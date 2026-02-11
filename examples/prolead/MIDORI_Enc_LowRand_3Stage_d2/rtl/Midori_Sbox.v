
/*
* -----------------------------------------------------------------
* AUTHOR  : Aein Rezaei Shahmirzadi (aein.rezaeishahmirzadi@rub.de)
* DOCUMENT: "Low-Latency and Low-Randomness Second-Order Masked Cubic Functions", TCHES 2023, Issue 1.
* -----------------------------------------------------------------
*
* Copyright (c) 2021, Aein Rezaei Shahmirzadi
*
* All rights reserved.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
* ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
* WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTERS BE LIABLE FOR ANY
* DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
* LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
* ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
* (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
* SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*
* Please see LICENSE and README for license and further instructions.
*/

module Midori_Sbox(
	 input clk,
	 input [3:0] in1,
    input [3:0] in2,
    input [3:0] in3,
    input [7:0] TwoSharesFromNeighbouringSbox,
    input [95:0] r,
    output reg [3:0] out1,
    output reg [3:0] out2,
    output reg [3:0] out3
    );


	wire [3:0] q1;
	wire [3:0] q2;
	wire [3:0] q3;

	wire [26:0] CF_Out [3:0];
	reg  [26:0] CF_Reg [3:0];
	
	wire [14:0] CF_Out1;
	reg  [14:0] CF_Reg1;

	reg [3:1] a;
	reg [3:1] b;
	reg [3:1] c;
	reg [3:1] d;

	
	always @(*) begin
		d = {in3[3],in2[3],in1[3]};
		c = {in3[2],in2[2],in1[2]};
		b = {in3[1],in2[1],in1[1]};
		a = {in3[0],in2[0],in1[0]};
	end

	genvar i,j;
   generate
	
	//NonLinear Layer
	for (i=0; i < 27; i=i+1) 
		begin: Component_function_num0
		 NF_CF_1 #(.num(i), .Co_f(0)) CF_Inst0 (
				.a(a), 
				.b(b), 
				.c(c), 
				.d(d), 
				.TwoSharesFromNeighbouringSbox(TwoSharesFromNeighbouringSbox), 
				.r(r), 
				.q(CF_Out[0][i]) );
		end
		
	for (i=0; i < 15; i=i+1) 
		begin: Component_function_num1
		 NF_CF_1 #(.num(i), .Co_f(1)) CF_Inst1 (
				.a(a), 
				.b(b), 
				.c(c), 
				.d(d), 
				.TwoSharesFromNeighbouringSbox(TwoSharesFromNeighbouringSbox), 
				.r(r),
				.q(CF_Out1[i]) );
		end
		
		
	for (j=2; j < 4; j=j+1) begin: Coordinate_function_num
		for (i=0; i < 27; i=i+1) 
		begin: Component_function_num
		 NF_CF_1 #(.num(i), .Co_f(j)) CF_Inst (
				.a(a), 
				.b(b), 
				.c(c), 
				.d(d), 
				.TwoSharesFromNeighbouringSbox(TwoSharesFromNeighbouringSbox), 
				.r(r),
				.q(CF_Out[j][i]) );
		end
	end
		
	//Compression
	
	XOR_n #(.WIDTH(9)) Compression0_0  ( .x(CF_Reg[0][8  : 0]),  .q(q1[0]) );
	XOR_n #(.WIDTH(9)) Compression1_0  ( .x(CF_Reg[0][17 : 9]),  .q(q2[0]) );
	XOR_n #(.WIDTH(9)) Compression2_0  ( .x(CF_Reg[0][26 : 18]), .q(q3[0]) );
	
	XOR_n #(.WIDTH(5)) Compression0_1  ( .x(CF_Reg1[4  : 0]),  .q(q1[1]) );
	XOR_n #(.WIDTH(5)) Compression1_1  ( .x(CF_Reg1[9  : 5]),  .q(q2[1]) );
	XOR_n #(.WIDTH(5)) Compression2_1  ( .x(CF_Reg1[14 : 10]), .q(q3[1]) );	
			
	for (j=2; j < 4; j=j+1) begin:InstXOR
	
		XOR_n #(.WIDTH(9)) Compression0  ( .x(CF_Reg[j][8  : 0]),  .q(q1[j]) );
		XOR_n #(.WIDTH(9)) Compression1  ( .x(CF_Reg[j][17 : 9]),  .q(q2[j]) );
		XOR_n #(.WIDTH(9)) Compression2  ( .x(CF_Reg[j][26 : 18]), .q(q3[j]) );
			
	end
   endgenerate
	
	always @(posedge clk) begin
		//register between component functions and compression layer
		CF_Reg[0] <= CF_Out[0];
		CF_Reg1   <= CF_Out1;
		CF_Reg[2] <= CF_Out[2];
		CF_Reg[3] <= CF_Out[3];
	end
	
	always @(*) begin
		out1 = q1;
		out2 = q2;
		out3 = q3;

	end

endmodule
