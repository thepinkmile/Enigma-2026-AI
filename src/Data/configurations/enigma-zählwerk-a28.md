# Zählwerk Enigma A28 (Ch.15)

| Field | Value |
| ------- | ------- |
| Who | ChiMaAG (Chiffriermaschinen AG), Berlin |
| What | First Zählwerk (cogwheel-driven) Enigma; unique driven UKW; used by Royal Dutch Navy and German Abwehr; ancestor of the Enigma G/G31 |
| When | Prototypes from 1927; introduced 1928 |
| Where | Manufactured in Berlin, Germany (52.5200°N, 13.4050°E) |
| Related | [Enigma G Abwehr](enigma-g-abwehr.md), [Arthur Scherbius](../profiles/arthur-scherbius.md) |

## Overview

The Zählwerk Enigma A28 was the first Enigma to use a **cogwheel (Zählwerk) stepping mechanism** instead of the standard ratchet. This produced a more complex, irregular stepping pattern with no
double-stepping anomaly, and featured a **driven UKW** — a reflector that actually moves during encipherment (unique in Enigma). It was the direct predecessor to the Abwehr Enigma G (G31).

## Technical Specifications

| Parameter | Value |
| ----------- | ------- |
| Official designation | Zählwerk Enigma A28; internal: Ch.15 |
| Year introduced | 1928 |
| Rotors | 3 cipher rotors with cogwheel stepping mechanism (52-tooth cogwheel; not ratchet) |
| Notch counts | I: 17 notches; II: 15 notches; III: 11 notches |
| Reflector | Driven UKW — moves during encipherment (unique to A28 and G31) |
| Plugboard | None |
| ETW | QWERTZUIOASDFGHJKPYXCVBNML |
| Stepping | Irregular cogwheel-driven; no double-stepping anomaly |
| Counter | 4-digit mechanical counter |
| Crank | Yes (for corrections) |
| Units produced | ~50 estimated (single batch) |
| Users | Royal Dutch Navy (batch of 6 including A865); Hungarian Army; German Abwehr |

## Wiring (as found on A865, Royal Dutch Navy)

```text
ETW: QWERTZUIOASDFGHJKPYXCVBNML

I:   LPGSZMHAEOQKVXRFYBUTNICJDW  Notches: 17  Turnovers: S,U,V,W,Z,A,B,C,E,F,G,I,K,L,O,P,Q
II:  SLVGBTFXJQOHEWIRZYAMKPCNDU  Notches: 15  Turnovers: S,T,V,Y,Z,A,C,D,F,G,H,K,M,N,Q
III: CJGDPSHKTURAWZXFMYNQOBVLIE  Notches: 11  Turnovers: U,W,X,A,E,F,H,K,M,N,R

UKW: IMETCGFRAYSQBZXWLHKDVUPOJN
```

## Surviving Examples

- **A865** — Crypto Museum, Netherlands (ex-Royal Dutch Navy; one of only 3 known surviving examples worldwide)

## Sources

- Crypto Museum: <https://cryptomuseum.com/crypto/enigma/g/a28.htm>
- Frode Weierud (forthcoming publication)
