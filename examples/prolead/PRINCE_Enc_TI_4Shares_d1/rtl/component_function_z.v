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

module component_function_z(
    input [3:0] w,
    input [3:0] x,
    input [3:0] y,
    input [3:0] b,
    input [3:0] c,
    output [3:0] z_z
    );
    
    wire [3:0] z_z_tmp;
    
    wire ww01, wx01, wy01, xw01, xx01, xy01, yw01, yx01, yy01;
    wire ww02, wx02, wy02, xw02, xx02, xy02, yw02, yx02, yy02;
    wire ww03, wx03, wy03, xw03, xx03, xy03, yw03, yx03, yy03;
    wire ww12, wx12, wy12, xw12, xx12, xy12, yw12, yx12, yy12;
    wire ww13, wx13, wy13, xw13, xx13, xy13, yw13, yx13, yy13;
    wire ww23, wx23, wy23, xw23, xx23, xy23, yw23, yx23, yy23;
    
    wire www012, wwx012, wwy012, wwz012, wxw012, wxx012, wxy012, wxz012, wyw012, wyx012, wyy012;
    wire xww012, xwx012, xwy012, xwz012, xxw012, xxx012, xxy012, xxz012, xyw012, xyx012, xyy012;
    wire yww012, ywx012, ywy012, ywz012, yxw012, yxx012, yxy012, yxz012, yyw012, yyx012, yyy012;
    
    wire www013, wwx013, wwy013, wwz013, wxw013, wxx013, wxy013, wxz013, wyw013, wyx013, wyy013;
    wire xww013, xwx013, xwy013, xwz013, xxw013, xxx013, xxy013, xxz013, xyw013, xyx013, xyy013;
    wire yww013, ywx013, ywy013, ywz013, yxw013, yxx013, yxy013, yxz013, yyw013, yyx013, yyy013;
    
    wire www023, wwx023, wwy023, wwz023, wxw023, wxx023, wxy023, wxz023, wyw023, wyx023, wyy023;
    wire xww023, xwx023, xwy023, xwz023, xxw023, xxx023, xxy023, xxz023, xyw023, xyx023, xyy023;
    wire yww023, ywx023, ywy023, ywz023, yxw023, yxx023, yxy023, yxz023, yyw023, yyx023, yyy023;
    
    wire www123, wwx123, wwy123, wwz123, wxw123, wxx123, wxy123, wxz123, wyw123, wyx123, wyy123;
    wire xww123, xwx123, xwy123, xwz123, xxw123, xxx123, xxy123, xxz123, xyw123, xyx123, xyy123;
    wire yww123, ywx123, ywy123, ywz123, yxw123, yxx123, yxy123, yxz123, yyw123, yyx123, yyy123;
    
    wire z0, z1, z2, z3;
    
    wire z01;
    wire z02;
    wire z03;
    wire z12;
    wire z13;
    wire z23;
    
    wire z012;
    wire z013;
    wire z023;
    wire z123;
    
    assign z0 = w[0];
    assign z1 = w[1];
    assign z2 = w[2];
    assign z3 = w[3];
    
    assign ww01 = w[0] & w[1];
    assign wx01 = w[0] & x[1];
    assign wy01 = w[0] & y[1];
    assign xw01 = x[0] & w[1];
    assign xx01 = x[0] & x[1];
    assign xy01 = x[0] & y[1];
    assign yw01 = y[0] & w[1];
    assign yx01 = y[0] & x[1];
    assign yy01 = y[0] & y[1];

    assign z01 = ww01 ^ wx01 ^ wy01 ^ xw01; 
    
    assign ww02 = w[0] & w[2];
    assign wx02 = w[0] & x[2];
    assign wy02 = w[0] & y[2];
    assign xw02 = x[0] & w[2];
    assign xx02 = x[0] & x[2];
    assign xy02 = x[0] & y[2];
    assign yw02 = y[0] & w[2];
    assign yx02 = y[0] & x[2];
    assign yy02 = y[0] & y[2];
    
    assign z02 = ww02 ^ wx02 ^ wy02 ^ xw02; 
    
    assign ww03 = w[0] & w[3];
    assign wx03 = w[0] & x[3];
    assign wy03 = w[0] & y[3];
    assign xw03 = x[0] & w[3];
    assign xx03 = x[0] & x[3];
    assign xy03 = x[0] & y[3];
    assign yw03 = y[0] & w[3];
    assign yx03 = y[0] & x[3];
    assign yy03 = y[0] & y[3];

    assign z03 = ww03 ^ wx03 ^ wy03 ^ xw03; 
    
    assign ww12 = w[1] & w[2];
    assign wx12 = w[1] & x[2];
    assign wy12 = w[1] & y[2];
    assign xw12 = x[1] & w[2];
    assign xx12 = x[1] & x[2];
    assign xy12 = x[1] & y[2];
    assign yw12 = y[1] & w[2];
    assign yx12 = y[1] & x[2];
    assign yy12 = y[1] & y[2];
    
    assign z12 = ww12 ^ wx12 ^ wy12 ^ xw12; 
    
    assign ww13 = w[1] & w[3];
    assign wx13 = w[1] & x[3];
    assign wy13 = w[1] & y[3];
    assign xw13 = x[1] & w[3];
    assign xx13 = x[1] & x[3];
    assign xy13 = x[1] & y[3];
    assign yw13 = y[1] & w[3];
    assign yx13 = y[1] & x[3];
    assign yy13 = y[1] & y[3];
    
    assign z13 = ww13 ^ wx13 ^ wy13 ^ xw13; 
    
    assign ww23 = w[2] & w[3];
    assign wx23 = w[2] & x[3];
    assign wy23 = w[2] & y[3];
    assign xw23 = x[2] & w[3];
    assign xx23 = x[2] & x[3];
    assign xy23 = x[2] & y[3];
    assign yw23 = y[2] & w[3];
    assign yx23 = y[2] & x[3];
    assign yy23 = y[2] & y[3];

    assign z23 = ww23 ^ wx23 ^ wy23 ^ xw23; 
    
    assign www012 = ww01 & w[2];
    assign wwx012 = ww01 & x[2];
    assign wwy012 = ww01 & y[2];
    assign wxw012 = wx01 & w[2];
    assign wxx012 = wx01 & x[2];
    assign wxy012 = wx01 & y[2];
    assign wyw012 = wy01 & w[2];
    assign wyx012 = wy01 & x[2];
    assign wyy012 = wy01 & y[2];
    assign xww012 = xw01 & w[2];
    assign xwx012 = xw01 & x[2];
    assign xwy012 = xw01 & y[2];
    assign xxw012 = xx01 & w[2];
    assign xxx012 = xx01 & x[2];
    assign xxy012 = xx01 & y[2];
    assign xyw012 = xy01 & w[2];
    assign xyx012 = xy01 & x[2];
    assign xyy012 = xy01 & y[2];
    assign yww012 = yw01 & w[2];
    assign ywx012 = yw01 & x[2]; 
    assign ywy012 = yw01 & y[2];
    assign yxw012 = yx01 & w[2];
    assign yxx012 = yx01 & x[2];
    assign yxy012 = yx01 & y[2];
    assign yyw012 = yy01 & w[2];
    assign yyx012 = yy01 & x[2];
    assign yyy012 = yy01 & y[2];

    assign z012 = www012 ^ wwx012 ^ wwy012 ^ wxw012 ^ wxx012 ^ wxy012 ^ wyw012 ^ wyx012 ^ wyy012 ^ xww012 ^ xwx012 ^ xwy012 ^ xxw012 ^ xyw012 ^ ywx012 ^ yxw012;
    
    assign www013 = ww01 & w[3];
    assign wwx013 = ww01 & x[3];
    assign wwy013 = ww01 & y[3];
    assign wxw013 = wx01 & w[3];
    assign wxx013 = wx01 & x[3];
    assign wxy013 = wx01 & y[3];
    assign wyw013 = wy01 & w[3];
    assign wyx013 = wy01 & x[3];
    assign wyy013 = wy01 & y[3];
    assign xww013 = xw01 & w[3];
    assign xwx013 = xw01 & x[3];
    assign xwy013 = xw01 & y[3];
    assign xxw013 = xx01 & w[3];
    assign xxx013 = xx01 & x[3];
    assign xxy013 = xx01 & y[3];
    assign xyw013 = xy01 & w[3];
    assign xyx013 = xy01 & x[3];
    assign xyy013 = xy01 & y[3];
    assign yww013 = yw01 & w[3];
    assign ywx013 = yw01 & x[3]; 
    assign ywy013 = yw01 & y[3];
    assign yxw013 = yx01 & w[3];
    assign yxx013 = yx01 & x[3];
    assign yxy013 = yx01 & y[3];
    assign yyw013 = yy01 & w[3];
    assign yyx013 = yy01 & x[3];
    assign yyy013 = yy01 & y[3];

    assign z013 = www013 ^ wwx013 ^ wwy013 ^ wxw013 ^ wxx013 ^ wxy013 ^ wyw013 ^ wyx013 ^ wyy013 ^ xww013 ^ xwx013 ^ xwy013 ^ xxw013 ^ xyw013 ^ ywx013 ^ yxw013;
    
    assign www023 = ww02 & w[3];
    assign wwx023 = ww02 & x[3];
    assign wwy023 = ww02 & y[3];
    assign wxw023 = wx02 & w[3];
    assign wxx023 = wx02 & x[3];
    assign wxy023 = wx02 & y[3];
    assign wyw023 = wy02 & w[3];
    assign wyx023 = wy02 & x[3];
    assign wyy023 = wy02 & y[3];
    assign xww023 = xw02 & w[3];
    assign xwx023 = xw02 & x[3];
    assign xwy023 = xw02 & y[3];
    assign xxw023 = xx02 & w[3];
    assign xxx023 = xx02 & x[3];
    assign xxy023 = xx02 & y[3];
    assign xyw023 = xy02 & w[3];
    assign xyx023 = xy02 & x[3];
    assign xyy023 = xy02 & y[3];
    assign yww023 = yw02 & w[3];
    assign ywx023 = yw02 & x[3]; 
    assign ywy023 = yw02 & y[3];
    assign yxw023 = yx02 & w[3];
    assign yxx023 = yx02 & x[3];
    assign yxy023 = yx02 & y[3];
    assign yyw023 = yy02 & w[3];
    assign yyx023 = yy02 & x[3];
    assign yyy023 = yy02 & y[3];

    assign z023 = www023 ^ wwx023 ^ wwy023 ^ wxw023 ^ wxx023 ^ wxy023 ^ wyw023 ^ wyx023 ^ wyy023 ^ xww023 ^ xwx023 ^ xwy023 ^ xxw023 ^ xyw023 ^ ywx023 ^ yxw023;
    
    assign www123 = ww12 & w[3];
    assign wwx123 = ww12 & x[3];
    assign wwy123 = ww12 & y[3];
    assign wxw123 = wx12 & w[3];
    assign wxx123 = wx12 & x[3];
    assign wxy123 = wx12 & y[3];
    assign wyw123 = wy12 & w[3];
    assign wyx123 = wy12 & x[3];
    assign wyy123 = wy12 & y[3];
    assign xww123 = xw12 & w[3];
    assign xwx123 = xw12 & x[3];
    assign xwy123 = xw12 & y[3];
    assign xxw123 = xx12 & w[3];
    assign xxx123 = xx12 & x[3];
    assign xxy123 = xx12 & y[3];
    assign xyw123 = xy12 & w[3];
    assign xyx123 = xy12 & x[3];
    assign xyy123 = xy12 & y[3];
    assign yww123 = yw12 & w[3];
    assign ywx123 = yw12 & x[3]; 
    assign ywy123 = yw12 & y[3];
    assign yxw123 = yx12 & w[3];
    assign yxx123 = yx12 & x[3];
    assign yxy123 = yx12 & y[3];
    assign yyw123 = yy12 & w[3];
    assign yyx123 = yy12 & x[3];
    assign yyy123 = yy12 & y[3];

    assign z123 = www123 ^ wwx123 ^ wwy123 ^ wxw123 ^ wxx123 ^ wxy123 ^ wyw123 ^ wyx123 ^ wyy123 ^ xww123 ^ xwx123 ^ xwy123 ^ xxw123 ^ xyw123 ^ ywx123 ^ yxw123;
    
    assign z_z_tmp[0] = z2 ^ z3 ^ z01 ^ z03 ^ z12 ^ z23 ^ z012;
    assign z_z_tmp[1] = z02 ^ z12 ^ z13 ^ z012 ^ z123;
    assign z_z_tmp[2] = z0 ^ z3 ^ z01 ^ z03 ^ z13 ^ z013 ^ z123;
    assign z_z_tmp[3] = z1 ^ z3 ^ z12 ^ z23 ^ z012 ^ z013 ^ z023;
    
     // Remasking according to changing of the guards
     assign z_z = z_z_tmp ^ b ^ c;
endmodule
