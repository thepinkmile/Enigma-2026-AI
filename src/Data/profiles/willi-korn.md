# Willi Korn

| Field | Value |
| ------- | ------- |
| Who | Wilhelm (Willi) Korn |
| What | German engineer at Scherbius's Chiffriermaschinen-Aktiengesellschaft (ChiMaAG); inventor of the Umkehrwalze (reflector), the key component that made Enigma practical and self-reciprocal — and paradoxically the component that made it cryptanalytically vulnerable |
| When | c. 1884 – c. 1960 (exact dates uncertain) |
| Where | Berlin, Germany — ChiMaAG factory: Berlin-Tempelhof (52.4538°N, 13.4067°E) |
| Related | [Arthur Scherbius](arthur-scherbius.md), [Hugo Koch](hugo-koch.md), [Enigma A and B](../configurations/enigma-a-and-b.md) |

## Portrait

No portrait photograph is known to exist in any accessible digital archive. Possible avenues for rights-holder contact:

- [Bundesarchiv (German Federal Archives)](https://www.bundesarchiv.de) — records of the German Cipher Office (Chiffrierstelle) or Chiffriermaschinen AG corporate archives
- [Deutsches Technikmuseum Berlin](https://www.sdtb.de) — holds Enigma-related technical material

## Biography

Willi Korn was a German engineer employed by Arthur Scherbius's **Chiffriermaschinen-Aktiengesellschaft (ChiMaAG)** in Berlin from the early 1920s. Very little is recorded about his personal life; he
is known almost entirely through his patent work and his role in the technical development of the commercial Enigma.

## The Reflector — Patent DE460457

In 1926, Korn filed German patent **DE460457** for the **Umkehrwalze** — the *reflector* or *reversing drum*. This was a fixed (non-rotating) wired disc placed at the leftmost position in the Enigma
rotor stack. Unlike the regular rotors, the reflector paired each of its 26 contacts into 13 mutual pairs, ensuring that the electrical signal entering the reflector on one contact always exited on a
different contact.

### What the Reflector Did

- **Self-reciprocal encryption**: Because the signal entered the rotor stack, bounced off the reflector, and returned through the same rotors in reverse, a message encrypted with a given key setting
  could be *decrypted by using the exact same key setting*. The machine was its own inverse. This was operationally critical — it meant receiving operators could use identical machines to decrypt
  without a separate decrypt table.
- **Eliminated the letter-to-itself case**: No letter could ever encrypt to itself. This was operationally convenient (operators could verify machine setup by checking `A → A` was impossible) but
  cryptanalytically fatal. It gave Alan Turing, Gordon Welchman, and the Polish mathematicians their single most powerful constraint — every crib (known plaintext segment) could be immediately tested
  by checking that no letter in the crib matched its cipher equivalent.

### The Paradox

The reflector was simultaneously the feature that made Enigma practical for mass military deployment *and* the single largest cryptanalytic weakness of the entire system. Every subsequent design
decision — the plugboard, additional rotors, operating procedures — was in some sense an attempt to compensate for the information that the self-reciprocal constraint leaked.

## Legacy

Korn's reflector invention shaped all subsequent Enigma variants. Even the Enigma M4 (naval 4-rotor machine) retained the reflector concept, using two thin half-width discs (thin reflector +
Beta/Gamma wheel) to achieve the same self-reciprocal property in a four-rotor stack while remaining compatible with three-rotor traffic.

The Lorenz SZ cipher machines, which used a different architecture entirely (no reflector, non-self-reciprocal), were consequently harder to break by the statistical methods developed against Enigma
— requiring the full power of Colossus.

## Sources

- Wikipedia: <https://en.wikipedia.org/wiki/Enigma_machine#Reflector>
- Crypto Museum — Umkehrwalze: <https://www.cryptomuseum.com/crypto/enigma/ukw.htm>
- Kahn, David. *The Codebreakers* (Scribner, 1967/1996)
