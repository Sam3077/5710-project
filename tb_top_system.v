`timescale 10 ms/1 ms

module tb_top_system();
	reg clk, rst, menu_button, next_button, select_button, exec_status;
	wire exec, menu_open;
	wire [1:0] selected;
	wire [31:0] happiness, hunger, health, clean;
   wire [5:0] 	    seconds;
   wire [5:0] 	    minutes;
   wire [4:0] 	    hours;
   
	
	top_system uut(
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
		.clean(clean),
		.seconds(seconds),
		.minutes(minutes),
		.hours(hours)
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
		
	   #500_000;
	   
		
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
			#100;
			// assert execution is finished
			exec_status = 1;
			
			// close menu
			#20;
			menu_button = 0;
			#20;
			menu_button = 1;
		end
		
		#75000;
		
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
			#100;
			exec_status = 1;
			
			// close menu
			#20;
			menu_button = 0;
			#20;
			menu_button = 1;
		end
		
		#50000;
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
			#100;
			exec_status = 1;
			
			// close menu
			#20;
			menu_button = 0;
			#20;
			menu_button = 1;
		end // while (clean < 10)
	   #10000;
	   
		$stop;
	end
	
	always #1 clk <= ~clk;
endmodule
