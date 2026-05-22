## DEC-015 - LINK-BETA Connector Reduced from 80-pin to 40-pin (ERF8-020 / ERM8-020)

- **Status:** ✔ RESOLVED
- **Date:** 2026-04-04
- **Category:** Electrical
- **Area:** Controller Board (J2), Stator Board (J8), Consolidated BOM
- **Amended by:** DEC-036 (2026-04-18), DEC-037 (2026-04-18)

### Decision

The LINK-BETA Board-to-Board connector is reduced from 80-pin (ERF8-040 / ERM8-040) to **40-pin
(ERF8-020-05.0-S-DV-K-TR / ERM8-020-05.0-S-DV-K-TR)**. The table below records the original
post-reduction allocation; the current active allocation is defined by **DEC-037**.

| Pin | Signal | Direction | Notes |
| :--- | :--- | :--- | :--- |
| 1 | GND | - | JTAG leading shield |
| 2 | TCK | CTRL→Stator | JTAG clock |
| 3 | GND | - | TCK/TMS inter-pin shield |
| 4 | TMS | CTRL→Stator | JTAG mode select |
| 5 | GND | - | TMS/TDI inter-pin shield |
| 6 | TDI | CTRL→Stator | JTAG data in |
| 7 | GND | - | TDI/SPARE inter-pin shield |
| 8 | SPARE | - | Freed by DEC-031 (was SYS_RESET_N - migrated to I²C U7 GPA[7] @ 0x21) |
| 9 | GND | - | JTAG trailing shield |
| 10 | GND | - | Isolation moat pin 1 |
| 11 | GND | - | Isolation moat pin 2 |
| 12 | SPARE | - | Freed by DEC-031 (was ENC_IN[0] - migrated to I²C U6 @ 0x20) |
| 13 | SPARE | - | Freed by DEC-031 (was ENC_IN[1]) |
| 14 | SPARE | - | Freed by DEC-031 (was ENC_IN[2]) |
| 15 | SPARE | - | Freed by DEC-031 (was ENC_IN[3]) |
| 16 | SPARE | - | Freed by DEC-031 (was ENC_IN[4]) |
| 17 | SPARE | - | Freed by DEC-031 (was ENC_IN[5]) |
| 18 | GND | - | Inter-group shield |
| 19 | SPARE | - | Freed by DEC-031 (was ENC_OUT[0] - migrated to I²C U6 @ 0x20) |
| 20 | SPARE | - | Freed by DEC-031 (was ENC_OUT[1]) |
| 21 | SPARE | - | Freed by DEC-031 (was ENC_OUT[2]) |
| 22 | SPARE | - | Freed by DEC-031 (was ENC_OUT[3]) |
| 23 | SPARE | - | Freed by DEC-031 (was ENC_OUT[4]) |
| 24 | SPARE | - | Freed by DEC-031 (was ENC_OUT[5]) |
| 25 | GND | - | ENC_OUT / TTD_RETURN shield |
| 26 | TTD_RETURN | Stator→CTRL | JTAG TDO short-path return (bypasses rotor stack) |
| 27 | GND | - | TTD_RETURN shield |
| 28-35 | 3V3_ENIG | PM→Stator | Power pass-through from Link-Alpha; 8 pins x 0.5A = 4.0A |
| 36-40 | GND | - | Power return (5 pins) |

### Rationale

Logic boards downstream of the Stator (Encoder, Reflector, Extension) are 3V3-only - they require
no 5V_MAIN rail. Removing 5V_MAIN from LINK-BETA and rationalising the signal set results in exactly
40 signals. The JTAG block has 5 internal GND shield pins (self-shielded at low-moderate MHz), so only
a 2-pin GND moat is needed between JTAG and the data zone. 8 x 3V3_ENIG pins deliver 4.0A - adequate
for the worst-case 30-rotor stack (2.11 A per Power_Budgets.md). 5 GND return pins plus the 10 other GND pins throughout the
connector provide adequate return paths.

### Poka-Yoke Safety Note

The 80-pin LINK-ALPHA (ERF8-040) and 40-pin LINK-BETA (ERF8-020) on the Controller Board are
**physically incompatible** - the mating connectors cannot be inserted into the wrong socket. This
provides a mechanical safeguard against mismating during prototype bring-up.

### Alternatives Considered

Keeping 80-pin connector with unused pins. Rejected: unnecessary connector cost and PCB area; larger
connector on the Stator increases stack height with no benefit.

### Impact

- Controller J2: ERF8-040 → ERF8-020-05.0-S-DV-K-TR (female, 40-pin)
- Stator J8: ERM8-040 → ERM8-020-05.0-S-DV-K-TR (male, 40-pin)
- DEC-014 connector table updated (see cross-ref below).

### Cross-ref

DEC-014 (gender assignment rationale remains valid; part numbers updated). DEC-031
(pins 8, 12-17, and 19-24 freed - SYS_RESET_N and ENC_IN/OUT migrated to I²C).
DEC-036 (freed monitor block reallocated into grouped 5V_MAIN / 3V3_ENIG / GND rails).
