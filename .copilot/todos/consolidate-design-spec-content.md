# Consolidate Design Spec Content

**ID:** `consolidate-design-spec-content`
**Status:** pending
**Category:** Documentation
**Source:** Session decision — Design_Spec.md file size reduction
**Blocked by:** `enc-connector-review-pre-pcb`

---

## Description

Simplify and reduce the size of `Design_Spec.md` files across all boards. The goal is to reduce verbosity and file size without losing any design intent or traceability.

Approaches to consider for each board's Design_Spec.md:

1. **Replace duplicated standards prose** with a single cross-reference to `design/Standards/Global_Routing_Spec.md` or `design/Standards/JLCPCB_Manufacturing.md` rather than repeating the same text in each board spec.
2. **Collapse redundant requirement wording** where multiple FRs or DRs say the same thing in slightly different words; consolidate into one clear requirement.
3. **Move large reference tables** (e.g. full pin tables already captured in schematic) to a separate `Pin_Map.md` per board and link to them.
4. **Remove stale or superseded notes** that have been resolved by design decisions (DEC entries) — replace with a short reference to the DEC.

## Scope

All board-level Design_Spec.md files:
- `design/Electronics/Controller/Design_Spec.md`
- `design/Electronics/Power_Module/Design_Spec.md`
- `design/Electronics/Stator/Design_Spec.md`
- `design/Electronics/Rotor/Design_Spec.md`
- `design/Electronics/Extension/Design_Spec.md`
- `design/Electronics/Reflector/Design_Spec.md`
- `design/Electronics/Encoder/Design_Spec.md`
- `design/Electronics/JTAG_Module/Design_Spec.md`
- `design/Electronics/User_Settings_Module/Design_Spec.md`
- `design/Electronics/Actuation_Module/Design_Spec.md`

## Notes

- Preserve all FR/DR requirement IDs — do not renumber.
- Preserve all cross-references and DEC citations.
- Do not remove any requirement that is not duplicated elsewhere.
- This is a v1.0 scope task (not v2.0 deferred).
