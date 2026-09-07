# Journey — Project Status

> **Living document for AI agents.** Read this first every session. Update before you finish any work.

**Last updated:** 2026-08-23  
**Current phase:** 9 (Dynamic World Bible) — **COMPLETE** (polish: larger AI reading text)  
**Previous:** Phase 8 (Lore collaboration loop) — complete  
**Deferred (non-AI):** Rich text, cloud sync

---

## Product intent

Journey is a **personal, casual writing app** — not a commercial author platform. Avoid word count goals, streaks, analytics dashboards, or "pro writer" tooling unless explicitly requested.

**AI policy:** All AI is **user-initiated**. The app must work fully offline as a plain writing tool with AI disabled. No background AI, no auto-summarize on save, no passive checking while typing.

---

## Quick state

| Area | Status |
|------|--------|
| Phases 0–8 | Done |
| Phase 9 — Dynamic World Bible | **Complete** |
| Onboarding, settings, backup, desktop polish | Done |
| Cloud sync | Deferred |
| Secure API key storage | Deferred |

---

## Phase checklist

### Phase 9 — Dynamic World Bible (complete)
- [x] Guided note scaffolding by type + Insert scaffolding
- [x] `interrogateLore` — probing questions on a note (optional append)
- [x] Note relationships table + add/edit/delete dialog
- [x] Chronology order + era on notes; Timeline section in Notes tab
- [x] `evolveWorldState` — update world state from chapter (notes + links, review-before-apply)
- [x] Schema v6; backup format v5

### Phase 8 — Lore collaboration loop (complete)
- [x] Promote brainstorm → structured lore (create / update / retire) with review-before-apply
- [x] Promote chapter ideas to lore from the editor
- [x] Deepen note with AI (review sheet)
- [x] Retire as spark (manual demotion)
- [x] Cross-screen workflow links (editor ↔ Story Lab, note → Story Lab, book → promote)

### Phase 7 — Foundations (complete)
- [x] Sparks → pick a picture (description + canon + tone)
- [x] Grow named pieces into real notes (character, place, group, item, history, plot, idea)
- [x] Note types expanded; Spark / Draft / Canon status
- [x] Notes search + type/status/tag/sort filters
- [x] Lore lookup in editor (panel + `Ctrl+Shift+L`) and Story Lab

### Phase 6 — Grounded long-form memory (complete)
- [x] 6A: Author's note + canon summary (manual / on-demand AI update)
- [x] 6B: Triggered lore on notes (keywords, always-include, priority)
- [x] 6C: Fix continuity with review-before-apply
- [x] 6D: Multi-variant results for selection transforms
- [x] 6E: Scene paths in editor
- [x] 6F: Story Lab (brainstorm, canon pins, scene ideas, glossary, summarize)

### Phase 5 — Contextual AI (complete)
- [x] 5A–5D (see prior changelog)

### Deferred
- [ ] Rich text editor
- [ ] Cloud backup/sync
- [ ] Secure API key storage

---

## Routes

| Path | Screen |
|------|--------|
| `/onboarding` | First-run welcome |
| `/books` | Library |
| `/settings` | Settings |
| `/books/:bookId` | Book hub |
| `/books/:bookId/story-lab` | Foundations + Story Lab (`?tab=brainstorm`) |
| `/books/:bookId/notes/:noteId` | Note editor |
| `/books/:bookId/search` | Search chapters |
| `/books/:bookId/chapters/:chapterId` | Chapter editor |

---

## Changelog

### 2026-08-23 — Fix Android release APK AI offline (build 30)
- Added missing `INTERNET` permission to `android/app/src/main/AndroidManifest.xml` — release APKs could not make AI API calls, showing "You appear to be offline."
- Debug and profile manifests already had the permission, so the issue only affected downloaded release builds

### 2026-08-23 — Larger AI reading text (build 29)
- App text size max raised to **200%** (was 130%)
- Theme body sizes bumped; sparks / grow / brainstorm / AI result & proposal sheets use a dedicated reading style
- Slider copy clarifies it scales AI reading text, not only chrome

### 2026-08-23 — Appearance colors & UI scale (build 28)
- Settings → Appearance: background presets (parchment, ink, slate, crimson, forest) and highlight colors (gold, yellow, red, amber, cyan, lime, white)
- App-wide UI text scale (85–130%); editor font size / line spacing unchanged and separate
- Theme cards/FAB/buttons follow chosen palette; glass-style card treatment kept

### 2026-08-23 — Foundations-aware empty states (build 27)
- Chapters / Notes empty CTAs say **Continue Foundations** (with progress) when Story Lab draft or picture exists — not always “Start from scratch”
- Removed duplicate **New chapter** on Chapters empty state (FAB only)
- Foundations intro acknowledges saved sparks/seed before a picture is committed

### 2026-08-23 — Dynamic World Bible (build 26)
- Note scaffolding templates by type; Interrogate lore AI action
- Note relationships (ally/enemy/etc.) with reviewable AI link/unlink proposals
- Chronology order + era on notes; Timeline + Relationships panels on Notes tab
- Update world state from chapter (`evolveWorldState`) via LoreProposalSheet
- SQLite schema v6; backup format v5

### 2026-08-22 — Promote to lore + workflow links (build 25)
- **Promote to lore:** Story Lab / book menu / editor → review create, update, and retire proposals before applying
- **Deepen note** from note editor (optional focus prompt; same review sheet)
- **Retire as spark** on notes (Idea / Spark demotion without AI)
- Cross-links: editor → Story Lab (`Ctrl+Shift+B`), note → Story Lab, book → Promote Story Lab to lore
- After promote from Story Lab, optional clear of brainstorm messages

### 2026-08-18 — Linux release builds (build 24)
- GitHub Releases now include a portable Linux tarball alongside Windows zip and Android APK
- CI job installs GTK 3 build deps on `ubuntu-latest` and packages `build/linux/x64/release/bundle/`

### 2026-08-14 — Story Lab drafts persist (build 23)
- Foundations sparks, grow options, vibe, and focus survive leaving the screen or switching tabs
- Brainstorm messages already saved; unsent composer text now saves too
- SQLite schema v5 (`story_lab_draft` on books); backup format v4

### 2026-08-14 — NanoGPT Auto, usage, and sticky AI settings (build 22)
- NanoGPT **Auto** (`auto-model`) is always available
- AI settings persist when you leave the screen (auto-save; no Save button)
- Remaining **today** and billing-period subscription allowance (NanoGPT’s API does not always send a weekly bucket) plus pay-as-you-go balance
- Model picker: search, subscription-only toggle, category/capability filters, sort, and stats (context, pricing, capabilities; TPS/uptime when NanoGPT includes them)

### 2026-08-13 — Chapters empty-state overflow (build 21)
- Empty chapters tab no longer overflows when description/author/canon cards leave little vertical room; empty states scroll if needed

### 2026-08-13 — Windows debug after drive-letter move
- Cleared stale CMake cache from old `F:/AI/Journey` path; `flutter clean` + debug rebuild on `D:`

### 2026-08-13 — Foundations: start from scratch (build 20)
- **Foundations** tab in Story Lab: generate world sparks, commit a picture, grow notes incrementally, opening-scene ideas
- Keep unused sparks as Idea notes; grow options save as Spark / Draft / Canon
- Note types: Item, Group, History, Idea; note **status** (spark/draft/canon)
- Notes tab: search, type/status/tag filters, sort
- Lore lookup from editor (wide panel + sheet, `Ctrl+Shift+L`) and Story Lab
- SQLite schema v4; backup format v3
- Sparks are excluded from writing-AI lore unless always-include

### 2026-08-13 — Post-reinstall cleanup (build 19)
- Restored Flutter packages (`flutter pub get`) after Windows reinstall; `.dart_tool` is gitignored so the IDE showed 1000+ unresolved-import errors until deps were fetched
- Cleared remaining analyzer infos: `mounted` guards on async `BuildContext` use, `DropdownButtonFormField.initialValue`, FilePicker `readAsBytes()` for backup restore
- `flutter analyze` clean; all 27 tests passing

### 2026-08-08 — Phase 6 complete (build 18)
- Per-book **Author's note** and **Canon summary** on Chapters tab
- Note **lore triggers** (keywords, always-include, priority)
- **Fix continuity** with review-before-apply sheet
- **Variant pager** for rephrase/expand/sensory/show-don't-tell
- **Scene paths** editor action
- **Story Lab** page: brainstorm, canon pins, scene ideas, glossary, summarize
- SQLite schema v3; backup format v2
- `AiContextBuilder`, `ContinuityFixParser`, `VariantsParser`

### 2026-08-08 — Icon & versioning policy
- (prior entries unchanged)

---

## Agent update checklist

- [x] `PROJECT_STATUS.md` updated
- [x] `PROJECT_REFERENCE.md` updated
- [x] `README.md` updated
- [x] `ROADMAP.md` updated
