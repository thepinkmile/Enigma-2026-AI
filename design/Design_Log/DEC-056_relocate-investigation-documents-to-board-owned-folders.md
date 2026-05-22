## DEC-056 - Relocate Investigation Documents to Board-Owned Folders

| Field | Value |
| --- | --- |
| **ID** | DEC-056 |
| **Status** | Accepted |
| **Date** | 2026-05-04 |
| **Author** | Design team |
| **Affects** | Repository structure; cross-references in multiple board files |

### Decision

Move the two investigation documents out of `design/Electronics/Investigations/` and into the
folders of the boards that own those topics. Rename the PoE document to match the content style
of other design artefacts.

| Old Path | New Path | Rationale |
| --- | --- | --- |
| `design/Electronics/Investigations/JTAG_Integrity.md` | `design/Electronics/JTAG_Daughterboard/JTAG_Integrity.md` | JTAG chain master is the JDB; document belongs with the board that owns the topic |
| `design/Electronics/Investigations/PoE_Investigation.md` | `design/Electronics/Controller/PoE_Power_Analysis.md` | PoE front-end is Controller-owned; rename reflects content (analysis, not open investigation) |

The `Investigations/` folder is removed entirely as it is now empty.

### Rationale

Placing investigation documents alongside the board that owns the topic makes it easier to
maintain them as part of the board review scope (as already practised for JTAG_Integrity - it was
reviewed with JDB in previous passes). The PoE document is likewise Controller-owned and was
always referenced from the Controller Design_Spec. The `Investigations/` folder name implied
open/unresolved work; moving the documents removes that ambiguity.

### Cross-references updated

All living design files referencing the old paths were updated:

- `.copilot/agent-directives.md` - integration review scope list updated
- `design/Electronics/Controller/Design_Spec.md` - PoE power table note
- `design/Electronics/Encoder/Design_Spec.md` - JTAG trace width rule
- `design/Electronics/Extension/Design_Spec.md` (×2) - JTAG trace width and stackup rules
- `design/Electronics/Extension/Board_Layout.md` - JTAG CI trace note
- `design/Electronics/JTAG_Daughterboard/Design_Spec.md` (×2) - termination and pull resistor notes
- `design/Electronics/JTAG_Daughterboard/Board_Layout.md` - impedance calculation note
- `design/Electronics/Reflector/Design_Spec.md` - JTAG trace width rule
- `design/Electronics/Reflector/Board_Layout.md` - JTAG CI trace note
- `design/Electronics/Rotor/Design_Spec.md` - JTAG trace width rule
- `design/Electronics/Rotor/Board_Layout.md` - JTAG CI trace note
- `design/Electronics/Stator/Design_Spec.md` - JTAG trace width rule

**Not updated (audit history - append-only):** All prior DEC entries in this log that reference the
old `Investigations/` paths remain as written; they record the historical file location at the time
of each decision.
