## DEC-066 - GRS Canonical PCB Stackup Authority (Consolidation)

| Field | Value |
| :--- | :--- |
| **Decision ID** | DEC-066 |
| **Status** | Confirmed |
| **Date** | 2026-05-11 |
| **Author** | Izzyonstage & Copilot |
| **Amends** | DEC-065 (stackup authority consolidated into GRS §2.3); DEC-016 (inverted stackup extended to Actuation Module) |

### Context

Following the stackup code correction in DEC-065, the JLCPCB identifiers and layer assignments were
still duplicated across all 10 board Design_Spec.md files. Each board contained its own stackup
section with the code, layer assignment table, and rationale - multiple sources of truth that would
need to be kept in sync independently for any future change.

Additionally, DEC-065 documented the JTAG Module inverted stackup note but the Actuation Module -
which also mounts upside-down on the carrier board - was missing an equivalent inverted stackup note.

### Decision

Stackup definitions are consolidated into the Global Routing Specification as new section
**§2.3 PCB Stackup Definitions**, with three named subsections:

- **§2.3.1** - Standard 4-layer (JLC041621-3313): Rotor (A+B), Stator, Extension, Reflector, Encoder, USM
- **§2.3.2** - Inverted 4-layer (JLC041621-3313): JTAG Module, Actuation Module (upside-down mounting; DEC-016)
- **§2.3.3** - Six-layer (JLC061621-3313): Controller Board, Power Module (board-specific layer signal assignments remain in respective board specs)

`JLCPCB_Manufacturing.md §1` remains the physical authority (prepreg thicknesses, CI trace widths).
GRS §2.3 is the logical layer assignment authority.

All 10 board Design_Spec.md stackup sections are simplified to a single GRS §2.3.x reference.
Two stale DR table stackup codes - JM DR-JM-01 and EXT DR-EXT-01 still showing old `JLC04161H-7628`
(missed in DEC-065 workstream) - are corrected as part of this work.

### Rationale

A single source of truth in the GRS eliminates duplication and ensures future stackup or layer
assignment changes propagate from one location only. Board specs retain only board-specific
operational content (CI routing rules, layer signal assignments for CTL §9.2).

### Files Changed

- `design/Standards/Global_Routing_Spec.md`: New §2.3 PCB Stackup Definitions (three subsections)
- `design/Production/JLCPCB_Manufacturing.md`: §1.1 and §1.2 design rule cross-refs updated to GRS §2.3
- `design/Electronics/JTAG_Module/Design_Spec.md`: DR-JM-01 stale code corrected; §5 simplified to GRS §2.3.2 reference
- `design/Electronics/Actuation_Module/Design_Spec.md`: DR-AM-01 and DR-AM-09 simplified; inverted stackup blockquote removed; content moved to GRS §2.3.2
- `design/Electronics/Extension/Design_Spec.md`: DR-EXT-01 stale code corrected; §4 simplified to GRS §2.3.1 reference
- `design/Electronics/Controller/Design_Spec.md`: §9.2 physical stackup table removed
  (duplicate of JLCPCB_Manufacturing.md §1.2); GRS §2.3.3 reference added; layer signal assignment table and CI routing table retained
- `design/Electronics/Power_Module/Design_Spec.md`: §1 PCB Architecture and DR-PM-13 updated with GRS §2.3.3 reference
- `design/Electronics/Rotor/Design_Spec.md`: DR-ROT-01 and §4 simplified to GRS §2.3.1 reference
- `design/Electronics/Stator/Design_Spec.md`: DR-STA-01 and §7 simplified to GRS §2.3.1 reference
- `design/Electronics/Reflector/Design_Spec.md`: DR-REF-01 and §6 simplified to GRS §2.3.1 reference
- `design/Electronics/Encoder/Design_Spec.md`: DR-ENC-01 and §9 simplified to GRS §2.3.1 reference
- `design/Electronics/User_Settings_Module/Design_Spec.md`: DR-USM-01 and §8 simplified to GRS §2.3.1 reference
