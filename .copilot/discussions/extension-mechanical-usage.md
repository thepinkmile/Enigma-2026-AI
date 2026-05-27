# Discussion: Extension Mechanical Usage Changes

**Status:** In Discussion — no design changes made yet  
**Todo ID:** `extension-mechanical-usage`  
**Opened:** 2026-05-17  
**Last Updated:** 2026-05-26 (entry 10)

---

## Purpose

This document is a pre-design discussion space. The user has a set of changes in mind that will significantly reshape how the Extension board and the boards it interfaces with physically interact.
All design implications, component requirements, and open questions should be captured here before any changes are made to design specifications or schematics.

**No design files should be modified until this discussion reaches a clear decision point and explicit implementation approval is given.**

---

## Known Scope

### New Boards Being Defined

| New Board Name | Description | Source Circuits |
| --- | --- | --- |
| **Cypher Board** | Central backplane board. Replaces STA + REF. Rotor mini-stacks attach to it. Also absorbs the JTAG Module (from CTL). BtB connections to CTL, Input-Cypher Board, and Output-Cypher Board. Spade tab connectors on back. 6-layer stackup. | STA circuits + REF circuits + JM circuits (from CTL) |
| **Stack-Input Board** | Input-side board of the Rotor Mini-Stack. **Front = right edge** (2 male stacking connectors: bottom + just above centre). **Back = left edge** (2 female stacking connectors: same positions). Input mating connectors to first ROT board. AM circuits native. Receives **5V_MAIN + 3V3_ENIG** via stacking connectors. Carries ribbon cable IDC for ENC_DATA. | EXT input-side circuits + AM circuits |
| **Stack-Output Board** | Output-side board of the Rotor Mini-Stack. **Front = left edge** (2 male stacking connectors: top + just below centre). **Back = right edge** (2 female stacking connectors: same positions). Output mating connectors from last ROT board. Receives **3V3_ENIG only** via stacking connectors. Carries ribbon cable IDC for ENC_DATA. | EXT output-side circuits |
| **Stack-Blanking Board** | Termination board. **Male connectors** matching all four female positions (Stack-Input back + Stack-Output back). Terminates the last mini-stack in the chain. Can also connect directly to Cypher Board female connectors for transport/testing without mini-stacks fitted. Passive or near-passive. | New design |
| **Input-Cypher Board** | New board — essentially the keyboard. 1 ENC module via Hirose-style BtB. Mechanical keyboard buttons on opposite face. BtB connection to Cypher Board. Chains with Output-Cypher Board in either order. | New design; ENC becomes module |
| **Output-Cypher Board** | New board — essentially the lightboard. 1 ENC module via Hirose-style BtB. LEDs on opposite face. BtB connection to Cypher Board. Chains with Input-Cypher Board in either order. | New design; ENC becomes module |

### Rotor Mini-Stack

The Rotor Mini-Stack is the assembly unit consisting of:

- **Stack-Input Board** (front: connects to Cypher Board or previous mini-stack rear; rear: input mating connectors to first ROT board)
- **ROT boards** (5 per mini-stack — one per rotor position in the stack; maximum 6 mini-stacks in the system = 30 rotor positions total)
- **Stack-Output Board** (rear: output mating connectors from last ROT board; front: connects to next mini-stack front or Cypher Board)
- **Stack-Blanking Board** (fitted to the rear of the last mini-stack only — terminates the chain)

#### Stacking Connector Topology

```text
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
| --- | --- | --- | --- | --- |
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

```text
[Cypher Board females] ←→ [Mini-stack 1 front males] ... [Mini-stack 1 back females] ←→ [Mini-stack 2 front males] ... → [Stack-Blanking Board males]
```

**Stack-Blanking Board:**

- Has **male connectors** matching all four female positions (Stack-Input back + Stack-Output back)
- Can be fitted to the last mini-stack to terminate the chain
- Can also connect **directly to the Cypher Board** female connectors for transportation / testing without any mini-stack fitted

**Power rail assignment and pass-through:**

| Board | 5V_MAIN | 3V3_ENIG | Notes |
| --- | --- | --- | --- |
| Stack-Input | ✅ Yes | ✅ Yes | AM motor driver requires 5V_MAIN; logic uses 3V3_ENIG. Both rails received on front-bottom-right and passed through to rear-bottom-right for next mini-stack. |
| Stack-Output | ❌ No | ✅ Yes | Logic only — no 5V_MAIN required |
| Stack-Blanking Board | TBD | TBD | Near-passive; no active ICs expected. Contains internal routing traces for signal return (see Q41). |

**8-connector signal assignment (assembly-level view, from 2026-05-26):**

The 8 inter-stack stacking connectors are named by position when viewing the mini-stack assembly from the front (Cypher Board / previous-stack side) or rear (next-stack / blanking board side).
Connector type expected to be Samtec-style (exact part TBD — see Q28/Q37).
These connectors are distinct from the face-mounted ROT-board Samtec BtB connectors which are internal to the mini-stack and unchanged.

*Front face (Cypher Board / previous-stack side):*

| Connector | Board/Edge | Signals |
| --- | --- | --- |
| **front-top-right** | Stack-Input front (right edge) | ENC_IN[5:0], ENC_OUT[5:0], TTD_IN (TDI from Cypher Board/prev stack to first ROT Board B), TMS, TCK, CPLD_RESET_N |
| **front-bottom-right** | Stack-Input front (right edge) | 3V3_ENIG, 5V_MAIN, GND, ENC_ACTIVE_N (from ENC module — active-low debounced keypress signal; triggers rotor actuation on keypress via native AM circuit) |
| **front-top-left** | Stack-Output front (left edge) | TTD_RETURN — passthrough only (return JTAG TDO path back to Cypher Board) |
| **front-bottom-left** | Stack-Output front (left edge) | ENC_DATA return (ENC_IN[5:0] + ENC_OUT[5:0]) — routed back to Cypher Board CPLD via blanking board |

*Rear face (next-stack / blanking board side):*

| Connector | Board/Edge | Signals |
| --- | --- | --- |
| **rear-top-right** | Stack-Input back (left edge) | Return signals from ribbon cable (ENC_DATA + JTAG TTD) forwarded to next mini-stack front-top-right or blanking board |
| **rear-bottom-right** | Stack-Input back (left edge) | 3V3_ENIG, 5V_MAIN, GND passthrough to next mini-stack front-bottom-right or blanking board |
| **rear-top-left** | Stack-Output back (right edge) | TTD_RETURN passthrough (received from blanking board routing at last mini-stack) |
| **rear-bottom-left** | Stack-Output back (right edge) | 3V3_ENIG, GND — Stack-Output board power supply (ROT face connectors on Stack-Output side have power pins NC to avoid ground loops; power provided by this connector instead — see Q43) |

*Signal flow through a mini-stack:*

1. Cypher Board / previous stack sends data + JTAG forward via **front-top-right** (ENC_IN/OUT, TTD_IN, TMS, TCK, CPLD_RESET_N)
2. Cypher Board / previous stack sends power + ENC_ACTIVE_N via **front-bottom-right** (3V3_ENIG, 5V_MAIN, GND, ENC_ACTIVE_N)
3. Stack-Input routes data and JTAG to face-mounted ROT connectors (Board B Samtec input — same BtB system as current EXT board)
4. Data and JTAG traverse all 5 ROT boards in series
5. Last ROT board (Board A Samtec output) routes into Stack-Output face-mounted connectors
6. Stack-Output connects via ribbon cable IDC back to Stack-Input — returning ENC_DATA and JTAG TTD back-path
7. Stack-Input maps ribbon return to **rear-top-right** and forwards to next mini-stack or blanking board
8. Power and ENC_ACTIVE_N pass straight through Stack-Input: **front-bottom-right** → **rear-bottom-right** (3V3_ENIG, 5V_MAIN, and ENC_ACTIVE_N all pass through;
   each Stack-Input taps ENC_ACTIVE_N locally for its AM circuit)
9. At the last mini-stack: blanking board routes TTD_RETURN to Stack-Output **rear-top-left**; every Stack-Output board has an internal **rear-top-left → front-top-left** passthrough;
   TTD_RETURN daisy-chains forward through all Stack-Output boards back to Cypher Board
10. ENC_DATA return path routes via blanking board back to **front-bottom-left** (Stack-Output) and on to Cypher Board CPLD *(exact chain path for intermediate stacks — see Q45)*

> **Note:** Per-connector pin assignment proposed in Entry 9 (pending user approval — see Q42). 5V_MAIN pin count on front/rear-bottom-right may need review for 6-stack current capacity.
> **Open question:** How does ENC_DATA return chain through intermediate Stack-Output boards — does rear-bottom-left also need ENC_DATA return pins alongside 3V3_ENIG? See Q45.

### Boards Affected / Fate

| Board | Current Role | Fate |
| --- | --- | --- |
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

The current board-per-function architecture (separate STA, REF, EXT, AM, JM boards) is being consolidated into
a new physical assembly concept — the **Rotor Mini-Stack** — centred around a new **Cypher Board** backplane.

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
- Carries a **ribbon cable IDC connector** for return signals — connects to Stack-Output; carries ENC_DATA (ENC_IN/OUT processed by 5 ROTs) and JTAG TTD (last ROT TDO) back to Stack-Input;
  power is not on this IDC
- Stacking connectors are keyed — only one valid orientation
- Exact connector type, pin count, and signal/power assignment: **TBD**

#### Stack-Output Board

- Output-side board of the Rotor Mini-Stack
- **Rear side** (2 keyed stacking connectors): carries output mating connectors from the last ROT board in the stack
- **Front side** (2 keyed stacking connectors): connects to the next mini-stack front, or to the Stack-Blanking Board on the last stack
- Carries a **ribbon cable IDC connector** for return signals back to Stack-Input (ENC_DATA + JTAG TTD from last ROT TDO)
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
- **No dedicated debounce circuitry required:** the ENC CPLD (EPM570T100I5N, 570 LEs) is sufficient to debounce all 64 input lines
  using the shared bank-level architecture defined in `Encoder_Logic.md §5` (~69% LE utilisation — see Q22)
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
| --- | --- | --- | --- | --- |
| ENC | SW1–SW40 | *(no standard MPN — eBay gadgetskingdom)* | DPDT keyboard switches (current) | ✅ **Confirmed obsolete** — buttons move to Input-Cypher Board as mechanical keyboard switches |

New mechanical keyboard style switches are required for the Input-Cypher Board. The exact MX-compatible (or equivalent) switch and any associated keycap/housing requirements are **TBD**.

> *Confirm exact mechanical keyboard switch specification, including actuation force, travel, MPN, and whether hot-swap sockets are desired.*

---

## New Component Requirements

Any new components introduced by this change will need the following fully confirmed before implementation:

| # | Component Description | Candidate MPN | Manufacturer | Status | Mouser PN | DigiKey PN | JLCPCB PN | KiCAD Symbol | KiCAD Footprint | 3D Model |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | - | - | - | Pending | - | - | - | - | - | - |

> *Populate this table as component candidates are identified during discussion.*

---

## Discussion

> *Use this section as a running log of decisions, user thoughts, and questions answered during the discussion phase. Add new entries at the bottom with a date.*

### 2026-05-17 — Architectural Restructuring Defined

User described the following changes:

1. **Cypher Board** (new) — STA + REF merged into single backplane board. Also absorbs the JTAG Module from CTL. Rotor mini-stacks attach to this board.
   BtB connections to CTL, Input-Cypher Board, and Output-Cypher Board.
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
2. **ENC connector topology:** small connector (one side) for original Stator-side pin connections; large connector (other side) for the former spade-tab signal lines.
   The Hirose-style BtB connector is the ENC-to-Input/Output-Cypher interface.
3. **Cypher Board back:** 4 mounts for ENC plugboard role modules. Spade tab connectors (for jack plug harnesses) now live here. Trace routing from spade tabs is done within Cypher Board copper layers.
4. **Cypher Board stackup:** 6-layer expected. JLCPCB is a known constraint for 6-layer; PCBWay is the likely prototype manufacturer due to 6-layer + double-sided assembly.
5. **Input-Cypher Board:** 1 ENC module + mechanical keyboard buttons on opposite face.
   ENC CPLD (EPM570T100I5N) confirmed sufficient to debounce all 64 inputs using the shared bank-level architecture — no debounce circuitry needed on this board (see Q22).
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
5. **Stack-Blanking Board: male** at all four positions — mates with the last mini-stack's back females (Stack-Input left edge + Stack-Output right edge).
   Can also connect directly to Cypher Board females for transportation without mini-stacks.
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

### 2026-05-26 — Signal Assignments, ROT Count, Power, AM, and I/O Board Chaining (Entry 8)

User provided detailed answers to multiple open questions:

1. Q36 — Signal assignment per connector (now defined):
   - **front-top-right (Stack-Input):** ENC_IN[5:0], ENC_OUT[5:0], TTD_IN (JTAG TDI from Cypher Board or previous stack to first ROT Board B), TMS, TCK, CPLD_RESET_N
   - **front-bottom-right (Stack-Input):** 3V3_ENIG, 5V_MAIN, GND, ENC_ACTIVE_N (from ENC module — active-low debounced keypress signal; triggers rotor actuation on keypress via native AM circuit)
   - **front-top-left (Stack-Output):** TTD_RETURN — passthrough only (return JTAG TDO path back to Cypher Board)
   - **front-bottom-left (Stack-Output):** ENC_DATA return (ENC_IN[5:0] + ENC_OUT[5:0]) — routed back to Cypher Board CPLD via blanking board
   - **rear-top-right (Stack-Input back):** return signals from ribbon cable (ENC_DATA + JTAG TTD) forwarded to next mini-stack front-top-right or blanking board
   - **rear-bottom-right (Stack-Input back):** 3V3_ENIG, 5V_MAIN, GND passthrough to next mini-stack
   - **rear-top-left (Stack-Output back):** TTD_RETURN passthrough (received from blanking board routing at last mini-stack)
   - **rear-bottom-left (Stack-Output back):** 3V3_ENIG + GND (Stack-Output board power; ROT face connectors on Stack-Output side have power pins NC — avoids ground loops — see Q43)
   - Signal flow: front-top-right data/JTAG into Stack-Input → face-mounted ROT connectors (Board B Samtec input, unchanged) → 5 ROT boards in series → last ROT Board A Samtec output
     → Stack-Output → ribbon cable IDC back to Stack-Input → out rear-top-right
2. Q5/Q32 — ROT boards per mini-stack:
   - **5 ROT boards per mini-stack.** Maximum 6 mini-stacks = 30 rotor positions total.
3. Q28/Q37 — Stacking connector type:
   - Expected to be Samtec-style. Exact part not yet selected — TBD.
4. Q38 — Power pass-through:
   - **Both 3V3_ENIG and 5V_MAIN** pass through Stack-Input: received on front-bottom-right, forwarded out rear-bottom-right to next mini-stack.
5. Q34 — AM power budget:
   - One servo motor + AM circuit (STM32G071 + motor driver) per mini-stack.
   - Max 6 mini-stacks = 6 AM circuits simultaneously.
   - Per-stack AM load = same as current standalone AM board (exact current figures in AM Board Design_Spec).
6. Q35 — AM MCU:
   - Same STM32G071 + motor driver as current AM board — identical circuits, made native to Stack-Input PCB. No changes to the design.
7. Q25 — Input-Cypher / Output-Cypher chaining:
   - 2 male Samtec connectors on the bottom edge of each board; 2 female Samtec connectors on the top edge.
   - **Input-Cypher:** consumes left-most male connector pins (ENC/keyboard signals); left-most female = NC except 3V3_ENIG + GND; right-most male passes through to right-most female.
   - **Output-Cypher:** left-most male passes through to left-most female; consumes right-most male pins (lightboard signals); right-most female = NC except 3V3_ENIG + GND.
   - Either board can be inserted first in the chain — the passthrough pins allow either order.
8. Q26 — Keyboard switch:
   - MX-style mechanical push button (same as modern keyboards). Exact MPN, actuation spec, and hot-swap socket requirement TBD.
9. Q22/Q23 — CPLD debounce capacity analysis (EPM570T100I5N):
   - CPLD confirmed as **EPM570T100I5N** (570 LEs). User clarified they had confused the part with the smaller EPM240.
   - `Encoder_Logic.md §5` already specifies a **shared bank-level debounce** architecture (NOT 64 independent counters):
     three 64-bit bank registers (raw/candidate/stable), one shared stability counter, one shared sample-tick divider.
   - Estimated LE utilisation for ENCODE image: ~394 / 570 LEs (~69% utilisation), ~31% margin.
   - **Conclusion: EPM570 is sufficient. No hardware debounce circuits are needed on Input-Cypher Board.** Pre-synthesis estimate; Quartus fit will give exact figures.

**mini-stack-base-board reminder:**
User noted a future architectural idea — the **`mini-stack-base-board`** — as an alternative to the ribbon cable IDC for the Stack-Output → Stack-Input return path. See Entry 9 and Q44 for the full description.

---

### 2026-05-26 — Q40–Q44 answers; Q42 proposed pin mapping (Entry 9)

**Q40 — TTD_RETURN propagation through intermediate mini-stacks:**

- Every Stack-Output board has a direct **rear-top-left → front-top-left** internal passthrough (no active logic needed).
- The blanking board routes TTD_RETURN to the last Stack-Output's rear-top-left.
- TTD_RETURN then daisy-chains forward through each Stack-Output board's internal passthrough back to the Cypher Board.

**Q41 — Blanking board:**

- Confirmed as a **basic pass-through PCB with routed traces** (not a shorting assembly).
- Internal signal routing detail TBD (which connector to connector, what signals).
- User has a future alternative idea deferred as `signal-trace-simplification-and-routing`.

**Q43 — rear-bottom-left connector:**

- Carries **3V3_ENIG + GND only** — Stack-Output board power supply.
- ROT face connectors on the Stack-Output side have power pins NC (same ground-loop-avoidance pattern as current EXT board J2 being NC; power was provided by Extension Port instead).
- Stack-Output board 3V3_ENIG is provided by this stacking connector instead of via the ROT face-connector chain.
- **Open concern:** for ENC_DATA return to chain through intermediate Stack-Output boards, rear-bottom-left may also need ENC_DATA return pins — which contradicts "3V3_ENIG + GND only." See Q45.

**Q44 / mini-stack-base-board:**

- Proposed as an alternative to the ribbon cable IDC for the Stack-Output → Stack-Input internal return path within each mini-stack.
- Concept: a pass-through PCB using the same connector style as the current STA–CTL interface (board-to-board, not ribbon cable).
- Advantages: mechanically solidifies the mini-stack; better signal integrity than a ribbon cable (ground planes top and bottom for shielding).
- **Not yet part of the current changeset.** User is still in design brain-dump phase. Will be revisited in a dedicated future session if adopted.
- A future discussion label `signal-trace-simplification-and-routing` was also recorded for future work related to blanking board and signal routing simplifications.

---

### 2026-05-26 - Q42 — Updated per-pin signal mapping (Entry 10)

All connectors are Samtec-style, 0.8mm pitch, SMT. Sizes based on ROT face connector precedents (ERM8-005 = 10-pin 2×5; ERM8-010 = 20-pin 2×10). Exact Samtec part numbers TBD (see Q28/Q37).
Per-user request: no reserved/NC pins on Cypher-facing stacking connectors — unused pins are to be tied to GND unless explicitly required to be NC on Cypher Input/Output boards.

#### J_FTR / J_RTR — front-top-right / rear-top-right: 20-pin 2×10 — Forward data / JTAG into next mini-stack

| Pos | Pin A | Pin B | Notes |
| --- | --- | --- | --- |
| 1 | ENC_IN[0] | ENC_IN[1] | Forward data into next stack |
| 2 | ENC_IN[2] | ENC_IN[3] | |
| 3 | ENC_IN[4] | ENC_IN[5] | |
| 4 | GND | GND | Guard |
| 5 | ENC_OUT[0] | ENC_OUT[1] | |
| 6 | ENC_OUT[2] | ENC_OUT[3] | |
| 7 | ENC_OUT[4] | ENC_OUT[5] | |
| 8 | GND | GND | Guard |
| 9 | TMS | TCK | JTAG forward (shared) |
| 10 | TTD (TDI) | CPLD_RESET_N | TTD = TDI for next stack's first ROT |

Notes: front-top-right carries forward ENC_DATA and JTAG/TDI into the next mini-stack. Rear-top-right (on the back face) carries the processed forward signals coming from the ribbon/blanking board.

#### J_FTL / J_RTL — front-top-left / rear-top-left: 20-pin 2×10 — Return data / JTAG return into Cypher Board (Reflector role)

| Pos | Pin A | Pin B | Notes |
| --- | --- | --- | --- |
| 1 | ENC_IN[0] (return) | ENC_IN[1] (return) | Data return from end-of-stack to Cypher Board |
| 2 | ENC_IN[2] (return) | ENC_IN[3] (return) | |
| 3 | ENC_IN[4] (return) | ENC_IN[5] (return) | |
| 4 | GND | GND | Guard |
| 5 | ENC_OUT[0] (return) | ENC_OUT[1] (return) | |
| 6 | ENC_OUT[2] (return) | ENC_OUT[3] (return) | |
| 7 | ENC_OUT[4] (return) | ENC_OUT[5] (return) | |
| 8 | GND | GND | Guard |
| 9 | TTD_RETURN | GND | TTD_RETURN (last ROT TDO path) — routed here by blanking board; paired guard to avoid NC pins |
| 10 | GND | GND | Previously reserved — now GND per user instruction |

Notes: top-left connectors carry the ENC_DATA return path back to the Cypher Board (Reflector). TTD_RETURN is provisioned on top-left and now explicitly paired with GND on the adjacent pin (no NCs left).
Per-user instruction, reserved pins have been converted to GND for robustness and testability.

#### J_FBR / J_RBR — front-bottom-right / rear-bottom-right: 20-pin 2×10 — Power + ENC_ACTIVE_N

Pin numbering convention: left column = Pins 1–10 (top→bottom), right column = Pins 11–20 (top→bottom). Proposed per-pin mapping (explicit linear pins for auditability):

| Pin | Signal | Notes |
| --- | --- | --- |
| 1 | 5V_MAIN | Parallel power pin — AM servo supply |
| 2 | GND | Ground return |
| 3 | 5V_MAIN | Parallel power pin |
| 4 | GND | Ground return |
| 5 | 5V_MAIN | Parallel power pin |
| 6 | GND | Ground return |
| 7 | 5V_MAIN | Parallel power pin |
| 8 | GND | Ground return |
| 9 | 5V_MAIN | Parallel power pin |
| 10 | GND | Ground return |
| 11 | 3V3_ENIG | Logic supply |
| 12 | 3V3_ENIG | Logic supply |
| 13 | 3V3_ENIG | Logic supply |
| 14 | 3V3_ENIG | Logic supply |
| 15 | GND | Ground return |
| 16 | GND | Ground return |
| 17 | GND | Ground return |
| 18 | GND | Ground return |
| 19 | ENC_ACTIVE_N | Debounced keypress (active-low) — local AM trigger |
| 20 | CPLD_RESET_N | CPLD reset (active-low) |

Notes: This linear pin assignment matches the user's approved mapping: pins [1,3,5,7,9] = 5V_MAIN (5 pins), pins [11–14] = 3V3_ENIG (4 pins), pins [2,4,6,8,10,15–18] = GND (9 pins),
pin 19 = ENC_ACTIVE_N, pin 20 = CPLD_RESET_N. The explicit numbering eliminates ambiguity between left/right column interpretation.
Current capacity rationale: ERM8 qualification (2.2 A/pin) and 75% continuous‑use rule were applied during the prior calculation;
adjust counts if further derating or thermal limits are found in the qualification report.

#### J_FBL / J_RBL — front-bottom-left / rear-bottom-left: 10-pin 2×5 — Power only (Stack-Output side)

| Pos | Pin A | Pin B | Notes |
| --- | --- | --- | --- |
| 1 | 3V3_ENIG | 3V3_ENIG | Logic supply for Stack-Output boards |
| 2 | 3V3_ENIG | GND | |
| 3 | GND | GND | |
| 4 | GND | GND | |
| 5 | GND | GND | |

Notes: front-bottom-left / rear-bottom-left remain power-only for Stack-Output boards (3V3_ENIG + GND). ENC_DATA remains carried on the top connectors (forward on top-right; return on top-left).
Per earlier discussion, rear-top-left (Stack-Output back) now carries both TTD_RETURN and ENC_DATA return signals coming from the blanking board, in addition to its passthrough role for TTD_RETURN.

> *Entry 10 updated with user-requested corrections: rear-top-left now includes ENC_DATA return alongside TTD_RETURN; front/rear-bottom-right upgraded to 20-pin for power/GND redundancy;
> reserved pins on top-left changed to GND. User approval requested. Q45 remains marked as resolved if this matches expectations.*

---

### 2026-05-27 — Explicit User Input (Entry 11)

#### Extension Mechanical Usage — Pin Mappings (Draft)

> File generated by Copilot CLI into .copilot/discussions for user editing.
Generated from Entry 10 per-user review.

Connector designators updated to follow standard refdes format.
Rear connectors mirror front signals with inverted I/O roles as defined below; J2/J4/J6/J8 invert Input/Output.

Updated by user based on the intent of the idea trying to be described and badly interpreted by the GPT-5 mini AI model.
This now contains the correct pin mappings the user intended and should be used to fix the incorrect details within Entry 10 of the discussion.

#### J1 — front-top-right (same pin out and connector should be used for the Blanking board connector STA side)

| Note (R1) | Direction (R1) | Signal (R1) | Pin (R1) | Pin (R2) | Signal (R2) | Direction (R2) | Note (R2) |
| - | - | GND | 1 | 14 | GND | - | - |
| - | In | ENC_IN[0] | 2 | 15 | ENC_IN[1] | In | - |
| - | In | ENC_IN[2] | 3 | 16 | ENC_IN[3] | In | - |
| - | In | ENC_IN[4] | 4 | 17 | ENC_IN[5] | In | - |
| - | - | GND | 5 | 18 | GND | - | - |
| JTAG | In | TMS | 6 | 19 | TCK | In | JTAG clock |
| - | - | GND | 7 | 20 | GND | - | - |
| JTAG TDI | In | TTD | 8 | 21 | CPLD_RESET_N | In | active-low |
| - | - | GND | 9 | 22 | GND | - | - |
| - | Out | ENC_OUT[4] | 10 | 23 | ENC_OUT[5] | Out | - |
| - | Out | ENC_OUT[2] | 11 | 24 | ENC_OUT[3] | Out | - |
| - | Out | ENC_OUT[0] | 12 | 25 | ENC_OUT[1] | Out | - |
| - | - | GND | 13 | 26 | GND | - | - |

#### J2 rear-top-right (same pin out and connector should be used for the Cypher board connector STA side)

| Note (R1) | Direction (R1) | Signal (R1) | Pin (R1) | Pin (R2) | Signal (R2) | Direction (R2) | Note (R2) |
| - | - | GND | 1 | 14 | GND | - | - |
| - | Out | ENC_OUT[0] | 2 | 15 | ENC_OUT[1] | Out | - |
| - | Out | ENC_OUT[2] | 3 | 16 | ENC_OUT[3] | Out | - |
| - | Out | ENC_OUT[4] | 4 | 17 | ENC_OUT[5] | Out | - |
| - | - | GND | 5 | 18 | GND | - | - |
| JTAG | Out | TMS | 6 | 19 | TCK | Out | JTAG clock |
| - | - | GND | 7 | 20 | GND | - | - |
| JTAG TDO | Out | TTD | 8 | 21 | CPLD_RESET_N | Out | active-low |
| - | - | GND | 9 | 22 | GND | - | - |
| - | In | ENC_IN[4] | 10 | 23 | ENC_IN[5] | In | - |
| - | In | ENC_IN[2] | 11 | 24 | ENC_IN[3] | In | - |
| - | In | ENC_IN[0] | 12 | 25 | ENC_IN[1] | In | - |
| - | - | GND | 13 | 26 | GND | - | - |

#### J3 — front-top-left (same pin out and connector should be used for the Blanking board connector REF side)

| Note (R1) | Direction (R1) | Signal (R1) | Pin (R1) | Pin (R2) | Signal (R2) | Direction (R2) | Note (R2) |
| - | - | GND | 1 | 13 | GND | - | - |
| - | Out | ENC_IN[0] | 2 | 14 | ENC_IN[1] | Out | - |
| - | Out | ENC_IN[2] | 3 | 15 | ENC_IN[3] | Out | - |
| - | Out | ENC_IN[4] | 4 | 16 | ENC_IN[5] | Out | - |
| - | - | GND | 5 | 17 | GND | - | - |
| last ROT TDO path | Out | TTD_RETURN | 6 | 18 | GND | - | - |
| - | - | GND | 7 | 19 | TTD_RETURN | Out | last ROT TDO path |
| - | - | GND | 8 | 20 | GND | - | - |
| - | In | ENC_OUT[4] | 9 | 21 | ENC_OUT[5] | In | - |
| - | In | ENC_OUT[2] | 10 | 22 | ENC_OUT[3] | In | - |
| - | In | ENC_OUT[0] | 11 | 23 | ENC_OUT[1] | In | - |
| - | - | GND | 12 | 24 | GND | - | - |

#### J4 - rear-top-left (same pin out and connector should be used for the Cypher board connector REF side)

| Note (R1) | Direction (R1) | Signal (R1) | Pin (R1) | Pin (R2) | Signal (R2) | Direction (R2) | Note (R2) |
| - | - | GND | 1 | 13 | GND | - | - |
| - | In | ENC_IN[0] | 2 | 14 | ENC_IN[1] | In | - |
| - | In | ENC_IN[2] | 3 | 15 | ENC_IN[3] | In | - |
| - | In | ENC_IN[4] | 4 | 16 | ENC_IN[5] | In | - |
| - | - | GND | 5 | 17 | GND | - | - |
| last ROT TDO path | In | TTD_RETURN | 6 | 18 | GND | - | - |
| - | - | GND | 7 | 19 | TTD_RETURN | In | last ROT TDO path |
| - | - | GND | 8 | 20 | GND | - | - |
| - | Out | ENC_OUT[4] | 9 | 21 | ENC_OUT[5] | Out | - |
| - | Out | ENC_OUT[2] | 10 | 22 | ENC_OUT[3] | Out | - |
| - | Out | ENC_OUT[0] | 11 | 23 | ENC_OUT[1] | Out | - |
| - | - | GND | 12 | 24 | GND | - | - |

#### J5 — front-bottom-right (20-pin) (J6 rear-bottom-right = same pin mapping, signals I/O inverted)

| Note (R1) | Direction (R1) | Signal (R1) | Pin (R1) | Pin (R2) | Signal (R2) | Direction (R2) | Note (R2) |
| active-low keypress | In | ENC_ACTIVE_N | 1 | 11 | GND | - | - |
| - | - | GND | 2 | 12 | GND | - | - |
| - | - | GND | 3 | 13 | 5V_MAIN | - | - |
| - | - | 5V_MAIN | 4 | 14 | 5V_MAIN | - | - |
| - | - | 5V_MAIN | 5 | 15 | 5V_MAIN | - | - |
| - | - | 3V3_ENIG | 6 | 16 | 3V3_ENIG | - | - |
| - | - | 3V3_ENIG | 7 | 17 | 3V3_ENIG | - | - |
| - | - | GND | 8 | 18 | GND | - | - |
| - | - | GND | 9 | 19 | GND | - | - |
| - | - | GND | 10 | 20 | CPLD_RESET_N | In | active-low |

#### J7 — front-bottom-left (10-pin 2×5) (J8 rear-bottom-left = same pin mapping)

| Note (R1) | Direction (R1) | Signal (R1) | Pin (R1) | Pin (R2) | Signal (R2) | Direction (R2) | Note (R2) |
| - | - | GND | 1 | 6 | GND | - | - |
| - | - | GND | 2 | 7 | GND | - | - |
| - | - | GND | 3 | 8 | GND | - | - |
| - | - | 3V3_ENIG | 4 | 9 | 3V3_ENIG | - | - |
| - | - | 3V3_ENIG | 5 | 10 | 3V3_ENIG | - | - |

---

> *Add new discussion entries above this line. Mark questions as ✅ in the table below when answered.*

| # | Question | Status | Answer |
| --- | --- | --- | --- |
| 1 | What connectors/interface does the Cypher Board use for rotor mini-stack attachment? | ✅ Partial | Samtec-style stacking connectors (exact part TBD — see Q28/Q37). Female connectors on Cypher Board: Stack-Input side (bottom + above-centre positions); Stack-Output side (top + below-centre positions). Signal assignments defined — see Q36. |
| 2 | What is the physical form factor / dimensions of the Cypher Board? | ❌ Open | |
| 3 | How does the Stack-Input Board interface with the Cypher Board (connector type, pin count)? | ✅ Partial | Via front-top-right (data/JTAG) and front-bottom-right (power + ENC_ACTIVE_N) Samtec-style stacking connectors. Exact part and pin count TBD — see Q28, Q37, Q42. |
| 4 | How does the Stack-Output Board interface with the Cypher Board (connector type, pin count)? | ✅ Partial | Via front-top-left (TTD_RETURN passthrough) and front-bottom-left (ENC_DATA return). Exact part and pin count TBD — see Q28, Q37, Q42. |
| 5 | How many Rotor boards sit between the Stack-Input and Stack-Output boards in a mini-stack? | ✅ Answered | **5 ROT boards per mini-stack.** Maximum 6 mini-stacks = 30 rotor positions total. |
| 6 | Does the ROT board form factor or connector change as a result of this restructuring? | ❌ Open | |
| 7 | Does the AM-native integration on Stack-Input change the motor/actuator wiring to the machine body? | ❌ Open | |
| 8 | Does the JTAG Module on the Cypher Board still connect to the same external FT232H/USB debug path? | ❌ Open | |
| 9 | Does Link-Beta (CTL→Cypher Board) use the same connector and protocol as the current CTL→STA Link-Beta? | ❌ Open | |
| 10 | Does Link-Alpha (PM→CTL) remain unchanged? | ❌ Open | |
| 11 | Do ENC SW1–SW40 become obsolete? | ✅ Answered | Yes — confirmed obsolete. Buttons move to Input-Cypher Board as mechanical keyboard switches. |
| 12 | How many mini-stacks does the Cypher Board backplane support (i.e. how many rotor positions)? | ❌ Open | Maximum 6 stacks per user, but maximum Cypher Board backplane capacity TBD |
| 13 | Will DECs need to be raised for each board retirement / new board creation? | ❌ Open | |
| 14 | Are there enclosure or panel-mount constraints that affect new board dimensions or connector placement? | ❌ Open | |
| 15 | What exact Hirose connector variant is used for ENC module attachment to Input-Cypher and Output-Cypher boards? | ❌ Open | |
| 16 | How many ENC modules does each of Input-Cypher and Output-Cypher support? | ✅ Answered | 1 ENC module per board (Input-Cypher: 1; Output-Cypher: 1). |
| 17 | What signals does the Input-Cypher Board carry between the ENC module and the Cypher Board? | ❌ Open | |
| 18 | What signals does the Output-Cypher Board carry between the ENC module and the Cypher Board? | ❌ Open | |
| 19 | What is the BtB connector between Input-Cypher Board and Cypher Board (type, pin count, stack height)? | ❌ Open | |
| 20 | What is the BtB connector between Output-Cypher Board and Cypher Board (type, pin count, stack height)? | ❌ Open | |
| 21 | Does the Output-Cypher Board (lightboard) drive LEDs directly, or does it carry signals to LED drivers on the ENC module? | ❌ Open | |
| 22 | Can the ENC CPLD (EPM570) debounce all 64 keyboard input lines within available logic cells? | ✅ Answered | **Yes — confirmed sufficient.** CPLD is EPM570T100I5N (570 LEs). Using the shared bank-level debounce architecture from `Encoder_Logic.md §5` (3 × 64-bit bank registers, shared stability counter, shared sample-tick divider — NOT 64 independent counters), estimated LE utilisation for the ENCODE image is ~394/570 LEs (~69%), leaving ~31% margin. **No hardware debounce circuitry is needed on Input-Cypher Board.** Pre-synthesis estimate; Quartus fit will give exact figures. |
| 23 | If CPLD debounce is insufficient for 64 lines, what debounce approach on Input-Cypher Board? (RC+Schmitt, dedicated IC, other?) | ✅ Answered | Not required — EPM570 capacity is sufficient (see Q22). |
| 24 | What connector mounts the ENC module on the back of the Cypher Board (type, pitch, stack height)? | ❌ Open | Must suit the plugboard role module mechanical envelope |
| 25 | What is the exact chaining connector and protocol between Input-Cypher and Output-Cypher boards? | ✅ Answered | 2 male Samtec connectors on bottom edge + 2 female on top edge of each board. Input-Cypher: consumes left male, right male passes through to right female, left female NC (except 3V3_ENIG + GND). Output-Cypher: consumes right male, left male passes through to left female, right female NC (except 3V3_ENIG + GND). Either board may be inserted first. Exact Samtec part TBD. |
| 26 | What mechanical keyboard switch type is required for Input-Cypher Board? (MX-compatible? actuation force, travel, hot-swap socket needed?) | ✅ Partial | MX-style mechanical push button (same as modern keyboards). Exact MPN, actuation spec, and hot-swap socket requirement TBD. |
| 27 | Will PCBWay be the confirmed prototype manufacturer for the Cypher Board given 6-layer + double-sided assembly? | ❌ Open | JLCPCB 6-layer is a known constraint |
| 28 | What is the connector type for the keyed stacking connectors on Stack-Input/Stack-Output (type, pin count, pitch, keying mechanism)? | ✅ Partial | Expected to be Samtec-style; exact part not yet selected. Positional keying by connector position confirmed (no separate mechanical key feature). Pin count driven by Q36/Q42 signal assignment. |
| 29 | What signals/rails are on the stacking connectors vs what is on the ribbon cable IDC? | ✅ Answered | **Stacking connectors (front-top-right):** ENC_IN[5:0], ENC_OUT[5:0], TTD_IN, TMS, TCK, CPLD_RESET_N. **(front-bottom-right):** 3V3_ENIG, 5V_MAIN, GND, ENC_ACTIVE_N. **(front-top-left):** TTD_RETURN passthrough. **(front-bottom-left):** ENC_DATA return. **Ribbon cable (IDC):** return path — ENC_DATA + JTAG TTD from Stack-Output back to Stack-Input within one mini-stack. |
| 30 | What is the ribbon cable IDC connector specification? (pin count, pitch, IDC type, cable width) | ❌ Open | Carries ENC_DATA + JTAG TTD return from Stack-Output to Stack-Input within one mini-stack |
| 31 | Is the Stack-Blanking Board purely passive (shorting jumpers/terminations) or does it contain active components? | ✅ Partial | Near-passive confirmed; no active ICs expected. Must contain routing traces to carry TTD_RETURN from Stack-Input rear-top-right to Stack-Output rear-top-left, and ENC_DATA return to front-bottom-left. Not a purely passive shorting board. Exact internal wiring TBD — see Q41. |
| 32 | How many ROT boards are in a single mini-stack (between Stack-Input and Stack-Output)? | ✅ Answered | **5 ROT boards per mini-stack.** |
| 33 | How do the Cypher Board connections to Stack-Input and Stack-Output differ in connector type/pin count (they serve different signal sets)? | ✅ Partial | Both Samtec-style (exact part TBD). front-top-right (Stack-Input): data + JTAG forward. front-bottom-right (Stack-Input): power + ENC_ACTIVE_N. front-top-left (Stack-Output): TTD_RETURN. front-bottom-left (Stack-Output): ENC_DATA return. Per-connector pin count TBD — see Q42. |
| 34 | With AM native to each Stack-Input Board, what is the per-stack power budget for AM circuits (motor driver current, MCU current)? | ✅ Partial | One servo + STM32G071 + motor driver per mini-stack. Per-stack AM load = same as current standalone AM board. Max 6 stacks = 6 AM circuits simultaneously. Exact current figures in AM Board Design_Spec. |
| 35 | Is the AM MCU the same STM32G071 as currently used, or will the native integration allow a smaller/different MCU? | ✅ Answered | Same STM32G071 + motor driver as current AM board — identical circuits, made native to Stack-Input PCB. |
| 36 | What is the full signal assignment for Cypher Board ↔ Stack-Input and Cypher Board ↔ Stack-Output connections? | ✅ Answered | See 8-connector signal assignment table in Known Scope section and Discussion entry 2026-05-26. |
| 37 | What is the exact connector type and pitch for the stacking connectors (e.g. board-to-board, edge connector, pin header)? | ✅ Partial | Expected Samtec-style (exact part TBD). Must carry 5V_MAIN at AM motor driver current. Positional keying by board position. |
| 38 | Does 5V_MAIN pass through the stacking connectors from one mini-stack to the next, or does each mini-stack source its own 5V? | ✅ Answered | Both 3V3_ENIG and 5V_MAIN pass through Stack-Input: received on front-bottom-right, forwarded out rear-bottom-right to next mini-stack. |
| 39 | Is KEYPRESS_N the same signal as ENC_ACTIVE_N defined in `Encoder_Logic.md §4.5` (active-low when a debounced printable keyboard event is active)? Or is it a distinct new signal? | ✅ Answered | Confirmed: the signal is **ENC_ACTIVE_N** — the debounced keypress signal from the ENC module. All prior references to KEYPRESS_N updated to ENC_ACTIVE_N. |
| 39a | User referenced the CPLD as "EPM540" — confirmed as EPM570T100I5N (570 LEs). User clarified they had confused the part with the smaller EPM240. | ✅ Answered | EPM570T100I5N confirmed. |
| 40 | How does TTD_RETURN propagate back through intermediate mini-stacks (not the last one)? At the last mini-stack the blanking board routes it — but in intermediate stacks, what carries TTD_RETURN from rear-top-left forward toward the Cypher Board? | ✅ Answered | **Every Stack-Output board** has a direct **rear-top-left → front-top-left** internal passthrough. The blanking board routes TTD_RETURN to the last mini-stack's Stack-Output rear-top-left, then it daisy-chains forward through each Stack-Output board (rear-top-left → front-top-left passthrough) back to the Cypher Board. No active logic needed on Stack-Output boards — purely a trace passthrough. |
| 41 | The blanking board must route TTD_RETURN from Stack-Input rear-top-right to Stack-Output rear-top-left — does this mean it is a routed PCB with traces (not just a shorting assembly)? What exactly does the blanking board contain? | ✅ Answered | Confirmed as a **basic pass-through PCB with routed traces** (not a shorting assembly). Contains routed PCB traces completing required signal connections between the 8 stacking connector positions at the end of the chain. Exact internal routing detail TBD. User has a future alternative idea deferred as `signal-trace-simplification-and-routing`. |
| 42 | Full per-pin signal assignment within each of the 8 connectors: which specific pins carry which signals? This drives the minimum pin count and Samtec part selection for each connector. | ✅ Proposed | Proposed pin tables presented in Entry 9 — **pending user approval.** 5V_MAIN current capacity concern flagged (3 pins = ~3A; 6-stack max requires ~6A — confirm against selected connector rating). ENC_DATA return chain question flagged as Q45. Once approved, update to ✅ Answered. |
| 43 | What signal does the rear-bottom-left connector (Stack-Output back, right edge) carry? | ✅ Partial | **3V3_ENIG + GND only** — Stack-Output board power supply. ROT face connectors on the Stack-Output side will have power pins NC (same ground-loop-avoidance pattern as current EXT board J2). Stack-Output board 3V3_ENIG is provided by this stacking connector instead. **Open:** may also need to carry ENC_DATA return for intermediate mini-stack chain — see Q45. |
| 44 | `mini-stack-base-board` — alternative to the ribbon cable IDC for the Stack-Output → Stack-Input return path within each mini-stack. | ✅ Answered | Pass-through PCB using the same connector style as the current STA–CTL interface. Advantages: mechanically solidifies the mini-stack; better signal integrity than ribbon cable (ground-plane shielding top + bottom). **Not yet part of the current changeset** — user still in design brain-dump phase. To be revisited in a dedicated future session if adopted. |
| 45 | **ENC_DATA return chain:** front-bottom-left carries ENC_DATA return toward Cypher Board. Resolution: rear-top-left now carries ENC_DATA return alongside TTD_RETURN; front/rear-bottom-right upgraded to 20-pin for power/GND redundancy; reserved pins converted to GND. | ✅ Answered | See Entry 10 (2026-05-26) — rear-top-left updated to include ENC_DATA return and TTD_RETURN; front/rear-bottom-right mapping published (pins 1,3,5,7,9 = 5V_MAIN; pins 11–14 = 3V3_ENIG; pins 2,4,6,8,10,15–18 = GND; pin 19 = ENC_ACTIVE_N; pin 20 = CPLD_RESET_N). |

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
