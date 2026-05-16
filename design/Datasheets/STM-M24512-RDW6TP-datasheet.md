# • Compatible with following I 2C bus modes

## Source

- **Source PDF:** [STM-M24512-RDW6TP-datasheet.pdf](STM-M24512-RDW6TP-datasheet.pdf)
- **Generated Markdown:** `STM-M24512-RDW6TP-datasheet.md`
- **Page count:** 47
- **Conversion method:** automated local PDF text extraction with pypdf/pdfplumber

## PDF Metadata

| Field | Value |
| :--- | :--- |
| Title | Datasheet - M24512-W M24512-R M24512-DF - 512-Kbit serial I²C bus EEPROM |
| Author | STMICROELECTRONICS |
| Subject | The M24512 is a 512-Kbit I2C-compatible EEPROM (Electrically Erasable PROgrammable Memory) organized as 64 K × 8 bits. The M24512-W can operate with a supply voltage from 2.5 V to 5.5 V, the M24512-R can operate with a supply voltage from 1.8 V to 5.5 V and the M24512-DF can operate with a supply voltage from 1.7 V to 5.5 V. All these devices operate with a clock frequency of 1 MHz (or less) over an ambient temperature range of -40 °C / +85 °C. |
| Creator | C2 v4.2.0220 build 670 - c2_rendition_config : Techlit_Active |
| Producer | Antenna House PDF Output Library 6.5.1119 (Windows (x64)); modified using iText 2.1.7 by 1T3XT |

## Extracted Technical Index

This markdown datasheet is meant to reduce the need to reopen the PDF during design work.
It preserves design-relevant extracted snippets first, followed by page-by-page text so the source content remains locally searchable.

### Part number and ordering information

- DS6520 - Rev 31 page 2/47 / Figure 3. WLCSP connections / Marking  side / (top view) / Bump  side
- DC and AC parameters / DS6520 - Rev 31 page 28/47 / 9 Package information / In order to meet environmental requirements, ST offers these devices in different grades of ECOPACK® / packages, depen…
- For die information concerning the M24512-W delivered in unsawn wafer, please contact your nearest ST Sales / Office. / 9.1 UFDFPN8 (DFN8) package information / UFDFPN8 is an 8-lead, 2 × 3 mm, 0…
- Top view / Pin #1 / ID marking / Side view / Seating plane
- e/2 / Pin #1 / ID marking / Bottom view See Detail “A” / e
- (not connected) in the end application. / M24512-W M24512-R M24512-DF / Package information / DS6520 - Rev 31 page 29/47 / Table 19. UFDFPN8 - Mechanical data
- 1. Dimensions are expressed in millimeters. / M24512-W M24512-R M24512-DF / UFDFPN8 (DFN8) package information / DS6520 - Rev 31 page 30/47 / 9.2 TSSOP8 package information
- UFDFPN8 (DFN8) package information / DS6520 - Rev 31 page 30/47 / 9.2 TSSOP8 package information / TSSOP8 is an 8 lead thin shrink small outline, 3 x 6.4 mm, 0.65 mm pitch, package. / Figure 17.…
- M24512-W M24512-R M24512-DF / TSSOP8 package information / DS6520 - Rev 31 page 31/47 / Figure 18. TSSOP8 – Recommended footprint
- 1. Dimensions are expressed in millimeters. / M24512-W M24512-R M24512-DF / TSSOP8 package information / DS6520 - Rev 31 page 32/47 / 9.3 SO8N package information
- TSSOP8 package information / DS6520 - Rev 31 page 32/47 / 9.3 SO8N package information / SO8N is an 8 lead, 4.9 x 6 mm, plastic small outline, 150 mils body width, package. / Figure 19. SO8N – O…
- M24512-W M24512-R M24512-DF / SO8N package information / DS6520 - Rev 31 page 33/47 / Figure 20. SO8N - Recommended footprint
- 1. Dimensions are expressed in millimeters. / M24512-W M24512-R M24512-DF / SO8N package information / DS6520 - Rev 31 page 34/47 / 9.4 WLCSP8 (CS) package information
- SO8N package information / DS6520 - Rev 31 page 34/47 / 9.4 WLCSP8 (CS) package information / WLCSP8 is a 8 bumps, 1.289 x 1.955 mm, 0.5 mm pitch wafer level chip scale package / Figure 21.  WLC…
- 4. Bump position designation per JESD 95-1, SPP-010. / M24512-W M24512-R M24512-DF / WLCSP8 (CS) package information / DS6520 - Rev 31 page 35/47 / Table 22. WLCSP8 - Mechanical data
- 1. Dimensions are expressed in millimeters. / M24512-W M24512-R M24512-DF / WLCSP8 (CS) package information / DS6520 - Rev 31 page 36/47 / 9.5 WLCSP8 (CU) package information
- WLCSP8 (CS) package information / DS6520 - Rev 31 page 36/47 / 9.5 WLCSP8 (CU) package information / This WLCSP is a 8 balls, 1.289 x 1.955 mm, 0.5 mm pitch, with BSC, wafer level chip scale pac…
- 4. Bump position designation per JESD 95-1, SPP-010. / M24512-W M24512-R M24512-DF / WLCSP8 (CU) package information / DS6520 - Rev 31 page 37/47 / Table 23. WLCSP8 - Mechanical data
- 1. Dimensions are expressed in millimeters. / M24512-W M24512-R M24512-DF / WLCSP8 (CU) package information / DS6520 - Rev 31 page 38/47 / 10 Ordering information
- WLCSP8 (CU) package information / DS6520 - Rev 31 page 38/47 / 10 Ordering information / Table 24. Ordering information scheme / Example: M24 512 - D W MC 6 T P /K

### Pin, pad, and connection designations

- SCL / VSS / Table 1. Signal names / Signal name Function Direction / E2, E1, E0 Chip enable Input
- VSS / Table 1. Signal names / Signal name Function Direction / E2, E1, E0 Chip enable Input / SDA Serial data I/O
- VCC Supply voltage - / VSS Ground - / Figure 2. 8-pin package connections, top view / SDAVSS / SCL
- Description / DS6520 - Rev 31 page 2/47 / Figure 3. WLCSP connections / Marking  side / (top view)
- E0 / WC / Table 2. Signal vs. bump position / Position A B C D E / 1 SDA - E2 - VSS
- Description / DS6520 - Rev 31 page 3/47 / 2 Signal description / 2.1 Serial clock (SCL) / The signal applied on the SCL input is used to strobe the data available on SDA(in) and to output the da…
- 2 Signal description / 2.1 Serial clock (SCL) / The signal applied on the SCL input is used to strobe the data available on SDA(in) and to output the data on / SDA(out). / 2.2 Serial data (SDA)
- 2.2 Serial data (SDA) / SDA is an input/output used to transfer data in or data out of the device. SDA(out) is an open drain output that / may be wire-OR’ed with other open drain or open collect…
- connected from serial data (SDA) to VCC (Figure 12 indicates how to calculate the value of the pull-up resistor). / 2.3 Chip enable (E2, E1, E0) / (E2,E1,E0) input signals are used to set the va…
- b1) of the 7-bit device select code (see Table 3). These inputs must be tied to VCC or VSS, as shown in Figure 4. / When not connected (left floating), these inputs are read as low (0). / Figure…
- Ei / 2.4 Write control (WC) / This input signal is useful for protecting the entire contents of the memory from inadvertent write operations. Write / operations are disabled to the entire memory…
- VSS is the reference for the VCC supply voltage. / M24512-W M24512-R M24512-DF / Signal description / DS6520 - Rev 31 page 4/47 / 2.6 Supply voltage (VCC)
- [VCC(min), VCC(max)] range must be applied (see Operating conditions in Section  8  DC and AC parameters). In / order to secure a stable DC supply voltage, it is recommended to decouple the VCC …
- DS6520 - Rev 31 page 6/47 / 4 Device operation / The device supports the I2C protocol. This is summarized in Figure 6. Any device that sends data on to the bus is / defined to be a transmitter, …
- During data input, the device samples serial data (SDA) on the rising edge of serial clock (SCL). For correct / device operation, serial data (SDA) must be stable during the rising edge of seria…
- 1. The most significant bit, b7, is sent first. / 2. E0, E1 and E2 are compared with the value read on input pins E0, E1 and E2. / When the device select code is received, the device only respon…
- DS6520 - Rev 31 page 14/47 / 5.2 Read operations / Read operations are performed independently of the state of the write control (WC) signal. / After the successful completion of a read operatio…
- specification, and the European directive on Restrictions of Hazardous Substances (RoHS directive 2011/65/EU of July / 2011). / 2. Positive and negative pulses applied on different combinations …
- Symbol Parameter(1) Test condition Min. Max. Unit / CIN Input capacitance (SDA) - - 8 pF / CIN Input capacitance (other pins) - - 6 pF / ZL / Input impedance (E2, E1, E0, WC)(2)
- tCLCH tLOW Clock pulse width low 1300 - ns / tQL1QL2(1) tF SDA (out) fall time 20(2) 300 ns / tXH1XH2 tR Input signal rise time (3) (3) ns / tXL1XL2 tF Input signal fall time (3) (3) ns / tDXCH …

### Specifications, ratings, and operating conditions

- – Page size: 128 byte / – Additional write lockable page (M24512-D order codes) / • Single supply voltage and high speed: / – 1 MHz clock from 1.7 V to 5.5 V / • Write time:
- The M24512 is a 512-Kbit I2C-compatible EEPROM (electrically erasable programmable memory) organized as / 64 K × 8 bits. / The M24512-W can operate with a supply voltage from 2.5 V to 5.5 V, the…
- 64 K × 8 bits. / The M24512-W can operate with a supply voltage from 2.5 V to 5.5 V, the M24512-R can operate with a supply / voltage from 1.8 V to 5.5 V, and the M24512-DF can operate with a su…
- SCL Serial clock Input / WC Write control Input / VCC Supply voltage - / VSS Ground - / Figure 2. 8-pin package connections, top view
- acknowledged. / 2.5 VSS (ground) / VSS is the reference for the VCC supply voltage. / M24512-W M24512-R M24512-DF / Signal description
- Signal description / DS6520 - Rev 31 page 4/47 / 2.6 Supply voltage (VCC) / 2.6.1 Operating supply voltage (VCC) / Prior to selecting the memory and issuing instructions to it, a valid and stabl…
- DS6520 - Rev 31 page 4/47 / 2.6 Supply voltage (VCC) / 2.6.1 Operating supply voltage (VCC) / Prior to selecting the memory and issuing instructions to it, a valid and stable VCC voltage within …
- 2.6 Supply voltage (VCC) / 2.6.1 Operating supply voltage (VCC) / Prior to selecting the memory and issuing instructions to it, a valid and stable VCC voltage within the specified / [VCC(min), V…
- Prior to selecting the memory and issuing instructions to it, a valid and stable VCC voltage within the specified / [VCC(min), VCC(max)] range must be applied (see Operating conditions in Sectio…
- order to secure a stable DC supply voltage, it is recommended to decouple the VCC line with a suitable capacitor / (usually of the order of 10 nF to 100 nF) close to the VCC/VSS package pins. / …
- instruction, until the completion of the internal write cycle (tW). / 2.6.2 Power-up conditions / The VCC voltage has to rise continuously from 0 V up to the minimum VCC operating voltage (see O…
- In order to prevent inadvertent write operations during power-up, a power-on-reset (POR) circuit is included. / At power-up, the device does not respond to any instruction until VCC has reached …
- Section  8  DC and AC parameters). When VCC passes over the POR threshold, the device is reset and enters / the standby power mode; however, the device must not be accessed until VCC reaches a v…
- parameters). / In a similar way, during power-down (continuous decrease in VCC), the device must not be accessed when VCC / drops below VCC(min). When VCC drops below the power-on-reset threshol…
- after decoding a stop condition, assuming that there is no internal write cycle in progress). / M24512-W M24512-R M24512-DF / Supply voltage (VCC) / DS6520 - Rev 31 page 5/47 / 3 Memory organiza…
- DS6520 - Rev 31 page 13/47 / 5.1.6 Minimizing write delays by polling on ACK / The maximum write time (tw) is shown in AC characteristics tables in Section  8  DC and AC parameters, but the / ty…
- Stop / Start / Current / Address / Read
- Dev sel \* Data out / Sequential / Current / Read / Stop
- with the RW bit set to 1. The device acknowledges this, and outputs the contents of the addressed byte. The bus / master must not acknowledge the byte, and terminates the transfer with a stop co…
- master must not acknowledge the byte, and terminates the transfer with a stop condition. / 5.2.2 Current address read / For the current address read operation, following a start condition, the b…

### Dimensions, package, and mechanical information

- • More than 4 million write cycles / • More than 200-years data retention / • Packages: / – SO8 ECOPACK2 ® / – TSSOP8 ECOPACK2 ®
- VCC Supply voltage - / VSS Ground - / Figure 2. 8-pin package connections, top view / SDAVSS / SCL
- [VCC(min), VCC(max)] range must be applied (see Operating conditions in Section  8  DC and AC parameters). In / order to secure a stable DC supply voltage, it is recommended to decouple the VCC …
- DC and AC parameters / DS6520 - Rev 31 page 28/47 / 9 Package information / In order to meet environmental requirements, ST offers these devices in different grades of ECOPACK® / packages, depen…
- 9 Package information / In order to meet environmental requirements, ST offers these devices in different grades of ECOPACK® / packages, depending on their level of environmental compliance. ECO…
- For die information concerning the M24512-W delivered in unsawn wafer, please contact your nearest ST Sales / Office. / 9.1 UFDFPN8 (DFN8) package information / UFDFPN8 is an 8-lead, 2 × 3 mm, 0…
- Office. / 9.1 UFDFPN8 (DFN8) package information / UFDFPN8 is an 8-lead, 2 × 3 mm, 0.5 mm thickness ultra thin profile fine pitch dual flat package / Figure 15. UFDFPN8 - Outline / Top view
- 9.1 UFDFPN8 (DFN8) package information / UFDFPN8 is an 8-lead, 2 × 3 mm, 0.5 mm thickness ultra thin profile fine pitch dual flat package / Figure 15. UFDFPN8 - Outline / Top view / Pin #1
- L / b / 1. Max. package war-page is 0.05 mm. / 2. Exposed copper is not systematic and can appear partially or totally according to the cross section. / 3. Drawing is not to scale.
- 1. Max. package war-page is 0.05 mm. / 2. Exposed copper is not systematic and can appear partially or totally according to the cross section. / 3. Drawing is not to scale. / 4. The central pad …
- (not connected) in the end application. / M24512-W M24512-R M24512-DF / Package information / DS6520 - Rev 31 page 29/47 / Table 19. UFDFPN8 - Mechanical data
- Package information / DS6520 - Rev 31 page 29/47 / Table 19. UFDFPN8 - Mechanical data / Symbol / millimeters inches(1)
- 1. Values in inches are converted from mm and rounded to 4 decimal digits. / 2. Dimension b applies to plated terminal and is measured between 0.15 and 0.30 mm from the terminal tip. / 3. Applie…
- 3. Applied for exposed die paddle and terminals. Exclude embedding part of exposed die paddle from measuring. / Figure 16. UFDFPN8 - Recommended footprint / 0.500 / 1.400
- 0.300 / 1.300 / 1. Dimensions are expressed in millimeters. / M24512-W M24512-R M24512-DF / UFDFPN8 (DFN8) package information
- 1. Dimensions are expressed in millimeters. / M24512-W M24512-R M24512-DF / UFDFPN8 (DFN8) package information / DS6520 - Rev 31 page 30/47 / 9.2 TSSOP8 package information
- UFDFPN8 (DFN8) package information / DS6520 - Rev 31 page 30/47 / 9.2 TSSOP8 package information / TSSOP8 is an 8 lead thin shrink small outline, 3 x 6.4 mm, 0.65 mm pitch, package. / Figure 17.…
- DS6520 - Rev 31 page 30/47 / 9.2 TSSOP8 package information / TSSOP8 is an 8 lead thin shrink small outline, 3 x 6.4 mm, 0.65 mm pitch, package. / Figure 17. TSSOP8 – Outline / 1
- 9.2 TSSOP8 package information / TSSOP8 is an 8 lead thin shrink small outline, 3 x 6.4 mm, 0.65 mm pitch, package. / Figure 17. TSSOP8 – Outline / 1 / CP
- 8 5 / A1 / 1. Drawing is not to scale. / Table 20. TSSOP8 – Mechanical data / Symbol

### Formulas, equations, and configurable calculations

- SDA is an input/output used to transfer data in or data out of the device. SDA(out) is an open drain output that / may be wire-OR’ed with other open drain or open collector signals on the bus. A…
- Ei / 2.4 Write control (WC) / This input signal is useful for protecting the entire contents of the memory from inadvertent write operations. Write / operations are disabled to the entire memory…
- 2.4 Write control (WC) / This input signal is useful for protecting the entire contents of the memory from inadvertent write operations. Write / operations are disabled to the entire memory arra…
- conditions in Section  8  DC and AC parameters). / 2.6.3 Device reset / In order to prevent inadvertent write operations during power-up, a power-on-reset (POR) circuit is included. / At power-u…
- Memory organization / DS6520 - Rev 31 page 6/47 / 4 Device operation / The device supports the I2C protocol. This is summarized in Figure 6. Any device that sends data on to the bus is / defined…
- Condition / M24512-W M24512-R M24512-DF / Device operation / DS6520 - Rev 31 page 7/47 / 4.1 Start condition
- 4.3 Data input / During data input, the device samples serial data (SDA) on the rising edge of serial clock (SCL). For correct / device operation, serial data (SDA) must be stable during the ris…
- When the device select code is received, the device only responds if the chip enable address is the same as the / value on the chip enable (E2, E1, E0) inputs. / The 8th bit is the Read/Write bi…
- DS6520 - Rev 31 page 9/47 / 5 Instructions / 5.1 Write operations / Following a start condition the bus master sends a device select code with the R/W bit (RW) reset to 0. The / device acknowled…
- Stop / M24512-W M24512-R M24512-DF / Write operations / DS6520 - Rev 31 page 11/47 / 5.1.2 Page write
- Byte write / M24512-W M24512-R M24512-DF / Write operations / DS6520 - Rev 31 page 12/47 / 5.1.3 Write identification page (M2512-D only)
- The ECC logic is implemented on each group of four EEPROM bytes (A group of four bytes is located at / addresses [4\*N, 4\*N+1, 4\*N+2, 4\*N+3], where N is an integer). Inside a group, if a sing…
- value defined Table 12. Cycling performance by groups of four bytes. / M24512-W M24512-R M24512-DF / Write operations / DS6520 - Rev 31 page 13/47 / 5.1.6 Minimizing write delays by polling on A…
- in progress / Next / operation is / addressing the / memory
- Stop / Data for the / write operation / Send address / and receive ACK
- YESNO / Continue the / write operation / Continue the / random read operation
- write operation / Continue the / random read operation / Device select / with RW = 1
- in the figure). / M24512-W M24512-R M24512-DF / Write operations / DS6520 - Rev 31 page 14/47 / 5.2 Read operations
- Write operations / DS6520 - Rev 31 page 14/47 / 5.2 Read operations / Read operations are performed independently of the state of the write control (WC) signal. / After the successful completion…
- DS6520 - Rev 31 page 14/47 / 5.2 Read operations / Read operations are performed independently of the state of the write control (WC) signal. / After the successful completion of a read operatio…

### Reference designs, applications, and examples

- devices operate with a clock frequency of 1 MHz (or less), over an ambient temperature range of –40 °C / +85 °C. / The M24512-D offers an additional page, named the identification page (128 byte…
- VOL Output low voltage IOL = 1 mA, VCC = 1.8 V - 0.2 V / 1. If the application uses the voltage range R device with 2.5 V < V cc < 5.5 V and -40 °C < TA < +85 °C, please refer to / Table 14 inst…
- VOL Output low voltage IOL = 1 mA, VCC = 1.7 V - 0.2 V / 1. If the application uses the voltage range F device with 2.5 V < V CC < 5.5 V and -40 °C < TA < +85 °C, please refer to / Table 14 inst…
- 3. Drawing is not to scale. / 4. The central pad (the area E2 by D2 in the above illustration) must be either connected to V SS or left floating / (not connected) in the end application. / M2451…
- 10 Ordering information / Table 24. Ordering information scheme / Example: M24 512 - D W MC 6 T P /K / Device type / M24 = I2C serial access EEPROM
- DS6520 - Rev 31 page 39/47 / Table 25. Ordering information scheme (unsawn wafer) / Example: M24 512 - D F K W 20 I /90 / Device type / M24 = I2C serial access EEPROM
- products and/or to this document at any time without notice. Purchasers should obtain the latest relevant information on ST products before placing orders. ST / products are sold pursuant to ST’…

## Page-by-Page Extracted Content

### Page 1

```text
TSSOP8 (DW)
169 mil width
SO8N (MN)
150 mil width
UFDFPN8 (MC)
DFN8 - 2x3 mm
WLSCP (CU)
WLSCP (CS)
Unsawn wafer
Features
• Compatible with following I 2C bus modes:
– 1 MHz
– 400 kHz
– 100 kHz
• Memory array:
– 512 Kbit (64 Kbyte) of EEPROM
– Page size: 128 byte
– Additional write lockable page (M24512-D order codes)
• Single supply voltage and high speed:
– 1 MHz clock from 1.7 V to 5.5 V
• Write time:
– Byte write within 5 ms
– Page write within 5 ms
• Operating temperature range:
– -40 °C up to +85 °C
• Random and sequential read modes
• Write protect of the whole memory array
• Enhanced ESD/latch-Up protection
• More than 4 million write cycles
• More than 200-years data retention
• Packages:
– SO8 ECOPACK2 ®
– TSSOP8 ECOPACK2 ®
– UFDFPN8 ECOPACK2 ®
– WLCSP ECOPACK2 ®
– Unsawn wafer (each die is tested)
Product status link
M24512-W
M24512-R
M24512-DF
512-Kbit serial I²C bus EEPROM
M24512-W M24512-R M24512-DF
Datasheet
DS6520 - Rev 31 - October 2020
For further information contact your local STMicroelectronics sales office.
www.st.com
```

### Page 2

```text
1 Description
The M24512 is a 512-Kbit I2C-compatible EEPROM (electrically erasable programmable memory) organized as
64 K × 8 bits.
The M24512-W can operate with a supply voltage from 2.5 V to 5.5 V, the M24512-R can operate with a supply
voltage from 1.8 V to 5.5 V, and the M24512-DF can operate with a supply voltage from 1.7 V to 5.5 V. All these
devices operate with a clock frequency of 1 MHz (or less), over an ambient temperature range of –40 °C / +85 °C.
The M24512-D offers an additional page, named the identification page (128 byte). The identification page can be
used to store sensitive application parameters which can be (later) permanently locked in read-only mode.
Figure 1. Logic diagram
3
E0-E2 SDA
VCC
M24xxx
WC
SCL
VSS
Table 1. Signal names
Signal name Function Direction
E2, E1, E0 Chip enable Input
SDA Serial data I/O
SCL Serial clock Input
WC Write control Input
VCC Supply voltage -
VSS Ground -
Figure 2. 8-pin package connections, top view
SDAVSS
SCL
WCE1
E0 VCC
E2
1
2
3
4
8
7
6
5
M24512-W M24512-R M24512-DF
Description
DS6520 - Rev 31 page 2/47
```

### Page 3

```text
Figure 3. WLCSP connections
Marking  side
(top view)
Bump  side
(bottom view)
A
1            2            3
C
B
D
E
E1
SDA
SCL
V CC
V SS E0
E2 WC
A
3            2            1
C
B
D
E
E1
SCL
SDA
V SS
E2
V CC
E0
WC
Table 2. Signal vs. bump position
Position A B C D E
1 SDA - E2 - VSS
2 - SCL - E1 -
3 VCC - WC - E0
M24512-W M24512-R M24512-DF
Description
DS6520 - Rev 31 page 3/47
```

### Page 4

```text
2 Signal description
2.1 Serial clock (SCL)
The signal applied on the SCL input is used to strobe the data available on SDA(in) and to output the data on
SDA(out).
2.2 Serial data (SDA)
SDA is an input/output used to transfer data in or data out of the device. SDA(out) is an open drain output that
may be wire-OR’ed with other open drain or open collector signals on the bus. A pull-up resistor must be
connected from serial data (SDA) to VCC (Figure 12 indicates how to calculate the value of the pull-up resistor).
2.3 Chip enable (E2, E1, E0)
(E2,E1,E0) input signals are used to set the value that is to be looked for on the three least significant bits (b3, b2,
b1) of the 7-bit device select code (see Table 3). These inputs must be tied to VCC or VSS, as shown in Figure 4.
When not connected (left floating), these inputs are read as low (0).
Figure 4. Chip enable inputs connection
VCC
M24xxx
VSS
Ei
VCC
M24xxx
VSS
Ei
2.4 Write control (WC)
This input signal is useful for protecting the entire contents of the memory from inadvertent write operations. Write
operations are disabled to the entire memory array when write control (WC) is driven high. Write operations are
enabled when write control (WC) is either driven low or left floating.
When write control (WC) is driven high, device select and address bytes are acknowledged, data bytes are not
acknowledged.
2.5 VSS (ground)
VSS is the reference for the VCC supply voltage.
M24512-W M24512-R M24512-DF
Signal description
DS6520 - Rev 31 page 4/47
```

### Page 5

```text
2.6 Supply voltage (VCC)
2.6.1 Operating supply voltage (VCC)
Prior to selecting the memory and issuing instructions to it, a valid and stable VCC voltage within the specified
[VCC(min), VCC(max)] range must be applied (see Operating conditions in Section  8  DC and AC parameters). In
order to secure a stable DC supply voltage, it is recommended to decouple the VCC line with a suitable capacitor
(usually of the order of 10 nF to 100 nF) close to the VCC/VSS package pins.
This voltage must remain stable and valid until the end of the transmission of the instruction and, for a write
instruction, until the completion of the internal write cycle (tW).
2.6.2 Power-up conditions
The VCC voltage has to rise continuously from 0 V up to the minimum VCC operating voltage (see Operating
conditions in Section  8  DC and AC parameters).
2.6.3 Device reset
In order to prevent inadvertent write operations during power-up, a power-on-reset (POR) circuit is included.
At power-up, the device does not respond to any instruction until VCC has reached the internal reset threshold
voltage. This threshold is lower than the minimum VCC operating voltage (see Operating conditions in
Section  8  DC and AC parameters). When VCC passes over the POR threshold, the device is reset and enters
the standby power mode; however, the device must not be accessed until VCC reaches a valid and stable DC
voltage within the specified [VCC(min), VCC(max)] range (see Operating conditions in Section  8  DC and AC
parameters).
In a similar way, during power-down (continuous decrease in VCC), the device must not be accessed when VCC
drops below VCC(min). When VCC drops below the power-on-reset threshold voltage, the device stops responding
to any instruction sent to it.
2.6.4 Power-down conditions
During power-down (continuous decrease in VCC), the device must be in the standby power mode (mode reached
after decoding a stop condition, assuming that there is no internal write cycle in progress).
M24512-W M24512-R M24512-DF
Supply voltage (VCC)
DS6520 - Rev 31 page 5/47
```

### Page 6

```text
3 Memory organization
The memory is organized as shown below.
Figure 5. Block diagram
HV GENERATOR
+
SEQUENCER
I/O
ARRAY
SENSE AMPLIFIERS
Y DECODER
DATA REGISTER
+
ECC
CONTROL
LOGIC
SCL
SDA
IDENTIFICATION PAGE
PAGE LATCHES X DECODER
START & STOP
DETECT
ADDRESS
REGISTER
WC
Ei
M24512-W M24512-R M24512-DF
Memory organization
DS6520 - Rev 31 page 6/47
```

### Page 7

```text
4 Device operation
The device supports the I2C protocol. This is summarized in Figure 6. Any device that sends data on to the bus is
defined to be a transmitter, and any device that reads the data to be a receiver. The device that controls the data
transfer is known as the bus master, and the other as the slave device. A data transfer can only be initiated by the
bus master, which will also provide the serial clock for synchronization. The device is always a slave in all
communications.
Figure 6. I2C bus protocol
SCL
SDA
SCL
SDA
SDA
START
Condition
SDA
Input
SDA
Change STOP
Condition
1 2 3 7 8 9
MSB ACK
START
Condition
SCL 1 2 3 7 8 9
MSB ACK
STOP
 Condition
M24512-W M24512-R M24512-DF
Device operation
DS6520 - Rev 31 page 7/47
```

### Page 8

```text
4.1 Start condition
Start is identified by a falling edge of serial data (SDA) while serial clock (SCL) is stable in the high state. A start
condition must precede any data transfer instruction. The device continuously monitors (except during a write
cycle) serial data (SDA) and serial clock (SCL) for a start condition.
4.2 Stop condition
Stop is identified by a rising edge of serial data (SDA) while serial clock (SCL) is stable and driven high. A stop
condition terminates communication between the device and the bus master. A read instruction that is followed by
NoAck can be followed by a stop condition to force the device into the standby mode.
A stop condition at the end of a write instruction triggers the internal write cycle.
4.3 Data input
During data input, the device samples serial data (SDA) on the rising edge of serial clock (SCL). For correct
device operation, serial data (SDA) must be stable during the rising edge of serial clock (SCL), and the serial data
(SDA) signal must change only when serial clock (SCL) is driven low.
4.4 Acknowledge bit (ACK)
The acknowledge bit is used to indicate a successful byte transfer. The bus transmitter, whether it be bus master
or slave device, releases serial data (SDA) after sending eight bits of data. During the 9th clock pulse period, the
receiver pulls serial data (SDA) low to acknowledge the receipt of the eight data bits.
M24512-W M24512-R M24512-DF
Start condition
DS6520 - Rev 31 page 8/47
```

### Page 9

```text
4.5 Device addressing
To start communication between the bus master and the slave device, the bus master must initiate a Start
condition. Following this, the bus master sends the device select code, shown in Table 3 (most significant bit first).
Table 3. Device select code
Device type identifier(1) Chip Enable address(2) RW
b7 b6 b5 b4 b3 b2 b1 b0
Device select code when addressing the memory array 1 0 1 0 E2 E1 E0 RW
Device select code when accessing the Identification page 1 0 1 1 E2 E1 E0 RW

1. The most significant bit, b7, is sent first.
2. E0, E1 and E2 are compared with the value read on input pins E0, E1 and E2.

When the device select code is received, the device only responds if the chip enable address is the same as the
value on the chip enable (E2, E1, E0) inputs.
The 8th bit is the Read/Write bit (RW). This bit is set to 1 for read and 0 for write operations.
If a match occurs on the device select code, the corresponding device gives an acknowledgement on serial data
(SDA) during the 9th bit time. If the device does not match the device select code, it deselects itself from the bus,
and goes into standby mode.
M24512-W M24512-R M24512-DF
Device addressing
DS6520 - Rev 31 page 9/47
```

### Page 10

```text
5 Instructions
5.1 Write operations
Following a start condition the bus master sends a device select code with the R/W bit (RW) reset to 0. The
device acknowledges this, as shown in Figure 7, and waits for two address bytes. The device responds to each
address byte with an acknowledge bit, and then waits for the data byte.
Table 4. Most significant address byte
A15 A14 A13 A12 A11 A10 A9 A8
Table 5. Least significant address byte
A7 A6 A5 A4 A3 A2 A1 A0
When the bus master generates a stop condition immediately after a data byte Ack bit (in the “10th bit” time slot),
either at the end of a byte write or a page write, the internal write cycle tW is triggered. A stop condition at any
other time slot does not trigger the internal write cycle.
After the stop condition and the successful completion of an internal write cycle (tW), the device internal address
counter is automatically incremented to point to the next byte after the last modified byte.
During the internal write cycle, serial data (SDA) is disabled internally, and the device does not respond to any
requests.
If the write control input (WC) is driven high, the write instruction is not executed and the accompanying data
bytes are not acknowledged, as shown in Figure 8.
M24512-W M24512-R M24512-DF
Instructions
DS6520 - Rev 31 page 10/47
```

### Page 11

```text
5.1.1 Byte write
After the device select code and the address bytes, the bus master sends one data byte. If the addressed location
is write-protected, by write control (WC) being driven high, the device replies with NoAck, and the location is not
modified. If, instead, the addressed location is not write-protected, the device replies with Ack. The bus master
terminates the transfer by generating a stop condition, as shown in Figure 7.
Figure 7. Write mode sequences with WC = 0 (data write enabled)
WC
Byte Write Dev sel Byte addr Byte addr Data in
ACK ACK ACK ACK
RW
Start
Stop
WC
Dev sel Byte addr Byte addr
ACK ACK ACK ACK
RW
Start
Data in 1 Data in 2Page Write
Page Write (cont’d)
WC (cont’d)
ACK ACK
Data in N
Stop
M24512-W M24512-R M24512-DF
Write operations
DS6520 - Rev 31 page 11/47
```

### Page 12

```text
5.1.2 Page write
The page write mode allows up to 128 byte to be written in a single write cycle, provided that they are all located
in the same page in the memory: that is, the most significant memory address bits, A15/A7, are the same. If more
bytes are sent than fit up to the end of the page, a “roll-over” occurs, i.e. the bytes exceeding the page end are
written on the same page, from location 0.
The bus master sends from 1 to 128 byte of data, each of which is acknowledged by the device if write control
(WC) is low. If write control (WC) is high, the contents of the addressed memory location are not modified, and
each data byte is followed by a NoAck, as shown in Figure 8. After each transferred byte, the internal page
address counter is incremented.
The transfer is terminated by the bus master generating a stop condition.
Figure 8. Write mode sequences with WC = 1 (data write inhibited)
Page write
Page write (cont’d)
WC (cont’d)
WC
WC
Byte write
M24512-W M24512-R M24512-DF
Write operations
DS6520 - Rev 31 page 12/47
```

### Page 13

```text
5.1.3 Write identification page (M2512-D only)
The identification page (128 byte) is an additional page which can be written and (later) permanently locked in
read-only mode. It is written by issuing the write identification page instruction. This instruction uses the same
protocol and format as page write (into memory array), except for the following differences:
• Device type identifier = 1011b
• MSB address bits A15/A7 are don't care except for address bit A10 which must be ‘0’. LSB address bits
A6/A0 define the byte address inside the identification page.
If the identification page is locked, the data bytes transferred during the write identification page instruction are not
acknowledged (NoAck).
5.1.4 Lock identification page (M24512-D only)
The lock identification page instruction (Lock ID) permanently locks the identification page in read-only mode. The
lock ID instruction is similar to byte write (into memory array) with the following specific conditions:
• Device type identifier = 1011b
• Address bit A10 must be ‘1’; all other address bits are don't care
• The data byte must be equal to the binary value xxxx xx1x, where x is don't care
5.1.5 ECC (error correction code) and write cycling
The error correction code (ECC) is an internal logic function which is transparent for the I2C communication
protocol.
The ECC logic is implemented on each group of four EEPROM bytes (A group of four bytes is located at
addresses [4*N, 4*N+1, 4*N+2, 4*N+3], where N is an integer). Inside a group, if a single bit out of the four bytes
happens to be erroneous during a read operation, the ECC detects this bit and replaces it with the correct value.
The read reliability is therefore much improved.
Even if the ECC function is performed on groups of four bytes, a single byte can be written/cycled independently.
In this case, the ECC function also writes/cycles the three other bytes located in the same group (A group of four
bytes is located at addresses [4*N, 4*N+1, 4*N+2, 4*N+3], where N is an integer). As a consequence, the
maximum cycling budget is defined at group level and the cycling can be distributed over the 4 bytes of the group:
the sum of the cycles seen by byte0, byte1, byte2 and byte3 of the same group must remain below the maximum
value defined Table 12. Cycling performance by groups of four bytes.
M24512-W M24512-R M24512-DF
Write operations
DS6520 - Rev 31 page 13/47
```

### Page 14

```text
5.1.6 Minimizing write delays by polling on ACK
The maximum write time (tw) is shown in AC characteristics tables in Section  8  DC and AC parameters, but the
typical time is shorter. To make use of this, a polling sequence can be used by the bus master.
The sequence, as shown in Figure 9, is:
• Initial condition: a write cycle is in progress.
• Step 1: the bus master issues a Start condition followed by a device select code (the first byte of the new
instruction).
• Step 2: if the device is busy with the internal write cycle, no Ack is returned and the bus master goes back to
step 1. If the device has terminated the internal write cycle, it responds with an Ack, indicating that the
device is ready to receive the second part of the instruction (the first byte of this instruction having been sent
during Step 1).
Figure 9. Write cycle polling flowchart using ACK
Write cycle
in progress
Next
operation is
addressing the
memory
Start condition
ACK
returned
YES
NO
YESNO
Re-start
Stop
Data for the
write operation
Send address
and receive ACK
YESNO
Continue the
write operation
Continue the
random read operation
Device select
with RW = 1
First byte of instruction
with RW = 0 already
decoded by the device
Device select
with RW = 0
StartCondition
1. The seven most significant bits of the device select code of a random read (bottom right box in the figure)
must be identical to the seven most significant bits of the device select code of the write (polling instruction
in the figure).
M24512-W M24512-R M24512-DF
Write operations
DS6520 - Rev 31 page 14/47
```

### Page 15

```text
5.2 Read operations
Read operations are performed independently of the state of the write control (WC) signal.
After the successful completion of a read operation, the device internal address counter is incremented by one, to
point to the next byte address.
For the read instructions, after each byte read (data out), the device waits for an acknowledgement (data in)
during the 9th bit time. If the bus master does not acknowledge during this 9th time, the device terminates the data
transfer and switches to its standby mode.
Figure 10. Read mode sequences
Start
Dev sel * Byte addr Byte addr
Start
Dev sel Data out 1
Data out N
Stop
Start
Current
Address
Read
Dev sel Data out
Random
Address
Read
Stop
Start
Dev sel * Data out
Sequential
Current
Read
Stop
Data out N
Start
Dev sel * Byte addr Byte addr
Sequential
Random
Read
Start
Dev sel * Data out1
Stop
ACK
RW
NO ACK
ACK
RW
ACK ACK ACK
RW
ACK ACK ACK NO ACK
RW
NO ACK
ACK ACK ACK
RW
ACK ACK
RW
ACK NO ACK
M24512-W M24512-R M24512-DF
Read operations
DS6520 - Rev 31 page 15/47
```

### Page 16

```text
5.2.1 Random address read
A dummy write is first performed to load the address into this address counter (as shown in Figure 10) but without
sending a stop condition. Then, the bus master sends another start condition, and repeats the device select code,
with the RW bit set to 1. The device acknowledges this, and outputs the contents of the addressed byte. The bus
master must not acknowledge the byte, and terminates the transfer with a stop condition.
5.2.2 Current address read
For the current address read operation, following a start condition, the bus master only sends a device select
code with the RW bit set to 1. The device acknowledges this, and outputs the byte addressed by the internal
address counter. The counter is then incremented. The bus master terminates the transfer with a stop condition,
as shown in Figure 10, without acknowledging the byte.
Note that the address counter value is defined by instructions accessing either the memory or the identification
page. When accessing the Identification page, the address counter value is loaded with the byte location in the
identification page, therefore the next current address read in the memory uses this new address counter value.
When accessing the memory, it is safer to always use the random address read instruction (this instruction loads
the address counter with the byte location to read in the memory, see Section  5.2.1  Random address read)
instead of the current address Read instruction.
5.2.3 Sequential read
This operation can be used after a current address read or a random address read. The bus master does
acknowledge the data byte output, and sends additional clock pulses so that the device continues to output the
next byte in sequence. To terminate the stream of bytes, the bus master must not acknowledge the last byte, and
must generate a Stop condition, as shown in Figure 10.
The output data comes from consecutive addresses, with the internal address counter automatically incremented
after each byte output. After the last memory address, the address counter “rolls-over”, and the device continues
to output data from memory address 00h.
5.3 Read identification page (M24512-D only)
The identification page (128 bytes) is an additional page which can be written and (later) permanently locked in
Read-only mode.
The identification page can be read by issuing an read identification page instruction. This instruction uses the
same protocol and format as the random address read (from memory array) with device type identifier defined as
1011b. The MSB address bits A15/A7 are don't care, the LSB address bits A6/A0 define the byte address inside
the identification page. The number of bytes to read in the ID page must not exceed the page boundary (e.g.:
when reading the identification page from location 100d, the number of bytes should be less than or equal to 28,
as the ID page boundary is 128 bytes).
M24512-W M24512-R M24512-DF
Read identification page (M24512-D only)
DS6520 - Rev 31 page 16/47
```

### Page 17

```text
5.4 Read the lock status (M24512-D only)
The locked/unlocked status of the identification page can be checked by transmitting a specific truncated
command [identification page write instruction + one data byte] to the device. The device returns an acknowledge
bit if the identification page is unlocked, otherwise a NoAck bit if the identification page is locked.
Right after this, it is recommended to transmit to the device a start condition followed by a stop condition, so that:
• Start: the truncated command is not executed because the start condition resets the device internal logic,
• Stop: the device is then set back into standby mode by the stop condition.
M24512-W M24512-R M24512-DF
Read the lock status (M24512-D only)
DS6520 - Rev 31 page 17/47
```

### Page 18

```text
6 Initial delivery state
The device is delivered with all the memory array bits and Identification page bits set to 1 (each byte contains
FFh).
M24512-W M24512-R M24512-DF
Initial delivery state
DS6520 - Rev 31 page 18/47
```

### Page 19

```text
7 Maximum rating
Stressing the device outside the ratings listed in Table 6 may cause permanent damage to the device. These are
stress ratings only, and operation of the device at these, or any other conditions outside those indicated in the
operating sections of this specification, is not implied. Exposure to absolute maximum rating conditions for
extended periods may affect device reliability.
Table 6. Absolute maximum ratings
Symbol Parameter Min. Max. Unit
- Ambient operating temperature -55 130 °C
TSTG Storage temperature –65 150 °C
TLEAD Lead temperature during soldering see note (1) °C
IOL DC output current (SDA = 0) – 5 mA
VIO Input or output range –0.50 6.5 V
VCC Supply voltage -0.50 6.5 V
VESD Electrostatic pulse (Human Body model)(2) – 4000 V

1. Compliant with JEDEC Std J-STD-020E (for small body, Sn-Pb or Pb-free assembly), the ST ECOPACK 7191395
specification, and the European directive on Restrictions of Hazardous Substances (RoHS directive 2011/65/EU of July
2011).
2. Positive and negative pulses applied on different combinations of pin connections, according to AEC-Q100-002 (compliant
with ANSI/ESDA/JEDEC JS-001-2012 standard, C1=100 pF, R1=1500 Ω).

M24512-W M24512-R M24512-DF
Maximum rating
DS6520 - Rev 31 page 19/47
```

### Page 20

```text
8 DC and AC parameters
This section summarizes the operating and measurement conditions, and the DC and AC characteristics of the
device.
Table 7. Operating conditions (voltage range W)
Symbol Parameter Min. Max. Unit
VCC Supply voltage 2.5 5.5 V
TA Ambient operating temperature –40 85 °C
fC Operating clock frequency - 1 MHz
Table 8. Operating conditions (voltage range R)
Symbol Parameter Min. Max. Unit
VCC Supply voltage 1.8 5.5 V
TA Ambient operating temperature –40 85 °C
fC Operating clock frequency - 1 MHz
Table 9. Operating conditions (voltage range F)
Symbol Parameter Min. Max. Unit
VCC Supply voltage 1.7 5.5 V
TA Ambient operating temperature -40 85 °C
fC Operating clock frequency - 1 MHz
Table 10. AC measurement conditions
Symbol Parameter Min. Max. Unit
Cbus Load capacitance - 100 pF
- SCL input rise/fall time, SDA input fall time - 50 ns
- Input levels 0.2 VCC to 0.8 VCC V
- Input and output timing reference levels 0.3 VCC to 0.7 VCC V
M24512-W M24512-R M24512-DF
DC and AC parameters
DS6520 - Rev 31 page 20/47
```

### Page 21

```text
Figure 11. AC measurement I/O waveform
0.8V CC
0.2V CC
0.7V CC
0.3V CC
Input and output
Timing reference levels
Input voltage levels
Table 11. Input parameters
Symbol Parameter(1) Test condition Min. Max. Unit
CIN Input capacitance (SDA) - - 8 pF
CIN Input capacitance (other pins) - - 6 pF
ZL
Input impedance (E2, E1, E0, WC)(2)
VIN < 0.3 VCC 30 - kΩ
ZH VIN > 0.7 VCC 500 - kΩ

1. Characterized only, not tested in production.
2. E2, E1, E0 input impedance when the memory is selected (after a start condition).

Table 12. Cycling performance by groups of four bytes
Symbol Parameter Test condition Max. Unit
Ncycle Write cycle endurance(1)
TA ≤  25 °C, VCC(min) < VCC < VCC(max) 4,000,000
Write cycle(2)
TA = 85 °C, VCC(min) < VCC < VCC(max) 1,200,000

1. The write cycle endurance is defined by characterization and qualification. For devices embedding the ECC functionality ,
the write cycle endurance is defined for group of four bytes located at addresses [4*N, 4*N+1, 4*N+2, 4*N+3] where N is an
integer.
2. A Write cycle is executed when either a page write, a byte write, a write identification page or a lock identification page
instruction is decoded. When using the byte write, the page write or the write identification page, refer also to
Section  5.1.5  ECC (error correction code) and write cycling

Table 13. Memory cell data retention
Parameter Test condition Min. Unit
Data retention(1) TA = 55 °C 200 Year

1. The data retention behaviour is checked in production, while the data retention limit defined in this table is extracted from
characterization and qualification results.

M24512-W M24512-R M24512-DF
DC and AC parameters
DS6520 - Rev 31 page 21/47
```

### Page 22

```text
Table 14. DC characteristics (M24512-W, device grade 6)
Symbol Parameter Test conditions (in addition to those in Table 7 and
Table 10) Min. Max. Unit
ILI
Input leakage current
(SCL, SDA, E2, E1, E0)
VIN = VSS or VCC, device in Standby mode - ± 2 µA
ILO Output leakage current SDA in Hi-Z, external voltage applied on SDA: VSS or VCC - ± 2 µA
ICC Supply current (Read)
2.5 V < VCC < 5.5 V, fC = 400 kHz - 2
mA
2.5 V ≤VCC ≤ 5.5 V, fC = 1 MHz - 2.5
ICC0 Supply current (Write)
During tW,
2.5 V ≤ VCC ≤ 5.5 V
- 5(1) mA
ICC1 Standby supply current
Device not selected(2),
VIN = VSS or VCC, VCC = 2.5 V
- 2 μA
Device not selected(2),
VIN = VSS or VCC, VCC = 5.5 V
- 3 μA
VIL
Input low voltage(3)
(SCL, SDA, WC, E2, E1, E0)
- –0.45 0.3 VCC V
VIH
Input high voltage
(SCL, SDA)
- 0.7 VCC 6.5 V
Input high voltage
(WC, E2, E1, E0)(4)
- 0.7 VCC VCC+0.6 V
VOL Output low voltage
IOL = 2.1 mA, VCC = 2.5 V or
IOL = 3 mA, VCC = 5.5 V
- 0.4 V

1. Characterized value, not tested in production.
2. The device is not selected after power-up, after a read instruction (after the stop condition), or after the completion of the
internal write cycle tW (tW is triggered by the correct decoding of a write instruction).
3. E i inputs should be tied to Vss (see Section  2.3  Chip enable (E2, E1, E0)).
4. Ei inputs should be tied to Vcc (see Section  2.3  Chip enable (E2, E1, E0)).

M24512-W M24512-R M24512-DF
DC and AC parameters
DS6520 - Rev 31 page 22/47
```

### Page 23

```text
Table 15. DC characteristics (M24512-R device grade 6)
Symbol Parameter Test conditions (1)(in addition to those in Table 8) Min. Max. Unit
ILI
Input leakage current
( E0, E1, E2, SCL, SDA)
VIN = VSS or VCC, device in Standby mode - ± 2 µA
ILO Output leakage current SDA in Hi-Z, external voltage applied on SDA: VSS or
VCC
- ± 2 µA
ICC Supply current (Read)
VCC = 1.8 V, fc= 400 kHz - 0.8 mA
fc= 1 MHz - 2.5 mA
ICC0 Supply current (Write)
During tW
1.8 V ≤ VCC ≤ 2.5 V
- 5(2) mA
ICC1 Standby supply current
Device not selected,(3)
VIN = VSS or VCC, VCC = 1.8 V
- 1 µA
VIL
Input low voltage (SCL, SDA,
WC,E2, E1, E0)(4) 1.8 V ≤ VCC < 2.5 V -0.45 0.25 VCC V
VIH
Input high voltage
(SCL, SDA)
1.8 V ≤ VCC < 2.5 V 0.75 VCC 6.5 V
Input high voltage
(WC, E2, E1, E0)(5)
1.8 V ≤ VCC < 2.5 V 0.75 VCC VCC+0.6 V
VOL Output low voltage IOL = 1 mA, VCC = 1.8 V - 0.2 V

1. If the application uses the voltage range R device with 2.5 V < V cc < 5.5 V and -40 °C < TA < +85 °C, please refer to
Table 14 instead of this table.
2. Characterized value, not tested in production.
3. The device is not selected after power-up, after a read instruction (after the stop condition), or after the completion of the
internal write cycle tW (tW is triggered by the correct decoding of a write instruction).
4. Ei inputs should be tied to V SS (see Section  2.3  Chip enable (E2, E1, E0)).
5. Ei inputs should be tied to V CC (see Section  2.3  Chip enable (E2, E1, E0)

M24512-W M24512-R M24512-DF
DC and AC parameters
DS6520 - Rev 31 page 23/47
```

### Page 24

```text
Table 16. DC characteristics (M24512-DF, device grade 6)
Symbol Parameter Test conditions(1) (in addition to those in Table 9) Min. Max. Unit
ILI
Input leakage current
(E0, E1, E2, SCL, SDA)
VIN = VSS or VCC
device in Standby mode
- ± 2 µA
ILO Output leakage current SDA in Hi-Z, external voltage applied on SDA: VSS or
VCC
- ± 2 µA
ICC Supply current (Read)
VCC = 1.7 V, fC= 400 kHz - 0.8
mA
fC= 1 MHz - 2.5
ICC0 Supply current (Write) During tW - 5(2) mA
ICC1 Standby supply current
Device not selected,(3)
VIN = VSS or VCC, VCC = 1.7 V
- 1 µA
VIL
Input low voltage (SCL, SDA,
WC,E2, E1, E0)(4) 1.7 V ≤ VCC < 2.5 V -0.45 0.25 VCC V
VIH
Input high voltage
(SCL, SDA)
1.7 V ≤ VCC < 2.5 V 0.75 VCC 6.5 V
Input high voltage
(WC, E2, E1, E0)(5)
1.7 V ≤ VCC < 2.5 V 0.75 VCC VCC+0.6 V
VOL Output low voltage IOL = 1 mA, VCC = 1.7 V - 0.2 V

1. If the application uses the voltage range F device with 2.5 V < V CC < 5.5 V and -40 °C < TA < +85 °C, please refer to
Table 14 instead of this table.
2. Characterized value, not tested in production.
3. The device is not selected after power-up, after a read instruction (after the stop condition), or after the completion of the
internal write cycle tW (tW is triggered by the correct decoding of a write instruction).
4. Ei inputs should be tied to V SS (see Section  2.3  Chip enable (E2, E1, E0)).
5. Ei inputs should be tied to V CC (see Section  2.3  Chip enable (E2, E1, E0)).

M24512-W M24512-R M24512-DF
DC and AC parameters
DS6520 - Rev 31 page 24/47
```

### Page 25

```text
Table 17. 400 kHz AC characteristics
Symbol Alt. Parameter Min. Max. Unit
fC fSCL Clock frequency - 400 kHz
tCHCL tHIGH Clock pulse width high 600 - ns
tCLCH tLOW Clock pulse width low 1300 - ns
tQL1QL2(1) tF SDA (out) fall time 20(2) 300 ns
tXH1XH2 tR Input signal rise time (3) (3) ns
tXL1XL2 tF Input signal fall time (3) (3) ns
tDXCH tSU:DAT Data in set up time 100 - ns
tCLDX tHD:DAT Data in hold time 0 - ns
tCLQX(4) tDH Data out hold time 100 - ns
tCLQV(5) tAA Clock low to next data valid (access time) - 900 ns
tCHDL tSU:STA Start condition setup time 600 - ns
tDLCL tHD:STA Start condition hold time 600 - ns
tCHDH tSU:STO Stop condition set up time 600 - ns
tDHDL tBUF Time between Stop condition and next Start condition 1300 - ns
tWLDL(1)(6) tSU:WC WC set up time (before the Start condition) 0 - µs
tDHWH(1)(7) tHD:WC WC hold time (after the Stop condition) 1 - µs
tW tWR Write time - 5 ms
tNS(1) - Pulse width ignored (input filter on SCL and SDA) - single glitch - 80 ns

1. Characterized only, not tested in production.
2. With C L = 10 pF.
3. There is no min. or max. values for the input signal rise and fall times. It is however recommended by the I²C specification
that the input signal rise and fall times be more than 20 ns and less than 300 ns when fC < 400 kHz.
4. To avoid spurious Start and Stop conditions, a minimum delay is placed between SCL=1 and the falling or rising edge of
SDA.
5. t CLQV is the time (from the falling edge of SCL) required by the SDA bus line to reach either 0.3VCC or 0.7VCC, assuming
that Rbus × Cbus time constant is within the values specified in Figure 12.
6. WC=0 set up time condition to enable the execution of a WRITE command.
7. WC=0 hold time condition to enable the execution of a WRITE command.

M24512-W M24512-R M24512-DF
DC and AC parameters
DS6520 - Rev 31 page 25/47
```

### Page 26

```text
Table 18. 1 MHz AC characteristics
Symbol Alt. Parameter Min. Max. Unit
fC fSCL Clock frequency 0 1 MHz
tCHCL tHIGH Clock pulse width high 300 - ns
tCLCH tLOW Clock pulse width low 550 - ns
tXH1XH2 tR Input signal rise time (1) (1) ns
tXL1XL2 tF Input signal fall time (1) (1) ns
tQL1QL2(2) tF SDA (out) fall time - 120 ns
tDXCH tSU:DAT Data in setup time 80 - ns
tCLDX tHD:DAT Data in hold time 0 - ns
tCLQX(3) tDH Data out hold time 50 - ns
tCLQV(4) tAA Clock low to next data valid (access time) - 500 ns
tCHDL tSU:STA Start condition setup time 250 - ns
tDLCL tHD:STA Start condition hold time 250 - ns
tCHDH tSU:STO Stop condition setup time 250 - ns
tDHDL tBUF Time between Stop condition and next Start condition 500 - ns
tWLDL(2)(5) tSU:WC WC set up time (before the Start condition) 0 - µs
tDHWH(2)(6) tHD:WC WC hold time (after the Stop condition) 1 - µs
tW tWR Write time - 5 ms
tNS(2) - Pulse width ignored (input filter on SCL and SDA) - 80 ns

1. There is no min. or max. values for the input signal rise and fall times. It is however recommended by the I²C specification
that the input signal rise and fall times be less than 120 ns when fC < 1 MHz.
2. Characterized only, not tested in production.
3. To avoid spurious Start and Stop conditions, a minimum delay is placed between SCL=1 and the falling or rising edge of
SDA.
4. t CLQV is the time (from the falling edge of SCL) required by the SDA bus line to reach either 0.3 VCC or 0.7 VCC, assuming
that the Rbus × Cbus time constant is within the values specified in Figure 13.
5. WC=0 set up time condition to enable the execution of a WRITE command.
6. WC=0 hold time condition to enable the execution of a WRITE command.

M24512-W M24512-R M24512-DF
DC and AC parameters
DS6520 - Rev 31 page 26/47
```

### Page 27

```text
Figure 12. Maximum Rbus value versus bus parasitic capacitance (Cbus) for an I2C bus at maximum
frequency fC = 400 kHz
1
10
100
10 100 1000
Bus line capacitor (pF)
I²C bus
master
M24xxx
R bus
V CC
C bus
SCL
SDA
R
bu
s ×
C
bu
s = 400 ns
Here R bus  x C bus  = 120 ns4 k
30
The R bus  x C bus  time constant
must be below the 400 ns
time constant line represented
on the left.
Bus line pull-up resistor (kΩ)
Figure 13. Maximum Rbus value versus bus parasitic capacitance (Cbus) for an I2C bus at maximum
frequency fC = 1MHz
1
1 0
0
I²C bus
master
M24xxx
SCL
SDA
Here,
R bus
 x C
bus
 = 150 ns
4
30
1 0
R bus  x C bus  = 120 ns
Bus line capacitor (pF)
10 100
The R bus  x C bus  time constant
Must be below the 150 ns
Time constant line
represented on the left
Bus line pull-up resistor (kΩ )
V CC
R bus
C bus
M24512-W M24512-R M24512-DF
DC and AC parameters
DS6520 - Rev 31 page 27/47
```

### Page 28

```text
Figure 14. AC waveforms
SCL
SDA Out
SCL
SDA In
Data valid
tCLQV tCLQX
tCHDH
Stop
condition
tCHDL
Start
condition
Write cycle
tW
Data valid
tQL1QL2
SDA In
tCHDL
Start
condition
tDXCHtCLDX
SDA
Input SDA
Change
tCHDH tDHDL
Stop
condition
Start
condition
tXH1XH2
SCL
tCHCL
tDLCL
tCLCHtXH1XH2
tXL1XL2
tXL1XL2
WC
tWLDL tDHWH
tCHCL
M24512-W M24512-R M24512-DF
DC and AC parameters
DS6520 - Rev 31 page 28/47
```

### Page 29

```text
9 Package information
In order to meet environmental requirements, ST offers these devices in different grades of ECOPACK®
packages, depending on their level of environmental compliance. ECOPACK® specifications, grade definitions
and product status are available at: www.st.com. ECOPACK® is an ST trademark.
For die information concerning the M24512-W delivered in unsawn wafer, please contact your nearest ST Sales
Office.
9.1 UFDFPN8 (DFN8) package information
UFDFPN8 is an 8-lead, 2 × 3 mm, 0.5 mm thickness ultra thin profile fine pitch dual flat package
Figure 15. UFDFPN8 - Outline
Top view
Pin #1
ID marking
Side view
Seating plane
eee
ccc
C
C
C
C
C
BA
1 2
N
D
E
aaa
aaa
A
A1
A3
2x
2x
Datum A
Terminal tip
Detail “A”
Even terminal
L1
L3L
e
e/2
Pin #1
ID marking
Bottom view See Detail “A”
e
e
1 2
ND-1 x
D2
L1
L3
E2
K
L
b
1. Max. package war-page is 0.05 mm.
2. Exposed copper is not systematic and can appear partially or totally according to the cross section.
3. Drawing is not to scale.
4. The central pad (the area E2 by D2 in the above illustration) must be either connected to V SS or left floating
(not connected) in the end application.
M24512-W M24512-R M24512-DF
Package information
DS6520 - Rev 31 page 29/47
```

### Page 30

```text
Table 19. UFDFPN8 - Mechanical data
Symbol
millimeters inches(1)
Min Typ Max Min Typ Max
A 0.450 0.550 0.600 0.0177 0.0217 0.0236
A1 0.000 0.020 0.050 0.0000 0.0008 0.0020
b(2) 0.200 0.250 0.300 0.0079 0.0098 0.0118
D 1.900 2.000 2.100 0.0748 0.0787 0.0827
D2 1.200 - 1.600 0.0472 - 0.0630
E 2.900 3.000 3.100 0.1142 0.1181 0.1220
E2 1.200 - 1.600 0.0472 - 0.0630
e - 0.500 - 0.0197
K 0.300 - - 0.0118 - -
L 0.300 - 0.500 0.0118 - 0.0197
L1 - - 0.150 - - 0.0059
L3 0.300 - - 0.0118 - -
aaa - - 0.150 - - 0.0059
bbb - - 0.100 - - 0.0039
ccc - - 0.100 - - 0.0039
ddd - - 0.050 - - 0.0020
eee(3) - - 0.080 - - 0.0031

1. Values in inches are converted from mm and rounded to 4 decimal digits.
2. Dimension b applies to plated terminal and is measured between 0.15 and 0.30 mm from the terminal tip.
3. Applied for exposed die paddle and terminals. Exclude embedding part of exposed die paddle from measuring.

Figure 16. UFDFPN8 - Recommended footprint
0.500
1.400
0.600
1.200
0.300
1.300
1. Dimensions are expressed in millimeters.
M24512-W M24512-R M24512-DF
UFDFPN8 (DFN8) package information
DS6520 - Rev 31 page 30/47
```

### Page 31

```text
9.2 TSSOP8 package information
TSSOP8 is an 8 lead thin shrink small outline, 3 x 6.4 mm, 0.65 mm pitch, package.
Figure 17. TSSOP8 – Outline
1
CP
c
L
E
D
α
e
4
L1
E1
A2A
b
8 5
A1
1. Drawing is not to scale.
Table 20. TSSOP8 – Mechanical data
Symbol
millimeters inches (1)
Min. Typ. Max. Min. Typ. Max.
A - - 1.200 - - 0.0472
A1 0.050 - 0.150 0.0020 - 0.0059
A2 0.800 1.000 1.050 0.0315 0.0394 0.0413
b 0.190 - 0.300 0.0075 - 0.0118
c 0.090 - 0.200 0.0035 - 0.0079
CP - - 0.100 - - 0.0039
D 2.900 3.000 3.100 0.1142 0.1181 0.1220
e - 0.650 - - 0.0256 -
E 6.200 6.400 6.600 0.2441 0.2520 0.2598
E1 4.300 4.400 4.500 0.1693 0.1732 0.1772
L 0.450 0.600 0.750 0.0177 0.0236 0.0295
L1 - 1.000 - - 0.0394 -
α 0° - 8° 0° - 8°

1. Values in inches are converted from mm and rounded to four decimal digits.

M24512-W M24512-R M24512-DF
TSSOP8 package information
DS6520 - Rev 31 page 31/47
```

### Page 32

```text
Figure 18. TSSOP8 – Recommended footprint
2.3
1.0
0.65
0.35
7.0
1. Dimensions are expressed in millimeters.
M24512-W M24512-R M24512-DF
TSSOP8 package information
DS6520 - Rev 31 page 32/47
```

### Page 33

```text
9.3 SO8N package information
SO8N is an 8 lead, 4.9 x 6 mm, plastic small outline, 150 mils body width, package.
Figure 19. SO8N – Outline
E1
8
ccc
b
D
c
1
E
h  x  45˚
A2
k
0.25  mm
L
A1
GAUGE PLANE
e
A
L1
1. Drawing is not to scale.
Table 21. SO8N – Mechanical data
Symbol
millimeters inches (1)
Min. Typ. Max. Min. Typ. Max.
A - - 1.750 - - 0.0689
A1 0.100 - 0.250 0.0039 - 0.0098
A2 1.250 - - 0.0492 - -
b 0.280 - 0.480 0.0110 - 0.0189
c 0.170 - 0.230 0.0067 - 0.0091
D 4.800 4.900 5.000 0.1890 0.1929 0.1969
E 5.800 6.000 6.200 0.2283 0.2362 0.2441
E1 3.800 3.900 4.000 0.1496 0.1535 0.1575
e - 1.270 - - 0.0500 -
h 0.250 - 0.500 0.0098 - 0.0197
k 0° - 8° 0° - 8°
L 0.400 - 1.270 0.0157 - 0.0500
L1 - 1.040 - - 0.0409 -
ccc - - 0.100 - - 0.0039

1. Values in inches are converted from mm and rounded to four decimal digits.

M24512-W M24512-R M24512-DF
SO8N package information
DS6520 - Rev 31 page 33/47
```

### Page 34

```text
Figure 20. SO8N - Recommended footprint
1.27
0.6 (x8)
3.9
6.7
1. Dimensions are expressed in millimeters.
M24512-W M24512-R M24512-DF
SO8N package information
DS6520 - Rev 31 page 34/47
```

### Page 35

```text
9.4 WLCSP8 (CS) package information
WLCSP8 is a 8 bumps, 1.289 x 1.955 mm, 0.5 mm pitch wafer level chip scale package
Figure 21.  WLCSP8 - Outline
D
E
Wafer back side
Side view
Orientation
reference
e1
e3
e2
e
F
G
Bump side
X Y
aaa
Bump
Seating plane
Z
Detail A
rotated by 90°
A1
(8X)
Detail A
A2
A
Orientation
reference
Z
Z
X Y
(4X)
b
Zbbb
Zeee
ccc MØ
Ø ddd M
1. Drawing is not to scale
2. Dimension is measured at the maximum bump diameter parallel to primary datum Z.
3. Primary datum Z and seating plane are defined by the spherical crowns of the bump.
4. Bump position designation per JESD 95-1, SPP-010.
M24512-W M24512-R M24512-DF
WLCSP8 (CS) package information
DS6520 - Rev 31 page 35/47
```

### Page 36

```text
Table 22. WLCSP8 - Mechanical data
Symbol
millimeters inches(1)
Min Typ Max Min Typ Max
A 0.500 0.540 0.580 0.0197 0.0213 0.0228
A1 - 0.190 - - 0.0075 -
A2 - 0.350 - - 0.0138 -
b - 0.270 - - 0.0106 -
D - 1.289 1.309 - 0.0507 0.0515
E - 1.955 1.975 - 0.0769 0.0777
e - 1.000 - - 0.0393 -
e1 - 0.866 - - 0.0340 -
e2 - 0.500 - - 0.0196 -
e3 - 0.433 - - 0.0170 -
F - 0.202 - - 0.0079 -
G - 0.469 - - 0.0184 -
aaa - 0.110 - - 0.0043 -
bbb - 0.110 - - 0.0043 -
ccc - 0.110 - - 0.0043 -
ddd - 0.060 - - 0.0024 -
eee - 0.060 - - 0.0024 -

1. Values in inches are converted from mm and rounded to four decimal digits.

Figure 22. WLCSP8 - Recommended footprint
1.000 mm
0.433 mm
0.866 mm
Orientation
reference
8 bumps x  Ø 0.270 mm
0.500 mm
1. Dimensions are expressed in millimeters.
M24512-W M24512-R M24512-DF
WLCSP8 (CS) package information
DS6520 - Rev 31 page 36/47
```

### Page 37

```text
9.5 WLCSP8 (CU) package information
This WLCSP is a 8 balls, 1.289 x 1.955 mm, 0.5 mm pitch, with BSC, wafer level chip scale package
Figure 23. WLCSP8 - Outline
X
Y
D
E
aaa
(2X)
aaa
(2X)
Orientation reference
TOP VIEW
bbb Z
DETAIL A
BACKSIDE PROTECTION
A3 A1
A
A2
b
SIDE VIEW
Orientation referenceF
G
e
e2
e3
e1
BOTTOM VIEW
Z
eee Z
ccc
ddd
Z
Z
X YM
M
b
A1
Seating plane
DETAIL A
ROTATED 90
1. Drawing is not to scale.
2. Dimension is measured at the maximum bump diameter parallel to primary datum Z.
3. Primary datum Z and seating plane are defined by the spherical crowns of the bump.
4. Bump position designation per JESD 95-1, SPP-010.
M24512-W M24512-R M24512-DF
WLCSP8 (CU) package information
DS6520 - Rev 31 page 37/47
```

### Page 38

```text
Table 23. WLCSP8 - Mechanical data
Millimeters inches(1)
Min Typ Max Min Typ Max
A 0.262 0.295 0.328 0.0103 0.0116 0.0129
A1 - 0.095 - - 0.0037 -
A2 - 0.175 - - 0.0069 -
A3 - 0.025 - - 0.0010 -
b - 0.185 - - 0.0073 -
D - 1.289 1.309 - 0.0507 0.0515
E - 1.955 1.975 - 0.0772 0.0778
e - 1.000 - - 0.0394 -
e1 - 0.866 - - 0.0341 -
e2 - 0.500 - - 0.0197 -
e3 - 0.433 - - 0.0170 -
F - 0.212 - - 0.0083 -
G - 0.478 - - 0.0096 -
aaa - 0.110 - - 0.0188 -
bbb - 0.110 - - 0.0043 -
ccc - 0.110 - - 0.0043 -
ddd - 0.060 - - 0.0024 -
eee - 0.060 - - 0.0024 -

1. Values in inches are converted from mm and rounded to the 4rd decimal place

Figure 24. WLCSP8 - Recommended footprint
1.0
0.5
0.433
0.866
8 bumps x     0.185
1. Dimensions are expressed in millimeters.
M24512-W M24512-R M24512-DF
WLCSP8 (CU) package information
DS6520 - Rev 31 page 38/47
```

### Page 39

```text
10 Ordering information
Table 24. Ordering information scheme
Example: M24 512 - D W MC 6 T P /K
Device type
M24 = I2C serial access EEPROM
Device function
512 = 512 Kbit (64 K x 8 bit)
Device family
Blank = Without identification page
D = With identification page
Operating voltage
W = VCC = 2.5 V to 5.5 V
R = VCC = 1.8 V to 5.5 V
F = VCC = 1.7 V to 5.5 V
Package(1)
MN = SO8 (150 mil width)
DW = TSSOP8 (169 mil width)
MC = UFDFPN8 (DFN8)
CS = WLCSP (chip scale package)
CU = WLCSP Ultra-thin
Device grade
6 = Industrial: device tested with standard test flow over -40 to 85 °C
Option
T = Tape and reel packing
blank = tube packing
Plating technology
P or G = ECOPACK2
Process(2)
/K = Manufacturing technology code

1. ECOPACK2 (RoHS compliant and free of brominated, chlorinated and antimony oxide flame retardants).
2. These process letters appear on the device package (marking) and on the shipment box. Contact your nearest ST Sales
Office for further information

M24512-W M24512-R M24512-DF
Ordering information
DS6520 - Rev 31 page 39/47
```

### Page 40

```text
Table 25. Ordering information scheme (unsawn wafer)
Example: M24 512 - D F K W 20 I /90
Device type
M24 = I2C serial access EEPROM
Device function
512 = 512 Kbit (64 K x 8 bit)
Device family
D = With identification page
Operating voltage
F = VCC = 1.7 V to 5.5 V
Process
K = F8H
Delivery form
W =Unsawn wafer
Wafer thickness
20 = Non-backlapped wafer
Wafer testing
I = Inkless test
Device grade
90 = -40°C to 85°C
Note: For all information concerning the M24512 delivered in unsawn wafer, please contact your nearest ST Sales
Office.
Note: Parts marked as ES or E or accompanied by an Engineering Sample notification letter are not yet qualified and
therefore not approved for use in production. ST is not responsible for any consequences resulting from such
use. In no event will ST be liable for the customer using any of these engineering samples in production. ST’s
Quality department must be contacted prior to any decision to use these engineering samples to run a
qualification activity.
M24512-W M24512-R M24512-DF
Ordering information
DS6520 - Rev 31 page 40/47
```

### Page 41

```text
Revision history
Table 26. Document revision history
Date Revision Changes
31-Jan-2011 22
Updated Table 7, Table 13, Table 16 and Table 17.
Added note (2) to Table 14.
Deleted Table 22: Available M24512-W and M24512-R products (package, voltage
range, temperature grade) and Table 23: Available M24512-DR products (package,
voltage range, temperature grade).
01-Mar-2012 23
– Deleted reference “M24512-DR” and inserted reference “M24512-DF”.
– Updated data regarding package UFDFPN8.
– Updated Section 1: Description.
– Added Figure 4 and updated title of Figure 3.
– Updated VESD value in Table 7: Absolute maximum ratings, note (1) under Table
13 and ICC value in Table 14.
– Added Table 10: Operating conditions (voltage range F) and Table 15: DC
characteristics (voltage range F).
– Added values tWLDL and tDHWH in Table 16: 400 kHz AC characteristics and Table
17: 1 MHz AC characteristics.
– Replaced Figure 14.
12-Apr-2012 24 Updated Section 1: Description.
25-Jun-2012 25
Datasheet split into:
– M24512-125 datasheet for automotive products (range 3),
– M24512-W M24512-R M24512-DR M24512-DF for standard products (range 6,
this datasheet rev 25).
Deleted:
– SO8W package
– UFDFPN8 (MLP8): MB version package
– WLCSP (KA die) dimensions
Added:
– Reference M24512-DR
– Table 12: Cycling performance
– Table 13: Memory cell data retention
Updated:
– Figure 12: Maximum Rbus value versus bus parasitic capacitance (Cbus) for an
I2C bus at maximum frequency fC = 400 kHz
– Figure 13: Maximum Rbus value versus bus parasitic capacitance Cbus) for an
I2C bus at maximum frequency fC = 1MHz
17-Sep-2012 26
Updated Section 5.2.2: Current Address Read.
Modified Figure 3: WLCSP connections and Figure
M24512-W M24512-R M24512-DF
DS6520 - Rev 31 page 41/47
```

### Page 42

```text
Date Revision Changes
16-Feb-2015 27
Removed:
• Note on Figure 3
• Note 2 on Table 3
Updated:
• Note 1 on Table 12 and Table 13
• Table 18
• Figure 11
• Table 20
• Titles on Figure and Table 21
• Table 24
• Note 1 on Table 21
Added:
• Note 2 on Table 12
• Note 4 and 5 on Table 14
• Note 6, 7 and 8 on Table 15
• Note 6, 7 on Table 16
• Note 8 on Table 17
• Figure 20
• Reference to Engineering sample after Ordering information scheme
27-May-2015 28
Added:
• Unsawn wafer reference on cover page and Table 25: Ordering information
scheme (unsawn wafer)
• Note 1 on Table 12
• Removed ordering type M24512-DRxxxx from the whole document (device
replaced by either M24512-Rxxx or M24512-DFxxx)
22-Mar-2018 29
Added:
• WLCSP8 ultra thin package in cover page
• Section 9.5: WLCSP8 ultra thin package information
• Table 3: Device select code
Updated:
• Figure 3: WLCSP connections
• Table 10: AC measurement conditions
• Table 24: Ordering information scheme
21-Sep-2018 30
Updated:
• Figure 19: WLCSP - 8 bumps, 1.271 x 1.937 mm, 0.5 mm pitch wafer level
chip scale package outline
• Figure 21: WLCSP - 8 balls, 1.289x1.955 mm, 1 mm pitch, wafer level chip
scale package outline
06-Oct-2020 31
Updated:
• Features
• Figure 5. Block diagram
Added:
• Figure 16. UFDFPN8 - Recommended footprint
• Figure 18. TSSOP8 – Recommended footprint
Removed note in:
• Table 6. Absolute maximum ratings, Table 7. Operating conditions (voltage
range W), Table 8. Operating conditions (voltage range R), Table 9. Operating
conditions (voltage range F),Table 12. Cycling performance by groups of four
bytes, Table 13. Memory cell data retention, Table 14. DC characteristics
(M24512-W, device grade 6), Table 15. DC characteristics (M24512-R device
grade 6), Table 16. DC characteristics (M24512-DF, device grade 6),
Table 18. 1 MHz AC characteristics
M24512-W M24512-R M24512-DF
DS6520 - Rev 31 page 42/47
```

### Page 43

```text
Contents
1 Description ........................................................................ 2
2 Signal description ................................................................. 4
2.1 Serial Clock (SCL).............................................................. 4
2.2 Serial Data (SDA) .............................................................. 4
2.3 Chip Enable (E2, E1, E0) ........................................................ 4
2.4 Write Control (WC) ............................................................. 4
2.5 VSS (ground).................................................................. 4
2.6 Supply voltage (VCC) ........................................................... 5
2.6.1 Operating supply voltage (VCC) ............................................. 5
2.6.2 Power-up conditions ...................................................... 5
2.6.3 Device reset ............................................................ 5
2.6.4 Power-down conditions .................................................... 5
3 Memory organization .............................................................. 6
4 Device operation .................................................................. 7
4.1 Start condition ................................................................. 8
4.2 Stop condition ................................................................. 8
4.3 Data input..................................................................... 8
4.4 Acknowledge bit (ACK).......................................................... 8
4.5 Device addressing.............................................................. 9
5 Instructions ...................................................................... 10
5.1 Write operations .............................................................. 10
5.1.1 Byte Write ............................................................. 11
5.1.2 Page Write ............................................................ 12
5.1.3 Write Identification Page (M24128-D only) .................................... 13
5.1.4 Lock Identification Page (M24128-D only)..................................... 13
5.1.5 ECC (Error Correction Code) and Write cycling ................................ 13
5.1.6 Minimizing Write delays by polling on ACK .................................... 14
5.2 Read operations .............................................................. 15
5.2.1 Random Address Read................................................... 16
5.2.2 Current Address Read ................................................... 16
M24512-W M24512-R M24512-DF
Contents
DS6520 - Rev 31 page 43/47
```

### Page 44

```text
5.2.3 Sequential Read ........................................................ 16
5.3 Read identification page (M24512-D only)......................................... 16
5.4 Read the lock status (M24512-D only) ............................................ 17
6 Initial delivery state ............................................................... 18
7 Maximum rating .................................................................. 19
8 DC and AC parameters ........................................................... 20
9 Package information.............................................................. 29
9.1 UFDFPN8 (DFN8) package information........................................... 29
9.2 TSSOP8 package information ................................................... 31
9.3 SO8N package information ..................................................... 33
9.4 WLCSP8 (CS) package information .............................................. 35
9.5 WLCSP8 (CU) package information .............................................. 37
10 Ordering information ............................................................. 39
Revision history ....................................................................... 41
M24512-W M24512-R M24512-DF
Contents
DS6520 - Rev 31 page 44/47
```

### Page 45

```text
List of tables
Table 1.  Signal names ...................................................................... 2
Table 2.  Signal vs. bump position ............................................................... 3
Table 3.  Device select code................................................................... 9
Table 4.  Most significant address byte........................................................... 10
Table 5.  Least significant address byte .......................................................... 10
Table 6.  Absolute maximum ratings ............................................................ 19
Table 7.  Operating conditions (voltage range W) ................................................... 20
Table 8.  Operating conditions (voltage range R) .................................................... 20
Table 9.  Operating conditions (voltage range F) .................................................... 20
Table 10.  AC measurement conditions ........................................................... 20
Table 11.  Input parameters ................................................................... 21
Table 12.  Cycling performance by groups of four bytes ................................................ 21
Table 13.  Memory cell data retention ............................................................ 21
Table 14.  DC characteristics (M24512-W, device grade 6).............................................. 22
Table 15.  DC characteristics (M24512-R device grade 6) .............................................. 23
Table 16.  DC characteristics (M24512-DF, device grade 6) ............................................. 24
Table 17.  400 kHz AC characteristics ............................................................ 25
Table 18.  1 MHz AC characteristics ............................................................. 26
Table 19.  UFDFPN8 - Mechanical data........................................................... 30
Table 20.  TSSOP8 – Mechanical data ........................................................... 31
Table 21.  SO8N – Mechanical data ............................................................. 33
Table 22.  WLCSP8 - Mechanical data............................................................ 36
Table 23.  WLCSP8 - Mechanical data............................................................ 38
Table 24.  Ordering information scheme........................................................... 39
Table 25.  Ordering information scheme (unsawn wafer) ............................................... 40
Table 26.  Document revision history ............................................................. 41
M24512-W M24512-R M24512-DF
List of tables
DS6520 - Rev 31 page 45/47
```

### Page 46

```text
List of figures
Figure 1.  Logic diagram..................................................................... 2
Figure 2.  8-pin package connections, top view ..................................................... 2
Figure 3.  WLCSP connections ................................................................ 3
Figure 4.  Chip enable inputs connection ......................................................... 4
Figure 5.  Block diagram .................................................................... 6
Figure 6.  I2C bus protocol ................................................................... 7
Figure 7.  Write mode sequences with WC = 0 (data write enabled) ...................................... 11
Figure 8.  Write mode sequences with WC = 1 (data write inhibited)...................................... 12
Figure 9.  Write cycle polling flowchart using ACK .................................................. 14
Figure 10.  Read mode sequences ............................................................. 15
Figure 11.  AC measurement I/O waveform ....................................................... 21
Figure 12.  Maximum Rbus value versus bus parasitic capacitance (Cbus) for an I2C bus at maximum frequency fC = 400 kHz
.............................................................................. 27
Figure 13.  Maximum Rbus value versus bus parasitic capacitance (Cbus) for an I2C bus at maximum frequency fC = 1MHz 27
Figure 14.  AC waveforms ................................................................... 28
Figure 15.  UFDFPN8 - Outline ................................................................ 29
Figure 16.  UFDFPN8 - Recommended footprint .................................................... 30
Figure 17.  TSSOP8 – Outline ................................................................ 31
Figure 18.  TSSOP8 – Recommended footprint..................................................... 32
Figure 19.  SO8N – Outline .................................................................. 33
Figure 20.  SO8N - Recommended footprint ....................................................... 34
Figure 21.  WLCSP8 - Outline................................................................. 35
Figure 22.  WLCSP8 - Recommended footprint..................................................... 36
Figure 23.  WLCSP8 - Outline................................................................. 37
Figure 24.  WLCSP8 - Recommended footprint..................................................... 38
M24512-W M24512-R M24512-DF
List of figures
DS6520 - Rev 31 page 46/47
```

### Page 47

```text
IMPORTANT NOTICE – PLEASE READ CAREFULLY
STMicroelectronics NV and its subsidiaries (“ST”) reserve the right to make changes, corrections, enhancements, modifications, and improvements to ST
products and/or to this document at any time without notice. Purchasers should obtain the latest relevant information on ST products before placing orders. ST
products are sold pursuant to ST’s terms and conditions of sale in place at the time of order acknowledgement.
Purchasers are solely responsible for the choice, selection, and use of ST products and ST assumes no liability for application assistance or the design of
Purchasers’ products.
No license, express or implied, to any intellectual property right is granted by ST herein.
Resale of ST products with provisions different from the information set forth herein shall void any warranty granted by ST for such product.
ST and the ST logo are trademarks of ST. For additional information about ST trademarks, please refer to www.st.com/trademarks. All other product or service
names are the property of their respective owners.
Information in this document supersedes and replaces information previously supplied in any prior versions of this document.
© 2020 STMicroelectronics – All rights reserved
M24512-W M24512-R M24512-DF
DS6520 - Rev 31 page 47/47
```
