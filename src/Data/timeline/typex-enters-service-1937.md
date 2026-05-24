# TypeX Mark I Enters RAF Service (Early 1937)

| Field | Value |
| ------- | ------- |
| Who | Wing Commander Oswyn G.W.G. Lywood (designer, RAF); J.C. Coulson, Albert P. Lemmon, Ernest W. Smith (development team); Creed & Company (printing unit); Powers-Samas (principal manufacturer) |
| What | The first production batch of approximately 29–30 TypeX Mark I cipher machines enters service with the Royal Air Force — the first deployment of Britain's Enigma-derived high-security cipher machine, originally designated "RAF Enigma with Type X attachments"; the machine is never broken by any Axis power throughout WWII |
| When | Early 1937 (Mark I production batch); prototype delivered to Air Ministry 30 April 1935; Mark II development begins February 1937; ~12,000 total machines built by 1945 |
| Where | Development: Kidbrooke, Greenwich, London, England (51.4662°N, 0.0227°E); Air Ministry receipt: Whitehall, London (51.5038°N, 0.1276°W); manufacture: Powers-Samas, UK |
| Related | [TypeX configuration](../configurations/typex.md), [SIGABA enters service 1941](sigaba-enters-service-1941.md), [Enigma I Wehrmacht](../configurations/enigma-i-Wehrmacht.md), [Bletchley Park established 1939](bletchley-park-1939.md), [Combined Cipher Machine](../configurations/combined-cipher-machine.md) |

## Origins

The story of the TypeX begins in **1926**, when a British inter-departmental committee was formed to examine replacing book cipher systems with cipher machines. During its deliberations,
**Wing Commander Oswyn G.W.G. Lywood** of the Royal Air Force proposed adapting the **commercial Enigma** — which was being sold openly on the civilian market through Scherbius's
Chiffriermaschinen AG — by adding a printing unit. The committee rejected his proposal, believing it unnecessary.

Lywood persisted. In **August 1934**, he was authorised by the RAF to proceed with development. Working at **Kidbrooke, Greenwich** with colleagues J.C. Coulson, Albert P. Lemmon, and Ernest
W. Smith, and with the printing unit supplied by **Creed & Company**, the team produced a working prototype. The machine was originally designated **"RAF Enigma with Type X attachments"** —
making the lineage from the commercial Enigma completely explicit.

The prototype was delivered to the Air Ministry on **30 April 1935**.

## TypeX vs Enigma: Key Improvements

TypeX addressed several fundamental weaknesses of the military Enigma:

| Feature | Military Enigma | TypeX |
| --- | --- | --- |
| Number of rotors | 3 (later 4, naval M4) | 5 always |
| Notch system | 1 fixed notch per rotor (predictable stepping) | Multiple notches (5, 7, or 9) — eliminates predictable stepping patterns |
| Static rotors | None | Two rightmost rotors are static — function as a plugboard |
| Double-stepping anomaly | Present | Eliminated |
| Output | Lamp board (requires manual transcription) | Automatic paper tape printer — ciphertext AND plaintext |
| Operators needed | Two | One only |
| Operating speed | ~100 characters/min (manual) | 300 characters/min (Mark II electric) |
| Plugboard | Yes (pairwise swaps) | Mark 22/23 added single-ended plugboard (any letter to any letter) |

The multiple-notch rotor design was the most critical security improvement: it eliminated the class of attacks based on predicting rotor stepping positions that could eventually be applied
against Enigma.

## Service Entry and Variants

The first production batch of approximately **29–30 TypeX Mark I** machines was delivered to the RAF in **early 1937**. No precise calendar day/month is recorded in any surviving primary source.

Development of the Mark II began immediately in **February 1937**; in **June 1938**, a cipher-machine committee demonstrated the Mark II and approved an initial order of **350 machines**,
manufactured by **Powers-Samas Accounting Machines Limited** (a British tabulating machine company that merged with BTM in 1959 to form International Computers and Tabulators). The Mark II
became the principal WWII variant, with two built-in printers.

By the end of WWII, approximately **12,000 TypeX machines** had been produced (estimate from historian Ralph Erskine, *Journal of Intelligence History*, 2002).

### Principal Variants

| Variant | Description |
| --- | --- |
| Mark I | First production batch (~29–30 machines), early 1937; linked to standard teletypewriter |
| Mark II | Main WWII variant; 350-unit initial order 1938; two built-in printers; 300 chars/min; produced by Powers-Samas |
| Mark III | Portable, hand-cranked; optional motor drive |
| Mark VI | Portable, motor-driven; 14 kg |
| Mark VIII | Mark II fitted with Morse perforator |
| Mark 22 (BID/08/2) | Mark II + two plugboards; rewirable reflector (like Enigma UKW-D); single-ended plugboard |
| Mark 23 (BID/08/3) | Mark 22 modified for Combined Cipher Machine (CCM) interoperability with SIGABA |

## Services That Used TypeX

| Service | Entry |
| --- | --- |
| Royal Air Force | Early 1937 (Mark I) |
| British Army | 1938–1939 (with Mark II) |
| Royal Navy | 1940 (after trials; RN circulars M 0707/40 and M 013030/40) |
| Other government departments | 1938+ |
| Australia, Canada, New Zealand | WWII period |

## Was TypeX Ever Broken?

**No.** Despite several opportunities, the Axis powers never broke TypeX traffic:

- At **Dunkirk (June 1940)**, a TypeX machine was captured — but **without its rotors**. The *Beobachtungs-Dienst* (B-Dienst) attempted analysis for six weeks before abandoning the effort.
- German assessment: "the Typex was more secure than the Enigma since it had seven rotors" — so no major effort was made, since the Germans believed even Enigma was unbreakable.
- "Less than a year into the war, the Germans could read all British military encryption other than Typex." (Tony Comer, RUSI commentary, 2021)
- A British internal investigation (*ZIP/SAC/G.34*, TOP SECRET) assessed reports of captures in North Africa (Tobruk, 1942) but found no confirmed German exploitation.

## Combined Cipher Machine

From **1 November 1943** (naval) and **April 1944** (all Allied services), TypeX Mark 23 machines were modified to operate as part of the **Combined Cipher Machine (CCM)** — a joint
US–British system that made TypeX and SIGABA interoperable. The US manufactured all CCM adapters; Britain lacked the manufacturing capacity. The Americans showed TypeX to the US, but
never permitted the British to examine SIGABA's internals.

## Sources

- Erskine, Ralph, "The Admiralty and Cipher Machines During the Second World War," *Journal of Intelligence History*, 2(2), 2002
- Wikipedia, "Typex" — [https://en.wikipedia.org/wiki/Typex](https://en.wikipedia.org/wiki/Typex)
- Crypto Museum, "TypeX" — [https://www.cryptomuseum.com/crypto/uk/typex](https://www.cryptomuseum.com/crypto/uk/typex)
- Wikipedia, "Combined Cipher Machine" — [https://en.wikipedia.org/wiki/Combined_Cipher_Machine](https://en.wikipedia.org/wiki/Combined_Cipher_Machine)
- Wikipedia, "Powers-Samas" — [https://en.wikipedia.org/wiki/Powers-Samas](https://en.wikipedia.org/wiki/Powers-Samas)
