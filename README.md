# UART-Controlled AXI4-Lite FPGA Accelerator

## Overview

The system bridges low-speed serial communication (UART) with a standard on-chip bus (AXI4-Lite), replicating how real-world SoCs expose peripherals for software control.

---

## Block Diagram

<img width="1536" height="1024" alt="Block Diagram" src="https://github.com/user-attachments/assets/5d0b51d7-67ca-4c65-af0f-7401e007c77b" />

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

## 🧾 UART Command Format

The system accepts simple commands over UART to perform AXI read/write operations.

### Example:

WRITE <address> <data>  
READ  <address>

### Sample Interaction:

WRITE 0x00 0x05  
READ  0x04  

→ FPGA processes command and returns result over UART

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
* Implements AXI valid-ready handshake protocol
* Handles write and read transactions independently
* Ensures proper synchronization between UART input and AXI operations

### 4. Hardware Accelerator (AXI Slave)

* Memory-mapped register interface
* Performs computation based on input data

---

## Simulation & Verification

* Verified UART transmission and reception
* Verified at 115200 baud UART communication
* Successfully executed multiple read/write transactions without data loss
* Tested AXI read/write transactions
* Validated correct register access via simulation waveforms

---

## FPGA Implementation

- Target Device: Cyclone IV FPGA
- UART connected via USB-to-Serial interface

### Hardware Demo:

1. User sends command from PC terminal  
2. UART receives and decodes command  
3. AXI transaction executed on accelerator  
4. Result transmitted back over UART  

Example:
Input  → WRITE 0x00 0x05  
Output → Computed result returned via UART

## 🔑 Key Features

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

## 📊 Results

- Successful UART-to-AXI communication established
- Correct register read/write verified on hardware
- System demonstrates reliable PC-to-FPGA control interface

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
