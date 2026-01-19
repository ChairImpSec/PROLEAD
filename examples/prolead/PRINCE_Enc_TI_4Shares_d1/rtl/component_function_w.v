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

module component_function_w(
    input [3:0] x,
    input [3:0] y,
    input [3:0] z,
    input [3:0] c,
    input [3:0] d,
    output [3:0] z_w
    );
    
    wire [3:0] z_w_tmp; 
    
    wire xx01, xy01, xz01, yw01, yx01, yy01, yz01, zw01, zx01, zy01, zz01;
    wire xx02, xy02, xz02, yw02, yx02, yy02, yz02, zw02, zx02, zy02, zz02;
    wire xx03, xy03, xz03, yw03, yx03, yy03, yz03, zw03, zx03, zy03, zz03;
    wire xx12, xy12, xz12, yw12, yx12, yy12, yz12, zw12, zx12, zy12, zz12;
    wire xx13, xy13, xz13, yw13, yx13, yy13, yz13, zw13, zx13, zy13, zz13;
    wire xx23, xy23, xz23, yw23, yx23, yy23, yz23, zw23, zx23, zy23, zz23;
    
    wire xxx012, xxy012, xxz012, xyx012, xyy012, xyz012, xzx012, xzy012, xzz012;
    wire yxx012, yxy012, yxz012, yyx012, yyy012, yyz012, yzx012, yzy012, yzz012;
    wire zxx012, zxy012, zxz012, zyx012, zyy012, zyz012, zzx012, zzy012, zzz012;
    
    wire xxx013, xxy013, xxz013, xyx013, xyy013, xyz013, xzx013, xzy013, xzz013;
    wire yxx013, yxy013, yxz013, yyx013, yyy013, yyz013, yzx013, yzy013, yzz013;
    wire zxx013, zxy013, zxz013, zyx013, zyy013, zyz013, zzx013, zzy013, zzz013;
    
    wire xxx023, xxy023, xxz023, xyx023, xyy023, xyz023, xzx023, xzy023, xzz023;
    wire yxx023, yxy023, yxz023, yyx023, yyy023, yyz023, yzx023, yzy023, yzz023;
    wire zxx023, zxy023, zxz023, zyx023, zyy023, zyz023, zzx023, zzy023, zzz023;
    
    wire xxx123, xxy123, xxz123, xyx123, xyy123, xyz123, xzx123, xzy123, xzz123;
    wire yxx123, yxy123, yxz123, yyx123, yyy123, yyz123, yzx123, yzy123, yzz123;
    wire zxx123, zxy123, zxz123, zyx123, zyy123, zyz123, zzx123, zzy123, zzz123;
    
    wire w0, w1, w2, w3;
    
    wire w01;
    wire w02;
    wire w03;
    wire w12;
    wire w13;
    wire w23;
    
    wire w012;
    wire w013;
    wire w023;
    wire w123;
    
    assign w0 = x[0];
    assign w1 = x[1];
    assign w2 = x[2];
    assign w3 = x[3];
    
    assign xx01 = x[0] & x[1];
    assign xy01 = x[0] & y[1];
    assign xz01 = x[0] & z[1];
    assign yx01 = y[0] & x[1];
    assign yy01 = y[0] & y[1];
    assign yz01 = y[0] & z[1];
    assign zx01 = z[0] & x[1];
    assign zy01 = z[0] & y[1];
    assign zz01 = z[0] & z[1];
    
    assign w01 = xx01 ^ xy01 ^ xz01 ^ yx01;  
    
    assign xx02 = x[0] & x[2];
    assign xy02 = x[0] & y[2];
    assign xz02 = x[0] & z[2];
    assign yx02 = y[0] & x[2];
    assign yy02 = y[0] & y[2];
    assign yz02 = y[0] & z[2];
    assign zx02 = z[0] & x[2];
    assign zy02 = z[0] & y[2];
    assign zz02 = z[0] & z[2];
    
    assign w02 = xx02 ^ xy02 ^ xz02 ^ yx02; 
    
    assign xx03 = x[0] & x[3];
    assign xy03 = x[0] & y[3];
    assign xz03 = x[0] & z[3];
    assign yx03 = y[0] & x[3];
    assign yy03 = y[0] & y[3];
    assign yz03 = y[0] & z[3];
    assign zx03 = z[0] & x[3];
    assign zy03 = z[0] & y[3];
    assign zz03 = z[0] & z[3];
    
    assign w03 = xx03 ^ xy03 ^ xz03 ^ yx03; 

    assign xx12 = x[1] & x[2];
    assign xy12 = x[1] & y[2];
    assign xz12 = x[1] & z[2];
    assign yx12 = y[1] & x[2];
    assign yy12 = y[1] & y[2];
    assign yz12 = y[1] & z[2];
    assign zx12 = z[1] & x[2];
    assign zy12 = z[1] & y[2];
    assign zz12 = z[1] & z[2];
    
    assign w12 = xx12 ^ xy12 ^ xz12 ^ yx12; 
    
    assign xx13 = x[1] & x[3];
    assign xy13 = x[1] & y[3];
    assign xz13 = x[1] & z[3];
    assign yx13 = y[1] & x[3];
    assign yy13 = y[1] & y[3];
    assign yz13 = y[1] & z[3];
    assign zx13 = z[1] & x[3];
    assign zy13 = z[1] & y[3];
    assign zz13 = z[1] & z[3];
    
    assign w13 = xx13 ^ xy13 ^ xz13 ^ yx13; 

    assign xx23 = x[2] & x[3];
    assign xy23 = x[2] & y[3];
    assign xz23 = x[2] & z[3];
    assign yx23 = y[2] & x[3];
    assign yy23 = y[2] & y[3];
    assign yz23 = y[2] & z[3];
    assign zx23 = z[2] & x[3];
    assign zy23 = z[2] & y[3];
    assign zz23 = z[2] & z[3];
    
    assign w23 = xx23 ^ xy23 ^ xz23 ^ yx23; 

    assign xxx012 = xx01 & x[2];
    assign xxy012 = xx01 & y[2];
    assign xxz012 = xx01 & z[2];
    assign xyx012 = xy01 & x[2];
    assign xyy012 = xy01 & y[2];
    assign xyz012 = xy01 & z[2];
    assign xzx012 = xz01 & x[2];
    assign xzy012 = xz01 & y[2];
    assign xzz012 = xz01 & z[2];
    assign yxx012 = yx01 & x[2];
    assign yxy012 = yx01 & y[2];
    assign yxz012 = yx01 & z[2];
    assign yyx012 = yy01 & x[2];
    assign yyy012 = yy01 & y[2];
    assign yyz012 = yy01 & z[2];
    assign yzx012 = yz01 & x[2];
    assign yzy012 = yz01 & y[2];
    assign yzz012 = yz01 & z[2];
    assign zxx012 = zx01 & x[2];
    assign zxy012 = zx01 & y[2];
    assign zxz012 = zx01 & z[2];
    assign zyx012 = zy01 & x[2];
    assign zyy012 = zy01 & y[2];
    assign zyz012 = zy01 & z[2];
    assign zzx012 = zz01 & x[2];
    assign zzy012 = zz01 & y[2];
    assign zzz012 = zz01 & z[2];
    
    assign w012 = xxx012 ^ xxy012 ^ xxz012 ^ xyx012 ^ xyy012 ^ xyz012 ^ xzy012 ^ yxx012 ^ yxy012 ^ yxz012 ^ yyx012 ^ yzx012 ^ zxx012 ^ zxy012 ^ zxz012 ^ zyx012; 

    assign xxx013 = xx01 & x[3];
    assign xxy013 = xx01 & y[3];
    assign xxz013 = xx01 & z[3];
    assign xyx013 = xy01 & x[3];
    assign xyy013 = xy01 & y[3];
    assign xyz013 = xy01 & z[3];
    assign xzx013 = xz01 & x[3];
    assign xzy013 = xz01 & y[3];
    assign xzz013 = xz01 & z[3];
    assign yxx013 = yx01 & x[3];
    assign yxy013 = yx01 & y[3];
    assign yxz013 = yx01 & z[3];
    assign yyx013 = yy01 & x[3];
    assign yyy013 = yy01 & y[3];
    assign yyz013 = yy01 & z[3];
    assign yzx013 = yz01 & x[3];
    assign yzy013 = yz01 & y[3];
    assign yzz013 = yz01 & z[3];
    assign zxx013 = zx01 & x[3];
    assign zxy013 = zx01 & y[3];
    assign zxz013 = zx01 & z[3];
    assign zyx013 = zy01 & x[3];
    assign zyy013 = zy01 & y[3];
    assign zyz013 = zy01 & z[3];
    assign zzx013 = zz01 & x[3];
    assign zzy013 = zz01 & y[3];
    assign zzz013 = zz01 & z[3];
    
    assign w013 = xxx013 ^ xxy013 ^ xxz013 ^ xyx013 ^ xyy013 ^ xyz013 ^ xzy013 ^ yxx013 ^ yxy013 ^ yxz013 ^ yyx013 ^ yzx013 ^ zxx013 ^ zxy013 ^ zxz013 ^ zyx013; 

    assign xxx023 = xx02 & x[3];
    assign xxy023 = xx02 & y[3];
    assign xxz023 = xx02 & z[3];
    assign xyx023 = xy02 & x[3];
    assign xyy023 = xy02 & y[3];
    assign xyz023 = xy02 & z[3];
    assign xzx023 = xz02 & x[3];
    assign xzy023 = xz02 & y[3];
    assign xzz023 = xz02 & z[3];
    assign yxx023 = yx02 & x[3];
    assign yxy023 = yx02 & y[3];
    assign yxz023 = yx02 & z[3];
    assign yyx023 = yy02 & x[3];
    assign yyy023 = yy02 & y[3];
    assign yyz023 = yy02 & z[3];
    assign yzx023 = yz02 & x[3];
    assign yzy023 = yz02 & y[3];
    assign yzz023 = yz02 & z[3];
    assign zxx023 = zx02 & x[3];
    assign zxy023 = zx02 & y[3];
    assign zxz023 = zx02 & z[3];
    assign zyx023 = zy02 & x[3];
    assign zyy023 = zy02 & y[3];
    assign zyz023 = zy02 & z[3];
    assign zzx023 = zz02 & x[3];
    assign zzy023 = zz02 & y[3];
    assign zzz023 = zz02 & z[3];
    
    assign w023 = xxx023 ^ xxy023 ^ xxz023 ^ xyx023 ^ xyy023 ^ xyz023 ^ xzy023 ^ yxx023 ^ yxy023 ^ yxz023 ^ yyx023 ^ yzx023 ^ zxx023 ^ zxy023 ^ zxz023 ^ zyx023; 

    assign xxx123 = xx12 & x[3];
    assign xxy123 = xx12 & y[3];
    assign xxz123 = xx12 & z[3];
    assign xyx123 = xy12 & x[3];
    assign xyy123 = xy12 & y[3];
    assign xyz123 = xy12 & z[3];
    assign xzx123 = xz12 & x[3];
    assign xzy123 = xz12 & y[3];
    assign xzz123 = xz12 & z[3];
    assign yxx123 = yx12 & x[3];
    assign yxy123 = yx12 & y[3];
    assign yxz123 = yx12 & z[3];
    assign yyx123 = yy12 & x[3];
    assign yyy123 = yy12 & y[3];
    assign yyz123 = yy12 & z[3];
    assign yzx123 = yz12 & x[3];
    assign yzy123 = yz12 & y[3];
    assign yzz123 = yz12 & z[3];
    assign zxx123 = zx12 & x[3];
    assign zxy123 = zx12 & y[3];
    assign zxz123 = zx12 & z[3];
    assign zyx123 = zy12 & x[3];
    assign zyy123 = zy12 & y[3];
    assign zyz123 = zy12 & z[3];
    assign zzx123 = zz12 & x[3];
    assign zzy123 = zz12 & y[3];
    assign zzz123 = zz12 & z[3];
    
    assign w123 = xxx123 ^ xxy123 ^ xxz123 ^ xyx123 ^ xyy123 ^ xyz123 ^ xzy123 ^ yxx123 ^ yxy123 ^ yxz123 ^ yyx123 ^ yzx123 ^ zxx123 ^ zxy123 ^ zxz123 ^ zyx123; 

    assign z_w_tmp[0] = ~w2 ^ w3 ^ w01 ^ w03 ^ w12 ^ w23 ^ w012;
    assign z_w_tmp[1] = ~w02 ^ w12 ^ w13 ^ w012 ^ w123;
    assign z_w_tmp[2] = w0 ^ w3 ^ w01 ^ w03 ^ w13 ^ w013 ^ w123;  
    assign z_w_tmp[3] = ~w1 ^ w3 ^ w12 ^ w23 ^ w012 ^ w013 ^ w023;
    
     // Remasking according to changing of the guards
     assign z_w = z_w_tmp ^ c ^ d;
endmodule
