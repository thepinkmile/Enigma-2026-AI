# GC&CS Breaks Enigma K During Spanish Civil War (1937)

| Field | Value |
| ------- | ------- |
| Who | Dilly Knox (cryptanalyst, GC&CS); supported by GC&CS Broadway Buildings team |
| What | GC&CS cryptanalyst Dilly Knox breaks the commercial Enigma K (without plugboard) used by Nationalist and Italian forces during the Spanish Civil War — the first successful break of any Enigma traffic in operational use, using the "buttoning up" and "rodding" methods |
| When | 24 April 1937 |
| Where | GC&CS, Broadway Buildings, London, England (51.4985°N, 0.1344°W) |
| Related | [Dilly Knox](../profiles/dilly-knox.md), [Enigma K Commercial](../configurations/enigma-k-commercial.md), [Polish Enigma break 1932](polish-enigma-break-1932.md), [Bletchley Park established 1939](bletchley-park-1939.md) |

## Background

From the outbreak of the Spanish Civil War in July 1936, the German military (Condor Legion) and Italian forces fighting alongside Franco's Nationalists used a commercial variant of the
Enigma machine — the **Enigma K** — for encrypted radio communications. Unlike the military Enigma (Enigma I and later variants), the Enigma K had **no plugboard (Steckerbrett)**, which
made it substantially more vulnerable to cryptanalysis.

GC&CS began collecting intercepted Spanish Civil War Enigma traffic as early as late 1936. The messages were passed to **Alfred Dillwyn Knox** — universally known as "Dilly" — the veteran
Room 40 cryptanalyst who had been working on the Enigma problem intermittently since 1937.

## The Break

On **24 April 1937**, Knox achieved the first successful decryption of operationally enciphered Enigma traffic. He used two complementary techniques he had developed for attacking plugboardless
Enigma:

### "Buttoning Up"

Knox observed that the commercial Enigma K's reflector combined with its rotor wiring produced systematic patterns when the same message key was enciphered repeatedly. By aligning multiple
messages with the same start position ("buttoning" them together) he could identify rotor positions.

### "Rodding"

Knox's "rodding" method used long thin slips of paper (the "rods") inscribed with the Enigma's alphabet-scrambling sequences at each rotor position. By sliding the rods against each other, an
analyst could mechanically search for self-consistent positions — letter-by-letter deductions that allowed the internal wiring of the rotors to be partially inferred.

These methods were later refined by Knox and his colleagues (including Mavis Lever and Penelope Fitzgerald) to break the Italian Naval Enigma K variant — a capability that proved decisive
at the **Battle of Cape Matapan** in March 1941.

## Significance

This was the **first time any version of the Enigma machine was broken in active operational use**. Several important consequences followed:

1. **Confidence in GC&CS methodology**: The break confirmed that Knox's rodding/buttoning approach could defeat plugboardless Enigma variants.
2. **Intelligence value**: Intercepted communications revealed details of German and Italian force deployments during the Spanish Civil War,
   and exposed the structure of the Condor Legion's communications network.
3. **Limits acknowledged**: The methods did *not* transfer directly to the military Enigma I with its plugboard. The plugboard increased
   the keyspace by a factor of roughly 10^14, requiring entirely new approaches — which Marian Rejewski's team in Poland had already
   begun developing independently.
4. **Foundation for wartime work**: Knox's experience with the Enigma K directly informed his contribution to understanding the military
   Enigma before and during WWII, and established the techniques later applied to the Abwehr Enigma.

## Context: The Polish Breakthrough

Unknown to Knox at the time, **Polish mathematicians** at the Biuro Szyfrów (Cipher Bureau) in Warsaw — led by Marian Rejewski, Jerzy Różycki, and Henryk Zygalski — had already been
reading German military Enigma (with plugboard) since **December 1932**, using algebraic methods that operated at a fundamentally different level. The British and Polish teams did not formally
share their methods until the historic meeting at Pyry, near Warsaw, in **July 1939**, just weeks before the outbreak of WWII.

## Sources

- Smith, Michael, *The Secrets of Station X*, Biteback Publishing, 2011
- Batey, Mavis, *Dilly: The Man Who Broke Enigmas*, Biteback Publishing, 2009
- Hinsley, F.H., *British Intelligence in the Second World War*, Vol. 1, HMSO, 1979
- Wikipedia, "Dilly Knox" — [https://en.wikipedia.org/wiki/Dilly_Knox](https://en.wikipedia.org/wiki/Dilly_Knox)
- Wikipedia, "Enigma machine — Spanish Civil War" section
