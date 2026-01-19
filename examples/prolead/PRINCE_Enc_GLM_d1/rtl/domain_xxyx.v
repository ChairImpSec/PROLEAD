`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.07.2020 11:35:05
// Design Name: 
// Module Name: domain_xxyx
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


module domain_xxyx(
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
    
    wire xx01, xy02, xy12, xx03, xx13, yx23, xxy012, xxx013, xyx023, xyx123;

    assign xx01 = x[0] & x[1];
    assign xy02 = x[0] & y;
    assign xy12 = x[1] & y;
    assign xx03 = x[0] & x[2];
    assign xx13 = x[1] & x[2];
    assign yx23 = y & x[2];
    
    assign xxx013 = xx01 & x[2];
    assign xyx023 = xy02 & x[2];
    assign xxy012 = xx01 & y;
    assign xyx123 = xy12 & x[2];
    
    assign s0 = xxy012 ^ xy12 ^ xx03 ^ ~x[2];
    assign s1 = xxy012 ^ xyx123 ^ xx13 ^ xy12;
    assign s2 = xxx013 ^ xyx123 ^ xx01 ^ xx13;
    assign s3 = x[1] ^ x[2] ^ xx01 ^ xy12 ^ xx03 ^ xx13 ^ yx23 ^ xxy012 ^ xxx013 ^ xyx023;//xxy012 ^ xxx013 ^ xyx023 ^ xy12 ^ x[2];
    
	 assign t0 = xxx013 ^ xyx023 ^ xy12 ^ ~x[2];
    assign t1 = xxy012 ^ xx13 ^ xy12;
    assign t2 = xxy012 ^ xxx013 ^ xx01 ^ xy12;
    assign t3 = yx23 ^ xxy012 ^ xyx023 ^ xyx123;//xxy012 ^ xyx023 ^ xyx123 ^ xy12 ^ yx23 ^ x[1];
endmodule