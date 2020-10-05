`timescale 1ns / 1ps
`include "const_def.vh"

module reg_file(
        //input
        input           clk,
        input [4:0]     reg_raddr1,
        input [4:0]     reg_raddr2,
        input [4:0]     reg_waddr,
        input [31:0]    reg_wdata,

        //forwarding
        input [1:0]     is_data_hazard,
        input [31:0]    new_reg_wdata1,
        input [31:0]    new_reg_wdata2,

        //ctrl signal
        input           ctrl_reg_wW,

        //output
        output [31:0]        reg_rdata1,
        output [31:0]        reg_rdata2,
        
        //final_to_digital
        output [31:0]        final_to_digital

    );

//get data from register
reg[31:0]   register[31:0];
wire [31:0] ans1;
wire [31:0] ans2;

assign reg_rdata1 = (reg_raddr1 == `INIT_5) ? `INIT_32 : 
                    (is_data_hazard == 2'b11 || is_data_hazard == 2'b01 ) ? new_reg_wdata1 : register[reg_raddr1];
assign reg_rdata2 = (reg_raddr2 == `INIT_5) ? `INIT_32 : 
                    (is_data_hazard == 2'b11 || is_data_hazard == 2'b10) ? new_reg_wdata2 : register[reg_raddr2];

//最后的结果存在寄存器2和寄存器3中
assign ans1 = register[2];
assign ans2 = register[3];
assign final_to_digital = {ans1[31:16],ans2[15:0]};

//write data to register
always @ (posedge clk) begin
    if (ctrl_reg_wW) begin
        register[reg_waddr] = reg_wdata;
    end
end

endmodule
