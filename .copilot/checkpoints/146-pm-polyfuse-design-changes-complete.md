# Checkpoint 146 — PM Per-Input Polyfuse & UVLO Recalculation Complete

## What was accomplished

Closed out the full PM per-input polyfuse protection and UVLO recalculation workstream
(started as `bulk-caps-per-power-source-or-conversion` discussion). All locked decisions
from DEC-069 have been applied across every affected design file. All writes are disk-only;
no git operations performed.

## Locked decisions (DEC-069)

| Decision | Detail |
| :--- | :--- |
| D1 — Per-input polyfuse (F2/F3/F4) | Bel Fuse 0ZRB0600FF1A, 6A hold / 12A trip, AEC-Q200, THT. One per input rail (PoE, USB-C, Battery), upstream of LM74700 OR-ing FET. CE/UKCA compliance. |
| D2 — UVLO resistor recalculation | R1 changed 232kΩ → 226kΩ (ERJ-3EKF2263V). Accounts for ≤40 mΩ polyfuse hold-state drop at 5.35A max load: eFuse EN_UVLO target = 10.786V (≈11V source). |
| D3 — OVLO unaffected | TPS25980 OVLO is silicon-fixed at 16.9V; no component changes required. |

Revised protection order: `[F2/F3/F4 polyfuse THT] → [LM74700 OR-ing FET U6a/b/c] → VIN_RAW → [L1/L2 Iron Curtain filter] → [U1 eFuse TPS259804] → VIN_BUS_OUT`

## KiCAD library imports (prior sessions, included here for completeness)

Both new parts were imported into `src/Electronics/Library/` before design files were updated:

| Part | MPN | DigiKey | Mouser | JLCPCB | Library status |
| :--- | :--- | :--- | :--- | :--- | :--- |
| Bel Fuse polyfuse | 0ZRB0600FF1A | 5923-0ZRB0600FF1A-ND | 530-0ZRB0600FF1A | C3762696 | Both legacy `.lib` and new `.kicad_sym` updated |
| Panasonic resistor | ERJ-3EKF2263V | P226KHCT-ND | 667-ERJ-3EKF2263V | C403081 | Both legacy `.lib` and new `.kicad_sym` updated |

## Files updated

| File | Change |
| :--- | :--- |
| `design/Electronics/Power_Module/Design_Spec.md` | Header Last Updated → 2026-05-14; DR-PM-06 Cross-Ref updated (226kΩ ERJ-3EKF2263V, UVLO note); DR-PM-19 added (per-input polyfuse, F2/F3/F4); mermaid block rebuilt (J2/J4/J5 inputs, F2/F3/F4, U6a/b/c OR-ing); Iron Curtain note updated; eFuse UVLO bullet updated (10.786V EN_UVLO / ≈11V source); R1 bullet updated (226kΩ ERJ-3EKF2263V); startup timeline step 2 corrected; BOM F2/F3/F4 row inserted; BOM R1 row updated |
| `design/Electronics/Consolidated_BOM.md` | F2/F3/F4 row inserted (PM: F2,F3,F4 | 0ZRB0600FF1A | qty 3); R1 row updated (ERJ-3EKF2263V, new supplier PNs) |
| `design/Design_Log.md` | DEC-069 appended (context, D1/D2/D3 decisions, rationale, precedence, files changed) |
| `.copilot/discussions/pm-bulk-caps-and-per-input-protection.md` | Status updated to "Closed / Implemented (DEC-068, DEC-069; 2026-05-14)" |

## Lint status

markdownlint run on all three design files — clean (exit 0). Two MD013 line-length errors
introduced in this session's edits were wrapped and resolved before final lint.

## Housekeeping

- Discussion file `.copilot/discussions/pm-bulk-caps-and-per-input-protection.md` closed
- SQL todo `bulk-caps-per-power-source-or-conversion` was already marked `done` in checkpoint 145

## Next steps

Resume remaining todo list. High-priority open todos:

- `jtag-integrity-resistor-value-reconcile` (pending)
- `mcp23017-gpb7-silicon-fixed-review` (pending)
- `usm-spdt-switch-floating-review` (pending)
- `consolidate-design-spec-content` (pending)
- `ctl-t1-tdk-library-import` / `ctl-t1-tdk-topology-confirm` (pending — T1 transformer decision)
- Board layout updates for PM (F2/F3/F4 THT placement, revised protection order) — not yet scoped
