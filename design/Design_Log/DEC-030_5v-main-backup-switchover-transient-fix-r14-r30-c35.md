## DEC-030 - 5V_MAIN Backup Switchover Transient Fix (R14, R30, C35)

- **Status:** Accepted
- **Date:** 2026-04-14
- **Category:** Electrical
- **Area:** Power Module - LTC3350 Backup Switchover, 5V_MAIN Bulk Capacitance

### Issue

At 3A load (CM5 typical draw), the existing 5V_MAIN bulk capacitance (C9=22µF + C10=22µF +
C13=10µF = 54µF total) provides only 2.59µs before PWR_GD deasserts
(54µF x 144mV / 3A). The LTC3350 at default 200kHz (5µs/cycle) gets only 0.52 cycles
to complete backup switchover - INSUFFICIENT.

### Root Cause Analysis

- Old R14 = 28.7kΩ → backup threshold = 4.644V; PWR_GD deassert = 4.50V; gap = 144mV
- LTC3350 RT=INTVCC (no resistor) = 200kHz → 5µs/cycle
- 54µF x 144mV / 3A = 2.59µs = 0.52 cycles → FAILS

### Fix (three combined changes)

1. **R14: 28.7kΩ → 30.1kΩ** - raises backup threshold to 4.812V; new gap = 312mV
2. **R30: new 33.2kΩ resistor** (LTC3350 RT pin to GND) - sets switching frequency to 400kHz (2.5µs/cycle)
3. **C35: 2x Samsung CL32B226KAJNNNE** (22µF 25V X7R 1210) in parallel = 44µF additional bulk on 5V_MAIN

### Result with Fix

- Total bulk = 54µF + 44µF = 98µF
- Time window = 98µF x 312mV / 3A = **10.2µs**
- Cycles at 400kHz = 10.2µs / 2.5µs = **4.1 cycles ✔**
- False-trigger headroom: 5Vx0.98 - 4.812V = 88mV (LTC3350 ~12µs deglitch filters brief dips)

### Component Selection Rationale for C35

- **Selected: 2x Samsung CL32B226KAJNNNE** (22µF 25V X7R 1210, existing BOM part)
  - ESR ≈ 10mΩ (negligible, stable -55°C to +125°C)
  - Uses existing qualified BOM part - no new component qualification needed
  - 4.1 cycles margin at all operating temperatures
- Evaluated and rejected: HZA107M025X16T-F (CDE hybrid polymer-Al, 30mΩ ESR, 4.56 cycles at
  +20°C but marginal 2.1 cycles at -40°C - not selected as existing BOM part is sufficient)
- Evaluated and rejected: KEMET T495X107K025ATA150 (MnO₂ tantalum, 150mΩ ESR - V_ESR = 450mV
  at 3A, EXCEEDS entire 312mV budget; also MnO₂ tantalum short-circuit failure mode is unsafe
  in low-impedance power supply)

### No Change Required To

- eFuse (HV input side)
- LDO TPS75733 (stays in regulation)
- MIC1555/R28/C32 (3.01s timing unchanged)
