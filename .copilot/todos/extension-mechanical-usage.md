# Extension interconnect architecture review

**ID:** `extension-mechanical-usage`
**Status:** pending
**Category:** Electronics
**Source:** `plan.md`
**Blocked by:** None

---

## Description

Review how Extension boards interconnect within a full system for each supported rotor-count variation (5, 10, 15, 20, 25, 30 rotors). Although originating from a mechanical question (where and how extension boards physically link between rotor groups), this is primarily an electronics todo — the findings will drive structural changes to the Stator, Reflector, and Extension boards.

### Proposed architectural direction (under review)

- **Stator + Reflector merge:** Combine the Stator and Reflector board functions onto a single board to reduce part count and simplify the end-of-chain return path.
- **Extension A / Extension B split:** Divide the current single Extension Board into two boards:
  - **Extension-A:** Mid-stack signal bridge and JTAG buffer (current Extension Board core function).
  - **Extension-B:** End-of-group return path / reflector turnaround for non-final rotor groups.
- **Connector replacement:** Replace the current Adam Tech 2BHR-30-VUA IDC shrouded headers (J7/J8 on Extension, J4 on Reflector, J10 on Stator) with a more mechanically robust connector family appropriate for the system's modular assembly and repeated insertion requirements.

### Impact

Changes here will affect the Stator, Reflector, and Extension board design specifications and BOMs. This todo gates `coupon-testing-review` and will influence `full-pn-review`.

## Notes

The shared AM (Actuation Module) architectural answer is already locked; this review is focused on the inter-board extension interconnect topology only.

When the architecture is resolved, update the system architecture diagrams in both `README.md` and `design/Electronics/Boards_Overview.md` §1.1 to reinstate a representation of Groups 2–6 (Rotors 6–30) within the rotor stack, which was removed during diagram simplification pending this review.
