# emc-testing

## Goal

Conduct electromagnetic compatibility (EMC) testing on the complete Enigma-NG
system to verify it meets applicable standards before certification.

## Scope

- Radiated emissions testing (e.g. EN 55032 Class B or applicable class)
- Conducted emissions testing
- ESD immunity (EN 61000-4-2)
- Radiated immunity (EN 61000-4-3)
- Electrical fast transient / burst (EN 61000-4-4)
- Surge immunity (EN 61000-4-5)
- Conducted disturbance immunity (EN 61000-4-6)
- Power frequency magnetic field immunity (EN 61000-4-8)
- Voltage dips and interruptions (EN 61000-4-11)

The specific standards to be applied should be confirmed against the target
market (CE / FCC / UKCA) prior to scheduling a test lab.

## Acceptance Criteria

- Test report from accredited test lab showing pass against all applicable clauses
- Any failures documented and design changes made before re-test
- Final passing test report archived in the project records

## Dependencies

- `version-1-documentation` — documentation must be complete before test lab submission

## Notes

A pre-compliance scan (using an in-house or rented antenna + spectrum analyser)
is recommended before committing to a formal lab booking.
