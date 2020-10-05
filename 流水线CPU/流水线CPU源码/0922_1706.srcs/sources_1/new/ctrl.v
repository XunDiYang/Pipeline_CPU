`timescale 1ns / 1ps
`include "const_def.vh"

module ctrl(
    input   [5:0]   opcode,
    input   [5:0]   func,
    input   [4:0]   rt,
    input   ctrl_beq,
    input   [3:0]   ctrl_beq_z,
    
    output  ctrl_reg_w,
    output  [2:0]   ctrl_reg_waddr,
    output  [2:0]   ctrl_reg_wdata,
    output  ctrl_mem_w,
    output  [12:0]  ctrl_alu_op,
    output  ctrl_num1,
    output  ctrl_num2,
    output  [3:0]   ctrl_br,
    output  [1:0]   ctrl_imm_sign,
    output  is_L_instD,
    output  [1:0]   ctrl_bhwD    
    );
    
    assign is_L_instD = ((opcode == `OP_LH) ||(opcode == `OP_LW) || (opcode == `OP_LB)) ? 1'b1 : 1'b0;    

    assign  ctrl_br = ((opcode == `OP_BEQ && ctrl_beq == `CTRL_BEQ_EQ) || (opcode == `OP_BNE && ctrl_beq ==`CTRL_BEQ_NE) 
                                || (opcode == `OP_BGTZ && ctrl_beq_z == `CTRL_BEQ_GTZ) || (opcode == `OP_BLEZ && (ctrl_beq_z ==`CTRL_BEQ_LEZ || ctrl_beq_z == `CTRL_BEQ_LTZ))
                                || (opcode == `OP_BGEZ && rt == 5'b00001 && (ctrl_beq_z == `CTRL_BEQ_GEZ || ctrl_beq_z == `CTRL_BEQ_GTZ)) 
                                || (opcode == `OP_BLTZ && rt == 5'b00000 && ctrl_beq_z == `CTRL_BEQ_LTZ)) ? 4'b0001 :
                        (opcode == `OP_J)   ?   4'b0010 :
                        (opcode == `OP_JAL) ?   4'b0100 :
                        (opcode == `OP_JR && func == `FUNC_JR)  ?   4'b1000 : 4'b0000;
     
    assign ctrl_reg_w = (opcode == `OP_BEQ || opcode == `OP_BNE || opcode == `OP_BGTZ || opcode == `OP_BLEZ || (opcode == `OP_BGEZ && rt == 5'b00001) || 
                            (opcode == `OP_BLTZ && rt == 5'b00000) || opcode == `OP_J || opcode == `OP_JAL || (opcode == `OP_JR && func == `FUNC_JR) || 
                                        opcode == `OP_SH || opcode == `OP_SW || opcode == `OP_SB) ? 0 : 1;
    
    assign ctrl_reg_waddr = ((opcode == `OP_LUI) || (opcode == `OP_LH) || (opcode == `OP_LW) || (opcode == `OP_LB) 
                                        ||  (opcode == `OP_ADDI) || (opcode == `OP_ADDIU) || (opcode == `OP_SLTI) 
                                        ||  (opcode == `OP_ANDI) ||  (opcode == `OP_ORI) || (opcode == `OP_XORI)) ? 3'b001 : 
                                ((opcode == `OP_JAL)) ? 3'b100 :
                                ((opcode == `OP_BEQ) || (opcode == `OP_BNE) || (opcode == `OP_BGTZ) || (opcode == `OP_BLEZ) 
                                        || (opcode == `OP_BGEZ && rt == 5'b00001) || (opcode == `OP_BLTZ && rt == 5'b00000) 
                                        || (opcode == `OP_J) || (opcode == `OP_SH) ||(opcode == `OP_SW) || (opcode == `OP_SB)) ? 3'b000 : 3'b010;
    
    assign ctrl_reg_wdata = ((opcode == `OP_JAL)) ? 3'b100 : 
                             ((opcode == `OP_LH) || (opcode == `OP_LW) || (opcode == `OP_LB)) ? 3'b010 :
                             ((opcode == `OP_BEQ) || (opcode == `OP_BNE) || (opcode == `OP_BGTZ) || (opcode == `OP_BLEZ) || 
                                        (opcode == `OP_BGEZ && rt == 5'b00001) || (opcode == `OP_BLTZ && rt == 5'b00000) || 
                                        (opcode == `OP_J) || (opcode == `OP_JR && func == `FUNC_JR) || (opcode == `OP_SH) || 
                                        (opcode == `OP_SW) || (opcode == `OP_SB)) ? 3'b000 : 3'b001; 

    assign ctrl_mem_w = ((opcode == `OP_SH) || (opcode == `OP_SW) || (opcode == `OP_SB)) ? 1'b1 : 1'b0;
    
    assign ctrl_alu_op = ((opcode == `OP_ADD && func == `FUNC_ADD) || (opcode == `OP_ADDU && func == `FUNC_ADDU) || 
                                    (opcode == `OP_ADDI) || (opcode == `OP_ADDIU) || (opcode == `OP_LH) || (opcode == `OP_LW) || ((opcode == `OP_LB))
                                    || (opcode == `OP_SH) || (opcode == `OP_SW) || ((opcode == `OP_SB))) ? `ALU_OP_ADD : 
                          ((opcode == `OP_SUB && func == `FUNC_SUB) || (opcode == `OP_SUBU && func == `FUNC_SUBU)) ? `ALU_OP_SUB :
                          ((opcode == `OP_SLT && func == `FUNC_SLT) || (opcode == `OP_SLTI) || (opcode == `OP_SLTU && func == `FUNC_SLTU)
                                    || opcode == `OP_SLTIU) ? `ALU_OP_SLT : 
                          ((opcode == `OP_AND && func == `FUNC_AND) || (opcode == `OP_ANDI)) ? `ALU_OP_AND : 
                          ((opcode == `OP_NOR) && func == `FUNC_NOR) ? `ALU_OP_NOR :
                          ((opcode == `OP_OR && func == `FUNC_OR) || (opcode == `OP_ORI)) ? `ALU_OP_OR :
                          ((opcode == `OP_XOR && func == `FUNC_XOR) || (opcode == `OP_XORI)) ? `ALU_OP_XOR :
                          ((opcode == `OP_SLL && func == `FUNC_SLL) || (opcode == `OP_SLLV && func == `FUNC_SLLV)) ? `ALU_OP_SLL :
                          ((opcode == `OP_SRL && func == `FUNC_SRL) || (opcode == `OP_SRLV && func == `FUNC_SRLV)) ? `ALU_OP_SRL :
                          ((opcode == `OP_SRA && func == `FUNC_SRA) || (opcode == `OP_SRAV && func == `FUNC_SRAV)) ? `ALU_OP_SRA :
                          ((opcode == `OP_LUI)) ? `ALU_OP_LUI : 
                          ((opcode == `OP_CLZ && func == `FUNC_CLZ)) ? `ALU_OP_CLZ :
                          ((opcode == `OP_CLO) && func == `FUNC_CLO) ? `ALU_OP_CLO : `ALU_OP_DEFAULT;
                          
    assign ctrl_num1 = ((opcode == `OP_SLL && func == `FUNC_SLL) || (opcode == `OP_SRL && func == `FUNC_SRL) || (opcode == `OP_SRA && func == `FUNC_SRA)
                                    || (opcode == `OP_LUI) || (opcode == `OP_BEQ) || (opcode == `OP_BNE) || (opcode == `OP_BGTZ) || (opcode == `OP_BLEZ) 
                                    || (opcode == `OP_BGEZ && rt == 5'b00001) || (opcode == `OP_BLTZ && rt == 5'b00000) || (opcode == `OP_J) 
                                    || (opcode == `OP_JAL) || (opcode == `OP_JR && func == `FUNC_JR)) ? 1'b0 : 1'b1; 

    assign  ctrl_num2 = ((opcode == `OP_ADDI) || (opcode == `OP_ADDIU) || (opcode == `OP_SLTI) || (opcode == `OP_SLTIU) || (opcode == `OP_ANDI) || (opcode == `OP_ORI)
                                    || (opcode == `OP_XORI) || (opcode == `OP_LUI) || (opcode == `OP_BEQ) || (opcode == `OP_BNE) || (opcode == `OP_BGTZ) || (opcode == `OP_BLEZ) 
                                    || (opcode == `OP_BGEZ && rt == 5'b00001) || (opcode == `OP_BLTZ && rt == 5'b00000) || (opcode == `OP_J) || (opcode == `OP_JAL) || (opcode == `OP_JR && func == `FUNC_JR)
                                    || (opcode == `OP_LH) || (opcode == `OP_LW) || (opcode == `OP_LB) || (opcode == `OP_SH) || (opcode == `OP_SW || (opcode == `OP_SB))) ? 1'b0 : 1'b1;

    assign ctrl_imm_sign = ((opcode == `OP_ADDIU) || (opcode == `OP_SLTIU)) ? 2'b01 :
                        ((opcode == `OP_SLL && func == `FUNC_SLL) ||  (opcode == `OP_SRL && func == `FUNC_SRL)|| (opcode == `OP_SRA && func == `FUNC_SRA)) ? 2'b10 : 2'b00;

    assign  ctrl_bhwD = ((opcode == `OP_LB) || (opcode == `OP_SB)) ? 2'b10 :
                                ((opcode == `OP_LH) || (opcode == `OP_SH)) ? 2'b01  : 2'b00;
                                
    
endmodule
