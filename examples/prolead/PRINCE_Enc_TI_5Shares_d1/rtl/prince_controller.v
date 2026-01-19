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

module prince_controller(
    input clk,
    input rst,
    input en,
    input enc,
    input [63:0] k,
    output [63:0] rc,
    output target_en,
    output target_start,
    output target_inv,
    output target_done
    );
    
    localparam ROUNDSTOP = 4'd13;
    
    wire [3:0] ctr, rc_ctr;
    reg [4:0] counter;
    reg [63:0] constant;
    
    always @ (posedge clk)
    begin
        if (rst == 1) begin
            counter <= 0;
        end
        else if (en == 1 && counter < ROUNDSTOP) begin
            counter <= counter + 1;
        end
    end
    
    assign rc_ctr = (enc == 1'b1) ? counter : ~counter;
    assign ctr = counter;
    
    always @ (rc_ctr)
    begin
        case(rc_ctr)
            4'b0010: constant = 64'h0000000000000000;
            4'b0011: constant = 64'h13198a2e03707344;
            4'b0100: constant = 64'ha4093822299f31d0;
            4'b0101: constant = 64'h082efa98ec4e6c89;
            4'b0110: constant = 64'h452821e638d01377;
            4'b0111: constant = 64'hbe5466cf34e90c6c; 
            4'b1000: constant = 64'h7ef84f78fd955cb1;
            4'b1001: constant = 64'h85840851f1ac43aa;
            4'b1010: constant = 64'hc882d32f25323c54;
            4'b1011: constant = 64'h64a51195e0e3610d;
            4'b1100: constant = 64'hd3b5a399ca0c2399;
            4'b1101: constant = 64'hc0ac29b7c97c50dd;
            default: constant = 0;
        endcase
    end
    
    // assign current round constant
    assign rc = constant ^ k;
    
    assign target_done = (ctr == ROUNDSTOP/* && rst == 1'b0*/) ? 1 : 0;
    assign target_en = en & ~target_done;
    assign target_start = (ctr == 1'b1 && en == 1) ? 1 : 0;
    assign target_inv = (ctr < 4'b1000) ? 1 : 0;
endmodule
