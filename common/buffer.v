module buffer(in, out, clk);
	input in, clk;
	output reg out;
	
	reg b;
	
	always @(posedge clk)
		b = in;
		
	always @(negedge clk)
		out = b;
		
endmodule
