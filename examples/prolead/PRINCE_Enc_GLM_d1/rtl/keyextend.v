`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Nicolai Müller
// 
// Create Date: 18.03.2020 08:36:15
// Module Name: keyextend
// Project Name: prince
// Description: module extends the 128-bit key to 192 bit
// 
// Revision:
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////

module keyextend(
    input [127:0] in,
    output [191:0] out
    );
    
    assign out[63:0] = in[127:64];
    assign out[127:64] = ({in[64],in[127:65]}) ^ in[127];
    assign out[191:128] =  in[63:0];
endmodule
