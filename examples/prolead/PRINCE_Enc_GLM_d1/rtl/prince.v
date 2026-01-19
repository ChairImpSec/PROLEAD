`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Nicolai Mller
// 
// Create Date: 18.03.2020 09:18:38
// Module Name: prince
// Project Name: prince
// Description: top module of the prince cipher
// 
// Revision:
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////

module prince(
    input clk,
    input rst, // reset 
    input en, // enable
    input enc, // enc = 1, dec = 0
    input [63:0] p0, // 64-bit plaintext share
    input [63:0] p1, // 64-bit plaintext share
    input [127:0] r, // 128-bit fresh randomness per cycle
    input [127:0] k, // 128-bit key
    output [63:0] c0, // 64-bit ciphertext share
    output [63:0] c1, // 64-bit ciphertext share
    output done
    );
    
    wire done_sig, en_sig, start_sig, inv_sig, inv_sig2;
    wire [191:0] kext; // extended 192-bit key
    wire [63:0] key, p0_reg, p1_reg, endkey, final_x, final_y, kout_x, kout_y, init_x, init_y, rin_x, rin_y, rout_x, rout_y, state_x, state_y, rc, rc2, final_x_k;
    wire [127:0] k_reg;
    
    // extend key to 192 bits   
    keyextend k_inst(.in(k_reg), .out(kext));
    assign key = (enc == 1'b1) ? kext[63:0] : kext[127:64];
    assign endkey = (enc == 1'b1) ? kext[127:64] : kext[63:0]; 
	 
    // register stage 
    register_stage64 reg_k0(.clk(clk), .rst(rst), .en(en_sig), .D(k[63:0]), .Q(k_reg[63:0]));
    register_stage64 reg_k1(.clk(clk), .rst(rst), .en(en_sig), .D(k[127:64]), .Q(k_reg[127:64]));
    register_stage64 reg_p0(.clk(clk), .rst(rst), .en(en_sig), .D(p0), .Q(p0_reg));
    register_stage64 reg_p1(.clk(clk), .rst(rst), .en(en_sig), .D(p1), .Q(p1_reg));

    // initialize state
    assign kout_x = p0_reg ^ key;
    assign kout_y = p1_reg;
    
    // initial inverse shift rows
    invshiftrows invsrx_init(.in(kout_x), .out(init_x));
    invshiftrows invsry_init(.in(kout_y), .out(init_y));
    
    muxer mux_x(.sel(start_sig), .t(init_x), .f(rout_x), .res(rin_x));
    muxer mux_y(.sel(start_sig), .t(init_y), .f(rout_y), .res(rin_y));
	 
    prince_controller cntrl_inst(.clk(clk), .rst(rst), .en(en), .enc(enc), .k(kext[191:128]), .rc(rc), .rc2(rc2), .target_en(en_sig), .target_start(start_sig), .target_inv(inv_sig), .target_inv2(inv_sig2), .target_done(done_sig));
    prince_round prince_inst(.clk(clk), .rst(rst), .en(en_sig), .ix(rin_x), .iy(rin_y), .rc(rc), .rc2(rc2), .r(r[127:0]), .inv(inv_sig), .inv2(inv_sig2), .ox(rout_x), .oy(rout_y), .o_half_x(final_x), .o_half_y(final_y));

    assign done = done_sig;
    assign final_x_k = endkey ^ final_x;
       
    muxer mux_c0(.sel(done_sig), .t(final_x_k), .f(64'h0000000000000000), .res(c0));
    muxer mux_c1(.sel(done_sig), .t(final_y), .f(64'h0000000000000000), .res(c1));
endmodule

