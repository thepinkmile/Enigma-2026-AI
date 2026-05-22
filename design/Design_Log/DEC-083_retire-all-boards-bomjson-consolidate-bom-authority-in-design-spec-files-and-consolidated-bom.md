## DEC-083 - Retire `all_boards_bom.json`; Consolidate BOM Authority in Design_Spec Files and Consolidated_BOM

| Field | Value |
| :--- | :--- |
| **Decision ID** | DEC-083 |
| **Status** | Confirmed |
| **Date** | 2026-05-21 |
| **Author** | Izzyonstage & GitHub Copilot |
| **Supersedes** | DEC-047 (Impact line re `all_boards_bom.json`); DEC-051 (Impact line re `all_boards_bom.json`) |

### Context

`design/Electronics/all_boards_bom.json` was created at an early stage of the project as a
machine-readable mirror of the cross-board BOM data. A full audit conducted on 2026-05-21 found
the file had never been actively used and had diverged significantly from the authoritative board
`Design_Spec.md` BOM tables — 43 missing entries, ~60 RefDes mismatches, 11 wrong MPNs, 2 wrong
electrical values, and 7 extra entries not present in any board spec. The discrepancies confirmed
it had not been kept in sync with design changes.

### Decision

Retire `all_boards_bom.json` permanently. The file has been moved to `.recycle-bin/` (not
committed). BOM authority is defined as follows:

- **System-level BOM source of truth:** `design/Electronics/Consolidated_BOM.md`
  — cross-board summary of all components; updated whenever a board BOM changes.
- **Board-level BOM source of truth:** each board's `Design_Spec.md` BOM table
  — the primary editable record for that board's components.
- The Consolidated BOM is derived from the board Design_Spec files and must always reflect them.
  It is never edited as a primary source.

### Rationale

The JSON file added maintenance overhead without providing value — no tooling, scripts, or
processes consumed it. Retaining an incorrect parallel source of truth is a procurement and design
risk. The markdown BOM tables in Design_Spec files are human-readable, version-controlled, and
already the de-facto primary sources; formalising this removes ambiguity.

### Impact

- `design/Electronics/all_boards_bom.json` moved to `.recycle-bin/` (retired, not deleted).
- `.copilot/agent-directives.md` BOM Authority Rules section updated to remove reference to the
  JSON and formally state the Consolidated_BOM / board Design_Spec authority hierarchy.
- Historical Impact entries in DEC-047 and DEC-051 that mention `all_boards_bom.json` are
  superseded by this decision; the file they reference no longer exists.

### Amends / Supersedes

- **DEC-047** (Impact only) — the line "all_boards_bom.json: Updated accordingly" is superseded;
  the file no longer exists.
- **DEC-051** (Impact only) — the line "all_boards_bom.json: all `"board": "Settings Board"`
  entries updated" is superseded; the file no longer exists.
