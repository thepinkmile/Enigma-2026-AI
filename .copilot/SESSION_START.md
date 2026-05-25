# SESSION_START

Bootstrap file for every new session on this repository.
Follow these steps in order before doing any other work.

---

## Step 1 — Load All Directives

1. Read `.copilot/directives/index.md`.
2. Read each directive file listed in the index (all files in `.copilot/directives/`).
3. **Store every directive as a persistent upvoted memory.** Do not proceed until all directives
   are committed to memory and cannot be overridden.

Minimum set to confirm loaded:

| Directive | Non-negotiable rule |
| :--- | :--- |
| PRIMARY | Never modify MPNs or supplier PNs; BOM content rules apply |
| SECONDARY | Never git commit / add / stage / unstage — ever |
| TERTIARY | `design/Design_Log/` is append-only; existing DEC files are read-only |
| QUATERNARY | Never delete files permanently; move to `.recycle-bin/` |
| SENARY | Never modify files without explicit implementation approval |
| SEPTENARY | Every sub-agent prompt must start with the mandatory preamble block |

---

## Step 2 — Seed Session Database

Run both SQL files via the `sql` tool:

1. `.copilot/todos/todos.sql` — inserts all todos (`INSERT OR IGNORE`, idempotent)
2. `.copilot/todos/deps.sql` — inserts all dependencies (uses `PRAGMA foreign_keys = OFF/ON`)

Verify row counts match expectations before proceeding. Failure to seed is an OCTONARY violation.

---

## Step 3 — Read Current State

1. Read `.copilot/plan.md` — current workstream status, next steps, key design decisions.
2. Read `.copilot/handoff.md` (latest section first) — what was last worked on.
3. Read the latest relevant checkpoint(s) in `.copilot/checkpoints/` if additional context is needed.

---

## Checklist

- [ ] All directives loaded as standing memories
- [ ] Session DB seeded (row counts verified)
- [ ] `plan.md` read
- [ ] `handoff.md` read
