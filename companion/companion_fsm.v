module companion_fsm(clk, rst, menu_button, next_button, select_button, exec_status, selected, exec, menu_open);
	input clk, rst, menu_button, next_button, select_button, exec_status;
	
	/* 00 - nothing
	 * 01 - Feed
	 * 10 - Play
	 * 11 - Clean
	 */
	output reg [1:0] selected;
	output reg exec, menu_open;
	
	reg [2:0] PS, NS;
	parameter [2:0] Idle = 3'b00, HoverFeed = 3'b001, HoverPlay = 3'b010, HoverClean = 3'b011;
	parameter [2:0] ExecFeed = 3'b100, ExecPlay = 3'b101, ExecClean = 3'b110;
	
	
	always @(PS) begin
		case (PS)
			Idle: begin
				menu_open = 1'b0;
				exec = 1'b0;
				selected = 2'b00;
			end
			HoverFeed: begin
				menu_open = 1'b1;
				exec = 1'b0;
				selected = 2'b01;
			end
			HoverPlay: begin
				menu_open = 1'b1;
				exec = 1'b0;
				selected = 2'b10;
			end
			HoverClean: begin
				menu_open = 1'b1;
				exec = 1'b0;
				selected = 2'b11;
			end
			ExecFeed: begin
				menu_open = 1'b0;
				exec = 1'b1;
				selected = 2'b01;
			end
			ExecPlay: begin
				menu_open = 1'b0;
				exec = 1'b1;
				selected = 2'b10;
			end
			ExecClean: begin
				menu_open = 1'b0;
				exec = 1'b1;
				selected = 2'b11;
			end
			default: begin
				menu_open = 1'b0;
				exec = 1'b0;
				selected = 2'b00;
			end
		endcase
	end
	
	always @(posedge clk)
		PS <= NS;
	
	// This could include a timed reset using a clock scaler if you wanted to.
	always @(negedge rst, negedge menu_button, negedge next_button, negedge select_button, posedge exec_status) begin
		if (~rst)
			NS <= Idle;
		else
			case(PS)
				Idle:
					if (~menu_button)
						NS <= HoverFeed;
					else
						NS <= PS;
				HoverFeed:
					if (~menu_button)
						NS <= Idle;
					else if (~next_button)
						NS <= HoverPlay;
					else if (~select_button)
						NS <= ExecFeed;
					else
						NS <= HoverFeed;
				HoverPlay:
					if (~menu_button)
						NS <= Idle;
					else if (~next_button)
						NS <= HoverClean;
					else if (~select_button)
						NS <= ExecPlay;
					else
						NS <= HoverPlay;
				HoverClean:
					if (~menu_button)
						NS <= Idle;
					else if (~next_button)
						NS <= HoverFeed;
					else if (~select_button)
						NS <= ExecClean;
					else
						NS <= HoverClean;
				ExecFeed:
					if (exec_status)
						NS <= HoverFeed;
					else
						NS <= ExecFeed;
				ExecPlay:
					if (exec_status)
						NS <= HoverPlay;
					else
						NS <= ExecPlay;
				ExecClean:
					if (exec_status)
						NS <= HoverClean;
					else
						NS <= ExecClean;
				default:
					NS <= Idle;
			endcase
	end
	
endmodule
