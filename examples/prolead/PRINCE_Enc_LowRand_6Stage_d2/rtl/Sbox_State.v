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
    input [215:0] r,
	input sel,
	input [63:0] In_state1,
	input [63:0] In_state2,
	input [63:0] In_state3,
	output reg [63:0] result1,
	output reg [63:0] result2,
	output reg [63:0] result3
	
    );
	reg [63:0] state1;
	reg [63:0] state2;
	reg [63:0] state3;
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
	
	wire [215:0] PermutedRandomness [7:0];
	
	reg reg_sel;

	always @(posedge clk) begin
		state1 <= In_state1;
		state2 <= In_state2;
		state3 <= In_state3;
		reg_sel <= sel;
	end

	
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


	
	always @(*) begin 
		for (j=0; j < 16; j=j+1) begin
			Nibble1[j] = state1[4*j +: 4];
			Nibble2[j] = state2[4*j +: 4];
			Nibble3[j] = state3[4*j +: 4];
			
			result1[4*j +: 4] = OutNibble1[j];
			result2[4*j +: 4] = OutNibble2[j];
			result3[4*j +: 4] = OutNibble3[j];
		end
	end
	
	always @(*) begin 
		for (j=0; j < 4; j=j+1) begin
			{OutNibble1[j], OutNibble1[j+4]} = Sbox_out1[j];
			{OutNibble2[j], OutNibble2[j+4]} = Sbox_out2[j];
			{OutNibble3[j], OutNibble3[j+4]} = Sbox_out3[j];
		end
		
		for (j=0; j < 4; j=j+1) begin
			{OutNibble1[j+8], OutNibble1[j+12]} = Sbox_out1[j+4];
			{OutNibble2[j+8], OutNibble2[j+12]} = Sbox_out2[j+4];
			{OutNibble3[j+8], OutNibble3[j+12]} = Sbox_out3[j+4];
		end
	end
	
	
	
	genvar i;
   generate
      for (i=0; i < 4; i=i+1) 
      begin
		assign Sbox_in1[i] = {Nibble1[i], Nibble1[i+4]};
		assign Sbox_in2[i] = {Nibble2[i], Nibble2[i+4]};
		assign Sbox_in3[i] = {Nibble3[i], Nibble3[i+4]};
      end
	  for (i=0; i < 4; i=i+1) 
      begin
		assign Sbox_in1[i+4] = {Nibble1[i+8], Nibble1[i+12]};
		assign Sbox_in2[i+4] = {Nibble2[i+8], Nibble2[i+12]};
		assign Sbox_in3[i+4] = {Nibble3[i+8], Nibble3[i+12]};
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
			.sel(reg_sel),
			.r(PermutedRandomness[i]), 
			.out1(Sbox_out1[i]), 
			.out2(Sbox_out2[i]), 
			.out3(Sbox_out3[i])
			);
      end

   endgenerate
   



endmodule
