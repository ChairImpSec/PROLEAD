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

module component_function_v(
    input [3:0] w,
    input [3:0] x,
    input [3:0] y,
    input [3:0] z,
    output [3:0] z_v
    );
    
    wire v0,w0,x0,y0,z0, v1,w1,x1,y1,z1, v2,w2,x2,y2,z2, v3,w3,x3,y3,z3;
    wire aw0,ax0,ay0,az0, aw1,ax1,ay1,az1, aw2,ax2,ay2,az2, aw3,ax3,ay3,az3;
    
    wire ww01,wx01,wy01,wz01, xw01,xx01,xy01,xz01, yw01,yx01,yy01,yz01, zw01,zx01,zy01,zz01;
    wire ww02,wx02,wy02,wz02, xw02,xx02,xy02,xz02, yw02,yx02,yy02,yz02, zw02,zx02,zy02,zz02;
    wire ww03,wx03,wy03,wz03, xw03,xx03,xy03,xz03, yw03,yx03,yy03,yz03, zw03,zx03,zy03,zz03;
    wire ww12,wx12,wy12,wz12, xw12,xx12,xy12,xz12, yw12,yx12,yy12,yz12, zw12,zx12,zy12,zz12;
    wire ww13,wx13,wy13,wz13, xw13,xx13,xy13,xz13, yw13,yx13,yy13,yz13, zw13,zx13,zy13,zz13;
    wire ww23,wx23,wy23,wz23, xw23,xx23,xy23,xz23, yw23,yx23,yy23,yz23, zw23,zx23,zy23,zz23;
    
    wire www012,wwx012,wwy012,wwz012, wxw012,wxx012,wxy012,wxz012, wyw012,wyx012,wyy012,wyz012, wzw012,wzx012,wzy012,wzz012;
    wire xww012,xwx012,xwy012,xwz012, xxw012,xxx012,xxy012,xxz012, xyw012,xyx012,xyy012,xyz012, xzw012,xzx012,xzy012,xzz012;
    wire yww012,ywx012,ywy012,ywz012, yxw012,yxx012,yxy012,yxz012, yyw012,yyx012,yyy012,yyz012, yzw012,yzx012,yzy012,yzz012;
    wire zww012,zwx012,zwy012,zwz012, zxw012,zxx012,zxy012,zxz012, zyw012,zyx012,zyy012,zyz012, zzw012,zzx012,zzy012,zzz012;

    wire www013,wwx013,wwy013,wwz013, wxw013,wxx013,wxy013,wxz013, wyw013,wyx013,wyy013,wyz013, wzw013,wzx013,wzy013,wzz013;
    wire xww013,xwx013,xwy013,xwz013, xxw013,xxx013,xxy013,xxz013, xyw013,xyx013,xyy013,xyz013, xzw013,xzx013,xzy013,xzz013;
    wire yww013,ywx013,ywy013,ywz013, yxw013,yxx013,yxy013,yxz013, yyw013,yyx013,yyy013,yyz013, yzw013,yzx013,yzy013,yzz013;
    wire zww013,zwx013,zwy013,zwz013, zxw013,zxx013,zxy013,zxz013, zyw013,zyx013,zyy013,zyz013, zzw013,zzx013,zzy013,zzz013;
    
    wire www023,wwx023,wwy023,wwz023, wxw023,wxx023,wxy023,wxz023, wyw023,wyx023,wyy023,wyz023, wzw023,wzx023,wzy023,wzz023;
    wire xww023,xwx023,xwy023,xwz023, xxw023,xxx023,xxy023,xxz023, xyw023,xyx023,xyy023,xyz023, xzw023,xzx023,xzy023,xzz023;
    wire yww023,ywx023,ywy023,ywz023, yxw023,yxx023,yxy023,yxz023, yyw023,yyx023,yyy023,yyz023, yzw023,yzx023,yzy023,yzz023;
    wire zww023,zwx023,zwy023,zwz023, zxw023,zxx023,zxy023,zxz023, zyw023,zyx023,zyy023,zyz023, zzw023,zzx023,zzy023,zzz023;
    
    wire www123,wwx123,wwy123,wwz123, wxw123,wxx123,wxy123,wxz123, wyw123,wyx123,wyy123,wyz123, wzw123,wzx123,wzy123,wzz123;
    wire xww123,xwx123,xwy123,xwz123, xxw123,xxx123,xxy123,xxz123, xyw123,xyx123,xyy123,xyz123, xzw123,xzx123,xzy123,xzz123;
    wire yww123,ywx123,ywy123,ywz123, yxw123,yxx123,yxy123,yxz123, yyw123,yyx123,yyy123,yyz123, yzw123,yzx123,yzy123,yzz123;
    wire zww123,zwx123,zwy123,zwz123, zxw123,zxx123,zxy123,zxz123, zyw123,zyx123,zyy123,zyz123, zzw123,zzx123,zzy123,zzz123;
    
    wire v01, w01, x01, y01, z01;
    wire v02, w02, x02, y02, z02;
    wire v03, w03, x03, y03, z03;
    wire v12, w12, x12, y12, z12;
    wire v13, w13, x13, y13, z13;
    wire v23, w23, x23, y23, z23;
    
    wire v012, w012, x012, y012, z012;
    wire v013, w013, x013, y013, z013;
    wire v023, w023, x023, y023, z023;
    wire v123, w123, x123, y123, z123;
    
    // apply affine linear transformation
    assign aw0 = w[0];
    assign ax0 = x[0];
    assign ay0 = y[0];
    assign az0 = z[0];
    
    assign aw1 = w[1] ^ w[3];
    assign ax1 = x[1] ^ x[3];
    assign ay1 = y[1] ^ y[3];
    assign az1 = z[1] ^ z[3];
    
    assign aw2 = w[2];
    assign ax2 = x[2];
    assign ay2 = y[2];
    assign az2 = z[2];
    
    assign aw3 = w[3];
    assign ax3 = x[3];
    assign ay3 = y[3];
    assign az3 = z[3];
    
    assign v0 = aw0;
    assign w0 = ax0;
    assign x0 = ay0;
    assign y0 = az0;
    
    assign v1 = aw1;
    assign w1 = ax1;
    assign x1 = ay1;
    assign y1 = az1;
    
    assign v2 = aw2;
    assign w2 = ax2;
    assign x2 = ay2;
    assign y2 = az2;
    
    assign v3 = aw3;
    assign w3 = ax3;
    assign x3 = ay3;
    assign y3 = az3;
    
    assign ww01 = aw0 & aw1;
    assign wx01 = aw0 & ax1;
    assign wy01 = aw0 & ay1;
    assign wz01 = aw0 & az1;
    assign xw01 = ax0 & aw1;
    assign xx01 = ax0 & ax1;
    assign xy01 = ax0 & ay1;
    assign xz01 = ax0 & az1;
    assign yw01 = ay0 & aw1;
    assign yx01 = ay0 & ax1;
    assign yy01 = ay0 & ay1;
    assign yz01 = ay0 & az1;   
    assign zw01 = az0 & aw1;
    assign zx01 = az0 & ax1;
    assign zy01 = az0 & ay1;
    assign zz01 = az0 & az1;
    
    assign v01 = ww01 ^ wx01 ^ xw01 ^ wy01 ^ yw01;
    
    assign ww02 = aw0 & aw2;
    assign wx02 = aw0 & ax2;
    assign wy02 = aw0 & ay2;
    assign wz02 = aw0 & az2;
    assign xw02 = ax0 & aw2;
    assign xx02 = ax0 & ax2;
    assign xy02 = ax0 & ay2;
    assign xz02 = ax0 & az2;
    assign yw02 = ay0 & aw2;
    assign yx02 = ay0 & ax2;
    assign yy02 = ay0 & ay2;
    assign yz02 = ay0 & az2;   
    assign zw02 = az0 & aw2;
    assign zx02 = az0 & ax2;
    assign zy02 = az0 & ay2;
    assign zz02 = az0 & az2;
    
    assign v02 = ww02 ^ wx02 ^ xw02 ^ wy02 ^ yw02;
    
    assign ww03 = aw0 & aw3;
    assign wx03 = aw0 & ax3;
    assign wy03 = aw0 & ay3;
    assign wz03 = aw0 & az3;
    assign xw03 = ax0 & aw3;
    assign xx03 = ax0 & ax3;
    assign xy03 = ax0 & ay3;
    assign xz03 = ax0 & az3;
    assign yw03 = ay0 & aw3;
    assign yx03 = ay0 & ax3;
    assign yy03 = ay0 & ay3;
    assign yz03 = ay0 & az3;   
    assign zw03 = az0 & aw3;
    assign zx03 = az0 & ax3;
    assign zy03 = az0 & ay3;
    assign zz03 = az0 & az3;
    
    assign v03 = ww03 ^ wx03 ^ xw03 ^ wy03 ^ yw03;
    
    assign ww12 = aw1 & aw2;
    assign wx12 = aw1 & ax2;
    assign wy12 = aw1 & ay2;
    assign wz12 = aw1 & az2;
    assign xw12 = ax1 & aw2;
    assign xx12 = ax1 & ax2;
    assign xy12 = ax1 & ay2;
    assign xz12 = ax1 & az2;
    assign yw12 = ay1 & aw2;
    assign yx12 = ay1 & ax2;
    assign yy12 = ay1 & ay2;
    assign yz12 = ay1 & az2;   
    assign zw12 = az1 & aw2;
    assign zx12 = az1 & ax2;
    assign zy12 = az1 & ay2;
    assign zz12 = az1 & az2;
    
    assign v12 = ww12 ^ wx12 ^ xw12 ^ wy12 ^ yw12;
    
    assign ww13 = aw1 & aw3;
    assign wx13 = aw1 & ax3;
    assign wy13 = aw1 & ay3;
    assign wz13 = aw1 & az3;
    assign xw13 = ax1 & aw3;
    assign xx13 = ax1 & ax3;
    assign xy13 = ax1 & ay3;
    assign xz13 = ax1 & az3;
    assign yw13 = ay1 & aw3;
    assign yx13 = ay1 & ax3;
    assign yy13 = ay1 & ay3;
    assign yz13 = ay1 & az3;   
    assign zw13 = az1 & aw3;
    assign zx13 = az1 & ax3;
    assign zy13 = az1 & ay3;
    assign zz13 = az1 & az3;
    
    assign v13 = ww13 ^ wx13 ^ xw13 ^ wy13 ^ yw13;

    assign ww23 = aw2 & aw3;
    assign wx23 = aw2 & ax3;
    assign wy23 = aw2 & ay3;
    assign wz23 = aw2 & az3;
    assign xw23 = ax2 & aw3;
    assign xx23 = ax2 & ax3;
    assign xy23 = ax2 & ay3;
    assign xz23 = ax2 & az3;
    assign yw23 = ay2 & aw3;
    assign yx23 = ay2 & ax3;
    assign yy23 = ay2 & ay3;
    assign yz23 = ay2 & az3;   
    assign zw23 = az2 & aw3;
    assign zx23 = az2 & ax3;
    assign zy23 = az2 & ay3;
    assign zz23 = az2 & az3;
    
    assign v23 = ww23 ^ wx23 ^ xw23 ^ wy23 ^ yw23;
    
    assign www012 = ww01 & aw2;
    assign wwx012 = ww01 & ax2;
    assign wwy012 = ww01 & ay2;
    assign wwz012 = ww01 & az2;
    assign wxw012 = wx01 & aw2;
    assign wxx012 = wx01 & ax2;
    assign wxy012 = wx01 & ay2;
    assign wxz012 = wx01 & az2;
    assign wyw012 = wy01 & aw2;
    assign wyx012 = wy01 & ax2;
    assign wyy012 = wy01 & ay2;
    assign wyz012 = wy01 & az2;
    assign wzw012 = wz01 & aw2;
    assign wzx012 = wz01 & ax2;
    assign wzy012 = wz01 & ay2;
    assign wzz012 = wz01 & az2;
    assign xww012 = xw01 & aw2;
    assign xwx012 = xw01 & ax2;
    assign xwy012 = xw01 & ay2;
    assign xwz012 = xw01 & az2;
    assign xxw012 = xx01 & aw2;
    assign xxx012 = xx01 & ax2;
    assign xxy012 = xx01 & ay2;
    assign xxz012 = xx01 & az2;
    assign xyw012 = xy01 & aw2;
    assign xyx012 = xy01 & ax2;
    assign xyy012 = xy01 & ay2;
    assign xyz012 = xy01 & az2;
    assign xzw012 = xz01 & aw2;
    assign xzx012 = xz01 & ax2;
    assign xzy012 = xz01 & ay2;
    assign xzz012 = xz01 & az2;
    assign yww012 = yw01 & aw2;
    assign ywx012 = yw01 & ax2;
    assign ywy012 = yw01 & ay2;
    assign ywz012 = yw01 & az2;
    assign yxw012 = yx01 & aw2;
    assign yxx012 = yx01 & ax2;
    assign yxy012 = yx01 & ay2;
    assign yxz012 = yx01 & az2;
    assign yyw012 = yy01 & aw2;
    assign yyx012 = yy01 & ax2;
    assign yyy012 = yy01 & ay2;
    assign yyz012 = yy01 & az2;
    assign yzw012 = yz01 & aw2;
    assign yzx012 = yz01 & ax2;
    assign yzy012 = yz01 & ay2;
    assign yzz012 = yz01 & az2; 
    assign zww012 = zw01 & aw2;
    assign zwx012 = zw01 & ax2;
    assign zwy012 = zw01 & ay2;
    assign zwz012 = zw01 & az2;
    assign zxw012 = zx01 & aw2;
    assign zxx012 = zx01 & ax2;
    assign zxy012 = zx01 & ay2;
    assign zxz012 = zx01 & az2;
    assign zyw012 = zy01 & aw2;
    assign zyx012 = zy01 & ax2;
    assign zyy012 = zy01 & ay2;
    assign zyz012 = zy01 & az2;
    assign zzw012 = zz01 & aw2;
    assign zzx012 = zz01 & ax2;
    assign zzy012 = zz01 & ay2;
    assign zzz012 = zz01 & az2;
    
    assign v012 = www012 ^ wwx012 ^ wxw012 ^ wxx012 ^ xww012 ^ xwx012 ^ xxw012 ^ wwy012 ^ wyw012 ^ wyy012 ^ yww012 ^ ywy012 ^ yyw012 ^ wxy012 ^ wyx012 ^ xwy012 ^ xyw012 ^ ywx012 ^ yxw012 ^ wxz012 ^ wzx012 ^ xwz012 ^ xzw012 ^ zwx012 ^ zxw012;  

    assign www013 = ww01 & aw3;
    assign wwx013 = ww01 & ax3;
    assign wwy013 = ww01 & ay3;
    assign wwz013 = ww01 & az3;
    assign wxw013 = wx01 & aw3;
    assign wxx013 = wx01 & ax3;
    assign wxy013 = wx01 & ay3;
    assign wxz013 = wx01 & az3;
    assign wyw013 = wy01 & aw3;
    assign wyx013 = wy01 & ax3;
    assign wyy013 = wy01 & ay3;
    assign wyz013 = wy01 & az3;
    assign wzw013 = wz01 & aw3;
    assign wzx013 = wz01 & ax3;
    assign wzy013 = wz01 & ay3;
    assign wzz013 = wz01 & az3;
    assign xww013 = xw01 & aw3;
    assign xwx013 = xw01 & ax3;
    assign xwy013 = xw01 & ay3;
    assign xwz013 = xw01 & az3;
    assign xxw013 = xx01 & aw3;
    assign xxx013 = xx01 & ax3;
    assign xxy013 = xx01 & ay3;
    assign xxz013 = xx01 & az3;
    assign xyw013 = xy01 & aw3;
    assign xyx013 = xy01 & ax3;
    assign xyy013 = xy01 & ay3;
    assign xyz013 = xy01 & az3;
    assign xzw013 = xz01 & aw3;
    assign xzx013 = xz01 & ax3;
    assign xzy013 = xz01 & ay3;
    assign xzz013 = xz01 & az3;
    assign yww013 = yw01 & aw3;
    assign ywx013 = yw01 & ax3;
    assign ywy013 = yw01 & ay3;
    assign ywz013 = yw01 & az3;
    assign yxw013 = yx01 & aw3;
    assign yxx013 = yx01 & ax3;
    assign yxy013 = yx01 & ay3;
    assign yxz013 = yx01 & az3;
    assign yyw013 = yy01 & aw3;
    assign yyx013 = yy01 & ax3;
    assign yyy013 = yy01 & ay3;
    assign yyz013 = yy01 & az3;
    assign yzw013 = yz01 & aw3;
    assign yzx013 = yz01 & ax3;
    assign yzy013 = yz01 & ay3;
    assign yzz013 = yz01 & az3; 
    assign zww013 = zw01 & aw3;
    assign zwx013 = zw01 & ax3;
    assign zwy013 = zw01 & ay3;
    assign zwz013 = zw01 & az3;
    assign zxw013 = zx01 & aw3;
    assign zxx013 = zx01 & ax3;
    assign zxy013 = zx01 & ay3;
    assign zxz013 = zx01 & az3;
    assign zyw013 = zy01 & aw3;
    assign zyx013 = zy01 & ax3;
    assign zyy013 = zy01 & ay3;
    assign zyz013 = zy01 & az3;
    assign zzw013 = zz01 & aw3;
    assign zzx013 = zz01 & ax3;
    assign zzy013 = zz01 & ay3;
    assign zzz013 = zz01 & az3;
    
    assign v013 = www013 ^ wwx013 ^ wxw013 ^ wxx013 ^ xww013 ^ xwx013 ^ xxw013 ^ wwy013 ^ wyw013 ^ wyy013 ^ yww013 ^ ywy013 ^ yyw013 ^ wxy013 ^ wyx013 ^ xwy013 ^ xyw013 ^ ywx013 ^ yxw013 ^ wxz013 ^ wzx013 ^ xwz013 ^ xzw013 ^ zwx013 ^ zxw013;  

    assign www023 = ww02 & aw3;
    assign wwx023 = ww02 & ax3;
    assign wwy023 = ww02 & ay3;
    assign wwz023 = ww02 & az3;
    assign wxw023 = wx02 & aw3;
    assign wxx023 = wx02 & ax3;
    assign wxy023 = wx02 & ay3;
    assign wxz023 = wx02 & az3;
    assign wyw023 = wy02 & aw3;
    assign wyx023 = wy02 & ax3;
    assign wyy023 = wy02 & ay3;
    assign wyz023 = wy02 & az3;
    assign wzw023 = wz02 & aw3;
    assign wzx023 = wz02 & ax3;
    assign wzy023 = wz02 & ay3;
    assign wzz023 = wz02 & az3;
    assign xww023 = xw02 & aw3;
    assign xwx023 = xw02 & ax3;
    assign xwy023 = xw02 & ay3;
    assign xwz023 = xw02 & az3;
    assign xxw023 = xx02 & aw3;
    assign xxx023 = xx02 & ax3;
    assign xxy023 = xx02 & ay3;
    assign xxz023 = xx02 & az3;
    assign xyw023 = xy02 & aw3;
    assign xyx023 = xy02 & ax3;
    assign xyy023 = xy02 & ay3;
    assign xyz023 = xy02 & az3;
    assign xzw023 = xz02 & aw3;
    assign xzx023 = xz02 & ax3;
    assign xzy023 = xz02 & ay3;
    assign xzz023 = xz02 & az3;
    assign yww023 = yw02 & aw3;
    assign ywx023 = yw02 & ax3;
    assign ywy023 = yw02 & ay3;
    assign ywz023 = yw02 & az3;
    assign yxw023 = yx02 & aw3;
    assign yxx023 = yx02 & ax3;
    assign yxy023 = yx02 & ay3;
    assign yxz023 = yx02 & az3;
    assign yyw023 = yy02 & aw3;
    assign yyx023 = yy02 & ax3;
    assign yyy023 = yy02 & ay3;
    assign yyz023 = yy02 & az3;
    assign yzw023 = yz02 & aw3;
    assign yzx023 = yz02 & ax3;
    assign yzy023 = yz02 & ay3;
    assign yzz023 = yz02 & az3; 
    assign zww023 = zw02 & aw3;
    assign zwx023 = zw02 & ax3;
    assign zwy023 = zw02 & ay3;
    assign zwz023 = zw02 & az3;
    assign zxw023 = zx02 & aw3;
    assign zxx023 = zx02 & ax3;
    assign zxy023 = zx02 & ay3;
    assign zxz023 = zx02 & az3;
    assign zyw023 = zy02 & aw3;
    assign zyx023 = zy02 & ax3;
    assign zyy023 = zy02 & ay3;
    assign zyz023 = zy02 & az3;
    assign zzw023 = zz02 & aw3;
    assign zzx023 = zz02 & ax3;
    assign zzy023 = zz02 & ay3;
    assign zzz023 = zz02 & az3;
    
    assign v023 = www023 ^ wwx023 ^ wxw023 ^ wxx023 ^ xww023 ^ xwx023 ^ xxw023 ^ wwy023 ^ wyw023 ^ wyy023 ^ yww023 ^ ywy023 ^ yyw023 ^ wxy023 ^ wyx023 ^ xwy023 ^ xyw023 ^ ywx023 ^ yxw023 ^ wxz023 ^ wzx023 ^ xwz023 ^ xzw023 ^ zwx023 ^ zxw023;  

    assign www123 = ww12 & aw3;
    assign wwx123 = ww12 & ax3;
    assign wwy123 = ww12 & ay3;
    assign wwz123 = ww12 & az3;
    assign wxw123 = wx12 & aw3;
    assign wxx123 = wx12 & ax3;
    assign wxy123 = wx12 & ay3;
    assign wxz123 = wx12 & az3;
    assign wyw123 = wy12 & aw3;
    assign wyx123 = wy12 & ax3;
    assign wyy123 = wy12 & ay3;
    assign wyz123 = wy12 & az3;
    assign wzw123 = wz12 & aw3;
    assign wzx123 = wz12 & ax3;
    assign wzy123 = wz12 & ay3;
    assign wzz123 = wz12 & az3;
    assign xww123 = xw12 & aw3;
    assign xwx123 = xw12 & ax3;
    assign xwy123 = xw12 & ay3;
    assign xwz123 = xw12 & az3;
    assign xxw123 = xx12 & aw3;
    assign xxx123 = xx12 & ax3;
    assign xxy123 = xx12 & ay3;
    assign xxz123 = xx12 & az3;
    assign xyw123 = xy12 & aw3;
    assign xyx123 = xy12 & ax3;
    assign xyy123 = xy12 & ay3;
    assign xyz123 = xy12 & az3;
    assign xzw123 = xz12 & aw3;
    assign xzx123 = xz12 & ax3;
    assign xzy123 = xz12 & ay3;
    assign xzz123 = xz12 & az3;
    assign yww123 = yw12 & aw3;
    assign ywx123 = yw12 & ax3;
    assign ywy123 = yw12 & ay3;
    assign ywz123 = yw12 & az3;
    assign yxw123 = yx12 & aw3;
    assign yxx123 = yx12 & ax3;
    assign yxy123 = yx12 & ay3;
    assign yxz123 = yx12 & az3;
    assign yyw123 = yy12 & aw3;
    assign yyx123 = yy12 & ax3;
    assign yyy123 = yy12 & ay3;
    assign yyz123 = yy12 & az3;
    assign yzw123 = yz12 & aw3;
    assign yzx123 = yz12 & ax3;
    assign yzy123 = yz12 & ay3;
    assign yzz123 = yz12 & az3; 
    assign zww123 = zw12 & aw3;
    assign zwx123 = zw12 & ax3;
    assign zwy123 = zw12 & ay3;
    assign zwz123 = zw12 & az3;
    assign zxw123 = zx12 & aw3;
    assign zxx123 = zx12 & ax3;
    assign zxy123 = zx12 & ay3;
    assign zxz123 = zx12 & az3;
    assign zyw123 = zy12 & aw3;
    assign zyx123 = zy12 & ax3;
    assign zyy123 = zy12 & ay3;
    assign zyz123 = zy12 & az3;
    assign zzw123 = zz12 & aw3;
    assign zzx123 = zz12 & ax3;
    assign zzy123 = zz12 & ay3;
    assign zzz123 = zz12 & az3;
    
    assign v123 = www123 ^ wwx123 ^ wxw123 ^ wxx123 ^ xww123 ^ xwx123 ^ xxw123 ^ wwy123 ^ wyw123 ^ wyy123 ^ yww123 ^ ywy123 ^ yyw123 ^ wxy123 ^ wyx123 ^ xwy123 ^ xyw123 ^ ywx123 ^ yxw123 ^ wxz123 ^ wzx123 ^ xwz123 ^ xzw123 ^ zwx123 ^ zxw123;  

    assign z_v[0] = ~v01 ^ v2 ^ v12 ^ v012 ^ v3 ^ v023;
    assign z_v[1] = ~v02 ^ v12 ^ v012 ^ v3 ^ v13 ^ v023 ^ v123;
    assign z_v[2] = v0 ^ v01 ^ v03 ^ v13 ^ v013 ^ v23 ^ v123;
    assign z_v[3] = ~v1 ^ v12 ^ v012 ^ v03 ^ v013;
endmodule
