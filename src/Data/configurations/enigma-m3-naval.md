# Enigma M3 (Naval 3-Rotor)

| Field | Value |
| ------- | ------- |
| Who | Heimsoeth und Rinke (H&R) designer; Konski und Krüger (K&K) manufacturer |
| What | German Kriegsmarine 3-rotor Enigma; standard for surface ships and shore stations; succeeded by M4 for U-boats in 1942 |
| When | Introduced 1940; M1 from 1934, M2 from 1938; used throughout WWII |
| Where | Manufactured in Berlin-Tempelhof, Germany (52.4700°N, 13.3900°E) |
| Related | [Alan Turing](../profiles/alan-turing.md), [Enigma M4 Naval](enigma-m4-naval.md), [Enigma I Wehrmacht](enigma-i-Wehrmacht.md) |

## Overview

The Enigma M-series were the Kriegsmarine (German Navy) variants of the Enigma machine. Starting with Enigma M1 (1934), the series evolved through M2 (1938) and M3 (1940), each adding incremental
improvements. The M3 was the primary Naval Enigma broken by Bletchley Park's Hut 8 under Alan Turing during the Battle of the Atlantic. It shared rotors I–V with the Army Enigma I but added
Naval-exclusive rotors VI, VII, and VIII.

## Technical Specifications

| Parameter | Value |
| ----------- | ------- |
| M1 designation | Ch.11g; 1934; 611 units (serials M501–M1111) |
| M2 designation | Ch.11g; 1938; 890 units (serials M1112–M2001); hinged lamp panel |
| M3 designation | Ch.11g; 1940; ~800 units (serials M2002–M2801) |
| BP codenames | DOLPHIN (main surface/shore network); HEIMISCH |
| Rotors | 3 from set of 8: I–V (shared with Enigma I) + VI, VII, VIII (Naval-exclusive, 2 notches each) |
| Reflector | UKW-B (standard) or UKW-C; Naval UKW-D from Jan 1944 |
| Plugboard | Yes — Steckerbrett; plugs with longer pins than Army model |
| ETW | ABCDEFGHIJKLMNOPQRSTUVWXYZ |
| Alphabet on ring | Letters A–Z (not numbers 01–26 as on Enigma I) |
| Power | Dual 4V + 220V sockets |
| Compatible with | Enigma I (fully); Enigma M4 (when 4th rotor set to 'A') |

## Naval Rotor Wiring

```text
VI:   JPGVOUMFYQBENHZRDKASXLICTW  Notches: H+U (2 notches)  Turnover: Z+M
VII:  NZJHGRCXMYSWBOUFAIVLPEKQDT  Notches: H+U (2 notches)  Turnover: Z+M
VIII: FKQHTLXOCBJSPDZRAMEWNIUYGV  Notches: H+U (2 notches)  Turnover: Z+M
```

## Operational Rules

- At least one Naval rotor (VI, VII, or VIII) must be in the machine each day
- That rotor cannot be placed in the same position on successive days

## Notable Events

- **9 May 1941**: HMS Bulldog captured **U-110** with complete Enigma M3 machine and codebooks for June 1941 — critical intelligence enabling BP to read naval traffic for weeks
- **28 June 1941**: Weather ship **Lauenburg** captured; provided July 1941 settings
- **Banburismus procedure**: Turing's statistical method for eliminating rotor starting positions — used for Naval Enigma before enough Bombes were available

## Surviving Examples

- **M897**: Bletchley Park Museum (Milton Keynes, UK) — on display in Enigma Gallery
- **M522**: Recovered from Danish waters by fisherman in 1992; locks still locked

## Sources

- Crypto Museum: <https://cryptomuseum.com/crypto/enigma/m3/index.htm>
- Wikipedia: Enigma machine
- Wikipedia: Battle of the Atlantic
