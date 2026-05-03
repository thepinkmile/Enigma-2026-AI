# Enigma-NG User Manual (V1.0 - DRAFT)

**Status:** Draft
**Version:** v.0.1.0
**Associated Hardware Revision:** Rev A
**Last Updated:** 2026-04-04

> **Document Status:** Draft- Power Module sections complete; additional board sections to follow as design review progresses.

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [Safety Instructions](#2-safety-instructions)
3. [The Power Module - System Power Overview](#3-the-power-module---system-power-overview)
   - 3.1 [Input Sources and Priority](#31-input-sources-and-priority)
   - 3.2 [Output Power Rails](#32-output-power-rails)
   - 3.3 [How the Power System Stays Quiet](#33-how-the-power-system-stays-quiet)
   - 3.4 [Power Status Indicators](#34-power-status-indicators)
   - 3.5 [Startup Sequence](#35-startup-sequence)
   - 3.6 [Battery and Supercapacitor Hold-Up](#36-battery-and-supercapacitor-hold-up)
   - 3.7 [USB-C Power Input](#37-usb-c-power-input)
   - 3.8 [PoE+ (Power over Ethernet) Input](#38-poe-power-over-ethernet-input)

---

## 1. Introduction

The **Enigma-NG** is a precision recreation of the legendary Enigma cipher machine and its variants, reimagined as a museum-grade, military-deployable, and educational device. It faithfully
replicates all major historical Enigma variants as well as Allied-developed adaptations, and adds a contemporary extension: a 64-character set supporting Base-64 encoded data transmission, enabling
the machine to encrypt and transmit binary files using the same mechanical substitution principles as the original.

At its core, the Enigma-NG is powered by a Raspberry Pi Compute Module 5 (CM5) running a full Linux-based control system, managing a stack of hardware Rotor logic implemented in dedicated logic chips
(CPLDs). The entire system is built to exacting electrical standards - meeting civilian CE and UKCA certification requirements - making it suitable for deployment in demanding environments.

---

## 2. Safety Instructions
>
> ⚠️ **Read these instructions before operating the Enigma-NG.**
>
### Supercapacitor Discharge Warning

The Power Module contains a bank of supercapacitors that store enough energy to power the system for ≥33.5 seconds after the input power is removed. This is by design - it provides a
graceful shutdown window so the operating system can save its state cleanly.

**Do not open the enclosure if the amber "Safety Glow" LED is illuminated.** This LED indicates that the supercapacitors are still charged above a safe threshold (> 5.1V) and the internal circuitry
is live.

**Before performing any internal maintenance:**

1. Remove all input power connections (mains adapter, PoE cable, battery).
2. Wait for the amber LED to extinguish fully.
3. Using a multimeter, verify that the **SICHERHEITS-PROBE** (V+) and **ERDE-PROBE** (GND) test pads read less than **2.0V** before touching any internal components.

### Electrostatic Discharge (ESD)

All external-facing connectors (Ethernet, USB-C, USB 3.0, HDMI, and battery) are protected against electrostatic discharge. However, internal diagnostic test points and board-to-board connectors are
**not** individually ESD-protected in the prototype variant. Follow standard ESD precautions (wrist strap, anti-static mat) when working inside the enclosure.

### RTC Backup Battery

The Controller board contains an RTC backup battery (CR2032 coin cell) to maintain the system clock during power-off periods.

> ⚠️ **Battery Safety Warning:** The RTC backup battery (CR2032 coin cell) is a lithium cell.
> Do not short-circuit, incinerate, disassemble, or expose to temperatures above 60°C. Replace only with the same or equivalent approved type. Dispose of in accordance with local regulations.

---

## 3. The Power Module - System Power Overview

The Power Module is a dedicated, independently shielded circuit board housed within the aluminium
enclosure. Its job is to condition the system's three power sources and convert them into two clean,
regulated power rails for the rest of the system. USB-C and Battery enter the Power Module directly;
PoE enters the machine through the Controller Ethernet connector and is forwarded to the Power Module
as a regulated auxiliary feed.

### 3.1 Input Sources and Priority

The Enigma-NG can be powered from any of three sources simultaneously. An intelligent input
selection circuit - using ideal-diode transistors and per-path control signals - automatically
selects the best available source without interrupting the system. The documented behaviour is:

| Priority | Source | Typical Voltage | Notes |
| :---: | --- | --- | --- |
| 1st | **PoE+ (Power over Ethernet)** | ~12V | Accepted at the Controller Ethernet / PoE entry, then forwarded to the Power Module as `VIN_POE_12V`; explicitly prioritised over USB-C by the documented LM74700/TPS2372-4 gating |
| 2nd / 3rd | **USB-C (PD adapter)** | 15V | Shares the OR-ing network with Battery; precedence vs Battery depends on the active source voltages unless additional gating is added |
| 2nd / 3rd | **Battery** | 11-16.4V | Shares the OR-ing network with USB-C; used as a fallback/off-grid source |

If a higher-priority documented source becomes available while a lower-priority one is in use, the
system switches seamlessly. The supercapacitor bank bridges any momentary gap during source
transitions.

A thermal fuse (72°C) and electronic protection circuit (eFuse) guard the input against excessive current and out-of-range voltages. The system will not start if the input voltage is below **11V** or
above **16.9V**, protecting all downstream components.

### 3.2 Output Power Rails

The Power Module produces two regulated output rails:

| Rail | Voltage | Max Current | Powers |
| --- | --- | --- | --- |
| **5V_MAIN** | 5.0V | 12A (rated) | Raspberry Pi CM5, USB 3.0 ports, HDMI output |
| **3V3_ENIG** | 3.3V | 3A (rated) | All CPLD logic chips, FT232H VCCIO domain, and low-voltage control/telemetry logic |

> **Note:** The CM5 module internally generates additional supply voltages (1.8V, 1.1V) for its own processors; these are not produced by the Power Module.
>
### 3.3 How the Power System Stays Quiet

The Enigma-NG must meet some of the strictest electromagnetic compatibility (EMC) standards available - both civilian and military. Keeping the power supply electrically "quiet" is therefore a
central design goal. Three complementary techniques are used together:

#### Dual-Phase Switching Regulators

The 5V_MAIN rail is generated by **two identical switching regulators working in tandem** (U2A and U2B). Running a single large regulator at full power would be both less efficient and noisier.
Instead, each regulator handles half the load, operating at 73.0% of its rated capacity - within the 75% design rule (see Certification Evidence §3.3.1).

More importantly, the two regulators are deliberately **timed 180° apart**: when one is switching its output transistor on, the other is switching it off. This "push-pull" rhythm means their
electrical noise largely cancels itself out before it reaches the rest of the circuit - the same principle used in noise-cancelling headphones.

The practical effect:

- The **output ripple** (small voltage fluctuation on the 5V rail) is halved compared to using a single regulator.
- The **effective noise frequency** the rest of the system sees is **800 kHz** (double the 400 kHz each regulator runs at). Higher-frequency noise is much easier to filter with small components.
- The **input-side ripple current** is also halved, reducing stress on the input capacitors and decreasing conducted noise back towards the power source.

#### Dual Random Spread Spectrum (DRSS)

Each regulator also uses a built-in feature called **Dual Random Spread Spectrum (DRSS)**, which continuously and randomly varies its switching frequency by ±5.5% around the 400 kHz centre. Instead
of concentrating switching noise into a single sharp peak at one frequency, DRSS smears it across a small band - reducing its peak amplitude significantly. This is the same technique used in the
power supplies of modern laptops and smartphones to pass EMC testing.

#### The "Iron Curtain" Input Filter

Before any switching occurs, the raw input power passes through a two-stage filter at the board entry point:

- A **nanocrystalline common-mode choke** (wideband, from Wurth Elektronik) blocks high-frequency noise arriving from the source.
- A **high-frequency nanocrystalline CMC** (Wurth WE-CMBNC 7448031002, same as L1) provides supplementary **common-mode** attenuation above ~10 MHz.
- A Pi-filter (L3 + capacitors) on the combined post-OR-ing VIN_RAW bus provides additional differential-mode attenuation.

Together, these three techniques - phase interleaving, spread spectrum, and input filtering - are designed to comfortably meet EN 55032 Class B conducted and radiated emission limits under CE/UKCA
certification.

### 3.4 Power Status Indicators

Two LEDs on the Power Module (visible through the enclosure window or on the front panel) provide at-a-glance status:

| LED | Colour | State | Meaning |
| --- | --- | --- | --- |
| **LOGIK-BEREIT** | Green | Solid | 5V_MAIN rail is stable; system is ready |
| **LOGIK-BEREIT** | Green | 1Hz pulse | System is initialising (CM5 booting) |
| **Safety Glow** | Amber | Solid | Supercapacitors are charged (>5.1V); internal power is live |
| **Safety Glow** | Amber | Off | Supercapacitors discharged; safe to open enclosure |

The multi-colour status LED (controlled by the CM5) on the front panel provides higher-level system state information; refer to the Software User Guide for a full description of status colours and
patterns.

### 3.5 Startup Sequence

When power is applied, the following sequence occurs automatically:

1. **Input validation:** The eFuse checks that input voltage is within 11-16.9V and current is within limits. The thermal cutoff (TCO) provides over-temperature protection at 72°C.
2. **Buck regulators start:** The dual 5V switching regulators (U2A/U2B) and the 3.3V LDO (U7) begin operating, establishing the 5V_MAIN and 3V3_ENIG power rails.
3. **Supercap charging:** The LTC3350 supercap manager begins a controlled 0.5A soft-charge of the supercapacitor bank from the 5V_MAIN rail. This reduced charge rate keeps the system within power

   budget on all input sources. From a fully depleted state, the bank takes approximately **9 minutes** to reach full charge. Full hold-up protection (≥33.5 seconds) is available once
charging is complete.

4. **Rail supervision:** A voltage supervisor monitors the 5V_MAIN rail. Once it stabilises above 4.5V, a 200ms delay timer starts.
5. **CM5 power-on:** After the 200ms delay, the CM5 module receives its enable signal and begins its internal power sequencing (1.8V, 1.1V rails).
6. **Linux boot:** The CM5 boots Linux. The LOGIK-BEREIT LED pulses at 1Hz during this phase.
7. **Ready:** Once the operating system is fully loaded, the front panel status LED changes to its steady-state colour and the system is ready for use.

Total startup time from power application to operational readiness is typically **30-45 seconds**.

### 3.6 Battery and Supercapacitor Hold-Up

**Supercapacitors:** The Power Module contains eight supercapacitor cells (25F each - Abracon
ADCR-T02R7SA256MB, arranged in a 2-series x 4-parallel configuration giving 50F at 5.4V,
managed by the LTC3350 supercap controller)
providing **≥33.5 seconds of hold-up** at a 15W shutdown load. This is sufficient for the operating system to perform a clean, ordered shutdown, preventing filesystem and memory corruption.

> **Note:** Full hold-up protection requires the supercapacitors to be charged, which takes approximately 9 minutes from a cold start. The system is designed for operational sessions of
> **15-30 minutes or longer** - the supercapacitors will be fully charged well before they could ever be needed in normal use.
>
> The graceful shutdown mechanism is a best-effort protection measure. In normal use, unplanned power removal after a full operational session is expected to be harmless - the hold-up window provides
> a comfortable safety margin that far exceeds the time required for a clean OS shutdown. Loss of power before the supercapacitors are fully charged (within the first ~9 minutes of a session) is an
> accepted risk for prototype use.

The LTC3350 controller continuously monitors the supercapacitor bank, balances charge across all eight cells, and automatically switches to supercap-powered operation within microseconds of detecting
a loss of the main 5V rail. No user action is required - the switchover is completely transparent to the operating system.

The amber "Safety Glow" LED remains lit until the supercapacitor voltage drops below 5.1V. Even after the green LED goes out, treat the enclosure as live until the amber LED also extinguishes.

**Battery (Smart Battery Pack):** The battery is connected via a locking 5-pin Micro-Fit connector on the side panel. The system communicates with the battery over SMBus (I2C) to read
state-of-charge, health status, and cell voltages. The CM5 monitors these via GPIO and I2C and displays battery status through the front panel indicator LED. When no higher-priority source is
available, the system runs from the battery; when a mains source becomes available, the battery charges automatically (charge management is handled by the battery pack's internal BMS).

### 3.7 USB-C Power Input

The USB-C port on the Power Module accepts **USB Power Delivery (PD)** adapters. The system automatically negotiates a 15V/5A (75W) power contract with the adapter. A standard 5V USB-C charger will
**not** power the system - a PD-capable adapter rated at 75W or higher (supporting a 15V/5A PDO) is required.

> **Recommended:** Any USB-C PD adapter rated at 90W or above with a 15V/5A profile will work reliably. Examples: most modern laptop chargers (65W+ GaN adapters that include a 15V PDO).

The system also presents a PD power contract to the CM5's USB-C detection circuit so that the Linux operating system correctly identifies the power supply as adequate and does not generate power
warning messages.

### 3.8 PoE+ (Power over Ethernet) Input

The Enigma-NG accepts **IEEE 802.3bt Type 4 (4-pair PoE++)** power delivery over the Controller's
Ethernet connection. This is the highest-power PoE standard currently available, supporting up to
72W delivered to the device - sufficient to run the Enigma-NG at full load without any additional
power source.

Standard PoE (802.3af, 12.95W) and PoE+ (802.3at, 25.5W) are **not sufficient** to power the Enigma-NG at full load. If a lower-power PoE source is connected, the system will fall back to the USB-C
or battery input if available, or operate at reduced load.

When using PoE, no separate mains adapter is needed - a single Ethernet cable handles both data and power.

> **Infrastructure note:** The PoE switch or injector must support **802.3bt Type 4** (also marketed as "PoE++" or "90W PoE"). Standard "PoE+" switches providing 30W per port are insufficient.

---

*Additional sections covering the Controller Board, Rotor Stack, software operation, and cryptographic functionality will be added as the design review progresses.*
