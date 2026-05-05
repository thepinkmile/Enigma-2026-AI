# Checkpoint 112 — CTL-P6-03/04/05 Applied: R4 Pull-Up and PoE Passive Documentation

**Status:** Complete  
**Repo:** thepinkmile/Enigma-NG  
**Branch:** main

## Overview

Applied two Pass 6 design-review findings for the Controller Board:

- **CTL-P6-03:** R4's distinct pull-up function was undocumented; it was grouped in the BOM with
  R1–R3 (series protection resistors) despite serving a different role. Fixed by adding DR-CTL-17
  (body text) and splitting the BOM row into R1–R3 (series protection, qty=3) and R4
  (ACTUATE_REQUEST_N pull-up, qty=1). MPN unchanged (ERJ-3EKF1002V both rows).
- **CTL-P6-04/05:** C12, C15, C16, and C17 appeared in the BOM but had no body-text documentation
  of their functional role. Fixed by adding DR-CTL-18 and a new §7.1 section in the spec.

Changes are staged but NOT committed (SECONDARY DIRECTIVE active).

## Files Modified

| File | Changes |
| :--- | :--- |
| `design/Electronics/Controller/Design_Spec.md` | DR-CTL-17 (R4 pull-up) and DR-CTL-18 (C17 ACF Cclamp) added to §1 DR table; R4 pull-up bullet added to §7 "External Links" note; new §7.1 "PoE Front-End Passive Components" section added for C17 and C12/C15/C16; BOM R1–R4 row split into R1–R3 (qty=3) + R4 (qty=1); BOM Notes updated to cross-reference §7/§7.1 |

## Rationale

**R4 (CTL-P6-03):**
- R1–R3 are 10kΩ series protection resistors on GPIO inputs (PM_IO_INT_N/GPIO5, USB_FAULT_N/GPIO6,
  PWR_GD/GPIO7).
- R4 is a 10kΩ pull-up on `ACTUATE_REQUEST_N` (CM5 GPIO 8, active-low output to AM). It holds the
  line HIGH (inactive) before CM5 firmware configures GPIO 8 as an output, preventing spurious
  actuation during early boot.
- The original R4 on the Controller (33Ω JTAG damping) was removed per DEC-024; the current R4 was
  added later for this distinct function. SW3/SERVO_HOME was retired from the Controller per DEC-043;
  R4 is not a debounce/pull-up for any switch.
- MPN does not change: ERJ-3EKF1002V. Consolidated BOM entry unchanged.

**C17 (CTL-P6-04):**
- 10nF 100V X7R 0402 (KEMET C0402C103K1RACAUTO) — the 100V rating identifies it as a primary-side
  PoE component. No other Controller node exceeds 57V PoE + transient margin.
- In ACF operating mode (selected by DEC-019), TPS23730RMTR (U8) requires a primary-side active-clamp
  capacitor (Cclamp) to store and recycle transformer leakage inductance energy. TI reference designs
  specify 4.7–10nF rated ≥100V. C17 = this Cclamp.

**C12, C15, C16 (CTL-P6-05):**
- All 100nF X7R 50V 0402 (same MPN as the VCC bypass caps). Five of the eight capacitors in this BOM
  group are already documented (C6 VBAT, C13 U2 VCC, C14 U3 VCC, C18 U7 VCC, C19 U8 VCC per
  DR-CTL-15/16). The remaining three (C12, C15, C16) are PoE application-circuit support capacitors.
- Typical application nodes: U7 (TPS2372-4) VAUX auxiliary supply output, U8 (TPS23730) VS auxiliary-
  winding sense input, secondary-output decoupling on VIN_POE_12V.
- Exact per-pin assignments noted as "to be confirmed at schematic capture" in §7.1 (appropriate for
  pre-schematic design spec stage).

## Next Steps

1. User confirms staged changes are correct, then commit.
2. Continue triaging remaining open Pass 6 findings (CTL-P6-02 and lower-priority items from the
   pass6-pending-investigation.md list).
