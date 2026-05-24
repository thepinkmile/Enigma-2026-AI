# Giovan Battista Bellaso

| Field | Value |
| ------- | ------- |
| Who | Giovan Battista Bellaso |
| What | Italian cryptographer; inventor of the proper Vigenère cipher in 1553 (the system that Blaise de Vigenère later published and received credit for); introduced the use of a passphrase as a repeating key to select rows from the tabula recta |
| When | c. 1505 – c. 1581 (exact dates unknown) |
| Where | Brescia, Lombardy, Italy (45.5416°N, 10.2118°E) |
| Related | [Johannes Trithemius](johannes-trithemius.md), [Blaise de Vigenère](blaise-de-vigenere.md), [Charles Babbage](charles-babbage.md), [Friedrich Kasiski](friedrich-kasiski.md), [Vigenère cipher](../timeline/vigenere-cipher-1553.md) |

## Portrait

No portrait exists — Bellaso (c. 1505–1581) lived before photography. No contemporary painting or engraving has been identified. An image of his published cipher booklet *La Cifra* (1553) is freely available:

- [*La Cifra* (1553) title page — Wikimedia Commons (public domain)](https://commons.wikimedia.org/wiki/File:Bellaso,_Giovanni_Battista_%E2%80%93_Cifra,_1553_%E2%80%93_BEIC_11404213.jpg)
- [Biblioteca Europea di Informazione e Cultura (BEIC), Milan](https://www.beic.it) — holds the digitised copy of *La Cifra*; may have additional biographical material
- [Archivio di Stato di Brescia](https://archiviodistatobrescia.beniculturali.it) — Brescia state archives for civic/family records

## Biography

Giovan Battista Bellaso was an Italian cryptographer working in Brescia in northern Italy during the mid-sixteenth century. His life is poorly documented beyond his publications. He served in the
court of Cardinal Duranti and was associated with the Italian Renaissance scholarly tradition.

## *La cifra del. Sig. Giovan Battista Bellaso* (1553)

In **1553**, Bellaso published a short pamphlet entitled *La cifra del. Sig. Giovan Battista Bellaso* — the first description of what is today called the **Vigenère cipher**. The key innovation over
Trithemius's progressive cipher was the use of a **secret passphrase** (a *contrasegno*, or countersign) to select which row of the tabula recta to apply at each position:

- Trithemius: use Row A for letter 1, Row B for letter 2, Row C for letter 3 (always the same cycle)
- **Bellaso**: use the rows indicated by *the letters of your passphrase* — Row A for key letter A, Row M for key letter M, etc. — then repeat the passphrase

This made the cipher length equal to the passphrase length, and if the passphrase was as long as the message and never reused (a **one-time pad**), theoretically unbreakable. In practice, passphrases
were short and reused, introducing a periodicity that Charles Babbage and Friedrich Kasiski later exploited.

## The Attribution Controversy

Blaise de Vigenère published a similar cipher in his *Traicté des Chiffres* in **1586** — 33 years after Bellaso. Vigenère knew of Bellaso's work (he cited Italian sources) but presented the cipher
as his own development in a context that later historians conflated with invention. By the 19th century the repeating-key polyalphabetic cipher was universally attributed to Vigenère, and despite
modern scholarship establishing Bellaso's priority, the name "Vigenère cipher" is now too embedded in the literature to change.

Bellaso also invented a variant using *reciprocal alphabets* (a forerunner of the autokey cipher concept) in his later work *Il vero modo di scrivere in cifra* (1564).

## Cryptographic Significance

The Bellaso/Vigenère cipher represented the state-of-the-art in encryption for nearly **300 years** (1553–1854). Its strength — using multiple alphabets with a repeating key — defeated Al-Kindi's
frequency analysis on individual symbols. Breaking it required the insight that if the key length was known, the ciphertext could be split into monoalphabetic sections — each of which was then
vulnerable to standard frequency analysis. This insight — developed independently by Charles Babbage (1854) and published by Friedrich Kasiski (1863) — also underpinned the index of coincidence, used
against Enigma indicator keys at Bletchley Park.

## Sources

- Wikipedia: <https://en.wikipedia.org/wiki/Giovan_Battista_Bellaso>
- Kahn, David. *The Codebreakers* (Scribner, 1967/1996)
- Singh, Simon. *The Code Book* (Doubleday, 1999)
