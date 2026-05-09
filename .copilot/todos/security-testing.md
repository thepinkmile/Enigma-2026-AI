# security-testing

## Goal

Conduct security testing of the Enigma-NG encryption stack, key management,
hardware interfaces, and firmware to verify the system meets its security
objectives prior to release.

## Scope

- **Encryption stack review** — verify the CPLD-implemented encryption logic
  against the design specification; confirm no exploitable fault modes
- **Key management audit** — review key generation, storage, zeroisation, and
  transport across the CM5 / CPLD boundary
- **JTAG / debug interface hardening** — verify that JTAG is correctly disabled
  or gated in production builds; confirm no unauthenticated debug access
- **Firmware integrity** — verify boot chain, signature verification, and update
  mechanism; confirm no rollback to insecure firmware versions
- **Physical attack surface** — review tamper-evident features and any side-channel
  leakage (power analysis, timing) relevant to the encryption implementation
- **Network / USB attack surface** — review all external interfaces (RJ45, USB3,
  HDMI) for unintended attack surface; confirm firewall / isolation between
  encrypted and unencrypted domains

## Acceptance Criteria

- Independent security review report (internal or external) with no critical or
  high-severity findings unresolved
- All medium-severity findings assessed and mitigated or formally accepted with
  documented rationale
- Test coverage documented against the encryption and security requirements in the
  Controller Board and Stator Design Specs

## Dependencies

- `version-1-documentation` — documentation must be complete before security review

## Notes

Consider engaging an independent third-party reviewer with cryptographic hardware
expertise for the encryption stack and key management audit.
