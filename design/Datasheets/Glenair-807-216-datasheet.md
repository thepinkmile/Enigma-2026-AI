# Glenair 807-216 Series 807 NW connector references

## Source Reference

- Source PDF: [Glenair_03232018_807_216-3045547-datasheet.pdf](Glenair_03232018_807_216-3045547-datasheet.pdf)
- Source path: `design\Datasheets\Glenair_03232018_807_216-3045547-datasheet.pdf`
- Page count: 2
- Extracted text characters: 2350
- Empty extraction pages: none
- Source PDF: [Glenair_mighty-mouse-807-nw-connector_catalogue.pdf](Glenair_mighty-mouse-807-nw-connector_catalogue.pdf)
- Source path: `design\Datasheets\Glenair_mighty-mouse-807-nw-connector_catalogue.pdf`
- Page count: 4
- Extracted text characters: 6645
- Empty extraction pages: none
- PDF metadata title: `Mighty Mouse 807 NW Connector`
- PDF metadata author: `Glenair`
- Generated markdown: `Glenair-807-216-datasheet.md`
- Conversion method: automated local PDF text extraction with pypdf

## Reviewed Summary

- Scope: combined extraction from the Glenair `807-216` drawing-style datasheet PDF and the Glenair `Series 807 Mighty Mouse NW` catalogue / brochure PDF.
- Candidate part under review: `807-216-00ZNU6-6DY`. The catalogue lists it under **Series 807 NW Receptacles (6 socket)** with marks in the **PC Tail** and **Front Mount Jam Nut** columns.
- Drawing family: `807-216` is described as a **connector receptacle, push/pull type** using **#23 contacts**, **shell size 6**, and **15 lb pull out**.
- Insert arrangement: `6-6` = **6 #23 contacts**.
- Shell styles from the drawing: `00` = jam nut receptacle, front mount; `01` = in-line receptacle; `07` = jam nut receptacle, rear mount.
- Contact style codes from the drawing: `S` = socket solder cup, `D` = socket PC tail,
  `P` = pin solder cup, `C` = pin PC tail. Therefore the candidate suffix `DY` implies a
  **socket PC-tail** version with **Y keying**.
- Key positions documented on the drawing: `N`, `X`, `Y`, `Z`. The drawing provides alternate
  key / keyway rotation values and shows `Y` as a distinct keyed orientation.
- Review note: `Y` keying is verified as the standard battery keying for this connector family and
  is intended to prevent mating with data-only ports on standard in-service devices such as
  STAR-PAN and STAR-PAN NG.
- Catalogue positioning: Glenair markets Series 807 NW as the **"Nett Warrior Connector"**,
  calls out **NATO STANAG 4695** interoperability on the brochure cover, and describes the
  family as backward-compatible with current and legacy Nett Warrior hardware.
- Materials / finish from the brochure: shell = aluminum alloy with **ZNU plating**; contacts = copper alloy with **gold plating**; insulators = rigid dielectric; O-rings = fluorosilicone.
- Programme / ecosystem notes from the brochure: marketed for soldier power, battery charging,
  radio, PAN, STAR-PAN, and US Army / NATO Nett Warrior applications; the brochure also
  references newer 7-pin and 10-amp variants, but the candidate remains in the original
  **6-pin** receptacle family.
- Review caution: the drawing extraction contains only mechanical / ordering-code information
  plus panel cutout details; it does **not** by itself resolve the final Enigma-NG logical
  signal assignment across all six contacts. The second page of the drawing PDF appears to be a
  distributor artifact rather than part of the core Glenair drawing content.

## Extraction Notes

- Native text extraction was usable on both PDFs.
- The catalogue PDF provides programme and ordering context; the drawing PDF provides part-number breakdown and front/rear panel cutout information.
- Use the original PDFs for mechanical dimensions, cutout geometry, and any final procurement cross-check before schematic or PCB release.

## Page-by-Page Extracted Text

### Glenair_03232018_807_216-3045547-datasheet.pdf

#### Page 1

```text
S:\Controlled Distribution\GDC4S LW\Active\807-2162OF2.prt
  1 of 1
ADAPTER
B = MOLDING, BANDING ADAPTER (FOR 01 SHELL STYLE ONLY)
    (REF: 809-025; OMIT FOR NONE)
B°
A°
.542
.538
.479
.475
Ø.575
Ø.510
.038
.038
.076
.076
.066
.066
ARRANGEMENT NO. 6-6
  6 #23 CONTACTS
RECOMMENDED PANEL CUTOUT FOR
FRONT MOUNT JAM NUT RECEPTACLE
RECOMMENDED PANEL CUTOUT FOR
REAR MOUNT JAM NUT RECEPTACLE
NORMAL AND ALTERNATE POSITION
        KEY ROTATION
CONNECTOR RECEPTACLE, PUSH/PULL TYPE.
  #23 CONTACTS, PC TAIL/SOLDER CUP, 
  SHELL SIZE 6, 15 LB PULL OUT
APPROVED
APPROVED
SHELL SIZE/INSERT ARRANGEMENT NO.
07/19/04
2 OF 2
J
SEE SHEET 1
APPROVED
807-216
07/19/04
JLT
JLT
-
+
RELEASE DATE
NON REPARABLE COMMERCIAL ITEM
CAD 1997
N/A
N/A
C
1211 AIR WAY - GLENDALE - CALIFORNIA 91201
1
-
+
.005
.XXX
.010
.XX
-
+
1/16
-
+
ANGLES
DECIMALS
FRACTIONS
TOLERANCES:
DIMENSIONS ARE IN INCHES
UNLESS OTHERWISE SPECIFIED
DO NOT SCALE THIS DRAWING
B/F 3376
P/C 800
ENGR
CHECK
DRAWN
C
06324
APPROVED
RELEASE DATE
ORIGINAL
SIZE
CODE IDENT. NO.
SCALE
WEIGHT
SHEET
REV.
807-216
REVISIONS
APPROVED
DATE
DESCRIPTION
SYM.
CONTACT STYLE
S = SOCKET, SOLDER CUP
D = SOCKET, PC TAIL 
P = PIN, SOLDER CUP
C = PIN, PC TAIL
CLASS
SHELL  STYLE
00 = JAM NUT RECEPTACLE, FRONT MOUNT
01 = IN-LINE RECEPTACLE
07 = JAM NUT RECEPTACLE, REAR MOUNT.
CONNECTOR SERIES
807-216  - 07  ZNU 6-6  S  N  B    
EXAMPLE:
PART NUMBER DEVELOPMENT
KEY POSITION (SEE TABLE I)
N = NORMAL
X = POSITION X
Y = POSITION Y
Z = POSITION Z
1
6
5
4
3
2
POSITION
ALTERNATE KEY AND
KEYWAY POSITION
TABLE I
A°
150°
B°
210°
X
Y
Z
 75°
210°
 95°
230°
140°
N
275°
  FACE VIEW OF RECEPTACLE
AS VIEWED FROM ENGAGING END
THIS COPYRIGHTED DOCUMENT IS THE PROPERTY OF GLENAIR, INC. AND IS FURNISHED ON THE CONDITION THAT IT IS NOT TO BE DISCLOSED, REPRODUCED IN
WHOLE OR IN PART, OR USED TO SOLICIT QUOTATIONS FROM COMPETITIVE SOURCES, OR USED FOR MANUFACTURE BY ANYONE OTHER THAN GLENAIR, INC. WITHOUT
WRITTEN PERMISSION FROM GLENAIR, INC. THE INFORMATION HEREIN HAS BEEN DEVELOPED AT GLENAIR'S EXPENSE AND MAY BE USED FOR ENGINEERING
EVALUATION AND INCORPORATION INTO TECHNICAL SPECIFICATIONS AND OTHER DOCUMENTS WHICH SPECIFY PROCUREMENT OF PRODUCTS FROM GLENAIR, INC.
```

#### Page 2

```text
Mouser Electronics
  
Authorized Distributor
 
  
Click to View Pricing, Inventory, Delivery & Lifecycle Information:
 
 
 
 Glenair:   
  807-216-01ZNU6-6SYB
```

### Glenair_mighty-mouse-807-nw-connector_catalogue.pdf

#### Page 1

```text
Series 807 Mighty Mouse NW 
"The Nett Warrior Connector"
Crimp • PC Tail • Solder Cup • Pigtail Assemblies
NEW 10 AMP CONFIGURATIONS
INTERCONNECT  
SOLUTIONS
MISSION-CRITICAL
NOVEMBER 2022
INTEROPERABLE
NATO STANAG 4695
Soldier Power Connectors
/gid00015/gid00032/gid00047/gid00047/gid00001/gid00024/gid00028/gid00045/gid00045/gid00036/gid00042/gid00045
/gid00015/gid00024/gid00017/gid00002/gid00015/gid00183/gid00024/gid00017/gid00183/gid00133/gid00131/gid00133/gid00132/gid00131/gid00133/gid00133/gid00134
approved
HUB 
SYSTEM  
COMPATIBLE
807 nw
JTAC-TOUGH
QUALIFIED
```

#### Page 2

```text
© 2022 Glenair, Inc • 1211 Air Way, Glendale, CA 91201 • 818-247-6000 • www.glenair.com • U.S. CAGE code 06324 • STAR-PAN ™  Tactical Interconnect Solutions
Dimensions are subject to change without notice.
Nett Warrior Power and 
Data Connectors
Series 807 Mighty Mouse NW micro 
miniature connectors for dismounted 
soldier battery charging, radio, and 
PAN applications, NSN stock-listed.
PUSH-PULL QDC SERIES 807 MIGHTY MOUSE NW  
CONNECTOR LINE
All designs backward-compatible 
with current and legacy Nett 
Warrior hardware
	 Original 6-pin Nett Warrior 
plugs and receptacles
	 Backward-compatible 
7-pin series with USB-C 
power integration and 
delivery
	 New 10 Amp receptacles 
for higher-current soldier 
battery, radio, and PAN 
C4ISR equipment
Today’s warfighters demand quick battery charging and reliable radio operation. 
Glenair pioneered the original 6-pin Nett Warrior connector, as well as a second-
generation 7-pin series with USB-C power integration and delivery. Now Glenair is 
introducing a signature 10 Amp Crown Ring contact-equipped version for higher-
current applications that easily integrates into US / NATO, Nett Warrior, and STAR-PAN 
hub and cable systems. Contacts are capable of carrying 10 amps of current across 3 
separate channels with less than 30°C of temperature rise. Electrical resistance remains 
consistent across 2000 mating cycles. Best of all, Glenair has integrated the new 10 
Amp contact connectors into our next-generation STAR-PAN NG platform, ensuring 
intelligent, system-wide handling of warfighter electronic equipment-for both 10 
Amp-capable devices as well as lower-power legacy hardware.
Glenair STAR-PAN NG hubs and cables-now equipped with 10 Amp Crown Ring contact 
receptacles-are smart devices capable of managing next-generation high-power 
equipment as well as lower-power legacy devices.
```

#### Page 3

```text
© 2022 Glenair, Inc • 1211 Air Way, Glendale, CA 91201 • 818-247-6000 • www.glenair.com • U.S. CAGE code 06324 • STAR-PAN ™  Tactical Interconnect Solutions
Dimensions are subject to change without notice.
807 nw
JTAC-TOUGH
QUALIFIED
US ARMY AND NATO QUALIFIED
Nett Warrior Connectors
For STAR-PAN hub systems, Nett Warrior C4ISR 
hardware, next-gen and legacy radios and batteries
QUALIFIED FOR USE WITH  
ALL STAR-PAN AND STAR-PAN NG  
POWER / DATA HUBS
MATERIALS / FINISH
• Shell: Al alloy / ZNU plated 
• Contacts: Cu alloy / Au plated
• Insulators: Rigid dielectric
• O-rings: Fluorosilicone
Glenair Signature Mighty Mouse 
807 NW connectors are available in 
pigtail and point-to-point cables for 
all US/NATO soldier C4ISR devices.
SERIES 807 MIGHTY MOUSE NW CONNECTOR LINE: HOW-TO-ORDER 
Series 807 NW  
Plugs (6 pin) Crimp PC Tail Solder 
Cup In-Line
Rear 
Mount 
Jam Nut
Front 
Mount 
Jam Nut
8070-1676-06ZNU6-6PY
NSN 5935-01-659-5575 X X
807-871-06ZNU6-6PY X X
807-309-06ZNU6-6PY X X
8070-1153-07ZNU6-6EC X X
8070-1153-07ZNU6-6PC X X
8070-1153-00ZNU6-6EC X X
8070-1153-00ZNU6-6PC X X
Series 807 NW  
Receptacles (6 socket) Crimp PC Tail Solder 
Cup In-Line
Rear 
Mount 
Jam Nut
Front 
Mount 
Jam Nut
8070-1675-01ZNU6-6SY
NSN 5935-01-659-4090 X X
8070-1675-07ZNU6-6SY X X
8070-1675-00ZNU6-6SY X X
807-874-01ZNU6-6SY X X
807-874-00ZNU6-6SY X X
807-874-07ZNU6-6SY X X
807-348-01ZNU6-6SY X X
807-216-07ZNU6-6SY X X
807-216-01ZNU6-6SY X X
807-216-00ZNU6-6SY X X
807-216-07ZNU6-6DY X X
807-216-01ZNU6-6DY X X
807-216-00ZNU6-6DY X X
Series 807 NW  
Plugs (7 pin) Crimp PC Tail Solder 
Cup In-Line
Rear 
Mount 
Jam Nut
Front 
Mount 
Jam Nut
8070-1676-06ZNU6-7PY X X
807-871-06ZNU6-7PY X X
Series 807 NW  
Receptacles (7 socket) Crimp PC Tail Solder 
Cup In-Line
Rear 
Mount 
Jam Nut
Front 
Mount 
Jam Nut
8070-1675-01ZNU6-7SY X X
8070-1675-07ZNU6-7SY X X
8070-1675-00ZNU6-7SY X X
807-874-01ZNU6-7SY X X
807-874-00ZNU6-7SY X X
807-874-07ZNU6-7SY X X
8070-1299-ZNU6-7DY X X
Series 807 NW  
Receptacles (10 Amp)
Pigtail 
Assembly PC Tail Solder 
Cup In-Line
Rear 
Mount 
Jam Nut
Front 
Mount 
Jam Nut
8071-6924 X X
8070-3151-07ZNU6-6SY X X
Panel-
mount 
plug
In-line 
cable plug
Panel-
mount 
receptacle
In-line cable 
receptacle
Series 807 NW Nett Warrior Connector 
Insert Arrangements
6
5 4
3
21
Original NSN-Listed 6-Pin  
(Nett Warrior Program /  
NATO STANAG 4695 Approved)
76
5 4
3
21
Backward-Compatible  
7-Pin USB-C Power Series
6
5 4
3
21
76
5 4
3
21
10-Amp STAR-PAN NG Series 
6-6 and 6-7 Arrangements
```

#### Page 4

```text
Glenair, Inc.
1211 Air Way • Glendale, California • 91201-2497
Telephone: 818-247-6000 • Fax: 818-500-9912 • sales@glenair.com
www.glenair.com
Telephone:
+44-1623-638100
Facsimile:
+44-1623-638111
 sales@glenair.co.uk
Glenair UK  Ltd
40 Lower Oakham Way
Oakham Business Park
Mansfield, Notts  
NG18 5BY England
Telephone:
06172 / 68 16 0
Facsimile:
06172 / 68 16 90
info@glenair.de
Glenair GmbH
Schaberweg 28
61348 Bad Homburg
Germany
Telephone:
+33-5-34-40-97-40
Facsimile:
+33-5-61-47-86-10
sales@glenair.fr
Glenair France SARL
7, Avenue Parmentier
Immeuble Central Parc #2
31200 Toulouse
France
Telephone:
847-679-8833
Facsimile:
847-679-8849
Glenair Microway Systems
7000 North Lawndale Avenue
Lincolnwood, IL
60712
Telephone:
+46-8-50550000
sales@glenair.se
Glenair Nordic AB
Gustav III:s Boulevard 42
SE-169 27 Solna
Sweden
© 2022 Glenair, Inc. Printed in U.S.A. 
Mighty Mouse 807 NW Brochure • Nov. 2022
Telephone:
+34-925-89-29-88
Facsimile:
+34-925-89-29-87
sales@glenair.es
Glenair Iberica
C/ La Vega, 16
45612 Velada
Spain
Telephone:
203-741-1115
Facsimile:
203-741-0053
sales@glenair.com
Glenair East
20 Sterling Drive
Wallingford, CT 
06492
Telephone: 
+39-051-782811
Facsimile:
+39-051-782259
info@glenair.it
Telephone: 
+82-07-5067-2437
Facsimile:
+82-504-375-4549
sales@glenair.kr
Telephone: 
+81-52-569-2521
Facsimile:
+81-52-569-2523
sales@glenair.jp
Glenair Italia S.p.A.
Via Del Lavoro, 7 
40057 Quarto Inferiore - 
Granarolo dell’Emilia
Bologna, Italy
Glenair Korea 
6-21Tapsil-ro 58beon-gil
Giheung-gu, Yongin-si
Gyeonggi-do
Republic of Korea
Glenair Japan 
40F, Nagoya Lucent Tower,
6-1, Ushijima-cho,
Nishi-ku, Nagoya, 451-6040 
Japan
INTERCONNECT  
SOLUTIONS
MISSION-CRITICAL
```
