
//// taken from https://github.com/hgrosz/keccak_dom


module keccak_roundconstant #(
    parameter W = 8
   ) 
   
   (input wire[4:0] RoundNrxDI,
    output reg[W-1:0] RCxDO
    );

    wire[0:18*8-1] RC = {
		8'h01, 8'h82, 8'h8A, 8'h00, 8'h8B, 8'h01,
        8'h81, 8'h09, 8'h8A, 8'h88, 8'h09, 8'h0A,
		8'h8B, 8'h8B, 8'h89, 8'h03, 8'h02, 8'h80
    };

    always @(*) begin : SELECT_ROUND_CONSTANT
    
        RCxDO = RC[RoundNrxDI*8 +: 8];
		
    end


endmodule