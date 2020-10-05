`timescale 1ns / 1ps
`include "const_def.vh"

module data_mem(
        //input
        input           clk,
        input [11:2]    mem_addr,
        input [31:0]    mem_wdata,

        //ctrl signal
        input           ctrl_mem_wM,
        input   [1:0]   ctrl_bhwM,
        
        //output
        output [31:0]   mem_rdata

    );

    reg [7:0]   data_memory[31:0];
    
    initial begin
        $readmemh("C:/Users/95135/Desktop/tests/data_memory.txt",data_memory);
    end
    
    //Ð´²Ù×÷
    always @(posedge clk) begin
        if (ctrl_mem_wM) begin
            if(ctrl_bhwM == 2'b00) begin
                data_memory[mem_addr+3] <= mem_wdata[31:24];
                data_memory[mem_addr+2] <= mem_wdata[23:16];
                data_memory[mem_addr+1] <= mem_wdata[15:8];
                data_memory[mem_addr] <= mem_wdata[7:0];
            end
            else if(ctrl_bhwM == 2'b01) begin
                data_memory[mem_addr+1] <= mem_wdata[15:8];
                data_memory[mem_addr] <= mem_wdata[7:0];
            end
            else if(ctrl_bhwM == 2'b10) begin
                data_memory[mem_addr] <= mem_wdata[7:0];
            end
        end
    end

    //¶Á²Ù×÷
    wire    [31:0]  mem_rdata32 ;
    wire    [31:0]  mem_rdata16 ;
    wire    [31:0]  mem_rdata8;
    
    wire    [7:0]   mem_rdata16_sign = data_memory[mem_addr+1];
    wire    [7:0]   mem_rdata8_sign = data_memory[mem_addr];
    
    assign  mem_rdata32 = {data_memory[mem_addr+3],data_memory[mem_addr+2],data_memory[mem_addr+1],data_memory[mem_addr]};
    assign  mem_rdata16 = {{16{mem_rdata16_sign[7]}},data_memory[mem_addr+1],data_memory[mem_addr]};
    assign  mem_rdata8 = {{24{mem_rdata8_sign[7]}},data_memory[mem_addr]}; 
    
    assign  mem_rdata = (ctrl_bhwM == 2'b00) ? mem_rdata32 :
                                (ctrl_bhwM == 2'b01) ? mem_rdata16 :
                                (ctrl_bhwM == 2'b10) ? mem_rdata8 : 32'b0;

  
   
//read from data_memory
//reg     [31:0]   data_memory[31:0];
//wire    [31:0]  mem_rdata32 = data_memory[mem_addr];
//wire    [31:0]  mem_rdata16 = {{16{mem_rdata[15]}},mem_rdata32[15:0]};
//wire    [31:0]  mem_rdata8  = {{24{mem_rdata[7]}},mem_rdata32[7:0]};

//assign  mem_rdata = (ctrl_bhwM == 2'b00) ? mem_rdata32 :
//                            (ctrl_bhwM == 2'b01) ? mem_rdata16 :
//                            (ctrl_bhwM == 2'b10) ? mem_rdata8 : 32'b0;

//always @ (posedge clk) begin
//    if (ctrl_mem_wM) begin
////        data_memory[mem_addr] <= mem_wdata_;
//        if(ctrl_bhwM == 2'b00) begin
//            data_memory[mem_addr] <= mem_wdata;
//        end
//        else if(ctrl_bhwM == 2'b01) begin
//            data_memory[mem_addr][15:0] <= mem_wdata[15:0];
//        end
//        else if(ctrl_bhwM == 2'b10) begin
//            data_memory[mem_addr][7:0] <= mem_wdata[7:0];
//        end
//    end
//end

endmodule

