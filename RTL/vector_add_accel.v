module vector_add_accel #(
    parameter DATA_W = 24
)(
    input  wire                 clk,
    input  wire                 rst_n,

    input  wire                 start,
    input  wire [DATA_W-1:0]    A,
    input  wire [DATA_W-1:0]    B,

    output reg  [DATA_W-1:0]    result,
    output wire                 done,
    output wire                 busy
);

    wire [DATA_W-1:0] sum;

    // Instantiate core
    vector_add_core #(.DATA_W(DATA_W)) u_core (
        .A(A),
        .B(B),
        .C(sum)
    );

    // Instantiate controller
    vector_add_ctrl u_ctrl (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .done(done),
        .busy(busy)
    );

    reg [DATA_W-1:0] A_reg, B_reg;

	

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			A_reg <= 0;
			B_reg <= 0;
			result <= 0;
		end else begin
			if (start) begin
				A_reg <= A;
            B_reg <= B;
			end

			if (busy) begin
            result <= A_reg + B_reg;
			end
    end
end

endmodule
