module buffer(in, out, clk, rst);
   parameter DATA_WIDTH = 1;
   
   input clk, rst;
   input [DATA_WIDTH-1:0] in;
   
   output [DATA_WIDTH-1:0] out;

   wire [DATA_WIDTH -1:0] b;

   register #(.DATA_WIDTH(DATA_WIDTH)) b_reg(
					     .d_in(in),
					     .d_out(b),
					     .en(1'b1),
					     .clk(clk),
					     .rst(rst)
					     );

   negative_register #(.DATA_WIDTH(DATA_WIDTH)) out_reg(
							.d_in(b),
							.d_out(out),
							.en(1'b1),
							.clk(clk),
							.rst(rst)
							);
   
					     	
endmodule
