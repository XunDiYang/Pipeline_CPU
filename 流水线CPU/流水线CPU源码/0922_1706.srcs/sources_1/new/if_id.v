`timescale 1ns / 1ps
`include "const_def.vh"

module if_id(
    input   clk,
    input   rst,
    input   [31:0]  _inst,

    //pause
    input  [5:0]   opcodeD,
    input  [5:0]   funcD,
    input  [15:0]  imm16D,
    input  [25:0]  imm26D,
    input  [4:0]   rsD,
    input  [4:0]   rtD,
    input  [4:0]   rdD,

    input          ctrl_pauseE,
    input          is_jump_inst,
    
    output  [5:0]   opcode_,
    output  [5:0]   func_,
    output  [15:0]  imm16_,
    output  [25:0]  imm26_,
    output  [4:0]   rs_,
    output  [4:0]   rt_,
    output  [4:0]   rd_
    );
    
    reg  [5:0]   opcode;
    reg  [5:0]   func;
    reg  [15:0]  imm16;
    reg  [25:0]  imm26;
    reg  [5:0]   rs;
    reg [5:0]   rt;
    reg  [5:0]   rd;
    
    always @(posedge clk)   begin
        if(!rst)    begin
            opcode <= `INIT_6;
            func <= `INIT_6;
            imm16 <= `INIT_16;
            imm26 <= `INIT_26;
            rs <= `INIT_6;
            rt <= `INIT_6;
            rd <= `INIT_6;
        end
        else    begin
            if(ctrl_pauseE) begin
                opcode <= opcodeD;
                func <= funcD;
                imm16 <= imm16D;
                imm26 <= imm26D;
                rs <= rsD;
                rt <= rtD;
                rd <= rdD; 
            end
            else if(is_jump_inst) begin
                //nop
                opcode <= `INIT_6;
                func <= `INIT_6;
                imm16 <= `INIT_16;
                imm26 <= `INIT_26;
                rs <= `INIT_6;
                rt <= `INIT_6;
                rd <= `INIT_6;                
            end
            else begin
                opcode <= _inst[31:26];
                func <= _inst[5:0];
                imm16 <= _inst[15:0];
                imm26 <=  _inst[25:0];
                rs <= _inst[25:21];
                rt <= _inst[20:16];
                rd <= _inst[15:11];                
            end

        end
    end
    
    assign  opcode_  =   opcode;
    assign  func_    =   func;
    assign  imm16_   =   imm16;
    assign  imm26_   =   imm26;
    assign  rs_  =   rs;
    assign  rt_  =   rt;
    assign  rd_  =   rd;
    
endmodule
