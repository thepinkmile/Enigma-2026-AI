# TERTIARY DIRECTIVE — Design Log Integrity

> ⚠️ **CRITICAL INTEGRITY VIOLATION** — Modifying an audit log entry is equivalent to falsifying a
> record. In a professional engineering context this could constitute a criminal offence.
> Commit `889cb5c` modified DEC-028 in-place. This must never recur.

The Design Log is `design/Design_Log/` — a directory of per-DEC files.

⛔ **NEVER modify any existing `design/Design_Log/DEC-NNN_*.md` file.** They are read-only once written.

## Structure

- `design/Design_Log/index.md` — index table (ID, title, date, status, summary)
- `design/Design_Log/DEC-NNN_{kebab-case-title}.md` — one file per decision

## Rules

- New decisions → create new `DEC-NNN_{kebab-title}.md` **and** add a row to `index.md`.
- Changes to a prior decision → new DEC entry with `Amends: DEC-NNN` or `Supersedes: DEC-NNN`.
- **Next entry: DEC-084** → file `design/Design_Log/DEC-084_{kebab-title}.md`.
- This rule applies to all agents and orchestrating sessions equally.
