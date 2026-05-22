## DEC-007 - Dual Interleaved LMQ61460-Q1 5V Buck (12A)

- **Status:** Decided
- **Date:** 2025
- **Category:** Electrical
- **Area:** Power Module 5V Buck (U2A/U2B)

### Decision

Two **LMQ61460-Q1** buck regulators are used in a **dual interleaved** configuration, providing a combined **12A** output at 5V. Earlier documentation referenced a single LM61460-Q1 (6A).

### Rationale

- Single 6A device is insufficient for CM5 at 25W (5A) + other 5V loads.
- Interleaved dual phase reduces input/output ripple and distributes thermal load.
- 12A capacity aligns with the 9A+ delivery capability of the updated Link-Alpha pin cluster.
