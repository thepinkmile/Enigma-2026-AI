# SIGABA (ECM Mark II / M-134)

| Field | Value |
| ------- | ------- |
| Who | Designed by William F. Friedman (US Army SIS) and Frank B. Rowlett; independently developed variant by Lt. Commander Joseph Wenger (US Navy) |
| What | American 15-rotor electromechanical cipher machine; considered the most secure cipher machine of WWII; used for all US high-command communications including Roosevelt–Churchill traffic; **never broken by any Axis power** |
| When | Designed 1935–1940; operational 1941–1959 |
| Where | Designed: US Army Signal Intelligence Service, Arlington Hall, Virginia, USA (38.8799°N, 77.1142°W); manufactured: USA; deployed worldwide with US forces |
| Related | [TypeX](typex.md), [Combined Cipher Machine](combined-cipher-machine.md), [William Friedman](../profiles/william-friedman.md), [SIGABA enters service 1941](../timeline/sigaba-enters-service-1941.md) |

## Overview

SIGABA (a cover name; official designations: **ECM Mark II** [Navy], **M-134-C** or **CSP-2900** [Army]) was the American strategic cipher machine of WWII. It was dramatically more complex than the
German Enigma or British TypeX, using **15 rotors** in a cascaded pseudo-random stepping arrangement that made it computationally impossible to attack with the techniques available to Axis
cryptanalysts.

SIGABA is the only major WWII cipher machine for which **no wartime break is recorded**. German, Japanese, and Italian SIGINT services were entirely unable to read US SIGABA traffic. This stands in
stark contrast to the Enigma, which was broken by the Poles in 1932 and exploited by Bletchley Park throughout the war.

## Design and Architecture

### The Three Rotor Banks

SIGABA used **15 rotors** arranged in three banks of five:

#### 1. Cipher Rotors (5 rotors)

- The five **cipher rotors** performed the actual letter substitution — functionally equivalent to Enigma's three or four cipher rotors
- However, unlike Enigma, **they did not step in a regular pattern**. Their advancement was controlled entirely by the control rotors

#### 2. Control Rotors (5 rotors)

- The five **control rotors** generated a pseudo-random binary pattern on each keypress
- Their outputs drove a set of switching magnets that determined which of the five cipher rotors (or combination) would advance on each character
- This produced highly irregular, statistically complex cipher rotor motion — not the simple odometer stepping of Enigma

#### 3. Index Rotors (5 rotors)

- The five **index rotors** were fixed (did not move during operation) but could be set to different positions before each message
- They fed into the control rotor mechanism, diversifying the control pattern

### Why This Architecture Was Unbreakable

Enigma's weakness was that its rotor stepping was **regular and predictable** — once the period and rotor wirings were known, the entire keyspace could be systematically searched. The Bombe worked by
exploiting the predictability of stepping.

SIGABA's control rotor mechanism made the cipher rotor advancement **pseudo-random with no exploitable period** at the cryptanalytic scale available in the 1940s. There was no equivalent to the Bombe
that could attack SIGABA's stepping logic, because:

- No two successive keypresses had a predictable relationship
- The effective "period" before exact repetition was astronomically large
- There was no message indicator procedure that leaked daily key information (unlike Enigma's fatal doubled-indicator system pre-1940)

## Physical Description

- **Dimensions**: Significantly larger and heavier than Enigma — a desktop unit roughly the size of a large typewriter
- **Input**: Typewriter keyboard
- **Output**: Printed paper tape (like TypeX; no lampboard)
- **Rotors**: Each rotor had 26 contacts; the 15 rotors were drawn from a larger library of available rotors
- **Weight**: Approximately 50 lbs (23 kg) — substantially heavier than Enigma's ~12 lbs

The machine required **two operators** for optimal use — one to type, one to manage the tape output.

## Operational Security Protocols

SIGABA machines were handled under strict protocols:

- Each machine was serialised and its location tracked continuously
- In the event of imminent capture, operators were required to **destroy the machine** — dedicated thermite charges were provided
- Rotors and key settings were distributed separately from machines under armed guard
- No SIGABA machine was **ever captured intact by Axis forces** during WWII — a record that contributed to the traffic remaining secure

## Roosevelt–Churchill Communications

SIGABA was used for the most sensitive Allied communications, including:

- **Roosevelt–Churchill transatlantic traffic** (alongside the separate SIGSALY voice encryption system for telephone)
- **Eisenhower's SHAEF headquarters** communications
- All US Joint Chiefs of Staff traffic
- Combined Allied command communications (via the CCM adapter with British TypeX)

## Post-War and Retirement

SIGABA remained in US service well into the **Cold War era**, with final retirement in **1959**. Its existence was classified until the 1990s. The detailed design of the rotor wirings remains
partially classified.

Surviving machines are held at:

- **National Cryptologic Museum**, Fort Meade, Maryland, USA
- **National Security Agency** (not publicly displayed)

## Sources

- Wikipedia: <https://en.wikipedia.org/wiki/SIGABA>
- Rowlett, Frank B. *The Story of Magic* (Aegean Park Press, 1998)
- Crypto Museum: <https://www.cryptomuseum.com/crypto/usa/ecm/>
- Budiansky, Stephen. *Battle of Wits* (Free Press, 2000)
