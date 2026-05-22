## DEC-001 - 3V3_ENIG Used Throughout; 3V3_SYSTEM Removed from BtB Interconnect

- **Status:** Obsolete - superseded by DEC-037
- **Date:** 2025
- **Category:** Electrical
- **Area:** Power Module, Controller Board, Link-Alpha connector

### Decision

The `3V3_SYSTEM` rail (sourced from the CM5 on the Controller Board) is **not** routed to the Power Module over the Link-Alpha BtB connector. All 3.3V logic within the Power Module (RJ45 LED anodes,
I2C pull-ups, BATT_PRES_N pull-up, reset pull-up) is powered by `3V3_ENIG`, generated locally by the Power Module LDO (U7).

### Rationale

- `3V3_SYSTEM` is a CM5-derived rail intended only for external peripheral interfaces (Ethernet, HDMI, USB 3.0 ports). Using it to power internal power-module logic would create a cross-domain

  dependency and complicate sequencing.

- Generating `3V3_ENIG` locally on the Power Module gives a clean, independently-controlled 3.3V supply that is always present when the Power Module is powered, regardless of CM5 boot state.
- Removing `3V3_SYSTEM` from the Link-Alpha connector freed pins 21-24, which were reallocated to extend the 5V_MAIN delivery cluster and GND return path.

### Alternatives Considered

- Route `3V3_SYSTEM` from CM5 over Link-Alpha and use it for RJ45 logic. Rejected: cross-domain dependency, sequencing risk, wasted connector pins.
- Use a second small LDO on the Controller Board to produce a local 3.3V for CM5-adjacent logic. Rejected: unnecessary complexity given `3V3_ENIG` already exists.

### Impact

- Pins 21-22: Reassigned from 3V3_SYSTEM → **5V_MAIN** (supplemental power pins)
- Pins 23-24: Reassigned from 3V3_SYSTEM → **GND** (supplemental return path)
- Combined 5V_MAIN capacity: 18 pins x 0.5A = **9A** (was 16 pins = 8A)
- Legacy Controller probe-access concept Pin 14: Reassigned from 3V3_SYSTEM → **SW_LED_CTRL (GPIO 20)** (subsequently updated; see DEC-009)
