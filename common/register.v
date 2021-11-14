module register(d_in, d_out, en, clk, rst);
	parameter DATA_WIDTH = 32;
	input [DATA_WIDTH-1:0] d_in;
	input clk, rst, en;
	output reg [DATA_WIDTH-1:0] d_out;
	
	always @(posedge clk, negedge rst) begin
		if (~rst)
			d_out = {DATA_WIDTH{1'b0}};
		else if (en)
			d_out = d_in;
		else
			d_out = d_out;
	end
	
endmodule
