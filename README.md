# FPGA-based-axi4-lite-hardware-accelerator-controlled-via-uart-bridge

📌 Project Overview
- This project implements a hardware acceleration system on an Altera Cyclone IV FPGA.
- It features a custom AXI4-Lite Slave interface that receives vector data from a PC via UART.
- The system performs vector addition using a FIFO-buffered architecture and displays results through physical onboard LEDs.
- To bridge the 5V logic of the USB-UART module with the 3.3V requirements of the FPGA, a custom voltage divider circuit was designed and implemented.

🚀 Key FeaturesProtocol
- AXI4-Lite compliant register interface.
- Communication: UART serial interface at 115200 Baud Rate.
- Processing: High-speed Vector Addition with synchronous FIFO buffering.
- Hardware Safety: 3-resistor voltage divider (5V to ~3.3V level shifting).
- UI: 5-bit LED output for real-time status and result verification.

🛠️ System Architecture
The design is modular and consists of the following
- RTL components:baud_gen: Generates sampling ticks for serial synchronization.
- uart_rx: Deserializes incoming 8-bit data from the UART bridge.
- axi_lite_slave: Manages the AXI4-Lite write handshakes (AWVALID, WVALID, BVALID).
- vector_add_with_fifo_accel: The processing core that performs the arithmetic.
- top: The top-level wrapper for pin mapping and signal routing.

🔌 Hardware SetupComponents Used:
- Altera Cyclone IV (EP4CE6) Development Board.
- CP2102 USB-to-UART TTL Module.
- 3x 1kΩ Resistors (Voltage Divider).
- Breadboard and Jumper Wires.
- Connection Table:ConnectionFromToSignal (TX)CP2102 TXFPGA PIN_23 (via Divider)GroundCP2102 GNDFPGA GND (Common Rail)ResetN/AOnboard Push ButtonExecuteN/AOnboard Push Button

💻 Software & ToolsQuartus Prime: 
- Synthesis and Bitstream generation.
- CuteCom: Serial terminal for sending vector data from Ubuntu.
- Verilog HDL: Hardware Description Language used for RTL.

📖 How to RunClone the Repo:

Bashgit clone https://github.com/your-username/FPGA-AXI-Accelerator.git

Synthesis: Open the project in Quartus, assign pins using the Pin Planner, and compile to generate the .sof file.Hardware Connection: Set up the voltage divider as shown in the schematics (TX $\rightarrow$ R1 $\rightarrow$ FPGA RX @ 3.3V).Deployment: Program the FPGA and open CuteCom (115200 Baud).Operation: Send two hex values (A and B). Press the start button on the FPGA to see the sum on the LEDs.

📂 Project Structure

Plaintext├── rtl/
│   ├── baud_gen.v
│   ├── uart_rx.v
│   ├── axi_lite_slave.v
│   ├── vector_add_with_fifo_accel.v
│   └── top.v
├── constraints/
│   └── pin_assignments.qsf
└── README.md


👤 AuthorBadrinath AyyamperumalElectronics and Communication Engineering
