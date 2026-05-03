# Lightboard Assembly - Mechanical Design Specification

**Status:** Draft
**Project:** Enigma-NG
**Author:** Izzyonstage & GitHub Copilot
**Version:** v.0.1.0
**Associated Hardware Revision:** Rev A
**Last Updated:** 2026-04-20

---

## 1. Overview

A standalone indicator lightboard assembly that mirrors the operator-facing HID character layout.
This assembly contains the lightboard panel, the lamp / indicator harness, and one Encoder Module
populated/programmed in the **`LBD_DEC`** role.

The lightboard assembly is electrically independent of the keyboard assembly. It connects to the
Stator through its own 20-pin IDC ribbon on the dedicated `LBD_DEC` port.

---

## 2. Indicator Layout

The lightboard mirrors the same **40-position physical layout** used by the keyboard assembly.

* **Printable indicator positions (x38):** `[a-z0-9+=]`.
* **Alphabetic case handling:** uppercase alphabetic outputs illuminate the matching alphabetic
  indicator position rather than a separate uppercase-only physical position.
* **Layout pairing:** keyboard and lightboard panel geometry should remain visually aligned so the
  illuminated output corresponds to the operator's expected key position.

> For the character-space mapping and decode behaviour, see
> `design/Electronics/Encoder/Design_Spec.md §6 Key Mapping`.

---

## 3. Encoder Allocation

The lightboard assembly uses one generic Encoder Module in **decode** service:

* Stator drives `ENC_DATA[5:0]` into the `LBD_DEC` board via the Stator-side alias `ENC_OUT_LBD[5:0]`.
* The board asserts one of up to 64 output lines.
* Initial Rev A implementations may populate only the 26- or 40-position lightboard subset, while
  the board footprint retains the full 64-line capability for future layouts.

---

## 4. Service / Packaging Intent

* The lightboard is its own serviceable assembly and must be removable without disturbing the
  keyboard assembly.
* Harnessing should preserve direct one-to-one mapping between populated indicator positions and the
  assigned Encoder output terminals.
* The assembly split is intentional so keyboard and lightboard packaging can evolve independently.

---

## 5. Cross-References

| Document | Description |
| :--- | :--- |
| `design/Electronics/Encoder/Design_Spec.md` | Generic Encoder Module pinout and decode-role definition |
| `design/Mechanical/Keyboard_Assembly/Design_Spec.md` | Matched keyboard assembly using the same logical layout |
