# User Settings Module V1.0 Layout & Pinout

**Status:** In Review
**Project:** Enigma-NG
**Author:** Izzyonstage & GitHub Copilot
**Version:** v.0.1.0
**Associated Hardware Revision:** Rev A
**Last Updated:** 2026-05-13

---

## 1. Board Overview

The User Settings Module is a landscape-orientation panel-mount PCB. The switch bodies mount through the
enclosure top-face panel cutouts, while the PCB sits directly behind the panel and connects back to
the Stator via a 6-wire harness on `J1`.

The active architecture is:

- `U1` (`MCP23017 @ 0x23`) reads the 10 configuration toggles plus `CFG_APPLY_N`
- `U2` (`MCP23017 @ 0x24`) drives the 5 Bank 1 BSS138 pre-driver gates and the Bank 1 RGB rail gates
- `U3` (`MCP23017 @ 0x25`) drives the 7 Bank 2 BSS138 pre-driver gates and the Bank 2 RGB rail gates
- `Q1-Q6` (BSS138 NMOS) are shared colour-rail low-side switches (3 per bank: R/G/B)
- `Q7-Q18` (BSS138 NMOS) are per-anode pre-drivers; `Q19-Q30` (PMOS, Cat B) are per-anode high-side switches;
  each pair sits in the signal path between the MCP23017 GPIO and the LED anode

All three LED colour channels are routed and driven; CM5 selects the active bank colour according to
mode or status state.

```text
TOP EDGE / ENCLOSURE PANEL FACE

  [D1 SRC]  [SW1] [SW2] [SW3] [SW4]   [D6 SRC]  [SW5] [SW6] [SW7] [SW8] [SW9] [SW10] [SW11]
    [LED]   [D2]  [D3]  [D4]  [D5]      [LED]   [D7]  [D8]  [D9]  [D10] [D11] [D12]  [PB]

   J1        U1 (0x23)    U2 (0x24)  Q7-Q11/Q19-Q23    U3 (0x25)  Q12-Q18/Q24-Q30   Q1/G/B Q4/G/B
   left edge       centre-left    centre                              centre-right              right edge
```

---

## 2. Placement Zones

- **Top edge:** 10 configuration toggle switches, 12 indicator LEDs (including 2 source-status LEDs), and the `SW11` actuator position
- **Left edge:** `J1` 6-pin JST PH connector, cable exit toward Stator `J13`
- **Centre-left:** `U1`, switch pull-downs, `R11`, `C4`
- **Centre / centre-right:** `U2` and `U3`, LED series resistors, per-anode two-stage switches
  (`Q7-Q18` BSS138 pre-drivers + `Q19-Q30` PMOS high-side, Cat B), and anode-routing fanout
- **Right edge:** 6 RGB BSS138 colour-rail transistors (`Q1-Q6`) with adjacent gate resistors
  (`R12-R17`)

---

## 3. J1 - Stator Harness Connector

**Connector:** `B6B-PH-K-S(LF)(SN)` - 6-pin JST PH 2.0mm, vertical THT  
**Mating connector:** Stator `J13`  
**Cable:** 6-wire harness, 100mm recommended

| Pin | Signal | Notes |
| :--- | :--- | :--- |
| 1 | `3V3_ENIG` | Logic supply for the three MCP23017 devices |
| 2 | `5V_MAIN` | Indicator power feed from the Controller via Stator `J13` / `J11` |
| 3 | `GND` | Logic return only; no local GND_CHASSIS bond |
| 4 | `SDA` | Shared I2C-1 data |
| 5 | `SCL` | Shared I2C-1 clock |
| 6 | `GND` | Indicator-current return paired with pin 2 |

> Use 28AWG for pins 2 and 6, and 30AWG for pins 1, 3, 4, and 5.

---

## 4. U1 - MCP23017 @ 0x23

**Package:** SOIC-28  
**Role:** Reads the 10 configuration toggles and `CFG_APPLY_N`

| Port | Pin | Signal | Direction | Pull | Description |
| :--- | :--- | :--- | :--- | :--- | :--- |
| GPA | [0] | `CFG_ROUTE[0]` | Bidirectional(Input) | 10k pull-down | Bank 1 routing config bit 0 (`SW1`) |
| GPA | [1] | `CFG_ROUTE[1]` | Bidirectional(Input) | 10k pull-down | Bank 1 routing config bit 1 (`SW2`) |
| GPA | [2] | `CFG_ROUTE[2]` | Bidirectional(Input) | 10k pull-down | Bank 1 routing config bit 2 (`SW3`) |
| GPA | [3] | `CFG_ROUTE[3]` | Bidirectional(Input) | 10k pull-down | Bank 1 routing config bit 3 (`SW4`) |
| GPA | [5:4] | NC | Bidirectional | - | - |
| GPA | [6] | `CFG_APPLY_N` | Bidirectional(Input) | 10k pull-up | Active-low momentary pushbutton (`SW11`) |
| GPA | [7] | NC | Output | - | - |
| GPB | [0] | `CFG_REFMAP[0]` | Bidirectional(Input) | 10k pull-down | Bank 2 reflector-map bit 0 (`SW5`) |
| GPB | [1] | `CFG_REFMAP[1]` | Bidirectional(Input) | 10k pull-down | Bank 2 reflector-map bit 1 (`SW6`) |
| GPB | [2] | `CFG_REFMAP[2]` | Bidirectional(Input) | 10k pull-down | Bank 2 reflector-map bit 2 (`SW7`) |
| GPB | [3] | `CFG_REFMAP[3]` | Bidirectional(Input) | 10k pull-down | Bank 2 reflector-map bit 3 (`SW8`) |
| GPB | [4] | `CFG_REFMAP[4]` | Bidirectional(Input) | 10k pull-down | Bank 2 reflector-map bit 4 (`SW9`) |
| GPB | [5] | `CFG_REFMAP[5]` | Bidirectional(Input) | 10k pull-down | Bank 2 reflector-map bit 5 (`SW10`) |
| GPB | [6] | NC | Bidirectional | - | - |
| GPB | [7] | NC | Output | - | - |

---

## 5. LED Drive Expanders

### 5.1 U2 - MCP23017 @ 0x24

> **Note:** GPA[0:4] each drive a BSS138 pre-driver gate (Q7-Q11) via 1 kΩ (R54-R58); the BSS138
> pulls its paired PMOS gate (Q19-Q23) low, enabling the 5V_MAIN high-side switch to the LED anode.

| Port | Pin | Signal | Direction | Description |
| :--- | :--- | :--- | :--- | :--- |
| GPA | [0] | `LED_B1_SRC_A` | Bidirectional(Output) | Drives Q7 gate → Q19 high-side → D1 anode |
| GPA | [1] | `LED_B1_0_A` | Bidirectional(Output) | Drives Q8 gate → Q20 high-side → D2 anode |
| GPA | [2] | `LED_B1_1_A` | Bidirectional(Output) | Drives Q9 gate → Q21 high-side → D3 anode |
| GPA | [3] | `LED_B1_2_A` | Bidirectional(Output) | Drives Q10 gate → Q22 high-side → D4 anode |
| GPA | [4] | `LED_B1_3_A` | Bidirectional(Output) | Drives Q11 gate → Q23 high-side → D5 anode |
| GPA | [5] | `BNK1_R` | Bidirectional(Output) | Drives `Q1` gate (Bank 1 red colour-rail) |
| GPA | [6] | `BNK1_G` | Bidirectional(Output) | Drives `Q2` gate (Bank 1 green colour-rail) |
| GPA | [7] | `BNK1_B` | Output | Drives `Q3` gate (Bank 1 blue colour-rail) |
| GPB | [6:0] | NC | Bidirectional | - |
| GPB | [7] | NC | Output | - |

### 5.2 U3 - MCP23017 @ 0x25

> **Note:** GPA[0:6] each drive a BSS138 pre-driver gate (Q12-Q18) via 1 kΩ (R59-R65); the BSS138
> pulls its paired PMOS gate (Q24-Q30) low, enabling the 5V_MAIN high-side switch to the LED anode.

| Port | Pin | Signal | Direction | Description |
| :--- | :--- | :--- | :--- | :--- |
| GPA | [0] | `LED_B2_SRC_A` | Bidirectional(Output) | Drives Q12 gate → Q24 high-side → D6 anode |
| GPA | [1] | `LED_B2_0_A` | Bidirectional(Output) | Drives Q13 gate → Q25 high-side → D7 anode |
| GPA | [2] | `LED_B2_1_A` | Bidirectional(Output) | Drives Q14 gate → Q26 high-side → D8 anode |
| GPA | [3] | `LED_B2_2_A` | Bidirectional(Output) | Drives Q15 gate → Q27 high-side → D9 anode |
| GPA | [4] | `LED_B2_3_A` | Bidirectional(Output) | Drives Q16 gate → Q28 high-side → D10 anode |
| GPA | [5] | `LED_B2_4_A` | Bidirectional(Output) | Drives Q17 gate → Q29 high-side → D11 anode |
| GPA | [6] | `LED_B2_5_A` | Bidirectional(Output) | Drives Q18 gate → Q30 high-side → D12 anode |
| GPA | [7] | `BNK2_R` | Output | Drives `Q4` gate (Bank 2 red colour-rail) |
| GPB | [0] | `BNK2_G` | Bidirectional(Output) | Drives `Q5` gate (Bank 2 green colour-rail) |
| GPB | [1] | `BNK2_B` | Bidirectional(Output) | Drives `Q6` gate (Bank 2 blue colour-rail) |
| GPB | [6:2] | NC | Bidirectional | - |
| GPB | [7] | NC | Output | - |

---

## 6. LED Switch Topology

Each indicator LED uses a two-stage switch path from MCP23017 GPIO to LED anode, plus shared
colour-rail low-side switches for RGB selection.

**Per-anode high-side path (12 LED positions):**

| GPIO source | Gate resistor | BSS138 pre-driver | PMOS high-side | LED anode |
| :--- | :--- | :--- | :--- | :--- |
| `U2.GPA[0]` | `R54` | `Q7` | `Q19` | `D1` |
| `U2.GPA[1]` | `R55` | `Q8` | `Q20` | `D2` |
| `U2.GPA[2]` | `R56` | `Q9` | `Q21` | `D3` |
| `U2.GPA[3]` | `R57` | `Q10` | `Q22` | `D4` |
| `U2.GPA[4]` | `R58` | `Q11` | `Q23` | `D5` |
| `U3.GPA[0]` | `R59` | `Q12` | `Q24` | `D6` |
| `U3.GPA[1]` | `R60` | `Q13` | `Q25` | `D7` |
| `U3.GPA[2]` | `R61` | `Q14` | `Q26` | `D8` |
| `U3.GPA[3]` | `R62` | `Q15` | `Q27` | `D9` |
| `U3.GPA[4]` | `R63` | `Q16` | `Q28` | `D10` |
| `U3.GPA[5]` | `R64` | `Q17` | `Q29` | `D11` |
| `U3.GPA[6]` | `R65` | `Q18` | `Q30` | `D12` |

**Shared colour-rail low-side path (6 transistors):**

| Transistor | Gate source | Gate resistor | Function |
| :--- | :--- | :--- | :--- |
| `Q1` | `U2.GPA[5]` | `R12` | Pull Bank 1 red rail low |
| `Q2` | `U2.GPA[6]` | `R13` | Pull Bank 1 green rail low |
| `Q3` | `U2.GPA[7]` | `R14` | Pull Bank 1 blue rail low |
| `Q4` | `U3.GPA[7]` | `R15` | Pull Bank 2 red rail low |
| `Q5` | `U3.GPB[0]` | `R16` | Pull Bank 2 green rail low |
| `Q6` | `U3.GPB[1]` | `R17` | Pull Bank 2 blue rail low |

CM5 firmware normally selects one colour rail per bank at a time:

- **Green** = switch-defined configuration
- **Red** = CM5-defined override

---

## 7. Switch / LED Mapping

| Physical item | Switch input | LED anode output | Bank colour rail source |
| :--- | :--- | :--- | :--- |
| `D1` Bank 1 source-status LED | - | `U2.GPA[0]` (`LED_B1_SRC_A`) | `U2.GPA[5:7]` |
| `SW1` / `D2` | `U1.GPA[0]` (`CFG_ROUTE[0]`) | `U2.GPA[1]` (`LED_B1_0_A`) | `U2.GPA[5:7]` |
| `SW2` / `D3` | `U1.GPA[1]` (`CFG_ROUTE[1]`) | `U2.GPA[2]` (`LED_B1_1_A`) | `U2.GPA[5:7]` |
| `SW3` / `D4` | `U1.GPA[2]` (`CFG_ROUTE[2]`) | `U2.GPA[3]` (`LED_B1_2_A`) | `U2.GPA[5:7]` |
| `SW4` / `D5` | `U1.GPA[3]` (`CFG_ROUTE[3]`) | `U2.GPA[4]` (`LED_B1_3_A`) | `U2.GPA[5:7]` |
| `D6` Bank 2 source-status LED | - | `U3.GPA[0]` (`LED_B2_SRC_A`) | `U3.GPA[7]` / `U3.GPB[0:1]` |
| `SW5` / `D7` | `U1.GPB[0]` (`CFG_REFMAP[0]`) | `U3.GPA[1]` (`LED_B2_0_A`) | `U3.GPA[7]` / `U3.GPB[0:1]` |
| `SW6` / `D8` | `U1.GPB[1]` (`CFG_REFMAP[1]`) | `U3.GPA[2]` (`LED_B2_1_A`) | `U3.GPA[7]` / `U3.GPB[0:1]` |
| `SW7` / `D9` | `U1.GPB[2]` (`CFG_REFMAP[2]`) | `U3.GPA[3]` (`LED_B2_2_A`) | `U3.GPA[7]` / `U3.GPB[0:1]` |
| `SW8` / `D10` | `U1.GPB[3]` (`CFG_REFMAP[3]`) | `U3.GPA[4]` (`LED_B2_3_A`) | `U3.GPA[7]` / `U3.GPB[0:1]` |
| `SW9` / `D11` | `U1.GPB[4]` (`CFG_REFMAP[4]`) | `U3.GPA[5]` (`LED_B2_4_A`) | `U3.GPA[7]` / `U3.GPB[0:1]` |
| `SW10` / `D12` | `U1.GPB[5]` (`CFG_REFMAP[5]`) | `U3.GPA[6]` (`LED_B2_5_A`) | `U3.GPA[7]` / `U3.GPB[0:1]` |
| `SW11` | `U1.GPA[6]` (`CFG_APPLY_N`) | - | - |

---

## 8. PCB Stackup & Routing Notes

**Manufacturer:** JLCPCB  
**Layer count:** 4-layer  
**Stackup:** JLC04161H-7628  
**Copper:** 2oz outer  
**Finish:** ENIG

| Layer | Role | Notes |
| :--- | :--- | :--- |
| L1 | Signals + components | Switch inputs, I2C, LED anodes, rail gates |
| L2 | GND plane | Solid reference plane |
| L3 | Power | `3V3_ENIG` and local `5V_MAIN` distribution |
| L4 | Secondary routing + silkscreen | Low-speed routing only |

### 8.1 Routing guidance

- Keep `SDA` / `SCL` as a matched short pair from `J1` to the three expanders
- Route the `5V_MAIN` feed and pin-6 return wider than logic traces
- Place one 100nF decoupler at each MCP23017 supply pin cluster
- Keep colour-rail gate resistors (R12-R17) adjacent to the six colour-rail BSS138s (Q1-Q6)
- Place each BSS138 pre-driver (Q7-Q18) and its paired PMOS (Q19-Q30) in a tight pair directly
  in the anode signal path between the MCP23017 GPIO fanout and the LED anode; keep PMOS source
  via short and direct to the `5V_MAIN` plane

---

## 9. Cross-References

| Document | Description |
| :--- | :--- |
| `design/Electronics/User_Settings_Module/Design_Spec.md` | Full electrical specification and BOM |
| `design/Electronics/Stator/Design_Spec.md` | `J13` definition and CPLD configuration ownership |
| `design/Electronics/Stator/Board_Layout.md` | Mating connector definition for `J13` |
| `design/Mechanical/Main_Enclosure/Design_Spec.md` | Panel cutout and actuator constraints |

---

## 10. Mounting Holes

The USM is a landscape panel-mount PCB. Mounting hole details are TBD at PCB Layout; the following
provides a placeholder for the assembly constraint.

### 10.1 Specifications

- **Count:** 4x M3 PTH mounting holes (one near each corner)
- **Hole diameter:** Ø3.2mm (clearance for M3 fastener)
- **Annular ring:** 6.0mm ENIG exposed pad (per GRS §4)
- **Net:** `GND_CHASSIS` — copper ring pads tied to chassis ground per GRS §4 (Mechanical Grounding)
- **BOM:** No BOM entry; plain chassis mounting holes with no fitted components

### 10.2 Positions

Exact XY coordinates to be confirmed at PCB Layout. Intended placement:

| Hole | Position Description |
| :--- | :--- |
| MH1 | Top-left corner |
| MH2 | Top-right corner |
| MH3 | Bottom-right corner |
| MH4 | Bottom-left corner |

> **Note:** The USM mounts inside the main enclosure panel. Exact hole positions are subject to
> review at Schematic Capture and PCB Layout to account for panel cutout geometry and component
> clearances.

### 10.3 Cross-References

| Document | Relevance |
| :--- | :--- |
| `design/Standards/Global_Routing_Spec.md §4` | Mechanical grounding, ENIG annular ring, GND_CHASSIS bonding rules |
| `design/Electronics/User_Settings_Module/Design_Spec.md` | Full electrical specification; mounting hole DR TBD |
| `design/Mechanical/Main_Enclosure/Design_Spec.md` | Panel cutout dimensions that constrain hole positions |
