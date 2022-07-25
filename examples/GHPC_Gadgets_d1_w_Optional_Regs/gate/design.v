
module circuit ( a, b, c, r, clk, d );
  input [1:0] a;
  input [1:0] b;
  input [1:0] c;
  input [1:0] r;
  output [1:0] d;
  input clk;
  wire   inst1_out0_mid_0_, inst1_Step1_ins_n14, inst1_Step1_ins_n13,
         inst1_Step1_ins_n12, inst1_Step1_ins_n11, inst1_Step1_ins_n10,
         inst1_Step2_inst_n3, inst1_Step2_inst_n2, inst1_Step2_inst_n1,
         inst1_Step2_inst_n7, inst1_Step2_inst_n6, inst1_Step2_inst_n5,
         inst1_Step2_inst_N10, inst1_Step2_inst_step2_ins_0_0_value,
         inst1_Step2_inst_step2_ins_0_1_value,
         inst1_Step2_inst_step2_ins_0_2_value,
         inst1_Step2_inst_step2_ins_0_3_value, inst2_out0_mid_0_,
         inst2_Step1_ins_n14, inst2_Step1_ins_n13, inst2_Step1_ins_n12,
         inst2_Step1_ins_n11, inst2_Step1_ins_n10, inst2_Step2_inst_n17,
         inst2_Step2_inst_n16, inst2_Step2_inst_n15, inst2_Step2_inst_n10,
         inst2_Step2_inst_n9, inst2_Step2_inst_n8, inst2_Step2_inst_N10,
         inst2_Step2_inst_step2_ins_0_0_value,
         inst2_Step2_inst_step2_ins_0_1_value,
         inst2_Step2_inst_step2_ins_0_2_value,
         inst2_Step2_inst_step2_ins_0_3_value;
  wire   [1:0] t;
  wire   [3:0] inst1_Step1_reg;
  wire   [1:0] inst1_in1_reg;
  wire   [3:0] inst1_Step1_ins_Step1;
  wire   [3:0] inst1_Step2_inst_Step2_reg;
  wire   [3:0] inst2_Step1_reg;
  wire   [1:0] inst2_in1_reg;
  wire   [3:0] inst2_Step1_ins_Step1;
  wire   [3:0] inst2_Step2_inst_Step2_reg;

  DFF_X1 inst1_reg_ins1_0_Q_reg ( .D(a[1]), .CK(clk), .Q(inst1_in1_reg[0]), 
        .QN() );
  DFF_X1 inst1_reg_ins1_1_Q_reg ( .D(b[1]), .CK(clk), .Q(inst1_in1_reg[1]), 
        .QN() );
  XOR2_X1 inst1_Step1_ins_U9 ( .A(r[0]), .B(inst1_Step1_ins_n14), .Z(
        inst1_Step1_ins_Step1[3]) );
  NOR2_X1 inst1_Step1_ins_U8 ( .A1(a[0]), .A2(b[0]), .ZN(inst1_Step1_ins_n14)
         );
  XOR2_X1 inst1_Step1_ins_U7 ( .A(r[0]), .B(inst1_Step1_ins_n13), .Z(
        inst1_Step1_ins_Step1[2]) );
  NOR2_X1 inst1_Step1_ins_U6 ( .A1(b[0]), .A2(inst1_Step1_ins_n12), .ZN(
        inst1_Step1_ins_n13) );
  XNOR2_X1 inst1_Step1_ins_U5 ( .A(inst1_Step1_ins_n11), .B(r[0]), .ZN(
        inst1_Step1_ins_Step1[1]) );
  NAND2_X1 inst1_Step1_ins_U4 ( .A1(inst1_Step1_ins_n12), .A2(b[0]), .ZN(
        inst1_Step1_ins_n11) );
  INV_X1 inst1_Step1_ins_U3 ( .A(a[0]), .ZN(inst1_Step1_ins_n12) );
  XNOR2_X1 inst1_Step1_ins_U2 ( .A(inst1_Step1_ins_n10), .B(r[0]), .ZN(
        inst1_Step1_ins_Step1[0]) );
  NAND2_X1 inst1_Step1_ins_U1 ( .A1(b[0]), .A2(a[0]), .ZN(inst1_Step1_ins_n10)
         );
  DFF_X1 inst1_Step1_ins_reg_ins_0_0_Q_reg ( .D(inst1_Step1_ins_Step1[0]), 
        .CK(clk), .Q(inst1_Step1_reg[0]), .QN() );
  DFF_X1 inst1_Step1_ins_reg_ins_0_1_Q_reg ( .D(inst1_Step1_ins_Step1[1]), 
        .CK(clk), .Q(inst1_Step1_reg[1]), .QN() );
  DFF_X1 inst1_Step1_ins_reg_ins_0_2_Q_reg ( .D(inst1_Step1_ins_Step1[2]), 
        .CK(clk), .Q(inst1_Step1_reg[2]), .QN() );
  DFF_X1 inst1_Step1_ins_reg_ins_0_3_Q_reg ( .D(inst1_Step1_ins_Step1[3]), 
        .CK(clk), .Q(inst1_Step1_reg[3]), .QN() );
  XNOR2_X1 inst1_Step2_inst_U8 ( .A(inst1_Step2_inst_n3), .B(
        inst1_Step2_inst_n2), .ZN(t[1]) );
  XNOR2_X1 inst1_Step2_inst_U7 ( .A(inst1_Step2_inst_Step2_reg[2]), .B(
        inst1_Step2_inst_Step2_reg[3]), .ZN(inst1_Step2_inst_n2) );
  XOR2_X1 inst1_Step2_inst_U6 ( .A(inst1_Step2_inst_Step2_reg[0]), .B(
        inst1_Step2_inst_Step2_reg[1]), .Z(inst1_Step2_inst_n3) );
  NOR2_X1 inst1_Step2_inst_U5 ( .A1(inst1_in1_reg[0]), .A2(inst1_in1_reg[1]), 
        .ZN(inst1_Step2_inst_n7) );
  AND2_X1 inst1_Step2_inst_U4 ( .A1(inst1_Step2_inst_n1), .A2(inst1_in1_reg[0]), .ZN(inst1_Step2_inst_n6) );
  NOR2_X1 inst1_Step2_inst_U3 ( .A1(inst1_in1_reg[0]), .A2(inst1_Step2_inst_n1), .ZN(inst1_Step2_inst_n5) );
  INV_X1 inst1_Step2_inst_U2 ( .A(inst1_in1_reg[1]), .ZN(inst1_Step2_inst_n1)
         );
  AND2_X1 inst1_Step2_inst_U1 ( .A1(inst1_in1_reg[0]), .A2(inst1_in1_reg[1]), 
        .ZN(inst1_Step2_inst_N10) );
  AND2_X1 inst1_Step2_inst_step2_ins_0_0_U3 ( .A1(inst1_Step2_inst_n7), .A2(
        inst1_Step1_reg[0]), .ZN(inst1_Step2_inst_step2_ins_0_0_value) );
  DFF_X1 inst1_Step2_inst_step2_ins_0_0_output_reg ( .D(
        inst1_Step2_inst_step2_ins_0_0_value), .CK(clk), .Q(
        inst1_Step2_inst_Step2_reg[0]), .QN() );
  AND2_X1 inst1_Step2_inst_step2_ins_0_1_U3 ( .A1(inst1_Step2_inst_n6), .A2(
        inst1_Step1_reg[1]), .ZN(inst1_Step2_inst_step2_ins_0_1_value) );
  DFF_X1 inst1_Step2_inst_step2_ins_0_1_output_reg ( .D(
        inst1_Step2_inst_step2_ins_0_1_value), .CK(clk), .Q(
        inst1_Step2_inst_Step2_reg[1]), .QN() );
  AND2_X1 inst1_Step2_inst_step2_ins_0_2_U3 ( .A1(inst1_Step2_inst_n5), .A2(
        inst1_Step1_reg[2]), .ZN(inst1_Step2_inst_step2_ins_0_2_value) );
  DFF_X1 inst1_Step2_inst_step2_ins_0_2_output_reg ( .D(
        inst1_Step2_inst_step2_ins_0_2_value), .CK(clk), .Q(
        inst1_Step2_inst_Step2_reg[2]), .QN() );
  AND2_X1 inst1_Step2_inst_step2_ins_0_3_U3 ( .A1(inst1_Step2_inst_N10), .A2(
        inst1_Step1_reg[3]), .ZN(inst1_Step2_inst_step2_ins_0_3_value) );
  DFF_X1 inst1_Step2_inst_step2_ins_0_3_output_reg ( .D(
        inst1_Step2_inst_step2_ins_0_3_value), .CK(clk), .Q(
        inst1_Step2_inst_Step2_reg[3]), .QN() );
  DFF_X1 inst1_reg_out0_ins1_0_Q_reg ( .D(r[0]), .CK(clk), .Q(
        inst1_out0_mid_0_), .QN() );
  DFF_X1 inst1_reg_out0_ins2_0_Q_reg ( .D(inst1_out0_mid_0_), .CK(clk), .Q(
        t[0]), .QN() );
  DFF_X1 inst2_reg_ins1_0_Q_reg ( .D(t[1]), .CK(clk), .Q(inst2_in1_reg[0]), 
        .QN() );
  DFF_X1 inst2_reg_ins1_1_Q_reg ( .D(c[1]), .CK(clk), .Q(inst2_in1_reg[1]), 
        .QN() );
  XOR2_X1 inst2_Step1_ins_U9 ( .A(r[1]), .B(inst2_Step1_ins_n14), .Z(
        inst2_Step1_ins_Step1[3]) );
  NOR2_X1 inst2_Step1_ins_U8 ( .A1(t[0]), .A2(c[0]), .ZN(inst2_Step1_ins_n14)
         );
  XOR2_X1 inst2_Step1_ins_U7 ( .A(r[1]), .B(inst2_Step1_ins_n13), .Z(
        inst2_Step1_ins_Step1[2]) );
  NOR2_X1 inst2_Step1_ins_U6 ( .A1(c[0]), .A2(inst2_Step1_ins_n12), .ZN(
        inst2_Step1_ins_n13) );
  XNOR2_X1 inst2_Step1_ins_U5 ( .A(inst2_Step1_ins_n11), .B(r[1]), .ZN(
        inst2_Step1_ins_Step1[1]) );
  NAND2_X1 inst2_Step1_ins_U4 ( .A1(inst2_Step1_ins_n12), .A2(c[0]), .ZN(
        inst2_Step1_ins_n11) );
  INV_X1 inst2_Step1_ins_U3 ( .A(t[0]), .ZN(inst2_Step1_ins_n12) );
  XNOR2_X1 inst2_Step1_ins_U2 ( .A(inst2_Step1_ins_n10), .B(r[1]), .ZN(
        inst2_Step1_ins_Step1[0]) );
  NAND2_X1 inst2_Step1_ins_U1 ( .A1(c[0]), .A2(t[0]), .ZN(inst2_Step1_ins_n10)
         );
  DFF_X1 inst2_Step1_ins_reg_ins_0_0_Q_reg ( .D(inst2_Step1_ins_Step1[0]), 
        .CK(clk), .Q(inst2_Step1_reg[0]), .QN() );
  DFF_X1 inst2_Step1_ins_reg_ins_0_1_Q_reg ( .D(inst2_Step1_ins_Step1[1]), 
        .CK(clk), .Q(inst2_Step1_reg[1]), .QN() );
  DFF_X1 inst2_Step1_ins_reg_ins_0_2_Q_reg ( .D(inst2_Step1_ins_Step1[2]), 
        .CK(clk), .Q(inst2_Step1_reg[2]), .QN() );
  DFF_X1 inst2_Step1_ins_reg_ins_0_3_Q_reg ( .D(inst2_Step1_ins_Step1[3]), 
        .CK(clk), .Q(inst2_Step1_reg[3]), .QN() );
  XNOR2_X1 inst2_Step2_inst_U8 ( .A(inst2_Step2_inst_n17), .B(
        inst2_Step2_inst_n16), .ZN(d[1]) );
  XNOR2_X1 inst2_Step2_inst_U7 ( .A(inst2_Step2_inst_Step2_reg[2]), .B(
        inst2_Step2_inst_Step2_reg[3]), .ZN(inst2_Step2_inst_n16) );
  XOR2_X1 inst2_Step2_inst_U6 ( .A(inst2_Step2_inst_Step2_reg[0]), .B(
        inst2_Step2_inst_Step2_reg[1]), .Z(inst2_Step2_inst_n17) );
  AND2_X1 inst2_Step2_inst_U5 ( .A1(inst2_Step2_inst_n15), .A2(
        inst2_in1_reg[0]), .ZN(inst2_Step2_inst_n9) );
  NOR2_X1 inst2_Step2_inst_U4 ( .A1(inst2_in1_reg[1]), .A2(inst2_in1_reg[0]), 
        .ZN(inst2_Step2_inst_n8) );
  NOR2_X1 inst2_Step2_inst_U3 ( .A1(inst2_in1_reg[0]), .A2(
        inst2_Step2_inst_n15), .ZN(inst2_Step2_inst_n10) );
  INV_X1 inst2_Step2_inst_U2 ( .A(inst2_in1_reg[1]), .ZN(inst2_Step2_inst_n15)
         );
  AND2_X1 inst2_Step2_inst_U1 ( .A1(inst2_in1_reg[1]), .A2(inst2_in1_reg[0]), 
        .ZN(inst2_Step2_inst_N10) );
  AND2_X1 inst2_Step2_inst_step2_ins_0_0_U3 ( .A1(inst2_Step2_inst_n8), .A2(
        inst2_Step1_reg[0]), .ZN(inst2_Step2_inst_step2_ins_0_0_value) );
  DFF_X1 inst2_Step2_inst_step2_ins_0_0_output_reg ( .D(
        inst2_Step2_inst_step2_ins_0_0_value), .CK(clk), .Q(
        inst2_Step2_inst_Step2_reg[0]), .QN() );
  AND2_X1 inst2_Step2_inst_step2_ins_0_1_U3 ( .A1(inst2_Step2_inst_n9), .A2(
        inst2_Step1_reg[1]), .ZN(inst2_Step2_inst_step2_ins_0_1_value) );
  DFF_X1 inst2_Step2_inst_step2_ins_0_1_output_reg ( .D(
        inst2_Step2_inst_step2_ins_0_1_value), .CK(clk), .Q(
        inst2_Step2_inst_Step2_reg[1]), .QN() );
  AND2_X1 inst2_Step2_inst_step2_ins_0_2_U3 ( .A1(inst2_Step2_inst_n10), .A2(
        inst2_Step1_reg[2]), .ZN(inst2_Step2_inst_step2_ins_0_2_value) );
  DFF_X1 inst2_Step2_inst_step2_ins_0_2_output_reg ( .D(
        inst2_Step2_inst_step2_ins_0_2_value), .CK(clk), .Q(
        inst2_Step2_inst_Step2_reg[2]), .QN() );
  AND2_X1 inst2_Step2_inst_step2_ins_0_3_U3 ( .A1(inst2_Step2_inst_N10), .A2(
        inst2_Step1_reg[3]), .ZN(inst2_Step2_inst_step2_ins_0_3_value) );
  DFF_X1 inst2_Step2_inst_step2_ins_0_3_output_reg ( .D(
        inst2_Step2_inst_step2_ins_0_3_value), .CK(clk), .Q(
        inst2_Step2_inst_Step2_reg[3]), .QN() );
  DFF_X1 inst2_reg_out0_ins1_0_Q_reg ( .D(r[1]), .CK(clk), .Q(
        inst2_out0_mid_0_), .QN() );
  DFF_X1 inst2_reg_out0_ins2_0_Q_reg ( .D(inst2_out0_mid_0_), .CK(clk), .Q(
        d[0]), .QN() );
endmodule

