module dom_indep_d1_fault_as_probe (clk, port_a, port_b, port_c, port_r, port_f);
    input clk;
    input [1:0] port_a;
    input [1:0] port_b;
    input [0:0] port_r;
    output [1:0] port_c;
    output port_f;

    wire i0, i1, i2, i3, j0, j1, l0, l1, port_c1;     

    AND2_X1 U0 ( .A1(port_a[0]), .A2(port_b[0]), .ZN(i0) );
    AND2_X1 U1 ( .A1(port_a[0]), .A2(port_b[1]), .ZN(i1) );
    AND2_X1 U2 ( .A1(port_a[1]), .A2(port_b[0]), .ZN(i2) );
    AND2_X1 U3 ( .A1(port_a[1]), .A2(port_b[1]), .ZN(i3) );

    XOR2_X1 U4 ( .A(i1), .B(port_r), .Z(j0) );
    XOR2_X1 U5 ( .A(i2), .B(port_r), .Z(j1) );

    DFF_X1 U6 ( .D(j0), .CK(clk), .Q(l0), .QN() );    
    DFF_X1 U7 ( .D(j1), .CK(clk), .Q(l1), .QN() );    

    XOR2_X1 U8 ( .A(i0), .B(l0), .Z(port_c[0]) );
    XOR2_X1 U9 ( .A(i3), .B(l1), .Z(port_c[1]) );
    XOR2_X1 U10 ( .A(i3), .B(l1), .Z(port_c1) );
    XOR2_X1 U11 ( .A(port_c1), .B(port_c[1]), .Z(port_f) );
endmodule