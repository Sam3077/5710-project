module top_system(clk, rst, menu_button, next_button, select_button, 
happiness, hunger, health, clean,
exec, exec_status, selected, menu_open,
seconds,
minutes,
hours);
	parameter CLOCK_FREQ = 50;
	
   input clk;

   input rst, menu_button, next_button, select_button, exec_status;
        wire       Clk_5sec;
   
	output [31:0] happiness, hunger, health, clean;
	
	output [1:0] selected;
	output exec, menu_open;
	output [5:0] seconds;
	output [5:0] minutes;
	output [4:0] hours;
	
	clock_divider #(.DIVIDE_FACTOR(CLOCK_FREQ)) five_sec_divider (
		.clk_in(clk),
		.clk_out(Clk_5sec),
		.rst(rst)
	);
	
	watch watch_module (
		.Clk_5sec(Clk_5sec),
		.reset(rst),
		.seconds(seconds),
		.minutes(minutes),
		.hours(hours)
	);
	
	companion_interface #(.CLOCK_FREQ(CLOCK_FREQ)) comp(
		.clk(clk),
		.rst(rst),
		.menu_button(menu_button),
		.next_button(next_button),
		.select_button(select_button),
		.exec(exec),
		.exec_status(exec_status),
		.selected(selected),
		.menu_open(menu_open),
		.happiness(happiness),
		.hunger(hunger),
		.health(health),
		.clean(clean)
	);
endmodule
