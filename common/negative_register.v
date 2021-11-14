
// same as register but is sensitive to falling edge of the clock
module negative_register(d_in, d_out, en, clk, rst);
	parameter DATA_WIDTH = 32;
	parameter RESET_VALUE = 0;
	input [DATA_WIDTH-1:0] d_in;
	input clk, rst, en;
	output reg [DATA_WIDTH-1:0] d_out;
	
	always @(negedge clk, negedge rst) begin
		if (~rst)
			d_out = RESET_VALUE;
		else if (en)
			d_out = d_in;
		else
			d_out = d_out;
	end
	
endmodule
