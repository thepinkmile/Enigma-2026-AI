# Checkpoint 153 — CFG_APPLY_N GPA[4]→GPA[6] Correction Complete; DEC-070 Updated

**Date:** 2026-05-13
**Session:** Post-reboot cleanup continuation

---

## Summary

Corrected all design files affected by the `CFG_APPLY_N` pin assignment error introduced in
DEC-032. The erroneous reference was `U8 GPA[4]`; the user's original decision was **GPA[6]**.
The Stator Design_Spec.md was already manually fixed by the user prior to this checkpoint.

Additionally, a spurious DEC-071 (written in error by a previous agent turn before the user
clarified the approach) was removed. The correction was instead incorporated into DEC-070 as
decision point D6, which is the correct location since DEC-070 already covered all MCP23017
pin assignment review activity for this session. DEC-070 was modified in-place with explicit
user authorisation (not yet committed/locked in at time of correction).

---

## Files Changed

- `design/Design_Log.md`
  - Removed erroneously appended DEC-071 block
  - DEC-070 updated in-place (user-authorised):
    - **Amends** field: added "DEC-032 bullet 4 (Stator U8 CFG_APPLY_N GPA[4] corrected to GPA[6])"
    - **D6** decision point added: documents DEC-032 bullet 4 clerical error; confirms GPA[6];
      notes Stator Design_Spec.md user fix + USM files updated to match
    - **Files Changed** — USM Design_Spec.md entry: added §6 step 4 correction note
    - **Files Changed** — Stator Design_Spec.md entry: added GPA[4]→GPA[6] user-fix note
    - **Files Changed** — USM Board_Layout.md entry added

- `design/Electronics/User_Settings_Module/Design_Spec.md`
  - §6 CFG_APPLY_N Button, step 4: "U8 GPA[4]" → "U8 GPA[6]"
  - Last Updated: already 2026-05-13 (no change needed)

- `design/Electronics/User_Settings_Module/Board_Layout.md`
  - U1 pin table: `GPB | [7] | CFG_APPLY_N` row → `GPA | [6] | CFG_APPLY_N`
  - Signal table `SW11` row: `U1.GPB[7]` → `U1.GPA[6]`
  - Last Updated: 2026-04-26 → 2026-05-13

- `design/Electronics/Stator/Design_Spec.md`
  - User manually corrected prior to this checkpoint; no agent edits

---

## Agent Error Note

The previous agent turn in this session wrote a DEC-071 without asking the user whether to
edit DEC-070 in place or append a new entry. When the user clarified that DEC-070 should be
updated directly (as it was not yet locked in), the DEC-071 was removed and the correction
was folded into DEC-070. The agent should have asked before acting.

---

## State After This Checkpoint

- All `CFG_APPLY_N` GPA[4] references corrected to GPA[6] across all design files
- DEC-070 is now authoritative for both the GPB[7]→GPA[6] silicon violation fix (D1) and
  the GPA[4]→GPA[6] clerical correction (D6)
- Next DEC = DEC-071 (no DEC-071 exists in the log)
- No new open workstreams; remaining open todos unchanged from checkpoint 152
