`timescale 1ns / 1ps
`include "const_def.vh"

module mux_num2(
        //input
        input [31:0]    reg2,
        input [31:0]    ex_imm,

        //ctrl signal
        input           ctrl_num2E,

        //output
        output [31:0]   num2
    );

assign num2 = (ctrl_num2E == `MUX_NUM2_TRUE) ? reg2 : ex_imm;

endmodule