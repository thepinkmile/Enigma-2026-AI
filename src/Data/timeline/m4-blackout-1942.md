# M4 "Shark" Blackout (1 February 1942)

| Field | Value |
| ------- | ------- |
| Who | German Navy (*Kriegsmarine*) U-boat arm; Bletchley Park Hut 8 (Alan Turing, Hugh Alexander); later Herbert Freeborn (US Naval codebreakers) |
| What | Introduction of the four-rotor Enigma M4 for U-boat communications creates a 10-month intelligence blackout on Atlantic U-boat traffic — directly contributing to catastrophic Allied merchant shipping losses; finally broken in December 1942 using material captured from U-559 |
| When | 1 February 1942 (blackout begins); c. December 1942 (Shark broken) |
| Where | Battle of the Atlantic; Bletchley Park, Buckinghamshire (51.9975°N, 0.7406°W); Mediterranean (U-559 capture site: 31.6°N, 32.5°E) |
| Related | [Alan Turing](../profiles/alan-turing.md), [Enigma M4 Naval](../configurations/enigma-m4-naval.md), [U-559 capture](u559-capture-1942.md), [Fasson and Grazier](../profiles/fasson-and-grazier.md) |

## The M4 Introduction

On **1 February 1942**, the German Navy (*Kriegsmarine*) switched its Atlantic U-boat communications from the three-rotor **M3** Enigma to the new **four-rotor M4** — codenamed **Shark** by Bletchley
Park. The M3 had been read almost continuously since mid-1941.

The M4 achieved its security increase through an elegant mechanical design: it replaced the thin reflector (Umkehrwalze B) and leftmost rotor with a single thin unit (the *Umkehrwalze Bruno* or
*Caesar*) paired with one of two new thin rotors (*Beta* or *Gamma*). To three-rotor machines, the combination was electrically identical to a standard reflector — the additional rotor was invisible.
But its 26 × 26 = 676 extra starting positions multiplied the Bombe's search space by 676, making existing three-rotor Bombes useless.

## The Blackout

For **ten months** — February to December 1942 — Bletchley could not read U-boat traffic. The consequences were catastrophic:

- **"Second Happy Time" for U-boats** (Jan–Aug 1942): U-boats operated freely off the US East Coast, sinking 1.6 million tons of Allied shipping — the highest monthly losses of the entire war
- Without routing intelligence, Allied convoys could not be diverted around U-boat patrol lines
- An estimated **2,000–3,000 merchant seamen died** who might have been saved with intelligence
- The Allied high command debated whether the Atlantic could be held at all

## The Solution

Bletchley needed a four-rotor Bombe, but also a **crib** for the M4 traffic — a known stretch of plaintext to initiate the Bombe test. In **October 1942**, the capture of material from U-559 provided
the cribs needed:

- The U-559 materials showed that **short weather signals** sent in the 4-rotor Shark key were simultaneously re-sent in the old 3-rotor *Dolphin* key
- If you could read the same message in both Shark and Dolphin, you had a **plaintext-ciphertext pair** — the perfect crib for attacking Shark
- By December 1942, Hut 8 had the cribs and the new 4-rotor Bombes (designed by Max Newman and built by the Post Office Research Station at Dollis Hill) to break Shark

## The Cost

The 10-month Shark blackout is a stark demonstration of what the Enigma was capable of when properly used. The German Navy's introduction of the M4 was well-managed — rolled out overnight with no
warning — and its effect was immediate and devastating.

The human cost was borne by the merchant mariners who died in ships that Bletchley might have routed to safety.

## Sources

- Harding, Stephen. *The Last Battle* (Da Capo Press, 2013)
- Hinsley, F.H. et al. *British Intelligence in the Second World War* (HMSO, 1979)
- Wikipedia: <https://en.wikipedia.org/wiki/Enigma_machine#Four-rotor_U-boat_Enigma>
