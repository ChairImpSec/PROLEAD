`timescale 1ns / 1ps
// Engineer: Nicolai Müller
// 
// Create Date: 16.03.2020 14:50:12
// Module Name: invshiftrows
// Project Name: prince
// Description: inverse shift rows operations
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module invshiftrows(
    input [63:0] in,
    output [63:0] out
    );
    
    assign out[3:0] = in[51:48];
    assign out[7:4] = in[39:36];
    assign out[11:8] = in[27:24];
    assign out[15:12] = in[15:12];
    
    assign out[19:16] = in[3:0];
    assign out[23:20] = in[55:52];
    assign out[27:24] = in[43:40];
    assign out[31:28] = in[31:28];
    
    assign out[35:32] = in[19:16];
    assign out[39:36] = in[7:4];
    assign out[43:40] = in[59:56];    
    assign out[47:44] = in[47:44];
    
    assign out[51:48] = in[35:32];
    assign out[55:52] = in[23:20];
    assign out[59:56] = in[11:8];
    assign out[63:60] = in[63:60];
   
endmodule
