# Enigma-NG — PoE Front-End Power Analysis: TDK B82806D0060A120 ACF Forward

**Date:** 2026-05-10
**Status:** Active — TDK B82806D0060A120 selected; see DEC-062
**Affected design document:** `design/Electronics/Controller/Design_Spec.md`
**Prior analysis (Coilcraft / ACF Flyback):** `design/Electronics/Controller/PoE_Power_Analysis_Coilcraft_v2.md`

---

## 1. Background

The Controller Board PoE front-end uses a two-stage architecture:

- **Stage 1 — PD Interface:** TPS2372-4RGWR (IEEE 802.3bt Type 4, 72W class)
- **Stage 2 — DC-DC Converter:** TPS23730RMTR ACF controller driving T1 isolation transformer

The DC-DC stage is designed as an **ACF Forward Converter**. The TPS23730 datasheet uses the label
"ACF Flyback"; TI application literature (e.g. PMP23253) and Google AI analysis confirm the
TPS23730 is equally compatible with an ACF Forward topology. The distinction matters for output
filtering: ACF Forward requires a buck-type output inductor (L1) after the secondary rectifier,
whereas ACF Flyback relies on transformer magnetising inductance for energy storage and does not
use a separate output inductor.

The selected transformer is the **TDK B82806D0060A120**. It is stocked at JLCPCB (C7218686),
DigiKey (495-76653-1-ND), and Mouser (871-B82806D0060A120). See DEC-062 for the selection rationale.

An earlier investigation evaluated the Coilcraft POE600F-12L in ACF Flyback mode; that design
is preserved in `PoE_Power_Analysis_Coilcraft_v2.md` and is deferred pending part availability.

---

## 2. TDK B82806D0060A120 — Electrical Parameters

| Parameter | Value |
| :--- | :--- |
| Manufacturer | TDK |
| MPN | B82806D0060A120 |
| Series | B82806D (EFD20 isolation transformer) |
| Package | EFD20 SMT 12-pin gullwing |
| Output voltage | 12V |
| Output current | 5A (60W) |
| Input voltage | 36–57V (PoE) |
| Turns ratio | Np:Ns:Naux = 2:1:1 (n = 2) |
| Primary inductance (Lm) | 100µH ±30% |
| Leakage inductance (Llk) | 0.18µH MAX |
| Primary DCR | 35mΩ |
| Secondary DCR | 8mΩ |
| Aux DCR | 160mΩ |
| Hipot (Pri–Sec) | 1500 Vac |
| JLCPCB assembly | ✔ C7218686 |
| PCB layout note | TDK datasheet permits solder bridges between pins 1–2 and pins 7–8 (intra-group within same net only; not primary-to-secondary). Confirm against footprint drawing during PCB layout phase. |

---

## 3. Duty Cycle Analysis (n = 2)

Formula: `D = n × (Vout + Vf) / (Vin + n × (Vout + Vf))`

Assuming: Vout = 12V, Vf = 0.4V (secondary rectifier), fsw = 200kHz.

| Vin | D (n=2) | TPS23730 window (5–75%) |
| :--- | :--- | :--- |
| 36V (min) | 40.8% | ✔ |
| 48V (nom) | 34.1% | ✔ |
| 57V (max) | 30.3% | ✔ |

All operating points are well within the TPS23730 duty cycle range.

---

## 4. TPS23730 VCC Derivation (Auxiliary Winding)

Turns ratio Naux:Ns = 1:1, therefore:

```text
V_aux = Vout × (Naux/Ns) = 12.0 × 1.0 = 12.0V
VCC   = V_aux − Vf_aux   = 12.0 − 0.4 = 11.6V
```

TPS23730 VCC operating range: 7–20V. Result: **11.6V ✔**

---

## 5. MOSFET Vds Stress

Formula: `Vds_peak = Vin_max + n × (Vout + Vf)`

```text
Vds_peak = 57 + 2 × (12.0 + 0.4) = 57 + 24.8 = 81.8V
```

MOSFET class required: ≥100V minimum; **200V with standard derating recommended.**
Selected device STD25NF20: Vds = 200V ✔ — no change required.

---

## 6. C17 — Active Clamp Capacitor Sizing

C17 sets the ACF clamp voltage. The clamp network recycles transformer leakage inductance energy
(E_Ls) into the Cclamp capacitor each switching cycle. The design target is ΔV_clamp ≤30%
of reflected output voltage.

### 6.1 Peak primary current (worst case: Vin = 36V)

```text
ΔI_Lm = Vin × D / (Lm × fsw) = 36 × 0.408 / (100µH × 200kHz) = 0.734A
I_pk   = Iout/n + ΔI_Lm/2    = 5/2 + 0.367 = 2.867A
```

Lm ±30% worst case (Lm_min = 70µH):

```text
ΔI_Lm_max = 36 × 0.408 / (70µH × 200kHz) = 1.048A
I_pk_max   = 2.5 + 0.524 = 3.024A  (+5.5% vs nominal)
```

Using worst-case Llk = 0.18µH MAX and I_pk = 2.867A (nominal):

```text
E_Ls = ½ × 0.18µH × 2.867² = ½ × 0.18 × 8.22 = 0.740µJ
```

Minimum C17 from resonant energy-recovery formula (DR-CTL-18):

```text
Cclamp_min = Llk × Ipk² / ΔVclamp²
```

Where:

- Llk = 0.18µH (worst-case MAX, TDK B82806D0060A120 datasheet)
- Ipk = 1.375A (TPS23730RMTR current-limit threshold, SLVSER6B §8.3)
- ΔVclamp = Vclamp − Vin_max = 61.14V − 57V = 4.14V (10% above Vin_max = 57V)

```text
Cclamp_min = 0.18µH × 1.375² / 4.14² = 0.18 × 1.891 / 17.14 = 0.3403µJ / 17.14 = 19.9nF
```

Next E24 value above 19.9nF: **22nF**. ✔

Voltage headroom check:

```text
Vclamp_peak = Vin_max + ΔVclamp = 57 + 4.14 = 61.14V
Vds_peak    = Vin_max + Vclamp_peak = 57 + 61.14 = 118.1V  (< 160V derating limit)
```

Dissipation check:

```text
P_clamp = ½ × Llk × Ipk² × fsw = ½ × 0.18µH × 1.891 × 200kHz = 0.034W  (negligible)
```

Selected: **C17 = 22nF (Kemet C0805C223K2RACAUTO, 22nF X7R 200V 0805)**

A 200V 0805 rating is required: worst-case Vclamp reaches 72V and X7R DC bias derating at 100V reduces effective capacitance below the 19.9nF minimum. See DR-CTL-18.

See DR-CTL-18 for the design requirement. See `design/Electronics/Controller/Design_Spec.md` BOM for
supplier PNs.

---

## 7. Output Filter

### 7.1 L1 — ACF Forward Output Inductor

The ACF Forward topology requires a buck-type inductor on the secondary rail. Lm stores energy
during the primary switch on-time and releases it to the secondary via transformer coupling; L1
provides the second energy storage element in the LC output filter.

L1 specification: 33µH, ≥6A Isat, DCR ≤50mΩ, shielded ferrite, SMT.

```text
ΔIL1 = (Vout × (1−D)) / (L1 × fsw)
      = 12 × (1 − 0.408) / (33µH × 200kHz)
      = 12 × 0.592 / 6.6 = 1.076A (ripple at Vin = 36V, D = 40.8%)
```

Peak-to-peak ripple: 1.076A / 5A = **21.5% ✔** (target ≤28%).

Selected: **Yageo PA4343.333NLT** (33µH, 6.5A Isat, 35mΩ typ / 57mΩ max DCR, 1265 shielded ferrite).
DCR note: Typ value (35mΩ) is within DR-CTL-25 (≤50mΩ); max value (57mΩ) marginally exceeds the DR.
Accepted at design phase: best available procurable part meeting all other parameters. See DR-CTL-25.

See DR-CTL-25 and `design/Electronics/Consolidated_BOM.md` for L1 details.

### 7.2 C20 — Output Capacitor

```text
Cout_min = Iout × D / (fsw × Vripple) = 5 × 0.408 / (200kHz × 0.12V) = 85µF
```

Standard: 100µF / 25V minimum. Selected: **4× TDK CGA9N3X7R1E476M230KB** (47µF × 4 = 188µF nominal).

Effective worst-case capacitance (DC bias at 12V + ±20% tolerance + temperature): ≥103µF ✔
ESR: ≤2.5mΩ total at 200kHz ✔. See DR-CTL-22.

---

## 8. Conduction Losses

### 8.1 RMS currents (Vin = 36V, D = 40.8%)

```text
I_pri_RMS = √(Iout²/n² + ΔI_Lm²/12) × √D
           ≈ √(6.25 + 0.045) × √0.408 = 2.510 × 0.639 = 2.70A (conservative approximation)

I_sec_RMS = Iout × √(1−D) = 5 × √0.592 = 5 × 0.769 = 6.50A
```

### 8.2 Winding losses

| Winding | RMS Current | DCR | P_cu |
| :--- | :--- | :--- | :--- |
| Primary | 2.70A | 35mΩ | 2.70² × 0.035 = 0.255W |
| Secondary | 6.50A | 8mΩ | 6.50² × 0.008 = 0.338W |
| **Total** | | | **0.593W (0.99% of 60W)** |

The low secondary DCR of the TDK B82806D (8mΩ vs 90mΩ for Coilcraft POE600F-12L) reduces winding
loss by ~3.3W compared to the original Coilcraft design.

---

## 9. Lm Tolerance Impact

TDK Lm tolerance: ±30%. Worst case: Lm_min = 70µH.

```text
ΔI_Lm_max = 36 × 0.408 / (70µH × 200kHz) = 1.048A  (+43% vs nominal 0.734A)
I_pk_max   = 2.5 + 0.524 = 3.024A  (+5.5% vs nominal 2.867A)
```

STD25NF20 pulsed drain current rating: 72A. I_pk_max well within device limits ✔.
Duty cycle variation with ±30% Lm: negligible (Lm appears in ripple only, not in steady-state
duty cycle at fixed Vout). No operating-point issues at Lm extremes.

---

## 10. Clamp Energy

Using Llk_max = 0.18µH and I_pk = 2.867A:

```text
P_clamp = E_Ls × fsw = 0.740µJ × 200kHz = 0.148W
```

Recycled to primary bus by ACF clamp network — not dissipated.

---

## 11. TDK vs Coilcraft Comparison Summary

| Parameter | TDK B82806D0060A120 | Coilcraft POE600F-12L |
| :--- | :--- | :--- |
| n (turns ratio) | 2:1:1 | 1.71:1 |
| Lm | 100µH ±30% | 100µH |
| Llk | 0.18µH MAX (published) | Not published |
| Primary DCR | 35mΩ | 39mΩ |
| Secondary DCR | **8mΩ** | **90mΩ** |
| Total winding loss | **0.593W (0.99%)** | **3.896W (6.49%)** |
| C17 value | 22nF | 47nF (conservative proxy) |
| Output inductor L1 | **Required** (ACF Forward) | Not required (ACF Flyback) |
| Topology | ACF Forward | ACF Flyback |
| JLCPCB C-number | C7218686 ✔ | Not available |
| DigiKey | 495-76653-1-ND ✔ | Not available |
| Mouser | 871-B82806D0060A120 ✔ | Not available |

---

## 12. ACF Forward Design Reference Equations

```text
Duty cycle:         D = n × (Vout + Vf) / (Vin + n × (Vout + Vf))
Vds stress:         Vds_peak = Vin_max + n × (Vout + Vf)
Aux winding VCC:    V_aux = Vout × (Naux/Ns);  VCC = V_aux − Vf_aux
Peak primary I:     I_pk  = Iout/n + ΔI_Lm/2
Lm ripple current:  ΔI_Lm = Vin × D / (Lm × fsw)
Clamp energy:       E_Ls  = ½ × Llk × I_pk²
Clamp voltage:      ΔV_clamp = E_Ls / (Cclamp × V_refl)
Output ripple (L1): ΔIL1  = Vout × (1−D) / (L1 × fsw)
Output capacitor:   Cout_min = Iout × D / (fsw × Vripple)
Primary RMS I:      I_pri_RMS ≈ √(Iout²/n² + ΔI_Lm²/12) × √D
Secondary RMS I:    I_sec_RMS ≈ Iout × √(1−D)
Conduction loss:    P_cu = I_RMS² × DCR
Clamp power:        P_clamp = E_Ls × fsw
```

---

## 13. Reference

- TI PMP23253 design (49.5W, TPS23730RMTR + ACF Forward, 36–57V PoE input)
- TDK B82806D0060A120 datasheet — `design/Datasheets/TDK-B82806D-datasheet.md`
- Design Log — DEC-062 (TDK selection and ACF Forward topology); DEC-019 (original Coilcraft decision)
