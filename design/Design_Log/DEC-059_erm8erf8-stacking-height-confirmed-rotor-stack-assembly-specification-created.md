## DEC-059 - ERM8/ERF8 Stacking Height Confirmed; Rotor Stack Assembly Specification Created

| Field | Value |
| :--- | :--- |
| **Decision ID** | DEC-059 |
| **Status** | Confirmed |
| **Date** | 2026-05-28 |
| **Author** | Copilot (session a38ceaab) |
| **Amends** | - |

### Context

The ERM8/ERF8 rotor-interconnect connector stacking height was previously recorded as
approximately 5mm but was disputed (see checkpoint 154). A systematic re-read of both
Samtec datasheets was performed to establish the definitive value.

### Decision

The `-05.0-` lead style designation in the selected parts:

- `ERM8-005-05.0-S-DV-K-TR` (male, rotor Board A)
- `ERF8-005-05.0-S-DV-K-TR` (female, rotor Board B)

denotes a **5 mm per-connector** standing height above each PCB surface. Because
the two connectors mate end-to-end, the total PCB-to-PCB inter-rotor gap is:

> **5 mm (ERM8) + 5 mm (ERF8) = 10 mm**

This was independently verified against the Samtec published stack-height range for
the ERM8/ERF8 family (7 mm - 18 mm): the minimum of 7 mm = ERM8 -02.0 (2 mm) +
ERF8 -05.0 (5 mm), confirming the additive model.

The 1.5 mm contact-wipe figure stated in the ERM8 datasheet is a spring-travel
specification and does **not** reduce the board-separation distance.

The **-05.0/-05.0 pairing is the minimum achievable stacking height** for the
current connector selection. Taller variants are available:

| ERM8 lead | ERF8 lead | Total |
| :--- | :--- | :--- |
| -02.0 (2 mm) | -05.0 (5 mm) | 7 mm |
| -03.0 (3 mm) | -05.0 (5 mm) | 8 mm |
| **-05.0 (5 mm) [current]** | **-05.0 (5 mm) [current]** | **10 mm** |
| -05.0 (5 mm) | -07.0 (7 mm) | 12 mm |
| -08.0 (8 mm) | -05.0 (5 mm) | 13 mm |
| -08.0 (8 mm) | -07.0 (7 mm) | 15 mm |
| -09.0 (9 mm) | -07.0 (7 mm) | 16 mm |
| -09.0 (9 mm) | -09.0 (9 mm) | 18 mm |

Any change to stacking height requires a **DEFECT-DEC** and must update the
affected MPN(s) in all board Design_Spec BOMs and the Consolidated BOM.

### New documentation

`design/Mechanical/Rotor_Stack_Assembly/Design_Spec.md` was created to formally
capture:

- The mini-stack concept (5 rotors + boundary boards)
- The 10 mm inter-rotor gap derivation and source
- The full achievable stack-height options table
- Mechanical clearance requirements (TBD - pending prototyping)
- Indicative mini-stack depth calculation (~115 mm PCB-only, 5 rotors)

### Files Changed

- `design/Mechanical/Rotor_Stack_Assembly/Design_Spec.md`: NEW - full specification created.
- `design/Mechanical/Rotor/Design_Spec.md`: §7 design intent bullets updated; §7 cross-reference block updated; §9 cross-ref table updated.
- `design/Mechanical/Rotor_Actuation_Assembly/Design_Spec.md`: §8 cross-ref table updated; new Rotor_Stack_Assembly row added.
- `design/Mechanical/Complete_System_Assembly/Design_Spec.md`: Component Index (§2) updated; Sub-Assembly Reference Table (§3) updated.
