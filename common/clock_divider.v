
// output clk_out has a frequency of (1/DIVIDE_FACTOR)*x where x
// is the frequency of clk_in
module clock_divider(clk_in, clk_out, rst);
	parameter DIVIDE_FACTOR = 2;
	input clk_in, rst;
	output clk_out;
	
	// count is a 32 bit number.
	// if the clock must be divided more, dividers should be chained.
	wire [31:0] rising_count, falling_count, count;
	assign count = (rising_count > falling_count) ? rising_count : falling_count;
	
	reg [31:0] next_count;
	register count_reg(
		.d_in(next_count),
		.d_out(rising_count),
		.clk(clk_in),
		.rst(rst),
		.en(1'b1)
	);
	negative_register negative_count_reg(
		.d_in(next_count),
		.d_out(falling_count),
		.clk(clk_in),
		.rst(rst),
		.en(1'b1)
	);
	
	wire rising_event, falling_event;
	
	register #(.DATA_WIDTH(1)) rising_clk_register(
		.d_in(~rising_event),
		.d_out(rising_event),
		.clk(clk_in),
		.rst(rst),
		.en(count == (DIVIDE_FACTOR - 1))
	);
	negative_register #(.DATA_WIDTH(1)) falling_clk_register(
		.d_in(~falling_event),
		.d_out(falling_event),
		.clk(clk_in),
		.rst(rst),
		.en(count == (DIVIDE_FACTOR - 1))
	);
	assign clk_out = rising_event | falling_event;
	
	always @(count) begin
		if (count == (DIVIDE_FACTOR - 1)) begin
			next_count = 0;
		end
		else begin
			next_count = count + 1;
		end
	end
endmodule
	