# Checkpoint 151 — DEC-070 enriched, DS20001952D citations complete, bookkeeping done

**Date:** 2026-05-13
**Follows:** Checkpoint 150 (MCP23017 GPA[7]/GPB[7] review complete)

## Overview

All remaining work for the `mcp23017-gpb7-silicon-fixed-review` todo is now complete. DEC-070 has
been enriched with four supplemental discussion points that previously existed only in the
`.copilot/todos/` discussion file. DS20001952D §1 citations added to all GPA[7]/GPB[7] inline cells
across USM and Stator. Silicon restriction note blocks updated with explicit pin-7-only scope
statements. Todo and discussion file moved to `.recycle-bin/`. Bookkeeping updated.

## Work Done

### DEC-070 enrichment (`design/Design_Log.md`)

- Date corrected: 2026-05-15 → 2026-05-13
- **Context expanded:**
  - Added "regardless of IODIR register state" to main restriction sentence
  - Added pin-7-only scope paragraph with three DS20001952D line citations
    (§1.0 Features lines 76–77, Table 3-21 GPB[7] lines 785–787, Table 3-20 GPA[7] lines 817–819)
  - Added "no publicly known silicon revision removes this restriction" note
- **Decision section expanded:**
  - D4: No part replacement needed — restriction is pin-7 only; 14 other GPIO fully bidirectional;
    CFG_APPLY_N violation (single assignment) resolved by D1; SPI variant (MCP23S17) would remove
    restriction but requires SPI bus wiring — not warranted
  - D5: U6 (Stator I²C 0x20) function = ENC service-bus monitoring — read-only telemetry interface
    for CM5 GUI. Monitors ENC_IN[5:0] + ENC_ACTIVE_KBD_N + ENC_OUT[5:0] + ENC_ACTIVE_LBD_N via
    Stator CPLD. Does NOT intercept, buffer, or drive those signals. All 14 active pins are Inputs
    (GPA[0:6], GPB[0:6]) — no silicon violation. GPA[7] and GPB[7] spare/NC.
- **Rationale expanded:** Added explicit pin-7-only documentation paragraph
- **Files Changed updated:** Both bullets updated to mention silicon note blocks and DS20001952D
  §1 citations

### USM Design_Spec.md (`design/Electronics/User_Settings_Module/Design_Spec.md`)

- U1 GPA[7] inline cell: `(DS20001952D §1)` citation added (done in prior checkpoint)
- U1 GPB[7] inline cell: `(DS20001952D §1)` citation added
- U1 silicon note block inserted: GPA[7] spare/NC; GPB[7] spare/NC; former CFG_APPLY_N violation
  noted as resolved by GPA[6] reassignment per DEC-070
- U2 GPB[7] inline cell: `(DS20001952D §1)` citation added
- U2 silicon note block inserted: GPA[7] = BNK1_B (Output, silicon-compatible); GPB[7] spare/NC
- U3 GPB[7] inline cell: `(DS20001952D §1)` citation added
- U3 silicon note block inserted: GPA[7] = BNK2_R (Output, silicon-compatible); GPB[7] spare/NC

### Stator Design_Spec.md (`design/Electronics/Stator/Design_Spec.md`)

- U6 GPA[7] inline cell: `(DS20001952D §1)` citation added (done in prior checkpoint)
- U6 GPB[7] inline cell: `(DS20001952D §1)` citation added
- U6 note block: expanded with pin-7-only scope sentence; all 14 active signals on GPA[0:6]/GPB[0:6]
- U7 GPA[7] inline cell: `(DS20001952D §1)` citation added; "Output assignment is silicon-compatible"
- U7 GPB[7] inline cell: `(DS20001952D §1)` citation added
- U7 note block: expanded with pin-7-only scope sentence; GPA[7]=SYS_RESET_N (Output, compatible)
- U8 GPA[7] inline cell: `(DS20001952D §1)` citation added
- U8 GPB[7] inline cell: `(DS20001952D §1)` citation added
- U8 note block: expanded with pin-7-only scope sentence; both GPA[7]/GPB[7] spare/NC

### Bookkeeping

- `.copilot/todos/mcp23017-gpb7-silicon-fixed-review.md` → `.recycle-bin/`
- `.copilot/todo-list.md` Last updated line updated to 2026-05-13
- `.copilot/plan.md` — Current Status updated to checkpoint 151; Open Workstreams updated (JTAG
  and MCP23017 removed; 3 remaining); Key Design Decisions updated with DEC-070 summary; next
  checkpoint reference updated; Design_Log append-only note updated to DEC-071
- `.copilot/handoff.md` — 2026-05-13 session result section added at top (two workstreams)
- `.copilot/checkpoints/index.md` — entry 151 appended

## Open Todos (after this checkpoint)

| ID | Status | Notes |
|----|--------|-------|
| `usm-spdt-switch-floating-review` | Pending | No blockers |
| `enc-connector-review-pre-pcb` | Pending | ENC J1/J2 and 100nF cap review |
| `consolidate-design-spec-content` | Pending | Blocked by enc-connector-review-pre-pcb |

## Key Technical Notes

- **CFG_APPLY_N disambiguation:** Two instances, same net name, different roles:
  - USM U1 GPA[6]: **Input** — reads SW11 push button (was GPB[7], fixed per DEC-070)
  - Stator U8 GPA[4]: **Output** — drives CPLD DEV_CLR_N via AND gate U3
  - Intentional; not a conflict

- **DS20001952D citation locations:**
  - §1.0 Features: "Pins GPA7, GPB7 are output only for MCP23017"
  - Table 3-21 GPB[7] Pin Summary: Output only
  - Table 3-20 GPA[7] Pin Summary: Output only

- **User override of TERTIARY DIRECTIVE (one-time):** DEC-070 was modified directly (not
  append-only) because it had not been committed/locked in at the time of modification. This
  override applies ONLY to this session's work. Future entries must still be appended as new DECs.
  Next entry = DEC-071.

- **U6 ENC service-bus monitoring function:** Read-only; monitors Stator CPLD ENC_IN/OUT paths for
  CM5 GUI visibility. Does not intercept or drive the cipher signal paths.
