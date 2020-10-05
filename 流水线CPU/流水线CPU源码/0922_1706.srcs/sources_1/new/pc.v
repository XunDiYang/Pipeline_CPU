`timescale 1ns / 1ps
`include "const_def.vh"

module pc(
    input   clk,
    input   rst,
    input   [31:0]  new_pc,
    input   ctrl_pauseE,
    
    output  [31:0]  now_pc_
    );
    
    reg [31:0] now_pc;
    wire [31:0]  pc_sub_4 = new_pc - 32'b100;
    
    always @(posedge clk)   begin
        if(!rst)    begin
            now_pc <= `INIT_32;
        end
       else    begin
            if(ctrl_pauseE) begin
                now_pc <= pc_sub_4;
            end
            else begin
                now_pc <= new_pc;
            end
           
        end
    end
    
    assign now_pc_ = now_pc;
    
endmodule
