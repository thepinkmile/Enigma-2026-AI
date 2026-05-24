# NEMA (Neue Maschine / TD-4)

| Field | Value |
| ------- | ------- |
| Who | Designed by Swiss Army cryptographic commission; manufactured by Zellweger AG, Uster, Switzerland |
| What | Swiss 10-rotor electromechanical cipher machine; direct successor to the Enigma K Swiss Army variant; developed after Switzerland learned post-war that all Enigma traffic had been read by Allied powers; used by the Swiss Army from 1947 to 1992 |
| When | Designed 1944–1947; operational 1947–1992 |
| Where | Designed and manufactured: Uster, Canton Zurich, Switzerland (47.3484°N, 8.7198°E); deployed with Swiss Army nationwide |
| Related | [Enigma K Swiss](enigma-k-swiss.md), [Enigma KD](enigma-kd.md), [Enigma I Wehrmacht](enigma-i-Wehrmacht.md) |

## Overview

The NEMA (*Neue Maschine* — "new machine"; Swiss military designation **TD-4**) was the Swiss Army's response to a post-war revelation that fundamentally undermined Swiss communications security: the
Enigma K machines used throughout WWII had been broken by Allied cryptanalysts, meaning Swiss Army and Air Force traffic had been readable by Britain (and potentially others) for the duration of the
war.

Rather than adopting a foreign machine, Switzerland designed its own — retaining the Enigma's familiar form factor and operating concept but addressing all known cryptanalytic weaknesses. The NEMA
was **never broken** during its 45-year operational life.

Approximately **640 NEMA machines** were manufactured, all by Zellweger AG in Uster. The machine was **declassified in 1992** when Switzerland retired it from service.

## Design History and Motivation

Switzerland had used **Enigma K** machines (commercial Enigma, 265 units) throughout WWII for both Army and Air Force communications. Swiss neutrality meant these communications were not a direct
wartime concern, but the revelation that both British intelligence and American SIGINT had been reading them was a significant diplomatic and military embarrassment.

In 1944, while the war was still ongoing, the Swiss Army began a secret programme to design a replacement machine that would address the known weaknesses of Enigma. The design was completed by 1947.

## Technical Specification

### Rotor Configuration — 10 Rotors Total

NEMA used **10 rotors** in a single stack — significantly more than Enigma's 3 or 4:

| Position | Function | Count |
| ---------- | ---------- | ------- |
| Input rotor (ETW) | Fixed entry scrambler | 1 |
| Cipher rotors | Active substitution rotors | 5 |
| Stepping rotors (Triebräder) | Control the advance of cipher rotors | 4 |
| Reflector (UKW) | Fixed reversing drum | 1 (integral) |

**Total active stepping elements: 5 cipher rotors + 4 stepping rotors = 9 variable elements** (plus fixed input and reflector)

### Cipher Rotors

- **5 cipher rotors** (designated I–X, with rotors selected from a larger library)
- Each rotor has **26 contacts** on each face
- Each rotor has **a single notch** — but the notch position is on the **stepping rotor** that drives it, not on the cipher rotor itself (unlike Enigma where the notch is on the cipher rotor)

### Stepping Rotors (Triebräder)

This is NEMA's key security innovation. Rather than having the cipher rotors advance each other (Enigma's odometer/double-stepping mechanism), NEMA used **4 dedicated stepping rotors**:

- The stepping rotors had **irregular notch patterns** (multiple notches per rotor, in non-uniform positions)
- Each stepping rotor independently controlled whether its corresponding cipher rotor advanced on a given keypress
- The result was that cipher rotor motion was **quasi-random and unpredictable**, with no regular period exploitable by Kasiski-type or Bombe-type attacks

### Reflector

- NEMA retained a **fixed reflector** (self-reciprocal property preserved)
- The reflector was integral to the machine's right end-plate rather than a removable rotor

### Physical Form Factor

- Similar size and layout to Enigma — a portable desktop unit
- **Keyboard input, lampboard output** (like Enigma — operators read off lamp letters)
- Supplied in a wooden carrying case

## Rotor Wiring (Declassified 1992)

The NEMA rotor wirings were declassified in 1992 and are now fully published. Cipher Museum and researchers have verified the complete wiring tables.

### Known Rotor Wirings

| Rotor | Wiring (A→Z) |
| ------- | ------------- |
| I | QSLRBTEKOGAIVNMCWFDPZHJYUX |
| II | QDJCFSOAIRGMUKBZWPTHYLVEXN |
| III | QNFBDKOPCGZELRIAHSXWYUTVMJ |
| IV | QJFLMXKZODCVHPBEARGWSITNU Y |
| V | QOZYDPXMLRGIKCUWVFJETBNAHS |
| VI | QHIMDRWFETOYJNVKUASPLCGBZX |
| VII | QGWXROHSBATPEVIDUMNCYLFJKZ |
| VIII | QFKLZMSNEIBHATRJXGDCUYWVOP |
| IX | QEUBIVSMCRXPDYJNOTFLHAWZGK |
| X | QAPBNUQCDGTFHYSMVELRKXWIZJ |

> (Note: all rotors begin with Q at position A — a fixed-point in NEMA design that differs from Enigma)

### Stepping Rotor Notch Positions

| Stepping Rotor | Notch positions (of 26) |
| ---------------- | ------------------------ |
| A | Multiple non-uniform positions |
| B | Multiple non-uniform positions |
| C | Multiple non-uniform positions |
| D | Multiple non-uniform positions |

Full notch tables are published by the Crypto Museum.

## Security Comparison: NEMA vs. Enigma K Swiss

| Feature | Enigma K Swiss | NEMA |
| --------- | --------------- | ------ |
| Cipher rotors | 3 | 5 |
| Stepping mechanism | Odometer (regular) | Dedicated stepping rotors (irregular) |
| Notches per rotor | 1 (regular period) | Multiple (no regular period) |
| Double-stepping anomaly | Present | Eliminated |
| Reflector | Fixed removable | Fixed integral |
| Broken in WWII? | **Yes** (by Allied SIGINT) | N/A (not in service) |
| Broken in service? | N/A | **No** |

## Operational Life

- **1947**: NEMA enters service with Swiss Army and Air Force
- **1952**: Full deployment to all Swiss Army cipher units; replaces Enigma K
- **1974**: Ultra declassification reveals Enigma had been broken — NEMA users learn their predecessor had been compromised throughout WWII; NEMA itself remains secure
- **1992**: NEMA retired and **declassified**; rotor wirings and operating manuals published
- **Present**: Surviving machines held by Swiss Military Museum, Crypto Museum (Eindhoven), and private collectors; fully operable software emulators available

## Survivors

Known surviving machines:

- **Swiss Military Museum** (Morges, Canton Vaud, Switzerland)
- **Crypto Museum** (Eindhoven, Netherlands) — operates a fully functional example
- Several private collections worldwide

## Sources

- Crypto Museum: <https://www.cryptomuseum.com/crypto/nema/index.htm>
- Wikipedia: <https://en.wikipedia.org/wiki/NEMA_(cipher_machine)>
- Reuvers, Paul & Simons, Marc. *NEMA Technical Documentation* (Crypto Museum, 2012)
