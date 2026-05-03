# Gadgetskingdom / uxcell DPDT Keyboard Switch - Pseudo Datasheet

**Status:** Pseudo datasheet derived from marketplace listing metadata
**Project:** Enigma-NG
**Author:** Izzyonstage & GitHub Copilot
**Version:** v.0.1.0
**Last Updated:** 2026-04-20
**Source Listing:** eBay item `365271584375`
**Seller:** `gadgetskingdom`
**Brand Shown on Listing:** `uxcell`
**Listing Title:** `Momentary Push Button Switch DPDT 2 Pole 6 Pin 1 Position 2pcs`
**Original URL:** <https://www.ebay.co.uk/itm/365271584375>

---

## 1. Purpose

This document captures the technical details that could be recovered from the marketplace listing
for the custom keyboard switch already purchased for the Enigma-NG HID assembly. It is **not** a
manufacturer-issued datasheet and must be treated as a project-side reference only.

Use this part only where a custom, single-source marketplace switch is acceptable and where a full
component qualification trail is not available.

---

## 2. Intended Enigma-NG Use

- **Assembly:** `design/Mechanical/Keyboard_Assembly/Design_Spec.md`
- **Board interface:** `design/Electronics/Encoder/Design_Spec.md`
- **Function:** HID keyboard switch for the QWERTY-derived 40-position operator panel
- **System quantity:** 40 switches total
- **Electrical use in Enigma-NG:** only **Pole 1** is used electrically (`COM1 + NO1`); the second
  pole is retained for mechanical anchoring only

---

## 3. Observed Listing Specifications

The following values were extracted directly from the eBay listing HTML:

| Parameter | Value from listing |
| :--- | :--- |
| Switch operation | Momentary |
| Contact configuration | DPDT |
| Position quantity | 1 |
| Terminal type | Straight through-hole |
| Pin quantity | 6 |
| Pin pitch | 4 mm |
| End width | 9 mm |
| Mounting pillar distance | 5 mm |
| Cap mounting part | 8 mm x 3.3 mm |
| Overall size | 42 mm x 9.7 mm x 18 mm |
| Materials | Plastic, metal |
| Pack quantity | 2 pieces |

Listing description text:

> Momentary contact, 6 pins, DIP through hole mounting. Used in the fields of electronic products,
> household appliances and more. High precision mechanism design offers acute operation and long
> service life.

---

## 4. Enigma-NG Integration Notes

| Attribute | Enigma-NG usage note |
| :--- | :--- |
| Contact style | Treat as a normally-open momentary key input on Pole 1 |
| Mounting | Keyboard-panel mounted with harness wiring back to Encoder spade inputs |
| Logic interface | Active-low key input to Encoder CPLD (`COM1 -> input`, `NO1 -> GND`) |
| Pole 2 | Do not assign an electrical net unless a future decision explicitly reuses it |
| Panel role | Custom keyboard key actuator, not a general-purpose front-panel pushbutton |

---

## 5. Known Unknowns / Unverified Parameters

The listing did **not** provide a trustworthy manufacturer datasheet for these items:

- Contact voltage / current rating
- Contact material and plating
- Operating force
- Travel distance
- Mechanical life / electrical life
- Insulation resistance / dielectric withstand
- Operating temperature range
- Exact manufacturer part number
- Compliance data (RoHS, REACH, UL, etc.)
- Tolerance on the quoted dimensions

These values remain **unverified** and should not be invented elsewhere in the design docs.

---

## 6. Procurement and Risk Notes

- This is a **single-source marketplace part** rather than a catalogue component with a stable MPN.
- The seller name and the visible brand (`uxcell`) may change independently of the physical part.
- Additional spare stock should be retained once the keyboard panel design is frozen.
- If long-term maintainability becomes more important than preserving the already purchased hardware,
  this part should be revisited as a future sourcing/risk-reduction task.

---

## 7. Document Status

This pseudo datasheet is sufficient to preserve the currently known dimensions and switching style
for the purchased Enigma-NG keyboard switches. It does **not** replace a real manufacturer datasheet.
