# Checkpoint 156 — README system architecture Mermaid diagram complete

## Status
Complete

## What was done

### README.md — System architecture Mermaid diagram added and finalised

A `flowchart BT` (bottom-to-top) Mermaid diagram was added to the README.md
`## 🗺️ System Architecture` section. The diagram shows all boards and their
interconnections at subgraph level.

**Final diagram structure:**
- `PWR` subgraph — Power Module node
- `CTRL` subgraph — CM5, JTAG Module, Actuation Module (Controller) nodes
- `ENCS` subgraph — KBD_ENC, LBD_DEC, PLG encoder nodes
- `STATOR` subgraph — Stator Board + Settings Board nodes
- `RSTACK` subgraph — Group 1 rotor modules
- `EXTRSTACK` subgraph — Extension Board + Actuation Module (group-boundary)
- `REF` — standalone Reflector Board node

**Connections:**
- `PWR --> CTRL` Link-Alpha (3× TE 2.5mm, 5V_MAIN · 3V3_ENIG)
- `CTRL --> STATOR` Link-Beta (2× Molex EXTreme Guardian HD, ENC_DATA · JTAG · I²C)
- `JTAG --> STA` JTAG chain entry
- `KBD --> STA` ENC_IN[5:0]
- `STA --> LBD` ENC_OUT[5:0]
- `PLG <--> STA` ENC_DATA bidirectional
- `STA --> ROT` Tri-connector Bus (Power · JTAG · ENC_DATA)
- `ROT --> REF` ENC_DATA
- `ROT <---> EXT` bidirectional bus
- `REF --> STA` ENC_OUT[5:0] TTD_RETURN
- `STA --> REF` ENC_IN[5:0] + 5V_MAIN · 3V3_ENIG (direct ribbon from Stator)

**Invisible rank hints added** to guide Dagre layout:
- `REF ~~~ RSTACK ~~~ STATOR` and `STATOR ~~~ PWR` — top row ordering
- `ENCS ~~~ CTRL` — second row alignment
- `EXTRSTACK ~~~ RSTACK` — extension stack adjacent to rotor stack

**Key design clarification confirmed:** Power reaches Reflector and Extension Boards
directly from the Stator via ribbon cable — NOT through the rotor chain. The
`STA --> REF` edge with 5V_MAIN · 3V3_ENIG is correct and intentional.

### `.copilot/todos/ctl-t1-coilcraft-v2-review.md`
Status changed to `blocked` as a v2.0 item, consistent with all other v2 todos.

### `.copilot/todo-list.md`
`ctl-t1-coilcraft-v2-review` entry updated to reflect blocked/v2 status.

### `.copilot/todos/extension-mechanical-usage.md`
Note added to reinstate Groups 2–6 (Rotors 6–30) in the README diagram once the
extension interconnect architecture review resolves the board topology.

### `.copilot/checkpoints/155-readme-full-audit-am-added.md`
Internal header corrected from "Checkpoint 151" to "Checkpoint 155".

## Open todos (unchanged)
- `usm-spdt-switch-floating-review` — SPDT switch GPIO expander pin mapping + pull-up/down check
- `enc-connector-review-pre-pcb` — ENC J1/J2 connector and 100nF cap review
- `consolidate-design-spec-content` — blocked by `enc-connector-review-pre-pcb`
- `extension-mechanical-usage` — extension interconnect architecture review (pending)

## Next checkpoint number
157
