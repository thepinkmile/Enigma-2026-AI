# Technical Proposal: Architecture Redesign for Stackable Modular Subsystem via SPI Daisy-Chain

## 1. Executive Summary & Objective

This document proposes an architectural overhaul of the current microcontroller and I/O expander subsystem. The goal is to transition from a localized, address-constrained topology into a highly scalable, single-sided, stackable modular system capable of expanding dynamically without pre-assigning I2C addresses.

### Current Architecture

*   **Master Controller:** STM32G071K8T3TR.
*   **Peripherals:** 1x 5V RC Servo (Actuator) controlled via STM32 PWM; 1x MCP-series I2C 16-channel GPIO expander.
*   **Limitations:** Hard-capped expansion limits imposed by fixed hardware I2C addresses (typically maximum 8 devices); routing bottlenecks on the host master controller; complex multi-tiered firmware compilation.

### Proposed Architecture

*   **System Host:** Raspberry Pi Compute Module 5 (CM5) running a unified Linux application layer.
*   **Modular Node Controller:** Raspberry Pi RP2040 Microcontroller running identical, positional-aware firmware.
*   **Communications:** High-speed hardware SPI Daisy-Chain topology.
*   **Expansion Target:** Up to 6 identical boards stacked horizontally/sideways via mating right-angle connectors.

---

## 2. Power Delivery Architecture & Electrical Specifications

The system relies entirely on an independent, high-capacity external power distribution board capable of supplying **5V @ 9A (max)** and **3.3V @ 6A (max)**. To eliminate voltage sag and ripple from inductive loads without adding local Low-Dropout (LDO) regulators, the power subsystem relies on massive, segmented bulk storage networks.

### 2.1 Dual-Rail 5-Capacitor Star Networks

Each modular board implements two entirely separate 5-capacitor bulk reservoir networks arranged in a graduated star topology to handle energy storage and suppress low-frequency sag.

#### 5V Actuator Rail (High-Current/Low-Frequency Damping)

*   **Central Capacitor:** 1x 100uF to 220uF Low-ESR Tantalum or Aluminum Polymer capacitor. This acts as the heavy energy reservoir for the servo's mechanical transients and stall currents. 
*   **Star Points:** 4x identical-value Ceramic Capacitors (e.g., 10uF or 22uF) connected in parallel.
*   **Placement:** Clustered physically adjacent to the high-current servo-driving MOSFET switching network.
*   **Voltage Derating:** Due to aggressive inrush rise times, the tantalum capacitor must be rated to **at least 10V**.

#### 3.3V RP2040 Logic Rail (Logic Isolation/Damping)

*   **Central Capacitor:** 1x 22uF or 47uF Tantalum capacitor.
*   **Star Points:** 4x identical-value Ceramic Capacitors (matching the value of the 5V ceramics to maintain component BOM uniformity).
*   **Placement:** Positioned at the entry point of the 3.3V rail from the stacking headers.
*   **Anti-Resonance Mitigation:** The natural ESR of the central tantalum capacitor (0.1 Ohm to 0.5 Ohm) intentionally dampens the low-ESR ceramic caps and parasitic trace inductances, eliminating high-frequency ringing and tank-circuit oscillations.

### 2.2 Local High-Frequency Decoupling

Completely separated from the bulk storage stars, dedicated, independent **10uF ceramic decoupling capacitors** must be placed directly at the VCC / IOVDD power pins of the RP2040 and external QSPI Flash memory ICs.

### 2.3 The 1.1V Core Exception

The RP2040 features an internal digital core regulator that drops 3.3V down to 1.1V (VREG_VOUT). To maintain regulator stability and prevent boot failures:
*   The 1.1V core input pins (DVDD) must be decoupled **strictly with 1uF ceramic capacitors**, bypassing the global 10uF IC decoupling rule.

---

## 3. Physical Layer Stackup & Manufacturing Constraints

The PCB is engineered as a high-density, single-sided assembly to minimize manufacturing passes and optimize electromagnetic shielding.

### 3.1 4-Layer Coaxial Shielded Stackup

Layer 1 (Top):     Components + 100% Pure Unbroken Ground Plane (GND)
Layer 2 (Inner):   Power Pours (Geographically split 3.3V and Localized 5V)
Layer 3 (Inner):   High-Speed Signals (SPI Daisy-Chain, GPIO, Controls)
Layer 4 (Bottom):  100% Pure Unbroken Ground Plane (GND) - No components, no traces

*   **Stripline Reference:** All signal traces are restricted to Layer 3. Because they are sandwiched between the Layer 2 Power planes and the Layer 4 Ground shield, they form stripline conductors, granting complete immunity from external EMI and preventing high-speed signal crosstalk.
*   **Geographic Partitioning:** To preserve a perfect, unbroken 3.3V reference plane under the Layer 3 signal traces, the 5V pour on Layer 2 is restricted to a tight, localized boundary directly beneath the servo connector and driving FETs. The remaining surface area of Layer 2 is a solid 3.3V power plane.

### 3.2 Via-In-Pad & Manufacturing Specifications

*   **Trace Restraints:** Zero electrical routing is permitted on Layer 1 and Layer 4. Components sit on Layer 1 and drop connections immediately down to the inner layers.
*   **Via Fill Specification:** All vias must be **resin or copper-filled and planarised with a copper cap (IPC-4761 Type VII Via-in-Pad)**. This allows vias to be placed directly within SMD component pads without causing solder wicking defects during reflow.
*   **Thermal Management:** Thermal relief wheels must be applied to the inner-layer plane connections (Layers 2 and 3) for all signal/power vias and Through-Hole stacking headers to ease solderability.
*   **Current-Density Bottlenecks:** To safely transition 9A on 5V and 6A on 3.3V from Layer 1 header pads down to Layer 2, multi-via clusters must be used in parallel:
    *   **5V Rail / Main GND Return:** Minimum of 6 to 8 parallel 0.3mm drill filled vias.
    *   **3.3V Rail:** Minimum of 4 to 5 parallel 0.3mm drill filled vias.

---

## 4. Signal Topology & Inter-Board Communication

The system ditches explicit hardware addressing in favor of a **positional SPI Daisy-Chain** driven by the CM5 Host.

### 4.1 Stacking Header Interconnect Pinout

Boards stack horizontally using right-angle male headers on the left and right-angle female sockets on the right. To enable a uniform, single-PCB design, the routing is staggered:

1.  **Pin 1 (GND):** Parallel (Passes straight through to next board).
2.  **Pin 2 (GND):** Parallel.
3.  **Pin 4 (5V Rail):** Parallel.
4.  **Pin 5 (5V Rail):** Parallel.
5.  **Pin 6 (5V Rail):** Parallel (Three pins dedicated to split the 9A delivery load safely across contacts).
6.  **Pin 7 (3V3 Rail):** Parallel.
7.  **Pin 8 (3V3 Rail):** Parallel (Two pins dedicated to split the 6A logic load).
8.  **Pin 9 (SCK / Clock):** Parallel bus.
9.  **Pin 10 (CS / Chip Select):** Parallel bus.
10. **Pin 11 (Data In / MOSI Proxy):** Connected to the *Left Input Header* only; routes straight to the RP2040's input pin.
11. **Pin 12 (Data Out / MISO Proxy):** Connected from the RP2040's output pin straight to the *Right Output Header*.

When Board (N) plugs into Board (N+1), Data Out from (N) physically connects to Data In of (N+1).

'''text
 [ CM5 Host ]             [ Board 1 ]             [ Board 2 ]
   MOSI   -------------->  Data In                
                           Data Out ------------>  Data In
   MISO   <--------------------------------------- Data Out (Return Trace Loop)
   SCLK   =================== SCK =================== SCK (Parallel Bus)
   CE0    =================== CS  =================== CS  (Parallel Bus)
'''

*Note: A dedicated physical return trace line must be mapped back through the stacking headers to loop the final board's Data Out back to the CM5 MISO pin.*

### 4.2 Signal Conditioning

To protect the RP2040 pins from high-frequency signal reflections and damp impedance mismatches caused by the multi-board capacitive load, **22 Ohm to 47 Ohm series termination resistors** must be placed on the Data In and Data Out lines directly adjacent to the RP2040 pins on Layer 3.

---

## 5. Firmware Strategy & Core Logic Implementation

Every modular board is flashed with the **exact same compiled firmware binary**, eliminating production overhead.

### 5.1 RP2040 Programmable I/O (PIO) Core

The standard hardware SPI peripheral on microcontrollers cannot easily natively daisy-chain because it expects independent tri-state control over the MISO line. The RP2040 bypasses this via its custom **PIO state machine assembly blocks**:

1.  The PIO continuously monitors the shared **CS** line.
2.  When **CS drops low**, the PIO samples incoming bits from the Data In pin on the rising edge of **SCK**.
3.  Simultaneously, it shifts out old bits to the Data Out pin on the falling edge of **SCK**, acting identically to a hardware shift register.
4.  When **CS pulls high**, the accumulated 32-bit packet data is pushed directly to the RP2040's core RAM via Direct Memory Access (DMA).

### 5.2 The 1.1V Core Island Logic

To connect the internal 1.1V regulator loop entirely on inner layers without disturbing the 3.3V reference plane:

*   A tiny, isolated **1.1V copper island is carved out on Layer 2** directly under the physical center footprint of the RP2040 chip.
*   The VREG_VOUT pin drops a filled via to this island.
*   The two DVDD core pins drop filled vias to this island.
*   This encapsulates the entire 1.1V network underneath the chip, utilizing minimal area and maintaining complete isolation from the main 3.3V logic plane.

### 5.3 CM5 Software Packet Architecture

The Linux host software controls the entire stack positionally using a packed byte array via /dev/spidevX.Y. A 4-byte (32-bit) packet is mapped for each board:

'''text
+------------------------+------------------------+

|  Bytes 1-2 (16 bits)   |  Bytes 3-4 (16 bits)   |
+------------------------+------------------------+

|   GPIO Pin States      |  Actuator PWM Duty     |
|   (On/Off High/Low)    |  Cycle (Microseconds)  |
+------------------------+------------------------+
'''

To update a 6-board stack, the CM5 streams a single continuous 24-byte payload. The data intended for Board 6 is clocked out first, cascading down the chain until CS latches, meaning software index mapping natively correlates to physical stacking positions.

---

## Peer-Review Feedback Focus Areas

When submitting this document to your repository, you can ask your peers to focus on:

1. Thermal Dissipation on Inner Layer 2: Will a 15.5mm pour width on 0.5 oz inner copper adequately handle the 9A transient spikes of the actuator without regional hot-spots?
2. PIO Assembly Timing: Verification of the PIO state machine execution boundaries to ensure zero-bit slip at target clock frequencies (e.g., 25MHz).
3. Inrush Suppression: Whether the host power supply soft-start curve can safely handle the simultaneous step-response charging of the 60 distributed capacitors without triggering over-current protection (OCP).
