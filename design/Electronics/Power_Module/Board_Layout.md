# Power Module: Board Layout Visualisations

**Status:** Draft
**Project:** Enigma-NG
**Author:** Izzyonstage & GitHub Copilot
**Version:** v.0.1.0
**Associated Hardware Revision:** Rev A
**Last Updated:** 2026-04-20

---

## 1. Functional Role

The Power Module is a removable power cartridge that:

- accepts **local USB-C PD input**
- accepts **local smart-battery input**
- accepts a **regulated PoE-derived auxiliary feed** from the Controller
- ORs / filters / protects those inputs
- generates `5V_MAIN` and `3V3_ENIG`
- provides supercap-backed hold-up and direct `PWR_BUT_N` / `PWR_GD` support

The RJ45, Ethernet ESD, magnetics, and PoE PD / ACF front-end live on the Controller.

---

## 2. Edge / Bulkhead Zones

```text
TOP VIEW

 Rear / external face (top):   [USB-C] [BATT]
 Front / internal face (bottom): [J1] [J2] [J3]

 USB-C   battery
 local   local

 J1      J2        J3
 regulated rails   PoE aux   low-speed control
 to Controller     from Ctrl to Controller
```

- **J1:** regulated `5V_MAIN` / `3V3_ENIG` / `GND`
- **J2:** `VIN_POE_12V` + `GND` from the Controller PoE front-end
- **J3:** `I2C_SDA`, `I2C_SCL`, `PM_IO_INT_N`, `PWR_GD`, `ROTOR_EN_N`, `PWR_BUT_N`, `LED_PWR_N`, guarded by `GND`

All three dock connectors use the same TE family:

- Controller side: `1-1674231-1`
- Power Module side: `1123684-7`

---

## 3. Power Flow

```text
Controller J2 VIN_POE_12V ----.
USB-C PD (local) --------------+--> OR-ing --> EMI filter --(input power bus)--> eFuse ---> 5V buck ------> 5V_MAIN
Battery (local) ---------------'                                 ^                             \--> LDO --> 3V3_ENIG
                                                                 |
                          GND_CHASSIS ---- single GND bond ---- GND
                          (common power-entry point immediately before eFuse)

5V_MAIN / 3V3_ENIG -> J1 -> Controller
```

The PM remains the sole board that bonds `GND` to `GND_CHASSIS` at the clean/dirty boundary before the
eFuse.

---

## 4. SW1 RGB Control Block

```text
pre-boot hardware path:
MIC1555 U11 -> Q4 -> D6/D7 -> Red + Green only  -> orange flash

runtime path:
PCA9534A U16 -> Rgates -> Q6/Q7/Q8 -> R/G/B cathodes
                         ^
                    SW_LED_CTRL output
```

- **D6 / D7** isolate the hardware boot path on the **red and green channels only**
- **blue** is runtime-only and is not part of the hardware flash path
- **Q6 / Q7 / Q8** are the full runtime RGB low-side sink stages
- **U16 (`PCA9534APWR`, 0x3F)** handles:
  - inputs: `POE_STAT`, `SYS_FAULT`, `BATT_PRES_N`, `USB_STAT`
  - outputs: `SW_LED_R`, `SW_LED_G`, `SW_LED_B`, `SW_LED_CTRL`

`PWR_GD`, `ROTOR_EN_N`, `PWR_BUT_N`, and `LED_PWR_N` remain direct signals on J3.

---

## 5. Major Placement Areas

```text
 ______________________________________________________________________
| [ USB-C ] [ BATT ]                                                   |
|----------------------------------------------------------------------|
| [ OR-ing FETs / controllers ]  [ EMI filters ]  [ TPS259804 eFuse ]  |
|----------------------------------------------------------------------|
| [ dual 5V buck ] [ TPS75733 ] [ U16 PM expander ] [ supervisor ]     |
|----------------------------------------------------------------------|
| [ LTC3350 ] [ supercap bank 2S4P ] [ switch spade tabs / test pads ] |
|----------------------------------------------------------------------|
| [ J1 ][ J2 ][ J3 ]                                                   |
|______________________________________________________________________|
```

Rear / top edge features (`USB-C`, `BATT`) form the user-accessible external face. Front / bottom edge
features (`J1` / `J2` / `J3`) face inward toward the assembled machine and can be positioned to suit
service clearance rather than blind-mate dual-board insertion constraints.

---

## 6. Notes for Schematic / PCB Capture

1. Keep the `VIN_POE_12V` path electrically separate from the local USB-C and battery entries until the
   intended OR-ing node.
2. Keep `PM_IO_INT_N` routed as a clean low-speed logic net back to the Controller.
3. Apply the common RGB sink-stage pattern from `design/Standards/Global_Routing_Spec.md §3.1`
   to the PM runtime RGB path (`Q6` / `Q7` / `Q8`). The PM-specific pre-boot hardware flash path
   remains a local exception: red + green only through `Q4` and `D6` / `D7`; blue stays runtime-only.
4. Route `LED_PWR_N` from `J3` only into the local SW2 hardware-indicator logic; do not place it on the
   PM I2C expander. The SW2 red/green sink stages and shutdown latch remain fully local to the PM.
