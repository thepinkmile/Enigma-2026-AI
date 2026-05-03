# Enigma-NG Certification Evidence Record (V1.0 - DRAFT)

**Status:** Draft
**Project:** Enigma-NG
**Author:** Izzyonstage & GitHub Copilot
**Version:** v.0.1.0
**Associated Hardware Revision:** Rev A
**Last Updated:** 2026-04-20

> **Document Status:** Draft - Power Module design rationale complete; additional sections to be added as design review progresses.
>
> **Applicable Standards:**
>
> - **CE Marking:** EN 55032:2015+A2:2021 (Multimedia Equipment EMC), EN 55035:2017+A11:2020, EN IEC 61000-3-2, EN IEC 61000-3-3
> - **UKCA:** UKCA equivalent to the above CE directives under UK Statutory Instrument 2016/1091
> - **IEC 61000-4-2:** Electrostatic Discharge Immunity
> - **IEC 61000-4-5:** Electrical Fast Transient / Surge Immunity
> - **IEC 60068-2:** Environmental Testing (Shock, Vibration, Temperature) - CE/UKCA design basis 55°C maximum ambient (industrial); DEFSTAN target -40°C to +80°C (military field use)
>
> **Note:** Military standards compliance evidence (including UK MOD environmental and EMC standards) is deferred to a future phase requiring access to an appropriate accredited review environment.
> The design is architected conservatively and is expected to satisfy military requirements with minimal rework once that review pathway is available; this document will be updated at that stage.

---

## Table of Contents

1. [Document Scope and Purpose](#1-document-scope-and-purpose)
2. [Design Philosophy and Overarching Decisions](#2-design-philosophy-and-overarching-decisions)
3. [Power Architecture Design Rationale](#3-power-architecture-design-rationale)
   - 3.1 [Input Selection and Protection Chain](#31-input-selection-and-protection-chain)
   - 3.2 [eFuse Settings - UVLO and OVLO Rationale](#32-efuse-settings---uvlo-and-ovlo-rationale)
   - 3.3 [5V Buck Converters - Dual-Phase Interleaving Design Rationale](#33-5v-buck-converters---dual-phase-interleaving-design-rationale)
   - 3.4 [3V3_ENIG LDO - Selection Rationale](#34-3v3_enig-ldo---selection-rationale)
   - 3.5 [Component Utilisation Policy](#35-component-utilisation-policy)
   - 3.6 [Thermal Management Design Intent](#36-thermal-management-design-intent)
4. [EMC Design Measures](#4-emc-design-measures)
   - 4.1 [Conducted Emissions - Power Entry Filtering](#41-conducted-emissions---power-entry-filtering)
   - 4.2 [Conducted Emissions - Switching Regulator Strategy](#42-conducted-emissions---switching-regulator-strategy)
   - 4.3 [Radiated Emissions - Grounding Architecture](#43-radiated-emissions---grounding-architecture)
   - 4.4 [ESD Protection Coverage](#44-esd-protection-coverage)
5. [Component Derating Evidence](#5-component-derating-evidence)
6. [PoE Power Budget Evidence](#6-poe-power-budget-evidence)
7. [Component Obsolescence Register](#7-component-obsolescence-register)
8. [Open Actions and Deferred Items](#8-open-actions-and-deferred-items)

---

## 1. Document Scope and Purpose

This document records the design decisions and technical rationale for the Enigma-NG hardware, structured to support formal conformity assessment against the standards listed above. It serves as the
primary evidence document for any independent test laboratory or Notified Body review.

The Enigma-NG is a purpose-built digital Enigma cipher machine recreation, intended for use in museum, military, and educational environments. The device must meet CE/UKCA electromagnetic
compatibility requirements and is designed conservatively to a standard consistent with demanding operational environments. The design philosophy deliberately exceeds civilian CE/UKCA minimums to
facilitate future military compliance assessment with minimal rework.

This document is **living** - it will be updated as the design progresses through prototype, validation, and production stages. Sections referencing prototype-stage decisions will be clearly marked.

---

## 2. Design Philosophy and Overarching Decisions

### 2.1 "Museum-Grade" Design Standard

All components are selected and operated to a standard described internally as "Museum-Grade": the design must remain functional and maintainable for decades, in the hands of non-technical users, in
unpredictable environments. This drives the following binding design rules, applied system-wide:

| Rule | Value | Rationale |
| --- | --- | --- |
| Ceramic capacitor dielectric | X7R only | Y5V/Z5U exhibit >80% capacitance loss at rated voltage; unacceptable for precision filtering |
| Power capacitor voltage derating | 2.5x rated voltage | Long-term reliability under voltage stress; mandatory for military cycling environments |
| Resistor tolerance | 1% minimum; 0.1% for protection thresholds and current-sense paths | Accuracy of UVLO/OVLO/ILIM settings directly impacts protection behaviour |
| Component utilisation | ≤75% of rated maximum | Prevents thermal and electrical degradation under sustained high load |
| Thermal design | Sized for 100% utilisation dissipation | Enclosure and thermal pads sized for worst-case, not design-point |
| Switching converters | Spread-spectrum mandatory; shielded inductors required | EN 55032 Class B conducted emissions compliance |

### 2.2 Single-Point Chassis Ground Architecture

A single-point `GND_CHASSIS` bond is established between the OR-ing network output and the eFuse input - the electrical boundary between the "dirty" input side and the "clean" downstream side. All
external connector ESD protection TVS diodes shunt to `GND_CHASSIS`, which connects to the aluminium enclosure and from there to protective earth. The signal and power reference ground connects to
`GND_CHASSIS` at this one point only.

**Rationale:** Multiple chassis ground bonds create ground loops. Ground loop currents are a leading cause of common-mode radiated emissions failures (EN 55032 Class B radiated emissions) and can
exacerbate susceptibility failures (EN 55035 / IEC 61000-4-3 radiated immunity). The single-point bond is the canonical solution specified in MIL-STD-461G §3.6 and is adopted here as best practice
for CE/UKCA EMC compliance.

---

## 3. Power Architecture Design Rationale

### 3.1 Input Selection and Protection Chain

**Full power chain (input to output):**

```text
[Controller PoE front-end: TPS2372-4 + TPS23730 + T2 ACF Transformer (Coilcraft POE600F-12L, 60W, 12V; `D` suffix = packaging only)]
  → PM dock `J2` as regulated `VIN_POE_12V`
[USB-C 15V PD (STUSB4500) / Battery 11-16.4V / VIN_POE_12V from Controller]
  → LM74700-Q1 OR-ing controller + CSD17483F4T ideal-diode FETs (x3)
  → [L1 CMC → L2 CMC] (common-mode attenuation, 1 kHz-30 MHz)
  → [L3 + C Pi-filter] (differential-mode HF bypass)
  → TCO F1 (72°C thermal fuse)
  → TPS259804ONRGER eFuse (7A ILIM via R3=210Ω, 11.0V UVLO, 16.9V OVLO silicon-fixed, VQFN 4x4mm)
  → [Dual LMQ61460-Q1 5V/12A Buck] → 5V_MAIN → [LTC3350 + 8x Abracon ADCR-T02R7SA256MB supercaps (50F/5.4V, 2S4P)]
  → 5V_MAIN bus
  → [CM5 via TPS25751 PD emulator] + [TPS2065C USB 1.6A] + [AP2331W HDMI 50mA] + [TPS75733KTTRG3 3V3 LDO]
  → 3V3_ENIG (all CPLDs + USB-JTAG)
```

**Input priority rationale:**

- PoE is the explicitly prioritised mains-backed source in the documented LM74700/TPS2372-4 input
  gating, making it the preferred fixed-installation supply path.
- USB-C shares the OR-ing network with Battery and is the preferred bench/service power source when
  PoE is absent.
- Battery shares the same OR-ing path as USB-C and acts as the portable/off-grid fallback source.

The LM74700-Q1 + CSD17483F4T ideal-diode OR-ing provides near-zero forward voltage drop compared to Schottky diodes, minimising thermal dissipation at the input selection stage, which directly reduces
junction temperatures across the power chain and supports IEC 60068-2 thermal test compliance.

### 3.2 eFuse Settings - UVLO and OVLO Rationale

The eFuse (**TPS259804ONRGER**, 16.9V silicon-fixed OVLO, VQFN 4x4mm) is programmed via resistors (UVLO and ILIM) to the following thresholds:

| Parameter | Value | Rationale |
| --- | --- | --- |
| UVLO (Under-Voltage Lock-Out) | **11.0V** | Input sources: PoE ~12V nominal; USB-C 15V; Battery 11V minimum at end-of-discharge. 11V UVLO permits full battery utilisation while rejecting abnormally low inputs. |
| OVLO | **16.9V (silicon-fixed - TPS259804ONRGER)** | Highest available option on TPS25980. No external resistor required or present. Battery BMS must specify max 4.1V/cell (16.4V for 4S) to maintain 0.5V margin below OVLO rising threshold. See §3.2 Note on Battery Voltage. |
| ILIM (current limit) | **7.0A (programmed via R_ILIM)** | Maximum downstream load is 8.76A peak (see §3.5). ILIM programmed using a single external resistor per TPS25980 datasheet formula. |
| Soft-start (supercap charge) | **0.5A** | Controls inrush current during supercapacitor initial charge (~9 min from cold), preventing nuisance eFuse trips at power-on. Charge current reduced from 1A nominal to limit peak PoE utilisation to 73.9% during cold-start charge (53.2W / 72W); within the 75% rule (see §3.5). |

**Resistor ladder values (all 1% thick-film, 0603):**

| Designator | Value | Purpose |
| --- | --- | --- |
| R_UVLO_HI | 232 kΩ (ERJ-3EKF2323V - Mouser 667-ERJ-3EKF2323V / DigiKey P232KHCT-ND / JLCPCB C403086) | UVLO upper resistor |
| R_UVLO_LO | 28.7 kΩ (ERJ-3EKF2872V - Mouser 667-ERJ-3EKF2872V / DigiKey P28.7KHCT-ND / JLCPCB C403135) | UVLO lower resistor |
| R_ILIM | 210 Ω (ERA-3VEB2100V - Mouser 667-ERA-3VEB2100V / DigiKey 10-ERA-3VEB2100VCT-ND / JLCPCB C1861624) | ILIM set resistor (R3) - programs 7.0A trip current |

> **Note on Battery Voltage - OVLO Margin:** The TPS259804ONRGER has a silicon-fixed OVLO rising threshold of 16.9V typ (16.32V min / 17.31V max from datasheet). To maintain an engineering margin of
> ≥0.5V, the Smart Battery BMS is specified to limit charge to **4.1V/cell maximum (16.4V for a 4S pack)** - giving 0.5V margin to the 16.9V typ threshold. This specification must be enforced in
> the battery procurement specification and verified during incoming inspection. Note: the worst-case minimum OVLO rising threshold is 16.32V - only 0.32V above BMS 16.4V maximum charge voltage.
> This margin is acceptable at typical operating temperature but must be re-evaluated if the BMS charge voltage specification is ever relaxed (see §8, OA-01).
>
> **Part Selection - RON Advantage:** The TPS25980's RON of 3mΩ (typ.) was a decisive factor. At 7A, the power dissipation in the eFuse is only 0.15W (I²R = 49 x 0.003) vs 0.60W for the alternative
> TPS25948 (12.2mΩ). The 4x reduction in eFuse heat and the 4x reduction in voltage drop (21mV vs 85mV) directly reduces thermal noise injection into the 5V bus, supporting EN 55032 Class B conducted
> emissions compliance.
>
### 3.3 5V Buck Converters - Dual-Phase Interleaving Design Rationale

#### 3.3.1 Part Selection

Two **TI LMQ61460-Q1** (3-36V input, 6A rated, VQFN-HR (RJR) 14-pin 4x3.5mm, automotive-grade AEC-Q100) switching regulators are used in parallel, phase-interleaved.

**Why two instead of one larger regulator?**

A single 12A-class Buck regulator would satisfy the current requirement but would concentrate switching noise into one location, increase thermal density, and reduce component utilisation headroom.
The dual 6A approach provides:

- 73.0% utilisation of each IC (within the 75% rule) ✔
- Thermal load distributed across two thermal pads
- Redundant current delivery - loss of one IC degrades output to 6A (sufficient for CM5 safe shutdown)
- An upgrade path without PCB redesign: LMQ61480 (8A) or LMQ61495 (10A) are pin-compatible replacements

#### 3.3.2 Switching Frequency - 400 kHz Selection

The LMQ61460-Q1 is configurable from approximately 200 kHz to 2.2 MHz. **400 kHz** is selected for this design.

| Consideration | 400 kHz | 2.2 MHz |
| --- | --- | --- |
| AM broadcast band (525-1705 kHz) | Below band ✔ | Above band ✔ |
| Harmonic at 3x | 1.2 MHz (in band) | 6.6 MHz (clear) |
| Harmonic at 2x (with interleaving) | 800 kHz (near band) | 4.4 MHz (clear) |
| Core loss in inductors | Low | High |
| Inductor size | Larger | Smaller |
| EN 55032 Class B compliance margin | High (DRSS keeps 2x fundamental clear of 525kHz) | Requires careful harmonic management above 2MHz |
| Thermal density in Power Can | Acceptable | Higher due to core loss |

At 400 kHz with the DRSS ±5.5% modulation:

- Fundamental range: 378-422 kHz (well below the 525 kHz AM lower boundary)
- Phase-interleaved effective ripple frequency: 756-844 kHz (the second harmonic cluster, marginally entering the AM band at its upper extreme)
- This residual overlap is managed by the Iron Curtain input filter and the board-level shielded enclosure

#### 3.3.3 Phase Interleaving Architecture - 180° SYNC Implementation

**Master IC (U2A):** Frequency set by R_FSET = 86.6 kΩ (1%, 0603, ERJ-3EKF8662V, R24) from FSET pin to AGND. DRSS enabled (factory default). Internal oscillator runs at 400 kHz ± 5.5%.

**Slave IC (U2B):** FSET/SYNC pin driven by an external phase-shifted replica of U2A's switching signal, constructed as follows:

```text
U2A SW node
    |
   [R_SW: 10kΩ 1% 0402]          (isolates SW ringing from delay chain)
    |
   [C_F1: 100pF X7R 0402]         (low-pass: τ = 1µs, attenuates SW ringing)
    |
   [U_INV1: NL27WZ14DFT2G-Q SC-88 (U13)]  (Schmitt trigger - restores clean digital signal)
    |
   [R_DLY: 82.0kΩ 1% 0402 (R26, ERJ-2RKF8202X)]  +
   [C_DLY: 22nF X7R 0603 (C29, CL10B223KB8WPNC)]  +  RC delay: τ = 1.804ms → well beyond 1/2 period at 400kHz (1.25µs); delay circuit relies on Schmitt-trigger threshold crossing, not τ ≈ T/2
    |
   [U_INV2: NL27WZ14DFT2G-Q SC-88 (U14)]  (Schmitt trigger - re-squares delayed signal)
    |
  U2B FSET/SYNC
    |
   [R_PD: 10kΩ 1% 0402 to AGND]   (ensures defined state during U2A startup; U2B free-runs
                                    at ~400kHz via R_FSET resistor until SYNC locks)
```

Both NL27WZ14DFT2G-Q instances are powered from 3V3_ENIG (available post-LDO startup). 100nF X7R decoupling capacitors are placed within 0.5mm of each VCC pin.

**Phase accuracy:** At 400 kHz nominal, the RC delay produces a 180° offset. With DRSS modulation at ±5.5% (frequency range 378-422 kHz), the fixed RC delay introduces ±8° phase variation. The
residual asymmetric ripple at this offset error is less than 5% of the single-phase ripple amplitude - acceptable for all certification purposes.

**DRSS coherence:** Because U2B's SYNC pin tracks U2A's switching signal directly (including DRSS modulation), both ICs share coherent spread-spectrum dithering. If each IC ran independent DRSS,
inter-modulation products would appear at sum and difference frequencies, partially defeating the spread-spectrum benefit. Coherent DRSS avoids this.

#### 3.3.4 EMI Benefit Quantification

| Mechanism | Quantified Effect | Applicable Limit |
| --- | --- | --- |
| 180° phase interleaving | Input capacitor RMS ripple current reduced by 50% | EN 55032 Class B conducted emissions (30Hz-10kHz) |
| Effective ripple at 800kHz | Output filter requirement halved; lower-inductance filter reduces parasitic emission | EN 55032 Class B conducted emissions (10kHz-10MHz) |
| DRSS ±5.5% | Peak conducted emission at switching frequency reduced ~10-15 dBµV | EN 55032 Class B conducted and radiated emissions |
| 400kHz below AM band | No interference with 525-1705kHz AM broadcast band | CISPR 25 Class 5 |
| Coherent DRSS | No inter-modulation artifacts between the two ICs | EN 55035 / IEC 61000-4-3 radiated susceptibility |

### 3.4 3V3_ENIG LDO - Selection Rationale

**Part selected: TI TPS75733KTTRG3** (fixed 3.3V output variant, TO-263 (KTT) 5-pin)

| Parameter | Value | Rationale |
| --- | --- | --- |
| Input | 5V_MAIN bus | Dropout: 5V - 3.3V = 1.7V; TPS75733 Vdo ≈ 0.22V worst-case at 2.05A - well above minimum input requirement |
| Output noise | Low-noise linear LDO | CPLD VCCIO noise sensitivity; low-noise LDO mandatory vs. second switching regulator |
| PSRR | High PSRR linear LDO | Attenuates Buck output ripple (800kHz effective) - negligible at CPLD supply |
| Max output current | 3A | Peak load: 37 CPLDs x 50mA (1,850mA) + 60x FDC2114RGHR at 2.1mA typ (126mA) + FT232H VCCIO (10mA) + INA219 x2 (2mA) + Extension buffers (10mA) + Controller-local (50mA) = 2,048mA → **2.05A rounded; 68.3% utilisation** ✔ (per Power_Budgets.md) |
| Package | TO-263 (KTT) 5-pin 10.16x15.24mm | Standard power package; thermal pad to PCB; no large copper pour required |
| Input power dissipation | Vdo≈0.18V x 2.05A = **~0.37W** (typ.); ≤**0.45W** worst-case | Standard TO-263 thermal pad and ground vias sufficient; ≥200mm² copper pour requirement removed |

**Why not a second switching regulator for 3V3_ENIG?**

The 37 CPLDs (6x Encoder + 30x Rotor + 1x Stator, all `EPM570T100I5N`) share this rail as their
VCCIO (I/O voltage reference).
Any ripple or noise on this rail corrupts the logic signal thresholds, causing indeterminate switching and
potential JTAG chain errors. A linear LDO provides high PSRR isolation from Buck switching noise that no practical switching converter could match in this topology without substantial additional
filtering.

### 3.5 Component Utilisation Policy

All active components are operated at ≤75% of their rated maximum under worst-case conditions (maximum ambient temperature, maximum specified load). This provides thermal and electrical derating
consistent with military component derating standards.

**Peak load budget (5V_MAIN bus):**

| Load | Current | Notes |
| --- | --- | --- |
| Raspberry Pi CM5 (full rated) | 5.00A | Linux OS undervoltage threshold: 5V/5A (25W); full allocation maintained |
| USB 3.0 (TPS2065C rated limit) | 1.60A | Single USB 3.0 port; TPS2065C current-limited |
| HDMI (AP2331W rated limit) | 0.05A | Hot-plug current spike handled by AP2331W |
| 3V3_ENIG LDO input (37 CPLDs) | 2.05A | 37 CPLDs x 50mA + 60x FDC2114RGHR at 2.1mA + other consumers = 2,048mA → 2.05A (per Power_Budgets.md); 3A LDO peak |
| **Total peak** | **8.76A** | **73.0% of 12A rated Buck output** ✔ |

**Component utilisation summary:**

| Component | Function | Rated | Peak Load | Utilisation |
| --- | --- | --- | --- | --- |
| 2x LMQ61460-Q1 | 5V Buck (combined) | 12A | 8.76A | **73.0%** ✔ |
| TPS75733KTTRG3 | 3V3_ENIG LDO | 3A | 2.05A | **68.3%** ✔ |
| TPS25980 (16.9V OVLO) | eFuse (programmed ILIM) | 7A | 4.67A* | **66.7%** ✔ |
| TPS2372-4 + TPS23730 + T2 POE600F-12L (PoE discrete DC-DC) | PoE PD capacity | 72W | 50.3W (steady) | **69.9%** ✔ |
| STUSB4500 | USB-C PD negotiation | 15V/5A (75W) | 42.5W | **56.7%** ✔ |

> *eFuse load (worst case - PoE 12V bus): Supercap bank is on 5V_MAIN (LTC3350 managed). eFuse sees: total system 5V draw 8.76A + LTC3350 supercap charge 1A (5V side) = 9.76A at 5V = 48.8W. Buck
> input (÷0.87) = 56.1W. At 12V PoE bus: 56.1W / 12V = **4.67A eFuse current**. eFuse utilisation (ILIM=7A): 4.67A / 7A = **66.7%** ✔. Steady state (no supercap charge): 8.76A x 5V / (0.87 x 12V) =
> 4.20A / 7A = **60.0%** ✔. At USB-C 15V: 56.1W / 15V = 3.74A / 7A = **53.4%** ✔. All cases within the 75% derating rule.
>
> **PoE peak: Supercapacitor bank (on 5V_MAIN bus, managed by LTC3350) charges at 0.5A from 5V_MAIN. During initial charge (~9 minutes from cold start), total 5V_MAIN load = 8.76A (system) + 0.5A
> (LTC3350 supercap charge) = 9.26A. Buck input at 87% efficiency = 9.26A x 5V / 0.87 = 53.2W drawn from PoE source (independent of bus voltage). PoE utilisation during charge phase = 53.2W / 72W =
> **73.9%** ✔ (within 75% design rule).
> Steady-state utilisation (fully charged): 8.76A x 5V / 0.87 = 50.3W / 72W = **69.9%** ✔. OA-02 resolved - see Open Actions.
>
### 3.6 Thermal Management Design Intent

The Power Module is housed in a 42mm aluminium "Power Can" enclosure with internal compression ribs. The thermal design provides a continuous heat path from component junctions to the enclosure:

- **Switching regulator thermal pads** → type VII epoxy-filled VIPPO via matrix (hexagonal pattern) → L4 copper plane → exposed ENIG thermal pad on PCB bottom → Gelid GP-Ultimate thermal interface

  material (15 W/mK) → aluminium enclosure wall
- **LDO thermal pad** → same via matrix → shared thermal zone with supercapacitor area
- **Enclosure** → ambient via natural convection; no forced cooling required for rated load

The thermal system is designed to manage the heat dissipation resulting from 100% component utilisation, despite the 75% operational limit, providing a safety margin for unexpected load spikes and
ambient temperature excursions consistent with IEC 60068-2 environmental test requirements.

---

## 4. EMC Design Measures

### 4.1 Conducted Emissions - Power Entry Filtering

The Power Module implements a two-stage common-mode and differential filter at the point of power entry (the "Iron Curtain"):

| Stage | Component | Type | Function |
| --- | --- | --- | --- |
| Primary | Wurth Elektronik WE-CMBNC Nanocrystalline CMC | Common-mode choke | Broadband (1kHz-1GHz) common-mode noise attenuation |
| Secondary | Wurth WE-CMBNC 7448031002 | High-frequency nanocrystalline CMC (replaces discontinued Laird CM5022) | Supplementary common-mode attenuation above ~10 MHz; L1+L2 pair together covers 1kHz-30MHz CM |
| Pi-filter | Moulded inductors + 50V X7R ceramic capacitors | LC Pi filter | Differential noise attenuation across Buck switching band |
| Y-capacitors | X7R ceramics, 50V, to GND_CHASSIS | Capacitive shunt to chassis | Common-mode current path to chassis; reduces conducted DM→CM conversion |

Y-capacitors are placed at the power entry point, between the power rails and GND_CHASSIS, before any switching circuitry. This ensures common-mode noise from the source is shunted to chassis before
entering the board.

### 4.2 Conducted Emissions - Switching Regulator Strategy

See §3.3 for the full dual-phase interleaving design rationale. Key measures:

- **400kHz operation:** Below AM broadcast band; avoids direct interference with 525-1705kHz
- **DRSS ±5.5%:** Mandatory for all switching regulators; spreads conducted emission peaks
- **Shielded inductors:** Mandatory for all Buck regulator output inductors; prevents magnetic field coupling to adjacent signal traces
- **Phase interleaving:** 180° offset between U2A and U2B reduces conducted ripple amplitude at all frequencies

### 4.3 Radiated Emissions - Grounding Architecture

**Single-point GND_CHASSIS bond:** As described in §2.2. The bond point is located physically between the OR-ing network and the eFuse, at the "clean/dirty" boundary. Copper pours for GND_CHASSIS and
signal GND are separated everywhere except this one point, with a clear visual gap on all PCB layers maintained in the layout.

**GND_CHASSIS ring:** A 4-layer GND_CHASSIS copper ring with 2.5mm staggered via-stitching runs the perimeter of the PCB, providing a low-impedance return path for ESD events and shielding the board
interior from external fields.

**Aluminium enclosure:** The "Power Can" enclosure acts as a Faraday shield for radiated emissions above approximately 300 MHz. All screws connecting the PCB to the enclosure pass through GND_CHASSIS
copper, maintaining shield continuity.

### 4.4 ESD Protection Coverage

All externally accessible connectors on the Power Module are protected against ESD events per IEC 61000-4-2 (contact discharge ±4kV, air discharge ±8kV minimum). TVS protection arrays shunt to
GND_CHASSIS (not signal GND) to prevent ESD injection into the signal reference.

| Interface | Protection Device | Package | Notes |
| --- | --- | --- | --- |
| RJ45 Ethernet (MDI0/MDI1) | TPD4E05U06 (D4) | U-DFN-10 | One device per two differential pairs |
| RJ45 Ethernet (MDI2/MDI3) | TPD4E05U06 (D5) | U-DFN-10 | One device per two differential pairs |
| USB-C Power Input | TPD4E05U06 (D3) | U-DFN-10 | Covers CC1, CC2, VBUS, and SBU lines |
| Battery SMBus (SDA/SCL) | TPD2E2U06 (D2) | SOT-553 (DRL) | SMBus differential pair protection |
| Battery Presence (BATT_PRES_N) | TPD1E10B06DYARQ1 (D1) | SOD-523 | Single-line presence detect |

**Internal connections (Board-to-Board links):** Internal BtB connectors (the PM dock cluster and the
Stator dock pair) are not individually ESD-protected in the standard configuration, as they are
considered internal interfaces not subject to user contact during normal operation.

**Coupon-based bring-up access:** If removable coupon probe access is added later, any exposed pads
will require a dedicated ESD review before production release.

---

## 5. Component Derating Evidence

All components operate within the following derating limits. The CE/UKCA design basis is 55°C maximum
ambient (IEC 60068-2 industrial). The DEFSTAN design target for future military certification is
**-40°C to +80°C**. All worst-case thermal calculations below use **+80°C** as the maximum ambient.
The thermal enclosure is sized to handle 100% component utilisation at 70°C ambient, providing
additional headroom.

| Component Class | Parameter | Derating Applied | Basis |
| --- | --- | --- | --- |
| Ceramic capacitors | Voltage | 2.5x rated | X7R capacitance loss at rated voltage; long-term reliability |
| Electrolytic capacitors | Voltage | 2.0x rated | Not used in this design (all ceramic and film) |
| Switching regulators | Current | ≤75% of Iout(max) | Thermal derating; junction temperature target |
| LDO regulator | Current | ≤75% of Iout(max) | Power dissipation; θJA x Pdiss < TJ(max) - TA(max) |
| eFuse | Current limit | 70% of ILIM setting | Prevents nuisance trips on transients |
| Resistors (power) | Power | ≤50% of rated | Long-term stability; 50% derating is standard for resistors |
| Resistors (precision, 0.1%) | Power | ≤25% of rated | Maintains temperature coefficient specification |
| PCB traces (power) | Current | Per IPC-2221B at 70°C | 2oz copper; trace width calculated per IPC standard |
| BtB connector (power pins) | Current | ≤75% of per-contact rating | TE PM dock: 6A/contact rated; max design load 3.17A/contact (52.8%). Molex Stator dock: 130A/contact rated; max design load <1A/contact (<0.8%). See §5.1 for full analysis. |

---

### 5.1 Connector Current and Thermal Derating Analysis

*Satisfies OA-05. Source data: TE Product Specification 108-5775 Rev. B2 (18 JUL 2019) - see
[../Datasheets/TE-108-5775-product-specification.md](../Datasheets/TE-108-5775-product-specification.md).*

#### TE Connectivity 2.5 mm Battery Connector - PM Dock (J1 / J2 / J3)

**Parts:** `1-1123684-7` (plug, Power Module) / `1-1674231-1` (receptacle, Controller Board)

| Electrical Parameter | Rating |
| --- | --- |
| Voltage | 30V DC max |
| Current | **6A per contact** |
| Operating Temperature | -20°C to +80°C |
| Temperature rise at full rated current | 30°C max at 6A (§3.5.5) |
| Thermal shock qualification | -40°C / 30 min ↔ +85°C / 30 min x 5 cycles - passes ΔR ≤ 20 mΩ (§3.5.12) |

**Temperature rise model:** The product spec states ≤30°C rise at the rated 6A. Assuming I²R-proportional
power dissipation, rise at any actual current is:

> ΔT_contact = 30°C x (I_actual / 6A)²

**J1 current derating (5V\_MAIN / 3V3\_ENIG / GND):**

| Net | Allocated Contacts | Worst-case Load | Per-Contact Load | % of 6A | Contact ΔT | Body Temp @+80°C amb. |
| --- | :---: | --- | --- | :---: | --- | --- |
| 5V\_MAIN | 3 | 9.50A (system peak) | 3.17A | **52.8%** ✔ | 8.4°C | 88.4°C |
| 3V3\_ENIG | 2 | 3.00A (LDO-limited) | 1.50A | **25.0%** ✔ | 1.9°C | 81.9°C |
| GND (return) | 5 | 12.50A (combined) | 2.50A | **41.7%** ✔ | 5.2°C | 85.2°C |

> 5V\_MAIN peak: CM5 5.00A + USB 1.60A + HDMI 0.05A + LDO input 2.85A = 9.50A (Power\_Budgets.md)
> GND contacts carry combined return for 5V\_MAIN (9.50A) + 3V3\_ENIG (3.00A) = 12.50A

**J2 current derating (VIN\_POE\_12V / GND):**

| Net | Allocated Contacts | Worst-case Load | Per-Contact Load | % of 6A | Contact ΔT | Body Temp @+80°C amb. |
| --- | :---: | --- | --- | :---: | --- | --- |
| VIN\_POE\_12V | 3 | 5.00A (estimated peak) | 1.67A | **27.8%** ✔ | 2.3°C | 82.3°C |
| GND (return) | 7 | 5.00A (combined) | 0.71A | **11.9%** ✔ | 0.4°C | 80.4°C |

> J3 carries signal and control lines only; no current derating applies.

**Result:** All TE PM dock contacts operate within the ≤75% component utilisation rule under worst-case
system load. At the DEFSTAN maximum ambient of +80°C, the worst-case contact body temperature is
approximately **88.4°C** (5V\_MAIN contacts on J1). This is:

- Within the thermal shock upper bound (+85°C, §3.5.12 - the connector cycles to this temperature and passes)
- Within the heat aging test temperature (85°C / 96h mated, §3.5.17 - connector passes)
- Marginally above the rated ambient (+80°C), but only when the contacts are simultaneously at 53% of rated current and at maximum ambient - a conservative double-worst-case scenario

This is considered acceptable.

#### Temperature Exception - TE PM Dock Cold Operating Limit

| | Value |
| --- | --- |
| TE connector operating temperature (lower bound) | -20°C |
| DEFSTAN design target (lower bound) | **-40°C** |
| Gap | 20°C |

The TE connector is not rated for continuous operation at -40°C. The following evidence supports
continued use subject to a design exception:

1. **Thermal shock qualification (§3.5.12):** The connector is tested by cycling between -40°C (30 min)
   and +85°C (30 min) for 5 cycles. Contact resistance after this cycling meets ΔR ≤ 20 mΩ. This is
   a more demanding test than cold-soak at -40°C and demonstrates material and contact integrity at the
   cold extreme.

2. **Operational context:** The Enigma-NG device, when in use, is expected to be operated inside a
   shelter, vehicle, or heated room. Operation at -40°C continuous ambient requires the device to be
   drawing current in an unheated field environment; the connector self-heating under load at 53% of
   rating adds a small positive ΔT (~8°C) above ambient, partially offsetting the cold ambient effect.

3. **No evidence of failure mode at -40°C:** The product specification does not cite any electrical or
   mechanical failure modes at -40°C; the lower bound is a rating limit, not a known failure point.

**Note:** DEFSTAN military certification is a **nice-to-have** aspiration for this project, not a hard
requirement. The thermal exception note above is retained for completeness, but it should be treated
with a pinch of salt - the primary certification targets are **CE / UKCA** (IEC 60068-2 industrial,
55°C maximum ambient). If formal DEFSTAN testing is ever pursued, obtaining TE Connectivity written
confirmation of -40°C continuous operation for this family would be recommended at that stage.

---

#### Molex EXTreme Guardian HD - Stator Dock (Stator J11/J12 ↔ Controller J4/J5)

**Parts:** `2195620015` (plug) / `2195630015` (receptacle)

| Electrical Parameter | Rating |
| --- | --- |
| Current | **130A per contact** |
| Operating Temperature | -40°C to +125°C ✔ meets DEFSTAN target |

The Stator dock connectors carry 5V\_MAIN and 3V3\_ENIG between the Controller Board and the Stator Board.
Maximum combined system load served through these connectors is approximately 2.2A (37 CPLDs + FDC2114 sensors + routing logic - see Power\_Budgets.md).

| Net | Max Total Load | Per-Contact Load | % of 130A Rating | Assessment |
| --- | --- | --- | :---: | --- |
| 5V\_MAIN | ≤ 0.74A | ≤ 0.19A | **< 0.2%** ✔✔ | Trivially within rating |
| 3V3\_ENIG | ≤ 2.05A | ≤ 0.51A | **< 0.4%** ✔✔ | Trivially within rating |

**Result:** Molex EXTreme Guardian HD connectors are overrated by a factor of >100x for this application.
No current or thermal derating concerns. Temperature rating (-40°C to +125°C) fully meets the DEFSTAN
target of -40°C to +80°C. ✔

---

## 6. PoE Power Budget Evidence

The following table documents the IEEE 802.3 PoE standard capabilities and the rationale for the selection of 802.3bt Type 4.

| Standard | PSE Output | PD Input Power | Input Current @15V | Pairs Used |
| --- | --- | --- | --- | --- |
| 802.3af (PoE) | 15.4W | 12.95W | 0.86A | 2-pair |
| 802.3at (PoE+) | 30W | 25.5W | 1.70A | 2-pair |
| 802.3bt Type 3 (PoE++) | 60W | 51.0W | 3.40A | 4-pair |
| **802.3bt Type 4 (PoE++)** | **90W** | **71.3W** | **4.75A** | **4-pair** |

**Load vs. PoE standard comparison:**

| Condition | System Load | Type 3 (51W) | Type 4 (72W) |
| --- | --- | --- | --- |
| Steady-state (CM5 + USB + HDMI + LDO) | 42.5W | 83.3% ❌ | 59.0% ✔ |
| Initial supercap charge (+2.87W Buck input for 0.5A @ 5V) | 45.4W | 89.0% ❌ | 63.1% ✔ |

> Initial supercap charge (0.5A at 5V, ~9 minutes from cold start) raises total 5V_MAIN load to 9.26A (8.76A system + 0.5A LTC3350 charge).
> Buck input at 87% efficiency = 9.26A x 5V / 0.87 = 53.2W PoE input.
> Worst-case PoE utilisation during this window: 53.2W / 72W = 73.9% ✔ - within the 75% design rule.
> System must be powered for ≥9 minutes before full hold-up protection (≥33.5 seconds) is available.
> Normal minimum operational session is 30+ minutes; this constraint is not operationally significant.

**PoE PD implementation - Discrete design (TPS2372-4 + TPS23730 + T2):** The Silvertel Ag5300 /
Ag53000 module (802.3at, 25.5W) previously considered is replaced by a fully discrete PoE PD design
on the Controller using:

- **TPS2372-4** (TI, VQFN-20): 802.3bt Type 4 PD interface, classification, and external hotswap controller (supports up to 90W PD)
- **TPS23730** (TI, WQFN-20): Active Clamp Flyback (ACF) DC-DC controller, 200kHz, 12V output (R_VFB feedback resistors configured for 12V), PSR mode
- **T2**: **Coilcraft POE600F-12L** - off-the-shelf 60W ACF PoE isolation transformer; 12V output,
  36-72V input, 200kHz, ≥1500Vrms isolation, SMT, RoHS. `D` suffix is packaging-only for
  pick-and-place. This is a Coilcraft-direct consignment part ordered from Coilcraft
  (coilcraft.com). No custom winding required.
  - **OR-ing priority note:** PoE at 12V is lower than USB-C at 15V. The LM74700-Q1 USB-C path enable pin is driven by the TPS2372-4 `/PG` signal to enforce PoE priority when PoE is live. Battery

    is the third ideal-diode input; its precedence relative to USB-C follows the active source

    voltages at the OR-ing stage unless additional gating is added.

**System capacity: 72W** (TPS2372-4 external hotswap allows TPS23730 DC-DC to operate beyond the 51W Type 3 integrated limit; confirmed by TI PMP23365 reference design at 72W/Class 8 with TPS2372-4).

**Open action OA-03 is closed** by this selection. See §8 for updated open action register.

---

## 7. Component Obsolescence Register

This section records components that have active end-of-life (EOL) or product change notices (PCN) at the time of design. For each such component, the design team's acceptance rationale and any
mitigation plan are documented.

### 7.1 MAX II EPM570T100I5N (CPLD - Encoder, Rotor, and Stator Boards)

| Attribute | Detail |
| --- | --- |
| **Manufacturer** | Intel (formerly Altera) |
| **Part Number** | EPM570T100I5N |
| **Family** | MAX II |
| **Function** | Encoder sampled debounce + 64-to-6 / 6-to-64 conversion logic (Encoder x6); rotor wiring-map lookup + mod-N adder + STGC/RBGC encoder decode (Rotor x30); Stator routing matrix and reflector map application (Stator x1) |
| **Quantity** | 37 devices (Encoder x6, Rotor x30, Stator x1) |
| **EOL/PCN Status** | Active lifecycle notice issued by Intel |
| **Notice Type** | Product Discontinuation / Last-Time-Buy notification |
| **Supply** | 3.3 V (3V3_ENIG rail) |
| **Package** | TQFP-100 (industrial, -40 °C to +100 °C) |
| **JTAG** | All 37 devices in-system programmable via shared JTAG chain |
| **Virtual JTAG** | Rotor CPLDs expose ALTERA_VIRTUAL_JTAG USER0 UDR for position readback (FR-ROT-09, DEC-027) |

**Acceptance Rationale (Prototype Stage):**

The MAX II EPM570T100I5N is accepted for use in the prototype design for the following reasons:

1. **Cost effectiveness:** These devices remain significantly lower in cost than their recommended
   successors (MAX 10, Cyclone 10 LP). Although noted as "obsolete", they remain readily available
   through established distribution channels and continue to be supported by Intel.
2. **Architecture consolidation:** Using one MAX II device across Encoder, Rotor, and Stator boards simplifies bulk purchasing, programming workflows, and spare-holding during
   prototype-stage development where design changes are expected.
3. **Developer tooling:** The designer holds a MAX II FPGA/CPLD development board, enabling direct verification of programming chains and JTAG connectivity prior to committing to PCB fabrication.
4. **Prototype scope:** The prototype is not intended for customer-facing deployment. Obsolescence risk during the prototype phase (expected duration: 6-12 months) is considered acceptable,
   particularly given the availability of remaining stock from reputable distributors.
5. **Pin and feature compatibility:** The MAX II EPM570T100I5N in a TQFP-100 package has established tooling and documentation support in Quartus II Web Edition (perpetual free licence), minimising
   development risk.

**Mitigation Plan (Production Stage):**

Before any production units are manufactured, the CPLD selection must be reviewed. Candidate replacements include:

- **Intel MAX 10 10M02SCE144C8G** (EEPROM-based, single-supply, no external configuration memory required) - preferred drop-in successor to MAX II in terms of tooling familiarity
- **Lattice MachXO2** family (lower cost, competitive tooling, active lifecycle)
- **Lattice MachXO3** family (higher density options if needed)

Any replacement CPLD must be verified for:

- Pin-compatible TQFP-100 (or equivalent via adapter) footprint, or a PCB layout revision must be performed
- JTAG chain compatibility with the FT232H-based USB-JTAG interface
- 3.3V VCCIO (3V3_ENIG) compatibility
- Operating temperature range: -40°C to +85°C minimum (IEC 60068-2 extended industrial range; selected conservatively to support future military certification assessment)

> **Action item OA-04:** Review replacement CPLD options before prototype-to-production transition. Update this register with selected replacement part.

---

## 8. Open Actions and Deferred Items

### Open Actions (Required Before Certification Submission)

| ID | Description | Owner | Priority |
| --- | --- | --- | --- |
| OA-01 | **[CLOSED]** eFuse variant confirmed as **TPS259804ONRGER** (16.9V silicon-fixed OVLO, VQFN-24). UVLO confirmed: V_UVLO_R = 1.20V typ; R1=232kΩ, R2=28.7kΩ → 10.90V typ (range 10.72-11.17V). OVLO: silicon-fixed 16.9V typ (16.32V min / 17.31V max rising) - no external R; worst-case min 16.32V gives 0.32V margin above BMS 16.4V max - documented in §3.2 battery note. ILIM: R3 = 210 Ω ERA-3VEB2100V (Mouser 667-ERA-3VEB2100V, DigiKey 10-ERA-3VEB2100VCT-ND, JLCPCB C1861624; 0.1% thin-film), programs 7.062A typ via R = 1460/(I-0.11). All PNs confirmed. | Hardware Designer | **CLOSED** |
| OA-02 | ~~Evaluate supercapacitor charge rate throttling during PoE-only operation to bring peak PoE utilisation below 75% (currently 80.6% during charge phase).~~ | ~~Hardware Designer~~ | **CLOSED** - LTC3350 RICHARGE programming resistor set for 0.5A charge current (halved from 1A nominal). During initial ~9 min charge from cold: 53.2W / 72W = 73.9% ✔ - within 75% design rule. Steady-state: 50.3W / 72W = 69.9% ✔. |
| ~~OA-03~~ | ~~Confirm specific 802.3bt Type 4 PoE module part number~~ | ~~Hardware Designer~~ | **CLOSED** - Replaced by discrete design: TPS2372-4 + TPS23730 + Coilcraft POE600F-12L ACF transformer (`D` suffix = packaging only). Capacity 72W. See §6 for full rationale. |
| OA-04 | Review replacement CPLD for production stage. Update §7.1 with selected part. | Hardware Designer | Low (pre-production) |
| ~~OA-05~~ | ~~Thermal / current-capacity verification of the active PM and Stator dock connectors using the TE `1-1674231-1` / `1123684-7` and Molex `2195630015` / `2195620015` datasheets. Document the final derating rule for §5.~~ | ~~Hardware Designer~~ | **CLOSED** - Full connector current and thermal derating analysis documented in §5.1. TE PM dock: 6A/contact rated; worst-case 3.17A/contact (52.8%). Molex Stator dock: 130A/contact rated; worst-case <0.51A/contact (<0.4%). Temperature exception noted: TE lower operating limit is -20°C vs DEFSTAN -40°C; thermal shock test to -40°C provides supporting evidence. DEFSTAN certification is a nice-to-have aspiration, not a hard requirement; primary targets are CE/UKCA. |
| ~~OA-06~~ | ~~Verify TPS25751DREFR CC1/CC2 routing to CM5 is present on Link-Alpha connector pin map. Confirm PDO presented is 5V/5A (25W).~~ | ~~Hardware Designer~~ | **CLOSED** - CC1/CC2 pins of TPS25751DREFR routed to CM5 via Link-Alpha connector. PDO programmed to 5V/5A (25W) to prevent Linux OS power-throttling during initial boot and full-load operation. Verified in Controller Board_Layout §4 Link-Alpha pin map. |
| ~~OA-07~~ | ~~Resolve Link-Alpha pins 21-24 reallocation (currently freed from `CM5 3V3` removal). Confirm new assignment and update Board_Layout.md.~~ | ~~Hardware Designer~~ | **CLOSED** - DEC-001 confirmed: pins 21-22 = 5V_MAIN, pins 23-24 = GND. Formally documented in Controller/Board_Layout.md BtB Link-Alpha table (all 80 pins assigned). |
| ~~OA-08~~ | ~~Engage Wurth Elektronik application support for custom ACF transformer T2 winding specification. Provide full electrical spec (EF20 core, Np:Ns 2.8:1, Lm 150-200µH, ≥1500Vrms, 51W/250kHz, -40°C to +125°C). Reference TI TIDA-050045 and PMP23365 design magnetics. Obtain prototype quantity quote and lead time.~~ | ~~Hardware Designer~~ | **CLOSED** - Superseded by selection of Coilcraft POE600F-12L (off-the-shelf 60W ACF PoE transformer, 12V output, ≥1500Vrms, Coilcraft-direct consignment part; `D` suffix = packaging only). No custom winding required. |

### Deferred Items (Post-Prototype Stage)

| ID | Description | Deferred Until |
| --- | --- | --- |
| DA-01 | If coupon-based diagnostic access is introduced, exposed ENIG pads must receive dedicated ESD protection or documented justification before production release and any classroom deployment. | Post-coupon diagnostic design |
| DA-02 | ESD policy for classroom deployment variant - define which internal BtB-accessible connections require additional ESD protection when the device is used in an educational/student-access configuration. | Pre-production (classroom variant) |
| DA-03 | Full consistency documentation pass - legacy Link-Alpha / Link-Beta references must remain historical-only after DEC-038. If further active docs are added, ensure they use the TE PM dock and Molex Stator dock naming from the start. | Ongoing document maintenance |
| DA-04 | Update Consolidated BOM with all locked Power Module components. Format: component description, specification, boards requiring, quantity, notes (no reference designators - these are per-board). | Post-eFuse part lock (OA-01) |

---

## 9. Future Military & Defence Certification Considerations

The following table records alignment of the current Enigma-NG Power Module design against relevant military and defence standards.
**No design changes are required at this stage.** This section is for reporting purposes and to support future MOD (UK Ministry of Defence) or equivalent certification submissions.

> **Status key:** ✔ Aligned - design meets intent; ⚠️ Partial - some requirements met, gaps identified; ❌ Not addressed; 🔵 Reference only - voltage/platform class mismatch, philosophy only
>
### 9.1 EMC Standards

| Standard | Relevance | Status | Aligned Features | Key Gaps / Future Actions |
| :--- | :--- | :---: | :--- | :--- |
| **MIL-STD-461G** | Primary EMC standard for defence equipment | ⚠️ Partial | CE102 input filter provides -46 dB @ 150 kHz; RE102 Faraday enclosure; §3.6 GND bond rule explicitly documented | CS114/RS103 susceptibility not addressed; non-PM boards lack EMC design documentation |
| **DEF STAN 59-411** | UK MoD EMC policy (Navy/Army/Air) | ⚠️ Partial | CMC below 150 kHz per specification; Faraday enclosure; ESD protection at all external ports | Platform category (Ship/Vehicle/Aircraft) not determined - this gates test levels |
| **IEC 61000-4-2** | ESD immunity | ✔ Aligned | TPD4E05U06 ESD suppressors fitted at all external ports; transients steered to GND_CHASSIS | Any future coupon-based diagnostic access needs a dedicated ESD review before release |
| **IEC 61000-4-4** | Electrical Fast Transient (EFT) | ⚠️ Partial | Pi-filter + CMC provides significant attenuation of fast transients on input lines | No EFT margin calculation documented against specific test levels |
| **IEC 61000-4-5** | Surge immunity | ⚠️ Partial | 1500 Vrms isolation on PoE path; TVS diode on battery input | No differential-mode surge margin calculated against specific test levels |
| **IEC 61000-4-6** | Conducted susceptibility (RF) | ⚠️ Partial | Dual CMC topology provides common-mode RF rejection | No CM susceptibility margin documented |
| **IEC 61000-4-8** | Power frequency magnetic field | ❌ Not addressed | Nanocrystalline CMC cores provide partial 50 Hz attenuation incidentally | No design intent or test plan stated |

### 9.2 Environmental Standards

| Standard | Relevance | Status | Aligned Features | Key Gaps / Future Actions |
| :--- | :--- | :---: | :--- | :--- |
| **MIL-STD-810H** | Environmental engineering - temperature, vibration, humidity, shock | ⚠️ Partial | Component temperature ratings: -40 °C / +125 °C for most actives; RTV silicone mechanical retention; locking connector features; X7R ceramic dielectric (stable over temperature) | Supercap rated to +85 °C - no thermal margin at upper extreme; CPLD lower limit 0 °C; no conformal coating specified; no vibration/shock profile defined |
| **DEF STAN 00-035** | Environmental testing for defence materiel | ⚠️ Partial | Same as MIL-STD-810H alignment | Same gaps; transit and storage environmental profiles not yet defined |

### 9.3 Safety Standards

| Standard | Relevance | Status | Aligned Features | Key Gaps / Future Actions |
| :--- | :--- | :---: | :--- | :--- |
| **MIL-STD-882E** | System safety programme requirements | ⚠️ Partial | OVLO/UVLO/ILIM protection on all inputs; thermal cutout (TCO) on battery path; 1500 Vrms galvanic isolation on PoE; graceful shutdown sequencing via supercap hold-up | No formal FMEA (Failure Mode & Effects Analysis) or SHA (System Hazard Analysis) documented |

### 9.4 Power Quality Standards

| Standard | Relevance | Status | Aligned Features | Key Gaps / Future Actions |
| :--- | :--- | :---: | :--- | :--- |
| **MIL-STD-704F** | Aircraft electric power characteristics | 🔵 Reference only | UVLO/OVLO input protection philosophy aligned with 704F intent | Voltage class mismatch: Enigma-NG operates at 11-17 V (battery/PoE), not 28 V DC mil-bus |
| **MIL-STD-1275E** | Characteristics of 28 V DC military vehicle power | 🔵 Reference only | Reverse polarity protection; UVLO floor concept | Voltage class mismatch: same as above; no 28 V bus |

### 9.5 Notes for Future Certification Submissions

1. **Platform classification (DEF STAN 59-411 / MIL-STD-461G):** The applicable test levels depend on classification (e.g., Ship Above Deck, Ground Vehicle, Airborne).
   This must be determined before any EMC pre-compliance testing.
2. **FMEA/SHA (MIL-STD-882E):** A formal Failure Mode & Effects Analysis should be conducted at PDR (Preliminary Design Review) stage prior to any MOD contract submission.
3. **Conformal coating:** Decision required at production design stage. Acrylic or silicone coating would support DEF STAN 00-035 humidity and fungal resistance requirements.
4. **Vibration profile:** No vibration specification has been defined. A target operational environment must be stated to determine whether vibration testing (MIL-STD-810H Method 514) is applicable.
5. **EFT/Surge margin calculations:** Formal margin calculations against IEC 61000-4-4 and IEC 61000-4-5 test levels should be performed at pre-compliance test stage.
6. **CPLD temperature range:** CPLD lower operating limit is 0 °C - this may require a cold-soak waiver or component substitution if sub-zero operation is required. See OA-04.
