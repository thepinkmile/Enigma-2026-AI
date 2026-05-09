# Todo: Actuation Module Component Diagram

**ID:** `am-component-diagram`
**Status:** pending
**Category:** Documentation improvements
**Source:** Session decision — per-board circuit component diagrams
**Blocked by:** —

---

## Description

Add a Mermaid `block-beta` component diagram to the **top of §1** in
`design/Electronics/Actuation_Module/Design_Spec.md`, immediately after the section heading,
before the existing overview prose and FR/DR tables.

Note: the AM is a shared service module — it is used both on the Controller Board
(depression-bar actuation) and on each Extension Board (group-boundary carry actuation).
The diagram should reflect this shared-service nature.

## Target File

`design/Electronics/Actuation_Module/Design_Spec.md`

Insert position: **top of §1 Overview**, after the title heading and the opening paragraph
(which explains the two usage contexts: Controller and Extension).

## Blocks to Show

| Block | Description | Key Components |
|-------|-------------|---------------|
| `HOST_DOCK` | BtB dock connector to host board (CTL or EXT) | J1 (Hirose DF40HC(3.5)-20 20-pin BtB plug) |
| `MCU` | STM32 microcontroller — homing, one-shot, PWM, diagnostics | U1 (STM32G071K8T3TR LQFP-32) |
| `SERVO_OUT` | Servo drive loom connector | J2 (servo loom header) |
| `HOME_SW` | Home switch loom connector | J3 (home switch loom header) |
| `DIAG_LEDS` | Local diagnostic LEDs (PWR, HOMED, ACT) | D1–D3, R1–R3 |
| `SWD_HDR` | SWD programming / service header | J4 (SWD header) |
| `UART_HDR` | UART bootloader / service header | J5 (UART header) |
| `RESET_BTN` | Local RESET_N momentary button | SW1 |
| `BOOT0_BTN` | Local BOOT0 momentary button | SW2 |

## Connections / Edges

| Edge | Label |
|------|-------|
| HOST_DOCK → MCU | 5V_MAIN, 3V3_ENIG, ACTUATE_REQUEST_N |
| MCU → SERVO_OUT | PWM servo signal |
| HOME_SW → MCU | Home position input |
| MCU → DIAG_LEDS | PWR / HOMED / ACT status |
| SWD_HDR → MCU | SWDIO, SWDCLK (SWD programming) |
| UART_HDR → MCU | TX, RX, BOOT0, RESET_N (UART bootloader) |
| RESET_BTN → MCU | RESET_N (active-low) |
| BOOT0_BTN → MCU | BOOT0 (bootloader entry) |

## Mermaid Type

Use `block-beta`. Suggested layout: HOST_DOCK on the left → MCU centre → SERVO_OUT and
HOME_SW on the right; DIAG_LEDS bottom-right; SWD_HDR, UART_HDR, RESET_BTN, BOOT0_BTN
as a service/debug cluster at the bottom.

## Notes

- Board stackup: 4-layer / 2oz (JLC04161H-7628).
- GND_CHASSIS: AM uses M2.5 NPTH exemption (DEC-057) — not GND_CHASSIS bonded.
- The AM PCB does not directly mount the servo or home switch — both are loom-connected
  to mechanical parts near the actuation bar. Show this with loom labels on SERVO_OUT
  and HOME_SW blocks.
- The host board (CTL or EXT) provides only power and ACTUATE_REQUEST_N — the AM is
  fully autonomous after that. Reflect this in the HOST_DOCK edge label.
- Do NOT show individual pin assignments — block-level connections only.
- Verify all refdes against `Actuation_Module/Design_Spec.md` BOM section before implementing.
