# Enigma-NG Power Budgets

**Status:** Draft
**Version:** v.0.1.0
**Associated Hardware Revision:** Rev A
**Last Updated:** 2026-04-20

---

## Design Constraint Hierarchy

1. **TPS75733KTTRG3 LDO** (Power Module U7): **3.0A maximum output** - hard limit, component not to be changed.
2. **PM dock `J1` 3V3_ENIG allocation:** `2 x 3V3_ENIG` contacts at 6A/contact - comfortably above the LDO limit.
3. **Stator dock `J5` 3V3_ENIG allocation:** `4 x 3V3_ENIG` large blades plus additional guarded-return capacity - connector is not the bottleneck, the LDO is.
4. **Available to Stator + Rotor stack:** LDO output minus Controller-local consumption (CM5 GPIO reference, pull-ups, and local housekeeping) ≈ 2.95A (Controller overhead ≤ 50mA).

---

## 3V3_ENIG Load Analysis

### Per-Device Current (Intel MAX II EPM570T100I5N [Encoder x6, Rotor x30, Stator x1] @ 3.3V)

| Operating condition | ICC (core) | Source |
| :--- | :--- | :--- |
| Static (no switching) | ~5 mA | Intel MAX II Datasheet ICC_STATIC |
| Typical cipher logic (50 MHz toggle) | ~25 mA | Intel MAX II Power Estimator (50% toggle, 50% resource use) |
| Worst-case (100 MHz, 80% resource use) | ~80 mA | MAX II Datasheet ICC_DYNAMIC worst case |

**Design value used:** 50 mA per CPLD (conservative typical - accounts for VHDL cipher switching without
being an unachievable worst-case peak).

### Per-Device Current (TI FDC2114RGHR Capacitive Sensor IC @ 3.3V)

| Condition | ICC |
| :--- | :--- |
| Active | 2.1 mA typ |

---

## 3V3_ENIG Allocation Table

| Consumer | Count | Per-unit (mA) | Total (mA) | Notes |
| :--- | :---: | :---: | :---: | :--- |
| Stator CPLD (U1, EPM570T100I5N) | 1 | 50 | 50 | JTAG forwarding + ENC signal routing |
| HID Encoder CPLDs (EPM570 x2) | 2 | 50 | 100 | Keyboard encode + lightboard decode CPLDs |
| Plugboard Encoder A CPLDs (EPM570 x2) | 2 | 50 | 100 | Stecker pass A encode/decode pair |
| Plugboard Encoder B CPLDs (EPM570 x2) | 2 | 50 | 100 | Stecker pass B encode/decode pair |
| FT232H VCCIO (JTAG Module) | 1 | 10 | 10 | VCCIO domain only; VCC (100 mA) is 5V_USB-sourced - see 5V_MAIN table |
| Rotor CPLDs (EPM570T100I5N x30) | 30 | 50 | 1500 | All rotors cipher-active simultaneously |
| Rotor FDC2114RGHR capacitive sensor ICs (U2/U3 or U2/U4, 2 ICs per rotor, 60 ICs total) | 60 | 2.1 | 126 | Continuous position polling; two ICs per rotor add 4.2 mA to the 50 mA CPLD budget, giving 54.2 mA typ / 55 mA budget per rotor |
| INA219 current monitor (Stator) | 1 | 1 | 1 | Negligible |
| INA219 current monitor (Power Module) | 1 | 1 | 1 | Negligible |
| Stator GPIO expanders (MCP23017 x3) | 3 | 10 | 30 | `U6`, `U7`, `U8` on shared `I2C-1`; monitor / control overhead only |
| Controller direct servo GPIO interface | - | - | Included in Controller-local housekeeping | Servo PWM / home sensing moved to direct CM5 GPIO on the Controller |
| PM-local GPIO expander (PCA9534A x1) | 1 | 5 | 5 | `U14 @ 0x3F`; PM status + SW1 runtime RGB handoff control |
| User Settings Module GPIO expanders (MCP23017 x3) | 3 | 25 | 75 | `U1`, `U2`, `U3` on the shared Stator `I2C-1` bus |
| Extension Buffer ICs (SN74LVC2G125DCUR) | 5 | 2 | 10 | TCK/TMS re-drive for each 5-rotor group; one per Extension board; negligible load |
| Controller-local housekeeping | - | - | 50 | Controller overhead subtracted before Stator distribution |
| **Typical total** | | | **2,163 mA** | |
| **Rounded budget** | | | **≤ 2.17 A** | |

### Headroom vs LDO Limit

| Limit | Value | Margin |
| :--- | :--- | :--- |
| LDO hard limit | 3.00 A | - |
| Typical worst-case load | 2.17 A | **+0.83 A (28%)** |
| Controller↔Stator dock capacity | Above 3.00 A | Not the constraint |

> ✔ **Conclusion:** The 3A TPS75733KTTRG3 LDO provides ~28% headroom above the full downstream
> worst-case typical load.
> No LDO upgrade is required for the current 30-rotor design.
> **Telemetry note:** The Stator INA219 / shunt path still measures the rotor-stack distribution branch
> at about **2.05 A typical**. The extra **75 mA** above that figure is the User Settings Module's local logic
> load on the shared `3V3_ENIG` rail.

---

## 3V3_ENIG Conflict Resolution

### STA-05 / STA-06: Shunt resistor and power figure reconciliation

| Document | Old figure | Resolved value | Action |
| :--- | :--- | :--- | :--- |
| Stator §2 "5A peak" | 5.0 A | **2.05 A** worst-case typical | ✔ Complete - Stator §2 updated to 2.05A worst-case typical; 5A figure retired |
| Controller↔Stator dock capacity | 5.5 A | Not the bottleneck - hybrid Molex dock remains above the 3.0 A LDO limit | ✔ Complete - Samtec Link-Beta constraint retired by DEC-038 |
| Rotor x30 claim "4.5A" | 4.5 A | **1.65 A** (30 x 55 mA budget; 1.63 A typ) | ✔ Complete - Rotor DR-ROT-06 and §3.1 now use the 54.2 mA typical / 55 mA budget figure; 150 mA figure retired |
| Shunt resistor | Stator: 20 mΩ, Controller: 10 mΩ | **10 mΩ CSS2H** (Stator R1 = CSS2H-2512R-R010ELF; Controller has no shunt) | ✔ Complete - Stator R1 updated to CSS2H-2512R-R010ELF (10mΩ, 2512 Kelvin) |

**INA219 shunt selection rationale (10 mΩ CSS2H-2512R-R010ELF):**

* V_drop at 2.05A: 2.05 x 0.010 = **20.5 mV** - within INA219 ±80 mV PGA range.
* V_drop at 3.00A max: 3.00 x 0.010 = **30 mV** - within ±80 mV range.
* Resolution: with 12-bit ADC at ±80 mV range, LSB = 2x80mV/4096 ≈ **39 µV/LSB** → I_LSB = 39µV/0.010Ω ≈ **4 mA** current resolution.
* Power dissipation at 2.05A: 2.05² x 0.010 = **42 mW** - 2512 Kelvin package (rated ≥0.5W) is adequate with >10x margin.
* Power dissipation at 3.00A max: 3.00² x 0.010 = **90 mW** - 2512 Kelvin package ≥0.5W still OK.
* CAL register: 0x0400 (1024) - unchanged. CAL = 0.04096 / (Current_LSB x R_SHUNT) = 0.04096 / (0.004 x 0.010) = 1024 ✔
* Part: CSS2H-2512R-R010ELF (Bourns 2512 Kelvin-sense, 10mΩ ±1%, 5A). Used on **PM R10** (LTC3350 RSENSE), **PM R16** (INA219 U10, 0x40, 5V_MAIN monitoring) and **Stator R1**
  (INA219 U2, 0x45, rotor-stack monitoring).
  Total build qty: 3.

---

## 5V_MAIN Load Analysis

| Consumer | Current | Notes |
| :--- | :--- | :--- |
| CM5 (Raspberry Pi Compute Module 5) | 5.0 A max | CM5 boot-to-load current profile; 25W at 5V = 5A |
| 3V3_ENIG LDO quiescent (TPS75733KTTRG3) | 2.05 A | Sourced from 5V_MAIN; P_in = 5V x 2.05A = 10.25W |
| Status LEDs, RJ45, misc. | 0.1 A | |
| FT232H VCC (JTAG Module - via Controller TPS2065C) | 0.1 A | USB HS active; VCC from 5V_USB (TPS2065C-protected 5V_MAIN output) |
| USB 3.0 external devices (TPS2065C rated max) | 1.60 A | System boundary: connected USB device load; TPS2065C hard-limits output |
| HDMI sink device | 0.05 A | System boundary: connected HDMI sink; AP2331W-limited |
| User Settings Module indicator rail (via Controller↔Stator dock → J13) | 0.24 A | 12 indicators, one active colour per bank, 240mA max |
| Controller-local servo rail (via Controller J11) | 0.50 A | Budgeted Controller-side servo allocation |
| **Total 5V_MAIN worst case (system boundary)** | **9.50 A** | |
| **LMQ61460-Q1 dual-phase capacity** | **12.0 A** | 79.2% utilisation (9.50/12.0) ✔ |

> **Scope note:** The 7.40 A board-level budget (internal consumers: CM5 + LDO + misc + FT232H) covers internal consumers only.
> External device loads (USB 3.0 + HDMI) plus the Stator-fed User Settings Module load and the Controller-local servo load add 2.39 A, giving a system total of 9.50 A.
> Component utilisation figures (e.g. LMQ61460-Q1) are calculated against the 9.50 A system total.
>
> **Stator dock 5V margin:** The Stator-facing 5V branch uses four large `5V_MAIN` blades on the
> dedicated Molex `J4` dock, with additional return capacity in the companion ground blades / guards.
> The current downstream budget remains **0.74 A**, so the dock is not the limiting factor for
> Stator-side 5V peripherals.

---

## Document History

| Date | Change |
| :--- | :--- |
| 2026-04-05 | Initial document - created to resolve STA-05/STA-06/ROT-04/PM-05 inconsistencies |
