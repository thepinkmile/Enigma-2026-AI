## DEC-014 - Controller Board Uses ERF8 (Female) on Both BtB Connectors for Blind-Mate Assembly

- **Status:** ✔ RESOLVED
- **Date:** 2026-04-04
- **Category:** Electrical
- **Area:** Controller J1 (Link-Alpha), Controller J2 (Link-Beta), Consolidated BOM connector inventory

### Decision

Both BtB connectors on the Controller Board use the ERF8 female socket: J1 (Link-Alpha) uses **ERF8-040-05.0-S-DV-K-TR** and J2 (Link-Beta) uses **ERF8-020-05.0-S-DV-K-TR**.
The mating male plugs are fitted to the Power Module (J1, ERM8-040) and the Stator Board (J8, ERM8-020-05.0-S-DV-K-TR) respectively.

### Rationale

During mechanical assembly, the Controller Board slides into the enclosure and must simultaneously engage
with two boards along its back edge - the Power Module (J1) to one side and the Stator (J2) to the other.
Using female sockets on the Controller allows guided blind-mate engagement in a single insertion motion,
with the mating male pins on the peripheral boards providing positive alignment.
Placing male headers on the Controller would require both peripheral boards to be precisely pre-positioned before the Controller could be inserted,
significantly complicating assembly.

### Connector Assignment Summary

| Board | Connector | Gender | Part |
| :--- | :--- | :--- | :--- |
| Controller | J1 (Link-Alpha, from Power Module) | Female | ERF8-040-05.0-S-DV-K-TR |
| Controller | J2 (Link-Beta, to Stator Board) | Female | ERF8-020-05.0-S-DV-K-TR |
| Power Module | J1 (Link-Alpha plug) | Male | ERM8-040-05.0-S-DV-K-TR |
| Stator Board | J8 (Link-Beta plug) | Male | ERM8-020-05.0-S-DV-K-TR |

### Impact

- Controller BOM J2 updated from ERM8 (male) to ERF8 (female); JLCPCB C-number to be verified.
- Controller §2 narrative updated to reflect ERF8 on Link-Beta.
- No electrical impact - connector is signal-transparent; pin assignments unchanged.
