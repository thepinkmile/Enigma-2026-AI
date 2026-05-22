## DEC-061 - Pass 7 Review Corrections: CTL/STA/ROT/ENC/AM/GRS/Status Updates

| Field | Value |
| :--- | :--- |
| **Decision ID** | DEC-061 |
| **Status** | Confirmed |
| **Date** | 2026-05-08 |
| **Author** | Izzyonstage & Copilot (session a38ceaab) |
| **Amends** | Supersedes MH13–MH16 = JDB assignment in DEC-057 and DEC-058; correct mapping per this DEC: MH9–MH12 = JM dock standoffs, MH13–MH16 = CM5 SoM standoffs. |

### Context

A targeted review pass (Pass 7) of the active design documents identified a set of
minor but precise corrections required across several boards and the Global Routing
Specification. These are copy/accuracy issues rather than design intent changes:

1. **CTL Design_Spec §3:** A stale reference to `J13` appeared alongside `J12` in the
   JTAG pass-through description. The Controller Board carries a single JM BtB
   connector (`J12`); `J13` does not exist on this board.

2. **CTL Board_Layout §6:** Three cross-references to the Actuation Module design
   specification used an abbreviated filename (`AM Design_Spec.md`) rather than the
   full repo-relative path. Abbreviated paths are ambiguous in a multi-board repo and
   violate the cross-reference convention established in GRS §7.

3. **STA Design_Spec DR-STA-12:** The I²C address strapping for U6 and U7 was omitted
   from the Design Requirement row. DR-STA-13 already captured U8's strapping
   (`A2=LOW, A1=HIGH, A0=LOW`); DR-STA-12 required the same level of detail for U6
   (`0x20`) and U7 (`0x21`) to be complete and unambiguous.

4. **ROT Variant BOMs (N=26 and N=64):** The Notes fields for C20A/C21A and C20B/C21B
   contained variant-specific IC designators (`U11A`/`U11B`) and a design cross-reference
   (`see GRS §3.2`). BOM Notes must be factual component descriptions only; design intent
   and cross-references belong in the body text or Design Requirements.

5. **ENC Board_Layout §4.1, §4.2, §5.1/§5.2:** The 20-pin data-link connector was
   originally designated J2; it has since been renumbered to J1 (with the 64-line spade
   terminal bank now starting at J2). Several sections of the Board_Layout still used the
   old J2 and J3-J66 designators.

6. **AM Design_Spec BOM:** The Footprint Available column used the string `Yes` instead
   of the project-standard checkmark `✔`. All other board BOMs use `✔`; the AM BOM
   was inconsistent.

7. **GRS §4.3 Named Exceptions table - JM row:** The JM standoff range was listed as
   `MH13-MH16`, which is the CM5 SoM standoff group on the Controller Board. The JM
   dock standoffs are `MH9-MH12` per `Controller/Design_Spec.md §8` and `DR-CTL-21`.

8. **Status headers:** All board Design_Spec and Board_Layout files that had advanced
   past initial drafting were updated from `**Status:** Draft` to `**Status:** In Review`,
   consistent with the Pass 7 review milestone. The Extension Board files remain at
   `Draft` as that board has not entered review. `Boards_Overview.md` was updated from
   `Reference` to `In Review`, and the Extension Board row in its status table was
   corrected from `**In Review**` to `**Draft**`.

### Decision

Apply all eight corrections as described above. These are accuracy fixes only; no design
intent is changed. The JTAG pass-through topology, I²C address map, BOM MPNs/part
numbers, routing rules, and mounting hole patterns are unaltered.

### Rationale

- Accurate cross-references are required for document traceability and tooling that parses
  design files by path.
- I²C address strapping must be captured in the Design Requirement (not inferred) to
  prevent assembly errors.
- BOM Notes must be factual component descriptions to remain valid across variant and
  common BOMs without variant-specific assumptions.
- RefDes consistency between schematic, layout, and documentation is mandatory to avoid
  assembly and test errors.
- The footprint availability checkmark convention (`✔`) is used uniformly across all
  other board BOMs and must be consistent for BOM tooling.
- Correct MH range in GRS §4.3 prevents confusion between the JM standoff group and the
  CM5 SoM standoff group during assembly.

### Files Changed

- `design/Electronics/Controller/Design_Spec.md`: §3 J13 stale reference removed; J12 described as JM BtB connector. Status updated to In Review.
- `design/Electronics/Controller/Board_Layout.md`: §6 three abbreviated `AM Design_Spec.md` cross-references expanded to full repo-relative paths. Status updated to In Review.
- `design/Electronics/Stator/Design_Spec.md`: DR-STA-12 U6 and U7 I²C address strapping added. Status updated to In Review.
- `design/Electronics/Stator/Board_Layout.md`: Status updated to In Review.
- `design/Electronics/Rotor/Design_Spec.md`: Status updated to In Review.
- `design/Electronics/Rotor/Rotor_26_Char_Design.md`: C20A and C21A BOM Notes corrected. Status updated to In Review.
- `design/Electronics/Rotor/Rotor_64_Char_Design.md`: C20B and C21B BOM Notes corrected. Status updated to In Review.
- `design/Electronics/Encoder/Board_Layout.md`: §4.1, §4.2, §5.1, §5.2 RefDes updated: J2→J1 (data connector), J3-J66→J2-J65 (64-line bank). Status updated to In Review.
- `design/Electronics/Encoder/Design_Spec.md`: Status updated to In Review.
- `design/Electronics/Actuation_Module/Design_Spec.md`: BOM Footprint Available column `Yes` → `✔`. Status updated to In Review.
- `design/Electronics/Actuation_Module/Board_Layout.md`: Status updated to In Review.
- `design/Electronics/Power_Module/Design_Spec.md`: Status updated to In Review.
- `design/Electronics/Power_Module/Board_Layout.md`: Status updated to In Review.
- `design/Electronics/JTAG_Module/Design_Spec.md`: Status updated to In Review.
- `design/Electronics/JTAG_Module/Board_Layout.md`: Status updated to In Review.
- `design/Electronics/User_Settings_Module/Design_Spec.md`: Status updated to In Review.
- `design/Electronics/User_Settings_Module/Board_Layout.md`: Status updated to In Review.
- `design/Electronics/Reflector/Design_Spec.md`: Status updated to In Review.
- `design/Electronics/Reflector/Board_Layout.md`: Status updated to In Review.
- `design/Electronics/Boards_Overview.md`: Status header updated Reference → In Review; Extension Board table row corrected In Review → Draft.
- `design/Standards/Global_Routing_Spec.md`: §4.3 JM Named Exception row MH13-MH16 corrected to MH9-MH12.
