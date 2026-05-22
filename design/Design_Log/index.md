# Enigma-NG Design Decision Log

**Status:** Active
**Project:** Enigma-NG
**Author:** Izzyonstage & GitHub Copilot
**Version:** v.0.1.0
**Associated Hardware Revision:** Rev A
**Last Updated:** 2026-05-18

This file records key architectural and component decisions made during the design of the Enigma-NG system. Each entry captures the decision taken, the rationale behind it, the alternatives that were
considered, and any constraints or caveats that future designers should be aware of.

Entries are numbered sequentially as **DEC-NNN**. Where a decision supersedes a previous one, the earlier entry is updated with a cross-reference.

---

| DEC | Title | Date | Status | Summary |
| --- | ----- | ---- | ------ | ------- |
| [DEC-001](DEC-001_3v3-enig-used-throughout-3v3-system-removed-from-btb-interconnect.md) | 3V3_ENIG Used Throughout; 3V3_SYSTEM Removed from BtB Interconnect | 2025 | Obsolete - superseded by DEC-037 | The `3V3_SYSTEM` rail (sourced from the CM5 on the Controller Board) is not routed to the Power Module over the Link-... |
| [DEC-002](DEC-002_poe-option-a2-selected-coilcraft-poe600f-12ld.md) | PoE Option A2 Selected: Coilcraft POE600F-12LD | 2025 | Decided | The PoE transformer T2 uses a Coilcraft POE600F-12LD off-the-shelf ACF transformer (12V output, 60W, 200kHz, ≥1500Vrm... |
| [DEC-003](DEC-003_poe-output-12v-or-ing-priority-logic-required.md) | PoE Output 12V; OR-ing Priority Logic Required | 2025 | Decided | PoE outputs 12V (not 15V) into the OR-ing stage. |
| [DEC-004](DEC-004_supercap-charge-current-05a-under-poe.md) | Supercap Charge Current 0.5A Under PoE | 2025 | Superseded by DEC-029 (cell specification updated; 0.5A charge current constraint retained) | When running on PoE (802.3bt Type 4, 72W budget), the supercap charge current is reduced to 0.5A (vs. |
| [DEC-005](DEC-005_tps25980-efuse-replaces-tps259474l.md) | TPS25980 eFuse Replaces TPS259474L | 2025 | Decided | The input eFuse uses a TPS25980 (7A ILIM, silicon-fixed 16.9V OVLO) rather than the originally considered TPS259474L... |
| [DEC-006](DEC-006_stusb4500-negotiates-15v5a-75w.md) | STUSB4500 Negotiates 15V/5A (75W) | 2025 | Decided | The STUSB4500 standalone PD sink is programmed to negotiate 15V/5A (75W) from the wall adapter or USB-C PD source. |
| [DEC-007](DEC-007_dual-interleaved-lmq61460-q1-5v-buck-12a.md) | Dual Interleaved LMQ61460-Q1 5V Buck (12A) | 2025 | Decided | Two LMQ61460-Q1 buck regulators are used in a dual interleaved configuration, providing a combined 12A output at 5V. |
| [DEC-008](DEC-008_tps25750-emulates-5v5a-pd-profile-to-cm5.md) | TPS25750 Emulates 5V/5A PD Profile to CM5 | 2025 | Superseded by DEC-012 | The TPS25750 PD emulator advertises a 5V/5A profile to the CM5 internal USB-C port. |
| [DEC-009](DEC-009_legacy-controller-probe-access-pin-14-reassigned-to-sw-led-ctrl.md) | Legacy Controller Probe-Access Pin 14 Reassigned to SW_LED_CTRL | 2025 (GND); superseded by final design (SW_LED_CTRL) | Decided | The legacy Controller probe-access concept pin 14 was initially reassigned from `3V3_SYSTEM` to
GND, following the re... |
| [DEC-010](DEC-010_inc-14-deferred-legacy-probe-access-esd-protection-post-prototype.md) | INC-14 DEFERRED: Legacy Probe-Access ESD Protection (Post-Prototype) | 2025 | Deferred - Accepted risk for prototype stage | ESD protection on the historical probe-access concept is deferred to post-prototype evaluation. |
| [DEC-011](DEC-011_all-power-rails-on-power-module-3v3-enig-serves-rotor-stack.md) | All Power Rails on Power Module; 3V3_ENIG Serves Rotor Stack | 2025 | ✔ RESOLVED | All power rails are generated on the Power Module. |
| [DEC-012](DEC-012_u4-tps25750-replaced-with-tps25751drefr-nrnd-resolution.md) | U4 TPS25750 Replaced with TPS25751DREFR (NRND Resolution) | 2026-04-03 | ✔ RESOLVED | Replace TPS25750 (NRND - Not Recommended for New Designs) with TPS25751DREFR (PD3.1 certified DRP controller, WQFN-38... |
| [DEC-013](DEC-013_l3-emi-inductor-changed-to-bourns-srp1265a-100m.md) | L3 EMI Inductor Changed to Bourns SRP1265A-100M | 2026-04-03 | ✔ RESOLVED | Replace Wurth 7447789100 with Bourns SRP1265A-100M as L3 (EMI DM Pi-filter inductor). |
| [DEC-014](DEC-014_controller-board-uses-erf8-female-on-both-btb-connectors-for-blind-mate-assembly.md) | Controller Board Uses ERF8 (Female) on Both BtB Connectors for Blind-Mate Assembly | 2026-04-04 | ✔ RESOLVED | Both BtB connectors on the Controller Board use the ERF8 female socket: J1 (Link-Alpha) uses ERF8-040-05.0-S-DV-K-TR... |
| [DEC-015](DEC-015_link-beta-connector-reduced-from-80-pin-to-40-pin-erf8-020-erm8-020.md) | LINK-BETA Connector Reduced from 80-pin to 40-pin (ERF8-020 / ERM8-020) | 2026-04-04 | ✔ RESOLVED | The LINK-BETA Board-to-Board connector is reduced from 80-pin (ERF8-040 / ERM8-040) to 40-pin
(ERF8-020-05.0-S-DV-K-T... |
| [DEC-016](DEC-016_jtag-controlled-impedance-and-series-termination.md) | JTAG Controlled Impedance and Series Termination | 2026-04-05 | ✔ ADOPTED | All JTAG signal traces on 4-layer and 6-layer PCBs are specified at 50 Ω controlled impedance
(0.127 mm / 5 mil trace... |
| [DEC-017](DEC-017_minimum-4-layer-stackup-for-all-non-controller-boards.md) | Minimum 4-Layer Stackup for All Non-Controller Boards | 2026-04-05 | ✔ ADOPTED | All PCBs in the Enigma-NG system shall use a minimum of 4-layer stackup (JLCPCB
JLC04161H-7628). |
| [DEC-018](DEC-018_connector-pinout-ownership-model.md) | Connector Pinout Ownership Model | 2026-04-05 | Adopted | Each multi-board connector interface shall have a single Definition Owner - the board whose
`Board_Layout.md` (or `De... |
| [DEC-019](DEC-019_poe-transformer-topology-acf-option-a-selected.md) | PoE Transformer Topology: ACF (Option A) Selected | 2026-04-05 | ✔ Adopted | The Power Module retains the Active Clamp Flyback (ACF) topology with the Coilcraft POE600F-12LD
transformer. |
| [DEC-020](DEC-020_gnd-chassis-rib-clearway-enig-bond.md) | GND_CHASSIS Rib Clearway ENIG Bond | 2026-04-08 | Accepted - 2026-04-08 | The 3.0mm rib clearway gaps between supercap cells shall have: |
| [DEC-021](DEC-021_supercapacitor-bank-upgrade-2x2-2s2p-2x3-2s3p.md) | Supercapacitor Bank Upgrade: 2x2 2S2P → 2x3 2S3P | 2026-04-08 | Superseded by DEC-029 (arrangement 2S3P retained; cell capacitance updated 22F → 25F Abracon) | The supercapacitor bank is upgraded from a 2x2 (4-cell, 2S2P) to a 2x3 (6-cell, 2S3P) arrangement,
with the inter-cel... |
| [DEC-022](DEC-022_jdb-ft232h-clock-source-dedicated-12mhz-smd-crystal-selected.md) | JDB FT232H Clock Source: Dedicated 12MHz SMD Crystal Selected | 2026-04-06 | Obsolete - superseded by DEC-037 | Dedicated 12MHz SMD passive crystal (Y1) on the JDB PCB. |
| [DEC-023](DEC-023_jdb-gnd-chassis-omitted-mounting-holes-tied-to-gnd.md) | JDB GND_CHASSIS Omitted; Mounting Holes Tied to GND | 2026-04-06 | Decided | The JTAG Daughterboard (JDB) does not implement a `GND_CHASSIS` net. |
| [DEC-024](DEC-024_jdb-is-complete-jtag-master-controller-jtag-lines-are-pass-through.md) | JDB is Complete JTAG Master; Controller JTAG Lines Are Pass-Through | 2026-04-06 | Decided | The JTAG Daughterboard (JDB) is the complete JTAG master. |
| [DEC-025](DEC-025_cm5-shutdown-mechanism-hardware-driven-ltc3350-software-support-deferred.md) | CM5 Shutdown Mechanism: Hardware-Driven; LTC3350 Software Support Deferred | 2026-04-09 | Deferred - Software PoC Stage | The final implementation of the CM5 graceful shutdown mechanism is hardware-driven via the
LTC3350 `/INTB` -> MIC1555... |
| [DEC-026](DEC-026_rotor-position-encoder-as5600-replaced-with-single-track-capacitive-encoder.md) | Rotor Position Encoder: AS5600 Replaced with Single-Track Capacitive Encoder | 2026-04-12 | Accepted | The AMS AS5600 magnetic encoder (originally specified in DR-ROT-03) is replaced with a
single-track absolute capaciti... |
| [DEC-027](DEC-027_rotor-position-readback-via-jtag-virtual-jtag-user0-udr.md) | Rotor Position Readback via JTAG Virtual JTAG (USER0 UDR) | 2026-04-12 | Accepted | The CPLD on each rotor must expose the effective rotor position (STGC-decoded position +
SW1 ring offset, mod N) via... |
| [DEC-028](DEC-028_split-dual-board-rotor-architecture.md) | Split dual-board rotor architecture | 2026-04-14 | Accepted | The rotor is split into two circular PCBs (Board A input side, Board B output side), each
Ø92mm, connected by four si... |
| [DEC-029](DEC-029_supercapacitor-hold-up-specification-25f-abracon-cells-2s4p-20-s-at-15w.md) | Supercapacitor Hold-Up Specification: 25F Abracon Cells, 2S4P, ≥20 s at 15W | 2026-04-14 | Accepted - 2026-04-14 | The supercapacitor hold-up minimum requirement is ≥20 seconds at a 15W shutdown load
(CM5 typical operating current:... |
| [DEC-030](DEC-030_5v-main-backup-switchover-transient-fix-r14-r30-c35.md) | 5V_MAIN Backup Switchover Transient Fix (R14, R30, C35) | 2026-04-14 | Accepted |  |
| [DEC-031](DEC-031_cm5-virtual-keyboard-key-injection-feature-architecture.md) | CM5 Virtual Keyboard (Key Injection) Feature Architecture | 2026-04-14 | Decided | Add three I²C expanders to the Stator board on the shared I²C-1 bus: |
| [DEC-032](DEC-032_settings-board-panel-mount-configuration-controls-with-cm5-override.md) | Settings Board: Panel-Mount Configuration Controls with CM5 Override | 2026-04-14 | Decided | 1. |
| [DEC-033](DEC-033_dsi1-display-connector-provision-for-optional-lid-touchscreen.md) | DSI1 Display Connector Provision for Optional Lid Touchscreen | 2026-04-14 | Decided | 1. |
| [DEC-034](DEC-034_switch-hardware-refresh-settings-board-toggle-discrete-rgb-led-ruggedized-pm-sw1.md) | Switch Hardware Refresh: Settings Board Toggle + Discrete RGB LED, Ruggedized PM SW1 | 2026-04-16 | Decided | 1. |
| [DEC-035](DEC-035_hid-keyboard-and-lightboard-use-a-40-position-qwerty-derived-layout-for-the-64-character-code-space.md) | HID Keyboard and Lightboard Use a 40-Position QWERTY-Derived Layout for the 64-Character Code Space | 2026-04-17 | Decided | 1. |
| [DEC-036](DEC-036_link-beta-former-monitor-pins-reallocated-as-grouped-power-rails.md) | LINK-BETA Former Monitor Pins Reallocated as Grouped Power Rails | 2026-04-18 | Decided | Retain the 40-pin LINK-BETA connector and apply this active allocation: |
| [DEC-037](DEC-037_link-beta-pin-map-regrouped-around-dedicated-jtag-and-i2c-guard-bands.md) | LINK-BETA Pin Map Regrouped Around Dedicated JTAG and I2C Guard Bands | 2026-04-18 | Decided | Adopt this LINK-BETA allocation as the active mapping: |
| [DEC-038](DEC-038_controller-centric-dock-architecture-replaces-legacy-link-alpha-link-beta-backplane.md) | Controller-Centric Dock Architecture Replaces Legacy Link-Alpha / Link-Beta Backplane | 2026-04-19 | Decided | #### 1. |
| [DEC-039](DEC-039_enclosure-connected-boards-use-gnd-chassis-daughterboards-are-exempt.md) | Enclosure-Connected Boards Use GND_CHASSIS; Daughterboards Are Exempt | 2026-04-20 | Decided | 1. |
| [DEC-040](DEC-040_diagnostics-banks-removed-from-active-design-specs-pending-coupon-review.md) | Diagnostics Banks Removed from Active Design Specs Pending Coupon Review | 2026-04-25 | Decided | 1. |
| [DEC-041](DEC-041_encoder-modules-use-epm570-with-digital-debounce-and-role-by-programming.md) | Encoder Modules Use EPM570 with Digital Debounce and Role-by-Programming | 2026-04-26 | Decided | 1. |
| [DEC-042](DEC-042_encoder-port-pin-8-carries-hid-local-enc-active-n.md) | Encoder Port Pin 8 Carries HID-Local `ENC_ACTIVE_N` | 2026-04-26 | Decided | 1. |
| [DEC-043](DEC-043_shared-actuation-module-replaces-direct-controller-servo-gpio.md) | Shared Actuation Module Replaces Direct Controller Servo GPIO | 2026-04-26 | Decided | 1. |
| [DEC-044](DEC-044_fdc2114-internal-oscillator-selected-clkin-gnd.md) | FDC2114 Internal Oscillator Selected (CLKIN → GND) | 2026-04-26 | Decided | Use the FDC2114 internal oscillator (CLKIN → GND). |
| [DEC-045](DEC-045_rotor-samtec-erm8erf8-connectors-require-esd-protection.md) | Rotor Samtec ERM8/ERF8 Connectors Require ESD Protection | 2026-04-28 | Decided | Add TVS/ESD protection to all Samtec ERM8/ERF8 connector interfaces on the Rotor Board. |
| [DEC-046](DEC-046_bypassdecoupling-capacitor-voltage-rating-50v-retained-on-all-non-pm-boards.md) | Bypass/Decoupling Capacitor Voltage Rating: 50V Retained on All Non-PM Boards | 2026-04-29 | Decided | Retain 50V-rated bypass and decoupling capacitors as the approved standard across all non-PM boards. |
| [DEC-047](DEC-047_or-ing-mosfet-corrected-to-csd17578q5a.md) | OR-ing MOSFET Corrected to CSD17578Q5A | 2025-07-05 | Decided | Replace CSD17483F4T with CSD17578Q5A (TI NexFET N-channel MOSFET): |
| [DEC-048](DEC-048_esd-protection-extended-to-host-side-rotor-facing-btb-connectors.md) | ESD Protection Extended to Host-Side Rotor-Facing BtB Connectors | 2026-04-30 | Approved | All Samtec ERM8/ERF8 connector faces on host boards that are exposed during live rotor swap require a TPD4E05U06QDQAR... |
| [DEC-049](DEC-049_rotor-internal-headers-renamed-to-j-convention-connector-count-updated-to-8-bom-unified.md) | Rotor Internal Headers Renamed to J-Convention; Connector Count Updated to 8; BOM Unified | 2026-05-01 | Accepted | The four internal rotor interconnect headers previously designated H_SW3, H_PWR, H_JTAG, and
H_SENS are renamed to J7... |
| [DEC-050](DEC-050_encoder-blade-terminal-refdes-corrected-from-bt-to-j-convention.md) | Encoder Blade Terminal RefDes Corrected from BT to J Convention | 2026-05-01 | Active | The 64 PCB spade blade terminals (Keystone 1285-ST) on the Encoder board have been
renamed from `BT1`-`BT64` to `J3`-... |
| [DEC-051](DEC-051_settings-board-renamed-to-user-settings-module-board-code-sbd-usm.md) | Settings Board Renamed to User Settings Module (Board Code SBD → USM) | 2026-05-02 | Active | The `Settings Board` is renamed to `User Settings Module` throughout all active design
documentation, the consolidate... |
| [DEC-052](DEC-052_variant-specific-fdc2114-refdes-use-ab-suffix-convention.md) | Variant-Specific FDC2114 RefDes Use A/B Suffix Convention | 2025-07-10 | Active | Variant-specific FDC2114 sensor components on the Rotor board are assigned RefDes with an A or B
suffix to indicate w... |
| [DEC-053](DEC-053_extension-port-connector-upgraded-from-bhr-20-vua-20-pin-to-2bhr-30-vua-30-pin.md) | Extension Port Connector Upgraded from BHR-20-VUA (20-pin) to 2BHR-30-VUA (30-pin) | 2025-07-10 | Active | Replace the Adam Tech BHR-20-VUA (20-pin 2x10) with the Adam Tech 2BHR-30-VUA (30-pin 2x15) on
all Extension Port ins... |
| [DEC-054](DEC-054_signal-net-renamed-pwr-but-pwr-but-n-active-low-suffix-conformance.md) | Signal Net Renamed: PWR_BUT → PWR_BUT_N (Active-Low Suffix Conformance) | 2026-07-11 | Active | The signal net `PWR_BUT` (the power key line from the Power Module to the CM5 PMIC dedicated
hardware input) is renam... |
| [DEC-055](DEC-055_f-108-system-wide-reference-designator-and-requirement-id-consecutive-renumbering.md) | F-108 System-Wide Reference Designator and Requirement ID Consecutive Renumbering | 2026-05-05 | Accepted | Renumber all affected component RefDes and FR/DR requirement IDs consecutively across all impacted
board Design_Spec... |
| [DEC-056](DEC-056_relocate-investigation-documents-to-board-owned-folders.md) | Relocate Investigation Documents to Board-Owned Folders |  |  | Move the two investigation documents out of `design/Electronics/Investigations/` and into the
folders of the boards t... |
| [DEC-057](DEC-057_daughterboard-mounting-hole-specification-and-standoff-bom-ownership.md) | Daughterboard Mounting Hole Specification and Standoff BOM Ownership | 2026-05-05 | Accepted | This is the single authoritative reference for mounting hole specification and standoff BOM
ownership across all boar... |
| [DEC-058](DEC-058_jdb-connector-upgrade-hat-headers-to-df40c-20-btb.md) | JDB Connector Upgrade: Hat-Headers to DF40C-20 BtB |  |  | Replace J1 + J2 hat-header connectors with a single Hirose DF40C-20DP-0.4V(51) 20-pin board-to-board plug on the JDB,... |
| [DEC-059](DEC-059_erm8erf8-stacking-height-confirmed-rotor-stack-assembly-specification-created.md) | ERM8/ERF8 Stacking Height Confirmed; Rotor Stack Assembly Specification Created |  |  | The `-05.0-` lead style designation in the selected parts: |
| [DEC-060](DEC-060_jtag-daughterboard-renamed-to-jtag-module-jdb-prefix-replaced-with-jm.md) | JTAG Daughterboard Renamed to JTAG Module; JDB Prefix Replaced with JM |  |  | The board is renamed from JTAG Daughterboard to JTAG Module with immediate
effect: |
| [DEC-061](DEC-061_pass-7-review-corrections-ctlstarotencamgrsstatus-updates.md) | Pass 7 Review Corrections: CTL/STA/ROT/ENC/AM/GRS/Status Updates |  | Draft` to `**Status:** In Review`, | Apply all eight corrections as described above. |
| [DEC-062](DEC-062_ctl-poe-t1-selection-tdk-b82806d0060a120-topology-acf-flyback-acf-forward.md) | CTL PoE T1 Selection: TDK B82806D0060A120; Topology ACF Flyback → ACF Forward |  |  | 1. |
| [DEC-063](DEC-063_ctl-poe-l1-selection-yageo-pa4343333nlt-acf-forward-output-inductor.md) | CTL PoE L1 Selection: Yageo PA4343.333NLT (ACF Forward Output Inductor) |  |  | L1 selected: Yageo PA4343.333NLT. |
| [DEC-064](DEC-064_ctl-poe-c17-final-part-selection-kemet-c0805c223k2racauto-22nf-200v-x7r-0805.md) | CTL PoE C17 Final Part Selection: Kemet C0805C223K2RACAUTO (22nF 200V X7R 0805) |  |  | C17 selected: Kemet C0805C223K2RACAUTO (22nF, 200V, X7R, 0805, ±10%, AEC-Q200). |
| [DEC-065](DEC-065_system-wide-stackup-code-correction-and-jlcpcb-authoritative-impedance-values.md) | System-Wide Stackup Code Correction and JLCPCB-Authoritative Impedance Values |  |  | Correct 4-layer stackup code: `JLC041621-3313`
Correct 6-layer stackup code: `JLC061621-3313` |
| [DEC-066](DEC-066_grs-canonical-pcb-stackup-authority-consolidation.md) | GRS Canonical PCB Stackup Authority (Consolidation) |  |  | Stackup definitions are consolidated into the Global Routing Specification as new section
§2.3 PCB Stackup Definition... |
| [DEC-067](DEC-067_am-sw1sw2-tactile-switch-rating-accepted-for-production.md) | AM SW1/SW2 Tactile Switch Rating Accepted for Production |  |  | SW1 and SW2 shall remain as the Omron B3F-1070 (or equivalent SPST NO through-hole tactile switch)
for production. |
| [DEC-068](DEC-068_pm-per-input-bulk-capacitors-and-output-source-quality-bulk-banks.md) | PM Per-Input Bulk Capacitors and Output Source-Quality Bulk Banks |  |  | Q1 - Pre-OR-ing per-input bulk: Each of the three input paths shall have a tight parallel cluster
of 3× Samsung CL32B... |
| [DEC-069](DEC-069_pm-per-input-polyfuse-protection-and-uvlo-resistor-recalculation.md) | PM Per-Input Polyfuse Protection and UVLO Resistor Recalculation |  |  | D1 - Per-input polyfuse: Each of the three input paths (VIN_POE_12V, Battery, USB-C) shall have
a Bel Fuse 0ZRB0600FF... |
| [DEC-070](DEC-070_mcp23017-i²c-silicon-restriction-gpb7gpa7-review-and-cfg-apply-n-reassignment.md) | MCP23017 I²C Silicon Restriction: GPB[7]/GPA[7] Review and CFG_APPLY_N Reassignment |  |  | D1 - CFG_APPLY_N reassignment: `CFG_APPLY_N` on USM U1 shall be reassigned from GPB[7] to
GPA[6]. |
| [DEC-071](DEC-071_usm-spdt-switch-dual-terminated-wiring-and-pull-down-resistor-removal.md) | USM SPDT Switch Dual-Terminated Wiring and Pull-Down Resistor Removal |  |  | D1 - Dual-terminated switch wiring adopted; pull-down resistors removed:
Each toggle switch (SW1-SW10) is wired as fo... |
| [DEC-072](DEC-072_review-pass-9-findings-and-resolutions.md) | Review Pass 9 Findings and Resolutions |  |  | Review Pass 9 identified 75 findings across all boards. |
| [DEC-073](DEC-073_ltc3350-rt-resistor-correction-332-kω-133-kω-amends-dec-030.md) | LTC3350 RT Resistor Correction: 33.2 kΩ → 133 kΩ (Amends DEC-030) | 2026-05-15 | Accepted | R23 (LTC3350 RT frequency-setting resistor) is changed from 33.2 kΩ to 133 kΩ (E96 nearest value to 133.75 kΩ). |
| [DEC-074](DEC-074_rename-cpld-reset-signal-sys-reset-n-cpld-reset-n.md) | Rename CPLD Reset Signal: SYS_RESET_N → CPLD_RESET_N | 2026-05-16 | Accepted | The active-low CPLD reset signal previously named SYS_RESET_N is renamed to CPLD_RESET_N across all design documentat... |
| [DEC-075](DEC-075_tps25751-option-c-external-eeprom-isolated-i2ct-debug-header-on-power-module.md) | TPS25751 Option C: External EEPROM + Isolated I2Ct Debug Header on Power Module | 2026-05-16 | Accepted | Implement Option C: |
| [DEC-076](DEC-076_pm-3v3-architecture-redesign-3v3-main3v3-enig-rail-split-j4-dual-purpose-programming-j6-removal-and-q12-parallel-p-fet-selection.md) | PM 3V3 Architecture Redesign: 3V3_MAIN/3V3_ENIG Rail Split, J4 Dual-Purpose Programming, J6 Removal, and Q12 Parallel P-FET Selection | 2026-05-16 | Accepted | A four-part redesign resolves both issues. |
| [DEC-077](DEC-077_retrospective-rotor-ttd-daisy-chain-no-series-termination-resistors-amends-dec-016.md) | Retrospective: Rotor TTD Daisy-Chain - No Series Termination Resistors (Amends DEC-016) |  |  | The deviation from DEC-016 for Rotor J2/J5 TTD lines is accepted retrospectively. |
| [DEC-078](DEC-078_cpld-reset-n-stator-buffer-bss138-n-channel-mosfet-new-decision-references-dec-077.md) | CPLD_RESET_N Stator Buffer: BSS138 N-Channel MOSFET (New Decision; References DEC-077) |  |  | A BSS138 N-channel MOSFET buffer is added to the Stator board as new reference designator Q1 on the `CPLD_RESET_N` line: |
| [DEC-079](DEC-079_c20-voltage-rating-correction-25v-35v-amends-dec-072-bom-item-1.md) | C20 Voltage Rating Correction: 25V → 35V (Amends DEC-072 BOM Item 1) |  |  | C20 is corrected to: |
| [DEC-080](DEC-080_retrospective-pm-and-stator-dock-connector-redesignation-amends-dec-038.md) | Retrospective: PM and Stator Dock Connector Redesignation (Amends DEC-038) | 2026-05-18 | Decided | #### Controller Board |
| [DEC-081](DEC-081_retrospective-rotor-ttd-no-series-resistor-policy-in-addition-to-dec-016.md) | Retrospective: Rotor TTD No-Series-Resistor Policy (In Addition to DEC-016) | 2026-05-18 | Decided | The Rotor Board TTD path carries no series resistor at each rotor-hop BtB interface
(`TTD` exits the CPLD directly to... |
| [DEC-082](DEC-082_10µf-bulk-reservoir-capacitor-upgrade-25v-0805-50v-1206-all-boards.md) | 10µF Bulk Reservoir Capacitor Upgrade: 25V 0805 → 50V 1206, All Boards |  |  | Standardise all 10µF X7R bulk/reservoir capacitors across all boards to: |
| [DEC-083](DEC-083_retire-all-boards-bomjson-consolidate-bom-authority-in-design-spec-files-and-consolidated-bom.md) | Retire `all_boards_bom.json`; Consolidate BOM Authority in Design_Spec Files and Consolidated_BOM |  |  | Retire `all_boards_bom.json` permanently. |
