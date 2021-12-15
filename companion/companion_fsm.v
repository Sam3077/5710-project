module companion_fsm(clk, rst, menu_button, next_button, select_button, exec_status, selected, exec, menu_open);
   input clk;
   input rst, menu_button, next_button, select_button, exec_status;
   
   /* 00 - nothing
    * 01 - Feed
    * 10 - Play
    * 11 - Clean
    */
   output reg [1:0] selected;
   output reg 	    exec, menu_open;
   
   reg [3:0] 	    NS;
   wire [3:0] 	    PS;

   localparam [3:0] Idle = 4'b0000, HoverFeed = 4'b0001, HoverPlay = 4'b0010, HoverClean = 4'b0011;
   localparam [3:0] ExecFeed = 4'b0100, ExecPlay = 4'b0101, ExecClean = 4'b0110;
   localparam [3:0] MenuOpenDown = 4'b0111, MenuCloseDown = 4'b1000, HoverFeedDown = 4'b1001, HoverPlayDown = 4'b1010;
   localparam [3:0] HoverCleanDown = 4'b1011, ExecFeedDown = 4'b1100, ExecPlayDown = 4'b1101, ExecCleanDown = 4'b1110;
   
	
   register #(.DATA_WIDTH(4), .RESET_VALUE(Idle)) state_reg(
							    .d_in(NS),
							    .d_out(PS),
							    .en(1'b1),
							    .clk(clk),
							    .rst(rst)
							    );
   
	always @(PS) begin
		case (PS)
		  Idle: begin
		     menu_open = 1'b0;
		     exec = 1'b0;
		     selected = 2'b00;
		  end
		  MenuOpenDown: begin
		     menu_open = 1'b0;
		     exec = 1'b0;
		     selected = 2'b00;
		  end
		  MenuCloseDown: begin
		     menu_open = 1'b1;
		     exec = 1'b0;
		     selected = 2'b00;
		     
		  end
		  HoverFeedDown: begin
		     menu_open = 1'b1;
		     exec = 1'b0;
		     selected = 2'b00;
		  end
		  
		  HoverFeed: begin
		     menu_open = 1'b1;
		     exec = 1'b0;
		     selected = 2'b01;
		  end
		  HoverPlayDown: begin
		     menu_open = 1'b1;
		     exec = 1'b0;
		     selected = 2'b00;
		  end
		  
		  HoverPlay: begin
		     menu_open = 1'b1;
		     exec = 1'b0;
		     selected = 2'b10;
		  end
		  HoverCleanDown: begin
		     menu_open = 1'b1;
		     exec = 1'b0;
		     selected = 2'b00;
		  end
		  
		  HoverClean: begin
		     menu_open = 1'b1;
		     exec = 1'b0;
		     selected = 2'b11;
		  end
		  ExecFeedDown: begin
		     menu_open = 1'b1;
		     exec = 1'b0;
		     selected = 2'b01;
		  end
		  
		  ExecFeed: begin
		     menu_open = 1'b0;
		     exec = 1'b1;
		     selected = 2'b01;
		  end
		  ExecPlayDown: begin
		     menu_open = 1'b1;
		     exec = 1'b0;
		     selected = 2'b10;
		  end
		  
		  ExecPlay: begin
		     menu_open = 1'b0;
		     exec = 1'b1;
		     selected = 2'b10;
		  end

		  ExecCleanDown: begin
		     menu_open = 1'b1;
		     exec = 1'b0;
		     selected = 2'b11;
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
	
	// This could include a timed reset using a clock scaler if you wanted to.
	always @(negedge clk) begin
	   case(PS)
	     Idle:
	       if (~menu_button)
		 NS <= MenuOpenDown;
	       else
		 NS <= Idle;
	     MenuOpenDown:
	       if (menu_button)
		 NS <= HoverFeed;
	       else
		 NS <= MenuOpenDown;
	     MenuCloseDown:
	       if (menu_button)
		 NS <= Idle;
	       else
		 NS <= MenuCloseDown;

	     HoverFeedDown:
	       if (next_button)
		 NS <= HoverFeed;
	       else
		 NS <= HoverFeedDown;
	     
	     
	     HoverFeed:
	       if (~menu_button)
		 NS <= MenuCloseDown;
	       else if (~next_button)
		 NS <= HoverPlayDown;
	       else if (~select_button)
		 NS <= ExecFeedDown;
	       else
		 NS <= HoverFeed;

	     HoverPlayDown:
	       if (next_button)
		 NS <= HoverPlay;
	       else
		 NS <= HoverPlayDown;
	     
	     HoverPlay:
	       if (~menu_button)
		 NS <= MenuCloseDown;
	       else if (~next_button)
		 NS <= HoverCleanDown;
	       else if (~select_button)
		 NS <= ExecPlayDown;
	       else
		 NS <= HoverPlay;

	     HoverCleanDown:
	       if (next_button)
		 NS <= HoverClean;
	       else
		 NS <= HoverCleanDown;
	     
	     HoverClean:
	       if (~menu_button)
		 NS <= MenuCloseDown;
	       else if (~next_button)
		 NS <= HoverFeedDown;
	       else if (~select_button)
		 NS <= ExecCleanDown;
	       else
		 NS <= HoverClean;

	     ExecFeedDown:
	       if (select_button)
		 NS <= ExecFeed;
	       else
		 NS <= ExecFeedDown;
	     
	     ExecFeed:
	       if (exec_status)
		 NS <= HoverFeed;
	       else
		 NS <= ExecFeed;

	     ExecPlayDown:
	       if (select_button)
		 NS <= ExecPlay;
	       else
		 NS <= ExecPlayDown;
	     
	     ExecPlay:
	       if (exec_status)
		 NS <= HoverPlay;
	       else
		 NS <= ExecPlay;
	     
	     ExecCleanDown:
	       if (select_button)
		 NS <= ExecClean;
	       else
		 NS <= ExecCleanDown;
	     
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
