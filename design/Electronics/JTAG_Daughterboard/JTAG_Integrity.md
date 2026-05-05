# JTAG Signal Integrity - Analysis and Design Decision

**Status:** Adopted - see DEC-016 in `design/Design_Log.md`
**Project:** Enigma-NG
**Author:** Izzyonstage & GitHub Copilot
**Version:** v.0.1.0
**Date:** 2026-04-05
**Affects:** Controller, Stator, Encoder, Reflector, Extension, JTAG Daughterboard (JDB)

---

## 1. Background and Problem Statement

The Enigma-NG JTAG chain spans multiple PCBs using two distinct interconnect types:

* **Ribbon cable (IDC 2.54mm, ~100 Ω):** Stator → Encoder boards (J4-J9) - six fixed-role
  Encoder Modules in one serial chain: `KBD_ENC`, `LBD_DEC`, `PLG_PASS1_DEC`, `PLG_PASS1_ENC`,
  `PLG_PASS2_DEC`, and `PLG_PASS2_ENC`.
* **BtB connectors (ERM8/ERF8, Samtec 0.8mm pitch):** Stator rotor interface (J1-J3) → Rotor 1
  → ... → Rotor 30 → Reflector. All rotor-to-rotor, rotor-to-Extension, and rotor-to-Reflector
  connections are BtB. **No ribbon cables are used within the rotor stack for JTAG signals.**

During design review it was identified that no impedance specification existed for JTAG traces, and
no series termination resistors had been defined for the cable-driving outputs. This document analyses
all available options, calculates trace widths and resistor values per board stackup, and records the
design decision adopted.

### JTAG Chain Topology

```text
FT232H (JDB)
    |  U2 SN74LVC2G125DCUR buffer (TCK, TMS)
    |  R2/R3 33Ω after U2 output (TCK/TMS); R1 33Ω at FT232H TDI; R4 33Ω before J2 (TDI)
    ↓
J2 JTAG header → Controller hat-header (pass-through: no active components)
    ↓
Controller J5 ↔ Stator J12 logic dock (BtB, no cable)
    |
    ↓
Stator CPLD (U1)
    |
    |  TCK/TMS broadcast via R7-R12 / R33-R38 to J4-J9
    |  TDI serial chain via R27-R32 and one CPLD per Encoder Module:
    ↓
    J4 KBD_ENC (1 CPLD, local R6 = 75Ω on TDO cable output)
    ↓
    J5 LBD_DEC (1 CPLD, local R6 = 75Ω on TDO cable output)
    ↓
    J6 PLG_PASS1_DEC (1 CPLD, local R6 = 75Ω on TDO cable output)
    ↓
    J7 PLG_PASS1_ENC (1 CPLD, local R6 = 75Ω on TDO cable output)
    ↓
    J8 PLG_PASS2_DEC (1 CPLD, local R6 = 75Ω on TDO cable output)
    ↓
    J9 PLG_PASS2_ENC (1 CPLD, local R6 = 75Ω on TDO cable output)
    ↓
    Rotor Stack - ALL via BtB (ERM8/ERF8 0.8mm pitch, no ribbon cable)
            |  Stator J1-J3 (ERM8 male) --→ Rotor 1-5 CPLDs (ERF8→ERM8 BtB chain)
            |                                     |
            |                               Extension board
            |                               U1: SN74LVC2G125DCUR re-buffers TCK/TMS
            |                               (repeated at every 5-rotor group boundary)
            |                                     |
            |                               Rotor 6-10 ... Rotor 26-30 CPLDs (BtB)
            |                                     |
            |                               Reflector (ERM8 J1-J3 plugs into Rotor 30 ERF8 J4-J6)
            |                               *** JTAG CHAIN END ***
            |                               R1 22Ω - end-of-chain TDO series damping
            |
            +-→ TTD_RETURN ribbon: Reflector J4 pin 16 --→ Stator J10 pin 16
                (J4 also carries `ENC_OUT_REF[5:0]` on pins 7-12 and `ENC_IN_REF[5:0]` on pins 19-24 for
                 the Stator CPLD reflector-boundary path - these are NOT part of the JTAG chain)
                Stator J10 → Controller-facing `J5/J12` `TTD_RETURN` path → FT232H
```

**TCK and TMS** are broadcast to all devices. On the Stator they fan out to:

* J4, J5, J6, J7, J8, J9 (encoder ribbon cable ports) - each requires its own 75 Ω series
  resistor before
  the ribbon cable.
* J1-J3 (rotor BtB interface) - TCK/TMS are re-buffered by U1 (SN74LVC2G125DCUR) on each
  Extension board at every 5-rotor group boundary. The direct BtB rotor-stack path does **not**
  add extra series resistors at each hop.

**TDI/TDO** are serial-chained. For **ribbon cable segments** each cable-driving output needs a
75 Ω series resistor. For the **BtB rotor stack**, TDI flows unbuffered board-to-board; the chain
ends at the passive Reflector turnaround. TDO exits as TTD_RETURN via Reflector R1 (22 Ω
end-of-chain damping) and returns to the Stator on the dedicated ribbon cable (Reflector J4 →
Stator J10).

> ⚠️ **Do not confuse the Reflector J4 ribbon cable with the JTAG chain.** The ribbon carries
> TTD_RETURN (JTAG TDO return, pin 16) AND ENC_IN/ENC_OUT (plugboard configuration, ENC_OUT_REF pins 7-12 / ENC_IN_REF pins 19-24).
> The ENC signals are a separate Stator CPLD interface for configuring plugboard pass positions.
> The JTAG chain terminates at the Reflector - it does NOT continue on this ribbon cable.

**SYS_RESET_N** is a very low-frequency quasi-DC signal (transitions only on system reset events).
Transmission line effects are negligible; no series resistor required.

---

## 2. Signal Characteristics

| Signal | Direction | Type | JTAG frequency | Rise time (EPM240) |
| --- | --- | --- | --- | --- |
| TCK | FT232H → all CPLDs | Clock (broadcast) | 1-10 MHz | ~2-3 ns |
| TMS | FT232H → all CPLDs | State (broadcast) | Transitions with TCK | ~2-3 ns |
| TDI | FT232H → CPLD chain | Serial data | Stable on TCK edge | ~2-3 ns |
| TDO | CPLD chain → FT232H | Serial data | Stable on TCK edge | ~2-3 ns |
| SYS_RESET_N | CM5 → all CPLDs | Active-low reset | DC / rare | N/A |

---

## 3. Physical Parameters by Board Stackup

### 3.1 4-Layer 1.6mm FR4 - Stator, Encoder, Rotor, Reflector, Extension, JTAG Daughterboard (JDB)

> For authoritative PCB stackup parameters, see `design/Standards/Global_Routing_Spec.md §2`.

| Parameter | Value | Source |
| --- | --- | --- |
| Prepreg (L1→L2) | 2116 style | JLCPCB stackup document |
| Dielectric height h | **0.087 mm** | Verified: JLCPCB calculator gives 50Ω at 0.127mm for this stackup |
| Copper thickness t | 0.035 mm (1oz outer) | Standard |
| Dielectric constant Eᵣ | 4.4 | FR4 2116 prepreg |
| JTAG layer | L1 (top) - microstrip over L2 GND plane | See note below |
| Manufacturing minimum trace width | 0.127 mm (5 mil) | JLCPCB standard process |

> **Why L1?** On the JLC04161H-7628 stackup, L2 (GND) and L3 (3V3_ENIG power) are solid planes
> dedicated to their functions - they are not available as signal layers. This leaves L1 (top) and
> L4 (bottom) as the only signal layers. L1 over L2 GND provides the tightest dielectric coupling
> (h = 0.087 mm) and the best achievable controlled impedance. L4 over L3 (power plane) is
> functionally acceptable but less ideal. **L1 is therefore the mandatory JTAG routing layer on
> all 4-layer boards.** This decision is EMC-optimal for this stackup: the contiguous L2 GND plane
> immediately below L1 provides consistent return-current path and low radiated-field coupling.
> **Exception:** the JTAG Daughterboard (JDB) uses an inverted stackup (L1=GND/SMT, L2=signals,
> L3=Power, L4=GND) to orient SMT components toward the Controller Board when mounted as a hat.
> On the JDB, JTAG signals are routed on L2 over the L1 GND reference plane. See
> `design/Electronics/JTAG_Daughterboard/Design_Spec.md §4` and DEC-017.
>
### 3.2 6-Layer 1.6mm FR4 - Controller

> For authoritative PCB stackup parameters, see `design/Standards/Global_Routing_Spec.md §2`.

| Parameter | Value | Source |
| --- | --- | --- |
| Prepreg (L5→L6) | 2116 style | JLCPCB 6-layer stackup |
| Dielectric height h | **~0.087 mm** | Similar outer prepreg to 4-layer; same calculator result |
| Copper thickness t | 0.035 mm (1oz outer) | Standard |
| Dielectric constant Eᵣ | 4.4 | FR4 2116 |
| JTAG layer | L6 (bottom) - microstrip over L5 GND plane | Per Controller stackup spec |
| Manufacturing minimum | 0.127 mm (5 mil) | JLCPCB standard process |

### 3.3 2-Layer 1.6mm FR4 - Historical Reference (Superseded by DEC-017)
>
> **Note:** The Reflector and Extension boards originally used a 2-layer stackup. DEC-017 upgrades
> all non-Controller boards to 4-layer JLC04161H-7628. The calculations in §4 below for 2-layer
> boards are retained for historical reference only. These boards now use the §3.1 parameters.

| Parameter | Value | Notes |
| --- | --- | --- |
| Dielectric height h | **1.53 mm** | Full board thickness minus both copper layers |
| Copper thickness t | 0.035 mm (1oz) | Standard |
| Dielectric constant Eᵣ | 4.4 | FR4 |
| JTAG layer | L1 - microstrip over any L2 GND pour | **Superseded** - no solid GND plane in former 2-layer design |

---

## 4. Impedance Formula (IPC-2141A Microstrip)

```text
Z₀ = (87 / √(Eᵣ + 1.41)) x ln(5.98h / (0.8w + t))

Where:
  Z₀  = characteristic impedance (Ω)
  Eᵣ  = dielectric constant of prepreg
  h   = dielectric height, copper-to-copper (mm)
  w   = trace width (mm)
  t   = copper thickness (mm)
```

For the 4-layer/6-layer outer-layer stackup (h = 0.087 mm, t = 0.035 mm, Eᵣ = 4.4):

```text
K = 87 / √(4.4 + 1.41) = 87 / √5.81 = 87 / 2.410 = 36.1
```

### Solving for 50Ω (w = ?)

```text
50 = 36.1 x ln(5.98 x 0.087 / (0.8w + 0.035))
50 = 36.1 x ln(0.520 / (0.8w + 0.035))
1.385 = ln(0.520 / (0.8w + 0.035))
3.994 = 0.520 / (0.8w + 0.035)
0.8w + 0.035 = 0.130
w = 0.119 mm → rounded to 0.127 mm (5 mil) for design rule consistency
```

✔ **0.127 mm is achievable** (JLCPCB minimum = 0.127 mm; confirmed by their online calculator)

> **Note on copper weight:** The IPC-2141A formula uses t = base copper thickness before plating.
> JLCPCB's 2oz finished specification starts from 1oz (t=0.035mm) base copper plus plating.
> Using t=0.035mm in the formula is correct for the geometric model. Actual finished Zo with
> 2oz plating build-up is approximately 40-50Ω depending on plating thickness. At JTAG operating
> frequencies of 1-10MHz, this variance is functionally tolerable; the 33Ω series resistors
> provide additional mismatch absorption.
>
### Solving for 100Ω (w = ?)

```text
100 = 36.1 x ln(0.520 / (0.8w + 0.035))
2.770 = ln(0.520 / (0.8w + 0.035))
15.96 = 0.520 / (0.8w + 0.035)
0.8w + 0.035 = 0.0326
0.8w = -0.0024   →   NEGATIVE - physically impossible
```

❌ **100Ω single-ended is not achievable** on this stackup. The thin 0.087 mm prepreg
(required for component density in 4-layer/6-layer boards) constrains the geometry such
that 100Ω would require a trace narrower than 0 mm. This is a fundamental physics constraint,
not a manufacturer limitation.

### 2-Layer Board - 50Ω Calculation (h = 1.53 mm)

```text
50 = 36.1 x ln(5.98 x 1.53 / (0.8w + 0.035))
50 = 36.1 x ln(9.15 / (0.8w + 0.035))
1.385 = ln(9.15 / (0.8w + 0.035))
3.994 = 9.15 / (0.8w + 0.035)
w = 2.82 mm
```

❌ **2.82 mm trace - impractical** for signal routing on a space-constrained PCB.
Controlled impedance is not specified for 2-layer boards (Reflector, Extension).

### 2-Layer Board - 100Ω Calculation (h = 1.53 mm)

```text
100 = 36.1 x ln(9.15 / (0.8w + 0.035))
2.770 = ln(9.15 / (0.8w + 0.035))
15.96 = 9.15 / (0.8w + 0.035)
w = 0.538 mm
```

⚠️ **0.538 mm (21 mil) - achievable** but not useful here. The Reflector and Extension boards
have been upgraded to 4-layer JLC04161H-7628 per DEC-017 and now have a solid L2 GND plane;
the 2-layer calculation above is retained for historical reference only. At JTAG frequencies
(1-10 MHz), even the longest traces are well below the λ/6 critical threshold (~100 mm for 3 ns
rise time). Series termination resistors at the driving ends of each ribbon cable segment are
sufficient; the rotor BtB stack is terminated at the Reflector end-of-chain (R1 22 Ω).

---

## 5. Ribbon Cable Impedance

Standard 2.54 mm pitch IDC flat ribbon cable has the following impedance characteristics:

| Configuration | Approx. Zo | Notes |
| --- | --- | --- |
| All-signal (no interleaved GND) | 130-150 Ω | Worst case; no shielding |
| Alternating signal/GND | **~100 Ω** | Confirmed by Belden/3M cable datasheets |
| Shielded ribbon (overall foil) | ~100 Ω | Foil improves EMI; minimal Zo change |

The Enigma-NG 20-pin encoder port connector specifies **alternating GND pins between all JTAG
signals** (J4-J9 pin table in `design/Electronics/Stator/Board_Layout.md`). This places the cable Zo at approximately
**100 Ω**.

> **Key implication:** The PCB-to-cable impedance discontinuity is from 50 Ω (PCB trace) to 100 Ω
> (ribbon cable). This mismatch can be minimised by sizing the series resistor to target the **cable
> impedance** rather than the PCB trace impedance.

---

## 6. Options Analysis

### CPLD Output Driver Impedance

The Intel MAX II EPM240T100I5N has a typical I/O output impedance (Zo_driver) of approximately
**15-20 Ω** in its 3.3V LVTTL drive mode. For calculations below, **Zo_driver = 20 Ω** is used.

---

### Option A - No Series Termination (Baseline)

```text
Source impedance = 20 Ω (driver alone)
PCB trace Zo     = uncontrolled (~50-150 Ω depending on routing)
Cable Zo         = ~100 Ω
Mismatch at PCB→cable: significant
Re-reflection at source: severe (20 Ω vs 100 Ω → Γ = -0.67)
```

**Result:** Multiple round-trip reflections, potentially 20-50% overshoot, visible ringing on TCK.
At 10 MHz with 3 ns rise times, false clock edges are possible on longer cables.

❌ **Not recommended.**

---

### Option B - 50Ω PCB + 33Ω Series Resistor (Match PCB Trace)

```text
Series R        = 33 Ω
Total source Z  = 20 + 33 = 53 Ω ≈ 50 Ω (matched to PCB trace)
PCB trace Zo    = 50 Ω (controlled, 0.127 mm)
```

**At PCB→cable transition (50 Ω → 100 Ω):**

```text
Γ_forward = (100 - 50) / (100 + 50) = +0.33   (33% reflection toward source)
```

**Returning reflection hits source (53 Ω):**

```text
Γ_source = (50 - 53) / (50 + 53) ≈ 0.0   (reflection almost fully absorbed ✔)
```

**At cable end (high-Z CPLD input):**

```text
V_launched onto cable = 3.3 x 100 / (53 + 100) = 2.16 V  (on first wave)
V_at_destination = V_launched + reflected = 2.16 + (0.33 x 2.16) ≈ 2.87 V
```

⚠️ The destination sees a slightly reduced first swing (~2.87 V) before settling to 3.3 V after one
round trip (~5-10 ns). Functionally correct, but the cable-entry reflection is not absorbed.

**Conclusion:** Good on-board signal integrity. Cable mismatch creates an unabsorbed reflection that
travels to the source, gets absorbed, but leaves a partial glitch on the cable during settling.

⚠️ **Acceptable, but not optimal for cable-driving outputs.**

---

### Option C - 100Ω PCB + 82Ω Series Resistor (Ideal - Not Achievable)

```text
Series R        = 82 Ω
Total source Z  = 20 + 82 = 102 Ω ≈ 100 Ω (matched to cable)
PCB trace Zo    = 100 Ω - REQUIRES w ≈ -0.002 mm (impossible)
```

If achievable, this would give perfect PCB-to-cable impedance matching with zero reflection at the
cable entry. The signal at the destination would still reach full logic swing via the open-end
reflection (V_dest = 2 x V_launched = 2 x 1.65 V = 3.30 V ✔).

❌ **Not achievable** on JLCPCB JLC04161H-7628 or JLC06161H-2116 stackups.
See §4 trace width calculation.

---

### Option D - 50Ω PCB + 75Ω Series Resistor (Selected)

This approach decouples PCB trace impedance from source termination. The **series resistor targets
the cable impedance (100 Ω)** rather than the PCB trace impedance (50 Ω).

```text
Series R        = 75 Ω
Total source Z  = 20 + 75 = 95 Ω ≈ 100 Ω (matched to cable Zo)
PCB trace Zo    = 50 Ω (controlled, 0.127 mm - achievable)
```

**At PCB→cable transition (50 Ω → 100 Ω):**

```text
Γ_forward = (100 - 50) / (100 + 50) = +0.33   (33% reflection toward source)
```

**Returning reflection hits source (95 Ω):**

```text
Γ_source = (50 - 95) / (50 + 95) = -0.31   (31% re-reflected, with inversion)
```

The PCB-to-cable discontinuity is not perfectly eliminated, but the return reflection at the source
(-0.31) dampens successive bounces rapidly. Each successive wave is attenuated by 0.31², 0.31³ etc.

**Signal swing at destination (high-Z CPLD input):**

```text
V_launched onto cable = 3.3 x 100 / (95 + 100) = 1.69 V
V_at_destination = 2 x V_launched = 2 x 1.69 = 3.38 V ≈ 3.3 V  ✔  (full logic swing)
```

The open-circuit reflection at the CPLD input doubles the wave back to full logic swing. The
destination always sees full voltage - the series resistor does not weaken the received signal.

**Short same-board / BtB traces (no ribbon cable):**

For traces that do NOT drive a ribbon cable (e.g., JDB U2 output → Controller `J5` / Stator `J12`
logic dock), the system is 50 Ω PCB throughout. Use **33 Ω series R** (source Z = 53 Ω ≈ 50 Ω,
matched to PCB). The Encoder Module now has **one CPLD only**, so it has no inter-CPLD JTAG segment.

**Critical length check (do these traces actually need termination?):**

```text
Critical trace length = (Rise time x propagation speed) / 6
                      = (3 ns x 200 mm/ns) / 6  =  100 mm
```

At typical JTAG trace lengths on a PCB (<50 mm), intra-board traces are electrically short and
the 33 Ω resistor provides protection and slew-rate control rather than strict termination. At
cable lengths of 200-500 mm the 75 Ω resistors are functionally necessary.

✔ **Option D is the selected solution.** See DEC-016 for formal adoption.

---

### Option Summary Table

| Option | PCB Zo | Series R | Source Z | Cable Zo match | PCB-trace match | Achievable? | Verdict |
| --- | --- | --- | --- | --- | --- | --- | --- |
| A - No termination | Uncontrolled | None | 20 Ω | ❌ Poor | ❌ Poor | Yes | Rejected |
| B - Match PCB | 50 Ω | 33 Ω | 53 Ω | ⚠️ Partial | ✔ Excellent | Yes | Acceptable |
| C - Match cable (ideal) | 100 Ω | 82 Ω | 102 Ω | ✔ Excellent | ✔ Excellent | **No** | Not possible |
| **D - Hybrid (selected)** | **50 Ω** | **75 Ω (cable) / 33 Ω (intra-board)** | **95 Ω / 53 Ω** | **✔ Good** | **✔ Good** | **Yes** | **Selected** |

---

## 7. Component Values and Placement

### 7.1 Series Resistor Values

| Placement | R value | Rationale |
| --- | --- | --- |
| Driving a ribbon cable (~100 Ω IDC) | **75 Ω** | Source Z = 95 Ω ≈ cable Zo |
| Short same-board / BtB 50 Ω trace | **33 Ω** | Source Z = 53 Ω ≈ PCB Zo |
| JDB U2 output → Controller `J5` / Stator `J12` logic dock (BtB, no cable) | **33 Ω** | Short BtB trace; match 50 Ω PCB; U2 out Z (15Ω) + 33Ω ≈ 48Ω |
| Rotor stack TDO end-of-chain (Reflector R1) | **22 Ω** | Final TDO output - lower R sufficient; verified by Reflector DR-REF-04 |

### 7.2 Placement Rule

Series resistors must be placed **within 2 mm of the driving pin** (CPLD output or buffer output).
Placing the resistor close to the source ensures reflections are absorbed before travelling any
distance on the trace.

### 7.3 Signals Requiring Series Resistors

| Signal | Ribbon cable segment | Intra-board / BtB | Notes |
| --- | --- | --- | --- |
| TCK | 75 Ω (at each Stator encoder port output, J4-J9) | Re-buffered by Extension U1 every 5-rotor group | Clock - most critical |
| TMS | 75 Ω (at each Stator encoder port output, J4-J9) | Re-buffered by Extension U1 every 5-rotor group | State machine control |
| TDI | 75 Ω (at each Stator-driven encoder cable segment) | Passes unbuffered via BtB in rotor stack | Chained data |
| TDO | 75 Ω (at each Encoder U1 → cable output) | 22 Ω (Reflector R1, end-of-chain) | Return chain data |
| SYS_RESET_N | None required | None required | Quasi-DC signal |

> **Rotor stack BtB path:** TCK and TMS are re-buffered by U1 (SN74LVC2G125DCUR) on each Extension
> board at every 5-rotor group boundary - no per-rotor termination required. TDI passes unbuffered
> board-to-board via BtB. The JTAG chain terminates at the Reflector; Reflector R1 (22 Ω) provides
> end-of-chain TDO damping. TTD_RETURN then returns to the Stator via the Reflector J4 ribbon cable.
>
> **Encoder chain (ribbon cable):** The six encoder ports (J4/J5/J6/J7/J8/J9) on the Stator form one
> serial six-module JTAG chain ahead of the rotor stack. 75 Ω series resistors (R7-R12, R27-R32,
> and R33-R38 on Stator; R6 on each Encoder board) apply ONLY to these ribbon cable segments. They
> are NOT present on or applicable to the rotor BtB stack.
>
### 7.4 Per-Board Implementation

| Board | New refs | Value | Qty | Location |
| --- | --- | --- | --- | --- |
| JDB | R1 | 33 Ω | 1 | TDI termination/pull at FT232H TDI output - maintains defined TDI signal state and provides source damping on the JDB TDI network |
| JDB | R2 | 33 Ω | 1 | TCK after U2 buffer, before J2 JTAG header pin 1 (TCK) |
| JDB | R3 | 33 Ω | 1 | TMS after U2 buffer, before J2 JTAG header pin 7 (TMS) |
| JDB | R4 | 33 Ω | 1 | TDI series damping (not buffered - from FT232H), before J2 JTAG header pin 3 (TDI) |
| Stator | R7-R12 | 75 Ω | 6 | TCK → J4/J5/J6/J7/J8/J9 encoder ribbon port outputs |
| Stator | R33-R38 | 75 Ω | 6 | TMS → J4/J5/J6/J7/J8/J9 encoder ribbon port outputs |
| Stator | R27-R32 | 75 Ω | 6 | TDI chain drive: Stator CPLD TDO → J4; J4 return → J5; J5 return → J6; J6 return → J7; J7 return → J8; J8 return → J9 |
| Encoder | R6 | 75 Ω | 1 per board | U1 TDO → J2 connector pin 13 (ribbon drive back to Stator) |
| Reflector | R1 (existing) | 22 Ω | 1 | TDO end-of-chain series damping - JTAG chain END |

> **Controller JTAG pass-through:** The Controller board carries no active JTAG components. All
> buffering (U2 SN74LVC2G125DCUR) and series damping (R1-R4, 33 Ω 0402) are located on the JDB.
> R1 is a termination/pull resistor at the FT232H TDI output; R2 and R3 damp TCK and TMS after the U2 buffer;
> R4 provides series damping on TDI before J2.
> The Controller `J5` ↔ Stator `J12` logic dock is a direct BtB connection (no cable), so 33 Ω
> applies there (not the 75 Ω cable-driving rule). See DEC-024.
>
> **Reflector and Extension:** Upgraded to 4-layer JLC04161H-7628 per DEC-017. Both boards now
> have a solid L2 GND plane. JTAG traces route on L1 at 0.127 mm (50 Ω controlled impedance),
> consistent with all other 4-layer boards. The "uncontrolled impedance" note from DEC-016 is
> superseded.

---

## 8. Trace Width Design Rule

| Board | Stackup | JTAG Layer | Target Zo | Trace width | Status |
| --- | --- | --- | --- | --- | --- |
| JDB | JLC04161H-7628 (4L) | L2 over L1 GND | 50 Ω | **0.127 mm (5 mil)** | JDB is the complete JTAG master. U2 buffer and R1-R4 series damping on JDB. R1: TDI termination/pull at FT232H output. Controller is pass-through. |
| Controller | JLC06161H-2116 (6L) | L6 over L5 GND | 50 Ω | **0.127 mm (5 mil)** | Pass-through only - no active JTAG components on Controller (see DEC-024) |
| Stator | JLC04161H-7628 (4L) | L1 over L2 GND | 50 Ω | **0.127 mm (5 mil)** | CPLD JTAG routing on L1; R7-R12, R27-R38 series resistors per §7.4 |
| Encoder | JLC04161H-7628 (4L) | L1 over L2 GND | 50 Ω | **0.127 mm (5 mil)** | CPLD JTAG routing on L1; R6 (75 Ω) TDO cable output per §7.4 |
| Reflector | JLC04161H-7628 (4L) | L1 over L2 GND | 50 Ω | **0.127 mm (5 mil)** | Updated per DEC-017 |
| Extension | JLC04161H-7628 (4L) | L1 over L2 GND | 50 Ω | **0.127 mm (5 mil)** | Updated per DEC-017. U1 (SN74LVC2G125DCUR) re-buffers TCK/TMS at rotor group boundary. |

---

## 9. Cost Analysis

| Item | Unit cost | Qty (full system) | Total |
| --- | --- | --- | --- |
| 75 Ω 1% 0603 (Stator R7-R12, R27-R38) | ~£0.002 | 18 | <£0.04 |
| 75 Ω 1% 0402 (Encoder R6, x6 boards) | ~£0.001 | 6 | <£0.01 |
| 33 Ω 1% 0402 (JDB R2-R4) | ~£0.002 | 3 | <£0.01 |
| Controlled impedance JLCPCB certification (optional) | ~£40/order | Per board type | ~£120 total if verified |
| **Controlled impedance design only (self-calc, no cert)** | **£0** | - | **£0** |

> **Recommendation:** Specify the 0.127 mm trace width in design rules. Do not pay for JLCPCB
> impedance verification on prototype boards - the self-calculated value is within ±10% of the
> target, which is well within the functional margin for 1-10 MHz JTAG signals. Impedance
> certification adds value only for production runs where consistency must be guaranteed.
>
> **Total additional BOM cost per full system: < £0.06** (a few tens of passive resistors).

---

*Decision formally recorded as DEC-016 in `design/Design_Log.md`.*
