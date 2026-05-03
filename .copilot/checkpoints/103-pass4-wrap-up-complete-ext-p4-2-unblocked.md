# Checkpoint 171 — Pass 4 wrap-up complete; EXT-P4-2 standoffs confirmed

**Date:** 2026-05-07
**Status:** Pass 4 fully resolved; EXT-P4-2 standoffs unblocked and ready to apply

---

## Summary

All Pass 4 review fixes have been applied and verified lint-clean. The final two
pending items — PM-P4-2 mounting holes and the rotor-refdes-reallocate todo
closure — are now done. The Pass 4 audit trail has been appended to
`.copilot/review-report.md`.

EXT-P4-2 (AM attachment standoffs missing from Extension BOM) is **unblocked**:
the Controller Board already specifies `Wurth 9774040151R` M2.5 x 4.0mm standoffs
for the same ERF8-005-05.0-S-DV-K-TR receptacles (J11/J16 on CTL = J9/J10 on EXT).
This fix is ready to apply but has not yet been committed -- it is the next
task before the post-Pass-4 character normalisation work begins.

---

## Files Modified This Session

| File | Change |
| :--- | :--- |
| `design/Electronics/Power_Module/Design_Spec.md` | PM-P4-2: Added `#### Mounting Holes` subsection to §1; 4x M3 3.2mm PTH non-plated GND_CHASSIS no-BOM. |
| `.copilot/review-report.md` | Appended full Pass 4 findings (Batch 1-3) and fix log (F-88-F-97 + EXT-P4-2 deferred note). |
| `.copilot/todo-list.md` | Marked `rotor-refdes-reallocate` as DONE (both display table and tuple section); updated Last updated date. |

---

## Prior Session Fixes (Pass 4 fixes applied before this checkpoint)

All confirmed lint-clean:

| Fix | File | Change |
| :--- | :--- | :--- |
| CTL-P4-1 (F-88) | `design/Electronics/Controller/Board_Layout.md` | `I2C1_SDA/SCL` -> `I2C_SDA/SCL` |
| CTL-P4-2 (F-89) | `design/Electronics/Controller/Design_Spec.md` | `6.0 mil` -> `0.20 mm (7.87 mil)` |
| EXT-P4-1 (F-90) | `design/Electronics/Extension/Design_Spec.md` | DR-EXT-13 pin 2 -> pin 15 |
| PM-P4-1 (F-91) | `design/Electronics/Power_Module/Design_Spec.md` | BOM note range rewritten |
| STA-P4-1 (F-93) | `design/Electronics/Stator/Board_Layout.md` | `KEY_CM5_ACTIVE_N` -> `KEY_CM5_ACTIVE` x2 |
| STA-P4-2 (F-94) | `design/Electronics/Stator/Design_Spec.md` | DR-STA-12 R39/R40/R41 pull-ups documented; DR-STA-15 R20 pull-up documented; §3 bullets added |
| AM-P4-1 (F-95) | `design/Electronics/Actuation_Module/Board_Layout.md` | `ACTUATION_HOME` -> `ACTUATION_HOME_N` x2 |
| AM-P4-2 (F-96) | `design/Electronics/Actuation_Module/Design_Spec.md` | C4 BOM note + DEC-046 cross-ref |
| INT-P4-1 (F-97) | `design/Electronics/System_Architecture.md` | `ROTOR_EN` -> `ROTOR_EN_N` x2 |
| Agent-directives | `.copilot/agent-directives.md` | `KEY_CM5_ACTIVE` suppression entry added; rotor-variant and integration review scope rules added |

---

## Outstanding Items (pre-Pass-5)

1. **EXT-P4-2** -- Apply `Wurth 9774040151R` M2.5 x 4.0mm standoffs BOM row to
   `design/Electronics/Extension/Design_Spec.md` §6. Ground truth from CTL spec;
   standoff height confirmed as 4.0mm matching ERF8-005-05.0-S-DV-K-TR mated stack.

2. **char-normalise-directives** -- Full non-ASCII character audit across all
   electronics design docs; produce consistency matrix for user approval. Scope:
   em-dash (U+2014), tick marks (U+2714 vs emoji), Omega (U+03A9), mu (U+00B5),
   degree (U+00B0), and any other non-ASCII found. Electronics-specific symbols
   (Omega, mu, degree) expected to stay as UTF-8; punctuation (em-dash) to be
   replaced with ASCII equivalents.

---

## Key Technical Notes

### ERM8/ERF8 Connector Findings

Local datasheets read this session:
- `design/Datasheets/erm8-xxx-xx.x-xxx-dv-xxxx-xx-mkt-datasheet.md`
- `design/Datasheets/erf8-xxx-xx.x-xxx-dv-xxxx-xx-mkt-datasheet.md`

Key finding: `-05.0` in the MPN is the **lead style** (SMT tail length = 5mm), NOT
the mated PCB-to-PCB height. Exact dimensional tables (TABLE 3) are graphical and
not OCR-readable. Ground truth for mated height = 4.0mm from CTL Board spec
(M2.5 x 4.0mm Wurth standoffs already specified for AM attachment with same connector).

### STA-P4-2 Resolution

Stator BOM has 19x 10kOhm resistors; spec documented only 16:
- R2-R6 (5x): SYS_RESET_N, KEY_CM5_ACTIVE, SYS_HALT_N, ALARM_N, OUTPUT_ENABLE_N
  pull-ups
- R16-R26 (11x): rotary encoder, display, buzzer interface pull-ups (includes R20)
- R39-R41 (3x): MCP23017 /RESET pull-ups for U6, U7, U8

R20 (CFG_APPLY_N pull-up on U8 GPA[4]) was already within the R16-R26 range but
undocumented in the spec body.

Separate /RESET pull-ups for each MCP23017 required: U7 GPA[7] drives SYS_RESET_N,
so tying U7 /RESET directly to SYS_RESET_N would create a circular dependency.
