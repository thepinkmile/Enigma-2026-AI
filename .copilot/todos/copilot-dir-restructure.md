# .copilot Directory Restructure

**ID:** `copilot-dir-restructure`  
**Status:** pending  
**Category:** Process / Tooling  
**Source:** User request 2026-05-22  
**Blocked by:** —  

---

## Description

Restructure the `.copilot/` directory so that large monolithic files (`agent-directives.md`,
`todo-list.md`) are split into smaller, focused files. The goal is to allow agent sessions to load
only the context they need, reducing memory pressure and preventing directives from being silently
dropped when context windows fill.

Current pain point: `agent-directives.md` is ~38 KB and `todo-list.md` is ~37 KB. Both are loaded
at session start. As the session progresses and context fills, these files scroll out of the active
window, causing directive violations (observed multiple times in this project's history).

## Notes

- **Proposed split for `agent-directives.md`:**  
  Create `.copilot/directives/` with one file per directive group, e.g.:
  - `primary.md` — PRIMARY: component/MPN protection
  - `secondary.md` — SECONDARY: git staging / commit rules
  - `tertiary.md` — TERTIARY: design log integrity
  - `quaternary.md` — QUATERNARY: file deletion / recycle-bin
  - `quinary.md` — QUINARY: review sub-agent constraints
  - `senary.md` — SENARY: implementation authorisation
  - `septenary.md` — SEPTENARY: mandatory agent prompt preamble
  - `octonary.md` — OCTONARY: todo-list and per-todo file management
  - `nonary.md` — NONARY: KiCAD library import
  - `operational.md` — remaining rules (component lookup, BOM content, metadata, etc.)
  - `index.md` — short summary + links to all directive files (session start loads this first)

- **Proposed split for `todo-list.md`:**  
  - `todo-list.md` keeps the summary table only (lightweight; loaded for status checks).
  - `.copilot/todo-sql/todos.sql` — Agent SQL INSERT block (todos only).
  - `.copilot/todo-sql/deps.sql` — Agent SQL dependencies block.
  - Sessions seed the DB by running the two SQL files rather than parsing the markdown.

- A minimal "session start" file (e.g. `.copilot/SESSION_START.md`) should list exactly which
  files to read and in what order, replacing the scattered "read these files" instructions.

- All cross-references within `.copilot/` (plan.md, handoff.md, checkpoints) must be updated to
  point to the new locations.

- `agent-scripts/` and `todos/` subdirectories remain unchanged.

- The restructure must not break any existing content — this is a move/split operation only.
  No directives are removed or weakened.
