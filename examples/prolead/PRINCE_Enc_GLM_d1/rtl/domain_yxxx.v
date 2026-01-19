`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.07.2020 12:43:22
// Design Name: 
// Module Name: domain_yxxx
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


module domain_yxxx(
    input [2:0] x,
    input y,
    output s0, 
    output s1,
    output s2,
    output s3,
    output t0,
    output t1,
    output t2,
    output t3
    );
    
    wire yx01, yx02, yx03, xx12, xx13, xx23, yxx012, yxx013, yxx023, xxx123;

    assign yx01 = y & x[0];
    assign yx02 = y & x[1];
    assign yx03 = y & x[2];
    assign xx12 = x[0] & x[1];
    assign xx13 = x[0] & x[2];
    assign xx23 = x[1] & x[2];
    assign yxx012 = yx01 & x[1];
    assign yxx013 = yx01 & x[2];
    assign yxx023 = yx02 & x[2];
    assign xxx123 = xx23 & x[0];
    
    assign s0 = yxx012 ^ xx23 ^ yx01;
    assign s1 = yxx012 ^ xxx123 ^ yx02;
    assign s2 = yxx013 ^ xxx123 ^ yx03 ^ y;
    assign s3 = xx12 ^ xx13 ^ xx23 ^ yxx012 ^ yxx013 ^ yxx023;//~yxx012 ^ yxx013 ^ yxx023 ^ xx23;
    
    assign t0 = yxx013 ^ yxx023 ^ xx23 ^ yx01;
    assign t1 = yxx012 ^ yx02 ^ xx23;
    assign t2 = yxx012 ^ yxx013 ^ yx01 ^ xx13 ^ y;
    assign t3 = yx02 ^ yxx012 ^ yxx023 ^ xxx123;//yxx012 ^ yxx023 ^ xxx123 ^ yx01 ^ xx12 ^ y; 
endmodule
