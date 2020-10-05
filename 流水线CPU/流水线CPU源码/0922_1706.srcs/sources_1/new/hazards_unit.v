`timescale 1ns / 1ps
`include "const_def.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/20 16:18:24
// Design Name: 
// Module Name: hazards_unit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module hazards_unit(
        //input
        input  [5:0]   opcode,
        input  [5:0]   func,
        input  [15:0]  imm16,
        input  [25:0]  imm26,
        input  [4:0]   rs,
        input  [4:0]   rt,
        input  [4:0]   rd,
    
        input [4:0]     reg_waddrE,
        input [4:0]     reg_waddrM,
        input [4:0]     reg_waddrW,
   
        input [31:0]    alu_ansE,
        input [31:0]    jal_dstE,

        input [31:0]    alu_ansM,
        input [31:0]    mem_rdataM,
        input [31:0]    jal_dstM,

        input [31:0]    reg_wdataW,

        input [2:0]     ctrl_reg_wdataE,
        input [2:0]     ctrl_reg_wdataM,

        input           is_L_instE,         
        input [3:0]     ctrl_brD,

        //output
        output [1:0]    is_data_hazard,
        output [31:0]   new_reg_wdata1,
        output [31:0]   new_reg_wdata2,

        output          ctrl_pauseE,         
        output          is_jump_inst,

        output  [5:0]   opcodeD,
        output  [5:0]   funcD,
        output  [15:0]  imm16D,
        output  [25:0]  imm26D,
        output  [4:0]   rsD,
        output  [4:0]   rtD,
        output  [4:0]   rdD  

    );

assign opcodeD = opcode;
assign funcD = func;
assign imm16D = imm16;
assign imm26D = imm26;
assign rsD = rs;
assign rtD = rt;
assign rdD = rd;

//判断是否为跳转类型指令处于EX阶段
assign is_jump_inst = ( (ctrl_brD == 4'b0001) || (ctrl_brD == 4'b0010) || (ctrl_brD == 4'b0100) || (ctrl_brD == 4'b1000) ) ? 1'b1 : 1'b0;   

//用于判断是否在EX阶段发生数据相关
wire is_data_hazardE;
assign is_data_hazardE = ( ((rs != 5'b00000) && ( rs == reg_waddrE)) || ((rt != 5'b00000) && ( rt == reg_waddrE)) ) ? 1'b1 : 1'b0;

//若在EX阶段发生数据相关且为LW/LH指令
assign ctrl_pauseE  = ( (is_L_instE == 1'b1) && (is_data_hazardE == 1'b1) ) ? 1'b1 : 1'b0;

//非阻塞暂停的情况
assign is_data_hazard = ( (ctrl_pauseE != 1'b1 ) && (rs != 5'b00000) && ( rs == reg_waddrE || rs == reg_waddrM || rs == reg_waddrW ) && (rt != 5'b00000) && ( rt == reg_waddrE || rt == reg_waddrM || rt == reg_waddrW )) ? 2'b11 :
                        ( (ctrl_pauseE != 1'b1 ) && (rs != 5'b00000) && ( rs == reg_waddrE || rs == reg_waddrM || rs == reg_waddrW )) ? 2'b01 :
                        ( (ctrl_pauseE != 1'b1 ) && (rt != 5'b00000) && ( rt == reg_waddrE || rt == reg_waddrM || rt == reg_waddrW )) ? 2'b10 : 2'b00;

assign new_reg_wdata1 = ( (ctrl_pauseE != 1'b1 ) && (rs == reg_waddrE) && ctrl_reg_wdataE == `MUX_REG_WDATA_ALU) ? alu_ansE :
                        ( (ctrl_pauseE != 1'b1 ) && (rs == reg_waddrE) && ctrl_reg_wdataE == `MUX_REG_WDATA_JAL) ? jal_dstE :

                        ( (ctrl_pauseE != 1'b1 ) && (rs == reg_waddrM) && ctrl_reg_wdataM == `MUX_REG_WDATA_ALU) ? alu_ansM :
                        ( (ctrl_pauseE != 1'b1 ) && (rs == reg_waddrM) && ctrl_reg_wdataM == `MUX_REG_WDATA_MEM) ? mem_rdataM :
                        ( (ctrl_pauseE != 1'b1 ) && (rs == reg_waddrM) && ctrl_reg_wdataM == `MUX_REG_WDATA_JAL) ? jal_dstM :

                        (  (ctrl_pauseE != 1'b1 ) && (rs == reg_waddrW)) ? reg_wdataW : `INIT_32;

assign new_reg_wdata2 = ( (ctrl_pauseE != 1'b1 ) && (rt == reg_waddrE) && ctrl_reg_wdataE == `MUX_REG_WDATA_ALU) ? alu_ansE :
                        ( (ctrl_pauseE != 1'b1 ) && (rt == reg_waddrE) && ctrl_reg_wdataE == `MUX_REG_WDATA_JAL) ? jal_dstE :

                        ( (ctrl_pauseE != 1'b1 ) && (rt == reg_waddrM) && ctrl_reg_wdataM == `MUX_REG_WDATA_ALU) ? alu_ansM :
                        ( (ctrl_pauseE != 1'b1 ) && (rt == reg_waddrM) && ctrl_reg_wdataM == `MUX_REG_WDATA_MEM) ? mem_rdataM :
                        ( (ctrl_pauseE != 1'b1 ) && (rt == reg_waddrM) && ctrl_reg_wdataM == `MUX_REG_WDATA_JAL) ? jal_dstM :

                        ( (ctrl_pauseE != 1'b1 ) && (rt == reg_waddrW)) ? reg_wdataW : `INIT_32;
                        
endmodule
