# Keyboard Assembly - Mechanical Design Specification

**Status:** Draft
**Project:** Enigma-NG
**Author:** Izzyonstage & GitHub Copilot
**Version:** v.0.1.0
**Associated Hardware Revision:** Rev A
**Last Updated:** 2026-04-20

---

## 1. Overview

A standalone operator keyboard assembly using the QWERTY-derived 40-position HID layout to access
the machine's 64-character code space. This assembly contains the keyboard panel, the key-switch
harness, and one Encoder Module populated/programmed in the **`KBD_ENC`** role.

The keyboard assembly is electrically independent of the lightboard assembly. It connects to the
Stator through its own 20-pin IDC ribbon on the dedicated `KBD_ENC` port.

---

## 2. Keyboard Switches

* **Keyboard Switches (x40):** DPDT 6-pin momentary push-button switches, one per physical HID key
  position.
  * Mounted in the keyboard panel (mechanical chassis); connect to the `KBD_ENC` Encoder Module via
    a field-installable spade-terminal harness.
  * **Pole 1 - COM1 + NO1** provides the active-low key path: COM1 -> assigned Encoder input
    terminal, NO1 -> local **GND** return. Pressing the key pulls the Encoder input LOW.
  * **Pole 2 pins (3x)** are unused electrically and may be retained only for mechanical anchoring;
    **no connection to the Encoder electrical netlist**.
  * **NC1** -> not connected.
  * Part: uxcell-style DPDT 2-pole 6-pin push button switch - purchased from seller
    `gadgetskingdom` (eBay item `365271584375`, 2 per pack). See
    `design/Datasheets/Gadgetskingdom_DPDT_Keyboard_Switch_Pseudo_Datasheet.md`.

---

## 3. Key Panel Layout

The keyboard assembly uses a **40-position physical layout** that preserves a conventional
QWERTY-inspired operator experience while still exposing the machine's full 64-character logical
alphabet.

* **Printable key positions (x38):** dedicated keycaps for `[a-z0-9+=]`.
* **Modifier key positions (x2):** one **Left Shift** key and one **Right Shift** key.
* **Bottom-row arrangement:** the two Shift keys flank the bottom row so either hand can access the
  uppercase alphabetic plane.
* **Uppercase behaviour:** there are **no separate uppercase-only key positions**. Holding either
  Shift key while pressing an alphabetic key yields the corresponding uppercase code (`A-Z`).

> For signal polarity, RC debounce circuit, Schmitt trigger configuration, and Shift key state
> machine logic, see `design/Electronics/Encoder/Design_Spec.md §6 Key Mapping`.

---

## 4. Mechanical Key Lever Interface

Each key has a mechanical lever extending downward from the key body to contact the depression bar
of the Rotor Actuation Assembly.

> See `design/Mechanical/Rotor_Actuation_Assembly/Design_Spec.md` for the depression bar and pivot
> lever mechanism that translates keypresses into rotor steps.

---

## 5. Cross-References

| Document | Description |
| :--- | :--- |
| `design/Electronics/Encoder/Design_Spec.md` | Generic Encoder Module pinout, CPLD role definition, key mapping |
| `design/Mechanical/Lightboard_Assembly/Design_Spec.md` | Separate but layout-matched lightboard assembly |
| `design/Mechanical/Rotor_Actuation_Assembly/Design_Spec.md` | Depression bar, pivot lever, and rotor stepping mechanism |
