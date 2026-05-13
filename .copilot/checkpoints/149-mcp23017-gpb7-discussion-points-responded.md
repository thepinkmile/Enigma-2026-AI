# Checkpoint 149 — MCP23017 GPB7 Discussion Points Responded; Diagram Fixed

**Session checkpoint:** 008  
**Design log context:** 149  
**Date:** 2026-05-13

---

## What Was Accomplished

1. **Responded to all four user discussion points** from the MCP23017 GPA7/GPB7 review:

   - **Point 1 (GPB[6] same violation?):** Clarified definitively — NO. The output-only
     restriction is specific to pin 7 only (GPA7 and GPB7). GPB[6] and all other 14 GPIO are
     fully bidirectional. Moving `CFG_APPLY_N` to GPB[6] is a valid fix. No part replacement needed.

   - **Point 2 (create discussion document):** Created
     `.copilot/todos/mcp23017-gpb7-silicon-fixed-review.md` with full findings, confirmed
     violations, proposed fixes, open gaps, and all conversation history.

   - **Point 3 (fix diagram error — user approved):** Fixed `U3 --> SW11` → `U1 --> SW11`
     in `design/Electronics/User_Settings_Module/Design_Spec.md`. Updated `Last Updated` to
     2026-05-13.

   - **Point 4 (what is ENC service-bus monitoring?):** Confirmed U6 monitors
     ENC_IN[5:0] + ENC_OUT[5:0] = 12 input signals. Hypothesis: GPA[7] and GPB[7] are spare.
     A detailed U6 pin table does not exist — this is a documentation gap requiring resolution.

2. **Part replacement assessment:** Confirmed MCP23017 is the I²C GPIO expander.
   Only GPA7 and GPB7 are output-only (2/16 pins). If U6 signals fit within GPA[0:6] and
   GPB[0:6] (likely), **no part replacement is needed**. All proposed fixes are
   documentation/schematic changes only.

---

## Files Modified This Session

- `design/Electronics/User_Settings_Module/Design_Spec.md`
  - Line 102: `U3 --> SW11` → `U1 --> SW11` (Mermaid diagram correction)
  - `Last Updated` updated to 2026-05-13

- `.copilot/todos/mcp23017-gpb7-silicon-fixed-review.md` — **created** (new discussion document)

---

## Files NOT Yet Modified (Awaiting Approval)

- `design/Electronics/User_Settings_Module/Design_Spec.md` — pin table and FR/DR references
  (GPB[7] → GPB[6] move; GPA[4:7] spare row split; §6 section; FR-USM-04; DR-USM-07)
- `design/Electronics/Stator/Design_Spec.md` — U6 pin table (documentation gap)
- `design/Design_Log.md` — no DEC entry yet

---

## Open Questions / Next Steps

1. Confirm U6 ENC service-bus monitoring pin assignments — does any monitoring signal land on
   GPA[7] or GPB[7]? (Likely spare, but requires explicit resolution and pin table.)
2. Once U6 is resolved: get user approval to apply all remaining USM fixes
   (GPB[7] → GPB[6] across pin table, FR-USM-04, DR-USM-07, §6).
3. Determine if a DEC entry is needed for the GPB[7] → GPB[6] reassignment.
4. Update `todo-list.md` to `done` and save state.

---

## SQL Todo Status

- `mcp23017-gpb7-silicon-fixed-review` → still `in_progress`
