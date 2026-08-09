# Journey

A personal book-writing app for **Windows** and **Android**. Write in a calm, distraction-friendly editor, organize your story with notes and outlines, and use built-in AI helpers when you want them — not as a chatbot bolted on the side.

**[Download the latest release](https://github.com/jwarren9393/Journey/releases/latest)** — Windows portable zip and Android APK. No account required for the app itself; AI features use your own API keys.

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
- **Notes** — General, Research, Character, Place, and Plot types
- **Tags** — per-book tags on notes
- **Attachments** — optional local file on notes
- **Book description** — editable summary on the Chapters tab

### Appearance & desktop polish

- **Onboarding** — first-run welcome (skippable)
- **Theme** — system, light, or dark
- **Editor preferences** — font size and line spacing
- **Keyboard shortcuts** (Windows) — `Ctrl+,` settings, `Ctrl+/` help, `Ctrl+Shift+F` focus mode
- **Local backup** — export/import all app data as JSON (Settings → Backup)

### AI assistant (optional)

AI is **off until you enable it** in Settings. You bring your own keys — data stays on your device except when you call an AI provider.

**Providers:** Google Gemini (AI Studio) or NanoGPT

**Editor actions**

| Action | Description |
|--------|-------------|
| Continue writing | Next paragraph from cursor or chapter end |
| Rephrase / Expand / Tighten | Selection transforms |
| Sensory enhance | Rewrite with sight, sound, smell, etc. |
| Show, don't tell | 2–3 showing alternatives for flat exposition |
| Summarize chapter | Short recap for the author |
| Tone & voice meter | Compare chapter to a reference scene or voice description |
| Check continuity | Flag contradictions vs. worldbuilding notes |
| Ask the world bible | Q&A over your notes |
| Discover entities | Scan text → pre-filled character/place notes |

**Book & outline**

| Action | Where |
|--------|--------|
| AI recap | Book menu |
| Check continuity | Book menu |
| Ask the world bible | Book menu |
| Analyze pacing | Outline tab — heatmap labels (High Action, Dialogue Heavy, …) |
| Plot bridge | Outline tab — bridge ideas between chapters |
| Discover entities | Notes tab or editor |
| Blurb & pitch | Book menu or after export — tagline, hook, back-cover blurb, query pitch |

---

## Download & install

### Windows (portable)

1. Download `journey-windows-x64-*.zip` from [Releases](https://github.com/jwarren9393/Journey/releases).
2. Extract the zip to any folder (e.g. `D:\Apps\Journey`).
3. Run `journey.exe`.

**Requirements:** Windows 10/11 (64-bit). You may need the [Microsoft Visual C++ Redistributable](https://learn.microsoft.com/en-us/cpp/windows/latest-supported-vc-redist) if the app fails to start.

Your books are stored locally on that PC in the app’s data directory — copy the whole extracted folder if you move machines (or use Settings → Backup for JSON export).

### Android

1. Download `journey-android-*.apk` from [Releases](https://github.com/jwarren9393/Journey/releases).
2. Install the APK (enable “Install unknown apps” for your browser/files app if prompted).

**Note:** Release builds are currently signed with a debug key for convenience. For production distribution, use a proper signing key.

### AI setup (optional)

1. Open **Settings → AI** and enable the assistant.
2. Choose **Google Gemini** or **NanoGPT**.
3. Add your API key and model ([Google AI Studio](https://aistudio.google.com/apikey) for Gemini).

---

## Build from source

### Prerequisites

- [Flutter](https://docs.flutter.dev/get-started/install) (stable channel)
- **Windows:** Visual Studio Build Tools with “Desktop development with C++”
- **Android:** Android SDK + JDK 17

### Commands

```bash
flutter pub get
flutter run                    # pick Windows or Android device
flutter test
flutter analyze
```

**Release builds**

```bash
flutter build windows --release
# Output: build/windows/x64/runner/Release/  (zip this folder for portable distribution)

flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

**After Drift schema changes**

```bash
dart run build_runner build
```

### GitHub Releases (maintainers)

Pushing a version tag builds and publishes both artifacts automatically:

```bash
git tag v1.6.0
git push origin v1.6.0
```

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
