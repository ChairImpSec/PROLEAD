`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.07.2020 11:19:46
// Design Name: 
// Module Name: domain_xxxy
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


module domain_xxxy(
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
    
    wire xx01, xx02, xx12, xy03, xy13, xy23, xxy013, xxy023, xxx012, xxy123;

    assign xx01 = x[0] & x[1]; 
    assign xx02 = x[0] & x[2];
    assign xy03 = x[0] & y;
    assign xx12 = x[1] & x[2]; 
    assign xy13 = x[1] & y; 
    assign xy23 = x[2] & y;
    assign xxx012 = xx01 & x[2];
    assign xxy013 = xx01 & y;
    assign xxy023 = x[0] & xy23;
    assign xxy123 = xx12 & y;
    
    assign s0 = xxx012 ^ xx12 ^ xx01 ^ y;
    assign s1 = xxx012 ^ xxy123 ^ xx02 ^ ~xx12;
    assign s2 = xxy013 ^ xxy123 ^ xy03 ^ xy13;
    assign s3 = ~xx01 ^ xy03 ^ xxx012 ^ xxy013 ^xxy023;//xxx012 ^ xxy013 ^ xxy023 ^ xx12 ^ x[1];
       
    assign t0 = xxy013 ^ xxy023 ^ xx12 ^ xx01;
    assign t1 = xxx012 ^ xx02 ^ ~xx12;
 	 assign t2 = xxx012 ^ xxy013 ^ xx02 ^ xx12 ^ x[0];
    assign t3 = ~x[1] ^ xx01 ^ xx12 ^ xy03 ^ xy13 ^ xxx012 ^ xxy023 ^ xxy123;//xxx012 ^ xxy023 ^ xxy123 ^ xx01 ^ xx02 ^ x[0];
endmodule
