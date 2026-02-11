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
	input [107:0] r,
	input sel,
    input [7:0] TwoSharesFromNeighbouringSbox,
    output q 
	 );
	 
	parameter num = 1;
	parameter Co_f = 0;
	wire [7:0] k;
	assign k = TwoSharesFromNeighbouringSbox;
	
	wire q_Sinv;
	wire q_S;
	wire MUX;
	 
	wire [26:0] r1;
	wire [26:0] r4;
	wire [26:0] r3;
	wire [26:0] r2;
	
	assign r1 = r[26:0];
	assign r3 = r[53:27];
	assign r4 = r[80:54];
	assign r2 = r[107:81];
	
	
	// Sbox Inverse
	generate
		if (Co_f == 0) begin
			if(num==0)  begin
				assign q_Sinv 	= (a[0]&b[0]&d[0]) ^ (a[0]&c[0]&d[0]) ^ (a[0]&b[0]) ^ 	(c[0]&b[0]) ^	(c[0]&d[0]) ^ d[0]  ^ b[0] ^ 1'b1  ;
				assign q_S 		= (a[0]&b[0]&c[0])  ^ (a[0]&b[0]) ^ 	(c[0]&b[0]) ^ (c[0]&d[0]) ^ (a[0]&d[0]) ^ 1'b1 ^ c[0] ^ d[0] ^ b[0];
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[0] ^ r1[0] ^ r1[1];
			end
			
			if(num==1)  begin 
				assign q_Sinv = (a[0]&b[0]&d[1]) ^ (a[0]&c[1]&d[1]);
				assign q_S = (a[0]&b[0]&c[1]) ^ c[1] ^ d[1] ;
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[0] ^ k[1]	^ r1[1] ^ r1[2];
			end
			
			if(num==2)  begin 
				assign q_Sinv 	= (a[0]&b[0]&d[2]) ^ (a[0]&c[2]&d[2]) 	;
				assign q_S 		= (a[0]&b[0]&c[2]) 						;
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[1] ^ k[2] ^ r1[2] ^ r1[3];
			end
			
			if(num==3)  begin 
				assign q_Sinv 	= (a[0]&b[1]&d[0]) ^ (a[0]&c[1]&d[0]) ^ (a[0]&b[1]) ^ b[1] ;
				assign q_S 		= (a[0]&b[1]&c[1])  ^ (a[0]&b[1]) ;
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[2] ^ k[3] ^ r1[3] ^ r1[4];
			end
			if(num==4)  begin 
				assign q_Sinv 	= (a[0]&b[1]&d[1]) ^ (a[0]&c[2]&d[1]) ;
				assign q_S 		= (a[0]&b[1]&c[2]) ;
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[3] ^ k[4]	    ^ r1[4] ^ r1[5];
			end
			if(num==5)  begin 
				assign q_Sinv 	= (a[0]&b[1]&d[2]) ^ (a[0]&c[0]&d[2]) ^ (c[0]&b[1]) ^	(c[0]&d[2]);
				assign q_S 		= (a[0]&b[1]&c[0])  ^ (c[0]&b[1]) ^ (c[0]&d[2]) ^ (a[0]&d[2]) ;
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[4] ^ k[5]	    ^ r1[5] ^ r1[6];
			end
			if(num==6)  begin 
				assign q_Sinv 	= (a[0]&b[2]&d[1]) ^ (a[0]&c[0]&d[1]) ^ (a[0]&b[2]) ^ 	(c[0]&b[2]) ^	(c[0]&d[1]) ;
				assign q_S 		= (a[0]&b[2]&c[0])  ^ (a[0]&b[2]) ^ 	(c[0]&b[2]) ^ (c[0]&d[1]) ^ (a[0]&d[1]) ;
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[5] ^ k[6] ^ r1[6] ^ r1[7];
			end
			if(num==7)  begin 
				assign q_Sinv 	= (a[0]&b[2]&d[2]) ^ (a[0]&c[1]&d[2]) ;
				assign q_S 		= (a[0]&b[2]&c[1]) ;
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[6] ^ k[7] ^ r1[7] ^ r1[8];
			end
			if(num==8)  begin 
				assign q_Sinv 	= (a[0]&b[2]&d[0]) ^ (a[0]&c[2]&d[0]);
				assign q_S 		= (a[0]&b[2]&c[2]) ;
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[7] ^ r1[8] ^ r1[9];
			end
																																									    
			if(num==9)  begin 
				assign q_Sinv = (a[1]&b[0]&d[0]) ^ (a[1]&c[2]&d[0]) ^ (a[1]&b[0]);
				assign q_S = (a[1]&b[0]&c[2])  ^ (a[1]&b[0])^ d[0];
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[0] 			^ r1[9]  ^ r1[10];
			end
			if(num==10) begin 
				assign q_Sinv = (a[1]&b[0]&d[1]) ^ (a[1]&c[0]&d[1]) ^ d[1] ;
				assign q_S = (a[1]&b[0]&c[0])  ^ c[0]  ;		 				 			    
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[0] ^ k[1]	    ^ r1[10] ^ r1[11];
			end
			if(num==11) begin 
				assign q_Sinv = (a[1]&b[0]&d[2]) ^ (a[1]&c[1]&d[2]) ^(c[1]&b[0]) ^	(c[1]&d[2]);
				assign q_S = (a[1]&b[0]&c[1])  ^ (c[1]&b[0]) ^ (c[1]&d[2]) ^ (a[1]&d[2]) ^ c[1];
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[1] ^ k[2]	    ^ r1[11] ^ r1[12];
			end
			if(num==12) begin 
				assign q_Sinv = (a[1]&b[1]&d[2]) ^ (a[1]&c[2]&d[2]) ^ (a[1]&b[1]) ^ b[1];
				assign q_S = (a[1]&b[1]&c[2])  ^ (a[1]&b[1]);
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[2] ^ k[3]	    ^ r1[12] ^ r1[13];
			end
			if(num==13) begin 
				assign q_Sinv = (a[1]&b[1]&d[0]) ^ (a[1]&c[0]&d[0]) ;
				assign q_S = (a[1]&b[1]&c[0]) ;
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[3] ^ k[4]	    ^ r1[13] ^ r1[14];
			end
			if(num==14) begin 
				assign q_Sinv = (a[1]&b[1]&d[1]) ^ (a[1]&c[1]&d[1]) ^ (c[1]&b[1]) ^ 	(c[1]&d[1]) ;
				assign q_S = (a[1]&b[1]&c[1])  ^ (c[1]&b[1]) ^ (c[1]&d[1]) ^ (a[1]&d[1]) ;
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[4] ^ k[5]	    ^ r1[14] ^ r1[15];
			end
			if(num==15) begin 
				assign q_Sinv = (a[1]&b[2]&d[2]) ^ (a[1]&c[0]&d[2]) ^ (a[1]&b[2]) ;
				assign q_S = (a[1]&b[2]&c[0])  ^ (a[1]&b[2]) ;
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[5] ^ k[6]	    ^ r1[15] ^ r1[16];
			end
			if(num==16) begin 
				assign q_Sinv = (a[1]&b[2]&d[0]) ^ (a[1]&c[1]&d[0]) ^ (c[1]&b[2]) ^ 	(c[1]&d[0]) ;
				assign q_S = (a[1]&b[2]&c[1])  ^ (c[1]&b[2]) ^ (c[1]&d[0]) ^ (a[1]&d[0]) ;
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[6] ^ k[7]	    ^ r1[16] ^ r1[17];
			end
			if(num==17) begin 
				assign q_Sinv 	= (a[1]&b[2]&d[1]) ^ (a[1]&c[2]&d[1]) ^ b[2] ;
				assign q_S 		= (a[1]&b[2]&c[2]) ;
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[7] 		    ^ r1[17] ^ r1[18];
			end
																																					 				    
			if(num==18) begin 
				assign q_Sinv = (a[2]&b[0]&d[2]) ^ (a[2]&c[0]&d[2]) ^ (a[2]&b[0]) ^ d[2] ^ b[0] ;
				assign q_S = (a[2]&b[0]&c[0])  ^ (a[2]&b[0]) ^ b[0] ;	
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[0] 			^ r1[18] ^ r1[19]	; 			        
			end
			if(num==19) begin  
				assign q_Sinv = (a[2]&b[0]&d[0]) ^ (a[2]&c[1]&d[0])                                                                          ;
				assign q_S = (a[2]&b[0]&c[1])   														^ c[1] ^ d[0]               ;    
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[0] ^ k[1]	    ^ r1[19] ^ r1[20]  ;                                        
			end
			if(num==20) begin  
				assign q_Sinv = (a[2]&b[0]&d[1]) ^ (a[2]&c[2]&d[1]) ^				(c[2]&b[0]) ^	(c[2]&d[1])                              ;
				assign q_S = (a[2]&b[0]&c[2])  ^				(c[2]&b[0]) ^ (c[2]&d[1]) ^ (a[2]&d[1])                           ;
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[1] ^ k[2]	    ^ r1[20] ^ r1[21];
			end
			if(num==21) begin  
				assign q_Sinv = (a[2]&b[1]&d[1]) ^ (a[2]&c[0]&d[1]) ^ (a[2]&b[1])                                                            ;
				assign q_S = (a[2]&b[1]&c[0])  ^ (a[2]&b[1])                                                          ;
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[2] ^ k[3]	    ^ r1[21] ^ r1[22];
			end
			if(num==22) begin  
				assign q_Sinv = (a[2]&b[1]&d[0]) ^ (a[2]&c[2]&d[0]) ^				(c[2]&b[1]) ^	(c[2]&d[0])                              ;
				assign q_S = (a[2]&b[1]&c[2])  ^				(c[2]&b[1]) ^ (c[2]&d[0]) ^ (a[2]&d[0])              ;
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[3] ^ k[4]	    ^ r1[22] ^ r1[23];
			end
			if(num==23) begin  
				assign q_Sinv = (a[2]&b[1]&d[2]) ^ (a[2]&c[1]&d[2])                                                                          ;
				assign q_S = (a[2]&b[1]&c[1])                                                                           ;
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[4] ^ k[5]	    ^ r1[23] ^ r1[24];
			end
			if(num==24) begin  
				assign q_Sinv = (a[2]&b[2]&d[1]) ^ (a[2]&c[1]&d[1]) ^ (a[2]&b[2])                                                            ;
				assign q_S = (a[2]&b[2]&c[1])  ^ (a[2]&b[2])                                                                         ;
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[5] ^ k[6]	    ^ r1[24] ^ r1[25];
			end
			if(num==25) begin  
				assign q_Sinv = (a[2]&b[2]&d[0]) ^ (a[2]&c[0]&d[0])                                                                          ;
				assign q_S = (a[2]&b[2]&c[0])															^ c[0]                     ;  
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[6] ^ k[7]	    ^ r1[25] ^ r1[26]      ;                                  
			end
			if(num==26) begin  
				assign q_Sinv = (a[2]&b[2]&d[2]) ^ (a[2]&c[2]&d[2]) ^				(c[2]&b[2]) ^  	(c[2]&d[2]) ^ b[2]                       ;
				assign q_S = (a[2]&b[2]&c[2])  ^				(c[2]&b[2]) ^ (c[2]&d[2]) ^ (a[2]&d[2]) ^ c[2] ^ d[2]               ;
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[7] 		    ^ r1[26] ^ r1[0];
			end
		end				
						
		
		else if (Co_f == 1) begin				
			if(num==0)  begin 
				assign q_Sinv = (b[0]&a[0]&c[0]) ^ (c[0]&b[0]) 	^ (a[0]&c[0]) ^ (d[0]&b[0])	^ d[0] ^ 1'b1  ^ (d[0]&c[0])     ;	
				assign q_S = (b[0]&a[0]&c[0]) ^ (b[0]&d[0]&c[0]) ^ (d[0]&b[0]) ^ (c[0]&b[0]) ^ (a[0]&c[0]) ^ 1'b1 ;
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[0] 			^ r2[0] ^ r2[1];
			end
			if(num==1)  begin 
				assign q_Sinv = (b[0]&a[0]&c[1]) ^ (c[1]&b[0]) 	^ (a[0]&c[1]) ^ (d[1]&b[0]) ^ d[1]	            ;  
				assign q_S = (b[0]&a[0]&c[1]) ^ (b[0]&d[1]&c[1]) ^ (d[1]&b[0]) ^ (c[1]&b[0]) ^ c[1]      ;
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[0] ^ k[1]	^ r2[1] ^ r2[2];
			end
			if(num==2)  begin 
				assign q_Sinv = (b[0]&a[0]&c[2]) ^ (c[2]&b[0])	^ (a[0]&c[2]) ^ (d[2]&b[0])                     ;   
				assign q_S = (b[0]&a[0]&c[2]) ^ (b[0]&d[2]&c[2]) ^ (d[2]&b[0]) ^ (c[2]&b[0])                       ;
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[1] ^ k[2]	^ r2[2] ^ r2[3];
			end
			if(num==3)  begin 
				assign q_Sinv = (b[0]&a[1]&c[1])	 ^ (d[0]&c[1])							                                ;
				assign q_S = (b[0]&a[1]&c[1]) ^	(b[0]&d[0]&c[1])	 							                   ;
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[2] ^ k[3]	^ r2[3] ^ r2[4];
			end
			if(num==4)  begin 
				assign q_Sinv = (b[0]&a[1]&c[2])                                                                ;
				assign q_S = (b[0]&a[1]&c[2]) ^ (b[0]&d[1]&c[2])                                             ;
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[3] ^ k[4]	^ r2[4] ^ r2[5];
			end
			if(num==5)  begin 
				assign q_Sinv = (b[0]&a[1]&c[0]) ;
				assign q_S = (b[0]&a[1]&c[0]) ^ (b[0]&d[2]&c[0]) 							 ^ (&a[1]&c[0]);
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[4] ^ k[5]	^ r2[5] ^ r2[6];
			end
			if(num==6)  begin 
				assign q_Sinv = (b[0]&a[2]&c[0]) ;   
				assign q_S = (b[0]&a[2]&c[0]) ^ (b[0]&d[1]&c[0]) 							 ^ (&a[2]&c[0]);
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX  ^ k[5] ^ k[6]	^ r2[6] ^ r2[7];         
			end
			if(num==7)  begin 
				assign q_Sinv = (b[0]&a[2]&c[1]);   
				assign q_S = (b[0]&a[2]&c[1]) ^ (b[0]&d[2]&c[1]);
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[6] ^ k[7]	^ r2[7] ^ r2[8];
			end
			if(num==8)  begin 
				assign q_Sinv = (b[0]&a[2]&c[2]) ^ (d[0]&c[2]);
				assign q_S = (b[0]&a[2]&c[2]) ^ (b[0]&d[0]&c[2]);
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[7] 		    ^ r2[8] ^ r2[9];
			end
		
			if(num==9)  begin 
				assign q_Sinv = (b[1]&a[0]&c[2]) ^ (b[1]&c[2])  ^ (b[1]&d[0])  ;           
				assign q_S = (b[1]&a[0]&c[2]) ^ (b[1]&d[0]&c[2]) ^ (b[1]&d[0]) ^ (b[1]&c[2]) ;
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[0] 		    ^ r2[9]  ^ r2[10];
			end
			if(num==10) begin 
				assign q_Sinv = (b[1]&a[0]&c[0]) ^ (b[1]&c[0]) ^ (b[1]&d[1])  ^ (d[1]&c[0])^ d[1];  
				assign q_S = (b[1]&a[0]&c[0]) ^ (b[1]&d[1]&c[0]) ^ (b[1]&d[1]) ^ (b[1]&c[0]) ^ c[0] ;
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[0] ^ k[1]	^ r2[10] ^ r2[11];
			end
			if(num==11) begin 
				assign q_Sinv = (b[1]&a[0]&c[1]) ^ (b[1]&c[1])  ^ (b[1]&d[2])             ^ d[2] ;         
				assign q_S = (b[1]&a[0]&c[1]) ^ (b[1]&d[2]&c[1]) ^ (b[1]&d[2]) ^ (b[1]&c[1]) ^ (a[0]&c[1]) ^ c[1]           ;
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX  ^ k[1] ^ k[2]	^ r2[11] ^ r2[12] ;    
			end
			if(num==12) begin 
				assign q_Sinv = (b[1]&a[1]&c[2]) ^ (a[1]&c[2]) ;      
				assign q_S = (b[1]&a[1]&c[2]) ^ (b[1]&d[2]&c[2])                      	                                    ;
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[2] ^ k[3]	^ r2[12] ^ r2[13]    ; 
			end
			if(num==13) begin 
				assign q_Sinv = (b[1]&a[1]&c[0]) ^ (a[1]&c[0]);
				assign q_S = (b[1]&a[1]&c[0]) ^ (b[1]&d[0]&c[0])                                                            ;
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[3] ^ k[4]	^ r2[13] ^ r2[14];
			end
			if(num==14) begin 
				assign q_Sinv = (b[1]&a[1]&c[1]) ^ (d[1]&c[1]) ^ (a[1]&c[1]);
				assign q_S = (b[1]&a[1]&c[1]) ^ (b[1]&d[1]&c[1]) 						     ^ (a[1]&c[1])                  ;
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[4] ^ k[5]	^ r2[14] ^ r2[15]; 
			end
			if(num==15) begin 
				assign q_Sinv = (b[1]&a[2]&c[0]);
				assign q_S = (b[1]&a[2]&c[0]) ^	(b[1]&d[2]&c[0])  							                                ; 
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[5] ^ k[6]	^ r2[15] ^ r2[16] ;
			end
			if(num==16) begin 
				assign q_Sinv = (b[1]&a[2]&c[1]);
				assign q_S = (b[1]&a[2]&c[1]) ^ (b[1]&d[0]&c[1])    						 ^ (a[2]&c[1])                  ;
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[6] ^ k[7]	^ r2[16] ^ r2[17];
			end
			if(num==17) begin 
				assign q_Sinv = (b[1]&a[2]&c[2]) ^ (d[1]&c[2]);
				assign q_S = (b[1]&a[2]&c[2]) ^ (b[1]&d[1]&c[2]); 
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[7] 		    ^ r2[17] ^ r2[18];
			end
																									           				
			if(num==18) begin 
				assign q_Sinv = (b[2]&a[0]&c[0]) ^ (b[2]&c[0])  ^ (b[2]&d[2]) ^ (d[2]&c[0]) 	^ d[2];
				assign q_S = (b[2]&a[0]&c[0]) ^ (b[2]&d[2]&c[0]) ^ (b[2]&d[2]) ^ (c[0]&b[2]) ^ c[0] 	                   	;
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[0] 		    ^ r2[18] ^ r2[19] ;
			end
			if(num==19) begin 
				assign q_Sinv = (b[2]&a[0]&c[1]) ^ (b[2]&c[1])  ^ (b[2]&d[0]) ^ d[0];  
				assign q_S = (b[2]&a[0]&c[1]) ^ (b[2]&d[0]&c[1]) ^ (b[2]&d[0]) ^ (c[1]&b[2])     	           			    ;
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[0] ^ k[1]	^ r2[19] ^ r2[20];
			end
			if(num==20) begin 
				assign q_Sinv = (b[2]&a[0]&c[2]) ^ (b[2]&c[2])  ^ (b[2]&d[1]);    
				assign q_S = (b[2]&a[0]&c[2]) ^ (b[2]&d[1]&c[2]) ^ (b[2]&d[1]) ^ (c[2]&b[2]) ^ (a[0]&c[2])                  ;
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[1] ^ k[2]	^ r2[20] ^ r2[21];
			end
			if(num==21) begin 
				assign q_Sinv = (b[2]&a[1]&c[0])        ;     
				assign q_S = (b[2]&a[1]&c[0]) ^ (b[2]&d[1]&c[0])  ;
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX  ^ k[2] ^ k[3]	^ r2[21] ^ r2[22]  ;  
			end
			if(num==22) begin 
				assign q_Sinv = (b[2]&a[1]&c[2])                ;   
				assign q_S = (b[2]&a[1]&c[2]) ^ (b[2]&d[0]&c[2]) ^                           ^ (a[1]&c[2])                  ;
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[3] ^ k[4]	^ r2[22] ^ r2[23] ;
			end
			if(num==23) begin 
				assign q_Sinv = (b[2]&a[1]&c[1]) ^ (d[2]&c[1])				;  
				assign q_S = (b[2]&a[1]&c[1]) ^ (b[2]&d[2]&c[1]) ;
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[4] ^ k[5]	^ r2[23] ^ r2[24]  ;
			end
			if(num==24) begin 
				assign q_Sinv = (b[2]&a[2]&c[1]) ^ (a[2]&c[1])               ;
				assign q_S = (b[2]&a[2]&c[1]) ^ (b[2]&d[1]&c[1]) ;
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[5] ^ k[6]	^ r2[24] ^ r2[25];
			end
			if(num==25) begin 
				assign q_Sinv = (b[2]&a[2]&c[0]) ^ (a[2]&c[0])               ;
				assign q_S = (b[2]&a[2]&c[0]) ^ (b[2]&d[0]&c[0]);
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[6] ^ k[7]	^ r2[25] ^ r2[26];
			end
			if(num==26) begin 
				assign q_Sinv = (b[2]&a[2]&c[2]) ^ (a[2]&c[2]) ^ (d[2]&c[2]);
				assign q_S = (b[2]&a[2]&c[2]) ^ (b[2]&d[2]&c[2]) ^ 							 ^ (a[2]&c[2]) ;                 
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX  ^ k[7] ^ r2[26] ^ r2[0];
			end
		end	
						
		else if (Co_f == 2) begin				
			if(num==0)  begin 
				assign q_Sinv = (b[0]&a[0]&c[0]) ^ (b[0]&a[0]&d[0]) ^ (a[0]&c[0]) ^ (a[0]&b[0]) ^ (b[0]&c[0]) ^ (b[0]&d[0]) ^ a[0] ^ c[0]    	;
				assign q_S = (b[0]&d[0]&c[0]) ^ (b[0]&a[0]&d[0]) ^  (a[0]&b[0])  ^ (b[0]&d[0]) 		^ (a[0]&d[0]) ^ a[0] ^ d[0]	 ;                 
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[0] 			^ r3[0] ^ r3[1];
			end
			if(num==1)  begin 
				assign q_Sinv = (b[0]&a[0]&c[1]) ^ (b[0]&a[0]&d[1]) ^ (a[0]&c[1])               ^ (b[0]&c[1]) ^ (b[0]&d[1])                  	;
				assign q_S = (b[0]&d[1]&c[1]) ^ (b[0]&a[0]&d[1]) ^                 ^ (b[0]&d[1]);                 
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[0] ^ k[1]	^ r3[1] ^ r3[2];
			end
			if(num==2)  begin 
				assign q_Sinv = (b[0]&a[0]&c[2]) ^ (b[0]&a[0]&d[2]) ^ (a[0]&c[2])               ^ (b[0]&c[2]) ^ (b[0]&d[2])                  	;
				assign q_S = (b[0]&d[2]&c[2]) ^ (b[0]&a[0]&d[2]) ^                 ^ (b[0]&d[2])                               ;                 
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[1] ^ k[2]	^ r3[2] ^ r3[3];
			end
			if(num==3)  begin 
				assign q_Sinv = (b[0]&a[1]&c[1]) ^ (b[0]&a[1]&d[0]) ^ 			    (a[1]&b[0])	                                            ;
				assign q_S = (b[0]&d[0]&c[1]) ^ (b[0]&a[1]&d[0]) ^  (a[1]&b[0])	                    ^ (a[1]&d[0]) ^ a[1]          ;                 
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[2] ^ k[3]	^ r3[3] ^ r3[4];
			end
			if(num==4)  begin 
				assign q_Sinv = (b[0]&a[1]&c[2]) ^ (b[0]&a[1]&d[1]);
				assign q_S = (b[0]&d[1]&c[2]) ^ (b[0]&a[1]&d[1]);                 
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[3] ^ k[4]	^ r3[4] ^ r3[5];
			end
			if(num==5)  begin 
				assign q_Sinv = (b[0]&a[1]&c[0]) ^ (b[0]&a[1]&d[2])                                                                          	;
				assign q_S = (b[0]&d[2]&c[0]) ^ (b[0]&a[1]&d[2]);                 
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[4] ^ k[5]	^ r3[5] ^ r3[6] ;
			end
			if(num==6)  begin 
				assign q_Sinv = (b[0]&a[2]&c[0]) ^ (b[0]&a[2]&d[1]) ^				(a[2]&b[0])                                              	;
				assign q_S = (b[0]&d[1]&c[0]) ^ (b[0]&a[2]&d[1]) ^	(a[2]&b[0]);                 
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[5] ^ k[6]	^ r3[6] ^ r3[7];
			end
			if(num==7)  begin 
				assign q_Sinv = (b[0]&a[2]&c[1]) ^ (b[0]&a[2]&d[2])                                                                          	;
				assign q_S = (b[0]&d[2]&c[1]) ^ (b[0]&a[2]&d[2]);                 
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[6] ^ k[7]	^ r3[7] ^ r3[8];
			end
			if(num==8)  begin 
				assign q_Sinv = (b[0]&a[2]&c[2]) ^ (b[0]&a[2]&d[0]) 	          															 	;	
				assign q_S = (b[0]&d[0]&c[2]) ^ (b[0]&a[2]&d[0])									^ (a[2]&d[0]);	                 
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[7] 			^ r3[8] ^ r3[9]	;																				 								
			end
						 							                                                                                               				        
			if(num==9)  begin 
				assign q_Sinv = (b[1]&a[0]&c[2]) ^ (b[1]&a[0]&d[0]) ^				(a[0]&b[1]) ^ (b[1]&c[2]) ^ (b[1]&d[0])  			     	;
				assign q_S = (b[1]&d[0]&c[2]) ^ (b[1]&a[0]&d[0]) ^	(a[0]&b[1])   ^ (b[1]&d[0]);	                 
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[0] 			^ r3[9]  ^ r3[10]	;		
			end
			if(num==10) begin 
				assign q_Sinv = (b[1]&a[0]&c[0]) ^ (b[1]&a[0]&d[1])                             ^ (b[1]&c[0]) ^ (b[1]&d[1])                  	;
				assign q_S = (b[1]&d[1]&c[0]) ^ (b[1]&a[0]&d[1])                   ^ (b[1]&d[1])    ^ (a[0]&d[1]) ^ d[1] ^ a[0]     ;                 
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[0] ^ k[1]	^ r3[10] ^ r3[11] ;
			end
			if(num==11) begin 
				assign q_Sinv = (b[1]&a[0]&c[1]) ^ (b[1]&a[0]&d[2])                             ^ (b[1]&c[1]) ^ (b[1]&d[2])                  	;
				assign q_S = (b[1]&d[2]&c[1]) ^ (b[1]&a[0]&d[2])                   ^ (b[1]&d[2])  ;                 
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[1] ^ k[2]	^ r3[11] ^ r3[12];
			end
			if(num==12) begin 
				assign q_Sinv = (b[1]&a[1]&c[2]) ^ (b[1]&a[1]&d[2]) ^ (a[1]&c[2]) ^ (a[1]&b[1])                                              	;
				assign q_S = (b[1]&d[2]&c[2]) ^ (b[1]&a[1]&d[2]) ^  (a[1]&b[1])                                                     ;                 
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[2] ^ k[3]	^ r3[12] ^ r3[13] ;
			end
			if(num==13) begin 
				assign q_Sinv = (b[1]&a[1]&c[0]) ^ (b[1]&a[1]&d[0]) ^ (a[1]&c[0])                                                            	;
				assign q_S = (b[1]&d[0]&c[0]) ^ (b[1]&a[1]&d[0]) ;                 
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[3] ^ k[4]	^ r3[13] ^ r3[14];
			end
			if(num==14) begin 
				assign q_Sinv = (b[1]&a[1]&c[1]) ^ (b[1]&a[1]&d[1]) ^ (a[1]&c[1]) ^ a[1] ^ c[1]	                                            ;
				assign q_S = (b[1]&d[1]&c[1]) ^ (b[1]&a[1]&d[1]) ^  								^ (a[1]&d[1])                   ;                 
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[4] ^ k[5]	^ r3[14] ^ r3[15];
			end
			if(num==15) begin 
				assign q_Sinv = (b[1]&a[2]&c[0]) ^ (b[1]&a[2]&d[2]) ^               (a[2]&b[1])                                              	;
				assign q_S = (b[1]&d[2]&c[0]) ^ (b[1]&a[2]&d[2]) ^  (a[2]&b[1])                                                     ;                 
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[5] ^ k[6]	^ r3[15] ^ r3[16];
			end
			if(num==16) begin 
				assign q_Sinv = (b[1]&a[2]&c[1]) ^ (b[1]&a[2]&d[0])                                                                          	;
				assign q_S = (b[1]&d[0]&c[1]) ^ (b[1]&a[2]&d[0])                                                                   ;                 
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[6] ^ k[7]	^ r3[16] ^ r3[17];
			end
			if(num==17) begin 
				assign q_Sinv = (b[1]&a[2]&c[2]) ^ (b[1]&a[2]&d[1]) 																		 	;	
				assign q_S = (b[1]&d[1]&c[2]) ^ (b[1]&a[2]&d[1])									^ (a[2]&d[1]) 					;		                 
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[7] 			^ r3[17] ^ r3[18];														 								
			end
						 								                                                                                            				    
			if(num==18) begin 
				assign q_Sinv = (b[2]&a[0]&c[0]) ^ (b[2]&a[0]&d[2]) ^  				(a[0]&b[2]) ^ (b[2]&c[0]) ^ (b[2]&d[2])                 ;
				assign q_S = (b[2]&d[2]&c[0]) ^ (b[2]&a[0]&d[2]) ^ (a[0]&b[2])   ^ (b[2]&d[2])		^ (a[0]&d[2]) ^ a[0]            ;                 
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[0] 		    ^ r3[18] ^ r3[19];
			end
			if(num==19) begin 
				assign q_Sinv = (b[2]&a[0]&c[1]) ^ (b[2]&a[0]&d[0])                             ^ (b[2]&c[1]) ^ (b[2]&d[0])                 	;
				assign q_S = (b[2]&d[0]&c[1]) ^ (b[2]&a[0]&d[0])                   ^ (b[2]&d[0])                                    ;                 
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[0] ^ k[1]	^ r3[19] ^ r3[20];
			end
			if(num==20) begin 
				assign q_Sinv = (b[2]&a[0]&c[2]) ^ (b[2]&a[0]&d[1])                             ^ (b[2]&c[2]) ^ (b[2]&d[1])                 	;
				assign q_S = (b[2]&d[1]&c[2]) ^ (b[2]&a[0]&d[1])                   ^ (b[2]&d[1])                                    ;                 
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[1] ^ k[2]	^ r3[20] ^ r3[21];
			end
			if(num==21) begin 
				assign q_Sinv = (b[2]&a[1]&c[0]) ^ (b[2]&a[1]&d[1]) ^               (a[1]&b[2])                                             	;
				assign q_S = (b[2]&d[1]&c[0]) ^ (b[2]&a[1]&d[1]) ^ (a[1]&b[2])                                                      ;                 
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[2] ^ k[3]	^ r3[21] ^ r3[22];
			end
			if(num==22) begin 
				assign q_Sinv = (b[2]&a[1]&c[2]) ^ (b[2]&a[1]&d[0])                                                                         	;
				assign q_S = (b[2]&d[0]&c[2]) ^ (b[2]&a[1]&d[0])                                                                    ;                 
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[3] ^ k[4]	^ r3[22] ^ r3[23];
			end
			if(num==23) begin 
				assign q_Sinv = (b[2]&a[1]&c[1]) ^ (b[2]&a[1]&d[2])                                                                         	;
				assign q_S = (b[2]&d[2]&c[1]) ^ (b[2]&a[1]&d[2])									^ (a[1]&d[2])                   ;                    
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[4] ^ k[5]	^ r3[23] ^ r3[24]  ;                                 
			end
			if(num==24) begin 
				assign q_Sinv = (b[2]&a[2]&c[1]) ^ (b[2]&a[2]&d[1]) ^ (a[2]&c[1]) ^ (a[2]&b[2])                                             	;
				assign q_S = (b[2]&d[1]&c[1]) ^ (b[2]&a[2]&d[1]) ^ (a[2]&b[2])                                                      ;                 
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[5] ^ k[6]	^ r3[24] ^ r3[25];
			end
			if(num==25) begin 
				assign q_Sinv = (b[2]&a[2]&c[0]) ^ (b[2]&a[2]&d[0]) ^ (a[2]&c[0])                                                           	;
				assign q_S = (b[2]&d[0]&c[0]) ^ (b[2]&a[2]&d[0]) ;                 
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[6] ^ k[7]	^ r3[25] ^ r3[26];
			end
			if(num==26) begin 
				assign q_Sinv = (b[2]&a[2]&c[2]) ^ (b[2]&a[2]&d[2]) ^ (a[2]&c[2]) ^ a[2] ^ c[2]                                             	;
				assign q_S = (b[2]&d[2]&c[2]) ^ (b[2]&a[2]&d[2]) ^									^ (a[2]&d[2]) ^ a[2] ^ d[2]     ;                     
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[7] 		    ^ r3[26] ^ r3[0] ;                            
			end
		end					
						
		else if (Co_f == 3) begin				
			if(num==0)  begin 
				assign q_Sinv = (c[0]&a[0]&b[0]) ^ (c[0]&a[0]&d[0]) ^ (c[0]&b[0]&d[0]) ^ (a[0]&b[0]) ^ 				(c[0]&b[0]) ^ 	(c[0]&d[0])	^ 1'b1 ^ a[0] ^ b[0] ^ d[0]    	;
				assign q_S = (a[0]&c[0]&b[0]) ^ (a[0]&c[0]&d[0]) ^ (a[0]&b[0]&d[0]) ^ (c[0]&b[0]) 	^ (c[0]&d[0]) ^ b[0] ^1'b1	;                     
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[0] 		  	^ r4[0] ^ r4[1];
			end
			if(num==1)  begin 
				assign q_Sinv = (c[0]&a[0]&b[1]) ^ (c[0]&a[0]&d[1]) ^ (c[0]&b[1]&d[1]) ^ (a[0]&b[1]) ^ 				(c[0]&b[1])	^	(c[0]&d[1])	 	   ^ b[1]                  	;
				assign q_S = (a[0]&c[0]&b[1]) ^ (a[0]&c[0]&d[1]) ^ (a[0]&b[1]&d[1]) ^ (c[0]&b[1]);                     
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[0] ^ k[1]	^ r4[1] ^ r4[2];
			end
			if(num==2)  begin 
				assign q_Sinv = (c[0]&a[0]&b[2]) ^ (c[0]&a[0]&d[2]) ^ (c[0]&b[2]&d[2]) ^ (a[0]&b[2]) ^ (c[0]&a[0]) ^ (c[0]&b[2])	^	(c[0]&d[2])	   ^ d[2] ^ b[2]           	;
				assign q_S = (a[0]&c[0]&b[2]) ^ (a[0]&c[0]&d[2]) ^ (a[0]&b[2]&d[2]) ^ (c[0]&b[2])                               ;                     
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[1] ^ k[2]	^ r4[2] ^ r4[3];
			end
			if(num==3)  begin 
				assign q_Sinv = (c[0]&a[1]&b[1]) ^ (c[0]&a[1]&d[0]) ^ (c[0]&b[1]&d[0]) ^ 			  (c[0]&a[1])							 		   ^ a[1]                  	^ k[2] ^ k[3]	^ r4[3] ^ r4[4];
				assign q_S = 0;                     
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ;
			end
			if(num==4)  begin 
				assign q_Sinv = (c[0]&a[1]&b[2]) ^ (c[0]&a[1]&d[1]) ^ (c[0]&b[2]&d[1])  													 					               	^ k[3] ^ k[4]	^ r4[4] ^ r4[5];                         
				assign q_S = 0;                     
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ;
			end
			if(num==5)  begin 
				assign q_Sinv = (c[0]&a[1]&b[0]) ^ (c[0]&a[1]&d[2]) ^ (c[0]&b[0]&d[2]) 														 						           	^ k[4] ^ k[5]	^ r4[5] ^ r4[6];                       
				assign q_S = 0;                     
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ;
			end
			if(num==6)  begin 
				assign q_Sinv = (c[0]&a[2]&b[0]) ^ (c[0]&a[2]&d[1]) ^ (c[0]&b[0]&d[1])  													 					               	^ k[5] ^ k[6]	^ r4[6] ^ r4[7];              
				assign q_S = 0;                     
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ;
			end
			if(num==7)  begin 
				assign q_Sinv = (c[0]&a[2]&b[1]) ^ (c[0]&a[2]&d[2]) ^ (c[0]&b[1]&d[2]) 														 		                           	^ k[6] ^ k[7]	^ r4[7] ^ r4[8];              
				assign q_S = 0;                     
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ;
			end
			if(num==8)  begin 
				assign q_Sinv = (c[0]&a[2]&b[2]) ^ (c[0]&a[2]&d[0]) ^ (c[0]&b[2]&d[0]) ^               (c[0]&a[2])	           			 									   	^ k[7] 			^ r4[8] ^ r4[9];																								
				assign q_S = 0;                     
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ;
			end
			if(num==9)  begin 
				assign q_Sinv = 0;
				assign q_S = (a[0]&c[1]&b[1]) ^ (a[0]&c[1]&d[0]) ^ (a[0]&b[1]&d[0]) 				^ (c[1]&d[0])               ^ k[2] ^ k[3]	^ r4[3] ^ r4[4];                     
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ;
			end
			if(num==10) begin 
				assign q_Sinv = 0;
				assign q_S = (a[0]&c[1]&b[2]) ^ (a[0]&c[1]&d[1]) ^ (a[0]&b[2]&d[1]) 			                                ^ k[3] ^ k[4]	^ r4[4] ^ r4[5];                     
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ;
			end
			if(num==11) begin 
				assign q_Sinv = 0;
				assign q_S = (a[0]&c[1]&b[0]) ^ (a[0]&c[1]&d[2]) ^ (a[0]&b[0]&d[2]) 			                                ^ k[4] ^ k[5]	^ r4[5] ^ r4[6];                     
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ;
			end
			if(num==12) begin 
				assign q_Sinv = 0;
				assign q_S = (a[0]&c[2]&b[0]) ^ (a[0]&c[2]&d[1]) ^ (a[0]&b[0]&d[1]) 			                                ^ k[5] ^ k[6]	^ r4[6] ^ r4[7];                     
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ;
			end
			if(num==13) begin 
				assign q_Sinv = 0;
				assign q_S = (a[0]&c[2]&b[1]) ^ (a[0]&c[2]&d[2]) ^ (a[0]&b[1]&d[2]) 			                                ^ k[6] ^ k[7]	^ r4[7] ^ r4[8];                     
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ;
			end
			if(num==14) begin 
				assign q_Sinv = 0;
				assign q_S = (a[0]&c[2]&b[2]) ^ (a[0]&c[2]&d[0]) ^ (a[0]&b[2]&d[0])					^ (c[2]&d[0])        		^ k[7] 			^ r4[8] ^ r4[9];										                     
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ;
			end
						 
			if(num==15) begin 
				assign q_Sinv = (c[1]&a[0]&b[2]) ^ (c[1]&a[0]&d[0]) ^ (c[1]&b[2]&d[0]) ^ (c[1]&d[0]) ^ k[0] 		  	^ r4[9]  ^ r4[10];
				assign q_S = 0; 
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ;
			end
			if(num==16) begin 
				assign q_Sinv = (c[1]&a[0]&b[0]) ^ (c[1]&a[0]&d[1]) ^ (c[1]&b[0]&d[1]) ^ 			 								(c[1]&d[1])	^ k[0] ^ k[1]	^ r4[10] ^ r4[11]                               	;
				assign q_S = 0;
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ;
			end
			if(num==17) begin 
				assign q_Sinv = (c[1]&a[0]&b[1]) ^ (c[1]&a[0]&d[2]) ^ (c[1]&b[1]&d[2]) ^ (c[1]&a[0]) ^ (c[1]&d[2]) ^ a[0] ^ d[2] ^ k[1] ^ k[2]^ r4[11] ^ r4[12];
				assign q_S = 0;
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX 	;
			end
			if(num==18) begin 
				assign q_Sinv = (c[1]&a[1]&b[2]) ^ (c[1]&a[1]&d[2]) ^ (c[1]&b[2]&d[2]) ^ (a[1]&b[2]) ^ (c[1]&a[1]) ^ (c[1]&b[2])			 	                               	;
				assign q_S = (a[1]&c[1]&b[2]) ^ (a[1]&c[1]&d[2]) ^ (a[1]&b[2]&d[2]) ^ (c[1]&b[2]);                     
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[2] ^ k[3]	^ r4[12] ^ r4[13];
			end
			if(num==19) begin 
				assign q_Sinv = (c[1]&a[1]&b[0]) ^ (c[1]&a[1]&d[0]) ^ (c[1]&b[0]&d[0]) ^ (a[1]&b[0])   			  ^ (c[1]&b[0])			 	 		                           	;
				assign q_S = (a[1]&c[1]&b[0]) ^ (a[1]&c[1]&d[0]) ^ (a[1]&b[0]&d[0]) ^ (c[1]&b[0]);                     
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[3] ^ k[4]	^ r4[13] ^ r4[14];
			end
			if(num==20) begin 
				assign q_Sinv = (c[1]&a[1]&b[1]) ^ (c[1]&a[1]&d[1]) ^ (c[1]&b[1]&d[1]) ^ (a[1]&b[1])				  ^ (c[1]&b[1])	^ b[1] ^ b[1]                              	;
				assign q_S = (a[1]&c[1]&b[1]) ^ (a[1]&c[1]&d[1]) ^ (a[1]&b[1]&d[1]) ^ (c[1]&b[1])	^ (c[1]&d[1]) ^ b[1] ^ d[1];                     
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[4] ^ k[5]	^ r4[14] ^ r4[15];
			end
			if(num==21) begin 
				assign q_Sinv = (c[1]&a[2]&b[0]) ^ (c[1]&a[2]&d[2]) ^ (c[1]&b[0]&d[2])  			 										 	                               	^ k[5] ^ k[6]	^ r4[15] ^ r4[16];
				assign q_S = 0;                     
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ;
			end
			if(num==22) begin 
				assign q_Sinv = (c[1]&a[2]&b[1]) ^ (c[1]&a[2]&d[0]) ^ (c[1]&b[1]&d[0])  			  										 	                               	^ k[6] ^ k[7]	^ r4[16] ^ r4[17];
				assign q_S = 0;                     
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ;
			end
			if(num==23) begin 
				assign q_Sinv = (c[1]&a[2]&b[2]) ^ (c[1]&a[2]&d[1]) ^ (c[1]&b[2]&d[1]) ^ 			  (c[1]&a[2])							 								   	^ k[7] 			^ r4[17] ^ r4[18];																								
				assign q_S = 0;                     
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ;
			end
			if(num==24) begin 
				assign q_Sinv = 0;
				assign q_S = (a[1]&c[0]&b[2]) ^ (a[1]&c[0]&d[0]) ^ (a[1]&b[2]&d[0])								                ^ k[0] 		  	^ r4[9]  ^ r4[10];
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ;
			end
			if(num==25) begin 
				assign q_Sinv = 0;
				assign q_S = (a[1]&c[0]&b[0]) ^ (a[1]&c[0]&d[1]) ^ (a[1]&b[0]&d[1])					^ (c[0]&d[1]) 			    ^ k[0] ^ k[1]	^ r4[10] ^ r4[11];
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ;
			end
			if(num==26) begin 
				assign q_Sinv = 0;
				assign q_S = (a[1]&c[0]&b[1]) ^ (a[1]&c[0]&d[2]) ^ (a[1]&b[1]&d[2]) 			                                ^ k[1] ^ k[2]	^ r4[11] ^ r4[12];
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ;
			end
			if(num==27) begin 
				assign q_Sinv = 0;
				assign q_S = (a[1]&c[2]&b[0]) ^ (a[1]&c[2]&d[2]) ^ (a[1]&b[0]&d[2]) 			                                ^ k[5] ^ k[6]	^ r4[15] ^ r4[16];
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ;
			end
			if(num==28) begin 
				assign q_Sinv = 0;
				assign q_S = (a[1]&c[2]&b[1]) ^ (a[1]&c[2]&d[0]) ^ (a[1]&b[1]&d[0]) 			                                ^ k[6] ^ k[7]	^ r4[16] ^ r4[17];
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ;
			end
			if(num==29) begin 
				assign q_Sinv = 0;	
				assign q_S = (a[1]&c[2]&b[2]) ^ (a[1]&c[2]&d[1]) ^ (a[1]&b[2]&d[1])					^ (c[2]&d[1])  				^ k[7] 			^ r4[17] ^ r4[18];
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ;
			end
						 
			if(num==30) begin 
				assign q_Sinv = (c[2]&a[0]&b[0]) ^ (c[2]&a[0]&d[2]) ^ (c[2]&b[0]&d[2]) ^ 			  								(c[2]&d[2])	                              	^ k[0] 		  	^ r4[18] ^ r4[19];
				assign q_S = 0;
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ;
			end
			if(num==31) begin 
				assign q_Sinv = (c[2]&a[0]&b[1]) ^ (c[2]&a[0]&d[0]) ^ (c[2]&b[1]&d[0]) ^       	      				      	   		(c[2]&d[0])	^ a[0] ^ d[0]	              	^ k[0] ^ k[1]	^ r4[19] ^ r4[20];	
				assign q_S = 0;
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ;
			end
			if(num==32) begin 
				assign q_Sinv = (c[2]&a[0]&b[2]) ^ (c[2]&a[0]&d[1]) ^ (c[2]&b[2]&d[1]) ^ 			  (c[2]&a[0])				^	(c[2]&d[1])	                              	^ k[1] ^ k[2]	^ r4[20] ^ r4[21];
				assign q_S = 0;
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ;
			end
			if(num==33) begin 
				assign q_Sinv = (c[2]&a[1]&b[0]) ^ (c[2]&a[1]&d[1]) ^ (c[2]&b[0]&d[1]) ^ 			  (c[2]&a[1])							 	                              	^ k[2] ^ k[3]	^ r4[21] ^ r4[22];
				assign q_S = 0;                     
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ;
			end
			if(num==34) begin 
				assign q_S = 0;
				assign q_Sinv = (c[2]&a[1]&b[2]) ^ (c[2]&a[1]&d[0]) ^ (c[2]&b[2]&d[0]) 														 		                          	^ k[3] ^ k[4]	^ r4[22] ^ r4[23];                          
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ;
			end
			if(num==35) begin 
				assign q_S = 0;
				assign q_Sinv = (c[2]&a[1]&b[1]) ^ (c[2]&a[1]&d[2]) ^ (c[2]&b[1]&d[2])                				           			 	 	                              	^ k[4] ^ k[5]	^ r4[23] ^ r4[24];                     
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ;
			end
			if(num==36) begin 
				assign q_S = (a[2]&c[2]&b[1]) ^ (a[2]&c[2]&d[1]) ^ (a[2]&b[1]&d[1]) ^ (c[2]&b[1])                               ;
				assign q_Sinv = (c[2]&a[2]&b[1]) ^ (c[2]&a[2]&d[1]) ^ (c[2]&b[1]&d[1]) ^ (a[2]&b[1])  			  ^ (c[2]&b[1])			 	 	                              	;                     
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[5] ^ k[6]	^ r4[24] ^ r4[25];
			end
			if(num==37) begin 
				assign q_S = (a[2]&c[2]&b[0]) ^ (a[2]&c[2]&d[0]) ^ (a[2]&b[0]&d[0]) ^ (c[2]&b[0])                               ;
				assign q_Sinv = (c[2]&a[2]&b[0]) ^ (c[2]&a[2]&d[0]) ^ (c[2]&b[0]&d[0]) ^ (a[2]&b[0])   			  ^ (c[2]&b[0])			 	 	                              	;                     
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[6] ^ k[7]	^ r4[25] ^ r4[26];
			end
			if(num==38) begin 
				assign q_S = (a[2]&c[2]&b[2]) ^ (a[2]&c[2]&d[2]) ^ (a[2]&b[2]&d[2]) ^ (c[2]&b[2])	^ (c[2]&d[2]) ^ b[2] ^ d[2] ;
				assign q_Sinv = (c[2]&a[2]&b[2]) ^ (c[2]&a[2]&d[2]) ^ (c[2]&b[2]&d[2]) ^ (a[2]&b[2]) ^ (c[2]&a[2]) ^ (c[2]&b[2]) ^ a[2]					                      	;                     
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ^ k[7] 		  	^ r4[26] ^ r4[0] ;
			end
			if(num==39) begin 
				assign q_Sinv = 0;
				assign q_S = (a[2]&c[1]&b[0]) ^ (a[2]&c[1]&d[1]) ^ (a[2]&b[0]&d[1]) 			                                ^ k[2] ^ k[3]	^ r4[21] ^ r4[22];                     
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ;
			end
			if(num==40) begin 
				assign q_Sinv = 0;
				assign q_S = (a[2]&c[1]&b[2]) ^ (a[2]&c[1]&d[0]) ^ (a[2]&b[2]&d[0]) 			                                ^ k[3] ^ k[4]	^ r4[22] ^ r4[23];                     
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ;
			end
			if(num==41) begin 
				assign q_Sinv = 0;
				assign q_S = (a[2]&c[1]&b[1]) ^ (a[2]&c[1]&d[2]) ^ (a[2]&b[1]&d[2])					^ (c[1]&d[2])        		^ k[4] ^ k[5]	^ r4[23] ^ r4[24];                     
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ;
			end
			if(num==42) begin 
				assign q_Sinv = 0;
				assign q_S = (a[2]&c[0]&b[0]) ^ (a[2]&c[0]&d[2]) ^ (a[2]&b[0]&d[2])					^ (c[0]&d[2])  			    ^ k[0] 		  	^ r4[18] ^ r4[19];                    
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ;
			end
			if(num==43) begin 
				assign q_Sinv = 0;
				assign q_S = (a[2]&c[0]&b[1]) ^ (a[2]&c[0]&d[0]) ^ (a[2]&b[1]&d[0]) ^ d[0]       	                            ^ k[0] ^ k[1]	^ r4[19] ^ r4[20];                    
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ;
			end
			if(num==44) begin 
				assign q_Sinv = 0;
				assign q_S = (a[2]&c[0]&b[2]) ^ (a[2]&c[0]&d[1]) ^ (a[2]&b[2]&d[1]) 			  	                            ^ k[1] ^ k[2]	^ r4[20] ^ r4[21];                     
				assign MUX 		= sel ? q_Sinv : q_S;
				assign q   		= MUX ;
			end
		end	
	endgenerate
	

	
	//assign q = q_S;
endmodule
