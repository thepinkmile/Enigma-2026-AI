# Checkpoint 117 — JDB BtB Connector Upgrade Complete

## Summary

The JTAG Daughterboard (JDB) has been upgraded from two separate 2.54mm hat-headers (J1 5-pin POWER INPUT + J2 10-pin JTAG OUTPUT) to a single Hirose DF40C-20DP-0.4V(51) 20-pin board-to-board plug, mirroring the AM daughterboard BtB pattern established in DEC-057. All six target files have been edited. DEC-058 has been appended to Design_Log.md. All changes are unstaged pending user review.

## Work Completed

- `design/Electronics/JTAG_Daughterboard/Design_Spec.md`
  - FR collapse: FR-JDB-01 and former FR-JDB-02 merged into single functional requirement (FR renumber deferred as `jdb-fr-renumber`)
  - §3 External Connectors: replaced J1/J2 hat-header rows with DF40C-20DP 20-pin BtB pinout table
  - DR-JDB-18 (DF40C connector), DR-JDB-19 (3.5mm clearance), DR-JDB-20 (R1 orientation toward LINK-BETA) added
  - BOM updated: old J1 (PH1-05-UA) and J2 (PH1-10-UA) rows removed; new J1 DF40C-20DP-0.4V(51) row added
  - Mounting holes section updated: M2.5 3.5mm standoffs, asymmetric hole pattern, GRS cross-ref
  - §7 "No external connectors" note updated to reference DF40 as internal BtB only (avoids review-agent ESD forcing)
  - Line 103: pre-emptive DEC-058 cross-reference preserved

- `design/Electronics/JTAG_Daughterboard/Board_Layout.md`
  - §1 ASCII art updated (hat-header layout removed, DF40 bottom-centre shown)
  - §2 simplified layout description updated
  - §3+§4 replaced with 20-pin DF40 pinout table
  - §7.1 trace pin references updated to match new connector pinout
  - §8 Mounting Holes section added (MH1–MH4 locations, asymmetric pattern, 3.5mm clearance zone)

- `design/Electronics/Controller/Design_Spec.md`
  - DR-CTL-19 (J12 DF40HC dock for JDB) added
  - DR-CTL-20 (no-component zone + MH13–MH16 + PCB layout deferred) added
  - §8.3 fully replaced: DF40HC(3.5)-20DS-0.4V(51) section with 20-pin pinout table
  - BOM: old J12/J13 hat-header rows removed; new J12 DF40HC row added; MH13–MH16 standoffs row added

- `design/Electronics/Controller/Board_Layout.md`
  - ASCII art: `[ JDB headers ]` → `[ JDB DF40 dock ]`

- `design/Electronics/Consolidated_BOM.md`
  - RS1-05-G: removed `CTL: J12` from RefDes; CTL Qty 1→0; System Qty 16→15
  - RS1-10-G: entire row removed (CTL J13 was sole user)
  - PH1-05-UA: removed `JDB: J1` from RefDes; JDB Qty 1→0; System Qty 11→10
  - PH1-10-UA: entire row removed (JDB J2 was sole user)
  - DF40HC(3.5)-20DS: added `CTL: J12` to RefDes; CTL Qty 1→2; System Qty 2→3
  - DF40C-20DP: added `JDB: J1` to RefDes; JDB Qty 0→1; System Qty 1→2
  - 9774035151R: added `CTL: MH13-MH16` to RefDes; CTL Qty 4→8; System Qty 8→12

- `design/Design_Log.md`
  - DEC-058 appended (JDB BtB connector upgrade decision, rationale, pinout, parts, files affected, deferred FT232H 3V3 todo)
  - No existing entries modified

## SQL Todo Updates

- `jdb-standoff-height` — marked done
- `mh-refdes-standardise` — unblocked (was blocked on `jdb-standoff-height`); now pending
- `jdb-fr-renumber` — added as pending (deferred FR renumbering cleanup)
- `jdb-ft232h-3v3-vregin` — added as blocked (v2.0 deferred, pending FT232H Rev C confirmation)

## Key Technical Decisions

**Finalised 20-pin pinout (user: "spot on"):**
```
      C1     C2     C3     C4     C5     C6     C7     C8     C9    C10
 R1:  TCK    GND    GND   5V_U   GND    GND   3V3    GND    GND    TDI
 R2:  GND    TMS    GND    GND   USB+   USB-   GND    GND    TDO    GND
```
- R1 = outer (bottom) edge of JDB; must face toward LINK-BETA on CTL when mounted
- 5V_U = 5V_USB, 3V3 = 3V3_ENIG; USB+/USB− adjacent (USB 2.0 FS differential pair)
- VREF removed — redundant with 3V3_ENIG on C7R1

**CTL mounting hole allocation:**
| Holes | Purpose | BOM Component |
|:------|:--------|:--------------|
| MH1–MH4 | CM5 SoM (M2.5 4mm standoffs) | ✓ |
| MH5–MH8 | AM dock (M2.5 3.5mm SMT) | 9774035151R ✓ |
| MH9–MH12 | Chassis (M3 PTH, GND_CHASSIS) | None — GRS plain holes |
| MH13–MH16 | JDB dock (M2.5 3.5mm SMT) | 9774035151R ✓ |

## Status

All changes are **unstaged** — user must confirm with "Let's lock this in" or "Save state" to proceed to commit.

## Pending / Deferred

- `jdb-fr-renumber` — renumber JDB FR identifiers consecutively (deferred cleanup)
- `jdb-ft232h-3v3-vregin` — FT232H Rev C VREGIN operation (v2.0, blocked)
- `mh-refdes-standardise` — now unblocked; pending
