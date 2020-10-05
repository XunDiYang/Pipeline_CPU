`timescale 1ns / 1ps
`include "const_def.vh"

module mux_reg_wdata(
        //input
        input [31:0]        alu_ans,
        input [31:0]        mem_rdata,
        input [31:0]        jal_dst,

        //ctrl signal
        input [2:0]         ctrl_reg_wdataW,

        //output
        output [31:0]       reg_wdata

    );

assign reg_wdata =  (ctrl_reg_wdataW == `MUX_REG_WDATA_ALU)  ?    alu_ans    :
                    (ctrl_reg_wdataW == `MUX_REG_WDATA_MEM)  ?    mem_rdata  :
                    (ctrl_reg_wdataW == `MUX_REG_WDATA_JAL)  ?    jal_dst    :   alu_ans;

endmodule
