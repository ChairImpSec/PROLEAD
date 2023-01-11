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

module LED128_Controller(
    input rst,
    input clk,
    output reg AddKey,
    output reg SelKey,
    output reg RoundFunctionEN,
    output reg done,
    output [5:0] FSM );
	 
	 parameter Sbox_Stages = 3;
	 integer i;
	 
	 wire FSM_EN_MUX;
	 reg [Sbox_Stages-1 : 0] FSM_EN_reg;
	 reg FSM_EN_reg2;
	 reg FSM_EN_reg3;
	 wire FSM_EN;
	 
	 wire [5:0] FSM_MUX_output;
	 reg  [5:0] FSM_reg_output;
	 wire [5:0] FSM_Update;
	 
	 
	 assign FSM = FSM_MUX_output;
	 assign FSM_MUX_output = rst ? 6'h1 : FSM_Update;
	 assign FSM_Update = {FSM_reg_output[4:0], FSM_reg_output[4] ~^ FSM_reg_output[5]};
	 
	 
	 always @(posedge clk) begin
		if(FSM_EN) begin
			FSM_reg_output <= FSM_MUX_output;
		end
	 end
	 

	 assign FSM_EN = FSM_EN_reg[Sbox_Stages-1] | rst;
	 
	 //TOGGLE FLIP FLOP
	 always @(posedge clk) begin
		if (rst) begin
			FSM_EN_reg  <= 1;
		end 
		else begin
			for(i=0; i<Sbox_Stages-1; i = i+1) begin
				FSM_EN_reg[i+1] <= FSM_EN_reg[i];
			end
			FSM_EN_reg[0] <= FSM_EN_reg[Sbox_Stages-1];
		end
	 end

	always @(*) begin
		AddKey = 0;
		SelKey = 1;
		done = 0;
		RoundFunctionEN = 1;
		
		if(rst || FSM==6'h01 || FSM==6'h1f || FSM==6'h37 || FSM==6'h39 || FSM==6'h1d || FSM==6'h16 || FSM==6'h21 || FSM==6'h17 || FSM==6'h31 || FSM==6'h1b || FSM==6'h34 || FSM==6'h08)
			AddKey = 1;
		if(rst || FSM==6'h01 || FSM==6'h1f || FSM==6'h37 || FSM==6'h1d || FSM==6'h21 || FSM==6'h31 || FSM==6'h34)
			SelKey = 0;
		if(FSM==6'h09)
			done = 1;
		if(FSM==6'h13)
			RoundFunctionEN = 0;
	end

endmodule
