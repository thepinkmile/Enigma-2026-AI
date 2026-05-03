# Main Enclosure Mechanical Design Specification

**Status:** Stub - pending detailed mechanical design
**Project:** Enigma-NG
**Author:** Izzyonstage & GitHub Copilot
**Version:** v.0.1.0
**Associated Hardware Revision:** Rev A
**Last Updated:** 2026-04-20

## Overview

Mechanical design specification for the main Enigma-NG enclosure. This encompasses the physical
housing of the Controller Board, Stator Board, rotor stack, the **Keyboard
Assembly**, the **Lightboard Assembly**, and the user-accessible User Settings Module
panel switches.

Content to be populated during detailed mechanical design phase.

## Panel Cutout Requirements

### User Settings Module - Configuration Switch Panel

The right side of the enclosure **top face**, positioned near the rotor stack, must provide panel
cutouts for the 12 User Settings Module toggle switches, 12 matching RGB indicator LEDs, and 1 CFG_APPLY
pushbutton.

| Feature | Quantity | Location | Notes |
| :--- | :---: | :--- | :--- |
| Toggle switch cutouts (Bank 1 - Plugboard Routing) | 5 | Right side, top face, near rotors | Bank 1 enable + SW_B1[3:0] - panel-mount SPDT toggle |
| Toggle switch cutouts (Bank 2 - Reflector Mapping) | 7 | Right side, top face, near rotors | Bank 2 enable + SW_B2[5:0] - panel-mount SPDT toggle |
| RGB LED apertures (Bank 1 indicators) | 5 | Adjacent to Bank 1 toggles | One 5mm indicator LED per switch position |
| RGB LED apertures (Bank 2 indicators) | 7 | Adjacent to Bank 2 toggles | One 5mm indicator LED per switch position |
| CFG_APPLY actuator cutout | 1 | Right side, top face | Opening for a mechanical actuator/plunger that presses the User Settings Module's internal momentary tactile switch; triggers CPLD config re-latch |

The User Settings Module PCB mounts internally to the enclosure panel, with the toggles and LEDs
protruding through their panel cutouts. CFG_APPLY may instead use an internal board-mounted tactile
switch with a simple actuator/plunger through the panel opening. The board connects to the Stator
Board via a 6-wire JST PH harness (`3V3_ENIG`, `5V_MAIN`, `GND`, `SDA`, `SCL`, `GND`), with
`5V_MAIN` feeding the User Settings Module RGB indicator rail. Final toggle-hole, LED-hole, and stand-off
/ spacer geometry are to be defined at detailed mechanical design phase based on the selected parts.

See `design/Electronics/User_Settings_Module/Design_Spec.md` for the electrical specification of the
User Settings Module.

### Lid Display - Optional Touchscreen Add-on

The machine lid must be designed to accommodate an optional touchscreen display add-on (see DEC-033).
Specific mounting dimensions are deferred pending display size selection (up to 10" supported via DSI1).
The following provisions must be made at detailed mechanical design phase:

| Feature | Notes |
| :--- | :--- |
| Display aperture in lid | Sized for chosen display (TBD - up to 10"); flush-mount or recessed bezel |
| Display mounting frame / bracket | Secures display panel against lid inner face |
| FPC hinge routing | Clear path for DSI1 FPC cable from lid through hinge to Controller Board J9 |
| Deferred display auxiliaries | No separate display power or touch harness is fixed yet; reserve hinge space beyond the `J9` FPC path only as future margin until the display add-on is defined |

See `design/Electronics/Controller/Design_Spec.md` (J9) and `design/Electronics/User_Settings_Module/Design_Spec.md` for electrical context.

## Cross-References

| Document | Description |
| :--- | :--- |
| `design/Electronics/Controller/Design_Spec.md` | Controller Board electrical specification |
| `design/Electronics/Controller/Design_Spec.md` | Controller Board - DSI1 connector J9 for lid display |
| `design/Electronics/Stator/Design_Spec.md` | Stator Board electrical specification - includes I²C interface to User Settings Module |
| `design/Electronics/User_Settings_Module/Design_Spec.md` | User Settings Module electrical specification - panel switch and LED expanders |
| `design/Mechanical/Keyboard_Assembly/Design_Spec.md` | Independent keyboard sub-assembly mounted into the enclosure |
| `design/Mechanical/Lightboard_Assembly/Design_Spec.md` | Independent lightboard sub-assembly mounted into the enclosure |
| `design/Mechanical/Complete_System_Assembly/Design_Spec.md` | Complete system assembly including all sub-assemblies |
