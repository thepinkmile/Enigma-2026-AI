## DEC-048 - ESD Protection Extended to Host-Side Rotor-Facing BtB Connectors

- **Status:** Approved
- **Date:** 2026-04-30
- **Category:** ESD / Protection Strategy
- **Area:** Stator, Extension, Reflector - Rotor-Facing BtB Connectors
- **Author:** Izzyonstage & GitHub Copilot

### Summary

ESD protection requirement (DEC-045) has been extended from the Rotor board to all host-side boards that present rotor-facing
BtB connector faces during live rotor swap. Any exposed Samtec ERM8/ERF8 connector face that is accessible when a rotor is
being inserted or removed must carry TVS protection.

### Problem

DEC-045 mandated TPD4E05U06QDQARQ1 ESD arrays on the Rotor board side of each BtB interface. However, when a rotor is
extracted, both the rotor-side connectors and the host-side (Stator / Extension / Reflector) socket faces become simultaneously
exposed to operator handling. An ESD event from operator touch to the host-side socket during live swap would propagate
directly into the host board with no protection.

### Decision

All Samtec ERM8/ERF8 connector faces on host boards that are exposed during live rotor swap require a TPD4E05U06QDQARQ1
4-channel bidirectional ESD array within 3mm of the connector mating edge. Only JTAG and ENC signal connectors are in scope;
Power connectors (power-only BtB pairs) and all internal IDC/ribbon/harness/dock connectors are explicitly excluded.

Board-level implementation:

- **Stator:** U9 (J1 JTAG), U10-U12 (J3 ENC) - 4 arrays total.
- **Extension:** U2 (J1 JTAG in), U3-U5 (J3 ENC in), U6 (J4 JTAG out), U7-U9 (J6 ENC out) - 8 arrays total.
- **Reflector:** U1 (J1 JTAG), U2-U4 (J3 ENC) - 4 arrays total.

Internal connectors explicitly excluded from this decision:

- All power-only BtB connector pairs on any board.
- Stator J4-J13 (IDC encoder ports, Extension Port ribbon, Controller docks, Settings harness).
- Extension J7/J8 (Extension Port BHR-20-VUA ribbons) and J9/J10 (AM service docks).
- Reflector J4 (TTD_RETURN ribbon).

### Rationale

Rotors are a user-handled, hot-swappable component. During installation or removal, both sides of the connector interface are
simultaneously accessible. Protecting only the rotor side is insufficient - a real ESD event from an operator to an unprotected
host socket would destroy the host board as readily as a rotor. Extending the same TPD4E05U06QDQARQ1 device used on rotors
to the host-side connector faces closes the remaining ESD risk at minimal BOM cost (16 additional arrays across 3 boards).

### Impact

- `design/Electronics/Stator/Design_Spec.md`: Added FR-STA-13, DR-STA-16; §8 ESD section rewritten; BOM U9-U12 added.
- `design/Electronics/Extension/Design_Spec.md`: Added FR-EXT-07, DR-EXT-13; §5 ESD section rewritten; BOM U2-U9 added.
- `design/Electronics/Reflector/Design_Spec.md`: Added FR-REF-05, DR-REF-06; §5 renamed to Thermal & ESD; BOM U1-U4 added.
- `design/Electronics/Consolidated_BOM.md`: Section 1 and Section 2 updated.

### Cross-ref

DEC-045 (Rotor ESD), `design/Electronics/Stator/Design_Spec.md §8`,
`design/Electronics/Extension/Design_Spec.md §5`, `design/Electronics/Reflector/Design_Spec.md §5`.
