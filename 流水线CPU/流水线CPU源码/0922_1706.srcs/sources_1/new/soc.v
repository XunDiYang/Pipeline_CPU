`timescale 1ns / 1ps

module soc(
    input   clk,
    input   rst,
    
    output  wire[6:0]   digital_num0,
    output  wire[6:0]   digital_num1,
    output  wire[7:0]   digital_cs
);

wire [31:0]   num_led_value;

    top top(
        .clk(clk),
        .rst(rst),
        .to_digital(num_led_value)
    );

    num_led num_led(
        .rst(rst),
        .clk(clk),
        .num_led_value(num_led_value),
        .digital_num0(digital_num0),
        .digital_num1(digital_num1),
        .digital_cs(digital_cs)
    );


    
    
    
    
    
    
endmodule