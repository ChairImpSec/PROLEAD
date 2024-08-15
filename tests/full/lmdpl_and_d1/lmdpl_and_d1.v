module lmdpl_and_d1 ( clk, rst, a1, b1, a2, a2_bar, b2, b2_bar, r, x1, x2, x2_bar );
  input clk, rst, a1, b1, a2, a2_bar, b2, b2_bar, r;
  output x1, x2, x2_bar;
  wire   r, mask_table_generator_layer_n5, mask_table_generator_layer_n4,
         mask_table_generator_layer_n3, mask_table_generator_layer_n2,
         mask_table_generator_layer_n1, reg_n1, reg_N10, reg_N9, reg_N8,
         reg_N7, reg_N6, reg_N5, reg_N4, reg_N3;
  wire   [7:0] t_in;
  wire   [7:0] t_out;
  wire   [3:0] operation_layer_inst_rail_s;
  wire   [3:0] operation_layer_inst_rail_bar_s;
  assign x1 = r;

  INV_X1 mask_table_generator_layer_U13 ( .A(t_in[0]), .ZN(t_in[4]) );
  XNOR2_X1 mask_table_generator_layer_U12 ( .A(r), .B(
        mask_table_generator_layer_n5), .ZN(t_in[0]) );
  AND2_X1 mask_table_generator_layer_U11 ( .A1(a1), .A2(b1), .ZN(
        mask_table_generator_layer_n5) );
  INV_X1 mask_table_generator_layer_U10 ( .A(t_in[1]), .ZN(t_in[5]) );
  XOR2_X1 mask_table_generator_layer_U9 ( .A(r), .B(
        mask_table_generator_layer_n4), .Z(t_in[1]) );
  OR2_X1 mask_table_generator_layer_U8 ( .A1(a1), .A2(
        mask_table_generator_layer_n3), .ZN(mask_table_generator_layer_n4) );
  INV_X1 mask_table_generator_layer_U7 ( .A(t_in[2]), .ZN(t_in[6]) );
  XNOR2_X1 mask_table_generator_layer_U6 ( .A(r), .B(
        mask_table_generator_layer_n2), .ZN(t_in[2]) );
  AND2_X1 mask_table_generator_layer_U5 ( .A1(a1), .A2(
        mask_table_generator_layer_n3), .ZN(mask_table_generator_layer_n2) );
  INV_X1 mask_table_generator_layer_U4 ( .A(b1), .ZN(
        mask_table_generator_layer_n3) );
  INV_X1 mask_table_generator_layer_U3 ( .A(t_in[3]), .ZN(t_in[7]) );
  XOR2_X1 mask_table_generator_layer_U2 ( .A(r), .B(
        mask_table_generator_layer_n1), .Z(t_in[3]) );
  OR2_X1 mask_table_generator_layer_U1 ( .A1(a1), .A2(b1), .ZN(
        mask_table_generator_layer_n1) );
  AND2_X1 reg_U11 ( .A1(t_in[1]), .A2(reg_n1), .ZN(reg_N4) );
  AND2_X1 reg_U10 ( .A1(t_in[2]), .A2(reg_n1), .ZN(reg_N5) );
  AND2_X1 reg_U9 ( .A1(t_in[3]), .A2(reg_n1), .ZN(reg_N6) );
  AND2_X1 reg_U8 ( .A1(t_in[0]), .A2(reg_n1), .ZN(reg_N3) );
  AND2_X1 reg_U7 ( .A1(t_in[4]), .A2(reg_n1), .ZN(reg_N7) );
  AND2_X1 reg_U6 ( .A1(t_in[5]), .A2(reg_n1), .ZN(reg_N8) );
  AND2_X1 reg_U5 ( .A1(t_in[6]), .A2(reg_n1), .ZN(reg_N9) );
  AND2_X1 reg_U4 ( .A1(t_in[7]), .A2(reg_n1), .ZN(reg_N10) );
  INV_X1 reg_U3 ( .A(rst), .ZN(reg_n1) );
  DFF_X1 reg_q_reg_0_ ( .D(reg_N3), .CK(clk), .Q(t_out[0]) );
  DFF_X1 reg_q_reg_1_ ( .D(reg_N4), .CK(clk), .Q(t_out[1]) );
  DFF_X1 reg_q_reg_2_ ( .D(reg_N5), .CK(clk), .Q(t_out[2]) );
  DFF_X1 reg_q_reg_3_ ( .D(reg_N6), .CK(clk), .Q(t_out[3]) );
  DFF_X1 reg_q_reg_4_ ( .D(reg_N7), .CK(clk), .Q(t_out[4]) );
  DFF_X1 reg_q_reg_5_ ( .D(reg_N8), .CK(clk), .Q(t_out[5]) );
  DFF_X1 reg_q_reg_6_ ( .D(reg_N9), .CK(clk), .Q(t_out[6]) );
  DFF_X1 reg_q_reg_7_ ( .D(reg_N10), .CK(clk), .Q(t_out[7]) );
  AND3_X1 operation_layer_inst_rail_and_inst0_U1 ( .A1(t_out[7]), .A2(b2), 
        .A3(a2), .ZN(operation_layer_inst_rail_s[3]) );
  AND3_X1 operation_layer_inst_rail_and_inst1_U1 ( .A1(t_out[6]), .A2(b2), 
        .A3(a2_bar), .ZN(operation_layer_inst_rail_s[2]) );
  AND3_X1 operation_layer_inst_rail_and_inst2_U1 ( .A1(t_out[5]), .A2(b2_bar), 
        .A3(a2), .ZN(operation_layer_inst_rail_s[1]) );
  AND3_X1 operation_layer_inst_rail_and_inst3_U1 ( .A1(t_out[4]), .A2(b2_bar), 
        .A3(a2_bar), .ZN(operation_layer_inst_rail_s[0]) );
  OR4_X1 operation_layer_inst_rail_or_inst0_U1 ( .A1(
        operation_layer_inst_rail_s[2]), .A2(operation_layer_inst_rail_s[3]), 
        .A3(operation_layer_inst_rail_s[0]), .A4(
        operation_layer_inst_rail_s[1]), .ZN(x2) );
  AND3_X1 operation_layer_inst_rail_bar_and_inst0_U1 ( .A1(t_out[3]), .A2(b2), 
        .A3(a2), .ZN(operation_layer_inst_rail_bar_s[3]) );
  AND3_X1 operation_layer_inst_rail_bar_and_inst1_U1 ( .A1(t_out[2]), .A2(b2), 
        .A3(a2_bar), .ZN(operation_layer_inst_rail_bar_s[2]) );
  AND3_X1 operation_layer_inst_rail_bar_and_inst2_U1 ( .A1(t_out[1]), .A2(
        b2_bar), .A3(a2), .ZN(operation_layer_inst_rail_bar_s[1]) );
  AND3_X1 operation_layer_inst_rail_bar_and_inst3_U1 ( .A1(t_out[0]), .A2(
        b2_bar), .A3(a2_bar), .ZN(operation_layer_inst_rail_bar_s[0]) );
  OR4_X1 operation_layer_inst_rail_bar_or_inst0_U1 ( .A1(
        operation_layer_inst_rail_bar_s[2]), .A2(
        operation_layer_inst_rail_bar_s[3]), .A3(
        operation_layer_inst_rail_bar_s[0]), .A4(
        operation_layer_inst_rail_bar_s[1]), .ZN(x2_bar) );
endmodule

