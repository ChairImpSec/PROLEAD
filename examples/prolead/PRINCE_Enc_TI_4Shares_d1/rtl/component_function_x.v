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
    input [3:0] w,
    input [3:0] y,
    input [3:0] z,
    input [3:0] d,
    output [3:0] z_x
    );
    
    wire [3:0] z_x_tmp; 
    
    wire ww01, wy01, wz01, yw01, yy01, yz01, zw01, zy01, zz01;
    wire ww02, wy02, wz02, yw02, yy02, yz02, zw02, zy02, zz02;
    wire ww03, wy03, wz03, yw03, yy03, yz03, zw03, zy03, zz03;
    wire ww12, wy12, wz12, yw12, yy12, yz12, zw12, zy12, zz12;
    wire ww13, wy13, wz13, yw13, yy13, yz13, zw13, zy13, zz13;
    wire ww23, wy23, wz23, yw23, yy23, yz23, zw23, zy23, zz23;
    
    wire www012, wwy012, wwz012, wyw012, wyy012, wyz012, wzw012, wzy012, wzz012;
    wire yww012, ywy012, ywz012, yyw012, yyy012, yyz012, yzw012, yzy012, yzz012;
    wire zww012, zwy012, zwz012, zyw012, zyy012, zyz012, zzw012, zzy012, zzz012;
    
    wire www013, wwy013, wwz013, wyw013, wyy013, wyz013, wzw013, wzy013, wzz013;
    wire yww013, ywy013, ywz013, yyw013, yyy013, yyz013, yzw013, yzy013, yzz013;
    wire zww013, zwy013, zwz013, zyw013, zyy013, zyz013, zzw013, zzy013, zzz013;
    
    wire www023, wwy023, wwz023, wyw023, wyy023, wyz023, wzw023, wzy023, wzz023;
    wire yww023, ywy023, ywz023, yyw023, yyy023, yyz023, yzw023, yzy023, yzz023;
    wire zww023, zwy023, zwz023, zyw023, zyy023, zyz023, zzw023, zzy023, zzz023;
    
    wire www123, wwy123, wwz123, wyw123, wyy123, wyz123, wzw123, wzy123, wzz123;
    wire yww123, ywy123, ywz123, yyw123, yyy123, yyz123, yzw123, yzy123, yzz123;
    wire zww123, zwy123, zwz123, zyw123, zyy123, zyz123, zzw123, zzy123, zzz123;
    
    wire x0, x1, x2, x3;
    
    wire x01;
    wire x02;
    wire x03;
    wire x12;
    wire x13;
    wire x23;
    
    wire x012;
    wire x013;
    wire x023;
    wire x123;
    
    assign x0 = y[0];
    assign x1 = y[1];
    assign x2 = y[2];
    assign x3 = y[3];
    
    assign ww01 = w[0] & w[1];
    assign wy01 = w[0] & y[1];
    assign wz01 = w[0] & z[1];
    assign yw01 = y[0] & w[1];
    assign yy01 = y[0] & y[1];
    assign yz01 = y[0] & z[1];
    assign zw01 = z[0] & w[1];
    assign zy01 = z[0] & y[1];
    assign zz01 = z[0] & z[1];
    
    assign x01 = yw01 ^ yy01 ^ yz01 ^ zy01;
 
    assign ww02 = w[0] & w[2];
    assign wy02 = w[0] & y[2];
    assign wz02 = w[0] & z[2];
    assign yw02 = y[0] & w[2];
    assign yy02 = y[0] & y[2];
    assign yz02 = y[0] & z[2];
    assign zw02 = z[0] & w[2];
    assign zy02 = z[0] & y[2];
    assign zz02 = z[0] & z[2];

    assign x02 = yw02 ^ yy02 ^ yz02 ^ zy02;
    
    assign ww03 = w[0] & w[3];
    assign wy03 = w[0] & y[3];
    assign wz03 = w[0] & z[3];
    assign yw03 = y[0] & w[3];
    assign yy03 = y[0] & y[3];
    assign yz03 = y[0] & z[3];
    assign zw03 = z[0] & w[3];
    assign zy03 = z[0] & y[3];
    assign zz03 = z[0] & z[3];

    assign x03 = yw03 ^ yy03 ^ yz03 ^ zy03;
    
    assign ww12 = w[1] & w[2];
    assign wy12 = w[1] & y[2];
    assign wz12 = w[1] & z[2];
    assign yw12 = y[1] & w[2];
    assign yy12 = y[1] & y[2];
    assign yz12 = y[1] & z[2];
    assign zw12 = z[1] & w[2];
    assign zy12 = z[1] & y[2];
    assign zz12 = z[1] & z[2];
    
    assign x12 = yw12 ^ yy12 ^ yz12 ^ zy12;
    
    assign ww13 = w[1] & w[3];
    assign wy13 = w[1] & y[3];
    assign wz13 = w[1] & z[3];
    assign yw13 = y[1] & w[3];
    assign yy13 = y[1] & y[3];
    assign yz13 = y[1] & z[3];
    assign zw13 = z[1] & w[3];
    assign zy13 = z[1] & y[3];
    assign zz13 = z[1] & z[3];

    assign x13 = yw13 ^ yy13 ^ yz13 ^ zy13;
    
    assign ww23 = w[2] & w[3];
    assign wy23 = w[2] & y[3];
    assign wz23 = w[2] & z[3];
    assign yw23 = y[2] & w[3];
    assign yy23 = y[2] & y[3];
    assign yz23 = y[2] & z[3];
    assign zw23 = z[2] & w[3];
    assign zy23 = z[2] & y[3];
    assign zz23 = z[2] & z[3];
    
    assign x23 = yw23 ^ yy23 ^ yz23 ^ zy23;

    assign www012 = ww01 & w[2];
    assign wwy012 = ww01 & y[2];
    assign wwz012 = ww01 & z[2];
    assign wyw012 = wy01 & w[2];
    assign wyy012 = wy01 & y[2];
    assign wyz012 = wy01 & z[2];
    assign wzw012 = wz01 & w[2];
    assign wzy012 = wz01 & y[2];
    assign wzz012 = wz01 & z[2];
    assign yww012 = yw01 & w[2];
    assign ywy012 = yw01 & y[2];
    assign ywz012 = yw01 & z[2];
    assign yyw012 = yy01 & w[2];
    assign yyy012 = yy01 & y[2];
    assign yyz012 = yy01 & z[2];
    assign yzw012 = yz01 & w[2];
    assign yzy012 = yz01 & y[2];
    assign yzz012 = yz01 & z[2];
    assign zww012 = zw01 & w[2];
    assign zwy012 = zw01 & y[2];
    assign zwz012 = zw01 & z[2];
    assign zyw012 = zy01 & w[2];
    assign zyy012 = zy01 & y[2];
    assign zyz012 = zy01 & z[2];
    assign zzw012 = zz01 & w[2];
    assign zzy012 = zz01 & y[2];
    assign zzz012 = zz01 & z[2];

    assign x012 = wyz012 ^ wzy012 ^ yww012 ^ ywy012 ^ ywz012 ^ yyw012 ^ yyy012 ^ yyz012 ^ yzw012 ^ yzy012 ^ yzz012 ^ zwy012 ^ zyw012 ^ zyy012 ^ zyz012 ^ zzy012;
    
    assign www013 = ww01 & w[3];
    assign wwy013 = ww01 & y[3];
    assign wwz013 = ww01 & z[3];
    assign wyw013 = wy01 & w[3];
    assign wyy013 = wy01 & y[3];
    assign wyz013 = wy01 & z[3];
    assign wzw013 = wz01 & w[3];
    assign wzy013 = wz01 & y[3];
    assign wzz013 = wz01 & z[3];
    assign yww013 = yw01 & w[3];
    assign ywy013 = yw01 & y[3];
    assign ywz013 = yw01 & z[3];
    assign yyw013 = yy01 & w[3];
    assign yyy013 = yy01 & y[3];
    assign yyz013 = yy01 & z[3];
    assign yzw013 = yz01 & w[3];
    assign yzy013 = yz01 & y[3];
    assign yzz013 = yz01 & z[3];
    assign zww013 = zw01 & w[3];
    assign zwy013 = zw01 & y[3];
    assign zwz013 = zw01 & z[3];
    assign zyw013 = zy01 & w[3];
    assign zyy013 = zy01 & y[3];
    assign zyz013 = zy01 & z[3];
    assign zzw013 = zz01 & w[3];
    assign zzy013 = zz01 & y[3];
    assign zzz013 = zz01 & z[3];

    assign x013 = wyz013 ^ wzy013 ^ yww013 ^ ywy013 ^ ywz013 ^ yyw013 ^ yyy013 ^ yyz013 ^ yzw013 ^ yzy013 ^ yzz013 ^ zwy013 ^ zyw013 ^ zyy013 ^ zyz013 ^ zzy013;
    
    assign www023 = ww02 & w[3];
    assign wwy023 = ww02 & y[3];
    assign wwz023 = ww02 & z[3];
    assign wyw023 = wy02 & w[3];
    assign wyy023 = wy02 & y[3];
    assign wyz023 = wy02 & z[3];
    assign wzw023 = wz02 & w[3];
    assign wzy023 = wz02 & y[3];
    assign wzz023 = wz02 & z[3];
    assign yww023 = yw02 & w[3];
    assign ywy023 = yw02 & y[3];
    assign ywz023 = yw02 & z[3];
    assign yyw023 = yy02 & w[3];
    assign yyy023 = yy02 & y[3];
    assign yyz023 = yy02 & z[3];
    assign yzw023 = yz02 & w[3];
    assign yzy023 = yz02 & y[3];
    assign yzz023 = yz02 & z[3];
    assign zww023 = zw02 & w[3];
    assign zwy023 = zw02 & y[3];
    assign zwz023 = zw02 & z[3];
    assign zyw023 = zy02 & w[3];
    assign zyy023 = zy02 & y[3];
    assign zyz023 = zy02 & z[3];
    assign zzw023 = zz02 & w[3];
    assign zzy023 = zz02 & y[3];
    assign zzz023 = zz02 & z[3];

    assign x023 = wyz023 ^ wzy023 ^ yww023 ^ ywy023 ^ ywz023 ^ yyw023 ^ yyy023 ^ yyz023 ^ yzw023 ^ yzy023 ^ yzz023 ^ zwy023 ^ zyw023 ^ zyy023 ^ zyz023 ^ zzy023;
    
    assign www123 = ww12 & w[3];
    assign wwy123 = ww12 & y[3];
    assign wwz123 = ww12 & z[3];
    assign wyw123 = wy12 & w[3];
    assign wyy123 = wy12 & y[3];
    assign wyz123 = wy12 & z[3];
    assign wzw123 = wz12 & w[3];
    assign wzy123 = wz12 & y[3];
    assign wzz123 = wz12 & z[3];
    assign yww123 = yw12 & w[3];
    assign ywy123 = yw12 & y[3];
    assign ywz123 = yw12 & z[3];
    assign yyw123 = yy12 & w[3];
    assign yyy123 = yy12 & y[3];
    assign yyz123 = yy12 & z[3];
    assign yzw123 = yz12 & w[3];
    assign yzy123 = yz12 & y[3];
    assign yzz123 = yz12 & z[3];
    assign zww123 = zw12 & w[3];
    assign zwy123 = zw12 & y[3];
    assign zwz123 = zw12 & z[3];
    assign zyw123 = zy12 & w[3];
    assign zyy123 = zy12 & y[3];
    assign zyz123 = zy12 & z[3];
    assign zzw123 = zz12 & w[3];
    assign zzy123 = zz12 & y[3];
    assign zzz123 = zz12 & z[3];
    
    assign x123 = wyz123 ^ wzy123 ^ yww123 ^ ywy123 ^ ywz123 ^ yyw123 ^ yyy123 ^ yyz123 ^ yzw123 ^ yzy123 ^ yzz123 ^ zwy123 ^ zyw123 ^ zyy123 ^ zyz123 ^ zzy123;
    
    assign z_x_tmp[0] = x2 ^ x3 ^ x01 ^ x03 ^ x12 ^ x23 ^ x012;
    assign z_x_tmp[1] = x02 ^ x12 ^ x13 ^ x012 ^ x123;
    assign z_x_tmp[2] = x0 ^ x3 ^ x01 ^ x03 ^ x13 ^ x013 ^ x123;
    assign z_x_tmp[3] = x1 ^ x3 ^ x12 ^ x23 ^ x012 ^ x013 ^ x023;  
    
     // Remasking according to changing of the guards
     assign z_x = z_x_tmp ^ d;
endmodule
