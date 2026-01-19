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
    input [3:0] w,
    input [3:0] x,
    input [3:0] y,
    input [3:0] z,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d, 
    output [3:0] z_w,
    output [3:0] z_x,
    output [3:0] z_y,
    output [3:0] z_z
    );
    
    wire [3:0] z_w_tmp, z_x_tmp, z_y_tmp, z_z_tmp; 
    
    component_function_w com_w_inst(.x(x), .y(y), .z(z), .c(c), .d(d), .z_w(z_w));
    component_function_x com_x_inst(.w(w), .y(y), .z(z), .d(d), .z_x(z_x));
    component_function_y com_y_inst(.w(w), .x(x), .z(z), .b(b), .z_y(z_y));
    component_function_z com_z_inst(.w(w), .x(x), .y(y), .b(b), .c(c), .z_z(z_z));
endmodule    

