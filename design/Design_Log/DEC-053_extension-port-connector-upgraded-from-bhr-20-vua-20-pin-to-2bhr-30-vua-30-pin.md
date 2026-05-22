## DEC-053 - Extension Port Connector Upgraded from BHR-20-VUA (20-pin) to 2BHR-30-VUA (30-pin)

- **Status:** Active
- **Date:** 2025-07-10
- **Category:** Electrical / Connector Selection
- **Area:** Extension Port - Stator J10, Reflector J4, Extension J7/J8

### Decision

Replace the Adam Tech BHR-20-VUA (20-pin 2x10) with the Adam Tech 2BHR-30-VUA (30-pin 2x15) on
all Extension Port instances (Stator J10, Reflector J4, Extension J7, Extension J8). The approved
30-pin pinout is symmetric end-to-end:

| Pin | Signal | Pin | Signal |
| --- | ------ | --- | ------ |
| 1 | 5V_MAIN | 2 | 5V_MAIN |
| 3 | 3V3_ENIG | 4 | 3V3_ENIG |
| 5 | GND | 6 | GND |
| 7 | ENC_OUT_REF[0] | 8 | ENC_OUT_REF[1] |
| 9 | ENC_OUT_REF[2] | 10 | ENC_OUT_REF[3] |
| 11 | ENC_OUT_REF[4] | 12 | ENC_OUT_REF[5] |
| 13 | GND | 14 | GND |
| 15 | SYS_RESET_N | 16 | TTD_RETURN |
| 17 | GND | 18 | GND |
| 19 | ENC_IN_REF[0] | 20 | ENC_IN_REF[1] |
| 21 | ENC_IN_REF[2] | 22 | ENC_IN_REF[3] |
| 23 | ENC_IN_REF[4] | 24 | ENC_IN_REF[5] |
| 25 | GND | 26 | GND |
| 27 | 3V3_ENIG | 28 | 3V3_ENIG |
| 29 | 5V_MAIN | 30 | 5V_MAIN |

The layout is symmetric: columns 1↔15, 2↔14, 3↔13 are identical; the signal blocks
(ENC_OUT pins 7-12, ENC_IN pins 19-24) are positionally mirrored about the centre pair
(pins 15-16). A keyed (polarised) variant is retained. The connector is from the same Adam Tech
BHR/2BHR series as the previous BHR-20-VUA (same 3 A/pin contact rating, same housing family).

### Rationale

Current-capacity analysis of the 20-pin connector revealed three worst-case violations at full system
build (30 rotors, 5 Extension boards) against the IPC-2221 28 AWG IDC ribbon limit of ~1 A/conductor:

- `3V3_ENIG`: 30 x 55 mA = **1.65 A** via a single pin → 1.65 A/conductor - exceeds limit.
- `5V_MAIN`: 5 extensions x 500 mA = **2.50 A** via 2 pins → 1.25 A/conductor - exceeds limit.
- `GND` return: 4.15 A total via 2 dedicated GND pins → 2.08 A/conductor - exceeds limit.

The 30-pin connector resolves all three:

- `3V3_ENIG`: 1.65 A ÷ 4 pins = **0.41 A/conductor** ✔
- `5V_MAIN`: 2.50 A ÷ 4 pins = **0.63 A/conductor** ✔
- `GND` return: 4.15 A ÷ 8 pins = **0.52 A/conductor** ✔

All rails are within the 1 A/conductor 28 AWG IDC ribbon limit. The 2BHR-30-VUA connector pin rating
(3 A/pin) is not the binding constraint; the IDC ribbon cable is. The symmetric, mirrored layout
satisfies an aesthetic consistency preference.

### Approved Part Numbers - 2BHR-30-VUA

| Supplier | Part Number |
| --- | --- |
| DigiKey | `2057-2BHR-30-VUA-ND` |
| Mouser | `737-2BHR-30-VUA` |
| JLCPCB | `C17346400` |

### Impact

- `design/Electronics/Stator/Board_Layout.md §1 J10` - authoritative pinout rewritten to 30-pin; pending-review note removed.
- `design/Electronics/Stator/Design_Spec.md` - FR-STA-04, DR-STA-05, §4 Interconnects, §8 ESD, BOM updated.
- `design/Electronics/Extension/Board_Layout.md` - §2/§3 section headings, cross-reference notes, §5/§5.2 power notes, §7 ESD reference updated.
- `design/Electronics/Extension/Design_Spec.md` - DR-EXT-08, DR-EXT-12, §2 Connectivity pin references, §5 ESD reference, BOM J7/J8 updated.
- `design/Electronics/Reflector/Design_Spec.md` - DR-REF-03, §2/§3 connector descriptions, JTAG warning block pin references, §4 power entry note, BOM J4 updated.
- `design/Electronics/Consolidated_BOM.md` - BHR-20-VUA row split; new 2BHR-30-VUA row added.
- `design/Electronics/System_Architecture.md` - JTAG chain diagram pin references updated.
- `design/Electronics/Investigations/JTAG_Integrity.md` - TTD_RETURN ribbon diagram pin references updated.
- `design/Electronics/Rotor/Board_Layout.md` - TTD_RETURN routing note updated.

---

## Open Questions

Questions raised during design review that are deferred pending further investigation or a future decision.

---

## QUE-001 - Exposed ENIG on Rib Clearway for GND_CHASSIS EMI Bonding

- **Status:** Closed - resolved by DEC-020 (2026-04-08)
- **Raised:** 2026-04-04
- **Area:** Power Module / All Boards - PCB Finish & EMC

### Background

The Power Module enclosure uses internal aluminium compression ribs that locate the PCB within the "Power Can".
The supercap block §4 defines a **2.0mm rib clearway** (14mm pitch, 12mm cell body) as a no-fly zone for traces on all layers.
A separate GND_CHASSIS copper pour already exists in the supercap shadow zone beneath the cells (§5).

The question is whether the rib clearway should have an **explicit solder mask opening (exposed ENIG)** on the top copper layer, connected to the GND_CHASSIS net,
so that when the PCB seats in the enclosure the aluminium ribs make direct electrical contact with the board's chassis ground.
This is a standard EMC bonding technique used in Eurocard/VME card-cage designs.

### What the change would involve

If accepted, the following updates would be made:

1. **Power Module Design_Spec.md §4** - Add bullet:
   > - **Rib Clearway ENIG Bond:** A solder mask opening (exposed ENIG) is placed in the 2.0mm rib clearway gap on the top copper layer, connected to GND_CHASSIS.
   >   Contact with the aluminium enclosure rib creates a distributed chassis ground bond at the supercap block location.

2. **Power Module Board_Layout.md** - Add keepout note:
   > Rib clearway gap: solder mask open, GND_CHASSIS copper strip, min 1.5mm wide x full rib depth.

3. **All other boards (Controller, Stator, Encoder)** - Assess whether their enclosure ribs also warrant the same treatment and add matching callouts if so.

4. **DEC-020** - Create a decision entry recording the EMC rationale, referencing the single-point GND_CHASSIS bond rule in Certification_Evidence.md §2.2.

### Considerations

| Factor | Note |
| ------ | ---- |
| Contact reliability | ENIG is ideal - hard, oxidation-resistant, consistent contact resistance |
| Enclosure material | Aluminium - no galvanic corrosion risk with ENIG |
| GND_CHASSIS topology | Single-point bond already defined (Cert_Evidence §2.2); rib contact adds distributed HF bond - compatible if star-point rule maintained for DC |
| Mechanical tolerance | Rib must be tight-fitting or spring-loaded to ensure reliable electrical contact |
| Other boards | Only applies where enclosure ribs contact the PCB - needs mechanical review per board |

### Resolution

Accepted. See DEC-020. Decision: expose ENIG on rib clearway zones, add minimum 2-mil polyimide (Kapton)
tape on supercap bodies, and add conductive elastomer gasket strip at the rib-to-PCB contact interface.
Other boards deferred pending mechanical design documentation (rib presence unconfirmed for Stator/Encoder/Rotor;
Controller noted as using 3D-printed prototype chassis with future metal chassis EMI gaskets per Mechanical_Design.md §3).

---

## QUE-002 - Prototype Bench-Testing Cable Strategy for Rotor Stack Connectors

- **Status:** CLOSED - 2026-04-08
- **Raised:** 2026-04-05
- **Area:** All Boards - Rotor Interface Connectors (ERF8/ERM8 0.8mm pitch) & Extension/Reflector Links

### Resolution

**Break-off PCB coupons** are to be included on the Rotor, Stator, Extension, and Reflector boards.
Each coupon is a small PCB tab attached to the main board by mousebite perforations. One coupon per
ERx8 connector. Each coupon fans out the 0.8mm pitch Samtec ERx8 pads to a standard **2.54mm pitch
shrouded IDC box header**, allowing standard ribbon cable assemblies to be used for initial bench
testing without full stack assembly.

**Coupon types required:**

| ERx8 Connector | Pins | IDC Header |
| :--- | :---: | :--- |
| ERM8-005 / ERF8-005 | 10 (2x5) | 2x5 IDC box header, 2.54mm pitch |
| ERM8-010 / ERF8-010 | 20 (2x10) | 2x10 IDC box header, 2.54mm pitch |
| ERM8-020 / ERF8-020 | 40 (2x20) | 2x20 IDC box header, 2.54mm pitch |

**Per-board coupon provision:**

- **Rotor:** 6 coupons - J1 (ERM8-005), J2 (ERM8-005), J3 (ERM8-010), J4 (ERF8-005), J5 (ERF8-005), J6 (ERF8-010)
- **Stator:** 4 coupons - J8 (ERM8-020) + J1/J2/J3 for Slot 1 test (ERF8-005 x2, ERF8-010 x1)
- **Extension:** 6 coupons - J1 (ERM8-005), J2 (ERM8-005), J3 (ERM8-010), J4 (ERF8-005), J5 (ERF8-005), J6 (ERF8-010)
- **Reflector:** 3 coupons - J1 (ERM8-005), J2 (ERM8-005), J3 (ERM8-010)

For final assembly the coupons are snapped off at the mousebite perforations and the ERx8 connectors mate
directly board-to-board. Coupon IDC connector selection (shrouded box header part numbers) and exact
PCB fanout geometry to be defined at schematic/layout phase.

Where early board concepts currently show permanent probe pads or other test-only breakout features,
that access should be reviewed for migration onto the removable coupons during schematic/layout
finalisation so the finished machine does not carry unnecessary permanent diagnostic hardware.

### Background

The rotor-to-rotor, rotor-to-Stator, and rotor-to-Reflector/Extension connections all use the Samtec
Edge-Rate ERF8/ERM8 0.8mm pitch family, which are direct board-to-board connectors with no off-the-shelf
cable assembly equivalent at standard distributors. During prototype bench testing it will not always be
practical to have all boards physically stacked.

The Extension/Reflector link (J7 on Stator, J7/J8 on Extension, J4 on Reflector) and the Encoder ports
(Stator J4-J6) use 2.54mm pitch shrouded IDC headers for which standard ribbon cable assemblies are
readily available.

### Questions to Resolve Before Prototype Build

1. **ERF8/ERM8 0.8mm pitch:** Are Samtec ERCD/ERCC cable assemblies available and stocked at DigiKey
   or Mouser for the ERF8-005 and ERF8-010 series? If not, what is the preferred bench-testing strategy
   (e.g., small bridge PCBs, short rigid extender boards, or FPC/FFC with pitch adapter)?
2. **Connector selection review:** Confirm that ERF8/ERM8 is still the correct family for the final
   design before committing to prototype PCB orders - alternative connector families may offer
   cable-assembly options without changing the electrical design.
3. **2.54mm IDC cables:** Confirm standard IDC ribbon cable lengths and sources for Stator J10
   (16-pin 2x8) and Stator J4-J9 encoder ports (20-pin 2x10).

### Note

This question was deferred to prioritise getting the connector definitions consolidated. The connector
designators and signal assignments are considered stable (pending QUE-002 resolution). If a connector
family change is required for prototype cabling, the affected documents are:
`Stator/Design_Spec.md`, `Extension/Design_Spec.md`, `Reflector/Design_Spec.md`, `Rotor/Design_Spec.md`,
`Consolidated_BOM.md`, and the Design_Log connector inventory.

> **Amendment - DEC-043:** Question 3 referenced "Stator J10 (16-pin 2x8)" - this is stale.
> J10 was widened to **20-pin 2x10 BHR-20-VUA** by DEC-043. The Reflector/Extension link connectors
> (Stator J10, Extension J7/J8, Reflector J4) are all 2.54mm-pitch shrouded IDC BHR-20-VUA headers
> for which standard 20-wire IDC ribbon cable assemblies are commercially available. These connectors
> are **not** Samtec ERF8/ERM8 0.8mm-pitch connectors; they do **not** require break-off PCB coupons
> and are outside the scope of the ERF8/ERM8 bench-test coupon strategy. Cable lengths and sourcing
> for these links can be confirmed at prototype procurement - no design-phase action required.

---

## INC Review History

This section records all INC (inconsistency) items tracked during the design process. Each item was identified during design review, verified, and resolved. All items are closed.

| INC | Area | Description | Original Value | Corrected Value | Status |
| ----- | ------ | ------------- | ---------------- | ----------------- | -------- |
| INC-01 | Power Module eFuse | UVLO/OVLO thresholds inconsistent between README and Design_Spec | README: 12V UVLO / 16V OVP | 11.0V UVLO / 16.9V OVLO (per Design_Spec §5) | ✔ Resolved - README corrected |
| INC-02 | Power Module eFuse | eFuse current limit insufficient for 75W USB-C path. TPS259474L max 5.5A with no headroom at 5.0A worst case | TPS259474L (5.5A ILIM) | TPS25980 (7A ILIM, 16.9V OVLO, VQFN-24). See DEC-005 | ✔ Resolved - DEC-005 |
| INC-03 | Power Module 5V Buck | Single buck insufficient for CM5 25W + other loads | LM61460-Q1 (6A) | Dual LMQ61460-Q1 interleaved (12A total). See DEC-007 | ✔ Resolved - DEC-007 |
| INC-04 | Power Module PD Emulator | TPS25750 PDO listed as "5V/6A" - not a valid USB-C PD current at 5V | "5V/6A" (invalid) | 5V/5A (25W maximum at 5V per USB-C PD spec). See DEC-008 | ✔ Resolved - DEC-008 |
| INC-05 | Link-Alpha BtB Connector | 3V3_SYSTEM routed from CM5 to Power Module on pins 21-24 for RJ45 LED anodes - cross-domain dependency | 3V3_SYSTEM on pins 21-24 (input from CM5) | Removed. 3V3_ENIG generated locally on Power Module. Pins 21-22 → 5V_MAIN; pins 23-24 → GND. See DEC-001 | ✔ Resolved - DEC-001 |
| INC-06 | Power Module PoE | Ag5300 PoE module only supports 802.3at (25.5W PD) - insufficient for full system load ~42W | Ag5300 (802.3at, 25.5W) | Discrete: TPS2372-4 + TPS23730 + Coilcraft POE600F-12LD (802.3bt Type 4 / Class 8, 72W system; T2 transformer = 60W). See DEC-002 | ✔ Resolved - DEC-002 |
| INC-07 | Power Module / Controller | "3.3V/5A Rotors Buck" placed on Controller Board in README; contradicts central power generation principle | README: Rotor Buck on Controller Board | All rails on Power Module. Rotor stack uses 3V3_ENIG. See DEC-011 | ✔ Resolved - DEC-011 |
| INC-08 | Power Module I2C | I2C pull-ups (SDA/SCL 4.7kΩ) tied to 3V3_SYSTEM - invalid once 3V3_SYSTEM removed from Power Module | Pull-ups to 3V3_SYSTEM | Pull-ups moved to 3V3_ENIG | ✔ Resolved |
| INC-09 | Power Module Design_Spec | Internal conflict: §1 stated "16.5V OVP"; §5 stated "17V OVLO" - two different values in same document | §1: 16.5V OVP | 16.9V OVLO (consistent with TPS25980 fixed OVLO variant; §1 corrected) | ✔ Resolved - auto-resolved (16.5V reference not found in any current file) |
| INC-10 | Power Module BOM | Reference designator collision: R1-R3 used for both eFuse ladder resistors AND I2C/reset pull-ups in the same document | R1-R3 dual-use | eFuse ladder: R1/R2/R3. I2C pull-ups: R7/R8. Reset pull-up: R9 | ✔ Resolved - designators renamed |
| INC-11 | Power Module Battery | BATT_PRES_N pull-up R6 tied to 3V3_SYSTEM - invalid once 3V3_SYSTEM removed | R6 pull-up to 3V3_SYSTEM | R6 pull-up moved to 3V3_ENIG | ✔ Resolved |
| INC-12 | Link-Alpha BtB Connector | Power cluster labelled "6A Delivery Cluster" - outdated after dual 12A buck upgrade and pin reallocation | "6A Delivery Cluster" (16 pins) | 9A delivery (18 pins x 0.5A/pin after reallocation). Label updated | ✔ Resolved |
| INC-13 | Power Module USB-C | STUSB4500 specified to negotiate 15V/3A (45W) - only 56.7% eFuse utilisation violation at worst-case 42.5W load | STUSB4500: 15V/3A (45W) | STUSB4500: 15V/5A (75W). See DEC-006 | ✔ Resolved - DEC-006 |
| INC-14 | Controller probe-access concept | Historical Controller bring-up probe pads had no ESD protection while exposed ENIG pads were still present in the concept design | No ESD on bring-up probe pads | Fixed probe-access pads removed from the active board design; any future coupon-based probe access will need a new ESD review | ✔ Resolved - pads removed from active design |
| INC-15 | Controller/Power Module | Internal conflict in Board_Layout.md: bullet list said I2C=pins 35-40, 3V3_ENIG=pins 41-44; ASCII diagram said I2C=35-38, 3V3_ENIG=39-44 | Bullets: I2C 35-40; 3V3_ENIG 41-44 | ASCII diagram authoritative: I2C 35-38, 3V3_ENIG 39-44 (6 pins at 51.4% utilisation) | ✔ Resolved - ASCII diagram is authoritative |
| INC-16 | Board_Layout.md ETH LED diagram | ETH LED diagram showed PIN 27 = ETH_LED_ACT; main pin map shows pins 27-30 = GND Isolation Moat | Diagram: PIN 27 = ETH_LED_ACT | Correct: PIN 26 = ETH_LED_ACT; PIN 27 = GND Moat | ✔ Resolved |
| INC-17 | Power Module Battery | eFuse OVLO margin: with 16.9V OVLO and 4.2V/cell BMS (16.8V max), only 0.1V margin - risk of nuisance trips | BMS max 4.2V/cell (16.8V); OVLO 16.9V; margin 0.1V | BMS must use 4.1V/cell max (16.4V total for 4S), giving 0.5V margin. Added to Design_Spec §2. See DEC-005 | ✔ Resolved |
| INC-18 | Power Module Design_Spec | Battery BMS charge voltage not specified in design spec - required to protect against OVLO nuisance trips | No BMS charge spec | Added: "BMS max charge voltage = 4.1V/cell (16.4V for 4S)" to Power Module §2 Battery Interface | ✔ Resolved |
| INC-19 | Power Module PoE | Ag5300/Ag53000 is 802.3at only (25.5W PD). No 802.3bt Type 4 PCB module found. Architecture change required: Type 3 (51W) insufficient; Type 4 (72W) required | Ag5300/Ag53000 (802.3at SIL module) | Discrete two-stage: TPS2372-4 (PD) + TPS23730 + POE600F-12LD (ACF transformer). See DEC-002 | ✔ Resolved - DEC-002 |
| INC-20 | Power Module Supercap | Supercap charge path had no current limiting - would cause excessive inrush and violate 75% utilisation rule under PoE | Supercap directly on 5V_MAIN bus | LTC3350 soft-charge via RICHARGE resistor; 0.5A limit under PoE. See DEC-004 | ✔ Resolved - DEC-004 |
| INC-21 | Power Module J2 | Component selection locked: RJ45 MagJack | - | Wurth 7499111121A (SMT, shielded, 2-LED, 10/100/1000) | ✔ Locked |
| INC-22 | Power Module ESD | Component selection locked: Ethernet ESD arrays | - | 2x TI TPD4E05U06QDQARQ1 (0.8pF, ±15kV, -40°C to +125°C, U-DFN-10). DigiKey: 296-40696-1-ND; Mouser: 595-PD4E05U06QDQARQ1; JLCPCB: C81353 | ✔ Locked |
| INC-23 | Power Module Bob Smith | Component selection locked: Bob Smith termination network | - | 4x 75Ω 0402 ±1% resistors + 1x 10nF Y1-class capacitor to GND_CHASSIS | ✔ Locked |
| INC-24 | All Boards | Encoder detailed design review phase complete. Two consecutive clean passes (R56 + R57) achieved across all 24 design documents. Key corrections during cycle: GPIO 20/24 swap propagated to all files (R50/R55); LDO load 2.20A→2.11A propagated to all files (R50-R53); Power_Budgets.md CSS2H build qty corrected to 3; JTAG topology (BtB vs ribbon) documented in JTAG_Integrity.md, Extension Design_Spec, Reflector Design_Spec. Extension U1 buffer (SN74LVC2G125DCUR) confirmed correct and intentional. | - | - | ✔ Phase complete |

---

## Board Connector Inventory

The following table lists all physical connectors across every board in the Enigma-NG system. This list should be manually verified against the original intended design to confirm no specification
changes have inadvertently altered connector placement, orientation, or mating requirements.

### Power Module

| Ref | Description | Part / Series | MPN | Mouser PN | DigiKey PN | Notes |
| ----- | ------------- | --------------- | ----- | ----------- | ------------ | ------- |
| J1 | Link-Alpha BtB - 80-pin socket to Controller Board | Samtec ERM8-040-05.0-S-DV-K-TR | ERM8-040 | 200-ERM8040050SDVKTR | SAM8613CT-ND | Male header (ERM8). Mating female on Controller (ERF8). Gold-plated, 0.5A/pin |
| J2 | RJ45 MagJack with integrated magnetics | Wurth 7499111121A | 7499111121A | 710-7499111121A | 1297-1070-5-ND | SMT, shielded, 2 integrated LEDs (green/yellow), 10/100/1000 PoE compatible |
| J3 | Battery connector - 5-pin Micro-Fit 3.0 THT vertical | Molex 43650-0519 | 43650-0519 | 538-43650-0519 | WM14587-ND | 5-circuit, 1-row, gold contacts, board lock, 3mm pitch. ⚠️ MPN corrected (43045-0512 does not exist) |

### Controller Board

| Ref | Description | Part / Series | MPN | Mouser PN | DigiKey PN | Notes |
| ----- | ------------- | --------------- | ----- | ----------- | ------------ | ------- |
| J1 | Link-Alpha BtB - 80-pin socket to Power Module | Samtec ERF8-040-05.0-S-DV-K-TR | ERF8-040 | 200-ERF8040050SDVKTR | SAM8621CT-ND | Female socket (ERF8). Mating male on Power Module (ERM8) |
| J2 | Link-Beta BtB - 40-pin socket to Stator Board | Samtec ERF8-020-05.0-S-DV-K-TR | ERF8-020 | 200-ERF8020050SDVKTR | SAM8619CT-ND | Female socket (ERF8). Mating male on Stator (ERM8-020). 40-pin per DEC-015 |
| J3 | USB 3.0 - Dual-stacked Type-A port | Molex 48406-0003 | 48406-0003 | 538-0484060003 | WM1394-ND | Dual-stack Type-A, 5.0mm protrusion through chassis |
| J4 | HDMI - Full-size Type-A | TE Connectivity 2007435-1 | 2007435-1 | 571-2007435-1 | A125057-ND | Full-size HDMI Type-A, 5.0mm protrusion through chassis |
| - | JTAG Daughterboard link (to FT232H board) | 1x5 INPUT header + 1x10 JTAG header | - | - | - | 2.54mm ENIG male headers on Controller. JDB female headers mate here. USB 2.0 to CM5 internally |

### Stator Board

| Ref | Description | Part / Series | MPN | Mouser PN | DigiKey PN | Notes |
| ----- | ------------- | --------------- | ----- | ----------- | ------------ | ------- |
| J1-J3 | Rotor 1 interface sockets (1 slot x 3 connectors: JTAG ERF8-005, Power ERF8-005, ENC ERF8-010) - cross-ref Rotor/Design_Spec.md §3.4 | ERF8-005 (J1+J2) / ERF8-010 (J3) | 200-ERF8005050SDVKTR (J1+J2) / 200-ERF8010050SDVKTR (J3) | SAM13517CT-ND (J1+J2 CT) / SAM8618CT-ND (J3 CT) | C7273978 (J1+J2) / C3646170 (J3) | ERF8 0.8mm pitch female sockets. Rotor 1 input side only (serial chain - not 30 slots). J1 pin 6 = TTD (outgoing TDI). |
| J4-J9 | Encoder port headers (x6: `KBD_ENC`, `LBD_DEC`, `PLG_PASS1_DEC`, `PLG_PASS1_ENC`, `PLG_PASS2_DEC`, `PLG_PASS2_ENC`) - 20-pin 2x10 shrouded box header | Adam Tech BHR-20-VUA / 2BHR-20-VUA (2x10, 2.54mm) | BHR-20-VUA | 737-BHR-20-VUA | 2057-BHR-20-VUA-ND | THT, shrouded, keyed. Pinout definition owner - see Stator/Board_Layout.md J4-J9. JLCPCB C17340054 uses 2BHR-20-VUA MPN. |
| J10 | Extension/Reflector Link - 16-pin shrouded box header | Adam Tech BHR-16-VUA (2x8, 2.54mm) | BHR-16-VUA | 737-BHR-16-VUA | 2057-BHR-16-VUA-ND | THT, shrouded. Power, reflector-boundary aliases, TTD_RETURN (pin 15). Pinout definition owner - see Stator/Board_Layout.md J10. JLCPCB C17692295 |
| J8 | Link-Beta BtB - 40-pin plug to Controller Board | Samtec ERM8-020-05.0-S-DV-K-TR | ERM8-020 | 200-ERM8020050SDVKTR | SAM8611CT-ND | Male plug (ERM8). Mating female on Controller (ERF8-020). 40-pin per DEC-015 |
| - | JTAG Aux header | 2x5 2.54mm shrouded | - | - | - | Pin pattern: GND\|TCK\|GND\|TMS\|GND\|TDI\|GND\|SYS_RESET_N\|GND |

### Rotor Board (x30)

| Ref | Description | Part / Series | MPN | Mouser PN | DigiKey PN | JLCPCB Part # | Notes |
| ----- | ------------- | --------------- | ----- | ----------- | ------------ | ------- | ------- |
| J1 | JTAG input - ERM8 male header (input side; plugs into Stator J1 ERF8 or Extension J4 ERF8) | Samtec ERM8-005-05.0-S-DV-K-TR (10-pin, 0.8mm pitch) | ERM8-005 | 200-ERM8005050SDVKTR | 612-ERM8-005-05.0-S-DV-K-TRCT-ND | C3649741 | Male (ERM8). Input side. Authority: Rotor/Design_Spec.md §3.4 |
| J2 | Power input - ERM8 male header (3V3_ENIG x5, GND x5) | Samtec ERM8-005-05.0-S-DV-K-TR (10-pin, 0.8mm pitch) | ERM8-005 | 200-ERM8005050SDVKTR | 612-ERM8-005-05.0-S-DV-K-TRCT-ND | C3649741 | Male (ERM8). Input power side |
| J3 | ENC Data input - ERM8 male header (ENC_IN/ENC_OUT + GND) | Samtec ERM8-010-05.0-S-DV-K-TR (20-pin, 0.8mm pitch) | ERM8-010 | 200-ERM8010050SDVKTR | SAM8610CT-ND | C374877 | Male (ERM8). Input ENC data |
| J4 | JTAG output - ERF8 female socket (output side; receives next Rotor J1, Reflector J1, or Extension J1 ERM8 male) | Samtec ERF8-005-05.0-S-DV-K-TR (10-pin, 0.8mm pitch) | ERF8-005 | 200-ERF8005050SDVKTR | SAM13517CT-ND | C7273978 | Female (ERF8). Output side. R1 (75Ω) in TTD output path |
| J5 | Power output - ERF8 female socket (3V3_ENIG x5, GND x5) | Samtec ERF8-005-05.0-S-DV-K-TR (10-pin, 0.8mm pitch) | ERF8-005 | 200-ERF8005050SDVKTR | SAM13517CT-ND | C7273978 | Female (ERF8). Output power side |
| J6 | ENC Data output - ERF8 female socket (ENC_IN/ENC_OUT + GND) | Samtec ERF8-010-05.0-S-DV-K-TR (20-pin, 0.8mm pitch) | ERF8-010 | 200-ERF8010050SDVKTR | SAM8618CT-ND | C3646170 | Female (ERF8). Output ENC data |

### Encoder Board

| Ref | Description | Part / Series | MPN | Mouser PN | DigiKey PN | Notes |
| ----- | ------------- | --------------- | ----- | ----------- | ------------ | ------- |
| J1 (x64) | Plugboard cipher jack sockets (one per key/lamp position) | 6.35mm (¼") mono switched panel-mount jack socket - already purchased (eBay: SaiBuy.Ltd item 334364197440) | - | - | - | THT panel-mount. 64x per board (26 input + 26 output + 10 plugboard positions + 2 spare). Purchased. |
| J2 | Data link to Stator - 20-pin 2x10 shrouded box header | Adam Tech BHR-20-VUA / 2BHR-20-VUA (2x10, 2.54mm) | BHR-20-VUA | 737-BHR-20-VUA | 2057-BHR-20-VUA-ND | Mating connector for Stator J4-J9. Cross-ref: Stator/Board_Layout.md J4-J9. JLCPCB C17340054 uses 2BHR-20-VUA MPN. |

### Reflector Board

| Ref | Description | Part / Series | MPN | Mouser PN | DigiKey PN | JLCPCB Part # | Notes |
| ----- | ------------- | --------------- | ----- | ----------- | ------------ | ------- | ------- |
| J1 | Rotor 30 output - JTAG (ERM8-005, 10-pin **male**, 0.8mm pitch) | Samtec ERM8-005-05.0-S-DV-K-TR | ERM8-005-05.0-S-DV-K-TR | 200-ERM8005050SDVKTR | 612-ERM8-005-05.0-S-DV-K-TRCT-ND | C3649741 | Plugs into Rotor 30 J4 (ERF8-005 female). Definition owner: Rotor/Design_Spec.md §3.4 |
| J2 | Rotor 30 output - Power (ERM8-005, 10-pin **male**, 0.8mm pitch) | Samtec ERM8-005-05.0-S-DV-K-TR | ERM8-005-05.0-S-DV-K-TR | 200-ERM8005050SDVKTR | 612-ERM8-005-05.0-S-DV-K-TRCT-ND | C3649741 | Plugs into Rotor 30 J5 (ERF8-005 female). Definition owner: Rotor/Design_Spec.md §3.4 |
| J3 | Rotor 30 output - ENC Data (ERM8-010, 20-pin **male**, 0.8mm pitch) | Samtec ERM8-010-05.0-S-DV-K-TR | ERM8-010-05.0-S-DV-K-TR | 200-ERM8010050SDVKTR | SAM8610CT-ND | C374877 | Plugs into Rotor 30 J6 (ERF8-010 female). Definition owner: Rotor/Design_Spec.md §3.4 |
| J4 | Interconnect to Stator/Extension - 16-pin shrouded box header | Adam Tech BHR-16-VUA (2x8, 2.54mm) | BHR-16-VUA | 737-BHR-16-VUA | 2057-BHR-16-VUA-ND | JLCPCB C17692295 | Mating connector for **Stator J10** (or Extension J7/J8). Carries TTD_RETURN on pin 15. |

### Extension Board

| Ref | Description | Part / Series | MPN | Mouser PN | DigiKey PN | JLCPCB Part # | Notes |
| ----- | ------------- | --------------- | ----- | ----------- | ------------ | ------- | ------- |
| J1 | Rotor group input - JTAG (ERM8-005, 10-pin **male**, 0.8mm pitch) | Samtec ERM8-005-05.0-S-DV-K-TR | ERM8-005-05.0-S-DV-K-TR | 200-ERM8005050SDVKTR | 612-ERM8-005-05.0-S-DV-K-TRCT-ND | C3649741 | Plugs into previous rotor group's last rotor J4 (ERF8-005 female). Cross-ref: Rotor/Design_Spec.md §3.4 |
| J2 | Rotor group input - Power (ERM8-005, 10-pin **male**, 0.8mm pitch) | Samtec ERM8-005-05.0-S-DV-K-TR | ERM8-005-05.0-S-DV-K-TR | 200-ERM8005050SDVKTR | 612-ERM8-005-05.0-S-DV-K-TRCT-ND | C3649741 | Plugs into previous rotor group's last rotor J5 (ERF8-005 female). |
| J3 | Rotor group input - ENC Data (ERM8-010, 20-pin **male**, 0.8mm pitch) | Samtec ERM8-010-05.0-S-DV-K-TR | ERM8-010-05.0-S-DV-K-TR | 200-ERM8010050SDVKTR | SAM8610CT-ND | C374877 | Plugs into previous rotor group's last rotor J6 (ERF8-010 female). |
| J4 | Rotor group output - JTAG (ERF8-005, 10-pin female, 0.8mm pitch) | Samtec ERF8-005-05.0-S-DV-K-TR | ERF8-005-05.0-S-DV-K-TR | 200-ERF8005050SDVKTR | SAM13517CT-ND | C7273978 | Receives next rotor group's first rotor J1 (ERM8-005 male). Cross-ref: Rotor/Design_Spec.md §3.4 |
| J5 | Rotor group output - Power (ERF8-005, 10-pin female, 0.8mm pitch) | Samtec ERF8-005-05.0-S-DV-K-TR | ERF8-005-05.0-S-DV-K-TR | 200-ERF8005050SDVKTR | SAM13517CT-ND | C7273978 | Receives next rotor group's first rotor J2 (ERM8-005 male). |
| J6 | Rotor group output - ENC Data (ERF8-010, 20-pin female, 0.8mm pitch) | Samtec ERF8-010-05.0-S-DV-K-TR | ERF8-010-05.0-S-DV-K-TR | 200-ERF8010050SDVKTR | SAM8618CT-ND | C3646170 | Receives next rotor group's first rotor J3 (ERM8-010 male). |
| J7 | Extension Port IN - 16-pin 2x8 shrouded box header | Adam Tech BHR-16-VUA (2x8, 2.54mm) | BHR-16-VUA | 737-BHR-16-VUA | 2057-BHR-16-VUA-ND | JLCPCB C17692295 | Mating connector for Stator J10 (or previous Extension J8). Cross-ref: Stator/Board_Layout.md J10 |
| J8 | Extension Port OUT - 16-pin 2x8 shrouded box header | Adam Tech BHR-16-VUA (2x8, 2.54mm) | BHR-16-VUA | 737-BHR-16-VUA | 2057-BHR-16-VUA-ND | JLCPCB C17692295 | Feeds next Extension J7 or Reflector J4. Cross-ref: Stator/Board_Layout.md J10 |

### JTAG Daughterboard (FT232H)

| Ref | Description | Part / Series | Notes |
| ----- | ------------- | --------------- | ------- |
| J1 | INPUT header - 5V_USB, 3V3_ENIG, D+, D-, GND | 1x5 2.54mm female IDC | Power in (5V_USB + 3V3_ENIG) + internal USB 2.0 to CM5 via hat-header |
| J2 | JTAG OUTPUT header (10-pin interleaved GND) | 1x10 2.54mm female IDC | TCK/GND/TDI/GND/TDO/GND/TMS/GND/VREF/GND |

---

> **Note for manual review:** Items marked `???` or `⚠️ verify` require confirmation before the BOM is finalised for procurement. In particular: Encoder J1 plug/jack type has not been selected;
> Controller J1 (ERF8) DigiKey PN SAM8621CT-ND (confirmed); Power Module J3 (43650-0519) DigiKey WM14587-ND (confirmed).

---

## Open Work Items

The following items have been identified as future tasks. They are not yet scheduled but must not be forgotten.

### OWI-001 - Test Coupons per Board

Add test coupon footprints to each board design to simplify manufacturing test and functional verification.
Each board must be specified independently, as the relevant test signals and accessible nets will differ per board.
Diagnostic-bank style bring-up access should be relocated onto these removable coupons wherever practical,
so full prototype and service test coverage is retained without carrying extra test-only hardware into the
final assembled machine.

### OWI-002 - PAS Definitions per Board

Define Provisional Acceptance Specifications (PAS) for each board, covering:

- **Basic board testing** - power-on checks, continuity, short detection.
- **Functional testing via coupons** - using coupon connections to real external devices to verify board functionality
  end-to-end (e.g. JTAG chain continuity, signal integrity, CPLD programming verification).
- **Bring-up access strategy** - PAS definitions should prefer removable coupon-based access for
  bring-up probes, rather than requiring permanent on-board probe features in the finished product.

Each board must be specified independently.

### OWI-003 - VHDL Pseudo-Code and CPLD Configuration Plans

For each CPLD in the system, create:

- A configuration plan describing the intended logical function, I/O assignments, and state machine behaviour.
- Pseudo-code or annotated VHDL stubs ready for handoff to software development.
- Notes on how the VHDL can be exercised during PAS testing (OWI-002) to verify functional correctness.

Boards with CPLDs requiring this work: Encoder (x2), Stator (x1), Rotor (x1 per rotor, x30 total).
