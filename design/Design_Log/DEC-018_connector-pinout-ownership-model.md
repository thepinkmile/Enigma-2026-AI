## DEC-018 - Connector Pinout Ownership Model

- **Status:** Adopted
- **Date:** 2026-04-05
- **Category:** Electrical
- **Area:** All Boards - Documentation Architecture

### Decision

Each multi-board connector interface shall have a single **Definition Owner** - the board whose
`Board_Layout.md` (or `Design_Spec.md` where no Board_Layout exists) contains the authoritative
pin-by-pin table for that interface. All other boards that mate with that connector must
**not** duplicate the pin table; instead they include a short cross-reference note of the form:

> **Connector Definition Owner:** `[OwnerBoard]/Board_Layout.md - [Section]`. This board uses the
> mating connector. See BOM for part number.

This rule prevents the class of drift errors where two boards define the same connector differently
(e.g. Pin 2 = GND on one board, SYS_RESET_N on another). When a conflict is found, the owner's
definition is authoritative.

### Ownership Register

| Interface | Connector(s) | Definition Owner | Authoritative Section |
| :--- | :--- | :--- | :--- |
| **LINK-ALPHA** | PM J1 ↔ Controller J1 (80-pin ERM8/ERF8) | **Power Module** | `Power_Module/Board_Layout.md - LINK-ALPHA` |
| **LINK-BETA** | Controller J2 ↔ Stator J8 (40-pin ERM8/ERF8) | **Controller** | `Controller/Board_Layout.md - LINK-BETA` |
| **Reflector/Extension Link** | Stator J10 ↔ Extension J7/J8 ↔ Reflector J4 (16-pin 2x8) | **Stator** | `Stator/Board_Layout.md - J10` |
| **Encoder Ports** | Stator J4/J5/J6/J7/J8/J9 ↔ Encoder J2 (20-pin 2x10) | **Stator** | `Stator/Board_Layout.md - J4-J9` |
| **Rotor Interface** | Stator J1-J3 ↔ Rotor 1 → ... → Rotor 30 → Reflector J1-J3 (serial chain; Extension J1-J6 at group boundaries) | **Rotor** | `Rotor/Design_Spec.md §3.4` |
| **JTAG Daughterboard headers** | JDB J1 (USB 5-pin) + J2 (JTAG 10-pin) | **JTAG Daughterboard** | `JTAG_Daughterboard/Board_Layout.md` |

### Rationale

- **LINK-ALPHA → Power Module:** The Power Module is the upstream power provider; it defines what
  rails and signals it places on the cable. The Controller is the downstream consumer.
- **LINK-BETA → Controller:** The Controller is the JTAG chain master. It originates TCK, TMS, TDI,
  SYS_RESET_N, and the ENC data bus. The Stator is the passive backplane receiver.
- **Reflector/Extension Link → Stator:** The Stator is the signal origin for all ENC data, power,
  and TTD_RETURN carried on this cable. Extension and Reflector are passive pass-throughs or endpoints.
- **Encoder Ports → Stator:** The Stator drives all three encoder cables and has the complete chain
  routing logic for TDI/TDO sequencing across J4/J5/J6. The Encoder boards are the downstream receivers.
- **Rotor Interface → Rotor:** The Rotor defines its own physical interface - both the connector
  type (mechanical) and the signal mapping. Stator, Extension, and Reflector must comply with the
  Rotor's mechanical interface, not the other way round.
- **JTAG Daughterboard → itself:** Self-contained module with no cross-board mating conflicts.

### Alternatives Considered

- **Central `Interfaces.md` document:** Rejected - separates pin definitions from the board they belong
  to, making it harder to keep in sync during incremental design changes. Per-board ownership with
  cross-references is more maintainable.
- **Both sides document the full table:** Rejected - this is the exact pattern that caused the REF-03
  Pin 2 conflict and the REF-01 16/20-pin mismatch found in the April 2026 deep-dive review.
