# Rotor CPLD Logic Requirements - FDC2114 Configuration

**Status:** Draft
**Project:** Enigma-NG
**Author:** Izzyonstage & GitHub Copilot
**Version:** v.0.1.0
**Associated Hardware Revision:** Rev A
**Last Updated:** 2026-04-26

## 1. Overview

This document defines the CPLD logic requirements and FDC2114 register configuration for the
Rotor Board capacitive position sensing subsystem. The Intel MAX II `EPM570T100I5N` CPLD acts as
the I²C master on the J9 bus and is responsible for configuring all FDC2114 devices at
power-up and reading their conversion results to produce the Gray-coded position output.

Board-level connector ownership, physical placement, and BOM authority remain in:

- `design/Electronics/Rotor/Design_Spec.md`
- `design/Electronics/Rotor/Board_Layout.md`

### 1.1 FDC2114 Firmware Note

The FDC2114 is a **hardware converter** and has **no user-programmable firmware**. All register
configuration is performed at runtime by the CPLD I²C master via VHDL bitstream. No UART
programming header is present on the Rotor board. The JTAG daisy-chain programs the CPLD only.

---

## 2. FDC2114 Register Configuration

The CPLD initialises each FDC2114 on the J9 bus immediately after power-up via I²C. All
multi-channel devices (U2, and where populated U3/U4) receive the same baseline register map.

### 2.1 Register Map (Baseline)

| Register | Address | Value (hex) | Field / Setting | Notes |
| :--- | :--- | :--- | :--- | :--- |
| `DRIVE_CURRENT_CH0` | 0x1E | 0x7C00 | `IDRIVE = 0b01111`, `INIT_DRIVE = 0b0` | Baseline drive current - lab validate (**LT-001**) |
| `DRIVE_CURRENT_CH1` | 0x1F | 0x7C00 | As above | All channels same baseline |
| `DRIVE_CURRENT_CH2` | 0x20 | 0x7C00 | As above | All channels same baseline |
| `DRIVE_CURRENT_CH3` | 0x21 | 0x7C00 | As above | All channels same baseline |
| `MUX_CONFIG` | 0x1B | 0x020D | `DEGLITCH = 0b101` (10 MHz), `AUTOSCAN_EN = 1`, `RR_SEQUENCE = 0b01` (CH0-CH1) | Adjust `RR_SEQUENCE` per active channel count; deglitch lab validate (**LT-002**) |
| `CONFIG` | 0x1A | 0x1601 | `ACTIVE_CHAN = 0b00` (start CH0), `SLEEP_MODE_EN = 0`, `RP_OVERRIDE_EN = 0`, `SENSOR_ACTIVATE_SEL = 1` | Continuous conversion, internal oscillator active |
| `RESET_DEV` | 0x1C | 0x8000 | Full device reset | Issue once on power-up before writing other registers |

> **`CHx_FIN_SEL` note:** The FDC2114 `CHx_FIN_SEL` field in each channel's `SETTLECOUNT`
> register must be set to `0b10` (single-ended, internal oscillator as reference clock) for all
> channels. This routes the internal ~43.35 MHz oscillator as the conversion clock;
> CLKIN is tied to GND on the PCB.

### 2.2 Internal Oscillator Rationale

CLKIN is tied to GND on the Rotor PCB. The FDC2114 detects this condition and activates its
internal oscillator (~43.35 MHz). Reasons for this choice:

- Avoids external crystal BOM cost and PCB footprint on a space-constrained circular board.
- Internal oscillator frequency is well above the ~6.5 MHz nominal resonant frequency of the
  LC tank (18 µH + 33 pF), satisfying the >4x oversampling requirement.
- Absolute frequency accuracy of the conversion clock is not critical; relative change detection
  (presence/absence of aluminium shroud segment) is sufficient for Gray-code position decoding.
- Confirmed viable by TI FDC2114 datasheet §8 (internal oscillator specification).

Design decision recorded in `design/Design_Log/DEC-044_fdc2114-internal-oscillator-selected-clkin-gnd.md` as **DEC-044**.

---

## 3. J9 I²C Bus

The J9 bus spans Board A and Board B via the 1x5 inner-face header pair (J9 [Board A] male,
J9 [Board B] female). Pin 3 = SCL, Pin 4 = SDA (3.3V logic levels, pulled up via R6/R7 on Board A).
I²C addresses: U2 = 0x2A, U3 = 0x2B (Board A, N=26 only), U4 = 0x2B (Board B, N=64 only).

> U3 and U4 share address 0x2B but reside on electrically separate boards. The CPLD manages
> Bus direction via the J9 header; U3 and U4 are never simultaneously addressable.

### 3.1 CPLD I²C Master Behaviour

1. On power-up, issue `RESET_DEV` (0x1C = 0x8000) to all FDC2114 devices.
2. Write baseline register map (§2.1) to each populated device.
3. Enter continuous polling loop: read `DATA_CH0_MSB`/`DATA_CH0_LSB` (addresses 0x00-0x07)
   for each active channel on each populated device.
4. Decode raw conversion values to detect sensor threshold crossing (presence of Al shroud slot).
5. Assemble Gray-coded bit vector and drive Encoder output lines.

Threshold calibration values are stored in CPLD configuration (loaded via JTAG). Initial
baseline values require lab bench validation - see `design/Procedures/Lab_Tests.md`.

---

## 4. JTAG Programming

The CPLD is programmed via the JTAG daisy-chain (J1 → J2 → J3 across a rotor stack, continuing
to the Stator). Programming is performed using the Intel Quartus Prime Programmer via the
Controller Board JTAG interface before final rotor assembly. Each Rotor board must have its CPLD
image flashed as part of the manufacturing procedure before the aluminium shroud is closed.

---

## 5. Lab Test Cross-References

| ID | Title | File |
| :--- | :--- | :--- |
| LT-001 | FDC2114 IDRIVE Baseline Calibration | `design/Procedures/Lab_Tests.md` |
| LT-002 | fSENSOR Resonant Frequency Validation | `design/Procedures/Lab_Tests.md` |
