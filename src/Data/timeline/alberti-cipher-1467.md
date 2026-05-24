# Alberti Cipher Disc (1467)

| Field | Value |
| ------- | ------- |
| Who | Leon Battista Alberti |
| What | Invention of the polyalphabetic cipher and the cipher disc — the first cipher device to use multiple substitution alphabets, directly defeating frequency analysis; conceptual ancestor of the Enigma rotor |
| When | c. 1467 (publication of *De Cifris*) |
| Where | Rome, Papal States (41.9022°N, 12.4533°E) — written at the Vatican for Cardinal Riario |
| Related | [Leon Battista Alberti](../profiles/leon-battista-alberti.md), [Al-Kindi frequency analysis](al-kindi-frequency-analysis-850.md), [Trithemius tabula recta](trithemius-polygraphia-1508.md), [Vigenère cipher](vigenere-cipher-1553.md) |

## The Problem Alberti Solved

Al-Kindi's frequency analysis (c. 850 AD) had made every monoalphabetic cipher — where each plaintext letter always maps to the same ciphertext letter — trivially breakable. For 600 years, cipher
designers had no good answer.

Alberti's insight was simple: **use more than one substitution alphabet**. If different letters are used to encipher the same plaintext letter at different positions in the message, the frequency
pattern of the ciphertext is flattened — no single ciphertext symbol accumulates the frequency signature of a common plaintext letter.

## The Cipher Disc

Alberti designed a physical **cipher disc** (*formula*): two concentric brass discs, each carrying the letters of the (Latin) alphabet. The outer (fixed) disc held the standard alphabet. The inner
(rotating) disc held a scrambled alphabet.

To encipher: set the inner disc to a starting position (the key). Encipher several words using this position. Then **rotate the inner disc** to a new position (agreed with the correspondent) and
continue. The change of disc position changes the entire substitution alphabet — making frequency analysis across the whole message impractical.

### Connection to the Enigma Rotor

Alberti's disc and the Enigma rotor share the same fundamental concept:

- **Alberti disc**: a wired disc mapping 26 inputs to 26 outputs; manually rotated to change the substitution
- **Enigma rotor**: a wired disc mapping 26 inputs to 26 outputs; automatically rotated one position with every keypress

The crucial Enigma innovation — making the disc advance automatically rather than at the operator's discretion — eliminates the human element that made Alberti-type ciphers vulnerable to lazy key
management.

## The Tabula Recta Context

In the same work *De Cifris*, Alberti also described a **tabula recta** (a square array of shifted alphabets) — the same table that Trithemius would later expand into a full book (*Polygraphia*,
1508). Trithemius's progressive key and Vigenère's keyword extension were both developments of ideas Alberti had already sketched.

## Sources

- Alberti, Leon Battista. *De Cifris* (c. 1467)
- Kahn, David. *The Codebreakers* (Scribner, 1967/1996)
- Singh, Simon. *The Code Book* (Doubleday, 1999)
