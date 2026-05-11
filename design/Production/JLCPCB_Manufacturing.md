# JLCPCB Manufacturing Specification

**Status:** Draft
**Project:** Enigma-NG
**Author:** Izzyonstage & GitHub Copilot
**Version:** v.0.1.0
**Associated Hardware Revision:** Rev A
**Last Updated:** 2026-05-11

This document defines the JLCPCB fabrication and assembly constraints that apply across all
Enigma-NG boards. Board-level design specifications and the Global Routing Specification (GRS)
should reference this document rather than restating these constraints individually.

---

## 1. Board Stackups

### 1.0 Stackup Code Naming Convention

JLCPCB stackup codes follow the pattern: `JLC` + `0N` (layer count, zero-padded) + `16` (1.6mm
nominal board thickness) + `21` (copper weight: 2oz outer / 1oz inner) + `-PPPP` (primary prepreg type).

| Code segment | Meaning | Example value |
| :--- | :--- | :--- |
| `JLC` | JLCPCB identifier | fixed |
| `04` or `06` | Layer count (4-layer or 6-layer) | `04`, `06` |
| `16` | Board thickness (1.6mm nominal) | `16` |
| `21` | Copper weight (2oz outer / 1oz inner) | `21` |
| `-3313` or `-3313` | Primary prepreg type (outermost dielectric layer) | `-3313` |

**System stackup codes:**

| Stackup code | Layer count | Boards |
| :--- | :--- | :--- |
| `JLC041621-3313` | 4-layer, 2oz outer / 1oz inner | ROT, STA, EXT, REF, ENC, JM, AM, USM (8 boards) |
| `JLC061621-3313` | 6-layer, 2oz outer / 1oz inner | CTL (CI required), PM (CI not required) |

> **Note:** Older documents (pre-DEC-065) used the codes `JLC04161H-7628` and `JLC06161H-2116`.
> These codes were incorrect interpretations of the JLCPCB stackup naming scheme and have been
> replaced throughout. `JLC041621-3313` and `JLC061621-3313` are the correct, authoritative codes.

---

### 1.1 Four-Layer 2oz Stackup — JLC041621-3313

This is the standard stackup for all Enigma-NG boards **except** the Controller Board and Power Module.

**Physical stackup (JLCPCB-authoritative):**

| Layer / Material | Thickness (mil) | Thickness (mm) | Copper Weight |
| :--- | :--- | :--- | :--- |
| L1 — Outer Copper | 2.76 | 0.070 | 2oz |
| Prepreg — 3313 RC57% | 3.62 | 0.092 | — |
| L2 — Inner Copper | 1.18 | 0.030 | 1oz |
| Core — FR4 (1/1oz without copper) | ~48.5 | ~1.231 | — |
| L3 — Inner Copper | 1.18 | 0.030 | 1oz |
| Prepreg — 3313 RC57% | 3.62 | 0.092 | — |
| L4 — Outer Copper | 2.76 | 0.070 | 2oz |
| **Total** | | **≈ 1.6 mm ✓** | |

**Prepreg dielectric properties (3313 RC57%):** h = 0.092 mm, Eᵣ = 4.2

**Controlled-impedance trace widths — JLCPCB calculator authoritative (non-coplanar):**

| Target | Type | Layer | Trace Width | Spacing |
| :--- | :--- | :--- | :--- | :--- |
| 50Ω SE | Microstrip | L1 (outer) | **0.1425 mm (5.61 mil)** | — |
| 50Ω SE | Stripline | L2 (inner) | **0.1478 mm (5.82 mil)** | — |
| 90Ω diff | Diff microstrip | L1 (outer) | **0.1468 mm (5.78 mil)** | **0.2032 mm (8.00 mil)** |
| 100Ω diff | Diff stripline | L2 (inner) | **0.1128 mm (4.44 mil)** | **0.2032 mm (8.00 mil)** |

> **IPC-2141A accuracy warning:** IPC-2141A estimates deviate significantly from the JLCPCB calculator
> for this stackup: outer 50Ω IPC estimate is approximately **−9% low**; inner 50Ω IPC estimate is
> approximately **+13% high**. Use JLCPCB calculator values only. Do **not** use IPC-2141A.

**Boards using this stackup:** Rotor (A+B), Stator, Extension, Reflector,
User Settings Module (USM), Actuation Module, Encoder, JTAG Module

**Design rule reference:** `design/Standards/Global_Routing_Spec.md §2.3.1` (standard 4-layer) and `§2.3.2` (inverted 4-layer — JTAG Module, Actuation Module)

---

### 1.2 Six-Layer 2oz Stackup — JLC061621-3313

This stackup is used by the **Controller Board** and the **Power Module**.

**Physical stackup (JLCPCB-authoritative):**

| Layer / Material | Thickness (mil) | Thickness (mm) | Copper Weight |
| :--- | :--- | :--- | :--- |
| L1 — Outer Copper | 2.76 | 0.070 | 2oz |
| Prepreg — 3313 RC57% | 3.62 | 0.092 | — |
| L2 — Inner Copper | 1.18 | 0.030 | 1oz |
| Core (L2–L3) — 1/1oz without copper | 17.72 | 0.450 | — |
| L3 — Inner Copper | 1.18 | 0.030 | 1oz |
| Prepreg — 2116 RC54% | 4.29 | 0.109 | — |
| Prepreg — 2116 RC54% | 4.29 | 0.109 | — |
| L4 — Inner Copper | 1.18 | 0.030 | 1oz |
| Core (L4–L5) — 1/1oz without copper | 17.72 | 0.450 | — |
| L5 — Inner Copper | 1.18 | 0.030 | 1oz |
| Prepreg — 3313 RC57% | 3.62 | 0.092 | — |
| L6 — Outer Copper | 2.76 | 0.070 | 2oz |
| **Total** | | **≈ 1.6 mm ✓** | |

**Controlled-impedance trace widths — JLCPCB calculator authoritative (non-coplanar):**

| Target | Type | Layer | Trace Width | Spacing |
| :--- | :--- | :--- | :--- | :--- |
| 50Ω SE | Microstrip | L1 or L6 (outer) | **0.1425 mm (5.61 mil)** | — |
| 50Ω SE | Stripline | L2 (inner, ref L1/L3) | **0.1387 mm (5.46 mil)** | — |
| 90Ω diff | Diff microstrip | L1 or L6 (outer) | **0.1468 mm (5.78 mil)** | **0.2032 mm (8.00 mil)** |
| 100Ω diff | Diff stripline | L2 (inner, ref L1/L3) | **0.1123 mm (4.42 mil)** | **0.2032 mm (8.00 mil)** |

> **IPC-2141A accuracy warning:** IPC-2141A estimates deviate significantly from the JLCPCB calculator
> for this stackup: outer 50Ω IPC estimate is approximately **−9% low**; inner 50Ω IPC estimate is
> approximately **+21% high**. Use JLCPCB calculator values only. Do **not** use IPC-2141A.

**Boards using this stackup:**

| Board | CI service required? | Reason |
| :--- | :--- | :--- |
| Controller Board | **Yes — required** | USB 3.0 SS, USB 2.0, HDMI, Ethernet BI_D diff pairs on inner layers; TDR-verified widths mandatory |
| Power Module | **No — not required** | Power-dominated board; no high-speed differential pairs requiring TDR-verified widths |

**Design rule reference:** `design/Standards/Global_Routing_Spec.md §2.3.3`

---

### 1.3 JLCPCB Stackup Catalog — Evaluated Options

The following table records all JLCPCB stackup options evaluated during the stackup selection process
(DEC-065). Options not selected are retained here for traceability.

| Code | Layers | Thickness | Outer Cu | Inner Cu | Prepreg | Status |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `JLC041621-3313` | 4L | 1.6mm | 2oz | 1oz | 3313 RC57% | ✅ **Selected** — system standard 4-layer |
| `JLC061621-3313` | 6L | 1.6mm | 2oz | 1oz | 3313 + 2116 | ✅ **Selected** — system standard 6-layer |
| `JLC04161H-7628` | 4L | 1.6mm | 2oz | 1oz | 7628 | ❌ Eliminated — incorrect code interpretation; 7628 prepreg gives higher Eᵣ, requiring narrower traces than calculator confirms |
| `JLC06161H-2116` | 6L | 1.6mm | 2oz | 1oz | 2116 | ❌ Eliminated — incorrect code interpretation; replaced by JLC061621-3313 |
| `JLC041621-7628` | 4L | 1.6mm | 2oz | 1oz | 7628 | ❌ Not selected — 7628 prepreg is higher loss at GHz frequencies vs 3313 |
| `JLC041221-3313` | 4L | 1.2mm | 2oz | 1oz | 3313 | ❌ Not selected — 1.2mm thickness non-standard for system; connector mating assumes 1.6mm |

## 2. PCB Fabrication Capabilities and Constraints

**Source:** [JLCPCB PCB Capabilities](https://jlcpcb.com/capabilities/pcb-capabilities) — verify
all values in this section against the live page before design sign-off, as JLCPCB periodically
update their published limits.

All boards are fabricated using JLCPCB's standard PCB service. The following constraints apply
and must be respected in all board designs.

| Parameter | Constraint | Notes |
| :--- | :--- | :--- |
| Minimum trace width | 0.09mm (3.5 mil) | GRS specifies 0.127mm CI minimum; 0.20mm signal minimum — both are above this limit |
| Minimum trace spacing | 0.09mm (3.5 mil) | GRS 10 mil (0.254mm) clearance requirement is more conservative |
| Minimum via drill | 0.2mm (drill); 0.45mm (pad) | Standard vias only; see §2.1 |
| Blind / buried vias | **Not supported** | No blind or buried vias on any board |
| Minimum hole size (drill) | 0.2mm | Mechanical NPTH and PTH |
| Minimum annular ring | 0.1mm (one side) | GRS specifies 6.0mm ENIG ring for mounting holes (far exceeds minimum) |
| Board thickness | 1.6mm nominal (±10%) | All boards in this design target 1.6mm |
| Surface finish | ENIG (Electroless Nickel Immersion Gold) | System-wide; provides flat, solderable, gold-plated surface |
| Copper weight | 2oz finished copper | System-wide; matches GRS §1.1 trace width calculations |
| Solder mask | Both sides | LPI solder mask on all boards |
| Silkscreen | Both sides | See GRS §10.1 for pin-1 silkscreen requirements |
| Min silkscreen line width | 0.153mm | |
| Max board size | 500mm × 470mm | Enigma-NG boards are well within this limit |
| Panelisation | Available (V-cut, tab-route) | May be useful for small boards (Rotor, USM) |

### 2.1 Via Constraints

JLCPCB standard service supports **through-hole vias only**. Blind and buried vias are **not
available** on the standard 4-layer or 6-layer service.

| Via type | Supported | Notes |
| :--- | :--- | :--- |
| Through-hole via | ✔ Yes | Standard; min drill 0.2mm, min pad 0.45mm |
| Blind via | ❌ No | Not available on standard service |
| Buried via | ❌ No | Not available on standard service |
| Micro-via | ⚠️ Non-standard service | Available; requires advanced/HDI service tier — verify current offering on JLCPCB capabilities page |
| Back-drill | ⚠️ Non-standard service | Available; requires explicit quotation — verify current offering on JLCPCB capabilities page |

---

## 3. PCBA (Assembly) Service Constraints

JLCPCB offers a PCBA (PCB Assembly) service with SMT component placement. The following
constraints must be understood and accounted for in board designs.

### 3.1 Assembly Side Constraint

| Constraint | Detail |
| :--- | :--- |
| **SMT assembly side** | **Single-sided only** on standard service |
| THT placement | Manual fit required (not included in JLCPCB PCBA standard service) |
| Double-sided SMT | Available on **Economic PCBA** service with limitations; requires explicit quotation |

> **Design note for Reflector Board:** The Reflector is a single-sided SMT assembly. All SMT
> components must be on the same board face to use JLCPCB standard PCBA. This is an explicit
> design constraint, not a limitation — see `design/Electronics/Reflector/Design_Spec.md`.

### 3.2 THT Components

All THT components (headers, connectors, DIP switches, pin headers, through-hole capacitors)
require **manual fitting** after JLCPCB PCBA. These components are excluded from the JLCPCB
PCBA BOM and assembled separately. Each board design spec identifies which components are
manually fitted.

### 3.3 Component Library Types

| Library type | Description | Assembly surcharge |
| :--- | :--- | :--- |
| Basic | Pre-loaded in JLCPCB feeders; no extra fee | None |
| Preferred | JLCPCB preferred parts; low surcharge | Low |
| Extended | Requires feeder setup fee per unique part | ~$3 per unique part |

> **Note:** Where a BOM entry shows `Global sourcing / consignment` in the JLCPCB PN column,
> the component must be sourced and consigned to JLCPCB separately.

### 3.4 Minimum Order Quantity (MOQ)

| Parameter | Value |
| :--- | :--- |
| PCBA MOQ (standard) | 2 boards per order |
| PCBA MOQ (prototype) | 5 boards (Economic PCBA) |

---

## 4. Design Rule Cross-References

| Document | Relationship |
| :--- | :--- |
| `design/Standards/Global_Routing_Spec.md` | System-wide routing rules; references this document for stackup details |
| `design/Electronics/Controller/Design_Spec.md §9` | Controller-specific 6-layer stackup (JLC061621-3313) |
| `design/Electronics/Rotor/Design_Spec.md §4` | Rotor 4-layer stackup (JLC041621-3313) |
| `design/Electronics/Stator/Design_Spec.md §7` | Stator fabrication requirements |
| `design/Electronics/Power_Module/Design_Spec.md §8` | Power Module fabrication requirements |
