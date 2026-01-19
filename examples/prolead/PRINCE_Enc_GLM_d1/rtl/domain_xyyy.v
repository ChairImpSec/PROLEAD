`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.07.2020 12:33:44
// Design Name: 
// Module Name: domain_xyyy
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


module domain_xyyy(
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
    
    wire xy01, xy02, xy03, yy12, yy13, yy23, xyy012, xyy013, xyy023, yyy123;

    assign xy01 = x & y[0];
    assign xy02 = x & y[1];
    assign xy03 = x & y[2];
    assign yy12 = y[0] & y[1];
    assign yy13 = y[0] & y[2];
    assign yy23 = y[1] & y[2];
    assign xyy012 = xy01 & y[1];
    assign xyy013 = xy01 & y[2];
    assign xyy023 = xy02 & y[2];
    assign yyy123 = yy12 & y[2];
    
    assign s0 = xyy012 ^ yy12 ^ xy03 ^ y[1];
    assign s1 = xyy012 ^ yyy123 ^ xy02 ^ yy12;
    assign s2 = xyy013 ^ yyy123 ^ xy01 ^ x;
    assign s3 = y[2] ^ yy12 ^ xy03 ^ yy13 ^ yy23 ^ xyy012 ^ xyy013 ^ xyy023;//xyy012 ^ xyy013 ^ xyy023 ^ yy12 ^ y[2];
    
    assign t0 = xyy013 ^ xyy023 ^ yy12 ^ y[2];
    assign t1 = xyy012 ^ xy02 ^ yy12;
    assign t2 = xyy012 ^ xyy013 ^ xy02 ^ yy12;
	 assign t3 = x ^ xy01 ^ xy02 ^ xy03 ^ yy13 ^ xyy012 ^ xyy023 ^ yyy123;
endmodule
