## DEC-010 - INC-14 DEFERRED: Legacy Probe-Access ESD Protection (Post-Prototype)

- **Status:** Deferred - Accepted risk for prototype stage
- **Date:** 2025
- **Category:** Electrical
- **Area:** Historical Controller bring-up probe-access concept

> **Supersession note:** Historical-only. See **DEC-040** for the current rule that all Diagnostics
> Banks are removed from the active design specs and will only be reconsidered later during the
> coupon implementation review.

### Decision

ESD protection on the historical probe-access concept is **deferred** to post-prototype evaluation.
No TVS diodes or series resistors are added to those bring-up-only signals at this stage.

### Rationale

- The probe-access concept was internal, accessed only by engineers with ESD precautions during
  development.
- Adding ESD protection to every bring-up-only signal adds cost, board space, and complexity before
  there is validated evidence that it is needed.
- Risk accepted for prototype: controlled lab environment, trained operators, no field exposure.

### Post-Prototype Action Required

- During first prototype test phase, evaluate signal integrity and ESD sensitivity on any temporary
  bring-up probe lines.
- If any such lines are exposed to field conditions (e.g., external test connectors), add series
  33Ω + TVS per line.
- Document findings and update this log with the final resolution.
