`timescale 1ns/1 ps
module tb_watch;

   
    reg Clk_5sec;
    reg reset;

    wire [5:0] seconds;
    wire [5:0] minutes;
    wire [4:0] hours;

 
    watch uut (
        .Clk_5sec(Clk_5sec), 
        .reset(reset), 
        .seconds(seconds), 
        .minutes(minutes), 
        .hours(hours)
    );
    
    initial Clk_5sec = 0;
    always #10000000 Clk_5sec = ~Clk_5sec;  

    initial begin
        reset = 1;
       
        #100;
		  $display("seconds = %b | minutes = %b | hours =%b", seconds, minutes, hours);
        reset = 0;  
		  
    end
      
endmodule
