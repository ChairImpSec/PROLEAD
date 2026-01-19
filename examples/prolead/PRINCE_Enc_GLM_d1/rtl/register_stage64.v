`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.07.2020 12:53:59
// Design Name: 
// Module Name: register_stage64
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module register_stage64(
    input clk,
    input rst,
    input en,
    input [63:0] D,
    output [63:0] Q
    );
    
    reg [63:0] s_current_state;
    wire [63:0] s_next_state;
    
    assign s_next_state = D;
    
    always @ (posedge clk)
    begin
        if (rst == 1'b1) begin
            s_current_state <= 64'h0000000000000000;
        end
        else if (en == 1'b1) begin
            s_current_state <= s_next_state;
        end
    end
    
    assign Q = s_current_state;
endmodule

