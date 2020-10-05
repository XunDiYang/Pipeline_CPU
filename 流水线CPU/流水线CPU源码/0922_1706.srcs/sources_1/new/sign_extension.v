`timescale 1ns / 1ps
`include "const_def.vh"

module sign_extension(
    input   [1:0] ctrl_imm_sign,
    input   [15:0]  imm16,
    
    output  [31:0] ex_imm
    );
    
    assign ex_imm = (ctrl_imm_sign == `SIGNED) ? {{16{imm16[15]}},imm16[15:0]} :
                        (ctrl_imm_sign == `UNSIGNED) ? {16'b0,imm16[15:0]} :
                        (ctrl_imm_sign == `SHAMIT) ? {27'b0,imm16[10:6]} : 16'b0; 
    
endmodule
