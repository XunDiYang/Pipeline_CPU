`timescale 1ns / 1ps
`include "const_def.vh"

module alu(
        //input
        input [31:0]        num1,
        input [31:0]        num2,

        //ctrl signal
        input [12:0]        ctrl_alu_opE,

        //output
        output [31:0]       ans

    );

//temp_ans
reg[32:0]   temp_ans;
assign ans = temp_ans[31:0];

//compare num1, num2
wire[31:0] cmp_ans;
assign cmp_ans = ((num1<num2 && num1[31] == 0 && num2[31] == 0) || (num1>num2 && num1[31] == 1 && num2[31] == 1)
                        || (num1[31] == 1 && num2[31] == 0)) ? 32'b00000001 : 32'b00000000;

//wire [31:0]  sa;
//assign  sa = {27'b0,num1[4:0]};
always @ (*) begin
    case(ctrl_alu_opE)

        `ALU_OP_ADD:
            temp_ans <= {num1[31], num1} + {num2[31], num2};

        `ALU_OP_SUB:
            temp_ans <= {num1[31], num1} - {num2[31], num2};

        `ALU_OP_SLT:
            temp_ans <= cmp_ans;

        `ALU_OP_AND:
            temp_ans <= {num1[31], num1} & {num2[31], num2};

        `ALU_OP_NOR:
//            temp_ans <= (( {num1[31], num1}  & ~{num2[31], num2}) |
//                         (~{num1[31], num1}  &  {num2[31], num2}));    
            temp_ans <= ~({num1[31], num1} | {num2[31], num2});

        `ALU_OP_OR:
            temp_ans <= {num1[31], num1} | {num2[31], num2};

        `ALU_OP_XOR:
            temp_ans <= {num1[31], num1} ^ {num2[31], num2};

        `ALU_OP_SLL:
            temp_ans <= {num2[31], num2} << num1;  

        `ALU_OP_SRL:
            temp_ans <= {num2[31], num2} >> num1;

        `ALU_OP_SRA:
            temp_ans <= ({{31{num2[31]}}, 1'b0} << (~num1[4:0])) | (num2 >> num1[4:0]);

        `ALU_OP_LUI:
            temp_ans <= {num2[15:0], 16'h0000};
         
         `ALU_OP_CLZ:
            temp_ans <= num1[31] ? 0 : num1[30] ? 1 : num1[29] ? 2 : num1[28] ? 3 : num1[27] ? 4 :
                        num1[26] ? 5 : num1[25] ? 6 : num1[24] ? 7 : num1[23] ? 8 : num1[22] ? 9 :
                        num1[21] ? 10 : num1[20] ? 11 : num1[19] ? 12 : num1[18] ? 13 : num1[17] ? 14 :
                        num1[16] ? 15 : num1[15] ? 16 : num1[14] ? 17 : num1[13] ? 18 : num1[12] ? 19 :
                        num1[11] ? 20 : num1[10] ? 21 : num1[9] ? 22 : num1[8] ? 23 : num1[7] ? 24 :
                        num1[6] ? 25 : num1[5] ? 26 : num1[4] ? 27 : num1[3] ? 28 : num1[2] ? 29 :
                        num1[1] ? 30 : num1[0] ? 31 : 32;
         `ALU_OP_CLO:
              temp_ans <= (~num1[31]) ? 0 : (~num1[30]) ? 1 : (~num1[29]) ? 2 : (~num1[28]) ? 3 : (~num1[27]) ? 4 :
                        (~num1[26]) ? 5 : (~num1[25]) ? 6 : (~num1[24]) ? 7 : (~num1[23]) ? 8 : (~num1[22]) ? 9 :
                        (~num1[21]) ? 10 : (~num1[20]) ? 11 : (~num1[19]) ? 12 : (~num1[18]) ? 13 : (~num1[17]) ? 14 :
                        (~num1[16]) ? 15 : (~num1[15]) ? 16 : (~num1[14]) ? 17 : (~num1[13]) ? 18 : (~num1[12]) ? 19 :
                        (~num1[11]) ? 20 : (~num1[10]) ? 21 : (~num1[9]) ? 22 : (~num1[8]) ? 23 : (~num1[7]) ? 24 :
                        (~num1[6]) ? 25 : (~num1[5]) ? 26 : (~num1[4]) ? 27 : (~num1[3]) ? 28 : (~num1[2]) ? 29 :
                        (~num1[1]) ? 30 : (~num1[0]) ? 31 : 32;

        default:
            temp_ans <= {num2[31], num2};                   

    endcase

end

endmodule
