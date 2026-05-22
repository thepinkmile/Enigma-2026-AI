## DEC-037 - LINK-BETA Pin Map Regrouped Around Dedicated JTAG and I2C Guard Bands

- **Status:** Decided
- **Date:** 2026-04-18
- **Category:** Electrical / Interconnect definition
- **Area:** Controller Board J2 (LINK-BETA), Stator Board J8, historical Controller bring-up probe concept
- **Author:** Izzyonstage & GitHub Copilot

### Summary

Retain the 40-pin LINK-BETA connector from DEC-015, but replace the DEC-036 allocation with a cleaner
rail-and-guard arrangement: front power cluster, front 3V3 cluster, dedicated guarded JTAG block,
guarded I2C pair, then a rear power cluster. This becomes the only active LINK-BETA pin-definition
table.

### Problem

DEC-036 solved the spare-pin problem, but the resulting active map split `3V3_ENIG` into a small
middle block plus a rear block and left the overall pin order harder to reason about in board docs
and bring-up references. The design intent now is to preserve a dedicated guarded JTAG region, keep
`TTD_RETURN` near that JTAG region, keep I2C shielded, and make the remaining rails cleaner to read
without relying on historical "additional" or "pass-through" distinctions.

### Decision

Adopt this LINK-BETA allocation as the active mapping:

| Pin | Signal | Direction | Notes |
| :--- | :--- | :--- | :--- |
| 1 | GND | - | Front power return / guard |
| 2 | GND | - | Front power return / guard |
| 3 | 5V_MAIN | PM→Stator | Grouped 5V_MAIN feed |
| 4 | 5V_MAIN | PM→Stator | Grouped 5V_MAIN feed |
| 5 | GND | - | Front power return / guard |
| 6 | 3V3_ENIG | PM→Stator | Grouped 3V3_ENIG feed |
| 7 | 3V3_ENIG | PM→Stator | Grouped 3V3_ENIG feed |
| 8 | 3V3_ENIG | PM→Stator | Grouped 3V3_ENIG feed |
| 9 | 3V3_ENIG | PM→Stator | Grouped 3V3_ENIG feed |
| 10 | 3V3_ENIG | PM→Stator | Grouped 3V3_ENIG feed |
| 11 | 3V3_ENIG | PM→Stator | Grouped 3V3_ENIG feed |
| 12 | 3V3_ENIG | PM→Stator | Grouped 3V3_ENIG feed |
| 13 | GND | - | Front 3V3 return / guard |
| 14 | GND | - | Front 3V3 return / guard |
| 15 | TCK | CTRL→Stator | JTAG clock |
| 16 | GND | - | TCK/TMS guard |
| 17 | TMS | CTRL→Stator | JTAG mode select |
| 18 | GND | - | TMS/TDI guard |
| 19 | TDI | CTRL→Stator | JTAG data in |
| 20 | GND | - | TDI/TTD_RETURN guard |
| 21 | TTD_RETURN | Stator→CTRL | JTAG TDO short-path return |
| 22 | GND | - | TTD_RETURN trailing guard |
| 23 | GND | - | JTAG/I2C isolation ground |
| 24 | I2C1_SDA | Bidir | Shared Stator/Settings I²C-1 data extension |
| 25 | GND | - | SDA/SCL guard |
| 26 | I2C1_SCL | Bidir | Shared Stator/Settings I²C-1 clock extension |
| 27 | GND | - | I2C/rear-power isolation ground |
| 28 | GND | - | Rear power guard |
| 29 | 3V3_ENIG | PM→Stator | Grouped 3V3_ENIG feed |
| 30 | 3V3_ENIG | PM→Stator | Grouped 3V3_ENIG feed |
| 31 | 3V3_ENIG | PM→Stator | Grouped 3V3_ENIG feed |
| 32 | 3V3_ENIG | PM→Stator | Grouped 3V3_ENIG feed |
| 33 | 3V3_ENIG | PM→Stator | Grouped 3V3_ENIG feed |
| 34 | 3V3_ENIG | PM→Stator | Grouped 3V3_ENIG feed |
| 35 | 3V3_ENIG | PM→Stator | Grouped 3V3_ENIG feed |
| 36 | GND | - | Rear 3V3 return / guard |
| 37 | 5V_MAIN | PM→Stator | Grouped 5V_MAIN feed |
| 38 | 5V_MAIN | PM→Stator | Grouped 5V_MAIN feed |
| 39 | GND | - | Rear power return / guard |
| 40 | GND | - | Rear power return / guard |

### Rationale

- Preserves a dedicated guarded JTAG block and keeps `TTD_RETURN` adjacent to the other JTAG nets.
- Preserves a separately guarded I2C pair instead of burying it inside a mixed power cluster.
- Keeps **4 x `5V_MAIN` pins = 2.0A connector capacity**, which remains above the current
  **0.74A** downstream Stator-side 5V budget.
- Expands LINK-BETA to **14 x `3V3_ENIG` pins = 7.0A connector capacity**, so the connector remains
  comfortably above the upstream **3.0A** LDO limit.
- Removes active-doc wording distinctions like "additional" or "pass-through" from the pin map; the
  table is now a straightforward interface definition.

### Supersession / Obsolescence

- **DEC-036 is obsolete** and retained only as historical traceability for the prior grouped-rail map.
- The **pin-allocation tables** recorded in **DEC-015** and **DEC-036** are obsolete as active
  interface definitions; DEC-037 is now the sole authority for LINK-BETA pin placement.
- **DEC-031** remains valid as the historical migration of `SYS_RESET_N` and `ENC_IN/ENC_OUT` off the
  connector, but it no longer defines the active pin order.

### Impact

- Controller and Stator LINK-BETA tables updated to the DEC-037 map.
- Power-budget docs updated to the new **7.0A** LINK-BETA `3V3_ENIG` connector capacity.
- Stator/Settings power-feed references updated to the new `5V_MAIN` pins **3, 4, 37, 38**.
- Historical Controller bring-up probe concept remapped to the new LINK-BETA rail and control-pin
  positions.

### Cross-ref

DEC-015 (40-pin connector retained), DEC-031 (functions moved off the connector), DEC-034
(Stator-side 5V indicator load), DEC-036 (obsolete prior grouped-rail map), DEC-040
(all Diagnostics Banks removed from active specs; revisit only during coupon review).
