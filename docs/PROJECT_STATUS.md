# Journey — Project Status

> **Living document for AI agents.** Read this first every session. Update before you finish any work.

**Last updated:** 2026-08-18  
**Current phase:** 7 (Foundations — start from scratch) — **COMPLETE**  
**Previous:** Phase 6 (Grounded long-form memory) — complete  
**Deferred (non-AI):** Rich text, cloud sync

---

## Product intent

Journey is a **personal, casual writing app** — not a commercial author platform. Avoid word count goals, streaks, analytics dashboards, or "pro writer" tooling unless explicitly requested.

**AI policy:** All AI is **user-initiated**. The app must work fully offline as a plain writing tool with AI disabled. No background AI, no auto-summarize on save, no passive checking while typing.

---

## Quick state

| Area | Status |
|------|--------|
| Phases 0–6 | Done |
| Phase 7 — Foundations (start from scratch) | **Complete** |
| Onboarding, settings, backup, desktop polish | Done |
| Cloud sync | Deferred |
| Secure API key storage | Deferred |

---

## Phase checklist

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
