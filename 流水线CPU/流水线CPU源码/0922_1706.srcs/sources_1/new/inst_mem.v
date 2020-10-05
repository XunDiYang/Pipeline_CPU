`timescale 1ns / 1ps
`include "const_def.vh"

module inst_mem(
        //input
        input [31:0]    now_pc,
        
        //output
        output [31:0]   inst
    );

 reg [31:0]   imem[255:0];
    
    //???????¨°
    initial begin
        $display("reading instruction...");
        $readmemh("C:/Users/95135/Desktop/tests/instructions.txt",imem);
    end
    
    assign  inst = imem[now_pc[31:2]]; 

endmodule