# Plugboard Assembly - Mechanical Design Specification

**Status:** Draft
**Project:** Enigma-NG
**Author:** Izzyonstage & GitHub Copilot
**Version:** v.0.1.0
**Associated Hardware Revision:** Rev A
**Last Updated:** 2026-05-08

---

## 1. Overview

The Plugboard Assembly contains **two independent plugboard passes**. Each pass uses:

1. one Encoder Module in a **decode** role,
2. one 64-jack passive patch field, and
3. one Encoder Module in an **encode** role.

The full Plugboard Assembly therefore contains **four Encoder Modules total**:

- `PLG_PASS1_DEC`
- `PLG_PASS1_ENC`
- `PLG_PASS2_DEC`
- `PLG_PASS2_ENC`

Each jack socket bridges one decode-board output line to one encode-board input line within the same
pass. With no patch cable inserted, the jack's normally-closed contact preserves identity mapping.

---

## 2. Functional Requirements

| ID | Functional Requirement | Notes | Satisfied By / Cross-Ref |
| :--- | :--- | :--- | :--- |
| FR-PLG-01 | Accept encoder input signal via the passive plugboard jack interface | Per pass: 6.35 mm (1/4") mono switched jack (Tip + Switch contact on decode board; Sleeve on encode board) | See `design/Electronics/Encoder/Design_Spec.md` for generic Encoder Module interconnect details |

---

## 3. Design Requirements

| ID | Design Requirement | Specification | Satisfied By / Cross-Ref |
| :--- | :--- | :--- | :--- |
| DR-PLG-01 | Plugboard plug interface | Per pass: 64× 6.35 mm (1/4") mono switched jack sockets (Tip + Switch contact tied to decode-board spade terminal; Sleeve to paired encode-board spade terminal). 128 jack sockets total across both passes. | Assembly BOM — see §7. No PCB RefDes assigned; parts are panel-mounted and wired via harness only. |

---

## 4. Plugboard Jack-Sensing
>
> For signal polarity, insertion-detect logic, RC debounce circuit, and detection latency, see
> `design/Electronics/Encoder/Design_Spec.md §7 Plugboard Jack-Sensing`.

---

## 5. Physical Harness

Per plugboard pass there are **64 panel-mount 6.35 mm (1/4") mono switched jack sockets**, each
wired between the two Encoder Modules assigned to that pass (one decode role, one encode role).
The mapping is strictly **1:1**: jack socket N connects line N on both boards simultaneously —
every jack therefore has at least one pin terminated on each of the two ENC boards.

- **Decode side (Tip + Switch):** both contacts of jack socket N wire to spade terminal N on the
  **decode** Encoder Module (`J2-J65`, where J(N+1) = line N).
- **Encode side (Sleeve):** the Sleeve contact of jack socket N wires to spade terminal N on the
  **encode** Encoder Module (`J2-J65`, same index).

Per pass: **64× 3-wire assemblies** (Tip + Switch + Sleeve), each terminated with 6.35 mm female
crimp spade terminals.

The full Plugboard Assembly duplicates this harness set for **Pass 1** and **Pass 2**.

---

## 7. Assembly BOM

These parts are panel-mounted and connected to the PCB via wiring harness only. They carry no PCB
RefDes and do not appear in any board-level BOM.

| Item | Description | MPN | Manufacturer | Source | Qty per Pass | System Qty |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| Jack socket | 6.35 mm (1/4") mono switched jack socket, panel-mount | (no standard MPN) | generic | eBay — SaiBuy.Ltd | 64 | 128 |

---

## 8. Cross-References

| Document | Description |
| :--- | :--- |
| `design/Electronics/Encoder/Design_Spec.md` | Generic Encoder Module spade-terminal pinout (J2-J65), CPLD role allocation, jack-sensing electrical spec |
