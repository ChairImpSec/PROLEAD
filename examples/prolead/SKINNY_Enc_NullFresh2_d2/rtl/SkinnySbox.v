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

module SkinnySbox(
    input clk,
	 input [3:0] in1,
    input [3:0] in2,
    input [3:0] in3,
    input [7:0] r,
    output  [3:0] out1,
    output  [3:0] out2,
    output  [3:0] out3
    );
	 
	 wire [3:0] G_out1,G_out2,G_out3;
	 wire [3:0] F_in1,F_in2,F_in3;
	 wire [3:0] q1,q2,q3;
	 reg [3:0] Rq1,Rq2,Rq3;
	 
	 always @(posedge clk) begin
		Rq1 <= q1;
		Rq2 <= q2;
		Rq3 <= q3;
	 end
	 
	 
	 Affine #(.num(1)) InputAffine (
    .x1(in1), 
    .x2(in2), 
    .x3(in3), 
    .y1(F_in1), 
    .y2(F_in2), 
    .y3(F_in3)
    );

	 Q294_1_2order_8r F (
		 .clk(clk), 
		 .in1(F_in1), 
		 .in2(F_in2), 
		 .in3(F_in3), 
		 .r(r), 
		 .out1(q1), 
		 .out2(q2), 
		 .out3(q3)
    );
	 
	 
	  Q294_2_2order_NoFresh G (
		 .clk(clk), 
		 .in1(Rq1), 
		 .in2(Rq2), 
		 .in3(Rq3), 
		 .out1(G_out1), 
		 .out2(G_out2), 
		 .out3(G_out3)
    );
	 
	Affine #(.num(2)) OutputAffine (
    .x1(G_out1), 
    .x2(G_out2), 
    .x3(G_out3), 
    .y1(out1), 
    .y2(out2), 
    .y3(out3)
    );

endmodule
