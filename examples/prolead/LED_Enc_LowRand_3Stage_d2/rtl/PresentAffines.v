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

module PresentAffines(
    input [3:0] x1,
    input [3:0] x2,
    input [3:0] x3,
    output [3:0] y1,
    output [3:0] y2,
    output [3:0] y3
    );

	parameter num = 1;

	
	generate
		//input affine
		if(num == 1) begin
			assign y1 = {x1[1] ~^ x1[2],x1[1],x1[3],x1[0]};
			assign y2 = {x2[1] ^ x2[2],x2[1],x2[3],x2[0]};
			assign y3 = {x3[1] ^ x3[2],x3[1],x3[3],x3[0]};
		end
		//output affine
		if(num == 2) begin
			assign y1 = {x1[1],x1[2] ^ x1[3],x1[0],x1[2]};
			assign y2 = {x2[1],x2[2] ^ x2[3],x2[0],x2[2]};
			assign y3 = {~x3[1],x3[2] ^ x3[3],x3[0],x3[2]};
		end
		//middle affine
		if(num == 3) begin
			assign y1 = {1'b1 ^ x1[0] ^ x1[2],x1[0],x1[1],x1[1] ^ x1[3]};
			assign y2 = {x2[0] ^ x2[2],x2[0],x2[1],x2[1] ^ x2[3]};
			assign y3 = {x3[0] ^ x3[2],x3[0],x3[1],x3[1] ^ x3[3]};
		end
   endgenerate

endmodule
