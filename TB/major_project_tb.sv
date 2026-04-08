module major_project_tb;

    // Clock and Reset Signals
    logic clk;
    logic [4:0] push_buttons;
    logic [4:0] leds;
    
    // UART Physical Signals
    logic uart_rx;
    wire  uart_tx;

    // Parameters
    localparam CLK_PERIOD = 20;       // 50MHz
    localparam BAUD_RATE  = 115200;
    localparam BIT_PERIOD = 8680;     // (1/115200) * 10^9 ns

    // 1. Instantiate the Top-Level Module
    major_project_top uut (
        .clk          (clk),
        .push_buttons (push_buttons),
        .leds         (leds),
        .uart_rx      (uart_rx),
        .uart_tx      (uart_tx)
    );

    // 2. Clock Generation
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    // 3. SystemVerilog Task: Send Byte over UART
    // This mimics the PC sending data to your Cyclone IV
    task automatic send_uart_byte(input [7:0] data);
        begin
            // Start Bit
            uart_rx = 0;
            #(BIT_PERIOD);
            
            // Data Bits (LSB First)
            for (int i = 0; i < 8; i++) begin
                uart_rx = data[i];
                #(BIT_PERIOD);
            end
            
            // Stop Bit
            uart_rx = 1;
            #(BIT_PERIOD);
            $display("[%0t] [UART_TX] Byte 0x%h sent to FPGA", $time, data);
        end
    endtask

    // 4. Stimulus block
    initial begin
        // Initialize Inputs
        uart_rx = 1;
        push_buttons = 5'b11111; // Pull-ups (not pressed)
        
        $display("[%0t] Simulation Started", $time);

        // Reset Sequence
        #(CLK_PERIOD * 5);
        push_buttons[0] = 0; // Press Reset
        #(CLK_PERIOD * 10);
        push_buttons[0] = 1; // Release Reset
        $display("[%0t] System Reset Complete", $time);

        #(CLK_PERIOD * 50);

        // --- TEST CASE 1: Send Data to Accelerator ---
        // We send a byte via UART. Your Top level should map this 
        // to an AXI Write into slv_reg1.
        send_uart_byte(8'h05); 
        
        // Wait for AXI Write Response (BVALID mapped to LED 4)
        wait(leds[4] == 1);
        $display("[%0t] [AXI_OBS] Data received by Accelerator Slave", $time);
        #(CLK_PERIOD * 10);

        // --- TEST CASE 2: Trigger Calculation via Button ---
        // Pressing Button 1 manually triggers an AXI write to Control Reg
        push_buttons[1] = 0;
        #(CLK_PERIOD * 5);
        push_buttons[1] = 1;
        $display("[%0t] [BUTTON] Manual Trigger Pressed", $time);

        // Observe the internal result (slv_reg3) in the wave window
        #(BIT_PERIOD * 2);

        $display("[%0t] Simulation Finished", $time);
        $finish;
    end

    // 5. Assertions (Optional but good for SV)
    // Check that LED 4 eventually blinks after UART RX finishes
    always @(posedge leds[4]) begin
        $display("[%0t] [ASSERT] AXI Write Transaction Successful!", $time);
    end

endmodule
