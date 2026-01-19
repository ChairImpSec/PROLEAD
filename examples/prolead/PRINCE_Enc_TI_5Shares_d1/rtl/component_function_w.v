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
    input [3:0] v,
    input [3:0] x,
    input [3:0] y,
    input [3:0] z,
    output [3:0] z_w
    );
    
    wire v0,w0,x0,y0,z0, v1,w1,x1,y1,z1, v2,w2,x2,y2,z2, v3,w3,x3,y3,z3;
    wire av0,ax0,ay0,az0, av1,ax1,ay1,az1, av2,ax2,ay2,az2, av3,ax3,ay3,az3;
    
    wire vv01,vw01,vx01,vy01,vz01, xv01,xw01,xx01,xy01,xz01, yv01,yw01,yx01,yy01,yz01, zv01,zw01,zx01,zy01,zz01;
    wire vv02,vw02,vx02,vy02,vz02, xv02,xw02,xx02,xy02,xz02, yv02,yw02,yx02,yy02,yz02, zv02,zw02,zx02,zy02,zz02;
    wire vv03,vw03,vx03,vy03,vz03, xv03,xw03,xx03,xy03,xz03, yv03,yw03,yx03,yy03,yz03, zv03,zw03,zx03,zy03,zz03;
    wire vv12,vw12,vx12,vy12,vz12, xv12,xw12,xx12,xy12,xz12, yv12,yw12,yx12,yy12,yz12, zv12,zw12,zx12,zy12,zz12;
    wire vv13,vw13,vx13,vy13,vz13, xv13,xw13,xx13,xy13,xz13, yv13,yw13,yx13,yy13,yz13, zv13,zw13,zx13,zy13,zz13;
    wire vv23,vw23,vx23,vy23,vz23, xv23,xw23,xx23,xy23,xz23, yv23,yw23,yx23,yy23,yz23, zv23,zw23,zx23,zy23,zz23;
    
    wire vvv012,vvx012,vvy012,vvz012, vxv012,vxx012,vxy012,vxz012, vyv012,vyx012,vyy012,vyz012, vzv012,vzx012,vzy012,vzz012;
    wire xvv012,xvx012,xvy012,xvz012, xxv012,xxx012,xxy012,xxz012, xyv012,xyx012,xyy012,xyz012, xzv012,xzx012,xzy012,xzz012;
    wire yvv012,yvx012,yvy012,yvz012, yxv012,yxx012,yxy012,yxz012, yyv012,yyx012,yyy012,yyz012, yzv012,yzx012,yzy012,yzz012;
    wire zvv012,zvx012,zvy012,zvz012, zxv012,zxx012,zxy012,zxz012, zyv012,zyx012,zyy012,zyz012, zzv012,zzx012,zzy012,zzz012;

    wire vvv013,vvx013,vvy013,vvz013, vxv013,vxx013,vxy013,vxz013, vyv013,vyx013,vyy013,vyz013, vzv013,vzx013,vzy013,vzz013;
    wire xvv013,xvx013,xvy013,xvz013, xxv013,xxx013,xxy013,xxz013, xyv013,xyx013,xyy013,xyz013, xzv013,xzx013,xzy013,xzz013;
    wire yvv013,yvx013,yvy013,yvz013, yxv013,yxx013,yxy013,yxz013, yyv013,yyx013,yyy013,yyz013, yzv013,yzx013,yzy013,yzz013;
    wire zvv013,zvx013,zvy013,zvz013, zxv013,zxx013,zxy013,zxz013, zyv013,zyx013,zyy013,zyz013, zzv013,zzx013,zzy013,zzz013;
    
    wire vvv023,vvx023,vvy023,vvz023, vxv023,vxx023,vxy023,vxz023, vyv023,vyx023,vyy023,vyz023, vzv023,vzx023,vzy023,vzz023;
    wire xvv023,xvx023,xvy023,xvz023, xxv023,xxx023,xxy023,xxz023, xyv023,xyx023,xyy023,xyz023, xzv023,xzx023,xzy023,xzz023;
    wire yvv023,yvx023,yvy023,yvz023, yxv023,yxx023,yxy023,yxz023, yyv023,yyx023,yyy023,yyz023, yzv023,yzx023,yzy023,yzz023;
    wire zvv023,zvx023,zvy023,zvz023, zxv023,zxx023,zxy023,zxz023, zyv023,zyx023,zyy023,zyz023, zzv023,zzx023,zzy023,zzz023;
    
    wire vvv123,vvx123,vvy123,vvz123, vxv123,vxx123,vxy123,vxz123, vyv123,vyx123,vyy123,vyz123, vzv123,vzx123,vzy123,vzz123;
    wire xvv123,xvx123,xvy123,xvz123, xxv123,xxx123,xxy123,xxz123, xyv123,xyx123,xyy123,xyz123, xzv123,xzx123,xzy123,xzz123;
    wire yvv123,yvx123,yvy123,yvz123, yxv123,yxx123,yxy123,yxz123, yyv123,yyx123,yyy123,yyz123, yzv123,yzx123,yzy123,yzz123;
    wire zvv123,zvx123,zvy123,zvz123, zxv123,zxx123,zxy123,zxz123, zyv123,zyx123,zyy123,zyz123, zzv123,zzx123,zzy123,zzz123;
    
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
    assign av0 = v[0];
    assign ax0 = x[0];
    assign ay0 = y[0];
    assign az0 = z[0];
    
    assign av1 = v[1] ^ v[3];
    assign ax1 = x[1] ^ x[3];
    assign ay1 = y[1] ^ y[3];
    assign az1 = z[1] ^ z[3];
    
    assign av2 = v[2];
    assign ax2 = x[2];
    assign ay2 = y[2];
    assign az2 = z[2];
    
    assign av3 = v[3];
    assign ax3 = x[3];
    assign ay3 = y[3];
    assign az3 = z[3];
    
    assign w0 = ax0;
    assign x0 = ay0;
    assign y0 = az0;
    assign z0 = av0;
    
    assign w1 = ax1;
    assign x1 = ay1;
    assign y1 = az1;
    assign z1 = av1;
    
    assign w2 = ax2;
    assign x2 = ay2;
    assign y2 = az2;
    assign z2 = av2;
    
    assign w3 = ax3;
    assign x3 = ay3;
    assign y3 = az3;
    assign z3 = av3;
    
    assign vv01 = av0 & av1;
    assign vx01 = av0 & ax1;
    assign vy01 = av0 & ay1;
    assign vz01 = av0 & az1;
    assign xv01 = ax0 & av1;
    assign xx01 = ax0 & ax1;
    assign xy01 = ax0 & ay1;
    assign xz01 = ax0 & az1;
    assign yv01 = ay0 & av1;
    assign yx01 = ay0 & ax1;
    assign yy01 = ay0 & ay1;
    assign yz01 = ay0 & az1;   
    assign zv01 = az0 & av1;
    assign zx01 = az0 & ax1;
    assign zy01 = az0 & ay1;
    assign zz01 = az0 & az1;
    
    assign w01 = xx01 ^ xy01 ^ yx01 ^ xz01 ^ zx01;
    
    assign vv02 = av0 & av2;
    assign vx02 = av0 & ax2;
    assign vy02 = av0 & ay2;
    assign vz02 = av0 & az2;
    assign xv02 = ax0 & av2;
    assign xx02 = ax0 & ax2;
    assign xy02 = ax0 & ay2;
    assign xz02 = ax0 & az2;
    assign yv02 = ay0 & av2;
    assign yx02 = ay0 & ax2;
    assign yy02 = ay0 & ay2;
    assign yz02 = ay0 & az2;   
    assign zv02 = az0 & av2;
    assign zx02 = az0 & ax2;
    assign zy02 = az0 & ay2;
    assign zz02 = az0 & az2;
    
    assign w02 = xx02 ^ xy02 ^ yx02 ^ xz02 ^ zx02;
    
    assign vv03 = av0 & av3;
    assign vx03 = av0 & ax3;
    assign vy03 = av0 & ay3;
    assign vz03 = av0 & az3;
    assign xv03 = ax0 & av3;
    assign xx03 = ax0 & ax3;
    assign xy03 = ax0 & ay3;
    assign xz03 = ax0 & az3;
    assign yv03 = ay0 & av3;
    assign yx03 = ay0 & ax3;
    assign yy03 = ay0 & ay3;
    assign yz03 = ay0 & az3;   
    assign zv03 = az0 & av3;
    assign zx03 = az0 & ax3;
    assign zy03 = az0 & ay3;
    assign zz03 = az0 & az3;
    
    assign w03 = xx03 ^ xy03 ^ yx03 ^ xz03 ^ zx03;
    
    assign vv12 = av1 & av2;
    assign vx12 = av1 & ax2;
    assign vy12 = av1 & ay2;
    assign vz12 = av1 & az2;
    assign xv12 = ax1 & av2;
    assign xx12 = ax1 & ax2;
    assign xy12 = ax1 & ay2;
    assign xz12 = ax1 & az2;
    assign yv12 = ay1 & av2;
    assign yx12 = ay1 & ax2;
    assign yy12 = ay1 & ay2;
    assign yz12 = ay1 & az2;   
    assign zv12 = az1 & av2;
    assign zx12 = az1 & ax2;
    assign zy12 = az1 & ay2;
    assign zz12 = az1 & az2;
    
    assign w12 = xx12 ^ xy12 ^ yx12 ^ xz12 ^ zx12;
    
    assign vv13 = av1 & av3;
    assign vx13 = av1 & ax3;
    assign vy13 = av1 & ay3;
    assign vz13 = av1 & az3;
    assign xv13 = ax1 & av3;
    assign xx13 = ax1 & ax3;
    assign xy13 = ax1 & ay3;
    assign xz13 = ax1 & az3;
    assign yv13 = ay1 & av3;
    assign yx13 = ay1 & ax3;
    assign yy13 = ay1 & ay3;
    assign yz13 = ay1 & az3;   
    assign zv13 = az1 & av3;
    assign zx13 = az1 & ax3;
    assign zy13 = az1 & ay3;
    assign zz13 = az1 & az3;
    
    assign w13 = xx13 ^ xy13 ^ yx13 ^ xz13 ^ zx13;
    
    assign vv23 = av2 & av3;
    assign vx23 = av2 & ax3;
    assign vy23 = av2 & ay3;
    assign vz23 = av2 & az3;
    assign xv23 = ax2 & av3;
    assign xx23 = ax2 & ax3;
    assign xy23 = ax2 & ay3;
    assign xz23 = ax2 & az3;
    assign yv23 = ay2 & av3;
    assign yx23 = ay2 & ax3;
    assign yy23 = ay2 & ay3;
    assign yz23 = ay2 & az3;   
    assign zv23 = az2 & av3;
    assign zx23 = az2 & ax3;
    assign zy23 = az2 & ay3;
    assign zz23 = az2 & az3;
    
    assign w23 = xx23 ^ xy23 ^ yx23 ^ xz23 ^ zx23;

    
    assign vvv012 = vv01 & av2;
    assign vvx012 = vv01 & ax2;
    assign vvy012 = vv01 & ay2;
    assign vvz012 = vv01 & az2;
    assign vxv012 = vx01 & av2;
    assign vxx012 = vx01 & ax2;
    assign vxy012 = vx01 & ay2;
    assign vxz012 = vx01 & az2;
    assign vyv012 = vy01 & av2;
    assign vyx012 = vy01 & ax2;
    assign vyy012 = vy01 & ay2;
    assign vyz012 = vy01 & az2;
    assign vzv012 = vz01 & av2;
    assign vzx012 = vz01 & ax2;
    assign vzy012 = vz01 & ay2;
    assign vzz012 = vz01 & az2;
    assign xvv012 = xv01 & av2;
    assign xvx012 = xv01 & ax2;
    assign xvy012 = xv01 & ay2;
    assign xvz012 = xv01 & az2;
    assign xxv012 = xx01 & av2;
    assign xxx012 = xx01 & ax2;
    assign xxy012 = xx01 & ay2;
    assign xxz012 = xx01 & az2;
    assign xyv012 = xy01 & av2;
    assign xyx012 = xy01 & ax2;
    assign xyy012 = xy01 & ay2;
    assign xyz012 = xy01 & az2;
    assign xzv012 = xz01 & av2;
    assign xzx012 = xz01 & ax2;
    assign xzy012 = xz01 & ay2;
    assign xzz012 = xz01 & az2;
    assign yvv012 = yv01 & av2;
    assign yvx012 = yv01 & ax2;
    assign yvy012 = yv01 & ay2;
    assign yvz012 = yv01 & az2;
    assign yxv012 = yx01 & av2;
    assign yxx012 = yx01 & ax2;
    assign yxy012 = yx01 & ay2;
    assign yxz012 = yx01 & az2;
    assign yyv012 = yy01 & av2;
    assign yyx012 = yy01 & ax2;
    assign yyy012 = yy01 & ay2;
    assign yyz012 = yy01 & az2;
    assign yzv012 = yz01 & av2;
    assign yzx012 = yz01 & ax2;
    assign yzy012 = yz01 & ay2;
    assign yzz012 = yz01 & az2; 
    assign zvv012 = zv01 & av2;
    assign zvx012 = zv01 & ax2;
    assign zvy012 = zv01 & ay2;
    assign zvz012 = zv01 & az2;
    assign zxv012 = zx01 & av2;
    assign zxx012 = zx01 & ax2;
    assign zxy012 = zx01 & ay2;
    assign zxz012 = zx01 & az2;
    assign zyv012 = zy01 & av2;
    assign zyx012 = zy01 & ax2;
    assign zyy012 = zy01 & ay2;
    assign zyz012 = zy01 & az2;
    assign zzv012 = zz01 & av2;
    assign zzx012 = zz01 & ax2;
    assign zzy012 = zz01 & ay2;
    assign zzz012 = zz01 & az2;
    
    assign w012 = xxx012 ^ xxy012 ^ xyx012 ^ xyy012 ^ yxx012 ^ yxy012 ^ yyx012 ^ xxz012 ^ xzx012 ^ xzz012 ^ zxx012 ^ zxz012 ^ zzx012 ^ xyz012 ^ xzy012 ^ yxz012 ^ yzx012 ^ zxy012 ^ zyx012 ^ xyv012 ^ xvy012 ^ yxv012 ^ yvx012 ^ vxy012 ^ vyx012;

    assign vvv013 = vv01 & av3;
    assign vvx013 = vv01 & ax3;
    assign vvy013 = vv01 & ay3;
    assign vvz013 = vv01 & az3;
    assign vxv013 = vx01 & av3;
    assign vxx013 = vx01 & ax3;
    assign vxy013 = vx01 & ay3;
    assign vxz013 = vx01 & az3;
    assign vyv013 = vy01 & av3;
    assign vyx013 = vy01 & ax3;
    assign vyy013 = vy01 & ay3;
    assign vyz013 = vy01 & az3;
    assign vzv013 = vz01 & av3;
    assign vzx013 = vz01 & ax3;
    assign vzy013 = vz01 & ay3;
    assign vzz013 = vz01 & az3;
    assign xvv013 = xv01 & av3;
    assign xvx013 = xv01 & ax3;
    assign xvy013 = xv01 & ay3;
    assign xvz013 = xv01 & az3;
    assign xxv013 = xx01 & av3;
    assign xxx013 = xx01 & ax3;
    assign xxy013 = xx01 & ay3;
    assign xxz013 = xx01 & az3;
    assign xyv013 = xy01 & av3;
    assign xyx013 = xy01 & ax3;
    assign xyy013 = xy01 & ay3;
    assign xyz013 = xy01 & az3;
    assign xzv013 = xz01 & av3;
    assign xzx013 = xz01 & ax3;
    assign xzy013 = xz01 & ay3;
    assign xzz013 = xz01 & az3;
    assign yvv013 = yv01 & av3;
    assign yvx013 = yv01 & ax3;
    assign yvy013 = yv01 & ay3;
    assign yvz013 = yv01 & az3;
    assign yxv013 = yx01 & av3;
    assign yxx013 = yx01 & ax3;
    assign yxy013 = yx01 & ay3;
    assign yxz013 = yx01 & az3;
    assign yyv013 = yy01 & av3;
    assign yyx013 = yy01 & ax3;
    assign yyy013 = yy01 & ay3;
    assign yyz013 = yy01 & az3;
    assign yzv013 = yz01 & av3;
    assign yzx013 = yz01 & ax3;
    assign yzy013 = yz01 & ay3;
    assign yzz013 = yz01 & az3; 
    assign zvv013 = zv01 & av3;
    assign zvx013 = zv01 & ax3;
    assign zvy013 = zv01 & ay3;
    assign zvz013 = zv01 & az3;
    assign zxv013 = zx01 & av3;
    assign zxx013 = zx01 & ax3;
    assign zxy013 = zx01 & ay3;
    assign zxz013 = zx01 & az3;
    assign zyv013 = zy01 & av3;
    assign zyx013 = zy01 & ax3;
    assign zyy013 = zy01 & ay3;
    assign zyz013 = zy01 & az3;
    assign zzv013 = zz01 & av3;
    assign zzx013 = zz01 & ax3;
    assign zzy013 = zz01 & ay3;
    assign zzz013 = zz01 & az3;
    
    assign w013 = xxx013 ^ xxy013 ^ xyx013 ^ xyy013 ^ yxx013 ^ yxy013 ^ yyx013 ^ xxz013 ^ xzx013 ^ xzz013 ^ zxx013 ^ zxz013 ^ zzx013 ^ xyz013 ^ xzy013 ^ yxz013 ^ yzx013 ^ zxy013 ^ zyx013 ^ xyv013 ^ xvy013 ^ yxv013 ^ yvx013 ^ vxy013 ^ vyx013;
    
    assign vvv023 = vv02 & av3;
    assign vvx023 = vv02 & ax3;
    assign vvy023 = vv02 & ay3;
    assign vvz023 = vv02 & az3;
    assign vxv023 = vx02 & av3;
    assign vxx023 = vx02 & ax3;
    assign vxy023 = vx02 & ay3;
    assign vxz023 = vx02 & az3;
    assign vyv023 = vy02 & av3;
    assign vyx023 = vy02 & ax3;
    assign vyy023 = vy02 & ay3;
    assign vyz023 = vy02 & az3;
    assign vzv023 = vz02 & av3;
    assign vzx023 = vz02 & ax3;
    assign vzy023 = vz02 & ay3;
    assign vzz023 = vz02 & az3;
    assign xvv023 = xv02 & av3;
    assign xvx023 = xv02 & ax3;
    assign xvy023 = xv02 & ay3;
    assign xvz023 = xv02 & az3;
    assign xxv023 = xx02 & av3;
    assign xxx023 = xx02 & ax3;
    assign xxy023 = xx02 & ay3;
    assign xxz023 = xx02 & az3;
    assign xyv023 = xy02 & av3;
    assign xyx023 = xy02 & ax3;
    assign xyy023 = xy02 & ay3;
    assign xyz023 = xy02 & az3;
    assign xzv023 = xz02 & av3;
    assign xzx023 = xz02 & ax3;
    assign xzy023 = xz02 & ay3;
    assign xzz023 = xz02 & az3;
    assign yvv023 = yv02 & av3;
    assign yvx023 = yv02 & ax3;
    assign yvy023 = yv02 & ay3;
    assign yvz023 = yv02 & az3;
    assign yxv023 = yx02 & av3;
    assign yxx023 = yx02 & ax3;
    assign yxy023 = yx02 & ay3;
    assign yxz023 = yx02 & az3;
    assign yyv023 = yy02 & av3;
    assign yyx023 = yy02 & ax3;
    assign yyy023 = yy02 & ay3;
    assign yyz023 = yy02 & az3;
    assign yzv023 = yz02 & av3;
    assign yzx023 = yz02 & ax3;
    assign yzy023 = yz02 & ay3;
    assign yzz023 = yz02 & az3; 
    assign zvv023 = zv02 & av3;
    assign zvx023 = zv02 & ax3;
    assign zvy023 = zv02 & ay3;
    assign zvz023 = zv02 & az3;
    assign zxv023 = zx02 & av3;
    assign zxx023 = zx02 & ax3;
    assign zxy023 = zx02 & ay3;
    assign zxz023 = zx02 & az3;
    assign zyv023 = zy02 & av3;
    assign zyx023 = zy02 & ax3;
    assign zyy023 = zy02 & ay3;
    assign zyz023 = zy02 & az3;
    assign zzv023 = zz02 & av3;
    assign zzx023 = zz02 & ax3;
    assign zzy023 = zz02 & ay3;
    assign zzz023 = zz02 & az3;
    
    assign w023 = xxx023 ^ xxy023 ^ xyx023 ^ xyy023 ^ yxx023 ^ yxy023 ^ yyx023 ^ xxz023 ^ xzx023 ^ xzz023 ^ zxx023 ^ zxz023 ^ zzx023 ^ xyz023 ^ xzy023 ^ yxz023 ^ yzx023 ^ zxy023 ^ zyx023 ^ xyv023 ^ xvy023 ^ yxv023 ^ yvx023 ^ vxy023 ^ vyx023;

    assign vvv123 = vv12 & av3;
    assign vvx123 = vv12 & ax3;
    assign vvy123 = vv12 & ay3;
    assign vvz123 = vv12 & az3;
    assign vxv123 = vx12 & av3;
    assign vxx123 = vx12 & ax3;
    assign vxy123 = vx12 & ay3;
    assign vxz123 = vx12 & az3;
    assign vyv123 = vy12 & av3;
    assign vyx123 = vy12 & ax3;
    assign vyy123 = vy12 & ay3;
    assign vyz123 = vy12 & az3;
    assign vzv123 = vz12 & av3;
    assign vzx123 = vz12 & ax3;
    assign vzy123 = vz12 & ay3;
    assign vzz123 = vz12 & az3;
    assign xvv123 = xv12 & av3;
    assign xvx123 = xv12 & ax3;
    assign xvy123 = xv12 & ay3;
    assign xvz123 = xv12 & az3;
    assign xxv123 = xx12 & av3;
    assign xxx123 = xx12 & ax3;
    assign xxy123 = xx12 & ay3;
    assign xxz123 = xx12 & az3;
    assign xyv123 = xy12 & av3;
    assign xyx123 = xy12 & ax3;
    assign xyy123 = xy12 & ay3;
    assign xyz123 = xy12 & az3;
    assign xzv123 = xz12 & av3;
    assign xzx123 = xz12 & ax3;
    assign xzy123 = xz12 & ay3;
    assign xzz123 = xz12 & az3;
    assign yvv123 = yv12 & av3;
    assign yvx123 = yv12 & ax3;
    assign yvy123 = yv12 & ay3;
    assign yvz123 = yv12 & az3;
    assign yxv123 = yx12 & av3;
    assign yxx123 = yx12 & ax3;
    assign yxy123 = yx12 & ay3;
    assign yxz123 = yx12 & az3;
    assign yyv123 = yy12 & av3;
    assign yyx123 = yy12 & ax3;
    assign yyy123 = yy12 & ay3;
    assign yyz123 = yy12 & az3;
    assign yzv123 = yz12 & av3;
    assign yzx123 = yz12 & ax3;
    assign yzy123 = yz12 & ay3;
    assign yzz123 = yz12 & az3; 
    assign zvv123 = zv12 & av3;
    assign zvx123 = zv12 & ax3;
    assign zvy123 = zv12 & ay3;
    assign zvz123 = zv12 & az3;
    assign zxv123 = zx12 & av3;
    assign zxx123 = zx12 & ax3;
    assign zxy123 = zx12 & ay3;
    assign zxz123 = zx12 & az3;
    assign zyv123 = zy12 & av3;
    assign zyx123 = zy12 & ax3;
    assign zyy123 = zy12 & ay3;
    assign zyz123 = zy12 & az3;
    assign zzv123 = zz12 & av3;
    assign zzx123 = zz12 & ax3;
    assign zzy123 = zz12 & ay3;
    assign zzz123 = zz12 & az3;
    
    assign w123 = xxx123 ^ xxy123 ^ xyx123 ^ xyy123 ^ yxx123 ^ yxy123 ^ yyx123 ^ xxz123 ^ xzx123 ^ xzz123 ^ zxx123 ^ zxz123 ^ zzx123 ^ xyz123 ^ xzy123 ^ yxz123 ^ yzx123 ^ zxy123 ^ zyx123 ^ xyv123 ^ xvy123 ^ yxv123 ^ yvx123 ^ vxy123 ^ vyx123;


    assign z_w[0] = w01 ^ w2 ^ w12 ^ w012 ^ w3 ^ w023;
    assign z_w[1] = w02 ^ w12 ^ w012 ^ w3 ^ w13 ^ w023 ^ w123;
    assign z_w[2] = w0 ^ w01 ^ w03 ^ w13 ^ w013 ^ w23 ^ w123;
    assign z_w[3] = w1 ^ w12 ^ w012 ^ w03 ^ w013;
endmodule
