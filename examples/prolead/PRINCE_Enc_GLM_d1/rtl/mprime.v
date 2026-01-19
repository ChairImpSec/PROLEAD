`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Nicolai Müller
// 
// Create Date: 16.03.2020 14:21:32
// Design Name: 
// Module Name: mprime
// Project Name: prince 
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

module add3(
	input i1, 
	input i2, 
	input i3,
	output o
	);
	
	assign o = i1 ^ i2 ^ i3;
endmodule	

module m1(
	 input [15:0] in,
	 output [15:0] out
	 );
	 
	 //assign out[0] = in[8] ^ in[4] ^ in[0];
	 add3 a0(.i1(in[8]), .i2(in[4]), .i3(in[0]), .o(out[0]));
	 
    //assign out[1] = in[13] ^ in[9] ^ in[5];
	 add3 a1(.i1(in[13]), .i2(in[9]), .i3(in[5]), .o(out[1]));

    //assign out[2] = in[14] ^ in[10] ^ in[2];
	 add3 a2(.i1(in[14]), .i2(in[10]), .i3(in[2]), .o(out[2]));

    //assign out[3] = in[15] ^ in[7] ^ in[3];
	 add3 a3(.i1(in[15]), .i2(in[7]), .i3(in[3]), .o(out[3]));

    //assign out[4] = in[12] ^ in[4] ^ in[0];
	 add3 a4(.i1(in[12]), .i2(in[4]), .i3(in[0]), .o(out[4]));

    //assign out[5] = in[9] ^ in[5] ^ in[1];
	 add3 a5(.i1(in[9]), .i2(in[5]), .i3(in[1]), .o(out[5]));

    //assign out[6] = in[14] ^ in[10] ^ in[6];
	 add3 a6(.i1(in[14]), .i2(in[10]), .i3(in[6]), .o(out[6]));

    //assign out[7] = in[15] ^ in[11] ^ in[3];
	 add3 a7(.i1(in[15]), .i2(in[11]), .i3(in[3]), .o(out[7]));

    //assign out[8] = in[12] ^ in[8] ^ in[0];
	 add3 a8(.i1(in[12]), .i2(in[8]), .i3(in[0]), .o(out[8]));

    //assign out[9] = in[13] ^ in[5] ^ in[1];
	 add3 a9(.i1(in[13]), .i2(in[5]), .i3(in[1]), .o(out[9]));

    //assign out[10] = in[10] ^ in[6] ^ in[2];
	 add3 a10(.i1(in[10]), .i2(in[6]), .i3(in[2]), .o(out[10]));

    //assign out[11] = in[15] ^ in[11] ^ in[7];
	 add3 a11(.i1(in[15]), .i2(in[11]), .i3(in[7]), .o(out[11]));

    //assign out[12] = in[12] ^ in[8] ^ in[4];
	 add3 a12(.i1(in[12]), .i2(in[8]), .i3(in[4]), .o(out[12]));

    //assign out[13] = in[13] ^ in[9] ^ in[1];
	 add3 a13(.i1(in[13]), .i2(in[9]), .i3(in[1]), .o(out[13]));

    //assign out[14] = in[14] ^ in[6] ^ in[2];
	 add3 a14(.i1(in[14]), .i2(in[6]), .i3(in[2]), .o(out[14]));

    //assign out[15] = in[11] ^ in[7] ^ in[3];
	 add3 a15(.i1(in[11]), .i2(in[7]), .i3(in[3]), .o(out[15]));

endmodule

module m2(
	 input [15:0] in,
	 output [15:0] out
	 );
	 
    //assign out[0] = in[12] ^ in[8] ^ in[4];
	 add3 a0(.i1(in[12]), .i2(in[8]), .i3(in[4]), .o(out[0]));

    //assign out[1] = in[13] ^ in[9] ^ in[1];
	 add3 a1(.i1(in[13]), .i2(in[9]), .i3(in[1]), .o(out[1]));

    //assign out[2] = in[14] ^ in[6] ^ in[2];
	 add3 a2(.i1(in[14]), .i2(in[6]), .i3(in[2]), .o(out[2]));

    //assign out[3] = in[11] ^ in[7] ^ in[3];
	 add3 a3(.i1(in[11]), .i2(in[7]), .i3(in[3]), .o(out[3]));

    //assign out[4] = in[8] ^ in[4] ^ in[0];
	 add3 a4(.i1(in[8]), .i2(in[4]), .i3(in[0]), .o(out[4]));

    //assign out[5] = in[13] ^ in[9] ^ in[5];
	 add3 a5(.i1(in[13]), .i2(in[9]), .i3(in[5]), .o(out[5]));

    //assign out[6] = in[14] ^ in[10] ^ in[2];
	 add3 a6(.i1(in[14]), .i2(in[10]), .i3(in[2]), .o(out[6]));

    //assign out[7] = in[15] ^ in[7] ^ in[3];
	 add3 a7(.i1(in[15]), .i2(in[7]), .i3(in[3]), .o(out[7]));

    //assign out[8] = in[12] ^ in[4] ^ in[0];
	 add3 a8(.i1(in[12]), .i2(in[4]), .i3(in[0]), .o(out[8]));

    //assign out[9] = in[9] ^ in[5] ^ in[1];
	 add3 a9(.i1(in[9]), .i2(in[5]), .i3(in[1]), .o(out[9]));

    //assign out[10] = in[14] ^ in[10] ^ in[6];
	 add3 a10(.i1(in[14]), .i2(in[10]), .i3(in[6]), .o(out[10]));

    //assign out[11] = in[15] ^ in[11] ^ in[3];
	 add3 a11(.i1(in[15]), .i2(in[11]), .i3(in[3]), .o(out[11]));

    //assign out[12] = in[12] ^ in[8] ^ in[0];
	 add3 a12(.i1(in[12]), .i2(in[8]), .i3(in[0]), .o(out[12]));

    //assign out[13] = in[13] ^ in[5] ^ in[1];
 	 add3 a13(.i1(in[13]), .i2(in[5]), .i3(in[1]), .o(out[13]));

    //assign out[14] = in[10] ^ in[6] ^ in[2];
	 add3 a14(.i1(in[10]), .i2(in[6]), .i3(in[2]), .o(out[14]));

    //assign out[15] = in[15] ^ in[11] ^ in[7];
	 add3 a15(.i1(in[15]), .i2(in[11]), .i3(in[7]), .o(out[15]));

endmodule

module mprime(
    input [63:0] in,
    output [63:0] out
    );
    
	 m1 m1_inst1(.in(in[15:0]), .out(out[15:0]));
	 m2 m2_inst1(.in(in[31:16]), .out(out[31:16]));
	 m2 m2_inst2(.in(in[47:32]), .out(out[47:32]));
	 m1 m1_inst2(.in(in[63:48]), .out(out[63:48]));
endmodule
