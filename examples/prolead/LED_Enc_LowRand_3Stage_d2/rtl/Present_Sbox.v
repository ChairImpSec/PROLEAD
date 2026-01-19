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

module Present_Sbox(
 (* SILVER = "clock" *) input clk,
  (* SILVER = "[3:0]_0" *) input [3:0] in1,
  (* SILVER = "[3:0]_1" *) input [3:0] in2,
  (* SILVER = "[3:0]_2" *) input [3:0] in3,
									 input EN,
  (* SILVER = "refresh" *) input [18*2-1:0] r,
  (* SILVER = "refresh" *) input [7:0] rs_in,
  (* SILVER = "refresh" *) output [7:0] rs_out,

  (* SILVER = "[3:0]_0" *) output  [3:0] out1,
  (* SILVER = "[3:0]_1" *) output  [3:0] out2,
  (* SILVER = "[3:0]_2" *) output  [3:0] out3
    );

	 
	 wire [3:0] InAff_out1;
	 wire [3:0] InAff_out2;
	 wire [3:0] InAff_out3;
	 
	 reg [3:0] InAff_out1_reg;
	 reg [3:0] InAff_out2_reg;
	 reg [3:0] InAff_out3_reg;
	 
	 wire [3:0] Q12_1_out1;
	 wire [3:0] Q12_1_out2;
	 wire [3:0] Q12_1_out3;
	 
	 
	 

	 
	 //----------------------
	 
	 PresentAffines #(.num(1)) InputAffine (
    .x1(in1), 
    .x2(in2), 
    .x3(in3), 
    .y1(InAff_out1), 
    .y2(InAff_out2), 
    .y3(InAff_out3) );
	 
	 always @(posedge clk) begin
		if(EN) begin
			InAff_out1_reg <= InAff_out1;
			InAff_out2_reg <= InAff_out2;
			InAff_out3_reg <= InAff_out3;
		end
	 end
	 
	 assign rs_out = {InAff_out1_reg, InAff_out2_reg};
	 
	 F_2order F_inst (
    .clk(clk), 
    .in1(InAff_out1_reg), 
    .in2(InAff_out2_reg), 
    .in3(InAff_out3_reg), 
    .r(r[17:0]), 
    .rs(rs_in), 
    .out1(Q12_1_out1), 
    .out2(Q12_1_out2), 
    .out3(Q12_1_out3) );

	
	G_2order G_inst (
    .clk(clk), 
    .in1(Q12_1_out1), 
    .in2(Q12_1_out2), 
    .in3(Q12_1_out3), 
    .r(r[18*2-1:18]),
	 //.rs(6'h0), 	
    .out1(out1), 
    .out2(out2), 
    .out3(out3)
    );
	
	
//	assign out1 = M2_out1;
//	assign out2 = M2_out2;
//	assign out3 = M2_out3;

endmodule
