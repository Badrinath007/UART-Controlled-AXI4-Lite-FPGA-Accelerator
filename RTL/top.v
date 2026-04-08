module top (
    input wire clk,
    input wire rst_n,
    output wire [4:0] led
);
	 
    // AXI signals
    reg [5:0] awaddr;
    reg awvalid;
    wire awready;

    reg [31:0] wdata;
    reg wvalid;
    wire wready;

    wire bvalid;
    reg bready;

    reg [5:0] araddr;
    reg arvalid;
    wire arready;

    wire [31:0] rdata;
    wire rvalid;
    reg rready;

    // Instantiate slave
    axi_accel_slave slave (
        .clk(clk),
        .rst_n(rst_n),
        .awaddr(awaddr),
        .awvalid(awvalid),
        .awready(awready),
        .wdata(wdata),
        .wvalid(wvalid),
        .wready(wready),
        .bvalid(bvalid),
        .bready(bready),
        .araddr(araddr),
        .arvalid(arvalid),
        .arready(arready),
        .rdata(rdata),
        .rvalid(rvalid),
        .rready(rready)
    );
	 

    reg [4:0] state;

    always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 0;
        awvalid <= 0; wvalid <= 0; bready <= 0;
        arvalid <= 0; rready <= 0;
    end else begin
        case(state)

        // WRITE A = 5
        0: begin
            awaddr <= 6'h08;
            wdata  <= 5;
            awvalid <= 1;
            wvalid  <= 1;
            state <= 1;
        end

        1: begin
            awvalid <= 0; wvalid <= 0;
            bready  <= 1;
            if (bvalid) begin
                bready <= 0;
                state <= 2;
            end
        end

        // WRITE B = 3
        2: begin
            awaddr <= 6'h0C;
            wdata  <= 3;
            awvalid <= 1;
            wvalid  <= 1;
            state <= 3;
        end

        3: begin
            awvalid <= 0; wvalid <= 0;
            bready  <= 1;
            if (bvalid) begin
                bready <= 0;
                state <= 4;
            end
        end

        // START
        4: begin
            awaddr <= 6'h00;
            wdata  <= 1;
            awvalid <= 1;
            wvalid  <= 1;
            state <= 5;
        end

        // START done → go to wait state
		  5: begin
				awvalid <= 0; wvalid <= 0;
				bready  <= 1;
				if (bvalid) begin
					bready <= 0;
					state <= 6;
				end
		  end

		  // WAIT for done
		  6: begin
				araddr <= 6'h04;  // status register
				arvalid <= 1;
				state <= 7;
		  end

		  7: begin
				arvalid <= 0;
				rready  <= 1;

				if (rvalid) begin
					rready <= 0;

					if (rdata[0] == 1) begin
						state <= 8;  // done reached
					end else begin
						state <= 6;  // keep polling
					end
				end
			end

			// READ RESULT after done
			8: begin
				araddr <= 6'h10;
				arvalid <= 1;
				state <= 9;
			end

			9: begin
				arvalid <= 0;
				rready  <= 1;

				if (rvalid) begin
					rready <= 0;
					state <= 10;
				end
			end

			10: state <= 10;

        endcase
    end
end
	 
    // LEDs (active LOW)
    assign led[0] = ~rvalid;
    assign led[1] = ~rdata[0];
    assign led[2] = ~rdata[1];
    assign led[3] = ~rdata[2];
    assign led[4] = ~rdata[3];

endmodule