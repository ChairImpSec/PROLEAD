module dom_indep_d2 (clk, port_a, port_b, port_c, port_r);
    input clk;
    input [2:0] port_a;
    input [2:0] port_b;
    input [2:0] port_r;
    output [2:0] port_c;

    wire i0, i1, i2, i3, i4, i5, i6, i7, i8;
    wire j0, j1, j2, j3, j4, j5;
    wire l0, l1, l2, l3, l4, l5;
    wire p0, p1, p2; 

    AND2_X1 U0 ( .A1(port_a[0]), .A2(port_b[0]), .ZN(i0) );
    AND2_X1 U1 ( .A1(port_a[0]), .A2(port_b[1]), .ZN(i1) );
    AND2_X1 U2 ( .A1(port_a[0]), .A2(port_b[2]), .ZN(i2) );
    AND2_X1 U3 ( .A1(port_a[1]), .A2(port_b[0]), .ZN(i3) );
    AND2_X1 U4 ( .A1(port_a[1]), .A2(port_b[1]), .ZN(i4) );
    AND2_X1 U5 ( .A1(port_a[1]), .A2(port_b[2]), .ZN(i5) );
    AND2_X1 U6 ( .A1(port_a[2]), .A2(port_b[0]), .ZN(i6) );
    AND2_X1 U7 ( .A1(port_a[2]), .A2(port_b[1]), .ZN(i7) );
    AND2_X1 U8 ( .A1(port_a[2]), .A2(port_b[2]), .ZN(i8) );

    XOR2_X1 U9  ( .A(i1), .B(port_r[0]), .Z(j0) );
    XOR2_X1 U10 ( .A(i2), .B(port_r[1]), .Z(j1) );
    XOR2_X1 U11 ( .A(i3), .B(port_r[0]), .Z(j2) );
    XOR2_X1 U12 ( .A(i5), .B(port_r[2]), .Z(j3) );
    XOR2_X1 U13 ( .A(i6), .B(port_r[1]), .Z(j4) );
    XOR2_X1 U14 ( .A(i7), .B(port_r[2]), .Z(j5) );

    DFF_X1 U15 ( .D(j0), .CK(clk), .Q(l0), .QN() );    
    DFF_X1 U16 ( .D(j1), .CK(clk), .Q(l1), .QN() );    
    DFF_X1 U17 ( .D(j2), .CK(clk), .Q(l2), .QN() );    
    DFF_X1 U18 ( .D(j3), .CK(clk), .Q(l3), .QN() );  
    DFF_X1 U19 ( .D(j4), .CK(clk), .Q(l4), .QN() );    
    DFF_X1 U20 ( .D(j5), .CK(clk), .Q(l5), .QN() );  

    XOR2_X1 U21 ( .A(l0), .B(l1), .Z(p0) );
    XOR2_X1 U22 ( .A(l2), .B(l3), .Z(p1) );
    XOR2_X1 U23 ( .A(l4), .B(l5), .Z(p2) );

    XOR2_X1 U24 ( .A(i0), .B(p0), .Z(port_c[0]) );
    XOR2_X1 U25 ( .A(i4), .B(p1), .Z(port_c[1]) );
    XOR2_X1 U26 ( .A(i8), .B(p2), .Z(port_c[2]) );
endmodule