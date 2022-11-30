/*
* -----------------------------------------------------------------
* AUTHOR  : Aein Rezaei Shahmirzadi (aein.rezaeishahmirzadi@rub.de)
* DOCUMENT: "Cryptanalysis of Efficient Masked Ciphers: Applications to Low Latency" (TCHES 2022, Issue 1)
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

module G_2order(
 (* SILVER = "clock" *) input clk,
  (* SILVER = "[3:0]_0" *) input [3:0] in1,
  (* SILVER = "[3:0]_1" *) input [3:0] in2,
  (* SILVER = "[3:0]_2" *) input [3:0] in3,
  
  (* SILVER = "refresh" *) input [6*3-1:0] r,
  //(* SILVER = "refresh" *) input [6-1:0] rs,

  (* SILVER = "[3:0]_0" *) output reg [3:0] out1,
  (* SILVER = "[3:0]_1" *) output reg [3:0] out2,
  (* SILVER = "[3:0]_2" *) output reg [3:0] out3
    );


   wire [2:0] q1;
   wire [2:0] q2;
   wire [2:0] q3;
	
	wire [26:0] CF_Out;
	reg [26:0] CF_Reg;
	
	reg [2:0] a;
	reg [2:0] b;
	reg [2:0] c;
	reg [2:0] d;
	reg [2:0] areg;

	
	always @(*) begin
		d = {in3[3],in2[3],in1[3]};
		c = {in3[2],in2[2],in1[2]};
		b = {in3[1],in2[1],in1[1]};
		a = {in3[0],in2[0],in1[0]};
	end

	genvar i;
   generate
		//NonLinear Layer
      for (i=0; i < 27; i=i+1) 
      begin: Inst
         CF_G #(.num(i)) CF_Inst (
				.a(a), 
				.b(b), 
				.c(c), 
				.d(d),
				.r1(r[5:0]),
				.r2(r[11:6]),
				.r3(r[17:12]),
//				.rs(rs),
				.q(CF_Out[i])
			);
      end
		
		//Compression
	  for (i=0; i < 3; i=i+1) 
      begin: InstXOR
			XOR_3 Compression1  ( .x0(CF_Reg[9*i]),   .x1(CF_Reg[9*i+1]), .x2(CF_Reg[9*i+2]), .q(q1[i]) );
			XOR_3 Compression2  ( .x0(CF_Reg[9*i+3]), .x1(CF_Reg[9*i+4]), .x2(CF_Reg[9*i+5]), .q(q2[i]) );
			XOR_3 Compression3  ( .x0(CF_Reg[9*i+6]), .x1(CF_Reg[9*i+7]), .x2(CF_Reg[9*i+8]), .q(q3[i]) );
      end
   endgenerate
	
	always @(posedge clk) begin
		//register between component functions and compression layer
		CF_Reg <= CF_Out;
		
		areg <= a ^ d ^ 3'h1;
	end
	
	always @(*) begin
	
		out1[0] = areg[1];
		out2[0] = areg[2];
		out3[0] = areg[0];
		
		out1[1] = q1[0];
		out2[1] = q2[0];
		out3[1] = q3[0];
		
		out1[2] = q1[1];
		out2[2] = q2[1];
		out3[2] = q3[1];
		
		out1[3] = q1[2];
		out2[3] = q2[2];
		out3[3] = q3[2];
	end

endmodule
