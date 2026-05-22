## DEC-034 - Switch Hardware Refresh: Settings Board Toggle + Discrete RGB LED, Ruggedized PM SW1

- **Status:** Decided
- **Date:** 2026-04-16
- **Category:** Electrical / HMI / Mechanical interface
- **Area:** Settings Board; Power Module front-panel switchgear
- **Author:** Izzyonstage & GitHub Copilot

### Summary

Replace the old unified Marquardt rocker-switch assumption with two purpose-specific solutions:
E-Switch 200-series toggle switches plus discrete RGB LEDs on the Settings Board, and the Adafruit
4660 rugged metal RGB latching switch for Power Module SW1.

### Problem

The previous design direction forced the Settings Board and Power Module onto one shared switch
family even though the two locations serve different aesthetic, mechanical, and service roles. The
Settings Board benefits from classic toggle controls with separate indicators, while the Power Module
benefits from a sealed, rugged metal power switch with a more robust panel interface and
spade-terminal wiring.

### Decision

1. **Settings Board switch selection:** Use `200MSP1T2B4M2QE` for the 10 configuration toggles
   (`SW_B1[3:0]`, `SW_B2[5:0]`).
2. **Settings Board LED selection:** Use `WP154A4SEJ3VBDZGW/CA` for all 12 Settings Board indicators
   (10 config-bit indicators + 2 source-status indicators).
   - Kingbright 5mm common-anode RGB through-hole LED
   - Full RGB operation is available under CM5 control
   - Separate red, green, and blue series resistors per switch allow colour balancing under nominal 5V operation
3. **Settings Board LED topology update:** Change the indicator drive from the previous
   common-cathode / PNP sourcing concept to:
   - individual LED anode drive from `U2` / `U3`
   - per-bank red / green / blue shared cathode rails
   - low-side BSS138 sink devices on each bank colour rail
4. **Power Module switch selection:** Use Adafruit `4660` for `SW1`.
   - Latching rugged metal power switch
   - RGB ring illumination
   - 16mm panel cutout
   - 2.8mm pin terminals routed to PCB-mounted 2.8mm male spade tabs for serviceable harnessing

### Rationale

- The Settings Board now matches the machine's more period-correct control aesthetic better than a
  rocker-based panel.
- Separate LEDs give more freedom over indicator placement and future panel detailing than
  integrated illuminated switches.
- The Power Module switch benefits from a tougher sealed metal body and clearer power-switch
  identity than the previous shared-family concept.
- Breaking the false BOM unification removes a mechanical compromise that was not buying any real
  electrical simplification.

### Impact

- **Settings Board Design_Spec / Board_Layout:** switch type, LED type, and LED driver polarity all
  change
- **Consolidated BOM:** split the old shared rocker line into distinct Settings Board and Power
  Module entries
- **Power Module Design_Spec:** SW1 selection and harnessing updated to the rugged metal switch
- **Copilot handoff / component tracking:** the old Marquardt-all-13-switches assumption is retired
