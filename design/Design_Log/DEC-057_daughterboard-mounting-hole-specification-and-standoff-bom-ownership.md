## DEC-057 - Daughterboard Mounting Hole Specification and Standoff BOM Ownership

**Date:** 2026-05-05
**Status:** Accepted
**Amends:** DEC-039, DEC-023

### Decision

This is the single authoritative reference for mounting hole specification and standoff BOM
ownership across all boards in the Enigma-NG system.

#### 1. Daughterboard Classification

Only the following boards are classified as **daughterboards** (host-mounted via standoffs onto a
carrier board):

| Board | Carrier Board(s) | Attachment Method |
| :--- | :--- | :--- |
| Actuation Module (AM) | CTL, EXT | M2.5×3.5mm SMT standoffs (MH5-MH8 on each carrier) |
| JTAG Daughterboard (JDB) | CTL | M2.5 standoffs (MH13-MH16 on CTL - to be created at CTL schematic capture) |

All other boards (PM, CTL, STA, REF, EXT, ROT, USM, ENC) are **chassis-mounted** boards and are
**not** daughterboards. The Encoder Module (ENC) is explicitly **not** a daughterboard; it uses
standard M3 chassis mounting per GRS §4 and DEC-039.

#### 2. Mounting Hole Specification by Board Category

**Daughterboards (AM, JDB):**

- Mounting holes: **M2.5 NPTH**, pads connected to local **`GND`** net (not `GND_CHASSIS`).
- Rationale: Daughterboards share their ground reference with the carrier via the board-to-board
  connector. Tying mounting holes to `GND_CHASSIS` would create an unintended second galvanic
  chassis-bond point, violating the single-point chassis ground topology defined in DEC-039.

**Chassis-mounted boards (all others):**

- Mounting holes: **M3 PTH**, pads connected to **`GND_CHASSIS`** per
  `design/Standards/Global_Routing_Spec.md §4` and DEC-039.

**CTL special case (carries both categories):**

| Holes | Size / Type | Net | Purpose |
| :--- | :--- | :--- | :--- |
| MH1-MH4 | M2.5 4mm standoffs | `GND` | CM5 SoM mounting |
| MH5-MH8 | M2.5 3.5mm SMT standoffs | `GND` | AM daughterboard dock |
| MH9-MH12 | M3 PTH | `GND_CHASSIS` | Chassis mounting |
| MH13-MH16 | M2.5 | `GND` | JDB daughterboard dock |

JDB dock standoffs on CTL are assigned RefDes MH13-MH16 - to be created at CTL schematic capture stage.

#### 3. Standoff BOM Ownership

The **carrier (host) board** is solely responsible for specifying and sourcing the standoffs used
to attach a daughterboard. The **daughterboard itself shall not contain standoff BOM entries** for
its own attachment points.

| Carrier Board | Standoff Entries Owned | Qty per Board |
| :--- | :--- | :--- |
| CTL | AM dock standoffs (MH5-MH8, 9774035151R, M2.5×3.5mm SMT) | 4 |
| CTL | JDB dock standoffs (MH13-MH16, M2.5 - to be created at CTL schematic capture) | 4 |
| EXT | AM dock standoffs (MH5-MH8, 9774035151R, M2.5×3.5mm SMT) | 4 |

The AM and JDB Design_Specs shall each include an explicit note that their mounting standoffs are
defined and sourced on their respective carrier board(s), with a cross-reference to those carrier
boards' Design_Specs.

#### 4. Summary Table - All Boards

| Board | Category | Hole Size | Net | Standoffs in BOM? | Carrier |
| :--- | :--- | :--- | :--- | :--- | :--- |
| PM | Chassis | M3 PTH | `GND_CHASSIS` | N/A | - |
| CTL MH1-4 | SoM dock | M2.5 | `GND` | Yes (CM5 screws) | - |
| CTL MH5-8 | Daughterboard dock | M2.5 SMT | `GND` | Yes (AM standoffs) | - |
| CTL MH9-12 | Chassis | M3 PTH | `GND_CHASSIS` | N/A | - |
| CTL (JDB dock) | Daughterboard dock | M2.5 | `GND` | Yes (JDB standoffs, MH13-MH16) | - |
| STA | Chassis | M3 PTH | `GND_CHASSIS` | N/A | - |
| REF | Chassis | M3 PTH | `GND_CHASSIS` | N/A | - |
| EXT MH1-4 | Chassis | M3 PTH | `GND_CHASSIS` | N/A | - |
| EXT MH5-8 | Daughterboard dock | M2.5 SMT | `GND` | Yes (AM standoffs) | - |
| ROT | Chassis | M3 PTH | `GND_CHASSIS` | N/A | - |
| USM | Chassis | M3 PTH | `GND_CHASSIS` | N/A | - |
| ENC | Chassis | M3 PTH | `GND_CHASSIS` | N/A | - |
| AM | Daughterboard | M2.5 NPTH | `GND` | No - on CTL and EXT | CTL, EXT |
| JDB | Daughterboard | M2.5 NPTH | `GND` | No - on CTL | CTL |

### Rationale

A single, fully declarative decision removes ambiguity and provides a canonical single-document
reference for reviewers and future design agents.

### Impact

- `design/Electronics/Actuation_Module/Design_Spec.md`: DR-AM-03 - cite DEC-057 for both CTL and EXT
  as carrier boards in the standoff ownership note.
- `design/Electronics/Extension/Design_Spec.md`: DR-EXT-10 and BOM MH5-MH8 already correct; add
  cross-reference to this DEC-057 standoff ownership note.
- `design/Electronics/JTAG_Daughterboard/Design_Spec.md`: Mounting note - cite DEC-057 for standoff
  ownership rule.
- `design/Electronics/Controller/Design_Spec.md`: Confirm CTL BOM contains standoff rows for AM dock
  (MH5-MH8) and JDB dock (MH13-MH16) - to be verified at schematic capture stage.
- `design/Standards/Global_Routing_Spec.md §4`: No change - this DEC supplements rather than
  contradicts GRS; cross-reference may be added at GRS maintenance time.
