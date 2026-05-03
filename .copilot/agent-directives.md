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

## SECONDARY DIRECTIVE — Git Commits

> ⚠️ **CRITICAL INTEGRITY VIOLATION** — Committing without authorisation corrupts the repository
> audit trail and removes the user's ability to review, reject, or roll back changes before they
> are permanently recorded. This has already caused a serious violation in this project (commit
> `889cb5c`). A repeat occurrence is an unacceptable breach of trust. There are no exceptions.

**NEVER perform a git commit without explicit user confirmation.**

All changes made to any files in the repository must be reviewed and accepted by the user before
they can be committed into the repository.
Possible user confirmation prompts include:

- "Let's lock this in"
- "Save state"

When using these prompts, you should create a new checkpoint following the "Repo-Local State Rules" before performing the commit.

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

1. The user has explicitly instructed implementation with a clear directive such as “apply this”,
   “implement it”, “make the changes”, “go ahead”, or equivalent. Discussion, evaluation, and design
   decisions do **NOT** constitute implementation approval.
2. The working tree is **clean** (no other uncommitted changes) at the point the changes begin,
   OR the user has explicitly confirmed awareness that existing uncommitted changes are present.

**ALWAYS apply changes in a single isolated scope at a time:**

- Complete one logical unit of change (e.g. one board’s spec file, one BOM row update) and pause.
- Do not cascade into related files or “tidy up while you’re there” without separate approval.
- This allows the user to review and commit each change individually for a clean, meaningful git history.

---

## Component Data Lookup Order

When researching any component, always use sources in this order:

1. **Reviewed markdown datasheet** — `design/Datasheets/<part>-datasheet.md`
2. **Local PDF datasheet** — `design/Datasheets/<part>-datasheet.pdf`
3. **Ask the user directly** — only if local sources are missing or insufficient

Do **not** perform web searches for component or supplier data. You will be rate-limited or blocked
and it wastes context budget. The user will provide any information that is not locally available.

---

## Version Metadata

Do **not** update any document `Version` field unless the user explicitly requests it. Do not infer
version bumps from the scope or significance of changes. The current baseline for all active docs
is `v.0.1.0`.

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
  as the file number.
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
   in isolation for internal consistency, completeness, FR/DR coverage, BOM accuracy, and correct
   component values. A board's review agent must also include **all supplementary docs that belong
   to that board** — for example, `Rotor_26_Char_Design.md` and `Rotor_64_Char_Design.md` are
   scoped to the Rotor board agent, not the integration agent. These variant/supplementary docs
   must **not** be delegated to the integration review.

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
     Stator ↔ Encoder, Controller ↔ JTAG Daughterboard, Controller/Stator ↔ Actuation Module,
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
   - Investigation documents (e.g. `Investigations/JTAG_Integrity.md`,
     `Investigations/PoE_Investigation.md`) — verify conclusions are reflected in board specs and
     no open action items remain unresolved
   - `README.md` (repo root) — verify it accurately ties together the electronics, mechanical, and
     software design sections; flag any content that has become stale relative to the current design

   **D. Consolidated BOM cross-check**
   - `design/Electronics/Consolidated_BOM.md` is complete, accurate, and consistent with all
     board-level BOMs

### Agent execution model

- Launch all planned review agents in parallel batches of **maximum 4 agents at a time**.
- Each agent is given a specific review scope (e.g. one board, or one cross-board interface pair).
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
  KEY_CM5_ACTIVE_N is incorrect. Do not raise the absence of an _N suffix on KEY_CM5_ACTIVE as
  a review finding.
