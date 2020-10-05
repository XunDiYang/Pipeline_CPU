// opcode
`define     OP_ADD      6'b000000
`define     OP_ADDU     6'b000000
`define     OP_ADDI     6'b001000
`define     OP_ADDIU    6'b001001
`define     OP_SUB      6'b000000
`define     OP_SUBU     6'b000000
`define     OP_SLT      6'b000000
`define     OP_SLTI     6'b001010
`define     OP_SLTU     6'b000000
`define     OP_SLTIU    6'b001011
`define     OP_AND      6'b000000
`define     OP_ANDI     6'b001100
`define     OP_NOR      6'b000000
`define     OP_OR	    6'b000000
`define     OP_ORI	    6'b001101
`define     OP_XOR	    6'b000000
`define     OP_XORI	    6'b001110
`define     OP_SLL	    6'b000000
`define     OP_SLLV	    6'b000000
`define     OP_SRL	    6'b000000
`define     OP_SRLV	    6'b000000
`define     OP_SRA	    6'b000000
`define     OP_SRAV	    6'b000000
`define     OP_LUI	    6'b001111
`define     OP_CLZ	    6'b011100
`define     OP_CLO	    6'b011100
`define     OP_BEQ 	    6'b000100
`define     OP_BNE	    6'b000101
`define     OP_BGTZ	    6'b000111
`define     OP_BLEZ	    6'b000110
`define     OP_BGEZ	    6'b000001
`define     OP_BLTZ	    6'b000001
`define     OP_J	    6'b000010
`define     OP_JAL	    6'b000011
`define     OP_JR       6'b000000
`define     OP_JALR	    6'b000000
//`define     OP_SYSCALL  6'b000000
`define     OP_LB	    6'b100000
`define     OP_LH	    6'b100001
`define     OP_LW       6'b100011
`define     OP_SB	    6'b101000
`define     OP_SH       6'b101001
`define     OP_SW       6'b101011
//`define     OP_ERET	    6'b010000
//`define     OP_MFC0	    6'b010000
//`define     OP_MTC0	    6'b010000

//func
`define     FUNC_ADD    6'b100000
`define     FUNC_ADDU   6'b100001
`define     FUNC_SUB    6'b100010
`define     FUNC_SUBU   6'b100011
`define     FUNC_SLT    6'b101010
`define     FUNC_SLTU   6'b101011
`define     FUNC_AND    6'b100100
`define     FUNC_NOR    6'b100111
`define     FUNC_OR     6'b100101
`define     FUNC_XOR    6'b100110
`define     FUNC_SLL    6'b000000
`define     FUNC_SLLV   6'b000100
`define     FUNC_SRL    6'b000010
`define     FUNC_SRLV   6'b000110
`define     FUNC_SRA    6'b000011
`define     FUNC_SRAV   6'b000111
`define     FUNC_JR     6'b001000
`define     FUNC_JALR   6'b001001
`define     FUNC_CLZ    6'b100000
`define     FUNC_CLO    6'b100001
//`define     FUNC_SYSCALL    6'b001100
//`define     FUNC_ERET   6'b011000
//`define     FUNC_MFC0   5'b00000
//`define     FUNC_MTC0   5'b00000

//大小关系---rs与rt
`define    CTRL_BEQ_EQ  1'b1
`define    CTRL_BEQ_NE   1'b0

//大小关系--rs与0
`define    CTRL_BEQ_GTZ  4'b0001
`define    CTRL_BEQ_LEZ  4'b0010
`define    CTRL_BEQ_GEZ  4'b0100
`define    CTRL_BEQ_LTZ  4'b1000

//无符号数
`define     UNSIGNED    2'b01
`define     SIGNED      2'b00
`define     SHAMIT      2'b10

//起始地址
`define PC_BASE 32'h00400000    
`define MEM_BASE 32'h10010000 

//31号寄存器
`define REG_31  5'b11111

//init
`define INIT_1              1'b0
`define INIT_2              2'b00
`define INIT_3              3'b000
`define INIT_4              4'b0000
`define INIT_5              5'b00000
`define INIT_6              6'b000000
`define INIT_16             16'h0000
`define INIT_26             26'b00000000000000000000000000
`define INIT_32             32'h00000000
`define INIT_11             32'b00000000000

//mux_num1
`define MUX_NUM1_TRUE       1'b1                // reg1
`define MUX_NUM1_FALSE      1'b0                // ex_imm

//mux_num2
`define MUX_NUM2_TRUE       1'b1                // reg2
`define MUX_NUM2_FALSE      1'b0                // ex_imm

//mux_reg_wdata
`define MUX_REG_WDATA_ALU   3'b001               // alu_ans
`define MUX_REG_WDATA_MEM   3'b010               // mem_rdata
`define MUX_REG_WDATA_JAL   3'b100               // jal_dst

//alu_op
`define ALU_OP_ADD          13'b0000000000001     // ADD, ADDU, ADDI, ADDIU, LH, LW, SH, SW,SB,LB
`define ALU_OP_SUB          13'b0000000000010     // SUB, SUBU
`define ALU_OP_SLT          13'b0000000000100     // SLT, SLTI, SLTU,SLTIU
`define ALU_OP_AND          13'b0000000001000     // AND, ANDI
`define ALU_OP_NOR          13'b0000000010000     // NOR 
`define ALU_OP_OR           13'b0000000100000     // OR,  ORI
`define ALU_OP_XOR          13'b0000001000000     // XOR, XORI
`define ALU_OP_SLL          13'b0000010000000     // SLL, SLLV
`define ALU_OP_SRL          13'b0000100000000     // SRL, SRLV
`define ALU_OP_SRA          13'b0001000000000     // SRA, SRAV
`define ALU_OP_LUI          13'b0010000000000     // LUI
`define ALU_OP_CLZ          13'b0100000000000     // CLZ
`define ALU_OP_CLO          13'b1000000000000     // CLO
`define ALU_OP_DEFAULT      13'b0000000000000     // BEQ, BNE, BGTZ, BLEZ, J, JAL, JAR, JALR...

`define DataMemNum  32








