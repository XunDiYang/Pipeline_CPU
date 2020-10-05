`timescale 1ns / 1ps
`include "const_def.vh"

module br_unit(
    input   [31:0]  now_pc,
    input   [15:0]  imm16,
    input   [25:0]  imm26,
    input   [31:0]  reg1,
    input   [3:0]   ctrl_br,
    
    output  [31:0]  new_pc,
    output  [31:0]  jal_dst  
    );
    
    wire    [31:0]  pc_add_4 = now_pc + 32'b100;
    wire    [31:0]  pc_add_8 = pc_add_4 + 32'b100;
    wire    [15:0]  imm16_sll2 = {imm16[13:0],2'b00};
    wire    [31:0]  ex_imm16;
    
    sign_extension sign_extension_imm16(
        .ctrl_imm_sign(`SIGNED),
        .imm16(imm16_sll2),
        .ex_imm(ex_imm16)
    );
    
    wire    [31:0]  pc_beq = now_pc + ex_imm16;
    wire    [31:0]  pc_j_ = {pc_add_4[31:28], imm26,2'b00};
    wire    [31:0]  pc_j = pc_j_ - `PC_BASE;
    wire    [31:0]  pc_jal = pc_j;
    wire    [31:0]  pc_jr = reg1 ;
    wire    [31:0]  pc_jalr = reg1;
    
    assign  new_pc = (ctrl_br == 4'b0001) ? pc_beq :
                        (ctrl_br == 4'b0010) ? pc_j :
                        (ctrl_br == 4'b0100) ? pc_jal :
                        (ctrl_br == 4'b1000) ? pc_jr : pc_add_4;
    
    //不太确定是pc_add_8还是pc_add_4
    assign jal_dst = (ctrl_br == 4'b0100 ) ?  pc_add_8 : 32'b0;
    
endmodule
