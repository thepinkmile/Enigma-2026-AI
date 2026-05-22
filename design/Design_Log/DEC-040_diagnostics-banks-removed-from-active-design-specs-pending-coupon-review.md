## DEC-040 - Diagnostics Banks Removed from Active Design Specs Pending Coupon Review

- **Status:** Decided
- **Date:** 2026-04-25
- **Category:** Documentation / Test-access strategy
- **Area:** All boards - active design specs, board layouts, and future coupon planning
- **Author:** Izzyonstage & GitHub Copilot

### Summary

All Diagnostics Banks have been removed from all design specs, as these are not production board
components and will be re-addressed later when reviewing the coupon implementations TODO item.

### Problem

The documentation had drifted into an inconsistent state:

- some active `Design_Spec.md` and `Board_Layout.md` files still described Diagnostics Banks or
  related future test-access details
- the finished machine is not intended to carry permanent Diagnostics Bank hardware
- the coupon strategy is already tracked separately as future work, so embedding those details into
  current board specs makes the active design harder to review

That mixed future test-access planning into documents that are supposed to define the current
production-board design.

### Decision

1. **Remove all Diagnostics Bank details from active board specs/layouts.**
   - No active `Design_Spec.md` or `Board_Layout.md` should describe Diagnostics Banks as if they are
     present on the current production boards.
   - Future test-access features must not appear as active board content before they are actually
     designed.

2. **Keep historical traceability in the Design Log only.**
   - Older Diagnostics Bank discussions remain in this log as historical context.
   - Where needed, those older entries are treated as superseded historical material rather than
     active design definition.

3. **Revisit test-access details only during the coupon work item.**
   - Any future removable coupon implementation is to be reviewed later under **OWI-001 - Test
     Coupons per Board**.
   - Per-board coupon signal selection, geometry, connector choices, and any related probe-access
     strategy are deferred until that dedicated review.

4. **Require a fresh review before any reintroduction.**
   - If test-access features are reintroduced later, they require a new explicit design update and
     the appropriate ESD / certification review at that time.

### Rationale

- Keeps active board docs focused on the actual production-board design.
- Avoids presenting future bring-up hardware as though it were already approved.
- Preserves the test-coverage intent without prematurely freezing implementation details.
- Makes the separation between **current design** and **future TODO work** explicit.

### Supersession / Obsolescence

- **DEC-009** and **DEC-010** remain historical traceability for the old Controller probe-access
  concept, but they are superseded as active board-definition guidance by this decision.
- Any historical references to Diagnostics Banks or equivalent fixed bring-up probe features in the
  active board specs/layouts are obsolete.

### Impact

- Active board `Design_Spec.md` and `Board_Layout.md` files must omit Diagnostics Bank content until
  the coupon work is actually designed.
- Future test-access planning stays in the Design Log / work-item tracking rather than in current
  board specs.
- Later coupon implementation work must decide the real test-access architecture per board instead of
  inheriting outdated fixed-bank assumptions.

### Cross-ref

DEC-009, DEC-010, QUE-002, OWI-001, OWI-002, `design/Standards/Certification_Evidence.md §8`
(DA-01).
