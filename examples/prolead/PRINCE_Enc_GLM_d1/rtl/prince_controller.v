`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.06.2020 14:54:11
// Design Name: 
// Module Name: prince_controller
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

module prince_controller(
    input clk,
    input rst,
    input en,
    input enc,
    input [63:0] k,
    output [63:0] rc,
    output [63:0] rc2,
    output target_en,
    output target_start,
    output target_inv,
    output target_inv2,
    output target_done
    );
    
    localparam ROUNDSTOP = 4'd14;

    wire [3:0] ctr, rc_ctr, rc_ctr2;
    reg [3:0] counter;
    reg [63:0] constant, constant2;
    
    always @ (posedge clk)
    begin
        if (rst == 1) begin
            counter <= 1;
        end
        else if (counter < ROUNDSTOP) begin
            counter <= counter + 1;
        end
    end
    
    assign rc_ctr = (enc == 1'b1) ? counter : ~counter;
    assign rc_ctr2 = rc_ctr - 1;
    assign ctr = counter;
    
    always @ (rc_ctr)
    begin
        case(rc_ctr)
            4'b0010: constant = 64'h0000000000000000;
            4'b0011: constant = 64'h13198a2e03707344;
            4'b0100: constant = 64'ha4093822299f31d0;
            4'b0101: constant = 64'h082efa98ec4e6c89;
            4'b0110: constant = 64'h452821e638d01377;
            4'b0111: constant = 64'hbe5466cf34e90c6c; 
            4'b1000: constant = 64'h7ef84f78fd955cb1;
            4'b1001: constant = 64'h85840851f1ac43aa;
            4'b1010: constant = 64'hc882d32f25323c54;
            4'b1011: constant = 64'h64a51195e0e3610d;
            4'b1100: constant = 64'hd3b5a399ca0c2399;
            4'b1101: constant = 64'hc0ac29b7c97c50dd;
            default: constant = 0;
        endcase
    end
    
    always @ (rc_ctr2)
    begin
        case(rc_ctr2)
            4'b0010: constant2 = 64'h0000000000000000;
            4'b0011: constant2 = 64'h13198a2e03707344;
            4'b0100: constant2 = 64'ha4093822299f31d0;
            4'b0101: constant2 = 64'h082efa98ec4e6c89;
            4'b0110: constant2 = 64'h452821e638d01377;
            4'b0111: constant2 = 64'hbe5466cf34e90c6c; 
            4'b1000: constant2 = 64'h7ef84f78fd955cb1;
            4'b1001: constant2 = 64'h85840851f1ac43aa;
            4'b1010: constant2 = 64'hc882d32f25323c54;
            4'b1011: constant2 = 64'h64a51195e0e3610d;
            4'b1100: constant2 = 64'hd3b5a399ca0c2399;
            4'b1101: constant2 = 64'hc0ac29b7c97c50dd;
            default: constant2 = 0;
        endcase
    end
    
    // assign current round constant
    assign rc = constant ^ k;
    assign rc2 = constant2 ^ k;
    
    assign target_done = (ctr == ROUNDSTOP/* && rst == 1'b0*/) ? 1 : 0;
    assign target_en = ~target_done;
    assign target_start = (ctr == 2'b10 && en == 1) ? 1 : 0;
    assign target_inv = (ctr < 4'b1000) ? 1 : 0;
    assign target_inv2 = (ctr < 4'b1001) ? 1 : 0;
endmodule
