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


module keccak_control #(
    parameter W = 8
)(
    input  wire Clock,
    input  wire Reset,
    output wire StateCtrl,
    output wire [W-1:0]IotaRCO,
    output reg  Ready,
    output wire Lastround
);


//-----------------------------------------------------------------------------
localparam ROUNDS = 12;
localparam   
	START					    = 3'h01,
   CHI_IOTA_NextLAMDA    = 3'h02,
   FINISH                = 3'h04;
//-----------------------------------------------------------------------------


reg[2:0]  CtrlStatexDP, CtrlStatexDN;
reg[4:0]  RoundCountxDP;
wire[4:0] RoundCountxDN;
reg       RoundCountLastxDP;

reg enableRoundCountxS;
reg enable_lambda;

assign StateCtrl = enable_lambda;
assign Lastround = RoundCountLastxDP & (~Reset);



//-----------------------------------------------------------------------------
// State machine

always @(*) begin : FSM
    CtrlStatexDN = CtrlStatexDP;

	 Ready = 1'b0;
    enable_lambda = Reset;
    enableRoundCountxS = 1'b0;

    case(CtrlStatexDP)

	START: begin
 		enable_lambda = 1'b1;

		 if(~Reset) 
		 begin
			enableRoundCountxS = 1'b1;
			CtrlStatexDN = CHI_IOTA_NextLAMDA;
		 end
		 else
			CtrlStatexDN = START;
	end
   
   CHI_IOTA_NextLAMDA: begin
		enable_lambda = 1'b1;
		enableRoundCountxS = 1'b1;
		if(RoundCountLastxDP) 
            CtrlStatexDN = FINISH;   
        else
            CtrlStatexDN = CHI_IOTA_NextLAMDA;
	end
		
	FINISH: begin
	    Ready = 1;
	end		
		
		
    endcase
end

always @(posedge Clock) begin
    if(Reset) begin
        CtrlStatexDP <= START;
        RoundCountxDP <= 0;
        RoundCountLastxDP <= 0;		
	end
    else begin
	     CtrlStatexDP <= CtrlStatexDN;
        RoundCountLastxDP <= (RoundCountxDN >= (ROUNDS - 1));
  		  if (enableRoundCountxS)
				RoundCountxDP <= RoundCountxDN;
	end
end


assign RoundCountxDN	= RoundCountxDP + 1;

wire[W-1:0] RCxD;

keccak_roundconstant #(
    .W(W)
    ) RC_GEN (
    .RoundNrxDI(RoundCountxDP),
    .RCxDO(RCxD)
    );

assign IotaRCO = RCxD ;


endmodule