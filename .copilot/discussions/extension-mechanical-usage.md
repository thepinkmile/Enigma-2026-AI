# Discussion: Extension Mechanical Usage Changes

**Status:** In Discussion — no design changes made yet  
**Todo ID:** `extension-mechanical-usage`  
**Opened:** 2026-05-17  
**Last Updated:** 2026-05-17 (entry 7)

---

## Purpose

This document is a pre-design discussion space. The user has a set of changes in mind that will significantly reshape how the Extension board and the boards it interfaces with physically interact. All design implications, component requirements, and open questions should be captured here before any changes are made to design specifications or schematics.

**No design files should be modified until this discussion reaches a clear decision point and explicit implementation approval is given.**

---

## Known Scope

### New Boards Being Defined

| New Board Name | Description | Source Circuits |
|---|---|---|
| **Cypher Board** | Central backplane board. Replaces STA + REF. Rotor mini-stacks attach to it. Also absorbs the JTAG Module (from CTL). BtB connections to CTL, Input-Cypher Board, and Output-Cypher Board. Spade tab connectors on back. 6-layer stackup. | STA circuits + REF circuits + JM circuits (from CTL) |
| **Stack-Input Board** | Input-side board of the Rotor Mini-Stack. **Front = right edge** (2 male stacking connectors: bottom + just above centre). **Back = left edge** (2 female stacking connectors: same positions). Input mating connectors to first ROT board. AM circuits native. Receives **5V_MAIN + 3V3_ENIG** via stacking connectors. Carries ribbon cable IDC for ENC_DATA. | EXT input-side circuits + AM circuits |
| **Stack-Output Board** | Output-side board of the Rotor Mini-Stack. **Front = left edge** (2 male stacking connectors: top + just below centre). **Back = right edge** (2 female stacking connectors: same positions). Output mating connectors from last ROT board. Receives **3V3_ENIG only** via stacking connectors. Carries ribbon cable IDC for ENC_DATA. | EXT output-side circuits |
| **Stack-Blanking Board** | Termination board. **Male connectors** matching all four female positions (Stack-Input back + Stack-Output back). Terminates the last mini-stack in the chain. Can also connect directly to Cypher Board female connectors for transport/testing without mini-stacks fitted. Passive or near-passive. | New design |
| **Input-Cypher Board** | New board — essentially the keyboard. 1 ENC module via Hirose-style BtB. Mechanical keyboard buttons on opposite face. BtB connection to Cypher Board. Chains with Output-Cypher Board in either order. | New design; ENC becomes module |
| **Output-Cypher Board** | New board — essentially the lightboard. 1 ENC module via Hirose-style BtB. LEDs on opposite face. BtB connection to Cypher Board. Chains with Input-Cypher Board in either order. | New design; ENC becomes module |

### Rotor Mini-Stack

The Rotor Mini-Stack is the assembly unit consisting of:
- **Stack-Input Board** (front: connects to Cypher Board or previous mini-stack rear; rear: input mating connectors to first ROT board)
- **ROT boards** (one per rotor position within the stack)
- **Stack-Output Board** (rear: output mating connectors from last ROT board; front: connects to next mini-stack front or Cypher Board)
- **Stack-Blanking Board** (fitted to the rear of the last mini-stack only — terminates the chain)

#### Stacking Connector Topology

```
                         [Cypher Board]
                        /              \
          (female, bottom +         (female, top +
           above-centre)             below-centre)
                |                         |
   RIGHT EDGE = FRONT          LEFT EDGE = FRONT
   [Stack-Input Board]          [Stack-Output Board]
   LEFT EDGE = BACK             RIGHT EDGE = BACK
                |                         |
          (female, bottom +         (female, top +
           above-centre)             below-centre)
                |                         |
          ←—— ROT boards ————————————————→
```

**Mini-stack front/back orientation:**
- **Stack-Input front** = RIGHT edge; **Stack-Input back** = LEFT edge
- **Stack-Output front** = LEFT edge; **Stack-Output back** = RIGHT edge
- The mini-stack "front face" is the right edge of Stack-Input + left edge of Stack-Output (both facing the Cypher Board / previous mini-stack)
- The mini-stack "back face" is the left edge of Stack-Input + right edge of Stack-Output (facing the next mini-stack or Stack-Blanking Board)

**Connector gender and position:**

| Board | Edge | Gender | Connector 1 position | Connector 2 position |
|---|---|---|---|---|
| Cypher Board | Stack-Input side | **Female** | Bottom | Just above centre |
| Cypher Board | Stack-Output side | **Female** | Top | Just below centre |
| Stack-Input | Front (right edge) | **Male** | Bottom | Just above centre |
| Stack-Input | Back (left edge) | **Female** | Bottom | Just above centre |
| Stack-Output | Front (left edge) | **Male** | Top | Just below centre |
| Stack-Output | Back (right edge) | **Female** | Top | Just below centre |
| Stack-Blanking Board | (single face) | **Male** | All four positions | (matches Stack-Input back + Stack-Output back females) |

**Positional keying logic:**
- Stack-Input front males (bottom + above-centre) can **only** mate with female connectors at those same positions (Cypher Board Stack-Input side, or previous mini-stack Stack-Input back)
- Stack-Output front males (top + below-centre) can **only** mate with female connectors at those positions (Cypher Board Stack-Output side, or previous mini-stack Stack-Output back)
- It is physically impossible to insert a Stack-Input where a Stack-Output belongs (connector positions do not match) — positional keying replaces mechanical key features

**Daisy-chain:**
Each successive mini-stack's front males (Stack-Input right edge + Stack-Output left edge) mate with the previous mini-stack's back females (Stack-Input left edge + Stack-Output right edge):
```
[Cypher Board females] ←→ [Mini-stack 1 front males] ... [Mini-stack 1 back females] ←→ [Mini-stack 2 front males] ... → [Stack-Blanking Board males]
```

**Stack-Blanking Board:**
- Has **male connectors** matching all four female positions (Stack-Input back + Stack-Output back)
- Can be fitted to the last mini-stack to terminate the chain
- Can also connect **directly to the Cypher Board** female connectors for transportation / testing without any mini-stack fitted

**Power rail assignment per board:**

| Board | 5V_MAIN | 3V3_ENIG | Notes |
|---|---|---|---|
| Stack-Input | ✅ Yes | ✅ Yes | AM motor driver requires 5V_MAIN; logic uses 3V3_ENIG |
| Stack-Output | ❌ No | ✅ Yes | Logic only — no 5V_MAIN required |
| Stack-Blanking Board | TBD | TBD | Passive/near-passive — likely no active power needed |

> **⚠️ Signal layout pending:** Full signal assignment for Cypher Board ↔ Stack-Input and Cypher Board ↔ Stack-Output connections still to be defined by user. This will determine connector pin counts and complete the mechanical assembly picture.

### Boards Affected / Fate

| Board | Current Role | Fate |
|---|---|---|
| **STA** — Stator | CPLD-based signal switching backplane | ➜ Circuits migrate to **Cypher Board**; standalone board retired |
| **REF** — Reflector | Signal reflection path | ➜ Circuits migrate to **Cypher Board**; standalone board retired |
| **EXT** — Extension | Sits at every 5th position in rotor chain; signal extension + 5V/3V3_ENIG regeneration | ➜ Split into **Stack-Input** (input side) and **Stack-Output** (output side); standalone board retired |
| **AM** — Actuation Module | Separate plug-in module on CTL (STM32G071, motor driver) | ➜ Integrated **natively** into **Stack-Input Board** (not as an attached sub-module). Each mini-stack has its own AM circuits. Standalone AM module board retired. AM attachment point on CTL removed entirely. |
| **CTL** — Controller | Hosts JM and AM connection points | ➜ Modified: loses JTAG Module circuit and AM attachment connector (J11 DF40); **no AM of any form remains on CTL**; gains BtB connection to Cypher Board |
| **JM** — JTAG Module | Currently a module board on CTL | ➜ Moves to **Cypher Board** |
| **ENC** — Encoder | Standalone keyboard/encoder interface board | ➜ Becomes a **module-style board** that plugs into Input-Cypher Board and/or Output-Cypher Board via Hirose-style BtB connectors; current SW1–SW40 keyboard switches may become obsolete |
| **ROT** — Rotor | Individual rotor sense boards | ➜ Unchanged (connects within mini-stack between Stack-Input and Stack-Output) |
| **USM** — User Settings | User configuration module | ➜ No change expected |
| **PM** — Power Module | Power supply | ➜ No change expected |

> **New boards summary:** Cypher Board, Stack-Input Board, Stack-Output Board, **Stack-Blanking Board**, Input-Cypher Board, Output-Cypher Board — 6 new boards total.

Additional impact areas to consider:
- Rotor chain physical geometry (Cypher Board as central backplane changes mechanical topology)
- Power distribution along the chain (Stack-Input/Stack-Output replace EXT power regeneration)
- Link-Beta interface (currently CTL→STA): now CTL→Cypher Board via BtB
- BtB interfaces: Cypher Board ↔ CTL, Cypher Board ↔ Input-Cypher Board, Cypher Board ↔ Output-Cypher Board (all Hirose DF40 style — TBC)
- ENC module connector: ENC boards now plug into Input-Cypher and Output-Cypher via Hirose-style BtB (TBC)
- AM-CTL interface (currently DF40 J1/J11): removed from CTL entirely
- JM-CTL interface: removed from CTL; JM now on Cypher Board
- Mechanical enclosure constraints

---

## Proposed Changes

### Summary

The current board-per-function architecture (separate STA, REF, EXT, AM, JM boards) is being consolidated into a new physical assembly concept — the **Rotor Mini-Stack** — centred around a new **Cypher Board** backplane.

- STA + REF merge into a single **Cypher Board**, which acts as the backplane for the rotor mini-stack assembly
- The EXT board is split into **Stack-Input Board** (input side) and **Stack-Output Board** (output side)
- The AM is no longer a plug-in module on CTL; its functionality is integrated natively into the **Stack-Input Board**
- The JM (JTAG Module), currently hosted on CTL, moves to the **Cypher Board**
- CTL is simplified: loses both the JM circuit and the AM attachment point

### Detail

#### Cypher Board
- Replaces both STA and REF as a single unified board
- Acts as a backplane: rotor mini-stacks (Stack-Input + ROT boards + Stack-Output) connect to it
- Inherits all STA CPLD signal-switching circuitry
- Inherits all REF signal-reflection path circuitry
- Hosts the JTAG Module circuitry (migrated from CTL)
- **4 mounts on the back** for ENC plugboard role modules (one per plugboard position)
- **Spade tab connectors on the back** — jack plug harnesses attach here (moved from ENC board); trace routing to/from these is done within the Cypher Board layers
- **6-layer stackup** expected (departure from standard 4-layer; driven by routing density of combined STA+REF+spade-tab traces)
- **Manufacturer note:** JLCPCB 6-layer capability is a known constraint; prototype manufacture may be done by **PCBWay** due to 6-layer board + double-sided assembly requirement
- Exact connector strategy for rotor mini-stack attachment: **TBD**
- BtB connectors to CTL, Input-Cypher Board, and Output-Cypher Board: **TBD**

#### Stack-Input Board
- Input-side board of the Rotor Mini-Stack
- **Front side** (2 keyed stacking connectors): connects to the Cypher Board (first stack) or the rear of the previous mini-stack (subsequent stacks)
- **Rear side** (2 keyed stacking connectors): carries input mating connectors to the first ROT board in the stack
- **Actuation Module circuits are native to this board** — this is the ONLY board in the system that carries AM functionality; there is no AM on CTL or anywhere else
- Each mini-stack therefore has its own independent actuation capability via its Stack-Input Board (STM32G071-equivalent + motor driver, or equivalent circuits)
- AM functionality is native (on-board circuit), NOT an attached sub-module
- Carries a **ribbon cable IDC connector** for ENC_DATA signals — connects to Stack-Output for signal routing within the stack; power is not on this IDC
- Stacking connectors are keyed — only one valid orientation
- Exact connector type, pin count, and signal/power assignment: **TBD**

#### Stack-Output Board
- Output-side board of the Rotor Mini-Stack
- **Rear side** (2 keyed stacking connectors): carries output mating connectors from the last ROT board in the stack
- **Front side** (2 keyed stacking connectors): connects to the next mini-stack front, or to the Stack-Blanking Board on the last stack
- Carries a **ribbon cable IDC connector** for ENC_DATA signals back to Stack-Input
- Stacking connectors are keyed — only one valid orientation
- Exact connector type, pin count, and signal/power assignment: **TBD**

#### Stack-Blanking Board (new)
- Passive (or near-passive) termination board
- Fits on the **rear of the last Rotor Mini-Stack** in the chain
- Completes all required system wiring (signal terminations, power rails, etc.)
- Exact content: **TBD** (depends on what the stacking connectors carry)

#### CTL Board Changes
- JTAG Module circuit removed (moves to Cypher Board)
- AM attachment connector (currently J11, DF40) removed — **no AM of any form remains on CTL**
- Link-Beta now targets Cypher Board instead of STA
- All other CTL functionality unchanged

#### Input-Cypher Board (new)
- Essentially the keyboard panel board
- Accepts **1 ENC module** via Hirose-style BtB connector
- Opposite face carries **mechanical keyboard style buttons** (MX-compatible or similar — exact switch TBD)
- BtB connection to the Cypher Board
- **Debounce question (open):** the ENC CPLD must debounce all 64 input lines; if the EPM570 (or equivalent) does not have sufficient logic cells to implement debounce for all 64 lines, dedicated debounce circuitry will be added to this board instead
- Input-Cypher and Output-Cypher boards can connect **in either order** and chain from one to the other from the Cypher Board connectors
- Exact ENC module connector type and pin count: **TBD**
- Chaining connector and protocol: **TBD (user to describe later)**

#### Output-Cypher Board (new)
- Similar shape and layout to the Input-Cypher Board
- Accepts **1 ENC module** via Hirose-style BtB connector
- Opposite face carries **LEDs** (output display only — no buttons)
- BtB connection to the Cypher Board
- Chains with Input-Cypher Board; can be connected in either order from the Cypher Board connectors
- LED driver location: **TBD** (may be on the ENC module or on this board — see Q21)
- Exact ENC module connector type and pin count: **TBD**
- Chaining connector and protocol: **TBD (user to describe later)**

#### ENC Board Changes
- ENC transitions from a standalone board to a **module-style board**
- **Spade tab connectors REMOVED** from ENC — these move to the back of the Cypher Board
- **SW1–SW40 keyboard switches REMOVED** from ENC — keyboard buttons move to the Input-Cypher Board
- ENC module now contains: CPLD + supporting components + bulk caps + status LED
- **Small connector (one side):** original Stator-side signal connections (what was the stator pin interface)
- **Large connector (other side):** signal lines for what were the spade tab connections (now routed within the Cypher Board layers)
- Plugs into Input-Cypher Board or Output-Cypher Board via Hirose-style BtB connectors
- Exact connector types and pin counts: **TBD**

---

## Current Keyboard Button Components — Obsolescence

The following components are confirmed or expected to become obsolete:

| Board | RefDes | MPN | Description | Status |
|---|---|---|---|---|
| ENC | SW1–SW40 | *(no standard MPN — eBay gadgetskingdom)* | DPDT keyboard switches (current) | ✅ **Confirmed obsolete** — buttons move to Input-Cypher Board as mechanical keyboard switches |

New mechanical keyboard style switches are required for the Input-Cypher Board. The exact MX-compatible (or equivalent) switch and any associated keycap/housing requirements are **TBD**.

> *Confirm exact mechanical keyboard switch specification, including actuation force, travel, MPN, and whether hot-swap sockets are desired.*

---

## New Component Requirements

Any new components introduced by this change will need the following fully confirmed before implementation:

| # | Component Description | Candidate MPN | Manufacturer | Status | Mouser PN | DigiKey PN | JLCPCB PN | KiCAD Symbol | KiCAD Footprint | 3D Model |
|---|---|---|---|---|---|---|---|---|---|---|
| 1 | | | | Pending | | | | | | |

> *Populate this table as component candidates are identified during discussion.*

---

## Discussion

> *Use this section as a running log of decisions, user thoughts, and questions answered during the discussion phase. Add new entries at the bottom with a date.*

### 2026-05-17 — Architectural Restructuring Defined

User described the following changes:

1. **Cypher Board** (new) — STA + REF merged into single backplane board. Also absorbs the JTAG Module from CTL. Rotor mini-stacks attach to this board. BtB connections to CTL, Input-Cypher Board, and Output-Cypher Board.
2. **Stack-Input Board** (new) — input-side split of the EXT board. AM functionality integrated natively (not as a plug-in module). No longer connects to CTL at all.
3. **Stack-Output Board** (new) — output-side split of the EXT board.
4. **Input-Cypher Board** (new) — keyboard panel board. ENC boards attach as module-style boards via Hirose-style BtB connectors. BtB to Cypher Board.
5. **Output-Cypher Board** (new) — lightboard panel board. Also accepts ENC module-style boards via Hirose-style BtB connectors. BtB to Cypher Board.
6. **Rotor Mini-Stack** — assembly concept: Stack-Input + ROT boards + Stack-Output, attaching to the Cypher Board backplane.
7. **CTL** — loses JTAG Module circuit and AM (J11 DF40) attachment point; gains BtB connection to Cypher Board.
8. **AM** — standalone module board retired; functionality moves natively to Stack-Input Board.
9. **STA, REF, EXT** — all standalone boards retired; circuits migrated to new boards above.
10. **JM** — moves from CTL to Cypher Board.
11. **ENC** — becomes a module-style board that plugs into Input-Cypher or Output-Cypher; SW1–SW40 may become obsolete (TBD).
12. Process: define new boards and migrate existing circuits first, then remove old board details.

### 2026-05-17 — Mini-Stack Connector Topology and Stack-Blanking Board Defined

User provided further detail on how the mini-stack chain connects and terminates:

1. **Stack-Input Board** carries the input mating connectors to the first ROT board of the mini-stack. Front side connects to Cypher Board (or previous mini-stack rear). Rear side has mating connectors.
2. **Stack-Output Board** similarly: rear side has output mating connectors from the last ROT board. Front side connects to next mini-stack or Stack-Blanking Board.
3. **Stacking connector layout:** 2 connectors on each side (front and rear) of BOTH Stack-Input and Stack-Output boards = 4 per board. Must be **keyed** — one valid orientation only.
4. **Stacking connectors carry power.** ENC_DATA signals are carried separately via **ribbon cable IDC connectors** (power is NOT on the IDC ribbon).
5. **Stack-Blanking Board** (new — 7th new board): goes on the rear of the last mini-stack to complete system wiring.
6. This topology allows many mini-stacks to be **daisy-chained**: rear of Stack-Output → front of next Stack-Input → ... → Stack-Blanking Board on the final Stack-Output rear.

---

User provided further detail on the ENC module redesign and Cypher Board back-plane specifics:

1. **ENC module content (confirmed):** CPLD + supporting components + bulk caps + status LED only. Spade tab connectors and keyboard switches both REMOVED from ENC.
2. **ENC connector topology:** small connector (one side) for original Stator-side pin connections; large connector (other side) for the former spade-tab signal lines. The Hirose-style BtB connector is the ENC-to-Input/Output-Cypher interface.
3. **Cypher Board back:** 4 mounts for ENC plugboard role modules. Spade tab connectors (for jack plug harnesses) now live here. Trace routing from spade tabs is done within Cypher Board copper layers.
4. **Cypher Board stackup:** 6-layer expected. JLCPCB is a known constraint for 6-layer; PCBWay is the likely prototype manufacturer due to 6-layer + double-sided assembly.
5. **Input-Cypher Board:** 1 ENC module + mechanical keyboard buttons on opposite face. Key open question: whether the ENC CPLD can debounce all 64 inputs — if not, debounce circuitry goes on this board.
6. **Output-Cypher Board:** same shape/layout as Input-Cypher but with LEDs (not buttons).
7. **Chaining:** Input-Cypher and Output-Cypher can connect in EITHER ORDER, chaining from the Cypher Board connectors. Connection detail deferred by user for a later session.
8. **SW1–SW40 obsolescence confirmed:** ENC keyboard switches are retired. New MX-compatible (or similar) mechanical keyboard switches needed on Input-Cypher Board.

---

### 2026-05-17 — Stacking Connector Gender, Position, and Power Assignment (Entry 7)

User defined connector gender, positional layout, orientation, and power split:

1. **Cypher Board: female connectors only** on both the Stack-Input side and the Stack-Output side.
2. **Stack-Input front (right edge): male** at bottom + just above centre. **Stack-Input back (left edge): female** at same positions.
3. **Stack-Output front (left edge): male** at top + just below centre. **Stack-Output back (right edge): female** at same positions.
4. **Positional keying:** Stack-Input connectors (bottom + above-centre) cannot physically mate with Stack-Output connector positions (top + below-centre) — orientation error is mechanically impossible.
5. **Stack-Blanking Board: male** at all four positions — mates with the last mini-stack's back females (Stack-Input left edge + Stack-Output right edge). Can also connect directly to Cypher Board females for transportation without mini-stacks.
6. **Power split:** Stack-Input receives **5V_MAIN + 3V3_ENIG** (AM motor driver needs 5V). Stack-Output receives **3V3_ENIG only**.
7. **Mini-stack front face** = right edge of Stack-Input + left edge of Stack-Output (both face the Cypher Board or previous stack). **Back face** = left edge of Stack-Input + right edge of Stack-Output.

---

User clarified: the Cypher Board connects to **both** Stack-Input and Stack-Output boards (not just one). The prior linear topology diagram was incorrect. The correct topology is:

- Cypher Board has dedicated connections to Stack-Input (input side) **and** Stack-Output (output side) of each mini-stack
- The Rotor boards sit between Stack-Input and Stack-Output within the mini-stack

Full signal layout for these connections is **deferred** — user to define. This signal definition will determine the mechanical assembly geometry of the mini-stack.

---

User confirmed: the Stack-Input Board is the **only** board in the system that carries Actuation Module circuits. Key implications:

1. **AM removed from CTL entirely** — no AM attachment point, no AM signals, no J11 DF40 on CTL.
2. **AM is native to Stack-Input** — not an attached sub-module. The STM32G071-equivalent and motor driver ICs are on the Stack-Input Board PCB itself.
3. **Each mini-stack has independent actuation** — one AM circuit set per mini-stack, housed in its Stack-Input Board. This means rotor position sensing and actuation is fully distributed per stack.
4. **Consequence for power budget:** each Stack-Input Board carries the AM power load; stacking connectors must supply sufficient current for both Stack-Input logic/AM circuits and ROT boards.

---

> *List unresolved questions here. Mark as ✅ when answered.*

| # | Question | Status | Answer |
|---|---|---|---|
| 1 | What connectors/interface does the Cypher Board use for rotor mini-stack attachment? | ❌ Open | |
| 2 | What is the physical form factor / dimensions of the Cypher Board? | ❌ Open | |
| 3 | How does the Stack-Input Board interface with the Cypher Board (connector type, pin count)? | ❌ Open | |
| 4 | How does the Stack-Output Board interface with the Cypher Board (connector type, pin count)? | ❌ Open | |
| 5 | How many Rotor boards sit between the Stack-Input and Stack-Output boards in a mini-stack? | ❌ Open | |
| 6 | Does the ROT board form factor or connector change as a result of this restructuring? | ❌ Open | |
| 7 | Does the AM-native integration on Stack-Input change the motor/actuator wiring to the machine body? | ❌ Open | |
| 8 | Does the JTAG Module on the Cypher Board still connect to the same external FT232H/USB debug path? | ❌ Open | |
| 9 | Does Link-Beta (CTL→Cypher Board) use the same connector and protocol as the current CTL→STA Link-Beta? | ❌ Open | |
| 10 | Does Link-Alpha (PM→CTL) remain unchanged? | ❌ Open | |
| 11 | Do ENC SW1–SW40 become obsolete? | ✅ Answered | Yes — confirmed obsolete. Buttons move to Input-Cypher Board as mechanical keyboard switches. |
| 12 | How many mini-stacks does the Cypher Board backplane support (i.e. how many rotor positions)? | ❌ Open | |
| 13 | Will DECs need to be raised for each board retirement / new board creation? | ❌ Open | |
| 14 | Are there enclosure or panel-mount constraints that affect new board dimensions or connector placement? | ❌ Open | |
| 15 | What exact Hirose connector variant is used for ENC module attachment to Input-Cypher and Output-Cypher boards? | ❌ Open | |
| 16 | How many ENC modules does each of Input-Cypher and Output-Cypher support? | ✅ Answered | 1 ENC module per board (Input-Cypher: 1; Output-Cypher: 1). |
| 17 | What signals does the Input-Cypher Board carry between the ENC module and the Cypher Board? | ❌ Open | |
| 18 | What signals does the Output-Cypher Board carry between the ENC module and the Cypher Board? | ❌ Open | |
| 19 | What is the BtB connector between Input-Cypher Board and Cypher Board (type, pin count, stack height)? | ❌ Open | |
| 20 | What is the BtB connector between Output-Cypher Board and Cypher Board (type, pin count, stack height)? | ❌ Open | |
| 21 | Does the Output-Cypher Board (lightboard) drive LEDs directly, or does it carry signals to LED drivers on the ENC module? | ❌ Open | |
| 22 | Can the ENC CPLD (EPM570) debounce all 64 keyboard input lines within available logic cells? | ❌ Open | Determines whether debounce circuitry must be added to the Input-Cypher Board |
| 23 | If CPLD debounce is insufficient for 64 lines, what debounce approach on Input-Cypher Board? (RC+Schmitt, dedicated IC, other?) | ❌ Open | Depends on Q22 answer |
| 24 | What connector mounts the ENC module on the back of the Cypher Board (type, pitch, stack height)? | ❌ Open | Must suit the plugboard role module mechanical envelope |
| 25 | What is the exact chaining connector and protocol between Input-Cypher and Output-Cypher boards? | ❌ Open | User to describe in a later session |
| 26 | What mechanical keyboard switch type is required for Input-Cypher Board? (MX-compatible? actuation force, travel, hot-swap socket needed?) | ❌ Open | |
| 27 | Will PCBWay be the confirmed prototype manufacturer for the Cypher Board given 6-layer + double-sided assembly? | ❌ Open | JLCPCB 6-layer is a known constraint |
| 28 | What is the connector type for the keyed stacking connectors on Stack-Input/Stack-Output (type, pin count, pitch, keying mechanism)? | ❌ Open | Positional keying confirmed (no mechanical key feature needed); exact connector type TBD |
| 29 | What signals/rails are on the stacking connectors vs what is on the ribbon cable IDC? | ✅ Partial | Stacking connectors: 5V_MAIN + 3V3_ENIG to Stack-Input; 3V3_ENIG only to Stack-Output. ENC_DATA on IDC ribbon. Full signal list TBD (user to define) |
| 30 | What is the ribbon cable IDC connector specification? (pin count, pitch, IDC type, cable width) | ❌ Open | For ENC_DATA transfer between Stack-Output and Stack-Input |
| 31 | Is the Stack-Blanking Board purely passive (shorting jumpers/terminations) or does it contain active components? | ✅ Partial | Passive or near-passive confirmed. Male connectors at all four positions to mate with last mini-stack back females. Can also connect directly to Cypher Board for transport. |
| 32 | How many ROT boards are in a single mini-stack (between Stack-Input and Stack-Output)? | ❌ Open | Determines mini-stack depth and connector reach |
| 33 | How do the Cypher Board connections to Stack-Input and Stack-Output differ in connector type/pin count (they serve different signal sets)? | ✅ Partial | Cypher Board: females only. Stack-Input side: bottom + just above centre. Stack-Output side: top + just below centre. Positional keying prevents swap errors. Full pin count/type TBD. |
| 34 | With AM native to each Stack-Input Board, what is the per-stack power budget for AM circuits (motor driver current, MCU current)? | ❌ Open | Impacts stacking connector current rating; 5V_MAIN on Stack-Input connectors |
| 35 | Is the AM MCU the same STM32G071 as currently used, or will the native integration allow a smaller/different MCU? | ❌ Open | |
| 36 | What is the full signal assignment for Cypher Board ↔ Stack-Input and Cypher Board ↔ Stack-Output connections? | ❌ Open | **User to define — this drives mechanical assembly geometry and connector pin count** |
| 37 | What is the exact connector type and pitch for the stacking connectors (e.g. board-to-board, edge connector, pin header)? | ❌ Open | Must carry power (5V_MAIN at AM motor driver current); positional keying by board position |
| 38 | Does 5V_MAIN pass through the stacking connectors from one mini-stack to the next, or does each mini-stack source its own 5V? | ❌ Open | Determines whether 5V_MAIN is on the Stack-Input back (left edge) female connectors |

---

## Implementation Prerequisites (before any design file changes)

- [ ] All open questions above answered
- [ ] All new component MPNs confirmed with supplier part numbers
- [ ] KiCAD symbol, footprint, and 3D model available for each new component (imported to library)
- [ ] Review-pass-11 complete (no open CRITICAL or HIGH findings)
- [ ] Explicit user implementation approval given (SENARY DIRECTIVE)
- [ ] DEC entries drafted for any architectural changes

---

## Cross-references

- Todo: `extension-mechanical-usage` → `.copilot/todos/extension-mechanical-usage.md`
- Review gate: `review-clean-passes-gate` must be satisfied before design changes begin
- Library: `src/Electronics/Library/LIBRARY_NOTES.md` — any new components must be added here after import
