# Journey — Full Project Reference

> **Living document for Gemini / NotebookLM / external collaborators.**  
> Upload this file to give full project context. Agents must update it whenever code, structure, or behavior changes.

**Last updated:** 2026-08-23  
**Version:** 1.0.0 (build 29 in `pubspec.yaml`)

---

## 1. Product overview

**Journey** is a **personal, casual** book-writing app for **Android**, **Linux**, and **Windows** — not a commercial author platform. An **AI assistant is woven into features** through contextual actions (continue writing, rephrase, recap, promote brainstorm to lore, etc.), not an always-on chat panel.

**Current maturity:** Personal writing app with optional user-initiated AI, Foundations (start from scratch → picture → grow notes), notes/worldbuilding with promote/deepen/retire workflows, outline planning, Story Lab, triggered lore, cross-screen workflow links, and desktop polish.

**Primary user flow:**
1. Open app → Library
2. Create a book
3. Add chapters
4. Write in the editor (auto-saves every ~2 seconds after typing stops)
5. Use AI actions (continue, rephrase, recap, etc.) from editor or book detail
6. Configure providers in Settings (Google AI Studio key and/or NanoGPT key)
7. Return later — data persists locally

---

## 2. Tech stack

| Layer | Technology |
|-------|------------|
| Framework | Flutter (Dart SDK ^3.12.2) |
| UI | Material 3, custom literary theme |
| State | flutter_riverpod ^2.6 |
| Routing | go_router ^17 |
| Database | drift ^2.34 + drift_flutter + sqlite3_flutter_libs |
| Local settings | shared_preferences |
| AI (Google) | google_generative_ai + HTTP |
| AI (NanoGPT) | http (OpenAI-compatible API) |
| External links | url_launcher |
| Export / share | share_plus |
| IDs | uuid |
| Code generation | drift_dev, build_runner |

**Target platforms:** Android, Linux, Windows (iOS/macOS/web folders exist but are not prioritized for releases).

> **Android system bars:** Journey targets SDK 36, so Android 15+ edge-to-edge is enforced. `main.dart` enables `SystemUiMode.edgeToEdge` with transparent bars, and the `MaterialApp` builder wraps the router in a bottom `SafeArea` (`_SystemBarsSync` in `lib/app/app.dart`) so content never sits behind the system navigation bar. System bar icon brightness follows the active theme.

> **Android requirement:** The release manifest (`android/app/src/main/AndroidManifest.xml`) must declare `<uses-permission android:name="android.permission.INTERNET"/>` for AI API calls. Debug and profile manifests include it automatically.

---

## 3. Architecture

Feature-based **clean architecture** with three layers per feature:

```
lib/features/<feature>/
  domain/        — models, repository interfaces
  data/          — repository implementations
  presentation/  — pages, widgets, Riverpod providers
```

Shared infrastructure lives in `lib/core/` and `lib/shared/`.

```
lib/
├── main.dart                          # Entry: ProviderScope, SharedPreferences init
├── app/
│   ├── app.dart                       # MaterialApp.router
│   └── router.dart                    # go_router routes + routerProvider
├── core/
│   ├── ai/
│   ├── constants/
│   ├── data/                          # BackupService
│   ├── database/
│   ├── preferences/                   # AppPreferences + repository
│   ├── providers/
│   ├── theme/
│   └── utils/
├── features/
│   ├── books/
│   ├── editor/
│   ├── onboarding/                    # First-run welcome
│   └── settings/
└── shared/widgets/                    # AppShell, EmptyState, dialogs
```

---

## 4. Data model

### Book
| Field | Type | Notes |
|-------|------|-------|
| id | String (UUID) | Primary key |
| title | String | Required |
| description | String | Optional, default empty |
| category | String | Optional casual grouping |
| authorsNote | String | Per-book AI style guide (Phase 6) |
| canonSummary | String | Running canon bullets (Phase 6) |
| storyLabSummary | String | Folded Story Lab summary (Phase 6) |
| storyLabDraft | String | JSON: Foundations sparks/prompts + brainstorm composer (not the picture) |
| createdAt | DateTime | |
| updatedAt | DateTime | Updated on save |

### Chapter
| Field | Type | Notes |
|-------|------|-------|
| id | String (UUID) | Primary key |
| bookId | String | FK → Book |
| title | String | Required |
| content | String | Plain text body |
| outlineSummary | String | Short planning note for outline tab |
| sortOrder | int | 0-based display order |
| createdAt | DateTime | |
| updatedAt | DateTime | Updated on auto-save |

**Deferred:** Scene entity (chapters only for now).

### BookNote
| Field | Type | Notes |
|-------|------|-------|
| id | String (UUID) | Primary key |
| bookId | String | FK → Book |
| type | NoteType | general, research, character, location, plot, item, group, history, idea |
| status | NoteStatus | spark, draft, canon (default canon for migrated rows; new notes default draft) |
| title | String | Required |
| content | String | Plain text |
| attachmentPath | String | Optional local file path |
| loreKeywords | String | Comma-separated trigger keywords (Phase 6) |
| loreAlwaysInclude | bool | Include in AI context when AI runs (Phase 6) |
| lorePriority | int | 0–10, higher included first (Phase 6) |
| chronologyOrder | double? | Optional timeline sort (History/Plot; Phase 9) |
| era | String | Optional era label (Phase 9) |
| sortOrder | int | Display order |
| tags | List<BookTag> | Via junction table |

### BookTag
| Field | Type | Notes |
|-------|------|-------|
| id | String (UUID) | Primary key |
| bookId | String | FK → Book |
| name | String | Tag label (per book) |

### NoteRelationship (Phase 9)
| Field | Type | Notes |
|-------|------|-------|
| id | String | UUID |
| bookId | String | FK → Book |
| sourceNoteId | String | FK → BookNote |
| targetNoteId | String | FK → BookNote |
| relationshipType | String | Ally, Enemy, Rival, Family, Betrayer, etc. |
| description | String | Optional context |
| createdAt / updatedAt | DateTime | |

### CanonPin (Phase 6)
| Field | Type | Notes |
|-------|------|-------|
| id | String | UUID |
| bookId | String | FK → Book |
| text | String | Canon fact pinned from Story Lab |

### StoryLabMessage (Phase 6)
| Field | Type | Notes |
|-------|------|-------|
| id | String | UUID |
| bookId | String | FK → Book |
| role | String | `user` or `assistant` |
| content | String | Message body |
| createdAt | DateTime | |

### Database
- **Engine:** SQLite via Drift
- **File:** `journey` (managed by drift_flutter)
- **Schema version:** 6
- **Backup format:** 5
- **Tables:** `books_table`, `chapters_table`, `book_notes_table`, `book_tags_table`, `book_note_tags_table`, `canon_pins_table`, `story_lab_messages_table`, `note_relationships_table`
- **Cascade:** Deleting a book deletes chapters, notes, tags, and relationships; deleting a note deletes its relationships

---

## 5. Repositories

### BookRepository
- `watchAll()` → Stream<List<Book>> (ordered by updatedAt desc)
- `getById(id)`
- `create(title, description?)`
- `update(book)`
- `delete(id)` — also deletes chapters

### ChapterRepository
- `watchByBookId(bookId)` → Stream<List<Chapter>> (ordered by sortOrder)
- `getById(id)`
- `create(bookId, title, content?)`
- `update(chapter)` — includes `outlineSummary`
- `reorderChapters(bookId, chapterIdsInOrder)`
- `delete(id)`

### NoteRepository
- `watchByBookId(bookId, {type?})` → Stream<List<BookNote>>
- `getById(id)`, `create(..., status: draft)`, `update(note)`, `delete(id)`
- Client-side `NoteSearch.filter` for query / type / status / tag / sort

### TagRepository
- `watchByBookId(bookId)`
- `getOrCreate(bookId, name)`
- `setTagsForNote(noteId, tagIds)`
- `delete(id)`

### StoryLabRepository
- `watchByBookId(bookId)` → brainstorm messages
- `addMessage`, `clearMessages`
- `getDraft` / `saveDraft` — Foundations sparks/prompts and unsent brainstorm text (`books.story_lab_draft`)

---

## 6. Navigation and screens

### App shell
- **Wide screens (≥800px):** NavigationRail — Library | Settings
- **Narrow screens:** Bottom NavigationBar — Library | Settings
- **Global shortcuts:** Ctrl+, → Settings; Ctrl+/ → shortcuts dialog
- Book detail and editor are full-screen (outside shell)

### Onboarding (`/onboarding`)
- Shown on first launch until completed or skipped
- Three-step welcome explaining writing, focus/export, and optional AI
- Stored in SharedPreferences (`onboarding_completed`)

### Library (`/books`)
- Lists all books as cards with optional **category filter chips**
- Shows title, description, category, or last updated
- **Actions:** Tap → book detail; FAB → create book; menu → delete book

### Book detail (`/books/:bookId`) — tabbed hub
- **Chapters tab:** description card, chapter list, FAB for new chapter; empty state opens Story Lab (**Continue Foundations** / **Start from scratch** from draft progress — no duplicate New chapter button)
- **Outline tab:** drag-reorder chapters, per-chapter outline notes, tap to open editor; **Analyze pacing** heatmap (color-coded chips); **Plot bridge** ideas on middle chapters (alt-route icon)
- **Notes tab:** search; filter by type/status/tag; sort; create notes with tags/attachments
- App bar: search, menu (continuity, Foundations / Story Lab, Promote Story Lab to lore, update canon, world bible, recap, edit, export, blurb)

### Note editor (`/books/:bookId/notes/:noteId`)
- Title, type, status (spark/draft/canon), content with auto-save
- Tags (create or pick existing per book)
- Optional file attachment (local path via file picker)
- Lore keywords, always-include, priority
- Menu: Deepen with AI (review-before-apply), Open Story Lab, Retire as spark (demote to Idea / Spark)

### Foundations / Story Lab (`/books/:bookId/story-lab`)
- **Foundations tab:** sparks → commit picture → grow notes; opening scene ideas; lore lookup. Sparks, grow options, and prompts persist when you leave the screen.
- **Brainstorm tab:** chat (saved in SQLite), unsent composer draft, canon pins; menu: Promote to lore, scene ideas, glossary, summarize, clear messages
- After Promote to lore applies, optional clear of brainstorm messages (pins + summary kept)
- `?tab=brainstorm` opens Brainstorm

### Book search (`/books/:bookId/search`)
- Search bar filters chapter titles and body text within one book
- Results show chapter title + content snippet
- Tap result → opens chapter in editor

### Editor (`/books/:bookId/chapters/:chapterId`)
- **Focus mode** (fullscreen icon or Ctrl+Shift+F): hides chrome, larger text, immersive UI; exit button or Esc (desktop)
- **Wide desktop (≥1100px):** chapter list sidebar; **≥1400px:** lore lookup panel
- Lore lookup sheet from book icon or `Ctrl+Shift+L`
- Story Lab brainstorm from science icon or `Ctrl+Shift+B`
- Respects appearance preferences (font size, line spacing)
- Chapter rename via title tap or rename icon
- AI menu: continue, rephrase, expand, tighten, sensory enhance, show don't tell, summarize, tone & voice meter, scene paths, continuity check/fix, world bible, discover entities, Promote chapter to lore; auto-save; save status
- No word count display (keeps the editor casual, not metric-driven)

### Settings (`/settings`) — tabbed
- **Appearance:** theme mode; background + highlight color presets; app-wide UI text scale; editor font size and line spacing with live preview
- **Backup:** export all data to JSON (Downloads/Documents; share sheet on mobile); restore from JSON (replaces all local data)
- **AI:** enable toggle, provider, keys (auto-saved locally), Google model picker, NanoGPT Auto + searchable catalog with stats/filters, remaining subscription allowance and balance
- Keyboard shortcuts dialog (toolbar icon or Ctrl+/)

**Important:** Google Gemini consumer app / Google One AI subscription is separate from the Gemini API. Users need an API key from AI Studio.

---

## 7. AI system

### Design principles
- User-initiated actions, not always-on chat
- Scoped context (selection, chapter, book metadata)
- Async, non-blocking
- Dual provider support: user picks active provider in Settings

### Providers

| Provider | Auth | Endpoint | Models |
|----------|------|----------|--------|
| **Google Gemini** | AI Studio API key | `google_generative_ai` SDK | Fetched via Gemini API or defaults (2.5 Flash, 2.5 Pro, etc.) |
| **NanoGPT** | API key (Bearer) | `POST https://nano-gpt.com/api/v1/chat/completions` | `GET /api/v1/models?detailed=true` + subscription catalog; **Auto** is `auto-model`. Usage: `GET /api/subscription/v1/usage`, balance: `POST /api/check-balance` |

### Files
| File | Purpose |
|------|---------|
| `ai_service.dart` | `AiService` + `JourneyAiService` (routes to active provider) |
| `clients/google_gemini_client.dart` | Gemini generateContent + listModels |
| `clients/nanogpt_client.dart` | Chat completions, full catalog + Auto, usage/balance |
| `ai_context.dart` | `AiContext`, `AiAction`, `AiResult`, `SensorySense` |
| `ai_book_actions.dart` | Shared runners: continuity, world bible, entities, canon update, **promote to lore**, **deepen note** |
| `note_context_service.dart` | Keyword note retrieval for AI context |
| `ai_export_actions.dart` | Blurb & pitch generator runner |
| `ai_outline_actions.dart` | Outline pacing heatmap + plot bridge runners |
| `pacing_label_parser.dart` | Parse pacing JSON from AI |
| `extracted_entity_parser.dart` | Parse entity-discovery JSON from AI |
| `continuity_fix_parser.dart` | Parse note-update JSON for Fix continuity |
| `lore_proposal_parser.dart` | Parse create/update/retire JSON for Promote / Deepen |
| `ai_provider_config.dart` | `AiProvider` (none, google, nanoGpt), dual key storage |
| `prompt_templates.dart` | System instruction + per-action prompts |
| `models/ai_model_option.dart` | `AiModelOption`, `AiModelGroup` |
| `models/nanogpt_account.dart` | NanoGPT usage, remaining credits, balance |
| `models/lore_proposal.dart` | `LoreProposal` / `LoreProposalKind` |
| `nanogpt_model_filters.dart` | Auto model + catalog search/filter/sort |
| `shared/widgets/lore_proposal_sheet.dart` | Review-before-apply UI for lore proposals |
| `shared/widgets/continuity_fix_sheet.dart` | Review-before-apply UI for continuity fixes |

### AiAction types (implemented in UI)
- `continueWriting` — editor menu
- `rephrase` — editor menu (requires selection)
- `expand` — editor menu (requires selection)
- `tighten` — editor menu (requires selection)
- `sensoryEnhance` — editor menu (requires selection; sense picker dialog)
- `showDontTell` — editor menu (requires selection; returns 2–3 options)
- `summarizeChapter` — editor menu
- `toneVoiceMeter` — editor menu (reference chapter or voice persona dialog; read-only analysis)
- `continuityCheck` — editor menu / book detail menu (chapter + notes; read-only)
- `extractEntities` — editor menu / Notes tab (entity discovery sheet → create note)
- `askWorldBible` — editor menu / book detail menu (question dialog + keyword-matched notes)
- `pacingHeatmap` — Outline tab (batch labels; color-coded chips)
- `plotBridge` — Outline tab (middle chapters; 3 bridge concepts)
- `blurbPitchGenerator` — book detail menu / post-export snackbar (tagline, hook, blurb, query pitch)
- `fixContinuity` — editor / book menu (review-before-apply note updates)
- `updateCanonSummary` — Chapters tab / book menu (on-demand)
- `scenePaths` — editor menu (6 beat ideas)
- `storyLabBrainstorm` — Story Lab Send button
- `storyLabSceneIdeas` — Story Lab menu
- `storyLabGlossary` — Story Lab menu → extract entities sheet
- `storyLabSummarize` — Story Lab menu → save storyLabSummary
- `foundationsSparks` — Foundations: 4 world portraits (JSON)
- `foundationsGrow` — Foundations: 3 named pieces to keep as notes (JSON)
- `foundationsOpeningScenes` — Foundations: 6 first-page ideas
- `promoteToLore` — Story Lab / book menu / editor: create/update/retire notes (review sheet)
- `deepenNote` — Note editor: deepen focus note + related proposals (review sheet)
- `interrogateLore` — Note editor: 3–4 probing questions; optional append to note
- `evolveWorldState` — Editor: update world state from chapter (notes + relationship link/unlink; review sheet)
- `recapBook` — book detail app bar

### Settings storage keys (SharedPreferences)
**App preferences:**
- `theme_mode` — ThemeMode index
- `background_preset` — parchment / ink / slate / crimson / forest
- `accent_preset` — gold / yellow / red / amber / cyan / lime / white
- `ui_font_scale` — double (default 1.0; clamped 0.85–2.0)
- `editor_font_size` — double (default 16)
- `editor_line_height` — double (default 1.6)
- `onboarding_completed` — bool

**AI settings:**
- `ai_provider_name` — `none`, `google`, `nanoGpt`
- `ai_enabled`
- `google_api_key`, `google_model`
- `nanogpt_api_key`, `nanogpt_model` (default picker includes `auto-model`)
- `nanogpt_subscription_only` — bool, model picker filter
- Legacy keys (`ai_provider`, `ai_api_key`, `ai_model`) migrated on load
- AI settings auto-save on change; leaving the screen no longer wipes unsaved fields

---

## 8. Riverpod providers

| Provider | Type | Purpose |
|----------|------|---------|
| `appPreferencesProvider` | AsyncNotifierProvider | Theme, editor prefs, onboarding |
| `backupServiceProvider` | Provider<BackupService> | JSON export/import |
| `databaseProvider` | Provider<AppDatabase> | Singleton DB, disposed on scope dispose |
| `bookRepositoryProvider` | Provider<BookRepository> | |
| `chapterRepositoryProvider` | Provider<ChapterRepository> | |
| `sharedPreferencesProvider` | Provider<SharedPreferences> | Overridden in main() |
| `aiSettingsRepositoryProvider` | Provider<AiSettingsRepository> | |
| `aiSettingsProvider` | AsyncNotifierProvider | Loads/saves AI config |
| `aiServiceProvider` | Provider<AiService> | `JourneyAiService` |
| `googleGeminiClientProvider` | Provider | Gemini API client |
| `nanoGptClientProvider` | Provider | NanoGPT API client |
| `googleModelsProvider` | FutureProvider.family | Gemini models by API key |
| `nanoGptModelsProvider` | FutureProvider.family | NanoGPT catalog + Auto by API key |
| `nanoGptAccountProvider` | FutureProvider.family | NanoGPT usage/balance by API key |
| `aiActionRunnerProvider` | Provider | Convenience wrapper for AI calls |
| `routerProvider` | Provider<GoRouter> | |
| `booksStreamProvider` | StreamProvider<List<Book>> | |
| `bookProvider` | FutureProvider.family | By book ID |
| `chaptersStreamProvider` | StreamProvider.family | By book ID |
| `chapterProvider` | FutureProvider.family | By chapter ID |
| `storyLabDraftProvider` | AsyncNotifierProvider.family | Foundations + brainstorm composer draft |

---

## 9. Theme

Configurable literary palette in `core/theme/appearance_palette.dart` (wired through Settings → Appearance):

- **Backgrounds:** parchment (default), ink, slate, crimson, forest — each resolves for light and dark
- **Highlights:** gold (default), yellow, red, amber, cyan, lime, white — used for primary / FAB / filled buttons
- Legacy named constants remain in `app_colors.dart` for any direct call sites

Material 3 with `useMaterial3: true`. Theme mode, background, and accent come from app preferences. App-wide UI text scale uses `MediaQuery.textScaler` (up to 200%). Body text themes are bumped for reading; AI prose (sparks, grow cards, brainstorm, result/proposal sheets) uses `appReadingStyle` (`bodyLarge` + 1.5 line height). Editor font size and line height stay separate from the UI scale.

---

## 10. Feature catalog (plain map for agents)

Use this section as the authoritative inventory of **shipped** user-facing capabilities.

### Writing & library
| Feature | Where | Notes |
|---------|-------|-------|
| Multi-book library | `/books` | Category filter chips; create/delete |
| Chapters | Book hub → Chapters | Auto-save in editor (~2s debounce) |
| Focus mode | Editor | `Ctrl+Shift+F` / Esc |
| Chapter sidebar | Editor ≥1100px | Jump between chapters |
| Rename chapter | Editor title / icon | |
| Search chapters | `/books/:id/search` | Titles + body |
| Export plain / Markdown | Book menu | Downloads/Documents; share on mobile |
| Onboarding | `/onboarding` | First-run; skippable |
| Theme / font / colors | Settings → Appearance | Background + highlight presets; UI scale + editor typography |
| Local backup JSON | Settings → Backup | Format v5; replaces all data on restore |
| Keyboard shortcuts | Settings / `Ctrl+/` | Also editor lore/Story Lab shortcuts |

### Organization & worldbuilding
| Feature | Where | Notes |
|---------|-------|-------|
| Notes | Book hub → Notes | Types: General, Research, Character, Place, Plot, Item, Group, History, Idea |
| Note scaffolding | New note / note editor | Templates for character, group, location, item, history, plot |
| Note status | Note editor | Spark / Draft / Canon; sparks excluded from writing AI unless always-include |
| Tags | Notes | Per-book tags; filter/sort/search |
| Attachments | Note editor | Stores local path (not copied into app DB) |
| Lore triggers | Note editor | Keywords, always-include, priority 0–10 |
| Relationships | Notes tab + note editor | Directed links (Ally, Enemy, …); add/edit/delete dialog |
| Timeline | Notes tab | History/Plot notes sorted by chronologyOrder / era |
| Lore lookup | Editor panel/sheet; Story Lab | `Ctrl+Shift+L` |
| Author's note | Chapters tab | Style guide injected into AI |
| Canon summary | Chapters tab / book menu | Manual or on-demand AI update |
| Outline reorder + notes | Outline tab | Drag-reorder; per-chapter outlineSummary |
| Retire as spark | Note editor menu | Soft archive → Idea / Spark |
| Interrogate lore | Note editor | Socratic questions; optional append |
| Update world state | Editor AI menu | Chapter → note/relationship proposals (review) |

### Foundations & Story Lab
| Feature | Where | Notes |
|---------|-------|-------|
| Sparks | Story Lab → Foundations | 4 portraits; commit picture; keep as idea |
| Grow | Foundations | Incremental named pieces → notes |
| Opening scenes | Foundations | 6 first-page ideas |
| Brainstorm chat | Story Lab → Brainstorm | Persisted messages; Send runs AI |
| Canon pins | Brainstorm | Long-press user message |
| Scene ideas / glossary / summarize | Brainstorm menu | Glossary → create notes sheet |
| Promote to lore | Brainstorm / book / editor | Review create/update/retire; optional clear chat |
| Draft persistence | Foundations + composer | `books.story_lab_draft` JSON |

### Contextual AI (writing)
| Feature | Where | Review? |
|---------|-------|---------|
| Continue / rephrase / expand / tighten | Editor | Inline / result sheet |
| Sensory enhance / show don't tell | Editor (selection) | Variants pager |
| Summarize chapter / scene paths / tone meter | Editor | Result sheet |
| Continuity check | Editor / book | Read-only |
| Fix continuity | Editor / book | **Yes** — note updates |
| Ask world bible | Editor / book | Q&A |
| Discover entities | Editor / Notes | Create notes sheet |
| Promote chapter to lore | Editor | **Yes** — create/update/retire |
| Update world state | Editor | **Yes** — notes + link/unlink |
| Deepen note | Note editor | **Yes** — proposals |
| Interrogate lore | Note editor | Questions (optional append) |
| Pacing heatmap / plot bridge | Outline | Labels / ideas |
| Blurb & pitch | Book menu / post-export | Marketing copy |
| Book recap | Book menu | Summary |

### Workflow links (integration)
| From | To | How |
|------|----|-----|
| Editor | Lore lookup | Icon / `Ctrl+Shift+L` |
| Editor | Story Lab brainstorm | Icon / `Ctrl+Shift+B` |
| Editor | Notes (new) | Discover entities → open note |
| Note editor | Story Lab | Menu → Open Story Lab |
| Note editor | Lore updates | Deepen with AI / Retire as spark |
| Story Lab | Notes | Promote to lore / glossary / grow |
| Book hub | Story Lab / Promote | App bar menu |
| Empty chapters/notes | Story Lab | Empty-state CTAs |

### AI policy (non-negotiable)
- All AI is **user-initiated** (menu, button, or Send)
- App works fully offline with AI disabled
- No background AI, no auto-summarize on save, no passive checking while typing
- Destructive-ish note changes use **review-before-apply**

### Platforms & releases
| Platform | Artifact |
|----------|----------|
| Windows | `journey-windows-x64-build-<N>.zip` |
| Linux | `journey-linux-x64-build-<N>.tar.gz` |
| Android | `journey-android-build-<N>.apk` |

Tag `build-*` triggers `.github/workflows/release.yml`. App version stays `1.0.0`; build number after `+` increments.

---

## 11. AI features history (phases)

**Phases 1–4:** Continue, rephrase, expand, tighten, summarize chapter, book recap; focus/search/export; notes/outline; polish/backup.

**Phase 5 — Contextual AI:** sensory, show-don't-tell, tone meter, continuity, entities, world bible, pacing, plot bridge, blurb — **done**.

**Phase 6 — Grounded memory:** author's note, canon summary, triggered lore, fix continuity, variants, scene paths, Story Lab — **done**.

**Phase 7 — Foundations:** sparks → picture → grow; note status; lore lookup; draft persistence — **done**.

**Phase 8 — Lore collaboration loop:** promote brainstorm/chapter → structured lore (create/update/retire); deepen note; cross-screen workflow links — **done** (build 25).

**Phase 9 — Dynamic World Bible:** note scaffolding; relationships matrix; chronology/era; interrogateLore; evolveWorldState — **done** (build 26). Schema v6 / backup v5.

**Phase 5 technical direction (still valid):** `NoteContextService` keyword matching; optional local embeddings later.

---

## 12. Dependencies (pubspec.yaml)

**Runtime:** flutter, cupertino_icons, flutter_riverpod, go_router, drift, drift_flutter, sqlite3_flutter_libs, path_provider, uuid, shared_preferences, http, google_generative_ai, url_launcher, share_plus, file_picker

**Dev:** flutter_test, flutter_lints, drift_dev, build_runner, flutter_launcher_icons

**App icon:** Source `assets/icons/app_icon.png` (1024×1024). Regenerate platform icons with `dart run flutter_launcher_icons`.

---

## 13. Build and development

```bash
flutter pub get
dart run build_runner build    # Regenerate app_database.g.dart after schema changes
dart run flutter_launcher_icons # Regenerate Android/Windows icons after changing app_icon.png
flutter run                    # Android emulator or Windows/Linux desktop
flutter build apk              # Android release
flutter build windows          # Windows release
flutter build linux            # Linux release
flutter test
flutter analyze
```

`.dart_tool/` and `/build/` are gitignored. After a fresh clone, OS reinstall, or moving the repo to a new drive letter, run `flutter pub get`. If Windows debug fails with a CMake path mismatch (`F:` vs `D:`), run `flutter clean` then debug again.

**Android:** `com.journey.journey`, Kotlin MainActivity, Gradle 9.x  
**Linux:** `journey` binary, GTK 3, CMake; release bundle at `build/linux/x64/release/bundle/`  
**Windows:** `journey.exe`, CMake, default 1280×720 window  

**GitHub Releases** (tag `build-*`): `journey-windows-x64-build-<N>.zip`, `journey-linux-x64-build-<N>.tar.gz`, `journey-android-build-<N>.apk` — see `.github/workflows/release.yml`.

---

## 14. Testing

- `test/widget_test.dart` — smoke test: app loads library empty state (onboarding skipped via mock prefs)
- Overrides `booksStreamProvider` in tests to avoid DB stream timing issues

---

## 15. Documentation files

| File | Audience | Purpose |
|------|----------|---------|
| `AGENTS.md` | Cursor agents | Read-first instructions |
| `docs/PROJECT_STATUS.md` | Agents | Current phase, changelog, next steps |
| `docs/PROJECT_REFERENCE.md` | Gemini / collaborators | This file — full reference |
| `docs/ROADMAP.md` | Everyone | Phased plan |

**All agents must update PROJECT_STATUS and PROJECT_REFERENCE when making changes.**

---

## 16. Open questions

- Secure storage for API keys (currently SharedPreferences)
- Markdown vs rich text editor (plain text for now)
- Scene-level structure within chapters
- Cloud backup/sync (local JSON backup implemented)
- Per-feature AI toggles
- Auto-recap on book open (currently manual button)

---

## 17. File index (key source files)

| Path | Role |
|------|------|
| `lib/main.dart` | App entry, ProviderScope |
| `lib/app/app.dart` | MaterialApp.router |
| `lib/app/router.dart` | Routes, AppRoutes helpers |
| `lib/core/database/app_database.dart` | Drift database |
| `lib/core/database/tables.dart` | Table definitions |
| `lib/core/providers/app_providers.dart` | Global providers |
| `lib/core/ai/*.dart` | AI abstraction |
| `lib/features/books/domain/models/*.dart` | Book, Chapter |
| `lib/features/books/domain/repositories/*.dart` | Repository interfaces |
| `lib/features/books/data/repositories/*.dart` | Repository implementations |
| `lib/features/books/presentation/pages/library_page.dart` | Library UI |
| `lib/features/books/presentation/pages/book_detail_page.dart` | Book hub |
| `lib/features/books/presentation/pages/story_lab_page.dart` | Foundations + brainstorm |
| `lib/features/books/presentation/pages/tabs/foundations_panel.dart` | Sparks / picture / grow |
| `lib/features/books/domain/models/story_lab_draft.dart` | Foundations + brainstorm composer JSON |
| `lib/shared/widgets/lore_lookup_panel.dart` | Searchable lore reference |
| `lib/shared/widgets/lore_proposal_sheet.dart` | Review-before-apply create/update/retire/link/unlink |
| `lib/shared/widgets/note_relationship_dialog.dart` | Add/edit relationships + list widget |
| `lib/features/books/domain/note_templates.dart` | Scaffolding by NoteType |
| `lib/features/books/domain/models/note_relationship.dart` | Relationship model |
| `lib/core/ai/lore_proposal_parser.dart` | Parse promote/deepen/evolve JSON |
| `lib/core/ai/models/lore_proposal.dart` | LoreProposal model |
| `lib/features/editor/presentation/pages/editor_page.dart` | Writing editor |
| `lib/core/preferences/*.dart` | App preferences model + repository |
| `lib/core/data/backup_service.dart` | JSON backup export/import |
| `lib/features/onboarding/presentation/pages/onboarding_page.dart` | First-run welcome |
| `lib/features/settings/presentation/pages/settings_page.dart` | Settings shell (tabs) |
| `lib/features/settings/presentation/widgets/appearance_settings_section.dart` | Theme + editor prefs |
| `lib/features/settings/presentation/widgets/backup_settings_section.dart` | Backup UI |
| `lib/features/settings/presentation/widgets/ai_settings_section.dart` | AI settings UI |
| `lib/features/settings/presentation/widgets/model_picker_dialog.dart` | Gemini + NanoGPT model pickers |
| `lib/core/ai/nanogpt_model_filters.dart` | NanoGPT Auto + catalog filters |
| `lib/features/editor/presentation/widgets/editor_chapter_sidebar.dart` | Desktop chapter nav |
| `core/utils/error_messages.dart` | User-friendly error mapping |
| `shared/widgets/error_state.dart` | Reusable error UI + snackbar helpers |
| `deploy.sh` | One-command deploy script (Android APK + Linux desktop + GitHub Release) |
| `shared/widgets/book_edit_dialog.dart` | Title + description editor |
| `shared/widgets/book_description_card.dart` | Book detail description card |
