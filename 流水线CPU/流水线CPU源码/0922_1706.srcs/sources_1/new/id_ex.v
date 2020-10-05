`timescale 1ns / 1ps
`include "const_def.vh"

module id_ex(
    input   clk,
    input   rst,
    input   [31:0]  _reg1,
    input   [31:0]  _reg2,
    input   [31:0]  _jal_dst,
    input   [31:0]  _ex_imm,
    input   [4:0]   _rs,
    input   [4:0]   _rt,
    input   [4:0]   _rd,
  
    input  ctrl_reg_wD,
    input  [2:0]   ctrl_reg_waddrD,
    input  [2:0]   ctrl_reg_wdataD,
    input  ctrl_mem_wD,
    input  [12:0]  ctrl_alu_opD,
    input  ctrl_num1D,
    input  ctrl_num2D,
    input  [3:0]   ctrl_brD,
    input  is_L_instD,
    input  ctrl_pauseE,
    input   [1:0]   ctrl_bhwD,
    
    output  [31:0]  reg1_,
    output  [31:0]  reg2_,
    output  [31:0]  jal_dst_,
    output  [31:0]  ex_imm_,
    output  [4:0]   rs_,
    output  [4:0]   rt_,
    output  [4:0]   rd_ ,
    
    output  ctrl_reg_wE,
    output  [2:0]   ctrl_reg_waddrE,
    output  [2:0]   ctrl_reg_wdataE,
    output  ctrl_mem_wE,
    output  [12:0]  ctrl_alu_opE,
    output  ctrl_num1E,
    output  ctrl_num2E,
    output  [3:0]   ctrl_brE,
    output  is_L_instE,
    output  [1:0]   ctrl_bhwE
    );
    
    reg   [31:0]  reg1;
    reg   [31:0]  reg2;
    reg   [31:0]  jal_dst;
    reg   [31:0]  ex_imm;
    reg   [4:0]   rs;
    reg   [4:0]   rt;
    reg   [4:0]   rd;
    
    reg  ctrl_reg_w;
    reg  [2:0]   ctrl_reg_waddr;
    reg  [2:0]   ctrl_reg_wdata;
    reg  ctrl_mem_w;
    reg  [12:0]  ctrl_alu_op;
    reg  ctrl_num1;
    reg  ctrl_num2;
    reg  [3:0]   ctrl_br;
    reg  is_L_inst;
    reg  [1:0]  ctrl_bhw;
    
    always @(posedge clk)   begin
        if(!rst)    begin
            reg1 <= `INIT_32;
            reg2 <= `INIT_32;
            jal_dst <= `INIT_32;
            ex_imm <= `INIT_32;
            rs <= `INIT_5;
            rt <= `INIT_5;
            rd <= `INIT_5;
            
            ctrl_reg_w <= `INIT_1;
            ctrl_reg_waddr <= `INIT_3;
            ctrl_reg_wdata <= `INIT_3;
            ctrl_mem_w <= `INIT_1;
            ctrl_alu_op <= `INIT_11; 
            ctrl_num1 <= `INIT_1;
            ctrl_num2 <= `INIT_1;
            ctrl_br <= `INIT_4;
            is_L_inst <= `INIT_1;
            ctrl_bhw <= `INIT_2;
        end
        else    begin
            if(ctrl_pauseE) begin
                //nop
                reg1 <= `INIT_32;
                reg2 <= `INIT_32;
                jal_dst <= `INIT_32;
                ex_imm <= `INIT_32;
                rs <= `INIT_5;
                rt <= `INIT_5;
                rd <= `INIT_5;
                
                ctrl_reg_w <= `INIT_1;
                ctrl_reg_waddr <= `INIT_3;
                ctrl_reg_wdata <= `INIT_3;
                ctrl_mem_w <= `INIT_1;
                ctrl_alu_op <= `INIT_11; 
                ctrl_num1 <= `INIT_1;
                ctrl_num2 <= `INIT_1;
                ctrl_br <= `INIT_4;
                is_L_inst <= `INIT_1;
                ctrl_bhw <= `INIT_2;       
            end
            else begin
                reg1 <= _reg1;
                reg2 <= _reg2;
                jal_dst <= _jal_dst;
                ex_imm <= _ex_imm;
                rs <= _rs;
                rt <= _rt;
                rd <= _rd;
                
                ctrl_reg_w <= ctrl_reg_wD;
                ctrl_reg_waddr <= ctrl_reg_waddrD;
                ctrl_reg_wdata <= ctrl_reg_wdataD;
                ctrl_mem_w <= ctrl_mem_wD;
                ctrl_alu_op <= ctrl_alu_opD; 
                ctrl_num1 <= ctrl_num1D;
                ctrl_num2 <= ctrl_num2D;
                ctrl_br <= ctrl_brD;   
                is_L_inst <= is_L_instD;   
                ctrl_bhw <= ctrl_bhwD;          
            end
        end
    end
    
    assign  reg1_   =   reg1;
    assign  reg2_   =   reg2;
    assign  jal_dst_    =   jal_dst;
    assign  ex_imm_     =   ex_imm;
    assign  rs_     =   rs;
    assign  rt_     =   rt;
    assign  rd_     =   rd;
    
    assign  ctrl_reg_wE = ctrl_reg_w;
    assign  ctrl_reg_waddrE =  ctrl_reg_waddr;
    assign  ctrl_reg_wdataE = ctrl_reg_wdata;
    assign  ctrl_mem_wE = ctrl_mem_w;
    assign  ctrl_alu_opE = ctrl_alu_op;
    assign  ctrl_num1E = ctrl_num1;
    assign  ctrl_num2E = ctrl_num2;
    assign  ctrl_brE = ctrl_br;
    assign  is_L_instE      = is_L_inst;
    assign  ctrl_bhwE = ctrl_bhw;          
        
endmodule
