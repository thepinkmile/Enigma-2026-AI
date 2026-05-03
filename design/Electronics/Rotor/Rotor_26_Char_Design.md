# Rotor Board - 26-Character Variant Design Specification

**Status:** Draft
**Project:** Enigma-NG
**Version:** v.0.1.0
**Associated Hardware Revision:** Rev A
**Last Updated:** 2026-04-XX
**Parent Document:** `design/Electronics/Rotor/Design_Spec.md`
**Mechanical Spec:** `design/Mechanical/Rotor/Design_Spec.md §5.2` - encoder slot machining
tolerances and shroud geometry

---

## 1. Overview

This document specifies the 26-character (5-bit) variant of the Enigma-NG Smart Digital Rotor.
This variant emulates original Enigma machine rotor wiring for a 26-character alphabet (A-Z),
and is compatible with historical rotor types I-VIII, Beta, and Gamma.

Both 26-character and 64-character rotor variants share identical PCB footprints, connector
pinouts, and DIP switch mechanisms. A mixed stack is fully supported.

---

## 2. Character Set and Data Bus

* **Character count:** 26 (A-Z)
* **Data bus width:** 5 bits (ENC[0:4]); ENC[5] is NC on this variant
* **Encoding:** Binary, 0 = 'A', 1 = 'B', ..., 25 = 'Z'
* **Connector bus:** ERM8-010 / ERF8-010 (6-bit footprint for cross-variant compatibility);
  ENC[5] pins are NC on all 26-character rotor boards.

---

## 3. UFM Map Storage and SW2/SW3 Selection

The CPLD UFM stores 21 forward-direction cipher maps in the common 64-entry x 6-bit format.
For the 26-character variant, each map defines a valid permutation of {0..25} in entries 0-25;
entries 26-63 are unused by this variant.

The direction bit on SW2/SW3 allows any stored map to be applied in reverse (inverse lookup),
giving 42 effective cipher configurations per side without additional UFM storage.

### UFM Capacity

| Parameter | Value |
| :--- | :--- |
| EPM570T100I5N UFM capacity | 8,192 bits |
| Map format (common to both variants) | 64 entries x 6 bits = 384 bits per map |
| Maps stored | floor(8,192 / 384) = **21 forward maps** |
| Effective configurations per side (with direction bit) | 21 x 2 = **42** |

### SW2 / SW3 Bit Encoding

| Bits | Function | Values |
| :--- | :--- | :--- |
| [4:0] | Map index | 0-20 valid; 21-31 reserved |
| [5] | Direction | 0 = forward; 1 = reverse (inverse lookup) |

SW2 and SW3 are read at power-up only; a power cycle is required after changing either switch.

---

## 4. Historical Rotor Wiring Tables

The following historical Enigma rotor wiring maps are pre-programmed into all 26-character
variant rotors at first JTAG programming. Each rotor type occupies one UFM map index (forward
wiring only; the inverse is obtained via the direction bit).

| Map Index | Rotor Name | Notes |
| :--- | :--- | :--- |
| 0 | Rotor I | Wehrmacht / Luftwaffe |
| 1 | Rotor II | Wehrmacht / Luftwaffe |
| 2 | Rotor III | Wehrmacht / Luftwaffe |
| 3 | Rotor IV | Wehrmacht |
| 4 | Rotor V | Wehrmacht |
| 5 | Rotor VI | Kriegsmarine |
| 6 | Rotor VII | Kriegsmarine |
| 7 | Rotor VIII | Kriegsmarine |
| 8 | Beta | Kriegsmarine 4-rotor (never rotates) |
| 9 | Gamma | Kriegsmarine 4-rotor (never rotates) |
| 10-20 | Custom / Reserved | Available for Enigma-NG extended use |

> To emulate e.g. Rotor I: set SW2 to index 0, direction 0 (forward) for the forward pass;
> set SW3 to index 0, direction 1 (reverse) for the return pass.
>
> The actual wiring permutation data for each historical rotor is defined in the VHDL
> design files (see OWI-003).

---

## 5. Ring Setting (SW1)

See `Design_Spec.md §2.3` for the SW1 hardware description.
For the 26-character variant:

* The CPLD reads 5 sensor pads (S0-S4, all on Board A) as a 5-bit STGC code and maps it via a
  combinational lookup table to a binary position 0-25. Codes not present in the lookup table
  (11, 13, 21, 22, 26, 31) indicate a between-character position and are flagged as a mechanical
  fault condition. FDC2114 U3B on Board B is **not populated** for the N=26 rotor.
* SW1[5:0] is summed **modulo 26** with the decoded binary position to yield the effective position.
* Notch trigger positions are defined per map in the VHDL tables (see OWI-003).

---

## 6. Prototype Build Note

Both 26-character and 64-character rotor sets will be built for the prototype. All 10 historical
rotor maps (indices 0-9) will be programmed into each 26-character rotor at first JTAG
programming. SW2 and SW3 are then used to select rotor type and direction independently at
runtime.

---

## 7. Single-Track Capacitive Encoder - 26-Character Variant

### Architecture

The 26-character rotor uses a **single-track 5-bit STGC** encoder. All 5 sensor electrodes
are on **Board A only**. Board B has no encoder electrodes for the N=26 rotor, and FDC2114
**U3B on Board B is not populated** for this variant.

* **Track** (5 bits, STGC): 5 sensor electrodes on Board A at r≈44mm; pattern milled into the
  inner face of the shroud **dish** flange (Board A side).
* **Board B shroud flange:** No encoder slots milled for N=26.
* **Sensing:** Bare copper electrode pads on the Board A flat face (no electronic components
  on the shroud). Aluminium (solid) = high capacitance; milled slot = low capacitance. Sensed
  by FDC2114RGHR U2 and U3A on Board A:
  * **U2 (Board A, addr 0x2A):** CH0-CH3 = STGC bits[3:0]
  * **U3A (Board A, addr 0x2B):** CH0 = STGC bit[4]; CH1-CH3 each carry a dummy LC tank (18 µH + 33 pF in parallel between INxA/INxB per TI app note unused-channel rule; BOM refs L5A-L8A, C22A-C25A)
  * U3A is an additional FDC2114RGHR populated on Board A for N=26 builds only.
* **Shroud:** Must remain electrically **floating** (bearing isolation - ceramic or nylon
  rolling elements). Not connected to circuit ground.

### Geometry

| Parameter | Value |
| :--- | :--- |
| Segments (N) | 26 |
| Sensor count (K) | 5 (all on Board A) |
| Degrees per segment | 13.846° |
| Arc length per segment at r = 44 mm | ≈ 10.63 mm |
| Sensor angular positions (from S0) | 0°, 13.846°, 27.692°, 41.538°, 55.385° |
| PCB outer diameter | 92 mm |
| Sensor electrode radius | ≈ 44 mm from board centre |
| Shroud outer face arc per character at r = 50 mm | ≈ 12.08 mm |

### Track Bit Pattern

The shroud **dish** inner face (Board A side) carries a 26-segment milled slot track. Starting
from the reference segment (position 0), the segment pattern is (1 = milled slot, 0 = solid aluminium):

```text
00000100011001010011101111
```

Position 0 is the reference (all 5 sensors read 0). The pattern is applied clockwise as viewed
from the input face of the rotor.

### STGC → Position Lookup Table

The CPLD VHDL implements a 32-entry lookup ROM (5-bit address → 5-bit position). Standard
Gray code is not achievable for N=26 (not a power of 2); therefore a lookup table decode is
retained. Codes not listed below are invalid and trigger a mechanical fault flag.

> **Note:** For the N=26 variant, U3B (FDC2114 on Board B) is not populated. U2 (Board A,
> addr 0x2A) reads STGC bits[3:0] via CH0-CH3. U3A (Board A, addr 0x2B) reads STGC bit[4]
> via CH0; CH1-CH3 are tied to GND via 100 kΩ. U3A is an additional FDC2114RGHR populated
> on Board A for N=26 builds only.

| STGC Code | Binary | Position | | STGC Code | Binary | Position |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| 0 | 00000 | 0 | | 17 | 10001 | 5 |
| 16 | 10000 | 1 | | 18 | 10010 | 14 |
| 8 | 01000 | 2 | | 25 | 11001 | 15 |
| 4 | 00100 | 3 | | 28 | 11100 | 16 |
| 2 | 00010 | 4 | | 14 | 01110 | 17 |
| 24 | 11000 | 6 | | 23 | 10111 | 18 |
| 12 | 01100 | 7 | | 27 | 11011 | 19 |
| 6 | 00110 | 8 | | 29 | 11101 | 20 |
| 19 | 10011 | 9 | | 30 | 11110 | 21 |
| 9 | 01001 | 10 | | 15 | 01111 | 22 |
| 20 | 10100 | 11 | | 7 | 00111 | 23 |
| 10 | 01010 | 12 | | 3 | 00011 | 24 |
| 5 | 00101 | 13 | | 1 | 00001 | 25 |

**Invalid codes** (mechanical fault / between-character): 11, 13, 21, 22, 26, 31.

---

## 8. Bill of Materials (N=26 Variant-Specific Components)

Variant-specific components for the N=26 rotor. Common components shared across all Rotor variants
are listed in **`design/Electronics/Rotor/Design_Spec.md`** §5.

| RefDes | Specification | MPN | Manufacturer | DigiKey PN | Mouser PN | JLCPCB PN | Alt Supplier + PN | Notes | Footprint Available | Footprint Downloaded | Qty |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| C16A | 100nF X7R 50V 0402 | CL05B104KB5NNNC | Samsung | 1276-CL05B104KB5NNNCCT-ND | 187-CL05B104KB5NNNC | C960916 | - | - | Yes | Pending | 1 |
| C17A | 1µF X7R ±10% 10V AEC-Q200 0402 | KAM05CR71A105KH | Kyocera AVX | 478-KAM05CR71A105KHCT-ND | 581-KAM05CR71A105KH | - | Global sourcing | - | Yes | Pending | 1 |
| C22A-C25A | 33pF C0G/NP0 ±1% 50V AEC-Q200 0402 | AC0402FRNPO9BN330 | YAGEO | 13-AC0402FRNPO9BN330CT-ND | 603-0402FRNPO9BN330 | C1852937 | - | - | Yes | Pending | 4 |
| L5A-L8A | 18µH ±10% SRF 28MHz 0603 | CWF1610A-180K | Bourns | 118-CWF1610A-180KCT-ND | 652-CWF1610A-180K | - | Global sourcing | - | Yes | Pending | 4 |
| U3A | 4-ch cap sensor I²C 0x2B 16-VQFN | FDC2114RGHR | Texas Instruments | FDC2114RGHR-ND | 595-FDC2114RGHR | C2652079 | - | JLCPCB MOQ 2 | Yes | Pending | 1 |
