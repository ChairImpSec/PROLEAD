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

module SKINNY_SBOX(
	 input clk,
	 input [3:0] in1,
    input [3:0] in2,
    input [3:0] in3,
    input [7:0] TwoSharesFromNeighbouringSbox,
    input [71:0] r,
    output reg [3:0] out1,
    output reg [3:0] out2,
    output reg [3:0] out3
    );


	wire [3:0] q1;
	wire [3:0] q2;
	wire [3:0] q3;

	wire [26:0] CF_Out [1:0];
	reg  [26:0] CF_Reg [1:0];
	
	wire [8:0] CF_Out34 [3:2];
	reg  [8:0] CF_Reg34 [3:2];

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
	for (j=0; j < 2; j=j+1) begin: Coordinate_function_num1
		for (i=0; i < 27; i=i+1) 
		begin: Component_function_num1
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
	
	for (j=2; j < 4; j=j+1) begin: Coordinate_function_num2
		for (i=0; i < 9; i=i+1) 
		begin: Component_function_num2
		 NF_CF_1 #(.num(i), .Co_f(j)) CF_Inst (
				.a(a), 
				.b(b), 
				.c(c), 
				.d(d), 
				.TwoSharesFromNeighbouringSbox(TwoSharesFromNeighbouringSbox), 
				.r(r), 
				.q(CF_Out34[j][i]) );
		end
	end
	
	
		
	//Compression
	for (j=0; j < 2; j=j+1) begin:InstXOR_LSB
	
		   XOR_n #(.WIDTH(9)) Compression0_LSB  ( .x(CF_Reg[j][8  : 0]),  .q(q1[j]) );
			XOR_n #(.WIDTH(9)) Compression1_LSB  ( .x(CF_Reg[j][17 : 9]),  .q(q2[j]) );
			XOR_n #(.WIDTH(9)) Compression2_LSB  ( .x(CF_Reg[j][26 : 18]), .q(q3[j]) );
			
	end
	
	for (j=2; j < 4; j=j+1) begin:InstXOR_MSB
	
		   XOR_n #(.WIDTH(3)) Compression0_MSB  ( .x(CF_Reg34[j][2 : 0]),  .q(q1[j]) );
			XOR_n #(.WIDTH(3)) Compression1_MSB  ( .x(CF_Reg34[j][5 : 3]),  .q(q2[j]) );
			XOR_n #(.WIDTH(3)) Compression2_MSB  ( .x(CF_Reg34[j][8 : 6]),  .q(q3[j]) );
			
	end
   endgenerate
	
	always @(posedge clk) begin
		//register between component functions and compression layer
		CF_Reg[0] <= CF_Out[0];
		CF_Reg[1] <= CF_Out[1];
		CF_Reg34[2] <= CF_Out34[2];
		CF_Reg34[3] <= CF_Out34[3];
	end
	
	always @(*) begin
		out1 = q1;
		out2 = q2;
		out3 = q3;
	end

endmodule
