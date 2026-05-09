# Todo: Board Interconnect Diagram

**ID:** `board-interconnect-diagram`
**Status:** pending
**Category:** Documentation improvements
**Source:** Session decision — UML/Mermaid diagram enhancement
**Blocked by:** —

---

## Description

Add a Mermaid `block-beta` component diagram to `design/Electronics/Boards_Overview.md`
showing all 10 Enigma-NG boards as named blocks, with edges labelled by physical connector
family and reference designator pair (host-side / device-side).

## Target File

`design/Electronics/Boards_Overview.md`

Insert the diagram **near the top of §1** (or as §1.1 immediately after the opening paragraph),
so it is one of the first things seen when opening the file. The diagram should appear before
the interconnect tables and other prose.

## Boards / Blocks

Group by subsystem:

**Core** (always present):
- `PM` — Power Module
- `CTL` — Controller Board (CM5 carrier)
- `STA` — Stator Board

**Peripherals** (attached to CTL or STA):
- `JM` — JTAG Module (BtB to CTL)
- `AM_CTL` — Actuation Module (CTL instance, BtB to CTL)
- `USM` — User Settings Module (I²C via STA J13)

**Rotor Stack** (representative, 1–30 rotors):
- `R1_5` — First 5-rotor group `[R1–R5]`
- `EXT` — Extension Board (0–5 units; show as one representative block with notation)
- `R6_10` — Second 5-rotor group `[R6–R10]` (mini-stack / full only)
- `REF` — Reflector Board

**Encoder Modules** (×6, attached to STA):
- `KBD_ENC`, `LBD_DEC`, `PLG1_DEC`, `PLG1_ENC`, `PLG2_DEC`, `PLG2_ENC`

## Connections / Edges

Label each edge with connector family + refdes pair. Verify all refdes against the
board-level Design_Spec.md BOM sections before implementing.

| Edge | Connector Family | Host Side | Device Side |
|------|-----------------|-----------|-------------|
| CTL ↔ PM | TE MX2.5 10-pos (Link-Alpha) | CTL J1/J2/J3 | PM J1/J2/J3 |
| CTL ↔ STA | Molex EXTreme Guardian HD (Link-Beta) | CTL J4/J5 | STA J11/J12 |
| CTL ↔ JM | Hirose DF40C-20 BtB | CTL J10 | JM J1 |
| CTL ↔ AM (CTL) | Hirose DF40HC-20 BtB | CTL J11 | AM J1 |
| STA ↔ ENC ×6 | 20-pin 2×10 IDC | STA J4–J9 | ENC J1 |
| STA ↔ USM | 6-pin JST PH 2.0mm | STA J13 | USM J1 |
| STA ↔ Rotor 1 | Samtec ERF8-005/010 BtB | STA (rotor slot 1) | R1 J1/J2/J3 |
| Rn ↔ Rn+1 | Samtec ERM8/ERF8-005/010 BtB | Rn J4/J5/J6 | Rn+1 J1/J2/J3 |
| R5 ↔ EXT | Samtec ERM8 + Adam Tech 2BHR-30-VUA | R5 J4/J5/J6 | EXT J1/J2/J3 |
| EXT ↔ R6 | Samtec ERF8-005/010 BtB | EXT J4/J5/J6 | R6 J1/J2/J3 |
| EXT ↔ AM (EXT) | Hirose DF40HC-20 BtB | EXT J9 | AM J1 |
| R30 ↔ REF | Samtec ERM8-005/010 | R30 J4/J5/J6 | REF J1/J2/J3 |
| REF ↔ STA | Adam Tech 2BHR-30-VUA 30-pin | REF J4 | STA J10 |

## Mermaid Type

Use `block-beta`. Suggested layout:
- **Centre column:** Main data-path chain — PM → CTL → STA → [R1–R5] → EXT → [R6–R10] → REF (vertical)
- **Left column:** Encoder modules (×6) stacked and connected to STA
- **Right column:** JM and AM attached to CTL; USM attached to STA

Use labelled arrow edges (`--"label"-->`) for all connections. Represent the rotor group as a
compressed block labelled `[R1–R5]`. Add an inline note: "up to ×5 EXT boards for 30 rotors."

## Notes

- Do NOT show internal circuitry — board-level connections only.
- The diagram is representative/schematic — not every individual rotor.
- Verify all refdes and connector families against the respective Design_Spec.md BOM tables.
- Reference `design/Electronics/Boards_Overview.md §2 Interconnects` for connector specs.
