## DEC-025 - CM5 Shutdown Mechanism: Hardware-Driven; LTC3350 Software Support Deferred

- **Status:** Deferred - Software PoC Stage
- **Date:** 2026-04-09
- **Category:** Software
- **Area:** Software / Linux OS - CM5 Power Management Shutdown Path

### Decision

The final implementation of the CM5 graceful shutdown mechanism is **hardware-driven** via the
LTC3350 `/INTB` -> MIC1555 U15 -> Q5 BSS138 -> `PWR_BUT` one-shot path. Any LTC3350 software
support is deferred to the **Software PoC stage**, pending hardware availability for integration
testing, and is limited to I2C telemetry / LED-state handling rather than a dedicated interrupt pin.

The PWR_GD GPIO (GPIO 27, MCP121T-450E output) is rail-health telemetry only and does NOT trigger shutdown. It is a CM5 input that reads HIGH while 5V_MAIN ≥ 4.50V.

### Rationale

- The shutdown path is already covered by hardware, so no Linux interrupt path or device-tree
  mapping is required for safe power-off behaviour.
- Any future software support can read LTC3350 status over I2C without consuming another
  dedicated CM5 GPIO.
- Driver or service development still requires the physical hardware to be available for testing
  and validation.
- The system is designed for operational sessions of 15-30 minutes or longer. The hold-up window
  (≥33.5 s) is a generous safety margin; an unplanned shutdown from a fully-charged state is expected
  to be harmless. Deferring the driver to the PoC stage does not create a risk for hardware bring-up.
- Placeholder notes in design/Software/Linux_OS/Power_Management.md document the intended
  telemetry behaviour for reference; they are not a binding software specification.

### Impact

- design/Software/Linux_OS/Power_Management.md keeps the deferred LTC3350 telemetry notes but
  removes any requirement for a dedicated `/INTB` GPIO or device-tree interrupt mapping.
- The active hardware protection path is the LTC3350 /INTB → MIC1555 U15 → Q5 BSS138 →
  PWR_BUT one-shot circuit (3.01 s LOW pulse), which requires no software driver.
