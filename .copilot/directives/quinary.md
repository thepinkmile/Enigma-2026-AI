# QUINARY DIRECTIVE — Review Sub-Agent Constraints

Review sub-agents are **strictly READ-ONLY**.

A review sub-agent **must**:

- Read design files, datasheets, standards, and all referenced documents.
- Report findings to the orchestrating session as structured text output.

A review sub-agent **must not**:

- Write, create, modify, or delete any file.
- Create checkpoint files or index entries.
- Modify `.copilot/plan.md`, `.copilot/handoff.md`, `.copilot/review-report.md`, or any `.copilot/` artifact.

Only the primary orchestrating session may write files or create checkpoints.

---

## Deep-Dive Review Cycle

### When to run

- User says **"Let's run a review cycle"**, or
- A major design phase or todo item is about to be marked complete.

### Review report

Create `.copilot/review-report.md` at cycle start. Append-only — each pass adds a new entry; nothing
is deleted. Delete the file only when the cycle is fully resolved and all items are closed.

### Scope

> **Read `design/Standards/Global_Routing_Spec.md` before any board review.** Board specs only
> document **exceptions** to global rules. Raise a finding only if a board **contradicts** (not
> merely omits) a global rule.

**1. Stand-alone board reviews** — each board's `Design_Spec.md` and `Board_Layout.md` reviewed for
internal consistency, completeness, FR/DR coverage, BOM accuracy, component values, and no historical
content. Read **every file** in the board's folder (`design/Electronics/<BoardName>/`) — no file may
be delegated to the integration review.

> **Historical content (cardinal rule):** Any superseded value, prior design rationale, correction
> note, or historical detail in a `Design_Spec.md`, `Board_Layout.md`, or supplementary board doc
> is a **HIGH** severity finding. Current design state only. History belongs in
> `.copilot/checkpoints/` and `design/Design_Log/`.

**2. Integration review** — single agent reads GRS first, then all boards, then all top-level docs.

**A. Cross-board connector consistency** — both ends of every physical connection must specify the
same connector type and pinout. Check all interfaces: Link-Alpha (PM↔CTL), Link-Beta (CTL↔STA),
STA↔Extension, Extension↔Rotor(s), Extension↔Reflector, STA↔Encoder, CTL↔JTAG Module,
CTL/STA↔Actuation Module, CTL↔USM.

**B. Signal name consistency** — signals on multiple boards must use exactly the same name.
Active-low signals carry `_N` suffix everywhere, per GRS §10.

**C. Top-level documents** (all `design/Electronics/` files that are not a board's `Design_Spec.md`
or `Board_Layout.md`):

- `System_Architecture.md` — current board set, interface names, signal names, connector descriptions
- `Boards_Overview.md` — all boards listed with correct layer/stackup info
- `Electrical_Design.md` — consistent with board specs
- `Power_Budgets.md` — power figures match board specs; no board missing
- Investigation docs — conclusions reflected in board specs; no open action items
- `README.md` — accurate and current; flag stale content

**D. Consolidated BOM** — `design/Electronics/Consolidated_BOM.md` complete and consistent with all
board-level BOMs.

**E. Historical content** — cardinal rule applies to every document in integration scope.

### Agent execution model

- **Before launching any batch: call `list_agents` first.** Only launch new agents if total
  (existing + new) ≤ 4.
- Launch review agents in parallel batches of **max 4 at a time**.
- **Every review agent prompt must begin with the SEPTENARY DIRECTIVE mandatory preamble block**
  (from `.copilot/directives/septenary.md`).
- Each board-level agent reads in order:
  1. `.copilot/directives/index.md` + all directive files
  2. `design/Standards/Global_Routing_Spec.md`
  3. **Every file** in the board's folder — no exceptions
  4. All relevant datasheets from `design/Datasheets/` (markdown first, then PDF; no web search)
  5. Relevant rows in `design/Electronics/Consolidated_BOM.md`
- Agents adopt the persona of a **senior electronics engineer** — scrutinise for flaws, missing
  components, invalid calculations, datasheet non-compliance. No shallow or summary-only findings.
- All review batches must complete before any fixes are applied.
- After all batches: run a single **fix agent** that resolves simple mechanical fixes (correcting
  cross-references, filling known values, fixing lint errors, aligning BOM rows). Does not fix
  anything requiring a design decision. Flags all unfixed items clearly.
- After fix agent: run full review batches again as a new pass.
- Repeat until **two consecutive complete review runs produce zero findings** (except items
  explicitly requiring user input).
- SECONDARY DIRECTIVE applies throughout — no commits without user confirmation.

### Pass result format

Each review pass entry in `review-report.md` ends with one of:

- `#### Pass N result: clean` — zero findings at any severity
- `#### Pass N result: N findings` — categorised table of HIGH / MEDIUM / LOW items; which were
  fixed, which deferred to user, which carry over to the next pass

---

## Review Suppression

Do not raise these as findings:

| Item | Suppression Reason |
| :--- | :--- |
| **PM-H5** — battery connector suitability | Ongoing; awaiting supplier response. See `Power_Module/Millitary_Battery_Connection_Option.md`. |
| **MOQ** — minimum order quantity | Informational only; addressed at procurement time, not design time. |
| **ROT-MOQ** — Rotor R5/R6 pull-up resistors | KOA Speer SG73S1ERTTP4701F; Mouser MOQ 10,000, JLCPCB MOQ 49; accepted for current batch-build plan. |
| **KEY_CM5_ACTIVE** — Stator keyboard-source select | Active-high signal; `_N` suffix is incorrect here. Do not raise absence of `_N`. |
| **Supplier PN format differences** | All supplier PNs are pre-approved and intentional. Mouser/DigiKey/JLCPCB abbreviate MPNs routinely. Never flag as incorrect or "missing" characters. |
| **CPLD unused I/O pins** | Configured as input with weak internal pull-up (VHDL/Quartus default). Raise **HIGH** only if configured otherwise. Boards with CPLDs: Rotor (U1), Encoder (U1). |
