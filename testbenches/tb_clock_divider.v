`timescale 1 ns/1 ps

module tb_clock_divider();
	reg clk_in, rst;
	wire clk_out;
	
	clock_divider #(.DIVIDE_FACTOR(2)) uut(
		.clk_in(clk_in),
		.clk_out(clk_out),
		.rst(rst)
	);

	initial begin
		clk_in = 0;
		rst = 1;
		#12;
		rst = 0;
		#10;
		rst = 1;
	end
	
	always #5 clk_in <= ~clk_in;
endmodule
