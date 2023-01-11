/*
* -----------------------------------------------------------------
* AUTHOR  : Sara Zarei (sarazareei.94@gmail.com), Aein Rezaei Shahmirzadi (aein.rezaeishahmirzadi@rub.de), Amir Moradi (amir.moradi@rub.de)
* DOCUMENT: "Low-Latency Keccak at any Arbitrary Order" (TCHES 2021, Issue 4)
* -----------------------------------------------------------------
*
* Copyright (c) 2021, Sara Zarei, Aein Rezaei Shahmirzadi, Amir Moradi
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


module compression
  #(parameter SHARES = 2
  , parameter W = 8
  )
  ( input  wire[(SHARES**2)*25*W-1:0] sharesPOW2
  , output  [SHARES*25*W-1:0] sharesOrig
  );


    wire [(SHARES)**2-1:0] bitshare [(25*W)-1:0];
	
	
    genvar i, j, k, m;
	
    for (i=0; i < 25*W; i=i+1) begin: Loop_w
		for (j=0; j <SHARES ; j=j+1) begin: Loop_shares1
			for (k=0; k <SHARES ; k=k+1) begin: Loop_shares2
				if ((i < 15*W) || (i >= 20*W))
					assign bitshare[i][j*SHARES+k] = sharesPOW2[i+(j*SHARES+k)*25*W];
				else
					assign bitshare[i][j*SHARES+k] = sharesPOW2[i+(j+k*SHARES)*25*W];
			end
		end		
	end
	

   generate
	
		//Compression
		for (k=0; k < 25*W; k=k+1) begin: BITS
			for (m=0; m < SHARES; m=m+1) begin: BIT_SHARES
				XOR_n #(.WIDTH(SHARES)) Copression  ( .x(bitshare[k][(SHARES)*(m+1)-1 : m*(SHARES)]), .q(sharesOrig[k+m*25*W]) );
			end
		end
   endgenerate

endmodule