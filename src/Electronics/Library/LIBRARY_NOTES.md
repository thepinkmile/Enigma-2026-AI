# KiCAD Library Notes

> This file is the canonical reference for `SamacSys_Parts` library contents.
> Agents and reviewers **must** read this before auditing or modifying library files.
> All naming differences documented here are **intentional and pre-approved** — do not flag them.

---

## Library File Structure

| File / Directory | Format | Role |
|---|---|---|
| `SamacSys_Parts.kicad_sym` | KiCAD 6+ | Primary symbol library (new format). 68 symbols. |
| `SamacSys_Parts.lib` | KiCAD 5 / EESchema | Legacy symbol library. 127 symbols. Superset of `.kicad_sym`. |
| `SamacSys_Parts.dcm` | KiCAD 5 | Legacy symbol descriptions/keywords/datasheet URLs. |
| `SamacSys_Parts.mod` | KiCAD 5 / PCBNEW | Legacy footprint library. Contains `$INDEX` section + `$MODULE` blocks. |
| `SamacSys_Parts.pretty/` | KiCAD 6+ | New footprint directory. One `.kicad_mod` file per footprint. 92 files. |
| `SamacSys_Parts.3dshapes/` | — | Part-specific 3D models in `.stp` format. 55 files. |
| `3D_Models/` | — | Mirror of 3dshapes in `.step` format. Kept in sync with `.3dshapes/`. |
| `temp/` | — | Drop zone for SamacSys/SnapMagic download zips. Not committed. |

**All four format layers must stay in sync** — when a symbol, footprint, or 3D model is added or
modified, the corresponding entry must be updated in both legacy and new formats. See
`.copilot/agent-directives.md` NONARY DIRECTIVE for the full import workflow.

**59 symbols exist only in legacy `.lib` format** and have not yet been migrated to `.kicad_sym`.
This is expected — new-format migration happens when a part is actively edited in KiCAD 6+.

---

## Known Naming Equivalences

These are cases where the footprint file name or 3D model name differs from the component MPN.
All are intentional — they reflect SamacSys naming conventions, TI package codes, or
wildcard-normalized footprint names. **Do not flag any entry in this table as an error.**

### Footprint name differs from component MPN

| Component MPN | Symbol Name | Footprint File (`.kicad_mod`) | Reason |
|---|---|---|---|
| `B3F-1070` | `B3F-1070` | `B3F1060.kicad_mod` | SamacSys uses the same physical footprint for both the B3F-1060 and B3F-1070 Omron switch variants. Both zips ship `B3F1060.kicad_mod`. The 3D model is variant-specific (`B3F-1070.stp`). |
| `CSD17578Q5A` | `CSD17578Q5A` | `CSD19531Q5AT.kicad_mod` | SamacSys assigns the `CSD19531Q5AT` SON-8 5×6mm package footprint to the CSD17578Q5A. Both are TI NexFET MOSFETs in the same package. The 3D model is part-specific (`CSD17578Q5A.stp`). |
| `TPS75733KTTRG3` | `TPS75733KTTRG3` | `TPS75933KTTR.kicad_mod` | SamacSys uses a shared TO-263-5 LDO footprint for the TPS757xx/TPS759xx family. Only the packaging tape suffix and voltage differ. |
| `TPD4E05U06QDQARQ1` | `TPD4E05U06QDQARQ1` | `DQA(R-PUSON-N10).kicad_mod` | `DQA` is Texas Instruments' internal package code for U-DFN-10. SamacSys names the footprint after the TI package designation rather than the component MPN. |
| `ERM8-005-05.0-S-DV-K-TR` | `ERM8-005-05.0-S-DV-K-TR` | `ERM8-005-XX.X-X-DV-K-TR.kicad_mod` | Footprint name uses wildcard pattern to serve all pitch/length variants of the ERM8 Samtec connector family. The specific pitch (5.0mm) is encoded in the MPN but normalized in the footprint name. |
| `ERF8-010-05.0-S-DV-K-TR` | `ERF8-010-05.0-S-DV-K-TR` | `ERF8-010-XX.X-XXX-DV-K-TR.kicad_mod` | Same wildcard normalization as ERM8. Mating receptacle to ERM8. |
| `SM04B-SRSS-TB(LF)(SN)` | `SM04B-SRSS-TB_LF__SN_` | `SM04B-SRSS-TB(LFSN).kicad_mod` | SamacSys encodes the `(LF)(SN)` suffix with underscores in the symbol name, then drops the separator in the footprint name. All three representations refer to the same JST SH SMD connector. |
| `CWF1610A-180K` | `CWF1610A-180K` | `CWF1610A100K.kicad_mod` | SamacSys omits the inductance value suffix from the footprint name. `CWF1610A100K` is the package footprint shared across the CWF1610A inductor series. |
| `WP154A4SEJ3VBDZGW/CA` | `WP154A4SEJ3VBDZGW_CA` | `L-154A4SUREQBFZGEC.kicad_mod` | SamacSys assigned a different catalog/variant name to the footprint of this Kingbright LED. The footprint dimensions are correct for the WP154A4 package. |
| `B82806D0060A120` | `B82806D0060A120` | `B82806D0060A033.kicad_mod` | SamacSys uses the A033 variant footprint (same Würth WE-CSB package) for the A120 inductance value. Package dimensions are identical across the B82806D0060Axxx series. |

### 3D model name differs from footprint or MPN

| Component MPN | Footprint File | 3D Model File | Reason |
|---|---|---|---|
| `B3F-1070` | `B3F1060.kicad_mod` | `B3F-1070.stp` | Model is part-specific; footprint name reflects shared package (see above). |
| `1-1674231-1` | `16742311.kicad_mod` | `1-1674231-1.stp` | Footprint name strips dashes; 3D model file retains original MPN formatting. |
| `SRP1265A-100M` | `SRP1265A.kicad_mod` | `SRP1265A-100M.stp` | Footprint name omits inductance value suffix; 3D model retains it. |
| `LMQ61460AFSQRJRRQ1` | `LMQ61460AFSQRJRRQ1.kicad_mod` | `LMQ61460AFSQRJRRQ1.stp` | Mouser SKU drops `LM` prefix (`595-Q61460AFSQRJRRQ1`). This is a Mouser abbreviation only — the MPN, symbol, footprint, and 3D model all correctly use the full `LMQ61460AFSQRJRRQ1` name. |

### Footprint name normalizations (dashes/dots removed)

SamacSys systematically strips punctuation from footprint file names. The following MPNs map to
footprints with dashes, dots, or spaces removed. These are all correct:

| Component MPN | Footprint File |
|---|---|
| `10164227-1004A1RLF` | `101642271004A1RLF.kicad_mod` |
| `1-1674231-1` | `16742311.kicad_mod` |
| `2007435-1` | `20074351.kicad_mod` |
| `48406-0003` | `484060003.kicad_mod` |
| `219-6LPST` | `2196LPST.kicad_mod` |
| `RS1-05-G` | `RS105G.kicad_mod` |
| `PA4343.333NLT` | `PA4343333NLT.kicad_mod` |
| `KRL6432T4-M-R010-F-T1` | `KRL6432T4MR010FT1.kicad_mod` |
| `USB4135-GF-A` | `USB4135GFA.kicad_mod` |
| `POE600F-12LB` | `POE600F12LB.kicad_mod` |
| `F52Q-1A7H1-11015` | `F52Q1A7H111015.kicad_mod` |
| `2195630015` | `2195630015.kicad_mod` (unchanged) |

---

## Component Inventory

Auto-extracted from library files. `Format` indicates whether the symbol exists in the new
`.kicad_sym` format (`new`), legacy `.lib` only (`legacy`), or both (`both`).

Footprint names prefixed `CAPC`, `RESC`, `SOT`, `SOIC`, `QFP`, `QFN`, `SOP`, `LEDC`, `DION`,
`DIOM`, `HDRV`, `SHDR` etc. are **generic IPC footprints** — they use KiCAD's built-in 3D models
from the standard library, not custom `.stp` files in `3dshapes/`. See
[Generic IPC Footprints](#generic-ipc-footprints) below.

| Symbol | Format | Footprint | 3D Model (.stp) | Notes |
|---|---|---|---|---|
| `0ZRB0600FF1A` | legacy | `0ZRB0600FF1A` | `0ZRB0600FF1A.stp` | Ferrite bead |
| `1.5SMBJ36CA` | legacy | `DIONM5436X244N` | `1.5SMBJ36CA.stp` | TVS diode; generic IPC footprint |
| `1.5SMBJ36CA-H` | legacy | `DIONM5436X244N` | `1.5SMBJ36CA.stp` | TVS diode high-temp variant; shares footprint |
| `10164227-1004A1RLF` | legacy | `101642271004A1RLF` | `10164227-1004A1RLF.stp` | Amphenol FPC connector |
| `1123684-7` | new | `11236847` | `1123684-7.stp` | TE Connectivity connector |
| `1211` | legacy | `1211` | `1211.stp` | Keystone battery holder |
| `1285-ST` | legacy | `1285ST` | — | Keystone test point |
| `150060VS75000` | legacy | `LEDC1608X70N` | `150060VS75000.stp` | Würth green LED; generic IPC footprint |
| `1-1674231-1` | legacy | `16742311` | `1-1674231-1.stp` | TE Connectivity connector; footprint strips dashes |
| `2007435-1` | legacy | `20074351` | `2007435-1.stp` | TE Connectivity connector |
| `200MSP1T2B4M2QE` | legacy | `200MSP1T2B4M2QE` | `200MSP1T2B4M2QE.stp` | C&K slide switch |
| `219-6LPST` | legacy | `2196LPST` | `219-6LPST.stp` | Keystone test point |
| `2195630015` | legacy | `2195630015` | `2195630015.stp` | Molex Micro-Lock Plus connector |
| `3034TR` | legacy | `3034TR` | — | Keystone THT test point |
| `43650-0519` | new | `43650-05YY_18192063` | `43650-0519.stp` | Molex KK 254 5-pos connector |
| `43650-0619` | legacy | `43650-06YY_18192063` | `43650-0619.stp` | Molex KK 254 6-pos connector |
| `48406-0003` | legacy | `484060003` | `48406-0003.stp` | Molex Nano-Fit connector |
| `7448031002` | new | `7448031002` | `7448031002.stp` | Würth common mode choke — ⚠️ STP absent from `3dshapes/` |
| `7499111121A` | legacy | `LAN-TRANSFORMER-WE-RJ45LAN` | `7499111121A.stp` | Würth RJ45 with magnetics — ⚠️ STP absent from `3dshapes/` |
| `74HC157PW-Q100,118` | new | `SOP65P640X110-16N` | — | NXP mux; generic IPC footprint |
| `74LVC2G3157DP-Q10J` | legacy | `SOP50P490X110-10N` | `74LVC2G3157DP-Q10J.stp` | NXP dual mux |
| `9774035151R` | legacy | `9774035151R` | `9774035151R.stp` | Würth SMD standoff — ⚠️ STP absent from `3dshapes/` |
| `9774040151R` | legacy | `9774040151R` | `9774040151R.stp` | Würth SMD standoff — ⚠️ STP absent from `3dshapes/` |
| `ADCR-T02R7SA256MB` | new | `CAPPRD750W85D1600H2500` | — | Capacitor; generic IPC footprint |
| `AP2331W-7` | new | `SOT95P285X130-3N` | — | Diodes Inc load switch; generic IPC |
| `B3F-1070` | legacy | `B3F1060` | `B3F-1070.stp` | Omron tactile switch; ⚠️ see naming equivalences |
| `B6B-PH-K-S(LF)(SN)` | legacy | `SHDR6W50P0X200_1X6_1390X450X600P` | — | JST PH 6-pos; generic IPC footprint |
| `B82806D0060A120` | legacy | `B82806D0060A033` | `B82806D0060A120.stp` | Würth inductor; ⚠️ see naming equivalences |
| `BAT54` | new | `SOT95P240X120-3N` | — | Schottky diode; generic IPC |
| `BHR-20-VUA` | legacy | `SHDR20W64P254_2X10_3300X880X910P` | `BHR-20-VUA.stp` | Sullins 2×10 header |
| `BMC-Q2AY0600M` | new | `BEADC2012X110N` | — | Ferrite bead; generic IPC |
| `BSS138LT1G` | new | `SOT96P237X111-3N` | — | ON Semi NMOS; generic IPC |
| `C0402C101K3RACAUTO` | new | `CAPC1005X55N` | — | KEMET cap 0402; generic IPC |
| `C0402C103K1RACAUTO` | legacy | `CAPC1005X55N` | — | KEMET cap 0402; generic IPC |
| `C0402C330J5GACAUTO` | legacy | `C0402` | — | KEMET cap 0402; generic IPC |
| `C0805C105K5RACTU` | new | `C0805` | — | KEMET cap 0805; generic IPC |
| `C0805C223K2RACAUTO` | legacy | `C0805` | — | KEMET cap 0805; generic IPC |
| `CC1206KKX7R8BB106` | new | `CAPC3216X180N` | — | Yageo cap 1206; generic IPC |
| `CGA6P3X7R1H475K250AD` | legacy | `CGA6P3X7R1H475K250AD` | — | TDK cap 1210 custom footprint |
| `CGA9N1X7R1V476M230KC` | new | `CAPC5750X280N` | — | TDK cap 2220; generic IPC |
| `CGA9N3X7R1E476M230KB` | new | `CAPC5750X250N` | — | TDK cap 2220; generic IPC |
| `CL05B103KB5NNNC` | new | `CAPC1005X55N` | — | Samsung cap 0402; generic IPC |
| `CL05B104KB5NNNC` | new | `CAPC1005X55N` | — | Samsung cap 0402; generic IPC |
| `CL10B223KB8WPNC` | new | `CAPC1608X90N` | — | Samsung cap 0603; generic IPC |
| `CL21B106KAYQNNE` | legacy | `CAPC2012X145N` | — | Samsung cap 0805; generic IPC |
| `CL32B226KAJNNNE` | new | `CAPC3225X270N` | — | Samsung cap 1210; generic IPC |
| `CSD17578Q5A` | new | `CSD19531Q5AT` | `CSD17578Q5A.stp` | TI NMOS 30V 25A; ⚠️ see naming equivalences |
| `CWF1610A-180K` | legacy | `CWF1610A100K` | `CWF1610A-180K.stp` | Bourns inductor; ⚠️ see naming equivalences |
| `DF40C-20DP-0.4V(51)` | new | `DF40C20DP04V51` | `DF40C20DP04V51.stp` | Hirose DF40 20-pos plug |
| `DF40HC(3.5)-20DS-0.4V(51)` | new | `DF40HC3520DS04V51` | `DF40HC3520DS04V51.stp` | Hirose DF40 20-pos receptacle |
| `EPM570T100I5N` | new | `QFP50P1600X1600X120-100N` | — | Intel CPLD; generic IPC QFP |
| `ERA-2AEB3322X` | new | `ERA2AED122X` | — | Panasonic resistor 0402 |
| `ERA-3VEB2100V` | new | `ERA3KV_(0603)` | — | Panasonic resistor 0603 |
| `ERA3ARB103V` | new | `ERA3AEB101V` | — | Panasonic resistor 0603 |
| `ERA3ARB3012V` | new | `ERA3AEB101V` | — | Panasonic resistor 0603; shares ERA3AEB101V footprint |
| `ERF8-010-05.0-S-DV-K-TR` | legacy | `ERF8-010-XX.X-XXX-DV-K-TR` | `ERF8-010-05.0-S-DV-K-TR.stp` | Samtec ERF8 receptacle; ⚠️ see naming equivalences |
| `ERJ-2RKF1001X` | legacy | `ERJ2RKD1004X` | — | Panasonic resistor 0402 |
| `ERJ-2RKF1002X` | new | `ERJ2RKD1004X` | — | Panasonic resistor 0402 |
| `ERJ-2RKF1003X` | legacy | `ERJ2RKD1004X` | — | Panasonic resistor 0402 |
| `ERJ-2RKF10R0X` | legacy | `ERJ2RKD1004X` | — | Panasonic resistor 0402 |
| `ERJ-2RKF3300X` | legacy | `ERJ2RKD1004X` | — | Panasonic resistor 0402 |
| `ERJ-2RKF33R0X` | legacy | `ERJ2RKD1004X` | — | Panasonic resistor 0402 |
| `ERJ-2RKF5232X` | legacy | `ERJ2RKD1004X` | — | Panasonic resistor 0402 |
| `ERJ-2RKF75R0X` | legacy | `ERJ2RKD1004X` | — | Panasonic resistor 0402 |
| `ERJ-2RKF8202X` | legacy | `ERJ2RKD1004X` | — | Panasonic resistor 0402 |
| `ERJ-3EKF1000V` | legacy | `RESC1608X55N` | — | Panasonic resistor 0603; generic IPC |
| `ERJ-3EKF1002V` | new | `RESC1608X55N` | — | Panasonic resistor 0603; generic IPC |
| `ERJ-3EKF1500V` | legacy | `RESC1608X55N` | — | Panasonic resistor 0603; generic IPC |
| `ERJ-3EKF2200V` | legacy | `RESC1608X55N` | — | Panasonic resistor 0603; generic IPC |
| `ERJ-3EKF2263V` | legacy | `RESC1608X55N` | — | Panasonic resistor 0603; generic IPC |
| `ERJ-3EKF2323V` | new | `RESC1608X55N` | — | Panasonic resistor 0603; generic IPC |
| `ERJ-3EKF2743V` | new | `RESC1608X55N` | — | Panasonic resistor 0603; generic IPC |
| `ERJ-3EKF2872V` | new | `RESC1608X55N` | — | Panasonic resistor 0603; generic IPC |
| `ERJ-3EKF3010V` | new | `RESC1608X55N` | — | Panasonic resistor 0603; generic IPC |
| `ERJ-3EKF4701V` | new | `RESC1608X55N` | — | Panasonic resistor 0603; generic IPC |
| `ERJ-3EKF7153V` | new | `RESC1608X55N` | — | Panasonic resistor 0603; generic IPC |
| `ERJ-3EKF8662V` | new | `RESC1608X55N` | — | Panasonic resistor 0603; generic IPC |
| `ERJ2RKF1001X` | new | `ERJ2RKD1004X` | — | Panasonic resistor 0402 |
| `ERJ2RKF1003X` | new | `ERJ2RKD1004X` | — | Panasonic resistor 0402 |
| `ERJ2RKF10R0X` | new | `ERJ2RKD1004X` | — | Panasonic resistor 0402 |
| `ERJ2RKF5232X` | new | `ERJ2RKD1004X` | — | Panasonic resistor 0402 |
| `ERJ2RKF8202X` | new | `ERJ2RKD1004X` | — | Panasonic resistor 0402 |
| `ERM8-005-05.0-S-DV-K-TR` | legacy | `ERM8-005-XX.X-X-DV-K-TR` | `ERM8-005-05.0-S-DV-K-TR.stp` | Samtec ERM8 plug; ⚠️ see naming equivalences |
| `F52Q-1A7H1-11015` | legacy | `F52Q1A7H111015` | `F52Q-1A7H1-11015.stp` | TE Connectivity connector |
| `FDC2114RGHR` | new | `QFN50P400X400X80-17N` | — | TI capacitive sensor; generic IPC |
| `FT232HL-REEL` | new | `QFP50P900X900X160-48N` | — | FTDI USB-UART; generic IPC QFP |
| `HI1206P121R-10` | legacy | `BEADC3216X130N` | `HI1206P121R-10.stp` | Laird ferrite bead 1206 |
| `INA219AIDR` | new | `SOIC127P600X175-8N` | — | TI current monitor; generic IPC |
| `KAM05CR71A105KH` | legacy | `CAPC1005X70N` | `KAM05CR71A105KH.stp` | AVX cap 0402 (special footprint) |
| `KRL6432T4-M-R010-F-T1` | new | `KRL6432T4MR010FT1` | `KRL6432T4-M-R010-F-T1.stp` | Susumu Kelvin shunt 2512 |
| `LM74700QDBVRQ1` | new | `SOT95P280X145-6N` | — | TI ideal diode; generic IPC |
| `LMQ61460AFSQRJRRQ1` | new | `LMQ61460AFSQRJRRQ1` | `LMQ61460AFSQRJRRQ1.stp` | TI buck converter; Mouser SKU abbreviates MPN |
| `LTC3350EUHF#PBF` | new | `QFN50P500X700X80-39N-D` | — | Analog Devices supercap charger; generic IPC |
| `M24512-RDW6TP` | legacy | `SOP65P640X120-8N` | `M24512-RDW6TP.stp` | ST EEPROM 512Kbit |
| `MCP121T-450E/LB` | new | `SOT65P210X110-3N` | — | Microchip supervisor; generic IPC |
| `MCP23017T-E/SO` | new | `SOIC127P1030X265-28N` | — | Microchip I/O expander; generic IPC |
| `MIC1555YM5-TR` | new | `SOT95P280X145-5N` | — | Microchip timer; generic IPC |
| `NE555DR` | new | `SOIC127P600X175-8N` | — | TI timer; generic IPC |
| `NL27WZ14DFT2G-Q` | new | `SOT65P210X110-6N` | — | ON Semi dual inverter; generic IPC |
| `PA4343.333NLT` | legacy | `PA4343333NLT` | `PA4343.333NLT.stp` | Pulse transformer; ⚠️ STP absent from `3dshapes/` |
| `PCA9534APWR` | new | `SOP65P640X120-16N` | — | TI I2C I/O expander; generic IPC |
| `PH1-05-UA` | legacy | `HDRV5W64P0X254_1X5_1270X250X850P` | — | Sullins 1×5 header; generic IPC |
| `PH1-07-UA` | legacy | `HDRV7W64P0X254_1X7_1778X250X850P` | `PH1-07-UA.stp` | Sullins 1×7 header |
| `POE600F-12LB` | legacy | `POE600F12LB` | `POE600F-12LB.stp` | Coilcraft PoE transformer (v2 reserved) |
| `RS1-05-G` | legacy | `RS105G` | `RS1-05-G.stp` | Bourns TVS array |
| `SG73S1ERTTP4702D` | legacy | `Resistor_SMD:R_0402_1005Metric` | — | KOA resistor 0402; uses KiCAD built-in footprint |
| `SM04B-SRSS-TB(LF)(SN)` | legacy | `SM04B-SRSS-TB(LFSN)` | `SM04B-SRSS-TB_LF__SN_.stp` | JST SH 4-pos; ⚠️ see naming equivalences |
| `SMBJ18A-Q` | new | `DIOM5436X244N` | — | ON Semi TVS; generic IPC |
| `SN74LVC1G08DBVR` | new | `SOT95P280X145-5N` | — | TI AND gate; generic IPC |
| `SN74LVC1G175DBVR` | new | `SOT95P280X145-6N` | — | TI D-FF; generic IPC |
| `SN74LVC2G125DCUR` | new | `SOP50P310X90-8N` | — | TI dual buffer; generic IPC |
| `SQ2319ADS-T1/BE3` | legacy | `SOT95P237X112-3N` | `SQ2319ADS-T1_BE3.stp` | Vishay PMOS |
| `SRP1265A-100M` | new | `SRP1265A` | `SRP1265A-100M.stp` | Bourns power inductor; ⚠️ see naming equivalences |
| `STD25NF20` | legacy | `STD25NF20` | `STD25NF20.stp` | ST NMOS TO-252 |
| `STM32G071K8T3TR` | new | `QFP80P900X900X160-32N` | — | ST MCU; generic IPC QFP |
| `STUSB4500LQTR` | new | `QFN50P400X400X100-25N-D` | — | ST USB-PD controller; generic IPC |
| `TPD1E10B06DYARQ1` | new | `SODFL1608X77N` | — | TI ESD; generic IPC |
| `TPD2E2U06DRLR` | new | `SOT50P160X60-5N` | — | TI dual ESD; generic IPC |
| `TPD4E05U06QDQARQ1` | new | `DQA(R-PUSON-N10)` | `TPD4E05U06QDQARQ1.stp` | TI 4-ch ESD; ⚠️ see naming equivalences |
| `TPS2065CDBVR` | new | `SOT95P280X145-5N` | — | TI load switch; generic IPC |
| `TPS2372-4RGWR` | new | `TPS259804ONRGER` | `TPS259804ONRGER.stp` | TI PoE PD; shares TPS259804 package footprint |
| `TPS23730RMTR` | legacy | `TPS23730RMTR` | `TPS23730RMTR.stp` | TI PoE PSE controller |
| `TPS25751DREFR` | legacy | `TPS25751DREFR` | `TPS25751DREFR.stp` | TI USB-PD controller |
| `TPS259804ONRGER` | legacy | `TPS259804ONRGER` | `TPS259804ONRGER.stp` | TI PoE PD |
| `TPS75733KTTRG3` | new | `TPS75933KTTR` | `TPS75733KTTRG3.stp` | TI LDO 3.3V; ⚠️ see naming equivalences |
| `USB4135-GF-A` | new | `USB4135GFA` | `USB4135-GF-A.stp` | GCT USB Type-C receptacle |
| `WP154A4SEJ3VBDZGW/CA` | legacy | `L-154A4SUREQBFZGEC` | `WP154A4SEJ3VBDZGW_CA.stp` | Kingbright LED; ⚠️ see naming equivalences |

---

## Generic IPC Footprints

The following footprint names are generic IPC-standard designations shared across multiple
components. They do **not** have part-specific `.stp` files in `3dshapes/` — KiCAD resolves
their 3D models from its built-in `Capacitor_SMD.3dshapes`, `Resistor_SMD.3dshapes`,
`Package_SO.3dshapes`, etc. libraries automatically.

| IPC Footprint Name | Package Type | Used by |
|---|---|---|
| `CAPC1005X55N` | 0402 capacitor | C0402C101K3, C0402C103K1, CL05B103, CL05B104, KAM05CR71A |
| `CAPC1608X90N` | 0603 capacitor | CL10B223 |
| `CAPC2012X145N` | 0805 capacitor | CL21B106 |
| `CAPC3216X180N` | 1206 capacitor | CC1206KKX7R8BB106 |
| `CAPC3225X270N` | 1210 capacitor | CL32B226 |
| `CAPC5750X250N` / `CAPC5750X280N` | 2220 capacitor | CGA9N3, CGA9N1 |
| `CAPPRD750W85D1600H2500` | THT radial cap | ADCR-T02R7SA256MB |
| `C0402` / `C0805` | IPC generic cap | C0402C330, C0805C105, C0805C223 |
| `RESC1608X55N` | 0603 resistor | ERJ-3EKF series |
| `ERJ2RKD1004X` | 0402 resistor | ERJ-2RKF series, ERJ2RKF series |
| `ERA2AED122X` | 0402 thin-film R | ERA-2AEB3322X |
| `ERA3AEB101V` / `ERA3KV_(0603)` | 0603 thin-film R | ERA3ARB103V, ERA3ARB3012V, ERA-3VEB2100V |
| `BEADC2012X110N` / `BEADC3216X130N` | Ferrite bead | BMC-Q2AY0600M, HI1206P121R-10 |
| `LEDC1608X70N` | 0603 LED | 150060VS75000 |
| `SOT95P240X120-3N` | SOT-23 | BAT54 |
| `SOT95P280X145-5N` | SOT-23-5 | AP2331W-7, MIC1555, TPS2065, SN74LVC1G08, SN74LVC1G175 |
| `SOT95P280X145-6N` | SOT-23-6 | LM74700QDBVRQ1, SN74LVC1G175 |
| `SOT95P285X130-3N` | SOT-23 variant | AP2331W-7 |
| `SOT96P237X111-3N` | SOT-323 | BSS138LT1G |
| `SOT65P210X110-3N` / `SOT65P210X110-6N` | SC-70 | MCP121T, NL27WZ14 |
| `SOT50P160X60-5N` | SC-88A / SOT-363 | TPD2E2U06DRLR |
| `SODFL1608X77N` | SOD-FL | TPD1E10B06DYARQ1 |
| `DIOM5436X244N` / `DIONM5436X244N` | DO-214AB (SMB) | SMBJ18A-Q, 1.5SMBJ36CA |
| `SOIC127P600X175-8N` | SOIC-8 | INA219AIDR, NE555DR |
| `SOIC127P1030X265-28N` | SOIC-28 | MCP23017T-E/SO |
| `SOP65P640X110-16N` | SOP-16 | 74HC157PW |
| `SOP65P640X120-16N` | SOP-16 | PCA9534APWR |
| `SOP50P310X90-8N` | SSOP-8 | SN74LVC2G125DCUR |
| `SOP50P490X110-10N` | SSOP-10 | 74LVC2G3157DP |
| `QFP50P1600X1600X120-100N` | TQFP-100 | EPM570T100I5N |
| `QFP50P900X900X160-48N` | LQFP-48 | FT232HL-REEL |
| `QFP80P900X900X160-32N` | LQFP-32 | STM32G071K8T3TR |
| `QFN50P400X400X80-17N` | QFN-17 | FDC2114RGHR |
| `QFN50P400X400X100-25N-D` | QFN-25 | STUSB4500LQTR |
| `QFN50P500X700X80-39N-D` | QFN-39 | LTC3350EUHF |
| `HDRV5W64P0X254_1X5_1270X250X850P` | 1×5 2.54mm header | PH1-05-UA |
| `HDRV7W64P0X254_1X7_1778X250X850P` | 1×7 2.54mm header | PH1-07-UA |
| `SHDR6W50P0X200_1X6_1390X450X600P` | 1×6 2.0mm header | B6B-PH-K-S |
| `SHDR20W64P254_2X10_3300X880X910P` | 2×10 2.54mm header | BHR-20-VUA |

---

## Import Notes for Agents

Before importing any component into this library, read `.copilot/agent-directives.md`
**NONARY DIRECTIVE** in full. Key rules:

1. All four format layers (`.kicad_sym`, `.lib`/`.dcm`, `.mod`, `.pretty/*.kicad_mod`) must be
   updated in a single import pass. A component is not "imported" until all four conditions are met.
2. 3D models go in both `SamacSys_Parts.3dshapes/` (`.stp`) and `3D_Models/` (`.step`).
3. SamacSys zip footprint names frequently differ from MPN — always compare pad layout before
   deciding whether to use the zip footprint or keep the existing one. Do **not** replace an
   existing footprint if pad positions differ even slightly.
4. Leading-zero pad numbers from SnapMagic must be normalized (remove leading zeros) to match
   symbol pin numbering.
5. Never flag the naming differences in the **Known Naming Equivalences** table above as errors.
   They are all intentional and pre-approved.
6. When retiring a processed zip, move it to `.recycle-bin/library-retired-YYYYMMDD/`. Do not
   delete it.
