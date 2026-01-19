
module circuit ( ClkxCI, XxDI, Zmul1xDI, Zmul2xDI, Zmul3xDI, Zinv1xDI, 
        Zinv2xDI, Zinv3xDI, QxDO );
  input [15:0] XxDI; // [7:0]:0, [15:8]:1
  input [3:0] Zmul1xDI; // ref
  input [3:0] Zmul2xDI; // ref
  input [3:0] Zmul3xDI; // ref
  input [1:0] Zinv1xDI; // ref
  input [1:0] Zinv2xDI; // ref
  input [1:0] Zinv3xDI; // ref
  output [15:0] QxDO; // [7:0]:0, [15:8]:1
  input ClkxCI; // control
  
  wire   mappedxD_1__7_, mappedxD_1__6_, mappedxD_1__5_, mappedxD_1__4_,
         mappedxD_1__3_, mappedxD_1__1_, mappedxD_1__0_, mappedxD_0__7_,
         mappedxD_0__6_, mappedxD_0__5_, mappedxD_0__4_, mappedxD_0__3_,
         mappedxD_0__1_, mappedxD_0__0_, InvMappedxD_0__6_, InvMappedxD_0__5_,
         InvMappedxD_0__1_, InvMappedxD_0__0_, n9, n10, n11, n12, n13, n14,
         n15, n16, n17, n18, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28,
         n29, n30, n31, n32, input_mapping_1_n23, input_mapping_1_n22,
         input_mapping_1_n21, input_mapping_1_n20, input_mapping_1_n19,
         input_mapping_1_n18, input_mapping_1_n17, output_mapping_1_n9,
         output_mapping_1_n8, output_mapping_1_n7, input_mapping_0_n23,
         input_mapping_0_n22, input_mapping_0_n21, input_mapping_0_n20,
         input_mapping_0_n19, input_mapping_0_n18, input_mapping_0_n17,
         output_mapping_0_n9, output_mapping_0_n8, output_mapping_0_n7,
         mul_y0y1_n16, mul_y0y1_n15, mul_y0y1_n14, mul_y0y1_n13, mul_y0y1_n12,
         mul_y0y1_n11, mul_y0y1_n10, mul_y0y1_n9, mul_y0y1_n8, mul_y0y1_n7,
         mul_y0y1_n6, mul_y0y1_n5, mul_y0y1_n4, mul_y0y1_n3, mul_y0y1_n2,
         mul_y0y1_n1, mul_y0y1_Xi_mul_Yj_1__0_, mul_y0y1_Xi_mul_Yj_1__1_,
         mul_y0y1_Xi_mul_Yj_1__2_, mul_y0y1_Xi_mul_Yj_1__3_,
         mul_y0y1_Xi_mul_Yj_2__0_, mul_y0y1_Xi_mul_Yj_2__1_,
         mul_y0y1_Xi_mul_Yj_2__2_, mul_y0y1_Xi_mul_Yj_2__3_,
         mul_y0y1_gf4_mul_1_1_n77, mul_y0y1_gf4_mul_1_1_n76,
         mul_y0y1_gf4_mul_1_1_n75, mul_y0y1_gf4_mul_1_1_n74,
         mul_y0y1_gf4_mul_1_1_n73, mul_y0y1_gf4_mul_1_1_n72,
         mul_y0y1_gf4_mul_1_1_n71, mul_y0y1_gf4_mul_1_1_n70,
         mul_y0y1_gf4_mul_1_1_n69, mul_y0y1_gf4_mul_1_1_n68,
         mul_y0y1_gf4_mul_1_1_n67, mul_y0y1_gf4_mul_1_1_n66,
         mul_y0y1_gf4_mul_1_1_n65, mul_y0y1_gf4_mul_1_1_n64,
         mul_y0y1_gf4_mul_1_1_n63, mul_y0y1_gf4_mul_1_1_n62,
         mul_y0y1_gf4_mul_1_1_n61, mul_y0y1_gf4_mul_1_1_n60,
         mul_y0y1_gf4_mul_1_1_n59, mul_y0y1_gf4_mul_1_1_n58,
         mul_y0y1_gf4_mul_1_1_n57, mul_y0y1_gf4_mul_1_1_n56,
         mul_y0y1_gf4_mul_1_1_n55, mul_y0y1_gf4_mul_1_1_n54,
         mul_y0y1_gf4_mul_1_1_n53, mul_y0y1_gf4_mul_1_0_n77,
         mul_y0y1_gf4_mul_1_0_n76, mul_y0y1_gf4_mul_1_0_n75,
         mul_y0y1_gf4_mul_1_0_n74, mul_y0y1_gf4_mul_1_0_n73,
         mul_y0y1_gf4_mul_1_0_n72, mul_y0y1_gf4_mul_1_0_n71,
         mul_y0y1_gf4_mul_1_0_n70, mul_y0y1_gf4_mul_1_0_n69,
         mul_y0y1_gf4_mul_1_0_n68, mul_y0y1_gf4_mul_1_0_n67,
         mul_y0y1_gf4_mul_1_0_n66, mul_y0y1_gf4_mul_1_0_n65,
         mul_y0y1_gf4_mul_1_0_n64, mul_y0y1_gf4_mul_1_0_n63,
         mul_y0y1_gf4_mul_1_0_n62, mul_y0y1_gf4_mul_1_0_n61,
         mul_y0y1_gf4_mul_1_0_n60, mul_y0y1_gf4_mul_1_0_n59,
         mul_y0y1_gf4_mul_1_0_n58, mul_y0y1_gf4_mul_1_0_n57,
         mul_y0y1_gf4_mul_1_0_n56, mul_y0y1_gf4_mul_1_0_n55,
         mul_y0y1_gf4_mul_1_0_n54, mul_y0y1_gf4_mul_1_0_n53,
         mul_y0y1_gf4_mul_0_1_n77, mul_y0y1_gf4_mul_0_1_n76,
         mul_y0y1_gf4_mul_0_1_n75, mul_y0y1_gf4_mul_0_1_n74,
         mul_y0y1_gf4_mul_0_1_n73, mul_y0y1_gf4_mul_0_1_n72,
         mul_y0y1_gf4_mul_0_1_n71, mul_y0y1_gf4_mul_0_1_n70,
         mul_y0y1_gf4_mul_0_1_n69, mul_y0y1_gf4_mul_0_1_n68,
         mul_y0y1_gf4_mul_0_1_n67, mul_y0y1_gf4_mul_0_1_n66,
         mul_y0y1_gf4_mul_0_1_n65, mul_y0y1_gf4_mul_0_1_n64,
         mul_y0y1_gf4_mul_0_1_n63, mul_y0y1_gf4_mul_0_1_n62,
         mul_y0y1_gf4_mul_0_1_n61, mul_y0y1_gf4_mul_0_1_n60,
         mul_y0y1_gf4_mul_0_1_n59, mul_y0y1_gf4_mul_0_1_n58,
         mul_y0y1_gf4_mul_0_1_n57, mul_y0y1_gf4_mul_0_1_n56,
         mul_y0y1_gf4_mul_0_1_n55, mul_y0y1_gf4_mul_0_1_n54,
         mul_y0y1_gf4_mul_0_1_n53, mul_y0y1_gf4_mul_0_0_n77,
         mul_y0y1_gf4_mul_0_0_n76, mul_y0y1_gf4_mul_0_0_n75,
         mul_y0y1_gf4_mul_0_0_n74, mul_y0y1_gf4_mul_0_0_n73,
         mul_y0y1_gf4_mul_0_0_n72, mul_y0y1_gf4_mul_0_0_n71,
         mul_y0y1_gf4_mul_0_0_n70, mul_y0y1_gf4_mul_0_0_n69,
         mul_y0y1_gf4_mul_0_0_n68, mul_y0y1_gf4_mul_0_0_n67,
         mul_y0y1_gf4_mul_0_0_n66, mul_y0y1_gf4_mul_0_0_n65,
         mul_y0y1_gf4_mul_0_0_n64, mul_y0y1_gf4_mul_0_0_n63,
         mul_y0y1_gf4_mul_0_0_n62, mul_y0y1_gf4_mul_0_0_n61,
         mul_y0y1_gf4_mul_0_0_n60, mul_y0y1_gf4_mul_0_0_n59,
         mul_y0y1_gf4_mul_0_0_n58, mul_y0y1_gf4_mul_0_0_n57,
         mul_y0y1_gf4_mul_0_0_n56, mul_y0y1_gf4_mul_0_0_n55,
         mul_y0y1_gf4_mul_0_0_n54, mul_y0y1_gf4_mul_0_0_n53, inverter_gf24_n2,
         inverter_gf24_n1, inverter_gf24_n8, inverter_gf24_n7,
         inverter_gf24_n6, inverter_gf24_n5, inverter_gf24_n4,
         inverter_gf24_n3, inverter_gf24_d_0__0_, inverter_gf24_d_1__0_,
         inverter_gf24_ExDP_0__0_, inverter_gf24_ExDP_0__1_,
         inverter_gf24_ExDP_1__0_, inverter_gf24_ExDP_1__1_,
         inverter_gf24_a_mul_b_n8, inverter_gf24_a_mul_b_n7,
         inverter_gf24_a_mul_b_n6, inverter_gf24_a_mul_b_n5,
         inverter_gf24_a_mul_b_n4, inverter_gf24_a_mul_b_n3,
         inverter_gf24_a_mul_b_n2, inverter_gf24_a_mul_b_n1,
         inverter_gf24_a_mul_b_Xi_mul_Yj_1__0_,
         inverter_gf24_a_mul_b_Xi_mul_Yj_1__1_,
         inverter_gf24_a_mul_b_Xi_mul_Yj_2__0_,
         inverter_gf24_a_mul_b_Xi_mul_Yj_2__1_,
         inverter_gf24_a_mul_b_gf2_mul_1_1_n15,
         inverter_gf24_a_mul_b_gf2_mul_1_1_n14,
         inverter_gf24_a_mul_b_gf2_mul_1_1_n13,
         inverter_gf24_a_mul_b_gf2_mul_1_1_n12,
         inverter_gf24_a_mul_b_gf2_mul_1_1_n11,
         inverter_gf24_a_mul_b_gf2_mul_1_0_n15,
         inverter_gf24_a_mul_b_gf2_mul_1_0_n14,
         inverter_gf24_a_mul_b_gf2_mul_1_0_n13,
         inverter_gf24_a_mul_b_gf2_mul_1_0_n12,
         inverter_gf24_a_mul_b_gf2_mul_1_0_n11,
         inverter_gf24_a_mul_b_gf2_mul_0_1_n15,
         inverter_gf24_a_mul_b_gf2_mul_0_1_n14,
         inverter_gf24_a_mul_b_gf2_mul_0_1_n13,
         inverter_gf24_a_mul_b_gf2_mul_0_1_n12,
         inverter_gf24_a_mul_b_gf2_mul_0_1_n11,
         inverter_gf24_a_mul_b_gf2_mul_0_0_n15,
         inverter_gf24_a_mul_b_gf2_mul_0_0_n14,
         inverter_gf24_a_mul_b_gf2_mul_0_0_n13,
         inverter_gf24_a_mul_b_gf2_mul_0_0_n12,
         inverter_gf24_a_mul_b_gf2_mul_0_0_n11, inverter_gf24_a_mul_e_n16,
         inverter_gf24_a_mul_e_n15, inverter_gf24_a_mul_e_n14,
         inverter_gf24_a_mul_e_n13, inverter_gf24_a_mul_e_n12,
         inverter_gf24_a_mul_e_n11, inverter_gf24_a_mul_e_n10,
         inverter_gf24_a_mul_e_n9, inverter_gf24_a_mul_e_Xi_mul_Yj_1__0_,
         inverter_gf24_a_mul_e_Xi_mul_Yj_1__1_,
         inverter_gf24_a_mul_e_Xi_mul_Yj_2__0_,
         inverter_gf24_a_mul_e_Xi_mul_Yj_2__1_,
         inverter_gf24_a_mul_e_gf2_mul_1_1_n15,
         inverter_gf24_a_mul_e_gf2_mul_1_1_n14,
         inverter_gf24_a_mul_e_gf2_mul_1_1_n13,
         inverter_gf24_a_mul_e_gf2_mul_1_1_n12,
         inverter_gf24_a_mul_e_gf2_mul_1_1_n11,
         inverter_gf24_a_mul_e_gf2_mul_1_0_n15,
         inverter_gf24_a_mul_e_gf2_mul_1_0_n14,
         inverter_gf24_a_mul_e_gf2_mul_1_0_n13,
         inverter_gf24_a_mul_e_gf2_mul_1_0_n12,
         inverter_gf24_a_mul_e_gf2_mul_1_0_n11,
         inverter_gf24_a_mul_e_gf2_mul_0_1_n15,
         inverter_gf24_a_mul_e_gf2_mul_0_1_n14,
         inverter_gf24_a_mul_e_gf2_mul_0_1_n13,
         inverter_gf24_a_mul_e_gf2_mul_0_1_n12,
         inverter_gf24_a_mul_e_gf2_mul_0_1_n11,
         inverter_gf24_a_mul_e_gf2_mul_0_0_n15,
         inverter_gf24_a_mul_e_gf2_mul_0_0_n14,
         inverter_gf24_a_mul_e_gf2_mul_0_0_n13,
         inverter_gf24_a_mul_e_gf2_mul_0_0_n12,
         inverter_gf24_a_mul_e_gf2_mul_0_0_n11, inverter_gf24_b_mul_e_n16,
         inverter_gf24_b_mul_e_n15, inverter_gf24_b_mul_e_n14,
         inverter_gf24_b_mul_e_n13, inverter_gf24_b_mul_e_n12,
         inverter_gf24_b_mul_e_n11, inverter_gf24_b_mul_e_n10,
         inverter_gf24_b_mul_e_n9, inverter_gf24_b_mul_e_Xi_mul_Yj_1__0_,
         inverter_gf24_b_mul_e_Xi_mul_Yj_1__1_,
         inverter_gf24_b_mul_e_Xi_mul_Yj_2__0_,
         inverter_gf24_b_mul_e_Xi_mul_Yj_2__1_,
         inverter_gf24_b_mul_e_gf2_mul_1_1_n15,
         inverter_gf24_b_mul_e_gf2_mul_1_1_n14,
         inverter_gf24_b_mul_e_gf2_mul_1_1_n13,
         inverter_gf24_b_mul_e_gf2_mul_1_1_n12,
         inverter_gf24_b_mul_e_gf2_mul_1_1_n11,
         inverter_gf24_b_mul_e_gf2_mul_1_0_n15,
         inverter_gf24_b_mul_e_gf2_mul_1_0_n14,
         inverter_gf24_b_mul_e_gf2_mul_1_0_n13,
         inverter_gf24_b_mul_e_gf2_mul_1_0_n12,
         inverter_gf24_b_mul_e_gf2_mul_1_0_n11,
         inverter_gf24_b_mul_e_gf2_mul_0_1_n15,
         inverter_gf24_b_mul_e_gf2_mul_0_1_n14,
         inverter_gf24_b_mul_e_gf2_mul_0_1_n13,
         inverter_gf24_b_mul_e_gf2_mul_0_1_n12,
         inverter_gf24_b_mul_e_gf2_mul_0_1_n11,
         inverter_gf24_b_mul_e_gf2_mul_0_0_n15,
         inverter_gf24_b_mul_e_gf2_mul_0_0_n14,
         inverter_gf24_b_mul_e_gf2_mul_0_0_n13,
         inverter_gf24_b_mul_e_gf2_mul_0_0_n12,
         inverter_gf24_b_mul_e_gf2_mul_0_0_n11, mult_msb_n16, mult_msb_n15,
         mult_msb_n14, mult_msb_n13, mult_msb_n12, mult_msb_n11, mult_msb_n10,
         mult_msb_n9, mult_msb_n8, mult_msb_n7, mult_msb_n6, mult_msb_n5,
         mult_msb_n4, mult_msb_n3, mult_msb_n2, mult_msb_n1,
         mult_msb_Xi_mul_Yj_1__0_, mult_msb_Xi_mul_Yj_1__1_,
         mult_msb_Xi_mul_Yj_1__2_, mult_msb_Xi_mul_Yj_1__3_,
         mult_msb_Xi_mul_Yj_2__0_, mult_msb_Xi_mul_Yj_2__1_,
         mult_msb_Xi_mul_Yj_2__2_, mult_msb_Xi_mul_Yj_2__3_,
         mult_msb_gf4_mul_1_1_n77, mult_msb_gf4_mul_1_1_n76,
         mult_msb_gf4_mul_1_1_n75, mult_msb_gf4_mul_1_1_n74,
         mult_msb_gf4_mul_1_1_n73, mult_msb_gf4_mul_1_1_n72,
         mult_msb_gf4_mul_1_1_n71, mult_msb_gf4_mul_1_1_n70,
         mult_msb_gf4_mul_1_1_n69, mult_msb_gf4_mul_1_1_n68,
         mult_msb_gf4_mul_1_1_n67, mult_msb_gf4_mul_1_1_n66,
         mult_msb_gf4_mul_1_1_n65, mult_msb_gf4_mul_1_1_n64,
         mult_msb_gf4_mul_1_1_n63, mult_msb_gf4_mul_1_1_n62,
         mult_msb_gf4_mul_1_1_n61, mult_msb_gf4_mul_1_1_n60,
         mult_msb_gf4_mul_1_1_n59, mult_msb_gf4_mul_1_1_n58,
         mult_msb_gf4_mul_1_1_n57, mult_msb_gf4_mul_1_1_n56,
         mult_msb_gf4_mul_1_1_n55, mult_msb_gf4_mul_1_1_n54,
         mult_msb_gf4_mul_1_1_n53, mult_msb_gf4_mul_1_0_n77,
         mult_msb_gf4_mul_1_0_n76, mult_msb_gf4_mul_1_0_n75,
         mult_msb_gf4_mul_1_0_n74, mult_msb_gf4_mul_1_0_n73,
         mult_msb_gf4_mul_1_0_n72, mult_msb_gf4_mul_1_0_n71,
         mult_msb_gf4_mul_1_0_n70, mult_msb_gf4_mul_1_0_n69,
         mult_msb_gf4_mul_1_0_n68, mult_msb_gf4_mul_1_0_n67,
         mult_msb_gf4_mul_1_0_n66, mult_msb_gf4_mul_1_0_n65,
         mult_msb_gf4_mul_1_0_n64, mult_msb_gf4_mul_1_0_n63,
         mult_msb_gf4_mul_1_0_n62, mult_msb_gf4_mul_1_0_n61,
         mult_msb_gf4_mul_1_0_n60, mult_msb_gf4_mul_1_0_n59,
         mult_msb_gf4_mul_1_0_n58, mult_msb_gf4_mul_1_0_n57,
         mult_msb_gf4_mul_1_0_n56, mult_msb_gf4_mul_1_0_n55,
         mult_msb_gf4_mul_1_0_n54, mult_msb_gf4_mul_1_0_n53,
         mult_msb_gf4_mul_0_1_n77, mult_msb_gf4_mul_0_1_n76,
         mult_msb_gf4_mul_0_1_n75, mult_msb_gf4_mul_0_1_n74,
         mult_msb_gf4_mul_0_1_n73, mult_msb_gf4_mul_0_1_n72,
         mult_msb_gf4_mul_0_1_n71, mult_msb_gf4_mul_0_1_n70,
         mult_msb_gf4_mul_0_1_n69, mult_msb_gf4_mul_0_1_n68,
         mult_msb_gf4_mul_0_1_n67, mult_msb_gf4_mul_0_1_n66,
         mult_msb_gf4_mul_0_1_n65, mult_msb_gf4_mul_0_1_n64,
         mult_msb_gf4_mul_0_1_n63, mult_msb_gf4_mul_0_1_n62,
         mult_msb_gf4_mul_0_1_n61, mult_msb_gf4_mul_0_1_n60,
         mult_msb_gf4_mul_0_1_n59, mult_msb_gf4_mul_0_1_n58,
         mult_msb_gf4_mul_0_1_n57, mult_msb_gf4_mul_0_1_n56,
         mult_msb_gf4_mul_0_1_n55, mult_msb_gf4_mul_0_1_n54,
         mult_msb_gf4_mul_0_1_n53, mult_msb_gf4_mul_0_0_n77,
         mult_msb_gf4_mul_0_0_n76, mult_msb_gf4_mul_0_0_n75,
         mult_msb_gf4_mul_0_0_n74, mult_msb_gf4_mul_0_0_n73,
         mult_msb_gf4_mul_0_0_n72, mult_msb_gf4_mul_0_0_n71,
         mult_msb_gf4_mul_0_0_n70, mult_msb_gf4_mul_0_0_n69,
         mult_msb_gf4_mul_0_0_n68, mult_msb_gf4_mul_0_0_n67,
         mult_msb_gf4_mul_0_0_n66, mult_msb_gf4_mul_0_0_n65,
         mult_msb_gf4_mul_0_0_n64, mult_msb_gf4_mul_0_0_n63,
         mult_msb_gf4_mul_0_0_n62, mult_msb_gf4_mul_0_0_n61,
         mult_msb_gf4_mul_0_0_n60, mult_msb_gf4_mul_0_0_n59,
         mult_msb_gf4_mul_0_0_n58, mult_msb_gf4_mul_0_0_n57,
         mult_msb_gf4_mul_0_0_n56, mult_msb_gf4_mul_0_0_n55,
         mult_msb_gf4_mul_0_0_n54, mult_msb_gf4_mul_0_0_n53, mult_lsb_n32,
         mult_lsb_n31, mult_lsb_n30, mult_lsb_n29, mult_lsb_n28, mult_lsb_n27,
         mult_lsb_n26, mult_lsb_n25, mult_lsb_n24, mult_lsb_n23, mult_lsb_n22,
         mult_lsb_n21, mult_lsb_n20, mult_lsb_n19, mult_lsb_n18, mult_lsb_n17,
         mult_lsb_Xi_mul_Yj_1__0_, mult_lsb_Xi_mul_Yj_1__1_,
         mult_lsb_Xi_mul_Yj_1__2_, mult_lsb_Xi_mul_Yj_1__3_,
         mult_lsb_Xi_mul_Yj_2__0_, mult_lsb_Xi_mul_Yj_2__1_,
         mult_lsb_Xi_mul_Yj_2__2_, mult_lsb_Xi_mul_Yj_2__3_,
         mult_lsb_gf4_mul_1_1_n77, mult_lsb_gf4_mul_1_1_n76,
         mult_lsb_gf4_mul_1_1_n75, mult_lsb_gf4_mul_1_1_n74,
         mult_lsb_gf4_mul_1_1_n73, mult_lsb_gf4_mul_1_1_n72,
         mult_lsb_gf4_mul_1_1_n71, mult_lsb_gf4_mul_1_1_n70,
         mult_lsb_gf4_mul_1_1_n69, mult_lsb_gf4_mul_1_1_n68,
         mult_lsb_gf4_mul_1_1_n67, mult_lsb_gf4_mul_1_1_n66,
         mult_lsb_gf4_mul_1_1_n65, mult_lsb_gf4_mul_1_1_n64,
         mult_lsb_gf4_mul_1_1_n63, mult_lsb_gf4_mul_1_1_n62,
         mult_lsb_gf4_mul_1_1_n61, mult_lsb_gf4_mul_1_1_n60,
         mult_lsb_gf4_mul_1_1_n59, mult_lsb_gf4_mul_1_1_n58,
         mult_lsb_gf4_mul_1_1_n57, mult_lsb_gf4_mul_1_1_n56,
         mult_lsb_gf4_mul_1_1_n55, mult_lsb_gf4_mul_1_1_n54,
         mult_lsb_gf4_mul_1_1_n53, mult_lsb_gf4_mul_1_0_n77,
         mult_lsb_gf4_mul_1_0_n76, mult_lsb_gf4_mul_1_0_n75,
         mult_lsb_gf4_mul_1_0_n74, mult_lsb_gf4_mul_1_0_n73,
         mult_lsb_gf4_mul_1_0_n72, mult_lsb_gf4_mul_1_0_n71,
         mult_lsb_gf4_mul_1_0_n70, mult_lsb_gf4_mul_1_0_n69,
         mult_lsb_gf4_mul_1_0_n68, mult_lsb_gf4_mul_1_0_n67,
         mult_lsb_gf4_mul_1_0_n66, mult_lsb_gf4_mul_1_0_n65,
         mult_lsb_gf4_mul_1_0_n64, mult_lsb_gf4_mul_1_0_n63,
         mult_lsb_gf4_mul_1_0_n62, mult_lsb_gf4_mul_1_0_n61,
         mult_lsb_gf4_mul_1_0_n60, mult_lsb_gf4_mul_1_0_n59,
         mult_lsb_gf4_mul_1_0_n58, mult_lsb_gf4_mul_1_0_n57,
         mult_lsb_gf4_mul_1_0_n56, mult_lsb_gf4_mul_1_0_n55,
         mult_lsb_gf4_mul_1_0_n54, mult_lsb_gf4_mul_1_0_n53,
         mult_lsb_gf4_mul_0_1_n77, mult_lsb_gf4_mul_0_1_n76,
         mult_lsb_gf4_mul_0_1_n75, mult_lsb_gf4_mul_0_1_n74,
         mult_lsb_gf4_mul_0_1_n73, mult_lsb_gf4_mul_0_1_n72,
         mult_lsb_gf4_mul_0_1_n71, mult_lsb_gf4_mul_0_1_n70,
         mult_lsb_gf4_mul_0_1_n69, mult_lsb_gf4_mul_0_1_n68,
         mult_lsb_gf4_mul_0_1_n67, mult_lsb_gf4_mul_0_1_n66,
         mult_lsb_gf4_mul_0_1_n65, mult_lsb_gf4_mul_0_1_n64,
         mult_lsb_gf4_mul_0_1_n63, mult_lsb_gf4_mul_0_1_n62,
         mult_lsb_gf4_mul_0_1_n61, mult_lsb_gf4_mul_0_1_n60,
         mult_lsb_gf4_mul_0_1_n59, mult_lsb_gf4_mul_0_1_n58,
         mult_lsb_gf4_mul_0_1_n57, mult_lsb_gf4_mul_0_1_n56,
         mult_lsb_gf4_mul_0_1_n55, mult_lsb_gf4_mul_0_1_n54,
         mult_lsb_gf4_mul_0_1_n53, mult_lsb_gf4_mul_0_0_n77,
         mult_lsb_gf4_mul_0_0_n76, mult_lsb_gf4_mul_0_0_n75,
         mult_lsb_gf4_mul_0_0_n74, mult_lsb_gf4_mul_0_0_n73,
         mult_lsb_gf4_mul_0_0_n72, mult_lsb_gf4_mul_0_0_n71,
         mult_lsb_gf4_mul_0_0_n70, mult_lsb_gf4_mul_0_0_n69,
         mult_lsb_gf4_mul_0_0_n68, mult_lsb_gf4_mul_0_0_n67,
         mult_lsb_gf4_mul_0_0_n66, mult_lsb_gf4_mul_0_0_n65,
         mult_lsb_gf4_mul_0_0_n64, mult_lsb_gf4_mul_0_0_n63,
         mult_lsb_gf4_mul_0_0_n62, mult_lsb_gf4_mul_0_0_n61,
         mult_lsb_gf4_mul_0_0_n60, mult_lsb_gf4_mul_0_0_n59,
         mult_lsb_gf4_mul_0_0_n58, mult_lsb_gf4_mul_0_0_n57,
         mult_lsb_gf4_mul_0_0_n56, mult_lsb_gf4_mul_0_0_n55,
         mult_lsb_gf4_mul_0_0_n54, mult_lsb_gf4_mul_0_0_n53;
  wire   [7:0] Y1xD;
  wire   [7:0] Y0xD;
  wire   [7:0] InverterInxDP;
  wire   [7:0] InverterInxD;
  wire   [7:0] Y0_0xDP;
  wire   [7:0] Y0_1xDP;
  wire   [7:0] Y0_2xDP;
  wire   [7:0] Y0_3xDP;
  wire   [7:0] Y0_4xDP;
  wire   [7:0] Y1_0xDP;
  wire   [7:0] Y1_1xDP;
  wire   [7:0] Y1_2xDP;
  wire   [7:0] Y1_3xDP;
  wire   [7:0] Y1_4xDP;
  wire   [7:0] Y0xorY12xD;
  wire   [5:0] Y0xorY1xD;
  wire   [7:0] Y0mulY1xD;
  wire   [15:0] InvUnmappedxD;
  wire   [7:0] InverterOutxD;
  wire   [15:0] mul_y0y1_FFxDN;
  wire   [3:0] inverter_gf24_AmulBxD;
  wire   [3:0] inverter_gf24_ExD;
  wire   [3:0] inverter_gf24_pipelinedBxDP;
  wire   [3:0] inverter_gf24_pipelinedAxDP;
  wire   [3:0] inverter_gf24_BxDP;
  wire   [3:0] inverter_gf24_AxDP;
  wire   [7:0] inverter_gf24_a_mul_b_FFxDN;
  wire   [7:0] inverter_gf24_a_mul_e_FFxDN;
  wire   [7:0] inverter_gf24_b_mul_e_FFxDN;
  wire   [15:0] mult_msb_FFxDN;
  wire   [15:0] mult_lsb_FFxDN;

  DFF_X1 mappedxDP_reg_1__7_ ( .D(mappedxD_1__7_), .CK(ClkxCI), .Q(Y1xD[7]), 
        .QN(n10) );
  DFF_X1 mappedxDP_reg_1__6_ ( .D(mappedxD_1__6_), .CK(ClkxCI), .Q(Y1xD[6]), 
        .QN(n12) );
  DFF_X1 mappedxDP_reg_1__5_ ( .D(mappedxD_1__5_), .CK(ClkxCI), .Q(Y1xD[5]), 
        .QN(n14) );
  DFF_X1 mappedxDP_reg_1__4_ ( .D(mappedxD_1__4_), .CK(ClkxCI), .Q(Y1xD[4]), 
        .QN(n16) );
  DFF_X1 mappedxDP_reg_1__3_ ( .D(mappedxD_1__3_), .CK(ClkxCI), .Q(Y0xD[7]), 
        .QN(n9) );
  DFF_X1 mappedxDP_reg_1__2_ ( .D(XxDI[8]), .CK(ClkxCI), .Q(Y0xD[6]), .QN(n11)
         );
  DFF_X1 mappedxDP_reg_1__1_ ( .D(mappedxD_1__1_), .CK(ClkxCI), .Q(Y0xD[5]), 
        .QN(n13) );
  DFF_X1 mappedxDP_reg_1__0_ ( .D(mappedxD_1__0_), .CK(ClkxCI), .Q(Y0xD[4]), 
        .QN(n15) );
  DFF_X1 mappedxDP_reg_0__7_ ( .D(mappedxD_0__7_), .CK(ClkxCI), .Q(Y1xD[3]), 
        .QN(n18) );
  DFF_X1 mappedxDP_reg_0__6_ ( .D(mappedxD_0__6_), .CK(ClkxCI), .Q(Y1xD[2]), 
        .QN(n20) );
  DFF_X1 mappedxDP_reg_0__5_ ( .D(mappedxD_0__5_), .CK(ClkxCI), .Q(Y1xD[1]), 
        .QN(n22) );
  DFF_X1 mappedxDP_reg_0__4_ ( .D(mappedxD_0__4_), .CK(ClkxCI), .Q(Y1xD[0]), 
        .QN(n24) );
  DFF_X1 mappedxDP_reg_0__3_ ( .D(mappedxD_0__3_), .CK(ClkxCI), .Q(Y0xD[3]), 
        .QN(n17) );
  DFF_X1 mappedxDP_reg_0__2_ ( .D(XxDI[0]), .CK(ClkxCI), .Q(Y0xD[2]), .QN(n19)
         );
  DFF_X1 mappedxDP_reg_0__1_ ( .D(mappedxD_0__1_), .CK(ClkxCI), .Q(Y0xD[1]), 
        .QN(n21) );
  DFF_X1 mappedxDP_reg_0__0_ ( .D(mappedxD_0__0_), .CK(ClkxCI), .Q(Y0xD[0]), 
        .QN(n23) );
  DFF_X1 Y0xorY12xDP_reg_1__3_ ( .D(Y0xorY12xD[7]), .CK(ClkxCI), .Q(), .QN(n25) );
  DFF_X1 InverterInxDP_reg_1__3_ ( .D(InverterInxD[7]), .CK(ClkxCI), .Q(
        InverterInxDP[7]), .QN() );
  DFF_X1 Y0xorY12xDP_reg_1__2_ ( .D(Y0xorY12xD[6]), .CK(ClkxCI), .Q(), .QN(n26) );
  DFF_X1 InverterInxDP_reg_1__2_ ( .D(InverterInxD[6]), .CK(ClkxCI), .Q(
        InverterInxDP[6]), .QN() );
  DFF_X1 Y0xorY12xDP_reg_1__1_ ( .D(Y0xorY12xD[5]), .CK(ClkxCI), .Q(), .QN(n27) );
  DFF_X1 InverterInxDP_reg_1__1_ ( .D(InverterInxD[5]), .CK(ClkxCI), .Q(
        InverterInxDP[5]), .QN() );
  DFF_X1 Y0xorY12xDP_reg_1__0_ ( .D(Y0xorY12xD[4]), .CK(ClkxCI), .Q(), .QN(n28) );
  DFF_X1 InverterInxDP_reg_1__0_ ( .D(InverterInxD[4]), .CK(ClkxCI), .Q(
        InverterInxDP[4]), .QN() );
  DFF_X1 Y0xorY12xDP_reg_0__3_ ( .D(Y0xorY12xD[3]), .CK(ClkxCI), .Q(), .QN(n29) );
  DFF_X1 InverterInxDP_reg_0__3_ ( .D(InverterInxD[3]), .CK(ClkxCI), .Q(
        InverterInxDP[3]), .QN() );
  DFF_X1 Y0xorY12xDP_reg_0__2_ ( .D(Y0xorY12xD[2]), .CK(ClkxCI), .Q(), .QN(n30) );
  DFF_X1 InverterInxDP_reg_0__2_ ( .D(InverterInxD[2]), .CK(ClkxCI), .Q(
        InverterInxDP[2]), .QN() );
  DFF_X1 Y0xorY12xDP_reg_0__1_ ( .D(Y0xorY12xD[1]), .CK(ClkxCI), .Q(), .QN(n31) );
  DFF_X1 InverterInxDP_reg_0__1_ ( .D(InverterInxD[1]), .CK(ClkxCI), .Q(
        InverterInxDP[1]), .QN() );
  DFF_X1 Y0xorY12xDP_reg_0__0_ ( .D(Y0xorY12xD[0]), .CK(ClkxCI), .Q(), .QN(n32) );
  DFF_X1 InverterInxDP_reg_0__0_ ( .D(InverterInxD[0]), .CK(ClkxCI), .Q(
        InverterInxDP[0]), .QN() );
  DFF_X1 Y0_0xDP_reg_1__3_ ( .D(Y0xD[7]), .CK(ClkxCI), .Q(Y0_0xDP[7]), .QN()
         );
  DFF_X1 Y0_0xDP_reg_1__2_ ( .D(Y0xD[6]), .CK(ClkxCI), .Q(Y0_0xDP[6]), .QN()
         );
  DFF_X1 Y0_0xDP_reg_1__1_ ( .D(Y0xD[5]), .CK(ClkxCI), .Q(Y0_0xDP[5]), .QN()
         );
  DFF_X1 Y0_0xDP_reg_1__0_ ( .D(Y0xD[4]), .CK(ClkxCI), .Q(Y0_0xDP[4]), .QN()
         );
  DFF_X1 Y0_0xDP_reg_0__3_ ( .D(Y0xD[3]), .CK(ClkxCI), .Q(Y0_0xDP[3]), .QN()
         );
  DFF_X1 Y0_0xDP_reg_0__2_ ( .D(Y0xD[2]), .CK(ClkxCI), .Q(Y0_0xDP[2]), .QN()
         );
  DFF_X1 Y0_0xDP_reg_0__1_ ( .D(Y0xD[1]), .CK(ClkxCI), .Q(Y0_0xDP[1]), .QN()
         );
  DFF_X1 Y0_0xDP_reg_0__0_ ( .D(Y0xD[0]), .CK(ClkxCI), .Q(Y0_0xDP[0]), .QN()
         );
  DFF_X1 Y0_1xDP_reg_1__3_ ( .D(Y0_0xDP[7]), .CK(ClkxCI), .Q(Y0_1xDP[7]), 
        .QN() );
  DFF_X1 Y0_1xDP_reg_1__2_ ( .D(Y0_0xDP[6]), .CK(ClkxCI), .Q(Y0_1xDP[6]), 
        .QN() );
  DFF_X1 Y0_1xDP_reg_1__1_ ( .D(Y0_0xDP[5]), .CK(ClkxCI), .Q(Y0_1xDP[5]), 
        .QN() );
  DFF_X1 Y0_1xDP_reg_1__0_ ( .D(Y0_0xDP[4]), .CK(ClkxCI), .Q(Y0_1xDP[4]), 
        .QN() );
  DFF_X1 Y0_1xDP_reg_0__3_ ( .D(Y0_0xDP[3]), .CK(ClkxCI), .Q(Y0_1xDP[3]), 
        .QN() );
  DFF_X1 Y0_1xDP_reg_0__2_ ( .D(Y0_0xDP[2]), .CK(ClkxCI), .Q(Y0_1xDP[2]), 
        .QN() );
  DFF_X1 Y0_1xDP_reg_0__1_ ( .D(Y0_0xDP[1]), .CK(ClkxCI), .Q(Y0_1xDP[1]), 
        .QN() );
  DFF_X1 Y0_1xDP_reg_0__0_ ( .D(Y0_0xDP[0]), .CK(ClkxCI), .Q(Y0_1xDP[0]), 
        .QN() );
  DFF_X1 Y0_2xDP_reg_1__3_ ( .D(Y0_1xDP[7]), .CK(ClkxCI), .Q(Y0_2xDP[7]), 
        .QN() );
  DFF_X1 Y0_2xDP_reg_1__2_ ( .D(Y0_1xDP[6]), .CK(ClkxCI), .Q(Y0_2xDP[6]), 
        .QN() );
  DFF_X1 Y0_2xDP_reg_1__1_ ( .D(Y0_1xDP[5]), .CK(ClkxCI), .Q(Y0_2xDP[5]), 
        .QN() );
  DFF_X1 Y0_2xDP_reg_1__0_ ( .D(Y0_1xDP[4]), .CK(ClkxCI), .Q(Y0_2xDP[4]), 
        .QN() );
  DFF_X1 Y0_2xDP_reg_0__3_ ( .D(Y0_1xDP[3]), .CK(ClkxCI), .Q(Y0_2xDP[3]), 
        .QN() );
  DFF_X1 Y0_2xDP_reg_0__2_ ( .D(Y0_1xDP[2]), .CK(ClkxCI), .Q(Y0_2xDP[2]), 
        .QN() );
  DFF_X1 Y0_2xDP_reg_0__1_ ( .D(Y0_1xDP[1]), .CK(ClkxCI), .Q(Y0_2xDP[1]), 
        .QN() );
  DFF_X1 Y0_2xDP_reg_0__0_ ( .D(Y0_1xDP[0]), .CK(ClkxCI), .Q(Y0_2xDP[0]), 
        .QN() );
  DFF_X1 Y0_3xDP_reg_1__3_ ( .D(Y0_2xDP[7]), .CK(ClkxCI), .Q(Y0_3xDP[7]), 
        .QN() );
  DFF_X1 Y0_3xDP_reg_1__2_ ( .D(Y0_2xDP[6]), .CK(ClkxCI), .Q(Y0_3xDP[6]), 
        .QN() );
  DFF_X1 Y0_3xDP_reg_1__1_ ( .D(Y0_2xDP[5]), .CK(ClkxCI), .Q(Y0_3xDP[5]), 
        .QN() );
  DFF_X1 Y0_3xDP_reg_1__0_ ( .D(Y0_2xDP[4]), .CK(ClkxCI), .Q(Y0_3xDP[4]), 
        .QN() );
  DFF_X1 Y0_3xDP_reg_0__3_ ( .D(Y0_2xDP[3]), .CK(ClkxCI), .Q(Y0_3xDP[3]), 
        .QN() );
  DFF_X1 Y0_3xDP_reg_0__2_ ( .D(Y0_2xDP[2]), .CK(ClkxCI), .Q(Y0_3xDP[2]), 
        .QN() );
  DFF_X1 Y0_3xDP_reg_0__1_ ( .D(Y0_2xDP[1]), .CK(ClkxCI), .Q(Y0_3xDP[1]), 
        .QN() );
  DFF_X1 Y0_3xDP_reg_0__0_ ( .D(Y0_2xDP[0]), .CK(ClkxCI), .Q(Y0_3xDP[0]), 
        .QN() );
  DFF_X1 Y0_4xDP_reg_1__3_ ( .D(Y0_3xDP[7]), .CK(ClkxCI), .Q(Y0_4xDP[7]), 
        .QN() );
  DFF_X1 Y0_4xDP_reg_1__2_ ( .D(Y0_3xDP[6]), .CK(ClkxCI), .Q(Y0_4xDP[6]), 
        .QN() );
  DFF_X1 Y0_4xDP_reg_1__1_ ( .D(Y0_3xDP[5]), .CK(ClkxCI), .Q(Y0_4xDP[5]), 
        .QN() );
  DFF_X1 Y0_4xDP_reg_1__0_ ( .D(Y0_3xDP[4]), .CK(ClkxCI), .Q(Y0_4xDP[4]), 
        .QN() );
  DFF_X1 Y0_4xDP_reg_0__3_ ( .D(Y0_3xDP[3]), .CK(ClkxCI), .Q(Y0_4xDP[3]), 
        .QN() );
  DFF_X1 Y0_4xDP_reg_0__2_ ( .D(Y0_3xDP[2]), .CK(ClkxCI), .Q(Y0_4xDP[2]), 
        .QN() );
  DFF_X1 Y0_4xDP_reg_0__1_ ( .D(Y0_3xDP[1]), .CK(ClkxCI), .Q(Y0_4xDP[1]), 
        .QN() );
  DFF_X1 Y0_4xDP_reg_0__0_ ( .D(Y0_3xDP[0]), .CK(ClkxCI), .Q(Y0_4xDP[0]), 
        .QN() );
  DFF_X1 Y1_0xDP_reg_1__3_ ( .D(Y1xD[7]), .CK(ClkxCI), .Q(Y1_0xDP[7]), .QN()
         );
  DFF_X1 Y1_0xDP_reg_1__2_ ( .D(Y1xD[6]), .CK(ClkxCI), .Q(Y1_0xDP[6]), .QN()
         );
  DFF_X1 Y1_0xDP_reg_1__1_ ( .D(Y1xD[5]), .CK(ClkxCI), .Q(Y1_0xDP[5]), .QN()
         );
  DFF_X1 Y1_0xDP_reg_1__0_ ( .D(Y1xD[4]), .CK(ClkxCI), .Q(Y1_0xDP[4]), .QN()
         );
  DFF_X1 Y1_0xDP_reg_0__3_ ( .D(Y1xD[3]), .CK(ClkxCI), .Q(Y1_0xDP[3]), .QN()
         );
  DFF_X1 Y1_0xDP_reg_0__2_ ( .D(Y1xD[2]), .CK(ClkxCI), .Q(Y1_0xDP[2]), .QN()
         );
  DFF_X1 Y1_0xDP_reg_0__1_ ( .D(Y1xD[1]), .CK(ClkxCI), .Q(Y1_0xDP[1]), .QN()
         );
  DFF_X1 Y1_0xDP_reg_0__0_ ( .D(Y1xD[0]), .CK(ClkxCI), .Q(Y1_0xDP[0]), .QN()
         );
  DFF_X1 Y1_1xDP_reg_1__3_ ( .D(Y1_0xDP[7]), .CK(ClkxCI), .Q(Y1_1xDP[7]), 
        .QN() );
  DFF_X1 Y1_1xDP_reg_1__2_ ( .D(Y1_0xDP[6]), .CK(ClkxCI), .Q(Y1_1xDP[6]), 
        .QN() );
  DFF_X1 Y1_1xDP_reg_1__1_ ( .D(Y1_0xDP[5]), .CK(ClkxCI), .Q(Y1_1xDP[5]), 
        .QN() );
  DFF_X1 Y1_1xDP_reg_1__0_ ( .D(Y1_0xDP[4]), .CK(ClkxCI), .Q(Y1_1xDP[4]), 
        .QN() );
  DFF_X1 Y1_1xDP_reg_0__3_ ( .D(Y1_0xDP[3]), .CK(ClkxCI), .Q(Y1_1xDP[3]), 
        .QN() );
  DFF_X1 Y1_1xDP_reg_0__2_ ( .D(Y1_0xDP[2]), .CK(ClkxCI), .Q(Y1_1xDP[2]), 
        .QN() );
  DFF_X1 Y1_1xDP_reg_0__1_ ( .D(Y1_0xDP[1]), .CK(ClkxCI), .Q(Y1_1xDP[1]), 
        .QN() );
  DFF_X1 Y1_1xDP_reg_0__0_ ( .D(Y1_0xDP[0]), .CK(ClkxCI), .Q(Y1_1xDP[0]), 
        .QN() );
  DFF_X1 Y1_2xDP_reg_1__3_ ( .D(Y1_1xDP[7]), .CK(ClkxCI), .Q(Y1_2xDP[7]), 
        .QN() );
  DFF_X1 Y1_2xDP_reg_1__2_ ( .D(Y1_1xDP[6]), .CK(ClkxCI), .Q(Y1_2xDP[6]), 
        .QN() );
  DFF_X1 Y1_2xDP_reg_1__1_ ( .D(Y1_1xDP[5]), .CK(ClkxCI), .Q(Y1_2xDP[5]), 
        .QN() );
  DFF_X1 Y1_2xDP_reg_1__0_ ( .D(Y1_1xDP[4]), .CK(ClkxCI), .Q(Y1_2xDP[4]), 
        .QN() );
  DFF_X1 Y1_2xDP_reg_0__3_ ( .D(Y1_1xDP[3]), .CK(ClkxCI), .Q(Y1_2xDP[3]), 
        .QN() );
  DFF_X1 Y1_2xDP_reg_0__2_ ( .D(Y1_1xDP[2]), .CK(ClkxCI), .Q(Y1_2xDP[2]), 
        .QN() );
  DFF_X1 Y1_2xDP_reg_0__1_ ( .D(Y1_1xDP[1]), .CK(ClkxCI), .Q(Y1_2xDP[1]), 
        .QN() );
  DFF_X1 Y1_2xDP_reg_0__0_ ( .D(Y1_1xDP[0]), .CK(ClkxCI), .Q(Y1_2xDP[0]), 
        .QN() );
  DFF_X1 Y1_3xDP_reg_1__3_ ( .D(Y1_2xDP[7]), .CK(ClkxCI), .Q(Y1_3xDP[7]), 
        .QN() );
  DFF_X1 Y1_4xDP_reg_1__3_ ( .D(Y1_3xDP[7]), .CK(ClkxCI), .Q(Y1_4xDP[7]), 
        .QN() );
  DFF_X1 Y1_3xDP_reg_1__2_ ( .D(Y1_2xDP[6]), .CK(ClkxCI), .Q(Y1_3xDP[6]), 
        .QN() );
  DFF_X1 Y1_4xDP_reg_1__2_ ( .D(Y1_3xDP[6]), .CK(ClkxCI), .Q(Y1_4xDP[6]), 
        .QN() );
  DFF_X1 Y1_3xDP_reg_1__1_ ( .D(Y1_2xDP[5]), .CK(ClkxCI), .Q(Y1_3xDP[5]), 
        .QN() );
  DFF_X1 Y1_4xDP_reg_1__1_ ( .D(Y1_3xDP[5]), .CK(ClkxCI), .Q(Y1_4xDP[5]), 
        .QN() );
  DFF_X1 Y1_3xDP_reg_1__0_ ( .D(Y1_2xDP[4]), .CK(ClkxCI), .Q(Y1_3xDP[4]), 
        .QN() );
  DFF_X1 Y1_4xDP_reg_1__0_ ( .D(Y1_3xDP[4]), .CK(ClkxCI), .Q(Y1_4xDP[4]), 
        .QN() );
  DFF_X1 Y1_3xDP_reg_0__3_ ( .D(Y1_2xDP[3]), .CK(ClkxCI), .Q(Y1_3xDP[3]), 
        .QN() );
  DFF_X1 Y1_4xDP_reg_0__3_ ( .D(Y1_3xDP[3]), .CK(ClkxCI), .Q(Y1_4xDP[3]), 
        .QN() );
  DFF_X1 Y1_3xDP_reg_0__2_ ( .D(Y1_2xDP[2]), .CK(ClkxCI), .Q(Y1_3xDP[2]), 
        .QN() );
  DFF_X1 Y1_4xDP_reg_0__2_ ( .D(Y1_3xDP[2]), .CK(ClkxCI), .Q(Y1_4xDP[2]), 
        .QN() );
  DFF_X1 Y1_3xDP_reg_0__1_ ( .D(Y1_2xDP[1]), .CK(ClkxCI), .Q(Y1_3xDP[1]), 
        .QN() );
  DFF_X1 Y1_4xDP_reg_0__1_ ( .D(Y1_3xDP[1]), .CK(ClkxCI), .Q(Y1_4xDP[1]), 
        .QN() );
  DFF_X1 Y1_3xDP_reg_0__0_ ( .D(Y1_2xDP[0]), .CK(ClkxCI), .Q(Y1_3xDP[0]), 
        .QN() );
  DFF_X1 Y1_4xDP_reg_0__0_ ( .D(Y1_3xDP[0]), .CK(ClkxCI), .Q(Y1_4xDP[0]), 
        .QN() );
  XNOR2_X1 U44 ( .A(Y0mulY1xD[0]), .B(n32), .ZN(InverterInxD[0]) );
  XNOR2_X1 U45 ( .A(Y0mulY1xD[1]), .B(n31), .ZN(InverterInxD[1]) );
  XNOR2_X1 U46 ( .A(Y0mulY1xD[2]), .B(n30), .ZN(InverterInxD[2]) );
  XNOR2_X1 U47 ( .A(Y0mulY1xD[3]), .B(n29), .ZN(InverterInxD[3]) );
  XNOR2_X1 U48 ( .A(Y0mulY1xD[4]), .B(n28), .ZN(InverterInxD[4]) );
  XNOR2_X1 U49 ( .A(Y0mulY1xD[5]), .B(n27), .ZN(InverterInxD[5]) );
  XNOR2_X1 U50 ( .A(Y0mulY1xD[6]), .B(n26), .ZN(InverterInxD[6]) );
  XNOR2_X1 U51 ( .A(Y0mulY1xD[7]), .B(n25), .ZN(InverterInxD[7]) );
  XOR2_X1 U52 ( .A(n24), .B(n23), .Z(Y0xorY12xD[0]) );
  XOR2_X1 U53 ( .A(n22), .B(n21), .Z(Y0xorY1xD[0]) );
  XOR2_X1 U54 ( .A(n20), .B(n19), .Z(Y0xorY1xD[1]) );
  XOR2_X1 U55 ( .A(n18), .B(n17), .Z(Y0xorY1xD[2]) );
  XOR2_X1 U56 ( .A(n16), .B(n15), .Z(Y0xorY12xD[4]) );
  XOR2_X1 U57 ( .A(n14), .B(n13), .Z(Y0xorY1xD[3]) );
  XOR2_X1 U58 ( .A(n12), .B(n11), .Z(Y0xorY1xD[4]) );
  XOR2_X1 U59 ( .A(n10), .B(n9), .Z(Y0xorY1xD[5]) );
  INV_X1 U60 ( .A(InvMappedxD_0__6_), .ZN(QxDO[6]) );
  INV_X1 U61 ( .A(InvMappedxD_0__5_), .ZN(QxDO[5]) );
  INV_X1 U62 ( .A(InvMappedxD_0__1_), .ZN(QxDO[1]) );
  INV_X1 U63 ( .A(InvMappedxD_0__0_), .ZN(QxDO[0]) );
  XNOR2_X1 input_mapping_1_U14 ( .A(input_mapping_1_n23), .B(
        input_mapping_1_n22), .ZN(mappedxD_1__7_) );
  XOR2_X1 input_mapping_1_U13 ( .A(XxDI[12]), .B(mappedxD_1__1_), .Z(
        mappedxD_1__6_) );
  XNOR2_X1 input_mapping_1_U12 ( .A(input_mapping_1_n21), .B(
        input_mapping_1_n20), .ZN(mappedxD_1__5_) );
  XNOR2_X1 input_mapping_1_U11 ( .A(XxDI[8]), .B(input_mapping_1_n22), .ZN(
        mappedxD_1__4_) );
  XNOR2_X1 input_mapping_1_U10 ( .A(XxDI[15]), .B(input_mapping_1_n21), .ZN(
        input_mapping_1_n22) );
  XNOR2_X1 input_mapping_1_U9 ( .A(input_mapping_1_n19), .B(
        input_mapping_1_n18), .ZN(mappedxD_1__3_) );
  XNOR2_X1 input_mapping_1_U8 ( .A(input_mapping_1_n20), .B(XxDI[11]), .ZN(
        input_mapping_1_n18) );
  XNOR2_X1 input_mapping_1_U7 ( .A(XxDI[15]), .B(XxDI[12]), .ZN(
        input_mapping_1_n19) );
  XOR2_X1 input_mapping_1_U6 ( .A(XxDI[8]), .B(input_mapping_1_n21), .Z(
        mappedxD_1__1_) );
  XOR2_X1 input_mapping_1_U5 ( .A(XxDI[14]), .B(XxDI[13]), .Z(
        input_mapping_1_n21) );
  XNOR2_X1 input_mapping_1_U4 ( .A(input_mapping_1_n23), .B(
        input_mapping_1_n17), .ZN(mappedxD_1__0_) );
  XNOR2_X1 input_mapping_1_U3 ( .A(XxDI[14]), .B(XxDI[11]), .ZN(
        input_mapping_1_n17) );
  XNOR2_X1 input_mapping_1_U2 ( .A(XxDI[10]), .B(input_mapping_1_n20), .ZN(
        input_mapping_1_n23) );
  XNOR2_X1 input_mapping_1_U1 ( .A(XxDI[8]), .B(XxDI[9]), .ZN(
        input_mapping_1_n20) );
  XOR2_X1 square_scaler_gf24_1_U3 ( .A(Y0xorY12xD[4]), .B(Y0xorY1xD[4]), .Z(
        Y0xorY12xD[7]) );
  XOR2_X1 square_scaler_gf24_1_U2 ( .A(Y0xorY1xD[3]), .B(Y0xorY1xD[5]), .Z(
        Y0xorY12xD[6]) );
  XOR2_X1 square_scaler_gf24_1_U1 ( .A(Y0xorY12xD[4]), .B(Y0xorY1xD[3]), .Z(
        Y0xorY12xD[5]) );
  XOR2_X1 output_mapping_1_U11 ( .A(InvUnmappedxD[11]), .B(InvUnmappedxD[15]), 
        .Z(QxDO[14]) );
  XNOR2_X1 output_mapping_1_U10 ( .A(QxDO[12]), .B(output_mapping_1_n9), .ZN(
        QxDO[11]) );
  XOR2_X1 output_mapping_1_U9 ( .A(QxDO[15]), .B(InvUnmappedxD[15]), .Z(
        QxDO[12]) );
  XNOR2_X1 output_mapping_1_U8 ( .A(output_mapping_1_n8), .B(QxDO[13]), .ZN(
        QxDO[10]) );
  XNOR2_X1 output_mapping_1_U7 ( .A(QxDO[15]), .B(InvUnmappedxD[10]), .ZN(
        output_mapping_1_n8) );
  XOR2_X1 output_mapping_1_U6 ( .A(InvUnmappedxD[14]), .B(InvUnmappedxD[8]), 
        .Z(QxDO[13]) );
  XOR2_X1 output_mapping_1_U5 ( .A(InvUnmappedxD[11]), .B(InvUnmappedxD[13]), 
        .Z(QxDO[15]) );
  XNOR2_X1 output_mapping_1_U4 ( .A(output_mapping_1_n7), .B(InvUnmappedxD[9]), 
        .ZN(QxDO[9]) );
  XNOR2_X1 output_mapping_1_U3 ( .A(InvUnmappedxD[13]), .B(InvUnmappedxD[12]), 
        .ZN(output_mapping_1_n7) );
  XNOR2_X1 output_mapping_1_U2 ( .A(InvUnmappedxD[9]), .B(output_mapping_1_n9), 
        .ZN(QxDO[8]) );
  XNOR2_X1 output_mapping_1_U1 ( .A(InvUnmappedxD[14]), .B(InvUnmappedxD[12]), 
        .ZN(output_mapping_1_n9) );
  XNOR2_X1 input_mapping_0_U14 ( .A(input_mapping_0_n23), .B(
        input_mapping_0_n22), .ZN(mappedxD_0__7_) );
  XOR2_X1 input_mapping_0_U13 ( .A(XxDI[4]), .B(mappedxD_0__1_), .Z(
        mappedxD_0__6_) );
  XNOR2_X1 input_mapping_0_U12 ( .A(input_mapping_0_n21), .B(
        input_mapping_0_n20), .ZN(mappedxD_0__5_) );
  XNOR2_X1 input_mapping_0_U11 ( .A(XxDI[0]), .B(input_mapping_0_n22), .ZN(
        mappedxD_0__4_) );
  XNOR2_X1 input_mapping_0_U10 ( .A(XxDI[7]), .B(input_mapping_0_n21), .ZN(
        input_mapping_0_n22) );
  XNOR2_X1 input_mapping_0_U9 ( .A(input_mapping_0_n19), .B(
        input_mapping_0_n18), .ZN(mappedxD_0__3_) );
  XNOR2_X1 input_mapping_0_U8 ( .A(input_mapping_0_n20), .B(XxDI[3]), .ZN(
        input_mapping_0_n18) );
  XNOR2_X1 input_mapping_0_U7 ( .A(XxDI[7]), .B(XxDI[4]), .ZN(
        input_mapping_0_n19) );
  XOR2_X1 input_mapping_0_U6 ( .A(XxDI[0]), .B(input_mapping_0_n21), .Z(
        mappedxD_0__1_) );
  XOR2_X1 input_mapping_0_U5 ( .A(XxDI[6]), .B(XxDI[5]), .Z(
        input_mapping_0_n21) );
  XNOR2_X1 input_mapping_0_U4 ( .A(input_mapping_0_n23), .B(
        input_mapping_0_n17), .ZN(mappedxD_0__0_) );
  XNOR2_X1 input_mapping_0_U3 ( .A(XxDI[6]), .B(XxDI[3]), .ZN(
        input_mapping_0_n17) );
  XNOR2_X1 input_mapping_0_U2 ( .A(XxDI[2]), .B(input_mapping_0_n20), .ZN(
        input_mapping_0_n23) );
  XNOR2_X1 input_mapping_0_U1 ( .A(XxDI[0]), .B(XxDI[1]), .ZN(
        input_mapping_0_n20) );
  XOR2_X1 square_scaler_gf24_0_U3 ( .A(Y0xorY12xD[0]), .B(Y0xorY1xD[1]), .Z(
        Y0xorY12xD[3]) );
  XOR2_X1 square_scaler_gf24_0_U2 ( .A(Y0xorY1xD[0]), .B(Y0xorY1xD[2]), .Z(
        Y0xorY12xD[2]) );
  XOR2_X1 square_scaler_gf24_0_U1 ( .A(Y0xorY12xD[0]), .B(Y0xorY1xD[0]), .Z(
        Y0xorY12xD[1]) );
  XOR2_X1 output_mapping_0_U11 ( .A(InvUnmappedxD[3]), .B(InvUnmappedxD[7]), 
        .Z(InvMappedxD_0__6_) );
  XNOR2_X1 output_mapping_0_U10 ( .A(QxDO[4]), .B(output_mapping_0_n9), .ZN(
        QxDO[3]) );
  XOR2_X1 output_mapping_0_U9 ( .A(QxDO[7]), .B(InvUnmappedxD[7]), .Z(QxDO[4])
         );
  XNOR2_X1 output_mapping_0_U8 ( .A(output_mapping_0_n8), .B(InvMappedxD_0__5_), .ZN(QxDO[2]) );
  XNOR2_X1 output_mapping_0_U7 ( .A(QxDO[7]), .B(InvUnmappedxD[2]), .ZN(
        output_mapping_0_n8) );
  XOR2_X1 output_mapping_0_U6 ( .A(InvUnmappedxD[6]), .B(InvUnmappedxD[0]), 
        .Z(InvMappedxD_0__5_) );
  XOR2_X1 output_mapping_0_U5 ( .A(InvUnmappedxD[3]), .B(InvUnmappedxD[5]), 
        .Z(QxDO[7]) );
  XNOR2_X1 output_mapping_0_U4 ( .A(output_mapping_0_n7), .B(InvUnmappedxD[1]), 
        .ZN(InvMappedxD_0__1_) );
  XNOR2_X1 output_mapping_0_U3 ( .A(InvUnmappedxD[5]), .B(InvUnmappedxD[4]), 
        .ZN(output_mapping_0_n7) );
  XNOR2_X1 output_mapping_0_U2 ( .A(InvUnmappedxD[1]), .B(output_mapping_0_n9), 
        .ZN(InvMappedxD_0__0_) );
  XNOR2_X1 output_mapping_0_U1 ( .A(InvUnmappedxD[6]), .B(InvUnmappedxD[4]), 
        .ZN(output_mapping_0_n9) );
  XOR2_X1 mul_y0y1_U18 ( .A(mul_y0y1_n2), .B(mul_y0y1_n1), .Z(Y0mulY1xD[7]) );
  XOR2_X1 mul_y0y1_U17 ( .A(mul_y0y1_n4), .B(mul_y0y1_n3), .Z(Y0mulY1xD[6]) );
  XOR2_X1 mul_y0y1_U16 ( .A(mul_y0y1_n6), .B(mul_y0y1_n5), .Z(Y0mulY1xD[5]) );
  XOR2_X1 mul_y0y1_U15 ( .A(mul_y0y1_n8), .B(mul_y0y1_n7), .Z(Y0mulY1xD[4]) );
  XOR2_X1 mul_y0y1_U14 ( .A(mul_y0y1_n10), .B(mul_y0y1_n9), .Z(Y0mulY1xD[3])
         );
  XOR2_X1 mul_y0y1_U13 ( .A(mul_y0y1_n12), .B(mul_y0y1_n11), .Z(Y0mulY1xD[2])
         );
  XOR2_X1 mul_y0y1_U12 ( .A(mul_y0y1_n14), .B(mul_y0y1_n13), .Z(Y0mulY1xD[1])
         );
  XOR2_X1 mul_y0y1_U11 ( .A(mul_y0y1_n16), .B(mul_y0y1_n15), .Z(Y0mulY1xD[0])
         );
  XOR2_X1 mul_y0y1_U10 ( .A(Zmul1xDI[3]), .B(mul_y0y1_Xi_mul_Yj_2__3_), .Z(
        mul_y0y1_FFxDN[11]) );
  XOR2_X1 mul_y0y1_U9 ( .A(Zmul1xDI[2]), .B(mul_y0y1_Xi_mul_Yj_2__2_), .Z(
        mul_y0y1_FFxDN[10]) );
  XOR2_X1 mul_y0y1_U8 ( .A(Zmul1xDI[1]), .B(mul_y0y1_Xi_mul_Yj_2__1_), .Z(
        mul_y0y1_FFxDN[9]) );
  XOR2_X1 mul_y0y1_U7 ( .A(Zmul1xDI[0]), .B(mul_y0y1_Xi_mul_Yj_2__0_), .Z(
        mul_y0y1_FFxDN[8]) );
  XOR2_X1 mul_y0y1_U6 ( .A(Zmul1xDI[3]), .B(mul_y0y1_Xi_mul_Yj_1__3_), .Z(
        mul_y0y1_FFxDN[7]) );
  XOR2_X1 mul_y0y1_U5 ( .A(Zmul1xDI[2]), .B(mul_y0y1_Xi_mul_Yj_1__2_), .Z(
        mul_y0y1_FFxDN[6]) );
  XOR2_X1 mul_y0y1_U4 ( .A(Zmul1xDI[1]), .B(mul_y0y1_Xi_mul_Yj_1__1_), .Z(
        mul_y0y1_FFxDN[5]) );
  XOR2_X1 mul_y0y1_U3 ( .A(Zmul1xDI[0]), .B(mul_y0y1_Xi_mul_Yj_1__0_), .Z(
        mul_y0y1_FFxDN[4]) );
  DFF_X1 mul_y0y1_FFxDP_reg_1__1_ ( .D(mul_y0y1_FFxDN[5]), .CK(ClkxCI), .Q(), 
        .QN(mul_y0y1_n14) );
  DFF_X1 mul_y0y1_FFxDP_reg_1__3_ ( .D(mul_y0y1_FFxDN[7]), .CK(ClkxCI), .Q(), 
        .QN(mul_y0y1_n10) );
  DFF_X1 mul_y0y1_FFxDP_reg_2__1_ ( .D(mul_y0y1_FFxDN[9]), .CK(ClkxCI), .Q(), 
        .QN(mul_y0y1_n5) );
  DFF_X1 mul_y0y1_FFxDP_reg_2__3_ ( .D(mul_y0y1_FFxDN[11]), .CK(ClkxCI), .Q(), 
        .QN(mul_y0y1_n1) );
  DFF_X1 mul_y0y1_FFxDP_reg_1__0_ ( .D(mul_y0y1_FFxDN[4]), .CK(ClkxCI), .Q(), 
        .QN(mul_y0y1_n16) );
  DFF_X1 mul_y0y1_FFxDP_reg_1__2_ ( .D(mul_y0y1_FFxDN[6]), .CK(ClkxCI), .Q(), 
        .QN(mul_y0y1_n12) );
  DFF_X1 mul_y0y1_FFxDP_reg_2__0_ ( .D(mul_y0y1_FFxDN[8]), .CK(ClkxCI), .Q(), 
        .QN(mul_y0y1_n7) );
  DFF_X1 mul_y0y1_FFxDP_reg_2__2_ ( .D(mul_y0y1_FFxDN[10]), .CK(ClkxCI), .Q(), 
        .QN(mul_y0y1_n3) );
  DFF_X1 mul_y0y1_FFxDP_reg_0__1_ ( .D(mul_y0y1_FFxDN[1]), .CK(ClkxCI), .Q(), 
        .QN(mul_y0y1_n13) );
  DFF_X1 mul_y0y1_FFxDP_reg_0__3_ ( .D(mul_y0y1_FFxDN[3]), .CK(ClkxCI), .Q(), 
        .QN(mul_y0y1_n9) );
  DFF_X1 mul_y0y1_FFxDP_reg_3__1_ ( .D(mul_y0y1_FFxDN[13]), .CK(ClkxCI), .Q(), 
        .QN(mul_y0y1_n6) );
  DFF_X1 mul_y0y1_FFxDP_reg_3__3_ ( .D(mul_y0y1_FFxDN[15]), .CK(ClkxCI), .Q(), 
        .QN(mul_y0y1_n2) );
  DFF_X1 mul_y0y1_FFxDP_reg_0__2_ ( .D(mul_y0y1_FFxDN[2]), .CK(ClkxCI), .Q(), 
        .QN(mul_y0y1_n11) );
  DFF_X1 mul_y0y1_FFxDP_reg_3__2_ ( .D(mul_y0y1_FFxDN[14]), .CK(ClkxCI), .Q(), 
        .QN(mul_y0y1_n4) );
  DFF_X1 mul_y0y1_FFxDP_reg_0__0_ ( .D(mul_y0y1_FFxDN[0]), .CK(ClkxCI), .Q(), 
        .QN(mul_y0y1_n15) );
  DFF_X1 mul_y0y1_FFxDP_reg_3__0_ ( .D(mul_y0y1_FFxDN[12]), .CK(ClkxCI), .Q(), 
        .QN(mul_y0y1_n8) );
  XNOR2_X1 mul_y0y1_gf4_mul_1_1_U29 ( .A(mul_y0y1_gf4_mul_1_1_n77), .B(
        mul_y0y1_gf4_mul_1_1_n76), .ZN(mul_y0y1_FFxDN[15]) );
  NAND2_X1 mul_y0y1_gf4_mul_1_1_U28 ( .A1(Y1xD[7]), .A2(Y0xD[7]), .ZN(
        mul_y0y1_gf4_mul_1_1_n76) );
  XOR2_X1 mul_y0y1_gf4_mul_1_1_U27 ( .A(mul_y0y1_gf4_mul_1_1_n75), .B(
        mul_y0y1_gf4_mul_1_1_n74), .Z(mul_y0y1_gf4_mul_1_1_n77) );
  XNOR2_X1 mul_y0y1_gf4_mul_1_1_U26 ( .A(mul_y0y1_gf4_mul_1_1_n73), .B(
        mul_y0y1_gf4_mul_1_1_n72), .ZN(mul_y0y1_FFxDN[14]) );
  NAND2_X1 mul_y0y1_gf4_mul_1_1_U25 ( .A1(Y1xD[6]), .A2(Y0xD[6]), .ZN(
        mul_y0y1_gf4_mul_1_1_n72) );
  XOR2_X1 mul_y0y1_gf4_mul_1_1_U24 ( .A(mul_y0y1_gf4_mul_1_1_n74), .B(
        mul_y0y1_gf4_mul_1_1_n71), .Z(mul_y0y1_gf4_mul_1_1_n73) );
  NOR2_X1 mul_y0y1_gf4_mul_1_1_U23 ( .A1(mul_y0y1_gf4_mul_1_1_n70), .A2(
        mul_y0y1_gf4_mul_1_1_n69), .ZN(mul_y0y1_gf4_mul_1_1_n74) );
  XNOR2_X1 mul_y0y1_gf4_mul_1_1_U22 ( .A(Y1xD[6]), .B(Y1xD[7]), .ZN(
        mul_y0y1_gf4_mul_1_1_n69) );
  XNOR2_X1 mul_y0y1_gf4_mul_1_1_U21 ( .A(Y0xD[6]), .B(Y0xD[7]), .ZN(
        mul_y0y1_gf4_mul_1_1_n70) );
  XNOR2_X1 mul_y0y1_gf4_mul_1_1_U20 ( .A(mul_y0y1_gf4_mul_1_1_n68), .B(
        mul_y0y1_gf4_mul_1_1_n67), .ZN(mul_y0y1_FFxDN[13]) );
  NAND2_X1 mul_y0y1_gf4_mul_1_1_U19 ( .A1(Y1xD[5]), .A2(Y0xD[5]), .ZN(
        mul_y0y1_gf4_mul_1_1_n67) );
  XOR2_X1 mul_y0y1_gf4_mul_1_1_U18 ( .A(mul_y0y1_gf4_mul_1_1_n75), .B(
        mul_y0y1_gf4_mul_1_1_n66), .Z(mul_y0y1_gf4_mul_1_1_n68) );
  XNOR2_X1 mul_y0y1_gf4_mul_1_1_U17 ( .A(mul_y0y1_gf4_mul_1_1_n65), .B(
        mul_y0y1_gf4_mul_1_1_n64), .ZN(mul_y0y1_gf4_mul_1_1_n75) );
  NAND2_X1 mul_y0y1_gf4_mul_1_1_U16 ( .A1(mul_y0y1_gf4_mul_1_1_n63), .A2(
        mul_y0y1_gf4_mul_1_1_n62), .ZN(mul_y0y1_gf4_mul_1_1_n64) );
  XNOR2_X1 mul_y0y1_gf4_mul_1_1_U15 ( .A(mul_y0y1_gf4_mul_1_1_n61), .B(
        mul_y0y1_gf4_mul_1_1_n60), .ZN(mul_y0y1_gf4_mul_1_1_n62) );
  XNOR2_X1 mul_y0y1_gf4_mul_1_1_U14 ( .A(mul_y0y1_gf4_mul_1_1_n59), .B(
        mul_y0y1_gf4_mul_1_1_n58), .ZN(mul_y0y1_gf4_mul_1_1_n63) );
  XNOR2_X1 mul_y0y1_gf4_mul_1_1_U13 ( .A(mul_y0y1_gf4_mul_1_1_n57), .B(
        mul_y0y1_gf4_mul_1_1_n56), .ZN(mul_y0y1_FFxDN[12]) );
  NAND2_X1 mul_y0y1_gf4_mul_1_1_U12 ( .A1(Y1xD[4]), .A2(Y0xD[4]), .ZN(
        mul_y0y1_gf4_mul_1_1_n56) );
  XOR2_X1 mul_y0y1_gf4_mul_1_1_U11 ( .A(mul_y0y1_gf4_mul_1_1_n66), .B(
        mul_y0y1_gf4_mul_1_1_n71), .Z(mul_y0y1_gf4_mul_1_1_n57) );
  XNOR2_X1 mul_y0y1_gf4_mul_1_1_U10 ( .A(mul_y0y1_gf4_mul_1_1_n55), .B(
        mul_y0y1_gf4_mul_1_1_n65), .ZN(mul_y0y1_gf4_mul_1_1_n71) );
  NOR2_X1 mul_y0y1_gf4_mul_1_1_U9 ( .A1(mul_y0y1_gf4_mul_1_1_n61), .A2(
        mul_y0y1_gf4_mul_1_1_n59), .ZN(mul_y0y1_gf4_mul_1_1_n65) );
  XNOR2_X1 mul_y0y1_gf4_mul_1_1_U8 ( .A(Y1xD[4]), .B(Y1xD[6]), .ZN(
        mul_y0y1_gf4_mul_1_1_n59) );
  XNOR2_X1 mul_y0y1_gf4_mul_1_1_U7 ( .A(Y0xD[4]), .B(Y0xD[6]), .ZN(
        mul_y0y1_gf4_mul_1_1_n61) );
  NAND2_X1 mul_y0y1_gf4_mul_1_1_U6 ( .A1(mul_y0y1_gf4_mul_1_1_n58), .A2(
        mul_y0y1_gf4_mul_1_1_n60), .ZN(mul_y0y1_gf4_mul_1_1_n55) );
  XOR2_X1 mul_y0y1_gf4_mul_1_1_U5 ( .A(Y0xD[5]), .B(Y0xD[7]), .Z(
        mul_y0y1_gf4_mul_1_1_n60) );
  XOR2_X1 mul_y0y1_gf4_mul_1_1_U4 ( .A(Y1xD[5]), .B(Y1xD[7]), .Z(
        mul_y0y1_gf4_mul_1_1_n58) );
  NOR2_X1 mul_y0y1_gf4_mul_1_1_U3 ( .A1(mul_y0y1_gf4_mul_1_1_n54), .A2(
        mul_y0y1_gf4_mul_1_1_n53), .ZN(mul_y0y1_gf4_mul_1_1_n66) );
  XNOR2_X1 mul_y0y1_gf4_mul_1_1_U2 ( .A(Y1xD[4]), .B(Y1xD[5]), .ZN(
        mul_y0y1_gf4_mul_1_1_n53) );
  XNOR2_X1 mul_y0y1_gf4_mul_1_1_U1 ( .A(Y0xD[4]), .B(Y0xD[5]), .ZN(
        mul_y0y1_gf4_mul_1_1_n54) );
  XNOR2_X1 mul_y0y1_gf4_mul_1_0_U29 ( .A(mul_y0y1_gf4_mul_1_0_n77), .B(
        mul_y0y1_gf4_mul_1_0_n76), .ZN(mul_y0y1_Xi_mul_Yj_2__3_) );
  NAND2_X1 mul_y0y1_gf4_mul_1_0_U28 ( .A1(Y1xD[7]), .A2(Y0xD[3]), .ZN(
        mul_y0y1_gf4_mul_1_0_n76) );
  XOR2_X1 mul_y0y1_gf4_mul_1_0_U27 ( .A(mul_y0y1_gf4_mul_1_0_n75), .B(
        mul_y0y1_gf4_mul_1_0_n74), .Z(mul_y0y1_gf4_mul_1_0_n77) );
  XNOR2_X1 mul_y0y1_gf4_mul_1_0_U26 ( .A(mul_y0y1_gf4_mul_1_0_n73), .B(
        mul_y0y1_gf4_mul_1_0_n72), .ZN(mul_y0y1_Xi_mul_Yj_2__2_) );
  NAND2_X1 mul_y0y1_gf4_mul_1_0_U25 ( .A1(Y1xD[6]), .A2(Y0xD[2]), .ZN(
        mul_y0y1_gf4_mul_1_0_n72) );
  XOR2_X1 mul_y0y1_gf4_mul_1_0_U24 ( .A(mul_y0y1_gf4_mul_1_0_n74), .B(
        mul_y0y1_gf4_mul_1_0_n71), .Z(mul_y0y1_gf4_mul_1_0_n73) );
  NOR2_X1 mul_y0y1_gf4_mul_1_0_U23 ( .A1(mul_y0y1_gf4_mul_1_0_n70), .A2(
        mul_y0y1_gf4_mul_1_0_n69), .ZN(mul_y0y1_gf4_mul_1_0_n74) );
  XNOR2_X1 mul_y0y1_gf4_mul_1_0_U22 ( .A(Y1xD[6]), .B(Y1xD[7]), .ZN(
        mul_y0y1_gf4_mul_1_0_n69) );
  XNOR2_X1 mul_y0y1_gf4_mul_1_0_U21 ( .A(Y0xD[2]), .B(Y0xD[3]), .ZN(
        mul_y0y1_gf4_mul_1_0_n70) );
  XNOR2_X1 mul_y0y1_gf4_mul_1_0_U20 ( .A(mul_y0y1_gf4_mul_1_0_n68), .B(
        mul_y0y1_gf4_mul_1_0_n67), .ZN(mul_y0y1_Xi_mul_Yj_2__1_) );
  NAND2_X1 mul_y0y1_gf4_mul_1_0_U19 ( .A1(Y1xD[5]), .A2(Y0xD[1]), .ZN(
        mul_y0y1_gf4_mul_1_0_n67) );
  XOR2_X1 mul_y0y1_gf4_mul_1_0_U18 ( .A(mul_y0y1_gf4_mul_1_0_n75), .B(
        mul_y0y1_gf4_mul_1_0_n66), .Z(mul_y0y1_gf4_mul_1_0_n68) );
  XNOR2_X1 mul_y0y1_gf4_mul_1_0_U17 ( .A(mul_y0y1_gf4_mul_1_0_n65), .B(
        mul_y0y1_gf4_mul_1_0_n64), .ZN(mul_y0y1_gf4_mul_1_0_n75) );
  NAND2_X1 mul_y0y1_gf4_mul_1_0_U16 ( .A1(mul_y0y1_gf4_mul_1_0_n63), .A2(
        mul_y0y1_gf4_mul_1_0_n62), .ZN(mul_y0y1_gf4_mul_1_0_n64) );
  XNOR2_X1 mul_y0y1_gf4_mul_1_0_U15 ( .A(mul_y0y1_gf4_mul_1_0_n61), .B(
        mul_y0y1_gf4_mul_1_0_n60), .ZN(mul_y0y1_gf4_mul_1_0_n62) );
  XNOR2_X1 mul_y0y1_gf4_mul_1_0_U14 ( .A(mul_y0y1_gf4_mul_1_0_n59), .B(
        mul_y0y1_gf4_mul_1_0_n58), .ZN(mul_y0y1_gf4_mul_1_0_n63) );
  XNOR2_X1 mul_y0y1_gf4_mul_1_0_U13 ( .A(mul_y0y1_gf4_mul_1_0_n57), .B(
        mul_y0y1_gf4_mul_1_0_n56), .ZN(mul_y0y1_Xi_mul_Yj_2__0_) );
  NAND2_X1 mul_y0y1_gf4_mul_1_0_U12 ( .A1(Y1xD[4]), .A2(Y0xD[0]), .ZN(
        mul_y0y1_gf4_mul_1_0_n56) );
  XOR2_X1 mul_y0y1_gf4_mul_1_0_U11 ( .A(mul_y0y1_gf4_mul_1_0_n66), .B(
        mul_y0y1_gf4_mul_1_0_n71), .Z(mul_y0y1_gf4_mul_1_0_n57) );
  XNOR2_X1 mul_y0y1_gf4_mul_1_0_U10 ( .A(mul_y0y1_gf4_mul_1_0_n55), .B(
        mul_y0y1_gf4_mul_1_0_n65), .ZN(mul_y0y1_gf4_mul_1_0_n71) );
  NOR2_X1 mul_y0y1_gf4_mul_1_0_U9 ( .A1(mul_y0y1_gf4_mul_1_0_n61), .A2(
        mul_y0y1_gf4_mul_1_0_n59), .ZN(mul_y0y1_gf4_mul_1_0_n65) );
  XNOR2_X1 mul_y0y1_gf4_mul_1_0_U8 ( .A(Y1xD[4]), .B(Y1xD[6]), .ZN(
        mul_y0y1_gf4_mul_1_0_n59) );
  XNOR2_X1 mul_y0y1_gf4_mul_1_0_U7 ( .A(Y0xD[0]), .B(Y0xD[2]), .ZN(
        mul_y0y1_gf4_mul_1_0_n61) );
  NAND2_X1 mul_y0y1_gf4_mul_1_0_U6 ( .A1(mul_y0y1_gf4_mul_1_0_n58), .A2(
        mul_y0y1_gf4_mul_1_0_n60), .ZN(mul_y0y1_gf4_mul_1_0_n55) );
  XOR2_X1 mul_y0y1_gf4_mul_1_0_U5 ( .A(Y0xD[1]), .B(Y0xD[3]), .Z(
        mul_y0y1_gf4_mul_1_0_n60) );
  XOR2_X1 mul_y0y1_gf4_mul_1_0_U4 ( .A(Y1xD[5]), .B(Y1xD[7]), .Z(
        mul_y0y1_gf4_mul_1_0_n58) );
  NOR2_X1 mul_y0y1_gf4_mul_1_0_U3 ( .A1(mul_y0y1_gf4_mul_1_0_n54), .A2(
        mul_y0y1_gf4_mul_1_0_n53), .ZN(mul_y0y1_gf4_mul_1_0_n66) );
  XNOR2_X1 mul_y0y1_gf4_mul_1_0_U2 ( .A(Y1xD[4]), .B(Y1xD[5]), .ZN(
        mul_y0y1_gf4_mul_1_0_n53) );
  XNOR2_X1 mul_y0y1_gf4_mul_1_0_U1 ( .A(Y0xD[0]), .B(Y0xD[1]), .ZN(
        mul_y0y1_gf4_mul_1_0_n54) );
  XNOR2_X1 mul_y0y1_gf4_mul_0_1_U29 ( .A(mul_y0y1_gf4_mul_0_1_n77), .B(
        mul_y0y1_gf4_mul_0_1_n76), .ZN(mul_y0y1_Xi_mul_Yj_1__3_) );
  NAND2_X1 mul_y0y1_gf4_mul_0_1_U28 ( .A1(Y1xD[3]), .A2(Y0xD[7]), .ZN(
        mul_y0y1_gf4_mul_0_1_n76) );
  XOR2_X1 mul_y0y1_gf4_mul_0_1_U27 ( .A(mul_y0y1_gf4_mul_0_1_n75), .B(
        mul_y0y1_gf4_mul_0_1_n74), .Z(mul_y0y1_gf4_mul_0_1_n77) );
  XNOR2_X1 mul_y0y1_gf4_mul_0_1_U26 ( .A(mul_y0y1_gf4_mul_0_1_n73), .B(
        mul_y0y1_gf4_mul_0_1_n72), .ZN(mul_y0y1_Xi_mul_Yj_1__2_) );
  NAND2_X1 mul_y0y1_gf4_mul_0_1_U25 ( .A1(Y1xD[2]), .A2(Y0xD[6]), .ZN(
        mul_y0y1_gf4_mul_0_1_n72) );
  XOR2_X1 mul_y0y1_gf4_mul_0_1_U24 ( .A(mul_y0y1_gf4_mul_0_1_n74), .B(
        mul_y0y1_gf4_mul_0_1_n71), .Z(mul_y0y1_gf4_mul_0_1_n73) );
  NOR2_X1 mul_y0y1_gf4_mul_0_1_U23 ( .A1(mul_y0y1_gf4_mul_0_1_n70), .A2(
        mul_y0y1_gf4_mul_0_1_n69), .ZN(mul_y0y1_gf4_mul_0_1_n74) );
  XNOR2_X1 mul_y0y1_gf4_mul_0_1_U22 ( .A(Y1xD[2]), .B(Y1xD[3]), .ZN(
        mul_y0y1_gf4_mul_0_1_n69) );
  XNOR2_X1 mul_y0y1_gf4_mul_0_1_U21 ( .A(Y0xD[6]), .B(Y0xD[7]), .ZN(
        mul_y0y1_gf4_mul_0_1_n70) );
  XNOR2_X1 mul_y0y1_gf4_mul_0_1_U20 ( .A(mul_y0y1_gf4_mul_0_1_n68), .B(
        mul_y0y1_gf4_mul_0_1_n67), .ZN(mul_y0y1_Xi_mul_Yj_1__1_) );
  NAND2_X1 mul_y0y1_gf4_mul_0_1_U19 ( .A1(Y1xD[1]), .A2(Y0xD[5]), .ZN(
        mul_y0y1_gf4_mul_0_1_n67) );
  XOR2_X1 mul_y0y1_gf4_mul_0_1_U18 ( .A(mul_y0y1_gf4_mul_0_1_n75), .B(
        mul_y0y1_gf4_mul_0_1_n66), .Z(mul_y0y1_gf4_mul_0_1_n68) );
  XNOR2_X1 mul_y0y1_gf4_mul_0_1_U17 ( .A(mul_y0y1_gf4_mul_0_1_n65), .B(
        mul_y0y1_gf4_mul_0_1_n64), .ZN(mul_y0y1_gf4_mul_0_1_n75) );
  NAND2_X1 mul_y0y1_gf4_mul_0_1_U16 ( .A1(mul_y0y1_gf4_mul_0_1_n63), .A2(
        mul_y0y1_gf4_mul_0_1_n62), .ZN(mul_y0y1_gf4_mul_0_1_n64) );
  XNOR2_X1 mul_y0y1_gf4_mul_0_1_U15 ( .A(mul_y0y1_gf4_mul_0_1_n61), .B(
        mul_y0y1_gf4_mul_0_1_n60), .ZN(mul_y0y1_gf4_mul_0_1_n62) );
  XNOR2_X1 mul_y0y1_gf4_mul_0_1_U14 ( .A(mul_y0y1_gf4_mul_0_1_n59), .B(
        mul_y0y1_gf4_mul_0_1_n58), .ZN(mul_y0y1_gf4_mul_0_1_n63) );
  XNOR2_X1 mul_y0y1_gf4_mul_0_1_U13 ( .A(mul_y0y1_gf4_mul_0_1_n57), .B(
        mul_y0y1_gf4_mul_0_1_n56), .ZN(mul_y0y1_Xi_mul_Yj_1__0_) );
  NAND2_X1 mul_y0y1_gf4_mul_0_1_U12 ( .A1(Y1xD[0]), .A2(Y0xD[4]), .ZN(
        mul_y0y1_gf4_mul_0_1_n56) );
  XOR2_X1 mul_y0y1_gf4_mul_0_1_U11 ( .A(mul_y0y1_gf4_mul_0_1_n66), .B(
        mul_y0y1_gf4_mul_0_1_n71), .Z(mul_y0y1_gf4_mul_0_1_n57) );
  XNOR2_X1 mul_y0y1_gf4_mul_0_1_U10 ( .A(mul_y0y1_gf4_mul_0_1_n55), .B(
        mul_y0y1_gf4_mul_0_1_n65), .ZN(mul_y0y1_gf4_mul_0_1_n71) );
  NOR2_X1 mul_y0y1_gf4_mul_0_1_U9 ( .A1(mul_y0y1_gf4_mul_0_1_n61), .A2(
        mul_y0y1_gf4_mul_0_1_n59), .ZN(mul_y0y1_gf4_mul_0_1_n65) );
  XNOR2_X1 mul_y0y1_gf4_mul_0_1_U8 ( .A(Y1xD[0]), .B(Y1xD[2]), .ZN(
        mul_y0y1_gf4_mul_0_1_n59) );
  XNOR2_X1 mul_y0y1_gf4_mul_0_1_U7 ( .A(Y0xD[4]), .B(Y0xD[6]), .ZN(
        mul_y0y1_gf4_mul_0_1_n61) );
  NAND2_X1 mul_y0y1_gf4_mul_0_1_U6 ( .A1(mul_y0y1_gf4_mul_0_1_n58), .A2(
        mul_y0y1_gf4_mul_0_1_n60), .ZN(mul_y0y1_gf4_mul_0_1_n55) );
  XOR2_X1 mul_y0y1_gf4_mul_0_1_U5 ( .A(Y0xD[5]), .B(Y0xD[7]), .Z(
        mul_y0y1_gf4_mul_0_1_n60) );
  XOR2_X1 mul_y0y1_gf4_mul_0_1_U4 ( .A(Y1xD[1]), .B(Y1xD[3]), .Z(
        mul_y0y1_gf4_mul_0_1_n58) );
  NOR2_X1 mul_y0y1_gf4_mul_0_1_U3 ( .A1(mul_y0y1_gf4_mul_0_1_n54), .A2(
        mul_y0y1_gf4_mul_0_1_n53), .ZN(mul_y0y1_gf4_mul_0_1_n66) );
  XNOR2_X1 mul_y0y1_gf4_mul_0_1_U2 ( .A(Y1xD[0]), .B(Y1xD[1]), .ZN(
        mul_y0y1_gf4_mul_0_1_n53) );
  XNOR2_X1 mul_y0y1_gf4_mul_0_1_U1 ( .A(Y0xD[4]), .B(Y0xD[5]), .ZN(
        mul_y0y1_gf4_mul_0_1_n54) );
  XNOR2_X1 mul_y0y1_gf4_mul_0_0_U29 ( .A(mul_y0y1_gf4_mul_0_0_n77), .B(
        mul_y0y1_gf4_mul_0_0_n76), .ZN(mul_y0y1_FFxDN[3]) );
  NAND2_X1 mul_y0y1_gf4_mul_0_0_U28 ( .A1(Y1xD[3]), .A2(Y0xD[3]), .ZN(
        mul_y0y1_gf4_mul_0_0_n76) );
  XOR2_X1 mul_y0y1_gf4_mul_0_0_U27 ( .A(mul_y0y1_gf4_mul_0_0_n75), .B(
        mul_y0y1_gf4_mul_0_0_n74), .Z(mul_y0y1_gf4_mul_0_0_n77) );
  XNOR2_X1 mul_y0y1_gf4_mul_0_0_U26 ( .A(mul_y0y1_gf4_mul_0_0_n73), .B(
        mul_y0y1_gf4_mul_0_0_n72), .ZN(mul_y0y1_FFxDN[2]) );
  NAND2_X1 mul_y0y1_gf4_mul_0_0_U25 ( .A1(Y1xD[2]), .A2(Y0xD[2]), .ZN(
        mul_y0y1_gf4_mul_0_0_n72) );
  XOR2_X1 mul_y0y1_gf4_mul_0_0_U24 ( .A(mul_y0y1_gf4_mul_0_0_n74), .B(
        mul_y0y1_gf4_mul_0_0_n71), .Z(mul_y0y1_gf4_mul_0_0_n73) );
  NOR2_X1 mul_y0y1_gf4_mul_0_0_U23 ( .A1(mul_y0y1_gf4_mul_0_0_n70), .A2(
        mul_y0y1_gf4_mul_0_0_n69), .ZN(mul_y0y1_gf4_mul_0_0_n74) );
  XNOR2_X1 mul_y0y1_gf4_mul_0_0_U22 ( .A(Y1xD[2]), .B(Y1xD[3]), .ZN(
        mul_y0y1_gf4_mul_0_0_n69) );
  XNOR2_X1 mul_y0y1_gf4_mul_0_0_U21 ( .A(Y0xD[2]), .B(Y0xD[3]), .ZN(
        mul_y0y1_gf4_mul_0_0_n70) );
  XNOR2_X1 mul_y0y1_gf4_mul_0_0_U20 ( .A(mul_y0y1_gf4_mul_0_0_n68), .B(
        mul_y0y1_gf4_mul_0_0_n67), .ZN(mul_y0y1_FFxDN[1]) );
  NAND2_X1 mul_y0y1_gf4_mul_0_0_U19 ( .A1(Y1xD[1]), .A2(Y0xD[1]), .ZN(
        mul_y0y1_gf4_mul_0_0_n67) );
  XOR2_X1 mul_y0y1_gf4_mul_0_0_U18 ( .A(mul_y0y1_gf4_mul_0_0_n75), .B(
        mul_y0y1_gf4_mul_0_0_n66), .Z(mul_y0y1_gf4_mul_0_0_n68) );
  XNOR2_X1 mul_y0y1_gf4_mul_0_0_U17 ( .A(mul_y0y1_gf4_mul_0_0_n65), .B(
        mul_y0y1_gf4_mul_0_0_n64), .ZN(mul_y0y1_gf4_mul_0_0_n75) );
  NAND2_X1 mul_y0y1_gf4_mul_0_0_U16 ( .A1(mul_y0y1_gf4_mul_0_0_n63), .A2(
        mul_y0y1_gf4_mul_0_0_n62), .ZN(mul_y0y1_gf4_mul_0_0_n64) );
  XNOR2_X1 mul_y0y1_gf4_mul_0_0_U15 ( .A(mul_y0y1_gf4_mul_0_0_n61), .B(
        mul_y0y1_gf4_mul_0_0_n60), .ZN(mul_y0y1_gf4_mul_0_0_n62) );
  XNOR2_X1 mul_y0y1_gf4_mul_0_0_U14 ( .A(mul_y0y1_gf4_mul_0_0_n59), .B(
        mul_y0y1_gf4_mul_0_0_n58), .ZN(mul_y0y1_gf4_mul_0_0_n63) );
  XNOR2_X1 mul_y0y1_gf4_mul_0_0_U13 ( .A(mul_y0y1_gf4_mul_0_0_n57), .B(
        mul_y0y1_gf4_mul_0_0_n56), .ZN(mul_y0y1_FFxDN[0]) );
  NAND2_X1 mul_y0y1_gf4_mul_0_0_U12 ( .A1(Y1xD[0]), .A2(Y0xD[0]), .ZN(
        mul_y0y1_gf4_mul_0_0_n56) );
  XOR2_X1 mul_y0y1_gf4_mul_0_0_U11 ( .A(mul_y0y1_gf4_mul_0_0_n66), .B(
        mul_y0y1_gf4_mul_0_0_n71), .Z(mul_y0y1_gf4_mul_0_0_n57) );
  XNOR2_X1 mul_y0y1_gf4_mul_0_0_U10 ( .A(mul_y0y1_gf4_mul_0_0_n55), .B(
        mul_y0y1_gf4_mul_0_0_n65), .ZN(mul_y0y1_gf4_mul_0_0_n71) );
  NOR2_X1 mul_y0y1_gf4_mul_0_0_U9 ( .A1(mul_y0y1_gf4_mul_0_0_n61), .A2(
        mul_y0y1_gf4_mul_0_0_n59), .ZN(mul_y0y1_gf4_mul_0_0_n65) );
  XNOR2_X1 mul_y0y1_gf4_mul_0_0_U8 ( .A(Y1xD[0]), .B(Y1xD[2]), .ZN(
        mul_y0y1_gf4_mul_0_0_n59) );
  XNOR2_X1 mul_y0y1_gf4_mul_0_0_U7 ( .A(Y0xD[0]), .B(Y0xD[2]), .ZN(
        mul_y0y1_gf4_mul_0_0_n61) );
  NAND2_X1 mul_y0y1_gf4_mul_0_0_U6 ( .A1(mul_y0y1_gf4_mul_0_0_n58), .A2(
        mul_y0y1_gf4_mul_0_0_n60), .ZN(mul_y0y1_gf4_mul_0_0_n55) );
  XOR2_X1 mul_y0y1_gf4_mul_0_0_U5 ( .A(Y0xD[1]), .B(Y0xD[3]), .Z(
        mul_y0y1_gf4_mul_0_0_n60) );
  XOR2_X1 mul_y0y1_gf4_mul_0_0_U4 ( .A(Y1xD[1]), .B(Y1xD[3]), .Z(
        mul_y0y1_gf4_mul_0_0_n58) );
  NOR2_X1 mul_y0y1_gf4_mul_0_0_U3 ( .A1(mul_y0y1_gf4_mul_0_0_n54), .A2(
        mul_y0y1_gf4_mul_0_0_n53), .ZN(mul_y0y1_gf4_mul_0_0_n66) );
  XNOR2_X1 mul_y0y1_gf4_mul_0_0_U2 ( .A(Y1xD[0]), .B(Y1xD[1]), .ZN(
        mul_y0y1_gf4_mul_0_0_n53) );
  XNOR2_X1 mul_y0y1_gf4_mul_0_0_U1 ( .A(Y0xD[0]), .B(Y0xD[1]), .ZN(
        mul_y0y1_gf4_mul_0_0_n54) );
  XNOR2_X1 inverter_gf24_U13 ( .A(inverter_gf24_n2), .B(InverterInxDP[6]), 
        .ZN(inverter_gf24_n7) );
  XNOR2_X1 inverter_gf24_U12 ( .A(inverter_gf24_d_1__0_), .B(InverterInxDP[4]), 
        .ZN(inverter_gf24_n2) );
  XNOR2_X1 inverter_gf24_U11 ( .A(inverter_gf24_n1), .B(InverterInxDP[2]), 
        .ZN(inverter_gf24_n8) );
  XNOR2_X1 inverter_gf24_U10 ( .A(inverter_gf24_d_0__0_), .B(InverterInxDP[0]), 
        .ZN(inverter_gf24_n1) );
  XOR2_X1 inverter_gf24_U9 ( .A(InverterInxDP[5]), .B(InverterInxDP[7]), .Z(
        inverter_gf24_d_1__0_) );
  XOR2_X1 inverter_gf24_U8 ( .A(InverterInxDP[1]), .B(InverterInxDP[3]), .Z(
        inverter_gf24_d_0__0_) );
  XNOR2_X1 inverter_gf24_U7 ( .A(inverter_gf24_AmulBxD[2]), .B(
        inverter_gf24_n3), .ZN(inverter_gf24_ExD[3]) );
  XNOR2_X1 inverter_gf24_U6 ( .A(inverter_gf24_AmulBxD[3]), .B(
        inverter_gf24_n4), .ZN(inverter_gf24_ExD[2]) );
  XNOR2_X1 inverter_gf24_U5 ( .A(inverter_gf24_AmulBxD[0]), .B(
        inverter_gf24_n5), .ZN(inverter_gf24_ExD[1]) );
  XNOR2_X1 inverter_gf24_U4 ( .A(inverter_gf24_AmulBxD[1]), .B(
        inverter_gf24_n6), .ZN(inverter_gf24_ExD[0]) );
  DFF_X1 inverter_gf24_CxDP_reg_0__0_ ( .D(inverter_gf24_n8), .CK(ClkxCI), 
        .Q(), .QN(inverter_gf24_n5) );
  DFF_X1 inverter_gf24_CxDP_reg_1__0_ ( .D(inverter_gf24_n7), .CK(ClkxCI), 
        .Q(), .QN(inverter_gf24_n3) );
  DFF_X1 inverter_gf24_CxDP_reg_0__1_ ( .D(inverter_gf24_d_0__0_), .CK(ClkxCI), 
        .Q(), .QN(inverter_gf24_n6) );
  DFF_X1 inverter_gf24_CxDP_reg_1__1_ ( .D(inverter_gf24_d_1__0_), .CK(ClkxCI), 
        .Q(), .QN(inverter_gf24_n4) );
  DFF_X1 inverter_gf24_ExDP_reg_0__0_ ( .D(inverter_gf24_ExD[0]), .CK(ClkxCI), 
        .Q(inverter_gf24_ExDP_0__0_), .QN() );
  DFF_X1 inverter_gf24_ExDP_reg_0__1_ ( .D(inverter_gf24_ExD[1]), .CK(ClkxCI), 
        .Q(inverter_gf24_ExDP_0__1_), .QN() );
  DFF_X1 inverter_gf24_ExDP_reg_1__0_ ( .D(inverter_gf24_ExD[2]), .CK(ClkxCI), 
        .Q(inverter_gf24_ExDP_1__0_), .QN() );
  DFF_X1 inverter_gf24_ExDP_reg_1__1_ ( .D(inverter_gf24_ExD[3]), .CK(ClkxCI), 
        .Q(inverter_gf24_ExDP_1__1_), .QN() );
  DFF_X1 inverter_gf24_BxDP_reg_0__0_ ( .D(InverterInxDP[0]), .CK(ClkxCI), .Q(
        inverter_gf24_BxDP[0]), .QN() );
  DFF_X1 inverter_gf24_BxDP_reg_1__0_ ( .D(InverterInxDP[4]), .CK(ClkxCI), .Q(
        inverter_gf24_BxDP[2]), .QN() );
  DFF_X1 inverter_gf24_AxDP_reg_0__0_ ( .D(InverterInxDP[2]), .CK(ClkxCI), .Q(
        inverter_gf24_AxDP[0]), .QN() );
  DFF_X1 inverter_gf24_AxDP_reg_1__0_ ( .D(InverterInxDP[6]), .CK(ClkxCI), .Q(
        inverter_gf24_AxDP[2]), .QN() );
  DFF_X1 inverter_gf24_AxDP_reg_0__1_ ( .D(InverterInxDP[3]), .CK(ClkxCI), .Q(
        inverter_gf24_AxDP[1]), .QN() );
  DFF_X1 inverter_gf24_AxDP_reg_1__1_ ( .D(InverterInxDP[7]), .CK(ClkxCI), .Q(
        inverter_gf24_AxDP[3]), .QN() );
  DFF_X1 inverter_gf24_BxDP_reg_0__1_ ( .D(InverterInxDP[1]), .CK(ClkxCI), .Q(
        inverter_gf24_BxDP[1]), .QN() );
  DFF_X1 inverter_gf24_BxDP_reg_1__1_ ( .D(InverterInxDP[5]), .CK(ClkxCI), .Q(
        inverter_gf24_BxDP[3]), .QN() );
  DFF_X1 inverter_gf24_pipelinedAxDP_reg_0__0_ ( .D(inverter_gf24_AxDP[0]), 
        .CK(ClkxCI), .Q(inverter_gf24_pipelinedAxDP[0]), .QN() );
  DFF_X1 inverter_gf24_pipelinedAxDP_reg_0__1_ ( .D(inverter_gf24_AxDP[1]), 
        .CK(ClkxCI), .Q(inverter_gf24_pipelinedAxDP[1]), .QN() );
  DFF_X1 inverter_gf24_pipelinedAxDP_reg_1__0_ ( .D(inverter_gf24_AxDP[2]), 
        .CK(ClkxCI), .Q(inverter_gf24_pipelinedAxDP[2]), .QN() );
  DFF_X1 inverter_gf24_pipelinedAxDP_reg_1__1_ ( .D(inverter_gf24_AxDP[3]), 
        .CK(ClkxCI), .Q(inverter_gf24_pipelinedAxDP[3]), .QN() );
  DFF_X1 inverter_gf24_pipelinedBxDP_reg_0__0_ ( .D(inverter_gf24_BxDP[0]), 
        .CK(ClkxCI), .Q(inverter_gf24_pipelinedBxDP[0]), .QN() );
  DFF_X1 inverter_gf24_pipelinedBxDP_reg_0__1_ ( .D(inverter_gf24_BxDP[1]), 
        .CK(ClkxCI), .Q(inverter_gf24_pipelinedBxDP[1]), .QN() );
  DFF_X1 inverter_gf24_pipelinedBxDP_reg_1__0_ ( .D(inverter_gf24_BxDP[2]), 
        .CK(ClkxCI), .Q(inverter_gf24_pipelinedBxDP[2]), .QN() );
  DFF_X1 inverter_gf24_pipelinedBxDP_reg_1__1_ ( .D(inverter_gf24_BxDP[3]), 
        .CK(ClkxCI), .Q(inverter_gf24_pipelinedBxDP[3]), .QN() );
  XOR2_X1 inverter_gf24_a_mul_b_U10 ( .A(inverter_gf24_a_mul_b_n2), .B(
        inverter_gf24_a_mul_b_n1), .Z(inverter_gf24_AmulBxD[3]) );
  XOR2_X1 inverter_gf24_a_mul_b_U9 ( .A(inverter_gf24_a_mul_b_n4), .B(
        inverter_gf24_a_mul_b_n3), .Z(inverter_gf24_AmulBxD[2]) );
  XOR2_X1 inverter_gf24_a_mul_b_U8 ( .A(inverter_gf24_a_mul_b_n6), .B(
        inverter_gf24_a_mul_b_n5), .Z(inverter_gf24_AmulBxD[1]) );
  XOR2_X1 inverter_gf24_a_mul_b_U7 ( .A(inverter_gf24_a_mul_b_n8), .B(
        inverter_gf24_a_mul_b_n7), .Z(inverter_gf24_AmulBxD[0]) );
  XOR2_X1 inverter_gf24_a_mul_b_U6 ( .A(Zinv1xDI[1]), .B(
        inverter_gf24_a_mul_b_Xi_mul_Yj_2__1_), .Z(
        inverter_gf24_a_mul_b_FFxDN[5]) );
  XOR2_X1 inverter_gf24_a_mul_b_U5 ( .A(Zinv1xDI[0]), .B(
        inverter_gf24_a_mul_b_Xi_mul_Yj_2__0_), .Z(
        inverter_gf24_a_mul_b_FFxDN[4]) );
  XOR2_X1 inverter_gf24_a_mul_b_U4 ( .A(Zinv1xDI[1]), .B(
        inverter_gf24_a_mul_b_Xi_mul_Yj_1__1_), .Z(
        inverter_gf24_a_mul_b_FFxDN[3]) );
  XOR2_X1 inverter_gf24_a_mul_b_U3 ( .A(Zinv1xDI[0]), .B(
        inverter_gf24_a_mul_b_Xi_mul_Yj_1__0_), .Z(
        inverter_gf24_a_mul_b_FFxDN[2]) );
  DFF_X1 inverter_gf24_a_mul_b_FFxDP_reg_1__0_ ( .D(
        inverter_gf24_a_mul_b_FFxDN[2]), .CK(ClkxCI), .Q(), .QN(
        inverter_gf24_a_mul_b_n8) );
  DFF_X1 inverter_gf24_a_mul_b_FFxDP_reg_1__1_ ( .D(
        inverter_gf24_a_mul_b_FFxDN[3]), .CK(ClkxCI), .Q(), .QN(
        inverter_gf24_a_mul_b_n6) );
  DFF_X1 inverter_gf24_a_mul_b_FFxDP_reg_2__0_ ( .D(
        inverter_gf24_a_mul_b_FFxDN[4]), .CK(ClkxCI), .Q(), .QN(
        inverter_gf24_a_mul_b_n3) );
  DFF_X1 inverter_gf24_a_mul_b_FFxDP_reg_2__1_ ( .D(
        inverter_gf24_a_mul_b_FFxDN[5]), .CK(ClkxCI), .Q(), .QN(
        inverter_gf24_a_mul_b_n1) );
  DFF_X1 inverter_gf24_a_mul_b_FFxDP_reg_0__0_ ( .D(
        inverter_gf24_a_mul_b_FFxDN[0]), .CK(ClkxCI), .Q(), .QN(
        inverter_gf24_a_mul_b_n7) );
  DFF_X1 inverter_gf24_a_mul_b_FFxDP_reg_3__0_ ( .D(
        inverter_gf24_a_mul_b_FFxDN[6]), .CK(ClkxCI), .Q(), .QN(
        inverter_gf24_a_mul_b_n4) );
  DFF_X1 inverter_gf24_a_mul_b_FFxDP_reg_0__1_ ( .D(
        inverter_gf24_a_mul_b_FFxDN[1]), .CK(ClkxCI), .Q(), .QN(
        inverter_gf24_a_mul_b_n5) );
  DFF_X1 inverter_gf24_a_mul_b_FFxDP_reg_3__1_ ( .D(
        inverter_gf24_a_mul_b_FFxDN[7]), .CK(ClkxCI), .Q(), .QN(
        inverter_gf24_a_mul_b_n2) );
  XNOR2_X1 inverter_gf24_a_mul_b_gf2_mul_1_1_U7 ( .A(
        inverter_gf24_a_mul_b_gf2_mul_1_1_n15), .B(
        inverter_gf24_a_mul_b_gf2_mul_1_1_n14), .ZN(
        inverter_gf24_a_mul_b_FFxDN[7]) );
  NAND2_X1 inverter_gf24_a_mul_b_gf2_mul_1_1_U6 ( .A1(InverterInxDP[7]), .A2(
        InverterInxDP[5]), .ZN(inverter_gf24_a_mul_b_gf2_mul_1_1_n15) );
  XNOR2_X1 inverter_gf24_a_mul_b_gf2_mul_1_1_U5 ( .A(
        inverter_gf24_a_mul_b_gf2_mul_1_1_n13), .B(
        inverter_gf24_a_mul_b_gf2_mul_1_1_n14), .ZN(
        inverter_gf24_a_mul_b_FFxDN[6]) );
  NOR2_X1 inverter_gf24_a_mul_b_gf2_mul_1_1_U4 ( .A1(
        inverter_gf24_a_mul_b_gf2_mul_1_1_n12), .A2(
        inverter_gf24_a_mul_b_gf2_mul_1_1_n11), .ZN(
        inverter_gf24_a_mul_b_gf2_mul_1_1_n14) );
  XNOR2_X1 inverter_gf24_a_mul_b_gf2_mul_1_1_U3 ( .A(InverterInxDP[7]), .B(
        InverterInxDP[6]), .ZN(inverter_gf24_a_mul_b_gf2_mul_1_1_n11) );
  XNOR2_X1 inverter_gf24_a_mul_b_gf2_mul_1_1_U2 ( .A(InverterInxDP[5]), .B(
        InverterInxDP[4]), .ZN(inverter_gf24_a_mul_b_gf2_mul_1_1_n12) );
  NAND2_X1 inverter_gf24_a_mul_b_gf2_mul_1_1_U1 ( .A1(InverterInxDP[6]), .A2(
        InverterInxDP[4]), .ZN(inverter_gf24_a_mul_b_gf2_mul_1_1_n13) );
  XNOR2_X1 inverter_gf24_a_mul_b_gf2_mul_1_0_U7 ( .A(
        inverter_gf24_a_mul_b_gf2_mul_1_0_n15), .B(
        inverter_gf24_a_mul_b_gf2_mul_1_0_n14), .ZN(
        inverter_gf24_a_mul_b_Xi_mul_Yj_2__1_) );
  NAND2_X1 inverter_gf24_a_mul_b_gf2_mul_1_0_U6 ( .A1(InverterInxDP[7]), .A2(
        InverterInxDP[1]), .ZN(inverter_gf24_a_mul_b_gf2_mul_1_0_n15) );
  XNOR2_X1 inverter_gf24_a_mul_b_gf2_mul_1_0_U5 ( .A(
        inverter_gf24_a_mul_b_gf2_mul_1_0_n13), .B(
        inverter_gf24_a_mul_b_gf2_mul_1_0_n14), .ZN(
        inverter_gf24_a_mul_b_Xi_mul_Yj_2__0_) );
  NOR2_X1 inverter_gf24_a_mul_b_gf2_mul_1_0_U4 ( .A1(
        inverter_gf24_a_mul_b_gf2_mul_1_0_n12), .A2(
        inverter_gf24_a_mul_b_gf2_mul_1_0_n11), .ZN(
        inverter_gf24_a_mul_b_gf2_mul_1_0_n14) );
  XNOR2_X1 inverter_gf24_a_mul_b_gf2_mul_1_0_U3 ( .A(InverterInxDP[7]), .B(
        InverterInxDP[6]), .ZN(inverter_gf24_a_mul_b_gf2_mul_1_0_n11) );
  XNOR2_X1 inverter_gf24_a_mul_b_gf2_mul_1_0_U2 ( .A(InverterInxDP[1]), .B(
        InverterInxDP[0]), .ZN(inverter_gf24_a_mul_b_gf2_mul_1_0_n12) );
  NAND2_X1 inverter_gf24_a_mul_b_gf2_mul_1_0_U1 ( .A1(InverterInxDP[6]), .A2(
        InverterInxDP[0]), .ZN(inverter_gf24_a_mul_b_gf2_mul_1_0_n13) );
  XNOR2_X1 inverter_gf24_a_mul_b_gf2_mul_0_1_U7 ( .A(
        inverter_gf24_a_mul_b_gf2_mul_0_1_n15), .B(
        inverter_gf24_a_mul_b_gf2_mul_0_1_n14), .ZN(
        inverter_gf24_a_mul_b_Xi_mul_Yj_1__1_) );
  NAND2_X1 inverter_gf24_a_mul_b_gf2_mul_0_1_U6 ( .A1(InverterInxDP[3]), .A2(
        InverterInxDP[5]), .ZN(inverter_gf24_a_mul_b_gf2_mul_0_1_n15) );
  XNOR2_X1 inverter_gf24_a_mul_b_gf2_mul_0_1_U5 ( .A(
        inverter_gf24_a_mul_b_gf2_mul_0_1_n13), .B(
        inverter_gf24_a_mul_b_gf2_mul_0_1_n14), .ZN(
        inverter_gf24_a_mul_b_Xi_mul_Yj_1__0_) );
  NOR2_X1 inverter_gf24_a_mul_b_gf2_mul_0_1_U4 ( .A1(
        inverter_gf24_a_mul_b_gf2_mul_0_1_n12), .A2(
        inverter_gf24_a_mul_b_gf2_mul_0_1_n11), .ZN(
        inverter_gf24_a_mul_b_gf2_mul_0_1_n14) );
  XNOR2_X1 inverter_gf24_a_mul_b_gf2_mul_0_1_U3 ( .A(InverterInxDP[3]), .B(
        InverterInxDP[2]), .ZN(inverter_gf24_a_mul_b_gf2_mul_0_1_n11) );
  XNOR2_X1 inverter_gf24_a_mul_b_gf2_mul_0_1_U2 ( .A(InverterInxDP[5]), .B(
        InverterInxDP[4]), .ZN(inverter_gf24_a_mul_b_gf2_mul_0_1_n12) );
  NAND2_X1 inverter_gf24_a_mul_b_gf2_mul_0_1_U1 ( .A1(InverterInxDP[2]), .A2(
        InverterInxDP[4]), .ZN(inverter_gf24_a_mul_b_gf2_mul_0_1_n13) );
  XNOR2_X1 inverter_gf24_a_mul_b_gf2_mul_0_0_U7 ( .A(
        inverter_gf24_a_mul_b_gf2_mul_0_0_n15), .B(
        inverter_gf24_a_mul_b_gf2_mul_0_0_n14), .ZN(
        inverter_gf24_a_mul_b_FFxDN[1]) );
  NAND2_X1 inverter_gf24_a_mul_b_gf2_mul_0_0_U6 ( .A1(InverterInxDP[3]), .A2(
        InverterInxDP[1]), .ZN(inverter_gf24_a_mul_b_gf2_mul_0_0_n15) );
  XNOR2_X1 inverter_gf24_a_mul_b_gf2_mul_0_0_U5 ( .A(
        inverter_gf24_a_mul_b_gf2_mul_0_0_n13), .B(
        inverter_gf24_a_mul_b_gf2_mul_0_0_n14), .ZN(
        inverter_gf24_a_mul_b_FFxDN[0]) );
  NOR2_X1 inverter_gf24_a_mul_b_gf2_mul_0_0_U4 ( .A1(
        inverter_gf24_a_mul_b_gf2_mul_0_0_n12), .A2(
        inverter_gf24_a_mul_b_gf2_mul_0_0_n11), .ZN(
        inverter_gf24_a_mul_b_gf2_mul_0_0_n14) );
  XNOR2_X1 inverter_gf24_a_mul_b_gf2_mul_0_0_U3 ( .A(InverterInxDP[3]), .B(
        InverterInxDP[2]), .ZN(inverter_gf24_a_mul_b_gf2_mul_0_0_n11) );
  XNOR2_X1 inverter_gf24_a_mul_b_gf2_mul_0_0_U2 ( .A(InverterInxDP[1]), .B(
        InverterInxDP[0]), .ZN(inverter_gf24_a_mul_b_gf2_mul_0_0_n12) );
  NAND2_X1 inverter_gf24_a_mul_b_gf2_mul_0_0_U1 ( .A1(InverterInxDP[2]), .A2(
        InverterInxDP[0]), .ZN(inverter_gf24_a_mul_b_gf2_mul_0_0_n13) );
  XOR2_X1 inverter_gf24_a_mul_e_U10 ( .A(Zinv2xDI[1]), .B(
        inverter_gf24_a_mul_e_Xi_mul_Yj_2__1_), .Z(
        inverter_gf24_a_mul_e_FFxDN[5]) );
  XOR2_X1 inverter_gf24_a_mul_e_U9 ( .A(Zinv2xDI[0]), .B(
        inverter_gf24_a_mul_e_Xi_mul_Yj_2__0_), .Z(
        inverter_gf24_a_mul_e_FFxDN[4]) );
  XOR2_X1 inverter_gf24_a_mul_e_U8 ( .A(Zinv2xDI[1]), .B(
        inverter_gf24_a_mul_e_Xi_mul_Yj_1__1_), .Z(
        inverter_gf24_a_mul_e_FFxDN[3]) );
  XOR2_X1 inverter_gf24_a_mul_e_U7 ( .A(Zinv2xDI[0]), .B(
        inverter_gf24_a_mul_e_Xi_mul_Yj_1__0_), .Z(
        inverter_gf24_a_mul_e_FFxDN[2]) );
  XOR2_X2 inverter_gf24_a_mul_e_U6 ( .A(inverter_gf24_a_mul_e_n11), .B(
        inverter_gf24_a_mul_e_n12), .Z(InverterOutxD[5]) );
  XOR2_X2 inverter_gf24_a_mul_e_U5 ( .A(inverter_gf24_a_mul_e_n9), .B(
        inverter_gf24_a_mul_e_n10), .Z(InverterOutxD[1]) );
  XOR2_X2 inverter_gf24_a_mul_e_U4 ( .A(inverter_gf24_a_mul_e_n15), .B(
        inverter_gf24_a_mul_e_n16), .Z(InverterOutxD[4]) );
  XOR2_X2 inverter_gf24_a_mul_e_U3 ( .A(inverter_gf24_a_mul_e_n13), .B(
        inverter_gf24_a_mul_e_n14), .Z(InverterOutxD[0]) );
  DFF_X1 inverter_gf24_a_mul_e_FFxDP_reg_1__0_ ( .D(
        inverter_gf24_a_mul_e_FFxDN[2]), .CK(ClkxCI), .Q(), .QN(
        inverter_gf24_a_mul_e_n13) );
  DFF_X1 inverter_gf24_a_mul_e_FFxDP_reg_1__1_ ( .D(
        inverter_gf24_a_mul_e_FFxDN[3]), .CK(ClkxCI), .Q(), .QN(
        inverter_gf24_a_mul_e_n9) );
  DFF_X1 inverter_gf24_a_mul_e_FFxDP_reg_2__0_ ( .D(
        inverter_gf24_a_mul_e_FFxDN[4]), .CK(ClkxCI), .Q(), .QN(
        inverter_gf24_a_mul_e_n16) );
  DFF_X1 inverter_gf24_a_mul_e_FFxDP_reg_2__1_ ( .D(
        inverter_gf24_a_mul_e_FFxDN[5]), .CK(ClkxCI), .Q(), .QN(
        inverter_gf24_a_mul_e_n12) );
  DFF_X1 inverter_gf24_a_mul_e_FFxDP_reg_0__0_ ( .D(
        inverter_gf24_a_mul_e_FFxDN[0]), .CK(ClkxCI), .Q(), .QN(
        inverter_gf24_a_mul_e_n14) );
  DFF_X1 inverter_gf24_a_mul_e_FFxDP_reg_0__1_ ( .D(
        inverter_gf24_a_mul_e_FFxDN[1]), .CK(ClkxCI), .Q(), .QN(
        inverter_gf24_a_mul_e_n10) );
  DFF_X1 inverter_gf24_a_mul_e_FFxDP_reg_3__0_ ( .D(
        inverter_gf24_a_mul_e_FFxDN[6]), .CK(ClkxCI), .Q(), .QN(
        inverter_gf24_a_mul_e_n15) );
  DFF_X1 inverter_gf24_a_mul_e_FFxDP_reg_3__1_ ( .D(
        inverter_gf24_a_mul_e_FFxDN[7]), .CK(ClkxCI), .Q(), .QN(
        inverter_gf24_a_mul_e_n11) );
  XNOR2_X1 inverter_gf24_a_mul_e_gf2_mul_1_1_U7 ( .A(
        inverter_gf24_a_mul_e_gf2_mul_1_1_n15), .B(
        inverter_gf24_a_mul_e_gf2_mul_1_1_n14), .ZN(
        inverter_gf24_a_mul_e_FFxDN[7]) );
  NAND2_X1 inverter_gf24_a_mul_e_gf2_mul_1_1_U6 ( .A1(
        inverter_gf24_pipelinedAxDP[3]), .A2(inverter_gf24_ExDP_1__1_), .ZN(
        inverter_gf24_a_mul_e_gf2_mul_1_1_n15) );
  XNOR2_X1 inverter_gf24_a_mul_e_gf2_mul_1_1_U5 ( .A(
        inverter_gf24_a_mul_e_gf2_mul_1_1_n13), .B(
        inverter_gf24_a_mul_e_gf2_mul_1_1_n14), .ZN(
        inverter_gf24_a_mul_e_FFxDN[6]) );
  NOR2_X1 inverter_gf24_a_mul_e_gf2_mul_1_1_U4 ( .A1(
        inverter_gf24_a_mul_e_gf2_mul_1_1_n12), .A2(
        inverter_gf24_a_mul_e_gf2_mul_1_1_n11), .ZN(
        inverter_gf24_a_mul_e_gf2_mul_1_1_n14) );
  XNOR2_X1 inverter_gf24_a_mul_e_gf2_mul_1_1_U3 ( .A(
        inverter_gf24_pipelinedAxDP[3]), .B(inverter_gf24_pipelinedAxDP[2]), 
        .ZN(inverter_gf24_a_mul_e_gf2_mul_1_1_n11) );
  XNOR2_X1 inverter_gf24_a_mul_e_gf2_mul_1_1_U2 ( .A(inverter_gf24_ExDP_1__1_), 
        .B(inverter_gf24_ExDP_1__0_), .ZN(
        inverter_gf24_a_mul_e_gf2_mul_1_1_n12) );
  NAND2_X1 inverter_gf24_a_mul_e_gf2_mul_1_1_U1 ( .A1(
        inverter_gf24_pipelinedAxDP[2]), .A2(inverter_gf24_ExDP_1__0_), .ZN(
        inverter_gf24_a_mul_e_gf2_mul_1_1_n13) );
  XNOR2_X1 inverter_gf24_a_mul_e_gf2_mul_1_0_U7 ( .A(
        inverter_gf24_a_mul_e_gf2_mul_1_0_n15), .B(
        inverter_gf24_a_mul_e_gf2_mul_1_0_n14), .ZN(
        inverter_gf24_a_mul_e_Xi_mul_Yj_2__1_) );
  NAND2_X1 inverter_gf24_a_mul_e_gf2_mul_1_0_U6 ( .A1(
        inverter_gf24_pipelinedAxDP[3]), .A2(inverter_gf24_ExDP_0__1_), .ZN(
        inverter_gf24_a_mul_e_gf2_mul_1_0_n15) );
  XNOR2_X1 inverter_gf24_a_mul_e_gf2_mul_1_0_U5 ( .A(
        inverter_gf24_a_mul_e_gf2_mul_1_0_n13), .B(
        inverter_gf24_a_mul_e_gf2_mul_1_0_n14), .ZN(
        inverter_gf24_a_mul_e_Xi_mul_Yj_2__0_) );
  NOR2_X1 inverter_gf24_a_mul_e_gf2_mul_1_0_U4 ( .A1(
        inverter_gf24_a_mul_e_gf2_mul_1_0_n12), .A2(
        inverter_gf24_a_mul_e_gf2_mul_1_0_n11), .ZN(
        inverter_gf24_a_mul_e_gf2_mul_1_0_n14) );
  XNOR2_X1 inverter_gf24_a_mul_e_gf2_mul_1_0_U3 ( .A(
        inverter_gf24_pipelinedAxDP[3]), .B(inverter_gf24_pipelinedAxDP[2]), 
        .ZN(inverter_gf24_a_mul_e_gf2_mul_1_0_n11) );
  XNOR2_X1 inverter_gf24_a_mul_e_gf2_mul_1_0_U2 ( .A(inverter_gf24_ExDP_0__1_), 
        .B(inverter_gf24_ExDP_0__0_), .ZN(
        inverter_gf24_a_mul_e_gf2_mul_1_0_n12) );
  NAND2_X1 inverter_gf24_a_mul_e_gf2_mul_1_0_U1 ( .A1(
        inverter_gf24_pipelinedAxDP[2]), .A2(inverter_gf24_ExDP_0__0_), .ZN(
        inverter_gf24_a_mul_e_gf2_mul_1_0_n13) );
  XNOR2_X1 inverter_gf24_a_mul_e_gf2_mul_0_1_U7 ( .A(
        inverter_gf24_a_mul_e_gf2_mul_0_1_n15), .B(
        inverter_gf24_a_mul_e_gf2_mul_0_1_n14), .ZN(
        inverter_gf24_a_mul_e_Xi_mul_Yj_1__1_) );
  NAND2_X1 inverter_gf24_a_mul_e_gf2_mul_0_1_U6 ( .A1(
        inverter_gf24_pipelinedAxDP[1]), .A2(inverter_gf24_ExDP_1__1_), .ZN(
        inverter_gf24_a_mul_e_gf2_mul_0_1_n15) );
  XNOR2_X1 inverter_gf24_a_mul_e_gf2_mul_0_1_U5 ( .A(
        inverter_gf24_a_mul_e_gf2_mul_0_1_n13), .B(
        inverter_gf24_a_mul_e_gf2_mul_0_1_n14), .ZN(
        inverter_gf24_a_mul_e_Xi_mul_Yj_1__0_) );
  NOR2_X1 inverter_gf24_a_mul_e_gf2_mul_0_1_U4 ( .A1(
        inverter_gf24_a_mul_e_gf2_mul_0_1_n12), .A2(
        inverter_gf24_a_mul_e_gf2_mul_0_1_n11), .ZN(
        inverter_gf24_a_mul_e_gf2_mul_0_1_n14) );
  XNOR2_X1 inverter_gf24_a_mul_e_gf2_mul_0_1_U3 ( .A(
        inverter_gf24_pipelinedAxDP[1]), .B(inverter_gf24_pipelinedAxDP[0]), 
        .ZN(inverter_gf24_a_mul_e_gf2_mul_0_1_n11) );
  XNOR2_X1 inverter_gf24_a_mul_e_gf2_mul_0_1_U2 ( .A(inverter_gf24_ExDP_1__1_), 
        .B(inverter_gf24_ExDP_1__0_), .ZN(
        inverter_gf24_a_mul_e_gf2_mul_0_1_n12) );
  NAND2_X1 inverter_gf24_a_mul_e_gf2_mul_0_1_U1 ( .A1(
        inverter_gf24_pipelinedAxDP[0]), .A2(inverter_gf24_ExDP_1__0_), .ZN(
        inverter_gf24_a_mul_e_gf2_mul_0_1_n13) );
  XNOR2_X1 inverter_gf24_a_mul_e_gf2_mul_0_0_U7 ( .A(
        inverter_gf24_a_mul_e_gf2_mul_0_0_n15), .B(
        inverter_gf24_a_mul_e_gf2_mul_0_0_n14), .ZN(
        inverter_gf24_a_mul_e_FFxDN[1]) );
  NAND2_X1 inverter_gf24_a_mul_e_gf2_mul_0_0_U6 ( .A1(
        inverter_gf24_pipelinedAxDP[1]), .A2(inverter_gf24_ExDP_0__1_), .ZN(
        inverter_gf24_a_mul_e_gf2_mul_0_0_n15) );
  XNOR2_X1 inverter_gf24_a_mul_e_gf2_mul_0_0_U5 ( .A(
        inverter_gf24_a_mul_e_gf2_mul_0_0_n13), .B(
        inverter_gf24_a_mul_e_gf2_mul_0_0_n14), .ZN(
        inverter_gf24_a_mul_e_FFxDN[0]) );
  NOR2_X1 inverter_gf24_a_mul_e_gf2_mul_0_0_U4 ( .A1(
        inverter_gf24_a_mul_e_gf2_mul_0_0_n12), .A2(
        inverter_gf24_a_mul_e_gf2_mul_0_0_n11), .ZN(
        inverter_gf24_a_mul_e_gf2_mul_0_0_n14) );
  XNOR2_X1 inverter_gf24_a_mul_e_gf2_mul_0_0_U3 ( .A(
        inverter_gf24_pipelinedAxDP[1]), .B(inverter_gf24_pipelinedAxDP[0]), 
        .ZN(inverter_gf24_a_mul_e_gf2_mul_0_0_n11) );
  XNOR2_X1 inverter_gf24_a_mul_e_gf2_mul_0_0_U2 ( .A(inverter_gf24_ExDP_0__1_), 
        .B(inverter_gf24_ExDP_0__0_), .ZN(
        inverter_gf24_a_mul_e_gf2_mul_0_0_n12) );
  NAND2_X1 inverter_gf24_a_mul_e_gf2_mul_0_0_U1 ( .A1(
        inverter_gf24_pipelinedAxDP[0]), .A2(inverter_gf24_ExDP_0__0_), .ZN(
        inverter_gf24_a_mul_e_gf2_mul_0_0_n13) );
  XOR2_X1 inverter_gf24_b_mul_e_U10 ( .A(Zinv3xDI[1]), .B(
        inverter_gf24_b_mul_e_Xi_mul_Yj_2__1_), .Z(
        inverter_gf24_b_mul_e_FFxDN[5]) );
  XOR2_X1 inverter_gf24_b_mul_e_U9 ( .A(Zinv3xDI[0]), .B(
        inverter_gf24_b_mul_e_Xi_mul_Yj_2__0_), .Z(
        inverter_gf24_b_mul_e_FFxDN[4]) );
  XOR2_X1 inverter_gf24_b_mul_e_U8 ( .A(Zinv3xDI[1]), .B(
        inverter_gf24_b_mul_e_Xi_mul_Yj_1__1_), .Z(
        inverter_gf24_b_mul_e_FFxDN[3]) );
  XOR2_X1 inverter_gf24_b_mul_e_U7 ( .A(Zinv3xDI[0]), .B(
        inverter_gf24_b_mul_e_Xi_mul_Yj_1__0_), .Z(
        inverter_gf24_b_mul_e_FFxDN[2]) );
  XOR2_X2 inverter_gf24_b_mul_e_U6 ( .A(inverter_gf24_b_mul_e_n11), .B(
        inverter_gf24_b_mul_e_n12), .Z(InverterOutxD[7]) );
  XOR2_X2 inverter_gf24_b_mul_e_U5 ( .A(inverter_gf24_b_mul_e_n9), .B(
        inverter_gf24_b_mul_e_n10), .Z(InverterOutxD[3]) );
  XOR2_X2 inverter_gf24_b_mul_e_U4 ( .A(inverter_gf24_b_mul_e_n15), .B(
        inverter_gf24_b_mul_e_n16), .Z(InverterOutxD[6]) );
  XOR2_X2 inverter_gf24_b_mul_e_U3 ( .A(inverter_gf24_b_mul_e_n13), .B(
        inverter_gf24_b_mul_e_n14), .Z(InverterOutxD[2]) );
  DFF_X1 inverter_gf24_b_mul_e_FFxDP_reg_1__0_ ( .D(
        inverter_gf24_b_mul_e_FFxDN[2]), .CK(ClkxCI), .Q(), .QN(
        inverter_gf24_b_mul_e_n13) );
  DFF_X1 inverter_gf24_b_mul_e_FFxDP_reg_1__1_ ( .D(
        inverter_gf24_b_mul_e_FFxDN[3]), .CK(ClkxCI), .Q(), .QN(
        inverter_gf24_b_mul_e_n9) );
  DFF_X1 inverter_gf24_b_mul_e_FFxDP_reg_2__0_ ( .D(
        inverter_gf24_b_mul_e_FFxDN[4]), .CK(ClkxCI), .Q(), .QN(
        inverter_gf24_b_mul_e_n16) );
  DFF_X1 inverter_gf24_b_mul_e_FFxDP_reg_2__1_ ( .D(
        inverter_gf24_b_mul_e_FFxDN[5]), .CK(ClkxCI), .Q(), .QN(
        inverter_gf24_b_mul_e_n12) );
  DFF_X1 inverter_gf24_b_mul_e_FFxDP_reg_0__0_ ( .D(
        inverter_gf24_b_mul_e_FFxDN[0]), .CK(ClkxCI), .Q(), .QN(
        inverter_gf24_b_mul_e_n14) );
  DFF_X1 inverter_gf24_b_mul_e_FFxDP_reg_0__1_ ( .D(
        inverter_gf24_b_mul_e_FFxDN[1]), .CK(ClkxCI), .Q(), .QN(
        inverter_gf24_b_mul_e_n10) );
  DFF_X1 inverter_gf24_b_mul_e_FFxDP_reg_3__0_ ( .D(
        inverter_gf24_b_mul_e_FFxDN[6]), .CK(ClkxCI), .Q(), .QN(
        inverter_gf24_b_mul_e_n15) );
  DFF_X1 inverter_gf24_b_mul_e_FFxDP_reg_3__1_ ( .D(
        inverter_gf24_b_mul_e_FFxDN[7]), .CK(ClkxCI), .Q(), .QN(
        inverter_gf24_b_mul_e_n11) );
  XNOR2_X1 inverter_gf24_b_mul_e_gf2_mul_1_1_U7 ( .A(
        inverter_gf24_b_mul_e_gf2_mul_1_1_n15), .B(
        inverter_gf24_b_mul_e_gf2_mul_1_1_n14), .ZN(
        inverter_gf24_b_mul_e_FFxDN[7]) );
  NAND2_X1 inverter_gf24_b_mul_e_gf2_mul_1_1_U6 ( .A1(
        inverter_gf24_pipelinedBxDP[3]), .A2(inverter_gf24_ExDP_1__1_), .ZN(
        inverter_gf24_b_mul_e_gf2_mul_1_1_n15) );
  XNOR2_X1 inverter_gf24_b_mul_e_gf2_mul_1_1_U5 ( .A(
        inverter_gf24_b_mul_e_gf2_mul_1_1_n13), .B(
        inverter_gf24_b_mul_e_gf2_mul_1_1_n14), .ZN(
        inverter_gf24_b_mul_e_FFxDN[6]) );
  NOR2_X1 inverter_gf24_b_mul_e_gf2_mul_1_1_U4 ( .A1(
        inverter_gf24_b_mul_e_gf2_mul_1_1_n12), .A2(
        inverter_gf24_b_mul_e_gf2_mul_1_1_n11), .ZN(
        inverter_gf24_b_mul_e_gf2_mul_1_1_n14) );
  XNOR2_X1 inverter_gf24_b_mul_e_gf2_mul_1_1_U3 ( .A(
        inverter_gf24_pipelinedBxDP[3]), .B(inverter_gf24_pipelinedBxDP[2]), 
        .ZN(inverter_gf24_b_mul_e_gf2_mul_1_1_n11) );
  XNOR2_X1 inverter_gf24_b_mul_e_gf2_mul_1_1_U2 ( .A(inverter_gf24_ExDP_1__1_), 
        .B(inverter_gf24_ExDP_1__0_), .ZN(
        inverter_gf24_b_mul_e_gf2_mul_1_1_n12) );
  NAND2_X1 inverter_gf24_b_mul_e_gf2_mul_1_1_U1 ( .A1(
        inverter_gf24_pipelinedBxDP[2]), .A2(inverter_gf24_ExDP_1__0_), .ZN(
        inverter_gf24_b_mul_e_gf2_mul_1_1_n13) );
  XNOR2_X1 inverter_gf24_b_mul_e_gf2_mul_1_0_U7 ( .A(
        inverter_gf24_b_mul_e_gf2_mul_1_0_n15), .B(
        inverter_gf24_b_mul_e_gf2_mul_1_0_n14), .ZN(
        inverter_gf24_b_mul_e_Xi_mul_Yj_2__1_) );
  NAND2_X1 inverter_gf24_b_mul_e_gf2_mul_1_0_U6 ( .A1(
        inverter_gf24_pipelinedBxDP[3]), .A2(inverter_gf24_ExDP_0__1_), .ZN(
        inverter_gf24_b_mul_e_gf2_mul_1_0_n15) );
  XNOR2_X1 inverter_gf24_b_mul_e_gf2_mul_1_0_U5 ( .A(
        inverter_gf24_b_mul_e_gf2_mul_1_0_n13), .B(
        inverter_gf24_b_mul_e_gf2_mul_1_0_n14), .ZN(
        inverter_gf24_b_mul_e_Xi_mul_Yj_2__0_) );
  NOR2_X1 inverter_gf24_b_mul_e_gf2_mul_1_0_U4 ( .A1(
        inverter_gf24_b_mul_e_gf2_mul_1_0_n12), .A2(
        inverter_gf24_b_mul_e_gf2_mul_1_0_n11), .ZN(
        inverter_gf24_b_mul_e_gf2_mul_1_0_n14) );
  XNOR2_X1 inverter_gf24_b_mul_e_gf2_mul_1_0_U3 ( .A(
        inverter_gf24_pipelinedBxDP[3]), .B(inverter_gf24_pipelinedBxDP[2]), 
        .ZN(inverter_gf24_b_mul_e_gf2_mul_1_0_n11) );
  XNOR2_X1 inverter_gf24_b_mul_e_gf2_mul_1_0_U2 ( .A(inverter_gf24_ExDP_0__1_), 
        .B(inverter_gf24_ExDP_0__0_), .ZN(
        inverter_gf24_b_mul_e_gf2_mul_1_0_n12) );
  NAND2_X1 inverter_gf24_b_mul_e_gf2_mul_1_0_U1 ( .A1(
        inverter_gf24_pipelinedBxDP[2]), .A2(inverter_gf24_ExDP_0__0_), .ZN(
        inverter_gf24_b_mul_e_gf2_mul_1_0_n13) );
  XNOR2_X1 inverter_gf24_b_mul_e_gf2_mul_0_1_U7 ( .A(
        inverter_gf24_b_mul_e_gf2_mul_0_1_n15), .B(
        inverter_gf24_b_mul_e_gf2_mul_0_1_n14), .ZN(
        inverter_gf24_b_mul_e_Xi_mul_Yj_1__1_) );
  NAND2_X1 inverter_gf24_b_mul_e_gf2_mul_0_1_U6 ( .A1(
        inverter_gf24_pipelinedBxDP[1]), .A2(inverter_gf24_ExDP_1__1_), .ZN(
        inverter_gf24_b_mul_e_gf2_mul_0_1_n15) );
  XNOR2_X1 inverter_gf24_b_mul_e_gf2_mul_0_1_U5 ( .A(
        inverter_gf24_b_mul_e_gf2_mul_0_1_n13), .B(
        inverter_gf24_b_mul_e_gf2_mul_0_1_n14), .ZN(
        inverter_gf24_b_mul_e_Xi_mul_Yj_1__0_) );
  NOR2_X1 inverter_gf24_b_mul_e_gf2_mul_0_1_U4 ( .A1(
        inverter_gf24_b_mul_e_gf2_mul_0_1_n12), .A2(
        inverter_gf24_b_mul_e_gf2_mul_0_1_n11), .ZN(
        inverter_gf24_b_mul_e_gf2_mul_0_1_n14) );
  XNOR2_X1 inverter_gf24_b_mul_e_gf2_mul_0_1_U3 ( .A(
        inverter_gf24_pipelinedBxDP[1]), .B(inverter_gf24_pipelinedBxDP[0]), 
        .ZN(inverter_gf24_b_mul_e_gf2_mul_0_1_n11) );
  XNOR2_X1 inverter_gf24_b_mul_e_gf2_mul_0_1_U2 ( .A(inverter_gf24_ExDP_1__1_), 
        .B(inverter_gf24_ExDP_1__0_), .ZN(
        inverter_gf24_b_mul_e_gf2_mul_0_1_n12) );
  NAND2_X1 inverter_gf24_b_mul_e_gf2_mul_0_1_U1 ( .A1(
        inverter_gf24_pipelinedBxDP[0]), .A2(inverter_gf24_ExDP_1__0_), .ZN(
        inverter_gf24_b_mul_e_gf2_mul_0_1_n13) );
  XNOR2_X1 inverter_gf24_b_mul_e_gf2_mul_0_0_U7 ( .A(
        inverter_gf24_b_mul_e_gf2_mul_0_0_n15), .B(
        inverter_gf24_b_mul_e_gf2_mul_0_0_n14), .ZN(
        inverter_gf24_b_mul_e_FFxDN[1]) );
  NAND2_X1 inverter_gf24_b_mul_e_gf2_mul_0_0_U6 ( .A1(
        inverter_gf24_pipelinedBxDP[1]), .A2(inverter_gf24_ExDP_0__1_), .ZN(
        inverter_gf24_b_mul_e_gf2_mul_0_0_n15) );
  XNOR2_X1 inverter_gf24_b_mul_e_gf2_mul_0_0_U5 ( .A(
        inverter_gf24_b_mul_e_gf2_mul_0_0_n13), .B(
        inverter_gf24_b_mul_e_gf2_mul_0_0_n14), .ZN(
        inverter_gf24_b_mul_e_FFxDN[0]) );
  NOR2_X1 inverter_gf24_b_mul_e_gf2_mul_0_0_U4 ( .A1(
        inverter_gf24_b_mul_e_gf2_mul_0_0_n12), .A2(
        inverter_gf24_b_mul_e_gf2_mul_0_0_n11), .ZN(
        inverter_gf24_b_mul_e_gf2_mul_0_0_n14) );
  XNOR2_X1 inverter_gf24_b_mul_e_gf2_mul_0_0_U3 ( .A(
        inverter_gf24_pipelinedBxDP[1]), .B(inverter_gf24_pipelinedBxDP[0]), 
        .ZN(inverter_gf24_b_mul_e_gf2_mul_0_0_n11) );
  XNOR2_X1 inverter_gf24_b_mul_e_gf2_mul_0_0_U2 ( .A(inverter_gf24_ExDP_0__1_), 
        .B(inverter_gf24_ExDP_0__0_), .ZN(
        inverter_gf24_b_mul_e_gf2_mul_0_0_n12) );
  NAND2_X1 inverter_gf24_b_mul_e_gf2_mul_0_0_U1 ( .A1(
        inverter_gf24_pipelinedBxDP[0]), .A2(inverter_gf24_ExDP_0__0_), .ZN(
        inverter_gf24_b_mul_e_gf2_mul_0_0_n13) );
  XOR2_X1 mult_msb_U18 ( .A(mult_msb_n2), .B(mult_msb_n1), .Z(
        InvUnmappedxD[15]) );
  XOR2_X1 mult_msb_U17 ( .A(mult_msb_n4), .B(mult_msb_n3), .Z(
        InvUnmappedxD[14]) );
  XOR2_X1 mult_msb_U16 ( .A(mult_msb_n6), .B(mult_msb_n5), .Z(
        InvUnmappedxD[13]) );
  XOR2_X1 mult_msb_U15 ( .A(mult_msb_n8), .B(mult_msb_n7), .Z(
        InvUnmappedxD[12]) );
  XOR2_X1 mult_msb_U14 ( .A(mult_msb_n10), .B(mult_msb_n9), .Z(
        InvUnmappedxD[7]) );
  XOR2_X1 mult_msb_U13 ( .A(mult_msb_n12), .B(mult_msb_n11), .Z(
        InvUnmappedxD[6]) );
  XOR2_X1 mult_msb_U12 ( .A(mult_msb_n14), .B(mult_msb_n13), .Z(
        InvUnmappedxD[5]) );
  XOR2_X1 mult_msb_U11 ( .A(mult_msb_n16), .B(mult_msb_n15), .Z(
        InvUnmappedxD[4]) );
  XOR2_X1 mult_msb_U10 ( .A(Zmul2xDI[3]), .B(mult_msb_Xi_mul_Yj_2__3_), .Z(
        mult_msb_FFxDN[11]) );
  XOR2_X1 mult_msb_U9 ( .A(Zmul2xDI[2]), .B(mult_msb_Xi_mul_Yj_2__2_), .Z(
        mult_msb_FFxDN[10]) );
  XOR2_X1 mult_msb_U8 ( .A(Zmul2xDI[1]), .B(mult_msb_Xi_mul_Yj_2__1_), .Z(
        mult_msb_FFxDN[9]) );
  XOR2_X1 mult_msb_U7 ( .A(Zmul2xDI[0]), .B(mult_msb_Xi_mul_Yj_2__0_), .Z(
        mult_msb_FFxDN[8]) );
  XOR2_X1 mult_msb_U6 ( .A(Zmul2xDI[3]), .B(mult_msb_Xi_mul_Yj_1__3_), .Z(
        mult_msb_FFxDN[7]) );
  XOR2_X1 mult_msb_U5 ( .A(Zmul2xDI[2]), .B(mult_msb_Xi_mul_Yj_1__2_), .Z(
        mult_msb_FFxDN[6]) );
  XOR2_X1 mult_msb_U4 ( .A(Zmul2xDI[1]), .B(mult_msb_Xi_mul_Yj_1__1_), .Z(
        mult_msb_FFxDN[5]) );
  XOR2_X1 mult_msb_U3 ( .A(Zmul2xDI[0]), .B(mult_msb_Xi_mul_Yj_1__0_), .Z(
        mult_msb_FFxDN[4]) );
  DFF_X1 mult_msb_FFxDP_reg_1__1_ ( .D(mult_msb_FFxDN[5]), .CK(ClkxCI), .Q(), 
        .QN(mult_msb_n14) );
  DFF_X1 mult_msb_FFxDP_reg_1__3_ ( .D(mult_msb_FFxDN[7]), .CK(ClkxCI), .Q(), 
        .QN(mult_msb_n10) );
  DFF_X1 mult_msb_FFxDP_reg_2__1_ ( .D(mult_msb_FFxDN[9]), .CK(ClkxCI), .Q(), 
        .QN(mult_msb_n5) );
  DFF_X1 mult_msb_FFxDP_reg_2__3_ ( .D(mult_msb_FFxDN[11]), .CK(ClkxCI), .Q(), 
        .QN(mult_msb_n1) );
  DFF_X1 mult_msb_FFxDP_reg_1__2_ ( .D(mult_msb_FFxDN[6]), .CK(ClkxCI), .Q(), 
        .QN(mult_msb_n12) );
  DFF_X1 mult_msb_FFxDP_reg_2__2_ ( .D(mult_msb_FFxDN[10]), .CK(ClkxCI), .Q(), 
        .QN(mult_msb_n3) );
  DFF_X1 mult_msb_FFxDP_reg_1__0_ ( .D(mult_msb_FFxDN[4]), .CK(ClkxCI), .Q(), 
        .QN(mult_msb_n16) );
  DFF_X1 mult_msb_FFxDP_reg_2__0_ ( .D(mult_msb_FFxDN[8]), .CK(ClkxCI), .Q(), 
        .QN(mult_msb_n7) );
  DFF_X1 mult_msb_FFxDP_reg_0__3_ ( .D(mult_msb_FFxDN[3]), .CK(ClkxCI), .Q(), 
        .QN(mult_msb_n9) );
  DFF_X1 mult_msb_FFxDP_reg_3__3_ ( .D(mult_msb_FFxDN[15]), .CK(ClkxCI), .Q(), 
        .QN(mult_msb_n2) );
  DFF_X1 mult_msb_FFxDP_reg_0__1_ ( .D(mult_msb_FFxDN[1]), .CK(ClkxCI), .Q(), 
        .QN(mult_msb_n13) );
  DFF_X1 mult_msb_FFxDP_reg_3__1_ ( .D(mult_msb_FFxDN[13]), .CK(ClkxCI), .Q(), 
        .QN(mult_msb_n6) );
  DFF_X1 mult_msb_FFxDP_reg_0__2_ ( .D(mult_msb_FFxDN[2]), .CK(ClkxCI), .Q(), 
        .QN(mult_msb_n11) );
  DFF_X1 mult_msb_FFxDP_reg_3__2_ ( .D(mult_msb_FFxDN[14]), .CK(ClkxCI), .Q(), 
        .QN(mult_msb_n4) );
  DFF_X1 mult_msb_FFxDP_reg_0__0_ ( .D(mult_msb_FFxDN[0]), .CK(ClkxCI), .Q(), 
        .QN(mult_msb_n15) );
  DFF_X1 mult_msb_FFxDP_reg_3__0_ ( .D(mult_msb_FFxDN[12]), .CK(ClkxCI), .Q(), 
        .QN(mult_msb_n8) );
  XNOR2_X1 mult_msb_gf4_mul_1_1_U29 ( .A(mult_msb_gf4_mul_1_1_n77), .B(
        mult_msb_gf4_mul_1_1_n76), .ZN(mult_msb_FFxDN[15]) );
  NAND2_X1 mult_msb_gf4_mul_1_1_U28 ( .A1(InverterOutxD[7]), .A2(Y0_4xDP[7]), 
        .ZN(mult_msb_gf4_mul_1_1_n76) );
  XOR2_X1 mult_msb_gf4_mul_1_1_U27 ( .A(mult_msb_gf4_mul_1_1_n75), .B(
        mult_msb_gf4_mul_1_1_n74), .Z(mult_msb_gf4_mul_1_1_n77) );
  XNOR2_X1 mult_msb_gf4_mul_1_1_U26 ( .A(mult_msb_gf4_mul_1_1_n73), .B(
        mult_msb_gf4_mul_1_1_n72), .ZN(mult_msb_FFxDN[14]) );
  NAND2_X1 mult_msb_gf4_mul_1_1_U25 ( .A1(InverterOutxD[6]), .A2(Y0_4xDP[6]), 
        .ZN(mult_msb_gf4_mul_1_1_n72) );
  XOR2_X1 mult_msb_gf4_mul_1_1_U24 ( .A(mult_msb_gf4_mul_1_1_n74), .B(
        mult_msb_gf4_mul_1_1_n71), .Z(mult_msb_gf4_mul_1_1_n73) );
  NOR2_X1 mult_msb_gf4_mul_1_1_U23 ( .A1(mult_msb_gf4_mul_1_1_n70), .A2(
        mult_msb_gf4_mul_1_1_n69), .ZN(mult_msb_gf4_mul_1_1_n74) );
  XNOR2_X1 mult_msb_gf4_mul_1_1_U22 ( .A(InverterOutxD[6]), .B(
        InverterOutxD[7]), .ZN(mult_msb_gf4_mul_1_1_n69) );
  XNOR2_X1 mult_msb_gf4_mul_1_1_U21 ( .A(Y0_4xDP[6]), .B(Y0_4xDP[7]), .ZN(
        mult_msb_gf4_mul_1_1_n70) );
  XNOR2_X1 mult_msb_gf4_mul_1_1_U20 ( .A(mult_msb_gf4_mul_1_1_n68), .B(
        mult_msb_gf4_mul_1_1_n67), .ZN(mult_msb_FFxDN[13]) );
  NAND2_X1 mult_msb_gf4_mul_1_1_U19 ( .A1(InverterOutxD[5]), .A2(Y0_4xDP[5]), 
        .ZN(mult_msb_gf4_mul_1_1_n67) );
  XOR2_X1 mult_msb_gf4_mul_1_1_U18 ( .A(mult_msb_gf4_mul_1_1_n75), .B(
        mult_msb_gf4_mul_1_1_n66), .Z(mult_msb_gf4_mul_1_1_n68) );
  XNOR2_X1 mult_msb_gf4_mul_1_1_U17 ( .A(mult_msb_gf4_mul_1_1_n65), .B(
        mult_msb_gf4_mul_1_1_n64), .ZN(mult_msb_gf4_mul_1_1_n75) );
  NAND2_X1 mult_msb_gf4_mul_1_1_U16 ( .A1(mult_msb_gf4_mul_1_1_n63), .A2(
        mult_msb_gf4_mul_1_1_n62), .ZN(mult_msb_gf4_mul_1_1_n64) );
  XNOR2_X1 mult_msb_gf4_mul_1_1_U15 ( .A(mult_msb_gf4_mul_1_1_n61), .B(
        mult_msb_gf4_mul_1_1_n60), .ZN(mult_msb_gf4_mul_1_1_n62) );
  XNOR2_X1 mult_msb_gf4_mul_1_1_U14 ( .A(mult_msb_gf4_mul_1_1_n59), .B(
        mult_msb_gf4_mul_1_1_n58), .ZN(mult_msb_gf4_mul_1_1_n63) );
  XNOR2_X1 mult_msb_gf4_mul_1_1_U13 ( .A(mult_msb_gf4_mul_1_1_n57), .B(
        mult_msb_gf4_mul_1_1_n56), .ZN(mult_msb_FFxDN[12]) );
  NAND2_X1 mult_msb_gf4_mul_1_1_U12 ( .A1(InverterOutxD[4]), .A2(Y0_4xDP[4]), 
        .ZN(mult_msb_gf4_mul_1_1_n56) );
  XOR2_X1 mult_msb_gf4_mul_1_1_U11 ( .A(mult_msb_gf4_mul_1_1_n66), .B(
        mult_msb_gf4_mul_1_1_n71), .Z(mult_msb_gf4_mul_1_1_n57) );
  XNOR2_X1 mult_msb_gf4_mul_1_1_U10 ( .A(mult_msb_gf4_mul_1_1_n55), .B(
        mult_msb_gf4_mul_1_1_n65), .ZN(mult_msb_gf4_mul_1_1_n71) );
  NOR2_X1 mult_msb_gf4_mul_1_1_U9 ( .A1(mult_msb_gf4_mul_1_1_n61), .A2(
        mult_msb_gf4_mul_1_1_n59), .ZN(mult_msb_gf4_mul_1_1_n65) );
  XNOR2_X1 mult_msb_gf4_mul_1_1_U8 ( .A(InverterOutxD[4]), .B(InverterOutxD[6]), .ZN(mult_msb_gf4_mul_1_1_n59) );
  XNOR2_X1 mult_msb_gf4_mul_1_1_U7 ( .A(Y0_4xDP[4]), .B(Y0_4xDP[6]), .ZN(
        mult_msb_gf4_mul_1_1_n61) );
  NAND2_X1 mult_msb_gf4_mul_1_1_U6 ( .A1(mult_msb_gf4_mul_1_1_n58), .A2(
        mult_msb_gf4_mul_1_1_n60), .ZN(mult_msb_gf4_mul_1_1_n55) );
  XOR2_X1 mult_msb_gf4_mul_1_1_U5 ( .A(Y0_4xDP[5]), .B(Y0_4xDP[7]), .Z(
        mult_msb_gf4_mul_1_1_n60) );
  XOR2_X1 mult_msb_gf4_mul_1_1_U4 ( .A(InverterOutxD[5]), .B(InverterOutxD[7]), 
        .Z(mult_msb_gf4_mul_1_1_n58) );
  NOR2_X1 mult_msb_gf4_mul_1_1_U3 ( .A1(mult_msb_gf4_mul_1_1_n54), .A2(
        mult_msb_gf4_mul_1_1_n53), .ZN(mult_msb_gf4_mul_1_1_n66) );
  XNOR2_X1 mult_msb_gf4_mul_1_1_U2 ( .A(InverterOutxD[4]), .B(InverterOutxD[5]), .ZN(mult_msb_gf4_mul_1_1_n53) );
  XNOR2_X1 mult_msb_gf4_mul_1_1_U1 ( .A(Y0_4xDP[4]), .B(Y0_4xDP[5]), .ZN(
        mult_msb_gf4_mul_1_1_n54) );
  XNOR2_X1 mult_msb_gf4_mul_1_0_U29 ( .A(mult_msb_gf4_mul_1_0_n77), .B(
        mult_msb_gf4_mul_1_0_n76), .ZN(mult_msb_Xi_mul_Yj_2__3_) );
  NAND2_X1 mult_msb_gf4_mul_1_0_U28 ( .A1(InverterOutxD[7]), .A2(Y0_4xDP[3]), 
        .ZN(mult_msb_gf4_mul_1_0_n76) );
  XOR2_X1 mult_msb_gf4_mul_1_0_U27 ( .A(mult_msb_gf4_mul_1_0_n75), .B(
        mult_msb_gf4_mul_1_0_n74), .Z(mult_msb_gf4_mul_1_0_n77) );
  XNOR2_X1 mult_msb_gf4_mul_1_0_U26 ( .A(mult_msb_gf4_mul_1_0_n73), .B(
        mult_msb_gf4_mul_1_0_n72), .ZN(mult_msb_Xi_mul_Yj_2__2_) );
  NAND2_X1 mult_msb_gf4_mul_1_0_U25 ( .A1(InverterOutxD[6]), .A2(Y0_4xDP[2]), 
        .ZN(mult_msb_gf4_mul_1_0_n72) );
  XOR2_X1 mult_msb_gf4_mul_1_0_U24 ( .A(mult_msb_gf4_mul_1_0_n74), .B(
        mult_msb_gf4_mul_1_0_n71), .Z(mult_msb_gf4_mul_1_0_n73) );
  NOR2_X1 mult_msb_gf4_mul_1_0_U23 ( .A1(mult_msb_gf4_mul_1_0_n70), .A2(
        mult_msb_gf4_mul_1_0_n69), .ZN(mult_msb_gf4_mul_1_0_n74) );
  XNOR2_X1 mult_msb_gf4_mul_1_0_U22 ( .A(InverterOutxD[6]), .B(
        InverterOutxD[7]), .ZN(mult_msb_gf4_mul_1_0_n69) );
  XNOR2_X1 mult_msb_gf4_mul_1_0_U21 ( .A(Y0_4xDP[2]), .B(Y0_4xDP[3]), .ZN(
        mult_msb_gf4_mul_1_0_n70) );
  XNOR2_X1 mult_msb_gf4_mul_1_0_U20 ( .A(mult_msb_gf4_mul_1_0_n68), .B(
        mult_msb_gf4_mul_1_0_n67), .ZN(mult_msb_Xi_mul_Yj_2__1_) );
  NAND2_X1 mult_msb_gf4_mul_1_0_U19 ( .A1(InverterOutxD[5]), .A2(Y0_4xDP[1]), 
        .ZN(mult_msb_gf4_mul_1_0_n67) );
  XOR2_X1 mult_msb_gf4_mul_1_0_U18 ( .A(mult_msb_gf4_mul_1_0_n75), .B(
        mult_msb_gf4_mul_1_0_n66), .Z(mult_msb_gf4_mul_1_0_n68) );
  XNOR2_X1 mult_msb_gf4_mul_1_0_U17 ( .A(mult_msb_gf4_mul_1_0_n65), .B(
        mult_msb_gf4_mul_1_0_n64), .ZN(mult_msb_gf4_mul_1_0_n75) );
  NAND2_X1 mult_msb_gf4_mul_1_0_U16 ( .A1(mult_msb_gf4_mul_1_0_n63), .A2(
        mult_msb_gf4_mul_1_0_n62), .ZN(mult_msb_gf4_mul_1_0_n64) );
  XNOR2_X1 mult_msb_gf4_mul_1_0_U15 ( .A(mult_msb_gf4_mul_1_0_n61), .B(
        mult_msb_gf4_mul_1_0_n60), .ZN(mult_msb_gf4_mul_1_0_n62) );
  XNOR2_X1 mult_msb_gf4_mul_1_0_U14 ( .A(mult_msb_gf4_mul_1_0_n59), .B(
        mult_msb_gf4_mul_1_0_n58), .ZN(mult_msb_gf4_mul_1_0_n63) );
  XNOR2_X1 mult_msb_gf4_mul_1_0_U13 ( .A(mult_msb_gf4_mul_1_0_n57), .B(
        mult_msb_gf4_mul_1_0_n56), .ZN(mult_msb_Xi_mul_Yj_2__0_) );
  NAND2_X1 mult_msb_gf4_mul_1_0_U12 ( .A1(InverterOutxD[4]), .A2(Y0_4xDP[0]), 
        .ZN(mult_msb_gf4_mul_1_0_n56) );
  XOR2_X1 mult_msb_gf4_mul_1_0_U11 ( .A(mult_msb_gf4_mul_1_0_n66), .B(
        mult_msb_gf4_mul_1_0_n71), .Z(mult_msb_gf4_mul_1_0_n57) );
  XNOR2_X1 mult_msb_gf4_mul_1_0_U10 ( .A(mult_msb_gf4_mul_1_0_n55), .B(
        mult_msb_gf4_mul_1_0_n65), .ZN(mult_msb_gf4_mul_1_0_n71) );
  NOR2_X1 mult_msb_gf4_mul_1_0_U9 ( .A1(mult_msb_gf4_mul_1_0_n61), .A2(
        mult_msb_gf4_mul_1_0_n59), .ZN(mult_msb_gf4_mul_1_0_n65) );
  XNOR2_X1 mult_msb_gf4_mul_1_0_U8 ( .A(InverterOutxD[4]), .B(InverterOutxD[6]), .ZN(mult_msb_gf4_mul_1_0_n59) );
  XNOR2_X1 mult_msb_gf4_mul_1_0_U7 ( .A(Y0_4xDP[0]), .B(Y0_4xDP[2]), .ZN(
        mult_msb_gf4_mul_1_0_n61) );
  NAND2_X1 mult_msb_gf4_mul_1_0_U6 ( .A1(mult_msb_gf4_mul_1_0_n58), .A2(
        mult_msb_gf4_mul_1_0_n60), .ZN(mult_msb_gf4_mul_1_0_n55) );
  XOR2_X1 mult_msb_gf4_mul_1_0_U5 ( .A(Y0_4xDP[1]), .B(Y0_4xDP[3]), .Z(
        mult_msb_gf4_mul_1_0_n60) );
  XOR2_X1 mult_msb_gf4_mul_1_0_U4 ( .A(InverterOutxD[5]), .B(InverterOutxD[7]), 
        .Z(mult_msb_gf4_mul_1_0_n58) );
  NOR2_X1 mult_msb_gf4_mul_1_0_U3 ( .A1(mult_msb_gf4_mul_1_0_n54), .A2(
        mult_msb_gf4_mul_1_0_n53), .ZN(mult_msb_gf4_mul_1_0_n66) );
  XNOR2_X1 mult_msb_gf4_mul_1_0_U2 ( .A(InverterOutxD[4]), .B(InverterOutxD[5]), .ZN(mult_msb_gf4_mul_1_0_n53) );
  XNOR2_X1 mult_msb_gf4_mul_1_0_U1 ( .A(Y0_4xDP[0]), .B(Y0_4xDP[1]), .ZN(
        mult_msb_gf4_mul_1_0_n54) );
  XNOR2_X1 mult_msb_gf4_mul_0_1_U29 ( .A(mult_msb_gf4_mul_0_1_n77), .B(
        mult_msb_gf4_mul_0_1_n76), .ZN(mult_msb_Xi_mul_Yj_1__3_) );
  NAND2_X1 mult_msb_gf4_mul_0_1_U28 ( .A1(InverterOutxD[3]), .A2(Y0_4xDP[7]), 
        .ZN(mult_msb_gf4_mul_0_1_n76) );
  XOR2_X1 mult_msb_gf4_mul_0_1_U27 ( .A(mult_msb_gf4_mul_0_1_n75), .B(
        mult_msb_gf4_mul_0_1_n74), .Z(mult_msb_gf4_mul_0_1_n77) );
  XNOR2_X1 mult_msb_gf4_mul_0_1_U26 ( .A(mult_msb_gf4_mul_0_1_n73), .B(
        mult_msb_gf4_mul_0_1_n72), .ZN(mult_msb_Xi_mul_Yj_1__2_) );
  NAND2_X1 mult_msb_gf4_mul_0_1_U25 ( .A1(InverterOutxD[2]), .A2(Y0_4xDP[6]), 
        .ZN(mult_msb_gf4_mul_0_1_n72) );
  XOR2_X1 mult_msb_gf4_mul_0_1_U24 ( .A(mult_msb_gf4_mul_0_1_n74), .B(
        mult_msb_gf4_mul_0_1_n71), .Z(mult_msb_gf4_mul_0_1_n73) );
  NOR2_X1 mult_msb_gf4_mul_0_1_U23 ( .A1(mult_msb_gf4_mul_0_1_n70), .A2(
        mult_msb_gf4_mul_0_1_n69), .ZN(mult_msb_gf4_mul_0_1_n74) );
  XNOR2_X1 mult_msb_gf4_mul_0_1_U22 ( .A(InverterOutxD[2]), .B(
        InverterOutxD[3]), .ZN(mult_msb_gf4_mul_0_1_n69) );
  XNOR2_X1 mult_msb_gf4_mul_0_1_U21 ( .A(Y0_4xDP[6]), .B(Y0_4xDP[7]), .ZN(
        mult_msb_gf4_mul_0_1_n70) );
  XNOR2_X1 mult_msb_gf4_mul_0_1_U20 ( .A(mult_msb_gf4_mul_0_1_n68), .B(
        mult_msb_gf4_mul_0_1_n67), .ZN(mult_msb_Xi_mul_Yj_1__1_) );
  NAND2_X1 mult_msb_gf4_mul_0_1_U19 ( .A1(InverterOutxD[1]), .A2(Y0_4xDP[5]), 
        .ZN(mult_msb_gf4_mul_0_1_n67) );
  XOR2_X1 mult_msb_gf4_mul_0_1_U18 ( .A(mult_msb_gf4_mul_0_1_n75), .B(
        mult_msb_gf4_mul_0_1_n66), .Z(mult_msb_gf4_mul_0_1_n68) );
  XNOR2_X1 mult_msb_gf4_mul_0_1_U17 ( .A(mult_msb_gf4_mul_0_1_n65), .B(
        mult_msb_gf4_mul_0_1_n64), .ZN(mult_msb_gf4_mul_0_1_n75) );
  NAND2_X1 mult_msb_gf4_mul_0_1_U16 ( .A1(mult_msb_gf4_mul_0_1_n63), .A2(
        mult_msb_gf4_mul_0_1_n62), .ZN(mult_msb_gf4_mul_0_1_n64) );
  XNOR2_X1 mult_msb_gf4_mul_0_1_U15 ( .A(mult_msb_gf4_mul_0_1_n61), .B(
        mult_msb_gf4_mul_0_1_n60), .ZN(mult_msb_gf4_mul_0_1_n62) );
  XNOR2_X1 mult_msb_gf4_mul_0_1_U14 ( .A(mult_msb_gf4_mul_0_1_n59), .B(
        mult_msb_gf4_mul_0_1_n58), .ZN(mult_msb_gf4_mul_0_1_n63) );
  XNOR2_X1 mult_msb_gf4_mul_0_1_U13 ( .A(mult_msb_gf4_mul_0_1_n57), .B(
        mult_msb_gf4_mul_0_1_n56), .ZN(mult_msb_Xi_mul_Yj_1__0_) );
  NAND2_X1 mult_msb_gf4_mul_0_1_U12 ( .A1(InverterOutxD[0]), .A2(Y0_4xDP[4]), 
        .ZN(mult_msb_gf4_mul_0_1_n56) );
  XOR2_X1 mult_msb_gf4_mul_0_1_U11 ( .A(mult_msb_gf4_mul_0_1_n66), .B(
        mult_msb_gf4_mul_0_1_n71), .Z(mult_msb_gf4_mul_0_1_n57) );
  XNOR2_X1 mult_msb_gf4_mul_0_1_U10 ( .A(mult_msb_gf4_mul_0_1_n55), .B(
        mult_msb_gf4_mul_0_1_n65), .ZN(mult_msb_gf4_mul_0_1_n71) );
  NOR2_X1 mult_msb_gf4_mul_0_1_U9 ( .A1(mult_msb_gf4_mul_0_1_n61), .A2(
        mult_msb_gf4_mul_0_1_n59), .ZN(mult_msb_gf4_mul_0_1_n65) );
  XNOR2_X1 mult_msb_gf4_mul_0_1_U8 ( .A(InverterOutxD[0]), .B(InverterOutxD[2]), .ZN(mult_msb_gf4_mul_0_1_n59) );
  XNOR2_X1 mult_msb_gf4_mul_0_1_U7 ( .A(Y0_4xDP[4]), .B(Y0_4xDP[6]), .ZN(
        mult_msb_gf4_mul_0_1_n61) );
  NAND2_X1 mult_msb_gf4_mul_0_1_U6 ( .A1(mult_msb_gf4_mul_0_1_n58), .A2(
        mult_msb_gf4_mul_0_1_n60), .ZN(mult_msb_gf4_mul_0_1_n55) );
  XOR2_X1 mult_msb_gf4_mul_0_1_U5 ( .A(Y0_4xDP[5]), .B(Y0_4xDP[7]), .Z(
        mult_msb_gf4_mul_0_1_n60) );
  XOR2_X1 mult_msb_gf4_mul_0_1_U4 ( .A(InverterOutxD[1]), .B(InverterOutxD[3]), 
        .Z(mult_msb_gf4_mul_0_1_n58) );
  NOR2_X1 mult_msb_gf4_mul_0_1_U3 ( .A1(mult_msb_gf4_mul_0_1_n54), .A2(
        mult_msb_gf4_mul_0_1_n53), .ZN(mult_msb_gf4_mul_0_1_n66) );
  XNOR2_X1 mult_msb_gf4_mul_0_1_U2 ( .A(InverterOutxD[0]), .B(InverterOutxD[1]), .ZN(mult_msb_gf4_mul_0_1_n53) );
  XNOR2_X1 mult_msb_gf4_mul_0_1_U1 ( .A(Y0_4xDP[4]), .B(Y0_4xDP[5]), .ZN(
        mult_msb_gf4_mul_0_1_n54) );
  XNOR2_X1 mult_msb_gf4_mul_0_0_U29 ( .A(mult_msb_gf4_mul_0_0_n77), .B(
        mult_msb_gf4_mul_0_0_n76), .ZN(mult_msb_FFxDN[3]) );
  NAND2_X1 mult_msb_gf4_mul_0_0_U28 ( .A1(InverterOutxD[3]), .A2(Y0_4xDP[3]), 
        .ZN(mult_msb_gf4_mul_0_0_n76) );
  XOR2_X1 mult_msb_gf4_mul_0_0_U27 ( .A(mult_msb_gf4_mul_0_0_n75), .B(
        mult_msb_gf4_mul_0_0_n74), .Z(mult_msb_gf4_mul_0_0_n77) );
  XNOR2_X1 mult_msb_gf4_mul_0_0_U26 ( .A(mult_msb_gf4_mul_0_0_n73), .B(
        mult_msb_gf4_mul_0_0_n72), .ZN(mult_msb_FFxDN[2]) );
  NAND2_X1 mult_msb_gf4_mul_0_0_U25 ( .A1(InverterOutxD[2]), .A2(Y0_4xDP[2]), 
        .ZN(mult_msb_gf4_mul_0_0_n72) );
  XOR2_X1 mult_msb_gf4_mul_0_0_U24 ( .A(mult_msb_gf4_mul_0_0_n74), .B(
        mult_msb_gf4_mul_0_0_n71), .Z(mult_msb_gf4_mul_0_0_n73) );
  NOR2_X1 mult_msb_gf4_mul_0_0_U23 ( .A1(mult_msb_gf4_mul_0_0_n70), .A2(
        mult_msb_gf4_mul_0_0_n69), .ZN(mult_msb_gf4_mul_0_0_n74) );
  XNOR2_X1 mult_msb_gf4_mul_0_0_U22 ( .A(InverterOutxD[2]), .B(
        InverterOutxD[3]), .ZN(mult_msb_gf4_mul_0_0_n69) );
  XNOR2_X1 mult_msb_gf4_mul_0_0_U21 ( .A(Y0_4xDP[2]), .B(Y0_4xDP[3]), .ZN(
        mult_msb_gf4_mul_0_0_n70) );
  XNOR2_X1 mult_msb_gf4_mul_0_0_U20 ( .A(mult_msb_gf4_mul_0_0_n68), .B(
        mult_msb_gf4_mul_0_0_n67), .ZN(mult_msb_FFxDN[1]) );
  NAND2_X1 mult_msb_gf4_mul_0_0_U19 ( .A1(InverterOutxD[1]), .A2(Y0_4xDP[1]), 
        .ZN(mult_msb_gf4_mul_0_0_n67) );
  XOR2_X1 mult_msb_gf4_mul_0_0_U18 ( .A(mult_msb_gf4_mul_0_0_n75), .B(
        mult_msb_gf4_mul_0_0_n66), .Z(mult_msb_gf4_mul_0_0_n68) );
  XNOR2_X1 mult_msb_gf4_mul_0_0_U17 ( .A(mult_msb_gf4_mul_0_0_n65), .B(
        mult_msb_gf4_mul_0_0_n64), .ZN(mult_msb_gf4_mul_0_0_n75) );
  NAND2_X1 mult_msb_gf4_mul_0_0_U16 ( .A1(mult_msb_gf4_mul_0_0_n63), .A2(
        mult_msb_gf4_mul_0_0_n62), .ZN(mult_msb_gf4_mul_0_0_n64) );
  XNOR2_X1 mult_msb_gf4_mul_0_0_U15 ( .A(mult_msb_gf4_mul_0_0_n61), .B(
        mult_msb_gf4_mul_0_0_n60), .ZN(mult_msb_gf4_mul_0_0_n62) );
  XNOR2_X1 mult_msb_gf4_mul_0_0_U14 ( .A(mult_msb_gf4_mul_0_0_n59), .B(
        mult_msb_gf4_mul_0_0_n58), .ZN(mult_msb_gf4_mul_0_0_n63) );
  XNOR2_X1 mult_msb_gf4_mul_0_0_U13 ( .A(mult_msb_gf4_mul_0_0_n57), .B(
        mult_msb_gf4_mul_0_0_n56), .ZN(mult_msb_FFxDN[0]) );
  NAND2_X1 mult_msb_gf4_mul_0_0_U12 ( .A1(InverterOutxD[0]), .A2(Y0_4xDP[0]), 
        .ZN(mult_msb_gf4_mul_0_0_n56) );
  XOR2_X1 mult_msb_gf4_mul_0_0_U11 ( .A(mult_msb_gf4_mul_0_0_n66), .B(
        mult_msb_gf4_mul_0_0_n71), .Z(mult_msb_gf4_mul_0_0_n57) );
  XNOR2_X1 mult_msb_gf4_mul_0_0_U10 ( .A(mult_msb_gf4_mul_0_0_n55), .B(
        mult_msb_gf4_mul_0_0_n65), .ZN(mult_msb_gf4_mul_0_0_n71) );
  NOR2_X1 mult_msb_gf4_mul_0_0_U9 ( .A1(mult_msb_gf4_mul_0_0_n61), .A2(
        mult_msb_gf4_mul_0_0_n59), .ZN(mult_msb_gf4_mul_0_0_n65) );
  XNOR2_X1 mult_msb_gf4_mul_0_0_U8 ( .A(InverterOutxD[0]), .B(InverterOutxD[2]), .ZN(mult_msb_gf4_mul_0_0_n59) );
  XNOR2_X1 mult_msb_gf4_mul_0_0_U7 ( .A(Y0_4xDP[0]), .B(Y0_4xDP[2]), .ZN(
        mult_msb_gf4_mul_0_0_n61) );
  NAND2_X1 mult_msb_gf4_mul_0_0_U6 ( .A1(mult_msb_gf4_mul_0_0_n58), .A2(
        mult_msb_gf4_mul_0_0_n60), .ZN(mult_msb_gf4_mul_0_0_n55) );
  XOR2_X1 mult_msb_gf4_mul_0_0_U5 ( .A(Y0_4xDP[1]), .B(Y0_4xDP[3]), .Z(
        mult_msb_gf4_mul_0_0_n60) );
  XOR2_X1 mult_msb_gf4_mul_0_0_U4 ( .A(InverterOutxD[1]), .B(InverterOutxD[3]), 
        .Z(mult_msb_gf4_mul_0_0_n58) );
  NOR2_X1 mult_msb_gf4_mul_0_0_U3 ( .A1(mult_msb_gf4_mul_0_0_n54), .A2(
        mult_msb_gf4_mul_0_0_n53), .ZN(mult_msb_gf4_mul_0_0_n66) );
  XNOR2_X1 mult_msb_gf4_mul_0_0_U2 ( .A(InverterOutxD[0]), .B(InverterOutxD[1]), .ZN(mult_msb_gf4_mul_0_0_n53) );
  XNOR2_X1 mult_msb_gf4_mul_0_0_U1 ( .A(Y0_4xDP[0]), .B(Y0_4xDP[1]), .ZN(
        mult_msb_gf4_mul_0_0_n54) );
  XOR2_X1 mult_lsb_U18 ( .A(mult_lsb_n31), .B(mult_lsb_n32), .Z(
        InvUnmappedxD[11]) );
  XOR2_X1 mult_lsb_U17 ( .A(mult_lsb_n29), .B(mult_lsb_n30), .Z(
        InvUnmappedxD[10]) );
  XOR2_X1 mult_lsb_U16 ( .A(mult_lsb_n27), .B(mult_lsb_n28), .Z(
        InvUnmappedxD[9]) );
  XOR2_X1 mult_lsb_U15 ( .A(mult_lsb_n25), .B(mult_lsb_n26), .Z(
        InvUnmappedxD[8]) );
  XOR2_X1 mult_lsb_U14 ( .A(mult_lsb_n23), .B(mult_lsb_n24), .Z(
        InvUnmappedxD[3]) );
  XOR2_X1 mult_lsb_U13 ( .A(mult_lsb_n21), .B(mult_lsb_n22), .Z(
        InvUnmappedxD[2]) );
  XOR2_X1 mult_lsb_U12 ( .A(mult_lsb_n19), .B(mult_lsb_n20), .Z(
        InvUnmappedxD[1]) );
  XOR2_X1 mult_lsb_U11 ( .A(mult_lsb_n17), .B(mult_lsb_n18), .Z(
        InvUnmappedxD[0]) );
  XOR2_X1 mult_lsb_U10 ( .A(Zmul3xDI[3]), .B(mult_lsb_Xi_mul_Yj_2__3_), .Z(
        mult_lsb_FFxDN[11]) );
  XOR2_X1 mult_lsb_U9 ( .A(Zmul3xDI[2]), .B(mult_lsb_Xi_mul_Yj_2__2_), .Z(
        mult_lsb_FFxDN[10]) );
  XOR2_X1 mult_lsb_U8 ( .A(Zmul3xDI[1]), .B(mult_lsb_Xi_mul_Yj_2__1_), .Z(
        mult_lsb_FFxDN[9]) );
  XOR2_X1 mult_lsb_U7 ( .A(Zmul3xDI[0]), .B(mult_lsb_Xi_mul_Yj_2__0_), .Z(
        mult_lsb_FFxDN[8]) );
  XOR2_X1 mult_lsb_U6 ( .A(Zmul3xDI[3]), .B(mult_lsb_Xi_mul_Yj_1__3_), .Z(
        mult_lsb_FFxDN[7]) );
  XOR2_X1 mult_lsb_U5 ( .A(Zmul3xDI[2]), .B(mult_lsb_Xi_mul_Yj_1__2_), .Z(
        mult_lsb_FFxDN[6]) );
  XOR2_X1 mult_lsb_U4 ( .A(Zmul3xDI[1]), .B(mult_lsb_Xi_mul_Yj_1__1_), .Z(
        mult_lsb_FFxDN[5]) );
  XOR2_X1 mult_lsb_U3 ( .A(Zmul3xDI[0]), .B(mult_lsb_Xi_mul_Yj_1__0_), .Z(
        mult_lsb_FFxDN[4]) );
  DFF_X1 mult_lsb_FFxDP_reg_1__1_ ( .D(mult_lsb_FFxDN[5]), .CK(ClkxCI), .Q(), 
        .QN(mult_lsb_n19) );
  DFF_X1 mult_lsb_FFxDP_reg_1__3_ ( .D(mult_lsb_FFxDN[7]), .CK(ClkxCI), .Q(), 
        .QN(mult_lsb_n23) );
  DFF_X1 mult_lsb_FFxDP_reg_2__1_ ( .D(mult_lsb_FFxDN[9]), .CK(ClkxCI), .Q(), 
        .QN(mult_lsb_n28) );
  DFF_X1 mult_lsb_FFxDP_reg_2__3_ ( .D(mult_lsb_FFxDN[11]), .CK(ClkxCI), .Q(), 
        .QN(mult_lsb_n32) );
  DFF_X1 mult_lsb_FFxDP_reg_1__2_ ( .D(mult_lsb_FFxDN[6]), .CK(ClkxCI), .Q(), 
        .QN(mult_lsb_n21) );
  DFF_X1 mult_lsb_FFxDP_reg_2__2_ ( .D(mult_lsb_FFxDN[10]), .CK(ClkxCI), .Q(), 
        .QN(mult_lsb_n30) );
  DFF_X1 mult_lsb_FFxDP_reg_1__0_ ( .D(mult_lsb_FFxDN[4]), .CK(ClkxCI), .Q(), 
        .QN(mult_lsb_n17) );
  DFF_X1 mult_lsb_FFxDP_reg_2__0_ ( .D(mult_lsb_FFxDN[8]), .CK(ClkxCI), .Q(), 
        .QN(mult_lsb_n26) );
  DFF_X1 mult_lsb_FFxDP_reg_0__3_ ( .D(mult_lsb_FFxDN[3]), .CK(ClkxCI), .Q(), 
        .QN(mult_lsb_n24) );
  DFF_X1 mult_lsb_FFxDP_reg_3__3_ ( .D(mult_lsb_FFxDN[15]), .CK(ClkxCI), .Q(), 
        .QN(mult_lsb_n31) );
  DFF_X1 mult_lsb_FFxDP_reg_0__1_ ( .D(mult_lsb_FFxDN[1]), .CK(ClkxCI), .Q(), 
        .QN(mult_lsb_n20) );
  DFF_X1 mult_lsb_FFxDP_reg_3__1_ ( .D(mult_lsb_FFxDN[13]), .CK(ClkxCI), .Q(), 
        .QN(mult_lsb_n27) );
  DFF_X1 mult_lsb_FFxDP_reg_0__2_ ( .D(mult_lsb_FFxDN[2]), .CK(ClkxCI), .Q(), 
        .QN(mult_lsb_n22) );
  DFF_X1 mult_lsb_FFxDP_reg_3__2_ ( .D(mult_lsb_FFxDN[14]), .CK(ClkxCI), .Q(), 
        .QN(mult_lsb_n29) );
  DFF_X1 mult_lsb_FFxDP_reg_0__0_ ( .D(mult_lsb_FFxDN[0]), .CK(ClkxCI), .Q(), 
        .QN(mult_lsb_n18) );
  DFF_X1 mult_lsb_FFxDP_reg_3__0_ ( .D(mult_lsb_FFxDN[12]), .CK(ClkxCI), .Q(), 
        .QN(mult_lsb_n25) );
  XNOR2_X1 mult_lsb_gf4_mul_1_1_U29 ( .A(mult_lsb_gf4_mul_1_1_n77), .B(
        mult_lsb_gf4_mul_1_1_n76), .ZN(mult_lsb_FFxDN[15]) );
  NAND2_X1 mult_lsb_gf4_mul_1_1_U28 ( .A1(InverterOutxD[7]), .A2(Y1_4xDP[7]), 
        .ZN(mult_lsb_gf4_mul_1_1_n76) );
  XOR2_X1 mult_lsb_gf4_mul_1_1_U27 ( .A(mult_lsb_gf4_mul_1_1_n75), .B(
        mult_lsb_gf4_mul_1_1_n74), .Z(mult_lsb_gf4_mul_1_1_n77) );
  XNOR2_X1 mult_lsb_gf4_mul_1_1_U26 ( .A(mult_lsb_gf4_mul_1_1_n73), .B(
        mult_lsb_gf4_mul_1_1_n72), .ZN(mult_lsb_FFxDN[14]) );
  NAND2_X1 mult_lsb_gf4_mul_1_1_U25 ( .A1(InverterOutxD[6]), .A2(Y1_4xDP[6]), 
        .ZN(mult_lsb_gf4_mul_1_1_n72) );
  XOR2_X1 mult_lsb_gf4_mul_1_1_U24 ( .A(mult_lsb_gf4_mul_1_1_n74), .B(
        mult_lsb_gf4_mul_1_1_n71), .Z(mult_lsb_gf4_mul_1_1_n73) );
  NOR2_X1 mult_lsb_gf4_mul_1_1_U23 ( .A1(mult_lsb_gf4_mul_1_1_n70), .A2(
        mult_lsb_gf4_mul_1_1_n69), .ZN(mult_lsb_gf4_mul_1_1_n74) );
  XNOR2_X1 mult_lsb_gf4_mul_1_1_U22 ( .A(InverterOutxD[6]), .B(
        InverterOutxD[7]), .ZN(mult_lsb_gf4_mul_1_1_n69) );
  XNOR2_X1 mult_lsb_gf4_mul_1_1_U21 ( .A(Y1_4xDP[6]), .B(Y1_4xDP[7]), .ZN(
        mult_lsb_gf4_mul_1_1_n70) );
  XNOR2_X1 mult_lsb_gf4_mul_1_1_U20 ( .A(mult_lsb_gf4_mul_1_1_n68), .B(
        mult_lsb_gf4_mul_1_1_n67), .ZN(mult_lsb_FFxDN[13]) );
  NAND2_X1 mult_lsb_gf4_mul_1_1_U19 ( .A1(InverterOutxD[5]), .A2(Y1_4xDP[5]), 
        .ZN(mult_lsb_gf4_mul_1_1_n67) );
  XOR2_X1 mult_lsb_gf4_mul_1_1_U18 ( .A(mult_lsb_gf4_mul_1_1_n75), .B(
        mult_lsb_gf4_mul_1_1_n66), .Z(mult_lsb_gf4_mul_1_1_n68) );
  XNOR2_X1 mult_lsb_gf4_mul_1_1_U17 ( .A(mult_lsb_gf4_mul_1_1_n65), .B(
        mult_lsb_gf4_mul_1_1_n64), .ZN(mult_lsb_gf4_mul_1_1_n75) );
  NAND2_X1 mult_lsb_gf4_mul_1_1_U16 ( .A1(mult_lsb_gf4_mul_1_1_n63), .A2(
        mult_lsb_gf4_mul_1_1_n62), .ZN(mult_lsb_gf4_mul_1_1_n64) );
  XNOR2_X1 mult_lsb_gf4_mul_1_1_U15 ( .A(mult_lsb_gf4_mul_1_1_n61), .B(
        mult_lsb_gf4_mul_1_1_n60), .ZN(mult_lsb_gf4_mul_1_1_n62) );
  XNOR2_X1 mult_lsb_gf4_mul_1_1_U14 ( .A(mult_lsb_gf4_mul_1_1_n59), .B(
        mult_lsb_gf4_mul_1_1_n58), .ZN(mult_lsb_gf4_mul_1_1_n63) );
  XNOR2_X1 mult_lsb_gf4_mul_1_1_U13 ( .A(mult_lsb_gf4_mul_1_1_n57), .B(
        mult_lsb_gf4_mul_1_1_n56), .ZN(mult_lsb_FFxDN[12]) );
  NAND2_X1 mult_lsb_gf4_mul_1_1_U12 ( .A1(InverterOutxD[4]), .A2(Y1_4xDP[4]), 
        .ZN(mult_lsb_gf4_mul_1_1_n56) );
  XOR2_X1 mult_lsb_gf4_mul_1_1_U11 ( .A(mult_lsb_gf4_mul_1_1_n66), .B(
        mult_lsb_gf4_mul_1_1_n71), .Z(mult_lsb_gf4_mul_1_1_n57) );
  XNOR2_X1 mult_lsb_gf4_mul_1_1_U10 ( .A(mult_lsb_gf4_mul_1_1_n55), .B(
        mult_lsb_gf4_mul_1_1_n65), .ZN(mult_lsb_gf4_mul_1_1_n71) );
  NOR2_X1 mult_lsb_gf4_mul_1_1_U9 ( .A1(mult_lsb_gf4_mul_1_1_n61), .A2(
        mult_lsb_gf4_mul_1_1_n59), .ZN(mult_lsb_gf4_mul_1_1_n65) );
  XNOR2_X1 mult_lsb_gf4_mul_1_1_U8 ( .A(InverterOutxD[4]), .B(InverterOutxD[6]), .ZN(mult_lsb_gf4_mul_1_1_n59) );
  XNOR2_X1 mult_lsb_gf4_mul_1_1_U7 ( .A(Y1_4xDP[4]), .B(Y1_4xDP[6]), .ZN(
        mult_lsb_gf4_mul_1_1_n61) );
  NAND2_X1 mult_lsb_gf4_mul_1_1_U6 ( .A1(mult_lsb_gf4_mul_1_1_n58), .A2(
        mult_lsb_gf4_mul_1_1_n60), .ZN(mult_lsb_gf4_mul_1_1_n55) );
  XOR2_X1 mult_lsb_gf4_mul_1_1_U5 ( .A(Y1_4xDP[5]), .B(Y1_4xDP[7]), .Z(
        mult_lsb_gf4_mul_1_1_n60) );
  XOR2_X1 mult_lsb_gf4_mul_1_1_U4 ( .A(InverterOutxD[5]), .B(InverterOutxD[7]), 
        .Z(mult_lsb_gf4_mul_1_1_n58) );
  NOR2_X1 mult_lsb_gf4_mul_1_1_U3 ( .A1(mult_lsb_gf4_mul_1_1_n54), .A2(
        mult_lsb_gf4_mul_1_1_n53), .ZN(mult_lsb_gf4_mul_1_1_n66) );
  XNOR2_X1 mult_lsb_gf4_mul_1_1_U2 ( .A(InverterOutxD[4]), .B(InverterOutxD[5]), .ZN(mult_lsb_gf4_mul_1_1_n53) );
  XNOR2_X1 mult_lsb_gf4_mul_1_1_U1 ( .A(Y1_4xDP[4]), .B(Y1_4xDP[5]), .ZN(
        mult_lsb_gf4_mul_1_1_n54) );
  XNOR2_X1 mult_lsb_gf4_mul_1_0_U29 ( .A(mult_lsb_gf4_mul_1_0_n77), .B(
        mult_lsb_gf4_mul_1_0_n76), .ZN(mult_lsb_Xi_mul_Yj_2__3_) );
  NAND2_X1 mult_lsb_gf4_mul_1_0_U28 ( .A1(InverterOutxD[7]), .A2(Y1_4xDP[3]), 
        .ZN(mult_lsb_gf4_mul_1_0_n76) );
  XOR2_X1 mult_lsb_gf4_mul_1_0_U27 ( .A(mult_lsb_gf4_mul_1_0_n75), .B(
        mult_lsb_gf4_mul_1_0_n74), .Z(mult_lsb_gf4_mul_1_0_n77) );
  XNOR2_X1 mult_lsb_gf4_mul_1_0_U26 ( .A(mult_lsb_gf4_mul_1_0_n73), .B(
        mult_lsb_gf4_mul_1_0_n72), .ZN(mult_lsb_Xi_mul_Yj_2__2_) );
  NAND2_X1 mult_lsb_gf4_mul_1_0_U25 ( .A1(InverterOutxD[6]), .A2(Y1_4xDP[2]), 
        .ZN(mult_lsb_gf4_mul_1_0_n72) );
  XOR2_X1 mult_lsb_gf4_mul_1_0_U24 ( .A(mult_lsb_gf4_mul_1_0_n74), .B(
        mult_lsb_gf4_mul_1_0_n71), .Z(mult_lsb_gf4_mul_1_0_n73) );
  NOR2_X1 mult_lsb_gf4_mul_1_0_U23 ( .A1(mult_lsb_gf4_mul_1_0_n70), .A2(
        mult_lsb_gf4_mul_1_0_n69), .ZN(mult_lsb_gf4_mul_1_0_n74) );
  XNOR2_X1 mult_lsb_gf4_mul_1_0_U22 ( .A(InverterOutxD[6]), .B(
        InverterOutxD[7]), .ZN(mult_lsb_gf4_mul_1_0_n69) );
  XNOR2_X1 mult_lsb_gf4_mul_1_0_U21 ( .A(Y1_4xDP[2]), .B(Y1_4xDP[3]), .ZN(
        mult_lsb_gf4_mul_1_0_n70) );
  XNOR2_X1 mult_lsb_gf4_mul_1_0_U20 ( .A(mult_lsb_gf4_mul_1_0_n68), .B(
        mult_lsb_gf4_mul_1_0_n67), .ZN(mult_lsb_Xi_mul_Yj_2__1_) );
  NAND2_X1 mult_lsb_gf4_mul_1_0_U19 ( .A1(InverterOutxD[5]), .A2(Y1_4xDP[1]), 
        .ZN(mult_lsb_gf4_mul_1_0_n67) );
  XOR2_X1 mult_lsb_gf4_mul_1_0_U18 ( .A(mult_lsb_gf4_mul_1_0_n75), .B(
        mult_lsb_gf4_mul_1_0_n66), .Z(mult_lsb_gf4_mul_1_0_n68) );
  XNOR2_X1 mult_lsb_gf4_mul_1_0_U17 ( .A(mult_lsb_gf4_mul_1_0_n65), .B(
        mult_lsb_gf4_mul_1_0_n64), .ZN(mult_lsb_gf4_mul_1_0_n75) );
  NAND2_X1 mult_lsb_gf4_mul_1_0_U16 ( .A1(mult_lsb_gf4_mul_1_0_n63), .A2(
        mult_lsb_gf4_mul_1_0_n62), .ZN(mult_lsb_gf4_mul_1_0_n64) );
  XNOR2_X1 mult_lsb_gf4_mul_1_0_U15 ( .A(mult_lsb_gf4_mul_1_0_n61), .B(
        mult_lsb_gf4_mul_1_0_n60), .ZN(mult_lsb_gf4_mul_1_0_n62) );
  XNOR2_X1 mult_lsb_gf4_mul_1_0_U14 ( .A(mult_lsb_gf4_mul_1_0_n59), .B(
        mult_lsb_gf4_mul_1_0_n58), .ZN(mult_lsb_gf4_mul_1_0_n63) );
  XNOR2_X1 mult_lsb_gf4_mul_1_0_U13 ( .A(mult_lsb_gf4_mul_1_0_n57), .B(
        mult_lsb_gf4_mul_1_0_n56), .ZN(mult_lsb_Xi_mul_Yj_2__0_) );
  NAND2_X1 mult_lsb_gf4_mul_1_0_U12 ( .A1(InverterOutxD[4]), .A2(Y1_4xDP[0]), 
        .ZN(mult_lsb_gf4_mul_1_0_n56) );
  XOR2_X1 mult_lsb_gf4_mul_1_0_U11 ( .A(mult_lsb_gf4_mul_1_0_n66), .B(
        mult_lsb_gf4_mul_1_0_n71), .Z(mult_lsb_gf4_mul_1_0_n57) );
  XNOR2_X1 mult_lsb_gf4_mul_1_0_U10 ( .A(mult_lsb_gf4_mul_1_0_n55), .B(
        mult_lsb_gf4_mul_1_0_n65), .ZN(mult_lsb_gf4_mul_1_0_n71) );
  NOR2_X1 mult_lsb_gf4_mul_1_0_U9 ( .A1(mult_lsb_gf4_mul_1_0_n61), .A2(
        mult_lsb_gf4_mul_1_0_n59), .ZN(mult_lsb_gf4_mul_1_0_n65) );
  XNOR2_X1 mult_lsb_gf4_mul_1_0_U8 ( .A(InverterOutxD[4]), .B(InverterOutxD[6]), .ZN(mult_lsb_gf4_mul_1_0_n59) );
  XNOR2_X1 mult_lsb_gf4_mul_1_0_U7 ( .A(Y1_4xDP[0]), .B(Y1_4xDP[2]), .ZN(
        mult_lsb_gf4_mul_1_0_n61) );
  NAND2_X1 mult_lsb_gf4_mul_1_0_U6 ( .A1(mult_lsb_gf4_mul_1_0_n58), .A2(
        mult_lsb_gf4_mul_1_0_n60), .ZN(mult_lsb_gf4_mul_1_0_n55) );
  XOR2_X1 mult_lsb_gf4_mul_1_0_U5 ( .A(Y1_4xDP[1]), .B(Y1_4xDP[3]), .Z(
        mult_lsb_gf4_mul_1_0_n60) );
  XOR2_X1 mult_lsb_gf4_mul_1_0_U4 ( .A(InverterOutxD[5]), .B(InverterOutxD[7]), 
        .Z(mult_lsb_gf4_mul_1_0_n58) );
  NOR2_X1 mult_lsb_gf4_mul_1_0_U3 ( .A1(mult_lsb_gf4_mul_1_0_n54), .A2(
        mult_lsb_gf4_mul_1_0_n53), .ZN(mult_lsb_gf4_mul_1_0_n66) );
  XNOR2_X1 mult_lsb_gf4_mul_1_0_U2 ( .A(InverterOutxD[4]), .B(InverterOutxD[5]), .ZN(mult_lsb_gf4_mul_1_0_n53) );
  XNOR2_X1 mult_lsb_gf4_mul_1_0_U1 ( .A(Y1_4xDP[0]), .B(Y1_4xDP[1]), .ZN(
        mult_lsb_gf4_mul_1_0_n54) );
  XNOR2_X1 mult_lsb_gf4_mul_0_1_U29 ( .A(mult_lsb_gf4_mul_0_1_n77), .B(
        mult_lsb_gf4_mul_0_1_n76), .ZN(mult_lsb_Xi_mul_Yj_1__3_) );
  NAND2_X1 mult_lsb_gf4_mul_0_1_U28 ( .A1(InverterOutxD[3]), .A2(Y1_4xDP[7]), 
        .ZN(mult_lsb_gf4_mul_0_1_n76) );
  XOR2_X1 mult_lsb_gf4_mul_0_1_U27 ( .A(mult_lsb_gf4_mul_0_1_n75), .B(
        mult_lsb_gf4_mul_0_1_n74), .Z(mult_lsb_gf4_mul_0_1_n77) );
  XNOR2_X1 mult_lsb_gf4_mul_0_1_U26 ( .A(mult_lsb_gf4_mul_0_1_n73), .B(
        mult_lsb_gf4_mul_0_1_n72), .ZN(mult_lsb_Xi_mul_Yj_1__2_) );
  NAND2_X1 mult_lsb_gf4_mul_0_1_U25 ( .A1(InverterOutxD[2]), .A2(Y1_4xDP[6]), 
        .ZN(mult_lsb_gf4_mul_0_1_n72) );
  XOR2_X1 mult_lsb_gf4_mul_0_1_U24 ( .A(mult_lsb_gf4_mul_0_1_n74), .B(
        mult_lsb_gf4_mul_0_1_n71), .Z(mult_lsb_gf4_mul_0_1_n73) );
  NOR2_X1 mult_lsb_gf4_mul_0_1_U23 ( .A1(mult_lsb_gf4_mul_0_1_n70), .A2(
        mult_lsb_gf4_mul_0_1_n69), .ZN(mult_lsb_gf4_mul_0_1_n74) );
  XNOR2_X1 mult_lsb_gf4_mul_0_1_U22 ( .A(InverterOutxD[2]), .B(
        InverterOutxD[3]), .ZN(mult_lsb_gf4_mul_0_1_n69) );
  XNOR2_X1 mult_lsb_gf4_mul_0_1_U21 ( .A(Y1_4xDP[6]), .B(Y1_4xDP[7]), .ZN(
        mult_lsb_gf4_mul_0_1_n70) );
  XNOR2_X1 mult_lsb_gf4_mul_0_1_U20 ( .A(mult_lsb_gf4_mul_0_1_n68), .B(
        mult_lsb_gf4_mul_0_1_n67), .ZN(mult_lsb_Xi_mul_Yj_1__1_) );
  NAND2_X1 mult_lsb_gf4_mul_0_1_U19 ( .A1(InverterOutxD[1]), .A2(Y1_4xDP[5]), 
        .ZN(mult_lsb_gf4_mul_0_1_n67) );
  XOR2_X1 mult_lsb_gf4_mul_0_1_U18 ( .A(mult_lsb_gf4_mul_0_1_n75), .B(
        mult_lsb_gf4_mul_0_1_n66), .Z(mult_lsb_gf4_mul_0_1_n68) );
  XNOR2_X1 mult_lsb_gf4_mul_0_1_U17 ( .A(mult_lsb_gf4_mul_0_1_n65), .B(
        mult_lsb_gf4_mul_0_1_n64), .ZN(mult_lsb_gf4_mul_0_1_n75) );
  NAND2_X1 mult_lsb_gf4_mul_0_1_U16 ( .A1(mult_lsb_gf4_mul_0_1_n63), .A2(
        mult_lsb_gf4_mul_0_1_n62), .ZN(mult_lsb_gf4_mul_0_1_n64) );
  XNOR2_X1 mult_lsb_gf4_mul_0_1_U15 ( .A(mult_lsb_gf4_mul_0_1_n61), .B(
        mult_lsb_gf4_mul_0_1_n60), .ZN(mult_lsb_gf4_mul_0_1_n62) );
  XNOR2_X1 mult_lsb_gf4_mul_0_1_U14 ( .A(mult_lsb_gf4_mul_0_1_n59), .B(
        mult_lsb_gf4_mul_0_1_n58), .ZN(mult_lsb_gf4_mul_0_1_n63) );
  XNOR2_X1 mult_lsb_gf4_mul_0_1_U13 ( .A(mult_lsb_gf4_mul_0_1_n57), .B(
        mult_lsb_gf4_mul_0_1_n56), .ZN(mult_lsb_Xi_mul_Yj_1__0_) );
  NAND2_X1 mult_lsb_gf4_mul_0_1_U12 ( .A1(InverterOutxD[0]), .A2(Y1_4xDP[4]), 
        .ZN(mult_lsb_gf4_mul_0_1_n56) );
  XOR2_X1 mult_lsb_gf4_mul_0_1_U11 ( .A(mult_lsb_gf4_mul_0_1_n66), .B(
        mult_lsb_gf4_mul_0_1_n71), .Z(mult_lsb_gf4_mul_0_1_n57) );
  XNOR2_X1 mult_lsb_gf4_mul_0_1_U10 ( .A(mult_lsb_gf4_mul_0_1_n55), .B(
        mult_lsb_gf4_mul_0_1_n65), .ZN(mult_lsb_gf4_mul_0_1_n71) );
  NOR2_X1 mult_lsb_gf4_mul_0_1_U9 ( .A1(mult_lsb_gf4_mul_0_1_n61), .A2(
        mult_lsb_gf4_mul_0_1_n59), .ZN(mult_lsb_gf4_mul_0_1_n65) );
  XNOR2_X1 mult_lsb_gf4_mul_0_1_U8 ( .A(InverterOutxD[0]), .B(InverterOutxD[2]), .ZN(mult_lsb_gf4_mul_0_1_n59) );
  XNOR2_X1 mult_lsb_gf4_mul_0_1_U7 ( .A(Y1_4xDP[4]), .B(Y1_4xDP[6]), .ZN(
        mult_lsb_gf4_mul_0_1_n61) );
  NAND2_X1 mult_lsb_gf4_mul_0_1_U6 ( .A1(mult_lsb_gf4_mul_0_1_n58), .A2(
        mult_lsb_gf4_mul_0_1_n60), .ZN(mult_lsb_gf4_mul_0_1_n55) );
  XOR2_X1 mult_lsb_gf4_mul_0_1_U5 ( .A(Y1_4xDP[5]), .B(Y1_4xDP[7]), .Z(
        mult_lsb_gf4_mul_0_1_n60) );
  XOR2_X1 mult_lsb_gf4_mul_0_1_U4 ( .A(InverterOutxD[1]), .B(InverterOutxD[3]), 
        .Z(mult_lsb_gf4_mul_0_1_n58) );
  NOR2_X1 mult_lsb_gf4_mul_0_1_U3 ( .A1(mult_lsb_gf4_mul_0_1_n54), .A2(
        mult_lsb_gf4_mul_0_1_n53), .ZN(mult_lsb_gf4_mul_0_1_n66) );
  XNOR2_X1 mult_lsb_gf4_mul_0_1_U2 ( .A(InverterOutxD[0]), .B(InverterOutxD[1]), .ZN(mult_lsb_gf4_mul_0_1_n53) );
  XNOR2_X1 mult_lsb_gf4_mul_0_1_U1 ( .A(Y1_4xDP[4]), .B(Y1_4xDP[5]), .ZN(
        mult_lsb_gf4_mul_0_1_n54) );
  XNOR2_X1 mult_lsb_gf4_mul_0_0_U29 ( .A(mult_lsb_gf4_mul_0_0_n77), .B(
        mult_lsb_gf4_mul_0_0_n76), .ZN(mult_lsb_FFxDN[3]) );
  NAND2_X1 mult_lsb_gf4_mul_0_0_U28 ( .A1(InverterOutxD[3]), .A2(Y1_4xDP[3]), 
        .ZN(mult_lsb_gf4_mul_0_0_n76) );
  XOR2_X1 mult_lsb_gf4_mul_0_0_U27 ( .A(mult_lsb_gf4_mul_0_0_n75), .B(
        mult_lsb_gf4_mul_0_0_n74), .Z(mult_lsb_gf4_mul_0_0_n77) );
  XNOR2_X1 mult_lsb_gf4_mul_0_0_U26 ( .A(mult_lsb_gf4_mul_0_0_n73), .B(
        mult_lsb_gf4_mul_0_0_n72), .ZN(mult_lsb_FFxDN[2]) );
  NAND2_X1 mult_lsb_gf4_mul_0_0_U25 ( .A1(InverterOutxD[2]), .A2(Y1_4xDP[2]), 
        .ZN(mult_lsb_gf4_mul_0_0_n72) );
  XOR2_X1 mult_lsb_gf4_mul_0_0_U24 ( .A(mult_lsb_gf4_mul_0_0_n74), .B(
        mult_lsb_gf4_mul_0_0_n71), .Z(mult_lsb_gf4_mul_0_0_n73) );
  NOR2_X1 mult_lsb_gf4_mul_0_0_U23 ( .A1(mult_lsb_gf4_mul_0_0_n70), .A2(
        mult_lsb_gf4_mul_0_0_n69), .ZN(mult_lsb_gf4_mul_0_0_n74) );
  XNOR2_X1 mult_lsb_gf4_mul_0_0_U22 ( .A(InverterOutxD[2]), .B(
        InverterOutxD[3]), .ZN(mult_lsb_gf4_mul_0_0_n69) );
  XNOR2_X1 mult_lsb_gf4_mul_0_0_U21 ( .A(Y1_4xDP[2]), .B(Y1_4xDP[3]), .ZN(
        mult_lsb_gf4_mul_0_0_n70) );
  XNOR2_X1 mult_lsb_gf4_mul_0_0_U20 ( .A(mult_lsb_gf4_mul_0_0_n68), .B(
        mult_lsb_gf4_mul_0_0_n67), .ZN(mult_lsb_FFxDN[1]) );
  NAND2_X1 mult_lsb_gf4_mul_0_0_U19 ( .A1(InverterOutxD[1]), .A2(Y1_4xDP[1]), 
        .ZN(mult_lsb_gf4_mul_0_0_n67) );
  XOR2_X1 mult_lsb_gf4_mul_0_0_U18 ( .A(mult_lsb_gf4_mul_0_0_n75), .B(
        mult_lsb_gf4_mul_0_0_n66), .Z(mult_lsb_gf4_mul_0_0_n68) );
  XNOR2_X1 mult_lsb_gf4_mul_0_0_U17 ( .A(mult_lsb_gf4_mul_0_0_n65), .B(
        mult_lsb_gf4_mul_0_0_n64), .ZN(mult_lsb_gf4_mul_0_0_n75) );
  NAND2_X1 mult_lsb_gf4_mul_0_0_U16 ( .A1(mult_lsb_gf4_mul_0_0_n63), .A2(
        mult_lsb_gf4_mul_0_0_n62), .ZN(mult_lsb_gf4_mul_0_0_n64) );
  XNOR2_X1 mult_lsb_gf4_mul_0_0_U15 ( .A(mult_lsb_gf4_mul_0_0_n61), .B(
        mult_lsb_gf4_mul_0_0_n60), .ZN(mult_lsb_gf4_mul_0_0_n62) );
  XNOR2_X1 mult_lsb_gf4_mul_0_0_U14 ( .A(mult_lsb_gf4_mul_0_0_n59), .B(
        mult_lsb_gf4_mul_0_0_n58), .ZN(mult_lsb_gf4_mul_0_0_n63) );
  XNOR2_X1 mult_lsb_gf4_mul_0_0_U13 ( .A(mult_lsb_gf4_mul_0_0_n57), .B(
        mult_lsb_gf4_mul_0_0_n56), .ZN(mult_lsb_FFxDN[0]) );
  NAND2_X1 mult_lsb_gf4_mul_0_0_U12 ( .A1(InverterOutxD[0]), .A2(Y1_4xDP[0]), 
        .ZN(mult_lsb_gf4_mul_0_0_n56) );
  XOR2_X1 mult_lsb_gf4_mul_0_0_U11 ( .A(mult_lsb_gf4_mul_0_0_n66), .B(
        mult_lsb_gf4_mul_0_0_n71), .Z(mult_lsb_gf4_mul_0_0_n57) );
  XNOR2_X1 mult_lsb_gf4_mul_0_0_U10 ( .A(mult_lsb_gf4_mul_0_0_n55), .B(
        mult_lsb_gf4_mul_0_0_n65), .ZN(mult_lsb_gf4_mul_0_0_n71) );
  NOR2_X1 mult_lsb_gf4_mul_0_0_U9 ( .A1(mult_lsb_gf4_mul_0_0_n61), .A2(
        mult_lsb_gf4_mul_0_0_n59), .ZN(mult_lsb_gf4_mul_0_0_n65) );
  XNOR2_X1 mult_lsb_gf4_mul_0_0_U8 ( .A(InverterOutxD[0]), .B(InverterOutxD[2]), .ZN(mult_lsb_gf4_mul_0_0_n59) );
  XNOR2_X1 mult_lsb_gf4_mul_0_0_U7 ( .A(Y1_4xDP[0]), .B(Y1_4xDP[2]), .ZN(
        mult_lsb_gf4_mul_0_0_n61) );
  NAND2_X1 mult_lsb_gf4_mul_0_0_U6 ( .A1(mult_lsb_gf4_mul_0_0_n58), .A2(
        mult_lsb_gf4_mul_0_0_n60), .ZN(mult_lsb_gf4_mul_0_0_n55) );
  XOR2_X1 mult_lsb_gf4_mul_0_0_U5 ( .A(Y1_4xDP[1]), .B(Y1_4xDP[3]), .Z(
        mult_lsb_gf4_mul_0_0_n60) );
  XOR2_X1 mult_lsb_gf4_mul_0_0_U4 ( .A(InverterOutxD[1]), .B(InverterOutxD[3]), 
        .Z(mult_lsb_gf4_mul_0_0_n58) );
  NOR2_X1 mult_lsb_gf4_mul_0_0_U3 ( .A1(mult_lsb_gf4_mul_0_0_n54), .A2(
        mult_lsb_gf4_mul_0_0_n53), .ZN(mult_lsb_gf4_mul_0_0_n66) );
  XNOR2_X1 mult_lsb_gf4_mul_0_0_U2 ( .A(InverterOutxD[0]), .B(InverterOutxD[1]), .ZN(mult_lsb_gf4_mul_0_0_n53) );
  XNOR2_X1 mult_lsb_gf4_mul_0_0_U1 ( .A(Y1_4xDP[0]), .B(Y1_4xDP[1]), .ZN(
        mult_lsb_gf4_mul_0_0_n54) );
endmodule

