# Stator V1.0 Master Pinout

**Status:** Draft
**Project:** Enigma-NG
**Author:** Izzyonstage & GitHub Copilot
**Version:** v.0.1.0
**Associated Hardware Revision:** Rev A
**Last Updated:** 2026-04-26

## 1. J10 - Reflector / Extension Link (30-pin, 2x15, 2.54mm Shrouded Box Header)

Provides a direct power and data link to the Reflector (end-of-stack loopback) board, bypassing the
full rotor stack to avoid cumulative contact resistance on the power rail and to provide a short TDO
return path for the JTAG chain.

> **Connector Definition Owner:** This board. All other boards using this connector cross-reference
> here.

| Pin | Signal | Direction | Notes |
| :--- | :--- | :--- | :--- |
| 1 | 5V_MAIN | CTRL → Ext / Reflector | Actuation supply (outer pair) |
| 2 | 5V_MAIN | CTRL → Ext / Reflector | Additional current path |
| 3 | 3V3_ENIG | PM → Reflector / Ext | 3.3V logic power (bypasses rotor stack) |
| 4 | 3V3_ENIG | PM → Reflector / Ext | Additional current path |
| 5 | GND | - | Logic/actuation return |
| 6 | GND | - | Logic/actuation return |
| 7 | ENC_OUT_REF[0] | Stator → Reflector / Ext | Outbound reflector-boundary bit 0 |
| 8 | ENC_OUT_REF[1] | Stator → Reflector / Ext | Outbound reflector-boundary bit 1 |
| 9 | ENC_OUT_REF[2] | Stator → Reflector / Ext | Outbound reflector-boundary bit 2 |
| 10 | ENC_OUT_REF[3] | Stator → Reflector / Ext | Outbound reflector-boundary bit 3 |
| 11 | ENC_OUT_REF[4] | Stator → Reflector / Ext | Outbound reflector-boundary bit 4 |
| 12 | ENC_OUT_REF[5] | Stator → Reflector / Ext | Outbound reflector-boundary bit 5 |
| 13 | GND | - | Signal group guard return |
| 14 | GND | - | Signal group guard return |
| 15 | SYS_RESET_N | Stator → Reflector / Ext | Active-low CPLD reset broadcast |
| 16 | TTD_RETURN | Reflector / Ext → Stator | JTAG TDO return path |
| 17 | GND | - | Signal group guard return |
| 18 | GND | - | Signal group guard return |
| 19 | ENC_IN_REF[0] | Reflector / Ext → Stator | Inbound reflector-boundary bit 0 |
| 20 | ENC_IN_REF[1] | Reflector / Ext → Stator | Inbound reflector-boundary bit 1 |
| 21 | ENC_IN_REF[2] | Reflector / Ext → Stator | Inbound reflector-boundary bit 2 |
| 22 | ENC_IN_REF[3] | Reflector / Ext → Stator | Inbound reflector-boundary bit 3 |
| 23 | ENC_IN_REF[4] | Reflector / Ext → Stator | Inbound reflector-boundary bit 4 |
| 24 | ENC_IN_REF[5] | Reflector / Ext → Stator | Inbound reflector-boundary bit 5 |
| 25 | GND | - | Signal group guard return |
| 26 | GND | - | Signal group guard return |
| 27 | 3V3_ENIG | PM → Reflector / Ext | 3.3V symmetric outer pair |
| 28 | 3V3_ENIG | PM → Reflector / Ext | 3.3V symmetric outer pair |
| 29 | 5V_MAIN | CTRL → Ext / Reflector | 5V symmetric outer pair |
| 30 | 5V_MAIN | CTRL → Ext / Reflector | 5V symmetric outer pair |

**Connector:** 2x15 2.54mm shrouded box header with polarisation key (Adam Tech 2BHR-30-VUA). Per DEC-053.  
**Mating connector on Extension: J7 / Reflector: J4 - same 30-pin 2x15 shrouded box header.**

## 2. J1-J3: ROTOR INTERFACE CONNECTORS
>
> **Connector Definition Owner:** `Rotor/Board_Layout.md - Rotor Interface Connectors`.

The connector set (ENC-IN, ENC-OUT, and PWR/JTAG - one of each per rotor position) is defined on the
Rotor board. The positional requirement stands: J1-J3 must be **positionally identical** across
Stator, Extension, and Reflector so any rotor can mate at any position without re-wiring.

## 3. J11 / J12 - Controller Dock (Hybrid Molex - To Controller Board)
>
> **Connector Definition Owner:** `Controller/Board_Layout.md - Controller ↔ Stator Dock`.

**Connector:** Molex `2195620015` hybrid blind-mate plug pair (`J11` / `J12`). Mating Controller
receptacles are Molex `2195630015` on `J4` / `J5`.

## 4. J4 / J5 / J6 / J7 / J8 / J9 - ENCODER PORTS (20-Pin, 2x10, 2.54mm Shrouded Box Header)

**Connector type:** 2x10 (20-pin) 2.54mm pitch shrouded box header with polarisation key.  
**Cable:** Standard 20-wire 2.54mm IDC ribbon cable.  
**Role model:** three physical banks of two identical ports using a single generic Encoder
`ENC_DATA[5:0]` service bus plus one active-low `ENC_ACTIVE_N` sideband.

### 4.1 Physical Placement & Silkscreen

```text
Bank 1 (HID)             Bank 2 (Plugboard Pass 1)    Bank 3 (Plugboard Pass 2)
┌────────────┐           ┌────────────┐               ┌────────────┐
│    J4     │           │    J6     │               │    J8     │
│  KBD_ENC   │           │PLG_PASS1_  │               │PLG_PASS2_  │
│            │           │    DEC     │               │    DEC     │
└────────────┘           └────────────┘               └────────────┘
┌────────────┐           ┌────────────┐               ┌────────────┐
│    J5     │           │    J7     │                │    J9     │
│  LBD_DEC   │           │PLG_PASS1_  │               │PLG_PASS2_  │
│            │           │    ENC     │               │    ENC     │
└────────────┘           └────────────┘               └────────────┘
```

> **Silkscreen requirement:** Each port labelled by fixed function, not by a generic board number.
>
### 4.2 JTAG Chain

TCK and TMS are broadcast to all six encoder ports and the rotor stack. SYS_RESET_N is broadcast to
all devices. TDI/TDO form a serial chain routed internally on the Stator PCB:

1. Controller `J5` / Stator `J12` TDI -> **Stator CPLD** TDI
2. Stator CPLD TDO -> **J4 (`KBD_ENC`)** TDI
3. J4 TDO -> **J5 (`LBD_DEC`)** TDI
4. J5 TDO -> **J6 (`PLG_PASS1_DEC`)** TDI
5. J6 TDO -> **J7 (`PLG_PASS1_ENC`)** TDI
6. J7 TDO -> **J8 (`PLG_PASS2_DEC`)** TDI
7. J8 TDO -> **J9 (`PLG_PASS2_ENC`)** TDI
8. J9 TDO -> **Rotor stack** TDI (via J1-J3 PWR/JTAG connector)
9. Rotor stack TDO returns via J10 Extension Port `TTD_RETURN`

> **Connector Definition Owner:** This board. All other boards using this connector cross-reference
> here.
>
### 4.3 Stator Alias Mapping

The remote Encoder board always exposes the same generic `ENC_DATA[5:0]` pins plus one generic
`ENC_ACTIVE_N` pin on `J2`. The Stator owns the per-port alias names below so the wiring remains
self-describing.

| Port | Fixed role | Stator alias carried on `ENC_DATA[5:0]` | Pin 8 alias |
| :--- | :--- | :--- | :--- |
| `J4` | `KBD_ENC` | `ENC_IN_KBD[5:0]` | `ENC_ACTIVE_KBD_N` |
| `J5` | `LBD_DEC` | `ENC_OUT_LBD[5:0]` | `ENC_ACTIVE_LBD_N` |
| `J6` | `PLG_PASS1_DEC` | `ENC_OUT_PLG1[5:0]` | Reserved / not used |
| `J7` | `PLG_PASS1_ENC` | `ENC_IN_PLG1[5:0]` | Reserved / not used |
| `J8` | `PLG_PASS2_DEC` | `ENC_OUT_PLG2[5:0]` | Reserved / not used |
| `J9` | `PLG_PASS2_ENC` | `ENC_IN_PLG2[5:0]` | Reserved / not used |

### 4.4 Pin Table (identical physical pinout across J4/J5/J6/J7/J8/J9)

| Pin | Signal | Direction | Notes |
| :--- | :--- | :--- | :--- |
| 1 | 3V3_ENIG | Stator->Encoder | Power supply |
| 2 | ENC_DATA[0] | Role-dependent | Stator alias per port - see table above |
| 3 | ENC_DATA[1] | Role-dependent | Stator alias per port - see table above |
| 4 | ENC_DATA[2] | Role-dependent | Stator alias per port - see table above |
| 5 | ENC_DATA[3] | Role-dependent | Stator alias per port - see table above |
| 6 | ENC_DATA[4] | Role-dependent | Stator alias per port - see table above |
| 7 | ENC_DATA[5] | Role-dependent | Stator alias per port - see table above |
| 8 | ENC_ACTIVE_N | Role-dependent | `J4` = `ENC_ACTIVE_KBD_N`, `J5` = `ENC_ACTIVE_LBD_N`, `J6-J9` reserved / held inactive |
| 9 | GND | - | `ENC_ACTIVE_N` / JTAG group separator |
| 10 | TCK | Stator->Encoder | JTAG clock (broadcast to all encoder ports) |
| 11 | GND | - | TCK/TMS inter-pin shield |
| 12 | TMS | Stator->Encoder | JTAG mode select (broadcast to all encoder ports) |
| 13 | GND | - | TMS/TDO inter-pin shield |
| 14 | TDO | Encoder->Stator | JTAG data out (chains to next device via Stator) |
| 15 | GND | - | TDO/TDI inter-pin shield |
| 16 | TDI | Stator->Encoder | JTAG data in (from previous device via Stator) |
| 17 | GND | - | TDI/SYS_RESET_N shield |
| 18 | SYS_RESET_N | Stator->Encoder | Active-low CPLD reset (broadcast to all encoder ports) |
| 19 | GND | - | Power return / trailing shield |
| 20 | 3V3_ENIG | Stator->Encoder | Power supply |

**Power capacity:** 2 x 3V3_ENIG pins x 1A/pin = 2.0A - adequate for one Encoder Module load
(~104mA).

---

## 5. J13 - User Settings Module I²C Connector

**Component:** JST B6B-PH-K-S(LF)(SN) - 6-pin JST PH 2.0mm THT (JLCPCB: C131342).  
**Placement:** Board edge facing the enclosure panel, accessible without rotor stack removal.

## 6. U8 - MCP23017 CPLD Config Output Driver (@ 0x22)

**Component:** MCP23017T-E/SO, SOIC-28.  
**Placement:** Near Stator CPLD U1, within 15 mm of config pull-down resistors. Decoupling cap within
1 mm of VDD pin.

Drives the CPLD configuration input pins (`CFG_ROUTE[3:0]`, `CFG_REFMAP[5:0]`) plus the active-low
Stator-only `CFG_APPLY_N` pulse under CM5 firmware control.

---

## 7. U6 / U7 - MCP23017 I²C GPIO Expanders (CM5 Interface)

**Component:** MCP23017T-E/SO, SOIC-28 (both).  
**Placement:** Near Controller dock connectors J11/J12; within 20 mm of each other. Decoupling caps
within 1 mm of each VDD pin.

- **U6** (I²C address 0x20) - Encoder-bus activity monitoring: reads `ENC_ACTIVE_N` sidebands from
  all six encoder ports (J4-J9) and presents them to the CM5 over I²C.
- **U7** (I²C address 0x21) - Virtual key injection, keyboard source selection, and system reset:
  drives `CM5_KEY_DATA[5:0]`, `KEY_CM5_ACTIVE` (keyboard source select), and `SYS_RESET_N`
  broadcast to the CPLD and all downstream boards.

---

## 8. U4 / U5 - Keyboard Source MUX

**Component:** 74HC157PW-Q100,118, TSSOP-16 (both).  
**Placement:** Near U7 (they share the `KEY_CM5_ACTIVE` select line) and near U1 CPLD input pins
for the selected keyboard bus.

A pair of quad 2-to-1 multiplexers that select between the physical keyboard encoder input
(`ENC_IN_KBD[5:0]` from J4) and the CM5-driven virtual key data (`CM5_KEY_DATA[5:0]` from U7) and
presents the selected 6-bit bus to the CPLD U1 encryption entry point.

---

## 9. U2 - INA219 3V3\_ENIG Current / Voltage Monitor

**Component:** INA219AIDR, SOIC-8.  
**Placement:** In series on the 3V3\_ENIG entry trace between J12 (Controller dock) and the local
shunt resistor R1; within 10 mm of the shunt. Decoupling cap within 1 mm of VS pin.

Provides real-time 3V3\_ENIG voltage and current telemetry to the CM5 over I²C. The shunt resistor
R1 is on the 3V3\_ENIG entry trace; INA219 differential voltage sense pins straddle R1.

---

## 10. U1 - Stator CPLD Signal Map (Logical Pin Budget)

> This is the board-authoritative **logical** signal map for U1.The local MAX II handbook confirms
> `EPM570T100` package availability in TQFP-100, but it explicitly points printed device pin-outs to
> the vendor package documentation rather than providing a fixed package pin table in the handbook.
> The grouping below therefore freezes **what U1 must connect to**, while the exact TQFP pad numbers
> remain a schematic-capture task.
>
> **CPLD power rails:** All VCCINT and VCCIO pins on U1 connect to `3V3_ENIG`. Refer to the
> device datasheet for supply domain details including the MultiVolt core architecture.
> **Reference datasheet:** `design/Datasheets/Intel-EPM570T100I5N-datasheet.md`

### 10.1 Dedicated device pins

| Function | Source / destination | Notes |
| :--- | :--- | :--- |
| `TCK` | Controller dock `J12` -> U1 | Dedicated JTAG clock input; broadcast onwards to all encoder ports and the rotor stack |
| `TMS` | Controller dock `J12` -> U1 | Dedicated JTAG mode input; broadcast onwards to all encoder ports and the rotor stack |
| `TDI` | Controller dock `J12` -> U1 | Head of the Stator-managed JTAG daisy chain |
| `TDO` | U1 -> Stator JTAG chain -> `J4` | First JTAG chain output; continues through encoder ports, then the rotor stack |
| `DEV_CLR_N` | `U3` (`SYS_RESET_N AND CFG_APPLY_N`) -> U1 | Dedicated device clear; not counted as a general-purpose routing I/O (vendor pin name `DEV_CLRN` - see `design/Standards/Global_Routing_Spec.md §10`) |

### 10.2 General-purpose signal groups

| Signal group | Pins | U1 direction | Notes |
| :--- | :---: | :--- | :--- |
| Selected keyboard-source bus | 6 | Input | Output of `U4`/`U5`; forwards either the physical keyboard source or `CM5_KEY_DATA[5:0]` into the Step 1 entry point |
| `ENC_OUT_LBD[5:0]` | 6 | Output | Drives the `LBD_DEC` lightboard decoder port (`J5`) |
| `ENC_OUT_PLG1[5:0]` | 6 | Output | Drives `PLG_PASS1_DEC` (`J6`) |
| `ENC_IN_PLG1[5:0]` | 6 | Input | Reads `PLG_PASS1_ENC` (`J7`) |
| `ENC_OUT_PLG2[5:0]` | 6 | Output | Drives `PLG_PASS2_DEC` (`J8`) |
| `ENC_IN_PLG2[5:0]` | 6 | Input | Reads `PLG_PASS2_ENC` (`J9`) |
| `ENC_OUT_ROT[5:0]` | 6 | Output | Forward-path bus from Stator into the first rotor via `J3` |
| `ENC_IN_ROT[5:0]` | 6 | Input | Return-path bus from the rotor stack via `J3` |
| `ENC_OUT_REF[5:0]` | 6 | Output | Stator-owned outbound reflector/extension bus via `J10` |
| `ENC_IN_REF[5:0]` | 6 | Input | Stator-owned inbound reflector/extension return bus via `J10` |
| `CFG_ROUTE[3:0]` | 4 | Input | Route-select inputs driven by `U8` |
| `CFG_REFMAP[5:0]` | 6 | Input | Reflector-map select inputs driven by `U8` |

**Logical budget summary:** 70 general-purpose signal connections total = **40 inputs + 30 outputs**,
plus the dedicated JTAG / clear pins above.

**Spare-pin policy:** one spare channel inside the `U4`/`U5` mux pair remains unallocated after the
shared `ENC_ACTIVE_N` source-select path is added. `U7 GPA[7]` is allocated to `SYS_RESET_N`;
`U7 GPB[0]` is allocated to `CM5_KEY_ACTIVE_N` and `U7 GPB[1]` to `KEY_SRC_ACTIVE_N` monitoring, so
`U7 GPB[7:2]` remains spare/reserved for future Stator-side control additions.

---

## 11. Routing - Trace Width Specifications

**Board specs:** 4-layer / 2oz finished copper (JLC04161H-7628).  
L1 = signal (JTAG/routing); L2 = GND plane; L3 = 3V3_ENIG power pour; L4 = secondary routing / data
plate.

### 11.1 Trace Width Table

| Net | Peak Current | IPC Calc (2oz ext) | Design Min | **Specified Width** | Layer | Notes |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| Signal (Encoder `ENC_DATA` aliases, `ENC_IN_REF`/`ENC_OUT_REF`, `SYS_RESET_N`, `CFG_APPLY_N`, I2C) | < 5 mA | < 0.001 mm | 0.20 mm | **0.20 mm** | L1 | 3.3 V logic signals |
| JTAG signals: TCK, TMS, TDI, TDO, TTD_RETURN (CI) | signal | - | 0.127 mm | **0.127 mm (5 mil)** | L1 (external) | 50 Ω controlled impedance over L2 GND plane |
| JTAG fan-out to encoder ports (L1, cable-drive side) | signal | - | 0.20 mm | **0.20 mm** | L1 | Traces from series resistors to encoder-port connector pads |
| 3V3_ENIG entry trace (`J12` dock -> shunt R1) | 2.05 A | 0.31 mm | 0.80 mm | **0.80 mm** | L1 | Carries full rotor-stack + encoder load |
| 3V3_ENIG fan-out (post-shunt -> L3 pour via-down) | 2.05 A | 0.31 mm | 0.80 mm | **0.80 mm** | L1 | Entry to inner power pour via thermal via cluster |
| 3V3_ENIG distribution (inner power pour) | 2.05 A | - | pour | **copper pour** | L3 | Full uninterrupted 2oz plane |
| GND return (inner GND pour) | - | - | pour | **copper pour** | L2 | Solid GND reference plane |

### 11.2 Notes

- **JTAG CI traces:** 0.127 mm (5 mil) on L1 over the L2 GND plane achieves 50 Ω controlled
  impedance on the JLC04161H-7628 stackup.
- **Encoder-port terminations:** provide one TCK and one TMS series resistor per encoder port plus
  one TDI-chain series resistor for each Stator-driven cable segment in the six-module chain.
- **3V3_ENIG entry trace:** 0.80 mm remains the canonical trunk width for the 2.05 A design budget.

---

## 12. Mounting Holes

The Stator uses 4x M3 PTH mounting holes for chassis attachment per DR-STA-17.

### 12.1 Specifications

- **Count:** 4x M3 PTH
- **Hole diameter:** Ø3.2mm (clearance for M3 fastener)
- **Annular ring:** 6.0mm ENIG exposed pad (per GRS §4)
- **Net:** `GND_CHASSIS` — copper ring pads tied to chassis ground for Faraday-cage continuity
- **BOM:** No BOM entry; these are plain chassis mounting holes with no fitted components

### 12.2 Positions

Positions are defined relative to the board origin (bottom-left corner). Exact XY coordinates to be confirmed at PCB Layout; the following describe the intended placement:

| Hole | Position Description |
| :--- | :--- |
| MH1 | Bottom-left corner |
| MH2 | Bottom-right corner |
| MH3 | Central hole (approximate board centre) |
| MH4 | Centre-top (horizontally centred, near top edge) |

> **Note:** Exact coordinates are subject to review during Schematic Capture and PCB Layout. The Stator board outline and connector clearances must be factored in before finalising hole positions.

### 12.3 Cross-References

| Document | Relevance |
| :--- | :--- |
| `design/Standards/Global_Routing_Spec.md §4` | Mechanical grounding, ENIG annular ring, GND_CHASSIS bonding rules |
| `design/Standards/Global_Routing_Spec.md §4.3` | Default mounting hole placement Pattern B (D-shaped board) |
| `design/Electronics/Stator/Design_Spec.md DR-STA-17` | Design requirement for mounting holes |
| `design/Electronics/Stator/Design_Spec.md §2` | GND_CHASSIS single-point bond note |
