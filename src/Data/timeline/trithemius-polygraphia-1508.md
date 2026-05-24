# Trithemius *Polygraphia* (1508/1518)

| Field | Value |
| ------- | ------- |
| Who | Johannes Trithemius |
| What | First printed book on cryptography; introduced the tabula recta (progressive polyalphabetic substitution table) — the canonical framework used in all subsequent Vigenère-type ciphers and referenced in describing Enigma rotor behaviour |
| When | Written c. 1508; published posthumously 1518 |
| Where | Written at: St. James's Abbey, Würzburg, Germany (49.7950°N, 9.9300°E); published: Oppenheim, Germany |
| Related | [Johannes Trithemius](../profiles/johannes-trithemius.md), [Alberti cipher disc](alberti-cipher-1467.md), [Vigenère cipher](vigenere-cipher-1553.md) |

## The Tabula Recta

Trithemius's *Polygraphia* introduced the **tabula recta** — a 26×26 (Latin: 24-letter) square of shifted alphabets:

- Row 1 uses the standard alphabet
- Row 2 shifts all letters one position
- Row 3 shifts two positions
- … and so on to Row 26

His **progressive cipher** used rows sequentially: letter 1 of the message uses Row 1, letter 2 uses Row 2, and so on, cycling back after exhausting all rows. This is a fixed polyalphabetic cipher —
multiple alphabets, but with no secret key (the key is always "use the rows in order").

## The Step to Vigenère

The tabula recta is the mechanical foundation of the Vigenère cipher (1553). Bellaso's improvement was simply to use a **secret keyword** to select which row to apply at each position, rather than
always cycling through them in order. The table itself was Trithemius's contribution; the variable keyword was Bellaso's.

## *Steganographia* (1499/1606)

Trithemius also wrote *Steganographia* — ostensibly a book on spirit summoning but actually containing the first systematic treatment of **steganography** (hiding messages inside innocent-looking
text). The first two volumes encode messages inside Latin prayers; decoding them requires knowing which words in each paragraph carry the hidden message.

## Sources

- Wikipedia: <https://en.wikipedia.org/wiki/Johannes_Trithemius>
- Kahn, David. *The Codebreakers* (Scribner, 1967/1996)
