# Directives Index

Load this file first at every session start, then fetch individual directive files as needed.
All directives apply equally to all agents, sub-agents, and orchestrating sessions.

## Critical Directives — load these first

| File | Directive | Summary |
| :--- | :--- | :--- |
| `primary.md` | PRIMARY | Never modify MPNs/supplier PNs; BOM content rules; banned manufacturers |
| `secondary.md` | SECONDARY | Never git commit/stage/unstage; user controls git; live-session approval only |
| `tertiary.md` | TERTIARY | `design/Design_Log/` is append-only; never modify existing DEC files |
| `quaternary.md` | QUATERNARY | Never delete files permanently; move to `.recycle-bin/` |
| `senary.md` | SENARY | Never modify files without explicit implementation approval; one scope at a time |
| `septenary.md` | SEPTENARY | Every sub-agent prompt must begin with the mandatory preamble block |

## Operational Directives

| File | Directive | Summary |
| :--- | :--- | :--- |
| `quinary.md` | QUINARY | Review sub-agents are read-only; deep-dive review cycle; review suppression |
| `octonary.md` | OCTONARY | Todo tracking: seed DB from `todos/todos.sql` + `todos/deps.sql` at session start |
| `nonary.md` | NONARY | KiCAD library imports: all 4 formats in sync; completeness gate; retirement |

## Rules

| File | Content |
| :--- | :--- |
| `component-lookup.md` | Use local sources only (MD → PDF → ask user); never web search |
| `document-rules.md` | Only `Last Updated` may change; design docs contain current design only |
| `character-usage.md` | Non-ASCII chars must appear in `allowed-character-matrix.md` |
| `repo-state.md` | `.copilot/` git tracking; checkpoint rules; path sanitisation |
