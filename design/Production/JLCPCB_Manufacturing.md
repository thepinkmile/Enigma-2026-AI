# JLCPCB Manufacturing Specification

**Status:** Draft
**Project:** Enigma-NG
**Author:** Izzyonstage & GitHub Copilot
**Version:** v.0.1.0
**Associated Hardware Revision:** Rev A
**Last Updated:** 2026-07-11

This document defines the JLCPCB fabrication and assembly constraints that apply across all
Enigma-NG boards. Board-level design specifications and the Global Routing Specification (GRS)
should reference this document rather than restating these constraints individually.

---

## 1. Board Stackups

### 1.1 Four-Layer 2oz Stackup — JLC04161H-7628

This is the standard stackup for all Enigma-NG boards **except** the Controller Board.

| Layer | Material | Thickness | Copper Weight |
| :--- | :--- | :--- | :--- |
| Top (L1) | Copper | — | 2oz |
| Prepreg | 7628 | 0.21mm | — |
| Inner (L2) | Copper | — | 2oz |
| Core | FR4 | 1.065mm | — |
| Inner (L3) | Copper | — | 2oz |
| Prepreg | 7628 | 0.21mm | — |
| Bottom (L4) | Copper | — | 2oz |
| **Total board thickness** | | **≈ 1.6mm** | |

**Controlled impedance reference:**

- Single-ended 50Ω (microstrip, L1): ~0.127mm (5 mil) trace over L2 GND plane
- Differential 100Ω (microstrip, L1): two 0.127mm traces with ~0.127mm gap

**Boards using this stackup:** Rotor (A+B), Stator, Extension, Reflector, Power Module,
User Settings Module (USM), Actuation Module, Encoder

**Design rule reference:** `design/Standards/Global_Routing_Spec.md §2`

---

### 1.2 Six-Layer 2oz Stackup — JLC06161H-2116

This stackup is used **only by the Controller Board**, which requires additional signal layers
for high-speed routing of USB 3.0, HDMI, Gigabit Ethernet, and the CM5 dual 200-pin connectors.

| Layer | Material | Thickness | Copper Weight |
| :--- | :--- | :--- | :--- |
| Top (L1) | Copper | — | 2oz |
| Prepreg | 2116 | 0.12mm | — |
| Inner (L2) | Copper | — | 2oz |
| Core | FR4 | 0.36mm | — |
| Inner (L3) | Copper | — | 2oz |
| Prepreg | 2116 | 0.12mm | — |
| Inner (L4) | Copper | — | 2oz |
| Core | FR4 | 0.36mm | — |
| Inner (L5) | Copper | — | 2oz |
| Prepreg | 2116 | 0.12mm | — |
| Bottom (L6) | Copper | — | 2oz |
| **Total board thickness** | | **≈ 1.6mm** | |

**Boards using this stackup:** Controller Board only

**Design rule reference:** `design/Electronics/Controller/Design_Spec.md §9`

---

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
| `design/Electronics/Controller/Design_Spec.md §9` | Controller-specific 6-layer stackup (JLC06161H-2116) |
| `design/Electronics/Rotor/Design_Spec.md §4` | Rotor 4-layer stackup (JLC04161H-7628) |
| `design/Electronics/Stator/Design_Spec.md §7` | Stator fabrication requirements |
| `design/Electronics/Power_Module/Design_Spec.md §8` | Power Module fabrication requirements |
