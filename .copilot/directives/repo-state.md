# Repo-Local State Rules

`.copilot/` is tracked in git and must stay in sync with meaningful design-state changes.

## Session Start

Read in this order (see also `.copilot/SESSION_START.md`):

1. `.copilot/SESSION_START.md` — bootstrap instructions
2. `.copilot/directives/index.md` → fetch individual directive files as needed
3. `.copilot/todos/todos.sql` + `.copilot/todos/deps.sql` — seed session DB (OCTONARY)
4. `.copilot/plan.md` — current state and next steps
5. `.copilot/handoff.md` — recent session history
6. Latest relevant checkpoint(s) in `.copilot/checkpoints/`

## Checkpoint Completeness

A checkpoint is not complete until all four are updated and consistent:

- New checkpoint file in `.copilot/checkpoints/`
- `.copilot/checkpoints/index.md`
- `.copilot/plan.md`
- `.copilot/handoff.md`

## Checkpoint Numbering

⛔ Repo-local checkpoint files must be numbered consecutively. Before writing a new checkpoint,
check `.copilot/checkpoints/index.md` or list the folder and use `max_existing_number + 1`.

⛔ The session-state folder (`%USERPROFILE%/.copilot/session-state/<id>/checkpoints/`) uses its own
independent numbering. **NEVER** use the session-state number as the repo-local number.

**Current highest: 169. Next: 170.**

## Path Sanitisation

All `.copilot/` content must be sanitised for version control:

- Use repo-relative paths or `%USERPROFILE%` placeholders — no machine-specific absolute paths.
- Do not persist raw usernames or Copilot session IDs.

## Agent Scripts

Repo-local helper scripts that persist across sessions belong in `.copilot/agent-scripts/`.

`design/Datasheets/_generated_markdown_inventory.json` is the full datasheet index — treat it as
a complete index, not a single-run artifact.
