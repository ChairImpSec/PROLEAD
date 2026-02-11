
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
    input [95:0] r,
    output [95:0] r_8,
    output [95:0] r_16,
    output [95:0] r_24,
    output [95:0] r_32 );
	 
	 
	 assign r_8  = {r[7 :0], r[95:8 ]};
	 assign r_16 = {r[15:0], r[95:16]};
	 assign r_24 = {r[23:0], r[95:24]};
	 assign r_32 = {r[31:0], r[95:32]};


endmodule
