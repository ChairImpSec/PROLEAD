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

module prince_round(
    input [63:0] iw,
    input [63:0] ix,
    input [63:0] iy,
    input [63:0] iz,
    input [63:0] rc,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input  inv,
    output [63:0] ow,
    output [63:0] ox,
    output [63:0] oy,
    output [63:0] oz,
    output [3:0] o_b,
    output [3:0] o_c,
    output [3:0] o_d,
    output [63:0] o_half_w,
    output [63:0] o_half_x,
    output [63:0] o_half_y,
    output [63:0] o_half_z
    );
    
    wire [63:0] sin_w, sin_x, sin_y, sin_z;
    wire [63:0] xin_w, xin_x, xin_y, xin_z;
    wire [63:0] min_w, min_x, min_y, min_z;
    wire [63:0] srin_w, srin_x, srin_y, srin_z;

    wire [63:0] mout_w, mout_x, mout_y, mout_z;
    wire [63:0] srout_w, srout_x, srout_y, srout_z;
    wire [63:0] srout2_w, srout2_x, srout2_y, srout2_z;
    wire [63:0] xout_w, xout_x, xout_y, xout_z;
    wire [63:0] aout_w, aout_x, aout_y, aout_z;
    wire [63:0] sout_w, sout_x, sout_y, sout_z;
    
    // shift rows layer
    shiftrows srw_inst(.in(iw), .out(srout_w));
    shiftrows srx_inst(.in(ix), .out(srout_x));
    shiftrows sry_inst(.in(iy), .out(srout_y));
    shiftrows srz_inst(.in(iz), .out(srout_z));
    
    // xor layer
    assign xout_w = srout_w ^ rc;
    assign xout_x = srout_x;
    assign xout_y = srout_y;
    assign xout_z = srout_z;
   
    
    // affine layer
    genvar j;
    generate 
        for (j = 0; j < 16; j = j + 1) begin:A
            abox_with_neg aw(.x(iw[(4*j)+3:(4*j)]), .z(aout_w[(4*j)+3:(4*j)]));
            abox ax(.x(ix[(4*j)+3:(4*j)]), .z(aout_x[(4*j)+3:(4*j)]));
            abox ay(.x(iy[(4*j)+3:(4*j)]), .z(aout_y[(4*j)+3:(4*j)]));
            abox az(.x(iz[(4*j)+3:(4*j)]), .z(aout_z[(4*j)+3:(4*j)]));
        end
    endgenerate

    muxer mux_inv_w(.sel(inv), .t(xout_w), .f(aout_w), .res(sin_w));
    muxer mux_inv_x(.sel(inv), .t(xout_x), .f(aout_x), .res(sin_x));
    muxer mux_inv_y(.sel(inv), .t(xout_y), .f(aout_y), .res(sin_y));
    muxer mux_inv_z(.sel(inv), .t(xout_z), .f(aout_z), .res(sin_z));
    
    // substitution layer;
    masked_sbox sbox_inst0(.w(sin_w[3:0]), .x(sin_x[3:0]), .y(sin_y[3:0]), .z(sin_z[3:0]), .b(b), .c(c), .d(d), .z_w(sout_w[3:0]), .z_x(sout_x[3:0]), .z_y(sout_y[3:0]), .z_z(sout_z[3:0]));

    genvar i;
    generate 
        for (i = 1; i < 16; i = i + 1) begin:S
            masked_sbox sbox_inst(.w(sin_w[(4*i)+3:(4*i)]), .x(sin_x[(4*i)+3:(4*i)]), .y(sin_y[(4*i)+3:(4*i)]), .z(sin_z[(4*i)+3:(4*i)]), .b(sin_x[(4*(i-1))+3:(4*(i-1))]), .c(sin_y[(4*(i-1))+3:(4*(i-1))]), .d(sin_z[(4*(i-1))+3:(4*(i-1))]), .z_w(sout_w[(4*i)+3:(4*i)]), .z_x(sout_x[(4*i)+3:(4*i)]), .z_y(sout_y[(4*i)+3:(4*i)]), .z_z(sout_z[(4*i)+3:(4*i)]));
        end
    endgenerate
    
    assign o_b = sin_x[63:60];
    assign o_c = sin_y[63:60];
    assign o_d = sin_z[63:60];
    
    // affine layer
    genvar l;
    generate 
        for (l = 0; l < 16; l = l + 1) begin:A2
            abox_with_neg aw2(.x(sout_w[(4*l)+3:(4*l)]), .z(xin_w[(4*l)+3:(4*l)]));
            abox ax2(.x(sout_x[(4*l)+3:(4*l)]), .z(xin_x[(4*l)+3:(4*l)]));
            abox ay2(.x(sout_y[(4*l)+3:(4*l)]), .z(xin_y[(4*l)+3:(4*l)]));
            abox az2(.x(sout_z[(4*l)+3:(4*l)]), .z(xin_z[(4*l)+3:(4*l)]));
        end
    endgenerate
    
    // xor layer
    assign srin_w = xin_w ^ rc; 
    assign srin_x = xin_x;
    assign srin_y = xin_y;
    assign srin_z = xin_z;
    
    assign o_half_w = srin_w;
    assign o_half_x = srin_x;
    assign o_half_y = srin_y;
    assign o_half_z = srin_z;
    
    // inverse shift rows layer
    invshiftrows invsrw_inst(.in(srin_w), .out(srout2_w));
    invshiftrows invsrx_inst(.in(srin_x), .out(srout2_x));
    invshiftrows invsry_inst(.in(srin_y), .out(srout2_y));
    invshiftrows invsrz_inst(.in(srin_z), .out(srout2_z));
    
    muxer mux_inv_w2(.sel(inv), .t(sout_w), .f(srout2_w), .res(min_w));
    muxer mux_inv_x2(.sel(inv), .t(sout_x), .f(srout2_x), .res(min_x));
    muxer mux_inv_y2(.sel(inv), .t(sout_y), .f(srout2_y), .res(min_y));
    muxer mux_inv_z2(.sel(inv), .t(sout_z), .f(srout2_z), .res(min_z));
    
    // mprime layer
    mprime mw_inst(.in(min_w), .out(ow));
    mprime mx_inst(.in(min_x), .out(ox));
    mprime my_inst(.in(min_y), .out(oy));
    mprime mz_inst(.in(min_z), .out(oz));
endmodule
