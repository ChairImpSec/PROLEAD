`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:21:57 07/24/2020 
// Design Name: 
// Module Name:    muxer1 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module muxer1(
    input sel,
    input t,
    input f,
    output res
    );
    
    assign res = (sel == 1'b1) ? t : f;
endmodule
