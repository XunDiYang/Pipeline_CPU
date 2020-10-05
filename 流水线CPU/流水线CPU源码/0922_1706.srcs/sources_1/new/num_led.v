`timescale 1ns / 1ps

`define RST_ENABLE 1'b0

module num_led #(
    parameter COUNTER_WIDTH = 20
)(
    input   wire        rst,
    input   wire        clk,
    input   wire[31:0]  num_led_value,
    
    output  wire[6:0]   digital_num0,
    output  wire[6:0]   digital_num1,
    output  wire[7:0]   digital_cs
    );
    
    /*
    * use center button and dial switch on the board as input
    * for example:
    * set the dial switch at down,down,down,up,up,down,up,down(up is high level, down is low level), 
    * then press the center button on  board, the dial switch value which is 00011010(0x1a) will be 
    * write to num_led_value according to write_byte_index. If num_led_value equals 0 then switch value 
    * will be write to num_led_value[7:0], if num_led_value equals 0 then switch value will be write to 
    * num_led_value[15:8] and so on.
    * write_byte_index initial value is 0, it will add 1 when you press center button. 
    * If write_byte_index = 3, write_byte_index will equal 0 after it add 1.
    */


    
    /*
    * digital num led
    * you need to code
    * make digital num led show the value of num_led_value(data width is 32) with Hexadecimal
    */
    reg [COUNTER_WIDTH - 1:0]  count;
    reg [3:0]   scan_data1, scan_data2;
    reg [7:0]   scan_enable;
    reg [6:0]   num_a_g1, num_a_g2;
    
    assign digital_cs = scan_enable;
    assign digital_num0 = num_a_g1;
    assign digital_num1 = num_a_g2;
    
    always @ (posedge clk) begin
        if (rst == `RST_ENABLE) begin
            count <= 0;
        end else begin
            count <= count + 1;
        end
    end
    
    always @ (posedge clk) begin
        if (rst == `RST_ENABLE) begin
            scan_data1 <= 4'b0;
            scan_data2 <= 4'b0;
            scan_enable <= 8'b0;
        end else begin
            case(count[COUNTER_WIDTH - 1:COUNTER_WIDTH - 2])
            2'b00: begin
                scan_data1 <= num_led_value[3:0];
                scan_data2 <= num_led_value[19:16];
                scan_enable <= 8'b0001_0001;
            end
            
            2'b01: begin
                scan_data1 <= num_led_value[7:4];
                scan_data2 <= num_led_value[23:20];
                scan_enable <= 8'b0010_0010;
            end
            
             2'b10: begin
                scan_data1 <= num_led_value[11:8];
                scan_data2 <= num_led_value[27:24];
                scan_enable <= 8'b0100_0100;
            end
            
            2'b11: begin
                scan_data1 <= num_led_value[15:12];
                scan_data2 <= num_led_value[31:28];
                scan_enable <= 8'b1000_1000;
            end   
            
            default: ;
            endcase
        end
    end
    
    always @ (posedge clk) begin
        if (rst == `RST_ENABLE) begin
            num_a_g1 <= 7'b0;
            num_a_g2 <= 7'b0;
        end else begin
            case(scan_data1)
            4'd0: num_a_g1 <= 7'b111_1110; // 0
            4'd1: num_a_g1 <= 7'b011_0000; // 1
            4'd2: num_a_g1 <= 7'b110_1101; // 2
            4'd3: num_a_g1 <= 7'b111_1001; // 3
            4'd4: num_a_g1 <= 7'b011_0011; // 4
            4'd5: num_a_g1 <= 7'b101_1011; // 5
            4'd6: num_a_g1 <= 7'b101_1111; // 6
            4'd7: num_a_g1 <= 7'b111_0000; // 7
            4'd8: num_a_g1 <= 7'b111_1111; // 8
            4'd9: num_a_g1 <= 7'b111_1011; // 9
            4'd10: num_a_g1 <= 7'b111_0111; // a
            4'd11: num_a_g1 <= 7'b001_1111; // b
            4'd12: num_a_g1 <= 7'b000_1101; // c
            4'd13: num_a_g1 <= 7'b011_1101; // d
            4'd14: num_a_g1 <= 7'b100_1111; // e
            4'd15: num_a_g1 <= 7'b100_0111; // f
            
            default: ;
            endcase
            
            case(scan_data2)
            4'd0: num_a_g2 <= 7'b111_1110; // 0
            4'd1: num_a_g2 <= 7'b011_0000; // 1
            4'd2: num_a_g2 <= 7'b110_1101; // 2
            4'd3: num_a_g2 <= 7'b111_1001; // 3
            4'd4: num_a_g2 <= 7'b011_0011; // 4
            4'd5: num_a_g2 <= 7'b101_1011; // 5
            4'd6: num_a_g2 <= 7'b101_1111; // 6
            4'd7: num_a_g2 <= 7'b111_0000; // 7
            4'd8: num_a_g2 <= 7'b111_1111; // 8
            4'd9: num_a_g2 <= 7'b111_1011; // 9
            4'd10: num_a_g2 <= 7'b111_0111; // a
            4'd11: num_a_g2 <= 7'b001_1111; // b
            4'd12: num_a_g2 <= 7'b000_1101; // c
            4'd13: num_a_g2 <= 7'b011_1101; // d
            4'd14: num_a_g2 <= 7'b100_1111; // e
            4'd15: num_a_g2 <= 7'b100_0111; // f
            
            default: ;
            endcase
        end
    end
    
endmodule
