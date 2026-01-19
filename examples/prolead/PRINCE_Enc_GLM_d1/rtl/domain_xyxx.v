`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.07.2020 11:56:34
// Design Name: 
// Module Name: domain_xyxx
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


module domain_xyxx(
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
    
    wire xy01, xx02, yx12, xx03, yx13, xx23, xyx012, xyx013, xxx023, yxx123;

    assign xy01 = x[0] & y;
    assign xx02 = x[0] & x[1];
    assign xx03 = x[0] & x[2];
    assign yx12 = x[1] & y;
    assign yx13 = x[2] & y;
    assign xx23 = x[1] & x[2];
    assign xyx012 = xy01 & x[1];
    assign xyx013 = xy01 & x[2];
    assign xxx023 = xx02 & x[2];
    assign yxx123 = xx23 & y;

    assign s0 = xyx012 ^ yx12 ^ xy01 ^ x[1];
    assign s1 = xyx012 ^ yxx123 ^ yx13 ^ yx12;
    assign s2 = xyx013 ^ yxx123 ^ xx03 ^ x[2];
    assign s3 = xx03 ^ xyx012 ^ xyx013 ^ xxx023;//xyx012 ^ xyx013 ^ xxx023 ^ yx12 ^ y;
    
    assign t0 = xyx013 ^ xxx023 ^ yx12 ^ xy01;
    assign t1 = xyx012 ^ yx13 ^ yx12;
	 assign t2 = xyx012 ^ xyx013 ^ xy01 ^ yx12 ^ x[1];
    assign t3 = y ^ xx02 ^ yx12 ^ xx23 ^ xyx012 ^ xxx023 ^ yxx123;//xyx012 ^ xxx023 ^ yxx123 ^ xy01 ^ ~xx23;
endmodule
