# Enigma-NG Project Todo List

> **Canonical deferred-work and open-action reference.** Updated as work progresses.
> See also `.copilot/plan.md` for current workstream status and `.copilot/agent-directives.md` for operational rules.
>
> **Per-todo detail files** are in `.copilot/todos/` (one `.md` file per active todo).
> Done todos are tracked here only — their detail files are moved to `.recycle-bin/` when closed.
>
> **Design Log Open Questions** are tracked separately in `design/Design_Log.md` under `## Open Questions`.
> Do not duplicate them here — that file is the authoritative source for formally raised design questions.

Last updated: 2026-05-16 (tps25751-i2c-review resolved DEC-075: Option C EEPROM + J6 debug header; M24512-RDW6TP added to BOM as U18; DR-PM-20/21/22 added; Maintenance_Guide §5 added)

---

## Summary Table

| ID | File | Status | Blocked By |
| --- | --- | --- | --- |
| `extension-mechanical-usage` | [extension-mechanical-usage.md](todos/extension-mechanical-usage.md) | pending | — |
| `coupon-testing-review` | [coupon-testing-review.md](todos/coupon-testing-review.md) | pending | `extension-mechanical-usage` |
| `battery-connector-final-review` | [battery-connector-final-review.md](todos/battery-connector-final-review.md) | **blocked** | awaiting supplier response |
| `general-pin-mapping-schematic-capture` | — | done | — |
| `rerun-deep-reviews` | [rerun-deep-reviews.md](todos/rerun-deep-reviews.md) | pending | `prototype-pcb-manufacturing` |
| `ctlh1-deferred` | — | done | — |
| `rotor-power-analysis-ministack` | — | done | — |
| `rotor-esd-tvs` | — | done | — |
| `rotor-variant-refdes-schematic` | — | done | — |
| `rotor-refdes-reallocate` | — | done | — |
| `production-folder` | — | done | — |
| `grs-production-link` | — | done | — |
| `display-addon-board` | [display-addon-board.md](todos/display-addon-board.md) | **blocked** (v2.0) | — |
| `cpld-production-replacement` | [cpld-production-replacement.md](todos/cpld-production-replacement.md) | **blocked** (v2.0) | — |
| `connector-thermal-verification` | — | done | — |
| `full-pn-review` | [full-pn-review.md](todos/full-pn-review.md) | pending | `extension-mechanical-usage`, `battery-connector-final-review`, `coupon-testing-review`, `am-button-review-production` |
| `footprint-requests-pending` | [footprint-requests-pending.md](todos/footprint-requests-pending.md) | pending | `full-pn-review` |
| `bom-func-notes-sweep` | — | done | — |
| `m25-m3-dec-exception` | — | done | — |
| `rotor-shaft-diameter` | [rotor-shaft-diameter.md](todos/rotor-shaft-diameter.md) | pending | `prototype-pcb-manufacturing`, `ltc3350-telemetry`, `cpld-timing-load` |
| `rotor-rolling-element` | [rotor-rolling-element.md](todos/rotor-rolling-element.md) | pending | `prototype-pcb-manufacturing`, `ltc3350-telemetry`, `cpld-timing-load` |
| `rotor-alloy-grade` | [rotor-alloy-grade.md](todos/rotor-alloy-grade.md) | pending | `prototype-pcb-manufacturing`, `ltc3350-telemetry`, `cpld-timing-load` |
| `rotor-shaft-mechanism` | [rotor-shaft-mechanism.md](todos/rotor-shaft-mechanism.md) | pending | `prototype-pcb-manufacturing`, `ltc3350-telemetry`, `cpld-timing-load` |
| `display-aperture` | [display-aperture.md](todos/display-aperture.md) | **blocked** (v2.0) | — |
| `system-assembly-harnesses` | [system-assembly-harnesses.md](todos/system-assembly-harnesses.md) | pending | `prototype-pcb-manufacturing`, `ltc3350-telemetry`, `cpld-timing-load` |
| `system-assembly-connectors` | [system-assembly-connectors.md](todos/system-assembly-connectors.md) | pending | `prototype-pcb-manufacturing`, `ltc3350-telemetry`, `cpld-timing-load` |
| `ltc3350-telemetry` | [ltc3350-telemetry.md](todos/ltc3350-telemetry.md) | pending | `rerun-deep-reviews`, `prototype-pcb-manufacturing` |
| `cpld-timing-load` | [cpld-timing-load.md](todos/cpld-timing-load.md) | pending | `rerun-deep-reviews`, `prototype-pcb-manufacturing` |
| `da-01` | — | done | — |
| `da-02` | — | done | — |
| `naming-convention-sweep` | — | done | — |
| `da-04` | — | done | — |
| `compliance-testing` | [compliance-testing.md](todos/compliance-testing.md) | pending | `prototype-pcb-manufacturing`, `emc-testing`, `environmental-testing`, `security-testing` |
| `bom-pre-prototype-check` | [bom-pre-prototype-check.md](todos/bom-pre-prototype-check.md) | pending | `full-pn-review`, `interim-electronics-review-3` |
| `bom-pre-production-check` | [bom-pre-production-check.md](todos/bom-pre-production-check.md) | pending | `bom-pre-prototype-check`, `prototype-system-complete` |
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
| `jdb-ft232h-3v3-vregin` | [jdb-ft232h-3v3-vregin.md](todos/jdb-ft232h-3v3-vregin.md) | **blocked** (v2.0) | — |
| `ctl-t1-wurth-datasheet-review` | — | done | — |
| `ctl-t1-transformer-decision` | — | done | — |
| `review-mounting-holes` | — | done | — |
| `interim-electronics-review-1` | [interim-electronics-review-1.md](todos/interim-electronics-review-1.md) | pending | `review-pass-10`, `stackup-impedance-recalc`, `bulk-caps-per-power-source-or-conversion`, `ctl-l02-refdes-gap`, `enc-cpld-spare-pins-rule`, `jtag-pin1-silkscreen-grs`, `jtag-integrity-resistor-value-reconcile`, `mcp23017-gpb7-silicon-fixed-review`, `rot-i2c-residual-removal`, `consolidate-design-spec-content` |
| `interim-electronics-review-2` | [interim-electronics-review-2.md](todos/interim-electronics-review-2.md) | pending | `interim-electronics-review-1`, `coupon-testing-review`, `review-mounting-holes` |
| `interim-electronics-review-3` | [interim-electronics-review-3.md](todos/interim-electronics-review-3.md) | pending | `interim-electronics-review-2`, `full-pn-review`, `footprint-requests-pending` |
| `interim-electronics-review-4` | [interim-electronics-review-4.md](todos/interim-electronics-review-4.md) | pending | `prototype-system-complete`, `compliance-testing` |
| `prototype-pcb-manufacturing` | [prototype-pcb-manufacturing.md](todos/prototype-pcb-manufacturing.md) | pending | `review-mounting-holes`, `interim-electronics-review-3`, `bom-pre-prototype-check`, `enc-connector-review-pre-pcb` |
| `prototype-system-complete` | [prototype-system-complete.md](todos/prototype-system-complete.md) | pending | `rerun-deep-reviews`, `ltc3350-telemetry`, `cpld-timing-load`, `rotor-shaft-diameter`, `rotor-rolling-element`, `rotor-alloy-grade`, `rotor-shaft-mechanism`, `system-assembly-harnesses`, `system-assembly-connectors` |
| `release-candidate-production` | [release-candidate-production.md](todos/release-candidate-production.md) | pending | `rerun-deep-reviews`, `prototype-system-complete`, `compliance-testing`, `interim-electronics-review-4`, `bom-pre-production-check` |
| `version-one-complete` | [version-one-complete.md](todos/version-one-complete.md) | pending | `release-candidate-production`, `version-1-documentation` |
| `review-pass-7` | — | done | — |
| `review-pass-8` | — | done | — |
| `review-pass-9` | — | done | — |
| `review-pass-10` | [review-pass-10.md](todos/review-pass-10.md) | done | `review-pass-9` |
| `download-missing-3d-models` | [download-missing-3d-models.md](todos/download-missing-3d-models.md) | pending | — |
| `review-pass-11` | [review-pass-11.md](todos/review-pass-11.md) | pending | `download-missing-3d-models`, `review-pass-10` |
| `ascii-to-mermaid-diagrams` | — | done | — |
| `board-interconnect-diagram` | — | done | — |
| `system-config-variants-diagrams` | [system-config-variants-diagrams.md](todos/system-config-variants-diagrams.md) | pending | — |
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
| `version-1-documentation` | [version-1-documentation.md](todos/version-1-documentation.md) | pending | `board-interconnect-diagram`, `system-config-variants-diagrams`, `ctl-component-diagram`, `pm-component-diagram`, `sta-component-diagram`, `rotor-component-diagram`, `ext-component-diagram`, `ref-component-diagram`, `enc-component-diagram`, `jm-component-diagram`, `usm-component-diagram`, `am-component-diagram`, `release-candidate-production`, `prototype-system-complete` |
| `emc-testing` | [emc-testing.md](todos/emc-testing.md) | pending | `prototype-pcb-manufacturing` |
| `environmental-testing` | [environmental-testing.md](todos/environmental-testing.md) | pending | `prototype-pcb-manufacturing` |
| `security-testing` | [security-testing.md](todos/security-testing.md) | pending | `prototype-pcb-manufacturing`, `prototype-system-complete` |
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
| `consolidate-design-spec-content` | [consolidate-design-spec-content.md](todos/consolidate-design-spec-content.md) | pending | `enc-connector-review-pre-pcb` |
| `usm-spdt-switch-floating-review` | — | done | — |
| `am-button-review-production` | — | done | — |
| `ctl-t1-tdk-a120-component-analysis` | — | done | — |
| `ctl-t1-tdk-topology-confirm` | — | done | — |
| `ctl-t1-tdk-library-import` | — | done | — |
| `ctl-t1-bourns-component-analysis` | — | ~~done~~ (superseded by TDK decision) | `ctl-t1-transformer-decision` |
| `ctl-t1-coilcraft-v2-review` | [ctl-t1-coilcraft-v2-review.md](todos/ctl-t1-coilcraft-v2-review.md) | **blocked** (v2.0) | `ctl-t1-transformer-decision` |
| `tps25751-i2c-review` | [tps25751-i2c-review.md](todos/tps25751-i2c-review.md) | **done** | Option C implemented: M24512 EEPROM U18 + J6 debug header; DEC-075; DR-PM-20/21/22 |
| `rename-sys-reset-n` | [rename-sys-reset-n.md](todos/rename-sys-reset-n.md) | done | — |

---

## Agent SQL

At session start, run these INSERT statements to reconstruct the `todos` and `todo_deps` tracking tables.
Use `INSERT OR IGNORE` to make the script idempotent (re-runnable without error).
**Note:** The `todo_deps` INSERT must be wrapped with `PRAGMA foreign_keys = OFF/ON` because some
dependencies reference done todos that are not inserted into the `todos` table (done todos are omitted to keep the table lean).

### Todos

```sql
INSERT OR IGNORE INTO todos (id, title, status) VALUES
-- Open Workstreams
('extension-mechanical-usage',        'Extension interconnect architecture review',    'pending'),
('coupon-testing-review',             'Board-level coupon & PAS test coverage',        'pending'),
('battery-connector-final-review',    'Battery connector final review',                'blocked'),
('general-pin-mapping-schematic-capture', 'General pin mapping / schematic capture',  'done'),
('rerun-deep-reviews',                'Final pre-V1 deep review cycle',               'pending'),
-- Electronics Deferrals
('ctlh1-deferred',                    'Controller CTL-H1 deferred finding',           'done'),
('rotor-power-analysis-ministack',    'Recalculate Rotor Board_Layout §7 power analysis for mini-stack (max 5 rotors per stack)', 'done'),
('rotor-esd-tvs',                     'Rotor ESD TVS (PRTR5V0U10AZ) sourcing',       'done'),
('rotor-variant-refdes-schematic',    'Rotor variant U3/U4 KiCAD DNF approach',       'done'),
('rotor-refdes-reallocate',           'Rotor RefDes gap removal: R2-R7 -> R1-R6',    'done'),
('production-folder',                 'Create design/Production/ folder with JLCPCB constraints doc',  'done'),
('grs-production-link',               'Update GRS to reference design/Production/ folder',             'done'),
('display-addon-board',               'Display add-on board (v2.0)',                  'blocked'),
('cpld-production-replacement',       'CPLD production replacement review (v2.0)',    'blocked'),
('connector-thermal-verification',    'Connector thermal/current derating',           'done'),
('full-pn-review',                    'Full supplier PN sweep pre-schematic',         'pending'),
('footprint-requests-pending',        'Outstanding footprint requests / downloads',   'pending'),
('bom-func-notes-sweep',              'BOM function notes conformity sweep',          'done'),
('m25-m3-dec-exception',              'M2.5 mounting hole DEC exception for daughterboards', 'done'),
-- Mechanical Deferrals
('rotor-shaft-diameter',              'Rotor PCB shaft hole diameter',                'pending'),
('rotor-rolling-element',             'Rotor rolling element diameter spec',          'pending'),
('rotor-alloy-grade',                 'Rotor disc alloy grade selection',             'pending'),
('rotor-shaft-mechanism',             'Rotor shaft retention mechanism',              'pending'),
('display-aperture',                  'Main enclosure display aperture (v2.0)',       'blocked'),
('system-assembly-harnesses',         'System Assembly harness definitions',          'pending'),
('system-assembly-connectors',        'System Assembly connector list',               'pending'),
-- Software Deferrals
('ltc3350-telemetry',                 'LTC3350 I2C telemetry Linux driver',           'pending'),
('cpld-timing-load',                  'CPLD timing & load characterisation',          'pending'),
-- Standards & Certification
('da-01',                             'DA-01: Coupon ESD protection requirement',     'done'),
('da-02',                             'DA-02: Classroom deployment ESD policy',       'done'),
('naming-convention-sweep',           'Naming consistency sweep: PM dock / Stator dock', 'done'),
('da-04',                             'DA-04: Consolidated BOM PM component update',  'done'),
('compliance-testing',                'Environmental and EMC compliance testing',     'pending'),
('emc-testing',                       'EMC testing',                                   'pending'),
('environmental-testing',             'Environmental testing',                         'pending'),
('security-testing',                  'Security testing',                              'pending'),
('bom-pre-prototype-check',           'BOM verification gate 1 (pre-prototype)',      'pending'),
('bom-pre-production-check',          'BOM verification gate 2 (pre-production)',     'pending'),
-- Pass 6 Deferred Items
('jdb-board-rename',                  'JDB board rename to JTAG Module',              'done'),
('bypass-cap-audit-100nf',            '100nF bypass cap DigiKey PN audit',            'done'),
('reset-n-prefix-decision',           'RESET_N net name prefix decision',             'done'),
('connector-stacking-height-review',  'ERF8/ERM8 stacking height review',             'done'),
('plugboard-assembly-spec',           'Plugboard Assembly specification',              'done'),
('enc-connector-review-pre-pcb',      'ENC connector review pre-PCB manufacturing',   'done'),
('bom-system-qty-audit',              'Consolidated BOM system quantity audit',        'done'),
('mh-refdes-standardise',             'Mounting hole RefDes standardisation',         'done'),
('jdb-standoff-height',               'JDB standoff height and DF40 BtB connector',   'done'),
('jdb-fr-renumber',                   'JDB FR renumbering after FR-02/03 collapse',   'done'),
('jdb-ft232h-3v3-vregin',             'FT232H Rev C 3V3 VREGIN (v2.0)',              'blocked'),
('ctl-t1-wurth-datasheet-review',     'Wurth 750318938 datasheet review',             'done'),
('ctl-t1-transformer-decision',       'CTL T1 transformer selection decision',        'done'),
-- Project Milestones
('review-mounting-holes',             'Mounting hole verification per board',         'done'),
('interim-electronics-review-1',      'Review gate 1: pass 3 fixes verified',        'pending'),
('interim-electronics-review-2',      'Review gate 2: post-coupon review',           'pending'),
('interim-electronics-review-3',      'Review gate 3: post-schematic / pre-prototype', 'pending'),
('interim-electronics-review-4',      'Review gate 4: pre-production run',           'pending'),
('prototype-pcb-manufacturing',       'Prototype PCB manufacturing (JLCPCB)',        'pending'),
('prototype-system-complete',         'Prototype system verification complete',       'pending'),
('release-candidate-production',      'Release candidate production manufacturing',  'pending'),
('version-one-complete',              'Version 1.0 complete',                        'pending'),
('review-pass-7',                     'Design review pass 7',                        'done'),
('review-pass-8',                     'Design review pass 8',                        'done'),
('review-pass-9',                     'Design review pass 9',                        'done'),
('review-pass-10',                    'Design review pass 10',                       'done'),
('download-missing-3d-models',        'Download remaining 3D models for library parts', 'pending'),
('review-pass-11',                    'Design review pass 11',                       'pending'),
-- Documentation improvements
('ascii-to-mermaid-diagrams',         'Replace ASCII flow/block diagrams with Mermaid fenced blocks', 'done'),
-- Mermaid Diagrams
('board-interconnect-diagram',        'block-beta board interconnect diagram in Boards_Overview.md',            'done'),
('system-config-variants-diagrams',   'flowchart TD system config variants in System_Architecture.md',          'pending'),
('version-1-documentation',           'Version 1.0 documentation package',                                      'pending'),
('ctl-component-diagram',             'flowchart TD CTL circuit component diagram in Controller/Design_Spec.md',   'done'),
('pm-component-diagram',              'flowchart TD PM circuit component diagram in Power_Module/Design_Spec.md',  'done'),
('sta-component-diagram',             'flowchart TD STA circuit component diagram in Stator/Design_Spec.md',      'done'),
('rotor-component-diagram',           'flowchart TD Rotor circuit component diagram in Rotor/Design_Spec.md',     'done'),
('ext-component-diagram',             'flowchart TD EXT circuit component diagram in Extension/Design_Spec.md',   'done'),
('ref-component-diagram',             'flowchart TD REF circuit component diagram in Reflector/Design_Spec.md',   'done'),
('enc-component-diagram',             'flowchart TD ENC circuit component diagram in Encoder/Design_Spec.md',     'done'),
('jm-component-diagram',              'flowchart TD JM circuit component diagram in JTAG_Module/Design_Spec.md',  'done'),
('usm-component-diagram',             'flowchart TD USM circuit component diagram in User_Settings_Module/Design_Spec.md', 'done'),
('am-component-diagram',              'flowchart TD AM circuit component diagram in Actuation_Module/Design_Spec.md',      'done'),
-- Review Pass 8 new todos
('stackup-impedance-recalc',                  'Select optimal JLCPCB stackup based on impedance-controlled trace width manufacturability', 'done'),
('bulk-caps-per-power-source-or-conversion',  'Bulk decoupling at every power source and conversion point',                                'done'),
('ctl-l02-refdes-gap',                        'Fix Controller board RefDes numbering gap',                                                 'done'),
('enc-cpld-spare-pins-rule',                  'Add CPLD spare-pins rule to review agent-directives',                                       'done'),
('jtag-pin1-silkscreen-grs',                  'Add pin-1 silkscreen marker requirement to GRS',                                            'done'),
('jtag-integrity-resistor-value-reconcile',   'Reconcile JTAG termination resistor values across all boards',                              'done'),
('mcp23017-gpb7-silicon-fixed-review',        'Review and fix MCP23017 GPB7 silicon-fixed output-only pin issue',                         'done'),
('rot-i2c-residual-removal',                  'Remove residual I2C references from Rotor design',                                          'done'),
('consolidate-design-spec-content',           'Consolidate and normalise all Design Spec content',                                         'pending'),
('usm-spdt-switch-floating-review',           'Review USM SPDT switch floating pin concern',                                               'done'),
('am-button-review-production',               'Review Actuation Module buttons for production version',                                     'done'),
-- T1 transformer analysis todos
('ctl-t1-bourns-component-analysis',          'Analyse supporting component changes for Bourns POE060-FD20120S T1 replacement',             'done'),  -- superseded by TDK decision
('ctl-t1-coilcraft-v2-review',                'v2: Review Coilcraft POE600F-12L production readiness',                                     'blocked'),
('tps25751-i2c-review',                      'Review TPS25751 I2C connectivity for runtime PDO configuration',                             'blocked'),
('rename-sys-reset-n',                       'Rename SYS_RESET_N signal to CPLD_RESET_N across all design files',                          'done'),
('ctl-t1-tdk-a120-component-analysis',        'Analyse supporting component changes for TDK B82806D0060A120 T1 option (12V)',               'done'),
('ctl-t1-tdk-library-import',                 'Import TDK B82806D footprint zip and add 3D model to legacy library',                       'done'),
('ctl-t1-tdk-topology-confirm',               'Contact TDK apps engineering — B82806D0060A120 topology confirmation',                      'done'),
-- Stackup consolidation sweep (grs-stackup-section done; simplify passes pending)
('grs-stackup-section',                        'Add GRS §2.3 PCB Stackup Definitions',                                                         'done'),
('design-log-dec066',                          'Append DEC-066 to Design_Log.md',                                                              'done'),
('jlcpcb-mfg-cross-refs',                      'Update JLCPCB_Manufacturing.md §1.1 and §1.2 cross-refs',                                      'done'),
('am-stackup-simplify',                        'Simplify AM DR-AM-01, DR-AM-09, remove blockquote',                                            'done'),
('ctl-stackup-simplify',                       'Simplify CTL §9.2 — remove physical table, add GRS ref',                                       'done'),
('enc-stackup-simplify',                       'Simplify ENC §9; add GRS §2.3.1 reference',                                                    'done'),
('ext-stackup-simplify',                       'Simplify EXT §4 + fix DR-EXT-01 stale code',                                                   'done'),
('jm-stackup-simplify',                        'Simplify JM §5 + fix DR-JM-01 stale code',                                                     'done'),
('pm-stackup-simplify',                        'Update PM DR-PM-13 and §1; add GRS §2.3.3 reference',                                          'done'),
('ref-stackup-simplify',                       'Simplify REF §6; add GRS §2.3.1 reference',                                                    'done'),
('rot-stackup-simplify',                       'Simplify ROT §4; add GRS §2.3.1 reference',                                                    'done'),
('sta-stackup-simplify',                       'Simplify STA §7; add GRS §2.3.1 reference',                                                    'done'),
('usm-stackup-simplify',                       'Simplify USM §8; add GRS §2.3.1 reference',                                                    'done');
```

### Dependencies

```sql
PRAGMA foreign_keys = OFF;
INSERT OR IGNORE INTO todo_deps (todo_id, depends_on) VALUES
-- rotor chain
('rotor-power-analysis-ministack',  'rotor-variant-refdes-schematic'),
('rotor-esd-tvs',                   'rotor-variant-refdes-schematic'),
-- full-pn-review prerequisites (all 6 must complete first)
('full-pn-review',              'connector-thermal-verification'),
('full-pn-review',              'extension-mechanical-usage'),
('full-pn-review',              'battery-connector-final-review'),
('full-pn-review',              'ctlh1-deferred'),
('full-pn-review',              'rotor-esd-tvs'),
('full-pn-review',              'coupon-testing-review'),
-- footprint gated by full-pn-review
('footprint-requests-pending',  'full-pn-review'),
-- coupon-testing-review needs extension architecture first
('coupon-testing-review',       'extension-mechanical-usage'),
-- rerun-deep-reviews runs after prototype boards exist; prototype-system-complete depends on it
('rerun-deep-reviews',          'prototype-pcb-manufacturing'),
-- software deferrals need deep reviews + prototype hardware
('ltc3350-telemetry',           'rerun-deep-reviews'),
('ltc3350-telemetry',           'prototype-pcb-manufacturing'),
('cpld-timing-load',            'rerun-deep-reviews'),
('cpld-timing-load',            'prototype-pcb-manufacturing'),
-- mechanical deferrals need prototype hardware + both SW deferrals
('rotor-shaft-diameter',        'prototype-pcb-manufacturing'),
('rotor-shaft-diameter',        'ltc3350-telemetry'),
('rotor-shaft-diameter',        'cpld-timing-load'),
('rotor-rolling-element',       'prototype-pcb-manufacturing'),
('rotor-rolling-element',       'ltc3350-telemetry'),
('rotor-rolling-element',       'cpld-timing-load'),
('rotor-alloy-grade',           'prototype-pcb-manufacturing'),
('rotor-alloy-grade',           'ltc3350-telemetry'),
('rotor-alloy-grade',           'cpld-timing-load'),
('rotor-shaft-mechanism',       'prototype-pcb-manufacturing'),
('rotor-shaft-mechanism',       'ltc3350-telemetry'),
('rotor-shaft-mechanism',       'cpld-timing-load'),
('system-assembly-harnesses',   'prototype-pcb-manufacturing'),
('system-assembly-harnesses',   'ltc3350-telemetry'),
('system-assembly-harnesses',   'cpld-timing-load'),
('system-assembly-connectors',  'prototype-pcb-manufacturing'),
('system-assembly-connectors',  'ltc3350-telemetry'),
('system-assembly-connectors',  'cpld-timing-load'),
-- prototype-system-complete needs all SW and Mech deferrals + rerun-deep-reviews
('prototype-system-complete',   'rerun-deep-reviews'),
('prototype-system-complete',   'ltc3350-telemetry'),
('prototype-system-complete',   'cpld-timing-load'),
('prototype-system-complete',   'rotor-shaft-diameter'),
('prototype-system-complete',   'rotor-rolling-element'),
('prototype-system-complete',   'rotor-alloy-grade'),
('prototype-system-complete',   'rotor-shaft-mechanism'),
('prototype-system-complete',   'system-assembly-harnesses'),
('prototype-system-complete',   'system-assembly-connectors'),
('prototype-system-complete',   'plugboard-assembly-spec'),
-- DA actions depend on prototype-system-complete
('da-01',                       'prototype-system-complete'),
('da-02',                       'prototype-system-complete'),
('naming-convention-sweep',     'prototype-system-complete'),
('da-04',                       'prototype-system-complete'),
-- compliance-testing requires prototype boards (and all DA actions, all done, kept for reference)
('compliance-testing',          'prototype-pcb-manufacturing'),
('compliance-testing',          'da-01'),
('compliance-testing',          'da-02'),
('compliance-testing',          'naming-convention-sweep'),
('compliance-testing',          'da-04'),
-- bom-pre-prototype-check gates
('bom-pre-prototype-check',     'full-pn-review'),
('bom-pre-prototype-check',     'interim-electronics-review-3'),
-- prototype-pcb-manufacturing depends on review-mounting-holes, interim-electronics-review-3, bom-pre-prototype-check, enc-connector-review-pre-pcb
('prototype-pcb-manufacturing', 'review-mounting-holes'),
('prototype-pcb-manufacturing', 'interim-electronics-review-3'),
('prototype-pcb-manufacturing', 'bom-pre-prototype-check'),
('prototype-pcb-manufacturing', 'enc-connector-review-pre-pcb'),
-- bom-pre-production-check gates
('bom-pre-production-check',    'bom-pre-prototype-check'),
('bom-pre-production-check',    'prototype-system-complete'),
-- release-candidate-production depends on rerun-deep-reviews, bom-pre-production-check, prototype-system-complete, compliance-testing, interim-electronics-review-4
('release-candidate-production', 'rerun-deep-reviews'),
('release-candidate-production', 'bom-pre-production-check'),
-- interim-electronics-review-1 gates
('interim-electronics-review-1', 'rotor-refdes-reallocate'),
('interim-electronics-review-1', 'review-pass-10'),
('interim-electronics-review-1', 'bulk-caps-per-power-source-or-conversion'),
('interim-electronics-review-1', 'ctl-l02-refdes-gap'),
('interim-electronics-review-1', 'enc-cpld-spare-pins-rule'),
('interim-electronics-review-1', 'jtag-pin1-silkscreen-grs'),
('interim-electronics-review-1', 'jtag-integrity-resistor-value-reconcile'),
('interim-electronics-review-1', 'mcp23017-gpb7-silicon-fixed-review'),
('interim-electronics-review-1', 'rot-i2c-residual-removal'),
('interim-electronics-review-1', 'consolidate-design-spec-content'),
('interim-electronics-review-1', 'usm-spdt-switch-floating-review'),
-- consolidate-design-spec-content gates
('consolidate-design-spec-content', 'enc-connector-review-pre-pcb'),
-- am-button-review-production gates full-pn-review
('full-pn-review', 'am-button-review-production'),
-- interim-electronics-review-2 gates
('interim-electronics-review-2', 'interim-electronics-review-1'),
('interim-electronics-review-2', 'coupon-testing-review'),
('interim-electronics-review-2', 'review-mounting-holes'),
-- interim-electronics-review-3 gates
('interim-electronics-review-3', 'interim-electronics-review-2'),
('interim-electronics-review-3', 'full-pn-review'),
('interim-electronics-review-3', 'footprint-requests-pending'),
-- interim-electronics-review-4 gates
('interim-electronics-review-4', 'prototype-system-complete'),
('interim-electronics-review-4', 'compliance-testing'),
-- release-candidate-production depends on prototype-system-complete + compliance-testing + interim-electronics-review-4
('release-candidate-production', 'prototype-system-complete'),
('release-candidate-production', 'compliance-testing'),
('release-candidate-production', 'interim-electronics-review-4'),
-- version-one-complete needs naming-convention-sweep (done) + release candidate
('version-one-complete',        'naming-convention-sweep'),
('version-one-complete',        'release-candidate-production'),
-- Pass 6 deferred items -> review-pass-7
('review-pass-7', 'jdb-board-rename'),
('review-pass-7', 'bypass-cap-audit-100nf'),
('review-pass-7', 'connector-stacking-height-review'),
-- bom-system-qty-audit blocks review-pass-7
('review-pass-7', 'bom-system-qty-audit'),
-- mh-refdes-standardise blocks review-pass-7
('review-pass-7', 'mh-refdes-standardise'),
-- jdb-fr-renumber blocks review-pass-7
('review-pass-7', 'jdb-fr-renumber'),
-- review-pass-7 -> review-pass-8 -> review-pass-9 -> review-pass-10 -> interim-electronics-review-1
('review-pass-8',             'review-pass-7'),
-- T1 decision blocks review-pass-8; Wurth datasheet must be reviewed before T1 decision
('review-pass-8',                   'ctl-t1-transformer-decision'),
('ctl-t1-transformer-decision',     'ctl-t1-wurth-datasheet-review'),
('review-pass-9',             'review-pass-8'),
('review-pass-10',            'review-pass-9'),
('review-pass-11',            'download-missing-3d-models'),
('review-pass-11',            'review-pass-10'),
-- stackup-simplify sweep gates on grs-stackup-section (done)
('am-stackup-simplify',  'grs-stackup-section'),
('ctl-stackup-simplify', 'grs-stackup-section'),
('enc-stackup-simplify', 'grs-stackup-section'),
('ext-stackup-simplify', 'grs-stackup-section'),
('jm-stackup-simplify',  'grs-stackup-section'),
('pm-stackup-simplify',  'grs-stackup-section'),
('ref-stackup-simplify', 'grs-stackup-section'),
('rot-stackup-simplify', 'grs-stackup-section'),
('sta-stackup-simplify', 'grs-stackup-section'),
('usm-stackup-simplify', 'grs-stackup-section'),
-- ctl-t1-coilcraft-v2-review gates
('ctl-t1-coilcraft-v2-review', 'ctl-t1-transformer-decision'),
-- tps25751-i2c-review: blocked on architectural decision; must resolve before review-pass-11
('interim-electronics-review-1', 'tps25751-i2c-review'),
-- rename-sys-reset-n should be done before review-pass-11
('review-pass-11',               'rename-sys-reset-n'),
-- emc/environmental testing need prototype hardware
('emc-testing',               'prototype-pcb-manufacturing'),
('environmental-testing',     'prototype-pcb-manufacturing'),
-- security-testing needs prototype hardware + full SW/HW implementation
('security-testing',          'prototype-pcb-manufacturing'),
('security-testing',          'prototype-system-complete'),
-- compliance-testing depends on all three testing phases
('compliance-testing',        'emc-testing'),
('compliance-testing',        'environmental-testing'),
('compliance-testing',        'security-testing'),
-- version-1-documentation depends on live diagrams + production manufacturing + full assembly testing
('version-1-documentation',   'board-interconnect-diagram'),
('version-1-documentation',   'system-config-variants-diagrams'),
('version-1-documentation',   'release-candidate-production'),
('version-1-documentation',   'prototype-system-complete'),
-- version-one-complete needs docs package + release candidate
('version-one-complete',      'version-1-documentation');
PRAGMA foreign_keys = ON;
```
