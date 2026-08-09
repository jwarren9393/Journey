# Journey — Project Status

> **Living document for AI agents.** Read this first every session. Update before you finish any work.

**Last updated:** 2026-08-08  
**Current phase:** 6 (Grounded long-form memory) — **COMPLETE**  
**Previous:** Phase 5 (Contextual AI) — complete  
**Deferred (non-AI):** Rich text, cloud sync

---

## Product intent

Journey is a **personal, casual writing app** — not a commercial author platform. Avoid word count goals, streaks, analytics dashboards, or "pro writer" tooling unless explicitly requested.

**AI policy:** All AI is **user-initiated**. The app must work fully offline as a plain writing tool with AI disabled. No background AI, no auto-summarize on save, no passive checking while typing.

---

## Quick state

| Area | Status |
|------|--------|
| Phases 0–5 | Done |
| Phase 6 — Grounded long-form memory | **Complete** (6A–6F) |
| Onboarding, settings, backup, desktop polish | Done |
| Cloud sync | Deferred |
| Secure API key storage | Deferred |

---

## Phase checklist

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
| `/books/:bookId/story-lab` | Story Lab brainstorm |
| `/books/:bookId/notes/:noteId` | Note editor |
| `/books/:bookId/search` | Search chapters |
| `/books/:bookId/chapters/:chapterId` | Chapter editor |

---

## Changelog

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
