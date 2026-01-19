module circuit ( g_clk, clk_en, z0, z1, ax, ay, bx, by, qx, qy );
  input [0:0] z0;
  input [0:0] z1;
  input [0:0] ax;
  input [0:0] ay;
  input [0:0] bx;
  input [0:0] by;
  output [0:0] qx;
  output [0:0] qy;
  input g_clk, clk_en;
  wire   t1_0_, t3_0_, n14, n15, n27, n28, n29, n30, n31, n32, n33, n34, n35,
         n36, n37;

  DFF_X1 t1_reg_0_ ( .D(n15), .CK(g_clk), .Q(t1_0_), .QN() );
  DFF_X1 t3_reg_0_ ( .D(n14), .CK(g_clk), .Q(t3_0_), .QN() );
  XOR2_X1 U34 ( .A(by[0]), .B(z0[0]), .Z(n34) );
  XOR2_X1 U35 ( .A(n34), .B(t3_0_), .Z(n27) );
  NAND2_X1 U36 ( .A1(n27), .A2(bx[0]), .ZN(n28) );
  XNOR2_X1 U37 ( .A(n28), .B(z1[0]), .ZN(qy[0]) );
  XOR2_X1 U38 ( .A(z0[0]), .B(ay[0]), .Z(n31) );
  XOR2_X1 U39 ( .A(t1_0_), .B(n31), .Z(n29) );
  NAND2_X1 U40 ( .A1(n29), .A2(ax[0]), .ZN(n30) );
  XNOR2_X1 U41 ( .A(z1[0]), .B(n30), .ZN(qx[0]) );
  NAND2_X1 U42 ( .A1(n31), .A2(clk_en), .ZN(n33) );
  INV_X1 U43 ( .A(clk_en), .ZN(n35) );
  NAND2_X1 U44 ( .A1(t3_0_), .A2(n35), .ZN(n32) );
  NAND2_X1 U45 ( .A1(n33), .A2(n32), .ZN(n14) );
  NAND2_X1 U46 ( .A1(n34), .A2(clk_en), .ZN(n37) );
  NAND2_X1 U47 ( .A1(t1_0_), .A2(n35), .ZN(n36) );
  NAND2_X1 U48 ( .A1(n37), .A2(n36), .ZN(n15) );
endmodule

