# Friedrich Kasiski

| Field | Value |
| ------- | ------- |
| Who | Friedrich Wilhelm Kasiski |
| What | Prussian military officer and cryptanalyst; independently discovered and published (1863) the technique for breaking the Vigenère cipher — now called the Kasiski test; his publication ended the cipher's 300-year reign as "indecipherable" |
| When | 29 November 1805 – 22 May 1881 |
| Where | Born: Schlochau, Prussia (now Człuchów, Poland) (53.6566°N, 17.3599°E); military service: Neustettin (now Szczecinek, Poland) (53.7120°N, 16.6980°E); later: Brandenburg an der Havel, Germany (52.4124°N, 12.5316°E) |
| Related | [Charles Babbage](charles-babbage.md), [Blaise de Vigenère](blaise-de-vigenere.md), [Charles Wheatstone](charles-wheatstone.md), [Breaking the Vigenère](../timeline/babbage-vigenere-break-1854.md) |

## Portrait

No portrait photograph is accessible in any digital archive (photography existed in Kasiski's lifetime from the 1850s onward, but no image has been digitised):

- [Bundesarchiv-Militärarchiv, Freiburg](https://www.bundesarchiv.de/bundesarchiv/organisation/abt_ma/index.html.de) — holds Prussian military records; may contain a formal military portrait or daguerreotype
- [Geheimes Staatsarchiv (Prussian State Archives), Berlin](https://gsta.prussian-cultural-heritage.de) — Prussian civil and military records
- [Muzeum Szczecinek (Neustettin, now Szczecinek, Poland)](http://muzeum.szczecinek.pl) — local museum of his home town; may hold regional historical materials

## Biography

Friedrich Kasiski was born in 1805 in the Prussian town of Schlochau (present-day Człuchów, Poland). He had a long career as an infantry officer in the Prussian army, rising to the rank of Major. He
served in the 33rd Infantry Regiment, stationed primarily at Neustettin. He retired from the military in 1863 — the same year he published his cryptanalytic breakthrough.

In retirement he pursued anthropology and archaeology as serious hobbies, publishing papers on prehistoric finds in Pomerania and becoming a corresponding member of the Berlin Anthropological
Society. He died at Brandenburg an der Havel in 1881.

## *Die Geheimschriften und die Dechiffrirkunst* (1863)

In 1863 Kasiski published ***Die Geheimschriften und die Dechiffrirkunst*** (*Secret Writing and the Art of Deciphering*) — a thin volume of 95 pages that destroyed the reputation of the Vigenère
cipher as indecipherable.

### The Kasiski Test

The technique Kasiski published — which Charles Babbage had discovered independently around 1854 but never published — worked as follows:

1. **Find repeated sequences**: Scan the ciphertext for repeated trigrams (and longer patterns). These repetitions indicate the same plaintext encrypted by the same portion of the keyword.
2. **Measure the spacings**: Record the distance (in letter positions) between each pair of repetitions.
3. **Find the GCD**: The greatest common divisor of these spacings is likely the keyword length (or a multiple of it).
4. **Factoring confirms the period**: Testing key lengths of *n* = 2, 3, 4, ... against the index of coincidence of each interleaved stream identifies the correct period.
5. **Frequency-analyse each stream**: Each of the *n* interleaved streams is now a Caesar cipher — solved by matching its character frequencies to expected language frequencies.

### Impact

The Kasiski test's publication in 1863 was a watershed moment:

- It immediately broke all known polyalphabetic ciphers in use for diplomatic and military communications
- It forced cryptographers to develop entirely new approaches — eventually leading to the one-time pad (Vernam, 1917) and the rotor machine (Scherbius, 1918)
- It established the concept of **key period** as the central vulnerability of repeating-key ciphers — a concept that Bletchley Park's cryptanalysts applied directly against Enigma indicator systems
  through techniques like the Kasiski-derived **index of coincidence** and **Banburismus**

## Connection to Breaking Enigma

The Kasiski test did not directly break Enigma — the machine's rotor stepping made its effective period astronomically large. However, the *concept* of exploiting key reuse and message repetition was
directly inherited:

- **Herivel tip**: German operators choosing similar daily key settings created a statistical cluster — a modern Kasiski-like observation
- **Cillies**: Lazy key choices (AAAA, QWERTY, operator's girlfriend's initials) were detected by searching for recurrence
- **Banburismus**: Turing's technique for aligning Naval Enigma messages was probabilistically equivalent to finding the period of a repeating element

## Sources

- Wikipedia: <https://en.wikipedia.org/wiki/Friedrich_Kasiski>
- Singh, Simon. *The Code Book* (Doubleday, 1999), Chapter 2
- Kahn, David. *The Codebreakers* (Scribner, 1967/1996)
