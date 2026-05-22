## DEC-064 - CTL PoE C17 Final Part Selection: Kemet C0805C223K2RACAUTO (22nF 200V X7R 0805)

| Field | Value |
| :--- | :--- |
| **Decision ID** | DEC-064 |
| **Status** | Confirmed |
| **Date** | 2026-05-09 |
| **Author** | Izzyonstage & Copilot (session e39f3cc4) |
| **Amends** | DEC-062 (C17 MPN "update pending" resolved); DR-CTL-18 package and voltage updated |

### Context

DEC-062 updated C17 value from 10nF to 22nF but deferred MPN selection.
Worst-case Vclamp = Vin×D/(1−D) = 36×0.667/0.333 = 72V.
A 100V-rated 22nF X7R MLCC in 0402 package was initially specified in DR-CTL-18; two problems emerged:

1. **Package constraint:** 22nF at 100V+ cannot fit in 0402 - 0603 is the minimum practical package for this voltage/capacitance combination in X7R.
2. **DC bias derating:** At 72V/100V = 72% of rating, X7R capacitance degrades by approximately 25-35%,
   leaving effective capacitance of only 15-18nF - significantly below the 22nF target and approaching the 19.9nF minimum from DR-CTL-18.

A 200V-rated 0805 part resolves both issues: at 72V/200V = 36% of rating, DC bias derating is only ~5%, giving effective capacitance of ~21nF - compliant with DR-CTL-18.

### Decision

**C17 selected: Kemet C0805C223K2RACAUTO** (22nF, 200V, X7R, 0805, ±10%, AEC-Q200). DigiKey: 399-17630-1-ND; Mouser: 80-C0805C223K2RAUTO; JLCPCB: C3843023.

Package and voltage rating in DR-CTL-18 updated from `100V 0402` to `200V 0805`.

The Open Mode (J-series, FO-CAP) variant (C0805J223K2RACAUTO) was considered - it provides fail-open behaviour
as a reliability enhancement - but is not stocked at JLCPCB.
The standard C-series hard-termination part (C0805C223K2RACAUTO) satisfies all electrical requirements;
Open Mode is a desirable reliability enhancement but not an electrical necessity for this application.

### Rationale

- 200V rating eliminates meaningful DC bias derating and ensures the part operates within its characterised range at all PoE operating points.
- 0805 package is a standard JLCPCB machine-placeable size with excellent availability.
- Kemet C-series X7R is a well-characterised commodity MLCC; AEC-Q200 automotive qualification maintained.
- JLCPCB LCSC number C3843023 confirmed as in-stock.

### Files Changed

- `design/Electronics/Controller/Design_Spec.md`: DR-CTL-18 package/voltage updated (100V 0402 → 200V 0805). BOM C17 row updated (TBD → C0805C223K2RACAUTO with supplier PNs and corrected spec).
- `design/Electronics/Consolidated_BOM.md`: CTL C17 row updated (C0402C103K1RACAUTO → C0805C223K2RACAUTO with supplier PNs).
