## DEC-079 - C20 Voltage Rating Correction: 25V → 35V (Amends DEC-072 BOM Item 1)

| Field | Value |
| --- | --- |
| **ID** | DEC-079 |
| **Status** | Accepted |
| **Date** | 2026-05-18 |
| **Author** | Izzyonstage & GitHub Copilot |
| **Amends** | DEC-072 (BOM item 1 - C20 part number CGA9N3X7R1E476M230KB) |

### Context

DEC-072 BOM item 1 added C20 (47µF bulk output decoupling capacitor on the 12V output rail of the Controller PoE power converter) to the Consolidated BOM as MPN CGA9N3X7R1E476M230KB
(TDK CGA series, 47µF 25V X7R 2220).

During Pass 9 review (finding CTL-P9-02, captured in DEC-072), the reviewer flagged that the 12V rail requires a capacitor rated to at least 30V minimum to satisfy the standard 2.5×
voltage derating rule (12V × 2.5 = 30V minimum rated). A 25V rated capacitor on a 12V rail violates this derating requirement.

DEC-072 recorded this finding and suggested a replacement MPN, but the suggested replacement was subsequently found to be invalid. The user independently sourced the correct 35V replacement: CGA9N1X7R1V476M230KC.

### Decision

C20 is corrected to:

- **MPN:** CGA9N1X7R1V476M230KC
- **Specification:** 47µF, 35V, X7R, 2220 package, TDK CGA series
- **Derating check:** 12V × 2.5 = 30V minimum; 35V rated ✓ - compliant

The superseded part CGA9N3X7R1E476M230KB (25V) must be removed from all locations.

### Affected Files

- `design/Electronics/Consolidated_BOM.md` - C20 row: replace CGA9N3X7R1E476M230KB with CGA9N1X7R1V476M230KC; add DEC-079 citation
- `design/Electronics/Controller/PoE_Power_Analysis.md` - §7.2: replace CGA9N3X7R1E476M230KB and "25V minimum" wording with CGA9N1X7R1V476M230KC (47µF 35V); add DEC-079 cross-reference
