`timescale 1ns / 1ps
`include "const_def.vh"

module beq_judge(
    input   [31:0]  reg1,
    input   [31:0]  reg2,
    
    output  [3:0]   ctrl_beq_z,
    output  ctrl_beq
    );
    
    assign  ctrl_beq = (reg1 == reg2)   ?   `CTRL_BEQ_EQ : `CTRL_BEQ_NE ;
    assign  ctrl_beq_z = (reg1 > 0)  ?   `CTRL_BEQ_GTZ :
                         (reg1 < 0)  ?   `CTRL_BEQ_LTZ : 
                         (reg1 <= 0) ?   `CTRL_BEQ_LEZ :
                         (reg1 >= 0) ?   `CTRL_BEQ_GEZ : 4'b0000;
    
endmodule
