/* Many of the outputs from this should be used by the graphics module.
 *	exec_status must be assert to 1 when an execution is finished. This is meant to
 * allow time for an animation to play after interacting with the companion.
 */
module companion_interface
	(clk, rst, menu_button, next_button, select_button, 
	happiness, hunger, health, clean,
	exec, exec_status, selected, menu_open);
	parameter CLOCK_FREQ = 125_000_000;
	
   input clk;
   input rst, menu_button, next_button, select_button, exec_status;
	output [31:0] happiness, hunger, health, clean;
	
	output [1:0] selected;
	output exec, menu_open;
	
	companion_fsm fsm(
		.clk(clk),
		.rst(rst),
		.menu_button(menu_button),
		.next_button(next_button),
		.select_button(select_button),
		.exec_status(exec_status),
		.exec(exec),
		.selected(selected),
		.menu_open(menu_open)
	);
	
	companion_status #(.CLOCK_FREQ(CLOCK_FREQ)) status(
		.clk(clk),
		.rst(rst),
		.hunger(hunger),
		.happiness(happiness),
		.health(health),
		.clean(clean),
		.feed((selected == 2'b01) & exec),
		.play((selected == 2'b10) & exec),
		.clean_up((selected == 2'b11) & exec)
	);
endmodule
