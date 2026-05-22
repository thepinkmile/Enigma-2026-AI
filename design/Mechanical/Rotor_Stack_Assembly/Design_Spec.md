# Rotor Stack Assembly — Mechanical Design Specification

**Status:** Draft
**Project:** Enigma-NG
**Author:** Izzyonstage & GitHub Copilot
**Version:** v0.1.0
**Associated Hardware Revision:** Rev A
**Last Updated:** 2026-05-07

---

## 1. Overview

The Rotor Stack Assembly defines the mechanical and dimensional properties of a **mini-stack**: the
fundamental operational unit of the Enigma-NG rotor system. A mini-stack consists of five
individual rotor modules stacked along a shared central shaft, bounded at each end by an enclosure
board (STA/EXT at the low end, EXT/REF at the high end). Multiple mini-stacks are chained through
Extension boards to form the full 30-rotor machine.

This document captures:

* Mini-stack grouping and boundary definition
* Inter-rotor PCB-to-PCB separation (connector-driven, not a free mechanical variable)
* Dimensional constraints the inter-rotor gap must satisfy
* Why total mini-stack depth remains **TBD** pending STA/EXT/REF enclosure details

> **This document does not define the individual rotor module.** For the individual rotor assembly
> (shroud, bearings, encoder slots, internal headers), see
> `design/Mechanical/Rotor/Design_Spec.md`.

---

## 2. Mini-Stack Definition

| Parameter | Value | Notes |
| :--- | :--- | :--- |
| Rotors per mini-stack | 5 | Fixed; mechanical carry propagates within the group |
| Low-end boundary board | STA (first group) or EXT (subsequent groups) | Carries ERF8 female sockets for Rotor 1 ERM8 male headers |
| High-end boundary board | EXT (intermediate groups) or REF (final group) | Carries ERM8 male headers for the final rotor's ERF8 sockets, or the passive Reflector |
| Total mini-stack depth | TBD | Cannot be defined until STA, EXT, and REF enclosure thicknesses are confirmed (see §5) |

The carry mechanism is mechanical within a mini-stack. At each Extension boundary, the mechanical
carry event is converted to an `ACTUATE_REQUEST` signal that regenerates a servo step for the next
mini-stack. See `design/Mechanical/Rotor_Actuation_Assembly/Design_Spec.md §7` for the carry
mechanism detail.

---

## 3. Inter-Rotor Connector Stack Height

### 3.1 Connector Selection and Stack Height

Adjacent rotor boards are connected via the **Samtec ERM8/ERF8 Edge Rate® vertical mezzanine
connector pair**. Each rotor's Board B carries ERM8 male headers (J1–J3); the adjacent rotor's
Board A carries ERF8 female sockets (J4–J6).

The board-to-board separation between adjacent rotor PCBs is **entirely determined by the connector
lead style** (the `-XX.X-` suffix in the part number). The relationship is additive:

> **Board-to-board gap = ERM8 lead style height + ERF8 lead style height**

This is confirmed by Samtec's own specification: the stated stack height range for the ERM8/ERF8
family is **7mm–18mm**, where 7mm = minimum ERM8 lead style (2mm) + minimum ERF8 lead style (5mm),
and 18mm = maximum ERM8 (9mm) + maximum ERF8 available (9mm).

### 3.2 Current Design

| Parameter | Value | Part Numbers |
| :--- | :--- | :--- |
| ERM8 lead style | 5mm (-05.0) | `ERM8-005-05.0-S-DV-K-TR` |
| ERF8 lead style | 5mm (-05.0) | `ERF8-005-05.0-S-DV-K-TR` |
| **Total PCB-to-PCB gap** | **10mm** | Confirmed from datasheets (DEC-059) |

The current -05.0/-05.0 selection represents the **minimum inter-rotor gap achievable for this
connector pairing**. It was selected to minimise the overall rotor stack footprint pending
mechanical design validation.

> **This 10mm inter-rotor gap has not yet been validated against the full list of mechanical
> clearance requirements in §4.** If mechanical testing reveals the gap is insufficient, a
> DEFECT-DEC must be raised (see §3.3).

### 3.3 Available Stack Height Options

The following lead-style variants exist in the Samtec ERM8/ERF8 family. Increasing the stack height
requires changing one or both connector MPNs; this must be formally recorded as a **DEFECT-DEC**
(amendment decision entry in `design/Design_Log/index.md`) before any part number changes are made.

| ERM8 Lead Style | ERF8 Lead Style | Total Stack Height |
| :--- | :--- | :--- |
| -02.0 (2mm) | -05.0 (5mm) | 7mm |
| -03.0 (3mm) | -05.0 (5mm) | 8mm |
| **-05.0 (5mm) ← current** | **-05.0 (5mm) ← current** | **10mm** |
| -05.0 (5mm) | -07.0 (7mm) | 12mm |
| -08.0 (8mm) | -05.0 (5mm) | 13mm |
| -05.0 (5mm) | -09.0 (9mm) | 14mm |
| -08.0 (8mm) | -07.0 (7mm) | 15mm |
| -09.0 (9mm) | -07.0 (7mm) | 16mm |
| -08.0 (8mm) | -09.0 (9mm) | 17mm |
| -09.0 (9mm) | -09.0 (9mm) | 18mm |

> **Note:** ERF8 -10.0 (10mm) is listed in the Samtec datasheet but is marked as **not tooled**
> and is therefore not available for ordering. The practical maximum is 18mm.
>
> Reducing below 10mm (e.g., using ERM8 -02.0 or -03.0 with ERF8 -05.0) is geometrically
> possible but has not been evaluated for signal integrity or mechanical fit, and would also
> require a DEFECT-DEC.

---

## 4. Inter-Rotor Gap Clearance Requirements

The 10mm PCB-to-PCB gap between adjacent rotors must simultaneously satisfy all of the following
clearance requirements. These are listed as design constraints; values are **TBD pending detailed
mechanical design**:

| Requirement | Description | Status |
| :--- | :--- | :--- |
| Shroud flange/cover thickness | The rotor shroud flanges extend over both PCB flat faces. The combined axial depth of the Board B shroud cover (of the lower rotor) and the Board A shroud dish rim (of the upper rotor) must fit within the 10mm gap. | TBD |
| Rotation gear wheel clearance | The stepping ratchet/gear wheel on each rotor shroud outer face must clear the gap between adjacent rotors without interference. | TBD |
| Mechanical case clearance | Any structural frame or casing material between adjacent rotor positions must not reduce the effective gap below the shroud + gear wheel requirements above. | TBD |
| Position encoder sensor standoff | The retention bar and actuation detent mechanism must be positioned so they do not intrude into the radial sensor zone (capacitive electrode radius r = 44mm on each PCB face). | TBD — see `design/Mechanical/Rotor/Design_Spec.md §5` for sensor geometry |

If the sum of the above clearances cannot be satisfied within 10mm, the stack height must be
increased by raising a DEFECT-DEC (§3.3).

---

## 5. Total Mini-Stack Depth

The total depth (axial length along the central shaft) of a complete mini-stack **cannot be
accurately defined at this stage**. It depends on:

1. **Individual rotor thickness** — currently ~15mm per rotor (Board A + 11.8mm internal gap +
   Board B). See `design/Mechanical/Rotor/Design_Spec.md §2`.
2. **Inter-rotor connector gap** — currently 10mm per rotor-to-rotor interface (§3.2 above).
3. **STA/EXT enclosure thickness** — the mechanical envelope of the Stator or Extension board at
   the low end of the mini-stack. Not yet defined.
4. **EXT/REF enclosure thickness** — the mechanical envelope of the Extension or Reflector board
   at the high end of the mini-stack. Not yet defined.

Indicative PCB-only calculation (no enclosures):

> 5 rotors × ~15mm + 4 inter-rotor gaps × 10mm = **75mm + 40mm = ~115mm** per mini-stack

This figure is **illustrative only** and excludes enclosures, retention hardware, and tolerance
stack-up. It must not be used as a design constraint until formally verified.

---

## 6. Cross-References

| Document | Description |
| :--- | :--- |
| `design/Mechanical/Rotor/Design_Spec.md` | Individual rotor module: shroud, bearings, encoder slots, internal header assembly, component height constraints |
| `design/Mechanical/Rotor_Actuation_Assembly/Design_Spec.md` | Depression bar, carry mechanism, and 5-rotor group stepping |
| `design/Mechanical/Complete_System_Assembly/Design_Spec.md` | Full machine assembly sequence; Extension boundary integration |
| `design/Electronics/Rotor/Design_Spec.md` | Rotor electrical spec: ERM8/ERF8 connector pinout (J1–J6), BOM |
| `design/Datasheets/erm8-xxx-xx.x-xxx-dv-xxxx-xx-mkt-datasheet.md` | Samtec ERM8 lead style definitions and dimensions |
| `design/Datasheets/erf8-xxx-xx.x-xxx-dv-xxxx-xx-mkt-datasheet.md` | Samtec ERF8 lead style definitions and dimensions |
| `design/Design_Log/DEC-059_erm8erf8-stacking-height-confirmed-rotor-stack-assembly-specification-created.md` | DEC-059 (ERM8/ERF8 -05.0 stack height confirmation) |
