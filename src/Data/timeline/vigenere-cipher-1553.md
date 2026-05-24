# Vigenère Cipher (1553)

| Field | Value |
| ------- | ------- |
| Who | Giovan Battista Bellaso (inventor, 1553); Blaise de Vigenère (popularised and extended, 1586) |
| What | The repeating-key polyalphabetic cipher — the dominant European encryption system from 1553 to 1854 (300 years); nicknamed "le chiffre indéchiffrable"; broken by Babbage (1854) and Kasiski (1863) using the technique of finding the key period |
| When | Bellaso pamphlet: 1553; Vigenère *Traicté des Chiffres*: 1586; broken: 1854 (Babbage) / 1863 (Kasiski) |
| Where | Bellaso: Brescia, Lombardy, Italy (45.5416°N, 10.2118°E); Vigenère: Paris, France (48.8566°N, 2.3522°E) |
| Related | [Giovan Battista Bellaso](../profiles/giovan-battista-bellaso.md), [Blaise de Vigenère](../profiles/blaise-de-vigenere.md), [Trithemius tabula recta](trithemius-polygraphia-1508.md), [Breaking the Vigenère](babbage-vigenere-break-1854.md) |

## The Cipher

Using the **tabula recta** (Trithemius's 26×26 alphabet square), the Vigenère cipher enciphers each letter of the plaintext using the row of the tabula recta indicated by the corresponding letter of
a repeating **keyword**:

```text
Plaintext:  ATTACKATDAWN
Keyword:    LEMONLEMONLE
Ciphertext: LXFOPVEFRNHR
```

Position 1: A (row L) → L  
Position 2: T (row E) → X  
Position 3: T (row M) → F  
…

The keyword repeats as many times as needed to cover the plaintext.

## Why It Defeated Frequency Analysis

Al-Kindi's frequency analysis works because in a monoalphabetic cipher, every `E` in the plaintext always produces the same ciphertext symbol. In the Vigenère cipher, `E` is enciphered differently
depending on which key letter aligns with it — so its frequency is spread across multiple ciphertext symbols. With a long random keyword, the ciphertext frequencies approach uniformity, and simple
frequency analysis produces gibberish.

## The Cryptanalytic Response — Finding the Period

The fatal weakness: if the keyword is *n* letters long, then every *n*th letter was enciphered by the **same key letter** — meaning every *n*th letter forms a **Caesar cipher** (monoalphabetic
substitution). If you can determine *n*, you can split the ciphertext into *n* groups and frequency-analyse each group independently.

Finding *n* (the **Kasiski test**):

1. Scan for repeated letter sequences in the ciphertext
2. Measure the distances between repetitions
3. The GCD of those distances is (likely) the keyword length

This technique, discovered by Babbage c. 1854 and published by Kasiski in 1863, ended the Vigenère's 300-year reign.

## 300 Years of Use

The Vigenère cipher (under various names) was the standard for European diplomatic and military communications from ~1553 to ~1854:

- Used by Mary Queen of Scots (a more complex variant — broken by Walsingham's team, leading to her execution in 1587)
- Used extensively in the Thirty Years' War, Seven Years' War, Napoleonic Wars
- Used by the Confederate States of America in the Civil War (repeatedly broken by Union cryptanalysts)

## Sources

- Kahn, David. *The Codebreakers* (Scribner, 1967/1996)
- Singh, Simon. *The Code Book* (Doubleday, 1999)
- Wikipedia: <https://en.wikipedia.org/wiki/Vigen%C3%A8re_cipher>
