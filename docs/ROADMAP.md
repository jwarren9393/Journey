# Journey — Development Roadmap

A phased plan for building the book-writing app. Phases are flexible — we'll refine as we go.

## Phase 0: Foundation

- [x] Flutter project scaffold
- [x] Folder structure (feature-based architecture)
- [x] App theme and routing shell
- [x] Define core features and user flows together

## Phase 0.5: Plumbing (complete)

- [x] Domain models (`Book`, `Chapter`)
- [x] Repository interfaces + Drift (SQLite) implementations
- [x] Riverpod state management
- [x] go_router navigation (library → book → editor)
- [x] Library, book detail, editor, settings screens
- [x] Auto-save in editor (debounced)
- [x] AI service abstraction + settings UI (stub, no API calls)
- [x] Living documents for agents and Gemini (`PROJECT_STATUS`, `PROJECT_REFERENCE`)

## Phase 1: Core Writing Experience + AI (complete)

- Book/project model — **done**
- Chapter structure — **done**
- Basic text editor — **done**
- Local persistence — **done**
- Library view — **done**
- Google Gemini (AI Studio) — **done**
- NanoGPT with Auto, remaining credits, subscription-only catalog, and filters — **done**
- Editor AI actions — **done**
- Book AI recap — **done**
- Book description editing — **done**
- Chapter rename from editor — **done**
- Error / offline messaging — **done**

## Phase 2: Personal Writing Tools (complete)

Journey is a **personal casual writing app** — not a commercial author platform.

- [x] Focus / distraction-free mode
- [x] Search within a book (chapter titles + text)
- [x] Export (plain text + Markdown)
- [x] **Excluded:** word count goals, streaks, analytics, commercial "pro writer" features
- [ ] Rich text formatting — deferred (plain text stays for now)

## Phase 3: Organization & Planning (complete)

- [x] Notes and research attachments (per-book notes with optional file attachment)
- [x] Character / location / plot note types (worldbuilding)
- [x] Outline view with drag-reorder chapters + per-chapter outline notes
- [x] Tags on notes + book categories in library

## Phase 4: Polish & Platform (complete)

- [x] Onboarding and empty states
- [x] Settings (theme, font, spacing)
- [x] Desktop optimizations (keyboard shortcuts, multi-panel editor sidebar)
- [x] Local backup (JSON export/restore)
- [ ] Cloud sync — deferred (TBD)

## Phase 5: Contextual AI (complete)

**Goal:** Make AI feel built into Journey — contextual, on-demand, and grounded in the manuscript and worldbuilding notes. Not a chatbot panel.

**Design principles (carry forward from Phase 1):**
- User-initiated actions only (no always-on background AI)
- Scoped context: selection, chapter, book metadata, and **BookNotes**
- Async, non-blocking; results shown in dialogs or inline affordances
- Dual provider support (Google Gemini + NanoGPT) via existing `AiService`

**Suggested build order** (each sub-phase unlocks the next):

### 5A — Editor: selection transforms & voice (complete)

Extend `AiContext`, `AiAction`, and editor menus. Lowest friction; mirrors existing rephrase/expand/tighten pattern.

- [x] **Sensory enhancer** — selection action; rewrite focusing on sight, sound, or smell (user picks sense or AI infers)
- [x] **Show, don't tell** — selection action; turn flat exposition (e.g. "He was terrified") into 2–3 subtle action-based alternatives
- [x] **Dynamic tone & voice meter** — editor menu action; compare active chapter against a user-chosen "reference scene" or quick persona prompt; surface pacing/vocabulary drift (e.g. modern slang in historical fiction)

### 5B — Continuity & worldbuilding notes (complete)

Ground AI in `BookNote` entries (character, location, plot, research).

- [x] **Continuity & fact checker** — on-demand editor or book action; send current chapter + relevant notes; flag contradictions (e.g. handedness, eye color, timeline)
- [x] **Extract to note / entity auto-discovery** — scan recent chapter(s) for new names, places, items; offer one-tap pre-filled `BookNote` drafts (character/place) with descriptions pulled from manuscript
- [x] **Ask the world bible** — quick-query prompt in editor or book menu; retrieve answers from local `BookNote` corpus via keyword matching over notes

### 5C — Outline & structure (complete)

Features live in the **Outline** tab; use `outlineSummary` and chapter order.

- [x] **Pacing & scene heatmap** — per-chapter labels from `outlineSummary` (and optionally body text): e.g. High Action, Dialogue Heavy, Exposition; visual flow in outline view
- [x] **"What happens next?" plot bridge** — between chapter N and N+2 in outline; analyze chapter N content + chapter N+2 target summary; suggest 3 short bridge concepts for chapter N+1 (ideas only, not prose)

### 5D — Export & polish (complete)

Hook into existing export flow (`share_plus` / book detail export menu).

- [x] **Blurb & query pitch generator** — on export (or book detail action); scan book description + chapter/outline summaries; draft back-cover blurb, tagline, short hook, and optional multi-paragraph pitch

### Phase 5 technical notes (for agents)

| Concern | Approach |
|---------|----------|
| Richer context | Extend `AiContext` with `List<BookNote>?`, optional `referenceChapter`, user query string |
| New actions | Add to `AiAction` enum + `PromptTemplates.forAction` |
| Note retrieval | `NoteRepository.watchByBookId`; filter by type/tag for continuity and world-bible queries |
| RAG (world bible) | v1: structured + keyword match over note titles/content; v2: local embeddings if needed |
| Outline UI | `book_detail_page` outline tab; heatmap chips + plot-bridge affordance between chapter rows |
| Export | Extend export dialog or post-export sheet with generated marketing copy |

### Phase 5 excluded (for now)

- Always-on passive fact-checking while typing
- Full semantic search across full manuscript body (separate from world-bible note query)
- Auto-generated prose for plot bridges (suggestions only)

## Phase 6: Grounded long-form memory (complete)

**Goal:** Layered, budgeted AI context that compounds over time — still **100% user-initiated**. No background AI, no auto-summarize on save, no passive checking while typing.

**Design principles:**
- Journey works fully offline as a writing app with AI disabled
- Every AI call starts from an explicit menu action, button, or Send in Story Lab
- Review-before-apply for destructive-ish AI outputs (fix continuity, canon save)

### 6A — Per-book context (complete)

- [x] **Author's note** — per-book style guide on Chapters tab; injected into all AI prompts when AI runs
- [x] **Canon summary** — editable bullets; **AI: Update from book/chapter** on demand only

### 6B — Triggered lore (complete)

- [x] Note fields: keywords, always-include, priority (0–10)
- [x] `NoteContextService.findTriggeredNotes` — keyword scan + budget when AI actions run
- [x] "Lore included" snackbar after user-initiated AI (informational only)

### 6C — Fix continuity (complete)

- [x] **Fix continuity** — proposes note body updates as JSON; review sheet before apply

### 6D — Variant swipes (complete)

- [x] Rephrase, Expand, Sensory enhance, Show don't tell return multiple variants with pager UI

### 6E — Scene paths (complete)

- [x] **Scene paths** — 6 in-scene beat ideas from editor AI menu

### 6F — Story Lab (complete)

- [x] Story Lab page (`/books/:bookId/story-lab`) — brainstorm chat, canon pins, scene ideas, glossary extract, summarize
- [x] Schema: `canon_pins`, `story_lab_messages`, `story_lab_summary` on book
- [x] Backup v2 includes Phase 6 data

### Phase 6 excluded

- Auto-summarize on chapter save or message count
- Always-on lore injection while typing
- Character roleplay chat in main editor

## Phase 7: Foundations — start from scratch (complete)

**Goal:** Help an author who has no book yet discover a world, lock an overall picture, then grow named pieces into organized notes — still 100% user-initiated AI.

- [x] **Sparks** — 4 whole-world portraits from an optional vibe or Surprise me
- [x] **Commit picture** — chosen spark → book description + canon summary + tone
- [x] **Keep as idea** — unused sparks become Idea notes (status: spark)
- [x] **Grow** — incrementally create character / place / group / item / history / plot / idea notes
- [x] **Opening scenes** — 6 first-page ideas from the picture + notes
- [x] **Organization** — extra note types; Spark / Draft / Canon status; search + filters + sort
- [x] **Lore lookup** — editor panel/sheet + Story Lab; `Ctrl+Shift+L`
- [x] Schema v4 (`status` on notes); backup v3
- [x] Schema v5 (`story_lab_draft` on books); backup v4 — Foundations/brainstorm drafts persist

### Phase 7 excluded

- Relationship graphs / family trees
- Auto-generating a full cast or encyclopedia dump
- Always-on lore while typing

## Phase 8: Lore collaboration loop (complete)

**Goal:** Close the loop between brainstorming and the world bible — talk, then promote structured changes with review-before-apply — and connect writing / notes / Story Lab without forcing a single screen.

- [x] **Promote to lore** — from Story Lab brainstorm (and chapter context from the editor): AI proposes create / update / retire note changes; author reviews before apply
- [x] **Retire** — soft-archive outdated notes as Idea / Spark (excluded from writing AI unless always-include)
- [x] **Deepen note** — from note editor; optional focus prompt; same review sheet
- [x] **Workflow links** — editor → Story Lab (`Ctrl+Shift+B`), note → Story Lab, book menu → Promote Story Lab to lore; optional clear brainstorm after promote
- [x] Manual **Retire as spark** on notes without AI

### Phase 8 excluded

- Always-on lore while typing
- Automatic promote on every brainstorm message
- Hard-delete of notes via AI (retire is demotion only)

## Phase 9: Dynamic World Bible (complete)

**Goal:** Structured worldbuilding templates, lightweight relationships/timeline, and living world-state updates from the manuscript — still user-initiated with review-before-apply.

- [x] Guided note scaffolding by `NoteType` (create + insert)
- [x] `interrogateLore` — developmental questions on a note
- [x] `note_relationships_table` + UI dialog/list
- [x] `chronologyOrder` + `era` on notes; Timeline panel
- [x] `evolveWorldState` — chapter → note/relationship proposals via `LoreProposalSheet`
- [x] Schema v6; backup v5

### Phase 9 excluded

- Full graph visualization / family trees
- Automatic relationship inference while typing
- Hard-delete of notes via AI

## Open Questions

Use this section to capture decisions as we discuss them:

- **Target platforms**: Windows + Linux + Android (locked). iOS/macOS/web later.
- **Editor style**: Plain text for now. Markdown or rich text TBD.
- **Data storage**: Local-only (Drift/SQLite). Cloud sync in Phase 4.
- **Book structure**: Chapters only for now. Scenes TBD.
- **AI integration**: Google Gemini (AI Studio API) + NanoGPT. Scattered contextual actions, not always-on chat.
- **App purpose**: Personal casual writing app — avoid commercial author-platform features unless requested.
- **Monetization**: Personal project — not applicable.

## Living documents

Agents and collaborators should use:

- `docs/PROJECT_STATUS.md` — current state, changelog, next steps (agents read first)
- `docs/PROJECT_REFERENCE.md` — full reference for Gemini/Notebook upload
- `AGENTS.md` — agent instructions at repo root
