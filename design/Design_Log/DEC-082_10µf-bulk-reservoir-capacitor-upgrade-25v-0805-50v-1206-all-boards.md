## DEC-082 - 10µF Bulk Reservoir Capacitor Upgrade: 25V 0805 → 50V 1206, All Boards

| Field | Value |
| :--- | :--- |
| **Decision ID** | DEC-082 |
| **Status** | Confirmed |
| **Date** | 2026-05-21 |
| **Author** | Izzyonstage & GitHub Copilot |
| **Amends** | DEC-068 (Q2/Q3 bulk output cap spec only) |

### Context

All boards in the system carry 10µF X7R bulk/reservoir capacitors at power-entry nodes per
`design/Standards/Global_Routing_Spec.md §3.2`. At the time of initial BOM population these were
specified as Samsung CL21B106KAYQNNE (10µF X7R 25V 0805), which was the smallest cost-effective
part available. A total of 87 placements exist across 11 boards (PM, CTL, USM, ENC, AM, STA, REF,
EXT, ROT-26, ROT-64).

DEC-046 established that bypass/decoupling capacitors (100nF, 1µF) must be rated 50V on all
non-PM boards. The bulk/reservoir capacitors were categorised separately and retained at 25V under
DEC-068's derating justification (5× at 5V_MAIN, 7.6× at 3V3_ENIG). While that derating is
technically adequate, it differs from the 50V standard applied to all bypass/decoupling caps.

### Decision

Standardise all 10µF X7R bulk/reservoir capacitors across all boards to:

**Samsung CL31B106KBK6PJE — 10µF X7R 50V ±10% 1206 (AEC-Q200, Pb-free Ni/Sn termination)**

Datasheet: `design/Datasheets/Samsung-CL31B106KBK6PJ-datasheet.md`

This part replaces CL21B106KAYQNNE at all 87 positions on all 11 boards. No change to capacitor
value, tolerance, or temperature characteristic (X7R, −55°C to +125°C, ±15%).

### Rationale

- Brings all bulk/reservoir caps into the same 50V voltage-rating family as bypass/decoupling caps,
  eliminating the rating inconsistency flagged during Pass-10 review.
- Improved derating: 50V rated at 5V = 10×; at 3.3V = 15.2× (vs 5× / 7.6× previously).
- Samsung CL31B106KBK6PJE carries an explicit Pb-free Ni/Sn termination declaration (RoHS) and
  AEC-Q200 automotive qualification — equivalent or better than the outgoing part.
- Package-size change (0805 → 1206) is not a blocking concern per project convention: schematic
  capture and PCB layout have not started; footprint selection is deferred to layout.
- Stays within the Samsung MLCC family already used across the BOM.

### Impact

- Consolidated BOM row updated: CL21B106KAYQNNE → CL31B106KBK6PJE, spec 10µF X7R 25V 0805 →
  10µF X7R 50V 1206.
- All 11 board Design_Spec.md BOM tables updated accordingly.
- DR-PM-17 and DR-PM-18 derating figures updated: 5× → 10× and 7.6× → 15.2× respectively.
- Supplier part numbers (DigiKey, Mouser, JLCPCB) to be confirmed at procurement.

### Amends / Supersedes

- **DEC-068** — Q2 (5V_MAIN output bulk, C68-C72) and Q3 (3V3_ENIG output bulk, C73-C77) part
  specifications are superseded by this entry. Q1 (pre-OR-ing per-input bulk, C59-C67,
  CL32B226KAJNNNE 22µF X7R 25V 1210) is unaffected.
