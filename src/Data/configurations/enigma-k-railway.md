# Railway Enigma (Reichsbahn)

| Field | Value |
| ------- | ------- |
| Who | H&R designer; Konski und Krüger manufacturer; German Reichsbahn (state railway) operator |
| What | Modified Enigma K with unique rotor wiring used by German state railway on Eastern European, Russian, and Balkan networks; Bletchley codename "Rocket I" |
| When | First intercepted 25 July 1940; used until at least 28 October 1944 |
| Where | Manufactured in Berlin-Tempelhof, Germany (52.4700°N, 13.3900°E); used across Eastern Europe |
| Related | [Enigma K Commercial](enigma-k-commercial.md), [Enigma D Commercial](enigma-d-commercial.md) |

## Overview

The Railway Enigma was a modified Enigma K issued to the German Reichsbahn (state railway) for encrypting railway operational traffic across Eastern Europe, Russia, and the Balkans. It used uniquely
rewired rotors and reflector. Bletchley Park gave it the codename "Rocket" and first broke it on 25 July 1940 when Colonel Tiltman solved initial traffic. Only approximately 10 machines were produced
(serials K432–K441, also K456).

## Technical Specifications

| Parameter | Value |
| ----------- | ------- |
| Base model | Enigma K (A27/Ch.11b) |
| BP codename | Rocket / Rocket I |
| Year in use | 1940–1944 |
| Rotors | 3 (standard Enigma K form factor) but uniquely rewired |
| ETW | QWERTZUIOASDFGHJKPYXCVBNML (standard commercial) |
| Units produced | ~10 (serials K432–K441; also K456) |
| Networks | Rocket I (Eastern Europe/Russia/Balkans); Rocket II (West Europe, Sep 1942); Rocket III |

## Rotor Wiring

```text
ETW: QWERTZUIOASDFGHJKPYXCVBNML

I:   EVLPKUDJHTGSZFRABWYICOXNMQ  Notch: G  Turnover: Y
II:  HXMQKGJTSCZFLBERNAWYIDOVPU  Notch: M  Turnover: E
III: JHDBSKYPZNMVXURECLIGQOAWTF  Notch: V  Turnover: N

UKW: DNSAJQIPGEXRWBVHFLCZYOMKUT  ← Uniquely rewired UKW
```

> Wiring measured from K438 by Patrick Hayes, verified 2023.

## Bletchley Breaking History

| Date | Event |
| ------ | ------- |
| 25 July 1940 | BP Colonel Tiltman first broke Rocket I traffic |
| 7 February 1941 | Broken again after re-appearance |
| 19 September 1944 | Traffic blackout |
| 28 October 1944 | Re-entered |

Rocket II (Western Europe, Sep 1942) was briefly broken. Rocket III was unbroken for a long period.

## Surviving Machines

| Serial | Location |
| -------- | ---------- |
| K438 | Glen Miranker collection, USA (appeared at Bonhams auction September 2023) |
| K456 | Detlev Gross (UKW only) |

## Sources

- Crypto Museum: <https://cryptomuseum.com/crypto/enigma/k/railway.htm>
- Marks, *Cryptologia* (2015)
- Patrick Hayes personal correspondence (2023) — K438 wiring measurement
