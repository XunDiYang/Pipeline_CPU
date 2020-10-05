`timescale 1ns / 1ps
`include "const_def.vh"

module mux_reg_waddr(
    input   [4:0]   rt,
    input   [4:0]   rd,
    input   [2:0]   ctrl_reg_waddrE,
    
    output  [4:0]   reg_waddrE
    );
    
    assign reg_waddrE = (ctrl_reg_waddrE == 3'b001) ? rt :
                            (ctrl_reg_waddrE == 3'b010) ? rd :
                            (ctrl_reg_waddrE == 3'b100) ? `REG_31 : 5'b00000; 
    
endmodule
