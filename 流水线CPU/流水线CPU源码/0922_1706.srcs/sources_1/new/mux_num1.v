`timescale 1ns / 1ps
`include "const_def.vh"

module mux_num1(
        //input
        input [31:0]    reg1,
        input [31:0]    ex_imm,

        //ctrl signal
        input           ctrl_num1E,

        //output
        output [31:0]   num1

    );

assign num1 = (ctrl_num1E == `MUX_NUM1_TRUE) ? reg1 : ex_imm;

endmodule

