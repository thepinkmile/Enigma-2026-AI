# Stackup & Impedance Controlled Trace Analysis

**Todo:** `stackup-impedance-recalc`
**Status:** In progress — full 10-option comparison complete (all 4-layer and 6-layer copper weight combinations); awaiting user stackup selection
**Last updated:** 2026-05-10

---

## 1. Objective

Determine the correct PCB stackup for every board in the Enigma-NG system.

All boards currently specify `JLC04161H-7628` (7628 prepreg) with 5 mil / 50 Ω CI traces.
This is **physically impossible** — 7628 outer prepreg (H ≈ 8 mil) requires ~14 mil for 50 Ω.
Everything must be corrected before any board proceeds to PCB layout.

Secondary objectives:
- Assess whether any 4-layer boards should become 6-layer
- Determine the correct per-stackup GRS rules (user confirmed: rules are per-stackup, not universal)
- Document all findings as a new DEC entry in Design_Log.md

---

## 2. Layer Philosophy (User-Approved)

| Layer | Role | Copper weight |
|---|---|---|
| L1 (outer top) | GND / power fills only | 2oz |
| L2 (inner) | Controlled-impedance signal traces | 1oz |
| L3 (inner) | Controlled-impedance signal traces | 1oz |
| L4 (outer bottom) | GND / power fills only | 2oz |

- **No inner power planes** — power carried on outer fills only (user decision)
- GRS rules to be defined **per approved stackup name**, not as a universal trace width, to allow future fab change (e.g. to PCBWay)
- The 3.5 mil JLCPCB manufacturing minimum is the hard floor; the old GRS 5 mil rule can be revised upward or downward as evidence requires

For 6-layer boards (Controller only currently):

| Layer | Role | Copper weight |
|---|---|---|
| L1 | GND / power fills | 2oz |
| L2 | CI signal (inner microstrip, ref to L1 via outer prepreg) | 1oz |
| L3 | Non-CI signal (slow I2C, SPI, GPIO — no impedance control) | 1oz |
| L4 | Non-CI signal | 1oz |
| L5 | CI signal (inner microstrip, ref to L6 via outer prepreg) | 1oz |
| L6 | GND / power fills | 2oz |

Only L2 and L5 carry controlled-impedance traces. L3 and L4 are bonus routing capacity for slow signals.
The 6-layer board adds **2 extra non-CI routing layers** over 4-layer — not 2 extra CI layers.

---

## 3. JLCPCB Stackup Naming Convention

| Code | Layers | Outer Cu | Inner Cu | Notes |
|---|---|---|---|---|
| `JLC04161H-xxxx` | 4-layer 1.6mm | 1oz | H/HOZ (~0.5oz) | Default page view |
| `JLC041621-xxxx` | 4-layer 1.6mm | 2oz | 1oz | JS button required to see |
| `JLC04162H-xxxx` | 4-layer 1.6mm | 2oz | H/HOZ (~0.5oz) | JS button required to see |
| `JLC06161H-xxxx` | 6-layer 1.6mm | 1oz | H/HOZ (~0.5oz) | Default page view |
| `JLC061621-xxxx` | 6-layer 1.6mm | 2oz | 1oz | JS button required to see |
| `JLC06162H-xxxx` | 6-layer 1.6mm | 2oz | H/HOZ (~0.5oz) | JS button required to see |

---

## 4. Copper Thickness Reference

| Spec | Weight | Thickness (mm) | Thickness (mil) |
|---|---|---|---|
| Outer (1oz) | 1oz | 0.035 | 1.38 |
| Outer (2oz) | 2oz | 0.070 | 2.76 |
| Inner 1oz | 1oz | 0.030 | 1.18 |
| Inner H/HOZ | ~0.5oz | 0.0152 | 0.60 |

Inner copper is thinner than outer of the same nominal weight due to electrodeposition vs foil.

---

## 5. Available Stackups — Confirmed from JLCPCB Page Data

Data sourced from user-supplied HTML page captures (JS-rendered, 2oz/1oz button selected).
Files: `paste-1778427567669.txt` (6-layer) and `paste-1778431846315.txt` (4-layer).

### 4-Layer Options (1oz outer / H/HOZ inner — JLC04161H-xxxx)

From the default JLCPCB impedance page view (not captured in paste files, from prior sessions):

| Stackup | Outer prepreg | H_nom (mm) | H_nom (mil) | Dk (approx) | Notes |
|---|---|---|---|---|---|
| JLC04161H-7628 | 7628×1 (0.203mm) | 0.203 | 7.99 | 4.40 | Currently specified — WRONG |
| JLC04161H-1080 | 1080×1 (0.069mm) | 0.069 | 2.72 | 3.91 | **Best thin-trace option** |
| JLC04161H-3313 | 3313×1 (0.092mm) | 0.092 | 3.62 | 3.69 | |
| JLC04161H-2116 | 2116×1 (0.109mm) | 0.109 | 4.29 | 3.80 | |

JLCPCB impedance calculator reports H=3.01 mil for JLC04161H-1080 (slightly larger than nominal,
likely accounts for solder mask and press variation). Use JLCPCB's H value, not nominal, for calcs.

### 4-Layer Options (2oz outer / 1oz inner — JLC041621-xxxx)

**Confirmed complete list from paste file:**

| Stackup | Outer prepreg | H_nom (mm) | H_nom (mil) | Notes |
|---|---|---|---|---|
| JLC041621-7628 | 7628×1 (0.203mm) | 0.203 | 7.99 | Too thick ❌ |
| JLC041621-3313 | 3313×1 (0.092mm) | 0.092 | 3.62 | **Viable 2oz option** ✅ |
| JLC041621-7628A | 7628×2 (0.218+0.203mm) | 0.421 | 16.57 | Far too thick ❌ |
| JLC041621-2116 | 2116×1 (0.109mm) | 0.109 | 4.29 | Marginal, wider trace |
| JLC041621-7628B | 7628 variant | >0.203 | >7.99 | Too thick ❌ |
| JLC041621-1080 | 1080×1 (0.069mm) | 0.069 | 2.72 | See critical finding below ⚠️ |

### 6-Layer Options (1oz outer / H/HOZ inner — JLC06161H-xxxx)

From prior session analysis (default page view):

| Stackup | Outer prepreg | H_nom (mil) | Notes |
|---|---|---|---|
| JLC06161H-7628 | 7628×1 | 7.99 | Too thick ❌ |
| JLC06161H-1080 | 1080×1 | 2.72 | **Viable thin-trace 6-layer** ✅ |
| JLC06161H-3313 | 3313×1 | 3.62 | Viable ✅ |
| JLC06161H-2116 | 2116×1 | 4.29 | Marginal |

### 6-Layer Options (2oz outer / 1oz inner — JLC061621-xxxx)

**Confirmed complete list from paste file:**

| Stackup | Outer prepreg | H_nom (mil) | Notes |
|---|---|---|---|
| JLC061621-7628 | 7628×1 (0.203mm) | 7.99 | Too thick ❌ |
| JLC061621-3313 | 3313×1 (0.092mm) | 3.62 | **Viable 2oz option** ✅ |
| JLC061621-3313A | 3313×1 outer + 1080 centre | 3.62 (outer) | Centre 1080 for total thickness only |
| JLC061621-7628A | 7628 variant + 2313 + 2116 | >7.99 | Too thick ❌ |

**JLC061621-1080 does NOT exist** — no 6-layer 2oz/1oz option with 1080 as outer prepreg.

### JLC061621-3313A Inner Structure (nuance)

- Top: 0.070mm (2oz copper)
- Outer prepreg: 3313×1 (0.092mm = 3.62 mil)
- L2/L3 core: **0.100mm (3.94 mil) — very thin**
- Centre prepregs: 1080×1 (0.069mm) + 1080×1 (0.084mm) — only used for board thickness
- L4/L5 core: 0.100mm (3.94 mil) — symmetric
- Outer prepreg: 3313×1 (0.092mm = 3.62 mil)
- Bottom: 0.070mm (2oz copper)

The 1080 prepregs in the centre are **not the outer dielectric** — they contribute to total board
thickness only. The CI reference height H is still 3.62 mil (3313 outer prepreg).
The L2/L3 core at 0.100mm (3.94 mil) is very thin — this complicates L3 routing if used near
plane structures (effectively a buried microstrip with dual reference). Avoid CI traces on L3 with
this stackup; treat L2 and L5 as the only CI layers (same as standard 6-layer).

---

## 6. Critical Finding — JLC041621-1080 Exists but is Not Viable

**JLC041621-1080 appears in the 4-layer 2oz/1oz list.** This initially appears to offer the
best of both worlds (2oz outer GND planes AND thin 1080 prepreg). However, with 2oz outer copper
(T=2.76 mil) and 1080 prepreg (H≈3.01 mil), the 50 Ω trace width calculates to approximately
**3.3–3.4 mil — below the JLCPCB 3.5 mil manufacturing floor**.

With inner CI traces (T_inner = 1oz = 1.18 mil) and same outer prepreg (H≈2.72 mil nominal):
the 50 Ω trace width is similarly problematic (~3.0 mil).

**JLC041621-1080 cannot be used for 50 Ω controlled-impedance traces. ❌**

> Note: The JLCPCB calculator should be run against this stackup to confirm the exact value.
> These are estimates from IPC-2141A calibrated to known reference points. The conclusion
> (at/below floor) is robust even accounting for formula uncertainty, but verification is advisable.

---

## 7. Trace Width Calculations

### Method

IPC-2141A microstrip formula, calibrated to reproduce JLCPCB calculator output for the known
reference point: `JLC04161H-1080` → W = 5.1 mil for 50 Ω (from JLCPCB calculator, outer trace).

Calibration gives Dk_eff ≈ 2.9 for 1080 and Dk_eff ≈ 3.0 for 3313.
These effective values are lower than nominal Dk (3.91 / 3.69) due to frequency correction
and JLCPCB's specific calculator model (Polar Si8000m-based). They are calibrated estimates
only — exact values require the JLCPCB impedance calculator.

### Key Note on Inner vs Outer Trace Widths

With our inner-signal strategy, CI traces are on L2/L3. These are inner microstrip referenced
to L1 (outer GND) via the outer prepreg. The formula parameters are:
- H = outer prepreg thickness (same as for outer microstrip)
- T = **inner copper weight** (H/HOZ for JLC04161H series; 1oz for JLC041621 series)

Thinner inner copper (H/HOZ) → slightly wider trace required vs outer copper for the same Z0.

### 50 Ω Single-Ended — Outer Trace (for reference)

| Stackup | H (mil) | T_outer | W_50Ω (mil) | Floor check |
|---|---|---|---|---|
| JLC04161H-1080 | 3.01 | 1.38 mil (1oz) | **5.1** (JLCPCB calc) | ✅ OK |
| JLC04161H-3313 | 3.62 | 1.38 mil (1oz) | ~6.3 (estimate) | ✅ OK |
| JLC041621-1080 | 3.01 | 2.76 mil (2oz) | ~3.3 | ❌ Below floor |
| JLC041621-3313 | 3.62 | 2.76 mil (2oz) | ~4.6 | ✅ OK |

### 50 Ω Single-Ended — Inner CI Trace (our actual use case)

| Stackup | H (mil) | T_inner | W_50Ω (mil) | Floor check |
|---|---|---|---|---|
| JLC04161H-1080 | 3.01 | 0.60 mil (H/HOZ) | ~6.1 | ✅ OK |
| JLC041621-3313 | 3.62 | 1.18 mil (1oz) | ~6.6 | ✅ OK |

> All estimates require JLCPCB calculator verification before being committed to GRS or Design_Spec files.

### Differential Pairs — Approximate Targets

For 90 Ω USB HS (inner microstrip, same H, appropriate T):
- JLC04161H-1080: W ≈ 7–8 mil, S ≈ 4–5 mil (edge-to-edge)
- JLC041621-3313: W ≈ 8–9 mil, S ≈ 5 mil

For 100 Ω GbE / HDMI / DSI (inner microstrip):
- JLC04161H-1080: W ≈ 6–7 mil, S ≈ 5 mil
- JLC041621-3313: W ≈ 7–8 mil, S ≈ 5–6 mil

> These are approximate. Exact values to be taken from JLCPCB calculator for each chosen stackup.
> They depend on the edge-to-edge spacing S chosen, which is coupled to W.

---

## 8. The Two Viable Options

The fundamental constraint: **wanting 2oz outer AND 1080 prepreg AND 50 Ω CI traces is impossible
at JLCPCB** (W falls below 3.5 mil floor with 2oz + 1080). The choice is:

### Option A — 1oz Outer, Thinner CI Traces

- **4-layer:** `JLC04161H-1080` — H=3.01 mil, inner CI W≈6.1 mil / 50 Ω (H/HOZ inner)
- **6-layer CTL:** `JLC06161H-1080` — same geometry
- GND/power outer fills: 1oz — adequate for most boards but slightly lower current capacity
- CI traces: narrower (≈6.1 mil 50 Ω inner)

### Option B — 2oz Outer, Slightly Wider CI Traces

- **4-layer:** `JLC041621-3313` — H=3.62 mil, inner CI W≈6.6 mil / 50 Ω (1oz inner)
- **6-layer CTL:** `JLC061621-3313` or `JLC061621-3313A` — same outer prepreg geometry
- GND/power outer fills: 2oz — better current capacity, better thermal, better EMI return path
- CI traces: slightly wider (≈6.6 mil 50 Ω inner)

### Comparison Summary

| Factor | Option A (1oz outer, 1080) | Option B (2oz outer, 3313) |
|---|---|---|
| Outer copper (GND/power) | 1oz | 2oz |
| 50 Ω inner CI trace width | ~6.1 mil | ~6.6 mil |
| 100 Ω diff pair width | ~6–7 mil | ~7–8 mil |
| JLCPCB floor margin | ~2.6 mil margin | ~3.1 mil margin |
| Power plane current capacity | Adequate | Better |
| EMI return path | Good | Better |
| 6-layer CTL option | JLC06161H-1080 | JLC061621-3313/3313A |
| Availability | ✅ Confirmed | ✅ Confirmed |

Both options keep all CI traces well above the 3.5 mil floor. Option B offers marginally more
manufacturing headroom and better power plane performance.

---

## 9. Board-by-Board Assessment

### Confirmed 4-Layer Boards

| Board | Current spec | Verdict | Target stackup |
|---|---|---|---|
| Rotor (AM) | JLC04161H-7628 | Needs correction | Option A or B |
| Extension (EXT) | JLC04161H-7628 | Needs correction | Option A or B |
| Reflector (REF) | JLC04161H-7628 | Needs correction | Option A or B |
| Stator (STA) | JLC04161H-7628 | Needs correction | Option A or B |
| Junction Module (JM) | JLC04161H-7628 | Needs correction | Option A or B |
| Encoder | JLC04161H-7628 | Needs correction | Option A or B |
| Actuation Module (AM) | JLC04161H-7628 | Needs correction | Option A or B |
| User Settings Module (USM) | JLC04161H-7628 | Needs correction | Option A or B |

User notes:
- JM: assess 6-layer? → User said "Not warranted — USB signals vs cost not worth it"
- STA: assess 6-layer? → User said "Not really required — CPLD density issue doesn't justify it"

### Confirmed 6-Layer Boards

#### Controller (CTL) — ✅ 6-Layer Confirmed (User 2026-05-10)

Current spec: `JLC06161H-2116` (incorrect — needs correction).

**Why 6-layer is justified for CTL:**

1. **Ethernet BI_DB crossover** — 1000BASE-T MDI places BI_DB+ at pin 3 and BI_DB− at pin 6,
   with BI_DC (pins 4 & 5) physically between them. Topologically impossible to route on one
   layer without crossing. 6-layer: BI_DB on L2, BI_DC on L5 — crossover eliminated.
   THT connector means no vias needed at the connector; each pair starts directly from its
   own-layer THT pad. Anti-pads required on fill layers.

2. **USB 3.0 dual-stack (Molex 48406-0003) layer isolation** — SS pairs from Port 1 and
   Port 2 can be assigned to L2 and L5 respectively, with USB 2.0 D+/D− on L3/L4 (non-CI).
   Diff pairs cannot escape through the pin matrix (diagonal clearance only ~7 mil);
   they must fan out sideways — clean on separate layers.

**Target 6-layer stackup for CTL:**
- Option A: `JLC06161H-1080`
- Option B: `JLC061621-3313` or `JLC061621-3313A`

---

#### Power Module (PM) — ✅ Already 6-Layer (pre-existing)

Current spec: `JLC06161H-2116` (incorrect — needs assessment).

The PM is 6-layer for power routing, thermal, and isolation reasons — **not** for CI signal
traces. The PM carries no high-speed digital signals requiring controlled impedance. Its
6-layer justification is:

- Multiple isolated power rails need dedicated routing planes
- Heavy copper (2oz) needed for current capacity
- Type VII (epoxy-filled) thermal vias throughout the supercap shadow zone
- Inner layers isolate switching noise from regulated output rails

**Key difference from CTL:** PM may not require impedance-controlled service at all.
The stackup choice for PM is driven by copper weight and layer count, not by H/Dk values
for CI trace geometry. Options to evaluate:
- Stay on `JLC06161H-2116` (acceptable if no CI traces needed — just needs copper weight confirmation)
- Or align to `JLC061621-3313` / `JLC06161H-1080` for consistency with CTL

> ⏳ **Open question:** Does PM need to align to the same stackup as CTL, or can it use a
> different 6-layer stackup optimised for power (e.g., heavier inner copper)? This depends
> on whether JLCPCB offers different inner copper options for non-impedance-controlled orders.

---

## 10. Ethernet RJ45 Routing Analysis (CTL)

### Connector Geometry

- Connector type: **Through-hole (THT)** — important; see implications below
- 2 rows of 4 pins
- Horizontal pin-to-pin spacing: **2.54 mm (100 mil)** — same row
- Second row horizontal offset: **1.27 mm (50 mil)**
- Row separation: **2.54 mm (100 mil)** — centre to centre
- Assumed layout: odd pins (1,3,5,7) in row 1; even pins (2,4,6,8) in row 2

Pin positions (assuming odd/even staggered, mm from pin 1):

```
Row 1 (y=0):    Pin 1      Pin 3      Pin 5      Pin 7
                 x=0       x=2.54    x=5.08    x=7.62

Row 2 (y=-2.54):    Pin 2      Pin 4      Pin 6      Pin 8
                     x=1.27    x=3.81    x=6.35    x=8.89
```

### Differential Pair Distances

| Pair | Pins | c-c (mm) | Edge gap (mil, ~1.5mm pad) | Adjacent? |
|---|---|---|---|---|
| BI_DA | 1 & 2 | 2.84 | 53 | Diagonal-adjacent ✓ |
| **BI_DB** | **3 & 6** | **4.58** | **121** | **Non-adjacent — BI_DC between them ❌** |
| BI_DC | 4 & 5 | 2.84 | 53 | Diagonal-adjacent ✓ |
| BI_DD | 7 & 8 | 2.84 | 53 | Diagonal-adjacent ✓ |

### Routing Capacity Between Adjacent Pads

Same-row adjacent pads: **41 mil** edge gap.

| Stackup | W (50 Ω inner) | Diff pair footprint | Fits between pads? |
|---|---|---|---|
| JLC04161H-1080 | ~6.1 mil | ~25 mil (2×6.1 + 5S + 2×3.5 cl) | ✅ 1 pair fits, 16 mil spare |
| JLC041621-3313 | ~6.6 mil | ~27 mil | ✅ 1 pair fits, 14 mil spare |

Trace widths are **not** a routing bottleneck at this connector. The constraint is topological only.

### THT — Key Implication for Routing

The RJ45 connector pins are **through-hole, not SMD**. The plated barrel extends through
all copper layers. This means:

- **No additional vias are needed at the connector** to route on different layers
- Routing BI_DC on L5: simply start the trace from the L5 pad of pins 4 and 5 directly
- Routing BI_DB on L2: simply start the trace from the L2 pad of pins 3 and 6 directly
- The THT barrel is the layer connection — no via stub risk
- **Anti-pads are required** on non-routing copper fill layers for each THT pin to prevent
  accidental shorts to GND/power fills on L1 and L4

### 6-Layer Routing Strategy for CTL GbE

```
L2: BI_DA (pins 1,2)    BI_DB (pins 3,6)    BI_DD (pins 7,8)
L5: BI_DC (pins 4,5)

Each pair traces start directly from the THT pad on the appropriate layer.
BI_DB routes on L2 freely since BI_DC is on L5 — no crossover.
```

This is clean, via-free at the connector, and fully resolves the crossover problem.

---

## 11. Rotor Design Spec Known Error

The Rotor board Design_Spec currently specifies:
- `JLC04161H-7628` with `h=0.087mm` — this is between 1080 (0.069mm) and 3313 (0.092mm),
  matching neither and therefore incorrect
- Claims outer microstrip at L1

Under the revised strategy: L1 is GND fill, CI traces move to L2 (inner microstrip).
The correct H (outer prepreg) will depend on the chosen stackup.

---

## 12. USB 3.0 Dual-Stack Connector Routing Analysis (CTL)

**Component:** Molex 48406-0003 (USB 3.0 dual-stack Type-A, THT)

### Pin Geometry

- 4 rows of pins; rows 1&3 align horizontally, rows 2&4 align horizontally
- Horizontal pitch: **2.0 mm** centre-to-centre (same row)
- Row 1 has **4 pins**; Row 2 has **5 pins**; Row 3 mirrors Row 1; Row 4 mirrors Row 2
- Row 1 is offset 0.5 mm horizontally from Row 2 (pin 1 of row 1 is at x=0.5 relative to row 2 x=0)
- Row 1 to Row 2 vertical spacing: **1.5 mm**; Row 2 to Row 3: **1.7 mm**; Row 3 to Row 4: **1.5 mm**

Pin coordinate map (mm, row 2 as reference):

```
Row 1 (y=–1.5): x = 0.5, 2.5, 4.5, 6.5   (4 pins)
Row 2 (y= 0.0): x = 0,   2,   4,   6,   8 (5 pins)
Row 3 (y=+1.7): x = 0.5, 2.5, 4.5, 6.5   (4 pins)
Row 4 (y=+3.2): x = 0,   2,   4,   6,   8 (5 pins)
```

### Centre-to-Centre Distances

| Gap | Calculation | Distance (mil) |
|---|---|---|
| Same-row horizontal | 2.0 mm | 78.7 mil |
| Row 1↔2 nearest diagonal | √(0.5² + 1.5²) = 1.581 mm | 62.2 mil |
| Row 2↔3 nearest diagonal | √(0.5² + 1.7²) = 1.772 mm | 69.8 mil |
| Row 3↔4 nearest diagonal | Same as row 1↔2 | 62.2 mil |

### Edge-to-Edge Clearances (estimated 1.4mm pad / 0.8mm drill)

> ⚠️ Pad size must be confirmed from the Molex 48406-0003 land pattern specification —
> 1.4mm is an estimate typical for 2mm-pitch THT connectors.

| Gap | Edge-to-edge |
|---|---|
| Same-row horizontal | 0.6mm = **23.6 mil** |
| Row 1↔2 / 3↔4 diagonal | 0.18mm = **7.1 mil** |
| Row 2↔3 diagonal | 0.37mm = **14.6 mil** |

### Routing Feasibility Through Pin Matrix

A 90 Ω USB SS differential pair (inner microstrip, Option A/B) needs approximately:
- W ≈ 7–8 mil × 2 + S ≈ 5 mil + 4 mil clearance each side ≈ **28 mil total**
- Single trace (with clearances): ≈ **16 mil**

| Gap | Single trace (16 mil) | Diff pair (28 mil) |
|---|---|---|
| Row 1↔2 diagonal (7.1 mil) | ❌ No | ❌ No |
| Row 2↔3 diagonal (14.6 mil) | ✅ Tight | ❌ No |
| Same-row horizontal (23.6 mil) | ✅ Yes | ❌ No |

**Conclusion: Differential pairs cannot escape through the pin matrix.** Traces must fan out
laterally from the sides of the connector pin field. This is standard practice for dense
multi-row THT connectors and is not a showstopper.

### No Crossover Issue (Unlike Ethernet)

USB 3.0 SuperSpeed uses separate unidirectional SSTX+/− and SSRX+/− pairs.
Each pair's + and − pins are adjacent within the connector; no topological crossover
equivalent to the Ethernet BI_DB problem is expected.

### 6-Layer Layer Assignment for USB SS

Assuming rows 1&2 = Port 1 and rows 3&4 = Port 2:

- **Port 1 SS pairs** (rows 1&2) → route on **L2** (CI inner microstrip)
- **Port 2 SS pairs** (rows 3&4) → route on **L5** (CI inner microstrip)
- **USB 2.0 D+/D−** (both ports) → route on **L3 or L4** (non-CI, low-speed)
- **VBUS / GND** → L1 / L6 outer fills

Each port's SS pairs escape sideways on their own CI layer with no inter-port congestion.
Anti-pads required on all copper fill layers for each THT barrel (same requirement as RJ45).

This analysis further reinforces the 6-layer choice for CTL without adding a new blocker.

---

## 13. User Decisions Recorded

| Decision | Status | Detail |
|---|---|---|
| Inner layers for CI signals | ✅ Approved | Outer layers = GND/power fills |
| No inner power planes | ✅ Approved | Power on outer copper fills only |
| Per-stackup GRS rules | ✅ Approved | Not a universal single width |
| GRS 5 mil rule is flexible | ✅ Approved | Can change if better stackup found |
| JM: stay 4-layer | ✅ Approved | USB signal cost not worth 6-layer |
| STA: stay 4-layer | ✅ Approved | CPLD density doesn't justify it |
| CTL: 6-layer confirmed | ✅ Confirmed (2026-05-10) | Ethernet BI_DB crossover + USB SS layer isolation both require 6-layer |
| 2oz outer preferred | ✅ User direction | User prefers 2oz outer for better GND/power fills; 1oz outer options remain as alternatives |
| **4-layer stackup selection** | ✅ **Confirmed (2026-05-10)** | **`JLC041621-3313` — 2oz outer / 1oz inner / 3313 prepreg. W50_outer ≈ 5.1 mil, W50_inn ≈ 6.6 mil, margin +3.1 mil. All 4-layer boards.** |
| **CTL 6-layer stackup selection** | ✅ **Confirmed (2026-05-10)** | **`JLC061621-3313` — 2oz outer / 1oz inner / 3313 prepreg. Same widths as 4-layer; CI service required.** |
| **PM 6-layer stackup selection** | ✅ **Confirmed (2026-05-10)** | **`JLC061621-3313` — same physical stackup as CTL. CI service NOT required for PM (no CI signals). See Section 20.** |

---

## 14. Files Affected (when SENARY approval is given)

| File | Change needed |
|---|---|
| `design/Production/JLCPCB_Manufacturing.md` | Full stackup catalogue, all layer parameters, CI trace width tables |
| `design/Standards/Global_Routing_Spec.md` | Per-stackup CI trace width rules; layer philosophy |
| `design/Electronics/Controller/Design_Spec.md` | Stackup update, layer assignments, GbE routing rationale |
| `design/Electronics/Rotor/Design_Spec.md` | Stackup correction, h value fix, layer assignment update |
| `design/Electronics/Stator/Design_Spec.md` | Stackup correction |
| `design/Electronics/Extension/Design_Spec.md` | Stackup correction |
| `design/Electronics/Reflector/Design_Spec.md` | Stackup correction |
| `design/Electronics/PowerModule/Design_Spec.md` | Stackup correction |
| `design/Electronics/JunctionModule/Design_Spec.md` | Stackup correction |
| `design/Electronics/Encoder/Design_Spec.md` | Stackup correction |
| `design/Design_Log.md` | Append new DEC entry (append-only — TERTIARY DIRECTIVE) |

---

## 15. Open Questions / Next Steps

1. ~~**User decision required:** Select from the 10-option stackup comparison table in Section 16.~~
   **✅ RESOLVED (2026-05-10):** `JLC041621-3313` (4-layer all boards), `JLC061621-3313` (6-layer all boards — CTL CI required, PM CI not required).

2. **JLCPCB calculator verification:** Once the stackup is chosen, the exact 50 Ω / 90 Ω / 100 Ω
   trace widths for that specific stackup need to be confirmed using the JLCPCB impedance calculator
   (not IPC-2141A estimates) before being written to GRS and Design_Spec files.
   ⏳ **Agent cannot access JLCPCB online calculator directly — user must run manually (see Section 20 for parameters).**

3. ~~**PM open question:** Does the Power Module need impedance-controlled service?~~
   **✅ RESOLVED (2026-05-10):** PM uses `JLC061621-3313` (same stackup as CTL) for independent reasons
   (2oz outer required; 1oz inner preferred for current-carrying inner routes). CI service NOT required for PM. See Section 20.

4. **Layer order convention for JM / AM:** User noted GND plane should be the bottom layer
   when mounted on carrier boards. Confirm and document preferred layer-order convention.

5. **DEC number to use:** Check the last DEC number in Design_Log.md before appending the
   new stackup decision entry.

---

## 16. Complete Stackup Data — All Copper Weight Combinations (Session 2026-05-10)

This section captures the full set of JLCPCB stackup data gathered across all sessions,
covering all three inner/outer copper weight combinations for 4-layer and 6-layer boards.
All prepreg thicknesses are as-pressed values from JLCPCB's stackup configurator pages.

### 16.1 Naming Convention and Coverage

| Code pattern | Outer | Inner | Data source |
|---|---|---|---|
| JLC04161H-xxxx | 1oz | H/HOZ | Default JLCPCB page (prior sessions) |
| JLC041621-xxxx | 2oz | 1oz | paste-1778431846315.txt |
| JLC04162H-xxxx | 2oz | H/HOZ | paste-1778441799023.txt |
| JLC06161H-xxxx | 1oz | H/HOZ | Default JLCPCB page (prior sessions) |
| JLC061621-xxxx | 2oz | 1oz | paste-1778427567669.txt |
| JLC06162H-xxxx | 2oz | H/HOZ | Inline HTML paste (session 2026-05-10) |

### 16.2 4-Layer 1oz Outer / H/HOZ Inner (JLC04161H-xxxx)

| Stackup | Outer prepreg | H_outer (mm) | H_outer (mil) | Dk_eff | Notes |
|---|---|---|---|---|---|
| JLC04161H-7628 | 7628×1 (0.203mm) | 0.203 | 7.99 | 4.40 | Currently specified — WRONG |
| JLC04161H-1080 | 1080×1 | 0.069 | 2.72 | 2.90 | JLCPCB calc gives H=3.01 mil |
| JLC04161H-3313 | 3313×1 | 0.092 | 3.62 | 3.00 | |
| JLC04161H-2116 | 2116×1 | 0.109 | 4.29 | 3.10 | |

### 16.3 4-Layer 2oz Outer / 1oz Inner (JLC041621-xxxx)

From paste-1778431846315.txt (impedance-controlled list, 2oz/1oz page):

| Stackup | Outer prepreg | H_outer (mm) | H_outer (mil) | Notes |
|---|---|---|---|---|
| JLC041621-7628 | 7628×1 (0.203mm) | 0.203 | 7.99 | Too thick ❌ |
| JLC041621-3313 | 3313×1 (0.092mm) | 0.092 | 3.62 | **Viable — primary 2oz/1oz candidate** ✅ |
| JLC041621-7628A | 7628×2 variants | >0.421 | >16.57 | Far too thick ❌ |
| JLC041621-2116 | 2116×1 (0.109mm) | 0.109 | 4.29 | Marginal; wider trace |
| JLC041621-1080 | 1080×1 (0.069mm) | 0.069 | 2.72 | Outer W below 3.5 mil floor with 2oz Cu ❌ |

### 16.4 4-Layer 2oz Outer / H/HOZ Inner (JLC04162H-xxxx)

From paste-1778441799023.txt (2oz/HOZ page). Prepreg thicknesses differ from 2oz/1oz
because lighter inner copper changes resin flow during press — these are the correct values.

| Stackup | Outer prepreg | H_outer (mm) | H_outer (mil) | Notes |
|---|---|---|---|---|
| JLC04162H-7628 | 7628×1 (0.21040mm) | 0.21040 | 8.28 | Too thick ❌ |
| JLC04162H-3313 | 3313×1 (0.09940mm) | 0.09940 | 3.91 | **Viable** ✅ |
| JLC04162H-3313A | 3313×1 + 1080 combined outer | 0.18340 | 7.22 | Outer too thick ❌ |
| JLC04162H-2116 | 2116+1080+1080 combined | 0.2846 | 11.19 | Far too thick ❌ |

> Note: JLC04162H-3313 is the **only viable** 4-layer 2oz/HOZ option.
> The 3313 prepreg presses to 0.09940mm (3.91 mil) with 2oz/HOZ inner, vs 0.092mm (3.62 mil)
> with 2oz/1oz inner. This difference is real — use the copper-weight-specific value.

### 16.5 6-Layer 1oz Outer / H/HOZ Inner (JLC06161H-xxxx)

| Stackup | Outer prepreg | H_outer (mil) | Core (mil) | Notes |
|---|---|---|---|---|
| JLC06161H-7628 | 7628×1 | 7.99 | — | Too thick ❌ |
| JLC06161H-1080 | 1080×1 | 2.72 | 23.6 | **Viable thin-trace 6-layer** ✅ |
| JLC06161H-3313 | 3313×1 | 3.62 | 21.7 | Viable ✅ |
| JLC06161H-2116 | 2116×1 | 4.29 | — | Currently specified — WRONG |

### 16.6 6-Layer 2oz Outer / 1oz Inner (JLC061621-xxxx)

From paste-1778427567669.txt:

| Stackup | Outer prepreg | H_outer (mm) | H_outer (mil) | Core (mil) | Notes |
|---|---|---|---|---|---|
| JLC061621-7628 | 7628×1 (0.203mm) | 0.203 | 7.99 | — | Too thick ❌ |
| JLC061621-3313 | 3313×1 (0.092mm) | 0.092 | 3.62 | 21.7 | **Primary 6-layer candidate** ✅ |
| JLC061621-3313A | 3313×1 outer + 1080 centre | 0.092 | 3.62 | 3.9 | ⚠️ Thin L2/L3 core — see warning |
| JLC061621-7628A | 7628 + 2313 + 2116 | >0.203 | >7.99 | — | Too thick ❌ |

**JLC061621-3313A warning:** L2/L3 core = 0.100mm (3.9 mil). This is extremely thin and risks
capacitive crosstalk between adjacent inner layers. The 1080 prepregs in the centre
contribute to board thickness only — the CI reference height H is still 3.62 mil (outer 3313).
**Avoid for CTL:** L2 carries CI Ethernet, L3 carries non-CI signals — thin core between them
is problematic. Only viable if CI trace layers are L2/L5 exclusively.

### 16.7 6-Layer 2oz Outer / H/HOZ Inner (JLC06162H-xxxx)

From inline HTML paste (session 2026-05-10). Structurally equivalent to 4-layer 2oz/HOZ
but with additional core stack. Same 3313 prepreg presses to 0.09940mm at 2oz/HOZ.

| Stackup | Outer prepreg | H_outer (mm) | H_outer (mil) | Core (mil) | Notes |
|---|---|---|---|---|---|
| No-req stackup | 3313×1 (0.09940mm) | 0.09940 | 3.91 | 21.7 | Non-named; same as JLC06162H-3313 |
| JLC06162H-3313 | 3313×1 (0.09940mm) | 0.09940 | 3.91 | 21.7 | **Viable** ✅ |
| JLC06162H-7628 | 7628×1 (0.216mm) + 1080×1 (0.07840mm) | 0.2944 | 11.59 | 7.87 | Far too thick ❌ |

Inner copper (H/HOZ): 0.0152mm = 0.60 mil per the JLCPCB page data.

---

## 17. Full 10-Option Viable Stackup Comparison

All calculations use IPC-2141A calibrated to JLCPCB's own calculator output.
Reference point: JLC04161H-1080 → W = 5.1 mil outer 50 Ω (from JLCPCB calculator).
Calibrated Dk_eff: 1080 → 2.90, 3313 → 3.00, 2116 → 3.10.
All values are **estimates** — JLCPCB calculator verification required before use in design files.

### 17.1 Copper Thickness

| Cu spec | T (mil) | T (mm) |
|---|---|---|
| Outer 1oz | 1.38 | 0.035 |
| Outer 2oz | 2.76 | 0.070 |
| Inner 1oz | 1.18 | 0.030 |
| Inner H/HOZ (~0.5oz) | 0.60 | 0.0152 |

### 17.2 Complete Comparison Table

W50_out = 50 Ω trace width on outer layer (reference only — outer layers are fills).
W50_inn = 50 Ω CI trace width on inner layer (operative value for GRS and Design_Spec).
Floor = JLCPCB 3.5 mil manufacturing minimum. Margin = W50_inn − 3.5 mil.

| Stackup | L | Outer Cu | Inner Cu | H_outer (mil) | Dk_eff | W50_out (mil) | W50_inn (mil) | Margin (mil) | Core (mil) | Flag |
|---|---|---|---|---|---|---|---|---|---|---|
| JLC04161H-1080 | 4 | 1oz | H/HOZ | 3.01 | 2.90 | 5.1 | 6.1 | +2.6 | 74.8 | 1oz outer ⚠ |
| JLC04161H-3313 | 4 | 1oz | H/HOZ | 3.62 | 3.00 | 6.4 | 7.3 | +3.8 | 63.0 | 1oz outer ⚠ |
| JLC04161H-2116 | 4 | 1oz | H/HOZ | 4.29 | 3.10 | 7.7 | 8.7 | +5.2 | 55.1 | 1oz outer ⚠ |
| JLC041621-3313 | 4 | 2oz | 1oz | 3.62 | 3.00 | 4.6 | 6.6 | +3.1 | 63.0 | ✅ **BEST 4-layer** |
| JLC04162H-3313 | 4 | 2oz | H/HOZ | 3.91 | 3.00 | 5.3 | 8.0 | +4.5 | 51.2 | ✅ |
| JLC06161H-1080 | 6 | 1oz | H/HOZ | 3.01 | 2.90 | 5.1 | 6.1 | +2.6 | 23.6 | 1oz outer ⚠ |
| JLC06161H-3313 | 6 | 1oz | H/HOZ | 3.62 | 3.00 | 6.4 | 7.3 | +3.8 | 21.7 | 1oz outer ⚠ |
| JLC061621-3313 | 6 | 2oz | 1oz | 3.62 | 3.00 | 4.6 | 6.6 | +3.1 | 21.7 | ✅ **BEST 6-layer** |
| JLC061621-3313A | 6 | 2oz | 1oz | 3.62 | 3.00 | 4.6 | 6.6 | +3.1 | 3.9 | ⚠ Thin core (see §16.6) |
| JLC06162H-3313 | 6 | 2oz | H/HOZ | 3.91 | 3.00 | 5.3 | 8.0 | +4.5 | 21.7 | ✅ |

### 17.3 Eliminated Options — With Reasons

| Stackup | Reason for elimination |
|---|---|
| JLC04161H-7628 | H=7.99 mil → W50_inn ≈ 14 mil; outer prepreg too thick ❌ |
| JLC041621-7628 | H=7.99 mil → same as above ❌ |
| JLC041621-7628A | H>16 mil → far too thick ❌ |
| JLC041621-1080 | W50_out ≈ 3.3 mil with 2oz outer — below 3.5 mil floor ❌ |
| JLC041621-2116 | W50_inn ≈ 8.7 mil — marginal; outer prepreg at 4.29 mil; eliminated in favour of better options |
| JLC04162H-7628 | H=8.28 mil → W50_inn ≈ 14 mil ❌ |
| JLC04162H-3313A | H=7.22 mil (combined 3313+1080 outer prepreg) → too thick ❌ |
| JLC04162H-2116 | H=11.19 mil (combined multi-layer outer prepreg) → far too thick ❌ |
| JLC06161H-7628 | H=7.99 mil → too thick ❌ |
| JLC061621-7628 | H=7.99 mil → too thick ❌ |
| JLC061621-7628A | H>7.99 mil → too thick ❌ |
| JLC06162H-7628 | H=11.59 mil (combined 7628+1080 outer prepreg) → far too thick ❌ |

### 17.4 Key Observations

1. **2oz outer + H/HOZ inner gives the widest inner CI traces** (W50_inn ≈ 8.0 mil for 3313).
   This is because the H/HOZ inner copper is much thinner (0.60 mil vs 1.18 mil for 1oz),
   which shifts the 50 Ω balance toward a wider trace. Wider traces have slightly more
   manufacturing headroom (+4.5 mil above floor vs +3.1 mil for 2oz/1oz).

2. **2oz outer + 1oz inner gives the narrowest CI traces while maintaining 2oz outer fills**
   (W50_inn ≈ 6.6 mil). This is the best balance of manufacturability, routing density,
   and outer fill performance. Primary recommendation for all 2oz-outer boards.

3. **1oz outer options** all produce adequate CI traces (6.1–8.7 mil) but sacrifice outer fill
   copper weight — suboptimal for GND/power planes. Retained as fallback only.

4. **JLC04162H-3313 and JLC06162H-3313** (2oz outer / H/HOZ inner): The wider traces
   (8.0 mil inner) are not a problem in themselves, but offer no routing density advantage
   over the 2oz/1oz option. The only scenario where HOZ inner might be preferred is if
   JLCPCB's pricing or availability favours it — otherwise 2oz/1oz is the better choice.

---

## 18. Differential Pair Routing Analysis (Session 2026-05-10)

### 18.1 100 Ω Differential Pairs (GbE, HDMI, DSI)

IPC-2141A edge-coupled differential pair: Z_diff ≈ 100 Ω when gap S ≈ H_outer.

| Stackup | W50_inn (mil) | Gap S (mil) | Pair footprint W+S+W (mil) |
|---|---|---|---|
| JLC041621-3313 / JLC061621-3313 | 6.6 | ~3.6 | **16.8 mil total** |
| JLC04162H-3313 / JLC06162H-3313 | 8.0 | ~3.9 | **19.9 mil total** |
| JLC04161H-1080 / JLC06161H-1080 | 6.1 | ~3.0 | **15.2 mil total** |

All estimates — exact values require JLCPCB impedance calculator for the selected stackup.

### 18.2 Connector Routing Verification

#### RJ45 THT (Ethernet — CTL board)

- Horizontal pitch: 2.54 mm = 100 mil (same row)
- Available routing channel between same-row pads: ≈ 41 mil edge-to-edge (estimated ~1.5mm drill)
- Routing constraint: topological (BI_DB crossover) — not trace-width-driven
- Diff pair footprints (16.8–19.9 mil) all fit within 41 mil channel: **✅ All viable options pass**

#### USB 3.0 Dual-Stack THT (Molex 48406-0003 — CTL board)

- Horizontal pitch: 2.0 mm = 78.7 mil (same row)
- Available same-row channel: ≈ 23.6 mil (after anti-pads; estimated 1.4mm pad)
- Diagonal row clearances: 7.1 mil (rows 1↔2), 14.6 mil (rows 2↔3) — nothing routes through
- SS diff pairs must fan out **laterally** from connector sides — standard practice for dense THT
- This is not a blockage; traces from each port go onto their own inner layer (L2 / L5)
- Diff pair footprints (16.8–19.9 mil): wider than same-row channel but routes laterally: **✅ All viable options pass**

**Both connectors are THT.** No vias required at the connectors — barrels span all layers.
Anti-pads required on all copper fill layers for each barrel to prevent shorts to GND fills.

### 18.3 Summary Assessment

All 10 viable options pass both connector routing constraints. The decision between them
is driven by:
- Outer copper weight preference (2oz preferred by user)
- Inner copper weight (1oz vs H/HOZ — affects trace width, not routeability)
- Cost and availability (similar; JLCPCB pricing varies by option)
- Whether JLC061621-3313A's thin core is acceptable for CTL (recommendation: avoid it)

**Primary recommendations:**
- 4-layer boards: `JLC041621-3313` (2oz outer / 1oz inner, W50_inn ≈ 6.6 mil)
- 6-layer CTL: `JLC061621-3313` (2oz outer / 1oz inner, W50_inn ≈ 6.6 mil)
- Avoid JLC061621-3313A for CTL due to thin L2/L3 core at 3.9 mil

---

## 19. Session 2026-05-10 Work Log

**Work completed this session:**

- [x] Parsed 4-layer 2oz/HOZ (JLC04162H-xxxx) stackup data from paste-1778441799023.txt
- [x] Parsed 6-layer 2oz/HOZ (JLC06162H-xxxx) stackup data from inline HTML paste
- [x] Identified all eliminated options across all copper weight combinations
- [x] Calculated 50 Ω outer and inner trace widths for all 10 viable stackup options
- [x] Calculated differential pair footprints (W+S+W) for 100 Ω routing
- [x] Verified all viable options fit RJ45 and USB connector routing constraints
- [x] Explained why HOZ inner gives wider traces than 1oz inner (thinner copper, same H)
- [x] Confirmed CTL 6-layer (user decision finalised)
- [x] Updated Section 3 naming convention table to include JLC04162H and JLC06162H
- [x] Updated Section 13 User Decisions with CTL 6-layer confirmation
- [x] Appended full comparison data to this archive (Sections 16–19)
- [x] PM 6-layer stackup analysis complete — JLC061621-3313 confirmed (Section 20)
- [x] Final stackup selections confirmed by user (2026-05-10)

**Pending — awaiting JLCPCB calculator verification:**

- [ ] User to run JLCPCB impedance calculator for JLC041621-3313 (see Section 20 for inputs)
- [ ] User to run JLCPCB impedance calculator for JLC061621-3313 (see Section 20 for inputs)
- [ ] All 10 board Design_Spec.md files to be updated (each requires SENARY approval)
- [ ] `design/Production/JLCPCB_Manufacturing.md` to be updated
- [ ] `design/Standards/Global_Routing_Spec.md` to be updated (per-stackup CI trace rules)
- [ ] `design/Design_Log.md` new DEC entry to be appended

---

## 20. PM Stackup Analysis & Final Decisions (2026-05-10)

### Power Module Stackup Analysis

**Current (incorrect) PM spec:** `JLC06161H-2116` — 1oz outer / H/HOZ inner.
**Problem:** PM spec text says "2oz finished copper" but `JLC06161H-2116` = 1oz outer — same root-cause
error (wrong stackup code) as all other boards.

**PM signal profile (from Design_Spec.md §6):**

> "No USB data lines, HDMI, RJ45, or GbE MDI routing are present on the Power Module."

PM carries **zero CI signals**. Its 6-layer requirement is driven entirely by:
- Heavy copper (2oz) needed for power fill current capacity
- Type VII (epoxy-filled) thermal vias throughout the 41mm×81mm supercap shadow zone
- GND_CHASSIS ring with 2.5mm staggered via-stitching on 4 copper layers
- Inner layer isolation of switching noise from regulated output rails
- 3mm rib clearway keepout region around board perimeter

**Filter against available 6-layer options:**

| Stackup | Outer Cu | Inner Cu | Suits PM? | Reason |
|---|---|---|---|---|
| JLC06161H-1080 | 1oz | H/HOZ | ❌ | 1oz outer insufficient for GND_CHASSIS/power fills |
| JLC06161H-3313 | 1oz | H/HOZ | ❌ | 1oz outer insufficient |
| **JLC061621-3313** | **2oz** | **1oz** | **✅** | 2oz outer for fills; 1oz inner for current-carrying routes |
| JLC061621-3313A | 2oz | 1oz | ⚠ | Same trace widths; thin L2/L3 core (3.9 mil) — undesirable |
| JLC06162H-3313 | 2oz | H/HOZ | ⚠ | H/HOZ inner too thin for power current routing |

**Winner: `JLC061621-3313`**

Independent justification (not just "match CTL"):
1. **2oz outer required** — heavy GND_CHASSIS fills, power rail fills, thermal halos
2. **1oz inner preferred over H/HOZ** — PM routes power currents (up to several amps) on inner layers; thicker inner copper gives lower sheet resistance and better current handling
3. **CI service NOT required** — PM has no differential or high-speed signals; JLCPCB's impedance-controlled service and TDR verification can be explicitly opted out, reducing cost

This is coincidentally the same stackup as CTL, giving **one 6-layer stackup across all 6-layer boards**. That outcome simplifies BOM management and spares sourcing, but it is justified independently for each board.

### Final Stackup Selections (User-confirmed 2026-05-10)

| Board group | Count | Stackup | CI service? | Notes |
|---|---|---|---|---|
| All 4-layer boards | 8 | `JLC041621-3313` | Required | ROT, STA, EXT, REF, ENC, JM, AM + future expansion |
| CTL (6-layer) | 1 | `JLC061621-3313` | Required | Two independent reasons: BI_DB crossover + USB SS layer isolation |
| PM (6-layer) | 1 | `JLC061621-3313` | NOT required | Thermal/power-dominated; no CI signals |

**Net result:** One stackup code per layer-count group. No mixed variants.

---

### JLCPCB Calculator Verification — What to Run

The IPC-2141A values in this document are calibrated estimates. Before writing trace widths to
GRS or any Design_Spec, the exact widths must be confirmed via the JLCPCB online impedance
calculator at: **jlcpcb.com → PCB quote → Impedance Control → Stackup calculator**

Select stackup `JLC041621-3313` and `JLC061621-3313` in turn, then record values for:

#### For each stackup, collect:

| Target impedance | Trace type | Layer | Notes |
|---|---|---|---|
| 50 Ω | Microstrip | Outer (L1/L4 or L1/L6) | CI outer traces |
| 50 Ω | Stripline | Inner (L2/L3 or L2/L5) | CI inner traces |
| 90 Ω | Diff microstrip | Outer | USB 2.0 D+/D− |
| 100 Ω | Diff stripline | Inner | GbE MDI, USB SS pairs |

#### Estimated values (IPC-2141A calibrated, for reference only):

**`JLC041621-3313` (4-layer, H_outer = 3.62 mil, H_inner = 3.62 mil):**
- W50_outer ≈ 5.1 mil (2oz outer, Dk_eff = 3.00)
- W50_inner ≈ 6.6 mil (1oz inner, Dk_eff = 3.00)
- W/S for 100 Ω diff pair inner: ≈ 6.6/3.6/6.6 mil (total footprint 16.8 mil)

**`JLC061621-3313` (6-layer, same prepreg geometry):**
- W50_outer ≈ 5.1 mil (same H as 4-layer — outer prepreg is common)
- W50_inner ≈ 6.6 mil (same inner core height)
- W/S for 100 Ω diff pair inner: ≈ 6.6/3.6/6.6 mil

> These values are expected to be identical because the 3313 prepreg thickness and inner core
> thicknesses are the same in both stackups. The JLCPCB calculator will give the authoritative
> values that will actually be written to design documents.

#### Manufacturing floor reminder:
- Minimum trace width at JLCPCB: **3.5 mil**
- Both estimated W50_outer values (≈ 5.1 mil) are comfortably above floor ✅

---

## 21. JLCPCB Calculator — Authoritative Results (2026-05-10)

All values obtained directly from the JLCPCB online impedance calculator.
These supersede all IPC-2141A estimates in this document.
Source: jlcpcb.com → PCB Quote → Impedance Control → Stackup calculator
Method: Non-coplanar (no same-layer ground pour) for all entries.

### `JLC041621-3313` — 4-layer, 2oz outer / 1oz inner

#### Confirmed physical stackup

| Layer | Material | Thickness (mil) | Thickness (mm) |
|---|---|---|---|
| L1 | Outer copper 2oz | 2.76 | 0.0700 |
| Prepreg | 3313 RC57% 4.2mil | 3.62 | 0.0920 |
| L2 | Inner copper 1oz | 1.18 | 0.0300 |
| Core | 1.3mm 1/1oz with copper | 48.43 | 1.2300 |
| L3 | Inner copper 1oz | 1.18 | 0.0300 |
| Prepreg | 3313 RC57% 4.2mil | 3.62 | 0.0920 |
| L4 | Outer copper 2oz | 2.76 | 0.0700 |

L2–L3 references: H_top = 3.62 mil (3313 prepreg), H_bottom = 48.43 mil (core) — highly asymmetric; top reference dominates.

#### Authoritative trace widths

| Target Ω | Type | Layer | Top Ref | Bot Ref | W (mm) | W (mil) | S (mm) | S (mil) |
|---|---|---|---|---|---|---|---|---|
| 50 Ω SE | Microstrip (non-coplanar) | L1 | — | L2 | **0.1425** | **5.61** | — | — |
| 50 Ω SE | Stripline (non-coplanar) | L2 | L1 | L3 | **0.1478** | **5.82** | — | — |
| 90 Ω diff | Diff microstrip (non-coplanar) | L1 | — | L2 | **0.1468** | **5.78** | **0.2032** | **8.00** |
| 100 Ω diff | Diff stripline (non-coplanar) | L2 | L1 | L3 | **0.1128** | **4.44** | **0.2032** | **8.00** |

All values above 3.5 mil manufacturing floor ✅

---

### `JLC061621-3313` — 6-layer, 2oz outer / 1oz inner

#### Confirmed physical stackup

| Layer | Material | Thickness (mil) | Thickness (mm) |
|---|---|---|---|
| L1 | Outer copper 2oz | 2.76 | 0.0700 |
| Prepreg | 3313 RC57% 4.2mil | 3.62 | 0.0920 |
| L2 | Inner copper 1oz | 1.18 | 0.0300 |
| Core | 0.45mm 1/1oz without copper | 17.72 | 0.4500 |
| L3 | Inner copper 1oz | 1.18 | 0.0300 |
| Prepreg | 2116 RC54% 4.9mil | 4.29 | 0.1090 |
| Prepreg | 2116 RC54% 4.9mil | 4.29 | 0.1090 |
| L4 | Inner copper 1oz | 1.18 | 0.0300 |
| Core | 0.45mm 1/1oz without copper | 17.72 | 0.4500 |
| L5 | Inner copper 1oz | 1.18 | 0.0300 |
| Prepreg | 3313 RC57% 4.2mil | 3.62 | 0.0920 |
| L6 | Outer copper 2oz | 2.76 | 0.0700 |

Stackup total: ~1.562mm raw laminate (→ finished ~1.6mm board ✅)
L2–L3 gap: 17.72 mil core (H_top = 3.62 mil above to L1, H_bottom = 17.72 mil to L3 — much more symmetric than 4-layer)
L3–L4 gap: 2× 2116 prepreg = 8.58 mil total
Symmetry: L1–L2–core–L3 mirrors L4–core–L5–L6 ✅

#### Authoritative trace widths

| Target Ω | Type | Layer | Top Ref | Bot Ref | W (mm) | W (mil) | S (mm) | S (mil) |
|---|---|---|---|---|---|---|---|---|
| 50 Ω SE | Microstrip (non-coplanar) | L1 | — | L2 | **0.1425** | **5.61** | — | — |
| 50 Ω SE | Stripline (non-coplanar) | L2 | L1 | L3 | **0.1387** | **5.46** | — | — |
| 90 Ω diff | Diff microstrip (non-coplanar) | L1 | — | L2 | **0.1468** | **5.78** | **0.2032** | **8.00** |
| 100 Ω diff | Diff stripline (non-coplanar) | L2 | L1 | L3 | **0.1123** | **4.42** | **0.2032** | **8.00** |

All values above 3.5 mil manufacturing floor ✅

---

## 22. Cross-Stackup Comparison — Final Authoritative Values

### Outer layer (microstrip) — identical for both stackups

Both stackups use 3313 RC57% prepreg for the outer layer (H = 3.62 mil), so outer-layer
impedance geometry is identical. The same trace widths apply to L1/L4 (4-layer) and L1/L6 (6-layer).

| Target Ω | Type | W (mm) | W (mil) | S (mm) | S (mil) |
|---|---|---|---|---|---|
| 50 Ω SE | Microstrip | 0.1425 | **5.61** | — | — |
| 90 Ω diff | Diff microstrip | 0.1468 | **5.78** | 0.2032 | **8.00** |

### Inner layer (stripline) — differs between stackups

The 4-layer core (1.23mm) is much thicker than the 6-layer inner core (0.45mm), making the
4-layer L2 more asymmetric (top-dominated). The 6-layer L2 is more symmetric, requiring
a slightly narrower trace for the same impedance.

| Target Ω | Type | `JLC041621-3313` 4L W (mm) | 4L W (mil) | `JLC061621-3313` 6L W (mm) | 6L W (mil) | S (mm) | S (mil) |
|---|---|---|---|---|---|---|---|
| 50 Ω SE | Stripline | 0.1478 | **5.82** | 0.1387 | **5.46** | — | — |
| 100 Ω diff | Diff stripline | 0.1128 | **4.44** | 0.1123 | **4.42** | 0.2032 | **8.00** |

Diff pair spacing is identical (8.00 mil / 0.2032mm) for all inner-layer cases.

### Routing feasibility checks (confirmed)

**100 Ω diff pair inner layer total footprint:**
- 4-layer: 4.44 + 8.00 + 4.44 = **16.88 mil**
- 6-layer: 4.42 + 8.00 + 4.42 = **16.84 mil**
- RJ45 inter-pin channel: ~41 mil → fits with margin ✅
- USB 3.0 lateral fan-out: confirmed feasible ✅

**90 Ω diff pair outer layer total footprint:**
- Both: 5.78 + 8.00 + 5.78 = **19.56 mil**

**All values above 3.5 mil JLCPCB manufacturing floor ✅**

### IPC-2141A estimate accuracy (post-calibration check)

| Value | IPC estimate (mil) | Actual (mil) | Error |
|---|---|---|---|
| 50 Ω SE outer | ~5.1 | 5.61 | −9% (estimate was low) |
| 50 Ω SE inner (4L) | ~6.6 | 5.82 | +13% (estimate was high) |
| 50 Ω SE inner (6L) | ~6.6 | 5.46 | +21% (estimate was high) |

Direction of estimates was correct; magnitude was off by up to ~21%. Calculator values are mandatory — estimates not suitable for spec documents.

---

## 23. Via Design Considerations — CTL 6-Layer (Layout Phase Notes)

These considerations do not change the impedance-controlled trace widths. They are layout-phase
design rules that arise from routing CI signals on inner layers (L2/L5) of the 6-layer CTL board.

### Via stub resonance (6-layer)

Through-hole vias connecting L1 pads to L2 traces leave a stub from L2 to L6.
- Stub length ≈ total board (~1.562mm) − L1 copper (0.070mm) − prepreg (0.092mm) − L2 copper (0.030mm) ≈ **1.37mm = 54 mil**
- Stub resonance frequency ≈ c / (4 × 0.00137m × √4.2) ≈ **~27 GHz**
- GbE signal BW: ~1 GHz; USB 3.0 Gen1: 5 GHz fundamental
- **Back-drilling not required ✅** — stub resonance is well above all signal frequencies on this board

### Via types by location

| Location | Via type | CI? | Notes |
|---|---|---|---|
| CM5 Amphenol connector pads | Via-in-pad (filled + capped) | Yes | Connector pitch (~0.6–0.8mm) likely requires VIP; JLCPCB supports resin-filled capped VIP |
| ESD TVS (RJ45 line side) | Standard through via L1↔L2 | Yes | TVS must be placed on line side (before magnetics primary) for PoE++ line protection |
| RJ45 pin → magnetics primary | Standard through via L1↔L2 each end | Yes | Keep +/− via pair symmetrically placed and close together to maintain differential balance |
| Magnetics secondary → CM5 path | Standard through via L2↔L1 | Yes | CI section terminates here |
| PoE++ center tap → controller | Non-CI standard via | No | DC power path extracted at magnetics center tap; no impedance control needed |
| PoE rectifier → DC/DC converter | Non-CI, wide pour | No | Low frequency / DC; route as standard power copper |

### Layout rules implied

1. **Differential via pairs:** + and − vias for any diff pair transition must be placed symmetrically
   and kept as close together as practical to preserve differential balance through the transition.

2. **Anti-pad sizing:** The L1 GND pour must have clearance (anti-pad) around each via barrel
   carrying CI signals. Typical: via drill diameter + 0.2–0.3mm clearance each side.
   This prevents capacitive loading of the via transition from the GND plane.

3. **ESD placement on line side:** For PoE++ (802.3bt), ESD TVS must be on the RJ45 line side
   (before the isolation transformer primary). The TVS absorbs transient overvoltage that
   would otherwise damage the magnetics. This means the CI routing section includes a short
   L1 run from the RJ45 pin to the ESD via, then L2 CI routing to the magnetics.

4. **PoE++ power path is non-CI:** Power is extracted from the magnetics center taps.
   The center-tap routing to the PoE controller, rectifier, and DC/DC converter is DC or
   very low frequency — route as standard wide copper pours with no impedance control.
   This is entirely separate from the data pair CI routing.

5. **Via-in-pad for CM5 Amphenol:** Filled and capped (not just tented). Resin fill preferred
   to prevent solder wicking into the via barrel during reflow. JLCPCB offers this as an option
   (adds cost). Required if pad pitch does not allow via placement adjacent to pad.

### Summary

The trace widths in §22 remain correct and unaffected by via count. The via transitions introduce
local impedance discontinuities managed by anti-pad sizing and differential via symmetry — these
are layout-phase concerns that do not require changes to the spec-level trace width values.


