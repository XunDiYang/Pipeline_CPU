`timescale 1ns / 1ps

module top(
    input   clk,
    input   rst,
    
    output [31:0]  to_digital
    );
    
    //pause
    wire            is_L_instD;
    wire            is_L_instE;      
    wire            ctrl_pauseE;

    wire    [5:0]   opcodeD;
    wire    [5:0]   funcD;
    wire    [4:0]   rsD;
    wire    [4:0]   rtD;
    wire    [4:0]   rdD;
    wire    [15:0]  imm16D;
    wire    [25:0]  imm26D;

    wire    [31:0]  now_pc;
    wire    [31:0]  new_pc;
    wire    [31:0]  inst;
    wire    [5:0]   opcode;
    wire    [5:0]   func;
    wire    [4:0]   rs;
    wire    [4:0]   rt;
    wire    [4:0]   rd;
    wire    [15:0]  imm16;
    wire    [25:0]  imm26;

    //is_jump_inst (add nop)
    wire    is_jump_inst;   
    
    //assign to_digital = 32'b010111; //////////////////////////////////////////////
    
    pc pc(
        .clk(clk),
        .rst(rst),
        .new_pc(new_pc),
        .ctrl_pauseE(ctrl_pauseE),
        .now_pc_(now_pc)
    );
    
    inst_mem inst_mem(
        .now_pc(now_pc),
        .inst(inst)
    );
    
    if_id if_id(
        .clk(clk),
        .rst(rst),
        ._inst(inst),
        .opcodeD(opcodeD),
        .funcD(funcD),
        .imm16D(imm16D),
        .imm26D(imm26D),
        .rsD(rsD),
        .rtD(rtD),
        .rdD(rdD),
        .ctrl_pauseE(ctrl_pauseE),
        .is_jump_inst(is_jump_inst),
        .opcode_(opcode),
        .func_(func),
        .imm16_(imm16),
        .imm26_(imm26),
        .rs_(rs),
        .rt_(rt),
        .rd_(rd)
    );
    
    wire            ctrl_beq;
    wire  [3:0]     ctrl_beq_z;
    wire            ctrl_reg_wD;
    wire  [2:0]     ctrl_reg_waddrD;
    wire  [2:0]     ctrl_reg_wdataD;
    wire            ctrl_mem_wD;
    wire  [12:0]    ctrl_alu_opD;
    wire            ctrl_num1D;
    wire            ctrl_num2D;
    wire  [3:0]     ctrl_brD;
    wire  [1:0]     ctrl_imm_signD;
    wire  [1:0]     ctrl_bhwD;
    
    wire            ctrl_reg_wE;
    wire  [2:0]     ctrl_reg_waddrE;
    wire  [2:0]     ctrl_reg_wdataE;
    wire            ctrl_mem_wE;
    wire  [12:0]    ctrl_alu_opE;
    wire            ctrl_num1E;
    wire            ctrl_num2E;
    wire  [3:0]     ctrl_brE;
    wire  [1:0]     ctrl_bhwE;
    
    wire            ctrl_reg_wM;
    wire  [2:0]     ctrl_reg_wdataM;
    wire            ctrl_mem_wM;
    wire  [3:0]     ctrl_brM;
    wire  [1:0]     ctrl_bhwM;
    
    wire            ctrl_reg_wW;
    wire  [2:0]     ctrl_reg_wdataW;
    wire  [3:0]     ctrl_brW;
    
    ctrl ctrl(
        .opcode(opcode),
        .func(func),
        .rt(rt),
        .ctrl_beq(ctrl_beq),
        .ctrl_beq_z(ctrl_beq_z),
        .ctrl_reg_w(ctrl_reg_wD),
        .ctrl_reg_waddr(ctrl_reg_waddrD),
        .ctrl_reg_wdata(ctrl_reg_wdataD),
        .ctrl_mem_w(ctrl_mem_wD),
        .ctrl_alu_op(ctrl_alu_opD),
        .ctrl_num1(ctrl_num1D),
        .ctrl_num2(ctrl_num2D),
        .ctrl_br(ctrl_brD),
        .ctrl_imm_sign(ctrl_imm_signD),
        .is_L_instD(is_L_instD),
        .ctrl_bhwD(ctrl_bhwD)
    );
    
    wire [4:0]     reg_waddrE;
    wire [4:0]     reg_waddrM;
    wire [4:0]     reg_waddrW;

    wire [31:0]    alu_ansE;         
    wire [31:0]    jal_dstE;

    wire [31:0]    alu_ansM;
    wire [31:0]    mem_rdataM;
    wire [31:0]    jal_dstM;

    wire [1:0]     is_data_hazard;
    wire [31:0]    new_reg_wdata1;  
    wire [31:0]    new_reg_wdata2;  

    
    wire    [31:0]  reg_rdata1;
    wire    [31:0]  reg_rdata2; 

////////////////////////////////////////////////////////////////
    wire    [4:0]   reg_waddr;
    wire    [31:0]  reg_wdata;
    wire    [31:0]  reg_wdataW;
    
    reg_file reg_file(
        .clk(clk),
        .reg_raddr1(rs),
        .reg_raddr2(rt),
        .reg_waddr(reg_waddrW),
        .reg_wdata(reg_wdataW),
        .is_data_hazard(is_data_hazard),
        .new_reg_wdata1(new_reg_wdata1),
        .new_reg_wdata2(new_reg_wdata2),
        .reg_rdata1(reg_rdata1),
        .reg_rdata2(reg_rdata2),
        .ctrl_reg_wW(ctrl_reg_wW),
        .final_to_digital(to_digital)
    );
    
    wire    [31:0]  reg1 = reg_rdata1;
    wire    [31:0]  reg2 = reg_rdata2;
    wire    [31:0]  jal_dstD;
    
    beq_judge beq_judge(
        .reg1(reg1),
        .reg2(reg2),
        .ctrl_beq_z(ctrl_beq_z),
        .ctrl_beq(ctrl_beq)
    );
    
    br_unit br_unit(
        .now_pc(now_pc),
        .imm16(imm16),
        .imm26(imm26),
        .reg1(reg1),
        .ctrl_br(ctrl_brD),
        .new_pc(new_pc),
        .jal_dst(jal_dstD)
    );
    
    wire    [31:0]  ex_imm;
    
    sign_extension sign_extension(
        .ctrl_imm_sign(ctrl_imm_signD),
        .imm16(imm16),
        .ex_imm(ex_imm)
    );
    
     wire   [31:0]  ex_imm_;
     wire   [4:0]   rs_;
     wire   [4:0]   rt_;
     wire   [4:0]   rd_;
     wire   [31:0]  reg1_;
     wire   [31:0]  reg2_;
    
    id_ex id_ex(
        .clk(clk),
        .rst(rst),
        ._reg1(reg1),
        ._reg2(reg2),
        ._jal_dst(jal_dstD),
        ._ex_imm(ex_imm),
        ._rs(rs),
        ._rt(rt),
        ._rd(rd),
        .ctrl_reg_wD(ctrl_reg_wD),
        .ctrl_reg_waddrD(ctrl_reg_waddrD),
        .ctrl_reg_wdataD(ctrl_reg_wdataD),
        .ctrl_mem_wD(ctrl_mem_wD),
        .ctrl_alu_opD(ctrl_alu_opD),
        .ctrl_num1D(ctrl_num1D),
        .ctrl_num2D(ctrl_num2D),
        .ctrl_brD(ctrl_brD),
        .is_L_instD(is_L_instD),
        .ctrl_bhwD(ctrl_bhwD),
        .ctrl_pauseE(ctrl_pauseE),
        .reg1_(reg1_),
        .reg2_(reg2_),
        .jal_dst_(jal_dstE),
        .ex_imm_(ex_imm_),
        .rs_(rs_),
        .rt_(rt_),
        .rd_(rd_),
        .ctrl_reg_wE(ctrl_reg_wE),
        .ctrl_reg_waddrE(ctrl_reg_waddrE),
        .ctrl_reg_wdataE(ctrl_reg_wdataE),
        .ctrl_mem_wE(ctrl_mem_wE),
        .ctrl_alu_opE(ctrl_alu_opE),
        .ctrl_num1E(ctrl_num1E),
        .ctrl_num2E(ctrl_num2E),
        .ctrl_brE(ctrl_brE),
        .is_L_instE(is_L_instE),
        .ctrl_bhwE(ctrl_bhwE)
    );
    
    wire    [31:0]  num1;
    wire    [31:0]  num2;
    
    mux_num1 mux_num1(
        .reg1(reg1_),
        .ex_imm(ex_imm_),
        .ctrl_num1E(ctrl_num1E),
        .num1(num1)
    );
    
    mux_num2 mux_num2(
        .reg2(reg2_),
        .ex_imm(ex_imm_),
        .ctrl_num2E(ctrl_num2E),
        .num2(num2)
    );
    
    alu alu(
        .num1(num1),
        .num2(num2),
        .ctrl_alu_opE(ctrl_alu_opE),
        .ans(alu_ansE)
    );
    
    mux_reg_waddr mux_reg_waddr(
        .rt(rt_),
        .rd(rd_),
        .ctrl_reg_waddrE(ctrl_reg_waddrE),
        .reg_waddrE(reg_waddrE)
    );
    
    wire    [31:0]  mem_addr;
    wire    [31:0]  mem_wdata;
    
    ex_mem ex_mem(
        .clk(clk),
        .rst(rst),
        ._ans(alu_ansE),
        ._reg2(reg2_),
        ._jal_dst(jal_dstE),
        ._reg_waddr(reg_waddrE),
        .ctrl_mem_wE(ctrl_mem_wE),
        .ctrl_reg_wdataE(ctrl_reg_wdataE),
        .ctrl_reg_wE(ctrl_reg_wE),
        .ctrl_bhwE(ctrl_bhwE),
        .alu_ans_(alu_ansM),
        .mem_addr_(mem_addr),
        .mem_wdata_(mem_wdata),
        .jal_dst_(jal_dstM),
        .reg_waddr_(reg_waddrM),
        .ctrl_mem_wM(ctrl_mem_wM),
        .ctrl_reg_wdataM(ctrl_reg_wdataM),
        .ctrl_reg_wM(ctrl_reg_wM),
        .ctrl_bhwM(ctrl_bhwM)
    );
    

    
    data_mem data_mem(
        .clk(clk),
        .mem_addr(mem_addr[11:2]),
        .mem_wdata(mem_wdata),
        .ctrl_mem_wM(ctrl_mem_wM),
        .mem_rdata(mem_rdataM),
        .ctrl_bhwM(ctrl_bhwM)
    );
    
    wire    [31:0]  mem_rdataW;
    wire    [31:0]  jal_dstW;
    wire    [31:0]  alu_ansW;
    
    mem_wb mem_wb(
        .clk(clk),
        .rst(rst),
        ._alu_ans(alu_ansM),
        ._mem_rdata(mem_rdataM),
        ._jal_dst(jal_dstM),
        ._reg_waddr(reg_waddrM),
        .ctrl_reg_wdataM(ctrl_reg_wdataM),
        .ctrl_reg_wM(ctrl_reg_wM),
        .alu_ans_(alu_ansW),
        .mem_rdata_(mem_rdataW),
        .jal_dst_(jal_dstW),
        .reg_waddr_(reg_waddrW),
        .ctrl_reg_wdataW(ctrl_reg_wdataW),
        .ctrl_reg_wW(ctrl_reg_wW)
    );
    
    mux_reg_wdata mux_reg_wdata(
        .alu_ans(alu_ansW),
        .mem_rdata(mem_rdataW),
        .jal_dst(jal_dstW),
        .ctrl_reg_wdataW(ctrl_reg_wdataW),
        .reg_wdata(reg_wdataW)
    ) ;
    
    hazards_unit hazards_unit(
        .opcode(opcode),
        .func(func),
        .imm16(imm16),
        .imm26(imm26),
        .rs(rs),
        .rt(rt),
        .rd(rd),
        .reg_waddrE(reg_waddrE),
        .reg_waddrM(reg_waddrM),
        .reg_waddrW(reg_waddrW),
        .alu_ansE(alu_ansE),
        .jal_dstE(jal_dstE),
        .alu_ansM(alu_ansM),
        .mem_rdataM(mem_rdataM),
        .jal_dstM(jal_dstM),
        .reg_wdataW(reg_wdataW),
        .ctrl_reg_wdataE(ctrl_reg_wdataE),
        .ctrl_reg_wdataM(ctrl_reg_wdataM),
        .is_L_instE(is_L_instE),
        .ctrl_brD(ctrl_brD),
        .is_data_hazard(is_data_hazard),
        .new_reg_wdata1(new_reg_wdata1),
        .new_reg_wdata2(new_reg_wdata2),
        .ctrl_pauseE(ctrl_pauseE),
        .is_jump_inst(is_jump_inst),
        .opcodeD(opcodeD),
        .funcD(funcD),
        .imm16D(imm16D),
        .imm26D(imm26D),
        .rsD(rsD),
        .rtD(rtD),
        .rdD(rdD)
    );
    
endmodule
