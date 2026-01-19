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
    input [3:0] v,
    input [3:0] w,
    input [3:0] x,
    input [3:0] z,
    output [3:0] z_y
    );
    
    wire v0,w0,x0,y0,z0, v1,w1,x1,y1,z1, v2,w2,x2,y2,z2, v3,w3,x3,y3,z3;
    wire av0,aw0,ax0,az0, av1,aw1,ax1,az1, av2,aw2,ax2,az2, av3,aw3,ax3,az3;
    
    wire vv01,vw01,vx01,vz01, wv01,ww01,wx01,wz01, xv01,xw01,xx01,xz01, zv01,zw01,zx01,zz01;
    wire vv02,vw02,vx02,vz02, wv02,ww02,wx02,wz02, xv02,xw02,xx02,xz02, zv02,zw02,zx02,zz02;
    wire vv03,vw03,vx03,vz03, wv03,ww03,wx03,wz03, xv03,xw03,xx03,xz03, zv03,zw03,zx03,zz03;
    wire vv12,vw12,vx12,vz12, wv12,ww12,wx12,wz12, xv12,xw12,xx12,xz12, zv12,zw12,zx12,zz12;
    wire vv13,vw13,vx13,vz13, wv13,ww13,wx13,wz13, xv13,xw13,xx13,xz13, zv13,zw13,zx13,zz13;
    wire vv23,vw23,vx23,vz23, wv23,ww23,wx23,wz23, xv23,xw23,xx23,xz23, zv23,zw23,zx23,zz23;
    
    wire vvv012,vvw012,vvx012,vvz012, vwv012,vww012,vwx012,vwz012, vxv012,vxw012,vxx012,vxz012, vzv012,vzw012,vzx012,vzz012;
    wire wvv012,wvw012,wvx012,wvz012, wwv012,www012,wwx012,wwz012, wxv012,wxw012,wxx012,wxz012, wzv012,wzw012,wzx012,wzz012;
    wire xvv012,xvw012,xvx012,xvz012, xwv012,xww012,xwx012,xwz012, xxv012,xxw012,xxx012,xxz012, xzv012,xzw012,xzx012,xzz012;
    wire zvv012,zvw012,zvx012,zvz012, zwv012,zww012,zwx012,zwz012, zxv012,zxw012,zxx012,zxz012, zzv012,zzw012,zzx012,zzz012;

    wire vvv013,vvw013,vvx013,vvz013, vwv013,vww013,vwx013,vwz013, vxv013,vxw013,vxx013,vxz013, vzv013,vzw013,vzx013,vzz013;
    wire wvv013,wvw013,wvx013,wvz013, wwv013,www013,wwx013,wwz013, wxv013,wxw013,wxx013,wxz013, wzv013,wzw013,wzx013,wzz013;
    wire xvv013,xvw013,xvx013,xvz013, xwv013,xww013,xwx013,xwz013, xxv013,xxw013,xxx013,xxz013, xzv013,xzw013,xzx013,xzz013;
    wire zvv013,zvw013,zvx013,zvz013, zwv013,zww013,zwx013,zwz013, zxv013,zxw013,zxx013,zxz013, zzv013,zzw013,zzx013,zzz013;
    
    wire vvv023,vvw023,vvx023,vvz023, vwv023,vww023,vwx023,vwz023, vxv023,vxw023,vxx023,vxz023, vzv023,vzw023,vzx023,vzz023;
    wire wvv023,wvw023,wvx023,wvz023, wwv023,www023,wwx023,wwz023, wxv023,wxw023,wxx023,wxz023, wzv023,wzw023,wzx023,wzz023;
    wire xvv023,xvw023,xvx023,xvz023, xwv023,xww023,xwx023,xwz023, xxv023,xxw023,xxx023,xxz023, xzv023,xzw023,xzx023,xzz023;
    wire zvv023,zvw023,zvx023,zvz023, zwv023,zww023,zwx023,zwz023, zxv023,zxw023,zxx023,zxz023, zzv023,zzw023,zzx023,zzz023;
    
    wire vvv123,vvw123,vvx123,vvz123, vwv123,vww123,vwx123,vwz123, vxv123,vxw123,vxx123,vxz123, vzv123,vzw123,vzx123,vzz123;
    wire wvv123,wvw123,wvx123,wvz123, wwv123,www123,wwx123,wwz123, wxv123,wxw123,wxx123,wxz123, wzv123,wzw123,wzx123,wzz123;
    wire xvv123,xvw123,xvx123,xvz123, xwv123,xww123,xwx123,xwz123, xxv123,xxw123,xxx123,xxz123, xzv123,xzw123,xzx123,xzz123;
    wire zvv123,zvw123,zvx123,zvz123, zwv123,zww123,zwx123,zwz123, zxv123,zxw123,zxx123,zxz123, zzv123,zzw123,zzx123,zzz123;
    
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
    assign aw0 = w[0];
    assign ax0 = x[0];
    assign az0 = z[0];
    
    assign av1 = v[1] ^ v[3];
    assign aw1 = w[1] ^ w[3];
    assign ax1 = x[1] ^ x[3];
    assign az1 = z[1] ^ z[3];
    
    assign av2 = v[2];
    assign aw2 = w[2];
    assign ax2 = x[2];
    assign az2 = z[2];
    
    assign av3 = v[3];
    assign aw3 = w[3];
    assign ax3 = x[3];
    assign az3 = z[3];
    
    assign v0 = aw0;
    assign w0 = ax0;
    assign y0 = az0;
    assign z0 = av0;
    
    assign v1 = aw1;
    assign w1 = ax1;
    assign y1 = az1;
    assign z1 = av1;
    
    assign v2 = aw2;
    assign w2 = ax2;
    assign y2 = az2;
    assign z2 = av2;
    
    assign v3 = aw3;
    assign w3 = ax3;
    assign y3 = az3;
    assign z3 = av3;
    
    assign vv01 = av0 & av1;
    assign vw01 = av0 & aw1;
    assign vx01 = av0 & ax1;
    assign vz01 = av0 & az1;
    assign wv01 = aw0 & av1;
    assign ww01 = aw0 & aw1;
    assign wx01 = aw0 & ax1;
    assign wz01 = aw0 & az1;
    assign xv01 = ax0 & av1;
    assign xw01 = ax0 & aw1;
    assign xx01 = ax0 & ax1;
    assign xz01 = ax0 & az1;  
    assign zv01 = az0 & av1;
    assign zw01 = az0 & aw1;
    assign zx01 = az0 & ax1;
    assign zz01 = az0 & az1;

    assign y01 = zz01 ^ zv01 ^ vz01 ^ zw01 ^ wz01;
    
    assign vv02 = av0 & av2;
    assign vw02 = av0 & aw2;
    assign vx02 = av0 & ax2;
    assign vz02 = av0 & az2;
    assign wv02 = aw0 & av2;
    assign ww02 = aw0 & aw2;
    assign wx02 = aw0 & ax2;
    assign wz02 = aw0 & az2;
    assign xv02 = ax0 & av2;
    assign xw02 = ax0 & aw2;
    assign xx02 = ax0 & ax2;
    assign xz02 = ax0 & az2;  
    assign zv02 = az0 & av2;
    assign zw02 = az0 & aw2;
    assign zx02 = az0 & ax2;
    assign zz02 = az0 & az2;
    
    assign y02 = zz02 ^ zv02 ^ vz02 ^ zw02 ^ wz02;
    
    assign vv03 = av0 & av3;
    assign vw03 = av0 & aw3;
    assign vx03 = av0 & ax3;
    assign vz03 = av0 & az3;
    assign wv03 = aw0 & av3;
    assign ww03 = aw0 & aw3;
    assign wx03 = aw0 & ax3;
    assign wz03 = aw0 & az3;
    assign xv03 = ax0 & av3;
    assign xw03 = ax0 & aw3;
    assign xx03 = ax0 & ax3;
    assign xz03 = ax0 & az3; 
    assign zv03 = az0 & av3;
    assign zw03 = az0 & aw3;
    assign zx03 = az0 & ax3;
    assign zz03 = az0 & az3;
    
    assign y03 = zz03 ^ zv03 ^ vz03 ^ zw03 ^ wz03;
    
    assign vv12 = av1 & av2;
    assign vw12 = av1 & aw2;
    assign vx12 = av1 & ax2;
    assign vz12 = av1 & az2;
    assign wv12 = aw1 & av2;
    assign ww12 = aw1 & aw2;
    assign wx12 = aw1 & ax2;
    assign wz12 = aw1 & az2;
    assign xv12 = ax1 & av2;
    assign xw12 = ax1 & aw2;
    assign xx12 = ax1 & ax2;
    assign xz12 = ax1 & az2;
    assign zv12 = az1 & av2;
    assign zw12 = az1 & aw2;
    assign zx12 = az1 & ax2;
    assign zz12 = az1 & az2;
    
    assign y12 = zz12 ^ zv12 ^ vz12 ^ zw12 ^ wz12;
    
    assign vv13 = av1 & av3;
    assign vw13 = av1 & aw3;
    assign vx13 = av1 & ax3;
    assign vz13 = av1 & az3;
    assign wv13 = aw1 & av3;
    assign ww13 = aw1 & aw3;
    assign wz13 = aw1 & az3;
    assign xv13 = ax1 & av3;
    assign xw13 = ax1 & aw3;
    assign xx13 = ax1 & ax3;
    assign xz13 = ax1 & az3;
    assign zv13 = az1 & av3;
    assign zw13 = az1 & aw3;
    assign zx13 = az1 & ax3;
    assign zz13 = az1 & az3;
    
    assign y13 = zz13 ^ zv13 ^ vz13 ^ zw13 ^ wz13;
    
    assign vv23 = av2 & av3;
    assign vw23 = av2 & aw3;
    assign vx23 = av2 & ax3;
    assign vz23 = av2 & az3;
    assign wv23 = aw2 & av3;
    assign ww23 = aw2 & aw3;
    assign wx23 = aw2 & ax3;
    assign wz23 = aw2 & az3;
    assign xv23 = ax2 & av3;
    assign xw23 = ax2 & aw3;
    assign xx23 = ax2 & ax3;
    assign xz23 = ax2 & az3;  
    assign zv23 = az2 & av3;
    assign zw23 = az2 & aw3;
    assign zx23 = az2 & ax3;
    assign zz23 = az2 & az3;
    
    assign y23 = zz23 ^ zv23 ^ vz23 ^ zw23 ^ wz23;
    
    assign vvv012 = vv01 & av2;
    assign vvw012 = vv01 & aw2;
    assign vvx012 = vv01 & ax2;
    assign vvz012 = vv01 & az2;
    assign vwv012 = vw01 & av2;
    assign vww012 = vw01 & aw2;
    assign vwx012 = vw01 & ax2;
    assign vwz012 = vw01 & az2;
    assign vxv012 = vx01 & av2;
    assign vxw012 = vx01 & aw2;
    assign vxx012 = vx01 & ax2;
    assign vxz012 = vx01 & az2;
    assign vzv012 = vz01 & av2;
    assign vzw012 = vz01 & aw2;
    assign vzx012 = vz01 & ax2;
    assign vzz012 = vz01 & az2;
    assign wvv012 = wv01 & av2;
    assign wvw012 = wv01 & aw2;
    assign wvx012 = wv01 & ax2;
    assign wvz012 = wv01 & az2;
    assign wwv012 = ww01 & av2;
    assign www012 = ww01 & aw2;
    assign wwx012 = ww01 & ax2;
    assign wwz012 = ww01 & az2;
    assign wxv012 = wx01 & av2;
    assign wxw012 = wx01 & aw2;
    assign wxx012 = wx01 & ax2;
    assign wxz012 = wx01 & az2;
    assign wzv012 = wz01 & av2;
    assign wzw012 = wz01 & aw2;
    assign wzx012 = wz01 & ax2;
    assign wzz012 = wz01 & az2;
    assign xvv012 = xv01 & av2;
    assign xvw012 = xv01 & aw2;
    assign xvx012 = xv01 & ax2;
    assign xvz012 = xv01 & az2;
    assign xwv012 = xw01 & av2;
    assign xww012 = xw01 & aw2;
    assign xwx012 = xw01 & ax2;
    assign xwz012 = xw01 & az2;
    assign xxv012 = xx01 & av2;
    assign xxw012 = xx01 & aw2;
    assign xxx012 = xx01 & ax2;
    assign xxz012 = xx01 & az2;
    assign xzv012 = xz01 & av2;
    assign xzw012 = xz01 & aw2;
    assign xzx012 = xz01 & ax2;
    assign xzz012 = xz01 & az2;
    assign zvv012 = zv01 & av2;
    assign zvw012 = zv01 & aw2;
    assign zvx012 = zv01 & ax2;
    assign zvz012 = zv01 & az2;
    assign zwv012 = zw01 & av2;
    assign zww012 = zw01 & aw2;
    assign zwx012 = zw01 & ax2;
    assign zwz012 = zw01 & az2;
    assign zxv012 = zx01 & av2;
    assign zxw012 = zx01 & aw2;
    assign zxx012 = zx01 & ax2;
    assign zxz012 = zx01 & az2;
    assign zzv012 = zz01 & av2;
    assign zzw012 = zz01 & aw2;
    assign zzx012 = zz01 & ax2;
    assign zzz012 = zz01 & az2;
    
    assign y012 = zzz012 ^ zzv012 ^ zvz012 ^ zvv012 ^ vzz012 ^ vzv012 ^ vvz012 ^ zzw012 ^ zwz012 ^ zww012 ^ wzz012 ^ wzw012 ^ wwz012 ^ zvw012 ^ zwv012 ^ vzw012 ^ vwz012 ^ wzv012 ^ wvz012 ^ zvx012 ^ zxv012 ^ vzx012 ^ vxz012 ^ xzv012 ^ xvz012;

    assign vvv013 = vv01 & av3;
    assign vvw013 = vv01 & aw3;
    assign vvx013 = vv01 & ax3;
    assign vvz013 = vv01 & az3;
    assign vwv013 = vw01 & av3;
    assign vww013 = vw01 & aw3;
    assign vwx013 = vw01 & ax3;
    assign vwz013 = vw01 & az3;
    assign vxv013 = vx01 & av3;
    assign vxw013 = vx01 & aw3;
    assign vxx013 = vx01 & ax3;
    assign vxz013 = vx01 & az3;
    assign vzv013 = vz01 & av3;
    assign vzw013 = vz01 & aw3;
    assign vzx013 = vz01 & ax3;
    assign vzz013 = vz01 & az3;
    assign wvv013 = wv01 & av3;
    assign wvw013 = wv01 & aw3;
    assign wvx013 = wv01 & ax3;
    assign wvz013 = wv01 & az3;
    assign wwv013 = ww01 & av3;
    assign www013 = ww01 & aw3;
    assign wwx013 = ww01 & ax3;
    assign wwz013 = ww01 & az3;
    assign wxv013 = wx01 & av3;
    assign wxw013 = wx01 & aw3;
    assign wxx013 = wx01 & ax3;
    assign wxz013 = wx01 & az3;
    assign wzv013 = wz01 & av3;
    assign wzw013 = wz01 & aw3;
    assign wzx013 = wz01 & ax3;
    assign wzz013 = wz01 & az3;
    assign xvv013 = xv01 & av3;
    assign xvw013 = xv01 & aw3;
    assign xvx013 = xv01 & ax3;
    assign xvz013 = xv01 & az3;
    assign xwv013 = xw01 & av3;
    assign xww013 = xw01 & aw3;
    assign xwx013 = xw01 & ax3;
    assign xwz013 = xw01 & az3;
    assign xxv013 = xx01 & av3;
    assign xxw013 = xx01 & aw3;
    assign xxx013 = xx01 & ax3;
    assign xxz013 = xx01 & az3;
    assign xzv013 = xz01 & av3;
    assign xzw013 = xz01 & aw3;
    assign xzx013 = xz01 & ax3;
    assign xzz013 = xz01 & az3;
    assign zvv013 = zv01 & av3;
    assign zvw013 = zv01 & aw3;
    assign zvx013 = zv01 & ax3;
    assign zvz013 = zv01 & az3;
    assign zwv013 = zw01 & av3;
    assign zww013 = zw01 & aw3;
    assign zwx013 = zw01 & ax3;
    assign zwz013 = zw01 & az3;
    assign zxv013 = zx01 & av3;
    assign zxw013 = zx01 & aw3;
    assign zxx013 = zx01 & ax3;
    assign zxz013 = zx01 & az3;
    assign zzv013 = zz01 & av3;
    assign zzw013 = zz01 & aw3;
    assign zzx013 = zz01 & ax3;
    assign zzz013 = zz01 & az3;
    
    assign y013 = zzz013 ^ zzv013 ^ zvz013 ^ zvv013 ^ vzz013 ^ vzv013 ^ vvz013 ^ zzw013 ^ zwz013 ^ zww013 ^ wzz013 ^ wzw013 ^ wwz013 ^ zvw013 ^ zwv013 ^ vzw013 ^ vwz013 ^ wzv013 ^ wvz013 ^ zvx013 ^ zxv013 ^ vzx013 ^ vxz013 ^ xzv013 ^ xvz013;

    assign vvv023 = vv02 & av3;
    assign vvw023 = vv02 & aw3;
    assign vvx023 = vv02 & ax3;
    assign vvz023 = vv02 & az3;
    assign vwv023 = vw02 & av3;
    assign vww023 = vw02 & aw3;
    assign vwx023 = vw02 & ax3;
    assign vwz023 = vw02 & az3;
    assign vxv023 = vx02 & av3;
    assign vxw023 = vx02 & aw3;
    assign vxx023 = vx02 & ax3;
    assign vxz023 = vx02 & az3;
    assign vzv023 = vz02 & av3;
    assign vzw023 = vz02 & aw3;
    assign vzx023 = vz02 & ax3;
    assign vzz023 = vz02 & az3;
    assign wvv023 = wv02 & av3;
    assign wvw023 = wv02 & aw3;
    assign wvx023 = wv02 & ax3;
    assign wvz023 = wv02 & az3;
    assign wwv023 = ww02 & av3;
    assign www023 = ww02 & aw3;
    assign wwx023 = ww02 & ax3;
    assign wwz023 = ww02 & az3;
    assign wxv023 = wx02 & av3;
    assign wxw023 = wx02 & aw3;
    assign wxx023 = wx02 & ax3;
    assign wxz023 = wx02 & az3;
    assign wzv023 = wz02 & av3;
    assign wzw023 = wz02 & aw3;
    assign wzx023 = wz02 & ax3;
    assign wzz023 = wz02 & az3;
    assign xvv023 = xv02 & av3;
    assign xvw023 = xv02 & aw3;
    assign xvx023 = xv02 & ax3;
    assign xvz023 = xv02 & az3;
    assign xwv023 = xw02 & av3;
    assign xww023 = xw02 & aw3;
    assign xwx023 = xw02 & ax3;
    assign xwz023 = xw02 & az3;
    assign xxv023 = xx02 & av3;
    assign xxw023 = xx02 & aw3;
    assign xxx023 = xx02 & ax3;
    assign xxz023 = xx02 & az3;
    assign xzv023 = xz02 & av3;
    assign xzw023 = xz02 & aw3;
    assign xzx023 = xz02 & ax3;
    assign xzz023 = xz02 & az3;
    assign zvv023 = zv02 & av3;
    assign zvw023 = zv02 & aw3;
    assign zvx023 = zv02 & ax3;
    assign zvz023 = zv02 & az3;
    assign zwv023 = zw02 & av3;
    assign zww023 = zw02 & aw3;
    assign zwx023 = zw02 & ax3;
    assign zwz023 = zw02 & az3;
    assign zxv023 = zx02 & av3;
    assign zxw023 = zx02 & aw3;
    assign zxx023 = zx02 & ax3;
    assign zxz023 = zx02 & az3;
    assign zzv023 = zz02 & av3;
    assign zzw023 = zz02 & aw3;
    assign zzx023 = zz02 & ax3;
    assign zzz023 = zz02 & az3;
    
    assign y023 = zzz023 ^ zzv023 ^ zvz023 ^ zvv023 ^ vzz023 ^ vzv023 ^ vvz023 ^ zzw023 ^ zwz023 ^ zww023 ^ wzz023 ^ wzw023 ^ wwz023 ^ zvw023 ^ zwv023 ^ vzw023 ^ vwz023 ^ wzv023 ^ wvz023 ^ zvx023 ^ zxv023 ^ vzx023 ^ vxz023 ^ xzv023 ^ xvz023;

    assign vvv123 = vv12 & av3;
    assign vvw123 = vv12 & aw3;
    assign vvx123 = vv12 & ax3;
    assign vvz123 = vv12 & az3;
    assign vwv123 = vw12 & av3;
    assign vww123 = vw12 & aw3;
    assign vwx123 = vw12 & ax3;
    assign vwz123 = vw12 & az3;
    assign vxv123 = vx12 & av3;
    assign vxw123 = vx12 & aw3;
    assign vxx123 = vx12 & ax3;
    assign vxz123 = vx12 & az3;
    assign vzv123 = vz12 & av3;
    assign vzw123 = vz12 & aw3;
    assign vzx123 = vz12 & ax3;
    assign vzz123 = vz12 & az3;
    assign wvv123 = wv12 & av3;
    assign wvw123 = wv12 & aw3;
    assign wvx123 = wv12 & ax3;
    assign wvz123 = wv12 & az3;
    assign wwv123 = ww12 & av3;
    assign www123 = ww12 & aw3;
    assign wwx123 = ww12 & ax3;
    assign wwz123 = ww12 & az3;
    assign wxv123 = wx12 & av3;
    assign wxw123 = wx12 & aw3;
    assign wxx123 = wx12 & ax3;
    assign wxz123 = wx12 & az3;
    assign wzv123 = wz12 & av3;
    assign wzw123 = wz12 & aw3;
    assign wzx123 = wz12 & ax3;
    assign wzz123 = wz12 & az3;
    assign xvv123 = xv12 & av3;
    assign xvw123 = xv12 & aw3;
    assign xvx123 = xv12 & ax3;
    assign xvz123 = xv12 & az3;
    assign xwv123 = xw12 & av3;
    assign xww123 = xw12 & aw3;
    assign xwx123 = xw12 & ax3;
    assign xwz123 = xw12 & az3;
    assign xxv123 = xx12 & av3;
    assign xxw123 = xx12 & aw3;
    assign xxx123 = xx12 & ax3;
    assign xxz123 = xx12 & az3;
    assign xzv123 = xz12 & av3;
    assign xzw123 = xz12 & aw3;
    assign xzx123 = xz12 & ax3;
    assign xzz123 = xz12 & az3;
    assign zvv123 = zv12 & av3;
    assign zvw123 = zv12 & aw3;
    assign zvx123 = zv12 & ax3;
    assign zvz123 = zv12 & az3;
    assign zwv123 = zw12 & av3;
    assign zww123 = zw12 & aw3;
    assign zwx123 = zw12 & ax3;
    assign zwz123 = zw12 & az3;
    assign zxv123 = zx12 & av3;
    assign zxw123 = zx12 & aw3;
    assign zxx123 = zx12 & ax3;
    assign zxz123 = zx12 & az3;
    assign zzv123 = zz12 & av3;
    assign zzw123 = zz12 & aw3;
    assign zzx123 = zz12 & ax3;
    assign zzz123 = zz12 & az3;
    
    assign y123 = zzz123 ^ zzv123 ^ zvz123 ^ zvv123 ^ vzz123 ^ vzv123 ^ vvz123 ^ zzw123 ^ zwz123 ^ zww123 ^ wzz123 ^ wzw123 ^ wwz123 ^ zvw123 ^ zwv123 ^ vzw123 ^ vwz123 ^ wzv123 ^ wvz123 ^ zvx123 ^ zxv123 ^ vzx123 ^ vxz123 ^ xzv123 ^ xvz123;

    assign z_y[0] = y01 ^ y2 ^ y12 ^ y012 ^ y3 ^ y023;
    assign z_y[1] = y02 ^ y12 ^ y012 ^ y3 ^ y13 ^ y023 ^ y123;
    assign z_y[2] = y0 ^ y01 ^ y03 ^ y13 ^ y013 ^ y23 ^ y123;
    assign z_y[3] = y1 ^ y12 ^ y012 ^ y03 ^ y013;
endmodule
