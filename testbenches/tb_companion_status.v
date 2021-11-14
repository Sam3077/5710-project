`timescale 1 ns / 1 ps

module tb_companion_status();
	reg clk, rst, feed, play, clean_up;
	wire [31:0] health, happiness, clean, hunger;
	
	companion_status #(.CLOCK_FREQ(1)) uut(
		.clk(clk),
		.rst(rst),
		.hunger(hunger),
		.happiness(happiness),
		.clean(clean),
		.health(health),
		.feed(feed),
		.play(play),
		.clean_up(clean_up)
	);
	
	initial begin
		clk = 0;
		rst = 1;
		feed = 0;
		play = 0;
		clean_up = 0;
		#12;
		rst = 0;
		#10;
		rst = 1;
		
		
		#100000;
		feed = 1;
		#1000;
		feed = 0;
	end
		
	always #5 clk <= ~clk;
endmodule
	