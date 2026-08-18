# Journey

A personal book-writing app for **Windows**, **Linux**, and **Android**. Write in a calm, distraction-friendly editor, organize your story with notes and outlines, and use built-in AI helpers when you want them — not as a chatbot bolted on the side.

**[Download the latest release](https://github.com/jwarren9393/Journey/releases/latest)** — Windows portable zip, Linux tarball, and Android APK. No account required for the app itself; AI features use your own API keys.

---

## Features

### Writing

- **Library** — multiple books with optional categories and filter chips
- **Chapters** — plain-text editor with auto-save (~2 seconds after you stop typing)
- **Focus mode** — fullscreen writing with larger text (desktop: `Ctrl+Shift+F`, exit with `Esc`)
- **Chapter sidebar** — quick chapter navigation on wide desktop (≥1100px)
- **Rename chapters** — from the editor title or app bar
- **Search** — find text within a book (titles + chapter bodies)
- **Export** — plain text or Markdown to Downloads/Documents (share sheet on mobile)

### Organization & planning

- **Book hub** — Chapters, Outline, and Notes tabs per book
- **Outline view** — drag-reorder chapters; per-chapter outline notes
- **Notes** — General, Research, Character, Place, Plot, Item, Group, History, and Idea types
- **Note status** — Spark (playing), Draft (developing), Canon (locked as true)
- **Tags** — per-book tags on notes; filter by type, status, tag, and search
- **Attachments** — optional local file on notes
- **Book description** — editable summary on the Chapters tab (also the Foundations “picture”)

### Appearance & desktop polish

- **Onboarding** — first-run welcome (skippable)
- **Theme** — system, light, or dark
- **Editor preferences** — font size and line spacing
- **Keyboard shortcuts** (Windows) — `Ctrl+,` settings, `Ctrl+/` help, `Ctrl+Shift+F` focus mode, `Ctrl+Shift+L` lore lookup in the editor
- **Local backup** — export/import all app data as JSON (Settings → Backup)

### AI assistant (optional)

AI is **off until you enable it** in Settings. You bring your own keys — data stays on your device except when you call an AI provider.

**Providers:** Google Gemini (AI Studio) or NanoGPT (includes **Auto**, remaining subscription allowance, and a searchable model catalog)

**Editor actions**

| Action | Description |
|--------|-------------|
| Continue writing | Next paragraph from cursor or chapter end |
| Rephrase / Expand / Tighten | Selection transforms (Rephrase, Expand, Sensory enhance return **multiple variants** to browse) |
| Show, don't tell | 3 showing alternatives for flat exposition |
| Scene paths | 6 beat ideas for what could happen next in a scene |
| Summarize chapter | Short recap for the author |
| Tone & voice meter | Compare chapter to a reference scene or voice description |
| Check continuity | Flag contradictions vs. worldbuilding notes |
| Fix continuity | Propose note updates — review before applying |
| Ask the world bible | Q&A over your notes (keyword-triggered lore when relevant) |
| Discover entities | Scan text → pre-filled character/place notes |

**Per-book AI context** (Chapters tab — manual edit or on-demand AI update)

| Item | Description |
|------|-------------|
| Author's note | Style guide injected into AI prompts (POV, tense, tone) |
| Canon summary | Running bullet facts; **Update from book/chapter** when you choose |

**Foundations / Story Lab** (book menu — start from nothing, then brainstorm)

| Action | Description |
|--------|-------------|
| Sparks | Generate 4 whole-world pictures; pick one, keep others as idea notes, or ask for more like one. Sparks and the vibe field stay when you leave. |
| The picture | Chosen spark becomes book description + canon + tone |
| Grow | Incrementally create character / place / group / item / history / plot / idea notes. Options and focus stay when you leave. |
| Opening scenes | 6 first-page ideas grounded in your picture and notes |
| Brainstorm chat | Freeform sandbox (only when you send). Messages and unsent draft persist. |
| Canon pins | Long-press your message to pin a fact |
| Scene ideas | Generate 6 scene starters |
| Glossary extract | Pull terms → pre-filled notes |
| Summarize brainstorm | Fold messages into editable Story Lab summary |
| Lore lookup | Search/filter notes from Story Lab or the editor (`Ctrl+Shift+L`) |

**Book & outline**

| Action | Where |
|--------|--------|
| AI recap | Book menu |
| Check continuity | Book menu / editor |
| Fix continuity | Book menu / editor |
| Update canon summary | Book menu / Chapters tab |
| Foundations / Story Lab | Book menu; empty chapter list |
| Ask the world bible | Book menu |
| Analyze pacing | Outline tab — heatmap labels (High Action, Dialogue Heavy, …) |
| Plot bridge | Outline tab — bridge ideas between chapters |
| Discover entities | Notes tab or editor |
| Blurb & pitch | Book menu or after export — tagline, hook, back-cover blurb, query pitch |

---

## Download & install

### Windows (portable)

1. Download `journey-windows-x64-build-*.zip` from [Releases](https://github.com/jwarren9393/Journey/releases).
2. Extract the zip to any folder (e.g. `D:\Apps\Journey`).
3. Run `journey.exe`.

**Requirements:** Windows 10/11 (64-bit). You may need the [Microsoft Visual C++ Redistributable](https://learn.microsoft.com/en-us/cpp/windows/latest-supported-vc-redist) if the app fails to start.

Your books are stored locally on that PC in the app’s data directory — copy the whole extracted folder if you move machines (or use Settings → Backup for JSON export).

### Android

1. Download `journey-android-build-*.apk` from [Releases](https://github.com/jwarren9393/Journey/releases).
2. Install the APK (enable “Install unknown apps” for your browser/files app if prompted).

**Note:** Release builds are currently signed with a debug key for convenience. For production distribution, use a proper signing key.

### Linux (portable)

1. Download `journey-linux-x64-build-*.tar.gz` from [Releases](https://github.com/jwarren9393/Journey/releases).
2. Extract anywhere (e.g. `~/Apps/Journey`).
3. Run `./journey` from the extracted folder.

**Requirements:** 64-bit Linux with GTK 3 (most desktop distros). If the app fails to start, install your distro’s GTK 3 runtime packages.

Your books stay in the app’s local data directory on that machine — use Settings → Backup for JSON export when moving systems.

### AI setup (optional)

1. Open **Settings → AI** and enable the assistant.
2. Choose **Google Gemini** or **NanoGPT**.
3. Add your API key. Journey saves the key and selected model on this device as you change them — you do not need a Save button.
4. NanoGPT: pick **Auto** or browse models (search, subscription-only, category, capability, sort). Remaining today / billing-period allowance and pay-as-you-go balance appear on that screen.

---

## Build from source

### Prerequisites

- [Flutter](https://docs.flutter.dev/get-started/install) (stable channel)
- **Windows:** Visual Studio Build Tools with “Desktop development with C++”
- **Linux:** GTK 3 dev packages (`libgtk-3-dev`, `cmake`, `ninja-build`, etc.)
- **Android:** Android SDK + JDK 17

### Commands

```bash
flutter pub get
flutter run                    # pick Windows, Linux, or Android device
flutter test
flutter analyze
```

**Release builds**

```bash
flutter build windows --release
# Output: build/windows/x64/runner/Release/  (zip this folder for portable distribution)

flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk

flutter build linux --release
# Output: build/linux/x64/release/bundle/  (tar.gz this folder for portable distribution)
```

**After Drift schema changes**

```bash
dart run build_runner build
```

### GitHub Releases (maintainers)

Pushing a **build tag** builds and publishes all release artifacts automatically:

```bash
# Bump only the build number in pubspec.yaml (e.g. 1.0.0+18), then:
git tag build-18
git push origin build-18
```

Release artifacts are named `journey-windows-x64-build-<N>.zip`, `journey-linux-x64-build-<N>.tar.gz`, and `journey-android-build-<N>.apk`. The app version shown to users stays **1.0.0**; the build number distinguishes releases.

See [.github/workflows/release.yml](.github/workflows/release.yml).

---

## Project structure

```
lib/
├── app/                 # MaterialApp, go_router
├── core/                # Database, AI, theme, backup, preferences
├── features/            # books, editor, onboarding, settings
├── shared/              # Shared widgets
└── main.dart
```

Each feature uses `domain/` (models, repos), `data/` (implementations), and `presentation/` (UI).

---

## Documentation

| Document | Audience | Purpose |
|----------|----------|---------|
| [docs/PROJECT_STATUS.md](docs/PROJECT_STATUS.md) | Agents | Current phase, changelog |
| [docs/PROJECT_REFERENCE.md](docs/PROJECT_REFERENCE.md) | Collaborators | Full technical reference |
| [docs/ROADMAP.md](docs/ROADMAP.md) | Everyone | Phased plan |
| [AGENTS.md](AGENTS.md) | Cursor agents | Required read/update protocol |

---

## Philosophy

Journey is a **personal, casual** writing app — not a commercial author platform. No word-count goals, streaks, or analytics dashboards unless you ask for them.

**Deferred / not yet:** rich text editor, cloud sync, secure API key storage (keys are in local preferences today).

---

## License

Private project — not published to pub.dev.
