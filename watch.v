module watch(
    Clk_5sec,  
    reset,     
    seconds,
    minutes,
    hours);


    input Clk_5sec;  
    input reset;

    output reg [5:0] seconds;
    output reg [5:0] minutes;
    output reg [4:0] hours;
  
    always @(posedge(Clk_5sec) or negedge(reset))
    begin
        if(~reset) begin  
           
            seconds = 0;
            minutes = 0;
            hours = 0;  end
        else begin  
            seconds = seconds + 1; 
            if(seconds == 60) begin 
                seconds = 0;  
                minutes = minutes + 1; 
                if(minutes == 60) begin 
                    minutes = 0;  
                    hours = hours + 1;  
                   if(hours ==  24) begin  
                        hours = 0; 
                    end 
                end
            end     
        end
    end     

endmodule
