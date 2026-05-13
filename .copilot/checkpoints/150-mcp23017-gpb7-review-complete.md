# Checkpoint 150 — MCP23017 GPA7/GPB7 Review Complete

**Date:** 2026-05-13  
**Status:** ✅ Complete  
**Preceding checkpoint:** 149-mcp23017-gpb7-discussion-points-responded.md

---

## What Was Accomplished

The full MCP23017 I²C silicon restriction review (`mcp23017-gpb7-silicon-fixed-review`) is complete.
All six MCP23017 instances across the Stator and USM have been audited, violations resolved, pin tables
added, and directional details documented. A Design_Log DEC entry has been appended.

### Files Changed

| File | Changes |
| :--- | :--- |
| `design/Electronics/User_Settings_Module/Design_Spec.md` | CFG_APPLY_N moved GPB[7]→GPA[6]; all cross-refs updated (FR-USM-04, DR-USM-07, note block, §6 intro, §6 operation); U1/U2/U3 pin tables updated with directional details and GPB[7] Output-only NC rows |
| `design/Electronics/Stator/Design_Spec.md` | U6 pin table added; U7 pin table added; U8 pin table added; all include directional details and GPA[7]/GPB[7] Output-only NC silicon notes |
| `design/Design_Log.md` | DEC-070 appended (MCP23017 silicon restriction review + CFG_APPLY_N reassignment) |
| `.copilot/todos/mcp23017-gpb7-silicon-fixed-review.md` | Status updated to Complete; work-remaining table all marked Done |
| `.copilot/todo-list.md` | `mcp23017-gpb7-silicon-fixed-review` status → `done` |

---

## Key Technical Facts

### Silicon Restriction
- GPA[7] and GPB[7] are **output-only** on MCP23017 (I²C variant) — DS20001952D §1
- All other 14 pins (GPA[0:6], GPB[0:6]) are fully bidirectional
- SPI variant (MCP23S17) does NOT have this restriction

### Instance Status (All Resolved)

| Board | Ref | Addr | GPA[7] | GPB[7] | Status |
| :--- | :--- | :--- | :--- | :--- | :--- |
| Stator | U6 | 0x20 | spare NC (Output-only) | spare NC (Output-only) | ✅ Safe |
| Stator | U7 | 0x21 | `SYS_RESET_N` Output | spare NC (Output-only) | ✅ Safe |
| Stator | U8 | 0x22 | spare NC (Output-only) | spare NC (Output-only) | ✅ Safe |
| USM | U1 | 0x23 | spare NC (Output-only) | spare NC (Output-only) | ✅ Fixed |
| USM | U2 | 0x24 | `BNK1_B` Output | spare NC (Output-only) | ✅ Safe |
| USM | U3 | 0x25 | `BNK2_R` Output | spare NC (Output-only) | ✅ Safe |

### CFG_APPLY_N Signal
- USM U1 GPA[6]: reads SW11 button (Input) — **was** GPB[7], now GPA[6]
- Stator U8 GPA[4]: drives CPLD AND gate (Output) — separate signal, always correct

---

## Remaining Open Todos

From `.copilot/todo-list.md` (pending):

- `enc-connector-review-pre-pcb` — pending
- `consolidate-design-spec-content` — pending (blocked on `enc-connector-review-pre-pcb`)
- `usm-spdt-switch-floating-review` — pending

---

## Next Steps

Any of the remaining pending todos may be picked up. Suggested candidates:

1. **`usm-spdt-switch-floating-review`** — floating-pin analysis for USM SPDT switches
2. **`enc-connector-review-pre-pcb`** — pre-PCB connector review; unblocks `consolidate-design-spec-content`
