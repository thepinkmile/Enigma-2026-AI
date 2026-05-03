# Complete System Assembly - Mechanical Design Specification

**Status:** Draft
**Project:** Enigma-NG
**Author:** Izzyonstage & GitHub Copilot
**Version:** v.0.1.0
**Associated Hardware Revision:** Rev A
**Last Updated:** 2026-04-26

## Overview

This is the top-level General Assembly document for the Enigma-NG machine. It defines the complete
set of mechanical and electromechanical components that constitute the finished machine and provides
the authoritative assembly sequence guidance for build and maintenance activities.

All sub-assembly details, tolerances, and part-level instructions are contained in the
sub-assembly documents listed in §3. This document provides the integration view: what assembles
where, in what order, and with what dependencies.

## Component Index

The following table lists every component category present in the assembled machine.

| Category | Qty | Description | Sub-Assembly Document |
| :--- | :--- | :--- | :--- |
| Rotors | 30 | Individual rotor modules (shroud, bearings, encoder slots, ERM8 male headers) | `Rotor/Design_Spec.md` |
| Stator Board | 1 | PCB backplane: rotor stack, JTAG hub, encryption routing, I²C expanders | `Stator/Design_Spec.md` (Electronics) |
| Rotor Actuation Assembly | 1 | Depression bar, pivot lever, actuation arm, sprung retention bar, main servo mechanism | `Rotor_Actuation_Assembly/Design_Spec.md` |
| Actuation Module | 1-6 | Shared local servo-control PCB: 1 on Controller, plus 1 on each fitted Extension | `design/Electronics/Actuation_Module/Design_Spec.md` |
| Keyboard Assembly | 1 | Keyboard panel, key-switch harness, Encoder Module (`KBD_ENC`) | `Keyboard_Assembly/Design_Spec.md` |
| Lightboard Assembly | 1 | Lightboard panel, indicator harness, Encoder Module (`LBD_DEC`) | `Lightboard_Assembly/Design_Spec.md` |
| Plugboard Assembly | 1 | Two plugboard passes, four Encoder Modules, patch cables | `Plugboard_Assembly/Design_Spec.md` |
| Reflector | 1 | Mandatory passive turnaround sub-assembly; reflection mapping is owned by the Stator CPLD | `Reflector/Design_Spec.md` |
| Extension (optional) | 0-N | Extension board for multi-stack rotor configurations | `Extension/Design_Spec.md` |
| Power Module | 1 | Standalone power supply sub-assembly (LTC3350, eFuse, INA219, supercaps) | `Power_Module/Design_Spec.md` |
| Controller Board | 1 | CM5 carrier board (CM5 module, JDB hat, PM dock, Stator dock, Ethernet / PoE entry, Actuation Module host interface) | `Controller/Design_Spec.md` (Electronics) |
| Main Enclosure | 1 | Chassis, panels, cable routing, EMI bonding, fan | `Main_Enclosure/Design_Spec.md` |
| Servo Motor | 1-6 | Miuzei Metal Gearbox 90 (5V, 3-pin), one per fitted Actuation Module | `Rotor_Actuation_Assembly/Design_Spec.md` |
| Actuation Home Switch | 1-6 | SPST NO momentary (Omron SS-01GL13 or equivalent), one per fitted Actuation Module | `design/Electronics/Actuation_Module/Design_Spec.md` |
| User Settings Module | 1 | Panel-mount configuration switch PCB (12x SPDT toggles, 12x discrete RGB indicators, + CFG_APPLY button); mounts to right side top face of Main Enclosure; connects to Stator via I²C ribbon | `User_Settings_Module/Design_Spec.md` (Electronics) |
| Cable Harnesses | TBD | 20-pin encoder IDC ribbons, reflector cable, fan cable, User Settings Module I²C ribbon, switch / battery harnesses | Each sub-assembly doc |
| Connectors | TBD | TE PM dock, Molex Stator dock, ERF8/ERM8 rotor-family BtB, JST PH servo, JST SH fan, 20-pin IDC encoder, etc. | Per sub-assembly BOM |

## Assembly Sequence Overview

The following is the recommended assembly order for a complete machine build. Sub-assembly build
steps are detailed in each referenced document; this section defines integration dependencies only.

| Step | Sub-Assembly | Notes |
| :--- | :--- | :--- |
| 1 | Power Module | Standalone build; test on bench before integration. Delivers 5V_MAIN and 3V3_ENIG. |
| 2 | Stator Board | Install ICs (CPLD, MCP23017 x3, INA219), passives, connectors. Bench-test I²C expanders before stack assembly. |
| 3 | Rotors (x30) | Build all 30 rotor modules. Verify ERM8 header alignment and encoder slot clearance before stacking. |
| 4 | Rotor groups onto Stator | Press Rotor 1 ERM8 headers into Stator ERF8 sockets. Build the first 5-rotor group, then insert an Extension before each further 5-rotor group as required. Verify JTAG daisy-chain continuity at each group boundary. |
| 5 | Rotor Actuation Assembly | Install depression bar, pivot lever, actuation arm, sprung retention bar. Fit the Controller-local Actuation Module and connect its servo and home-switch looms. |
| 6 | Keyboard Assembly | Build keyboard panel + `KBD_ENC` Encoder Module. Connect IDC ribbon to the Stator keyboard encoder port. |
| 7 | Lightboard Assembly | Build lightboard panel + `LBD_DEC` Encoder Module. Connect IDC ribbon to the Stator lightboard decoder port. |
| 8 | Plugboard Assembly | Build both plugboard passes. Connect IDC ribbons to the four Stator plugboard ports (`PLG_PASS1_DEC`, `PLG_PASS1_ENC`, `PLG_PASS2_DEC`, `PLG_PASS2_ENC`). |
| 9 | Reflector | Install the mandatory passive Reflector sub-assembly at the far end of the final rotor group. Connect the 20-pin cable to Stator J10. Reflection-map selection remains Stator-CPLD-owned. |
| 10 | Extension (if used) | Insert each Extension between 5-rotor groups: `Stator -> 5 rotors -> [Extension -> 5 rotors]* -> Reflector`. Each Extension reinjects clean `3V3_ENIG`, carries the reflector-boundary service harness including grouped `5V_MAIN`, and hosts one local Actuation Module for the next group-boundary carry handoff. |
| 11 | Controller Board + JDB Hat | Install JDB hat on Controller. Mount Controller in Main Enclosure. Engage the TE PM dock cluster (`J1/J2/J3`) to the Power Module, then mate the Molex Stator dock pair (`J4/J5` ↔ `J11/J12`). |
| 12 | User Settings Module | Mount User Settings Module PCB to Main Enclosure right side top panel. Route the 6-wire harness (`3V3_ENIG`, `5V_MAIN`, `GND`, `SDA`, `SCL`, `GND`) to Stator J13. Verify `U1`, `U2`, and `U3` appear on the shared I²C bus, then run a functional check that reads switch-state changes and drives each bank's RGB indicator rails before final panel closure. |
| 13 | Main Enclosure final assembly | Route all cable harnesses. Install panels. Fit fan. Secure EMI bonding. Final torque fasteners. |

> **Note on the JTAG Daughterboard (JDB):** The JDB is a PCB hat that mounts directly on the
> Controller Board. It has no independent mechanical assembly step - it is installed as part of
> Step 10 (Controller Board install) before the Controller is fitted in the Main Enclosure.
> See `design/Electronics/JTAG_Daughterboard/Design_Spec.md` for electrical details.
>
## Sub-Assembly Reference Table

| Sub-Assembly | Document | Status |
| :--- | :--- | :--- |
| Main Enclosure | `Main_Enclosure/Design_Spec.md` | Draft |
| Rotor Actuation Assembly | `Rotor_Actuation_Assembly/Design_Spec.md` | Draft |
| Rotor | `Rotor/Design_Spec.md` | Draft |
| Keyboard Assembly | `Keyboard_Assembly/Design_Spec.md` | Draft |
| Lightboard Assembly | `Lightboard_Assembly/Design_Spec.md` | Draft |
| Plugboard Assembly | `Plugboard_Assembly/Design_Spec.md` | Draft |
| Power Module | `Power_Module/Design_Spec.md` | Draft |
| Extension | `Extension/Design_Spec.md` | Draft |
| Reflector | `Reflector/Design_Spec.md` | Draft |
| User Settings Module | `design/Electronics/User_Settings_Module/Design_Spec.md` | Draft |

## Cross-References

| Document | Description |
| :--- | :--- |
| `design/Electronics/User_Settings_Module/Design_Spec.md` | User Settings Module electrical specification - panel switches, LED expanders, I²C interface |
| `design/Electronics/Stator/Design_Spec.md` | Stator Board electrical specification - J13 I²C connector to User Settings Module |
| `design/Mechanical/Main_Enclosure/Design_Spec.md` | Main Enclosure - User Settings Module panel cutout requirements |
| `design/Guides/Maintenance_Guide.md` | Maintenance procedures referencing assembly steps |
| `design/Guides/User_Manual.md` | User-facing assembly and operation guide |
