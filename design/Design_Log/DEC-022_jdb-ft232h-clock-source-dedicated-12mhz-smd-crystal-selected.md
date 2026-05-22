## DEC-022 - JDB FT232H Clock Source: Dedicated 12MHz SMD Crystal Selected

- **Status:** Obsolete - superseded by DEC-037
- **Date:** 2026-04-06
- **Category:** Electrical
- **Area:** JTAG Daughterboard - Clock Source (FT232H)

### Decision

Dedicated 12MHz SMD passive crystal (Y1) on the JDB PCB. CM5 GPCLK0 option rejected.

### Context

During JDB detailed design review, two issues were identified:

1. The original design incorrectly specified a **24MHz HC-49 through-hole crystal**. The FT232H datasheet requires a **12MHz**
   reference - its internal PLL multiplies 12MHz x 40 to generate 480MHz for USB Hi-Speed operation. 24MHz is outside specification.
2. An alternative was considered: routing a clock from the **CM5 GPCLK0 output (GPIO4)** to the FT232H OSCI pin instead of a dedicated on-board crystal.

### Options Considered

| Option | Description | Verdict |
| :--- | :--- | :--- |
| A | CM5 GPCLK0 (GPIO4) routed through Controller hat-header to FT232H OSCI | **Rejected** |
| B | Dedicated 12MHz passive SMD crystal (Y1) on JDB PCB | **Selected** |

**Option A - Rejected reasons:**

- Signal path: CM5 GPIO4 → Controller board → hat-header pin → JDB OSCI is long and noise-prone
- GPIO clock jitter from BCM is unsuitable as a USB PLL reference clock
- Creates a CM5 boot-order dependency - FT232H cannot enumerate on USB until CM5 configures GPCLK0
- Adds routing and firmware complexity with no benefit over a $0.07 crystal

**Option B - Selected:**

- Standard FTDI reference design approach; clean stable clock source
- No boot dependency; FT232H enumerates immediately on USB connect
- Component: **YXC X322512MSB4SI** (JLCPCB C9002), SMD3225-4P, 12MHz, 20pF, ±20ppm, Basic part
- Crystal load capacitors: C10-C11 = 33pF C0G 0402 (sets 20pF load capacitance)

### Impact

- `design/Electronics/JTAG_Daughterboard/Design_Spec.md`: Y1 corrected to 12MHz SMD3225-4P (C9002); C10-C11 added; text references updated.
