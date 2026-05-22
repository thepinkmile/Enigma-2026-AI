## DEC-029 - Supercapacitor Hold-Up Specification: 25F Abracon Cells, 2S4P, ≥20 s at 15W

- **Status:** Accepted - 2026-04-14
- **Date:** 2026-04-14
- **Category:** Electrical
- **Area:** Power Module - Supercap Bank, Hold-up Specification
- **Supersedes:** DEC-004 (cell reference), DEC-021 (cell capacitance and count)
- **References:** DR-PM-07, DR-PM-09, BOM C_SC1-8

### Decision

The supercapacitor hold-up **minimum requirement is ≥20 seconds** at a **15W shutdown load**
(CM5 typical operating current: 5V x 3A = 15W). The confirmed cell selection (Abracon
ADCR-T02R7SA256MB, 25F/2.7V) in a **2S4P (8-cell)** arrangement provides ≥33.5 seconds.

> ⚠️ **Cell lock:** Cells are **Abracon ADCR-T02R7SA256MB, 25F/2.7V** in **2S4P (8 cells)**.
> Stale values **22F**, **33F**, **37.5F**, **21.7 s**, and **24.8 s** must never reappear.
> Any proposed cell or configuration change requires recalculating hold-up against the ≥20 s
> rule below using the **15W** load figure.

### Correct Load Figure

> ⚠️ The CM5 draws **5V x 3A = 15W** during typical operation. When a power-loss event
> occurs, the CM5 is running at this load and continues to draw it throughout the OS shutdown
> sequence (~10-15 s). Earlier documents used 5W (1A) which significantly overstated margin.
> **All hold-up calculations must use 15W** as the minimum design load.

### Configuration

| Parameter | Value |
| :--- | :--- |
| Cell part number | Abracon ADCR-T02R7SA256MB |
| Cell capacitance | 25F / 2.7V each |
| Configuration | 2S4P - 8 cells total (C_SC1-C_SC8) |
| Effective capacitance | 50F at 5.4V |
| Charge voltage (2S) | 5.4V |
| Block footprint | 37mm x 77mm (2 columns x 4 rows, 20mm pitch) |
| Shadow zone | 41mm x 81mm |

### Hold-Up Calculation

Usable energy from a capacitor bank discharged from V\_hi to V\_lo:

> **E = 1/2 x C x (V\_hi² - V\_lo²)**

Load power during shutdown: **P = 15W** (CM5 at 5V x 3A typical).

Hold-up duration: **t = E x η / P**

#### Conservative model (pure-buck - LTC3350 loses regulation at V\_lo ≈ 4.75V)

| Step | Calculation | Result |
| :--- | :--- | :--- |
| Usable energy | 1/2 x 50 x (5.4² - 4.75²) | 164.9J |
| Hold-up @ 15W | 164.9J / 15W | **11.0 s ❌** |

This model is unrealistic - the LTC3350 is a 4-switch synchronous buck-boost, not a simple
buck. It is shown here only to illustrate that relying on the cap voltage staying above the
output voltage is not sufficient at this load.

#### Realistic model (LTC3350 boost mode, V\_lo = 2.0V, η = 80%)

The LTC3350 actively boosts the supercap voltage to maintain 5V output in backup mode.
Minimum practical V\_CAP of ~2.0V protects cells from over-discharge (1.0V/cell for 2S).

| Step | Calculation | Result |
| :--- | :--- | :--- |
| Stored energy (V\_lo = 2.0V) | 1/2 x 50 x (5.4² - 2.0²) | 629J |
| Delivered (η = 80%) | 629J x 0.80 | **503J** |
| Hold-up @ 15W | 503J / 15W | **≥33.5 s ✔** |

#### Sensitivity to LTC3350 efficiency at 15W load

| Efficiency | Delivered energy | Hold-up | Pass ≥20 s? |
| :--- | :--- | :--- | :--- |
| 85% | 535J | 35.6 s | ✔ |
| 80% | 503J | 33.5 s | ✔ |
| 75% | 472J | 31.5 s | ✔ |
| 67% | 421J | 28.1 s | ✔ |
| 48% (minimum) | 302J | 20.1 s | ✔ (edge) |

The ≥20 s rule is satisfied even if converter efficiency degrades to ~48%, which is far below
any credible operating point for a synchronous buck-boost at these voltages and currents.

### Rationale

- **Why 2S4P (8 cells) and not 2S3P (6 cells)?** At 15W, 2S3P (37.5F) delivers 377J at 80%
  efficiency → 25.2 s. This passes the 20 s rule but leaves only 26% margin. 2S4P (50F)
  delivers 503J → 33.5 s, a 68% margin, providing meaningful headroom against LTC3350
  efficiency variation, higher CM5 loads during bring-up, and supercap aging.
- **Why 15W?** The CM5 module draws 5V x 3A under typical operating load. When power is lost,
  the OS shutdown sequence takes ~10-15 s during which the CM5 continues at near-full load.
  Using 5W (1A) as the design load significantly understates the required hold-up margin and
  was an error in DEC-004 and DEC-021.
- **0.5A PoE charge current (from DEC-004) retained:** charge power = 5.4V x 0.5A = 2.7W,
  unaffected by the cell count increase. Charge time from fully depleted ≈ **9 minutes**
  (100F per series position x 2.7V / 0.5A = 540 s). PoE utilisation calculations in
  Certification\_Evidence are unaffected.

### Constraints

- Do not change the cell MPN, cell count, or configuration without re-running the hold-up
  calculation at **15W** against the ≥20 s rule and updating DR-PM-07, DR-PM-09, and this DEC.
- LTC3350 CELLS register must remain configured for 2 series cells (CELLS = 0x01).
- PCB shadow zone: 41mm x 81mm. No traces on L1-L6 within this zone (enclosure rib clearway).
