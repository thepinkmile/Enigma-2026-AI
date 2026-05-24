# Polish Cipher Bureau Breaks Enigma (December 1932)

| Field | Value |
| ------- | ------- |
| Who | Marian Rejewski (lead mathematician); Jerzy Różycki; Henryk Zygalski; Gustave Bertrand (French intelligence, supplied documents); Hans-Thilo Schmidt (*Asche*, source) |
| What | Marian Rejewski uses group-theory mathematics to reconstruct the internal wiring of the Enigma military rotors from ciphertext alone — the first complete cryptanalytic break of the Enigma machine; achieved seven years before WWII began; the foundation on which Bletchley Park would build |
| When | December 1932 |
| Where | Polish Cipher Bureau (*Biuro Szyfrów*), Saxon Palace, Warsaw, Poland (52.2423°N, 21.0124°E) |
| Related | [Marian Rejewski](../profiles/marian-rejewski.md), [Jerzy Różycki](../profiles/jerzy-rozycki.md), [Henryk Zygalski](../profiles/henryk-zygalski.md), [Gustave Bertrand](../profiles/gustave-bertrand.md), [Hans-Thilo Schmidt](../profiles/hans-thilo-schmidt.md), [Pyry conference 1939](pyry-conference-1939.md) |

## Background

By 1932, the German military was using the **Enigma I** — the plugboard-equipped Wehrmacht version — for all sensitive communications. The Polish Cipher Bureau (*Biuro Szyfrów*) had been attempting
to read German signals since at least 1929, when they acquired a commercial Enigma machine. However, the military version with its plugboard was a different problem entirely.

## The French Intelligence Connection

French military intelligence officer **Gustave Bertrand** had cultivated a German spy: **Hans-Thilo Schmidt** (codenamed *Asche* — "ashes"), a low-level employee at the German Cipher Office
(*Chiffrierstelle*). In September and October 1931, Schmidt provided Bertrand with Enigma operating manuals — the **Schlüsselanleitung** — and the daily key settings used by the German Army for
specific periods. These documents did **not** include the internal wiring of the rotors, but they told the Polish mathematicians exactly how the machine was **used**.

Bertrand shared the material with Polish intelligence. The French and British intelligence services had attempted to exploit the material and failed; it was the Poles who succeeded.

## Rejewski's Mathematical Attack

Working from:

1. The operating manuals (structure of the key message)
2. Actual encrypted messages intercepted in known periods
3. A fundamental weakness in the **message indicator procedure** — operators sent the 3-letter message key twice at the start of every message

Rejewski deduced that the twice-repeated key created **pairs of substitutions six positions apart** in the Enigma's rotor sequence. Using **permutation group theory** (a branch of abstract algebra),
he set up a system of equations whose solution gave him the complete wiring of all three rotors.

The solution required months of mathematical effort but yielded the complete internal wiring — without ever seeing the inside of a military Enigma machine.

## What the Break Achieved

By the end of 1932, the Polish Cipher Bureau could:

- Reconstruct the **daily key** (rotor selection, ring settings, plugboard settings) for any day on which they had intercepted sufficient traffic
- Read German Army Enigma traffic in near-real-time once the daily key was recovered
- Use **Rejewski's card catalogue** method to speed daily key recovery

## The Bombe Origin

In 1938, when Germany increased the plugboard to 10 pairs (making manual methods impractical), Rejewski and Różycki designed the **Bomba kryptologiczna** — an electromechanical device that tested
multiple rotor positions simultaneously. Six were built. This was the direct conceptual predecessor of Turing and Welchman's Bombe at Bletchley Park.

## Significance

The Polish break of December 1932 is arguably the **single most consequential event in the history of cryptanalysis**. It established:

- That the Enigma was mathematically breakable (not theoretically unbreakable, as the Germans believed)
- A set of techniques — double indicator analysis, mathematical group theory, catalogue attacks — that Bletchley Park extended and refined
- A tradition of cooperation (Poland → France → Britain at Pyry, 1939) that shaped the entire Allied intelligence effort

## Sources

- Rejewski, Marian. "An Application of the Theory of Permutations in Breaking the Enigma Cipher." *Applicationes Mathematicae* 16(4), 1980
- Kozaczuk, Władysław. *Enigma: How the German Machine Cipher Was Broken* (1984)
- Sebag-Montefiore, Hugh. *Enigma: The Battle for the Code* (Weidenfeld & Nicolson, 2000)
