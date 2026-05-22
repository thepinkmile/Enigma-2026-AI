## DEC-070 - MCP23017 I²C Silicon Restriction: GPB[7]/GPA[7] Review and CFG_APPLY_N Reassignment

| Field | Value |
| :--- | :--- |
| **Decision ID** | DEC-070 |
| **Status** | Confirmed |
| **Date** | 2026-05-13 |
| **Author** | Izzyonstage & Copilot |
| **Amends** | USM DR-USM-07 (pin assignment corrected); USM FR-USM-04 (pin cross-reference corrected); DEC-032 bullet 4 (Stator U8 CFG_APPLY_N GPA[4] corrected to GPA[6]) |

### Context

During a silicon restriction review of the MCP23017 I²C GPIO expander (DS20001952D June 2022), it was
confirmed that on the **I²C variant** (MCP23017), pins GPA[7] and GPB[7] are **output-only** - they
cannot be configured as inputs regardless of the IODIR register setting. This restriction does **not**
apply to the SPI variant (MCP23S17).

**Restriction scope - pin 7 only, not port-wide:** The output-only restriction applies exclusively to
pin 7 of each port (GPA[7] and GPB[7]). All 14 remaining GPIO (GPA[0:6] and GPB[0:6]) are fully
bidirectional. The restriction is explicitly documented at three locations in DS20001952D:

- **Section 1.0 Features** (lines 76-77): "Pins GPA7, GPB7 are output only for MCP23017"
- **Table 3-21 - GPB[7] Pin Summary** (lines 785-787): pin type listed as Output only
- **Table 3-20 - GPA[7] Pin Summary** (lines 817-819): pin type listed as Output only

There is no publicly known silicon revision that removes this restriction.

The USM Design_Spec had `CFG_APPLY_N` - an active-low input read from push button SW11 - assigned to
**USM U1 GPB[7]**. Because GPB[7] is output-only, this constitutes a silicon violation: the CM5
firmware cannot read an input state from that pin regardless of IODIR register setting.

All six MCP23017 instances across the Stator (U6 @ 0x20, U7 @ 0x21, U8 @ 0x22) and USM
(U1 @ 0x23, U2 @ 0x24, U3 @ 0x25) were reviewed for GPA[7]/GPB[7] violations.

### Decision

**D1 - CFG_APPLY_N reassignment:** `CFG_APPLY_N` on USM U1 shall be reassigned from **GPB[7]** to
**GPA[6]**. GPA[6] was previously spare; it is a general-purpose bidirectional pin and can be
configured as an input. This provides one spare input pin on GPA[7:0] at GPA[7] (output-only/NC) and
preserves expansion headroom on GPA[5] - no other signals require reassignment.

**D2 - Full instance audit result:** After review, the remaining five instances were found free of
functional violations:

| Board | Ref | Addr | GPA[7] | GPB[7] | Status |
| :--- | :--- | :--- | :--- | :--- | :--- |
| Stator | U6 | 0x20 | spare NC (Output-only) | spare NC (Output-only) | ✅ No violation |
| Stator | U7 | 0x21 | `SYS_RESET_N` Output | spare NC (Output-only) | ✅ No violation |
| Stator | U8 | 0x22 | spare NC (Output-only) | spare NC (Output-only) | ✅ No violation |
| USM | U1 | 0x23 | spare NC (Output-only) | spare NC (Output-only) → was CFG_APPLY_N ❌ | ✅ Fixed by D1 |
| USM | U2 | 0x24 | `BNK1_B` Output | spare NC (Output-only) | ✅ No violation |
| USM | U3 | 0x25 | `BNK2_R` Output | spare NC (Output-only) | ✅ No violation |

**D3 - Documentation:** All six instances shall have complete pin tables with directional details
added to their respective Design_Spec.md files, with explicit silicon restriction notes on GPA[7] and
GPB[7] rows. This replaces the previous practice of noting spare pins without direction information.

**D4 - Part selection confirmed - no replacement required:** A question was raised during review as
to whether the MCP23017 is the correct part given this restriction. **No part replacement is needed.**
The restriction affects only GPA[7] and GPB[7]; the remaining 14 GPIO (GPA[0:6] and GPB[0:6]) are
fully bidirectional and sufficient for all application assignments. The single affected assignment
(CFG_APPLY_N on USM U1) was resolved by reassignment to GPA[6] under D1. No other instance requires
an input on GPA[7] or GPB[7]. The SPI variant (MCP23S17) would remove the restriction but requires
SPI bus wiring changes - a significant design change that is not warranted.

**D5 - U6 ENC service-bus monitoring function:** During review, the role of "ENC service-bus
monitoring" on Stator U6 (0x20) required clarification. U6 functions as a **read-only telemetry
interface** for the CM5: it monitors the live state of the ENC_IN and ENC_OUT cipher signal paths as
they pass through the Stator CPLD, providing software-visible signal-state data for CM5 GUI display
and diagnostics. U6 does not intercept, buffer, or drive those signals. All active assignments are
Inputs; GPA[7] and GPB[7] are spare NC - no silicon violation exists on U6.

| Port/Pin | Signal | Direction | Role |
| :--- | :--- | :--- | :--- |
| GPA[0:5] | `ENC_IN[5:0]` | Input | Cipher data entering CPLD from keyboard encoder |
| GPA[6] | `ENC_ACTIVE_KBD_N` | Input | Selected keyboard-source activity sideband (active-LOW) |
| GPA[7] | - | Output-only (NC) | Silicon restriction (DS20001952D §1); spare/no-connect |
| GPB[0:5] | `ENC_OUT[5:0]` | Input | Cipher data leaving CPLD toward lightboard decoder |
| GPB[6] | `ENC_ACTIVE_LBD_N` | Input | Lightboard output activity sideband (active-LOW) |
| GPB[7] | - | Output-only (NC) | Silicon restriction (DS20001952D §1); spare/no-connect |

**D6 - Stator U8 CFG_APPLY_N corrected from GPA[4] to GPA[6]:** A clerical error was identified
in DEC-032 decision bullet 4, which stated the CM5 firmware pulses `CFG_APPLY_N` on **U8 GPA[4]**.
The user's original design decision was **GPA[6]**: GPA[3:0] carry `CFG_ROUTE[3:0]` outputs;
GPA[4] and GPA[5] are spare NC; GPA[6] is `CFG_APPLY_N` (output, active-low pulse to CPLD
DEV_CLR_N via AND gate U3); GPA[7] is spare NC (output-only, per D1/D2 above). The Stator
Design_Spec.md was corrected manually by the user; USM Design_Spec.md §6 step 4 and USM
Board_Layout.md were updated to match.

### Rationale

The MCP23017 I²C variant restriction is a silicon-level constraint that cannot be worked around in
firmware. Assigning an input signal to GPA[7] or GPB[7] would result in the firmware reading an
indeterminate value (the output latch state) rather than the actual external signal. Detecting this
class of error at design time eliminates a difficult-to-diagnose runtime failure.

Moving `CFG_APPLY_N` to GPA[6] is a minimal, non-disruptive reassignment: no other signals are
displaced, the pin count is identical, and the physical routing change is negligible (adjacent pin on
the same port of the same IC).

Explicit documentation of the restriction as **pin-7-only** (not port-wide) is important for future
maintainers: a reader seeing silicon restriction notes on GPA[7] and GPB[7] could incorrectly infer
a general output-only limitation affecting the entire port and unnecessarily avoid GPA[0:6] or
GPB[0:6] for new input assignments. The specific datasheet citations (Section 1.0 Features lines
76-77; Table 3-21 GPB[7] lines 785-787; Table 3-20 GPA[7] lines 817-819) provide independent
verification without requiring access to session review history.

### Files Changed

- `design/Electronics/User_Settings_Module/Design_Spec.md` - FR-USM-04, DR-USM-07, U1 pin table,
  §4.2 note block, §6 Operation: all references updated from `GPB[7]` to `GPA[6]` for `CFG_APPLY_N`;
  U1/U2/U3 pin tables updated with directional details and GPB[7] Output-only NC rows; silicon
  restriction note blocks added for U1/U2/U3; DS20001952D §1 citation added to all GPA[7]/GPB[7]
  inline cells; §6 step 4 Stator-side reference corrected from `U8 GPA[4]` to `U8 GPA[6]` (per D6);
  Last Updated 2026-05-13
- `design/Electronics/Stator/Design_Spec.md` - U6 pin table added; U7 and U8 pin tables added;
  all tables include directional details and GPA[7]/GPB[7] Output-only NC rows; silicon restriction
  note blocks updated with explicit pin-7-only scope statement; DS20001952D §1 citation added to
  all GPA[7]/GPB[7] inline cells; CFG_APPLY_N on U8 corrected from GPA[4] to GPA[6] (per D6,
  user manually fixed prior to this entry); Last Updated 2026-05-13
- `design/Electronics/User_Settings_Module/Board_Layout.md` - U1 pin table `CFG_APPLY_N` row
  corrected from `GPB[7]` to `GPA[6]`; signal table `SW11` entry corrected from `U1.GPB[7]` to
  `U1.GPA[6]` (per D6); Last Updated 2026-05-13
