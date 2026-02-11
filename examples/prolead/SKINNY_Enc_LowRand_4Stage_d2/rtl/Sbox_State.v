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


module Sbox_State(
    input clk,
    input [143:0] r,
	input [63:0] state1,
	input [63:0] state2,
	input [63:0] state3,
	output reg [63:0] result1,
	output reg [63:0] result2,
	output reg [63:0] result3
	
    );
	
	wire [7:0] Sbox_in1 [7:0];
	wire [7:0] Sbox_in2 [7:0];
	wire [7:0] Sbox_in3 [7:0];
	wire [7:0] Sbox_out1 [7:0];
	wire [7:0] Sbox_out2 [7:0];
	wire [7:0] Sbox_out3 [7:0];
	integer j;
	reg [3:0] Nibble1 [15:0];
	reg [3:0] Nibble2 [15:0];
	reg [3:0] Nibble3 [15:0];
	
	reg [3:0] OutNibble1 [15:0];
	reg [3:0] OutNibble2 [15:0];
	reg [3:0] OutNibble3 [15:0];
	
	reg [63:0] Reg_state1;
	reg [63:0] Reg_state2;
	reg [63:0] Reg_state3;
	
	wire [143:0] PermutedRandomness [7:0];
	
	wire [71:0] rm, rl;
	wire [71:0] rm8, rl8;
	wire [71:0] rm16, rl16;
	wire [71:0] rm24, rl24;
	wire [71:0] rm32, rl32;
	
	assign rm = r[143:72];
	assign rl = r[71:0];
	
	MyRotation MyRotation1 (
    .r(r), 
    .r1(PermutedRandomness[1]), 
    .r2(PermutedRandomness[2]), 
    .r3(PermutedRandomness[3]), 
    .r4(PermutedRandomness[4]), 
    .r5(PermutedRandomness[5]), 
    .r6(PermutedRandomness[6]), 
    .r7(PermutedRandomness[7])
 );
	 
	
	assign PermutedRandomness[0] = r;

	always @(posedge clk) begin
		Reg_state1 <= state1;
		Reg_state2 <= state2;
		Reg_state3 <= state3;
	end

	
	always @(*) begin 
		for (j=0; j < 8; j=j+1) begin
			result1[8*j +: 8] = Sbox_out1[j];
			result2[8*j +: 8] = Sbox_out2[j];
			result3[8*j +: 8] = Sbox_out3[j];
		end
		

	end
	
	
	
	genvar i;
   generate
      for (i=0; i < 8; i=i+1) 
      begin
		assign Sbox_in1[i] = Reg_state1[8*i +: 8];
		assign Sbox_in2[i] = Reg_state2[8*i +: 8];
		assign Sbox_in3[i] = Reg_state3[8*i +: 8];
      end
   endgenerate
	
	
	generate
      for (i=0; i < 8; i=i+1) 
      begin: TwoSboxInstance
        TwoSboxes TwoSboxes_module (
			.clk(clk), 
			.in1(Sbox_in1[i]), 
			.in2(Sbox_in2[i]), 
			.in3(Sbox_in3[i]), 
			.r(PermutedRandomness[i]), 
			.out1(Sbox_out1[i]), 
			.out2(Sbox_out2[i]), 
			.out3(Sbox_out3[i])
			);
      end

   endgenerate
   



endmodule
