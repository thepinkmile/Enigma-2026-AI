# CTL T1 Coilcraft v2.0 Review

**ID:** `ctl-t1-coilcraft-v2-review`
**Status:** pending (v2.0)
**Category:** Electronics
**Source:** T1 transformer analysis — v2.0 deferred
**Blocked by:** None (v2.0 deferred)

---

## Description

DEFERRED TO V2.0. Review the Coilcraft POE600F-12L as an alternative T1 transformer for the v2.0 production design.

The TDK B82806D0060A120 was selected as the v1.0 transformer (see `ctl-t1-transformer-decision`). The Coilcraft POE600F-12L was shortlisted during the T1 analysis but not selected for v1.0.

For v2.0, evaluate:

1. **Production readiness** — confirm Coilcraft POE600F-12L is a production-stock (non-EOL) part with adequate supply.
2. **Supporting component changes** — identify any changes to the PoE front-end circuit (clamp, snubber, gate resistors, bulk caps) compared to the TDK-based v1.0 design.
3. **Cost delta** — compare total BoM cost impact vs TDK option.
4. **Footprint compatibility** — confirm whether the Coilcraft footprint is pin-compatible with the TDK footprint, or if a PCB re-spin is required.

## Notes

- This todo is intentionally v2.0 only; do not action as part of v1.0 prototype or interim-electronics-review-1.
- Reference: `ctl-t1-transformer-decision` (done), `ctl-t1-tdk-a120-component-analysis` (done), `ctl-t1-bourns-component-analysis` (done, superseded).
- Same priority as `display-addon-board` and `jdb-ft232h-3v3-vregin`.
