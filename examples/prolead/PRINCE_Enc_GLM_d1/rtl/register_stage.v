`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.06.2020 12:31:33
// Design Name: 
// Module Name: register_stage
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


module register_stage(
    input clk,
    input rst,
    input en,
    input D,
    output Q
    );
    
    reg s_current_state;
    wire s_next_state;
    
    assign s_next_state = D;
    
    always @ (posedge clk)
    begin
        if (rst == 1'b1) begin
            s_current_state <= 1'b0;
        end
        else if (en == 1'b1) begin
            s_current_state <= s_next_state;
        end
    end
    
    assign Q = s_current_state;
endmodule
