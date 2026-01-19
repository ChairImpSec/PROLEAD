`timescale 1ns / 1ps

/*
* -----------------------------------------------------------------
* COMPANY : Ruhr University Bochum
* AUTHOR  : Amir Moradi (amir.moradi@rub.de) Aein Rezaei Shahmirzadi (aein.rezaeishahmirzadi@rub.de)
* DOCUMENT: https://doi.org/10.46586/tches.v2021.i1.305-342
* -----------------------------------------------------------------
*
* Copyright (c) 2020, Amir Moradi, Aein Rezaei Shahmirzadi
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

module Controller(
    input clk,
    input rst,
	 output reg KeyScheduleRegisterEN,
	 output reg ShowRcon,
	 output reg DoSR,
    output reg DoMC,
	 output reg state_reg_hold,
	 output reg key_reg_hold,
	 output reg DoKeySbox,
	 output reg JustFirstColShift,
	 output reg Done,
	 output reg CorrectCiphertext,
	 output reg output_sel,
	 output reg [1:0] KeyIn_sel,
	 output reg [1:0] SboxIn_sel,
	 output reg [7:0] Rcon
    );
	
	
	reg [3:0] RoundCounter;
	reg [5:0] PerRoundCounter;
	reg [7:0] Rcon_Reg;
	wire [7:0] Rcon_x2;
	
	wire [7:0] conditionalXOR;
	wire [7:0] ShiftedData;
	
	parameter FinalRoundNumber = 10;
	
	assign conditionalXOR = {3'b000, Rcon_Reg[7], Rcon_Reg[7], 1'b0, Rcon_Reg[7], Rcon_Reg[7]};
	assign ShiftedData = {Rcon_Reg[6:0], 1'b0};
	assign Rcon_x2 = conditionalXOR ^ ShiftedData;
	
	always @(posedge clk) begin
		if (rst) begin
			RoundCounter <= 0;
			PerRoundCounter <= 1;
			Rcon_Reg <= 1;
		end
		else begin
			PerRoundCounter <= PerRoundCounter + 1;
			if (RoundCounter == 0) begin
				if(PerRoundCounter == 19) begin
					RoundCounter <= RoundCounter + 1;
					PerRoundCounter <= 0;
				end
			end
			else begin
				if(PerRoundCounter == 22) begin
					RoundCounter <= RoundCounter + 1;
					PerRoundCounter <= 0;
					Rcon_Reg <= Rcon_x2;
				end
			end
		end
	end
	
	always @(*) begin
		Rcon 					= Rcon_Reg;
		DoSR 					= 0;
		DoMC 					= 0;
		state_reg_hold 	= 1;
		key_reg_hold   	= 1;
		DoKeySbox			= 0;
		JustFirstColShift	= 0;	
		KeyIn_sel			= 2;
		SboxIn_sel			= 3;
		ShowRcon				= 0;
		output_sel			= 1;
		CorrectCiphertext = 0;
		Done              = 0;
		KeyScheduleRegisterEN = 0;

		
		if(RoundCounter == 0 || (RoundCounter == 1 && PerRoundCounter < 3) || rst == 1) begin
				KeyIn_sel 		= 0;
		end			
	   else if(PerRoundCounter == 3 || PerRoundCounter == 4 || PerRoundCounter == 5 || PerRoundCounter == 6) begin
				KeyIn_sel 		= 1;
		end			
		
		if(RoundCounter == FinalRoundNumber) begin

			if (PerRoundCounter > 2 && PerRoundCounter < 19) begin
				Done = 1;
			end
		end
		
		if(rst == 1) begin
			SboxIn_sel  = 0;
		end		
		else if(RoundCounter == 0) begin
			if(PerRoundCounter < 16) 
				SboxIn_sel  = 0;
			else 	
				SboxIn_sel  = 1;
		end
		else begin
			if(PerRoundCounter < 3 || PerRoundCounter > 18) 
				SboxIn_sel  = 1;
			else if (PerRoundCounter < 7 )
				SboxIn_sel  = 2;
		end
						
		case (PerRoundCounter)
			5'd0: begin
					if(RoundCounter != 0) 
							key_reg_hold 		= 0;
					end
			5'd1: begin
					if(RoundCounter != 0) 
							DoSR 					= 1;
					if(RoundCounter != 0) 
							key_reg_hold 		= 0;
					end
					
			5'd2: begin
					if(RoundCounter != 0) begin
							KeyScheduleRegisterEN = 1;
							state_reg_hold = 0;
							JustFirstColShift = 1;
							end
					end
			5'd3: begin
					if(RoundCounter != 0) begin
						ShowRcon = 1;
						KeyScheduleRegisterEN = 1;
					end
					if(RoundCounter != 0 && RoundCounter != FinalRoundNumber) 
							DoMC 					= 1;
					if(RoundCounter == FinalRoundNumber)
							output_sel 			= 0;
					end
			5'd4: begin
					if(RoundCounter != 0) begin
							KeyScheduleRegisterEN = 1;
							end
					
					if(RoundCounter == FinalRoundNumber) begin
							output_sel 			= 0;
							Done 					= 1;
							CorrectCiphertext = 1;
							end
					end
			5'd5: begin
					if(RoundCounter != 0) begin
							KeyScheduleRegisterEN = 1;
							end
					if(RoundCounter == FinalRoundNumber) begin
							output_sel 			= 0;
							end
					end
					
			5'd6: begin
					if(RoundCounter == FinalRoundNumber) begin
							output_sel 			= 0;
							end
					end
			5'd7: begin
					if(RoundCounter != 0 && RoundCounter != FinalRoundNumber) begin
							DoMC 					= 1;
						end
					end
					
			5'd11: begin
					if(RoundCounter != 0 && RoundCounter != FinalRoundNumber) begin
							DoMC 					= 1;
						end
					end
			5'd15: begin
					if(RoundCounter != 0 && RoundCounter != FinalRoundNumber) 
							DoMC 					= 1;
					end
			5'd16: begin
					if(RoundCounter == 0) 
							DoKeySbox 			= 1;
					end
			5'd17: begin
					if(RoundCounter == 0) 
							DoKeySbox 			= 1;
					end
			5'd18: begin

					if(RoundCounter == 0) 
							DoKeySbox 			= 1;
					end
			5'd19: begin
							DoKeySbox 			= 1;
					end
			5'd20, 5'd21: begin
					if(RoundCounter != 0) 
							DoKeySbox 			= 1;
					end
			5'd22: begin
					if(RoundCounter != 0) begin
							DoKeySbox 			= 1;
							end
					end
			
			
					 
			default : begin
							DoSR 					= 0;
							DoMC 					= 0;
							state_reg_hold 	= 1;
							key_reg_hold   	= 1;
							DoKeySbox			= 0;
							JustFirstColShift	= 0;	
							ShowRcon				= 0;	
							KeyScheduleRegisterEN = 0;
						 end
   endcase
	end 
	
	
	
endmodule
