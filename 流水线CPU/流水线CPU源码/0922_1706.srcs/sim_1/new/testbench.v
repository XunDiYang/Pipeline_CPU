`timescale 1ns / 1ps


module testbench();
    reg rst;
    reg clk;
    
    top top(
        .clk(clk),
        .rst(rst)
    );
    
    initial begin
        rst =   0;
        clk =   0;
        
        #30 rst = 1;
        #500 $stop;
         
    end
    
    always
        #20 clk = ~clk;
    
endmodule
