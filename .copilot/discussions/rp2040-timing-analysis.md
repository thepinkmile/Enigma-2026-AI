# Technical Supplement: Propagation Delay & Timing Analysis for Multi-Stage Software-Routed Digital Enigma Subsystem

## 1. Context & Architectural Mapping
This supplement evaluates the timing and signal propagation implications of utilizing a Raspberry Pi Compute Module 5 (CM5) host to orchestrate the dynamic routing, variant emulation, and signal patching of a modular, hardware-accelerated digital Enigma machine. 

### Core Components
*   **Hardware Acceleration Subsystem:** Altera/Intel MAX II EPM570 CPLDs handle the core structural cryptographic rotor mappings and combinational transformations.
*   **Interfacing & Transport:** RP2040 microcontrollers behave as positional full-duplex SPI daisy-chain node controllers, acting as the dynamic injection and inspection points for the cryptographic data lines (ENC_DATA[5:0] / ENC_IN).
*   **System Scale Constraints:** The architecture accommodates a maximum of 6 horizontal mini-stacks (each housing 5 physical rotor boards), plus 4 to 6 external alternative routing components (e.g., custom plugboard modifications, unique clones, or variant reflectors). This structures a total network containing **12 to 18 software-orchestrated routing points / injection points**.

---

## 2. Theoretical Propagation Delay & Timing Analysis

Unlike an original mechanical Enigma machine—where the electrical path is completely asynchronous and moves at near the speed of light—this architecture quantizes the signal path across a serialized digital SPI bus whenever the CM5 software layer steps in to alter the routing topology between components.

### 2.1 Single-Hop Latency Breakdown (The Microsecond Pipeline)
For any single routing stage where the data must be read from an injection point, parsed via the active machine configuration table, and written to the next component's input, the latency per hop is defined by three factors:

1.  **SPI Wire Transmission Time:** A full-duplex 24-byte payload (4 bytes per board across a maximum 6-board stack) moving across a standard hardware SPI link running at a conservative **10 MHz** takes approximately **~19.2 microseconds**.
2.  **Linux Kernel System Call Overhead:** The context switch between the user-space routing application and the /dev/spidev low-level kernel driver introduces roughly **10 to 30 microseconds** of delay.
3.  **Software Evaluation Matrix:** The look-up overhead on the CM5 to cross-reference ENC_DATA[5:0] against the configuration table takes under **1 microsecond** in C/C++/Rust.

**Total Estimated Latency Per Single Routing Hop:** **~50 microseconds.**

### 2.2 Global System Latency Profile (Cumulative Run)
When a physical keypress triggers the system, the signal must propagate sequentially through up to 18 sequential software-routed points before rendering the final output on the target Enigma Lamp or display module.

*   **Total Expected Minimum Latency (12 Hops):** 12 * 50 microseconds = **600 microseconds (0.6 ms)**
*   **Total Expected Maximum Latency (18 Hops):** 18 * 50 microseconds = **900 microseconds (0.9 ms)**

### 2.3 Human Perception Threshold Verification
In human-machine interfaces, any input-to-output propagation delay that stays comfortably beneath **10 milliseconds** is perceived by the human operator as entirely zero-latency and instantaneous. Because the absolute worst-case round-trip evaluation of your 18-point cryptographic pipeline falls safely under **0.9 ms**, the system will feel completely responsive and tactile, with zero observable lag.

---

## 3. Four-Stage Software Propagation Architecture

Because the input data state of any given component depends entirely on the output transformation of the preceding component, a global snapshot cannot be read all at once. The CM5 application must handle the propagation as a synchronous state machine, driven by the physical hardware interrupt line: ENC_ACTIVE_N.

Upon detecting that a key has been depressed (ENC_ACTIVE_N pulls low), the host application executes the following sequential processing pipeline:

~~~
       [ Key Pressed: ENC_ACTIVE_N drops low ]
                         │
                         ▼
┌────────────────────────────────────────────────────────┐
│ STAGE 1: Read Stator Inputs                            │
│ ──► Send SPI Sync Frame                                │
│ ──► Capture active key data on the first board         │
└────────────────────────────────────────────────────────┘
                         │
                         ▼
┌────────────────────────────────────────────────────────┐
│ STAGE 2: Core Propagation Loop (Iterate 1 to 18)       │
│ ──► Process current ENCDATA[5:0] via active layout map │
│ ──► Update target RP2040 GPIO Output pins via SPI      │
│ ──► Wait for CPLD combinatorial delay (~10-20ns)       │
│ ──► Pull next SPI frame to read CPLD transformation    │
└────────────────────────────────────────────────────────┘
                         │
                         ▼
┌────────────────────────────────────────────────────────┐
│ STAGE 3: The Reflector Boundary (UKW Turnaround)       │
│ ──► Identify path reversal point from config table     │
│ ──► Feed transformed bits backward into the chain      │
└────────────────────────────────────────────────────────┘
                         │
                         ▼
┌────────────────────────────────────────────────────────┐
│ STAGE 4: Final Output Rendering                        │
│ ──► Write finalized byte to target Enigma Lamp/Display │
└────────────────────────────────────────────────────────┘
~~~

---

## 4. Hardware Optimization Rules for Peak Performance

To minimize any potential timing variability caused by the Linux operating system scheduler, the hardware and software layers should implement the following implementation guidelines:

### 4.1 Bus Speed Escalation
The RP2040’s Programmable I/O (PIO) state machines and the CM5’s hardware SPI peripherals can natively scale communications far beyond 10 MHz. Configuring the SPI clock rate to **25 MHz or 32 MHz** drops the 24-byte wire transmission time down to **~6–7 microseconds per frame**, pushing the entire 18-hop system loop time closer to **~400 microseconds total**.

### 4.2 CPLD Synchronization Matching
The Altera EPM570 CPLDs operate strictly via ultra-high-speed combinational logic, completing internal structural matrix transformations within a few nanoseconds (~5 to 10ns). Because this is virtually instant compared to the SPI bus, no software delay stages are required for the CPLD itself. To ensure a glitch-free read, the RP2040's local firmware must sample its GPIO pins immediately prior to shifting data back down the daisy-chain line.

### 4.3 Kernel Level Prioritization
Standard Linux can introduce minor, unpredictable scheduling stutters if background processes interrupt the main routing application. To enforce hard real-time execution predictability:
*   Write the primary Enigma routing engine in an unmanaged compiled language (C, C++, or Rust).
*   Utilize a real-time patched Linux kernel (PREEMPT_RT).
*   Elevate the execution thread's priority to a real-time scheduling class (SCHED_FIFO) to protect the time-critical ENC_ACTIVE_N polling loop.
