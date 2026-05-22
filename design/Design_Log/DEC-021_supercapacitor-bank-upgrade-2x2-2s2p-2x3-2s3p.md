## DEC-021 - Supercapacitor Bank Upgrade: 2x2 2S2P → 2x3 2S3P

- **Status:** Superseded by DEC-029 (arrangement 2S3P retained; cell capacitance updated 22F → 25F Abracon)
- **Date:** 2026-04-08
- **Category:** Electrical
- **Area:** Power Module - Supercap Bank, Board Layout, Hold-up Specification
- **References:** DR-PM-07, DR-PM-09, DEC-020

### Decision

The supercapacitor bank is upgraded from a 2x2 (4-cell, 2S2P) to a **2x3 (6-cell, 2S3P)** arrangement,
with the inter-cell air gap increased from 2.0mm to **3.0mm**.

| Parameter | Previous | New |
| :--- | :--- | :--- |
| Cell count | 4 (C_SC1-4) | 6 (C_SC1-6) |
| Arrangement | 2x2 | 2x3 |
| Configuration | 2S2P | 2S3P |
| Inter-cell gap | 2.0mm | 3.0mm |
| Cell pitch | 14mm | 15mm |
| Block footprint | 28mm x 28mm | 30mm x 45mm |
| Shadow zone | 32mm x 32mm | 34mm x 49mm |
| Effective capacitance | 22F at 5.4V | 33F at 5.4V |
| Hold-up energy | 72.4J | 108.6J |
| Hold-up duration @ 5W | ≥14.5s | ≥21.7s |
| Charge time (depleted) | ~2 min | ~3 min |

### Rationale

- **50% more hold-up:** 33F vs 22F provides ≥21.7 seconds at 5W - a more comfortable shutdown window
  and headroom for higher CM5 load profiles at prototype bring-up.
- **LTC3350 compatibility:** No IC change required. LTC3350 is configured for 2 cells in series;
  each series position now has 3x22F in parallel (66F per position). CELLS register unchanged.
  RICHARGE (0.5A charge current limit) unchanged; charge time increases ~3 minutes from depleted.
- **Wider gap (3mm):** The increased inter-cell gap from 2.0mm to 3.0mm provides adequate clearance
  for the 2-mil Kapton tape wrap (DEC-020), the conductive elastomer gasket strip, and the aluminium
  enclosure compression ribs, while maintaining margin for manufacturing tolerances.
- **Board space:** The Power Module board dimensions are not yet fixed; the design is being built
  around this component block. The increased footprint (30mm x 45mm vs 28mm x 28mm) is accepted.

> **Post-decision update (2026-04-08, checkpoint 025):** The 22F generic cells specified above
> were subsequently replaced with **Abracon ADCR-T02R7SA256MB (25F/2.7V)** when a verified in-stock
> THT radial supercap was sourced. The 2S3P arrangement and all mechanical dimensions are unchanged.
> Effective capacitance increases from 33F to **37.5F**; hold-up increases from 21.7 s to **≥24.8 s**.
> The values **22F / 33F / 21.7 s** are historical and must not be restored.
