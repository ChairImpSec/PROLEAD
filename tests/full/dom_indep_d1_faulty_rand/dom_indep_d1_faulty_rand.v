module dom_indep_d1_faulty_rand (clk, port_a, port_b, port_c, port_r);
    input clk;
    input [1:0] port_a;
    input [1:0] port_b;
    input [0:0] port_r;
    output [1:0] port_c;

    wire i0, i1, i2, i3, j0, j1, l0, l1, inv_r, r; 

	INV_X1 U0 ( .A(port_r), .ZN(inv_r) );
	INV_X1 U1 ( .A(inv_r), .ZN(r) );

    AND2_X1 U2 ( .A1(port_a[0]), .A2(port_b[0]), .ZN(i0) );
    AND2_X1 U3 ( .A1(port_a[0]), .A2(port_b[1]), .ZN(i1) );
    AND2_X1 U4 ( .A1(port_a[1]), .A2(port_b[0]), .ZN(i2) );
    AND2_X1 U5 ( .A1(port_a[1]), .A2(port_b[1]), .ZN(i3) );

    XOR2_X1 U6 ( .A(i1), .B(r), .Z(j0) );
    XOR2_X1 U7 ( .A(i2), .B(r), .Z(j1) );

    DFF_X1 U8 ( .D(j0), .CK(clk), .Q(l0), .QN() );    
    DFF_X1 U9 ( .D(j1), .CK(clk), .Q(l1), .QN() );    

    XOR2_X1 U10 ( .A(i0), .B(l0), .Z(port_c[0]) );
    XOR2_X1 U11 ( .A(i3), .B(l1), .Z(port_c[1]) );
endmodule