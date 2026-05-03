# Rotor Mechanical Design Specification

**Status:** Draft
**Project:** Enigma-NG
**Author:** Izzyonstage & GitHub Copilot
**Version:** v.0.1.0
**Associated Hardware Revision:** Rev A
**Last Updated:** 2026-04-12

---

## 1. Overview

The Enigma-NG rotor is a split two-board assembly consisting of Board A (input side) and
Board B (output side), both circular PCBs (Ø92mm), housed inside an aluminium shroud (Ø100mm
outer diameter). The shroud is the outer rotating element; the PCB/chassis assembly is the
static inner hub.

Total outer diameter matches the original Enigma machine (~100mm) for authentic proportions.

> **Cross-reference:** For the electrical specification (CPLD, FDC2114 encoder ICs, connector
> pinouts, BOM, FR/DR requirements), see
> `design/Electronics/Rotor/Design_Spec.md`.

---

## 2. Rotor Assembly Dimensions

| Feature | Nominal | Notes |
| :--- | :--- | :--- |
| Outer rotor diameter (shroud) | Ø100mm | Matches original Enigma rotor |
| Shroud wall thickness (radial) | 4mm | Houses rolling-pin bearing pockets |
| PCB diameter (Board A and Board B) | Ø92mm | Inside shroud |
| Total rotor assembly thickness | ~15mm | Board A + gap + Board B |
| PCB thickness (each board) | 1.6mm | Standard PCB |
| Internal board gap | ~11.8mm | Between inner faces of boards |
| Character engraving radius | r=50mm | On outer cylindrical face of shroud |
| Capacitive sensor electrode radius | r=44mm | On PCB flat face |
| Central shaft hole diameter (both PCBs) | Ø10mm nominal (TBD) | Through-hole, 8-12mm range; confirmed once rotor actuation shaft diameter is fixed |
| Central keep-out zone radius (both PCBs) | r ≥ 6mm | No copper, components, or traces within 6mm of board centre; driven by shaft clearance |

---

## 3. Manufacturing Tolerances

All mechanical parts must be manufactured to the tolerances specified below.

| Feature | Nominal | Tolerance | Standard / Notes |
| :--- | :--- | :--- | :--- |
| Shroud outer diameter | Ø100mm | ±0.1mm | CNC machined aluminium |
| Shroud inner bore (PCB fit) | Ø92mm | H7 (+0.000/+0.035mm) | Clearance fit for rotation |
| Shroud wall thickness | 4mm | ±0.1mm | CNC machined |
| PCB outer diameter | Ø92mm | ±0.2mm | JLCPCB PCB fabrication |
| PCB thickness | 1.6mm | ±0.1mm | PCB fabrication standard |
| Board gap | ~11.8mm | ±0.5mm | IDC connector + PCB thickness stack |
| Capacitive sensor gap (PCB face to shroud flange) | 0.5mm | ±0.15mm | Controlled by bearing precision - critical for FDC2114 sensor reliability |
| Gray code slot angular position | - | ±0.1° | CNC milled, per-slot angular tolerance |
| Gray code slot depth | 0.5mm | ±0.05mm | Milled into shroud flange inner face |
| Character engraving depth | 0.4mm | ±0.1mm | Milled on shroud outer cylindrical face |
| Character engraving width | per-character | ±0.1mm | CNC |
| Rolling element diameter | TBD | ±0.01mm | Matched set required for even load |
| Central shaft hole diameter (each PCB) | Ø10mm nominal (TBD) | ±0.2mm | NPTH (non-plated through-hole); final size confirmed once shaft diameter fixed |
| Central shaft hole position | Board centre | ±0.1mm | Must be concentric with PCB outer diameter |

> **Note on capacitive gap:** The FDC2114RGHR sensor sensitivity must be validated across the
> full tolerance range (0.35mm minimum to 0.65mm maximum gap). Bearing precision directly
> determines sensor reliability.

---

## 4. Shroud Design

* **Material:** Aluminium alloy (grade TBD - suggest 6061-T6 for machinability and surface finish)
* **Manufacturing:** CNC machined
* **Style:** Dish-shaped outer shell. Board A PCB and chassis mount inside the dish. A cover
  plate (Board B side) screws down from the Board B side.
* **Bearing mechanism:** Rolling-pin style cylindrical bearings around the inner circumference
  of the shroud. Bearing pockets machined into the shroud inner wall.
* **Rolling elements:** Must use ceramic or nylon rolling elements - **electrically isolating
  required**. The aluminium shroud must remain electrically floating relative to PCB ground.
  Metal rolling elements must NOT be used.
* **Outer face:** Characters engraved on the outer cylindrical face at r=50mm. Engraving depth
  0.4mm ±0.1mm. Character height/width to suit per-segment arc width (N=26: 12.08mm arc;
  N=64: 4.91mm arc at r=50mm).
* **Inner flanges (brake-caliper style):** The shroud flanges extend over both PCB flat faces.
  The inner face of each flange carries the Gray code encoder slot pattern (see §5).
* **Electrical isolation:** The shroud must remain floating. Do not ground the shroud to the
  PCB or chassis. Specify this explicitly on assembly drawings.

---

## 5. Capacitive Encoder Slot Patterns

The Gray code encoder pattern is machined as slots/pockets into the inner face of the shroud
flanges. No electronic components are present on the shroud.

**Sensing principle:** Solid aluminium over a sensor electrode = high capacitance; milled slot
(air) = low capacitance. The FDC2114RGHR on the PCB measures these changes as the shroud
rotates.

**Sensor electrode radius:** r=44mm on the PCB flat face (bare copper electrode pads, no
components).

### 5.1 N=64 Rotor (dual-track)

* **Track A** (bits[5:3]): milled into inner face of shroud **dish** (Board A side flange)
* **Track B** (bits[2:0]): milled into inner face of shroud **cover** (Board B side flange)
* 3 sensor electrodes per track (6 total, 3 per PCB)
* Encoding: standard 6-bit reflected (binary) Gray code - perfect Gray code, zero multi-bit
  transitions including wrap-around
* Arc per segment at r=44mm: 4.32mm

> **Cross-reference:** `design/Electronics/Rotor/Rotor_64_Char_Design.md §7` for full bit
> patterns.
>
### 5.2 N=26 Rotor (single-track, Board A only)

* **Track A** (5-bit STGC): milled into inner face of shroud **dish** (Board A side flange)
  only
* Board B side flange: no encoder slots (plain inner face)
* 5 sensor electrodes on Board A only (4 read by U2, addr 0x2A, STGC bits[3:0]; 1 read by U3,
  addr 0x2B, STGC bit[4]; both FDC2114RGHR ICs on Board A)
* Encoding: Single-Track Gray Code (STGC) - nearest achievable to Gray code for N=26
  (non-power-of-2)
* Arc per segment at r=44mm: 10.63mm

> **Cross-reference:** `design/Electronics/Rotor/Rotor_26_Char_Design.md §7` for track
> pattern.

---

## 6. Internal Header Assembly

* **Connector type:** Eight single-row 2.54mm THT pin headers, four per board face. Board A:
  J7 (Adam Tech RS1-05-G 1x5 female), J8 (Adam Tech RS1-05-G 1x5 female), J11 (Adam Tech
  PH1-05-UA 1x5 male), J14 (Adam Tech PH1-07-UA 1x7 male). Board B: J9 (Adam Tech RS1-05-G
  1x5 female), J10 (Adam Tech RS1-07-G 1x7 female), J12 (Adam Tech PH1-05-UA 1x5 male), J13
  (Adam Tech PH1-05-UA 1x5 male). Mixed gender provides physical keying.
* **Keying:** Board A carries J11 and J14 as male and J7 and J8 as female; Board B carries
  the inverse (J12/J13 male, J9/J10 female). The unique 7-pin footprint of J10/J14 makes
  incorrect board orientation geometrically impossible.
* **Assembly sequence:**
  1. JLCPCB SMT pick-and-place assembly is performed on the outward-facing side of each board
     (Board A and Board B separately).
  2. After JLCPCB assembly, all four headers are **manually soldered** to the inner-facing
     side of each board.
  3. The two boards are then mated via the four headers and secured within the shroud dish.
  4. The shroud cover is fitted and secured.
* **Mated height:** ~8.5mm (fits within 11.8mm board gap; 3.3mm clearance)

> **Cross-reference:** `design/Electronics/Rotor/Design_Spec.md §3.4` for full signal
> pinout of all four headers.

---

## 7. Central Shaft Support

Each rotor PCB pair carries the full mechanical weight of all rotors in the stack on a central metal
rod (shaft) that passes through **both** Board A and Board B via an NPTH centre hole.

**Design intent:**

* The rotor stack connectors (J1-J6 ERM8/ERF8 series) are signal/power connectors and must **not**
  be used as the primary mechanical weight-bearing interface between rotors. The central shaft is the
  sole weight-bearing support.
* The shaft passes through the full rotor stack; all rotors within a group slide onto the shaft and
  are retained by the same shaft mechanism (design TBD - pending Rotor Actuation Assembly spec).

**PCB hole specification:**

| Parameter | Value | Notes |
| :--- | :--- | :--- |
| Hole type | NPTH (non-plated through-hole) | Shaft must be electrically isolated from PCB copper |
| Nominal diameter | Ø10mm TBD | Final size confirmed once actuation shaft diameter is fixed (8-12mm range) |
| Location | Board centre (0,0) | Concentric with PCB outer diameter |
| Keep-out zone | r ≥ 6mm from centre | No copper, components, traces, or vias within this zone |

**Electrical isolation:**

The shaft is a metal rod. It must be electrically isolated from the PCB ground and power planes.
The NPTH construction (no copper barrel) with the copper keep-out zone ensures no continuity between
the shaft and any PCB net. Do not add a mounting pad ring or grounded copper pour extending into the
keep-out zone.

> **Cross-reference:** `design/Mechanical/Rotor_Actuation_Assembly/Design_Spec.md` for shaft
> diameter, material, retention mechanism, and inter-rotor spacing along the shaft axis.

---

## 8. Component Height Constraints

| Zone | Max component height | Notes |
| :--- | :--- | :--- |
| Board A outward face (external) | 5.0mm | Clearance to shroud dish inner wall |
| Board B outward face (external) | 5.0mm | Clearance to shroud cover inner wall |
| Board A inner face | 8.5mm (IDC only) | IDC header + mating header height |
| Board B inner face | 8.5mm (IDC only) | IDC header + mating header height |

---

## 9. Cross-References

| Document | Description |
| :--- | :--- |
| `design/Electronics/Rotor/Design_Spec.md` | Electrical design, BOM, FR/DR requirements |
| `design/Electronics/Rotor/Board_Layout.md` | PCB layout, component placement, ASCII diagrams |
| `design/Electronics/Rotor/Rotor_26_Char_Design.md` | N=26 encoder track pattern and geometry |
| `design/Electronics/Rotor/Rotor_64_Char_Design.md` | N=64 encoder track pattern and geometry |
| `design/Mechanical/Rotor_Actuation_Assembly/Design_Spec.md` | Shaft diameter, retention, and inter-rotor spacing |
| `design/Design_Log.md` | DEC-026 (capacitive encoder), DEC-028 (split-board architecture) |
