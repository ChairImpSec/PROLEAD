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


module MyRotation(
    input  [143:0] r,
    output [143:0] r1,
    output [143:0] r2,
    output [143:0] r3,
    output [143:0] r4,
    output [143:0] r5,
    output [143:0] r6,
    output [143:0] r7 );
	 
	 
	 assign r1  = {r [8 :0], r [143:9]};
	 assign r2  = {r1[8 :0], r1[143:9]};
	 assign r3  = {r2[8 :0], r2[143:9]};
	 assign r4  = {r3[8 :0], r3[143:9]};
	 assign r5  = {r4[8 :0], r4[143:9]};
	 assign r6  = {r5[8 :0], r5[143:9]};
	 assign r7  = {r6[8 :0], r6[143:9]};



endmodule
