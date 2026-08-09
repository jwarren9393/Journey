# Journey — Project Status

> **Living document for AI agents.** Read this first every session. Update before you finish any work.

**Last updated:** 2026-08-08  
**Current phase:** 5 (Contextual AI) — **COMPLETE**  
**Previous:** Phase 4 (Polish & platform) — complete  
**Deferred (non-AI):** Rich text, cloud sync

---

## Product intent

Journey is a **personal, casual writing app** — not a commercial author platform. Avoid word count goals, streaks, analytics dashboards, or "pro writer" tooling unless explicitly requested.

---

## Quick state

| Area | Status |
|------|--------|
| Phases 0–3 | Done |
| Onboarding (first-run welcome) | Done |
| Settings: appearance (theme, font, spacing) | Done |
| Settings: local JSON backup/restore | Done |
| Desktop: editor chapter sidebar (≥1100px) | Done |
| Desktop: keyboard shortcuts | Done |
| Cloud sync | Deferred |
| Phase 5 — Contextual AI | **Complete** (5A–5D) |

---

## Phase checklist

### Phase 5 — Contextual AI (complete)
- [x] 5A: Sensory enhancer, show-don't-tell, tone & voice meter
- [x] 5B: Continuity checker, extract-to-note, ask the world bible
- [x] 5C: Pacing heatmap, plot bridge
- [x] 5D: Blurb & query pitch generator

### Phase 4 — Polish (complete)
- [x] Onboarding flow with skip / get started
- [x] Settings tabs: Appearance | Backup | AI
- [x] Theme mode (system / light / dark)
- [x] Editor font size and line spacing preferences
- [x] Local JSON backup export and restore
- [x] Editor chapter sidebar on wide desktop
- [x] Keyboard shortcuts (Ctrl+, settings; Ctrl+Shift+F focus; Ctrl+/ help)

### Deferred
- [ ] Rich text editor
- [ ] Cloud backup/sync
- [ ] Secure API key storage

---

## Routes

| Path | Screen |
|------|--------|
| `/onboarding` | First-run welcome (redirects until completed) |
| `/books` | Library |
| `/settings` | Settings (Appearance / Backup / AI tabs) |
| `/books/:bookId` | Book hub (Chapters / Outline / Notes tabs) |
| `/books/:bookId/notes/:noteId` | Note editor |
| `/books/:bookId/search` | Search chapters |
| `/books/:bookId/chapters/:chapterId` | Chapter editor |

---

## Changelog

### 2026-08-08 — Releases & README
- GitHub Actions release workflow (Windows zip + Android APK on `v*` tags)
- Version bumped to 1.6.0+16; `file_picker` upgraded to 12.x (Gradle 9 / win32 6 compat)
- README rewritten with full feature list and install instructions
- Agent docs: `README.md` must be updated for user-visible feature changes

### 2026-08-06 — Phase 5D complete (Phase 5 done)
- Blurb & query pitch generator from book description + chapter outlines
- Book detail menu item; post-export snackbar action
- `AiExportActions` helper; `blurbPitchGenerator` AI action

### 2026-08-06 — Phase 5C complete
- Pacing heatmap: batch AI labels per chapter (High Action, Dialogue Heavy, etc.) in Outline tab
- Plot bridge: bridge ideas between chapter N and N+2 for middle chapters
- `PacingLabelParser`, `PacingChip`, `AiOutlineActions`
- Outline tab toolbar with Analyze pacing + Show heatmap toggle

### 2026-08-06 — Phase 5B complete
- Continuity check: chapter + worldbuilding notes → contradiction flags
- Extract to note: scan manuscript for new entities → one-tap note creation
- Ask the world bible: keyword-matched notes + AI Q&A from editor/book menu
- `NoteContextService`, `ExtractedEntityParser`, `AiBookActions` helper
- Notes tab "Discover entities" button; book menu continuity + world bible

### 2026-08-06 — Phase 5A complete
- New AI actions: sensory enhance, show don't tell, tone & voice meter
- Extended `AiContext` with `SensorySense`, `referenceChapter`, `userPrompt`
- Editor menus + sensory sense picker and tone/voice reference dialog
- AI actions now use live editor text (not stale chapter snapshot)
- Unit tests for Phase 5A prompt templates

### 2026-08-06 — Phase 5 roadmap defined
- Added Phase 5 (Contextual AI) to `ROADMAP.md` from Gemini feature brainstorm
- Sub-phases 5A–5D: editor transforms, continuity/notes, outline tools, export polish
- Suggested build order and technical notes for agents

### 2026-08-03 — Phase 4 complete
- Onboarding page with first-run redirect
- App preferences (theme, editor font size, line height) in SharedPreferences
- Settings reorganized into Appearance, Backup, and AI tabs
- Local JSON backup export/restore (`BackupService`)
- Editor chapter sidebar on wide screens; focus mode shortcut
- Global keyboard shortcuts (settings, shortcuts dialog)

### 2026-08-03 — Phase 3 complete
- Book detail tabs: Chapters, Outline, Notes
- Notes with types, tags, attachments, auto-save editor
- Outline: drag-reorder chapters, per-chapter outline notes
- Book categories with library filter chips
- SQLite schema v2 (notes, tags, category, outlineSummary)

### 2026-08-03 — Phase 2 complete
- Focus mode, search, export

---

## Agent update checklist

- [x] `PROJECT_STATUS.md` updated
- [x] `PROJECT_REFERENCE.md` updated
- [x] `README.md` updated (user-facing features & releases)
