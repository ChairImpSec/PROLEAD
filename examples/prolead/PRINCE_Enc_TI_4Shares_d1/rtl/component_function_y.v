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

module component_function_y(
    input [3:0] w,
    input [3:0] x,
    input [3:0] z,
    input [3:0] b,
    output [3:0] z_y
    );
    
    wire [3:0] z_y_tmp;
    
    wire ww01, wx01, wz01, xw01, xx01, xz01, zw01, zx01, zz01;
    wire ww02, wx02, wz02, xw02, xx02, xz02, zw02, zx02, zz02;
    wire ww03, wx03, wz03, xw03, xx03, xz03, zw03, zx03, zz03;
    wire ww12, wx12, wz12, xw12, xx12, xz12, zw12, zx12, zz12;
    wire ww13, wx13, wz13, xw13, xx13, xz13, zw13, zx13, zz13;
    wire ww23, wx23, wz23, xw23, xx23, xz23, zw23, zx23, zz23;
    
    wire www012, wwx012, wwz012, wxw012, wxx012, wxz012, wzw012, wzx012, wzz012;
    wire xww012, xwx012, xwz012, xxw012, xxx012, xxz012, xzw012, xzx012, xzz012;
    wire zww012, zwx012, zwz012, zxw012, zxx012, zxz012, zzw012, zzx012, zzz012;
    
    wire www013, wwx013, wwz013, wxw013, wxx013, wxz013, wzw013, wzx013, wzz013;
    wire xww013, xwx013, xwz013, xxw013, xxx013, xxz013, xzw013, xzx013, xzz013;
    wire zww013, zwx013, zwz013, zxw013, zxx013, zxz013, zzw013, zzx013, zzz013;
    
    wire www023, wwx023, wwz023, wxw023, wxx023, wxz023, wzw023, wzx023, wzz023;
    wire xww023, xwx023, xwz023, xxw023, xxx023, xxz023, xzw023, xzx023, xzz023;
    wire zww023, zwx023, zwz023, zxw023, zxx023, zxz023, zzw023, zzx023, zzz023;
    
    wire www123, wwx123, wwz123, wxw123, wxx123, wxz123, wzw123, wzx123, wzz123;
    wire xww123, xwx123, xwz123, xxw123, xxx123, xxz123, xzw123, xzx123, xzz123;
    wire zww123, zwx123, zwz123, zxw123, zxx123, zxz123, zzw123, zzx123, zzz123;
    
    wire y0, y1, y2, y3;
    
    wire y01;
    wire y02;
    wire y03;
    wire y12;
    wire y13;
    wire y23;
    
    wire y012;
    wire y013;
    wire y023;
    wire y123;
    
    assign y0 = z[0];
    assign y1 = z[1];
    assign y2 = z[2];
    assign y3 = z[3];
    
    assign ww01 = w[0] & w[1];
    assign wx01 = w[0] & x[1];
    assign wz01 = w[0] & z[1];
    assign xw01 = x[0] & w[1];
    assign xx01 = x[0] & x[1];
    assign xz01 = x[0] & z[1];
    assign zw01 = z[0] & w[1];
    assign zx01 = z[0] & x[1];
    assign zz01 = z[0] & z[1];
    
    assign y01 = wz01 ^ zw01 ^ zz01 ^ zx01;
    
    assign ww02 = w[0] & w[2];
    assign wx02 = w[0] & x[2];
    assign wz02 = w[0] & z[2];
    assign xw02 = x[0] & w[2];
    assign xx02 = x[0] & x[2];
    assign xz02 = x[0] & z[2];
    assign zw02 = z[0] & w[2];
    assign zx02 = z[0] & x[2];
    assign zz02 = z[0] & z[2];
    
    assign y02 = wz02 ^ zw02 ^ zz02 ^ zx02;
    
    assign ww03 = w[0] & w[3];
    assign wx03 = w[0] & x[3];
    assign wz03 = w[0] & z[3];
    assign xw03 = x[0] & w[3];
    assign xx03 = x[0] & x[3];
    assign xz03 = x[0] & z[3];
    assign zw03 = z[0] & w[3];
    assign zx03 = z[0] & x[3];
    assign zz03 = z[0] & z[3];

    assign y03 = wz03 ^ zw03 ^ zz03 ^ zx03;

    assign ww12 = w[1] & w[2];
    assign wx12 = w[1] & x[2];
    assign wz12 = w[1] & z[2];
    assign xw12 = x[1] & w[2];
    assign xx12 = x[1] & x[2];
    assign xz12 = x[1] & z[2];
    assign zw12 = z[1] & w[2];
    assign zx12 = z[1] & x[2];
    assign zz12 = z[1] & z[2];
    
    assign y12 = wz12 ^ zw12 ^ zz12 ^ zx12;
    
    assign ww13 = w[1] & w[3];
    assign wx13 = w[1] & x[3];
    assign wz13 = w[1] & z[3];
    assign xw13 = x[1] & w[3];
    assign xx13 = x[1] & x[3];
    assign xz13 = x[1] & z[3];
    assign zw13 = z[1] & w[3];
    assign zx13 = z[1] & x[3];
    assign zz13 = z[1] & z[3];
    
    assign y13 = wz13 ^ zw13 ^ zz13 ^ zx13;
    
    assign ww23 = w[2] & w[3];
    assign wx23 = w[2] & x[3];
    assign wz23 = w[2] & z[3];
    assign xw23 = x[2] & w[3];
    assign xx23 = x[2] & x[3];
    assign xz23 = x[2] & z[3];
    assign zw23 = z[2] & w[3];
    assign zx23 = z[2] & x[3];
    assign zz23 = z[2] & z[3];
    
    assign y23 = wz23 ^ zw23 ^ zz23 ^ zx23;
    
    assign www012 = ww01 & w[2];
    assign wwx012 = ww01 & x[2];
    assign wwz012 = ww01 & z[2];
    assign wxw012 = wx01 & w[2];
    assign wxx012 = wx01 & x[2];
    assign wxz012 = wx01 & z[2];
    assign wzw012 = wz01 & w[2];
    assign wzx012 = wz01 & x[2];
    assign wzz012 = wz01 & z[2];
    assign xww012 = xw01 & w[2];
    assign xwx012 = xw01 & x[2];
    assign xwz012 = xw01 & z[2];
    assign xxw012 = xx01 & w[2];
    assign xxx012 = xx01 & x[2];
    assign xxz012 = xx01 & z[2];
    assign xzw012 = xz01 & w[2];
    assign xzx012 = xz01 & x[2];
    assign xzz012 = xz01 & z[2];
    assign zww012 = zw01 & w[2];
    assign zwx012 = zw01 & x[2];
    assign zwz012 = zw01 & z[2];
    assign zxw012 = zx01 & w[2];
    assign zxx012 = zx01 & x[2];
    assign zxz012 = zx01 & z[2];
    assign zzw012 = zz01 & w[2];
    assign zzx012 = zz01 & x[2];
    assign zzz012 = zz01 & z[2];
    
    assign y012 = wwz012 ^ wzw012 ^ wxz012 ^ wzx012 ^ wzz012 ^ xwz012 ^ xzw012 ^ xzx012 ^ xzz012 ^ zww012 ^ zwx012 ^ zwz012 ^ zxw012 ^ zzw012 ^ zzx012 ^ zzz012;
    
    assign www013 = ww01 & w[3];
    assign wwx013 = ww01 & x[3];
    assign wwz013 = ww01 & z[3];
    assign wxw013 = wx01 & w[3];
    assign wxx013 = wx01 & x[3];
    assign wxz013 = wx01 & z[3];
    assign wzw013 = wz01 & w[3];
    assign wzx013 = wz01 & x[3];
    assign wzz013 = wz01 & z[3];
    assign xww013 = xw01 & w[3];
    assign xwx013 = xw01 & x[3];
    assign xwz013 = xw01 & z[3];
    assign xxw013 = xx01 & w[3];
    assign xxx013 = xx01 & x[3];
    assign xxz013 = xx01 & z[3];
    assign xzw013 = xz01 & w[3];
    assign xzx013 = xz01 & x[3];
    assign xzz013 = xz01 & z[3];
    assign zww013 = zw01 & w[3];
    assign zwx013 = zw01 & x[3];
    assign zwz013 = zw01 & z[3];
    assign zxw013 = zx01 & w[3];
    assign zxx013 = zx01 & x[3];
    assign zxz013 = zx01 & z[3];
    assign zzw013 = zz01 & w[3];
    assign zzx013 = zz01 & x[3];
    assign zzz013 = zz01 & z[3];
    
    assign y013 = wwz013 ^ wzw013 ^ wxz013 ^ wzx013 ^ wzz013 ^ xwz013 ^ xzw013 ^ xzx013 ^ xzz013 ^ zww013 ^ zwx013 ^ zwz013 ^ zxw013 ^ zzw013 ^ zzx013 ^ zzz013;
    
    assign www023 = ww02 & w[3];
    assign wwx023 = ww02 & x[3];
    assign wwz023 = ww02 & z[3];
    assign wxw023 = wx02 & w[3];
    assign wxx023 = wx02 & x[3];
    assign wxz023 = wx02 & z[3];
    assign wzw023 = wz02 & w[3];
    assign wzx023 = wz02 & x[3];
    assign wzz023 = wz02 & z[3];
    assign xww023 = xw02 & w[3];
    assign xwx023 = xw02 & x[3];
    assign xwz023 = xw02 & z[3];
    assign xxw023 = xx02 & w[3];
    assign xxx023 = xx02 & x[3];
    assign xxz023 = xx02 & z[3];
    assign xzw023 = xz02 & w[3];
    assign xzx023 = xz02 & x[3];
    assign xzz023 = xz02 & z[3];
    assign zww023 = zw02 & w[3];
    assign zwx023 = zw02 & x[3];
    assign zwz023 = zw02 & z[3];
    assign zxw023 = zx02 & w[3];
    assign zxx023 = zx02 & x[3];
    assign zxz023 = zx02 & z[3];
    assign zzw023 = zz02 & w[3];
    assign zzx023 = zz02 & x[3];
    assign zzz023 = zz02 & z[3];
    
    assign y023 = wwz023 ^ wzw023 ^ wxz023 ^ wzx023 ^ wzz023 ^ xwz023 ^ xzw023 ^ xzx023 ^ xzz023 ^ zww023 ^ zwx023 ^ zwz023 ^ zxw023 ^ zzw023 ^ zzx023 ^ zzz023;
    
    assign www123 = ww12 & w[3];
    assign wwx123 = ww12 & x[3];
    assign wwz123 = ww12 & z[3];
    assign wxw123 = wx12 & w[3];
    assign wxx123 = wx12 & x[3];
    assign wxz123 = wx12 & z[3];
    assign wzw123 = wz12 & w[3];
    assign wzx123 = wz12 & x[3];
    assign wzz123 = wz12 & z[3];
    assign xww123 = xw12 & w[3];
    assign xwx123 = xw12 & x[3];
    assign xwz123 = xw12 & z[3];
    assign xxw123 = xx12 & w[3];
    assign xxx123 = xx12 & x[3];
    assign xxz123 = xx12 & z[3];
    assign xzw123 = xz12 & w[3];
    assign xzx123 = xz12 & x[3];
    assign xzz123 = xz12 & z[3];
    assign zww123 = zw12 & w[3];
    assign zwx123 = zw12 & x[3];
    assign zwz123 = zw12 & z[3];
    assign zxw123 = zx12 & w[3];
    assign zxx123 = zx12 & x[3];
    assign zxz123 = zx12 & z[3];
    assign zzw123 = zz12 & w[3];
    assign zzx123 = zz12 & x[3];
    assign zzz123 = zz12 & z[3];
    
    assign y123 = wwz123 ^ wzw123 ^ wxz123 ^ wzx123 ^ wzz123 ^ xwz123 ^ xzw123 ^ xzx123 ^ xzz123 ^ zww123 ^ zwx123 ^ zwz123 ^ zxw123 ^ zzw123 ^ zzx123 ^ zzz123;

    assign z_y_tmp[0] = y2 ^ y3 ^ y01 ^ y03 ^ y12 ^ y23 ^ y012;
    assign z_y_tmp[1] = y02 ^ y12 ^ y13 ^ y012 ^ y123;
    assign z_y_tmp[2] = y0 ^ y3 ^ y01 ^ y03 ^ y13 ^ y013 ^ y123;
    assign z_y_tmp[3] = y1 ^ y3 ^ y12 ^ y23 ^ y012 ^ y013 ^ y023;
    
     // Remasking according to changing of the guards
     assign z_y = z_y_tmp ^ b;
endmodule
