## DEC-036 - LINK-BETA Former Monitor Pins Reallocated as Grouped Power Rails

- **Status:** Decided
- **Date:** 2026-04-18
- **Category:** Electrical / Power distribution
- **Area:** Controller Board J2 (LINK-BETA), Stator Board J8, Settings/Servo 5V branch
- **Author:** Izzyonstage & GitHub Copilot

### Summary

Keep LINK-BETA as the 40-pin Samtec ERF8/ERM8 pair from DEC-015, but stop carrying a large legacy
spare block. Reallocate the former ENC monitor positions into grouped power rails: **4 contiguous
5V_MAIN pins**, **3 additional 3V3_ENIG pins**, and **3 additional GND return pins**.

### Problem

After DEC-031 migrated ENC_IN/ENC_OUT monitoring and SYS_RESET_N to Stator-side I²C expanders, a
large section of LINK-BETA remained unused. That left the connector under-utilised while the
Stator-side 5V branch had only 2 pins (1.0A connector capacity) available for the servo and the
Settings Board indicator rail.

### Decision

Retain the 40-pin LINK-BETA connector and apply this active allocation:

| Pin | Signal | Direction | Notes |
| :--- | :--- | :--- | :--- |
| 1 | GND | - | JTAG leading shield |
| 2 | TCK | CTRL→Stator | JTAG clock |
| 3 | GND | - | TCK/TMS inter-pin shield |
| 4 | TMS | CTRL→Stator | JTAG mode select |
| 5 | GND | - | TMS/TDI inter-pin shield |
| 6 | TDI | CTRL→Stator | JTAG data in |
| 7 | GND | - | TDI/GND inter-pin shield |
| 8 | GND | - | Extra JTAG trailing/guard ground |
| 9 | GND | - | JTAG trailing shield |
| 10 | GND | - | Isolation moat pin 1 |
| 11 | GND | - | Isolation moat pin 2 |
| 12 | I2C1_SDA | Bidir | Shared Stator/Settings I²C-1 data extension |
| 13 | I2C1_SCL | Bidir | Shared Stator/Settings I²C-1 clock extension |
| 14 | 5V_MAIN | PM→Stator | Grouped 5V_MAIN feed |
| 15 | 5V_MAIN | PM→Stator | Grouped 5V_MAIN feed |
| 16 | 5V_MAIN | PM→Stator | Grouped 5V_MAIN feed |
| 17 | 5V_MAIN | PM→Stator | Grouped 5V_MAIN feed |
| 18 | GND | - | 5V_MAIN return moat |
| 19 | 3V3_ENIG | PM→Stator | Additional 3V3_ENIG feed |
| 20 | 3V3_ENIG | PM→Stator | Additional 3V3_ENIG feed |
| 21 | 3V3_ENIG | PM→Stator | Additional 3V3_ENIG feed |
| 22 | GND | - | Grouped return for the mixed-power block |
| 23 | GND | - | Grouped return for the mixed-power block |
| 24 | GND | - | Grouped return for the mixed-power block |
| 25 | GND | - | TTD_RETURN leading shield |
| 26 | TTD_RETURN | Stator→CTRL | JTAG TDO short-path return |
| 27 | GND | - | TTD_RETURN trailing shield |
| 28-35 | 3V3_ENIG | PM→Stator | Existing 3V3_ENIG pass-through block |
| 36-40 | GND | - | Main power return block |

### Rationale

- The connector footprint, mating safety, and stack geometry from DEC-015 stay unchanged.
- Grouping all four 5V_MAIN pins together simplifies routing and clearly separates the 5V branch
  from the I²C and JTAG regions.
- 4 x 5V_MAIN pins provide **2.0A connector capacity**, giving ample headroom above the current
  0.74A downstream budget (Settings Board indicators + servo).
- The extra 3V3_ENIG pins make LINK-BETA electrically overprovisioned, so the upstream 3.0A LDO
  remains the only practical 3V3 limit.

### Impact

- Controller / Stator LINK-BETA tables updated to grouped 5V_MAIN, 3V3_ENIG, and GND allocations
- Settings Board and Stator docs updated to source `5V_MAIN` from LINK-BETA pins **14-17**
- Historical Controller probe-access concept repurposed from unused spare pads to power/I²C
  bring-up probes

### Cross-ref

DEC-015 (40-pin connector retained). DEC-031 (freed the former monitor pins). DEC-034
(Settings Board full-RGB 5V indicator branch creates a standing Stator-side 5V load). DEC-040
(all Diagnostics Banks removed from active specs; revisit only during coupon review).
