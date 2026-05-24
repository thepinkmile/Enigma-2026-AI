# Caesar Cipher (~50 BC)

| Field | Value |
| ------- | ------- |
| Who | Gaius Julius Caesar |
| What | First documented systematic military use of alphabetic substitution encryption; a shift cipher (ROT-3) used in Caesar's military dispatches — the conceptual ancestor of all subsequent alphabetic substitution, including the Enigma rotor substitutions |
| When | c. 58–50 BC (during the Gallic Wars and subsequent campaigns) |
| Where | Roman Republic campaigns: Gaul (modern France), approx. 46.2276°N, 2.2137°E; Rome (41.9028°N, 12.4964°E) |
| Related | [Julius Caesar](../profiles/julius-caesar.md), [Al-Kindi frequency analysis](al-kindi-frequency-analysis-850.md), [Atbash and Scytale](ancient-ciphers-700bc.md) |

## The Cipher

The **Caesar cipher** substitutes each letter of the plaintext with the letter a fixed number of positions later in the alphabet. Caesar reportedly used a shift of **3**:

```text
Plain:  A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
Cipher: D E F G H I J K L M N O P Q R S T U V W X Y Z A B C
```

Example: `VENI VIDI VICI` → `YHQL YLGL YLFL`

## Historical Source

The cipher is documented by **Suetonius** in *The Twelve Caesars* (c. AD 121):
> *"If he had anything confidential to say, he wrote it in cipher, that is, by so changing the order of the letters of the alphabet, that not a word could be made out. If anyone wishes to decipher
these, and get at their meaning, he must substitute the fourth letter of the alphabet, namely D, for A, and so with the others."*

**Aulus Gellius** (*Noctes Atticae*, c. AD 150) confirms the shift-of-three usage. Caesar's successor **Augustus** used a shift of one, and — per Suetonius — did not wrap around (Z became AA rather
  than A), showing early awareness of cryptographic variation.

## Cryptographic Significance

### Strength and Weakness

The Caesar cipher has exactly **25 possible keys** (shifts of 1–25; shift of 0 or 26 is no encryption). It can be broken in seconds by brute force — trying all 25 shifts and checking which produces
readable Latin.

Against opponents of the first century BC who were unfamiliar with the concept of systematic alphabetic substitution, it provided adequate tactical security. Against Al-Kindi's frequency analysis
(developed c. 850 AD), it provides zero security.

### Conceptual Legacy

The Caesar cipher established three principles that run through all subsequent cryptography to Enigma and beyond:

1. **Key separation**: the algorithm (shift) is separate from the key (how much to shift)
2. **Alphabetic substitution**: letters map to letters via a systematic rule
3. **Mechanical reproducibility**: the same key setting produces the same result every time

Each Enigma rotor is, at its core, a Caesar cipher with a randomly wired "shift" — the innovation is that the shift changes automatically with every keypress.

## Sources

- Suetonius. *The Twelve Caesars* (c. AD 121)
- Kahn, David. *The Codebreakers* (Scribner, 1967/1996)
- Singh, Simon. *The Code Book* (Doubleday, 1999)
