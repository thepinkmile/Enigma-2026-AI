## DEC-063 - CTL PoE L1 Selection: Yageo PA4343.333NLT (ACF Forward Output Inductor)

| Field | Value |
| :--- | :--- |
| **Decision ID** | DEC-063 |
| **Status** | Confirmed |
| **Date** | 2026-05-09 |
| **Author** | Izzyonstage & Copilot (session e39f3cc4) |
| **Amends** | DEC-062 (L1 "part selection pending" resolved) |

### Context

The ACF Forward topology change (DEC-062) introduced L1 as a new output inductor requirement (DR-CTL-25). Three candidates were evaluated:

- **Würth 74436413300**: Eliminated - oversized body, non-standard 3-pin configuration, and marginal saturation current.
- **Bourns SRP1265A-330M**: Eliminated - carbonyl powder (iron) core. At 200kHz switching frequency, iron-powder cores exhibit
  unacceptable core loss. Hard disqualified by DR-CTL-25 (ferrite only, no iron-powder cores).
- **Yageo PA4343.333NLT**: Only viable option. 33µH ±20%, Isat=11A @30% inductance drop, DCR typ 48mΩ / max 58mΩ, Irms 8A, 13.5×12.5×6.2mm, shielded ferrite SMT, AEC-Q200.

### Decision

**L1 selected: Yageo PA4343.333NLT.** DigiKey: 553-3457-1-ND; Mouser: 673-PA4343.333NLT; JLCPCB: C2453886.
KiCAD footprint downloaded (zip in temp folder, pending library addition at schematic capture stage).

### Rationale

- All three candidates share the same inductance value and nominal Isat figure, but the Würth part has procurement and pin-count drawbacks, and the Bourns part is disqualified on core material grounds.
- Yageo PA4343.333NLT is the only candidate meeting the ferrite core, Isat (≥6A), and form-factor requirements of DR-CTL-25.

### DCR Compliance Note

DR-CTL-25 specifies DCR ≤50mΩ. The Yageo PA4343.333NLT has a typical DCR of 48mΩ (compliant) but a
manufacturer maximum of 58mΩ (non-compliant). This is the best available option at current procurement time;
accepted as a qualified exception. The DR limit is retained at ≤50mΩ and this entry documents the exception.

### Files Changed

- `design/Electronics/Controller/Design_Spec.md`: DR-CTL-25 updated (part selected, DCR exception noted). BOM L1 row updated with MPN and supplier PNs.
- `design/Electronics/Consolidated_BOM.md`: CTL L1 row updated (TBD → PA4343.333NLT with supplier PNs).
