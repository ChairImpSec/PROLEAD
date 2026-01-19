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

module prince(
    input clk,
    input rst, // reset 
    input en, // enable
    input enc, // enc = 1, dec = 0
    input [63:0] p0, // 64-bit plaintext share
    input [63:0] p1, // 64-bit plaintext share
    input [63:0] p2, // 64-bit plaintext share
    input [63:0] p3, // 64-bit plaintext share
    input [63:0] p4, // 64-bit plaintext share
    input [127:0] k, // 128-bit key
    output [63:0] c0, // 64-bit ciphertext share
    output [63:0] c1, // 64-bit ciphertext share
    output [63:0] c2, // 64-bit ciphertext share
    output [63:0] c3, // 64-bit ciphertext share
    output [63:0] c4, // 64-bit ciphertext share
    output done
    );
    
    wire done_sig, en_sig, start_sig, inv_sig;
    wire [63:0] key, endkey;
    wire [63:0] rc, final_v_k;
    wire [191:0] kext; // extended 192-bit key
    
    wire [63:0] final_v, final_w, final_x, final_y, final_z;
    wire [63:0] kout_v, kout_w, kout_x, kout_y, kout_z;
    wire [63:0] init_v, init_w, init_x, init_y, init_z;
    wire [63:0] rin_v, rin_w, rin_x, rin_y, rin_z;
    wire [63:0] rout_v, rout_w, rout_x, rout_y, rout_z;
    wire [63:0] state_v, state_w, state_x, state_y, state_z;

    // extend key to 192 bits   
    keyextend k_inst(.in(k), .out(kext));
    assign key = (enc == 1'b1) ? kext[63:0] : kext[127:64];
    assign endkey = (enc == 1'b1) ? kext[127:64] : kext[63:0]; 
    
    // initialize state
    assign kout_v = p0 ^ key;
    assign kout_w = p1;
    assign kout_x = p2;
    assign kout_y = p3;
    assign kout_z = p4;
    
    // initial inverse shift rows
    invshiftrows invsrv_init(.in(kout_v), .out(init_v));
    invshiftrows invsrw_init(.in(kout_w), .out(init_w));
    invshiftrows invsrx_init(.in(kout_x), .out(init_x));
    invshiftrows invsry_init(.in(kout_y), .out(init_y));
    invshiftrows invsrz_init(.in(kout_z), .out(init_z));
    
    muxer mux_v(.sel(start_sig), .t(init_v), .f(rout_v), .res(state_v));
    muxer mux_w(.sel(start_sig), .t(init_w), .f(rout_w), .res(state_w));
    muxer mux_x(.sel(start_sig), .t(init_x), .f(rout_x), .res(state_x));
    muxer mux_y(.sel(start_sig), .t(init_y), .f(rout_y), .res(state_y));
    muxer mux_z(.sel(start_sig), .t(init_z), .f(rout_z), .res(state_z));
    
    // register stage 
    register_stage reg_v(.clk(clk), .rst(rst), .en(en_sig), .D(state_v), .Q(rin_v));
    register_stage reg_w(.clk(clk), .rst(rst), .en(en_sig), .D(state_w), .Q(rin_w));
    register_stage reg_x(.clk(clk), .rst(rst), .en(en_sig), .D(state_x), .Q(rin_x));
    register_stage reg_y(.clk(clk), .rst(rst), .en(en_sig), .D(state_y), .Q(rin_y));
    register_stage reg_z(.clk(clk), .rst(rst), .en(en_sig), .D(state_z), .Q(rin_z));
    
    wire [3:0] ctr;
    
    prince_controller cntrl_inst(.clk(clk), .rst(rst), .en(en), .enc(enc), .k(kext[191:128]), .rc(rc), .target_en(en_sig), .target_start(start_sig), .target_inv(inv_sig), .target_done(done_sig));
    prince_round round_inst(.iv(rin_v), .iw(rin_w), .ix(rin_x), .iy(rin_y), .iz(rin_z), .rc(rc), .inv(inv_sig), .ov(rout_v), .ow(rout_w), .ox(rout_x), .oy(rout_y), .oz(rout_z), .o_half_v(final_v), .o_half_w(final_w), .o_half_x(final_x), .o_half_y(final_y), .o_half_z(final_z));

    assign done = done_sig;
    assign final_v_k = endkey ^ final_v;
    
    muxer mux_c0(.sel(done_sig), .t(final_v_k), .f(64'h0000000000000000), .res(c0));
    muxer mux_c1(.sel(done_sig), .t(final_w), .f(64'h0000000000000000), .res(c1));
    muxer mux_c2(.sel(done_sig), .t(final_x), .f(64'h0000000000000000), .res(c2));
    muxer mux_c3(.sel(done_sig), .t(final_y), .f(64'h0000000000000000), .res(c3));
    muxer mux_c4(.sel(done_sig), .t(final_z), .f(64'h0000000000000000), .res(c4));
endmodule

