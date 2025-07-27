module circuit ( port_a_0, port_a_1, port_b_0, port_b_1, port_c_0, port_c_1,
        port_r, clk, reset );
  input [2:0] port_a_0;
  input [2:0] port_a_1;
  input [2:0] port_b_0;
  input [2:0] port_b_1;
  output [2:0] port_c_0;
  output [2:0] port_c_1;
  input [1:0] port_r;
  input clk, reset;
  wire   mul_n12, mul_n11, mul_n10, mul_n9, mul_n8, mul_n7, mul_n6, mul_n5,
         mul_n4, mul_n3, mul_n2, mul_n1, mul_N13, mul_N12, mul_N11, mul_N10,
         mul_N9, mul_N8, cor_maj_23_port_o, cor_maj_22_port_o,
         cor_maj_21_port_o, cor_maj_20_port_o, cor_maj_19_port_o,
         cor_maj_18_port_o, cor_maj_17_port_o, cor_maj_16_port_o,
         cor_maj_15_port_o, cor_maj_14_port_o, cor_maj_13_port_o,
         cor_maj_12_port_o, cor_maj_12_n3, cor_maj_12_n2, cor_maj_12_n1,
         cor_maj_13_n6, cor_maj_13_n5, cor_maj_13_n4, cor_maj_14_n6,
         cor_maj_14_n5, cor_maj_14_n4, cor_maj_15_n6, cor_maj_15_n5,
         cor_maj_15_n4, cor_maj_16_n6, cor_maj_16_n5, cor_maj_16_n4,
         cor_maj_17_n6, cor_maj_17_n5, cor_maj_17_n4, cor_maj_18_n6,
         cor_maj_18_n5, cor_maj_18_n4, cor_maj_19_n6, cor_maj_19_n5,
         cor_maj_19_n4, cor_maj_20_n6, cor_maj_20_n5, cor_maj_20_n4,
         cor_maj_21_n6, cor_maj_21_n5, cor_maj_21_n4, cor_maj_22_n6,
         cor_maj_22_n5, cor_maj_22_n4, cor_maj_23_n6, cor_maj_23_n5,
         cor_maj_23_n4;
  wire   [2:0] mul_port_c_0_0;
  wire   [2:0] mul_port_c_0_1;
  wire   [2:0] mul_port_c_1_0;
  wire   [2:0] mul_port_c_1_1;
  wire   [2:0] cor_port_v_0_0;
  wire   [2:0] cor_port_v_0_1;
  wire   [2:0] cor_port_v_1_0;
  wire   [2:0] cor_port_v_1_1;
  wire   [2:0] comp_port_c_0;
  wire   [2:0] comp_port_c_1;
  wire   [2:0] mul_xor2_7_port_z;
  wire   [2:0] mul_xor2_6_port_z;
  wire   [2:0] mul_xor2_6_port_a0;
  wire   [2:0] mul_xor2_5_port_z;
  wire   [2:0] mul_xor2_4_port_z;
  wire   [2:0] mul_xor2_4_port_a0;

  DFF_X1 result_0_reg_2_ ( .D(comp_port_c_0[2]), .CK(clk), .Q(port_c_0[2]),
        .QN() );
  DFF_X1 result_0_reg_1_ ( .D(comp_port_c_0[1]), .CK(clk), .Q(port_c_0[1]),
        .QN() );
  DFF_X1 result_0_reg_0_ ( .D(comp_port_c_0[0]), .CK(clk), .Q(port_c_0[0]),
        .QN() );
  DFF_X1 result_1_reg_2_ ( .D(comp_port_c_1[2]), .CK(clk), .Q(port_c_1[2]),
        .QN() );
  DFF_X1 result_1_reg_1_ ( .D(comp_port_c_1[1]), .CK(clk), .Q(port_c_1[1]),
        .QN() );
  DFF_X1 result_1_reg_0_ ( .D(comp_port_c_1[0]), .CK(clk), .Q(port_c_1[0]),
        .QN() );
  INV_X1 mul_U26 ( .A(port_a_1[2]), .ZN(mul_n4) );
  INV_X1 mul_U25 ( .A(port_a_1[1]), .ZN(mul_n5) );
  INV_X1 mul_U24 ( .A(port_a_1[0]), .ZN(mul_n6) );
  INV_X1 mul_U23 ( .A(port_a_0[2]), .ZN(mul_n1) );
  INV_X1 mul_U22 ( .A(port_a_0[1]), .ZN(mul_n2) );
  INV_X1 mul_U21 ( .A(port_a_0[0]), .ZN(mul_n3) );
  INV_X1 mul_U20 ( .A(port_b_0[2]), .ZN(mul_n7) );
  INV_X1 mul_U19 ( .A(port_b_0[1]), .ZN(mul_n8) );
  INV_X1 mul_U18 ( .A(port_b_0[0]), .ZN(mul_n9) );
  INV_X1 mul_U17 ( .A(port_b_1[2]), .ZN(mul_n10) );
  INV_X1 mul_U16 ( .A(port_b_1[1]), .ZN(mul_n11) );
  INV_X1 mul_U15 ( .A(port_b_1[0]), .ZN(mul_n12) );
  NOR2_X1 mul_U14 ( .A1(mul_n1), .A2(mul_n10), .ZN(mul_xor2_4_port_a0[2]) );
  NOR2_X1 mul_U13 ( .A1(mul_n2), .A2(mul_n11), .ZN(mul_xor2_4_port_a0[1]) );
  NOR2_X1 mul_U12 ( .A1(mul_n3), .A2(mul_n12), .ZN(mul_xor2_4_port_a0[0]) );
  NOR2_X1 mul_U11 ( .A1(mul_n4), .A2(mul_n7), .ZN(mul_xor2_6_port_a0[2]) );
  NOR2_X1 mul_U10 ( .A1(mul_n5), .A2(mul_n8), .ZN(mul_xor2_6_port_a0[1]) );
  NOR2_X1 mul_U9 ( .A1(mul_n6), .A2(mul_n9), .ZN(mul_xor2_6_port_a0[0]) );
  NOR2_X1 mul_U8 ( .A1(mul_n7), .A2(mul_n1), .ZN(mul_N8) );
  NOR2_X1 mul_U7 ( .A1(mul_n8), .A2(mul_n2), .ZN(mul_N9) );
  NOR2_X1 mul_U6 ( .A1(mul_n9), .A2(mul_n3), .ZN(mul_N10) );
  NOR2_X1 mul_U5 ( .A1(mul_n4), .A2(mul_n10), .ZN(mul_N11) );
  NOR2_X1 mul_U4 ( .A1(mul_n5), .A2(mul_n11), .ZN(mul_N12) );
  NOR2_X1 mul_U3 ( .A1(mul_n6), .A2(mul_n12), .ZN(mul_N13) );
  DFF_X1 mul_u_1_1_reg_0_ ( .D(mul_N13), .CK(clk), .Q(mul_port_c_1_1[0]),
        .QN() );
  DFF_X1 mul_u_1_1_reg_1_ ( .D(mul_N12), .CK(clk), .Q(mul_port_c_1_1[1]),
        .QN() );
  DFF_X1 mul_u_1_1_reg_2_ ( .D(mul_N11), .CK(clk), .Q(mul_port_c_1_1[2]),
        .QN() );
  DFF_X1 mul_u_1_0_reg_0_ ( .D(mul_xor2_7_port_z[0]), .CK(clk), .Q(
        mul_port_c_1_0[0]), .QN() );
  DFF_X1 mul_u_1_0_reg_1_ ( .D(mul_xor2_7_port_z[1]), .CK(clk), .Q(
        mul_port_c_1_0[1]), .QN() );
  DFF_X1 mul_u_1_0_reg_2_ ( .D(mul_xor2_7_port_z[2]), .CK(clk), .Q(
        mul_port_c_1_0[2]), .QN() );
  DFF_X1 mul_u_0_1_reg_0_ ( .D(mul_xor2_5_port_z[0]), .CK(clk), .Q(
        mul_port_c_0_1[0]), .QN() );
  DFF_X1 mul_u_0_1_reg_1_ ( .D(mul_xor2_5_port_z[1]), .CK(clk), .Q(
        mul_port_c_0_1[1]), .QN() );
  DFF_X1 mul_u_0_1_reg_2_ ( .D(mul_xor2_5_port_z[2]), .CK(clk), .Q(
        mul_port_c_0_1[2]), .QN() );
  DFF_X1 mul_u_0_0_reg_0_ ( .D(mul_N10), .CK(clk), .Q(mul_port_c_0_0[0]),
        .QN() );
  DFF_X1 mul_u_0_0_reg_1_ ( .D(mul_N9), .CK(clk), .Q(mul_port_c_0_0[1]), .QN()
         );
  DFF_X1 mul_u_0_0_reg_2_ ( .D(mul_N8), .CK(clk), .Q(mul_port_c_0_0[2]), .QN()
         );
  XOR2_X1 mul_xor2_4_U3 ( .A(port_r[0]), .B(mul_xor2_4_port_a0[2]), .Z(
        mul_xor2_4_port_z[2]) );
  XOR2_X1 mul_xor2_4_U2 ( .A(port_r[0]), .B(mul_xor2_4_port_a0[1]), .Z(
        mul_xor2_4_port_z[1]) );
  XOR2_X1 mul_xor2_4_U1 ( .A(port_r[0]), .B(mul_xor2_4_port_a0[0]), .Z(
        mul_xor2_4_port_z[0]) );
  XOR2_X1 mul_xor2_5_U3 ( .A(port_r[1]), .B(mul_xor2_4_port_z[2]), .Z(
        mul_xor2_5_port_z[2]) );
  XOR2_X1 mul_xor2_5_U2 ( .A(port_r[1]), .B(mul_xor2_4_port_z[1]), .Z(
        mul_xor2_5_port_z[1]) );
  XOR2_X1 mul_xor2_5_U1 ( .A(port_r[1]), .B(mul_xor2_4_port_z[0]), .Z(
        mul_xor2_5_port_z[0]) );
  XOR2_X1 mul_xor2_6_U3 ( .A(port_r[0]), .B(mul_xor2_6_port_a0[2]), .Z(
        mul_xor2_6_port_z[2]) );
  XOR2_X1 mul_xor2_6_U2 ( .A(port_r[0]), .B(mul_xor2_6_port_a0[1]), .Z(
        mul_xor2_6_port_z[1]) );
  XOR2_X1 mul_xor2_6_U1 ( .A(port_r[0]), .B(mul_xor2_6_port_a0[0]), .Z(
        mul_xor2_6_port_z[0]) );
  XOR2_X1 mul_xor2_7_U3 ( .A(port_r[1]), .B(mul_xor2_6_port_z[2]), .Z(
        mul_xor2_7_port_z[2]) );
  XOR2_X1 mul_xor2_7_U2 ( .A(port_r[1]), .B(mul_xor2_6_port_z[1]), .Z(
        mul_xor2_7_port_z[1]) );
  XOR2_X1 mul_xor2_7_U1 ( .A(port_r[1]), .B(mul_xor2_6_port_z[0]), .Z(
        mul_xor2_7_port_z[0]) );
  DFF_X1 cor_m_1_1_reg_0_ ( .D(cor_maj_21_port_o), .CK(clk), .Q(
        cor_port_v_1_1[0]), .QN() );
  DFF_X1 cor_m_1_1_reg_1_ ( .D(cor_maj_22_port_o), .CK(clk), .Q(
        cor_port_v_1_1[1]), .QN() );
  DFF_X1 cor_m_1_1_reg_2_ ( .D(cor_maj_23_port_o), .CK(clk), .Q(
        cor_port_v_1_1[2]), .QN() );
  DFF_X1 cor_m_1_0_reg_0_ ( .D(cor_maj_18_port_o), .CK(clk), .Q(
        cor_port_v_1_0[0]), .QN() );
  DFF_X1 cor_m_1_0_reg_1_ ( .D(cor_maj_19_port_o), .CK(clk), .Q(
        cor_port_v_1_0[1]), .QN() );
  DFF_X1 cor_m_1_0_reg_2_ ( .D(cor_maj_20_port_o), .CK(clk), .Q(
        cor_port_v_1_0[2]), .QN() );
  DFF_X1 cor_m_0_1_reg_0_ ( .D(cor_maj_15_port_o), .CK(clk), .Q(
        cor_port_v_0_1[0]), .QN() );
  DFF_X1 cor_m_0_1_reg_1_ ( .D(cor_maj_16_port_o), .CK(clk), .Q(
        cor_port_v_0_1[1]), .QN() );
  DFF_X1 cor_m_0_1_reg_2_ ( .D(cor_maj_17_port_o), .CK(clk), .Q(
        cor_port_v_0_1[2]), .QN() );
  DFF_X1 cor_m_0_0_reg_0_ ( .D(cor_maj_12_port_o), .CK(clk), .Q(
        cor_port_v_0_0[0]), .QN() );
  DFF_X1 cor_m_0_0_reg_1_ ( .D(cor_maj_13_port_o), .CK(clk), .Q(
        cor_port_v_0_0[1]), .QN() );
  DFF_X1 cor_m_0_0_reg_2_ ( .D(cor_maj_14_port_o), .CK(clk), .Q(
        cor_port_v_0_0[2]), .QN() );
  OR2_X1 cor_maj_12_U4 ( .A1(mul_port_c_0_0[1]), .A2(mul_port_c_0_0[0]), .ZN(
        cor_maj_12_n3) );
  NAND2_X1 cor_maj_12_U3 ( .A1(mul_port_c_0_0[2]), .A2(cor_maj_12_n3), .ZN(
        cor_maj_12_n2) );
  NAND2_X1 cor_maj_12_U2 ( .A1(mul_port_c_0_0[1]), .A2(mul_port_c_0_0[0]),
        .ZN(cor_maj_12_n1) );
  NAND2_X1 cor_maj_12_U1 ( .A1(cor_maj_12_n1), .A2(cor_maj_12_n2), .ZN(
        cor_maj_12_port_o) );
  OR2_X1 cor_maj_13_U4 ( .A1(mul_port_c_0_0[1]), .A2(mul_port_c_0_0[0]), .ZN(
        cor_maj_13_n4) );
  NAND2_X1 cor_maj_13_U3 ( .A1(mul_port_c_0_0[2]), .A2(cor_maj_13_n4), .ZN(
        cor_maj_13_n5) );
  NAND2_X1 cor_maj_13_U2 ( .A1(mul_port_c_0_0[1]), .A2(mul_port_c_0_0[0]),
        .ZN(cor_maj_13_n6) );
  NAND2_X1 cor_maj_13_U1 ( .A1(cor_maj_13_n6), .A2(cor_maj_13_n5), .ZN(
        cor_maj_13_port_o) );
  OR2_X1 cor_maj_14_U4 ( .A1(mul_port_c_0_0[1]), .A2(mul_port_c_0_0[0]), .ZN(
        cor_maj_14_n4) );
  NAND2_X1 cor_maj_14_U3 ( .A1(mul_port_c_0_0[2]), .A2(cor_maj_14_n4), .ZN(
        cor_maj_14_n5) );
  NAND2_X1 cor_maj_14_U2 ( .A1(mul_port_c_0_0[1]), .A2(mul_port_c_0_0[0]),
        .ZN(cor_maj_14_n6) );
  NAND2_X1 cor_maj_14_U1 ( .A1(cor_maj_14_n6), .A2(cor_maj_14_n5), .ZN(
        cor_maj_14_port_o) );
  OR2_X1 cor_maj_15_U4 ( .A1(mul_port_c_0_1[1]), .A2(mul_port_c_0_1[0]), .ZN(
        cor_maj_15_n4) );
  NAND2_X1 cor_maj_15_U3 ( .A1(mul_port_c_0_1[2]), .A2(cor_maj_15_n4), .ZN(
        cor_maj_15_n5) );
  NAND2_X1 cor_maj_15_U2 ( .A1(mul_port_c_0_1[1]), .A2(mul_port_c_0_1[0]),
        .ZN(cor_maj_15_n6) );
  NAND2_X1 cor_maj_15_U1 ( .A1(cor_maj_15_n6), .A2(cor_maj_15_n5), .ZN(
        cor_maj_15_port_o) );
  OR2_X1 cor_maj_16_U4 ( .A1(mul_port_c_0_1[1]), .A2(mul_port_c_0_1[0]), .ZN(
        cor_maj_16_n4) );
  NAND2_X1 cor_maj_16_U3 ( .A1(mul_port_c_0_1[2]), .A2(cor_maj_16_n4), .ZN(
        cor_maj_16_n5) );
  NAND2_X1 cor_maj_16_U2 ( .A1(mul_port_c_0_1[1]), .A2(mul_port_c_0_1[0]),
        .ZN(cor_maj_16_n6) );
  NAND2_X1 cor_maj_16_U1 ( .A1(cor_maj_16_n6), .A2(cor_maj_16_n5), .ZN(
        cor_maj_16_port_o) );
  OR2_X1 cor_maj_17_U4 ( .A1(mul_port_c_0_1[1]), .A2(mul_port_c_0_1[0]), .ZN(
        cor_maj_17_n4) );
  NAND2_X1 cor_maj_17_U3 ( .A1(mul_port_c_0_1[2]), .A2(cor_maj_17_n4), .ZN(
        cor_maj_17_n5) );
  NAND2_X1 cor_maj_17_U2 ( .A1(mul_port_c_0_1[1]), .A2(mul_port_c_0_1[0]),
        .ZN(cor_maj_17_n6) );
  NAND2_X1 cor_maj_17_U1 ( .A1(cor_maj_17_n6), .A2(cor_maj_17_n5), .ZN(
        cor_maj_17_port_o) );
  OR2_X1 cor_maj_18_U4 ( .A1(mul_port_c_1_0[1]), .A2(mul_port_c_1_0[0]), .ZN(
        cor_maj_18_n4) );
  NAND2_X1 cor_maj_18_U3 ( .A1(mul_port_c_1_0[2]), .A2(cor_maj_18_n4), .ZN(
        cor_maj_18_n5) );
  NAND2_X1 cor_maj_18_U2 ( .A1(mul_port_c_1_0[1]), .A2(mul_port_c_1_0[0]),
        .ZN(cor_maj_18_n6) );
  NAND2_X1 cor_maj_18_U1 ( .A1(cor_maj_18_n6), .A2(cor_maj_18_n5), .ZN(
        cor_maj_18_port_o) );
  OR2_X1 cor_maj_19_U4 ( .A1(mul_port_c_1_0[1]), .A2(mul_port_c_1_0[0]), .ZN(
        cor_maj_19_n4) );
  NAND2_X1 cor_maj_19_U3 ( .A1(mul_port_c_1_0[2]), .A2(cor_maj_19_n4), .ZN(
        cor_maj_19_n5) );
  NAND2_X1 cor_maj_19_U2 ( .A1(mul_port_c_1_0[1]), .A2(mul_port_c_1_0[0]),
        .ZN(cor_maj_19_n6) );
  NAND2_X1 cor_maj_19_U1 ( .A1(cor_maj_19_n6), .A2(cor_maj_19_n5), .ZN(
        cor_maj_19_port_o) );
  OR2_X1 cor_maj_20_U4 ( .A1(mul_port_c_1_0[1]), .A2(mul_port_c_1_0[0]), .ZN(
        cor_maj_20_n4) );
  NAND2_X1 cor_maj_20_U3 ( .A1(mul_port_c_1_0[2]), .A2(cor_maj_20_n4), .ZN(
        cor_maj_20_n5) );
  NAND2_X1 cor_maj_20_U2 ( .A1(mul_port_c_1_0[1]), .A2(mul_port_c_1_0[0]),
        .ZN(cor_maj_20_n6) );
  NAND2_X1 cor_maj_20_U1 ( .A1(cor_maj_20_n6), .A2(cor_maj_20_n5), .ZN(
        cor_maj_20_port_o) );
  OR2_X1 cor_maj_21_U4 ( .A1(mul_port_c_1_1[1]), .A2(mul_port_c_1_1[0]), .ZN(
        cor_maj_21_n4) );
  NAND2_X1 cor_maj_21_U3 ( .A1(mul_port_c_1_1[2]), .A2(cor_maj_21_n4), .ZN(
        cor_maj_21_n5) );
  NAND2_X1 cor_maj_21_U2 ( .A1(mul_port_c_1_1[1]), .A2(mul_port_c_1_1[0]),
        .ZN(cor_maj_21_n6) );
  NAND2_X1 cor_maj_21_U1 ( .A1(cor_maj_21_n6), .A2(cor_maj_21_n5), .ZN(
        cor_maj_21_port_o) );
  OR2_X1 cor_maj_22_U4 ( .A1(mul_port_c_1_1[1]), .A2(mul_port_c_1_1[0]), .ZN(
        cor_maj_22_n4) );
  NAND2_X1 cor_maj_22_U3 ( .A1(mul_port_c_1_1[2]), .A2(cor_maj_22_n4), .ZN(
        cor_maj_22_n5) );
  NAND2_X1 cor_maj_22_U2 ( .A1(mul_port_c_1_1[1]), .A2(mul_port_c_1_1[0]),
        .ZN(cor_maj_22_n6) );
  NAND2_X1 cor_maj_22_U1 ( .A1(cor_maj_22_n6), .A2(cor_maj_22_n5), .ZN(
        cor_maj_22_port_o) );
  OR2_X1 cor_maj_23_U4 ( .A1(mul_port_c_1_1[1]), .A2(mul_port_c_1_1[0]), .ZN(
        cor_maj_23_n4) );
  NAND2_X1 cor_maj_23_U3 ( .A1(mul_port_c_1_1[2]), .A2(cor_maj_23_n4), .ZN(
        cor_maj_23_n5) );
  NAND2_X1 cor_maj_23_U2 ( .A1(mul_port_c_1_1[1]), .A2(mul_port_c_1_1[0]),
        .ZN(cor_maj_23_n6) );
  NAND2_X1 cor_maj_23_U1 ( .A1(cor_maj_23_n6), .A2(cor_maj_23_n5), .ZN(
        cor_maj_23_port_o) );
  XOR2_X1 comp_U6 ( .A(cor_port_v_0_1[2]), .B(cor_port_v_0_0[2]), .Z(
        comp_port_c_0[2]) );
  XOR2_X1 comp_U5 ( .A(cor_port_v_0_1[1]), .B(cor_port_v_0_0[1]), .Z(
        comp_port_c_0[1]) );
  XOR2_X1 comp_U4 ( .A(cor_port_v_0_1[0]), .B(cor_port_v_0_0[0]), .Z(
        comp_port_c_0[0]) );
  XOR2_X1 comp_U3 ( .A(cor_port_v_1_1[2]), .B(cor_port_v_1_0[2]), .Z(
        comp_port_c_1[2]) );
  XOR2_X1 comp_U2 ( .A(cor_port_v_1_1[1]), .B(cor_port_v_1_0[1]), .Z(
        comp_port_c_1[1]) );
  XOR2_X1 comp_U1 ( .A(cor_port_v_1_1[0]), .B(cor_port_v_1_0[0]), .Z(
        comp_port_c_1[0]) );
endmodule
