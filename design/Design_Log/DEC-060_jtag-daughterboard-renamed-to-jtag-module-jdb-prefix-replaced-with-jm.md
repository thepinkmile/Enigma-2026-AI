## DEC-060 - JTAG Daughterboard Renamed to JTAG Module; JDB Prefix Replaced with JM

| Field | Value |
| :--- | :--- |
| **Decision ID** | DEC-060 |
| **Status** | Confirmed |
| **Date** | 2026-05-07 |
| **Author** | Izzyonstage & Copilot (session a38ceaab) |
| **Amends** | - |

### Context

The board previously known as the "JTAG Daughterboard" (abbreviated "JDB") mounts on
the Controller Board (CTL) via the DF40C-20 board-to-board connector introduced in
DEC-058. As a module that physically attaches to a carrier board (CTL) and operates
as a discrete, self-contained functional unit, the "Daughterboard" designation is
both imprecise and inconsistent with the rest of the system naming convention.

In addition, the Global Routing Specification (GRS) defines a specific mounting hole
ownership model for **Modules** - boards that mount on a carrier - governing standoff
BOM ownership and mounting hole RefDes conventions. Renaming this board to "JTAG
Module" ensures it is correctly classified under the GRS Module definition, tying
together design specification body text, BOM ownership rules, and component naming
convention in a consistent way.

### Decision

The board is renamed from **JTAG Daughterboard** to **JTAG Module** with immediate
effect:

| Old | New |
| :--- | :--- |
| JTAG Daughterboard | JTAG Module |
| JTAG_Daughterboard | JTAG_Module |
| JDB (prefix/abbreviation) | JM |

Historical audit entries (Design_Log.md DEC-001 through DEC-059 and all committed
session checkpoints) retain the original terminology as an accurate record of the
decisions made at the time. All live design documents use the new naming.

### Rationale

- The board mounts on CTL via DF40C BtB connector - it is a module on a carrier,
  not a daughter to a motherboard in the traditional sense.
- "JTAG Module" aligns with the project's module/carrier vocabulary used for the
  Encoder, User Settings Module, and Actuation Module.
- Adopting the Module classification brings the board under the GRS Module mounting
  hole rules (DEC-057), ensuring BOM ownership and standoff conventions are applied
  consistently without a bespoke carve-out.
- "JM" is unambiguous within the system; no other board or assembly uses this prefix.

### Files Changed

- `design/Electronics/JTAG_Module/` (folder): renamed from `JTAG_Daughterboard/`.
- `design/Electronics/JTAG_Module/Design_Spec.md`: all JDB/JTAG Daughterboard references updated.
- `design/Electronics/JTAG_Module/Board_Layout.md`: all JDB/JTAG Daughterboard references updated.
- `design/Electronics/JTAG_Module/JTAG_Integrity.md`: all JDB/JTAG Daughterboard references updated.
