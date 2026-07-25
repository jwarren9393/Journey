# Journey

A book-writing app for authors to craft their stories.

## Getting Started

### Prerequisites

- [Flutter](https://docs.flutter.dev/get-started/install) (stable channel)
- A device or emulator for your target platform

### Run the app

```bash
flutter pub get
flutter run
```

### Run tests

```bash
flutter test
```

## Project Structure

```
lib/
├── app/                 # App shell: MaterialApp, routing
├── core/                # Shared constants, theme, utilities
│   ├── constants/
│   └── theme/
├── features/            # Feature modules (books, editor, settings, etc.)
│   ├── home/
│   ├── books/
│   ├── editor/
│   └── settings/
├── shared/              # Shared widgets and components
└── main.dart
```

Each feature follows a layered structure:

- `presentation/` — UI (pages, widgets)
- `domain/` — business logic and models (add as features grow)
- `data/` — persistence and repositories (add as features grow)

## Roadmap

See [docs/ROADMAP.md](docs/ROADMAP.md) for phased development plans.

## License

Private project — not published to pub.dev.
