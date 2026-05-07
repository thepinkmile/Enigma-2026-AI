# Consolidated Bill of Materials

<!-- markdownlint-disable MD013 MD055 MD056 -->

**Status:** Draft
**Project:** Enigma-NG
**Author:** Izzyonstage & GitHub Copilot
**Version:** v.0.1.0
**Associated Hardware Revision:** Rev A
**Last Updated:** 2026-05-05

---

## Notes and Conventions

- Manufacturer shown in Description/Usage column as `[Manufacturer]`.
- Board codes: PM = Power Module · CTL = Controller · STA = Stator · ROT = Rotor · USM = User Settings Module · EXT = Extension · REF = Reflector · ENC = Encoder · AM = Actuation Module · JDB = JTAG Daughterboard.
- **Footprint Downloaded** column: user-maintained. Replace "Pending" with tick once the footprint is added to the shared KiCAD library. "Requested" means a custom footprint has been formally requested from the manufacturer or third party, awaiting delivery.
- **CSD17578Q5A replaces CSD17483F4T:** OR-ing MOSFET corrected from the incorrectly specified CSD17483F4T (1.5A FemtoFET) to CSD17578Q5A (30V 25A 5.9mΩ SON 5x6mm). DigiKey: 296-48512-1-ND, Mouser: 595-CSD17578Q5A, JLCPCB: C2871447.
- **LMQ61460AFSQRJRRQ1 Mouser PN:** `595-Q61460AFSQRJRRQ1` drops the "LM" prefix - confirmed correct Mouser convention.
- **System Qty** represents one complete base-system build: 1× PM, 1× CTL, 1× STA, 1× REF, 1× EXT, 1× JDB, 1× USM, 1× ENC, 1× AM, and **5× ROT boards of a single rotor variant (either all ROT-26 or all ROT-64 — never both)**. ROT-26 Qty and ROT-64 Qty columns show per-board quantities for one board of each variant. For shared components (same value in both variant BOM tables), System Qty = non-ROT board sum + (per-board count × 5). For variant-specific components (appears in one variant only), System Qty = non-ROT board sum + (variant-specific per-board count × 5).
- **Locked parts** marked with a lock symbol require owner approval before any change.

---

## Section 1 - Full Component Table

| Board (RefDes) | MPN | DigiKey PN | Mouser PN | JLCPCB PN | Alt Supplier + PN | PM Qty | CTL Qty | JDB Qty | USM Qty | ENC Qty | AM Qty | STA Qty | REF Qty | EXT Qty | ROT-26 Qty | ROT-64 Qty | System Qty | Notes | Footprint Available | Footprint Downloaded |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| PM: C1-C15 | CL32B226KAJNNNE | 1276-3392-1-ND | 187-CL32B226KAJNNNE | C309062 | - | 15 | - | - | - | - | - | - | - | - | - | - | 15 | 22µF 25V X7R 1210 [Samsung] | Yes | ✔ |
| PM: C16-C19 | CGA9N3X7R1E476M230KB | 445-174773-1-ND | 810-A9N3X7476M23KB | C2182815 | - | 4 | - | - | - | - | - | - | - | - | - | - | 4 | 47µF 25V X7R 2220 [TDK] | Yes | ✔ |
| PM: C21-C23,C53,C55-C57; AM: C1 | C0805C105K5RACTU | 399-C0805C105K5RACTUCT-ND | 80-C0805C105K5R | C3018567 | - | 7 | - | - | - | - | 1 | - | - | - | - | - | 8 | 1µF 50V X7R 0805 [Kemet] | Yes | ✔ |
| PM: C24-C30,C31-C37,C41-C48,C50,C56; CTL: C6,C12-C16,C18,C19; JDB: C1-C4,C6-C9,C12; USM: C1-C4; ENC: C1-C8; AM: C2,C3,C6,C7; STA: C1-C8,C14-C21; EXT: C6; ROT-26: C1-C9,C20A; ROT-64: C1-C9,C20B | CL05B104KB5NNNC | 1276-CL05B104KB5NNNCCT-ND | 187-CL05B104KB5NNNC | C960916 | - | 24 | 8 | 9 | 4 | 8 | 4 | 16 | - | 1 | 10 | 10 | 124 | 100nF 50V X7R 0402 [Samsung] | Yes | ✔ |
| PM: C38 | C0402C101K3RACAUTO | 399-C0402C101K3RACAUTOCT-ND | 80-C0402C101K3RAUTO | C5272912 | - | 1 | - | - | - | - | - | - | - | - | - | - | 1 | 100pF X7R 25V 0402 [Kemet] | Yes | ✔ |
| PM: C_SC1-C_SC8 | ADCR-T02R7SA256MB | 535-ADCR-T02R7SA256MB-ND | 815-ADCRT02R7SA256MB | - | Global sourcing | 8 | - | - | - | - | - | - | - | - | - | - | 8 | 25F 2.7V supercap THT Radial 16x25mm [Abracon] | Yes | ✔ |
| PM: C39 | CL10B223KB8WPNC | 1276-6534-1-ND | 187-CL10B223KB8WPNC | C346197 | - | 1 | - | - | - | - | - | - | - | - | - | - | 1 | 22nF X7R 25V 0603 [Samsung] | Yes | ✔ |
| PM: C40,C52 | CC1206KKX7R8BB106 | 311-1959-1-ND | 603-CC126KKX7R8BB106 | C70462 | - | 2 | - | - | - | - | - | - | - | - | - | - | 2 | 10µF 16V X7R 1206 [YAGEO] | Yes | ✔ |
| PM: C51 | CL05B103KB5NNNC | 1276-1008-1-ND | 187-CL05B103KB5NNNC | C15195 | - | 1 | - | - | - | - | - | - | - | - | - | - | 1 | 10nF 50V X7R 0402 [Samsung] | Yes | ✔ |
| PM: D1 | TPD1E10B06DYARQ1 | 296-TPD1E10B06DYARQ1CT-ND | 595-TPD1E10B06DYARQ1 | C3013901 | - | 1 | - | - | - | - | - | - | - | - | - | - | 1 | ESD SOD-523 [Texas Instruments] | Yes | ✔ |
| PM: D2 | TPD2E2U06DRLR | 296-38361-1-ND | 595-TPD2E2U06DRLR | C1972959 | - | 1 | - | - | - | - | - | - | - | - | - | - | 1 | ESD SOT-553 [Texas Instruments] | Yes | ✔ |
| PM: D3; CTL: U4-U6; STA: U9-U12; REF: U1-U4; EXT: U2-U9; ROT-26: U3-U10; ROT-64: U3-U10 | TPD4E05U06QDQARQ1 | 296-40696-1-ND | 595-PD4E05U06QDQARQ1 | C81353 | - | 1 | 3 | - | - | - | - | 4 | 4 | 8 | 8 | 8 | 60 | 4-ch ESD ±15kV 0.5pF U-DFN-10 [Texas Instruments] | Yes | ✔ |
| PM: D4 | SMBJ18A-Q | 118-SMBJ18A-QCT-ND | 652-SMBJ18A-Q | C1979859 (Extended) | - | 1 | - | - | - | - | - | - | - | - | - | - | 1 | 18V 600W unidirectional TVS SMB (DO-214AA) [Bourns] | Yes | ✔ |
| PM: D5,D6; CTL: D1 | BAT54 | 4878-BAT54CT-ND | 637-BAT54 | C49435667 | - | 2 | 1 | - | - | - | - | - | - | - | - | - | 3 | Schottky SOT-23 [Diotec] | Yes | ✔ |
| PM: F1 | AC72ABD | AC72ABD-ND | 652-AC72ABD | C17468669 | - | 1 | - | - | - | - | - | - | - | - | - | - | 1 | 72°C SMD Thermal Cutoff [Bourns]; No PCB footprint — component is laser/spot-welded to battery cell tabs; not suitable for PCB mounting per Bourns datasheet | No | N/A |
| PM: FB1 | BMC-Q2AY0600M (2-2176748-1) | 1712-2-2176748-1CT-ND | 279-BMC-Q2AY0600M | - | Global sourcing / consignment | 1 | - | - | - | - | - | - | - | - | - | - | 1 | 600Ω ±25% @100MHz ferrite bead 0805 AEC-Q200 Gr.1 [TE Connectivity] | Yes | ✔ |
| PM: J1-J3 | 1123684-7 | A114780-ND | 571-1123684-7 | C3683043 (consignment - see BOM Notes) | - | 3 | - | - | - | - | - | - | - | - | - | - | 3 | 10-pos 2.5mm RA plug [TE Connectivity] | Yes | ✔ |
| PM: J4 | 0436500519 | WM14587-ND | 538-43650-0519 | C563849 | - | 1 | - | - | - | - | - | - | - | - | - | - | 1 | 5-pin Micro-Fit 3.0 THT vertical [Molex] | Yes | ✔ |
| PM: J5 | USB4135-GF-A | 2073-USB4135-GF-ACT-ND | 640-USB4135-GF-A | C5438410 | - | 1 | - | - | - | - | - | - | - | - | - | - | 1 | USB-C right-angle SMT [GCT] | Yes | ✔ |
| PM: L1,L2 | 7448031002 | 732-5584-ND | 710-7448031002 | C1519839 | - | 2 | - | - | - | - | - | - | - | - | - | - | 2 | 10A 2mH nanocrystalline CMC THT [Wurth Elektronik] | Yes | ✔ |
| PM: L3 | SRP1265A-100M | SRP1265A-100MCT-ND | 652-SRP1265A-100M | C840531 | - | 1 | - | - | - | - | - | - | - | - | - | - | 1 | 10µH 15.5A Isat shielded SMT 13.5x12.5x6.2mm [Bourns] | Yes | ✔ |
| PM: Q1-Q3 | CSD17578Q5A | 296-48512-1-ND | 595-CSD17578Q5A | C2871447 | - | 3 | - | - | - | - | - | - | - | - | - | - | 3 | N-ch MOSFET 30V 10A SON-8 3.3x3.3mm [Texas Instruments] | Yes | ✔ |
| PM: Q4-Q10; USM: Q1-Q18 | BSS138 | BSS138CT-ND | 512-BSS138 | C52895 | - | 7 | - | - | 18 | - | - | - | - | - | - | - | 25 | N-ch MOSFET 50V 200mA SOT-23 [onsemi] | Yes | ✔ |
| PM: R1 | ERJ-3EKF2323V | P232KHCT-ND | 667-ERJ-3EKF2323V | C403086 | - | 1 | - | - | - | - | - | - | - | - | - | - | 1 | 232kΩ 1% 0603 [Panasonic] | Yes | ✔ |
| PM: R2 | ERJ-3EKF2872V | P28.7KHCT-ND | 667-ERJ-3EKF2872V | C403135 | - | 1 | - | - | - | - | - | - | - | - | - | - | 1 | 28.7kΩ 1% 0603 [Panasonic] | Yes | ✔ |
| PM: R3 | ERA-3VEB2100V | 10-ERA-3VEB2100VCT-ND | 667-ERA-3VEB2100V | C1861624 | - | 1 | - | - | - | - | - | - | - | - | - | - | 1 | 210Ω 0.1% 0603 [Panasonic] | Yes | ✔ |
| PM: R4,R7,R8,R13,R15,R22; CTL: R1-R4; USM: R1-R11 | ERJ-3EKF1002V | P10.0KHCT-ND | 667-ERJ-3EKF1002V | C191124 | - | 6 | 4 | - | 11 | - | - | - | - | - | - | - | 21 | 10kΩ 1% 0603 [Panasonic] | Yes | ✔ |
| PM: R5,R6 | ERJ-3EKF4701V | P4.70KHCT-ND | 667-ERJ-3EKF4701V | C192166 | - | 2 | - | - | - | - | - | - | - | - | - | - | 2 | 4.7kΩ 1% 0603 [Panasonic] | Yes | ✔ |
| PM: R9 | ERJ-3EKF3010V | P301HCT-ND | 667-ERJ-3EKF3010V | C403144 | - | 1 | - | - | - | - | - | - | - | - | - | - | 1 | 301Ω 1% 0603 [Panasonic] | Yes | ✔ |
| PM: R10,R16; STA: R1 | KRL6432T4-M-R010-F-T1 | KRL6432T4-M-R010-F-T1 | 754-KRL6432T4MR010FT | C4076514 | - | 2 | - | - | - | - | - | 1 | - | - | - | - | 3 | 10mΩ ±1% 2W 6432 (2512) Kelvin 4-terminal shunt [Susumu] | Yes | ✔ |
| PM: R11 | ERA-3ARB3012V | 10-ERA-3ARB3012VCT-ND | 667-ERA-3ARB3012V | C1728516 | - | 1 | - | - | - | - | - | - | - | - | - | - | 1 | 30.1kΩ 0.1% 0603 [Panasonic] | Yes | ✔ |
| PM: R12 | ERA-3ARB103V | P10KBDCT-ND | 667-ERA-3ARB103V | C465746 | - | 1 | - | - | - | - | - | - | - | - | - | - | 1 | 10.0kΩ 0.1% 0603 [Panasonic] | Yes | ✔ |
| PM: R14 | ERJ-3EKF7153V | P715KHCT-ND | 667-ERJ-3EKF7153V | C403339 | - | 1 | - | - | - | - | - | - | - | - | - | - | 1 | 715kΩ 1% 0603 [Panasonic] | Yes | ✔ |
| PM: R17 | ERJ-3EKF8662V | P86.6KHCT-ND | 667-ERJ-3EKF8662V | C403381 | - | 1 | - | - | - | - | - | - | - | - | - | - | 1 | 86.6kΩ 1% 0603 [Panasonic] | Yes | ✔ |
| PM: R18,R20,R27-R29,R32-R33,R36-R37; JDB: R5-R7; ENC: R2-R5; AM: R4,R5; STA: R2-R6,R13-R23,R36-R38; ROT-26: R1-R4; ROT-64: R1-R4 | ERJ-2RKF1002X | P10.0KLCT-ND | 667-ERJ-2RKF1002X | C191123 | - | 9 | - | 3 | - | 4 | 2 | 19 | - | - | 4 | 4 | 45 | 10kΩ 1% 0402 [Panasonic] | Yes | ✔ |
| PM: R19 | ERJ-2RKF8202X | P82.0KLCT-ND | 667-ERJ-2RKF8202X | C400641 | - | 1 | - | - | - | - | - | - | - | - | - | - | 1 | 82.0kΩ 1% 0402 [Panasonic] | Yes | ✔ |
| PM: R21 | ERJ-3EKF2743V | P274KHCT-ND | 667-ERJ-3EKF2743V | C403126 | - | 1 | - | - | - | - | - | - | - | - | - | - | 1 | 274kΩ 1% 0603 [Panasonic] | Yes | ✔ |
| PM: R23 | ERA-2AEB3322X | P33.2KDCCT-ND | 667-ERA-2AEB3322X | C2087909 | - | 1 | - | - | - | - | - | - | - | - | - | - | 1 | 33.2kΩ 1% 0402 [Panasonic] | Yes | ✔ |
| PM: R24-R26,R30-R31; USM: R12-R17,R54-R65 | ERJ-2RKF1001X | P1.00KLCT-ND | 667-ERJ-2RKF1001X | C242161 | - | 5 | - | - | 18 | - | - | - | - | - | - | - | 23 | 1kΩ 1% Thick-Film 0402 [Panasonic] | Yes | ✔ |
| PM: R34-R35 | ERJ-2RKF5232X | P52.3KLCT-ND | 667-ERJ-2RKF5232X | - | Global sourcing | 2 | - | - | - | - | - | - | - | - | - | - | 2 | 52.3kΩ 1% 0402 [Panasonic] | Yes | ✔ |
| PM: R38-R41; USM: R78-R95 | ERJ-2RKF1003X | P100KLCT-ND | 667-ERJ-2RKF1003X | - | Global sourcing | 4 | - | - | 18 | - | - | - | - | - | - | - | 22 | 100kΩ 1% 0402; no JLCPCB stock [Panasonic] | Yes | ✔ |
| PM: R42-R46; STA: R39,R40 | ERJ-2RKF10R0X | P10.0LCT-ND | 667-ERJ-2RKF10R0X | C413044 | - | 5 | - | - | - | - | - | 2 | - | - | - | - | 7 | 10Ω 1% Thin-Film 0402 [Panasonic] | Yes | ✔ |
| PM: SW1 | 4660 | 1528-4660-ND | 485-4660 | - | Global sourcing | 1 | - | - | - | - | - | - | - | - | - | - | 1 | 16mm panel latching RGB metal switch [Adafruit] | N/A | N/A |
| PM: SW2 | 3350 | 1528-2546-ND | 485-3350 | - | Global sourcing | 1 | - | - | - | - | - | - | - | - | - | - | 1 | 16mm panel momentary RGB metal switch [Adafruit] | N/A | N/A |
| PM: BT_SW1_1-6,BT_SW2_1-6 | 1211 | 36-1211-ND | 534-1211 | C3029550 | - | 2 | - | - | - | - | - | - | - | - | - | - | 2 | 2.8mm PCB male spade tabs THT Quick-Fit [Keystone Electronics] | Yes | ✔ |
| PM: U1 | TPS259804ONRGER | 296-TPS259804ONRGERCT-ND | 595-TPS259804ONRGER | C2878936 | - | 1 | - | - | - | - | - | - | - | - | - | - | 1 | eFuse 16.9V fixed OVLO VQFN-24 4x4mm; variant-locked [Texas Instruments] | Yes | ✔ |
| PM: U2A,U2B | LMQ61460AFSQRJRRQ1 | 296-LMQ61460AFSQRJRRQ1CT-ND | 595-LMQ61460AFSQRJRRQ1 | C1518767 | - | 2 | - | - | - | - | - | - | - | - | - | - | 2 | 5V buck x2 180° interleaved VQFN-HR 14-pin 4x3.5mm [Texas Instruments] | Yes | ✔ |
| PM: U3 | LTC3350EUHF#PBF | 505-LTC3350EUHF#PBF-ND | 584-LTC3350EUHF#PBF | C580711 | - | 1 | - | - | - | - | - | - | - | - | - | - | 1 | Supercap manager QFN-38 5x7mm [Analog Devices] | Yes | ✔ |
| PM: U4 | TPS25751DREFR | 296-TPS25751DREFRCT-ND | 595-TPS25751DREFR | C30169739 | - | 1 | - | - | - | - | - | - | - | - | - | - | 1 | PD3.1 DRP controller WQFN-38 6x4mm [Texas Instruments] | Yes | ✔ |
| PM: U5 | STUSB4500LQTR | 497-STUSB4500LQCT-ND | 511-STUSB4500LQTR | C506650 | - | 1 | - | - | - | - | - | - | - | - | - | - | 1 | USB-C sink controller QFN-24 [STMicroelectronics] | Yes | ✔ |
| PM: U6a,U6b,U6c | LM74700QDBVRQ1 | 296-LM74700QDBVRQ1CT-ND | 595-LM74700QDBVRQ1 | C2941042 | - | 3 | - | - | - | - | - | - | - | - | - | - | 3 | OR-ing controller SOT-23-6 [Texas Instruments] | Yes | ✔ |
| PM: U7 | TPS75733KTTRG3 | 296-50559-1-ND | 595-TPS75733KTTRG3 | C3749924 | - | 1 | - | - | - | - | - | - | - | - | - | - | 1 | 3.3V LDO fixed TO-263 5-pin [Texas Instruments] | Yes | ✔ |
| PM: U8 | MCP121T-450E/LB | MCP121T-450E/LBCT-ND | 579-MCP121T-450E/LB | C625189 | - | 1 | - | - | - | - | - | - | - | - | - | - | 1 | 4.5V voltage supervisor SC70-3 [Microchip Technology] | Yes | ✔ |
| PM: U9,U13 | MIC1555YM5-TR | 576-2576-1-ND | 998-MIC1555YM5TR | C145373 | - | 2 | - | - | - | - | - | - | - | - | - | - | 2 | CMOS timer SOT-23-5 [Microchip Technology] | Yes | ✔ |
| PM: U10; STA: U2 | INA219AIDR | 296-23978-1-ND | 595-INA219AIDR | C138706 | - | 1 | - | - | - | - | - | 1 | - | - | - | - | 2 | Current monitor I²C SOIC-8 [Texas Instruments] | Yes | ✔ |
| PM: U11,U12,U15 | NL27WZ14DFT2G-Q | 488-NL27WZ14DFT2G-QCT-ND | 863-NL27WZ14DFT2G-Q | C24511261 | - | 3 | - | - | - | - | - | - | - | - | - | - | 3 | Dual Schmitt-trigger inverter SC-88 [onsemi] | Yes | ✔ |
| PM: U14 | PCA9534APWR | 296-21760-1-ND | 595-PCA9534APWR | C2871127 | - | 1 | - | - | - | - | - | - | - | - | - | - | 1 | 8-bit I²C GPIO expander 0x3F TSSOP-16 [NXP Semiconductors] | Yes | ✔ |
| PM: U16 | SN74LVC1G175DBVR | 296-17617-1-ND | 595-SN74LVC1G175DBVR | C128412 | - | 1 | - | - | - | - | - | - | - | - | - | - | 1 | D-type flip-flop shutdown latch SOT-23-6 [Texas Instruments] | Yes | ✔ |
| PM: U17; STA: U3 | SN74LVC1G08DBVR | 296-11601-1-ND | 595-SN74LVC1G08DBVR | C7666 | - | 1 | - | - | - | - | - | 1 | - | - | - | - | 2 | Single AND gate SOT-23-5 [Texas Instruments] | Yes | ✔ |
| CTL: BT1 | 3034TR | 36-3034CT-ND | 534-3034TR | C5213768 | - | - | 1 | - | - | - | - | - | - | - | - | - | 1 | CR2032 holder SMD horizontal [Keystone Electronics]; Footprint adapted from KiCAD 10.0 standard library (unofficial, not manufacturer-supplied) | Yes* | Yes* |
| CTL: C17 | C0402C103K1RACAUTO | 399-C0402C103K1RACAUTOCT-ND | 80-C0402C103K1RAUTO | C19862710 | - | - | 1 | - | - | - | - | - | - | - | - | - | 1 | 10nF 100V X7R 0402 [Kemet] | Yes | Pending |
| PM: C20; CTL: C1-C5,C7-C11; USM: C5-C14; ENC: C9-C13; AM: C5; STA: C9-C13,C22-C26; REF: C1-C5; EXT: C1-C5,C7-C11; ROT-26: C10-C14; ROT-64: C10-C14 | CL21B106KAYQNNE | 1276-CL21B106KAYQNNECT-ND | 187-CL21B106KAYQNNE | C3039694 | - | 1 | 10 | - | 10 | 5 | 1 | 10 | 5 | 10 | 5 | 5 | 77 | 10µF X7R 25V 0805 [Samsung] | Yes | ✔ |
| CTL: J1-J3 | 1-1674231-1 | A119250-ND | 571-1-1674231-1 | C3683260 | - | - | 3 | - | - | - | - | - | - | - | - | - | 3 | 10-pos 2.5mm receptacle vertical [TE Connectivity] | Yes | ✔ |
| CTL: J4,J5 | 2195630015 | 900-2195630015-ND | 538-219563-0015 | - | Global sourcing | - | 2 | - | - | - | - | - | - | - | - | - | 2 | 5-pwr+15-sig press-fit receptacle hybrid [Molex] | Yes | ✔ |
| CTL: J6 | 48406-0003 | WM10420-ND | 538-48406-0003 | C565298 | - | - | 1 | - | - | - | - | - | - | - | - | - | 1 | USB 3.0 Type-A dual-stack [Molex] | Yes | ✔ |
| CTL: J7 | 2007435-1 | A141617-ND | 571-2007435-1 | C195051 | - | - | 1 | - | - | - | - | - | - | - | - | - | 1 | HDMI Type-A full-size [TE Connectivity] | Yes | ✔ |
| CTL: J8 | 7499111121A | 1297-1070-5-ND | 710-7499111121A | C5523983 | - | - | 1 | - | - | - | - | - | - | - | - | - | 1 | RJ45 w/ magnetics/PoE long-body THT [Wurth Elektronik] | Yes | ✔ |
| CTL: J9 | F52Q-1A7H1-11015 | 609-F52Q-1A7H1-11015CT-ND | 649-F52Q-1A7H1-11015 | C3169095 | - | - | 1 | - | - | - | - | - | - | - | - | - | 1 | DSI1 15-pin 1.0mm ZIF [Amphenol] | Yes | ✔ |
| CTL: J10 | SM04B-SRSS-TB(LF)(SN) | 455-SM04B-SRSS-TBCT-ND | 306-SM04BSRSSTBLFSN | C160404 | - | - | 1 | - | - | - | - | - | - | - | - | - | 1 | 4-pin SH 1.0mm fan SMT [JST] | Yes | ✔ |
| STA: J1,J2; EXT: J4,J5; ROT-26: J4,J5; ROT-64: J4,J5 | ERF8-005-05.0-S-DV-K-TR | SAM13517CT-ND | 200-ERF8005050SDVKTR | C7273978 | - | - | - | - | - | - | - | 2 | - | 2 | 2 | 2 | 14 | 10-pin 2x5 0.8mm female SMT [Samtec] | Yes | ✔ |
| ROT-26: J7,J8,J9; ROT-64: J7,J8,J9 | RS1-05-G | 2057-RS1-05-G-ND | 737-RS1-05-G | C3321119 | - | - | - | - | - | - | - | - | - | - | 3 | 3 | 15 | 1x5 2.54mm female socket THT [Adam Tech] | Yes | ✔ |
| CTL: J14,J15 | 10164227-1004A1RLF | 609-10164227-1004A1RLFCT-ND | 649-101642271004RLF | C7435219 | - | - | 2 | - | - | - | - | - | - | - | - | - | 2 | CM5 SO-DIMM 100-pin 4mm [Amphenol] | Yes | ✔ |
| CTL: MH1-MH4 | 9774040151R | 732-7089-1-ND | 710-9774040151R | C5182034 | - | - | 4 | - | - | - | - | - | - | - | - | - | 4 | M2.5x4.0mm SMT standoff [Wurth Elektronik] | Yes | ✔ |
| CTL: T1 | POE600F-12L | N/A | N/A | N/A | - | - | 1 | - | - | - | - | - | - | - | - | - | 1 | PoE transformer 1500V 12-pin SMT; only available direct from Coilcraft [Coilcraft] | Yes | ✔ |
| CTL: U1 | CM5 | - | - | - | - | - | 1 | - | - | - | - | - | - | - | - | - | 1 | CM5 module SO-DIMM [Raspberry Pi Ltd] | N/A | N/A |
| CTL: U2 | TPS2065CDBVR | 296-39353-1-ND | 595-TPS2065CDBVR | C353882 | - | - | 1 | - | - | - | - | - | - | - | - | - | 1 | USB power switch SOT-23-5 [Texas Instruments] | Yes | ✔ |
| CTL: U3 | AP2331W-7 | AP2331W-7DICT-ND | 621-AP2331W-7 | C460346 | - | - | 1 | - | - | - | - | - | - | - | - | - | 1 | HDMI power switch SOT-23-5 [Diodes Inc] | Yes | ✔ |
| CTL: U7 | TPS2372-4RGWR | 296-45285-1-ND | 595-TPS2372-4RGWR | C470955 | - | - | 1 | - | - | - | - | - | - | - | - | - | 1 | PoE PD interface VQFN-24 4x4mm [Texas Instruments] | Yes | ✔ |
| CTL: U8 | TPS23730RMTR | 296-TPS23730RMTRCT-ND | 595-TPS23730RMTR | C3189530 | - | - | 1 | - | - | - | - | - | - | - | - | - | 1 | PoE auxiliary controller WSON-10 3x3mm [Texas Instruments] | Yes | ✔ |
| JDB: C5; AM: C4 | CGA6P3X7R1H475K250AD | 445-10040-1-ND | 810-CGA6P3X7R1H475KD | C3877549 | - | - | - | 1 | - | - | 1 | - | - | - | - | - | 2 | 4.7µF X7R 50V 1210 [TDK] | Yes | Pending |
| JDB: C10,C11 | C0402C330J5GAUTO | 399-12979-1-ND | 80-C0402C330J5GAUTO | C2169327 | - | - | - | 2 | - | - | - | - | - | - | - | - | 2 | 33pF C0G/NP0 crystal load 0402; C0G/NP0 exception approved [Kemet] | Yes | Pending |
| AM: J2-J5; ROT-26: J11,J12,J13; ROT-64: J11,J12,J13 | PH1-05-UA | 2057-PH1-05-UA-ND | 737-PH1-05-UA | C5374051 | - | - | - | - | - | - | 4 | - | - | - | 3 | 3 | 10 | 1x5 2.54mm male THT [Adam Tech] | Yes | ✔ |
| JDB: R1-R4 | ERJ-2RKF33R0X | P33.0LCT-ND | 667-ERJ-2RKF33R0X | C278594 | - | - | - | 4 | - | - | - | - | - | - | - | - | 4 | 33Ω 1% 0402; see DEC-016, DEC-024 [Panasonic] | Yes | ✔ |
| JDB: U1 | FT232HL-REEL | 768-1101-1-ND | 895-FT232HL-REEL | C51997 | - | - | - | 1 | - | - | - | - | - | - | - | - | 1 | USB 2.0 to MPSSE bridge LQFP-48 [FTDI Chip] | Yes | ✔ |
| JDB: U2; EXT: U1 | SN74LVC2G125DCUR | 296-SN74LVC2G125DCURCT-ND | 595-SN74LVC2G125DCUR | C21404 | - | - | - | 1 | - | - | - | - | - | 1 | - | - | 2 | Dual 3-state buffer VSSOP-8 [Texas Instruments] | Yes | ✔ |
| JDB: Y1 | 435F12012IET | 110-435F12012IETTR-ND | 774-435F12012IET | C19766404 (Extended) | - | - | - | 1 | - | - | - | - | - | - | - | - | 1 | 12MHz 20pF ±20ppm crystal SMD-5032 (5.0×3.2×1.1mm); see DEC-022 [CTS]; BOM description corrected from SMD-3225 to SMD-5032 per CTS 435 datasheet; unofficial footprint adapted from KiCAD 10.0 Crystal_SMD_5032-4Pin standard; 3D model approximated from 2-pin 5032 STEP (same body) | Yes* | Yes* |
| USM: D1-D12 | WP154A4SEJ3VBDZGW/CA | 754-2029-ND | 604-WP154A43VBDZGWCA | C7151795 | - | - | - | - | 12 | - | - | - | - | - | - | - | 12 | 5mm common-anode RGB THT [Kingbright] | Yes | Pending |
| USM: J1; STA: J13 | B6B-PH-K-S(LF)(SN) | 455-1708-ND | 306-B6B-PH-K-SLFSN | C131342 | - | - | - | - | 1 | - | - | 1 | - | - | - | - | 2 | 6-pin JST PH 2.0mm THT [JST] | Yes | ✔ |
| USM: Q19-Q30 | SQ2319ADS-T1_BE3 | 742-SQ2319ADS-T1_BE3CT-ND | 78-SQ2319ADS-T1_BE3 | C3280190 | - | - | - | - | 12 | - | - | - | - | - | - | - | 12 | P-MOSFET AEC-Q101 SOT-23 [Vishay] | Yes | Pending |
| USM: R18-R29 | ERJ-3EKF1500V | P150HCT-ND | 667-ERJ-3EKF1500V | C400650 | - | - | - | - | 12 | - | - | - | - | - | - | - | 12 | 150Ω 1% 0603 [Panasonic] | Yes | Pending |
| USM: R30-R53 | ERJ-3EKF1000V | P100HCT-ND | 667-ERJ-3EKF1000V | C193336 | - | - | - | - | 24 | - | - | - | - | - | - | - | 24 | 100Ω 1% 0603 [Panasonic] | Yes | Pending |
| USM: R66-R77 | SG73S1ERTTP4702D | 2019-SG73S1ERTTP4702DTR-ND | 660-SG73S1ERTTP4702D | C5915648 (MOQ 40) | - | - | - | - | 12 | - | - | - | - | - | - | - | 12 | 47kΩ ±0.5% AEC-Q200 0402; JLCPCB MOQ 40 [KOA Speer] | Yes | Pending |
| USM: SW1-SW10 | 200MSP1T2B4M2QE | EG5525-ND | 612-200MSP1T2B4M2QE | C5491263 | - | - | - | - | 10 | - | - | - | - | - | - | - | 10 | SPDT latching toggle panel-mount THT [E-Switch] | Yes | Pending |
| USM: SW11; AM: SW1,SW2 | B3F-1070 | SW406-ND | 653-B3F-1070 | C726011 | - | - | - | - | 1 | - | 2 | - | - | - | - | - | 3 | SPST NO tactile THT [Omron] | Yes | ✔ |
| USM: U1-U3; STA: U6-U8 | MCP23017T-E/SO | MCP23017T-E/SOCT-ND | 579-MCP23017T-E/SO | C47023 | - | - | - | - | 3 | - | - | 3 | - | - | - | - | 6 | I²C GPIO expander SOIC-28 [Microchip Technology] | Yes | ✔ |
| ENC: J3-J66 | 1285-ST | 36-1285-ST-ND | 534-1285-ST | C5370868 | - | - | - | - | - | 64 | - | - | - | - | - | - | 64 | 6.35mm PCB spade blade terminals THT vertical [Keystone Electronics] | Yes | Pending |
| ENC: D1; AM: D1-D3 | 150060VS75000 | 732-4980-1-ND | 710-150060VS75000 | C6848499 | - | - | - | - | - | 1 | 3 | - | - | - | - | - | 4 | Green SMD LED Vf≈2.0V 0402 [Wurth Elektronik] | Yes | ✔ |
| ENC: J1 | (no standard MPN) | - | - | - | eBay SaiBuy.Ltd | - | - | - | - | 1 | - | - | - | - | - | - | 1 | 6.35mm mono jack sockets panel-mount [generic]; eBay SaiBuy.Ltd | N/A | N/A |
| ENC: J2; STA: J4-J9 | BHR-20-VUA | 2057-BHR-20-VUA-ND | 737-BHR-20-VUA | C17340054 | - | - | - | - | - | 1 | - | 6 | - | - | - | - | 7 | 20-pin 2x10 2.54mm shrouded box THT [Adam Tech] | Yes | ✔ |
| STA: J10; REF: J4; EXT: J7,J8 | 2BHR-30-VUA | 2057-2BHR-30-VUA-ND | 737-2BHR-30-VUA | C17346400 | - | - | - | - | - | - | - | 1 | 1 | 2 | - | - | 4 | 30-pin 2x15 2.54mm shrouded box THT [Adam Tech]. Per DEC-053 | No | Pending |
| ENC: R1; AM: R1-R3 | ERJ-2RKF3300X | P330LCT-ND | 667-ERJ-2RKF3300X | C278592 | - | - | - | - | - | 1 | 3 | - | - | - | - | - | 4 | 330Ω 1% 0402 [Panasonic] | Yes | ✔ |
| ENC: R6; STA: R7-R12,R24-R35 | ERJ-2RKF75R0X | P75.0LCT-ND | 667-ERJ-2RKF75R0X | C413061 | - | - | - | - | - | 1 | - | 18 | - | - | - | - | 19 | 75Ω 1% 0402 [Panasonic] | Yes | ✔ |
| ENC: SW1-SW40 | (no standard MPN) | - | - | - | eBay gadgetskingdom | - | - | - | - | 40 | - | - | - | - | - | - | 40 | DPDT 6-pin momentary switches panel-mount [generic]; eBay gadgetskingdom | N/A | N/A |
| ENC: U1; STA: U1; ROT-26: U1; ROT-64: U1 | EPM570T100I5N | 544-2281-ND | 989-EPM570T100I5N | C27319 | - | - | - | - | - | 1 | - | 1 | - | - | 1 | 1 | 7 | MAX II 570 LEs CPLD TQFP-100 [Intel (Altera)] | Yes | ✔ |
| REF: J1,J2; EXT: J1,J2; ROT-26: J1,J2; ROT-64: J1,J2 | ERM8-005-05.0-S-DV-K-TR | 612-ERM8-005-05.0-S-DV-K-TRCT-ND | 200-ERM8005050SDVKTR | C3649741 | - | - | - | - | - | - | - | - | 2 | 2 | 2 | 2 | 14 | 10-pin 2x5 0.8mm male SMT [Samtec] | Yes | ✔ |
| CTL: J11, J12; EXT: J9 | DF40HC(3.5)-20DS-0.4V(51) | 26-DF40HC(3.5)-20DS-0.4V(51)CT-ND | 798-DF40HC3520DS04V5 | C3644774 | - | - | 2 | - | - | - | - | - | - | 1 | - | - | 3 | 20-pin 0.4mm pitch BtB receptacle 3.5mm stack [Hirose] | Yes | ✔ |
| AM: J1; JDB: J1 | DF40C-20DP-0.4V(51) | H11618CT-ND | 798-DF40C20DP0.4V51 | C424637 | - | - | - | 1 | - | - | 1 | - | - | - | - | - | 2 | 20-pin 0.4mm pitch BtB plug [Hirose] | Yes | ✔ |
| CTL: MH5-MH8, MH13-MH16; EXT: MH5-MH8 | 9774035151R | 732-9774035151RCT-ND | 710-9774035151R | C22367582 | - | - | 8 | - | - | - | - | - | - | 4 | - | - | 12 | M2.5x3.5mm SMT standoff [Wurth Elektronik] | Yes | ✔ |
| AM: U1 | STM32G071K8T3TR | 497-STM32G071K8T3TR-ND | 511-STM32G071K8T3TR | - | Global sourcing | - | - | - | - | - | 1 | - | - | - | - | - | 1 | Local actuation controller LQFP32; JLCPCB consignment only [STMicroelectronics] | Yes | ✔ |
| STA: J3; EXT: J6; ROT-26: J6; ROT-64: J6 | ERF8-010-05.0-S-DV-K-TR | SAM8618CT-ND | 200-ERF8010050SDVKTR | C3646170 | - | - | - | - | - | - | - | 1 | - | 1 | 1 | 1 | 7 | 20-pin 2x10 0.8mm female SMT [Samtec] | Yes | ✔ |
| STA: J11,J12 | 2195620015 | 900-2195620015-ND | 538-219562-0015 | - | Global sourcing | - | - | - | - | - | - | 2 | - | - | - | - | 2 | 5-pwr+15-sig hybrid plug [Molex] | Yes | ✔ |
| STA: L1-L4 | HI1206P121R-10 | 240-2410-1-ND | 875-HI1206P121R-10 | C2442103 | - | - | - | - | - | - | - | 4 | - | - | - | - | 4 | 120Ω @100MHz 4.0A 1206 ferrite bead [Laird Performance Materials] | Yes | ✔ |
| STA: U4,U5 | 74HC157PW-Q100,118 | 1727-74HC157PW-Q100,118CT-ND | 771-74HC157PWQ100118 | C546614 | - | - | - | - | - | - | - | 2 | - | - | - | - | 2 | Quad 2-to-1 mux TSSOP-16 [Nexperia] | Yes | ✔ |
| REF: J3; EXT: J3; ROT-26: J3; ROT-64: J3 | ERM8-010-05.0-S-DV-K-TR | SAM8610CT-ND | 200-ERM8010050SDVKTR | C374877 | - | - | - | - | - | - | - | - | 1 | 1 | 1 | 1 | 7 | 20-pin 2x10 0.8mm male SMT [Samtec] | Yes | ✔ |
| REF: R1 | ERJ-3EKF2200V | P220HCT-ND | 667-ERJ-3EKF2200V | C403073 | - | - | - | - | - | - | - | - | 1 | - | - | - | 1 | 22Ω 1% 0603 [Panasonic] | Yes | ✔ |
| ROT-26: C15,C21A; ROT-64: C15,C21B | KAM05CR71A105KH | 478-KAM05CR71A105KHCT-ND | 581-KAM05CR71A105KH | - | Global sourcing | - | - | - | - | - | - | - | - | - | 2 | 2 | 10 | 1µF X7R ±10% 10V AEC-Q200 0402 [Kyocera AVX] | Yes | ✔ |
| ROT-26: C16-C19,C22A-C25A; ROT-64: C16-C19,C22B-C25B | AC0402FRNPO9BN330 | 13-AC0402FRNPO9BN330CT-ND | 603-0402FRNPO9BN330 | C1852937 | - | - | - | - | - | - | - | - | - | - | 8 | 8 | 40 | 33pF C0G/NP0 ±1% 50V AEC-Q200 0402 [YAGEO] | Yes | ✔ |
| ROT-26: J14; ROT-64: J14 | PH1-07-UA | 2057-PH1-07-UA-ND | 737-PH1-07-UA | C3331618 | - | - | - | - | - | - | - | - | - | - | 1 | 1 | 5 | 1x7 2.54mm male THT [Adam Tech] | Yes | ✔ |
| ROT-26: L1-L4,L5A-L8A; ROT-64: L1-L4,L5B-L8B | CWF1610A-180K | 118-CWF1610A-180KCT-ND | 652-CWF1610A-180K | - | Global sourcing | - | - | - | - | - | - | - | - | - | 8 | 8 | 40 | 18µH ±10% SRF 28MHz 0603 [Bourns] | Yes | ✔ |
| ROT-26: R5,R6; ROT-64: R5,R6 | SG73S1ERTTP4701F | 2019-SG73S1ERTTP4701FTR-ND | 660-SG73S1ERTTP4701F | C6483673 | - | - | - | - | - | - | - | - | - | - | 2 | 2 | 10 | 4.7kΩ ±1% AEC-Q200 0402 [KOA Speer] | Yes | ✔ |
| ROT-26: SW1,SW2,SW3; ROT-64: SW1,SW2,SW3 | 219-6LPSTR | 119-219-6LPSTRCT-ND | 774-2196LPSTR | C2842671 | - | - | - | - | - | - | - | - | - | - | 3 | 3 | 15 | 6-pos DIP switch 2.54mm THT [CTS] | Yes | ✔ |
| ROT-26: U2,U11A; ROT-64: U2,U11B | FDC2114RGHR | FDC2114RGHR-ND | 595-FDC2114RGHR | C2652079 | - | - | - | - | - | - | - | - | - | - | 2 | 2 | 10 | 4-ch cap sensor I²C 16-VQFN; JLCPCB MOQ 2 [Texas Instruments] | Yes | ✔ |
| ROT-26: J10; ROT-64: J10 | RS1-07-G | 2057-RS1-07-G-ND | 737-RS1-07-G | C3321543 | - | - | - | - | - | - | - | - | - | - | 1 | 1 | 5 | 1x7 2.54mm female socket THT [Adam Tech] | Yes | ✔ |
