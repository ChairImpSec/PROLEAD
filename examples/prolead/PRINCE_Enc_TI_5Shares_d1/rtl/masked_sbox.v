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

module masked_sbox(
    input [3:0] v,
    input [3:0] w,
    input [3:0] x,
    input [3:0] y,
    input [3:0] z,
    output [3:0] z_v,
    output [3:0] z_w,
    output [3:0] z_x,
    output [3:0] z_y,
    output [3:0] z_z
    );
 
    component_function_v com_v_inst(.w(w), .x(x), .y(y), .z(z), .z_v(z_v));
    component_function_w com_w_inst(.v(v), .x(x), .y(y), .z(z), .z_w(z_w));
    component_function_x com_x_inst(.v(v), .w(w), .y(y), .z(z), .z_x(z_x));
    component_function_y com_y_inst(.v(v), .w(w), .x(x), .z(z), .z_y(z_y));
    component_function_z com_z_inst(.v(v), .w(w), .x(x), .y(y), .z_z(z_z));

endmodule    
