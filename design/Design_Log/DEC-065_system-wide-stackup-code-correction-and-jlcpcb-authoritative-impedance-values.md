## DEC-065 - System-Wide Stackup Code Correction and JLCPCB-Authoritative Impedance Values

| Field | Value |
| :--- | :--- |
| **Decision ID** | DEC-065 |
| **Status** | Confirmed |
| **Date** | 2026-05-11 |
| **Author** | Izzyonstage & Copilot (session e39f3cc4) |
| **Amends** | All prior board Design_Spec.md files referencing stackup codes; DEC-016 (CI trace widths updated); DEC-017 (Extension stackup code corrected) |

### Context

All board Design_Spec.md files, the JLCPCB Manufacturing Specification, and the Global Routing
Specification were written using stackup codes `JLC04161H-7628` (4-layer) and `JLC06161H-2116`
(6-layer). These codes were incorrect interpretations of the JLCPCB stackup naming scheme and did
not correspond to any real JLCPCB stackup offering.

Additionally, all controlled-impedance trace widths across board specs and the GRS were estimated
using IPC-2141A rather than the JLCPCB impedance calculator. IPC-2141A estimates were found to be
significantly inaccurate for these stackups, deviating by −9% to +21% from JLCPCB calculator values.

### Decision

**Correct 4-layer stackup code:** `JLC041621-3313`
**Correct 6-layer stackup code:** `JLC061621-3313`

Code structure: `JLC` + `0N` (layer count) + `16` (1.6mm thickness) + `21` (2oz outer / 1oz inner) + `-3313` (primary prepreg type).

**JLCPCB-authoritative controlled-impedance trace widths (non-coplanar):**

| Target | Type | JLC041621-3313 (4L) | JLC061621-3313 (6L) | Spacing |
| :--- | :--- | :--- | :--- | :--- |
| 50Ω SE | Microstrip (L1 outer) | 0.1425 mm / 5.61 mil | 0.1425 mm / 5.61 mil | - |
| 50Ω SE | Stripline (inner) | 0.1478 mm / 5.82 mil | 0.1387 mm / 5.46 mil | - |
| 90Ω diff | Diff microstrip (L1 outer) | 0.1468 mm / 5.78 mil | 0.1468 mm / 5.78 mil | 0.2032 mm / 8.00 mil |
| 100Ω diff | Diff stripline (inner) | 0.1128 mm / 4.44 mil | 0.1123 mm / 4.42 mil | 0.2032 mm / 8.00 mil |

**IPC-2141A accuracy finding:**

| Estimate | IPC value | JLCPCB value | Error |
| :--- | :--- | :--- | :--- |
| Outer 50Ω microstrip | ~0.130 mm | 0.1425 mm | −9% (IPC too low) |
| Inner 50Ω stripline (4L) | ~0.167 mm | 0.1478 mm | +13% (IPC too high) |
| Inner 50Ω stripline (6L) | ~0.167 mm | 0.1387 mm | +21% (IPC too high) |

IPC-2141A shall not be used for CI trace width calculation in this design. All CI trace widths must
use the JLCPCB impedance calculator for the assigned stackup code.

**Physical stackup - JLC041621-3313 (4-layer):**

- L1/L4: 2oz outer copper = 0.070 mm; Prepreg: 3313 RC57% = 0.092 mm (h = 0.092 mm, Eᵣ = 4.2)
- L2/L3: 1oz inner copper = 0.030 mm; Core (1/1oz without copper) ≈ 1.231 mm
- Total ≈ 1.6 mm ✓

**Physical stackup - JLC061621-3313 (6-layer):**

- L1/L6: 2oz outer copper = 0.070 mm; Outer prepreg: 3313 RC57% = 0.092 mm
- L2-L5: 1oz inner copper = 0.030 mm each
- Core L2-L3 and L4-L5: 0.450 mm each; Mid prepreg: 2× 2116 RC54% = 0.109 mm each
- Total ≈ 1.6 mm ✓

**JTAG Module inverted stackup note (DEC-016):** JM uses L1=GND, L2=signals, L3=power, L4=GND
(intentionally inverted per DEC-016). JM CI trace width uses the 4-layer inner stripline value
(0.1478 mm), not the outer microstrip value.

**Controlled impedance service requirement:**

- Controller Board: CI service **required** - USB 3.0 SS, USB 2.0, HDMI, and Ethernet BI_D diff pairs on inner signal layers require TDR-verified trace widths.
- Power Module: CI service **not required** - power-dominated board; no high-speed differential pairs. 6-layer layer count was already correct; only the stackup code was wrong.

### Rationale

- JLCPCB impedance calculator results are authoritative for the fab process and supersede any
  IPC-formula estimates for this design.
- Correcting the stackup codes ensures future ordering and fab review match what is actually
  specified; incorrect codes would cause JLCPCB to use a different prepreg, invalidating all CI
  trace widths.
- The Rotor, Stator, Extension, Reflector, Encoder, JTAG Module, Actuation Module, and USM are
  all 4-layer 2oz designs; the Controller and Power Module are 6-layer 2oz designs.

### Files Changed

- `design/Electronics/Rotor/Design_Spec.md`: DR-ROT-01, §3.3 physical params (h/t/Eᵣ corrected), §4 stackup code
- `design/Electronics/Stator/Design_Spec.md`: Line 14 stackup code, DR-STA-01, §7 stackup code; bug fix §7 "0.5oz inner" → "1oz inner"
- `design/Electronics/Extension/Design_Spec.md`: DR-EXT stackup code, §4 trace width → 0.1425 mm
- `design/Electronics/Reflector/Design_Spec.md`: DR-REF-01, §2 heading, §6 stackup code
- `design/Electronics/Encoder/Design_Spec.md`: DR-ENC-01, §9 stackup code, §5 trace width → 0.1425 mm
- `design/Electronics/JTAG_Module/Design_Spec.md`: §5 stackup code, §6 trace width → 0.1478 mm (inner stripline)
- `design/Electronics/Actuation_Module/Design_Spec.md`: DR-AM-01 stackup code
- `design/Electronics/User_Settings_Module/Design_Spec.md`: overview, DR-USM-01, §8 stackup code; copper weight description corrected
- `design/Electronics/Power_Module/Design_Spec.md`: DR-PM-13 stackup code, §1 stackup text (CI not required clarified)
- `design/Electronics/Controller/Design_Spec.md`: Overview, DR-CTL-01, §9.1-§9.4 (full rewrite: layer assignments, physical stackup, authoritative trace widths, via design rules)
- `design/Production/JLCPCB_Manufacturing.md`: Full §1 rewrite (naming convention added, §1.0-§1.3; §4 cross-refs corrected)
- `design/Standards/Global_Routing_Spec.md`: §1 CI exception updated to per-stackup table reference; GRS trace width table Signal/CI row updated
