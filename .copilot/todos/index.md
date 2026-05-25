# Enigma-NG Todo Index

> **Canonical deferred-work reference.** Summary table only — no prose or inline notes.
> Per-todo detail files are in `.copilot/todos/<id>.md` (active todos only).
> Done todos retain their table row; detail files are archived to `.recycle-bin/` when closed.
>
> **Session DB setup:** run `.copilot/todos/todos.sql` then `.copilot/todos/deps.sql` at session start.
>
> **Design Log** entries: `design/Design_Log/` (per-DEC files; see `design/Design_Log/index.md`).

Last updated: 2026-05-25

---

## Summary Table

| ID | File | Status | Blocked By |
| --- | --- | --- | --- |
| `extension-mechanical-usage` | [extension-mechanical-usage.md](extension-mechanical-usage.md) | in-progress | — |
| `coupon-testing-review` | [coupon-testing-review.md](coupon-testing-review.md) | pending | `extension-mechanical-usage` |
| `battery-connector-final-review` | [battery-connector-final-review.md](battery-connector-final-review.md) | **blocked** | awaiting supplier response |
| `general-pin-mapping-schematic-capture` | — | done | — |
| `rerun-deep-reviews` | [rerun-deep-reviews.md](rerun-deep-reviews.md) | pending | `prototype-pcb-manufacturing` |
| `ctlh1-deferred` | — | done | — |
| `rotor-power-analysis-ministack` | — | done | — |
| `rotor-esd-tvs` | — | done | — |
| `rotor-variant-refdes-schematic` | — | done | — |
| `rotor-refdes-reallocate` | — | done | — |
| `production-folder` | — | done | — |
| `grs-production-link` | — | done | — |
| `display-addon-board` | [display-addon-board.md](display-addon-board.md) | **blocked** (v2.0) | — |
| `cpld-production-replacement` | [cpld-production-replacement.md](cpld-production-replacement.md) | **blocked** (v2.0) | — |
| `connector-thermal-verification` | — | done | — |
| `full-pn-review` | [full-pn-review.md](full-pn-review.md) | pending | `extension-mechanical-usage`, `battery-connector-final-review`, `coupon-testing-review`, `am-button-review-production` |
| `footprint-requests-pending` | [footprint-requests-pending.md](footprint-requests-pending.md) | pending | `full-pn-review` |
| `bom-func-notes-sweep` | — | done | — |
| `m25-m3-dec-exception` | — | done | — |
| `rotor-shaft-diameter` | [rotor-shaft-diameter.md](rotor-shaft-diameter.md) | pending | `prototype-pcb-manufacturing`, `ltc3350-telemetry`, `cpld-timing-load` |
| `rotor-rolling-element` | [rotor-rolling-element.md](rotor-rolling-element.md) | pending | `prototype-pcb-manufacturing`, `ltc3350-telemetry`, `cpld-timing-load` |
| `rotor-alloy-grade` | [rotor-alloy-grade.md](rotor-alloy-grade.md) | pending | `prototype-pcb-manufacturing`, `ltc3350-telemetry`, `cpld-timing-load` |
| `rotor-shaft-mechanism` | [rotor-shaft-mechanism.md](rotor-shaft-mechanism.md) | pending | `prototype-pcb-manufacturing`, `ltc3350-telemetry`, `cpld-timing-load` |
| `display-aperture` | [display-aperture.md](display-aperture.md) | **blocked** (v2.0) | — |
| `system-assembly-harnesses` | [system-assembly-harnesses.md](system-assembly-harnesses.md) | pending | `prototype-pcb-manufacturing`, `ltc3350-telemetry`, `cpld-timing-load` |
| `system-assembly-connectors` | [system-assembly-connectors.md](system-assembly-connectors.md) | pending | `prototype-pcb-manufacturing`, `ltc3350-telemetry`, `cpld-timing-load` |
| `ltc3350-telemetry` | [ltc3350-telemetry.md](ltc3350-telemetry.md) | pending | `rerun-deep-reviews`, `prototype-pcb-manufacturing` |
| `cpld-timing-load` | [cpld-timing-load.md](cpld-timing-load.md) | pending | `rerun-deep-reviews`, `prototype-pcb-manufacturing` |
| `da-01` | — | done | — |
| `da-02` | — | done | — |
| `naming-convention-sweep` | — | done | — |
| `da-04` | — | done | — |
| `compliance-testing` | [compliance-testing.md](compliance-testing.md) | pending | `prototype-pcb-manufacturing`, `emc-testing`, `environmental-testing`, `security-testing` |
| `bom-pre-prototype-check` | [bom-pre-prototype-check.md](bom-pre-prototype-check.md) | pending | `full-pn-review`, `interim-electronics-review-3`, `consolidate-design-spec-content` |
| `bom-pre-production-check` | [bom-pre-production-check.md](bom-pre-production-check.md) | pending | `bom-pre-prototype-check`, `prototype-system-complete`, `compliance-testing`, `emc-testing`, `environmental-testing`, `security-testing` |
| `jdb-board-rename` | — | done | — |
| `bypass-cap-audit-100nf` | — | done | — |
| `reset-n-prefix-decision` | — | done | — |
| `connector-stacking-height-review` | — | done | — |
| `plugboard-assembly-spec` | — | done | — |
| `enc-connector-review-pre-pcb` | — | done | — |
| `bom-system-qty-audit` | — | done | — |
| `mh-refdes-standardise` | — | done | — |
| `jdb-standoff-height` | — | done | — |
| `jdb-fr-renumber` | — | done | — |
| `jdb-ft232h-3v3-vregin` | [jdb-ft232h-3v3-vregin.md](jdb-ft232h-3v3-vregin.md) | **blocked** (v2.0) | — |
| `ctl-t1-wurth-datasheet-review` | — | done | — |
| `ctl-t1-transformer-decision` | — | done | — |
| `review-mounting-holes` | — | done | — |
| `interim-electronics-review-1` | [interim-electronics-review-1.md](interim-electronics-review-1.md) | pending | `review-pass-10`, `stackup-impedance-recalc`, `bulk-caps-per-power-source-or-conversion`, `ctl-l02-refdes-gap`, `enc-cpld-spare-pins-rule`, `jtag-pin1-silkscreen-grs`, `jtag-integrity-resistor-value-reconcile`, `mcp23017-gpb7-silicon-fixed-review`, `rot-i2c-residual-removal`, `consolidate-design-spec-content` |
| `interim-electronics-review-2` | [interim-electronics-review-2.md](interim-electronics-review-2.md) | pending | `interim-electronics-review-1`, `coupon-testing-review`, `review-mounting-holes` |
| `interim-electronics-review-3` | [interim-electronics-review-3.md](interim-electronics-review-3.md) | pending | `interim-electronics-review-2`, `full-pn-review`, `footprint-requests-pending` |
| `interim-electronics-review-4` | [interim-electronics-review-4.md](interim-electronics-review-4.md) | pending | `prototype-system-complete`, `compliance-testing` |
| `prototype-pcb-manufacturing` | [prototype-pcb-manufacturing.md](prototype-pcb-manufacturing.md) | pending | `review-mounting-holes`, `interim-electronics-review-3`, `bom-pre-prototype-check`, `enc-connector-review-pre-pcb` |
| `prototype-system-complete` | [prototype-system-complete.md](prototype-system-complete.md) | pending | `rerun-deep-reviews`, `ltc3350-telemetry`, `cpld-timing-load`, `rotor-shaft-diameter`, `rotor-rolling-element`, `rotor-alloy-grade`, `rotor-shaft-mechanism`, `system-assembly-harnesses`, `system-assembly-connectors` |
| `release-candidate-production` | [release-candidate-production.md](release-candidate-production.md) | pending | `rerun-deep-reviews`, `bom-pre-production-check`, `prototype-system-complete`, `compliance-testing`, `interim-electronics-review-4` |
| `version-one-complete` | [version-one-complete.md](version-one-complete.md) | pending | `release-candidate-production`, `version-1-documentation` |
| `review-pass-7` | — | done | — |
| `review-pass-8` | — | done | — |
| `review-pass-9` | — | done | — |
| `review-pass-10` | — | done | `review-pass-9` |
| `download-missing-3d-models` | — | done | — |
| `data-plate-standardisation` | — | done | `review-pass-10` |
| `design-log-restructure` | — | done | — |
| `copilot-dir-restructure` | — | done | — |
| `review-pass-11` | [review-pass-11.md](review-pass-11.md) | pending | `download-missing-3d-models`, `review-pass-10`, `copilot-dir-restructure` |
| `review-pass-12` | [review-pass-12.md](review-pass-12.md) | pending | `review-pass-11` |
| `review-clean-passes-gate` | [review-clean-passes-gate.md](review-clean-passes-gate.md) | pending | all `review-pass-x` todos |
| `ascii-to-mermaid-diagrams` | — | done | — |
| `board-interconnect-diagram` | — | done | — |
| `system-config-variants-diagrams` | [system-config-variants-diagrams.md](system-config-variants-diagrams.md) | pending | `prototype-pcb-manufacturing` |
| `version-1-documentation` | [version-1-documentation.md](version-1-documentation.md) | pending | `board-interconnect-diagram`, `system-config-variants-diagrams`, `ctl-component-diagram`, `pm-component-diagram`, `sta-component-diagram`, `rotor-component-diagram`, `ext-component-diagram`, `ref-component-diagram`, `enc-component-diagram`, `jm-component-diagram`, `usm-component-diagram`, `am-component-diagram`, `release-candidate-production`, `prototype-system-complete` |
| `ctl-component-diagram` | — | done | — |
| `pm-component-diagram` | — | done | — |
| `sta-component-diagram` | — | done | — |
| `rotor-component-diagram` | — | done | — |
| `ext-component-diagram` | — | done | — |
| `ref-component-diagram` | — | done | — |
| `enc-component-diagram` | — | done | — |
| `jm-component-diagram` | — | done | — |
| `usm-component-diagram` | — | done | — |
| `am-component-diagram` | — | done | — |
| `emc-testing` | [emc-testing.md](emc-testing.md) | pending | `prototype-pcb-manufacturing` |
| `environmental-testing` | [environmental-testing.md](environmental-testing.md) | pending | `prototype-pcb-manufacturing` |
| `security-testing` | [security-testing.md](security-testing.md) | pending | `prototype-pcb-manufacturing`, `prototype-system-complete` |
| `stackup-impedance-recalc` | — | done | — |
| `grs-stackup-section` | — | done | — |
| `design-log-dec066` | — | done | — |
| `jlcpcb-mfg-cross-refs` | — | done | — |
| `am-stackup-simplify` | — | done | `grs-stackup-section` |
| `ctl-stackup-simplify` | — | done | `grs-stackup-section` |
| `enc-stackup-simplify` | — | done | `grs-stackup-section` |
| `ext-stackup-simplify` | — | done | `grs-stackup-section` |
| `jm-stackup-simplify` | — | done | `grs-stackup-section` |
| `pm-stackup-simplify` | — | done | `grs-stackup-section` |
| `ref-stackup-simplify` | — | done | `grs-stackup-section` |
| `rot-stackup-simplify` | — | done | `grs-stackup-section` |
| `sta-stackup-simplify` | — | done | `grs-stackup-section` |
| `usm-stackup-simplify` | — | done | `grs-stackup-section` |
| `bulk-caps-per-power-source-or-conversion` | — | done | — |
| `ctl-l02-refdes-gap` | — | done | — |
| `enc-cpld-spare-pins-rule` | — | done | — |
| `jtag-pin1-silkscreen-grs` | — | done | — |
| `jtag-integrity-resistor-value-reconcile` | — | done | — |
| `mcp23017-gpb7-silicon-fixed-review` | — | done | — |
| `rot-i2c-residual-removal` | — | done | — |
| `consolidate-design-spec-content` | [consolidate-design-spec-content.md](consolidate-design-spec-content.md) | pending | `enc-connector-review-pre-pcb`, `review-clean-passes-gate` |
| `usm-spdt-switch-floating-review` | — | done | — |
| `am-button-review-production` | — | done | — |
| `ctl-t1-tdk-a120-component-analysis` | — | done | — |
| `ctl-t1-tdk-topology-confirm` | — | done | — |
| `ctl-t1-tdk-library-import` | — | done | — |
| `ctl-t1-bourns-component-analysis` | — | ~~done~~ (superseded by TDK decision) | `ctl-t1-transformer-decision` |
| `ctl-t1-coilcraft-v2-review` | [ctl-t1-coilcraft-v2-review.md](ctl-t1-coilcraft-v2-review.md) | **blocked** (v2.0) | `ctl-t1-transformer-decision` |
| `tps25751-i2c-review` | — | done | — |
| `rename-sys-reset-n` | — | done | — |
