# Kasiski Test Published (1863)

| Field | Value |
| ------- | ------- |
| Who | Friedrich Wilhelm Kasiski |
| What | Publication of *Die Geheimschriften und die Dechiffrir-Kunst* — the first public description of the technique for finding the key period of a Vigenère cipher, ending its 300-year reign as "le chiffre indéchiffrable" |
| When | 1863 |
| Where | Berlin, Kingdom of Prussia (52.5200°N, 13.4050°E) |
| Related | [Friedrich Kasiski](../profiles/friedrich-kasiski.md), [Breaking the Vigenère](babbage-vigenere-break-1854.md), [Vigenère cipher](vigenere-cipher-1553.md) |

## Publication

Friedrich Kasiski's 95-page book *Die Geheimschriften und die Dechiffrir-Kunst* ("Secret Writing and the Art of Deciphering") was published in Berlin in 1863. It introduced what is now known as the
**Kasiski Test** or **Kasiski Examination**: a systematic method for determining the key length of a Vigenère cipher by measuring the distances between repeated ciphertext sequences.

Kasiski had cracked the Vigenère independently, and — unlike Babbage, who kept his method private — published it in full. He was a retired military officer in his 50s with no academic affiliation; he
had cracked the cipher as an intellectual exercise over the preceding decade.

## The Test in Brief

1. Find repeated sequences (3+ letters) in the ciphertext
2. Record the spacing between occurrences
3. The GCD of those spacings is the probable key length
4. Split the message into streams of that length
5. Frequency-analyse each stream as a Caesar cipher

## Historical Impact

The publication of the Kasiski test had immediate practical consequences:

- Professional cryptographers in European governments immediately recognised that the Vigenère family of ciphers was broken
- The search for a new "unbreakable" cipher class began in earnest
- William Friedman's **Index of Coincidence** (1920) formalised the statistical basis of the Kasiski attack mathematically

The progression from Kasiski (1863) → Friedman (1920) → Turing's Banburismus (1940) represents a single unbroken thread of statistical cryptanalytic thinking applied at increasing levels of
sophistication to increasingly complex cipher machines.

## Kasiski's Subsequent Obscurity

Despite this fundamental contribution, Kasiski published no further cryptographic work and returned to his civilian life. He pursued an interest in pre-Slavic anthropology and was elected a
corresponding member of the Berlin Anthropological Society. His cryptographic contribution was largely forgotten until historians of cryptography rediscovered *Die Geheimschriften* in the 20th
century.

## Sources

- Kahn, David. *The Codebreakers* (Scribner, 1967/1996)
- Wikipedia: <https://en.wikipedia.org/wiki/Friedrich_Kasiski>
