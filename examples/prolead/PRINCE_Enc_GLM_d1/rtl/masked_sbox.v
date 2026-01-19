`timescale 1ns / 1ps

module add4(
	input i1, 
	input i2,
	input i3, 
	input i4,
	output o
	);
	
	assign o = i1 ^ i2 ^ i3 ^ i4;
endmodule

module remask(
    input clk,
	 input rst, 
	 input en,
    input x, 
    input r,
    output z
	);	 
	
	wire xr;
	
	assign xr = x ^ r;
	register_stage reg_xr(.clk(clk), .rst(rst), .en(en), .D(xr), .Q(z));
endmodule

module compression(
    input clk, 
    input rst, 
    input en, 
    input [7:0] x,
    input [3:0] r,
    output zx, 
    output zy
    );
    
    wire [7:0] y;
    
    // remasking
    remask msk0(.clk(clk), .rst(rst), .en(en), .x(x[0]), .r(r[0]), .z(y[0]));
    remask msk1(.clk(clk), .rst(rst), .en(en), .x(x[1]), .r(r[1]), .z(y[1]));
    remask msk2(.clk(clk), .rst(rst), .en(en), .x(x[2]), .r(r[2]), .z(y[2]));
    remask msk3(.clk(clk), .rst(rst), .en(en), .x(x[3]), .r(r[3]), .z(y[3]));
    remask msk4(.clk(clk), .rst(rst), .en(en), .x(x[4]), .r(r[0]), .z(y[4]));
    remask msk5(.clk(clk), .rst(rst), .en(en), .x(x[5]), .r(r[1]), .z(y[5]));
    remask msk6(.clk(clk), .rst(rst), .en(en), .x(x[6]), .r(r[2]), .z(y[6]));
    remask msk7(.clk(clk), .rst(rst), .en(en), .x(x[7]), .r(r[3]), .z(y[7]));

    add4 ax(.i1(y[0]), .i2(y[1]), .i3(y[2]), .i4(y[3]), .o(zx));
    add4 ay(.i1(y[4]), .i2(y[5]), .i3(y[6]), .i4(y[7]), .o(zy));
endmodule

module masked_sbox(
    input clk, 
    input rst,
    input en,
    input sel, 
    input [3:0] x,
    input [3:0] y,
    input [15:0] r,
    output [3:0] z_x,
    output [3:0] z_y
    );
    
    wire [7:0] s0_sh, t0_sh, s1_sh, t1_sh, s2_sh, t2_sh, s3_sh, t3_sh; 
    wire [7:0] sh0_tmp, sh1_tmp, sh2_tmp, sh3_tmp;

    domain_xxxy xxxy_inst(.x(x[2:0]),        .y(y[3]),           .s0(s0_sh[0]), .s1(s1_sh[0]), .s2(s2_sh[0]), .s3(s3_sh[0]), .t0(t0_sh[0]), .t1(t1_sh[0]), .t2(t2_sh[0]), .t3(t3_sh[0]));
    domain_xxyx xxyx_inst(.x({x[3],x[1:0]}), .y(y[2]),           .s0(s0_sh[1]), .s1(s1_sh[1]), .s2(s2_sh[1]), .s3(s3_sh[1]), .t0(t0_sh[1]), .t1(t1_sh[1]), .t2(t2_sh[1]), .t3(t3_sh[1]));
    domain_xyxx xyxx_inst(.x({x[3:2],x[0]}), .y(y[1]),           .s0(s0_sh[2]), .s1(s1_sh[2]), .s2(s2_sh[2]), .s3(s3_sh[2]), .t0(t0_sh[2]), .t1(t1_sh[2]), .t2(t2_sh[2]), .t3(t3_sh[2]));
    domain_xyyy xyyy_inst(.x(x[0]),          .y(y[3:1]),         .s0(s0_sh[3]), .s1(s1_sh[3]), .s2(s2_sh[3]), .s3(s3_sh[3]), .t0(t0_sh[3]), .t1(t1_sh[3]), .t2(t2_sh[3]), .t3(t3_sh[3]));
    domain_yxxx yxxx_inst(.x(x[3:1]),        .y(y[0]),           .s0(s0_sh[4]), .s1(s1_sh[4]), .s2(s2_sh[4]), .s3(s3_sh[4]), .t0(t0_sh[4]), .t1(t1_sh[4]), .t2(t2_sh[4]), .t3(t3_sh[4]));
    domain_yxyy yxyy_inst(.x(x[1]),          .y({y[3:2],y[0]}),  .s0(s0_sh[5]), .s1(s1_sh[5]), .s2(s2_sh[5]), .s3(s3_sh[5]), .t0(t0_sh[5]), .t1(t1_sh[5]), .t2(t2_sh[5]), .t3(t3_sh[5]));
    domain_yyxy yyxy_inst(.x(x[2]),          .y({y[3],y[1:0]}),  .s0(s0_sh[6]), .s1(s1_sh[6]), .s2(s2_sh[6]), .s3(s3_sh[6]), .t0(t0_sh[6]), .t1(t1_sh[6]), .t2(t2_sh[6]), .t3(t3_sh[6]));
    domain_yyyx yyyx_inst(.x(x[3]),          .y({y[2:0]}),       .s0(s0_sh[7]), .s1(s1_sh[7]), .s2(s2_sh[7]), .s3(s3_sh[7]), .t0(t0_sh[7]), .t1(t1_sh[7]), .t2(t2_sh[7]), .t3(t3_sh[7]));
                
    muxer1 mux_s00(.sel(sel), .t(s0_sh[0]), .f(t0_sh[0]), .res(sh0_tmp[0]));
	 muxer1 mux_s01(.sel(sel), .t(s0_sh[1]), .f(t0_sh[1]), .res(sh0_tmp[1]));
    muxer1 mux_s02(.sel(sel), .t(s0_sh[2]), .f(t0_sh[2]), .res(sh0_tmp[2]));
    muxer1 mux_s03(.sel(sel), .t(s0_sh[3]), .f(t0_sh[3]), .res(sh0_tmp[3]));
    muxer1 mux_s04(.sel(sel), .t(s0_sh[4]), .f(t0_sh[4]), .res(sh0_tmp[4]));
    muxer1 mux_s05(.sel(sel), .t(s0_sh[5]), .f(t0_sh[5]), .res(sh0_tmp[5]));
    muxer1 mux_s06(.sel(sel), .t(s0_sh[6]), .f(t0_sh[6]), .res(sh0_tmp[6]));
    muxer1 mux_s07(.sel(sel), .t(s0_sh[7]), .f(t0_sh[7]), .res(sh0_tmp[7]));
	 
    muxer1 mux_s10(.sel(sel), .t(s1_sh[0]), .f(t1_sh[0]), .res(sh1_tmp[0]));
	 muxer1 mux_s11(.sel(sel), .t(s1_sh[1]), .f(t1_sh[1]), .res(sh1_tmp[1]));
    muxer1 mux_s12(.sel(sel), .t(s1_sh[2]), .f(t1_sh[2]), .res(sh1_tmp[2]));
    muxer1 mux_s13(.sel(sel), .t(s1_sh[3]), .f(t1_sh[3]), .res(sh1_tmp[3]));
    muxer1 mux_s14(.sel(sel), .t(s1_sh[4]), .f(t1_sh[4]), .res(sh1_tmp[4]));
    muxer1 mux_s15(.sel(sel), .t(s1_sh[5]), .f(t1_sh[5]), .res(sh1_tmp[5]));
    muxer1 mux_s16(.sel(sel), .t(s1_sh[6]), .f(t1_sh[6]), .res(sh1_tmp[6]));
    muxer1 mux_s17(.sel(sel), .t(s1_sh[7]), .f(t1_sh[7]), .res(sh1_tmp[7]));
	 
	 muxer1 mux_s20(.sel(sel), .t(s2_sh[0]), .f(t2_sh[0]), .res(sh2_tmp[0]));
	 muxer1 mux_s21(.sel(sel), .t(s2_sh[1]), .f(t2_sh[1]), .res(sh2_tmp[1]));
    muxer1 mux_s22(.sel(sel), .t(s2_sh[2]), .f(t2_sh[2]), .res(sh2_tmp[2]));
    muxer1 mux_s23(.sel(sel), .t(s2_sh[3]), .f(t2_sh[3]), .res(sh2_tmp[3]));
    muxer1 mux_s24(.sel(sel), .t(s2_sh[4]), .f(t2_sh[4]), .res(sh2_tmp[4]));
    muxer1 mux_s25(.sel(sel), .t(s2_sh[5]), .f(t2_sh[5]), .res(sh2_tmp[5]));
    muxer1 mux_s26(.sel(sel), .t(s2_sh[6]), .f(t2_sh[6]), .res(sh2_tmp[6]));
    muxer1 mux_s27(.sel(sel), .t(s2_sh[7]), .f(t2_sh[7]), .res(sh2_tmp[7]));
	 
	 muxer1 mux_s30(.sel(sel), .t(s3_sh[0]), .f(t3_sh[0]), .res(sh3_tmp[0]));
	 muxer1 mux_s31(.sel(sel), .t(s3_sh[1]), .f(t3_sh[1]), .res(sh3_tmp[1]));
    muxer1 mux_s32(.sel(sel), .t(s3_sh[2]), .f(t3_sh[2]), .res(sh3_tmp[2]));
    muxer1 mux_s33(.sel(sel), .t(s3_sh[3]), .f(t3_sh[3]), .res(sh3_tmp[3]));
    muxer1 mux_s34(.sel(sel), .t(s3_sh[4]), .f(t3_sh[4]), .res(sh3_tmp[4]));
    muxer1 mux_s35(.sel(sel), .t(s3_sh[5]), .f(t3_sh[5]), .res(sh3_tmp[5]));
    muxer1 mux_s36(.sel(sel), .t(s3_sh[6]), .f(t3_sh[6]), .res(sh3_tmp[6]));
    muxer1 mux_s37(.sel(sel), .t(s3_sh[7]), .f(t3_sh[7]), .res(sh3_tmp[7]));
    
    compression c_inst0(.clk(clk), .rst(rst), .en(en), .x(sh0_tmp), .r(r[3:0]), .zx(z_x[0]), .zy(z_y[0]));
    compression c_inst1(.clk(clk), .rst(rst), .en(en), .x(sh1_tmp), .r(r[7:4]), .zx(z_x[1]), .zy(z_y[1]));
    compression c_inst2(.clk(clk), .rst(rst), .en(en), .x(sh2_tmp), .r(r[11:8]), .zx(z_x[2]), .zy(z_y[2]));
    compression c_inst3(.clk(clk), .rst(rst), .en(en), .x(sh3_tmp), .r(r[15:12]), .zx(z_x[3]), .zy(z_y[3]));
endmodule    