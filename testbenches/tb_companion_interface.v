`timescale 1 ns/1 ps

module tb_companion_interface();
	reg clk, rst, menu_button, next_button, select_button, exec_status;
	wire exec, menu_open;
	wire [1:0] selected;
	wire [31:0] happiness, hunger, health, clean;
	
	companion_interface #(.CLOCK_FREQ(1)) uut(
		.clk(clk),
		.rst(rst),
		.menu_button(menu_button),
		.next_button(next_button),
		.select_button(select_button),
		.exec_status(exec_status),
		.exec(exec),
		.menu_open(menu_open),
		.selected(selected),
		.happiness(happiness),
		.hunger(hunger),
		.health(health),
		.clean(clean)
	);
	
	always @(posedge exec) begin
		case(selected)
			2'b01: $display("Executing feed");
			2'b10: $display("Executing play");
			2'b11: $display("Executing clean up");
		endcase
		exec_status = 0;
	end
	
	initial begin
		clk = 0;
		rst = 1;
		menu_button = 1;
		next_button = 1;
		select_button = 1;
		exec_status = 1;
		#12;
		rst = 0;
		#10;
		rst = 1;
		#10;
		
		#100_000;
		
		// ==== feed action ====
		while (hunger < 10) begin
			// open menu
			menu_button = 0;
			#20;
			menu_button = 1;
			#20;
			// select first open
			select_button = 0;
			#20;
			select_button = 1;
			#1000;
			// assert execution is finished
			exec_status = 1;
			
			// close menu
			#20;
			menu_button = 0;
			#20;
			menu_button = 1;
		end
		
		#5_000;
		
		// ==== play action ====
		while (happiness < 10) begin
			menu_button = 0;
			#20;
			menu_button = 1;
			#20;
			next_button = 0;
			#20;
			next_button = 1;
			#20;
			select_button = 0;
			#20;
			select_button = 1;
			#1000;
			exec_status = 1;
			
			// close menu
			#20;
			menu_button = 0;
			#20;
			menu_button = 1;
		end
		
		#10_000;
		// ==== clean up action ====
		while (clean < 10) begin
			menu_button = 0;
			#20;
			menu_button = 1;
			#20;
			next_button = 0;
			#20;
			next_button = 1;
			#20;
			next_button = 0;
			#20;
			next_button = 1;
			#20;
			select_button = 0;
			#20;
			select_button = 1;
			#3000;
			exec_status = 1;
			
			// close menu
			#20;
			menu_button = 0;
			#20;
			menu_button = 1;
		end
		$stop;
	end
	
	always #5 clk <= ~clk;
endmodule
