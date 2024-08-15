module one_domain_d1 (clk, port_a, port_b, port_c, port_r);
    input clk;
    input port_a;
    input [1:0] port_b;
    input port_r;
    output port_c;

    wire i0, i1, j0, l0;

    AND2_X1 U0 ( .A1(port_a), .A2(port_b[0]), .ZN(i0) );
    AND2_X1 U1 ( .A1(port_a), .A2(port_b[1]), .ZN(i1) );
    XOR2_X1 U2 ( .A(i1), .B(port_r), .Z(j0) );
    DFF_X1  U3 ( .D(j0), .CK(clk), .Q(l0), .QN() );    
    XOR2_X1 U4 ( .A(i0), .B(l0), .Z(port_c) );
endmodule

module dom_indep_d1_non_flatten (clk, port_a, port_b, port_c, port_r);
    input clk;
    input [1:0] port_a;
    input [1:0] port_b;
    input [0:0] port_r;
    output [1:0] port_c;

    one_domain_d1 dom_inst0(.clk(clk), .port_a(port_a[0]), .port_b(port_b[1:0]), .port_r(port_r[0]), .port_c(port_c[0])); 
    one_domain_d1 dom_inst1(.clk(clk), .port_a(port_a[1]), .port_b(port_b[0:1]), .port_r(port_r[0]), .port_c(port_c[1])); 
endmodule