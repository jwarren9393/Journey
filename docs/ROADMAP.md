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
- NanoGPT with subscription model picker — **done**
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

## Open Questions

Use this section to capture decisions as we discuss them:

- **Target platforms**: Windows + Android first (locked). iOS/macOS/web later.
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
