module watch(
    Clk_5sec,  
    reset,     
    seconds,
    minutes,
    hours);


    input Clk_5sec;  
    input reset;

    output [5:0] seconds;
    output [5:0] minutes;
    output [4:0] hours;

     reg [5:0] seconds;
     reg [5:0] minutes;
     reg [4:0] hours; 

  
    always @(posedge(Clk_5sec) or posedge(reset))
    begin
        if(reset == 1'b1) begin  
           
            seconds = 0;
            minutes = 0;
            hours = 0;  end
        else if(Clk_5sec == 1'b1) begin  
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
