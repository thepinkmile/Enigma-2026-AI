## DEC-080 - Retrospective: PM and Stator Dock Connector Redesignation (Amends DEC-038)

- **Status:** Decided
- **Date:** 2026-05-18
- **Category:** Naming / Identifier Conventions
- **Area:** Controller Board, Power Module, Stator — dock connectors
- **Author:** Izzyonstage & GitHub Copilot

### Summary

Retire the alphabetic-suffix designator scheme introduced by DEC-038 for the
Controller ↔ Power Module and Controller ↔ Stator dock connectors. Replace with
plain integer designators that eliminate gaps and reflect each connector's
distinct purpose.

### Problem

DEC-038 introduced suffixed families `J1A / J1B / J1C` (PM dock) and `J2A / J2B`
(Stator dock) on the Controller and Power Module boards. This scheme has two
structural defects:

1. **False kinship.** Sharing a base designator (`J1`, `J2`) implies the
   suffixed connectors form a replicated set of identical-function components
   (analogous to `C1-C5` or `U3-U10`). The three PM dock connectors carry
   entirely different signal types (rails, PoE aux, control/telemetry) and the
   two Stator dock connectors carry different power domains. The suffix convention
   misrepresents their relationship.

2. **Identifier gaps.** Using `J1A / J1B / J1C` consumed the `J1` slot on the
   PM and Controller while leaving `J2` and `J3` (as plain integers) absent from
   the BOM, FR, and DR tables. Similarly, `J2A / J2B` on the Controller left `J3`
   absent before `J4`. Project convention requires no gaps in integer identifier
   sequences across FR, DR, and BOM tables.

### Decision

#### Controller Board

| Old designator (DEC-038) | New designator | Function |
| :--- | :--- | :--- |
| `J1A` | `J1` | PM main regulated rails — `3 x 5V_MAIN`, `2 x 3V3_ENIG`, `5 x GND` |
| `J1B` | `J2` | PM PoE auxiliary handoff — `3 x VIN_POE_12V`, `7 x GND` |
| `J1C` | `J3` | PM control / telemetry — I2C, `PM_IO_INT_N`, `PWR_GD`, `ROTOR_EN_N`, etc. |
| `J2A` | `J4` | Stator 5V-biased power dock — `4 x 5V_MAIN`, `1 x GND` blade |
| `J2B` | `J5` | Stator 3V3 / logic dock — `4 x 3V3_ENIG`, `1 x GND` blade, JTAG/I2C signal field |

#### Power Module

| Old designator (DEC-038) | New designator | Function |
| :--- | :--- | :--- |
| `J1A` | `J1` | Main regulated rails to Controller |
| `J1B` | `J2` | PoE auxiliary handoff to Controller |
| `J1C` | `J3` | Control / telemetry to Controller |

#### Stator

Stator dock connector designators `J11` (5V-biased dock, mates with CTL `J4`)
and `J12` (3V3 / logic dock, mates with CTL `J5`) are unchanged and were not
affected by the DEC-038 suffix scheme.

### Rationale

- Distinct purposes warrant distinct base designators, consistent with all other
  boards in the system.
- Sequential integer designators eliminate the FR/DR/BOM identifier gaps that
  violated project convention.
- Plain integer numbering is unambiguous and aligns with the designator practice
  used on every other board without exception.

### Amends / Supersedes

- **DEC-038** — supersedes the `J1A/J1B/J1C` and `J2A/J2B` naming decisions
  only; all other DEC-038 decisions (dock architecture, connector families, rail
  allocation, grounding rule) remain in force.
