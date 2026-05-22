## DEC-067 - AM SW1/SW2 Tactile Switch Rating Accepted for Production

| Field | Value |
| :--- | :--- |
| **Decision ID** | DEC-067 |
| **Status** | Confirmed |
| **Date** | 2026-05-12 |
| **Author** | Izzyonstage & Copilot |
| **Amends** | - |

### Context

The Actuation Module carries two through-hole tactile switches adjacent to the UART service header
(J5): SW1 (RESET\_N) and SW2 (BOOT0), both specified as the Omron B3F-1070 (50 gf, rated 50,000
cycles). The purpose of these switches is to enter the STM32G071K8T3TR ROM bootloader for UART
firmware loading - hold SW2 (BOOT0), press and release SW1 (RESET\_N), then release SW2. This
procedure is only needed at manufacturing time for initial firmware load and, rarely, during field
maintenance if a firmware update is required and the primary SWD path (J4) is unavailable.

### Decision

SW1 and SW2 shall remain as the Omron B3F-1070 (or equivalent SPST NO through-hole tactile switch)
for production. No higher-rated or alternative switch type is required.

### Rationale

The B3F-1070 is rated for 50,000 actuation cycles. Given that the buttons are used exclusively for
manufacturing-time programming and occasional maintenance firmware updates - not by end users and
not as part of normal operation - the expected lifetime actuation count is negligible relative to
the rated cycle life. Longevity is not a concern. The existing part is appropriate and no change is
warranted.

### Files Changed

- None - no design change; decision documents a confirmed review outcome.
