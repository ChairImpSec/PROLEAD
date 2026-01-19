`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.06.2020 11:05:43
// Design Name: 
// Module Name: muxer
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


module muxer(
    input sel,
    input [63:0] t,
    input [63:0] f,
    output [63:0] res
    );
    
    assign res = (sel == 1'b1) ? t : f;
endmodule
