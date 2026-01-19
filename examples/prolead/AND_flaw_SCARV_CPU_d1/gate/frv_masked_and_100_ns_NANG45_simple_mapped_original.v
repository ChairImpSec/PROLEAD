/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : M-2016.12
// Date      : Tue Mar 19 13:31:58 2024
/////////////////////////////////////////////////////////////


module frv_masked_and ( g_clk, clk_en, z0, z1, ax, ay, bx, by, qx, qy );
  input [0:0] z0;
  input [0:0] z1;
  input [0:0] ax;
  input [0:0] ay;
  input [0:0] bx;
  input [0:0] by;
  output [0:0] qx;
  output [0:0] qy;
  input g_clk, clk_en;
  wire   t1_0_, t3_0_, n12, n13, n23, n24, n25, n26, n27, n28, n29, n30, n31;

  DFF_X1 t3_reg_0_ ( .D(n12), .CK(g_clk), .Q(t3_0_), .QN() );
  DFF_X1 t1_reg_0_ ( .D(n13), .CK(g_clk), .Q(t1_0_), .QN() );
  XOR2_X1 U30 ( .A(by[0]), .B(z0[0]), .Z(n29) );
  NAND2_X1 U31 ( .A1(n29), .A2(t3_0_), .ZN(n23) );
  OAI211_X1 U32 ( .C1(n29), .C2(t3_0_), .A(bx[0]), .B(n23), .ZN(n24) );
  XNOR2_X1 U33 ( .A(z1[0]), .B(n24), .ZN(qy[0]) );
  XOR2_X1 U34 ( .A(z0[0]), .B(ay[0]), .Z(n27) );
  NAND2_X1 U35 ( .A1(t1_0_), .A2(n27), .ZN(n25) );
  OAI211_X1 U36 ( .C1(t1_0_), .C2(n27), .A(ax[0]), .B(n25), .ZN(n26) );
  XNOR2_X1 U37 ( .A(z1[0]), .B(n26), .ZN(qx[0]) );
  INV_X1 U38 ( .A(clk_en), .ZN(n30) );
  OAI22_X1 U39 ( .A1(n30), .A2(n27), .B1(t3_0_), .B2(clk_en), .ZN(n28) );
  INV_X1 U40 ( .A(n28), .ZN(n12) );
  OAI22_X1 U41 ( .A1(n30), .A2(n29), .B1(t1_0_), .B2(clk_en), .ZN(n31) );
  INV_X1 U42 ( .A(n31), .ZN(n13) );
endmodule

