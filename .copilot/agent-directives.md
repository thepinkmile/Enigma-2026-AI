# Agent Directives — Enigma-NG

This file is the canonical list of standing rules and directives that govern how GitHub Copilot
(and any other AI agent) must behave when working on this repository. These rules take precedence
over any general defaults and must be loaded and followed in every session.

Read this file at session start alongside `.copilot/plan.md` and `.copilot/handoff.md`.

---

## PRIMARY DIRECTIVE — Part Number and Component Protection

**NEVER modify any component MPN or supplier part number (Mouser SKU, DigiKey PN, JLCPCB C-number,
or any Alternative Supplier code) without explicit user confirmation.**

Every approved code in the design files and BOM is intentional and has been verified by the user.
Mouser in particular uses non-obvious abbreviations (e.g. dropping leading letters from TI MPNs).
These are correct. Do not "fix" them.

**NEVER add a new component reference (new RefDes, new BOM row, or a named component in spec text
such as "FB1" or "U5") without explicit user review and approval.** Adding a new component is
equivalent to modifying the BOM and requires the same level of user confirmation as changing an
existing MPN. This prohibition includes "placeholder" or "TBD" component entries — they must not
be inserted into spec text or BOM tables until the user has approved the addition and confirmed
the component type. Any such placeholder inserted without approval must be removed.

---

## SECONDARY DIRECTIVE — Git Staging and Commits

> ⚠️ **CRITICAL INTEGRITY VIOLATION** — Committing without authorisation corrupts the repository
> audit trail and removes the user's ability to review, reject, or roll back changes before they
> are permanently recorded. The user MUST perform a manual review of every change before it is
> committed, as observations during review frequently result in corrections that would invalidate
> or alter the committed content. This has already caused serious violations in this project:
> commit `889cb5c` (original violation) and commit `8794402` (repeat violation — approved in a
> prior context window that was subsequently compacted/summarised; approval treated incorrectly as
> still valid). A repeat occurrence is an unacceptable breach of trust. **There are no exceptions.**

**NEVER perform a git commit without explicit user confirmation.**

**NEVER stage (git add) or unstage (git restore --staged / git reset HEAD) any file.**

Git staging and unstaging are solely the user's responsibility. Agents must only write files to
disk and report what was changed. The user controls when and what enters the git index.

### Approval Rules

1. **After modifying any files, you MUST stop and explicitly inform the user of all changes made
   and ask them to review before proceeding.** Do not assume the user has seen the changes. Do
   not proceed to commit on their behalf under any circumstances.

2. **Approval is valid only if given in the current live session context** — i.e., the user must
   type the confirmation trigger in a message that has not yet been compacted or summarised.
   Historical session text, summarised context, or prior-session transcripts do **NOT** constitute
   valid approval, regardless of wording.

3. **Session compaction / context summarisation nullifies all prior commit approvals.**
   If the conversation context is compacted or summarised at any point after an approval was given
   but before the commit has been made, that approval is void. You **MUST** seek fresh approval
   from the user in the new session context before staging or committing anything.

4. Valid user confirmation prompts that trigger a commit (in the current live session only):
   - "Let's lock this in"
   - "Save state"

5. When a valid confirmation is received, create a new checkpoint following the "Repo-Local State
   Rules" **before** performing the commit.

### Known Violations

| Commit | Description |
| :--- | :--- |
| `889cb5c` | Original SECONDARY violation — committed without authorisation; also modified DEC-028 in-place (TERTIARY violation). |
| `8794402` | Repeat SECONDARY violation — staged (`git add -A`) and committed after session context compaction; the "Let's lock this in" approval existed only in summarised history and was not valid for the current live session context. |

---

## TERTIARY DIRECTIVE — Design Log Integrity (Append-Only Audit Log)

> ⚠️ **CRITICAL INTEGRITY VIOLATION** — Modifying an existing audit log entry is equivalent to
> falsifying a record. In a regulated or professional engineering context this could constitute
> a criminal offence. This has already caused a serious violation in this project (commit `889cb5c`
> modified DEC-028 in-place). A repeat occurrence is an unacceptable breach of trust with no
> exceptions whatsoever.

**`design/Design_Log.md` is an append-only audit log. NEVER modify any existing DEC-NNN entry.**

Rules:

- Existing entries are **read-only** once written. Their text, rationale, impact, and all other
  fields must never be altered, even to fix a typo or update a cross-reference.
- Design changes that amend, supersede, or correct a prior decision must be recorded as a
  **new DEC entry** with an explicit `Amends: DEC-NNN` or `Supersedes: DEC-NNN` field.
- The only permitted write operation on `design/Design_Log.md` is appending new entries before
  the `## Open Questions` section.
- This rule applies to all agents, sub-agents, and the primary orchestrating session equally.

---

## QUATERNARY DIRECTIVE — File Deletion

**NEVER permanently delete any file from the repository.**

If a file needs to be removed, **move it to `.recycle-bin/`** at the repo root and inform the user
that it has been placed there. Permanent deletion is a user-only action. The `.recycle-bin/`
folder is listed in `.gitignore` (its contents are never committed), so moved files will not
appear in git history.

---

## QUINARY DIRECTIVE — Review Sub-Agent Constraints

**Review sub-agents launched during a review cycle are strictly READ-ONLY.**

A review sub-agent must:

- Read design files, datasheets, standards, and any other referenced documents.
- Report findings back to the orchestrating session as structured text output.

A review sub-agent must **NOT**:

- Write, create, modify, or delete any file in the repository.
- Create checkpoint files or index entries in `.copilot/checkpoints/`.
- Modify `.copilot/plan.md`, `.copilot/handoff.md`, or `.copilot/review-report.md`.
- Modify `.copilot/agent-directives.md` or any other `.copilot/` artifact.

Only the primary orchestrating session is authorised to write files or create checkpoints.
Any finding that requires a file change must be returned as a finding and actioned by the orchestrator.

---

## SENARY DIRECTIVE — Implementation Authorization and Change Isolation

> ⚠️ **CRITICAL WORKFLOW VIOLATION** — Making file changes during a design discussion or
> evaluation without explicit implementation approval wastes user review time, corrupts git history,
> and can mix unapproved changes with approved ones in the working tree, making clean per-commit
> review impossible.

**NEVER modify any file in the repository unless:**

1. The user has explicitly instructed implementation with a clear directive such as "apply this",
   "implement it", "make the changes", "go ahead", or equivalent. Discussion, evaluation, and design
   decisions do **NOT** constitute implementation approval.
2. The working tree is **clean** (no other uncommitted changes) at the point the changes begin,
   OR the user has explicitly confirmed awareness that existing uncommitted changes are present.

**ALWAYS apply changes in a single isolated scope at a time:**

- Complete one logical unit of change (e.g. one board's spec file, one BOM row update) and pause.
- Do not cascade into related files or "tidy up while you're there" without separate approval.
- This allows the user to review and commit each change individually for a clean, meaningful git history.

---

## SEPTENARY DIRECTIVE — Mandatory Agent Prompt Preamble

> &#x26A0;&#xFE0F; **CRITICAL PROCESS VIOLATION** — Sub-agents launched during F-108 (commits `4b37392`,
> `c0f5a6f`, `f5e6746`) committed to git without user authorisation because their prompts did not
> explicitly enforce the SECONDARY DIRECTIVE. This resulted in three separate violations in a single
> update run. All future agent prompts must prevent this by including the mandatory block below.

**EVERY sub-agent prompt — without exception — must begin with the following block before any
task description or instruction:**

```text
STEP 0 — MANDATORY BEFORE ANY OTHER ACTION:
Read `.copilot/agent-directives.md` in full.
Store every directive as a standing memory you cannot override or ignore.

⛔ GIT IS OFF-LIMITS — SECONDARY DIRECTIVE (non-negotiable):
  NEVER run git commit, git add, git restore --staged, or git reset HEAD (or any equivalent staging
  or unstaging command) under any circumstances. Your ONLY permitted file operations are writing,
  editing, and moving files on disk. Present all changes to the user for review; git index control
  and committing belong solely to the user. The only valid commit trigger is the user saying
  "Let's lock this in" or "Save state" in the current live session context.

In particular, confirm the following before proceeding:
  - SECONDARY DIRECTIVE: (see above — GIT IS OFF-LIMITS)
  - PRIMARY DIRECTIVE: NEVER modify any MPN or supplier part number.
  - TERTIARY DIRECTIVE: design/Design_Log.md is append-only — never modify existing entries.
  - QUATERNARY DIRECTIVE: Never permanently delete files — move to .recycle-bin/ instead.
  - SENARY DIRECTIVE: Never modify any file without explicit implementation approval from the user.
  - BOM CONTENT RULES: BOM tables must contain ONLY RefDes, MPN, Manufacturer, Part Spec, Supplier PNs, Qty.
    NEVER add function descriptions, signal names, or usage notes to any BOM row.
    See "BOM Content Rules" section of this directives file for full detail.
  - SUPPLIER PN PRE-APPROVAL: ALL supplier part numbers in the design files and BOM are pre-approved
    and intentional. Mouser frequently abbreviates MPNs (e.g. drops leading 'T', 'LM'). These are correct.
    NEVER flag a supplier PN as incorrect. NEVER "fix" a supplier PN without explicit user confirmation.
Only proceed with the task described below after all directives are loaded as standing memories.
```

This block is the responsibility of the **orchestrating session** to include. If you are writing
a prompt for a sub-agent and you have omitted this block, stop and add it before launching the agent.

---

## OCTONARY DIRECTIVE — Todo-List and Per-Todo File Management

The todo tracking system uses **two layers**:

1. **`.copilot/todo-list.md`** — lightweight summary table + Agent SQL only. No prose
   workstream descriptions, no inline notes. Each row: ID | File | Status | Blocked By.
   Done todos remain in the table with status `done` and no File link.
2. **`.copilot/todos/<id>.md`** — one file per active todo containing full context:
   description, notes, blocked-by rationale, links to relevant design files.

Rules:

- **SESSION START — MANDATORY FIRST ACTION:** Before any other work, run the Agent SQL
  block from `.copilot/todo-list.md` to seed the session database. The block uses
  `INSERT OR IGNORE` so it is safe to re-run. Steps:
  1. Read the `### Todos` SQL block from `todo-list.md` and execute it via the `sql` tool.
  2. Read the `### Dependencies` SQL block and execute it (wrapped in
     `PRAGMA foreign_keys = OFF/ON` as shown in the file).
  3. Verify the row counts match expectations before proceeding with any task.
  Failure to seed the session DB at startup is a directive violation.

- **KEEPING IN SYNC:** The summary table in `todo-list.md` is the **source of truth for
  status**. The session DB and the Agent SQL block must both stay in sync with it at all
  times:
  - When a todo status changes, update **all three**: summary table, Agent SQL INSERT
    value, and session DB (`UPDATE todos SET status = '...' WHERE id = '...'`).
  - When a new todo is added, insert it into **all three**: summary table row, Agent SQL
    INSERT value, session DB INSERT, and `todo_deps` if it has dependencies.
  - When dependencies change, update **all three**: summary table Blocked By column, Agent
    SQL `todo_deps` INSERT, and session DB `todo_deps` INSERT.

- When a new todo is identified, **both** a row in the summary table **and** a detail
  file in `.copilot/todos/` must be created before the todo is considered tracked.
- When a todo is closed (status → done), remove the File link from the summary table row
  and archive the corresponding detail file to `.recycle-bin/`. Do not delete the row itself.
- Do **not** add prose descriptions, workstream headers, or inline notes to `todo-list.md`.
  All detail belongs in the per-todo `.md` files.
- When writing or updating a per-todo file, use the standard header format:
  `# Title`, `**ID:**`, `**Status:**`, `**Category:**`, `**Source:**`, `**Blocked by:**`,
  then `---`, then `## Description` and `## Notes`.

---

## NONARY DIRECTIVE — KiCAD Library Component Import

> ⚠️ **CRITICAL LIBRARY INTEGRITY RULE** — The project uses a single unified KiCAD library with
> four parallel formats that must remain in sync at all times. Partial imports (e.g. only the new
> format, or only the symbol without the footprint) leave the library in a broken state where legacy
> KiCAD users and legacy CI/export pipelines cannot resolve references. Every import must be
> complete across all formats before source files are retired.

### Library file locations

All files are under `src/Electronics/Library/`:

| Format | File | Notes |
|---|---|---|
| New-format symbol | `SamacSys_Parts.kicad_sym` | KiCAD 6+ `(symbol …)` s-expressions |
| Legacy symbol | `SamacSys_Parts.lib` | EESchema-LIBRARY V2.3, `DEF…ENDDEF` blocks |
| Legacy component descriptions | `SamacSys_Parts.dcm` | `$CMP` blocks |
| Legacy footprint library | `SamacSys_Parts.mod` | PCBNEW-LibModule-V1; has `$INDEX` section (lines ~4–90) + `$MODULE…$EndMODULE` blocks |
| New-format footprint directory | `SamacSys_Parts.pretty/` | One `.kicad_mod` file per footprint |
| 3D model (footprint ref) | `SamacSys_Parts.3dshapes/` | Use `.stp` extension; bare filename — no path prefix |
| 3D model (reference copy) | `3D_Models/` | Use `.step` extension; same base name as `.stp` |

### Source location

Parts to import arrive as zip files in `src/Electronics/Library/temp/`. Each zip typically
contains:
- `KiCad/<PARTNAME>.kicad_sym` — new-format symbol
- `KiCad/<PARTNAME>.kicad_mod` — new-format footprint
- `3D/<PARTNAME>.stp` — 3D model

### Import workflow (run for every part)

**STEP A — Extract** the zip to `src/Electronics/Library/temp/_<source>_extracted/<ZIPNAME>/`.
Do not flatten the extracted structure.

**STEP B — Check what already exists** for this part:
- Does a `(symbol "<PARTNAME>" …)` block exist in `SamacSys_Parts.kicad_sym`?
- Does a `DEF <PARTNAME> …` block exist in `SamacSys_Parts.lib`?
- Does a `<PARTNAME>.kicad_mod` (or equivalent) exist in `SamacSys_Parts.pretty/`?
- Does the footprint already contain a `(model …)` ref?

**STEP C — 3D model (always required):**
1. Copy the `.stp` file to `SamacSys_Parts.3dshapes/<FILENAME>.stp` (keep original filename).
2. Copy the `.stp` file to `3D_Models/<FILENAME>.step` (same base name, `.step` extension).
3. If the footprint exists but has no model ref, add one. Model ref format (unquoted filename,
   legacy style — used consistently across all existing footprints in this library):
   ```
     (model <FILENAME>.stp
       (at (xyz 0 0 0))
       (scale (xyz 1 1 1))
       (rotate (xyz 0 0 0))
     )
   ```
   Insert immediately before the final closing `)` of the `.kicad_mod` file.

**STEP D — Symbol (conditional):**
- If the part already has a symbol in **both** `SamacSys_Parts.kicad_sym` **and**
  `SamacSys_Parts.lib`: **do NOT import the symbol**. Keep the existing entries.
- If the part is new (no symbol in either): add the symbol from the zip to all three:
  `SamacSys_Parts.kicad_sym`, `SamacSys_Parts.lib`, and `SamacSys_Parts.dcm`.

**STEP E — Footprint (conditional):**
- If a footprint already exists in `SamacSys_Parts.pretty/` matching the symbol's footprint
  property: **do NOT replace it** — only add the model ref (STEP C). Replacement is forbidden
  mid-design because pad-position changes break existing PCB layouts.
- If no footprint exists: import the `.kicad_mod` from the zip into `SamacSys_Parts.pretty/`.
  Also add the module to `SamacSys_Parts.mod`:
  - Add the module name to the `$INDEX` section (before `$EndINDEX`).
  - Append a `$MODULE <NAME>…$EndMODULE <NAME>` block before `$EndLIBRARY`, converted from
    the new-format `.kicad_mod` pads using the legacy pad syntax below.
  - Update the footprint property in the symbol (both `SamacSys_Parts.kicad_sym` and
    `SamacSys_Parts.lib`) to reference `SamacSys_Parts:<FOOTPRINTNAME>`.

### Legacy `.mod` pad syntax (for backport of new footprints)

SMD rectangular pad:
```
$PAD
Po <x> <y>
Sh "<num>" R <width> <height> 0 0 0
At SMD N 00888000
Ne 0 ""
$EndPAD
```

NPTH drill hole:
```
$PAD
Po <x> <y>
Sh "" C <diam> <diam> 0 0 900
Dr <diam> 0 0
At HOLE N 00E0FFFF
$EndPAD
```

### Naming conventions

- Footprint file names use the part's canonical name with no vendor prefix (e.g.
  `ERM8-005-XX.X-X-DV-K-TR.kicad_mod`, not `SAMTEC_ERM8-005-XX.X-X-DV-K-TR.kicad_mod`).
- Zip filenames sometimes use dashes where the library uses concatenated names (e.g.
  `LIB_10164227-1004A1RLF.zip` → part `101642271004A1RLF`). Always search the library with
  the normalised (no-dash) form.
- The internal `fp_text value` of a `.kicad_mod` must match the file's base name.

### Completeness gate and retirement

A part import is **complete** when all of the following are true:
1. Symbol is present in `SamacSys_Parts.kicad_sym` and `SamacSys_Parts.lib` / `.dcm`.
2. Footprint `.kicad_mod` is present in `SamacSys_Parts.pretty/` with a valid `(model …)` ref.
3. Footprint module is present in `SamacSys_Parts.mod` (index + `$MODULE` block).
4. Both `SamacSys_Parts.3dshapes/<NAME>.stp` and `3D_Models/<NAME>.step` exist.
5. `src/Electronics/Library/LIBRARY_NOTES.md` is updated — the component inventory table (Section 3) must reflect the new or removed part, and any new naming equivalences must be added to Section 2.

**Only after all four conditions are verified** for a part: move its source zip (and any
extracted files) from `temp/` to `.recycle-bin/library-retired-YYYYMMDD/`. Do **not** delete
anything directly — use the QUATERNARY DIRECTIVE `.recycle-bin/` move.

> ⚠️ **Never remove the `temp/` directory itself.** Only move its contents. The directory must
> remain in place — population and download scripts depend on its existence.

If a condition cannot be satisfied (e.g. no 3D model is available in the zip), document the
gap clearly in the import summary and do **not** retire the zip until the gap is resolved.

### Agent prompt preamble (SEPTENARY DIRECTIVE compliance)

Every sub-agent prompt for a library import task **must** begin with the standard SEPTENARY
DIRECTIVE preamble block (defined under the SEPTENARY DIRECTIVE heading in this file) before
any task-specific instructions. The preamble must be followed immediately by a reference to
this NONARY DIRECTIVE:

```text
Also read and apply the NONARY DIRECTIVE — KiCAD Library Component Import — from this file
before importing any part. All four library formats must be kept in sync. Source files are
retired to .recycle-bin/ only after a complete verified import.
```

---

## Component Data Lookup Order

When researching any component, always use sources in this order:

1. **Reviewed markdown datasheet** — `design/Datasheets/<part>-datasheet.md`
2. **Local PDF datasheet** — `design/Datasheets/<part>-datasheet.pdf`
3. **Ask the user directly** — only if local sources are missing or insufficient

Do **not** perform web searches for component or supplier data. You will be rate-limited or blocked
and it wastes context budget. The user will provide any information that is not locally available.

---

## Document Header Metadata

Design document headers contain several fields (e.g. `Status`, `Version`, `Author`, `Last Updated`,
`Associated Hardware Revision`). The rules for each are:

- **`Last Updated`** — **ALWAYS update** this field to the current date whenever any content change
  is made to the file. This is mandatory; do not skip it.
- **`Version`** — **NEVER update** this field. Version bumps are solely the user's responsibility
  and will only be requested explicitly. The current baseline for all active docs is `v.0.1.0`.
- **All other header fields** (`Status`, `Author`, `Associated Hardware Revision`, etc.) — **NEVER
  update** any of these fields. They are the user's responsibility to manage.

In summary: the only header field an agent may ever change is `Last Updated`.

---

## Design Document Content Rules

- Design specs contain **current design only**. Do not preserve historical details in spec files.
- History belongs in `.copilot/checkpoints/` and `design/Design_Log.md`.
- Never change a component MPN without a corresponding local datasheet review in `design/Datasheets/`.
- Do not raise package-family or footprint-size differences as blocking issues until the user
  explicitly says schematic capture and layout have started. They are irrelevant at the pre-layout stage.
- Connector and mechanical-drawing datasheet markdowns can remain lightweight; fuller detail can
  wait until the initial KiCAD library generation or mechanical modeling phases.

---

## Character Usage Rules

All non-ASCII characters used in design documents (any file outside `.copilot/`) must appear in the
approved table in `.copilot/allowed-character-matrix.md`. Before using any non-ASCII character not
already listed, stop and ask the user for explicit approval. The `.copilot/` directory itself is not
strictly bound by this rule, but new agent-authored content there should follow it as best practice.

---

## Banned Manufacturers

The following manufacturers are **banned from the Enigma-NG BOM entirely**. Do not recommend,
suggest, or add any component from these manufacturers under any circumstances:

- **Murata** (includes all Murata product families: GRM, GCM, BLM, DMR, etc.)

When searching for or recommending components, exclude these manufacturers from all suggestions.
If an existing BOM entry is discovered to carry a banned manufacturer's MPN, flag it as a finding
for user review rather than silently substituting an alternative.

---

## BOM Authority Rules

- Individual board `Design_Spec.md` files are the **authoritative source** for all component data.
- `design/Electronics/Consolidated_BOM.md` is a **derived document** — always rebuilt from board
  specs via `design/Electronics/all_boards_bom.json`. Never edit the consolidated BOM as a primary
  source and then work backwards.
- Supplier PN conventions confirmed by the user:
  - `TPD4E05U06QDQARQ1` → Mouser `595-PD4E05U06QDQARQ1` (drops leading `T`)
  - `LMQ61460AFSQRJRRQ1` → Mouser `595-Q61460AFSQRJRRQ1` (drops leading `LM`)
  - These are correct. Do not alter them.

---

## BOM Content Rules

**A BOM table must contain ONLY the following information:**

| Column | Content |
| :--- | :--- |
| Board (RefDes) | Board identifier and reference designator(s) |
| MPN | Manufacturer part number |
| Manufacturer | Component manufacturer name |
| Part Specification | Value, tolerance, voltage rating, package, etc. |
| DigiKey PN | DigiKey order code |
| Mouser PN | Mouser order code |
| JLCPCB PN | JLCPCB part number |
| Alt Supplier + PN | Alternative supplier and order code |
| Qty columns | Per-board and system quantities |
| Notes | Procurement notes only (e.g. "Order direct from manufacturer", availability flags) |

**The BOM must NEVER contain:**

- Function descriptions or circuit explanations for any designator
- Design rationale or notes about why a part is used
- Signal names, net names, or connectivity information
- Any information that belongs in `Design_Spec.md`, `Board_Layout.md`, or a DR entry

Functional information for any designator belongs in **design body text** (`Design_Spec.md` or
`Board_Layout.md`), not in the BOM. A BOM is a **procurement document**. The supplier does not
need to know the function of a part — only its MPN and quantity.

Do **not** raise the absence of function notes in a BOM as a finding. Do **not** add function notes
to a BOM as a fix. If a BOM row currently contains function notes in a Notes column, those notes
should be removed when that row is next edited for another reason — do not perform a standalone
bulk-cleanup pass for this unless the user explicitly requests a conformity sweep.

---

## Repo-Local State Rules

- `.copilot/` is tracked in git and must stay in sync with meaningful design-state changes.
- At session start, read `.copilot/agent-directives.md` **first**, then `.copilot/plan.md`,
  `.copilot/handoff.md`, and the latest relevant checkpoint(s) in `.copilot/checkpoints/`.
  Load each directive into memory as a standing rule before performing any other work.
- A checkpoint is not complete until all of these are updated and consistent:
  - the new checkpoint file in `.copilot/checkpoints/`
  - `.copilot/checkpoints/index.md`
  - `.copilot/plan.md`
  - `.copilot/handoff.md`
- **Checkpoint numbering:** Repo-local checkpoint files **must always be numbered consecutively**.
  The CLI agent may take more checkpoints internally than the user explicitly requests, but every
  checkpoint written to `.copilot/checkpoints/` gets the next available integer after the current
  highest-numbered file in that folder. Check the folder before writing a new checkpoint and use
  `max_existing_number + 1` as the new number. Never skip numbers or use session-internal counters
  as the file number. **CRITICAL: The session-state folder (e.g. `~/.copilot/session-state/<id>/checkpoints/`)
  uses its own numbering that is completely unrelated to the repo-local sequence. NEVER use the
  session-state checkpoint number as the repo-local checkpoint number. Always determine the correct
  number by reading `.copilot/checkpoints/index.md` or listing the files in `.copilot/checkpoints/`
  and taking `max + 1`.**
- Sanitize all `.copilot/` content for version control: use repo-relative paths or
  `%USERPROFILE%` placeholders instead of machine-specific absolute paths. Do not persist raw
  usernames or session IDs.
- Repo-local helper scripts that should persist across sessions belong in `.copilot/agent-scripts/`.
  `design/Datasheets/_generated_markdown_inventory.json` is the full datasheet index — treat it as
  such, not as a partial single-run artifact.

---

## Deep-Dive Review Cycle

### When to run

Run the deep-dive review cycle when:

- The user explicitly requests it with **"Let's run a review cycle"**, or
- A new major design phase or design todo item is about to be marked complete.

### Review report file

At the start of each review cycle, create `.copilot/review-report.md`. This file is the running
audit log for the entire cycle. It is append-only — each pass adds a new entry; nothing is deleted.
When the cycle is complete and all items are resolved, the file may be deleted.

### Scope of review

Each cycle comprises two complementary review types:

> **IMPORTANT — Global Routing Rules first:** Before reviewing any board's `Design_Spec.md` or
> `Board_Layout.md`, every review agent **must** first read
> `design/Standards/Global_Routing_Spec.md`. Board-level specs and layouts only document
> **exceptions** to global rules, not restatements of them. A board that omits a value covered
> by a global rule is correct, not incomplete. Only raise a finding if a board explicitly claims
> to be exempt from a rule (and the exemption is missing or wrong), or if a board's inline value
> **contradicts** the global rule.

1. **Stand-alone board reviews** — each board's `Design_Spec.md` and `Board_Layout.md` are reviewed
   in isolation for internal consistency, completeness, FR/DR coverage, BOM accuracy, correct
   component values, and **no historical content** (see Design Document Content Rules). A board's
   review agent **must read every file in that board's folder** — all files under
   `design/Electronics/<BoardName>/` are considered part of that board's specification without
   exception. For example, `Rotor_26_Char_Design.md` and `Rotor_64_Char_Design.md` are part of the
   Rotor board's spec and must be read by the Rotor agent; variant qty totals and component details
   in the board-level BOM must be cross-checked against those variant files. These files must
   **not** be delegated to the integration review.

   > **Historical content check (cardinal rule):** Any text in a `Design_Spec.md`,
   > `Board_Layout.md`, or supplementary board doc that records a superseded value, a prior
   > design rationale, a correction note, or any other historical detail **must** be raised as a
   > **HIGH** severity finding. Current design state only. History belongs exclusively in
   > `.copilot/checkpoints/` and `design/Design_Log.md`.

2. **Integration review** — all boards are reviewed together using a single agent that reads the
   GRS first, then every board's `Design_Spec.md` and `Board_Layout.md`, and then all
   top-level/cross-cutting design documents. The integration agent must verify:

   **A. Cross-board connector consistency**
   - For every physical inter-board connection, both sides must specify the same connector type and
     part number (or correctly reference the mating connector)
   - Pinouts must match on both sides: pin N on board A carries the same signal as pin N on board B
   - The "owning" board defines the connector; the receiving board references the owner's definition
   - Check all link interfaces: Link-Alpha (Power Module ↔ Controller), Link-Beta
     (Controller ↔ Stator), Stator ↔ Extension Port, Extension ↔ Rotor(s), Extension ↔ Reflector,
     Stator ↔ Encoder, Controller ↔ JTAG Module, Controller/Stator ↔ Actuation Module,
     Controller ↔ USM

   **B. Cross-board signal name consistency**
   - Any signal that appears on more than one board must use exactly the same name on both boards
   - Active-low signals must carry the `_N` suffix on every board they appear on, per GRS §10

   **C. Top-level design documents** (all files under `design/Electronics/` that are **not** a
   board's `Design_Spec.md` or `Board_Layout.md`)
   - `System_Architecture.md` — verify it accurately reflects the current board set, interface
     names, signal names, and connector descriptions; no stale signal names
   - `Boards_Overview.md` — verify all boards are listed with correct layer/stackup info
   - `Electrical_Design.md` — verify electrical design decisions are consistent with board specs
   - `Power_Budgets.md` — verify power figures match board specs; no board missing from the budget
   - Investigation documents (e.g. `JTAG_Module/JTAG_Integrity.md`,
     `Controller/PoE_Power_Analysis.md`) — verify conclusions are reflected in board specs and
     no open action items remain unresolved
   - `README.md` (repo root) — verify it accurately ties together the electronics, mechanical, and
     software design sections; flag any content that has become stale relative to the current design

   **D. Consolidated BOM cross-check**
   - `design/Electronics/Consolidated_BOM.md` is complete, accurate, and consistent with all
     board-level BOMs

   **E. Historical content check (cardinal rule — applies to every document in scope)**
   - No `Design_Spec.md`, `Board_Layout.md`, supplementary board doc, or top-level design document
     may contain superseded values, prior design rationale, correction notes, or any other
     historical detail. These belong exclusively in `.copilot/checkpoints/` and
     `design/Design_Log.md`. Any violation must be raised as a **HIGH** severity finding.

### Agent execution model

- **BEFORE launching any batch of agents, always call `list_agents` first.** Confirm the number
  of currently running agents. Only launch new agents if the total (existing + new) will not exceed
  4. If a stale agent from a prior run is still active, wait for it to complete or ask the user to
  terminate it before launching new agents. Never assume the slot count is correct from memory.
- Launch all planned review agents in parallel batches of **maximum 4 agents at a time**.
- Each agent is given a specific review scope (e.g. one board, or one cross-board interface pair).
- **Every review agent prompt must begin with the SEPTENARY DIRECTIVE mandatory preamble block**
  (the block defined under the SEPTENARY DIRECTIVE heading in this file). This is non-negotiable.
  The preamble explicitly enumerates all primary directives so the sub-agent cannot miss them.
- Each board-level review agent must read the following in order before reviewing board files:
  1. This file (`agent-directives.md`) in full.
  2. `design\Standards\Global_Routing_Spec.md` — board specs only document **exceptions** to global
     rules. Only raise a finding where a board value explicitly **contradicts** a global rule.
  3. **Every file in the board's folder** (`design\Electronics\<BoardName>\`). All files in that
     folder are part of the board's specification — `Design_Spec.md`, `Board_Layout.md`, and every
     supplementary/variant/analysis doc present (e.g. `Rotor_26_Char_Design.md`,
     `Rotor_64_Char_Design.md`, `JTAG_Integrity.md`, `PoE_Power_Analysis.md`). Do **not** skip any
     file on the grounds that it is a variant or supplementary doc — all are in scope. BOM qty
     totals must be verified against all variant files in the folder.
  4. All datasheets relevant to the board's components from `design\Datasheets\` (markdown first,
     then local PDF; no web search).
  5. The relevant rows in `design\Electronics\Consolidated_BOM.md`.
- Each review agent must adopt the persona of a **senior electronics engineer**: scrutinise the
  design for flaws, missing components, invalid calculations, and datasheet non-compliance. Do not
  produce shallow or summary-only findings.
- All planned review batches must complete before any fixes are applied. Running the fix agent
  mid-cycle would leave the design in a potentially misaligned state while findings from later
  batches are still outstanding.
- Once **all** review batches have completed, run a single **fix agent** that:
  - Attempts to resolve all findings that are **simple, mechanical fixes** based on confirmed design
    details already in the specs (e.g. correcting a cross-reference, filling in a known value,
    fixing a lint error, aligning a BOM row with the board spec).
  - Does **not** fix anything that requires user input, involves a design decision not yet taken,
    or is not definitively resolved in the existing design documentation.
  - Flags all unfixed items clearly so the user can provide decisions.
- After the fix agent completes, run the full set of review batches again as a new pass.
- Repeat (all review batches → single fix agent) until **two consecutive complete review runs
  produce zero findings** at any severity level (HIGH, MEDIUM, or LOW), except for items
  explicitly flagged as requiring user input.
- **The SECONDARY DIRECTIVE applies throughout the entire review cycle.** No git commit may be
  made at any point during a review cycle without explicit user confirmation. All changes
  accumulated during the cycle — including all fix-agent edits — must be presented to the user
  for approval before anything is committed.

### Pass result format

Each review pass entry in `review-report.md` must end with one of:

- `#### Pass N result: clean` — zero findings at any severity
- `#### Pass N result: N findings` — with a categorised table of HIGH / MEDIUM / LOW items and
  which were fixed, which are deferred to user, and which carry over to the next pass

---

## Review Suppression

The following items are intentionally suppressed from automated review cycles. Do not raise them
as findings until the referenced pre-condition is complete.

- **PM-H5 — battery connector suitability review:** The Molex 43650-0519 versus Glenair/ODU
  military replacement review is ongoing; supplier responses are still pending. Do not flag this
  as an issue until the connector review is complete and a decision is recorded in the Design Log.
  See `design/Electronics/Power_Module/Millitary_Battery_Connection_Option.md` for background.

- **MOQ — Minimum Order Quantity:** MOQ values are informational only. Do not raise minimum order
  quantity as a review finding at any severity level. MOQ constraints are addressed at procurement
  time, not design time.

- **ROT-MOQ — Rotor R5/R6 pull-up resistors:** KOA Speer SG73S1ERTTP4701F 4.7kΩ carries Mouser
  MOQ 10,000 and JLCPCB MOQ 49. Accepted for the current batch-build plan. Do not raise as a
  BOM-MOQ finding.

- **KEY_CM5_ACTIVE — Stator keyboard-source select:** Signal is active-high; the active-low variant
  `KEY_CM5_ACTIVE_N` is incorrect. Do not raise the absence of an `_N` suffix on `KEY_CM5_ACTIVE` as
  a review finding.

- **Supplier PN format differences:** Supplier part numbers (Mouser, DigiKey, JLCPCB) routinely
  abbreviate or reformat manufacturer MPNs. These differences are **always correct as written** —
  they have been explicitly verified and approved by the user. Do **not** raise supplier PN format
  differences as review findings at any severity level. Do not suggest that a part number is
  "missing" letters or digits. Do not compare a Mouser/DigiKey/JLCPCB PN to the full manufacturer
  MPN and flag discrepancies. The approved BOM values are intentional and final.

- **CPLD unused I/O pins:** All unused I/O pins on any CPLD (e.g. Intel MAX II EPM570T100I5N, or
  any equivalent device) are assumed not connected. The default treatment in VHDL and the Quartus
  pin-assignment file is to configure each unused pin as an **input with a weak internal pull-up**;
  this avoids floating-input power draw and undefined logic state without requiring external
  components. Boards currently carrying a CPLD: Rotor (U1), Encoder (U1). Raise as a **High**
  severity finding only if unused I/O pins are configured as anything other than input-with-pull-up
  (e.g. output, tri-state, or explicitly left floating).
