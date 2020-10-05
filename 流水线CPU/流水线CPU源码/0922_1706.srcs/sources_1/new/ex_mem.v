`timescale 1ns / 1ps
`include "const_def.vh"


module ex_mem(
        //input
        input               clk,
        input               rst,
        input [31:0]        _ans,
        input [31:0]        _reg2,
        input [31:0]        _jal_dst,
        input [4:0]         _reg_waddr,


        //ctrl signal in
        input               ctrl_mem_wE,
        input [2:0]         ctrl_reg_wdataE,
        input               ctrl_reg_wE,
        input   [1:0]       ctrl_bhwE,

        //output
        output [31:0]       alu_ans_,
        output [31:0]       mem_addr_,
        output [31:0]       mem_wdata_,
        output [31:0]       jal_dst_,
        output [4:0]        reg_waddr_,

        //ctrl signal out
        output               ctrl_mem_wM,
        output [2:0]         ctrl_reg_wdataM,
        output               ctrl_reg_wM,
        output  [1:0]        ctrl_bhwM
    );

//本级缓冲区定义
reg[31:0]   ans;
reg[31:0]   reg2;
reg[31:0]   jal_dst;
reg[4:0]    reg_waddr;
reg         ctrl_mem_w;
reg[2:0]    ctrl_reg_wdata;  
reg         ctrl_reg_w; 
reg   [1:0]   ctrl_bhw;

always @ (posedge clk) begin
    //缓冲区复位
    if(!rst) begin
        ans             <=  `INIT_32;
        reg2            <=  `INIT_32;
        jal_dst         <=  `INIT_32;
        reg_waddr       <=  `INIT_5;
        ctrl_mem_w      <=  `INIT_1;
        ctrl_reg_wdata  <=  `INIT_3;
        ctrl_reg_w      <=  `INIT_1;
        ctrl_bhw        <=  `INIT_2;
    end

    //缓冲区暂存上一级传入的数据和控制信号，起各级隔断的作用
    else begin
        ans             <=  _ans;
        reg2            <=  _reg2;
        jal_dst         <=  _jal_dst;
        reg_waddr       <=  _reg_waddr;
        ctrl_mem_w      <=  ctrl_mem_wE;
        ctrl_reg_wdata  <=  ctrl_reg_wdataE;
        ctrl_reg_w      <=  ctrl_reg_wE;
        ctrl_bhw        <=  ctrl_bhwE;
        
    end
end

//赋值传出到下一级的信号
assign alu_ans_             =   ans;
assign  mem_addr_      =   ans;
assign mem_wdata_      =   reg2;
assign jal_dst_         =   jal_dst;
assign reg_waddr_       =   reg_waddr;
assign ctrl_mem_wM      =   ctrl_mem_w;
assign ctrl_reg_wdataM  =   ctrl_reg_wdata;
assign  ctrl_reg_wM     =   ctrl_reg_w;
assign  ctrl_bhwM        =   ctrl_bhw;

//例化??

endmodule
