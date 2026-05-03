# Plugboard Assembly - Mechanical Design Specification

**Status:** Draft
**Project:** Enigma-NG
**Author:** Izzyonstage & GitHub Copilot
**Version:** v.0.1.0
**Associated Hardware Revision:** Rev A
**Last Updated:** 2026-04-20

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
| DR-PLG-01 | Plugboard plug interface | Per pass: J1 = 6.35 mm (1/4") mono switched jack (Tip + Switch contact tied to decode-board line; Sleeve to paired encode-board line) | BOM J1 (x64 jack sockets per pass, 2 passes total) |

---

## 4. Plugboard Jack-Sensing
>
> For signal polarity, insertion-detect logic, RC debounce circuit, and detection latency, see
> `design/Electronics/Encoder/Design_Spec.md §7 Plugboard Jack-Sensing`.

---

## 5. Physical Harness

Per plugboard pass:

- **64x 3-wire assemblies** (Tip wire + Switch wire + Sleeve wire), each terminated with 6.35 mm
  female crimp spade terminals.
- Tip and Switch both terminate on the paired **decode** Encoder Module output bank.
- Sleeve terminates on the paired **encode** Encoder Module input bank.

The full Plugboard Assembly duplicates this harness set for **Pass 1** and **Pass 2**.

---

## 6. Cross-References

| Document | Description |
| :--- | :--- |
| `design/Electronics/Encoder/Design_Spec.md` | Generic Encoder Module spade-terminal pinout, CPLD role allocation, jack-sensing electrical spec |
