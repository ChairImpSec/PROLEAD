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


module keccak_top #(      
   parameter b = 25,      		//The width of a KECCAK-p permutation in bits.
   parameter W = 1,       		//The lane size of a KECCAK-p permutation in bits, i.e., b/25
	parameter d = 1,       	   	//The security order
   parameter Sin = d+1,        	
	parameter Sout = Sin**2			
)(
    input  wire Clock,
    input  wire Reset,
	 input  wire [Sin*b-1:0] InData,  // Input shares concatenateed to each other
	 input  wire [((Sin * Sin)- Sin)/2 * b - 1:0] FreshRand,		
    output wire Ready,
    output wire [Sin*b-1:0] OutData	// Output shares concatenateed to each other
);


wire[Sout*b-1:0] StateOut;
wire[Sin*b-1:0]  SlicesFromCompression; 
wire[Sin*b-1:0]  StateFromRhoPi;
wire[Sout*b-1:0] SlicesFromChi;

wire [b-1:0] InputShares [Sout-1:0];
wire enable_lambda;
wire[W-1:0] IotaRC;
wire Lastround;


//---------------------------------------------------------------------

genvar i, j, k;
	
	for (i=0; i < Sin; i=i+1) begin: Make_InShares1
		for (k=0; k <b ; k=k+1) begin: Make_InShares2
			for (j=0; j < Sin; j=j+1) begin: Make_InShares3
				if (i == j)
					assign InputShares[i*Sin+j][k] = InData[i*b+k];
				else
					assign InputShares[i*Sin+j][k] = 1'b0;
			end
		end
	end


	genvar m;
	generate 
		for (m=0; m < Sout; m=m+1) 
		begin: all_mux_linear

			Keccak_MUX_theta_state #(.W(W), .b(b)) MUX_theta_state_inst (
			 .Reset(Reset),
			 .Lastround(Lastround), 
          .EnableLambda(enable_lambda),        
			 .Clock(Clock),
			 .SlicesFromChi(SlicesFromChi[(m+1)*b-1 : m*b]), 
			 .InputShares(InputShares[m]), 
          .StateOut(StateOut[m*b +: b]));

		end
	endgenerate;

 //---------------------------------------------------------------------


		// Compression
		
		compression #(
			.SHARES(Sin),
			.W(W)
			) COMPRESSION(
			.sharesPOW2(StateOut),
			.sharesOrig(SlicesFromCompression)
		);
		
		
//---------------------------------------------------------------------

	// Rho + Pi

	generate
		 for(m = 0; m < Sin; m=m+1) begin : RHOPI

			keccak_rhopi #(.W(W)) RHOPI(
				.In(SlicesFromCompression[m*b +: b]),
				.Out(StateFromRhoPi[m*b +: b]));
		 end
	endgenerate	

//---------------------------------------------------------------------

		// Chi + Iota

		keccak_chi_iota #(
			.SHARES(Sin),
			.W(W)
			) CHI(
			.In(StateFromRhoPi),
			.IotaRCI(IotaRC),
			.FreshRand(FreshRand),
			.Out(SlicesFromChi)
		);

//-----------------------------------------------------------------------------

	assign OutData = SlicesFromCompression;		

//-----------------------------------------------------------------------------
// Control path

keccak_control #(
    .W(W)	
    ) KECCAK_CONTROL (
	
   .Clock(Clock),
   .Reset(Reset),
   .StateCtrl(enable_lambda),
	.IotaRCO(IotaRC),
	.Ready(Ready),
	.Lastround(Lastround));


endmodule  
