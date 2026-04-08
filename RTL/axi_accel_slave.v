module axi_accel_slave (
    input  wire clk,
    input  wire rst_n,

    // AXI-lite
    input  wire [5:0]  awaddr,
    input  wire        awvalid,
    output reg         awready,

    input  wire [31:0] wdata,
    input  wire        wvalid,
    output reg         wready,

    output reg         bvalid,
    input  wire        bready,

    input  wire [5:0]  araddr,
    input  wire        arvalid,
    output reg         arready,

    output reg [31:0]  rdata,
    output reg         rvalid,
    input  wire        rready
);

    // Registers
    reg [23:0] A_reg, B_reg;
    reg start_reg, valid_reg;

    wire done;
    wire [23:0] result;

    // Accelerator
    vector_add_with_fifo_accel accel (
        .clk(clk),
        .rst_n(rst_n),
        .start(start_reg),
        .valid_in(valid_reg),
        .A(A_reg),
        .B(B_reg),
        .done(done),
        .result(result)
    );

    // ---------------- WRITE ----------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            awready <= 0;
            wready  <= 0;
            bvalid  <= 0;
            start_reg <= 0;
            valid_reg <= 0;
            A_reg <= 0;
            B_reg <= 0;
        end else begin
            // Default: ready signals are only high for one cycle per transaction
            awready <= 0;
            wready  <= 0;

            // Clear start signal once the accelerator acknowledges or finishes
            if (done) begin
                start_reg <= 0;
                valid_reg <= 0;
            end

            // Only process if Master is sending valid Address AND Data
            // and we aren't already busy with a response (bvalid)
            if (awvalid && wvalid && !bvalid) begin
                awready <= 1;
                wready  <= 1;

                case (awaddr)
                    6'h08: A_reg <= wdata[23:0];
                    6'h0C: B_reg <= wdata[23:0];
                    6'h00: begin
                        if (wdata[0]) begin
                            start_reg <= 1; 
                            valid_reg <= 1;
                        end
                    end
                endcase
                bvalid <= 1;
            end

            // AXI Write Response Handshake
            if (bvalid && bready) begin
                bvalid <= 0;
            end
        end
    end

    // ---------------- READ ----------------
    reg read_pending;
    reg [5:0] addr_latched;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            arready <= 0;
            rvalid  <= 0;
            rdata   <= 0;
            read_pending <= 0;
        end else begin
            arready <= 0;

            if (arvalid && !read_pending) begin
                arready <= 1;
                addr_latched <= araddr;
                read_pending <= 1;
            end

            if (read_pending && !rvalid) begin
                case (addr_latched)
                    6'h04: rdata <= {31'b0, done};
                    6'h10: rdata <= result;
                    default: rdata <= 0;
                endcase
                rvalid <= 1;
            end

            if (rvalid && rready) begin
                rvalid <= 0;
                read_pending <= 0;
            end
        end
    end

endmodule