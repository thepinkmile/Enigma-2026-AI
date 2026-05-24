# Breaking the Vigenère — Babbage and Kasiski (1854/1863)

| Field | Value |
| ------- | ------- |
| Who | Charles Babbage (c. 1854, unpublished); Friedrich Kasiski (1863, published) |
| What | Independent discovery of the technique for breaking the Vigenère cipher by finding the key period; ended the cipher's 300-year reputation as "indecipherable"; the conceptual ancestor of Bletchley Park's Banburismus and index of coincidence techniques used against Enigma |
| When | Babbage: c. 1854; Kasiski published: 1863 |
| Where | Babbage: London, England (51.5074°N, 0.1278°W); Kasiski: Neustettin, Prussia (now Szczecinek, Poland) (53.7120°N, 16.6980°E) |
| Related | [Charles Babbage](../profiles/charles-babbage.md), [Friedrich Kasiski](../profiles/friedrich-kasiski.md), [Vigenère cipher](vigenere-cipher-1553.md), [Playfair cipher](playfair-cipher-1854.md) |

## The Break

Both Babbage and Kasiski independently recognised that the Vigenère cipher's security depended entirely on the key length being unknown. Once the key length was found, the cipher reduced to multiple
independent Caesar ciphers — each trivially broken by frequency analysis.

### Finding the Key Length — The Kasiski Test

1. **Search for repeated sequences** of 3 or more letters in the ciphertext
2. **Record the distance** (in character positions) between each pair of repetitions
3. **Find the GCD** of all recorded distances — this is the probable key length (or a factor of it)
4. **Confirm** using the Index of Coincidence: split the ciphertext into *n* streams and check that each stream has the IC of natural language (not random)

### Breaking Each Caesar Stream

Once the key length *n* is known, split the ciphertext into *n* interleaved streams (characters at positions 1, n+1, 2n+1, ... form stream 1; positions 2, n+2, 2n+2, ... form stream 2; etc.). Each
stream is a Caesar cipher — broken by frequency analysis in seconds.

## Why Babbage Never Published

Babbage cracked the Vigenère in response to a challenge from John Hall Brock Thwaites (who claimed to have invented an unbreakable cipher). He demonstrated the break in private correspondence but
never published it. Historians speculate this may have been at the request of the British government — if the break was made public, adversaries would replace Vigenère with something harder. Kasiski,
unaware of Babbage's work, published independently in 1863.

## Connection to Bletchley Park

The conceptual chain from the Kasiski test to Bletchley Park is direct:

- **Index of Coincidence** (Friedman, 1920): a formal statistical version of Kasiski's insight
- **Banburismus** (Turing, 1940): Bayesian alignment of Naval Enigma messages — functionally equivalent to finding the period of a repeating element in M3 traffic
- **Crib-based attacks**: finding repeated plaintext ("weather report", "KEINE BESONDEREN EREIGNISSE" — "nothing to report") exploited the same statistical structures

## Sources

- Kahn, David. *The Codebreakers* (Scribner, 1967/1996)
- Singh, Simon. *The Code Book* (Doubleday, 1999)
- Wikipedia: <https://en.wikipedia.org/wiki/Kasiski_examination>
