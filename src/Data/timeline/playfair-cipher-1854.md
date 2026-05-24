# Playfair Cipher (1854)

| Field | Value |
| ------- | ------- |
| Who | Charles Wheatstone (inventor, 1854); Lord Lyon Playfair (promoter) |
| What | First bigraph substitution cipher — enciphers pairs of letters rather than individual letters, defeating simple frequency analysis and remaining in British military use through WWII; misnamed after its promoter rather than its inventor |
| When | Invented: 1854; adopted by British Foreign Office: 1857; used in WWI and WWII by British and Australian forces |
| Where | London, England (51.5074°N, 0.1278°W) |
| Related | [Charles Wheatstone](../profiles/charles-wheatstone.md), [Vigenère cipher](vigenere-cipher-1553.md), [Babbage–Kasiski break](babbage-vigenere-break-1854.md) |

## The Cipher

The Playfair cipher uses a **5×5 key square** constructed from a keyword. The letter I and J share a cell (reducing 26 letters to 25).

**Constructing the key square** (keyword `ENIGMA`):

```text
E N I G M
A B C D F
H K L O P
Q R S T U
V W X Y Z
```

**Encipherment rules** (operating on digraphs — pairs of letters):

1. If both letters are in the **same row**: replace each with the letter to its right (wrapping)
2. If both letters are in the **same column**: replace each with the letter below it (wrapping)
3. Otherwise (**rectangle rule**): each letter is replaced by the letter in the same row but in the column of the other letter

If a digraph has two identical letters, insert an `X` (or `Q`) between them and re-pair.

## Why It Was Stronger

Unlike monoalphabetic ciphers, Playfair enciphers **26×26 = 676 possible bigraphs** (letter pairs) rather than 26 individual letters. A simple frequency analysis of single letters gives no useful
information. The attacker must study **bigraph frequencies** — which exist in natural language (`TH`, `HE`, `IN`, `ER` are common English bigraphs) but are much harder to exploit without substantial
ciphertext.

## Military Use

- **British Foreign Office**: adopted 1857
- **World War I**: used by British forces for tactical (field) communications
- **World War II**: still used by British and Australian forces for low-level field communications; considered adequately secure for messages whose tactical value expired quickly
- **Notable use**: the Battle of Tobruk and other North Africa campaigns

## Misattribution

Wheatstone demonstrated the cipher to friends including **Lord Lyon Playfair** at a dinner party in 1854. Playfair enthusiastically promoted it to the British government. When the British Foreign
Office adopted it, they named it after Playfair — not Wheatstone. Wheatstone reportedly remarked that it was "the most interesting thing about the cipher."

## Sources

- Singh, Simon. *The Code Book* (Doubleday, 1999)
- Kahn, David. *The Codebreakers* (Scribner, 1967/1996)
- Wikipedia: <https://en.wikipedia.org/wiki/Playfair_cipher>
