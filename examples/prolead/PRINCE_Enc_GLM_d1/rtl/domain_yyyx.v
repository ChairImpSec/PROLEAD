`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.07.2020 13:43:23
// Design Name: 
// Module Name: domain_yyyx
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


module domain_yyyx(
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
    
    wire yy01, yy02, yx03, yy12, yx13, yx23, yyy012, yyx013, yyx023, yyx123;
    
    assign yy01 = y[0] & y[1];
    assign yy02 = y[0] & y[2];
    assign yx03 = y[0] & x;
    assign yy12 = y[1] & y[2];
    assign yx13 = y[1] & x;
    assign yx23 = y[2] & x;
    assign yyy012 = yy01 & y[2];
    assign yyx013 = yy01 & x;
    assign yyx023 = yx23 & y[0];
    assign yyx123 = yx23 & y[1];

    assign s0 = yyy012 ^ yx23 ^ yx03;
    assign s1 = yyy012 ^ yyx123 ^ yy02;
    assign s2 = yyx013 ^ yyx123 ^ yy01 ^ yx13;
    assign s3 = y[0] ^ yy01 ^ yyy012 ^ yyx013 ^ yyx023;//yyy012 ^ yyx013 ^ yyx023 ^ yx23;
    
    assign t0 = yyx013 ^ yyx023 ^ yx23;
    assign t1 = yyy012 ^ yy02 ^ yx23;
    assign t2 = yyy012 ^ yyx013 ^ yy01 ^ yx13 ^ y[2];
    assign t3 = yy12 ^ yyy012 ^ yyx023 ^ yyx123;//yyy012 ^ yyx023 ^ yyx123 ^ yy01 ^ y[1];
endmodule
