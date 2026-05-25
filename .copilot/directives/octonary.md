# OCTONARY DIRECTIVE — Todo-List and Per-Todo File Management

Todo tracking uses two layers:

1. **`.copilot/todos/index.md`** — summary table only (ID | File | Status | Blocked By). No prose,
   no inline notes.
2. **`.copilot/todos/<id>.md`** — one file per active todo; full context: description, notes,
   blocked-by rationale, links to relevant design files.

## Session Start — Mandatory First Action

Before any other work, seed the session database:

1. Run the SQL from `.copilot/todos/todos.sql` via the `sql` tool.
2. Run the SQL from `.copilot/todos/deps.sql` (wrapped in `PRAGMA foreign_keys = OFF/ON` as shown).
3. Verify row counts match expectations before proceeding.

Failure to seed the session DB at startup is a directive violation.

## Keeping in Sync

When any todo changes, update **all three** (index.md table, SQL file, session DB):

- **Status change** → update row in `index.md`, the INSERT value in `todos.sql`, and
  `UPDATE todos SET status = '...' WHERE id = '...'` in session DB.
- **New todo** → add row to `index.md`, INSERT to `todos.sql`, insert into session DB, create
  `todos/<id>.md`, add deps to `deps.sql` and session DB if any.
- **Dependencies change** → update `index.md` Blocked By column, `deps.sql`, and session DB.

## Per-Todo File Rules

- When a todo is added: create both the `index.md` row **and** the detail file before it is
  considered tracked.
- When a todo is closed: remove the File link from the `index.md` row; archive the detail file to
  `.recycle-bin/`. Keep the row with status `done`.
- Per-todo file format: `# Title`, `**ID:**`, `**Status:**`, `**Category:**`, `**Source:**`,
  `**Blocked by:**`, `---`, `## Description`, `## Notes`.
