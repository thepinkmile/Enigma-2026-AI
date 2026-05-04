# Actuation Module Board Layout Visualisation

**Status:** Draft
**Project:** Enigma-NG
**Author:** Izzyonstage & GitHub Copilot
**Version:** v.0.1.0
**Associated Hardware Revision:** Rev A
**Last Updated:** 2026-04-26

## 1. Placement Intent

```text
TOP VIEW (L1 / component side / enclosed side; intended to mount upside-down from host board)
 ____________________________________
|[MH1]                               |
|                                    |
|                              [MH2] |
| [D1] <-- edge-visible status LEDs  |
| [D2]                               |
| [D3]    [ U1 LOCAL CONTROLLER ]    |
|        [C2][C3][C4] [C1][R4][C5]   |
|                                    |
|       [J1 AM HOST DOCK (DF40C)]    |
|                              [MH4] |
|                                    |
|[MH3]                               |
|____________________________________|
```

> **Mounting hole asymmetry:** MH1/MH3 (left pair) sit 7 mm from the left edge and 7 mm from the
> top/bottom edges - close to the left corners. MH2/MH4 (right pair) sit 7 mm from the right edge
> and 12 mm from the top/bottom edges - inset further from the right corners. Only one physical
> orientation aligns all four standoffs simultaneously. See DR-AM-03.

```text
BOTTOM VIEW (L4 / header-maintenance side / exterior face)
 ____________________________________
|                       [DATA-PLATE] |
| [J2 SERVO LOOM]                    |
|                           [J4 SWD] |
|                                    |
|                     [J5 UART/BOOT] |
|                         [SW1 NRST] |
|                        [SW2 BOOT0] |
| [J3 HOME LOOM]                     |
|____________________________________|
```

## 2. Layout Notes

* J1 is a single 20-pin Hirose DF40C-20DP-0.4V(51) plug centred on the connector-facing side, carrying
  power (`5V_MAIN`, `3V3_ENIG`) and the trigger signal (`ACTUATE_REQUEST_N`) on one connector. Four M2.5mm
  NPTH mounting holes with copper annular ring (MH1-MH4, `MountingHole_Pad` footprint, net = `GND`) mate with 3.5mm standoffs (9774035151R) on the host board.
* J2 and J3 are bottom-edge manual-fit Dupont-style headers. They are intentionally excluded from the
  automated PCBA flow.
* J4 and J5 are manual-fit service headers. J4 is the primary SWD header and J5 is the separate
  UART/bootloader header; place them near U1, keep them adjacent, and keep both accessible before the
  module is installed on its host board. SW1 and SW2 should sit directly beside J5 so the two-button
  UART bootloader action (`BOOT0` held while reset is pressed) can be done directly at the AM.
* The upside-down mounting is driven by the single-side PCBA rule: the DF40 plug and SMT components are
  assembled on the enclosed connector-facing side, while the manually fitted loom / service headers stay on
  the opposite side for post-PCBA fitting and service access.
* D1-D3 should stay on the PCBA-fitted side but be pushed to a visible board edge so the indicators can
  still be seen during maintenance without moving them onto the manual-fit side.
* The `ACTUATION_HOME_N` loom on J3 should use a twisted pair for pins 1-2 (`ACTUATION_HOME_N` + `GND`)
  because the loom is expected to run near the servo wiring.
* U1, C1, and R4 should stay close to J3 so the home input is biased and filtered at the module edge.
  J4, J5, SW1, and SW2 should also stay close to U1 so the SWD, UART, `BOOT0`, and `NRST` service
  lines remain short and unambiguous.
* C2-C3 should sit tight to the STM32 supply pins as local high-frequency decouplers. C4 should sit near
  the local `3V3_ENIG` entry / U1 supply region. C5 should sit near the `5V_MAIN` intake and servo loom
  region so the AM has a local short-burst current reservoir when the servo moves.
* C6 (100 nF NRST filter cap) shall be placed adjacent to U1's NRST pin. Keep the trace from U1 NRST to
  C6 and from C6 to GND as short as practicable to maximise noise suppression effectiveness.
* R5 (10 kΩ BOOT0 series protection resistor) shall be placed on the signal path between the SW2 / J5-pin-5
  shared node and the U1 BOOT0 pin. Place R5 in the J4/J5/SW1/SW2 service-header cluster so the service
  interconnect remains compact.
* Unlike the JDB, the AM is not purely a light logic daughterboard: it has both an MCU and a local servo
  power path. The AM therefore keeps the reduced daughterboard-capacitor approach, but adds an explicit
  5V local reservoir cap rather than relying only on upstream host-board bulk capacitance.
* **Connector orientation (DF40 polarity-free body):** The DF40 connector body can mate in two orientations
  (180° rotated). MH1-MH4 shall be placed in an asymmetric (non-square) pattern so that only one physical
  orientation of the AM aligns all four standoffs simultaneously. The silkscreen pin-1 triangle marker on
  both the AM and the host board shall indicate the correct mating direction (per
  `design/Standards/Global_Routing_Spec.md §7.1`). Pin 1 is defined as the
  top-left pin when the AM is viewed from its component side (connector-facing side) with the short
  standoff-pair edge on the left.
* Enclosed-side fitted parts must remain within the 2.0 mm installed-height rule from `Design_Spec.md`
  (DR-AM-11). The DF40 plug body height above PCB (~1.14 mm) satisfies this limit. The reviewed
  STM32G071K8T3TR LQFP32 package is 1.60 mm max height and the 0402 passives / LEDs are substantially
  lower.
* **Minimum board size guidance (non-binding):** The DR-AM-03 asymmetric mounting hole pattern implies a
  minimum board height of approximately **26 mm** (right-pair 12 mm insets x 2 plus 1 mm edge clearance
  each side) and a minimum board width of approximately **28 mm** (7 mm insets each side plus clearance
  for the DF40C connector body). These are guidance values only; final dimensions shall be confirmed at
  PCB layout stage.
* The module is electrically lightand mechanically non-load-bearing; the servo must not transfer
  structural load into the AM PCB or its host dock.
