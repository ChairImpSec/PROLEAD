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


module keccak_sbox
  #(parameter integer d = 1) /* security order */
   
   (input  [d:0] aa,
    input  [d:0] bb,
    input  [d:0] cc,
    input  [d:0] dd,
    input  [d:0] ee,
    input  [5*d*(d+1)/2-1:0] r,
    output [(d+1)**2-1:0] ap,
    output [(d+1)**2-1:0] bp,
    output [(d+1)**2-1:0] cp,
    output [(d+1)**2-1:0] dp,
    output [(d+1)**2-1:0] ep);

    wire [(d+1)**2-1:0] fm [4:0];
    
    genvar i, j, k;

    /***************************/
    
    for (i=0; i <= d; i=i+1)
    begin : FreshMaskGenerate1
        for (j=0; j <= d; j=j+1)    
        begin : FreshMaskGenerate2
            for (k=0; k < 5; k=k+1)    
            begin : FreshMaskGenerate3
                if (i == j)    
                    assign fm[k][i*(d+1) + j] = 1'b0;    
                else if (i < j)    
                    assign fm[k][i*(d+1) + j] = r[k*d*(d+1)/2 + i + j*(j-1)/2];    
                else if (i > j)    
                    assign fm[k][i*(d+1) + j] = r[k*d*(d+1)/2 + j + i*(i-1)/2];    
            end            
        end    
     end    
    
    /***************************/
    
    for (i=0; i <= d; i=i+1)
    begin : ComponentFunctionGen1
        for (j=0; j <= d; j=j+1)    
        begin : ComponentFunctionGen1
            AND_XOR #(i == 0, j == 0)               and_xor_inst_a (.x(bb[i]),             .y(cc[j]),             .z(aa[(i+j) % (d+1)]), .r(fm[0][i*(d+1) + j]),               .q(ap[i*(d+1) + j]));
            AND_XOR #(j == 0, j == 0)               and_xor_inst_b (.x(cc[j]),             .y(dd[i]),             .z(bb[i]),             .r(fm[1][i*(d+1) + j]),               .q(bp[i*(d+1) + j]));
            AND_XOR #(i == 0, i == 0)               and_xor_inst_c (.x(dd[i]),             .y(ee[j]),             .z(cc[j]),             .r(fm[2][i*(d+1) + j]),               .q(cp[i*(d+1) + j]));

            AND_XOR #(j == 0, j == 0)               and_xor_inst_d (.x(ee[j]),             .y(aa[(i+j) % (d+1)]), .z(dd[i]),             .r(fm[3][j*(d+1) + ((i+j) % (d+1))]), .q(dp[i*(d+1) + j]));
            AND_XOR #(((i+j) % (d+1)) == 0, i == 0) and_xor_inst_e (.x(aa[(i+j) % (d+1)]), .y(bb[i]),             .z(ee[j]),             .r(fm[4][i*(d+1) + ((i+j) % (d+1))]), .q(ep[i*(d+1) + j]));
        end
    end

endmodule
















































