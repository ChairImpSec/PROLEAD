module circuit ( clk, reset, input1, input2, output1, output2, key, enc_dec, 
        done );
  input [63:0] input1;
  input [63:0] input2;
  output [63:0] output1;
  output [63:0] output2;
  input [127:0] key;
  input clk, reset, enc_dec;
  output done;
  wire   controller_n2, controller_n1, controller_roundCounter_n13,
         controller_roundCounter_n12, controller_roundCounter_n11,
         controller_roundCounter_n10, controller_roundCounter_n9,
         controller_roundCounter_n8, controller_roundCounter_n7,
         controller_roundCounter_n6, controller_roundCounter_N12,
         controller_roundCounter_N11, controller_roundCounter_N10,
         controller_roundCounter_N9, controller_roundCounter_N8,
         controller_roundCounter_q_0_, Midori_rounds_n1093,
         Midori_rounds_n1092, Midori_rounds_n1091, Midori_rounds_n1090,
         Midori_rounds_n1089, Midori_rounds_n1088, Midori_rounds_n1087,
         Midori_rounds_n1086, Midori_rounds_n1085, Midori_rounds_n1084,
         Midori_rounds_n1083, Midori_rounds_n1082, Midori_rounds_n1081,
         Midori_rounds_n1080, Midori_rounds_n1079, Midori_rounds_n1078,
         Midori_rounds_n1077, Midori_rounds_n1076, Midori_rounds_n1075,
         Midori_rounds_n1074, Midori_rounds_n1073, Midori_rounds_n1072,
         Midori_rounds_n1071, Midori_rounds_n1070, Midori_rounds_n1069,
         Midori_rounds_n1068, Midori_rounds_n1067, Midori_rounds_n1066,
         Midori_rounds_n1065, Midori_rounds_n1064, Midori_rounds_n1063,
         Midori_rounds_n1062, Midori_rounds_n1061, Midori_rounds_n1060,
         Midori_rounds_n1059, Midori_rounds_n1058, Midori_rounds_n1057,
         Midori_rounds_n1056, Midori_rounds_n1055, Midori_rounds_n1054,
         Midori_rounds_n1053, Midori_rounds_n1052, Midori_rounds_n1051,
         Midori_rounds_n1050, Midori_rounds_n1049, Midori_rounds_n1048,
         Midori_rounds_n1047, Midori_rounds_n1046, Midori_rounds_n1045,
         Midori_rounds_n1044, Midori_rounds_n1043, Midori_rounds_n1042,
         Midori_rounds_n1041, Midori_rounds_n1040, Midori_rounds_n1039,
         Midori_rounds_n1038, Midori_rounds_n1037, Midori_rounds_n1036,
         Midori_rounds_n1035, Midori_rounds_n1034, Midori_rounds_n1033,
         Midori_rounds_n1032, Midori_rounds_n1031, Midori_rounds_n1030,
         Midori_rounds_n1029, Midori_rounds_n1028, Midori_rounds_n1027,
         Midori_rounds_n1026, Midori_rounds_n1025, Midori_rounds_n1024,
         Midori_rounds_n1023, Midori_rounds_n1022, Midori_rounds_n1021,
         Midori_rounds_n1020, Midori_rounds_n1019, Midori_rounds_n1018,
         Midori_rounds_n1017, Midori_rounds_n1016, Midori_rounds_n1015,
         Midori_rounds_n1014, Midori_rounds_n1013, Midori_rounds_n1012,
         Midori_rounds_n1011, Midori_rounds_n1010, Midori_rounds_n1009,
         Midori_rounds_n1008, Midori_rounds_n1007, Midori_rounds_n1006,
         Midori_rounds_n1005, Midori_rounds_n1004, Midori_rounds_n1003,
         Midori_rounds_n1002, Midori_rounds_n1001, Midori_rounds_n1000,
         Midori_rounds_n999, Midori_rounds_n998, Midori_rounds_n997,
         Midori_rounds_n996, Midori_rounds_n995, Midori_rounds_n994,
         Midori_rounds_n993, Midori_rounds_n992, Midori_rounds_n991,
         Midori_rounds_n990, Midori_rounds_n989, Midori_rounds_n988,
         Midori_rounds_n987, Midori_rounds_n986, Midori_rounds_n985,
         Midori_rounds_n984, Midori_rounds_n983, Midori_rounds_n982,
         Midori_rounds_n981, Midori_rounds_n980, Midori_rounds_n979,
         Midori_rounds_n978, Midori_rounds_n977, Midori_rounds_n976,
         Midori_rounds_n975, Midori_rounds_n974, Midori_rounds_n973,
         Midori_rounds_n972, Midori_rounds_n971, Midori_rounds_n970,
         Midori_rounds_n969, Midori_rounds_n968, Midori_rounds_n967,
         Midori_rounds_n966, Midori_rounds_n965, Midori_rounds_n964,
         Midori_rounds_n963, Midori_rounds_n962, Midori_rounds_n961,
         Midori_rounds_n960, Midori_rounds_n959, Midori_rounds_n958,
         Midori_rounds_n957, Midori_rounds_n956, Midori_rounds_n955,
         Midori_rounds_n954, Midori_rounds_n953, Midori_rounds_n952,
         Midori_rounds_n951, Midori_rounds_n950, Midori_rounds_n949,
         Midori_rounds_n948, Midori_rounds_n947, Midori_rounds_n946,
         Midori_rounds_n945, Midori_rounds_n944, Midori_rounds_n943,
         Midori_rounds_n942, Midori_rounds_n941, Midori_rounds_n940,
         Midori_rounds_n939, Midori_rounds_n938, Midori_rounds_n937,
         Midori_rounds_n936, Midori_rounds_n935, Midori_rounds_n934,
         Midori_rounds_n933, Midori_rounds_n932, Midori_rounds_n931,
         Midori_rounds_n930, Midori_rounds_n929, Midori_rounds_n928,
         Midori_rounds_n927, Midori_rounds_n926, Midori_rounds_n925,
         Midori_rounds_n924, Midori_rounds_n923, Midori_rounds_n922,
         Midori_rounds_n921, Midori_rounds_n920, Midori_rounds_n919,
         Midori_rounds_n918, Midori_rounds_n917, Midori_rounds_n916,
         Midori_rounds_n915, Midori_rounds_n914, Midori_rounds_n913,
         Midori_rounds_n912, Midori_rounds_n911, Midori_rounds_n910,
         Midori_rounds_n909, Midori_rounds_n908, Midori_rounds_n907,
         Midori_rounds_n906, Midori_rounds_n905, Midori_rounds_n904,
         Midori_rounds_n903, Midori_rounds_n902, Midori_rounds_n901,
         Midori_rounds_n900, Midori_rounds_n899, Midori_rounds_n898,
         Midori_rounds_n897, Midori_rounds_n896, Midori_rounds_n895,
         Midori_rounds_n894, Midori_rounds_n893, Midori_rounds_n892,
         Midori_rounds_n891, Midori_rounds_n890, Midori_rounds_n889,
         Midori_rounds_n888, Midori_rounds_n887, Midori_rounds_n886,
         Midori_rounds_n885, Midori_rounds_n884, Midori_rounds_n883,
         Midori_rounds_constant_MUX_n130, Midori_rounds_constant_MUX_n129,
         Midori_rounds_constant_MUX_n128, Midori_rounds_constant_MUX_n127,
         Midori_rounds_constant_MUX_n126, Midori_rounds_constant_MUX_n125,
         Midori_rounds_constant_MUX_n124, Midori_rounds_constant_MUX_n123,
         Midori_rounds_constant_MUX_n122, Midori_rounds_constant_MUX_n121,
         Midori_rounds_constant_MUX_n120, Midori_rounds_constant_MUX_n119,
         Midori_rounds_constant_MUX_n118, Midori_rounds_constant_MUX_n117,
         Midori_rounds_constant_MUX_n116, Midori_rounds_constant_MUX_n115,
         Midori_rounds_constant_MUX_n114, Midori_rounds_constant_MUX_n113,
         Midori_rounds_constant_MUX_n112, Midori_rounds_constant_MUX_n111,
         Midori_rounds_constant_MUX_n110, Midori_rounds_constant_MUX_n109,
         Midori_rounds_constant_MUX_n108, Midori_rounds_constant_MUX_n107,
         Midori_rounds_constant_MUX_n106, Midori_rounds_constant_MUX_n105,
         Midori_rounds_constant_MUX_n104, Midori_rounds_constant_MUX_n103,
         Midori_rounds_constant_MUX_n102, Midori_rounds_constant_MUX_n101,
         Midori_rounds_constant_MUX_n100, Midori_rounds_constant_MUX_n99,
         Midori_rounds_constant_MUX_n98, Midori_rounds_constant_MUX_n97,
         Midori_rounds_constant_MUX_n96, Midori_rounds_constant_MUX_n95,
         Midori_rounds_constant_MUX_n94, Midori_rounds_constant_MUX_n93,
         Midori_rounds_constant_MUX_n92, Midori_rounds_constant_MUX_n91,
         Midori_rounds_constant_MUX_n90, Midori_rounds_constant_MUX_n89,
         Midori_rounds_constant_MUX_n88, Midori_rounds_constant_MUX_n87,
         Midori_rounds_constant_MUX_n86, Midori_rounds_constant_MUX_n85,
         Midori_rounds_constant_MUX_n84, Midori_rounds_constant_MUX_n83,
         Midori_rounds_constant_MUX_n82, Midori_rounds_constant_MUX_n81,
         Midori_rounds_constant_MUX_n80, Midori_rounds_constant_MUX_n79,
         Midori_rounds_constant_MUX_n78, Midori_rounds_constant_MUX_n77,
         Midori_rounds_constant_MUX_n76, Midori_rounds_constant_MUX_n75,
         Midori_rounds_constant_MUX_n74, Midori_rounds_constant_MUX_n73,
         Midori_rounds_constant_MUX_n72, Midori_rounds_constant_MUX_n71,
         Midori_rounds_constant_MUX_n70, Midori_rounds_constant_MUX_n69,
         Midori_rounds_constant_MUX_n68, Midori_rounds_constant_MUX_n67,
         Midori_rounds_constant_MUX_n66, Midori_rounds_constant_MUX_n65,
         Midori_rounds_constant_MUX_n64, Midori_rounds_constant_MUX_n63,
         Midori_rounds_constant_MUX_n62, Midori_rounds_constant_MUX_n61,
         Midori_rounds_constant_MUX_n60, Midori_rounds_constant_MUX_n59,
         Midori_rounds_constant_MUX_n58, Midori_rounds_constant_MUX_n57,
         Midori_rounds_constant_MUX_n56, Midori_rounds_constant_MUX_n55,
         Midori_rounds_constant_MUX_n54, Midori_rounds_constant_MUX_n53,
         Midori_rounds_constant_MUX_n52, Midori_rounds_constant_MUX_n51,
         Midori_rounds_constant_MUX_n50, Midori_rounds_constant_MUX_n49,
         Midori_rounds_constant_MUX_n48, Midori_rounds_constant_MUX_n47,
         Midori_rounds_constant_MUX_n46, Midori_rounds_constant_MUX_n45,
         Midori_rounds_constant_MUX_n44, Midori_rounds_constant_MUX_n43,
         Midori_rounds_constant_MUX_n42, Midori_rounds_constant_MUX_n41,
         Midori_rounds_constant_MUX_n40, Midori_rounds_constant_MUX_n39,
         Midori_rounds_constant_MUX_n38, Midori_rounds_constant_MUX_n37,
         Midori_rounds_constant_MUX_n36, Midori_rounds_constant_MUX_n35,
         Midori_rounds_constant_MUX_n34, Midori_rounds_constant_MUX_n33,
         Midori_rounds_constant_MUX_n32, Midori_rounds_constant_MUX_n31,
         Midori_rounds_constant_MUX_n30, Midori_rounds_constant_MUX_n29,
         Midori_rounds_constant_MUX_n28, Midori_rounds_constant_MUX_n27,
         Midori_rounds_constant_MUX_n26, Midori_rounds_constant_MUX_n25,
         Midori_rounds_constant_MUX_n24, Midori_rounds_constant_MUX_n23,
         Midori_rounds_constant_MUX_n22, Midori_rounds_constant_MUX_n21,
         Midori_rounds_constant_MUX_n20, Midori_rounds_constant_MUX_n19,
         Midori_rounds_constant_MUX_n18,
         Midori_rounds_roundResult_Reg1_SFF_0_SFFInst_N3,
         Midori_rounds_roundResult_Reg1_SFF_1_SFFInst_N3,
         Midori_rounds_roundResult_Reg1_SFF_2_SFFInst_N3,
         Midori_rounds_roundResult_Reg1_SFF_3_SFFInst_N3,
         Midori_rounds_roundResult_Reg1_SFF_4_SFFInst_N3,
         Midori_rounds_roundResult_Reg1_SFF_5_SFFInst_N3,
         Midori_rounds_roundResult_Reg1_SFF_6_SFFInst_N3,
         Midori_rounds_roundResult_Reg1_SFF_7_SFFInst_N3,
         Midori_rounds_roundResult_Reg1_SFF_8_SFFInst_N3,
         Midori_rounds_roundResult_Reg1_SFF_9_SFFInst_N3,
         Midori_rounds_roundResult_Reg1_SFF_10_SFFInst_N3,
         Midori_rounds_roundResult_Reg1_SFF_11_SFFInst_N3,
         Midori_rounds_roundResult_Reg1_SFF_12_SFFInst_N3,
         Midori_rounds_roundResult_Reg1_SFF_13_SFFInst_N3,
         Midori_rounds_roundResult_Reg1_SFF_14_SFFInst_N3,
         Midori_rounds_roundResult_Reg1_SFF_15_SFFInst_N3,
         Midori_rounds_roundResult_Reg1_SFF_16_SFFInst_N3,
         Midori_rounds_roundResult_Reg1_SFF_17_SFFInst_N3,
         Midori_rounds_roundResult_Reg1_SFF_18_SFFInst_N3,
         Midori_rounds_roundResult_Reg1_SFF_19_SFFInst_N3,
         Midori_rounds_roundResult_Reg1_SFF_20_SFFInst_N3,
         Midori_rounds_roundResult_Reg1_SFF_21_SFFInst_N3,
         Midori_rounds_roundResult_Reg1_SFF_22_SFFInst_N3,
         Midori_rounds_roundResult_Reg1_SFF_23_SFFInst_N3,
         Midori_rounds_roundResult_Reg1_SFF_24_SFFInst_N3,
         Midori_rounds_roundResult_Reg1_SFF_25_SFFInst_N3,
         Midori_rounds_roundResult_Reg1_SFF_26_SFFInst_N3,
         Midori_rounds_roundResult_Reg1_SFF_27_SFFInst_N3,
         Midori_rounds_roundResult_Reg1_SFF_28_SFFInst_N3,
         Midori_rounds_roundResult_Reg1_SFF_29_SFFInst_N3,
         Midori_rounds_roundResult_Reg1_SFF_30_SFFInst_N3,
         Midori_rounds_roundResult_Reg1_SFF_31_SFFInst_N3,
         Midori_rounds_roundResult_Reg1_SFF_32_SFFInst_N3,
         Midori_rounds_roundResult_Reg1_SFF_33_SFFInst_N3,
         Midori_rounds_roundResult_Reg1_SFF_34_SFFInst_N3,
         Midori_rounds_roundResult_Reg1_SFF_35_SFFInst_N3,
         Midori_rounds_roundResult_Reg1_SFF_36_SFFInst_N3,
         Midori_rounds_roundResult_Reg1_SFF_37_SFFInst_N3,
         Midori_rounds_roundResult_Reg1_SFF_38_SFFInst_N3,
         Midori_rounds_roundResult_Reg1_SFF_39_SFFInst_N3,
         Midori_rounds_roundResult_Reg1_SFF_40_SFFInst_N3,
         Midori_rounds_roundResult_Reg1_SFF_41_SFFInst_N3,
         Midori_rounds_roundResult_Reg1_SFF_42_SFFInst_N3,
         Midori_rounds_roundResult_Reg1_SFF_43_SFFInst_N3,
         Midori_rounds_roundResult_Reg1_SFF_44_SFFInst_N3,
         Midori_rounds_roundResult_Reg1_SFF_45_SFFInst_N3,
         Midori_rounds_roundResult_Reg1_SFF_46_SFFInst_N3,
         Midori_rounds_roundResult_Reg1_SFF_47_SFFInst_N3,
         Midori_rounds_roundResult_Reg1_SFF_48_SFFInst_N3,
         Midori_rounds_roundResult_Reg1_SFF_49_SFFInst_N3,
         Midori_rounds_roundResult_Reg1_SFF_50_SFFInst_N3,
         Midori_rounds_roundResult_Reg1_SFF_51_SFFInst_N3,
         Midori_rounds_roundResult_Reg1_SFF_52_SFFInst_N3,
         Midori_rounds_roundResult_Reg1_SFF_53_SFFInst_N3,
         Midori_rounds_roundResult_Reg1_SFF_54_SFFInst_N3,
         Midori_rounds_roundResult_Reg1_SFF_55_SFFInst_N3,
         Midori_rounds_roundResult_Reg1_SFF_56_SFFInst_N3,
         Midori_rounds_roundResult_Reg1_SFF_57_SFFInst_N3,
         Midori_rounds_roundResult_Reg1_SFF_58_SFFInst_N3,
         Midori_rounds_roundResult_Reg1_SFF_59_SFFInst_N3,
         Midori_rounds_roundResult_Reg1_SFF_60_SFFInst_N3,
         Midori_rounds_roundResult_Reg1_SFF_61_SFFInst_N3,
         Midori_rounds_roundResult_Reg1_SFF_62_SFFInst_N3,
         Midori_rounds_roundResult_Reg1_SFF_63_SFFInst_N3,
         Midori_rounds_roundResult_Reg2_SFF_0_SFFInst_N3,
         Midori_rounds_roundResult_Reg2_SFF_1_SFFInst_N3,
         Midori_rounds_roundResult_Reg2_SFF_2_SFFInst_N3,
         Midori_rounds_roundResult_Reg2_SFF_3_SFFInst_N3,
         Midori_rounds_roundResult_Reg2_SFF_4_SFFInst_N3,
         Midori_rounds_roundResult_Reg2_SFF_5_SFFInst_N3,
         Midori_rounds_roundResult_Reg2_SFF_6_SFFInst_N3,
         Midori_rounds_roundResult_Reg2_SFF_7_SFFInst_N3,
         Midori_rounds_roundResult_Reg2_SFF_8_SFFInst_N3,
         Midori_rounds_roundResult_Reg2_SFF_9_SFFInst_N3,
         Midori_rounds_roundResult_Reg2_SFF_10_SFFInst_N3,
         Midori_rounds_roundResult_Reg2_SFF_11_SFFInst_N3,
         Midori_rounds_roundResult_Reg2_SFF_12_SFFInst_N3,
         Midori_rounds_roundResult_Reg2_SFF_13_SFFInst_N3,
         Midori_rounds_roundResult_Reg2_SFF_14_SFFInst_N3,
         Midori_rounds_roundResult_Reg2_SFF_15_SFFInst_N3,
         Midori_rounds_roundResult_Reg2_SFF_16_SFFInst_N3,
         Midori_rounds_roundResult_Reg2_SFF_17_SFFInst_N3,
         Midori_rounds_roundResult_Reg2_SFF_18_SFFInst_N3,
         Midori_rounds_roundResult_Reg2_SFF_19_SFFInst_N3,
         Midori_rounds_roundResult_Reg2_SFF_20_SFFInst_N3,
         Midori_rounds_roundResult_Reg2_SFF_21_SFFInst_N3,
         Midori_rounds_roundResult_Reg2_SFF_22_SFFInst_N3,
         Midori_rounds_roundResult_Reg2_SFF_23_SFFInst_N3,
         Midori_rounds_roundResult_Reg2_SFF_24_SFFInst_N3,
         Midori_rounds_roundResult_Reg2_SFF_25_SFFInst_N3,
         Midori_rounds_roundResult_Reg2_SFF_26_SFFInst_N3,
         Midori_rounds_roundResult_Reg2_SFF_27_SFFInst_N3,
         Midori_rounds_roundResult_Reg2_SFF_28_SFFInst_N3,
         Midori_rounds_roundResult_Reg2_SFF_29_SFFInst_N3,
         Midori_rounds_roundResult_Reg2_SFF_30_SFFInst_N3,
         Midori_rounds_roundResult_Reg2_SFF_31_SFFInst_N3,
         Midori_rounds_roundResult_Reg2_SFF_32_SFFInst_N3,
         Midori_rounds_roundResult_Reg2_SFF_33_SFFInst_N3,
         Midori_rounds_roundResult_Reg2_SFF_34_SFFInst_N3,
         Midori_rounds_roundResult_Reg2_SFF_35_SFFInst_N3,
         Midori_rounds_roundResult_Reg2_SFF_36_SFFInst_N3,
         Midori_rounds_roundResult_Reg2_SFF_37_SFFInst_N3,
         Midori_rounds_roundResult_Reg2_SFF_38_SFFInst_N3,
         Midori_rounds_roundResult_Reg2_SFF_39_SFFInst_N3,
         Midori_rounds_roundResult_Reg2_SFF_40_SFFInst_N3,
         Midori_rounds_roundResult_Reg2_SFF_41_SFFInst_N3,
         Midori_rounds_roundResult_Reg2_SFF_42_SFFInst_N3,
         Midori_rounds_roundResult_Reg2_SFF_43_SFFInst_N3,
         Midori_rounds_roundResult_Reg2_SFF_44_SFFInst_N3,
         Midori_rounds_roundResult_Reg2_SFF_45_SFFInst_N3,
         Midori_rounds_roundResult_Reg2_SFF_46_SFFInst_N3,
         Midori_rounds_roundResult_Reg2_SFF_47_SFFInst_N3,
         Midori_rounds_roundResult_Reg2_SFF_48_SFFInst_N3,
         Midori_rounds_roundResult_Reg2_SFF_49_SFFInst_N3,
         Midori_rounds_roundResult_Reg2_SFF_50_SFFInst_N3,
         Midori_rounds_roundResult_Reg2_SFF_51_SFFInst_N3,
         Midori_rounds_roundResult_Reg2_SFF_52_SFFInst_N3,
         Midori_rounds_roundResult_Reg2_SFF_53_SFFInst_N3,
         Midori_rounds_roundResult_Reg2_SFF_54_SFFInst_N3,
         Midori_rounds_roundResult_Reg2_SFF_55_SFFInst_N3,
         Midori_rounds_roundResult_Reg2_SFF_56_SFFInst_N3,
         Midori_rounds_roundResult_Reg2_SFF_57_SFFInst_N3,
         Midori_rounds_roundResult_Reg2_SFF_58_SFFInst_N3,
         Midori_rounds_roundResult_Reg2_SFF_59_SFFInst_N3,
         Midori_rounds_roundResult_Reg2_SFF_60_SFFInst_N3,
         Midori_rounds_roundResult_Reg2_SFF_61_SFFInst_N3,
         Midori_rounds_roundResult_Reg2_SFF_62_SFFInst_N3,
         Midori_rounds_roundResult_Reg2_SFF_63_SFFInst_N3,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F1_n17,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F1_n16,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F1_n15,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F1_n14,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F1_n13,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F1_n12,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F1_n11,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F1_n10,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F1_n9,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F1_n8,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F1_n7,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F1_n6,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F1_n5,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F1_n4,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F2_n11,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F2_n10,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F2_n9,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F2_n8,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F2_n7,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F2_n6,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F2_n5,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F2_n4,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F3_n13,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F3_n12,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F3_n11,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F3_n10,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F3_n9,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F3_n8,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F3_n7,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F3_n6,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F3_n5,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F3_n4,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F4_n15,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F4_n14,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F4_n13,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F4_n12,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F4_n11,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F4_n10,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F4_n9,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F4_n8,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F4_n7,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F4_n6,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F4_n5,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F5_n11,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F5_n10,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F5_n9,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F5_n8,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F5_n7,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F5_n6,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F5_n5,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F5_n4,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F5_n3,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_n22,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_n21,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_n20,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_n19,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_n18,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_n17,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_n16,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_n15,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_n14,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_n13,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_n12,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_n11,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_n10,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_n9,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_n8,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_n7,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_n6,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_n5,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F7_n9,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F7_n8,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F7_n7,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F7_n6,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F7_n5,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F7_n4,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F7_n3,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F7_n2,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F8_n16,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F8_n15,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F8_n14,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F8_n13,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F8_n12,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F8_n11,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F8_n10,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F8_n9,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F8_n8,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F8_n7,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F8_n6,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F8_n5,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F8_n4,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_L_XORInst1_n2,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_L_XORInst1_n1,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_L_XORInst2_n6,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_L_XORInst2_n5,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_L_XORInst5_n6,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_L_XORInst5_n5,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_L_XORInst6_n6,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_L_XORInst6_n5,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_L_XORInst7_n6,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_L_XORInst7_n5,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_L_XORInst8_n6,
         Midori_rounds_sub_sBox_PRINCE_0_Inst_L_XORInst8_n5,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F1_n43,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F1_n42,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F1_n41,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F1_n40,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F1_n39,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F1_n38,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F1_n37,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F1_n36,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F1_n35,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F1_n34,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F1_n33,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F1_n32,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F1_n31,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F1_n30,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F2_n33,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F2_n32,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F2_n31,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F2_n30,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F2_n29,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F2_n28,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F2_n27,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F2_n26,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F3_n35,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F3_n34,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F3_n33,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F3_n32,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F3_n31,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F3_n30,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F3_n29,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F3_n28,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F3_n27,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F3_n26,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F4_n49,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F4_n48,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F4_n47,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F4_n46,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F4_n45,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F4_n44,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F4_n43,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F4_n42,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F4_n41,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F4_n40,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F4_n39,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F5_n33,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F5_n32,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F5_n31,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F5_n30,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F5_n29,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F5_n28,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F5_n27,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F5_n26,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F5_n25,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_n62,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_n61,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_n60,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_n59,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_n58,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_n57,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_n56,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_n55,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_n54,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_n53,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_n52,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_n51,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_n50,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_n49,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_n48,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_n47,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_n46,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_n45,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F7_n35,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F7_n34,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F7_n33,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F7_n32,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F7_n31,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F7_n30,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F7_n29,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F7_n28,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F8_n44,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F8_n43,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F8_n42,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F8_n41,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F8_n40,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F8_n39,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F8_n38,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F8_n37,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F8_n36,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F8_n35,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F8_n34,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F8_n33,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F8_n32,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_L_XORInst1_n6,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_L_XORInst1_n5,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_L_XORInst2_n6,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_L_XORInst2_n5,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_L_XORInst5_n6,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_L_XORInst5_n5,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_L_XORInst6_n6,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_L_XORInst6_n5,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_L_XORInst7_n6,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_L_XORInst7_n5,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_L_XORInst8_n6,
         Midori_rounds_sub_sBox_PRINCE_1_Inst_L_XORInst8_n5,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F1_n43,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F1_n42,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F1_n41,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F1_n40,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F1_n39,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F1_n38,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F1_n37,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F1_n36,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F1_n35,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F1_n34,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F1_n33,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F1_n32,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F1_n31,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F1_n30,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F2_n33,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F2_n32,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F2_n31,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F2_n30,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F2_n29,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F2_n28,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F2_n27,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F2_n26,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F3_n35,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F3_n34,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F3_n33,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F3_n32,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F3_n31,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F3_n30,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F3_n29,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F3_n28,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F3_n27,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F3_n26,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F4_n49,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F4_n48,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F4_n47,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F4_n46,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F4_n45,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F4_n44,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F4_n43,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F4_n42,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F4_n41,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F4_n40,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F4_n39,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F5_n33,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F5_n32,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F5_n31,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F5_n30,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F5_n29,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F5_n28,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F5_n27,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F5_n26,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F5_n25,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_n62,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_n61,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_n60,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_n59,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_n58,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_n57,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_n56,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_n55,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_n54,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_n53,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_n52,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_n51,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_n50,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_n49,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_n48,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_n47,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_n46,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_n45,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F7_n35,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F7_n34,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F7_n33,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F7_n32,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F7_n31,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F7_n30,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F7_n29,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F7_n28,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F8_n44,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F8_n43,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F8_n42,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F8_n41,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F8_n40,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F8_n39,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F8_n38,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F8_n37,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F8_n36,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F8_n35,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F8_n34,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F8_n33,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F8_n32,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_L_XORInst1_n6,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_L_XORInst1_n5,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_L_XORInst2_n6,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_L_XORInst2_n5,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_L_XORInst5_n6,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_L_XORInst5_n5,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_L_XORInst6_n6,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_L_XORInst6_n5,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_L_XORInst7_n6,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_L_XORInst7_n5,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_L_XORInst8_n6,
         Midori_rounds_sub_sBox_PRINCE_2_Inst_L_XORInst8_n5,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F1_n43,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F1_n42,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F1_n41,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F1_n40,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F1_n39,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F1_n38,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F1_n37,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F1_n36,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F1_n35,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F1_n34,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F1_n33,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F1_n32,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F1_n31,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F1_n30,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F2_n33,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F2_n32,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F2_n31,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F2_n30,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F2_n29,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F2_n28,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F2_n27,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F2_n26,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F3_n35,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F3_n34,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F3_n33,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F3_n32,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F3_n31,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F3_n30,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F3_n29,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F3_n28,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F3_n27,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F3_n26,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F4_n49,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F4_n48,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F4_n47,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F4_n46,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F4_n45,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F4_n44,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F4_n43,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F4_n42,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F4_n41,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F4_n40,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F4_n39,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F5_n33,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F5_n32,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F5_n31,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F5_n30,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F5_n29,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F5_n28,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F5_n27,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F5_n26,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F5_n25,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_n62,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_n61,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_n60,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_n59,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_n58,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_n57,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_n56,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_n55,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_n54,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_n53,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_n52,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_n51,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_n50,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_n49,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_n48,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_n47,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_n46,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_n45,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F7_n35,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F7_n34,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F7_n33,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F7_n32,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F7_n31,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F7_n30,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F7_n29,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F7_n28,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F8_n44,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F8_n43,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F8_n42,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F8_n41,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F8_n40,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F8_n39,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F8_n38,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F8_n37,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F8_n36,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F8_n35,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F8_n34,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F8_n33,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F8_n32,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_L_XORInst1_n6,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_L_XORInst1_n5,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_L_XORInst2_n6,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_L_XORInst2_n5,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_L_XORInst5_n6,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_L_XORInst5_n5,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_L_XORInst6_n6,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_L_XORInst6_n5,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_L_XORInst7_n6,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_L_XORInst7_n5,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_L_XORInst8_n6,
         Midori_rounds_sub_sBox_PRINCE_3_Inst_L_XORInst8_n5,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F1_n43,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F1_n42,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F1_n41,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F1_n40,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F1_n39,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F1_n38,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F1_n37,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F1_n36,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F1_n35,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F1_n34,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F1_n33,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F1_n32,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F1_n31,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F1_n30,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F2_n33,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F2_n32,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F2_n31,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F2_n30,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F2_n29,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F2_n28,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F2_n27,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F2_n26,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F3_n35,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F3_n34,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F3_n33,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F3_n32,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F3_n31,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F3_n30,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F3_n29,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F3_n28,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F3_n27,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F3_n26,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F4_n49,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F4_n48,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F4_n47,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F4_n46,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F4_n45,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F4_n44,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F4_n43,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F4_n42,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F4_n41,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F4_n40,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F4_n39,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F5_n33,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F5_n32,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F5_n31,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F5_n30,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F5_n29,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F5_n28,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F5_n27,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F5_n26,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F5_n25,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_n62,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_n61,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_n60,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_n59,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_n58,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_n57,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_n56,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_n55,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_n54,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_n53,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_n52,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_n51,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_n50,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_n49,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_n48,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_n47,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_n46,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_n45,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F7_n35,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F7_n34,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F7_n33,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F7_n32,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F7_n31,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F7_n30,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F7_n29,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F7_n28,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F8_n44,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F8_n43,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F8_n42,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F8_n41,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F8_n40,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F8_n39,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F8_n38,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F8_n37,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F8_n36,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F8_n35,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F8_n34,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F8_n33,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F8_n32,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_L_XORInst1_n6,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_L_XORInst1_n5,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_L_XORInst2_n6,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_L_XORInst2_n5,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_L_XORInst5_n6,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_L_XORInst5_n5,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_L_XORInst6_n6,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_L_XORInst6_n5,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_L_XORInst7_n6,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_L_XORInst7_n5,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_L_XORInst8_n6,
         Midori_rounds_sub_sBox_PRINCE_4_Inst_L_XORInst8_n5,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F1_n43,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F1_n42,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F1_n41,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F1_n40,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F1_n39,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F1_n38,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F1_n37,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F1_n36,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F1_n35,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F1_n34,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F1_n33,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F1_n32,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F1_n31,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F1_n30,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F2_n33,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F2_n32,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F2_n31,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F2_n30,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F2_n29,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F2_n28,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F2_n27,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F2_n26,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F3_n35,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F3_n34,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F3_n33,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F3_n32,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F3_n31,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F3_n30,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F3_n29,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F3_n28,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F3_n27,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F3_n26,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F4_n49,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F4_n48,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F4_n47,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F4_n46,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F4_n45,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F4_n44,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F4_n43,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F4_n42,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F4_n41,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F4_n40,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F4_n39,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F5_n33,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F5_n32,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F5_n31,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F5_n30,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F5_n29,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F5_n28,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F5_n27,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F5_n26,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F5_n25,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_n62,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_n61,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_n60,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_n59,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_n58,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_n57,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_n56,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_n55,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_n54,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_n53,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_n52,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_n51,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_n50,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_n49,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_n48,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_n47,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_n46,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_n45,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F7_n35,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F7_n34,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F7_n33,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F7_n32,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F7_n31,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F7_n30,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F7_n29,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F7_n28,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F8_n44,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F8_n43,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F8_n42,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F8_n41,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F8_n40,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F8_n39,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F8_n38,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F8_n37,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F8_n36,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F8_n35,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F8_n34,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F8_n33,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F8_n32,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_L_XORInst1_n6,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_L_XORInst1_n5,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_L_XORInst2_n6,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_L_XORInst2_n5,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_L_XORInst5_n6,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_L_XORInst5_n5,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_L_XORInst6_n6,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_L_XORInst6_n5,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_L_XORInst7_n6,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_L_XORInst7_n5,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_L_XORInst8_n6,
         Midori_rounds_sub_sBox_PRINCE_5_Inst_L_XORInst8_n5,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F1_n43,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F1_n42,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F1_n41,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F1_n40,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F1_n39,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F1_n38,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F1_n37,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F1_n36,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F1_n35,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F1_n34,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F1_n33,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F1_n32,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F1_n31,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F1_n30,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F2_n33,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F2_n32,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F2_n31,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F2_n30,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F2_n29,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F2_n28,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F2_n27,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F2_n26,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F3_n35,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F3_n34,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F3_n33,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F3_n32,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F3_n31,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F3_n30,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F3_n29,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F3_n28,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F3_n27,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F3_n26,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F4_n49,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F4_n48,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F4_n47,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F4_n46,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F4_n45,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F4_n44,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F4_n43,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F4_n42,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F4_n41,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F4_n40,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F4_n39,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F5_n33,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F5_n32,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F5_n31,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F5_n30,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F5_n29,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F5_n28,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F5_n27,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F5_n26,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F5_n25,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_n62,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_n61,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_n60,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_n59,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_n58,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_n57,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_n56,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_n55,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_n54,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_n53,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_n52,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_n51,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_n50,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_n49,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_n48,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_n47,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_n46,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_n45,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F7_n35,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F7_n34,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F7_n33,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F7_n32,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F7_n31,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F7_n30,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F7_n29,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F7_n28,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F8_n44,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F8_n43,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F8_n42,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F8_n41,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F8_n40,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F8_n39,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F8_n38,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F8_n37,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F8_n36,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F8_n35,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F8_n34,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F8_n33,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F8_n32,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_L_XORInst1_n6,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_L_XORInst1_n5,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_L_XORInst2_n6,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_L_XORInst2_n5,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_L_XORInst5_n6,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_L_XORInst5_n5,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_L_XORInst6_n6,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_L_XORInst6_n5,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_L_XORInst7_n6,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_L_XORInst7_n5,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_L_XORInst8_n6,
         Midori_rounds_sub_sBox_PRINCE_6_Inst_L_XORInst8_n5,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F1_n43,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F1_n42,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F1_n41,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F1_n40,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F1_n39,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F1_n38,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F1_n37,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F1_n36,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F1_n35,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F1_n34,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F1_n33,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F1_n32,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F1_n31,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F1_n30,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F2_n33,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F2_n32,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F2_n31,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F2_n30,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F2_n29,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F2_n28,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F2_n27,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F2_n26,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F3_n35,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F3_n34,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F3_n33,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F3_n32,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F3_n31,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F3_n30,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F3_n29,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F3_n28,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F3_n27,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F3_n26,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F4_n49,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F4_n48,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F4_n47,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F4_n46,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F4_n45,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F4_n44,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F4_n43,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F4_n42,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F4_n41,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F4_n40,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F4_n39,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F5_n33,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F5_n32,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F5_n31,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F5_n30,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F5_n29,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F5_n28,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F5_n27,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F5_n26,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F5_n25,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_n62,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_n61,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_n60,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_n59,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_n58,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_n57,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_n56,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_n55,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_n54,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_n53,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_n52,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_n51,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_n50,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_n49,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_n48,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_n47,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_n46,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_n45,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F7_n35,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F7_n34,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F7_n33,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F7_n32,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F7_n31,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F7_n30,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F7_n29,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F7_n28,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F8_n44,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F8_n43,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F8_n42,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F8_n41,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F8_n40,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F8_n39,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F8_n38,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F8_n37,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F8_n36,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F8_n35,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F8_n34,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F8_n33,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F8_n32,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_L_XORInst1_n6,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_L_XORInst1_n5,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_L_XORInst2_n6,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_L_XORInst2_n5,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_L_XORInst5_n6,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_L_XORInst5_n5,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_L_XORInst6_n6,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_L_XORInst6_n5,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_L_XORInst7_n6,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_L_XORInst7_n5,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_L_XORInst8_n6,
         Midori_rounds_sub_sBox_PRINCE_7_Inst_L_XORInst8_n5,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F1_n43,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F1_n42,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F1_n41,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F1_n40,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F1_n39,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F1_n38,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F1_n37,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F1_n36,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F1_n35,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F1_n34,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F1_n33,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F1_n32,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F1_n31,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F1_n30,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F2_n33,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F2_n32,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F2_n31,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F2_n30,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F2_n29,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F2_n28,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F2_n27,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F2_n26,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F3_n35,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F3_n34,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F3_n33,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F3_n32,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F3_n31,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F3_n30,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F3_n29,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F3_n28,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F3_n27,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F3_n26,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F4_n49,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F4_n48,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F4_n47,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F4_n46,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F4_n45,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F4_n44,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F4_n43,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F4_n42,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F4_n41,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F4_n40,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F4_n39,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F5_n33,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F5_n32,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F5_n31,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F5_n30,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F5_n29,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F5_n28,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F5_n27,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F5_n26,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F5_n25,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_n62,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_n61,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_n60,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_n59,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_n58,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_n57,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_n56,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_n55,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_n54,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_n53,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_n52,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_n51,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_n50,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_n49,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_n48,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_n47,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_n46,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_n45,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F7_n35,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F7_n34,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F7_n33,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F7_n32,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F7_n31,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F7_n30,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F7_n29,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F7_n28,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F8_n44,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F8_n43,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F8_n42,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F8_n41,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F8_n40,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F8_n39,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F8_n38,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F8_n37,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F8_n36,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F8_n35,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F8_n34,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F8_n33,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F8_n32,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_L_XORInst1_n6,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_L_XORInst1_n5,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_L_XORInst2_n6,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_L_XORInst2_n5,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_L_XORInst5_n6,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_L_XORInst5_n5,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_L_XORInst6_n6,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_L_XORInst6_n5,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_L_XORInst7_n6,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_L_XORInst7_n5,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_L_XORInst8_n6,
         Midori_rounds_sub_sBox_PRINCE_8_Inst_L_XORInst8_n5,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F1_n43,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F1_n42,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F1_n41,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F1_n40,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F1_n39,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F1_n38,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F1_n37,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F1_n36,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F1_n35,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F1_n34,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F1_n33,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F1_n32,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F1_n31,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F1_n30,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F2_n33,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F2_n32,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F2_n31,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F2_n30,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F2_n29,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F2_n28,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F2_n27,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F2_n26,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F3_n35,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F3_n34,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F3_n33,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F3_n32,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F3_n31,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F3_n30,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F3_n29,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F3_n28,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F3_n27,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F3_n26,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F4_n49,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F4_n48,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F4_n47,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F4_n46,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F4_n45,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F4_n44,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F4_n43,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F4_n42,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F4_n41,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F4_n40,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F4_n39,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F5_n33,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F5_n32,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F5_n31,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F5_n30,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F5_n29,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F5_n28,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F5_n27,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F5_n26,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F5_n25,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_n62,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_n61,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_n60,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_n59,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_n58,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_n57,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_n56,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_n55,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_n54,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_n53,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_n52,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_n51,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_n50,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_n49,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_n48,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_n47,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_n46,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_n45,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F7_n35,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F7_n34,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F7_n33,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F7_n32,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F7_n31,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F7_n30,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F7_n29,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F7_n28,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F8_n44,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F8_n43,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F8_n42,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F8_n41,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F8_n40,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F8_n39,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F8_n38,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F8_n37,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F8_n36,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F8_n35,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F8_n34,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F8_n33,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F8_n32,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_L_XORInst1_n6,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_L_XORInst1_n5,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_L_XORInst2_n6,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_L_XORInst2_n5,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_L_XORInst5_n6,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_L_XORInst5_n5,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_L_XORInst6_n6,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_L_XORInst6_n5,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_L_XORInst7_n6,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_L_XORInst7_n5,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_L_XORInst8_n6,
         Midori_rounds_sub_sBox_PRINCE_9_Inst_L_XORInst8_n5,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F1_n43,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F1_n42,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F1_n41,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F1_n40,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F1_n39,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F1_n38,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F1_n37,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F1_n36,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F1_n35,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F1_n34,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F1_n33,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F1_n32,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F1_n31,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F1_n30,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F2_n33,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F2_n32,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F2_n31,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F2_n30,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F2_n29,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F2_n28,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F2_n27,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F2_n26,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F3_n35,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F3_n34,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F3_n33,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F3_n32,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F3_n31,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F3_n30,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F3_n29,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F3_n28,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F3_n27,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F3_n26,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F4_n49,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F4_n48,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F4_n47,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F4_n46,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F4_n45,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F4_n44,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F4_n43,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F4_n42,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F4_n41,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F4_n40,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F4_n39,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F5_n33,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F5_n32,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F5_n31,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F5_n30,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F5_n29,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F5_n28,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F5_n27,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F5_n26,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F5_n25,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_n62,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_n61,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_n60,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_n59,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_n58,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_n57,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_n56,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_n55,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_n54,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_n53,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_n52,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_n51,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_n50,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_n49,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_n48,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_n47,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_n46,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_n45,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F7_n35,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F7_n34,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F7_n33,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F7_n32,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F7_n31,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F7_n30,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F7_n29,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F7_n28,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F8_n44,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F8_n43,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F8_n42,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F8_n41,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F8_n40,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F8_n39,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F8_n38,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F8_n37,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F8_n36,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F8_n35,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F8_n34,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F8_n33,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F8_n32,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_L_XORInst1_n6,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_L_XORInst1_n5,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_L_XORInst2_n6,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_L_XORInst2_n5,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_L_XORInst5_n6,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_L_XORInst5_n5,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_L_XORInst6_n6,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_L_XORInst6_n5,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_L_XORInst7_n6,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_L_XORInst7_n5,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_L_XORInst8_n6,
         Midori_rounds_sub_sBox_PRINCE_10_Inst_L_XORInst8_n5,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F1_n43,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F1_n42,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F1_n41,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F1_n40,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F1_n39,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F1_n38,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F1_n37,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F1_n36,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F1_n35,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F1_n34,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F1_n33,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F1_n32,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F1_n31,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F1_n30,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F2_n33,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F2_n32,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F2_n31,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F2_n30,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F2_n29,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F2_n28,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F2_n27,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F2_n26,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F3_n35,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F3_n34,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F3_n33,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F3_n32,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F3_n31,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F3_n30,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F3_n29,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F3_n28,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F3_n27,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F3_n26,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F4_n49,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F4_n48,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F4_n47,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F4_n46,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F4_n45,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F4_n44,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F4_n43,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F4_n42,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F4_n41,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F4_n40,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F4_n39,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F5_n33,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F5_n32,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F5_n31,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F5_n30,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F5_n29,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F5_n28,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F5_n27,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F5_n26,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F5_n25,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_n62,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_n61,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_n60,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_n59,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_n58,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_n57,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_n56,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_n55,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_n54,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_n53,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_n52,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_n51,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_n50,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_n49,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_n48,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_n47,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_n46,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_n45,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F7_n35,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F7_n34,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F7_n33,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F7_n32,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F7_n31,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F7_n30,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F7_n29,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F7_n28,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F8_n44,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F8_n43,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F8_n42,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F8_n41,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F8_n40,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F8_n39,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F8_n38,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F8_n37,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F8_n36,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F8_n35,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F8_n34,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F8_n33,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F8_n32,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_L_XORInst1_n6,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_L_XORInst1_n5,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_L_XORInst2_n6,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_L_XORInst2_n5,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_L_XORInst5_n6,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_L_XORInst5_n5,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_L_XORInst6_n6,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_L_XORInst6_n5,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_L_XORInst7_n6,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_L_XORInst7_n5,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_L_XORInst8_n6,
         Midori_rounds_sub_sBox_PRINCE_11_Inst_L_XORInst8_n5,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F1_n43,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F1_n42,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F1_n41,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F1_n40,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F1_n39,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F1_n38,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F1_n37,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F1_n36,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F1_n35,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F1_n34,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F1_n33,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F1_n32,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F1_n31,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F1_n30,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F2_n33,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F2_n32,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F2_n31,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F2_n30,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F2_n29,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F2_n28,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F2_n27,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F2_n26,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F3_n35,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F3_n34,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F3_n33,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F3_n32,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F3_n31,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F3_n30,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F3_n29,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F3_n28,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F3_n27,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F3_n26,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F4_n49,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F4_n48,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F4_n47,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F4_n46,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F4_n45,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F4_n44,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F4_n43,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F4_n42,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F4_n41,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F4_n40,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F4_n39,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F5_n33,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F5_n32,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F5_n31,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F5_n30,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F5_n29,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F5_n28,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F5_n27,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F5_n26,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F5_n25,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_n62,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_n61,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_n60,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_n59,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_n58,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_n57,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_n56,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_n55,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_n54,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_n53,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_n52,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_n51,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_n50,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_n49,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_n48,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_n47,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_n46,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_n45,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F7_n35,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F7_n34,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F7_n33,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F7_n32,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F7_n31,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F7_n30,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F7_n29,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F7_n28,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F8_n44,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F8_n43,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F8_n42,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F8_n41,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F8_n40,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F8_n39,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F8_n38,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F8_n37,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F8_n36,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F8_n35,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F8_n34,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F8_n33,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F8_n32,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_L_XORInst1_n6,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_L_XORInst1_n5,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_L_XORInst2_n6,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_L_XORInst2_n5,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_L_XORInst5_n6,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_L_XORInst5_n5,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_L_XORInst6_n6,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_L_XORInst6_n5,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_L_XORInst7_n6,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_L_XORInst7_n5,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_L_XORInst8_n6,
         Midori_rounds_sub_sBox_PRINCE_12_Inst_L_XORInst8_n5,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F1_n43,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F1_n42,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F1_n41,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F1_n40,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F1_n39,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F1_n38,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F1_n37,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F1_n36,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F1_n35,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F1_n34,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F1_n33,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F1_n32,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F1_n31,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F1_n30,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F2_n33,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F2_n32,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F2_n31,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F2_n30,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F2_n29,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F2_n28,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F2_n27,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F2_n26,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F3_n35,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F3_n34,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F3_n33,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F3_n32,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F3_n31,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F3_n30,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F3_n29,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F3_n28,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F3_n27,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F3_n26,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F4_n49,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F4_n48,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F4_n47,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F4_n46,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F4_n45,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F4_n44,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F4_n43,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F4_n42,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F4_n41,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F4_n40,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F4_n39,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F5_n33,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F5_n32,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F5_n31,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F5_n30,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F5_n29,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F5_n28,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F5_n27,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F5_n26,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F5_n25,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_n62,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_n61,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_n60,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_n59,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_n58,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_n57,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_n56,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_n55,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_n54,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_n53,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_n52,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_n51,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_n50,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_n49,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_n48,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_n47,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_n46,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_n45,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F7_n35,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F7_n34,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F7_n33,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F7_n32,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F7_n31,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F7_n30,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F7_n29,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F7_n28,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F8_n44,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F8_n43,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F8_n42,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F8_n41,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F8_n40,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F8_n39,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F8_n38,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F8_n37,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F8_n36,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F8_n35,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F8_n34,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F8_n33,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F8_n32,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_L_XORInst1_n6,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_L_XORInst1_n5,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_L_XORInst2_n6,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_L_XORInst2_n5,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_L_XORInst5_n6,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_L_XORInst5_n5,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_L_XORInst6_n6,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_L_XORInst6_n5,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_L_XORInst7_n6,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_L_XORInst7_n5,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_L_XORInst8_n6,
         Midori_rounds_sub_sBox_PRINCE_13_Inst_L_XORInst8_n5,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F1_n43,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F1_n42,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F1_n41,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F1_n40,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F1_n39,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F1_n38,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F1_n37,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F1_n36,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F1_n35,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F1_n34,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F1_n33,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F1_n32,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F1_n31,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F1_n30,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F2_n33,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F2_n32,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F2_n31,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F2_n30,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F2_n29,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F2_n28,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F2_n27,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F2_n26,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F3_n35,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F3_n34,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F3_n33,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F3_n32,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F3_n31,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F3_n30,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F3_n29,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F3_n28,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F3_n27,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F3_n26,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F4_n49,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F4_n48,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F4_n47,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F4_n46,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F4_n45,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F4_n44,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F4_n43,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F4_n42,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F4_n41,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F4_n40,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F4_n39,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F5_n33,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F5_n32,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F5_n31,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F5_n30,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F5_n29,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F5_n28,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F5_n27,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F5_n26,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F5_n25,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_n62,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_n61,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_n60,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_n59,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_n58,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_n57,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_n56,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_n55,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_n54,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_n53,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_n52,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_n51,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_n50,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_n49,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_n48,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_n47,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_n46,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_n45,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F7_n35,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F7_n34,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F7_n33,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F7_n32,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F7_n31,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F7_n30,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F7_n29,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F7_n28,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F8_n44,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F8_n43,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F8_n42,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F8_n41,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F8_n40,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F8_n39,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F8_n38,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F8_n37,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F8_n36,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F8_n35,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F8_n34,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F8_n33,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F8_n32,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_L_XORInst1_n6,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_L_XORInst1_n5,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_L_XORInst2_n6,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_L_XORInst2_n5,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_L_XORInst5_n6,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_L_XORInst5_n5,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_L_XORInst6_n6,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_L_XORInst6_n5,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_L_XORInst7_n6,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_L_XORInst7_n5,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_L_XORInst8_n6,
         Midori_rounds_sub_sBox_PRINCE_14_Inst_L_XORInst8_n5,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F1_n43,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F1_n42,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F1_n41,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F1_n40,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F1_n39,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F1_n38,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F1_n37,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F1_n36,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F1_n35,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F1_n34,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F1_n33,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F1_n32,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F1_n31,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F1_n30,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F2_n33,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F2_n32,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F2_n31,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F2_n30,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F2_n29,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F2_n28,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F2_n27,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F2_n26,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F3_n35,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F3_n34,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F3_n33,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F3_n32,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F3_n31,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F3_n30,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F3_n29,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F3_n28,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F3_n27,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F3_n26,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F4_n49,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F4_n48,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F4_n47,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F4_n46,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F4_n45,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F4_n44,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F4_n43,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F4_n42,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F4_n41,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F4_n40,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F4_n39,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F5_n33,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F5_n32,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F5_n31,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F5_n30,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F5_n29,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F5_n28,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F5_n27,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F5_n26,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F5_n25,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_n62,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_n61,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_n60,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_n59,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_n58,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_n57,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_n56,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_n55,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_n54,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_n53,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_n52,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_n51,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_n50,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_n49,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_n48,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_n47,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_n46,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_n45,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F7_n35,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F7_n34,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F7_n33,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F7_n32,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F7_n31,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F7_n30,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F7_n29,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F7_n28,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F8_n44,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F8_n43,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F8_n42,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F8_n41,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F8_n40,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F8_n39,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F8_n38,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F8_n37,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F8_n36,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F8_n35,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F8_n34,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F8_n33,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F8_n32,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_L_XORInst1_n6,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_L_XORInst1_n5,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_L_XORInst2_n6,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_L_XORInst2_n5,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_L_XORInst5_n6,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_L_XORInst5_n5,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_L_XORInst6_n6,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_L_XORInst6_n5,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_L_XORInst7_n6,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_L_XORInst7_n5,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_L_XORInst8_n6,
         Midori_rounds_sub_sBox_PRINCE_15_Inst_L_XORInst8_n5,
         Midori_rounds_mul1_MC1_n8, Midori_rounds_mul1_MC1_n7,
         Midori_rounds_mul1_MC1_n6, Midori_rounds_mul1_MC1_n5,
         Midori_rounds_mul1_MC1_n4, Midori_rounds_mul1_MC1_n3,
         Midori_rounds_mul1_MC1_n2, Midori_rounds_mul1_MC1_n1,
         Midori_rounds_mul1_MC2_n24, Midori_rounds_mul1_MC2_n23,
         Midori_rounds_mul1_MC2_n22, Midori_rounds_mul1_MC2_n21,
         Midori_rounds_mul1_MC2_n20, Midori_rounds_mul1_MC2_n19,
         Midori_rounds_mul1_MC2_n18, Midori_rounds_mul1_MC2_n17,
         Midori_rounds_mul1_MC3_n24, Midori_rounds_mul1_MC3_n23,
         Midori_rounds_mul1_MC3_n22, Midori_rounds_mul1_MC3_n21,
         Midori_rounds_mul1_MC3_n20, Midori_rounds_mul1_MC3_n19,
         Midori_rounds_mul1_MC3_n18, Midori_rounds_mul1_MC3_n17,
         Midori_rounds_mul1_MC4_n24, Midori_rounds_mul1_MC4_n23,
         Midori_rounds_mul1_MC4_n22, Midori_rounds_mul1_MC4_n21,
         Midori_rounds_mul1_MC4_n20, Midori_rounds_mul1_MC4_n19,
         Midori_rounds_mul1_MC4_n18, Midori_rounds_mul1_MC4_n17,
         Midori_rounds_mul2_MC1_n24, Midori_rounds_mul2_MC1_n23,
         Midori_rounds_mul2_MC1_n22, Midori_rounds_mul2_MC1_n21,
         Midori_rounds_mul2_MC1_n20, Midori_rounds_mul2_MC1_n19,
         Midori_rounds_mul2_MC1_n18, Midori_rounds_mul2_MC1_n17,
         Midori_rounds_mul2_MC2_n24, Midori_rounds_mul2_MC2_n23,
         Midori_rounds_mul2_MC2_n22, Midori_rounds_mul2_MC2_n21,
         Midori_rounds_mul2_MC2_n20, Midori_rounds_mul2_MC2_n19,
         Midori_rounds_mul2_MC2_n18, Midori_rounds_mul2_MC2_n17,
         Midori_rounds_mul2_MC3_n24, Midori_rounds_mul2_MC3_n23,
         Midori_rounds_mul2_MC3_n22, Midori_rounds_mul2_MC3_n21,
         Midori_rounds_mul2_MC3_n20, Midori_rounds_mul2_MC3_n19,
         Midori_rounds_mul2_MC3_n18, Midori_rounds_mul2_MC3_n17,
         Midori_rounds_mul2_MC4_n24, Midori_rounds_mul2_MC4_n23,
         Midori_rounds_mul2_MC4_n22, Midori_rounds_mul2_MC4_n21,
         Midori_rounds_mul2_MC4_n20, Midori_rounds_mul2_MC4_n19,
         Midori_rounds_mul2_MC4_n18, Midori_rounds_mul2_MC4_n17;
  wire   [63:0] wk;
  wire   [3:0] round_Signal;
  wire   [63:0] Midori_add_Result_Start1;
  wire   [63:0] Midori_rounds_SR_Inv_Result2;
  wire   [63:0] Midori_rounds_SR_Inv_Result1;
  wire   [63:0] Midori_rounds_mul_input2;
  wire   [63:0] Midori_rounds_mul_input1;
  wire   [63:0] Midori_rounds_SR_Result2;
  wire   [63:0] Midori_rounds_roundReg_out2;
  wire   [63:0] Midori_rounds_round_Result2;
  wire   [63:0] Midori_rounds_roundReg_out1;
  wire   [63:0] Midori_rounds_round_Result1;
  wire   [15:0] Midori_rounds_round_Constant;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_0_h_reg;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_0_g_reg;
  wire   [4:1] Midori_rounds_sub_sBox_PRINCE_0_f_reg;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_0_e_reg;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_0_h;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_0_g;
  wire   [4:1] Midori_rounds_sub_sBox_PRINCE_0_f;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_0_e;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_1_h_reg;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_1_g_reg;
  wire   [4:1] Midori_rounds_sub_sBox_PRINCE_1_f_reg;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_1_e_reg;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_1_h;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_1_g;
  wire   [4:1] Midori_rounds_sub_sBox_PRINCE_1_f;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_1_e;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_2_h_reg;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_2_g_reg;
  wire   [4:1] Midori_rounds_sub_sBox_PRINCE_2_f_reg;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_2_e_reg;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_2_h;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_2_g;
  wire   [4:1] Midori_rounds_sub_sBox_PRINCE_2_f;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_2_e;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_3_h_reg;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_3_g_reg;
  wire   [4:1] Midori_rounds_sub_sBox_PRINCE_3_f_reg;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_3_e_reg;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_3_h;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_3_g;
  wire   [4:1] Midori_rounds_sub_sBox_PRINCE_3_f;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_3_e;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_4_h_reg;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_4_g_reg;
  wire   [4:1] Midori_rounds_sub_sBox_PRINCE_4_f_reg;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_4_e_reg;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_4_h;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_4_g;
  wire   [4:1] Midori_rounds_sub_sBox_PRINCE_4_f;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_4_e;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_5_h_reg;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_5_g_reg;
  wire   [4:1] Midori_rounds_sub_sBox_PRINCE_5_f_reg;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_5_e_reg;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_5_h;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_5_g;
  wire   [4:1] Midori_rounds_sub_sBox_PRINCE_5_f;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_5_e;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_6_h_reg;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_6_g_reg;
  wire   [4:1] Midori_rounds_sub_sBox_PRINCE_6_f_reg;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_6_e_reg;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_6_h;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_6_g;
  wire   [4:1] Midori_rounds_sub_sBox_PRINCE_6_f;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_6_e;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_7_h_reg;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_7_g_reg;
  wire   [4:1] Midori_rounds_sub_sBox_PRINCE_7_f_reg;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_7_e_reg;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_7_h;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_7_g;
  wire   [4:1] Midori_rounds_sub_sBox_PRINCE_7_f;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_7_e;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_8_h_reg;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_8_g_reg;
  wire   [4:1] Midori_rounds_sub_sBox_PRINCE_8_f_reg;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_8_e_reg;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_8_h;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_8_g;
  wire   [4:1] Midori_rounds_sub_sBox_PRINCE_8_f;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_8_e;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_9_h_reg;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_9_g_reg;
  wire   [4:1] Midori_rounds_sub_sBox_PRINCE_9_f_reg;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_9_e_reg;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_9_h;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_9_g;
  wire   [4:1] Midori_rounds_sub_sBox_PRINCE_9_f;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_9_e;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_10_h_reg;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_10_g_reg;
  wire   [4:1] Midori_rounds_sub_sBox_PRINCE_10_f_reg;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_10_e_reg;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_10_h;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_10_g;
  wire   [4:1] Midori_rounds_sub_sBox_PRINCE_10_f;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_10_e;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_11_h_reg;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_11_g_reg;
  wire   [4:1] Midori_rounds_sub_sBox_PRINCE_11_f_reg;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_11_e_reg;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_11_h;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_11_g;
  wire   [4:1] Midori_rounds_sub_sBox_PRINCE_11_f;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_11_e;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_12_h_reg;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_12_g_reg;
  wire   [4:1] Midori_rounds_sub_sBox_PRINCE_12_f_reg;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_12_e_reg;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_12_h;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_12_g;
  wire   [4:1] Midori_rounds_sub_sBox_PRINCE_12_f;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_12_e;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_13_h_reg;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_13_g_reg;
  wire   [4:1] Midori_rounds_sub_sBox_PRINCE_13_f_reg;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_13_e_reg;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_13_h;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_13_g;
  wire   [4:1] Midori_rounds_sub_sBox_PRINCE_13_f;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_13_e;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_14_h_reg;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_14_g_reg;
  wire   [4:1] Midori_rounds_sub_sBox_PRINCE_14_f_reg;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_14_e_reg;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_14_h;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_14_g;
  wire   [4:1] Midori_rounds_sub_sBox_PRINCE_14_f;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_14_e;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_15_h_reg;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_15_g_reg;
  wire   [4:1] Midori_rounds_sub_sBox_PRINCE_15_f_reg;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_15_e_reg;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_15_h;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_15_g;
  wire   [4:1] Midori_rounds_sub_sBox_PRINCE_15_f;
  wire   [8:1] Midori_rounds_sub_sBox_PRINCE_15_e;

  XOR2_X1 keys_U64 ( .A(key[64]), .B(key[0]), .Z(wk[0]) );
  XOR2_X1 keys_U63 ( .A(key[74]), .B(key[10]), .Z(wk[10]) );
  XOR2_X1 keys_U62 ( .A(key[75]), .B(key[11]), .Z(wk[11]) );
  XOR2_X1 keys_U61 ( .A(key[76]), .B(key[12]), .Z(wk[12]) );
  XOR2_X1 keys_U60 ( .A(key[77]), .B(key[13]), .Z(wk[13]) );
  XOR2_X1 keys_U59 ( .A(key[78]), .B(key[14]), .Z(wk[14]) );
  XOR2_X1 keys_U58 ( .A(key[79]), .B(key[15]), .Z(wk[15]) );
  XOR2_X1 keys_U57 ( .A(key[80]), .B(key[16]), .Z(wk[16]) );
  XOR2_X1 keys_U56 ( .A(key[81]), .B(key[17]), .Z(wk[17]) );
  XOR2_X1 keys_U55 ( .A(key[82]), .B(key[18]), .Z(wk[18]) );
  XOR2_X1 keys_U54 ( .A(key[83]), .B(key[19]), .Z(wk[19]) );
  XOR2_X1 keys_U53 ( .A(key[65]), .B(key[1]), .Z(wk[1]) );
  XOR2_X1 keys_U52 ( .A(key[84]), .B(key[20]), .Z(wk[20]) );
  XOR2_X1 keys_U51 ( .A(key[85]), .B(key[21]), .Z(wk[21]) );
  XOR2_X1 keys_U50 ( .A(key[86]), .B(key[22]), .Z(wk[22]) );
  XOR2_X1 keys_U49 ( .A(key[87]), .B(key[23]), .Z(wk[23]) );
  XOR2_X1 keys_U48 ( .A(key[88]), .B(key[24]), .Z(wk[24]) );
  XOR2_X1 keys_U47 ( .A(key[89]), .B(key[25]), .Z(wk[25]) );
  XOR2_X1 keys_U46 ( .A(key[90]), .B(key[26]), .Z(wk[26]) );
  XOR2_X1 keys_U45 ( .A(key[91]), .B(key[27]), .Z(wk[27]) );
  XOR2_X1 keys_U44 ( .A(key[92]), .B(key[28]), .Z(wk[28]) );
  XOR2_X1 keys_U43 ( .A(key[93]), .B(key[29]), .Z(wk[29]) );
  XOR2_X1 keys_U42 ( .A(key[66]), .B(key[2]), .Z(wk[2]) );
  XOR2_X1 keys_U41 ( .A(key[94]), .B(key[30]), .Z(wk[30]) );
  XOR2_X1 keys_U40 ( .A(key[95]), .B(key[31]), .Z(wk[31]) );
  XOR2_X1 keys_U39 ( .A(key[96]), .B(key[32]), .Z(wk[32]) );
  XOR2_X1 keys_U38 ( .A(key[97]), .B(key[33]), .Z(wk[33]) );
  XOR2_X1 keys_U37 ( .A(key[98]), .B(key[34]), .Z(wk[34]) );
  XOR2_X1 keys_U36 ( .A(key[99]), .B(key[35]), .Z(wk[35]) );
  XOR2_X1 keys_U35 ( .A(key[100]), .B(key[36]), .Z(wk[36]) );
  XOR2_X1 keys_U34 ( .A(key[101]), .B(key[37]), .Z(wk[37]) );
  XOR2_X1 keys_U33 ( .A(key[102]), .B(key[38]), .Z(wk[38]) );
  XOR2_X1 keys_U32 ( .A(key[103]), .B(key[39]), .Z(wk[39]) );
  XOR2_X1 keys_U31 ( .A(key[67]), .B(key[3]), .Z(wk[3]) );
  XOR2_X1 keys_U30 ( .A(key[104]), .B(key[40]), .Z(wk[40]) );
  XOR2_X1 keys_U29 ( .A(key[105]), .B(key[41]), .Z(wk[41]) );
  XOR2_X1 keys_U28 ( .A(key[106]), .B(key[42]), .Z(wk[42]) );
  XOR2_X1 keys_U27 ( .A(key[107]), .B(key[43]), .Z(wk[43]) );
  XOR2_X1 keys_U26 ( .A(key[108]), .B(key[44]), .Z(wk[44]) );
  XOR2_X1 keys_U25 ( .A(key[109]), .B(key[45]), .Z(wk[45]) );
  XOR2_X1 keys_U24 ( .A(key[110]), .B(key[46]), .Z(wk[46]) );
  XOR2_X1 keys_U23 ( .A(key[111]), .B(key[47]), .Z(wk[47]) );
  XOR2_X1 keys_U22 ( .A(key[112]), .B(key[48]), .Z(wk[48]) );
  XOR2_X1 keys_U21 ( .A(key[113]), .B(key[49]), .Z(wk[49]) );
  XOR2_X1 keys_U20 ( .A(key[68]), .B(key[4]), .Z(wk[4]) );
  XOR2_X1 keys_U19 ( .A(key[114]), .B(key[50]), .Z(wk[50]) );
  XOR2_X1 keys_U18 ( .A(key[115]), .B(key[51]), .Z(wk[51]) );
  XOR2_X1 keys_U17 ( .A(key[116]), .B(key[52]), .Z(wk[52]) );
  XOR2_X1 keys_U16 ( .A(key[117]), .B(key[53]), .Z(wk[53]) );
  XOR2_X1 keys_U15 ( .A(key[118]), .B(key[54]), .Z(wk[54]) );
  XOR2_X1 keys_U14 ( .A(key[119]), .B(key[55]), .Z(wk[55]) );
  XOR2_X1 keys_U13 ( .A(key[120]), .B(key[56]), .Z(wk[56]) );
  XOR2_X1 keys_U12 ( .A(key[121]), .B(key[57]), .Z(wk[57]) );
  XOR2_X1 keys_U11 ( .A(key[122]), .B(key[58]), .Z(wk[58]) );
  XOR2_X1 keys_U10 ( .A(key[123]), .B(key[59]), .Z(wk[59]) );
  XOR2_X1 keys_U9 ( .A(key[69]), .B(key[5]), .Z(wk[5]) );
  XOR2_X1 keys_U8 ( .A(key[124]), .B(key[60]), .Z(wk[60]) );
  XOR2_X1 keys_U7 ( .A(key[125]), .B(key[61]), .Z(wk[61]) );
  XOR2_X1 keys_U6 ( .A(key[126]), .B(key[62]), .Z(wk[62]) );
  XOR2_X1 keys_U5 ( .A(key[127]), .B(key[63]), .Z(wk[63]) );
  XOR2_X1 keys_U4 ( .A(key[70]), .B(key[6]), .Z(wk[6]) );
  XOR2_X1 keys_U3 ( .A(key[71]), .B(key[7]), .Z(wk[7]) );
  XOR2_X1 keys_U2 ( .A(key[72]), .B(key[8]), .Z(wk[8]) );
  XOR2_X1 keys_U1 ( .A(key[73]), .B(key[9]), .Z(wk[9]) );
  NOR2_X1 controller_U3 ( .A1(controller_n2), .A2(controller_n1), .ZN(done) );
  NAND2_X1 controller_U2 ( .A1(round_Signal[1]), .A2(round_Signal[0]), .ZN(
        controller_n1) );
  NAND2_X1 controller_U1 ( .A1(round_Signal[3]), .A2(round_Signal[2]), .ZN(
        controller_n2) );
  NOR2_X1 controller_roundCounter_U14 ( .A1(reset), .A2(
        controller_roundCounter_q_0_), .ZN(controller_roundCounter_N8) );
  NOR2_X1 controller_roundCounter_U13 ( .A1(controller_roundCounter_n13), .A2(
        reset), .ZN(controller_roundCounter_N9) );
  XNOR2_X1 controller_roundCounter_U12 ( .A(controller_roundCounter_q_0_), .B(
        round_Signal[0]), .ZN(controller_roundCounter_n13) );
  NOR2_X1 controller_roundCounter_U11 ( .A1(controller_roundCounter_n12), .A2(
        reset), .ZN(controller_roundCounter_N10) );
  XNOR2_X1 controller_roundCounter_U10 ( .A(controller_roundCounter_n11), .B(
        round_Signal[1]), .ZN(controller_roundCounter_n12) );
  NOR2_X1 controller_roundCounter_U9 ( .A1(controller_roundCounter_n10), .A2(
        reset), .ZN(controller_roundCounter_N12) );
  XNOR2_X1 controller_roundCounter_U8 ( .A(round_Signal[3]), .B(
        controller_roundCounter_n9), .ZN(controller_roundCounter_n10) );
  NOR2_X1 controller_roundCounter_U7 ( .A1(controller_roundCounter_n6), .A2(
        controller_roundCounter_n8), .ZN(controller_roundCounter_n9) );
  NOR2_X1 controller_roundCounter_U6 ( .A1(controller_roundCounter_n7), .A2(
        reset), .ZN(controller_roundCounter_N11) );
  XNOR2_X1 controller_roundCounter_U5 ( .A(controller_roundCounter_n8), .B(
        controller_roundCounter_n6), .ZN(controller_roundCounter_n7) );
  NAND2_X1 controller_roundCounter_U4 ( .A1(controller_roundCounter_n11), .A2(
        round_Signal[1]), .ZN(controller_roundCounter_n8) );
  AND2_X1 controller_roundCounter_U3 ( .A1(controller_roundCounter_q_0_), .A2(
        round_Signal[0]), .ZN(controller_roundCounter_n11) );
  DFF_X1 controller_roundCounter_count_reg_4_ ( .D(controller_roundCounter_N12), .CK(clk), .Q(round_Signal[3]) , .QN() ); 
  DFF_X1 controller_roundCounter_count_reg_3_ ( .D(controller_roundCounter_N11), .CK(clk), .Q(round_Signal[2]), .QN(controller_roundCounter_n6) );
  DFF_X1 controller_roundCounter_count_reg_2_ ( .D(controller_roundCounter_N10), .CK(clk), .Q(round_Signal[1]) , .QN() ); 
  DFF_X1 controller_roundCounter_count_reg_1_ ( .D(controller_roundCounter_N9), 
        .CK(clk), .Q(round_Signal[0]) , .QN() ); 
  DFF_X1 controller_roundCounter_count_reg_0_ ( .D(controller_roundCounter_N8), 
        .CK(clk), .Q(controller_roundCounter_q_0_) , .QN() ); 
  XOR2_X1 Midori_U128 ( .A(wk[0]), .B(input1[0]), .Z(
        Midori_add_Result_Start1[0]) );
  XOR2_X1 Midori_U127 ( .A(wk[10]), .B(input1[10]), .Z(
        Midori_add_Result_Start1[10]) );
  XOR2_X1 Midori_U126 ( .A(wk[11]), .B(input1[11]), .Z(
        Midori_add_Result_Start1[11]) );
  XOR2_X1 Midori_U125 ( .A(wk[12]), .B(input1[12]), .Z(
        Midori_add_Result_Start1[12]) );
  XOR2_X1 Midori_U124 ( .A(wk[13]), .B(input1[13]), .Z(
        Midori_add_Result_Start1[13]) );
  XOR2_X1 Midori_U123 ( .A(wk[14]), .B(input1[14]), .Z(
        Midori_add_Result_Start1[14]) );
  XOR2_X1 Midori_U122 ( .A(wk[15]), .B(input1[15]), .Z(
        Midori_add_Result_Start1[15]) );
  XOR2_X1 Midori_U121 ( .A(wk[16]), .B(input1[16]), .Z(
        Midori_add_Result_Start1[16]) );
  XOR2_X1 Midori_U120 ( .A(wk[17]), .B(input1[17]), .Z(
        Midori_add_Result_Start1[17]) );
  XOR2_X1 Midori_U119 ( .A(wk[18]), .B(input1[18]), .Z(
        Midori_add_Result_Start1[18]) );
  XOR2_X1 Midori_U118 ( .A(wk[19]), .B(input1[19]), .Z(
        Midori_add_Result_Start1[19]) );
  XOR2_X1 Midori_U117 ( .A(wk[1]), .B(input1[1]), .Z(
        Midori_add_Result_Start1[1]) );
  XOR2_X1 Midori_U116 ( .A(wk[20]), .B(input1[20]), .Z(
        Midori_add_Result_Start1[20]) );
  XOR2_X1 Midori_U115 ( .A(wk[21]), .B(input1[21]), .Z(
        Midori_add_Result_Start1[21]) );
  XOR2_X1 Midori_U114 ( .A(wk[22]), .B(input1[22]), .Z(
        Midori_add_Result_Start1[22]) );
  XOR2_X1 Midori_U113 ( .A(wk[23]), .B(input1[23]), .Z(
        Midori_add_Result_Start1[23]) );
  XOR2_X1 Midori_U112 ( .A(wk[24]), .B(input1[24]), .Z(
        Midori_add_Result_Start1[24]) );
  XOR2_X1 Midori_U111 ( .A(wk[25]), .B(input1[25]), .Z(
        Midori_add_Result_Start1[25]) );
  XOR2_X1 Midori_U110 ( .A(wk[26]), .B(input1[26]), .Z(
        Midori_add_Result_Start1[26]) );
  XOR2_X1 Midori_U109 ( .A(wk[27]), .B(input1[27]), .Z(
        Midori_add_Result_Start1[27]) );
  XOR2_X1 Midori_U108 ( .A(wk[28]), .B(input1[28]), .Z(
        Midori_add_Result_Start1[28]) );
  XOR2_X1 Midori_U107 ( .A(wk[29]), .B(input1[29]), .Z(
        Midori_add_Result_Start1[29]) );
  XOR2_X1 Midori_U106 ( .A(wk[2]), .B(input1[2]), .Z(
        Midori_add_Result_Start1[2]) );
  XOR2_X1 Midori_U105 ( .A(wk[30]), .B(input1[30]), .Z(
        Midori_add_Result_Start1[30]) );
  XOR2_X1 Midori_U104 ( .A(wk[31]), .B(input1[31]), .Z(
        Midori_add_Result_Start1[31]) );
  XOR2_X1 Midori_U103 ( .A(wk[32]), .B(input1[32]), .Z(
        Midori_add_Result_Start1[32]) );
  XOR2_X1 Midori_U102 ( .A(wk[33]), .B(input1[33]), .Z(
        Midori_add_Result_Start1[33]) );
  XOR2_X1 Midori_U101 ( .A(wk[34]), .B(input1[34]), .Z(
        Midori_add_Result_Start1[34]) );
  XOR2_X1 Midori_U100 ( .A(wk[35]), .B(input1[35]), .Z(
        Midori_add_Result_Start1[35]) );
  XOR2_X1 Midori_U99 ( .A(wk[36]), .B(input1[36]), .Z(
        Midori_add_Result_Start1[36]) );
  XOR2_X1 Midori_U98 ( .A(wk[37]), .B(input1[37]), .Z(
        Midori_add_Result_Start1[37]) );
  XOR2_X1 Midori_U97 ( .A(wk[38]), .B(input1[38]), .Z(
        Midori_add_Result_Start1[38]) );
  XOR2_X1 Midori_U96 ( .A(wk[39]), .B(input1[39]), .Z(
        Midori_add_Result_Start1[39]) );
  XOR2_X1 Midori_U95 ( .A(wk[3]), .B(input1[3]), .Z(
        Midori_add_Result_Start1[3]) );
  XOR2_X1 Midori_U94 ( .A(wk[40]), .B(input1[40]), .Z(
        Midori_add_Result_Start1[40]) );
  XOR2_X1 Midori_U93 ( .A(wk[41]), .B(input1[41]), .Z(
        Midori_add_Result_Start1[41]) );
  XOR2_X1 Midori_U92 ( .A(wk[42]), .B(input1[42]), .Z(
        Midori_add_Result_Start1[42]) );
  XOR2_X1 Midori_U91 ( .A(wk[43]), .B(input1[43]), .Z(
        Midori_add_Result_Start1[43]) );
  XOR2_X1 Midori_U90 ( .A(wk[44]), .B(input1[44]), .Z(
        Midori_add_Result_Start1[44]) );
  XOR2_X1 Midori_U89 ( .A(wk[45]), .B(input1[45]), .Z(
        Midori_add_Result_Start1[45]) );
  XOR2_X1 Midori_U88 ( .A(wk[46]), .B(input1[46]), .Z(
        Midori_add_Result_Start1[46]) );
  XOR2_X1 Midori_U87 ( .A(wk[47]), .B(input1[47]), .Z(
        Midori_add_Result_Start1[47]) );
  XOR2_X1 Midori_U86 ( .A(wk[48]), .B(input1[48]), .Z(
        Midori_add_Result_Start1[48]) );
  XOR2_X1 Midori_U85 ( .A(wk[49]), .B(input1[49]), .Z(
        Midori_add_Result_Start1[49]) );
  XOR2_X1 Midori_U84 ( .A(wk[4]), .B(input1[4]), .Z(
        Midori_add_Result_Start1[4]) );
  XOR2_X1 Midori_U83 ( .A(wk[50]), .B(input1[50]), .Z(
        Midori_add_Result_Start1[50]) );
  XOR2_X1 Midori_U82 ( .A(wk[51]), .B(input1[51]), .Z(
        Midori_add_Result_Start1[51]) );
  XOR2_X1 Midori_U81 ( .A(wk[52]), .B(input1[52]), .Z(
        Midori_add_Result_Start1[52]) );
  XOR2_X1 Midori_U80 ( .A(wk[53]), .B(input1[53]), .Z(
        Midori_add_Result_Start1[53]) );
  XOR2_X1 Midori_U79 ( .A(wk[54]), .B(input1[54]), .Z(
        Midori_add_Result_Start1[54]) );
  XOR2_X1 Midori_U78 ( .A(wk[55]), .B(input1[55]), .Z(
        Midori_add_Result_Start1[55]) );
  XOR2_X1 Midori_U77 ( .A(wk[56]), .B(input1[56]), .Z(
        Midori_add_Result_Start1[56]) );
  XOR2_X1 Midori_U76 ( .A(wk[57]), .B(input1[57]), .Z(
        Midori_add_Result_Start1[57]) );
  XOR2_X1 Midori_U75 ( .A(wk[58]), .B(input1[58]), .Z(
        Midori_add_Result_Start1[58]) );
  XOR2_X1 Midori_U74 ( .A(wk[59]), .B(input1[59]), .Z(
        Midori_add_Result_Start1[59]) );
  XOR2_X1 Midori_U73 ( .A(wk[5]), .B(input1[5]), .Z(
        Midori_add_Result_Start1[5]) );
  XOR2_X1 Midori_U72 ( .A(wk[60]), .B(input1[60]), .Z(
        Midori_add_Result_Start1[60]) );
  XOR2_X1 Midori_U71 ( .A(wk[61]), .B(input1[61]), .Z(
        Midori_add_Result_Start1[61]) );
  XOR2_X1 Midori_U70 ( .A(wk[62]), .B(input1[62]), .Z(
        Midori_add_Result_Start1[62]) );
  XOR2_X1 Midori_U69 ( .A(wk[63]), .B(input1[63]), .Z(
        Midori_add_Result_Start1[63]) );
  XOR2_X1 Midori_U68 ( .A(wk[6]), .B(input1[6]), .Z(
        Midori_add_Result_Start1[6]) );
  XOR2_X1 Midori_U67 ( .A(wk[7]), .B(input1[7]), .Z(
        Midori_add_Result_Start1[7]) );
  XOR2_X1 Midori_U66 ( .A(wk[8]), .B(input1[8]), .Z(
        Midori_add_Result_Start1[8]) );
  XOR2_X1 Midori_U65 ( .A(wk[9]), .B(input1[9]), .Z(
        Midori_add_Result_Start1[9]) );
  XOR2_X1 Midori_U64 ( .A(wk[0]), .B(Midori_rounds_SR_Result2[48]), .Z(
        output2[0]) );
  XOR2_X1 Midori_U63 ( .A(wk[10]), .B(Midori_rounds_SR_Result2[10]), .Z(
        output2[10]) );
  XOR2_X1 Midori_U62 ( .A(wk[11]), .B(Midori_rounds_SR_Result2[11]), .Z(
        output2[11]) );
  XOR2_X1 Midori_U61 ( .A(wk[12]), .B(Midori_rounds_SR_Result2[20]), .Z(
        output2[12]) );
  XOR2_X1 Midori_U60 ( .A(wk[13]), .B(Midori_rounds_SR_Result2[21]), .Z(
        output2[13]) );
  XOR2_X1 Midori_U59 ( .A(wk[14]), .B(Midori_rounds_SR_Result2[22]), .Z(
        output2[14]) );
  XOR2_X1 Midori_U58 ( .A(wk[15]), .B(Midori_rounds_SR_Result2[23]), .Z(
        output2[15]) );
  XOR2_X1 Midori_U57 ( .A(wk[16]), .B(Midori_rounds_SR_Result2[36]), .Z(
        output2[16]) );
  XOR2_X1 Midori_U56 ( .A(wk[17]), .B(Midori_rounds_SR_Result2[37]), .Z(
        output2[17]) );
  XOR2_X1 Midori_U55 ( .A(wk[18]), .B(Midori_rounds_SR_Result2[38]), .Z(
        output2[18]) );
  XOR2_X1 Midori_U54 ( .A(wk[19]), .B(Midori_rounds_SR_Result2[39]), .Z(
        output2[19]) );
  XOR2_X1 Midori_U53 ( .A(wk[1]), .B(Midori_rounds_SR_Result2[49]), .Z(
        output2[1]) );
  XOR2_X1 Midori_U52 ( .A(wk[20]), .B(Midori_rounds_SR_Result2[56]), .Z(
        output2[20]) );
  XOR2_X1 Midori_U51 ( .A(wk[21]), .B(Midori_rounds_SR_Result2[57]), .Z(
        output2[21]) );
  XOR2_X1 Midori_U50 ( .A(wk[22]), .B(Midori_rounds_SR_Result2[58]), .Z(
        output2[22]) );
  XOR2_X1 Midori_U49 ( .A(wk[23]), .B(Midori_rounds_SR_Result2[59]), .Z(
        output2[23]) );
  XOR2_X1 Midori_U48 ( .A(wk[24]), .B(Midori_rounds_SR_Result2[28]), .Z(
        output2[24]) );
  XOR2_X1 Midori_U47 ( .A(wk[25]), .B(Midori_rounds_SR_Result2[29]), .Z(
        output2[25]) );
  XOR2_X1 Midori_U46 ( .A(wk[26]), .B(Midori_rounds_SR_Result2[30]), .Z(
        output2[26]) );
  XOR2_X1 Midori_U45 ( .A(wk[27]), .B(Midori_rounds_SR_Result2[31]), .Z(
        output2[27]) );
  XOR2_X1 Midori_U44 ( .A(wk[28]), .B(Midori_rounds_SR_Result2[0]), .Z(
        output2[28]) );
  XOR2_X1 Midori_U43 ( .A(wk[29]), .B(Midori_rounds_SR_Result2[1]), .Z(
        output2[29]) );
  XOR2_X1 Midori_U42 ( .A(wk[2]), .B(Midori_rounds_SR_Result2[50]), .Z(
        output2[2]) );
  XOR2_X1 Midori_U41 ( .A(wk[30]), .B(Midori_rounds_SR_Result2[2]), .Z(
        output2[30]) );
  XOR2_X1 Midori_U40 ( .A(wk[31]), .B(Midori_rounds_SR_Result2[3]), .Z(
        output2[31]) );
  XOR2_X1 Midori_U39 ( .A(wk[32]), .B(Midori_rounds_SR_Result2[12]), .Z(
        output2[32]) );
  XOR2_X1 Midori_U38 ( .A(wk[33]), .B(Midori_rounds_SR_Result2[13]), .Z(
        output2[33]) );
  XOR2_X1 Midori_U37 ( .A(wk[34]), .B(Midori_rounds_SR_Result2[14]), .Z(
        output2[34]) );
  XOR2_X1 Midori_U36 ( .A(wk[35]), .B(Midori_rounds_SR_Result2[15]), .Z(
        output2[35]) );
  XOR2_X1 Midori_U35 ( .A(wk[36]), .B(Midori_rounds_SR_Result2[16]), .Z(
        output2[36]) );
  XOR2_X1 Midori_U34 ( .A(wk[37]), .B(Midori_rounds_SR_Result2[17]), .Z(
        output2[37]) );
  XOR2_X1 Midori_U33 ( .A(wk[38]), .B(Midori_rounds_SR_Result2[18]), .Z(
        output2[38]) );
  XOR2_X1 Midori_U32 ( .A(wk[39]), .B(Midori_rounds_SR_Result2[19]), .Z(
        output2[39]) );
  XOR2_X1 Midori_U31 ( .A(wk[3]), .B(Midori_rounds_SR_Result2[51]), .Z(
        output2[3]) );
  XOR2_X1 Midori_U30 ( .A(wk[40]), .B(Midori_rounds_SR_Result2[52]), .Z(
        output2[40]) );
  XOR2_X1 Midori_U29 ( .A(wk[41]), .B(Midori_rounds_SR_Result2[53]), .Z(
        output2[41]) );
  XOR2_X1 Midori_U28 ( .A(wk[42]), .B(Midori_rounds_SR_Result2[54]), .Z(
        output2[42]) );
  XOR2_X1 Midori_U27 ( .A(wk[43]), .B(Midori_rounds_SR_Result2[55]), .Z(
        output2[43]) );
  XOR2_X1 Midori_U26 ( .A(wk[44]), .B(Midori_rounds_SR_Result2[40]), .Z(
        output2[44]) );
  XOR2_X1 Midori_U25 ( .A(wk[45]), .B(Midori_rounds_SR_Result2[41]), .Z(
        output2[45]) );
  XOR2_X1 Midori_U24 ( .A(wk[46]), .B(Midori_rounds_SR_Result2[42]), .Z(
        output2[46]) );
  XOR2_X1 Midori_U23 ( .A(wk[47]), .B(Midori_rounds_SR_Result2[43]), .Z(
        output2[47]) );
  XOR2_X1 Midori_U22 ( .A(wk[48]), .B(Midori_rounds_SR_Result2[24]), .Z(
        output2[48]) );
  XOR2_X1 Midori_U21 ( .A(wk[49]), .B(Midori_rounds_SR_Result2[25]), .Z(
        output2[49]) );
  XOR2_X1 Midori_U20 ( .A(wk[4]), .B(Midori_rounds_SR_Result2[44]), .Z(
        output2[4]) );
  XOR2_X1 Midori_U19 ( .A(wk[50]), .B(Midori_rounds_SR_Result2[26]), .Z(
        output2[50]) );
  XOR2_X1 Midori_U18 ( .A(wk[51]), .B(Midori_rounds_SR_Result2[27]), .Z(
        output2[51]) );
  XOR2_X1 Midori_U17 ( .A(wk[52]), .B(Midori_rounds_SR_Result2[4]), .Z(
        output2[52]) );
  XOR2_X1 Midori_U16 ( .A(wk[53]), .B(Midori_rounds_SR_Result2[5]), .Z(
        output2[53]) );
  XOR2_X1 Midori_U15 ( .A(wk[54]), .B(Midori_rounds_SR_Result2[6]), .Z(
        output2[54]) );
  XOR2_X1 Midori_U14 ( .A(wk[55]), .B(Midori_rounds_SR_Result2[7]), .Z(
        output2[55]) );
  XOR2_X1 Midori_U13 ( .A(wk[56]), .B(Midori_rounds_SR_Result2[32]), .Z(
        output2[56]) );
  XOR2_X1 Midori_U12 ( .A(wk[57]), .B(Midori_rounds_SR_Result2[33]), .Z(
        output2[57]) );
  XOR2_X1 Midori_U11 ( .A(wk[58]), .B(Midori_rounds_SR_Result2[34]), .Z(
        output2[58]) );
  XOR2_X1 Midori_U10 ( .A(wk[59]), .B(Midori_rounds_SR_Result2[35]), .Z(
        output2[59]) );
  XOR2_X1 Midori_U9 ( .A(wk[5]), .B(Midori_rounds_SR_Result2[45]), .Z(
        output2[5]) );
  XOR2_X1 Midori_U8 ( .A(wk[60]), .B(Midori_rounds_SR_Result2[60]), .Z(
        output2[60]) );
  XOR2_X1 Midori_U7 ( .A(wk[61]), .B(Midori_rounds_SR_Result2[61]), .Z(
        output2[61]) );
  XOR2_X1 Midori_U6 ( .A(wk[62]), .B(Midori_rounds_SR_Result2[62]), .Z(
        output2[62]) );
  XOR2_X1 Midori_U5 ( .A(wk[63]), .B(Midori_rounds_SR_Result2[63]), .Z(
        output2[63]) );
  XOR2_X1 Midori_U4 ( .A(wk[6]), .B(Midori_rounds_SR_Result2[46]), .Z(
        output2[6]) );
  XOR2_X1 Midori_U3 ( .A(wk[7]), .B(Midori_rounds_SR_Result2[47]), .Z(
        output2[7]) );
  XOR2_X1 Midori_U2 ( .A(wk[8]), .B(Midori_rounds_SR_Result2[8]), .Z(
        output2[8]) );
  XOR2_X1 Midori_U1 ( .A(wk[9]), .B(Midori_rounds_SR_Result2[9]), .Z(
        output2[9]) );
  MUX2_X1 Midori_rounds_U469 ( .A(output1[1]), .B(output1[49]), .S(enc_dec), 
        .Z(Midori_rounds_mul_input1[49]) );
  MUX2_X1 Midori_rounds_U468 ( .A(output1[53]), .B(output1[5]), .S(enc_dec), 
        .Z(Midori_rounds_mul_input1[5]) );
  MUX2_X1 Midori_rounds_U467 ( .A(output1[41]), .B(output1[53]), .S(enc_dec), 
        .Z(Midori_rounds_mul_input1[53]) );
  MUX2_X1 Midori_rounds_U466 ( .A(output1[17]), .B(output1[37]), .S(enc_dec), 
        .Z(Midori_rounds_mul_input1[37]) );
  MUX2_X1 Midori_rounds_U465 ( .A(output1[29]), .B(output1[1]), .S(enc_dec), 
        .Z(Midori_rounds_mul_input1[1]) );
  MUX2_X1 Midori_rounds_U464 ( .A(output1[37]), .B(output1[17]), .S(enc_dec), 
        .Z(Midori_rounds_mul_input1[17]) );
  MUX2_X1 Midori_rounds_U463 ( .A(output1[57]), .B(output1[33]), .S(enc_dec), 
        .Z(Midori_rounds_mul_input1[33]) );
  MUX2_X1 Midori_rounds_U462 ( .A(output1[13]), .B(output1[21]), .S(enc_dec), 
        .Z(Midori_rounds_mul_input1[21]) );
  MUX2_X1 Midori_rounds_U461 ( .A(output1[3]), .B(output1[51]), .S(enc_dec), 
        .Z(Midori_rounds_mul_input1[51]) );
  MUX2_X1 Midori_rounds_U460 ( .A(output1[42]), .B(output1[54]), .S(enc_dec), 
        .Z(Midori_rounds_mul_input1[54]) );
  MUX2_X1 Midori_rounds_U459 ( .A(output1[40]), .B(output1[52]), .S(enc_dec), 
        .Z(Midori_rounds_mul_input1[52]) );
  MUX2_X1 Midori_rounds_U458 ( .A(output1[55]), .B(output1[7]), .S(enc_dec), 
        .Z(Midori_rounds_mul_input1[7]) );
  MUX2_X1 Midori_rounds_U457 ( .A(output1[30]), .B(output1[2]), .S(enc_dec), 
        .Z(Midori_rounds_mul_input1[2]) );
  MUX2_X1 Midori_rounds_U456 ( .A(output1[28]), .B(output1[0]), .S(enc_dec), 
        .Z(Midori_rounds_mul_input1[0]) );
  MUX2_X1 Midori_rounds_U455 ( .A(output1[52]), .B(output1[4]), .S(enc_dec), 
        .Z(Midori_rounds_mul_input1[4]) );
  MUX2_X1 Midori_rounds_U454 ( .A(output1[43]), .B(output1[55]), .S(enc_dec), 
        .Z(Midori_rounds_mul_input1[55]) );
  MUX2_X1 Midori_rounds_U453 ( .A(output1[2]), .B(output1[50]), .S(enc_dec), 
        .Z(Midori_rounds_mul_input1[50]) );
  MUX2_X1 Midori_rounds_U452 ( .A(output1[0]), .B(output1[48]), .S(enc_dec), 
        .Z(Midori_rounds_mul_input1[48]) );
  MUX2_X1 Midori_rounds_U451 ( .A(output1[19]), .B(output1[39]), .S(enc_dec), 
        .Z(Midori_rounds_mul_input1[39]) );
  MUX2_X1 Midori_rounds_U450 ( .A(output1[18]), .B(output1[38]), .S(enc_dec), 
        .Z(Midori_rounds_mul_input1[38]) );
  MUX2_X1 Midori_rounds_U449 ( .A(output1[16]), .B(output1[36]), .S(enc_dec), 
        .Z(Midori_rounds_mul_input1[36]) );
  MUX2_X1 Midori_rounds_U448 ( .A(output1[31]), .B(output1[3]), .S(enc_dec), 
        .Z(Midori_rounds_mul_input1[3]) );
  MUX2_X1 Midori_rounds_U447 ( .A(output1[39]), .B(output1[19]), .S(enc_dec), 
        .Z(Midori_rounds_mul_input1[19]) );
  MUX2_X1 Midori_rounds_U446 ( .A(output1[14]), .B(output1[22]), .S(enc_dec), 
        .Z(Midori_rounds_mul_input1[22]) );
  MUX2_X1 Midori_rounds_U445 ( .A(output1[12]), .B(output1[20]), .S(enc_dec), 
        .Z(Midori_rounds_mul_input1[20]) );
  MUX2_X1 Midori_rounds_U444 ( .A(output1[59]), .B(output1[35]), .S(enc_dec), 
        .Z(Midori_rounds_mul_input1[35]) );
  MUX2_X1 Midori_rounds_U443 ( .A(output1[58]), .B(output1[34]), .S(enc_dec), 
        .Z(Midori_rounds_mul_input1[34]) );
  MUX2_X1 Midori_rounds_U442 ( .A(output1[56]), .B(output1[32]), .S(enc_dec), 
        .Z(Midori_rounds_mul_input1[32]) );
  MUX2_X1 Midori_rounds_U441 ( .A(output1[15]), .B(output1[23]), .S(enc_dec), 
        .Z(Midori_rounds_mul_input1[23]) );
  MUX2_X1 Midori_rounds_U440 ( .A(output1[38]), .B(output1[18]), .S(enc_dec), 
        .Z(Midori_rounds_mul_input1[18]) );
  MUX2_X1 Midori_rounds_U439 ( .A(output1[54]), .B(output1[6]), .S(enc_dec), 
        .Z(Midori_rounds_mul_input1[6]) );
  MUX2_X1 Midori_rounds_U438 ( .A(output1[36]), .B(output1[16]), .S(enc_dec), 
        .Z(Midori_rounds_mul_input1[16]) );
  MUX2_X1 Midori_rounds_U437 ( .A(output1[21]), .B(output1[57]), .S(enc_dec), 
        .Z(Midori_rounds_mul_input1[57]) );
  MUX2_X1 Midori_rounds_U436 ( .A(output1[61]), .B(output1[61]), .S(enc_dec), 
        .Z(Midori_rounds_mul_input1[61]) );
  MUX2_X1 Midori_rounds_U435 ( .A(output1[45]), .B(output1[41]), .S(enc_dec), 
        .Z(Midori_rounds_mul_input1[41]) );
  MUX2_X1 Midori_rounds_U434 ( .A(output1[33]), .B(output1[13]), .S(enc_dec), 
        .Z(Midori_rounds_mul_input1[13]) );
  MUX2_X1 Midori_rounds_U433 ( .A(output1[25]), .B(output1[29]), .S(enc_dec), 
        .Z(Midori_rounds_mul_input1[29]) );
  MUX2_X1 Midori_rounds_U432 ( .A(output1[5]), .B(output1[45]), .S(enc_dec), 
        .Z(Midori_rounds_mul_input1[45]) );
  MUX2_X1 Midori_rounds_U431 ( .A(output1[49]), .B(output1[25]), .S(enc_dec), 
        .Z(Midori_rounds_mul_input1[25]) );
  MUX2_X1 Midori_rounds_U430 ( .A(output1[9]), .B(output1[9]), .S(enc_dec), 
        .Z(Midori_rounds_mul_input1[9]) );
  MUX2_X1 Midori_rounds_U429 ( .A(output1[32]), .B(output1[12]), .S(enc_dec), 
        .Z(Midori_rounds_mul_input1[12]) );
  MUX2_X1 Midori_rounds_U428 ( .A(output1[60]), .B(output1[60]), .S(enc_dec), 
        .Z(Midori_rounds_mul_input1[60]) );
  MUX2_X1 Midori_rounds_U427 ( .A(output1[23]), .B(output1[59]), .S(enc_dec), 
        .Z(Midori_rounds_mul_input1[59]) );
  MUX2_X1 Midori_rounds_U426 ( .A(output1[22]), .B(output1[58]), .S(enc_dec), 
        .Z(Midori_rounds_mul_input1[58]) );
  MUX2_X1 Midori_rounds_U425 ( .A(output1[20]), .B(output1[56]), .S(enc_dec), 
        .Z(Midori_rounds_mul_input1[56]) );
  MUX2_X1 Midori_rounds_U424 ( .A(output1[63]), .B(output1[63]), .S(enc_dec), 
        .Z(Midori_rounds_mul_input1[63]) );
  MUX2_X1 Midori_rounds_U423 ( .A(output1[47]), .B(output1[43]), .S(enc_dec), 
        .Z(Midori_rounds_mul_input1[43]) );
  MUX2_X1 Midori_rounds_U422 ( .A(output1[62]), .B(output1[62]), .S(enc_dec), 
        .Z(Midori_rounds_mul_input1[62]) );
  MUX2_X1 Midori_rounds_U421 ( .A(output1[6]), .B(output1[46]), .S(enc_dec), 
        .Z(Midori_rounds_mul_input1[46]) );
  MUX2_X1 Midori_rounds_U420 ( .A(output1[4]), .B(output1[44]), .S(enc_dec), 
        .Z(Midori_rounds_mul_input1[44]) );
  MUX2_X1 Midori_rounds_U419 ( .A(output1[35]), .B(output1[15]), .S(enc_dec), 
        .Z(Midori_rounds_mul_input1[15]) );
  MUX2_X1 Midori_rounds_U418 ( .A(output1[10]), .B(output1[10]), .S(enc_dec), 
        .Z(Midori_rounds_mul_input1[10]) );
  MUX2_X1 Midori_rounds_U417 ( .A(output1[8]), .B(output1[8]), .S(enc_dec), 
        .Z(Midori_rounds_mul_input1[8]) );
  MUX2_X1 Midori_rounds_U416 ( .A(output1[27]), .B(output1[31]), .S(enc_dec), 
        .Z(Midori_rounds_mul_input1[31]) );
  MUX2_X1 Midori_rounds_U415 ( .A(output1[26]), .B(output1[30]), .S(enc_dec), 
        .Z(Midori_rounds_mul_input1[30]) );
  MUX2_X1 Midori_rounds_U414 ( .A(output1[24]), .B(output1[28]), .S(enc_dec), 
        .Z(Midori_rounds_mul_input1[28]) );
  MUX2_X1 Midori_rounds_U413 ( .A(output1[7]), .B(output1[47]), .S(enc_dec), 
        .Z(Midori_rounds_mul_input1[47]) );
  MUX2_X1 Midori_rounds_U412 ( .A(output1[46]), .B(output1[42]), .S(enc_dec), 
        .Z(Midori_rounds_mul_input1[42]) );
  MUX2_X1 Midori_rounds_U411 ( .A(output1[44]), .B(output1[40]), .S(enc_dec), 
        .Z(Midori_rounds_mul_input1[40]) );
  MUX2_X1 Midori_rounds_U410 ( .A(output1[51]), .B(output1[27]), .S(enc_dec), 
        .Z(Midori_rounds_mul_input1[27]) );
  MUX2_X1 Midori_rounds_U409 ( .A(output1[11]), .B(output1[11]), .S(enc_dec), 
        .Z(Midori_rounds_mul_input1[11]) );
  MUX2_X1 Midori_rounds_U408 ( .A(output1[50]), .B(output1[26]), .S(enc_dec), 
        .Z(Midori_rounds_mul_input1[26]) );
  MUX2_X1 Midori_rounds_U407 ( .A(output1[34]), .B(output1[14]), .S(enc_dec), 
        .Z(Midori_rounds_mul_input1[14]) );
  MUX2_X1 Midori_rounds_U406 ( .A(output1[48]), .B(output1[24]), .S(enc_dec), 
        .Z(Midori_rounds_mul_input1[24]) );
  MUX2_X1 Midori_rounds_U405 ( .A(Midori_rounds_n1092), .B(
        Midori_rounds_SR_Inv_Result2[60]), .S(enc_dec), .Z(
        Midori_rounds_round_Result2[60]) );
  XNOR2_X1 Midori_rounds_U404 ( .A(Midori_rounds_n1091), .B(
        Midori_rounds_SR_Inv_Result2[60]), .ZN(Midori_rounds_n1092) );
  MUX2_X1 Midori_rounds_U403 ( .A(Midori_rounds_n1090), .B(
        Midori_rounds_SR_Inv_Result2[56]), .S(enc_dec), .Z(
        Midori_rounds_round_Result2[56]) );
  XNOR2_X1 Midori_rounds_U402 ( .A(Midori_rounds_n1089), .B(
        Midori_rounds_SR_Inv_Result2[20]), .ZN(Midori_rounds_n1090) );
  MUX2_X1 Midori_rounds_U401 ( .A(Midori_rounds_n1088), .B(
        Midori_rounds_SR_Inv_Result2[52]), .S(enc_dec), .Z(
        Midori_rounds_round_Result2[52]) );
  XNOR2_X1 Midori_rounds_U400 ( .A(Midori_rounds_n1087), .B(
        Midori_rounds_SR_Inv_Result2[40]), .ZN(Midori_rounds_n1088) );
  MUX2_X1 Midori_rounds_U399 ( .A(Midori_rounds_n1086), .B(
        Midori_rounds_SR_Inv_Result2[48]), .S(enc_dec), .Z(
        Midori_rounds_round_Result2[48]) );
  XNOR2_X1 Midori_rounds_U398 ( .A(Midori_rounds_n1085), .B(
        Midori_rounds_SR_Inv_Result2[0]), .ZN(Midori_rounds_n1086) );
  MUX2_X1 Midori_rounds_U397 ( .A(Midori_rounds_n1084), .B(
        Midori_rounds_SR_Inv_Result2[44]), .S(enc_dec), .Z(
        Midori_rounds_round_Result2[44]) );
  XNOR2_X1 Midori_rounds_U396 ( .A(Midori_rounds_n1083), .B(
        Midori_rounds_SR_Inv_Result2[4]), .ZN(Midori_rounds_n1084) );
  MUX2_X1 Midori_rounds_U395 ( .A(Midori_rounds_n1082), .B(
        Midori_rounds_SR_Inv_Result2[40]), .S(enc_dec), .Z(
        Midori_rounds_round_Result2[40]) );
  XNOR2_X1 Midori_rounds_U394 ( .A(Midori_rounds_n1081), .B(
        Midori_rounds_SR_Inv_Result2[44]), .ZN(Midori_rounds_n1082) );
  MUX2_X1 Midori_rounds_U393 ( .A(Midori_rounds_n1080), .B(
        Midori_rounds_SR_Inv_Result2[36]), .S(enc_dec), .Z(
        Midori_rounds_round_Result2[36]) );
  XNOR2_X1 Midori_rounds_U392 ( .A(Midori_rounds_n1079), .B(
        Midori_rounds_SR_Inv_Result2[16]), .ZN(Midori_rounds_n1080) );
  MUX2_X1 Midori_rounds_U391 ( .A(Midori_rounds_n1078), .B(
        Midori_rounds_SR_Inv_Result2[32]), .S(enc_dec), .Z(
        Midori_rounds_round_Result2[32]) );
  XNOR2_X1 Midori_rounds_U390 ( .A(Midori_rounds_n1077), .B(
        Midori_rounds_SR_Inv_Result2[56]), .ZN(Midori_rounds_n1078) );
  MUX2_X1 Midori_rounds_U389 ( .A(Midori_rounds_n1076), .B(
        Midori_rounds_SR_Inv_Result2[28]), .S(enc_dec), .Z(
        Midori_rounds_round_Result2[28]) );
  XNOR2_X1 Midori_rounds_U388 ( .A(Midori_rounds_n1075), .B(
        Midori_rounds_SR_Inv_Result2[24]), .ZN(Midori_rounds_n1076) );
  MUX2_X1 Midori_rounds_U387 ( .A(Midori_rounds_n1074), .B(
        Midori_rounds_SR_Inv_Result2[24]), .S(enc_dec), .Z(
        Midori_rounds_round_Result2[24]) );
  XNOR2_X1 Midori_rounds_U386 ( .A(Midori_rounds_n1073), .B(
        Midori_rounds_SR_Inv_Result2[48]), .ZN(Midori_rounds_n1074) );
  MUX2_X1 Midori_rounds_U385 ( .A(Midori_rounds_n1072), .B(
        Midori_rounds_SR_Inv_Result2[20]), .S(enc_dec), .Z(
        Midori_rounds_round_Result2[20]) );
  XNOR2_X1 Midori_rounds_U384 ( .A(Midori_rounds_n1071), .B(
        Midori_rounds_SR_Inv_Result2[12]), .ZN(Midori_rounds_n1072) );
  MUX2_X1 Midori_rounds_U383 ( .A(Midori_rounds_n1070), .B(
        Midori_rounds_SR_Inv_Result2[16]), .S(enc_dec), .Z(
        Midori_rounds_round_Result2[16]) );
  XNOR2_X1 Midori_rounds_U382 ( .A(Midori_rounds_n1069), .B(
        Midori_rounds_SR_Inv_Result2[36]), .ZN(Midori_rounds_n1070) );
  MUX2_X1 Midori_rounds_U381 ( .A(Midori_rounds_n1068), .B(
        Midori_rounds_SR_Inv_Result2[12]), .S(enc_dec), .Z(
        Midori_rounds_round_Result2[12]) );
  XNOR2_X1 Midori_rounds_U380 ( .A(Midori_rounds_n1067), .B(
        Midori_rounds_SR_Inv_Result2[32]), .ZN(Midori_rounds_n1068) );
  MUX2_X1 Midori_rounds_U379 ( .A(Midori_rounds_n1066), .B(
        Midori_rounds_SR_Inv_Result2[8]), .S(enc_dec), .Z(
        Midori_rounds_round_Result2[8]) );
  XNOR2_X1 Midori_rounds_U378 ( .A(Midori_rounds_n1065), .B(
        Midori_rounds_SR_Inv_Result2[8]), .ZN(Midori_rounds_n1066) );
  MUX2_X1 Midori_rounds_U377 ( .A(Midori_rounds_n1064), .B(
        Midori_rounds_SR_Inv_Result2[4]), .S(enc_dec), .Z(
        Midori_rounds_round_Result2[4]) );
  XNOR2_X1 Midori_rounds_U376 ( .A(Midori_rounds_n1063), .B(
        Midori_rounds_SR_Inv_Result2[52]), .ZN(Midori_rounds_n1064) );
  MUX2_X1 Midori_rounds_U375 ( .A(Midori_rounds_n1062), .B(
        Midori_rounds_SR_Inv_Result2[0]), .S(enc_dec), .Z(
        Midori_rounds_round_Result2[0]) );
  XNOR2_X1 Midori_rounds_U374 ( .A(Midori_rounds_n1061), .B(
        Midori_rounds_SR_Inv_Result2[28]), .ZN(Midori_rounds_n1062) );
  MUX2_X1 Midori_rounds_U373 ( .A(Midori_rounds_n1060), .B(
        Midori_rounds_SR_Inv_Result2[63]), .S(enc_dec), .Z(
        Midori_rounds_round_Result2[63]) );
  XOR2_X1 Midori_rounds_U372 ( .A(Midori_rounds_n1059), .B(
        Midori_rounds_SR_Inv_Result2[63]), .Z(Midori_rounds_n1060) );
  MUX2_X1 Midori_rounds_U371 ( .A(Midori_rounds_n1058), .B(
        Midori_rounds_SR_Inv_Result2[62]), .S(enc_dec), .Z(
        Midori_rounds_round_Result2[62]) );
  XOR2_X1 Midori_rounds_U370 ( .A(Midori_rounds_n1057), .B(
        Midori_rounds_SR_Inv_Result2[62]), .Z(Midori_rounds_n1058) );
  MUX2_X1 Midori_rounds_U369 ( .A(Midori_rounds_n1056), .B(
        Midori_rounds_SR_Inv_Result2[61]), .S(enc_dec), .Z(
        Midori_rounds_round_Result2[61]) );
  XOR2_X1 Midori_rounds_U368 ( .A(Midori_rounds_n1055), .B(
        Midori_rounds_SR_Inv_Result2[61]), .Z(Midori_rounds_n1056) );
  MUX2_X1 Midori_rounds_U367 ( .A(Midori_rounds_n1054), .B(
        Midori_rounds_SR_Inv_Result2[59]), .S(enc_dec), .Z(
        Midori_rounds_round_Result2[59]) );
  XOR2_X1 Midori_rounds_U366 ( .A(Midori_rounds_n1053), .B(
        Midori_rounds_SR_Inv_Result2[23]), .Z(Midori_rounds_n1054) );
  MUX2_X1 Midori_rounds_U365 ( .A(Midori_rounds_n1052), .B(
        Midori_rounds_SR_Inv_Result2[58]), .S(enc_dec), .Z(
        Midori_rounds_round_Result2[58]) );
  XOR2_X1 Midori_rounds_U364 ( .A(Midori_rounds_n1051), .B(
        Midori_rounds_SR_Inv_Result2[22]), .Z(Midori_rounds_n1052) );
  MUX2_X1 Midori_rounds_U363 ( .A(Midori_rounds_n1050), .B(
        Midori_rounds_SR_Inv_Result2[57]), .S(enc_dec), .Z(
        Midori_rounds_round_Result2[57]) );
  XOR2_X1 Midori_rounds_U362 ( .A(Midori_rounds_n1049), .B(
        Midori_rounds_SR_Inv_Result2[21]), .Z(Midori_rounds_n1050) );
  MUX2_X1 Midori_rounds_U361 ( .A(Midori_rounds_n1048), .B(
        Midori_rounds_SR_Inv_Result2[55]), .S(enc_dec), .Z(
        Midori_rounds_round_Result2[55]) );
  XOR2_X1 Midori_rounds_U360 ( .A(Midori_rounds_n1047), .B(
        Midori_rounds_SR_Inv_Result2[43]), .Z(Midori_rounds_n1048) );
  MUX2_X1 Midori_rounds_U359 ( .A(Midori_rounds_n1046), .B(
        Midori_rounds_SR_Inv_Result2[54]), .S(enc_dec), .Z(
        Midori_rounds_round_Result2[54]) );
  XOR2_X1 Midori_rounds_U358 ( .A(Midori_rounds_n1045), .B(
        Midori_rounds_SR_Inv_Result2[42]), .Z(Midori_rounds_n1046) );
  MUX2_X1 Midori_rounds_U357 ( .A(Midori_rounds_n1044), .B(
        Midori_rounds_SR_Inv_Result2[53]), .S(enc_dec), .Z(
        Midori_rounds_round_Result2[53]) );
  XOR2_X1 Midori_rounds_U356 ( .A(Midori_rounds_n1043), .B(
        Midori_rounds_SR_Inv_Result2[41]), .Z(Midori_rounds_n1044) );
  MUX2_X1 Midori_rounds_U355 ( .A(Midori_rounds_n1042), .B(
        Midori_rounds_SR_Inv_Result2[51]), .S(enc_dec), .Z(
        Midori_rounds_round_Result2[51]) );
  XOR2_X1 Midori_rounds_U354 ( .A(Midori_rounds_n1041), .B(
        Midori_rounds_SR_Inv_Result2[3]), .Z(Midori_rounds_n1042) );
  MUX2_X1 Midori_rounds_U353 ( .A(Midori_rounds_n1040), .B(
        Midori_rounds_SR_Inv_Result2[50]), .S(enc_dec), .Z(
        Midori_rounds_round_Result2[50]) );
  XOR2_X1 Midori_rounds_U352 ( .A(Midori_rounds_n1039), .B(
        Midori_rounds_SR_Inv_Result2[2]), .Z(Midori_rounds_n1040) );
  MUX2_X1 Midori_rounds_U351 ( .A(Midori_rounds_n1038), .B(
        Midori_rounds_SR_Inv_Result2[49]), .S(enc_dec), .Z(
        Midori_rounds_round_Result2[49]) );
  XOR2_X1 Midori_rounds_U350 ( .A(Midori_rounds_n1037), .B(
        Midori_rounds_SR_Inv_Result2[1]), .Z(Midori_rounds_n1038) );
  MUX2_X1 Midori_rounds_U349 ( .A(Midori_rounds_n1036), .B(
        Midori_rounds_SR_Inv_Result2[47]), .S(enc_dec), .Z(
        Midori_rounds_round_Result2[47]) );
  XOR2_X1 Midori_rounds_U348 ( .A(Midori_rounds_n1035), .B(
        Midori_rounds_SR_Inv_Result2[7]), .Z(Midori_rounds_n1036) );
  MUX2_X1 Midori_rounds_U347 ( .A(Midori_rounds_n1034), .B(
        Midori_rounds_SR_Inv_Result2[46]), .S(enc_dec), .Z(
        Midori_rounds_round_Result2[46]) );
  XOR2_X1 Midori_rounds_U346 ( .A(Midori_rounds_n1033), .B(
        Midori_rounds_SR_Inv_Result2[6]), .Z(Midori_rounds_n1034) );
  MUX2_X1 Midori_rounds_U345 ( .A(Midori_rounds_n1032), .B(
        Midori_rounds_SR_Inv_Result2[45]), .S(enc_dec), .Z(
        Midori_rounds_round_Result2[45]) );
  XOR2_X1 Midori_rounds_U344 ( .A(Midori_rounds_n1031), .B(
        Midori_rounds_SR_Inv_Result2[5]), .Z(Midori_rounds_n1032) );
  MUX2_X1 Midori_rounds_U343 ( .A(Midori_rounds_n1030), .B(
        Midori_rounds_SR_Inv_Result2[43]), .S(enc_dec), .Z(
        Midori_rounds_round_Result2[43]) );
  XOR2_X1 Midori_rounds_U342 ( .A(Midori_rounds_n1029), .B(
        Midori_rounds_SR_Inv_Result2[47]), .Z(Midori_rounds_n1030) );
  MUX2_X1 Midori_rounds_U341 ( .A(Midori_rounds_n1028), .B(
        Midori_rounds_SR_Inv_Result2[42]), .S(enc_dec), .Z(
        Midori_rounds_round_Result2[42]) );
  XOR2_X1 Midori_rounds_U340 ( .A(Midori_rounds_n1027), .B(
        Midori_rounds_SR_Inv_Result2[46]), .Z(Midori_rounds_n1028) );
  MUX2_X1 Midori_rounds_U339 ( .A(Midori_rounds_n1026), .B(
        Midori_rounds_SR_Inv_Result2[41]), .S(enc_dec), .Z(
        Midori_rounds_round_Result2[41]) );
  XOR2_X1 Midori_rounds_U338 ( .A(Midori_rounds_n1025), .B(
        Midori_rounds_SR_Inv_Result2[45]), .Z(Midori_rounds_n1026) );
  MUX2_X1 Midori_rounds_U337 ( .A(Midori_rounds_n1024), .B(
        Midori_rounds_SR_Inv_Result2[39]), .S(enc_dec), .Z(
        Midori_rounds_round_Result2[39]) );
  XOR2_X1 Midori_rounds_U336 ( .A(Midori_rounds_n1023), .B(
        Midori_rounds_SR_Inv_Result2[19]), .Z(Midori_rounds_n1024) );
  MUX2_X1 Midori_rounds_U335 ( .A(Midori_rounds_n1022), .B(
        Midori_rounds_SR_Inv_Result2[38]), .S(enc_dec), .Z(
        Midori_rounds_round_Result2[38]) );
  XOR2_X1 Midori_rounds_U334 ( .A(Midori_rounds_n1021), .B(
        Midori_rounds_SR_Inv_Result2[18]), .Z(Midori_rounds_n1022) );
  MUX2_X1 Midori_rounds_U333 ( .A(Midori_rounds_n1020), .B(
        Midori_rounds_SR_Inv_Result2[37]), .S(enc_dec), .Z(
        Midori_rounds_round_Result2[37]) );
  XOR2_X1 Midori_rounds_U332 ( .A(Midori_rounds_n1019), .B(
        Midori_rounds_SR_Inv_Result2[17]), .Z(Midori_rounds_n1020) );
  MUX2_X1 Midori_rounds_U331 ( .A(Midori_rounds_n1018), .B(
        Midori_rounds_SR_Inv_Result2[35]), .S(enc_dec), .Z(
        Midori_rounds_round_Result2[35]) );
  XOR2_X1 Midori_rounds_U330 ( .A(Midori_rounds_n1017), .B(
        Midori_rounds_SR_Inv_Result2[59]), .Z(Midori_rounds_n1018) );
  MUX2_X1 Midori_rounds_U329 ( .A(Midori_rounds_n1016), .B(
        Midori_rounds_SR_Inv_Result2[34]), .S(enc_dec), .Z(
        Midori_rounds_round_Result2[34]) );
  XOR2_X1 Midori_rounds_U328 ( .A(Midori_rounds_n1015), .B(
        Midori_rounds_SR_Inv_Result2[58]), .Z(Midori_rounds_n1016) );
  MUX2_X1 Midori_rounds_U327 ( .A(Midori_rounds_n1014), .B(
        Midori_rounds_SR_Inv_Result2[33]), .S(enc_dec), .Z(
        Midori_rounds_round_Result2[33]) );
  XOR2_X1 Midori_rounds_U326 ( .A(Midori_rounds_n1013), .B(
        Midori_rounds_SR_Inv_Result2[57]), .Z(Midori_rounds_n1014) );
  MUX2_X1 Midori_rounds_U325 ( .A(Midori_rounds_n1012), .B(
        Midori_rounds_SR_Inv_Result2[31]), .S(enc_dec), .Z(
        Midori_rounds_round_Result2[31]) );
  XOR2_X1 Midori_rounds_U324 ( .A(Midori_rounds_n1011), .B(
        Midori_rounds_SR_Inv_Result2[27]), .Z(Midori_rounds_n1012) );
  MUX2_X1 Midori_rounds_U323 ( .A(Midori_rounds_n1010), .B(
        Midori_rounds_SR_Inv_Result2[30]), .S(enc_dec), .Z(
        Midori_rounds_round_Result2[30]) );
  XOR2_X1 Midori_rounds_U322 ( .A(Midori_rounds_n1009), .B(
        Midori_rounds_SR_Inv_Result2[26]), .Z(Midori_rounds_n1010) );
  MUX2_X1 Midori_rounds_U321 ( .A(Midori_rounds_n1008), .B(
        Midori_rounds_SR_Inv_Result2[29]), .S(enc_dec), .Z(
        Midori_rounds_round_Result2[29]) );
  XOR2_X1 Midori_rounds_U320 ( .A(Midori_rounds_n1007), .B(
        Midori_rounds_SR_Inv_Result2[25]), .Z(Midori_rounds_n1008) );
  MUX2_X1 Midori_rounds_U319 ( .A(Midori_rounds_n1006), .B(
        Midori_rounds_SR_Inv_Result2[27]), .S(enc_dec), .Z(
        Midori_rounds_round_Result2[27]) );
  XOR2_X1 Midori_rounds_U318 ( .A(Midori_rounds_n1005), .B(
        Midori_rounds_SR_Inv_Result2[51]), .Z(Midori_rounds_n1006) );
  MUX2_X1 Midori_rounds_U317 ( .A(Midori_rounds_n1004), .B(
        Midori_rounds_SR_Inv_Result2[26]), .S(enc_dec), .Z(
        Midori_rounds_round_Result2[26]) );
  XOR2_X1 Midori_rounds_U316 ( .A(Midori_rounds_n1003), .B(
        Midori_rounds_SR_Inv_Result2[50]), .Z(Midori_rounds_n1004) );
  MUX2_X1 Midori_rounds_U315 ( .A(Midori_rounds_n1002), .B(
        Midori_rounds_SR_Inv_Result2[25]), .S(enc_dec), .Z(
        Midori_rounds_round_Result2[25]) );
  XOR2_X1 Midori_rounds_U314 ( .A(Midori_rounds_n1001), .B(
        Midori_rounds_SR_Inv_Result2[49]), .Z(Midori_rounds_n1002) );
  MUX2_X1 Midori_rounds_U313 ( .A(Midori_rounds_n1000), .B(
        Midori_rounds_SR_Inv_Result2[23]), .S(enc_dec), .Z(
        Midori_rounds_round_Result2[23]) );
  XOR2_X1 Midori_rounds_U312 ( .A(Midori_rounds_n999), .B(
        Midori_rounds_SR_Inv_Result2[15]), .Z(Midori_rounds_n1000) );
  MUX2_X1 Midori_rounds_U311 ( .A(Midori_rounds_n998), .B(
        Midori_rounds_SR_Inv_Result2[22]), .S(enc_dec), .Z(
        Midori_rounds_round_Result2[22]) );
  XOR2_X1 Midori_rounds_U310 ( .A(Midori_rounds_n997), .B(
        Midori_rounds_SR_Inv_Result2[14]), .Z(Midori_rounds_n998) );
  MUX2_X1 Midori_rounds_U309 ( .A(Midori_rounds_n996), .B(
        Midori_rounds_SR_Inv_Result2[21]), .S(enc_dec), .Z(
        Midori_rounds_round_Result2[21]) );
  XOR2_X1 Midori_rounds_U308 ( .A(Midori_rounds_n995), .B(
        Midori_rounds_SR_Inv_Result2[13]), .Z(Midori_rounds_n996) );
  MUX2_X1 Midori_rounds_U307 ( .A(Midori_rounds_n994), .B(
        Midori_rounds_SR_Inv_Result2[19]), .S(enc_dec), .Z(
        Midori_rounds_round_Result2[19]) );
  XOR2_X1 Midori_rounds_U306 ( .A(Midori_rounds_n993), .B(
        Midori_rounds_SR_Inv_Result2[39]), .Z(Midori_rounds_n994) );
  MUX2_X1 Midori_rounds_U305 ( .A(Midori_rounds_n992), .B(
        Midori_rounds_SR_Inv_Result2[18]), .S(enc_dec), .Z(
        Midori_rounds_round_Result2[18]) );
  XOR2_X1 Midori_rounds_U304 ( .A(Midori_rounds_n991), .B(
        Midori_rounds_SR_Inv_Result2[38]), .Z(Midori_rounds_n992) );
  MUX2_X1 Midori_rounds_U303 ( .A(Midori_rounds_n990), .B(
        Midori_rounds_SR_Inv_Result2[17]), .S(enc_dec), .Z(
        Midori_rounds_round_Result2[17]) );
  XOR2_X1 Midori_rounds_U302 ( .A(Midori_rounds_n989), .B(
        Midori_rounds_SR_Inv_Result2[37]), .Z(Midori_rounds_n990) );
  MUX2_X1 Midori_rounds_U301 ( .A(Midori_rounds_n988), .B(
        Midori_rounds_SR_Inv_Result2[15]), .S(enc_dec), .Z(
        Midori_rounds_round_Result2[15]) );
  XOR2_X1 Midori_rounds_U300 ( .A(Midori_rounds_n987), .B(
        Midori_rounds_SR_Inv_Result2[35]), .Z(Midori_rounds_n988) );
  MUX2_X1 Midori_rounds_U299 ( .A(Midori_rounds_n986), .B(
        Midori_rounds_SR_Inv_Result2[14]), .S(enc_dec), .Z(
        Midori_rounds_round_Result2[14]) );
  XOR2_X1 Midori_rounds_U298 ( .A(Midori_rounds_n985), .B(
        Midori_rounds_SR_Inv_Result2[34]), .Z(Midori_rounds_n986) );
  MUX2_X1 Midori_rounds_U297 ( .A(Midori_rounds_n984), .B(
        Midori_rounds_SR_Inv_Result2[13]), .S(enc_dec), .Z(
        Midori_rounds_round_Result2[13]) );
  XOR2_X1 Midori_rounds_U296 ( .A(Midori_rounds_n983), .B(
        Midori_rounds_SR_Inv_Result2[33]), .Z(Midori_rounds_n984) );
  MUX2_X1 Midori_rounds_U295 ( .A(Midori_rounds_n982), .B(
        Midori_rounds_SR_Inv_Result2[11]), .S(enc_dec), .Z(
        Midori_rounds_round_Result2[11]) );
  XOR2_X1 Midori_rounds_U294 ( .A(Midori_rounds_n981), .B(
        Midori_rounds_SR_Inv_Result2[11]), .Z(Midori_rounds_n982) );
  MUX2_X1 Midori_rounds_U293 ( .A(Midori_rounds_n980), .B(
        Midori_rounds_SR_Inv_Result2[10]), .S(enc_dec), .Z(
        Midori_rounds_round_Result2[10]) );
  XOR2_X1 Midori_rounds_U292 ( .A(Midori_rounds_n979), .B(
        Midori_rounds_SR_Inv_Result2[10]), .Z(Midori_rounds_n980) );
  MUX2_X1 Midori_rounds_U291 ( .A(Midori_rounds_n978), .B(
        Midori_rounds_SR_Inv_Result2[9]), .S(enc_dec), .Z(
        Midori_rounds_round_Result2[9]) );
  XOR2_X1 Midori_rounds_U290 ( .A(Midori_rounds_n977), .B(
        Midori_rounds_SR_Inv_Result2[9]), .Z(Midori_rounds_n978) );
  MUX2_X1 Midori_rounds_U289 ( .A(Midori_rounds_n976), .B(
        Midori_rounds_SR_Inv_Result2[7]), .S(enc_dec), .Z(
        Midori_rounds_round_Result2[7]) );
  XOR2_X1 Midori_rounds_U288 ( .A(Midori_rounds_n975), .B(
        Midori_rounds_SR_Inv_Result2[55]), .Z(Midori_rounds_n976) );
  MUX2_X1 Midori_rounds_U287 ( .A(Midori_rounds_n974), .B(
        Midori_rounds_SR_Inv_Result2[6]), .S(enc_dec), .Z(
        Midori_rounds_round_Result2[6]) );
  XOR2_X1 Midori_rounds_U286 ( .A(Midori_rounds_n973), .B(
        Midori_rounds_SR_Inv_Result2[54]), .Z(Midori_rounds_n974) );
  MUX2_X1 Midori_rounds_U285 ( .A(Midori_rounds_n972), .B(
        Midori_rounds_SR_Inv_Result2[5]), .S(enc_dec), .Z(
        Midori_rounds_round_Result2[5]) );
  XOR2_X1 Midori_rounds_U284 ( .A(Midori_rounds_n971), .B(
        Midori_rounds_SR_Inv_Result2[53]), .Z(Midori_rounds_n972) );
  MUX2_X1 Midori_rounds_U283 ( .A(Midori_rounds_n970), .B(
        Midori_rounds_SR_Inv_Result2[3]), .S(enc_dec), .Z(
        Midori_rounds_round_Result2[3]) );
  XOR2_X1 Midori_rounds_U282 ( .A(Midori_rounds_n969), .B(
        Midori_rounds_SR_Inv_Result2[31]), .Z(Midori_rounds_n970) );
  MUX2_X1 Midori_rounds_U281 ( .A(Midori_rounds_n968), .B(
        Midori_rounds_SR_Inv_Result2[2]), .S(enc_dec), .Z(
        Midori_rounds_round_Result2[2]) );
  XOR2_X1 Midori_rounds_U280 ( .A(Midori_rounds_n967), .B(
        Midori_rounds_SR_Inv_Result2[30]), .Z(Midori_rounds_n968) );
  MUX2_X1 Midori_rounds_U279 ( .A(Midori_rounds_n966), .B(
        Midori_rounds_SR_Inv_Result2[1]), .S(enc_dec), .Z(
        Midori_rounds_round_Result2[1]) );
  XOR2_X1 Midori_rounds_U278 ( .A(Midori_rounds_n965), .B(
        Midori_rounds_SR_Inv_Result2[29]), .Z(Midori_rounds_n966) );
  MUX2_X1 Midori_rounds_U277 ( .A(Midori_rounds_SR_Result2[6]), .B(
        Midori_rounds_n964), .S(enc_dec), .Z(Midori_rounds_mul_input2[6]) );
  XOR2_X1 Midori_rounds_U276 ( .A(Midori_rounds_SR_Result2[46]), .B(
        Midori_rounds_n973), .Z(Midori_rounds_n964) );
  MUX2_X1 Midori_rounds_U275 ( .A(key[70]), .B(key[6]), .S(round_Signal[0]), 
        .Z(Midori_rounds_n973) );
  MUX2_X1 Midori_rounds_U274 ( .A(Midori_rounds_SR_Result2[51]), .B(
        Midori_rounds_n963), .S(enc_dec), .Z(Midori_rounds_mul_input2[51]) );
  XOR2_X1 Midori_rounds_U273 ( .A(Midori_rounds_SR_Result2[27]), .B(
        Midori_rounds_n1041), .Z(Midori_rounds_n963) );
  MUX2_X1 Midori_rounds_U272 ( .A(key[115]), .B(key[51]), .S(
        Midori_rounds_n962), .Z(Midori_rounds_n1041) );
  MUX2_X1 Midori_rounds_U271 ( .A(Midori_rounds_SR_Result2[54]), .B(
        Midori_rounds_n961), .S(enc_dec), .Z(Midori_rounds_mul_input2[54]) );
  XOR2_X1 Midori_rounds_U270 ( .A(Midori_rounds_SR_Result2[6]), .B(
        Midori_rounds_n1045), .Z(Midori_rounds_n961) );
  MUX2_X1 Midori_rounds_U269 ( .A(key[118]), .B(key[54]), .S(
        Midori_rounds_n962), .Z(Midori_rounds_n1045) );
  MUX2_X1 Midori_rounds_U268 ( .A(Midori_rounds_SR_Result2[49]), .B(
        Midori_rounds_n960), .S(enc_dec), .Z(Midori_rounds_mul_input2[49]) );
  XOR2_X1 Midori_rounds_U267 ( .A(Midori_rounds_SR_Result2[25]), .B(
        Midori_rounds_n1037), .Z(Midori_rounds_n960) );
  MUX2_X1 Midori_rounds_U266 ( .A(key[113]), .B(key[49]), .S(
        Midori_rounds_n962), .Z(Midori_rounds_n1037) );
  MUX2_X1 Midori_rounds_U265 ( .A(Midori_rounds_SR_Result2[34]), .B(
        Midori_rounds_n959), .S(enc_dec), .Z(Midori_rounds_mul_input2[34]) );
  XOR2_X1 Midori_rounds_U264 ( .A(Midori_rounds_SR_Result2[14]), .B(
        Midori_rounds_n1015), .Z(Midori_rounds_n959) );
  MUX2_X1 Midori_rounds_U263 ( .A(key[98]), .B(key[34]), .S(round_Signal[0]), 
        .Z(Midori_rounds_n1015) );
  MUX2_X1 Midori_rounds_U262 ( .A(Midori_rounds_SR_Result2[18]), .B(
        Midori_rounds_n958), .S(enc_dec), .Z(Midori_rounds_mul_input2[18]) );
  XOR2_X1 Midori_rounds_U261 ( .A(Midori_rounds_SR_Result2[38]), .B(
        Midori_rounds_n991), .Z(Midori_rounds_n958) );
  MUX2_X1 Midori_rounds_U260 ( .A(key[82]), .B(key[18]), .S(Midori_rounds_n962), .Z(Midori_rounds_n991) );
  MUX2_X1 Midori_rounds_U259 ( .A(Midori_rounds_SR_Result2[55]), .B(
        Midori_rounds_n957), .S(enc_dec), .Z(Midori_rounds_mul_input2[55]) );
  XOR2_X1 Midori_rounds_U258 ( .A(Midori_rounds_SR_Result2[7]), .B(
        Midori_rounds_n1047), .Z(Midori_rounds_n957) );
  MUX2_X1 Midori_rounds_U257 ( .A(key[119]), .B(key[55]), .S(round_Signal[0]), 
        .Z(Midori_rounds_n1047) );
  MUX2_X1 Midori_rounds_U256 ( .A(Midori_rounds_SR_Result2[50]), .B(
        Midori_rounds_n956), .S(enc_dec), .Z(Midori_rounds_mul_input2[50]) );
  XOR2_X1 Midori_rounds_U255 ( .A(Midori_rounds_SR_Result2[26]), .B(
        Midori_rounds_n1039), .Z(Midori_rounds_n956) );
  MUX2_X1 Midori_rounds_U254 ( .A(key[114]), .B(key[50]), .S(
        Midori_rounds_n962), .Z(Midori_rounds_n1039) );
  MUX2_X1 Midori_rounds_U253 ( .A(Midori_rounds_SR_Result2[53]), .B(
        Midori_rounds_n955), .S(enc_dec), .Z(Midori_rounds_mul_input2[53]) );
  XOR2_X1 Midori_rounds_U252 ( .A(Midori_rounds_SR_Result2[5]), .B(
        Midori_rounds_n1043), .Z(Midori_rounds_n955) );
  MUX2_X1 Midori_rounds_U251 ( .A(key[117]), .B(key[53]), .S(round_Signal[0]), 
        .Z(Midori_rounds_n1043) );
  MUX2_X1 Midori_rounds_U250 ( .A(Midori_rounds_SR_Result2[35]), .B(
        Midori_rounds_n954), .S(enc_dec), .Z(Midori_rounds_mul_input2[35]) );
  XOR2_X1 Midori_rounds_U249 ( .A(Midori_rounds_SR_Result2[15]), .B(
        Midori_rounds_n1017), .Z(Midori_rounds_n954) );
  MUX2_X1 Midori_rounds_U248 ( .A(key[99]), .B(key[35]), .S(Midori_rounds_n962), .Z(Midori_rounds_n1017) );
  MUX2_X1 Midori_rounds_U247 ( .A(Midori_rounds_SR_Result2[38]), .B(
        Midori_rounds_n953), .S(enc_dec), .Z(Midori_rounds_mul_input2[38]) );
  XOR2_X1 Midori_rounds_U246 ( .A(Midori_rounds_SR_Result2[18]), .B(
        Midori_rounds_n1021), .Z(Midori_rounds_n953) );
  MUX2_X1 Midori_rounds_U245 ( .A(key[102]), .B(key[38]), .S(
        Midori_rounds_n962), .Z(Midori_rounds_n1021) );
  MUX2_X1 Midori_rounds_U244 ( .A(Midori_rounds_SR_Result2[33]), .B(
        Midori_rounds_n952), .S(enc_dec), .Z(Midori_rounds_mul_input2[33]) );
  XOR2_X1 Midori_rounds_U243 ( .A(Midori_rounds_SR_Result2[13]), .B(
        Midori_rounds_n1013), .Z(Midori_rounds_n952) );
  MUX2_X1 Midori_rounds_U242 ( .A(key[97]), .B(key[33]), .S(Midori_rounds_n962), .Z(Midori_rounds_n1013) );
  MUX2_X1 Midori_rounds_U241 ( .A(Midori_rounds_SR_Result2[39]), .B(
        Midori_rounds_n951), .S(enc_dec), .Z(Midori_rounds_mul_input2[39]) );
  XOR2_X1 Midori_rounds_U240 ( .A(Midori_rounds_SR_Result2[19]), .B(
        Midori_rounds_n1023), .Z(Midori_rounds_n951) );
  MUX2_X1 Midori_rounds_U239 ( .A(key[103]), .B(key[39]), .S(
        Midori_rounds_n1093), .Z(Midori_rounds_n1023) );
  MUX2_X1 Midori_rounds_U238 ( .A(Midori_rounds_SR_Result2[37]), .B(
        Midori_rounds_n950), .S(enc_dec), .Z(Midori_rounds_mul_input2[37]) );
  XOR2_X1 Midori_rounds_U237 ( .A(Midori_rounds_SR_Result2[17]), .B(
        Midori_rounds_n1019), .Z(Midori_rounds_n950) );
  MUX2_X1 Midori_rounds_U236 ( .A(key[101]), .B(key[37]), .S(
        Midori_rounds_n962), .Z(Midori_rounds_n1019) );
  MUX2_X1 Midori_rounds_U235 ( .A(Midori_rounds_SR_Result2[19]), .B(
        Midori_rounds_n949), .S(enc_dec), .Z(Midori_rounds_mul_input2[19]) );
  XOR2_X1 Midori_rounds_U234 ( .A(Midori_rounds_SR_Result2[39]), .B(
        Midori_rounds_n993), .Z(Midori_rounds_n949) );
  MUX2_X1 Midori_rounds_U233 ( .A(key[83]), .B(key[19]), .S(round_Signal[0]), 
        .Z(Midori_rounds_n993) );
  MUX2_X1 Midori_rounds_U232 ( .A(Midori_rounds_SR_Result2[22]), .B(
        Midori_rounds_n948), .S(enc_dec), .Z(Midori_rounds_mul_input2[22]) );
  XOR2_X1 Midori_rounds_U231 ( .A(Midori_rounds_SR_Result2[58]), .B(
        Midori_rounds_n997), .Z(Midori_rounds_n948) );
  MUX2_X1 Midori_rounds_U230 ( .A(key[86]), .B(key[22]), .S(Midori_rounds_n962), .Z(Midori_rounds_n997) );
  MUX2_X1 Midori_rounds_U229 ( .A(Midori_rounds_SR_Result2[17]), .B(
        Midori_rounds_n947), .S(enc_dec), .Z(Midori_rounds_mul_input2[17]) );
  XOR2_X1 Midori_rounds_U228 ( .A(Midori_rounds_SR_Result2[37]), .B(
        Midori_rounds_n989), .Z(Midori_rounds_n947) );
  MUX2_X1 Midori_rounds_U227 ( .A(key[81]), .B(key[17]), .S(Midori_rounds_n962), .Z(Midori_rounds_n989) );
  MUX2_X1 Midori_rounds_U226 ( .A(Midori_rounds_SR_Result2[23]), .B(
        Midori_rounds_n946), .S(enc_dec), .Z(Midori_rounds_mul_input2[23]) );
  XOR2_X1 Midori_rounds_U225 ( .A(Midori_rounds_SR_Result2[59]), .B(
        Midori_rounds_n999), .Z(Midori_rounds_n946) );
  MUX2_X1 Midori_rounds_U224 ( .A(key[87]), .B(key[23]), .S(
        Midori_rounds_n1093), .Z(Midori_rounds_n999) );
  MUX2_X1 Midori_rounds_U223 ( .A(Midori_rounds_SR_Result2[21]), .B(
        Midori_rounds_n945), .S(enc_dec), .Z(Midori_rounds_mul_input2[21]) );
  XOR2_X1 Midori_rounds_U222 ( .A(Midori_rounds_SR_Result2[57]), .B(
        Midori_rounds_n995), .Z(Midori_rounds_n945) );
  MUX2_X1 Midori_rounds_U221 ( .A(key[85]), .B(key[21]), .S(round_Signal[0]), 
        .Z(Midori_rounds_n995) );
  MUX2_X1 Midori_rounds_U220 ( .A(Midori_rounds_SR_Result2[7]), .B(
        Midori_rounds_n944), .S(enc_dec), .Z(Midori_rounds_mul_input2[7]) );
  XOR2_X1 Midori_rounds_U219 ( .A(Midori_rounds_SR_Result2[47]), .B(
        Midori_rounds_n975), .Z(Midori_rounds_n944) );
  MUX2_X1 Midori_rounds_U218 ( .A(key[71]), .B(key[7]), .S(Midori_rounds_n962), 
        .Z(Midori_rounds_n975) );
  MUX2_X1 Midori_rounds_U217 ( .A(Midori_rounds_SR_Result2[2]), .B(
        Midori_rounds_n943), .S(enc_dec), .Z(Midori_rounds_mul_input2[2]) );
  XOR2_X1 Midori_rounds_U216 ( .A(Midori_rounds_SR_Result2[50]), .B(
        Midori_rounds_n967), .Z(Midori_rounds_n943) );
  MUX2_X1 Midori_rounds_U215 ( .A(key[66]), .B(key[2]), .S(Midori_rounds_n962), 
        .Z(Midori_rounds_n967) );
  MUX2_X1 Midori_rounds_U214 ( .A(Midori_rounds_SR_Result2[5]), .B(
        Midori_rounds_n942), .S(enc_dec), .Z(Midori_rounds_mul_input2[5]) );
  XOR2_X1 Midori_rounds_U213 ( .A(Midori_rounds_SR_Result2[45]), .B(
        Midori_rounds_n971), .Z(Midori_rounds_n942) );
  MUX2_X1 Midori_rounds_U212 ( .A(key[69]), .B(key[5]), .S(Midori_rounds_n962), 
        .Z(Midori_rounds_n971) );
  MUX2_X1 Midori_rounds_U211 ( .A(Midori_rounds_SR_Result2[3]), .B(
        Midori_rounds_n941), .S(enc_dec), .Z(Midori_rounds_mul_input2[3]) );
  XOR2_X1 Midori_rounds_U210 ( .A(Midori_rounds_SR_Result2[51]), .B(
        Midori_rounds_n969), .Z(Midori_rounds_n941) );
  MUX2_X1 Midori_rounds_U209 ( .A(key[67]), .B(key[3]), .S(round_Signal[0]), 
        .Z(Midori_rounds_n969) );
  MUX2_X1 Midori_rounds_U208 ( .A(Midori_rounds_SR_Result2[1]), .B(
        Midori_rounds_n940), .S(enc_dec), .Z(Midori_rounds_mul_input2[1]) );
  XOR2_X1 Midori_rounds_U207 ( .A(Midori_rounds_SR_Result2[49]), .B(
        Midori_rounds_n965), .Z(Midori_rounds_n940) );
  MUX2_X1 Midori_rounds_U206 ( .A(key[65]), .B(key[1]), .S(round_Signal[0]), 
        .Z(Midori_rounds_n965) );
  MUX2_X1 Midori_rounds_U205 ( .A(Midori_rounds_SR_Result2[32]), .B(
        Midori_rounds_n939), .S(enc_dec), .Z(Midori_rounds_mul_input2[32]) );
  XNOR2_X1 Midori_rounds_U204 ( .A(Midori_rounds_SR_Result2[12]), .B(
        Midori_rounds_n1077), .ZN(Midori_rounds_n939) );
  XNOR2_X1 Midori_rounds_U203 ( .A(Midori_rounds_round_Constant[8]), .B(
        Midori_rounds_n938), .ZN(Midori_rounds_n1077) );
  MUX2_X1 Midori_rounds_U202 ( .A(key[96]), .B(key[32]), .S(Midori_rounds_n962), .Z(Midori_rounds_n938) );
  MUX2_X1 Midori_rounds_U201 ( .A(Midori_rounds_SR_Result2[48]), .B(
        Midori_rounds_n937), .S(enc_dec), .Z(Midori_rounds_mul_input2[48]) );
  XNOR2_X1 Midori_rounds_U200 ( .A(Midori_rounds_SR_Result2[24]), .B(
        Midori_rounds_n1085), .ZN(Midori_rounds_n937) );
  XNOR2_X1 Midori_rounds_U199 ( .A(Midori_rounds_round_Constant[12]), .B(
        Midori_rounds_n936), .ZN(Midori_rounds_n1085) );
  MUX2_X1 Midori_rounds_U198 ( .A(key[112]), .B(key[48]), .S(
        Midori_rounds_n962), .Z(Midori_rounds_n936) );
  MUX2_X1 Midori_rounds_U197 ( .A(Midori_rounds_SR_Result2[20]), .B(
        Midori_rounds_n935), .S(enc_dec), .Z(Midori_rounds_mul_input2[20]) );
  XNOR2_X1 Midori_rounds_U196 ( .A(Midori_rounds_SR_Result2[56]), .B(
        Midori_rounds_n1071), .ZN(Midori_rounds_n935) );
  XNOR2_X1 Midori_rounds_U195 ( .A(Midori_rounds_round_Constant[5]), .B(
        Midori_rounds_n934), .ZN(Midori_rounds_n1071) );
  MUX2_X1 Midori_rounds_U194 ( .A(key[84]), .B(key[20]), .S(Midori_rounds_n962), .Z(Midori_rounds_n934) );
  MUX2_X1 Midori_rounds_U193 ( .A(Midori_rounds_SR_Result2[4]), .B(
        Midori_rounds_n933), .S(enc_dec), .Z(Midori_rounds_mul_input2[4]) );
  XNOR2_X1 Midori_rounds_U192 ( .A(Midori_rounds_SR_Result2[44]), .B(
        Midori_rounds_n1063), .ZN(Midori_rounds_n933) );
  XNOR2_X1 Midori_rounds_U191 ( .A(Midori_rounds_round_Constant[1]), .B(
        Midori_rounds_n932), .ZN(Midori_rounds_n1063) );
  MUX2_X1 Midori_rounds_U190 ( .A(key[68]), .B(key[4]), .S(Midori_rounds_n962), 
        .Z(Midori_rounds_n932) );
  MUX2_X1 Midori_rounds_U189 ( .A(Midori_rounds_SR_Result2[0]), .B(
        Midori_rounds_n931), .S(enc_dec), .Z(Midori_rounds_mul_input2[0]) );
  XNOR2_X1 Midori_rounds_U188 ( .A(Midori_rounds_SR_Result2[48]), .B(
        Midori_rounds_n1061), .ZN(Midori_rounds_n931) );
  XNOR2_X1 Midori_rounds_U187 ( .A(Midori_rounds_round_Constant[0]), .B(
        Midori_rounds_n930), .ZN(Midori_rounds_n1061) );
  MUX2_X1 Midori_rounds_U186 ( .A(key[64]), .B(key[0]), .S(Midori_rounds_n962), 
        .Z(Midori_rounds_n930) );
  MUX2_X1 Midori_rounds_U185 ( .A(Midori_rounds_SR_Result2[59]), .B(
        Midori_rounds_n929), .S(enc_dec), .Z(Midori_rounds_mul_input2[59]) );
  XOR2_X1 Midori_rounds_U184 ( .A(Midori_rounds_SR_Result2[35]), .B(
        Midori_rounds_n1053), .Z(Midori_rounds_n929) );
  MUX2_X1 Midori_rounds_U183 ( .A(key[123]), .B(key[59]), .S(
        Midori_rounds_n962), .Z(Midori_rounds_n1053) );
  MUX2_X1 Midori_rounds_U182 ( .A(Midori_rounds_SR_Result2[63]), .B(
        Midori_rounds_n928), .S(enc_dec), .Z(Midori_rounds_mul_input2[63]) );
  XOR2_X1 Midori_rounds_U181 ( .A(Midori_rounds_SR_Result2[63]), .B(
        Midori_rounds_n1059), .Z(Midori_rounds_n928) );
  MUX2_X1 Midori_rounds_U180 ( .A(key[127]), .B(key[63]), .S(
        Midori_rounds_n962), .Z(Midori_rounds_n1059) );
  MUX2_X1 Midori_rounds_U179 ( .A(Midori_rounds_SR_Result2[61]), .B(
        Midori_rounds_n927), .S(enc_dec), .Z(Midori_rounds_mul_input2[61]) );
  XOR2_X1 Midori_rounds_U178 ( .A(Midori_rounds_SR_Result2[61]), .B(
        Midori_rounds_n1055), .Z(Midori_rounds_n927) );
  MUX2_X1 Midori_rounds_U177 ( .A(key[125]), .B(key[61]), .S(
        Midori_rounds_n962), .Z(Midori_rounds_n1055) );
  MUX2_X1 Midori_rounds_U176 ( .A(Midori_rounds_SR_Result2[42]), .B(
        Midori_rounds_n926), .S(enc_dec), .Z(Midori_rounds_mul_input2[42]) );
  XOR2_X1 Midori_rounds_U175 ( .A(Midori_rounds_SR_Result2[54]), .B(
        Midori_rounds_n1027), .Z(Midori_rounds_n926) );
  MUX2_X1 Midori_rounds_U174 ( .A(key[106]), .B(key[42]), .S(
        Midori_rounds_n962), .Z(Midori_rounds_n1027) );
  MUX2_X1 Midori_rounds_U173 ( .A(Midori_rounds_SR_Result2[26]), .B(
        Midori_rounds_n925), .S(enc_dec), .Z(Midori_rounds_mul_input2[26]) );
  XOR2_X1 Midori_rounds_U172 ( .A(Midori_rounds_SR_Result2[30]), .B(
        Midori_rounds_n1003), .Z(Midori_rounds_n925) );
  MUX2_X1 Midori_rounds_U171 ( .A(key[90]), .B(key[26]), .S(Midori_rounds_n962), .Z(Midori_rounds_n1003) );
  MUX2_X1 Midori_rounds_U170 ( .A(Midori_rounds_SR_Result2[62]), .B(
        Midori_rounds_n924), .S(enc_dec), .Z(Midori_rounds_mul_input2[62]) );
  XOR2_X1 Midori_rounds_U169 ( .A(Midori_rounds_SR_Result2[62]), .B(
        Midori_rounds_n1057), .Z(Midori_rounds_n924) );
  MUX2_X1 Midori_rounds_U168 ( .A(key[126]), .B(key[62]), .S(
        Midori_rounds_n962), .Z(Midori_rounds_n1057) );
  MUX2_X1 Midori_rounds_U167 ( .A(Midori_rounds_SR_Result2[58]), .B(
        Midori_rounds_n923), .S(enc_dec), .Z(Midori_rounds_mul_input2[58]) );
  XOR2_X1 Midori_rounds_U166 ( .A(Midori_rounds_SR_Result2[34]), .B(
        Midori_rounds_n1051), .Z(Midori_rounds_n923) );
  MUX2_X1 Midori_rounds_U165 ( .A(key[122]), .B(key[58]), .S(
        Midori_rounds_n962), .Z(Midori_rounds_n1051) );
  MUX2_X1 Midori_rounds_U164 ( .A(Midori_rounds_SR_Result2[57]), .B(
        Midori_rounds_n922), .S(enc_dec), .Z(Midori_rounds_mul_input2[57]) );
  XOR2_X1 Midori_rounds_U163 ( .A(Midori_rounds_SR_Result2[33]), .B(
        Midori_rounds_n1049), .Z(Midori_rounds_n922) );
  MUX2_X1 Midori_rounds_U162 ( .A(key[121]), .B(key[57]), .S(round_Signal[0]), 
        .Z(Midori_rounds_n1049) );
  MUX2_X1 Midori_rounds_U161 ( .A(Midori_rounds_SR_Result2[47]), .B(
        Midori_rounds_n921), .S(enc_dec), .Z(Midori_rounds_mul_input2[47]) );
  XOR2_X1 Midori_rounds_U160 ( .A(Midori_rounds_SR_Result2[43]), .B(
        Midori_rounds_n1035), .Z(Midori_rounds_n921) );
  MUX2_X1 Midori_rounds_U159 ( .A(key[111]), .B(key[47]), .S(
        Midori_rounds_n962), .Z(Midori_rounds_n1035) );
  MUX2_X1 Midori_rounds_U158 ( .A(Midori_rounds_SR_Result2[46]), .B(
        Midori_rounds_n920), .S(enc_dec), .Z(Midori_rounds_mul_input2[46]) );
  XOR2_X1 Midori_rounds_U157 ( .A(Midori_rounds_SR_Result2[42]), .B(
        Midori_rounds_n1033), .Z(Midori_rounds_n920) );
  MUX2_X1 Midori_rounds_U156 ( .A(key[110]), .B(key[46]), .S(
        Midori_rounds_n962), .Z(Midori_rounds_n1033) );
  MUX2_X1 Midori_rounds_U155 ( .A(Midori_rounds_SR_Result2[45]), .B(
        Midori_rounds_n919), .S(enc_dec), .Z(Midori_rounds_mul_input2[45]) );
  XOR2_X1 Midori_rounds_U154 ( .A(Midori_rounds_SR_Result2[41]), .B(
        Midori_rounds_n1031), .Z(Midori_rounds_n919) );
  MUX2_X1 Midori_rounds_U153 ( .A(key[109]), .B(key[45]), .S(
        Midori_rounds_n962), .Z(Midori_rounds_n1031) );
  MUX2_X1 Midori_rounds_U152 ( .A(Midori_rounds_SR_Result2[43]), .B(
        Midori_rounds_n918), .S(enc_dec), .Z(Midori_rounds_mul_input2[43]) );
  XOR2_X1 Midori_rounds_U151 ( .A(Midori_rounds_SR_Result2[55]), .B(
        Midori_rounds_n1029), .Z(Midori_rounds_n918) );
  MUX2_X1 Midori_rounds_U150 ( .A(key[107]), .B(key[43]), .S(
        Midori_rounds_n1093), .Z(Midori_rounds_n1029) );
  MUX2_X1 Midori_rounds_U149 ( .A(Midori_rounds_SR_Result2[41]), .B(
        Midori_rounds_n917), .S(enc_dec), .Z(Midori_rounds_mul_input2[41]) );
  XOR2_X1 Midori_rounds_U148 ( .A(Midori_rounds_SR_Result2[53]), .B(
        Midori_rounds_n1025), .Z(Midori_rounds_n917) );
  MUX2_X1 Midori_rounds_U147 ( .A(key[105]), .B(key[41]), .S(round_Signal[0]), 
        .Z(Midori_rounds_n1025) );
  MUX2_X1 Midori_rounds_U146 ( .A(Midori_rounds_SR_Result2[31]), .B(
        Midori_rounds_n916), .S(enc_dec), .Z(Midori_rounds_mul_input2[31]) );
  XOR2_X1 Midori_rounds_U145 ( .A(Midori_rounds_SR_Result2[3]), .B(
        Midori_rounds_n1011), .Z(Midori_rounds_n916) );
  MUX2_X1 Midori_rounds_U144 ( .A(key[95]), .B(key[31]), .S(round_Signal[0]), 
        .Z(Midori_rounds_n1011) );
  MUX2_X1 Midori_rounds_U143 ( .A(Midori_rounds_SR_Result2[30]), .B(
        Midori_rounds_n915), .S(enc_dec), .Z(Midori_rounds_mul_input2[30]) );
  XOR2_X1 Midori_rounds_U142 ( .A(Midori_rounds_SR_Result2[2]), .B(
        Midori_rounds_n1009), .Z(Midori_rounds_n915) );
  MUX2_X1 Midori_rounds_U141 ( .A(key[94]), .B(key[30]), .S(round_Signal[0]), 
        .Z(Midori_rounds_n1009) );
  MUX2_X1 Midori_rounds_U140 ( .A(Midori_rounds_SR_Result2[29]), .B(
        Midori_rounds_n914), .S(enc_dec), .Z(Midori_rounds_mul_input2[29]) );
  XOR2_X1 Midori_rounds_U139 ( .A(Midori_rounds_SR_Result2[1]), .B(
        Midori_rounds_n1007), .Z(Midori_rounds_n914) );
  MUX2_X1 Midori_rounds_U138 ( .A(key[93]), .B(key[29]), .S(Midori_rounds_n962), .Z(Midori_rounds_n1007) );
  MUX2_X1 Midori_rounds_U137 ( .A(Midori_rounds_SR_Result2[27]), .B(
        Midori_rounds_n913), .S(enc_dec), .Z(Midori_rounds_mul_input2[27]) );
  XOR2_X1 Midori_rounds_U136 ( .A(Midori_rounds_SR_Result2[31]), .B(
        Midori_rounds_n1005), .Z(Midori_rounds_n913) );
  MUX2_X1 Midori_rounds_U135 ( .A(key[91]), .B(key[27]), .S(
        Midori_rounds_n1093), .Z(Midori_rounds_n1005) );
  MUX2_X1 Midori_rounds_U134 ( .A(Midori_rounds_SR_Result2[25]), .B(
        Midori_rounds_n912), .S(enc_dec), .Z(Midori_rounds_mul_input2[25]) );
  XOR2_X1 Midori_rounds_U133 ( .A(Midori_rounds_SR_Result2[29]), .B(
        Midori_rounds_n1001), .Z(Midori_rounds_n912) );
  MUX2_X1 Midori_rounds_U132 ( .A(key[89]), .B(key[25]), .S(Midori_rounds_n962), .Z(Midori_rounds_n1001) );
  MUX2_X1 Midori_rounds_U131 ( .A(Midori_rounds_SR_Result2[11]), .B(
        Midori_rounds_n911), .S(enc_dec), .Z(Midori_rounds_mul_input2[11]) );
  XOR2_X1 Midori_rounds_U130 ( .A(Midori_rounds_SR_Result2[11]), .B(
        Midori_rounds_n981), .Z(Midori_rounds_n911) );
  MUX2_X1 Midori_rounds_U129 ( .A(key[75]), .B(key[11]), .S(Midori_rounds_n962), .Z(Midori_rounds_n981) );
  MUX2_X1 Midori_rounds_U128 ( .A(Midori_rounds_SR_Result2[10]), .B(
        Midori_rounds_n910), .S(enc_dec), .Z(Midori_rounds_mul_input2[10]) );
  XOR2_X1 Midori_rounds_U127 ( .A(Midori_rounds_SR_Result2[10]), .B(
        Midori_rounds_n979), .Z(Midori_rounds_n910) );
  MUX2_X1 Midori_rounds_U126 ( .A(key[74]), .B(key[10]), .S(
        Midori_rounds_n1093), .Z(Midori_rounds_n979) );
  MUX2_X1 Midori_rounds_U125 ( .A(Midori_rounds_SR_Result2[9]), .B(
        Midori_rounds_n909), .S(enc_dec), .Z(Midori_rounds_mul_input2[9]) );
  XOR2_X1 Midori_rounds_U124 ( .A(Midori_rounds_SR_Result2[9]), .B(
        Midori_rounds_n977), .Z(Midori_rounds_n909) );
  MUX2_X1 Midori_rounds_U123 ( .A(key[73]), .B(key[9]), .S(round_Signal[0]), 
        .Z(Midori_rounds_n977) );
  MUX2_X1 Midori_rounds_U122 ( .A(Midori_rounds_SR_Result2[15]), .B(
        Midori_rounds_n908), .S(enc_dec), .Z(Midori_rounds_mul_input2[15]) );
  XOR2_X1 Midori_rounds_U121 ( .A(Midori_rounds_SR_Result2[23]), .B(
        Midori_rounds_n987), .Z(Midori_rounds_n908) );
  MUX2_X1 Midori_rounds_U120 ( .A(key[79]), .B(key[15]), .S(round_Signal[0]), 
        .Z(Midori_rounds_n987) );
  MUX2_X1 Midori_rounds_U119 ( .A(Midori_rounds_SR_Result2[14]), .B(
        Midori_rounds_n907), .S(enc_dec), .Z(Midori_rounds_mul_input2[14]) );
  XOR2_X1 Midori_rounds_U118 ( .A(Midori_rounds_SR_Result2[22]), .B(
        Midori_rounds_n985), .Z(Midori_rounds_n907) );
  MUX2_X1 Midori_rounds_U117 ( .A(key[78]), .B(key[14]), .S(round_Signal[0]), 
        .Z(Midori_rounds_n985) );
  MUX2_X1 Midori_rounds_U116 ( .A(Midori_rounds_SR_Result2[13]), .B(
        Midori_rounds_n906), .S(enc_dec), .Z(Midori_rounds_mul_input2[13]) );
  XOR2_X1 Midori_rounds_U115 ( .A(Midori_rounds_SR_Result2[21]), .B(
        Midori_rounds_n983), .Z(Midori_rounds_n906) );
  MUX2_X1 Midori_rounds_U114 ( .A(key[77]), .B(key[13]), .S(round_Signal[0]), 
        .Z(Midori_rounds_n983) );
  MUX2_X1 Midori_rounds_U113 ( .A(Midori_rounds_SR_Result2[24]), .B(
        Midori_rounds_n905), .S(enc_dec), .Z(Midori_rounds_mul_input2[24]) );
  XNOR2_X1 Midori_rounds_U112 ( .A(Midori_rounds_SR_Result2[28]), .B(
        Midori_rounds_n1073), .ZN(Midori_rounds_n905) );
  XNOR2_X1 Midori_rounds_U111 ( .A(Midori_rounds_round_Constant[6]), .B(
        Midori_rounds_n904), .ZN(Midori_rounds_n1073) );
  MUX2_X1 Midori_rounds_U110 ( .A(key[88]), .B(key[24]), .S(Midori_rounds_n962), .Z(Midori_rounds_n904) );
  MUX2_X1 Midori_rounds_U109 ( .A(Midori_rounds_SR_Result2[52]), .B(
        Midori_rounds_n903), .S(enc_dec), .Z(Midori_rounds_mul_input2[52]) );
  XNOR2_X1 Midori_rounds_U108 ( .A(Midori_rounds_SR_Result2[4]), .B(
        Midori_rounds_n1087), .ZN(Midori_rounds_n903) );
  XNOR2_X1 Midori_rounds_U107 ( .A(Midori_rounds_round_Constant[13]), .B(
        Midori_rounds_n902), .ZN(Midori_rounds_n1087) );
  MUX2_X1 Midori_rounds_U106 ( .A(key[116]), .B(key[52]), .S(
        Midori_rounds_n962), .Z(Midori_rounds_n902) );
  MUX2_X1 Midori_rounds_U105 ( .A(Midori_rounds_SR_Result2[60]), .B(
        Midori_rounds_n901), .S(enc_dec), .Z(Midori_rounds_mul_input2[60]) );
  XNOR2_X1 Midori_rounds_U104 ( .A(Midori_rounds_SR_Result2[60]), .B(
        Midori_rounds_n1091), .ZN(Midori_rounds_n901) );
  XNOR2_X1 Midori_rounds_U103 ( .A(Midori_rounds_round_Constant[15]), .B(
        Midori_rounds_n900), .ZN(Midori_rounds_n1091) );
  MUX2_X1 Midori_rounds_U102 ( .A(key[124]), .B(key[60]), .S(
        Midori_rounds_n962), .Z(Midori_rounds_n900) );
  MUX2_X1 Midori_rounds_U101 ( .A(Midori_rounds_SR_Result2[56]), .B(
        Midori_rounds_n899), .S(enc_dec), .Z(Midori_rounds_mul_input2[56]) );
  XNOR2_X1 Midori_rounds_U100 ( .A(Midori_rounds_SR_Result2[32]), .B(
        Midori_rounds_n1089), .ZN(Midori_rounds_n899) );
  XNOR2_X1 Midori_rounds_U99 ( .A(Midori_rounds_round_Constant[14]), .B(
        Midori_rounds_n898), .ZN(Midori_rounds_n1089) );
  MUX2_X1 Midori_rounds_U98 ( .A(key[120]), .B(key[56]), .S(Midori_rounds_n962), .Z(Midori_rounds_n898) );
  MUX2_X1 Midori_rounds_U97 ( .A(Midori_rounds_SR_Result2[44]), .B(
        Midori_rounds_n897), .S(enc_dec), .Z(Midori_rounds_mul_input2[44]) );
  XNOR2_X1 Midori_rounds_U96 ( .A(Midori_rounds_SR_Result2[40]), .B(
        Midori_rounds_n1083), .ZN(Midori_rounds_n897) );
  XNOR2_X1 Midori_rounds_U95 ( .A(Midori_rounds_round_Constant[11]), .B(
        Midori_rounds_n896), .ZN(Midori_rounds_n1083) );
  MUX2_X1 Midori_rounds_U94 ( .A(key[108]), .B(key[44]), .S(Midori_rounds_n962), .Z(Midori_rounds_n896) );
  MUX2_X1 Midori_rounds_U93 ( .A(Midori_rounds_SR_Result2[12]), .B(
        Midori_rounds_n895), .S(enc_dec), .Z(Midori_rounds_mul_input2[12]) );
  XNOR2_X1 Midori_rounds_U92 ( .A(Midori_rounds_SR_Result2[20]), .B(
        Midori_rounds_n1067), .ZN(Midori_rounds_n895) );
  XNOR2_X1 Midori_rounds_U91 ( .A(Midori_rounds_round_Constant[3]), .B(
        Midori_rounds_n894), .ZN(Midori_rounds_n1067) );
  MUX2_X1 Midori_rounds_U90 ( .A(key[76]), .B(key[12]), .S(Midori_rounds_n962), 
        .Z(Midori_rounds_n894) );
  MUX2_X1 Midori_rounds_U89 ( .A(Midori_rounds_SR_Result2[40]), .B(
        Midori_rounds_n893), .S(enc_dec), .Z(Midori_rounds_mul_input2[40]) );
  XNOR2_X1 Midori_rounds_U88 ( .A(Midori_rounds_SR_Result2[52]), .B(
        Midori_rounds_n1081), .ZN(Midori_rounds_n893) );
  XNOR2_X1 Midori_rounds_U87 ( .A(Midori_rounds_round_Constant[10]), .B(
        Midori_rounds_n892), .ZN(Midori_rounds_n1081) );
  MUX2_X1 Midori_rounds_U86 ( .A(key[104]), .B(key[40]), .S(Midori_rounds_n962), .Z(Midori_rounds_n892) );
  MUX2_X1 Midori_rounds_U85 ( .A(Midori_rounds_SR_Result2[36]), .B(
        Midori_rounds_n890), .S(enc_dec), .Z(Midori_rounds_mul_input2[36]) );
  XNOR2_X1 Midori_rounds_U84 ( .A(Midori_rounds_SR_Result2[16]), .B(
        Midori_rounds_n1079), .ZN(Midori_rounds_n890) );
  XNOR2_X1 Midori_rounds_U83 ( .A(Midori_rounds_round_Constant[9]), .B(
        Midori_rounds_n889), .ZN(Midori_rounds_n1079) );
  MUX2_X1 Midori_rounds_U82 ( .A(key[100]), .B(key[36]), .S(
        Midori_rounds_n1093), .Z(Midori_rounds_n889) );
  MUX2_X1 Midori_rounds_U81 ( .A(Midori_rounds_SR_Result2[8]), .B(
        Midori_rounds_n888), .S(enc_dec), .Z(Midori_rounds_mul_input2[8]) );
  XNOR2_X1 Midori_rounds_U80 ( .A(Midori_rounds_SR_Result2[8]), .B(
        Midori_rounds_n1065), .ZN(Midori_rounds_n888) );
  XNOR2_X1 Midori_rounds_U79 ( .A(Midori_rounds_round_Constant[2]), .B(
        Midori_rounds_n887), .ZN(Midori_rounds_n1065) );
  MUX2_X1 Midori_rounds_U78 ( .A(key[72]), .B(key[8]), .S(Midori_rounds_n1093), 
        .Z(Midori_rounds_n887) );
  MUX2_X1 Midori_rounds_U77 ( .A(Midori_rounds_SR_Result2[16]), .B(
        Midori_rounds_n886), .S(enc_dec), .Z(Midori_rounds_mul_input2[16]) );
  XNOR2_X1 Midori_rounds_U76 ( .A(Midori_rounds_SR_Result2[36]), .B(
        Midori_rounds_n1069), .ZN(Midori_rounds_n886) );
  XNOR2_X1 Midori_rounds_U75 ( .A(Midori_rounds_round_Constant[4]), .B(
        Midori_rounds_n885), .ZN(Midori_rounds_n1069) );
  MUX2_X1 Midori_rounds_U74 ( .A(key[80]), .B(key[16]), .S(Midori_rounds_n1093), .Z(Midori_rounds_n885) );
  MUX2_X1 Midori_rounds_U73 ( .A(Midori_rounds_SR_Result2[28]), .B(
        Midori_rounds_n884), .S(enc_dec), .Z(Midori_rounds_mul_input2[28]) );
  XNOR2_X1 Midori_rounds_U72 ( .A(Midori_rounds_SR_Result2[0]), .B(
        Midori_rounds_n1075), .ZN(Midori_rounds_n884) );
  XNOR2_X1 Midori_rounds_U71 ( .A(Midori_rounds_round_Constant[7]), .B(
        Midori_rounds_n883), .ZN(Midori_rounds_n1075) );
  MUX2_X1 Midori_rounds_U70 ( .A(key[92]), .B(key[28]), .S(Midori_rounds_n1093), .Z(Midori_rounds_n883) );
  MUX2_X1 Midori_rounds_U69 ( .A(Midori_rounds_SR_Inv_Result1[63]), .B(
        Midori_rounds_SR_Inv_Result1[63]), .S(enc_dec), .Z(
        Midori_rounds_round_Result1[63]) );
  MUX2_X1 Midori_rounds_U68 ( .A(Midori_rounds_SR_Inv_Result1[62]), .B(
        Midori_rounds_SR_Inv_Result1[62]), .S(enc_dec), .Z(
        Midori_rounds_round_Result1[62]) );
  MUX2_X1 Midori_rounds_U67 ( .A(Midori_rounds_SR_Inv_Result1[61]), .B(
        Midori_rounds_SR_Inv_Result1[61]), .S(enc_dec), .Z(
        Midori_rounds_round_Result1[61]) );
  MUX2_X1 Midori_rounds_U66 ( .A(Midori_rounds_SR_Inv_Result1[60]), .B(
        Midori_rounds_SR_Inv_Result1[60]), .S(enc_dec), .Z(
        Midori_rounds_round_Result1[60]) );
  MUX2_X1 Midori_rounds_U65 ( .A(Midori_rounds_SR_Inv_Result1[9]), .B(
        Midori_rounds_SR_Inv_Result1[9]), .S(enc_dec), .Z(
        Midori_rounds_round_Result1[9]) );
  MUX2_X1 Midori_rounds_U64 ( .A(Midori_rounds_SR_Inv_Result1[8]), .B(
        Midori_rounds_SR_Inv_Result1[8]), .S(enc_dec), .Z(
        Midori_rounds_round_Result1[8]) );
  MUX2_X1 Midori_rounds_U63 ( .A(Midori_rounds_SR_Inv_Result1[11]), .B(
        Midori_rounds_SR_Inv_Result1[11]), .S(enc_dec), .Z(
        Midori_rounds_round_Result1[11]) );
  MUX2_X1 Midori_rounds_U62 ( .A(Midori_rounds_SR_Inv_Result1[10]), .B(
        Midori_rounds_SR_Inv_Result1[10]), .S(enc_dec), .Z(
        Midori_rounds_round_Result1[10]) );
  MUX2_X1 Midori_rounds_U61 ( .A(Midori_rounds_SR_Inv_Result1[28]), .B(
        Midori_rounds_SR_Inv_Result1[0]), .S(enc_dec), .Z(
        Midori_rounds_round_Result1[0]) );
  MUX2_X1 Midori_rounds_U60 ( .A(Midori_rounds_SR_Inv_Result1[23]), .B(
        Midori_rounds_SR_Inv_Result1[59]), .S(enc_dec), .Z(
        Midori_rounds_round_Result1[59]) );
  MUX2_X1 Midori_rounds_U59 ( .A(Midori_rounds_SR_Inv_Result1[22]), .B(
        Midori_rounds_SR_Inv_Result1[58]), .S(enc_dec), .Z(
        Midori_rounds_round_Result1[58]) );
  MUX2_X1 Midori_rounds_U58 ( .A(Midori_rounds_SR_Inv_Result1[21]), .B(
        Midori_rounds_SR_Inv_Result1[57]), .S(enc_dec), .Z(
        Midori_rounds_round_Result1[57]) );
  MUX2_X1 Midori_rounds_U57 ( .A(Midori_rounds_SR_Inv_Result1[20]), .B(
        Midori_rounds_SR_Inv_Result1[56]), .S(enc_dec), .Z(
        Midori_rounds_round_Result1[56]) );
  MUX2_X1 Midori_rounds_U56 ( .A(Midori_rounds_SR_Inv_Result1[43]), .B(
        Midori_rounds_SR_Inv_Result1[55]), .S(enc_dec), .Z(
        Midori_rounds_round_Result1[55]) );
  MUX2_X1 Midori_rounds_U55 ( .A(Midori_rounds_SR_Inv_Result1[42]), .B(
        Midori_rounds_SR_Inv_Result1[54]), .S(enc_dec), .Z(
        Midori_rounds_round_Result1[54]) );
  MUX2_X1 Midori_rounds_U54 ( .A(Midori_rounds_SR_Inv_Result1[41]), .B(
        Midori_rounds_SR_Inv_Result1[53]), .S(enc_dec), .Z(
        Midori_rounds_round_Result1[53]) );
  MUX2_X1 Midori_rounds_U53 ( .A(Midori_rounds_SR_Inv_Result1[40]), .B(
        Midori_rounds_SR_Inv_Result1[52]), .S(enc_dec), .Z(
        Midori_rounds_round_Result1[52]) );
  MUX2_X1 Midori_rounds_U52 ( .A(Midori_rounds_SR_Inv_Result1[3]), .B(
        Midori_rounds_SR_Inv_Result1[51]), .S(enc_dec), .Z(
        Midori_rounds_round_Result1[51]) );
  MUX2_X1 Midori_rounds_U51 ( .A(Midori_rounds_SR_Inv_Result1[2]), .B(
        Midori_rounds_SR_Inv_Result1[50]), .S(enc_dec), .Z(
        Midori_rounds_round_Result1[50]) );
  MUX2_X1 Midori_rounds_U50 ( .A(Midori_rounds_SR_Inv_Result1[1]), .B(
        Midori_rounds_SR_Inv_Result1[49]), .S(enc_dec), .Z(
        Midori_rounds_round_Result1[49]) );
  MUX2_X1 Midori_rounds_U49 ( .A(Midori_rounds_SR_Inv_Result1[0]), .B(
        Midori_rounds_SR_Inv_Result1[48]), .S(enc_dec), .Z(
        Midori_rounds_round_Result1[48]) );
  MUX2_X1 Midori_rounds_U48 ( .A(Midori_rounds_SR_Inv_Result1[7]), .B(
        Midori_rounds_SR_Inv_Result1[47]), .S(enc_dec), .Z(
        Midori_rounds_round_Result1[47]) );
  MUX2_X1 Midori_rounds_U47 ( .A(Midori_rounds_SR_Inv_Result1[6]), .B(
        Midori_rounds_SR_Inv_Result1[46]), .S(enc_dec), .Z(
        Midori_rounds_round_Result1[46]) );
  MUX2_X1 Midori_rounds_U46 ( .A(Midori_rounds_SR_Inv_Result1[5]), .B(
        Midori_rounds_SR_Inv_Result1[45]), .S(enc_dec), .Z(
        Midori_rounds_round_Result1[45]) );
  MUX2_X1 Midori_rounds_U45 ( .A(Midori_rounds_SR_Inv_Result1[4]), .B(
        Midori_rounds_SR_Inv_Result1[44]), .S(enc_dec), .Z(
        Midori_rounds_round_Result1[44]) );
  MUX2_X1 Midori_rounds_U44 ( .A(Midori_rounds_SR_Inv_Result1[47]), .B(
        Midori_rounds_SR_Inv_Result1[43]), .S(enc_dec), .Z(
        Midori_rounds_round_Result1[43]) );
  MUX2_X1 Midori_rounds_U43 ( .A(Midori_rounds_SR_Inv_Result1[46]), .B(
        Midori_rounds_SR_Inv_Result1[42]), .S(enc_dec), .Z(
        Midori_rounds_round_Result1[42]) );
  MUX2_X1 Midori_rounds_U42 ( .A(Midori_rounds_SR_Inv_Result1[45]), .B(
        Midori_rounds_SR_Inv_Result1[41]), .S(enc_dec), .Z(
        Midori_rounds_round_Result1[41]) );
  MUX2_X1 Midori_rounds_U41 ( .A(Midori_rounds_SR_Inv_Result1[44]), .B(
        Midori_rounds_SR_Inv_Result1[40]), .S(enc_dec), .Z(
        Midori_rounds_round_Result1[40]) );
  MUX2_X1 Midori_rounds_U40 ( .A(Midori_rounds_SR_Inv_Result1[19]), .B(
        Midori_rounds_SR_Inv_Result1[39]), .S(enc_dec), .Z(
        Midori_rounds_round_Result1[39]) );
  MUX2_X1 Midori_rounds_U39 ( .A(Midori_rounds_SR_Inv_Result1[18]), .B(
        Midori_rounds_SR_Inv_Result1[38]), .S(enc_dec), .Z(
        Midori_rounds_round_Result1[38]) );
  MUX2_X1 Midori_rounds_U38 ( .A(Midori_rounds_SR_Inv_Result1[17]), .B(
        Midori_rounds_SR_Inv_Result1[37]), .S(enc_dec), .Z(
        Midori_rounds_round_Result1[37]) );
  MUX2_X1 Midori_rounds_U37 ( .A(Midori_rounds_SR_Inv_Result1[16]), .B(
        Midori_rounds_SR_Inv_Result1[36]), .S(enc_dec), .Z(
        Midori_rounds_round_Result1[36]) );
  MUX2_X1 Midori_rounds_U36 ( .A(Midori_rounds_SR_Inv_Result1[59]), .B(
        Midori_rounds_SR_Inv_Result1[35]), .S(enc_dec), .Z(
        Midori_rounds_round_Result1[35]) );
  MUX2_X1 Midori_rounds_U35 ( .A(Midori_rounds_SR_Inv_Result1[58]), .B(
        Midori_rounds_SR_Inv_Result1[34]), .S(enc_dec), .Z(
        Midori_rounds_round_Result1[34]) );
  MUX2_X1 Midori_rounds_U34 ( .A(Midori_rounds_SR_Inv_Result1[57]), .B(
        Midori_rounds_SR_Inv_Result1[33]), .S(enc_dec), .Z(
        Midori_rounds_round_Result1[33]) );
  MUX2_X1 Midori_rounds_U33 ( .A(Midori_rounds_SR_Inv_Result1[56]), .B(
        Midori_rounds_SR_Inv_Result1[32]), .S(enc_dec), .Z(
        Midori_rounds_round_Result1[32]) );
  MUX2_X1 Midori_rounds_U32 ( .A(Midori_rounds_SR_Inv_Result1[27]), .B(
        Midori_rounds_SR_Inv_Result1[31]), .S(enc_dec), .Z(
        Midori_rounds_round_Result1[31]) );
  MUX2_X1 Midori_rounds_U31 ( .A(Midori_rounds_SR_Inv_Result1[26]), .B(
        Midori_rounds_SR_Inv_Result1[30]), .S(enc_dec), .Z(
        Midori_rounds_round_Result1[30]) );
  MUX2_X1 Midori_rounds_U30 ( .A(Midori_rounds_SR_Inv_Result1[25]), .B(
        Midori_rounds_SR_Inv_Result1[29]), .S(enc_dec), .Z(
        Midori_rounds_round_Result1[29]) );
  MUX2_X1 Midori_rounds_U29 ( .A(Midori_rounds_SR_Inv_Result1[24]), .B(
        Midori_rounds_SR_Inv_Result1[28]), .S(enc_dec), .Z(
        Midori_rounds_round_Result1[28]) );
  MUX2_X1 Midori_rounds_U28 ( .A(Midori_rounds_SR_Inv_Result1[51]), .B(
        Midori_rounds_SR_Inv_Result1[27]), .S(enc_dec), .Z(
        Midori_rounds_round_Result1[27]) );
  MUX2_X1 Midori_rounds_U27 ( .A(Midori_rounds_SR_Inv_Result1[50]), .B(
        Midori_rounds_SR_Inv_Result1[26]), .S(enc_dec), .Z(
        Midori_rounds_round_Result1[26]) );
  MUX2_X1 Midori_rounds_U26 ( .A(Midori_rounds_SR_Inv_Result1[49]), .B(
        Midori_rounds_SR_Inv_Result1[25]), .S(enc_dec), .Z(
        Midori_rounds_round_Result1[25]) );
  MUX2_X1 Midori_rounds_U25 ( .A(Midori_rounds_SR_Inv_Result1[48]), .B(
        Midori_rounds_SR_Inv_Result1[24]), .S(enc_dec), .Z(
        Midori_rounds_round_Result1[24]) );
  MUX2_X1 Midori_rounds_U24 ( .A(Midori_rounds_SR_Inv_Result1[15]), .B(
        Midori_rounds_SR_Inv_Result1[23]), .S(enc_dec), .Z(
        Midori_rounds_round_Result1[23]) );
  MUX2_X1 Midori_rounds_U23 ( .A(Midori_rounds_SR_Inv_Result1[14]), .B(
        Midori_rounds_SR_Inv_Result1[22]), .S(enc_dec), .Z(
        Midori_rounds_round_Result1[22]) );
  MUX2_X1 Midori_rounds_U22 ( .A(Midori_rounds_SR_Inv_Result1[13]), .B(
        Midori_rounds_SR_Inv_Result1[21]), .S(enc_dec), .Z(
        Midori_rounds_round_Result1[21]) );
  MUX2_X1 Midori_rounds_U21 ( .A(Midori_rounds_SR_Inv_Result1[12]), .B(
        Midori_rounds_SR_Inv_Result1[20]), .S(enc_dec), .Z(
        Midori_rounds_round_Result1[20]) );
  MUX2_X1 Midori_rounds_U20 ( .A(Midori_rounds_SR_Inv_Result1[39]), .B(
        Midori_rounds_SR_Inv_Result1[19]), .S(enc_dec), .Z(
        Midori_rounds_round_Result1[19]) );
  MUX2_X1 Midori_rounds_U19 ( .A(Midori_rounds_SR_Inv_Result1[38]), .B(
        Midori_rounds_SR_Inv_Result1[18]), .S(enc_dec), .Z(
        Midori_rounds_round_Result1[18]) );
  MUX2_X1 Midori_rounds_U18 ( .A(Midori_rounds_SR_Inv_Result1[37]), .B(
        Midori_rounds_SR_Inv_Result1[17]), .S(enc_dec), .Z(
        Midori_rounds_round_Result1[17]) );
  MUX2_X1 Midori_rounds_U17 ( .A(Midori_rounds_SR_Inv_Result1[36]), .B(
        Midori_rounds_SR_Inv_Result1[16]), .S(enc_dec), .Z(
        Midori_rounds_round_Result1[16]) );
  MUX2_X1 Midori_rounds_U16 ( .A(Midori_rounds_SR_Inv_Result1[55]), .B(
        Midori_rounds_SR_Inv_Result1[7]), .S(enc_dec), .Z(
        Midori_rounds_round_Result1[7]) );
  MUX2_X1 Midori_rounds_U15 ( .A(Midori_rounds_SR_Inv_Result1[54]), .B(
        Midori_rounds_SR_Inv_Result1[6]), .S(enc_dec), .Z(
        Midori_rounds_round_Result1[6]) );
  MUX2_X1 Midori_rounds_U14 ( .A(Midori_rounds_SR_Inv_Result1[53]), .B(
        Midori_rounds_SR_Inv_Result1[5]), .S(enc_dec), .Z(
        Midori_rounds_round_Result1[5]) );
  MUX2_X1 Midori_rounds_U13 ( .A(Midori_rounds_SR_Inv_Result1[52]), .B(
        Midori_rounds_SR_Inv_Result1[4]), .S(enc_dec), .Z(
        Midori_rounds_round_Result1[4]) );
  MUX2_X1 Midori_rounds_U12 ( .A(Midori_rounds_SR_Inv_Result1[31]), .B(
        Midori_rounds_SR_Inv_Result1[3]), .S(enc_dec), .Z(
        Midori_rounds_round_Result1[3]) );
  MUX2_X1 Midori_rounds_U11 ( .A(Midori_rounds_SR_Inv_Result1[30]), .B(
        Midori_rounds_SR_Inv_Result1[2]), .S(enc_dec), .Z(
        Midori_rounds_round_Result1[2]) );
  MUX2_X1 Midori_rounds_U10 ( .A(Midori_rounds_SR_Inv_Result1[29]), .B(
        Midori_rounds_SR_Inv_Result1[1]), .S(enc_dec), .Z(
        Midori_rounds_round_Result1[1]) );
  MUX2_X1 Midori_rounds_U9 ( .A(Midori_rounds_SR_Inv_Result1[35]), .B(
        Midori_rounds_SR_Inv_Result1[15]), .S(enc_dec), .Z(
        Midori_rounds_round_Result1[15]) );
  MUX2_X1 Midori_rounds_U8 ( .A(Midori_rounds_SR_Inv_Result1[34]), .B(
        Midori_rounds_SR_Inv_Result1[14]), .S(enc_dec), .Z(
        Midori_rounds_round_Result1[14]) );
  MUX2_X1 Midori_rounds_U7 ( .A(Midori_rounds_SR_Inv_Result1[33]), .B(
        Midori_rounds_SR_Inv_Result1[13]), .S(enc_dec), .Z(
        Midori_rounds_round_Result1[13]) );
  MUX2_X1 Midori_rounds_U6 ( .A(Midori_rounds_SR_Inv_Result1[32]), .B(
        Midori_rounds_SR_Inv_Result1[12]), .S(enc_dec), .Z(
        Midori_rounds_round_Result1[12]) );
  INV_X1 Midori_rounds_U5 ( .A(Midori_rounds_n891), .ZN(Midori_rounds_n1093)
         );
  INV_X1 Midori_rounds_U4 ( .A(round_Signal[0]), .ZN(Midori_rounds_n891) );
  INV_X2 Midori_rounds_U3 ( .A(Midori_rounds_n891), .ZN(Midori_rounds_n962) );
  NAND2_X1 Midori_rounds_constant_MUX_U131 ( .A1(
        Midori_rounds_constant_MUX_n130), .A2(Midori_rounds_constant_MUX_n129), 
        .ZN(Midori_rounds_round_Constant[11]) );
  NAND2_X1 Midori_rounds_constant_MUX_U130 ( .A1(
        Midori_rounds_constant_MUX_n128), .A2(Midori_rounds_constant_MUX_n127), 
        .ZN(Midori_rounds_constant_MUX_n129) );
  NAND2_X1 Midori_rounds_constant_MUX_U129 ( .A1(
        Midori_rounds_constant_MUX_n126), .A2(Midori_rounds_constant_MUX_n125), 
        .ZN(Midori_rounds_constant_MUX_n128) );
  NOR2_X1 Midori_rounds_constant_MUX_U128 ( .A1(
        Midori_rounds_constant_MUX_n124), .A2(Midori_rounds_constant_MUX_n123), 
        .ZN(Midori_rounds_constant_MUX_n125) );
  NAND2_X1 Midori_rounds_constant_MUX_U127 ( .A1(
        Midori_rounds_constant_MUX_n122), .A2(Midori_rounds_constant_MUX_n121), 
        .ZN(Midori_rounds_constant_MUX_n126) );
  NOR2_X1 Midori_rounds_constant_MUX_U126 ( .A1(
        Midori_rounds_constant_MUX_n120), .A2(Midori_rounds_constant_MUX_n119), 
        .ZN(Midori_rounds_constant_MUX_n122) );
  NAND2_X1 Midori_rounds_constant_MUX_U125 ( .A1(
        Midori_rounds_constant_MUX_n118), .A2(Midori_rounds_constant_MUX_n117), 
        .ZN(Midori_rounds_round_Constant[10]) );
  NOR2_X1 Midori_rounds_constant_MUX_U124 ( .A1(
        Midori_rounds_constant_MUX_n116), .A2(Midori_rounds_constant_MUX_n115), 
        .ZN(Midori_rounds_constant_MUX_n117) );
  NOR2_X1 Midori_rounds_constant_MUX_U123 ( .A1(
        Midori_rounds_constant_MUX_n114), .A2(Midori_rounds_constant_MUX_n113), 
        .ZN(Midori_rounds_constant_MUX_n118) );
  NOR2_X1 Midori_rounds_constant_MUX_U122 ( .A1(
        Midori_rounds_constant_MUX_n112), .A2(Midori_rounds_constant_MUX_n111), 
        .ZN(Midori_rounds_constant_MUX_n113) );
  NAND2_X1 Midori_rounds_constant_MUX_U121 ( .A1(
        Midori_rounds_constant_MUX_n121), .A2(Midori_rounds_constant_MUX_n127), 
        .ZN(Midori_rounds_constant_MUX_n111) );
  NOR2_X1 Midori_rounds_constant_MUX_U120 ( .A1(
        Midori_rounds_constant_MUX_n120), .A2(Midori_rounds_constant_MUX_n110), 
        .ZN(Midori_rounds_constant_MUX_n112) );
  NOR2_X1 Midori_rounds_constant_MUX_U119 ( .A1(Midori_rounds_n1093), .A2(
        Midori_rounds_constant_MUX_n119), .ZN(Midori_rounds_constant_MUX_n110)
         );
  NAND2_X1 Midori_rounds_constant_MUX_U118 ( .A1(
        Midori_rounds_constant_MUX_n109), .A2(Midori_rounds_constant_MUX_n108), 
        .ZN(Midori_rounds_constant_MUX_n119) );
  NAND2_X1 Midori_rounds_constant_MUX_U117 ( .A1(
        Midori_rounds_constant_MUX_n107), .A2(Midori_rounds_constant_MUX_n106), 
        .ZN(Midori_rounds_round_Constant[6]) );
  NOR2_X1 Midori_rounds_constant_MUX_U116 ( .A1(
        Midori_rounds_constant_MUX_n105), .A2(Midori_rounds_constant_MUX_n104), 
        .ZN(Midori_rounds_constant_MUX_n106) );
  NAND2_X1 Midori_rounds_constant_MUX_U115 ( .A1(
        Midori_rounds_constant_MUX_n103), .A2(Midori_rounds_constant_MUX_n102), 
        .ZN(Midori_rounds_constant_MUX_n104) );
  NAND2_X1 Midori_rounds_constant_MUX_U114 ( .A1(
        Midori_rounds_constant_MUX_n107), .A2(Midori_rounds_constant_MUX_n101), 
        .ZN(Midori_rounds_round_Constant[15]) );
  NOR2_X1 Midori_rounds_constant_MUX_U113 ( .A1(
        Midori_rounds_constant_MUX_n100), .A2(Midori_rounds_constant_MUX_n99), 
        .ZN(Midori_rounds_constant_MUX_n101) );
  NAND2_X1 Midori_rounds_constant_MUX_U112 ( .A1(
        Midori_rounds_constant_MUX_n98), .A2(Midori_rounds_constant_MUX_n97), 
        .ZN(Midori_rounds_constant_MUX_n99) );
  NAND2_X1 Midori_rounds_constant_MUX_U111 ( .A1(
        Midori_rounds_constant_MUX_n96), .A2(Midori_rounds_constant_MUX_n95), 
        .ZN(Midori_rounds_round_Constant[5]) );
  NOR2_X1 Midori_rounds_constant_MUX_U110 ( .A1(Midori_rounds_constant_MUX_n94), .A2(Midori_rounds_constant_MUX_n93), .ZN(Midori_rounds_constant_MUX_n95) );
  NAND2_X1 Midori_rounds_constant_MUX_U109 ( .A1(
        Midori_rounds_constant_MUX_n92), .A2(Midori_rounds_constant_MUX_n91), 
        .ZN(Midori_rounds_round_Constant[9]) );
  NOR2_X1 Midori_rounds_constant_MUX_U108 ( .A1(
        Midori_rounds_constant_MUX_n100), .A2(Midori_rounds_constant_MUX_n90), 
        .ZN(Midori_rounds_constant_MUX_n91) );
  NAND2_X1 Midori_rounds_constant_MUX_U107 ( .A1(
        Midori_rounds_constant_MUX_n89), .A2(Midori_rounds_constant_MUX_n96), 
        .ZN(Midori_rounds_constant_MUX_n90) );
  NAND2_X1 Midori_rounds_constant_MUX_U106 ( .A1(
        Midori_rounds_constant_MUX_n88), .A2(Midori_rounds_constant_MUX_n87), 
        .ZN(Midori_rounds_round_Constant[13]) );
  NOR2_X1 Midori_rounds_constant_MUX_U105 ( .A1(Midori_rounds_constant_MUX_n86), .A2(Midori_rounds_constant_MUX_n85), .ZN(Midori_rounds_constant_MUX_n87) );
  NAND2_X1 Midori_rounds_constant_MUX_U104 ( .A1(
        Midori_rounds_constant_MUX_n84), .A2(Midori_rounds_constant_MUX_n83), 
        .ZN(Midori_rounds_round_Constant[3]) );
  NOR2_X1 Midori_rounds_constant_MUX_U103 ( .A1(Midori_rounds_constant_MUX_n82), .A2(Midori_rounds_constant_MUX_n81), .ZN(Midori_rounds_constant_MUX_n83) );
  NAND2_X1 Midori_rounds_constant_MUX_U102 ( .A1(
        Midori_rounds_constant_MUX_n98), .A2(Midori_rounds_constant_MUX_n80), 
        .ZN(Midori_rounds_round_Constant[1]) );
  NOR2_X1 Midori_rounds_constant_MUX_U101 ( .A1(Midori_rounds_constant_MUX_n86), .A2(Midori_rounds_constant_MUX_n79), .ZN(Midori_rounds_constant_MUX_n80) );
  NAND2_X1 Midori_rounds_constant_MUX_U100 ( .A1(
        Midori_rounds_constant_MUX_n96), .A2(Midori_rounds_constant_MUX_n78), 
        .ZN(Midori_rounds_constant_MUX_n79) );
  INV_X1 Midori_rounds_constant_MUX_U99 ( .A(Midori_rounds_constant_MUX_n82), 
        .ZN(Midori_rounds_constant_MUX_n98) );
  NAND2_X1 Midori_rounds_constant_MUX_U98 ( .A1(Midori_rounds_constant_MUX_n77), .A2(Midori_rounds_constant_MUX_n76), .ZN(Midori_rounds_constant_MUX_n82) );
  NAND2_X1 Midori_rounds_constant_MUX_U97 ( .A1(
        Midori_rounds_constant_MUX_n124), .A2(Midori_rounds_constant_MUX_n18), 
        .ZN(Midori_rounds_constant_MUX_n76) );
  OR2_X1 Midori_rounds_constant_MUX_U96 ( .A1(Midori_rounds_constant_MUX_n75), 
        .A2(Midori_rounds_constant_MUX_n74), .ZN(
        Midori_rounds_constant_MUX_n77) );
  NAND2_X1 Midori_rounds_constant_MUX_U95 ( .A1(Midori_rounds_constant_MUX_n73), .A2(Midori_rounds_constant_MUX_n72), .ZN(Midori_rounds_round_Constant[14])
         );
  NOR2_X1 Midori_rounds_constant_MUX_U94 ( .A1(Midori_rounds_constant_MUX_n100), .A2(Midori_rounds_constant_MUX_n85), .ZN(Midori_rounds_constant_MUX_n72) );
  OR2_X1 Midori_rounds_constant_MUX_U93 ( .A1(Midori_rounds_constant_MUX_n71), 
        .A2(Midori_rounds_constant_MUX_n70), .ZN(
        Midori_rounds_constant_MUX_n85) );
  NAND2_X1 Midori_rounds_constant_MUX_U92 ( .A1(Midori_rounds_constant_MUX_n84), .A2(Midori_rounds_constant_MUX_n69), .ZN(Midori_rounds_round_Constant[12])
         );
  NOR2_X1 Midori_rounds_constant_MUX_U91 ( .A1(Midori_rounds_constant_MUX_n68), 
        .A2(Midori_rounds_constant_MUX_n67), .ZN(
        Midori_rounds_constant_MUX_n69) );
  NAND2_X1 Midori_rounds_constant_MUX_U90 ( .A1(Midori_rounds_constant_MUX_n97), .A2(Midori_rounds_constant_MUX_n78), .ZN(Midori_rounds_round_Constant[0]) );
  NOR2_X1 Midori_rounds_constant_MUX_U89 ( .A1(Midori_rounds_constant_MUX_n70), 
        .A2(Midori_rounds_constant_MUX_n66), .ZN(
        Midori_rounds_constant_MUX_n78) );
  NAND2_X1 Midori_rounds_constant_MUX_U88 ( .A1(Midori_rounds_constant_MUX_n65), .A2(Midori_rounds_constant_MUX_n84), .ZN(Midori_rounds_constant_MUX_n66) );
  INV_X1 Midori_rounds_constant_MUX_U87 ( .A(Midori_rounds_constant_MUX_n93), 
        .ZN(Midori_rounds_constant_MUX_n65) );
  NAND2_X1 Midori_rounds_constant_MUX_U86 ( .A1(Midori_rounds_constant_MUX_n92), .A2(Midori_rounds_constant_MUX_n64), .ZN(Midori_rounds_constant_MUX_n70) );
  AND2_X1 Midori_rounds_constant_MUX_U85 ( .A1(Midori_rounds_constant_MUX_n88), 
        .A2(Midori_rounds_constant_MUX_n63), .ZN(
        Midori_rounds_constant_MUX_n97) );
  NAND2_X1 Midori_rounds_constant_MUX_U84 ( .A1(Midori_rounds_constant_MUX_n88), .A2(Midori_rounds_constant_MUX_n62), .ZN(Midori_rounds_round_Constant[2]) );
  NOR2_X1 Midori_rounds_constant_MUX_U83 ( .A1(Midori_rounds_constant_MUX_n105), .A2(Midori_rounds_constant_MUX_n61), .ZN(Midori_rounds_constant_MUX_n62) );
  NAND2_X1 Midori_rounds_constant_MUX_U82 ( .A1(Midori_rounds_constant_MUX_n64), .A2(Midori_rounds_constant_MUX_n89), .ZN(Midori_rounds_constant_MUX_n61) );
  NAND2_X1 Midori_rounds_constant_MUX_U81 ( .A1(Midori_rounds_constant_MUX_n84), .A2(Midori_rounds_constant_MUX_n96), .ZN(Midori_rounds_constant_MUX_n105) );
  NOR2_X1 Midori_rounds_constant_MUX_U80 ( .A1(Midori_rounds_constant_MUX_n60), 
        .A2(Midori_rounds_constant_MUX_n59), .ZN(
        Midori_rounds_constant_MUX_n96) );
  NOR2_X1 Midori_rounds_constant_MUX_U79 ( .A1(Midori_rounds_constant_MUX_n58), 
        .A2(Midori_rounds_constant_MUX_n109), .ZN(
        Midori_rounds_constant_MUX_n59) );
  NOR2_X1 Midori_rounds_constant_MUX_U78 ( .A1(Midori_rounds_constant_MUX_n108), .A2(Midori_rounds_constant_MUX_n57), .ZN(Midori_rounds_constant_MUX_n60) );
  NOR2_X1 Midori_rounds_constant_MUX_U77 ( .A1(Midori_rounds_constant_MUX_n56), 
        .A2(Midori_rounds_constant_MUX_n55), .ZN(
        Midori_rounds_constant_MUX_n84) );
  NOR2_X1 Midori_rounds_constant_MUX_U76 ( .A1(Midori_rounds_constant_MUX_n57), 
        .A2(Midori_rounds_constant_MUX_n75), .ZN(
        Midori_rounds_constant_MUX_n55) );
  NOR2_X1 Midori_rounds_constant_MUX_U75 ( .A1(Midori_rounds_constant_MUX_n58), 
        .A2(Midori_rounds_constant_MUX_n127), .ZN(
        Midori_rounds_constant_MUX_n56) );
  NAND2_X1 Midori_rounds_constant_MUX_U74 ( .A1(Midori_rounds_constant_MUX_n54), .A2(Midori_rounds_constant_MUX_n102), .ZN(Midori_rounds_round_Constant[8])
         );
  INV_X1 Midori_rounds_constant_MUX_U73 ( .A(Midori_rounds_constant_MUX_n123), 
        .ZN(Midori_rounds_constant_MUX_n102) );
  NOR2_X1 Midori_rounds_constant_MUX_U72 ( .A1(Midori_rounds_constant_MUX_n68), 
        .A2(Midori_rounds_constant_MUX_n53), .ZN(
        Midori_rounds_constant_MUX_n54) );
  NAND2_X1 Midori_rounds_constant_MUX_U71 ( .A1(Midori_rounds_constant_MUX_n92), .A2(Midori_rounds_constant_MUX_n52), .ZN(Midori_rounds_round_Constant[4]) );
  NOR2_X1 Midori_rounds_constant_MUX_U70 ( .A1(Midori_rounds_constant_MUX_n94), 
        .A2(Midori_rounds_constant_MUX_n53), .ZN(
        Midori_rounds_constant_MUX_n52) );
  NAND2_X1 Midori_rounds_constant_MUX_U69 ( .A1(Midori_rounds_constant_MUX_n88), .A2(Midori_rounds_constant_MUX_n73), .ZN(Midori_rounds_constant_MUX_n94) );
  NOR2_X1 Midori_rounds_constant_MUX_U68 ( .A1(Midori_rounds_constant_MUX_n68), 
        .A2(Midori_rounds_constant_MUX_n51), .ZN(
        Midori_rounds_constant_MUX_n73) );
  NAND2_X1 Midori_rounds_constant_MUX_U67 ( .A1(
        Midori_rounds_constant_MUX_n107), .A2(Midori_rounds_constant_MUX_n50), 
        .ZN(Midori_rounds_constant_MUX_n68) );
  NOR2_X1 Midori_rounds_constant_MUX_U66 ( .A1(Midori_rounds_constant_MUX_n49), 
        .A2(Midori_rounds_constant_MUX_n48), .ZN(
        Midori_rounds_constant_MUX_n50) );
  NOR2_X1 Midori_rounds_constant_MUX_U65 ( .A1(Midori_rounds_constant_MUX_n109), .A2(Midori_rounds_constant_MUX_n57), .ZN(Midori_rounds_constant_MUX_n48) );
  NAND2_X1 Midori_rounds_constant_MUX_U64 ( .A1(round_Signal[2]), .A2(
        Midori_rounds_constant_MUX_n120), .ZN(Midori_rounds_constant_MUX_n57)
         );
  NOR2_X1 Midori_rounds_constant_MUX_U63 ( .A1(Midori_rounds_constant_MUX_n108), .A2(Midori_rounds_constant_MUX_n58), .ZN(Midori_rounds_constant_MUX_n49) );
  INV_X1 Midori_rounds_constant_MUX_U62 ( .A(Midori_rounds_constant_MUX_n47), 
        .ZN(Midori_rounds_constant_MUX_n58) );
  NOR2_X1 Midori_rounds_constant_MUX_U61 ( .A1(Midori_rounds_constant_MUX_n46), 
        .A2(Midori_rounds_constant_MUX_n45), .ZN(
        Midori_rounds_constant_MUX_n107) );
  NOR2_X1 Midori_rounds_constant_MUX_U60 ( .A1(Midori_rounds_constant_MUX_n109), .A2(Midori_rounds_constant_MUX_n74), .ZN(Midori_rounds_constant_MUX_n45) );
  AND2_X1 Midori_rounds_constant_MUX_U59 ( .A1(Midori_rounds_constant_MUX_n18), 
        .A2(Midori_rounds_constant_MUX_n44), .ZN(
        Midori_rounds_constant_MUX_n46) );
  NOR2_X1 Midori_rounds_constant_MUX_U58 ( .A1(Midori_rounds_constant_MUX_n116), .A2(Midori_rounds_constant_MUX_n43), .ZN(Midori_rounds_constant_MUX_n88) );
  NOR2_X1 Midori_rounds_constant_MUX_U57 ( .A1(Midori_rounds_constant_MUX_n108), .A2(Midori_rounds_constant_MUX_n42), .ZN(Midori_rounds_constant_MUX_n43) );
  NOR2_X1 Midori_rounds_constant_MUX_U56 ( .A1(Midori_rounds_constant_MUX_n109), .A2(Midori_rounds_constant_MUX_n41), .ZN(Midori_rounds_constant_MUX_n116) );
  NOR2_X1 Midori_rounds_constant_MUX_U55 ( .A1(Midori_rounds_constant_MUX_n40), 
        .A2(Midori_rounds_constant_MUX_n39), .ZN(
        Midori_rounds_constant_MUX_n92) );
  NOR2_X1 Midori_rounds_constant_MUX_U54 ( .A1(Midori_rounds_constant_MUX_n38), 
        .A2(Midori_rounds_constant_MUX_n108), .ZN(
        Midori_rounds_constant_MUX_n39) );
  NOR2_X1 Midori_rounds_constant_MUX_U53 ( .A1(Midori_rounds_constant_MUX_n74), 
        .A2(Midori_rounds_constant_MUX_n127), .ZN(
        Midori_rounds_constant_MUX_n40) );
  OR2_X1 Midori_rounds_constant_MUX_U52 ( .A1(Midori_rounds_constant_MUX_n67), 
        .A2(Midori_rounds_constant_MUX_n81), .ZN(
        Midori_rounds_round_Constant[7]) );
  NAND2_X1 Midori_rounds_constant_MUX_U51 ( .A1(Midori_rounds_constant_MUX_n37), .A2(Midori_rounds_constant_MUX_n89), .ZN(Midori_rounds_constant_MUX_n81) );
  NOR2_X1 Midori_rounds_constant_MUX_U50 ( .A1(Midori_rounds_constant_MUX_n123), .A2(Midori_rounds_constant_MUX_n86), .ZN(Midori_rounds_constant_MUX_n89) );
  NOR2_X1 Midori_rounds_constant_MUX_U49 ( .A1(Midori_rounds_constant_MUX_n36), 
        .A2(Midori_rounds_constant_MUX_n35), .ZN(
        Midori_rounds_constant_MUX_n86) );
  MUX2_X1 Midori_rounds_constant_MUX_U48 ( .A(Midori_rounds_constant_MUX_n74), 
        .B(Midori_rounds_constant_MUX_n38), .S(round_Signal[3]), .Z(
        Midori_rounds_constant_MUX_n35) );
  NAND2_X1 Midori_rounds_constant_MUX_U47 ( .A1(enc_dec), .A2(
        Midori_rounds_constant_MUX_n34), .ZN(Midori_rounds_constant_MUX_n74)
         );
  NOR2_X1 Midori_rounds_constant_MUX_U46 ( .A1(Midori_rounds_constant_MUX_n108), .A2(Midori_rounds_constant_MUX_n33), .ZN(Midori_rounds_constant_MUX_n123) );
  INV_X1 Midori_rounds_constant_MUX_U45 ( .A(Midori_rounds_constant_MUX_n51), 
        .ZN(Midori_rounds_constant_MUX_n37) );
  NAND2_X1 Midori_rounds_constant_MUX_U44 ( .A1(Midori_rounds_constant_MUX_n32), .A2(Midori_rounds_constant_MUX_n31), .ZN(Midori_rounds_constant_MUX_n51) );
  OR2_X1 Midori_rounds_constant_MUX_U43 ( .A1(Midori_rounds_constant_MUX_n109), 
        .A2(Midori_rounds_constant_MUX_n38), .ZN(
        Midori_rounds_constant_MUX_n31) );
  NAND2_X1 Midori_rounds_constant_MUX_U42 ( .A1(Midori_rounds_constant_MUX_n34), .A2(Midori_rounds_constant_MUX_n18), .ZN(Midori_rounds_constant_MUX_n38) );
  NAND2_X1 Midori_rounds_constant_MUX_U41 ( .A1(enc_dec), .A2(
        Midori_rounds_constant_MUX_n44), .ZN(Midori_rounds_constant_MUX_n32)
         );
  NOR2_X1 Midori_rounds_constant_MUX_U40 ( .A1(Midori_rounds_constant_MUX_n33), 
        .A2(Midori_rounds_constant_MUX_n75), .ZN(
        Midori_rounds_constant_MUX_n44) );
  NAND2_X1 Midori_rounds_constant_MUX_U39 ( .A1(Midori_rounds_constant_MUX_n63), .A2(Midori_rounds_constant_MUX_n30), .ZN(Midori_rounds_constant_MUX_n67) );
  NOR2_X1 Midori_rounds_constant_MUX_U38 ( .A1(Midori_rounds_constant_MUX_n53), 
        .A2(Midori_rounds_constant_MUX_n71), .ZN(
        Midori_rounds_constant_MUX_n30) );
  INV_X1 Midori_rounds_constant_MUX_U37 ( .A(Midori_rounds_constant_MUX_n103), 
        .ZN(Midori_rounds_constant_MUX_n71) );
  NOR2_X1 Midori_rounds_constant_MUX_U36 ( .A1(Midori_rounds_constant_MUX_n29), 
        .A2(Midori_rounds_constant_MUX_n124), .ZN(
        Midori_rounds_constant_MUX_n103) );
  NOR2_X1 Midori_rounds_constant_MUX_U35 ( .A1(Midori_rounds_constant_MUX_n109), .A2(Midori_rounds_constant_MUX_n33), .ZN(Midori_rounds_constant_MUX_n124) );
  NAND2_X1 Midori_rounds_constant_MUX_U34 ( .A1(round_Signal[2]), .A2(
        Midori_rounds_n1093), .ZN(Midori_rounds_constant_MUX_n33) );
  AND2_X1 Midori_rounds_constant_MUX_U33 ( .A1(Midori_rounds_constant_MUX_n28), 
        .A2(Midori_rounds_constant_MUX_n34), .ZN(
        Midori_rounds_constant_MUX_n29) );
  NOR2_X1 Midori_rounds_constant_MUX_U32 ( .A1(round_Signal[2]), .A2(
        Midori_rounds_constant_MUX_n27), .ZN(Midori_rounds_constant_MUX_n34)
         );
  NAND2_X1 Midori_rounds_constant_MUX_U31 ( .A1(Midori_rounds_constant_MUX_n64), .A2(Midori_rounds_constant_MUX_n26), .ZN(Midori_rounds_constant_MUX_n53) );
  NOR2_X1 Midori_rounds_constant_MUX_U30 ( .A1(Midori_rounds_constant_MUX_n100), .A2(Midori_rounds_constant_MUX_n93), .ZN(Midori_rounds_constant_MUX_n26) );
  NAND2_X1 Midori_rounds_constant_MUX_U29 ( .A1(Midori_rounds_constant_MUX_n25), .A2(Midori_rounds_constant_MUX_n24), .ZN(Midori_rounds_constant_MUX_n93) );
  OR2_X1 Midori_rounds_constant_MUX_U28 ( .A1(Midori_rounds_constant_MUX_n127), 
        .A2(Midori_rounds_constant_MUX_n41), .ZN(
        Midori_rounds_constant_MUX_n24) );
  OR2_X1 Midori_rounds_constant_MUX_U27 ( .A1(Midori_rounds_constant_MUX_n75), 
        .A2(Midori_rounds_constant_MUX_n42), .ZN(
        Midori_rounds_constant_MUX_n25) );
  NAND2_X1 Midori_rounds_constant_MUX_U26 ( .A1(
        Midori_rounds_constant_MUX_n130), .A2(Midori_rounds_constant_MUX_n23), 
        .ZN(Midori_rounds_constant_MUX_n100) );
  NAND2_X1 Midori_rounds_constant_MUX_U25 ( .A1(Midori_rounds_constant_MUX_n28), .A2(Midori_rounds_constant_MUX_n47), .ZN(Midori_rounds_constant_MUX_n23) );
  NOR2_X1 Midori_rounds_constant_MUX_U24 ( .A1(Midori_rounds_constant_MUX_n22), 
        .A2(round_Signal[2]), .ZN(Midori_rounds_constant_MUX_n47) );
  NAND2_X1 Midori_rounds_constant_MUX_U23 ( .A1(
        Midori_rounds_constant_MUX_n115), .A2(Midori_rounds_constant_MUX_n22), 
        .ZN(Midori_rounds_constant_MUX_n130) );
  NOR2_X1 Midori_rounds_constant_MUX_U22 ( .A1(Midori_rounds_constant_MUX_n121), .A2(Midori_rounds_constant_MUX_n127), .ZN(Midori_rounds_constant_MUX_n115)
         );
  NOR2_X1 Midori_rounds_constant_MUX_U21 ( .A1(Midori_rounds_constant_MUX_n21), 
        .A2(Midori_rounds_constant_MUX_n20), .ZN(
        Midori_rounds_constant_MUX_n64) );
  NOR2_X1 Midori_rounds_constant_MUX_U20 ( .A1(Midori_rounds_constant_MUX_n75), 
        .A2(Midori_rounds_constant_MUX_n41), .ZN(
        Midori_rounds_constant_MUX_n20) );
  INV_X1 Midori_rounds_constant_MUX_U19 ( .A(Midori_rounds_constant_MUX_n28), 
        .ZN(Midori_rounds_constant_MUX_n75) );
  NOR2_X1 Midori_rounds_constant_MUX_U18 ( .A1(round_Signal[1]), .A2(
        round_Signal[3]), .ZN(Midori_rounds_constant_MUX_n28) );
  NOR2_X1 Midori_rounds_constant_MUX_U17 ( .A1(Midori_rounds_constant_MUX_n42), 
        .A2(Midori_rounds_constant_MUX_n127), .ZN(
        Midori_rounds_constant_MUX_n21) );
  NAND2_X1 Midori_rounds_constant_MUX_U16 ( .A1(round_Signal[1]), .A2(
        round_Signal[3]), .ZN(Midori_rounds_constant_MUX_n127) );
  NOR2_X1 Midori_rounds_constant_MUX_U15 ( .A1(Midori_rounds_constant_MUX_n114), .A2(Midori_rounds_constant_MUX_n19), .ZN(Midori_rounds_constant_MUX_n63) );
  NOR2_X1 Midori_rounds_constant_MUX_U14 ( .A1(Midori_rounds_constant_MUX_n42), 
        .A2(Midori_rounds_constant_MUX_n109), .ZN(
        Midori_rounds_constant_MUX_n19) );
  NAND2_X1 Midori_rounds_constant_MUX_U13 ( .A1(round_Signal[3]), .A2(
        Midori_rounds_constant_MUX_n36), .ZN(Midori_rounds_constant_MUX_n109)
         );
  NAND2_X1 Midori_rounds_constant_MUX_U12 ( .A1(
        Midori_rounds_constant_MUX_n120), .A2(Midori_rounds_constant_MUX_n121), 
        .ZN(Midori_rounds_constant_MUX_n42) );
  NOR2_X1 Midori_rounds_constant_MUX_U11 ( .A1(Midori_rounds_n1093), .A2(
        enc_dec), .ZN(Midori_rounds_constant_MUX_n120) );
  NOR2_X1 Midori_rounds_constant_MUX_U10 ( .A1(Midori_rounds_constant_MUX_n41), 
        .A2(Midori_rounds_constant_MUX_n108), .ZN(
        Midori_rounds_constant_MUX_n114) );
  OR2_X1 Midori_rounds_constant_MUX_U9 ( .A1(Midori_rounds_constant_MUX_n36), 
        .A2(round_Signal[3]), .ZN(Midori_rounds_constant_MUX_n108) );
  INV_X1 Midori_rounds_constant_MUX_U8 ( .A(round_Signal[1]), .ZN(
        Midori_rounds_constant_MUX_n36) );
  OR2_X1 Midori_rounds_constant_MUX_U7 ( .A1(Midori_rounds_constant_MUX_n121), 
        .A2(Midori_rounds_constant_MUX_n22), .ZN(
        Midori_rounds_constant_MUX_n41) );
  NAND2_X1 Midori_rounds_constant_MUX_U6 ( .A1(Midori_rounds_constant_MUX_n27), 
        .A2(enc_dec), .ZN(Midori_rounds_constant_MUX_n22) );
  INV_X1 Midori_rounds_constant_MUX_U5 ( .A(Midori_rounds_n1093), .ZN(
        Midori_rounds_constant_MUX_n27) );
  INV_X1 Midori_rounds_constant_MUX_U4 ( .A(round_Signal[2]), .ZN(
        Midori_rounds_constant_MUX_n121) );
  INV_X1 Midori_rounds_constant_MUX_U3 ( .A(enc_dec), .ZN(
        Midori_rounds_constant_MUX_n18) );
  MUX2_X1 Midori_rounds_roundResult_Reg1_SFF_0_SFFInst_U3 ( .A(
        Midori_rounds_round_Result1[0]), .B(Midori_add_Result_Start1[0]), .S(
        reset), .Z(Midori_rounds_roundResult_Reg1_SFF_0_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg1_SFF_0_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg1_SFF_0_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out1[0]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg1_SFF_1_SFFInst_U3 ( .A(
        Midori_rounds_round_Result1[1]), .B(Midori_add_Result_Start1[1]), .S(
        reset), .Z(Midori_rounds_roundResult_Reg1_SFF_1_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg1_SFF_1_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg1_SFF_1_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out1[1]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg1_SFF_2_SFFInst_U3 ( .A(
        Midori_rounds_round_Result1[2]), .B(Midori_add_Result_Start1[2]), .S(
        reset), .Z(Midori_rounds_roundResult_Reg1_SFF_2_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg1_SFF_2_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg1_SFF_2_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out1[2]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg1_SFF_3_SFFInst_U3 ( .A(
        Midori_rounds_round_Result1[3]), .B(Midori_add_Result_Start1[3]), .S(
        reset), .Z(Midori_rounds_roundResult_Reg1_SFF_3_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg1_SFF_3_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg1_SFF_3_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out1[3]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg1_SFF_4_SFFInst_U3 ( .A(
        Midori_rounds_round_Result1[4]), .B(Midori_add_Result_Start1[4]), .S(
        reset), .Z(Midori_rounds_roundResult_Reg1_SFF_4_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg1_SFF_4_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg1_SFF_4_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out1[4]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg1_SFF_5_SFFInst_U3 ( .A(
        Midori_rounds_round_Result1[5]), .B(Midori_add_Result_Start1[5]), .S(
        reset), .Z(Midori_rounds_roundResult_Reg1_SFF_5_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg1_SFF_5_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg1_SFF_5_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out1[5]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg1_SFF_6_SFFInst_U3 ( .A(
        Midori_rounds_round_Result1[6]), .B(Midori_add_Result_Start1[6]), .S(
        reset), .Z(Midori_rounds_roundResult_Reg1_SFF_6_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg1_SFF_6_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg1_SFF_6_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out1[6]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg1_SFF_7_SFFInst_U3 ( .A(
        Midori_rounds_round_Result1[7]), .B(Midori_add_Result_Start1[7]), .S(
        reset), .Z(Midori_rounds_roundResult_Reg1_SFF_7_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg1_SFF_7_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg1_SFF_7_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out1[7]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg1_SFF_8_SFFInst_U3 ( .A(
        Midori_rounds_round_Result1[8]), .B(Midori_add_Result_Start1[8]), .S(
        reset), .Z(Midori_rounds_roundResult_Reg1_SFF_8_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg1_SFF_8_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg1_SFF_8_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out1[8]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg1_SFF_9_SFFInst_U3 ( .A(
        Midori_rounds_round_Result1[9]), .B(Midori_add_Result_Start1[9]), .S(
        reset), .Z(Midori_rounds_roundResult_Reg1_SFF_9_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg1_SFF_9_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg1_SFF_9_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out1[9]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg1_SFF_10_SFFInst_U3 ( .A(
        Midori_rounds_round_Result1[10]), .B(Midori_add_Result_Start1[10]), 
        .S(reset), .Z(Midori_rounds_roundResult_Reg1_SFF_10_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg1_SFF_10_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg1_SFF_10_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out1[10]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg1_SFF_11_SFFInst_U3 ( .A(
        Midori_rounds_round_Result1[11]), .B(Midori_add_Result_Start1[11]), 
        .S(reset), .Z(Midori_rounds_roundResult_Reg1_SFF_11_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg1_SFF_11_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg1_SFF_11_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out1[11]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg1_SFF_12_SFFInst_U3 ( .A(
        Midori_rounds_round_Result1[12]), .B(Midori_add_Result_Start1[12]), 
        .S(reset), .Z(Midori_rounds_roundResult_Reg1_SFF_12_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg1_SFF_12_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg1_SFF_12_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out1[12]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg1_SFF_13_SFFInst_U3 ( .A(
        Midori_rounds_round_Result1[13]), .B(Midori_add_Result_Start1[13]), 
        .S(reset), .Z(Midori_rounds_roundResult_Reg1_SFF_13_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg1_SFF_13_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg1_SFF_13_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out1[13]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg1_SFF_14_SFFInst_U3 ( .A(
        Midori_rounds_round_Result1[14]), .B(Midori_add_Result_Start1[14]), 
        .S(reset), .Z(Midori_rounds_roundResult_Reg1_SFF_14_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg1_SFF_14_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg1_SFF_14_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out1[14]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg1_SFF_15_SFFInst_U3 ( .A(
        Midori_rounds_round_Result1[15]), .B(Midori_add_Result_Start1[15]), 
        .S(reset), .Z(Midori_rounds_roundResult_Reg1_SFF_15_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg1_SFF_15_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg1_SFF_15_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out1[15]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg1_SFF_16_SFFInst_U3 ( .A(
        Midori_rounds_round_Result1[16]), .B(Midori_add_Result_Start1[16]), 
        .S(reset), .Z(Midori_rounds_roundResult_Reg1_SFF_16_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg1_SFF_16_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg1_SFF_16_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out1[16]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg1_SFF_17_SFFInst_U3 ( .A(
        Midori_rounds_round_Result1[17]), .B(Midori_add_Result_Start1[17]), 
        .S(reset), .Z(Midori_rounds_roundResult_Reg1_SFF_17_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg1_SFF_17_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg1_SFF_17_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out1[17]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg1_SFF_18_SFFInst_U3 ( .A(
        Midori_rounds_round_Result1[18]), .B(Midori_add_Result_Start1[18]), 
        .S(reset), .Z(Midori_rounds_roundResult_Reg1_SFF_18_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg1_SFF_18_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg1_SFF_18_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out1[18]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg1_SFF_19_SFFInst_U3 ( .A(
        Midori_rounds_round_Result1[19]), .B(Midori_add_Result_Start1[19]), 
        .S(reset), .Z(Midori_rounds_roundResult_Reg1_SFF_19_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg1_SFF_19_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg1_SFF_19_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out1[19]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg1_SFF_20_SFFInst_U3 ( .A(
        Midori_rounds_round_Result1[20]), .B(Midori_add_Result_Start1[20]), 
        .S(reset), .Z(Midori_rounds_roundResult_Reg1_SFF_20_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg1_SFF_20_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg1_SFF_20_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out1[20]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg1_SFF_21_SFFInst_U3 ( .A(
        Midori_rounds_round_Result1[21]), .B(Midori_add_Result_Start1[21]), 
        .S(reset), .Z(Midori_rounds_roundResult_Reg1_SFF_21_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg1_SFF_21_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg1_SFF_21_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out1[21]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg1_SFF_22_SFFInst_U3 ( .A(
        Midori_rounds_round_Result1[22]), .B(Midori_add_Result_Start1[22]), 
        .S(reset), .Z(Midori_rounds_roundResult_Reg1_SFF_22_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg1_SFF_22_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg1_SFF_22_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out1[22]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg1_SFF_23_SFFInst_U3 ( .A(
        Midori_rounds_round_Result1[23]), .B(Midori_add_Result_Start1[23]), 
        .S(reset), .Z(Midori_rounds_roundResult_Reg1_SFF_23_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg1_SFF_23_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg1_SFF_23_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out1[23]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg1_SFF_24_SFFInst_U3 ( .A(
        Midori_rounds_round_Result1[24]), .B(Midori_add_Result_Start1[24]), 
        .S(reset), .Z(Midori_rounds_roundResult_Reg1_SFF_24_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg1_SFF_24_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg1_SFF_24_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out1[24]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg1_SFF_25_SFFInst_U3 ( .A(
        Midori_rounds_round_Result1[25]), .B(Midori_add_Result_Start1[25]), 
        .S(reset), .Z(Midori_rounds_roundResult_Reg1_SFF_25_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg1_SFF_25_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg1_SFF_25_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out1[25]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg1_SFF_26_SFFInst_U3 ( .A(
        Midori_rounds_round_Result1[26]), .B(Midori_add_Result_Start1[26]), 
        .S(reset), .Z(Midori_rounds_roundResult_Reg1_SFF_26_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg1_SFF_26_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg1_SFF_26_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out1[26]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg1_SFF_27_SFFInst_U3 ( .A(
        Midori_rounds_round_Result1[27]), .B(Midori_add_Result_Start1[27]), 
        .S(reset), .Z(Midori_rounds_roundResult_Reg1_SFF_27_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg1_SFF_27_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg1_SFF_27_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out1[27]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg1_SFF_28_SFFInst_U3 ( .A(
        Midori_rounds_round_Result1[28]), .B(Midori_add_Result_Start1[28]), 
        .S(reset), .Z(Midori_rounds_roundResult_Reg1_SFF_28_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg1_SFF_28_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg1_SFF_28_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out1[28]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg1_SFF_29_SFFInst_U3 ( .A(
        Midori_rounds_round_Result1[29]), .B(Midori_add_Result_Start1[29]), 
        .S(reset), .Z(Midori_rounds_roundResult_Reg1_SFF_29_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg1_SFF_29_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg1_SFF_29_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out1[29]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg1_SFF_30_SFFInst_U3 ( .A(
        Midori_rounds_round_Result1[30]), .B(Midori_add_Result_Start1[30]), 
        .S(reset), .Z(Midori_rounds_roundResult_Reg1_SFF_30_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg1_SFF_30_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg1_SFF_30_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out1[30]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg1_SFF_31_SFFInst_U3 ( .A(
        Midori_rounds_round_Result1[31]), .B(Midori_add_Result_Start1[31]), 
        .S(reset), .Z(Midori_rounds_roundResult_Reg1_SFF_31_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg1_SFF_31_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg1_SFF_31_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out1[31]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg1_SFF_32_SFFInst_U3 ( .A(
        Midori_rounds_round_Result1[32]), .B(Midori_add_Result_Start1[32]), 
        .S(reset), .Z(Midori_rounds_roundResult_Reg1_SFF_32_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg1_SFF_32_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg1_SFF_32_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out1[32]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg1_SFF_33_SFFInst_U3 ( .A(
        Midori_rounds_round_Result1[33]), .B(Midori_add_Result_Start1[33]), 
        .S(reset), .Z(Midori_rounds_roundResult_Reg1_SFF_33_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg1_SFF_33_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg1_SFF_33_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out1[33]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg1_SFF_34_SFFInst_U3 ( .A(
        Midori_rounds_round_Result1[34]), .B(Midori_add_Result_Start1[34]), 
        .S(reset), .Z(Midori_rounds_roundResult_Reg1_SFF_34_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg1_SFF_34_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg1_SFF_34_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out1[34]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg1_SFF_35_SFFInst_U3 ( .A(
        Midori_rounds_round_Result1[35]), .B(Midori_add_Result_Start1[35]), 
        .S(reset), .Z(Midori_rounds_roundResult_Reg1_SFF_35_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg1_SFF_35_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg1_SFF_35_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out1[35]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg1_SFF_36_SFFInst_U3 ( .A(
        Midori_rounds_round_Result1[36]), .B(Midori_add_Result_Start1[36]), 
        .S(reset), .Z(Midori_rounds_roundResult_Reg1_SFF_36_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg1_SFF_36_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg1_SFF_36_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out1[36]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg1_SFF_37_SFFInst_U3 ( .A(
        Midori_rounds_round_Result1[37]), .B(Midori_add_Result_Start1[37]), 
        .S(reset), .Z(Midori_rounds_roundResult_Reg1_SFF_37_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg1_SFF_37_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg1_SFF_37_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out1[37]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg1_SFF_38_SFFInst_U3 ( .A(
        Midori_rounds_round_Result1[38]), .B(Midori_add_Result_Start1[38]), 
        .S(reset), .Z(Midori_rounds_roundResult_Reg1_SFF_38_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg1_SFF_38_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg1_SFF_38_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out1[38]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg1_SFF_39_SFFInst_U3 ( .A(
        Midori_rounds_round_Result1[39]), .B(Midori_add_Result_Start1[39]), 
        .S(reset), .Z(Midori_rounds_roundResult_Reg1_SFF_39_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg1_SFF_39_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg1_SFF_39_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out1[39]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg1_SFF_40_SFFInst_U3 ( .A(
        Midori_rounds_round_Result1[40]), .B(Midori_add_Result_Start1[40]), 
        .S(reset), .Z(Midori_rounds_roundResult_Reg1_SFF_40_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg1_SFF_40_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg1_SFF_40_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out1[40]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg1_SFF_41_SFFInst_U3 ( .A(
        Midori_rounds_round_Result1[41]), .B(Midori_add_Result_Start1[41]), 
        .S(reset), .Z(Midori_rounds_roundResult_Reg1_SFF_41_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg1_SFF_41_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg1_SFF_41_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out1[41]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg1_SFF_42_SFFInst_U3 ( .A(
        Midori_rounds_round_Result1[42]), .B(Midori_add_Result_Start1[42]), 
        .S(reset), .Z(Midori_rounds_roundResult_Reg1_SFF_42_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg1_SFF_42_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg1_SFF_42_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out1[42]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg1_SFF_43_SFFInst_U3 ( .A(
        Midori_rounds_round_Result1[43]), .B(Midori_add_Result_Start1[43]), 
        .S(reset), .Z(Midori_rounds_roundResult_Reg1_SFF_43_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg1_SFF_43_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg1_SFF_43_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out1[43]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg1_SFF_44_SFFInst_U3 ( .A(
        Midori_rounds_round_Result1[44]), .B(Midori_add_Result_Start1[44]), 
        .S(reset), .Z(Midori_rounds_roundResult_Reg1_SFF_44_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg1_SFF_44_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg1_SFF_44_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out1[44]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg1_SFF_45_SFFInst_U3 ( .A(
        Midori_rounds_round_Result1[45]), .B(Midori_add_Result_Start1[45]), 
        .S(reset), .Z(Midori_rounds_roundResult_Reg1_SFF_45_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg1_SFF_45_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg1_SFF_45_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out1[45]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg1_SFF_46_SFFInst_U3 ( .A(
        Midori_rounds_round_Result1[46]), .B(Midori_add_Result_Start1[46]), 
        .S(reset), .Z(Midori_rounds_roundResult_Reg1_SFF_46_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg1_SFF_46_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg1_SFF_46_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out1[46]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg1_SFF_47_SFFInst_U3 ( .A(
        Midori_rounds_round_Result1[47]), .B(Midori_add_Result_Start1[47]), 
        .S(reset), .Z(Midori_rounds_roundResult_Reg1_SFF_47_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg1_SFF_47_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg1_SFF_47_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out1[47]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg1_SFF_48_SFFInst_U3 ( .A(
        Midori_rounds_round_Result1[48]), .B(Midori_add_Result_Start1[48]), 
        .S(reset), .Z(Midori_rounds_roundResult_Reg1_SFF_48_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg1_SFF_48_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg1_SFF_48_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out1[48]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg1_SFF_49_SFFInst_U3 ( .A(
        Midori_rounds_round_Result1[49]), .B(Midori_add_Result_Start1[49]), 
        .S(reset), .Z(Midori_rounds_roundResult_Reg1_SFF_49_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg1_SFF_49_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg1_SFF_49_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out1[49]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg1_SFF_50_SFFInst_U3 ( .A(
        Midori_rounds_round_Result1[50]), .B(Midori_add_Result_Start1[50]), 
        .S(reset), .Z(Midori_rounds_roundResult_Reg1_SFF_50_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg1_SFF_50_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg1_SFF_50_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out1[50]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg1_SFF_51_SFFInst_U3 ( .A(
        Midori_rounds_round_Result1[51]), .B(Midori_add_Result_Start1[51]), 
        .S(reset), .Z(Midori_rounds_roundResult_Reg1_SFF_51_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg1_SFF_51_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg1_SFF_51_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out1[51]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg1_SFF_52_SFFInst_U3 ( .A(
        Midori_rounds_round_Result1[52]), .B(Midori_add_Result_Start1[52]), 
        .S(reset), .Z(Midori_rounds_roundResult_Reg1_SFF_52_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg1_SFF_52_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg1_SFF_52_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out1[52]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg1_SFF_53_SFFInst_U3 ( .A(
        Midori_rounds_round_Result1[53]), .B(Midori_add_Result_Start1[53]), 
        .S(reset), .Z(Midori_rounds_roundResult_Reg1_SFF_53_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg1_SFF_53_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg1_SFF_53_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out1[53]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg1_SFF_54_SFFInst_U3 ( .A(
        Midori_rounds_round_Result1[54]), .B(Midori_add_Result_Start1[54]), 
        .S(reset), .Z(Midori_rounds_roundResult_Reg1_SFF_54_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg1_SFF_54_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg1_SFF_54_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out1[54]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg1_SFF_55_SFFInst_U3 ( .A(
        Midori_rounds_round_Result1[55]), .B(Midori_add_Result_Start1[55]), 
        .S(reset), .Z(Midori_rounds_roundResult_Reg1_SFF_55_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg1_SFF_55_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg1_SFF_55_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out1[55]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg1_SFF_56_SFFInst_U3 ( .A(
        Midori_rounds_round_Result1[56]), .B(Midori_add_Result_Start1[56]), 
        .S(reset), .Z(Midori_rounds_roundResult_Reg1_SFF_56_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg1_SFF_56_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg1_SFF_56_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out1[56]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg1_SFF_57_SFFInst_U3 ( .A(
        Midori_rounds_round_Result1[57]), .B(Midori_add_Result_Start1[57]), 
        .S(reset), .Z(Midori_rounds_roundResult_Reg1_SFF_57_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg1_SFF_57_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg1_SFF_57_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out1[57]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg1_SFF_58_SFFInst_U3 ( .A(
        Midori_rounds_round_Result1[58]), .B(Midori_add_Result_Start1[58]), 
        .S(reset), .Z(Midori_rounds_roundResult_Reg1_SFF_58_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg1_SFF_58_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg1_SFF_58_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out1[58]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg1_SFF_59_SFFInst_U3 ( .A(
        Midori_rounds_round_Result1[59]), .B(Midori_add_Result_Start1[59]), 
        .S(reset), .Z(Midori_rounds_roundResult_Reg1_SFF_59_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg1_SFF_59_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg1_SFF_59_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out1[59]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg1_SFF_60_SFFInst_U3 ( .A(
        Midori_rounds_round_Result1[60]), .B(Midori_add_Result_Start1[60]), 
        .S(reset), .Z(Midori_rounds_roundResult_Reg1_SFF_60_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg1_SFF_60_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg1_SFF_60_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out1[60]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg1_SFF_61_SFFInst_U3 ( .A(
        Midori_rounds_round_Result1[61]), .B(Midori_add_Result_Start1[61]), 
        .S(reset), .Z(Midori_rounds_roundResult_Reg1_SFF_61_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg1_SFF_61_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg1_SFF_61_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out1[61]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg1_SFF_62_SFFInst_U3 ( .A(
        Midori_rounds_round_Result1[62]), .B(Midori_add_Result_Start1[62]), 
        .S(reset), .Z(Midori_rounds_roundResult_Reg1_SFF_62_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg1_SFF_62_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg1_SFF_62_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out1[62]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg1_SFF_63_SFFInst_U3 ( .A(
        Midori_rounds_round_Result1[63]), .B(Midori_add_Result_Start1[63]), 
        .S(reset), .Z(Midori_rounds_roundResult_Reg1_SFF_63_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg1_SFF_63_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg1_SFF_63_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out1[63]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg2_SFF_0_SFFInst_U3 ( .A(
        Midori_rounds_round_Result2[0]), .B(input2[0]), .S(reset), .Z(
        Midori_rounds_roundResult_Reg2_SFF_0_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg2_SFF_0_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg2_SFF_0_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out2[0]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg2_SFF_1_SFFInst_U3 ( .A(
        Midori_rounds_round_Result2[1]), .B(input2[1]), .S(reset), .Z(
        Midori_rounds_roundResult_Reg2_SFF_1_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg2_SFF_1_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg2_SFF_1_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out2[1]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg2_SFF_2_SFFInst_U3 ( .A(
        Midori_rounds_round_Result2[2]), .B(input2[2]), .S(reset), .Z(
        Midori_rounds_roundResult_Reg2_SFF_2_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg2_SFF_2_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg2_SFF_2_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out2[2]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg2_SFF_3_SFFInst_U3 ( .A(
        Midori_rounds_round_Result2[3]), .B(input2[3]), .S(reset), .Z(
        Midori_rounds_roundResult_Reg2_SFF_3_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg2_SFF_3_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg2_SFF_3_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out2[3]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg2_SFF_4_SFFInst_U3 ( .A(
        Midori_rounds_round_Result2[4]), .B(input2[4]), .S(reset), .Z(
        Midori_rounds_roundResult_Reg2_SFF_4_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg2_SFF_4_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg2_SFF_4_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out2[4]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg2_SFF_5_SFFInst_U3 ( .A(
        Midori_rounds_round_Result2[5]), .B(input2[5]), .S(reset), .Z(
        Midori_rounds_roundResult_Reg2_SFF_5_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg2_SFF_5_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg2_SFF_5_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out2[5]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg2_SFF_6_SFFInst_U3 ( .A(
        Midori_rounds_round_Result2[6]), .B(input2[6]), .S(reset), .Z(
        Midori_rounds_roundResult_Reg2_SFF_6_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg2_SFF_6_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg2_SFF_6_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out2[6]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg2_SFF_7_SFFInst_U3 ( .A(
        Midori_rounds_round_Result2[7]), .B(input2[7]), .S(reset), .Z(
        Midori_rounds_roundResult_Reg2_SFF_7_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg2_SFF_7_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg2_SFF_7_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out2[7]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg2_SFF_8_SFFInst_U3 ( .A(
        Midori_rounds_round_Result2[8]), .B(input2[8]), .S(reset), .Z(
        Midori_rounds_roundResult_Reg2_SFF_8_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg2_SFF_8_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg2_SFF_8_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out2[8]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg2_SFF_9_SFFInst_U3 ( .A(
        Midori_rounds_round_Result2[9]), .B(input2[9]), .S(reset), .Z(
        Midori_rounds_roundResult_Reg2_SFF_9_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg2_SFF_9_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg2_SFF_9_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out2[9]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg2_SFF_10_SFFInst_U3 ( .A(
        Midori_rounds_round_Result2[10]), .B(input2[10]), .S(reset), .Z(
        Midori_rounds_roundResult_Reg2_SFF_10_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg2_SFF_10_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg2_SFF_10_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out2[10]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg2_SFF_11_SFFInst_U3 ( .A(
        Midori_rounds_round_Result2[11]), .B(input2[11]), .S(reset), .Z(
        Midori_rounds_roundResult_Reg2_SFF_11_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg2_SFF_11_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg2_SFF_11_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out2[11]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg2_SFF_12_SFFInst_U3 ( .A(
        Midori_rounds_round_Result2[12]), .B(input2[12]), .S(reset), .Z(
        Midori_rounds_roundResult_Reg2_SFF_12_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg2_SFF_12_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg2_SFF_12_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out2[12]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg2_SFF_13_SFFInst_U3 ( .A(
        Midori_rounds_round_Result2[13]), .B(input2[13]), .S(reset), .Z(
        Midori_rounds_roundResult_Reg2_SFF_13_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg2_SFF_13_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg2_SFF_13_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out2[13]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg2_SFF_14_SFFInst_U3 ( .A(
        Midori_rounds_round_Result2[14]), .B(input2[14]), .S(reset), .Z(
        Midori_rounds_roundResult_Reg2_SFF_14_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg2_SFF_14_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg2_SFF_14_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out2[14]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg2_SFF_15_SFFInst_U3 ( .A(
        Midori_rounds_round_Result2[15]), .B(input2[15]), .S(reset), .Z(
        Midori_rounds_roundResult_Reg2_SFF_15_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg2_SFF_15_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg2_SFF_15_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out2[15]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg2_SFF_16_SFFInst_U3 ( .A(
        Midori_rounds_round_Result2[16]), .B(input2[16]), .S(reset), .Z(
        Midori_rounds_roundResult_Reg2_SFF_16_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg2_SFF_16_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg2_SFF_16_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out2[16]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg2_SFF_17_SFFInst_U3 ( .A(
        Midori_rounds_round_Result2[17]), .B(input2[17]), .S(reset), .Z(
        Midori_rounds_roundResult_Reg2_SFF_17_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg2_SFF_17_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg2_SFF_17_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out2[17]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg2_SFF_18_SFFInst_U3 ( .A(
        Midori_rounds_round_Result2[18]), .B(input2[18]), .S(reset), .Z(
        Midori_rounds_roundResult_Reg2_SFF_18_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg2_SFF_18_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg2_SFF_18_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out2[18]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg2_SFF_19_SFFInst_U3 ( .A(
        Midori_rounds_round_Result2[19]), .B(input2[19]), .S(reset), .Z(
        Midori_rounds_roundResult_Reg2_SFF_19_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg2_SFF_19_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg2_SFF_19_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out2[19]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg2_SFF_20_SFFInst_U3 ( .A(
        Midori_rounds_round_Result2[20]), .B(input2[20]), .S(reset), .Z(
        Midori_rounds_roundResult_Reg2_SFF_20_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg2_SFF_20_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg2_SFF_20_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out2[20]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg2_SFF_21_SFFInst_U3 ( .A(
        Midori_rounds_round_Result2[21]), .B(input2[21]), .S(reset), .Z(
        Midori_rounds_roundResult_Reg2_SFF_21_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg2_SFF_21_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg2_SFF_21_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out2[21]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg2_SFF_22_SFFInst_U3 ( .A(
        Midori_rounds_round_Result2[22]), .B(input2[22]), .S(reset), .Z(
        Midori_rounds_roundResult_Reg2_SFF_22_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg2_SFF_22_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg2_SFF_22_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out2[22]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg2_SFF_23_SFFInst_U3 ( .A(
        Midori_rounds_round_Result2[23]), .B(input2[23]), .S(reset), .Z(
        Midori_rounds_roundResult_Reg2_SFF_23_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg2_SFF_23_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg2_SFF_23_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out2[23]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg2_SFF_24_SFFInst_U3 ( .A(
        Midori_rounds_round_Result2[24]), .B(input2[24]), .S(reset), .Z(
        Midori_rounds_roundResult_Reg2_SFF_24_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg2_SFF_24_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg2_SFF_24_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out2[24]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg2_SFF_25_SFFInst_U3 ( .A(
        Midori_rounds_round_Result2[25]), .B(input2[25]), .S(reset), .Z(
        Midori_rounds_roundResult_Reg2_SFF_25_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg2_SFF_25_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg2_SFF_25_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out2[25]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg2_SFF_26_SFFInst_U3 ( .A(
        Midori_rounds_round_Result2[26]), .B(input2[26]), .S(reset), .Z(
        Midori_rounds_roundResult_Reg2_SFF_26_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg2_SFF_26_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg2_SFF_26_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out2[26]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg2_SFF_27_SFFInst_U3 ( .A(
        Midori_rounds_round_Result2[27]), .B(input2[27]), .S(reset), .Z(
        Midori_rounds_roundResult_Reg2_SFF_27_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg2_SFF_27_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg2_SFF_27_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out2[27]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg2_SFF_28_SFFInst_U3 ( .A(
        Midori_rounds_round_Result2[28]), .B(input2[28]), .S(reset), .Z(
        Midori_rounds_roundResult_Reg2_SFF_28_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg2_SFF_28_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg2_SFF_28_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out2[28]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg2_SFF_29_SFFInst_U3 ( .A(
        Midori_rounds_round_Result2[29]), .B(input2[29]), .S(reset), .Z(
        Midori_rounds_roundResult_Reg2_SFF_29_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg2_SFF_29_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg2_SFF_29_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out2[29]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg2_SFF_30_SFFInst_U3 ( .A(
        Midori_rounds_round_Result2[30]), .B(input2[30]), .S(reset), .Z(
        Midori_rounds_roundResult_Reg2_SFF_30_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg2_SFF_30_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg2_SFF_30_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out2[30]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg2_SFF_31_SFFInst_U3 ( .A(
        Midori_rounds_round_Result2[31]), .B(input2[31]), .S(reset), .Z(
        Midori_rounds_roundResult_Reg2_SFF_31_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg2_SFF_31_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg2_SFF_31_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out2[31]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg2_SFF_32_SFFInst_U3 ( .A(
        Midori_rounds_round_Result2[32]), .B(input2[32]), .S(reset), .Z(
        Midori_rounds_roundResult_Reg2_SFF_32_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg2_SFF_32_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg2_SFF_32_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out2[32]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg2_SFF_33_SFFInst_U3 ( .A(
        Midori_rounds_round_Result2[33]), .B(input2[33]), .S(reset), .Z(
        Midori_rounds_roundResult_Reg2_SFF_33_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg2_SFF_33_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg2_SFF_33_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out2[33]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg2_SFF_34_SFFInst_U3 ( .A(
        Midori_rounds_round_Result2[34]), .B(input2[34]), .S(reset), .Z(
        Midori_rounds_roundResult_Reg2_SFF_34_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg2_SFF_34_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg2_SFF_34_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out2[34]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg2_SFF_35_SFFInst_U3 ( .A(
        Midori_rounds_round_Result2[35]), .B(input2[35]), .S(reset), .Z(
        Midori_rounds_roundResult_Reg2_SFF_35_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg2_SFF_35_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg2_SFF_35_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out2[35]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg2_SFF_36_SFFInst_U3 ( .A(
        Midori_rounds_round_Result2[36]), .B(input2[36]), .S(reset), .Z(
        Midori_rounds_roundResult_Reg2_SFF_36_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg2_SFF_36_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg2_SFF_36_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out2[36]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg2_SFF_37_SFFInst_U3 ( .A(
        Midori_rounds_round_Result2[37]), .B(input2[37]), .S(reset), .Z(
        Midori_rounds_roundResult_Reg2_SFF_37_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg2_SFF_37_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg2_SFF_37_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out2[37]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg2_SFF_38_SFFInst_U3 ( .A(
        Midori_rounds_round_Result2[38]), .B(input2[38]), .S(reset), .Z(
        Midori_rounds_roundResult_Reg2_SFF_38_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg2_SFF_38_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg2_SFF_38_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out2[38]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg2_SFF_39_SFFInst_U3 ( .A(
        Midori_rounds_round_Result2[39]), .B(input2[39]), .S(reset), .Z(
        Midori_rounds_roundResult_Reg2_SFF_39_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg2_SFF_39_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg2_SFF_39_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out2[39]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg2_SFF_40_SFFInst_U3 ( .A(
        Midori_rounds_round_Result2[40]), .B(input2[40]), .S(reset), .Z(
        Midori_rounds_roundResult_Reg2_SFF_40_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg2_SFF_40_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg2_SFF_40_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out2[40]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg2_SFF_41_SFFInst_U3 ( .A(
        Midori_rounds_round_Result2[41]), .B(input2[41]), .S(reset), .Z(
        Midori_rounds_roundResult_Reg2_SFF_41_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg2_SFF_41_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg2_SFF_41_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out2[41]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg2_SFF_42_SFFInst_U3 ( .A(
        Midori_rounds_round_Result2[42]), .B(input2[42]), .S(reset), .Z(
        Midori_rounds_roundResult_Reg2_SFF_42_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg2_SFF_42_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg2_SFF_42_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out2[42]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg2_SFF_43_SFFInst_U3 ( .A(
        Midori_rounds_round_Result2[43]), .B(input2[43]), .S(reset), .Z(
        Midori_rounds_roundResult_Reg2_SFF_43_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg2_SFF_43_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg2_SFF_43_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out2[43]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg2_SFF_44_SFFInst_U3 ( .A(
        Midori_rounds_round_Result2[44]), .B(input2[44]), .S(reset), .Z(
        Midori_rounds_roundResult_Reg2_SFF_44_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg2_SFF_44_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg2_SFF_44_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out2[44]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg2_SFF_45_SFFInst_U3 ( .A(
        Midori_rounds_round_Result2[45]), .B(input2[45]), .S(reset), .Z(
        Midori_rounds_roundResult_Reg2_SFF_45_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg2_SFF_45_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg2_SFF_45_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out2[45]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg2_SFF_46_SFFInst_U3 ( .A(
        Midori_rounds_round_Result2[46]), .B(input2[46]), .S(reset), .Z(
        Midori_rounds_roundResult_Reg2_SFF_46_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg2_SFF_46_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg2_SFF_46_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out2[46]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg2_SFF_47_SFFInst_U3 ( .A(
        Midori_rounds_round_Result2[47]), .B(input2[47]), .S(reset), .Z(
        Midori_rounds_roundResult_Reg2_SFF_47_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg2_SFF_47_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg2_SFF_47_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out2[47]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg2_SFF_48_SFFInst_U3 ( .A(
        Midori_rounds_round_Result2[48]), .B(input2[48]), .S(reset), .Z(
        Midori_rounds_roundResult_Reg2_SFF_48_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg2_SFF_48_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg2_SFF_48_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out2[48]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg2_SFF_49_SFFInst_U3 ( .A(
        Midori_rounds_round_Result2[49]), .B(input2[49]), .S(reset), .Z(
        Midori_rounds_roundResult_Reg2_SFF_49_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg2_SFF_49_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg2_SFF_49_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out2[49]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg2_SFF_50_SFFInst_U3 ( .A(
        Midori_rounds_round_Result2[50]), .B(input2[50]), .S(reset), .Z(
        Midori_rounds_roundResult_Reg2_SFF_50_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg2_SFF_50_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg2_SFF_50_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out2[50]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg2_SFF_51_SFFInst_U3 ( .A(
        Midori_rounds_round_Result2[51]), .B(input2[51]), .S(reset), .Z(
        Midori_rounds_roundResult_Reg2_SFF_51_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg2_SFF_51_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg2_SFF_51_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out2[51]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg2_SFF_52_SFFInst_U3 ( .A(
        Midori_rounds_round_Result2[52]), .B(input2[52]), .S(reset), .Z(
        Midori_rounds_roundResult_Reg2_SFF_52_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg2_SFF_52_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg2_SFF_52_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out2[52]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg2_SFF_53_SFFInst_U3 ( .A(
        Midori_rounds_round_Result2[53]), .B(input2[53]), .S(reset), .Z(
        Midori_rounds_roundResult_Reg2_SFF_53_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg2_SFF_53_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg2_SFF_53_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out2[53]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg2_SFF_54_SFFInst_U3 ( .A(
        Midori_rounds_round_Result2[54]), .B(input2[54]), .S(reset), .Z(
        Midori_rounds_roundResult_Reg2_SFF_54_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg2_SFF_54_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg2_SFF_54_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out2[54]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg2_SFF_55_SFFInst_U3 ( .A(
        Midori_rounds_round_Result2[55]), .B(input2[55]), .S(reset), .Z(
        Midori_rounds_roundResult_Reg2_SFF_55_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg2_SFF_55_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg2_SFF_55_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out2[55]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg2_SFF_56_SFFInst_U3 ( .A(
        Midori_rounds_round_Result2[56]), .B(input2[56]), .S(reset), .Z(
        Midori_rounds_roundResult_Reg2_SFF_56_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg2_SFF_56_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg2_SFF_56_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out2[56]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg2_SFF_57_SFFInst_U3 ( .A(
        Midori_rounds_round_Result2[57]), .B(input2[57]), .S(reset), .Z(
        Midori_rounds_roundResult_Reg2_SFF_57_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg2_SFF_57_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg2_SFF_57_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out2[57]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg2_SFF_58_SFFInst_U3 ( .A(
        Midori_rounds_round_Result2[58]), .B(input2[58]), .S(reset), .Z(
        Midori_rounds_roundResult_Reg2_SFF_58_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg2_SFF_58_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg2_SFF_58_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out2[58]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg2_SFF_59_SFFInst_U3 ( .A(
        Midori_rounds_round_Result2[59]), .B(input2[59]), .S(reset), .Z(
        Midori_rounds_roundResult_Reg2_SFF_59_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg2_SFF_59_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg2_SFF_59_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out2[59]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg2_SFF_60_SFFInst_U3 ( .A(
        Midori_rounds_round_Result2[60]), .B(input2[60]), .S(reset), .Z(
        Midori_rounds_roundResult_Reg2_SFF_60_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg2_SFF_60_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg2_SFF_60_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out2[60]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg2_SFF_61_SFFInst_U3 ( .A(
        Midori_rounds_round_Result2[61]), .B(input2[61]), .S(reset), .Z(
        Midori_rounds_roundResult_Reg2_SFF_61_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg2_SFF_61_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg2_SFF_61_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out2[61]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg2_SFF_62_SFFInst_U3 ( .A(
        Midori_rounds_round_Result2[62]), .B(input2[62]), .S(reset), .Z(
        Midori_rounds_roundResult_Reg2_SFF_62_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg2_SFF_62_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg2_SFF_62_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out2[62]) , .QN() ); 
  MUX2_X1 Midori_rounds_roundResult_Reg2_SFF_63_SFFInst_U3 ( .A(
        Midori_rounds_round_Result2[63]), .B(input2[63]), .S(reset), .Z(
        Midori_rounds_roundResult_Reg2_SFF_63_SFFInst_N3) );
  DFF_X1 Midori_rounds_roundResult_Reg2_SFF_63_SFFInst_Q_reg ( .D(
        Midori_rounds_roundResult_Reg2_SFF_63_SFFInst_N3), .CK(clk), .Q(
        Midori_rounds_roundReg_out2[63]) , .QN() ); 
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F1_U17 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F1_n17), .A2(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F1_n16), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_g[1]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F1_U16 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F1_n15), .A2(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F1_n14), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F1_n16) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F1_U15 ( .A1(
        Midori_rounds_roundReg_out2[2]), .A2(Midori_rounds_roundReg_out1[3]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F1_n14) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F1_U14 ( .A(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F1_n13), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F1_n17) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F1_U13 ( .A(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F1_n12), .B(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F1_n11), .S(
        Midori_rounds_roundReg_out1[1]), .Z(
        Midori_rounds_sub_sBox_PRINCE_0_e[1]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F1_U12 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F1_n10), .A2(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F1_n15), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F1_n12) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F1_U11 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F1_n9), .A2(
        Midori_rounds_roundReg_out1[3]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F1_n15) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F1_U10 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F1_n8), .A2(
        Midori_rounds_roundReg_out2[2]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F1_n10) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F1_U9 ( .A1(
        Midori_rounds_roundReg_out1[3]), .A2(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F1_n9), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F1_n8) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F1_U8 ( .A(
        Midori_rounds_roundReg_out1[0]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F1_n9) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F1_U7 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F1_n7), .A2(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F1_n6), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_h[1]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F1_U6 ( .A1(
        Midori_rounds_roundReg_out1[3]), .A2(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F1_n13), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F1_n6) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F1_U5 ( .A1(
        Midori_rounds_roundReg_out1[1]), .A2(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F1_n5), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F1_n13) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F1_U4 ( .A1(
        Midori_rounds_roundReg_out2[2]), .A2(Midori_rounds_roundReg_out1[0]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F1_n5) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F1_U3 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F1_n4), .A2(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F1_n11), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F1_n7) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F1_U2 ( .A(
        Midori_rounds_roundReg_out2[2]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F1_n11) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F1_U1 ( .A1(
        Midori_rounds_roundReg_out1[3]), .A2(Midori_rounds_roundReg_out1[0]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F1_n4) );
  AND2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F2_U12 ( .A1(
        Midori_rounds_roundReg_out2[1]), .A2(
        Midori_rounds_sub_sBox_PRINCE_0_f[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_e[2]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F2_U11 ( .A(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F2_n11), .B(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F2_n10), .S(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F2_n9), .Z(
        Midori_rounds_sub_sBox_PRINCE_0_f[1]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F2_U10 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F2_n8), .A2(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F2_n7), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_g[2]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F2_U9 ( .A(
        Midori_rounds_roundReg_out1[2]), .B(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F2_n6), .S(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F2_n9), .Z(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F2_n7) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F2_U8 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F2_n10), .A2(
        Midori_rounds_roundReg_out2[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F2_n8) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F2_U7 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F2_n5), .A2(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F2_n4), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_h[2]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F2_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F2_n11), .A2(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F2_n10), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F2_n4) );
  AND2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F2_U5 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F2_n6), .A2(
        Midori_rounds_roundReg_out1[2]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F2_n10) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F2_U4 ( .A1(
        Midori_rounds_roundReg_out1[2]), .A2(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F2_n6), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F2_n11) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F2_U3 ( .A(
        Midori_rounds_roundReg_out1[0]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F2_n6) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F2_U2 ( .A1(
        Midori_rounds_roundReg_out2[1]), .A2(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F2_n9), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F2_n5) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F2_U1 ( .A(
        Midori_rounds_roundReg_out1[3]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F2_n9) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F3_U13 ( .A1(
        Midori_rounds_roundReg_out1[1]), .A2(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F3_n13), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_g[3]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F3_U12 ( .A(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F3_n12), .B(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F3_n11), .S(
        Midori_rounds_roundReg_out2[0]), .Z(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F3_n13) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F3_U11 ( .A1(
        Midori_rounds_roundReg_out1[3]), .A2(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F3_n10), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F3_n11) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F3_U10 ( .A1(
        Midori_rounds_roundReg_out1[2]), .A2(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F3_n9), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F3_n12) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F3_U9 ( .A(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F3_n8), .B(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F3_n7), .S(
        Midori_rounds_roundReg_out1[2]), .Z(
        Midori_rounds_sub_sBox_PRINCE_0_e[3]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F3_U8 ( .A1(
        Midori_rounds_roundReg_out2[0]), .A2(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F3_n6), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F3_n7) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F3_U7 ( .A1(
        Midori_rounds_roundReg_out1[1]), .A2(Midori_rounds_roundReg_out1[3]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F3_n6) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F3_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F3_n5), .A2(
        Midori_rounds_roundReg_out1[3]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F3_n8) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F3_U5 ( .A1(
        Midori_rounds_roundReg_out1[1]), .A2(Midori_rounds_roundReg_out2[0]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F3_n5) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F3_U4 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F3_n9), .A2(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F3_n4), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_h[3]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F3_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F3_n10), .B(
        Midori_rounds_roundReg_out2[0]), .S(Midori_rounds_roundReg_out1[1]), 
        .Z(Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F3_n4) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F3_U2 ( .A(
        Midori_rounds_roundReg_out1[2]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F3_n10) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F3_U1 ( .A(
        Midori_rounds_roundReg_out1[3]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F3_n9) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F4_U15 ( .A(
        Midori_rounds_roundReg_out2[0]), .B(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F4_n15), .S(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F4_n14), .Z(
        Midori_rounds_sub_sBox_PRINCE_0_h[4]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F4_U14 ( .A1(
        Midori_rounds_roundReg_out1[3]), .A2(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F4_n13), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F4_n14) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F4_U13 ( .A(
        Midori_rounds_roundReg_out2[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F4_n13) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F4_U12 ( .A(
        Midori_rounds_roundReg_out2[0]), .B(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F4_n12), .S(
        Midori_rounds_roundReg_out2[1]), .Z(
        Midori_rounds_sub_sBox_PRINCE_0_g[4]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F4_U11 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F4_n11), .A2(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F4_n10), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F4_n12) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F4_U10 ( .A1(
        Midori_rounds_roundReg_out2[2]), .A2(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F4_n9), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F4_n11) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F4_U9 ( .A(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F4_n8), .B(
        Midori_rounds_roundReg_out2[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_f[2]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F4_U8 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F4_n7), .A2(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F4_n10), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F4_n8) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F4_U7 ( .A1(
        Midori_rounds_roundReg_out2[1]), .A2(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F4_n6), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_e[4]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F4_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F4_n7), .A2(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F4_n5), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F4_n6) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F4_U5 ( .A1(
        Midori_rounds_roundReg_out2[2]), .A2(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F4_n10), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F4_n5) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F4_U4 ( .A1(
        Midori_rounds_roundReg_out2[0]), .A2(Midori_rounds_roundReg_out1[3]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F4_n10) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F4_U3 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F4_n15), .A2(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F4_n9), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F4_n7) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F4_U2 ( .A1(
        Midori_rounds_roundReg_out2[0]), .A2(Midori_rounds_roundReg_out1[3]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F4_n9) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F4_U1 ( .A(
        Midori_rounds_roundReg_out2[2]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F4_n15) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F5_U12 ( .A(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F5_n11), .B(
        Midori_rounds_roundReg_out1[0]), .S(Midori_rounds_roundReg_out1[1]), 
        .Z(Midori_rounds_sub_sBox_PRINCE_0_g[5]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F5_U11 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F5_n10), .A2(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F5_n9), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F5_n11) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F5_U10 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F5_n8), .A2(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F5_n7), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F5_n9) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F5_U9 ( .A(
        Midori_rounds_roundReg_out1[0]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F5_n8) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F5_U8 ( .A(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F5_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F5_n5), .S(
        Midori_rounds_roundReg_out1[0]), .Z(
        Midori_rounds_sub_sBox_PRINCE_0_e[5]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F5_U7 ( .A1(
        Midori_rounds_roundReg_out1[1]), .A2(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F5_n7), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F5_n5) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F5_U6 ( .A1(
        Midori_rounds_roundReg_out2[3]), .A2(Midori_rounds_roundReg_out1[2]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F5_n7) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F5_U5 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F5_n6), .A2(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F5_n4), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_h[5]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F5_U4 ( .A1(
        Midori_rounds_roundReg_out2[3]), .A2(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F5_n3), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F5_n4) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F5_U3 ( .A1(
        Midori_rounds_roundReg_out1[1]), .A2(Midori_rounds_roundReg_out1[0]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F5_n3) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F5_U2 ( .A1(
        Midori_rounds_roundReg_out1[1]), .A2(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F5_n10), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F5_n6) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F5_U1 ( .A1(
        Midori_rounds_roundReg_out2[3]), .A2(Midori_rounds_roundReg_out1[2]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F5_n10) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_U22 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_n22), .A2(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_n21), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_h[6]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_U21 ( .A1(
        Midori_rounds_roundReg_out2[1]), .A2(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_n20), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_n21) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_U20 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_n19), .A2(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_n18), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_n22) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_U19 ( .A(
        Midori_rounds_roundReg_out2[3]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_n18) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_U18 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_n17), .A2(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_n16), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_n19) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_U17 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_n17), .A2(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_n15), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_e[6]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_U16 ( .A(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_n14), .B(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_n13), .S(
        Midori_rounds_roundReg_out2[3]), .Z(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_n15) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_U15 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_n12), .A2(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_n11), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_f[3]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_U14 ( .A1(
        Midori_rounds_roundReg_out2[1]), .A2(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_n10), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_n11) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_U13 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_n9), .A2(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_n8), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_n12) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_U12 ( .A(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_n10), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_n8) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_U11 ( .A1(
        Midori_rounds_roundReg_out2[2]), .A2(Midori_rounds_roundReg_out1[0]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_n10) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_U10 ( .A(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_n7), .B(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_n17), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_n9) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_U9 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_n6), .A2(
        Midori_rounds_roundReg_out2[3]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_n7) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_U8 ( .A1(
        Midori_rounds_roundReg_out2[2]), .A2(Midori_rounds_roundReg_out1[0]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_n6) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_U7 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_n17), .A2(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_n5), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_g[6]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_U6 ( .A(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_n13), .B(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_n14), .S(
        Midori_rounds_roundReg_out2[3]), .Z(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_n5) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_U5 ( .A1(
        Midori_rounds_roundReg_out2[2]), .A2(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_n20), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_n14) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_U4 ( .A(
        Midori_rounds_roundReg_out1[0]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_n20) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_U3 ( .A1(
        Midori_rounds_roundReg_out1[0]), .A2(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_n16), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_n13) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_U2 ( .A(
        Midori_rounds_roundReg_out2[2]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_n16) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_U1 ( .A(
        Midori_rounds_roundReg_out2[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F6_n17) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F7_U11 ( .A(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F7_n9), .B(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F7_n8), .S(
        Midori_rounds_roundReg_out1[1]), .Z(
        Midori_rounds_sub_sBox_PRINCE_0_h[7]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F7_U10 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F7_n7), .A2(
        Midori_rounds_roundReg_out2[2]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F7_n8) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F7_U9 ( .A(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F7_n6), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F7_n9) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F7_U8 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F7_n5), .A2(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F7_n4), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_g[7]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F7_U7 ( .A(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F7_n3), .B(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F7_n6), .S(
        Midori_rounds_roundReg_out2[2]), .Z(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F7_n4) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F7_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F7_n5), .A2(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F7_n2), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_e[7]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F7_U5 ( .A(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F7_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F7_n3), .S(
        Midori_rounds_roundReg_out2[2]), .Z(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F7_n2) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F7_U4 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F7_n7), .A2(
        Midori_rounds_roundReg_out2[0]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F7_n3) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F7_U3 ( .A1(
        Midori_rounds_roundReg_out2[0]), .A2(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F7_n7), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F7_n6) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F7_U2 ( .A(
        Midori_rounds_roundReg_out2[3]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F7_n7) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F7_U1 ( .A(
        Midori_rounds_roundReg_out1[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F7_n5) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F8_U17 ( .A(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F8_n16), .B(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F8_n15), .S(
        Midori_rounds_roundReg_out2[1]), .Z(
        Midori_rounds_sub_sBox_PRINCE_0_e[8]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F8_U16 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F8_n14), .A2(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F8_n13), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F8_n16) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F8_U15 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F8_n12), .A2(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F8_n11), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_h[8]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F8_U14 ( .A1(
        Midori_rounds_roundReg_out2[1]), .A2(Midori_rounds_roundReg_out1[2]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F8_n11) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F8_U13 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F8_n10), .A2(
        Midori_rounds_roundReg_out2[3]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F8_n12) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F8_U12 ( .A1(
        Midori_rounds_roundReg_out2[1]), .A2(Midori_rounds_roundReg_out2[0]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F8_n10) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F8_U11 ( .A1(
        Midori_rounds_roundReg_out2[1]), .A2(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F8_n9), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_g[8]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F8_U10 ( .A(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F8_n8), .B(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F8_n7), .S(
        Midori_rounds_roundReg_out2[3]), .Z(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F8_n9) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F8_U9 ( .A1(
        Midori_rounds_roundReg_out2[0]), .A2(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F8_n15), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F8_n7) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F8_U8 ( .A(
        Midori_rounds_roundReg_out1[2]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F8_n15) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F8_U7 ( .A1(
        Midori_rounds_roundReg_out1[2]), .A2(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F8_n6), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F8_n8) );
  AND2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F8_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F8_n5), .A2(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F8_n14), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_f[4]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F8_U5 ( .A1(
        Midori_rounds_roundReg_out2[0]), .A2(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F8_n4), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F8_n14) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F8_U4 ( .A1(
        Midori_rounds_roundReg_out2[3]), .A2(Midori_rounds_roundReg_out1[2]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F8_n4) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F8_U3 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F8_n13), .A2(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F8_n6), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F8_n5) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F8_U2 ( .A(
        Midori_rounds_roundReg_out2[0]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F8_n6) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F8_U1 ( .A1(
        Midori_rounds_roundReg_out2[3]), .A2(Midori_rounds_roundReg_out1[2]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_0_Inst_N_F8_n13) );
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_0_InAff_output_reg_s_current_state_reg_7_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_0_e[8]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_0_e_reg[8]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_0_InAff_output_reg_s_current_state_reg_10_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_0_f[3]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_0_f_reg[3]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_0_InAff_output_reg_s_current_state_reg_16_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_0_g[5]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_0_g_reg[5]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_0_InAff_output_reg_s_current_state_reg_15_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_0_g[4]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_0_g_reg[4]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_0_InAff_output_reg_s_current_state_reg_19_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_0_g[8]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_0_g_reg[8]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_0_InAff_output_reg_s_current_state_reg_2_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_0_e[3]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_0_e_reg[3]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_0_InAff_output_reg_s_current_state_reg_9_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_0_f[2]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_0_f_reg[2]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_0_InAff_output_reg_s_current_state_reg_4_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_0_e[5]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_0_e_reg[5]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_0_InAff_output_reg_s_current_state_reg_17_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_0_g[6]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_0_g_reg[6]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_0_InAff_output_reg_s_current_state_reg_3_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_0_e[4]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_0_e_reg[4]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_0_InAff_output_reg_s_current_state_reg_13_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_0_g[2]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_0_g_reg[2]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_0_InAff_output_reg_s_current_state_reg_20_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_0_h[1]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_0_h_reg[1]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_0_InAff_output_reg_s_current_state_reg_26_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_0_h[7]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_0_h_reg[7]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_0_InAff_output_reg_s_current_state_reg_0_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_0_e[1]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_0_e_reg[1]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_0_InAff_output_reg_s_current_state_reg_1_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_0_e[2]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_0_e_reg[2]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_0_InAff_output_reg_s_current_state_reg_21_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_0_h[2]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_0_h_reg[2]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_0_InAff_output_reg_s_current_state_reg_6_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_0_e[7]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_0_e_reg[7]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_0_InAff_output_reg_s_current_state_reg_5_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_0_e[6]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_0_e_reg[6]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_0_InAff_output_reg_s_current_state_reg_14_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_0_g[3]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_0_g_reg[3]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_0_InAff_output_reg_s_current_state_reg_18_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_0_g[7]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_0_g_reg[7]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_0_InAff_output_reg_s_current_state_reg_22_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_0_h[3]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_0_h_reg[3]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_0_InAff_output_reg_s_current_state_reg_11_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_0_f[4]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_0_f_reg[4]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_0_InAff_output_reg_s_current_state_reg_24_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_0_h[5]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_0_h_reg[5]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_0_InAff_output_reg_s_current_state_reg_23_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_0_h[4]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_0_h_reg[4]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_0_InAff_output_reg_s_current_state_reg_25_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_0_h[6]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_0_h_reg[6]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_0_InAff_output_reg_s_current_state_reg_8_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_0_f[1]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_0_f_reg[1]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_0_InAff_output_reg_s_current_state_reg_27_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_0_h[8]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_0_h_reg[8]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_0_InAff_output_reg_s_current_state_reg_12_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_0_g[1]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_0_g_reg[1]) , .QN() ); 
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_L_XORInst1_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_L_XORInst1_n2), .B(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_L_XORInst1_n1), .ZN(output1[0])
         );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_L_XORInst1_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_0_e_reg[2]), .B(
        Midori_rounds_sub_sBox_PRINCE_0_e_reg[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_L_XORInst1_n1) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_L_XORInst1_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_0_e_reg[3]), .B(
        Midori_rounds_sub_sBox_PRINCE_0_e_reg[4]), .Z(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_L_XORInst1_n2) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_L_XORInst2_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_L_XORInst2_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_L_XORInst2_n5), .ZN(
        Midori_rounds_SR_Result2[48]) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_L_XORInst2_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_0_e_reg[6]), .B(
        Midori_rounds_sub_sBox_PRINCE_0_e_reg[5]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_L_XORInst2_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_L_XORInst2_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_0_e_reg[7]), .B(
        Midori_rounds_sub_sBox_PRINCE_0_e_reg[8]), .Z(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_L_XORInst2_n6) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_L_XORInst3_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_0_f_reg[2]), .B(
        Midori_rounds_sub_sBox_PRINCE_0_f_reg[1]), .Z(output1[1]) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_L_XORInst4_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_0_f_reg[4]), .B(
        Midori_rounds_sub_sBox_PRINCE_0_f_reg[3]), .Z(
        Midori_rounds_SR_Result2[49]) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_L_XORInst5_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_L_XORInst5_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_L_XORInst5_n5), .ZN(output1[2])
         );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_L_XORInst5_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_0_g_reg[2]), .B(
        Midori_rounds_sub_sBox_PRINCE_0_g_reg[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_L_XORInst5_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_L_XORInst5_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_0_g_reg[3]), .B(
        Midori_rounds_sub_sBox_PRINCE_0_g_reg[4]), .Z(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_L_XORInst5_n6) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_L_XORInst6_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_L_XORInst6_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_L_XORInst6_n5), .ZN(
        Midori_rounds_SR_Result2[50]) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_L_XORInst6_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_0_g_reg[6]), .B(
        Midori_rounds_sub_sBox_PRINCE_0_g_reg[5]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_L_XORInst6_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_L_XORInst6_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_0_g_reg[7]), .B(
        Midori_rounds_sub_sBox_PRINCE_0_g_reg[8]), .Z(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_L_XORInst6_n6) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_L_XORInst7_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_L_XORInst7_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_L_XORInst7_n5), .ZN(output1[3])
         );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_L_XORInst7_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_0_h_reg[2]), .B(
        Midori_rounds_sub_sBox_PRINCE_0_h_reg[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_L_XORInst7_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_L_XORInst7_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_0_h_reg[3]), .B(
        Midori_rounds_sub_sBox_PRINCE_0_h_reg[4]), .Z(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_L_XORInst7_n6) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_L_XORInst8_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_L_XORInst8_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_L_XORInst8_n5), .ZN(
        Midori_rounds_SR_Result2[51]) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_L_XORInst8_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_0_h_reg[6]), .B(
        Midori_rounds_sub_sBox_PRINCE_0_h_reg[5]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_L_XORInst8_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_0_Inst_L_XORInst8_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_0_h_reg[7]), .B(
        Midori_rounds_sub_sBox_PRINCE_0_h_reg[8]), .Z(
        Midori_rounds_sub_sBox_PRINCE_0_Inst_L_XORInst8_n6) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F1_U17 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F1_n43), .A2(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F1_n42), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_g[1]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F1_U16 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F1_n41), .A2(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F1_n40), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F1_n42) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F1_U15 ( .A1(
        Midori_rounds_roundReg_out2[6]), .A2(Midori_rounds_roundReg_out1[7]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F1_n40) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F1_U14 ( .A(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F1_n39), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F1_n43) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F1_U13 ( .A(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F1_n38), .B(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F1_n37), .S(
        Midori_rounds_roundReg_out1[5]), .Z(
        Midori_rounds_sub_sBox_PRINCE_1_e[1]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F1_U12 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F1_n36), .A2(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F1_n41), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F1_n38) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F1_U11 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F1_n35), .A2(
        Midori_rounds_roundReg_out1[7]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F1_n41) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F1_U10 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F1_n34), .A2(
        Midori_rounds_roundReg_out2[6]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F1_n36) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F1_U9 ( .A1(
        Midori_rounds_roundReg_out1[7]), .A2(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F1_n35), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F1_n34) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F1_U8 ( .A(
        Midori_rounds_roundReg_out1[4]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F1_n35) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F1_U7 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F1_n33), .A2(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F1_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_h[1]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F1_U6 ( .A1(
        Midori_rounds_roundReg_out1[7]), .A2(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F1_n39), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F1_n32) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F1_U5 ( .A1(
        Midori_rounds_roundReg_out1[5]), .A2(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F1_n31), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F1_n39) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F1_U4 ( .A1(
        Midori_rounds_roundReg_out2[6]), .A2(Midori_rounds_roundReg_out1[4]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F1_n31) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F1_U3 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F1_n30), .A2(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F1_n37), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F1_n33) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F1_U2 ( .A(
        Midori_rounds_roundReg_out2[6]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F1_n37) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F1_U1 ( .A1(
        Midori_rounds_roundReg_out1[7]), .A2(Midori_rounds_roundReg_out1[4]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F1_n30) );
  AND2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F2_U12 ( .A1(
        Midori_rounds_roundReg_out2[5]), .A2(
        Midori_rounds_sub_sBox_PRINCE_1_f[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_e[2]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F2_U11 ( .A(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F2_n33), .B(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F2_n32), .S(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F2_n31), .Z(
        Midori_rounds_sub_sBox_PRINCE_1_f[1]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F2_U10 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F2_n30), .A2(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F2_n29), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_g[2]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F2_U9 ( .A(
        Midori_rounds_roundReg_out1[6]), .B(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F2_n28), .S(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F2_n31), .Z(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F2_n29) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F2_U8 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F2_n32), .A2(
        Midori_rounds_roundReg_out2[5]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F2_n30) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F2_U7 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F2_n27), .A2(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F2_n26), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_h[2]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F2_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F2_n33), .A2(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F2_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F2_n26) );
  AND2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F2_U5 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F2_n28), .A2(
        Midori_rounds_roundReg_out1[6]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F2_n32) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F2_U4 ( .A1(
        Midori_rounds_roundReg_out1[6]), .A2(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F2_n28), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F2_n33) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F2_U3 ( .A(
        Midori_rounds_roundReg_out1[4]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F2_n28) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F2_U2 ( .A1(
        Midori_rounds_roundReg_out2[5]), .A2(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F2_n31), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F2_n27) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F2_U1 ( .A(
        Midori_rounds_roundReg_out1[7]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F2_n31) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F3_U13 ( .A1(
        Midori_rounds_roundReg_out1[5]), .A2(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F3_n35), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_g[3]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F3_U12 ( .A(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F3_n34), .B(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F3_n33), .S(
        Midori_rounds_roundReg_out2[4]), .Z(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F3_n35) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F3_U11 ( .A1(
        Midori_rounds_roundReg_out1[7]), .A2(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F3_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F3_n33) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F3_U10 ( .A1(
        Midori_rounds_roundReg_out1[6]), .A2(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F3_n31), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F3_n34) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F3_U9 ( .A(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F3_n30), .B(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F3_n29), .S(
        Midori_rounds_roundReg_out1[6]), .Z(
        Midori_rounds_sub_sBox_PRINCE_1_e[3]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F3_U8 ( .A1(
        Midori_rounds_roundReg_out2[4]), .A2(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F3_n28), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F3_n29) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F3_U7 ( .A1(
        Midori_rounds_roundReg_out1[5]), .A2(Midori_rounds_roundReg_out1[7]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F3_n28) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F3_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F3_n27), .A2(
        Midori_rounds_roundReg_out1[7]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F3_n30) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F3_U5 ( .A1(
        Midori_rounds_roundReg_out1[5]), .A2(Midori_rounds_roundReg_out2[4]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F3_n27) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F3_U4 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F3_n31), .A2(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F3_n26), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_h[3]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F3_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F3_n32), .B(
        Midori_rounds_roundReg_out2[4]), .S(Midori_rounds_roundReg_out1[5]), 
        .Z(Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F3_n26) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F3_U2 ( .A(
        Midori_rounds_roundReg_out1[6]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F3_n32) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F3_U1 ( .A(
        Midori_rounds_roundReg_out1[7]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F3_n31) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F4_U15 ( .A(
        Midori_rounds_roundReg_out2[4]), .B(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F4_n49), .S(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F4_n48), .Z(
        Midori_rounds_sub_sBox_PRINCE_1_h[4]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F4_U14 ( .A1(
        Midori_rounds_roundReg_out1[7]), .A2(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F4_n47), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F4_n48) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F4_U13 ( .A(
        Midori_rounds_roundReg_out2[5]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F4_n47) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F4_U12 ( .A(
        Midori_rounds_roundReg_out2[4]), .B(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F4_n46), .S(
        Midori_rounds_roundReg_out2[5]), .Z(
        Midori_rounds_sub_sBox_PRINCE_1_g[4]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F4_U11 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F4_n45), .A2(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F4_n44), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F4_n46) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F4_U10 ( .A1(
        Midori_rounds_roundReg_out2[6]), .A2(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F4_n43), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F4_n45) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F4_U9 ( .A(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F4_n42), .B(
        Midori_rounds_roundReg_out2[5]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_f[2]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F4_U8 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F4_n41), .A2(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F4_n44), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F4_n42) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F4_U7 ( .A1(
        Midori_rounds_roundReg_out2[5]), .A2(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F4_n40), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_e[4]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F4_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F4_n41), .A2(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F4_n39), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F4_n40) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F4_U5 ( .A1(
        Midori_rounds_roundReg_out2[6]), .A2(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F4_n44), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F4_n39) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F4_U4 ( .A1(
        Midori_rounds_roundReg_out2[4]), .A2(Midori_rounds_roundReg_out1[7]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F4_n44) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F4_U3 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F4_n49), .A2(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F4_n43), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F4_n41) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F4_U2 ( .A1(
        Midori_rounds_roundReg_out2[4]), .A2(Midori_rounds_roundReg_out1[7]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F4_n43) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F4_U1 ( .A(
        Midori_rounds_roundReg_out2[6]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F4_n49) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F5_U12 ( .A(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F5_n33), .B(
        Midori_rounds_roundReg_out1[4]), .S(Midori_rounds_roundReg_out1[5]), 
        .Z(Midori_rounds_sub_sBox_PRINCE_1_g[5]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F5_U11 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F5_n32), .A2(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F5_n31), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F5_n33) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F5_U10 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F5_n30), .A2(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F5_n29), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F5_n31) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F5_U9 ( .A(
        Midori_rounds_roundReg_out1[4]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F5_n30) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F5_U8 ( .A(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F5_n28), .B(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F5_n27), .S(
        Midori_rounds_roundReg_out1[4]), .Z(
        Midori_rounds_sub_sBox_PRINCE_1_e[5]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F5_U7 ( .A1(
        Midori_rounds_roundReg_out1[5]), .A2(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F5_n29), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F5_n27) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F5_U6 ( .A1(
        Midori_rounds_roundReg_out2[7]), .A2(Midori_rounds_roundReg_out1[6]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F5_n29) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F5_U5 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F5_n28), .A2(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F5_n26), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_h[5]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F5_U4 ( .A1(
        Midori_rounds_roundReg_out2[7]), .A2(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F5_n25), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F5_n26) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F5_U3 ( .A1(
        Midori_rounds_roundReg_out1[5]), .A2(Midori_rounds_roundReg_out1[4]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F5_n25) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F5_U2 ( .A1(
        Midori_rounds_roundReg_out1[5]), .A2(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F5_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F5_n28) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F5_U1 ( .A1(
        Midori_rounds_roundReg_out2[7]), .A2(Midori_rounds_roundReg_out1[6]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F5_n32) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_U22 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_n62), .A2(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_n61), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_h[6]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_U21 ( .A1(
        Midori_rounds_roundReg_out2[5]), .A2(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_n60), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_n61) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_U20 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_n59), .A2(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_n58), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_n62) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_U19 ( .A(
        Midori_rounds_roundReg_out2[7]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_n58) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_U18 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_n57), .A2(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_n56), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_n59) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_U17 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_n57), .A2(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_n55), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_e[6]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_U16 ( .A(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_n54), .B(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_n53), .S(
        Midori_rounds_roundReg_out2[7]), .Z(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_n55) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_U15 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_n52), .A2(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_n51), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_f[3]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_U14 ( .A1(
        Midori_rounds_roundReg_out2[5]), .A2(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_n50), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_n51) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_U13 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_n49), .A2(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_n48), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_n52) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_U12 ( .A(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_n50), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_n48) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_U11 ( .A1(
        Midori_rounds_roundReg_out2[6]), .A2(Midori_rounds_roundReg_out1[4]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_n50) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_U10 ( .A(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_n47), .B(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_n57), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_n49) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_U9 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_n46), .A2(
        Midori_rounds_roundReg_out2[7]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_n47) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_U8 ( .A1(
        Midori_rounds_roundReg_out2[6]), .A2(Midori_rounds_roundReg_out1[4]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_n46) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_U7 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_n57), .A2(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_n45), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_g[6]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_U6 ( .A(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_n53), .B(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_n54), .S(
        Midori_rounds_roundReg_out2[7]), .Z(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_n45) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_U5 ( .A1(
        Midori_rounds_roundReg_out2[6]), .A2(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_n60), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_n54) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_U4 ( .A(
        Midori_rounds_roundReg_out1[4]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_n60) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_U3 ( .A1(
        Midori_rounds_roundReg_out1[4]), .A2(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_n56), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_n53) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_U2 ( .A(
        Midori_rounds_roundReg_out2[6]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_n56) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_U1 ( .A(
        Midori_rounds_roundReg_out2[5]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F6_n57) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F7_U11 ( .A(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F7_n35), .B(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F7_n34), .S(
        Midori_rounds_roundReg_out1[5]), .Z(
        Midori_rounds_sub_sBox_PRINCE_1_h[7]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F7_U10 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F7_n33), .A2(
        Midori_rounds_roundReg_out2[6]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F7_n34) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F7_U9 ( .A(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F7_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F7_n35) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F7_U8 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F7_n31), .A2(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F7_n30), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_g[7]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F7_U7 ( .A(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F7_n29), .B(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F7_n32), .S(
        Midori_rounds_roundReg_out2[6]), .Z(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F7_n30) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F7_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F7_n31), .A2(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F7_n28), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_e[7]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F7_U5 ( .A(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F7_n32), .B(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F7_n29), .S(
        Midori_rounds_roundReg_out2[6]), .Z(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F7_n28) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F7_U4 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F7_n33), .A2(
        Midori_rounds_roundReg_out2[4]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F7_n29) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F7_U3 ( .A1(
        Midori_rounds_roundReg_out2[4]), .A2(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F7_n33), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F7_n32) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F7_U2 ( .A(
        Midori_rounds_roundReg_out2[7]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F7_n33) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F7_U1 ( .A(
        Midori_rounds_roundReg_out1[5]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F7_n31) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F8_U17 ( .A(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F8_n44), .B(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F8_n43), .S(
        Midori_rounds_roundReg_out2[5]), .Z(
        Midori_rounds_sub_sBox_PRINCE_1_e[8]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F8_U16 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F8_n42), .A2(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F8_n41), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F8_n44) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F8_U15 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F8_n40), .A2(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F8_n39), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_h[8]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F8_U14 ( .A1(
        Midori_rounds_roundReg_out2[5]), .A2(Midori_rounds_roundReg_out1[6]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F8_n39) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F8_U13 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F8_n38), .A2(
        Midori_rounds_roundReg_out2[7]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F8_n40) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F8_U12 ( .A1(
        Midori_rounds_roundReg_out2[5]), .A2(Midori_rounds_roundReg_out2[4]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F8_n38) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F8_U11 ( .A1(
        Midori_rounds_roundReg_out2[5]), .A2(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F8_n37), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_g[8]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F8_U10 ( .A(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F8_n36), .B(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F8_n35), .S(
        Midori_rounds_roundReg_out2[7]), .Z(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F8_n37) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F8_U9 ( .A1(
        Midori_rounds_roundReg_out2[4]), .A2(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F8_n43), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F8_n35) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F8_U8 ( .A(
        Midori_rounds_roundReg_out1[6]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F8_n43) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F8_U7 ( .A1(
        Midori_rounds_roundReg_out1[6]), .A2(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F8_n34), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F8_n36) );
  AND2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F8_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F8_n33), .A2(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F8_n42), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_f[4]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F8_U5 ( .A1(
        Midori_rounds_roundReg_out2[4]), .A2(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F8_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F8_n42) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F8_U4 ( .A1(
        Midori_rounds_roundReg_out2[7]), .A2(Midori_rounds_roundReg_out1[6]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F8_n32) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F8_U3 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F8_n41), .A2(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F8_n34), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F8_n33) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F8_U2 ( .A(
        Midori_rounds_roundReg_out2[4]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F8_n34) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F8_U1 ( .A1(
        Midori_rounds_roundReg_out2[7]), .A2(Midori_rounds_roundReg_out1[6]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_1_Inst_N_F8_n41) );
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_1_InAff_output_reg_s_current_state_reg_0_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_1_e[1]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_1_e_reg[1]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_1_InAff_output_reg_s_current_state_reg_1_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_1_e[2]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_1_e_reg[2]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_1_InAff_output_reg_s_current_state_reg_2_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_1_e[3]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_1_e_reg[3]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_1_InAff_output_reg_s_current_state_reg_3_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_1_e[4]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_1_e_reg[4]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_1_InAff_output_reg_s_current_state_reg_4_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_1_e[5]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_1_e_reg[5]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_1_InAff_output_reg_s_current_state_reg_5_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_1_e[6]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_1_e_reg[6]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_1_InAff_output_reg_s_current_state_reg_6_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_1_e[7]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_1_e_reg[7]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_1_InAff_output_reg_s_current_state_reg_7_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_1_e[8]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_1_e_reg[8]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_1_InAff_output_reg_s_current_state_reg_8_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_1_f[1]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_1_f_reg[1]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_1_InAff_output_reg_s_current_state_reg_9_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_1_f[2]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_1_f_reg[2]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_1_InAff_output_reg_s_current_state_reg_10_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_1_f[3]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_1_f_reg[3]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_1_InAff_output_reg_s_current_state_reg_11_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_1_f[4]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_1_f_reg[4]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_1_InAff_output_reg_s_current_state_reg_12_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_1_g[1]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_1_g_reg[1]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_1_InAff_output_reg_s_current_state_reg_13_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_1_g[2]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_1_g_reg[2]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_1_InAff_output_reg_s_current_state_reg_14_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_1_g[3]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_1_g_reg[3]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_1_InAff_output_reg_s_current_state_reg_15_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_1_g[4]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_1_g_reg[4]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_1_InAff_output_reg_s_current_state_reg_16_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_1_g[5]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_1_g_reg[5]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_1_InAff_output_reg_s_current_state_reg_17_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_1_g[6]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_1_g_reg[6]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_1_InAff_output_reg_s_current_state_reg_18_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_1_g[7]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_1_g_reg[7]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_1_InAff_output_reg_s_current_state_reg_19_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_1_g[8]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_1_g_reg[8]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_1_InAff_output_reg_s_current_state_reg_20_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_1_h[1]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_1_h_reg[1]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_1_InAff_output_reg_s_current_state_reg_21_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_1_h[2]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_1_h_reg[2]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_1_InAff_output_reg_s_current_state_reg_22_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_1_h[3]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_1_h_reg[3]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_1_InAff_output_reg_s_current_state_reg_23_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_1_h[4]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_1_h_reg[4]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_1_InAff_output_reg_s_current_state_reg_24_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_1_h[5]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_1_h_reg[5]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_1_InAff_output_reg_s_current_state_reg_25_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_1_h[6]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_1_h_reg[6]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_1_InAff_output_reg_s_current_state_reg_26_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_1_h[7]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_1_h_reg[7]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_1_InAff_output_reg_s_current_state_reg_27_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_1_h[8]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_1_h_reg[8]) , .QN() ); 
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_L_XORInst1_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_L_XORInst1_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_L_XORInst1_n5), .ZN(output1[4])
         );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_L_XORInst1_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_1_e_reg[2]), .B(
        Midori_rounds_sub_sBox_PRINCE_1_e_reg[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_L_XORInst1_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_L_XORInst1_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_1_e_reg[3]), .B(
        Midori_rounds_sub_sBox_PRINCE_1_e_reg[4]), .Z(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_L_XORInst1_n6) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_L_XORInst2_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_L_XORInst2_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_L_XORInst2_n5), .ZN(
        Midori_rounds_SR_Result2[44]) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_L_XORInst2_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_1_e_reg[6]), .B(
        Midori_rounds_sub_sBox_PRINCE_1_e_reg[5]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_L_XORInst2_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_L_XORInst2_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_1_e_reg[7]), .B(
        Midori_rounds_sub_sBox_PRINCE_1_e_reg[8]), .Z(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_L_XORInst2_n6) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_L_XORInst3_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_1_f_reg[2]), .B(
        Midori_rounds_sub_sBox_PRINCE_1_f_reg[1]), .Z(output1[5]) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_L_XORInst4_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_1_f_reg[4]), .B(
        Midori_rounds_sub_sBox_PRINCE_1_f_reg[3]), .Z(
        Midori_rounds_SR_Result2[45]) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_L_XORInst5_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_L_XORInst5_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_L_XORInst5_n5), .ZN(output1[6])
         );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_L_XORInst5_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_1_g_reg[2]), .B(
        Midori_rounds_sub_sBox_PRINCE_1_g_reg[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_L_XORInst5_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_L_XORInst5_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_1_g_reg[3]), .B(
        Midori_rounds_sub_sBox_PRINCE_1_g_reg[4]), .Z(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_L_XORInst5_n6) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_L_XORInst6_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_L_XORInst6_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_L_XORInst6_n5), .ZN(
        Midori_rounds_SR_Result2[46]) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_L_XORInst6_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_1_g_reg[6]), .B(
        Midori_rounds_sub_sBox_PRINCE_1_g_reg[5]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_L_XORInst6_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_L_XORInst6_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_1_g_reg[7]), .B(
        Midori_rounds_sub_sBox_PRINCE_1_g_reg[8]), .Z(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_L_XORInst6_n6) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_L_XORInst7_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_L_XORInst7_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_L_XORInst7_n5), .ZN(output1[7])
         );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_L_XORInst7_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_1_h_reg[2]), .B(
        Midori_rounds_sub_sBox_PRINCE_1_h_reg[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_L_XORInst7_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_L_XORInst7_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_1_h_reg[3]), .B(
        Midori_rounds_sub_sBox_PRINCE_1_h_reg[4]), .Z(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_L_XORInst7_n6) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_L_XORInst8_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_L_XORInst8_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_L_XORInst8_n5), .ZN(
        Midori_rounds_SR_Result2[47]) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_L_XORInst8_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_1_h_reg[6]), .B(
        Midori_rounds_sub_sBox_PRINCE_1_h_reg[5]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_L_XORInst8_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_1_Inst_L_XORInst8_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_1_h_reg[7]), .B(
        Midori_rounds_sub_sBox_PRINCE_1_h_reg[8]), .Z(
        Midori_rounds_sub_sBox_PRINCE_1_Inst_L_XORInst8_n6) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F1_U17 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F1_n43), .A2(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F1_n42), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_g[1]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F1_U16 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F1_n41), .A2(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F1_n40), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F1_n42) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F1_U15 ( .A1(
        Midori_rounds_roundReg_out2[10]), .A2(Midori_rounds_roundReg_out1[11]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F1_n40) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F1_U14 ( .A(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F1_n39), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F1_n43) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F1_U13 ( .A(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F1_n38), .B(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F1_n37), .S(
        Midori_rounds_roundReg_out1[9]), .Z(
        Midori_rounds_sub_sBox_PRINCE_2_e[1]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F1_U12 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F1_n36), .A2(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F1_n41), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F1_n38) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F1_U11 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F1_n35), .A2(
        Midori_rounds_roundReg_out1[11]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F1_n41) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F1_U10 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F1_n34), .A2(
        Midori_rounds_roundReg_out2[10]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F1_n36) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F1_U9 ( .A1(
        Midori_rounds_roundReg_out1[11]), .A2(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F1_n35), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F1_n34) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F1_U8 ( .A(
        Midori_rounds_roundReg_out1[8]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F1_n35) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F1_U7 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F1_n33), .A2(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F1_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_h[1]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F1_U6 ( .A1(
        Midori_rounds_roundReg_out1[11]), .A2(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F1_n39), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F1_n32) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F1_U5 ( .A1(
        Midori_rounds_roundReg_out1[9]), .A2(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F1_n31), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F1_n39) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F1_U4 ( .A1(
        Midori_rounds_roundReg_out2[10]), .A2(Midori_rounds_roundReg_out1[8]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F1_n31) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F1_U3 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F1_n30), .A2(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F1_n37), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F1_n33) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F1_U2 ( .A(
        Midori_rounds_roundReg_out2[10]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F1_n37) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F1_U1 ( .A1(
        Midori_rounds_roundReg_out1[11]), .A2(Midori_rounds_roundReg_out1[8]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F1_n30) );
  AND2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F2_U12 ( .A1(
        Midori_rounds_roundReg_out2[9]), .A2(
        Midori_rounds_sub_sBox_PRINCE_2_f[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_e[2]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F2_U11 ( .A(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F2_n33), .B(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F2_n32), .S(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F2_n31), .Z(
        Midori_rounds_sub_sBox_PRINCE_2_f[1]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F2_U10 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F2_n30), .A2(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F2_n29), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_g[2]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F2_U9 ( .A(
        Midori_rounds_roundReg_out1[10]), .B(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F2_n28), .S(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F2_n31), .Z(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F2_n29) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F2_U8 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F2_n32), .A2(
        Midori_rounds_roundReg_out2[9]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F2_n30) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F2_U7 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F2_n27), .A2(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F2_n26), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_h[2]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F2_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F2_n33), .A2(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F2_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F2_n26) );
  AND2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F2_U5 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F2_n28), .A2(
        Midori_rounds_roundReg_out1[10]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F2_n32) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F2_U4 ( .A1(
        Midori_rounds_roundReg_out1[10]), .A2(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F2_n28), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F2_n33) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F2_U3 ( .A(
        Midori_rounds_roundReg_out1[8]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F2_n28) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F2_U2 ( .A1(
        Midori_rounds_roundReg_out2[9]), .A2(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F2_n31), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F2_n27) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F2_U1 ( .A(
        Midori_rounds_roundReg_out1[11]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F2_n31) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F3_U13 ( .A1(
        Midori_rounds_roundReg_out1[9]), .A2(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F3_n35), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_g[3]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F3_U12 ( .A(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F3_n34), .B(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F3_n33), .S(
        Midori_rounds_roundReg_out2[8]), .Z(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F3_n35) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F3_U11 ( .A1(
        Midori_rounds_roundReg_out1[11]), .A2(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F3_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F3_n33) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F3_U10 ( .A1(
        Midori_rounds_roundReg_out1[10]), .A2(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F3_n31), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F3_n34) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F3_U9 ( .A(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F3_n30), .B(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F3_n29), .S(
        Midori_rounds_roundReg_out1[10]), .Z(
        Midori_rounds_sub_sBox_PRINCE_2_e[3]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F3_U8 ( .A1(
        Midori_rounds_roundReg_out2[8]), .A2(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F3_n28), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F3_n29) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F3_U7 ( .A1(
        Midori_rounds_roundReg_out1[9]), .A2(Midori_rounds_roundReg_out1[11]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F3_n28) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F3_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F3_n27), .A2(
        Midori_rounds_roundReg_out1[11]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F3_n30) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F3_U5 ( .A1(
        Midori_rounds_roundReg_out1[9]), .A2(Midori_rounds_roundReg_out2[8]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F3_n27) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F3_U4 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F3_n31), .A2(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F3_n26), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_h[3]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F3_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F3_n32), .B(
        Midori_rounds_roundReg_out2[8]), .S(Midori_rounds_roundReg_out1[9]), 
        .Z(Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F3_n26) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F3_U2 ( .A(
        Midori_rounds_roundReg_out1[10]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F3_n32) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F3_U1 ( .A(
        Midori_rounds_roundReg_out1[11]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F3_n31) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F4_U15 ( .A(
        Midori_rounds_roundReg_out2[8]), .B(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F4_n49), .S(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F4_n48), .Z(
        Midori_rounds_sub_sBox_PRINCE_2_h[4]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F4_U14 ( .A1(
        Midori_rounds_roundReg_out1[11]), .A2(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F4_n47), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F4_n48) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F4_U13 ( .A(
        Midori_rounds_roundReg_out2[9]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F4_n47) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F4_U12 ( .A(
        Midori_rounds_roundReg_out2[8]), .B(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F4_n46), .S(
        Midori_rounds_roundReg_out2[9]), .Z(
        Midori_rounds_sub_sBox_PRINCE_2_g[4]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F4_U11 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F4_n45), .A2(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F4_n44), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F4_n46) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F4_U10 ( .A1(
        Midori_rounds_roundReg_out2[10]), .A2(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F4_n43), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F4_n45) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F4_U9 ( .A(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F4_n42), .B(
        Midori_rounds_roundReg_out2[9]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_f[2]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F4_U8 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F4_n41), .A2(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F4_n44), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F4_n42) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F4_U7 ( .A1(
        Midori_rounds_roundReg_out2[9]), .A2(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F4_n40), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_e[4]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F4_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F4_n41), .A2(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F4_n39), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F4_n40) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F4_U5 ( .A1(
        Midori_rounds_roundReg_out2[10]), .A2(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F4_n44), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F4_n39) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F4_U4 ( .A1(
        Midori_rounds_roundReg_out2[8]), .A2(Midori_rounds_roundReg_out1[11]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F4_n44) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F4_U3 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F4_n49), .A2(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F4_n43), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F4_n41) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F4_U2 ( .A1(
        Midori_rounds_roundReg_out2[8]), .A2(Midori_rounds_roundReg_out1[11]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F4_n43) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F4_U1 ( .A(
        Midori_rounds_roundReg_out2[10]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F4_n49) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F5_U12 ( .A(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F5_n33), .B(
        Midori_rounds_roundReg_out1[8]), .S(Midori_rounds_roundReg_out1[9]), 
        .Z(Midori_rounds_sub_sBox_PRINCE_2_g[5]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F5_U11 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F5_n32), .A2(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F5_n31), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F5_n33) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F5_U10 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F5_n30), .A2(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F5_n29), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F5_n31) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F5_U9 ( .A(
        Midori_rounds_roundReg_out1[8]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F5_n30) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F5_U8 ( .A(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F5_n28), .B(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F5_n27), .S(
        Midori_rounds_roundReg_out1[8]), .Z(
        Midori_rounds_sub_sBox_PRINCE_2_e[5]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F5_U7 ( .A1(
        Midori_rounds_roundReg_out1[9]), .A2(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F5_n29), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F5_n27) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F5_U6 ( .A1(
        Midori_rounds_roundReg_out2[11]), .A2(Midori_rounds_roundReg_out1[10]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F5_n29) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F5_U5 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F5_n28), .A2(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F5_n26), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_h[5]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F5_U4 ( .A1(
        Midori_rounds_roundReg_out2[11]), .A2(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F5_n25), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F5_n26) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F5_U3 ( .A1(
        Midori_rounds_roundReg_out1[9]), .A2(Midori_rounds_roundReg_out1[8]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F5_n25) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F5_U2 ( .A1(
        Midori_rounds_roundReg_out1[9]), .A2(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F5_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F5_n28) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F5_U1 ( .A1(
        Midori_rounds_roundReg_out2[11]), .A2(Midori_rounds_roundReg_out1[10]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F5_n32) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_U22 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_n62), .A2(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_n61), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_h[6]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_U21 ( .A1(
        Midori_rounds_roundReg_out2[9]), .A2(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_n60), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_n61) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_U20 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_n59), .A2(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_n58), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_n62) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_U19 ( .A(
        Midori_rounds_roundReg_out2[11]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_n58) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_U18 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_n57), .A2(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_n56), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_n59) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_U17 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_n57), .A2(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_n55), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_e[6]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_U16 ( .A(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_n54), .B(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_n53), .S(
        Midori_rounds_roundReg_out2[11]), .Z(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_n55) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_U15 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_n52), .A2(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_n51), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_f[3]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_U14 ( .A1(
        Midori_rounds_roundReg_out2[9]), .A2(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_n50), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_n51) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_U13 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_n49), .A2(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_n48), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_n52) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_U12 ( .A(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_n50), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_n48) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_U11 ( .A1(
        Midori_rounds_roundReg_out2[10]), .A2(Midori_rounds_roundReg_out1[8]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_n50) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_U10 ( .A(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_n47), .B(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_n57), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_n49) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_U9 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_n46), .A2(
        Midori_rounds_roundReg_out2[11]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_n47) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_U8 ( .A1(
        Midori_rounds_roundReg_out2[10]), .A2(Midori_rounds_roundReg_out1[8]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_n46) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_U7 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_n57), .A2(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_n45), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_g[6]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_U6 ( .A(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_n53), .B(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_n54), .S(
        Midori_rounds_roundReg_out2[11]), .Z(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_n45) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_U5 ( .A1(
        Midori_rounds_roundReg_out2[10]), .A2(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_n60), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_n54) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_U4 ( .A(
        Midori_rounds_roundReg_out1[8]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_n60) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_U3 ( .A1(
        Midori_rounds_roundReg_out1[8]), .A2(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_n56), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_n53) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_U2 ( .A(
        Midori_rounds_roundReg_out2[10]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_n56) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_U1 ( .A(
        Midori_rounds_roundReg_out2[9]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F6_n57) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F7_U11 ( .A(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F7_n35), .B(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F7_n34), .S(
        Midori_rounds_roundReg_out1[9]), .Z(
        Midori_rounds_sub_sBox_PRINCE_2_h[7]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F7_U10 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F7_n33), .A2(
        Midori_rounds_roundReg_out2[10]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F7_n34) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F7_U9 ( .A(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F7_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F7_n35) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F7_U8 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F7_n31), .A2(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F7_n30), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_g[7]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F7_U7 ( .A(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F7_n29), .B(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F7_n32), .S(
        Midori_rounds_roundReg_out2[10]), .Z(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F7_n30) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F7_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F7_n31), .A2(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F7_n28), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_e[7]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F7_U5 ( .A(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F7_n32), .B(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F7_n29), .S(
        Midori_rounds_roundReg_out2[10]), .Z(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F7_n28) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F7_U4 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F7_n33), .A2(
        Midori_rounds_roundReg_out2[8]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F7_n29) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F7_U3 ( .A1(
        Midori_rounds_roundReg_out2[8]), .A2(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F7_n33), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F7_n32) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F7_U2 ( .A(
        Midori_rounds_roundReg_out2[11]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F7_n33) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F7_U1 ( .A(
        Midori_rounds_roundReg_out1[9]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F7_n31) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F8_U17 ( .A(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F8_n44), .B(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F8_n43), .S(
        Midori_rounds_roundReg_out2[9]), .Z(
        Midori_rounds_sub_sBox_PRINCE_2_e[8]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F8_U16 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F8_n42), .A2(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F8_n41), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F8_n44) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F8_U15 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F8_n40), .A2(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F8_n39), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_h[8]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F8_U14 ( .A1(
        Midori_rounds_roundReg_out2[9]), .A2(Midori_rounds_roundReg_out1[10]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F8_n39) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F8_U13 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F8_n38), .A2(
        Midori_rounds_roundReg_out2[11]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F8_n40) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F8_U12 ( .A1(
        Midori_rounds_roundReg_out2[9]), .A2(Midori_rounds_roundReg_out2[8]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F8_n38) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F8_U11 ( .A1(
        Midori_rounds_roundReg_out2[9]), .A2(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F8_n37), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_g[8]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F8_U10 ( .A(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F8_n36), .B(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F8_n35), .S(
        Midori_rounds_roundReg_out2[11]), .Z(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F8_n37) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F8_U9 ( .A1(
        Midori_rounds_roundReg_out2[8]), .A2(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F8_n43), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F8_n35) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F8_U8 ( .A(
        Midori_rounds_roundReg_out1[10]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F8_n43) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F8_U7 ( .A1(
        Midori_rounds_roundReg_out1[10]), .A2(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F8_n34), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F8_n36) );
  AND2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F8_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F8_n33), .A2(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F8_n42), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_f[4]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F8_U5 ( .A1(
        Midori_rounds_roundReg_out2[8]), .A2(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F8_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F8_n42) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F8_U4 ( .A1(
        Midori_rounds_roundReg_out2[11]), .A2(Midori_rounds_roundReg_out1[10]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F8_n32) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F8_U3 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F8_n41), .A2(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F8_n34), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F8_n33) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F8_U2 ( .A(
        Midori_rounds_roundReg_out2[8]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F8_n34) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F8_U1 ( .A1(
        Midori_rounds_roundReg_out2[11]), .A2(Midori_rounds_roundReg_out1[10]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_2_Inst_N_F8_n41) );
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_2_InAff_output_reg_s_current_state_reg_0_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_2_e[1]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_2_e_reg[1]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_2_InAff_output_reg_s_current_state_reg_1_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_2_e[2]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_2_e_reg[2]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_2_InAff_output_reg_s_current_state_reg_2_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_2_e[3]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_2_e_reg[3]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_2_InAff_output_reg_s_current_state_reg_3_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_2_e[4]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_2_e_reg[4]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_2_InAff_output_reg_s_current_state_reg_4_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_2_e[5]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_2_e_reg[5]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_2_InAff_output_reg_s_current_state_reg_5_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_2_e[6]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_2_e_reg[6]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_2_InAff_output_reg_s_current_state_reg_6_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_2_e[7]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_2_e_reg[7]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_2_InAff_output_reg_s_current_state_reg_7_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_2_e[8]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_2_e_reg[8]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_2_InAff_output_reg_s_current_state_reg_8_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_2_f[1]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_2_f_reg[1]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_2_InAff_output_reg_s_current_state_reg_9_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_2_f[2]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_2_f_reg[2]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_2_InAff_output_reg_s_current_state_reg_10_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_2_f[3]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_2_f_reg[3]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_2_InAff_output_reg_s_current_state_reg_11_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_2_f[4]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_2_f_reg[4]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_2_InAff_output_reg_s_current_state_reg_12_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_2_g[1]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_2_g_reg[1]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_2_InAff_output_reg_s_current_state_reg_13_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_2_g[2]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_2_g_reg[2]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_2_InAff_output_reg_s_current_state_reg_14_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_2_g[3]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_2_g_reg[3]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_2_InAff_output_reg_s_current_state_reg_15_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_2_g[4]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_2_g_reg[4]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_2_InAff_output_reg_s_current_state_reg_16_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_2_g[5]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_2_g_reg[5]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_2_InAff_output_reg_s_current_state_reg_17_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_2_g[6]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_2_g_reg[6]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_2_InAff_output_reg_s_current_state_reg_18_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_2_g[7]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_2_g_reg[7]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_2_InAff_output_reg_s_current_state_reg_19_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_2_g[8]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_2_g_reg[8]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_2_InAff_output_reg_s_current_state_reg_20_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_2_h[1]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_2_h_reg[1]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_2_InAff_output_reg_s_current_state_reg_21_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_2_h[2]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_2_h_reg[2]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_2_InAff_output_reg_s_current_state_reg_22_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_2_h[3]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_2_h_reg[3]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_2_InAff_output_reg_s_current_state_reg_23_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_2_h[4]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_2_h_reg[4]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_2_InAff_output_reg_s_current_state_reg_24_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_2_h[5]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_2_h_reg[5]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_2_InAff_output_reg_s_current_state_reg_25_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_2_h[6]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_2_h_reg[6]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_2_InAff_output_reg_s_current_state_reg_26_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_2_h[7]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_2_h_reg[7]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_2_InAff_output_reg_s_current_state_reg_27_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_2_h[8]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_2_h_reg[8]) , .QN() ); 
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_L_XORInst1_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_L_XORInst1_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_L_XORInst1_n5), .ZN(output1[8])
         );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_L_XORInst1_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_2_e_reg[2]), .B(
        Midori_rounds_sub_sBox_PRINCE_2_e_reg[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_L_XORInst1_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_L_XORInst1_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_2_e_reg[3]), .B(
        Midori_rounds_sub_sBox_PRINCE_2_e_reg[4]), .Z(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_L_XORInst1_n6) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_L_XORInst2_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_L_XORInst2_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_L_XORInst2_n5), .ZN(
        Midori_rounds_SR_Result2[8]) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_L_XORInst2_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_2_e_reg[6]), .B(
        Midori_rounds_sub_sBox_PRINCE_2_e_reg[5]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_L_XORInst2_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_L_XORInst2_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_2_e_reg[7]), .B(
        Midori_rounds_sub_sBox_PRINCE_2_e_reg[8]), .Z(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_L_XORInst2_n6) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_L_XORInst3_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_2_f_reg[2]), .B(
        Midori_rounds_sub_sBox_PRINCE_2_f_reg[1]), .Z(output1[9]) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_L_XORInst4_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_2_f_reg[4]), .B(
        Midori_rounds_sub_sBox_PRINCE_2_f_reg[3]), .Z(
        Midori_rounds_SR_Result2[9]) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_L_XORInst5_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_L_XORInst5_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_L_XORInst5_n5), .ZN(output1[10])
         );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_L_XORInst5_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_2_g_reg[2]), .B(
        Midori_rounds_sub_sBox_PRINCE_2_g_reg[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_L_XORInst5_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_L_XORInst5_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_2_g_reg[3]), .B(
        Midori_rounds_sub_sBox_PRINCE_2_g_reg[4]), .Z(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_L_XORInst5_n6) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_L_XORInst6_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_L_XORInst6_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_L_XORInst6_n5), .ZN(
        Midori_rounds_SR_Result2[10]) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_L_XORInst6_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_2_g_reg[6]), .B(
        Midori_rounds_sub_sBox_PRINCE_2_g_reg[5]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_L_XORInst6_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_L_XORInst6_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_2_g_reg[7]), .B(
        Midori_rounds_sub_sBox_PRINCE_2_g_reg[8]), .Z(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_L_XORInst6_n6) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_L_XORInst7_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_L_XORInst7_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_L_XORInst7_n5), .ZN(output1[11])
         );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_L_XORInst7_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_2_h_reg[2]), .B(
        Midori_rounds_sub_sBox_PRINCE_2_h_reg[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_L_XORInst7_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_L_XORInst7_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_2_h_reg[3]), .B(
        Midori_rounds_sub_sBox_PRINCE_2_h_reg[4]), .Z(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_L_XORInst7_n6) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_L_XORInst8_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_L_XORInst8_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_L_XORInst8_n5), .ZN(
        Midori_rounds_SR_Result2[11]) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_L_XORInst8_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_2_h_reg[6]), .B(
        Midori_rounds_sub_sBox_PRINCE_2_h_reg[5]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_L_XORInst8_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_2_Inst_L_XORInst8_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_2_h_reg[7]), .B(
        Midori_rounds_sub_sBox_PRINCE_2_h_reg[8]), .Z(
        Midori_rounds_sub_sBox_PRINCE_2_Inst_L_XORInst8_n6) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F1_U17 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F1_n43), .A2(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F1_n42), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_g[1]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F1_U16 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F1_n41), .A2(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F1_n40), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F1_n42) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F1_U15 ( .A1(
        Midori_rounds_roundReg_out2[14]), .A2(Midori_rounds_roundReg_out1[15]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F1_n40) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F1_U14 ( .A(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F1_n39), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F1_n43) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F1_U13 ( .A(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F1_n38), .B(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F1_n37), .S(
        Midori_rounds_roundReg_out1[13]), .Z(
        Midori_rounds_sub_sBox_PRINCE_3_e[1]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F1_U12 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F1_n36), .A2(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F1_n41), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F1_n38) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F1_U11 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F1_n35), .A2(
        Midori_rounds_roundReg_out1[15]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F1_n41) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F1_U10 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F1_n34), .A2(
        Midori_rounds_roundReg_out2[14]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F1_n36) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F1_U9 ( .A1(
        Midori_rounds_roundReg_out1[15]), .A2(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F1_n35), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F1_n34) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F1_U8 ( .A(
        Midori_rounds_roundReg_out1[12]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F1_n35) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F1_U7 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F1_n33), .A2(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F1_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_h[1]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F1_U6 ( .A1(
        Midori_rounds_roundReg_out1[15]), .A2(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F1_n39), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F1_n32) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F1_U5 ( .A1(
        Midori_rounds_roundReg_out1[13]), .A2(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F1_n31), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F1_n39) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F1_U4 ( .A1(
        Midori_rounds_roundReg_out2[14]), .A2(Midori_rounds_roundReg_out1[12]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F1_n31) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F1_U3 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F1_n30), .A2(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F1_n37), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F1_n33) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F1_U2 ( .A(
        Midori_rounds_roundReg_out2[14]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F1_n37) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F1_U1 ( .A1(
        Midori_rounds_roundReg_out1[15]), .A2(Midori_rounds_roundReg_out1[12]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F1_n30) );
  AND2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F2_U12 ( .A1(
        Midori_rounds_roundReg_out2[13]), .A2(
        Midori_rounds_sub_sBox_PRINCE_3_f[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_e[2]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F2_U11 ( .A(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F2_n33), .B(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F2_n32), .S(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F2_n31), .Z(
        Midori_rounds_sub_sBox_PRINCE_3_f[1]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F2_U10 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F2_n30), .A2(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F2_n29), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_g[2]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F2_U9 ( .A(
        Midori_rounds_roundReg_out1[14]), .B(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F2_n28), .S(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F2_n31), .Z(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F2_n29) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F2_U8 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F2_n32), .A2(
        Midori_rounds_roundReg_out2[13]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F2_n30) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F2_U7 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F2_n27), .A2(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F2_n26), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_h[2]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F2_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F2_n33), .A2(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F2_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F2_n26) );
  AND2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F2_U5 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F2_n28), .A2(
        Midori_rounds_roundReg_out1[14]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F2_n32) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F2_U4 ( .A1(
        Midori_rounds_roundReg_out1[14]), .A2(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F2_n28), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F2_n33) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F2_U3 ( .A(
        Midori_rounds_roundReg_out1[12]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F2_n28) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F2_U2 ( .A1(
        Midori_rounds_roundReg_out2[13]), .A2(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F2_n31), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F2_n27) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F2_U1 ( .A(
        Midori_rounds_roundReg_out1[15]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F2_n31) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F3_U13 ( .A1(
        Midori_rounds_roundReg_out1[13]), .A2(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F3_n35), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_g[3]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F3_U12 ( .A(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F3_n34), .B(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F3_n33), .S(
        Midori_rounds_roundReg_out2[12]), .Z(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F3_n35) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F3_U11 ( .A1(
        Midori_rounds_roundReg_out1[15]), .A2(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F3_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F3_n33) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F3_U10 ( .A1(
        Midori_rounds_roundReg_out1[14]), .A2(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F3_n31), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F3_n34) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F3_U9 ( .A(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F3_n30), .B(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F3_n29), .S(
        Midori_rounds_roundReg_out1[14]), .Z(
        Midori_rounds_sub_sBox_PRINCE_3_e[3]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F3_U8 ( .A1(
        Midori_rounds_roundReg_out2[12]), .A2(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F3_n28), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F3_n29) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F3_U7 ( .A1(
        Midori_rounds_roundReg_out1[13]), .A2(Midori_rounds_roundReg_out1[15]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F3_n28) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F3_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F3_n27), .A2(
        Midori_rounds_roundReg_out1[15]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F3_n30) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F3_U5 ( .A1(
        Midori_rounds_roundReg_out1[13]), .A2(Midori_rounds_roundReg_out2[12]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F3_n27) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F3_U4 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F3_n31), .A2(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F3_n26), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_h[3]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F3_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F3_n32), .B(
        Midori_rounds_roundReg_out2[12]), .S(Midori_rounds_roundReg_out1[13]), 
        .Z(Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F3_n26) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F3_U2 ( .A(
        Midori_rounds_roundReg_out1[14]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F3_n32) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F3_U1 ( .A(
        Midori_rounds_roundReg_out1[15]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F3_n31) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F4_U15 ( .A(
        Midori_rounds_roundReg_out2[12]), .B(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F4_n49), .S(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F4_n48), .Z(
        Midori_rounds_sub_sBox_PRINCE_3_h[4]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F4_U14 ( .A1(
        Midori_rounds_roundReg_out1[15]), .A2(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F4_n47), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F4_n48) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F4_U13 ( .A(
        Midori_rounds_roundReg_out2[13]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F4_n47) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F4_U12 ( .A(
        Midori_rounds_roundReg_out2[12]), .B(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F4_n46), .S(
        Midori_rounds_roundReg_out2[13]), .Z(
        Midori_rounds_sub_sBox_PRINCE_3_g[4]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F4_U11 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F4_n45), .A2(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F4_n44), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F4_n46) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F4_U10 ( .A1(
        Midori_rounds_roundReg_out2[14]), .A2(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F4_n43), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F4_n45) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F4_U9 ( .A(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F4_n42), .B(
        Midori_rounds_roundReg_out2[13]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_f[2]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F4_U8 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F4_n41), .A2(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F4_n44), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F4_n42) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F4_U7 ( .A1(
        Midori_rounds_roundReg_out2[13]), .A2(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F4_n40), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_e[4]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F4_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F4_n41), .A2(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F4_n39), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F4_n40) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F4_U5 ( .A1(
        Midori_rounds_roundReg_out2[14]), .A2(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F4_n44), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F4_n39) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F4_U4 ( .A1(
        Midori_rounds_roundReg_out2[12]), .A2(Midori_rounds_roundReg_out1[15]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F4_n44) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F4_U3 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F4_n49), .A2(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F4_n43), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F4_n41) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F4_U2 ( .A1(
        Midori_rounds_roundReg_out2[12]), .A2(Midori_rounds_roundReg_out1[15]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F4_n43) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F4_U1 ( .A(
        Midori_rounds_roundReg_out2[14]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F4_n49) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F5_U12 ( .A(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F5_n33), .B(
        Midori_rounds_roundReg_out1[12]), .S(Midori_rounds_roundReg_out1[13]), 
        .Z(Midori_rounds_sub_sBox_PRINCE_3_g[5]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F5_U11 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F5_n32), .A2(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F5_n31), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F5_n33) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F5_U10 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F5_n30), .A2(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F5_n29), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F5_n31) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F5_U9 ( .A(
        Midori_rounds_roundReg_out1[12]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F5_n30) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F5_U8 ( .A(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F5_n28), .B(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F5_n27), .S(
        Midori_rounds_roundReg_out1[12]), .Z(
        Midori_rounds_sub_sBox_PRINCE_3_e[5]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F5_U7 ( .A1(
        Midori_rounds_roundReg_out1[13]), .A2(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F5_n29), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F5_n27) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F5_U6 ( .A1(
        Midori_rounds_roundReg_out2[15]), .A2(Midori_rounds_roundReg_out1[14]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F5_n29) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F5_U5 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F5_n28), .A2(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F5_n26), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_h[5]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F5_U4 ( .A1(
        Midori_rounds_roundReg_out2[15]), .A2(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F5_n25), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F5_n26) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F5_U3 ( .A1(
        Midori_rounds_roundReg_out1[13]), .A2(Midori_rounds_roundReg_out1[12]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F5_n25) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F5_U2 ( .A1(
        Midori_rounds_roundReg_out1[13]), .A2(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F5_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F5_n28) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F5_U1 ( .A1(
        Midori_rounds_roundReg_out2[15]), .A2(Midori_rounds_roundReg_out1[14]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F5_n32) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_U22 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_n62), .A2(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_n61), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_h[6]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_U21 ( .A1(
        Midori_rounds_roundReg_out2[13]), .A2(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_n60), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_n61) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_U20 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_n59), .A2(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_n58), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_n62) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_U19 ( .A(
        Midori_rounds_roundReg_out2[15]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_n58) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_U18 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_n57), .A2(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_n56), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_n59) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_U17 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_n57), .A2(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_n55), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_e[6]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_U16 ( .A(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_n54), .B(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_n53), .S(
        Midori_rounds_roundReg_out2[15]), .Z(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_n55) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_U15 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_n52), .A2(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_n51), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_f[3]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_U14 ( .A1(
        Midori_rounds_roundReg_out2[13]), .A2(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_n50), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_n51) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_U13 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_n49), .A2(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_n48), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_n52) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_U12 ( .A(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_n50), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_n48) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_U11 ( .A1(
        Midori_rounds_roundReg_out2[14]), .A2(Midori_rounds_roundReg_out1[12]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_n50) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_U10 ( .A(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_n47), .B(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_n57), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_n49) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_U9 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_n46), .A2(
        Midori_rounds_roundReg_out2[15]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_n47) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_U8 ( .A1(
        Midori_rounds_roundReg_out2[14]), .A2(Midori_rounds_roundReg_out1[12]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_n46) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_U7 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_n57), .A2(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_n45), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_g[6]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_U6 ( .A(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_n53), .B(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_n54), .S(
        Midori_rounds_roundReg_out2[15]), .Z(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_n45) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_U5 ( .A1(
        Midori_rounds_roundReg_out2[14]), .A2(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_n60), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_n54) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_U4 ( .A(
        Midori_rounds_roundReg_out1[12]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_n60) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_U3 ( .A1(
        Midori_rounds_roundReg_out1[12]), .A2(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_n56), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_n53) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_U2 ( .A(
        Midori_rounds_roundReg_out2[14]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_n56) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_U1 ( .A(
        Midori_rounds_roundReg_out2[13]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F6_n57) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F7_U11 ( .A(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F7_n35), .B(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F7_n34), .S(
        Midori_rounds_roundReg_out1[13]), .Z(
        Midori_rounds_sub_sBox_PRINCE_3_h[7]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F7_U10 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F7_n33), .A2(
        Midori_rounds_roundReg_out2[14]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F7_n34) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F7_U9 ( .A(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F7_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F7_n35) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F7_U8 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F7_n31), .A2(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F7_n30), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_g[7]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F7_U7 ( .A(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F7_n29), .B(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F7_n32), .S(
        Midori_rounds_roundReg_out2[14]), .Z(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F7_n30) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F7_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F7_n31), .A2(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F7_n28), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_e[7]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F7_U5 ( .A(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F7_n32), .B(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F7_n29), .S(
        Midori_rounds_roundReg_out2[14]), .Z(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F7_n28) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F7_U4 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F7_n33), .A2(
        Midori_rounds_roundReg_out2[12]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F7_n29) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F7_U3 ( .A1(
        Midori_rounds_roundReg_out2[12]), .A2(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F7_n33), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F7_n32) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F7_U2 ( .A(
        Midori_rounds_roundReg_out2[15]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F7_n33) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F7_U1 ( .A(
        Midori_rounds_roundReg_out1[13]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F7_n31) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F8_U17 ( .A(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F8_n44), .B(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F8_n43), .S(
        Midori_rounds_roundReg_out2[13]), .Z(
        Midori_rounds_sub_sBox_PRINCE_3_e[8]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F8_U16 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F8_n42), .A2(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F8_n41), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F8_n44) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F8_U15 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F8_n40), .A2(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F8_n39), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_h[8]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F8_U14 ( .A1(
        Midori_rounds_roundReg_out2[13]), .A2(Midori_rounds_roundReg_out1[14]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F8_n39) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F8_U13 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F8_n38), .A2(
        Midori_rounds_roundReg_out2[15]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F8_n40) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F8_U12 ( .A1(
        Midori_rounds_roundReg_out2[13]), .A2(Midori_rounds_roundReg_out2[12]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F8_n38) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F8_U11 ( .A1(
        Midori_rounds_roundReg_out2[13]), .A2(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F8_n37), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_g[8]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F8_U10 ( .A(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F8_n36), .B(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F8_n35), .S(
        Midori_rounds_roundReg_out2[15]), .Z(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F8_n37) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F8_U9 ( .A1(
        Midori_rounds_roundReg_out2[12]), .A2(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F8_n43), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F8_n35) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F8_U8 ( .A(
        Midori_rounds_roundReg_out1[14]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F8_n43) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F8_U7 ( .A1(
        Midori_rounds_roundReg_out1[14]), .A2(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F8_n34), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F8_n36) );
  AND2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F8_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F8_n33), .A2(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F8_n42), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_f[4]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F8_U5 ( .A1(
        Midori_rounds_roundReg_out2[12]), .A2(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F8_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F8_n42) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F8_U4 ( .A1(
        Midori_rounds_roundReg_out2[15]), .A2(Midori_rounds_roundReg_out1[14]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F8_n32) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F8_U3 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F8_n41), .A2(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F8_n34), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F8_n33) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F8_U2 ( .A(
        Midori_rounds_roundReg_out2[12]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F8_n34) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F8_U1 ( .A1(
        Midori_rounds_roundReg_out2[15]), .A2(Midori_rounds_roundReg_out1[14]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_3_Inst_N_F8_n41) );
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_3_InAff_output_reg_s_current_state_reg_0_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_3_e[1]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_3_e_reg[1]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_3_InAff_output_reg_s_current_state_reg_1_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_3_e[2]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_3_e_reg[2]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_3_InAff_output_reg_s_current_state_reg_2_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_3_e[3]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_3_e_reg[3]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_3_InAff_output_reg_s_current_state_reg_3_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_3_e[4]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_3_e_reg[4]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_3_InAff_output_reg_s_current_state_reg_4_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_3_e[5]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_3_e_reg[5]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_3_InAff_output_reg_s_current_state_reg_5_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_3_e[6]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_3_e_reg[6]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_3_InAff_output_reg_s_current_state_reg_6_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_3_e[7]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_3_e_reg[7]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_3_InAff_output_reg_s_current_state_reg_7_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_3_e[8]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_3_e_reg[8]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_3_InAff_output_reg_s_current_state_reg_8_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_3_f[1]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_3_f_reg[1]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_3_InAff_output_reg_s_current_state_reg_9_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_3_f[2]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_3_f_reg[2]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_3_InAff_output_reg_s_current_state_reg_10_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_3_f[3]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_3_f_reg[3]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_3_InAff_output_reg_s_current_state_reg_11_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_3_f[4]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_3_f_reg[4]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_3_InAff_output_reg_s_current_state_reg_12_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_3_g[1]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_3_g_reg[1]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_3_InAff_output_reg_s_current_state_reg_13_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_3_g[2]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_3_g_reg[2]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_3_InAff_output_reg_s_current_state_reg_14_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_3_g[3]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_3_g_reg[3]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_3_InAff_output_reg_s_current_state_reg_15_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_3_g[4]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_3_g_reg[4]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_3_InAff_output_reg_s_current_state_reg_16_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_3_g[5]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_3_g_reg[5]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_3_InAff_output_reg_s_current_state_reg_17_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_3_g[6]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_3_g_reg[6]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_3_InAff_output_reg_s_current_state_reg_18_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_3_g[7]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_3_g_reg[7]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_3_InAff_output_reg_s_current_state_reg_19_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_3_g[8]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_3_g_reg[8]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_3_InAff_output_reg_s_current_state_reg_20_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_3_h[1]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_3_h_reg[1]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_3_InAff_output_reg_s_current_state_reg_21_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_3_h[2]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_3_h_reg[2]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_3_InAff_output_reg_s_current_state_reg_22_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_3_h[3]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_3_h_reg[3]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_3_InAff_output_reg_s_current_state_reg_23_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_3_h[4]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_3_h_reg[4]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_3_InAff_output_reg_s_current_state_reg_24_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_3_h[5]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_3_h_reg[5]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_3_InAff_output_reg_s_current_state_reg_25_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_3_h[6]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_3_h_reg[6]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_3_InAff_output_reg_s_current_state_reg_26_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_3_h[7]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_3_h_reg[7]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_3_InAff_output_reg_s_current_state_reg_27_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_3_h[8]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_3_h_reg[8]) , .QN() ); 
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_L_XORInst1_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_L_XORInst1_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_L_XORInst1_n5), .ZN(output1[12])
         );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_L_XORInst1_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_3_e_reg[2]), .B(
        Midori_rounds_sub_sBox_PRINCE_3_e_reg[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_L_XORInst1_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_L_XORInst1_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_3_e_reg[3]), .B(
        Midori_rounds_sub_sBox_PRINCE_3_e_reg[4]), .Z(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_L_XORInst1_n6) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_L_XORInst2_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_L_XORInst2_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_L_XORInst2_n5), .ZN(
        Midori_rounds_SR_Result2[20]) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_L_XORInst2_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_3_e_reg[6]), .B(
        Midori_rounds_sub_sBox_PRINCE_3_e_reg[5]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_L_XORInst2_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_L_XORInst2_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_3_e_reg[7]), .B(
        Midori_rounds_sub_sBox_PRINCE_3_e_reg[8]), .Z(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_L_XORInst2_n6) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_L_XORInst3_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_3_f_reg[2]), .B(
        Midori_rounds_sub_sBox_PRINCE_3_f_reg[1]), .Z(output1[13]) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_L_XORInst4_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_3_f_reg[4]), .B(
        Midori_rounds_sub_sBox_PRINCE_3_f_reg[3]), .Z(
        Midori_rounds_SR_Result2[21]) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_L_XORInst5_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_L_XORInst5_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_L_XORInst5_n5), .ZN(output1[14])
         );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_L_XORInst5_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_3_g_reg[2]), .B(
        Midori_rounds_sub_sBox_PRINCE_3_g_reg[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_L_XORInst5_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_L_XORInst5_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_3_g_reg[3]), .B(
        Midori_rounds_sub_sBox_PRINCE_3_g_reg[4]), .Z(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_L_XORInst5_n6) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_L_XORInst6_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_L_XORInst6_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_L_XORInst6_n5), .ZN(
        Midori_rounds_SR_Result2[22]) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_L_XORInst6_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_3_g_reg[6]), .B(
        Midori_rounds_sub_sBox_PRINCE_3_g_reg[5]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_L_XORInst6_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_L_XORInst6_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_3_g_reg[7]), .B(
        Midori_rounds_sub_sBox_PRINCE_3_g_reg[8]), .Z(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_L_XORInst6_n6) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_L_XORInst7_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_L_XORInst7_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_L_XORInst7_n5), .ZN(output1[15])
         );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_L_XORInst7_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_3_h_reg[2]), .B(
        Midori_rounds_sub_sBox_PRINCE_3_h_reg[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_L_XORInst7_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_L_XORInst7_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_3_h_reg[3]), .B(
        Midori_rounds_sub_sBox_PRINCE_3_h_reg[4]), .Z(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_L_XORInst7_n6) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_L_XORInst8_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_L_XORInst8_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_L_XORInst8_n5), .ZN(
        Midori_rounds_SR_Result2[23]) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_L_XORInst8_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_3_h_reg[6]), .B(
        Midori_rounds_sub_sBox_PRINCE_3_h_reg[5]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_L_XORInst8_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_3_Inst_L_XORInst8_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_3_h_reg[7]), .B(
        Midori_rounds_sub_sBox_PRINCE_3_h_reg[8]), .Z(
        Midori_rounds_sub_sBox_PRINCE_3_Inst_L_XORInst8_n6) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F1_U17 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F1_n43), .A2(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F1_n42), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_g[1]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F1_U16 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F1_n41), .A2(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F1_n40), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F1_n42) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F1_U15 ( .A1(
        Midori_rounds_roundReg_out2[18]), .A2(Midori_rounds_roundReg_out1[19]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F1_n40) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F1_U14 ( .A(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F1_n39), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F1_n43) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F1_U13 ( .A(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F1_n38), .B(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F1_n37), .S(
        Midori_rounds_roundReg_out1[17]), .Z(
        Midori_rounds_sub_sBox_PRINCE_4_e[1]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F1_U12 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F1_n36), .A2(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F1_n41), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F1_n38) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F1_U11 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F1_n35), .A2(
        Midori_rounds_roundReg_out1[19]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F1_n41) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F1_U10 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F1_n34), .A2(
        Midori_rounds_roundReg_out2[18]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F1_n36) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F1_U9 ( .A1(
        Midori_rounds_roundReg_out1[19]), .A2(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F1_n35), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F1_n34) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F1_U8 ( .A(
        Midori_rounds_roundReg_out1[16]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F1_n35) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F1_U7 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F1_n33), .A2(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F1_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_h[1]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F1_U6 ( .A1(
        Midori_rounds_roundReg_out1[19]), .A2(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F1_n39), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F1_n32) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F1_U5 ( .A1(
        Midori_rounds_roundReg_out1[17]), .A2(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F1_n31), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F1_n39) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F1_U4 ( .A1(
        Midori_rounds_roundReg_out2[18]), .A2(Midori_rounds_roundReg_out1[16]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F1_n31) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F1_U3 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F1_n30), .A2(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F1_n37), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F1_n33) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F1_U2 ( .A(
        Midori_rounds_roundReg_out2[18]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F1_n37) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F1_U1 ( .A1(
        Midori_rounds_roundReg_out1[19]), .A2(Midori_rounds_roundReg_out1[16]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F1_n30) );
  AND2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F2_U12 ( .A1(
        Midori_rounds_roundReg_out2[17]), .A2(
        Midori_rounds_sub_sBox_PRINCE_4_f[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_e[2]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F2_U11 ( .A(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F2_n33), .B(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F2_n32), .S(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F2_n31), .Z(
        Midori_rounds_sub_sBox_PRINCE_4_f[1]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F2_U10 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F2_n30), .A2(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F2_n29), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_g[2]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F2_U9 ( .A(
        Midori_rounds_roundReg_out1[18]), .B(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F2_n28), .S(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F2_n31), .Z(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F2_n29) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F2_U8 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F2_n32), .A2(
        Midori_rounds_roundReg_out2[17]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F2_n30) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F2_U7 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F2_n27), .A2(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F2_n26), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_h[2]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F2_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F2_n33), .A2(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F2_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F2_n26) );
  AND2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F2_U5 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F2_n28), .A2(
        Midori_rounds_roundReg_out1[18]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F2_n32) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F2_U4 ( .A1(
        Midori_rounds_roundReg_out1[18]), .A2(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F2_n28), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F2_n33) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F2_U3 ( .A(
        Midori_rounds_roundReg_out1[16]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F2_n28) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F2_U2 ( .A1(
        Midori_rounds_roundReg_out2[17]), .A2(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F2_n31), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F2_n27) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F2_U1 ( .A(
        Midori_rounds_roundReg_out1[19]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F2_n31) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F3_U13 ( .A1(
        Midori_rounds_roundReg_out1[17]), .A2(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F3_n35), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_g[3]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F3_U12 ( .A(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F3_n34), .B(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F3_n33), .S(
        Midori_rounds_roundReg_out2[16]), .Z(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F3_n35) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F3_U11 ( .A1(
        Midori_rounds_roundReg_out1[19]), .A2(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F3_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F3_n33) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F3_U10 ( .A1(
        Midori_rounds_roundReg_out1[18]), .A2(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F3_n31), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F3_n34) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F3_U9 ( .A(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F3_n30), .B(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F3_n29), .S(
        Midori_rounds_roundReg_out1[18]), .Z(
        Midori_rounds_sub_sBox_PRINCE_4_e[3]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F3_U8 ( .A1(
        Midori_rounds_roundReg_out2[16]), .A2(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F3_n28), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F3_n29) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F3_U7 ( .A1(
        Midori_rounds_roundReg_out1[17]), .A2(Midori_rounds_roundReg_out1[19]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F3_n28) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F3_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F3_n27), .A2(
        Midori_rounds_roundReg_out1[19]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F3_n30) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F3_U5 ( .A1(
        Midori_rounds_roundReg_out1[17]), .A2(Midori_rounds_roundReg_out2[16]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F3_n27) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F3_U4 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F3_n31), .A2(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F3_n26), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_h[3]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F3_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F3_n32), .B(
        Midori_rounds_roundReg_out2[16]), .S(Midori_rounds_roundReg_out1[17]), 
        .Z(Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F3_n26) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F3_U2 ( .A(
        Midori_rounds_roundReg_out1[18]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F3_n32) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F3_U1 ( .A(
        Midori_rounds_roundReg_out1[19]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F3_n31) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F4_U15 ( .A(
        Midori_rounds_roundReg_out2[16]), .B(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F4_n49), .S(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F4_n48), .Z(
        Midori_rounds_sub_sBox_PRINCE_4_h[4]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F4_U14 ( .A1(
        Midori_rounds_roundReg_out1[19]), .A2(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F4_n47), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F4_n48) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F4_U13 ( .A(
        Midori_rounds_roundReg_out2[17]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F4_n47) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F4_U12 ( .A(
        Midori_rounds_roundReg_out2[16]), .B(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F4_n46), .S(
        Midori_rounds_roundReg_out2[17]), .Z(
        Midori_rounds_sub_sBox_PRINCE_4_g[4]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F4_U11 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F4_n45), .A2(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F4_n44), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F4_n46) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F4_U10 ( .A1(
        Midori_rounds_roundReg_out2[18]), .A2(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F4_n43), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F4_n45) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F4_U9 ( .A(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F4_n42), .B(
        Midori_rounds_roundReg_out2[17]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_f[2]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F4_U8 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F4_n41), .A2(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F4_n44), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F4_n42) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F4_U7 ( .A1(
        Midori_rounds_roundReg_out2[17]), .A2(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F4_n40), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_e[4]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F4_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F4_n41), .A2(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F4_n39), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F4_n40) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F4_U5 ( .A1(
        Midori_rounds_roundReg_out2[18]), .A2(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F4_n44), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F4_n39) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F4_U4 ( .A1(
        Midori_rounds_roundReg_out2[16]), .A2(Midori_rounds_roundReg_out1[19]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F4_n44) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F4_U3 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F4_n49), .A2(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F4_n43), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F4_n41) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F4_U2 ( .A1(
        Midori_rounds_roundReg_out2[16]), .A2(Midori_rounds_roundReg_out1[19]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F4_n43) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F4_U1 ( .A(
        Midori_rounds_roundReg_out2[18]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F4_n49) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F5_U12 ( .A(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F5_n33), .B(
        Midori_rounds_roundReg_out1[16]), .S(Midori_rounds_roundReg_out1[17]), 
        .Z(Midori_rounds_sub_sBox_PRINCE_4_g[5]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F5_U11 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F5_n32), .A2(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F5_n31), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F5_n33) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F5_U10 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F5_n30), .A2(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F5_n29), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F5_n31) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F5_U9 ( .A(
        Midori_rounds_roundReg_out1[16]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F5_n30) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F5_U8 ( .A(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F5_n28), .B(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F5_n27), .S(
        Midori_rounds_roundReg_out1[16]), .Z(
        Midori_rounds_sub_sBox_PRINCE_4_e[5]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F5_U7 ( .A1(
        Midori_rounds_roundReg_out1[17]), .A2(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F5_n29), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F5_n27) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F5_U6 ( .A1(
        Midori_rounds_roundReg_out2[19]), .A2(Midori_rounds_roundReg_out1[18]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F5_n29) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F5_U5 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F5_n28), .A2(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F5_n26), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_h[5]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F5_U4 ( .A1(
        Midori_rounds_roundReg_out2[19]), .A2(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F5_n25), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F5_n26) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F5_U3 ( .A1(
        Midori_rounds_roundReg_out1[17]), .A2(Midori_rounds_roundReg_out1[16]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F5_n25) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F5_U2 ( .A1(
        Midori_rounds_roundReg_out1[17]), .A2(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F5_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F5_n28) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F5_U1 ( .A1(
        Midori_rounds_roundReg_out2[19]), .A2(Midori_rounds_roundReg_out1[18]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F5_n32) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_U22 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_n62), .A2(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_n61), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_h[6]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_U21 ( .A1(
        Midori_rounds_roundReg_out2[17]), .A2(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_n60), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_n61) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_U20 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_n59), .A2(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_n58), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_n62) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_U19 ( .A(
        Midori_rounds_roundReg_out2[19]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_n58) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_U18 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_n57), .A2(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_n56), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_n59) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_U17 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_n57), .A2(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_n55), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_e[6]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_U16 ( .A(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_n54), .B(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_n53), .S(
        Midori_rounds_roundReg_out2[19]), .Z(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_n55) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_U15 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_n52), .A2(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_n51), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_f[3]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_U14 ( .A1(
        Midori_rounds_roundReg_out2[17]), .A2(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_n50), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_n51) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_U13 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_n49), .A2(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_n48), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_n52) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_U12 ( .A(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_n50), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_n48) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_U11 ( .A1(
        Midori_rounds_roundReg_out2[18]), .A2(Midori_rounds_roundReg_out1[16]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_n50) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_U10 ( .A(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_n47), .B(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_n57), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_n49) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_U9 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_n46), .A2(
        Midori_rounds_roundReg_out2[19]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_n47) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_U8 ( .A1(
        Midori_rounds_roundReg_out2[18]), .A2(Midori_rounds_roundReg_out1[16]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_n46) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_U7 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_n57), .A2(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_n45), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_g[6]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_U6 ( .A(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_n53), .B(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_n54), .S(
        Midori_rounds_roundReg_out2[19]), .Z(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_n45) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_U5 ( .A1(
        Midori_rounds_roundReg_out2[18]), .A2(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_n60), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_n54) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_U4 ( .A(
        Midori_rounds_roundReg_out1[16]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_n60) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_U3 ( .A1(
        Midori_rounds_roundReg_out1[16]), .A2(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_n56), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_n53) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_U2 ( .A(
        Midori_rounds_roundReg_out2[18]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_n56) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_U1 ( .A(
        Midori_rounds_roundReg_out2[17]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F6_n57) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F7_U11 ( .A(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F7_n35), .B(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F7_n34), .S(
        Midori_rounds_roundReg_out1[17]), .Z(
        Midori_rounds_sub_sBox_PRINCE_4_h[7]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F7_U10 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F7_n33), .A2(
        Midori_rounds_roundReg_out2[18]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F7_n34) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F7_U9 ( .A(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F7_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F7_n35) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F7_U8 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F7_n31), .A2(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F7_n30), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_g[7]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F7_U7 ( .A(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F7_n29), .B(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F7_n32), .S(
        Midori_rounds_roundReg_out2[18]), .Z(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F7_n30) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F7_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F7_n31), .A2(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F7_n28), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_e[7]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F7_U5 ( .A(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F7_n32), .B(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F7_n29), .S(
        Midori_rounds_roundReg_out2[18]), .Z(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F7_n28) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F7_U4 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F7_n33), .A2(
        Midori_rounds_roundReg_out2[16]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F7_n29) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F7_U3 ( .A1(
        Midori_rounds_roundReg_out2[16]), .A2(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F7_n33), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F7_n32) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F7_U2 ( .A(
        Midori_rounds_roundReg_out2[19]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F7_n33) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F7_U1 ( .A(
        Midori_rounds_roundReg_out1[17]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F7_n31) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F8_U17 ( .A(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F8_n44), .B(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F8_n43), .S(
        Midori_rounds_roundReg_out2[17]), .Z(
        Midori_rounds_sub_sBox_PRINCE_4_e[8]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F8_U16 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F8_n42), .A2(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F8_n41), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F8_n44) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F8_U15 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F8_n40), .A2(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F8_n39), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_h[8]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F8_U14 ( .A1(
        Midori_rounds_roundReg_out2[17]), .A2(Midori_rounds_roundReg_out1[18]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F8_n39) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F8_U13 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F8_n38), .A2(
        Midori_rounds_roundReg_out2[19]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F8_n40) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F8_U12 ( .A1(
        Midori_rounds_roundReg_out2[17]), .A2(Midori_rounds_roundReg_out2[16]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F8_n38) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F8_U11 ( .A1(
        Midori_rounds_roundReg_out2[17]), .A2(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F8_n37), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_g[8]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F8_U10 ( .A(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F8_n36), .B(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F8_n35), .S(
        Midori_rounds_roundReg_out2[19]), .Z(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F8_n37) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F8_U9 ( .A1(
        Midori_rounds_roundReg_out2[16]), .A2(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F8_n43), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F8_n35) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F8_U8 ( .A(
        Midori_rounds_roundReg_out1[18]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F8_n43) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F8_U7 ( .A1(
        Midori_rounds_roundReg_out1[18]), .A2(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F8_n34), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F8_n36) );
  AND2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F8_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F8_n33), .A2(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F8_n42), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_f[4]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F8_U5 ( .A1(
        Midori_rounds_roundReg_out2[16]), .A2(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F8_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F8_n42) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F8_U4 ( .A1(
        Midori_rounds_roundReg_out2[19]), .A2(Midori_rounds_roundReg_out1[18]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F8_n32) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F8_U3 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F8_n41), .A2(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F8_n34), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F8_n33) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F8_U2 ( .A(
        Midori_rounds_roundReg_out2[16]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F8_n34) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F8_U1 ( .A1(
        Midori_rounds_roundReg_out2[19]), .A2(Midori_rounds_roundReg_out1[18]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_4_Inst_N_F8_n41) );
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_4_InAff_output_reg_s_current_state_reg_0_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_4_e[1]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_4_e_reg[1]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_4_InAff_output_reg_s_current_state_reg_1_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_4_e[2]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_4_e_reg[2]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_4_InAff_output_reg_s_current_state_reg_2_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_4_e[3]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_4_e_reg[3]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_4_InAff_output_reg_s_current_state_reg_3_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_4_e[4]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_4_e_reg[4]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_4_InAff_output_reg_s_current_state_reg_4_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_4_e[5]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_4_e_reg[5]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_4_InAff_output_reg_s_current_state_reg_5_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_4_e[6]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_4_e_reg[6]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_4_InAff_output_reg_s_current_state_reg_6_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_4_e[7]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_4_e_reg[7]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_4_InAff_output_reg_s_current_state_reg_7_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_4_e[8]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_4_e_reg[8]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_4_InAff_output_reg_s_current_state_reg_8_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_4_f[1]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_4_f_reg[1]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_4_InAff_output_reg_s_current_state_reg_9_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_4_f[2]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_4_f_reg[2]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_4_InAff_output_reg_s_current_state_reg_10_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_4_f[3]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_4_f_reg[3]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_4_InAff_output_reg_s_current_state_reg_11_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_4_f[4]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_4_f_reg[4]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_4_InAff_output_reg_s_current_state_reg_12_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_4_g[1]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_4_g_reg[1]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_4_InAff_output_reg_s_current_state_reg_13_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_4_g[2]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_4_g_reg[2]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_4_InAff_output_reg_s_current_state_reg_14_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_4_g[3]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_4_g_reg[3]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_4_InAff_output_reg_s_current_state_reg_15_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_4_g[4]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_4_g_reg[4]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_4_InAff_output_reg_s_current_state_reg_16_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_4_g[5]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_4_g_reg[5]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_4_InAff_output_reg_s_current_state_reg_17_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_4_g[6]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_4_g_reg[6]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_4_InAff_output_reg_s_current_state_reg_18_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_4_g[7]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_4_g_reg[7]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_4_InAff_output_reg_s_current_state_reg_19_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_4_g[8]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_4_g_reg[8]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_4_InAff_output_reg_s_current_state_reg_20_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_4_h[1]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_4_h_reg[1]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_4_InAff_output_reg_s_current_state_reg_21_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_4_h[2]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_4_h_reg[2]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_4_InAff_output_reg_s_current_state_reg_22_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_4_h[3]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_4_h_reg[3]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_4_InAff_output_reg_s_current_state_reg_23_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_4_h[4]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_4_h_reg[4]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_4_InAff_output_reg_s_current_state_reg_24_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_4_h[5]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_4_h_reg[5]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_4_InAff_output_reg_s_current_state_reg_25_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_4_h[6]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_4_h_reg[6]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_4_InAff_output_reg_s_current_state_reg_26_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_4_h[7]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_4_h_reg[7]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_4_InAff_output_reg_s_current_state_reg_27_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_4_h[8]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_4_h_reg[8]) , .QN() ); 
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_L_XORInst1_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_L_XORInst1_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_L_XORInst1_n5), .ZN(output1[16])
         );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_L_XORInst1_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_4_e_reg[2]), .B(
        Midori_rounds_sub_sBox_PRINCE_4_e_reg[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_L_XORInst1_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_L_XORInst1_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_4_e_reg[3]), .B(
        Midori_rounds_sub_sBox_PRINCE_4_e_reg[4]), .Z(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_L_XORInst1_n6) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_L_XORInst2_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_L_XORInst2_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_L_XORInst2_n5), .ZN(
        Midori_rounds_SR_Result2[36]) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_L_XORInst2_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_4_e_reg[6]), .B(
        Midori_rounds_sub_sBox_PRINCE_4_e_reg[5]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_L_XORInst2_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_L_XORInst2_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_4_e_reg[7]), .B(
        Midori_rounds_sub_sBox_PRINCE_4_e_reg[8]), .Z(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_L_XORInst2_n6) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_L_XORInst3_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_4_f_reg[2]), .B(
        Midori_rounds_sub_sBox_PRINCE_4_f_reg[1]), .Z(output1[17]) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_L_XORInst4_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_4_f_reg[4]), .B(
        Midori_rounds_sub_sBox_PRINCE_4_f_reg[3]), .Z(
        Midori_rounds_SR_Result2[37]) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_L_XORInst5_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_L_XORInst5_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_L_XORInst5_n5), .ZN(output1[18])
         );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_L_XORInst5_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_4_g_reg[2]), .B(
        Midori_rounds_sub_sBox_PRINCE_4_g_reg[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_L_XORInst5_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_L_XORInst5_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_4_g_reg[3]), .B(
        Midori_rounds_sub_sBox_PRINCE_4_g_reg[4]), .Z(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_L_XORInst5_n6) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_L_XORInst6_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_L_XORInst6_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_L_XORInst6_n5), .ZN(
        Midori_rounds_SR_Result2[38]) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_L_XORInst6_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_4_g_reg[6]), .B(
        Midori_rounds_sub_sBox_PRINCE_4_g_reg[5]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_L_XORInst6_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_L_XORInst6_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_4_g_reg[7]), .B(
        Midori_rounds_sub_sBox_PRINCE_4_g_reg[8]), .Z(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_L_XORInst6_n6) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_L_XORInst7_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_L_XORInst7_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_L_XORInst7_n5), .ZN(output1[19])
         );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_L_XORInst7_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_4_h_reg[2]), .B(
        Midori_rounds_sub_sBox_PRINCE_4_h_reg[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_L_XORInst7_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_L_XORInst7_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_4_h_reg[3]), .B(
        Midori_rounds_sub_sBox_PRINCE_4_h_reg[4]), .Z(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_L_XORInst7_n6) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_L_XORInst8_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_L_XORInst8_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_L_XORInst8_n5), .ZN(
        Midori_rounds_SR_Result2[39]) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_L_XORInst8_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_4_h_reg[6]), .B(
        Midori_rounds_sub_sBox_PRINCE_4_h_reg[5]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_L_XORInst8_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_4_Inst_L_XORInst8_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_4_h_reg[7]), .B(
        Midori_rounds_sub_sBox_PRINCE_4_h_reg[8]), .Z(
        Midori_rounds_sub_sBox_PRINCE_4_Inst_L_XORInst8_n6) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F1_U17 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F1_n43), .A2(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F1_n42), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_g[1]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F1_U16 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F1_n41), .A2(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F1_n40), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F1_n42) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F1_U15 ( .A1(
        Midori_rounds_roundReg_out2[22]), .A2(Midori_rounds_roundReg_out1[23]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F1_n40) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F1_U14 ( .A(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F1_n39), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F1_n43) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F1_U13 ( .A(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F1_n38), .B(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F1_n37), .S(
        Midori_rounds_roundReg_out1[21]), .Z(
        Midori_rounds_sub_sBox_PRINCE_5_e[1]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F1_U12 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F1_n36), .A2(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F1_n41), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F1_n38) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F1_U11 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F1_n35), .A2(
        Midori_rounds_roundReg_out1[23]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F1_n41) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F1_U10 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F1_n34), .A2(
        Midori_rounds_roundReg_out2[22]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F1_n36) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F1_U9 ( .A1(
        Midori_rounds_roundReg_out1[23]), .A2(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F1_n35), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F1_n34) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F1_U8 ( .A(
        Midori_rounds_roundReg_out1[20]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F1_n35) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F1_U7 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F1_n33), .A2(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F1_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_h[1]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F1_U6 ( .A1(
        Midori_rounds_roundReg_out1[23]), .A2(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F1_n39), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F1_n32) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F1_U5 ( .A1(
        Midori_rounds_roundReg_out1[21]), .A2(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F1_n31), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F1_n39) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F1_U4 ( .A1(
        Midori_rounds_roundReg_out2[22]), .A2(Midori_rounds_roundReg_out1[20]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F1_n31) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F1_U3 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F1_n30), .A2(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F1_n37), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F1_n33) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F1_U2 ( .A(
        Midori_rounds_roundReg_out2[22]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F1_n37) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F1_U1 ( .A1(
        Midori_rounds_roundReg_out1[23]), .A2(Midori_rounds_roundReg_out1[20]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F1_n30) );
  AND2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F2_U12 ( .A1(
        Midori_rounds_roundReg_out2[21]), .A2(
        Midori_rounds_sub_sBox_PRINCE_5_f[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_e[2]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F2_U11 ( .A(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F2_n33), .B(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F2_n32), .S(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F2_n31), .Z(
        Midori_rounds_sub_sBox_PRINCE_5_f[1]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F2_U10 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F2_n30), .A2(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F2_n29), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_g[2]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F2_U9 ( .A(
        Midori_rounds_roundReg_out1[22]), .B(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F2_n28), .S(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F2_n31), .Z(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F2_n29) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F2_U8 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F2_n32), .A2(
        Midori_rounds_roundReg_out2[21]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F2_n30) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F2_U7 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F2_n27), .A2(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F2_n26), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_h[2]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F2_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F2_n33), .A2(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F2_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F2_n26) );
  AND2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F2_U5 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F2_n28), .A2(
        Midori_rounds_roundReg_out1[22]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F2_n32) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F2_U4 ( .A1(
        Midori_rounds_roundReg_out1[22]), .A2(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F2_n28), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F2_n33) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F2_U3 ( .A(
        Midori_rounds_roundReg_out1[20]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F2_n28) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F2_U2 ( .A1(
        Midori_rounds_roundReg_out2[21]), .A2(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F2_n31), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F2_n27) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F2_U1 ( .A(
        Midori_rounds_roundReg_out1[23]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F2_n31) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F3_U13 ( .A1(
        Midori_rounds_roundReg_out1[21]), .A2(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F3_n35), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_g[3]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F3_U12 ( .A(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F3_n34), .B(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F3_n33), .S(
        Midori_rounds_roundReg_out2[20]), .Z(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F3_n35) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F3_U11 ( .A1(
        Midori_rounds_roundReg_out1[23]), .A2(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F3_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F3_n33) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F3_U10 ( .A1(
        Midori_rounds_roundReg_out1[22]), .A2(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F3_n31), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F3_n34) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F3_U9 ( .A(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F3_n30), .B(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F3_n29), .S(
        Midori_rounds_roundReg_out1[22]), .Z(
        Midori_rounds_sub_sBox_PRINCE_5_e[3]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F3_U8 ( .A1(
        Midori_rounds_roundReg_out2[20]), .A2(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F3_n28), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F3_n29) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F3_U7 ( .A1(
        Midori_rounds_roundReg_out1[21]), .A2(Midori_rounds_roundReg_out1[23]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F3_n28) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F3_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F3_n27), .A2(
        Midori_rounds_roundReg_out1[23]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F3_n30) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F3_U5 ( .A1(
        Midori_rounds_roundReg_out1[21]), .A2(Midori_rounds_roundReg_out2[20]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F3_n27) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F3_U4 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F3_n31), .A2(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F3_n26), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_h[3]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F3_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F3_n32), .B(
        Midori_rounds_roundReg_out2[20]), .S(Midori_rounds_roundReg_out1[21]), 
        .Z(Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F3_n26) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F3_U2 ( .A(
        Midori_rounds_roundReg_out1[22]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F3_n32) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F3_U1 ( .A(
        Midori_rounds_roundReg_out1[23]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F3_n31) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F4_U15 ( .A(
        Midori_rounds_roundReg_out2[20]), .B(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F4_n49), .S(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F4_n48), .Z(
        Midori_rounds_sub_sBox_PRINCE_5_h[4]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F4_U14 ( .A1(
        Midori_rounds_roundReg_out1[23]), .A2(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F4_n47), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F4_n48) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F4_U13 ( .A(
        Midori_rounds_roundReg_out2[21]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F4_n47) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F4_U12 ( .A(
        Midori_rounds_roundReg_out2[20]), .B(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F4_n46), .S(
        Midori_rounds_roundReg_out2[21]), .Z(
        Midori_rounds_sub_sBox_PRINCE_5_g[4]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F4_U11 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F4_n45), .A2(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F4_n44), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F4_n46) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F4_U10 ( .A1(
        Midori_rounds_roundReg_out2[22]), .A2(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F4_n43), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F4_n45) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F4_U9 ( .A(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F4_n42), .B(
        Midori_rounds_roundReg_out2[21]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_f[2]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F4_U8 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F4_n41), .A2(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F4_n44), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F4_n42) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F4_U7 ( .A1(
        Midori_rounds_roundReg_out2[21]), .A2(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F4_n40), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_e[4]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F4_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F4_n41), .A2(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F4_n39), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F4_n40) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F4_U5 ( .A1(
        Midori_rounds_roundReg_out2[22]), .A2(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F4_n44), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F4_n39) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F4_U4 ( .A1(
        Midori_rounds_roundReg_out2[20]), .A2(Midori_rounds_roundReg_out1[23]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F4_n44) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F4_U3 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F4_n49), .A2(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F4_n43), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F4_n41) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F4_U2 ( .A1(
        Midori_rounds_roundReg_out2[20]), .A2(Midori_rounds_roundReg_out1[23]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F4_n43) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F4_U1 ( .A(
        Midori_rounds_roundReg_out2[22]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F4_n49) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F5_U12 ( .A(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F5_n33), .B(
        Midori_rounds_roundReg_out1[20]), .S(Midori_rounds_roundReg_out1[21]), 
        .Z(Midori_rounds_sub_sBox_PRINCE_5_g[5]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F5_U11 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F5_n32), .A2(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F5_n31), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F5_n33) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F5_U10 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F5_n30), .A2(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F5_n29), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F5_n31) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F5_U9 ( .A(
        Midori_rounds_roundReg_out1[20]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F5_n30) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F5_U8 ( .A(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F5_n28), .B(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F5_n27), .S(
        Midori_rounds_roundReg_out1[20]), .Z(
        Midori_rounds_sub_sBox_PRINCE_5_e[5]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F5_U7 ( .A1(
        Midori_rounds_roundReg_out1[21]), .A2(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F5_n29), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F5_n27) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F5_U6 ( .A1(
        Midori_rounds_roundReg_out2[23]), .A2(Midori_rounds_roundReg_out1[22]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F5_n29) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F5_U5 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F5_n28), .A2(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F5_n26), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_h[5]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F5_U4 ( .A1(
        Midori_rounds_roundReg_out2[23]), .A2(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F5_n25), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F5_n26) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F5_U3 ( .A1(
        Midori_rounds_roundReg_out1[21]), .A2(Midori_rounds_roundReg_out1[20]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F5_n25) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F5_U2 ( .A1(
        Midori_rounds_roundReg_out1[21]), .A2(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F5_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F5_n28) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F5_U1 ( .A1(
        Midori_rounds_roundReg_out2[23]), .A2(Midori_rounds_roundReg_out1[22]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F5_n32) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_U22 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_n62), .A2(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_n61), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_h[6]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_U21 ( .A1(
        Midori_rounds_roundReg_out2[21]), .A2(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_n60), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_n61) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_U20 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_n59), .A2(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_n58), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_n62) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_U19 ( .A(
        Midori_rounds_roundReg_out2[23]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_n58) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_U18 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_n57), .A2(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_n56), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_n59) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_U17 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_n57), .A2(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_n55), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_e[6]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_U16 ( .A(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_n54), .B(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_n53), .S(
        Midori_rounds_roundReg_out2[23]), .Z(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_n55) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_U15 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_n52), .A2(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_n51), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_f[3]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_U14 ( .A1(
        Midori_rounds_roundReg_out2[21]), .A2(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_n50), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_n51) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_U13 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_n49), .A2(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_n48), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_n52) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_U12 ( .A(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_n50), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_n48) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_U11 ( .A1(
        Midori_rounds_roundReg_out2[22]), .A2(Midori_rounds_roundReg_out1[20]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_n50) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_U10 ( .A(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_n47), .B(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_n57), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_n49) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_U9 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_n46), .A2(
        Midori_rounds_roundReg_out2[23]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_n47) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_U8 ( .A1(
        Midori_rounds_roundReg_out2[22]), .A2(Midori_rounds_roundReg_out1[20]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_n46) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_U7 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_n57), .A2(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_n45), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_g[6]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_U6 ( .A(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_n53), .B(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_n54), .S(
        Midori_rounds_roundReg_out2[23]), .Z(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_n45) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_U5 ( .A1(
        Midori_rounds_roundReg_out2[22]), .A2(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_n60), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_n54) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_U4 ( .A(
        Midori_rounds_roundReg_out1[20]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_n60) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_U3 ( .A1(
        Midori_rounds_roundReg_out1[20]), .A2(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_n56), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_n53) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_U2 ( .A(
        Midori_rounds_roundReg_out2[22]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_n56) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_U1 ( .A(
        Midori_rounds_roundReg_out2[21]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F6_n57) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F7_U11 ( .A(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F7_n35), .B(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F7_n34), .S(
        Midori_rounds_roundReg_out1[21]), .Z(
        Midori_rounds_sub_sBox_PRINCE_5_h[7]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F7_U10 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F7_n33), .A2(
        Midori_rounds_roundReg_out2[22]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F7_n34) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F7_U9 ( .A(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F7_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F7_n35) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F7_U8 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F7_n31), .A2(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F7_n30), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_g[7]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F7_U7 ( .A(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F7_n29), .B(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F7_n32), .S(
        Midori_rounds_roundReg_out2[22]), .Z(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F7_n30) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F7_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F7_n31), .A2(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F7_n28), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_e[7]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F7_U5 ( .A(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F7_n32), .B(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F7_n29), .S(
        Midori_rounds_roundReg_out2[22]), .Z(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F7_n28) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F7_U4 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F7_n33), .A2(
        Midori_rounds_roundReg_out2[20]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F7_n29) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F7_U3 ( .A1(
        Midori_rounds_roundReg_out2[20]), .A2(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F7_n33), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F7_n32) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F7_U2 ( .A(
        Midori_rounds_roundReg_out2[23]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F7_n33) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F7_U1 ( .A(
        Midori_rounds_roundReg_out1[21]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F7_n31) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F8_U17 ( .A(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F8_n44), .B(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F8_n43), .S(
        Midori_rounds_roundReg_out2[21]), .Z(
        Midori_rounds_sub_sBox_PRINCE_5_e[8]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F8_U16 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F8_n42), .A2(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F8_n41), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F8_n44) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F8_U15 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F8_n40), .A2(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F8_n39), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_h[8]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F8_U14 ( .A1(
        Midori_rounds_roundReg_out2[21]), .A2(Midori_rounds_roundReg_out1[22]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F8_n39) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F8_U13 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F8_n38), .A2(
        Midori_rounds_roundReg_out2[23]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F8_n40) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F8_U12 ( .A1(
        Midori_rounds_roundReg_out2[21]), .A2(Midori_rounds_roundReg_out2[20]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F8_n38) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F8_U11 ( .A1(
        Midori_rounds_roundReg_out2[21]), .A2(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F8_n37), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_g[8]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F8_U10 ( .A(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F8_n36), .B(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F8_n35), .S(
        Midori_rounds_roundReg_out2[23]), .Z(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F8_n37) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F8_U9 ( .A1(
        Midori_rounds_roundReg_out2[20]), .A2(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F8_n43), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F8_n35) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F8_U8 ( .A(
        Midori_rounds_roundReg_out1[22]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F8_n43) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F8_U7 ( .A1(
        Midori_rounds_roundReg_out1[22]), .A2(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F8_n34), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F8_n36) );
  AND2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F8_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F8_n33), .A2(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F8_n42), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_f[4]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F8_U5 ( .A1(
        Midori_rounds_roundReg_out2[20]), .A2(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F8_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F8_n42) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F8_U4 ( .A1(
        Midori_rounds_roundReg_out2[23]), .A2(Midori_rounds_roundReg_out1[22]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F8_n32) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F8_U3 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F8_n41), .A2(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F8_n34), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F8_n33) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F8_U2 ( .A(
        Midori_rounds_roundReg_out2[20]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F8_n34) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F8_U1 ( .A1(
        Midori_rounds_roundReg_out2[23]), .A2(Midori_rounds_roundReg_out1[22]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_5_Inst_N_F8_n41) );
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_5_InAff_output_reg_s_current_state_reg_0_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_5_e[1]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_5_e_reg[1]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_5_InAff_output_reg_s_current_state_reg_1_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_5_e[2]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_5_e_reg[2]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_5_InAff_output_reg_s_current_state_reg_2_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_5_e[3]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_5_e_reg[3]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_5_InAff_output_reg_s_current_state_reg_3_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_5_e[4]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_5_e_reg[4]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_5_InAff_output_reg_s_current_state_reg_4_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_5_e[5]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_5_e_reg[5]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_5_InAff_output_reg_s_current_state_reg_5_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_5_e[6]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_5_e_reg[6]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_5_InAff_output_reg_s_current_state_reg_6_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_5_e[7]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_5_e_reg[7]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_5_InAff_output_reg_s_current_state_reg_7_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_5_e[8]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_5_e_reg[8]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_5_InAff_output_reg_s_current_state_reg_8_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_5_f[1]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_5_f_reg[1]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_5_InAff_output_reg_s_current_state_reg_9_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_5_f[2]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_5_f_reg[2]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_5_InAff_output_reg_s_current_state_reg_10_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_5_f[3]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_5_f_reg[3]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_5_InAff_output_reg_s_current_state_reg_11_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_5_f[4]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_5_f_reg[4]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_5_InAff_output_reg_s_current_state_reg_12_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_5_g[1]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_5_g_reg[1]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_5_InAff_output_reg_s_current_state_reg_13_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_5_g[2]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_5_g_reg[2]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_5_InAff_output_reg_s_current_state_reg_14_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_5_g[3]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_5_g_reg[3]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_5_InAff_output_reg_s_current_state_reg_15_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_5_g[4]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_5_g_reg[4]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_5_InAff_output_reg_s_current_state_reg_16_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_5_g[5]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_5_g_reg[5]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_5_InAff_output_reg_s_current_state_reg_17_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_5_g[6]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_5_g_reg[6]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_5_InAff_output_reg_s_current_state_reg_18_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_5_g[7]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_5_g_reg[7]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_5_InAff_output_reg_s_current_state_reg_19_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_5_g[8]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_5_g_reg[8]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_5_InAff_output_reg_s_current_state_reg_20_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_5_h[1]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_5_h_reg[1]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_5_InAff_output_reg_s_current_state_reg_21_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_5_h[2]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_5_h_reg[2]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_5_InAff_output_reg_s_current_state_reg_22_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_5_h[3]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_5_h_reg[3]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_5_InAff_output_reg_s_current_state_reg_23_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_5_h[4]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_5_h_reg[4]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_5_InAff_output_reg_s_current_state_reg_24_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_5_h[5]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_5_h_reg[5]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_5_InAff_output_reg_s_current_state_reg_25_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_5_h[6]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_5_h_reg[6]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_5_InAff_output_reg_s_current_state_reg_26_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_5_h[7]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_5_h_reg[7]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_5_InAff_output_reg_s_current_state_reg_27_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_5_h[8]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_5_h_reg[8]) , .QN() ); 
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_L_XORInst1_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_L_XORInst1_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_L_XORInst1_n5), .ZN(output1[20])
         );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_L_XORInst1_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_5_e_reg[2]), .B(
        Midori_rounds_sub_sBox_PRINCE_5_e_reg[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_L_XORInst1_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_L_XORInst1_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_5_e_reg[3]), .B(
        Midori_rounds_sub_sBox_PRINCE_5_e_reg[4]), .Z(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_L_XORInst1_n6) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_L_XORInst2_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_L_XORInst2_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_L_XORInst2_n5), .ZN(
        Midori_rounds_SR_Result2[56]) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_L_XORInst2_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_5_e_reg[6]), .B(
        Midori_rounds_sub_sBox_PRINCE_5_e_reg[5]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_L_XORInst2_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_L_XORInst2_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_5_e_reg[7]), .B(
        Midori_rounds_sub_sBox_PRINCE_5_e_reg[8]), .Z(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_L_XORInst2_n6) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_L_XORInst3_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_5_f_reg[2]), .B(
        Midori_rounds_sub_sBox_PRINCE_5_f_reg[1]), .Z(output1[21]) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_L_XORInst4_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_5_f_reg[4]), .B(
        Midori_rounds_sub_sBox_PRINCE_5_f_reg[3]), .Z(
        Midori_rounds_SR_Result2[57]) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_L_XORInst5_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_L_XORInst5_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_L_XORInst5_n5), .ZN(output1[22])
         );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_L_XORInst5_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_5_g_reg[2]), .B(
        Midori_rounds_sub_sBox_PRINCE_5_g_reg[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_L_XORInst5_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_L_XORInst5_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_5_g_reg[3]), .B(
        Midori_rounds_sub_sBox_PRINCE_5_g_reg[4]), .Z(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_L_XORInst5_n6) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_L_XORInst6_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_L_XORInst6_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_L_XORInst6_n5), .ZN(
        Midori_rounds_SR_Result2[58]) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_L_XORInst6_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_5_g_reg[6]), .B(
        Midori_rounds_sub_sBox_PRINCE_5_g_reg[5]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_L_XORInst6_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_L_XORInst6_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_5_g_reg[7]), .B(
        Midori_rounds_sub_sBox_PRINCE_5_g_reg[8]), .Z(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_L_XORInst6_n6) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_L_XORInst7_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_L_XORInst7_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_L_XORInst7_n5), .ZN(output1[23])
         );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_L_XORInst7_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_5_h_reg[2]), .B(
        Midori_rounds_sub_sBox_PRINCE_5_h_reg[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_L_XORInst7_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_L_XORInst7_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_5_h_reg[3]), .B(
        Midori_rounds_sub_sBox_PRINCE_5_h_reg[4]), .Z(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_L_XORInst7_n6) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_L_XORInst8_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_L_XORInst8_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_L_XORInst8_n5), .ZN(
        Midori_rounds_SR_Result2[59]) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_L_XORInst8_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_5_h_reg[6]), .B(
        Midori_rounds_sub_sBox_PRINCE_5_h_reg[5]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_L_XORInst8_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_5_Inst_L_XORInst8_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_5_h_reg[7]), .B(
        Midori_rounds_sub_sBox_PRINCE_5_h_reg[8]), .Z(
        Midori_rounds_sub_sBox_PRINCE_5_Inst_L_XORInst8_n6) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F1_U17 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F1_n43), .A2(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F1_n42), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_g[1]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F1_U16 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F1_n41), .A2(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F1_n40), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F1_n42) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F1_U15 ( .A1(
        Midori_rounds_roundReg_out2[26]), .A2(Midori_rounds_roundReg_out1[27]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F1_n40) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F1_U14 ( .A(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F1_n39), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F1_n43) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F1_U13 ( .A(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F1_n38), .B(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F1_n37), .S(
        Midori_rounds_roundReg_out1[25]), .Z(
        Midori_rounds_sub_sBox_PRINCE_6_e[1]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F1_U12 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F1_n36), .A2(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F1_n41), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F1_n38) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F1_U11 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F1_n35), .A2(
        Midori_rounds_roundReg_out1[27]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F1_n41) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F1_U10 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F1_n34), .A2(
        Midori_rounds_roundReg_out2[26]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F1_n36) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F1_U9 ( .A1(
        Midori_rounds_roundReg_out1[27]), .A2(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F1_n35), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F1_n34) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F1_U8 ( .A(
        Midori_rounds_roundReg_out1[24]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F1_n35) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F1_U7 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F1_n33), .A2(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F1_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_h[1]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F1_U6 ( .A1(
        Midori_rounds_roundReg_out1[27]), .A2(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F1_n39), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F1_n32) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F1_U5 ( .A1(
        Midori_rounds_roundReg_out1[25]), .A2(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F1_n31), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F1_n39) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F1_U4 ( .A1(
        Midori_rounds_roundReg_out2[26]), .A2(Midori_rounds_roundReg_out1[24]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F1_n31) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F1_U3 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F1_n30), .A2(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F1_n37), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F1_n33) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F1_U2 ( .A(
        Midori_rounds_roundReg_out2[26]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F1_n37) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F1_U1 ( .A1(
        Midori_rounds_roundReg_out1[27]), .A2(Midori_rounds_roundReg_out1[24]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F1_n30) );
  AND2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F2_U12 ( .A1(
        Midori_rounds_roundReg_out2[25]), .A2(
        Midori_rounds_sub_sBox_PRINCE_6_f[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_e[2]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F2_U11 ( .A(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F2_n33), .B(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F2_n32), .S(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F2_n31), .Z(
        Midori_rounds_sub_sBox_PRINCE_6_f[1]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F2_U10 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F2_n30), .A2(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F2_n29), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_g[2]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F2_U9 ( .A(
        Midori_rounds_roundReg_out1[26]), .B(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F2_n28), .S(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F2_n31), .Z(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F2_n29) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F2_U8 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F2_n32), .A2(
        Midori_rounds_roundReg_out2[25]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F2_n30) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F2_U7 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F2_n27), .A2(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F2_n26), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_h[2]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F2_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F2_n33), .A2(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F2_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F2_n26) );
  AND2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F2_U5 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F2_n28), .A2(
        Midori_rounds_roundReg_out1[26]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F2_n32) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F2_U4 ( .A1(
        Midori_rounds_roundReg_out1[26]), .A2(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F2_n28), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F2_n33) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F2_U3 ( .A(
        Midori_rounds_roundReg_out1[24]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F2_n28) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F2_U2 ( .A1(
        Midori_rounds_roundReg_out2[25]), .A2(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F2_n31), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F2_n27) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F2_U1 ( .A(
        Midori_rounds_roundReg_out1[27]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F2_n31) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F3_U13 ( .A1(
        Midori_rounds_roundReg_out1[25]), .A2(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F3_n35), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_g[3]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F3_U12 ( .A(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F3_n34), .B(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F3_n33), .S(
        Midori_rounds_roundReg_out2[24]), .Z(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F3_n35) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F3_U11 ( .A1(
        Midori_rounds_roundReg_out1[27]), .A2(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F3_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F3_n33) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F3_U10 ( .A1(
        Midori_rounds_roundReg_out1[26]), .A2(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F3_n31), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F3_n34) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F3_U9 ( .A(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F3_n30), .B(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F3_n29), .S(
        Midori_rounds_roundReg_out1[26]), .Z(
        Midori_rounds_sub_sBox_PRINCE_6_e[3]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F3_U8 ( .A1(
        Midori_rounds_roundReg_out2[24]), .A2(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F3_n28), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F3_n29) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F3_U7 ( .A1(
        Midori_rounds_roundReg_out1[25]), .A2(Midori_rounds_roundReg_out1[27]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F3_n28) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F3_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F3_n27), .A2(
        Midori_rounds_roundReg_out1[27]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F3_n30) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F3_U5 ( .A1(
        Midori_rounds_roundReg_out1[25]), .A2(Midori_rounds_roundReg_out2[24]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F3_n27) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F3_U4 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F3_n31), .A2(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F3_n26), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_h[3]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F3_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F3_n32), .B(
        Midori_rounds_roundReg_out2[24]), .S(Midori_rounds_roundReg_out1[25]), 
        .Z(Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F3_n26) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F3_U2 ( .A(
        Midori_rounds_roundReg_out1[26]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F3_n32) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F3_U1 ( .A(
        Midori_rounds_roundReg_out1[27]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F3_n31) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F4_U15 ( .A(
        Midori_rounds_roundReg_out2[24]), .B(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F4_n49), .S(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F4_n48), .Z(
        Midori_rounds_sub_sBox_PRINCE_6_h[4]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F4_U14 ( .A1(
        Midori_rounds_roundReg_out1[27]), .A2(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F4_n47), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F4_n48) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F4_U13 ( .A(
        Midori_rounds_roundReg_out2[25]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F4_n47) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F4_U12 ( .A(
        Midori_rounds_roundReg_out2[24]), .B(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F4_n46), .S(
        Midori_rounds_roundReg_out2[25]), .Z(
        Midori_rounds_sub_sBox_PRINCE_6_g[4]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F4_U11 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F4_n45), .A2(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F4_n44), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F4_n46) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F4_U10 ( .A1(
        Midori_rounds_roundReg_out2[26]), .A2(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F4_n43), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F4_n45) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F4_U9 ( .A(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F4_n42), .B(
        Midori_rounds_roundReg_out2[25]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_f[2]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F4_U8 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F4_n41), .A2(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F4_n44), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F4_n42) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F4_U7 ( .A1(
        Midori_rounds_roundReg_out2[25]), .A2(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F4_n40), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_e[4]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F4_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F4_n41), .A2(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F4_n39), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F4_n40) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F4_U5 ( .A1(
        Midori_rounds_roundReg_out2[26]), .A2(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F4_n44), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F4_n39) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F4_U4 ( .A1(
        Midori_rounds_roundReg_out2[24]), .A2(Midori_rounds_roundReg_out1[27]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F4_n44) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F4_U3 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F4_n49), .A2(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F4_n43), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F4_n41) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F4_U2 ( .A1(
        Midori_rounds_roundReg_out2[24]), .A2(Midori_rounds_roundReg_out1[27]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F4_n43) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F4_U1 ( .A(
        Midori_rounds_roundReg_out2[26]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F4_n49) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F5_U12 ( .A(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F5_n33), .B(
        Midori_rounds_roundReg_out1[24]), .S(Midori_rounds_roundReg_out1[25]), 
        .Z(Midori_rounds_sub_sBox_PRINCE_6_g[5]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F5_U11 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F5_n32), .A2(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F5_n31), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F5_n33) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F5_U10 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F5_n30), .A2(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F5_n29), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F5_n31) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F5_U9 ( .A(
        Midori_rounds_roundReg_out1[24]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F5_n30) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F5_U8 ( .A(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F5_n28), .B(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F5_n27), .S(
        Midori_rounds_roundReg_out1[24]), .Z(
        Midori_rounds_sub_sBox_PRINCE_6_e[5]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F5_U7 ( .A1(
        Midori_rounds_roundReg_out1[25]), .A2(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F5_n29), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F5_n27) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F5_U6 ( .A1(
        Midori_rounds_roundReg_out2[27]), .A2(Midori_rounds_roundReg_out1[26]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F5_n29) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F5_U5 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F5_n28), .A2(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F5_n26), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_h[5]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F5_U4 ( .A1(
        Midori_rounds_roundReg_out2[27]), .A2(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F5_n25), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F5_n26) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F5_U3 ( .A1(
        Midori_rounds_roundReg_out1[25]), .A2(Midori_rounds_roundReg_out1[24]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F5_n25) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F5_U2 ( .A1(
        Midori_rounds_roundReg_out1[25]), .A2(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F5_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F5_n28) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F5_U1 ( .A1(
        Midori_rounds_roundReg_out2[27]), .A2(Midori_rounds_roundReg_out1[26]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F5_n32) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_U22 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_n62), .A2(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_n61), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_h[6]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_U21 ( .A1(
        Midori_rounds_roundReg_out2[25]), .A2(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_n60), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_n61) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_U20 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_n59), .A2(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_n58), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_n62) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_U19 ( .A(
        Midori_rounds_roundReg_out2[27]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_n58) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_U18 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_n57), .A2(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_n56), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_n59) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_U17 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_n57), .A2(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_n55), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_e[6]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_U16 ( .A(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_n54), .B(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_n53), .S(
        Midori_rounds_roundReg_out2[27]), .Z(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_n55) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_U15 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_n52), .A2(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_n51), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_f[3]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_U14 ( .A1(
        Midori_rounds_roundReg_out2[25]), .A2(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_n50), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_n51) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_U13 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_n49), .A2(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_n48), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_n52) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_U12 ( .A(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_n50), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_n48) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_U11 ( .A1(
        Midori_rounds_roundReg_out2[26]), .A2(Midori_rounds_roundReg_out1[24]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_n50) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_U10 ( .A(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_n47), .B(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_n57), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_n49) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_U9 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_n46), .A2(
        Midori_rounds_roundReg_out2[27]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_n47) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_U8 ( .A1(
        Midori_rounds_roundReg_out2[26]), .A2(Midori_rounds_roundReg_out1[24]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_n46) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_U7 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_n57), .A2(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_n45), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_g[6]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_U6 ( .A(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_n53), .B(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_n54), .S(
        Midori_rounds_roundReg_out2[27]), .Z(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_n45) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_U5 ( .A1(
        Midori_rounds_roundReg_out2[26]), .A2(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_n60), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_n54) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_U4 ( .A(
        Midori_rounds_roundReg_out1[24]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_n60) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_U3 ( .A1(
        Midori_rounds_roundReg_out1[24]), .A2(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_n56), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_n53) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_U2 ( .A(
        Midori_rounds_roundReg_out2[26]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_n56) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_U1 ( .A(
        Midori_rounds_roundReg_out2[25]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F6_n57) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F7_U11 ( .A(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F7_n35), .B(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F7_n34), .S(
        Midori_rounds_roundReg_out1[25]), .Z(
        Midori_rounds_sub_sBox_PRINCE_6_h[7]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F7_U10 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F7_n33), .A2(
        Midori_rounds_roundReg_out2[26]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F7_n34) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F7_U9 ( .A(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F7_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F7_n35) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F7_U8 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F7_n31), .A2(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F7_n30), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_g[7]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F7_U7 ( .A(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F7_n29), .B(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F7_n32), .S(
        Midori_rounds_roundReg_out2[26]), .Z(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F7_n30) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F7_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F7_n31), .A2(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F7_n28), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_e[7]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F7_U5 ( .A(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F7_n32), .B(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F7_n29), .S(
        Midori_rounds_roundReg_out2[26]), .Z(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F7_n28) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F7_U4 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F7_n33), .A2(
        Midori_rounds_roundReg_out2[24]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F7_n29) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F7_U3 ( .A1(
        Midori_rounds_roundReg_out2[24]), .A2(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F7_n33), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F7_n32) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F7_U2 ( .A(
        Midori_rounds_roundReg_out2[27]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F7_n33) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F7_U1 ( .A(
        Midori_rounds_roundReg_out1[25]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F7_n31) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F8_U17 ( .A(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F8_n44), .B(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F8_n43), .S(
        Midori_rounds_roundReg_out2[25]), .Z(
        Midori_rounds_sub_sBox_PRINCE_6_e[8]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F8_U16 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F8_n42), .A2(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F8_n41), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F8_n44) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F8_U15 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F8_n40), .A2(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F8_n39), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_h[8]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F8_U14 ( .A1(
        Midori_rounds_roundReg_out2[25]), .A2(Midori_rounds_roundReg_out1[26]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F8_n39) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F8_U13 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F8_n38), .A2(
        Midori_rounds_roundReg_out2[27]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F8_n40) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F8_U12 ( .A1(
        Midori_rounds_roundReg_out2[25]), .A2(Midori_rounds_roundReg_out2[24]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F8_n38) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F8_U11 ( .A1(
        Midori_rounds_roundReg_out2[25]), .A2(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F8_n37), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_g[8]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F8_U10 ( .A(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F8_n36), .B(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F8_n35), .S(
        Midori_rounds_roundReg_out2[27]), .Z(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F8_n37) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F8_U9 ( .A1(
        Midori_rounds_roundReg_out2[24]), .A2(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F8_n43), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F8_n35) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F8_U8 ( .A(
        Midori_rounds_roundReg_out1[26]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F8_n43) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F8_U7 ( .A1(
        Midori_rounds_roundReg_out1[26]), .A2(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F8_n34), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F8_n36) );
  AND2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F8_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F8_n33), .A2(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F8_n42), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_f[4]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F8_U5 ( .A1(
        Midori_rounds_roundReg_out2[24]), .A2(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F8_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F8_n42) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F8_U4 ( .A1(
        Midori_rounds_roundReg_out2[27]), .A2(Midori_rounds_roundReg_out1[26]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F8_n32) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F8_U3 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F8_n41), .A2(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F8_n34), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F8_n33) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F8_U2 ( .A(
        Midori_rounds_roundReg_out2[24]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F8_n34) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F8_U1 ( .A1(
        Midori_rounds_roundReg_out2[27]), .A2(Midori_rounds_roundReg_out1[26]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_6_Inst_N_F8_n41) );
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_6_InAff_output_reg_s_current_state_reg_0_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_6_e[1]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_6_e_reg[1]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_6_InAff_output_reg_s_current_state_reg_1_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_6_e[2]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_6_e_reg[2]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_6_InAff_output_reg_s_current_state_reg_2_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_6_e[3]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_6_e_reg[3]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_6_InAff_output_reg_s_current_state_reg_3_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_6_e[4]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_6_e_reg[4]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_6_InAff_output_reg_s_current_state_reg_4_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_6_e[5]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_6_e_reg[5]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_6_InAff_output_reg_s_current_state_reg_5_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_6_e[6]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_6_e_reg[6]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_6_InAff_output_reg_s_current_state_reg_6_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_6_e[7]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_6_e_reg[7]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_6_InAff_output_reg_s_current_state_reg_7_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_6_e[8]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_6_e_reg[8]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_6_InAff_output_reg_s_current_state_reg_8_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_6_f[1]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_6_f_reg[1]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_6_InAff_output_reg_s_current_state_reg_9_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_6_f[2]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_6_f_reg[2]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_6_InAff_output_reg_s_current_state_reg_10_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_6_f[3]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_6_f_reg[3]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_6_InAff_output_reg_s_current_state_reg_11_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_6_f[4]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_6_f_reg[4]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_6_InAff_output_reg_s_current_state_reg_12_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_6_g[1]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_6_g_reg[1]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_6_InAff_output_reg_s_current_state_reg_13_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_6_g[2]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_6_g_reg[2]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_6_InAff_output_reg_s_current_state_reg_14_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_6_g[3]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_6_g_reg[3]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_6_InAff_output_reg_s_current_state_reg_15_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_6_g[4]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_6_g_reg[4]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_6_InAff_output_reg_s_current_state_reg_16_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_6_g[5]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_6_g_reg[5]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_6_InAff_output_reg_s_current_state_reg_17_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_6_g[6]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_6_g_reg[6]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_6_InAff_output_reg_s_current_state_reg_18_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_6_g[7]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_6_g_reg[7]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_6_InAff_output_reg_s_current_state_reg_19_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_6_g[8]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_6_g_reg[8]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_6_InAff_output_reg_s_current_state_reg_20_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_6_h[1]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_6_h_reg[1]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_6_InAff_output_reg_s_current_state_reg_21_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_6_h[2]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_6_h_reg[2]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_6_InAff_output_reg_s_current_state_reg_22_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_6_h[3]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_6_h_reg[3]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_6_InAff_output_reg_s_current_state_reg_23_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_6_h[4]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_6_h_reg[4]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_6_InAff_output_reg_s_current_state_reg_24_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_6_h[5]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_6_h_reg[5]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_6_InAff_output_reg_s_current_state_reg_25_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_6_h[6]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_6_h_reg[6]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_6_InAff_output_reg_s_current_state_reg_26_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_6_h[7]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_6_h_reg[7]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_6_InAff_output_reg_s_current_state_reg_27_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_6_h[8]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_6_h_reg[8]) , .QN() ); 
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_L_XORInst1_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_L_XORInst1_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_L_XORInst1_n5), .ZN(output1[24])
         );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_L_XORInst1_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_6_e_reg[2]), .B(
        Midori_rounds_sub_sBox_PRINCE_6_e_reg[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_L_XORInst1_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_L_XORInst1_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_6_e_reg[3]), .B(
        Midori_rounds_sub_sBox_PRINCE_6_e_reg[4]), .Z(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_L_XORInst1_n6) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_L_XORInst2_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_L_XORInst2_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_L_XORInst2_n5), .ZN(
        Midori_rounds_SR_Result2[28]) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_L_XORInst2_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_6_e_reg[6]), .B(
        Midori_rounds_sub_sBox_PRINCE_6_e_reg[5]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_L_XORInst2_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_L_XORInst2_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_6_e_reg[7]), .B(
        Midori_rounds_sub_sBox_PRINCE_6_e_reg[8]), .Z(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_L_XORInst2_n6) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_L_XORInst3_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_6_f_reg[2]), .B(
        Midori_rounds_sub_sBox_PRINCE_6_f_reg[1]), .Z(output1[25]) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_L_XORInst4_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_6_f_reg[4]), .B(
        Midori_rounds_sub_sBox_PRINCE_6_f_reg[3]), .Z(
        Midori_rounds_SR_Result2[29]) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_L_XORInst5_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_L_XORInst5_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_L_XORInst5_n5), .ZN(output1[26])
         );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_L_XORInst5_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_6_g_reg[2]), .B(
        Midori_rounds_sub_sBox_PRINCE_6_g_reg[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_L_XORInst5_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_L_XORInst5_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_6_g_reg[3]), .B(
        Midori_rounds_sub_sBox_PRINCE_6_g_reg[4]), .Z(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_L_XORInst5_n6) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_L_XORInst6_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_L_XORInst6_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_L_XORInst6_n5), .ZN(
        Midori_rounds_SR_Result2[30]) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_L_XORInst6_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_6_g_reg[6]), .B(
        Midori_rounds_sub_sBox_PRINCE_6_g_reg[5]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_L_XORInst6_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_L_XORInst6_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_6_g_reg[7]), .B(
        Midori_rounds_sub_sBox_PRINCE_6_g_reg[8]), .Z(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_L_XORInst6_n6) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_L_XORInst7_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_L_XORInst7_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_L_XORInst7_n5), .ZN(output1[27])
         );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_L_XORInst7_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_6_h_reg[2]), .B(
        Midori_rounds_sub_sBox_PRINCE_6_h_reg[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_L_XORInst7_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_L_XORInst7_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_6_h_reg[3]), .B(
        Midori_rounds_sub_sBox_PRINCE_6_h_reg[4]), .Z(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_L_XORInst7_n6) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_L_XORInst8_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_L_XORInst8_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_L_XORInst8_n5), .ZN(
        Midori_rounds_SR_Result2[31]) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_L_XORInst8_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_6_h_reg[6]), .B(
        Midori_rounds_sub_sBox_PRINCE_6_h_reg[5]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_L_XORInst8_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_6_Inst_L_XORInst8_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_6_h_reg[7]), .B(
        Midori_rounds_sub_sBox_PRINCE_6_h_reg[8]), .Z(
        Midori_rounds_sub_sBox_PRINCE_6_Inst_L_XORInst8_n6) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F1_U17 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F1_n43), .A2(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F1_n42), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_g[1]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F1_U16 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F1_n41), .A2(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F1_n40), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F1_n42) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F1_U15 ( .A1(
        Midori_rounds_roundReg_out2[30]), .A2(Midori_rounds_roundReg_out1[31]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F1_n40) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F1_U14 ( .A(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F1_n39), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F1_n43) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F1_U13 ( .A(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F1_n38), .B(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F1_n37), .S(
        Midori_rounds_roundReg_out1[29]), .Z(
        Midori_rounds_sub_sBox_PRINCE_7_e[1]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F1_U12 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F1_n36), .A2(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F1_n41), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F1_n38) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F1_U11 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F1_n35), .A2(
        Midori_rounds_roundReg_out1[31]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F1_n41) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F1_U10 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F1_n34), .A2(
        Midori_rounds_roundReg_out2[30]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F1_n36) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F1_U9 ( .A1(
        Midori_rounds_roundReg_out1[31]), .A2(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F1_n35), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F1_n34) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F1_U8 ( .A(
        Midori_rounds_roundReg_out1[28]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F1_n35) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F1_U7 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F1_n33), .A2(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F1_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_h[1]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F1_U6 ( .A1(
        Midori_rounds_roundReg_out1[31]), .A2(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F1_n39), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F1_n32) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F1_U5 ( .A1(
        Midori_rounds_roundReg_out1[29]), .A2(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F1_n31), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F1_n39) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F1_U4 ( .A1(
        Midori_rounds_roundReg_out2[30]), .A2(Midori_rounds_roundReg_out1[28]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F1_n31) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F1_U3 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F1_n30), .A2(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F1_n37), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F1_n33) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F1_U2 ( .A(
        Midori_rounds_roundReg_out2[30]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F1_n37) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F1_U1 ( .A1(
        Midori_rounds_roundReg_out1[31]), .A2(Midori_rounds_roundReg_out1[28]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F1_n30) );
  AND2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F2_U12 ( .A1(
        Midori_rounds_roundReg_out2[29]), .A2(
        Midori_rounds_sub_sBox_PRINCE_7_f[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_e[2]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F2_U11 ( .A(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F2_n33), .B(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F2_n32), .S(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F2_n31), .Z(
        Midori_rounds_sub_sBox_PRINCE_7_f[1]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F2_U10 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F2_n30), .A2(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F2_n29), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_g[2]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F2_U9 ( .A(
        Midori_rounds_roundReg_out1[30]), .B(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F2_n28), .S(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F2_n31), .Z(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F2_n29) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F2_U8 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F2_n32), .A2(
        Midori_rounds_roundReg_out2[29]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F2_n30) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F2_U7 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F2_n27), .A2(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F2_n26), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_h[2]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F2_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F2_n33), .A2(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F2_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F2_n26) );
  AND2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F2_U5 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F2_n28), .A2(
        Midori_rounds_roundReg_out1[30]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F2_n32) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F2_U4 ( .A1(
        Midori_rounds_roundReg_out1[30]), .A2(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F2_n28), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F2_n33) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F2_U3 ( .A(
        Midori_rounds_roundReg_out1[28]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F2_n28) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F2_U2 ( .A1(
        Midori_rounds_roundReg_out2[29]), .A2(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F2_n31), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F2_n27) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F2_U1 ( .A(
        Midori_rounds_roundReg_out1[31]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F2_n31) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F3_U13 ( .A1(
        Midori_rounds_roundReg_out1[29]), .A2(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F3_n35), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_g[3]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F3_U12 ( .A(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F3_n34), .B(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F3_n33), .S(
        Midori_rounds_roundReg_out2[28]), .Z(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F3_n35) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F3_U11 ( .A1(
        Midori_rounds_roundReg_out1[31]), .A2(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F3_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F3_n33) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F3_U10 ( .A1(
        Midori_rounds_roundReg_out1[30]), .A2(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F3_n31), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F3_n34) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F3_U9 ( .A(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F3_n30), .B(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F3_n29), .S(
        Midori_rounds_roundReg_out1[30]), .Z(
        Midori_rounds_sub_sBox_PRINCE_7_e[3]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F3_U8 ( .A1(
        Midori_rounds_roundReg_out2[28]), .A2(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F3_n28), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F3_n29) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F3_U7 ( .A1(
        Midori_rounds_roundReg_out1[29]), .A2(Midori_rounds_roundReg_out1[31]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F3_n28) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F3_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F3_n27), .A2(
        Midori_rounds_roundReg_out1[31]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F3_n30) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F3_U5 ( .A1(
        Midori_rounds_roundReg_out1[29]), .A2(Midori_rounds_roundReg_out2[28]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F3_n27) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F3_U4 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F3_n31), .A2(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F3_n26), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_h[3]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F3_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F3_n32), .B(
        Midori_rounds_roundReg_out2[28]), .S(Midori_rounds_roundReg_out1[29]), 
        .Z(Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F3_n26) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F3_U2 ( .A(
        Midori_rounds_roundReg_out1[30]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F3_n32) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F3_U1 ( .A(
        Midori_rounds_roundReg_out1[31]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F3_n31) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F4_U15 ( .A(
        Midori_rounds_roundReg_out2[28]), .B(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F4_n49), .S(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F4_n48), .Z(
        Midori_rounds_sub_sBox_PRINCE_7_h[4]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F4_U14 ( .A1(
        Midori_rounds_roundReg_out1[31]), .A2(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F4_n47), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F4_n48) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F4_U13 ( .A(
        Midori_rounds_roundReg_out2[29]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F4_n47) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F4_U12 ( .A(
        Midori_rounds_roundReg_out2[28]), .B(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F4_n46), .S(
        Midori_rounds_roundReg_out2[29]), .Z(
        Midori_rounds_sub_sBox_PRINCE_7_g[4]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F4_U11 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F4_n45), .A2(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F4_n44), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F4_n46) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F4_U10 ( .A1(
        Midori_rounds_roundReg_out2[30]), .A2(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F4_n43), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F4_n45) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F4_U9 ( .A(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F4_n42), .B(
        Midori_rounds_roundReg_out2[29]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_f[2]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F4_U8 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F4_n41), .A2(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F4_n44), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F4_n42) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F4_U7 ( .A1(
        Midori_rounds_roundReg_out2[29]), .A2(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F4_n40), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_e[4]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F4_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F4_n41), .A2(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F4_n39), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F4_n40) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F4_U5 ( .A1(
        Midori_rounds_roundReg_out2[30]), .A2(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F4_n44), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F4_n39) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F4_U4 ( .A1(
        Midori_rounds_roundReg_out2[28]), .A2(Midori_rounds_roundReg_out1[31]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F4_n44) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F4_U3 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F4_n49), .A2(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F4_n43), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F4_n41) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F4_U2 ( .A1(
        Midori_rounds_roundReg_out2[28]), .A2(Midori_rounds_roundReg_out1[31]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F4_n43) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F4_U1 ( .A(
        Midori_rounds_roundReg_out2[30]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F4_n49) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F5_U12 ( .A(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F5_n33), .B(
        Midori_rounds_roundReg_out1[28]), .S(Midori_rounds_roundReg_out1[29]), 
        .Z(Midori_rounds_sub_sBox_PRINCE_7_g[5]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F5_U11 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F5_n32), .A2(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F5_n31), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F5_n33) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F5_U10 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F5_n30), .A2(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F5_n29), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F5_n31) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F5_U9 ( .A(
        Midori_rounds_roundReg_out1[28]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F5_n30) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F5_U8 ( .A(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F5_n28), .B(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F5_n27), .S(
        Midori_rounds_roundReg_out1[28]), .Z(
        Midori_rounds_sub_sBox_PRINCE_7_e[5]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F5_U7 ( .A1(
        Midori_rounds_roundReg_out1[29]), .A2(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F5_n29), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F5_n27) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F5_U6 ( .A1(
        Midori_rounds_roundReg_out2[31]), .A2(Midori_rounds_roundReg_out1[30]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F5_n29) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F5_U5 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F5_n28), .A2(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F5_n26), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_h[5]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F5_U4 ( .A1(
        Midori_rounds_roundReg_out2[31]), .A2(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F5_n25), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F5_n26) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F5_U3 ( .A1(
        Midori_rounds_roundReg_out1[29]), .A2(Midori_rounds_roundReg_out1[28]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F5_n25) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F5_U2 ( .A1(
        Midori_rounds_roundReg_out1[29]), .A2(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F5_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F5_n28) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F5_U1 ( .A1(
        Midori_rounds_roundReg_out2[31]), .A2(Midori_rounds_roundReg_out1[30]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F5_n32) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_U22 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_n62), .A2(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_n61), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_h[6]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_U21 ( .A1(
        Midori_rounds_roundReg_out2[29]), .A2(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_n60), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_n61) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_U20 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_n59), .A2(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_n58), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_n62) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_U19 ( .A(
        Midori_rounds_roundReg_out2[31]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_n58) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_U18 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_n57), .A2(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_n56), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_n59) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_U17 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_n57), .A2(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_n55), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_e[6]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_U16 ( .A(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_n54), .B(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_n53), .S(
        Midori_rounds_roundReg_out2[31]), .Z(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_n55) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_U15 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_n52), .A2(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_n51), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_f[3]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_U14 ( .A1(
        Midori_rounds_roundReg_out2[29]), .A2(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_n50), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_n51) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_U13 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_n49), .A2(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_n48), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_n52) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_U12 ( .A(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_n50), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_n48) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_U11 ( .A1(
        Midori_rounds_roundReg_out2[30]), .A2(Midori_rounds_roundReg_out1[28]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_n50) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_U10 ( .A(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_n47), .B(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_n57), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_n49) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_U9 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_n46), .A2(
        Midori_rounds_roundReg_out2[31]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_n47) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_U8 ( .A1(
        Midori_rounds_roundReg_out2[30]), .A2(Midori_rounds_roundReg_out1[28]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_n46) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_U7 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_n57), .A2(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_n45), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_g[6]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_U6 ( .A(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_n53), .B(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_n54), .S(
        Midori_rounds_roundReg_out2[31]), .Z(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_n45) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_U5 ( .A1(
        Midori_rounds_roundReg_out2[30]), .A2(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_n60), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_n54) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_U4 ( .A(
        Midori_rounds_roundReg_out1[28]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_n60) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_U3 ( .A1(
        Midori_rounds_roundReg_out1[28]), .A2(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_n56), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_n53) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_U2 ( .A(
        Midori_rounds_roundReg_out2[30]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_n56) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_U1 ( .A(
        Midori_rounds_roundReg_out2[29]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F6_n57) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F7_U11 ( .A(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F7_n35), .B(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F7_n34), .S(
        Midori_rounds_roundReg_out1[29]), .Z(
        Midori_rounds_sub_sBox_PRINCE_7_h[7]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F7_U10 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F7_n33), .A2(
        Midori_rounds_roundReg_out2[30]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F7_n34) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F7_U9 ( .A(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F7_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F7_n35) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F7_U8 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F7_n31), .A2(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F7_n30), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_g[7]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F7_U7 ( .A(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F7_n29), .B(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F7_n32), .S(
        Midori_rounds_roundReg_out2[30]), .Z(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F7_n30) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F7_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F7_n31), .A2(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F7_n28), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_e[7]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F7_U5 ( .A(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F7_n32), .B(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F7_n29), .S(
        Midori_rounds_roundReg_out2[30]), .Z(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F7_n28) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F7_U4 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F7_n33), .A2(
        Midori_rounds_roundReg_out2[28]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F7_n29) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F7_U3 ( .A1(
        Midori_rounds_roundReg_out2[28]), .A2(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F7_n33), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F7_n32) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F7_U2 ( .A(
        Midori_rounds_roundReg_out2[31]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F7_n33) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F7_U1 ( .A(
        Midori_rounds_roundReg_out1[29]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F7_n31) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F8_U17 ( .A(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F8_n44), .B(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F8_n43), .S(
        Midori_rounds_roundReg_out2[29]), .Z(
        Midori_rounds_sub_sBox_PRINCE_7_e[8]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F8_U16 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F8_n42), .A2(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F8_n41), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F8_n44) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F8_U15 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F8_n40), .A2(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F8_n39), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_h[8]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F8_U14 ( .A1(
        Midori_rounds_roundReg_out2[29]), .A2(Midori_rounds_roundReg_out1[30]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F8_n39) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F8_U13 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F8_n38), .A2(
        Midori_rounds_roundReg_out2[31]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F8_n40) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F8_U12 ( .A1(
        Midori_rounds_roundReg_out2[29]), .A2(Midori_rounds_roundReg_out2[28]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F8_n38) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F8_U11 ( .A1(
        Midori_rounds_roundReg_out2[29]), .A2(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F8_n37), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_g[8]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F8_U10 ( .A(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F8_n36), .B(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F8_n35), .S(
        Midori_rounds_roundReg_out2[31]), .Z(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F8_n37) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F8_U9 ( .A1(
        Midori_rounds_roundReg_out2[28]), .A2(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F8_n43), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F8_n35) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F8_U8 ( .A(
        Midori_rounds_roundReg_out1[30]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F8_n43) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F8_U7 ( .A1(
        Midori_rounds_roundReg_out1[30]), .A2(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F8_n34), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F8_n36) );
  AND2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F8_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F8_n33), .A2(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F8_n42), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_f[4]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F8_U5 ( .A1(
        Midori_rounds_roundReg_out2[28]), .A2(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F8_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F8_n42) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F8_U4 ( .A1(
        Midori_rounds_roundReg_out2[31]), .A2(Midori_rounds_roundReg_out1[30]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F8_n32) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F8_U3 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F8_n41), .A2(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F8_n34), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F8_n33) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F8_U2 ( .A(
        Midori_rounds_roundReg_out2[28]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F8_n34) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F8_U1 ( .A1(
        Midori_rounds_roundReg_out2[31]), .A2(Midori_rounds_roundReg_out1[30]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_7_Inst_N_F8_n41) );
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_7_InAff_output_reg_s_current_state_reg_0_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_7_e[1]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_7_e_reg[1]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_7_InAff_output_reg_s_current_state_reg_1_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_7_e[2]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_7_e_reg[2]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_7_InAff_output_reg_s_current_state_reg_2_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_7_e[3]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_7_e_reg[3]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_7_InAff_output_reg_s_current_state_reg_3_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_7_e[4]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_7_e_reg[4]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_7_InAff_output_reg_s_current_state_reg_4_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_7_e[5]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_7_e_reg[5]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_7_InAff_output_reg_s_current_state_reg_5_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_7_e[6]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_7_e_reg[6]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_7_InAff_output_reg_s_current_state_reg_6_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_7_e[7]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_7_e_reg[7]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_7_InAff_output_reg_s_current_state_reg_7_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_7_e[8]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_7_e_reg[8]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_7_InAff_output_reg_s_current_state_reg_8_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_7_f[1]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_7_f_reg[1]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_7_InAff_output_reg_s_current_state_reg_9_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_7_f[2]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_7_f_reg[2]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_7_InAff_output_reg_s_current_state_reg_10_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_7_f[3]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_7_f_reg[3]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_7_InAff_output_reg_s_current_state_reg_11_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_7_f[4]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_7_f_reg[4]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_7_InAff_output_reg_s_current_state_reg_12_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_7_g[1]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_7_g_reg[1]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_7_InAff_output_reg_s_current_state_reg_13_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_7_g[2]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_7_g_reg[2]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_7_InAff_output_reg_s_current_state_reg_14_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_7_g[3]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_7_g_reg[3]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_7_InAff_output_reg_s_current_state_reg_15_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_7_g[4]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_7_g_reg[4]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_7_InAff_output_reg_s_current_state_reg_16_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_7_g[5]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_7_g_reg[5]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_7_InAff_output_reg_s_current_state_reg_17_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_7_g[6]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_7_g_reg[6]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_7_InAff_output_reg_s_current_state_reg_18_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_7_g[7]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_7_g_reg[7]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_7_InAff_output_reg_s_current_state_reg_19_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_7_g[8]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_7_g_reg[8]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_7_InAff_output_reg_s_current_state_reg_20_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_7_h[1]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_7_h_reg[1]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_7_InAff_output_reg_s_current_state_reg_21_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_7_h[2]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_7_h_reg[2]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_7_InAff_output_reg_s_current_state_reg_22_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_7_h[3]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_7_h_reg[3]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_7_InAff_output_reg_s_current_state_reg_23_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_7_h[4]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_7_h_reg[4]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_7_InAff_output_reg_s_current_state_reg_24_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_7_h[5]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_7_h_reg[5]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_7_InAff_output_reg_s_current_state_reg_25_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_7_h[6]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_7_h_reg[6]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_7_InAff_output_reg_s_current_state_reg_26_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_7_h[7]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_7_h_reg[7]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_7_InAff_output_reg_s_current_state_reg_27_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_7_h[8]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_7_h_reg[8]) , .QN() ); 
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_L_XORInst1_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_L_XORInst1_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_L_XORInst1_n5), .ZN(output1[28])
         );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_L_XORInst1_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_7_e_reg[2]), .B(
        Midori_rounds_sub_sBox_PRINCE_7_e_reg[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_L_XORInst1_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_L_XORInst1_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_7_e_reg[3]), .B(
        Midori_rounds_sub_sBox_PRINCE_7_e_reg[4]), .Z(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_L_XORInst1_n6) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_L_XORInst2_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_L_XORInst2_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_L_XORInst2_n5), .ZN(
        Midori_rounds_SR_Result2[0]) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_L_XORInst2_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_7_e_reg[6]), .B(
        Midori_rounds_sub_sBox_PRINCE_7_e_reg[5]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_L_XORInst2_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_L_XORInst2_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_7_e_reg[7]), .B(
        Midori_rounds_sub_sBox_PRINCE_7_e_reg[8]), .Z(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_L_XORInst2_n6) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_L_XORInst3_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_7_f_reg[2]), .B(
        Midori_rounds_sub_sBox_PRINCE_7_f_reg[1]), .Z(output1[29]) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_L_XORInst4_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_7_f_reg[4]), .B(
        Midori_rounds_sub_sBox_PRINCE_7_f_reg[3]), .Z(
        Midori_rounds_SR_Result2[1]) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_L_XORInst5_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_L_XORInst5_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_L_XORInst5_n5), .ZN(output1[30])
         );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_L_XORInst5_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_7_g_reg[2]), .B(
        Midori_rounds_sub_sBox_PRINCE_7_g_reg[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_L_XORInst5_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_L_XORInst5_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_7_g_reg[3]), .B(
        Midori_rounds_sub_sBox_PRINCE_7_g_reg[4]), .Z(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_L_XORInst5_n6) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_L_XORInst6_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_L_XORInst6_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_L_XORInst6_n5), .ZN(
        Midori_rounds_SR_Result2[2]) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_L_XORInst6_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_7_g_reg[6]), .B(
        Midori_rounds_sub_sBox_PRINCE_7_g_reg[5]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_L_XORInst6_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_L_XORInst6_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_7_g_reg[7]), .B(
        Midori_rounds_sub_sBox_PRINCE_7_g_reg[8]), .Z(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_L_XORInst6_n6) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_L_XORInst7_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_L_XORInst7_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_L_XORInst7_n5), .ZN(output1[31])
         );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_L_XORInst7_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_7_h_reg[2]), .B(
        Midori_rounds_sub_sBox_PRINCE_7_h_reg[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_L_XORInst7_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_L_XORInst7_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_7_h_reg[3]), .B(
        Midori_rounds_sub_sBox_PRINCE_7_h_reg[4]), .Z(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_L_XORInst7_n6) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_L_XORInst8_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_L_XORInst8_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_L_XORInst8_n5), .ZN(
        Midori_rounds_SR_Result2[3]) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_L_XORInst8_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_7_h_reg[6]), .B(
        Midori_rounds_sub_sBox_PRINCE_7_h_reg[5]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_L_XORInst8_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_7_Inst_L_XORInst8_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_7_h_reg[7]), .B(
        Midori_rounds_sub_sBox_PRINCE_7_h_reg[8]), .Z(
        Midori_rounds_sub_sBox_PRINCE_7_Inst_L_XORInst8_n6) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F1_U17 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F1_n43), .A2(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F1_n42), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_g[1]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F1_U16 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F1_n41), .A2(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F1_n40), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F1_n42) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F1_U15 ( .A1(
        Midori_rounds_roundReg_out2[34]), .A2(Midori_rounds_roundReg_out1[35]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F1_n40) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F1_U14 ( .A(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F1_n39), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F1_n43) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F1_U13 ( .A(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F1_n38), .B(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F1_n37), .S(
        Midori_rounds_roundReg_out1[33]), .Z(
        Midori_rounds_sub_sBox_PRINCE_8_e[1]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F1_U12 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F1_n36), .A2(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F1_n41), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F1_n38) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F1_U11 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F1_n35), .A2(
        Midori_rounds_roundReg_out1[35]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F1_n41) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F1_U10 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F1_n34), .A2(
        Midori_rounds_roundReg_out2[34]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F1_n36) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F1_U9 ( .A1(
        Midori_rounds_roundReg_out1[35]), .A2(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F1_n35), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F1_n34) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F1_U8 ( .A(
        Midori_rounds_roundReg_out1[32]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F1_n35) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F1_U7 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F1_n33), .A2(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F1_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_h[1]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F1_U6 ( .A1(
        Midori_rounds_roundReg_out1[35]), .A2(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F1_n39), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F1_n32) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F1_U5 ( .A1(
        Midori_rounds_roundReg_out1[33]), .A2(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F1_n31), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F1_n39) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F1_U4 ( .A1(
        Midori_rounds_roundReg_out2[34]), .A2(Midori_rounds_roundReg_out1[32]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F1_n31) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F1_U3 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F1_n30), .A2(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F1_n37), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F1_n33) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F1_U2 ( .A(
        Midori_rounds_roundReg_out2[34]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F1_n37) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F1_U1 ( .A1(
        Midori_rounds_roundReg_out1[35]), .A2(Midori_rounds_roundReg_out1[32]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F1_n30) );
  AND2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F2_U12 ( .A1(
        Midori_rounds_roundReg_out2[33]), .A2(
        Midori_rounds_sub_sBox_PRINCE_8_f[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_e[2]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F2_U11 ( .A(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F2_n33), .B(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F2_n32), .S(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F2_n31), .Z(
        Midori_rounds_sub_sBox_PRINCE_8_f[1]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F2_U10 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F2_n30), .A2(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F2_n29), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_g[2]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F2_U9 ( .A(
        Midori_rounds_roundReg_out1[34]), .B(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F2_n28), .S(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F2_n31), .Z(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F2_n29) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F2_U8 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F2_n32), .A2(
        Midori_rounds_roundReg_out2[33]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F2_n30) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F2_U7 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F2_n27), .A2(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F2_n26), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_h[2]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F2_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F2_n33), .A2(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F2_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F2_n26) );
  AND2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F2_U5 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F2_n28), .A2(
        Midori_rounds_roundReg_out1[34]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F2_n32) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F2_U4 ( .A1(
        Midori_rounds_roundReg_out1[34]), .A2(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F2_n28), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F2_n33) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F2_U3 ( .A(
        Midori_rounds_roundReg_out1[32]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F2_n28) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F2_U2 ( .A1(
        Midori_rounds_roundReg_out2[33]), .A2(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F2_n31), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F2_n27) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F2_U1 ( .A(
        Midori_rounds_roundReg_out1[35]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F2_n31) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F3_U13 ( .A1(
        Midori_rounds_roundReg_out1[33]), .A2(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F3_n35), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_g[3]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F3_U12 ( .A(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F3_n34), .B(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F3_n33), .S(
        Midori_rounds_roundReg_out2[32]), .Z(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F3_n35) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F3_U11 ( .A1(
        Midori_rounds_roundReg_out1[35]), .A2(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F3_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F3_n33) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F3_U10 ( .A1(
        Midori_rounds_roundReg_out1[34]), .A2(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F3_n31), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F3_n34) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F3_U9 ( .A(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F3_n30), .B(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F3_n29), .S(
        Midori_rounds_roundReg_out1[34]), .Z(
        Midori_rounds_sub_sBox_PRINCE_8_e[3]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F3_U8 ( .A1(
        Midori_rounds_roundReg_out2[32]), .A2(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F3_n28), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F3_n29) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F3_U7 ( .A1(
        Midori_rounds_roundReg_out1[33]), .A2(Midori_rounds_roundReg_out1[35]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F3_n28) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F3_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F3_n27), .A2(
        Midori_rounds_roundReg_out1[35]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F3_n30) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F3_U5 ( .A1(
        Midori_rounds_roundReg_out1[33]), .A2(Midori_rounds_roundReg_out2[32]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F3_n27) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F3_U4 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F3_n31), .A2(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F3_n26), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_h[3]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F3_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F3_n32), .B(
        Midori_rounds_roundReg_out2[32]), .S(Midori_rounds_roundReg_out1[33]), 
        .Z(Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F3_n26) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F3_U2 ( .A(
        Midori_rounds_roundReg_out1[34]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F3_n32) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F3_U1 ( .A(
        Midori_rounds_roundReg_out1[35]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F3_n31) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F4_U15 ( .A(
        Midori_rounds_roundReg_out2[32]), .B(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F4_n49), .S(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F4_n48), .Z(
        Midori_rounds_sub_sBox_PRINCE_8_h[4]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F4_U14 ( .A1(
        Midori_rounds_roundReg_out1[35]), .A2(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F4_n47), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F4_n48) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F4_U13 ( .A(
        Midori_rounds_roundReg_out2[33]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F4_n47) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F4_U12 ( .A(
        Midori_rounds_roundReg_out2[32]), .B(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F4_n46), .S(
        Midori_rounds_roundReg_out2[33]), .Z(
        Midori_rounds_sub_sBox_PRINCE_8_g[4]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F4_U11 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F4_n45), .A2(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F4_n44), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F4_n46) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F4_U10 ( .A1(
        Midori_rounds_roundReg_out2[34]), .A2(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F4_n43), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F4_n45) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F4_U9 ( .A(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F4_n42), .B(
        Midori_rounds_roundReg_out2[33]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_f[2]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F4_U8 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F4_n41), .A2(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F4_n44), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F4_n42) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F4_U7 ( .A1(
        Midori_rounds_roundReg_out2[33]), .A2(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F4_n40), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_e[4]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F4_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F4_n41), .A2(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F4_n39), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F4_n40) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F4_U5 ( .A1(
        Midori_rounds_roundReg_out2[34]), .A2(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F4_n44), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F4_n39) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F4_U4 ( .A1(
        Midori_rounds_roundReg_out2[32]), .A2(Midori_rounds_roundReg_out1[35]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F4_n44) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F4_U3 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F4_n49), .A2(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F4_n43), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F4_n41) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F4_U2 ( .A1(
        Midori_rounds_roundReg_out2[32]), .A2(Midori_rounds_roundReg_out1[35]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F4_n43) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F4_U1 ( .A(
        Midori_rounds_roundReg_out2[34]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F4_n49) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F5_U12 ( .A(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F5_n33), .B(
        Midori_rounds_roundReg_out1[32]), .S(Midori_rounds_roundReg_out1[33]), 
        .Z(Midori_rounds_sub_sBox_PRINCE_8_g[5]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F5_U11 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F5_n32), .A2(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F5_n31), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F5_n33) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F5_U10 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F5_n30), .A2(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F5_n29), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F5_n31) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F5_U9 ( .A(
        Midori_rounds_roundReg_out1[32]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F5_n30) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F5_U8 ( .A(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F5_n28), .B(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F5_n27), .S(
        Midori_rounds_roundReg_out1[32]), .Z(
        Midori_rounds_sub_sBox_PRINCE_8_e[5]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F5_U7 ( .A1(
        Midori_rounds_roundReg_out1[33]), .A2(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F5_n29), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F5_n27) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F5_U6 ( .A1(
        Midori_rounds_roundReg_out2[35]), .A2(Midori_rounds_roundReg_out1[34]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F5_n29) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F5_U5 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F5_n28), .A2(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F5_n26), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_h[5]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F5_U4 ( .A1(
        Midori_rounds_roundReg_out2[35]), .A2(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F5_n25), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F5_n26) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F5_U3 ( .A1(
        Midori_rounds_roundReg_out1[33]), .A2(Midori_rounds_roundReg_out1[32]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F5_n25) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F5_U2 ( .A1(
        Midori_rounds_roundReg_out1[33]), .A2(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F5_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F5_n28) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F5_U1 ( .A1(
        Midori_rounds_roundReg_out2[35]), .A2(Midori_rounds_roundReg_out1[34]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F5_n32) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_U22 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_n62), .A2(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_n61), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_h[6]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_U21 ( .A1(
        Midori_rounds_roundReg_out2[33]), .A2(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_n60), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_n61) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_U20 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_n59), .A2(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_n58), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_n62) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_U19 ( .A(
        Midori_rounds_roundReg_out2[35]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_n58) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_U18 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_n57), .A2(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_n56), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_n59) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_U17 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_n57), .A2(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_n55), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_e[6]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_U16 ( .A(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_n54), .B(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_n53), .S(
        Midori_rounds_roundReg_out2[35]), .Z(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_n55) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_U15 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_n52), .A2(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_n51), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_f[3]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_U14 ( .A1(
        Midori_rounds_roundReg_out2[33]), .A2(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_n50), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_n51) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_U13 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_n49), .A2(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_n48), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_n52) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_U12 ( .A(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_n50), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_n48) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_U11 ( .A1(
        Midori_rounds_roundReg_out2[34]), .A2(Midori_rounds_roundReg_out1[32]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_n50) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_U10 ( .A(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_n47), .B(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_n57), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_n49) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_U9 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_n46), .A2(
        Midori_rounds_roundReg_out2[35]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_n47) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_U8 ( .A1(
        Midori_rounds_roundReg_out2[34]), .A2(Midori_rounds_roundReg_out1[32]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_n46) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_U7 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_n57), .A2(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_n45), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_g[6]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_U6 ( .A(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_n53), .B(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_n54), .S(
        Midori_rounds_roundReg_out2[35]), .Z(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_n45) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_U5 ( .A1(
        Midori_rounds_roundReg_out2[34]), .A2(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_n60), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_n54) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_U4 ( .A(
        Midori_rounds_roundReg_out1[32]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_n60) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_U3 ( .A1(
        Midori_rounds_roundReg_out1[32]), .A2(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_n56), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_n53) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_U2 ( .A(
        Midori_rounds_roundReg_out2[34]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_n56) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_U1 ( .A(
        Midori_rounds_roundReg_out2[33]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F6_n57) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F7_U11 ( .A(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F7_n35), .B(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F7_n34), .S(
        Midori_rounds_roundReg_out1[33]), .Z(
        Midori_rounds_sub_sBox_PRINCE_8_h[7]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F7_U10 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F7_n33), .A2(
        Midori_rounds_roundReg_out2[34]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F7_n34) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F7_U9 ( .A(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F7_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F7_n35) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F7_U8 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F7_n31), .A2(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F7_n30), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_g[7]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F7_U7 ( .A(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F7_n29), .B(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F7_n32), .S(
        Midori_rounds_roundReg_out2[34]), .Z(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F7_n30) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F7_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F7_n31), .A2(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F7_n28), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_e[7]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F7_U5 ( .A(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F7_n32), .B(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F7_n29), .S(
        Midori_rounds_roundReg_out2[34]), .Z(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F7_n28) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F7_U4 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F7_n33), .A2(
        Midori_rounds_roundReg_out2[32]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F7_n29) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F7_U3 ( .A1(
        Midori_rounds_roundReg_out2[32]), .A2(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F7_n33), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F7_n32) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F7_U2 ( .A(
        Midori_rounds_roundReg_out2[35]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F7_n33) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F7_U1 ( .A(
        Midori_rounds_roundReg_out1[33]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F7_n31) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F8_U17 ( .A(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F8_n44), .B(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F8_n43), .S(
        Midori_rounds_roundReg_out2[33]), .Z(
        Midori_rounds_sub_sBox_PRINCE_8_e[8]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F8_U16 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F8_n42), .A2(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F8_n41), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F8_n44) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F8_U15 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F8_n40), .A2(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F8_n39), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_h[8]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F8_U14 ( .A1(
        Midori_rounds_roundReg_out2[33]), .A2(Midori_rounds_roundReg_out1[34]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F8_n39) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F8_U13 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F8_n38), .A2(
        Midori_rounds_roundReg_out2[35]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F8_n40) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F8_U12 ( .A1(
        Midori_rounds_roundReg_out2[33]), .A2(Midori_rounds_roundReg_out2[32]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F8_n38) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F8_U11 ( .A1(
        Midori_rounds_roundReg_out2[33]), .A2(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F8_n37), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_g[8]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F8_U10 ( .A(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F8_n36), .B(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F8_n35), .S(
        Midori_rounds_roundReg_out2[35]), .Z(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F8_n37) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F8_U9 ( .A1(
        Midori_rounds_roundReg_out2[32]), .A2(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F8_n43), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F8_n35) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F8_U8 ( .A(
        Midori_rounds_roundReg_out1[34]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F8_n43) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F8_U7 ( .A1(
        Midori_rounds_roundReg_out1[34]), .A2(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F8_n34), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F8_n36) );
  AND2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F8_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F8_n33), .A2(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F8_n42), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_f[4]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F8_U5 ( .A1(
        Midori_rounds_roundReg_out2[32]), .A2(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F8_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F8_n42) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F8_U4 ( .A1(
        Midori_rounds_roundReg_out2[35]), .A2(Midori_rounds_roundReg_out1[34]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F8_n32) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F8_U3 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F8_n41), .A2(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F8_n34), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F8_n33) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F8_U2 ( .A(
        Midori_rounds_roundReg_out2[32]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F8_n34) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F8_U1 ( .A1(
        Midori_rounds_roundReg_out2[35]), .A2(Midori_rounds_roundReg_out1[34]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_8_Inst_N_F8_n41) );
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_8_InAff_output_reg_s_current_state_reg_0_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_8_e[1]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_8_e_reg[1]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_8_InAff_output_reg_s_current_state_reg_1_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_8_e[2]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_8_e_reg[2]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_8_InAff_output_reg_s_current_state_reg_2_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_8_e[3]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_8_e_reg[3]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_8_InAff_output_reg_s_current_state_reg_3_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_8_e[4]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_8_e_reg[4]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_8_InAff_output_reg_s_current_state_reg_4_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_8_e[5]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_8_e_reg[5]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_8_InAff_output_reg_s_current_state_reg_5_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_8_e[6]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_8_e_reg[6]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_8_InAff_output_reg_s_current_state_reg_6_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_8_e[7]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_8_e_reg[7]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_8_InAff_output_reg_s_current_state_reg_7_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_8_e[8]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_8_e_reg[8]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_8_InAff_output_reg_s_current_state_reg_8_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_8_f[1]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_8_f_reg[1]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_8_InAff_output_reg_s_current_state_reg_9_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_8_f[2]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_8_f_reg[2]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_8_InAff_output_reg_s_current_state_reg_10_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_8_f[3]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_8_f_reg[3]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_8_InAff_output_reg_s_current_state_reg_11_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_8_f[4]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_8_f_reg[4]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_8_InAff_output_reg_s_current_state_reg_12_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_8_g[1]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_8_g_reg[1]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_8_InAff_output_reg_s_current_state_reg_13_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_8_g[2]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_8_g_reg[2]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_8_InAff_output_reg_s_current_state_reg_14_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_8_g[3]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_8_g_reg[3]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_8_InAff_output_reg_s_current_state_reg_15_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_8_g[4]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_8_g_reg[4]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_8_InAff_output_reg_s_current_state_reg_16_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_8_g[5]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_8_g_reg[5]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_8_InAff_output_reg_s_current_state_reg_17_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_8_g[6]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_8_g_reg[6]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_8_InAff_output_reg_s_current_state_reg_18_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_8_g[7]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_8_g_reg[7]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_8_InAff_output_reg_s_current_state_reg_19_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_8_g[8]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_8_g_reg[8]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_8_InAff_output_reg_s_current_state_reg_20_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_8_h[1]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_8_h_reg[1]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_8_InAff_output_reg_s_current_state_reg_21_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_8_h[2]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_8_h_reg[2]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_8_InAff_output_reg_s_current_state_reg_22_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_8_h[3]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_8_h_reg[3]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_8_InAff_output_reg_s_current_state_reg_23_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_8_h[4]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_8_h_reg[4]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_8_InAff_output_reg_s_current_state_reg_24_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_8_h[5]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_8_h_reg[5]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_8_InAff_output_reg_s_current_state_reg_25_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_8_h[6]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_8_h_reg[6]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_8_InAff_output_reg_s_current_state_reg_26_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_8_h[7]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_8_h_reg[7]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_8_InAff_output_reg_s_current_state_reg_27_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_8_h[8]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_8_h_reg[8]) , .QN() ); 
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_L_XORInst1_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_L_XORInst1_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_L_XORInst1_n5), .ZN(output1[32])
         );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_L_XORInst1_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_8_e_reg[2]), .B(
        Midori_rounds_sub_sBox_PRINCE_8_e_reg[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_L_XORInst1_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_L_XORInst1_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_8_e_reg[3]), .B(
        Midori_rounds_sub_sBox_PRINCE_8_e_reg[4]), .Z(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_L_XORInst1_n6) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_L_XORInst2_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_L_XORInst2_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_L_XORInst2_n5), .ZN(
        Midori_rounds_SR_Result2[12]) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_L_XORInst2_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_8_e_reg[6]), .B(
        Midori_rounds_sub_sBox_PRINCE_8_e_reg[5]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_L_XORInst2_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_L_XORInst2_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_8_e_reg[7]), .B(
        Midori_rounds_sub_sBox_PRINCE_8_e_reg[8]), .Z(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_L_XORInst2_n6) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_L_XORInst3_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_8_f_reg[2]), .B(
        Midori_rounds_sub_sBox_PRINCE_8_f_reg[1]), .Z(output1[33]) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_L_XORInst4_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_8_f_reg[4]), .B(
        Midori_rounds_sub_sBox_PRINCE_8_f_reg[3]), .Z(
        Midori_rounds_SR_Result2[13]) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_L_XORInst5_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_L_XORInst5_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_L_XORInst5_n5), .ZN(output1[34])
         );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_L_XORInst5_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_8_g_reg[2]), .B(
        Midori_rounds_sub_sBox_PRINCE_8_g_reg[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_L_XORInst5_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_L_XORInst5_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_8_g_reg[3]), .B(
        Midori_rounds_sub_sBox_PRINCE_8_g_reg[4]), .Z(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_L_XORInst5_n6) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_L_XORInst6_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_L_XORInst6_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_L_XORInst6_n5), .ZN(
        Midori_rounds_SR_Result2[14]) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_L_XORInst6_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_8_g_reg[6]), .B(
        Midori_rounds_sub_sBox_PRINCE_8_g_reg[5]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_L_XORInst6_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_L_XORInst6_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_8_g_reg[7]), .B(
        Midori_rounds_sub_sBox_PRINCE_8_g_reg[8]), .Z(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_L_XORInst6_n6) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_L_XORInst7_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_L_XORInst7_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_L_XORInst7_n5), .ZN(output1[35])
         );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_L_XORInst7_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_8_h_reg[2]), .B(
        Midori_rounds_sub_sBox_PRINCE_8_h_reg[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_L_XORInst7_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_L_XORInst7_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_8_h_reg[3]), .B(
        Midori_rounds_sub_sBox_PRINCE_8_h_reg[4]), .Z(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_L_XORInst7_n6) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_L_XORInst8_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_L_XORInst8_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_L_XORInst8_n5), .ZN(
        Midori_rounds_SR_Result2[15]) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_L_XORInst8_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_8_h_reg[6]), .B(
        Midori_rounds_sub_sBox_PRINCE_8_h_reg[5]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_L_XORInst8_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_8_Inst_L_XORInst8_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_8_h_reg[7]), .B(
        Midori_rounds_sub_sBox_PRINCE_8_h_reg[8]), .Z(
        Midori_rounds_sub_sBox_PRINCE_8_Inst_L_XORInst8_n6) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F1_U17 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F1_n43), .A2(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F1_n42), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_g[1]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F1_U16 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F1_n41), .A2(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F1_n40), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F1_n42) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F1_U15 ( .A1(
        Midori_rounds_roundReg_out2[38]), .A2(Midori_rounds_roundReg_out1[39]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F1_n40) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F1_U14 ( .A(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F1_n39), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F1_n43) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F1_U13 ( .A(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F1_n38), .B(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F1_n37), .S(
        Midori_rounds_roundReg_out1[37]), .Z(
        Midori_rounds_sub_sBox_PRINCE_9_e[1]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F1_U12 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F1_n36), .A2(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F1_n41), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F1_n38) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F1_U11 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F1_n35), .A2(
        Midori_rounds_roundReg_out1[39]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F1_n41) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F1_U10 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F1_n34), .A2(
        Midori_rounds_roundReg_out2[38]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F1_n36) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F1_U9 ( .A1(
        Midori_rounds_roundReg_out1[39]), .A2(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F1_n35), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F1_n34) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F1_U8 ( .A(
        Midori_rounds_roundReg_out1[36]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F1_n35) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F1_U7 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F1_n33), .A2(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F1_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_h[1]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F1_U6 ( .A1(
        Midori_rounds_roundReg_out1[39]), .A2(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F1_n39), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F1_n32) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F1_U5 ( .A1(
        Midori_rounds_roundReg_out1[37]), .A2(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F1_n31), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F1_n39) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F1_U4 ( .A1(
        Midori_rounds_roundReg_out2[38]), .A2(Midori_rounds_roundReg_out1[36]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F1_n31) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F1_U3 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F1_n30), .A2(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F1_n37), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F1_n33) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F1_U2 ( .A(
        Midori_rounds_roundReg_out2[38]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F1_n37) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F1_U1 ( .A1(
        Midori_rounds_roundReg_out1[39]), .A2(Midori_rounds_roundReg_out1[36]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F1_n30) );
  AND2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F2_U12 ( .A1(
        Midori_rounds_roundReg_out2[37]), .A2(
        Midori_rounds_sub_sBox_PRINCE_9_f[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_e[2]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F2_U11 ( .A(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F2_n33), .B(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F2_n32), .S(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F2_n31), .Z(
        Midori_rounds_sub_sBox_PRINCE_9_f[1]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F2_U10 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F2_n30), .A2(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F2_n29), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_g[2]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F2_U9 ( .A(
        Midori_rounds_roundReg_out1[38]), .B(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F2_n28), .S(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F2_n31), .Z(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F2_n29) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F2_U8 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F2_n32), .A2(
        Midori_rounds_roundReg_out2[37]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F2_n30) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F2_U7 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F2_n27), .A2(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F2_n26), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_h[2]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F2_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F2_n33), .A2(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F2_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F2_n26) );
  AND2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F2_U5 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F2_n28), .A2(
        Midori_rounds_roundReg_out1[38]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F2_n32) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F2_U4 ( .A1(
        Midori_rounds_roundReg_out1[38]), .A2(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F2_n28), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F2_n33) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F2_U3 ( .A(
        Midori_rounds_roundReg_out1[36]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F2_n28) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F2_U2 ( .A1(
        Midori_rounds_roundReg_out2[37]), .A2(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F2_n31), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F2_n27) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F2_U1 ( .A(
        Midori_rounds_roundReg_out1[39]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F2_n31) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F3_U13 ( .A1(
        Midori_rounds_roundReg_out1[37]), .A2(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F3_n35), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_g[3]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F3_U12 ( .A(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F3_n34), .B(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F3_n33), .S(
        Midori_rounds_roundReg_out2[36]), .Z(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F3_n35) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F3_U11 ( .A1(
        Midori_rounds_roundReg_out1[39]), .A2(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F3_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F3_n33) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F3_U10 ( .A1(
        Midori_rounds_roundReg_out1[38]), .A2(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F3_n31), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F3_n34) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F3_U9 ( .A(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F3_n30), .B(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F3_n29), .S(
        Midori_rounds_roundReg_out1[38]), .Z(
        Midori_rounds_sub_sBox_PRINCE_9_e[3]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F3_U8 ( .A1(
        Midori_rounds_roundReg_out2[36]), .A2(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F3_n28), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F3_n29) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F3_U7 ( .A1(
        Midori_rounds_roundReg_out1[37]), .A2(Midori_rounds_roundReg_out1[39]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F3_n28) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F3_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F3_n27), .A2(
        Midori_rounds_roundReg_out1[39]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F3_n30) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F3_U5 ( .A1(
        Midori_rounds_roundReg_out1[37]), .A2(Midori_rounds_roundReg_out2[36]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F3_n27) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F3_U4 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F3_n31), .A2(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F3_n26), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_h[3]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F3_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F3_n32), .B(
        Midori_rounds_roundReg_out2[36]), .S(Midori_rounds_roundReg_out1[37]), 
        .Z(Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F3_n26) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F3_U2 ( .A(
        Midori_rounds_roundReg_out1[38]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F3_n32) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F3_U1 ( .A(
        Midori_rounds_roundReg_out1[39]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F3_n31) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F4_U15 ( .A(
        Midori_rounds_roundReg_out2[36]), .B(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F4_n49), .S(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F4_n48), .Z(
        Midori_rounds_sub_sBox_PRINCE_9_h[4]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F4_U14 ( .A1(
        Midori_rounds_roundReg_out1[39]), .A2(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F4_n47), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F4_n48) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F4_U13 ( .A(
        Midori_rounds_roundReg_out2[37]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F4_n47) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F4_U12 ( .A(
        Midori_rounds_roundReg_out2[36]), .B(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F4_n46), .S(
        Midori_rounds_roundReg_out2[37]), .Z(
        Midori_rounds_sub_sBox_PRINCE_9_g[4]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F4_U11 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F4_n45), .A2(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F4_n44), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F4_n46) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F4_U10 ( .A1(
        Midori_rounds_roundReg_out2[38]), .A2(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F4_n43), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F4_n45) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F4_U9 ( .A(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F4_n42), .B(
        Midori_rounds_roundReg_out2[37]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_f[2]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F4_U8 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F4_n41), .A2(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F4_n44), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F4_n42) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F4_U7 ( .A1(
        Midori_rounds_roundReg_out2[37]), .A2(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F4_n40), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_e[4]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F4_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F4_n41), .A2(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F4_n39), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F4_n40) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F4_U5 ( .A1(
        Midori_rounds_roundReg_out2[38]), .A2(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F4_n44), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F4_n39) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F4_U4 ( .A1(
        Midori_rounds_roundReg_out2[36]), .A2(Midori_rounds_roundReg_out1[39]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F4_n44) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F4_U3 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F4_n49), .A2(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F4_n43), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F4_n41) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F4_U2 ( .A1(
        Midori_rounds_roundReg_out2[36]), .A2(Midori_rounds_roundReg_out1[39]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F4_n43) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F4_U1 ( .A(
        Midori_rounds_roundReg_out2[38]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F4_n49) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F5_U12 ( .A(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F5_n33), .B(
        Midori_rounds_roundReg_out1[36]), .S(Midori_rounds_roundReg_out1[37]), 
        .Z(Midori_rounds_sub_sBox_PRINCE_9_g[5]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F5_U11 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F5_n32), .A2(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F5_n31), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F5_n33) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F5_U10 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F5_n30), .A2(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F5_n29), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F5_n31) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F5_U9 ( .A(
        Midori_rounds_roundReg_out1[36]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F5_n30) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F5_U8 ( .A(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F5_n28), .B(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F5_n27), .S(
        Midori_rounds_roundReg_out1[36]), .Z(
        Midori_rounds_sub_sBox_PRINCE_9_e[5]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F5_U7 ( .A1(
        Midori_rounds_roundReg_out1[37]), .A2(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F5_n29), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F5_n27) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F5_U6 ( .A1(
        Midori_rounds_roundReg_out2[39]), .A2(Midori_rounds_roundReg_out1[38]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F5_n29) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F5_U5 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F5_n28), .A2(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F5_n26), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_h[5]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F5_U4 ( .A1(
        Midori_rounds_roundReg_out2[39]), .A2(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F5_n25), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F5_n26) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F5_U3 ( .A1(
        Midori_rounds_roundReg_out1[37]), .A2(Midori_rounds_roundReg_out1[36]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F5_n25) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F5_U2 ( .A1(
        Midori_rounds_roundReg_out1[37]), .A2(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F5_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F5_n28) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F5_U1 ( .A1(
        Midori_rounds_roundReg_out2[39]), .A2(Midori_rounds_roundReg_out1[38]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F5_n32) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_U22 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_n62), .A2(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_n61), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_h[6]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_U21 ( .A1(
        Midori_rounds_roundReg_out2[37]), .A2(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_n60), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_n61) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_U20 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_n59), .A2(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_n58), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_n62) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_U19 ( .A(
        Midori_rounds_roundReg_out2[39]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_n58) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_U18 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_n57), .A2(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_n56), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_n59) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_U17 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_n57), .A2(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_n55), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_e[6]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_U16 ( .A(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_n54), .B(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_n53), .S(
        Midori_rounds_roundReg_out2[39]), .Z(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_n55) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_U15 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_n52), .A2(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_n51), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_f[3]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_U14 ( .A1(
        Midori_rounds_roundReg_out2[37]), .A2(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_n50), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_n51) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_U13 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_n49), .A2(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_n48), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_n52) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_U12 ( .A(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_n50), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_n48) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_U11 ( .A1(
        Midori_rounds_roundReg_out2[38]), .A2(Midori_rounds_roundReg_out1[36]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_n50) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_U10 ( .A(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_n47), .B(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_n57), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_n49) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_U9 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_n46), .A2(
        Midori_rounds_roundReg_out2[39]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_n47) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_U8 ( .A1(
        Midori_rounds_roundReg_out2[38]), .A2(Midori_rounds_roundReg_out1[36]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_n46) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_U7 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_n57), .A2(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_n45), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_g[6]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_U6 ( .A(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_n53), .B(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_n54), .S(
        Midori_rounds_roundReg_out2[39]), .Z(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_n45) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_U5 ( .A1(
        Midori_rounds_roundReg_out2[38]), .A2(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_n60), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_n54) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_U4 ( .A(
        Midori_rounds_roundReg_out1[36]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_n60) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_U3 ( .A1(
        Midori_rounds_roundReg_out1[36]), .A2(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_n56), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_n53) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_U2 ( .A(
        Midori_rounds_roundReg_out2[38]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_n56) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_U1 ( .A(
        Midori_rounds_roundReg_out2[37]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F6_n57) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F7_U11 ( .A(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F7_n35), .B(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F7_n34), .S(
        Midori_rounds_roundReg_out1[37]), .Z(
        Midori_rounds_sub_sBox_PRINCE_9_h[7]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F7_U10 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F7_n33), .A2(
        Midori_rounds_roundReg_out2[38]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F7_n34) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F7_U9 ( .A(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F7_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F7_n35) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F7_U8 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F7_n31), .A2(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F7_n30), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_g[7]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F7_U7 ( .A(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F7_n29), .B(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F7_n32), .S(
        Midori_rounds_roundReg_out2[38]), .Z(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F7_n30) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F7_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F7_n31), .A2(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F7_n28), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_e[7]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F7_U5 ( .A(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F7_n32), .B(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F7_n29), .S(
        Midori_rounds_roundReg_out2[38]), .Z(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F7_n28) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F7_U4 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F7_n33), .A2(
        Midori_rounds_roundReg_out2[36]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F7_n29) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F7_U3 ( .A1(
        Midori_rounds_roundReg_out2[36]), .A2(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F7_n33), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F7_n32) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F7_U2 ( .A(
        Midori_rounds_roundReg_out2[39]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F7_n33) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F7_U1 ( .A(
        Midori_rounds_roundReg_out1[37]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F7_n31) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F8_U17 ( .A(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F8_n44), .B(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F8_n43), .S(
        Midori_rounds_roundReg_out2[37]), .Z(
        Midori_rounds_sub_sBox_PRINCE_9_e[8]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F8_U16 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F8_n42), .A2(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F8_n41), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F8_n44) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F8_U15 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F8_n40), .A2(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F8_n39), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_h[8]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F8_U14 ( .A1(
        Midori_rounds_roundReg_out2[37]), .A2(Midori_rounds_roundReg_out1[38]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F8_n39) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F8_U13 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F8_n38), .A2(
        Midori_rounds_roundReg_out2[39]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F8_n40) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F8_U12 ( .A1(
        Midori_rounds_roundReg_out2[37]), .A2(Midori_rounds_roundReg_out2[36]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F8_n38) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F8_U11 ( .A1(
        Midori_rounds_roundReg_out2[37]), .A2(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F8_n37), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_g[8]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F8_U10 ( .A(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F8_n36), .B(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F8_n35), .S(
        Midori_rounds_roundReg_out2[39]), .Z(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F8_n37) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F8_U9 ( .A1(
        Midori_rounds_roundReg_out2[36]), .A2(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F8_n43), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F8_n35) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F8_U8 ( .A(
        Midori_rounds_roundReg_out1[38]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F8_n43) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F8_U7 ( .A1(
        Midori_rounds_roundReg_out1[38]), .A2(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F8_n34), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F8_n36) );
  AND2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F8_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F8_n33), .A2(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F8_n42), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_f[4]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F8_U5 ( .A1(
        Midori_rounds_roundReg_out2[36]), .A2(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F8_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F8_n42) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F8_U4 ( .A1(
        Midori_rounds_roundReg_out2[39]), .A2(Midori_rounds_roundReg_out1[38]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F8_n32) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F8_U3 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F8_n41), .A2(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F8_n34), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F8_n33) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F8_U2 ( .A(
        Midori_rounds_roundReg_out2[36]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F8_n34) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F8_U1 ( .A1(
        Midori_rounds_roundReg_out2[39]), .A2(Midori_rounds_roundReg_out1[38]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_9_Inst_N_F8_n41) );
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_9_InAff_output_reg_s_current_state_reg_0_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_9_e[1]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_9_e_reg[1]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_9_InAff_output_reg_s_current_state_reg_1_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_9_e[2]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_9_e_reg[2]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_9_InAff_output_reg_s_current_state_reg_2_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_9_e[3]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_9_e_reg[3]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_9_InAff_output_reg_s_current_state_reg_3_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_9_e[4]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_9_e_reg[4]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_9_InAff_output_reg_s_current_state_reg_4_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_9_e[5]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_9_e_reg[5]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_9_InAff_output_reg_s_current_state_reg_5_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_9_e[6]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_9_e_reg[6]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_9_InAff_output_reg_s_current_state_reg_6_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_9_e[7]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_9_e_reg[7]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_9_InAff_output_reg_s_current_state_reg_7_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_9_e[8]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_9_e_reg[8]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_9_InAff_output_reg_s_current_state_reg_8_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_9_f[1]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_9_f_reg[1]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_9_InAff_output_reg_s_current_state_reg_9_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_9_f[2]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_9_f_reg[2]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_9_InAff_output_reg_s_current_state_reg_10_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_9_f[3]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_9_f_reg[3]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_9_InAff_output_reg_s_current_state_reg_11_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_9_f[4]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_9_f_reg[4]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_9_InAff_output_reg_s_current_state_reg_12_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_9_g[1]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_9_g_reg[1]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_9_InAff_output_reg_s_current_state_reg_13_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_9_g[2]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_9_g_reg[2]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_9_InAff_output_reg_s_current_state_reg_14_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_9_g[3]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_9_g_reg[3]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_9_InAff_output_reg_s_current_state_reg_15_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_9_g[4]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_9_g_reg[4]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_9_InAff_output_reg_s_current_state_reg_16_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_9_g[5]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_9_g_reg[5]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_9_InAff_output_reg_s_current_state_reg_17_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_9_g[6]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_9_g_reg[6]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_9_InAff_output_reg_s_current_state_reg_18_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_9_g[7]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_9_g_reg[7]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_9_InAff_output_reg_s_current_state_reg_19_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_9_g[8]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_9_g_reg[8]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_9_InAff_output_reg_s_current_state_reg_20_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_9_h[1]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_9_h_reg[1]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_9_InAff_output_reg_s_current_state_reg_21_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_9_h[2]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_9_h_reg[2]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_9_InAff_output_reg_s_current_state_reg_22_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_9_h[3]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_9_h_reg[3]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_9_InAff_output_reg_s_current_state_reg_23_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_9_h[4]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_9_h_reg[4]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_9_InAff_output_reg_s_current_state_reg_24_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_9_h[5]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_9_h_reg[5]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_9_InAff_output_reg_s_current_state_reg_25_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_9_h[6]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_9_h_reg[6]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_9_InAff_output_reg_s_current_state_reg_26_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_9_h[7]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_9_h_reg[7]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_9_InAff_output_reg_s_current_state_reg_27_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_9_h[8]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_9_h_reg[8]) , .QN() ); 
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_L_XORInst1_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_L_XORInst1_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_L_XORInst1_n5), .ZN(output1[36])
         );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_L_XORInst1_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_9_e_reg[2]), .B(
        Midori_rounds_sub_sBox_PRINCE_9_e_reg[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_L_XORInst1_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_L_XORInst1_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_9_e_reg[3]), .B(
        Midori_rounds_sub_sBox_PRINCE_9_e_reg[4]), .Z(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_L_XORInst1_n6) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_L_XORInst2_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_L_XORInst2_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_L_XORInst2_n5), .ZN(
        Midori_rounds_SR_Result2[16]) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_L_XORInst2_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_9_e_reg[6]), .B(
        Midori_rounds_sub_sBox_PRINCE_9_e_reg[5]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_L_XORInst2_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_L_XORInst2_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_9_e_reg[7]), .B(
        Midori_rounds_sub_sBox_PRINCE_9_e_reg[8]), .Z(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_L_XORInst2_n6) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_L_XORInst3_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_9_f_reg[2]), .B(
        Midori_rounds_sub_sBox_PRINCE_9_f_reg[1]), .Z(output1[37]) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_L_XORInst4_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_9_f_reg[4]), .B(
        Midori_rounds_sub_sBox_PRINCE_9_f_reg[3]), .Z(
        Midori_rounds_SR_Result2[17]) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_L_XORInst5_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_L_XORInst5_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_L_XORInst5_n5), .ZN(output1[38])
         );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_L_XORInst5_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_9_g_reg[2]), .B(
        Midori_rounds_sub_sBox_PRINCE_9_g_reg[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_L_XORInst5_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_L_XORInst5_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_9_g_reg[3]), .B(
        Midori_rounds_sub_sBox_PRINCE_9_g_reg[4]), .Z(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_L_XORInst5_n6) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_L_XORInst6_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_L_XORInst6_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_L_XORInst6_n5), .ZN(
        Midori_rounds_SR_Result2[18]) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_L_XORInst6_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_9_g_reg[6]), .B(
        Midori_rounds_sub_sBox_PRINCE_9_g_reg[5]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_L_XORInst6_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_L_XORInst6_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_9_g_reg[7]), .B(
        Midori_rounds_sub_sBox_PRINCE_9_g_reg[8]), .Z(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_L_XORInst6_n6) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_L_XORInst7_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_L_XORInst7_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_L_XORInst7_n5), .ZN(output1[39])
         );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_L_XORInst7_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_9_h_reg[2]), .B(
        Midori_rounds_sub_sBox_PRINCE_9_h_reg[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_L_XORInst7_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_L_XORInst7_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_9_h_reg[3]), .B(
        Midori_rounds_sub_sBox_PRINCE_9_h_reg[4]), .Z(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_L_XORInst7_n6) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_L_XORInst8_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_L_XORInst8_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_L_XORInst8_n5), .ZN(
        Midori_rounds_SR_Result2[19]) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_L_XORInst8_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_9_h_reg[6]), .B(
        Midori_rounds_sub_sBox_PRINCE_9_h_reg[5]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_L_XORInst8_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_9_Inst_L_XORInst8_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_9_h_reg[7]), .B(
        Midori_rounds_sub_sBox_PRINCE_9_h_reg[8]), .Z(
        Midori_rounds_sub_sBox_PRINCE_9_Inst_L_XORInst8_n6) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F1_U17 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F1_n43), .A2(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F1_n42), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_g[1]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F1_U16 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F1_n41), .A2(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F1_n40), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F1_n42) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F1_U15 ( .A1(
        Midori_rounds_roundReg_out2[42]), .A2(Midori_rounds_roundReg_out1[43]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F1_n40) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F1_U14 ( .A(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F1_n39), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F1_n43) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F1_U13 ( .A(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F1_n38), .B(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F1_n37), .S(
        Midori_rounds_roundReg_out1[41]), .Z(
        Midori_rounds_sub_sBox_PRINCE_10_e[1]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F1_U12 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F1_n36), .A2(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F1_n41), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F1_n38) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F1_U11 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F1_n35), .A2(
        Midori_rounds_roundReg_out1[43]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F1_n41) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F1_U10 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F1_n34), .A2(
        Midori_rounds_roundReg_out2[42]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F1_n36) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F1_U9 ( .A1(
        Midori_rounds_roundReg_out1[43]), .A2(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F1_n35), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F1_n34) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F1_U8 ( .A(
        Midori_rounds_roundReg_out1[40]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F1_n35) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F1_U7 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F1_n33), .A2(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F1_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_h[1]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F1_U6 ( .A1(
        Midori_rounds_roundReg_out1[43]), .A2(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F1_n39), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F1_n32) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F1_U5 ( .A1(
        Midori_rounds_roundReg_out1[41]), .A2(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F1_n31), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F1_n39) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F1_U4 ( .A1(
        Midori_rounds_roundReg_out2[42]), .A2(Midori_rounds_roundReg_out1[40]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F1_n31) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F1_U3 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F1_n30), .A2(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F1_n37), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F1_n33) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F1_U2 ( .A(
        Midori_rounds_roundReg_out2[42]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F1_n37) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F1_U1 ( .A1(
        Midori_rounds_roundReg_out1[43]), .A2(Midori_rounds_roundReg_out1[40]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F1_n30) );
  AND2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F2_U12 ( .A1(
        Midori_rounds_roundReg_out2[41]), .A2(
        Midori_rounds_sub_sBox_PRINCE_10_f[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_e[2]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F2_U11 ( .A(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F2_n33), .B(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F2_n32), .S(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F2_n31), .Z(
        Midori_rounds_sub_sBox_PRINCE_10_f[1]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F2_U10 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F2_n30), .A2(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F2_n29), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_g[2]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F2_U9 ( .A(
        Midori_rounds_roundReg_out1[42]), .B(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F2_n28), .S(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F2_n31), .Z(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F2_n29) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F2_U8 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F2_n32), .A2(
        Midori_rounds_roundReg_out2[41]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F2_n30) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F2_U7 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F2_n27), .A2(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F2_n26), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_h[2]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F2_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F2_n33), .A2(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F2_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F2_n26) );
  AND2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F2_U5 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F2_n28), .A2(
        Midori_rounds_roundReg_out1[42]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F2_n32) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F2_U4 ( .A1(
        Midori_rounds_roundReg_out1[42]), .A2(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F2_n28), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F2_n33) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F2_U3 ( .A(
        Midori_rounds_roundReg_out1[40]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F2_n28) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F2_U2 ( .A1(
        Midori_rounds_roundReg_out2[41]), .A2(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F2_n31), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F2_n27) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F2_U1 ( .A(
        Midori_rounds_roundReg_out1[43]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F2_n31) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F3_U13 ( .A1(
        Midori_rounds_roundReg_out1[41]), .A2(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F3_n35), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_g[3]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F3_U12 ( .A(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F3_n34), .B(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F3_n33), .S(
        Midori_rounds_roundReg_out2[40]), .Z(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F3_n35) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F3_U11 ( .A1(
        Midori_rounds_roundReg_out1[43]), .A2(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F3_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F3_n33) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F3_U10 ( .A1(
        Midori_rounds_roundReg_out1[42]), .A2(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F3_n31), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F3_n34) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F3_U9 ( .A(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F3_n30), .B(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F3_n29), .S(
        Midori_rounds_roundReg_out1[42]), .Z(
        Midori_rounds_sub_sBox_PRINCE_10_e[3]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F3_U8 ( .A1(
        Midori_rounds_roundReg_out2[40]), .A2(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F3_n28), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F3_n29) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F3_U7 ( .A1(
        Midori_rounds_roundReg_out1[41]), .A2(Midori_rounds_roundReg_out1[43]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F3_n28) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F3_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F3_n27), .A2(
        Midori_rounds_roundReg_out1[43]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F3_n30) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F3_U5 ( .A1(
        Midori_rounds_roundReg_out1[41]), .A2(Midori_rounds_roundReg_out2[40]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F3_n27) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F3_U4 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F3_n31), .A2(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F3_n26), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_h[3]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F3_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F3_n32), .B(
        Midori_rounds_roundReg_out2[40]), .S(Midori_rounds_roundReg_out1[41]), 
        .Z(Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F3_n26) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F3_U2 ( .A(
        Midori_rounds_roundReg_out1[42]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F3_n32) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F3_U1 ( .A(
        Midori_rounds_roundReg_out1[43]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F3_n31) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F4_U15 ( .A(
        Midori_rounds_roundReg_out2[40]), .B(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F4_n49), .S(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F4_n48), .Z(
        Midori_rounds_sub_sBox_PRINCE_10_h[4]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F4_U14 ( .A1(
        Midori_rounds_roundReg_out1[43]), .A2(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F4_n47), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F4_n48) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F4_U13 ( .A(
        Midori_rounds_roundReg_out2[41]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F4_n47) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F4_U12 ( .A(
        Midori_rounds_roundReg_out2[40]), .B(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F4_n46), .S(
        Midori_rounds_roundReg_out2[41]), .Z(
        Midori_rounds_sub_sBox_PRINCE_10_g[4]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F4_U11 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F4_n45), .A2(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F4_n44), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F4_n46) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F4_U10 ( .A1(
        Midori_rounds_roundReg_out2[42]), .A2(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F4_n43), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F4_n45) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F4_U9 ( .A(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F4_n42), .B(
        Midori_rounds_roundReg_out2[41]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_f[2]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F4_U8 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F4_n41), .A2(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F4_n44), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F4_n42) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F4_U7 ( .A1(
        Midori_rounds_roundReg_out2[41]), .A2(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F4_n40), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_e[4]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F4_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F4_n41), .A2(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F4_n39), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F4_n40) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F4_U5 ( .A1(
        Midori_rounds_roundReg_out2[42]), .A2(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F4_n44), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F4_n39) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F4_U4 ( .A1(
        Midori_rounds_roundReg_out2[40]), .A2(Midori_rounds_roundReg_out1[43]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F4_n44) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F4_U3 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F4_n49), .A2(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F4_n43), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F4_n41) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F4_U2 ( .A1(
        Midori_rounds_roundReg_out2[40]), .A2(Midori_rounds_roundReg_out1[43]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F4_n43) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F4_U1 ( .A(
        Midori_rounds_roundReg_out2[42]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F4_n49) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F5_U12 ( .A(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F5_n33), .B(
        Midori_rounds_roundReg_out1[40]), .S(Midori_rounds_roundReg_out1[41]), 
        .Z(Midori_rounds_sub_sBox_PRINCE_10_g[5]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F5_U11 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F5_n32), .A2(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F5_n31), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F5_n33) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F5_U10 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F5_n30), .A2(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F5_n29), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F5_n31) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F5_U9 ( .A(
        Midori_rounds_roundReg_out1[40]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F5_n30) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F5_U8 ( .A(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F5_n28), .B(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F5_n27), .S(
        Midori_rounds_roundReg_out1[40]), .Z(
        Midori_rounds_sub_sBox_PRINCE_10_e[5]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F5_U7 ( .A1(
        Midori_rounds_roundReg_out1[41]), .A2(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F5_n29), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F5_n27) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F5_U6 ( .A1(
        Midori_rounds_roundReg_out2[43]), .A2(Midori_rounds_roundReg_out1[42]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F5_n29) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F5_U5 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F5_n28), .A2(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F5_n26), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_h[5]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F5_U4 ( .A1(
        Midori_rounds_roundReg_out2[43]), .A2(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F5_n25), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F5_n26) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F5_U3 ( .A1(
        Midori_rounds_roundReg_out1[41]), .A2(Midori_rounds_roundReg_out1[40]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F5_n25) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F5_U2 ( .A1(
        Midori_rounds_roundReg_out1[41]), .A2(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F5_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F5_n28) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F5_U1 ( .A1(
        Midori_rounds_roundReg_out2[43]), .A2(Midori_rounds_roundReg_out1[42]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F5_n32) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_U22 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_n62), .A2(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_n61), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_h[6]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_U21 ( .A1(
        Midori_rounds_roundReg_out2[41]), .A2(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_n60), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_n61) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_U20 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_n59), .A2(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_n58), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_n62) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_U19 ( .A(
        Midori_rounds_roundReg_out2[43]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_n58) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_U18 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_n57), .A2(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_n56), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_n59) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_U17 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_n57), .A2(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_n55), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_e[6]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_U16 ( .A(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_n54), .B(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_n53), .S(
        Midori_rounds_roundReg_out2[43]), .Z(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_n55) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_U15 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_n52), .A2(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_n51), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_f[3]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_U14 ( .A1(
        Midori_rounds_roundReg_out2[41]), .A2(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_n50), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_n51) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_U13 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_n49), .A2(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_n48), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_n52) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_U12 ( .A(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_n50), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_n48) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_U11 ( .A1(
        Midori_rounds_roundReg_out2[42]), .A2(Midori_rounds_roundReg_out1[40]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_n50) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_U10 ( .A(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_n47), .B(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_n57), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_n49) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_U9 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_n46), .A2(
        Midori_rounds_roundReg_out2[43]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_n47) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_U8 ( .A1(
        Midori_rounds_roundReg_out2[42]), .A2(Midori_rounds_roundReg_out1[40]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_n46) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_U7 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_n57), .A2(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_n45), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_g[6]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_U6 ( .A(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_n53), .B(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_n54), .S(
        Midori_rounds_roundReg_out2[43]), .Z(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_n45) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_U5 ( .A1(
        Midori_rounds_roundReg_out2[42]), .A2(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_n60), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_n54) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_U4 ( .A(
        Midori_rounds_roundReg_out1[40]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_n60) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_U3 ( .A1(
        Midori_rounds_roundReg_out1[40]), .A2(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_n56), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_n53) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_U2 ( .A(
        Midori_rounds_roundReg_out2[42]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_n56) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_U1 ( .A(
        Midori_rounds_roundReg_out2[41]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F6_n57) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F7_U11 ( .A(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F7_n35), .B(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F7_n34), .S(
        Midori_rounds_roundReg_out1[41]), .Z(
        Midori_rounds_sub_sBox_PRINCE_10_h[7]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F7_U10 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F7_n33), .A2(
        Midori_rounds_roundReg_out2[42]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F7_n34) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F7_U9 ( .A(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F7_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F7_n35) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F7_U8 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F7_n31), .A2(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F7_n30), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_g[7]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F7_U7 ( .A(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F7_n29), .B(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F7_n32), .S(
        Midori_rounds_roundReg_out2[42]), .Z(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F7_n30) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F7_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F7_n31), .A2(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F7_n28), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_e[7]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F7_U5 ( .A(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F7_n32), .B(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F7_n29), .S(
        Midori_rounds_roundReg_out2[42]), .Z(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F7_n28) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F7_U4 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F7_n33), .A2(
        Midori_rounds_roundReg_out2[40]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F7_n29) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F7_U3 ( .A1(
        Midori_rounds_roundReg_out2[40]), .A2(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F7_n33), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F7_n32) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F7_U2 ( .A(
        Midori_rounds_roundReg_out2[43]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F7_n33) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F7_U1 ( .A(
        Midori_rounds_roundReg_out1[41]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F7_n31) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F8_U17 ( .A(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F8_n44), .B(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F8_n43), .S(
        Midori_rounds_roundReg_out2[41]), .Z(
        Midori_rounds_sub_sBox_PRINCE_10_e[8]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F8_U16 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F8_n42), .A2(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F8_n41), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F8_n44) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F8_U15 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F8_n40), .A2(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F8_n39), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_h[8]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F8_U14 ( .A1(
        Midori_rounds_roundReg_out2[41]), .A2(Midori_rounds_roundReg_out1[42]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F8_n39) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F8_U13 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F8_n38), .A2(
        Midori_rounds_roundReg_out2[43]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F8_n40) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F8_U12 ( .A1(
        Midori_rounds_roundReg_out2[41]), .A2(Midori_rounds_roundReg_out2[40]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F8_n38) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F8_U11 ( .A1(
        Midori_rounds_roundReg_out2[41]), .A2(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F8_n37), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_g[8]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F8_U10 ( .A(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F8_n36), .B(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F8_n35), .S(
        Midori_rounds_roundReg_out2[43]), .Z(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F8_n37) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F8_U9 ( .A1(
        Midori_rounds_roundReg_out2[40]), .A2(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F8_n43), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F8_n35) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F8_U8 ( .A(
        Midori_rounds_roundReg_out1[42]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F8_n43) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F8_U7 ( .A1(
        Midori_rounds_roundReg_out1[42]), .A2(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F8_n34), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F8_n36) );
  AND2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F8_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F8_n33), .A2(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F8_n42), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_f[4]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F8_U5 ( .A1(
        Midori_rounds_roundReg_out2[40]), .A2(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F8_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F8_n42) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F8_U4 ( .A1(
        Midori_rounds_roundReg_out2[43]), .A2(Midori_rounds_roundReg_out1[42]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F8_n32) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F8_U3 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F8_n41), .A2(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F8_n34), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F8_n33) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F8_U2 ( .A(
        Midori_rounds_roundReg_out2[40]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F8_n34) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F8_U1 ( .A1(
        Midori_rounds_roundReg_out2[43]), .A2(Midori_rounds_roundReg_out1[42]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_10_Inst_N_F8_n41) );
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_10_InAff_output_reg_s_current_state_reg_0_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_10_e[1]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_10_e_reg[1]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_10_InAff_output_reg_s_current_state_reg_1_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_10_e[2]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_10_e_reg[2]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_10_InAff_output_reg_s_current_state_reg_2_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_10_e[3]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_10_e_reg[3]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_10_InAff_output_reg_s_current_state_reg_3_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_10_e[4]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_10_e_reg[4]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_10_InAff_output_reg_s_current_state_reg_4_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_10_e[5]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_10_e_reg[5]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_10_InAff_output_reg_s_current_state_reg_5_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_10_e[6]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_10_e_reg[6]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_10_InAff_output_reg_s_current_state_reg_6_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_10_e[7]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_10_e_reg[7]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_10_InAff_output_reg_s_current_state_reg_7_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_10_e[8]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_10_e_reg[8]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_10_InAff_output_reg_s_current_state_reg_8_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_10_f[1]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_10_f_reg[1]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_10_InAff_output_reg_s_current_state_reg_9_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_10_f[2]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_10_f_reg[2]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_10_InAff_output_reg_s_current_state_reg_10_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_10_f[3]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_10_f_reg[3]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_10_InAff_output_reg_s_current_state_reg_11_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_10_f[4]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_10_f_reg[4]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_10_InAff_output_reg_s_current_state_reg_12_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_10_g[1]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_10_g_reg[1]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_10_InAff_output_reg_s_current_state_reg_13_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_10_g[2]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_10_g_reg[2]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_10_InAff_output_reg_s_current_state_reg_14_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_10_g[3]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_10_g_reg[3]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_10_InAff_output_reg_s_current_state_reg_15_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_10_g[4]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_10_g_reg[4]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_10_InAff_output_reg_s_current_state_reg_16_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_10_g[5]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_10_g_reg[5]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_10_InAff_output_reg_s_current_state_reg_17_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_10_g[6]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_10_g_reg[6]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_10_InAff_output_reg_s_current_state_reg_18_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_10_g[7]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_10_g_reg[7]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_10_InAff_output_reg_s_current_state_reg_19_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_10_g[8]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_10_g_reg[8]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_10_InAff_output_reg_s_current_state_reg_20_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_10_h[1]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_10_h_reg[1]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_10_InAff_output_reg_s_current_state_reg_21_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_10_h[2]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_10_h_reg[2]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_10_InAff_output_reg_s_current_state_reg_22_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_10_h[3]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_10_h_reg[3]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_10_InAff_output_reg_s_current_state_reg_23_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_10_h[4]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_10_h_reg[4]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_10_InAff_output_reg_s_current_state_reg_24_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_10_h[5]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_10_h_reg[5]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_10_InAff_output_reg_s_current_state_reg_25_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_10_h[6]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_10_h_reg[6]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_10_InAff_output_reg_s_current_state_reg_26_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_10_h[7]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_10_h_reg[7]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_10_InAff_output_reg_s_current_state_reg_27_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_10_h[8]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_10_h_reg[8]) , .QN() ); 
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_L_XORInst1_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_L_XORInst1_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_L_XORInst1_n5), .ZN(output1[40])
         );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_L_XORInst1_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_10_e_reg[2]), .B(
        Midori_rounds_sub_sBox_PRINCE_10_e_reg[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_L_XORInst1_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_L_XORInst1_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_10_e_reg[3]), .B(
        Midori_rounds_sub_sBox_PRINCE_10_e_reg[4]), .Z(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_L_XORInst1_n6) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_L_XORInst2_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_L_XORInst2_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_L_XORInst2_n5), .ZN(
        Midori_rounds_SR_Result2[52]) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_L_XORInst2_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_10_e_reg[6]), .B(
        Midori_rounds_sub_sBox_PRINCE_10_e_reg[5]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_L_XORInst2_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_L_XORInst2_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_10_e_reg[7]), .B(
        Midori_rounds_sub_sBox_PRINCE_10_e_reg[8]), .Z(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_L_XORInst2_n6) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_L_XORInst3_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_10_f_reg[2]), .B(
        Midori_rounds_sub_sBox_PRINCE_10_f_reg[1]), .Z(output1[41]) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_L_XORInst4_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_10_f_reg[4]), .B(
        Midori_rounds_sub_sBox_PRINCE_10_f_reg[3]), .Z(
        Midori_rounds_SR_Result2[53]) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_L_XORInst5_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_L_XORInst5_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_L_XORInst5_n5), .ZN(output1[42])
         );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_L_XORInst5_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_10_g_reg[2]), .B(
        Midori_rounds_sub_sBox_PRINCE_10_g_reg[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_L_XORInst5_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_L_XORInst5_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_10_g_reg[3]), .B(
        Midori_rounds_sub_sBox_PRINCE_10_g_reg[4]), .Z(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_L_XORInst5_n6) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_L_XORInst6_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_L_XORInst6_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_L_XORInst6_n5), .ZN(
        Midori_rounds_SR_Result2[54]) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_L_XORInst6_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_10_g_reg[6]), .B(
        Midori_rounds_sub_sBox_PRINCE_10_g_reg[5]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_L_XORInst6_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_L_XORInst6_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_10_g_reg[7]), .B(
        Midori_rounds_sub_sBox_PRINCE_10_g_reg[8]), .Z(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_L_XORInst6_n6) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_L_XORInst7_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_L_XORInst7_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_L_XORInst7_n5), .ZN(output1[43])
         );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_L_XORInst7_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_10_h_reg[2]), .B(
        Midori_rounds_sub_sBox_PRINCE_10_h_reg[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_L_XORInst7_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_L_XORInst7_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_10_h_reg[3]), .B(
        Midori_rounds_sub_sBox_PRINCE_10_h_reg[4]), .Z(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_L_XORInst7_n6) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_L_XORInst8_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_L_XORInst8_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_L_XORInst8_n5), .ZN(
        Midori_rounds_SR_Result2[55]) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_L_XORInst8_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_10_h_reg[6]), .B(
        Midori_rounds_sub_sBox_PRINCE_10_h_reg[5]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_L_XORInst8_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_10_Inst_L_XORInst8_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_10_h_reg[7]), .B(
        Midori_rounds_sub_sBox_PRINCE_10_h_reg[8]), .Z(
        Midori_rounds_sub_sBox_PRINCE_10_Inst_L_XORInst8_n6) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F1_U17 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F1_n43), .A2(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F1_n42), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_g[1]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F1_U16 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F1_n41), .A2(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F1_n40), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F1_n42) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F1_U15 ( .A1(
        Midori_rounds_roundReg_out2[46]), .A2(Midori_rounds_roundReg_out1[47]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F1_n40) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F1_U14 ( .A(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F1_n39), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F1_n43) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F1_U13 ( .A(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F1_n38), .B(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F1_n37), .S(
        Midori_rounds_roundReg_out1[45]), .Z(
        Midori_rounds_sub_sBox_PRINCE_11_e[1]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F1_U12 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F1_n36), .A2(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F1_n41), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F1_n38) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F1_U11 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F1_n35), .A2(
        Midori_rounds_roundReg_out1[47]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F1_n41) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F1_U10 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F1_n34), .A2(
        Midori_rounds_roundReg_out2[46]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F1_n36) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F1_U9 ( .A1(
        Midori_rounds_roundReg_out1[47]), .A2(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F1_n35), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F1_n34) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F1_U8 ( .A(
        Midori_rounds_roundReg_out1[44]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F1_n35) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F1_U7 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F1_n33), .A2(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F1_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_h[1]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F1_U6 ( .A1(
        Midori_rounds_roundReg_out1[47]), .A2(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F1_n39), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F1_n32) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F1_U5 ( .A1(
        Midori_rounds_roundReg_out1[45]), .A2(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F1_n31), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F1_n39) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F1_U4 ( .A1(
        Midori_rounds_roundReg_out2[46]), .A2(Midori_rounds_roundReg_out1[44]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F1_n31) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F1_U3 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F1_n30), .A2(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F1_n37), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F1_n33) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F1_U2 ( .A(
        Midori_rounds_roundReg_out2[46]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F1_n37) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F1_U1 ( .A1(
        Midori_rounds_roundReg_out1[47]), .A2(Midori_rounds_roundReg_out1[44]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F1_n30) );
  AND2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F2_U12 ( .A1(
        Midori_rounds_roundReg_out2[45]), .A2(
        Midori_rounds_sub_sBox_PRINCE_11_f[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_e[2]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F2_U11 ( .A(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F2_n33), .B(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F2_n32), .S(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F2_n31), .Z(
        Midori_rounds_sub_sBox_PRINCE_11_f[1]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F2_U10 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F2_n30), .A2(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F2_n29), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_g[2]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F2_U9 ( .A(
        Midori_rounds_roundReg_out1[46]), .B(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F2_n28), .S(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F2_n31), .Z(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F2_n29) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F2_U8 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F2_n32), .A2(
        Midori_rounds_roundReg_out2[45]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F2_n30) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F2_U7 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F2_n27), .A2(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F2_n26), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_h[2]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F2_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F2_n33), .A2(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F2_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F2_n26) );
  AND2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F2_U5 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F2_n28), .A2(
        Midori_rounds_roundReg_out1[46]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F2_n32) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F2_U4 ( .A1(
        Midori_rounds_roundReg_out1[46]), .A2(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F2_n28), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F2_n33) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F2_U3 ( .A(
        Midori_rounds_roundReg_out1[44]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F2_n28) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F2_U2 ( .A1(
        Midori_rounds_roundReg_out2[45]), .A2(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F2_n31), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F2_n27) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F2_U1 ( .A(
        Midori_rounds_roundReg_out1[47]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F2_n31) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F3_U13 ( .A1(
        Midori_rounds_roundReg_out1[45]), .A2(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F3_n35), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_g[3]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F3_U12 ( .A(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F3_n34), .B(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F3_n33), .S(
        Midori_rounds_roundReg_out2[44]), .Z(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F3_n35) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F3_U11 ( .A1(
        Midori_rounds_roundReg_out1[47]), .A2(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F3_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F3_n33) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F3_U10 ( .A1(
        Midori_rounds_roundReg_out1[46]), .A2(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F3_n31), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F3_n34) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F3_U9 ( .A(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F3_n30), .B(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F3_n29), .S(
        Midori_rounds_roundReg_out1[46]), .Z(
        Midori_rounds_sub_sBox_PRINCE_11_e[3]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F3_U8 ( .A1(
        Midori_rounds_roundReg_out2[44]), .A2(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F3_n28), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F3_n29) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F3_U7 ( .A1(
        Midori_rounds_roundReg_out1[45]), .A2(Midori_rounds_roundReg_out1[47]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F3_n28) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F3_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F3_n27), .A2(
        Midori_rounds_roundReg_out1[47]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F3_n30) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F3_U5 ( .A1(
        Midori_rounds_roundReg_out1[45]), .A2(Midori_rounds_roundReg_out2[44]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F3_n27) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F3_U4 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F3_n31), .A2(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F3_n26), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_h[3]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F3_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F3_n32), .B(
        Midori_rounds_roundReg_out2[44]), .S(Midori_rounds_roundReg_out1[45]), 
        .Z(Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F3_n26) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F3_U2 ( .A(
        Midori_rounds_roundReg_out1[46]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F3_n32) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F3_U1 ( .A(
        Midori_rounds_roundReg_out1[47]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F3_n31) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F4_U15 ( .A(
        Midori_rounds_roundReg_out2[44]), .B(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F4_n49), .S(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F4_n48), .Z(
        Midori_rounds_sub_sBox_PRINCE_11_h[4]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F4_U14 ( .A1(
        Midori_rounds_roundReg_out1[47]), .A2(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F4_n47), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F4_n48) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F4_U13 ( .A(
        Midori_rounds_roundReg_out2[45]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F4_n47) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F4_U12 ( .A(
        Midori_rounds_roundReg_out2[44]), .B(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F4_n46), .S(
        Midori_rounds_roundReg_out2[45]), .Z(
        Midori_rounds_sub_sBox_PRINCE_11_g[4]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F4_U11 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F4_n45), .A2(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F4_n44), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F4_n46) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F4_U10 ( .A1(
        Midori_rounds_roundReg_out2[46]), .A2(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F4_n43), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F4_n45) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F4_U9 ( .A(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F4_n42), .B(
        Midori_rounds_roundReg_out2[45]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_f[2]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F4_U8 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F4_n41), .A2(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F4_n44), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F4_n42) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F4_U7 ( .A1(
        Midori_rounds_roundReg_out2[45]), .A2(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F4_n40), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_e[4]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F4_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F4_n41), .A2(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F4_n39), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F4_n40) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F4_U5 ( .A1(
        Midori_rounds_roundReg_out2[46]), .A2(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F4_n44), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F4_n39) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F4_U4 ( .A1(
        Midori_rounds_roundReg_out2[44]), .A2(Midori_rounds_roundReg_out1[47]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F4_n44) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F4_U3 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F4_n49), .A2(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F4_n43), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F4_n41) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F4_U2 ( .A1(
        Midori_rounds_roundReg_out2[44]), .A2(Midori_rounds_roundReg_out1[47]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F4_n43) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F4_U1 ( .A(
        Midori_rounds_roundReg_out2[46]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F4_n49) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F5_U12 ( .A(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F5_n33), .B(
        Midori_rounds_roundReg_out1[44]), .S(Midori_rounds_roundReg_out1[45]), 
        .Z(Midori_rounds_sub_sBox_PRINCE_11_g[5]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F5_U11 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F5_n32), .A2(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F5_n31), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F5_n33) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F5_U10 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F5_n30), .A2(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F5_n29), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F5_n31) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F5_U9 ( .A(
        Midori_rounds_roundReg_out1[44]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F5_n30) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F5_U8 ( .A(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F5_n28), .B(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F5_n27), .S(
        Midori_rounds_roundReg_out1[44]), .Z(
        Midori_rounds_sub_sBox_PRINCE_11_e[5]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F5_U7 ( .A1(
        Midori_rounds_roundReg_out1[45]), .A2(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F5_n29), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F5_n27) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F5_U6 ( .A1(
        Midori_rounds_roundReg_out2[47]), .A2(Midori_rounds_roundReg_out1[46]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F5_n29) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F5_U5 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F5_n28), .A2(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F5_n26), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_h[5]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F5_U4 ( .A1(
        Midori_rounds_roundReg_out2[47]), .A2(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F5_n25), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F5_n26) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F5_U3 ( .A1(
        Midori_rounds_roundReg_out1[45]), .A2(Midori_rounds_roundReg_out1[44]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F5_n25) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F5_U2 ( .A1(
        Midori_rounds_roundReg_out1[45]), .A2(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F5_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F5_n28) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F5_U1 ( .A1(
        Midori_rounds_roundReg_out2[47]), .A2(Midori_rounds_roundReg_out1[46]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F5_n32) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_U22 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_n62), .A2(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_n61), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_h[6]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_U21 ( .A1(
        Midori_rounds_roundReg_out2[45]), .A2(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_n60), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_n61) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_U20 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_n59), .A2(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_n58), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_n62) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_U19 ( .A(
        Midori_rounds_roundReg_out2[47]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_n58) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_U18 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_n57), .A2(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_n56), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_n59) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_U17 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_n57), .A2(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_n55), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_e[6]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_U16 ( .A(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_n54), .B(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_n53), .S(
        Midori_rounds_roundReg_out2[47]), .Z(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_n55) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_U15 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_n52), .A2(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_n51), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_f[3]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_U14 ( .A1(
        Midori_rounds_roundReg_out2[45]), .A2(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_n50), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_n51) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_U13 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_n49), .A2(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_n48), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_n52) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_U12 ( .A(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_n50), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_n48) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_U11 ( .A1(
        Midori_rounds_roundReg_out2[46]), .A2(Midori_rounds_roundReg_out1[44]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_n50) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_U10 ( .A(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_n47), .B(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_n57), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_n49) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_U9 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_n46), .A2(
        Midori_rounds_roundReg_out2[47]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_n47) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_U8 ( .A1(
        Midori_rounds_roundReg_out2[46]), .A2(Midori_rounds_roundReg_out1[44]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_n46) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_U7 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_n57), .A2(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_n45), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_g[6]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_U6 ( .A(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_n53), .B(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_n54), .S(
        Midori_rounds_roundReg_out2[47]), .Z(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_n45) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_U5 ( .A1(
        Midori_rounds_roundReg_out2[46]), .A2(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_n60), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_n54) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_U4 ( .A(
        Midori_rounds_roundReg_out1[44]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_n60) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_U3 ( .A1(
        Midori_rounds_roundReg_out1[44]), .A2(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_n56), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_n53) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_U2 ( .A(
        Midori_rounds_roundReg_out2[46]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_n56) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_U1 ( .A(
        Midori_rounds_roundReg_out2[45]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F6_n57) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F7_U11 ( .A(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F7_n35), .B(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F7_n34), .S(
        Midori_rounds_roundReg_out1[45]), .Z(
        Midori_rounds_sub_sBox_PRINCE_11_h[7]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F7_U10 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F7_n33), .A2(
        Midori_rounds_roundReg_out2[46]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F7_n34) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F7_U9 ( .A(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F7_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F7_n35) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F7_U8 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F7_n31), .A2(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F7_n30), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_g[7]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F7_U7 ( .A(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F7_n29), .B(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F7_n32), .S(
        Midori_rounds_roundReg_out2[46]), .Z(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F7_n30) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F7_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F7_n31), .A2(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F7_n28), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_e[7]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F7_U5 ( .A(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F7_n32), .B(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F7_n29), .S(
        Midori_rounds_roundReg_out2[46]), .Z(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F7_n28) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F7_U4 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F7_n33), .A2(
        Midori_rounds_roundReg_out2[44]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F7_n29) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F7_U3 ( .A1(
        Midori_rounds_roundReg_out2[44]), .A2(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F7_n33), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F7_n32) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F7_U2 ( .A(
        Midori_rounds_roundReg_out2[47]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F7_n33) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F7_U1 ( .A(
        Midori_rounds_roundReg_out1[45]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F7_n31) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F8_U17 ( .A(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F8_n44), .B(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F8_n43), .S(
        Midori_rounds_roundReg_out2[45]), .Z(
        Midori_rounds_sub_sBox_PRINCE_11_e[8]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F8_U16 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F8_n42), .A2(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F8_n41), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F8_n44) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F8_U15 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F8_n40), .A2(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F8_n39), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_h[8]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F8_U14 ( .A1(
        Midori_rounds_roundReg_out2[45]), .A2(Midori_rounds_roundReg_out1[46]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F8_n39) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F8_U13 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F8_n38), .A2(
        Midori_rounds_roundReg_out2[47]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F8_n40) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F8_U12 ( .A1(
        Midori_rounds_roundReg_out2[45]), .A2(Midori_rounds_roundReg_out2[44]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F8_n38) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F8_U11 ( .A1(
        Midori_rounds_roundReg_out2[45]), .A2(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F8_n37), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_g[8]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F8_U10 ( .A(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F8_n36), .B(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F8_n35), .S(
        Midori_rounds_roundReg_out2[47]), .Z(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F8_n37) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F8_U9 ( .A1(
        Midori_rounds_roundReg_out2[44]), .A2(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F8_n43), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F8_n35) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F8_U8 ( .A(
        Midori_rounds_roundReg_out1[46]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F8_n43) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F8_U7 ( .A1(
        Midori_rounds_roundReg_out1[46]), .A2(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F8_n34), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F8_n36) );
  AND2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F8_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F8_n33), .A2(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F8_n42), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_f[4]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F8_U5 ( .A1(
        Midori_rounds_roundReg_out2[44]), .A2(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F8_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F8_n42) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F8_U4 ( .A1(
        Midori_rounds_roundReg_out2[47]), .A2(Midori_rounds_roundReg_out1[46]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F8_n32) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F8_U3 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F8_n41), .A2(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F8_n34), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F8_n33) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F8_U2 ( .A(
        Midori_rounds_roundReg_out2[44]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F8_n34) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F8_U1 ( .A1(
        Midori_rounds_roundReg_out2[47]), .A2(Midori_rounds_roundReg_out1[46]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_11_Inst_N_F8_n41) );
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_11_InAff_output_reg_s_current_state_reg_0_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_11_e[1]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_11_e_reg[1]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_11_InAff_output_reg_s_current_state_reg_1_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_11_e[2]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_11_e_reg[2]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_11_InAff_output_reg_s_current_state_reg_2_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_11_e[3]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_11_e_reg[3]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_11_InAff_output_reg_s_current_state_reg_3_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_11_e[4]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_11_e_reg[4]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_11_InAff_output_reg_s_current_state_reg_4_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_11_e[5]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_11_e_reg[5]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_11_InAff_output_reg_s_current_state_reg_5_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_11_e[6]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_11_e_reg[6]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_11_InAff_output_reg_s_current_state_reg_6_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_11_e[7]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_11_e_reg[7]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_11_InAff_output_reg_s_current_state_reg_7_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_11_e[8]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_11_e_reg[8]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_11_InAff_output_reg_s_current_state_reg_8_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_11_f[1]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_11_f_reg[1]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_11_InAff_output_reg_s_current_state_reg_9_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_11_f[2]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_11_f_reg[2]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_11_InAff_output_reg_s_current_state_reg_10_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_11_f[3]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_11_f_reg[3]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_11_InAff_output_reg_s_current_state_reg_11_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_11_f[4]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_11_f_reg[4]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_11_InAff_output_reg_s_current_state_reg_12_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_11_g[1]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_11_g_reg[1]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_11_InAff_output_reg_s_current_state_reg_13_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_11_g[2]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_11_g_reg[2]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_11_InAff_output_reg_s_current_state_reg_14_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_11_g[3]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_11_g_reg[3]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_11_InAff_output_reg_s_current_state_reg_15_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_11_g[4]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_11_g_reg[4]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_11_InAff_output_reg_s_current_state_reg_16_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_11_g[5]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_11_g_reg[5]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_11_InAff_output_reg_s_current_state_reg_17_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_11_g[6]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_11_g_reg[6]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_11_InAff_output_reg_s_current_state_reg_18_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_11_g[7]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_11_g_reg[7]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_11_InAff_output_reg_s_current_state_reg_19_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_11_g[8]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_11_g_reg[8]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_11_InAff_output_reg_s_current_state_reg_20_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_11_h[1]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_11_h_reg[1]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_11_InAff_output_reg_s_current_state_reg_21_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_11_h[2]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_11_h_reg[2]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_11_InAff_output_reg_s_current_state_reg_22_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_11_h[3]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_11_h_reg[3]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_11_InAff_output_reg_s_current_state_reg_23_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_11_h[4]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_11_h_reg[4]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_11_InAff_output_reg_s_current_state_reg_24_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_11_h[5]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_11_h_reg[5]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_11_InAff_output_reg_s_current_state_reg_25_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_11_h[6]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_11_h_reg[6]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_11_InAff_output_reg_s_current_state_reg_26_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_11_h[7]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_11_h_reg[7]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_11_InAff_output_reg_s_current_state_reg_27_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_11_h[8]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_11_h_reg[8]) , .QN() ); 
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_L_XORInst1_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_L_XORInst1_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_L_XORInst1_n5), .ZN(output1[44])
         );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_L_XORInst1_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_11_e_reg[2]), .B(
        Midori_rounds_sub_sBox_PRINCE_11_e_reg[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_L_XORInst1_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_L_XORInst1_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_11_e_reg[3]), .B(
        Midori_rounds_sub_sBox_PRINCE_11_e_reg[4]), .Z(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_L_XORInst1_n6) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_L_XORInst2_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_L_XORInst2_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_L_XORInst2_n5), .ZN(
        Midori_rounds_SR_Result2[40]) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_L_XORInst2_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_11_e_reg[6]), .B(
        Midori_rounds_sub_sBox_PRINCE_11_e_reg[5]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_L_XORInst2_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_L_XORInst2_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_11_e_reg[7]), .B(
        Midori_rounds_sub_sBox_PRINCE_11_e_reg[8]), .Z(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_L_XORInst2_n6) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_L_XORInst3_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_11_f_reg[2]), .B(
        Midori_rounds_sub_sBox_PRINCE_11_f_reg[1]), .Z(output1[45]) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_L_XORInst4_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_11_f_reg[4]), .B(
        Midori_rounds_sub_sBox_PRINCE_11_f_reg[3]), .Z(
        Midori_rounds_SR_Result2[41]) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_L_XORInst5_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_L_XORInst5_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_L_XORInst5_n5), .ZN(output1[46])
         );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_L_XORInst5_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_11_g_reg[2]), .B(
        Midori_rounds_sub_sBox_PRINCE_11_g_reg[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_L_XORInst5_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_L_XORInst5_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_11_g_reg[3]), .B(
        Midori_rounds_sub_sBox_PRINCE_11_g_reg[4]), .Z(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_L_XORInst5_n6) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_L_XORInst6_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_L_XORInst6_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_L_XORInst6_n5), .ZN(
        Midori_rounds_SR_Result2[42]) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_L_XORInst6_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_11_g_reg[6]), .B(
        Midori_rounds_sub_sBox_PRINCE_11_g_reg[5]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_L_XORInst6_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_L_XORInst6_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_11_g_reg[7]), .B(
        Midori_rounds_sub_sBox_PRINCE_11_g_reg[8]), .Z(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_L_XORInst6_n6) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_L_XORInst7_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_L_XORInst7_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_L_XORInst7_n5), .ZN(output1[47])
         );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_L_XORInst7_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_11_h_reg[2]), .B(
        Midori_rounds_sub_sBox_PRINCE_11_h_reg[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_L_XORInst7_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_L_XORInst7_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_11_h_reg[3]), .B(
        Midori_rounds_sub_sBox_PRINCE_11_h_reg[4]), .Z(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_L_XORInst7_n6) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_L_XORInst8_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_L_XORInst8_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_L_XORInst8_n5), .ZN(
        Midori_rounds_SR_Result2[43]) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_L_XORInst8_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_11_h_reg[6]), .B(
        Midori_rounds_sub_sBox_PRINCE_11_h_reg[5]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_L_XORInst8_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_11_Inst_L_XORInst8_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_11_h_reg[7]), .B(
        Midori_rounds_sub_sBox_PRINCE_11_h_reg[8]), .Z(
        Midori_rounds_sub_sBox_PRINCE_11_Inst_L_XORInst8_n6) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F1_U17 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F1_n43), .A2(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F1_n42), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_g[1]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F1_U16 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F1_n41), .A2(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F1_n40), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F1_n42) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F1_U15 ( .A1(
        Midori_rounds_roundReg_out2[50]), .A2(Midori_rounds_roundReg_out1[51]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F1_n40) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F1_U14 ( .A(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F1_n39), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F1_n43) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F1_U13 ( .A(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F1_n38), .B(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F1_n37), .S(
        Midori_rounds_roundReg_out1[49]), .Z(
        Midori_rounds_sub_sBox_PRINCE_12_e[1]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F1_U12 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F1_n36), .A2(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F1_n41), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F1_n38) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F1_U11 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F1_n35), .A2(
        Midori_rounds_roundReg_out1[51]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F1_n41) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F1_U10 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F1_n34), .A2(
        Midori_rounds_roundReg_out2[50]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F1_n36) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F1_U9 ( .A1(
        Midori_rounds_roundReg_out1[51]), .A2(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F1_n35), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F1_n34) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F1_U8 ( .A(
        Midori_rounds_roundReg_out1[48]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F1_n35) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F1_U7 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F1_n33), .A2(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F1_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_h[1]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F1_U6 ( .A1(
        Midori_rounds_roundReg_out1[51]), .A2(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F1_n39), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F1_n32) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F1_U5 ( .A1(
        Midori_rounds_roundReg_out1[49]), .A2(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F1_n31), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F1_n39) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F1_U4 ( .A1(
        Midori_rounds_roundReg_out2[50]), .A2(Midori_rounds_roundReg_out1[48]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F1_n31) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F1_U3 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F1_n30), .A2(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F1_n37), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F1_n33) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F1_U2 ( .A(
        Midori_rounds_roundReg_out2[50]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F1_n37) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F1_U1 ( .A1(
        Midori_rounds_roundReg_out1[51]), .A2(Midori_rounds_roundReg_out1[48]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F1_n30) );
  AND2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F2_U12 ( .A1(
        Midori_rounds_roundReg_out2[49]), .A2(
        Midori_rounds_sub_sBox_PRINCE_12_f[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_e[2]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F2_U11 ( .A(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F2_n33), .B(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F2_n32), .S(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F2_n31), .Z(
        Midori_rounds_sub_sBox_PRINCE_12_f[1]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F2_U10 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F2_n30), .A2(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F2_n29), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_g[2]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F2_U9 ( .A(
        Midori_rounds_roundReg_out1[50]), .B(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F2_n28), .S(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F2_n31), .Z(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F2_n29) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F2_U8 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F2_n32), .A2(
        Midori_rounds_roundReg_out2[49]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F2_n30) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F2_U7 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F2_n27), .A2(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F2_n26), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_h[2]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F2_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F2_n33), .A2(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F2_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F2_n26) );
  AND2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F2_U5 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F2_n28), .A2(
        Midori_rounds_roundReg_out1[50]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F2_n32) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F2_U4 ( .A1(
        Midori_rounds_roundReg_out1[50]), .A2(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F2_n28), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F2_n33) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F2_U3 ( .A(
        Midori_rounds_roundReg_out1[48]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F2_n28) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F2_U2 ( .A1(
        Midori_rounds_roundReg_out2[49]), .A2(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F2_n31), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F2_n27) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F2_U1 ( .A(
        Midori_rounds_roundReg_out1[51]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F2_n31) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F3_U13 ( .A1(
        Midori_rounds_roundReg_out1[49]), .A2(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F3_n35), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_g[3]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F3_U12 ( .A(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F3_n34), .B(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F3_n33), .S(
        Midori_rounds_roundReg_out2[48]), .Z(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F3_n35) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F3_U11 ( .A1(
        Midori_rounds_roundReg_out1[51]), .A2(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F3_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F3_n33) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F3_U10 ( .A1(
        Midori_rounds_roundReg_out1[50]), .A2(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F3_n31), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F3_n34) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F3_U9 ( .A(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F3_n30), .B(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F3_n29), .S(
        Midori_rounds_roundReg_out1[50]), .Z(
        Midori_rounds_sub_sBox_PRINCE_12_e[3]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F3_U8 ( .A1(
        Midori_rounds_roundReg_out2[48]), .A2(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F3_n28), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F3_n29) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F3_U7 ( .A1(
        Midori_rounds_roundReg_out1[49]), .A2(Midori_rounds_roundReg_out1[51]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F3_n28) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F3_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F3_n27), .A2(
        Midori_rounds_roundReg_out1[51]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F3_n30) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F3_U5 ( .A1(
        Midori_rounds_roundReg_out1[49]), .A2(Midori_rounds_roundReg_out2[48]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F3_n27) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F3_U4 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F3_n31), .A2(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F3_n26), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_h[3]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F3_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F3_n32), .B(
        Midori_rounds_roundReg_out2[48]), .S(Midori_rounds_roundReg_out1[49]), 
        .Z(Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F3_n26) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F3_U2 ( .A(
        Midori_rounds_roundReg_out1[50]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F3_n32) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F3_U1 ( .A(
        Midori_rounds_roundReg_out1[51]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F3_n31) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F4_U15 ( .A(
        Midori_rounds_roundReg_out2[48]), .B(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F4_n49), .S(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F4_n48), .Z(
        Midori_rounds_sub_sBox_PRINCE_12_h[4]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F4_U14 ( .A1(
        Midori_rounds_roundReg_out1[51]), .A2(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F4_n47), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F4_n48) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F4_U13 ( .A(
        Midori_rounds_roundReg_out2[49]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F4_n47) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F4_U12 ( .A(
        Midori_rounds_roundReg_out2[48]), .B(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F4_n46), .S(
        Midori_rounds_roundReg_out2[49]), .Z(
        Midori_rounds_sub_sBox_PRINCE_12_g[4]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F4_U11 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F4_n45), .A2(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F4_n44), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F4_n46) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F4_U10 ( .A1(
        Midori_rounds_roundReg_out2[50]), .A2(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F4_n43), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F4_n45) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F4_U9 ( .A(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F4_n42), .B(
        Midori_rounds_roundReg_out2[49]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_f[2]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F4_U8 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F4_n41), .A2(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F4_n44), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F4_n42) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F4_U7 ( .A1(
        Midori_rounds_roundReg_out2[49]), .A2(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F4_n40), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_e[4]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F4_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F4_n41), .A2(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F4_n39), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F4_n40) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F4_U5 ( .A1(
        Midori_rounds_roundReg_out2[50]), .A2(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F4_n44), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F4_n39) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F4_U4 ( .A1(
        Midori_rounds_roundReg_out2[48]), .A2(Midori_rounds_roundReg_out1[51]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F4_n44) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F4_U3 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F4_n49), .A2(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F4_n43), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F4_n41) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F4_U2 ( .A1(
        Midori_rounds_roundReg_out2[48]), .A2(Midori_rounds_roundReg_out1[51]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F4_n43) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F4_U1 ( .A(
        Midori_rounds_roundReg_out2[50]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F4_n49) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F5_U12 ( .A(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F5_n33), .B(
        Midori_rounds_roundReg_out1[48]), .S(Midori_rounds_roundReg_out1[49]), 
        .Z(Midori_rounds_sub_sBox_PRINCE_12_g[5]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F5_U11 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F5_n32), .A2(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F5_n31), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F5_n33) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F5_U10 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F5_n30), .A2(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F5_n29), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F5_n31) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F5_U9 ( .A(
        Midori_rounds_roundReg_out1[48]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F5_n30) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F5_U8 ( .A(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F5_n28), .B(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F5_n27), .S(
        Midori_rounds_roundReg_out1[48]), .Z(
        Midori_rounds_sub_sBox_PRINCE_12_e[5]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F5_U7 ( .A1(
        Midori_rounds_roundReg_out1[49]), .A2(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F5_n29), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F5_n27) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F5_U6 ( .A1(
        Midori_rounds_roundReg_out2[51]), .A2(Midori_rounds_roundReg_out1[50]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F5_n29) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F5_U5 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F5_n28), .A2(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F5_n26), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_h[5]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F5_U4 ( .A1(
        Midori_rounds_roundReg_out2[51]), .A2(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F5_n25), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F5_n26) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F5_U3 ( .A1(
        Midori_rounds_roundReg_out1[49]), .A2(Midori_rounds_roundReg_out1[48]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F5_n25) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F5_U2 ( .A1(
        Midori_rounds_roundReg_out1[49]), .A2(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F5_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F5_n28) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F5_U1 ( .A1(
        Midori_rounds_roundReg_out2[51]), .A2(Midori_rounds_roundReg_out1[50]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F5_n32) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_U22 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_n62), .A2(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_n61), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_h[6]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_U21 ( .A1(
        Midori_rounds_roundReg_out2[49]), .A2(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_n60), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_n61) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_U20 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_n59), .A2(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_n58), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_n62) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_U19 ( .A(
        Midori_rounds_roundReg_out2[51]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_n58) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_U18 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_n57), .A2(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_n56), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_n59) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_U17 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_n57), .A2(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_n55), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_e[6]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_U16 ( .A(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_n54), .B(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_n53), .S(
        Midori_rounds_roundReg_out2[51]), .Z(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_n55) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_U15 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_n52), .A2(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_n51), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_f[3]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_U14 ( .A1(
        Midori_rounds_roundReg_out2[49]), .A2(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_n50), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_n51) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_U13 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_n49), .A2(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_n48), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_n52) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_U12 ( .A(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_n50), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_n48) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_U11 ( .A1(
        Midori_rounds_roundReg_out2[50]), .A2(Midori_rounds_roundReg_out1[48]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_n50) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_U10 ( .A(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_n47), .B(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_n57), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_n49) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_U9 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_n46), .A2(
        Midori_rounds_roundReg_out2[51]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_n47) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_U8 ( .A1(
        Midori_rounds_roundReg_out2[50]), .A2(Midori_rounds_roundReg_out1[48]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_n46) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_U7 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_n57), .A2(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_n45), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_g[6]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_U6 ( .A(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_n53), .B(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_n54), .S(
        Midori_rounds_roundReg_out2[51]), .Z(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_n45) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_U5 ( .A1(
        Midori_rounds_roundReg_out2[50]), .A2(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_n60), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_n54) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_U4 ( .A(
        Midori_rounds_roundReg_out1[48]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_n60) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_U3 ( .A1(
        Midori_rounds_roundReg_out1[48]), .A2(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_n56), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_n53) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_U2 ( .A(
        Midori_rounds_roundReg_out2[50]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_n56) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_U1 ( .A(
        Midori_rounds_roundReg_out2[49]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F6_n57) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F7_U11 ( .A(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F7_n35), .B(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F7_n34), .S(
        Midori_rounds_roundReg_out1[49]), .Z(
        Midori_rounds_sub_sBox_PRINCE_12_h[7]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F7_U10 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F7_n33), .A2(
        Midori_rounds_roundReg_out2[50]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F7_n34) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F7_U9 ( .A(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F7_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F7_n35) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F7_U8 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F7_n31), .A2(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F7_n30), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_g[7]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F7_U7 ( .A(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F7_n29), .B(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F7_n32), .S(
        Midori_rounds_roundReg_out2[50]), .Z(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F7_n30) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F7_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F7_n31), .A2(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F7_n28), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_e[7]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F7_U5 ( .A(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F7_n32), .B(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F7_n29), .S(
        Midori_rounds_roundReg_out2[50]), .Z(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F7_n28) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F7_U4 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F7_n33), .A2(
        Midori_rounds_roundReg_out2[48]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F7_n29) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F7_U3 ( .A1(
        Midori_rounds_roundReg_out2[48]), .A2(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F7_n33), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F7_n32) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F7_U2 ( .A(
        Midori_rounds_roundReg_out2[51]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F7_n33) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F7_U1 ( .A(
        Midori_rounds_roundReg_out1[49]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F7_n31) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F8_U17 ( .A(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F8_n44), .B(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F8_n43), .S(
        Midori_rounds_roundReg_out2[49]), .Z(
        Midori_rounds_sub_sBox_PRINCE_12_e[8]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F8_U16 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F8_n42), .A2(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F8_n41), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F8_n44) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F8_U15 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F8_n40), .A2(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F8_n39), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_h[8]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F8_U14 ( .A1(
        Midori_rounds_roundReg_out2[49]), .A2(Midori_rounds_roundReg_out1[50]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F8_n39) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F8_U13 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F8_n38), .A2(
        Midori_rounds_roundReg_out2[51]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F8_n40) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F8_U12 ( .A1(
        Midori_rounds_roundReg_out2[49]), .A2(Midori_rounds_roundReg_out2[48]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F8_n38) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F8_U11 ( .A1(
        Midori_rounds_roundReg_out2[49]), .A2(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F8_n37), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_g[8]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F8_U10 ( .A(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F8_n36), .B(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F8_n35), .S(
        Midori_rounds_roundReg_out2[51]), .Z(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F8_n37) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F8_U9 ( .A1(
        Midori_rounds_roundReg_out2[48]), .A2(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F8_n43), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F8_n35) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F8_U8 ( .A(
        Midori_rounds_roundReg_out1[50]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F8_n43) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F8_U7 ( .A1(
        Midori_rounds_roundReg_out1[50]), .A2(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F8_n34), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F8_n36) );
  AND2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F8_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F8_n33), .A2(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F8_n42), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_f[4]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F8_U5 ( .A1(
        Midori_rounds_roundReg_out2[48]), .A2(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F8_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F8_n42) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F8_U4 ( .A1(
        Midori_rounds_roundReg_out2[51]), .A2(Midori_rounds_roundReg_out1[50]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F8_n32) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F8_U3 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F8_n41), .A2(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F8_n34), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F8_n33) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F8_U2 ( .A(
        Midori_rounds_roundReg_out2[48]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F8_n34) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F8_U1 ( .A1(
        Midori_rounds_roundReg_out2[51]), .A2(Midori_rounds_roundReg_out1[50]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_12_Inst_N_F8_n41) );
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_12_InAff_output_reg_s_current_state_reg_0_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_12_e[1]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_12_e_reg[1]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_12_InAff_output_reg_s_current_state_reg_1_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_12_e[2]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_12_e_reg[2]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_12_InAff_output_reg_s_current_state_reg_2_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_12_e[3]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_12_e_reg[3]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_12_InAff_output_reg_s_current_state_reg_3_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_12_e[4]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_12_e_reg[4]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_12_InAff_output_reg_s_current_state_reg_4_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_12_e[5]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_12_e_reg[5]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_12_InAff_output_reg_s_current_state_reg_5_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_12_e[6]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_12_e_reg[6]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_12_InAff_output_reg_s_current_state_reg_6_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_12_e[7]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_12_e_reg[7]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_12_InAff_output_reg_s_current_state_reg_7_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_12_e[8]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_12_e_reg[8]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_12_InAff_output_reg_s_current_state_reg_8_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_12_f[1]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_12_f_reg[1]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_12_InAff_output_reg_s_current_state_reg_9_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_12_f[2]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_12_f_reg[2]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_12_InAff_output_reg_s_current_state_reg_10_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_12_f[3]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_12_f_reg[3]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_12_InAff_output_reg_s_current_state_reg_11_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_12_f[4]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_12_f_reg[4]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_12_InAff_output_reg_s_current_state_reg_12_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_12_g[1]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_12_g_reg[1]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_12_InAff_output_reg_s_current_state_reg_13_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_12_g[2]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_12_g_reg[2]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_12_InAff_output_reg_s_current_state_reg_14_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_12_g[3]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_12_g_reg[3]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_12_InAff_output_reg_s_current_state_reg_15_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_12_g[4]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_12_g_reg[4]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_12_InAff_output_reg_s_current_state_reg_16_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_12_g[5]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_12_g_reg[5]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_12_InAff_output_reg_s_current_state_reg_17_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_12_g[6]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_12_g_reg[6]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_12_InAff_output_reg_s_current_state_reg_18_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_12_g[7]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_12_g_reg[7]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_12_InAff_output_reg_s_current_state_reg_19_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_12_g[8]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_12_g_reg[8]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_12_InAff_output_reg_s_current_state_reg_20_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_12_h[1]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_12_h_reg[1]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_12_InAff_output_reg_s_current_state_reg_21_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_12_h[2]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_12_h_reg[2]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_12_InAff_output_reg_s_current_state_reg_22_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_12_h[3]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_12_h_reg[3]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_12_InAff_output_reg_s_current_state_reg_23_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_12_h[4]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_12_h_reg[4]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_12_InAff_output_reg_s_current_state_reg_24_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_12_h[5]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_12_h_reg[5]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_12_InAff_output_reg_s_current_state_reg_25_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_12_h[6]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_12_h_reg[6]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_12_InAff_output_reg_s_current_state_reg_26_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_12_h[7]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_12_h_reg[7]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_12_InAff_output_reg_s_current_state_reg_27_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_12_h[8]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_12_h_reg[8]) , .QN() ); 
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_L_XORInst1_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_L_XORInst1_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_L_XORInst1_n5), .ZN(output1[48])
         );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_L_XORInst1_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_12_e_reg[2]), .B(
        Midori_rounds_sub_sBox_PRINCE_12_e_reg[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_L_XORInst1_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_L_XORInst1_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_12_e_reg[3]), .B(
        Midori_rounds_sub_sBox_PRINCE_12_e_reg[4]), .Z(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_L_XORInst1_n6) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_L_XORInst2_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_L_XORInst2_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_L_XORInst2_n5), .ZN(
        Midori_rounds_SR_Result2[24]) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_L_XORInst2_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_12_e_reg[6]), .B(
        Midori_rounds_sub_sBox_PRINCE_12_e_reg[5]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_L_XORInst2_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_L_XORInst2_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_12_e_reg[7]), .B(
        Midori_rounds_sub_sBox_PRINCE_12_e_reg[8]), .Z(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_L_XORInst2_n6) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_L_XORInst3_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_12_f_reg[2]), .B(
        Midori_rounds_sub_sBox_PRINCE_12_f_reg[1]), .Z(output1[49]) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_L_XORInst4_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_12_f_reg[4]), .B(
        Midori_rounds_sub_sBox_PRINCE_12_f_reg[3]), .Z(
        Midori_rounds_SR_Result2[25]) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_L_XORInst5_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_L_XORInst5_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_L_XORInst5_n5), .ZN(output1[50])
         );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_L_XORInst5_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_12_g_reg[2]), .B(
        Midori_rounds_sub_sBox_PRINCE_12_g_reg[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_L_XORInst5_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_L_XORInst5_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_12_g_reg[3]), .B(
        Midori_rounds_sub_sBox_PRINCE_12_g_reg[4]), .Z(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_L_XORInst5_n6) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_L_XORInst6_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_L_XORInst6_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_L_XORInst6_n5), .ZN(
        Midori_rounds_SR_Result2[26]) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_L_XORInst6_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_12_g_reg[6]), .B(
        Midori_rounds_sub_sBox_PRINCE_12_g_reg[5]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_L_XORInst6_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_L_XORInst6_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_12_g_reg[7]), .B(
        Midori_rounds_sub_sBox_PRINCE_12_g_reg[8]), .Z(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_L_XORInst6_n6) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_L_XORInst7_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_L_XORInst7_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_L_XORInst7_n5), .ZN(output1[51])
         );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_L_XORInst7_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_12_h_reg[2]), .B(
        Midori_rounds_sub_sBox_PRINCE_12_h_reg[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_L_XORInst7_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_L_XORInst7_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_12_h_reg[3]), .B(
        Midori_rounds_sub_sBox_PRINCE_12_h_reg[4]), .Z(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_L_XORInst7_n6) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_L_XORInst8_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_L_XORInst8_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_L_XORInst8_n5), .ZN(
        Midori_rounds_SR_Result2[27]) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_L_XORInst8_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_12_h_reg[6]), .B(
        Midori_rounds_sub_sBox_PRINCE_12_h_reg[5]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_L_XORInst8_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_12_Inst_L_XORInst8_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_12_h_reg[7]), .B(
        Midori_rounds_sub_sBox_PRINCE_12_h_reg[8]), .Z(
        Midori_rounds_sub_sBox_PRINCE_12_Inst_L_XORInst8_n6) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F1_U17 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F1_n43), .A2(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F1_n42), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_g[1]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F1_U16 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F1_n41), .A2(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F1_n40), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F1_n42) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F1_U15 ( .A1(
        Midori_rounds_roundReg_out2[54]), .A2(Midori_rounds_roundReg_out1[55]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F1_n40) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F1_U14 ( .A(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F1_n39), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F1_n43) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F1_U13 ( .A(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F1_n38), .B(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F1_n37), .S(
        Midori_rounds_roundReg_out1[53]), .Z(
        Midori_rounds_sub_sBox_PRINCE_13_e[1]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F1_U12 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F1_n36), .A2(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F1_n41), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F1_n38) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F1_U11 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F1_n35), .A2(
        Midori_rounds_roundReg_out1[55]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F1_n41) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F1_U10 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F1_n34), .A2(
        Midori_rounds_roundReg_out2[54]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F1_n36) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F1_U9 ( .A1(
        Midori_rounds_roundReg_out1[55]), .A2(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F1_n35), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F1_n34) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F1_U8 ( .A(
        Midori_rounds_roundReg_out1[52]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F1_n35) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F1_U7 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F1_n33), .A2(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F1_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_h[1]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F1_U6 ( .A1(
        Midori_rounds_roundReg_out1[55]), .A2(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F1_n39), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F1_n32) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F1_U5 ( .A1(
        Midori_rounds_roundReg_out1[53]), .A2(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F1_n31), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F1_n39) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F1_U4 ( .A1(
        Midori_rounds_roundReg_out2[54]), .A2(Midori_rounds_roundReg_out1[52]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F1_n31) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F1_U3 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F1_n30), .A2(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F1_n37), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F1_n33) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F1_U2 ( .A(
        Midori_rounds_roundReg_out2[54]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F1_n37) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F1_U1 ( .A1(
        Midori_rounds_roundReg_out1[55]), .A2(Midori_rounds_roundReg_out1[52]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F1_n30) );
  AND2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F2_U12 ( .A1(
        Midori_rounds_roundReg_out2[53]), .A2(
        Midori_rounds_sub_sBox_PRINCE_13_f[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_e[2]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F2_U11 ( .A(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F2_n33), .B(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F2_n32), .S(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F2_n31), .Z(
        Midori_rounds_sub_sBox_PRINCE_13_f[1]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F2_U10 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F2_n30), .A2(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F2_n29), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_g[2]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F2_U9 ( .A(
        Midori_rounds_roundReg_out1[54]), .B(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F2_n28), .S(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F2_n31), .Z(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F2_n29) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F2_U8 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F2_n32), .A2(
        Midori_rounds_roundReg_out2[53]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F2_n30) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F2_U7 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F2_n27), .A2(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F2_n26), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_h[2]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F2_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F2_n33), .A2(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F2_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F2_n26) );
  AND2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F2_U5 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F2_n28), .A2(
        Midori_rounds_roundReg_out1[54]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F2_n32) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F2_U4 ( .A1(
        Midori_rounds_roundReg_out1[54]), .A2(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F2_n28), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F2_n33) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F2_U3 ( .A(
        Midori_rounds_roundReg_out1[52]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F2_n28) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F2_U2 ( .A1(
        Midori_rounds_roundReg_out2[53]), .A2(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F2_n31), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F2_n27) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F2_U1 ( .A(
        Midori_rounds_roundReg_out1[55]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F2_n31) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F3_U13 ( .A1(
        Midori_rounds_roundReg_out1[53]), .A2(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F3_n35), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_g[3]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F3_U12 ( .A(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F3_n34), .B(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F3_n33), .S(
        Midori_rounds_roundReg_out2[52]), .Z(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F3_n35) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F3_U11 ( .A1(
        Midori_rounds_roundReg_out1[55]), .A2(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F3_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F3_n33) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F3_U10 ( .A1(
        Midori_rounds_roundReg_out1[54]), .A2(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F3_n31), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F3_n34) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F3_U9 ( .A(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F3_n30), .B(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F3_n29), .S(
        Midori_rounds_roundReg_out1[54]), .Z(
        Midori_rounds_sub_sBox_PRINCE_13_e[3]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F3_U8 ( .A1(
        Midori_rounds_roundReg_out2[52]), .A2(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F3_n28), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F3_n29) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F3_U7 ( .A1(
        Midori_rounds_roundReg_out1[53]), .A2(Midori_rounds_roundReg_out1[55]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F3_n28) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F3_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F3_n27), .A2(
        Midori_rounds_roundReg_out1[55]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F3_n30) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F3_U5 ( .A1(
        Midori_rounds_roundReg_out1[53]), .A2(Midori_rounds_roundReg_out2[52]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F3_n27) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F3_U4 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F3_n31), .A2(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F3_n26), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_h[3]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F3_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F3_n32), .B(
        Midori_rounds_roundReg_out2[52]), .S(Midori_rounds_roundReg_out1[53]), 
        .Z(Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F3_n26) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F3_U2 ( .A(
        Midori_rounds_roundReg_out1[54]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F3_n32) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F3_U1 ( .A(
        Midori_rounds_roundReg_out1[55]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F3_n31) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F4_U15 ( .A(
        Midori_rounds_roundReg_out2[52]), .B(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F4_n49), .S(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F4_n48), .Z(
        Midori_rounds_sub_sBox_PRINCE_13_h[4]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F4_U14 ( .A1(
        Midori_rounds_roundReg_out1[55]), .A2(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F4_n47), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F4_n48) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F4_U13 ( .A(
        Midori_rounds_roundReg_out2[53]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F4_n47) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F4_U12 ( .A(
        Midori_rounds_roundReg_out2[52]), .B(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F4_n46), .S(
        Midori_rounds_roundReg_out2[53]), .Z(
        Midori_rounds_sub_sBox_PRINCE_13_g[4]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F4_U11 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F4_n45), .A2(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F4_n44), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F4_n46) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F4_U10 ( .A1(
        Midori_rounds_roundReg_out2[54]), .A2(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F4_n43), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F4_n45) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F4_U9 ( .A(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F4_n42), .B(
        Midori_rounds_roundReg_out2[53]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_f[2]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F4_U8 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F4_n41), .A2(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F4_n44), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F4_n42) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F4_U7 ( .A1(
        Midori_rounds_roundReg_out2[53]), .A2(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F4_n40), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_e[4]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F4_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F4_n41), .A2(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F4_n39), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F4_n40) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F4_U5 ( .A1(
        Midori_rounds_roundReg_out2[54]), .A2(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F4_n44), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F4_n39) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F4_U4 ( .A1(
        Midori_rounds_roundReg_out2[52]), .A2(Midori_rounds_roundReg_out1[55]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F4_n44) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F4_U3 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F4_n49), .A2(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F4_n43), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F4_n41) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F4_U2 ( .A1(
        Midori_rounds_roundReg_out2[52]), .A2(Midori_rounds_roundReg_out1[55]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F4_n43) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F4_U1 ( .A(
        Midori_rounds_roundReg_out2[54]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F4_n49) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F5_U12 ( .A(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F5_n33), .B(
        Midori_rounds_roundReg_out1[52]), .S(Midori_rounds_roundReg_out1[53]), 
        .Z(Midori_rounds_sub_sBox_PRINCE_13_g[5]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F5_U11 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F5_n32), .A2(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F5_n31), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F5_n33) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F5_U10 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F5_n30), .A2(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F5_n29), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F5_n31) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F5_U9 ( .A(
        Midori_rounds_roundReg_out1[52]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F5_n30) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F5_U8 ( .A(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F5_n28), .B(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F5_n27), .S(
        Midori_rounds_roundReg_out1[52]), .Z(
        Midori_rounds_sub_sBox_PRINCE_13_e[5]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F5_U7 ( .A1(
        Midori_rounds_roundReg_out1[53]), .A2(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F5_n29), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F5_n27) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F5_U6 ( .A1(
        Midori_rounds_roundReg_out2[55]), .A2(Midori_rounds_roundReg_out1[54]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F5_n29) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F5_U5 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F5_n28), .A2(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F5_n26), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_h[5]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F5_U4 ( .A1(
        Midori_rounds_roundReg_out2[55]), .A2(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F5_n25), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F5_n26) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F5_U3 ( .A1(
        Midori_rounds_roundReg_out1[53]), .A2(Midori_rounds_roundReg_out1[52]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F5_n25) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F5_U2 ( .A1(
        Midori_rounds_roundReg_out1[53]), .A2(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F5_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F5_n28) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F5_U1 ( .A1(
        Midori_rounds_roundReg_out2[55]), .A2(Midori_rounds_roundReg_out1[54]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F5_n32) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_U22 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_n62), .A2(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_n61), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_h[6]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_U21 ( .A1(
        Midori_rounds_roundReg_out2[53]), .A2(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_n60), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_n61) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_U20 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_n59), .A2(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_n58), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_n62) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_U19 ( .A(
        Midori_rounds_roundReg_out2[55]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_n58) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_U18 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_n57), .A2(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_n56), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_n59) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_U17 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_n57), .A2(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_n55), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_e[6]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_U16 ( .A(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_n54), .B(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_n53), .S(
        Midori_rounds_roundReg_out2[55]), .Z(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_n55) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_U15 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_n52), .A2(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_n51), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_f[3]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_U14 ( .A1(
        Midori_rounds_roundReg_out2[53]), .A2(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_n50), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_n51) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_U13 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_n49), .A2(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_n48), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_n52) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_U12 ( .A(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_n50), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_n48) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_U11 ( .A1(
        Midori_rounds_roundReg_out2[54]), .A2(Midori_rounds_roundReg_out1[52]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_n50) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_U10 ( .A(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_n47), .B(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_n57), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_n49) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_U9 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_n46), .A2(
        Midori_rounds_roundReg_out2[55]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_n47) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_U8 ( .A1(
        Midori_rounds_roundReg_out2[54]), .A2(Midori_rounds_roundReg_out1[52]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_n46) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_U7 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_n57), .A2(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_n45), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_g[6]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_U6 ( .A(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_n53), .B(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_n54), .S(
        Midori_rounds_roundReg_out2[55]), .Z(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_n45) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_U5 ( .A1(
        Midori_rounds_roundReg_out2[54]), .A2(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_n60), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_n54) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_U4 ( .A(
        Midori_rounds_roundReg_out1[52]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_n60) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_U3 ( .A1(
        Midori_rounds_roundReg_out1[52]), .A2(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_n56), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_n53) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_U2 ( .A(
        Midori_rounds_roundReg_out2[54]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_n56) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_U1 ( .A(
        Midori_rounds_roundReg_out2[53]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F6_n57) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F7_U11 ( .A(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F7_n35), .B(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F7_n34), .S(
        Midori_rounds_roundReg_out1[53]), .Z(
        Midori_rounds_sub_sBox_PRINCE_13_h[7]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F7_U10 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F7_n33), .A2(
        Midori_rounds_roundReg_out2[54]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F7_n34) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F7_U9 ( .A(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F7_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F7_n35) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F7_U8 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F7_n31), .A2(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F7_n30), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_g[7]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F7_U7 ( .A(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F7_n29), .B(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F7_n32), .S(
        Midori_rounds_roundReg_out2[54]), .Z(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F7_n30) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F7_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F7_n31), .A2(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F7_n28), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_e[7]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F7_U5 ( .A(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F7_n32), .B(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F7_n29), .S(
        Midori_rounds_roundReg_out2[54]), .Z(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F7_n28) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F7_U4 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F7_n33), .A2(
        Midori_rounds_roundReg_out2[52]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F7_n29) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F7_U3 ( .A1(
        Midori_rounds_roundReg_out2[52]), .A2(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F7_n33), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F7_n32) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F7_U2 ( .A(
        Midori_rounds_roundReg_out2[55]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F7_n33) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F7_U1 ( .A(
        Midori_rounds_roundReg_out1[53]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F7_n31) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F8_U17 ( .A(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F8_n44), .B(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F8_n43), .S(
        Midori_rounds_roundReg_out2[53]), .Z(
        Midori_rounds_sub_sBox_PRINCE_13_e[8]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F8_U16 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F8_n42), .A2(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F8_n41), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F8_n44) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F8_U15 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F8_n40), .A2(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F8_n39), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_h[8]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F8_U14 ( .A1(
        Midori_rounds_roundReg_out2[53]), .A2(Midori_rounds_roundReg_out1[54]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F8_n39) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F8_U13 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F8_n38), .A2(
        Midori_rounds_roundReg_out2[55]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F8_n40) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F8_U12 ( .A1(
        Midori_rounds_roundReg_out2[53]), .A2(Midori_rounds_roundReg_out2[52]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F8_n38) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F8_U11 ( .A1(
        Midori_rounds_roundReg_out2[53]), .A2(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F8_n37), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_g[8]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F8_U10 ( .A(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F8_n36), .B(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F8_n35), .S(
        Midori_rounds_roundReg_out2[55]), .Z(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F8_n37) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F8_U9 ( .A1(
        Midori_rounds_roundReg_out2[52]), .A2(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F8_n43), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F8_n35) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F8_U8 ( .A(
        Midori_rounds_roundReg_out1[54]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F8_n43) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F8_U7 ( .A1(
        Midori_rounds_roundReg_out1[54]), .A2(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F8_n34), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F8_n36) );
  AND2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F8_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F8_n33), .A2(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F8_n42), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_f[4]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F8_U5 ( .A1(
        Midori_rounds_roundReg_out2[52]), .A2(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F8_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F8_n42) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F8_U4 ( .A1(
        Midori_rounds_roundReg_out2[55]), .A2(Midori_rounds_roundReg_out1[54]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F8_n32) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F8_U3 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F8_n41), .A2(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F8_n34), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F8_n33) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F8_U2 ( .A(
        Midori_rounds_roundReg_out2[52]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F8_n34) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F8_U1 ( .A1(
        Midori_rounds_roundReg_out2[55]), .A2(Midori_rounds_roundReg_out1[54]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_13_Inst_N_F8_n41) );
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_13_InAff_output_reg_s_current_state_reg_0_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_13_e[1]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_13_e_reg[1]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_13_InAff_output_reg_s_current_state_reg_1_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_13_e[2]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_13_e_reg[2]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_13_InAff_output_reg_s_current_state_reg_2_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_13_e[3]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_13_e_reg[3]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_13_InAff_output_reg_s_current_state_reg_3_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_13_e[4]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_13_e_reg[4]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_13_InAff_output_reg_s_current_state_reg_4_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_13_e[5]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_13_e_reg[5]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_13_InAff_output_reg_s_current_state_reg_5_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_13_e[6]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_13_e_reg[6]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_13_InAff_output_reg_s_current_state_reg_6_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_13_e[7]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_13_e_reg[7]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_13_InAff_output_reg_s_current_state_reg_7_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_13_e[8]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_13_e_reg[8]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_13_InAff_output_reg_s_current_state_reg_8_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_13_f[1]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_13_f_reg[1]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_13_InAff_output_reg_s_current_state_reg_9_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_13_f[2]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_13_f_reg[2]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_13_InAff_output_reg_s_current_state_reg_10_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_13_f[3]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_13_f_reg[3]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_13_InAff_output_reg_s_current_state_reg_11_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_13_f[4]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_13_f_reg[4]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_13_InAff_output_reg_s_current_state_reg_12_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_13_g[1]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_13_g_reg[1]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_13_InAff_output_reg_s_current_state_reg_13_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_13_g[2]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_13_g_reg[2]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_13_InAff_output_reg_s_current_state_reg_14_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_13_g[3]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_13_g_reg[3]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_13_InAff_output_reg_s_current_state_reg_15_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_13_g[4]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_13_g_reg[4]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_13_InAff_output_reg_s_current_state_reg_16_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_13_g[5]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_13_g_reg[5]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_13_InAff_output_reg_s_current_state_reg_17_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_13_g[6]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_13_g_reg[6]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_13_InAff_output_reg_s_current_state_reg_18_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_13_g[7]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_13_g_reg[7]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_13_InAff_output_reg_s_current_state_reg_19_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_13_g[8]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_13_g_reg[8]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_13_InAff_output_reg_s_current_state_reg_20_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_13_h[1]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_13_h_reg[1]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_13_InAff_output_reg_s_current_state_reg_21_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_13_h[2]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_13_h_reg[2]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_13_InAff_output_reg_s_current_state_reg_22_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_13_h[3]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_13_h_reg[3]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_13_InAff_output_reg_s_current_state_reg_23_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_13_h[4]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_13_h_reg[4]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_13_InAff_output_reg_s_current_state_reg_24_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_13_h[5]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_13_h_reg[5]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_13_InAff_output_reg_s_current_state_reg_25_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_13_h[6]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_13_h_reg[6]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_13_InAff_output_reg_s_current_state_reg_26_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_13_h[7]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_13_h_reg[7]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_13_InAff_output_reg_s_current_state_reg_27_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_13_h[8]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_13_h_reg[8]) , .QN() ); 
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_L_XORInst1_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_L_XORInst1_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_L_XORInst1_n5), .ZN(output1[52])
         );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_L_XORInst1_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_13_e_reg[2]), .B(
        Midori_rounds_sub_sBox_PRINCE_13_e_reg[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_L_XORInst1_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_L_XORInst1_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_13_e_reg[3]), .B(
        Midori_rounds_sub_sBox_PRINCE_13_e_reg[4]), .Z(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_L_XORInst1_n6) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_L_XORInst2_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_L_XORInst2_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_L_XORInst2_n5), .ZN(
        Midori_rounds_SR_Result2[4]) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_L_XORInst2_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_13_e_reg[6]), .B(
        Midori_rounds_sub_sBox_PRINCE_13_e_reg[5]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_L_XORInst2_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_L_XORInst2_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_13_e_reg[7]), .B(
        Midori_rounds_sub_sBox_PRINCE_13_e_reg[8]), .Z(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_L_XORInst2_n6) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_L_XORInst3_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_13_f_reg[2]), .B(
        Midori_rounds_sub_sBox_PRINCE_13_f_reg[1]), .Z(output1[53]) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_L_XORInst4_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_13_f_reg[4]), .B(
        Midori_rounds_sub_sBox_PRINCE_13_f_reg[3]), .Z(
        Midori_rounds_SR_Result2[5]) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_L_XORInst5_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_L_XORInst5_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_L_XORInst5_n5), .ZN(output1[54])
         );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_L_XORInst5_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_13_g_reg[2]), .B(
        Midori_rounds_sub_sBox_PRINCE_13_g_reg[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_L_XORInst5_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_L_XORInst5_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_13_g_reg[3]), .B(
        Midori_rounds_sub_sBox_PRINCE_13_g_reg[4]), .Z(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_L_XORInst5_n6) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_L_XORInst6_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_L_XORInst6_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_L_XORInst6_n5), .ZN(
        Midori_rounds_SR_Result2[6]) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_L_XORInst6_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_13_g_reg[6]), .B(
        Midori_rounds_sub_sBox_PRINCE_13_g_reg[5]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_L_XORInst6_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_L_XORInst6_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_13_g_reg[7]), .B(
        Midori_rounds_sub_sBox_PRINCE_13_g_reg[8]), .Z(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_L_XORInst6_n6) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_L_XORInst7_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_L_XORInst7_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_L_XORInst7_n5), .ZN(output1[55])
         );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_L_XORInst7_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_13_h_reg[2]), .B(
        Midori_rounds_sub_sBox_PRINCE_13_h_reg[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_L_XORInst7_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_L_XORInst7_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_13_h_reg[3]), .B(
        Midori_rounds_sub_sBox_PRINCE_13_h_reg[4]), .Z(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_L_XORInst7_n6) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_L_XORInst8_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_L_XORInst8_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_L_XORInst8_n5), .ZN(
        Midori_rounds_SR_Result2[7]) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_L_XORInst8_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_13_h_reg[6]), .B(
        Midori_rounds_sub_sBox_PRINCE_13_h_reg[5]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_L_XORInst8_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_13_Inst_L_XORInst8_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_13_h_reg[7]), .B(
        Midori_rounds_sub_sBox_PRINCE_13_h_reg[8]), .Z(
        Midori_rounds_sub_sBox_PRINCE_13_Inst_L_XORInst8_n6) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F1_U17 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F1_n43), .A2(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F1_n42), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_g[1]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F1_U16 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F1_n41), .A2(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F1_n40), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F1_n42) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F1_U15 ( .A1(
        Midori_rounds_roundReg_out2[58]), .A2(Midori_rounds_roundReg_out1[59]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F1_n40) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F1_U14 ( .A(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F1_n39), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F1_n43) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F1_U13 ( .A(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F1_n38), .B(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F1_n37), .S(
        Midori_rounds_roundReg_out1[57]), .Z(
        Midori_rounds_sub_sBox_PRINCE_14_e[1]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F1_U12 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F1_n36), .A2(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F1_n41), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F1_n38) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F1_U11 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F1_n35), .A2(
        Midori_rounds_roundReg_out1[59]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F1_n41) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F1_U10 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F1_n34), .A2(
        Midori_rounds_roundReg_out2[58]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F1_n36) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F1_U9 ( .A1(
        Midori_rounds_roundReg_out1[59]), .A2(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F1_n35), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F1_n34) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F1_U8 ( .A(
        Midori_rounds_roundReg_out1[56]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F1_n35) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F1_U7 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F1_n33), .A2(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F1_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_h[1]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F1_U6 ( .A1(
        Midori_rounds_roundReg_out1[59]), .A2(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F1_n39), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F1_n32) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F1_U5 ( .A1(
        Midori_rounds_roundReg_out1[57]), .A2(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F1_n31), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F1_n39) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F1_U4 ( .A1(
        Midori_rounds_roundReg_out2[58]), .A2(Midori_rounds_roundReg_out1[56]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F1_n31) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F1_U3 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F1_n30), .A2(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F1_n37), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F1_n33) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F1_U2 ( .A(
        Midori_rounds_roundReg_out2[58]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F1_n37) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F1_U1 ( .A1(
        Midori_rounds_roundReg_out1[59]), .A2(Midori_rounds_roundReg_out1[56]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F1_n30) );
  AND2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F2_U12 ( .A1(
        Midori_rounds_roundReg_out2[57]), .A2(
        Midori_rounds_sub_sBox_PRINCE_14_f[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_e[2]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F2_U11 ( .A(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F2_n33), .B(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F2_n32), .S(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F2_n31), .Z(
        Midori_rounds_sub_sBox_PRINCE_14_f[1]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F2_U10 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F2_n30), .A2(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F2_n29), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_g[2]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F2_U9 ( .A(
        Midori_rounds_roundReg_out1[58]), .B(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F2_n28), .S(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F2_n31), .Z(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F2_n29) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F2_U8 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F2_n32), .A2(
        Midori_rounds_roundReg_out2[57]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F2_n30) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F2_U7 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F2_n27), .A2(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F2_n26), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_h[2]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F2_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F2_n33), .A2(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F2_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F2_n26) );
  AND2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F2_U5 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F2_n28), .A2(
        Midori_rounds_roundReg_out1[58]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F2_n32) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F2_U4 ( .A1(
        Midori_rounds_roundReg_out1[58]), .A2(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F2_n28), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F2_n33) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F2_U3 ( .A(
        Midori_rounds_roundReg_out1[56]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F2_n28) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F2_U2 ( .A1(
        Midori_rounds_roundReg_out2[57]), .A2(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F2_n31), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F2_n27) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F2_U1 ( .A(
        Midori_rounds_roundReg_out1[59]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F2_n31) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F3_U13 ( .A1(
        Midori_rounds_roundReg_out1[57]), .A2(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F3_n35), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_g[3]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F3_U12 ( .A(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F3_n34), .B(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F3_n33), .S(
        Midori_rounds_roundReg_out2[56]), .Z(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F3_n35) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F3_U11 ( .A1(
        Midori_rounds_roundReg_out1[59]), .A2(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F3_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F3_n33) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F3_U10 ( .A1(
        Midori_rounds_roundReg_out1[58]), .A2(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F3_n31), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F3_n34) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F3_U9 ( .A(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F3_n30), .B(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F3_n29), .S(
        Midori_rounds_roundReg_out1[58]), .Z(
        Midori_rounds_sub_sBox_PRINCE_14_e[3]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F3_U8 ( .A1(
        Midori_rounds_roundReg_out2[56]), .A2(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F3_n28), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F3_n29) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F3_U7 ( .A1(
        Midori_rounds_roundReg_out1[57]), .A2(Midori_rounds_roundReg_out1[59]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F3_n28) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F3_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F3_n27), .A2(
        Midori_rounds_roundReg_out1[59]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F3_n30) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F3_U5 ( .A1(
        Midori_rounds_roundReg_out1[57]), .A2(Midori_rounds_roundReg_out2[56]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F3_n27) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F3_U4 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F3_n31), .A2(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F3_n26), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_h[3]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F3_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F3_n32), .B(
        Midori_rounds_roundReg_out2[56]), .S(Midori_rounds_roundReg_out1[57]), 
        .Z(Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F3_n26) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F3_U2 ( .A(
        Midori_rounds_roundReg_out1[58]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F3_n32) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F3_U1 ( .A(
        Midori_rounds_roundReg_out1[59]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F3_n31) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F4_U15 ( .A(
        Midori_rounds_roundReg_out2[56]), .B(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F4_n49), .S(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F4_n48), .Z(
        Midori_rounds_sub_sBox_PRINCE_14_h[4]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F4_U14 ( .A1(
        Midori_rounds_roundReg_out1[59]), .A2(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F4_n47), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F4_n48) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F4_U13 ( .A(
        Midori_rounds_roundReg_out2[57]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F4_n47) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F4_U12 ( .A(
        Midori_rounds_roundReg_out2[56]), .B(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F4_n46), .S(
        Midori_rounds_roundReg_out2[57]), .Z(
        Midori_rounds_sub_sBox_PRINCE_14_g[4]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F4_U11 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F4_n45), .A2(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F4_n44), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F4_n46) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F4_U10 ( .A1(
        Midori_rounds_roundReg_out2[58]), .A2(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F4_n43), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F4_n45) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F4_U9 ( .A(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F4_n42), .B(
        Midori_rounds_roundReg_out2[57]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_f[2]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F4_U8 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F4_n41), .A2(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F4_n44), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F4_n42) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F4_U7 ( .A1(
        Midori_rounds_roundReg_out2[57]), .A2(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F4_n40), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_e[4]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F4_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F4_n41), .A2(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F4_n39), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F4_n40) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F4_U5 ( .A1(
        Midori_rounds_roundReg_out2[58]), .A2(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F4_n44), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F4_n39) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F4_U4 ( .A1(
        Midori_rounds_roundReg_out2[56]), .A2(Midori_rounds_roundReg_out1[59]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F4_n44) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F4_U3 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F4_n49), .A2(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F4_n43), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F4_n41) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F4_U2 ( .A1(
        Midori_rounds_roundReg_out2[56]), .A2(Midori_rounds_roundReg_out1[59]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F4_n43) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F4_U1 ( .A(
        Midori_rounds_roundReg_out2[58]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F4_n49) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F5_U12 ( .A(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F5_n33), .B(
        Midori_rounds_roundReg_out1[56]), .S(Midori_rounds_roundReg_out1[57]), 
        .Z(Midori_rounds_sub_sBox_PRINCE_14_g[5]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F5_U11 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F5_n32), .A2(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F5_n31), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F5_n33) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F5_U10 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F5_n30), .A2(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F5_n29), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F5_n31) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F5_U9 ( .A(
        Midori_rounds_roundReg_out1[56]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F5_n30) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F5_U8 ( .A(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F5_n28), .B(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F5_n27), .S(
        Midori_rounds_roundReg_out1[56]), .Z(
        Midori_rounds_sub_sBox_PRINCE_14_e[5]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F5_U7 ( .A1(
        Midori_rounds_roundReg_out1[57]), .A2(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F5_n29), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F5_n27) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F5_U6 ( .A1(
        Midori_rounds_roundReg_out2[59]), .A2(Midori_rounds_roundReg_out1[58]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F5_n29) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F5_U5 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F5_n28), .A2(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F5_n26), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_h[5]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F5_U4 ( .A1(
        Midori_rounds_roundReg_out2[59]), .A2(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F5_n25), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F5_n26) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F5_U3 ( .A1(
        Midori_rounds_roundReg_out1[57]), .A2(Midori_rounds_roundReg_out1[56]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F5_n25) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F5_U2 ( .A1(
        Midori_rounds_roundReg_out1[57]), .A2(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F5_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F5_n28) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F5_U1 ( .A1(
        Midori_rounds_roundReg_out2[59]), .A2(Midori_rounds_roundReg_out1[58]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F5_n32) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_U22 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_n62), .A2(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_n61), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_h[6]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_U21 ( .A1(
        Midori_rounds_roundReg_out2[57]), .A2(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_n60), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_n61) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_U20 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_n59), .A2(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_n58), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_n62) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_U19 ( .A(
        Midori_rounds_roundReg_out2[59]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_n58) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_U18 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_n57), .A2(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_n56), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_n59) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_U17 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_n57), .A2(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_n55), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_e[6]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_U16 ( .A(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_n54), .B(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_n53), .S(
        Midori_rounds_roundReg_out2[59]), .Z(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_n55) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_U15 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_n52), .A2(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_n51), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_f[3]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_U14 ( .A1(
        Midori_rounds_roundReg_out2[57]), .A2(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_n50), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_n51) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_U13 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_n49), .A2(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_n48), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_n52) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_U12 ( .A(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_n50), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_n48) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_U11 ( .A1(
        Midori_rounds_roundReg_out2[58]), .A2(Midori_rounds_roundReg_out1[56]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_n50) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_U10 ( .A(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_n47), .B(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_n57), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_n49) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_U9 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_n46), .A2(
        Midori_rounds_roundReg_out2[59]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_n47) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_U8 ( .A1(
        Midori_rounds_roundReg_out2[58]), .A2(Midori_rounds_roundReg_out1[56]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_n46) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_U7 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_n57), .A2(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_n45), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_g[6]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_U6 ( .A(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_n53), .B(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_n54), .S(
        Midori_rounds_roundReg_out2[59]), .Z(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_n45) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_U5 ( .A1(
        Midori_rounds_roundReg_out2[58]), .A2(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_n60), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_n54) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_U4 ( .A(
        Midori_rounds_roundReg_out1[56]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_n60) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_U3 ( .A1(
        Midori_rounds_roundReg_out1[56]), .A2(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_n56), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_n53) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_U2 ( .A(
        Midori_rounds_roundReg_out2[58]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_n56) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_U1 ( .A(
        Midori_rounds_roundReg_out2[57]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F6_n57) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F7_U11 ( .A(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F7_n35), .B(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F7_n34), .S(
        Midori_rounds_roundReg_out1[57]), .Z(
        Midori_rounds_sub_sBox_PRINCE_14_h[7]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F7_U10 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F7_n33), .A2(
        Midori_rounds_roundReg_out2[58]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F7_n34) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F7_U9 ( .A(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F7_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F7_n35) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F7_U8 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F7_n31), .A2(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F7_n30), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_g[7]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F7_U7 ( .A(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F7_n29), .B(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F7_n32), .S(
        Midori_rounds_roundReg_out2[58]), .Z(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F7_n30) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F7_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F7_n31), .A2(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F7_n28), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_e[7]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F7_U5 ( .A(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F7_n32), .B(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F7_n29), .S(
        Midori_rounds_roundReg_out2[58]), .Z(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F7_n28) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F7_U4 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F7_n33), .A2(
        Midori_rounds_roundReg_out2[56]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F7_n29) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F7_U3 ( .A1(
        Midori_rounds_roundReg_out2[56]), .A2(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F7_n33), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F7_n32) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F7_U2 ( .A(
        Midori_rounds_roundReg_out2[59]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F7_n33) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F7_U1 ( .A(
        Midori_rounds_roundReg_out1[57]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F7_n31) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F8_U17 ( .A(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F8_n44), .B(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F8_n43), .S(
        Midori_rounds_roundReg_out2[57]), .Z(
        Midori_rounds_sub_sBox_PRINCE_14_e[8]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F8_U16 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F8_n42), .A2(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F8_n41), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F8_n44) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F8_U15 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F8_n40), .A2(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F8_n39), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_h[8]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F8_U14 ( .A1(
        Midori_rounds_roundReg_out2[57]), .A2(Midori_rounds_roundReg_out1[58]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F8_n39) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F8_U13 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F8_n38), .A2(
        Midori_rounds_roundReg_out2[59]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F8_n40) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F8_U12 ( .A1(
        Midori_rounds_roundReg_out2[57]), .A2(Midori_rounds_roundReg_out2[56]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F8_n38) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F8_U11 ( .A1(
        Midori_rounds_roundReg_out2[57]), .A2(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F8_n37), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_g[8]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F8_U10 ( .A(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F8_n36), .B(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F8_n35), .S(
        Midori_rounds_roundReg_out2[59]), .Z(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F8_n37) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F8_U9 ( .A1(
        Midori_rounds_roundReg_out2[56]), .A2(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F8_n43), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F8_n35) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F8_U8 ( .A(
        Midori_rounds_roundReg_out1[58]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F8_n43) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F8_U7 ( .A1(
        Midori_rounds_roundReg_out1[58]), .A2(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F8_n34), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F8_n36) );
  AND2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F8_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F8_n33), .A2(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F8_n42), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_f[4]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F8_U5 ( .A1(
        Midori_rounds_roundReg_out2[56]), .A2(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F8_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F8_n42) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F8_U4 ( .A1(
        Midori_rounds_roundReg_out2[59]), .A2(Midori_rounds_roundReg_out1[58]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F8_n32) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F8_U3 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F8_n41), .A2(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F8_n34), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F8_n33) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F8_U2 ( .A(
        Midori_rounds_roundReg_out2[56]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F8_n34) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F8_U1 ( .A1(
        Midori_rounds_roundReg_out2[59]), .A2(Midori_rounds_roundReg_out1[58]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_14_Inst_N_F8_n41) );
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_14_InAff_output_reg_s_current_state_reg_0_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_14_e[1]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_14_e_reg[1]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_14_InAff_output_reg_s_current_state_reg_1_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_14_e[2]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_14_e_reg[2]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_14_InAff_output_reg_s_current_state_reg_2_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_14_e[3]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_14_e_reg[3]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_14_InAff_output_reg_s_current_state_reg_3_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_14_e[4]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_14_e_reg[4]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_14_InAff_output_reg_s_current_state_reg_4_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_14_e[5]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_14_e_reg[5]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_14_InAff_output_reg_s_current_state_reg_5_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_14_e[6]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_14_e_reg[6]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_14_InAff_output_reg_s_current_state_reg_6_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_14_e[7]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_14_e_reg[7]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_14_InAff_output_reg_s_current_state_reg_7_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_14_e[8]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_14_e_reg[8]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_14_InAff_output_reg_s_current_state_reg_8_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_14_f[1]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_14_f_reg[1]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_14_InAff_output_reg_s_current_state_reg_9_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_14_f[2]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_14_f_reg[2]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_14_InAff_output_reg_s_current_state_reg_10_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_14_f[3]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_14_f_reg[3]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_14_InAff_output_reg_s_current_state_reg_11_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_14_f[4]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_14_f_reg[4]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_14_InAff_output_reg_s_current_state_reg_12_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_14_g[1]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_14_g_reg[1]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_14_InAff_output_reg_s_current_state_reg_13_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_14_g[2]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_14_g_reg[2]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_14_InAff_output_reg_s_current_state_reg_14_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_14_g[3]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_14_g_reg[3]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_14_InAff_output_reg_s_current_state_reg_15_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_14_g[4]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_14_g_reg[4]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_14_InAff_output_reg_s_current_state_reg_16_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_14_g[5]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_14_g_reg[5]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_14_InAff_output_reg_s_current_state_reg_17_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_14_g[6]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_14_g_reg[6]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_14_InAff_output_reg_s_current_state_reg_18_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_14_g[7]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_14_g_reg[7]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_14_InAff_output_reg_s_current_state_reg_19_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_14_g[8]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_14_g_reg[8]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_14_InAff_output_reg_s_current_state_reg_20_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_14_h[1]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_14_h_reg[1]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_14_InAff_output_reg_s_current_state_reg_21_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_14_h[2]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_14_h_reg[2]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_14_InAff_output_reg_s_current_state_reg_22_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_14_h[3]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_14_h_reg[3]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_14_InAff_output_reg_s_current_state_reg_23_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_14_h[4]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_14_h_reg[4]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_14_InAff_output_reg_s_current_state_reg_24_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_14_h[5]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_14_h_reg[5]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_14_InAff_output_reg_s_current_state_reg_25_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_14_h[6]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_14_h_reg[6]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_14_InAff_output_reg_s_current_state_reg_26_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_14_h[7]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_14_h_reg[7]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_14_InAff_output_reg_s_current_state_reg_27_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_14_h[8]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_14_h_reg[8]) , .QN() ); 
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_L_XORInst1_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_L_XORInst1_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_L_XORInst1_n5), .ZN(output1[56])
         );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_L_XORInst1_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_14_e_reg[2]), .B(
        Midori_rounds_sub_sBox_PRINCE_14_e_reg[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_L_XORInst1_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_L_XORInst1_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_14_e_reg[3]), .B(
        Midori_rounds_sub_sBox_PRINCE_14_e_reg[4]), .Z(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_L_XORInst1_n6) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_L_XORInst2_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_L_XORInst2_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_L_XORInst2_n5), .ZN(
        Midori_rounds_SR_Result2[32]) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_L_XORInst2_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_14_e_reg[6]), .B(
        Midori_rounds_sub_sBox_PRINCE_14_e_reg[5]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_L_XORInst2_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_L_XORInst2_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_14_e_reg[7]), .B(
        Midori_rounds_sub_sBox_PRINCE_14_e_reg[8]), .Z(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_L_XORInst2_n6) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_L_XORInst3_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_14_f_reg[2]), .B(
        Midori_rounds_sub_sBox_PRINCE_14_f_reg[1]), .Z(output1[57]) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_L_XORInst4_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_14_f_reg[4]), .B(
        Midori_rounds_sub_sBox_PRINCE_14_f_reg[3]), .Z(
        Midori_rounds_SR_Result2[33]) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_L_XORInst5_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_L_XORInst5_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_L_XORInst5_n5), .ZN(output1[58])
         );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_L_XORInst5_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_14_g_reg[2]), .B(
        Midori_rounds_sub_sBox_PRINCE_14_g_reg[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_L_XORInst5_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_L_XORInst5_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_14_g_reg[3]), .B(
        Midori_rounds_sub_sBox_PRINCE_14_g_reg[4]), .Z(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_L_XORInst5_n6) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_L_XORInst6_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_L_XORInst6_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_L_XORInst6_n5), .ZN(
        Midori_rounds_SR_Result2[34]) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_L_XORInst6_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_14_g_reg[6]), .B(
        Midori_rounds_sub_sBox_PRINCE_14_g_reg[5]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_L_XORInst6_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_L_XORInst6_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_14_g_reg[7]), .B(
        Midori_rounds_sub_sBox_PRINCE_14_g_reg[8]), .Z(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_L_XORInst6_n6) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_L_XORInst7_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_L_XORInst7_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_L_XORInst7_n5), .ZN(output1[59])
         );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_L_XORInst7_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_14_h_reg[2]), .B(
        Midori_rounds_sub_sBox_PRINCE_14_h_reg[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_L_XORInst7_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_L_XORInst7_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_14_h_reg[3]), .B(
        Midori_rounds_sub_sBox_PRINCE_14_h_reg[4]), .Z(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_L_XORInst7_n6) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_L_XORInst8_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_L_XORInst8_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_L_XORInst8_n5), .ZN(
        Midori_rounds_SR_Result2[35]) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_L_XORInst8_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_14_h_reg[6]), .B(
        Midori_rounds_sub_sBox_PRINCE_14_h_reg[5]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_L_XORInst8_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_14_Inst_L_XORInst8_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_14_h_reg[7]), .B(
        Midori_rounds_sub_sBox_PRINCE_14_h_reg[8]), .Z(
        Midori_rounds_sub_sBox_PRINCE_14_Inst_L_XORInst8_n6) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F1_U17 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F1_n43), .A2(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F1_n42), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_g[1]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F1_U16 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F1_n41), .A2(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F1_n40), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F1_n42) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F1_U15 ( .A1(
        Midori_rounds_roundReg_out2[62]), .A2(Midori_rounds_roundReg_out1[63]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F1_n40) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F1_U14 ( .A(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F1_n39), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F1_n43) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F1_U13 ( .A(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F1_n38), .B(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F1_n37), .S(
        Midori_rounds_roundReg_out1[61]), .Z(
        Midori_rounds_sub_sBox_PRINCE_15_e[1]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F1_U12 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F1_n36), .A2(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F1_n41), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F1_n38) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F1_U11 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F1_n35), .A2(
        Midori_rounds_roundReg_out1[63]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F1_n41) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F1_U10 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F1_n34), .A2(
        Midori_rounds_roundReg_out2[62]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F1_n36) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F1_U9 ( .A1(
        Midori_rounds_roundReg_out1[63]), .A2(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F1_n35), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F1_n34) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F1_U8 ( .A(
        Midori_rounds_roundReg_out1[60]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F1_n35) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F1_U7 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F1_n33), .A2(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F1_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_h[1]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F1_U6 ( .A1(
        Midori_rounds_roundReg_out1[63]), .A2(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F1_n39), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F1_n32) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F1_U5 ( .A1(
        Midori_rounds_roundReg_out1[61]), .A2(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F1_n31), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F1_n39) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F1_U4 ( .A1(
        Midori_rounds_roundReg_out2[62]), .A2(Midori_rounds_roundReg_out1[60]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F1_n31) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F1_U3 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F1_n30), .A2(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F1_n37), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F1_n33) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F1_U2 ( .A(
        Midori_rounds_roundReg_out2[62]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F1_n37) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F1_U1 ( .A1(
        Midori_rounds_roundReg_out1[63]), .A2(Midori_rounds_roundReg_out1[60]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F1_n30) );
  AND2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F2_U12 ( .A1(
        Midori_rounds_roundReg_out2[61]), .A2(
        Midori_rounds_sub_sBox_PRINCE_15_f[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_e[2]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F2_U11 ( .A(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F2_n33), .B(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F2_n32), .S(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F2_n31), .Z(
        Midori_rounds_sub_sBox_PRINCE_15_f[1]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F2_U10 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F2_n30), .A2(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F2_n29), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_g[2]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F2_U9 ( .A(
        Midori_rounds_roundReg_out1[62]), .B(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F2_n28), .S(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F2_n31), .Z(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F2_n29) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F2_U8 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F2_n32), .A2(
        Midori_rounds_roundReg_out2[61]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F2_n30) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F2_U7 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F2_n27), .A2(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F2_n26), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_h[2]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F2_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F2_n33), .A2(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F2_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F2_n26) );
  AND2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F2_U5 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F2_n28), .A2(
        Midori_rounds_roundReg_out1[62]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F2_n32) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F2_U4 ( .A1(
        Midori_rounds_roundReg_out1[62]), .A2(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F2_n28), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F2_n33) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F2_U3 ( .A(
        Midori_rounds_roundReg_out1[60]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F2_n28) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F2_U2 ( .A1(
        Midori_rounds_roundReg_out2[61]), .A2(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F2_n31), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F2_n27) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F2_U1 ( .A(
        Midori_rounds_roundReg_out1[63]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F2_n31) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F3_U13 ( .A1(
        Midori_rounds_roundReg_out1[61]), .A2(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F3_n35), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_g[3]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F3_U12 ( .A(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F3_n34), .B(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F3_n33), .S(
        Midori_rounds_roundReg_out2[60]), .Z(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F3_n35) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F3_U11 ( .A1(
        Midori_rounds_roundReg_out1[63]), .A2(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F3_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F3_n33) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F3_U10 ( .A1(
        Midori_rounds_roundReg_out1[62]), .A2(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F3_n31), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F3_n34) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F3_U9 ( .A(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F3_n30), .B(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F3_n29), .S(
        Midori_rounds_roundReg_out1[62]), .Z(
        Midori_rounds_sub_sBox_PRINCE_15_e[3]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F3_U8 ( .A1(
        Midori_rounds_roundReg_out2[60]), .A2(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F3_n28), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F3_n29) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F3_U7 ( .A1(
        Midori_rounds_roundReg_out1[61]), .A2(Midori_rounds_roundReg_out1[63]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F3_n28) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F3_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F3_n27), .A2(
        Midori_rounds_roundReg_out1[63]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F3_n30) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F3_U5 ( .A1(
        Midori_rounds_roundReg_out1[61]), .A2(Midori_rounds_roundReg_out2[60]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F3_n27) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F3_U4 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F3_n31), .A2(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F3_n26), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_h[3]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F3_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F3_n32), .B(
        Midori_rounds_roundReg_out2[60]), .S(Midori_rounds_roundReg_out1[61]), 
        .Z(Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F3_n26) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F3_U2 ( .A(
        Midori_rounds_roundReg_out1[62]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F3_n32) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F3_U1 ( .A(
        Midori_rounds_roundReg_out1[63]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F3_n31) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F4_U15 ( .A(
        Midori_rounds_roundReg_out2[60]), .B(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F4_n49), .S(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F4_n48), .Z(
        Midori_rounds_sub_sBox_PRINCE_15_h[4]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F4_U14 ( .A1(
        Midori_rounds_roundReg_out1[63]), .A2(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F4_n47), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F4_n48) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F4_U13 ( .A(
        Midori_rounds_roundReg_out2[61]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F4_n47) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F4_U12 ( .A(
        Midori_rounds_roundReg_out2[60]), .B(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F4_n46), .S(
        Midori_rounds_roundReg_out2[61]), .Z(
        Midori_rounds_sub_sBox_PRINCE_15_g[4]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F4_U11 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F4_n45), .A2(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F4_n44), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F4_n46) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F4_U10 ( .A1(
        Midori_rounds_roundReg_out2[62]), .A2(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F4_n43), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F4_n45) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F4_U9 ( .A(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F4_n42), .B(
        Midori_rounds_roundReg_out2[61]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_f[2]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F4_U8 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F4_n41), .A2(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F4_n44), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F4_n42) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F4_U7 ( .A1(
        Midori_rounds_roundReg_out2[61]), .A2(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F4_n40), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_e[4]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F4_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F4_n41), .A2(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F4_n39), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F4_n40) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F4_U5 ( .A1(
        Midori_rounds_roundReg_out2[62]), .A2(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F4_n44), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F4_n39) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F4_U4 ( .A1(
        Midori_rounds_roundReg_out2[60]), .A2(Midori_rounds_roundReg_out1[63]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F4_n44) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F4_U3 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F4_n49), .A2(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F4_n43), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F4_n41) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F4_U2 ( .A1(
        Midori_rounds_roundReg_out2[60]), .A2(Midori_rounds_roundReg_out1[63]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F4_n43) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F4_U1 ( .A(
        Midori_rounds_roundReg_out2[62]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F4_n49) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F5_U12 ( .A(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F5_n33), .B(
        Midori_rounds_roundReg_out1[60]), .S(Midori_rounds_roundReg_out1[61]), 
        .Z(Midori_rounds_sub_sBox_PRINCE_15_g[5]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F5_U11 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F5_n32), .A2(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F5_n31), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F5_n33) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F5_U10 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F5_n30), .A2(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F5_n29), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F5_n31) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F5_U9 ( .A(
        Midori_rounds_roundReg_out1[60]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F5_n30) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F5_U8 ( .A(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F5_n28), .B(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F5_n27), .S(
        Midori_rounds_roundReg_out1[60]), .Z(
        Midori_rounds_sub_sBox_PRINCE_15_e[5]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F5_U7 ( .A1(
        Midori_rounds_roundReg_out1[61]), .A2(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F5_n29), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F5_n27) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F5_U6 ( .A1(
        Midori_rounds_roundReg_out2[63]), .A2(Midori_rounds_roundReg_out1[62]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F5_n29) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F5_U5 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F5_n28), .A2(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F5_n26), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_h[5]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F5_U4 ( .A1(
        Midori_rounds_roundReg_out2[63]), .A2(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F5_n25), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F5_n26) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F5_U3 ( .A1(
        Midori_rounds_roundReg_out1[61]), .A2(Midori_rounds_roundReg_out1[60]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F5_n25) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F5_U2 ( .A1(
        Midori_rounds_roundReg_out1[61]), .A2(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F5_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F5_n28) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F5_U1 ( .A1(
        Midori_rounds_roundReg_out2[63]), .A2(Midori_rounds_roundReg_out1[62]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F5_n32) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_U22 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_n62), .A2(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_n61), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_h[6]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_U21 ( .A1(
        Midori_rounds_roundReg_out2[61]), .A2(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_n60), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_n61) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_U20 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_n59), .A2(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_n58), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_n62) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_U19 ( .A(
        Midori_rounds_roundReg_out2[63]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_n58) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_U18 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_n57), .A2(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_n56), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_n59) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_U17 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_n57), .A2(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_n55), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_e[6]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_U16 ( .A(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_n54), .B(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_n53), .S(
        Midori_rounds_roundReg_out2[63]), .Z(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_n55) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_U15 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_n52), .A2(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_n51), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_f[3]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_U14 ( .A1(
        Midori_rounds_roundReg_out2[61]), .A2(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_n50), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_n51) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_U13 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_n49), .A2(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_n48), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_n52) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_U12 ( .A(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_n50), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_n48) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_U11 ( .A1(
        Midori_rounds_roundReg_out2[62]), .A2(Midori_rounds_roundReg_out1[60]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_n50) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_U10 ( .A(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_n47), .B(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_n57), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_n49) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_U9 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_n46), .A2(
        Midori_rounds_roundReg_out2[63]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_n47) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_U8 ( .A1(
        Midori_rounds_roundReg_out2[62]), .A2(Midori_rounds_roundReg_out1[60]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_n46) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_U7 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_n57), .A2(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_n45), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_g[6]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_U6 ( .A(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_n53), .B(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_n54), .S(
        Midori_rounds_roundReg_out2[63]), .Z(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_n45) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_U5 ( .A1(
        Midori_rounds_roundReg_out2[62]), .A2(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_n60), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_n54) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_U4 ( .A(
        Midori_rounds_roundReg_out1[60]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_n60) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_U3 ( .A1(
        Midori_rounds_roundReg_out1[60]), .A2(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_n56), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_n53) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_U2 ( .A(
        Midori_rounds_roundReg_out2[62]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_n56) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_U1 ( .A(
        Midori_rounds_roundReg_out2[61]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F6_n57) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F7_U11 ( .A(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F7_n35), .B(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F7_n34), .S(
        Midori_rounds_roundReg_out1[61]), .Z(
        Midori_rounds_sub_sBox_PRINCE_15_h[7]) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F7_U10 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F7_n33), .A2(
        Midori_rounds_roundReg_out2[62]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F7_n34) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F7_U9 ( .A(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F7_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F7_n35) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F7_U8 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F7_n31), .A2(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F7_n30), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_g[7]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F7_U7 ( .A(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F7_n29), .B(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F7_n32), .S(
        Midori_rounds_roundReg_out2[62]), .Z(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F7_n30) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F7_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F7_n31), .A2(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F7_n28), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_e[7]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F7_U5 ( .A(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F7_n32), .B(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F7_n29), .S(
        Midori_rounds_roundReg_out2[62]), .Z(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F7_n28) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F7_U4 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F7_n33), .A2(
        Midori_rounds_roundReg_out2[60]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F7_n29) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F7_U3 ( .A1(
        Midori_rounds_roundReg_out2[60]), .A2(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F7_n33), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F7_n32) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F7_U2 ( .A(
        Midori_rounds_roundReg_out2[63]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F7_n33) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F7_U1 ( .A(
        Midori_rounds_roundReg_out1[61]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F7_n31) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F8_U17 ( .A(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F8_n44), .B(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F8_n43), .S(
        Midori_rounds_roundReg_out2[61]), .Z(
        Midori_rounds_sub_sBox_PRINCE_15_e[8]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F8_U16 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F8_n42), .A2(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F8_n41), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F8_n44) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F8_U15 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F8_n40), .A2(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F8_n39), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_h[8]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F8_U14 ( .A1(
        Midori_rounds_roundReg_out2[61]), .A2(Midori_rounds_roundReg_out1[62]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F8_n39) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F8_U13 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F8_n38), .A2(
        Midori_rounds_roundReg_out2[63]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F8_n40) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F8_U12 ( .A1(
        Midori_rounds_roundReg_out2[61]), .A2(Midori_rounds_roundReg_out2[60]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F8_n38) );
  NOR2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F8_U11 ( .A1(
        Midori_rounds_roundReg_out2[61]), .A2(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F8_n37), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_g[8]) );
  MUX2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F8_U10 ( .A(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F8_n36), .B(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F8_n35), .S(
        Midori_rounds_roundReg_out2[63]), .Z(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F8_n37) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F8_U9 ( .A1(
        Midori_rounds_roundReg_out2[60]), .A2(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F8_n43), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F8_n35) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F8_U8 ( .A(
        Midori_rounds_roundReg_out1[62]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F8_n43) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F8_U7 ( .A1(
        Midori_rounds_roundReg_out1[62]), .A2(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F8_n34), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F8_n36) );
  AND2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F8_U6 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F8_n33), .A2(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F8_n42), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_f[4]) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F8_U5 ( .A1(
        Midori_rounds_roundReg_out2[60]), .A2(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F8_n32), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F8_n42) );
  OR2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F8_U4 ( .A1(
        Midori_rounds_roundReg_out2[63]), .A2(Midori_rounds_roundReg_out1[62]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F8_n32) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F8_U3 ( .A1(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F8_n41), .A2(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F8_n34), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F8_n33) );
  INV_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F8_U2 ( .A(
        Midori_rounds_roundReg_out2[60]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F8_n34) );
  NAND2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F8_U1 ( .A1(
        Midori_rounds_roundReg_out2[63]), .A2(Midori_rounds_roundReg_out1[62]), 
        .ZN(Midori_rounds_sub_sBox_PRINCE_15_Inst_N_F8_n41) );
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_15_InAff_output_reg_s_current_state_reg_0_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_15_e[1]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_15_e_reg[1]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_15_InAff_output_reg_s_current_state_reg_1_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_15_e[2]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_15_e_reg[2]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_15_InAff_output_reg_s_current_state_reg_2_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_15_e[3]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_15_e_reg[3]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_15_InAff_output_reg_s_current_state_reg_3_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_15_e[4]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_15_e_reg[4]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_15_InAff_output_reg_s_current_state_reg_4_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_15_e[5]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_15_e_reg[5]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_15_InAff_output_reg_s_current_state_reg_5_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_15_e[6]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_15_e_reg[6]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_15_InAff_output_reg_s_current_state_reg_6_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_15_e[7]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_15_e_reg[7]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_15_InAff_output_reg_s_current_state_reg_7_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_15_e[8]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_15_e_reg[8]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_15_InAff_output_reg_s_current_state_reg_8_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_15_f[1]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_15_f_reg[1]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_15_InAff_output_reg_s_current_state_reg_9_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_15_f[2]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_15_f_reg[2]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_15_InAff_output_reg_s_current_state_reg_10_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_15_f[3]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_15_f_reg[3]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_15_InAff_output_reg_s_current_state_reg_11_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_15_f[4]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_15_f_reg[4]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_15_InAff_output_reg_s_current_state_reg_12_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_15_g[1]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_15_g_reg[1]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_15_InAff_output_reg_s_current_state_reg_13_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_15_g[2]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_15_g_reg[2]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_15_InAff_output_reg_s_current_state_reg_14_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_15_g[3]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_15_g_reg[3]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_15_InAff_output_reg_s_current_state_reg_15_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_15_g[4]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_15_g_reg[4]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_15_InAff_output_reg_s_current_state_reg_16_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_15_g[5]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_15_g_reg[5]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_15_InAff_output_reg_s_current_state_reg_17_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_15_g[6]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_15_g_reg[6]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_15_InAff_output_reg_s_current_state_reg_18_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_15_g[7]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_15_g_reg[7]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_15_InAff_output_reg_s_current_state_reg_19_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_15_g[8]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_15_g_reg[8]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_15_InAff_output_reg_s_current_state_reg_20_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_15_h[1]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_15_h_reg[1]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_15_InAff_output_reg_s_current_state_reg_21_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_15_h[2]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_15_h_reg[2]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_15_InAff_output_reg_s_current_state_reg_22_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_15_h[3]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_15_h_reg[3]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_15_InAff_output_reg_s_current_state_reg_23_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_15_h[4]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_15_h_reg[4]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_15_InAff_output_reg_s_current_state_reg_24_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_15_h[5]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_15_h_reg[5]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_15_InAff_output_reg_s_current_state_reg_25_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_15_h[6]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_15_h_reg[6]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_15_InAff_output_reg_s_current_state_reg_26_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_15_h[7]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_15_h_reg[7]) , .QN() ); 
  DFF_X1 Midori_rounds_sub_sBox_PRINCE_15_InAff_output_reg_s_current_state_reg_27_ ( 
        .D(Midori_rounds_sub_sBox_PRINCE_15_h[8]), .CK(clk), .Q(
        Midori_rounds_sub_sBox_PRINCE_15_h_reg[8]) , .QN() ); 
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_L_XORInst1_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_L_XORInst1_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_L_XORInst1_n5), .ZN(output1[60])
         );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_L_XORInst1_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_15_e_reg[2]), .B(
        Midori_rounds_sub_sBox_PRINCE_15_e_reg[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_L_XORInst1_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_L_XORInst1_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_15_e_reg[3]), .B(
        Midori_rounds_sub_sBox_PRINCE_15_e_reg[4]), .Z(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_L_XORInst1_n6) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_L_XORInst2_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_L_XORInst2_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_L_XORInst2_n5), .ZN(
        Midori_rounds_SR_Result2[60]) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_L_XORInst2_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_15_e_reg[6]), .B(
        Midori_rounds_sub_sBox_PRINCE_15_e_reg[5]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_L_XORInst2_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_L_XORInst2_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_15_e_reg[7]), .B(
        Midori_rounds_sub_sBox_PRINCE_15_e_reg[8]), .Z(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_L_XORInst2_n6) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_L_XORInst3_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_15_f_reg[2]), .B(
        Midori_rounds_sub_sBox_PRINCE_15_f_reg[1]), .Z(output1[61]) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_L_XORInst4_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_15_f_reg[4]), .B(
        Midori_rounds_sub_sBox_PRINCE_15_f_reg[3]), .Z(
        Midori_rounds_SR_Result2[61]) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_L_XORInst5_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_L_XORInst5_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_L_XORInst5_n5), .ZN(output1[62])
         );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_L_XORInst5_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_15_g_reg[2]), .B(
        Midori_rounds_sub_sBox_PRINCE_15_g_reg[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_L_XORInst5_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_L_XORInst5_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_15_g_reg[3]), .B(
        Midori_rounds_sub_sBox_PRINCE_15_g_reg[4]), .Z(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_L_XORInst5_n6) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_L_XORInst6_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_L_XORInst6_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_L_XORInst6_n5), .ZN(
        Midori_rounds_SR_Result2[62]) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_L_XORInst6_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_15_g_reg[6]), .B(
        Midori_rounds_sub_sBox_PRINCE_15_g_reg[5]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_L_XORInst6_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_L_XORInst6_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_15_g_reg[7]), .B(
        Midori_rounds_sub_sBox_PRINCE_15_g_reg[8]), .Z(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_L_XORInst6_n6) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_L_XORInst7_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_L_XORInst7_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_L_XORInst7_n5), .ZN(output1[63])
         );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_L_XORInst7_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_15_h_reg[2]), .B(
        Midori_rounds_sub_sBox_PRINCE_15_h_reg[1]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_L_XORInst7_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_L_XORInst7_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_15_h_reg[3]), .B(
        Midori_rounds_sub_sBox_PRINCE_15_h_reg[4]), .Z(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_L_XORInst7_n6) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_L_XORInst8_U3 ( .A(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_L_XORInst8_n6), .B(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_L_XORInst8_n5), .ZN(
        Midori_rounds_SR_Result2[63]) );
  XNOR2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_L_XORInst8_U2 ( .A(
        Midori_rounds_sub_sBox_PRINCE_15_h_reg[6]), .B(
        Midori_rounds_sub_sBox_PRINCE_15_h_reg[5]), .ZN(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_L_XORInst8_n5) );
  XOR2_X1 Midori_rounds_sub_sBox_PRINCE_15_Inst_L_XORInst8_U1 ( .A(
        Midori_rounds_sub_sBox_PRINCE_15_h_reg[7]), .B(
        Midori_rounds_sub_sBox_PRINCE_15_h_reg[8]), .Z(
        Midori_rounds_sub_sBox_PRINCE_15_Inst_L_XORInst8_n6) );
  XNOR2_X1 Midori_rounds_mul1_MC1_U24 ( .A(Midori_rounds_mul_input1[59]), .B(
        Midori_rounds_mul1_MC1_n8), .ZN(Midori_rounds_SR_Inv_Result1[63]) );
  XNOR2_X1 Midori_rounds_mul1_MC1_U23 ( .A(Midori_rounds_mul_input1[63]), .B(
        Midori_rounds_mul1_MC1_n8), .ZN(Midori_rounds_SR_Inv_Result1[23]) );
  XNOR2_X1 Midori_rounds_mul1_MC1_U22 ( .A(Midori_rounds_mul_input1[55]), .B(
        Midori_rounds_mul_input1[51]), .ZN(Midori_rounds_mul1_MC1_n8) );
  XNOR2_X1 Midori_rounds_mul1_MC1_U21 ( .A(Midori_rounds_mul_input1[58]), .B(
        Midori_rounds_mul1_MC1_n7), .ZN(Midori_rounds_SR_Inv_Result1[62]) );
  XNOR2_X1 Midori_rounds_mul1_MC1_U20 ( .A(Midori_rounds_mul_input1[62]), .B(
        Midori_rounds_mul1_MC1_n7), .ZN(Midori_rounds_SR_Inv_Result1[22]) );
  XNOR2_X1 Midori_rounds_mul1_MC1_U19 ( .A(Midori_rounds_mul_input1[54]), .B(
        Midori_rounds_mul_input1[50]), .ZN(Midori_rounds_mul1_MC1_n7) );
  XNOR2_X1 Midori_rounds_mul1_MC1_U18 ( .A(Midori_rounds_mul_input1[56]), .B(
        Midori_rounds_mul1_MC1_n6), .ZN(Midori_rounds_SR_Inv_Result1[60]) );
  XNOR2_X1 Midori_rounds_mul1_MC1_U17 ( .A(Midori_rounds_mul_input1[60]), .B(
        Midori_rounds_mul1_MC1_n6), .ZN(Midori_rounds_SR_Inv_Result1[20]) );
  XNOR2_X1 Midori_rounds_mul1_MC1_U16 ( .A(Midori_rounds_mul_input1[52]), .B(
        Midori_rounds_mul_input1[48]), .ZN(Midori_rounds_mul1_MC1_n6) );
  XNOR2_X1 Midori_rounds_mul1_MC1_U15 ( .A(Midori_rounds_mul_input1[51]), .B(
        Midori_rounds_mul1_MC1_n5), .ZN(Midori_rounds_SR_Inv_Result1[43]) );
  XNOR2_X1 Midori_rounds_mul1_MC1_U14 ( .A(Midori_rounds_mul_input1[55]), .B(
        Midori_rounds_mul1_MC1_n5), .ZN(Midori_rounds_SR_Inv_Result1[3]) );
  XNOR2_X1 Midori_rounds_mul1_MC1_U13 ( .A(Midori_rounds_mul_input1[59]), .B(
        Midori_rounds_mul_input1[63]), .ZN(Midori_rounds_mul1_MC1_n5) );
  XNOR2_X1 Midori_rounds_mul1_MC1_U12 ( .A(Midori_rounds_mul_input1[57]), .B(
        Midori_rounds_mul1_MC1_n4), .ZN(Midori_rounds_SR_Inv_Result1[61]) );
  XNOR2_X1 Midori_rounds_mul1_MC1_U11 ( .A(Midori_rounds_mul_input1[61]), .B(
        Midori_rounds_mul1_MC1_n4), .ZN(Midori_rounds_SR_Inv_Result1[21]) );
  XNOR2_X1 Midori_rounds_mul1_MC1_U10 ( .A(Midori_rounds_mul_input1[53]), .B(
        Midori_rounds_mul_input1[49]), .ZN(Midori_rounds_mul1_MC1_n4) );
  XNOR2_X1 Midori_rounds_mul1_MC1_U9 ( .A(Midori_rounds_mul_input1[50]), .B(
        Midori_rounds_mul1_MC1_n3), .ZN(Midori_rounds_SR_Inv_Result1[42]) );
  XNOR2_X1 Midori_rounds_mul1_MC1_U8 ( .A(Midori_rounds_mul_input1[54]), .B(
        Midori_rounds_mul1_MC1_n3), .ZN(Midori_rounds_SR_Inv_Result1[2]) );
  XNOR2_X1 Midori_rounds_mul1_MC1_U7 ( .A(Midori_rounds_mul_input1[58]), .B(
        Midori_rounds_mul_input1[62]), .ZN(Midori_rounds_mul1_MC1_n3) );
  XNOR2_X1 Midori_rounds_mul1_MC1_U6 ( .A(Midori_rounds_mul_input1[49]), .B(
        Midori_rounds_mul1_MC1_n2), .ZN(Midori_rounds_SR_Inv_Result1[41]) );
  XNOR2_X1 Midori_rounds_mul1_MC1_U5 ( .A(Midori_rounds_mul_input1[53]), .B(
        Midori_rounds_mul1_MC1_n2), .ZN(Midori_rounds_SR_Inv_Result1[1]) );
  XNOR2_X1 Midori_rounds_mul1_MC1_U4 ( .A(Midori_rounds_mul_input1[57]), .B(
        Midori_rounds_mul_input1[61]), .ZN(Midori_rounds_mul1_MC1_n2) );
  XNOR2_X1 Midori_rounds_mul1_MC1_U3 ( .A(Midori_rounds_mul_input1[48]), .B(
        Midori_rounds_mul1_MC1_n1), .ZN(Midori_rounds_SR_Inv_Result1[40]) );
  XNOR2_X1 Midori_rounds_mul1_MC1_U2 ( .A(Midori_rounds_mul_input1[52]), .B(
        Midori_rounds_mul1_MC1_n1), .ZN(Midori_rounds_SR_Inv_Result1[0]) );
  XNOR2_X1 Midori_rounds_mul1_MC1_U1 ( .A(Midori_rounds_mul_input1[56]), .B(
        Midori_rounds_mul_input1[60]), .ZN(Midori_rounds_mul1_MC1_n1) );
  XNOR2_X1 Midori_rounds_mul1_MC2_U24 ( .A(Midori_rounds_mul_input1[43]), .B(
        Midori_rounds_mul1_MC2_n24), .ZN(Midori_rounds_SR_Inv_Result1[7]) );
  XNOR2_X1 Midori_rounds_mul1_MC2_U23 ( .A(Midori_rounds_mul_input1[47]), .B(
        Midori_rounds_mul1_MC2_n24), .ZN(Midori_rounds_SR_Inv_Result1[47]) );
  XNOR2_X1 Midori_rounds_mul1_MC2_U22 ( .A(Midori_rounds_mul_input1[39]), .B(
        Midori_rounds_mul_input1[35]), .ZN(Midori_rounds_mul1_MC2_n24) );
  XNOR2_X1 Midori_rounds_mul1_MC2_U21 ( .A(Midori_rounds_mul_input1[42]), .B(
        Midori_rounds_mul1_MC2_n23), .ZN(Midori_rounds_SR_Inv_Result1[6]) );
  XNOR2_X1 Midori_rounds_mul1_MC2_U20 ( .A(Midori_rounds_mul_input1[46]), .B(
        Midori_rounds_mul1_MC2_n23), .ZN(Midori_rounds_SR_Inv_Result1[46]) );
  XNOR2_X1 Midori_rounds_mul1_MC2_U19 ( .A(Midori_rounds_mul_input1[38]), .B(
        Midori_rounds_mul_input1[34]), .ZN(Midori_rounds_mul1_MC2_n23) );
  XNOR2_X1 Midori_rounds_mul1_MC2_U18 ( .A(Midori_rounds_mul_input1[40]), .B(
        Midori_rounds_mul1_MC2_n22), .ZN(Midori_rounds_SR_Inv_Result1[4]) );
  XNOR2_X1 Midori_rounds_mul1_MC2_U17 ( .A(Midori_rounds_mul_input1[44]), .B(
        Midori_rounds_mul1_MC2_n22), .ZN(Midori_rounds_SR_Inv_Result1[44]) );
  XNOR2_X1 Midori_rounds_mul1_MC2_U16 ( .A(Midori_rounds_mul_input1[36]), .B(
        Midori_rounds_mul_input1[32]), .ZN(Midori_rounds_mul1_MC2_n22) );
  XNOR2_X1 Midori_rounds_mul1_MC2_U15 ( .A(Midori_rounds_mul_input1[35]), .B(
        Midori_rounds_mul1_MC2_n21), .ZN(Midori_rounds_SR_Inv_Result1[19]) );
  XNOR2_X1 Midori_rounds_mul1_MC2_U14 ( .A(Midori_rounds_mul_input1[39]), .B(
        Midori_rounds_mul1_MC2_n21), .ZN(Midori_rounds_SR_Inv_Result1[59]) );
  XNOR2_X1 Midori_rounds_mul1_MC2_U13 ( .A(Midori_rounds_mul_input1[43]), .B(
        Midori_rounds_mul_input1[47]), .ZN(Midori_rounds_mul1_MC2_n21) );
  XNOR2_X1 Midori_rounds_mul1_MC2_U12 ( .A(Midori_rounds_mul_input1[41]), .B(
        Midori_rounds_mul1_MC2_n20), .ZN(Midori_rounds_SR_Inv_Result1[5]) );
  XNOR2_X1 Midori_rounds_mul1_MC2_U11 ( .A(Midori_rounds_mul_input1[45]), .B(
        Midori_rounds_mul1_MC2_n20), .ZN(Midori_rounds_SR_Inv_Result1[45]) );
  XNOR2_X1 Midori_rounds_mul1_MC2_U10 ( .A(Midori_rounds_mul_input1[37]), .B(
        Midori_rounds_mul_input1[33]), .ZN(Midori_rounds_mul1_MC2_n20) );
  XNOR2_X1 Midori_rounds_mul1_MC2_U9 ( .A(Midori_rounds_mul_input1[34]), .B(
        Midori_rounds_mul1_MC2_n19), .ZN(Midori_rounds_SR_Inv_Result1[18]) );
  XNOR2_X1 Midori_rounds_mul1_MC2_U8 ( .A(Midori_rounds_mul_input1[38]), .B(
        Midori_rounds_mul1_MC2_n19), .ZN(Midori_rounds_SR_Inv_Result1[58]) );
  XNOR2_X1 Midori_rounds_mul1_MC2_U7 ( .A(Midori_rounds_mul_input1[42]), .B(
        Midori_rounds_mul_input1[46]), .ZN(Midori_rounds_mul1_MC2_n19) );
  XNOR2_X1 Midori_rounds_mul1_MC2_U6 ( .A(Midori_rounds_mul_input1[33]), .B(
        Midori_rounds_mul1_MC2_n18), .ZN(Midori_rounds_SR_Inv_Result1[17]) );
  XNOR2_X1 Midori_rounds_mul1_MC2_U5 ( .A(Midori_rounds_mul_input1[37]), .B(
        Midori_rounds_mul1_MC2_n18), .ZN(Midori_rounds_SR_Inv_Result1[57]) );
  XNOR2_X1 Midori_rounds_mul1_MC2_U4 ( .A(Midori_rounds_mul_input1[41]), .B(
        Midori_rounds_mul_input1[45]), .ZN(Midori_rounds_mul1_MC2_n18) );
  XNOR2_X1 Midori_rounds_mul1_MC2_U3 ( .A(Midori_rounds_mul_input1[32]), .B(
        Midori_rounds_mul1_MC2_n17), .ZN(Midori_rounds_SR_Inv_Result1[16]) );
  XNOR2_X1 Midori_rounds_mul1_MC2_U2 ( .A(Midori_rounds_mul_input1[36]), .B(
        Midori_rounds_mul1_MC2_n17), .ZN(Midori_rounds_SR_Inv_Result1[56]) );
  XNOR2_X1 Midori_rounds_mul1_MC2_U1 ( .A(Midori_rounds_mul_input1[40]), .B(
        Midori_rounds_mul_input1[44]), .ZN(Midori_rounds_mul1_MC2_n17) );
  XNOR2_X1 Midori_rounds_mul1_MC3_U24 ( .A(Midori_rounds_mul_input1[27]), .B(
        Midori_rounds_mul1_MC3_n24), .ZN(Midori_rounds_SR_Inv_Result1[27]) );
  XNOR2_X1 Midori_rounds_mul1_MC3_U23 ( .A(Midori_rounds_mul_input1[31]), .B(
        Midori_rounds_mul1_MC3_n24), .ZN(Midori_rounds_SR_Inv_Result1[51]) );
  XNOR2_X1 Midori_rounds_mul1_MC3_U22 ( .A(Midori_rounds_mul_input1[23]), .B(
        Midori_rounds_mul_input1[19]), .ZN(Midori_rounds_mul1_MC3_n24) );
  XNOR2_X1 Midori_rounds_mul1_MC3_U21 ( .A(Midori_rounds_mul_input1[26]), .B(
        Midori_rounds_mul1_MC3_n23), .ZN(Midori_rounds_SR_Inv_Result1[26]) );
  XNOR2_X1 Midori_rounds_mul1_MC3_U20 ( .A(Midori_rounds_mul_input1[30]), .B(
        Midori_rounds_mul1_MC3_n23), .ZN(Midori_rounds_SR_Inv_Result1[50]) );
  XNOR2_X1 Midori_rounds_mul1_MC3_U19 ( .A(Midori_rounds_mul_input1[22]), .B(
        Midori_rounds_mul_input1[18]), .ZN(Midori_rounds_mul1_MC3_n23) );
  XNOR2_X1 Midori_rounds_mul1_MC3_U18 ( .A(Midori_rounds_mul_input1[24]), .B(
        Midori_rounds_mul1_MC3_n22), .ZN(Midori_rounds_SR_Inv_Result1[24]) );
  XNOR2_X1 Midori_rounds_mul1_MC3_U17 ( .A(Midori_rounds_mul_input1[28]), .B(
        Midori_rounds_mul1_MC3_n22), .ZN(Midori_rounds_SR_Inv_Result1[48]) );
  XNOR2_X1 Midori_rounds_mul1_MC3_U16 ( .A(Midori_rounds_mul_input1[20]), .B(
        Midori_rounds_mul_input1[16]), .ZN(Midori_rounds_mul1_MC3_n22) );
  XNOR2_X1 Midori_rounds_mul1_MC3_U15 ( .A(Midori_rounds_mul_input1[19]), .B(
        Midori_rounds_mul1_MC3_n21), .ZN(Midori_rounds_SR_Inv_Result1[15]) );
  XNOR2_X1 Midori_rounds_mul1_MC3_U14 ( .A(Midori_rounds_mul_input1[23]), .B(
        Midori_rounds_mul1_MC3_n21), .ZN(Midori_rounds_SR_Inv_Result1[39]) );
  XNOR2_X1 Midori_rounds_mul1_MC3_U13 ( .A(Midori_rounds_mul_input1[27]), .B(
        Midori_rounds_mul_input1[31]), .ZN(Midori_rounds_mul1_MC3_n21) );
  XNOR2_X1 Midori_rounds_mul1_MC3_U12 ( .A(Midori_rounds_mul_input1[25]), .B(
        Midori_rounds_mul1_MC3_n20), .ZN(Midori_rounds_SR_Inv_Result1[25]) );
  XNOR2_X1 Midori_rounds_mul1_MC3_U11 ( .A(Midori_rounds_mul_input1[29]), .B(
        Midori_rounds_mul1_MC3_n20), .ZN(Midori_rounds_SR_Inv_Result1[49]) );
  XNOR2_X1 Midori_rounds_mul1_MC3_U10 ( .A(Midori_rounds_mul_input1[21]), .B(
        Midori_rounds_mul_input1[17]), .ZN(Midori_rounds_mul1_MC3_n20) );
  XNOR2_X1 Midori_rounds_mul1_MC3_U9 ( .A(Midori_rounds_mul_input1[18]), .B(
        Midori_rounds_mul1_MC3_n19), .ZN(Midori_rounds_SR_Inv_Result1[14]) );
  XNOR2_X1 Midori_rounds_mul1_MC3_U8 ( .A(Midori_rounds_mul_input1[22]), .B(
        Midori_rounds_mul1_MC3_n19), .ZN(Midori_rounds_SR_Inv_Result1[38]) );
  XNOR2_X1 Midori_rounds_mul1_MC3_U7 ( .A(Midori_rounds_mul_input1[26]), .B(
        Midori_rounds_mul_input1[30]), .ZN(Midori_rounds_mul1_MC3_n19) );
  XNOR2_X1 Midori_rounds_mul1_MC3_U6 ( .A(Midori_rounds_mul_input1[17]), .B(
        Midori_rounds_mul1_MC3_n18), .ZN(Midori_rounds_SR_Inv_Result1[13]) );
  XNOR2_X1 Midori_rounds_mul1_MC3_U5 ( .A(Midori_rounds_mul_input1[21]), .B(
        Midori_rounds_mul1_MC3_n18), .ZN(Midori_rounds_SR_Inv_Result1[37]) );
  XNOR2_X1 Midori_rounds_mul1_MC3_U4 ( .A(Midori_rounds_mul_input1[25]), .B(
        Midori_rounds_mul_input1[29]), .ZN(Midori_rounds_mul1_MC3_n18) );
  XNOR2_X1 Midori_rounds_mul1_MC3_U3 ( .A(Midori_rounds_mul_input1[16]), .B(
        Midori_rounds_mul1_MC3_n17), .ZN(Midori_rounds_SR_Inv_Result1[12]) );
  XNOR2_X1 Midori_rounds_mul1_MC3_U2 ( .A(Midori_rounds_mul_input1[20]), .B(
        Midori_rounds_mul1_MC3_n17), .ZN(Midori_rounds_SR_Inv_Result1[36]) );
  XNOR2_X1 Midori_rounds_mul1_MC3_U1 ( .A(Midori_rounds_mul_input1[24]), .B(
        Midori_rounds_mul_input1[28]), .ZN(Midori_rounds_mul1_MC3_n17) );
  XNOR2_X1 Midori_rounds_mul1_MC4_U24 ( .A(Midori_rounds_mul_input1[11]), .B(
        Midori_rounds_mul1_MC4_n24), .ZN(Midori_rounds_SR_Inv_Result1[35]) );
  XNOR2_X1 Midori_rounds_mul1_MC4_U23 ( .A(Midori_rounds_mul_input1[15]), .B(
        Midori_rounds_mul1_MC4_n24), .ZN(Midori_rounds_SR_Inv_Result1[11]) );
  XNOR2_X1 Midori_rounds_mul1_MC4_U22 ( .A(Midori_rounds_mul_input1[7]), .B(
        Midori_rounds_mul_input1[3]), .ZN(Midori_rounds_mul1_MC4_n24) );
  XNOR2_X1 Midori_rounds_mul1_MC4_U21 ( .A(Midori_rounds_mul_input1[10]), .B(
        Midori_rounds_mul1_MC4_n23), .ZN(Midori_rounds_SR_Inv_Result1[34]) );
  XNOR2_X1 Midori_rounds_mul1_MC4_U20 ( .A(Midori_rounds_mul_input1[14]), .B(
        Midori_rounds_mul1_MC4_n23), .ZN(Midori_rounds_SR_Inv_Result1[10]) );
  XNOR2_X1 Midori_rounds_mul1_MC4_U19 ( .A(Midori_rounds_mul_input1[6]), .B(
        Midori_rounds_mul_input1[2]), .ZN(Midori_rounds_mul1_MC4_n23) );
  XNOR2_X1 Midori_rounds_mul1_MC4_U18 ( .A(Midori_rounds_mul_input1[8]), .B(
        Midori_rounds_mul1_MC4_n22), .ZN(Midori_rounds_SR_Inv_Result1[32]) );
  XNOR2_X1 Midori_rounds_mul1_MC4_U17 ( .A(Midori_rounds_mul_input1[12]), .B(
        Midori_rounds_mul1_MC4_n22), .ZN(Midori_rounds_SR_Inv_Result1[8]) );
  XNOR2_X1 Midori_rounds_mul1_MC4_U16 ( .A(Midori_rounds_mul_input1[4]), .B(
        Midori_rounds_mul_input1[0]), .ZN(Midori_rounds_mul1_MC4_n22) );
  XNOR2_X1 Midori_rounds_mul1_MC4_U15 ( .A(Midori_rounds_mul_input1[3]), .B(
        Midori_rounds_mul1_MC4_n21), .ZN(Midori_rounds_SR_Inv_Result1[55]) );
  XNOR2_X1 Midori_rounds_mul1_MC4_U14 ( .A(Midori_rounds_mul_input1[7]), .B(
        Midori_rounds_mul1_MC4_n21), .ZN(Midori_rounds_SR_Inv_Result1[31]) );
  XNOR2_X1 Midori_rounds_mul1_MC4_U13 ( .A(Midori_rounds_mul_input1[11]), .B(
        Midori_rounds_mul_input1[15]), .ZN(Midori_rounds_mul1_MC4_n21) );
  XNOR2_X1 Midori_rounds_mul1_MC4_U12 ( .A(Midori_rounds_mul_input1[9]), .B(
        Midori_rounds_mul1_MC4_n20), .ZN(Midori_rounds_SR_Inv_Result1[33]) );
  XNOR2_X1 Midori_rounds_mul1_MC4_U11 ( .A(Midori_rounds_mul_input1[13]), .B(
        Midori_rounds_mul1_MC4_n20), .ZN(Midori_rounds_SR_Inv_Result1[9]) );
  XNOR2_X1 Midori_rounds_mul1_MC4_U10 ( .A(Midori_rounds_mul_input1[5]), .B(
        Midori_rounds_mul_input1[1]), .ZN(Midori_rounds_mul1_MC4_n20) );
  XNOR2_X1 Midori_rounds_mul1_MC4_U9 ( .A(Midori_rounds_mul_input1[2]), .B(
        Midori_rounds_mul1_MC4_n19), .ZN(Midori_rounds_SR_Inv_Result1[54]) );
  XNOR2_X1 Midori_rounds_mul1_MC4_U8 ( .A(Midori_rounds_mul_input1[6]), .B(
        Midori_rounds_mul1_MC4_n19), .ZN(Midori_rounds_SR_Inv_Result1[30]) );
  XNOR2_X1 Midori_rounds_mul1_MC4_U7 ( .A(Midori_rounds_mul_input1[10]), .B(
        Midori_rounds_mul_input1[14]), .ZN(Midori_rounds_mul1_MC4_n19) );
  XNOR2_X1 Midori_rounds_mul1_MC4_U6 ( .A(Midori_rounds_mul_input1[1]), .B(
        Midori_rounds_mul1_MC4_n18), .ZN(Midori_rounds_SR_Inv_Result1[53]) );
  XNOR2_X1 Midori_rounds_mul1_MC4_U5 ( .A(Midori_rounds_mul_input1[5]), .B(
        Midori_rounds_mul1_MC4_n18), .ZN(Midori_rounds_SR_Inv_Result1[29]) );
  XNOR2_X1 Midori_rounds_mul1_MC4_U4 ( .A(Midori_rounds_mul_input1[9]), .B(
        Midori_rounds_mul_input1[13]), .ZN(Midori_rounds_mul1_MC4_n18) );
  XNOR2_X1 Midori_rounds_mul1_MC4_U3 ( .A(Midori_rounds_mul_input1[0]), .B(
        Midori_rounds_mul1_MC4_n17), .ZN(Midori_rounds_SR_Inv_Result1[52]) );
  XNOR2_X1 Midori_rounds_mul1_MC4_U2 ( .A(Midori_rounds_mul_input1[4]), .B(
        Midori_rounds_mul1_MC4_n17), .ZN(Midori_rounds_SR_Inv_Result1[28]) );
  XNOR2_X1 Midori_rounds_mul1_MC4_U1 ( .A(Midori_rounds_mul_input1[8]), .B(
        Midori_rounds_mul_input1[12]), .ZN(Midori_rounds_mul1_MC4_n17) );
  XNOR2_X1 Midori_rounds_mul2_MC1_U24 ( .A(Midori_rounds_mul_input2[59]), .B(
        Midori_rounds_mul2_MC1_n24), .ZN(Midori_rounds_SR_Inv_Result2[63]) );
  XNOR2_X1 Midori_rounds_mul2_MC1_U23 ( .A(Midori_rounds_mul_input2[63]), .B(
        Midori_rounds_mul2_MC1_n24), .ZN(Midori_rounds_SR_Inv_Result2[23]) );
  XNOR2_X1 Midori_rounds_mul2_MC1_U22 ( .A(Midori_rounds_mul_input2[55]), .B(
        Midori_rounds_mul_input2[51]), .ZN(Midori_rounds_mul2_MC1_n24) );
  XNOR2_X1 Midori_rounds_mul2_MC1_U21 ( .A(Midori_rounds_mul_input2[58]), .B(
        Midori_rounds_mul2_MC1_n23), .ZN(Midori_rounds_SR_Inv_Result2[62]) );
  XNOR2_X1 Midori_rounds_mul2_MC1_U20 ( .A(Midori_rounds_mul_input2[62]), .B(
        Midori_rounds_mul2_MC1_n23), .ZN(Midori_rounds_SR_Inv_Result2[22]) );
  XNOR2_X1 Midori_rounds_mul2_MC1_U19 ( .A(Midori_rounds_mul_input2[54]), .B(
        Midori_rounds_mul_input2[50]), .ZN(Midori_rounds_mul2_MC1_n23) );
  XNOR2_X1 Midori_rounds_mul2_MC1_U18 ( .A(Midori_rounds_mul_input2[56]), .B(
        Midori_rounds_mul2_MC1_n22), .ZN(Midori_rounds_SR_Inv_Result2[60]) );
  XNOR2_X1 Midori_rounds_mul2_MC1_U17 ( .A(Midori_rounds_mul_input2[60]), .B(
        Midori_rounds_mul2_MC1_n22), .ZN(Midori_rounds_SR_Inv_Result2[20]) );
  XNOR2_X1 Midori_rounds_mul2_MC1_U16 ( .A(Midori_rounds_mul_input2[52]), .B(
        Midori_rounds_mul_input2[48]), .ZN(Midori_rounds_mul2_MC1_n22) );
  XNOR2_X1 Midori_rounds_mul2_MC1_U15 ( .A(Midori_rounds_mul_input2[51]), .B(
        Midori_rounds_mul2_MC1_n21), .ZN(Midori_rounds_SR_Inv_Result2[43]) );
  XNOR2_X1 Midori_rounds_mul2_MC1_U14 ( .A(Midori_rounds_mul_input2[55]), .B(
        Midori_rounds_mul2_MC1_n21), .ZN(Midori_rounds_SR_Inv_Result2[3]) );
  XNOR2_X1 Midori_rounds_mul2_MC1_U13 ( .A(Midori_rounds_mul_input2[59]), .B(
        Midori_rounds_mul_input2[63]), .ZN(Midori_rounds_mul2_MC1_n21) );
  XNOR2_X1 Midori_rounds_mul2_MC1_U12 ( .A(Midori_rounds_mul_input2[57]), .B(
        Midori_rounds_mul2_MC1_n20), .ZN(Midori_rounds_SR_Inv_Result2[61]) );
  XNOR2_X1 Midori_rounds_mul2_MC1_U11 ( .A(Midori_rounds_mul_input2[61]), .B(
        Midori_rounds_mul2_MC1_n20), .ZN(Midori_rounds_SR_Inv_Result2[21]) );
  XNOR2_X1 Midori_rounds_mul2_MC1_U10 ( .A(Midori_rounds_mul_input2[53]), .B(
        Midori_rounds_mul_input2[49]), .ZN(Midori_rounds_mul2_MC1_n20) );
  XNOR2_X1 Midori_rounds_mul2_MC1_U9 ( .A(Midori_rounds_mul_input2[50]), .B(
        Midori_rounds_mul2_MC1_n19), .ZN(Midori_rounds_SR_Inv_Result2[42]) );
  XNOR2_X1 Midori_rounds_mul2_MC1_U8 ( .A(Midori_rounds_mul_input2[54]), .B(
        Midori_rounds_mul2_MC1_n19), .ZN(Midori_rounds_SR_Inv_Result2[2]) );
  XNOR2_X1 Midori_rounds_mul2_MC1_U7 ( .A(Midori_rounds_mul_input2[58]), .B(
        Midori_rounds_mul_input2[62]), .ZN(Midori_rounds_mul2_MC1_n19) );
  XNOR2_X1 Midori_rounds_mul2_MC1_U6 ( .A(Midori_rounds_mul_input2[49]), .B(
        Midori_rounds_mul2_MC1_n18), .ZN(Midori_rounds_SR_Inv_Result2[41]) );
  XNOR2_X1 Midori_rounds_mul2_MC1_U5 ( .A(Midori_rounds_mul_input2[53]), .B(
        Midori_rounds_mul2_MC1_n18), .ZN(Midori_rounds_SR_Inv_Result2[1]) );
  XNOR2_X1 Midori_rounds_mul2_MC1_U4 ( .A(Midori_rounds_mul_input2[57]), .B(
        Midori_rounds_mul_input2[61]), .ZN(Midori_rounds_mul2_MC1_n18) );
  XNOR2_X1 Midori_rounds_mul2_MC1_U3 ( .A(Midori_rounds_mul_input2[48]), .B(
        Midori_rounds_mul2_MC1_n17), .ZN(Midori_rounds_SR_Inv_Result2[40]) );
  XNOR2_X1 Midori_rounds_mul2_MC1_U2 ( .A(Midori_rounds_mul_input2[52]), .B(
        Midori_rounds_mul2_MC1_n17), .ZN(Midori_rounds_SR_Inv_Result2[0]) );
  XNOR2_X1 Midori_rounds_mul2_MC1_U1 ( .A(Midori_rounds_mul_input2[56]), .B(
        Midori_rounds_mul_input2[60]), .ZN(Midori_rounds_mul2_MC1_n17) );
  XNOR2_X1 Midori_rounds_mul2_MC2_U24 ( .A(Midori_rounds_mul_input2[43]), .B(
        Midori_rounds_mul2_MC2_n24), .ZN(Midori_rounds_SR_Inv_Result2[7]) );
  XNOR2_X1 Midori_rounds_mul2_MC2_U23 ( .A(Midori_rounds_mul_input2[47]), .B(
        Midori_rounds_mul2_MC2_n24), .ZN(Midori_rounds_SR_Inv_Result2[47]) );
  XNOR2_X1 Midori_rounds_mul2_MC2_U22 ( .A(Midori_rounds_mul_input2[39]), .B(
        Midori_rounds_mul_input2[35]), .ZN(Midori_rounds_mul2_MC2_n24) );
  XNOR2_X1 Midori_rounds_mul2_MC2_U21 ( .A(Midori_rounds_mul_input2[42]), .B(
        Midori_rounds_mul2_MC2_n23), .ZN(Midori_rounds_SR_Inv_Result2[6]) );
  XNOR2_X1 Midori_rounds_mul2_MC2_U20 ( .A(Midori_rounds_mul_input2[46]), .B(
        Midori_rounds_mul2_MC2_n23), .ZN(Midori_rounds_SR_Inv_Result2[46]) );
  XNOR2_X1 Midori_rounds_mul2_MC2_U19 ( .A(Midori_rounds_mul_input2[38]), .B(
        Midori_rounds_mul_input2[34]), .ZN(Midori_rounds_mul2_MC2_n23) );
  XNOR2_X1 Midori_rounds_mul2_MC2_U18 ( .A(Midori_rounds_mul_input2[40]), .B(
        Midori_rounds_mul2_MC2_n22), .ZN(Midori_rounds_SR_Inv_Result2[4]) );
  XNOR2_X1 Midori_rounds_mul2_MC2_U17 ( .A(Midori_rounds_mul_input2[44]), .B(
        Midori_rounds_mul2_MC2_n22), .ZN(Midori_rounds_SR_Inv_Result2[44]) );
  XNOR2_X1 Midori_rounds_mul2_MC2_U16 ( .A(Midori_rounds_mul_input2[36]), .B(
        Midori_rounds_mul_input2[32]), .ZN(Midori_rounds_mul2_MC2_n22) );
  XNOR2_X1 Midori_rounds_mul2_MC2_U15 ( .A(Midori_rounds_mul_input2[35]), .B(
        Midori_rounds_mul2_MC2_n21), .ZN(Midori_rounds_SR_Inv_Result2[19]) );
  XNOR2_X1 Midori_rounds_mul2_MC2_U14 ( .A(Midori_rounds_mul_input2[39]), .B(
        Midori_rounds_mul2_MC2_n21), .ZN(Midori_rounds_SR_Inv_Result2[59]) );
  XNOR2_X1 Midori_rounds_mul2_MC2_U13 ( .A(Midori_rounds_mul_input2[43]), .B(
        Midori_rounds_mul_input2[47]), .ZN(Midori_rounds_mul2_MC2_n21) );
  XNOR2_X1 Midori_rounds_mul2_MC2_U12 ( .A(Midori_rounds_mul_input2[41]), .B(
        Midori_rounds_mul2_MC2_n20), .ZN(Midori_rounds_SR_Inv_Result2[5]) );
  XNOR2_X1 Midori_rounds_mul2_MC2_U11 ( .A(Midori_rounds_mul_input2[45]), .B(
        Midori_rounds_mul2_MC2_n20), .ZN(Midori_rounds_SR_Inv_Result2[45]) );
  XNOR2_X1 Midori_rounds_mul2_MC2_U10 ( .A(Midori_rounds_mul_input2[37]), .B(
        Midori_rounds_mul_input2[33]), .ZN(Midori_rounds_mul2_MC2_n20) );
  XNOR2_X1 Midori_rounds_mul2_MC2_U9 ( .A(Midori_rounds_mul_input2[34]), .B(
        Midori_rounds_mul2_MC2_n19), .ZN(Midori_rounds_SR_Inv_Result2[18]) );
  XNOR2_X1 Midori_rounds_mul2_MC2_U8 ( .A(Midori_rounds_mul_input2[38]), .B(
        Midori_rounds_mul2_MC2_n19), .ZN(Midori_rounds_SR_Inv_Result2[58]) );
  XNOR2_X1 Midori_rounds_mul2_MC2_U7 ( .A(Midori_rounds_mul_input2[42]), .B(
        Midori_rounds_mul_input2[46]), .ZN(Midori_rounds_mul2_MC2_n19) );
  XNOR2_X1 Midori_rounds_mul2_MC2_U6 ( .A(Midori_rounds_mul_input2[33]), .B(
        Midori_rounds_mul2_MC2_n18), .ZN(Midori_rounds_SR_Inv_Result2[17]) );
  XNOR2_X1 Midori_rounds_mul2_MC2_U5 ( .A(Midori_rounds_mul_input2[37]), .B(
        Midori_rounds_mul2_MC2_n18), .ZN(Midori_rounds_SR_Inv_Result2[57]) );
  XNOR2_X1 Midori_rounds_mul2_MC2_U4 ( .A(Midori_rounds_mul_input2[41]), .B(
        Midori_rounds_mul_input2[45]), .ZN(Midori_rounds_mul2_MC2_n18) );
  XNOR2_X1 Midori_rounds_mul2_MC2_U3 ( .A(Midori_rounds_mul_input2[32]), .B(
        Midori_rounds_mul2_MC2_n17), .ZN(Midori_rounds_SR_Inv_Result2[16]) );
  XNOR2_X1 Midori_rounds_mul2_MC2_U2 ( .A(Midori_rounds_mul_input2[36]), .B(
        Midori_rounds_mul2_MC2_n17), .ZN(Midori_rounds_SR_Inv_Result2[56]) );
  XNOR2_X1 Midori_rounds_mul2_MC2_U1 ( .A(Midori_rounds_mul_input2[40]), .B(
        Midori_rounds_mul_input2[44]), .ZN(Midori_rounds_mul2_MC2_n17) );
  XNOR2_X1 Midori_rounds_mul2_MC3_U24 ( .A(Midori_rounds_mul_input2[27]), .B(
        Midori_rounds_mul2_MC3_n24), .ZN(Midori_rounds_SR_Inv_Result2[27]) );
  XNOR2_X1 Midori_rounds_mul2_MC3_U23 ( .A(Midori_rounds_mul_input2[31]), .B(
        Midori_rounds_mul2_MC3_n24), .ZN(Midori_rounds_SR_Inv_Result2[51]) );
  XNOR2_X1 Midori_rounds_mul2_MC3_U22 ( .A(Midori_rounds_mul_input2[23]), .B(
        Midori_rounds_mul_input2[19]), .ZN(Midori_rounds_mul2_MC3_n24) );
  XNOR2_X1 Midori_rounds_mul2_MC3_U21 ( .A(Midori_rounds_mul_input2[26]), .B(
        Midori_rounds_mul2_MC3_n23), .ZN(Midori_rounds_SR_Inv_Result2[26]) );
  XNOR2_X1 Midori_rounds_mul2_MC3_U20 ( .A(Midori_rounds_mul_input2[30]), .B(
        Midori_rounds_mul2_MC3_n23), .ZN(Midori_rounds_SR_Inv_Result2[50]) );
  XNOR2_X1 Midori_rounds_mul2_MC3_U19 ( .A(Midori_rounds_mul_input2[22]), .B(
        Midori_rounds_mul_input2[18]), .ZN(Midori_rounds_mul2_MC3_n23) );
  XNOR2_X1 Midori_rounds_mul2_MC3_U18 ( .A(Midori_rounds_mul_input2[24]), .B(
        Midori_rounds_mul2_MC3_n22), .ZN(Midori_rounds_SR_Inv_Result2[24]) );
  XNOR2_X1 Midori_rounds_mul2_MC3_U17 ( .A(Midori_rounds_mul_input2[28]), .B(
        Midori_rounds_mul2_MC3_n22), .ZN(Midori_rounds_SR_Inv_Result2[48]) );
  XNOR2_X1 Midori_rounds_mul2_MC3_U16 ( .A(Midori_rounds_mul_input2[20]), .B(
        Midori_rounds_mul_input2[16]), .ZN(Midori_rounds_mul2_MC3_n22) );
  XNOR2_X1 Midori_rounds_mul2_MC3_U15 ( .A(Midori_rounds_mul_input2[19]), .B(
        Midori_rounds_mul2_MC3_n21), .ZN(Midori_rounds_SR_Inv_Result2[15]) );
  XNOR2_X1 Midori_rounds_mul2_MC3_U14 ( .A(Midori_rounds_mul_input2[23]), .B(
        Midori_rounds_mul2_MC3_n21), .ZN(Midori_rounds_SR_Inv_Result2[39]) );
  XNOR2_X1 Midori_rounds_mul2_MC3_U13 ( .A(Midori_rounds_mul_input2[27]), .B(
        Midori_rounds_mul_input2[31]), .ZN(Midori_rounds_mul2_MC3_n21) );
  XNOR2_X1 Midori_rounds_mul2_MC3_U12 ( .A(Midori_rounds_mul_input2[25]), .B(
        Midori_rounds_mul2_MC3_n20), .ZN(Midori_rounds_SR_Inv_Result2[25]) );
  XNOR2_X1 Midori_rounds_mul2_MC3_U11 ( .A(Midori_rounds_mul_input2[29]), .B(
        Midori_rounds_mul2_MC3_n20), .ZN(Midori_rounds_SR_Inv_Result2[49]) );
  XNOR2_X1 Midori_rounds_mul2_MC3_U10 ( .A(Midori_rounds_mul_input2[21]), .B(
        Midori_rounds_mul_input2[17]), .ZN(Midori_rounds_mul2_MC3_n20) );
  XNOR2_X1 Midori_rounds_mul2_MC3_U9 ( .A(Midori_rounds_mul_input2[18]), .B(
        Midori_rounds_mul2_MC3_n19), .ZN(Midori_rounds_SR_Inv_Result2[14]) );
  XNOR2_X1 Midori_rounds_mul2_MC3_U8 ( .A(Midori_rounds_mul_input2[22]), .B(
        Midori_rounds_mul2_MC3_n19), .ZN(Midori_rounds_SR_Inv_Result2[38]) );
  XNOR2_X1 Midori_rounds_mul2_MC3_U7 ( .A(Midori_rounds_mul_input2[26]), .B(
        Midori_rounds_mul_input2[30]), .ZN(Midori_rounds_mul2_MC3_n19) );
  XNOR2_X1 Midori_rounds_mul2_MC3_U6 ( .A(Midori_rounds_mul_input2[17]), .B(
        Midori_rounds_mul2_MC3_n18), .ZN(Midori_rounds_SR_Inv_Result2[13]) );
  XNOR2_X1 Midori_rounds_mul2_MC3_U5 ( .A(Midori_rounds_mul_input2[21]), .B(
        Midori_rounds_mul2_MC3_n18), .ZN(Midori_rounds_SR_Inv_Result2[37]) );
  XNOR2_X1 Midori_rounds_mul2_MC3_U4 ( .A(Midori_rounds_mul_input2[25]), .B(
        Midori_rounds_mul_input2[29]), .ZN(Midori_rounds_mul2_MC3_n18) );
  XNOR2_X1 Midori_rounds_mul2_MC3_U3 ( .A(Midori_rounds_mul_input2[16]), .B(
        Midori_rounds_mul2_MC3_n17), .ZN(Midori_rounds_SR_Inv_Result2[12]) );
  XNOR2_X1 Midori_rounds_mul2_MC3_U2 ( .A(Midori_rounds_mul_input2[20]), .B(
        Midori_rounds_mul2_MC3_n17), .ZN(Midori_rounds_SR_Inv_Result2[36]) );
  XNOR2_X1 Midori_rounds_mul2_MC3_U1 ( .A(Midori_rounds_mul_input2[24]), .B(
        Midori_rounds_mul_input2[28]), .ZN(Midori_rounds_mul2_MC3_n17) );
  XNOR2_X1 Midori_rounds_mul2_MC4_U24 ( .A(Midori_rounds_mul_input2[11]), .B(
        Midori_rounds_mul2_MC4_n24), .ZN(Midori_rounds_SR_Inv_Result2[35]) );
  XNOR2_X1 Midori_rounds_mul2_MC4_U23 ( .A(Midori_rounds_mul_input2[15]), .B(
        Midori_rounds_mul2_MC4_n24), .ZN(Midori_rounds_SR_Inv_Result2[11]) );
  XNOR2_X1 Midori_rounds_mul2_MC4_U22 ( .A(Midori_rounds_mul_input2[7]), .B(
        Midori_rounds_mul_input2[3]), .ZN(Midori_rounds_mul2_MC4_n24) );
  XNOR2_X1 Midori_rounds_mul2_MC4_U21 ( .A(Midori_rounds_mul_input2[10]), .B(
        Midori_rounds_mul2_MC4_n23), .ZN(Midori_rounds_SR_Inv_Result2[34]) );
  XNOR2_X1 Midori_rounds_mul2_MC4_U20 ( .A(Midori_rounds_mul_input2[14]), .B(
        Midori_rounds_mul2_MC4_n23), .ZN(Midori_rounds_SR_Inv_Result2[10]) );
  XNOR2_X1 Midori_rounds_mul2_MC4_U19 ( .A(Midori_rounds_mul_input2[6]), .B(
        Midori_rounds_mul_input2[2]), .ZN(Midori_rounds_mul2_MC4_n23) );
  XNOR2_X1 Midori_rounds_mul2_MC4_U18 ( .A(Midori_rounds_mul_input2[8]), .B(
        Midori_rounds_mul2_MC4_n22), .ZN(Midori_rounds_SR_Inv_Result2[32]) );
  XNOR2_X1 Midori_rounds_mul2_MC4_U17 ( .A(Midori_rounds_mul_input2[12]), .B(
        Midori_rounds_mul2_MC4_n22), .ZN(Midori_rounds_SR_Inv_Result2[8]) );
  XNOR2_X1 Midori_rounds_mul2_MC4_U16 ( .A(Midori_rounds_mul_input2[4]), .B(
        Midori_rounds_mul_input2[0]), .ZN(Midori_rounds_mul2_MC4_n22) );
  XNOR2_X1 Midori_rounds_mul2_MC4_U15 ( .A(Midori_rounds_mul_input2[3]), .B(
        Midori_rounds_mul2_MC4_n21), .ZN(Midori_rounds_SR_Inv_Result2[55]) );
  XNOR2_X1 Midori_rounds_mul2_MC4_U14 ( .A(Midori_rounds_mul_input2[7]), .B(
        Midori_rounds_mul2_MC4_n21), .ZN(Midori_rounds_SR_Inv_Result2[31]) );
  XNOR2_X1 Midori_rounds_mul2_MC4_U13 ( .A(Midori_rounds_mul_input2[11]), .B(
        Midori_rounds_mul_input2[15]), .ZN(Midori_rounds_mul2_MC4_n21) );
  XNOR2_X1 Midori_rounds_mul2_MC4_U12 ( .A(Midori_rounds_mul_input2[9]), .B(
        Midori_rounds_mul2_MC4_n20), .ZN(Midori_rounds_SR_Inv_Result2[33]) );
  XNOR2_X1 Midori_rounds_mul2_MC4_U11 ( .A(Midori_rounds_mul_input2[13]), .B(
        Midori_rounds_mul2_MC4_n20), .ZN(Midori_rounds_SR_Inv_Result2[9]) );
  XNOR2_X1 Midori_rounds_mul2_MC4_U10 ( .A(Midori_rounds_mul_input2[5]), .B(
        Midori_rounds_mul_input2[1]), .ZN(Midori_rounds_mul2_MC4_n20) );
  XNOR2_X1 Midori_rounds_mul2_MC4_U9 ( .A(Midori_rounds_mul_input2[2]), .B(
        Midori_rounds_mul2_MC4_n19), .ZN(Midori_rounds_SR_Inv_Result2[54]) );
  XNOR2_X1 Midori_rounds_mul2_MC4_U8 ( .A(Midori_rounds_mul_input2[6]), .B(
        Midori_rounds_mul2_MC4_n19), .ZN(Midori_rounds_SR_Inv_Result2[30]) );
  XNOR2_X1 Midori_rounds_mul2_MC4_U7 ( .A(Midori_rounds_mul_input2[10]), .B(
        Midori_rounds_mul_input2[14]), .ZN(Midori_rounds_mul2_MC4_n19) );
  XNOR2_X1 Midori_rounds_mul2_MC4_U6 ( .A(Midori_rounds_mul_input2[1]), .B(
        Midori_rounds_mul2_MC4_n18), .ZN(Midori_rounds_SR_Inv_Result2[53]) );
  XNOR2_X1 Midori_rounds_mul2_MC4_U5 ( .A(Midori_rounds_mul_input2[5]), .B(
        Midori_rounds_mul2_MC4_n18), .ZN(Midori_rounds_SR_Inv_Result2[29]) );
  XNOR2_X1 Midori_rounds_mul2_MC4_U4 ( .A(Midori_rounds_mul_input2[9]), .B(
        Midori_rounds_mul_input2[13]), .ZN(Midori_rounds_mul2_MC4_n18) );
  XNOR2_X1 Midori_rounds_mul2_MC4_U3 ( .A(Midori_rounds_mul_input2[0]), .B(
        Midori_rounds_mul2_MC4_n17), .ZN(Midori_rounds_SR_Inv_Result2[52]) );
  XNOR2_X1 Midori_rounds_mul2_MC4_U2 ( .A(Midori_rounds_mul_input2[4]), .B(
        Midori_rounds_mul2_MC4_n17), .ZN(Midori_rounds_SR_Inv_Result2[28]) );
  XNOR2_X1 Midori_rounds_mul2_MC4_U1 ( .A(Midori_rounds_mul_input2[8]), .B(
        Midori_rounds_mul_input2[12]), .ZN(Midori_rounds_mul2_MC4_n17) );
endmodule