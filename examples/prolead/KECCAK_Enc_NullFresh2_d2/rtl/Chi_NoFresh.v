/*
* -----------------------------------------------------------------
* COMPANY : Ruhr University Bochum
* AUTHOR  : Amir Moradi amir.moradi@rub.de Aein Rezaei Shahmirzadi aein.rezaeishahmirzadi@rub.de
* DOCUMENT: "Second-Order SCA Security with almost no Fresh Randomness" TCHES 2021, Issue 3
* -----------------------------------------------------------------
*
* Copyright c 2021, Amir Moradi, Aein Rezaei Shahmirzadi
*
* All rights reserved.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
* ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
* WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTERS BE LIABLE FOR ANY
* DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
* LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION HOWEVER CAUSED AND
* ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
* INCLUDING NEGLIGENCE OR OTHERWISE ARISING IN ANY WAY OUT OF THE USE OF THIS
* SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*
* Please see LICENSE and README for license and further instructions.
*/

module Chi_NoFresh(
	 input clk,
	 input [4:0] in1,
    input [4:0] in2,
    input [4:0] in3,
    output [4:0] out1,
    output [4:0] out2,
    output [4:0] out3
    );

	wire [44:0] CF_Out;
	reg [44:0] CF_Reg;
	wire [4:0] q1;
	wire [4:0] q2;
	wire [4:0] q3;
	
	reg [3:1] a;
	reg [3:1] b;
	reg [3:1] c;
	reg [3:1] d;
	reg [3:1] e;
	
	always @(*) begin
		a = {in3[4],in2[4],in1[4]};
		b = {in3[3],in2[3],in1[3]};
		c = {in3[2],in2[2],in1[2]};
		d = {in3[1],in2[1],in1[1]};
		e = {in3[0],in2[0],in1[0]};
	end

	genvar i;
   generate
		//NonLinear Layer
      for (i=0; i < 45; i=i+1) 
      begin: Inst
         NF_CF #(.num(i)) CF_Inst (
				.a(a), 
				.b(b), 
				.c(c), 
				.d(d), 
				.e(e), 
				.q(CF_Out[i])
			);
      end
		
		//Compression
		for (i=0; i < 5; i=i+1) 
      begin: InstXOR
			XOR_3 Compression1  ( .x0(CF_Reg[9*i]), 	.x1(CF_Reg[9*i+1]), .x2(CF_Reg[9*i+2]), .q(q1[i]) );
			XOR_3 Compression2  ( .x0(CF_Reg[9*i+3]), .x1(CF_Reg[9*i+4]), .x2(CF_Reg[9*i+5]), .q(q2[i]) );
			XOR_3 Compression3  ( .x0(CF_Reg[9*i+6]), .x1(CF_Reg[9*i+7]), .x2(CF_Reg[9*i+8]), .q(q3[i]) );
      end
   endgenerate
	
	always @(posedge clk) begin
		CF_Reg <= CF_Out;
	end
	
	assign out1 = {q1[0], q1[1], q1[2], q1[3], q1[4]};
	assign out2 = {q2[0], q2[1], q2[2], q2[3], q2[4]};
	assign out3 = {q3[0], q3[1], q3[2], q3[3], q3[4]};

endmodule
