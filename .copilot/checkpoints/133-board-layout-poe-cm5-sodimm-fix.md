# Checkpoint 133 — Board Layout PoE/CM5 Additions; SO-DIMM Terminology Fixed

## Overview

Board_Layout.md for the Controller board was extended with two new sections covering
components added during prior sessions (the PoE ACF front-end and CM5 carrier area).
Terminology errors using "SO-DIMM" to describe the Amphenol CM5 carrier sockets were
corrected across both the Board_Layout.md and Design_Spec.md.

## Work Done

### design/Electronics/Controller/Board_Layout.md
- "Last Updated" updated to 2026-05-09
- **§7 added:** CM5 Module Carrier (J14/J15 — Amphenol `10164227-1004A1RLF` carrier sockets;
  MH13–MH16 — 9774040151R 4.0mm SMT standoffs; 4.0mm stack height; 2.0mm height restriction
  under CM5 shadow; GND net for standoff pads; cross-ref to Design_Spec §2.3)
- **§8 added:** PoE ACF Front-End Placement (component summary table for T1/U7/U8/Q1/Q2/L1/C17/C20;
  DPAK thermal notes; switching loop minimisation; T1 solder bridge caveat; L1 orientation;
  C17 clamp node proximity; C20 2×2 parallel grid)
- SO-DIMM removed from §7 section heading and §7.1 part description

### design/Electronics/Controller/Design_Spec.md
- DR-CTL-02: removed "(SO-DIMM form factor)" — CM5 does not use a generic SO-DIMM connector
- §2.3: "CM5 SO-DIMM sockets" → "Amphenol CM5 carrier sockets"
- BOM J14-J15 Part Spec: "CM5 SO-DIMM 100-pin 4mm" → "100-pin CM5 carrier socket 4.0mm stack height"
- BOM U1 Part Spec: "CM5 module SO-DIMM" → "CM5 module"

## Technical Notes

- J14/J15 are specifically Amphenol `10164227-1004A1RLF` carrier sockets — not generic SO-DIMM
- 4.0mm stack height leaves 2.0mm clearance under the CM5 module; passives only in that zone
- MH13–MH16 pads connect to `GND` (not `GND_CHASSIS`) per Global Routing Spec
- C17 must be 200V rated (C0805C223K2RACAUTO); 100V X7R parts derate below minimum at primary voltage
- C20: 4× 47µF 2220 in 2×2 grid = 188µF nominal; ≥103µF worst-case
- L1 DCR exception: PA4343.333NLT typ 48mΩ compliant, max 58mΩ accepted per DEC-063

## Files Modified

- `design/Electronics/Controller/Board_Layout.md`
- `design/Electronics/Controller/Design_Spec.md`
