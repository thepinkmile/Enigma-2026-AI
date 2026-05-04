# Enigma-NG Global Routing Specification (V1.0)

**Status:** Draft
**Version:** v.0.1.0
**Associated Hardware Revision:** Rev A
**Last Updated:** 2026-04-20

## 1. Trace & Via Geometry

* **Arcs:** All directional changes must use Full Circular Arcs (0.5mm Logic / 1.0mm Power).
* **Teardrops:** 0.5mm curved teardrops required on all High-Current (5.5A+) pads and vias.
* **Fillets:** All PCB corners and internal cutouts must feature a 2.0mm fillet (rounded corners).
* **Standard Radius:** 0.5mm for signal/logic; 1.0mm for power rails.
* **Mitres:** Sharp 45/90-degree corners are strictly prohibited to ensure signal integrity and reduce EMI.
* **Internal Layers:** 10 mil minimum width for signal traces on multi-layer boards.
  * **CI Exception:** Controlled-impedance traces targeting 50 Ω (per DEC-016) shall be routed at the
    width calculated for the target stackup - typically **0.127 mm (5 mil)** on outer layers over a
    contiguous GND plane (microstrip). This overrides the 10 mil minimum for CI-designated JTAG and
    differential signal nets only.
* **Clearance:** 10 mil minimum spacing to reduce crosstalk and noise.
* **Grid Snap:** 0.5mm strict snap for all primary component placement and trace nodes.

### 1.1 Trace Width Standards

**Basis:** IPC-2221A, 2oz finished copper (system-wide per §2), 10°C rise, 25°C ambient.
For 2oz external traces: ~0.15 mm per amp (calculated from IPC-2221A with A = w x 2.76 mil, k = 0.048).
Internal signal traces: use 2.5x the external minimum width for equivalent thermal performance.

| Category | Current Range | Min Width - External (2oz) | Min Width - Internal (2oz) | Notes |
| :--- | :--- | :--- | :--- | :--- |
| Signal / CI | < 0.5 A | 0.20 mm | 0.254 mm (10 mil); CI exception (DEC-016) applies to outer layers only | Logic, I2C, GPIO; JTAG/diff CI at 0.127 mm on outer layers per DEC-016 |
| Low-power supply | 0.5 A - 1.0 A | 0.50 mm | 0.75 mm | 3V3 feeds to low-draw loads |
| Medium supply | 1.0 A - 3.0 A | 0.50 mm - 1.00 mm | 1.00 mm - 2.00 mm | 12 V feeds |
| 3V3_ENIG (canonical) | ≤ 3.0 A | 0.80 mm (system-wide fixed) | copper pour (L3) | Fixed at 0.80 mm on ALL boards regardless of local load; inner L3 pour carries bus current. Any 3V3_ENIG surface trace below 0.80 mm is non-conformant. |
| High-current | 3.0 A - 5.5 A | 1.00 mm - 1.50 mm | copper pour | 5 V/12 V power inputs, OR-ing rails |
| Very high current | > 5.5 A | 2.00 mm + copper pour | copper pour | 5V_MAIN bus; teardrops + 20 mil spokes mandatory per §2.1 |

> * All power rails > 3 A: dedicated inner-layer copper pour mandatory in addition to surface traces.
> * All GND returns: copper pour on dedicated inner layer(s); no GND path via single narrow trace.
> * Widths above are minimums - wider is always preferred where board space allows.
>
## 2. Manufacturing & Mask

* **PCB Stackup:** System-wide 2oz Finished Copper (ensures zero voltage drop across links).
  * **Spec-A:** Dual-Side Assembly + Hidden/Burried Vias.
  * **Spec-B:** Single-Side Assembly (used for prototyping).
* **Mask Type:** NSMD (Non-Solder Mask Defined) for ICs/PowerPAKs; SMD for passives.
* **Expansion:** Global Solder Mask Expansion set to 3mil (0.075mm).
* **Bridge:** Minimum 4mil (0.1mm) Solder Mask Bridge between pads.
* **Thermal:** Type VII (Filled/Capped) Hexagonal Thermal Via Matrix for all high-heat zones.
* **Thermal Mesh:** Large exposed copper zones must use a 45-degree cross-hatch (10-mil trace / 10-mil gap) to prevent board warping during reflow.
* **Mask Clearance:** Global Solder Mask Expansion set to 3mil; Minimum Mask Bridge set to 4mil.
* **Mounting:** M3 PTH holes must be gold-plated (ENIG). Every enclosure-connected board shall
  implement a local `GND_CHASSIS` net and tie its mounting points (or equivalent defined
  mechanical grounding features) to `GND_CHASSIS`.

### 2.1. Advanced Manufacturing

* **Via-in-Pad (POFV):** Mandatory for CM5 and Samtec high-density clusters. Vias must be Epoxy Filled and Capped (IPC-4761 Type VII).
  * **High-Current Thermal Reliefs:** Standard 10-mil spokes are FORBIDDEN on 2oz Power/GND planes for 5.5A+ rails.
  * **Heavy Spokes:** All high-current via-in-pad clusters (Samtec Alpha/Beta, Buck, eFuse) MUST use 20-mil (0.5mm) wide thermal relief spokes.
  * **Pattern:** 4-spoke orthogonal pattern to ensure reliable solder reflow while maintaining massive current-carrying capacity.

### 2.2. Prototype Standards (Spec-B)

* **Component Placement:** All active and passive components (CPLDs, ICs, SMT Passives) MUST be placed on the Top Layer (L1) for the V1.0 prototype.
* **Bottom Layer (L_MAX):** Reserved primarily for Data Plates and `GND_CHASSIS` pours / shield
  features where the board layout requires them. Any future coupon-based diagnostics should use the
  dedicated coupon area rather than permanent production-board probe banks.

> For full JLCPCB fabrication capabilities, assembly constraints, and stackup specifications,
> see `design/Production/JLCPCB_Manufacturing.md`.

## 3. Power Decoupling

These rules apply to all boards in the Enigma-NG system unless a board's design spec explicitly documents an exemption.

* **CPLD Decoupling Rule:** All Intel MAX II TQFP-100 CPLDs (EPM240T100I5N and EPM570T100I5N) require **8x 100nF (0.1µF) X7R** decoupling capacitors, one per VCC pin, placed within 2 mm of each pin.
* **Bulk Entry Bank Rule:** All boards must place **5x 10µF X7R 25V (0805)** bulk decoupling
  capacitors **per board, per power rail** (one 5-cap bank per distinct power rail present on the
  board), placed at the rail entry point in a **Symmetrical Star/Spoke pattern**.
  Standard part: Samsung CL21B106KAYQNNE (10µF ±10% X7R 25V 0805; Mouser 187-CL21B106KAYQNNE; DigiKey 1276-CL21B106KAYQNNECT-ND; JLCPCB C3039694).
  Voltage derating: 25V ÷ 3.3V ≈ 7.6x (3V3\_ENIG) and 25V ÷ 5.0V = 5.0x (5V\_MAIN) - both exceed the mandatory 2x minimum.
  * Exception: The JTAG Daughterboard is exempt from this rule - see `JTAG_Daughterboard/Design_Spec.md` DR-JDB-11.

### 3.1. Common RGB Sink-Stage Pattern

Use this rule whenever an Enigma-NG board implements firmware-controlled RGB indicator cathode switching
with discrete low-side devices.

* **Device:** One `BSS138` N-channel MOSFET per switched colour rail.
* **Source:** Tie directly to `GND`.
* **Drain:** Connect to the switched colour cathode rail or equivalent shared LED return node.
* **Gate drive:** Drive from the controlling logic output through a **1kΩ** series gate resistor.
* **Gate bias:** Add a local gate pull-down resistor so the MOSFET defaults OFF during reset / startup.
* **Logic behaviour:** GPIO HIGH = MOSFET ON = colour rail sinks to GND. GPIO LOW = MOSFET OFF = colour rail open.
* **Board-local scope:** LED anode routing, series-resistor values, bank grouping, and any parallel
  hardware override path remain board-specific and must be documented in the owning board design.

### 3.2. Per-IC Bypass Capacitors

Every IC shall have a dedicated local 100nF X7R 50V 0402 bypass capacitor on its Vcc/supply pin,
placed within 1mm of the IC on the same layer.

* **Standard part:** Samsung CL05B104KB5NNNC (Mouser: 187-CL05B104KB5NNNC,
  DigiKey: 1276-1009-1-ND, JLCPCB: C1525) - same as the RTC bypass capacitors in the Controller BOM.
* **Placement:** Within 1mm of the IC supply pin on the same layer; connect directly to the Vcc
  pad with the shortest possible trace before joining the power plane.
* **Shared bypass:** Two adjacent ICs whose Vcc pins are ≤2mm apart may share one capacitor;
  otherwise each IC requires a dedicated capacitor.
* **Board-local scope:** Where a board design spec does not explicitly list per-IC bypass
  capacitors for a given IC, the design requirement table for that board shall cite this rule and
  list the specific capacitors added.

> **Note:** ESD protection ICs (TVS arrays) are excluded from the per-IC bypass capacitor rule in §3.2. These devices do not require dedicated decoupling capacitors.

## 4. Mechanical Grounding

* **Mounting Holes:** 3.2mm PTH for M3 screws.
* **Pattern:** Star-Burst (Radial) copper relief (8 spokes, 20-mil width) for mechanical flex.
* **Plating:** 6.0mm Exposed ENIG Gold annular ring on Top and Bottom.
* **Bonding:** On enclosure-connected boards, mechanical grounding features are tied to
  `GND_CHASSIS` for Faraday-cage continuity. This includes mounting holes and any deliberate
  enclosure-contact pads or shield-landing zones.
* **EMI Landing Zones:** 10mm unmasked ENIG gold landing strips are required where a board exposes
  shielded external connectors or otherwise needs a deliberate enclosure-contact pad tied to
  `GND_CHASSIS`.
* **Structural Ground:** Enclosure-connected boards shall keep their mechanical grounding features in
  the `GND_CHASSIS` domain. These features may be extended with local shield islands or EMI landing
  zones, but they must not create a local galvanic bond to signal/power `GND`.

## 4.1. External Connector Face Alignment

* **Global external-face rule:** Board-mounted external connectors that protrude through an enclosure
  wall should target **2.0mm nominal overhang beyond the finished external face** unless a
  board-specific design decision explicitly overrides that value.
* **Intent:** This rule provides a common mechanical target for enclosure-accessible connectors now that
  the Power Module enclosure rear face is itself part of the machine exterior, so legacy deeper
  protrusion assumptions are no longer required.
* **Tolerance / fit-check:** Final wall thickness, bezel geometry, gasket stack, and connector body
  tolerances must still be verified during mechanical prototype fit-check.
* **Exceptions:** Panel-mounted switches, LEDs, buttons, and any connector family whose datasheet
  mechanically prevents a 2.0mm nominal overhang must be handled by explicit board-level documentation.

## 4.2. Mounting Hole BOM Policy

Every board design specification shall explicitly list its mounting holes (designators, size, and
location). The BOM treatment depends on hole purpose:

* **Plain chassis mounting holes** (board-to-enclosure): Use the KiCAD built-in `MountingHole`
  footprint. These are physical PCB features only - no purchasable component exists and **no BOM
  row shall be added** for them.
* **Module attachment standoffs** (board-to-Module): Where a Module (e.g. CM5 = Compute Module 5,
  AM = Actuation Module) is mechanically secured to the host board, SMT standoff components are
  required. These are purchasable parts with a specific footprint and **shall have a BOM row**.
* **Identification:** The term "Module" in this context means a discrete sub-assembly that mounts
  onto the host board (not merely a board-to-board connector). If in doubt, presence of a
  purchasable standoff part number is the distinguishing test.
* **Final positions:** Exact mounting hole coordinates cannot be fully verified until schematic
  capture and PCB layout; all mounting hole locations shall be reviewed as part of the
  `review-mounting-holes` design checkpoint before first manufacture.

## 5. Single-Point GND ↔ GND_CHASSIS Bond (Global Rule)

**The Enigma-NG system must connect signal/power GND to GND_CHASSIS at exactly one galvanic point,
defined on the Power Module only.**

* **Universal enclosure rule:** Every enclosure-connected board shall implement a local
  `GND_CHASSIS` net. Tie all mounting holes and any defined enclosure-contact / shield-contact
  mechanical features to that net so the metal enclosure forms one continuous chassis domain across
  the machine.
* **Daughterboard exception:** Board-mounted daughterboards that do **not** connect directly to the
  enclosure are exempt from the local `GND_CHASSIS` requirement. Treat them as electrical /
  mechanical extensions of their host board rather than as independent chassis-bonded boards.
* **Transient path intent:** The distributed `GND_CHASSIS` domain exists so enclosure-coupled
  transients and shield currents can return through the metalwork toward the single galvanic bond
  without being forced directly into local logic/power `GND` on intermediate boards.
* **Rule:** One and only one galvanic bridge exists between the system GND reference and
  GND_CHASSIS. Multiple bond points create ground loops, which are a leading cause of common-mode
  radiated emissions and conducted susceptibility failures.
* **Placement:** The single bond point must be located as close as possible to the incoming power
  rails - at the boundary between the "dirty" (external/input) side and the "clean" (internal
  signal) side of the system.
* **Implementation:** A dedicated 0Ω link, copper bridge, or direct via connection at the defined
  bond point. Mark clearly on silkscreen and schematic.
* **Board guidance:**
  * **Power Module:** Hosts the only permitted GND ↔ GND_CHASSIS bond at the common power-entry
    point, immediately before the eFuse input. This location is downstream of the source-selection /
    OR-ing stage so the bond remains correct regardless of whether PoE, USB-C, or battery input is
    active. See
    `Certification_Evidence.md §2.2`.
  * **All other enclosure-connected boards:** Implement `GND_CHASSIS` on mounting holes and any
    local shield / enclosure contact features, but keep that chassis domain isolated from
    signal/power `GND` everywhere except the single Power Module bond point.
  * **Non-chassis-connected daughterboards:** Do not create a standalone `GND_CHASSIS` net unless a
    later design explicitly gives that daughterboard a direct enclosure bond path.
* **Reference:** MIL-STD-461G §3.6; documented rationale in `Standards/Certification_Evidence.md §2.2`.

## 6. Branding & Identity (The "Data Plate")

To maintain a unified "Museum-Grade" look, every board must feature the V1.0 Data Plate on the **Bottom Silkscreen (B.Silkscreen)** layer.

* **Background:** Inverted solid white silkscreen rectangular block on the bottom layer.
* **Graphic:** The Enigma silhouette and "ENIGMA-NG" text, knocked out of the white block, revealing the dark green solder mask.
* **Serial Number:** A clear zone within the white block containing the string `JLCJLCJLCJLC` for the JLCPCB automated serial numbering service.
* **Metadata:** Must include `AUSGABE [Rev] V1.0` in ALL-CAPS German typewriter font.
* **Placement:** Positioned in a "Quiet Zone" on the bottom layer, away from critical test points.

## 7. Silkscreen Standards

* **Font:** All text must use the "KiCad Font" with a typewriter-style appearance.
* **Language:** Bilingual German/English (e.g., `SICHERHEITS-PROBE [Safety Probe]`).
* **Warning Labels:** High-voltage or high-energy zones must be demarcated with a 0.2mm border box.

### 7.1 Connector Pin-1 Identification

Every connector or header (J-prefix RefDes) on all Enigma-NG boards shall have a silkscreen
pin-1 marker placed adjacent to pin 1 on the F.SilkS (or B.SilkS for bottom-side parts) layer.

* **Shape:** Solid filled triangle or arrow pointing toward pin 1 (KiCAD standard pin-1
  indicator; minimum 1.0 mm tip-to-base height).
* **Clearance:** The marker must not overlap pad copper, solder mask openings, or courtyard
  boundaries.
* **Polarised connectors:** Where the connector body provides physical polarisation (shroud key,
  asymmetric housing), the silkscreen marker is still required as a visual confirmation aid.
* **Polarity-free connectors:** For connectors where orientation is enforced mechanically (e.g.,
  Hirose DF40 family using asymmetric standoff patterns), the pin-1 marker is especially critical
  and shall appear on **both** the connector footprint and on any mating host-board footprint.
* **Scope:** Applies to all J-prefix connectors and headers on every board, including
  daughterboards and service headers (SWD, UART, JTAG, fan).
* **Verification:** Silkscreen pin-1 markers for all J-prefix RefDes shall be confirmed present
  at the `review-mounting-holes` design checkpoint before first manufacture.

## 9. ESD and TVS Protection

**ESD/TVS protection is required on any connector that is directly accessible from outside the enclosure or that is mated/unmated during normal servicing.**

* **External connectors:** Any port that protrudes through or is directly accessible from the machine exterior (e.g., USB, HDMI,
  panel-accessible connectors) must be protected with an appropriate TVS/ESD suppressor. The specific device, protected nets, working
  voltage, package, and MPN shall be documented in the owning board design specification.
* **Hot-swappable / service-accessible connectors:** Board-to-board connectors on assemblies that are inserted or removed during
  servicing while the system may be powered (e.g., Rotor ERM8/ERF8 connectors for rotor hot-swap - see DEC-045) are treated as
  equivalent to external connectors and **must** be protected with an appropriate TVS/ESD suppressor. The specific device, protected
  nets, working voltage, package, and MPN shall be documented in the owning board design specification.
* **Internal connectors:** Board-to-board connectors (Samtec ERM8/ERF8 BtB stacks **used in a non-hot-swappable context**), inter-board ribbon and harness connectors
  (Extension Port BHR-20, encoder ribbons), Controller dock connectors, service headers (SWD, UART, JTAG), and any other connector
  whose mating occurs exclusively inside the closed enclosure during normal operation do **not** require TVS/ESD protection. Internal signal integrity relies
  on enclosure shielding and the system GND plane.
* **Do not add UNSOURCED ESD placeholders for internal-only boards.** Boards that carry only internal connectors shall state "No
  TVS/ESD protection required - all connectors are internal to the enclosure, per `Global_Routing_Spec.md §9`" in their Thermal &
  ESD section.

## 10. Vendor Pin Name Mapping

Where a vendor IC uses a pin or signal name that does not conform to the Enigma-NG active-low naming
convention (`_N` suffix), the **design net shall be renamed** to comply. The original vendor name must
be noted alongside the design net name in the relevant Design Specification and Board Layout for
traceability, cross-referenced back to this section.

| Vendor | Device Family | Vendor Pin Name | Design Net Name | Notes |
| :--- | :--- | :--- | :--- | :--- |
| Intel (Altera) | MAX II / MAX V CPLD | `DEV_CLRN` | `DEV_CLR_N` | Global asynchronous device clear; active-low; vendor uses `N` suffix without underscore separator |

## 8. Vias & Teardrops

These rules apply to all boards in the Enigma-NG system.

* **VIPPO (Via-in-Pad):** 0.2mm Drill / 0.45mm Diameter (Plugged & Capped).
* **Standard Via:** 0.3mm Drill / 0.6mm Diameter (Staggered zigzag pattern).
  * **Spec-A (Premium):** Blind/Buried Vias (L1-L3) and Back-drilling for all 5Gbps differential pairs to eliminate stubs.
  * **Spec-B (Standard):** Through-hole Vias using POFV (Via-in-Pad). Vias MUST be Epoxy Filled and Capped (IPC-4761 Type VII) to provide a flat solderable surface for CM5/Samtec pads.
* **Teardrops:** Enabled on all signal and power pads to reduce stress and impedance steps.
* **Copper:** 2oz Finished Copper (L1-L6 on 6-layer boards; L1-L4 on 4-layer boards).
* **Finish:** ENIG (Electroless Nickel Immersion Gold) mandatory for 0.4mm pitch integrity (all BtB connector pads and diagnostic probe loops).
