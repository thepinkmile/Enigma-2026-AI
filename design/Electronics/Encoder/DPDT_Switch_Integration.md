# DPDT Keyboard Switch — Encoder Integration Notes

**Status:** Active
**Project:** Enigma-NG
**Author:** Izzyonstage & GitHub Copilot
**Version:** v.0.1.0
**Last Updated:** 2026-05-16
**Associated Hardware Revision:** Rev A

---

## Purpose

This document records the Enigma-NG integration decisions for the DPDT keyboard switches
purchased from gadgetskingdom / uxcell. Component physical and electrical specifications are
captured in `design/Datasheets/Gadgetskingdom_DPDT_Keyboard_Switch_Pseudo_Datasheet.md`.

---

## Assembly and Board Assignment

| Attribute | Detail |
| :--- | :--- |
| Assembly | `design/Mechanical/Keyboard_Assembly/Design_Spec.md` |
| Board interface | `design/Electronics/Encoder/Design_Spec.md` |
| Function | HID keyboard switch for the QWERTY-derived 40-position operator panel |
| System quantity | 40 switches total |

---

## Electrical Use

Only **Pole 1** is used electrically (`COM1 + NO1`). The second pole is retained for
mechanical anchoring only and does **not** carry a net assignment unless a future design
decision explicitly changes this.

---

## Integration Notes

| Attribute | Enigma-NG usage note |
| :--- | :--- |
| Contact style | Treat as a normally-open momentary key input on Pole 1 |
| Mounting | Keyboard-panel mounted with harness wiring back to Encoder spade inputs |
| Logic interface | Active-low key input to Encoder CPLD (`COM1 -> input`, `NO1 -> GND`) |
| Pole 2 | Do not assign an electrical net unless a future decision explicitly reuses it |
| Panel role | Custom keyboard key actuator, not a general-purpose front-panel pushbutton |
