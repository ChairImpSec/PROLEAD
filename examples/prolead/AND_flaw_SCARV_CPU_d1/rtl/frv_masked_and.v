// This code is extracted from SCARV repository, containing a masked (but leaking) version of the scarv cpu core.
// https://github.com/scarv/scarv-cpu/blob/scarv/xcrypto/masking-ise/rtl/core/frv_masked_bitwise.v
// The code is released under the following license.

// MIT License
//
// Copyright (c) 2019 Ben Marshall
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

module frv_masked_and #(
parameter integer N=1
)(
input  wire          g_clk  ,
input  wire          clk_en ,   // Clock/register enble.
input  wire [N-1:0]  z0     ,   // Fresh randomness
input  wire [N-1:0]  z1     ,   // Fresh randomness
input  wire [N-1:0]  ax, ay ,   // Domain A Input shares: rs1 s0, rs2 s0
input  wire [N-1:0]  bx, by ,   // Domain B Input shares: rs1 s1, rs2 s1
output wire [N-1:0]  qx, qy     // Result shares
);

wire [N-1:0] t0 = ax & z0;
reg  [N-1:0] t1 ;

always @(posedge g_clk) if(clk_en) t1 <= by ^ z0;

assign qx = ((t1 ^ ay) & ax) ^ t0 ^ z1;


wire [N-1:0] t2 = bx & z0;
reg  [N-1:0] t3 ;

always @(posedge g_clk) if(clk_en) t3 <= ay ^ z0;

assign qy = ((t3 ^ by) & bx) ^ t2 ^ z1;

endmodule
