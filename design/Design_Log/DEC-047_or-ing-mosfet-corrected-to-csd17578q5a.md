## DEC-047 - OR-ing MOSFET Corrected to CSD17578Q5A

- **Status:** Decided
- **Date:** 2025-07-05
- **Category:** Component Selection / Part Number Correction
- **Area:** Power Module (Q1, Q2, Q3)
- **Author:** Izzyonstage & GitHub Copilot

### Summary

The OR-ing MOSFET for the Power Module ideal-diode circuit was incorrectly specified as CSD17483F4T.
This has been corrected to **CSD17578Q5A**.

### Problem

Q1, Q2, and Q3 (LM74700-Q1 ideal-diode OR-ing MOSFETs) were listed as CSD17483F4T with a
description of "30V 10A SON-8". The local datasheet (`csd17483f4-datasheet.md`) confirmed this part
is actually a 1.5A / 260mΩ / PICOSTAR YJC 3-pin FemtoFET - completely unsuitable for an OR-ing
application handling multi-ampere input currents.

### Decision

Replace CSD17483F4T with **CSD17578Q5A** (TI NexFET N-channel MOSFET):

- V_DSS: 30V
- I_D: 25A continuous (package limited), 59A (silicon limited)
- R_DS(on): 5.9mΩ @ V_GS = 10V; 7.9mΩ @ V_GS = 4.5V
- Package: SON 5x6mm
- DigiKey: `296-48512-1-ND` | Mouser: `595-CSD17578Q5A` | JLCPCB: `C2871447`

### Rationale

CSD17578Q5A is designed specifically for point-of-load and OR-ing converter applications. Its 5.9mΩ
R_DS(on) provides extremely low conduction losses, and 25A package rating gives adequate headroom
above the expected OR-ing path current. The LM74700-Q1 gate-drive requirements (charge-pump +7V above
source) are fully compatible with this device's ±20V V_GS limit.

### Alternatives Considered

| Alternative | Reason rejected |
| :--- | :--- |
| Retain CSD17483F4T | Incorrect part - 1.5A FemtoFET cannot handle OR-ing path currents |
| Other SON-8 OR-ing MOSFETs | CSD17578Q5A already approved and datasheet verified; no need to evaluate alternatives |

### Impact

- `design/Electronics/Power_Module/Design_Spec.md`: Q1/Q2/Q3 MPN, PNs, and specs updated.
- `design/Electronics/Consolidated_BOM.md`: CSD17578Q5A row replaces CSD17483F4T.
- `design/Electronics/all_boards_bom.json`: Updated accordingly.

### Cross-ref

`design/Electronics/Power_Module/Design_Spec.md §5` (Q1, Q2, Q3 BOM row),
`design/Datasheets/TI-csd17578q5a-datasheet.pdf`.
