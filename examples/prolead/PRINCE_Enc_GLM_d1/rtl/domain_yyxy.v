`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.07.2020 13:33:24
// Design Name: 
// Module Name: domain_yyxy
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


module domain_yyxy(
    input x,
    input [2:0] y,
    output s0, 
    output s1,
    output s2,
    output s3,
    output t0,
    output t1,
    output t2,
    output t3
    );
    
    wire yy01, yx02, yx12, yy13, yy03, xy23, yyx012, yyy013, yxy023, yxy123;
 
    assign yy01 = y[0] & y[1];
    assign yx02 = y[0] & x;
    assign yx12 = y[1] & x;
    assign yy03 = y[0] & y[2];
    assign yy13 = y[1] & y[2];
    assign xy23 = x & y[2];
    assign yyx012 = yy01 & x;
    assign yyy013 = yy01 & y[2];
    assign yxy023 = yx02 & y[2];
    assign yxy123 = yx12 & y[2];
    
    assign s0 = yyx012 ^ xy23 ^ yy01;
    assign s1 = yyx012 ^ yxy123 ^ yy13;
    assign s2 = yyy013 ^ yxy123 ^ yy03 ^ yy13;
    assign s3 = y[1] ^ yy01 ^ yx12 ^ yy13 ^ xy23 ^ yyx012 ^ yyy013 ^ yxy023;//yyx012 ^ yyy013 ^ yxy023 ^ xy23;
    
    assign t0 = yyy013 ^ yxy023 ^ xy23 ^ yy01;
    assign t1 = yyx012 ^ yy13 ^ xy23;
    assign t2 = yyx012 ^ yyy013 ^ yx02 ^ yy13;
    assign t3 = y[2] ^ yy01 ^ yy03 ^ yy13 ^ xy23 ^ yyx012 ^ yxy023 ^ yxy123;//yyx012 ^ yxy023 ^ yxy123 ^ yx12 ^ yx02 ^ xy23;
endmodule
