# Rotor Board - 64-Character Variant Design Specification

**Status:** In Review
**Project:** Enigma-NG
**Version:** v.0.1.0
**Associated Hardware Revision:** Rev A
**Last Updated:** 2026-04-XX
**Parent Document:** `design/Electronics/Rotor/Design_Spec.md`
**Mechanical Spec:** `design/Mechanical/Rotor/Design_Spec.md §5.1` - encoder slot machining
tolerances and shroud geometry

---

## 1. Overview

This document specifies the 64-character (6-bit) variant of the Enigma-NG Smart Digital Rotor.
This variant supports the extended Enigma-NG character set (64 characters) and is the primary
variant for the Enigma-NG system. It is not compatible with original Enigma machines (which use
26-character rotors) but can coexist with 26-character variant rotors in a mixed stack.

Both 26-character and 64-character rotor variants share identical PCB footprints, connector
pinouts, and DIP switch mechanisms. A mixed stack is fully supported at the hardware level.

---

## 2. Character Set and Data Bus

* **Character count:** 64
* **Data bus width:** 6 bits (ENC[5:0]); all 6 bits are active on this variant
* **Encoding:** Binary, 0-63 mapping to the Enigma-NG extended character set (to be defined in
  the VHDL / software design specification; see OWI-003)
* **Connector bus:** ERM8-010 / ERF8-010 (6-bit footprint); all 12 signal pins on J3/J6 active.

---

## 3. UFM Map Storage and SW2/SW3 Selection

The CPLD UFM stores 21 forward-direction cipher maps in the common 64-entry x 6-bit format.
Each map defines a valid permutation of {0..63}.

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

## 4. Wiring Maps

The 64-character Enigma-NG wiring tables are not derived from historical sources and will be
defined in the VHDL design specification (see OWI-003). Each map must satisfy:

1. Complete bijection (permutation) of {0..63} - no character maps to itself (derangement).
2. Forward and inverse are mathematically linked; the inverse is obtained via the SW direction
   bit - no separate inverse map needs to be stored.
3. Notch trigger position(s) for each map must be defined in the VHDL tables.

Up to 21 distinct forward maps can be stored, each usable in both forward and reverse direction.

> To use a map as a standard forward/return pair: set SW2 to index N, direction 0 (forward);
> set SW3 to index N, direction 1 (reverse). Non-matching index or direction combinations are
> valid and produce a more complex compound cipher.

---

## 5. Ring Setting (SW1)

See `Design_Spec.md §2.3` for the SW1 hardware description.
For the 64-character variant:

* The CPLD reads 6 Gray code bits (G[5:3] from FDC2114 U2 on Board A, G[2:0] from FDC2114 U11B
  on Board B) and decodes them to binary position 0-63 via the XOR chain (see §7). All 64
  6-bit Gray codes are valid; no between-character jam detection is required for this variant.
* SW1[5:0] is summed **modulo 64** with the decoded binary position to yield the effective position.
* Notch trigger positions are defined per map in the VHDL tables (see OWI-003).

---

## 6. Prototype Build Note

Both 26-character and 64-character rotor sets will be built for the prototype. Wiring maps will
be defined per OWI-003 and loaded into each 64-character rotor's UFM at first JTAG programming.
SW2 and SW3 are then used to select map index and direction independently at runtime.

---

## 7. Dual-Track Capacitive Encoder - 64-Character Variant

### Architecture

The 64-character rotor uses a **dual-track 3+3 bit standard reflected Gray code** implemented
across the two PCBs of the split rotor assembly. Track A (bits[5:3]) is sensed by Board A;
Track B (bits[2:0]) is sensed by Board B. Together they form a complete 6-bit Gray code for
N=64 positions with **zero multi-bit transitions**, including the wrap-around from position 63
back to position 0.

* **Track A** (bits[5:3]): 3 sensor electrodes on Board A at r≈44mm; Gray code slots milled
  into the inner face of the shroud **dish** flange (Board A side).
* **Track B** (bits[2:0]): 3 sensor electrodes on Board B at r≈44mm; Gray code slots milled
  into the inner face of the shroud **cover** flange (Board B side).
* **Sensing:** Bare copper electrode pads on the PCB flat face (no electronic components on
  the shroud). Aluminium (solid) = high capacitance; milled slot = low capacitance. Sensed by
  FDC2114RGHR (U2 on Board A, U11B on Board B).
* **Shroud:** Must remain electrically **floating** (bearing isolation - ceramic or nylon
  rolling elements). Not connected to circuit ground.

### Geometry

| Parameter | Value |
| :--- | :--- |
| Segments (N) | 64 |
| Sensor count (K) | 6 (3 on Board A + 3 on Board B) |
| Degrees per segment | 5.625° |
| Arc length per segment at r = 44 mm | ≈ 4.32 mm |
| Sensor electrode radius | ≈ 44 mm from board centre |
| PCB outer diameter | 92 mm |
| Shroud outer face arc per character at r = 50 mm | ≈ 4.91 mm |

### Track Bit Patterns

The following patterns define which segments of each track have a milled slot (1 = slot, 0 = solid).
These are the bits of the 6-bit standard reflected (binary) Gray code for positions 0-63.

**Track A - Board A side (shroud dish inner face):**

```text
Bit 5: 0000000000000000000000000000000011111111111111111111111111111111
Bit 4: 0000000000000000111111111111111111111111111111110000000000000000
Bit 3: 0000000011111111111111110000000000000000111111111111111100000000
```

**Track B - Board B side (shroud cover inner face):**

```text
Bit 2: 0000111111110000000011111111000000001111111100000000111111110000
Bit 1: 0011110000111100001111000011110000111100001111000011110000111100
Bit 0: 0110011001100110011001100110011001100110011001100110011001100110
```

Each row has 64 positions (left = position 0, right = position 63). A '1' indicates a milled
slot at that segment for that bit track (low capacitance → logic 0 from FDC2114); a '0'
indicates solid aluminium (high capacitance → logic 1). The CPLD inverts the FDC2114 output
sense accordingly.

**Verification:** This is the standard reflected binary Gray code. Every adjacent pair of
positions (including 63→0 wrap) differs in exactly **1 bit** - no multi-bit transitions occur
at any rotor position. All 64 codes are unique. No invalid-code jam detection is required.

### CPLD Decode - XOR Chain (Gray to Binary)

The CPLD decodes the 6 raw Gray code bits G[5:0] (from FDC2114 U2 bits[5:3] and U11B bits[2:0])
to 6-bit binary position B[5:0] using the standard XOR chain:

```text
B5 = G5
B4 = B5 XOR G4
B3 = B4 XOR G3
B2 = B3 XOR G2
B1 = B2 XOR G1
B0 = B1 XOR G0
```

Where G[5:0] = raw Gray code bits from FDC2114 sensors, B[5:0] = 6-bit binary position 0-63.

No lookup table is required. The XOR chain is fully combinational and synthesises to 5 XOR
gates in the CPLD. SW1[5:0] is summed modulo 64 with B[5:0] to yield the effective position.

---

## 8. Bill of Materials (N=64 Variant-Specific Components)

Variant-specific components for the N=64 rotor. Common components shared across all Rotor variants
are listed in **`design/Electronics/Rotor/Design_Spec.md`** §5.

| RefDes | Specification | MPN | Manufacturer | DigiKey PN | Mouser PN | JLCPCB PN | Alt Supplier + PN | Notes | Footprint Available | Footprint Downloaded | Qty |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| C20B | 100nF X7R 50V 0402 | CL05B104KB5NNNC | Samsung | 1276-CL05B104KB5NNNCCT-ND | 187-CL05B104KB5NNNC | C960916 | - | FDC2114 VDD bypass cap | Yes | Pending | 1 |
| C21B | 1µF X7R ±10% 10V AEC-Q200 0402 | KAM05CR71A105KH | Kyocera AVX | 478-KAM05CR71A105KHCT-ND | 581-KAM05CR71A105KH | - | Global sourcing | FDC2114 VDD bulk decoupling cap | Yes | Pending | 1 |
| C22B-C25B | 33pF C0G/NP0 ±1% 50V AEC-Q200 0402 | AC0402FRNPO9BN330 | YAGEO | 13-AC0402FRNPO9BN330CT-ND | 603-0402FRNPO9BN330 | C1852937 | - | - | Yes | Pending | 4 |
| L5B-L8B | 18µH ±10% SRF 28MHz 0603 | CWF1610A-180K | Bourns | 118-CWF1610A-180KCT-ND | 652-CWF1610A-180K | - | Global sourcing | - | Yes | Pending | 4 |
| U11B | 4-ch cap sensor I²C 0x2B 16-VQFN | FDC2114RGHR | Texas Instruments | FDC2114RGHR-ND | 595-FDC2114RGHR | C2652079 | - | JLCPCB MOQ 2 | Yes | Pending | 1 |
