module dom_and(clk, x0, x1, y0, y1, r, z0, z1);
    input clk;
    input x0;
    input y0;
    input x1;
    input y1;
    input r;
    output z0;
    output z1;
    
    (* share_domain = 0 *) reg r0;
    (* share_domain = 1 *) reg r1;
    (* share_domain = 2 *) reg r2;
    (* share_domain = 3 *) reg r3;

    (* share_domain = 0 *) wire t0;
    (* share_domain = 1 *) wire t1;
    (* share_domain = 2 *) wire t2;
    (* share_domain = 3 *) wire t3;
    
    assign t0 = x0 & y0;
    assign t1 = x0 & y1 ^ r;
    assign t2 = x1 & y0 ^ r;
    assign t3 = x1 & y1;

    assign z0 = r0 ^ r1;
    assign z1 = r2 ^ r3;
   
    always @ (posedge clk)
    begin
        r0 <= t0;
        r1 <= t1;
        r2 <= t2;
        r3 <= t3;
    end 
endmodule

module top(clk, a0, a1, b0, b1, x0, x1, y0, y1, r0, r1, z0, z1);
    input clk;
    input a0, x0;
    input b0, y0;
    input a1, x1;
    input b1, y1;
    input r0, r1;
    output z0, z1;
    
    wire c0, c1, d0, d1;

    dom_and inst0(.clk(clk), .x0(a0), .x1(a1), .y0(b0), .y1(b1), .r(r0), .z0(c0), .z1(c1));   
    dom_and inst1(.clk(clk), .x0(x0), .x1(x1), .y0(y0), .y1(y1), .r(r1), .z0(d0), .z1(d1));    
 
    assign z0 = c0 ^ d0;
    assign z1 = c1 ^ d1;
endmodule
