## DEC-058 - JDB Connector Upgrade: Hat-Headers to DF40C-20 BtB

| **ID** | DEC-058 |
| --- | --- |
| **Status** | Accepted |
| **Date** | 2026-05-15 |
| **Author** | Izzyonstage & GitHub Copilot |
| **Associated Hardware Revision** | Rev A |

### Context

The JTAG Daughterboard (JDB) originally used two separate 2.54mm pin-header connectors: J1 (1×5 POWER INPUT) and J2 (1×10 JTAG OUTPUT).
These hat-style connectors produced a tall board-to-board stack of approximately 12-15mm, with no mechanical keying to prevent incorrect installation.
The JTAG signals were routed on separate pins with no differential-pair adjacency for the USB lines.
Following the AM daughterboard BtB upgrade pattern (DEC-057), a parallel upgrade was evaluated for the JDB.

### Decision

Replace J1 + J2 hat-header connectors with a single Hirose DF40C-20DP-0.4V(51) 20-pin board-to-board plug on the JDB,
mating with a Hirose DF40HC(3.5)-20DS-0.4V(51) receptacle (J12) on the CTL board.
The CTL board carries four M2.5×3.5mm Würth 9774035151R standoffs at MH13-MH16 to establish the 3.5mm stack height and provide mechanical support for the JDB.

### Rationale

- **Stack height**: 3.5mm vs ~12-15mm hat - significant reduction in mechanical profile within the chassis.
- **Positional keying**: Asymmetric mounting hole pattern (MH1/MH2 at corners top edge; MH3/MH4 inset bottom edge)
  combined with bottom-centre connector placement prevents incorrect orientation and rules out accidental mating with the AM dock location on the CTL board.
- **USB differential pair integrity**: USB+ (C5R2) and USB− (C6R2) are placed adjacent on the connector, forming a proper USB 2.0 FS differential pair as required.
- **Pattern consistency**: Matches the AM daughterboard BtB approach, standardising the daughterboard interface across the system.
- **VREF removal**: With 3V3_ENIG available directly on pin C7R1, a separate VREF pin is redundant; removing it simplifies the pinout.

### Finalised 20-Pin Pinout

```text
      C1     C2     C3     C4     C5     C6     C7     C8     C9    C10
 R1:  TCK    GND    GND    5V_U   GND    GND    3V3    GND    GND   TDI
 R2:  GND    TMS    GND    GND    USB+   USB-   GND    GND    TDO   GND
```

- R1 = outer (bottom) edge of JDB; when mounted on CTL, R1 must face toward LINK-BETA (J4/J5) to minimise JTAG trace length into the Stator.
- Abbreviations: 5V_U = 5V_USB, 3V3 = 3V3_ENIG, USB+/USB− = USB 2.0 FS differential pair.

### Connector Parts

| Board | RefDes | MPN | DigiKey | Mouser | JLCPCB |
| --- | --- | --- | --- | --- | --- |
| JDB | J1 | DF40C-20DP-0.4V(51) | H11618CT-ND | 798-DF40C20DP0.4V51 | C424637 |
| CTL | J12 | DF40HC(3.5)-20DS-0.4V(51) | 26-DF40HC(3.5)-20DS-0.4V(51)CT-ND | 798-DF40HC3520DS04V5 | C3644774 |
| CTL | MH13-MH16 | 9774035151R | 732-9774035151RCT-ND | 710-9774035151R | C22367582 |

### Deferred

- **FT232H 3.3V operation** (`jdb-ft232h-3v3-vregin`, v2.0): FT232H Rev C supports 3.0-3.6V on VREGIN,
  which would eliminate the 5V_USB pin from the connector entirely.
  Deferred pending Rev C availability confirmation; same timeline as display screen deferred todo.

### Files Affected

- `design/Electronics/JTAG_Daughterboard/Design_Spec.md`: DR-JDB-18/19/20 added; §3 pinout replaced with DF40 20-pin table; BOM rows updated.
- `design/Electronics/JTAG_Daughterboard/Board_Layout.md`: §1-§4 connector and ASCII art updated; §7.1 trace pin references updated; §8 Mounting Holes section added.
- `design/Electronics/Controller/Design_Spec.md`: DR-CTL-19/20 added; §8.3 replaced with DF40HC section and 20-pin pinout table; BOM J12/J13 hat-header rows removed, J12 DF40HC and MH13-MH16 rows added.
- `design/Electronics/Controller/Board_Layout.md`: ASCII art updated (`[ JDB DF40 dock ]`).
- `design/Electronics/Consolidated_BOM.md`: RS1-05-G CTL row removed (CTL no longer uses);
  RS1-10-G row removed (CTL J13 eliminated); PH1-05-UA JDB row removed; PH1-10-UA row removed;
  DF40HC CTL qty 1→2; DF40C-20DP JDB qty 0→1; 9774035151R CTL qty 4→8.
