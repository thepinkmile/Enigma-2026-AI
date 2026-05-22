## DEC-044 - FDC2114 Internal Oscillator Selected (CLKIN → GND)

- **Status:** Decided
- **Date:** 2026-04-26
- **Category:** Electrical / Component configuration
- **Area:** Rotor Board, capacitive position sensing, FDC2114 clock source
- **Author:** Izzyonstage & GitHub Copilot

### Summary

The FDC2114 on every Rotor Board uses its **internal oscillator** as the conversion clock.
The `CLKIN` pin is tied permanently to GND on the PCB. The `CHx_FIN_SEL` field in each channel's
`SETTLECOUNT` register is set to `0b10` (internal oscillator reference).

### Problem

The FDC2114 supports two clock sources: an external crystal/oscillator on CLKIN, or the internal
~43.35 MHz oscillator activated when CLKIN is tied to GND. A decision was required on which to
use for the Rotor sensing application.

### Decision

Use the FDC2114 internal oscillator (CLKIN → GND). This means:

1. No external crystal or oscillator component on the Rotor PCB.
2. `CHx_FIN_SEL = 0b10` in all active channel `SETTLECOUNT` registers.
3. Conversion reference clock frequency ≈ 43.35 MHz (internal specification).
4. CPLD I²C master (VHDL bitstream) configures this field at power-up.

### Rationale

- Avoids an external crystal BOM cost and the associated PCB footprint on a space-constrained
  circular board (Ø92mm with CPLD, FDC2114, sensor electrodes, DIP switches, and connectors).
- The internal oscillator frequency (~43.35 MHz) is well above the ~6.5 MHz nominal resonant
  frequency of the LC tank (18 µH + 33 pF), satisfying the FDC2114 requirement for the
  conversion clock to be >4x the sensor resonant frequency.
- Absolute frequency accuracy of the conversion clock is not critical for this application.
  Gray-code position detection requires only relative threshold crossing detection (presence or
  absence of an aluminium shroud slot), not absolute frequency measurement.
- Confirmed viable by TI FDC2114 datasheet §8 (internal oscillator specification) and TI
  FDC2114 application note guidance.

### Alternatives Considered

| Alternative | Reason rejected |
| :--- | :--- |
| External crystal on CLKIN | Additional BOM line, PCB footprint, and layout complexity; not needed for this sensing application |
| External clock oscillator module | Same objections as crystal; adds cost and board area |

### Impact

- Rotor Board PCB: CLKIN tied to GND; no crystal footprint required.
- CPLD VHDL: set `CHx_FIN_SEL = 0b10` in `SETTLECOUNT` register for all active channels at
  power-up initialisation.
- `design/Electronics/Rotor/Design_Spec.md`: Resonant Front-End Topology subsection updated.
- `design/Software/CPLD_Logic/Rotor_Logic.md`: FDC2114 register map documents this setting.

### Cross-ref

`design/Electronics/Rotor/Design_Spec.md`,
`design/Software/CPLD_Logic/Rotor_Logic.md`,
`design/Procedures/Lab_Tests.md` (LT-001, LT-002).
