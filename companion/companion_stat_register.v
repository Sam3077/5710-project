module companion_stat_register(clk, tick, value, refresh, rst);
	parameter MAX_VALUE = 10;
	
	input tick, refresh, rst, clk;
	output [31:0] value;
		
	reg [31:0] next_val;
	
	wire delayed_refresh;
	
	// delaying the refresh signal half a clock cycle gives us time
	// to set the new next_val variable.
	buffer b(.in(refresh), .out(delayed_refresh), .clk(clk), .rst(rst));
	
	register #(.RESET_VALUE(MAX_VALUE)) stat_reg(
		.d_in(next_val),
		.d_out(value),
		.en(1'b1),
		.clk(tick | delayed_refresh),
		.rst(rst)
	);
		
	
	always @(value, refresh) begin
		if (refresh)
			if (value >= (MAX_VALUE - 1))
				next_val = MAX_VALUE;
			else
				next_val = value + 2;
		else
			if (value == 0)
				next_val = 0;
			else
				next_val = value - 1;
	end
	
endmodule
