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


module keccak_chi_iota #(
        parameter SHARES = 2,
        parameter W = 8
    )(
        input wire[SHARES*25*W-1:0] In,
        input wire[W-1:0] IotaRCI,
		input wire [((SHARES * SHARES)- SHARES)/2 * (25 * W) - 1:0] FreshRand,
        output reg[(SHARES**2)*25*W-1:0] Out
    );

localparam FreshSize = (SHARES*SHARES - SHARES)/2;
reg[(SHARES**2)*25*W-1:0] ChiOut;


generate

  genvar y, z;


  function integer RowIdx(input integer share_nr, input integer idx_x, input integer idx_y);
      RowIdx = share_nr*25*W + (5*idx_x + idx_y)*W;
  endfunction

  for(z = 0; z < W; z=z+1) begin : GEN_SLICES
    for (y = 0; y < 5; y=y+1) begin : GEN_ROWS
      reg[SHARES*5-1 : 0] RowsInxD;
      wire[(SHARES**2)*5-1 : 0] RowsOutxD;
      reg[5*(SHARES*SHARES-SHARES)/2-1 : 0] RowsRand;


      always @(*) begin : ROW_SEL_IN
        integer i,x;
        for (x = 0; x < 5 ; x=x+1) begin          
         for (i = 0; i < SHARES; i=i+1) begin
          RowsInxD[(SHARES*x)+i] = In[RowIdx(i,x,y) + z];
		 end
        end
        RowsRand = FreshRand[(5*z + y)*5*FreshSize +: 5*FreshSize];
      end

      always @(*) begin : ROW_SEL_OUT
        integer t,x;
		for (x = 0; x < 5 ; x=x+1) begin  
         for (t = 0; t < SHARES**2; t=t+1) begin
          ChiOut[RowIdx(t,x,y) + z] = RowsOutxD[((SHARES**2)*x)+t];
         end
		end

      end
	  
        keccak_sbox
          #(.d(SHARES-1)
          ) sbox
          ( 

			.aa(RowsInxD[SHARES*0 +:SHARES]),
			.bb(RowsInxD[SHARES*1 +:SHARES]),
			.cc(RowsInxD[SHARES*2 +:SHARES]),
			.dd(RowsInxD[SHARES*3 +:SHARES]),
			.ee(RowsInxD[SHARES*4 +:SHARES]),
			.r(RowsRand),
			.ap(RowsOutxD[(SHARES**2)*0 +:SHARES**2]),
			.bp(RowsOutxD[(SHARES**2)*1 +:SHARES**2]),
			.cp(RowsOutxD[(SHARES**2)*2 +:SHARES**2]),
			.dp(RowsOutxD[(SHARES**2)*3 +:SHARES**2]),
			.ep(RowsOutxD[(SHARES**2)*4 +:SHARES**2]) );
		  

    end
  end

endgenerate

always@(*) begin
Out = ChiOut ^ IotaRCI;
end

endmodule
