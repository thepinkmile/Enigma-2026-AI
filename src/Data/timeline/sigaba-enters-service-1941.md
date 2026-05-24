# SIGABA (ECM Mark II) Enters Joint Army–Navy Service (1941)

| Field | Value |
| ------- | ------- |
| Who | William F. Friedman (US Army SIS, M-134 concept); Frank B. Rowlett (rotor-stepping mechanism, SIGGOO); Commander Laurance F. Safford (US Navy OP-20-G, ECM Mark II); Commander Donald W. Seiler (US Navy, co-inventor on patent) |
| What | The US Army and Navy jointly adopt the SIGABA (ECM Mark II / M-134-C) as their shared high-security cipher machine — the most complex rotor cipher machine of WWII, with 15 rotors in three banks producing pseudo-random stepping; never broken by any Axis power throughout WWII |
| When | Joint adoption: 1941; development: mid-1930s–1940; patent filed 15 December 1944; patent issued 16 January 2001 (US Patent 6,175,625); operating principles declassified 2000 |
| Where | US Army SIS: Arlington Hall, Arlington, Virginia, USA (38.8763°N, 77.1075°W); US Navy OP-20-G: Navy Department Building then Naval Communications Annex, Nebraska Avenue, Washington DC (38.9383°N, 77.0868°W) |
| Related | [William Friedman](../profiles/william-friedman.md), [TypeX enters service 1937](typex-enters-service-1937.md), [SIGABA configuration](../configurations/sigaba.md), [Combined Cipher Machine](../configurations/combined-cipher-machine.md), [Bletchley Park established 1939](bletchley-park-1939.md) |

## Background and Development History

SIGABA was the product of a multi-year collaboration between the US Army's **Signal Intelligence Service (SIS)** and the US Navy's **OP-20-G** cryptologic bureau. Its development addressed
a fundamental weakness of contemporary rotor cipher machines — including Enigma — that their rotor stepping patterns were predictable and could be exploited by cryptanalysis.

### The Friedman M-134 Concept (mid-1930s)

**William Friedman**, Director of the Army SIS, identified that Enigma-style machines advanced their rightmost rotor at every keypress in a fixed, regular pattern — the source of the
"double-stepping anomaly" and other predictable features. His solution was to use a **paper tape reader from a teletype machine** to drive a truly random stepping pattern for the cipher
rotors. This concept went into limited Army production as the **M-134 Converter**.

### Rowlett's Rotor Improvement

**Frank Rowlett**, hired by Friedman on 1 April 1930 as a "junior cryptanalyst," replaced the fragile paper tape with a second set of rotors — a device called the **SIGGOO (M-229)**. In
the SIGGOO, five of the outputs from a three-rotor controlling assembly were live, generating pseudo-random signals that advanced the cipher rotors in an irregular, non-deterministic pattern.
The combination of the M-134 and SIGGOO became the **M-134-C**.

In 1964, Congress awarded Rowlett **US$100,000** (approximately US$1,040,000 in 2025) as partial compensation for his classified cryptologic inventions.

### Navy Adoption and ECM Mark II

In **1935**, Friedman and Rowlett showed their work to Joseph Wenger of OP-20-G. He found little interest in the Navy at first. In **early 1937**, Wenger showed the M-134-C to Commander
**Laurance Safford** — head of OP-20-G, "the Friedman of the Navy." Safford immediately recognised the machine's potential. Working with Commander **Donald W. Seiler**, they added
engineering improvements to make the machine easier to build, producing the **Electric Code Machine Mark II (ECM Mark II)**, which the Navy produced as the **CSP-888** (or **CSP-889**).

The Army was "let in" on Navy production in **early 1940**. In **1941**, the Army and Navy agreed to adopt a joint system:

- **US Army** designation: **SIGABA** (or **Converter M-134**)
- **US Navy** designation: **ECM Mark II** (CSP-888/889)

The patent, filed **15 December 1944** and kept classified until **16 January 2001** (US Patent 6,175,625), lists Safford and Seiler as the formal inventors.

## Architecture: Three Banks of 15 Rotors

SIGABA's fundamental innovation was its three-bank, 15-rotor architecture — radically different from Enigma's single bank of 3–4 rotors:

| Bank | Name | Count | Steps? | Function |
| --- | --- | --- | --- | --- |
| Rear | Cipher rotors ("alphabet maze") | 5 | Yes, irregularly | Primary encryption — equivalent to Enigma's rotor assembly |
| Middle | Control rotors ("stepping maze") | 5 | Yes | Receive 4 input signals; outputs grouped into 9 groups feeding index rotors |
| Front | Index rotors | 5 | **No** (fixed during operation) | Combined with control rotors, determine which 1–4 of 5 output lines carry power — advancing cipher rotors |

The control and index rotors together generated a **pseudo-random, irregular stepping pattern** for the cipher rotors. Any number from 1 to 4 cipher rotors might advance at each keypress —
completely unpredictably. This made attacks exploiting Enigma-style stepping patterns mathematically impossible.

### Key Differences from Enigma

| Feature | Enigma | SIGABA |
| --- | --- | --- |
| Total rotors | 3 (later 4) | 15 (3 banks of 5) |
| Reflector | Yes (mandatory) | No reflector; mode switch required |
| Plugboard | Yes (Steckerbrett) | None needed |
| Rotor stepping | Fixed regular + double-step anomaly | Pseudo-random irregular — 1–4 rotors per keypress |
| Key distribution | Manual settings lists | IBM 513 Reproducing Punch card system, Washington DC |
| Portability | ~12 kg, field-portable | Large, heavy, fragile — HQ use only |
| Tactical field use | Yes | No — M-209 (Hagelin) used instead for field comms |
| Self-reciprocal | Yes (reflector) | No — mode selector switch required |

## Machines Produced

**Just over 10,000 SIGABA machines** were built in total. By **1943**, over 5,000 were deployed; by the end of WWII, well over 10,000 (NSA figure, cited in Mucklow 2015). For comparison,
approximately 140,000 M-209 field cipher machines and 35,000+ Enigma machines were produced.

## Was SIGABA Ever Broken?

**No.** This is confirmed by multiple independent sources including post-war TICOM interrogations of German and Japanese cryptanalysts:

- A decrypted Japanese diplomatic message dated **24 January 1942** reported that joint Japanese-German cryptanalytical efforts were
  "encountering difficulty in establishing successful techniques of attack" on American communications.
- A German war diary entry from **September 1944** records: *"U.S. 5-letter traffic: Work discontinued as unprofitable at this time."*
- TICOM interrogations confirmed that neither Germany nor Japan ever achieved a working attack on SIGABA.

### The Colmar Incident (3 February 1945)

A US Army truck carrying a SIGABA system in three safes was stolen while guards visited a brothel in recently liberated **Colmar, France**. General Eisenhower ordered an extensive search;
the safes were discovered six weeks later in a nearby river — apparently dumped when the thieves could not open them. The machine was recovered intact before any exploitation.

### Modern Analysis

In 2023, cryptologist George Lasry published methods for modern cryptanalysis of SIGABA (*Cryptologia*, 2023), demonstrating it can be attacked with modern computing power in under 24 hours.
With 1940s technology, this was completely impossible.

## Security Protocol

On **26 June 1942**, the Army and Navy agreed: *"SIGABA not to be placed in foreign territory without armed US personnel... The SIGABA would be made available to another Allied country only if
personnel of that country were denied direct access to the machine or its operation by an American liaison officer."*

## Combined Cipher Machine

From **1 November 1943** (naval) and **April 1944** (all Allied services), modified SIGABA machines formed part of the **Combined Cipher Machine (CCM)** — enabling US–British interoperability
with TypeX. The British were shown TypeX; the Americans never permitted the British to examine the ECM Mark II internals. For CCM use, the SIGABA's 15-rotor basket was replaced with a
5-rotor basket (less secure but interoperable with a modified TypeX Mark 23).

## Decommissioning and Declassification

SIGABA remained in service through the **1950s** until replaced by the KL-7 (AFSAM-7). Its operating principles were not declassified until **2000**; the patent was issued on
**16 January 2001** — 57 years after it was filed.

## Sources

- Mucklow, Timothy J., "The SIGABA/ECM II Cipher Machine: 'A Beautiful Idea'," Center for Cryptologic History, NSA, 2015
- Fagone, Jason, *The Woman Who Smashed Codes*, Crown, 2017
- Wikipedia, "SIGABA" — [https://en.wikipedia.org/wiki/SIGABA](https://en.wikipedia.org/wiki/SIGABA)
- Crypto Museum, "SIGABA" — [https://www.cryptomuseum.com/crypto/usa/sigaba](https://www.cryptomuseum.com/crypto/usa/sigaba)
- Wikipedia, "Combined Cipher Machine" — [https://en.wikipedia.org/wiki/Combined_Cipher_Machine](https://en.wikipedia.org/wiki/Combined_Cipher_Machine)
- US Patent 6,175,625 — filed 15 December 1944; issued 16 January 2001
