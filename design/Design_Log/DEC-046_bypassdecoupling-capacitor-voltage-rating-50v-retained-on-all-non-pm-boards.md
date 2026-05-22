## DEC-046 - Bypass/Decoupling Capacitor Voltage Rating: 50V Retained on All Non-PM Boards

- **Status:** Decided
- **Date:** 2026-04-29
- **Category:** Component Selection / Passive Derating
- **Area:** All boards (Rotor, Stator, Controller, Extension, JDB, Encoder, AM, Settings Board)
- **Author:** Izzyonstage & GitHub Copilot

### Summary

Standard bypass and decoupling capacitors across all non-PM boards are retained at their current
50V voltage rating. No down-specification to 25V is required or warranted.

### Problem

A design review (CTL-L2) flagged that bulk reservoir caps on some boards were specified at 50V while
the highest non-PM rail is 5V_MAIN (5V). Bulk reservoir caps were subsequently down-specced to 25V
(Samsung CL21B106KAYQNNE). The question then arose: should the smaller bypass and decoupling
capacitors also be down-specced for cost savings?

### Decision

Retain 50V-rated bypass and decoupling capacitors as the approved standard across all non-PM boards.
The Power Module retains 50V for all capacitors on its input/battery path, which sees up to 16.9V.

### Rationale

**Power Module (input-side caps):** 50V is required. The PM input rail reaches ~16.9V; 50V provides
>3x voltage margin, meeting the X7R DC bias derating requirement. A 25V cap would give only 1.5x
margin - insufficient for X7R ceramics.

**All other boards (bypass/decoupling caps):** 25V is technically sufficient (5V_MAIN gives 5x
margin at 25V). However:

1. The standard approved parts (`CL05B104KB5NNNC` 100nF 0402, `C0805C105K5RACTU` 1µF 0805) are
   already approved, priced, and used consistently across every board. Changing them requires
   sourcing and approving new part numbers.
2. No existing approved 25V part matches these capacitance values - the approved 25V parts
   (`CL21B106KAYQNNE` 10µF 0805, `CL32B226KAJNNNE` 22µF 1210, etc.) are all different values used
   for bulk/reservoir purposes.
3. The 100nF 0402 bypass cap is one of the cheapest passive components in the design (~£0.002-0.003
   each at JLCPCB volumes). The cost delta between 25V and 50V variants is negligible - fractions of
   a penny per unit - and the total BOM saving across even a 500-unit build would be immaterial.
4. Consistency across the design has positive value: a single approved bypass cap part used
   everywhere reduces procurement complexity and qualification overhead.

### Alternatives Considered

| Alternative | Reason rejected |
| :--- | :--- |
| Down-spec 100nF 0402 to 25V across all boards | Requires new part approval; cost saving negligible; no existing approved 25V equivalent at this value |
| Down-spec 1µF 0805 to 25V on non-PM boards | Same reasoning; only ~10 placements total, saving immaterial |
| Mixed 25V/50V bypass depending on board | Creates two approved bypass cap standards; procurement complexity outweighs any saving |

### Impact

No document changes required. This decision records the rationale for the existing 50V specification
to prevent future reviews from re-raising it as an issue.

- `design/Electronics/Consolidated_BOM.md`: No change - existing 50V parts remain the standard.
- `design/Standards/Global_Routing_Spec.md`: No change.

### Cross-ref

`design/Electronics/Power_Module/Design_Spec.md §7.4` (50V derating note for PM input rails),
`design/Electronics/Consolidated_BOM.md` (approved 50V bypass/decoupling cap parts).
