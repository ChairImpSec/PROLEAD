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
    input [3:0] b_guard, // guard 1
    input [3:0] c_guard, // guard 2
    input [3:0] d_guard, // guard 3
    input [127:0] k, // 128-bit key
    output [63:0] c0, // 64-bit ciphertext share
    output [63:0] c1, // 64-bit ciphertext share
    output [63:0] c2, // 64-bit ciphertext share
    output [63:0] c3, // 64-bit ciphertext share
    output done
    );
    
    wire done_sig, en_sig, start_sig, inv_sig;
    wire [63:0] key, endkey;
    wire [63:0] rc, final_w_k;
    wire [191:0] kext; // extended 192-bit key
    
    wire [63:0] final_w, final_x, final_y, final_z;
    wire [63:0] kout_w, kout_x, kout_y, kout_z;
    wire [63:0] init_w, init_x, init_y, init_z;
    wire [63:0] rin_w, rin_x, rin_y, rin_z;
    wire [63:0] pin_w, pin_x, pin_y, pin_z;
    wire [63:0] rout_w, rout_x, rout_y, rout_z;
    wire [63:0] state_w, state_x, state_y, state_z;
    wire [3:0] bout, cout, dout; 
    wire [3:0] bin, cin, din;  
    wire [3:0] state_b, state_c, state_d;   

    // extend key to 192 bits   
    keyextend k_inst(.in(k), .out(kext));
    assign key = (enc == 1'b1) ? kext[63:0] : kext[127:64];
    assign endkey = (enc == 1'b1) ? kext[127:64] : kext[63:0]; 

    // initialize state
    assign kout_w = p0 ^ key;
    assign kout_x = p1;
    assign kout_y = p2;
    assign kout_z = p3;
    
    // initial inverse shift rows
    invshiftrows invsrw_init(.in(kout_w), .out(init_w));
    invshiftrows invsrx_init(.in(kout_x), .out(init_x));
    invshiftrows invsry_init(.in(kout_y), .out(init_y));
    invshiftrows invsrz_init(.in(kout_z), .out(init_z));
    
    muxer mux_w(.sel(start_sig), .t(init_w), .f(rout_w), .res(state_w));
    muxer mux_x(.sel(start_sig), .t(init_x), .f(rout_x), .res(state_x));
    muxer mux_y(.sel(start_sig), .t(init_y), .f(rout_y), .res(state_y));
    muxer mux_z(.sel(start_sig), .t(init_z), .f(rout_z), .res(state_z));
    
    muxer_small mux_b(.sel(start_sig), .t(b_guard), .f(bout), .res(state_b));
    muxer_small mux_c(.sel(start_sig), .t(c_guard), .f(cout), .res(state_c));
    muxer_small mux_d(.sel(start_sig), .t(d_guard), .f(dout), .res(state_d));
    
    // register stage 
    register_stage reg_w(.clk(clk), .rst(rst), .en(en_sig), .D(state_w), .Q(rin_w));
    register_stage reg_x(.clk(clk), .rst(rst), .en(en_sig), .D(state_x), .Q(rin_x));
    register_stage reg_y(.clk(clk), .rst(rst), .en(en_sig), .D(state_y), .Q(rin_y));
    register_stage reg_z(.clk(clk), .rst(rst), .en(en_sig), .D(state_z), .Q(rin_z));
    
    register_stage_small reg_b(.clk(clk), .rst(rst), .en(en_sig), .D(state_b), .Q(bin));
    register_stage_small reg_c(.clk(clk), .rst(rst), .en(en_sig), .D(state_c), .Q(cin));
    register_stage_small reg_d(.clk(clk), .rst(rst), .en(en_sig), .D(state_d), .Q(din));

    prince_controller cntrl_inst(.clk(clk), .rst(rst), .en(en), .enc(enc), .k(kext[191:128]), .rc(rc), .target_en(en_sig), .target_start(start_sig), .target_inv(inv_sig), .target_done(done_sig));
    prince_round round_inst(.iw(rin_w), .ix(rin_x), .iy(rin_y), .iz(rin_z), .b(bin), .c(cin), .d(din), .rc(rc), .inv(inv_sig), .ow(rout_w), .ox(rout_x), .oy(rout_y), .oz(rout_z), .o_b(bout), .o_c(cout), .o_d(dout), .o_half_w(final_w), .o_half_x(final_x), .o_half_y(final_y), .o_half_z(final_z));

    assign done = done_sig;
    assign final_w_k = endkey ^ final_w;
       
    muxer mux_c0(.sel(done_sig), .t(final_w_k), .f(64'h0000000000000000), .res(c0));
    muxer mux_c1(.sel(done_sig), .t(final_x), .f(64'h0000000000000000), .res(c1));
    muxer mux_c2(.sel(done_sig), .t(final_y), .f(64'h0000000000000000), .res(c2));
    muxer mux_c3(.sel(done_sig), .t(final_z), .f(64'h0000000000000000), .res(c3));
endmodule

