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

module NF_CF_1(
    input [2:0] a,
    input [2:0] b,
    input [2:0] c,
    input [2:0] d,
    input [7:0] TwoSharesFromNeighbouringSbox,
	input [71:0] r,
	input [3:0] dr1_1,
	input [3:0] dr1_2,
	input [3:0] dr1_3,
    output q 
	 );
	 
	parameter num = 1;
	parameter Co_f = 0;
	wire [7:0] k;
	assign k = TwoSharesFromNeighbouringSbox;
	
	wire [26:0] r1;
	wire [26:0] r3;
	wire [8:0] r2;
	wire [8:0] r4;
	
	assign r1 = r[26:0];
	assign r3 = r[53:27];
	assign r2 = r[62:54];
	assign r4 = r[71:63];
	 
	generate
		if (Co_f == 0) begin
			if(num==0)  assign q = (b[0]&a[0]&c[0]) ^ (b[0]&c[0]&d[0]) ^ (b[0]&a[0]) ^ (c[0]&a[0]) 	^ (a[0]&d[0]) ^ (b[0]&d[0]) ^ b[0] ^ c[0] ^ d[0] ^ a[0]			^ k[0] 				^ r1[0] ^ r1[1] ^ dr1_1[0];
			if(num==1)  assign q = (b[0]&a[0]&c[1]) ^ (b[0]&c[1]&d[1])                                            ^ (b[0]&d[1])                                     ^ k[0] ^ k[1]		^ r1[1] ^ r1[2];
			if(num==2)  assign q = (b[0]&a[0]&c[2]) ^ (b[0]&c[2]&d[2])                                            ^ (b[0]&d[2])                                     ^ k[1] ^ k[2]		^ r1[2] ^ r1[3];
			if(num==3)  assign q = (b[0]&a[1]&c[1]) ^ (b[0]&c[1]&d[0]) ^ (b[0]&a[1]) 				^ (a[1]&d[0])                                                   ^ k[2] ^ k[3]		^ r1[3] ^ r1[4];
			if(num==4)  assign q = (b[0]&a[1]&c[2]) ^ (b[0]&c[2]&d[1])                                                                                              ^ k[3] ^ k[4]		^ r1[4] ^ r1[5];
			if(num==5)  assign q = (b[0]&a[1]&c[0]) ^ (b[0]&c[0]&d[2])				 ^ (c[0]&a[1])                                                                  ^ k[4] ^ k[5]		^ r1[5] ^ r1[6];
			if(num==6)  assign q = (b[0]&a[2]&c[0]) ^ (b[0]&c[0]&d[1]) ^ (b[0]&a[2]) ^ (c[0]&a[2])                                                                  ^ k[5] ^ k[6]		^ r1[6] ^ r1[7];
			if(num==7)  assign q = (b[0]&a[2]&c[1]) ^ (b[0]&c[1]&d[2])                                                                                              ^ k[6] ^ k[7]		^ r1[7] ^ r1[8];
			if(num==8)  assign q = (b[0]&a[2]&c[2]) ^ (b[0]&c[2]&d[0])  							^ (a[2]&d[0]) ^ a[2]      	                                    ^ k[7] 				^ r1[8] ^ r1[9];
																		                                                                                             				
			if(num==9)  assign q = (b[1]&a[0]&c[2]) ^ (b[1]&c[2]&d[0]) ^ (b[1]&a[0]) 							  ^ (b[1]&d[0]) ^ b[1]                               ^ k[0] 			^ r1[9]  ^ r1[10] ^ dr1_2[0];
			if(num==10) assign q = (b[1]&a[0]&c[0]) ^ (b[1]&c[0]&d[1]) 								^ (a[0]&d[1]) ^ (b[1]&d[1])                                      ^ k[0] ^ k[1]		^ r1[10] ^ r1[11];
			if(num==11) assign q = (b[1]&a[0]&c[1]) ^ (b[1]&c[1]&d[2]) 				 ^ (c[1]&a[0])                ^ (b[1]&d[2])                                      ^ k[1] ^ k[2]		^ r1[11] ^ r1[12];
			if(num==12) assign q = (b[1]&a[1]&c[2]) ^ (b[1]&c[2]&d[2]) ^ (b[1]&a[1])                                                                                 ^ k[2] ^ k[3]		^ r1[12] ^ r1[13];
			if(num==13) assign q = (b[1]&a[1]&c[0]) ^ (b[1]&c[0]&d[0])                                                                                               ^ k[3] ^ k[4]		^ r1[13] ^ r1[14];
			if(num==14) assign q = (b[1]&a[1]&c[1]) ^ (b[1]&c[1]&d[1]) 				 ^ (c[1]&a[1])	^ (a[1]&d[1]) ^ c[1] ^ d[1]                                      ^ k[4] ^ k[5]		^ r1[14] ^ r1[15];
			if(num==15) assign q = (b[1]&a[2]&c[0]) ^ (b[1]&c[0]&d[2]) ^ (b[1]&a[2])                                                                                 ^ k[5] ^ k[6]		^ r1[15] ^ r1[16];
			if(num==16) assign q = (b[1]&a[2]&c[1]) ^ (b[1]&c[1]&d[0]) 				 ^ (c[1]&a[2])                                                                   ^ k[6] ^ k[7]		^ r1[16] ^ r1[17];
			if(num==17) assign q = (b[1]&a[2]&c[2]) ^ (b[1]&c[2]&d[1]) 								^ (a[2]&d[1]) ^ a[2]                                             ^ k[7] 			^ r1[17] ^ r1[18];
																		                                                                                             				
			if(num==18) assign q = (b[2]&a[0]&c[0]) ^ (b[2]&c[0]&d[2]) ^ (b[2]&a[0]) 				^ (a[0]&d[2]) ^ (b[2]&d[2]) ^ b[2] ^ a[0]                        ^ k[0] 		^ r1[18] ^ r1[19] ^ dr1_3[0];
			if(num==19) assign q = (b[2]&a[0]&c[1]) ^ (b[2]&c[1]&d[0])                                            ^ (b[2]&d[0])                                      ^ k[0] ^ k[1]	^ r1[19] ^ r1[20];
			if(num==20) assign q = (b[2]&a[0]&c[2]) ^ (b[2]&c[2]&d[1]) 				 ^ (c[2]&a[0])                ^ (b[2]&d[1])                                      ^ k[1] ^ k[2]	^ r1[20] ^ r1[21];
			if(num==21) assign q = (b[2]&a[1]&c[0]) ^ (b[2]&c[0]&d[1]) ^ (b[2]&a[1])                                                                                 ^ k[2] ^ k[3]	^ r1[21] ^ r1[22];
			if(num==22) assign q = (b[2]&a[1]&c[2]) ^ (b[2]&c[2]&d[0]) 				 ^ (c[2]&a[1])                                                                   ^ k[3] ^ k[4]	^ r1[22] ^ r1[23];
			if(num==23) assign q = (b[2]&a[1]&c[1]) ^ (b[2]&c[1]&d[2]) 								^ (a[1]&d[2])                                                    ^ k[4] ^ k[5]	^ r1[23] ^ r1[24];
			if(num==24) assign q = (b[2]&a[2]&c[1]) ^ (b[2]&c[1]&d[1]) ^ (b[2]&a[2])                                                                                 ^ k[5] ^ k[6]	^ r1[24] ^ r1[25];
			if(num==25) assign q = (b[2]&a[2]&c[0]) ^ (b[2]&c[0]&d[0])                                                                                               ^ k[6] ^ k[7]	^ r1[25] ^ r1[26];
			if(num==26) assign q = (b[2]&a[2]&c[2]) ^ (b[2]&c[2]&d[2]) 				 ^ (c[2]&a[2]) 	^ (a[2]&d[2]) ^ c[2] ^ d[2]                                     ^ k[7] 			^ r1[26] ^ r1[0];
		end				
						
		else if (Co_f == 1) begin				
			if(num==0)  assign q = (b[0]&c[0]&d[0]) ^ (b[0]&a[0]) ^ (b[0]&c[0]) ^ (b[0]&d[0]) 	^ (c[0]&d[0]) ^ d[0] ^ a[0] ^ c[0]									^ k[0] 			^ r3[0] ^ r3[1] ^ dr1_1[1];
			if(num==1)  assign q = (b[0]&c[1]&d[1])               ^ (b[0]&c[1]) ^ (b[0]&d[1])                                                                       ^ k[0] ^ k[1]	^ r3[1] ^ r3[2];
			if(num==2)  assign q = (b[0]&c[2]&d[2])               ^ (b[0]&c[2]) ^ (b[0]&d[2])					^ c[2]                                              ^ k[1] ^ k[2]	^ r3[2] ^ r3[3];
			if(num==3)  assign q = (b[0]&c[1]&d[0]) ^ (b[0]&a[1])								^ (c[1]&d[0])                                                       ^ k[2] ^ k[3]	^ r3[3] ^ r3[4];
			if(num==4)  assign q = (b[0]&c[2]&d[1]) 															                                                    ^ k[3] ^ k[4]	^ r3[4] ^ r3[5];
			if(num==5)  assign q = (b[0]&c[0]&d[2])				                                                                                                    ^ k[4] ^ k[5]	^ r3[5] ^ r3[6];
			if(num==6)  assign q = (b[0]&c[0]&d[1]) ^ (b[0]&a[2])                                                                                                   ^ k[5] ^ k[6]	^ r3[6] ^ r3[7];
			if(num==7)  assign q = (b[0]&c[1]&d[2])                                                                                                                 ^ k[6] ^ k[7]	^ r3[7] ^ r3[8];
			if(num==8)  assign q = (b[0]&c[2]&d[0]) 											^ (c[2]&d[0])                                                       ^ k[7] 			^ r3[8] ^ r3[9];
													                                                                                                                 				
			if(num==9)  assign q = (b[1]&c[2]&d[0]) ^ (b[1]&a[0]) ^ (b[1]&c[2]) ^ (b[1]&d[0])                                                                        ^ k[0] 		^ r3[9]  ^ r3[10] ^ dr1_2[1];
			if(num==10) assign q = (b[1]&c[0]&d[1]) 			  ^ (b[1]&c[0]) ^ (b[1]&d[1]) 	^ (c[0]&d[1])  ^ d[1] ^ a[1]                                         ^ k[0] ^ k[1]	^ r3[10] ^ r3[11];
			if(num==11) assign q = (b[1]&c[1]&d[2]) 			  ^ (b[1]&c[1]) ^ (b[1]&d[2])                                                                        ^ k[1] ^ k[2]	^ r3[11] ^ r3[12];
			if(num==12) assign q = (b[1]&c[2]&d[2]) ^ (b[1]&a[1])                                                                                                    ^ k[2] ^ k[3]	^ r3[12] ^ r3[13];
			if(num==13) assign q = (b[1]&c[0]&d[0])                                                                                                                  ^ k[3] ^ k[4]	^ r3[13] ^ r3[14];
			if(num==14) assign q = (b[1]&c[1]&d[1])												^ (c[1]&d[1]) 				                                         ^ k[4] ^ k[5]	^ r3[14] ^ r3[15];
			if(num==15) assign q = (b[1]&c[0]&d[2]) ^ (b[1]&a[2])                                                                                                    ^ k[5] ^ k[6]	^ r3[15] ^ r3[16];
			if(num==16) assign q = (b[1]&c[1]&d[0]) 				                                                                                                 ^ k[6] ^ k[7]	^ r3[16] ^ r3[17];
			if(num==17) assign q = (b[1]&c[2]&d[1]) 											^ (c[2]&d[1]) ^ c[2]                                                 ^ k[7] 		^ r3[17] ^ r3[18];
													                                                                                                                 				
			if(num==18) assign q = (b[2]&c[0]&d[2]) ^ (b[2]&a[0]) ^ (b[2]&c[0]) ^ (b[2]&d[2])	^ (c[0]&d[2])                                                        ^ k[0] 		^ r3[18] ^ r3[19] ^ dr1_3[1];
			if(num==19) assign q = (b[2]&c[1]&d[0])               ^ (b[2]&c[1]) ^ (b[2]&d[0])                                                                        ^ k[0] ^ k[1]	^ r3[19] ^ r3[20];
			if(num==20) assign q = (b[2]&c[2]&d[1]) 			  ^ (b[2]&c[2])	^ (b[2]&d[1])                                                                        ^ k[1] ^ k[2]	^ r3[20] ^ r3[21];
			if(num==21) assign q = (b[2]&c[0]&d[1]) ^ (b[2]&a[1])                                                                                                    ^ k[2] ^ k[3]	^ r3[21] ^ r3[22];
			if(num==22) assign q = (b[2]&c[2]&d[0]) 				                                                                                                 ^ k[3] ^ k[4]	^ r3[22] ^ r3[23];
			if(num==23) assign q = (b[2]&c[1]&d[2])												^ (c[1]&d[2]) 				                                         ^ k[4] ^ k[5]	^ r3[23] ^ r3[24];
			if(num==24) assign q = (b[2]&c[1]&d[1]) ^ (b[2]&a[2])                                                                                                    ^ k[5] ^ k[6]	^ r3[24] ^ r3[25];
			if(num==25) assign q = (b[2]&c[0]&d[0])																^ c[0]                                               ^ k[6] ^ k[7]	^ r3[25] ^ r3[26];
			if(num==26) assign q = (b[2]&c[2]&d[2])												^ (c[2]&d[2]) ^ d[2] ^ a[2]                                         ^ k[7] 			^ r3[26] ^ r3[0];
		end					
						
		else if (Co_f == 2) begin				
			if(num==0)  assign q = (b[0]&c[0]) ^ d[0] ^ c[0] ^ b[0] ^ 1'b1  ^ k[0] ^ k[1] ^ r2[0] ^ r2[1] ^ dr1_1[2];
			if(num==1)  assign q = (b[0]&c[1])                            	^ k[1] ^ k[2] ^ r2[1] ^ r2[2];
			if(num==2)  assign q = (b[0]&c[2])                            	^ k[2] ^ k[0] ^ r2[2] ^ r2[3];                              
			
			if(num==3)  assign q = (b[1]&c[0]) ^ d[1] ^ b[1]		  		^ k[0] ^ k[1] ^ r2[3] ^ r2[4] ^ dr1_2[2];
			if(num==4)  assign q = (b[1]&c[1]) ^ c[1]                       ^ k[1] ^ k[2] ^ r2[4] ^ r2[5];
			if(num==5)  assign q = (b[1]&c[2])                            	^ k[2] ^ k[0] ^ r2[5] ^ r2[6];                                                
			
			if(num==6)  assign q = (b[2]&c[0]) ^ d[2] ^ b[2]		  		^ k[0] ^ k[1] ^ r2[6] ^ r2[7] ^ dr1_3[2];
			if(num==7)  assign q = (b[2]&c[1])                            	^ k[1] ^ k[2] ^ r2[7] ^ r2[8];
			if(num==8)  assign q = (b[2]&c[2]) ^ c[2]						^ k[2] ^ k[0] ^ r2[8] ^ r2[0];																 				
			
		end					
						
		else if (Co_f == 3) begin				
			if(num==0)  assign q = (c[0]&d[0]) ^ d[0] ^ c[0] ^ a[0] ^ 1'b1	^ k[0] ^ k[1] ^ r4[0] ^ r4[1] ^ dr1_1[3];
			if(num==1)  assign q = (c[0]&d[1])                            	^ k[1] ^ k[2] ^ r4[1] ^ r4[2];
			if(num==2)  assign q = (c[0]&d[2])                            	^ k[2] ^ k[0] ^ r4[2] ^ r4[3];                                          
																			   
			if(num==3)  assign q = (c[1]&d[0]) ^ c[1] ^ a[1]		  		^ k[0] ^ k[1] ^ r4[3] ^ r4[4] ^ dr1_2[3];
			if(num==4)  assign q = (c[1]&d[1]) ^ d[1]                     	^ k[1] ^ k[2] ^ r4[4] ^ r4[5];
			if(num==5)  assign q = (c[1]&d[2])                            	^ k[2] ^ k[0] ^ r4[5] ^ r4[6];                                             
																			   
			if(num==6)  assign q = (c[2]&d[0]) ^ c[2] ^ a[2]		  		^ k[0] ^ k[1] ^ r4[6] ^ r4[7] ^ dr1_3[3];
			if(num==7)  assign q = (c[2]&d[1])                            	^ k[1] ^ k[2] ^ r4[7] ^ r4[8];
			if(num==8)  assign q = (c[2]&d[2]) ^ d[2]						^ k[2] ^ k[0] ^ r4[8] ^ r4[0];
			
		end	
		
		


	endgenerate


endmodule
