
// output clk_out has a frequency of (1/DIVIDE_FACTOR)*x where x
// is the frequency of clk_in
// this module is only accurate if DIVIDE_FACTOR is an even number

module clock_divider(clk_in, clk_out, rst);
   parameter DIVIDE_FACTOR = 2;
   input clk_in, rst;
   output clk_out;

   wire [31:0] count;
   reg [31:0] next_count;
   reg        next_clk_out;
   
   
   register count_reg(
		      .d_in(next_count),
		      .d_out(count),
		      .clk(clk_in),
		      .rst(rst),
		      .en(1'b1)
		      );
   register #(.DATA_WIDTH(1)) out_reg(
				      .d_in(next_clk_out),
				      .d_out(clk_out),
				      .clk(clk_in),
				      .rst(rst),
				      .en(1'b1)
				      );
   
   always @(negedge clk_in, negedge rst) begin
      if (~rst) begin
	 next_clk_out <= 0;
	 next_count <= 0;
      end
      else if (count * 2 >= (DIVIDE_FACTOR)) begin
	 next_clk_out <= ~clk_out;
	 next_count <= 1;
      end
      else begin
	 next_clk_out <= clk_out;
	 next_count <= count + 1;
      end
   end
   
endmodule // clock_divider

/*
module clock_divider(clk_in, clk_out, rst);
	parameter DIVIDE_FACTOR = 2;
	input clk_in, rst;
	output reg clk_out;

   buf(clk_in, last_change);   
   
   always @(clk_in)
     last_change = clk_in;
   
   
	// count is a 32 bit number.
	// if the clock must be divided more, dividers should be chained.
   wire [31:0] 	   rising_count, falling_count;
   wire [31:0] 	   count;
   assign count = (last_change) ? rising_count : falling_count;
   
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
	
        always @(count) begin
	   if (~rst) begin
	      clk_out = 0;
	      next_count = 1;
	   end
	   else if (count == (DIVIDE_FACTOR)) begin
	      clk_out = ~clk_out;
	      next_count = 1;
	   end
	   else begin
	      clk_out = clk_out;
	      next_count = count + 1;
	   end
	end
endmodule
*/
