# Atbash and Scytale — Ancient Ciphers (~700–600 BC)

| Field | Value |
| ------- | ------- |
| Who | Hebrew scribes (Atbash); Spartan military commanders (Scytale) |
| What | Two of the earliest recorded encryption methods: Atbash (mirror-substitution cipher in Hebrew) and the Scytale (transposition cipher using a rod) |
| When | Atbash: c. 700–600 BC; Scytale: c. 650–404 BC |
| Where | Atbash: Kingdom of Judah, Jerusalem (31.7683°N, 35.2137°E); Scytale: Sparta, Greece (37.0755°N, 22.4300°E) |
| Related | [Julius Caesar](../profiles/julius-caesar.md), [Caesar cipher](caesar-cipher-50bc.md) |

## Atbash Cipher (~700–600 BC)

**Atbash** is a simple Hebrew cipher in which each letter of the alphabet is substituted with its mirror: the first letter (Aleph, א) maps to the last (Taw, ת), the second (Beth, ב) maps to the
  second-to-last (Shin, ש), and so on.

The name "Atbash" (אטבש) is itself a cipher clue: it combines the first letter (Aleph), the last (Taw), the second (Beth), and the second-to-last (Shin) — signalling the mirror substitution principle.

**Biblical usage**: Atbash is used in the Hebrew Bible (*Tanakh*) in the books of **Jeremiah** (the word *Sheshach* in Jer. 25:26 and 51:41 is the Atbash encoding of *Babel*, i.e., Babylon) and
  **Jeremiah 51:1** (where *lev kamai* is Atbash for *Kasdim*, i.e., the Chaldeans). These encodings may have been political — avoiding direct use of Babylon's name during periods of Babylonian
  dominance.

Atbash is a **monoalphabetic substitution cipher** (every instance of a letter is always substituted the same way), making it trivially broken by frequency analysis. Its historical significance is as
the first recorded instance of deliberate alphabetic substitution for secrecy purposes.

## Scytale (~650–400 BC)

The **scytale** (Greek: σκυτάλη, *skutálē*, meaning "baton") was a **transposition cipher** device used by the Spartans. It consisted of a cylindrical rod around which a strip of parchment or leather
was wound in a tight spiral. The message was written along the length of the rod; when the strip was unwound, it appeared as a meaningless jumble of letters. The recipient rewound the strip around a
rod of identical diameter to read the message.

The scytale is the earliest recorded use of a physical **cipher device** (rather than a purely mental substitution). It was used for military dispatches — particularly between Spartan commanders in
the field and the home authorities (*ephors*) in Sparta.

**Cryptanalytic significance**: The scytale is a **transposition cipher** — letters are rearranged but not substituted. Unlike substitution ciphers, transposition preserves letter frequencies exactly
  (the most common letter in the ciphertext is still the most common letter of the plaintext language). It is therefore broken by frequency analysis even more easily than monoalphabetic substitution.

## Historical Significance

These two ancient ciphers represent the two fundamental classes of classical cipher:

1. **Substitution** (Atbash): replace letters with other letters
2. **Transposition** (Scytale): rearrange letters without substituting

Every classical cipher until the 20th century was a combination, elaboration, or iteration of these two principles. The Enigma machine performs multiple rounds of substitution (via its rotors) —
making it a vastly more complex descendant of the Atbash idea.

## Sources

- Kahn, David. *The Codebreakers* (Scribner, 1967/1996), Chapter 1
- Singh, Simon. *The Code Book* (Doubleday, 1999), Chapter 1
- Wikipedia: <https://en.wikipedia.org/wiki/Atbash>
- Wikipedia: <https://en.wikipedia.org/wiki/Scytale>
