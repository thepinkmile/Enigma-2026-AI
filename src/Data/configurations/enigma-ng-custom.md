# Enigma-NG Custom Configurations (Educational Stubs)

| Field | Value |
| ------- | ------- |
| Who | Enigma-NG Project (thepinkmile) |
| What | Custom Enigma configurations defined for the Enigma-NG educational hardware project; includes pre-programmed historical configurations and novel custom configurations for teaching modern cryptographic concepts |
| When | 2024–present (project inception to ongoing) |
| Where | Digital / Distributed (project hosted at GitHub: thepinkmile/Enigma-NG) |
| Related | [Enigma I Wehrmacht](enigma-i-Wehrmacht.md), [Enigma M4 Naval](enigma-m4-naval.md), [Enigma M3 Naval](enigma-m3-naval.md), [Enigma G Abwehr](enigma-g-abwehr.md) |

## Overview

The Enigma-NG project is a custom digital reconstruction of the Enigma machine built on a Raspberry Pi CM5 carrier board with a custom stator, up to 30 physical rotor boards, an extension/reflector
board, and a power module. The hardware supports any Enigma configuration in software, as well as novel custom configurations impossible on physical Enigma hardware (e.g., more than 4 rotor slots,
adjustable notch patterns, software-defined plugboard).

This file is a **stub placeholder** for all Enigma-NG custom configurations. Full configuration details will be added as the Enigma-NG hardware and software project progresses.

---

## Section 1: Pre-Programmed Historical Configurations

The following historical Enigma configurations will be built into the Enigma-NG application as selectable presets. Each maps directly to a documented historical variant.

| Config ID | Name | Historical Reference | Rotor Set |
| ----------- | ------ | --------------------- | ----------- |
| `HIST-01` | Wehrmacht Enigma I (Day 1 of Battle of Britain) | [Enigma I Wehrmacht](enigma-i-Wehrmacht.md) | I, II, III, UKW-B |
| `HIST-02` | Naval Enigma M3 (Standard, 1939) | [Enigma M3 Naval](enigma-m3-naval.md) | I–VIII, UKW-B |
| `HIST-03` | Naval Enigma M4 (Triton, Feb 1942) | [Enigma M4 Naval](enigma-m4-naval.md) | I–VIII + Beta/Gamma, UKW-b thin |
| `HIST-04` | Abwehr Enigma G (G312 / BP-captured) | [Enigma G Abwehr](enigma-g-abwehr.md) | I–III (G312 wiring), no plugboard |
| `HIST-05` | Enigma T Tirpitz (Japanese liaison) | [Enigma T Tirpitz](enigma-t-tirpitz.md) | I–VIII (T-wiring), unique ETW |
| `HIST-06` | Commercial Enigma K (Standard) | [Enigma K Commercial](enigma-k-commercial.md) | I–III (K wiring), no plugboard |
| `HIST-07` | Swiss-K Air Force | [Swiss-K Enigma](enigma-k-swiss.md) | I–III (Swiss AF wiring), no plugboard |
| `HIST-08` | Railway Enigma (Rocket I) | [Railway Enigma](enigma-k-railway.md) | I–III (Railway wiring), unique UKW |
| `HIST-09` | Enigma D Commercial (A320) | [Enigma D Commercial](enigma-d-commercial.md) | I–III (D wiring), settable UKW |
| `HIST-10` | Enigma Z Numbers (Z103) | [Enigma Z Numbers](enigma-z-numbers.md) | Numeric rotors I–III |

---

## Section 2: Enigma-NG Custom Educational Configurations

The following configurations are novel to the Enigma-NG project and do not correspond to any historical machine. They are designed to illustrate cryptographic concepts.

> **Note:** All custom configurations are clearly labelled as non-historical in the application UI.

| Config ID | Name | Description | Educational Focus |
| ----------- | ------ | ------------- | ------------------ |
| `ENGNG-01` | *Caesar Mode* | Enigma-NG reduced to Caesar-cipher equivalent (single rotor, no stepping) | Entry-level; shows simplest substitution |
| `ENGNG-02` | *Vigenère Mode* | Enigma-NG in stepped-substitution mode (rotor steps every character, no UKW) | Bridges Caesar → polyalphabetic cipher |
| `ENGNG-03` | *No Self-Encrypt* | Standard M4 wiring but with self-encryption prevention highlighted in UI | Demonstrates the reflector constraint as a vulnerability |
| `ENGNG-04` | *Maximum Depth* | 30-rotor chain (max hardware) + plugboard + UKW-D rewirable | Shows key-space limits; maximum security achievable |
| `ENGNG-05` | *Bombe Demo* | Fixed known-plaintext crib loaded; machine runs in demonstration mode showing Bombe elimination | Demonstrates the Bombe/crib attack |
| `ENGNG-06` | *Double-Step Demo* | 3-rotor standard Enigma I wiring; visual counter shows double-step anomaly when it occurs | Teaches the stepping anomaly |

---

## Planned Extensions

- User-defined custom wiring (full plugboard + rotor rewire in software)
- QR-code exportable key sheets
- Networked multi-machine link (two Enigma-NG units communicate over TCP/IP)
- Side-channel timing demonstration (intentionally degraded mode)

---

## Sources

- Enigma-NG hardware design specification: `design/Software/GUI_App/Design_Spec.md`
- Enigma-NG Controller Board: `design/Electronics/Controller_Board/Design_Spec.md`
