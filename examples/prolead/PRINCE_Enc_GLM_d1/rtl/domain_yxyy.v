`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.07.2020 13:17:29
// Design Name: 
// Module Name: domain_yxyy
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


module domain_yxyy(
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
    
    wire yx01, yy02, yy03, xy12,xy13,  yy23, yxy012, yxy013, yyy023, xyy123;

    assign yx01 = y[0] & x;
    assign yy02 = y[0] & y[1];
    assign yy03 = y[0] & y[2];
    assign xy12 = x & y[1];
    assign xy13 = x & y[2];
    assign yy23 = y[1] & y[2];
    assign yxy012 = yx01 & y[1];
    assign yxy013 = yx01 & y[2];
    assign yyy023 = yy02 & y[2];
    assign xyy123 = xy12 & y[2];

    assign s0 = yxy012 ^ yy23 ^ yy03;
    assign s1 = yxy012 ^ xyy123 ^ xy13;
    assign s2 = yxy013 ^ xyy123 ^ yx01 ^ y[2];
    assign s3 = y[0] ^ yxy012 ^ yxy013 ^ yyy023;//yxy012 ^ yxy013 ^ yyy023 ^ yy23;
    
    assign t0 = yxy013 ^ yyy023 ^ yy23;
    assign t1 = yxy012 ^ xy13 ^ yy23;
    assign t2 = yxy012 ^ yxy013 ^ yy02 ^ xy13;
    assign t3 = y[0] ^ y[2] ^ yx01 ^ yy02 ^ xy12 ^ yy03 ^ xy13 ^ yy23 ^ yxy012 ^ yyy023 ^ xyy123;//yxy012 ^ yyy023 ^ xyy123 ^ yy02 ^ yy23; 
endmodule
