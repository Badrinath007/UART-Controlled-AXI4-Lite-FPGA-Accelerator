# UART-Controlled AXI4-Lite FPGA Accelerator

## Overview

- This project implements a UART-controlled hardware accelerator using an AXI4-Lite interface on FPGA.

- The system allows a host PC to communicate with an FPGA accelerator via UART, enabling register read/write operations through a custom AXI4-Lite bridge.

- This design mimics real-world SoC architectures where peripherals are accessed through memory-mapped interfaces.

---

## System Architecture

PC (Terminal)

↓

UART RX

↓

Command Decoder

↓

AXI4-Lite Master Interface

↓

Hardware Accelerator (AXI Slave Registers)

↓

Result → UART TX → PC

---

## Design Components

### 1. UART Interface

* Implements asynchronous serial communication (TX/RX)
* Configurable baud rate
* Handles byte-level data transfer

### 2. UART Command Decoder

* Parses incoming UART commands
* Converts them into AXI read/write transactions

### 3. AXI4-Lite Master

* Generates AXI transactions (address, data, control)
* Interfaces with hardware accelerator registers

### 4. Hardware Accelerator (AXI Slave)

* Memory-mapped register interface
* Performs computation based on input data

---

## Simulation & Verification

* Verified UART transmission and reception
* Tested AXI read/write transactions
* Validated correct register access via simulation waveforms

(Add GTKWave screenshots here)

---

## FPGA Implementation

* Implemented on Cyclone IV FPGA
* UART connected via USB-to-Serial interface
* Tested using CuteCom

### Demo:

* User sends command from PC
* FPGA processes via AXI interface
* Result returned over UART

---

## Key Features

* UART-to-AXI protocol bridging
* Memory-mapped register control
* Modular RTL design
* Hardware validation on FPGA

---

## Tools Used

* Verilog / SystemVerilog
* Quartus Prime
* GTKWave

---

## Challenges & Learnings

* Handling AXI handshake signals correctly
* Synchronizing UART data with AXI transactions
* Debugging hardware communication issues

---

## 🔮 Future Improvements

* Add FIFO buffering for UART
* Support burst transactions
* Extend to AXI4 / AXI-Stream
* Integrate with RISC-V core
