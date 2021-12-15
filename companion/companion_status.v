// assuming a 125 MHz clock
module companion_status(clk, rst, hunger, happiness, clean, health, feed, play, clean_up);
	parameter CLOCK_FREQ = 125_000_000;

	input clk, rst, feed, play, clean_up;
	output [31:0] hunger, happiness, clean, health;
	wire per_sec, hunger_tick, happiness_tick, clean_tick, health_tick;
	
	// generate a signal that ticks once per second
	clock_divider #(.DIVIDE_FACTOR(CLOCK_FREQ)) prescaler (
		.clk_in(clk),
		.clk_out(per_sec),
		.rst(rst)
	);
	
	// 600 seconds = 10 minutes
	clock_divider #(.DIVIDE_FACTOR(600)) hunger_scaler(
		.clk_in(per_sec),
		.clk_out(hunger_tick),
		.rst(rst ^ feed)
	);
	
	// 900 seconds = 15 minutes
	clock_divider #(.DIVIDE_FACTOR(900)) clean_scaler(
		.clk_in(per_sec),
		.clk_out(clean_tick),
		.rst(rst ^ clean_up)
	);
	
	// 720 seconds = 12 minutes
	clock_divider #(.DIVIDE_FACTOR(720)) happiness_scaler(
		.clk_in(per_sec),
		.clk_out(happiness_tick),
		.rst(rst ^ play)
	);
	
	clock_divider #(.DIVIDE_FACTOR(300)) health_scaler(
		.clk_in(per_sec),
		.clk_out(health_tick),
		.rst(rst)
	);
	
	companion_stat_register hunger_register(
		.tick(hunger_tick),
		// can't feed them if they're dead!
		.refresh(feed & (health != 0)),
		.rst(rst),
		.value(hunger),
		.clk(clk)
	);
	
	companion_stat_register clean_register(
		.tick(clean_tick),
		.refresh(clean_up & (health != 0)),
		.rst(rst),
		.value(clean),
		.clk(clk)
	);
	
	companion_stat_register happiness_register(
		.tick(happiness_tick),
		.refresh(play & (health != 0)),
		.rst(rst),
		.value(happiness),
		.clk(clk)
	);
	
	companion_stat_register health_register(
		// health only decays if something else is at 0.
		.tick(health_tick & (hunger == 0 || clean == 0 || happiness == 0)),
		.refresh((hunger == 10) & (clean == 10) & (happiness == 10)),
		.rst(rst),
		.value(health),
		.clk(clk)
	);
	
endmodule
