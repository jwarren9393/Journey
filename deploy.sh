#!/usr/bin/env bash
set -e

# ==============================================================================
# Journey — One-Command Deploy
# ==============================================================================
# Builds Android APK + Linux desktop, installs to phone, updates local desktop
# copy, packages release artifacts, and pushes tag to trigger GitHub Actions CI
# (which builds Windows + publishes the release).
#
# Usage:
#   ./deploy.sh "optional changelog message"
#   ./deploy.sh --skip-checks "message"     skip flutter analyze + flutter test
# ==============================================================================

# ------------------------------------------------------------------------------
# Automatic value extraction
# ------------------------------------------------------------------------------

if [ ! -f "pubspec.yaml" ]; then
  echo "❌ Error: pubspec.yaml not found in current directory."
  echo "   Run this script from the Journey project root."
  exit 1
fi

FULL_VERSION=$(grep "^version:" pubspec.yaml | head -n1 | awk '{print $2}' | tr -d '\r')
VERSION=$(echo "$FULL_VERSION" | cut -d'+' -f1 | tr -d '\r')
BUILD_NUM=$(echo "$FULL_VERSION" | cut -d'+' -f2 | tr -d '\r')

if [ -z "$BUILD_NUM" ]; then
  echo "❌ Error: Could not parse build number from pubspec.yaml"
  exit 1
fi

PROJECT_ROOT="$(pwd)"
DEVICE_ID=$(adb devices | grep -w "device" | awk '{print $1}' | head -n1 | tr -d '\r')
DESKTOP_DIR="$HOME/.local/share/journey"
CHANGELOG=""
SKIP_CHECKS=0
for _arg in "$@"; do
  case "$_arg" in
    --skip-checks) SKIP_CHECKS=1 ;;
    *) [ -z "$CHANGELOG" ] && CHANGELOG="$_arg" ;;
  esac
done
CHANGELOG="${CHANGELOG:-Build ${BUILD_NUM} release update and improvements}"

echo "=================================================="
echo "🚀 Deploying Journey ${VERSION} (Build ${BUILD_NUM})"
echo "📱 Connected Device: ${DEVICE_ID:-None (Skipping phone install)}"
echo "💻 Desktop Target:   ${DESKTOP_DIR}"
echo "📝 Notes:            ${CHANGELOG}"
echo "=================================================="

# ==============================================================================
# 1. SANITY CHECKS — type-check + tests before anything ships
# ==============================================================================
if [ "$SKIP_CHECKS" = "1" ]; then
  echo -e "\n🔍 [1/6] Checks skipped (--skip-checks)."
else
  echo -e "\n🔍 [1/6] Running flutter analyze + flutter test..."
  flutter analyze || { echo "❌ flutter analyze failed — fix the issues, or re-run with --skip-checks."; exit 1; }
  flutter test    || { echo "❌ Tests failed — fix them, or re-run with --skip-checks."; exit 1; }
  echo "   ✅ Checks passed."
fi

# ==============================================================================
# 2. GIT COMMIT & PUSH (source code, no tag yet)
# ==============================================================================
echo -e "\n📦 [2/6] Syncing source code to GitHub..."
git add .
if git diff --staged --quiet; then
  echo "   No uncommitted code changes."
else
  git commit -m "Build ${BUILD_NUM}: ${CHANGELOG}"
fi
git push origin master
echo "   ✅ Source code pushed."

# ==============================================================================
# 2. BUILD ANDROID APK & INSTALL TO PHONE
# ==============================================================================
echo -e "\n📱 [3/6] Compiling Android Release APK..."
flutter build apk --release --build-name="$VERSION" --build-number="$BUILD_NUM"
cp build/app/outputs/flutter-apk/app-release.apk "journey-android-build-${BUILD_NUM}.apk"

if [ -n "$DEVICE_ID" ]; then
  echo "   Installing in-place onto device ($DEVICE_ID)..."
  if INSTALL_OUT=$(adb -s "$DEVICE_ID" install -r "journey-android-build-${BUILD_NUM}.apk" 2>&1); then
    echo "$INSTALL_OUT"
    echo "   ✅ Phone updated successfully!"
  else
    echo "$INSTALL_OUT"
    if echo "$INSTALL_OUT" | grep -q 'INSTALL_FAILED_UPDATE_INCOMPATIBLE'; then
      echo "   ⚠️ The app on the phone was signed with a different key."
      echo "      Journey's books live in app storage, so first open Journey on the phone and"
      echo "      export a backup (Settings → Backup), then:"
      echo "        adb -s $DEVICE_ID uninstall com.journey.journey"
      echo "      re-run ./deploy.sh, open Journey and import the backup."
      echo "      Every later update then installs in place."
    fi
    echo "   ⚠️ Phone install failed — continuing with the rest of the deploy."
  fi
else
  echo "   ⚠️ No ADB device found. Skipping physical phone install."
fi

# ==============================================================================
# 3. BUILD LINUX DESKTOP & UPDATE IN-PLACE
# ==============================================================================
echo -e "\n💻 [4/6] Compiling Linux Desktop Release..."
flutter build linux --release --build-name="$VERSION" --build-number="$BUILD_NUM"

echo "   Updating desktop application in-place..."
mkdir -p "$DESKTOP_DIR"
rsync -av --delete build/linux/x64/release/bundle/ "$DESKTOP_DIR/"
echo "   ✅ Desktop app updated in-place!"

# ==============================================================================
# 4. PACKAGE LINUX TARBALL FOR GITHUB RELEASE
# ==============================================================================
echo -e "\n🗜️  [5/6] Packaging Linux Release Tarball..."
LINUX_ARCHIVE="journey-linux-x64-build-${BUILD_NUM}.tar.gz"
tar czf "${LINUX_ARCHIVE}" -C build/linux/x64/release/bundle .
echo "   ✅ Created ${LINUX_ARCHIVE}"

# ==============================================================================
# 5. PUSH TAG & UPDATE GITHUB RELEASE
# ==============================================================================
echo -e "\n🌐 [6/6] Pushing tag and updating GitHub Release..."
TAG="build-${BUILD_NUM}"
RELEASE_TITLE="Journey ${VERSION} (build ${BUILD_NUM})"
RELEASE_BODY="Install the new APK over the existing app (do not uninstall first).

### What's new in build ${BUILD_NUM}
- ${CHANGELOG}"

# Push the tag to trigger GitHub Actions CI (builds Windows + publishes release)
git tag -f "$TAG"
git push origin "$TAG" --force
echo "   ✅ Tag ${TAG} pushed — CI is now building the Windows portable zip."

HAVE_GH=false
if command -v gh &> /dev/null; then
  HAVE_GH=true

  # Create/update the release immediately with locally built assets so the
  # Android APK and Linux tarball are available right away. CI will attach the
  # Windows zip when its build finishes (this machine can't build Windows).
  gh release edit "$TAG" --title "$RELEASE_TITLE" --notes "$RELEASE_BODY" 2>/dev/null || \
  gh release create "$TAG" --title "$RELEASE_TITLE" --notes "$RELEASE_BODY"

  # Upload local builds; --clobber lets CI overwrite later without conflict
  gh release upload "$TAG" "journey-android-build-${BUILD_NUM}.apk" "${LINUX_ARCHIVE}" --clobber 2>/dev/null || true
  echo "   ✅ Release created with Android APK + Linux tarball."
else
  echo "   ⚠️ GitHub CLI (gh) not found — the release will be published by CI with all three builds."
fi

# ==============================================================================
# 5b. WAIT FOR CI WINDOWS BUILD & CONFIRM RELEASE (optional, interruptible)
# ==============================================================================
echo ""
echo "   ⏳ Windows is built by GitHub Actions, not locally."
echo "      Waiting for the workflow to finish (usually ~10–12 min)..."
echo "      Press Ctrl+C to skip — the phone/desktop are already updated."

if [ "$HAVE_GH" = true ]; then
  REPO="jwarren9393/Journey"
  ATTACHED=false
  for _ in $(seq 1 120); do
    sleep 15

    # The workflow run for a tag push lists the tag name in the branch column.
    CONCLUSION=$(gh run list -R "$REPO" --branch "$TAG" --workflow Release --limit 1 \
      --json conclusion -q '.[0].conclusion' 2>/dev/null || true)
    if [ "$CONCLUSION" = "success" ]; then
      if gh release view "$TAG" -R "$REPO" --json assets -q '.[].name' 2>/dev/null |
          grep -q 'windows'; then
        ATTACHED=true
        break
      fi
    elif [ -n "$CONCLUSION" ] && [ "$CONCLUSION" != "null" ]; then
      echo "   ⚠️ CI finished with status: $CONCLUSION — see https://github.com/jwarren9393/Journey/actions"
      break
    fi
  done

  echo ""
  if [ "$ATTACHED" = true ]; then
    echo "   ✅ Windows portable zip is attached to the release!"
    echo "      https://github.com/jwarren9393/Journey/releases/tag/${TAG}"
  else
    echo "   ⚠️ Windows build not confirmed (still running or you pressed Ctrl+C)."
    echo "      It will appear when CI finishes: https://github.com/jwarren9393/Journey/actions"
  fi
else
  echo "   ⚠️ Cannot verify the release without GitHub CLI (gh)."
  echo "      CI will publish it automatically: https://github.com/jwarren9393/Journey/actions"
fi

echo ""
echo "🎉 ALL DONE! Phone updated, desktop updated, and release published!"
echo ""
echo "   Release page: https://github.com/jwarren9393/Journey/releases/tag/${TAG}"