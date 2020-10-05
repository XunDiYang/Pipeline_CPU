`timescale 1ns / 1ps
`include "const_def.vh"


module mem_wb(
        //input
        input               clk,
        input               rst,     
        input [31:0]        _alu_ans,
        input [31:0]        _mem_rdata,
        input [31:0]        _jal_dst,
        input [4:0]         _reg_waddr,

        //ctrl signal in
        input [2:0]         ctrl_reg_wdataM,
        input               ctrl_reg_wM,

        //output
        output [31:0]        alu_ans_,
        output [31:0]        mem_rdata_,
        output [31:0]        jal_dst_,
        output [4:0]         reg_waddr_,

        //ctrl signal out
        output [2:0]         ctrl_reg_wdataW,
        output               ctrl_reg_wW

    );

//本级缓冲区定义
reg[31:0]   alu_ans;
reg[31:0]   mem_rdata;
reg[31:0]   jal_dst;
reg[4:0]    reg_waddr;
reg[2:0]    ctrl_reg_wdata; 
reg         ctrl_reg_w;  

always @ (posedge clk) begin
    //缓冲区复位
    if(!rst) begin
        alu_ans         <=  `INIT_32;
        mem_rdata        <=  `INIT_32;
        jal_dst         <=  `INIT_32;
        reg_waddr       <=  `INIT_5;
        ctrl_reg_wdata  <=  `INIT_3;
        ctrl_reg_w     <=  `INIT_1;
    end

    //缓冲区暂存上一级传入的数据和控制信号，起各级隔断的作用
    else begin
        alu_ans         <=  _alu_ans;
        mem_rdata        <=  _mem_rdata;
        jal_dst         <=  _jal_dst;
        reg_waddr       <=  _reg_waddr;
        ctrl_reg_wdata  <=  ctrl_reg_wdataM;
        ctrl_reg_w     <=  ctrl_reg_wM;
    end
end

//赋值传出到下一级的信号
assign alu_ans_         =   alu_ans;
assign mem_rdata_        =   mem_rdata;
assign jal_dst_         =   jal_dst;
assign reg_waddr_       =   reg_waddr;
assign ctrl_reg_wdataW  =   ctrl_reg_wdata;
assign  ctrl_reg_wW     =   ctrl_reg_w;

//例化??


endmodule


