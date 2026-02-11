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

module Controller_Midori64(
    input clk,
    input reset,
    output [3:0] round ,
    output roundStart_Select,
    output reg EN,
    output reg done
    );
	 
	parameter Sbox_stages = 2;
	 
	assign roundStart_Select = reset;
	
	
	reg [3:0] PerRoundCounter;
	reg [3:0] RoundCounter;
	assign round = RoundCounter;

	always @(posedge clk) begin
		
		PerRoundCounter 	<= PerRoundCounter + 1;
		
		if(reset) begin
			PerRoundCounter 	<= 0;
			RoundCounter 		<= 0;
		end
		else if (PerRoundCounter == Sbox_stages-1)
		begin
			RoundCounter 		<= RoundCounter + 1;
			PerRoundCounter 	<= 0;
		end

	end
	
	always @(*) begin
		EN 	= 1;
		done 	= 0;
		if (RoundCounter == 4'hf)
			done = 1;
		if (RoundCounter == 4'hf && PerRoundCounter == 4'h3)
			EN = 0;
	end

endmodule
