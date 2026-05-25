-- Enigma-NG Todo Dependencies Seed
-- Run this after todos.sql. PRAGMA foreign_keys OFF/ON allows deps that reference done todos
-- which are inserted into todos table with status 'done' but may not have a row yet if filtered.

PRAGMA foreign_keys = OFF;
INSERT OR IGNORE INTO todo_deps (todo_id, depends_on) VALUES
-- rotor chain
('rotor-power-analysis-ministack',  'rotor-variant-refdes-schematic'),
('rotor-esd-tvs',                   'rotor-variant-refdes-schematic'),
-- full-pn-review prerequisites
('full-pn-review',              'connector-thermal-verification'),
('full-pn-review',              'extension-mechanical-usage'),
('full-pn-review',              'battery-connector-final-review'),
('full-pn-review',              'ctlh1-deferred'),
('full-pn-review',              'rotor-esd-tvs'),
('full-pn-review',              'coupon-testing-review'),
('full-pn-review',              'am-button-review-production'),
-- footprint gated by full-pn-review
('footprint-requests-pending',  'full-pn-review'),
-- coupon-testing-review needs extension architecture first
('coupon-testing-review',       'extension-mechanical-usage'),
-- software deferrals need deep reviews + prototype hardware
('rerun-deep-reviews',          'prototype-pcb-manufacturing'),
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
-- DA actions
('da-01',                       'prototype-system-complete'),
('da-02',                       'prototype-system-complete'),
('naming-convention-sweep',     'prototype-system-complete'),
('da-04',                       'prototype-system-complete'),
-- compliance-testing
('compliance-testing',          'prototype-pcb-manufacturing'),
('compliance-testing',          'da-01'),
('compliance-testing',          'da-02'),
('compliance-testing',          'naming-convention-sweep'),
('compliance-testing',          'da-04'),
('compliance-testing',          'emc-testing'),
('compliance-testing',          'environmental-testing'),
('compliance-testing',          'security-testing'),
-- bom-pre-prototype-check
('bom-pre-prototype-check',     'full-pn-review'),
('bom-pre-prototype-check',     'interim-electronics-review-3'),
('bom-pre-prototype-check',     'consolidate-design-spec-content'),
-- prototype-pcb-manufacturing
('prototype-pcb-manufacturing', 'review-mounting-holes'),
('prototype-pcb-manufacturing', 'interim-electronics-review-3'),
('prototype-pcb-manufacturing', 'bom-pre-prototype-check'),
('prototype-pcb-manufacturing', 'enc-connector-review-pre-pcb'),
-- bom-pre-production-check
('bom-pre-production-check',    'bom-pre-prototype-check'),
('bom-pre-production-check',    'prototype-system-complete'),
('bom-pre-production-check',    'compliance-testing'),
('bom-pre-production-check',    'emc-testing'),
('bom-pre-production-check',    'environmental-testing'),
('bom-pre-production-check',    'security-testing'),
-- release-candidate-production
('release-candidate-production', 'rerun-deep-reviews'),
('release-candidate-production', 'bom-pre-production-check'),
('release-candidate-production', 'prototype-system-complete'),
('release-candidate-production', 'compliance-testing'),
('release-candidate-production', 'interim-electronics-review-4'),
-- interim-electronics-review-1
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
('interim-electronics-review-1', 'tps25751-i2c-review'),
-- consolidate-design-spec-content
('consolidate-design-spec-content', 'enc-connector-review-pre-pcb'),
('consolidate-design-spec-content', 'review-clean-passes-gate'),
-- system-config-variants-diagrams
('system-config-variants-diagrams', 'prototype-pcb-manufacturing'),
-- interim-electronics-review-2
('interim-electronics-review-2', 'interim-electronics-review-1'),
('interim-electronics-review-2', 'coupon-testing-review'),
('interim-electronics-review-2', 'review-mounting-holes'),
-- interim-electronics-review-3
('interim-electronics-review-3', 'interim-electronics-review-2'),
('interim-electronics-review-3', 'full-pn-review'),
('interim-electronics-review-3', 'footprint-requests-pending'),
-- interim-electronics-review-4
('interim-electronics-review-4', 'prototype-system-complete'),
('interim-electronics-review-4', 'compliance-testing'),
-- version-one-complete
('version-one-complete',        'naming-convention-sweep'),
('version-one-complete',        'release-candidate-production'),
('version-one-complete',        'version-1-documentation'),
-- review pass chain
('review-pass-7',             'jdb-board-rename'),
('review-pass-7',             'bypass-cap-audit-100nf'),
('review-pass-7',             'connector-stacking-height-review'),
('review-pass-7',             'bom-system-qty-audit'),
('review-pass-7',             'mh-refdes-standardise'),
('review-pass-7',             'jdb-fr-renumber'),
('review-pass-8',             'review-pass-7'),
('review-pass-8',             'ctl-t1-transformer-decision'),
('ctl-t1-transformer-decision', 'ctl-t1-wurth-datasheet-review'),
('review-pass-9',             'review-pass-8'),
('review-pass-10',            'review-pass-9'),
('review-pass-11',            'download-missing-3d-models'),
('review-pass-11',            'review-pass-10'),
('review-pass-11',            'copilot-dir-restructure'),
('review-pass-11',            'rename-sys-reset-n'),
('review-pass-12',            'review-pass-11'),
-- review-clean-passes-gate: *** add new review-pass-x dep here whenever a new pass is created ***
('review-clean-passes-gate',  'review-pass-7'),
('review-clean-passes-gate',  'review-pass-8'),
('review-clean-passes-gate',  'review-pass-9'),
('review-clean-passes-gate',  'review-pass-10'),
('review-clean-passes-gate',  'review-pass-11'),
('review-clean-passes-gate',  'review-pass-12'),
-- stackup-simplify sweep
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
-- ctl-t1-coilcraft-v2-review
('ctl-t1-coilcraft-v2-review', 'ctl-t1-transformer-decision'),
-- emc/environmental/security testing
('emc-testing',               'prototype-pcb-manufacturing'),
('environmental-testing',     'prototype-pcb-manufacturing'),
('security-testing',          'prototype-pcb-manufacturing'),
('security-testing',          'prototype-system-complete'),
-- version-1-documentation
('version-1-documentation',   'board-interconnect-diagram'),
('version-1-documentation',   'system-config-variants-diagrams'),
('version-1-documentation',   'release-candidate-production'),
('version-1-documentation',   'prototype-system-complete');
PRAGMA foreign_keys = ON;
