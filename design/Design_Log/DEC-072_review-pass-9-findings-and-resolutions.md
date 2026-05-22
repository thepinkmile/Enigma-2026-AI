## DEC-072 - Review Pass 9 Findings and Resolutions

| Field | Value |
| --- | --- |
| **ID** | DEC-072 |
| **Status** | Accepted |
| **Date** | 2026-05-14 |
| **Author** | Design team |
| **Affects** | Controller, Power Module, JTAG Module, User Settings Module, Global Routing Spec, Consolidated BOM |

### Decision

Review Pass 9 identified 75 findings across all boards. Decisions and fixes are recorded below by finding ID.

**CLOSED - No change required:**

| Finding | Reason |
| --- | --- |
| PM-P9-01 R23=33.2kΩ | DEC-030 confirms correct for 400kHz switching frequency. |
| CTL-P9-03 Vds formula | TDK B82806D0060A120: D=0.667, Vds=108V correct for specified inductor. |
| CTL-P9-07 ZVS derating | Note already present in DR-CTL-23. |
| JM-P9-04 R4 duplicate | Dual-stage intentional; FR-JM-02 confirms all 4 resistors (R1-R4) required. |
| INT-CON-P9-03 VREF | VREF sourced from FT232H power pins on JM directly - no external supply needed. |
| BAT54 manufacturer | Consolidated BOM line 43 already shows `[Diotec]` - confirmed correct. |

**RESOLVED - Changes applied:**

- **JM-P9-01 TTD_RETURN net standardisation:** All JM TDO net references renamed to TTD_RETURN (JTAG Module Design_Spec.md §3.1 pinout, §5 schematic description, §9 Board_Layout.md) to align
  with system-wide on-board net naming. Component net name mapping table documents TDO↔TTD_RETURN relationship at the boundary. This maintains the Enigma machine-centric perspective (ENC_IN/ENC_OUT)
  consistently across all board net names.

- **CTL-P9-01 PoE power-side ESD protection (D2 1.5SMBJ36CA):** Added Bourns 1.5SMBJ36CA bidirectional TVS diode (36V, 1.5kW, DO-214AA) as D2 between the PoE transformer and PD controller
  (CTL Design_Spec.md §5 ESD section, BOM). Existing TPD4E05U06 (U4-U6) retained for data-side ESD. KiCAD library assets created: symbol in SamacSys_Parts.kicad_sym,
  footprint DIONM5436X244N in SamacSys_Parts.pretty/.

- **PM-P9-03 R8 and PM-P9-05 R22 - 3V3_ENIG → 5V_MAIN:** MIC1555 timing resistors R8 (FREQ_SET) and R22 (LED_PULSE) updated from 3V3_ENIG to 5V_MAIN rail. 3V3_ENIG is gated behind CM5 startup
  and would prevent the power status LED from operating at initial power-on. MIC1555 input voltage range confirmed compatible with 5V from datasheet.
  Power_Management.md §5 note removed (no longer applicable).

- **INT-CON-P9-05 CM5 underside connector wording:** Controller Design_Spec.md interconnect table wording generalised to "The CM5 underside connector mates with the Amphenol..." since
  the physical connector on the CM5 module itself is not under design control.

- **CTL-P9-05 J13/J14 renumbering:** Controller Board_Layout.md §7 updated throughout: J14→J13, J15→J14 to match current Design_Spec connector assignments after recent connector and standoff changes.

- **USM-P9-03 Switch series resistors R2-R11:** Added 10× 330Ω series resistors (ERJ-2RKF3300X, Panasonic, 0402) between SPDT switch contacts and GPIO expander U1 inputs. Original pull-down
  resistors (R2-R11) were removed in a prior pass when hard termination was confirmed; this pass re-adds protective series resistors against switch bounce / GPIO latch-up. USM Design_Spec.md
  DR-USM-09, U1 pinout table, silicon note, and BOM updated.

- **GRS §3.2 bypass cap placement:** Global Routing Spec §3.2 placement rule updated to explicitly state that bypass capacitors shall be placed as close to their associated VCC pin as physically
  possible on the board, in addition to the existing per-VCC-pin requirement.

- **JM-P9-03 USB trace width GRS cross-reference:** JTAG Module Board_Layout.md USB differential pair trace width specification updated to cross-reference GRS §2.3 instead of stating an explicit
  value, ensuring single-point control of impedance target.

- **INT-BOM-P9 Consolidated BOM corrections (7 items):**
  1. CGA9N3X7R1E476M230KB (47µF 2220): Added CTL C20; CTL qty -→4; Sys qty 4→8.
  2. C0805C105K5RACTU (1µF 0805): PM RefDes corrected C21-C23,C53,C55-C57 → C21-C23,C51,C53-C55.
  3. CL05B104KB5NNNC (100nF 0402): PM RefDes corrected C24-C30,...,C50,C56 → C26-C30,...,C50,C56,C57,C58 (C24,C25 phantom; C57,C58 added).
  4. CL05B103KB5NNNC (10nF 0402): PM RefDes corrected C51→C49.
  5. CSD17578Q5A (N-ch MOSFET): Notes description corrected 30V 10A SON-8 3.3x3.3mm → 30V 25A 5.9mΩ SON-8 5x6mm.
  6. ERJ-2RKF1002X (10kΩ 0402): System Qty corrected 45→57.
  7. PH1-05-UA (1×5 2.54mm male THT): System Qty corrected 10→19 (applies ×5 ROT multiplier).
  8. ERJ-2RKF3300X (330Ω 0402): Added USM R2-R11; USM qty -→10; Sys qty 4→14.
  9. New row inserted: CTL D2 1.5SMBJ36CA (DigiKey 118-1.5SMBJ36CACT-ND, Mouser 652-1.5SMBJ36CA, JLCPCB C5439937).

### Rationale

Pass 9 was the first full-sweep pass following the major connector renumbering and USM switch topology changes in Passes 7-8. The ESD addition (D2) closes a gap where PoE power-side protection was
absent; only data-side ESD had been specified. The 5V_MAIN change for R8/R22 corrects a functional error that would have prevented the power status LED from blinking at power-on. The BOM corrections
resolve accumulated RefDes drift that had built up as component values were adjusted across passes.

### Files Changed

- `design/Electronics/JTAG_Module/Design_Spec.md` - TDO→TTD_RETURN at §3.1, §5; Last Updated 2026-05-14
- `design/Electronics/JTAG_Module/Board_Layout.md` - USB trace width GRS cross-reference; Last Updated 2026-05-14
- `design/Electronics/Controller/Design_Spec.md` - D2 1.5SMBJ36CA ESD section; VREF removed; CM5 connector wording generalised; BOM D2 row added; Last Updated 2026-05-14
- `design/Electronics/Controller/Board_Layout.md` - J14→J13, J15→J14 throughout §7; Last Updated 2026-05-14
- `design/Electronics/Power_Module/Design_Spec.md` - R8/R22 3V3_ENIG→5V_MAIN; §5 note removed; Last Updated 2026-05-14
- `design/Electronics/User_Settings_Module/Design_Spec.md` - R2-R11 330Ω series resistors added throughout; BOM updated; count 156→166; Last Updated 2026-05-14
- `design/Standards/Global_Routing_Spec.md` - §3.2 bypass cap proximity wording; Last Updated 2026-05-14
- `design/Electronics/Consolidated_BOM.md` - 7 corrections + 1 new row (CTL D2 1.5SMBJ36CA); Last Updated 2026-05-14
- `src/Electronics/Library/SamacSys_Parts.kicad_sym` - 1.5SMBJ36CA symbol added
- `src/Electronics/Library/SamacSys_Parts.pretty/DIONM5436X244N.kicad_mod` - footprint created
