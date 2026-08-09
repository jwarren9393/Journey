# Agent Instructions — Read First

**Every agent working on Journey must read this file before making changes.**

## Required reading order

1. **`docs/PROJECT_STATUS.md`** — current phase, what's done, what's next, recent changes
2. **`docs/PROJECT_REFERENCE.md`** — full project reference (update when you change behavior, structure, or features)
3. **`docs/ROADMAP.md`** — phased plan (update when phases complete or scope shifts)

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

- **Journey** — book-writing app for Android and Windows
- **Stack** — Flutter, Riverpod, go_router, Drift (SQLite), plain-text editor
- **AI** — contextual actions via Google Gemini and/or NanoGPT (user-provided keys)
- **Architecture** — feature-based clean architecture (`domain` / `data` / `presentation`)
- **Releases** — tag `v*` pushes GitHub Actions build (Windows zip + Android APK); see `README.md` and `.github/workflows/release.yml`

## Key commands

```bash
flutter pub get
dart run build_runner build    # after Drift schema changes
flutter analyze
flutter test
flutter run                    # pick Android or Windows device
flutter build windows --release
flutter build apk --release
```

## Conventions

- Match existing code style and folder structure
- Keep changes focused; don't expand scope without user request
- Domain models are plain Dart classes; repositories are abstract interfaces in `domain/`, implementations in `data/`
- New features go under `lib/features/<name>/`
