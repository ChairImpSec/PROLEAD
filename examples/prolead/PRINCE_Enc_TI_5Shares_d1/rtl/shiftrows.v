`timescale 1ns / 1ps
/*
* -----------------------------------------------------------------
* AUTHOR  : Nicolai Müller (nicolai.mueller@rub.de)
* DOCUMENT: "Low-Latency Hardware Masking of PRINCE" (COSADE 2021)
* -----------------------------------------------------------------
*
* Copyright (c) 2021, Nicolai Müller
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

module shiftrows(
    input [63:0] in,
    output [63:0] out
    );
    
    assign out[3:0] = in[19:16];
    assign out[7:4] = in[39:36];
    assign out[11:8] = in[59:56];
    assign out[15:12] = in[15:12];
    
    assign out[19:16] = in[35:32];
    assign out[23:20] = in[55:52];
    assign out[27:24] = in[11:8];
    assign out[31:28] = in[31:28];
    
    assign out[35:32] = in[51:48];
    assign out[39:36] = in[7:4];
    assign out[43:40] = in[27:24];
    assign out[47:44] = in[47:44];
    
    assign out[51:48] = in[3:0];
    assign out[55:52] = in[23:20];
    assign out[59:56] = in[43:40];
    assign out[63:60] = in[63:60];

endmodule
