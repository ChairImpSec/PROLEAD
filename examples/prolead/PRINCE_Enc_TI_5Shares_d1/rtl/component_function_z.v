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
    input [3:0] v,
    input [3:0] w,
    input [3:0] x,
    input [3:0] y,
    output [3:0] z_z
    );
    
    wire v0,w0,x0,y0,z0, v1,w1,x1,y1,z1, v2,w2,x2,y2,z2, v3,w3,x3,y3,z3;
    wire av0,aw0,ax0,ay0, av1,aw1,ax1,ay1, av2,aw2,ax2,ay2, av3,aw3,ax3,ay3;
    
    wire vv01,vw01,vx01,vy01, wv01,ww01,wx01,wy01, xv01,xw01,xx01,xy01, yv01,yw01,yx01,yy01;
    wire vv02,vw02,vx02,vy02, wv02,ww02,wx02,wy02, xv02,xw02,xx02,xy02, yv02,yw02,yx02,yy02;
    wire vv03,vw03,vx03,vy03, wv03,ww03,wx03,wy03, xv03,xw03,xx03,xy03, yv03,yw03,yx03,yy03;
    wire vv12,vw12,vx12,vy12, wv12,ww12,wx12,wy12, xv12,xw12,xx12,xy12, yv12,yw12,yx12,yy12;
    wire vv13,vw13,vx13,vy13, wv13,ww13,wx13,wy13, xv13,xw13,xx13,xy13, yv13,yw13,yx13,yy13;
    wire vv23,vw23,vx23,vy23, wv23,ww23,wx23,wy23, xv23,xw23,xx23,xy23, yv23,yw23,yx23,yy23;
    
    wire vvv012,vvw012,vvx012,vvy012, vwv012,vww012,vwx012,vwy012, vxv012,vxw012,vxx012,vxy012, vyv012,vyw012,vyx012,vyy012;
    wire wvv012,wvw012,wvx012,wvy012, wwv012,www012,wwx012,wwy012, wxv012,wxw012,wxx012,wxy012, wyv012,wyw012,wyx012,wyy012;
    wire xvv012,xvw012,xvx012,xvy012, xwv012,xww012,xwx012,xwy012, xxv012,xxw012,xxx012,xxy012, xyv012,xyw012,xyx012,xyy012;
    wire yvv012,yvw012,yvx012,yvy012, ywv012,yww012,ywx012,ywy012, yxv012,yxw012,yxx012,yxy012, yyv012,yyw012,yyx012,yyy012;

    wire vvv013,vvw013,vvx013,vvy013, vwv013,vww013,vwx013,vwy013, vxv013,vxw013,vxx013,vxy013, vyv013,vyw013,vyx013,vyy013;
    wire wvv013,wvw013,wvx013,wvy013, wwv013,www013,wwx013,wwy013, wxv013,wxw013,wxx013,wxy013, wyv013,wyw013,wyx013,wyy013;
    wire xvv013,xvw013,xvx013,xvy013, xwv013,xww013,xwx013,xwy013, xxv013,xxw013,xxx013,xxy013, xyv013,xyw013,xyx013,xyy013;
    wire yvv013,yvw013,yvx013,yvy013, ywv013,yww013,ywx013,ywy013, yxv013,yxw013,yxx013,yxy013, yyv013,yyw013,yyx013,yyy013;
    
    wire vvv023,vvw023,vvx023,vvy023, vwv023,vww023,vwx023,vwy023, vxv023,vxw023,vxx023,vxy023, vyv023,vyw023,vyx023,vyy023;
    wire wvv023,wvw023,wvx023,wvy023, wwv023,www023,wwx023,wwy023, wxv023,wxw023,wxx023,wxy023, wyv023,wyw023,wyx023,wyy023;
    wire xvv023,xvw023,xvx023,xvy023, xwv023,xww023,xwx023,xwy023, xxv023,xxw023,xxx023,xxy023, xyv023,xyw023,xyx023,xyy023;
    wire yvv023,yvw023,yvx023,yvy023, ywv023,yww023,ywx023,ywy023, yxv023,yxw023,yxx023,yxy023, yyv023,yyw023,yyx023,yyy023;
    
    wire vvv123,vvw123,vvx123,vvy123, vwv123,vww123,vwx123,vwy123, vxv123,vxw123,vxx123,vxy123, vyv123,vyw123,vyx123,vyy123;
    wire wvv123,wvw123,wvx123,wvy123, wwv123,www123,wwx123,wwy123, wxv123,wxw123,wxx123,wxy123, wyv123,wyw123,wyx123,wyy123;
    wire xvv123,xvw123,xvx123,xvy123, xwv123,xww123,xwx123,xwy123, xxv123,xxw123,xxx123,xxy123, xyv123,xyw123,xyx123,xyy123;
    wire yvv123,yvw123,yvx123,yvy123, ywv123,yww123,ywx123,ywy123, yxv123,yxw123,yxx123,yxy123, yyv123,yyw123,yyx123,yyy123;
    
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
    assign av1 = v[1] ^ v[3];
    assign av2 = v[2];
    assign av3 = v[3];
    
    assign aw0 = w[0];
    assign aw1 = w[1] ^ w[3];
    assign aw2 = w[2];
    assign aw3 = w[3];
    
    assign ax0 = x[0];
    assign ax1 = x[1] ^ x[3];
    assign ax2 = x[2];
    assign ax3 = x[3];
    
    assign ay0 = y[0];
    assign ay1 = y[1] ^ y[3];
    assign ay2 = y[2];
    assign ay3 = y[3];
    
    assign z0 = av0;
    assign z1 = av1;
    assign z2 = av2;
    assign z3 = av3;
    
    assign vv01 = av0 & av1;
    assign vw01 = av0 & aw1;
    assign vx01 = av0 & ax1;
    assign vy01 = av0 & ay1;
    assign wv01 = aw0 & av1;
    assign ww01 = aw0 & aw1;
    assign wx01 = aw0 & ax1;
    assign wy01 = aw0 & ay1;
    assign xv01 = ax0 & av1;
    assign xw01 = ax0 & aw1;
    assign xx01 = ax0 & ax1;
    assign xy01 = ax0 & ay1;
    assign yv01 = ay0 & av1;
    assign yw01 = ay0 & aw1;
    assign yx01 = ay0 & ax1;
    assign yy01 = ay0 & ay1;
    
    assign z01 = vv01 ^ vw01 ^ wv01 ^ vx01 ^ xv01;
    
    assign vv02 = av0 & av2;
    assign vw02 = av0 & aw2;
    assign vx02 = av0 & ax2;
    assign vy02 = av0 & ay2;
    assign wv02 = aw0 & av2;
    assign ww02 = aw0 & aw2;
    assign wx02 = aw0 & ax2;
    assign wy02 = aw0 & ay2;
    assign xv02 = ax0 & av2;
    assign xw02 = ax0 & aw2;
    assign xx02 = ax0 & ax2;
    assign xy02 = ax0 & ay2;
    assign yv02 = ay0 & av2;
    assign yw02 = ay0 & aw2;
    assign yx02 = ay0 & ax2;
    assign yy02 = ay0 & ay2;

    assign z02 = vv02 ^ vw02 ^ wv02 ^ vx02 ^ xv02;
    
    assign vv03 = av0 & av3;
    assign vw03 = av0 & aw3;
    assign vx03 = av0 & ax3;
    assign vy03 = av0 & ay3;
    assign wv03 = aw0 & av3;
    assign ww03 = aw0 & aw3;
    assign wx03 = aw0 & ax3;
    assign wy03 = aw0 & ay3;
    assign xv03 = ax0 & av3;
    assign xw03 = ax0 & aw3;
    assign xx03 = ax0 & ax3;
    assign xy03 = ax0 & ay3;
    assign yv03 = ay0 & av3;
    assign yw03 = ay0 & aw3;
    assign yx03 = ay0 & ax3;
    assign yy03 = ay0 & ay3;
    
    assign z03 = vv03 ^ vw03 ^ wv03 ^ vx03 ^ xv03;
    
    assign vv12 = av1 & av2;
    assign vw12 = av1 & aw2;
    assign vx12 = av1 & ax2;
    assign vy12 = av1 & ay2;
    assign wv12 = aw1 & av2;
    assign ww12 = aw1 & aw2;
    assign wx12 = aw1 & ax2;
    assign wy12 = aw1 & ay2;
    assign xv12 = ax1 & av2;
    assign xw12 = ax1 & aw2;
    assign xx12 = ax1 & ax2;
    assign xy12 = ax1 & ay2;
    assign yv12 = ay1 & av2;
    assign yw12 = ay1 & aw2;
    assign yx12 = ay1 & ax2;
    assign yy12 = ay1 & ay2;

    assign z12 = vv12 ^ vw12 ^ wv12 ^ vx12 ^ xv12;
    
    assign vv13 = av1 & av3;
    assign vw13 = av1 & aw3;
    assign vx13 = av1 & ax3;
    assign vy13 = av1 & ay3;
    assign wv13 = aw1 & av3;
    assign ww13 = aw1 & aw3;
    assign wx13 = aw1 & ax3;
    assign wy13 = aw1 & ay3;
    assign xv13 = ax1 & av3;
    assign xw13 = ax1 & aw3;
    assign xx13 = ax1 & ax3;
    assign xy13 = ax1 & ay3;
    assign yv13 = ay1 & av3;
    assign yw13 = ay1 & aw3;
    assign yx13 = ay1 & ax3;
    assign yy13 = ay1 & ay3;

    assign z13 = vv13 ^ vw13 ^ wv13 ^ vx13 ^ xv13;
    
    assign vv23 = av2 & av3;
    assign vw23 = av2 & aw3;
    assign vx23 = av2 & ax3;
    assign vy23 = av2 & ay3;
    assign wv23 = aw2 & av3;
    assign ww23 = aw2 & aw3;
    assign wx23 = aw2 & ax3;
    assign wy23 = aw2 & ay3;
    assign xv23 = ax2 & av3;
    assign xw23 = ax2 & aw3;
    assign xx23 = ax2 & ax3;
    assign xy23 = ax2 & ay3;
    assign yv23 = ay2 & av3;
    assign yw23 = ay2 & aw3;
    assign yx23 = ay2 & ax3;
    assign yy23 = ay2 & ay3;
    
    assign z23 = vv23 ^ vw23 ^ wv23 ^ vx23 ^ xv23;
    
    assign vvv012 = vv01 & av2;
    assign vvw012 = vv01 & aw2;
    assign vvx012 = vv01 & ax2;
    assign vvy012 = vv01 & ay2;
    assign vwv012 = vw01 & av2;
    assign vww012 = vw01 & aw2;
    assign vwx012 = vw01 & ax2;
    assign vwy012 = vw01 & ay2;
    assign vxv012 = vx01 & av2;
    assign vxw012 = vx01 & aw2;
    assign vxx012 = vx01 & ax2;
    assign vxy012 = vx01 & ay2;
    assign vyv012 = vy01 & av2;
    assign vyw012 = vy01 & aw2;
    assign vyx012 = vy01 & ax2;
    assign vyy012 = vy01 & ay2;
    assign wvv012 = wv01 & av2;
    assign wvw012 = wv01 & aw2;
    assign wvx012 = wv01 & ax2;
    assign wvy012 = wv01 & ay2;
    assign wwv012 = ww01 & av2;
    assign www012 = ww01 & aw2;
    assign wwx012 = ww01 & ax2;
    assign wwy012 = ww01 & ay2;
    assign wxv012 = wx01 & av2;
    assign wxw012 = wx01 & aw2;
    assign wxx012 = wx01 & ax2;
    assign wxy012 = wx01 & ay2;
    assign wyv012 = wy01 & av2;
    assign wyw012 = wy01 & aw2;
    assign wyx012 = wy01 & ax2;
    assign wyy012 = wy01 & ay2;
    assign xvv012 = xv01 & av2;
    assign xvw012 = xv01 & aw2;
    assign xvx012 = xv01 & ax2;
    assign xvy012 = xv01 & ay2;
    assign xwv012 = xw01 & av2;
    assign xww012 = xw01 & aw2;
    assign xwx012 = xw01 & ax2;
    assign xwy012 = xw01 & ay2;
    assign xxv012 = xx01 & av2;
    assign xxw012 = xx01 & aw2;
    assign xxx012 = xx01 & ax2;
    assign xxy012 = xx01 & ay2;
    assign xyv012 = xy01 & av2;
    assign xyw012 = xy01 & aw2;
    assign xyx012 = xy01 & ax2;
    assign xyy012 = xy01 & ay2;
    assign yvv012 = yv01 & av2;
    assign yvw012 = yv01 & aw2;
    assign yvx012 = yv01 & ax2;
    assign yvy012 = yv01 & ay2;
    assign ywv012 = yw01 & av2;
    assign yww012 = yw01 & aw2;
    assign ywx012 = yw01 & ax2;
    assign ywy012 = yw01 & ay2;
    assign yxv012 = yx01 & av2;
    assign yxw012 = yx01 & aw2;
    assign yxx012 = yx01 & ax2;
    assign yxy012 = yx01 & ay2;
    assign yyv012 = yy01 & av2;
    assign yyw012 = yy01 & aw2;
    assign yyx012 = yy01 & ax2;
    assign yyy012 = yy01 & ay2;
    
    assign z012 = vvv012 ^ vvw012 ^ vwv012 ^ vww012 ^ wvv012 ^ wvw012 ^ wwv012 ^ vvx012 ^ vxv012 ^ vxx012 ^ xvv012 ^ xvx012 ^ xxv012 ^ vwx012 ^ vxw012 ^ wvx012 ^ wxv012 ^ xvw012 ^ xwv012 ^ vwy012 ^ vyw012 ^ wvy012 ^ wyv012 ^ yvw012 ^ ywv012;
    
    assign vvv013 = vv01 & av3;
    assign vvw013 = vv01 & aw3;
    assign vvx013 = vv01 & ax3;
    assign vvy013 = vv01 & ay3;
    assign vwv013 = vw01 & av3;
    assign vww013 = vw01 & aw3;
    assign vwx013 = vw01 & ax3;
    assign vwy013 = vw01 & ay3;
    assign vxv013 = vx01 & av3;
    assign vxw013 = vx01 & aw3;
    assign vxx013 = vx01 & ax3;
    assign vxy013 = vx01 & ay3;
    assign vyv013 = vy01 & av3;
    assign vyw013 = vy01 & aw3;
    assign vyx013 = vy01 & ax3;
    assign vyy013 = vy01 & ay3;
    assign wvv013 = wv01 & av3;
    assign wvw013 = wv01 & aw3;
    assign wvx013 = wv01 & ax3;
    assign wvy013 = wv01 & ay3;
    assign wwv013 = ww01 & av3;
    assign www013 = ww01 & aw3;
    assign wwx013 = ww01 & ax3;
    assign wwy013 = ww01 & ay3;
    assign wxv013 = wx01 & av3;
    assign wxw013 = wx01 & aw3;
    assign wxx013 = wx01 & ax3;
    assign wxy013 = wx01 & ay3;
    assign wyv013 = wy01 & av3;
    assign wyw013 = wy01 & aw3;
    assign wyx013 = wy01 & ax3;
    assign wyy013 = wy01 & ay3;
    assign xvv013 = xv01 & av3;
    assign xvw013 = xv01 & aw3;
    assign xvx013 = xv01 & ax3;
    assign xvy013 = xv01 & ay3;
    assign xwv013 = xw01 & av3;
    assign xww013 = xw01 & aw3;
    assign xwx013 = xw01 & ax3;
    assign xwy013 = xw01 & ay3;
    assign xxv013 = xx01 & av3;
    assign xxw013 = xx01 & aw3;
    assign xxx013 = xx01 & ax3;
    assign xxy013 = xx01 & ay3;
    assign xyv013 = xy01 & av3;
    assign xyw013 = xy01 & aw3;
    assign xyx013 = xy01 & ax3;
    assign xyy013 = xy01 & ay3;
    assign yvv013 = yv01 & av3;
    assign yvw013 = yv01 & aw3;
    assign yvx013 = yv01 & ax3;
    assign yvy013 = yv01 & ay3;
    assign ywv013 = yw01 & av3;
    assign yww013 = yw01 & aw3;
    assign ywx013 = yw01 & ax3;
    assign ywy013 = yw01 & ay3;
    assign yxv013 = yx01 & av3;
    assign yxw013 = yx01 & aw3;
    assign yxx013 = yx01 & ax3;
    assign yxy013 = yx01 & ay3;
    assign yyv013 = yy01 & av3;
    assign yyw013 = yy01 & aw3;
    assign yyx013 = yy01 & ax3;
    assign yyy013 = yy01 & ay3;
    
    assign z013 = vvv013 ^ vvw013 ^ vwv013 ^ vww013 ^ wvv013 ^ wvw013 ^ wwv013 ^ vvx013 ^ vxv013 ^ vxx013 ^ xvv013 ^ xvx013 ^ xxv013 ^ vwx013 ^ vxw013 ^ wvx013 ^ wxv013 ^ xvw013 ^ xwv013 ^ vwy013 ^ vyw013 ^ wvy013 ^ wyv013 ^ yvw013 ^ ywv013;
    
    assign vvv023 = vv02 & av3;
    assign vvw023 = vv02 & aw3;
    assign vvx023 = vv02 & ax3;
    assign vvy023 = vv02 & ay3;
    assign vwv023 = vw02 & av3;
    assign vww023 = vw02 & aw3;
    assign vwx023 = vw02 & ax3;
    assign vwy023 = vw02 & ay3;
    assign vxv023 = vx02 & av3;
    assign vxw023 = vx02 & aw3;
    assign vxx023 = vx02 & ax3;
    assign vxy023 = vx02 & ay3;
    assign vyv023 = vy02 & av3;
    assign vyw023 = vy02 & aw3;
    assign vyx023 = vy02 & ax3;
    assign vyy023 = vy02 & ay3;
    assign wvv023 = wv02 & av3;
    assign wvw023 = wv02 & aw3;
    assign wvx023 = wv02 & ax3;
    assign wvy023 = wv02 & ay3;
    assign wwv023 = ww02 & av3;
    assign www023 = ww02 & aw3;
    assign wwx023 = ww02 & ax3;
    assign wwy023 = ww02 & ay3;
    assign wxv023 = wx02 & av3;
    assign wxw023 = wx02 & aw3;
    assign wxx023 = wx02 & ax3;
    assign wxy023 = wx02 & ay3;
    assign wyv023 = wy02 & av3;
    assign wyw023 = wy02 & aw3;
    assign wyx023 = wy02 & ax3;
    assign wyy023 = wy02 & ay3;
    assign xvv023 = xv02 & av3;
    assign xvw023 = xv02 & aw3;
    assign xvx023 = xv02 & ax3;
    assign xvy023 = xv02 & ay3;
    assign xwv023 = xw02 & av3;
    assign xww023 = xw02 & aw3;
    assign xwx023 = xw02 & ax3;
    assign xwy023 = xw02 & ay3;
    assign xxv023 = xx02 & av3;
    assign xxw023 = xx02 & aw3;
    assign xxx023 = xx02 & ax3;
    assign xxy023 = xx02 & ay3;
    assign xyv023 = xy02 & av3;
    assign xyw023 = xy02 & aw3;
    assign xyx023 = xy02 & ax3;
    assign xyy023 = xy02 & ay3;
    assign yvv023 = yv02 & av3;
    assign yvw023 = yv02 & aw3;
    assign yvx023 = yv02 & ax3;
    assign yvy023 = yv02 & ay3;
    assign ywv023 = yw02 & av3;
    assign yww023 = yw02 & aw3;
    assign ywx023 = yw02 & ax3;
    assign ywy023 = yw02 & ay3;
    assign yxv023 = yx02 & av3;
    assign yxw023 = yx02 & aw3;
    assign yxx023 = yx02 & ax3;
    assign yxy023 = yx02 & ay3;
    assign yyv023 = yy02 & av3;
    assign yyw023 = yy02 & aw3;
    assign yyx023 = yy02 & ax3;
    assign yyy023 = yy02 & ay3;

    assign z023 = vvv023 ^ vvw023 ^ vwv023 ^ vww023 ^ wvv023 ^ wvw023 ^ wwv023 ^ vvx023 ^ vxv023 ^ vxx023 ^ xvv023 ^ xvx023 ^ xxv023 ^ vwx023 ^ vxw023 ^ wvx023 ^ wxv023 ^ xvw023 ^ xwv023 ^ vwy023 ^ vyw023 ^ wvy023 ^ wyv023 ^ yvw023 ^ ywv023;
    
    assign vvv123 = vv12 & av3;
    assign vvw123 = vv12 & aw3;
    assign vvx123 = vv12 & ax3;
    assign vvy123 = vv12 & ay3;
    assign vwv123 = vw12 & av3;
    assign vww123 = vw12 & aw3;
    assign vwx123 = vw12 & ax3;
    assign vwy123 = vw12 & ay3;
    assign vxv123 = vx12 & av3;
    assign vxw123 = vx12 & aw3;
    assign vxx123 = vx12 & ax3;
    assign vxy123 = vx12 & ay3;
    assign vyv123 = vy12 & av3;
    assign vyw123 = vy12 & aw3;
    assign vyx123 = vy12 & ax3;
    assign vyy123 = vy12 & ay3;
    assign wvv123 = wv12 & av3;
    assign wvw123 = wv12 & aw3;
    assign wvx123 = wv12 & ax3;
    assign wvy123 = wv12 & ay3;
    assign wwv123 = ww12 & av3;
    assign www123 = ww12 & aw3;
    assign wwx123 = ww12 & ax3;
    assign wwy123 = ww12 & ay3;
    assign wxv123 = wx12 & av3;
    assign wxw123 = wx12 & aw3;
    assign wxx123 = wx12 & ax3;
    assign wxy123 = wx12 & ay3;
    assign wyv123 = wy12 & av3;
    assign wyw123 = wy12 & aw3;
    assign wyx123 = wy12 & ax3;
    assign wyy123 = wy12 & ay3;
    assign xvv123 = xv12 & av3;
    assign xvw123 = xv12 & aw3;
    assign xvx123 = xv12 & ax3;
    assign xvy123 = xv12 & ay3;
    assign xwv123 = xw12 & av3;
    assign xww123 = xw12 & aw3;
    assign xwx123 = xw12 & ax3;
    assign xwy123 = xw12 & ay3;
    assign xxv123 = xx12 & av3;
    assign xxw123 = xx12 & aw3;
    assign xxx123 = xx12 & ax3;
    assign xxy123 = xx12 & ay3;
    assign xyv123 = xy12 & av3;
    assign xyw123 = xy12 & aw3;
    assign xyx123 = xy12 & ax3;
    assign xyy123 = xy12 & ay3;
    assign yvv123 = yv12 & av3;
    assign yvw123 = yv12 & aw3;
    assign yvx123 = yv12 & ax3;
    assign yvy123 = yv12 & ay3;
    assign ywv123 = yw12 & av3;
    assign yww123 = yw12 & aw3;
    assign ywx123 = yw12 & ax3;
    assign ywy123 = yw12 & ay3;
    assign yxv123 = yx12 & av3;
    assign yxw123 = yx12 & aw3;
    assign yxx123 = yx12 & ax3;
    assign yxy123 = yx12 & ay3;
    assign yyv123 = yy12 & av3;
    assign yyw123 = yy12 & aw3;
    assign yyx123 = yy12 & ax3;
    assign yyy123 = yy12 & ay3;

    assign z123 = vvv123 ^ vvw123 ^ vwv123 ^ vww123 ^ wvv123 ^ wvw123 ^ wwv123 ^ vvx123 ^ vxv123 ^ vxx123 ^ xvv123 ^ xvx123 ^ xxv123 ^ vwx123 ^ vxw123 ^ wvx123 ^ wxv123 ^ xvw123 ^ xwv123 ^ vwy123 ^ vyw123 ^ wvy123 ^ wyv123 ^ yvw123 ^ ywv123;  
    

    assign z_z[0] = z01 ^ z2 ^ z12 ^ z012 ^ z3 ^ z023;
    assign z_z[1] = z02 ^ z12 ^ z012 ^ z3 ^ z13 ^ z023 ^ z123;
    assign z_z[2] = z0 ^ z01 ^ z03 ^ z13 ^ z013 ^ z23 ^ z123;
    assign z_z[3] = z1 ^ z12 ^ z012 ^ z03 ^ z013;  
endmodule
