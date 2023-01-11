/*
* -----------------------------------------------------------------
* AUTHOR  : Sara Zarei (sarazareei.94@gmail.com), Aein Rezaei Shahmirzadi (aein.rezaeishahmirzadi@rub.de), Amir Moradi (amir.moradi@rub.de)
* DOCUMENT: "Low-Latency Keccak at any Arbitrary Order" (TCHES 2021, Issue 4)
* -----------------------------------------------------------------
*
* Copyright (c) 2021, Sara Zarei, Aein Rezaei Shahmirzadi, Amir Moradi
* Modified version, taken from https://github.com/hgrosz/keccak_dom 
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


module Keccak_MUX_theta_state #(
    parameter W = 8,
	 parameter b = 200)(

	input Reset,
	input Lastround,
   input EnableLambda,
	input Clock,
	input  [b-1:0] SlicesFromChi,
	input  [b-1:0] InputShares,
   output [b-1:0] StateOut);

	function integer Idx(input integer x, input integer y);
		Idx = (5*x+y)*W;
	endfunction

	localparam STATE_SIZE = 5*5*W;

	wire [b-1:0] SlicesToTheta;
	reg  [b-1:0] StateToReg;
	wire [b-1:0] StateIn;

	// first MUX stage

	assign SlicesToTheta = Reset ? InputShares : SlicesFromChi;

	// theta

	reg[5*W-1:0] C, C_rot;
	reg[25*W-1:0] A, D;

		 always @(*) begin : THETA_PARALLEL
			  integer x, y;
			  A = SlicesToTheta;
			  for(x=0; x < 5; x=x+1) begin
					C[x*W +: W] = A[Idx(x,0) +: W] ^ A[Idx(x,1) +: W] ^ A[Idx(x,2) +: W]
										 ^ A[Idx(x,3) +: W] ^ A[Idx(x,4) +: W];
					C_rot[x*W +: W] = {2{C[x*W +: W]}} >> (W-1);
			  end
			  for(x=0; x < 5; x=x+1) begin
					for(y=0; y < 5; y=y+1) begin
						 D[Idx(x,y) +: W] = A[Idx(x,y) +: W]
							  ^ C[(((x-1)+5) % 5)*W +: W] ^ C_rot[((x+1) % 5)*W +: W];
					end
			  end

			  StateToReg = D;
		 end
		
	

	// second MUX stage

	assign StateIn = Lastround ? SlicesFromChi : StateToReg;
	
	// State Reg

	reg[STATE_SIZE-1:0] StatexDP;
	 always @(posedge Clock) begin : STATE
		StatexDP <= StateIn;
	 end

	assign StateOut = StatexDP;

endmodule

