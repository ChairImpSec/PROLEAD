`timescale 1ns / 1ps

module prince_round(
    input clk, 
    input rst, 
    input en,
    input [63:0] ix,
    input [63:0] iy,
    input [63:0] rc,
    input [63:0] rc2,
    input [127:0] r,
    input  inv,
    input  inv2,
    output [63:0] ox,
    output [63:0] oy,
    output [63:0] o_half_x,
    output [63:0] o_half_y
    );
    
    wire [63:0] sin_x, sin_y, xin_x, xin_y, min_x, min_y, srin_x, srin_y,  mout_x, mout_y, srout_x, srout_y, srout2_x, srout2_y, xout_x, xout_y, aout_x, aout_y, sout_x, sout_y, invsout_x, invsout_y, rc2_inv;
   
	 // inverse shift rows key and round constant layer
    invshiftrows invrc_inst(.in(rc2), .out(rc2_inv));
	 	 
    // shift rows layer
    shiftrows srx_inst(.in(ix), .out(srout_x));
    shiftrows sry_inst(.in(iy), .out(srout_y));
	 
	 // inverse shift rows layer
    invshiftrows invsrx_inst(.in(ix), .out(srin_x));
    invshiftrows invsry_inst(.in(iy), .out(srin_y));

	 // multiplexer and key addition
    genvar i;
    generate 
        for (i = 0; i < 64; i = i + 1) begin:S
		  	   keyadd x(.x(srout_x[i]), .k(rc[i]), .z(xout_x[i]));
			   keyadd srx(.x(sout_x[i]), .k(rc2_inv[i]), .z(srout2_x[i]));
		      muxer1 mux_inv_x1(.sel(inv), .t(xout_x[i]), .f(srin_x[i]), .res(sin_x[i]));
				muxer1 mux_inv_y1(.sel(inv), .t(xout_y[i]), .f(srin_y[i]), .res(sin_y[i]));
			   muxer1 mux_inv_x2(.sel(inv2), .t(sout_x[i]), .f(srout2_x[i]), .res(min_x[i]));
				muxer1 mux_inv_y2(.sel(inv2), .t(sout_y[i]), .f(srout2_y[i]), .res(min_y[i]));
        end
    endgenerate
	 
	 assign xout_y = srout_y;
	 assign srout2_y = sout_y;
    
    // substitution layer
    masked_sbox sbox_inst0(.clk(clk), .rst(rst), .en(en), .sel(inv), .x(sin_x[3:0]), .y(sin_y[3:0]), .r(r[15:0]), .z_x(sout_x[3:0]), .z_y(sout_y[3:0]));
    masked_sbox sbox_inst1(.clk(clk), .rst(rst), .en(en), .sel(inv), .x(sin_x[7:4]), .y(sin_y[7:4]), .r(r[31:16]), .z_x(sout_x[7:4]), .z_y(sout_y[7:4]));
    masked_sbox sbox_inst2(.clk(clk), .rst(rst), .en(en), .sel(inv), .x(sin_x[11:8]), .y(sin_y[11:8]), .r(r[47:32]), .z_x(sout_x[11:8]), .z_y(sout_y[11:8]));
    masked_sbox sbox_inst3(.clk(clk), .rst(rst), .en(en), .sel(inv), .x(sin_x[15:12]), .y(sin_y[15:12]), .r(r[63:48]), .z_x(sout_x[15:12]), .z_y(sout_y[15:12]));
    
    masked_sbox sbox_inst4(.clk(clk), .rst(rst), .en(en), .sel(inv), .x(sin_x[19:16]), .y(sin_y[19:16]), .r(r[15:0]), .z_x(sout_x[19:16]), .z_y(sout_y[19:16]));
    masked_sbox sbox_inst5(.clk(clk), .rst(rst), .en(en), .sel(inv), .x(sin_x[23:20]), .y(sin_y[23:20]), .r(r[31:16]), .z_x(sout_x[23:20]), .z_y(sout_y[23:20]));
    masked_sbox sbox_inst6(.clk(clk), .rst(rst), .en(en), .sel(inv), .x(sin_x[27:24]), .y(sin_y[27:24]), .r(r[47:32]), .z_x(sout_x[27:24]), .z_y(sout_y[27:24]));
    masked_sbox sbox_inst7(.clk(clk), .rst(rst), .en(en), .sel(inv), .x(sin_x[31:28]), .y(sin_y[31:28]), .r(r[63:48]), .z_x(sout_x[31:28]), .z_y(sout_y[31:28]));

    masked_sbox sbox_inst8(.clk(clk), .rst(rst), .en(en), .sel(inv), .x(sin_x[35:32]), .y(sin_y[35:32]), .r(r[79:64]), .z_x(sout_x[35:32]), .z_y(sout_y[35:32]));
    masked_sbox sbox_inst9(.clk(clk), .rst(rst), .en(en), .sel(inv), .x(sin_x[39:36]), .y(sin_y[39:36]), .r(r[95:80]), .z_x(sout_x[39:36]), .z_y(sout_y[39:36]));
    masked_sbox sbox_inst10(.clk(clk), .rst(rst), .en(en), .sel(inv), .x(sin_x[43:40]), .y(sin_y[43:40]), .r(r[111:96]), .z_x(sout_x[43:40]), .z_y(sout_y[43:40]));
    masked_sbox sbox_inst11(.clk(clk), .rst(rst), .en(en), .sel(inv), .x(sin_x[47:44]), .y(sin_y[47:44]), .r(r[127:112]), .z_x(sout_x[47:44]), .z_y(sout_y[47:44]));
    
    masked_sbox sbox_inst12(.clk(clk), .rst(rst), .en(en), .sel(inv), .x(sin_x[51:48]), .y(sin_y[51:48]), .r(r[79:64]), .z_x(sout_x[51:48]), .z_y(sout_y[51:48]));
    masked_sbox sbox_inst13(.clk(clk), .rst(rst), .en(en), .sel(inv), .x(sin_x[55:52]), .y(sin_y[55:52]), .r(r[95:80]), .z_x(sout_x[55:52]), .z_y(sout_y[55:52]));
    masked_sbox sbox_inst14(.clk(clk), .rst(rst), .en(en), .sel(inv), .x(sin_x[59:56]), .y(sin_y[59:56]), .r(r[111:96]), .z_x(sout_x[59:56]), .z_y(sout_y[59:56]));
    masked_sbox sbox_inst15(.clk(clk), .rst(rst), .en(en), .sel(inv), .x(sin_x[63:60]), .y(sin_y[63:60]), .r(r[127:112]), .z_x(sout_x[63:60]), .z_y(sout_y[63:60]));

	 shiftrows srox_inst(.in(srout2_x), .out(o_half_x));
    shiftrows sroy_inst(.in(srout2_y), .out(o_half_y));

    // mprime layer
    mprime mx_inst(.in(min_x), .out(ox));
    mprime my_inst(.in(min_y), .out(oy));
endmodule
