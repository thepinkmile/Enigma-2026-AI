# User Settings Module (V1.0) Design Specification

**Status:** In Review
**Project:** Enigma-NG
**Author:** Izzyonstage & GitHub Copilot
**Version:** v.0.1.0
**Associated Hardware Revision:** Rev A
**Last Updated:** 2026-05-13

---

## 1. Overview

The User Settings Module is a panel-mount PCB providing user-accessible hardware configuration controls
for the Enigma-NG system. It replaces the DIP switches previously located on the Stator Board with
10 sub-miniature SPDT toggle switches plus 12 discrete RGB status LEDs, mounted through the right
side of the enclosure top face near the rotors. A momentary active-low `CFG_APPLY_N` pushbutton
captures the user's configuration intent; the CM5 firmware then mirrors that request onto the
Stator-side apply/reset path.

The User Settings Module communicates with the Stator Board exclusively via a 6-wire I²C harness
(J1 → Stator J13), sharing the Stator I²C-1 bus. It hosts three MCP23017 GPIO expanders:

* **U1 (@ 0x23):** Reads the 10 toggle-switch states and the `CFG_APPLY_N` momentary button.
* **U2 (@ 0x24):** Drives Bank 1 LED anodes (1 source-status LED + 4 config LEDs) and RGB bank-rail low-side switches.
* **U3 (@ 0x25):** Drives Bank 2 LED anodes (1 source-status LED + 6 config LEDs) and RGB bank-rail low-side switches.

No JTAG chain is present on this board. All configuration logic is handled by the CM5 enigma
daemon over I²C.

* **Location:** Right side of enclosure top face, near rotors.
* **Mounting:** Panel-mount switches through enclosure panel; PCB mounted behind panel.
* **Stackup:** 4-layer standard per `design/Standards/Global_Routing_Spec.md §2.3.1`.
* **Role:** User-accessible configuration panel; I²C peripheral to Stator Board.

### Functional & Design Requirements

#### Functional Requirements

| ID | Functional Requirement | Notes | Satisfied By / Cross-Ref |
| :--- | :--- | :--- | :--- |
| FR-USM-01 | Provide 10 user-accessible toggle switches with matching RGB status LEDs for hardware configuration without opening the enclosure | 4 toggles for routing config, 6 for reflector-map config, plus 2 RGB source-status LEDs; panel-mount through enclosure top face | §3 Configuration Bank Descriptions; §4 I²C Devices |
| FR-USM-02 | Allow CM5 firmware / GUI presets to override the user-intent configuration on a per-bank basis | CM5 decides authority in software, drives the final applied config on the Stator, and reflects source state back to the Settings indicators via `CFG_ROUTE_CM5_ACTIVE` / `CFG_REFMAP_CM5_ACTIVE` | §5 LED Control Logic; `design/Electronics/Stator/Design_Spec.md` FR-STA-08/09 |
| FR-USM-03 | Provide visual feedback via RGB LED illumination showing configuration source and active bit state | Green = user-intent forwarded; Red = CM5-defined override active; per-bank shared colour rails + per-bit individual LED anode drive with per-colour cathode-return resistors | §5 LED Control Logic |
| FR-USM-04 | Provide a momentary `CFG_APPLY_N` pushbutton that requests Stator CPLD configuration reload | CM5 daemon polls U1 GPA[6]; active-low; 10kΩ pull-up + 100nF X7R 0402 debounce cap. A board-mounted tactile switch actuated through the enclosure is acceptable; the switch itself need not be panel-mount. | §6 `CFG_APPLY_N` Button |
| FR-USM-05 | Connect to the Stator Board via a 6-wire I²C harness (`3V3_ENIG`, `5V_MAIN`, 2x `GND`, `SDA`, `SCL`) | J1 = 6-pin JST PH 2.0mm connector; shares Stator I²C-1 bus; `5V_MAIN` powers the indicator LEDs | §7 Interconnects; BOM J1 |

#### Design Requirements

| ID | Design Requirement | Specification | Satisfied By / Cross-Ref |
| :--- | :--- | :--- | :--- |
| DR-USM-01 | PCB stackup | Stackup per `design/Standards/Global_Routing_Spec.md §2.3.1` | §8 PCB Fabrication |
| DR-USM-02 | Switch + indicator type | 10x E-Switch 200MSP1T2B4M2QE panel-mount SPDT latching toggle switches plus 12x Kingbright WP154A4SEJ3VBDZGW/CA common-anode RGB through-hole LEDs; 10 LEDs mirror config bits and 2 LEDs indicate CM5-vs-user authority | §3 Configuration Bank Descriptions; BOM SW1-SW10, D1-D12 |
| DR-USM-03 | Switch input expander | U1 = MCP23017T-E/SO @ 0x23; SOIC-28; contiguous after the Stator expander block | §4 I²C Devices - U1; BOM U1 |
| DR-USM-04 | LED control expanders | U2 = MCP23017T-E/SO @ 0x24 (Bank 1); U3 = MCP23017T-E/SO @ 0x25 (Bank 2); SOIC-28; per-indicator anodes plus shared RGB bank rails | §4 I²C Devices - U2, U3; §5 LED Control Logic; BOM U2, U3 |
| DR-USM-05 | LED colour-rail transistors | 6x BSS138 SOT-23 N-channel MOSFETs (`Q1-Q6`); gate driven via 1kΩ resistor; GPIO HIGH = transistor ON | §5 LED Control Logic; BOM Q1-Q6 |
| DR-USM-06 | LED power supply | `5V_MAIN` from the Stator via J1 pin 2; full RGB operation at 5V uses 150Ω red and 100Ω green/blue series resistors; LED anodes connect to `5V_MAIN` via per-anode PMOS high-side switches (Q19-Q30) - see DR-USM-10 | §7 Interconnects - J1; §5 LED Control Logic; BOM R18-R53, Q7-Q30, R54-R77 |
| DR-USM-07 | `CFG_APPLY_N` button | SW11 = Omron B3F-1070 or equivalent SPST NO through-hole tactile switch, active-low; mounted on the User Settings Module and actuated through the enclosure by a mechanical plunger/cap; 10kΩ pull-up to 3V3_ENIG + 100nF debounce cap; U1 GPA[6] | §6 `CFG_APPLY_N` Button; BOM SW11, R11, C4 |
| DR-USM-08 | I²C connector | J1 = 6-pin JST PH 2.0mm B6B-PH-K-S(LF)(SN); pins: `3V3_ENIG`, `5V_MAIN`, `GND`, `SDA`, `SCL`, `GND`; harness to Stator J13 | §7 Interconnects; BOM J1 |
| DR-USM-09 | Switch input pull-downs | 10x 10kΩ 0603 pull-down resistors on all toggle-switch inputs to U1 (GPA[3:0], GPB[5:0]); HIGH when closed | §4 I²C Devices - U1; BOM R1-R10 |
| DR-USM-10 | Per-anode LED high-side switch | 12x two-stage per-anode high-side switch: MCP23017 GPIO → 1 kΩ gate resistor (R54-R65) → BSS138 NMOS pre-driver (Q7-Q18); BSS138 drain pulls PMOS gate low; 47 kΩ pull-up (R66-R77) from PMOS gate to `5V_MAIN`; PMOS source at `5V_MAIN`, drain to LED anode; GPIO HIGH → LED ON (non-inverted logic); this topology isolates the MCP23017 3.3 V GPIO from direct-driving 5 V LED anodes | §5 LED Control Logic; BOM Q7-Q30, R54-R77 |
| DR-USM-11 | Mounting holes | MH1–MH4 shall be M3 PTH (Ø3.2 mm drill) mounting holes (KiCAD built-in `MountingHole` footprint; no purchasable BOM component), bonded to `GND_CHASSIS` per `design/Standards/Global_Routing_Spec.md §4`. Placement follows GRS §4.3 Pattern A (rectangular board): MH1 bottom-left, MH2 bottom-right, MH3 top-right, MH4 top-left — all at 7 mm inset from both nearest edges. Exact XY coordinates TBD at PCB layout. | §2 Core Features (GND_CHASSIS section); `design/Standards/Global_Routing_Spec.md §4.3` |
| DR-USM-12 | Per-IC bypass capacitors | Per-IC bypass capacitor rule applies per `design/Standards/Global_Routing_Spec.md §3.2`. C1, C2, and C3 are the bypass capacitors for U1, U2, and U3 respectively. | §10 BOM (C1-C3); §12 Component Count Summary; `design/Standards/Global_Routing_Spec.md §3.2` |

### Component Block Diagram

```mermaid
flowchart TD
  subgraph stator["Stator Interface"]
    J1["J1 JST-PH 6-pin"]
    r3v3["3V3_ENIG"]
    r5v["5V_MAIN"]
  end

  subgraph expanders["I2C Expanders"]
    U1["U1 MCP23017 0x23"]
    U2["U2 MCP23017 0x24"]
    U3["U3 MCP23017 0x25"]
  end

  subgraph controls["User Controls"]
    SW1_10["SW1-SW10 Toggles"]
    SW11["SW11 CFG_APPLY_N Button"]
  end

  subgraph led_drive["LED Drive"]
    Q1_6["Q1-Q6 N-FETs (colour rails)"]
    Q7_30["Q7-Q30 PMOS/NMOS (per-anode)"]
    D1_12["D1-D12 RGB LEDs"]
  end

  J1 -- "I2C" --> U1
  J1 -- "I2C" --> U2
  J1 -- "I2C" --> U3
  J1 --> r3v3
  J1 --> r5v
  r3v3 --> U1
  r3v3 --> U2
  r3v3 --> U3
  r5v --> Q7_30
  U1 --> SW1_10
  U1 --> SW11
  U2 -- "GPIO" --> Q1_6
  Q1_6 --> Q7_30
  Q7_30 --> D1_12
```

---

## 2. Core Features

* **10 Panel-Mount Toggle Switches + 12 RGB LEDs:** E-Switch 200 series SPDT toggles provide the
  user-intent configuration inputs; one discrete Kingbright common-anode RGB LED is mounted beside
  each config position, and one additional RGB source-status LED is provided per bank. Bank 1
  therefore has 4 config toggles + 5 LEDs total; Bank 2 has 6 config toggles + 7 LEDs total.
* **Three-Expander Architecture:** U1 reads all switch states, while U2 and U3
  independently drive the two indicator banks. Separate expanders prevent LED drive state from
  interfering with switch read-back and keep the Settings address block contiguous after the Stator.
* **Per-Bank CM5-Active Status:** Each bank has a CM5-owned logical state
  (`CFG_ROUTE_CM5_ACTIVE`, `CFG_REFMAP_CM5_ACTIVE`) reflected by the bank's source-status LED and
  shared colour rail. LOW = the CM5 is forwarding user-intent config. HIGH = the CM5 is applying a
  GUI-selected or automated override.
* **RGB LED Feedback:** Green = switch-defined active; Red = CM5-defined override. Blue remains
  available for CM5-controlled status, boot, or fault states. Per-bit anode control illuminates
  only set bits. Shared per-bank RGB rails simplify wiring (6 low-side sink MOSFETs total).
* **`CFG_APPLY_N` Button:** Momentary pushbutton requests a Stator-only configuration reload via the
  CM5 daemon. CM5 reads the user-intent switch state, writes the final config to U8 on the
  Stator, and pulses the Stator-side `CFG_APPLY_N` output low.
* **I²C-Only Interface:** 6-wire harness to Stator (`3V3_ENIG`, `5V_MAIN`, `GND`, `SDA`, `SCL`, `GND`) - no parallel signal wiring.

### GND_CHASSIS Single-Point Bond

Per `design/Standards/Global_Routing_Spec.md §5`, the User Settings Module implements a local
`GND_CHASSIS` net tied to its mounting holes and any panel-contact mechanical features, but it does
**not** implement a local GND-to-GND_CHASSIS bond. The system's only galvanic GND ↔ GND_CHASSIS
bond is defined on the Power Module at the common power-entry point immediately before the eFuse.
J1 pin 3 is therefore **logic GND return only**, and must not be repurposed as a local
chassis-bond point.

---

## 3. Configuration Bank Descriptions

### Bank 1 - Plugboard Routing (`CFG_ROUTE[3:0]` + `CFG_ROUTE_CM5_ACTIVE`)

Bank 1 provides a 4-bit user-intent image of the logical `CFG_ROUTE[3:0]` bus, selecting the active
routing case from 16 configurations synthesised into the Stator CPLD fabric. `CFG_ROUTE[1:0]`
encode **Plugboard Pass 1** (`J6/J7`) insertion position; `CFG_ROUTE[3:2]` encode **Plugboard Pass
2** (`J8/J9`) insertion position.

The CM5 daemon decides whether the applied `CFG_ROUTE[3:0]` value is the forwarded User Settings Module
user-intent image or a CM5-defined override. `CFG_ROUTE_CM5_ACTIVE` is the CM5-owned status state
used to colour the Bank 1 indicators: LOW = user-intent forwarded (green), HIGH = CM5-defined
override active (red).

Pull-down resistors (10kΩ, one per switch signal) hold each input at logic-0 when the
corresponding switch is open. On the Stator, R16-R19 provide the corresponding pull-downs on the
logical `CFG_ROUTE[3:0]` CPLD input pins to maintain a safe all-zero default before CM5 initialises
U8.

The final applied `CFG_ROUTE[3:0]` value is driven to the Stator CPLD by U8 GPA[3:0] via I²C.
After CM5 writes the final value, it may assert the Stator-side `CFG_APPLY_N` output low to force a
Stator-only configuration reload.

| `CFG_ROUTE` Index (`CFG_ROUTE[3]:CFG_ROUTE[2]:CFG_ROUTE[1]:CFG_ROUTE[0]`) | Plugboard Pass 1 (`J6/J7`) insertion point | Plugboard Pass 2 (`J8/J9`) insertion point | Historical reference |
| :--- | :--- | :--- | :--- |
| 0 (0000) | None | None | No plugboard - straight through |
| 1 (0001) | Pre-Rotor 1 | None | Single pre-Rotor 1 pass |
| 2 (0010) | At Reflector | None | Later Enigma models (single reflector pass) |
| 3 (0011) | Post-Rotor 1 return | None | Single post-Rotor 1 pass |
| 4 (0100) | None | Pre-Rotor 1 | - |
| 5 (0101) | Pre-Rotor 1 | Pre-Rotor 1 | Cascaded pre-Rotor 1 |
| 6 (0110) | At Reflector | Pre-Rotor 1 | - |
| 7 (0111) | Post-Rotor 1 return | Pre-Rotor 1 | - |
| 8 (1000) | None | At Reflector | - |
| 9 (1001) | Pre-Rotor 1 | At Reflector | - |
| 10 (1010) | At Reflector | At Reflector | Cascaded at Reflector |
| 11 (1011) | Post-Rotor 1 return | At Reflector | - |
| 12 (1100) | None | Post-Rotor 1 return | - |
| 13 (1101) | Pre-Rotor 1 | Post-Rotor 1 return | Original Enigma (pre-war) |
| 14 (1110) | At Reflector | Post-Rotor 1 return | - |
| 15 (1111) | Post-Rotor 1 return | Post-Rotor 1 return | Cascaded post-Rotor 1 |

### Bank 2 - Reflector Mapping (`CFG_REFMAP[5:0]` + `CFG_REFMAP_CM5_ACTIVE`)

Bank 2 provides a 6-bit user-intent image of the logical `CFG_REFMAP[5:0]` bus used by the Stator
CPLD to select the reflector-map index. The physical Reflector board remains mandatory and always
provides the electrical turnaround at the end of the rotor/extension chain.

The CM5 daemon decides whether the applied `CFG_REFMAP[5:0]` value is the forwarded User Settings Module
user-intent image or a CM5-defined override. `CFG_REFMAP_CM5_ACTIVE` is the CM5-owned status state
used to colour the Bank 2 indicators: LOW = user-intent forwarded (green), HIGH = CM5-defined
override active (red).

| Bit | Switch | Function |
| :--- | :--- | :--- |
| `CFG_REFMAP[5:0]` | SW5-SW10 | **6-bit map index** (0-63): selects which involutory map to load from CPLD UFM at configuration load; indices 0-20 are currently allocated |

Pull-down resistors R21-R26 on the Stator CPLD `CFG_REFMAP[5:0]` input pins hold each input at
logic-0 when U8 is uninitialised (default map index = 0).

When Bank 2 is latched, the Stator CPLD loads the selected map and applies it at the reflection
boundary while the physical Reflector board remains in the active ENC signal path.

**UFM map storage:** 21 involutory reflector maps (same as defined in `design/Electronics/Stator/Design_Spec.md` §3):

| Index | Map | Notes |
| :--- | :--- | :--- |
| 0 | UKW-A equivalent | Historical Enigma Reflector A (26-char; entries 26-63 = identity for 64-char variant) |
| 1 | UKW-B equivalent | Historical Enigma Reflector B - most common WWII Enigma variant |
| 2 | UKW-C equivalent | Historical Enigma Reflector C - later wartime variant |
| 3-20 | Custom | User-defined involutory maps via JTAG programming |

---

## 4. I²C Devices

All User Settings Module I²C devices share the Stator I²C-1 bus via J1 → Stator J13.

### U1 - MCP23017T-E/SO @ 0x23

Reads the 10 toggle-switch states and the active-low `CFG_APPLY_N` momentary button.

**Address:** 0x23 - MCP23017 base 0x20; A2=LOW, A1=HIGH, A0=HIGH → 0x20 | 0b011 = 0x23

| Port | Pin | Signal | Direction | Pull | Description |
| :--- | :--- | :--- | :--- | :--- | :--- |
| GPA | [0] | `CFG_ROUTE[0]` | Bidirectional(Input) | 10kΩ pull-down | Routing config bit 0 |
| GPA | [1] | `CFG_ROUTE[1]` | Bidirectional(Input) | 10kΩ pull-down | Routing config bit 1 |
| GPA | [2] | `CFG_ROUTE[2]` | Bidirectional(Input) | 10kΩ pull-down | Routing config bit 2 |
| GPA | [3] | `CFG_ROUTE[3]` | Bidirectional(Input) | 10kΩ pull-down | Routing config bit 3 |
| GPA | [5:4] | NC | Bidirectional | - | Spare (reserved future use) |
| GPA | [6] | `CFG_APPLY_N` | Bidirectional(Input) | 10kΩ pull-up to 3V3_ENIG | Active-low momentary; 100nF X7R debounce cap to GND |
| GPA | [7] | NC | Output | — | MCP23017 silicon restriction: GPA[7] is output-only on I²C variant (DS20001952D §1) |
| GPB | [0] | `CFG_REFMAP[0]` | Bidirectional(Input) | 10kΩ pull-down | Reflector-map config bit 0 |
| GPB | [1] | `CFG_REFMAP[1]` | Bidirectional(Input) | 10kΩ pull-down | Reflector-map config bit 1 |
| GPB | [2] | `CFG_REFMAP[2]` | Bidirectional(Input) | 10kΩ pull-down | Reflector-map config bit 2 |
| GPB | [3] | `CFG_REFMAP[3]` | Bidirectional(Input) | 10kΩ pull-down | Reflector-map config bit 3 |
| GPB | [4] | `CFG_REFMAP[4]` | Bidirectional(Input) | 10kΩ pull-down | Reflector-map config bit 4 |
| GPB | [5] | `CFG_REFMAP[5]` | Bidirectional(Input) | 10kΩ pull-down | Reflector-map config bit 5 |
| GPB | [6] | NC | Bidirectional | - | Spare (reserved future use) |
| GPB | [7] | NC | Output | — | MCP23017 silicon restriction: GPB[7] is output-only on I²C variant (DS20001952D §1) |

> **Silicon note:** GPA[7] and GPB[7] on the MCP23017 I²C variant are output-only (DS20001952D §1);
> this restriction applies to pin 7 of each port only — all other 14 GPIO (GPA[0:6] and GPB[0:6])
> are fully bidirectional. GPA[5:4], GPA[7] and GPB[7:6] are NC.
>
> All toggle-switch signal inputs (GPA[3:0], GPB[5:0]) use 10kΩ pull-down resistors: open/off switch = logic-0.
> `CFG_APPLY_N` (GPA[6]) uses 10kΩ pull-up: active button press = logic-0.
>
> Each `200MSP1T2B4M2QE` toggle is wired as an SPDT-used-as-SPST input: the centre COM lug goes
> to the named `CFG_*` signal net, the asserted throw goes to `3V3_ENIG`, and the opposite throw is
> left unconnected in Rev A. Panel orientation shall make the lever-up / marked-ON position select
> the `3V3_ENIG` throw so the asserted state always reads logic-1.
>
### U2 - MCP23017T-E/SO @ 0x24

Drives Bank 1 LED high-side switch trigger signals (1 source-status LED + 4 config LEDs) via dedicated
BSS138 NMOS pre-drivers (Q7-Q11), and Bank 1 RGB colour-rail low-side transistor gates (Q1-Q3).

**Address:** 0x24 - MCP23017 base 0x20; A2=HIGH, A1=LOW, A0=LOW → 0x20 | 0b100 = 0x24

| Port | Pin | Signal | Direction | Description |
| :--- | :--- | :--- | :--- | :--- |
| GPA | [0] | LED_B1_SRC_A | Bidirectional(Output) | Bank 1 source-status LED high-side switch trigger; HIGH drives Q7 gate (BSS138 ON → Q19 PMOS ON → anode at 5V) |
| GPA | [1] | LED_B1_0_A | Bidirectional(Output) | Bank 1 bit 0 LED high-side switch trigger; HIGH drives Q8 gate (BSS138 ON → Q20 PMOS ON → anode at 5V) |
| GPA | [2] | LED_B1_1_A | Bidirectional(Output) | Bank 1 bit 1 LED high-side switch trigger; HIGH drives Q9 gate (BSS138 ON → Q21 PMOS ON → anode at 5V) |
| GPA | [3] | LED_B1_2_A | Bidirectional(Output) | Bank 1 bit 2 LED high-side switch trigger; HIGH drives Q10 gate (BSS138 ON → Q22 PMOS ON → anode at 5V) |
| GPA | [4] | LED_B1_3_A | Bidirectional(Output) | Bank 1 bit 3 LED high-side switch trigger; HIGH drives Q11 gate (BSS138 ON → Q23 PMOS ON → anode at 5V) |
| GPA | [5] | BNK1_R | Bidirectional(Output) | Bank 1 red cathode rail; drives gate of Q1; HIGH = red rail active |
| GPA | [6] | BNK1_G | Bidirectional(Output) | Bank 1 green cathode rail; drives gate of Q2; HIGH = green rail active |
| GPA | [7] | BNK1_B | Output | Bank 1 blue cathode rail; drives gate of Q3; HIGH = blue rail active |
| GPB | [6:0] | NC | Bidirectional | Reserved future use |
| GPB | [7] | NC | Output | MCP23017 silicon restriction: GPB[7] is output-only on I²C variant (DS20001952D §1) |

> **Silicon note:** GPA[7] and GPB[7] on the MCP23017 I²C variant are output-only (DS20001952D §1);
> this restriction applies to pin 7 of each port only — all other 14 GPIO (GPA[0:6] and GPB[0:6])
> are fully bidirectional. GPA[7] is assigned `BNK1_B` (Output) — silicon-compatible; no violation.
> GPB[7:0] are NC.
>
> LED anode signals drive the gates of BSS138 NMOS pre-drivers (Q7-Q11) through 1 kΩ gate resistors
> (R54-R58). Each BSS138 drain pulls down the gate of a PMOS high-side switch (Q19-Q23); 47 kΩ pull-ups
> (R66-R70) hold the PMOS gates HIGH when the BSS138 is OFF, keeping the PMOS OFF and the anode
> floating. GPIO HIGH → BSS138 ON → PMOS gate ≈0 V → PMOS ON → LED anode driven to `5V_MAIN`. Each
> LED's red, green, and blue cathodes return through current-limiting resistors (`R_LED_R` = 150Ω,
> `R_LED_G` = 100Ω, `R_LED_B` = 100Ω) to the shared bank colour rails switched by Q1-Q3.
> 100 kΩ pull-down resistors (R84-R88 on Q7-Q11 gates; R78-R83 on Q1-Q6 gates) hold BSS138 gates LOW
> during GPIO Hi-Z at power-up, preventing spurious transistor turn-on.
>
### U3 - MCP23017T-E/SO @ 0x25

Drives Bank 2 LED high-side switch trigger signals (1 source-status LED + 6 config LEDs) via dedicated
BSS138 NMOS pre-drivers (Q12-Q18), and Bank 2 RGB colour-rail low-side transistor gates (Q4-Q6).

**Address:** 0x25 - MCP23017 base 0x20; A2=HIGH, A1=LOW, A0=HIGH → 0x20 | 0b101 = 0x25

| Port | Pin | Signal | Direction | Description |
| :--- | :--- | :--- | :--- | :--- |
| GPA | [0] | LED_B2_SRC_A | Bidirectional(Output) | Bank 2 source-status LED high-side switch trigger; HIGH drives Q12 gate (BSS138 ON → Q24 PMOS ON → anode at 5V) |
| GPA | [1] | LED_B2_0_A | Bidirectional(Output) | Bank 2 bit 0 LED high-side switch trigger; HIGH drives Q13 gate (BSS138 ON → Q25 PMOS ON → anode at 5V) |
| GPA | [2] | LED_B2_1_A | Bidirectional(Output) | Bank 2 bit 1 LED high-side switch trigger; HIGH drives Q14 gate (BSS138 ON → Q26 PMOS ON → anode at 5V) |
| GPA | [3] | LED_B2_2_A | Bidirectional(Output) | Bank 2 bit 2 LED high-side switch trigger; HIGH drives Q15 gate (BSS138 ON → Q27 PMOS ON → anode at 5V) |
| GPA | [4] | LED_B2_3_A | Bidirectional(Output) | Bank 2 bit 3 LED high-side switch trigger; HIGH drives Q16 gate (BSS138 ON → Q28 PMOS ON → anode at 5V) |
| GPA | [5] | LED_B2_4_A | Bidirectional(Output) | Bank 2 bit 4 LED high-side switch trigger; HIGH drives Q17 gate (BSS138 ON → Q29 PMOS ON → anode at 5V) |
| GPA | [6] | LED_B2_5_A | Bidirectional(Output) | Bank 2 bit 5 LED high-side switch trigger; HIGH drives Q18 gate (BSS138 ON → Q30 PMOS ON → anode at 5V) |
| GPA | [7] | BNK2_R | Output | Bank 2 red cathode rail; drives gate of Q4; HIGH = red rail active |
| GPB | [0] | BNK2_G | Bidirectional(Output) | Bank 2 green cathode rail; drives gate of Q5; HIGH = green rail active |
| GPB | [1] | BNK2_B | Bidirectional(Output) | Bank 2 blue cathode rail; drives gate of Q6; HIGH = blue rail active |
| GPB | [6:2] | NC | Bidirectional | Reserved future use |
| GPB | [7] | NC | Output | MCP23017 silicon restriction: GPB[7] is output-only on I²C variant (DS20001952D §1) |

> **Silicon note:** GPA[7] and GPB[7] on the MCP23017 I²C variant are output-only (DS20001952D §1);
> this restriction applies to pin 7 of each port only — all other 14 GPIO (GPA[0:6] and GPB[0:6])
> are fully bidirectional. GPA[7] is assigned `BNK2_R` (Output) — silicon-compatible; no violation.
> GPB[7:2] are NC.
>
> LED anode signals drive the gates of BSS138 NMOS pre-drivers (Q12-Q18) through 1 kΩ gate resistors
> (R59-R65). Each BSS138 drain pulls down the gate of a PMOS high-side switch (Q24-Q30); 47 kΩ pull-ups
> (R71-R77) hold the PMOS gates HIGH when the BSS138 is OFF. GPIO HIGH → BSS138 ON → PMOS gate ≈0 V →
> PMOS ON → LED anode driven to `5V_MAIN`. Cathodes return through current-limiting resistors to the
> shared Bank 2 colour rails switched by Q4-Q6.
> 100 kΩ pull-down resistors (R89-R95 on Q12-Q18 gates; R78-R83 on Q1-Q6 gates) hold BSS138 gates LOW
> during GPIO Hi-Z at power-up, preventing spurious transistor turn-on.
>

---

## 5. LED Control Logic

### Colour Scheme

Full RGB capability with software-selectable colors per bank:

| CM5_ACTIVE State | Primary Colour | Meaning |
| :--- | :--- | :--- |
| LOW (`CFG_*_CM5_ACTIVE` deasserted) | Green (BNKx_G transistor ON) | Configuration source = User Settings Module user intent |
| HIGH (`CFG_*_CM5_ACTIVE` asserted) | Red (BNKx_R transistor ON) | Configuration source = CM5 firmware / GUI override |
| Special modes | Blue (BNKx_B transistor ON) | Future use: status, bootloader, error states |

> Software can select any RGB color by enabling the appropriate color-rail transistor. Only one
> color is active per bank at any time, so the definitive worst-case indicator-rail budget is
> **240mA total**: Bank 1 = 5 LEDs x 20mA = 100mA max, Bank 2 = 7 LEDs x 20mA = 140mA max.
>
### Per-Bit Illumination

* Each bank has one always-on source-status LED anode plus individual config-bit LED anodes
  (U2 drives Bank 1 anodes, U3 drives Bank 2 anodes).
* CM5 daemon sets each anode HIGH to illuminate that bit's LED when the corresponding bit in the
  active configuration is set (= 1) and the correct bank colour rail is enabled.
* Unset bits (= 0) have their anode held LOW (LED off); only active configuration bits are
  illuminated.

### Bank Source-Status LED

The first LED in each bank (`D1` / `D6`) is a source-status indicator rather than a
switch-paired LED. Its anode is driven HIGH whenever the bank is active, while the shared RGB rail
colour communicates whether the applied configuration is user-intent forwarded (green) or
CM5-defined (red).

### Low-Side Colour-Rail Circuit

The six colour-rail sink stages on this board (`BNK1_R/G/B`, `BNK2_R/G/B`) follow the common RGB
sink-stage rule defined in `design/Standards/Global_Routing_Spec.md §3.1`.

On the User Settings Module this pattern is applied as one `BSS138` low-side sink per bank colour rail,
with gates driven by `U2` / `U3`.

Each LED uses three dedicated series resistors: one in each red, green, and blue cathode path.
This allows the three dice to be balanced independently under nominal 5V operation.

When the GPIO output is HIGH, the transistor turns ON, sinking the selected colour rail to GND and
illuminating any LEDs in that bank whose anode outputs are HIGH. GPIO LOW = transistor OFF = colour
rail disabled.

---

## 6. `CFG_APPLY_N` Button

SW11 is a board-mounted momentary tactile switch (SPST, active-low) connected to
U1 GPA[6]. The switch itself does not need to be panel-mount; the enclosure may use a
simple plunger or cap to mechanically actuate the switch through the panel opening.

* **Pull-up:** 10kΩ to 3V3_ENIG (R11) - idle state = logic HIGH.
* **Debounce:** 100nF X7R 0402 capacitor to GND (C4; RC τ = 1ms).
* **Operation:** CM5 enigma daemon polls GPA[6] during its main loop. On detecting LOW (button
  pressed, after debounce), the daemon:
  1. Reads U1 (full 16-bit state).
  2. Determines whether each bank should forward User Settings Module user intent or apply a CM5 override.
  3. Writes final configuration to U8 GPA[3:0] and GPB[5:0] on the Stator Board.
  4. Pulses the Stator-side `CFG_APPLY_N` output (U8 GPA[6]) LOW then HIGH to trigger a
     Stator-only configuration reload.
  5. Updates U2 and U3 outputs to reflect the new configuration source and state.

This button provides operator-initiated explicit configuration commit without relying solely on
automatic polling intervals.

---

## 7. Interconnects

### J1 - I²C Connector to Stator Board

| Pin | Signal | Notes |
| :--- | :--- | :--- |
| 1 | 3V3_ENIG | Power from Stator; powers User Settings Module logic (MCP23017 ICs) |
| 2 | 5V_MAIN | Indicator power supply from Stator; powers LED anodes only |
| 3 | GND | Logic ground return only; no local GND_CHASSIS bond on User Settings Module |
| 4 | SDA | I²C data; shared Stator I²C-1 bus |
| 5 | SCL | I²C clock; shared Stator I²C-1 bus |
| 6 | GND | LED cathode ground return; high-current return path |

**Connector:** JST B6B-PH-K-S(LF)(SN) - 6-pin JST PH 2.0mm THT
(Mouser: 306-B6B-PH-K-SLFSN, DigiKey: 455-1708-ND, JLCPCB: C131342)

**Cable:** 6-wire harness (100mm recommended); matching JST PHR-6 crimp housing on both ends. Use 28AWG for pins 2 and 6 (power path) and 30AWG for pins 1, 3, 4, 5 (logic/signals).

**Mating connector on Stator:** J13 - same JST PH 2.0mm 6-pin part.

**Why 2x GND pins?**

* Pin 3 (GND): Low-current logic return for MCP23017s (~80mA total)
* Pin 6 (GND): High-current LED return (up to 240mA max, ~120mA typical)
* Separating logic and power grounds reduces noise coupling into I²C signals

---

## 8. PCB Fabrication

* **Stackup:** 4-layer standard per `design/Standards/Global_Routing_Spec.md §2.3.1`. Physical properties: see `design/Production/JLCPCB_Manufacturing.md §1.1`.
* **JTAG chain:** None — User Settings Module is not in any JTAG chain.

### 8.1 Manually Fitted Components

Per `design/Production/JLCPCB_Manufacturing.md §3.2`, all THT components require manual fitting after
JLCPCB PCBA and are excluded from the JLCPCB SMT assembly BOM.

| RefDes | Description | Package |
| :--- | :--- | :--- |
| D1-D12 | Kingbright WP154A4SEJ3VBDZGW/CA 5mm common-anode RGB LED | THT |
| J1 | JST B6B-PH-K-S(LF)(SN) 6-pin PH 2.0 mm connector | THT |
| SW1-SW10 | E-Switch 200MSP1T2B4M2QE SPDT latching toggle | THT panel-mount |
| SW11 | Omron B3F-1070 SPST NO tactile | THT |

---

## 9. Thermal & ESD

* **Thermal:** No active cooling required on the User Settings Module. No high-power components are fitted; thermal dissipation is well within passive limits.
* **ESD:** All connectors on the User Settings Module are internal. J1 (JST PH 6-pin harness to Stator J13) is a PCB-to-harness connection; it is not operator-accessible during live operation.
  No TVS protection is required per `design/Standards/Global_Routing_Spec.md §9`.

---

## 10. Bill of Materials

| RefDes | Specification | MPN | Manufacturer | DigiKey PN | Mouser PN | JLCPCB PN | Alt Supplier + PN | Notes | Footprint Available | Footprint Downloaded | Qty |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| C1-C4 | 100nF X7R 50V 0402 | CL05B104KB5NNNC | Samsung | 1276-CL05B104KB5NNNCCT-ND | 187-CL05B104KB5NNNC | C960916 | - | - | Yes | Pending | 4 |
| C5-C14 | 10µF X7R 25V 0805 | CL21B106KAYQNNE | Samsung | 1276-CL21B106KAYQNNECT-ND | 187-CL21B106KAYQNNE | C3039694 | - | - | Yes | ✔ | 10 |
| D1-D12 | 5mm common-anode RGB THT | WP154A4SEJ3VBDZGW/CA | Kingbright | 754-2029-ND | 604-WP154A43VBDZGWCA | C7151795 | - | - | Yes | Pending | 12 |
| J1 | 6-pin JST PH 2.0mm THT | B6B-PH-K-S(LF)(SN) | JST | 455-1708-ND | 306-B6B-PH-K-SLFSN | C131342 | - | - | Yes | ✔ | 1 |
| Q1-Q18 | N-MOSFET 50V 200mA SOT-23 | BSS138 | onsemi | BSS138CT-ND | 512-BSS138 | C52895 | - | - | Yes | Pending | 18 |
| Q19-Q30 | P-MOSFET AEC-Q101 SOT-23 | SQ2319ADS-T1_BE3 | Vishay | 742-SQ2319ADS-T1_BE3CT-ND | 78-SQ2319ADS-T1_BE3 | C3280190 | - | - | Yes | Pending | 12 |
| R1-R11 | 10kΩ 1% 0603 | ERJ-3EKF1002V | Panasonic | P10.0KHCT-ND | 667-ERJ-3EKF1002V | C191124 | - | - | Yes | Pending | 11 |
| R12-R17,R54-R65 | 1kΩ 1% 0402 | ERJ-2RKF1001X | Panasonic | P1.00KLCT-ND | 667-ERJ-2RKF1001X | C242161 | - | - | Yes | Pending | 18 |
| R18-R29 | 150Ω 1% 0603 | ERJ-3EKF1500V | Panasonic | P150HCT-ND | 667-ERJ-3EKF1500V | C400650 | - | - | Yes | Pending | 12 |
| R30-R53 | 100Ω 1% 0603 | ERJ-3EKF1000V | Panasonic | P100HCT-ND | 667-ERJ-3EKF1000V | C193336 | - | - | Yes | Pending | 24 |
| R66-R77 | 47kΩ ±0.5% AEC-Q200 0402 | SG73S1ERTTP4702D | KOA Speer | 2019-SG73S1ERTTP4702DTR-ND ⚠️ MOQ 10000 | 660-SG73S1ERTTP4702D | C5915648 ⚠️ MOQ 40 | - | JLCPCB MOQ 40 | Yes | Pending | 12 |
| R78-R95 | 100kΩ 1% 0402 | ERJ-2RKF1003X | Panasonic | P100KLCT-ND | 667-ERJ-2RKF1003X | Global sourcing / consignment | Global sourcing | no JLCPCB stock | Yes | Pending | 18 |
| SW1-SW10 | SPDT latching toggle panel-mount THT | 200MSP1T2B4M2QE | E-Switch | EG5525-ND | 612-200MSP1T2B4M2QE | C5491263 | - | - | Yes | Pending | 10 |
| SW11 | SPST NO tactile THT | B3F-1070 | Omron | SW406-ND | 653-B3F-1070 | C726011 | - | - | Yes | ✔ | 1 |
| U1-U3 | I²C GPIO expander SOIC-28 | MCP23017T-E/SO | Microchip Technology | MCP23017T-E/SOCT-ND | 579-MCP23017T-E/SO | C47023 | - | - | Yes | Pending | 3 |

---

## 11. Power Budget

### 3V3_ENIG (Logic Rail)

| Component | Typical (mA) | Max (mA) | Notes |
| :--- | :---: | :---: | :--- |
| U1 (MCP23017 @ 0x23) | 25 | 50 | Switch input reader; 16 GPIO inputs |
| U2 (MCP23017 @ 0x24) | 25 | 50 | Bank 1 LED controller; low-side MOSFET drivers |
| U3 (MCP23017 @ 0x25) | 25 | 50 | Bank 2 LED controller; low-side MOSFET drivers |
| **Total 3V3_ENIG** | **75 mA** | **150 mA** | Well within Stator J13 capacity |

### 5V_MAIN (Indicator Rail Allocation)

| Load | Typical (mA) | Max (mA) | Notes |
| :--- | :---: | :---: | :--- |
| Bank 1 LEDs (5x @ 20mA) | 60 | 100 | Typical assumes ~12mA per LED average; max = 5 x 20mA = 100mA with one active colour rail |
| Bank 2 LEDs (7x @ 20mA) | 84 | 140 | Typical assumes ~12mA per LED average; max = 7 x 20mA = 140mA with one active colour rail |
| **Total indicator rail** | **144 mA** | **240 mA** | Definitive max = 100mA + 140mA; one active colour per bank, all 12 LEDs illuminated |

**User Settings Module 5V_MAIN Allocation:**

* User Settings Module indicator rail: **240mA max**
* This board uses `5V_MAIN` only for LED anode power.

---

## 12. Component Count Summary

| Category | Quantity | Notes |
| :--- | :---: | :--- |
| **Toggle Switches** | 10 | E-Switch 200MSP1T2B4M2QE - SPDT latching panel-mount |
| **RGB LEDs** | 12 | Kingbright WP154A4SEJ3VBDZGW/CA - 5mm common-anode THT |
| **MCP23017 I²C Expanders** | 3 | U1, U2, U3 |
| **BSS138 MOSFETs (colour-rail low-side)** | 6 | Q1/G/B, Q4/G/B - shared colour-rail cathode switches |
| **BSS138 MOSFETs (per-anode pre-driver)** | 12 | Q7-Q18 - one per LED anode; drives PMOS high-side gate |
| **PMOS MOSFETs (per-anode high-side switch)** | 12 | Q19-Q30 - Vishay SQ2319ADS-T1_BE3; source at 5V_MAIN, drain to LED anode |
| **0603 LED path resistors** | 36 | 12x red (150Ω), 12x green (100Ω), 12x blue (100Ω) |
| **0603 Resistors (switch pull-down)** | 10 | 10kΩ pull-downs on all toggle-switch inputs |
| **0402 Resistors (colour-rail gate)** | 6 | R12-R17: 1kΩ colour-rail MOSFET gate resistors |
| **0402 Resistors (per-anode gate)** | 12 | R54-R65: 1kΩ BSS138 pre-driver gate resistors |
| **0402 Resistors (PMOS pull-up)** | 12 | R66-R77: KOA Speer SG73S1ERTTP4702D 47 kΩ ±0.5% PMOS gate pull-ups |
| **0402 Resistors (BSS138 gate pull-down)** | 18 | R78-R95: 100kΩ Panasonic ERJ-2RKF1003X - holds gates LOW at power-up Hi-Z |
| **0603 Resistors (misc)** | 1 | R11: 10kΩ `CFG_APPLY_N` pull-up |
| **0402 Capacitors (decoupling)** | 3 | 100nF X7R for 3x MCP23017s |
| **0402 Capacitors (debounce)** | 1 | C4: 100nF X7R `CFG_APPLY_N` debounce |
| **0805 Capacitors (power-entry bulk)** | 10 | C5-C14: 10µF X7R 25V Samsung CL21B106KAYQNNE - 5x on `3V3_ENIG`, 5x on `5V_MAIN` power-entry nodes; satisfies §3 bulk-entry bank rule |
| **JST PH Connectors** | 1 | J1: 6-pin B6B-PH-K-S(LF)(SN) to Stator |
| **Pushbutton Switch** | 1 | SW11 - Omron B3F-1070 SPST NO through-hole tactile switch |

**Total unique part numbers:** ~20
**Total component count:** 166

---

## 13. Design Notes

### LED Control Architecture

The User Settings Module uses a **hybrid topology**: shared colour-rail low-side switches for RGB selection
combined with per-anode high-side switches for individual LED illumination control:

* **Colour-rail low-side stage (Q1-Q6):** 6x BSS138 N-channel MOSFETs switch each RGB cathode rail to
  GND - 3 per bank (red, green, blue). MCP23017 GPIO drives gate directly through 1 kΩ resistors
  (R12-R17). GPIO HIGH = transistor ON = colour rail active.

* **Per-anode high-side stage (Q7-Q30):** 12x two-stage circuits (one per LED anode) consisting of:
  1. BSS138 NMOS pre-driver (Q7-Q18) - gate driven by MCP23017 GPIO through 1 kΩ resistor (R54-R65)
  2. PMOS high-side switch (Q19-Q30) - gate held HIGH by 47 kΩ pull-up (R66-R77) to `5V_MAIN`;
     BSS138 drain pulls gate LOW to enable PMOS. PMOS source at `5V_MAIN`, drain to LED anode.

  GPIO HIGH → BSS138 ON → PMOS gate ≈0 V → PMOS ON → LED anode at `5V_MAIN`. Logic is non-inverted;
  no firmware inversion required.

* **Root cause note:** Kingbright WP154A4SEJ3VBDZGW/CA LEDs have typical Vf = 3.3 V (blue/green).
  The MCP23017 GPIO output maximum is 3.3 V and cannot source current into a 5 V-supply anode directly.
  The two-stage high-side topology resolves this without requiring firmware changes or rail compromise.

* **Power-up behaviour:** 100 kΩ pull-down resistors (R78-R95) hold all 18 BSS138 gates LOW during
  MCP23017 Hi-Z at power-up, preventing spurious transistor turn-on and ensuring LED anodes remain
  de-energised until the CM5 drives the expanders.

### 5V Power Routing

Indicator power is provided on `J1` pin 2 as `5V_MAIN` from the Stator `J13` harness.

On the User Settings Module, this rail powers the LED anodes only (240mA max) and is not used by the
logic supply, which remains on `3V3_ENIG`.

### I²C Address Selection

The User Settings Module uses the contiguous `0x23`-`0x25` block immediately after the Stator's
`0x20`-`0x22` expanders. This keeps the shared Settings/Stator GPIO devices grouped together on the
bus. The authoritative full-system I²C allocation is defined in `design/Electronics/Controller/Design_Spec.md §4.1`.
