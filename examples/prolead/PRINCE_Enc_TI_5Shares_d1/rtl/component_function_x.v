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

module component_function_x(
    input [3:0] v,
    input [3:0] w,
    input [3:0] y,
    input [3:0] z,
    output [3:0] z_x
    );
    
    wire v0,w0,x0,y0,z0, v1,w1,x1,y1,z1, v2,w2,x2,y2,z2, v3,w3,x3,y3,z3;
    wire av0,aw0,ay0,az0, av1,aw1,ay1,az1, av2,aw2,ay2,az2, av3,aw3,ay3,az3;
    
    wire vv01,vw01,vy01,vz01, wv01,ww01,wy01,wz01, yv01,yw01,yy01,yz01, zv01,zw01,zy01,zz01;
    wire vv02,vw02,vy02,vz02, wv02,ww02,wy02,wz02, yv02,yw02,yy02,yz02, zv02,zw02,zy02,zz02;
    wire vv03,vw03,vy03,vz03, wv03,ww03,wy03,wz03, yv03,yw03,yy03,yz03, zv03,zw03,zy03,zz03;
    wire vv12,vw12,vy12,vz12, wv12,ww12,wy12,wz12, yv12,yw12,yy12,yz12, zv12,zw12,zy12,zz12;
    wire vv13,vw13,vy13,vz13, wv13,ww13,wy13,wz13, yv13,yw13,yy13,yz13, zv13,zw13,zy13,zz13;
    wire vv23,vw23,vy23,vz23, wv23,ww23,wy23,wz23, yv23,yw23,yy23,yz23, zv23,zw23,zy23,zz23;
    
    wire vvv012,vvw012,vvy012,vvz012, vwv012,vww012,vwy012,vwz012, vyv012,vyw012,vyy012,vyz012, vzv012,vzw012,vzy012,vzz012;
    wire wvv012,wvw012,wvy012,wvz012, wwv012,www012,wwy012,wwz012, wyv012,wyw012,wyy012,wyz012, wzv012,wzw012,wzy012,wzz012;
    wire yvv012,yvw012,yvy012,yvz012, ywv012,yww012,ywy012,ywz012, yyv012,yyw012,yyy012,yyz012, yzv012,yzw012,yzy012,yzz012;
    wire zvv012,zvw012,zvy012,zvz012, zwv012,zww012,zwy012,zwz012, zyv012,zyw012,zyy012,zyz012, zzv012,zzw012,zzy012,zzz012;

    wire vvv013,vvw013,vvy013,vvz013, vwv013,vww013,vwy013,vwz013, vyv013,vyw013,vyy013,vyz013, vzv013,vzw013,vzy013,vzz013;
    wire wvv013,wvw013,wvy013,wvz013, wwv013,www013,wwy013,wwz013, wyv013,wyw013,wyy013,wyz013, wzv013,wzw013,wzy013,wzz013;
    wire yvv013,yvw013,yvy013,yvz013, ywv013,yww013,ywy013,ywz013, yyv013,yyw013,yyy013,yyz013, yzv013,yzw013,yzy013,yzz013;
    wire zvv013,zvw013,zvy013,zvz013, zwv013,zww013,zwy013,zwz013, zyv013,zyw013,zyy013,zyz013, zzv013,zzw013,zzy013,zzz013;
    
    wire vvv023,vvw023,vvy023,vvz023, vwv023,vww023,vwy023,vwz023, vyv023,vyw023,vyy023,vyz023, vzv023,vzw023,vzy023,vzz023;
    wire wvv023,wvw023,wvy023,wvz023, wwv023,www023,wwy023,wwz023, wyv023,wyw023,wyy023,wyz023, wzv023,wzw023,wzy023,wzz023;
    wire yvv023,yvw023,yvy023,yvz023, ywv023,yww023,ywy023,ywz023, yyv023,yyw023,yyy023,yyz023, yzv023,yzw023,yzy023,yzz023;
    wire zvv023,zvw023,zvy023,zvz023, zwv023,zww023,zwy023,zwz023, zyv023,zyw023,zyy023,zyz023, zzv023,zzw023,zzy023,zzz023;
    
    wire vvv123,vvw123,vvy123,vvz123, vwv123,vww123,vwy123,vwz123, vyv123,vyw123,vyy123,vyz123, vzv123,vzw123,vzy123,vzz123;
    wire wvv123,wvw123,wvy123,wvz123, wwv123,www123,wwy123,wwz123, wyv123,wyw123,wyy123,wyz123, wzv123,wzw123,wzy123,wzz123;
    wire yvv123,yvw123,yvy123,yvz123, ywv123,yww123,ywy123,ywz123, yyv123,yyw123,yyy123,yyz123, yzv123,yzw123,yzy123,yzz123;
    wire zvv123,zvw123,zvy123,zvz123, zwv123,zww123,zwy123,zwz123, zyv123,zyw123,zyy123,zyz123, zzv123,zzw123,zzy123,zzz123;
    
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
    assign ay0 = y[0];
    assign az0 = z[0];
    
    assign av1 = v[1] ^ v[3];
    assign aw1 = w[1] ^ w[3];
    assign ay1 = y[1] ^ y[3];
    assign az1 = z[1] ^ z[3];
    
    assign av2 = v[2];
    assign aw2 = w[2];
    assign ay2 = y[2];
    assign az2 = z[2];
    
    assign av3 = v[3];
    assign aw3 = w[3];
    assign ay3 = y[3];
    assign az3 = z[3];
    
    assign v0 = aw0;
    assign x0 = ay0;
    assign y0 = az0;
    assign z0 = av0;
    
    assign v1 = aw1;
    assign x1 = ay1;
    assign y1 = az1;
    assign z1 = av1;
    
    assign v2 = aw2;
    assign x2 = ay2;
    assign y2 = az2;
    assign z2 = av2;
    
    assign v3 = aw3;
    assign x3 = ay3;
    assign y3 = az3;
    assign z3 = av3;
    
    assign vv01 = av0 & av1;
    assign vw01 = av0 & aw1;
    assign vy01 = av0 & ay1;
    assign vz01 = av0 & az1;
    assign wv01 = aw0 & av1;
    assign ww01 = aw0 & aw1;
    assign wy01 = aw0 & ay1;
    assign wz01 = aw0 & az1;
    assign yv01 = ay0 & av1;
    assign yw01 = ay0 & aw1;
    assign yy01 = ay0 & ay1;
    assign yz01 = ay0 & az1;   
    assign zv01 = az0 & av1;
    assign zw01 = az0 & aw1;
    assign zy01 = az0 & ay1;
    assign zz01 = az0 & az1;
    
    assign x01 = yy01 ^ yz01 ^ zy01 ^ yv01 ^ vy01;
    
    assign vv02 = av0 & av2;
    assign vw02 = av0 & aw2;
    assign vy02 = av0 & ay2;
    assign vz02 = av0 & az2;
    assign wv02 = aw0 & av2;
    assign ww02 = aw0 & aw2;
    assign wy02 = aw0 & ay2;
    assign wz02 = aw0 & az2;
    assign yv02 = ay0 & av2;
    assign yw02 = ay0 & aw2;
    assign yy02 = ay0 & ay2;
    assign yz02 = ay0 & az2;   
    assign zv02 = az0 & av2;
    assign zw02 = az0 & aw2;
    assign zy02 = az0 & ay2;
    assign zz02 = az0 & az2;
    
    assign x02 = yy02 ^ yz02 ^ zy02 ^ yv02 ^ vy02;
    
    assign vv03 = av0 & av3;
    assign vw03 = av0 & aw3;
    assign vy03 = av0 & ay3;
    assign vz03 = av0 & az3;
    assign wv03 = aw0 & av3;
    assign ww03 = aw0 & aw3;
    assign wy03 = aw0 & ay3;
    assign wz03 = aw0 & az3;
    assign yv03 = ay0 & av3;
    assign yw03 = ay0 & aw3;
    assign yy03 = ay0 & ay3;
    assign yz03 = ay0 & az3;   
    assign zv03 = az0 & av3;
    assign zw03 = az0 & aw3;
    assign zy03 = az0 & ay3;
    assign zz03 = az0 & az3;
    
    assign x03 = yy03 ^ yz03 ^ zy03 ^ yv03 ^ vy03;
    
    assign vv12 = av1 & av2;
    assign vw12 = av1 & aw2;
    assign vy12 = av1 & ay2;
    assign vz12 = av1 & az2;
    assign wv12 = aw1 & av2;
    assign ww12 = aw1 & aw2;
    assign wy12 = aw1 & ay2;
    assign wz12 = aw1 & az2;
    assign yv12 = ay1 & av2;
    assign yw12 = ay1 & aw2;
    assign yy12 = ay1 & ay2;
    assign yz12 = ay1 & az2;   
    assign zv12 = az1 & av2;
    assign zw12 = az1 & aw2;
    assign zy12 = az1 & ay2;
    assign zz12 = az1 & az2;
    
    assign x12 = yy12 ^ yz12 ^ zy12 ^ yv12 ^ vy12;
    
    assign vv13 = av1 & av3;
    assign vw13 = av1 & aw3;
    assign vy13 = av1 & ay3;
    assign vz13 = av1 & az3;
    assign wv13 = aw1 & av3;
    assign ww13 = aw1 & aw3;
    assign wy13 = aw1 & ay3;
    assign wz13 = aw1 & az3;
    assign yv13 = ay1 & av3;
    assign yw13 = ay1 & aw3;
    assign yy13 = ay1 & ay3;
    assign yz13 = ay1 & az3;   
    assign zv13 = az1 & av3;
    assign zw13 = az1 & aw3;
    assign zy13 = az1 & ay3;
    assign zz13 = az1 & az3;
    
    assign x13 = yy13 ^ yz13 ^ zy13 ^ yv13 ^ vy13;
    
    assign vv23 = av2 & av3;
    assign vw23 = av2 & aw3;
    assign vy23 = av2 & ay3;
    assign vz23 = av2 & az3;
    assign wv23 = aw2 & av3;
    assign ww23 = aw2 & aw3;
    assign wy23 = aw2 & ay3;
    assign wz23 = aw2 & az3;
    assign yv23 = ay2 & av3;
    assign yw23 = ay2 & aw3;
    assign yy23 = ay2 & ay3;
    assign yz23 = ay2 & az3;   
    assign zv23 = az2 & av3;
    assign zw23 = az2 & aw3;
    assign zy23 = az2 & ay3;
    assign zz23 = az2 & az3;
    
    assign x23 = yy23 ^ yz23 ^ zy23 ^ yv23 ^ vy23;
    
    assign vvv012 = vv01 & av2;
    assign vvw012 = vv01 & aw2;
    assign vvy012 = vv01 & ay2;
    assign vvz012 = vv01 & az2;
    assign vwv012 = vw01 & av2;
    assign vww012 = vw01 & aw2;
    assign vwy012 = vw01 & ay2;
    assign vwz012 = vw01 & az2;
    assign vyv012 = vy01 & av2;
    assign vyw012 = vy01 & aw2;
    assign vyy012 = vy01 & ay2;
    assign vyz012 = vy01 & az2;
    assign vzv012 = vz01 & av2;
    assign vzw012 = vz01 & aw2;
    assign vzy012 = vz01 & ay2;
    assign vzz012 = vz01 & az2;
    assign wvv012 = wv01 & av2;
    assign wvw012 = wv01 & aw2;
    assign wvy012 = wv01 & ay2;
    assign wvz012 = wv01 & az2;
    assign wwv012 = ww01 & av2;
    assign www012 = ww01 & aw2;
    assign wwy012 = ww01 & ay2;
    assign wwz012 = ww01 & az2;
    assign wyv012 = wy01 & av2;
    assign wyw012 = wy01 & aw2;
    assign wyy012 = wy01 & ay2;
    assign wyz012 = wy01 & az2;
    assign wzv012 = wz01 & av2;
    assign wzw012 = wz01 & aw2;
    assign wzy012 = wz01 & ay2;
    assign wzz012 = wz01 & az2;
    assign yvv012 = yv01 & av2;
    assign yvw012 = yv01 & aw2;
    assign yvy012 = yv01 & ay2;
    assign yvz012 = yv01 & az2;
    assign ywv012 = yw01 & av2;
    assign yww012 = yw01 & aw2;
    assign ywy012 = yw01 & ay2;
    assign ywz012 = yw01 & az2;
    assign yyv012 = yy01 & av2;
    assign yyw012 = yy01 & aw2;
    assign yyy012 = yy01 & ay2;
    assign yyz012 = yy01 & az2;
    assign yzv012 = yz01 & av2;
    assign yzw012 = yz01 & aw2;
    assign yzy012 = yz01 & ay2;
    assign yzz012 = yz01 & az2; 
    assign zvv012 = zv01 & av2;
    assign zvw012 = zv01 & aw2;
    assign zvy012 = zv01 & ay2;
    assign zvz012 = zv01 & az2;
    assign zwv012 = zw01 & av2;
    assign zww012 = zw01 & aw2;
    assign zwy012 = zw01 & ay2;
    assign zwz012 = zw01 & az2;
    assign zyv012 = zy01 & av2;
    assign zyw012 = zy01 & aw2;
    assign zyy012 = zy01 & ay2;
    assign zyz012 = zy01 & az2;
    assign zzv012 = zz01 & av2;
    assign zzw012 = zz01 & aw2;
    assign zzy012 = zz01 & ay2;
    assign zzz012 = zz01 & az2;
    
    assign x012 = yyy012 ^ yyz012 ^ yzy012 ^ yzz012 ^ zyy012 ^ zyz012 ^ zzy012 ^ yyv012 ^ yvy012 ^ yvv012 ^ vyy012 ^ vyv012 ^ vvy012 ^ yzv012 ^ yvz012 ^ zyv012 ^ zvy012 ^ vyz012 ^ vzy012 ^ yzw012 ^ ywz012 ^ zyw012 ^ zwy012 ^ wyz012 ^ wzy012;

    assign vvv013 = vv01 & av3;
    assign vvw013 = vv01 & aw3;
    assign vvy013 = vv01 & ay3;
    assign vvz013 = vv01 & az3;
    assign vwv013 = vw01 & av3;
    assign vww013 = vw01 & aw3;
    assign vwy013 = vw01 & ay3;
    assign vwz013 = vw01 & az3;
    assign vyv013 = vy01 & av3;
    assign vyw013 = vy01 & aw3;
    assign vyy013 = vy01 & ay3;
    assign vyz013 = vy01 & az3;
    assign vzv013 = vz01 & av3;
    assign vzw013 = vz01 & aw3;
    assign vzy013 = vz01 & ay3;
    assign vzz013 = vz01 & az3;
    assign wvv013 = wv01 & av3;
    assign wvw013 = wv01 & aw3;
    assign wvy013 = wv01 & ay3;
    assign wvz013 = wv01 & az3;
    assign wwv013 = ww01 & av3;
    assign www013 = ww01 & aw3;
    assign wwy013 = ww01 & ay3;
    assign wwz013 = ww01 & az3;
    assign wyv013 = wy01 & av3;
    assign wyw013 = wy01 & aw3;
    assign wyy013 = wy01 & ay3;
    assign wyz013 = wy01 & az3;
    assign wzv013 = wz01 & av3;
    assign wzw013 = wz01 & aw3;
    assign wzy013 = wz01 & ay3;
    assign wzz013 = wz01 & az3;
    assign yvv013 = yv01 & av3;
    assign yvw013 = yv01 & aw3;
    assign yvy013 = yv01 & ay3;
    assign yvz013 = yv01 & az3;
    assign ywv013 = yw01 & av3;
    assign yww013 = yw01 & aw3;
    assign ywy013 = yw01 & ay3;
    assign ywz013 = yw01 & az3;
    assign yyv013 = yy01 & av3;
    assign yyw013 = yy01 & aw3;
    assign yyy013 = yy01 & ay3;
    assign yyz013 = yy01 & az3;
    assign yzv013 = yz01 & av3;
    assign yzw013 = yz01 & aw3;
    assign yzy013 = yz01 & ay3;
    assign yzz013 = yz01 & az3; 
    assign zvv013 = zv01 & av3;
    assign zvw013 = zv01 & aw3;
    assign zvy013 = zv01 & ay3;
    assign zvz013 = zv01 & az3;
    assign zwv013 = zw01 & av3;
    assign zww013 = zw01 & aw3;
    assign zwy013 = zw01 & ay3;
    assign zwz013 = zw01 & az3;
    assign zyv013 = zy01 & av3;
    assign zyw013 = zy01 & aw3;
    assign zyy013 = zy01 & ay3;
    assign zyz013 = zy01 & az3;
    assign zzv013 = zz01 & av3;
    assign zzw013 = zz01 & aw3;
    assign zzy013 = zz01 & ay3;
    assign zzz013 = zz01 & az3;
    
    assign x013 = yyy013 ^ yyz013 ^ yzy013 ^ yzz013 ^ zyy013 ^ zyz013 ^ zzy013 ^ yyv013 ^ yvy013 ^ yvv013 ^ vyy013 ^ vyv013 ^ vvy013 ^ yzv013 ^ yvz013 ^ zyv013 ^ zvy013 ^ vyz013 ^ vzy013 ^ yzw013 ^ ywz013 ^ zyw013 ^ zwy013 ^ wyz013 ^ wzy013;

    assign vvv023 = vv02 & av3;
    assign vvw023 = vv02 & aw3;
    assign vvy023 = vv02 & ay3;
    assign vvz023 = vv02 & az3;
    assign vwv023 = vw02 & av3;
    assign vww023 = vw02 & aw3;
    assign vwy023 = vw02 & ay3;
    assign vwz023 = vw02 & az3;
    assign vyv023 = vy02 & av3;
    assign vyw023 = vy02 & aw3;
    assign vyy023 = vy02 & ay3;
    assign vyz023 = vy02 & az3;
    assign vzv023 = vz02 & av3;
    assign vzw023 = vz02 & aw3;
    assign vzy023 = vz02 & ay3;
    assign vzz023 = vz02 & az3;
    assign wvv023 = wv02 & av3;
    assign wvw023 = wv02 & aw3;
    assign wvy023 = wv02 & ay3;
    assign wvz023 = wv02 & az3;
    assign wwv023 = ww02 & av3;
    assign www023 = ww02 & aw3;
    assign wwy023 = ww02 & ay3;
    assign wwz023 = ww02 & az3;
    assign wyv023 = wy02 & av3;
    assign wyw023 = wy02 & aw3;
    assign wyy023 = wy02 & ay3;
    assign wyz023 = wy02 & az3;
    assign wzv023 = wz02 & av3;
    assign wzw023 = wz02 & aw3;
    assign wzy023 = wz02 & ay3;
    assign wzz023 = wz02 & az3;
    assign yvv023 = yv02 & av3;
    assign yvw023 = yv02 & aw3;
    assign yvy023 = yv02 & ay3;
    assign yvz023 = yv02 & az3;
    assign ywv023 = yw02 & av3;
    assign yww023 = yw02 & aw3;
    assign ywy023 = yw02 & ay3;
    assign ywz023 = yw02 & az3;
    assign yyv023 = yy02 & av3;
    assign yyw023 = yy02 & aw3;
    assign yyy023 = yy02 & ay3;
    assign yyz023 = yy02 & az3;
    assign yzv023 = yz02 & av3;
    assign yzw023 = yz02 & aw3;
    assign yzy023 = yz02 & ay3;
    assign yzz023 = yz02 & az3; 
    assign zvv023 = zv02 & av3;
    assign zvw023 = zv02 & aw3;
    assign zvy023 = zv02 & ay3;
    assign zvz023 = zv02 & az3;
    assign zwv023 = zw02 & av3;
    assign zww023 = zw02 & aw3;
    assign zwy023 = zw02 & ay3;
    assign zwz023 = zw02 & az3;
    assign zyv023 = zy02 & av3;
    assign zyw023 = zy02 & aw3;
    assign zyy023 = zy02 & ay3;
    assign zyz023 = zy02 & az3;
    assign zzv023 = zz02 & av3;
    assign zzw023 = zz02 & aw3;
    assign zzy023 = zz02 & ay3;
    assign zzz023 = zz02 & az3;
    
    assign x023 = yyy023 ^ yyz023 ^ yzy023 ^ yzz023 ^ zyy023 ^ zyz023 ^ zzy023 ^ yyv023 ^ yvy023 ^ yvv023 ^ vyy023 ^ vyv023 ^ vvy023 ^ yzv023 ^ yvz023 ^ zyv023 ^ zvy023 ^ vyz023 ^ vzy023 ^ yzw023 ^ ywz023 ^ zyw023 ^ zwy023 ^ wyz023 ^ wzy023;

    assign vvv123 = vv12 & av3;
    assign vvw123 = vv12 & aw3;
    assign vvy123 = vv12 & ay3;
    assign vvz123 = vv12 & az3;
    assign vwv123 = vw12 & av3;
    assign vww123 = vw12 & aw3;
    assign vwy123 = vw12 & ay3;
    assign vwz123 = vw12 & az3;
    assign vyv123 = vy12 & av3;
    assign vyw123 = vy12 & aw3;
    assign vyy123 = vy12 & ay3;
    assign vyz123 = vy12 & az3;
    assign vzv123 = vz12 & av3;
    assign vzw123 = vz12 & aw3;
    assign vzy123 = vz12 & ay3;
    assign vzz123 = vz12 & az3;
    assign wvv123 = wv12 & av3;
    assign wvw123 = wv12 & aw3;
    assign wvy123 = wv12 & ay3;
    assign wvz123 = wv12 & az3;
    assign wwv123 = ww12 & av3;
    assign www123 = ww12 & aw3;
    assign wwy123 = ww12 & ay3;
    assign wwz123 = ww12 & az3;
    assign wyv123 = wy12 & av3;
    assign wyw123 = wy12 & aw3;
    assign wyy123 = wy12 & ay3;
    assign wyz123 = wy12 & az3;
    assign wzv123 = wz12 & av3;
    assign wzw123 = wz12 & aw3;
    assign wzy123 = wz12 & ay3;
    assign wzz123 = wz12 & az3;
    assign yvv123 = yv12 & av3;
    assign yvw123 = yv12 & aw3;
    assign yvy123 = yv12 & ay3;
    assign yvz123 = yv12 & az3;
    assign ywv123 = yw12 & av3;
    assign yww123 = yw12 & aw3;
    assign ywy123 = yw12 & ay3;
    assign ywz123 = yw12 & az3;
    assign yyv123 = yy12 & av3;
    assign yyw123 = yy12 & aw3;
    assign yyy123 = yy12 & ay3;
    assign yyz123 = yy12 & az3;
    assign yzv123 = yz12 & av3;
    assign yzw123 = yz12 & aw3;
    assign yzy123 = yz12 & ay3;
    assign yzz123 = yz12 & az3; 
    assign zvv123 = zv12 & av3;
    assign zvw123 = zv12 & aw3;
    assign zvy123 = zv12 & ay3;
    assign zvz123 = zv12 & az3;
    assign zwv123 = zw12 & av3;
    assign zww123 = zw12 & aw3;
    assign zwy123 = zw12 & ay3;
    assign zwz123 = zw12 & az3;
    assign zyv123 = zy12 & av3;
    assign zyw123 = zy12 & aw3;
    assign zyy123 = zy12 & ay3;
    assign zyz123 = zy12 & az3;
    assign zzv123 = zz12 & av3;
    assign zzw123 = zz12 & aw3;
    assign zzy123 = zz12 & ay3;
    assign zzz123 = zz12 & az3;
    
    assign x123 = yyy123 ^ yyz123 ^ yzy123 ^ yzz123 ^ zyy123 ^ zyz123 ^ zzy123 ^ yyv123 ^ yvy123 ^ yvv123 ^ vyy123 ^ vyv123 ^ vvy123 ^ yzv123 ^ yvz123 ^ zyv123 ^ zvy123 ^ vyz123 ^ vzy123 ^ yzw123 ^ ywz123 ^ zyw123 ^ zwy123 ^ wyz123 ^ wzy123;

    assign z_x[0] = x01 ^ x2 ^ x12 ^ x012 ^ x3 ^ x023;
    assign z_x[1] = x02 ^ x12 ^ x012 ^ x3 ^ x13 ^ x023 ^ x123;
    assign z_x[2] = x0 ^ x01 ^ x03 ^ x13 ^ x013 ^ x23 ^ x123;
    assign z_x[3] = x1 ^ x12 ^ x012 ^ x03 ^ x013;
endmodule
