## DEC-069 - PM Per-Input Polyfuse Protection and UVLO Resistor Recalculation

| Field | Value |
| :--- | :--- |
| **Decision ID** | DEC-069 |
| **Status** | Confirmed |
| **Date** | 2026-05-14 |
| **Author** | Izzyonstage & Copilot |
| **Amends** | DR-PM-06 (UVLO threshold updated); adds DR-PM-19 |

### Context

Following integration of per-input OR-ing (LM74700) and the Iron Curtain choke filter (L1/L2), a
question was raised about whether each input requires polyfuse (PPTC) protection upstream of the
OR-ing stage for CE/UKCA compliance. The device is intended as a classroom learning tool with
aspirational military-standard reliability in keeping with the historical Enigma machine reference -
both CE marking and UKCA marking are required.

Additionally, adding series polyfuses between each input and the eFuse (U1) changes the effective
voltage at the TPS259804 EN_UVLO divider pin under load, because the polyfuse's hold-state
resistance introduces a series voltage drop. This required recalculation of R1 (`R_UVLO_HI`) to
preserve the intended system-level UVLO threshold of approximately 11V at the source.

### Decision

**D1 - Per-input polyfuse:** Each of the three input paths (VIN_POE_12V, Battery, USB-C) shall have
a Bel Fuse 0ZRB0600FF1A polyfuse placed series upstream of the corresponding LM74700 OR-ing
controller:

- **F2** - VIN_POE_12V path
- **F3** - Battery path
- **F4** - USB-C path

Specification: 6A hold current / 12A trip current, THT package, ≤40 mΩ hold-state resistance,
AEC-Q200 qualified. F1 (AC72ABD, Bourns battery thermal cutoff) is unaffected - it is
laser/spot-welded to the battery cell tabs and not PCB-mounted.

No qualifying SMD part was found meeting all criteria (6A hold, 12A trip, AEC-Q200, ≥24V rating).
THT package selected accordingly.

**D2 - UVLO resistor recalculation:** R1 (`R_UVLO_HI`) shall be changed from 232kΩ (ERJ-3EKF2323V)
to 226kΩ (ERJ-3EKF2263V) to compensate for the polyfuse series voltage drop.

Calculation: At maximum PM load (5.35A), the polyfuse drop = 5.35A × 40mΩ = 0.214V. This reduces
the voltage at the eFuse EN_UVLO pin when the source is at the 11V system UVLO threshold. Setting
the eFuse pin threshold to 10.786V preserves the effective source-level UVLO at ≈11V.

R1_new = R2 × (V_UVLO_pin / V_REF − 1) = 28.7kΩ × (10.786 / 1.224 − 1) ≈ 226kΩ (E96).

R2 (28.7kΩ, ERJ-3EKF2872V) is unchanged. OVLO is silicon-fixed at 16.9V and is unaffected.

**D3 - OVLO:** No change required. The OVLO threshold is silicon-fixed in the TPS259804 at 16.9V
and does not depend on the R1/R2 divider.

### Rationale

CE and UKCA compliance require overcurrent protection on each input to ensure a source-side short
cannot propagate damage to other system components. A polyfuse (PPTC) provides resettable
overcurrent protection consistent with the educational/serviceable intent of the device.

The UVLO recalculation is necessary to maintain the system-level protection intent. Without it, the
eFuse would unlatch at ≈11.21V (source) rather than ≈11V, slightly narrowing the valid input
window. With R1 = 226kΩ the UVLO fires at ≈11V at the source, which is unchanged from the
original design intent.

### Precedence

1. **CE Directive 2014/35/EU (Low Voltage Directive):** Requires adequate overcurrent protection for
   electrical equipment placed on the EU market.
2. **UKCA SI 2016/1101 (Electrical Equipment Safety Regulations):** UK equivalent of LVD; requires
   same overcurrent protection.
3. **BS EN 60950-1 / IEC 62368-1:** Specifies overcurrent protection requirements for IT and
   audio/video equipment.
4. **Bel Fuse 0ZRB Series datasheet:** AEC-Q200 qualified, rated for harsh automotive environments;
   confirms suitability for ruggedised classroom/military-reference application.

### Input Current Derivation

System power demand at VIN_BUS (input to eFuse U1):

| Load | Rail | Worst-Case Current |
| :--- | :--- | :--- |
| 5V_MAIN (CM5, LDO, USB/HDMI, servos, misc) | 5 V | 9.50 A |
| Supercap soft-charge (LTC3350, 0.5 A limit) | 5 V | 0.50 A |
| **Total output power** | 5 V | **10.0 A → 50 W** |

Buck converter efficiency: η = 85% conservative (LMQ61460 datasheet typical: 87-90% at 9 A,
12 V→5 V; 85% gives a safe margin for calculation purposes).

Input current per source (single source supplying full system; OR-ing passes one source at a time):

| Source | V_in | I_in = 50 W ÷ (V_in × 0.85) | Note |
| :--- | :--- | :--- | :--- |
| PoE (CTL-derived) | 12 V nominal | 4.90 A | CTL auxiliary output regulated |
| PoE (at UVLO threshold) | 11 V min | **5.35 A** | eFuse UVLO = 11 V |
| USB-C (STUSB4500 negotiated) | 15 V fixed | 3.92 A | Negotiated PDO; stays within 16.9 V OVLO |
| Battery (4S LiPo nominal) | 14.8 V | 3.98 A | Mid-state of charge |
| Battery (at UVLO threshold) | 11 V min | **5.35 A** | Battery cutoff ≈ 11 V (2.75 V/cell × 4) |
| Battery (max charge) | 16.4 V | 3.60 A | 4.1 V/cell × 4 |

Design worst case: **5.35 A continuous at 11 V** (PoE minimum or battery at cutoff).
Polyfuse hold current requirement with ≥12% margin: **I_hold_min = 6.0 A**.

Cross-check against eFuse U1 (TPS259804ONRGER, ILIM = 7 A):

- At normal operating load (≤5.35 A): polyfuse at ≤89% of I_hold - stable, no nuisance trip.
- At eFuse trip level (7 A): eFuse trips first; 7 A < 12 A polyfuse trip - correct layer ordering.
- At connector hard-short: current ramps rapidly above 12 A → polyfuse trips; eFuse also trips as
  a backup - double protection as intended.

The two layers are complementary: eFuse guards the post-OR-ing VIN_BUS against load-side faults;
polyfuses guard each individual connector/cable against source-side faults.

### USB-C PD and EN 62368-1 §6.4.3

The STUSB4500 USB PD controller negotiates a 15 V/3.33 A (50 W) PDO. Its current limit is
**firmware-programmed into device EEPROM** - not a physically hard-wired current limiter.

EN 62368-1 §6.4.3 requires a *current-limiting protector* (CLP) that operates **independently
of software or firmware**. A PD-negotiated current cap does not qualify as a CLP. Physical
polyfuse F4 is therefore required on the USB-C input regardless of the STUSB4500 setting.

### Standards Applicability

**CE / UKCA (mandatory):**

| Standard | Relevance | Satisfied By |
| :--- | :--- | :--- |
| EN 62368-1:2020 §6.4.3 | Per-input current-limiting protector (CLP) required | F2, F3, F4 polyfuses |
| EN 62368-1:2020 §6.2 | ES2 energy source at 12-15 V - physical protection required | Above CLP satisfies |
| IEC 60950-1:2005 §6.3 | Legacy IT equipment overcurrent protection | Covered by EN 62368-1 |
| UKCA SI 2016/1101 Sch 1 | Mirrors EN 62368-1 post-2024 transition | Same as EN 62368-1 |
| BS EN 60335-1 Annex G | Resettable protective device acceptable in lieu of one-shot fuse | PTC is acceptable format |

**Military (best-effort - full certification not required or planned):**

| Standard | Relevance | Status |
| :--- | :--- | :--- |
| DEF STAN 59-411 (UK) | UK military EMC - radiated and conducted emissions/susceptibility | Design intent |
| MIL-STD-461G (US) | US military EMC; equivalent reference standard - passive PTCs introduce no switching noise | Compatible |
| MIL-STD-1275E | 28 V DC military vehicle bus - per-input fuse on each source is standard practice | Establishes precedent |
| MIL-HDBK-217F | Reliability prediction - passive PTC devices have well-characterised MTBF data | Polyfuses improve system MTBF |

Per-input passive PTCs align with MIL-STD-1275E per-source fusing principles and will be cited
in the CE Technical Construction File as demonstrating military-grade design intent.

### Voltage Rating Selection

Initial guidance from the polyfuse sourcing research proposed 33V-rated parts to cover USB-C EPR
(Extended Power Range) headroom. This was revised to a 24V minimum for the following reasons:

1. **STUSB4500 cannot negotiate EPR.** The USB PD controller is factory-programmed as a fixed
   15V/3.33A sink. EPR (28V-48V) negotiation is not supported; the maximum PDO voltage on this
   input path is 15V.

2. **Battery transient analysis.** A 4S LiPo charges to 4.1V/cell maximum = 16.4V. Applying a
   conservative 20% transient overshoot margin: 16.4V × 1.2 = 19.7V. This sets the absolute
   hard minimum at 20V for any part placed on the battery or shared VIN input paths.

3. **24V minimum with margin.** 24V provides ≈4.3V headroom above the 19.7V transient peak,
   an adequate derating for a non-switching passive series element.

The chosen part (Bel Fuse 0ZRB0600FF1A) is rated 30VDC, which satisfies the 24V minimum
requirement with a further 6V margin and aligns with the AEC-Q200 qualification requirement.

No SMD PTC combining 6A hold current, AEC-Q200 qualification, and ≥24V rating was found available
from the selected suppliers. THT format was therefore selected as the only viable package option.

### Thermal Derating

The Bel Fuse 0ZRB0600FF1A holds 6.0 A at 25°C. At 85°C the datasheet thermal derating factor
is 44%, giving an effective hold current of **I_H_eff = 6.0 × 0.44 = 2.64 A**.

> ⚠️ If the PM enclosure sustained ambient temperature exceeds approximately 70°C, the effective
> hold current falls below the 5.35 A worst-case operating current and nuisance trips may occur at
> full load. Maximum sustained PM enclosure ambient temperature must be confirmed during thermal
> validation to ensure reliable operation at full system load.

### Files Changed

- `design/Electronics/Power_Module/Design_Spec.md` - DR-PM-06 Cross-Ref updated (R1 226kΩ);
  DR-PM-19 added; mermaid block diagram updated (F2/F3/F4, J2/PoE, U6a/b/c OR-ing stage);
  Iron Curtain note updated; eFuse body text UVLO updated; R1 body text updated; startup timeline
  step 2 updated; BOM F2/F3/F4 row added; BOM R1 row updated; Last Updated 2026-05-14
- `design/Electronics/Consolidated_BOM.md` - PM F2/F3/F4 row added (0ZRB0600FF1A); PM R1 row
  updated (ERJ-3EKF2263V, P226KHCT-ND, 667-ERJ-3EKF2263V, C403081)
