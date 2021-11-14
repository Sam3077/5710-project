
// output clk_out has a frequency of (1/DIVIDE_FACTOR)*x where x
// is the frequency of clk_in
module clock_divider(clk_in, clk_out);
	parameter DIVIDE_FACTOR = 2;
	input clk_in;
	output reg clk_out;
	
	// count is a 32 bit number.
	// if the clock must be divided more, dividers should be chained.
	reg [31:0] count;
	
	initial begin
		clk_out = 0;
		count = 0;
	end
	
	always @(clk_in) begin
		if (count == (DIVIDE_FACTOR - 1)) begin
			clk_out = ~clk_out;
			count = 0;
		else begin
			clk_out = clk_out;
			count = count + 1;
		end
	end	
	
endmodule
	