# Enigma-NG Software Design: C# GUI Application

**Status:** Draft
**Version:** v.0.1.0
**Associated Hardware Revision:** Rev A
**Last Updated:** 2026-04-05

## 1. Core Framework

* **Version:** .NET 10.0 (C#)
* **UI Library:** Avalonia UI (for hardware-accelerated Skia rendering on Linux/CM5).
* **Architecture:** MVVM (Model-View-ViewModel) for clean separation between hardware I/O and the display.

## 2. Aesthetic (The "Digital Museum" Look)

* **Font:** Authentic "Typewriter" monospaced font for all data readouts.
* **Colour Palette:** "Enigma Green" (#004D40), Slate Grey, and Amber highlights.
* **Bilingual Toggle:** A one-click switch to toggle all UI text between **DEUTSCH** and **ENGLISH**.

## 3. Primary Dashboard Features

* **The Virtual Enigma:** A 3D or high-res 2D representation of the 30-rotor stack.
* **Live Power Telemetry:** Real-time Gauges for Voltage, Current (mA), and Power (W) sourced from the INA219.
  * **Rotor stack monitor:** INA219 at I²C address **0x45** (on Stator board), `R_SHUNT = 0.010Ω` (10mΩ CSS2H-2512R-R010ELF), calibration register `CAL = 0x0400`;
    current formula: `I = V_shunt / 0.010`, range 0-3A, typical 1-2.05A; Current_LSB = 4mA.
  * **Power Module monitor:** INA219 at I²C address **0x40** (on Power Module board), monitors 5V_MAIN rail.
  * See `Software/Linux_OS/Power_Management.md §INA219` for full driver code and register setup.
* **Source Indicators:** Dynamic icons for PoE+, USB-C, and Battery (with "Time-to-Empty" countdown).
* **Thermal Monitor:** CPU and eFuse temperature tracking with bilingual "HOT" alerts.
* **The "Daily Key":** Ability to export/import the machine configuration (Rotor order, Ring settings, Plugboard patches) as a "Codebook" PDF or JSON file.

## 4. Cryptographic Visualization

* **Signal Path Trace:** A "light-trail" animation showing the 12-bit signal traveling from the Keyboard, through the Plugboard, through the 30 rotors, hitting the Reflector, and returning to the

  Lampboard.
* **Rotor Configurator:** Drag-and-drop interface to "program" historical wiring (I-VIII) into the CPLDs/FPGAs.

---

## 5. GUI Implementation Checklist

* [x] Setup Avalonia .NET 10.0 Project Template.
* [ ] Implement I2C Wrapper for INA219 (Telemetry) - address 0x45 (rotor stack), 0x40 (power module); R_SHUNT=0.010Ω (CSS2H 10mΩ); CAL=0x0400; see Power_Management.md for driver code.
* [ ] Create the "Enigma Path" SVG animation logic.
* [ ] Integrate JTAG programming library for Intel MAX II EPM570T100I5N CPLDs across Encoder (x6), Rotor (x30), and Stator (x1).
* [ ] Design the Bilingual "Typewriter" UI Theme.
* [ ] Finalize the "Time-to-Empty" Battery algorithm.
