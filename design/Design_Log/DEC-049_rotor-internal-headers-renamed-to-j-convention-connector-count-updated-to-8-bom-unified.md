## DEC-049 - Rotor Internal Headers Renamed to J-Convention; Connector Count Updated to 8; BOM Unified

- **Status:** Accepted
- **Date:** 2026-05-01
- **Category:** Hardware
- **Area:** Rotor Board - Internal Interconnect; BOM Structure
- **Amends:** DEC-028 (original internal header definition)

### Decision

The four internal rotor interconnect headers previously designated H_SW3, H_PWR, H_JTAG, and
H_SENS are renamed to J7-J14 to follow the established J-prefix convention for all connectors
across the project. The configuration is updated to **eight connectors** (four per board face):
Board A J7/J8 1x5 female RS1-05-G, J11 1x5 male PH1-05-UA, J14 1x7 male PH1-07-UA;
Board B J9 1x5 female RS1-05-G, J10 1x7 female RS1-07-G, J12/J13 1x5 male PH1-05-UA;
**44 pins total**. The Rotor BOM is unified into a single table (rather than split Board A /
Board B) to reflect that rotor boards are manufactured as a single v-scored panel.

### Rationale

- H_SW3/H_PWR/H_JTAG/H_SENS naming was functional rather than positional and inconsistent with all other connector RefDes conventions in the project.
- Enumerating connectors as J7-J14 aligns with the J-prefix standard and makes RefDes unambiguous in BOMs and schematics.
- The connector count of 8 (4 per board face) correctly reflects the physical geometry: each board face independently connects to its mating face, requiring its own set of male/female headers.
- A unified BOM table accurately represents the manufacturing reality: the two halves are produced as a single v-scored panel at JLCPCB, separated only during mechanical assembly.

### Impact

- `design/Electronics/Rotor/Design_Spec.md`: §3.4 J_INT headers updated from H_SW3/H_PWR/H_JTAG/H_SENS to J7-J14 with revised pinouts; BOM unified into single table, FR/DR updated.
- `design/Electronics/Consolidated_BOM.md`: Internal headers updated to J7/J8 RS1-05-G female
  (Board A), J11 PH1-05-UA male, J14 PH1-07-UA male, J9 RS1-05-G female (Board B),
  J10 RS1-07-G female, J12/J13 PH1-05-UA male; 8 headers per rotor assembly (240 total for
  30 rotors).

### Cross-ref

DEC-028 (original split-board architecture and header definition).
