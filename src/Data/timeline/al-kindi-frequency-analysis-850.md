# Al-Kindi — Frequency Analysis (c. 850 AD)

| Field | Value |
| ------- | ------- |
| Who | Al-Kindi (Abū Yūsuf Yaʻqūb ibn ʼIsḥāq aṣ-Ṣabbāḥ al-Kindī) |
| What | Publication of the world's first cryptanalytic technique — frequency analysis — in *Risalah fī Istikhraj al-Mu'amma*; broke all monoalphabetic ciphers including the Caesar cipher; drove 700 years of cipher development as cryptographers sought to defeat it |
| When | c. 850 AD |
| Where | House of Wisdom (*Bayt al-Ḥikma*), Baghdad, Abbasid Caliphate (33.3152°N, 44.3661°E) |
| Related | [Al-Kindi](../profiles/al-kindi.md), [Caesar cipher](caesar-cipher-50bc.md), [Alberti cipher disc](alberti-cipher-1467.md) |

## The Breakthrough

Al-Kindi observed that every written language has a characteristic distribution of letter frequencies. In Arabic, certain letters appear far more commonly than others. Crucially, a **monoalphabetic
substitution cipher** — like the Caesar cipher — preserves these frequencies exactly: it replaces each letter consistently with the same substitute, so the most common letter in the ciphertext
corresponds to the most common letter in the plaintext language.

His method:

1. Count the frequency of each symbol in a sufficiently long ciphertext
2. Compare the ranked list to the known frequency ranking of the plaintext language
3. Assign the most common ciphertext symbol to the most common plaintext letter, second most common to second, and so on
4. Where ambiguities remain, use context and linguistic pattern to resolve

> *"One way to solve an encrypted message, if we know its underlying language, is to find a different plaintext of the same language long enough to fill one sheet or so, and then we count the
occurrences of each letter…"*
> — Al-Kindi, translated by Ibrahim Al-Kadi (1992)

## Impact

Frequency analysis rendered every monoalphabetic cipher — Caesar, Atbash, all simple substitutions — **immediately breakable** given sufficient ciphertext. This was not a marginal improvement; it was
a complete break of the entire class of cipher.

The cryptographic response took centuries:

- **1467**: Alberti's cipher disc — polyalphabetic substitution to flatten frequencies
- **1553**: Bellaso's repeating keyword cipher (misnamed Vigenère)
- **1854**: Babbage/Kasiski break of Vigenère by finding the key period
- **1918**: Scherbius's Enigma — rotors that change the substitution with every letter

Every major development in cipher design from 850 AD to the 20th century was, in essence, an attempt to defeat Al-Kindi's technique.

## Rediscovery

The manuscript was lost to Western scholarship for centuries. It was rediscovered in the **Sulaymaniyah Ottoman Archive in Istanbul** in **1987** by researchers Mehmet Mrayati, Yahya Meer Alam, and
M. Hassan at-Tayyan, who published an Arabic edition. An English translation by Ibrahim Al-Kadi was published in *Cryptologia* in 1992.

## Sources

- Al-Kindi (trans. Ibrahim Al-Kadi). *Cryptologia* Vol. 16(2), 1992
- Singh, Simon. *The Code Book* (Doubleday, 1999)
- Wikipedia: <https://en.wikipedia.org/wiki/Al-Kindi#Cryptography>
