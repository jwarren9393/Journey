# Agent Instructions — Read First

**Every agent working on Journey must read this file before making changes.**

## Required reading order

1. **`docs/PROJECT_STATUS.md`** — current phase, what's done, what's next, recent changes
2. **`docs/PROJECT_REFERENCE.md`** — full project reference (update when you change behavior, structure, or features)
3. **`docs/ROADMAP.md`** — phased plan (update when phases complete or scope shifts)

## Versioning

Journey stays at **version 1.0.0**. Only the **build number** after `+` in `pubspec.yaml` increments (e.g. `1.0.0+17`). Do not bump the major/minor/patch version unless the user explicitly asks.

## Required after every session

Before finishing, update these living documents:

| Document | What to update |
|----------|----------------|
| `docs/PROJECT_STATUS.md` | Phase progress, completed items, next steps, changelog entry |
| `docs/PROJECT_REFERENCE.md` | Architecture, routes, screens, data models, dependencies, feature behavior |
| **`README.md`** | **User-facing features, download/install notes, AI action tables — whenever you add, remove, or materially change a feature visible to users** |

If you completed a roadmap item, check it off in `docs/ROADMAP.md`.

### README update rule

`README.md` is the public face of the repo (GitHub visitors and release downloaders). Keep it in sync with the app:

- **Do update** when adding/changing: screens, AI actions, settings, export/backup, keyboard shortcuts, platforms, or install/release process
- **Don't duplicate** deep implementation detail — that belongs in `PROJECT_REFERENCE.md`
- **Don't update** for internal refactors with no user-visible change
- Match the tone: personal casual writing app, optional AI with own API keys

## Project summary

- **Journey** — book-writing app for Android, Linux, and Windows
- **Stack** — Flutter, Riverpod, go_router, Drift (SQLite), plain-text editor
- **AI** — contextual actions via Google Gemini and/or NanoGPT (user-provided keys)
- **Architecture** — feature-based clean architecture (`domain` / `data` / `presentation`)
- **Releases** — tag `build-*` pushes GitHub Actions build (Windows zip + Linux tarball + Android APK); see `README.md` and `.github/workflows/release.yml`

## Key commands

```bash
# One-time setup on a fresh Linux PC (installs Flutter, JDK 17, Android SDK, gh):
bash scripts/setup_linux_dev.sh --github

flutter pub get
dart run build_runner build    # after Drift schema changes
dart run flutter_launcher_icons # after changing assets/icons/app_icon.png
flutter analyze
flutter test
flutter run                    # pick Android, Linux, or Windows device
flutter build windows --release
flutter build apk --release
./scripts/update_linux.sh      # build + install just the Linux desktop app
./deploy.sh "changelog message" # full deploy: checks + git push + APK + phone install + Linux desktop + GitHub Release
```

## Machine notes (this PC)

Main dev machine: **Linux Mint 22.3 Cinnamon** (`jay@jay-mint-laptop`). One idempotent command
installs everything (build tools, JDK 17, Flutter, Android SDK, GitHub CLI, Cursor's Dart path):

```bash
bash scripts/setup_linux_dev.sh --github    # --github connects your GitHub account too
```

| Tool | Status |
|------|--------|
| Flutter / Dart | **3.47.5** stable in `~/development/flutter` (Dart 3.13.4) |
| JDK | **Temurin 17** at `/usr/lib/jvm/temurin-17-jdk-amd64` |
| Android SDK | `~/Android/Sdk` — platform 36, build-tools 36.0.0, licences accepted |
| Linux desktop toolchain | clang / cmake / ninja / GTK 3 / libsqlite3 |
| GitHub CLI | signed in as `jwarren9393`; `gh auth setup-git` wires git push/pull |
| Cursor | Dart + Flutter extensions; `dart.flutterSdkPath` set by the setup script |
| Test phone | Samsung **SM-S731U** — USB *or* wireless debugging; `adb devices` should list it (e.g. `192.168.1.14:38613`) |

**Project home:** `~/Documents/App-Builds/Journey` (ext4) — keep exactly one working copy.

**⚠️ Never build from an exFAT/FAT drive** (USB stick, portable SSD, the Jay-Storage drive). exFAT
cannot store symlinks, and Flutter writes its plugin links as symlinks then **rethrows** when that
fails (`flutter_plugins.dart` → `handleSymlinkException` only covers Windows) — so `flutter pub get`,
`flutter test` and every build fail there. If a copy ever lands on such a drive, run
`bash scripts/dev_copy_linux.sh` in it first.

## Automation scripts

| Script | When | What it does |
|--------|------|--------------|
| `scripts/setup_linux_dev.sh [--github]` | once per Linux PC | installs the whole toolchain, writes PATH/`JAVA_HOME`/`ANDROID_HOME` (`~/.bashrc` + `~/.config/environment.d/50-flutter-dev.conf`), points Cursor at the SDK, optionally signs in to GitHub |
| `scripts/update_linux.sh [--pull]` | desktop app only | builds the Linux release and installs it to `~/.local/share/journey` with a menu entry |
| **`./deploy.sh "message"`** | **when you finish changes** | checks (`flutter analyze` + `flutter test`) → commit + push → build APK → install on phone → build + install Linux desktop → package artifacts → tag `build-N` → GitHub Release (then waits for the CI Windows zip) |
| `./deploy.sh --skip-checks "message"` | same, without the checks | use only deliberately |
| `scripts/dev_copy_linux.sh [target]` | source on exFAT | makes a buildable copy on an ext4 drive (default `~/Documents/App-Builds/Journey`) |

## Next actions

1. Fresh PC: `bash scripts/setup_linux_dev.sh --github`, then reopen the terminal and restart Cursor.
2. To ship everything at once: `./deploy.sh "what changed"` (phone + desktop + GitHub + CI Windows).
3. To just run it: `flutter run -d linux` (desktop) or `flutter run` with the phone connected (USB or wireless debugging).
4. AI keys (Gemini / NanoGPT) live in **Settings** on the device — they are never committed.

## Conventions

- Match existing code style and folder structure
- Keep changes focused; don't expand scope without user request
- Domain models are plain Dart classes; repositories are abstract interfaces in `domain/`, implementations in `data/`
- New features go under `lib/features/<name>/`
