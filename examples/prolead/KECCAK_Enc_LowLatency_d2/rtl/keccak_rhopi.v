
//// taken from https://github.com/hgrosz/keccak_dom


module keccak_rhopi #(
    parameter W = 8
)(
    input wire[25*W-1:0] In,
    output reg[25*W-1:0] Out
);

function integer Idx(input integer x, input integer y);
    Idx = (5*x+y)*W;
endfunction

localparam [0:25*4-1] ROTATION_OFFSETS = {
    4'd0, 4'd4, 4'd3, 4'd1, 4'd2,
    4'd1, 4'd4, 4'd2, 4'd5, 4'd2,
    4'd6, 4'd6, 4'd3, 4'd7, 4'd5,
    4'd4, 4'd7, 4'd1, 4'd5, 4'd0,
    4'd3, 4'd4, 4'd7, 4'd0, 4'd6
};

reg[25*W-1:0] RHO;
always @(*) begin : RHO_PI_COMB
    reg[25*W-1:0] A;
    reg[25*W-1:0] B;
    integer x, y;

    A = In;
    for(x=0; x < 5; x=x+1) begin
        for(y=0; y < 5; y=y+1) begin
            RHO[Idx(x,y) +: W] = {2{A[Idx(x,y) +: W]}} >> (W - (ROTATION_OFFSETS[(5*x+y)*4 +: 4] % W));
            B[Idx(y,(2*x+3*y)%5) +: W] = RHO[Idx(x,y) +: W];
        end
    end
    Out = B;
end

endmodule