
module circuit ( CLK, RESET, FRESH, DONE, KEY1, KEY2, KEY3, PLAINTEXT1, 
        PLAINTEXT2, PLAINTEXT3, CIPHERTEXT1, CIPHERTEXT2, CIPHERTEXT3 );
  input [39:0] FRESH;
  input [63:0] KEY1;
  input [63:0] KEY2;
  input [63:0] KEY3;
  input [63:0] PLAINTEXT1;
  input [63:0] PLAINTEXT2;
  input [63:0] PLAINTEXT3;
  output [63:0] CIPHERTEXT1;
  output [63:0] CIPHERTEXT2;
  output [63:0] CIPHERTEXT3;
  input CLK, RESET;
  output DONE;
  wire   KEY_EN, RF1_KA_n18, RF1_KA_n17, RF1_KA_n16, RF1_KA_n15, RF1_KA_n14,
         RF1_KA_n13, RF2_KA_n18, RF2_KA_n17, RF2_KA_n16, RF2_KA_n15,
         RF2_KA_n14, RF2_KA_n13, RF3_KA_n18, RF3_KA_n17, RF3_KA_n16,
         RF3_KA_n15, RF3_KA_n14, RF3_KA_n13, Inst_SKINNY_Sbox_0_n4,
         Inst_SKINNY_Sbox_0_n3, Inst_SKINNY_Sbox_0_n2, Inst_SKINNY_Sbox_0_n1,
         Inst_SKINNY_Sbox_0_Q294_inst1_Inst_0__CF_Inst_n3,
         Inst_SKINNY_Sbox_0_Q294_inst1_Inst_1__CF_Inst_n6,
         Inst_SKINNY_Sbox_0_Q294_inst1_Inst_1__CF_Inst_n5,
         Inst_SKINNY_Sbox_0_Q294_inst1_Inst_2__CF_Inst_n6,
         Inst_SKINNY_Sbox_0_Q294_inst1_Inst_2__CF_Inst_n5,
         Inst_SKINNY_Sbox_0_Q294_inst1_Inst_3__CF_Inst_n3,
         Inst_SKINNY_Sbox_0_Q294_inst1_Inst_4__CF_Inst_n6,
         Inst_SKINNY_Sbox_0_Q294_inst1_Inst_4__CF_Inst_n5,
         Inst_SKINNY_Sbox_0_Q294_inst1_Inst_5__CF_Inst_n6,
         Inst_SKINNY_Sbox_0_Q294_inst1_Inst_5__CF_Inst_n5,
         Inst_SKINNY_Sbox_0_Q294_inst1_Inst_6__CF_Inst_n3,
         Inst_SKINNY_Sbox_0_Q294_inst1_Inst_7__CF_Inst_n6,
         Inst_SKINNY_Sbox_0_Q294_inst1_Inst_7__CF_Inst_n5,
         Inst_SKINNY_Sbox_0_Q294_inst1_Inst_8__CF_Inst_n6,
         Inst_SKINNY_Sbox_0_Q294_inst1_Inst_8__CF_Inst_n5,
         Inst_SKINNY_Sbox_0_Q294_inst1_Inst_9__CF_Inst_n3,
         Inst_SKINNY_Sbox_0_Q294_inst1_Inst_10__CF_Inst_n6,
         Inst_SKINNY_Sbox_0_Q294_inst1_Inst_10__CF_Inst_n5,
         Inst_SKINNY_Sbox_0_Q294_inst1_Inst_11__CF_Inst_n6,
         Inst_SKINNY_Sbox_0_Q294_inst1_Inst_11__CF_Inst_n5,
         Inst_SKINNY_Sbox_0_Q294_inst1_Inst_12__CF_Inst_n3,
         Inst_SKINNY_Sbox_0_Q294_inst1_Inst_13__CF_Inst_n6,
         Inst_SKINNY_Sbox_0_Q294_inst1_Inst_13__CF_Inst_n5,
         Inst_SKINNY_Sbox_0_Q294_inst1_Inst_14__CF_Inst_n6,
         Inst_SKINNY_Sbox_0_Q294_inst1_Inst_14__CF_Inst_n5,
         Inst_SKINNY_Sbox_0_Q294_inst1_Inst_15__CF_Inst_n3,
         Inst_SKINNY_Sbox_0_Q294_inst1_Inst_16__CF_Inst_n6,
         Inst_SKINNY_Sbox_0_Q294_inst1_Inst_16__CF_Inst_n5,
         Inst_SKINNY_Sbox_0_Q294_inst1_Inst_17__CF_Inst_n6,
         Inst_SKINNY_Sbox_0_Q294_inst1_Inst_17__CF_Inst_n5,
         Inst_SKINNY_Sbox_0_Q294_inst1_InstXOR_0__Compression1_n3,
         Inst_SKINNY_Sbox_0_Q294_inst1_InstXOR_0__Compression2_n3,
         Inst_SKINNY_Sbox_0_Q294_inst1_InstXOR_0__Compression3_n3,
         Inst_SKINNY_Sbox_0_Q294_inst1_InstXOR_1__Compression1_n3,
         Inst_SKINNY_Sbox_0_Q294_inst1_InstXOR_1__Compression2_n3,
         Inst_SKINNY_Sbox_0_Q294_inst1_InstXOR_1__Compression3_n3,
         Inst_SKINNY_Sbox_0_Q294_inst2_Inst_0__CF_Inst_n3,
         Inst_SKINNY_Sbox_0_Q294_inst2_Inst_1__CF_Inst_n6,
         Inst_SKINNY_Sbox_0_Q294_inst2_Inst_1__CF_Inst_n5,
         Inst_SKINNY_Sbox_0_Q294_inst2_Inst_2__CF_Inst_n6,
         Inst_SKINNY_Sbox_0_Q294_inst2_Inst_2__CF_Inst_n5,
         Inst_SKINNY_Sbox_0_Q294_inst2_Inst_3__CF_Inst_n3,
         Inst_SKINNY_Sbox_0_Q294_inst2_Inst_4__CF_Inst_n6,
         Inst_SKINNY_Sbox_0_Q294_inst2_Inst_4__CF_Inst_n5,
         Inst_SKINNY_Sbox_0_Q294_inst2_Inst_5__CF_Inst_n6,
         Inst_SKINNY_Sbox_0_Q294_inst2_Inst_5__CF_Inst_n5,
         Inst_SKINNY_Sbox_0_Q294_inst2_Inst_6__CF_Inst_n3,
         Inst_SKINNY_Sbox_0_Q294_inst2_Inst_7__CF_Inst_n6,
         Inst_SKINNY_Sbox_0_Q294_inst2_Inst_7__CF_Inst_n5,
         Inst_SKINNY_Sbox_0_Q294_inst2_Inst_8__CF_Inst_n6,
         Inst_SKINNY_Sbox_0_Q294_inst2_Inst_8__CF_Inst_n5,
         Inst_SKINNY_Sbox_0_Q294_inst2_Inst_9__CF_Inst_n3,
         Inst_SKINNY_Sbox_0_Q294_inst2_Inst_10__CF_Inst_n6,
         Inst_SKINNY_Sbox_0_Q294_inst2_Inst_10__CF_Inst_n5,
         Inst_SKINNY_Sbox_0_Q294_inst2_Inst_11__CF_Inst_n6,
         Inst_SKINNY_Sbox_0_Q294_inst2_Inst_11__CF_Inst_n5,
         Inst_SKINNY_Sbox_0_Q294_inst2_Inst_12__CF_Inst_n3,
         Inst_SKINNY_Sbox_0_Q294_inst2_Inst_13__CF_Inst_n6,
         Inst_SKINNY_Sbox_0_Q294_inst2_Inst_13__CF_Inst_n5,
         Inst_SKINNY_Sbox_0_Q294_inst2_Inst_14__CF_Inst_n6,
         Inst_SKINNY_Sbox_0_Q294_inst2_Inst_14__CF_Inst_n5,
         Inst_SKINNY_Sbox_0_Q294_inst2_Inst_15__CF_Inst_n3,
         Inst_SKINNY_Sbox_0_Q294_inst2_Inst_16__CF_Inst_n6,
         Inst_SKINNY_Sbox_0_Q294_inst2_Inst_16__CF_Inst_n5,
         Inst_SKINNY_Sbox_0_Q294_inst2_Inst_17__CF_Inst_n6,
         Inst_SKINNY_Sbox_0_Q294_inst2_Inst_17__CF_Inst_n5,
         Inst_SKINNY_Sbox_0_Q294_inst2_InstXOR_0__Compression1_n3,
         Inst_SKINNY_Sbox_0_Q294_inst2_InstXOR_0__Compression2_n3,
         Inst_SKINNY_Sbox_0_Q294_inst2_InstXOR_0__Compression3_n3,
         Inst_SKINNY_Sbox_0_Q294_inst2_InstXOR_1__Compression1_n3,
         Inst_SKINNY_Sbox_0_Q294_inst2_InstXOR_1__Compression2_n3,
         Inst_SKINNY_Sbox_0_Q294_inst2_InstXOR_1__Compression3_n3,
         Inst_SKINNY_Sbox_1_n12, Inst_SKINNY_Sbox_1_n11,
         Inst_SKINNY_Sbox_1_n10, Inst_SKINNY_Sbox_1_n9,
         Inst_SKINNY_Sbox_1_Q294_inst1_Inst_0__CF_Inst_n3,
         Inst_SKINNY_Sbox_1_Q294_inst1_Inst_1__CF_Inst_n6,
         Inst_SKINNY_Sbox_1_Q294_inst1_Inst_1__CF_Inst_n5,
         Inst_SKINNY_Sbox_1_Q294_inst1_Inst_2__CF_Inst_n6,
         Inst_SKINNY_Sbox_1_Q294_inst1_Inst_2__CF_Inst_n5,
         Inst_SKINNY_Sbox_1_Q294_inst1_Inst_3__CF_Inst_n3,
         Inst_SKINNY_Sbox_1_Q294_inst1_Inst_4__CF_Inst_n6,
         Inst_SKINNY_Sbox_1_Q294_inst1_Inst_4__CF_Inst_n5,
         Inst_SKINNY_Sbox_1_Q294_inst1_Inst_5__CF_Inst_n6,
         Inst_SKINNY_Sbox_1_Q294_inst1_Inst_5__CF_Inst_n5,
         Inst_SKINNY_Sbox_1_Q294_inst1_Inst_6__CF_Inst_n3,
         Inst_SKINNY_Sbox_1_Q294_inst1_Inst_7__CF_Inst_n6,
         Inst_SKINNY_Sbox_1_Q294_inst1_Inst_7__CF_Inst_n5,
         Inst_SKINNY_Sbox_1_Q294_inst1_Inst_8__CF_Inst_n6,
         Inst_SKINNY_Sbox_1_Q294_inst1_Inst_8__CF_Inst_n5,
         Inst_SKINNY_Sbox_1_Q294_inst1_Inst_9__CF_Inst_n3,
         Inst_SKINNY_Sbox_1_Q294_inst1_Inst_10__CF_Inst_n6,
         Inst_SKINNY_Sbox_1_Q294_inst1_Inst_10__CF_Inst_n5,
         Inst_SKINNY_Sbox_1_Q294_inst1_Inst_11__CF_Inst_n6,
         Inst_SKINNY_Sbox_1_Q294_inst1_Inst_11__CF_Inst_n5,
         Inst_SKINNY_Sbox_1_Q294_inst1_Inst_12__CF_Inst_n3,
         Inst_SKINNY_Sbox_1_Q294_inst1_Inst_13__CF_Inst_n6,
         Inst_SKINNY_Sbox_1_Q294_inst1_Inst_13__CF_Inst_n5,
         Inst_SKINNY_Sbox_1_Q294_inst1_Inst_14__CF_Inst_n6,
         Inst_SKINNY_Sbox_1_Q294_inst1_Inst_14__CF_Inst_n5,
         Inst_SKINNY_Sbox_1_Q294_inst1_Inst_15__CF_Inst_n3,
         Inst_SKINNY_Sbox_1_Q294_inst1_Inst_16__CF_Inst_n6,
         Inst_SKINNY_Sbox_1_Q294_inst1_Inst_16__CF_Inst_n5,
         Inst_SKINNY_Sbox_1_Q294_inst1_Inst_17__CF_Inst_n6,
         Inst_SKINNY_Sbox_1_Q294_inst1_Inst_17__CF_Inst_n5,
         Inst_SKINNY_Sbox_1_Q294_inst1_InstXOR_0__Compression1_n3,
         Inst_SKINNY_Sbox_1_Q294_inst1_InstXOR_0__Compression2_n3,
         Inst_SKINNY_Sbox_1_Q294_inst1_InstXOR_0__Compression3_n3,
         Inst_SKINNY_Sbox_1_Q294_inst1_InstXOR_1__Compression1_n3,
         Inst_SKINNY_Sbox_1_Q294_inst1_InstXOR_1__Compression2_n3,
         Inst_SKINNY_Sbox_1_Q294_inst1_InstXOR_1__Compression3_n3,
         Inst_SKINNY_Sbox_1_Q294_inst2_Inst_0__CF_Inst_n3,
         Inst_SKINNY_Sbox_1_Q294_inst2_Inst_1__CF_Inst_n6,
         Inst_SKINNY_Sbox_1_Q294_inst2_Inst_1__CF_Inst_n5,
         Inst_SKINNY_Sbox_1_Q294_inst2_Inst_2__CF_Inst_n6,
         Inst_SKINNY_Sbox_1_Q294_inst2_Inst_2__CF_Inst_n5,
         Inst_SKINNY_Sbox_1_Q294_inst2_Inst_3__CF_Inst_n3,
         Inst_SKINNY_Sbox_1_Q294_inst2_Inst_4__CF_Inst_n6,
         Inst_SKINNY_Sbox_1_Q294_inst2_Inst_4__CF_Inst_n5,
         Inst_SKINNY_Sbox_1_Q294_inst2_Inst_5__CF_Inst_n6,
         Inst_SKINNY_Sbox_1_Q294_inst2_Inst_5__CF_Inst_n5,
         Inst_SKINNY_Sbox_1_Q294_inst2_Inst_6__CF_Inst_n3,
         Inst_SKINNY_Sbox_1_Q294_inst2_Inst_7__CF_Inst_n6,
         Inst_SKINNY_Sbox_1_Q294_inst2_Inst_7__CF_Inst_n5,
         Inst_SKINNY_Sbox_1_Q294_inst2_Inst_8__CF_Inst_n6,
         Inst_SKINNY_Sbox_1_Q294_inst2_Inst_8__CF_Inst_n5,
         Inst_SKINNY_Sbox_1_Q294_inst2_Inst_9__CF_Inst_n3,
         Inst_SKINNY_Sbox_1_Q294_inst2_Inst_10__CF_Inst_n6,
         Inst_SKINNY_Sbox_1_Q294_inst2_Inst_10__CF_Inst_n5,
         Inst_SKINNY_Sbox_1_Q294_inst2_Inst_11__CF_Inst_n6,
         Inst_SKINNY_Sbox_1_Q294_inst2_Inst_11__CF_Inst_n5,
         Inst_SKINNY_Sbox_1_Q294_inst2_Inst_12__CF_Inst_n3,
         Inst_SKINNY_Sbox_1_Q294_inst2_Inst_13__CF_Inst_n6,
         Inst_SKINNY_Sbox_1_Q294_inst2_Inst_13__CF_Inst_n5,
         Inst_SKINNY_Sbox_1_Q294_inst2_Inst_14__CF_Inst_n6,
         Inst_SKINNY_Sbox_1_Q294_inst2_Inst_14__CF_Inst_n5,
         Inst_SKINNY_Sbox_1_Q294_inst2_Inst_15__CF_Inst_n3,
         Inst_SKINNY_Sbox_1_Q294_inst2_Inst_16__CF_Inst_n6,
         Inst_SKINNY_Sbox_1_Q294_inst2_Inst_16__CF_Inst_n5,
         Inst_SKINNY_Sbox_1_Q294_inst2_Inst_17__CF_Inst_n6,
         Inst_SKINNY_Sbox_1_Q294_inst2_Inst_17__CF_Inst_n5,
         Inst_SKINNY_Sbox_1_Q294_inst2_InstXOR_0__Compression1_n3,
         Inst_SKINNY_Sbox_1_Q294_inst2_InstXOR_0__Compression2_n3,
         Inst_SKINNY_Sbox_1_Q294_inst2_InstXOR_0__Compression3_n3,
         Inst_SKINNY_Sbox_1_Q294_inst2_InstXOR_1__Compression1_n3,
         Inst_SKINNY_Sbox_1_Q294_inst2_InstXOR_1__Compression2_n3,
         Inst_SKINNY_Sbox_1_Q294_inst2_InstXOR_1__Compression3_n3,
         Inst_SKINNY_Sbox_2_n12, Inst_SKINNY_Sbox_2_n11,
         Inst_SKINNY_Sbox_2_n10, Inst_SKINNY_Sbox_2_n9,
         Inst_SKINNY_Sbox_2_Q294_inst1_Inst_0__CF_Inst_n3,
         Inst_SKINNY_Sbox_2_Q294_inst1_Inst_1__CF_Inst_n6,
         Inst_SKINNY_Sbox_2_Q294_inst1_Inst_1__CF_Inst_n5,
         Inst_SKINNY_Sbox_2_Q294_inst1_Inst_2__CF_Inst_n6,
         Inst_SKINNY_Sbox_2_Q294_inst1_Inst_2__CF_Inst_n5,
         Inst_SKINNY_Sbox_2_Q294_inst1_Inst_3__CF_Inst_n3,
         Inst_SKINNY_Sbox_2_Q294_inst1_Inst_4__CF_Inst_n6,
         Inst_SKINNY_Sbox_2_Q294_inst1_Inst_4__CF_Inst_n5,
         Inst_SKINNY_Sbox_2_Q294_inst1_Inst_5__CF_Inst_n6,
         Inst_SKINNY_Sbox_2_Q294_inst1_Inst_5__CF_Inst_n5,
         Inst_SKINNY_Sbox_2_Q294_inst1_Inst_6__CF_Inst_n3,
         Inst_SKINNY_Sbox_2_Q294_inst1_Inst_7__CF_Inst_n6,
         Inst_SKINNY_Sbox_2_Q294_inst1_Inst_7__CF_Inst_n5,
         Inst_SKINNY_Sbox_2_Q294_inst1_Inst_8__CF_Inst_n6,
         Inst_SKINNY_Sbox_2_Q294_inst1_Inst_8__CF_Inst_n5,
         Inst_SKINNY_Sbox_2_Q294_inst1_Inst_9__CF_Inst_n3,
         Inst_SKINNY_Sbox_2_Q294_inst1_Inst_10__CF_Inst_n6,
         Inst_SKINNY_Sbox_2_Q294_inst1_Inst_10__CF_Inst_n5,
         Inst_SKINNY_Sbox_2_Q294_inst1_Inst_11__CF_Inst_n6,
         Inst_SKINNY_Sbox_2_Q294_inst1_Inst_11__CF_Inst_n5,
         Inst_SKINNY_Sbox_2_Q294_inst1_Inst_12__CF_Inst_n3,
         Inst_SKINNY_Sbox_2_Q294_inst1_Inst_13__CF_Inst_n6,
         Inst_SKINNY_Sbox_2_Q294_inst1_Inst_13__CF_Inst_n5,
         Inst_SKINNY_Sbox_2_Q294_inst1_Inst_14__CF_Inst_n6,
         Inst_SKINNY_Sbox_2_Q294_inst1_Inst_14__CF_Inst_n5,
         Inst_SKINNY_Sbox_2_Q294_inst1_Inst_15__CF_Inst_n3,
         Inst_SKINNY_Sbox_2_Q294_inst1_Inst_16__CF_Inst_n6,
         Inst_SKINNY_Sbox_2_Q294_inst1_Inst_16__CF_Inst_n5,
         Inst_SKINNY_Sbox_2_Q294_inst1_Inst_17__CF_Inst_n6,
         Inst_SKINNY_Sbox_2_Q294_inst1_Inst_17__CF_Inst_n5,
         Inst_SKINNY_Sbox_2_Q294_inst1_InstXOR_0__Compression1_n3,
         Inst_SKINNY_Sbox_2_Q294_inst1_InstXOR_0__Compression2_n3,
         Inst_SKINNY_Sbox_2_Q294_inst1_InstXOR_0__Compression3_n3,
         Inst_SKINNY_Sbox_2_Q294_inst1_InstXOR_1__Compression1_n3,
         Inst_SKINNY_Sbox_2_Q294_inst1_InstXOR_1__Compression2_n3,
         Inst_SKINNY_Sbox_2_Q294_inst1_InstXOR_1__Compression3_n3,
         Inst_SKINNY_Sbox_2_Q294_inst2_Inst_0__CF_Inst_n3,
         Inst_SKINNY_Sbox_2_Q294_inst2_Inst_1__CF_Inst_n6,
         Inst_SKINNY_Sbox_2_Q294_inst2_Inst_1__CF_Inst_n5,
         Inst_SKINNY_Sbox_2_Q294_inst2_Inst_2__CF_Inst_n6,
         Inst_SKINNY_Sbox_2_Q294_inst2_Inst_2__CF_Inst_n5,
         Inst_SKINNY_Sbox_2_Q294_inst2_Inst_3__CF_Inst_n3,
         Inst_SKINNY_Sbox_2_Q294_inst2_Inst_4__CF_Inst_n6,
         Inst_SKINNY_Sbox_2_Q294_inst2_Inst_4__CF_Inst_n5,
         Inst_SKINNY_Sbox_2_Q294_inst2_Inst_5__CF_Inst_n6,
         Inst_SKINNY_Sbox_2_Q294_inst2_Inst_5__CF_Inst_n5,
         Inst_SKINNY_Sbox_2_Q294_inst2_Inst_6__CF_Inst_n3,
         Inst_SKINNY_Sbox_2_Q294_inst2_Inst_7__CF_Inst_n6,
         Inst_SKINNY_Sbox_2_Q294_inst2_Inst_7__CF_Inst_n5,
         Inst_SKINNY_Sbox_2_Q294_inst2_Inst_8__CF_Inst_n6,
         Inst_SKINNY_Sbox_2_Q294_inst2_Inst_8__CF_Inst_n5,
         Inst_SKINNY_Sbox_2_Q294_inst2_Inst_9__CF_Inst_n3,
         Inst_SKINNY_Sbox_2_Q294_inst2_Inst_10__CF_Inst_n6,
         Inst_SKINNY_Sbox_2_Q294_inst2_Inst_10__CF_Inst_n5,
         Inst_SKINNY_Sbox_2_Q294_inst2_Inst_11__CF_Inst_n6,
         Inst_SKINNY_Sbox_2_Q294_inst2_Inst_11__CF_Inst_n5,
         Inst_SKINNY_Sbox_2_Q294_inst2_Inst_12__CF_Inst_n3,
         Inst_SKINNY_Sbox_2_Q294_inst2_Inst_13__CF_Inst_n6,
         Inst_SKINNY_Sbox_2_Q294_inst2_Inst_13__CF_Inst_n5,
         Inst_SKINNY_Sbox_2_Q294_inst2_Inst_14__CF_Inst_n6,
         Inst_SKINNY_Sbox_2_Q294_inst2_Inst_14__CF_Inst_n5,
         Inst_SKINNY_Sbox_2_Q294_inst2_Inst_15__CF_Inst_n3,
         Inst_SKINNY_Sbox_2_Q294_inst2_Inst_16__CF_Inst_n6,
         Inst_SKINNY_Sbox_2_Q294_inst2_Inst_16__CF_Inst_n5,
         Inst_SKINNY_Sbox_2_Q294_inst2_Inst_17__CF_Inst_n6,
         Inst_SKINNY_Sbox_2_Q294_inst2_Inst_17__CF_Inst_n5,
         Inst_SKINNY_Sbox_2_Q294_inst2_InstXOR_0__Compression1_n3,
         Inst_SKINNY_Sbox_2_Q294_inst2_InstXOR_0__Compression2_n3,
         Inst_SKINNY_Sbox_2_Q294_inst2_InstXOR_0__Compression3_n3,
         Inst_SKINNY_Sbox_2_Q294_inst2_InstXOR_1__Compression1_n3,
         Inst_SKINNY_Sbox_2_Q294_inst2_InstXOR_1__Compression2_n3,
         Inst_SKINNY_Sbox_2_Q294_inst2_InstXOR_1__Compression3_n3,
         Inst_SKINNY_Sbox_3_n12, Inst_SKINNY_Sbox_3_n11,
         Inst_SKINNY_Sbox_3_n10, Inst_SKINNY_Sbox_3_n9,
         Inst_SKINNY_Sbox_3_Q294_inst1_Inst_0__CF_Inst_n3,
         Inst_SKINNY_Sbox_3_Q294_inst1_Inst_1__CF_Inst_n6,
         Inst_SKINNY_Sbox_3_Q294_inst1_Inst_1__CF_Inst_n5,
         Inst_SKINNY_Sbox_3_Q294_inst1_Inst_2__CF_Inst_n6,
         Inst_SKINNY_Sbox_3_Q294_inst1_Inst_2__CF_Inst_n5,
         Inst_SKINNY_Sbox_3_Q294_inst1_Inst_3__CF_Inst_n3,
         Inst_SKINNY_Sbox_3_Q294_inst1_Inst_4__CF_Inst_n6,
         Inst_SKINNY_Sbox_3_Q294_inst1_Inst_4__CF_Inst_n5,
         Inst_SKINNY_Sbox_3_Q294_inst1_Inst_5__CF_Inst_n6,
         Inst_SKINNY_Sbox_3_Q294_inst1_Inst_5__CF_Inst_n5,
         Inst_SKINNY_Sbox_3_Q294_inst1_Inst_6__CF_Inst_n3,
         Inst_SKINNY_Sbox_3_Q294_inst1_Inst_7__CF_Inst_n6,
         Inst_SKINNY_Sbox_3_Q294_inst1_Inst_7__CF_Inst_n5,
         Inst_SKINNY_Sbox_3_Q294_inst1_Inst_8__CF_Inst_n6,
         Inst_SKINNY_Sbox_3_Q294_inst1_Inst_8__CF_Inst_n5,
         Inst_SKINNY_Sbox_3_Q294_inst1_Inst_9__CF_Inst_n3,
         Inst_SKINNY_Sbox_3_Q294_inst1_Inst_10__CF_Inst_n6,
         Inst_SKINNY_Sbox_3_Q294_inst1_Inst_10__CF_Inst_n5,
         Inst_SKINNY_Sbox_3_Q294_inst1_Inst_11__CF_Inst_n6,
         Inst_SKINNY_Sbox_3_Q294_inst1_Inst_11__CF_Inst_n5,
         Inst_SKINNY_Sbox_3_Q294_inst1_Inst_12__CF_Inst_n3,
         Inst_SKINNY_Sbox_3_Q294_inst1_Inst_13__CF_Inst_n6,
         Inst_SKINNY_Sbox_3_Q294_inst1_Inst_13__CF_Inst_n5,
         Inst_SKINNY_Sbox_3_Q294_inst1_Inst_14__CF_Inst_n6,
         Inst_SKINNY_Sbox_3_Q294_inst1_Inst_14__CF_Inst_n5,
         Inst_SKINNY_Sbox_3_Q294_inst1_Inst_15__CF_Inst_n3,
         Inst_SKINNY_Sbox_3_Q294_inst1_Inst_16__CF_Inst_n6,
         Inst_SKINNY_Sbox_3_Q294_inst1_Inst_16__CF_Inst_n5,
         Inst_SKINNY_Sbox_3_Q294_inst1_Inst_17__CF_Inst_n6,
         Inst_SKINNY_Sbox_3_Q294_inst1_Inst_17__CF_Inst_n5,
         Inst_SKINNY_Sbox_3_Q294_inst1_InstXOR_0__Compression1_n3,
         Inst_SKINNY_Sbox_3_Q294_inst1_InstXOR_0__Compression2_n3,
         Inst_SKINNY_Sbox_3_Q294_inst1_InstXOR_0__Compression3_n3,
         Inst_SKINNY_Sbox_3_Q294_inst1_InstXOR_1__Compression1_n3,
         Inst_SKINNY_Sbox_3_Q294_inst1_InstXOR_1__Compression2_n3,
         Inst_SKINNY_Sbox_3_Q294_inst1_InstXOR_1__Compression3_n3,
         Inst_SKINNY_Sbox_3_Q294_inst2_Inst_0__CF_Inst_n3,
         Inst_SKINNY_Sbox_3_Q294_inst2_Inst_1__CF_Inst_n6,
         Inst_SKINNY_Sbox_3_Q294_inst2_Inst_1__CF_Inst_n5,
         Inst_SKINNY_Sbox_3_Q294_inst2_Inst_2__CF_Inst_n6,
         Inst_SKINNY_Sbox_3_Q294_inst2_Inst_2__CF_Inst_n5,
         Inst_SKINNY_Sbox_3_Q294_inst2_Inst_3__CF_Inst_n3,
         Inst_SKINNY_Sbox_3_Q294_inst2_Inst_4__CF_Inst_n6,
         Inst_SKINNY_Sbox_3_Q294_inst2_Inst_4__CF_Inst_n5,
         Inst_SKINNY_Sbox_3_Q294_inst2_Inst_5__CF_Inst_n6,
         Inst_SKINNY_Sbox_3_Q294_inst2_Inst_5__CF_Inst_n5,
         Inst_SKINNY_Sbox_3_Q294_inst2_Inst_6__CF_Inst_n3,
         Inst_SKINNY_Sbox_3_Q294_inst2_Inst_7__CF_Inst_n6,
         Inst_SKINNY_Sbox_3_Q294_inst2_Inst_7__CF_Inst_n5,
         Inst_SKINNY_Sbox_3_Q294_inst2_Inst_8__CF_Inst_n6,
         Inst_SKINNY_Sbox_3_Q294_inst2_Inst_8__CF_Inst_n5,
         Inst_SKINNY_Sbox_3_Q294_inst2_Inst_9__CF_Inst_n3,
         Inst_SKINNY_Sbox_3_Q294_inst2_Inst_10__CF_Inst_n6,
         Inst_SKINNY_Sbox_3_Q294_inst2_Inst_10__CF_Inst_n5,
         Inst_SKINNY_Sbox_3_Q294_inst2_Inst_11__CF_Inst_n6,
         Inst_SKINNY_Sbox_3_Q294_inst2_Inst_11__CF_Inst_n5,
         Inst_SKINNY_Sbox_3_Q294_inst2_Inst_12__CF_Inst_n3,
         Inst_SKINNY_Sbox_3_Q294_inst2_Inst_13__CF_Inst_n6,
         Inst_SKINNY_Sbox_3_Q294_inst2_Inst_13__CF_Inst_n5,
         Inst_SKINNY_Sbox_3_Q294_inst2_Inst_14__CF_Inst_n6,
         Inst_SKINNY_Sbox_3_Q294_inst2_Inst_14__CF_Inst_n5,
         Inst_SKINNY_Sbox_3_Q294_inst2_Inst_15__CF_Inst_n3,
         Inst_SKINNY_Sbox_3_Q294_inst2_Inst_16__CF_Inst_n6,
         Inst_SKINNY_Sbox_3_Q294_inst2_Inst_16__CF_Inst_n5,
         Inst_SKINNY_Sbox_3_Q294_inst2_Inst_17__CF_Inst_n6,
         Inst_SKINNY_Sbox_3_Q294_inst2_Inst_17__CF_Inst_n5,
         Inst_SKINNY_Sbox_3_Q294_inst2_InstXOR_0__Compression1_n3,
         Inst_SKINNY_Sbox_3_Q294_inst2_InstXOR_0__Compression2_n3,
         Inst_SKINNY_Sbox_3_Q294_inst2_InstXOR_0__Compression3_n3,
         Inst_SKINNY_Sbox_3_Q294_inst2_InstXOR_1__Compression1_n3,
         Inst_SKINNY_Sbox_3_Q294_inst2_InstXOR_1__Compression2_n3,
         Inst_SKINNY_Sbox_3_Q294_inst2_InstXOR_1__Compression3_n3,
         Inst_SKINNY_Sbox_4_n12, Inst_SKINNY_Sbox_4_n11,
         Inst_SKINNY_Sbox_4_n10, Inst_SKINNY_Sbox_4_n9,
         Inst_SKINNY_Sbox_4_Q294_inst1_Inst_0__CF_Inst_n3,
         Inst_SKINNY_Sbox_4_Q294_inst1_Inst_1__CF_Inst_n6,
         Inst_SKINNY_Sbox_4_Q294_inst1_Inst_1__CF_Inst_n5,
         Inst_SKINNY_Sbox_4_Q294_inst1_Inst_2__CF_Inst_n6,
         Inst_SKINNY_Sbox_4_Q294_inst1_Inst_2__CF_Inst_n5,
         Inst_SKINNY_Sbox_4_Q294_inst1_Inst_3__CF_Inst_n3,
         Inst_SKINNY_Sbox_4_Q294_inst1_Inst_4__CF_Inst_n6,
         Inst_SKINNY_Sbox_4_Q294_inst1_Inst_4__CF_Inst_n5,
         Inst_SKINNY_Sbox_4_Q294_inst1_Inst_5__CF_Inst_n6,
         Inst_SKINNY_Sbox_4_Q294_inst1_Inst_5__CF_Inst_n5,
         Inst_SKINNY_Sbox_4_Q294_inst1_Inst_6__CF_Inst_n3,
         Inst_SKINNY_Sbox_4_Q294_inst1_Inst_7__CF_Inst_n6,
         Inst_SKINNY_Sbox_4_Q294_inst1_Inst_7__CF_Inst_n5,
         Inst_SKINNY_Sbox_4_Q294_inst1_Inst_8__CF_Inst_n6,
         Inst_SKINNY_Sbox_4_Q294_inst1_Inst_8__CF_Inst_n5,
         Inst_SKINNY_Sbox_4_Q294_inst1_Inst_9__CF_Inst_n3,
         Inst_SKINNY_Sbox_4_Q294_inst1_Inst_10__CF_Inst_n6,
         Inst_SKINNY_Sbox_4_Q294_inst1_Inst_10__CF_Inst_n5,
         Inst_SKINNY_Sbox_4_Q294_inst1_Inst_11__CF_Inst_n6,
         Inst_SKINNY_Sbox_4_Q294_inst1_Inst_11__CF_Inst_n5,
         Inst_SKINNY_Sbox_4_Q294_inst1_Inst_12__CF_Inst_n3,
         Inst_SKINNY_Sbox_4_Q294_inst1_Inst_13__CF_Inst_n6,
         Inst_SKINNY_Sbox_4_Q294_inst1_Inst_13__CF_Inst_n5,
         Inst_SKINNY_Sbox_4_Q294_inst1_Inst_14__CF_Inst_n6,
         Inst_SKINNY_Sbox_4_Q294_inst1_Inst_14__CF_Inst_n5,
         Inst_SKINNY_Sbox_4_Q294_inst1_Inst_15__CF_Inst_n3,
         Inst_SKINNY_Sbox_4_Q294_inst1_Inst_16__CF_Inst_n6,
         Inst_SKINNY_Sbox_4_Q294_inst1_Inst_16__CF_Inst_n5,
         Inst_SKINNY_Sbox_4_Q294_inst1_Inst_17__CF_Inst_n6,
         Inst_SKINNY_Sbox_4_Q294_inst1_Inst_17__CF_Inst_n5,
         Inst_SKINNY_Sbox_4_Q294_inst1_InstXOR_0__Compression1_n3,
         Inst_SKINNY_Sbox_4_Q294_inst1_InstXOR_0__Compression2_n3,
         Inst_SKINNY_Sbox_4_Q294_inst1_InstXOR_0__Compression3_n3,
         Inst_SKINNY_Sbox_4_Q294_inst1_InstXOR_1__Compression1_n3,
         Inst_SKINNY_Sbox_4_Q294_inst1_InstXOR_1__Compression2_n3,
         Inst_SKINNY_Sbox_4_Q294_inst1_InstXOR_1__Compression3_n3,
         Inst_SKINNY_Sbox_4_Q294_inst2_Inst_0__CF_Inst_n3,
         Inst_SKINNY_Sbox_4_Q294_inst2_Inst_1__CF_Inst_n6,
         Inst_SKINNY_Sbox_4_Q294_inst2_Inst_1__CF_Inst_n5,
         Inst_SKINNY_Sbox_4_Q294_inst2_Inst_2__CF_Inst_n6,
         Inst_SKINNY_Sbox_4_Q294_inst2_Inst_2__CF_Inst_n5,
         Inst_SKINNY_Sbox_4_Q294_inst2_Inst_3__CF_Inst_n3,
         Inst_SKINNY_Sbox_4_Q294_inst2_Inst_4__CF_Inst_n6,
         Inst_SKINNY_Sbox_4_Q294_inst2_Inst_4__CF_Inst_n5,
         Inst_SKINNY_Sbox_4_Q294_inst2_Inst_5__CF_Inst_n6,
         Inst_SKINNY_Sbox_4_Q294_inst2_Inst_5__CF_Inst_n5,
         Inst_SKINNY_Sbox_4_Q294_inst2_Inst_6__CF_Inst_n3,
         Inst_SKINNY_Sbox_4_Q294_inst2_Inst_7__CF_Inst_n6,
         Inst_SKINNY_Sbox_4_Q294_inst2_Inst_7__CF_Inst_n5,
         Inst_SKINNY_Sbox_4_Q294_inst2_Inst_8__CF_Inst_n6,
         Inst_SKINNY_Sbox_4_Q294_inst2_Inst_8__CF_Inst_n5,
         Inst_SKINNY_Sbox_4_Q294_inst2_Inst_9__CF_Inst_n3,
         Inst_SKINNY_Sbox_4_Q294_inst2_Inst_10__CF_Inst_n6,
         Inst_SKINNY_Sbox_4_Q294_inst2_Inst_10__CF_Inst_n5,
         Inst_SKINNY_Sbox_4_Q294_inst2_Inst_11__CF_Inst_n6,
         Inst_SKINNY_Sbox_4_Q294_inst2_Inst_11__CF_Inst_n5,
         Inst_SKINNY_Sbox_4_Q294_inst2_Inst_12__CF_Inst_n3,
         Inst_SKINNY_Sbox_4_Q294_inst2_Inst_13__CF_Inst_n6,
         Inst_SKINNY_Sbox_4_Q294_inst2_Inst_13__CF_Inst_n5,
         Inst_SKINNY_Sbox_4_Q294_inst2_Inst_14__CF_Inst_n6,
         Inst_SKINNY_Sbox_4_Q294_inst2_Inst_14__CF_Inst_n5,
         Inst_SKINNY_Sbox_4_Q294_inst2_Inst_15__CF_Inst_n3,
         Inst_SKINNY_Sbox_4_Q294_inst2_Inst_16__CF_Inst_n6,
         Inst_SKINNY_Sbox_4_Q294_inst2_Inst_16__CF_Inst_n5,
         Inst_SKINNY_Sbox_4_Q294_inst2_Inst_17__CF_Inst_n6,
         Inst_SKINNY_Sbox_4_Q294_inst2_Inst_17__CF_Inst_n5,
         Inst_SKINNY_Sbox_4_Q294_inst2_InstXOR_0__Compression1_n3,
         Inst_SKINNY_Sbox_4_Q294_inst2_InstXOR_0__Compression2_n3,
         Inst_SKINNY_Sbox_4_Q294_inst2_InstXOR_0__Compression3_n3,
         Inst_SKINNY_Sbox_4_Q294_inst2_InstXOR_1__Compression1_n3,
         Inst_SKINNY_Sbox_4_Q294_inst2_InstXOR_1__Compression2_n3,
         Inst_SKINNY_Sbox_4_Q294_inst2_InstXOR_1__Compression3_n3,
         Inst_SKINNY_Sbox_5_n12, Inst_SKINNY_Sbox_5_n11,
         Inst_SKINNY_Sbox_5_n10, Inst_SKINNY_Sbox_5_n9,
         Inst_SKINNY_Sbox_5_Q294_inst1_Inst_0__CF_Inst_n3,
         Inst_SKINNY_Sbox_5_Q294_inst1_Inst_1__CF_Inst_n6,
         Inst_SKINNY_Sbox_5_Q294_inst1_Inst_1__CF_Inst_n5,
         Inst_SKINNY_Sbox_5_Q294_inst1_Inst_2__CF_Inst_n6,
         Inst_SKINNY_Sbox_5_Q294_inst1_Inst_2__CF_Inst_n5,
         Inst_SKINNY_Sbox_5_Q294_inst1_Inst_3__CF_Inst_n3,
         Inst_SKINNY_Sbox_5_Q294_inst1_Inst_4__CF_Inst_n6,
         Inst_SKINNY_Sbox_5_Q294_inst1_Inst_4__CF_Inst_n5,
         Inst_SKINNY_Sbox_5_Q294_inst1_Inst_5__CF_Inst_n6,
         Inst_SKINNY_Sbox_5_Q294_inst1_Inst_5__CF_Inst_n5,
         Inst_SKINNY_Sbox_5_Q294_inst1_Inst_6__CF_Inst_n3,
         Inst_SKINNY_Sbox_5_Q294_inst1_Inst_7__CF_Inst_n6,
         Inst_SKINNY_Sbox_5_Q294_inst1_Inst_7__CF_Inst_n5,
         Inst_SKINNY_Sbox_5_Q294_inst1_Inst_8__CF_Inst_n6,
         Inst_SKINNY_Sbox_5_Q294_inst1_Inst_8__CF_Inst_n5,
         Inst_SKINNY_Sbox_5_Q294_inst1_Inst_9__CF_Inst_n3,
         Inst_SKINNY_Sbox_5_Q294_inst1_Inst_10__CF_Inst_n6,
         Inst_SKINNY_Sbox_5_Q294_inst1_Inst_10__CF_Inst_n5,
         Inst_SKINNY_Sbox_5_Q294_inst1_Inst_11__CF_Inst_n6,
         Inst_SKINNY_Sbox_5_Q294_inst1_Inst_11__CF_Inst_n5,
         Inst_SKINNY_Sbox_5_Q294_inst1_Inst_12__CF_Inst_n3,
         Inst_SKINNY_Sbox_5_Q294_inst1_Inst_13__CF_Inst_n6,
         Inst_SKINNY_Sbox_5_Q294_inst1_Inst_13__CF_Inst_n5,
         Inst_SKINNY_Sbox_5_Q294_inst1_Inst_14__CF_Inst_n6,
         Inst_SKINNY_Sbox_5_Q294_inst1_Inst_14__CF_Inst_n5,
         Inst_SKINNY_Sbox_5_Q294_inst1_Inst_15__CF_Inst_n3,
         Inst_SKINNY_Sbox_5_Q294_inst1_Inst_16__CF_Inst_n6,
         Inst_SKINNY_Sbox_5_Q294_inst1_Inst_16__CF_Inst_n5,
         Inst_SKINNY_Sbox_5_Q294_inst1_Inst_17__CF_Inst_n6,
         Inst_SKINNY_Sbox_5_Q294_inst1_Inst_17__CF_Inst_n5,
         Inst_SKINNY_Sbox_5_Q294_inst1_InstXOR_0__Compression1_n3,
         Inst_SKINNY_Sbox_5_Q294_inst1_InstXOR_0__Compression2_n3,
         Inst_SKINNY_Sbox_5_Q294_inst1_InstXOR_0__Compression3_n3,
         Inst_SKINNY_Sbox_5_Q294_inst1_InstXOR_1__Compression1_n3,
         Inst_SKINNY_Sbox_5_Q294_inst1_InstXOR_1__Compression2_n3,
         Inst_SKINNY_Sbox_5_Q294_inst1_InstXOR_1__Compression3_n3,
         Inst_SKINNY_Sbox_5_Q294_inst2_Inst_0__CF_Inst_n3,
         Inst_SKINNY_Sbox_5_Q294_inst2_Inst_1__CF_Inst_n6,
         Inst_SKINNY_Sbox_5_Q294_inst2_Inst_1__CF_Inst_n5,
         Inst_SKINNY_Sbox_5_Q294_inst2_Inst_2__CF_Inst_n6,
         Inst_SKINNY_Sbox_5_Q294_inst2_Inst_2__CF_Inst_n5,
         Inst_SKINNY_Sbox_5_Q294_inst2_Inst_3__CF_Inst_n3,
         Inst_SKINNY_Sbox_5_Q294_inst2_Inst_4__CF_Inst_n6,
         Inst_SKINNY_Sbox_5_Q294_inst2_Inst_4__CF_Inst_n5,
         Inst_SKINNY_Sbox_5_Q294_inst2_Inst_5__CF_Inst_n6,
         Inst_SKINNY_Sbox_5_Q294_inst2_Inst_5__CF_Inst_n5,
         Inst_SKINNY_Sbox_5_Q294_inst2_Inst_6__CF_Inst_n3,
         Inst_SKINNY_Sbox_5_Q294_inst2_Inst_7__CF_Inst_n6,
         Inst_SKINNY_Sbox_5_Q294_inst2_Inst_7__CF_Inst_n5,
         Inst_SKINNY_Sbox_5_Q294_inst2_Inst_8__CF_Inst_n6,
         Inst_SKINNY_Sbox_5_Q294_inst2_Inst_8__CF_Inst_n5,
         Inst_SKINNY_Sbox_5_Q294_inst2_Inst_9__CF_Inst_n3,
         Inst_SKINNY_Sbox_5_Q294_inst2_Inst_10__CF_Inst_n6,
         Inst_SKINNY_Sbox_5_Q294_inst2_Inst_10__CF_Inst_n5,
         Inst_SKINNY_Sbox_5_Q294_inst2_Inst_11__CF_Inst_n6,
         Inst_SKINNY_Sbox_5_Q294_inst2_Inst_11__CF_Inst_n5,
         Inst_SKINNY_Sbox_5_Q294_inst2_Inst_12__CF_Inst_n3,
         Inst_SKINNY_Sbox_5_Q294_inst2_Inst_13__CF_Inst_n6,
         Inst_SKINNY_Sbox_5_Q294_inst2_Inst_13__CF_Inst_n5,
         Inst_SKINNY_Sbox_5_Q294_inst2_Inst_14__CF_Inst_n6,
         Inst_SKINNY_Sbox_5_Q294_inst2_Inst_14__CF_Inst_n5,
         Inst_SKINNY_Sbox_5_Q294_inst2_Inst_15__CF_Inst_n3,
         Inst_SKINNY_Sbox_5_Q294_inst2_Inst_16__CF_Inst_n6,
         Inst_SKINNY_Sbox_5_Q294_inst2_Inst_16__CF_Inst_n5,
         Inst_SKINNY_Sbox_5_Q294_inst2_Inst_17__CF_Inst_n6,
         Inst_SKINNY_Sbox_5_Q294_inst2_Inst_17__CF_Inst_n5,
         Inst_SKINNY_Sbox_5_Q294_inst2_InstXOR_0__Compression1_n3,
         Inst_SKINNY_Sbox_5_Q294_inst2_InstXOR_0__Compression2_n3,
         Inst_SKINNY_Sbox_5_Q294_inst2_InstXOR_0__Compression3_n3,
         Inst_SKINNY_Sbox_5_Q294_inst2_InstXOR_1__Compression1_n3,
         Inst_SKINNY_Sbox_5_Q294_inst2_InstXOR_1__Compression2_n3,
         Inst_SKINNY_Sbox_5_Q294_inst2_InstXOR_1__Compression3_n3,
         Inst_SKINNY_Sbox_6_n12, Inst_SKINNY_Sbox_6_n11,
         Inst_SKINNY_Sbox_6_n10, Inst_SKINNY_Sbox_6_n9,
         Inst_SKINNY_Sbox_6_Q294_inst1_Inst_0__CF_Inst_n3,
         Inst_SKINNY_Sbox_6_Q294_inst1_Inst_1__CF_Inst_n6,
         Inst_SKINNY_Sbox_6_Q294_inst1_Inst_1__CF_Inst_n5,
         Inst_SKINNY_Sbox_6_Q294_inst1_Inst_2__CF_Inst_n6,
         Inst_SKINNY_Sbox_6_Q294_inst1_Inst_2__CF_Inst_n5,
         Inst_SKINNY_Sbox_6_Q294_inst1_Inst_3__CF_Inst_n3,
         Inst_SKINNY_Sbox_6_Q294_inst1_Inst_4__CF_Inst_n6,
         Inst_SKINNY_Sbox_6_Q294_inst1_Inst_4__CF_Inst_n5,
         Inst_SKINNY_Sbox_6_Q294_inst1_Inst_5__CF_Inst_n6,
         Inst_SKINNY_Sbox_6_Q294_inst1_Inst_5__CF_Inst_n5,
         Inst_SKINNY_Sbox_6_Q294_inst1_Inst_6__CF_Inst_n3,
         Inst_SKINNY_Sbox_6_Q294_inst1_Inst_7__CF_Inst_n6,
         Inst_SKINNY_Sbox_6_Q294_inst1_Inst_7__CF_Inst_n5,
         Inst_SKINNY_Sbox_6_Q294_inst1_Inst_8__CF_Inst_n6,
         Inst_SKINNY_Sbox_6_Q294_inst1_Inst_8__CF_Inst_n5,
         Inst_SKINNY_Sbox_6_Q294_inst1_Inst_9__CF_Inst_n3,
         Inst_SKINNY_Sbox_6_Q294_inst1_Inst_10__CF_Inst_n6,
         Inst_SKINNY_Sbox_6_Q294_inst1_Inst_10__CF_Inst_n5,
         Inst_SKINNY_Sbox_6_Q294_inst1_Inst_11__CF_Inst_n6,
         Inst_SKINNY_Sbox_6_Q294_inst1_Inst_11__CF_Inst_n5,
         Inst_SKINNY_Sbox_6_Q294_inst1_Inst_12__CF_Inst_n3,
         Inst_SKINNY_Sbox_6_Q294_inst1_Inst_13__CF_Inst_n6,
         Inst_SKINNY_Sbox_6_Q294_inst1_Inst_13__CF_Inst_n5,
         Inst_SKINNY_Sbox_6_Q294_inst1_Inst_14__CF_Inst_n6,
         Inst_SKINNY_Sbox_6_Q294_inst1_Inst_14__CF_Inst_n5,
         Inst_SKINNY_Sbox_6_Q294_inst1_Inst_15__CF_Inst_n3,
         Inst_SKINNY_Sbox_6_Q294_inst1_Inst_16__CF_Inst_n6,
         Inst_SKINNY_Sbox_6_Q294_inst1_Inst_16__CF_Inst_n5,
         Inst_SKINNY_Sbox_6_Q294_inst1_Inst_17__CF_Inst_n6,
         Inst_SKINNY_Sbox_6_Q294_inst1_Inst_17__CF_Inst_n5,
         Inst_SKINNY_Sbox_6_Q294_inst1_InstXOR_0__Compression1_n3,
         Inst_SKINNY_Sbox_6_Q294_inst1_InstXOR_0__Compression2_n3,
         Inst_SKINNY_Sbox_6_Q294_inst1_InstXOR_0__Compression3_n3,
         Inst_SKINNY_Sbox_6_Q294_inst1_InstXOR_1__Compression1_n3,
         Inst_SKINNY_Sbox_6_Q294_inst1_InstXOR_1__Compression2_n3,
         Inst_SKINNY_Sbox_6_Q294_inst1_InstXOR_1__Compression3_n3,
         Inst_SKINNY_Sbox_6_Q294_inst2_Inst_0__CF_Inst_n3,
         Inst_SKINNY_Sbox_6_Q294_inst2_Inst_1__CF_Inst_n6,
         Inst_SKINNY_Sbox_6_Q294_inst2_Inst_1__CF_Inst_n5,
         Inst_SKINNY_Sbox_6_Q294_inst2_Inst_2__CF_Inst_n6,
         Inst_SKINNY_Sbox_6_Q294_inst2_Inst_2__CF_Inst_n5,
         Inst_SKINNY_Sbox_6_Q294_inst2_Inst_3__CF_Inst_n3,
         Inst_SKINNY_Sbox_6_Q294_inst2_Inst_4__CF_Inst_n6,
         Inst_SKINNY_Sbox_6_Q294_inst2_Inst_4__CF_Inst_n5,
         Inst_SKINNY_Sbox_6_Q294_inst2_Inst_5__CF_Inst_n6,
         Inst_SKINNY_Sbox_6_Q294_inst2_Inst_5__CF_Inst_n5,
         Inst_SKINNY_Sbox_6_Q294_inst2_Inst_6__CF_Inst_n3,
         Inst_SKINNY_Sbox_6_Q294_inst2_Inst_7__CF_Inst_n6,
         Inst_SKINNY_Sbox_6_Q294_inst2_Inst_7__CF_Inst_n5,
         Inst_SKINNY_Sbox_6_Q294_inst2_Inst_8__CF_Inst_n6,
         Inst_SKINNY_Sbox_6_Q294_inst2_Inst_8__CF_Inst_n5,
         Inst_SKINNY_Sbox_6_Q294_inst2_Inst_9__CF_Inst_n3,
         Inst_SKINNY_Sbox_6_Q294_inst2_Inst_10__CF_Inst_n6,
         Inst_SKINNY_Sbox_6_Q294_inst2_Inst_10__CF_Inst_n5,
         Inst_SKINNY_Sbox_6_Q294_inst2_Inst_11__CF_Inst_n6,
         Inst_SKINNY_Sbox_6_Q294_inst2_Inst_11__CF_Inst_n5,
         Inst_SKINNY_Sbox_6_Q294_inst2_Inst_12__CF_Inst_n3,
         Inst_SKINNY_Sbox_6_Q294_inst2_Inst_13__CF_Inst_n6,
         Inst_SKINNY_Sbox_6_Q294_inst2_Inst_13__CF_Inst_n5,
         Inst_SKINNY_Sbox_6_Q294_inst2_Inst_14__CF_Inst_n6,
         Inst_SKINNY_Sbox_6_Q294_inst2_Inst_14__CF_Inst_n5,
         Inst_SKINNY_Sbox_6_Q294_inst2_Inst_15__CF_Inst_n3,
         Inst_SKINNY_Sbox_6_Q294_inst2_Inst_16__CF_Inst_n6,
         Inst_SKINNY_Sbox_6_Q294_inst2_Inst_16__CF_Inst_n5,
         Inst_SKINNY_Sbox_6_Q294_inst2_Inst_17__CF_Inst_n6,
         Inst_SKINNY_Sbox_6_Q294_inst2_Inst_17__CF_Inst_n5,
         Inst_SKINNY_Sbox_6_Q294_inst2_InstXOR_0__Compression1_n3,
         Inst_SKINNY_Sbox_6_Q294_inst2_InstXOR_0__Compression2_n3,
         Inst_SKINNY_Sbox_6_Q294_inst2_InstXOR_0__Compression3_n3,
         Inst_SKINNY_Sbox_6_Q294_inst2_InstXOR_1__Compression1_n3,
         Inst_SKINNY_Sbox_6_Q294_inst2_InstXOR_1__Compression2_n3,
         Inst_SKINNY_Sbox_6_Q294_inst2_InstXOR_1__Compression3_n3,
         Inst_SKINNY_Sbox_7_n12, Inst_SKINNY_Sbox_7_n11,
         Inst_SKINNY_Sbox_7_n10, Inst_SKINNY_Sbox_7_n9,
         Inst_SKINNY_Sbox_7_Q294_inst1_Inst_0__CF_Inst_n3,
         Inst_SKINNY_Sbox_7_Q294_inst1_Inst_1__CF_Inst_n6,
         Inst_SKINNY_Sbox_7_Q294_inst1_Inst_1__CF_Inst_n5,
         Inst_SKINNY_Sbox_7_Q294_inst1_Inst_2__CF_Inst_n6,
         Inst_SKINNY_Sbox_7_Q294_inst1_Inst_2__CF_Inst_n5,
         Inst_SKINNY_Sbox_7_Q294_inst1_Inst_3__CF_Inst_n3,
         Inst_SKINNY_Sbox_7_Q294_inst1_Inst_4__CF_Inst_n6,
         Inst_SKINNY_Sbox_7_Q294_inst1_Inst_4__CF_Inst_n5,
         Inst_SKINNY_Sbox_7_Q294_inst1_Inst_5__CF_Inst_n6,
         Inst_SKINNY_Sbox_7_Q294_inst1_Inst_5__CF_Inst_n5,
         Inst_SKINNY_Sbox_7_Q294_inst1_Inst_6__CF_Inst_n3,
         Inst_SKINNY_Sbox_7_Q294_inst1_Inst_7__CF_Inst_n6,
         Inst_SKINNY_Sbox_7_Q294_inst1_Inst_7__CF_Inst_n5,
         Inst_SKINNY_Sbox_7_Q294_inst1_Inst_8__CF_Inst_n6,
         Inst_SKINNY_Sbox_7_Q294_inst1_Inst_8__CF_Inst_n5,
         Inst_SKINNY_Sbox_7_Q294_inst1_Inst_9__CF_Inst_n3,
         Inst_SKINNY_Sbox_7_Q294_inst1_Inst_10__CF_Inst_n6,
         Inst_SKINNY_Sbox_7_Q294_inst1_Inst_10__CF_Inst_n5,
         Inst_SKINNY_Sbox_7_Q294_inst1_Inst_11__CF_Inst_n6,
         Inst_SKINNY_Sbox_7_Q294_inst1_Inst_11__CF_Inst_n5,
         Inst_SKINNY_Sbox_7_Q294_inst1_Inst_12__CF_Inst_n3,
         Inst_SKINNY_Sbox_7_Q294_inst1_Inst_13__CF_Inst_n6,
         Inst_SKINNY_Sbox_7_Q294_inst1_Inst_13__CF_Inst_n5,
         Inst_SKINNY_Sbox_7_Q294_inst1_Inst_14__CF_Inst_n6,
         Inst_SKINNY_Sbox_7_Q294_inst1_Inst_14__CF_Inst_n5,
         Inst_SKINNY_Sbox_7_Q294_inst1_Inst_15__CF_Inst_n3,
         Inst_SKINNY_Sbox_7_Q294_inst1_Inst_16__CF_Inst_n6,
         Inst_SKINNY_Sbox_7_Q294_inst1_Inst_16__CF_Inst_n5,
         Inst_SKINNY_Sbox_7_Q294_inst1_Inst_17__CF_Inst_n6,
         Inst_SKINNY_Sbox_7_Q294_inst1_Inst_17__CF_Inst_n5,
         Inst_SKINNY_Sbox_7_Q294_inst1_InstXOR_0__Compression1_n3,
         Inst_SKINNY_Sbox_7_Q294_inst1_InstXOR_0__Compression2_n3,
         Inst_SKINNY_Sbox_7_Q294_inst1_InstXOR_0__Compression3_n3,
         Inst_SKINNY_Sbox_7_Q294_inst1_InstXOR_1__Compression1_n3,
         Inst_SKINNY_Sbox_7_Q294_inst1_InstXOR_1__Compression2_n3,
         Inst_SKINNY_Sbox_7_Q294_inst1_InstXOR_1__Compression3_n3,
         Inst_SKINNY_Sbox_7_Q294_inst2_Inst_0__CF_Inst_n3,
         Inst_SKINNY_Sbox_7_Q294_inst2_Inst_1__CF_Inst_n6,
         Inst_SKINNY_Sbox_7_Q294_inst2_Inst_1__CF_Inst_n5,
         Inst_SKINNY_Sbox_7_Q294_inst2_Inst_2__CF_Inst_n6,
         Inst_SKINNY_Sbox_7_Q294_inst2_Inst_2__CF_Inst_n5,
         Inst_SKINNY_Sbox_7_Q294_inst2_Inst_3__CF_Inst_n3,
         Inst_SKINNY_Sbox_7_Q294_inst2_Inst_4__CF_Inst_n6,
         Inst_SKINNY_Sbox_7_Q294_inst2_Inst_4__CF_Inst_n5,
         Inst_SKINNY_Sbox_7_Q294_inst2_Inst_5__CF_Inst_n6,
         Inst_SKINNY_Sbox_7_Q294_inst2_Inst_5__CF_Inst_n5,
         Inst_SKINNY_Sbox_7_Q294_inst2_Inst_6__CF_Inst_n3,
         Inst_SKINNY_Sbox_7_Q294_inst2_Inst_7__CF_Inst_n6,
         Inst_SKINNY_Sbox_7_Q294_inst2_Inst_7__CF_Inst_n5,
         Inst_SKINNY_Sbox_7_Q294_inst2_Inst_8__CF_Inst_n6,
         Inst_SKINNY_Sbox_7_Q294_inst2_Inst_8__CF_Inst_n5,
         Inst_SKINNY_Sbox_7_Q294_inst2_Inst_9__CF_Inst_n3,
         Inst_SKINNY_Sbox_7_Q294_inst2_Inst_10__CF_Inst_n6,
         Inst_SKINNY_Sbox_7_Q294_inst2_Inst_10__CF_Inst_n5,
         Inst_SKINNY_Sbox_7_Q294_inst2_Inst_11__CF_Inst_n6,
         Inst_SKINNY_Sbox_7_Q294_inst2_Inst_11__CF_Inst_n5,
         Inst_SKINNY_Sbox_7_Q294_inst2_Inst_12__CF_Inst_n3,
         Inst_SKINNY_Sbox_7_Q294_inst2_Inst_13__CF_Inst_n6,
         Inst_SKINNY_Sbox_7_Q294_inst2_Inst_13__CF_Inst_n5,
         Inst_SKINNY_Sbox_7_Q294_inst2_Inst_14__CF_Inst_n6,
         Inst_SKINNY_Sbox_7_Q294_inst2_Inst_14__CF_Inst_n5,
         Inst_SKINNY_Sbox_7_Q294_inst2_Inst_15__CF_Inst_n3,
         Inst_SKINNY_Sbox_7_Q294_inst2_Inst_16__CF_Inst_n6,
         Inst_SKINNY_Sbox_7_Q294_inst2_Inst_16__CF_Inst_n5,
         Inst_SKINNY_Sbox_7_Q294_inst2_Inst_17__CF_Inst_n6,
         Inst_SKINNY_Sbox_7_Q294_inst2_Inst_17__CF_Inst_n5,
         Inst_SKINNY_Sbox_7_Q294_inst2_InstXOR_0__Compression1_n3,
         Inst_SKINNY_Sbox_7_Q294_inst2_InstXOR_0__Compression2_n3,
         Inst_SKINNY_Sbox_7_Q294_inst2_InstXOR_0__Compression3_n3,
         Inst_SKINNY_Sbox_7_Q294_inst2_InstXOR_1__Compression1_n3,
         Inst_SKINNY_Sbox_7_Q294_inst2_InstXOR_1__Compression2_n3,
         Inst_SKINNY_Sbox_7_Q294_inst2_InstXOR_1__Compression3_n3,
         Inst_SKINNY_Sbox_8_n12, Inst_SKINNY_Sbox_8_n11,
         Inst_SKINNY_Sbox_8_n10, Inst_SKINNY_Sbox_8_n9,
         Inst_SKINNY_Sbox_8_Q294_inst1_Inst_0__CF_Inst_n3,
         Inst_SKINNY_Sbox_8_Q294_inst1_Inst_1__CF_Inst_n6,
         Inst_SKINNY_Sbox_8_Q294_inst1_Inst_1__CF_Inst_n5,
         Inst_SKINNY_Sbox_8_Q294_inst1_Inst_2__CF_Inst_n6,
         Inst_SKINNY_Sbox_8_Q294_inst1_Inst_2__CF_Inst_n5,
         Inst_SKINNY_Sbox_8_Q294_inst1_Inst_3__CF_Inst_n3,
         Inst_SKINNY_Sbox_8_Q294_inst1_Inst_4__CF_Inst_n6,
         Inst_SKINNY_Sbox_8_Q294_inst1_Inst_4__CF_Inst_n5,
         Inst_SKINNY_Sbox_8_Q294_inst1_Inst_5__CF_Inst_n6,
         Inst_SKINNY_Sbox_8_Q294_inst1_Inst_5__CF_Inst_n5,
         Inst_SKINNY_Sbox_8_Q294_inst1_Inst_6__CF_Inst_n3,
         Inst_SKINNY_Sbox_8_Q294_inst1_Inst_7__CF_Inst_n6,
         Inst_SKINNY_Sbox_8_Q294_inst1_Inst_7__CF_Inst_n5,
         Inst_SKINNY_Sbox_8_Q294_inst1_Inst_8__CF_Inst_n6,
         Inst_SKINNY_Sbox_8_Q294_inst1_Inst_8__CF_Inst_n5,
         Inst_SKINNY_Sbox_8_Q294_inst1_Inst_9__CF_Inst_n3,
         Inst_SKINNY_Sbox_8_Q294_inst1_Inst_10__CF_Inst_n6,
         Inst_SKINNY_Sbox_8_Q294_inst1_Inst_10__CF_Inst_n5,
         Inst_SKINNY_Sbox_8_Q294_inst1_Inst_11__CF_Inst_n6,
         Inst_SKINNY_Sbox_8_Q294_inst1_Inst_11__CF_Inst_n5,
         Inst_SKINNY_Sbox_8_Q294_inst1_Inst_12__CF_Inst_n3,
         Inst_SKINNY_Sbox_8_Q294_inst1_Inst_13__CF_Inst_n6,
         Inst_SKINNY_Sbox_8_Q294_inst1_Inst_13__CF_Inst_n5,
         Inst_SKINNY_Sbox_8_Q294_inst1_Inst_14__CF_Inst_n6,
         Inst_SKINNY_Sbox_8_Q294_inst1_Inst_14__CF_Inst_n5,
         Inst_SKINNY_Sbox_8_Q294_inst1_Inst_15__CF_Inst_n3,
         Inst_SKINNY_Sbox_8_Q294_inst1_Inst_16__CF_Inst_n6,
         Inst_SKINNY_Sbox_8_Q294_inst1_Inst_16__CF_Inst_n5,
         Inst_SKINNY_Sbox_8_Q294_inst1_Inst_17__CF_Inst_n6,
         Inst_SKINNY_Sbox_8_Q294_inst1_Inst_17__CF_Inst_n5,
         Inst_SKINNY_Sbox_8_Q294_inst1_InstXOR_0__Compression1_n3,
         Inst_SKINNY_Sbox_8_Q294_inst1_InstXOR_0__Compression2_n3,
         Inst_SKINNY_Sbox_8_Q294_inst1_InstXOR_0__Compression3_n3,
         Inst_SKINNY_Sbox_8_Q294_inst1_InstXOR_1__Compression1_n3,
         Inst_SKINNY_Sbox_8_Q294_inst1_InstXOR_1__Compression2_n3,
         Inst_SKINNY_Sbox_8_Q294_inst1_InstXOR_1__Compression3_n3,
         Inst_SKINNY_Sbox_8_Q294_inst2_Inst_0__CF_Inst_n3,
         Inst_SKINNY_Sbox_8_Q294_inst2_Inst_1__CF_Inst_n6,
         Inst_SKINNY_Sbox_8_Q294_inst2_Inst_1__CF_Inst_n5,
         Inst_SKINNY_Sbox_8_Q294_inst2_Inst_2__CF_Inst_n6,
         Inst_SKINNY_Sbox_8_Q294_inst2_Inst_2__CF_Inst_n5,
         Inst_SKINNY_Sbox_8_Q294_inst2_Inst_3__CF_Inst_n3,
         Inst_SKINNY_Sbox_8_Q294_inst2_Inst_4__CF_Inst_n6,
         Inst_SKINNY_Sbox_8_Q294_inst2_Inst_4__CF_Inst_n5,
         Inst_SKINNY_Sbox_8_Q294_inst2_Inst_5__CF_Inst_n6,
         Inst_SKINNY_Sbox_8_Q294_inst2_Inst_5__CF_Inst_n5,
         Inst_SKINNY_Sbox_8_Q294_inst2_Inst_6__CF_Inst_n3,
         Inst_SKINNY_Sbox_8_Q294_inst2_Inst_7__CF_Inst_n6,
         Inst_SKINNY_Sbox_8_Q294_inst2_Inst_7__CF_Inst_n5,
         Inst_SKINNY_Sbox_8_Q294_inst2_Inst_8__CF_Inst_n6,
         Inst_SKINNY_Sbox_8_Q294_inst2_Inst_8__CF_Inst_n5,
         Inst_SKINNY_Sbox_8_Q294_inst2_Inst_9__CF_Inst_n3,
         Inst_SKINNY_Sbox_8_Q294_inst2_Inst_10__CF_Inst_n6,
         Inst_SKINNY_Sbox_8_Q294_inst2_Inst_10__CF_Inst_n5,
         Inst_SKINNY_Sbox_8_Q294_inst2_Inst_11__CF_Inst_n6,
         Inst_SKINNY_Sbox_8_Q294_inst2_Inst_11__CF_Inst_n5,
         Inst_SKINNY_Sbox_8_Q294_inst2_Inst_12__CF_Inst_n3,
         Inst_SKINNY_Sbox_8_Q294_inst2_Inst_13__CF_Inst_n6,
         Inst_SKINNY_Sbox_8_Q294_inst2_Inst_13__CF_Inst_n5,
         Inst_SKINNY_Sbox_8_Q294_inst2_Inst_14__CF_Inst_n6,
         Inst_SKINNY_Sbox_8_Q294_inst2_Inst_14__CF_Inst_n5,
         Inst_SKINNY_Sbox_8_Q294_inst2_Inst_15__CF_Inst_n3,
         Inst_SKINNY_Sbox_8_Q294_inst2_Inst_16__CF_Inst_n6,
         Inst_SKINNY_Sbox_8_Q294_inst2_Inst_16__CF_Inst_n5,
         Inst_SKINNY_Sbox_8_Q294_inst2_Inst_17__CF_Inst_n6,
         Inst_SKINNY_Sbox_8_Q294_inst2_Inst_17__CF_Inst_n5,
         Inst_SKINNY_Sbox_8_Q294_inst2_InstXOR_0__Compression1_n3,
         Inst_SKINNY_Sbox_8_Q294_inst2_InstXOR_0__Compression2_n3,
         Inst_SKINNY_Sbox_8_Q294_inst2_InstXOR_0__Compression3_n3,
         Inst_SKINNY_Sbox_8_Q294_inst2_InstXOR_1__Compression1_n3,
         Inst_SKINNY_Sbox_8_Q294_inst2_InstXOR_1__Compression2_n3,
         Inst_SKINNY_Sbox_8_Q294_inst2_InstXOR_1__Compression3_n3,
         Inst_SKINNY_Sbox_9_n12, Inst_SKINNY_Sbox_9_n11,
         Inst_SKINNY_Sbox_9_n10, Inst_SKINNY_Sbox_9_n9,
         Inst_SKINNY_Sbox_9_Q294_inst1_Inst_0__CF_Inst_n3,
         Inst_SKINNY_Sbox_9_Q294_inst1_Inst_1__CF_Inst_n6,
         Inst_SKINNY_Sbox_9_Q294_inst1_Inst_1__CF_Inst_n5,
         Inst_SKINNY_Sbox_9_Q294_inst1_Inst_2__CF_Inst_n6,
         Inst_SKINNY_Sbox_9_Q294_inst1_Inst_2__CF_Inst_n5,
         Inst_SKINNY_Sbox_9_Q294_inst1_Inst_3__CF_Inst_n3,
         Inst_SKINNY_Sbox_9_Q294_inst1_Inst_4__CF_Inst_n6,
         Inst_SKINNY_Sbox_9_Q294_inst1_Inst_4__CF_Inst_n5,
         Inst_SKINNY_Sbox_9_Q294_inst1_Inst_5__CF_Inst_n6,
         Inst_SKINNY_Sbox_9_Q294_inst1_Inst_5__CF_Inst_n5,
         Inst_SKINNY_Sbox_9_Q294_inst1_Inst_6__CF_Inst_n3,
         Inst_SKINNY_Sbox_9_Q294_inst1_Inst_7__CF_Inst_n6,
         Inst_SKINNY_Sbox_9_Q294_inst1_Inst_7__CF_Inst_n5,
         Inst_SKINNY_Sbox_9_Q294_inst1_Inst_8__CF_Inst_n6,
         Inst_SKINNY_Sbox_9_Q294_inst1_Inst_8__CF_Inst_n5,
         Inst_SKINNY_Sbox_9_Q294_inst1_Inst_9__CF_Inst_n3,
         Inst_SKINNY_Sbox_9_Q294_inst1_Inst_10__CF_Inst_n6,
         Inst_SKINNY_Sbox_9_Q294_inst1_Inst_10__CF_Inst_n5,
         Inst_SKINNY_Sbox_9_Q294_inst1_Inst_11__CF_Inst_n6,
         Inst_SKINNY_Sbox_9_Q294_inst1_Inst_11__CF_Inst_n5,
         Inst_SKINNY_Sbox_9_Q294_inst1_Inst_12__CF_Inst_n3,
         Inst_SKINNY_Sbox_9_Q294_inst1_Inst_13__CF_Inst_n6,
         Inst_SKINNY_Sbox_9_Q294_inst1_Inst_13__CF_Inst_n5,
         Inst_SKINNY_Sbox_9_Q294_inst1_Inst_14__CF_Inst_n6,
         Inst_SKINNY_Sbox_9_Q294_inst1_Inst_14__CF_Inst_n5,
         Inst_SKINNY_Sbox_9_Q294_inst1_Inst_15__CF_Inst_n3,
         Inst_SKINNY_Sbox_9_Q294_inst1_Inst_16__CF_Inst_n6,
         Inst_SKINNY_Sbox_9_Q294_inst1_Inst_16__CF_Inst_n5,
         Inst_SKINNY_Sbox_9_Q294_inst1_Inst_17__CF_Inst_n6,
         Inst_SKINNY_Sbox_9_Q294_inst1_Inst_17__CF_Inst_n5,
         Inst_SKINNY_Sbox_9_Q294_inst1_InstXOR_0__Compression1_n3,
         Inst_SKINNY_Sbox_9_Q294_inst1_InstXOR_0__Compression2_n3,
         Inst_SKINNY_Sbox_9_Q294_inst1_InstXOR_0__Compression3_n3,
         Inst_SKINNY_Sbox_9_Q294_inst1_InstXOR_1__Compression1_n3,
         Inst_SKINNY_Sbox_9_Q294_inst1_InstXOR_1__Compression2_n3,
         Inst_SKINNY_Sbox_9_Q294_inst1_InstXOR_1__Compression3_n3,
         Inst_SKINNY_Sbox_9_Q294_inst2_Inst_0__CF_Inst_n3,
         Inst_SKINNY_Sbox_9_Q294_inst2_Inst_1__CF_Inst_n6,
         Inst_SKINNY_Sbox_9_Q294_inst2_Inst_1__CF_Inst_n5,
         Inst_SKINNY_Sbox_9_Q294_inst2_Inst_2__CF_Inst_n6,
         Inst_SKINNY_Sbox_9_Q294_inst2_Inst_2__CF_Inst_n5,
         Inst_SKINNY_Sbox_9_Q294_inst2_Inst_3__CF_Inst_n3,
         Inst_SKINNY_Sbox_9_Q294_inst2_Inst_4__CF_Inst_n6,
         Inst_SKINNY_Sbox_9_Q294_inst2_Inst_4__CF_Inst_n5,
         Inst_SKINNY_Sbox_9_Q294_inst2_Inst_5__CF_Inst_n6,
         Inst_SKINNY_Sbox_9_Q294_inst2_Inst_5__CF_Inst_n5,
         Inst_SKINNY_Sbox_9_Q294_inst2_Inst_6__CF_Inst_n3,
         Inst_SKINNY_Sbox_9_Q294_inst2_Inst_7__CF_Inst_n6,
         Inst_SKINNY_Sbox_9_Q294_inst2_Inst_7__CF_Inst_n5,
         Inst_SKINNY_Sbox_9_Q294_inst2_Inst_8__CF_Inst_n6,
         Inst_SKINNY_Sbox_9_Q294_inst2_Inst_8__CF_Inst_n5,
         Inst_SKINNY_Sbox_9_Q294_inst2_Inst_9__CF_Inst_n3,
         Inst_SKINNY_Sbox_9_Q294_inst2_Inst_10__CF_Inst_n6,
         Inst_SKINNY_Sbox_9_Q294_inst2_Inst_10__CF_Inst_n5,
         Inst_SKINNY_Sbox_9_Q294_inst2_Inst_11__CF_Inst_n6,
         Inst_SKINNY_Sbox_9_Q294_inst2_Inst_11__CF_Inst_n5,
         Inst_SKINNY_Sbox_9_Q294_inst2_Inst_12__CF_Inst_n3,
         Inst_SKINNY_Sbox_9_Q294_inst2_Inst_13__CF_Inst_n6,
         Inst_SKINNY_Sbox_9_Q294_inst2_Inst_13__CF_Inst_n5,
         Inst_SKINNY_Sbox_9_Q294_inst2_Inst_14__CF_Inst_n6,
         Inst_SKINNY_Sbox_9_Q294_inst2_Inst_14__CF_Inst_n5,
         Inst_SKINNY_Sbox_9_Q294_inst2_Inst_15__CF_Inst_n3,
         Inst_SKINNY_Sbox_9_Q294_inst2_Inst_16__CF_Inst_n6,
         Inst_SKINNY_Sbox_9_Q294_inst2_Inst_16__CF_Inst_n5,
         Inst_SKINNY_Sbox_9_Q294_inst2_Inst_17__CF_Inst_n6,
         Inst_SKINNY_Sbox_9_Q294_inst2_Inst_17__CF_Inst_n5,
         Inst_SKINNY_Sbox_9_Q294_inst2_InstXOR_0__Compression1_n3,
         Inst_SKINNY_Sbox_9_Q294_inst2_InstXOR_0__Compression2_n3,
         Inst_SKINNY_Sbox_9_Q294_inst2_InstXOR_0__Compression3_n3,
         Inst_SKINNY_Sbox_9_Q294_inst2_InstXOR_1__Compression1_n3,
         Inst_SKINNY_Sbox_9_Q294_inst2_InstXOR_1__Compression2_n3,
         Inst_SKINNY_Sbox_9_Q294_inst2_InstXOR_1__Compression3_n3,
         Inst_SKINNY_Sbox_10_n12, Inst_SKINNY_Sbox_10_n11,
         Inst_SKINNY_Sbox_10_n10, Inst_SKINNY_Sbox_10_n9,
         Inst_SKINNY_Sbox_10_Q294_inst1_Inst_0__CF_Inst_n3,
         Inst_SKINNY_Sbox_10_Q294_inst1_Inst_1__CF_Inst_n6,
         Inst_SKINNY_Sbox_10_Q294_inst1_Inst_1__CF_Inst_n5,
         Inst_SKINNY_Sbox_10_Q294_inst1_Inst_2__CF_Inst_n6,
         Inst_SKINNY_Sbox_10_Q294_inst1_Inst_2__CF_Inst_n5,
         Inst_SKINNY_Sbox_10_Q294_inst1_Inst_3__CF_Inst_n3,
         Inst_SKINNY_Sbox_10_Q294_inst1_Inst_4__CF_Inst_n6,
         Inst_SKINNY_Sbox_10_Q294_inst1_Inst_4__CF_Inst_n5,
         Inst_SKINNY_Sbox_10_Q294_inst1_Inst_5__CF_Inst_n6,
         Inst_SKINNY_Sbox_10_Q294_inst1_Inst_5__CF_Inst_n5,
         Inst_SKINNY_Sbox_10_Q294_inst1_Inst_6__CF_Inst_n3,
         Inst_SKINNY_Sbox_10_Q294_inst1_Inst_7__CF_Inst_n6,
         Inst_SKINNY_Sbox_10_Q294_inst1_Inst_7__CF_Inst_n5,
         Inst_SKINNY_Sbox_10_Q294_inst1_Inst_8__CF_Inst_n6,
         Inst_SKINNY_Sbox_10_Q294_inst1_Inst_8__CF_Inst_n5,
         Inst_SKINNY_Sbox_10_Q294_inst1_Inst_9__CF_Inst_n3,
         Inst_SKINNY_Sbox_10_Q294_inst1_Inst_10__CF_Inst_n6,
         Inst_SKINNY_Sbox_10_Q294_inst1_Inst_10__CF_Inst_n5,
         Inst_SKINNY_Sbox_10_Q294_inst1_Inst_11__CF_Inst_n6,
         Inst_SKINNY_Sbox_10_Q294_inst1_Inst_11__CF_Inst_n5,
         Inst_SKINNY_Sbox_10_Q294_inst1_Inst_12__CF_Inst_n3,
         Inst_SKINNY_Sbox_10_Q294_inst1_Inst_13__CF_Inst_n6,
         Inst_SKINNY_Sbox_10_Q294_inst1_Inst_13__CF_Inst_n5,
         Inst_SKINNY_Sbox_10_Q294_inst1_Inst_14__CF_Inst_n6,
         Inst_SKINNY_Sbox_10_Q294_inst1_Inst_14__CF_Inst_n5,
         Inst_SKINNY_Sbox_10_Q294_inst1_Inst_15__CF_Inst_n3,
         Inst_SKINNY_Sbox_10_Q294_inst1_Inst_16__CF_Inst_n6,
         Inst_SKINNY_Sbox_10_Q294_inst1_Inst_16__CF_Inst_n5,
         Inst_SKINNY_Sbox_10_Q294_inst1_Inst_17__CF_Inst_n6,
         Inst_SKINNY_Sbox_10_Q294_inst1_Inst_17__CF_Inst_n5,
         Inst_SKINNY_Sbox_10_Q294_inst1_InstXOR_0__Compression1_n3,
         Inst_SKINNY_Sbox_10_Q294_inst1_InstXOR_0__Compression2_n3,
         Inst_SKINNY_Sbox_10_Q294_inst1_InstXOR_0__Compression3_n3,
         Inst_SKINNY_Sbox_10_Q294_inst1_InstXOR_1__Compression1_n3,
         Inst_SKINNY_Sbox_10_Q294_inst1_InstXOR_1__Compression2_n3,
         Inst_SKINNY_Sbox_10_Q294_inst1_InstXOR_1__Compression3_n3,
         Inst_SKINNY_Sbox_10_Q294_inst2_Inst_0__CF_Inst_n3,
         Inst_SKINNY_Sbox_10_Q294_inst2_Inst_1__CF_Inst_n6,
         Inst_SKINNY_Sbox_10_Q294_inst2_Inst_1__CF_Inst_n5,
         Inst_SKINNY_Sbox_10_Q294_inst2_Inst_2__CF_Inst_n6,
         Inst_SKINNY_Sbox_10_Q294_inst2_Inst_2__CF_Inst_n5,
         Inst_SKINNY_Sbox_10_Q294_inst2_Inst_3__CF_Inst_n3,
         Inst_SKINNY_Sbox_10_Q294_inst2_Inst_4__CF_Inst_n6,
         Inst_SKINNY_Sbox_10_Q294_inst2_Inst_4__CF_Inst_n5,
         Inst_SKINNY_Sbox_10_Q294_inst2_Inst_5__CF_Inst_n6,
         Inst_SKINNY_Sbox_10_Q294_inst2_Inst_5__CF_Inst_n5,
         Inst_SKINNY_Sbox_10_Q294_inst2_Inst_6__CF_Inst_n3,
         Inst_SKINNY_Sbox_10_Q294_inst2_Inst_7__CF_Inst_n6,
         Inst_SKINNY_Sbox_10_Q294_inst2_Inst_7__CF_Inst_n5,
         Inst_SKINNY_Sbox_10_Q294_inst2_Inst_8__CF_Inst_n6,
         Inst_SKINNY_Sbox_10_Q294_inst2_Inst_8__CF_Inst_n5,
         Inst_SKINNY_Sbox_10_Q294_inst2_Inst_9__CF_Inst_n3,
         Inst_SKINNY_Sbox_10_Q294_inst2_Inst_10__CF_Inst_n6,
         Inst_SKINNY_Sbox_10_Q294_inst2_Inst_10__CF_Inst_n5,
         Inst_SKINNY_Sbox_10_Q294_inst2_Inst_11__CF_Inst_n6,
         Inst_SKINNY_Sbox_10_Q294_inst2_Inst_11__CF_Inst_n5,
         Inst_SKINNY_Sbox_10_Q294_inst2_Inst_12__CF_Inst_n3,
         Inst_SKINNY_Sbox_10_Q294_inst2_Inst_13__CF_Inst_n6,
         Inst_SKINNY_Sbox_10_Q294_inst2_Inst_13__CF_Inst_n5,
         Inst_SKINNY_Sbox_10_Q294_inst2_Inst_14__CF_Inst_n6,
         Inst_SKINNY_Sbox_10_Q294_inst2_Inst_14__CF_Inst_n5,
         Inst_SKINNY_Sbox_10_Q294_inst2_Inst_15__CF_Inst_n3,
         Inst_SKINNY_Sbox_10_Q294_inst2_Inst_16__CF_Inst_n6,
         Inst_SKINNY_Sbox_10_Q294_inst2_Inst_16__CF_Inst_n5,
         Inst_SKINNY_Sbox_10_Q294_inst2_Inst_17__CF_Inst_n6,
         Inst_SKINNY_Sbox_10_Q294_inst2_Inst_17__CF_Inst_n5,
         Inst_SKINNY_Sbox_10_Q294_inst2_InstXOR_0__Compression1_n3,
         Inst_SKINNY_Sbox_10_Q294_inst2_InstXOR_0__Compression2_n3,
         Inst_SKINNY_Sbox_10_Q294_inst2_InstXOR_0__Compression3_n3,
         Inst_SKINNY_Sbox_10_Q294_inst2_InstXOR_1__Compression1_n3,
         Inst_SKINNY_Sbox_10_Q294_inst2_InstXOR_1__Compression2_n3,
         Inst_SKINNY_Sbox_10_Q294_inst2_InstXOR_1__Compression3_n3,
         Inst_SKINNY_Sbox_11_n12, Inst_SKINNY_Sbox_11_n11,
         Inst_SKINNY_Sbox_11_n10, Inst_SKINNY_Sbox_11_n9,
         Inst_SKINNY_Sbox_11_Q294_inst1_Inst_0__CF_Inst_n3,
         Inst_SKINNY_Sbox_11_Q294_inst1_Inst_1__CF_Inst_n6,
         Inst_SKINNY_Sbox_11_Q294_inst1_Inst_1__CF_Inst_n5,
         Inst_SKINNY_Sbox_11_Q294_inst1_Inst_2__CF_Inst_n6,
         Inst_SKINNY_Sbox_11_Q294_inst1_Inst_2__CF_Inst_n5,
         Inst_SKINNY_Sbox_11_Q294_inst1_Inst_3__CF_Inst_n3,
         Inst_SKINNY_Sbox_11_Q294_inst1_Inst_4__CF_Inst_n6,
         Inst_SKINNY_Sbox_11_Q294_inst1_Inst_4__CF_Inst_n5,
         Inst_SKINNY_Sbox_11_Q294_inst1_Inst_5__CF_Inst_n6,
         Inst_SKINNY_Sbox_11_Q294_inst1_Inst_5__CF_Inst_n5,
         Inst_SKINNY_Sbox_11_Q294_inst1_Inst_6__CF_Inst_n3,
         Inst_SKINNY_Sbox_11_Q294_inst1_Inst_7__CF_Inst_n6,
         Inst_SKINNY_Sbox_11_Q294_inst1_Inst_7__CF_Inst_n5,
         Inst_SKINNY_Sbox_11_Q294_inst1_Inst_8__CF_Inst_n6,
         Inst_SKINNY_Sbox_11_Q294_inst1_Inst_8__CF_Inst_n5,
         Inst_SKINNY_Sbox_11_Q294_inst1_Inst_9__CF_Inst_n3,
         Inst_SKINNY_Sbox_11_Q294_inst1_Inst_10__CF_Inst_n6,
         Inst_SKINNY_Sbox_11_Q294_inst1_Inst_10__CF_Inst_n5,
         Inst_SKINNY_Sbox_11_Q294_inst1_Inst_11__CF_Inst_n6,
         Inst_SKINNY_Sbox_11_Q294_inst1_Inst_11__CF_Inst_n5,
         Inst_SKINNY_Sbox_11_Q294_inst1_Inst_12__CF_Inst_n3,
         Inst_SKINNY_Sbox_11_Q294_inst1_Inst_13__CF_Inst_n6,
         Inst_SKINNY_Sbox_11_Q294_inst1_Inst_13__CF_Inst_n5,
         Inst_SKINNY_Sbox_11_Q294_inst1_Inst_14__CF_Inst_n6,
         Inst_SKINNY_Sbox_11_Q294_inst1_Inst_14__CF_Inst_n5,
         Inst_SKINNY_Sbox_11_Q294_inst1_Inst_15__CF_Inst_n3,
         Inst_SKINNY_Sbox_11_Q294_inst1_Inst_16__CF_Inst_n6,
         Inst_SKINNY_Sbox_11_Q294_inst1_Inst_16__CF_Inst_n5,
         Inst_SKINNY_Sbox_11_Q294_inst1_Inst_17__CF_Inst_n6,
         Inst_SKINNY_Sbox_11_Q294_inst1_Inst_17__CF_Inst_n5,
         Inst_SKINNY_Sbox_11_Q294_inst1_InstXOR_0__Compression1_n3,
         Inst_SKINNY_Sbox_11_Q294_inst1_InstXOR_0__Compression2_n3,
         Inst_SKINNY_Sbox_11_Q294_inst1_InstXOR_0__Compression3_n3,
         Inst_SKINNY_Sbox_11_Q294_inst1_InstXOR_1__Compression1_n3,
         Inst_SKINNY_Sbox_11_Q294_inst1_InstXOR_1__Compression2_n3,
         Inst_SKINNY_Sbox_11_Q294_inst1_InstXOR_1__Compression3_n3,
         Inst_SKINNY_Sbox_11_Q294_inst2_Inst_0__CF_Inst_n3,
         Inst_SKINNY_Sbox_11_Q294_inst2_Inst_1__CF_Inst_n6,
         Inst_SKINNY_Sbox_11_Q294_inst2_Inst_1__CF_Inst_n5,
         Inst_SKINNY_Sbox_11_Q294_inst2_Inst_2__CF_Inst_n6,
         Inst_SKINNY_Sbox_11_Q294_inst2_Inst_2__CF_Inst_n5,
         Inst_SKINNY_Sbox_11_Q294_inst2_Inst_3__CF_Inst_n3,
         Inst_SKINNY_Sbox_11_Q294_inst2_Inst_4__CF_Inst_n6,
         Inst_SKINNY_Sbox_11_Q294_inst2_Inst_4__CF_Inst_n5,
         Inst_SKINNY_Sbox_11_Q294_inst2_Inst_5__CF_Inst_n6,
         Inst_SKINNY_Sbox_11_Q294_inst2_Inst_5__CF_Inst_n5,
         Inst_SKINNY_Sbox_11_Q294_inst2_Inst_6__CF_Inst_n3,
         Inst_SKINNY_Sbox_11_Q294_inst2_Inst_7__CF_Inst_n6,
         Inst_SKINNY_Sbox_11_Q294_inst2_Inst_7__CF_Inst_n5,
         Inst_SKINNY_Sbox_11_Q294_inst2_Inst_8__CF_Inst_n6,
         Inst_SKINNY_Sbox_11_Q294_inst2_Inst_8__CF_Inst_n5,
         Inst_SKINNY_Sbox_11_Q294_inst2_Inst_9__CF_Inst_n3,
         Inst_SKINNY_Sbox_11_Q294_inst2_Inst_10__CF_Inst_n6,
         Inst_SKINNY_Sbox_11_Q294_inst2_Inst_10__CF_Inst_n5,
         Inst_SKINNY_Sbox_11_Q294_inst2_Inst_11__CF_Inst_n6,
         Inst_SKINNY_Sbox_11_Q294_inst2_Inst_11__CF_Inst_n5,
         Inst_SKINNY_Sbox_11_Q294_inst2_Inst_12__CF_Inst_n3,
         Inst_SKINNY_Sbox_11_Q294_inst2_Inst_13__CF_Inst_n6,
         Inst_SKINNY_Sbox_11_Q294_inst2_Inst_13__CF_Inst_n5,
         Inst_SKINNY_Sbox_11_Q294_inst2_Inst_14__CF_Inst_n6,
         Inst_SKINNY_Sbox_11_Q294_inst2_Inst_14__CF_Inst_n5,
         Inst_SKINNY_Sbox_11_Q294_inst2_Inst_15__CF_Inst_n3,
         Inst_SKINNY_Sbox_11_Q294_inst2_Inst_16__CF_Inst_n6,
         Inst_SKINNY_Sbox_11_Q294_inst2_Inst_16__CF_Inst_n5,
         Inst_SKINNY_Sbox_11_Q294_inst2_Inst_17__CF_Inst_n6,
         Inst_SKINNY_Sbox_11_Q294_inst2_Inst_17__CF_Inst_n5,
         Inst_SKINNY_Sbox_11_Q294_inst2_InstXOR_0__Compression1_n3,
         Inst_SKINNY_Sbox_11_Q294_inst2_InstXOR_0__Compression2_n3,
         Inst_SKINNY_Sbox_11_Q294_inst2_InstXOR_0__Compression3_n3,
         Inst_SKINNY_Sbox_11_Q294_inst2_InstXOR_1__Compression1_n3,
         Inst_SKINNY_Sbox_11_Q294_inst2_InstXOR_1__Compression2_n3,
         Inst_SKINNY_Sbox_11_Q294_inst2_InstXOR_1__Compression3_n3,
         Inst_SKINNY_Sbox_12_n12, Inst_SKINNY_Sbox_12_n11,
         Inst_SKINNY_Sbox_12_n10, Inst_SKINNY_Sbox_12_n9,
         Inst_SKINNY_Sbox_12_Q294_inst1_Inst_0__CF_Inst_n3,
         Inst_SKINNY_Sbox_12_Q294_inst1_Inst_1__CF_Inst_n6,
         Inst_SKINNY_Sbox_12_Q294_inst1_Inst_1__CF_Inst_n5,
         Inst_SKINNY_Sbox_12_Q294_inst1_Inst_2__CF_Inst_n6,
         Inst_SKINNY_Sbox_12_Q294_inst1_Inst_2__CF_Inst_n5,
         Inst_SKINNY_Sbox_12_Q294_inst1_Inst_3__CF_Inst_n3,
         Inst_SKINNY_Sbox_12_Q294_inst1_Inst_4__CF_Inst_n6,
         Inst_SKINNY_Sbox_12_Q294_inst1_Inst_4__CF_Inst_n5,
         Inst_SKINNY_Sbox_12_Q294_inst1_Inst_5__CF_Inst_n6,
         Inst_SKINNY_Sbox_12_Q294_inst1_Inst_5__CF_Inst_n5,
         Inst_SKINNY_Sbox_12_Q294_inst1_Inst_6__CF_Inst_n3,
         Inst_SKINNY_Sbox_12_Q294_inst1_Inst_7__CF_Inst_n6,
         Inst_SKINNY_Sbox_12_Q294_inst1_Inst_7__CF_Inst_n5,
         Inst_SKINNY_Sbox_12_Q294_inst1_Inst_8__CF_Inst_n6,
         Inst_SKINNY_Sbox_12_Q294_inst1_Inst_8__CF_Inst_n5,
         Inst_SKINNY_Sbox_12_Q294_inst1_Inst_9__CF_Inst_n3,
         Inst_SKINNY_Sbox_12_Q294_inst1_Inst_10__CF_Inst_n6,
         Inst_SKINNY_Sbox_12_Q294_inst1_Inst_10__CF_Inst_n5,
         Inst_SKINNY_Sbox_12_Q294_inst1_Inst_11__CF_Inst_n6,
         Inst_SKINNY_Sbox_12_Q294_inst1_Inst_11__CF_Inst_n5,
         Inst_SKINNY_Sbox_12_Q294_inst1_Inst_12__CF_Inst_n3,
         Inst_SKINNY_Sbox_12_Q294_inst1_Inst_13__CF_Inst_n6,
         Inst_SKINNY_Sbox_12_Q294_inst1_Inst_13__CF_Inst_n5,
         Inst_SKINNY_Sbox_12_Q294_inst1_Inst_14__CF_Inst_n6,
         Inst_SKINNY_Sbox_12_Q294_inst1_Inst_14__CF_Inst_n5,
         Inst_SKINNY_Sbox_12_Q294_inst1_Inst_15__CF_Inst_n3,
         Inst_SKINNY_Sbox_12_Q294_inst1_Inst_16__CF_Inst_n6,
         Inst_SKINNY_Sbox_12_Q294_inst1_Inst_16__CF_Inst_n5,
         Inst_SKINNY_Sbox_12_Q294_inst1_Inst_17__CF_Inst_n6,
         Inst_SKINNY_Sbox_12_Q294_inst1_Inst_17__CF_Inst_n5,
         Inst_SKINNY_Sbox_12_Q294_inst1_InstXOR_0__Compression1_n3,
         Inst_SKINNY_Sbox_12_Q294_inst1_InstXOR_0__Compression2_n3,
         Inst_SKINNY_Sbox_12_Q294_inst1_InstXOR_0__Compression3_n3,
         Inst_SKINNY_Sbox_12_Q294_inst1_InstXOR_1__Compression1_n3,
         Inst_SKINNY_Sbox_12_Q294_inst1_InstXOR_1__Compression2_n3,
         Inst_SKINNY_Sbox_12_Q294_inst1_InstXOR_1__Compression3_n3,
         Inst_SKINNY_Sbox_12_Q294_inst2_Inst_0__CF_Inst_n3,
         Inst_SKINNY_Sbox_12_Q294_inst2_Inst_1__CF_Inst_n6,
         Inst_SKINNY_Sbox_12_Q294_inst2_Inst_1__CF_Inst_n5,
         Inst_SKINNY_Sbox_12_Q294_inst2_Inst_2__CF_Inst_n6,
         Inst_SKINNY_Sbox_12_Q294_inst2_Inst_2__CF_Inst_n5,
         Inst_SKINNY_Sbox_12_Q294_inst2_Inst_3__CF_Inst_n3,
         Inst_SKINNY_Sbox_12_Q294_inst2_Inst_4__CF_Inst_n6,
         Inst_SKINNY_Sbox_12_Q294_inst2_Inst_4__CF_Inst_n5,
         Inst_SKINNY_Sbox_12_Q294_inst2_Inst_5__CF_Inst_n6,
         Inst_SKINNY_Sbox_12_Q294_inst2_Inst_5__CF_Inst_n5,
         Inst_SKINNY_Sbox_12_Q294_inst2_Inst_6__CF_Inst_n3,
         Inst_SKINNY_Sbox_12_Q294_inst2_Inst_7__CF_Inst_n6,
         Inst_SKINNY_Sbox_12_Q294_inst2_Inst_7__CF_Inst_n5,
         Inst_SKINNY_Sbox_12_Q294_inst2_Inst_8__CF_Inst_n6,
         Inst_SKINNY_Sbox_12_Q294_inst2_Inst_8__CF_Inst_n5,
         Inst_SKINNY_Sbox_12_Q294_inst2_Inst_9__CF_Inst_n3,
         Inst_SKINNY_Sbox_12_Q294_inst2_Inst_10__CF_Inst_n6,
         Inst_SKINNY_Sbox_12_Q294_inst2_Inst_10__CF_Inst_n5,
         Inst_SKINNY_Sbox_12_Q294_inst2_Inst_11__CF_Inst_n6,
         Inst_SKINNY_Sbox_12_Q294_inst2_Inst_11__CF_Inst_n5,
         Inst_SKINNY_Sbox_12_Q294_inst2_Inst_12__CF_Inst_n3,
         Inst_SKINNY_Sbox_12_Q294_inst2_Inst_13__CF_Inst_n6,
         Inst_SKINNY_Sbox_12_Q294_inst2_Inst_13__CF_Inst_n5,
         Inst_SKINNY_Sbox_12_Q294_inst2_Inst_14__CF_Inst_n6,
         Inst_SKINNY_Sbox_12_Q294_inst2_Inst_14__CF_Inst_n5,
         Inst_SKINNY_Sbox_12_Q294_inst2_Inst_15__CF_Inst_n3,
         Inst_SKINNY_Sbox_12_Q294_inst2_Inst_16__CF_Inst_n6,
         Inst_SKINNY_Sbox_12_Q294_inst2_Inst_16__CF_Inst_n5,
         Inst_SKINNY_Sbox_12_Q294_inst2_Inst_17__CF_Inst_n6,
         Inst_SKINNY_Sbox_12_Q294_inst2_Inst_17__CF_Inst_n5,
         Inst_SKINNY_Sbox_12_Q294_inst2_InstXOR_0__Compression1_n3,
         Inst_SKINNY_Sbox_12_Q294_inst2_InstXOR_0__Compression2_n3,
         Inst_SKINNY_Sbox_12_Q294_inst2_InstXOR_0__Compression3_n3,
         Inst_SKINNY_Sbox_12_Q294_inst2_InstXOR_1__Compression1_n3,
         Inst_SKINNY_Sbox_12_Q294_inst2_InstXOR_1__Compression2_n3,
         Inst_SKINNY_Sbox_12_Q294_inst2_InstXOR_1__Compression3_n3,
         Inst_SKINNY_Sbox_13_n12, Inst_SKINNY_Sbox_13_n11,
         Inst_SKINNY_Sbox_13_n10, Inst_SKINNY_Sbox_13_n9,
         Inst_SKINNY_Sbox_13_Q294_inst1_Inst_0__CF_Inst_n3,
         Inst_SKINNY_Sbox_13_Q294_inst1_Inst_1__CF_Inst_n6,
         Inst_SKINNY_Sbox_13_Q294_inst1_Inst_1__CF_Inst_n5,
         Inst_SKINNY_Sbox_13_Q294_inst1_Inst_2__CF_Inst_n6,
         Inst_SKINNY_Sbox_13_Q294_inst1_Inst_2__CF_Inst_n5,
         Inst_SKINNY_Sbox_13_Q294_inst1_Inst_3__CF_Inst_n3,
         Inst_SKINNY_Sbox_13_Q294_inst1_Inst_4__CF_Inst_n6,
         Inst_SKINNY_Sbox_13_Q294_inst1_Inst_4__CF_Inst_n5,
         Inst_SKINNY_Sbox_13_Q294_inst1_Inst_5__CF_Inst_n6,
         Inst_SKINNY_Sbox_13_Q294_inst1_Inst_5__CF_Inst_n5,
         Inst_SKINNY_Sbox_13_Q294_inst1_Inst_6__CF_Inst_n3,
         Inst_SKINNY_Sbox_13_Q294_inst1_Inst_7__CF_Inst_n6,
         Inst_SKINNY_Sbox_13_Q294_inst1_Inst_7__CF_Inst_n5,
         Inst_SKINNY_Sbox_13_Q294_inst1_Inst_8__CF_Inst_n6,
         Inst_SKINNY_Sbox_13_Q294_inst1_Inst_8__CF_Inst_n5,
         Inst_SKINNY_Sbox_13_Q294_inst1_Inst_9__CF_Inst_n3,
         Inst_SKINNY_Sbox_13_Q294_inst1_Inst_10__CF_Inst_n6,
         Inst_SKINNY_Sbox_13_Q294_inst1_Inst_10__CF_Inst_n5,
         Inst_SKINNY_Sbox_13_Q294_inst1_Inst_11__CF_Inst_n6,
         Inst_SKINNY_Sbox_13_Q294_inst1_Inst_11__CF_Inst_n5,
         Inst_SKINNY_Sbox_13_Q294_inst1_Inst_12__CF_Inst_n3,
         Inst_SKINNY_Sbox_13_Q294_inst1_Inst_13__CF_Inst_n6,
         Inst_SKINNY_Sbox_13_Q294_inst1_Inst_13__CF_Inst_n5,
         Inst_SKINNY_Sbox_13_Q294_inst1_Inst_14__CF_Inst_n6,
         Inst_SKINNY_Sbox_13_Q294_inst1_Inst_14__CF_Inst_n5,
         Inst_SKINNY_Sbox_13_Q294_inst1_Inst_15__CF_Inst_n3,
         Inst_SKINNY_Sbox_13_Q294_inst1_Inst_16__CF_Inst_n6,
         Inst_SKINNY_Sbox_13_Q294_inst1_Inst_16__CF_Inst_n5,
         Inst_SKINNY_Sbox_13_Q294_inst1_Inst_17__CF_Inst_n6,
         Inst_SKINNY_Sbox_13_Q294_inst1_Inst_17__CF_Inst_n5,
         Inst_SKINNY_Sbox_13_Q294_inst1_InstXOR_0__Compression1_n3,
         Inst_SKINNY_Sbox_13_Q294_inst1_InstXOR_0__Compression2_n3,
         Inst_SKINNY_Sbox_13_Q294_inst1_InstXOR_0__Compression3_n3,
         Inst_SKINNY_Sbox_13_Q294_inst1_InstXOR_1__Compression1_n3,
         Inst_SKINNY_Sbox_13_Q294_inst1_InstXOR_1__Compression2_n3,
         Inst_SKINNY_Sbox_13_Q294_inst1_InstXOR_1__Compression3_n3,
         Inst_SKINNY_Sbox_13_Q294_inst2_Inst_0__CF_Inst_n3,
         Inst_SKINNY_Sbox_13_Q294_inst2_Inst_1__CF_Inst_n6,
         Inst_SKINNY_Sbox_13_Q294_inst2_Inst_1__CF_Inst_n5,
         Inst_SKINNY_Sbox_13_Q294_inst2_Inst_2__CF_Inst_n6,
         Inst_SKINNY_Sbox_13_Q294_inst2_Inst_2__CF_Inst_n5,
         Inst_SKINNY_Sbox_13_Q294_inst2_Inst_3__CF_Inst_n3,
         Inst_SKINNY_Sbox_13_Q294_inst2_Inst_4__CF_Inst_n6,
         Inst_SKINNY_Sbox_13_Q294_inst2_Inst_4__CF_Inst_n5,
         Inst_SKINNY_Sbox_13_Q294_inst2_Inst_5__CF_Inst_n6,
         Inst_SKINNY_Sbox_13_Q294_inst2_Inst_5__CF_Inst_n5,
         Inst_SKINNY_Sbox_13_Q294_inst2_Inst_6__CF_Inst_n3,
         Inst_SKINNY_Sbox_13_Q294_inst2_Inst_7__CF_Inst_n6,
         Inst_SKINNY_Sbox_13_Q294_inst2_Inst_7__CF_Inst_n5,
         Inst_SKINNY_Sbox_13_Q294_inst2_Inst_8__CF_Inst_n6,
         Inst_SKINNY_Sbox_13_Q294_inst2_Inst_8__CF_Inst_n5,
         Inst_SKINNY_Sbox_13_Q294_inst2_Inst_9__CF_Inst_n3,
         Inst_SKINNY_Sbox_13_Q294_inst2_Inst_10__CF_Inst_n6,
         Inst_SKINNY_Sbox_13_Q294_inst2_Inst_10__CF_Inst_n5,
         Inst_SKINNY_Sbox_13_Q294_inst2_Inst_11__CF_Inst_n6,
         Inst_SKINNY_Sbox_13_Q294_inst2_Inst_11__CF_Inst_n5,
         Inst_SKINNY_Sbox_13_Q294_inst2_Inst_12__CF_Inst_n3,
         Inst_SKINNY_Sbox_13_Q294_inst2_Inst_13__CF_Inst_n6,
         Inst_SKINNY_Sbox_13_Q294_inst2_Inst_13__CF_Inst_n5,
         Inst_SKINNY_Sbox_13_Q294_inst2_Inst_14__CF_Inst_n6,
         Inst_SKINNY_Sbox_13_Q294_inst2_Inst_14__CF_Inst_n5,
         Inst_SKINNY_Sbox_13_Q294_inst2_Inst_15__CF_Inst_n3,
         Inst_SKINNY_Sbox_13_Q294_inst2_Inst_16__CF_Inst_n6,
         Inst_SKINNY_Sbox_13_Q294_inst2_Inst_16__CF_Inst_n5,
         Inst_SKINNY_Sbox_13_Q294_inst2_Inst_17__CF_Inst_n6,
         Inst_SKINNY_Sbox_13_Q294_inst2_Inst_17__CF_Inst_n5,
         Inst_SKINNY_Sbox_13_Q294_inst2_InstXOR_0__Compression1_n3,
         Inst_SKINNY_Sbox_13_Q294_inst2_InstXOR_0__Compression2_n3,
         Inst_SKINNY_Sbox_13_Q294_inst2_InstXOR_0__Compression3_n3,
         Inst_SKINNY_Sbox_13_Q294_inst2_InstXOR_1__Compression1_n3,
         Inst_SKINNY_Sbox_13_Q294_inst2_InstXOR_1__Compression2_n3,
         Inst_SKINNY_Sbox_13_Q294_inst2_InstXOR_1__Compression3_n3,
         Inst_SKINNY_Sbox_14_n12, Inst_SKINNY_Sbox_14_n11,
         Inst_SKINNY_Sbox_14_n10, Inst_SKINNY_Sbox_14_n9,
         Inst_SKINNY_Sbox_14_Q294_inst1_Inst_0__CF_Inst_n3,
         Inst_SKINNY_Sbox_14_Q294_inst1_Inst_1__CF_Inst_n6,
         Inst_SKINNY_Sbox_14_Q294_inst1_Inst_1__CF_Inst_n5,
         Inst_SKINNY_Sbox_14_Q294_inst1_Inst_2__CF_Inst_n6,
         Inst_SKINNY_Sbox_14_Q294_inst1_Inst_2__CF_Inst_n5,
         Inst_SKINNY_Sbox_14_Q294_inst1_Inst_3__CF_Inst_n3,
         Inst_SKINNY_Sbox_14_Q294_inst1_Inst_4__CF_Inst_n6,
         Inst_SKINNY_Sbox_14_Q294_inst1_Inst_4__CF_Inst_n5,
         Inst_SKINNY_Sbox_14_Q294_inst1_Inst_5__CF_Inst_n6,
         Inst_SKINNY_Sbox_14_Q294_inst1_Inst_5__CF_Inst_n5,
         Inst_SKINNY_Sbox_14_Q294_inst1_Inst_6__CF_Inst_n3,
         Inst_SKINNY_Sbox_14_Q294_inst1_Inst_7__CF_Inst_n6,
         Inst_SKINNY_Sbox_14_Q294_inst1_Inst_7__CF_Inst_n5,
         Inst_SKINNY_Sbox_14_Q294_inst1_Inst_8__CF_Inst_n6,
         Inst_SKINNY_Sbox_14_Q294_inst1_Inst_8__CF_Inst_n5,
         Inst_SKINNY_Sbox_14_Q294_inst1_Inst_9__CF_Inst_n3,
         Inst_SKINNY_Sbox_14_Q294_inst1_Inst_10__CF_Inst_n6,
         Inst_SKINNY_Sbox_14_Q294_inst1_Inst_10__CF_Inst_n5,
         Inst_SKINNY_Sbox_14_Q294_inst1_Inst_11__CF_Inst_n6,
         Inst_SKINNY_Sbox_14_Q294_inst1_Inst_11__CF_Inst_n5,
         Inst_SKINNY_Sbox_14_Q294_inst1_Inst_12__CF_Inst_n3,
         Inst_SKINNY_Sbox_14_Q294_inst1_Inst_13__CF_Inst_n6,
         Inst_SKINNY_Sbox_14_Q294_inst1_Inst_13__CF_Inst_n5,
         Inst_SKINNY_Sbox_14_Q294_inst1_Inst_14__CF_Inst_n6,
         Inst_SKINNY_Sbox_14_Q294_inst1_Inst_14__CF_Inst_n5,
         Inst_SKINNY_Sbox_14_Q294_inst1_Inst_15__CF_Inst_n3,
         Inst_SKINNY_Sbox_14_Q294_inst1_Inst_16__CF_Inst_n6,
         Inst_SKINNY_Sbox_14_Q294_inst1_Inst_16__CF_Inst_n5,
         Inst_SKINNY_Sbox_14_Q294_inst1_Inst_17__CF_Inst_n6,
         Inst_SKINNY_Sbox_14_Q294_inst1_Inst_17__CF_Inst_n5,
         Inst_SKINNY_Sbox_14_Q294_inst1_InstXOR_0__Compression1_n3,
         Inst_SKINNY_Sbox_14_Q294_inst1_InstXOR_0__Compression2_n3,
         Inst_SKINNY_Sbox_14_Q294_inst1_InstXOR_0__Compression3_n3,
         Inst_SKINNY_Sbox_14_Q294_inst1_InstXOR_1__Compression1_n3,
         Inst_SKINNY_Sbox_14_Q294_inst1_InstXOR_1__Compression2_n3,
         Inst_SKINNY_Sbox_14_Q294_inst1_InstXOR_1__Compression3_n3,
         Inst_SKINNY_Sbox_14_Q294_inst2_Inst_0__CF_Inst_n3,
         Inst_SKINNY_Sbox_14_Q294_inst2_Inst_1__CF_Inst_n6,
         Inst_SKINNY_Sbox_14_Q294_inst2_Inst_1__CF_Inst_n5,
         Inst_SKINNY_Sbox_14_Q294_inst2_Inst_2__CF_Inst_n6,
         Inst_SKINNY_Sbox_14_Q294_inst2_Inst_2__CF_Inst_n5,
         Inst_SKINNY_Sbox_14_Q294_inst2_Inst_3__CF_Inst_n3,
         Inst_SKINNY_Sbox_14_Q294_inst2_Inst_4__CF_Inst_n6,
         Inst_SKINNY_Sbox_14_Q294_inst2_Inst_4__CF_Inst_n5,
         Inst_SKINNY_Sbox_14_Q294_inst2_Inst_5__CF_Inst_n6,
         Inst_SKINNY_Sbox_14_Q294_inst2_Inst_5__CF_Inst_n5,
         Inst_SKINNY_Sbox_14_Q294_inst2_Inst_6__CF_Inst_n3,
         Inst_SKINNY_Sbox_14_Q294_inst2_Inst_7__CF_Inst_n6,
         Inst_SKINNY_Sbox_14_Q294_inst2_Inst_7__CF_Inst_n5,
         Inst_SKINNY_Sbox_14_Q294_inst2_Inst_8__CF_Inst_n6,
         Inst_SKINNY_Sbox_14_Q294_inst2_Inst_8__CF_Inst_n5,
         Inst_SKINNY_Sbox_14_Q294_inst2_Inst_9__CF_Inst_n3,
         Inst_SKINNY_Sbox_14_Q294_inst2_Inst_10__CF_Inst_n6,
         Inst_SKINNY_Sbox_14_Q294_inst2_Inst_10__CF_Inst_n5,
         Inst_SKINNY_Sbox_14_Q294_inst2_Inst_11__CF_Inst_n6,
         Inst_SKINNY_Sbox_14_Q294_inst2_Inst_11__CF_Inst_n5,
         Inst_SKINNY_Sbox_14_Q294_inst2_Inst_12__CF_Inst_n3,
         Inst_SKINNY_Sbox_14_Q294_inst2_Inst_13__CF_Inst_n6,
         Inst_SKINNY_Sbox_14_Q294_inst2_Inst_13__CF_Inst_n5,
         Inst_SKINNY_Sbox_14_Q294_inst2_Inst_14__CF_Inst_n6,
         Inst_SKINNY_Sbox_14_Q294_inst2_Inst_14__CF_Inst_n5,
         Inst_SKINNY_Sbox_14_Q294_inst2_Inst_15__CF_Inst_n3,
         Inst_SKINNY_Sbox_14_Q294_inst2_Inst_16__CF_Inst_n6,
         Inst_SKINNY_Sbox_14_Q294_inst2_Inst_16__CF_Inst_n5,
         Inst_SKINNY_Sbox_14_Q294_inst2_Inst_17__CF_Inst_n6,
         Inst_SKINNY_Sbox_14_Q294_inst2_Inst_17__CF_Inst_n5,
         Inst_SKINNY_Sbox_14_Q294_inst2_InstXOR_0__Compression1_n3,
         Inst_SKINNY_Sbox_14_Q294_inst2_InstXOR_0__Compression2_n3,
         Inst_SKINNY_Sbox_14_Q294_inst2_InstXOR_0__Compression3_n3,
         Inst_SKINNY_Sbox_14_Q294_inst2_InstXOR_1__Compression1_n3,
         Inst_SKINNY_Sbox_14_Q294_inst2_InstXOR_1__Compression2_n3,
         Inst_SKINNY_Sbox_14_Q294_inst2_InstXOR_1__Compression3_n3,
         Inst_SKINNY_Sbox_15_n12, Inst_SKINNY_Sbox_15_n11,
         Inst_SKINNY_Sbox_15_n10, Inst_SKINNY_Sbox_15_n9,
         Inst_SKINNY_Sbox_15_Q294_inst1_Inst_0__CF_Inst_n3,
         Inst_SKINNY_Sbox_15_Q294_inst1_Inst_1__CF_Inst_n6,
         Inst_SKINNY_Sbox_15_Q294_inst1_Inst_1__CF_Inst_n5,
         Inst_SKINNY_Sbox_15_Q294_inst1_Inst_2__CF_Inst_n6,
         Inst_SKINNY_Sbox_15_Q294_inst1_Inst_2__CF_Inst_n5,
         Inst_SKINNY_Sbox_15_Q294_inst1_Inst_3__CF_Inst_n3,
         Inst_SKINNY_Sbox_15_Q294_inst1_Inst_4__CF_Inst_n6,
         Inst_SKINNY_Sbox_15_Q294_inst1_Inst_4__CF_Inst_n5,
         Inst_SKINNY_Sbox_15_Q294_inst1_Inst_5__CF_Inst_n6,
         Inst_SKINNY_Sbox_15_Q294_inst1_Inst_5__CF_Inst_n5,
         Inst_SKINNY_Sbox_15_Q294_inst1_Inst_6__CF_Inst_n3,
         Inst_SKINNY_Sbox_15_Q294_inst1_Inst_7__CF_Inst_n6,
         Inst_SKINNY_Sbox_15_Q294_inst1_Inst_7__CF_Inst_n5,
         Inst_SKINNY_Sbox_15_Q294_inst1_Inst_8__CF_Inst_n6,
         Inst_SKINNY_Sbox_15_Q294_inst1_Inst_8__CF_Inst_n5,
         Inst_SKINNY_Sbox_15_Q294_inst1_Inst_9__CF_Inst_n3,
         Inst_SKINNY_Sbox_15_Q294_inst1_Inst_10__CF_Inst_n6,
         Inst_SKINNY_Sbox_15_Q294_inst1_Inst_10__CF_Inst_n5,
         Inst_SKINNY_Sbox_15_Q294_inst1_Inst_11__CF_Inst_n6,
         Inst_SKINNY_Sbox_15_Q294_inst1_Inst_11__CF_Inst_n5,
         Inst_SKINNY_Sbox_15_Q294_inst1_Inst_12__CF_Inst_n3,
         Inst_SKINNY_Sbox_15_Q294_inst1_Inst_13__CF_Inst_n6,
         Inst_SKINNY_Sbox_15_Q294_inst1_Inst_13__CF_Inst_n5,
         Inst_SKINNY_Sbox_15_Q294_inst1_Inst_14__CF_Inst_n6,
         Inst_SKINNY_Sbox_15_Q294_inst1_Inst_14__CF_Inst_n5,
         Inst_SKINNY_Sbox_15_Q294_inst1_Inst_15__CF_Inst_n3,
         Inst_SKINNY_Sbox_15_Q294_inst1_Inst_16__CF_Inst_n6,
         Inst_SKINNY_Sbox_15_Q294_inst1_Inst_16__CF_Inst_n5,
         Inst_SKINNY_Sbox_15_Q294_inst1_Inst_17__CF_Inst_n6,
         Inst_SKINNY_Sbox_15_Q294_inst1_Inst_17__CF_Inst_n5,
         Inst_SKINNY_Sbox_15_Q294_inst1_InstXOR_0__Compression1_n3,
         Inst_SKINNY_Sbox_15_Q294_inst1_InstXOR_0__Compression2_n3,
         Inst_SKINNY_Sbox_15_Q294_inst1_InstXOR_0__Compression3_n3,
         Inst_SKINNY_Sbox_15_Q294_inst1_InstXOR_1__Compression1_n3,
         Inst_SKINNY_Sbox_15_Q294_inst1_InstXOR_1__Compression2_n3,
         Inst_SKINNY_Sbox_15_Q294_inst1_InstXOR_1__Compression3_n3,
         Inst_SKINNY_Sbox_15_Q294_inst2_Inst_0__CF_Inst_n3,
         Inst_SKINNY_Sbox_15_Q294_inst2_Inst_1__CF_Inst_n6,
         Inst_SKINNY_Sbox_15_Q294_inst2_Inst_1__CF_Inst_n5,
         Inst_SKINNY_Sbox_15_Q294_inst2_Inst_2__CF_Inst_n6,
         Inst_SKINNY_Sbox_15_Q294_inst2_Inst_2__CF_Inst_n5,
         Inst_SKINNY_Sbox_15_Q294_inst2_Inst_3__CF_Inst_n3,
         Inst_SKINNY_Sbox_15_Q294_inst2_Inst_4__CF_Inst_n6,
         Inst_SKINNY_Sbox_15_Q294_inst2_Inst_4__CF_Inst_n5,
         Inst_SKINNY_Sbox_15_Q294_inst2_Inst_5__CF_Inst_n6,
         Inst_SKINNY_Sbox_15_Q294_inst2_Inst_5__CF_Inst_n5,
         Inst_SKINNY_Sbox_15_Q294_inst2_Inst_6__CF_Inst_n3,
         Inst_SKINNY_Sbox_15_Q294_inst2_Inst_7__CF_Inst_n6,
         Inst_SKINNY_Sbox_15_Q294_inst2_Inst_7__CF_Inst_n5,
         Inst_SKINNY_Sbox_15_Q294_inst2_Inst_8__CF_Inst_n6,
         Inst_SKINNY_Sbox_15_Q294_inst2_Inst_8__CF_Inst_n5,
         Inst_SKINNY_Sbox_15_Q294_inst2_Inst_9__CF_Inst_n3,
         Inst_SKINNY_Sbox_15_Q294_inst2_Inst_10__CF_Inst_n6,
         Inst_SKINNY_Sbox_15_Q294_inst2_Inst_10__CF_Inst_n5,
         Inst_SKINNY_Sbox_15_Q294_inst2_Inst_11__CF_Inst_n6,
         Inst_SKINNY_Sbox_15_Q294_inst2_Inst_11__CF_Inst_n5,
         Inst_SKINNY_Sbox_15_Q294_inst2_Inst_12__CF_Inst_n3,
         Inst_SKINNY_Sbox_15_Q294_inst2_Inst_13__CF_Inst_n6,
         Inst_SKINNY_Sbox_15_Q294_inst2_Inst_13__CF_Inst_n5,
         Inst_SKINNY_Sbox_15_Q294_inst2_Inst_14__CF_Inst_n6,
         Inst_SKINNY_Sbox_15_Q294_inst2_Inst_14__CF_Inst_n5,
         Inst_SKINNY_Sbox_15_Q294_inst2_Inst_15__CF_Inst_n3,
         Inst_SKINNY_Sbox_15_Q294_inst2_Inst_16__CF_Inst_n6,
         Inst_SKINNY_Sbox_15_Q294_inst2_Inst_16__CF_Inst_n5,
         Inst_SKINNY_Sbox_15_Q294_inst2_Inst_17__CF_Inst_n6,
         Inst_SKINNY_Sbox_15_Q294_inst2_Inst_17__CF_Inst_n5,
         Inst_SKINNY_Sbox_15_Q294_inst2_InstXOR_0__Compression1_n3,
         Inst_SKINNY_Sbox_15_Q294_inst2_InstXOR_0__Compression2_n3,
         Inst_SKINNY_Sbox_15_Q294_inst2_InstXOR_0__Compression3_n3,
         Inst_SKINNY_Sbox_15_Q294_inst2_InstXOR_1__Compression1_n3,
         Inst_SKINNY_Sbox_15_Q294_inst2_InstXOR_1__Compression2_n3,
         Inst_SKINNY_Sbox_15_Q294_inst2_InstXOR_1__Compression3_n3, KE1_RS_n12,
         KE1_RS_n11, KE1_RS_n10, KE1_RS_n9, KE1_RS_n8, KE1_RS_n7,
         KE1_RS_SFF_0_n10, KE1_RS_SFF_0_n9, KE1_RS_SFF_0_n7, KE1_RS_SFF_0_n6,
         KE1_RS_SFF_1_n11, KE1_RS_SFF_1_n10, KE1_RS_SFF_1_n8, KE1_RS_SFF_1_n7,
         KE1_RS_SFF_2_n11, KE1_RS_SFF_2_n10, KE1_RS_SFF_2_n8, KE1_RS_SFF_2_n7,
         KE1_RS_SFF_3_n10, KE1_RS_SFF_3_n9, KE1_RS_SFF_3_n7, KE1_RS_SFF_3_n6,
         KE1_RS_SFF_4_n10, KE1_RS_SFF_4_n9, KE1_RS_SFF_4_n7, KE1_RS_SFF_4_n6,
         KE1_RS_SFF_5_n10, KE1_RS_SFF_5_n9, KE1_RS_SFF_5_n7, KE1_RS_SFF_5_n6,
         KE1_RS_SFF_6_n10, KE1_RS_SFF_6_n9, KE1_RS_SFF_6_n7, KE1_RS_SFF_6_n6,
         KE1_RS_SFF_7_n10, KE1_RS_SFF_7_n9, KE1_RS_SFF_7_n7, KE1_RS_SFF_7_n6,
         KE1_RS_SFF_8_n10, KE1_RS_SFF_8_n9, KE1_RS_SFF_8_n7, KE1_RS_SFF_8_n6,
         KE1_RS_SFF_9_n10, KE1_RS_SFF_9_n9, KE1_RS_SFF_9_n7, KE1_RS_SFF_9_n6,
         KE1_RS_SFF_10_n10, KE1_RS_SFF_10_n9, KE1_RS_SFF_10_n7,
         KE1_RS_SFF_10_n6, KE1_RS_SFF_11_n10, KE1_RS_SFF_11_n9,
         KE1_RS_SFF_11_n7, KE1_RS_SFF_11_n6, KE1_RS_SFF_12_n10,
         KE1_RS_SFF_12_n9, KE1_RS_SFF_12_n7, KE1_RS_SFF_12_n6,
         KE1_RS_SFF_13_n11, KE1_RS_SFF_13_n10, KE1_RS_SFF_13_n8,
         KE1_RS_SFF_13_n7, KE1_RS_SFF_14_n11, KE1_RS_SFF_14_n10,
         KE1_RS_SFF_14_n8, KE1_RS_SFF_14_n7, KE1_RS_SFF_15_n10,
         KE1_RS_SFF_15_n9, KE1_RS_SFF_15_n7, KE1_RS_SFF_15_n6,
         KE1_RS_SFF_16_n10, KE1_RS_SFF_16_n9, KE1_RS_SFF_16_n7,
         KE1_RS_SFF_16_n6, KE1_RS_SFF_17_n10, KE1_RS_SFF_17_n9,
         KE1_RS_SFF_17_n7, KE1_RS_SFF_17_n6, KE1_RS_SFF_18_n10,
         KE1_RS_SFF_18_n9, KE1_RS_SFF_18_n7, KE1_RS_SFF_18_n6,
         KE1_RS_SFF_19_n10, KE1_RS_SFF_19_n9, KE1_RS_SFF_19_n7,
         KE1_RS_SFF_19_n6, KE1_RS_SFF_20_n10, KE1_RS_SFF_20_n9,
         KE1_RS_SFF_20_n7, KE1_RS_SFF_20_n6, KE1_RS_SFF_21_n10,
         KE1_RS_SFF_21_n9, KE1_RS_SFF_21_n7, KE1_RS_SFF_21_n6,
         KE1_RS_SFF_22_n10, KE1_RS_SFF_22_n9, KE1_RS_SFF_22_n7,
         KE1_RS_SFF_22_n6, KE1_RS_SFF_23_n10, KE1_RS_SFF_23_n9,
         KE1_RS_SFF_23_n7, KE1_RS_SFF_23_n6, KE1_RS_SFF_24_n10,
         KE1_RS_SFF_24_n9, KE1_RS_SFF_24_n7, KE1_RS_SFF_24_n6,
         KE1_RS_SFF_25_n11, KE1_RS_SFF_25_n10, KE1_RS_SFF_25_n8,
         KE1_RS_SFF_25_n7, KE1_RS_SFF_26_n11, KE1_RS_SFF_26_n10,
         KE1_RS_SFF_26_n8, KE1_RS_SFF_26_n7, KE1_RS_SFF_27_n10,
         KE1_RS_SFF_27_n9, KE1_RS_SFF_27_n7, KE1_RS_SFF_27_n6,
         KE1_RS_SFF_28_n10, KE1_RS_SFF_28_n9, KE1_RS_SFF_28_n7,
         KE1_RS_SFF_28_n6, KE1_RS_SFF_29_n10, KE1_RS_SFF_29_n9,
         KE1_RS_SFF_29_n7, KE1_RS_SFF_29_n6, KE1_RS_SFF_30_n10,
         KE1_RS_SFF_30_n9, KE1_RS_SFF_30_n7, KE1_RS_SFF_30_n6,
         KE1_RS_SFF_31_n10, KE1_RS_SFF_31_n9, KE1_RS_SFF_31_n7,
         KE1_RS_SFF_31_n6, KE1_RS_SFF_32_n10, KE1_RS_SFF_32_n9,
         KE1_RS_SFF_32_n7, KE1_RS_SFF_32_n6, KE1_RS_SFF_33_n10,
         KE1_RS_SFF_33_n9, KE1_RS_SFF_33_n7, KE1_RS_SFF_33_n6,
         KE1_RS_SFF_34_n10, KE1_RS_SFF_34_n9, KE1_RS_SFF_34_n7,
         KE1_RS_SFF_34_n6, KE1_RS_SFF_35_n10, KE1_RS_SFF_35_n9,
         KE1_RS_SFF_35_n7, KE1_RS_SFF_35_n6, KE1_RS_SFF_36_n10,
         KE1_RS_SFF_36_n9, KE1_RS_SFF_36_n7, KE1_RS_SFF_36_n6,
         KE1_RS_SFF_37_n11, KE1_RS_SFF_37_n10, KE1_RS_SFF_37_n8,
         KE1_RS_SFF_37_n7, KE1_RS_SFF_38_n11, KE1_RS_SFF_38_n10,
         KE1_RS_SFF_38_n8, KE1_RS_SFF_38_n7, KE1_RS_SFF_39_n10,
         KE1_RS_SFF_39_n9, KE1_RS_SFF_39_n7, KE1_RS_SFF_39_n6,
         KE1_RS_SFF_40_n10, KE1_RS_SFF_40_n9, KE1_RS_SFF_40_n7,
         KE1_RS_SFF_40_n6, KE1_RS_SFF_41_n10, KE1_RS_SFF_41_n9,
         KE1_RS_SFF_41_n7, KE1_RS_SFF_41_n6, KE1_RS_SFF_42_n10,
         KE1_RS_SFF_42_n9, KE1_RS_SFF_42_n7, KE1_RS_SFF_42_n6,
         KE1_RS_SFF_43_n10, KE1_RS_SFF_43_n9, KE1_RS_SFF_43_n7,
         KE1_RS_SFF_43_n6, KE1_RS_SFF_44_n10, KE1_RS_SFF_44_n9,
         KE1_RS_SFF_44_n7, KE1_RS_SFF_44_n6, KE1_RS_SFF_45_n10,
         KE1_RS_SFF_45_n9, KE1_RS_SFF_45_n7, KE1_RS_SFF_45_n6,
         KE1_RS_SFF_46_n10, KE1_RS_SFF_46_n9, KE1_RS_SFF_46_n7,
         KE1_RS_SFF_46_n6, KE1_RS_SFF_47_n10, KE1_RS_SFF_47_n9,
         KE1_RS_SFF_47_n7, KE1_RS_SFF_47_n6, KE1_RS_SFF_48_n10,
         KE1_RS_SFF_48_n9, KE1_RS_SFF_48_n7, KE1_RS_SFF_48_n6,
         KE1_RS_SFF_49_n11, KE1_RS_SFF_49_n10, KE1_RS_SFF_49_n8,
         KE1_RS_SFF_49_n7, KE1_RS_SFF_50_n11, KE1_RS_SFF_50_n10,
         KE1_RS_SFF_50_n8, KE1_RS_SFF_50_n7, KE1_RS_SFF_51_n10,
         KE1_RS_SFF_51_n9, KE1_RS_SFF_51_n7, KE1_RS_SFF_51_n6,
         KE1_RS_SFF_52_n10, KE1_RS_SFF_52_n9, KE1_RS_SFF_52_n7,
         KE1_RS_SFF_52_n6, KE1_RS_SFF_53_n10, KE1_RS_SFF_53_n9,
         KE1_RS_SFF_53_n7, KE1_RS_SFF_53_n6, KE1_RS_SFF_54_n10,
         KE1_RS_SFF_54_n9, KE1_RS_SFF_54_n7, KE1_RS_SFF_54_n6,
         KE1_RS_SFF_55_n10, KE1_RS_SFF_55_n9, KE1_RS_SFF_55_n7,
         KE1_RS_SFF_55_n6, KE1_RS_SFF_56_n10, KE1_RS_SFF_56_n9,
         KE1_RS_SFF_56_n7, KE1_RS_SFF_56_n6, KE1_RS_SFF_57_n10,
         KE1_RS_SFF_57_n9, KE1_RS_SFF_57_n7, KE1_RS_SFF_57_n6,
         KE1_RS_SFF_58_n10, KE1_RS_SFF_58_n9, KE1_RS_SFF_58_n7,
         KE1_RS_SFF_58_n6, KE1_RS_SFF_59_n10, KE1_RS_SFF_59_n9,
         KE1_RS_SFF_59_n7, KE1_RS_SFF_59_n6, KE1_RS_SFF_60_n10,
         KE1_RS_SFF_60_n9, KE1_RS_SFF_60_n7, KE1_RS_SFF_60_n6,
         KE1_RS_SFF_61_n10, KE1_RS_SFF_61_n9, KE1_RS_SFF_61_n7,
         KE1_RS_SFF_61_n6, KE1_RS_SFF_62_n10, KE1_RS_SFF_62_n9,
         KE1_RS_SFF_62_n7, KE1_RS_SFF_62_n6, KE1_RS_SFF_63_n10,
         KE1_RS_SFF_63_n9, KE1_RS_SFF_63_n7, KE1_RS_SFF_63_n6, KE2_RS_n11,
         KE2_RS_n10, KE2_RS_n9, KE2_RS_n8, KE2_RS_n7, KE2_RS_n6,
         KE2_RS_SFF_0_n11, KE2_RS_SFF_0_n10, KE2_RS_SFF_0_n8, KE2_RS_SFF_0_n7,
         KE2_RS_SFF_1_n11, KE2_RS_SFF_1_n10, KE2_RS_SFF_1_n8, KE2_RS_SFF_1_n7,
         KE2_RS_SFF_2_n10, KE2_RS_SFF_2_n9, KE2_RS_SFF_2_n7, KE2_RS_SFF_2_n6,
         KE2_RS_SFF_3_n10, KE2_RS_SFF_3_n9, KE2_RS_SFF_3_n7, KE2_RS_SFF_3_n6,
         KE2_RS_SFF_4_n10, KE2_RS_SFF_4_n9, KE2_RS_SFF_4_n7, KE2_RS_SFF_4_n6,
         KE2_RS_SFF_5_n10, KE2_RS_SFF_5_n9, KE2_RS_SFF_5_n7, KE2_RS_SFF_5_n6,
         KE2_RS_SFF_6_n10, KE2_RS_SFF_6_n9, KE2_RS_SFF_6_n7, KE2_RS_SFF_6_n6,
         KE2_RS_SFF_7_n10, KE2_RS_SFF_7_n9, KE2_RS_SFF_7_n7, KE2_RS_SFF_7_n6,
         KE2_RS_SFF_8_n10, KE2_RS_SFF_8_n9, KE2_RS_SFF_8_n7, KE2_RS_SFF_8_n6,
         KE2_RS_SFF_9_n10, KE2_RS_SFF_9_n9, KE2_RS_SFF_9_n7, KE2_RS_SFF_9_n6,
         KE2_RS_SFF_10_n10, KE2_RS_SFF_10_n9, KE2_RS_SFF_10_n7,
         KE2_RS_SFF_10_n6, KE2_RS_SFF_11_n10, KE2_RS_SFF_11_n9,
         KE2_RS_SFF_11_n7, KE2_RS_SFF_11_n6, KE2_RS_SFF_12_n11,
         KE2_RS_SFF_12_n10, KE2_RS_SFF_12_n8, KE2_RS_SFF_12_n7,
         KE2_RS_SFF_13_n11, KE2_RS_SFF_13_n10, KE2_RS_SFF_13_n8,
         KE2_RS_SFF_13_n7, KE2_RS_SFF_14_n10, KE2_RS_SFF_14_n9,
         KE2_RS_SFF_14_n7, KE2_RS_SFF_14_n6, KE2_RS_SFF_15_n10,
         KE2_RS_SFF_15_n9, KE2_RS_SFF_15_n7, KE2_RS_SFF_15_n6,
         KE2_RS_SFF_16_n10, KE2_RS_SFF_16_n9, KE2_RS_SFF_16_n7,
         KE2_RS_SFF_16_n6, KE2_RS_SFF_17_n10, KE2_RS_SFF_17_n9,
         KE2_RS_SFF_17_n7, KE2_RS_SFF_17_n6, KE2_RS_SFF_18_n10,
         KE2_RS_SFF_18_n9, KE2_RS_SFF_18_n7, KE2_RS_SFF_18_n6,
         KE2_RS_SFF_19_n10, KE2_RS_SFF_19_n9, KE2_RS_SFF_19_n7,
         KE2_RS_SFF_19_n6, KE2_RS_SFF_20_n10, KE2_RS_SFF_20_n9,
         KE2_RS_SFF_20_n7, KE2_RS_SFF_20_n6, KE2_RS_SFF_21_n10,
         KE2_RS_SFF_21_n9, KE2_RS_SFF_21_n7, KE2_RS_SFF_21_n6,
         KE2_RS_SFF_22_n10, KE2_RS_SFF_22_n9, KE2_RS_SFF_22_n7,
         KE2_RS_SFF_22_n6, KE2_RS_SFF_23_n10, KE2_RS_SFF_23_n9,
         KE2_RS_SFF_23_n7, KE2_RS_SFF_23_n6, KE2_RS_SFF_24_n11,
         KE2_RS_SFF_24_n10, KE2_RS_SFF_24_n8, KE2_RS_SFF_24_n7,
         KE2_RS_SFF_25_n11, KE2_RS_SFF_25_n10, KE2_RS_SFF_25_n8,
         KE2_RS_SFF_25_n7, KE2_RS_SFF_26_n10, KE2_RS_SFF_26_n9,
         KE2_RS_SFF_26_n7, KE2_RS_SFF_26_n6, KE2_RS_SFF_27_n10,
         KE2_RS_SFF_27_n9, KE2_RS_SFF_27_n7, KE2_RS_SFF_27_n6,
         KE2_RS_SFF_28_n10, KE2_RS_SFF_28_n9, KE2_RS_SFF_28_n7,
         KE2_RS_SFF_28_n6, KE2_RS_SFF_29_n10, KE2_RS_SFF_29_n9,
         KE2_RS_SFF_29_n7, KE2_RS_SFF_29_n6, KE2_RS_SFF_30_n10,
         KE2_RS_SFF_30_n9, KE2_RS_SFF_30_n7, KE2_RS_SFF_30_n6,
         KE2_RS_SFF_31_n10, KE2_RS_SFF_31_n9, KE2_RS_SFF_31_n7,
         KE2_RS_SFF_31_n6, KE2_RS_SFF_32_n10, KE2_RS_SFF_32_n9,
         KE2_RS_SFF_32_n7, KE2_RS_SFF_32_n6, KE2_RS_SFF_33_n10,
         KE2_RS_SFF_33_n9, KE2_RS_SFF_33_n7, KE2_RS_SFF_33_n6,
         KE2_RS_SFF_34_n10, KE2_RS_SFF_34_n9, KE2_RS_SFF_34_n7,
         KE2_RS_SFF_34_n6, KE2_RS_SFF_35_n10, KE2_RS_SFF_35_n9,
         KE2_RS_SFF_35_n7, KE2_RS_SFF_35_n6, KE2_RS_SFF_36_n11,
         KE2_RS_SFF_36_n10, KE2_RS_SFF_36_n8, KE2_RS_SFF_36_n7,
         KE2_RS_SFF_37_n11, KE2_RS_SFF_37_n10, KE2_RS_SFF_37_n8,
         KE2_RS_SFF_37_n7, KE2_RS_SFF_38_n10, KE2_RS_SFF_38_n9,
         KE2_RS_SFF_38_n7, KE2_RS_SFF_38_n6, KE2_RS_SFF_39_n10,
         KE2_RS_SFF_39_n9, KE2_RS_SFF_39_n7, KE2_RS_SFF_39_n6,
         KE2_RS_SFF_40_n10, KE2_RS_SFF_40_n9, KE2_RS_SFF_40_n7,
         KE2_RS_SFF_40_n6, KE2_RS_SFF_41_n10, KE2_RS_SFF_41_n9,
         KE2_RS_SFF_41_n7, KE2_RS_SFF_41_n6, KE2_RS_SFF_42_n10,
         KE2_RS_SFF_42_n9, KE2_RS_SFF_42_n7, KE2_RS_SFF_42_n6,
         KE2_RS_SFF_43_n10, KE2_RS_SFF_43_n9, KE2_RS_SFF_43_n7,
         KE2_RS_SFF_43_n6, KE2_RS_SFF_44_n10, KE2_RS_SFF_44_n9,
         KE2_RS_SFF_44_n7, KE2_RS_SFF_44_n6, KE2_RS_SFF_45_n10,
         KE2_RS_SFF_45_n9, KE2_RS_SFF_45_n7, KE2_RS_SFF_45_n6,
         KE2_RS_SFF_46_n10, KE2_RS_SFF_46_n9, KE2_RS_SFF_46_n7,
         KE2_RS_SFF_46_n6, KE2_RS_SFF_47_n10, KE2_RS_SFF_47_n9,
         KE2_RS_SFF_47_n7, KE2_RS_SFF_47_n6, KE2_RS_SFF_48_n10,
         KE2_RS_SFF_48_n9, KE2_RS_SFF_48_n7, KE2_RS_SFF_48_n6,
         KE2_RS_SFF_49_n10, KE2_RS_SFF_49_n9, KE2_RS_SFF_49_n7,
         KE2_RS_SFF_49_n6, KE2_RS_SFF_50_n10, KE2_RS_SFF_50_n9,
         KE2_RS_SFF_50_n7, KE2_RS_SFF_50_n6, KE2_RS_SFF_51_n10,
         KE2_RS_SFF_51_n9, KE2_RS_SFF_51_n7, KE2_RS_SFF_51_n6,
         KE2_RS_SFF_52_n10, KE2_RS_SFF_52_n9, KE2_RS_SFF_52_n7,
         KE2_RS_SFF_52_n6, KE2_RS_SFF_53_n10, KE2_RS_SFF_53_n9,
         KE2_RS_SFF_53_n7, KE2_RS_SFF_53_n6, KE2_RS_SFF_54_n10,
         KE2_RS_SFF_54_n9, KE2_RS_SFF_54_n7, KE2_RS_SFF_54_n6,
         KE2_RS_SFF_55_n10, KE2_RS_SFF_55_n9, KE2_RS_SFF_55_n7,
         KE2_RS_SFF_55_n6, KE2_RS_SFF_56_n10, KE2_RS_SFF_56_n9,
         KE2_RS_SFF_56_n7, KE2_RS_SFF_56_n6, KE2_RS_SFF_57_n10,
         KE2_RS_SFF_57_n9, KE2_RS_SFF_57_n7, KE2_RS_SFF_57_n6,
         KE2_RS_SFF_58_n10, KE2_RS_SFF_58_n9, KE2_RS_SFF_58_n7,
         KE2_RS_SFF_58_n6, KE2_RS_SFF_59_n10, KE2_RS_SFF_59_n9,
         KE2_RS_SFF_59_n7, KE2_RS_SFF_59_n6, KE2_RS_SFF_60_n10,
         KE2_RS_SFF_60_n9, KE2_RS_SFF_60_n7, KE2_RS_SFF_60_n6,
         KE2_RS_SFF_61_n10, KE2_RS_SFF_61_n9, KE2_RS_SFF_61_n7,
         KE2_RS_SFF_61_n6, KE2_RS_SFF_62_n10, KE2_RS_SFF_62_n9,
         KE2_RS_SFF_62_n7, KE2_RS_SFF_62_n6, KE2_RS_SFF_63_n10,
         KE2_RS_SFF_63_n9, KE2_RS_SFF_63_n7, KE2_RS_SFF_63_n6, KE3_RS_n12,
         KE3_RS_n11, KE3_RS_n10, KE3_RS_n9, KE3_RS_n8, KE3_RS_n7,
         KE3_RS_SFF_0_n11, KE3_RS_SFF_0_n10, KE3_RS_SFF_0_n8, KE3_RS_SFF_0_n7,
         KE3_RS_SFF_1_n11, KE3_RS_SFF_1_n10, KE3_RS_SFF_1_n8, KE3_RS_SFF_1_n7,
         KE3_RS_SFF_2_n10, KE3_RS_SFF_2_n9, KE3_RS_SFF_2_n7, KE3_RS_SFF_2_n6,
         KE3_RS_SFF_3_n10, KE3_RS_SFF_3_n9, KE3_RS_SFF_3_n7, KE3_RS_SFF_3_n6,
         KE3_RS_SFF_4_n10, KE3_RS_SFF_4_n9, KE3_RS_SFF_4_n7, KE3_RS_SFF_4_n6,
         KE3_RS_SFF_5_n10, KE3_RS_SFF_5_n9, KE3_RS_SFF_5_n7, KE3_RS_SFF_5_n6,
         KE3_RS_SFF_6_n10, KE3_RS_SFF_6_n9, KE3_RS_SFF_6_n7, KE3_RS_SFF_6_n6,
         KE3_RS_SFF_7_n10, KE3_RS_SFF_7_n9, KE3_RS_SFF_7_n7, KE3_RS_SFF_7_n6,
         KE3_RS_SFF_8_n10, KE3_RS_SFF_8_n9, KE3_RS_SFF_8_n7, KE3_RS_SFF_8_n6,
         KE3_RS_SFF_9_n10, KE3_RS_SFF_9_n9, KE3_RS_SFF_9_n7, KE3_RS_SFF_9_n6,
         KE3_RS_SFF_10_n10, KE3_RS_SFF_10_n9, KE3_RS_SFF_10_n7,
         KE3_RS_SFF_10_n6, KE3_RS_SFF_11_n10, KE3_RS_SFF_11_n9,
         KE3_RS_SFF_11_n7, KE3_RS_SFF_11_n6, KE3_RS_SFF_12_n11,
         KE3_RS_SFF_12_n10, KE3_RS_SFF_12_n8, KE3_RS_SFF_12_n7,
         KE3_RS_SFF_13_n11, KE3_RS_SFF_13_n10, KE3_RS_SFF_13_n8,
         KE3_RS_SFF_13_n7, KE3_RS_SFF_14_n10, KE3_RS_SFF_14_n9,
         KE3_RS_SFF_14_n7, KE3_RS_SFF_14_n6, KE3_RS_SFF_15_n10,
         KE3_RS_SFF_15_n9, KE3_RS_SFF_15_n7, KE3_RS_SFF_15_n6,
         KE3_RS_SFF_16_n10, KE3_RS_SFF_16_n9, KE3_RS_SFF_16_n7,
         KE3_RS_SFF_16_n6, KE3_RS_SFF_17_n10, KE3_RS_SFF_17_n9,
         KE3_RS_SFF_17_n7, KE3_RS_SFF_17_n6, KE3_RS_SFF_18_n10,
         KE3_RS_SFF_18_n9, KE3_RS_SFF_18_n7, KE3_RS_SFF_18_n6,
         KE3_RS_SFF_19_n10, KE3_RS_SFF_19_n9, KE3_RS_SFF_19_n7,
         KE3_RS_SFF_19_n6, KE3_RS_SFF_20_n10, KE3_RS_SFF_20_n9,
         KE3_RS_SFF_20_n7, KE3_RS_SFF_20_n6, KE3_RS_SFF_21_n10,
         KE3_RS_SFF_21_n9, KE3_RS_SFF_21_n7, KE3_RS_SFF_21_n6,
         KE3_RS_SFF_22_n10, KE3_RS_SFF_22_n9, KE3_RS_SFF_22_n7,
         KE3_RS_SFF_22_n6, KE3_RS_SFF_23_n10, KE3_RS_SFF_23_n9,
         KE3_RS_SFF_23_n7, KE3_RS_SFF_23_n6, KE3_RS_SFF_24_n11,
         KE3_RS_SFF_24_n10, KE3_RS_SFF_24_n8, KE3_RS_SFF_24_n7,
         KE3_RS_SFF_25_n11, KE3_RS_SFF_25_n10, KE3_RS_SFF_25_n8,
         KE3_RS_SFF_25_n7, KE3_RS_SFF_26_n10, KE3_RS_SFF_26_n9,
         KE3_RS_SFF_26_n7, KE3_RS_SFF_26_n6, KE3_RS_SFF_27_n10,
         KE3_RS_SFF_27_n9, KE3_RS_SFF_27_n7, KE3_RS_SFF_27_n6,
         KE3_RS_SFF_28_n10, KE3_RS_SFF_28_n9, KE3_RS_SFF_28_n7,
         KE3_RS_SFF_28_n6, KE3_RS_SFF_29_n10, KE3_RS_SFF_29_n9,
         KE3_RS_SFF_29_n7, KE3_RS_SFF_29_n6, KE3_RS_SFF_30_n10,
         KE3_RS_SFF_30_n9, KE3_RS_SFF_30_n7, KE3_RS_SFF_30_n6,
         KE3_RS_SFF_31_n10, KE3_RS_SFF_31_n9, KE3_RS_SFF_31_n7,
         KE3_RS_SFF_31_n6, KE3_RS_SFF_32_n10, KE3_RS_SFF_32_n9,
         KE3_RS_SFF_32_n7, KE3_RS_SFF_32_n6, KE3_RS_SFF_33_n10,
         KE3_RS_SFF_33_n9, KE3_RS_SFF_33_n7, KE3_RS_SFF_33_n6,
         KE3_RS_SFF_34_n10, KE3_RS_SFF_34_n9, KE3_RS_SFF_34_n7,
         KE3_RS_SFF_34_n6, KE3_RS_SFF_35_n10, KE3_RS_SFF_35_n9,
         KE3_RS_SFF_35_n7, KE3_RS_SFF_35_n6, KE3_RS_SFF_36_n11,
         KE3_RS_SFF_36_n10, KE3_RS_SFF_36_n8, KE3_RS_SFF_36_n7,
         KE3_RS_SFF_37_n11, KE3_RS_SFF_37_n10, KE3_RS_SFF_37_n8,
         KE3_RS_SFF_37_n7, KE3_RS_SFF_38_n10, KE3_RS_SFF_38_n9,
         KE3_RS_SFF_38_n7, KE3_RS_SFF_38_n6, KE3_RS_SFF_39_n10,
         KE3_RS_SFF_39_n9, KE3_RS_SFF_39_n7, KE3_RS_SFF_39_n6,
         KE3_RS_SFF_40_n10, KE3_RS_SFF_40_n9, KE3_RS_SFF_40_n7,
         KE3_RS_SFF_40_n6, KE3_RS_SFF_41_n10, KE3_RS_SFF_41_n9,
         KE3_RS_SFF_41_n7, KE3_RS_SFF_41_n6, KE3_RS_SFF_42_n10,
         KE3_RS_SFF_42_n9, KE3_RS_SFF_42_n7, KE3_RS_SFF_42_n6,
         KE3_RS_SFF_43_n10, KE3_RS_SFF_43_n9, KE3_RS_SFF_43_n7,
         KE3_RS_SFF_43_n6, KE3_RS_SFF_44_n10, KE3_RS_SFF_44_n9,
         KE3_RS_SFF_44_n7, KE3_RS_SFF_44_n6, KE3_RS_SFF_45_n10,
         KE3_RS_SFF_45_n9, KE3_RS_SFF_45_n7, KE3_RS_SFF_45_n6,
         KE3_RS_SFF_46_n10, KE3_RS_SFF_46_n9, KE3_RS_SFF_46_n7,
         KE3_RS_SFF_46_n6, KE3_RS_SFF_47_n10, KE3_RS_SFF_47_n9,
         KE3_RS_SFF_47_n7, KE3_RS_SFF_47_n6, KE3_RS_SFF_48_n11,
         KE3_RS_SFF_48_n10, KE3_RS_SFF_48_n8, KE3_RS_SFF_48_n7,
         KE3_RS_SFF_49_n11, KE3_RS_SFF_49_n10, KE3_RS_SFF_49_n8,
         KE3_RS_SFF_49_n7, KE3_RS_SFF_50_n10, KE3_RS_SFF_50_n9,
         KE3_RS_SFF_50_n7, KE3_RS_SFF_50_n6, KE3_RS_SFF_51_n10,
         KE3_RS_SFF_51_n9, KE3_RS_SFF_51_n7, KE3_RS_SFF_51_n6,
         KE3_RS_SFF_52_n10, KE3_RS_SFF_52_n9, KE3_RS_SFF_52_n7,
         KE3_RS_SFF_52_n6, KE3_RS_SFF_53_n10, KE3_RS_SFF_53_n9,
         KE3_RS_SFF_53_n7, KE3_RS_SFF_53_n6, KE3_RS_SFF_54_n10,
         KE3_RS_SFF_54_n9, KE3_RS_SFF_54_n7, KE3_RS_SFF_54_n6,
         KE3_RS_SFF_55_n10, KE3_RS_SFF_55_n9, KE3_RS_SFF_55_n7,
         KE3_RS_SFF_55_n6, KE3_RS_SFF_56_n10, KE3_RS_SFF_56_n9,
         KE3_RS_SFF_56_n7, KE3_RS_SFF_56_n6, KE3_RS_SFF_57_n10,
         KE3_RS_SFF_57_n9, KE3_RS_SFF_57_n7, KE3_RS_SFF_57_n6,
         KE3_RS_SFF_58_n10, KE3_RS_SFF_58_n9, KE3_RS_SFF_58_n7,
         KE3_RS_SFF_58_n6, KE3_RS_SFF_59_n10, KE3_RS_SFF_59_n9,
         KE3_RS_SFF_59_n7, KE3_RS_SFF_59_n6, KE3_RS_SFF_60_n10,
         KE3_RS_SFF_60_n9, KE3_RS_SFF_60_n7, KE3_RS_SFF_60_n6,
         KE3_RS_SFF_61_n10, KE3_RS_SFF_61_n9, KE3_RS_SFF_61_n7,
         KE3_RS_SFF_61_n6, KE3_RS_SFF_62_n10, KE3_RS_SFF_62_n9,
         KE3_RS_SFF_62_n7, KE3_RS_SFF_62_n6, KE3_RS_SFF_63_n10,
         KE3_RS_SFF_63_n9, KE3_RS_SFF_63_n7, KE3_RS_SFF_63_n6, CL_n14, CL_n13,
         CL_n12, CL_n11, CL_n10, CL_n30, CL_n29, CL_n28, CL_n27, CL_n25,
         CL_n24, CL_n23, CL_n20, CL_n19, CL_n18, CL_n17, CL_n16, CL_n15, CL_n3,
         CL_n2, CL_n1, CL_n22, CL_n21, CL_n9;
  wire   [5:0] ROUND_CST;
  wire   [63:0] SUB_IN1;
  wire   [63:29] SUB_OUT1;
  wire   [63:29] SUB_OUT2;
  wire   [63:29] SUB_OUT3;
  wire   [47:0] RF1_SHIFTROWS;
  wire   [47:0] RF2_SHIFTROWS;
  wire   [47:0] RF3_SHIFTROWS;
  wire   [3:0] Inst_SKINNY_Sbox_0_OutAff_out3;
  wire   [3:0] Inst_SKINNY_Sbox_0_OutAff_out2;
  wire   [3:0] Inst_SKINNY_Sbox_0_OutAff_out1;
  wire   [3:0] Inst_SKINNY_Sbox_0_Q294_2_out1;
  wire   [3:0] Inst_SKINNY_Sbox_0_M2_out3;
  wire   [3:0] Inst_SKINNY_Sbox_0_M2_out3_reg;
  wire   [3:0] Inst_SKINNY_Sbox_0_M2_out2;
  wire   [3:0] Inst_SKINNY_Sbox_0_M2_out2_reg;
  wire   [3:0] Inst_SKINNY_Sbox_0_M2_out1;
  wire   [3:0] Inst_SKINNY_Sbox_0_M2_out1_reg;
  wire   [3:0] Inst_SKINNY_Sbox_0_InAff_out3_reg;
  wire   [3:0] Inst_SKINNY_Sbox_0_InAff_out2_reg;
  wire   [3:0] Inst_SKINNY_Sbox_0_InAff_out1_reg;
  wire   [3:0] Inst_SKINNY_Sbox_0_InAff_out3;
  wire   [3:0] Inst_SKINNY_Sbox_0_InAff_out2;
  wire   [3:0] Inst_SKINNY_Sbox_0_InAff_out1;
  wire   [17:0] Inst_SKINNY_Sbox_0_Q294_inst1_CF_Reg;
  wire   [17:0] Inst_SKINNY_Sbox_0_Q294_inst1_CF_Out;
  wire   [17:0] Inst_SKINNY_Sbox_0_Q294_inst2_CF_Reg;
  wire   [17:0] Inst_SKINNY_Sbox_0_Q294_inst2_CF_Out;
  wire   [3:0] Inst_SKINNY_Sbox_1_OutAff_out3;
  wire   [3:0] Inst_SKINNY_Sbox_1_OutAff_out2;
  wire   [3:0] Inst_SKINNY_Sbox_1_OutAff_out1;
  wire   [3:0] Inst_SKINNY_Sbox_1_Q294_2_out1;
  wire   [3:0] Inst_SKINNY_Sbox_1_M2_out3;
  wire   [3:0] Inst_SKINNY_Sbox_1_M2_out3_reg;
  wire   [3:0] Inst_SKINNY_Sbox_1_M2_out2;
  wire   [3:0] Inst_SKINNY_Sbox_1_M2_out2_reg;
  wire   [3:0] Inst_SKINNY_Sbox_1_M2_out1;
  wire   [3:0] Inst_SKINNY_Sbox_1_M2_out1_reg;
  wire   [3:0] Inst_SKINNY_Sbox_1_InAff_out3_reg;
  wire   [3:0] Inst_SKINNY_Sbox_1_InAff_out2_reg;
  wire   [3:0] Inst_SKINNY_Sbox_1_InAff_out1_reg;
  wire   [3:0] Inst_SKINNY_Sbox_1_InAff_out3;
  wire   [3:0] Inst_SKINNY_Sbox_1_InAff_out2;
  wire   [3:0] Inst_SKINNY_Sbox_1_InAff_out1;
  wire   [17:0] Inst_SKINNY_Sbox_1_Q294_inst1_CF_Reg;
  wire   [17:0] Inst_SKINNY_Sbox_1_Q294_inst1_CF_Out;
  wire   [17:0] Inst_SKINNY_Sbox_1_Q294_inst2_CF_Reg;
  wire   [17:0] Inst_SKINNY_Sbox_1_Q294_inst2_CF_Out;
  wire   [3:0] Inst_SKINNY_Sbox_2_OutAff_out3;
  wire   [3:0] Inst_SKINNY_Sbox_2_OutAff_out2;
  wire   [3:0] Inst_SKINNY_Sbox_2_OutAff_out1;
  wire   [3:0] Inst_SKINNY_Sbox_2_Q294_2_out1;
  wire   [3:0] Inst_SKINNY_Sbox_2_M2_out3;
  wire   [3:0] Inst_SKINNY_Sbox_2_M2_out3_reg;
  wire   [3:0] Inst_SKINNY_Sbox_2_M2_out2;
  wire   [3:0] Inst_SKINNY_Sbox_2_M2_out2_reg;
  wire   [3:0] Inst_SKINNY_Sbox_2_M2_out1;
  wire   [3:0] Inst_SKINNY_Sbox_2_M2_out1_reg;
  wire   [3:0] Inst_SKINNY_Sbox_2_InAff_out3_reg;
  wire   [3:0] Inst_SKINNY_Sbox_2_InAff_out2_reg;
  wire   [3:0] Inst_SKINNY_Sbox_2_InAff_out1_reg;
  wire   [3:0] Inst_SKINNY_Sbox_2_InAff_out3;
  wire   [3:0] Inst_SKINNY_Sbox_2_InAff_out2;
  wire   [3:0] Inst_SKINNY_Sbox_2_InAff_out1;
  wire   [17:0] Inst_SKINNY_Sbox_2_Q294_inst1_CF_Reg;
  wire   [17:0] Inst_SKINNY_Sbox_2_Q294_inst1_CF_Out;
  wire   [17:0] Inst_SKINNY_Sbox_2_Q294_inst2_CF_Reg;
  wire   [17:0] Inst_SKINNY_Sbox_2_Q294_inst2_CF_Out;
  wire   [3:0] Inst_SKINNY_Sbox_3_OutAff_out3;
  wire   [3:0] Inst_SKINNY_Sbox_3_OutAff_out2;
  wire   [3:0] Inst_SKINNY_Sbox_3_OutAff_out1;
  wire   [3:0] Inst_SKINNY_Sbox_3_Q294_2_out1;
  wire   [3:0] Inst_SKINNY_Sbox_3_M2_out3;
  wire   [3:0] Inst_SKINNY_Sbox_3_M2_out3_reg;
  wire   [3:0] Inst_SKINNY_Sbox_3_M2_out2;
  wire   [3:0] Inst_SKINNY_Sbox_3_M2_out2_reg;
  wire   [3:0] Inst_SKINNY_Sbox_3_M2_out1;
  wire   [3:0] Inst_SKINNY_Sbox_3_M2_out1_reg;
  wire   [3:0] Inst_SKINNY_Sbox_3_InAff_out3_reg;
  wire   [3:0] Inst_SKINNY_Sbox_3_InAff_out2_reg;
  wire   [3:0] Inst_SKINNY_Sbox_3_InAff_out1_reg;
  wire   [3:0] Inst_SKINNY_Sbox_3_InAff_out3;
  wire   [3:0] Inst_SKINNY_Sbox_3_InAff_out2;
  wire   [3:0] Inst_SKINNY_Sbox_3_InAff_out1;
  wire   [17:0] Inst_SKINNY_Sbox_3_Q294_inst1_CF_Reg;
  wire   [17:0] Inst_SKINNY_Sbox_3_Q294_inst1_CF_Out;
  wire   [17:0] Inst_SKINNY_Sbox_3_Q294_inst2_CF_Reg;
  wire   [17:0] Inst_SKINNY_Sbox_3_Q294_inst2_CF_Out;
  wire   [3:0] Inst_SKINNY_Sbox_4_OutAff_out3;
  wire   [3:0] Inst_SKINNY_Sbox_4_OutAff_out2;
  wire   [3:0] Inst_SKINNY_Sbox_4_OutAff_out1;
  wire   [3:0] Inst_SKINNY_Sbox_4_Q294_2_out1;
  wire   [3:0] Inst_SKINNY_Sbox_4_M2_out3;
  wire   [3:0] Inst_SKINNY_Sbox_4_M2_out3_reg;
  wire   [3:0] Inst_SKINNY_Sbox_4_M2_out2;
  wire   [3:0] Inst_SKINNY_Sbox_4_M2_out2_reg;
  wire   [3:0] Inst_SKINNY_Sbox_4_M2_out1;
  wire   [3:0] Inst_SKINNY_Sbox_4_M2_out1_reg;
  wire   [3:0] Inst_SKINNY_Sbox_4_InAff_out3_reg;
  wire   [3:0] Inst_SKINNY_Sbox_4_InAff_out2_reg;
  wire   [3:0] Inst_SKINNY_Sbox_4_InAff_out1_reg;
  wire   [3:0] Inst_SKINNY_Sbox_4_InAff_out3;
  wire   [3:0] Inst_SKINNY_Sbox_4_InAff_out2;
  wire   [3:0] Inst_SKINNY_Sbox_4_InAff_out1;
  wire   [17:0] Inst_SKINNY_Sbox_4_Q294_inst1_CF_Reg;
  wire   [17:0] Inst_SKINNY_Sbox_4_Q294_inst1_CF_Out;
  wire   [17:0] Inst_SKINNY_Sbox_4_Q294_inst2_CF_Reg;
  wire   [17:0] Inst_SKINNY_Sbox_4_Q294_inst2_CF_Out;
  wire   [3:0] Inst_SKINNY_Sbox_5_OutAff_out3;
  wire   [3:0] Inst_SKINNY_Sbox_5_OutAff_out2;
  wire   [3:0] Inst_SKINNY_Sbox_5_OutAff_out1;
  wire   [3:0] Inst_SKINNY_Sbox_5_Q294_2_out1;
  wire   [3:0] Inst_SKINNY_Sbox_5_M2_out3;
  wire   [3:0] Inst_SKINNY_Sbox_5_M2_out3_reg;
  wire   [3:0] Inst_SKINNY_Sbox_5_M2_out2;
  wire   [3:0] Inst_SKINNY_Sbox_5_M2_out2_reg;
  wire   [3:0] Inst_SKINNY_Sbox_5_M2_out1;
  wire   [3:0] Inst_SKINNY_Sbox_5_M2_out1_reg;
  wire   [3:0] Inst_SKINNY_Sbox_5_InAff_out3_reg;
  wire   [3:0] Inst_SKINNY_Sbox_5_InAff_out2_reg;
  wire   [3:0] Inst_SKINNY_Sbox_5_InAff_out1_reg;
  wire   [3:0] Inst_SKINNY_Sbox_5_InAff_out3;
  wire   [3:0] Inst_SKINNY_Sbox_5_InAff_out2;
  wire   [3:0] Inst_SKINNY_Sbox_5_InAff_out1;
  wire   [17:0] Inst_SKINNY_Sbox_5_Q294_inst1_CF_Reg;
  wire   [17:0] Inst_SKINNY_Sbox_5_Q294_inst1_CF_Out;
  wire   [17:0] Inst_SKINNY_Sbox_5_Q294_inst2_CF_Reg;
  wire   [17:0] Inst_SKINNY_Sbox_5_Q294_inst2_CF_Out;
  wire   [3:0] Inst_SKINNY_Sbox_6_OutAff_out3;
  wire   [3:0] Inst_SKINNY_Sbox_6_OutAff_out2;
  wire   [3:0] Inst_SKINNY_Sbox_6_OutAff_out1;
  wire   [3:0] Inst_SKINNY_Sbox_6_Q294_2_out1;
  wire   [3:0] Inst_SKINNY_Sbox_6_M2_out3;
  wire   [3:0] Inst_SKINNY_Sbox_6_M2_out3_reg;
  wire   [3:0] Inst_SKINNY_Sbox_6_M2_out2;
  wire   [3:0] Inst_SKINNY_Sbox_6_M2_out2_reg;
  wire   [3:0] Inst_SKINNY_Sbox_6_M2_out1;
  wire   [3:0] Inst_SKINNY_Sbox_6_M2_out1_reg;
  wire   [3:0] Inst_SKINNY_Sbox_6_InAff_out3_reg;
  wire   [3:0] Inst_SKINNY_Sbox_6_InAff_out2_reg;
  wire   [3:0] Inst_SKINNY_Sbox_6_InAff_out1_reg;
  wire   [3:0] Inst_SKINNY_Sbox_6_InAff_out3;
  wire   [3:0] Inst_SKINNY_Sbox_6_InAff_out2;
  wire   [3:0] Inst_SKINNY_Sbox_6_InAff_out1;
  wire   [17:0] Inst_SKINNY_Sbox_6_Q294_inst1_CF_Reg;
  wire   [17:0] Inst_SKINNY_Sbox_6_Q294_inst1_CF_Out;
  wire   [17:0] Inst_SKINNY_Sbox_6_Q294_inst2_CF_Reg;
  wire   [17:0] Inst_SKINNY_Sbox_6_Q294_inst2_CF_Out;
  wire   [3:0] Inst_SKINNY_Sbox_7_OutAff_out3;
  wire   [3:0] Inst_SKINNY_Sbox_7_OutAff_out2;
  wire   [3:0] Inst_SKINNY_Sbox_7_OutAff_out1;
  wire   [3:0] Inst_SKINNY_Sbox_7_Q294_2_out1;
  wire   [3:0] Inst_SKINNY_Sbox_7_M2_out3;
  wire   [3:0] Inst_SKINNY_Sbox_7_M2_out3_reg;
  wire   [3:0] Inst_SKINNY_Sbox_7_M2_out2;
  wire   [3:0] Inst_SKINNY_Sbox_7_M2_out2_reg;
  wire   [3:0] Inst_SKINNY_Sbox_7_M2_out1;
  wire   [3:0] Inst_SKINNY_Sbox_7_M2_out1_reg;
  wire   [3:0] Inst_SKINNY_Sbox_7_InAff_out3_reg;
  wire   [3:0] Inst_SKINNY_Sbox_7_InAff_out2_reg;
  wire   [3:0] Inst_SKINNY_Sbox_7_InAff_out1_reg;
  wire   [3:0] Inst_SKINNY_Sbox_7_InAff_out3;
  wire   [3:0] Inst_SKINNY_Sbox_7_InAff_out2;
  wire   [3:0] Inst_SKINNY_Sbox_7_InAff_out1;
  wire   [17:0] Inst_SKINNY_Sbox_7_Q294_inst1_CF_Reg;
  wire   [17:0] Inst_SKINNY_Sbox_7_Q294_inst1_CF_Out;
  wire   [17:0] Inst_SKINNY_Sbox_7_Q294_inst2_CF_Reg;
  wire   [17:0] Inst_SKINNY_Sbox_7_Q294_inst2_CF_Out;
  wire   [3:0] Inst_SKINNY_Sbox_8_OutAff_out3;
  wire   [3:0] Inst_SKINNY_Sbox_8_OutAff_out2;
  wire   [3:0] Inst_SKINNY_Sbox_8_OutAff_out1;
  wire   [3:0] Inst_SKINNY_Sbox_8_Q294_2_out1;
  wire   [3:0] Inst_SKINNY_Sbox_8_M2_out3;
  wire   [3:0] Inst_SKINNY_Sbox_8_M2_out3_reg;
  wire   [3:0] Inst_SKINNY_Sbox_8_M2_out2;
  wire   [3:0] Inst_SKINNY_Sbox_8_M2_out2_reg;
  wire   [3:0] Inst_SKINNY_Sbox_8_M2_out1;
  wire   [3:0] Inst_SKINNY_Sbox_8_M2_out1_reg;
  wire   [3:0] Inst_SKINNY_Sbox_8_InAff_out3_reg;
  wire   [3:0] Inst_SKINNY_Sbox_8_InAff_out2_reg;
  wire   [3:0] Inst_SKINNY_Sbox_8_InAff_out1_reg;
  wire   [3:0] Inst_SKINNY_Sbox_8_InAff_out3;
  wire   [3:0] Inst_SKINNY_Sbox_8_InAff_out2;
  wire   [3:0] Inst_SKINNY_Sbox_8_InAff_out1;
  wire   [17:0] Inst_SKINNY_Sbox_8_Q294_inst1_CF_Reg;
  wire   [17:0] Inst_SKINNY_Sbox_8_Q294_inst1_CF_Out;
  wire   [17:0] Inst_SKINNY_Sbox_8_Q294_inst2_CF_Reg;
  wire   [17:0] Inst_SKINNY_Sbox_8_Q294_inst2_CF_Out;
  wire   [3:0] Inst_SKINNY_Sbox_9_OutAff_out3;
  wire   [3:0] Inst_SKINNY_Sbox_9_OutAff_out2;
  wire   [3:0] Inst_SKINNY_Sbox_9_OutAff_out1;
  wire   [3:0] Inst_SKINNY_Sbox_9_Q294_2_out1;
  wire   [3:0] Inst_SKINNY_Sbox_9_M2_out3;
  wire   [3:0] Inst_SKINNY_Sbox_9_M2_out3_reg;
  wire   [3:0] Inst_SKINNY_Sbox_9_M2_out2;
  wire   [3:0] Inst_SKINNY_Sbox_9_M2_out2_reg;
  wire   [3:0] Inst_SKINNY_Sbox_9_M2_out1;
  wire   [3:0] Inst_SKINNY_Sbox_9_M2_out1_reg;
  wire   [3:0] Inst_SKINNY_Sbox_9_InAff_out3_reg;
  wire   [3:0] Inst_SKINNY_Sbox_9_InAff_out2_reg;
  wire   [3:0] Inst_SKINNY_Sbox_9_InAff_out1_reg;
  wire   [3:0] Inst_SKINNY_Sbox_9_InAff_out3;
  wire   [3:0] Inst_SKINNY_Sbox_9_InAff_out2;
  wire   [3:0] Inst_SKINNY_Sbox_9_InAff_out1;
  wire   [17:0] Inst_SKINNY_Sbox_9_Q294_inst1_CF_Reg;
  wire   [17:0] Inst_SKINNY_Sbox_9_Q294_inst1_CF_Out;
  wire   [17:0] Inst_SKINNY_Sbox_9_Q294_inst2_CF_Reg;
  wire   [17:0] Inst_SKINNY_Sbox_9_Q294_inst2_CF_Out;
  wire   [3:0] Inst_SKINNY_Sbox_10_OutAff_out3;
  wire   [3:0] Inst_SKINNY_Sbox_10_OutAff_out2;
  wire   [3:0] Inst_SKINNY_Sbox_10_OutAff_out1;
  wire   [3:0] Inst_SKINNY_Sbox_10_Q294_2_out1;
  wire   [3:0] Inst_SKINNY_Sbox_10_M2_out3;
  wire   [3:0] Inst_SKINNY_Sbox_10_M2_out3_reg;
  wire   [3:0] Inst_SKINNY_Sbox_10_M2_out2;
  wire   [3:0] Inst_SKINNY_Sbox_10_M2_out2_reg;
  wire   [3:0] Inst_SKINNY_Sbox_10_M2_out1;
  wire   [3:0] Inst_SKINNY_Sbox_10_M2_out1_reg;
  wire   [3:0] Inst_SKINNY_Sbox_10_InAff_out3_reg;
  wire   [3:0] Inst_SKINNY_Sbox_10_InAff_out2_reg;
  wire   [3:0] Inst_SKINNY_Sbox_10_InAff_out1_reg;
  wire   [3:0] Inst_SKINNY_Sbox_10_InAff_out3;
  wire   [3:0] Inst_SKINNY_Sbox_10_InAff_out2;
  wire   [3:0] Inst_SKINNY_Sbox_10_InAff_out1;
  wire   [17:0] Inst_SKINNY_Sbox_10_Q294_inst1_CF_Reg;
  wire   [17:0] Inst_SKINNY_Sbox_10_Q294_inst1_CF_Out;
  wire   [17:0] Inst_SKINNY_Sbox_10_Q294_inst2_CF_Reg;
  wire   [17:0] Inst_SKINNY_Sbox_10_Q294_inst2_CF_Out;
  wire   [3:0] Inst_SKINNY_Sbox_11_OutAff_out3;
  wire   [3:0] Inst_SKINNY_Sbox_11_OutAff_out2;
  wire   [3:0] Inst_SKINNY_Sbox_11_OutAff_out1;
  wire   [3:0] Inst_SKINNY_Sbox_11_Q294_2_out1;
  wire   [3:0] Inst_SKINNY_Sbox_11_M2_out3;
  wire   [3:0] Inst_SKINNY_Sbox_11_M2_out3_reg;
  wire   [3:0] Inst_SKINNY_Sbox_11_M2_out2;
  wire   [3:0] Inst_SKINNY_Sbox_11_M2_out2_reg;
  wire   [3:0] Inst_SKINNY_Sbox_11_M2_out1;
  wire   [3:0] Inst_SKINNY_Sbox_11_M2_out1_reg;
  wire   [3:0] Inst_SKINNY_Sbox_11_InAff_out3_reg;
  wire   [3:0] Inst_SKINNY_Sbox_11_InAff_out2_reg;
  wire   [3:0] Inst_SKINNY_Sbox_11_InAff_out1_reg;
  wire   [3:0] Inst_SKINNY_Sbox_11_InAff_out3;
  wire   [3:0] Inst_SKINNY_Sbox_11_InAff_out2;
  wire   [3:0] Inst_SKINNY_Sbox_11_InAff_out1;
  wire   [17:0] Inst_SKINNY_Sbox_11_Q294_inst1_CF_Reg;
  wire   [17:0] Inst_SKINNY_Sbox_11_Q294_inst1_CF_Out;
  wire   [17:0] Inst_SKINNY_Sbox_11_Q294_inst2_CF_Reg;
  wire   [17:0] Inst_SKINNY_Sbox_11_Q294_inst2_CF_Out;
  wire   [3:0] Inst_SKINNY_Sbox_12_OutAff_out3;
  wire   [3:0] Inst_SKINNY_Sbox_12_OutAff_out2;
  wire   [3:0] Inst_SKINNY_Sbox_12_OutAff_out1;
  wire   [3:0] Inst_SKINNY_Sbox_12_Q294_2_out1;
  wire   [3:0] Inst_SKINNY_Sbox_12_M2_out3;
  wire   [3:0] Inst_SKINNY_Sbox_12_M2_out3_reg;
  wire   [3:0] Inst_SKINNY_Sbox_12_M2_out2;
  wire   [3:0] Inst_SKINNY_Sbox_12_M2_out2_reg;
  wire   [3:0] Inst_SKINNY_Sbox_12_M2_out1;
  wire   [3:0] Inst_SKINNY_Sbox_12_M2_out1_reg;
  wire   [3:0] Inst_SKINNY_Sbox_12_InAff_out3_reg;
  wire   [3:0] Inst_SKINNY_Sbox_12_InAff_out2_reg;
  wire   [3:0] Inst_SKINNY_Sbox_12_InAff_out1_reg;
  wire   [3:0] Inst_SKINNY_Sbox_12_InAff_out3;
  wire   [3:0] Inst_SKINNY_Sbox_12_InAff_out2;
  wire   [3:0] Inst_SKINNY_Sbox_12_InAff_out1;
  wire   [17:0] Inst_SKINNY_Sbox_12_Q294_inst1_CF_Reg;
  wire   [17:0] Inst_SKINNY_Sbox_12_Q294_inst1_CF_Out;
  wire   [17:0] Inst_SKINNY_Sbox_12_Q294_inst2_CF_Reg;
  wire   [17:0] Inst_SKINNY_Sbox_12_Q294_inst2_CF_Out;
  wire   [3:0] Inst_SKINNY_Sbox_13_OutAff_out3;
  wire   [3:0] Inst_SKINNY_Sbox_13_OutAff_out2;
  wire   [3:0] Inst_SKINNY_Sbox_13_OutAff_out1;
  wire   [3:0] Inst_SKINNY_Sbox_13_Q294_2_out1;
  wire   [3:0] Inst_SKINNY_Sbox_13_M2_out3;
  wire   [3:0] Inst_SKINNY_Sbox_13_M2_out3_reg;
  wire   [3:0] Inst_SKINNY_Sbox_13_M2_out2;
  wire   [3:0] Inst_SKINNY_Sbox_13_M2_out2_reg;
  wire   [3:0] Inst_SKINNY_Sbox_13_M2_out1;
  wire   [3:0] Inst_SKINNY_Sbox_13_M2_out1_reg;
  wire   [3:0] Inst_SKINNY_Sbox_13_InAff_out3_reg;
  wire   [3:0] Inst_SKINNY_Sbox_13_InAff_out2_reg;
  wire   [3:0] Inst_SKINNY_Sbox_13_InAff_out1_reg;
  wire   [3:0] Inst_SKINNY_Sbox_13_InAff_out3;
  wire   [3:0] Inst_SKINNY_Sbox_13_InAff_out2;
  wire   [3:0] Inst_SKINNY_Sbox_13_InAff_out1;
  wire   [17:0] Inst_SKINNY_Sbox_13_Q294_inst1_CF_Reg;
  wire   [17:0] Inst_SKINNY_Sbox_13_Q294_inst1_CF_Out;
  wire   [17:0] Inst_SKINNY_Sbox_13_Q294_inst2_CF_Reg;
  wire   [17:0] Inst_SKINNY_Sbox_13_Q294_inst2_CF_Out;
  wire   [3:0] Inst_SKINNY_Sbox_14_OutAff_out3;
  wire   [3:0] Inst_SKINNY_Sbox_14_OutAff_out2;
  wire   [3:0] Inst_SKINNY_Sbox_14_OutAff_out1;
  wire   [3:0] Inst_SKINNY_Sbox_14_Q294_2_out1;
  wire   [3:0] Inst_SKINNY_Sbox_14_M2_out3;
  wire   [3:0] Inst_SKINNY_Sbox_14_M2_out3_reg;
  wire   [3:0] Inst_SKINNY_Sbox_14_M2_out2;
  wire   [3:0] Inst_SKINNY_Sbox_14_M2_out2_reg;
  wire   [3:0] Inst_SKINNY_Sbox_14_M2_out1;
  wire   [3:0] Inst_SKINNY_Sbox_14_M2_out1_reg;
  wire   [3:0] Inst_SKINNY_Sbox_14_InAff_out3_reg;
  wire   [3:0] Inst_SKINNY_Sbox_14_InAff_out2_reg;
  wire   [3:0] Inst_SKINNY_Sbox_14_InAff_out1_reg;
  wire   [3:0] Inst_SKINNY_Sbox_14_InAff_out3;
  wire   [3:0] Inst_SKINNY_Sbox_14_InAff_out2;
  wire   [3:0] Inst_SKINNY_Sbox_14_InAff_out1;
  wire   [17:0] Inst_SKINNY_Sbox_14_Q294_inst1_CF_Reg;
  wire   [17:0] Inst_SKINNY_Sbox_14_Q294_inst1_CF_Out;
  wire   [17:0] Inst_SKINNY_Sbox_14_Q294_inst2_CF_Reg;
  wire   [17:0] Inst_SKINNY_Sbox_14_Q294_inst2_CF_Out;
  wire   [3:0] Inst_SKINNY_Sbox_15_OutAff_out3;
  wire   [3:0] Inst_SKINNY_Sbox_15_OutAff_out2;
  wire   [3:0] Inst_SKINNY_Sbox_15_OutAff_out1;
  wire   [3:0] Inst_SKINNY_Sbox_15_Q294_2_out1;
  wire   [3:0] Inst_SKINNY_Sbox_15_M2_out3;
  wire   [3:0] Inst_SKINNY_Sbox_15_M2_out3_reg;
  wire   [3:0] Inst_SKINNY_Sbox_15_M2_out2;
  wire   [3:0] Inst_SKINNY_Sbox_15_M2_out2_reg;
  wire   [3:0] Inst_SKINNY_Sbox_15_M2_out1;
  wire   [3:0] Inst_SKINNY_Sbox_15_M2_out1_reg;
  wire   [3:0] Inst_SKINNY_Sbox_15_InAff_out3_reg;
  wire   [3:0] Inst_SKINNY_Sbox_15_InAff_out2_reg;
  wire   [3:0] Inst_SKINNY_Sbox_15_InAff_out1_reg;
  wire   [3:0] Inst_SKINNY_Sbox_15_InAff_out3;
  wire   [3:0] Inst_SKINNY_Sbox_15_InAff_out2;
  wire   [3:0] Inst_SKINNY_Sbox_15_InAff_out1;
  wire   [17:0] Inst_SKINNY_Sbox_15_Q294_inst1_CF_Reg;
  wire   [17:0] Inst_SKINNY_Sbox_15_Q294_inst1_CF_Out;
  wire   [17:0] Inst_SKINNY_Sbox_15_Q294_inst2_CF_Reg;
  wire   [17:0] Inst_SKINNY_Sbox_15_Q294_inst2_CF_Out;
  wire   [63:0] KE1_KEY_PERM;
  wire   [63:0] KE2_KEY_PERM;
  wire   [63:0] KE3_KEY_PERM;

  MUX2_X1 RF1_U64 ( .A(CIPHERTEXT1[0]), .B(PLAINTEXT1[0]), .S(RESET), .Z(
        SUB_IN1[0]) );
  MUX2_X1 RF1_U63 ( .A(CIPHERTEXT1[1]), .B(PLAINTEXT1[1]), .S(RESET), .Z(
        SUB_IN1[1]) );
  MUX2_X1 RF1_U62 ( .A(CIPHERTEXT1[2]), .B(PLAINTEXT1[2]), .S(RESET), .Z(
        SUB_IN1[2]) );
  MUX2_X1 RF1_U61 ( .A(CIPHERTEXT1[3]), .B(PLAINTEXT1[3]), .S(RESET), .Z(
        SUB_IN1[3]) );
  MUX2_X1 RF1_U60 ( .A(CIPHERTEXT1[4]), .B(PLAINTEXT1[4]), .S(RESET), .Z(
        SUB_IN1[4]) );
  MUX2_X1 RF1_U59 ( .A(CIPHERTEXT1[5]), .B(PLAINTEXT1[5]), .S(RESET), .Z(
        SUB_IN1[5]) );
  MUX2_X1 RF1_U58 ( .A(CIPHERTEXT1[6]), .B(PLAINTEXT1[6]), .S(RESET), .Z(
        SUB_IN1[6]) );
  MUX2_X1 RF1_U57 ( .A(CIPHERTEXT1[7]), .B(PLAINTEXT1[7]), .S(RESET), .Z(
        SUB_IN1[7]) );
  MUX2_X1 RF1_U56 ( .A(CIPHERTEXT1[8]), .B(PLAINTEXT1[8]), .S(RESET), .Z(
        SUB_IN1[8]) );
  MUX2_X1 RF1_U55 ( .A(CIPHERTEXT1[9]), .B(PLAINTEXT1[9]), .S(RESET), .Z(
        SUB_IN1[9]) );
  MUX2_X1 RF1_U54 ( .A(CIPHERTEXT1[10]), .B(PLAINTEXT1[10]), .S(RESET), .Z(
        SUB_IN1[10]) );
  MUX2_X1 RF1_U53 ( .A(CIPHERTEXT1[11]), .B(PLAINTEXT1[11]), .S(RESET), .Z(
        SUB_IN1[11]) );
  MUX2_X1 RF1_U52 ( .A(CIPHERTEXT1[12]), .B(PLAINTEXT1[12]), .S(RESET), .Z(
        SUB_IN1[12]) );
  MUX2_X1 RF1_U51 ( .A(CIPHERTEXT1[13]), .B(PLAINTEXT1[13]), .S(RESET), .Z(
        SUB_IN1[13]) );
  MUX2_X1 RF1_U50 ( .A(CIPHERTEXT1[14]), .B(PLAINTEXT1[14]), .S(RESET), .Z(
        SUB_IN1[14]) );
  MUX2_X1 RF1_U49 ( .A(CIPHERTEXT1[15]), .B(PLAINTEXT1[15]), .S(RESET), .Z(
        SUB_IN1[15]) );
  MUX2_X1 RF1_U48 ( .A(CIPHERTEXT1[16]), .B(PLAINTEXT1[16]), .S(RESET), .Z(
        SUB_IN1[16]) );
  MUX2_X1 RF1_U47 ( .A(CIPHERTEXT1[17]), .B(PLAINTEXT1[17]), .S(RESET), .Z(
        SUB_IN1[17]) );
  MUX2_X1 RF1_U46 ( .A(CIPHERTEXT1[18]), .B(PLAINTEXT1[18]), .S(RESET), .Z(
        SUB_IN1[18]) );
  MUX2_X1 RF1_U45 ( .A(CIPHERTEXT1[19]), .B(PLAINTEXT1[19]), .S(RESET), .Z(
        SUB_IN1[19]) );
  MUX2_X1 RF1_U44 ( .A(CIPHERTEXT1[20]), .B(PLAINTEXT1[20]), .S(RESET), .Z(
        SUB_IN1[20]) );
  MUX2_X1 RF1_U43 ( .A(CIPHERTEXT1[21]), .B(PLAINTEXT1[21]), .S(RESET), .Z(
        SUB_IN1[21]) );
  MUX2_X1 RF1_U42 ( .A(CIPHERTEXT1[22]), .B(PLAINTEXT1[22]), .S(RESET), .Z(
        SUB_IN1[22]) );
  MUX2_X1 RF1_U41 ( .A(CIPHERTEXT1[23]), .B(PLAINTEXT1[23]), .S(RESET), .Z(
        SUB_IN1[23]) );
  MUX2_X1 RF1_U40 ( .A(CIPHERTEXT1[24]), .B(PLAINTEXT1[24]), .S(RESET), .Z(
        SUB_IN1[24]) );
  MUX2_X1 RF1_U39 ( .A(CIPHERTEXT1[25]), .B(PLAINTEXT1[25]), .S(RESET), .Z(
        SUB_IN1[25]) );
  MUX2_X1 RF1_U38 ( .A(CIPHERTEXT1[26]), .B(PLAINTEXT1[26]), .S(RESET), .Z(
        SUB_IN1[26]) );
  MUX2_X1 RF1_U37 ( .A(CIPHERTEXT1[27]), .B(PLAINTEXT1[27]), .S(RESET), .Z(
        SUB_IN1[27]) );
  MUX2_X1 RF1_U36 ( .A(CIPHERTEXT1[28]), .B(PLAINTEXT1[28]), .S(RESET), .Z(
        SUB_IN1[28]) );
  MUX2_X1 RF1_U35 ( .A(CIPHERTEXT1[29]), .B(PLAINTEXT1[29]), .S(RESET), .Z(
        SUB_IN1[29]) );
  MUX2_X1 RF1_U34 ( .A(CIPHERTEXT1[30]), .B(PLAINTEXT1[30]), .S(RESET), .Z(
        SUB_IN1[30]) );
  MUX2_X1 RF1_U33 ( .A(CIPHERTEXT1[31]), .B(PLAINTEXT1[31]), .S(RESET), .Z(
        SUB_IN1[31]) );
  MUX2_X1 RF1_U32 ( .A(CIPHERTEXT1[32]), .B(PLAINTEXT1[32]), .S(RESET), .Z(
        SUB_IN1[32]) );
  MUX2_X1 RF1_U31 ( .A(CIPHERTEXT1[33]), .B(PLAINTEXT1[33]), .S(RESET), .Z(
        SUB_IN1[33]) );
  MUX2_X1 RF1_U30 ( .A(CIPHERTEXT1[34]), .B(PLAINTEXT1[34]), .S(RESET), .Z(
        SUB_IN1[34]) );
  MUX2_X1 RF1_U29 ( .A(CIPHERTEXT1[35]), .B(PLAINTEXT1[35]), .S(RESET), .Z(
        SUB_IN1[35]) );
  MUX2_X1 RF1_U28 ( .A(CIPHERTEXT1[36]), .B(PLAINTEXT1[36]), .S(RESET), .Z(
        SUB_IN1[36]) );
  MUX2_X1 RF1_U27 ( .A(CIPHERTEXT1[37]), .B(PLAINTEXT1[37]), .S(RESET), .Z(
        SUB_IN1[37]) );
  MUX2_X1 RF1_U26 ( .A(CIPHERTEXT1[38]), .B(PLAINTEXT1[38]), .S(RESET), .Z(
        SUB_IN1[38]) );
  MUX2_X1 RF1_U25 ( .A(CIPHERTEXT1[39]), .B(PLAINTEXT1[39]), .S(RESET), .Z(
        SUB_IN1[39]) );
  MUX2_X1 RF1_U24 ( .A(CIPHERTEXT1[40]), .B(PLAINTEXT1[40]), .S(RESET), .Z(
        SUB_IN1[40]) );
  MUX2_X1 RF1_U23 ( .A(CIPHERTEXT1[41]), .B(PLAINTEXT1[41]), .S(RESET), .Z(
        SUB_IN1[41]) );
  MUX2_X1 RF1_U22 ( .A(CIPHERTEXT1[42]), .B(PLAINTEXT1[42]), .S(RESET), .Z(
        SUB_IN1[42]) );
  MUX2_X1 RF1_U21 ( .A(CIPHERTEXT1[43]), .B(PLAINTEXT1[43]), .S(RESET), .Z(
        SUB_IN1[43]) );
  MUX2_X1 RF1_U20 ( .A(CIPHERTEXT1[44]), .B(PLAINTEXT1[44]), .S(RESET), .Z(
        SUB_IN1[44]) );
  MUX2_X1 RF1_U19 ( .A(CIPHERTEXT1[45]), .B(PLAINTEXT1[45]), .S(RESET), .Z(
        SUB_IN1[45]) );
  MUX2_X1 RF1_U18 ( .A(CIPHERTEXT1[46]), .B(PLAINTEXT1[46]), .S(RESET), .Z(
        SUB_IN1[46]) );
  MUX2_X1 RF1_U17 ( .A(CIPHERTEXT1[47]), .B(PLAINTEXT1[47]), .S(RESET), .Z(
        SUB_IN1[47]) );
  MUX2_X1 RF1_U16 ( .A(CIPHERTEXT1[48]), .B(PLAINTEXT1[48]), .S(RESET), .Z(
        SUB_IN1[48]) );
  MUX2_X1 RF1_U15 ( .A(CIPHERTEXT1[49]), .B(PLAINTEXT1[49]), .S(RESET), .Z(
        SUB_IN1[49]) );
  MUX2_X1 RF1_U14 ( .A(CIPHERTEXT1[50]), .B(PLAINTEXT1[50]), .S(RESET), .Z(
        SUB_IN1[50]) );
  MUX2_X1 RF1_U13 ( .A(CIPHERTEXT1[51]), .B(PLAINTEXT1[51]), .S(RESET), .Z(
        SUB_IN1[51]) );
  MUX2_X1 RF1_U12 ( .A(CIPHERTEXT1[52]), .B(PLAINTEXT1[52]), .S(RESET), .Z(
        SUB_IN1[52]) );
  MUX2_X1 RF1_U11 ( .A(CIPHERTEXT1[53]), .B(PLAINTEXT1[53]), .S(RESET), .Z(
        SUB_IN1[53]) );
  MUX2_X1 RF1_U10 ( .A(CIPHERTEXT1[54]), .B(PLAINTEXT1[54]), .S(RESET), .Z(
        SUB_IN1[54]) );
  MUX2_X1 RF1_U9 ( .A(CIPHERTEXT1[55]), .B(PLAINTEXT1[55]), .S(RESET), .Z(
        SUB_IN1[55]) );
  MUX2_X1 RF1_U8 ( .A(CIPHERTEXT1[56]), .B(PLAINTEXT1[56]), .S(RESET), .Z(
        SUB_IN1[56]) );
  MUX2_X1 RF1_U7 ( .A(CIPHERTEXT1[57]), .B(PLAINTEXT1[57]), .S(RESET), .Z(
        SUB_IN1[57]) );
  MUX2_X1 RF1_U6 ( .A(CIPHERTEXT1[58]), .B(PLAINTEXT1[58]), .S(RESET), .Z(
        SUB_IN1[58]) );
  MUX2_X1 RF1_U5 ( .A(CIPHERTEXT1[59]), .B(PLAINTEXT1[59]), .S(RESET), .Z(
        SUB_IN1[59]) );
  MUX2_X1 RF1_U4 ( .A(CIPHERTEXT1[60]), .B(PLAINTEXT1[60]), .S(RESET), .Z(
        SUB_IN1[60]) );
  MUX2_X1 RF1_U3 ( .A(CIPHERTEXT1[61]), .B(PLAINTEXT1[61]), .S(RESET), .Z(
        SUB_IN1[61]) );
  MUX2_X1 RF1_U2 ( .A(CIPHERTEXT1[62]), .B(PLAINTEXT1[62]), .S(RESET), .Z(
        SUB_IN1[62]) );
  MUX2_X1 RF1_U1 ( .A(CIPHERTEXT1[63]), .B(PLAINTEXT1[63]), .S(RESET), .Z(
        SUB_IN1[63]) );
  INV_X1 RF1_KA_U39 ( .A(SUB_OUT1[29]), .ZN(RF1_SHIFTROWS[21]) );
  XNOR2_X1 RF1_KA_U38 ( .A(RF1_KA_n18), .B(KE1_KEY_PERM[31]), .ZN(
        CIPHERTEXT1[47]) );
  XNOR2_X1 RF1_KA_U37 ( .A(ROUND_CST[3]), .B(SUB_OUT1[63]), .ZN(RF1_KA_n18) );
  XNOR2_X1 RF1_KA_U36 ( .A(RF1_KA_n17), .B(KE1_KEY_PERM[30]), .ZN(
        CIPHERTEXT1[46]) );
  XNOR2_X1 RF1_KA_U35 ( .A(ROUND_CST[2]), .B(SUB_OUT1[62]), .ZN(RF1_KA_n17) );
  XNOR2_X1 RF1_KA_U34 ( .A(RF1_KA_n16), .B(KE1_KEY_PERM[29]), .ZN(
        CIPHERTEXT1[45]) );
  XNOR2_X1 RF1_KA_U33 ( .A(ROUND_CST[1]), .B(SUB_OUT1[61]), .ZN(RF1_KA_n16) );
  XNOR2_X1 RF1_KA_U32 ( .A(RF1_KA_n15), .B(KE1_KEY_PERM[28]), .ZN(
        CIPHERTEXT1[44]) );
  XNOR2_X1 RF1_KA_U31 ( .A(ROUND_CST[0]), .B(SUB_OUT1[60]), .ZN(RF1_KA_n15) );
  XOR2_X1 RF1_KA_U30 ( .A(SUB_OUT1[59]), .B(KE1_KEY_PERM[27]), .Z(
        CIPHERTEXT1[43]) );
  XOR2_X1 RF1_KA_U29 ( .A(SUB_OUT1[58]), .B(KE1_KEY_PERM[26]), .Z(
        CIPHERTEXT1[42]) );
  XOR2_X1 RF1_KA_U28 ( .A(SUB_OUT1[57]), .B(KE1_KEY_PERM[25]), .Z(
        CIPHERTEXT1[41]) );
  XOR2_X1 RF1_KA_U27 ( .A(SUB_OUT1[56]), .B(KE1_KEY_PERM[24]), .Z(
        CIPHERTEXT1[40]) );
  XOR2_X1 RF1_KA_U26 ( .A(SUB_OUT1[55]), .B(KE1_KEY_PERM[23]), .Z(
        CIPHERTEXT1[39]) );
  XOR2_X1 RF1_KA_U25 ( .A(SUB_OUT1[54]), .B(KE1_KEY_PERM[22]), .Z(
        CIPHERTEXT1[38]) );
  XOR2_X1 RF1_KA_U24 ( .A(SUB_OUT1[53]), .B(KE1_KEY_PERM[21]), .Z(
        CIPHERTEXT1[37]) );
  XOR2_X1 RF1_KA_U23 ( .A(SUB_OUT1[52]), .B(KE1_KEY_PERM[20]), .Z(
        CIPHERTEXT1[36]) );
  XOR2_X1 RF1_KA_U22 ( .A(SUB_OUT1[51]), .B(KE1_KEY_PERM[19]), .Z(
        CIPHERTEXT1[35]) );
  XOR2_X1 RF1_KA_U21 ( .A(SUB_OUT1[50]), .B(KE1_KEY_PERM[18]), .Z(
        CIPHERTEXT1[34]) );
  XOR2_X1 RF1_KA_U20 ( .A(SUB_OUT1[49]), .B(KE1_KEY_PERM[17]), .Z(
        CIPHERTEXT1[33]) );
  XOR2_X1 RF1_KA_U19 ( .A(SUB_OUT1[48]), .B(KE1_KEY_PERM[16]), .Z(
        CIPHERTEXT1[32]) );
  XOR2_X1 RF1_KA_U18 ( .A(SUB_OUT1[47]), .B(KE1_KEY_PERM[15]), .Z(
        RF1_SHIFTROWS[43]) );
  XOR2_X1 RF1_KA_U17 ( .A(SUB_OUT1[46]), .B(KE1_KEY_PERM[14]), .Z(
        RF1_SHIFTROWS[42]) );
  XNOR2_X1 RF1_KA_U16 ( .A(RF1_KA_n14), .B(KE1_KEY_PERM[13]), .ZN(
        RF1_SHIFTROWS[41]) );
  XNOR2_X1 RF1_KA_U15 ( .A(ROUND_CST[5]), .B(SUB_OUT1[45]), .ZN(RF1_KA_n14) );
  XNOR2_X1 RF1_KA_U14 ( .A(RF1_KA_n13), .B(KE1_KEY_PERM[12]), .ZN(
        RF1_SHIFTROWS[40]) );
  XNOR2_X1 RF1_KA_U13 ( .A(ROUND_CST[4]), .B(SUB_OUT1[44]), .ZN(RF1_KA_n13) );
  XOR2_X1 RF1_KA_U12 ( .A(SUB_OUT1[43]), .B(KE1_KEY_PERM[11]), .Z(
        RF1_SHIFTROWS[39]) );
  XOR2_X1 RF1_KA_U11 ( .A(SUB_OUT1[42]), .B(KE1_KEY_PERM[10]), .Z(
        RF1_SHIFTROWS[38]) );
  XOR2_X1 RF1_KA_U10 ( .A(SUB_OUT1[41]), .B(KE1_KEY_PERM[9]), .Z(
        RF1_SHIFTROWS[37]) );
  XOR2_X1 RF1_KA_U9 ( .A(SUB_OUT1[40]), .B(KE1_KEY_PERM[8]), .Z(
        RF1_SHIFTROWS[36]) );
  XOR2_X1 RF1_KA_U8 ( .A(SUB_OUT1[39]), .B(KE1_KEY_PERM[7]), .Z(
        RF1_SHIFTROWS[35]) );
  XOR2_X1 RF1_KA_U7 ( .A(SUB_OUT1[38]), .B(KE1_KEY_PERM[6]), .Z(
        RF1_SHIFTROWS[34]) );
  XOR2_X1 RF1_KA_U6 ( .A(SUB_OUT1[37]), .B(KE1_KEY_PERM[5]), .Z(
        RF1_SHIFTROWS[33]) );
  XOR2_X1 RF1_KA_U5 ( .A(SUB_OUT1[36]), .B(KE1_KEY_PERM[4]), .Z(
        RF1_SHIFTROWS[32]) );
  XOR2_X1 RF1_KA_U4 ( .A(SUB_OUT1[35]), .B(KE1_KEY_PERM[3]), .Z(
        RF1_SHIFTROWS[47]) );
  XOR2_X1 RF1_KA_U3 ( .A(SUB_OUT1[34]), .B(KE1_KEY_PERM[2]), .Z(
        RF1_SHIFTROWS[46]) );
  XOR2_X1 RF1_KA_U2 ( .A(SUB_OUT1[33]), .B(KE1_KEY_PERM[1]), .Z(
        RF1_SHIFTROWS[45]) );
  XOR2_X1 RF1_KA_U1 ( .A(SUB_OUT1[32]), .B(KE1_KEY_PERM[0]), .Z(
        RF1_SHIFTROWS[44]) );
  XOR2_X1 RF1_MC_U48 ( .A(RF1_SHIFTROWS[15]), .B(CIPHERTEXT1[15]), .Z(
        CIPHERTEXT1[63]) );
  XOR2_X1 RF1_MC_U47 ( .A(RF1_SHIFTROWS[14]), .B(CIPHERTEXT1[14]), .Z(
        CIPHERTEXT1[62]) );
  XOR2_X1 RF1_MC_U46 ( .A(RF1_SHIFTROWS[13]), .B(CIPHERTEXT1[13]), .Z(
        CIPHERTEXT1[61]) );
  XOR2_X1 RF1_MC_U45 ( .A(RF1_SHIFTROWS[12]), .B(CIPHERTEXT1[12]), .Z(
        CIPHERTEXT1[60]) );
  XOR2_X1 RF1_MC_U44 ( .A(RF1_SHIFTROWS[11]), .B(CIPHERTEXT1[11]), .Z(
        CIPHERTEXT1[59]) );
  XOR2_X1 RF1_MC_U43 ( .A(RF1_SHIFTROWS[10]), .B(CIPHERTEXT1[10]), .Z(
        CIPHERTEXT1[58]) );
  XOR2_X1 RF1_MC_U42 ( .A(RF1_SHIFTROWS[9]), .B(CIPHERTEXT1[9]), .Z(
        CIPHERTEXT1[57]) );
  XOR2_X1 RF1_MC_U41 ( .A(CIPHERTEXT1[41]), .B(RF1_SHIFTROWS[25]), .Z(
        CIPHERTEXT1[9]) );
  XOR2_X1 RF1_MC_U40 ( .A(RF1_SHIFTROWS[8]), .B(CIPHERTEXT1[8]), .Z(
        CIPHERTEXT1[56]) );
  XOR2_X1 RF1_MC_U39 ( .A(CIPHERTEXT1[40]), .B(RF1_SHIFTROWS[24]), .Z(
        CIPHERTEXT1[8]) );
  XOR2_X1 RF1_MC_U38 ( .A(RF1_SHIFTROWS[7]), .B(CIPHERTEXT1[7]), .Z(
        CIPHERTEXT1[55]) );
  XOR2_X1 RF1_MC_U37 ( .A(CIPHERTEXT1[39]), .B(RF1_SHIFTROWS[23]), .Z(
        CIPHERTEXT1[7]) );
  XOR2_X1 RF1_MC_U36 ( .A(RF1_SHIFTROWS[6]), .B(CIPHERTEXT1[6]), .Z(
        CIPHERTEXT1[54]) );
  XOR2_X1 RF1_MC_U35 ( .A(CIPHERTEXT1[38]), .B(RF1_SHIFTROWS[22]), .Z(
        CIPHERTEXT1[6]) );
  XOR2_X1 RF1_MC_U34 ( .A(RF1_SHIFTROWS[5]), .B(CIPHERTEXT1[5]), .Z(
        CIPHERTEXT1[53]) );
  XOR2_X1 RF1_MC_U33 ( .A(CIPHERTEXT1[37]), .B(RF1_SHIFTROWS[21]), .Z(
        CIPHERTEXT1[5]) );
  XOR2_X1 RF1_MC_U32 ( .A(RF1_SHIFTROWS[4]), .B(CIPHERTEXT1[4]), .Z(
        CIPHERTEXT1[52]) );
  XOR2_X1 RF1_MC_U31 ( .A(RF1_SHIFTROWS[3]), .B(CIPHERTEXT1[3]), .Z(
        CIPHERTEXT1[51]) );
  XOR2_X1 RF1_MC_U30 ( .A(RF1_SHIFTROWS[2]), .B(CIPHERTEXT1[2]), .Z(
        CIPHERTEXT1[50]) );
  XOR2_X1 RF1_MC_U29 ( .A(CIPHERTEXT1[36]), .B(RF1_SHIFTROWS[20]), .Z(
        CIPHERTEXT1[4]) );
  XOR2_X1 RF1_MC_U28 ( .A(RF1_SHIFTROWS[1]), .B(CIPHERTEXT1[1]), .Z(
        CIPHERTEXT1[49]) );
  XOR2_X1 RF1_MC_U27 ( .A(RF1_SHIFTROWS[0]), .B(CIPHERTEXT1[0]), .Z(
        CIPHERTEXT1[48]) );
  XOR2_X1 RF1_MC_U26 ( .A(CIPHERTEXT1[35]), .B(RF1_SHIFTROWS[19]), .Z(
        CIPHERTEXT1[3]) );
  XOR2_X1 RF1_MC_U25 ( .A(RF1_SHIFTROWS[31]), .B(RF1_SHIFTROWS[47]), .Z(
        CIPHERTEXT1[31]) );
  XOR2_X1 RF1_MC_U24 ( .A(RF1_SHIFTROWS[30]), .B(RF1_SHIFTROWS[46]), .Z(
        CIPHERTEXT1[30]) );
  XOR2_X1 RF1_MC_U23 ( .A(CIPHERTEXT1[34]), .B(RF1_SHIFTROWS[18]), .Z(
        CIPHERTEXT1[2]) );
  XOR2_X1 RF1_MC_U22 ( .A(RF1_SHIFTROWS[29]), .B(RF1_SHIFTROWS[45]), .Z(
        CIPHERTEXT1[29]) );
  XOR2_X1 RF1_MC_U21 ( .A(RF1_SHIFTROWS[28]), .B(RF1_SHIFTROWS[44]), .Z(
        CIPHERTEXT1[28]) );
  XOR2_X1 RF1_MC_U20 ( .A(RF1_SHIFTROWS[27]), .B(RF1_SHIFTROWS[43]), .Z(
        CIPHERTEXT1[27]) );
  XOR2_X1 RF1_MC_U19 ( .A(RF1_SHIFTROWS[26]), .B(RF1_SHIFTROWS[42]), .Z(
        CIPHERTEXT1[26]) );
  XOR2_X1 RF1_MC_U18 ( .A(RF1_SHIFTROWS[25]), .B(RF1_SHIFTROWS[41]), .Z(
        CIPHERTEXT1[25]) );
  XOR2_X1 RF1_MC_U17 ( .A(RF1_SHIFTROWS[24]), .B(RF1_SHIFTROWS[40]), .Z(
        CIPHERTEXT1[24]) );
  XOR2_X1 RF1_MC_U16 ( .A(RF1_SHIFTROWS[23]), .B(RF1_SHIFTROWS[39]), .Z(
        CIPHERTEXT1[23]) );
  XOR2_X1 RF1_MC_U15 ( .A(RF1_SHIFTROWS[22]), .B(RF1_SHIFTROWS[38]), .Z(
        CIPHERTEXT1[22]) );
  XOR2_X1 RF1_MC_U14 ( .A(RF1_SHIFTROWS[21]), .B(RF1_SHIFTROWS[37]), .Z(
        CIPHERTEXT1[21]) );
  XOR2_X1 RF1_MC_U13 ( .A(RF1_SHIFTROWS[20]), .B(RF1_SHIFTROWS[36]), .Z(
        CIPHERTEXT1[20]) );
  XOR2_X1 RF1_MC_U12 ( .A(CIPHERTEXT1[33]), .B(RF1_SHIFTROWS[17]), .Z(
        CIPHERTEXT1[1]) );
  XOR2_X1 RF1_MC_U11 ( .A(RF1_SHIFTROWS[19]), .B(RF1_SHIFTROWS[35]), .Z(
        CIPHERTEXT1[19]) );
  XOR2_X1 RF1_MC_U10 ( .A(RF1_SHIFTROWS[18]), .B(RF1_SHIFTROWS[34]), .Z(
        CIPHERTEXT1[18]) );
  XOR2_X1 RF1_MC_U9 ( .A(RF1_SHIFTROWS[17]), .B(RF1_SHIFTROWS[33]), .Z(
        CIPHERTEXT1[17]) );
  XOR2_X1 RF1_MC_U8 ( .A(RF1_SHIFTROWS[16]), .B(RF1_SHIFTROWS[32]), .Z(
        CIPHERTEXT1[16]) );
  XOR2_X1 RF1_MC_U7 ( .A(RF1_SHIFTROWS[31]), .B(CIPHERTEXT1[47]), .Z(
        CIPHERTEXT1[15]) );
  XOR2_X1 RF1_MC_U6 ( .A(RF1_SHIFTROWS[30]), .B(CIPHERTEXT1[46]), .Z(
        CIPHERTEXT1[14]) );
  XOR2_X1 RF1_MC_U5 ( .A(RF1_SHIFTROWS[29]), .B(CIPHERTEXT1[45]), .Z(
        CIPHERTEXT1[13]) );
  XOR2_X1 RF1_MC_U4 ( .A(RF1_SHIFTROWS[28]), .B(CIPHERTEXT1[44]), .Z(
        CIPHERTEXT1[12]) );
  XOR2_X1 RF1_MC_U3 ( .A(RF1_SHIFTROWS[27]), .B(CIPHERTEXT1[43]), .Z(
        CIPHERTEXT1[11]) );
  XOR2_X1 RF1_MC_U2 ( .A(RF1_SHIFTROWS[26]), .B(CIPHERTEXT1[42]), .Z(
        CIPHERTEXT1[10]) );
  XOR2_X1 RF1_MC_U1 ( .A(RF1_SHIFTROWS[16]), .B(CIPHERTEXT1[32]), .Z(
        CIPHERTEXT1[0]) );
  MUX2_X1 RF2_U64 ( .A(CIPHERTEXT2[0]), .B(PLAINTEXT2[0]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_0_InAff_out2[0]) );
  MUX2_X1 RF2_U63 ( .A(CIPHERTEXT2[1]), .B(PLAINTEXT2[1]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_0_InAff_out2[2]) );
  MUX2_X1 RF2_U62 ( .A(CIPHERTEXT2[2]), .B(PLAINTEXT2[2]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_0_InAff_out2[3]) );
  MUX2_X1 RF2_U61 ( .A(CIPHERTEXT2[3]), .B(PLAINTEXT2[3]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_0_InAff_out2[1]) );
  MUX2_X1 RF2_U60 ( .A(CIPHERTEXT2[4]), .B(PLAINTEXT2[4]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_1_InAff_out2[0]) );
  MUX2_X1 RF2_U59 ( .A(CIPHERTEXT2[5]), .B(PLAINTEXT2[5]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_1_InAff_out2[2]) );
  MUX2_X1 RF2_U58 ( .A(CIPHERTEXT2[6]), .B(PLAINTEXT2[6]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_1_InAff_out2[3]) );
  MUX2_X1 RF2_U57 ( .A(CIPHERTEXT2[7]), .B(PLAINTEXT2[7]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_1_InAff_out2[1]) );
  MUX2_X1 RF2_U56 ( .A(CIPHERTEXT2[8]), .B(PLAINTEXT2[8]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_2_InAff_out2[0]) );
  MUX2_X1 RF2_U55 ( .A(CIPHERTEXT2[9]), .B(PLAINTEXT2[9]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_2_InAff_out2[2]) );
  MUX2_X1 RF2_U54 ( .A(CIPHERTEXT2[10]), .B(PLAINTEXT2[10]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_2_InAff_out2[3]) );
  MUX2_X1 RF2_U53 ( .A(CIPHERTEXT2[11]), .B(PLAINTEXT2[11]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_2_InAff_out2[1]) );
  MUX2_X1 RF2_U52 ( .A(CIPHERTEXT2[12]), .B(PLAINTEXT2[12]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_3_InAff_out2[0]) );
  MUX2_X1 RF2_U51 ( .A(CIPHERTEXT2[13]), .B(PLAINTEXT2[13]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_3_InAff_out2[2]) );
  MUX2_X1 RF2_U50 ( .A(CIPHERTEXT2[14]), .B(PLAINTEXT2[14]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_3_InAff_out2[3]) );
  MUX2_X1 RF2_U49 ( .A(CIPHERTEXT2[15]), .B(PLAINTEXT2[15]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_3_InAff_out2[1]) );
  MUX2_X1 RF2_U48 ( .A(CIPHERTEXT2[16]), .B(PLAINTEXT2[16]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_4_InAff_out2[0]) );
  MUX2_X1 RF2_U47 ( .A(CIPHERTEXT2[17]), .B(PLAINTEXT2[17]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_4_InAff_out2[2]) );
  MUX2_X1 RF2_U46 ( .A(CIPHERTEXT2[18]), .B(PLAINTEXT2[18]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_4_InAff_out2[3]) );
  MUX2_X1 RF2_U45 ( .A(CIPHERTEXT2[19]), .B(PLAINTEXT2[19]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_4_InAff_out2[1]) );
  MUX2_X1 RF2_U44 ( .A(CIPHERTEXT2[20]), .B(PLAINTEXT2[20]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_5_InAff_out2[0]) );
  MUX2_X1 RF2_U43 ( .A(CIPHERTEXT2[21]), .B(PLAINTEXT2[21]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_5_InAff_out2[2]) );
  MUX2_X1 RF2_U42 ( .A(CIPHERTEXT2[22]), .B(PLAINTEXT2[22]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_5_InAff_out2[3]) );
  MUX2_X1 RF2_U41 ( .A(CIPHERTEXT2[23]), .B(PLAINTEXT2[23]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_5_InAff_out2[1]) );
  MUX2_X1 RF2_U40 ( .A(CIPHERTEXT2[24]), .B(PLAINTEXT2[24]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_6_InAff_out2[0]) );
  MUX2_X1 RF2_U39 ( .A(CIPHERTEXT2[25]), .B(PLAINTEXT2[25]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_6_InAff_out2[2]) );
  MUX2_X1 RF2_U38 ( .A(CIPHERTEXT2[26]), .B(PLAINTEXT2[26]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_6_InAff_out2[3]) );
  MUX2_X1 RF2_U37 ( .A(CIPHERTEXT2[27]), .B(PLAINTEXT2[27]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_6_InAff_out2[1]) );
  MUX2_X1 RF2_U36 ( .A(CIPHERTEXT2[28]), .B(PLAINTEXT2[28]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_7_InAff_out2[0]) );
  MUX2_X1 RF2_U35 ( .A(CIPHERTEXT2[29]), .B(PLAINTEXT2[29]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_7_InAff_out2[2]) );
  MUX2_X1 RF2_U34 ( .A(CIPHERTEXT2[30]), .B(PLAINTEXT2[30]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_7_InAff_out2[3]) );
  MUX2_X1 RF2_U33 ( .A(CIPHERTEXT2[31]), .B(PLAINTEXT2[31]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_7_InAff_out2[1]) );
  MUX2_X1 RF2_U32 ( .A(CIPHERTEXT2[32]), .B(PLAINTEXT2[32]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_8_InAff_out2[0]) );
  MUX2_X1 RF2_U31 ( .A(CIPHERTEXT2[33]), .B(PLAINTEXT2[33]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_8_InAff_out2[2]) );
  MUX2_X1 RF2_U30 ( .A(CIPHERTEXT2[34]), .B(PLAINTEXT2[34]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_8_InAff_out2[3]) );
  MUX2_X1 RF2_U29 ( .A(CIPHERTEXT2[35]), .B(PLAINTEXT2[35]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_8_InAff_out2[1]) );
  MUX2_X1 RF2_U28 ( .A(CIPHERTEXT2[36]), .B(PLAINTEXT2[36]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_9_InAff_out2[0]) );
  MUX2_X1 RF2_U27 ( .A(CIPHERTEXT2[37]), .B(PLAINTEXT2[37]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_9_InAff_out2[2]) );
  MUX2_X1 RF2_U26 ( .A(CIPHERTEXT2[38]), .B(PLAINTEXT2[38]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_9_InAff_out2[3]) );
  MUX2_X1 RF2_U25 ( .A(CIPHERTEXT2[39]), .B(PLAINTEXT2[39]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_9_InAff_out2[1]) );
  MUX2_X1 RF2_U24 ( .A(CIPHERTEXT2[40]), .B(PLAINTEXT2[40]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_10_InAff_out2[0]) );
  MUX2_X1 RF2_U23 ( .A(CIPHERTEXT2[41]), .B(PLAINTEXT2[41]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_10_InAff_out2[2]) );
  MUX2_X1 RF2_U22 ( .A(CIPHERTEXT2[42]), .B(PLAINTEXT2[42]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_10_InAff_out2[3]) );
  MUX2_X1 RF2_U21 ( .A(CIPHERTEXT2[43]), .B(PLAINTEXT2[43]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_10_InAff_out2[1]) );
  MUX2_X1 RF2_U20 ( .A(CIPHERTEXT2[44]), .B(PLAINTEXT2[44]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_11_InAff_out2[0]) );
  MUX2_X1 RF2_U19 ( .A(CIPHERTEXT2[45]), .B(PLAINTEXT2[45]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_11_InAff_out2[2]) );
  MUX2_X1 RF2_U18 ( .A(CIPHERTEXT2[46]), .B(PLAINTEXT2[46]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_11_InAff_out2[3]) );
  MUX2_X1 RF2_U17 ( .A(CIPHERTEXT2[47]), .B(PLAINTEXT2[47]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_11_InAff_out2[1]) );
  MUX2_X1 RF2_U16 ( .A(CIPHERTEXT2[48]), .B(PLAINTEXT2[48]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_12_InAff_out2[0]) );
  MUX2_X1 RF2_U15 ( .A(CIPHERTEXT2[49]), .B(PLAINTEXT2[49]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_12_InAff_out2[2]) );
  MUX2_X1 RF2_U14 ( .A(CIPHERTEXT2[50]), .B(PLAINTEXT2[50]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_12_InAff_out2[3]) );
  MUX2_X1 RF2_U13 ( .A(CIPHERTEXT2[51]), .B(PLAINTEXT2[51]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_12_InAff_out2[1]) );
  MUX2_X1 RF2_U12 ( .A(CIPHERTEXT2[52]), .B(PLAINTEXT2[52]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_13_InAff_out2[0]) );
  MUX2_X1 RF2_U11 ( .A(CIPHERTEXT2[53]), .B(PLAINTEXT2[53]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_13_InAff_out2[2]) );
  MUX2_X1 RF2_U10 ( .A(CIPHERTEXT2[54]), .B(PLAINTEXT2[54]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_13_InAff_out2[3]) );
  MUX2_X1 RF2_U9 ( .A(CIPHERTEXT2[55]), .B(PLAINTEXT2[55]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_13_InAff_out2[1]) );
  MUX2_X1 RF2_U8 ( .A(CIPHERTEXT2[56]), .B(PLAINTEXT2[56]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_14_InAff_out2[0]) );
  MUX2_X1 RF2_U7 ( .A(CIPHERTEXT2[57]), .B(PLAINTEXT2[57]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_14_InAff_out2[2]) );
  MUX2_X1 RF2_U6 ( .A(CIPHERTEXT2[58]), .B(PLAINTEXT2[58]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_14_InAff_out2[3]) );
  MUX2_X1 RF2_U5 ( .A(CIPHERTEXT2[59]), .B(PLAINTEXT2[59]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_14_InAff_out2[1]) );
  MUX2_X1 RF2_U4 ( .A(CIPHERTEXT2[60]), .B(PLAINTEXT2[60]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_15_InAff_out2[0]) );
  MUX2_X1 RF2_U3 ( .A(CIPHERTEXT2[61]), .B(PLAINTEXT2[61]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_15_InAff_out2[2]) );
  MUX2_X1 RF2_U2 ( .A(CIPHERTEXT2[62]), .B(PLAINTEXT2[62]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_15_InAff_out2[3]) );
  MUX2_X1 RF2_U1 ( .A(CIPHERTEXT2[63]), .B(PLAINTEXT2[63]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_15_InAff_out2[1]) );
  XNOR2_X1 RF2_KA_U39 ( .A(RF2_KA_n18), .B(KE2_KEY_PERM[31]), .ZN(
        CIPHERTEXT2[47]) );
  XNOR2_X1 RF2_KA_U38 ( .A(1'b0), .B(SUB_OUT2[63]), .ZN(RF2_KA_n18) );
  XNOR2_X1 RF2_KA_U37 ( .A(RF2_KA_n17), .B(KE2_KEY_PERM[30]), .ZN(
        CIPHERTEXT2[46]) );
  XNOR2_X1 RF2_KA_U36 ( .A(1'b0), .B(SUB_OUT2[62]), .ZN(RF2_KA_n17) );
  XNOR2_X1 RF2_KA_U35 ( .A(RF2_KA_n16), .B(KE2_KEY_PERM[29]), .ZN(
        CIPHERTEXT2[45]) );
  XNOR2_X1 RF2_KA_U34 ( .A(1'b0), .B(SUB_OUT2[61]), .ZN(RF2_KA_n16) );
  XNOR2_X1 RF2_KA_U33 ( .A(RF2_KA_n15), .B(KE2_KEY_PERM[28]), .ZN(
        CIPHERTEXT2[44]) );
  XNOR2_X1 RF2_KA_U32 ( .A(1'b0), .B(SUB_OUT2[60]), .ZN(RF2_KA_n15) );
  XOR2_X1 RF2_KA_U31 ( .A(SUB_OUT2[59]), .B(KE2_KEY_PERM[27]), .Z(
        CIPHERTEXT2[43]) );
  XOR2_X1 RF2_KA_U30 ( .A(SUB_OUT2[58]), .B(KE2_KEY_PERM[26]), .Z(
        CIPHERTEXT2[42]) );
  XOR2_X1 RF2_KA_U29 ( .A(SUB_OUT2[57]), .B(KE2_KEY_PERM[25]), .Z(
        CIPHERTEXT2[41]) );
  XOR2_X1 RF2_KA_U28 ( .A(SUB_OUT2[56]), .B(KE2_KEY_PERM[24]), .Z(
        CIPHERTEXT2[40]) );
  XOR2_X1 RF2_KA_U27 ( .A(SUB_OUT2[55]), .B(KE2_KEY_PERM[23]), .Z(
        CIPHERTEXT2[39]) );
  XOR2_X1 RF2_KA_U26 ( .A(SUB_OUT2[54]), .B(KE2_KEY_PERM[22]), .Z(
        CIPHERTEXT2[38]) );
  XOR2_X1 RF2_KA_U25 ( .A(SUB_OUT2[53]), .B(KE2_KEY_PERM[21]), .Z(
        CIPHERTEXT2[37]) );
  XOR2_X1 RF2_KA_U24 ( .A(SUB_OUT2[52]), .B(KE2_KEY_PERM[20]), .Z(
        CIPHERTEXT2[36]) );
  XOR2_X1 RF2_KA_U23 ( .A(SUB_OUT2[51]), .B(KE2_KEY_PERM[19]), .Z(
        CIPHERTEXT2[35]) );
  XOR2_X1 RF2_KA_U22 ( .A(SUB_OUT2[50]), .B(KE2_KEY_PERM[18]), .Z(
        CIPHERTEXT2[34]) );
  XOR2_X1 RF2_KA_U21 ( .A(SUB_OUT2[49]), .B(KE2_KEY_PERM[17]), .Z(
        CIPHERTEXT2[33]) );
  XOR2_X1 RF2_KA_U20 ( .A(SUB_OUT2[48]), .B(KE2_KEY_PERM[16]), .Z(
        CIPHERTEXT2[32]) );
  XOR2_X1 RF2_KA_U19 ( .A(SUB_OUT2[47]), .B(KE2_KEY_PERM[15]), .Z(
        RF2_SHIFTROWS[43]) );
  XOR2_X1 RF2_KA_U18 ( .A(SUB_OUT2[46]), .B(KE2_KEY_PERM[14]), .Z(
        RF2_SHIFTROWS[42]) );
  XNOR2_X1 RF2_KA_U17 ( .A(RF2_KA_n14), .B(KE2_KEY_PERM[13]), .ZN(
        RF2_SHIFTROWS[41]) );
  XNOR2_X1 RF2_KA_U16 ( .A(1'b0), .B(SUB_OUT2[45]), .ZN(RF2_KA_n14) );
  XNOR2_X1 RF2_KA_U15 ( .A(RF2_KA_n13), .B(KE2_KEY_PERM[12]), .ZN(
        RF2_SHIFTROWS[40]) );
  XNOR2_X1 RF2_KA_U14 ( .A(1'b0), .B(SUB_OUT2[44]), .ZN(RF2_KA_n13) );
  XOR2_X1 RF2_KA_U13 ( .A(SUB_OUT2[43]), .B(KE2_KEY_PERM[11]), .Z(
        RF2_SHIFTROWS[39]) );
  XOR2_X1 RF2_KA_U12 ( .A(SUB_OUT2[42]), .B(KE2_KEY_PERM[10]), .Z(
        RF2_SHIFTROWS[38]) );
  XOR2_X1 RF2_KA_U11 ( .A(SUB_OUT2[41]), .B(KE2_KEY_PERM[9]), .Z(
        RF2_SHIFTROWS[37]) );
  XOR2_X1 RF2_KA_U10 ( .A(SUB_OUT2[40]), .B(KE2_KEY_PERM[8]), .Z(
        RF2_SHIFTROWS[36]) );
  XOR2_X1 RF2_KA_U9 ( .A(SUB_OUT2[39]), .B(KE2_KEY_PERM[7]), .Z(
        RF2_SHIFTROWS[35]) );
  XOR2_X1 RF2_KA_U8 ( .A(SUB_OUT2[38]), .B(KE2_KEY_PERM[6]), .Z(
        RF2_SHIFTROWS[34]) );
  XOR2_X1 RF2_KA_U7 ( .A(SUB_OUT2[37]), .B(KE2_KEY_PERM[5]), .Z(
        RF2_SHIFTROWS[33]) );
  XOR2_X1 RF2_KA_U6 ( .A(SUB_OUT2[36]), .B(KE2_KEY_PERM[4]), .Z(
        RF2_SHIFTROWS[32]) );
  XOR2_X1 RF2_KA_U5 ( .A(SUB_OUT2[35]), .B(KE2_KEY_PERM[3]), .Z(
        RF2_SHIFTROWS[47]) );
  XOR2_X1 RF2_KA_U4 ( .A(SUB_OUT2[34]), .B(KE2_KEY_PERM[2]), .Z(
        RF2_SHIFTROWS[46]) );
  XOR2_X1 RF2_KA_U3 ( .A(SUB_OUT2[33]), .B(KE2_KEY_PERM[1]), .Z(
        RF2_SHIFTROWS[45]) );
  XOR2_X1 RF2_KA_U2 ( .A(SUB_OUT2[32]), .B(KE2_KEY_PERM[0]), .Z(
        RF2_SHIFTROWS[44]) );
  INV_X1 RF2_KA_U1 ( .A(SUB_OUT2[29]), .ZN(RF2_SHIFTROWS[21]) );
  XOR2_X1 RF2_MC_U48 ( .A(RF2_SHIFTROWS[15]), .B(CIPHERTEXT2[15]), .Z(
        CIPHERTEXT2[63]) );
  XOR2_X1 RF2_MC_U47 ( .A(RF2_SHIFTROWS[14]), .B(CIPHERTEXT2[14]), .Z(
        CIPHERTEXT2[62]) );
  XOR2_X1 RF2_MC_U46 ( .A(RF2_SHIFTROWS[13]), .B(CIPHERTEXT2[13]), .Z(
        CIPHERTEXT2[61]) );
  XOR2_X1 RF2_MC_U45 ( .A(RF2_SHIFTROWS[12]), .B(CIPHERTEXT2[12]), .Z(
        CIPHERTEXT2[60]) );
  XOR2_X1 RF2_MC_U44 ( .A(RF2_SHIFTROWS[11]), .B(CIPHERTEXT2[11]), .Z(
        CIPHERTEXT2[59]) );
  XOR2_X1 RF2_MC_U43 ( .A(RF2_SHIFTROWS[10]), .B(CIPHERTEXT2[10]), .Z(
        CIPHERTEXT2[58]) );
  XOR2_X1 RF2_MC_U42 ( .A(RF2_SHIFTROWS[9]), .B(CIPHERTEXT2[9]), .Z(
        CIPHERTEXT2[57]) );
  XOR2_X1 RF2_MC_U41 ( .A(CIPHERTEXT2[41]), .B(RF2_SHIFTROWS[25]), .Z(
        CIPHERTEXT2[9]) );
  XOR2_X1 RF2_MC_U40 ( .A(RF2_SHIFTROWS[8]), .B(CIPHERTEXT2[8]), .Z(
        CIPHERTEXT2[56]) );
  XOR2_X1 RF2_MC_U39 ( .A(CIPHERTEXT2[40]), .B(RF2_SHIFTROWS[24]), .Z(
        CIPHERTEXT2[8]) );
  XOR2_X1 RF2_MC_U38 ( .A(RF2_SHIFTROWS[7]), .B(CIPHERTEXT2[7]), .Z(
        CIPHERTEXT2[55]) );
  XOR2_X1 RF2_MC_U37 ( .A(CIPHERTEXT2[39]), .B(RF2_SHIFTROWS[23]), .Z(
        CIPHERTEXT2[7]) );
  XOR2_X1 RF2_MC_U36 ( .A(RF2_SHIFTROWS[6]), .B(CIPHERTEXT2[6]), .Z(
        CIPHERTEXT2[54]) );
  XOR2_X1 RF2_MC_U35 ( .A(CIPHERTEXT2[38]), .B(RF2_SHIFTROWS[22]), .Z(
        CIPHERTEXT2[6]) );
  XOR2_X1 RF2_MC_U34 ( .A(RF2_SHIFTROWS[5]), .B(CIPHERTEXT2[5]), .Z(
        CIPHERTEXT2[53]) );
  XOR2_X1 RF2_MC_U33 ( .A(CIPHERTEXT2[37]), .B(RF2_SHIFTROWS[21]), .Z(
        CIPHERTEXT2[5]) );
  XOR2_X1 RF2_MC_U32 ( .A(RF2_SHIFTROWS[4]), .B(CIPHERTEXT2[4]), .Z(
        CIPHERTEXT2[52]) );
  XOR2_X1 RF2_MC_U31 ( .A(RF2_SHIFTROWS[3]), .B(CIPHERTEXT2[3]), .Z(
        CIPHERTEXT2[51]) );
  XOR2_X1 RF2_MC_U30 ( .A(RF2_SHIFTROWS[2]), .B(CIPHERTEXT2[2]), .Z(
        CIPHERTEXT2[50]) );
  XOR2_X1 RF2_MC_U29 ( .A(CIPHERTEXT2[36]), .B(RF2_SHIFTROWS[20]), .Z(
        CIPHERTEXT2[4]) );
  XOR2_X1 RF2_MC_U28 ( .A(RF2_SHIFTROWS[1]), .B(CIPHERTEXT2[1]), .Z(
        CIPHERTEXT2[49]) );
  XOR2_X1 RF2_MC_U27 ( .A(RF2_SHIFTROWS[0]), .B(CIPHERTEXT2[0]), .Z(
        CIPHERTEXT2[48]) );
  XOR2_X1 RF2_MC_U26 ( .A(CIPHERTEXT2[35]), .B(RF2_SHIFTROWS[19]), .Z(
        CIPHERTEXT2[3]) );
  XOR2_X1 RF2_MC_U25 ( .A(RF2_SHIFTROWS[31]), .B(RF2_SHIFTROWS[47]), .Z(
        CIPHERTEXT2[31]) );
  XOR2_X1 RF2_MC_U24 ( .A(RF2_SHIFTROWS[30]), .B(RF2_SHIFTROWS[46]), .Z(
        CIPHERTEXT2[30]) );
  XOR2_X1 RF2_MC_U23 ( .A(CIPHERTEXT2[34]), .B(RF2_SHIFTROWS[18]), .Z(
        CIPHERTEXT2[2]) );
  XOR2_X1 RF2_MC_U22 ( .A(RF2_SHIFTROWS[29]), .B(RF2_SHIFTROWS[45]), .Z(
        CIPHERTEXT2[29]) );
  XOR2_X1 RF2_MC_U21 ( .A(RF2_SHIFTROWS[28]), .B(RF2_SHIFTROWS[44]), .Z(
        CIPHERTEXT2[28]) );
  XOR2_X1 RF2_MC_U20 ( .A(RF2_SHIFTROWS[27]), .B(RF2_SHIFTROWS[43]), .Z(
        CIPHERTEXT2[27]) );
  XOR2_X1 RF2_MC_U19 ( .A(RF2_SHIFTROWS[26]), .B(RF2_SHIFTROWS[42]), .Z(
        CIPHERTEXT2[26]) );
  XOR2_X1 RF2_MC_U18 ( .A(RF2_SHIFTROWS[25]), .B(RF2_SHIFTROWS[41]), .Z(
        CIPHERTEXT2[25]) );
  XOR2_X1 RF2_MC_U17 ( .A(RF2_SHIFTROWS[24]), .B(RF2_SHIFTROWS[40]), .Z(
        CIPHERTEXT2[24]) );
  XOR2_X1 RF2_MC_U16 ( .A(RF2_SHIFTROWS[23]), .B(RF2_SHIFTROWS[39]), .Z(
        CIPHERTEXT2[23]) );
  XOR2_X1 RF2_MC_U15 ( .A(RF2_SHIFTROWS[22]), .B(RF2_SHIFTROWS[38]), .Z(
        CIPHERTEXT2[22]) );
  XOR2_X1 RF2_MC_U14 ( .A(RF2_SHIFTROWS[21]), .B(RF2_SHIFTROWS[37]), .Z(
        CIPHERTEXT2[21]) );
  XOR2_X1 RF2_MC_U13 ( .A(RF2_SHIFTROWS[20]), .B(RF2_SHIFTROWS[36]), .Z(
        CIPHERTEXT2[20]) );
  XOR2_X1 RF2_MC_U12 ( .A(CIPHERTEXT2[33]), .B(RF2_SHIFTROWS[17]), .Z(
        CIPHERTEXT2[1]) );
  XOR2_X1 RF2_MC_U11 ( .A(RF2_SHIFTROWS[19]), .B(RF2_SHIFTROWS[35]), .Z(
        CIPHERTEXT2[19]) );
  XOR2_X1 RF2_MC_U10 ( .A(RF2_SHIFTROWS[18]), .B(RF2_SHIFTROWS[34]), .Z(
        CIPHERTEXT2[18]) );
  XOR2_X1 RF2_MC_U9 ( .A(RF2_SHIFTROWS[17]), .B(RF2_SHIFTROWS[33]), .Z(
        CIPHERTEXT2[17]) );
  XOR2_X1 RF2_MC_U8 ( .A(RF2_SHIFTROWS[16]), .B(RF2_SHIFTROWS[32]), .Z(
        CIPHERTEXT2[16]) );
  XOR2_X1 RF2_MC_U7 ( .A(RF2_SHIFTROWS[31]), .B(CIPHERTEXT2[47]), .Z(
        CIPHERTEXT2[15]) );
  XOR2_X1 RF2_MC_U6 ( .A(RF2_SHIFTROWS[30]), .B(CIPHERTEXT2[46]), .Z(
        CIPHERTEXT2[14]) );
  XOR2_X1 RF2_MC_U5 ( .A(RF2_SHIFTROWS[29]), .B(CIPHERTEXT2[45]), .Z(
        CIPHERTEXT2[13]) );
  XOR2_X1 RF2_MC_U4 ( .A(RF2_SHIFTROWS[28]), .B(CIPHERTEXT2[44]), .Z(
        CIPHERTEXT2[12]) );
  XOR2_X1 RF2_MC_U3 ( .A(RF2_SHIFTROWS[27]), .B(CIPHERTEXT2[43]), .Z(
        CIPHERTEXT2[11]) );
  XOR2_X1 RF2_MC_U2 ( .A(RF2_SHIFTROWS[26]), .B(CIPHERTEXT2[42]), .Z(
        CIPHERTEXT2[10]) );
  XOR2_X1 RF2_MC_U1 ( .A(RF2_SHIFTROWS[16]), .B(CIPHERTEXT2[32]), .Z(
        CIPHERTEXT2[0]) );
  MUX2_X1 RF3_U64 ( .A(CIPHERTEXT3[0]), .B(PLAINTEXT3[0]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_0_InAff_out3[0]) );
  MUX2_X1 RF3_U63 ( .A(CIPHERTEXT3[1]), .B(PLAINTEXT3[1]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_0_InAff_out3[2]) );
  MUX2_X1 RF3_U62 ( .A(CIPHERTEXT3[2]), .B(PLAINTEXT3[2]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_0_InAff_out3[3]) );
  MUX2_X1 RF3_U61 ( .A(CIPHERTEXT3[3]), .B(PLAINTEXT3[3]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_0_InAff_out3[1]) );
  MUX2_X1 RF3_U60 ( .A(CIPHERTEXT3[4]), .B(PLAINTEXT3[4]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_1_InAff_out3[0]) );
  MUX2_X1 RF3_U59 ( .A(CIPHERTEXT3[5]), .B(PLAINTEXT3[5]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_1_InAff_out3[2]) );
  MUX2_X1 RF3_U58 ( .A(CIPHERTEXT3[6]), .B(PLAINTEXT3[6]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_1_InAff_out3[3]) );
  MUX2_X1 RF3_U57 ( .A(CIPHERTEXT3[7]), .B(PLAINTEXT3[7]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_1_InAff_out3[1]) );
  MUX2_X1 RF3_U56 ( .A(CIPHERTEXT3[8]), .B(PLAINTEXT3[8]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_2_InAff_out3[0]) );
  MUX2_X1 RF3_U55 ( .A(CIPHERTEXT3[9]), .B(PLAINTEXT3[9]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_2_InAff_out3[2]) );
  MUX2_X1 RF3_U54 ( .A(CIPHERTEXT3[10]), .B(PLAINTEXT3[10]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_2_InAff_out3[3]) );
  MUX2_X1 RF3_U53 ( .A(CIPHERTEXT3[11]), .B(PLAINTEXT3[11]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_2_InAff_out3[1]) );
  MUX2_X1 RF3_U52 ( .A(CIPHERTEXT3[12]), .B(PLAINTEXT3[12]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_3_InAff_out3[0]) );
  MUX2_X1 RF3_U51 ( .A(CIPHERTEXT3[13]), .B(PLAINTEXT3[13]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_3_InAff_out3[2]) );
  MUX2_X1 RF3_U50 ( .A(CIPHERTEXT3[14]), .B(PLAINTEXT3[14]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_3_InAff_out3[3]) );
  MUX2_X1 RF3_U49 ( .A(CIPHERTEXT3[15]), .B(PLAINTEXT3[15]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_3_InAff_out3[1]) );
  MUX2_X1 RF3_U48 ( .A(CIPHERTEXT3[16]), .B(PLAINTEXT3[16]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_4_InAff_out3[0]) );
  MUX2_X1 RF3_U47 ( .A(CIPHERTEXT3[17]), .B(PLAINTEXT3[17]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_4_InAff_out3[2]) );
  MUX2_X1 RF3_U46 ( .A(CIPHERTEXT3[18]), .B(PLAINTEXT3[18]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_4_InAff_out3[3]) );
  MUX2_X1 RF3_U45 ( .A(CIPHERTEXT3[19]), .B(PLAINTEXT3[19]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_4_InAff_out3[1]) );
  MUX2_X1 RF3_U44 ( .A(CIPHERTEXT3[20]), .B(PLAINTEXT3[20]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_5_InAff_out3[0]) );
  MUX2_X1 RF3_U43 ( .A(CIPHERTEXT3[21]), .B(PLAINTEXT3[21]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_5_InAff_out3[2]) );
  MUX2_X1 RF3_U42 ( .A(CIPHERTEXT3[22]), .B(PLAINTEXT3[22]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_5_InAff_out3[3]) );
  MUX2_X1 RF3_U41 ( .A(CIPHERTEXT3[23]), .B(PLAINTEXT3[23]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_5_InAff_out3[1]) );
  MUX2_X1 RF3_U40 ( .A(CIPHERTEXT3[24]), .B(PLAINTEXT3[24]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_6_InAff_out3[0]) );
  MUX2_X1 RF3_U39 ( .A(CIPHERTEXT3[25]), .B(PLAINTEXT3[25]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_6_InAff_out3[2]) );
  MUX2_X1 RF3_U38 ( .A(CIPHERTEXT3[26]), .B(PLAINTEXT3[26]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_6_InAff_out3[3]) );
  MUX2_X1 RF3_U37 ( .A(CIPHERTEXT3[27]), .B(PLAINTEXT3[27]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_6_InAff_out3[1]) );
  MUX2_X1 RF3_U36 ( .A(CIPHERTEXT3[28]), .B(PLAINTEXT3[28]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_7_InAff_out3[0]) );
  MUX2_X1 RF3_U35 ( .A(CIPHERTEXT3[29]), .B(PLAINTEXT3[29]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_7_InAff_out3[2]) );
  MUX2_X1 RF3_U34 ( .A(CIPHERTEXT3[30]), .B(PLAINTEXT3[30]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_7_InAff_out3[3]) );
  MUX2_X1 RF3_U33 ( .A(CIPHERTEXT3[31]), .B(PLAINTEXT3[31]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_7_InAff_out3[1]) );
  MUX2_X1 RF3_U32 ( .A(CIPHERTEXT3[32]), .B(PLAINTEXT3[32]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_8_InAff_out3[0]) );
  MUX2_X1 RF3_U31 ( .A(CIPHERTEXT3[33]), .B(PLAINTEXT3[33]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_8_InAff_out3[2]) );
  MUX2_X1 RF3_U30 ( .A(CIPHERTEXT3[34]), .B(PLAINTEXT3[34]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_8_InAff_out3[3]) );
  MUX2_X1 RF3_U29 ( .A(CIPHERTEXT3[35]), .B(PLAINTEXT3[35]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_8_InAff_out3[1]) );
  MUX2_X1 RF3_U28 ( .A(CIPHERTEXT3[36]), .B(PLAINTEXT3[36]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_9_InAff_out3[0]) );
  MUX2_X1 RF3_U27 ( .A(CIPHERTEXT3[37]), .B(PLAINTEXT3[37]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_9_InAff_out3[2]) );
  MUX2_X1 RF3_U26 ( .A(CIPHERTEXT3[38]), .B(PLAINTEXT3[38]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_9_InAff_out3[3]) );
  MUX2_X1 RF3_U25 ( .A(CIPHERTEXT3[39]), .B(PLAINTEXT3[39]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_9_InAff_out3[1]) );
  MUX2_X1 RF3_U24 ( .A(CIPHERTEXT3[40]), .B(PLAINTEXT3[40]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_10_InAff_out3[0]) );
  MUX2_X1 RF3_U23 ( .A(CIPHERTEXT3[41]), .B(PLAINTEXT3[41]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_10_InAff_out3[2]) );
  MUX2_X1 RF3_U22 ( .A(CIPHERTEXT3[42]), .B(PLAINTEXT3[42]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_10_InAff_out3[3]) );
  MUX2_X1 RF3_U21 ( .A(CIPHERTEXT3[43]), .B(PLAINTEXT3[43]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_10_InAff_out3[1]) );
  MUX2_X1 RF3_U20 ( .A(CIPHERTEXT3[44]), .B(PLAINTEXT3[44]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_11_InAff_out3[0]) );
  MUX2_X1 RF3_U19 ( .A(CIPHERTEXT3[45]), .B(PLAINTEXT3[45]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_11_InAff_out3[2]) );
  MUX2_X1 RF3_U18 ( .A(CIPHERTEXT3[46]), .B(PLAINTEXT3[46]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_11_InAff_out3[3]) );
  MUX2_X1 RF3_U17 ( .A(CIPHERTEXT3[47]), .B(PLAINTEXT3[47]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_11_InAff_out3[1]) );
  MUX2_X1 RF3_U16 ( .A(CIPHERTEXT3[48]), .B(PLAINTEXT3[48]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_12_InAff_out3[0]) );
  MUX2_X1 RF3_U15 ( .A(CIPHERTEXT3[49]), .B(PLAINTEXT3[49]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_12_InAff_out3[2]) );
  MUX2_X1 RF3_U14 ( .A(CIPHERTEXT3[50]), .B(PLAINTEXT3[50]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_12_InAff_out3[3]) );
  MUX2_X1 RF3_U13 ( .A(CIPHERTEXT3[51]), .B(PLAINTEXT3[51]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_12_InAff_out3[1]) );
  MUX2_X1 RF3_U12 ( .A(CIPHERTEXT3[52]), .B(PLAINTEXT3[52]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_13_InAff_out3[0]) );
  MUX2_X1 RF3_U11 ( .A(CIPHERTEXT3[53]), .B(PLAINTEXT3[53]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_13_InAff_out3[2]) );
  MUX2_X1 RF3_U10 ( .A(CIPHERTEXT3[54]), .B(PLAINTEXT3[54]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_13_InAff_out3[3]) );
  MUX2_X1 RF3_U9 ( .A(CIPHERTEXT3[55]), .B(PLAINTEXT3[55]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_13_InAff_out3[1]) );
  MUX2_X1 RF3_U8 ( .A(CIPHERTEXT3[56]), .B(PLAINTEXT3[56]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_14_InAff_out3[0]) );
  MUX2_X1 RF3_U7 ( .A(CIPHERTEXT3[57]), .B(PLAINTEXT3[57]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_14_InAff_out3[2]) );
  MUX2_X1 RF3_U6 ( .A(CIPHERTEXT3[58]), .B(PLAINTEXT3[58]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_14_InAff_out3[3]) );
  MUX2_X1 RF3_U5 ( .A(CIPHERTEXT3[59]), .B(PLAINTEXT3[59]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_14_InAff_out3[1]) );
  MUX2_X1 RF3_U4 ( .A(CIPHERTEXT3[60]), .B(PLAINTEXT3[60]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_15_InAff_out3[0]) );
  MUX2_X1 RF3_U3 ( .A(CIPHERTEXT3[61]), .B(PLAINTEXT3[61]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_15_InAff_out3[2]) );
  MUX2_X1 RF3_U2 ( .A(CIPHERTEXT3[62]), .B(PLAINTEXT3[62]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_15_InAff_out3[3]) );
  MUX2_X1 RF3_U1 ( .A(CIPHERTEXT3[63]), .B(PLAINTEXT3[63]), .S(RESET), .Z(
        Inst_SKINNY_Sbox_15_InAff_out3[1]) );
  INV_X1 RF3_KA_U39 ( .A(SUB_OUT3[29]), .ZN(RF3_SHIFTROWS[21]) );
  XNOR2_X1 RF3_KA_U38 ( .A(RF3_KA_n18), .B(KE3_KEY_PERM[31]), .ZN(
        CIPHERTEXT3[47]) );
  XNOR2_X1 RF3_KA_U37 ( .A(1'b0), .B(SUB_OUT3[63]), .ZN(RF3_KA_n18) );
  XNOR2_X1 RF3_KA_U36 ( .A(RF3_KA_n17), .B(KE3_KEY_PERM[30]), .ZN(
        CIPHERTEXT3[46]) );
  XNOR2_X1 RF3_KA_U35 ( .A(1'b0), .B(SUB_OUT3[62]), .ZN(RF3_KA_n17) );
  XNOR2_X1 RF3_KA_U34 ( .A(RF3_KA_n16), .B(KE3_KEY_PERM[29]), .ZN(
        CIPHERTEXT3[45]) );
  XNOR2_X1 RF3_KA_U33 ( .A(1'b0), .B(SUB_OUT3[61]), .ZN(RF3_KA_n16) );
  XNOR2_X1 RF3_KA_U32 ( .A(RF3_KA_n15), .B(KE3_KEY_PERM[28]), .ZN(
        CIPHERTEXT3[44]) );
  XNOR2_X1 RF3_KA_U31 ( .A(1'b0), .B(SUB_OUT3[60]), .ZN(RF3_KA_n15) );
  XOR2_X1 RF3_KA_U30 ( .A(SUB_OUT3[59]), .B(KE3_KEY_PERM[27]), .Z(
        CIPHERTEXT3[43]) );
  XOR2_X1 RF3_KA_U29 ( .A(SUB_OUT3[58]), .B(KE3_KEY_PERM[26]), .Z(
        CIPHERTEXT3[42]) );
  XOR2_X1 RF3_KA_U28 ( .A(SUB_OUT3[57]), .B(KE3_KEY_PERM[25]), .Z(
        CIPHERTEXT3[41]) );
  XOR2_X1 RF3_KA_U27 ( .A(SUB_OUT3[56]), .B(KE3_KEY_PERM[24]), .Z(
        CIPHERTEXT3[40]) );
  XOR2_X1 RF3_KA_U26 ( .A(SUB_OUT3[55]), .B(KE3_KEY_PERM[23]), .Z(
        CIPHERTEXT3[39]) );
  XOR2_X1 RF3_KA_U25 ( .A(SUB_OUT3[54]), .B(KE3_KEY_PERM[22]), .Z(
        CIPHERTEXT3[38]) );
  XOR2_X1 RF3_KA_U24 ( .A(SUB_OUT3[53]), .B(KE3_KEY_PERM[21]), .Z(
        CIPHERTEXT3[37]) );
  XOR2_X1 RF3_KA_U23 ( .A(SUB_OUT3[52]), .B(KE3_KEY_PERM[20]), .Z(
        CIPHERTEXT3[36]) );
  XOR2_X1 RF3_KA_U22 ( .A(SUB_OUT3[51]), .B(KE3_KEY_PERM[19]), .Z(
        CIPHERTEXT3[35]) );
  XOR2_X1 RF3_KA_U21 ( .A(SUB_OUT3[50]), .B(KE3_KEY_PERM[18]), .Z(
        CIPHERTEXT3[34]) );
  XOR2_X1 RF3_KA_U20 ( .A(SUB_OUT3[49]), .B(KE3_KEY_PERM[17]), .Z(
        CIPHERTEXT3[33]) );
  XOR2_X1 RF3_KA_U19 ( .A(SUB_OUT3[48]), .B(KE3_KEY_PERM[16]), .Z(
        CIPHERTEXT3[32]) );
  XOR2_X1 RF3_KA_U18 ( .A(SUB_OUT3[47]), .B(KE3_KEY_PERM[15]), .Z(
        RF3_SHIFTROWS[43]) );
  XOR2_X1 RF3_KA_U17 ( .A(SUB_OUT3[46]), .B(KE3_KEY_PERM[14]), .Z(
        RF3_SHIFTROWS[42]) );
  XNOR2_X1 RF3_KA_U16 ( .A(RF3_KA_n14), .B(KE3_KEY_PERM[13]), .ZN(
        RF3_SHIFTROWS[41]) );
  XNOR2_X1 RF3_KA_U15 ( .A(1'b0), .B(SUB_OUT3[45]), .ZN(RF3_KA_n14) );
  XNOR2_X1 RF3_KA_U14 ( .A(RF3_KA_n13), .B(KE3_KEY_PERM[12]), .ZN(
        RF3_SHIFTROWS[40]) );
  XNOR2_X1 RF3_KA_U13 ( .A(1'b0), .B(SUB_OUT3[44]), .ZN(RF3_KA_n13) );
  XOR2_X1 RF3_KA_U12 ( .A(SUB_OUT3[43]), .B(KE3_KEY_PERM[11]), .Z(
        RF3_SHIFTROWS[39]) );
  XOR2_X1 RF3_KA_U11 ( .A(SUB_OUT3[42]), .B(KE3_KEY_PERM[10]), .Z(
        RF3_SHIFTROWS[38]) );
  XOR2_X1 RF3_KA_U10 ( .A(SUB_OUT3[41]), .B(KE3_KEY_PERM[9]), .Z(
        RF3_SHIFTROWS[37]) );
  XOR2_X1 RF3_KA_U9 ( .A(SUB_OUT3[40]), .B(KE3_KEY_PERM[8]), .Z(
        RF3_SHIFTROWS[36]) );
  XOR2_X1 RF3_KA_U8 ( .A(SUB_OUT3[39]), .B(KE3_KEY_PERM[7]), .Z(
        RF3_SHIFTROWS[35]) );
  XOR2_X1 RF3_KA_U7 ( .A(SUB_OUT3[38]), .B(KE3_KEY_PERM[6]), .Z(
        RF3_SHIFTROWS[34]) );
  XOR2_X1 RF3_KA_U6 ( .A(SUB_OUT3[37]), .B(KE3_KEY_PERM[5]), .Z(
        RF3_SHIFTROWS[33]) );
  XOR2_X1 RF3_KA_U5 ( .A(SUB_OUT3[36]), .B(KE3_KEY_PERM[4]), .Z(
        RF3_SHIFTROWS[32]) );
  XOR2_X1 RF3_KA_U4 ( .A(SUB_OUT3[35]), .B(KE3_KEY_PERM[3]), .Z(
        RF3_SHIFTROWS[47]) );
  XOR2_X1 RF3_KA_U3 ( .A(SUB_OUT3[34]), .B(KE3_KEY_PERM[2]), .Z(
        RF3_SHIFTROWS[46]) );
  XOR2_X1 RF3_KA_U2 ( .A(SUB_OUT3[33]), .B(KE3_KEY_PERM[1]), .Z(
        RF3_SHIFTROWS[45]) );
  XOR2_X1 RF3_KA_U1 ( .A(SUB_OUT3[32]), .B(KE3_KEY_PERM[0]), .Z(
        RF3_SHIFTROWS[44]) );
  XOR2_X1 RF3_MC_U48 ( .A(RF3_SHIFTROWS[15]), .B(CIPHERTEXT3[15]), .Z(
        CIPHERTEXT3[63]) );
  XOR2_X1 RF3_MC_U47 ( .A(RF3_SHIFTROWS[14]), .B(CIPHERTEXT3[14]), .Z(
        CIPHERTEXT3[62]) );
  XOR2_X1 RF3_MC_U46 ( .A(RF3_SHIFTROWS[13]), .B(CIPHERTEXT3[13]), .Z(
        CIPHERTEXT3[61]) );
  XOR2_X1 RF3_MC_U45 ( .A(RF3_SHIFTROWS[12]), .B(CIPHERTEXT3[12]), .Z(
        CIPHERTEXT3[60]) );
  XOR2_X1 RF3_MC_U44 ( .A(RF3_SHIFTROWS[11]), .B(CIPHERTEXT3[11]), .Z(
        CIPHERTEXT3[59]) );
  XOR2_X1 RF3_MC_U43 ( .A(RF3_SHIFTROWS[10]), .B(CIPHERTEXT3[10]), .Z(
        CIPHERTEXT3[58]) );
  XOR2_X1 RF3_MC_U42 ( .A(RF3_SHIFTROWS[9]), .B(CIPHERTEXT3[9]), .Z(
        CIPHERTEXT3[57]) );
  XOR2_X1 RF3_MC_U41 ( .A(CIPHERTEXT3[41]), .B(RF3_SHIFTROWS[25]), .Z(
        CIPHERTEXT3[9]) );
  XOR2_X1 RF3_MC_U40 ( .A(RF3_SHIFTROWS[8]), .B(CIPHERTEXT3[8]), .Z(
        CIPHERTEXT3[56]) );
  XOR2_X1 RF3_MC_U39 ( .A(CIPHERTEXT3[40]), .B(RF3_SHIFTROWS[24]), .Z(
        CIPHERTEXT3[8]) );
  XOR2_X1 RF3_MC_U38 ( .A(RF3_SHIFTROWS[7]), .B(CIPHERTEXT3[7]), .Z(
        CIPHERTEXT3[55]) );
  XOR2_X1 RF3_MC_U37 ( .A(CIPHERTEXT3[39]), .B(RF3_SHIFTROWS[23]), .Z(
        CIPHERTEXT3[7]) );
  XOR2_X1 RF3_MC_U36 ( .A(RF3_SHIFTROWS[6]), .B(CIPHERTEXT3[6]), .Z(
        CIPHERTEXT3[54]) );
  XOR2_X1 RF3_MC_U35 ( .A(CIPHERTEXT3[38]), .B(RF3_SHIFTROWS[22]), .Z(
        CIPHERTEXT3[6]) );
  XOR2_X1 RF3_MC_U34 ( .A(RF3_SHIFTROWS[5]), .B(CIPHERTEXT3[5]), .Z(
        CIPHERTEXT3[53]) );
  XOR2_X1 RF3_MC_U33 ( .A(CIPHERTEXT3[37]), .B(RF3_SHIFTROWS[21]), .Z(
        CIPHERTEXT3[5]) );
  XOR2_X1 RF3_MC_U32 ( .A(RF3_SHIFTROWS[4]), .B(CIPHERTEXT3[4]), .Z(
        CIPHERTEXT3[52]) );
  XOR2_X1 RF3_MC_U31 ( .A(RF3_SHIFTROWS[3]), .B(CIPHERTEXT3[3]), .Z(
        CIPHERTEXT3[51]) );
  XOR2_X1 RF3_MC_U30 ( .A(RF3_SHIFTROWS[2]), .B(CIPHERTEXT3[2]), .Z(
        CIPHERTEXT3[50]) );
  XOR2_X1 RF3_MC_U29 ( .A(CIPHERTEXT3[36]), .B(RF3_SHIFTROWS[20]), .Z(
        CIPHERTEXT3[4]) );
  XOR2_X1 RF3_MC_U28 ( .A(RF3_SHIFTROWS[1]), .B(CIPHERTEXT3[1]), .Z(
        CIPHERTEXT3[49]) );
  XOR2_X1 RF3_MC_U27 ( .A(RF3_SHIFTROWS[0]), .B(CIPHERTEXT3[0]), .Z(
        CIPHERTEXT3[48]) );
  XOR2_X1 RF3_MC_U26 ( .A(CIPHERTEXT3[35]), .B(RF3_SHIFTROWS[19]), .Z(
        CIPHERTEXT3[3]) );
  XOR2_X1 RF3_MC_U25 ( .A(RF3_SHIFTROWS[31]), .B(RF3_SHIFTROWS[47]), .Z(
        CIPHERTEXT3[31]) );
  XOR2_X1 RF3_MC_U24 ( .A(RF3_SHIFTROWS[30]), .B(RF3_SHIFTROWS[46]), .Z(
        CIPHERTEXT3[30]) );
  XOR2_X1 RF3_MC_U23 ( .A(CIPHERTEXT3[34]), .B(RF3_SHIFTROWS[18]), .Z(
        CIPHERTEXT3[2]) );
  XOR2_X1 RF3_MC_U22 ( .A(RF3_SHIFTROWS[29]), .B(RF3_SHIFTROWS[45]), .Z(
        CIPHERTEXT3[29]) );
  XOR2_X1 RF3_MC_U21 ( .A(RF3_SHIFTROWS[28]), .B(RF3_SHIFTROWS[44]), .Z(
        CIPHERTEXT3[28]) );
  XOR2_X1 RF3_MC_U20 ( .A(RF3_SHIFTROWS[27]), .B(RF3_SHIFTROWS[43]), .Z(
        CIPHERTEXT3[27]) );
  XOR2_X1 RF3_MC_U19 ( .A(RF3_SHIFTROWS[26]), .B(RF3_SHIFTROWS[42]), .Z(
        CIPHERTEXT3[26]) );
  XOR2_X1 RF3_MC_U18 ( .A(RF3_SHIFTROWS[25]), .B(RF3_SHIFTROWS[41]), .Z(
        CIPHERTEXT3[25]) );
  XOR2_X1 RF3_MC_U17 ( .A(RF3_SHIFTROWS[24]), .B(RF3_SHIFTROWS[40]), .Z(
        CIPHERTEXT3[24]) );
  XOR2_X1 RF3_MC_U16 ( .A(RF3_SHIFTROWS[23]), .B(RF3_SHIFTROWS[39]), .Z(
        CIPHERTEXT3[23]) );
  XOR2_X1 RF3_MC_U15 ( .A(RF3_SHIFTROWS[22]), .B(RF3_SHIFTROWS[38]), .Z(
        CIPHERTEXT3[22]) );
  XOR2_X1 RF3_MC_U14 ( .A(RF3_SHIFTROWS[21]), .B(RF3_SHIFTROWS[37]), .Z(
        CIPHERTEXT3[21]) );
  XOR2_X1 RF3_MC_U13 ( .A(RF3_SHIFTROWS[20]), .B(RF3_SHIFTROWS[36]), .Z(
        CIPHERTEXT3[20]) );
  XOR2_X1 RF3_MC_U12 ( .A(CIPHERTEXT3[33]), .B(RF3_SHIFTROWS[17]), .Z(
        CIPHERTEXT3[1]) );
  XOR2_X1 RF3_MC_U11 ( .A(RF3_SHIFTROWS[19]), .B(RF3_SHIFTROWS[35]), .Z(
        CIPHERTEXT3[19]) );
  XOR2_X1 RF3_MC_U10 ( .A(RF3_SHIFTROWS[18]), .B(RF3_SHIFTROWS[34]), .Z(
        CIPHERTEXT3[18]) );
  XOR2_X1 RF3_MC_U9 ( .A(RF3_SHIFTROWS[17]), .B(RF3_SHIFTROWS[33]), .Z(
        CIPHERTEXT3[17]) );
  XOR2_X1 RF3_MC_U8 ( .A(RF3_SHIFTROWS[16]), .B(RF3_SHIFTROWS[32]), .Z(
        CIPHERTEXT3[16]) );
  XOR2_X1 RF3_MC_U7 ( .A(RF3_SHIFTROWS[31]), .B(CIPHERTEXT3[47]), .Z(
        CIPHERTEXT3[15]) );
  XOR2_X1 RF3_MC_U6 ( .A(RF3_SHIFTROWS[30]), .B(CIPHERTEXT3[46]), .Z(
        CIPHERTEXT3[14]) );
  XOR2_X1 RF3_MC_U5 ( .A(RF3_SHIFTROWS[29]), .B(CIPHERTEXT3[45]), .Z(
        CIPHERTEXT3[13]) );
  XOR2_X1 RF3_MC_U4 ( .A(RF3_SHIFTROWS[28]), .B(CIPHERTEXT3[44]), .Z(
        CIPHERTEXT3[12]) );
  XOR2_X1 RF3_MC_U3 ( .A(RF3_SHIFTROWS[27]), .B(CIPHERTEXT3[43]), .Z(
        CIPHERTEXT3[11]) );
  XOR2_X1 RF3_MC_U2 ( .A(RF3_SHIFTROWS[26]), .B(CIPHERTEXT3[42]), .Z(
        CIPHERTEXT3[10]) );
  XOR2_X1 RF3_MC_U1 ( .A(RF3_SHIFTROWS[16]), .B(CIPHERTEXT3[32]), .Z(
        CIPHERTEXT3[0]) );
  XNOR2_X1 Inst_SKINNY_Sbox_0_U18 ( .A(Inst_SKINNY_Sbox_0_n4), .B(FRESH[31]), 
        .ZN(RF3_SHIFTROWS[7]) );
  XNOR2_X1 Inst_SKINNY_Sbox_0_U17 ( .A(FRESH[27]), .B(
        Inst_SKINNY_Sbox_0_OutAff_out3[3]), .ZN(Inst_SKINNY_Sbox_0_n4) );
  XNOR2_X1 Inst_SKINNY_Sbox_0_U16 ( .A(Inst_SKINNY_Sbox_0_n3), .B(FRESH[30]), 
        .ZN(RF3_SHIFTROWS[6]) );
  XNOR2_X1 Inst_SKINNY_Sbox_0_U15 ( .A(FRESH[26]), .B(
        Inst_SKINNY_Sbox_0_OutAff_out3[2]), .ZN(Inst_SKINNY_Sbox_0_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_0_U14 ( .A(Inst_SKINNY_Sbox_0_n2), .B(FRESH[29]), 
        .ZN(RF3_SHIFTROWS[5]) );
  XNOR2_X1 Inst_SKINNY_Sbox_0_U13 ( .A(FRESH[25]), .B(
        Inst_SKINNY_Sbox_0_OutAff_out3[1]), .ZN(Inst_SKINNY_Sbox_0_n2) );
  XNOR2_X1 Inst_SKINNY_Sbox_0_U12 ( .A(Inst_SKINNY_Sbox_0_n1), .B(FRESH[28]), 
        .ZN(RF3_SHIFTROWS[4]) );
  XNOR2_X1 Inst_SKINNY_Sbox_0_U11 ( .A(FRESH[24]), .B(
        Inst_SKINNY_Sbox_0_OutAff_out3[0]), .ZN(Inst_SKINNY_Sbox_0_n1) );
  XOR2_X1 Inst_SKINNY_Sbox_0_U10 ( .A(FRESH[31]), .B(
        Inst_SKINNY_Sbox_0_OutAff_out2[3]), .Z(RF2_SHIFTROWS[7]) );
  XOR2_X1 Inst_SKINNY_Sbox_0_U9 ( .A(FRESH[30]), .B(
        Inst_SKINNY_Sbox_0_OutAff_out2[2]), .Z(RF2_SHIFTROWS[6]) );
  XOR2_X1 Inst_SKINNY_Sbox_0_U8 ( .A(FRESH[29]), .B(
        Inst_SKINNY_Sbox_0_OutAff_out2[1]), .Z(RF2_SHIFTROWS[5]) );
  XOR2_X1 Inst_SKINNY_Sbox_0_U7 ( .A(FRESH[28]), .B(
        Inst_SKINNY_Sbox_0_OutAff_out2[0]), .Z(RF2_SHIFTROWS[4]) );
  XOR2_X1 Inst_SKINNY_Sbox_0_U6 ( .A(FRESH[27]), .B(
        Inst_SKINNY_Sbox_0_OutAff_out1[3]), .Z(RF1_SHIFTROWS[7]) );
  XOR2_X1 Inst_SKINNY_Sbox_0_U5 ( .A(FRESH[26]), .B(
        Inst_SKINNY_Sbox_0_OutAff_out1[2]), .Z(RF1_SHIFTROWS[6]) );
  XOR2_X1 Inst_SKINNY_Sbox_0_U4 ( .A(FRESH[25]), .B(
        Inst_SKINNY_Sbox_0_OutAff_out1[1]), .Z(RF1_SHIFTROWS[5]) );
  XOR2_X1 Inst_SKINNY_Sbox_0_U3 ( .A(FRESH[24]), .B(
        Inst_SKINNY_Sbox_0_OutAff_out1[0]), .Z(RF1_SHIFTROWS[4]) );
  DFF_X1 Inst_SKINNY_Sbox_0_M2_out3_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_0_M2_out3[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_M2_out3_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_M2_out3_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_0_M2_out3[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_M2_out3_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_M2_out3_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_0_M2_out3[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_M2_out3_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_M2_out3_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_0_M2_out3[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_M2_out3_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_M2_out2_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_0_M2_out2[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_M2_out2_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_M2_out2_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_0_M2_out2[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_M2_out2_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_M2_out2_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_0_M2_out2[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_M2_out2_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_M2_out2_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_0_M2_out2[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_M2_out2_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_M2_out1_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_0_M2_out1[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_M2_out1_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_M2_out1_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_0_M2_out1[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_M2_out1_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_M2_out1_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_0_M2_out1[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_M2_out1_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_M2_out1_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_0_M2_out1[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_M2_out1_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_InAff_out3_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_0_InAff_out3[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_InAff_out3_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_InAff_out3_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_0_InAff_out3[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_InAff_out3_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_InAff_out3_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_0_InAff_out3[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_InAff_out3_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_InAff_out3_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_0_InAff_out3[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_InAff_out3_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_InAff_out2_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_0_InAff_out2[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_InAff_out2_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_InAff_out2_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_0_InAff_out2[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_InAff_out2_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_InAff_out2_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_0_InAff_out2[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_InAff_out2_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_InAff_out2_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_0_InAff_out2[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_InAff_out2_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_InAff_out1_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_0_InAff_out1[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_InAff_out1_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_InAff_out1_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_0_InAff_out1[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_InAff_out1_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_InAff_out1_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_0_InAff_out1[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_InAff_out1_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_InAff_out1_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_0_InAff_out1[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_InAff_out1_reg[3]), .QN() );
  INV_X1 Inst_SKINNY_Sbox_0_InputAffine_U4 ( .A(SUB_IN1[3]), .ZN(
        Inst_SKINNY_Sbox_0_InAff_out1[1]) );
  INV_X1 Inst_SKINNY_Sbox_0_InputAffine_U3 ( .A(SUB_IN1[2]), .ZN(
        Inst_SKINNY_Sbox_0_InAff_out1[3]) );
  INV_X1 Inst_SKINNY_Sbox_0_InputAffine_U2 ( .A(SUB_IN1[1]), .ZN(
        Inst_SKINNY_Sbox_0_InAff_out1[2]) );
  INV_X1 Inst_SKINNY_Sbox_0_InputAffine_U1 ( .A(SUB_IN1[0]), .ZN(
        Inst_SKINNY_Sbox_0_InAff_out1[0]) );
  DFF_X1 Inst_SKINNY_Sbox_0_Q294_inst1_CF_Reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Out[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_Q294_inst1_CF_Reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Out[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_Q294_inst1_CF_Reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Out[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_Q294_inst1_CF_Reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Out[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_Q294_inst1_CF_Reg_reg_4_ ( .D(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Out[4]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Reg[4]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_Q294_inst1_CF_Reg_reg_5_ ( .D(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Out[5]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Reg[5]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_Q294_inst1_CF_Reg_reg_6_ ( .D(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Out[6]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Reg[6]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_Q294_inst1_CF_Reg_reg_7_ ( .D(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Out[7]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Reg[7]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_Q294_inst1_CF_Reg_reg_8_ ( .D(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Out[8]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Reg[8]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_Q294_inst1_CF_Reg_reg_9_ ( .D(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Out[9]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Reg[9]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_Q294_inst1_CF_Reg_reg_10_ ( .D(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Out[10]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Reg[10]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_Q294_inst1_CF_Reg_reg_11_ ( .D(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Out[11]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Reg[11]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_Q294_inst1_CF_Reg_reg_12_ ( .D(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Out[12]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Reg[12]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_Q294_inst1_CF_Reg_reg_13_ ( .D(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Out[13]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Reg[13]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_Q294_inst1_CF_Reg_reg_14_ ( .D(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Out[14]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Reg[14]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_Q294_inst1_CF_Reg_reg_15_ ( .D(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Out[15]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Reg[15]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_Q294_inst1_CF_Reg_reg_16_ ( .D(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Out[16]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Reg[16]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_Q294_inst1_CF_Reg_reg_17_ ( .D(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Out[17]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Reg[17]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_Q294_inst1_dreg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_0_InAff_out2_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_M2_out1[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_Q294_inst1_dreg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_0_InAff_out3_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_M2_out2[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_Q294_inst1_dreg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_0_InAff_out1_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_M2_out3[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_Q294_inst1_creg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_0_InAff_out2_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_M2_out1[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_Q294_inst1_creg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_0_InAff_out3_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_M2_out2[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_Q294_inst1_creg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_0_InAff_out1_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_M2_out3[1]), .QN() );
  XNOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst1_Inst_0__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_0_Q294_inst1_Inst_0__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_0_InAff_out2_reg[0]), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Out[0]) );
  NAND2_X1 Inst_SKINNY_Sbox_0_Q294_inst1_Inst_0__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_0_InAff_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_0_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst1_Inst_0__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst1_Inst_1__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_0_Q294_inst1_Inst_1__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_0_Q294_inst1_Inst_1__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Out[1]) );
  NAND2_X1 Inst_SKINNY_Sbox_0_Q294_inst1_Inst_1__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_0_InAff_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_0_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst1_Inst_1__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst1_Inst_1__CF_Inst_U1 ( .A(FRESH[0]), .B(
        FRESH[1]), .Z(Inst_SKINNY_Sbox_0_Q294_inst1_Inst_1__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst1_Inst_2__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_0_Q294_inst1_Inst_2__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_0_Q294_inst1_Inst_2__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Out[2]) );
  NAND2_X1 Inst_SKINNY_Sbox_0_Q294_inst1_Inst_2__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_0_InAff_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_0_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst1_Inst_2__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst1_Inst_2__CF_Inst_U1 ( .A(FRESH[1]), .B(
        FRESH[2]), .Z(Inst_SKINNY_Sbox_0_Q294_inst1_Inst_2__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst1_Inst_3__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_0_Q294_inst1_Inst_3__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_0_InAff_out3_reg[0]), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Out[3]) );
  NAND2_X1 Inst_SKINNY_Sbox_0_Q294_inst1_Inst_3__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_0_InAff_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_0_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst1_Inst_3__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst1_Inst_4__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_0_Q294_inst1_Inst_4__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_0_Q294_inst1_Inst_4__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Out[4]) );
  NAND2_X1 Inst_SKINNY_Sbox_0_Q294_inst1_Inst_4__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_0_InAff_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_0_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst1_Inst_4__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst1_Inst_4__CF_Inst_U1 ( .A(FRESH[2]), .B(
        FRESH[3]), .Z(Inst_SKINNY_Sbox_0_Q294_inst1_Inst_4__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst1_Inst_5__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_0_Q294_inst1_Inst_5__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_0_Q294_inst1_Inst_5__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Out[5]) );
  NAND2_X1 Inst_SKINNY_Sbox_0_Q294_inst1_Inst_5__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_0_InAff_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_0_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst1_Inst_5__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst1_Inst_5__CF_Inst_U1 ( .A(FRESH[3]), .B(
        FRESH[4]), .Z(Inst_SKINNY_Sbox_0_Q294_inst1_Inst_5__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst1_Inst_6__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_0_Q294_inst1_Inst_6__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_0_InAff_out1_reg[0]), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Out[6]) );
  NAND2_X1 Inst_SKINNY_Sbox_0_Q294_inst1_Inst_6__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_0_InAff_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_0_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst1_Inst_6__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst1_Inst_7__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_0_Q294_inst1_Inst_7__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_0_Q294_inst1_Inst_7__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Out[7]) );
  NAND2_X1 Inst_SKINNY_Sbox_0_Q294_inst1_Inst_7__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_0_InAff_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_0_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst1_Inst_7__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst1_Inst_7__CF_Inst_U1 ( .A(FRESH[4]), .B(
        FRESH[5]), .Z(Inst_SKINNY_Sbox_0_Q294_inst1_Inst_7__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst1_Inst_8__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_0_Q294_inst1_Inst_8__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_0_Q294_inst1_Inst_8__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Out[8]) );
  NAND2_X1 Inst_SKINNY_Sbox_0_Q294_inst1_Inst_8__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_0_InAff_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_0_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst1_Inst_8__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst1_Inst_8__CF_Inst_U1 ( .A(FRESH[5]), .B(
        FRESH[0]), .Z(Inst_SKINNY_Sbox_0_Q294_inst1_Inst_8__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst1_Inst_9__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_0_Q294_inst1_Inst_9__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_0_InAff_out2_reg[1]), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Out[9]) );
  NAND2_X1 Inst_SKINNY_Sbox_0_Q294_inst1_Inst_9__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_0_InAff_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_0_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst1_Inst_9__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst1_Inst_10__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_0_Q294_inst1_Inst_10__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_0_Q294_inst1_Inst_10__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Out[10]) );
  NAND2_X1 Inst_SKINNY_Sbox_0_Q294_inst1_Inst_10__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_0_InAff_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_0_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst1_Inst_10__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst1_Inst_10__CF_Inst_U1 ( .A(FRESH[6]), 
        .B(FRESH[7]), .Z(Inst_SKINNY_Sbox_0_Q294_inst1_Inst_10__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst1_Inst_11__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_0_Q294_inst1_Inst_11__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_0_Q294_inst1_Inst_11__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Out[11]) );
  NAND2_X1 Inst_SKINNY_Sbox_0_Q294_inst1_Inst_11__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_0_InAff_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_0_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst1_Inst_11__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst1_Inst_11__CF_Inst_U1 ( .A(FRESH[7]), 
        .B(FRESH[8]), .Z(Inst_SKINNY_Sbox_0_Q294_inst1_Inst_11__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst1_Inst_12__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_0_Q294_inst1_Inst_12__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_0_InAff_out3_reg[1]), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Out[12]) );
  NAND2_X1 Inst_SKINNY_Sbox_0_Q294_inst1_Inst_12__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_0_InAff_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_0_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst1_Inst_12__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst1_Inst_13__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_0_Q294_inst1_Inst_13__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_0_Q294_inst1_Inst_13__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Out[13]) );
  NAND2_X1 Inst_SKINNY_Sbox_0_Q294_inst1_Inst_13__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_0_InAff_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_0_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst1_Inst_13__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst1_Inst_13__CF_Inst_U1 ( .A(FRESH[8]), 
        .B(FRESH[9]), .Z(Inst_SKINNY_Sbox_0_Q294_inst1_Inst_13__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst1_Inst_14__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_0_Q294_inst1_Inst_14__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_0_Q294_inst1_Inst_14__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Out[14]) );
  NAND2_X1 Inst_SKINNY_Sbox_0_Q294_inst1_Inst_14__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_0_InAff_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_0_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst1_Inst_14__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst1_Inst_14__CF_Inst_U1 ( .A(FRESH[9]), 
        .B(FRESH[10]), .Z(Inst_SKINNY_Sbox_0_Q294_inst1_Inst_14__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst1_Inst_15__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_0_Q294_inst1_Inst_15__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_0_InAff_out1_reg[1]), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Out[15]) );
  NAND2_X1 Inst_SKINNY_Sbox_0_Q294_inst1_Inst_15__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_0_InAff_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_0_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst1_Inst_15__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst1_Inst_16__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_0_Q294_inst1_Inst_16__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_0_Q294_inst1_Inst_16__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Out[16]) );
  NAND2_X1 Inst_SKINNY_Sbox_0_Q294_inst1_Inst_16__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_0_InAff_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_0_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst1_Inst_16__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst1_Inst_16__CF_Inst_U1 ( .A(FRESH[10]), 
        .B(FRESH[11]), .Z(Inst_SKINNY_Sbox_0_Q294_inst1_Inst_16__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst1_Inst_17__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_0_Q294_inst1_Inst_17__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_0_Q294_inst1_Inst_17__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Out[17]) );
  NAND2_X1 Inst_SKINNY_Sbox_0_Q294_inst1_Inst_17__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_0_InAff_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_0_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst1_Inst_17__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst1_Inst_17__CF_Inst_U1 ( .A(FRESH[11]), 
        .B(FRESH[6]), .Z(Inst_SKINNY_Sbox_0_Q294_inst1_Inst_17__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst1_InstXOR_0__Compression1_U2 ( .A(
        Inst_SKINNY_Sbox_0_Q294_inst1_InstXOR_0__Compression1_n3), .B(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Reg[2]), .ZN(
        Inst_SKINNY_Sbox_0_M2_out1[3]) );
  XNOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst1_InstXOR_0__Compression1_U1 ( .A(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Reg[0]), .B(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Reg[1]), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst1_InstXOR_0__Compression1_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst1_InstXOR_0__Compression2_U2 ( .A(
        Inst_SKINNY_Sbox_0_Q294_inst1_InstXOR_0__Compression2_n3), .B(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Reg[5]), .ZN(
        Inst_SKINNY_Sbox_0_M2_out2[3]) );
  XNOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst1_InstXOR_0__Compression2_U1 ( .A(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Reg[3]), .B(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Reg[4]), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst1_InstXOR_0__Compression2_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst1_InstXOR_0__Compression3_U2 ( .A(
        Inst_SKINNY_Sbox_0_Q294_inst1_InstXOR_0__Compression3_n3), .B(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Reg[8]), .ZN(
        Inst_SKINNY_Sbox_0_M2_out3[3]) );
  XNOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst1_InstXOR_0__Compression3_U1 ( .A(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Reg[6]), .B(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Reg[7]), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst1_InstXOR_0__Compression3_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst1_InstXOR_1__Compression1_U2 ( .A(
        Inst_SKINNY_Sbox_0_Q294_inst1_InstXOR_1__Compression1_n3), .B(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Reg[11]), .ZN(
        Inst_SKINNY_Sbox_0_M2_out1[2]) );
  XNOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst1_InstXOR_1__Compression1_U1 ( .A(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Reg[9]), .B(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Reg[10]), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst1_InstXOR_1__Compression1_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst1_InstXOR_1__Compression2_U2 ( .A(
        Inst_SKINNY_Sbox_0_Q294_inst1_InstXOR_1__Compression2_n3), .B(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Reg[14]), .ZN(
        Inst_SKINNY_Sbox_0_M2_out2[2]) );
  XNOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst1_InstXOR_1__Compression2_U1 ( .A(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Reg[12]), .B(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Reg[13]), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst1_InstXOR_1__Compression2_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst1_InstXOR_1__Compression3_U2 ( .A(
        Inst_SKINNY_Sbox_0_Q294_inst1_InstXOR_1__Compression3_n3), .B(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Reg[17]), .ZN(
        Inst_SKINNY_Sbox_0_M2_out3[2]) );
  XNOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst1_InstXOR_1__Compression3_U1 ( .A(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Reg[15]), .B(
        Inst_SKINNY_Sbox_0_Q294_inst1_CF_Reg[16]), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst1_InstXOR_1__Compression3_n3) );
  DFF_X1 Inst_SKINNY_Sbox_0_Q294_inst2_CF_Reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Out[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_Q294_inst2_CF_Reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Out[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_Q294_inst2_CF_Reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Out[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_Q294_inst2_CF_Reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Out[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_Q294_inst2_CF_Reg_reg_4_ ( .D(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Out[4]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Reg[4]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_Q294_inst2_CF_Reg_reg_5_ ( .D(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Out[5]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Reg[5]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_Q294_inst2_CF_Reg_reg_6_ ( .D(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Out[6]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Reg[6]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_Q294_inst2_CF_Reg_reg_7_ ( .D(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Out[7]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Reg[7]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_Q294_inst2_CF_Reg_reg_8_ ( .D(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Out[8]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Reg[8]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_Q294_inst2_CF_Reg_reg_9_ ( .D(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Out[9]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Reg[9]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_Q294_inst2_CF_Reg_reg_10_ ( .D(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Out[10]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Reg[10]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_Q294_inst2_CF_Reg_reg_11_ ( .D(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Out[11]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Reg[11]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_Q294_inst2_CF_Reg_reg_12_ ( .D(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Out[12]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Reg[12]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_Q294_inst2_CF_Reg_reg_13_ ( .D(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Out[13]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Reg[13]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_Q294_inst2_CF_Reg_reg_14_ ( .D(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Out[14]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Reg[14]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_Q294_inst2_CF_Reg_reg_15_ ( .D(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Out[15]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Reg[15]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_Q294_inst2_CF_Reg_reg_16_ ( .D(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Out[16]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Reg[16]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_Q294_inst2_CF_Reg_reg_17_ ( .D(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Out[17]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Reg[17]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_Q294_inst2_dreg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_0_M2_out2_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_Q294_2_out1[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_Q294_inst2_dreg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_0_M2_out3_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_OutAff_out2[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_Q294_inst2_dreg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_0_M2_out1_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_OutAff_out3[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_Q294_inst2_creg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_0_M2_out2_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_Q294_2_out1[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_Q294_inst2_creg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_0_M2_out3_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_OutAff_out2[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_0_Q294_inst2_creg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_0_M2_out1_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_0_OutAff_out3[2]), .QN() );
  XNOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst2_Inst_0__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_0_Q294_inst2_Inst_0__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_0_M2_out2_reg[0]), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Out[0]) );
  NAND2_X1 Inst_SKINNY_Sbox_0_Q294_inst2_Inst_0__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_0_M2_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_0_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst2_Inst_0__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst2_Inst_1__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_0_Q294_inst2_Inst_1__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_0_Q294_inst2_Inst_1__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Out[1]) );
  NAND2_X1 Inst_SKINNY_Sbox_0_Q294_inst2_Inst_1__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_0_M2_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_0_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst2_Inst_1__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst2_Inst_1__CF_Inst_U1 ( .A(FRESH[12]), 
        .B(FRESH[13]), .Z(Inst_SKINNY_Sbox_0_Q294_inst2_Inst_1__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst2_Inst_2__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_0_Q294_inst2_Inst_2__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_0_Q294_inst2_Inst_2__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Out[2]) );
  NAND2_X1 Inst_SKINNY_Sbox_0_Q294_inst2_Inst_2__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_0_M2_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_0_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst2_Inst_2__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst2_Inst_2__CF_Inst_U1 ( .A(FRESH[13]), 
        .B(FRESH[14]), .Z(Inst_SKINNY_Sbox_0_Q294_inst2_Inst_2__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst2_Inst_3__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_0_Q294_inst2_Inst_3__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_0_M2_out3_reg[0]), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Out[3]) );
  NAND2_X1 Inst_SKINNY_Sbox_0_Q294_inst2_Inst_3__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_0_M2_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_0_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst2_Inst_3__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst2_Inst_4__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_0_Q294_inst2_Inst_4__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_0_Q294_inst2_Inst_4__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Out[4]) );
  NAND2_X1 Inst_SKINNY_Sbox_0_Q294_inst2_Inst_4__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_0_M2_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_0_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst2_Inst_4__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst2_Inst_4__CF_Inst_U1 ( .A(FRESH[14]), 
        .B(FRESH[15]), .Z(Inst_SKINNY_Sbox_0_Q294_inst2_Inst_4__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst2_Inst_5__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_0_Q294_inst2_Inst_5__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_0_Q294_inst2_Inst_5__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Out[5]) );
  NAND2_X1 Inst_SKINNY_Sbox_0_Q294_inst2_Inst_5__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_0_M2_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_0_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst2_Inst_5__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst2_Inst_5__CF_Inst_U1 ( .A(FRESH[15]), 
        .B(FRESH[16]), .Z(Inst_SKINNY_Sbox_0_Q294_inst2_Inst_5__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst2_Inst_6__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_0_Q294_inst2_Inst_6__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_0_M2_out1_reg[0]), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Out[6]) );
  NAND2_X1 Inst_SKINNY_Sbox_0_Q294_inst2_Inst_6__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_0_M2_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_0_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst2_Inst_6__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst2_Inst_7__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_0_Q294_inst2_Inst_7__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_0_Q294_inst2_Inst_7__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Out[7]) );
  NAND2_X1 Inst_SKINNY_Sbox_0_Q294_inst2_Inst_7__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_0_M2_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_0_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst2_Inst_7__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst2_Inst_7__CF_Inst_U1 ( .A(FRESH[16]), 
        .B(FRESH[17]), .Z(Inst_SKINNY_Sbox_0_Q294_inst2_Inst_7__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst2_Inst_8__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_0_Q294_inst2_Inst_8__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_0_Q294_inst2_Inst_8__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Out[8]) );
  NAND2_X1 Inst_SKINNY_Sbox_0_Q294_inst2_Inst_8__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_0_M2_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_0_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst2_Inst_8__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst2_Inst_8__CF_Inst_U1 ( .A(FRESH[17]), 
        .B(FRESH[12]), .Z(Inst_SKINNY_Sbox_0_Q294_inst2_Inst_8__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst2_Inst_9__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_0_Q294_inst2_Inst_9__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_0_M2_out2_reg[1]), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Out[9]) );
  NAND2_X1 Inst_SKINNY_Sbox_0_Q294_inst2_Inst_9__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_0_M2_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_0_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst2_Inst_9__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst2_Inst_10__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_0_Q294_inst2_Inst_10__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_0_Q294_inst2_Inst_10__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Out[10]) );
  NAND2_X1 Inst_SKINNY_Sbox_0_Q294_inst2_Inst_10__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_0_M2_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_0_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst2_Inst_10__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst2_Inst_10__CF_Inst_U1 ( .A(FRESH[18]), 
        .B(FRESH[19]), .Z(Inst_SKINNY_Sbox_0_Q294_inst2_Inst_10__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst2_Inst_11__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_0_Q294_inst2_Inst_11__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_0_Q294_inst2_Inst_11__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Out[11]) );
  NAND2_X1 Inst_SKINNY_Sbox_0_Q294_inst2_Inst_11__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_0_M2_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_0_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst2_Inst_11__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst2_Inst_11__CF_Inst_U1 ( .A(FRESH[19]), 
        .B(FRESH[20]), .Z(Inst_SKINNY_Sbox_0_Q294_inst2_Inst_11__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst2_Inst_12__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_0_Q294_inst2_Inst_12__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_0_M2_out3_reg[1]), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Out[12]) );
  NAND2_X1 Inst_SKINNY_Sbox_0_Q294_inst2_Inst_12__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_0_M2_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_0_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst2_Inst_12__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst2_Inst_13__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_0_Q294_inst2_Inst_13__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_0_Q294_inst2_Inst_13__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Out[13]) );
  NAND2_X1 Inst_SKINNY_Sbox_0_Q294_inst2_Inst_13__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_0_M2_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_0_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst2_Inst_13__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst2_Inst_13__CF_Inst_U1 ( .A(FRESH[20]), 
        .B(FRESH[21]), .Z(Inst_SKINNY_Sbox_0_Q294_inst2_Inst_13__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst2_Inst_14__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_0_Q294_inst2_Inst_14__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_0_Q294_inst2_Inst_14__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Out[14]) );
  NAND2_X1 Inst_SKINNY_Sbox_0_Q294_inst2_Inst_14__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_0_M2_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_0_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst2_Inst_14__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst2_Inst_14__CF_Inst_U1 ( .A(FRESH[21]), 
        .B(FRESH[22]), .Z(Inst_SKINNY_Sbox_0_Q294_inst2_Inst_14__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst2_Inst_15__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_0_Q294_inst2_Inst_15__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_0_M2_out1_reg[1]), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Out[15]) );
  NAND2_X1 Inst_SKINNY_Sbox_0_Q294_inst2_Inst_15__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_0_M2_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_0_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst2_Inst_15__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst2_Inst_16__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_0_Q294_inst2_Inst_16__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_0_Q294_inst2_Inst_16__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Out[16]) );
  NAND2_X1 Inst_SKINNY_Sbox_0_Q294_inst2_Inst_16__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_0_M2_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_0_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst2_Inst_16__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst2_Inst_16__CF_Inst_U1 ( .A(FRESH[22]), 
        .B(FRESH[23]), .Z(Inst_SKINNY_Sbox_0_Q294_inst2_Inst_16__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst2_Inst_17__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_0_Q294_inst2_Inst_17__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_0_Q294_inst2_Inst_17__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Out[17]) );
  NAND2_X1 Inst_SKINNY_Sbox_0_Q294_inst2_Inst_17__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_0_M2_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_0_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst2_Inst_17__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst2_Inst_17__CF_Inst_U1 ( .A(FRESH[23]), 
        .B(FRESH[18]), .Z(Inst_SKINNY_Sbox_0_Q294_inst2_Inst_17__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst2_InstXOR_0__Compression1_U2 ( .A(
        Inst_SKINNY_Sbox_0_Q294_inst2_InstXOR_0__Compression1_n3), .B(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Reg[2]), .ZN(
        Inst_SKINNY_Sbox_0_Q294_2_out1[0]) );
  XNOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst2_InstXOR_0__Compression1_U1 ( .A(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Reg[0]), .B(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Reg[1]), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst2_InstXOR_0__Compression1_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst2_InstXOR_0__Compression2_U2 ( .A(
        Inst_SKINNY_Sbox_0_Q294_inst2_InstXOR_0__Compression2_n3), .B(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Reg[5]), .ZN(
        Inst_SKINNY_Sbox_0_OutAff_out2[1]) );
  XNOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst2_InstXOR_0__Compression2_U1 ( .A(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Reg[3]), .B(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Reg[4]), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst2_InstXOR_0__Compression2_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst2_InstXOR_0__Compression3_U2 ( .A(
        Inst_SKINNY_Sbox_0_Q294_inst2_InstXOR_0__Compression3_n3), .B(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Reg[8]), .ZN(
        Inst_SKINNY_Sbox_0_OutAff_out3[1]) );
  XNOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst2_InstXOR_0__Compression3_U1 ( .A(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Reg[6]), .B(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Reg[7]), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst2_InstXOR_0__Compression3_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst2_InstXOR_1__Compression1_U2 ( .A(
        Inst_SKINNY_Sbox_0_Q294_inst2_InstXOR_1__Compression1_n3), .B(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Reg[11]), .ZN(
        Inst_SKINNY_Sbox_0_Q294_2_out1[1]) );
  XNOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst2_InstXOR_1__Compression1_U1 ( .A(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Reg[9]), .B(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Reg[10]), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst2_InstXOR_1__Compression1_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst2_InstXOR_1__Compression2_U2 ( .A(
        Inst_SKINNY_Sbox_0_Q294_inst2_InstXOR_1__Compression2_n3), .B(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Reg[14]), .ZN(
        Inst_SKINNY_Sbox_0_OutAff_out2[0]) );
  XNOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst2_InstXOR_1__Compression2_U1 ( .A(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Reg[12]), .B(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Reg[13]), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst2_InstXOR_1__Compression2_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst2_InstXOR_1__Compression3_U2 ( .A(
        Inst_SKINNY_Sbox_0_Q294_inst2_InstXOR_1__Compression3_n3), .B(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Reg[17]), .ZN(
        Inst_SKINNY_Sbox_0_OutAff_out3[0]) );
  XNOR2_X1 Inst_SKINNY_Sbox_0_Q294_inst2_InstXOR_1__Compression3_U1 ( .A(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Reg[15]), .B(
        Inst_SKINNY_Sbox_0_Q294_inst2_CF_Reg[16]), .ZN(
        Inst_SKINNY_Sbox_0_Q294_inst2_InstXOR_1__Compression3_n3) );
  INV_X1 Inst_SKINNY_Sbox_0_OutputAffine_U4 ( .A(
        Inst_SKINNY_Sbox_0_Q294_2_out1[3]), .ZN(
        Inst_SKINNY_Sbox_0_OutAff_out1[3]) );
  INV_X1 Inst_SKINNY_Sbox_0_OutputAffine_U3 ( .A(
        Inst_SKINNY_Sbox_0_Q294_2_out1[2]), .ZN(
        Inst_SKINNY_Sbox_0_OutAff_out1[2]) );
  INV_X1 Inst_SKINNY_Sbox_0_OutputAffine_U2 ( .A(
        Inst_SKINNY_Sbox_0_Q294_2_out1[1]), .ZN(
        Inst_SKINNY_Sbox_0_OutAff_out1[0]) );
  INV_X1 Inst_SKINNY_Sbox_0_OutputAffine_U1 ( .A(
        Inst_SKINNY_Sbox_0_Q294_2_out1[0]), .ZN(
        Inst_SKINNY_Sbox_0_OutAff_out1[1]) );
  XNOR2_X1 Inst_SKINNY_Sbox_1_U18 ( .A(Inst_SKINNY_Sbox_1_n12), .B(FRESH[39]), 
        .ZN(RF3_SHIFTROWS[11]) );
  XNOR2_X1 Inst_SKINNY_Sbox_1_U17 ( .A(FRESH[35]), .B(
        Inst_SKINNY_Sbox_1_OutAff_out3[3]), .ZN(Inst_SKINNY_Sbox_1_n12) );
  XNOR2_X1 Inst_SKINNY_Sbox_1_U16 ( .A(Inst_SKINNY_Sbox_1_n11), .B(FRESH[38]), 
        .ZN(RF3_SHIFTROWS[10]) );
  XNOR2_X1 Inst_SKINNY_Sbox_1_U15 ( .A(FRESH[34]), .B(
        Inst_SKINNY_Sbox_1_OutAff_out3[2]), .ZN(Inst_SKINNY_Sbox_1_n11) );
  XNOR2_X1 Inst_SKINNY_Sbox_1_U14 ( .A(Inst_SKINNY_Sbox_1_n10), .B(FRESH[37]), 
        .ZN(RF3_SHIFTROWS[9]) );
  XNOR2_X1 Inst_SKINNY_Sbox_1_U13 ( .A(FRESH[33]), .B(
        Inst_SKINNY_Sbox_1_OutAff_out3[1]), .ZN(Inst_SKINNY_Sbox_1_n10) );
  XNOR2_X1 Inst_SKINNY_Sbox_1_U12 ( .A(Inst_SKINNY_Sbox_1_n9), .B(FRESH[36]), 
        .ZN(RF3_SHIFTROWS[8]) );
  XNOR2_X1 Inst_SKINNY_Sbox_1_U11 ( .A(FRESH[32]), .B(
        Inst_SKINNY_Sbox_1_OutAff_out3[0]), .ZN(Inst_SKINNY_Sbox_1_n9) );
  XOR2_X1 Inst_SKINNY_Sbox_1_U10 ( .A(FRESH[39]), .B(
        Inst_SKINNY_Sbox_1_OutAff_out2[3]), .Z(RF2_SHIFTROWS[11]) );
  XOR2_X1 Inst_SKINNY_Sbox_1_U9 ( .A(FRESH[38]), .B(
        Inst_SKINNY_Sbox_1_OutAff_out2[2]), .Z(RF2_SHIFTROWS[10]) );
  XOR2_X1 Inst_SKINNY_Sbox_1_U8 ( .A(FRESH[37]), .B(
        Inst_SKINNY_Sbox_1_OutAff_out2[1]), .Z(RF2_SHIFTROWS[9]) );
  XOR2_X1 Inst_SKINNY_Sbox_1_U7 ( .A(FRESH[36]), .B(
        Inst_SKINNY_Sbox_1_OutAff_out2[0]), .Z(RF2_SHIFTROWS[8]) );
  XOR2_X1 Inst_SKINNY_Sbox_1_U6 ( .A(FRESH[35]), .B(
        Inst_SKINNY_Sbox_1_OutAff_out1[3]), .Z(RF1_SHIFTROWS[11]) );
  XOR2_X1 Inst_SKINNY_Sbox_1_U5 ( .A(FRESH[34]), .B(
        Inst_SKINNY_Sbox_1_OutAff_out1[2]), .Z(RF1_SHIFTROWS[10]) );
  XOR2_X1 Inst_SKINNY_Sbox_1_U4 ( .A(FRESH[33]), .B(
        Inst_SKINNY_Sbox_1_OutAff_out1[1]), .Z(RF1_SHIFTROWS[9]) );
  XOR2_X1 Inst_SKINNY_Sbox_1_U3 ( .A(FRESH[32]), .B(
        Inst_SKINNY_Sbox_1_OutAff_out1[0]), .Z(RF1_SHIFTROWS[8]) );
  DFF_X1 Inst_SKINNY_Sbox_1_M2_out3_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_1_M2_out3[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_M2_out3_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_M2_out3_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_1_M2_out3[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_M2_out3_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_M2_out3_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_1_M2_out3[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_M2_out3_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_M2_out3_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_1_M2_out3[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_M2_out3_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_M2_out2_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_1_M2_out2[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_M2_out2_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_M2_out2_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_1_M2_out2[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_M2_out2_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_M2_out2_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_1_M2_out2[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_M2_out2_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_M2_out2_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_1_M2_out2[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_M2_out2_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_M2_out1_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_1_M2_out1[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_M2_out1_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_M2_out1_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_1_M2_out1[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_M2_out1_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_M2_out1_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_1_M2_out1[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_M2_out1_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_M2_out1_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_1_M2_out1[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_M2_out1_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_InAff_out3_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_1_InAff_out3[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_InAff_out3_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_InAff_out3_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_1_InAff_out3[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_InAff_out3_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_InAff_out3_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_1_InAff_out3[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_InAff_out3_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_InAff_out3_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_1_InAff_out3[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_InAff_out3_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_InAff_out2_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_1_InAff_out2[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_InAff_out2_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_InAff_out2_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_1_InAff_out2[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_InAff_out2_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_InAff_out2_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_1_InAff_out2[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_InAff_out2_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_InAff_out2_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_1_InAff_out2[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_InAff_out2_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_InAff_out1_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_1_InAff_out1[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_InAff_out1_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_InAff_out1_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_1_InAff_out1[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_InAff_out1_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_InAff_out1_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_1_InAff_out1[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_InAff_out1_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_InAff_out1_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_1_InAff_out1[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_InAff_out1_reg[3]), .QN() );
  INV_X1 Inst_SKINNY_Sbox_1_InputAffine_U4 ( .A(SUB_IN1[7]), .ZN(
        Inst_SKINNY_Sbox_1_InAff_out1[1]) );
  INV_X1 Inst_SKINNY_Sbox_1_InputAffine_U3 ( .A(SUB_IN1[6]), .ZN(
        Inst_SKINNY_Sbox_1_InAff_out1[3]) );
  INV_X1 Inst_SKINNY_Sbox_1_InputAffine_U2 ( .A(SUB_IN1[5]), .ZN(
        Inst_SKINNY_Sbox_1_InAff_out1[2]) );
  INV_X1 Inst_SKINNY_Sbox_1_InputAffine_U1 ( .A(SUB_IN1[4]), .ZN(
        Inst_SKINNY_Sbox_1_InAff_out1[0]) );
  DFF_X1 Inst_SKINNY_Sbox_1_Q294_inst1_CF_Reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Out[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_Q294_inst1_CF_Reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Out[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_Q294_inst1_CF_Reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Out[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_Q294_inst1_CF_Reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Out[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_Q294_inst1_CF_Reg_reg_4_ ( .D(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Out[4]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Reg[4]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_Q294_inst1_CF_Reg_reg_5_ ( .D(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Out[5]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Reg[5]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_Q294_inst1_CF_Reg_reg_6_ ( .D(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Out[6]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Reg[6]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_Q294_inst1_CF_Reg_reg_7_ ( .D(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Out[7]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Reg[7]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_Q294_inst1_CF_Reg_reg_8_ ( .D(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Out[8]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Reg[8]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_Q294_inst1_CF_Reg_reg_9_ ( .D(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Out[9]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Reg[9]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_Q294_inst1_CF_Reg_reg_10_ ( .D(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Out[10]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Reg[10]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_Q294_inst1_CF_Reg_reg_11_ ( .D(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Out[11]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Reg[11]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_Q294_inst1_CF_Reg_reg_12_ ( .D(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Out[12]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Reg[12]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_Q294_inst1_CF_Reg_reg_13_ ( .D(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Out[13]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Reg[13]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_Q294_inst1_CF_Reg_reg_14_ ( .D(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Out[14]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Reg[14]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_Q294_inst1_CF_Reg_reg_15_ ( .D(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Out[15]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Reg[15]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_Q294_inst1_CF_Reg_reg_16_ ( .D(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Out[16]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Reg[16]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_Q294_inst1_CF_Reg_reg_17_ ( .D(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Out[17]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Reg[17]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_Q294_inst1_dreg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_1_InAff_out2_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_M2_out1[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_Q294_inst1_dreg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_1_InAff_out3_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_M2_out2[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_Q294_inst1_dreg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_1_InAff_out1_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_M2_out3[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_Q294_inst1_creg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_1_InAff_out2_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_M2_out1[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_Q294_inst1_creg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_1_InAff_out3_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_M2_out2[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_Q294_inst1_creg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_1_InAff_out1_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_M2_out3[1]), .QN() );
  XNOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst1_Inst_0__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_1_Q294_inst1_Inst_0__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_1_InAff_out2_reg[0]), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Out[0]) );
  NAND2_X1 Inst_SKINNY_Sbox_1_Q294_inst1_Inst_0__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_1_InAff_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_1_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst1_Inst_0__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst1_Inst_1__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_1_Q294_inst1_Inst_1__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_1_Q294_inst1_Inst_1__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Out[1]) );
  NAND2_X1 Inst_SKINNY_Sbox_1_Q294_inst1_Inst_1__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_1_InAff_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_1_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst1_Inst_1__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst1_Inst_1__CF_Inst_U1 ( .A(FRESH[0]), .B(
        FRESH[1]), .Z(Inst_SKINNY_Sbox_1_Q294_inst1_Inst_1__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst1_Inst_2__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_1_Q294_inst1_Inst_2__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_1_Q294_inst1_Inst_2__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Out[2]) );
  NAND2_X1 Inst_SKINNY_Sbox_1_Q294_inst1_Inst_2__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_1_InAff_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_1_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst1_Inst_2__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst1_Inst_2__CF_Inst_U1 ( .A(FRESH[1]), .B(
        FRESH[2]), .Z(Inst_SKINNY_Sbox_1_Q294_inst1_Inst_2__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst1_Inst_3__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_1_Q294_inst1_Inst_3__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_1_InAff_out3_reg[0]), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Out[3]) );
  NAND2_X1 Inst_SKINNY_Sbox_1_Q294_inst1_Inst_3__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_1_InAff_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_1_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst1_Inst_3__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst1_Inst_4__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_1_Q294_inst1_Inst_4__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_1_Q294_inst1_Inst_4__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Out[4]) );
  NAND2_X1 Inst_SKINNY_Sbox_1_Q294_inst1_Inst_4__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_1_InAff_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_1_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst1_Inst_4__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst1_Inst_4__CF_Inst_U1 ( .A(FRESH[2]), .B(
        FRESH[3]), .Z(Inst_SKINNY_Sbox_1_Q294_inst1_Inst_4__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst1_Inst_5__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_1_Q294_inst1_Inst_5__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_1_Q294_inst1_Inst_5__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Out[5]) );
  NAND2_X1 Inst_SKINNY_Sbox_1_Q294_inst1_Inst_5__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_1_InAff_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_1_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst1_Inst_5__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst1_Inst_5__CF_Inst_U1 ( .A(FRESH[3]), .B(
        FRESH[4]), .Z(Inst_SKINNY_Sbox_1_Q294_inst1_Inst_5__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst1_Inst_6__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_1_Q294_inst1_Inst_6__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_1_InAff_out1_reg[0]), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Out[6]) );
  NAND2_X1 Inst_SKINNY_Sbox_1_Q294_inst1_Inst_6__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_1_InAff_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_1_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst1_Inst_6__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst1_Inst_7__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_1_Q294_inst1_Inst_7__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_1_Q294_inst1_Inst_7__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Out[7]) );
  NAND2_X1 Inst_SKINNY_Sbox_1_Q294_inst1_Inst_7__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_1_InAff_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_1_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst1_Inst_7__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst1_Inst_7__CF_Inst_U1 ( .A(FRESH[4]), .B(
        FRESH[5]), .Z(Inst_SKINNY_Sbox_1_Q294_inst1_Inst_7__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst1_Inst_8__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_1_Q294_inst1_Inst_8__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_1_Q294_inst1_Inst_8__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Out[8]) );
  NAND2_X1 Inst_SKINNY_Sbox_1_Q294_inst1_Inst_8__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_1_InAff_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_1_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst1_Inst_8__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst1_Inst_8__CF_Inst_U1 ( .A(FRESH[5]), .B(
        FRESH[0]), .Z(Inst_SKINNY_Sbox_1_Q294_inst1_Inst_8__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst1_Inst_9__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_1_Q294_inst1_Inst_9__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_1_InAff_out2_reg[1]), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Out[9]) );
  NAND2_X1 Inst_SKINNY_Sbox_1_Q294_inst1_Inst_9__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_1_InAff_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_1_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst1_Inst_9__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst1_Inst_10__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_1_Q294_inst1_Inst_10__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_1_Q294_inst1_Inst_10__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Out[10]) );
  NAND2_X1 Inst_SKINNY_Sbox_1_Q294_inst1_Inst_10__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_1_InAff_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_1_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst1_Inst_10__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst1_Inst_10__CF_Inst_U1 ( .A(FRESH[6]), 
        .B(FRESH[7]), .Z(Inst_SKINNY_Sbox_1_Q294_inst1_Inst_10__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst1_Inst_11__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_1_Q294_inst1_Inst_11__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_1_Q294_inst1_Inst_11__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Out[11]) );
  NAND2_X1 Inst_SKINNY_Sbox_1_Q294_inst1_Inst_11__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_1_InAff_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_1_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst1_Inst_11__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst1_Inst_11__CF_Inst_U1 ( .A(FRESH[7]), 
        .B(FRESH[8]), .Z(Inst_SKINNY_Sbox_1_Q294_inst1_Inst_11__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst1_Inst_12__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_1_Q294_inst1_Inst_12__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_1_InAff_out3_reg[1]), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Out[12]) );
  NAND2_X1 Inst_SKINNY_Sbox_1_Q294_inst1_Inst_12__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_1_InAff_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_1_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst1_Inst_12__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst1_Inst_13__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_1_Q294_inst1_Inst_13__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_1_Q294_inst1_Inst_13__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Out[13]) );
  NAND2_X1 Inst_SKINNY_Sbox_1_Q294_inst1_Inst_13__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_1_InAff_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_1_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst1_Inst_13__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst1_Inst_13__CF_Inst_U1 ( .A(FRESH[8]), 
        .B(FRESH[9]), .Z(Inst_SKINNY_Sbox_1_Q294_inst1_Inst_13__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst1_Inst_14__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_1_Q294_inst1_Inst_14__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_1_Q294_inst1_Inst_14__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Out[14]) );
  NAND2_X1 Inst_SKINNY_Sbox_1_Q294_inst1_Inst_14__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_1_InAff_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_1_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst1_Inst_14__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst1_Inst_14__CF_Inst_U1 ( .A(FRESH[9]), 
        .B(FRESH[10]), .Z(Inst_SKINNY_Sbox_1_Q294_inst1_Inst_14__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst1_Inst_15__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_1_Q294_inst1_Inst_15__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_1_InAff_out1_reg[1]), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Out[15]) );
  NAND2_X1 Inst_SKINNY_Sbox_1_Q294_inst1_Inst_15__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_1_InAff_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_1_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst1_Inst_15__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst1_Inst_16__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_1_Q294_inst1_Inst_16__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_1_Q294_inst1_Inst_16__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Out[16]) );
  NAND2_X1 Inst_SKINNY_Sbox_1_Q294_inst1_Inst_16__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_1_InAff_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_1_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst1_Inst_16__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst1_Inst_16__CF_Inst_U1 ( .A(FRESH[10]), 
        .B(FRESH[11]), .Z(Inst_SKINNY_Sbox_1_Q294_inst1_Inst_16__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst1_Inst_17__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_1_Q294_inst1_Inst_17__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_1_Q294_inst1_Inst_17__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Out[17]) );
  NAND2_X1 Inst_SKINNY_Sbox_1_Q294_inst1_Inst_17__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_1_InAff_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_1_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst1_Inst_17__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst1_Inst_17__CF_Inst_U1 ( .A(FRESH[11]), 
        .B(FRESH[6]), .Z(Inst_SKINNY_Sbox_1_Q294_inst1_Inst_17__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst1_InstXOR_0__Compression1_U2 ( .A(
        Inst_SKINNY_Sbox_1_Q294_inst1_InstXOR_0__Compression1_n3), .B(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Reg[2]), .ZN(
        Inst_SKINNY_Sbox_1_M2_out1[3]) );
  XNOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst1_InstXOR_0__Compression1_U1 ( .A(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Reg[0]), .B(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Reg[1]), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst1_InstXOR_0__Compression1_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst1_InstXOR_0__Compression2_U2 ( .A(
        Inst_SKINNY_Sbox_1_Q294_inst1_InstXOR_0__Compression2_n3), .B(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Reg[5]), .ZN(
        Inst_SKINNY_Sbox_1_M2_out2[3]) );
  XNOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst1_InstXOR_0__Compression2_U1 ( .A(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Reg[3]), .B(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Reg[4]), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst1_InstXOR_0__Compression2_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst1_InstXOR_0__Compression3_U2 ( .A(
        Inst_SKINNY_Sbox_1_Q294_inst1_InstXOR_0__Compression3_n3), .B(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Reg[8]), .ZN(
        Inst_SKINNY_Sbox_1_M2_out3[3]) );
  XNOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst1_InstXOR_0__Compression3_U1 ( .A(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Reg[6]), .B(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Reg[7]), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst1_InstXOR_0__Compression3_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst1_InstXOR_1__Compression1_U2 ( .A(
        Inst_SKINNY_Sbox_1_Q294_inst1_InstXOR_1__Compression1_n3), .B(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Reg[11]), .ZN(
        Inst_SKINNY_Sbox_1_M2_out1[2]) );
  XNOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst1_InstXOR_1__Compression1_U1 ( .A(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Reg[9]), .B(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Reg[10]), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst1_InstXOR_1__Compression1_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst1_InstXOR_1__Compression2_U2 ( .A(
        Inst_SKINNY_Sbox_1_Q294_inst1_InstXOR_1__Compression2_n3), .B(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Reg[14]), .ZN(
        Inst_SKINNY_Sbox_1_M2_out2[2]) );
  XNOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst1_InstXOR_1__Compression2_U1 ( .A(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Reg[12]), .B(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Reg[13]), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst1_InstXOR_1__Compression2_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst1_InstXOR_1__Compression3_U2 ( .A(
        Inst_SKINNY_Sbox_1_Q294_inst1_InstXOR_1__Compression3_n3), .B(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Reg[17]), .ZN(
        Inst_SKINNY_Sbox_1_M2_out3[2]) );
  XNOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst1_InstXOR_1__Compression3_U1 ( .A(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Reg[15]), .B(
        Inst_SKINNY_Sbox_1_Q294_inst1_CF_Reg[16]), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst1_InstXOR_1__Compression3_n3) );
  DFF_X1 Inst_SKINNY_Sbox_1_Q294_inst2_CF_Reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Out[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_Q294_inst2_CF_Reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Out[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_Q294_inst2_CF_Reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Out[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_Q294_inst2_CF_Reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Out[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_Q294_inst2_CF_Reg_reg_4_ ( .D(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Out[4]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Reg[4]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_Q294_inst2_CF_Reg_reg_5_ ( .D(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Out[5]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Reg[5]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_Q294_inst2_CF_Reg_reg_6_ ( .D(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Out[6]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Reg[6]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_Q294_inst2_CF_Reg_reg_7_ ( .D(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Out[7]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Reg[7]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_Q294_inst2_CF_Reg_reg_8_ ( .D(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Out[8]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Reg[8]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_Q294_inst2_CF_Reg_reg_9_ ( .D(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Out[9]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Reg[9]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_Q294_inst2_CF_Reg_reg_10_ ( .D(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Out[10]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Reg[10]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_Q294_inst2_CF_Reg_reg_11_ ( .D(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Out[11]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Reg[11]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_Q294_inst2_CF_Reg_reg_12_ ( .D(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Out[12]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Reg[12]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_Q294_inst2_CF_Reg_reg_13_ ( .D(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Out[13]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Reg[13]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_Q294_inst2_CF_Reg_reg_14_ ( .D(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Out[14]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Reg[14]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_Q294_inst2_CF_Reg_reg_15_ ( .D(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Out[15]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Reg[15]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_Q294_inst2_CF_Reg_reg_16_ ( .D(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Out[16]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Reg[16]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_Q294_inst2_CF_Reg_reg_17_ ( .D(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Out[17]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Reg[17]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_Q294_inst2_dreg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_1_M2_out2_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_Q294_2_out1[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_Q294_inst2_dreg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_1_M2_out3_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_OutAff_out2[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_Q294_inst2_dreg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_1_M2_out1_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_OutAff_out3[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_Q294_inst2_creg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_1_M2_out2_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_Q294_2_out1[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_Q294_inst2_creg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_1_M2_out3_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_OutAff_out2[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_1_Q294_inst2_creg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_1_M2_out1_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_1_OutAff_out3[2]), .QN() );
  XNOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst2_Inst_0__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_1_Q294_inst2_Inst_0__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_1_M2_out2_reg[0]), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Out[0]) );
  NAND2_X1 Inst_SKINNY_Sbox_1_Q294_inst2_Inst_0__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_1_M2_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_1_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst2_Inst_0__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst2_Inst_1__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_1_Q294_inst2_Inst_1__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_1_Q294_inst2_Inst_1__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Out[1]) );
  NAND2_X1 Inst_SKINNY_Sbox_1_Q294_inst2_Inst_1__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_1_M2_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_1_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst2_Inst_1__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst2_Inst_1__CF_Inst_U1 ( .A(FRESH[12]), 
        .B(FRESH[13]), .Z(Inst_SKINNY_Sbox_1_Q294_inst2_Inst_1__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst2_Inst_2__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_1_Q294_inst2_Inst_2__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_1_Q294_inst2_Inst_2__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Out[2]) );
  NAND2_X1 Inst_SKINNY_Sbox_1_Q294_inst2_Inst_2__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_1_M2_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_1_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst2_Inst_2__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst2_Inst_2__CF_Inst_U1 ( .A(FRESH[13]), 
        .B(FRESH[14]), .Z(Inst_SKINNY_Sbox_1_Q294_inst2_Inst_2__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst2_Inst_3__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_1_Q294_inst2_Inst_3__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_1_M2_out3_reg[0]), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Out[3]) );
  NAND2_X1 Inst_SKINNY_Sbox_1_Q294_inst2_Inst_3__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_1_M2_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_1_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst2_Inst_3__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst2_Inst_4__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_1_Q294_inst2_Inst_4__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_1_Q294_inst2_Inst_4__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Out[4]) );
  NAND2_X1 Inst_SKINNY_Sbox_1_Q294_inst2_Inst_4__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_1_M2_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_1_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst2_Inst_4__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst2_Inst_4__CF_Inst_U1 ( .A(FRESH[14]), 
        .B(FRESH[15]), .Z(Inst_SKINNY_Sbox_1_Q294_inst2_Inst_4__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst2_Inst_5__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_1_Q294_inst2_Inst_5__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_1_Q294_inst2_Inst_5__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Out[5]) );
  NAND2_X1 Inst_SKINNY_Sbox_1_Q294_inst2_Inst_5__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_1_M2_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_1_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst2_Inst_5__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst2_Inst_5__CF_Inst_U1 ( .A(FRESH[15]), 
        .B(FRESH[16]), .Z(Inst_SKINNY_Sbox_1_Q294_inst2_Inst_5__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst2_Inst_6__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_1_Q294_inst2_Inst_6__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_1_M2_out1_reg[0]), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Out[6]) );
  NAND2_X1 Inst_SKINNY_Sbox_1_Q294_inst2_Inst_6__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_1_M2_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_1_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst2_Inst_6__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst2_Inst_7__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_1_Q294_inst2_Inst_7__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_1_Q294_inst2_Inst_7__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Out[7]) );
  NAND2_X1 Inst_SKINNY_Sbox_1_Q294_inst2_Inst_7__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_1_M2_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_1_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst2_Inst_7__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst2_Inst_7__CF_Inst_U1 ( .A(FRESH[16]), 
        .B(FRESH[17]), .Z(Inst_SKINNY_Sbox_1_Q294_inst2_Inst_7__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst2_Inst_8__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_1_Q294_inst2_Inst_8__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_1_Q294_inst2_Inst_8__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Out[8]) );
  NAND2_X1 Inst_SKINNY_Sbox_1_Q294_inst2_Inst_8__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_1_M2_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_1_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst2_Inst_8__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst2_Inst_8__CF_Inst_U1 ( .A(FRESH[17]), 
        .B(FRESH[12]), .Z(Inst_SKINNY_Sbox_1_Q294_inst2_Inst_8__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst2_Inst_9__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_1_Q294_inst2_Inst_9__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_1_M2_out2_reg[1]), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Out[9]) );
  NAND2_X1 Inst_SKINNY_Sbox_1_Q294_inst2_Inst_9__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_1_M2_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_1_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst2_Inst_9__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst2_Inst_10__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_1_Q294_inst2_Inst_10__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_1_Q294_inst2_Inst_10__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Out[10]) );
  NAND2_X1 Inst_SKINNY_Sbox_1_Q294_inst2_Inst_10__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_1_M2_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_1_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst2_Inst_10__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst2_Inst_10__CF_Inst_U1 ( .A(FRESH[18]), 
        .B(FRESH[19]), .Z(Inst_SKINNY_Sbox_1_Q294_inst2_Inst_10__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst2_Inst_11__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_1_Q294_inst2_Inst_11__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_1_Q294_inst2_Inst_11__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Out[11]) );
  NAND2_X1 Inst_SKINNY_Sbox_1_Q294_inst2_Inst_11__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_1_M2_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_1_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst2_Inst_11__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst2_Inst_11__CF_Inst_U1 ( .A(FRESH[19]), 
        .B(FRESH[20]), .Z(Inst_SKINNY_Sbox_1_Q294_inst2_Inst_11__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst2_Inst_12__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_1_Q294_inst2_Inst_12__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_1_M2_out3_reg[1]), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Out[12]) );
  NAND2_X1 Inst_SKINNY_Sbox_1_Q294_inst2_Inst_12__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_1_M2_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_1_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst2_Inst_12__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst2_Inst_13__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_1_Q294_inst2_Inst_13__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_1_Q294_inst2_Inst_13__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Out[13]) );
  NAND2_X1 Inst_SKINNY_Sbox_1_Q294_inst2_Inst_13__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_1_M2_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_1_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst2_Inst_13__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst2_Inst_13__CF_Inst_U1 ( .A(FRESH[20]), 
        .B(FRESH[21]), .Z(Inst_SKINNY_Sbox_1_Q294_inst2_Inst_13__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst2_Inst_14__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_1_Q294_inst2_Inst_14__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_1_Q294_inst2_Inst_14__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Out[14]) );
  NAND2_X1 Inst_SKINNY_Sbox_1_Q294_inst2_Inst_14__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_1_M2_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_1_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst2_Inst_14__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst2_Inst_14__CF_Inst_U1 ( .A(FRESH[21]), 
        .B(FRESH[22]), .Z(Inst_SKINNY_Sbox_1_Q294_inst2_Inst_14__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst2_Inst_15__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_1_Q294_inst2_Inst_15__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_1_M2_out1_reg[1]), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Out[15]) );
  NAND2_X1 Inst_SKINNY_Sbox_1_Q294_inst2_Inst_15__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_1_M2_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_1_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst2_Inst_15__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst2_Inst_16__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_1_Q294_inst2_Inst_16__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_1_Q294_inst2_Inst_16__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Out[16]) );
  NAND2_X1 Inst_SKINNY_Sbox_1_Q294_inst2_Inst_16__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_1_M2_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_1_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst2_Inst_16__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst2_Inst_16__CF_Inst_U1 ( .A(FRESH[22]), 
        .B(FRESH[23]), .Z(Inst_SKINNY_Sbox_1_Q294_inst2_Inst_16__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst2_Inst_17__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_1_Q294_inst2_Inst_17__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_1_Q294_inst2_Inst_17__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Out[17]) );
  NAND2_X1 Inst_SKINNY_Sbox_1_Q294_inst2_Inst_17__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_1_M2_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_1_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst2_Inst_17__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst2_Inst_17__CF_Inst_U1 ( .A(FRESH[23]), 
        .B(FRESH[18]), .Z(Inst_SKINNY_Sbox_1_Q294_inst2_Inst_17__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst2_InstXOR_0__Compression1_U2 ( .A(
        Inst_SKINNY_Sbox_1_Q294_inst2_InstXOR_0__Compression1_n3), .B(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Reg[2]), .ZN(
        Inst_SKINNY_Sbox_1_Q294_2_out1[0]) );
  XNOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst2_InstXOR_0__Compression1_U1 ( .A(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Reg[0]), .B(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Reg[1]), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst2_InstXOR_0__Compression1_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst2_InstXOR_0__Compression2_U2 ( .A(
        Inst_SKINNY_Sbox_1_Q294_inst2_InstXOR_0__Compression2_n3), .B(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Reg[5]), .ZN(
        Inst_SKINNY_Sbox_1_OutAff_out2[1]) );
  XNOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst2_InstXOR_0__Compression2_U1 ( .A(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Reg[3]), .B(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Reg[4]), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst2_InstXOR_0__Compression2_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst2_InstXOR_0__Compression3_U2 ( .A(
        Inst_SKINNY_Sbox_1_Q294_inst2_InstXOR_0__Compression3_n3), .B(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Reg[8]), .ZN(
        Inst_SKINNY_Sbox_1_OutAff_out3[1]) );
  XNOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst2_InstXOR_0__Compression3_U1 ( .A(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Reg[6]), .B(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Reg[7]), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst2_InstXOR_0__Compression3_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst2_InstXOR_1__Compression1_U2 ( .A(
        Inst_SKINNY_Sbox_1_Q294_inst2_InstXOR_1__Compression1_n3), .B(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Reg[11]), .ZN(
        Inst_SKINNY_Sbox_1_Q294_2_out1[1]) );
  XNOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst2_InstXOR_1__Compression1_U1 ( .A(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Reg[9]), .B(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Reg[10]), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst2_InstXOR_1__Compression1_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst2_InstXOR_1__Compression2_U2 ( .A(
        Inst_SKINNY_Sbox_1_Q294_inst2_InstXOR_1__Compression2_n3), .B(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Reg[14]), .ZN(
        Inst_SKINNY_Sbox_1_OutAff_out2[0]) );
  XNOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst2_InstXOR_1__Compression2_U1 ( .A(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Reg[12]), .B(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Reg[13]), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst2_InstXOR_1__Compression2_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst2_InstXOR_1__Compression3_U2 ( .A(
        Inst_SKINNY_Sbox_1_Q294_inst2_InstXOR_1__Compression3_n3), .B(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Reg[17]), .ZN(
        Inst_SKINNY_Sbox_1_OutAff_out3[0]) );
  XNOR2_X1 Inst_SKINNY_Sbox_1_Q294_inst2_InstXOR_1__Compression3_U1 ( .A(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Reg[15]), .B(
        Inst_SKINNY_Sbox_1_Q294_inst2_CF_Reg[16]), .ZN(
        Inst_SKINNY_Sbox_1_Q294_inst2_InstXOR_1__Compression3_n3) );
  INV_X1 Inst_SKINNY_Sbox_1_OutputAffine_U4 ( .A(
        Inst_SKINNY_Sbox_1_Q294_2_out1[3]), .ZN(
        Inst_SKINNY_Sbox_1_OutAff_out1[3]) );
  INV_X1 Inst_SKINNY_Sbox_1_OutputAffine_U3 ( .A(
        Inst_SKINNY_Sbox_1_Q294_2_out1[2]), .ZN(
        Inst_SKINNY_Sbox_1_OutAff_out1[2]) );
  INV_X1 Inst_SKINNY_Sbox_1_OutputAffine_U2 ( .A(
        Inst_SKINNY_Sbox_1_Q294_2_out1[1]), .ZN(
        Inst_SKINNY_Sbox_1_OutAff_out1[0]) );
  INV_X1 Inst_SKINNY_Sbox_1_OutputAffine_U1 ( .A(
        Inst_SKINNY_Sbox_1_Q294_2_out1[0]), .ZN(
        Inst_SKINNY_Sbox_1_OutAff_out1[1]) );
  XNOR2_X1 Inst_SKINNY_Sbox_2_U18 ( .A(Inst_SKINNY_Sbox_2_n12), .B(FRESH[31]), 
        .ZN(RF3_SHIFTROWS[15]) );
  XNOR2_X1 Inst_SKINNY_Sbox_2_U17 ( .A(FRESH[27]), .B(
        Inst_SKINNY_Sbox_2_OutAff_out3[3]), .ZN(Inst_SKINNY_Sbox_2_n12) );
  XNOR2_X1 Inst_SKINNY_Sbox_2_U16 ( .A(Inst_SKINNY_Sbox_2_n11), .B(FRESH[30]), 
        .ZN(RF3_SHIFTROWS[14]) );
  XNOR2_X1 Inst_SKINNY_Sbox_2_U15 ( .A(FRESH[26]), .B(
        Inst_SKINNY_Sbox_2_OutAff_out3[2]), .ZN(Inst_SKINNY_Sbox_2_n11) );
  XNOR2_X1 Inst_SKINNY_Sbox_2_U14 ( .A(Inst_SKINNY_Sbox_2_n10), .B(FRESH[29]), 
        .ZN(RF3_SHIFTROWS[13]) );
  XNOR2_X1 Inst_SKINNY_Sbox_2_U13 ( .A(FRESH[25]), .B(
        Inst_SKINNY_Sbox_2_OutAff_out3[1]), .ZN(Inst_SKINNY_Sbox_2_n10) );
  XNOR2_X1 Inst_SKINNY_Sbox_2_U12 ( .A(Inst_SKINNY_Sbox_2_n9), .B(FRESH[28]), 
        .ZN(RF3_SHIFTROWS[12]) );
  XNOR2_X1 Inst_SKINNY_Sbox_2_U11 ( .A(FRESH[24]), .B(
        Inst_SKINNY_Sbox_2_OutAff_out3[0]), .ZN(Inst_SKINNY_Sbox_2_n9) );
  XOR2_X1 Inst_SKINNY_Sbox_2_U10 ( .A(FRESH[31]), .B(
        Inst_SKINNY_Sbox_2_OutAff_out2[3]), .Z(RF2_SHIFTROWS[15]) );
  XOR2_X1 Inst_SKINNY_Sbox_2_U9 ( .A(FRESH[30]), .B(
        Inst_SKINNY_Sbox_2_OutAff_out2[2]), .Z(RF2_SHIFTROWS[14]) );
  XOR2_X1 Inst_SKINNY_Sbox_2_U8 ( .A(FRESH[29]), .B(
        Inst_SKINNY_Sbox_2_OutAff_out2[1]), .Z(RF2_SHIFTROWS[13]) );
  XOR2_X1 Inst_SKINNY_Sbox_2_U7 ( .A(FRESH[28]), .B(
        Inst_SKINNY_Sbox_2_OutAff_out2[0]), .Z(RF2_SHIFTROWS[12]) );
  XOR2_X1 Inst_SKINNY_Sbox_2_U6 ( .A(FRESH[27]), .B(
        Inst_SKINNY_Sbox_2_OutAff_out1[3]), .Z(RF1_SHIFTROWS[15]) );
  XOR2_X1 Inst_SKINNY_Sbox_2_U5 ( .A(FRESH[26]), .B(
        Inst_SKINNY_Sbox_2_OutAff_out1[2]), .Z(RF1_SHIFTROWS[14]) );
  XOR2_X1 Inst_SKINNY_Sbox_2_U4 ( .A(FRESH[25]), .B(
        Inst_SKINNY_Sbox_2_OutAff_out1[1]), .Z(RF1_SHIFTROWS[13]) );
  XOR2_X1 Inst_SKINNY_Sbox_2_U3 ( .A(FRESH[24]), .B(
        Inst_SKINNY_Sbox_2_OutAff_out1[0]), .Z(RF1_SHIFTROWS[12]) );
  DFF_X1 Inst_SKINNY_Sbox_2_M2_out3_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_2_M2_out3[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_M2_out3_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_M2_out3_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_2_M2_out3[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_M2_out3_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_M2_out3_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_2_M2_out3[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_M2_out3_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_M2_out3_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_2_M2_out3[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_M2_out3_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_M2_out2_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_2_M2_out2[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_M2_out2_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_M2_out2_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_2_M2_out2[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_M2_out2_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_M2_out2_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_2_M2_out2[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_M2_out2_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_M2_out2_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_2_M2_out2[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_M2_out2_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_M2_out1_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_2_M2_out1[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_M2_out1_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_M2_out1_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_2_M2_out1[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_M2_out1_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_M2_out1_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_2_M2_out1[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_M2_out1_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_M2_out1_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_2_M2_out1[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_M2_out1_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_InAff_out3_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_2_InAff_out3[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_InAff_out3_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_InAff_out3_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_2_InAff_out3[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_InAff_out3_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_InAff_out3_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_2_InAff_out3[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_InAff_out3_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_InAff_out3_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_2_InAff_out3[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_InAff_out3_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_InAff_out2_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_2_InAff_out2[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_InAff_out2_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_InAff_out2_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_2_InAff_out2[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_InAff_out2_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_InAff_out2_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_2_InAff_out2[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_InAff_out2_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_InAff_out2_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_2_InAff_out2[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_InAff_out2_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_InAff_out1_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_2_InAff_out1[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_InAff_out1_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_InAff_out1_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_2_InAff_out1[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_InAff_out1_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_InAff_out1_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_2_InAff_out1[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_InAff_out1_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_InAff_out1_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_2_InAff_out1[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_InAff_out1_reg[3]), .QN() );
  INV_X1 Inst_SKINNY_Sbox_2_InputAffine_U4 ( .A(SUB_IN1[11]), .ZN(
        Inst_SKINNY_Sbox_2_InAff_out1[1]) );
  INV_X1 Inst_SKINNY_Sbox_2_InputAffine_U3 ( .A(SUB_IN1[10]), .ZN(
        Inst_SKINNY_Sbox_2_InAff_out1[3]) );
  INV_X1 Inst_SKINNY_Sbox_2_InputAffine_U2 ( .A(SUB_IN1[9]), .ZN(
        Inst_SKINNY_Sbox_2_InAff_out1[2]) );
  INV_X1 Inst_SKINNY_Sbox_2_InputAffine_U1 ( .A(SUB_IN1[8]), .ZN(
        Inst_SKINNY_Sbox_2_InAff_out1[0]) );
  DFF_X1 Inst_SKINNY_Sbox_2_Q294_inst1_CF_Reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Out[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_Q294_inst1_CF_Reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Out[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_Q294_inst1_CF_Reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Out[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_Q294_inst1_CF_Reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Out[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_Q294_inst1_CF_Reg_reg_4_ ( .D(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Out[4]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Reg[4]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_Q294_inst1_CF_Reg_reg_5_ ( .D(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Out[5]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Reg[5]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_Q294_inst1_CF_Reg_reg_6_ ( .D(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Out[6]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Reg[6]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_Q294_inst1_CF_Reg_reg_7_ ( .D(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Out[7]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Reg[7]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_Q294_inst1_CF_Reg_reg_8_ ( .D(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Out[8]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Reg[8]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_Q294_inst1_CF_Reg_reg_9_ ( .D(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Out[9]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Reg[9]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_Q294_inst1_CF_Reg_reg_10_ ( .D(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Out[10]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Reg[10]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_Q294_inst1_CF_Reg_reg_11_ ( .D(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Out[11]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Reg[11]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_Q294_inst1_CF_Reg_reg_12_ ( .D(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Out[12]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Reg[12]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_Q294_inst1_CF_Reg_reg_13_ ( .D(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Out[13]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Reg[13]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_Q294_inst1_CF_Reg_reg_14_ ( .D(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Out[14]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Reg[14]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_Q294_inst1_CF_Reg_reg_15_ ( .D(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Out[15]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Reg[15]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_Q294_inst1_CF_Reg_reg_16_ ( .D(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Out[16]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Reg[16]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_Q294_inst1_CF_Reg_reg_17_ ( .D(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Out[17]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Reg[17]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_Q294_inst1_dreg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_2_InAff_out2_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_M2_out1[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_Q294_inst1_dreg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_2_InAff_out3_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_M2_out2[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_Q294_inst1_dreg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_2_InAff_out1_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_M2_out3[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_Q294_inst1_creg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_2_InAff_out2_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_M2_out1[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_Q294_inst1_creg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_2_InAff_out3_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_M2_out2[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_Q294_inst1_creg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_2_InAff_out1_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_M2_out3[1]), .QN() );
  XNOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst1_Inst_0__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_2_Q294_inst1_Inst_0__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_2_InAff_out2_reg[0]), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Out[0]) );
  NAND2_X1 Inst_SKINNY_Sbox_2_Q294_inst1_Inst_0__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_2_InAff_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_2_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst1_Inst_0__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst1_Inst_1__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_2_Q294_inst1_Inst_1__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_2_Q294_inst1_Inst_1__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Out[1]) );
  NAND2_X1 Inst_SKINNY_Sbox_2_Q294_inst1_Inst_1__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_2_InAff_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_2_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst1_Inst_1__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst1_Inst_1__CF_Inst_U1 ( .A(FRESH[0]), .B(
        FRESH[1]), .Z(Inst_SKINNY_Sbox_2_Q294_inst1_Inst_1__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst1_Inst_2__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_2_Q294_inst1_Inst_2__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_2_Q294_inst1_Inst_2__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Out[2]) );
  NAND2_X1 Inst_SKINNY_Sbox_2_Q294_inst1_Inst_2__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_2_InAff_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_2_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst1_Inst_2__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst1_Inst_2__CF_Inst_U1 ( .A(FRESH[1]), .B(
        FRESH[2]), .Z(Inst_SKINNY_Sbox_2_Q294_inst1_Inst_2__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst1_Inst_3__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_2_Q294_inst1_Inst_3__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_2_InAff_out3_reg[0]), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Out[3]) );
  NAND2_X1 Inst_SKINNY_Sbox_2_Q294_inst1_Inst_3__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_2_InAff_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_2_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst1_Inst_3__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst1_Inst_4__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_2_Q294_inst1_Inst_4__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_2_Q294_inst1_Inst_4__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Out[4]) );
  NAND2_X1 Inst_SKINNY_Sbox_2_Q294_inst1_Inst_4__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_2_InAff_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_2_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst1_Inst_4__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst1_Inst_4__CF_Inst_U1 ( .A(FRESH[2]), .B(
        FRESH[3]), .Z(Inst_SKINNY_Sbox_2_Q294_inst1_Inst_4__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst1_Inst_5__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_2_Q294_inst1_Inst_5__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_2_Q294_inst1_Inst_5__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Out[5]) );
  NAND2_X1 Inst_SKINNY_Sbox_2_Q294_inst1_Inst_5__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_2_InAff_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_2_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst1_Inst_5__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst1_Inst_5__CF_Inst_U1 ( .A(FRESH[3]), .B(
        FRESH[4]), .Z(Inst_SKINNY_Sbox_2_Q294_inst1_Inst_5__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst1_Inst_6__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_2_Q294_inst1_Inst_6__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_2_InAff_out1_reg[0]), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Out[6]) );
  NAND2_X1 Inst_SKINNY_Sbox_2_Q294_inst1_Inst_6__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_2_InAff_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_2_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst1_Inst_6__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst1_Inst_7__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_2_Q294_inst1_Inst_7__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_2_Q294_inst1_Inst_7__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Out[7]) );
  NAND2_X1 Inst_SKINNY_Sbox_2_Q294_inst1_Inst_7__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_2_InAff_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_2_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst1_Inst_7__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst1_Inst_7__CF_Inst_U1 ( .A(FRESH[4]), .B(
        FRESH[5]), .Z(Inst_SKINNY_Sbox_2_Q294_inst1_Inst_7__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst1_Inst_8__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_2_Q294_inst1_Inst_8__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_2_Q294_inst1_Inst_8__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Out[8]) );
  NAND2_X1 Inst_SKINNY_Sbox_2_Q294_inst1_Inst_8__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_2_InAff_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_2_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst1_Inst_8__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst1_Inst_8__CF_Inst_U1 ( .A(FRESH[5]), .B(
        FRESH[0]), .Z(Inst_SKINNY_Sbox_2_Q294_inst1_Inst_8__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst1_Inst_9__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_2_Q294_inst1_Inst_9__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_2_InAff_out2_reg[1]), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Out[9]) );
  NAND2_X1 Inst_SKINNY_Sbox_2_Q294_inst1_Inst_9__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_2_InAff_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_2_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst1_Inst_9__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst1_Inst_10__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_2_Q294_inst1_Inst_10__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_2_Q294_inst1_Inst_10__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Out[10]) );
  NAND2_X1 Inst_SKINNY_Sbox_2_Q294_inst1_Inst_10__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_2_InAff_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_2_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst1_Inst_10__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst1_Inst_10__CF_Inst_U1 ( .A(FRESH[6]), 
        .B(FRESH[7]), .Z(Inst_SKINNY_Sbox_2_Q294_inst1_Inst_10__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst1_Inst_11__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_2_Q294_inst1_Inst_11__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_2_Q294_inst1_Inst_11__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Out[11]) );
  NAND2_X1 Inst_SKINNY_Sbox_2_Q294_inst1_Inst_11__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_2_InAff_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_2_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst1_Inst_11__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst1_Inst_11__CF_Inst_U1 ( .A(FRESH[7]), 
        .B(FRESH[8]), .Z(Inst_SKINNY_Sbox_2_Q294_inst1_Inst_11__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst1_Inst_12__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_2_Q294_inst1_Inst_12__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_2_InAff_out3_reg[1]), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Out[12]) );
  NAND2_X1 Inst_SKINNY_Sbox_2_Q294_inst1_Inst_12__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_2_InAff_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_2_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst1_Inst_12__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst1_Inst_13__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_2_Q294_inst1_Inst_13__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_2_Q294_inst1_Inst_13__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Out[13]) );
  NAND2_X1 Inst_SKINNY_Sbox_2_Q294_inst1_Inst_13__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_2_InAff_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_2_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst1_Inst_13__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst1_Inst_13__CF_Inst_U1 ( .A(FRESH[8]), 
        .B(FRESH[9]), .Z(Inst_SKINNY_Sbox_2_Q294_inst1_Inst_13__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst1_Inst_14__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_2_Q294_inst1_Inst_14__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_2_Q294_inst1_Inst_14__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Out[14]) );
  NAND2_X1 Inst_SKINNY_Sbox_2_Q294_inst1_Inst_14__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_2_InAff_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_2_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst1_Inst_14__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst1_Inst_14__CF_Inst_U1 ( .A(FRESH[9]), 
        .B(FRESH[10]), .Z(Inst_SKINNY_Sbox_2_Q294_inst1_Inst_14__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst1_Inst_15__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_2_Q294_inst1_Inst_15__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_2_InAff_out1_reg[1]), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Out[15]) );
  NAND2_X1 Inst_SKINNY_Sbox_2_Q294_inst1_Inst_15__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_2_InAff_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_2_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst1_Inst_15__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst1_Inst_16__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_2_Q294_inst1_Inst_16__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_2_Q294_inst1_Inst_16__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Out[16]) );
  NAND2_X1 Inst_SKINNY_Sbox_2_Q294_inst1_Inst_16__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_2_InAff_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_2_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst1_Inst_16__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst1_Inst_16__CF_Inst_U1 ( .A(FRESH[10]), 
        .B(FRESH[11]), .Z(Inst_SKINNY_Sbox_2_Q294_inst1_Inst_16__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst1_Inst_17__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_2_Q294_inst1_Inst_17__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_2_Q294_inst1_Inst_17__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Out[17]) );
  NAND2_X1 Inst_SKINNY_Sbox_2_Q294_inst1_Inst_17__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_2_InAff_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_2_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst1_Inst_17__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst1_Inst_17__CF_Inst_U1 ( .A(FRESH[11]), 
        .B(FRESH[6]), .Z(Inst_SKINNY_Sbox_2_Q294_inst1_Inst_17__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst1_InstXOR_0__Compression1_U2 ( .A(
        Inst_SKINNY_Sbox_2_Q294_inst1_InstXOR_0__Compression1_n3), .B(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Reg[2]), .ZN(
        Inst_SKINNY_Sbox_2_M2_out1[3]) );
  XNOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst1_InstXOR_0__Compression1_U1 ( .A(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Reg[0]), .B(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Reg[1]), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst1_InstXOR_0__Compression1_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst1_InstXOR_0__Compression2_U2 ( .A(
        Inst_SKINNY_Sbox_2_Q294_inst1_InstXOR_0__Compression2_n3), .B(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Reg[5]), .ZN(
        Inst_SKINNY_Sbox_2_M2_out2[3]) );
  XNOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst1_InstXOR_0__Compression2_U1 ( .A(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Reg[3]), .B(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Reg[4]), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst1_InstXOR_0__Compression2_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst1_InstXOR_0__Compression3_U2 ( .A(
        Inst_SKINNY_Sbox_2_Q294_inst1_InstXOR_0__Compression3_n3), .B(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Reg[8]), .ZN(
        Inst_SKINNY_Sbox_2_M2_out3[3]) );
  XNOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst1_InstXOR_0__Compression3_U1 ( .A(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Reg[6]), .B(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Reg[7]), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst1_InstXOR_0__Compression3_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst1_InstXOR_1__Compression1_U2 ( .A(
        Inst_SKINNY_Sbox_2_Q294_inst1_InstXOR_1__Compression1_n3), .B(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Reg[11]), .ZN(
        Inst_SKINNY_Sbox_2_M2_out1[2]) );
  XNOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst1_InstXOR_1__Compression1_U1 ( .A(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Reg[9]), .B(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Reg[10]), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst1_InstXOR_1__Compression1_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst1_InstXOR_1__Compression2_U2 ( .A(
        Inst_SKINNY_Sbox_2_Q294_inst1_InstXOR_1__Compression2_n3), .B(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Reg[14]), .ZN(
        Inst_SKINNY_Sbox_2_M2_out2[2]) );
  XNOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst1_InstXOR_1__Compression2_U1 ( .A(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Reg[12]), .B(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Reg[13]), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst1_InstXOR_1__Compression2_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst1_InstXOR_1__Compression3_U2 ( .A(
        Inst_SKINNY_Sbox_2_Q294_inst1_InstXOR_1__Compression3_n3), .B(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Reg[17]), .ZN(
        Inst_SKINNY_Sbox_2_M2_out3[2]) );
  XNOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst1_InstXOR_1__Compression3_U1 ( .A(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Reg[15]), .B(
        Inst_SKINNY_Sbox_2_Q294_inst1_CF_Reg[16]), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst1_InstXOR_1__Compression3_n3) );
  DFF_X1 Inst_SKINNY_Sbox_2_Q294_inst2_CF_Reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Out[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_Q294_inst2_CF_Reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Out[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_Q294_inst2_CF_Reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Out[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_Q294_inst2_CF_Reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Out[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_Q294_inst2_CF_Reg_reg_4_ ( .D(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Out[4]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Reg[4]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_Q294_inst2_CF_Reg_reg_5_ ( .D(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Out[5]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Reg[5]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_Q294_inst2_CF_Reg_reg_6_ ( .D(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Out[6]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Reg[6]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_Q294_inst2_CF_Reg_reg_7_ ( .D(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Out[7]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Reg[7]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_Q294_inst2_CF_Reg_reg_8_ ( .D(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Out[8]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Reg[8]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_Q294_inst2_CF_Reg_reg_9_ ( .D(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Out[9]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Reg[9]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_Q294_inst2_CF_Reg_reg_10_ ( .D(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Out[10]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Reg[10]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_Q294_inst2_CF_Reg_reg_11_ ( .D(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Out[11]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Reg[11]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_Q294_inst2_CF_Reg_reg_12_ ( .D(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Out[12]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Reg[12]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_Q294_inst2_CF_Reg_reg_13_ ( .D(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Out[13]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Reg[13]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_Q294_inst2_CF_Reg_reg_14_ ( .D(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Out[14]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Reg[14]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_Q294_inst2_CF_Reg_reg_15_ ( .D(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Out[15]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Reg[15]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_Q294_inst2_CF_Reg_reg_16_ ( .D(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Out[16]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Reg[16]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_Q294_inst2_CF_Reg_reg_17_ ( .D(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Out[17]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Reg[17]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_Q294_inst2_dreg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_2_M2_out2_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_Q294_2_out1[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_Q294_inst2_dreg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_2_M2_out3_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_OutAff_out2[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_Q294_inst2_dreg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_2_M2_out1_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_OutAff_out3[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_Q294_inst2_creg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_2_M2_out2_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_Q294_2_out1[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_Q294_inst2_creg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_2_M2_out3_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_OutAff_out2[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_2_Q294_inst2_creg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_2_M2_out1_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_2_OutAff_out3[2]), .QN() );
  XNOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst2_Inst_0__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_2_Q294_inst2_Inst_0__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_2_M2_out2_reg[0]), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Out[0]) );
  NAND2_X1 Inst_SKINNY_Sbox_2_Q294_inst2_Inst_0__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_2_M2_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_2_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst2_Inst_0__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst2_Inst_1__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_2_Q294_inst2_Inst_1__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_2_Q294_inst2_Inst_1__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Out[1]) );
  NAND2_X1 Inst_SKINNY_Sbox_2_Q294_inst2_Inst_1__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_2_M2_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_2_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst2_Inst_1__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst2_Inst_1__CF_Inst_U1 ( .A(FRESH[12]), 
        .B(FRESH[13]), .Z(Inst_SKINNY_Sbox_2_Q294_inst2_Inst_1__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst2_Inst_2__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_2_Q294_inst2_Inst_2__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_2_Q294_inst2_Inst_2__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Out[2]) );
  NAND2_X1 Inst_SKINNY_Sbox_2_Q294_inst2_Inst_2__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_2_M2_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_2_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst2_Inst_2__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst2_Inst_2__CF_Inst_U1 ( .A(FRESH[13]), 
        .B(FRESH[14]), .Z(Inst_SKINNY_Sbox_2_Q294_inst2_Inst_2__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst2_Inst_3__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_2_Q294_inst2_Inst_3__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_2_M2_out3_reg[0]), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Out[3]) );
  NAND2_X1 Inst_SKINNY_Sbox_2_Q294_inst2_Inst_3__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_2_M2_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_2_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst2_Inst_3__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst2_Inst_4__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_2_Q294_inst2_Inst_4__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_2_Q294_inst2_Inst_4__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Out[4]) );
  NAND2_X1 Inst_SKINNY_Sbox_2_Q294_inst2_Inst_4__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_2_M2_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_2_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst2_Inst_4__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst2_Inst_4__CF_Inst_U1 ( .A(FRESH[14]), 
        .B(FRESH[15]), .Z(Inst_SKINNY_Sbox_2_Q294_inst2_Inst_4__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst2_Inst_5__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_2_Q294_inst2_Inst_5__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_2_Q294_inst2_Inst_5__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Out[5]) );
  NAND2_X1 Inst_SKINNY_Sbox_2_Q294_inst2_Inst_5__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_2_M2_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_2_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst2_Inst_5__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst2_Inst_5__CF_Inst_U1 ( .A(FRESH[15]), 
        .B(FRESH[16]), .Z(Inst_SKINNY_Sbox_2_Q294_inst2_Inst_5__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst2_Inst_6__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_2_Q294_inst2_Inst_6__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_2_M2_out1_reg[0]), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Out[6]) );
  NAND2_X1 Inst_SKINNY_Sbox_2_Q294_inst2_Inst_6__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_2_M2_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_2_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst2_Inst_6__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst2_Inst_7__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_2_Q294_inst2_Inst_7__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_2_Q294_inst2_Inst_7__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Out[7]) );
  NAND2_X1 Inst_SKINNY_Sbox_2_Q294_inst2_Inst_7__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_2_M2_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_2_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst2_Inst_7__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst2_Inst_7__CF_Inst_U1 ( .A(FRESH[16]), 
        .B(FRESH[17]), .Z(Inst_SKINNY_Sbox_2_Q294_inst2_Inst_7__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst2_Inst_8__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_2_Q294_inst2_Inst_8__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_2_Q294_inst2_Inst_8__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Out[8]) );
  NAND2_X1 Inst_SKINNY_Sbox_2_Q294_inst2_Inst_8__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_2_M2_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_2_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst2_Inst_8__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst2_Inst_8__CF_Inst_U1 ( .A(FRESH[17]), 
        .B(FRESH[12]), .Z(Inst_SKINNY_Sbox_2_Q294_inst2_Inst_8__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst2_Inst_9__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_2_Q294_inst2_Inst_9__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_2_M2_out2_reg[1]), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Out[9]) );
  NAND2_X1 Inst_SKINNY_Sbox_2_Q294_inst2_Inst_9__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_2_M2_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_2_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst2_Inst_9__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst2_Inst_10__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_2_Q294_inst2_Inst_10__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_2_Q294_inst2_Inst_10__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Out[10]) );
  NAND2_X1 Inst_SKINNY_Sbox_2_Q294_inst2_Inst_10__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_2_M2_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_2_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst2_Inst_10__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst2_Inst_10__CF_Inst_U1 ( .A(FRESH[18]), 
        .B(FRESH[19]), .Z(Inst_SKINNY_Sbox_2_Q294_inst2_Inst_10__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst2_Inst_11__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_2_Q294_inst2_Inst_11__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_2_Q294_inst2_Inst_11__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Out[11]) );
  NAND2_X1 Inst_SKINNY_Sbox_2_Q294_inst2_Inst_11__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_2_M2_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_2_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst2_Inst_11__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst2_Inst_11__CF_Inst_U1 ( .A(FRESH[19]), 
        .B(FRESH[20]), .Z(Inst_SKINNY_Sbox_2_Q294_inst2_Inst_11__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst2_Inst_12__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_2_Q294_inst2_Inst_12__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_2_M2_out3_reg[1]), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Out[12]) );
  NAND2_X1 Inst_SKINNY_Sbox_2_Q294_inst2_Inst_12__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_2_M2_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_2_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst2_Inst_12__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst2_Inst_13__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_2_Q294_inst2_Inst_13__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_2_Q294_inst2_Inst_13__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Out[13]) );
  NAND2_X1 Inst_SKINNY_Sbox_2_Q294_inst2_Inst_13__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_2_M2_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_2_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst2_Inst_13__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst2_Inst_13__CF_Inst_U1 ( .A(FRESH[20]), 
        .B(FRESH[21]), .Z(Inst_SKINNY_Sbox_2_Q294_inst2_Inst_13__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst2_Inst_14__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_2_Q294_inst2_Inst_14__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_2_Q294_inst2_Inst_14__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Out[14]) );
  NAND2_X1 Inst_SKINNY_Sbox_2_Q294_inst2_Inst_14__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_2_M2_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_2_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst2_Inst_14__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst2_Inst_14__CF_Inst_U1 ( .A(FRESH[21]), 
        .B(FRESH[22]), .Z(Inst_SKINNY_Sbox_2_Q294_inst2_Inst_14__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst2_Inst_15__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_2_Q294_inst2_Inst_15__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_2_M2_out1_reg[1]), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Out[15]) );
  NAND2_X1 Inst_SKINNY_Sbox_2_Q294_inst2_Inst_15__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_2_M2_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_2_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst2_Inst_15__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst2_Inst_16__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_2_Q294_inst2_Inst_16__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_2_Q294_inst2_Inst_16__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Out[16]) );
  NAND2_X1 Inst_SKINNY_Sbox_2_Q294_inst2_Inst_16__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_2_M2_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_2_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst2_Inst_16__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst2_Inst_16__CF_Inst_U1 ( .A(FRESH[22]), 
        .B(FRESH[23]), .Z(Inst_SKINNY_Sbox_2_Q294_inst2_Inst_16__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst2_Inst_17__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_2_Q294_inst2_Inst_17__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_2_Q294_inst2_Inst_17__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Out[17]) );
  NAND2_X1 Inst_SKINNY_Sbox_2_Q294_inst2_Inst_17__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_2_M2_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_2_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst2_Inst_17__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst2_Inst_17__CF_Inst_U1 ( .A(FRESH[23]), 
        .B(FRESH[18]), .Z(Inst_SKINNY_Sbox_2_Q294_inst2_Inst_17__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst2_InstXOR_0__Compression1_U2 ( .A(
        Inst_SKINNY_Sbox_2_Q294_inst2_InstXOR_0__Compression1_n3), .B(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Reg[2]), .ZN(
        Inst_SKINNY_Sbox_2_Q294_2_out1[0]) );
  XNOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst2_InstXOR_0__Compression1_U1 ( .A(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Reg[0]), .B(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Reg[1]), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst2_InstXOR_0__Compression1_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst2_InstXOR_0__Compression2_U2 ( .A(
        Inst_SKINNY_Sbox_2_Q294_inst2_InstXOR_0__Compression2_n3), .B(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Reg[5]), .ZN(
        Inst_SKINNY_Sbox_2_OutAff_out2[1]) );
  XNOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst2_InstXOR_0__Compression2_U1 ( .A(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Reg[3]), .B(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Reg[4]), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst2_InstXOR_0__Compression2_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst2_InstXOR_0__Compression3_U2 ( .A(
        Inst_SKINNY_Sbox_2_Q294_inst2_InstXOR_0__Compression3_n3), .B(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Reg[8]), .ZN(
        Inst_SKINNY_Sbox_2_OutAff_out3[1]) );
  XNOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst2_InstXOR_0__Compression3_U1 ( .A(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Reg[6]), .B(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Reg[7]), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst2_InstXOR_0__Compression3_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst2_InstXOR_1__Compression1_U2 ( .A(
        Inst_SKINNY_Sbox_2_Q294_inst2_InstXOR_1__Compression1_n3), .B(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Reg[11]), .ZN(
        Inst_SKINNY_Sbox_2_Q294_2_out1[1]) );
  XNOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst2_InstXOR_1__Compression1_U1 ( .A(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Reg[9]), .B(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Reg[10]), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst2_InstXOR_1__Compression1_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst2_InstXOR_1__Compression2_U2 ( .A(
        Inst_SKINNY_Sbox_2_Q294_inst2_InstXOR_1__Compression2_n3), .B(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Reg[14]), .ZN(
        Inst_SKINNY_Sbox_2_OutAff_out2[0]) );
  XNOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst2_InstXOR_1__Compression2_U1 ( .A(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Reg[12]), .B(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Reg[13]), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst2_InstXOR_1__Compression2_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst2_InstXOR_1__Compression3_U2 ( .A(
        Inst_SKINNY_Sbox_2_Q294_inst2_InstXOR_1__Compression3_n3), .B(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Reg[17]), .ZN(
        Inst_SKINNY_Sbox_2_OutAff_out3[0]) );
  XNOR2_X1 Inst_SKINNY_Sbox_2_Q294_inst2_InstXOR_1__Compression3_U1 ( .A(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Reg[15]), .B(
        Inst_SKINNY_Sbox_2_Q294_inst2_CF_Reg[16]), .ZN(
        Inst_SKINNY_Sbox_2_Q294_inst2_InstXOR_1__Compression3_n3) );
  INV_X1 Inst_SKINNY_Sbox_2_OutputAffine_U4 ( .A(
        Inst_SKINNY_Sbox_2_Q294_2_out1[3]), .ZN(
        Inst_SKINNY_Sbox_2_OutAff_out1[3]) );
  INV_X1 Inst_SKINNY_Sbox_2_OutputAffine_U3 ( .A(
        Inst_SKINNY_Sbox_2_Q294_2_out1[2]), .ZN(
        Inst_SKINNY_Sbox_2_OutAff_out1[2]) );
  INV_X1 Inst_SKINNY_Sbox_2_OutputAffine_U2 ( .A(
        Inst_SKINNY_Sbox_2_Q294_2_out1[1]), .ZN(
        Inst_SKINNY_Sbox_2_OutAff_out1[0]) );
  INV_X1 Inst_SKINNY_Sbox_2_OutputAffine_U1 ( .A(
        Inst_SKINNY_Sbox_2_Q294_2_out1[0]), .ZN(
        Inst_SKINNY_Sbox_2_OutAff_out1[1]) );
  XNOR2_X1 Inst_SKINNY_Sbox_3_U18 ( .A(Inst_SKINNY_Sbox_3_n12), .B(FRESH[39]), 
        .ZN(RF3_SHIFTROWS[3]) );
  XNOR2_X1 Inst_SKINNY_Sbox_3_U17 ( .A(FRESH[35]), .B(
        Inst_SKINNY_Sbox_3_OutAff_out3[3]), .ZN(Inst_SKINNY_Sbox_3_n12) );
  XNOR2_X1 Inst_SKINNY_Sbox_3_U16 ( .A(Inst_SKINNY_Sbox_3_n11), .B(FRESH[38]), 
        .ZN(RF3_SHIFTROWS[2]) );
  XNOR2_X1 Inst_SKINNY_Sbox_3_U15 ( .A(FRESH[34]), .B(
        Inst_SKINNY_Sbox_3_OutAff_out3[2]), .ZN(Inst_SKINNY_Sbox_3_n11) );
  XNOR2_X1 Inst_SKINNY_Sbox_3_U14 ( .A(Inst_SKINNY_Sbox_3_n10), .B(FRESH[37]), 
        .ZN(RF3_SHIFTROWS[1]) );
  XNOR2_X1 Inst_SKINNY_Sbox_3_U13 ( .A(FRESH[33]), .B(
        Inst_SKINNY_Sbox_3_OutAff_out3[1]), .ZN(Inst_SKINNY_Sbox_3_n10) );
  XNOR2_X1 Inst_SKINNY_Sbox_3_U12 ( .A(Inst_SKINNY_Sbox_3_n9), .B(FRESH[36]), 
        .ZN(RF3_SHIFTROWS[0]) );
  XNOR2_X1 Inst_SKINNY_Sbox_3_U11 ( .A(FRESH[32]), .B(
        Inst_SKINNY_Sbox_3_OutAff_out3[0]), .ZN(Inst_SKINNY_Sbox_3_n9) );
  XOR2_X1 Inst_SKINNY_Sbox_3_U10 ( .A(FRESH[39]), .B(
        Inst_SKINNY_Sbox_3_OutAff_out2[3]), .Z(RF2_SHIFTROWS[3]) );
  XOR2_X1 Inst_SKINNY_Sbox_3_U9 ( .A(FRESH[38]), .B(
        Inst_SKINNY_Sbox_3_OutAff_out2[2]), .Z(RF2_SHIFTROWS[2]) );
  XOR2_X1 Inst_SKINNY_Sbox_3_U8 ( .A(FRESH[37]), .B(
        Inst_SKINNY_Sbox_3_OutAff_out2[1]), .Z(RF2_SHIFTROWS[1]) );
  XOR2_X1 Inst_SKINNY_Sbox_3_U7 ( .A(FRESH[36]), .B(
        Inst_SKINNY_Sbox_3_OutAff_out2[0]), .Z(RF2_SHIFTROWS[0]) );
  XOR2_X1 Inst_SKINNY_Sbox_3_U6 ( .A(FRESH[35]), .B(
        Inst_SKINNY_Sbox_3_OutAff_out1[3]), .Z(RF1_SHIFTROWS[3]) );
  XOR2_X1 Inst_SKINNY_Sbox_3_U5 ( .A(FRESH[34]), .B(
        Inst_SKINNY_Sbox_3_OutAff_out1[2]), .Z(RF1_SHIFTROWS[2]) );
  XOR2_X1 Inst_SKINNY_Sbox_3_U4 ( .A(FRESH[33]), .B(
        Inst_SKINNY_Sbox_3_OutAff_out1[1]), .Z(RF1_SHIFTROWS[1]) );
  XOR2_X1 Inst_SKINNY_Sbox_3_U3 ( .A(FRESH[32]), .B(
        Inst_SKINNY_Sbox_3_OutAff_out1[0]), .Z(RF1_SHIFTROWS[0]) );
  DFF_X1 Inst_SKINNY_Sbox_3_M2_out3_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_3_M2_out3[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_M2_out3_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_M2_out3_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_3_M2_out3[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_M2_out3_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_M2_out3_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_3_M2_out3[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_M2_out3_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_M2_out3_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_3_M2_out3[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_M2_out3_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_M2_out2_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_3_M2_out2[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_M2_out2_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_M2_out2_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_3_M2_out2[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_M2_out2_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_M2_out2_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_3_M2_out2[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_M2_out2_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_M2_out2_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_3_M2_out2[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_M2_out2_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_M2_out1_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_3_M2_out1[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_M2_out1_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_M2_out1_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_3_M2_out1[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_M2_out1_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_M2_out1_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_3_M2_out1[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_M2_out1_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_M2_out1_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_3_M2_out1[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_M2_out1_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_InAff_out3_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_3_InAff_out3[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_InAff_out3_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_InAff_out3_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_3_InAff_out3[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_InAff_out3_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_InAff_out3_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_3_InAff_out3[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_InAff_out3_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_InAff_out3_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_3_InAff_out3[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_InAff_out3_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_InAff_out2_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_3_InAff_out2[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_InAff_out2_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_InAff_out2_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_3_InAff_out2[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_InAff_out2_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_InAff_out2_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_3_InAff_out2[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_InAff_out2_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_InAff_out2_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_3_InAff_out2[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_InAff_out2_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_InAff_out1_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_3_InAff_out1[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_InAff_out1_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_InAff_out1_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_3_InAff_out1[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_InAff_out1_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_InAff_out1_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_3_InAff_out1[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_InAff_out1_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_InAff_out1_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_3_InAff_out1[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_InAff_out1_reg[3]), .QN() );
  INV_X1 Inst_SKINNY_Sbox_3_InputAffine_U4 ( .A(SUB_IN1[15]), .ZN(
        Inst_SKINNY_Sbox_3_InAff_out1[1]) );
  INV_X1 Inst_SKINNY_Sbox_3_InputAffine_U3 ( .A(SUB_IN1[14]), .ZN(
        Inst_SKINNY_Sbox_3_InAff_out1[3]) );
  INV_X1 Inst_SKINNY_Sbox_3_InputAffine_U2 ( .A(SUB_IN1[13]), .ZN(
        Inst_SKINNY_Sbox_3_InAff_out1[2]) );
  INV_X1 Inst_SKINNY_Sbox_3_InputAffine_U1 ( .A(SUB_IN1[12]), .ZN(
        Inst_SKINNY_Sbox_3_InAff_out1[0]) );
  DFF_X1 Inst_SKINNY_Sbox_3_Q294_inst1_CF_Reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Out[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_Q294_inst1_CF_Reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Out[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_Q294_inst1_CF_Reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Out[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_Q294_inst1_CF_Reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Out[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_Q294_inst1_CF_Reg_reg_4_ ( .D(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Out[4]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Reg[4]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_Q294_inst1_CF_Reg_reg_5_ ( .D(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Out[5]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Reg[5]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_Q294_inst1_CF_Reg_reg_6_ ( .D(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Out[6]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Reg[6]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_Q294_inst1_CF_Reg_reg_7_ ( .D(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Out[7]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Reg[7]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_Q294_inst1_CF_Reg_reg_8_ ( .D(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Out[8]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Reg[8]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_Q294_inst1_CF_Reg_reg_9_ ( .D(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Out[9]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Reg[9]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_Q294_inst1_CF_Reg_reg_10_ ( .D(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Out[10]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Reg[10]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_Q294_inst1_CF_Reg_reg_11_ ( .D(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Out[11]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Reg[11]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_Q294_inst1_CF_Reg_reg_12_ ( .D(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Out[12]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Reg[12]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_Q294_inst1_CF_Reg_reg_13_ ( .D(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Out[13]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Reg[13]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_Q294_inst1_CF_Reg_reg_14_ ( .D(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Out[14]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Reg[14]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_Q294_inst1_CF_Reg_reg_15_ ( .D(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Out[15]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Reg[15]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_Q294_inst1_CF_Reg_reg_16_ ( .D(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Out[16]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Reg[16]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_Q294_inst1_CF_Reg_reg_17_ ( .D(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Out[17]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Reg[17]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_Q294_inst1_dreg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_3_InAff_out2_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_M2_out1[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_Q294_inst1_dreg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_3_InAff_out3_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_M2_out2[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_Q294_inst1_dreg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_3_InAff_out1_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_M2_out3[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_Q294_inst1_creg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_3_InAff_out2_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_M2_out1[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_Q294_inst1_creg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_3_InAff_out3_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_M2_out2[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_Q294_inst1_creg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_3_InAff_out1_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_M2_out3[1]), .QN() );
  XNOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst1_Inst_0__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_3_Q294_inst1_Inst_0__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_3_InAff_out2_reg[0]), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Out[0]) );
  NAND2_X1 Inst_SKINNY_Sbox_3_Q294_inst1_Inst_0__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_3_InAff_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_3_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst1_Inst_0__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst1_Inst_1__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_3_Q294_inst1_Inst_1__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_3_Q294_inst1_Inst_1__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Out[1]) );
  NAND2_X1 Inst_SKINNY_Sbox_3_Q294_inst1_Inst_1__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_3_InAff_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_3_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst1_Inst_1__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst1_Inst_1__CF_Inst_U1 ( .A(FRESH[0]), .B(
        FRESH[1]), .Z(Inst_SKINNY_Sbox_3_Q294_inst1_Inst_1__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst1_Inst_2__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_3_Q294_inst1_Inst_2__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_3_Q294_inst1_Inst_2__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Out[2]) );
  NAND2_X1 Inst_SKINNY_Sbox_3_Q294_inst1_Inst_2__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_3_InAff_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_3_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst1_Inst_2__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst1_Inst_2__CF_Inst_U1 ( .A(FRESH[1]), .B(
        FRESH[2]), .Z(Inst_SKINNY_Sbox_3_Q294_inst1_Inst_2__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst1_Inst_3__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_3_Q294_inst1_Inst_3__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_3_InAff_out3_reg[0]), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Out[3]) );
  NAND2_X1 Inst_SKINNY_Sbox_3_Q294_inst1_Inst_3__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_3_InAff_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_3_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst1_Inst_3__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst1_Inst_4__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_3_Q294_inst1_Inst_4__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_3_Q294_inst1_Inst_4__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Out[4]) );
  NAND2_X1 Inst_SKINNY_Sbox_3_Q294_inst1_Inst_4__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_3_InAff_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_3_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst1_Inst_4__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst1_Inst_4__CF_Inst_U1 ( .A(FRESH[2]), .B(
        FRESH[3]), .Z(Inst_SKINNY_Sbox_3_Q294_inst1_Inst_4__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst1_Inst_5__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_3_Q294_inst1_Inst_5__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_3_Q294_inst1_Inst_5__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Out[5]) );
  NAND2_X1 Inst_SKINNY_Sbox_3_Q294_inst1_Inst_5__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_3_InAff_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_3_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst1_Inst_5__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst1_Inst_5__CF_Inst_U1 ( .A(FRESH[3]), .B(
        FRESH[4]), .Z(Inst_SKINNY_Sbox_3_Q294_inst1_Inst_5__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst1_Inst_6__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_3_Q294_inst1_Inst_6__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_3_InAff_out1_reg[0]), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Out[6]) );
  NAND2_X1 Inst_SKINNY_Sbox_3_Q294_inst1_Inst_6__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_3_InAff_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_3_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst1_Inst_6__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst1_Inst_7__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_3_Q294_inst1_Inst_7__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_3_Q294_inst1_Inst_7__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Out[7]) );
  NAND2_X1 Inst_SKINNY_Sbox_3_Q294_inst1_Inst_7__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_3_InAff_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_3_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst1_Inst_7__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst1_Inst_7__CF_Inst_U1 ( .A(FRESH[4]), .B(
        FRESH[5]), .Z(Inst_SKINNY_Sbox_3_Q294_inst1_Inst_7__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst1_Inst_8__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_3_Q294_inst1_Inst_8__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_3_Q294_inst1_Inst_8__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Out[8]) );
  NAND2_X1 Inst_SKINNY_Sbox_3_Q294_inst1_Inst_8__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_3_InAff_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_3_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst1_Inst_8__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst1_Inst_8__CF_Inst_U1 ( .A(FRESH[5]), .B(
        FRESH[0]), .Z(Inst_SKINNY_Sbox_3_Q294_inst1_Inst_8__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst1_Inst_9__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_3_Q294_inst1_Inst_9__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_3_InAff_out2_reg[1]), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Out[9]) );
  NAND2_X1 Inst_SKINNY_Sbox_3_Q294_inst1_Inst_9__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_3_InAff_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_3_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst1_Inst_9__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst1_Inst_10__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_3_Q294_inst1_Inst_10__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_3_Q294_inst1_Inst_10__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Out[10]) );
  NAND2_X1 Inst_SKINNY_Sbox_3_Q294_inst1_Inst_10__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_3_InAff_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_3_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst1_Inst_10__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst1_Inst_10__CF_Inst_U1 ( .A(FRESH[6]), 
        .B(FRESH[7]), .Z(Inst_SKINNY_Sbox_3_Q294_inst1_Inst_10__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst1_Inst_11__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_3_Q294_inst1_Inst_11__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_3_Q294_inst1_Inst_11__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Out[11]) );
  NAND2_X1 Inst_SKINNY_Sbox_3_Q294_inst1_Inst_11__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_3_InAff_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_3_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst1_Inst_11__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst1_Inst_11__CF_Inst_U1 ( .A(FRESH[7]), 
        .B(FRESH[8]), .Z(Inst_SKINNY_Sbox_3_Q294_inst1_Inst_11__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst1_Inst_12__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_3_Q294_inst1_Inst_12__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_3_InAff_out3_reg[1]), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Out[12]) );
  NAND2_X1 Inst_SKINNY_Sbox_3_Q294_inst1_Inst_12__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_3_InAff_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_3_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst1_Inst_12__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst1_Inst_13__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_3_Q294_inst1_Inst_13__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_3_Q294_inst1_Inst_13__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Out[13]) );
  NAND2_X1 Inst_SKINNY_Sbox_3_Q294_inst1_Inst_13__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_3_InAff_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_3_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst1_Inst_13__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst1_Inst_13__CF_Inst_U1 ( .A(FRESH[8]), 
        .B(FRESH[9]), .Z(Inst_SKINNY_Sbox_3_Q294_inst1_Inst_13__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst1_Inst_14__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_3_Q294_inst1_Inst_14__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_3_Q294_inst1_Inst_14__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Out[14]) );
  NAND2_X1 Inst_SKINNY_Sbox_3_Q294_inst1_Inst_14__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_3_InAff_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_3_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst1_Inst_14__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst1_Inst_14__CF_Inst_U1 ( .A(FRESH[9]), 
        .B(FRESH[10]), .Z(Inst_SKINNY_Sbox_3_Q294_inst1_Inst_14__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst1_Inst_15__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_3_Q294_inst1_Inst_15__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_3_InAff_out1_reg[1]), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Out[15]) );
  NAND2_X1 Inst_SKINNY_Sbox_3_Q294_inst1_Inst_15__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_3_InAff_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_3_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst1_Inst_15__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst1_Inst_16__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_3_Q294_inst1_Inst_16__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_3_Q294_inst1_Inst_16__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Out[16]) );
  NAND2_X1 Inst_SKINNY_Sbox_3_Q294_inst1_Inst_16__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_3_InAff_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_3_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst1_Inst_16__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst1_Inst_16__CF_Inst_U1 ( .A(FRESH[10]), 
        .B(FRESH[11]), .Z(Inst_SKINNY_Sbox_3_Q294_inst1_Inst_16__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst1_Inst_17__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_3_Q294_inst1_Inst_17__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_3_Q294_inst1_Inst_17__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Out[17]) );
  NAND2_X1 Inst_SKINNY_Sbox_3_Q294_inst1_Inst_17__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_3_InAff_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_3_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst1_Inst_17__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst1_Inst_17__CF_Inst_U1 ( .A(FRESH[11]), 
        .B(FRESH[6]), .Z(Inst_SKINNY_Sbox_3_Q294_inst1_Inst_17__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst1_InstXOR_0__Compression1_U2 ( .A(
        Inst_SKINNY_Sbox_3_Q294_inst1_InstXOR_0__Compression1_n3), .B(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Reg[2]), .ZN(
        Inst_SKINNY_Sbox_3_M2_out1[3]) );
  XNOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst1_InstXOR_0__Compression1_U1 ( .A(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Reg[0]), .B(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Reg[1]), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst1_InstXOR_0__Compression1_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst1_InstXOR_0__Compression2_U2 ( .A(
        Inst_SKINNY_Sbox_3_Q294_inst1_InstXOR_0__Compression2_n3), .B(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Reg[5]), .ZN(
        Inst_SKINNY_Sbox_3_M2_out2[3]) );
  XNOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst1_InstXOR_0__Compression2_U1 ( .A(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Reg[3]), .B(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Reg[4]), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst1_InstXOR_0__Compression2_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst1_InstXOR_0__Compression3_U2 ( .A(
        Inst_SKINNY_Sbox_3_Q294_inst1_InstXOR_0__Compression3_n3), .B(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Reg[8]), .ZN(
        Inst_SKINNY_Sbox_3_M2_out3[3]) );
  XNOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst1_InstXOR_0__Compression3_U1 ( .A(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Reg[6]), .B(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Reg[7]), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst1_InstXOR_0__Compression3_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst1_InstXOR_1__Compression1_U2 ( .A(
        Inst_SKINNY_Sbox_3_Q294_inst1_InstXOR_1__Compression1_n3), .B(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Reg[11]), .ZN(
        Inst_SKINNY_Sbox_3_M2_out1[2]) );
  XNOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst1_InstXOR_1__Compression1_U1 ( .A(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Reg[9]), .B(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Reg[10]), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst1_InstXOR_1__Compression1_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst1_InstXOR_1__Compression2_U2 ( .A(
        Inst_SKINNY_Sbox_3_Q294_inst1_InstXOR_1__Compression2_n3), .B(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Reg[14]), .ZN(
        Inst_SKINNY_Sbox_3_M2_out2[2]) );
  XNOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst1_InstXOR_1__Compression2_U1 ( .A(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Reg[12]), .B(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Reg[13]), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst1_InstXOR_1__Compression2_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst1_InstXOR_1__Compression3_U2 ( .A(
        Inst_SKINNY_Sbox_3_Q294_inst1_InstXOR_1__Compression3_n3), .B(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Reg[17]), .ZN(
        Inst_SKINNY_Sbox_3_M2_out3[2]) );
  XNOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst1_InstXOR_1__Compression3_U1 ( .A(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Reg[15]), .B(
        Inst_SKINNY_Sbox_3_Q294_inst1_CF_Reg[16]), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst1_InstXOR_1__Compression3_n3) );
  DFF_X1 Inst_SKINNY_Sbox_3_Q294_inst2_CF_Reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Out[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_Q294_inst2_CF_Reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Out[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_Q294_inst2_CF_Reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Out[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_Q294_inst2_CF_Reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Out[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_Q294_inst2_CF_Reg_reg_4_ ( .D(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Out[4]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Reg[4]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_Q294_inst2_CF_Reg_reg_5_ ( .D(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Out[5]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Reg[5]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_Q294_inst2_CF_Reg_reg_6_ ( .D(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Out[6]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Reg[6]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_Q294_inst2_CF_Reg_reg_7_ ( .D(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Out[7]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Reg[7]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_Q294_inst2_CF_Reg_reg_8_ ( .D(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Out[8]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Reg[8]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_Q294_inst2_CF_Reg_reg_9_ ( .D(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Out[9]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Reg[9]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_Q294_inst2_CF_Reg_reg_10_ ( .D(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Out[10]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Reg[10]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_Q294_inst2_CF_Reg_reg_11_ ( .D(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Out[11]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Reg[11]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_Q294_inst2_CF_Reg_reg_12_ ( .D(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Out[12]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Reg[12]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_Q294_inst2_CF_Reg_reg_13_ ( .D(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Out[13]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Reg[13]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_Q294_inst2_CF_Reg_reg_14_ ( .D(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Out[14]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Reg[14]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_Q294_inst2_CF_Reg_reg_15_ ( .D(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Out[15]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Reg[15]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_Q294_inst2_CF_Reg_reg_16_ ( .D(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Out[16]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Reg[16]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_Q294_inst2_CF_Reg_reg_17_ ( .D(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Out[17]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Reg[17]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_Q294_inst2_dreg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_3_M2_out2_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_Q294_2_out1[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_Q294_inst2_dreg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_3_M2_out3_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_OutAff_out2[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_Q294_inst2_dreg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_3_M2_out1_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_OutAff_out3[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_Q294_inst2_creg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_3_M2_out2_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_Q294_2_out1[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_Q294_inst2_creg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_3_M2_out3_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_OutAff_out2[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_3_Q294_inst2_creg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_3_M2_out1_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_3_OutAff_out3[2]), .QN() );
  XNOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst2_Inst_0__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_3_Q294_inst2_Inst_0__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_3_M2_out2_reg[0]), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Out[0]) );
  NAND2_X1 Inst_SKINNY_Sbox_3_Q294_inst2_Inst_0__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_3_M2_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_3_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst2_Inst_0__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst2_Inst_1__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_3_Q294_inst2_Inst_1__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_3_Q294_inst2_Inst_1__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Out[1]) );
  NAND2_X1 Inst_SKINNY_Sbox_3_Q294_inst2_Inst_1__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_3_M2_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_3_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst2_Inst_1__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst2_Inst_1__CF_Inst_U1 ( .A(FRESH[12]), 
        .B(FRESH[13]), .Z(Inst_SKINNY_Sbox_3_Q294_inst2_Inst_1__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst2_Inst_2__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_3_Q294_inst2_Inst_2__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_3_Q294_inst2_Inst_2__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Out[2]) );
  NAND2_X1 Inst_SKINNY_Sbox_3_Q294_inst2_Inst_2__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_3_M2_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_3_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst2_Inst_2__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst2_Inst_2__CF_Inst_U1 ( .A(FRESH[13]), 
        .B(FRESH[14]), .Z(Inst_SKINNY_Sbox_3_Q294_inst2_Inst_2__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst2_Inst_3__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_3_Q294_inst2_Inst_3__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_3_M2_out3_reg[0]), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Out[3]) );
  NAND2_X1 Inst_SKINNY_Sbox_3_Q294_inst2_Inst_3__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_3_M2_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_3_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst2_Inst_3__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst2_Inst_4__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_3_Q294_inst2_Inst_4__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_3_Q294_inst2_Inst_4__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Out[4]) );
  NAND2_X1 Inst_SKINNY_Sbox_3_Q294_inst2_Inst_4__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_3_M2_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_3_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst2_Inst_4__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst2_Inst_4__CF_Inst_U1 ( .A(FRESH[14]), 
        .B(FRESH[15]), .Z(Inst_SKINNY_Sbox_3_Q294_inst2_Inst_4__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst2_Inst_5__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_3_Q294_inst2_Inst_5__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_3_Q294_inst2_Inst_5__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Out[5]) );
  NAND2_X1 Inst_SKINNY_Sbox_3_Q294_inst2_Inst_5__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_3_M2_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_3_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst2_Inst_5__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst2_Inst_5__CF_Inst_U1 ( .A(FRESH[15]), 
        .B(FRESH[16]), .Z(Inst_SKINNY_Sbox_3_Q294_inst2_Inst_5__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst2_Inst_6__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_3_Q294_inst2_Inst_6__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_3_M2_out1_reg[0]), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Out[6]) );
  NAND2_X1 Inst_SKINNY_Sbox_3_Q294_inst2_Inst_6__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_3_M2_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_3_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst2_Inst_6__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst2_Inst_7__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_3_Q294_inst2_Inst_7__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_3_Q294_inst2_Inst_7__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Out[7]) );
  NAND2_X1 Inst_SKINNY_Sbox_3_Q294_inst2_Inst_7__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_3_M2_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_3_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst2_Inst_7__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst2_Inst_7__CF_Inst_U1 ( .A(FRESH[16]), 
        .B(FRESH[17]), .Z(Inst_SKINNY_Sbox_3_Q294_inst2_Inst_7__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst2_Inst_8__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_3_Q294_inst2_Inst_8__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_3_Q294_inst2_Inst_8__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Out[8]) );
  NAND2_X1 Inst_SKINNY_Sbox_3_Q294_inst2_Inst_8__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_3_M2_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_3_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst2_Inst_8__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst2_Inst_8__CF_Inst_U1 ( .A(FRESH[17]), 
        .B(FRESH[12]), .Z(Inst_SKINNY_Sbox_3_Q294_inst2_Inst_8__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst2_Inst_9__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_3_Q294_inst2_Inst_9__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_3_M2_out2_reg[1]), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Out[9]) );
  NAND2_X1 Inst_SKINNY_Sbox_3_Q294_inst2_Inst_9__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_3_M2_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_3_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst2_Inst_9__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst2_Inst_10__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_3_Q294_inst2_Inst_10__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_3_Q294_inst2_Inst_10__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Out[10]) );
  NAND2_X1 Inst_SKINNY_Sbox_3_Q294_inst2_Inst_10__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_3_M2_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_3_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst2_Inst_10__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst2_Inst_10__CF_Inst_U1 ( .A(FRESH[18]), 
        .B(FRESH[19]), .Z(Inst_SKINNY_Sbox_3_Q294_inst2_Inst_10__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst2_Inst_11__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_3_Q294_inst2_Inst_11__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_3_Q294_inst2_Inst_11__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Out[11]) );
  NAND2_X1 Inst_SKINNY_Sbox_3_Q294_inst2_Inst_11__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_3_M2_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_3_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst2_Inst_11__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst2_Inst_11__CF_Inst_U1 ( .A(FRESH[19]), 
        .B(FRESH[20]), .Z(Inst_SKINNY_Sbox_3_Q294_inst2_Inst_11__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst2_Inst_12__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_3_Q294_inst2_Inst_12__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_3_M2_out3_reg[1]), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Out[12]) );
  NAND2_X1 Inst_SKINNY_Sbox_3_Q294_inst2_Inst_12__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_3_M2_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_3_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst2_Inst_12__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst2_Inst_13__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_3_Q294_inst2_Inst_13__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_3_Q294_inst2_Inst_13__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Out[13]) );
  NAND2_X1 Inst_SKINNY_Sbox_3_Q294_inst2_Inst_13__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_3_M2_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_3_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst2_Inst_13__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst2_Inst_13__CF_Inst_U1 ( .A(FRESH[20]), 
        .B(FRESH[21]), .Z(Inst_SKINNY_Sbox_3_Q294_inst2_Inst_13__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst2_Inst_14__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_3_Q294_inst2_Inst_14__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_3_Q294_inst2_Inst_14__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Out[14]) );
  NAND2_X1 Inst_SKINNY_Sbox_3_Q294_inst2_Inst_14__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_3_M2_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_3_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst2_Inst_14__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst2_Inst_14__CF_Inst_U1 ( .A(FRESH[21]), 
        .B(FRESH[22]), .Z(Inst_SKINNY_Sbox_3_Q294_inst2_Inst_14__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst2_Inst_15__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_3_Q294_inst2_Inst_15__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_3_M2_out1_reg[1]), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Out[15]) );
  NAND2_X1 Inst_SKINNY_Sbox_3_Q294_inst2_Inst_15__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_3_M2_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_3_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst2_Inst_15__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst2_Inst_16__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_3_Q294_inst2_Inst_16__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_3_Q294_inst2_Inst_16__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Out[16]) );
  NAND2_X1 Inst_SKINNY_Sbox_3_Q294_inst2_Inst_16__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_3_M2_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_3_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst2_Inst_16__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst2_Inst_16__CF_Inst_U1 ( .A(FRESH[22]), 
        .B(FRESH[23]), .Z(Inst_SKINNY_Sbox_3_Q294_inst2_Inst_16__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst2_Inst_17__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_3_Q294_inst2_Inst_17__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_3_Q294_inst2_Inst_17__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Out[17]) );
  NAND2_X1 Inst_SKINNY_Sbox_3_Q294_inst2_Inst_17__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_3_M2_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_3_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst2_Inst_17__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst2_Inst_17__CF_Inst_U1 ( .A(FRESH[23]), 
        .B(FRESH[18]), .Z(Inst_SKINNY_Sbox_3_Q294_inst2_Inst_17__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst2_InstXOR_0__Compression1_U2 ( .A(
        Inst_SKINNY_Sbox_3_Q294_inst2_InstXOR_0__Compression1_n3), .B(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Reg[2]), .ZN(
        Inst_SKINNY_Sbox_3_Q294_2_out1[0]) );
  XNOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst2_InstXOR_0__Compression1_U1 ( .A(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Reg[0]), .B(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Reg[1]), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst2_InstXOR_0__Compression1_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst2_InstXOR_0__Compression2_U2 ( .A(
        Inst_SKINNY_Sbox_3_Q294_inst2_InstXOR_0__Compression2_n3), .B(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Reg[5]), .ZN(
        Inst_SKINNY_Sbox_3_OutAff_out2[1]) );
  XNOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst2_InstXOR_0__Compression2_U1 ( .A(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Reg[3]), .B(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Reg[4]), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst2_InstXOR_0__Compression2_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst2_InstXOR_0__Compression3_U2 ( .A(
        Inst_SKINNY_Sbox_3_Q294_inst2_InstXOR_0__Compression3_n3), .B(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Reg[8]), .ZN(
        Inst_SKINNY_Sbox_3_OutAff_out3[1]) );
  XNOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst2_InstXOR_0__Compression3_U1 ( .A(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Reg[6]), .B(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Reg[7]), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst2_InstXOR_0__Compression3_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst2_InstXOR_1__Compression1_U2 ( .A(
        Inst_SKINNY_Sbox_3_Q294_inst2_InstXOR_1__Compression1_n3), .B(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Reg[11]), .ZN(
        Inst_SKINNY_Sbox_3_Q294_2_out1[1]) );
  XNOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst2_InstXOR_1__Compression1_U1 ( .A(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Reg[9]), .B(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Reg[10]), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst2_InstXOR_1__Compression1_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst2_InstXOR_1__Compression2_U2 ( .A(
        Inst_SKINNY_Sbox_3_Q294_inst2_InstXOR_1__Compression2_n3), .B(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Reg[14]), .ZN(
        Inst_SKINNY_Sbox_3_OutAff_out2[0]) );
  XNOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst2_InstXOR_1__Compression2_U1 ( .A(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Reg[12]), .B(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Reg[13]), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst2_InstXOR_1__Compression2_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst2_InstXOR_1__Compression3_U2 ( .A(
        Inst_SKINNY_Sbox_3_Q294_inst2_InstXOR_1__Compression3_n3), .B(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Reg[17]), .ZN(
        Inst_SKINNY_Sbox_3_OutAff_out3[0]) );
  XNOR2_X1 Inst_SKINNY_Sbox_3_Q294_inst2_InstXOR_1__Compression3_U1 ( .A(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Reg[15]), .B(
        Inst_SKINNY_Sbox_3_Q294_inst2_CF_Reg[16]), .ZN(
        Inst_SKINNY_Sbox_3_Q294_inst2_InstXOR_1__Compression3_n3) );
  INV_X1 Inst_SKINNY_Sbox_3_OutputAffine_U4 ( .A(
        Inst_SKINNY_Sbox_3_Q294_2_out1[3]), .ZN(
        Inst_SKINNY_Sbox_3_OutAff_out1[3]) );
  INV_X1 Inst_SKINNY_Sbox_3_OutputAffine_U3 ( .A(
        Inst_SKINNY_Sbox_3_Q294_2_out1[2]), .ZN(
        Inst_SKINNY_Sbox_3_OutAff_out1[2]) );
  INV_X1 Inst_SKINNY_Sbox_3_OutputAffine_U2 ( .A(
        Inst_SKINNY_Sbox_3_Q294_2_out1[1]), .ZN(
        Inst_SKINNY_Sbox_3_OutAff_out1[0]) );
  INV_X1 Inst_SKINNY_Sbox_3_OutputAffine_U1 ( .A(
        Inst_SKINNY_Sbox_3_Q294_2_out1[0]), .ZN(
        Inst_SKINNY_Sbox_3_OutAff_out1[1]) );
  XNOR2_X1 Inst_SKINNY_Sbox_4_U18 ( .A(Inst_SKINNY_Sbox_4_n12), .B(FRESH[31]), 
        .ZN(RF3_SHIFTROWS[27]) );
  XNOR2_X1 Inst_SKINNY_Sbox_4_U17 ( .A(FRESH[27]), .B(
        Inst_SKINNY_Sbox_4_OutAff_out3[3]), .ZN(Inst_SKINNY_Sbox_4_n12) );
  XNOR2_X1 Inst_SKINNY_Sbox_4_U16 ( .A(Inst_SKINNY_Sbox_4_n11), .B(FRESH[30]), 
        .ZN(RF3_SHIFTROWS[26]) );
  XNOR2_X1 Inst_SKINNY_Sbox_4_U15 ( .A(FRESH[26]), .B(
        Inst_SKINNY_Sbox_4_OutAff_out3[2]), .ZN(Inst_SKINNY_Sbox_4_n11) );
  XNOR2_X1 Inst_SKINNY_Sbox_4_U14 ( .A(Inst_SKINNY_Sbox_4_n10), .B(FRESH[29]), 
        .ZN(RF3_SHIFTROWS[25]) );
  XNOR2_X1 Inst_SKINNY_Sbox_4_U13 ( .A(FRESH[25]), .B(
        Inst_SKINNY_Sbox_4_OutAff_out3[1]), .ZN(Inst_SKINNY_Sbox_4_n10) );
  XNOR2_X1 Inst_SKINNY_Sbox_4_U12 ( .A(Inst_SKINNY_Sbox_4_n9), .B(FRESH[28]), 
        .ZN(RF3_SHIFTROWS[24]) );
  XNOR2_X1 Inst_SKINNY_Sbox_4_U11 ( .A(FRESH[24]), .B(
        Inst_SKINNY_Sbox_4_OutAff_out3[0]), .ZN(Inst_SKINNY_Sbox_4_n9) );
  XOR2_X1 Inst_SKINNY_Sbox_4_U10 ( .A(FRESH[31]), .B(
        Inst_SKINNY_Sbox_4_OutAff_out2[3]), .Z(RF2_SHIFTROWS[27]) );
  XOR2_X1 Inst_SKINNY_Sbox_4_U9 ( .A(FRESH[30]), .B(
        Inst_SKINNY_Sbox_4_OutAff_out2[2]), .Z(RF2_SHIFTROWS[26]) );
  XOR2_X1 Inst_SKINNY_Sbox_4_U8 ( .A(FRESH[29]), .B(
        Inst_SKINNY_Sbox_4_OutAff_out2[1]), .Z(RF2_SHIFTROWS[25]) );
  XOR2_X1 Inst_SKINNY_Sbox_4_U7 ( .A(FRESH[28]), .B(
        Inst_SKINNY_Sbox_4_OutAff_out2[0]), .Z(RF2_SHIFTROWS[24]) );
  XOR2_X1 Inst_SKINNY_Sbox_4_U6 ( .A(FRESH[27]), .B(
        Inst_SKINNY_Sbox_4_OutAff_out1[3]), .Z(RF1_SHIFTROWS[27]) );
  XOR2_X1 Inst_SKINNY_Sbox_4_U5 ( .A(FRESH[26]), .B(
        Inst_SKINNY_Sbox_4_OutAff_out1[2]), .Z(RF1_SHIFTROWS[26]) );
  XOR2_X1 Inst_SKINNY_Sbox_4_U4 ( .A(FRESH[25]), .B(
        Inst_SKINNY_Sbox_4_OutAff_out1[1]), .Z(RF1_SHIFTROWS[25]) );
  XOR2_X1 Inst_SKINNY_Sbox_4_U3 ( .A(FRESH[24]), .B(
        Inst_SKINNY_Sbox_4_OutAff_out1[0]), .Z(RF1_SHIFTROWS[24]) );
  DFF_X1 Inst_SKINNY_Sbox_4_M2_out3_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_4_M2_out3[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_M2_out3_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_M2_out3_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_4_M2_out3[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_M2_out3_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_M2_out3_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_4_M2_out3[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_M2_out3_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_M2_out3_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_4_M2_out3[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_M2_out3_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_M2_out2_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_4_M2_out2[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_M2_out2_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_M2_out2_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_4_M2_out2[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_M2_out2_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_M2_out2_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_4_M2_out2[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_M2_out2_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_M2_out2_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_4_M2_out2[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_M2_out2_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_M2_out1_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_4_M2_out1[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_M2_out1_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_M2_out1_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_4_M2_out1[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_M2_out1_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_M2_out1_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_4_M2_out1[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_M2_out1_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_M2_out1_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_4_M2_out1[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_M2_out1_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_InAff_out3_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_4_InAff_out3[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_InAff_out3_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_InAff_out3_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_4_InAff_out3[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_InAff_out3_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_InAff_out3_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_4_InAff_out3[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_InAff_out3_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_InAff_out3_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_4_InAff_out3[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_InAff_out3_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_InAff_out2_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_4_InAff_out2[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_InAff_out2_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_InAff_out2_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_4_InAff_out2[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_InAff_out2_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_InAff_out2_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_4_InAff_out2[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_InAff_out2_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_InAff_out2_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_4_InAff_out2[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_InAff_out2_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_InAff_out1_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_4_InAff_out1[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_InAff_out1_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_InAff_out1_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_4_InAff_out1[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_InAff_out1_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_InAff_out1_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_4_InAff_out1[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_InAff_out1_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_InAff_out1_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_4_InAff_out1[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_InAff_out1_reg[3]), .QN() );
  INV_X1 Inst_SKINNY_Sbox_4_InputAffine_U4 ( .A(SUB_IN1[19]), .ZN(
        Inst_SKINNY_Sbox_4_InAff_out1[1]) );
  INV_X1 Inst_SKINNY_Sbox_4_InputAffine_U3 ( .A(SUB_IN1[18]), .ZN(
        Inst_SKINNY_Sbox_4_InAff_out1[3]) );
  INV_X1 Inst_SKINNY_Sbox_4_InputAffine_U2 ( .A(SUB_IN1[17]), .ZN(
        Inst_SKINNY_Sbox_4_InAff_out1[2]) );
  INV_X1 Inst_SKINNY_Sbox_4_InputAffine_U1 ( .A(SUB_IN1[16]), .ZN(
        Inst_SKINNY_Sbox_4_InAff_out1[0]) );
  DFF_X1 Inst_SKINNY_Sbox_4_Q294_inst1_CF_Reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Out[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_Q294_inst1_CF_Reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Out[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_Q294_inst1_CF_Reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Out[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_Q294_inst1_CF_Reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Out[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_Q294_inst1_CF_Reg_reg_4_ ( .D(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Out[4]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Reg[4]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_Q294_inst1_CF_Reg_reg_5_ ( .D(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Out[5]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Reg[5]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_Q294_inst1_CF_Reg_reg_6_ ( .D(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Out[6]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Reg[6]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_Q294_inst1_CF_Reg_reg_7_ ( .D(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Out[7]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Reg[7]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_Q294_inst1_CF_Reg_reg_8_ ( .D(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Out[8]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Reg[8]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_Q294_inst1_CF_Reg_reg_9_ ( .D(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Out[9]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Reg[9]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_Q294_inst1_CF_Reg_reg_10_ ( .D(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Out[10]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Reg[10]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_Q294_inst1_CF_Reg_reg_11_ ( .D(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Out[11]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Reg[11]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_Q294_inst1_CF_Reg_reg_12_ ( .D(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Out[12]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Reg[12]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_Q294_inst1_CF_Reg_reg_13_ ( .D(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Out[13]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Reg[13]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_Q294_inst1_CF_Reg_reg_14_ ( .D(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Out[14]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Reg[14]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_Q294_inst1_CF_Reg_reg_15_ ( .D(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Out[15]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Reg[15]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_Q294_inst1_CF_Reg_reg_16_ ( .D(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Out[16]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Reg[16]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_Q294_inst1_CF_Reg_reg_17_ ( .D(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Out[17]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Reg[17]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_Q294_inst1_dreg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_4_InAff_out2_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_M2_out1[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_Q294_inst1_dreg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_4_InAff_out3_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_M2_out2[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_Q294_inst1_dreg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_4_InAff_out1_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_M2_out3[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_Q294_inst1_creg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_4_InAff_out2_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_M2_out1[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_Q294_inst1_creg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_4_InAff_out3_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_M2_out2[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_Q294_inst1_creg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_4_InAff_out1_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_M2_out3[1]), .QN() );
  XNOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst1_Inst_0__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_4_Q294_inst1_Inst_0__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_4_InAff_out2_reg[0]), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Out[0]) );
  NAND2_X1 Inst_SKINNY_Sbox_4_Q294_inst1_Inst_0__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_4_InAff_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_4_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst1_Inst_0__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst1_Inst_1__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_4_Q294_inst1_Inst_1__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_4_Q294_inst1_Inst_1__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Out[1]) );
  NAND2_X1 Inst_SKINNY_Sbox_4_Q294_inst1_Inst_1__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_4_InAff_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_4_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst1_Inst_1__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst1_Inst_1__CF_Inst_U1 ( .A(FRESH[0]), .B(
        FRESH[1]), .Z(Inst_SKINNY_Sbox_4_Q294_inst1_Inst_1__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst1_Inst_2__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_4_Q294_inst1_Inst_2__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_4_Q294_inst1_Inst_2__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Out[2]) );
  NAND2_X1 Inst_SKINNY_Sbox_4_Q294_inst1_Inst_2__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_4_InAff_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_4_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst1_Inst_2__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst1_Inst_2__CF_Inst_U1 ( .A(FRESH[1]), .B(
        FRESH[2]), .Z(Inst_SKINNY_Sbox_4_Q294_inst1_Inst_2__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst1_Inst_3__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_4_Q294_inst1_Inst_3__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_4_InAff_out3_reg[0]), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Out[3]) );
  NAND2_X1 Inst_SKINNY_Sbox_4_Q294_inst1_Inst_3__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_4_InAff_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_4_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst1_Inst_3__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst1_Inst_4__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_4_Q294_inst1_Inst_4__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_4_Q294_inst1_Inst_4__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Out[4]) );
  NAND2_X1 Inst_SKINNY_Sbox_4_Q294_inst1_Inst_4__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_4_InAff_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_4_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst1_Inst_4__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst1_Inst_4__CF_Inst_U1 ( .A(FRESH[2]), .B(
        FRESH[3]), .Z(Inst_SKINNY_Sbox_4_Q294_inst1_Inst_4__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst1_Inst_5__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_4_Q294_inst1_Inst_5__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_4_Q294_inst1_Inst_5__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Out[5]) );
  NAND2_X1 Inst_SKINNY_Sbox_4_Q294_inst1_Inst_5__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_4_InAff_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_4_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst1_Inst_5__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst1_Inst_5__CF_Inst_U1 ( .A(FRESH[3]), .B(
        FRESH[4]), .Z(Inst_SKINNY_Sbox_4_Q294_inst1_Inst_5__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst1_Inst_6__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_4_Q294_inst1_Inst_6__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_4_InAff_out1_reg[0]), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Out[6]) );
  NAND2_X1 Inst_SKINNY_Sbox_4_Q294_inst1_Inst_6__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_4_InAff_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_4_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst1_Inst_6__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst1_Inst_7__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_4_Q294_inst1_Inst_7__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_4_Q294_inst1_Inst_7__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Out[7]) );
  NAND2_X1 Inst_SKINNY_Sbox_4_Q294_inst1_Inst_7__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_4_InAff_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_4_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst1_Inst_7__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst1_Inst_7__CF_Inst_U1 ( .A(FRESH[4]), .B(
        FRESH[5]), .Z(Inst_SKINNY_Sbox_4_Q294_inst1_Inst_7__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst1_Inst_8__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_4_Q294_inst1_Inst_8__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_4_Q294_inst1_Inst_8__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Out[8]) );
  NAND2_X1 Inst_SKINNY_Sbox_4_Q294_inst1_Inst_8__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_4_InAff_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_4_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst1_Inst_8__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst1_Inst_8__CF_Inst_U1 ( .A(FRESH[5]), .B(
        FRESH[0]), .Z(Inst_SKINNY_Sbox_4_Q294_inst1_Inst_8__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst1_Inst_9__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_4_Q294_inst1_Inst_9__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_4_InAff_out2_reg[1]), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Out[9]) );
  NAND2_X1 Inst_SKINNY_Sbox_4_Q294_inst1_Inst_9__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_4_InAff_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_4_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst1_Inst_9__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst1_Inst_10__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_4_Q294_inst1_Inst_10__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_4_Q294_inst1_Inst_10__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Out[10]) );
  NAND2_X1 Inst_SKINNY_Sbox_4_Q294_inst1_Inst_10__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_4_InAff_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_4_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst1_Inst_10__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst1_Inst_10__CF_Inst_U1 ( .A(FRESH[6]), 
        .B(FRESH[7]), .Z(Inst_SKINNY_Sbox_4_Q294_inst1_Inst_10__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst1_Inst_11__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_4_Q294_inst1_Inst_11__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_4_Q294_inst1_Inst_11__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Out[11]) );
  NAND2_X1 Inst_SKINNY_Sbox_4_Q294_inst1_Inst_11__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_4_InAff_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_4_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst1_Inst_11__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst1_Inst_11__CF_Inst_U1 ( .A(FRESH[7]), 
        .B(FRESH[8]), .Z(Inst_SKINNY_Sbox_4_Q294_inst1_Inst_11__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst1_Inst_12__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_4_Q294_inst1_Inst_12__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_4_InAff_out3_reg[1]), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Out[12]) );
  NAND2_X1 Inst_SKINNY_Sbox_4_Q294_inst1_Inst_12__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_4_InAff_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_4_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst1_Inst_12__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst1_Inst_13__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_4_Q294_inst1_Inst_13__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_4_Q294_inst1_Inst_13__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Out[13]) );
  NAND2_X1 Inst_SKINNY_Sbox_4_Q294_inst1_Inst_13__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_4_InAff_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_4_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst1_Inst_13__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst1_Inst_13__CF_Inst_U1 ( .A(FRESH[8]), 
        .B(FRESH[9]), .Z(Inst_SKINNY_Sbox_4_Q294_inst1_Inst_13__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst1_Inst_14__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_4_Q294_inst1_Inst_14__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_4_Q294_inst1_Inst_14__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Out[14]) );
  NAND2_X1 Inst_SKINNY_Sbox_4_Q294_inst1_Inst_14__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_4_InAff_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_4_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst1_Inst_14__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst1_Inst_14__CF_Inst_U1 ( .A(FRESH[9]), 
        .B(FRESH[10]), .Z(Inst_SKINNY_Sbox_4_Q294_inst1_Inst_14__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst1_Inst_15__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_4_Q294_inst1_Inst_15__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_4_InAff_out1_reg[1]), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Out[15]) );
  NAND2_X1 Inst_SKINNY_Sbox_4_Q294_inst1_Inst_15__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_4_InAff_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_4_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst1_Inst_15__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst1_Inst_16__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_4_Q294_inst1_Inst_16__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_4_Q294_inst1_Inst_16__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Out[16]) );
  NAND2_X1 Inst_SKINNY_Sbox_4_Q294_inst1_Inst_16__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_4_InAff_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_4_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst1_Inst_16__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst1_Inst_16__CF_Inst_U1 ( .A(FRESH[10]), 
        .B(FRESH[11]), .Z(Inst_SKINNY_Sbox_4_Q294_inst1_Inst_16__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst1_Inst_17__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_4_Q294_inst1_Inst_17__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_4_Q294_inst1_Inst_17__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Out[17]) );
  NAND2_X1 Inst_SKINNY_Sbox_4_Q294_inst1_Inst_17__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_4_InAff_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_4_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst1_Inst_17__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst1_Inst_17__CF_Inst_U1 ( .A(FRESH[11]), 
        .B(FRESH[6]), .Z(Inst_SKINNY_Sbox_4_Q294_inst1_Inst_17__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst1_InstXOR_0__Compression1_U2 ( .A(
        Inst_SKINNY_Sbox_4_Q294_inst1_InstXOR_0__Compression1_n3), .B(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Reg[2]), .ZN(
        Inst_SKINNY_Sbox_4_M2_out1[3]) );
  XNOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst1_InstXOR_0__Compression1_U1 ( .A(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Reg[0]), .B(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Reg[1]), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst1_InstXOR_0__Compression1_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst1_InstXOR_0__Compression2_U2 ( .A(
        Inst_SKINNY_Sbox_4_Q294_inst1_InstXOR_0__Compression2_n3), .B(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Reg[5]), .ZN(
        Inst_SKINNY_Sbox_4_M2_out2[3]) );
  XNOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst1_InstXOR_0__Compression2_U1 ( .A(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Reg[3]), .B(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Reg[4]), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst1_InstXOR_0__Compression2_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst1_InstXOR_0__Compression3_U2 ( .A(
        Inst_SKINNY_Sbox_4_Q294_inst1_InstXOR_0__Compression3_n3), .B(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Reg[8]), .ZN(
        Inst_SKINNY_Sbox_4_M2_out3[3]) );
  XNOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst1_InstXOR_0__Compression3_U1 ( .A(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Reg[6]), .B(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Reg[7]), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst1_InstXOR_0__Compression3_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst1_InstXOR_1__Compression1_U2 ( .A(
        Inst_SKINNY_Sbox_4_Q294_inst1_InstXOR_1__Compression1_n3), .B(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Reg[11]), .ZN(
        Inst_SKINNY_Sbox_4_M2_out1[2]) );
  XNOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst1_InstXOR_1__Compression1_U1 ( .A(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Reg[9]), .B(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Reg[10]), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst1_InstXOR_1__Compression1_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst1_InstXOR_1__Compression2_U2 ( .A(
        Inst_SKINNY_Sbox_4_Q294_inst1_InstXOR_1__Compression2_n3), .B(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Reg[14]), .ZN(
        Inst_SKINNY_Sbox_4_M2_out2[2]) );
  XNOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst1_InstXOR_1__Compression2_U1 ( .A(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Reg[12]), .B(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Reg[13]), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst1_InstXOR_1__Compression2_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst1_InstXOR_1__Compression3_U2 ( .A(
        Inst_SKINNY_Sbox_4_Q294_inst1_InstXOR_1__Compression3_n3), .B(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Reg[17]), .ZN(
        Inst_SKINNY_Sbox_4_M2_out3[2]) );
  XNOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst1_InstXOR_1__Compression3_U1 ( .A(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Reg[15]), .B(
        Inst_SKINNY_Sbox_4_Q294_inst1_CF_Reg[16]), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst1_InstXOR_1__Compression3_n3) );
  DFF_X1 Inst_SKINNY_Sbox_4_Q294_inst2_CF_Reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Out[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_Q294_inst2_CF_Reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Out[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_Q294_inst2_CF_Reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Out[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_Q294_inst2_CF_Reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Out[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_Q294_inst2_CF_Reg_reg_4_ ( .D(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Out[4]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Reg[4]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_Q294_inst2_CF_Reg_reg_5_ ( .D(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Out[5]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Reg[5]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_Q294_inst2_CF_Reg_reg_6_ ( .D(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Out[6]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Reg[6]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_Q294_inst2_CF_Reg_reg_7_ ( .D(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Out[7]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Reg[7]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_Q294_inst2_CF_Reg_reg_8_ ( .D(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Out[8]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Reg[8]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_Q294_inst2_CF_Reg_reg_9_ ( .D(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Out[9]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Reg[9]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_Q294_inst2_CF_Reg_reg_10_ ( .D(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Out[10]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Reg[10]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_Q294_inst2_CF_Reg_reg_11_ ( .D(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Out[11]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Reg[11]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_Q294_inst2_CF_Reg_reg_12_ ( .D(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Out[12]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Reg[12]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_Q294_inst2_CF_Reg_reg_13_ ( .D(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Out[13]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Reg[13]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_Q294_inst2_CF_Reg_reg_14_ ( .D(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Out[14]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Reg[14]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_Q294_inst2_CF_Reg_reg_15_ ( .D(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Out[15]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Reg[15]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_Q294_inst2_CF_Reg_reg_16_ ( .D(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Out[16]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Reg[16]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_Q294_inst2_CF_Reg_reg_17_ ( .D(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Out[17]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Reg[17]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_Q294_inst2_dreg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_4_M2_out2_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_Q294_2_out1[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_Q294_inst2_dreg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_4_M2_out3_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_OutAff_out2[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_Q294_inst2_dreg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_4_M2_out1_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_OutAff_out3[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_Q294_inst2_creg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_4_M2_out2_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_Q294_2_out1[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_Q294_inst2_creg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_4_M2_out3_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_OutAff_out2[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_4_Q294_inst2_creg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_4_M2_out1_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_4_OutAff_out3[2]), .QN() );
  XNOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst2_Inst_0__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_4_Q294_inst2_Inst_0__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_4_M2_out2_reg[0]), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Out[0]) );
  NAND2_X1 Inst_SKINNY_Sbox_4_Q294_inst2_Inst_0__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_4_M2_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_4_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst2_Inst_0__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst2_Inst_1__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_4_Q294_inst2_Inst_1__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_4_Q294_inst2_Inst_1__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Out[1]) );
  NAND2_X1 Inst_SKINNY_Sbox_4_Q294_inst2_Inst_1__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_4_M2_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_4_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst2_Inst_1__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst2_Inst_1__CF_Inst_U1 ( .A(FRESH[12]), 
        .B(FRESH[13]), .Z(Inst_SKINNY_Sbox_4_Q294_inst2_Inst_1__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst2_Inst_2__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_4_Q294_inst2_Inst_2__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_4_Q294_inst2_Inst_2__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Out[2]) );
  NAND2_X1 Inst_SKINNY_Sbox_4_Q294_inst2_Inst_2__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_4_M2_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_4_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst2_Inst_2__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst2_Inst_2__CF_Inst_U1 ( .A(FRESH[13]), 
        .B(FRESH[14]), .Z(Inst_SKINNY_Sbox_4_Q294_inst2_Inst_2__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst2_Inst_3__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_4_Q294_inst2_Inst_3__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_4_M2_out3_reg[0]), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Out[3]) );
  NAND2_X1 Inst_SKINNY_Sbox_4_Q294_inst2_Inst_3__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_4_M2_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_4_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst2_Inst_3__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst2_Inst_4__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_4_Q294_inst2_Inst_4__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_4_Q294_inst2_Inst_4__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Out[4]) );
  NAND2_X1 Inst_SKINNY_Sbox_4_Q294_inst2_Inst_4__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_4_M2_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_4_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst2_Inst_4__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst2_Inst_4__CF_Inst_U1 ( .A(FRESH[14]), 
        .B(FRESH[15]), .Z(Inst_SKINNY_Sbox_4_Q294_inst2_Inst_4__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst2_Inst_5__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_4_Q294_inst2_Inst_5__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_4_Q294_inst2_Inst_5__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Out[5]) );
  NAND2_X1 Inst_SKINNY_Sbox_4_Q294_inst2_Inst_5__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_4_M2_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_4_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst2_Inst_5__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst2_Inst_5__CF_Inst_U1 ( .A(FRESH[15]), 
        .B(FRESH[16]), .Z(Inst_SKINNY_Sbox_4_Q294_inst2_Inst_5__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst2_Inst_6__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_4_Q294_inst2_Inst_6__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_4_M2_out1_reg[0]), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Out[6]) );
  NAND2_X1 Inst_SKINNY_Sbox_4_Q294_inst2_Inst_6__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_4_M2_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_4_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst2_Inst_6__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst2_Inst_7__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_4_Q294_inst2_Inst_7__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_4_Q294_inst2_Inst_7__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Out[7]) );
  NAND2_X1 Inst_SKINNY_Sbox_4_Q294_inst2_Inst_7__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_4_M2_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_4_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst2_Inst_7__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst2_Inst_7__CF_Inst_U1 ( .A(FRESH[16]), 
        .B(FRESH[17]), .Z(Inst_SKINNY_Sbox_4_Q294_inst2_Inst_7__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst2_Inst_8__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_4_Q294_inst2_Inst_8__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_4_Q294_inst2_Inst_8__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Out[8]) );
  NAND2_X1 Inst_SKINNY_Sbox_4_Q294_inst2_Inst_8__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_4_M2_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_4_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst2_Inst_8__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst2_Inst_8__CF_Inst_U1 ( .A(FRESH[17]), 
        .B(FRESH[12]), .Z(Inst_SKINNY_Sbox_4_Q294_inst2_Inst_8__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst2_Inst_9__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_4_Q294_inst2_Inst_9__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_4_M2_out2_reg[1]), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Out[9]) );
  NAND2_X1 Inst_SKINNY_Sbox_4_Q294_inst2_Inst_9__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_4_M2_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_4_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst2_Inst_9__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst2_Inst_10__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_4_Q294_inst2_Inst_10__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_4_Q294_inst2_Inst_10__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Out[10]) );
  NAND2_X1 Inst_SKINNY_Sbox_4_Q294_inst2_Inst_10__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_4_M2_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_4_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst2_Inst_10__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst2_Inst_10__CF_Inst_U1 ( .A(FRESH[18]), 
        .B(FRESH[19]), .Z(Inst_SKINNY_Sbox_4_Q294_inst2_Inst_10__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst2_Inst_11__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_4_Q294_inst2_Inst_11__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_4_Q294_inst2_Inst_11__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Out[11]) );
  NAND2_X1 Inst_SKINNY_Sbox_4_Q294_inst2_Inst_11__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_4_M2_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_4_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst2_Inst_11__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst2_Inst_11__CF_Inst_U1 ( .A(FRESH[19]), 
        .B(FRESH[20]), .Z(Inst_SKINNY_Sbox_4_Q294_inst2_Inst_11__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst2_Inst_12__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_4_Q294_inst2_Inst_12__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_4_M2_out3_reg[1]), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Out[12]) );
  NAND2_X1 Inst_SKINNY_Sbox_4_Q294_inst2_Inst_12__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_4_M2_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_4_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst2_Inst_12__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst2_Inst_13__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_4_Q294_inst2_Inst_13__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_4_Q294_inst2_Inst_13__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Out[13]) );
  NAND2_X1 Inst_SKINNY_Sbox_4_Q294_inst2_Inst_13__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_4_M2_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_4_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst2_Inst_13__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst2_Inst_13__CF_Inst_U1 ( .A(FRESH[20]), 
        .B(FRESH[21]), .Z(Inst_SKINNY_Sbox_4_Q294_inst2_Inst_13__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst2_Inst_14__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_4_Q294_inst2_Inst_14__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_4_Q294_inst2_Inst_14__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Out[14]) );
  NAND2_X1 Inst_SKINNY_Sbox_4_Q294_inst2_Inst_14__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_4_M2_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_4_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst2_Inst_14__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst2_Inst_14__CF_Inst_U1 ( .A(FRESH[21]), 
        .B(FRESH[22]), .Z(Inst_SKINNY_Sbox_4_Q294_inst2_Inst_14__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst2_Inst_15__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_4_Q294_inst2_Inst_15__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_4_M2_out1_reg[1]), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Out[15]) );
  NAND2_X1 Inst_SKINNY_Sbox_4_Q294_inst2_Inst_15__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_4_M2_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_4_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst2_Inst_15__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst2_Inst_16__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_4_Q294_inst2_Inst_16__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_4_Q294_inst2_Inst_16__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Out[16]) );
  NAND2_X1 Inst_SKINNY_Sbox_4_Q294_inst2_Inst_16__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_4_M2_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_4_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst2_Inst_16__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst2_Inst_16__CF_Inst_U1 ( .A(FRESH[22]), 
        .B(FRESH[23]), .Z(Inst_SKINNY_Sbox_4_Q294_inst2_Inst_16__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst2_Inst_17__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_4_Q294_inst2_Inst_17__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_4_Q294_inst2_Inst_17__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Out[17]) );
  NAND2_X1 Inst_SKINNY_Sbox_4_Q294_inst2_Inst_17__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_4_M2_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_4_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst2_Inst_17__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst2_Inst_17__CF_Inst_U1 ( .A(FRESH[23]), 
        .B(FRESH[18]), .Z(Inst_SKINNY_Sbox_4_Q294_inst2_Inst_17__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst2_InstXOR_0__Compression1_U2 ( .A(
        Inst_SKINNY_Sbox_4_Q294_inst2_InstXOR_0__Compression1_n3), .B(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Reg[2]), .ZN(
        Inst_SKINNY_Sbox_4_Q294_2_out1[0]) );
  XNOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst2_InstXOR_0__Compression1_U1 ( .A(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Reg[0]), .B(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Reg[1]), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst2_InstXOR_0__Compression1_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst2_InstXOR_0__Compression2_U2 ( .A(
        Inst_SKINNY_Sbox_4_Q294_inst2_InstXOR_0__Compression2_n3), .B(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Reg[5]), .ZN(
        Inst_SKINNY_Sbox_4_OutAff_out2[1]) );
  XNOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst2_InstXOR_0__Compression2_U1 ( .A(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Reg[3]), .B(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Reg[4]), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst2_InstXOR_0__Compression2_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst2_InstXOR_0__Compression3_U2 ( .A(
        Inst_SKINNY_Sbox_4_Q294_inst2_InstXOR_0__Compression3_n3), .B(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Reg[8]), .ZN(
        Inst_SKINNY_Sbox_4_OutAff_out3[1]) );
  XNOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst2_InstXOR_0__Compression3_U1 ( .A(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Reg[6]), .B(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Reg[7]), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst2_InstXOR_0__Compression3_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst2_InstXOR_1__Compression1_U2 ( .A(
        Inst_SKINNY_Sbox_4_Q294_inst2_InstXOR_1__Compression1_n3), .B(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Reg[11]), .ZN(
        Inst_SKINNY_Sbox_4_Q294_2_out1[1]) );
  XNOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst2_InstXOR_1__Compression1_U1 ( .A(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Reg[9]), .B(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Reg[10]), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst2_InstXOR_1__Compression1_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst2_InstXOR_1__Compression2_U2 ( .A(
        Inst_SKINNY_Sbox_4_Q294_inst2_InstXOR_1__Compression2_n3), .B(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Reg[14]), .ZN(
        Inst_SKINNY_Sbox_4_OutAff_out2[0]) );
  XNOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst2_InstXOR_1__Compression2_U1 ( .A(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Reg[12]), .B(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Reg[13]), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst2_InstXOR_1__Compression2_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst2_InstXOR_1__Compression3_U2 ( .A(
        Inst_SKINNY_Sbox_4_Q294_inst2_InstXOR_1__Compression3_n3), .B(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Reg[17]), .ZN(
        Inst_SKINNY_Sbox_4_OutAff_out3[0]) );
  XNOR2_X1 Inst_SKINNY_Sbox_4_Q294_inst2_InstXOR_1__Compression3_U1 ( .A(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Reg[15]), .B(
        Inst_SKINNY_Sbox_4_Q294_inst2_CF_Reg[16]), .ZN(
        Inst_SKINNY_Sbox_4_Q294_inst2_InstXOR_1__Compression3_n3) );
  INV_X1 Inst_SKINNY_Sbox_4_OutputAffine_U4 ( .A(
        Inst_SKINNY_Sbox_4_Q294_2_out1[3]), .ZN(
        Inst_SKINNY_Sbox_4_OutAff_out1[3]) );
  INV_X1 Inst_SKINNY_Sbox_4_OutputAffine_U3 ( .A(
        Inst_SKINNY_Sbox_4_Q294_2_out1[2]), .ZN(
        Inst_SKINNY_Sbox_4_OutAff_out1[2]) );
  INV_X1 Inst_SKINNY_Sbox_4_OutputAffine_U2 ( .A(
        Inst_SKINNY_Sbox_4_Q294_2_out1[1]), .ZN(
        Inst_SKINNY_Sbox_4_OutAff_out1[0]) );
  INV_X1 Inst_SKINNY_Sbox_4_OutputAffine_U1 ( .A(
        Inst_SKINNY_Sbox_4_Q294_2_out1[0]), .ZN(
        Inst_SKINNY_Sbox_4_OutAff_out1[1]) );
  XNOR2_X1 Inst_SKINNY_Sbox_5_U18 ( .A(Inst_SKINNY_Sbox_5_n12), .B(FRESH[39]), 
        .ZN(RF3_SHIFTROWS[31]) );
  XNOR2_X1 Inst_SKINNY_Sbox_5_U17 ( .A(FRESH[35]), .B(
        Inst_SKINNY_Sbox_5_OutAff_out3[3]), .ZN(Inst_SKINNY_Sbox_5_n12) );
  XNOR2_X1 Inst_SKINNY_Sbox_5_U16 ( .A(Inst_SKINNY_Sbox_5_n11), .B(FRESH[38]), 
        .ZN(RF3_SHIFTROWS[30]) );
  XNOR2_X1 Inst_SKINNY_Sbox_5_U15 ( .A(FRESH[34]), .B(
        Inst_SKINNY_Sbox_5_OutAff_out3[2]), .ZN(Inst_SKINNY_Sbox_5_n11) );
  XNOR2_X1 Inst_SKINNY_Sbox_5_U14 ( .A(Inst_SKINNY_Sbox_5_n10), .B(FRESH[37]), 
        .ZN(RF3_SHIFTROWS[29]) );
  XNOR2_X1 Inst_SKINNY_Sbox_5_U13 ( .A(FRESH[33]), .B(
        Inst_SKINNY_Sbox_5_OutAff_out3[1]), .ZN(Inst_SKINNY_Sbox_5_n10) );
  XNOR2_X1 Inst_SKINNY_Sbox_5_U12 ( .A(Inst_SKINNY_Sbox_5_n9), .B(FRESH[36]), 
        .ZN(RF3_SHIFTROWS[28]) );
  XNOR2_X1 Inst_SKINNY_Sbox_5_U11 ( .A(FRESH[32]), .B(
        Inst_SKINNY_Sbox_5_OutAff_out3[0]), .ZN(Inst_SKINNY_Sbox_5_n9) );
  XOR2_X1 Inst_SKINNY_Sbox_5_U10 ( .A(FRESH[39]), .B(
        Inst_SKINNY_Sbox_5_OutAff_out2[3]), .Z(RF2_SHIFTROWS[31]) );
  XOR2_X1 Inst_SKINNY_Sbox_5_U9 ( .A(FRESH[38]), .B(
        Inst_SKINNY_Sbox_5_OutAff_out2[2]), .Z(RF2_SHIFTROWS[30]) );
  XOR2_X1 Inst_SKINNY_Sbox_5_U8 ( .A(FRESH[37]), .B(
        Inst_SKINNY_Sbox_5_OutAff_out2[1]), .Z(RF2_SHIFTROWS[29]) );
  XOR2_X1 Inst_SKINNY_Sbox_5_U7 ( .A(FRESH[36]), .B(
        Inst_SKINNY_Sbox_5_OutAff_out2[0]), .Z(RF2_SHIFTROWS[28]) );
  XOR2_X1 Inst_SKINNY_Sbox_5_U6 ( .A(FRESH[35]), .B(
        Inst_SKINNY_Sbox_5_OutAff_out1[3]), .Z(RF1_SHIFTROWS[31]) );
  XOR2_X1 Inst_SKINNY_Sbox_5_U5 ( .A(FRESH[34]), .B(
        Inst_SKINNY_Sbox_5_OutAff_out1[2]), .Z(RF1_SHIFTROWS[30]) );
  XOR2_X1 Inst_SKINNY_Sbox_5_U4 ( .A(FRESH[33]), .B(
        Inst_SKINNY_Sbox_5_OutAff_out1[1]), .Z(RF1_SHIFTROWS[29]) );
  XOR2_X1 Inst_SKINNY_Sbox_5_U3 ( .A(FRESH[32]), .B(
        Inst_SKINNY_Sbox_5_OutAff_out1[0]), .Z(RF1_SHIFTROWS[28]) );
  DFF_X1 Inst_SKINNY_Sbox_5_M2_out3_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_5_M2_out3[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_M2_out3_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_M2_out3_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_5_M2_out3[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_M2_out3_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_M2_out3_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_5_M2_out3[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_M2_out3_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_M2_out3_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_5_M2_out3[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_M2_out3_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_M2_out2_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_5_M2_out2[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_M2_out2_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_M2_out2_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_5_M2_out2[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_M2_out2_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_M2_out2_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_5_M2_out2[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_M2_out2_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_M2_out2_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_5_M2_out2[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_M2_out2_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_M2_out1_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_5_M2_out1[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_M2_out1_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_M2_out1_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_5_M2_out1[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_M2_out1_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_M2_out1_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_5_M2_out1[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_M2_out1_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_M2_out1_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_5_M2_out1[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_M2_out1_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_InAff_out3_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_5_InAff_out3[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_InAff_out3_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_InAff_out3_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_5_InAff_out3[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_InAff_out3_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_InAff_out3_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_5_InAff_out3[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_InAff_out3_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_InAff_out3_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_5_InAff_out3[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_InAff_out3_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_InAff_out2_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_5_InAff_out2[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_InAff_out2_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_InAff_out2_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_5_InAff_out2[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_InAff_out2_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_InAff_out2_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_5_InAff_out2[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_InAff_out2_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_InAff_out2_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_5_InAff_out2[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_InAff_out2_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_InAff_out1_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_5_InAff_out1[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_InAff_out1_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_InAff_out1_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_5_InAff_out1[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_InAff_out1_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_InAff_out1_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_5_InAff_out1[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_InAff_out1_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_InAff_out1_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_5_InAff_out1[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_InAff_out1_reg[3]), .QN() );
  INV_X1 Inst_SKINNY_Sbox_5_InputAffine_U4 ( .A(SUB_IN1[23]), .ZN(
        Inst_SKINNY_Sbox_5_InAff_out1[1]) );
  INV_X1 Inst_SKINNY_Sbox_5_InputAffine_U3 ( .A(SUB_IN1[22]), .ZN(
        Inst_SKINNY_Sbox_5_InAff_out1[3]) );
  INV_X1 Inst_SKINNY_Sbox_5_InputAffine_U2 ( .A(SUB_IN1[21]), .ZN(
        Inst_SKINNY_Sbox_5_InAff_out1[2]) );
  INV_X1 Inst_SKINNY_Sbox_5_InputAffine_U1 ( .A(SUB_IN1[20]), .ZN(
        Inst_SKINNY_Sbox_5_InAff_out1[0]) );
  DFF_X1 Inst_SKINNY_Sbox_5_Q294_inst1_CF_Reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Out[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_Q294_inst1_CF_Reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Out[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_Q294_inst1_CF_Reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Out[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_Q294_inst1_CF_Reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Out[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_Q294_inst1_CF_Reg_reg_4_ ( .D(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Out[4]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Reg[4]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_Q294_inst1_CF_Reg_reg_5_ ( .D(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Out[5]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Reg[5]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_Q294_inst1_CF_Reg_reg_6_ ( .D(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Out[6]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Reg[6]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_Q294_inst1_CF_Reg_reg_7_ ( .D(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Out[7]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Reg[7]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_Q294_inst1_CF_Reg_reg_8_ ( .D(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Out[8]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Reg[8]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_Q294_inst1_CF_Reg_reg_9_ ( .D(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Out[9]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Reg[9]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_Q294_inst1_CF_Reg_reg_10_ ( .D(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Out[10]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Reg[10]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_Q294_inst1_CF_Reg_reg_11_ ( .D(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Out[11]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Reg[11]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_Q294_inst1_CF_Reg_reg_12_ ( .D(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Out[12]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Reg[12]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_Q294_inst1_CF_Reg_reg_13_ ( .D(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Out[13]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Reg[13]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_Q294_inst1_CF_Reg_reg_14_ ( .D(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Out[14]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Reg[14]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_Q294_inst1_CF_Reg_reg_15_ ( .D(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Out[15]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Reg[15]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_Q294_inst1_CF_Reg_reg_16_ ( .D(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Out[16]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Reg[16]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_Q294_inst1_CF_Reg_reg_17_ ( .D(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Out[17]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Reg[17]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_Q294_inst1_dreg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_5_InAff_out2_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_M2_out1[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_Q294_inst1_dreg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_5_InAff_out3_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_M2_out2[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_Q294_inst1_dreg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_5_InAff_out1_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_M2_out3[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_Q294_inst1_creg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_5_InAff_out2_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_M2_out1[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_Q294_inst1_creg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_5_InAff_out3_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_M2_out2[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_Q294_inst1_creg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_5_InAff_out1_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_M2_out3[1]), .QN() );
  XNOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst1_Inst_0__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_5_Q294_inst1_Inst_0__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_5_InAff_out2_reg[0]), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Out[0]) );
  NAND2_X1 Inst_SKINNY_Sbox_5_Q294_inst1_Inst_0__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_5_InAff_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_5_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst1_Inst_0__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst1_Inst_1__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_5_Q294_inst1_Inst_1__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_5_Q294_inst1_Inst_1__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Out[1]) );
  NAND2_X1 Inst_SKINNY_Sbox_5_Q294_inst1_Inst_1__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_5_InAff_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_5_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst1_Inst_1__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst1_Inst_1__CF_Inst_U1 ( .A(FRESH[0]), .B(
        FRESH[1]), .Z(Inst_SKINNY_Sbox_5_Q294_inst1_Inst_1__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst1_Inst_2__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_5_Q294_inst1_Inst_2__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_5_Q294_inst1_Inst_2__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Out[2]) );
  NAND2_X1 Inst_SKINNY_Sbox_5_Q294_inst1_Inst_2__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_5_InAff_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_5_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst1_Inst_2__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst1_Inst_2__CF_Inst_U1 ( .A(FRESH[1]), .B(
        FRESH[2]), .Z(Inst_SKINNY_Sbox_5_Q294_inst1_Inst_2__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst1_Inst_3__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_5_Q294_inst1_Inst_3__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_5_InAff_out3_reg[0]), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Out[3]) );
  NAND2_X1 Inst_SKINNY_Sbox_5_Q294_inst1_Inst_3__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_5_InAff_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_5_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst1_Inst_3__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst1_Inst_4__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_5_Q294_inst1_Inst_4__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_5_Q294_inst1_Inst_4__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Out[4]) );
  NAND2_X1 Inst_SKINNY_Sbox_5_Q294_inst1_Inst_4__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_5_InAff_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_5_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst1_Inst_4__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst1_Inst_4__CF_Inst_U1 ( .A(FRESH[2]), .B(
        FRESH[3]), .Z(Inst_SKINNY_Sbox_5_Q294_inst1_Inst_4__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst1_Inst_5__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_5_Q294_inst1_Inst_5__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_5_Q294_inst1_Inst_5__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Out[5]) );
  NAND2_X1 Inst_SKINNY_Sbox_5_Q294_inst1_Inst_5__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_5_InAff_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_5_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst1_Inst_5__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst1_Inst_5__CF_Inst_U1 ( .A(FRESH[3]), .B(
        FRESH[4]), .Z(Inst_SKINNY_Sbox_5_Q294_inst1_Inst_5__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst1_Inst_6__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_5_Q294_inst1_Inst_6__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_5_InAff_out1_reg[0]), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Out[6]) );
  NAND2_X1 Inst_SKINNY_Sbox_5_Q294_inst1_Inst_6__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_5_InAff_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_5_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst1_Inst_6__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst1_Inst_7__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_5_Q294_inst1_Inst_7__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_5_Q294_inst1_Inst_7__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Out[7]) );
  NAND2_X1 Inst_SKINNY_Sbox_5_Q294_inst1_Inst_7__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_5_InAff_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_5_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst1_Inst_7__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst1_Inst_7__CF_Inst_U1 ( .A(FRESH[4]), .B(
        FRESH[5]), .Z(Inst_SKINNY_Sbox_5_Q294_inst1_Inst_7__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst1_Inst_8__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_5_Q294_inst1_Inst_8__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_5_Q294_inst1_Inst_8__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Out[8]) );
  NAND2_X1 Inst_SKINNY_Sbox_5_Q294_inst1_Inst_8__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_5_InAff_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_5_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst1_Inst_8__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst1_Inst_8__CF_Inst_U1 ( .A(FRESH[5]), .B(
        FRESH[0]), .Z(Inst_SKINNY_Sbox_5_Q294_inst1_Inst_8__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst1_Inst_9__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_5_Q294_inst1_Inst_9__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_5_InAff_out2_reg[1]), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Out[9]) );
  NAND2_X1 Inst_SKINNY_Sbox_5_Q294_inst1_Inst_9__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_5_InAff_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_5_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst1_Inst_9__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst1_Inst_10__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_5_Q294_inst1_Inst_10__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_5_Q294_inst1_Inst_10__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Out[10]) );
  NAND2_X1 Inst_SKINNY_Sbox_5_Q294_inst1_Inst_10__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_5_InAff_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_5_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst1_Inst_10__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst1_Inst_10__CF_Inst_U1 ( .A(FRESH[6]), 
        .B(FRESH[7]), .Z(Inst_SKINNY_Sbox_5_Q294_inst1_Inst_10__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst1_Inst_11__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_5_Q294_inst1_Inst_11__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_5_Q294_inst1_Inst_11__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Out[11]) );
  NAND2_X1 Inst_SKINNY_Sbox_5_Q294_inst1_Inst_11__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_5_InAff_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_5_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst1_Inst_11__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst1_Inst_11__CF_Inst_U1 ( .A(FRESH[7]), 
        .B(FRESH[8]), .Z(Inst_SKINNY_Sbox_5_Q294_inst1_Inst_11__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst1_Inst_12__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_5_Q294_inst1_Inst_12__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_5_InAff_out3_reg[1]), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Out[12]) );
  NAND2_X1 Inst_SKINNY_Sbox_5_Q294_inst1_Inst_12__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_5_InAff_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_5_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst1_Inst_12__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst1_Inst_13__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_5_Q294_inst1_Inst_13__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_5_Q294_inst1_Inst_13__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Out[13]) );
  NAND2_X1 Inst_SKINNY_Sbox_5_Q294_inst1_Inst_13__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_5_InAff_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_5_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst1_Inst_13__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst1_Inst_13__CF_Inst_U1 ( .A(FRESH[8]), 
        .B(FRESH[9]), .Z(Inst_SKINNY_Sbox_5_Q294_inst1_Inst_13__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst1_Inst_14__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_5_Q294_inst1_Inst_14__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_5_Q294_inst1_Inst_14__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Out[14]) );
  NAND2_X1 Inst_SKINNY_Sbox_5_Q294_inst1_Inst_14__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_5_InAff_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_5_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst1_Inst_14__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst1_Inst_14__CF_Inst_U1 ( .A(FRESH[9]), 
        .B(FRESH[10]), .Z(Inst_SKINNY_Sbox_5_Q294_inst1_Inst_14__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst1_Inst_15__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_5_Q294_inst1_Inst_15__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_5_InAff_out1_reg[1]), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Out[15]) );
  NAND2_X1 Inst_SKINNY_Sbox_5_Q294_inst1_Inst_15__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_5_InAff_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_5_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst1_Inst_15__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst1_Inst_16__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_5_Q294_inst1_Inst_16__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_5_Q294_inst1_Inst_16__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Out[16]) );
  NAND2_X1 Inst_SKINNY_Sbox_5_Q294_inst1_Inst_16__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_5_InAff_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_5_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst1_Inst_16__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst1_Inst_16__CF_Inst_U1 ( .A(FRESH[10]), 
        .B(FRESH[11]), .Z(Inst_SKINNY_Sbox_5_Q294_inst1_Inst_16__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst1_Inst_17__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_5_Q294_inst1_Inst_17__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_5_Q294_inst1_Inst_17__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Out[17]) );
  NAND2_X1 Inst_SKINNY_Sbox_5_Q294_inst1_Inst_17__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_5_InAff_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_5_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst1_Inst_17__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst1_Inst_17__CF_Inst_U1 ( .A(FRESH[11]), 
        .B(FRESH[6]), .Z(Inst_SKINNY_Sbox_5_Q294_inst1_Inst_17__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst1_InstXOR_0__Compression1_U2 ( .A(
        Inst_SKINNY_Sbox_5_Q294_inst1_InstXOR_0__Compression1_n3), .B(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Reg[2]), .ZN(
        Inst_SKINNY_Sbox_5_M2_out1[3]) );
  XNOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst1_InstXOR_0__Compression1_U1 ( .A(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Reg[0]), .B(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Reg[1]), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst1_InstXOR_0__Compression1_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst1_InstXOR_0__Compression2_U2 ( .A(
        Inst_SKINNY_Sbox_5_Q294_inst1_InstXOR_0__Compression2_n3), .B(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Reg[5]), .ZN(
        Inst_SKINNY_Sbox_5_M2_out2[3]) );
  XNOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst1_InstXOR_0__Compression2_U1 ( .A(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Reg[3]), .B(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Reg[4]), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst1_InstXOR_0__Compression2_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst1_InstXOR_0__Compression3_U2 ( .A(
        Inst_SKINNY_Sbox_5_Q294_inst1_InstXOR_0__Compression3_n3), .B(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Reg[8]), .ZN(
        Inst_SKINNY_Sbox_5_M2_out3[3]) );
  XNOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst1_InstXOR_0__Compression3_U1 ( .A(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Reg[6]), .B(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Reg[7]), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst1_InstXOR_0__Compression3_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst1_InstXOR_1__Compression1_U2 ( .A(
        Inst_SKINNY_Sbox_5_Q294_inst1_InstXOR_1__Compression1_n3), .B(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Reg[11]), .ZN(
        Inst_SKINNY_Sbox_5_M2_out1[2]) );
  XNOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst1_InstXOR_1__Compression1_U1 ( .A(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Reg[9]), .B(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Reg[10]), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst1_InstXOR_1__Compression1_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst1_InstXOR_1__Compression2_U2 ( .A(
        Inst_SKINNY_Sbox_5_Q294_inst1_InstXOR_1__Compression2_n3), .B(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Reg[14]), .ZN(
        Inst_SKINNY_Sbox_5_M2_out2[2]) );
  XNOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst1_InstXOR_1__Compression2_U1 ( .A(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Reg[12]), .B(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Reg[13]), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst1_InstXOR_1__Compression2_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst1_InstXOR_1__Compression3_U2 ( .A(
        Inst_SKINNY_Sbox_5_Q294_inst1_InstXOR_1__Compression3_n3), .B(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Reg[17]), .ZN(
        Inst_SKINNY_Sbox_5_M2_out3[2]) );
  XNOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst1_InstXOR_1__Compression3_U1 ( .A(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Reg[15]), .B(
        Inst_SKINNY_Sbox_5_Q294_inst1_CF_Reg[16]), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst1_InstXOR_1__Compression3_n3) );
  DFF_X1 Inst_SKINNY_Sbox_5_Q294_inst2_CF_Reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Out[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_Q294_inst2_CF_Reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Out[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_Q294_inst2_CF_Reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Out[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_Q294_inst2_CF_Reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Out[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_Q294_inst2_CF_Reg_reg_4_ ( .D(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Out[4]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Reg[4]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_Q294_inst2_CF_Reg_reg_5_ ( .D(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Out[5]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Reg[5]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_Q294_inst2_CF_Reg_reg_6_ ( .D(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Out[6]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Reg[6]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_Q294_inst2_CF_Reg_reg_7_ ( .D(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Out[7]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Reg[7]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_Q294_inst2_CF_Reg_reg_8_ ( .D(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Out[8]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Reg[8]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_Q294_inst2_CF_Reg_reg_9_ ( .D(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Out[9]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Reg[9]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_Q294_inst2_CF_Reg_reg_10_ ( .D(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Out[10]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Reg[10]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_Q294_inst2_CF_Reg_reg_11_ ( .D(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Out[11]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Reg[11]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_Q294_inst2_CF_Reg_reg_12_ ( .D(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Out[12]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Reg[12]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_Q294_inst2_CF_Reg_reg_13_ ( .D(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Out[13]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Reg[13]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_Q294_inst2_CF_Reg_reg_14_ ( .D(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Out[14]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Reg[14]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_Q294_inst2_CF_Reg_reg_15_ ( .D(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Out[15]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Reg[15]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_Q294_inst2_CF_Reg_reg_16_ ( .D(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Out[16]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Reg[16]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_Q294_inst2_CF_Reg_reg_17_ ( .D(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Out[17]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Reg[17]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_Q294_inst2_dreg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_5_M2_out2_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_Q294_2_out1[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_Q294_inst2_dreg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_5_M2_out3_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_OutAff_out2[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_Q294_inst2_dreg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_5_M2_out1_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_OutAff_out3[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_Q294_inst2_creg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_5_M2_out2_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_Q294_2_out1[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_Q294_inst2_creg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_5_M2_out3_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_OutAff_out2[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_5_Q294_inst2_creg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_5_M2_out1_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_5_OutAff_out3[2]), .QN() );
  XNOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst2_Inst_0__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_5_Q294_inst2_Inst_0__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_5_M2_out2_reg[0]), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Out[0]) );
  NAND2_X1 Inst_SKINNY_Sbox_5_Q294_inst2_Inst_0__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_5_M2_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_5_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst2_Inst_0__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst2_Inst_1__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_5_Q294_inst2_Inst_1__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_5_Q294_inst2_Inst_1__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Out[1]) );
  NAND2_X1 Inst_SKINNY_Sbox_5_Q294_inst2_Inst_1__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_5_M2_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_5_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst2_Inst_1__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst2_Inst_1__CF_Inst_U1 ( .A(FRESH[12]), 
        .B(FRESH[13]), .Z(Inst_SKINNY_Sbox_5_Q294_inst2_Inst_1__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst2_Inst_2__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_5_Q294_inst2_Inst_2__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_5_Q294_inst2_Inst_2__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Out[2]) );
  NAND2_X1 Inst_SKINNY_Sbox_5_Q294_inst2_Inst_2__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_5_M2_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_5_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst2_Inst_2__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst2_Inst_2__CF_Inst_U1 ( .A(FRESH[13]), 
        .B(FRESH[14]), .Z(Inst_SKINNY_Sbox_5_Q294_inst2_Inst_2__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst2_Inst_3__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_5_Q294_inst2_Inst_3__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_5_M2_out3_reg[0]), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Out[3]) );
  NAND2_X1 Inst_SKINNY_Sbox_5_Q294_inst2_Inst_3__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_5_M2_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_5_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst2_Inst_3__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst2_Inst_4__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_5_Q294_inst2_Inst_4__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_5_Q294_inst2_Inst_4__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Out[4]) );
  NAND2_X1 Inst_SKINNY_Sbox_5_Q294_inst2_Inst_4__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_5_M2_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_5_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst2_Inst_4__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst2_Inst_4__CF_Inst_U1 ( .A(FRESH[14]), 
        .B(FRESH[15]), .Z(Inst_SKINNY_Sbox_5_Q294_inst2_Inst_4__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst2_Inst_5__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_5_Q294_inst2_Inst_5__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_5_Q294_inst2_Inst_5__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Out[5]) );
  NAND2_X1 Inst_SKINNY_Sbox_5_Q294_inst2_Inst_5__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_5_M2_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_5_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst2_Inst_5__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst2_Inst_5__CF_Inst_U1 ( .A(FRESH[15]), 
        .B(FRESH[16]), .Z(Inst_SKINNY_Sbox_5_Q294_inst2_Inst_5__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst2_Inst_6__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_5_Q294_inst2_Inst_6__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_5_M2_out1_reg[0]), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Out[6]) );
  NAND2_X1 Inst_SKINNY_Sbox_5_Q294_inst2_Inst_6__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_5_M2_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_5_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst2_Inst_6__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst2_Inst_7__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_5_Q294_inst2_Inst_7__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_5_Q294_inst2_Inst_7__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Out[7]) );
  NAND2_X1 Inst_SKINNY_Sbox_5_Q294_inst2_Inst_7__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_5_M2_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_5_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst2_Inst_7__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst2_Inst_7__CF_Inst_U1 ( .A(FRESH[16]), 
        .B(FRESH[17]), .Z(Inst_SKINNY_Sbox_5_Q294_inst2_Inst_7__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst2_Inst_8__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_5_Q294_inst2_Inst_8__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_5_Q294_inst2_Inst_8__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Out[8]) );
  NAND2_X1 Inst_SKINNY_Sbox_5_Q294_inst2_Inst_8__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_5_M2_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_5_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst2_Inst_8__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst2_Inst_8__CF_Inst_U1 ( .A(FRESH[17]), 
        .B(FRESH[12]), .Z(Inst_SKINNY_Sbox_5_Q294_inst2_Inst_8__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst2_Inst_9__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_5_Q294_inst2_Inst_9__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_5_M2_out2_reg[1]), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Out[9]) );
  NAND2_X1 Inst_SKINNY_Sbox_5_Q294_inst2_Inst_9__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_5_M2_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_5_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst2_Inst_9__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst2_Inst_10__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_5_Q294_inst2_Inst_10__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_5_Q294_inst2_Inst_10__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Out[10]) );
  NAND2_X1 Inst_SKINNY_Sbox_5_Q294_inst2_Inst_10__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_5_M2_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_5_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst2_Inst_10__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst2_Inst_10__CF_Inst_U1 ( .A(FRESH[18]), 
        .B(FRESH[19]), .Z(Inst_SKINNY_Sbox_5_Q294_inst2_Inst_10__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst2_Inst_11__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_5_Q294_inst2_Inst_11__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_5_Q294_inst2_Inst_11__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Out[11]) );
  NAND2_X1 Inst_SKINNY_Sbox_5_Q294_inst2_Inst_11__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_5_M2_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_5_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst2_Inst_11__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst2_Inst_11__CF_Inst_U1 ( .A(FRESH[19]), 
        .B(FRESH[20]), .Z(Inst_SKINNY_Sbox_5_Q294_inst2_Inst_11__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst2_Inst_12__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_5_Q294_inst2_Inst_12__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_5_M2_out3_reg[1]), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Out[12]) );
  NAND2_X1 Inst_SKINNY_Sbox_5_Q294_inst2_Inst_12__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_5_M2_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_5_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst2_Inst_12__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst2_Inst_13__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_5_Q294_inst2_Inst_13__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_5_Q294_inst2_Inst_13__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Out[13]) );
  NAND2_X1 Inst_SKINNY_Sbox_5_Q294_inst2_Inst_13__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_5_M2_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_5_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst2_Inst_13__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst2_Inst_13__CF_Inst_U1 ( .A(FRESH[20]), 
        .B(FRESH[21]), .Z(Inst_SKINNY_Sbox_5_Q294_inst2_Inst_13__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst2_Inst_14__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_5_Q294_inst2_Inst_14__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_5_Q294_inst2_Inst_14__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Out[14]) );
  NAND2_X1 Inst_SKINNY_Sbox_5_Q294_inst2_Inst_14__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_5_M2_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_5_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst2_Inst_14__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst2_Inst_14__CF_Inst_U1 ( .A(FRESH[21]), 
        .B(FRESH[22]), .Z(Inst_SKINNY_Sbox_5_Q294_inst2_Inst_14__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst2_Inst_15__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_5_Q294_inst2_Inst_15__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_5_M2_out1_reg[1]), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Out[15]) );
  NAND2_X1 Inst_SKINNY_Sbox_5_Q294_inst2_Inst_15__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_5_M2_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_5_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst2_Inst_15__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst2_Inst_16__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_5_Q294_inst2_Inst_16__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_5_Q294_inst2_Inst_16__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Out[16]) );
  NAND2_X1 Inst_SKINNY_Sbox_5_Q294_inst2_Inst_16__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_5_M2_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_5_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst2_Inst_16__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst2_Inst_16__CF_Inst_U1 ( .A(FRESH[22]), 
        .B(FRESH[23]), .Z(Inst_SKINNY_Sbox_5_Q294_inst2_Inst_16__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst2_Inst_17__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_5_Q294_inst2_Inst_17__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_5_Q294_inst2_Inst_17__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Out[17]) );
  NAND2_X1 Inst_SKINNY_Sbox_5_Q294_inst2_Inst_17__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_5_M2_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_5_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst2_Inst_17__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst2_Inst_17__CF_Inst_U1 ( .A(FRESH[23]), 
        .B(FRESH[18]), .Z(Inst_SKINNY_Sbox_5_Q294_inst2_Inst_17__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst2_InstXOR_0__Compression1_U2 ( .A(
        Inst_SKINNY_Sbox_5_Q294_inst2_InstXOR_0__Compression1_n3), .B(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Reg[2]), .ZN(
        Inst_SKINNY_Sbox_5_Q294_2_out1[0]) );
  XNOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst2_InstXOR_0__Compression1_U1 ( .A(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Reg[0]), .B(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Reg[1]), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst2_InstXOR_0__Compression1_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst2_InstXOR_0__Compression2_U2 ( .A(
        Inst_SKINNY_Sbox_5_Q294_inst2_InstXOR_0__Compression2_n3), .B(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Reg[5]), .ZN(
        Inst_SKINNY_Sbox_5_OutAff_out2[1]) );
  XNOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst2_InstXOR_0__Compression2_U1 ( .A(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Reg[3]), .B(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Reg[4]), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst2_InstXOR_0__Compression2_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst2_InstXOR_0__Compression3_U2 ( .A(
        Inst_SKINNY_Sbox_5_Q294_inst2_InstXOR_0__Compression3_n3), .B(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Reg[8]), .ZN(
        Inst_SKINNY_Sbox_5_OutAff_out3[1]) );
  XNOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst2_InstXOR_0__Compression3_U1 ( .A(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Reg[6]), .B(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Reg[7]), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst2_InstXOR_0__Compression3_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst2_InstXOR_1__Compression1_U2 ( .A(
        Inst_SKINNY_Sbox_5_Q294_inst2_InstXOR_1__Compression1_n3), .B(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Reg[11]), .ZN(
        Inst_SKINNY_Sbox_5_Q294_2_out1[1]) );
  XNOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst2_InstXOR_1__Compression1_U1 ( .A(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Reg[9]), .B(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Reg[10]), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst2_InstXOR_1__Compression1_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst2_InstXOR_1__Compression2_U2 ( .A(
        Inst_SKINNY_Sbox_5_Q294_inst2_InstXOR_1__Compression2_n3), .B(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Reg[14]), .ZN(
        Inst_SKINNY_Sbox_5_OutAff_out2[0]) );
  XNOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst2_InstXOR_1__Compression2_U1 ( .A(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Reg[12]), .B(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Reg[13]), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst2_InstXOR_1__Compression2_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst2_InstXOR_1__Compression3_U2 ( .A(
        Inst_SKINNY_Sbox_5_Q294_inst2_InstXOR_1__Compression3_n3), .B(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Reg[17]), .ZN(
        Inst_SKINNY_Sbox_5_OutAff_out3[0]) );
  XNOR2_X1 Inst_SKINNY_Sbox_5_Q294_inst2_InstXOR_1__Compression3_U1 ( .A(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Reg[15]), .B(
        Inst_SKINNY_Sbox_5_Q294_inst2_CF_Reg[16]), .ZN(
        Inst_SKINNY_Sbox_5_Q294_inst2_InstXOR_1__Compression3_n3) );
  INV_X1 Inst_SKINNY_Sbox_5_OutputAffine_U4 ( .A(
        Inst_SKINNY_Sbox_5_Q294_2_out1[3]), .ZN(
        Inst_SKINNY_Sbox_5_OutAff_out1[3]) );
  INV_X1 Inst_SKINNY_Sbox_5_OutputAffine_U3 ( .A(
        Inst_SKINNY_Sbox_5_Q294_2_out1[2]), .ZN(
        Inst_SKINNY_Sbox_5_OutAff_out1[2]) );
  INV_X1 Inst_SKINNY_Sbox_5_OutputAffine_U2 ( .A(
        Inst_SKINNY_Sbox_5_Q294_2_out1[1]), .ZN(
        Inst_SKINNY_Sbox_5_OutAff_out1[0]) );
  INV_X1 Inst_SKINNY_Sbox_5_OutputAffine_U1 ( .A(
        Inst_SKINNY_Sbox_5_Q294_2_out1[0]), .ZN(
        Inst_SKINNY_Sbox_5_OutAff_out1[1]) );
  XNOR2_X1 Inst_SKINNY_Sbox_6_U18 ( .A(Inst_SKINNY_Sbox_6_n12), .B(FRESH[31]), 
        .ZN(RF3_SHIFTROWS[19]) );
  XNOR2_X1 Inst_SKINNY_Sbox_6_U17 ( .A(FRESH[27]), .B(
        Inst_SKINNY_Sbox_6_OutAff_out3[3]), .ZN(Inst_SKINNY_Sbox_6_n12) );
  XNOR2_X1 Inst_SKINNY_Sbox_6_U16 ( .A(Inst_SKINNY_Sbox_6_n11), .B(FRESH[30]), 
        .ZN(RF3_SHIFTROWS[18]) );
  XNOR2_X1 Inst_SKINNY_Sbox_6_U15 ( .A(FRESH[26]), .B(
        Inst_SKINNY_Sbox_6_OutAff_out3[2]), .ZN(Inst_SKINNY_Sbox_6_n11) );
  XNOR2_X1 Inst_SKINNY_Sbox_6_U14 ( .A(Inst_SKINNY_Sbox_6_n10), .B(FRESH[29]), 
        .ZN(RF3_SHIFTROWS[17]) );
  XNOR2_X1 Inst_SKINNY_Sbox_6_U13 ( .A(FRESH[25]), .B(
        Inst_SKINNY_Sbox_6_OutAff_out3[1]), .ZN(Inst_SKINNY_Sbox_6_n10) );
  XNOR2_X1 Inst_SKINNY_Sbox_6_U12 ( .A(Inst_SKINNY_Sbox_6_n9), .B(FRESH[28]), 
        .ZN(RF3_SHIFTROWS[16]) );
  XNOR2_X1 Inst_SKINNY_Sbox_6_U11 ( .A(FRESH[24]), .B(
        Inst_SKINNY_Sbox_6_OutAff_out3[0]), .ZN(Inst_SKINNY_Sbox_6_n9) );
  XOR2_X1 Inst_SKINNY_Sbox_6_U10 ( .A(FRESH[31]), .B(
        Inst_SKINNY_Sbox_6_OutAff_out2[3]), .Z(RF2_SHIFTROWS[19]) );
  XOR2_X1 Inst_SKINNY_Sbox_6_U9 ( .A(FRESH[30]), .B(
        Inst_SKINNY_Sbox_6_OutAff_out2[2]), .Z(RF2_SHIFTROWS[18]) );
  XOR2_X1 Inst_SKINNY_Sbox_6_U8 ( .A(FRESH[29]), .B(
        Inst_SKINNY_Sbox_6_OutAff_out2[1]), .Z(RF2_SHIFTROWS[17]) );
  XOR2_X1 Inst_SKINNY_Sbox_6_U7 ( .A(FRESH[28]), .B(
        Inst_SKINNY_Sbox_6_OutAff_out2[0]), .Z(RF2_SHIFTROWS[16]) );
  XOR2_X1 Inst_SKINNY_Sbox_6_U6 ( .A(FRESH[27]), .B(
        Inst_SKINNY_Sbox_6_OutAff_out1[3]), .Z(RF1_SHIFTROWS[19]) );
  XOR2_X1 Inst_SKINNY_Sbox_6_U5 ( .A(FRESH[26]), .B(
        Inst_SKINNY_Sbox_6_OutAff_out1[2]), .Z(RF1_SHIFTROWS[18]) );
  XOR2_X1 Inst_SKINNY_Sbox_6_U4 ( .A(FRESH[25]), .B(
        Inst_SKINNY_Sbox_6_OutAff_out1[1]), .Z(RF1_SHIFTROWS[17]) );
  XOR2_X1 Inst_SKINNY_Sbox_6_U3 ( .A(FRESH[24]), .B(
        Inst_SKINNY_Sbox_6_OutAff_out1[0]), .Z(RF1_SHIFTROWS[16]) );
  DFF_X1 Inst_SKINNY_Sbox_6_M2_out3_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_6_M2_out3[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_M2_out3_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_M2_out3_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_6_M2_out3[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_M2_out3_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_M2_out3_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_6_M2_out3[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_M2_out3_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_M2_out3_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_6_M2_out3[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_M2_out3_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_M2_out2_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_6_M2_out2[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_M2_out2_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_M2_out2_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_6_M2_out2[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_M2_out2_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_M2_out2_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_6_M2_out2[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_M2_out2_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_M2_out2_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_6_M2_out2[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_M2_out2_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_M2_out1_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_6_M2_out1[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_M2_out1_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_M2_out1_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_6_M2_out1[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_M2_out1_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_M2_out1_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_6_M2_out1[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_M2_out1_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_M2_out1_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_6_M2_out1[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_M2_out1_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_InAff_out3_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_6_InAff_out3[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_InAff_out3_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_InAff_out3_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_6_InAff_out3[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_InAff_out3_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_InAff_out3_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_6_InAff_out3[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_InAff_out3_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_InAff_out3_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_6_InAff_out3[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_InAff_out3_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_InAff_out2_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_6_InAff_out2[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_InAff_out2_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_InAff_out2_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_6_InAff_out2[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_InAff_out2_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_InAff_out2_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_6_InAff_out2[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_InAff_out2_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_InAff_out2_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_6_InAff_out2[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_InAff_out2_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_InAff_out1_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_6_InAff_out1[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_InAff_out1_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_InAff_out1_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_6_InAff_out1[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_InAff_out1_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_InAff_out1_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_6_InAff_out1[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_InAff_out1_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_InAff_out1_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_6_InAff_out1[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_InAff_out1_reg[3]), .QN() );
  INV_X1 Inst_SKINNY_Sbox_6_InputAffine_U4 ( .A(SUB_IN1[27]), .ZN(
        Inst_SKINNY_Sbox_6_InAff_out1[1]) );
  INV_X1 Inst_SKINNY_Sbox_6_InputAffine_U3 ( .A(SUB_IN1[26]), .ZN(
        Inst_SKINNY_Sbox_6_InAff_out1[3]) );
  INV_X1 Inst_SKINNY_Sbox_6_InputAffine_U2 ( .A(SUB_IN1[25]), .ZN(
        Inst_SKINNY_Sbox_6_InAff_out1[2]) );
  INV_X1 Inst_SKINNY_Sbox_6_InputAffine_U1 ( .A(SUB_IN1[24]), .ZN(
        Inst_SKINNY_Sbox_6_InAff_out1[0]) );
  DFF_X1 Inst_SKINNY_Sbox_6_Q294_inst1_CF_Reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Out[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_Q294_inst1_CF_Reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Out[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_Q294_inst1_CF_Reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Out[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_Q294_inst1_CF_Reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Out[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_Q294_inst1_CF_Reg_reg_4_ ( .D(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Out[4]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Reg[4]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_Q294_inst1_CF_Reg_reg_5_ ( .D(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Out[5]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Reg[5]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_Q294_inst1_CF_Reg_reg_6_ ( .D(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Out[6]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Reg[6]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_Q294_inst1_CF_Reg_reg_7_ ( .D(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Out[7]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Reg[7]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_Q294_inst1_CF_Reg_reg_8_ ( .D(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Out[8]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Reg[8]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_Q294_inst1_CF_Reg_reg_9_ ( .D(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Out[9]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Reg[9]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_Q294_inst1_CF_Reg_reg_10_ ( .D(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Out[10]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Reg[10]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_Q294_inst1_CF_Reg_reg_11_ ( .D(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Out[11]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Reg[11]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_Q294_inst1_CF_Reg_reg_12_ ( .D(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Out[12]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Reg[12]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_Q294_inst1_CF_Reg_reg_13_ ( .D(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Out[13]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Reg[13]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_Q294_inst1_CF_Reg_reg_14_ ( .D(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Out[14]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Reg[14]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_Q294_inst1_CF_Reg_reg_15_ ( .D(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Out[15]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Reg[15]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_Q294_inst1_CF_Reg_reg_16_ ( .D(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Out[16]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Reg[16]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_Q294_inst1_CF_Reg_reg_17_ ( .D(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Out[17]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Reg[17]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_Q294_inst1_dreg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_6_InAff_out2_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_M2_out1[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_Q294_inst1_dreg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_6_InAff_out3_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_M2_out2[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_Q294_inst1_dreg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_6_InAff_out1_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_M2_out3[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_Q294_inst1_creg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_6_InAff_out2_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_M2_out1[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_Q294_inst1_creg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_6_InAff_out3_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_M2_out2[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_Q294_inst1_creg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_6_InAff_out1_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_M2_out3[1]), .QN() );
  XNOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst1_Inst_0__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_6_Q294_inst1_Inst_0__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_6_InAff_out2_reg[0]), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Out[0]) );
  NAND2_X1 Inst_SKINNY_Sbox_6_Q294_inst1_Inst_0__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_6_InAff_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_6_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst1_Inst_0__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst1_Inst_1__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_6_Q294_inst1_Inst_1__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_6_Q294_inst1_Inst_1__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Out[1]) );
  NAND2_X1 Inst_SKINNY_Sbox_6_Q294_inst1_Inst_1__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_6_InAff_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_6_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst1_Inst_1__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst1_Inst_1__CF_Inst_U1 ( .A(FRESH[0]), .B(
        FRESH[1]), .Z(Inst_SKINNY_Sbox_6_Q294_inst1_Inst_1__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst1_Inst_2__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_6_Q294_inst1_Inst_2__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_6_Q294_inst1_Inst_2__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Out[2]) );
  NAND2_X1 Inst_SKINNY_Sbox_6_Q294_inst1_Inst_2__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_6_InAff_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_6_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst1_Inst_2__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst1_Inst_2__CF_Inst_U1 ( .A(FRESH[1]), .B(
        FRESH[2]), .Z(Inst_SKINNY_Sbox_6_Q294_inst1_Inst_2__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst1_Inst_3__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_6_Q294_inst1_Inst_3__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_6_InAff_out3_reg[0]), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Out[3]) );
  NAND2_X1 Inst_SKINNY_Sbox_6_Q294_inst1_Inst_3__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_6_InAff_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_6_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst1_Inst_3__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst1_Inst_4__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_6_Q294_inst1_Inst_4__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_6_Q294_inst1_Inst_4__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Out[4]) );
  NAND2_X1 Inst_SKINNY_Sbox_6_Q294_inst1_Inst_4__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_6_InAff_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_6_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst1_Inst_4__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst1_Inst_4__CF_Inst_U1 ( .A(FRESH[2]), .B(
        FRESH[3]), .Z(Inst_SKINNY_Sbox_6_Q294_inst1_Inst_4__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst1_Inst_5__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_6_Q294_inst1_Inst_5__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_6_Q294_inst1_Inst_5__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Out[5]) );
  NAND2_X1 Inst_SKINNY_Sbox_6_Q294_inst1_Inst_5__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_6_InAff_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_6_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst1_Inst_5__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst1_Inst_5__CF_Inst_U1 ( .A(FRESH[3]), .B(
        FRESH[4]), .Z(Inst_SKINNY_Sbox_6_Q294_inst1_Inst_5__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst1_Inst_6__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_6_Q294_inst1_Inst_6__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_6_InAff_out1_reg[0]), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Out[6]) );
  NAND2_X1 Inst_SKINNY_Sbox_6_Q294_inst1_Inst_6__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_6_InAff_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_6_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst1_Inst_6__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst1_Inst_7__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_6_Q294_inst1_Inst_7__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_6_Q294_inst1_Inst_7__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Out[7]) );
  NAND2_X1 Inst_SKINNY_Sbox_6_Q294_inst1_Inst_7__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_6_InAff_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_6_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst1_Inst_7__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst1_Inst_7__CF_Inst_U1 ( .A(FRESH[4]), .B(
        FRESH[5]), .Z(Inst_SKINNY_Sbox_6_Q294_inst1_Inst_7__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst1_Inst_8__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_6_Q294_inst1_Inst_8__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_6_Q294_inst1_Inst_8__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Out[8]) );
  NAND2_X1 Inst_SKINNY_Sbox_6_Q294_inst1_Inst_8__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_6_InAff_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_6_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst1_Inst_8__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst1_Inst_8__CF_Inst_U1 ( .A(FRESH[5]), .B(
        FRESH[0]), .Z(Inst_SKINNY_Sbox_6_Q294_inst1_Inst_8__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst1_Inst_9__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_6_Q294_inst1_Inst_9__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_6_InAff_out2_reg[1]), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Out[9]) );
  NAND2_X1 Inst_SKINNY_Sbox_6_Q294_inst1_Inst_9__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_6_InAff_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_6_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst1_Inst_9__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst1_Inst_10__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_6_Q294_inst1_Inst_10__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_6_Q294_inst1_Inst_10__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Out[10]) );
  NAND2_X1 Inst_SKINNY_Sbox_6_Q294_inst1_Inst_10__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_6_InAff_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_6_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst1_Inst_10__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst1_Inst_10__CF_Inst_U1 ( .A(FRESH[6]), 
        .B(FRESH[7]), .Z(Inst_SKINNY_Sbox_6_Q294_inst1_Inst_10__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst1_Inst_11__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_6_Q294_inst1_Inst_11__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_6_Q294_inst1_Inst_11__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Out[11]) );
  NAND2_X1 Inst_SKINNY_Sbox_6_Q294_inst1_Inst_11__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_6_InAff_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_6_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst1_Inst_11__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst1_Inst_11__CF_Inst_U1 ( .A(FRESH[7]), 
        .B(FRESH[8]), .Z(Inst_SKINNY_Sbox_6_Q294_inst1_Inst_11__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst1_Inst_12__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_6_Q294_inst1_Inst_12__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_6_InAff_out3_reg[1]), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Out[12]) );
  NAND2_X1 Inst_SKINNY_Sbox_6_Q294_inst1_Inst_12__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_6_InAff_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_6_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst1_Inst_12__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst1_Inst_13__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_6_Q294_inst1_Inst_13__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_6_Q294_inst1_Inst_13__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Out[13]) );
  NAND2_X1 Inst_SKINNY_Sbox_6_Q294_inst1_Inst_13__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_6_InAff_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_6_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst1_Inst_13__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst1_Inst_13__CF_Inst_U1 ( .A(FRESH[8]), 
        .B(FRESH[9]), .Z(Inst_SKINNY_Sbox_6_Q294_inst1_Inst_13__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst1_Inst_14__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_6_Q294_inst1_Inst_14__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_6_Q294_inst1_Inst_14__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Out[14]) );
  NAND2_X1 Inst_SKINNY_Sbox_6_Q294_inst1_Inst_14__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_6_InAff_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_6_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst1_Inst_14__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst1_Inst_14__CF_Inst_U1 ( .A(FRESH[9]), 
        .B(FRESH[10]), .Z(Inst_SKINNY_Sbox_6_Q294_inst1_Inst_14__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst1_Inst_15__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_6_Q294_inst1_Inst_15__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_6_InAff_out1_reg[1]), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Out[15]) );
  NAND2_X1 Inst_SKINNY_Sbox_6_Q294_inst1_Inst_15__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_6_InAff_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_6_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst1_Inst_15__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst1_Inst_16__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_6_Q294_inst1_Inst_16__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_6_Q294_inst1_Inst_16__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Out[16]) );
  NAND2_X1 Inst_SKINNY_Sbox_6_Q294_inst1_Inst_16__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_6_InAff_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_6_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst1_Inst_16__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst1_Inst_16__CF_Inst_U1 ( .A(FRESH[10]), 
        .B(FRESH[11]), .Z(Inst_SKINNY_Sbox_6_Q294_inst1_Inst_16__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst1_Inst_17__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_6_Q294_inst1_Inst_17__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_6_Q294_inst1_Inst_17__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Out[17]) );
  NAND2_X1 Inst_SKINNY_Sbox_6_Q294_inst1_Inst_17__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_6_InAff_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_6_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst1_Inst_17__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst1_Inst_17__CF_Inst_U1 ( .A(FRESH[11]), 
        .B(FRESH[6]), .Z(Inst_SKINNY_Sbox_6_Q294_inst1_Inst_17__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst1_InstXOR_0__Compression1_U2 ( .A(
        Inst_SKINNY_Sbox_6_Q294_inst1_InstXOR_0__Compression1_n3), .B(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Reg[2]), .ZN(
        Inst_SKINNY_Sbox_6_M2_out1[3]) );
  XNOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst1_InstXOR_0__Compression1_U1 ( .A(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Reg[0]), .B(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Reg[1]), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst1_InstXOR_0__Compression1_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst1_InstXOR_0__Compression2_U2 ( .A(
        Inst_SKINNY_Sbox_6_Q294_inst1_InstXOR_0__Compression2_n3), .B(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Reg[5]), .ZN(
        Inst_SKINNY_Sbox_6_M2_out2[3]) );
  XNOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst1_InstXOR_0__Compression2_U1 ( .A(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Reg[3]), .B(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Reg[4]), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst1_InstXOR_0__Compression2_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst1_InstXOR_0__Compression3_U2 ( .A(
        Inst_SKINNY_Sbox_6_Q294_inst1_InstXOR_0__Compression3_n3), .B(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Reg[8]), .ZN(
        Inst_SKINNY_Sbox_6_M2_out3[3]) );
  XNOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst1_InstXOR_0__Compression3_U1 ( .A(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Reg[6]), .B(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Reg[7]), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst1_InstXOR_0__Compression3_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst1_InstXOR_1__Compression1_U2 ( .A(
        Inst_SKINNY_Sbox_6_Q294_inst1_InstXOR_1__Compression1_n3), .B(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Reg[11]), .ZN(
        Inst_SKINNY_Sbox_6_M2_out1[2]) );
  XNOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst1_InstXOR_1__Compression1_U1 ( .A(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Reg[9]), .B(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Reg[10]), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst1_InstXOR_1__Compression1_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst1_InstXOR_1__Compression2_U2 ( .A(
        Inst_SKINNY_Sbox_6_Q294_inst1_InstXOR_1__Compression2_n3), .B(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Reg[14]), .ZN(
        Inst_SKINNY_Sbox_6_M2_out2[2]) );
  XNOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst1_InstXOR_1__Compression2_U1 ( .A(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Reg[12]), .B(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Reg[13]), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst1_InstXOR_1__Compression2_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst1_InstXOR_1__Compression3_U2 ( .A(
        Inst_SKINNY_Sbox_6_Q294_inst1_InstXOR_1__Compression3_n3), .B(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Reg[17]), .ZN(
        Inst_SKINNY_Sbox_6_M2_out3[2]) );
  XNOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst1_InstXOR_1__Compression3_U1 ( .A(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Reg[15]), .B(
        Inst_SKINNY_Sbox_6_Q294_inst1_CF_Reg[16]), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst1_InstXOR_1__Compression3_n3) );
  DFF_X1 Inst_SKINNY_Sbox_6_Q294_inst2_CF_Reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Out[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_Q294_inst2_CF_Reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Out[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_Q294_inst2_CF_Reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Out[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_Q294_inst2_CF_Reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Out[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_Q294_inst2_CF_Reg_reg_4_ ( .D(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Out[4]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Reg[4]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_Q294_inst2_CF_Reg_reg_5_ ( .D(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Out[5]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Reg[5]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_Q294_inst2_CF_Reg_reg_6_ ( .D(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Out[6]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Reg[6]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_Q294_inst2_CF_Reg_reg_7_ ( .D(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Out[7]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Reg[7]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_Q294_inst2_CF_Reg_reg_8_ ( .D(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Out[8]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Reg[8]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_Q294_inst2_CF_Reg_reg_9_ ( .D(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Out[9]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Reg[9]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_Q294_inst2_CF_Reg_reg_10_ ( .D(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Out[10]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Reg[10]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_Q294_inst2_CF_Reg_reg_11_ ( .D(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Out[11]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Reg[11]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_Q294_inst2_CF_Reg_reg_12_ ( .D(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Out[12]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Reg[12]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_Q294_inst2_CF_Reg_reg_13_ ( .D(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Out[13]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Reg[13]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_Q294_inst2_CF_Reg_reg_14_ ( .D(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Out[14]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Reg[14]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_Q294_inst2_CF_Reg_reg_15_ ( .D(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Out[15]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Reg[15]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_Q294_inst2_CF_Reg_reg_16_ ( .D(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Out[16]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Reg[16]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_Q294_inst2_CF_Reg_reg_17_ ( .D(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Out[17]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Reg[17]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_Q294_inst2_dreg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_6_M2_out2_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_Q294_2_out1[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_Q294_inst2_dreg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_6_M2_out3_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_OutAff_out2[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_Q294_inst2_dreg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_6_M2_out1_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_OutAff_out3[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_Q294_inst2_creg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_6_M2_out2_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_Q294_2_out1[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_Q294_inst2_creg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_6_M2_out3_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_OutAff_out2[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_6_Q294_inst2_creg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_6_M2_out1_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_6_OutAff_out3[2]), .QN() );
  XNOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst2_Inst_0__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_6_Q294_inst2_Inst_0__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_6_M2_out2_reg[0]), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Out[0]) );
  NAND2_X1 Inst_SKINNY_Sbox_6_Q294_inst2_Inst_0__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_6_M2_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_6_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst2_Inst_0__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst2_Inst_1__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_6_Q294_inst2_Inst_1__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_6_Q294_inst2_Inst_1__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Out[1]) );
  NAND2_X1 Inst_SKINNY_Sbox_6_Q294_inst2_Inst_1__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_6_M2_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_6_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst2_Inst_1__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst2_Inst_1__CF_Inst_U1 ( .A(FRESH[12]), 
        .B(FRESH[13]), .Z(Inst_SKINNY_Sbox_6_Q294_inst2_Inst_1__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst2_Inst_2__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_6_Q294_inst2_Inst_2__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_6_Q294_inst2_Inst_2__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Out[2]) );
  NAND2_X1 Inst_SKINNY_Sbox_6_Q294_inst2_Inst_2__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_6_M2_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_6_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst2_Inst_2__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst2_Inst_2__CF_Inst_U1 ( .A(FRESH[13]), 
        .B(FRESH[14]), .Z(Inst_SKINNY_Sbox_6_Q294_inst2_Inst_2__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst2_Inst_3__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_6_Q294_inst2_Inst_3__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_6_M2_out3_reg[0]), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Out[3]) );
  NAND2_X1 Inst_SKINNY_Sbox_6_Q294_inst2_Inst_3__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_6_M2_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_6_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst2_Inst_3__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst2_Inst_4__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_6_Q294_inst2_Inst_4__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_6_Q294_inst2_Inst_4__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Out[4]) );
  NAND2_X1 Inst_SKINNY_Sbox_6_Q294_inst2_Inst_4__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_6_M2_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_6_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst2_Inst_4__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst2_Inst_4__CF_Inst_U1 ( .A(FRESH[14]), 
        .B(FRESH[15]), .Z(Inst_SKINNY_Sbox_6_Q294_inst2_Inst_4__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst2_Inst_5__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_6_Q294_inst2_Inst_5__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_6_Q294_inst2_Inst_5__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Out[5]) );
  NAND2_X1 Inst_SKINNY_Sbox_6_Q294_inst2_Inst_5__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_6_M2_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_6_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst2_Inst_5__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst2_Inst_5__CF_Inst_U1 ( .A(FRESH[15]), 
        .B(FRESH[16]), .Z(Inst_SKINNY_Sbox_6_Q294_inst2_Inst_5__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst2_Inst_6__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_6_Q294_inst2_Inst_6__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_6_M2_out1_reg[0]), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Out[6]) );
  NAND2_X1 Inst_SKINNY_Sbox_6_Q294_inst2_Inst_6__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_6_M2_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_6_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst2_Inst_6__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst2_Inst_7__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_6_Q294_inst2_Inst_7__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_6_Q294_inst2_Inst_7__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Out[7]) );
  NAND2_X1 Inst_SKINNY_Sbox_6_Q294_inst2_Inst_7__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_6_M2_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_6_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst2_Inst_7__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst2_Inst_7__CF_Inst_U1 ( .A(FRESH[16]), 
        .B(FRESH[17]), .Z(Inst_SKINNY_Sbox_6_Q294_inst2_Inst_7__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst2_Inst_8__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_6_Q294_inst2_Inst_8__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_6_Q294_inst2_Inst_8__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Out[8]) );
  NAND2_X1 Inst_SKINNY_Sbox_6_Q294_inst2_Inst_8__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_6_M2_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_6_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst2_Inst_8__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst2_Inst_8__CF_Inst_U1 ( .A(FRESH[17]), 
        .B(FRESH[12]), .Z(Inst_SKINNY_Sbox_6_Q294_inst2_Inst_8__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst2_Inst_9__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_6_Q294_inst2_Inst_9__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_6_M2_out2_reg[1]), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Out[9]) );
  NAND2_X1 Inst_SKINNY_Sbox_6_Q294_inst2_Inst_9__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_6_M2_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_6_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst2_Inst_9__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst2_Inst_10__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_6_Q294_inst2_Inst_10__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_6_Q294_inst2_Inst_10__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Out[10]) );
  NAND2_X1 Inst_SKINNY_Sbox_6_Q294_inst2_Inst_10__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_6_M2_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_6_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst2_Inst_10__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst2_Inst_10__CF_Inst_U1 ( .A(FRESH[18]), 
        .B(FRESH[19]), .Z(Inst_SKINNY_Sbox_6_Q294_inst2_Inst_10__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst2_Inst_11__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_6_Q294_inst2_Inst_11__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_6_Q294_inst2_Inst_11__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Out[11]) );
  NAND2_X1 Inst_SKINNY_Sbox_6_Q294_inst2_Inst_11__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_6_M2_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_6_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst2_Inst_11__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst2_Inst_11__CF_Inst_U1 ( .A(FRESH[19]), 
        .B(FRESH[20]), .Z(Inst_SKINNY_Sbox_6_Q294_inst2_Inst_11__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst2_Inst_12__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_6_Q294_inst2_Inst_12__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_6_M2_out3_reg[1]), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Out[12]) );
  NAND2_X1 Inst_SKINNY_Sbox_6_Q294_inst2_Inst_12__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_6_M2_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_6_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst2_Inst_12__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst2_Inst_13__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_6_Q294_inst2_Inst_13__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_6_Q294_inst2_Inst_13__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Out[13]) );
  NAND2_X1 Inst_SKINNY_Sbox_6_Q294_inst2_Inst_13__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_6_M2_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_6_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst2_Inst_13__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst2_Inst_13__CF_Inst_U1 ( .A(FRESH[20]), 
        .B(FRESH[21]), .Z(Inst_SKINNY_Sbox_6_Q294_inst2_Inst_13__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst2_Inst_14__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_6_Q294_inst2_Inst_14__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_6_Q294_inst2_Inst_14__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Out[14]) );
  NAND2_X1 Inst_SKINNY_Sbox_6_Q294_inst2_Inst_14__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_6_M2_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_6_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst2_Inst_14__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst2_Inst_14__CF_Inst_U1 ( .A(FRESH[21]), 
        .B(FRESH[22]), .Z(Inst_SKINNY_Sbox_6_Q294_inst2_Inst_14__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst2_Inst_15__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_6_Q294_inst2_Inst_15__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_6_M2_out1_reg[1]), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Out[15]) );
  NAND2_X1 Inst_SKINNY_Sbox_6_Q294_inst2_Inst_15__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_6_M2_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_6_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst2_Inst_15__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst2_Inst_16__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_6_Q294_inst2_Inst_16__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_6_Q294_inst2_Inst_16__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Out[16]) );
  NAND2_X1 Inst_SKINNY_Sbox_6_Q294_inst2_Inst_16__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_6_M2_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_6_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst2_Inst_16__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst2_Inst_16__CF_Inst_U1 ( .A(FRESH[22]), 
        .B(FRESH[23]), .Z(Inst_SKINNY_Sbox_6_Q294_inst2_Inst_16__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst2_Inst_17__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_6_Q294_inst2_Inst_17__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_6_Q294_inst2_Inst_17__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Out[17]) );
  NAND2_X1 Inst_SKINNY_Sbox_6_Q294_inst2_Inst_17__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_6_M2_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_6_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst2_Inst_17__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst2_Inst_17__CF_Inst_U1 ( .A(FRESH[23]), 
        .B(FRESH[18]), .Z(Inst_SKINNY_Sbox_6_Q294_inst2_Inst_17__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst2_InstXOR_0__Compression1_U2 ( .A(
        Inst_SKINNY_Sbox_6_Q294_inst2_InstXOR_0__Compression1_n3), .B(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Reg[2]), .ZN(
        Inst_SKINNY_Sbox_6_Q294_2_out1[0]) );
  XNOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst2_InstXOR_0__Compression1_U1 ( .A(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Reg[0]), .B(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Reg[1]), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst2_InstXOR_0__Compression1_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst2_InstXOR_0__Compression2_U2 ( .A(
        Inst_SKINNY_Sbox_6_Q294_inst2_InstXOR_0__Compression2_n3), .B(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Reg[5]), .ZN(
        Inst_SKINNY_Sbox_6_OutAff_out2[1]) );
  XNOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst2_InstXOR_0__Compression2_U1 ( .A(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Reg[3]), .B(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Reg[4]), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst2_InstXOR_0__Compression2_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst2_InstXOR_0__Compression3_U2 ( .A(
        Inst_SKINNY_Sbox_6_Q294_inst2_InstXOR_0__Compression3_n3), .B(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Reg[8]), .ZN(
        Inst_SKINNY_Sbox_6_OutAff_out3[1]) );
  XNOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst2_InstXOR_0__Compression3_U1 ( .A(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Reg[6]), .B(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Reg[7]), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst2_InstXOR_0__Compression3_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst2_InstXOR_1__Compression1_U2 ( .A(
        Inst_SKINNY_Sbox_6_Q294_inst2_InstXOR_1__Compression1_n3), .B(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Reg[11]), .ZN(
        Inst_SKINNY_Sbox_6_Q294_2_out1[1]) );
  XNOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst2_InstXOR_1__Compression1_U1 ( .A(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Reg[9]), .B(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Reg[10]), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst2_InstXOR_1__Compression1_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst2_InstXOR_1__Compression2_U2 ( .A(
        Inst_SKINNY_Sbox_6_Q294_inst2_InstXOR_1__Compression2_n3), .B(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Reg[14]), .ZN(
        Inst_SKINNY_Sbox_6_OutAff_out2[0]) );
  XNOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst2_InstXOR_1__Compression2_U1 ( .A(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Reg[12]), .B(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Reg[13]), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst2_InstXOR_1__Compression2_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst2_InstXOR_1__Compression3_U2 ( .A(
        Inst_SKINNY_Sbox_6_Q294_inst2_InstXOR_1__Compression3_n3), .B(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Reg[17]), .ZN(
        Inst_SKINNY_Sbox_6_OutAff_out3[0]) );
  XNOR2_X1 Inst_SKINNY_Sbox_6_Q294_inst2_InstXOR_1__Compression3_U1 ( .A(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Reg[15]), .B(
        Inst_SKINNY_Sbox_6_Q294_inst2_CF_Reg[16]), .ZN(
        Inst_SKINNY_Sbox_6_Q294_inst2_InstXOR_1__Compression3_n3) );
  INV_X1 Inst_SKINNY_Sbox_6_OutputAffine_U4 ( .A(
        Inst_SKINNY_Sbox_6_Q294_2_out1[3]), .ZN(
        Inst_SKINNY_Sbox_6_OutAff_out1[3]) );
  INV_X1 Inst_SKINNY_Sbox_6_OutputAffine_U3 ( .A(
        Inst_SKINNY_Sbox_6_Q294_2_out1[2]), .ZN(
        Inst_SKINNY_Sbox_6_OutAff_out1[2]) );
  INV_X1 Inst_SKINNY_Sbox_6_OutputAffine_U2 ( .A(
        Inst_SKINNY_Sbox_6_Q294_2_out1[1]), .ZN(
        Inst_SKINNY_Sbox_6_OutAff_out1[0]) );
  INV_X1 Inst_SKINNY_Sbox_6_OutputAffine_U1 ( .A(
        Inst_SKINNY_Sbox_6_Q294_2_out1[0]), .ZN(
        Inst_SKINNY_Sbox_6_OutAff_out1[1]) );
  XNOR2_X1 Inst_SKINNY_Sbox_7_U18 ( .A(Inst_SKINNY_Sbox_7_n12), .B(FRESH[39]), 
        .ZN(RF3_SHIFTROWS[23]) );
  XNOR2_X1 Inst_SKINNY_Sbox_7_U17 ( .A(FRESH[35]), .B(
        Inst_SKINNY_Sbox_7_OutAff_out3[3]), .ZN(Inst_SKINNY_Sbox_7_n12) );
  XNOR2_X1 Inst_SKINNY_Sbox_7_U16 ( .A(Inst_SKINNY_Sbox_7_n11), .B(FRESH[38]), 
        .ZN(RF3_SHIFTROWS[22]) );
  XNOR2_X1 Inst_SKINNY_Sbox_7_U15 ( .A(FRESH[34]), .B(
        Inst_SKINNY_Sbox_7_OutAff_out3[2]), .ZN(Inst_SKINNY_Sbox_7_n11) );
  XNOR2_X1 Inst_SKINNY_Sbox_7_U14 ( .A(Inst_SKINNY_Sbox_7_n10), .B(FRESH[37]), 
        .ZN(SUB_OUT3[29]) );
  XNOR2_X1 Inst_SKINNY_Sbox_7_U13 ( .A(FRESH[33]), .B(
        Inst_SKINNY_Sbox_7_OutAff_out3[1]), .ZN(Inst_SKINNY_Sbox_7_n10) );
  XNOR2_X1 Inst_SKINNY_Sbox_7_U12 ( .A(Inst_SKINNY_Sbox_7_n9), .B(FRESH[36]), 
        .ZN(RF3_SHIFTROWS[20]) );
  XNOR2_X1 Inst_SKINNY_Sbox_7_U11 ( .A(FRESH[32]), .B(
        Inst_SKINNY_Sbox_7_OutAff_out3[0]), .ZN(Inst_SKINNY_Sbox_7_n9) );
  XOR2_X1 Inst_SKINNY_Sbox_7_U10 ( .A(FRESH[39]), .B(
        Inst_SKINNY_Sbox_7_OutAff_out2[3]), .Z(RF2_SHIFTROWS[23]) );
  XOR2_X1 Inst_SKINNY_Sbox_7_U9 ( .A(FRESH[38]), .B(
        Inst_SKINNY_Sbox_7_OutAff_out2[2]), .Z(RF2_SHIFTROWS[22]) );
  XOR2_X1 Inst_SKINNY_Sbox_7_U8 ( .A(FRESH[37]), .B(
        Inst_SKINNY_Sbox_7_OutAff_out2[1]), .Z(SUB_OUT2[29]) );
  XOR2_X1 Inst_SKINNY_Sbox_7_U7 ( .A(FRESH[36]), .B(
        Inst_SKINNY_Sbox_7_OutAff_out2[0]), .Z(RF2_SHIFTROWS[20]) );
  XOR2_X1 Inst_SKINNY_Sbox_7_U6 ( .A(FRESH[35]), .B(
        Inst_SKINNY_Sbox_7_OutAff_out1[3]), .Z(RF1_SHIFTROWS[23]) );
  XOR2_X1 Inst_SKINNY_Sbox_7_U5 ( .A(FRESH[34]), .B(
        Inst_SKINNY_Sbox_7_OutAff_out1[2]), .Z(RF1_SHIFTROWS[22]) );
  XOR2_X1 Inst_SKINNY_Sbox_7_U4 ( .A(FRESH[33]), .B(
        Inst_SKINNY_Sbox_7_OutAff_out1[1]), .Z(SUB_OUT1[29]) );
  XOR2_X1 Inst_SKINNY_Sbox_7_U3 ( .A(FRESH[32]), .B(
        Inst_SKINNY_Sbox_7_OutAff_out1[0]), .Z(RF1_SHIFTROWS[20]) );
  DFF_X1 Inst_SKINNY_Sbox_7_M2_out3_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_7_M2_out3[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_M2_out3_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_M2_out3_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_7_M2_out3[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_M2_out3_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_M2_out3_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_7_M2_out3[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_M2_out3_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_M2_out3_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_7_M2_out3[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_M2_out3_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_M2_out2_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_7_M2_out2[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_M2_out2_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_M2_out2_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_7_M2_out2[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_M2_out2_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_M2_out2_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_7_M2_out2[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_M2_out2_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_M2_out2_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_7_M2_out2[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_M2_out2_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_M2_out1_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_7_M2_out1[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_M2_out1_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_M2_out1_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_7_M2_out1[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_M2_out1_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_M2_out1_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_7_M2_out1[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_M2_out1_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_M2_out1_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_7_M2_out1[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_M2_out1_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_InAff_out3_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_7_InAff_out3[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_InAff_out3_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_InAff_out3_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_7_InAff_out3[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_InAff_out3_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_InAff_out3_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_7_InAff_out3[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_InAff_out3_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_InAff_out3_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_7_InAff_out3[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_InAff_out3_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_InAff_out2_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_7_InAff_out2[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_InAff_out2_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_InAff_out2_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_7_InAff_out2[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_InAff_out2_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_InAff_out2_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_7_InAff_out2[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_InAff_out2_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_InAff_out2_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_7_InAff_out2[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_InAff_out2_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_InAff_out1_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_7_InAff_out1[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_InAff_out1_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_InAff_out1_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_7_InAff_out1[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_InAff_out1_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_InAff_out1_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_7_InAff_out1[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_InAff_out1_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_InAff_out1_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_7_InAff_out1[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_InAff_out1_reg[3]), .QN() );
  INV_X1 Inst_SKINNY_Sbox_7_InputAffine_U4 ( .A(SUB_IN1[31]), .ZN(
        Inst_SKINNY_Sbox_7_InAff_out1[1]) );
  INV_X1 Inst_SKINNY_Sbox_7_InputAffine_U3 ( .A(SUB_IN1[30]), .ZN(
        Inst_SKINNY_Sbox_7_InAff_out1[3]) );
  INV_X1 Inst_SKINNY_Sbox_7_InputAffine_U2 ( .A(SUB_IN1[29]), .ZN(
        Inst_SKINNY_Sbox_7_InAff_out1[2]) );
  INV_X1 Inst_SKINNY_Sbox_7_InputAffine_U1 ( .A(SUB_IN1[28]), .ZN(
        Inst_SKINNY_Sbox_7_InAff_out1[0]) );
  DFF_X1 Inst_SKINNY_Sbox_7_Q294_inst1_CF_Reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Out[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_Q294_inst1_CF_Reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Out[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_Q294_inst1_CF_Reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Out[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_Q294_inst1_CF_Reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Out[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_Q294_inst1_CF_Reg_reg_4_ ( .D(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Out[4]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Reg[4]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_Q294_inst1_CF_Reg_reg_5_ ( .D(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Out[5]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Reg[5]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_Q294_inst1_CF_Reg_reg_6_ ( .D(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Out[6]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Reg[6]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_Q294_inst1_CF_Reg_reg_7_ ( .D(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Out[7]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Reg[7]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_Q294_inst1_CF_Reg_reg_8_ ( .D(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Out[8]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Reg[8]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_Q294_inst1_CF_Reg_reg_9_ ( .D(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Out[9]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Reg[9]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_Q294_inst1_CF_Reg_reg_10_ ( .D(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Out[10]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Reg[10]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_Q294_inst1_CF_Reg_reg_11_ ( .D(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Out[11]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Reg[11]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_Q294_inst1_CF_Reg_reg_12_ ( .D(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Out[12]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Reg[12]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_Q294_inst1_CF_Reg_reg_13_ ( .D(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Out[13]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Reg[13]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_Q294_inst1_CF_Reg_reg_14_ ( .D(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Out[14]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Reg[14]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_Q294_inst1_CF_Reg_reg_15_ ( .D(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Out[15]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Reg[15]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_Q294_inst1_CF_Reg_reg_16_ ( .D(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Out[16]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Reg[16]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_Q294_inst1_CF_Reg_reg_17_ ( .D(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Out[17]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Reg[17]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_Q294_inst1_dreg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_7_InAff_out2_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_M2_out1[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_Q294_inst1_dreg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_7_InAff_out3_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_M2_out2[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_Q294_inst1_dreg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_7_InAff_out1_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_M2_out3[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_Q294_inst1_creg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_7_InAff_out2_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_M2_out1[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_Q294_inst1_creg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_7_InAff_out3_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_M2_out2[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_Q294_inst1_creg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_7_InAff_out1_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_M2_out3[1]), .QN() );
  XNOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst1_Inst_0__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_7_Q294_inst1_Inst_0__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_7_InAff_out2_reg[0]), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Out[0]) );
  NAND2_X1 Inst_SKINNY_Sbox_7_Q294_inst1_Inst_0__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_7_InAff_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_7_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst1_Inst_0__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst1_Inst_1__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_7_Q294_inst1_Inst_1__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_7_Q294_inst1_Inst_1__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Out[1]) );
  NAND2_X1 Inst_SKINNY_Sbox_7_Q294_inst1_Inst_1__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_7_InAff_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_7_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst1_Inst_1__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst1_Inst_1__CF_Inst_U1 ( .A(FRESH[0]), .B(
        FRESH[1]), .Z(Inst_SKINNY_Sbox_7_Q294_inst1_Inst_1__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst1_Inst_2__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_7_Q294_inst1_Inst_2__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_7_Q294_inst1_Inst_2__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Out[2]) );
  NAND2_X1 Inst_SKINNY_Sbox_7_Q294_inst1_Inst_2__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_7_InAff_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_7_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst1_Inst_2__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst1_Inst_2__CF_Inst_U1 ( .A(FRESH[1]), .B(
        FRESH[2]), .Z(Inst_SKINNY_Sbox_7_Q294_inst1_Inst_2__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst1_Inst_3__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_7_Q294_inst1_Inst_3__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_7_InAff_out3_reg[0]), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Out[3]) );
  NAND2_X1 Inst_SKINNY_Sbox_7_Q294_inst1_Inst_3__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_7_InAff_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_7_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst1_Inst_3__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst1_Inst_4__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_7_Q294_inst1_Inst_4__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_7_Q294_inst1_Inst_4__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Out[4]) );
  NAND2_X1 Inst_SKINNY_Sbox_7_Q294_inst1_Inst_4__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_7_InAff_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_7_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst1_Inst_4__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst1_Inst_4__CF_Inst_U1 ( .A(FRESH[2]), .B(
        FRESH[3]), .Z(Inst_SKINNY_Sbox_7_Q294_inst1_Inst_4__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst1_Inst_5__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_7_Q294_inst1_Inst_5__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_7_Q294_inst1_Inst_5__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Out[5]) );
  NAND2_X1 Inst_SKINNY_Sbox_7_Q294_inst1_Inst_5__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_7_InAff_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_7_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst1_Inst_5__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst1_Inst_5__CF_Inst_U1 ( .A(FRESH[3]), .B(
        FRESH[4]), .Z(Inst_SKINNY_Sbox_7_Q294_inst1_Inst_5__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst1_Inst_6__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_7_Q294_inst1_Inst_6__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_7_InAff_out1_reg[0]), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Out[6]) );
  NAND2_X1 Inst_SKINNY_Sbox_7_Q294_inst1_Inst_6__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_7_InAff_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_7_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst1_Inst_6__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst1_Inst_7__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_7_Q294_inst1_Inst_7__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_7_Q294_inst1_Inst_7__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Out[7]) );
  NAND2_X1 Inst_SKINNY_Sbox_7_Q294_inst1_Inst_7__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_7_InAff_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_7_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst1_Inst_7__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst1_Inst_7__CF_Inst_U1 ( .A(FRESH[4]), .B(
        FRESH[5]), .Z(Inst_SKINNY_Sbox_7_Q294_inst1_Inst_7__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst1_Inst_8__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_7_Q294_inst1_Inst_8__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_7_Q294_inst1_Inst_8__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Out[8]) );
  NAND2_X1 Inst_SKINNY_Sbox_7_Q294_inst1_Inst_8__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_7_InAff_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_7_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst1_Inst_8__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst1_Inst_8__CF_Inst_U1 ( .A(FRESH[5]), .B(
        FRESH[0]), .Z(Inst_SKINNY_Sbox_7_Q294_inst1_Inst_8__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst1_Inst_9__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_7_Q294_inst1_Inst_9__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_7_InAff_out2_reg[1]), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Out[9]) );
  NAND2_X1 Inst_SKINNY_Sbox_7_Q294_inst1_Inst_9__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_7_InAff_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_7_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst1_Inst_9__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst1_Inst_10__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_7_Q294_inst1_Inst_10__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_7_Q294_inst1_Inst_10__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Out[10]) );
  NAND2_X1 Inst_SKINNY_Sbox_7_Q294_inst1_Inst_10__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_7_InAff_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_7_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst1_Inst_10__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst1_Inst_10__CF_Inst_U1 ( .A(FRESH[6]), 
        .B(FRESH[7]), .Z(Inst_SKINNY_Sbox_7_Q294_inst1_Inst_10__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst1_Inst_11__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_7_Q294_inst1_Inst_11__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_7_Q294_inst1_Inst_11__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Out[11]) );
  NAND2_X1 Inst_SKINNY_Sbox_7_Q294_inst1_Inst_11__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_7_InAff_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_7_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst1_Inst_11__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst1_Inst_11__CF_Inst_U1 ( .A(FRESH[7]), 
        .B(FRESH[8]), .Z(Inst_SKINNY_Sbox_7_Q294_inst1_Inst_11__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst1_Inst_12__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_7_Q294_inst1_Inst_12__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_7_InAff_out3_reg[1]), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Out[12]) );
  NAND2_X1 Inst_SKINNY_Sbox_7_Q294_inst1_Inst_12__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_7_InAff_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_7_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst1_Inst_12__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst1_Inst_13__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_7_Q294_inst1_Inst_13__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_7_Q294_inst1_Inst_13__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Out[13]) );
  NAND2_X1 Inst_SKINNY_Sbox_7_Q294_inst1_Inst_13__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_7_InAff_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_7_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst1_Inst_13__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst1_Inst_13__CF_Inst_U1 ( .A(FRESH[8]), 
        .B(FRESH[9]), .Z(Inst_SKINNY_Sbox_7_Q294_inst1_Inst_13__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst1_Inst_14__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_7_Q294_inst1_Inst_14__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_7_Q294_inst1_Inst_14__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Out[14]) );
  NAND2_X1 Inst_SKINNY_Sbox_7_Q294_inst1_Inst_14__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_7_InAff_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_7_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst1_Inst_14__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst1_Inst_14__CF_Inst_U1 ( .A(FRESH[9]), 
        .B(FRESH[10]), .Z(Inst_SKINNY_Sbox_7_Q294_inst1_Inst_14__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst1_Inst_15__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_7_Q294_inst1_Inst_15__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_7_InAff_out1_reg[1]), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Out[15]) );
  NAND2_X1 Inst_SKINNY_Sbox_7_Q294_inst1_Inst_15__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_7_InAff_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_7_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst1_Inst_15__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst1_Inst_16__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_7_Q294_inst1_Inst_16__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_7_Q294_inst1_Inst_16__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Out[16]) );
  NAND2_X1 Inst_SKINNY_Sbox_7_Q294_inst1_Inst_16__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_7_InAff_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_7_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst1_Inst_16__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst1_Inst_16__CF_Inst_U1 ( .A(FRESH[10]), 
        .B(FRESH[11]), .Z(Inst_SKINNY_Sbox_7_Q294_inst1_Inst_16__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst1_Inst_17__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_7_Q294_inst1_Inst_17__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_7_Q294_inst1_Inst_17__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Out[17]) );
  NAND2_X1 Inst_SKINNY_Sbox_7_Q294_inst1_Inst_17__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_7_InAff_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_7_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst1_Inst_17__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst1_Inst_17__CF_Inst_U1 ( .A(FRESH[11]), 
        .B(FRESH[6]), .Z(Inst_SKINNY_Sbox_7_Q294_inst1_Inst_17__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst1_InstXOR_0__Compression1_U2 ( .A(
        Inst_SKINNY_Sbox_7_Q294_inst1_InstXOR_0__Compression1_n3), .B(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Reg[2]), .ZN(
        Inst_SKINNY_Sbox_7_M2_out1[3]) );
  XNOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst1_InstXOR_0__Compression1_U1 ( .A(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Reg[0]), .B(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Reg[1]), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst1_InstXOR_0__Compression1_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst1_InstXOR_0__Compression2_U2 ( .A(
        Inst_SKINNY_Sbox_7_Q294_inst1_InstXOR_0__Compression2_n3), .B(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Reg[5]), .ZN(
        Inst_SKINNY_Sbox_7_M2_out2[3]) );
  XNOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst1_InstXOR_0__Compression2_U1 ( .A(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Reg[3]), .B(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Reg[4]), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst1_InstXOR_0__Compression2_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst1_InstXOR_0__Compression3_U2 ( .A(
        Inst_SKINNY_Sbox_7_Q294_inst1_InstXOR_0__Compression3_n3), .B(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Reg[8]), .ZN(
        Inst_SKINNY_Sbox_7_M2_out3[3]) );
  XNOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst1_InstXOR_0__Compression3_U1 ( .A(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Reg[6]), .B(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Reg[7]), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst1_InstXOR_0__Compression3_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst1_InstXOR_1__Compression1_U2 ( .A(
        Inst_SKINNY_Sbox_7_Q294_inst1_InstXOR_1__Compression1_n3), .B(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Reg[11]), .ZN(
        Inst_SKINNY_Sbox_7_M2_out1[2]) );
  XNOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst1_InstXOR_1__Compression1_U1 ( .A(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Reg[9]), .B(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Reg[10]), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst1_InstXOR_1__Compression1_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst1_InstXOR_1__Compression2_U2 ( .A(
        Inst_SKINNY_Sbox_7_Q294_inst1_InstXOR_1__Compression2_n3), .B(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Reg[14]), .ZN(
        Inst_SKINNY_Sbox_7_M2_out2[2]) );
  XNOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst1_InstXOR_1__Compression2_U1 ( .A(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Reg[12]), .B(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Reg[13]), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst1_InstXOR_1__Compression2_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst1_InstXOR_1__Compression3_U2 ( .A(
        Inst_SKINNY_Sbox_7_Q294_inst1_InstXOR_1__Compression3_n3), .B(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Reg[17]), .ZN(
        Inst_SKINNY_Sbox_7_M2_out3[2]) );
  XNOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst1_InstXOR_1__Compression3_U1 ( .A(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Reg[15]), .B(
        Inst_SKINNY_Sbox_7_Q294_inst1_CF_Reg[16]), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst1_InstXOR_1__Compression3_n3) );
  DFF_X1 Inst_SKINNY_Sbox_7_Q294_inst2_CF_Reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Out[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_Q294_inst2_CF_Reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Out[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_Q294_inst2_CF_Reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Out[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_Q294_inst2_CF_Reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Out[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_Q294_inst2_CF_Reg_reg_4_ ( .D(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Out[4]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Reg[4]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_Q294_inst2_CF_Reg_reg_5_ ( .D(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Out[5]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Reg[5]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_Q294_inst2_CF_Reg_reg_6_ ( .D(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Out[6]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Reg[6]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_Q294_inst2_CF_Reg_reg_7_ ( .D(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Out[7]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Reg[7]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_Q294_inst2_CF_Reg_reg_8_ ( .D(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Out[8]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Reg[8]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_Q294_inst2_CF_Reg_reg_9_ ( .D(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Out[9]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Reg[9]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_Q294_inst2_CF_Reg_reg_10_ ( .D(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Out[10]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Reg[10]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_Q294_inst2_CF_Reg_reg_11_ ( .D(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Out[11]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Reg[11]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_Q294_inst2_CF_Reg_reg_12_ ( .D(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Out[12]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Reg[12]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_Q294_inst2_CF_Reg_reg_13_ ( .D(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Out[13]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Reg[13]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_Q294_inst2_CF_Reg_reg_14_ ( .D(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Out[14]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Reg[14]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_Q294_inst2_CF_Reg_reg_15_ ( .D(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Out[15]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Reg[15]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_Q294_inst2_CF_Reg_reg_16_ ( .D(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Out[16]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Reg[16]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_Q294_inst2_CF_Reg_reg_17_ ( .D(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Out[17]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Reg[17]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_Q294_inst2_dreg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_7_M2_out2_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_Q294_2_out1[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_Q294_inst2_dreg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_7_M2_out3_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_OutAff_out2[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_Q294_inst2_dreg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_7_M2_out1_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_OutAff_out3[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_Q294_inst2_creg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_7_M2_out2_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_Q294_2_out1[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_Q294_inst2_creg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_7_M2_out3_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_OutAff_out2[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_7_Q294_inst2_creg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_7_M2_out1_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_7_OutAff_out3[2]), .QN() );
  XNOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst2_Inst_0__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_7_Q294_inst2_Inst_0__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_7_M2_out2_reg[0]), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Out[0]) );
  NAND2_X1 Inst_SKINNY_Sbox_7_Q294_inst2_Inst_0__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_7_M2_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_7_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst2_Inst_0__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst2_Inst_1__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_7_Q294_inst2_Inst_1__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_7_Q294_inst2_Inst_1__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Out[1]) );
  NAND2_X1 Inst_SKINNY_Sbox_7_Q294_inst2_Inst_1__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_7_M2_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_7_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst2_Inst_1__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst2_Inst_1__CF_Inst_U1 ( .A(FRESH[12]), 
        .B(FRESH[13]), .Z(Inst_SKINNY_Sbox_7_Q294_inst2_Inst_1__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst2_Inst_2__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_7_Q294_inst2_Inst_2__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_7_Q294_inst2_Inst_2__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Out[2]) );
  NAND2_X1 Inst_SKINNY_Sbox_7_Q294_inst2_Inst_2__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_7_M2_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_7_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst2_Inst_2__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst2_Inst_2__CF_Inst_U1 ( .A(FRESH[13]), 
        .B(FRESH[14]), .Z(Inst_SKINNY_Sbox_7_Q294_inst2_Inst_2__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst2_Inst_3__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_7_Q294_inst2_Inst_3__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_7_M2_out3_reg[0]), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Out[3]) );
  NAND2_X1 Inst_SKINNY_Sbox_7_Q294_inst2_Inst_3__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_7_M2_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_7_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst2_Inst_3__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst2_Inst_4__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_7_Q294_inst2_Inst_4__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_7_Q294_inst2_Inst_4__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Out[4]) );
  NAND2_X1 Inst_SKINNY_Sbox_7_Q294_inst2_Inst_4__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_7_M2_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_7_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst2_Inst_4__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst2_Inst_4__CF_Inst_U1 ( .A(FRESH[14]), 
        .B(FRESH[15]), .Z(Inst_SKINNY_Sbox_7_Q294_inst2_Inst_4__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst2_Inst_5__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_7_Q294_inst2_Inst_5__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_7_Q294_inst2_Inst_5__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Out[5]) );
  NAND2_X1 Inst_SKINNY_Sbox_7_Q294_inst2_Inst_5__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_7_M2_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_7_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst2_Inst_5__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst2_Inst_5__CF_Inst_U1 ( .A(FRESH[15]), 
        .B(FRESH[16]), .Z(Inst_SKINNY_Sbox_7_Q294_inst2_Inst_5__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst2_Inst_6__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_7_Q294_inst2_Inst_6__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_7_M2_out1_reg[0]), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Out[6]) );
  NAND2_X1 Inst_SKINNY_Sbox_7_Q294_inst2_Inst_6__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_7_M2_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_7_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst2_Inst_6__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst2_Inst_7__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_7_Q294_inst2_Inst_7__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_7_Q294_inst2_Inst_7__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Out[7]) );
  NAND2_X1 Inst_SKINNY_Sbox_7_Q294_inst2_Inst_7__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_7_M2_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_7_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst2_Inst_7__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst2_Inst_7__CF_Inst_U1 ( .A(FRESH[16]), 
        .B(FRESH[17]), .Z(Inst_SKINNY_Sbox_7_Q294_inst2_Inst_7__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst2_Inst_8__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_7_Q294_inst2_Inst_8__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_7_Q294_inst2_Inst_8__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Out[8]) );
  NAND2_X1 Inst_SKINNY_Sbox_7_Q294_inst2_Inst_8__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_7_M2_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_7_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst2_Inst_8__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst2_Inst_8__CF_Inst_U1 ( .A(FRESH[17]), 
        .B(FRESH[12]), .Z(Inst_SKINNY_Sbox_7_Q294_inst2_Inst_8__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst2_Inst_9__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_7_Q294_inst2_Inst_9__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_7_M2_out2_reg[1]), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Out[9]) );
  NAND2_X1 Inst_SKINNY_Sbox_7_Q294_inst2_Inst_9__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_7_M2_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_7_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst2_Inst_9__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst2_Inst_10__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_7_Q294_inst2_Inst_10__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_7_Q294_inst2_Inst_10__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Out[10]) );
  NAND2_X1 Inst_SKINNY_Sbox_7_Q294_inst2_Inst_10__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_7_M2_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_7_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst2_Inst_10__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst2_Inst_10__CF_Inst_U1 ( .A(FRESH[18]), 
        .B(FRESH[19]), .Z(Inst_SKINNY_Sbox_7_Q294_inst2_Inst_10__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst2_Inst_11__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_7_Q294_inst2_Inst_11__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_7_Q294_inst2_Inst_11__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Out[11]) );
  NAND2_X1 Inst_SKINNY_Sbox_7_Q294_inst2_Inst_11__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_7_M2_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_7_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst2_Inst_11__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst2_Inst_11__CF_Inst_U1 ( .A(FRESH[19]), 
        .B(FRESH[20]), .Z(Inst_SKINNY_Sbox_7_Q294_inst2_Inst_11__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst2_Inst_12__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_7_Q294_inst2_Inst_12__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_7_M2_out3_reg[1]), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Out[12]) );
  NAND2_X1 Inst_SKINNY_Sbox_7_Q294_inst2_Inst_12__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_7_M2_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_7_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst2_Inst_12__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst2_Inst_13__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_7_Q294_inst2_Inst_13__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_7_Q294_inst2_Inst_13__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Out[13]) );
  NAND2_X1 Inst_SKINNY_Sbox_7_Q294_inst2_Inst_13__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_7_M2_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_7_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst2_Inst_13__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst2_Inst_13__CF_Inst_U1 ( .A(FRESH[20]), 
        .B(FRESH[21]), .Z(Inst_SKINNY_Sbox_7_Q294_inst2_Inst_13__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst2_Inst_14__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_7_Q294_inst2_Inst_14__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_7_Q294_inst2_Inst_14__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Out[14]) );
  NAND2_X1 Inst_SKINNY_Sbox_7_Q294_inst2_Inst_14__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_7_M2_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_7_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst2_Inst_14__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst2_Inst_14__CF_Inst_U1 ( .A(FRESH[21]), 
        .B(FRESH[22]), .Z(Inst_SKINNY_Sbox_7_Q294_inst2_Inst_14__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst2_Inst_15__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_7_Q294_inst2_Inst_15__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_7_M2_out1_reg[1]), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Out[15]) );
  NAND2_X1 Inst_SKINNY_Sbox_7_Q294_inst2_Inst_15__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_7_M2_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_7_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst2_Inst_15__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst2_Inst_16__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_7_Q294_inst2_Inst_16__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_7_Q294_inst2_Inst_16__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Out[16]) );
  NAND2_X1 Inst_SKINNY_Sbox_7_Q294_inst2_Inst_16__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_7_M2_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_7_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst2_Inst_16__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst2_Inst_16__CF_Inst_U1 ( .A(FRESH[22]), 
        .B(FRESH[23]), .Z(Inst_SKINNY_Sbox_7_Q294_inst2_Inst_16__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst2_Inst_17__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_7_Q294_inst2_Inst_17__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_7_Q294_inst2_Inst_17__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Out[17]) );
  NAND2_X1 Inst_SKINNY_Sbox_7_Q294_inst2_Inst_17__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_7_M2_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_7_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst2_Inst_17__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst2_Inst_17__CF_Inst_U1 ( .A(FRESH[23]), 
        .B(FRESH[18]), .Z(Inst_SKINNY_Sbox_7_Q294_inst2_Inst_17__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst2_InstXOR_0__Compression1_U2 ( .A(
        Inst_SKINNY_Sbox_7_Q294_inst2_InstXOR_0__Compression1_n3), .B(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Reg[2]), .ZN(
        Inst_SKINNY_Sbox_7_Q294_2_out1[0]) );
  XNOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst2_InstXOR_0__Compression1_U1 ( .A(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Reg[0]), .B(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Reg[1]), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst2_InstXOR_0__Compression1_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst2_InstXOR_0__Compression2_U2 ( .A(
        Inst_SKINNY_Sbox_7_Q294_inst2_InstXOR_0__Compression2_n3), .B(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Reg[5]), .ZN(
        Inst_SKINNY_Sbox_7_OutAff_out2[1]) );
  XNOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst2_InstXOR_0__Compression2_U1 ( .A(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Reg[3]), .B(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Reg[4]), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst2_InstXOR_0__Compression2_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst2_InstXOR_0__Compression3_U2 ( .A(
        Inst_SKINNY_Sbox_7_Q294_inst2_InstXOR_0__Compression3_n3), .B(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Reg[8]), .ZN(
        Inst_SKINNY_Sbox_7_OutAff_out3[1]) );
  XNOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst2_InstXOR_0__Compression3_U1 ( .A(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Reg[6]), .B(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Reg[7]), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst2_InstXOR_0__Compression3_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst2_InstXOR_1__Compression1_U2 ( .A(
        Inst_SKINNY_Sbox_7_Q294_inst2_InstXOR_1__Compression1_n3), .B(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Reg[11]), .ZN(
        Inst_SKINNY_Sbox_7_Q294_2_out1[1]) );
  XNOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst2_InstXOR_1__Compression1_U1 ( .A(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Reg[9]), .B(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Reg[10]), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst2_InstXOR_1__Compression1_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst2_InstXOR_1__Compression2_U2 ( .A(
        Inst_SKINNY_Sbox_7_Q294_inst2_InstXOR_1__Compression2_n3), .B(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Reg[14]), .ZN(
        Inst_SKINNY_Sbox_7_OutAff_out2[0]) );
  XNOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst2_InstXOR_1__Compression2_U1 ( .A(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Reg[12]), .B(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Reg[13]), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst2_InstXOR_1__Compression2_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst2_InstXOR_1__Compression3_U2 ( .A(
        Inst_SKINNY_Sbox_7_Q294_inst2_InstXOR_1__Compression3_n3), .B(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Reg[17]), .ZN(
        Inst_SKINNY_Sbox_7_OutAff_out3[0]) );
  XNOR2_X1 Inst_SKINNY_Sbox_7_Q294_inst2_InstXOR_1__Compression3_U1 ( .A(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Reg[15]), .B(
        Inst_SKINNY_Sbox_7_Q294_inst2_CF_Reg[16]), .ZN(
        Inst_SKINNY_Sbox_7_Q294_inst2_InstXOR_1__Compression3_n3) );
  INV_X1 Inst_SKINNY_Sbox_7_OutputAffine_U4 ( .A(
        Inst_SKINNY_Sbox_7_Q294_2_out1[3]), .ZN(
        Inst_SKINNY_Sbox_7_OutAff_out1[3]) );
  INV_X1 Inst_SKINNY_Sbox_7_OutputAffine_U3 ( .A(
        Inst_SKINNY_Sbox_7_Q294_2_out1[2]), .ZN(
        Inst_SKINNY_Sbox_7_OutAff_out1[2]) );
  INV_X1 Inst_SKINNY_Sbox_7_OutputAffine_U2 ( .A(
        Inst_SKINNY_Sbox_7_Q294_2_out1[1]), .ZN(
        Inst_SKINNY_Sbox_7_OutAff_out1[0]) );
  INV_X1 Inst_SKINNY_Sbox_7_OutputAffine_U1 ( .A(
        Inst_SKINNY_Sbox_7_Q294_2_out1[0]), .ZN(
        Inst_SKINNY_Sbox_7_OutAff_out1[1]) );
  XNOR2_X1 Inst_SKINNY_Sbox_8_U18 ( .A(Inst_SKINNY_Sbox_8_n12), .B(FRESH[31]), 
        .ZN(SUB_OUT3[35]) );
  XNOR2_X1 Inst_SKINNY_Sbox_8_U17 ( .A(FRESH[27]), .B(
        Inst_SKINNY_Sbox_8_OutAff_out3[3]), .ZN(Inst_SKINNY_Sbox_8_n12) );
  XNOR2_X1 Inst_SKINNY_Sbox_8_U16 ( .A(Inst_SKINNY_Sbox_8_n11), .B(FRESH[30]), 
        .ZN(SUB_OUT3[34]) );
  XNOR2_X1 Inst_SKINNY_Sbox_8_U15 ( .A(FRESH[26]), .B(
        Inst_SKINNY_Sbox_8_OutAff_out3[2]), .ZN(Inst_SKINNY_Sbox_8_n11) );
  XNOR2_X1 Inst_SKINNY_Sbox_8_U14 ( .A(Inst_SKINNY_Sbox_8_n10), .B(FRESH[29]), 
        .ZN(SUB_OUT3[33]) );
  XNOR2_X1 Inst_SKINNY_Sbox_8_U13 ( .A(FRESH[25]), .B(
        Inst_SKINNY_Sbox_8_OutAff_out3[1]), .ZN(Inst_SKINNY_Sbox_8_n10) );
  XNOR2_X1 Inst_SKINNY_Sbox_8_U12 ( .A(Inst_SKINNY_Sbox_8_n9), .B(FRESH[28]), 
        .ZN(SUB_OUT3[32]) );
  XNOR2_X1 Inst_SKINNY_Sbox_8_U11 ( .A(FRESH[24]), .B(
        Inst_SKINNY_Sbox_8_OutAff_out3[0]), .ZN(Inst_SKINNY_Sbox_8_n9) );
  XOR2_X1 Inst_SKINNY_Sbox_8_U10 ( .A(FRESH[31]), .B(
        Inst_SKINNY_Sbox_8_OutAff_out2[3]), .Z(SUB_OUT2[35]) );
  XOR2_X1 Inst_SKINNY_Sbox_8_U9 ( .A(FRESH[30]), .B(
        Inst_SKINNY_Sbox_8_OutAff_out2[2]), .Z(SUB_OUT2[34]) );
  XOR2_X1 Inst_SKINNY_Sbox_8_U8 ( .A(FRESH[29]), .B(
        Inst_SKINNY_Sbox_8_OutAff_out2[1]), .Z(SUB_OUT2[33]) );
  XOR2_X1 Inst_SKINNY_Sbox_8_U7 ( .A(FRESH[28]), .B(
        Inst_SKINNY_Sbox_8_OutAff_out2[0]), .Z(SUB_OUT2[32]) );
  XOR2_X1 Inst_SKINNY_Sbox_8_U6 ( .A(FRESH[27]), .B(
        Inst_SKINNY_Sbox_8_OutAff_out1[3]), .Z(SUB_OUT1[35]) );
  XOR2_X1 Inst_SKINNY_Sbox_8_U5 ( .A(FRESH[26]), .B(
        Inst_SKINNY_Sbox_8_OutAff_out1[2]), .Z(SUB_OUT1[34]) );
  XOR2_X1 Inst_SKINNY_Sbox_8_U4 ( .A(FRESH[25]), .B(
        Inst_SKINNY_Sbox_8_OutAff_out1[1]), .Z(SUB_OUT1[33]) );
  XOR2_X1 Inst_SKINNY_Sbox_8_U3 ( .A(FRESH[24]), .B(
        Inst_SKINNY_Sbox_8_OutAff_out1[0]), .Z(SUB_OUT1[32]) );
  DFF_X1 Inst_SKINNY_Sbox_8_M2_out3_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_8_M2_out3[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_M2_out3_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_M2_out3_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_8_M2_out3[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_M2_out3_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_M2_out3_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_8_M2_out3[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_M2_out3_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_M2_out3_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_8_M2_out3[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_M2_out3_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_M2_out2_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_8_M2_out2[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_M2_out2_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_M2_out2_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_8_M2_out2[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_M2_out2_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_M2_out2_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_8_M2_out2[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_M2_out2_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_M2_out2_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_8_M2_out2[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_M2_out2_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_M2_out1_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_8_M2_out1[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_M2_out1_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_M2_out1_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_8_M2_out1[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_M2_out1_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_M2_out1_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_8_M2_out1[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_M2_out1_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_M2_out1_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_8_M2_out1[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_M2_out1_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_InAff_out3_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_8_InAff_out3[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_InAff_out3_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_InAff_out3_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_8_InAff_out3[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_InAff_out3_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_InAff_out3_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_8_InAff_out3[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_InAff_out3_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_InAff_out3_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_8_InAff_out3[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_InAff_out3_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_InAff_out2_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_8_InAff_out2[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_InAff_out2_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_InAff_out2_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_8_InAff_out2[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_InAff_out2_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_InAff_out2_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_8_InAff_out2[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_InAff_out2_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_InAff_out2_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_8_InAff_out2[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_InAff_out2_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_InAff_out1_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_8_InAff_out1[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_InAff_out1_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_InAff_out1_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_8_InAff_out1[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_InAff_out1_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_InAff_out1_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_8_InAff_out1[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_InAff_out1_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_InAff_out1_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_8_InAff_out1[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_InAff_out1_reg[3]), .QN() );
  INV_X1 Inst_SKINNY_Sbox_8_InputAffine_U4 ( .A(SUB_IN1[35]), .ZN(
        Inst_SKINNY_Sbox_8_InAff_out1[1]) );
  INV_X1 Inst_SKINNY_Sbox_8_InputAffine_U3 ( .A(SUB_IN1[34]), .ZN(
        Inst_SKINNY_Sbox_8_InAff_out1[3]) );
  INV_X1 Inst_SKINNY_Sbox_8_InputAffine_U2 ( .A(SUB_IN1[33]), .ZN(
        Inst_SKINNY_Sbox_8_InAff_out1[2]) );
  INV_X1 Inst_SKINNY_Sbox_8_InputAffine_U1 ( .A(SUB_IN1[32]), .ZN(
        Inst_SKINNY_Sbox_8_InAff_out1[0]) );
  DFF_X1 Inst_SKINNY_Sbox_8_Q294_inst1_CF_Reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Out[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_Q294_inst1_CF_Reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Out[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_Q294_inst1_CF_Reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Out[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_Q294_inst1_CF_Reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Out[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_Q294_inst1_CF_Reg_reg_4_ ( .D(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Out[4]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Reg[4]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_Q294_inst1_CF_Reg_reg_5_ ( .D(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Out[5]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Reg[5]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_Q294_inst1_CF_Reg_reg_6_ ( .D(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Out[6]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Reg[6]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_Q294_inst1_CF_Reg_reg_7_ ( .D(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Out[7]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Reg[7]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_Q294_inst1_CF_Reg_reg_8_ ( .D(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Out[8]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Reg[8]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_Q294_inst1_CF_Reg_reg_9_ ( .D(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Out[9]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Reg[9]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_Q294_inst1_CF_Reg_reg_10_ ( .D(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Out[10]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Reg[10]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_Q294_inst1_CF_Reg_reg_11_ ( .D(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Out[11]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Reg[11]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_Q294_inst1_CF_Reg_reg_12_ ( .D(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Out[12]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Reg[12]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_Q294_inst1_CF_Reg_reg_13_ ( .D(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Out[13]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Reg[13]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_Q294_inst1_CF_Reg_reg_14_ ( .D(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Out[14]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Reg[14]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_Q294_inst1_CF_Reg_reg_15_ ( .D(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Out[15]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Reg[15]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_Q294_inst1_CF_Reg_reg_16_ ( .D(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Out[16]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Reg[16]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_Q294_inst1_CF_Reg_reg_17_ ( .D(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Out[17]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Reg[17]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_Q294_inst1_dreg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_8_InAff_out2_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_M2_out1[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_Q294_inst1_dreg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_8_InAff_out3_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_M2_out2[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_Q294_inst1_dreg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_8_InAff_out1_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_M2_out3[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_Q294_inst1_creg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_8_InAff_out2_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_M2_out1[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_Q294_inst1_creg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_8_InAff_out3_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_M2_out2[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_Q294_inst1_creg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_8_InAff_out1_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_M2_out3[1]), .QN() );
  XNOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst1_Inst_0__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_8_Q294_inst1_Inst_0__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_8_InAff_out2_reg[0]), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Out[0]) );
  NAND2_X1 Inst_SKINNY_Sbox_8_Q294_inst1_Inst_0__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_8_InAff_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_8_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst1_Inst_0__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst1_Inst_1__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_8_Q294_inst1_Inst_1__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_8_Q294_inst1_Inst_1__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Out[1]) );
  NAND2_X1 Inst_SKINNY_Sbox_8_Q294_inst1_Inst_1__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_8_InAff_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_8_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst1_Inst_1__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst1_Inst_1__CF_Inst_U1 ( .A(FRESH[0]), .B(
        FRESH[1]), .Z(Inst_SKINNY_Sbox_8_Q294_inst1_Inst_1__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst1_Inst_2__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_8_Q294_inst1_Inst_2__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_8_Q294_inst1_Inst_2__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Out[2]) );
  NAND2_X1 Inst_SKINNY_Sbox_8_Q294_inst1_Inst_2__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_8_InAff_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_8_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst1_Inst_2__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst1_Inst_2__CF_Inst_U1 ( .A(FRESH[1]), .B(
        FRESH[2]), .Z(Inst_SKINNY_Sbox_8_Q294_inst1_Inst_2__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst1_Inst_3__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_8_Q294_inst1_Inst_3__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_8_InAff_out3_reg[0]), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Out[3]) );
  NAND2_X1 Inst_SKINNY_Sbox_8_Q294_inst1_Inst_3__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_8_InAff_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_8_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst1_Inst_3__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst1_Inst_4__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_8_Q294_inst1_Inst_4__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_8_Q294_inst1_Inst_4__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Out[4]) );
  NAND2_X1 Inst_SKINNY_Sbox_8_Q294_inst1_Inst_4__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_8_InAff_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_8_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst1_Inst_4__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst1_Inst_4__CF_Inst_U1 ( .A(FRESH[2]), .B(
        FRESH[3]), .Z(Inst_SKINNY_Sbox_8_Q294_inst1_Inst_4__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst1_Inst_5__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_8_Q294_inst1_Inst_5__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_8_Q294_inst1_Inst_5__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Out[5]) );
  NAND2_X1 Inst_SKINNY_Sbox_8_Q294_inst1_Inst_5__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_8_InAff_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_8_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst1_Inst_5__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst1_Inst_5__CF_Inst_U1 ( .A(FRESH[3]), .B(
        FRESH[4]), .Z(Inst_SKINNY_Sbox_8_Q294_inst1_Inst_5__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst1_Inst_6__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_8_Q294_inst1_Inst_6__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_8_InAff_out1_reg[0]), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Out[6]) );
  NAND2_X1 Inst_SKINNY_Sbox_8_Q294_inst1_Inst_6__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_8_InAff_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_8_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst1_Inst_6__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst1_Inst_7__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_8_Q294_inst1_Inst_7__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_8_Q294_inst1_Inst_7__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Out[7]) );
  NAND2_X1 Inst_SKINNY_Sbox_8_Q294_inst1_Inst_7__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_8_InAff_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_8_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst1_Inst_7__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst1_Inst_7__CF_Inst_U1 ( .A(FRESH[4]), .B(
        FRESH[5]), .Z(Inst_SKINNY_Sbox_8_Q294_inst1_Inst_7__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst1_Inst_8__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_8_Q294_inst1_Inst_8__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_8_Q294_inst1_Inst_8__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Out[8]) );
  NAND2_X1 Inst_SKINNY_Sbox_8_Q294_inst1_Inst_8__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_8_InAff_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_8_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst1_Inst_8__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst1_Inst_8__CF_Inst_U1 ( .A(FRESH[5]), .B(
        FRESH[0]), .Z(Inst_SKINNY_Sbox_8_Q294_inst1_Inst_8__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst1_Inst_9__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_8_Q294_inst1_Inst_9__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_8_InAff_out2_reg[1]), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Out[9]) );
  NAND2_X1 Inst_SKINNY_Sbox_8_Q294_inst1_Inst_9__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_8_InAff_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_8_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst1_Inst_9__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst1_Inst_10__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_8_Q294_inst1_Inst_10__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_8_Q294_inst1_Inst_10__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Out[10]) );
  NAND2_X1 Inst_SKINNY_Sbox_8_Q294_inst1_Inst_10__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_8_InAff_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_8_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst1_Inst_10__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst1_Inst_10__CF_Inst_U1 ( .A(FRESH[6]), 
        .B(FRESH[7]), .Z(Inst_SKINNY_Sbox_8_Q294_inst1_Inst_10__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst1_Inst_11__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_8_Q294_inst1_Inst_11__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_8_Q294_inst1_Inst_11__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Out[11]) );
  NAND2_X1 Inst_SKINNY_Sbox_8_Q294_inst1_Inst_11__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_8_InAff_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_8_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst1_Inst_11__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst1_Inst_11__CF_Inst_U1 ( .A(FRESH[7]), 
        .B(FRESH[8]), .Z(Inst_SKINNY_Sbox_8_Q294_inst1_Inst_11__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst1_Inst_12__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_8_Q294_inst1_Inst_12__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_8_InAff_out3_reg[1]), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Out[12]) );
  NAND2_X1 Inst_SKINNY_Sbox_8_Q294_inst1_Inst_12__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_8_InAff_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_8_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst1_Inst_12__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst1_Inst_13__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_8_Q294_inst1_Inst_13__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_8_Q294_inst1_Inst_13__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Out[13]) );
  NAND2_X1 Inst_SKINNY_Sbox_8_Q294_inst1_Inst_13__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_8_InAff_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_8_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst1_Inst_13__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst1_Inst_13__CF_Inst_U1 ( .A(FRESH[8]), 
        .B(FRESH[9]), .Z(Inst_SKINNY_Sbox_8_Q294_inst1_Inst_13__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst1_Inst_14__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_8_Q294_inst1_Inst_14__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_8_Q294_inst1_Inst_14__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Out[14]) );
  NAND2_X1 Inst_SKINNY_Sbox_8_Q294_inst1_Inst_14__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_8_InAff_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_8_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst1_Inst_14__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst1_Inst_14__CF_Inst_U1 ( .A(FRESH[9]), 
        .B(FRESH[10]), .Z(Inst_SKINNY_Sbox_8_Q294_inst1_Inst_14__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst1_Inst_15__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_8_Q294_inst1_Inst_15__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_8_InAff_out1_reg[1]), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Out[15]) );
  NAND2_X1 Inst_SKINNY_Sbox_8_Q294_inst1_Inst_15__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_8_InAff_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_8_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst1_Inst_15__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst1_Inst_16__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_8_Q294_inst1_Inst_16__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_8_Q294_inst1_Inst_16__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Out[16]) );
  NAND2_X1 Inst_SKINNY_Sbox_8_Q294_inst1_Inst_16__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_8_InAff_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_8_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst1_Inst_16__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst1_Inst_16__CF_Inst_U1 ( .A(FRESH[10]), 
        .B(FRESH[11]), .Z(Inst_SKINNY_Sbox_8_Q294_inst1_Inst_16__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst1_Inst_17__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_8_Q294_inst1_Inst_17__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_8_Q294_inst1_Inst_17__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Out[17]) );
  NAND2_X1 Inst_SKINNY_Sbox_8_Q294_inst1_Inst_17__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_8_InAff_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_8_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst1_Inst_17__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst1_Inst_17__CF_Inst_U1 ( .A(FRESH[11]), 
        .B(FRESH[6]), .Z(Inst_SKINNY_Sbox_8_Q294_inst1_Inst_17__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst1_InstXOR_0__Compression1_U2 ( .A(
        Inst_SKINNY_Sbox_8_Q294_inst1_InstXOR_0__Compression1_n3), .B(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Reg[2]), .ZN(
        Inst_SKINNY_Sbox_8_M2_out1[3]) );
  XNOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst1_InstXOR_0__Compression1_U1 ( .A(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Reg[0]), .B(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Reg[1]), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst1_InstXOR_0__Compression1_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst1_InstXOR_0__Compression2_U2 ( .A(
        Inst_SKINNY_Sbox_8_Q294_inst1_InstXOR_0__Compression2_n3), .B(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Reg[5]), .ZN(
        Inst_SKINNY_Sbox_8_M2_out2[3]) );
  XNOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst1_InstXOR_0__Compression2_U1 ( .A(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Reg[3]), .B(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Reg[4]), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst1_InstXOR_0__Compression2_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst1_InstXOR_0__Compression3_U2 ( .A(
        Inst_SKINNY_Sbox_8_Q294_inst1_InstXOR_0__Compression3_n3), .B(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Reg[8]), .ZN(
        Inst_SKINNY_Sbox_8_M2_out3[3]) );
  XNOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst1_InstXOR_0__Compression3_U1 ( .A(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Reg[6]), .B(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Reg[7]), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst1_InstXOR_0__Compression3_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst1_InstXOR_1__Compression1_U2 ( .A(
        Inst_SKINNY_Sbox_8_Q294_inst1_InstXOR_1__Compression1_n3), .B(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Reg[11]), .ZN(
        Inst_SKINNY_Sbox_8_M2_out1[2]) );
  XNOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst1_InstXOR_1__Compression1_U1 ( .A(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Reg[9]), .B(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Reg[10]), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst1_InstXOR_1__Compression1_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst1_InstXOR_1__Compression2_U2 ( .A(
        Inst_SKINNY_Sbox_8_Q294_inst1_InstXOR_1__Compression2_n3), .B(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Reg[14]), .ZN(
        Inst_SKINNY_Sbox_8_M2_out2[2]) );
  XNOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst1_InstXOR_1__Compression2_U1 ( .A(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Reg[12]), .B(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Reg[13]), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst1_InstXOR_1__Compression2_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst1_InstXOR_1__Compression3_U2 ( .A(
        Inst_SKINNY_Sbox_8_Q294_inst1_InstXOR_1__Compression3_n3), .B(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Reg[17]), .ZN(
        Inst_SKINNY_Sbox_8_M2_out3[2]) );
  XNOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst1_InstXOR_1__Compression3_U1 ( .A(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Reg[15]), .B(
        Inst_SKINNY_Sbox_8_Q294_inst1_CF_Reg[16]), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst1_InstXOR_1__Compression3_n3) );
  DFF_X1 Inst_SKINNY_Sbox_8_Q294_inst2_CF_Reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Out[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_Q294_inst2_CF_Reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Out[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_Q294_inst2_CF_Reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Out[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_Q294_inst2_CF_Reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Out[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_Q294_inst2_CF_Reg_reg_4_ ( .D(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Out[4]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Reg[4]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_Q294_inst2_CF_Reg_reg_5_ ( .D(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Out[5]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Reg[5]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_Q294_inst2_CF_Reg_reg_6_ ( .D(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Out[6]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Reg[6]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_Q294_inst2_CF_Reg_reg_7_ ( .D(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Out[7]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Reg[7]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_Q294_inst2_CF_Reg_reg_8_ ( .D(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Out[8]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Reg[8]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_Q294_inst2_CF_Reg_reg_9_ ( .D(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Out[9]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Reg[9]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_Q294_inst2_CF_Reg_reg_10_ ( .D(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Out[10]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Reg[10]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_Q294_inst2_CF_Reg_reg_11_ ( .D(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Out[11]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Reg[11]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_Q294_inst2_CF_Reg_reg_12_ ( .D(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Out[12]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Reg[12]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_Q294_inst2_CF_Reg_reg_13_ ( .D(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Out[13]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Reg[13]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_Q294_inst2_CF_Reg_reg_14_ ( .D(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Out[14]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Reg[14]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_Q294_inst2_CF_Reg_reg_15_ ( .D(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Out[15]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Reg[15]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_Q294_inst2_CF_Reg_reg_16_ ( .D(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Out[16]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Reg[16]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_Q294_inst2_CF_Reg_reg_17_ ( .D(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Out[17]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Reg[17]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_Q294_inst2_dreg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_8_M2_out2_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_Q294_2_out1[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_Q294_inst2_dreg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_8_M2_out3_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_OutAff_out2[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_Q294_inst2_dreg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_8_M2_out1_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_OutAff_out3[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_Q294_inst2_creg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_8_M2_out2_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_Q294_2_out1[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_Q294_inst2_creg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_8_M2_out3_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_OutAff_out2[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_8_Q294_inst2_creg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_8_M2_out1_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_8_OutAff_out3[2]), .QN() );
  XNOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst2_Inst_0__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_8_Q294_inst2_Inst_0__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_8_M2_out2_reg[0]), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Out[0]) );
  NAND2_X1 Inst_SKINNY_Sbox_8_Q294_inst2_Inst_0__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_8_M2_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_8_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst2_Inst_0__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst2_Inst_1__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_8_Q294_inst2_Inst_1__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_8_Q294_inst2_Inst_1__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Out[1]) );
  NAND2_X1 Inst_SKINNY_Sbox_8_Q294_inst2_Inst_1__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_8_M2_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_8_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst2_Inst_1__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst2_Inst_1__CF_Inst_U1 ( .A(FRESH[12]), 
        .B(FRESH[13]), .Z(Inst_SKINNY_Sbox_8_Q294_inst2_Inst_1__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst2_Inst_2__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_8_Q294_inst2_Inst_2__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_8_Q294_inst2_Inst_2__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Out[2]) );
  NAND2_X1 Inst_SKINNY_Sbox_8_Q294_inst2_Inst_2__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_8_M2_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_8_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst2_Inst_2__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst2_Inst_2__CF_Inst_U1 ( .A(FRESH[13]), 
        .B(FRESH[14]), .Z(Inst_SKINNY_Sbox_8_Q294_inst2_Inst_2__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst2_Inst_3__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_8_Q294_inst2_Inst_3__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_8_M2_out3_reg[0]), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Out[3]) );
  NAND2_X1 Inst_SKINNY_Sbox_8_Q294_inst2_Inst_3__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_8_M2_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_8_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst2_Inst_3__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst2_Inst_4__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_8_Q294_inst2_Inst_4__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_8_Q294_inst2_Inst_4__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Out[4]) );
  NAND2_X1 Inst_SKINNY_Sbox_8_Q294_inst2_Inst_4__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_8_M2_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_8_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst2_Inst_4__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst2_Inst_4__CF_Inst_U1 ( .A(FRESH[14]), 
        .B(FRESH[15]), .Z(Inst_SKINNY_Sbox_8_Q294_inst2_Inst_4__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst2_Inst_5__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_8_Q294_inst2_Inst_5__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_8_Q294_inst2_Inst_5__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Out[5]) );
  NAND2_X1 Inst_SKINNY_Sbox_8_Q294_inst2_Inst_5__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_8_M2_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_8_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst2_Inst_5__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst2_Inst_5__CF_Inst_U1 ( .A(FRESH[15]), 
        .B(FRESH[16]), .Z(Inst_SKINNY_Sbox_8_Q294_inst2_Inst_5__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst2_Inst_6__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_8_Q294_inst2_Inst_6__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_8_M2_out1_reg[0]), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Out[6]) );
  NAND2_X1 Inst_SKINNY_Sbox_8_Q294_inst2_Inst_6__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_8_M2_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_8_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst2_Inst_6__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst2_Inst_7__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_8_Q294_inst2_Inst_7__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_8_Q294_inst2_Inst_7__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Out[7]) );
  NAND2_X1 Inst_SKINNY_Sbox_8_Q294_inst2_Inst_7__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_8_M2_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_8_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst2_Inst_7__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst2_Inst_7__CF_Inst_U1 ( .A(FRESH[16]), 
        .B(FRESH[17]), .Z(Inst_SKINNY_Sbox_8_Q294_inst2_Inst_7__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst2_Inst_8__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_8_Q294_inst2_Inst_8__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_8_Q294_inst2_Inst_8__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Out[8]) );
  NAND2_X1 Inst_SKINNY_Sbox_8_Q294_inst2_Inst_8__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_8_M2_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_8_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst2_Inst_8__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst2_Inst_8__CF_Inst_U1 ( .A(FRESH[17]), 
        .B(FRESH[12]), .Z(Inst_SKINNY_Sbox_8_Q294_inst2_Inst_8__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst2_Inst_9__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_8_Q294_inst2_Inst_9__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_8_M2_out2_reg[1]), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Out[9]) );
  NAND2_X1 Inst_SKINNY_Sbox_8_Q294_inst2_Inst_9__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_8_M2_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_8_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst2_Inst_9__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst2_Inst_10__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_8_Q294_inst2_Inst_10__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_8_Q294_inst2_Inst_10__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Out[10]) );
  NAND2_X1 Inst_SKINNY_Sbox_8_Q294_inst2_Inst_10__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_8_M2_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_8_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst2_Inst_10__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst2_Inst_10__CF_Inst_U1 ( .A(FRESH[18]), 
        .B(FRESH[19]), .Z(Inst_SKINNY_Sbox_8_Q294_inst2_Inst_10__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst2_Inst_11__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_8_Q294_inst2_Inst_11__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_8_Q294_inst2_Inst_11__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Out[11]) );
  NAND2_X1 Inst_SKINNY_Sbox_8_Q294_inst2_Inst_11__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_8_M2_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_8_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst2_Inst_11__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst2_Inst_11__CF_Inst_U1 ( .A(FRESH[19]), 
        .B(FRESH[20]), .Z(Inst_SKINNY_Sbox_8_Q294_inst2_Inst_11__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst2_Inst_12__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_8_Q294_inst2_Inst_12__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_8_M2_out3_reg[1]), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Out[12]) );
  NAND2_X1 Inst_SKINNY_Sbox_8_Q294_inst2_Inst_12__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_8_M2_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_8_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst2_Inst_12__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst2_Inst_13__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_8_Q294_inst2_Inst_13__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_8_Q294_inst2_Inst_13__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Out[13]) );
  NAND2_X1 Inst_SKINNY_Sbox_8_Q294_inst2_Inst_13__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_8_M2_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_8_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst2_Inst_13__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst2_Inst_13__CF_Inst_U1 ( .A(FRESH[20]), 
        .B(FRESH[21]), .Z(Inst_SKINNY_Sbox_8_Q294_inst2_Inst_13__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst2_Inst_14__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_8_Q294_inst2_Inst_14__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_8_Q294_inst2_Inst_14__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Out[14]) );
  NAND2_X1 Inst_SKINNY_Sbox_8_Q294_inst2_Inst_14__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_8_M2_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_8_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst2_Inst_14__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst2_Inst_14__CF_Inst_U1 ( .A(FRESH[21]), 
        .B(FRESH[22]), .Z(Inst_SKINNY_Sbox_8_Q294_inst2_Inst_14__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst2_Inst_15__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_8_Q294_inst2_Inst_15__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_8_M2_out1_reg[1]), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Out[15]) );
  NAND2_X1 Inst_SKINNY_Sbox_8_Q294_inst2_Inst_15__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_8_M2_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_8_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst2_Inst_15__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst2_Inst_16__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_8_Q294_inst2_Inst_16__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_8_Q294_inst2_Inst_16__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Out[16]) );
  NAND2_X1 Inst_SKINNY_Sbox_8_Q294_inst2_Inst_16__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_8_M2_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_8_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst2_Inst_16__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst2_Inst_16__CF_Inst_U1 ( .A(FRESH[22]), 
        .B(FRESH[23]), .Z(Inst_SKINNY_Sbox_8_Q294_inst2_Inst_16__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst2_Inst_17__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_8_Q294_inst2_Inst_17__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_8_Q294_inst2_Inst_17__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Out[17]) );
  NAND2_X1 Inst_SKINNY_Sbox_8_Q294_inst2_Inst_17__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_8_M2_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_8_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst2_Inst_17__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst2_Inst_17__CF_Inst_U1 ( .A(FRESH[23]), 
        .B(FRESH[18]), .Z(Inst_SKINNY_Sbox_8_Q294_inst2_Inst_17__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst2_InstXOR_0__Compression1_U2 ( .A(
        Inst_SKINNY_Sbox_8_Q294_inst2_InstXOR_0__Compression1_n3), .B(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Reg[2]), .ZN(
        Inst_SKINNY_Sbox_8_Q294_2_out1[0]) );
  XNOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst2_InstXOR_0__Compression1_U1 ( .A(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Reg[0]), .B(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Reg[1]), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst2_InstXOR_0__Compression1_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst2_InstXOR_0__Compression2_U2 ( .A(
        Inst_SKINNY_Sbox_8_Q294_inst2_InstXOR_0__Compression2_n3), .B(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Reg[5]), .ZN(
        Inst_SKINNY_Sbox_8_OutAff_out2[1]) );
  XNOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst2_InstXOR_0__Compression2_U1 ( .A(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Reg[3]), .B(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Reg[4]), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst2_InstXOR_0__Compression2_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst2_InstXOR_0__Compression3_U2 ( .A(
        Inst_SKINNY_Sbox_8_Q294_inst2_InstXOR_0__Compression3_n3), .B(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Reg[8]), .ZN(
        Inst_SKINNY_Sbox_8_OutAff_out3[1]) );
  XNOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst2_InstXOR_0__Compression3_U1 ( .A(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Reg[6]), .B(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Reg[7]), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst2_InstXOR_0__Compression3_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst2_InstXOR_1__Compression1_U2 ( .A(
        Inst_SKINNY_Sbox_8_Q294_inst2_InstXOR_1__Compression1_n3), .B(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Reg[11]), .ZN(
        Inst_SKINNY_Sbox_8_Q294_2_out1[1]) );
  XNOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst2_InstXOR_1__Compression1_U1 ( .A(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Reg[9]), .B(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Reg[10]), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst2_InstXOR_1__Compression1_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst2_InstXOR_1__Compression2_U2 ( .A(
        Inst_SKINNY_Sbox_8_Q294_inst2_InstXOR_1__Compression2_n3), .B(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Reg[14]), .ZN(
        Inst_SKINNY_Sbox_8_OutAff_out2[0]) );
  XNOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst2_InstXOR_1__Compression2_U1 ( .A(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Reg[12]), .B(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Reg[13]), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst2_InstXOR_1__Compression2_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst2_InstXOR_1__Compression3_U2 ( .A(
        Inst_SKINNY_Sbox_8_Q294_inst2_InstXOR_1__Compression3_n3), .B(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Reg[17]), .ZN(
        Inst_SKINNY_Sbox_8_OutAff_out3[0]) );
  XNOR2_X1 Inst_SKINNY_Sbox_8_Q294_inst2_InstXOR_1__Compression3_U1 ( .A(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Reg[15]), .B(
        Inst_SKINNY_Sbox_8_Q294_inst2_CF_Reg[16]), .ZN(
        Inst_SKINNY_Sbox_8_Q294_inst2_InstXOR_1__Compression3_n3) );
  INV_X1 Inst_SKINNY_Sbox_8_OutputAffine_U4 ( .A(
        Inst_SKINNY_Sbox_8_Q294_2_out1[3]), .ZN(
        Inst_SKINNY_Sbox_8_OutAff_out1[3]) );
  INV_X1 Inst_SKINNY_Sbox_8_OutputAffine_U3 ( .A(
        Inst_SKINNY_Sbox_8_Q294_2_out1[2]), .ZN(
        Inst_SKINNY_Sbox_8_OutAff_out1[2]) );
  INV_X1 Inst_SKINNY_Sbox_8_OutputAffine_U2 ( .A(
        Inst_SKINNY_Sbox_8_Q294_2_out1[1]), .ZN(
        Inst_SKINNY_Sbox_8_OutAff_out1[0]) );
  INV_X1 Inst_SKINNY_Sbox_8_OutputAffine_U1 ( .A(
        Inst_SKINNY_Sbox_8_Q294_2_out1[0]), .ZN(
        Inst_SKINNY_Sbox_8_OutAff_out1[1]) );
  XNOR2_X1 Inst_SKINNY_Sbox_9_U18 ( .A(Inst_SKINNY_Sbox_9_n12), .B(FRESH[39]), 
        .ZN(SUB_OUT3[39]) );
  XNOR2_X1 Inst_SKINNY_Sbox_9_U17 ( .A(FRESH[35]), .B(
        Inst_SKINNY_Sbox_9_OutAff_out3[3]), .ZN(Inst_SKINNY_Sbox_9_n12) );
  XNOR2_X1 Inst_SKINNY_Sbox_9_U16 ( .A(Inst_SKINNY_Sbox_9_n11), .B(FRESH[38]), 
        .ZN(SUB_OUT3[38]) );
  XNOR2_X1 Inst_SKINNY_Sbox_9_U15 ( .A(FRESH[34]), .B(
        Inst_SKINNY_Sbox_9_OutAff_out3[2]), .ZN(Inst_SKINNY_Sbox_9_n11) );
  XNOR2_X1 Inst_SKINNY_Sbox_9_U14 ( .A(Inst_SKINNY_Sbox_9_n10), .B(FRESH[37]), 
        .ZN(SUB_OUT3[37]) );
  XNOR2_X1 Inst_SKINNY_Sbox_9_U13 ( .A(FRESH[33]), .B(
        Inst_SKINNY_Sbox_9_OutAff_out3[1]), .ZN(Inst_SKINNY_Sbox_9_n10) );
  XNOR2_X1 Inst_SKINNY_Sbox_9_U12 ( .A(Inst_SKINNY_Sbox_9_n9), .B(FRESH[36]), 
        .ZN(SUB_OUT3[36]) );
  XNOR2_X1 Inst_SKINNY_Sbox_9_U11 ( .A(FRESH[32]), .B(
        Inst_SKINNY_Sbox_9_OutAff_out3[0]), .ZN(Inst_SKINNY_Sbox_9_n9) );
  XOR2_X1 Inst_SKINNY_Sbox_9_U10 ( .A(FRESH[39]), .B(
        Inst_SKINNY_Sbox_9_OutAff_out2[3]), .Z(SUB_OUT2[39]) );
  XOR2_X1 Inst_SKINNY_Sbox_9_U9 ( .A(FRESH[38]), .B(
        Inst_SKINNY_Sbox_9_OutAff_out2[2]), .Z(SUB_OUT2[38]) );
  XOR2_X1 Inst_SKINNY_Sbox_9_U8 ( .A(FRESH[37]), .B(
        Inst_SKINNY_Sbox_9_OutAff_out2[1]), .Z(SUB_OUT2[37]) );
  XOR2_X1 Inst_SKINNY_Sbox_9_U7 ( .A(FRESH[36]), .B(
        Inst_SKINNY_Sbox_9_OutAff_out2[0]), .Z(SUB_OUT2[36]) );
  XOR2_X1 Inst_SKINNY_Sbox_9_U6 ( .A(FRESH[35]), .B(
        Inst_SKINNY_Sbox_9_OutAff_out1[3]), .Z(SUB_OUT1[39]) );
  XOR2_X1 Inst_SKINNY_Sbox_9_U5 ( .A(FRESH[34]), .B(
        Inst_SKINNY_Sbox_9_OutAff_out1[2]), .Z(SUB_OUT1[38]) );
  XOR2_X1 Inst_SKINNY_Sbox_9_U4 ( .A(FRESH[33]), .B(
        Inst_SKINNY_Sbox_9_OutAff_out1[1]), .Z(SUB_OUT1[37]) );
  XOR2_X1 Inst_SKINNY_Sbox_9_U3 ( .A(FRESH[32]), .B(
        Inst_SKINNY_Sbox_9_OutAff_out1[0]), .Z(SUB_OUT1[36]) );
  DFF_X1 Inst_SKINNY_Sbox_9_M2_out3_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_9_M2_out3[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_M2_out3_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_M2_out3_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_9_M2_out3[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_M2_out3_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_M2_out3_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_9_M2_out3[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_M2_out3_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_M2_out3_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_9_M2_out3[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_M2_out3_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_M2_out2_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_9_M2_out2[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_M2_out2_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_M2_out2_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_9_M2_out2[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_M2_out2_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_M2_out2_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_9_M2_out2[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_M2_out2_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_M2_out2_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_9_M2_out2[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_M2_out2_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_M2_out1_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_9_M2_out1[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_M2_out1_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_M2_out1_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_9_M2_out1[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_M2_out1_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_M2_out1_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_9_M2_out1[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_M2_out1_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_M2_out1_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_9_M2_out1[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_M2_out1_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_InAff_out3_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_9_InAff_out3[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_InAff_out3_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_InAff_out3_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_9_InAff_out3[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_InAff_out3_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_InAff_out3_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_9_InAff_out3[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_InAff_out3_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_InAff_out3_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_9_InAff_out3[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_InAff_out3_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_InAff_out2_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_9_InAff_out2[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_InAff_out2_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_InAff_out2_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_9_InAff_out2[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_InAff_out2_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_InAff_out2_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_9_InAff_out2[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_InAff_out2_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_InAff_out2_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_9_InAff_out2[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_InAff_out2_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_InAff_out1_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_9_InAff_out1[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_InAff_out1_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_InAff_out1_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_9_InAff_out1[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_InAff_out1_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_InAff_out1_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_9_InAff_out1[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_InAff_out1_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_InAff_out1_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_9_InAff_out1[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_InAff_out1_reg[3]), .QN() );
  INV_X1 Inst_SKINNY_Sbox_9_InputAffine_U4 ( .A(SUB_IN1[39]), .ZN(
        Inst_SKINNY_Sbox_9_InAff_out1[1]) );
  INV_X1 Inst_SKINNY_Sbox_9_InputAffine_U3 ( .A(SUB_IN1[38]), .ZN(
        Inst_SKINNY_Sbox_9_InAff_out1[3]) );
  INV_X1 Inst_SKINNY_Sbox_9_InputAffine_U2 ( .A(SUB_IN1[37]), .ZN(
        Inst_SKINNY_Sbox_9_InAff_out1[2]) );
  INV_X1 Inst_SKINNY_Sbox_9_InputAffine_U1 ( .A(SUB_IN1[36]), .ZN(
        Inst_SKINNY_Sbox_9_InAff_out1[0]) );
  DFF_X1 Inst_SKINNY_Sbox_9_Q294_inst1_CF_Reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Out[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_Q294_inst1_CF_Reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Out[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_Q294_inst1_CF_Reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Out[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_Q294_inst1_CF_Reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Out[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_Q294_inst1_CF_Reg_reg_4_ ( .D(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Out[4]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Reg[4]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_Q294_inst1_CF_Reg_reg_5_ ( .D(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Out[5]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Reg[5]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_Q294_inst1_CF_Reg_reg_6_ ( .D(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Out[6]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Reg[6]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_Q294_inst1_CF_Reg_reg_7_ ( .D(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Out[7]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Reg[7]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_Q294_inst1_CF_Reg_reg_8_ ( .D(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Out[8]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Reg[8]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_Q294_inst1_CF_Reg_reg_9_ ( .D(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Out[9]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Reg[9]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_Q294_inst1_CF_Reg_reg_10_ ( .D(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Out[10]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Reg[10]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_Q294_inst1_CF_Reg_reg_11_ ( .D(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Out[11]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Reg[11]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_Q294_inst1_CF_Reg_reg_12_ ( .D(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Out[12]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Reg[12]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_Q294_inst1_CF_Reg_reg_13_ ( .D(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Out[13]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Reg[13]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_Q294_inst1_CF_Reg_reg_14_ ( .D(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Out[14]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Reg[14]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_Q294_inst1_CF_Reg_reg_15_ ( .D(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Out[15]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Reg[15]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_Q294_inst1_CF_Reg_reg_16_ ( .D(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Out[16]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Reg[16]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_Q294_inst1_CF_Reg_reg_17_ ( .D(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Out[17]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Reg[17]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_Q294_inst1_dreg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_9_InAff_out2_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_M2_out1[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_Q294_inst1_dreg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_9_InAff_out3_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_M2_out2[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_Q294_inst1_dreg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_9_InAff_out1_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_M2_out3[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_Q294_inst1_creg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_9_InAff_out2_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_M2_out1[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_Q294_inst1_creg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_9_InAff_out3_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_M2_out2[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_Q294_inst1_creg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_9_InAff_out1_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_M2_out3[1]), .QN() );
  XNOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst1_Inst_0__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_9_Q294_inst1_Inst_0__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_9_InAff_out2_reg[0]), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Out[0]) );
  NAND2_X1 Inst_SKINNY_Sbox_9_Q294_inst1_Inst_0__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_9_InAff_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_9_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst1_Inst_0__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst1_Inst_1__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_9_Q294_inst1_Inst_1__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_9_Q294_inst1_Inst_1__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Out[1]) );
  NAND2_X1 Inst_SKINNY_Sbox_9_Q294_inst1_Inst_1__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_9_InAff_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_9_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst1_Inst_1__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst1_Inst_1__CF_Inst_U1 ( .A(FRESH[0]), .B(
        FRESH[1]), .Z(Inst_SKINNY_Sbox_9_Q294_inst1_Inst_1__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst1_Inst_2__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_9_Q294_inst1_Inst_2__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_9_Q294_inst1_Inst_2__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Out[2]) );
  NAND2_X1 Inst_SKINNY_Sbox_9_Q294_inst1_Inst_2__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_9_InAff_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_9_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst1_Inst_2__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst1_Inst_2__CF_Inst_U1 ( .A(FRESH[1]), .B(
        FRESH[2]), .Z(Inst_SKINNY_Sbox_9_Q294_inst1_Inst_2__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst1_Inst_3__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_9_Q294_inst1_Inst_3__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_9_InAff_out3_reg[0]), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Out[3]) );
  NAND2_X1 Inst_SKINNY_Sbox_9_Q294_inst1_Inst_3__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_9_InAff_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_9_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst1_Inst_3__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst1_Inst_4__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_9_Q294_inst1_Inst_4__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_9_Q294_inst1_Inst_4__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Out[4]) );
  NAND2_X1 Inst_SKINNY_Sbox_9_Q294_inst1_Inst_4__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_9_InAff_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_9_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst1_Inst_4__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst1_Inst_4__CF_Inst_U1 ( .A(FRESH[2]), .B(
        FRESH[3]), .Z(Inst_SKINNY_Sbox_9_Q294_inst1_Inst_4__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst1_Inst_5__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_9_Q294_inst1_Inst_5__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_9_Q294_inst1_Inst_5__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Out[5]) );
  NAND2_X1 Inst_SKINNY_Sbox_9_Q294_inst1_Inst_5__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_9_InAff_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_9_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst1_Inst_5__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst1_Inst_5__CF_Inst_U1 ( .A(FRESH[3]), .B(
        FRESH[4]), .Z(Inst_SKINNY_Sbox_9_Q294_inst1_Inst_5__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst1_Inst_6__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_9_Q294_inst1_Inst_6__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_9_InAff_out1_reg[0]), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Out[6]) );
  NAND2_X1 Inst_SKINNY_Sbox_9_Q294_inst1_Inst_6__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_9_InAff_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_9_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst1_Inst_6__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst1_Inst_7__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_9_Q294_inst1_Inst_7__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_9_Q294_inst1_Inst_7__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Out[7]) );
  NAND2_X1 Inst_SKINNY_Sbox_9_Q294_inst1_Inst_7__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_9_InAff_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_9_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst1_Inst_7__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst1_Inst_7__CF_Inst_U1 ( .A(FRESH[4]), .B(
        FRESH[5]), .Z(Inst_SKINNY_Sbox_9_Q294_inst1_Inst_7__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst1_Inst_8__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_9_Q294_inst1_Inst_8__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_9_Q294_inst1_Inst_8__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Out[8]) );
  NAND2_X1 Inst_SKINNY_Sbox_9_Q294_inst1_Inst_8__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_9_InAff_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_9_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst1_Inst_8__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst1_Inst_8__CF_Inst_U1 ( .A(FRESH[5]), .B(
        FRESH[0]), .Z(Inst_SKINNY_Sbox_9_Q294_inst1_Inst_8__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst1_Inst_9__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_9_Q294_inst1_Inst_9__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_9_InAff_out2_reg[1]), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Out[9]) );
  NAND2_X1 Inst_SKINNY_Sbox_9_Q294_inst1_Inst_9__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_9_InAff_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_9_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst1_Inst_9__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst1_Inst_10__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_9_Q294_inst1_Inst_10__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_9_Q294_inst1_Inst_10__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Out[10]) );
  NAND2_X1 Inst_SKINNY_Sbox_9_Q294_inst1_Inst_10__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_9_InAff_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_9_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst1_Inst_10__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst1_Inst_10__CF_Inst_U1 ( .A(FRESH[6]), 
        .B(FRESH[7]), .Z(Inst_SKINNY_Sbox_9_Q294_inst1_Inst_10__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst1_Inst_11__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_9_Q294_inst1_Inst_11__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_9_Q294_inst1_Inst_11__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Out[11]) );
  NAND2_X1 Inst_SKINNY_Sbox_9_Q294_inst1_Inst_11__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_9_InAff_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_9_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst1_Inst_11__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst1_Inst_11__CF_Inst_U1 ( .A(FRESH[7]), 
        .B(FRESH[8]), .Z(Inst_SKINNY_Sbox_9_Q294_inst1_Inst_11__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst1_Inst_12__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_9_Q294_inst1_Inst_12__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_9_InAff_out3_reg[1]), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Out[12]) );
  NAND2_X1 Inst_SKINNY_Sbox_9_Q294_inst1_Inst_12__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_9_InAff_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_9_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst1_Inst_12__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst1_Inst_13__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_9_Q294_inst1_Inst_13__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_9_Q294_inst1_Inst_13__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Out[13]) );
  NAND2_X1 Inst_SKINNY_Sbox_9_Q294_inst1_Inst_13__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_9_InAff_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_9_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst1_Inst_13__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst1_Inst_13__CF_Inst_U1 ( .A(FRESH[8]), 
        .B(FRESH[9]), .Z(Inst_SKINNY_Sbox_9_Q294_inst1_Inst_13__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst1_Inst_14__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_9_Q294_inst1_Inst_14__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_9_Q294_inst1_Inst_14__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Out[14]) );
  NAND2_X1 Inst_SKINNY_Sbox_9_Q294_inst1_Inst_14__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_9_InAff_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_9_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst1_Inst_14__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst1_Inst_14__CF_Inst_U1 ( .A(FRESH[9]), 
        .B(FRESH[10]), .Z(Inst_SKINNY_Sbox_9_Q294_inst1_Inst_14__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst1_Inst_15__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_9_Q294_inst1_Inst_15__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_9_InAff_out1_reg[1]), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Out[15]) );
  NAND2_X1 Inst_SKINNY_Sbox_9_Q294_inst1_Inst_15__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_9_InAff_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_9_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst1_Inst_15__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst1_Inst_16__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_9_Q294_inst1_Inst_16__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_9_Q294_inst1_Inst_16__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Out[16]) );
  NAND2_X1 Inst_SKINNY_Sbox_9_Q294_inst1_Inst_16__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_9_InAff_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_9_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst1_Inst_16__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst1_Inst_16__CF_Inst_U1 ( .A(FRESH[10]), 
        .B(FRESH[11]), .Z(Inst_SKINNY_Sbox_9_Q294_inst1_Inst_16__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst1_Inst_17__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_9_Q294_inst1_Inst_17__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_9_Q294_inst1_Inst_17__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Out[17]) );
  NAND2_X1 Inst_SKINNY_Sbox_9_Q294_inst1_Inst_17__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_9_InAff_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_9_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst1_Inst_17__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst1_Inst_17__CF_Inst_U1 ( .A(FRESH[11]), 
        .B(FRESH[6]), .Z(Inst_SKINNY_Sbox_9_Q294_inst1_Inst_17__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst1_InstXOR_0__Compression1_U2 ( .A(
        Inst_SKINNY_Sbox_9_Q294_inst1_InstXOR_0__Compression1_n3), .B(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Reg[2]), .ZN(
        Inst_SKINNY_Sbox_9_M2_out1[3]) );
  XNOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst1_InstXOR_0__Compression1_U1 ( .A(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Reg[0]), .B(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Reg[1]), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst1_InstXOR_0__Compression1_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst1_InstXOR_0__Compression2_U2 ( .A(
        Inst_SKINNY_Sbox_9_Q294_inst1_InstXOR_0__Compression2_n3), .B(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Reg[5]), .ZN(
        Inst_SKINNY_Sbox_9_M2_out2[3]) );
  XNOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst1_InstXOR_0__Compression2_U1 ( .A(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Reg[3]), .B(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Reg[4]), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst1_InstXOR_0__Compression2_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst1_InstXOR_0__Compression3_U2 ( .A(
        Inst_SKINNY_Sbox_9_Q294_inst1_InstXOR_0__Compression3_n3), .B(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Reg[8]), .ZN(
        Inst_SKINNY_Sbox_9_M2_out3[3]) );
  XNOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst1_InstXOR_0__Compression3_U1 ( .A(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Reg[6]), .B(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Reg[7]), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst1_InstXOR_0__Compression3_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst1_InstXOR_1__Compression1_U2 ( .A(
        Inst_SKINNY_Sbox_9_Q294_inst1_InstXOR_1__Compression1_n3), .B(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Reg[11]), .ZN(
        Inst_SKINNY_Sbox_9_M2_out1[2]) );
  XNOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst1_InstXOR_1__Compression1_U1 ( .A(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Reg[9]), .B(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Reg[10]), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst1_InstXOR_1__Compression1_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst1_InstXOR_1__Compression2_U2 ( .A(
        Inst_SKINNY_Sbox_9_Q294_inst1_InstXOR_1__Compression2_n3), .B(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Reg[14]), .ZN(
        Inst_SKINNY_Sbox_9_M2_out2[2]) );
  XNOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst1_InstXOR_1__Compression2_U1 ( .A(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Reg[12]), .B(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Reg[13]), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst1_InstXOR_1__Compression2_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst1_InstXOR_1__Compression3_U2 ( .A(
        Inst_SKINNY_Sbox_9_Q294_inst1_InstXOR_1__Compression3_n3), .B(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Reg[17]), .ZN(
        Inst_SKINNY_Sbox_9_M2_out3[2]) );
  XNOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst1_InstXOR_1__Compression3_U1 ( .A(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Reg[15]), .B(
        Inst_SKINNY_Sbox_9_Q294_inst1_CF_Reg[16]), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst1_InstXOR_1__Compression3_n3) );
  DFF_X1 Inst_SKINNY_Sbox_9_Q294_inst2_CF_Reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Out[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_Q294_inst2_CF_Reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Out[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_Q294_inst2_CF_Reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Out[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_Q294_inst2_CF_Reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Out[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_Q294_inst2_CF_Reg_reg_4_ ( .D(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Out[4]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Reg[4]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_Q294_inst2_CF_Reg_reg_5_ ( .D(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Out[5]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Reg[5]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_Q294_inst2_CF_Reg_reg_6_ ( .D(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Out[6]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Reg[6]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_Q294_inst2_CF_Reg_reg_7_ ( .D(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Out[7]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Reg[7]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_Q294_inst2_CF_Reg_reg_8_ ( .D(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Out[8]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Reg[8]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_Q294_inst2_CF_Reg_reg_9_ ( .D(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Out[9]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Reg[9]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_Q294_inst2_CF_Reg_reg_10_ ( .D(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Out[10]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Reg[10]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_Q294_inst2_CF_Reg_reg_11_ ( .D(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Out[11]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Reg[11]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_Q294_inst2_CF_Reg_reg_12_ ( .D(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Out[12]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Reg[12]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_Q294_inst2_CF_Reg_reg_13_ ( .D(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Out[13]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Reg[13]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_Q294_inst2_CF_Reg_reg_14_ ( .D(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Out[14]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Reg[14]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_Q294_inst2_CF_Reg_reg_15_ ( .D(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Out[15]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Reg[15]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_Q294_inst2_CF_Reg_reg_16_ ( .D(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Out[16]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Reg[16]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_Q294_inst2_CF_Reg_reg_17_ ( .D(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Out[17]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Reg[17]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_Q294_inst2_dreg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_9_M2_out2_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_Q294_2_out1[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_Q294_inst2_dreg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_9_M2_out3_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_OutAff_out2[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_Q294_inst2_dreg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_9_M2_out1_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_OutAff_out3[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_Q294_inst2_creg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_9_M2_out2_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_Q294_2_out1[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_Q294_inst2_creg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_9_M2_out3_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_OutAff_out2[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_9_Q294_inst2_creg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_9_M2_out1_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_9_OutAff_out3[2]), .QN() );
  XNOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst2_Inst_0__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_9_Q294_inst2_Inst_0__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_9_M2_out2_reg[0]), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Out[0]) );
  NAND2_X1 Inst_SKINNY_Sbox_9_Q294_inst2_Inst_0__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_9_M2_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_9_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst2_Inst_0__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst2_Inst_1__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_9_Q294_inst2_Inst_1__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_9_Q294_inst2_Inst_1__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Out[1]) );
  NAND2_X1 Inst_SKINNY_Sbox_9_Q294_inst2_Inst_1__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_9_M2_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_9_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst2_Inst_1__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst2_Inst_1__CF_Inst_U1 ( .A(FRESH[12]), 
        .B(FRESH[13]), .Z(Inst_SKINNY_Sbox_9_Q294_inst2_Inst_1__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst2_Inst_2__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_9_Q294_inst2_Inst_2__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_9_Q294_inst2_Inst_2__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Out[2]) );
  NAND2_X1 Inst_SKINNY_Sbox_9_Q294_inst2_Inst_2__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_9_M2_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_9_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst2_Inst_2__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst2_Inst_2__CF_Inst_U1 ( .A(FRESH[13]), 
        .B(FRESH[14]), .Z(Inst_SKINNY_Sbox_9_Q294_inst2_Inst_2__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst2_Inst_3__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_9_Q294_inst2_Inst_3__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_9_M2_out3_reg[0]), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Out[3]) );
  NAND2_X1 Inst_SKINNY_Sbox_9_Q294_inst2_Inst_3__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_9_M2_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_9_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst2_Inst_3__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst2_Inst_4__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_9_Q294_inst2_Inst_4__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_9_Q294_inst2_Inst_4__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Out[4]) );
  NAND2_X1 Inst_SKINNY_Sbox_9_Q294_inst2_Inst_4__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_9_M2_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_9_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst2_Inst_4__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst2_Inst_4__CF_Inst_U1 ( .A(FRESH[14]), 
        .B(FRESH[15]), .Z(Inst_SKINNY_Sbox_9_Q294_inst2_Inst_4__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst2_Inst_5__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_9_Q294_inst2_Inst_5__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_9_Q294_inst2_Inst_5__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Out[5]) );
  NAND2_X1 Inst_SKINNY_Sbox_9_Q294_inst2_Inst_5__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_9_M2_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_9_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst2_Inst_5__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst2_Inst_5__CF_Inst_U1 ( .A(FRESH[15]), 
        .B(FRESH[16]), .Z(Inst_SKINNY_Sbox_9_Q294_inst2_Inst_5__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst2_Inst_6__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_9_Q294_inst2_Inst_6__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_9_M2_out1_reg[0]), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Out[6]) );
  NAND2_X1 Inst_SKINNY_Sbox_9_Q294_inst2_Inst_6__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_9_M2_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_9_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst2_Inst_6__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst2_Inst_7__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_9_Q294_inst2_Inst_7__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_9_Q294_inst2_Inst_7__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Out[7]) );
  NAND2_X1 Inst_SKINNY_Sbox_9_Q294_inst2_Inst_7__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_9_M2_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_9_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst2_Inst_7__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst2_Inst_7__CF_Inst_U1 ( .A(FRESH[16]), 
        .B(FRESH[17]), .Z(Inst_SKINNY_Sbox_9_Q294_inst2_Inst_7__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst2_Inst_8__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_9_Q294_inst2_Inst_8__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_9_Q294_inst2_Inst_8__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Out[8]) );
  NAND2_X1 Inst_SKINNY_Sbox_9_Q294_inst2_Inst_8__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_9_M2_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_9_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst2_Inst_8__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst2_Inst_8__CF_Inst_U1 ( .A(FRESH[17]), 
        .B(FRESH[12]), .Z(Inst_SKINNY_Sbox_9_Q294_inst2_Inst_8__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst2_Inst_9__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_9_Q294_inst2_Inst_9__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_9_M2_out2_reg[1]), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Out[9]) );
  NAND2_X1 Inst_SKINNY_Sbox_9_Q294_inst2_Inst_9__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_9_M2_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_9_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst2_Inst_9__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst2_Inst_10__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_9_Q294_inst2_Inst_10__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_9_Q294_inst2_Inst_10__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Out[10]) );
  NAND2_X1 Inst_SKINNY_Sbox_9_Q294_inst2_Inst_10__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_9_M2_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_9_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst2_Inst_10__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst2_Inst_10__CF_Inst_U1 ( .A(FRESH[18]), 
        .B(FRESH[19]), .Z(Inst_SKINNY_Sbox_9_Q294_inst2_Inst_10__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst2_Inst_11__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_9_Q294_inst2_Inst_11__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_9_Q294_inst2_Inst_11__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Out[11]) );
  NAND2_X1 Inst_SKINNY_Sbox_9_Q294_inst2_Inst_11__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_9_M2_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_9_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst2_Inst_11__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst2_Inst_11__CF_Inst_U1 ( .A(FRESH[19]), 
        .B(FRESH[20]), .Z(Inst_SKINNY_Sbox_9_Q294_inst2_Inst_11__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst2_Inst_12__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_9_Q294_inst2_Inst_12__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_9_M2_out3_reg[1]), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Out[12]) );
  NAND2_X1 Inst_SKINNY_Sbox_9_Q294_inst2_Inst_12__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_9_M2_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_9_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst2_Inst_12__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst2_Inst_13__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_9_Q294_inst2_Inst_13__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_9_Q294_inst2_Inst_13__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Out[13]) );
  NAND2_X1 Inst_SKINNY_Sbox_9_Q294_inst2_Inst_13__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_9_M2_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_9_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst2_Inst_13__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst2_Inst_13__CF_Inst_U1 ( .A(FRESH[20]), 
        .B(FRESH[21]), .Z(Inst_SKINNY_Sbox_9_Q294_inst2_Inst_13__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst2_Inst_14__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_9_Q294_inst2_Inst_14__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_9_Q294_inst2_Inst_14__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Out[14]) );
  NAND2_X1 Inst_SKINNY_Sbox_9_Q294_inst2_Inst_14__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_9_M2_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_9_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst2_Inst_14__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst2_Inst_14__CF_Inst_U1 ( .A(FRESH[21]), 
        .B(FRESH[22]), .Z(Inst_SKINNY_Sbox_9_Q294_inst2_Inst_14__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst2_Inst_15__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_9_Q294_inst2_Inst_15__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_9_M2_out1_reg[1]), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Out[15]) );
  NAND2_X1 Inst_SKINNY_Sbox_9_Q294_inst2_Inst_15__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_9_M2_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_9_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst2_Inst_15__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst2_Inst_16__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_9_Q294_inst2_Inst_16__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_9_Q294_inst2_Inst_16__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Out[16]) );
  NAND2_X1 Inst_SKINNY_Sbox_9_Q294_inst2_Inst_16__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_9_M2_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_9_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst2_Inst_16__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst2_Inst_16__CF_Inst_U1 ( .A(FRESH[22]), 
        .B(FRESH[23]), .Z(Inst_SKINNY_Sbox_9_Q294_inst2_Inst_16__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst2_Inst_17__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_9_Q294_inst2_Inst_17__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_9_Q294_inst2_Inst_17__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Out[17]) );
  NAND2_X1 Inst_SKINNY_Sbox_9_Q294_inst2_Inst_17__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_9_M2_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_9_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst2_Inst_17__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst2_Inst_17__CF_Inst_U1 ( .A(FRESH[23]), 
        .B(FRESH[18]), .Z(Inst_SKINNY_Sbox_9_Q294_inst2_Inst_17__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst2_InstXOR_0__Compression1_U2 ( .A(
        Inst_SKINNY_Sbox_9_Q294_inst2_InstXOR_0__Compression1_n3), .B(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Reg[2]), .ZN(
        Inst_SKINNY_Sbox_9_Q294_2_out1[0]) );
  XNOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst2_InstXOR_0__Compression1_U1 ( .A(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Reg[0]), .B(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Reg[1]), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst2_InstXOR_0__Compression1_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst2_InstXOR_0__Compression2_U2 ( .A(
        Inst_SKINNY_Sbox_9_Q294_inst2_InstXOR_0__Compression2_n3), .B(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Reg[5]), .ZN(
        Inst_SKINNY_Sbox_9_OutAff_out2[1]) );
  XNOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst2_InstXOR_0__Compression2_U1 ( .A(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Reg[3]), .B(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Reg[4]), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst2_InstXOR_0__Compression2_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst2_InstXOR_0__Compression3_U2 ( .A(
        Inst_SKINNY_Sbox_9_Q294_inst2_InstXOR_0__Compression3_n3), .B(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Reg[8]), .ZN(
        Inst_SKINNY_Sbox_9_OutAff_out3[1]) );
  XNOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst2_InstXOR_0__Compression3_U1 ( .A(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Reg[6]), .B(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Reg[7]), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst2_InstXOR_0__Compression3_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst2_InstXOR_1__Compression1_U2 ( .A(
        Inst_SKINNY_Sbox_9_Q294_inst2_InstXOR_1__Compression1_n3), .B(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Reg[11]), .ZN(
        Inst_SKINNY_Sbox_9_Q294_2_out1[1]) );
  XNOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst2_InstXOR_1__Compression1_U1 ( .A(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Reg[9]), .B(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Reg[10]), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst2_InstXOR_1__Compression1_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst2_InstXOR_1__Compression2_U2 ( .A(
        Inst_SKINNY_Sbox_9_Q294_inst2_InstXOR_1__Compression2_n3), .B(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Reg[14]), .ZN(
        Inst_SKINNY_Sbox_9_OutAff_out2[0]) );
  XNOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst2_InstXOR_1__Compression2_U1 ( .A(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Reg[12]), .B(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Reg[13]), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst2_InstXOR_1__Compression2_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst2_InstXOR_1__Compression3_U2 ( .A(
        Inst_SKINNY_Sbox_9_Q294_inst2_InstXOR_1__Compression3_n3), .B(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Reg[17]), .ZN(
        Inst_SKINNY_Sbox_9_OutAff_out3[0]) );
  XNOR2_X1 Inst_SKINNY_Sbox_9_Q294_inst2_InstXOR_1__Compression3_U1 ( .A(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Reg[15]), .B(
        Inst_SKINNY_Sbox_9_Q294_inst2_CF_Reg[16]), .ZN(
        Inst_SKINNY_Sbox_9_Q294_inst2_InstXOR_1__Compression3_n3) );
  INV_X1 Inst_SKINNY_Sbox_9_OutputAffine_U4 ( .A(
        Inst_SKINNY_Sbox_9_Q294_2_out1[3]), .ZN(
        Inst_SKINNY_Sbox_9_OutAff_out1[3]) );
  INV_X1 Inst_SKINNY_Sbox_9_OutputAffine_U3 ( .A(
        Inst_SKINNY_Sbox_9_Q294_2_out1[2]), .ZN(
        Inst_SKINNY_Sbox_9_OutAff_out1[2]) );
  INV_X1 Inst_SKINNY_Sbox_9_OutputAffine_U2 ( .A(
        Inst_SKINNY_Sbox_9_Q294_2_out1[1]), .ZN(
        Inst_SKINNY_Sbox_9_OutAff_out1[0]) );
  INV_X1 Inst_SKINNY_Sbox_9_OutputAffine_U1 ( .A(
        Inst_SKINNY_Sbox_9_Q294_2_out1[0]), .ZN(
        Inst_SKINNY_Sbox_9_OutAff_out1[1]) );
  XNOR2_X1 Inst_SKINNY_Sbox_10_U18 ( .A(Inst_SKINNY_Sbox_10_n12), .B(FRESH[31]), .ZN(SUB_OUT3[43]) );
  XNOR2_X1 Inst_SKINNY_Sbox_10_U17 ( .A(FRESH[27]), .B(
        Inst_SKINNY_Sbox_10_OutAff_out3[3]), .ZN(Inst_SKINNY_Sbox_10_n12) );
  XNOR2_X1 Inst_SKINNY_Sbox_10_U16 ( .A(Inst_SKINNY_Sbox_10_n11), .B(FRESH[30]), .ZN(SUB_OUT3[42]) );
  XNOR2_X1 Inst_SKINNY_Sbox_10_U15 ( .A(FRESH[26]), .B(
        Inst_SKINNY_Sbox_10_OutAff_out3[2]), .ZN(Inst_SKINNY_Sbox_10_n11) );
  XNOR2_X1 Inst_SKINNY_Sbox_10_U14 ( .A(Inst_SKINNY_Sbox_10_n10), .B(FRESH[29]), .ZN(SUB_OUT3[41]) );
  XNOR2_X1 Inst_SKINNY_Sbox_10_U13 ( .A(FRESH[25]), .B(
        Inst_SKINNY_Sbox_10_OutAff_out3[1]), .ZN(Inst_SKINNY_Sbox_10_n10) );
  XNOR2_X1 Inst_SKINNY_Sbox_10_U12 ( .A(Inst_SKINNY_Sbox_10_n9), .B(FRESH[28]), 
        .ZN(SUB_OUT3[40]) );
  XNOR2_X1 Inst_SKINNY_Sbox_10_U11 ( .A(FRESH[24]), .B(
        Inst_SKINNY_Sbox_10_OutAff_out3[0]), .ZN(Inst_SKINNY_Sbox_10_n9) );
  XOR2_X1 Inst_SKINNY_Sbox_10_U10 ( .A(FRESH[31]), .B(
        Inst_SKINNY_Sbox_10_OutAff_out2[3]), .Z(SUB_OUT2[43]) );
  XOR2_X1 Inst_SKINNY_Sbox_10_U9 ( .A(FRESH[30]), .B(
        Inst_SKINNY_Sbox_10_OutAff_out2[2]), .Z(SUB_OUT2[42]) );
  XOR2_X1 Inst_SKINNY_Sbox_10_U8 ( .A(FRESH[29]), .B(
        Inst_SKINNY_Sbox_10_OutAff_out2[1]), .Z(SUB_OUT2[41]) );
  XOR2_X1 Inst_SKINNY_Sbox_10_U7 ( .A(FRESH[28]), .B(
        Inst_SKINNY_Sbox_10_OutAff_out2[0]), .Z(SUB_OUT2[40]) );
  XOR2_X1 Inst_SKINNY_Sbox_10_U6 ( .A(FRESH[27]), .B(
        Inst_SKINNY_Sbox_10_OutAff_out1[3]), .Z(SUB_OUT1[43]) );
  XOR2_X1 Inst_SKINNY_Sbox_10_U5 ( .A(FRESH[26]), .B(
        Inst_SKINNY_Sbox_10_OutAff_out1[2]), .Z(SUB_OUT1[42]) );
  XOR2_X1 Inst_SKINNY_Sbox_10_U4 ( .A(FRESH[25]), .B(
        Inst_SKINNY_Sbox_10_OutAff_out1[1]), .Z(SUB_OUT1[41]) );
  XOR2_X1 Inst_SKINNY_Sbox_10_U3 ( .A(FRESH[24]), .B(
        Inst_SKINNY_Sbox_10_OutAff_out1[0]), .Z(SUB_OUT1[40]) );
  DFF_X1 Inst_SKINNY_Sbox_10_M2_out3_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_10_M2_out3[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_M2_out3_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_M2_out3_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_10_M2_out3[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_M2_out3_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_M2_out3_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_10_M2_out3[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_M2_out3_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_M2_out3_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_10_M2_out3[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_M2_out3_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_M2_out2_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_10_M2_out2[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_M2_out2_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_M2_out2_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_10_M2_out2[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_M2_out2_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_M2_out2_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_10_M2_out2[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_M2_out2_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_M2_out2_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_10_M2_out2[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_M2_out2_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_M2_out1_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_10_M2_out1[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_M2_out1_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_M2_out1_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_10_M2_out1[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_M2_out1_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_M2_out1_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_10_M2_out1[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_M2_out1_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_M2_out1_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_10_M2_out1[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_M2_out1_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_InAff_out3_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_10_InAff_out3[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_InAff_out3_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_InAff_out3_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_10_InAff_out3[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_InAff_out3_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_InAff_out3_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_10_InAff_out3[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_InAff_out3_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_InAff_out3_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_10_InAff_out3[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_InAff_out3_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_InAff_out2_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_10_InAff_out2[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_InAff_out2_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_InAff_out2_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_10_InAff_out2[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_InAff_out2_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_InAff_out2_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_10_InAff_out2[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_InAff_out2_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_InAff_out2_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_10_InAff_out2[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_InAff_out2_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_InAff_out1_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_10_InAff_out1[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_InAff_out1_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_InAff_out1_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_10_InAff_out1[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_InAff_out1_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_InAff_out1_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_10_InAff_out1[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_InAff_out1_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_InAff_out1_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_10_InAff_out1[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_InAff_out1_reg[3]), .QN() );
  INV_X1 Inst_SKINNY_Sbox_10_InputAffine_U4 ( .A(SUB_IN1[43]), .ZN(
        Inst_SKINNY_Sbox_10_InAff_out1[1]) );
  INV_X1 Inst_SKINNY_Sbox_10_InputAffine_U3 ( .A(SUB_IN1[42]), .ZN(
        Inst_SKINNY_Sbox_10_InAff_out1[3]) );
  INV_X1 Inst_SKINNY_Sbox_10_InputAffine_U2 ( .A(SUB_IN1[41]), .ZN(
        Inst_SKINNY_Sbox_10_InAff_out1[2]) );
  INV_X1 Inst_SKINNY_Sbox_10_InputAffine_U1 ( .A(SUB_IN1[40]), .ZN(
        Inst_SKINNY_Sbox_10_InAff_out1[0]) );
  DFF_X1 Inst_SKINNY_Sbox_10_Q294_inst1_CF_Reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Out[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_Q294_inst1_CF_Reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Out[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_Q294_inst1_CF_Reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Out[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_Q294_inst1_CF_Reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Out[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_Q294_inst1_CF_Reg_reg_4_ ( .D(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Out[4]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Reg[4]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_Q294_inst1_CF_Reg_reg_5_ ( .D(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Out[5]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Reg[5]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_Q294_inst1_CF_Reg_reg_6_ ( .D(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Out[6]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Reg[6]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_Q294_inst1_CF_Reg_reg_7_ ( .D(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Out[7]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Reg[7]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_Q294_inst1_CF_Reg_reg_8_ ( .D(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Out[8]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Reg[8]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_Q294_inst1_CF_Reg_reg_9_ ( .D(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Out[9]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Reg[9]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_Q294_inst1_CF_Reg_reg_10_ ( .D(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Out[10]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Reg[10]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_Q294_inst1_CF_Reg_reg_11_ ( .D(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Out[11]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Reg[11]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_Q294_inst1_CF_Reg_reg_12_ ( .D(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Out[12]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Reg[12]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_Q294_inst1_CF_Reg_reg_13_ ( .D(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Out[13]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Reg[13]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_Q294_inst1_CF_Reg_reg_14_ ( .D(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Out[14]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Reg[14]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_Q294_inst1_CF_Reg_reg_15_ ( .D(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Out[15]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Reg[15]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_Q294_inst1_CF_Reg_reg_16_ ( .D(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Out[16]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Reg[16]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_Q294_inst1_CF_Reg_reg_17_ ( .D(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Out[17]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Reg[17]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_Q294_inst1_dreg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_10_InAff_out2_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_M2_out1[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_Q294_inst1_dreg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_10_InAff_out3_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_M2_out2[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_Q294_inst1_dreg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_10_InAff_out1_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_M2_out3[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_Q294_inst1_creg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_10_InAff_out2_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_M2_out1[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_Q294_inst1_creg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_10_InAff_out3_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_M2_out2[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_Q294_inst1_creg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_10_InAff_out1_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_M2_out3[1]), .QN() );
  XNOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst1_Inst_0__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_10_Q294_inst1_Inst_0__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_10_InAff_out2_reg[0]), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Out[0]) );
  NAND2_X1 Inst_SKINNY_Sbox_10_Q294_inst1_Inst_0__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_10_InAff_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_10_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst1_Inst_0__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst1_Inst_1__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_10_Q294_inst1_Inst_1__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_10_Q294_inst1_Inst_1__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Out[1]) );
  NAND2_X1 Inst_SKINNY_Sbox_10_Q294_inst1_Inst_1__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_10_InAff_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_10_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst1_Inst_1__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst1_Inst_1__CF_Inst_U1 ( .A(FRESH[0]), 
        .B(FRESH[1]), .Z(Inst_SKINNY_Sbox_10_Q294_inst1_Inst_1__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst1_Inst_2__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_10_Q294_inst1_Inst_2__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_10_Q294_inst1_Inst_2__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Out[2]) );
  NAND2_X1 Inst_SKINNY_Sbox_10_Q294_inst1_Inst_2__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_10_InAff_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_10_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst1_Inst_2__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst1_Inst_2__CF_Inst_U1 ( .A(FRESH[1]), 
        .B(FRESH[2]), .Z(Inst_SKINNY_Sbox_10_Q294_inst1_Inst_2__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst1_Inst_3__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_10_Q294_inst1_Inst_3__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_10_InAff_out3_reg[0]), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Out[3]) );
  NAND2_X1 Inst_SKINNY_Sbox_10_Q294_inst1_Inst_3__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_10_InAff_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_10_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst1_Inst_3__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst1_Inst_4__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_10_Q294_inst1_Inst_4__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_10_Q294_inst1_Inst_4__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Out[4]) );
  NAND2_X1 Inst_SKINNY_Sbox_10_Q294_inst1_Inst_4__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_10_InAff_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_10_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst1_Inst_4__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst1_Inst_4__CF_Inst_U1 ( .A(FRESH[2]), 
        .B(FRESH[3]), .Z(Inst_SKINNY_Sbox_10_Q294_inst1_Inst_4__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst1_Inst_5__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_10_Q294_inst1_Inst_5__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_10_Q294_inst1_Inst_5__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Out[5]) );
  NAND2_X1 Inst_SKINNY_Sbox_10_Q294_inst1_Inst_5__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_10_InAff_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_10_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst1_Inst_5__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst1_Inst_5__CF_Inst_U1 ( .A(FRESH[3]), 
        .B(FRESH[4]), .Z(Inst_SKINNY_Sbox_10_Q294_inst1_Inst_5__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst1_Inst_6__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_10_Q294_inst1_Inst_6__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_10_InAff_out1_reg[0]), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Out[6]) );
  NAND2_X1 Inst_SKINNY_Sbox_10_Q294_inst1_Inst_6__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_10_InAff_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_10_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst1_Inst_6__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst1_Inst_7__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_10_Q294_inst1_Inst_7__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_10_Q294_inst1_Inst_7__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Out[7]) );
  NAND2_X1 Inst_SKINNY_Sbox_10_Q294_inst1_Inst_7__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_10_InAff_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_10_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst1_Inst_7__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst1_Inst_7__CF_Inst_U1 ( .A(FRESH[4]), 
        .B(FRESH[5]), .Z(Inst_SKINNY_Sbox_10_Q294_inst1_Inst_7__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst1_Inst_8__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_10_Q294_inst1_Inst_8__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_10_Q294_inst1_Inst_8__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Out[8]) );
  NAND2_X1 Inst_SKINNY_Sbox_10_Q294_inst1_Inst_8__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_10_InAff_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_10_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst1_Inst_8__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst1_Inst_8__CF_Inst_U1 ( .A(FRESH[5]), 
        .B(FRESH[0]), .Z(Inst_SKINNY_Sbox_10_Q294_inst1_Inst_8__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst1_Inst_9__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_10_Q294_inst1_Inst_9__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_10_InAff_out2_reg[1]), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Out[9]) );
  NAND2_X1 Inst_SKINNY_Sbox_10_Q294_inst1_Inst_9__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_10_InAff_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_10_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst1_Inst_9__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst1_Inst_10__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_10_Q294_inst1_Inst_10__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_10_Q294_inst1_Inst_10__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Out[10]) );
  NAND2_X1 Inst_SKINNY_Sbox_10_Q294_inst1_Inst_10__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_10_InAff_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_10_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst1_Inst_10__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst1_Inst_10__CF_Inst_U1 ( .A(FRESH[6]), 
        .B(FRESH[7]), .Z(Inst_SKINNY_Sbox_10_Q294_inst1_Inst_10__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst1_Inst_11__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_10_Q294_inst1_Inst_11__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_10_Q294_inst1_Inst_11__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Out[11]) );
  NAND2_X1 Inst_SKINNY_Sbox_10_Q294_inst1_Inst_11__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_10_InAff_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_10_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst1_Inst_11__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst1_Inst_11__CF_Inst_U1 ( .A(FRESH[7]), 
        .B(FRESH[8]), .Z(Inst_SKINNY_Sbox_10_Q294_inst1_Inst_11__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst1_Inst_12__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_10_Q294_inst1_Inst_12__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_10_InAff_out3_reg[1]), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Out[12]) );
  NAND2_X1 Inst_SKINNY_Sbox_10_Q294_inst1_Inst_12__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_10_InAff_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_10_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst1_Inst_12__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst1_Inst_13__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_10_Q294_inst1_Inst_13__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_10_Q294_inst1_Inst_13__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Out[13]) );
  NAND2_X1 Inst_SKINNY_Sbox_10_Q294_inst1_Inst_13__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_10_InAff_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_10_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst1_Inst_13__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst1_Inst_13__CF_Inst_U1 ( .A(FRESH[8]), 
        .B(FRESH[9]), .Z(Inst_SKINNY_Sbox_10_Q294_inst1_Inst_13__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst1_Inst_14__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_10_Q294_inst1_Inst_14__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_10_Q294_inst1_Inst_14__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Out[14]) );
  NAND2_X1 Inst_SKINNY_Sbox_10_Q294_inst1_Inst_14__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_10_InAff_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_10_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst1_Inst_14__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst1_Inst_14__CF_Inst_U1 ( .A(FRESH[9]), 
        .B(FRESH[10]), .Z(Inst_SKINNY_Sbox_10_Q294_inst1_Inst_14__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst1_Inst_15__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_10_Q294_inst1_Inst_15__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_10_InAff_out1_reg[1]), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Out[15]) );
  NAND2_X1 Inst_SKINNY_Sbox_10_Q294_inst1_Inst_15__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_10_InAff_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_10_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst1_Inst_15__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst1_Inst_16__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_10_Q294_inst1_Inst_16__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_10_Q294_inst1_Inst_16__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Out[16]) );
  NAND2_X1 Inst_SKINNY_Sbox_10_Q294_inst1_Inst_16__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_10_InAff_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_10_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst1_Inst_16__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst1_Inst_16__CF_Inst_U1 ( .A(FRESH[10]), 
        .B(FRESH[11]), .Z(Inst_SKINNY_Sbox_10_Q294_inst1_Inst_16__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst1_Inst_17__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_10_Q294_inst1_Inst_17__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_10_Q294_inst1_Inst_17__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Out[17]) );
  NAND2_X1 Inst_SKINNY_Sbox_10_Q294_inst1_Inst_17__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_10_InAff_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_10_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst1_Inst_17__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst1_Inst_17__CF_Inst_U1 ( .A(FRESH[11]), 
        .B(FRESH[6]), .Z(Inst_SKINNY_Sbox_10_Q294_inst1_Inst_17__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst1_InstXOR_0__Compression1_U2 ( .A(
        Inst_SKINNY_Sbox_10_Q294_inst1_InstXOR_0__Compression1_n3), .B(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Reg[2]), .ZN(
        Inst_SKINNY_Sbox_10_M2_out1[3]) );
  XNOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst1_InstXOR_0__Compression1_U1 ( .A(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Reg[0]), .B(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Reg[1]), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst1_InstXOR_0__Compression1_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst1_InstXOR_0__Compression2_U2 ( .A(
        Inst_SKINNY_Sbox_10_Q294_inst1_InstXOR_0__Compression2_n3), .B(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Reg[5]), .ZN(
        Inst_SKINNY_Sbox_10_M2_out2[3]) );
  XNOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst1_InstXOR_0__Compression2_U1 ( .A(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Reg[3]), .B(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Reg[4]), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst1_InstXOR_0__Compression2_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst1_InstXOR_0__Compression3_U2 ( .A(
        Inst_SKINNY_Sbox_10_Q294_inst1_InstXOR_0__Compression3_n3), .B(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Reg[8]), .ZN(
        Inst_SKINNY_Sbox_10_M2_out3[3]) );
  XNOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst1_InstXOR_0__Compression3_U1 ( .A(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Reg[6]), .B(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Reg[7]), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst1_InstXOR_0__Compression3_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst1_InstXOR_1__Compression1_U2 ( .A(
        Inst_SKINNY_Sbox_10_Q294_inst1_InstXOR_1__Compression1_n3), .B(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Reg[11]), .ZN(
        Inst_SKINNY_Sbox_10_M2_out1[2]) );
  XNOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst1_InstXOR_1__Compression1_U1 ( .A(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Reg[9]), .B(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Reg[10]), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst1_InstXOR_1__Compression1_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst1_InstXOR_1__Compression2_U2 ( .A(
        Inst_SKINNY_Sbox_10_Q294_inst1_InstXOR_1__Compression2_n3), .B(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Reg[14]), .ZN(
        Inst_SKINNY_Sbox_10_M2_out2[2]) );
  XNOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst1_InstXOR_1__Compression2_U1 ( .A(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Reg[12]), .B(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Reg[13]), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst1_InstXOR_1__Compression2_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst1_InstXOR_1__Compression3_U2 ( .A(
        Inst_SKINNY_Sbox_10_Q294_inst1_InstXOR_1__Compression3_n3), .B(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Reg[17]), .ZN(
        Inst_SKINNY_Sbox_10_M2_out3[2]) );
  XNOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst1_InstXOR_1__Compression3_U1 ( .A(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Reg[15]), .B(
        Inst_SKINNY_Sbox_10_Q294_inst1_CF_Reg[16]), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst1_InstXOR_1__Compression3_n3) );
  DFF_X1 Inst_SKINNY_Sbox_10_Q294_inst2_CF_Reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Out[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_Q294_inst2_CF_Reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Out[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_Q294_inst2_CF_Reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Out[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_Q294_inst2_CF_Reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Out[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_Q294_inst2_CF_Reg_reg_4_ ( .D(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Out[4]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Reg[4]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_Q294_inst2_CF_Reg_reg_5_ ( .D(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Out[5]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Reg[5]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_Q294_inst2_CF_Reg_reg_6_ ( .D(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Out[6]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Reg[6]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_Q294_inst2_CF_Reg_reg_7_ ( .D(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Out[7]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Reg[7]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_Q294_inst2_CF_Reg_reg_8_ ( .D(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Out[8]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Reg[8]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_Q294_inst2_CF_Reg_reg_9_ ( .D(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Out[9]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Reg[9]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_Q294_inst2_CF_Reg_reg_10_ ( .D(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Out[10]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Reg[10]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_Q294_inst2_CF_Reg_reg_11_ ( .D(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Out[11]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Reg[11]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_Q294_inst2_CF_Reg_reg_12_ ( .D(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Out[12]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Reg[12]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_Q294_inst2_CF_Reg_reg_13_ ( .D(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Out[13]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Reg[13]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_Q294_inst2_CF_Reg_reg_14_ ( .D(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Out[14]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Reg[14]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_Q294_inst2_CF_Reg_reg_15_ ( .D(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Out[15]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Reg[15]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_Q294_inst2_CF_Reg_reg_16_ ( .D(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Out[16]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Reg[16]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_Q294_inst2_CF_Reg_reg_17_ ( .D(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Out[17]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Reg[17]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_Q294_inst2_dreg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_10_M2_out2_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_Q294_2_out1[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_Q294_inst2_dreg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_10_M2_out3_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_OutAff_out2[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_Q294_inst2_dreg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_10_M2_out1_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_OutAff_out3[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_Q294_inst2_creg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_10_M2_out2_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_Q294_2_out1[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_Q294_inst2_creg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_10_M2_out3_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_OutAff_out2[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_10_Q294_inst2_creg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_10_M2_out1_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_10_OutAff_out3[2]), .QN() );
  XNOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst2_Inst_0__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_10_Q294_inst2_Inst_0__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_10_M2_out2_reg[0]), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Out[0]) );
  NAND2_X1 Inst_SKINNY_Sbox_10_Q294_inst2_Inst_0__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_10_M2_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_10_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst2_Inst_0__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst2_Inst_1__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_10_Q294_inst2_Inst_1__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_10_Q294_inst2_Inst_1__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Out[1]) );
  NAND2_X1 Inst_SKINNY_Sbox_10_Q294_inst2_Inst_1__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_10_M2_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_10_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst2_Inst_1__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst2_Inst_1__CF_Inst_U1 ( .A(FRESH[12]), 
        .B(FRESH[13]), .Z(Inst_SKINNY_Sbox_10_Q294_inst2_Inst_1__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst2_Inst_2__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_10_Q294_inst2_Inst_2__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_10_Q294_inst2_Inst_2__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Out[2]) );
  NAND2_X1 Inst_SKINNY_Sbox_10_Q294_inst2_Inst_2__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_10_M2_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_10_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst2_Inst_2__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst2_Inst_2__CF_Inst_U1 ( .A(FRESH[13]), 
        .B(FRESH[14]), .Z(Inst_SKINNY_Sbox_10_Q294_inst2_Inst_2__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst2_Inst_3__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_10_Q294_inst2_Inst_3__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_10_M2_out3_reg[0]), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Out[3]) );
  NAND2_X1 Inst_SKINNY_Sbox_10_Q294_inst2_Inst_3__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_10_M2_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_10_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst2_Inst_3__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst2_Inst_4__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_10_Q294_inst2_Inst_4__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_10_Q294_inst2_Inst_4__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Out[4]) );
  NAND2_X1 Inst_SKINNY_Sbox_10_Q294_inst2_Inst_4__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_10_M2_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_10_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst2_Inst_4__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst2_Inst_4__CF_Inst_U1 ( .A(FRESH[14]), 
        .B(FRESH[15]), .Z(Inst_SKINNY_Sbox_10_Q294_inst2_Inst_4__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst2_Inst_5__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_10_Q294_inst2_Inst_5__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_10_Q294_inst2_Inst_5__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Out[5]) );
  NAND2_X1 Inst_SKINNY_Sbox_10_Q294_inst2_Inst_5__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_10_M2_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_10_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst2_Inst_5__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst2_Inst_5__CF_Inst_U1 ( .A(FRESH[15]), 
        .B(FRESH[16]), .Z(Inst_SKINNY_Sbox_10_Q294_inst2_Inst_5__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst2_Inst_6__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_10_Q294_inst2_Inst_6__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_10_M2_out1_reg[0]), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Out[6]) );
  NAND2_X1 Inst_SKINNY_Sbox_10_Q294_inst2_Inst_6__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_10_M2_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_10_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst2_Inst_6__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst2_Inst_7__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_10_Q294_inst2_Inst_7__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_10_Q294_inst2_Inst_7__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Out[7]) );
  NAND2_X1 Inst_SKINNY_Sbox_10_Q294_inst2_Inst_7__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_10_M2_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_10_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst2_Inst_7__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst2_Inst_7__CF_Inst_U1 ( .A(FRESH[16]), 
        .B(FRESH[17]), .Z(Inst_SKINNY_Sbox_10_Q294_inst2_Inst_7__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst2_Inst_8__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_10_Q294_inst2_Inst_8__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_10_Q294_inst2_Inst_8__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Out[8]) );
  NAND2_X1 Inst_SKINNY_Sbox_10_Q294_inst2_Inst_8__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_10_M2_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_10_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst2_Inst_8__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst2_Inst_8__CF_Inst_U1 ( .A(FRESH[17]), 
        .B(FRESH[12]), .Z(Inst_SKINNY_Sbox_10_Q294_inst2_Inst_8__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst2_Inst_9__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_10_Q294_inst2_Inst_9__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_10_M2_out2_reg[1]), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Out[9]) );
  NAND2_X1 Inst_SKINNY_Sbox_10_Q294_inst2_Inst_9__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_10_M2_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_10_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst2_Inst_9__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst2_Inst_10__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_10_Q294_inst2_Inst_10__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_10_Q294_inst2_Inst_10__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Out[10]) );
  NAND2_X1 Inst_SKINNY_Sbox_10_Q294_inst2_Inst_10__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_10_M2_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_10_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst2_Inst_10__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst2_Inst_10__CF_Inst_U1 ( .A(FRESH[18]), 
        .B(FRESH[19]), .Z(Inst_SKINNY_Sbox_10_Q294_inst2_Inst_10__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst2_Inst_11__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_10_Q294_inst2_Inst_11__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_10_Q294_inst2_Inst_11__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Out[11]) );
  NAND2_X1 Inst_SKINNY_Sbox_10_Q294_inst2_Inst_11__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_10_M2_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_10_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst2_Inst_11__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst2_Inst_11__CF_Inst_U1 ( .A(FRESH[19]), 
        .B(FRESH[20]), .Z(Inst_SKINNY_Sbox_10_Q294_inst2_Inst_11__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst2_Inst_12__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_10_Q294_inst2_Inst_12__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_10_M2_out3_reg[1]), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Out[12]) );
  NAND2_X1 Inst_SKINNY_Sbox_10_Q294_inst2_Inst_12__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_10_M2_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_10_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst2_Inst_12__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst2_Inst_13__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_10_Q294_inst2_Inst_13__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_10_Q294_inst2_Inst_13__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Out[13]) );
  NAND2_X1 Inst_SKINNY_Sbox_10_Q294_inst2_Inst_13__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_10_M2_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_10_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst2_Inst_13__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst2_Inst_13__CF_Inst_U1 ( .A(FRESH[20]), 
        .B(FRESH[21]), .Z(Inst_SKINNY_Sbox_10_Q294_inst2_Inst_13__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst2_Inst_14__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_10_Q294_inst2_Inst_14__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_10_Q294_inst2_Inst_14__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Out[14]) );
  NAND2_X1 Inst_SKINNY_Sbox_10_Q294_inst2_Inst_14__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_10_M2_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_10_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst2_Inst_14__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst2_Inst_14__CF_Inst_U1 ( .A(FRESH[21]), 
        .B(FRESH[22]), .Z(Inst_SKINNY_Sbox_10_Q294_inst2_Inst_14__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst2_Inst_15__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_10_Q294_inst2_Inst_15__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_10_M2_out1_reg[1]), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Out[15]) );
  NAND2_X1 Inst_SKINNY_Sbox_10_Q294_inst2_Inst_15__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_10_M2_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_10_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst2_Inst_15__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst2_Inst_16__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_10_Q294_inst2_Inst_16__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_10_Q294_inst2_Inst_16__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Out[16]) );
  NAND2_X1 Inst_SKINNY_Sbox_10_Q294_inst2_Inst_16__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_10_M2_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_10_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst2_Inst_16__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst2_Inst_16__CF_Inst_U1 ( .A(FRESH[22]), 
        .B(FRESH[23]), .Z(Inst_SKINNY_Sbox_10_Q294_inst2_Inst_16__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst2_Inst_17__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_10_Q294_inst2_Inst_17__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_10_Q294_inst2_Inst_17__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Out[17]) );
  NAND2_X1 Inst_SKINNY_Sbox_10_Q294_inst2_Inst_17__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_10_M2_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_10_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst2_Inst_17__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst2_Inst_17__CF_Inst_U1 ( .A(FRESH[23]), 
        .B(FRESH[18]), .Z(Inst_SKINNY_Sbox_10_Q294_inst2_Inst_17__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst2_InstXOR_0__Compression1_U2 ( .A(
        Inst_SKINNY_Sbox_10_Q294_inst2_InstXOR_0__Compression1_n3), .B(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Reg[2]), .ZN(
        Inst_SKINNY_Sbox_10_Q294_2_out1[0]) );
  XNOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst2_InstXOR_0__Compression1_U1 ( .A(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Reg[0]), .B(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Reg[1]), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst2_InstXOR_0__Compression1_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst2_InstXOR_0__Compression2_U2 ( .A(
        Inst_SKINNY_Sbox_10_Q294_inst2_InstXOR_0__Compression2_n3), .B(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Reg[5]), .ZN(
        Inst_SKINNY_Sbox_10_OutAff_out2[1]) );
  XNOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst2_InstXOR_0__Compression2_U1 ( .A(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Reg[3]), .B(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Reg[4]), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst2_InstXOR_0__Compression2_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst2_InstXOR_0__Compression3_U2 ( .A(
        Inst_SKINNY_Sbox_10_Q294_inst2_InstXOR_0__Compression3_n3), .B(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Reg[8]), .ZN(
        Inst_SKINNY_Sbox_10_OutAff_out3[1]) );
  XNOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst2_InstXOR_0__Compression3_U1 ( .A(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Reg[6]), .B(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Reg[7]), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst2_InstXOR_0__Compression3_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst2_InstXOR_1__Compression1_U2 ( .A(
        Inst_SKINNY_Sbox_10_Q294_inst2_InstXOR_1__Compression1_n3), .B(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Reg[11]), .ZN(
        Inst_SKINNY_Sbox_10_Q294_2_out1[1]) );
  XNOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst2_InstXOR_1__Compression1_U1 ( .A(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Reg[9]), .B(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Reg[10]), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst2_InstXOR_1__Compression1_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst2_InstXOR_1__Compression2_U2 ( .A(
        Inst_SKINNY_Sbox_10_Q294_inst2_InstXOR_1__Compression2_n3), .B(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Reg[14]), .ZN(
        Inst_SKINNY_Sbox_10_OutAff_out2[0]) );
  XNOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst2_InstXOR_1__Compression2_U1 ( .A(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Reg[12]), .B(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Reg[13]), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst2_InstXOR_1__Compression2_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst2_InstXOR_1__Compression3_U2 ( .A(
        Inst_SKINNY_Sbox_10_Q294_inst2_InstXOR_1__Compression3_n3), .B(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Reg[17]), .ZN(
        Inst_SKINNY_Sbox_10_OutAff_out3[0]) );
  XNOR2_X1 Inst_SKINNY_Sbox_10_Q294_inst2_InstXOR_1__Compression3_U1 ( .A(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Reg[15]), .B(
        Inst_SKINNY_Sbox_10_Q294_inst2_CF_Reg[16]), .ZN(
        Inst_SKINNY_Sbox_10_Q294_inst2_InstXOR_1__Compression3_n3) );
  INV_X1 Inst_SKINNY_Sbox_10_OutputAffine_U4 ( .A(
        Inst_SKINNY_Sbox_10_Q294_2_out1[3]), .ZN(
        Inst_SKINNY_Sbox_10_OutAff_out1[3]) );
  INV_X1 Inst_SKINNY_Sbox_10_OutputAffine_U3 ( .A(
        Inst_SKINNY_Sbox_10_Q294_2_out1[2]), .ZN(
        Inst_SKINNY_Sbox_10_OutAff_out1[2]) );
  INV_X1 Inst_SKINNY_Sbox_10_OutputAffine_U2 ( .A(
        Inst_SKINNY_Sbox_10_Q294_2_out1[1]), .ZN(
        Inst_SKINNY_Sbox_10_OutAff_out1[0]) );
  INV_X1 Inst_SKINNY_Sbox_10_OutputAffine_U1 ( .A(
        Inst_SKINNY_Sbox_10_Q294_2_out1[0]), .ZN(
        Inst_SKINNY_Sbox_10_OutAff_out1[1]) );
  XNOR2_X1 Inst_SKINNY_Sbox_11_U18 ( .A(Inst_SKINNY_Sbox_11_n12), .B(FRESH[39]), .ZN(SUB_OUT3[47]) );
  XNOR2_X1 Inst_SKINNY_Sbox_11_U17 ( .A(FRESH[35]), .B(
        Inst_SKINNY_Sbox_11_OutAff_out3[3]), .ZN(Inst_SKINNY_Sbox_11_n12) );
  XNOR2_X1 Inst_SKINNY_Sbox_11_U16 ( .A(Inst_SKINNY_Sbox_11_n11), .B(FRESH[38]), .ZN(SUB_OUT3[46]) );
  XNOR2_X1 Inst_SKINNY_Sbox_11_U15 ( .A(FRESH[34]), .B(
        Inst_SKINNY_Sbox_11_OutAff_out3[2]), .ZN(Inst_SKINNY_Sbox_11_n11) );
  XNOR2_X1 Inst_SKINNY_Sbox_11_U14 ( .A(Inst_SKINNY_Sbox_11_n10), .B(FRESH[37]), .ZN(SUB_OUT3[45]) );
  XNOR2_X1 Inst_SKINNY_Sbox_11_U13 ( .A(FRESH[33]), .B(
        Inst_SKINNY_Sbox_11_OutAff_out3[1]), .ZN(Inst_SKINNY_Sbox_11_n10) );
  XNOR2_X1 Inst_SKINNY_Sbox_11_U12 ( .A(Inst_SKINNY_Sbox_11_n9), .B(FRESH[36]), 
        .ZN(SUB_OUT3[44]) );
  XNOR2_X1 Inst_SKINNY_Sbox_11_U11 ( .A(FRESH[32]), .B(
        Inst_SKINNY_Sbox_11_OutAff_out3[0]), .ZN(Inst_SKINNY_Sbox_11_n9) );
  XOR2_X1 Inst_SKINNY_Sbox_11_U10 ( .A(FRESH[39]), .B(
        Inst_SKINNY_Sbox_11_OutAff_out2[3]), .Z(SUB_OUT2[47]) );
  XOR2_X1 Inst_SKINNY_Sbox_11_U9 ( .A(FRESH[38]), .B(
        Inst_SKINNY_Sbox_11_OutAff_out2[2]), .Z(SUB_OUT2[46]) );
  XOR2_X1 Inst_SKINNY_Sbox_11_U8 ( .A(FRESH[37]), .B(
        Inst_SKINNY_Sbox_11_OutAff_out2[1]), .Z(SUB_OUT2[45]) );
  XOR2_X1 Inst_SKINNY_Sbox_11_U7 ( .A(FRESH[36]), .B(
        Inst_SKINNY_Sbox_11_OutAff_out2[0]), .Z(SUB_OUT2[44]) );
  XOR2_X1 Inst_SKINNY_Sbox_11_U6 ( .A(FRESH[35]), .B(
        Inst_SKINNY_Sbox_11_OutAff_out1[3]), .Z(SUB_OUT1[47]) );
  XOR2_X1 Inst_SKINNY_Sbox_11_U5 ( .A(FRESH[34]), .B(
        Inst_SKINNY_Sbox_11_OutAff_out1[2]), .Z(SUB_OUT1[46]) );
  XOR2_X1 Inst_SKINNY_Sbox_11_U4 ( .A(FRESH[33]), .B(
        Inst_SKINNY_Sbox_11_OutAff_out1[1]), .Z(SUB_OUT1[45]) );
  XOR2_X1 Inst_SKINNY_Sbox_11_U3 ( .A(FRESH[32]), .B(
        Inst_SKINNY_Sbox_11_OutAff_out1[0]), .Z(SUB_OUT1[44]) );
  DFF_X1 Inst_SKINNY_Sbox_11_M2_out3_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_11_M2_out3[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_M2_out3_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_M2_out3_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_11_M2_out3[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_M2_out3_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_M2_out3_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_11_M2_out3[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_M2_out3_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_M2_out3_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_11_M2_out3[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_M2_out3_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_M2_out2_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_11_M2_out2[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_M2_out2_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_M2_out2_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_11_M2_out2[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_M2_out2_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_M2_out2_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_11_M2_out2[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_M2_out2_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_M2_out2_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_11_M2_out2[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_M2_out2_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_M2_out1_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_11_M2_out1[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_M2_out1_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_M2_out1_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_11_M2_out1[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_M2_out1_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_M2_out1_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_11_M2_out1[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_M2_out1_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_M2_out1_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_11_M2_out1[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_M2_out1_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_InAff_out3_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_11_InAff_out3[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_InAff_out3_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_InAff_out3_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_11_InAff_out3[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_InAff_out3_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_InAff_out3_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_11_InAff_out3[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_InAff_out3_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_InAff_out3_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_11_InAff_out3[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_InAff_out3_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_InAff_out2_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_11_InAff_out2[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_InAff_out2_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_InAff_out2_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_11_InAff_out2[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_InAff_out2_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_InAff_out2_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_11_InAff_out2[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_InAff_out2_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_InAff_out2_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_11_InAff_out2[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_InAff_out2_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_InAff_out1_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_11_InAff_out1[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_InAff_out1_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_InAff_out1_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_11_InAff_out1[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_InAff_out1_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_InAff_out1_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_11_InAff_out1[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_InAff_out1_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_InAff_out1_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_11_InAff_out1[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_InAff_out1_reg[3]), .QN() );
  INV_X1 Inst_SKINNY_Sbox_11_InputAffine_U4 ( .A(SUB_IN1[47]), .ZN(
        Inst_SKINNY_Sbox_11_InAff_out1[1]) );
  INV_X1 Inst_SKINNY_Sbox_11_InputAffine_U3 ( .A(SUB_IN1[46]), .ZN(
        Inst_SKINNY_Sbox_11_InAff_out1[3]) );
  INV_X1 Inst_SKINNY_Sbox_11_InputAffine_U2 ( .A(SUB_IN1[45]), .ZN(
        Inst_SKINNY_Sbox_11_InAff_out1[2]) );
  INV_X1 Inst_SKINNY_Sbox_11_InputAffine_U1 ( .A(SUB_IN1[44]), .ZN(
        Inst_SKINNY_Sbox_11_InAff_out1[0]) );
  DFF_X1 Inst_SKINNY_Sbox_11_Q294_inst1_CF_Reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Out[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_Q294_inst1_CF_Reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Out[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_Q294_inst1_CF_Reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Out[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_Q294_inst1_CF_Reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Out[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_Q294_inst1_CF_Reg_reg_4_ ( .D(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Out[4]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Reg[4]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_Q294_inst1_CF_Reg_reg_5_ ( .D(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Out[5]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Reg[5]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_Q294_inst1_CF_Reg_reg_6_ ( .D(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Out[6]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Reg[6]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_Q294_inst1_CF_Reg_reg_7_ ( .D(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Out[7]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Reg[7]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_Q294_inst1_CF_Reg_reg_8_ ( .D(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Out[8]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Reg[8]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_Q294_inst1_CF_Reg_reg_9_ ( .D(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Out[9]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Reg[9]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_Q294_inst1_CF_Reg_reg_10_ ( .D(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Out[10]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Reg[10]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_Q294_inst1_CF_Reg_reg_11_ ( .D(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Out[11]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Reg[11]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_Q294_inst1_CF_Reg_reg_12_ ( .D(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Out[12]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Reg[12]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_Q294_inst1_CF_Reg_reg_13_ ( .D(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Out[13]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Reg[13]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_Q294_inst1_CF_Reg_reg_14_ ( .D(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Out[14]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Reg[14]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_Q294_inst1_CF_Reg_reg_15_ ( .D(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Out[15]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Reg[15]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_Q294_inst1_CF_Reg_reg_16_ ( .D(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Out[16]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Reg[16]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_Q294_inst1_CF_Reg_reg_17_ ( .D(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Out[17]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Reg[17]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_Q294_inst1_dreg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_11_InAff_out2_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_M2_out1[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_Q294_inst1_dreg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_11_InAff_out3_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_M2_out2[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_Q294_inst1_dreg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_11_InAff_out1_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_M2_out3[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_Q294_inst1_creg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_11_InAff_out2_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_M2_out1[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_Q294_inst1_creg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_11_InAff_out3_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_M2_out2[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_Q294_inst1_creg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_11_InAff_out1_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_M2_out3[1]), .QN() );
  XNOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst1_Inst_0__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_11_Q294_inst1_Inst_0__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_11_InAff_out2_reg[0]), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Out[0]) );
  NAND2_X1 Inst_SKINNY_Sbox_11_Q294_inst1_Inst_0__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_11_InAff_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_11_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst1_Inst_0__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst1_Inst_1__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_11_Q294_inst1_Inst_1__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_11_Q294_inst1_Inst_1__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Out[1]) );
  NAND2_X1 Inst_SKINNY_Sbox_11_Q294_inst1_Inst_1__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_11_InAff_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_11_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst1_Inst_1__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst1_Inst_1__CF_Inst_U1 ( .A(FRESH[0]), 
        .B(FRESH[1]), .Z(Inst_SKINNY_Sbox_11_Q294_inst1_Inst_1__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst1_Inst_2__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_11_Q294_inst1_Inst_2__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_11_Q294_inst1_Inst_2__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Out[2]) );
  NAND2_X1 Inst_SKINNY_Sbox_11_Q294_inst1_Inst_2__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_11_InAff_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_11_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst1_Inst_2__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst1_Inst_2__CF_Inst_U1 ( .A(FRESH[1]), 
        .B(FRESH[2]), .Z(Inst_SKINNY_Sbox_11_Q294_inst1_Inst_2__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst1_Inst_3__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_11_Q294_inst1_Inst_3__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_11_InAff_out3_reg[0]), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Out[3]) );
  NAND2_X1 Inst_SKINNY_Sbox_11_Q294_inst1_Inst_3__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_11_InAff_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_11_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst1_Inst_3__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst1_Inst_4__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_11_Q294_inst1_Inst_4__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_11_Q294_inst1_Inst_4__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Out[4]) );
  NAND2_X1 Inst_SKINNY_Sbox_11_Q294_inst1_Inst_4__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_11_InAff_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_11_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst1_Inst_4__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst1_Inst_4__CF_Inst_U1 ( .A(FRESH[2]), 
        .B(FRESH[3]), .Z(Inst_SKINNY_Sbox_11_Q294_inst1_Inst_4__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst1_Inst_5__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_11_Q294_inst1_Inst_5__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_11_Q294_inst1_Inst_5__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Out[5]) );
  NAND2_X1 Inst_SKINNY_Sbox_11_Q294_inst1_Inst_5__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_11_InAff_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_11_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst1_Inst_5__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst1_Inst_5__CF_Inst_U1 ( .A(FRESH[3]), 
        .B(FRESH[4]), .Z(Inst_SKINNY_Sbox_11_Q294_inst1_Inst_5__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst1_Inst_6__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_11_Q294_inst1_Inst_6__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_11_InAff_out1_reg[0]), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Out[6]) );
  NAND2_X1 Inst_SKINNY_Sbox_11_Q294_inst1_Inst_6__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_11_InAff_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_11_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst1_Inst_6__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst1_Inst_7__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_11_Q294_inst1_Inst_7__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_11_Q294_inst1_Inst_7__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Out[7]) );
  NAND2_X1 Inst_SKINNY_Sbox_11_Q294_inst1_Inst_7__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_11_InAff_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_11_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst1_Inst_7__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst1_Inst_7__CF_Inst_U1 ( .A(FRESH[4]), 
        .B(FRESH[5]), .Z(Inst_SKINNY_Sbox_11_Q294_inst1_Inst_7__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst1_Inst_8__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_11_Q294_inst1_Inst_8__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_11_Q294_inst1_Inst_8__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Out[8]) );
  NAND2_X1 Inst_SKINNY_Sbox_11_Q294_inst1_Inst_8__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_11_InAff_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_11_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst1_Inst_8__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst1_Inst_8__CF_Inst_U1 ( .A(FRESH[5]), 
        .B(FRESH[0]), .Z(Inst_SKINNY_Sbox_11_Q294_inst1_Inst_8__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst1_Inst_9__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_11_Q294_inst1_Inst_9__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_11_InAff_out2_reg[1]), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Out[9]) );
  NAND2_X1 Inst_SKINNY_Sbox_11_Q294_inst1_Inst_9__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_11_InAff_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_11_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst1_Inst_9__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst1_Inst_10__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_11_Q294_inst1_Inst_10__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_11_Q294_inst1_Inst_10__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Out[10]) );
  NAND2_X1 Inst_SKINNY_Sbox_11_Q294_inst1_Inst_10__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_11_InAff_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_11_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst1_Inst_10__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst1_Inst_10__CF_Inst_U1 ( .A(FRESH[6]), 
        .B(FRESH[7]), .Z(Inst_SKINNY_Sbox_11_Q294_inst1_Inst_10__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst1_Inst_11__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_11_Q294_inst1_Inst_11__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_11_Q294_inst1_Inst_11__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Out[11]) );
  NAND2_X1 Inst_SKINNY_Sbox_11_Q294_inst1_Inst_11__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_11_InAff_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_11_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst1_Inst_11__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst1_Inst_11__CF_Inst_U1 ( .A(FRESH[7]), 
        .B(FRESH[8]), .Z(Inst_SKINNY_Sbox_11_Q294_inst1_Inst_11__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst1_Inst_12__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_11_Q294_inst1_Inst_12__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_11_InAff_out3_reg[1]), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Out[12]) );
  NAND2_X1 Inst_SKINNY_Sbox_11_Q294_inst1_Inst_12__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_11_InAff_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_11_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst1_Inst_12__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst1_Inst_13__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_11_Q294_inst1_Inst_13__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_11_Q294_inst1_Inst_13__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Out[13]) );
  NAND2_X1 Inst_SKINNY_Sbox_11_Q294_inst1_Inst_13__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_11_InAff_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_11_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst1_Inst_13__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst1_Inst_13__CF_Inst_U1 ( .A(FRESH[8]), 
        .B(FRESH[9]), .Z(Inst_SKINNY_Sbox_11_Q294_inst1_Inst_13__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst1_Inst_14__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_11_Q294_inst1_Inst_14__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_11_Q294_inst1_Inst_14__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Out[14]) );
  NAND2_X1 Inst_SKINNY_Sbox_11_Q294_inst1_Inst_14__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_11_InAff_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_11_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst1_Inst_14__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst1_Inst_14__CF_Inst_U1 ( .A(FRESH[9]), 
        .B(FRESH[10]), .Z(Inst_SKINNY_Sbox_11_Q294_inst1_Inst_14__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst1_Inst_15__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_11_Q294_inst1_Inst_15__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_11_InAff_out1_reg[1]), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Out[15]) );
  NAND2_X1 Inst_SKINNY_Sbox_11_Q294_inst1_Inst_15__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_11_InAff_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_11_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst1_Inst_15__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst1_Inst_16__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_11_Q294_inst1_Inst_16__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_11_Q294_inst1_Inst_16__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Out[16]) );
  NAND2_X1 Inst_SKINNY_Sbox_11_Q294_inst1_Inst_16__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_11_InAff_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_11_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst1_Inst_16__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst1_Inst_16__CF_Inst_U1 ( .A(FRESH[10]), 
        .B(FRESH[11]), .Z(Inst_SKINNY_Sbox_11_Q294_inst1_Inst_16__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst1_Inst_17__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_11_Q294_inst1_Inst_17__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_11_Q294_inst1_Inst_17__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Out[17]) );
  NAND2_X1 Inst_SKINNY_Sbox_11_Q294_inst1_Inst_17__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_11_InAff_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_11_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst1_Inst_17__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst1_Inst_17__CF_Inst_U1 ( .A(FRESH[11]), 
        .B(FRESH[6]), .Z(Inst_SKINNY_Sbox_11_Q294_inst1_Inst_17__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst1_InstXOR_0__Compression1_U2 ( .A(
        Inst_SKINNY_Sbox_11_Q294_inst1_InstXOR_0__Compression1_n3), .B(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Reg[2]), .ZN(
        Inst_SKINNY_Sbox_11_M2_out1[3]) );
  XNOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst1_InstXOR_0__Compression1_U1 ( .A(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Reg[0]), .B(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Reg[1]), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst1_InstXOR_0__Compression1_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst1_InstXOR_0__Compression2_U2 ( .A(
        Inst_SKINNY_Sbox_11_Q294_inst1_InstXOR_0__Compression2_n3), .B(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Reg[5]), .ZN(
        Inst_SKINNY_Sbox_11_M2_out2[3]) );
  XNOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst1_InstXOR_0__Compression2_U1 ( .A(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Reg[3]), .B(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Reg[4]), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst1_InstXOR_0__Compression2_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst1_InstXOR_0__Compression3_U2 ( .A(
        Inst_SKINNY_Sbox_11_Q294_inst1_InstXOR_0__Compression3_n3), .B(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Reg[8]), .ZN(
        Inst_SKINNY_Sbox_11_M2_out3[3]) );
  XNOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst1_InstXOR_0__Compression3_U1 ( .A(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Reg[6]), .B(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Reg[7]), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst1_InstXOR_0__Compression3_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst1_InstXOR_1__Compression1_U2 ( .A(
        Inst_SKINNY_Sbox_11_Q294_inst1_InstXOR_1__Compression1_n3), .B(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Reg[11]), .ZN(
        Inst_SKINNY_Sbox_11_M2_out1[2]) );
  XNOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst1_InstXOR_1__Compression1_U1 ( .A(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Reg[9]), .B(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Reg[10]), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst1_InstXOR_1__Compression1_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst1_InstXOR_1__Compression2_U2 ( .A(
        Inst_SKINNY_Sbox_11_Q294_inst1_InstXOR_1__Compression2_n3), .B(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Reg[14]), .ZN(
        Inst_SKINNY_Sbox_11_M2_out2[2]) );
  XNOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst1_InstXOR_1__Compression2_U1 ( .A(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Reg[12]), .B(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Reg[13]), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst1_InstXOR_1__Compression2_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst1_InstXOR_1__Compression3_U2 ( .A(
        Inst_SKINNY_Sbox_11_Q294_inst1_InstXOR_1__Compression3_n3), .B(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Reg[17]), .ZN(
        Inst_SKINNY_Sbox_11_M2_out3[2]) );
  XNOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst1_InstXOR_1__Compression3_U1 ( .A(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Reg[15]), .B(
        Inst_SKINNY_Sbox_11_Q294_inst1_CF_Reg[16]), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst1_InstXOR_1__Compression3_n3) );
  DFF_X1 Inst_SKINNY_Sbox_11_Q294_inst2_CF_Reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Out[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_Q294_inst2_CF_Reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Out[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_Q294_inst2_CF_Reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Out[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_Q294_inst2_CF_Reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Out[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_Q294_inst2_CF_Reg_reg_4_ ( .D(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Out[4]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Reg[4]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_Q294_inst2_CF_Reg_reg_5_ ( .D(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Out[5]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Reg[5]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_Q294_inst2_CF_Reg_reg_6_ ( .D(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Out[6]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Reg[6]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_Q294_inst2_CF_Reg_reg_7_ ( .D(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Out[7]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Reg[7]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_Q294_inst2_CF_Reg_reg_8_ ( .D(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Out[8]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Reg[8]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_Q294_inst2_CF_Reg_reg_9_ ( .D(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Out[9]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Reg[9]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_Q294_inst2_CF_Reg_reg_10_ ( .D(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Out[10]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Reg[10]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_Q294_inst2_CF_Reg_reg_11_ ( .D(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Out[11]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Reg[11]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_Q294_inst2_CF_Reg_reg_12_ ( .D(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Out[12]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Reg[12]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_Q294_inst2_CF_Reg_reg_13_ ( .D(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Out[13]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Reg[13]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_Q294_inst2_CF_Reg_reg_14_ ( .D(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Out[14]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Reg[14]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_Q294_inst2_CF_Reg_reg_15_ ( .D(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Out[15]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Reg[15]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_Q294_inst2_CF_Reg_reg_16_ ( .D(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Out[16]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Reg[16]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_Q294_inst2_CF_Reg_reg_17_ ( .D(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Out[17]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Reg[17]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_Q294_inst2_dreg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_11_M2_out2_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_Q294_2_out1[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_Q294_inst2_dreg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_11_M2_out3_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_OutAff_out2[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_Q294_inst2_dreg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_11_M2_out1_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_OutAff_out3[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_Q294_inst2_creg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_11_M2_out2_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_Q294_2_out1[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_Q294_inst2_creg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_11_M2_out3_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_OutAff_out2[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_11_Q294_inst2_creg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_11_M2_out1_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_11_OutAff_out3[2]), .QN() );
  XNOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst2_Inst_0__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_11_Q294_inst2_Inst_0__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_11_M2_out2_reg[0]), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Out[0]) );
  NAND2_X1 Inst_SKINNY_Sbox_11_Q294_inst2_Inst_0__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_11_M2_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_11_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst2_Inst_0__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst2_Inst_1__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_11_Q294_inst2_Inst_1__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_11_Q294_inst2_Inst_1__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Out[1]) );
  NAND2_X1 Inst_SKINNY_Sbox_11_Q294_inst2_Inst_1__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_11_M2_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_11_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst2_Inst_1__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst2_Inst_1__CF_Inst_U1 ( .A(FRESH[12]), 
        .B(FRESH[13]), .Z(Inst_SKINNY_Sbox_11_Q294_inst2_Inst_1__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst2_Inst_2__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_11_Q294_inst2_Inst_2__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_11_Q294_inst2_Inst_2__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Out[2]) );
  NAND2_X1 Inst_SKINNY_Sbox_11_Q294_inst2_Inst_2__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_11_M2_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_11_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst2_Inst_2__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst2_Inst_2__CF_Inst_U1 ( .A(FRESH[13]), 
        .B(FRESH[14]), .Z(Inst_SKINNY_Sbox_11_Q294_inst2_Inst_2__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst2_Inst_3__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_11_Q294_inst2_Inst_3__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_11_M2_out3_reg[0]), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Out[3]) );
  NAND2_X1 Inst_SKINNY_Sbox_11_Q294_inst2_Inst_3__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_11_M2_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_11_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst2_Inst_3__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst2_Inst_4__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_11_Q294_inst2_Inst_4__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_11_Q294_inst2_Inst_4__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Out[4]) );
  NAND2_X1 Inst_SKINNY_Sbox_11_Q294_inst2_Inst_4__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_11_M2_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_11_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst2_Inst_4__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst2_Inst_4__CF_Inst_U1 ( .A(FRESH[14]), 
        .B(FRESH[15]), .Z(Inst_SKINNY_Sbox_11_Q294_inst2_Inst_4__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst2_Inst_5__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_11_Q294_inst2_Inst_5__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_11_Q294_inst2_Inst_5__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Out[5]) );
  NAND2_X1 Inst_SKINNY_Sbox_11_Q294_inst2_Inst_5__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_11_M2_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_11_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst2_Inst_5__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst2_Inst_5__CF_Inst_U1 ( .A(FRESH[15]), 
        .B(FRESH[16]), .Z(Inst_SKINNY_Sbox_11_Q294_inst2_Inst_5__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst2_Inst_6__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_11_Q294_inst2_Inst_6__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_11_M2_out1_reg[0]), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Out[6]) );
  NAND2_X1 Inst_SKINNY_Sbox_11_Q294_inst2_Inst_6__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_11_M2_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_11_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst2_Inst_6__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst2_Inst_7__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_11_Q294_inst2_Inst_7__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_11_Q294_inst2_Inst_7__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Out[7]) );
  NAND2_X1 Inst_SKINNY_Sbox_11_Q294_inst2_Inst_7__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_11_M2_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_11_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst2_Inst_7__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst2_Inst_7__CF_Inst_U1 ( .A(FRESH[16]), 
        .B(FRESH[17]), .Z(Inst_SKINNY_Sbox_11_Q294_inst2_Inst_7__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst2_Inst_8__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_11_Q294_inst2_Inst_8__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_11_Q294_inst2_Inst_8__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Out[8]) );
  NAND2_X1 Inst_SKINNY_Sbox_11_Q294_inst2_Inst_8__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_11_M2_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_11_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst2_Inst_8__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst2_Inst_8__CF_Inst_U1 ( .A(FRESH[17]), 
        .B(FRESH[12]), .Z(Inst_SKINNY_Sbox_11_Q294_inst2_Inst_8__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst2_Inst_9__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_11_Q294_inst2_Inst_9__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_11_M2_out2_reg[1]), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Out[9]) );
  NAND2_X1 Inst_SKINNY_Sbox_11_Q294_inst2_Inst_9__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_11_M2_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_11_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst2_Inst_9__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst2_Inst_10__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_11_Q294_inst2_Inst_10__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_11_Q294_inst2_Inst_10__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Out[10]) );
  NAND2_X1 Inst_SKINNY_Sbox_11_Q294_inst2_Inst_10__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_11_M2_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_11_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst2_Inst_10__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst2_Inst_10__CF_Inst_U1 ( .A(FRESH[18]), 
        .B(FRESH[19]), .Z(Inst_SKINNY_Sbox_11_Q294_inst2_Inst_10__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst2_Inst_11__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_11_Q294_inst2_Inst_11__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_11_Q294_inst2_Inst_11__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Out[11]) );
  NAND2_X1 Inst_SKINNY_Sbox_11_Q294_inst2_Inst_11__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_11_M2_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_11_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst2_Inst_11__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst2_Inst_11__CF_Inst_U1 ( .A(FRESH[19]), 
        .B(FRESH[20]), .Z(Inst_SKINNY_Sbox_11_Q294_inst2_Inst_11__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst2_Inst_12__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_11_Q294_inst2_Inst_12__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_11_M2_out3_reg[1]), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Out[12]) );
  NAND2_X1 Inst_SKINNY_Sbox_11_Q294_inst2_Inst_12__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_11_M2_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_11_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst2_Inst_12__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst2_Inst_13__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_11_Q294_inst2_Inst_13__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_11_Q294_inst2_Inst_13__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Out[13]) );
  NAND2_X1 Inst_SKINNY_Sbox_11_Q294_inst2_Inst_13__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_11_M2_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_11_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst2_Inst_13__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst2_Inst_13__CF_Inst_U1 ( .A(FRESH[20]), 
        .B(FRESH[21]), .Z(Inst_SKINNY_Sbox_11_Q294_inst2_Inst_13__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst2_Inst_14__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_11_Q294_inst2_Inst_14__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_11_Q294_inst2_Inst_14__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Out[14]) );
  NAND2_X1 Inst_SKINNY_Sbox_11_Q294_inst2_Inst_14__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_11_M2_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_11_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst2_Inst_14__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst2_Inst_14__CF_Inst_U1 ( .A(FRESH[21]), 
        .B(FRESH[22]), .Z(Inst_SKINNY_Sbox_11_Q294_inst2_Inst_14__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst2_Inst_15__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_11_Q294_inst2_Inst_15__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_11_M2_out1_reg[1]), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Out[15]) );
  NAND2_X1 Inst_SKINNY_Sbox_11_Q294_inst2_Inst_15__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_11_M2_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_11_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst2_Inst_15__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst2_Inst_16__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_11_Q294_inst2_Inst_16__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_11_Q294_inst2_Inst_16__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Out[16]) );
  NAND2_X1 Inst_SKINNY_Sbox_11_Q294_inst2_Inst_16__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_11_M2_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_11_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst2_Inst_16__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst2_Inst_16__CF_Inst_U1 ( .A(FRESH[22]), 
        .B(FRESH[23]), .Z(Inst_SKINNY_Sbox_11_Q294_inst2_Inst_16__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst2_Inst_17__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_11_Q294_inst2_Inst_17__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_11_Q294_inst2_Inst_17__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Out[17]) );
  NAND2_X1 Inst_SKINNY_Sbox_11_Q294_inst2_Inst_17__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_11_M2_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_11_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst2_Inst_17__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst2_Inst_17__CF_Inst_U1 ( .A(FRESH[23]), 
        .B(FRESH[18]), .Z(Inst_SKINNY_Sbox_11_Q294_inst2_Inst_17__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst2_InstXOR_0__Compression1_U2 ( .A(
        Inst_SKINNY_Sbox_11_Q294_inst2_InstXOR_0__Compression1_n3), .B(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Reg[2]), .ZN(
        Inst_SKINNY_Sbox_11_Q294_2_out1[0]) );
  XNOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst2_InstXOR_0__Compression1_U1 ( .A(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Reg[0]), .B(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Reg[1]), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst2_InstXOR_0__Compression1_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst2_InstXOR_0__Compression2_U2 ( .A(
        Inst_SKINNY_Sbox_11_Q294_inst2_InstXOR_0__Compression2_n3), .B(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Reg[5]), .ZN(
        Inst_SKINNY_Sbox_11_OutAff_out2[1]) );
  XNOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst2_InstXOR_0__Compression2_U1 ( .A(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Reg[3]), .B(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Reg[4]), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst2_InstXOR_0__Compression2_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst2_InstXOR_0__Compression3_U2 ( .A(
        Inst_SKINNY_Sbox_11_Q294_inst2_InstXOR_0__Compression3_n3), .B(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Reg[8]), .ZN(
        Inst_SKINNY_Sbox_11_OutAff_out3[1]) );
  XNOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst2_InstXOR_0__Compression3_U1 ( .A(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Reg[6]), .B(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Reg[7]), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst2_InstXOR_0__Compression3_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst2_InstXOR_1__Compression1_U2 ( .A(
        Inst_SKINNY_Sbox_11_Q294_inst2_InstXOR_1__Compression1_n3), .B(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Reg[11]), .ZN(
        Inst_SKINNY_Sbox_11_Q294_2_out1[1]) );
  XNOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst2_InstXOR_1__Compression1_U1 ( .A(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Reg[9]), .B(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Reg[10]), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst2_InstXOR_1__Compression1_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst2_InstXOR_1__Compression2_U2 ( .A(
        Inst_SKINNY_Sbox_11_Q294_inst2_InstXOR_1__Compression2_n3), .B(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Reg[14]), .ZN(
        Inst_SKINNY_Sbox_11_OutAff_out2[0]) );
  XNOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst2_InstXOR_1__Compression2_U1 ( .A(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Reg[12]), .B(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Reg[13]), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst2_InstXOR_1__Compression2_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst2_InstXOR_1__Compression3_U2 ( .A(
        Inst_SKINNY_Sbox_11_Q294_inst2_InstXOR_1__Compression3_n3), .B(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Reg[17]), .ZN(
        Inst_SKINNY_Sbox_11_OutAff_out3[0]) );
  XNOR2_X1 Inst_SKINNY_Sbox_11_Q294_inst2_InstXOR_1__Compression3_U1 ( .A(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Reg[15]), .B(
        Inst_SKINNY_Sbox_11_Q294_inst2_CF_Reg[16]), .ZN(
        Inst_SKINNY_Sbox_11_Q294_inst2_InstXOR_1__Compression3_n3) );
  INV_X1 Inst_SKINNY_Sbox_11_OutputAffine_U4 ( .A(
        Inst_SKINNY_Sbox_11_Q294_2_out1[3]), .ZN(
        Inst_SKINNY_Sbox_11_OutAff_out1[3]) );
  INV_X1 Inst_SKINNY_Sbox_11_OutputAffine_U3 ( .A(
        Inst_SKINNY_Sbox_11_Q294_2_out1[2]), .ZN(
        Inst_SKINNY_Sbox_11_OutAff_out1[2]) );
  INV_X1 Inst_SKINNY_Sbox_11_OutputAffine_U2 ( .A(
        Inst_SKINNY_Sbox_11_Q294_2_out1[1]), .ZN(
        Inst_SKINNY_Sbox_11_OutAff_out1[0]) );
  INV_X1 Inst_SKINNY_Sbox_11_OutputAffine_U1 ( .A(
        Inst_SKINNY_Sbox_11_Q294_2_out1[0]), .ZN(
        Inst_SKINNY_Sbox_11_OutAff_out1[1]) );
  XNOR2_X1 Inst_SKINNY_Sbox_12_U18 ( .A(Inst_SKINNY_Sbox_12_n12), .B(FRESH[31]), .ZN(SUB_OUT3[51]) );
  XNOR2_X1 Inst_SKINNY_Sbox_12_U17 ( .A(FRESH[27]), .B(
        Inst_SKINNY_Sbox_12_OutAff_out3[3]), .ZN(Inst_SKINNY_Sbox_12_n12) );
  XNOR2_X1 Inst_SKINNY_Sbox_12_U16 ( .A(Inst_SKINNY_Sbox_12_n11), .B(FRESH[30]), .ZN(SUB_OUT3[50]) );
  XNOR2_X1 Inst_SKINNY_Sbox_12_U15 ( .A(FRESH[26]), .B(
        Inst_SKINNY_Sbox_12_OutAff_out3[2]), .ZN(Inst_SKINNY_Sbox_12_n11) );
  XNOR2_X1 Inst_SKINNY_Sbox_12_U14 ( .A(Inst_SKINNY_Sbox_12_n10), .B(FRESH[29]), .ZN(SUB_OUT3[49]) );
  XNOR2_X1 Inst_SKINNY_Sbox_12_U13 ( .A(FRESH[25]), .B(
        Inst_SKINNY_Sbox_12_OutAff_out3[1]), .ZN(Inst_SKINNY_Sbox_12_n10) );
  XNOR2_X1 Inst_SKINNY_Sbox_12_U12 ( .A(Inst_SKINNY_Sbox_12_n9), .B(FRESH[28]), 
        .ZN(SUB_OUT3[48]) );
  XNOR2_X1 Inst_SKINNY_Sbox_12_U11 ( .A(FRESH[24]), .B(
        Inst_SKINNY_Sbox_12_OutAff_out3[0]), .ZN(Inst_SKINNY_Sbox_12_n9) );
  XOR2_X1 Inst_SKINNY_Sbox_12_U10 ( .A(FRESH[31]), .B(
        Inst_SKINNY_Sbox_12_OutAff_out2[3]), .Z(SUB_OUT2[51]) );
  XOR2_X1 Inst_SKINNY_Sbox_12_U9 ( .A(FRESH[30]), .B(
        Inst_SKINNY_Sbox_12_OutAff_out2[2]), .Z(SUB_OUT2[50]) );
  XOR2_X1 Inst_SKINNY_Sbox_12_U8 ( .A(FRESH[29]), .B(
        Inst_SKINNY_Sbox_12_OutAff_out2[1]), .Z(SUB_OUT2[49]) );
  XOR2_X1 Inst_SKINNY_Sbox_12_U7 ( .A(FRESH[28]), .B(
        Inst_SKINNY_Sbox_12_OutAff_out2[0]), .Z(SUB_OUT2[48]) );
  XOR2_X1 Inst_SKINNY_Sbox_12_U6 ( .A(FRESH[27]), .B(
        Inst_SKINNY_Sbox_12_OutAff_out1[3]), .Z(SUB_OUT1[51]) );
  XOR2_X1 Inst_SKINNY_Sbox_12_U5 ( .A(FRESH[26]), .B(
        Inst_SKINNY_Sbox_12_OutAff_out1[2]), .Z(SUB_OUT1[50]) );
  XOR2_X1 Inst_SKINNY_Sbox_12_U4 ( .A(FRESH[25]), .B(
        Inst_SKINNY_Sbox_12_OutAff_out1[1]), .Z(SUB_OUT1[49]) );
  XOR2_X1 Inst_SKINNY_Sbox_12_U3 ( .A(FRESH[24]), .B(
        Inst_SKINNY_Sbox_12_OutAff_out1[0]), .Z(SUB_OUT1[48]) );
  DFF_X1 Inst_SKINNY_Sbox_12_M2_out3_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_12_M2_out3[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_M2_out3_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_M2_out3_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_12_M2_out3[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_M2_out3_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_M2_out3_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_12_M2_out3[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_M2_out3_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_M2_out3_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_12_M2_out3[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_M2_out3_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_M2_out2_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_12_M2_out2[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_M2_out2_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_M2_out2_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_12_M2_out2[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_M2_out2_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_M2_out2_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_12_M2_out2[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_M2_out2_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_M2_out2_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_12_M2_out2[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_M2_out2_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_M2_out1_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_12_M2_out1[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_M2_out1_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_M2_out1_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_12_M2_out1[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_M2_out1_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_M2_out1_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_12_M2_out1[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_M2_out1_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_M2_out1_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_12_M2_out1[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_M2_out1_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_InAff_out3_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_12_InAff_out3[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_InAff_out3_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_InAff_out3_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_12_InAff_out3[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_InAff_out3_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_InAff_out3_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_12_InAff_out3[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_InAff_out3_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_InAff_out3_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_12_InAff_out3[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_InAff_out3_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_InAff_out2_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_12_InAff_out2[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_InAff_out2_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_InAff_out2_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_12_InAff_out2[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_InAff_out2_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_InAff_out2_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_12_InAff_out2[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_InAff_out2_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_InAff_out2_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_12_InAff_out2[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_InAff_out2_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_InAff_out1_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_12_InAff_out1[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_InAff_out1_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_InAff_out1_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_12_InAff_out1[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_InAff_out1_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_InAff_out1_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_12_InAff_out1[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_InAff_out1_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_InAff_out1_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_12_InAff_out1[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_InAff_out1_reg[3]), .QN() );
  INV_X1 Inst_SKINNY_Sbox_12_InputAffine_U4 ( .A(SUB_IN1[51]), .ZN(
        Inst_SKINNY_Sbox_12_InAff_out1[1]) );
  INV_X1 Inst_SKINNY_Sbox_12_InputAffine_U3 ( .A(SUB_IN1[50]), .ZN(
        Inst_SKINNY_Sbox_12_InAff_out1[3]) );
  INV_X1 Inst_SKINNY_Sbox_12_InputAffine_U2 ( .A(SUB_IN1[49]), .ZN(
        Inst_SKINNY_Sbox_12_InAff_out1[2]) );
  INV_X1 Inst_SKINNY_Sbox_12_InputAffine_U1 ( .A(SUB_IN1[48]), .ZN(
        Inst_SKINNY_Sbox_12_InAff_out1[0]) );
  DFF_X1 Inst_SKINNY_Sbox_12_Q294_inst1_CF_Reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Out[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_Q294_inst1_CF_Reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Out[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_Q294_inst1_CF_Reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Out[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_Q294_inst1_CF_Reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Out[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_Q294_inst1_CF_Reg_reg_4_ ( .D(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Out[4]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Reg[4]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_Q294_inst1_CF_Reg_reg_5_ ( .D(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Out[5]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Reg[5]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_Q294_inst1_CF_Reg_reg_6_ ( .D(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Out[6]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Reg[6]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_Q294_inst1_CF_Reg_reg_7_ ( .D(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Out[7]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Reg[7]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_Q294_inst1_CF_Reg_reg_8_ ( .D(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Out[8]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Reg[8]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_Q294_inst1_CF_Reg_reg_9_ ( .D(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Out[9]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Reg[9]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_Q294_inst1_CF_Reg_reg_10_ ( .D(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Out[10]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Reg[10]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_Q294_inst1_CF_Reg_reg_11_ ( .D(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Out[11]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Reg[11]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_Q294_inst1_CF_Reg_reg_12_ ( .D(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Out[12]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Reg[12]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_Q294_inst1_CF_Reg_reg_13_ ( .D(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Out[13]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Reg[13]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_Q294_inst1_CF_Reg_reg_14_ ( .D(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Out[14]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Reg[14]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_Q294_inst1_CF_Reg_reg_15_ ( .D(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Out[15]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Reg[15]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_Q294_inst1_CF_Reg_reg_16_ ( .D(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Out[16]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Reg[16]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_Q294_inst1_CF_Reg_reg_17_ ( .D(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Out[17]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Reg[17]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_Q294_inst1_dreg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_12_InAff_out2_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_M2_out1[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_Q294_inst1_dreg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_12_InAff_out3_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_M2_out2[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_Q294_inst1_dreg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_12_InAff_out1_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_M2_out3[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_Q294_inst1_creg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_12_InAff_out2_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_M2_out1[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_Q294_inst1_creg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_12_InAff_out3_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_M2_out2[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_Q294_inst1_creg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_12_InAff_out1_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_M2_out3[1]), .QN() );
  XNOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst1_Inst_0__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_12_Q294_inst1_Inst_0__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_12_InAff_out2_reg[0]), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Out[0]) );
  NAND2_X1 Inst_SKINNY_Sbox_12_Q294_inst1_Inst_0__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_12_InAff_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_12_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst1_Inst_0__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst1_Inst_1__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_12_Q294_inst1_Inst_1__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_12_Q294_inst1_Inst_1__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Out[1]) );
  NAND2_X1 Inst_SKINNY_Sbox_12_Q294_inst1_Inst_1__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_12_InAff_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_12_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst1_Inst_1__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst1_Inst_1__CF_Inst_U1 ( .A(FRESH[0]), 
        .B(FRESH[1]), .Z(Inst_SKINNY_Sbox_12_Q294_inst1_Inst_1__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst1_Inst_2__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_12_Q294_inst1_Inst_2__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_12_Q294_inst1_Inst_2__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Out[2]) );
  NAND2_X1 Inst_SKINNY_Sbox_12_Q294_inst1_Inst_2__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_12_InAff_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_12_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst1_Inst_2__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst1_Inst_2__CF_Inst_U1 ( .A(FRESH[1]), 
        .B(FRESH[2]), .Z(Inst_SKINNY_Sbox_12_Q294_inst1_Inst_2__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst1_Inst_3__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_12_Q294_inst1_Inst_3__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_12_InAff_out3_reg[0]), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Out[3]) );
  NAND2_X1 Inst_SKINNY_Sbox_12_Q294_inst1_Inst_3__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_12_InAff_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_12_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst1_Inst_3__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst1_Inst_4__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_12_Q294_inst1_Inst_4__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_12_Q294_inst1_Inst_4__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Out[4]) );
  NAND2_X1 Inst_SKINNY_Sbox_12_Q294_inst1_Inst_4__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_12_InAff_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_12_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst1_Inst_4__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst1_Inst_4__CF_Inst_U1 ( .A(FRESH[2]), 
        .B(FRESH[3]), .Z(Inst_SKINNY_Sbox_12_Q294_inst1_Inst_4__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst1_Inst_5__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_12_Q294_inst1_Inst_5__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_12_Q294_inst1_Inst_5__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Out[5]) );
  NAND2_X1 Inst_SKINNY_Sbox_12_Q294_inst1_Inst_5__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_12_InAff_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_12_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst1_Inst_5__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst1_Inst_5__CF_Inst_U1 ( .A(FRESH[3]), 
        .B(FRESH[4]), .Z(Inst_SKINNY_Sbox_12_Q294_inst1_Inst_5__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst1_Inst_6__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_12_Q294_inst1_Inst_6__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_12_InAff_out1_reg[0]), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Out[6]) );
  NAND2_X1 Inst_SKINNY_Sbox_12_Q294_inst1_Inst_6__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_12_InAff_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_12_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst1_Inst_6__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst1_Inst_7__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_12_Q294_inst1_Inst_7__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_12_Q294_inst1_Inst_7__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Out[7]) );
  NAND2_X1 Inst_SKINNY_Sbox_12_Q294_inst1_Inst_7__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_12_InAff_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_12_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst1_Inst_7__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst1_Inst_7__CF_Inst_U1 ( .A(FRESH[4]), 
        .B(FRESH[5]), .Z(Inst_SKINNY_Sbox_12_Q294_inst1_Inst_7__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst1_Inst_8__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_12_Q294_inst1_Inst_8__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_12_Q294_inst1_Inst_8__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Out[8]) );
  NAND2_X1 Inst_SKINNY_Sbox_12_Q294_inst1_Inst_8__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_12_InAff_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_12_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst1_Inst_8__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst1_Inst_8__CF_Inst_U1 ( .A(FRESH[5]), 
        .B(FRESH[0]), .Z(Inst_SKINNY_Sbox_12_Q294_inst1_Inst_8__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst1_Inst_9__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_12_Q294_inst1_Inst_9__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_12_InAff_out2_reg[1]), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Out[9]) );
  NAND2_X1 Inst_SKINNY_Sbox_12_Q294_inst1_Inst_9__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_12_InAff_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_12_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst1_Inst_9__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst1_Inst_10__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_12_Q294_inst1_Inst_10__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_12_Q294_inst1_Inst_10__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Out[10]) );
  NAND2_X1 Inst_SKINNY_Sbox_12_Q294_inst1_Inst_10__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_12_InAff_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_12_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst1_Inst_10__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst1_Inst_10__CF_Inst_U1 ( .A(FRESH[6]), 
        .B(FRESH[7]), .Z(Inst_SKINNY_Sbox_12_Q294_inst1_Inst_10__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst1_Inst_11__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_12_Q294_inst1_Inst_11__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_12_Q294_inst1_Inst_11__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Out[11]) );
  NAND2_X1 Inst_SKINNY_Sbox_12_Q294_inst1_Inst_11__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_12_InAff_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_12_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst1_Inst_11__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst1_Inst_11__CF_Inst_U1 ( .A(FRESH[7]), 
        .B(FRESH[8]), .Z(Inst_SKINNY_Sbox_12_Q294_inst1_Inst_11__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst1_Inst_12__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_12_Q294_inst1_Inst_12__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_12_InAff_out3_reg[1]), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Out[12]) );
  NAND2_X1 Inst_SKINNY_Sbox_12_Q294_inst1_Inst_12__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_12_InAff_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_12_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst1_Inst_12__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst1_Inst_13__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_12_Q294_inst1_Inst_13__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_12_Q294_inst1_Inst_13__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Out[13]) );
  NAND2_X1 Inst_SKINNY_Sbox_12_Q294_inst1_Inst_13__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_12_InAff_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_12_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst1_Inst_13__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst1_Inst_13__CF_Inst_U1 ( .A(FRESH[8]), 
        .B(FRESH[9]), .Z(Inst_SKINNY_Sbox_12_Q294_inst1_Inst_13__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst1_Inst_14__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_12_Q294_inst1_Inst_14__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_12_Q294_inst1_Inst_14__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Out[14]) );
  NAND2_X1 Inst_SKINNY_Sbox_12_Q294_inst1_Inst_14__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_12_InAff_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_12_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst1_Inst_14__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst1_Inst_14__CF_Inst_U1 ( .A(FRESH[9]), 
        .B(FRESH[10]), .Z(Inst_SKINNY_Sbox_12_Q294_inst1_Inst_14__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst1_Inst_15__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_12_Q294_inst1_Inst_15__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_12_InAff_out1_reg[1]), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Out[15]) );
  NAND2_X1 Inst_SKINNY_Sbox_12_Q294_inst1_Inst_15__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_12_InAff_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_12_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst1_Inst_15__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst1_Inst_16__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_12_Q294_inst1_Inst_16__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_12_Q294_inst1_Inst_16__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Out[16]) );
  NAND2_X1 Inst_SKINNY_Sbox_12_Q294_inst1_Inst_16__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_12_InAff_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_12_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst1_Inst_16__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst1_Inst_16__CF_Inst_U1 ( .A(FRESH[10]), 
        .B(FRESH[11]), .Z(Inst_SKINNY_Sbox_12_Q294_inst1_Inst_16__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst1_Inst_17__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_12_Q294_inst1_Inst_17__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_12_Q294_inst1_Inst_17__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Out[17]) );
  NAND2_X1 Inst_SKINNY_Sbox_12_Q294_inst1_Inst_17__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_12_InAff_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_12_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst1_Inst_17__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst1_Inst_17__CF_Inst_U1 ( .A(FRESH[11]), 
        .B(FRESH[6]), .Z(Inst_SKINNY_Sbox_12_Q294_inst1_Inst_17__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst1_InstXOR_0__Compression1_U2 ( .A(
        Inst_SKINNY_Sbox_12_Q294_inst1_InstXOR_0__Compression1_n3), .B(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Reg[2]), .ZN(
        Inst_SKINNY_Sbox_12_M2_out1[3]) );
  XNOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst1_InstXOR_0__Compression1_U1 ( .A(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Reg[0]), .B(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Reg[1]), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst1_InstXOR_0__Compression1_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst1_InstXOR_0__Compression2_U2 ( .A(
        Inst_SKINNY_Sbox_12_Q294_inst1_InstXOR_0__Compression2_n3), .B(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Reg[5]), .ZN(
        Inst_SKINNY_Sbox_12_M2_out2[3]) );
  XNOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst1_InstXOR_0__Compression2_U1 ( .A(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Reg[3]), .B(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Reg[4]), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst1_InstXOR_0__Compression2_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst1_InstXOR_0__Compression3_U2 ( .A(
        Inst_SKINNY_Sbox_12_Q294_inst1_InstXOR_0__Compression3_n3), .B(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Reg[8]), .ZN(
        Inst_SKINNY_Sbox_12_M2_out3[3]) );
  XNOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst1_InstXOR_0__Compression3_U1 ( .A(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Reg[6]), .B(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Reg[7]), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst1_InstXOR_0__Compression3_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst1_InstXOR_1__Compression1_U2 ( .A(
        Inst_SKINNY_Sbox_12_Q294_inst1_InstXOR_1__Compression1_n3), .B(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Reg[11]), .ZN(
        Inst_SKINNY_Sbox_12_M2_out1[2]) );
  XNOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst1_InstXOR_1__Compression1_U1 ( .A(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Reg[9]), .B(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Reg[10]), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst1_InstXOR_1__Compression1_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst1_InstXOR_1__Compression2_U2 ( .A(
        Inst_SKINNY_Sbox_12_Q294_inst1_InstXOR_1__Compression2_n3), .B(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Reg[14]), .ZN(
        Inst_SKINNY_Sbox_12_M2_out2[2]) );
  XNOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst1_InstXOR_1__Compression2_U1 ( .A(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Reg[12]), .B(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Reg[13]), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst1_InstXOR_1__Compression2_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst1_InstXOR_1__Compression3_U2 ( .A(
        Inst_SKINNY_Sbox_12_Q294_inst1_InstXOR_1__Compression3_n3), .B(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Reg[17]), .ZN(
        Inst_SKINNY_Sbox_12_M2_out3[2]) );
  XNOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst1_InstXOR_1__Compression3_U1 ( .A(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Reg[15]), .B(
        Inst_SKINNY_Sbox_12_Q294_inst1_CF_Reg[16]), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst1_InstXOR_1__Compression3_n3) );
  DFF_X1 Inst_SKINNY_Sbox_12_Q294_inst2_CF_Reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Out[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_Q294_inst2_CF_Reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Out[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_Q294_inst2_CF_Reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Out[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_Q294_inst2_CF_Reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Out[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_Q294_inst2_CF_Reg_reg_4_ ( .D(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Out[4]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Reg[4]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_Q294_inst2_CF_Reg_reg_5_ ( .D(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Out[5]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Reg[5]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_Q294_inst2_CF_Reg_reg_6_ ( .D(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Out[6]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Reg[6]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_Q294_inst2_CF_Reg_reg_7_ ( .D(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Out[7]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Reg[7]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_Q294_inst2_CF_Reg_reg_8_ ( .D(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Out[8]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Reg[8]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_Q294_inst2_CF_Reg_reg_9_ ( .D(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Out[9]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Reg[9]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_Q294_inst2_CF_Reg_reg_10_ ( .D(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Out[10]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Reg[10]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_Q294_inst2_CF_Reg_reg_11_ ( .D(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Out[11]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Reg[11]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_Q294_inst2_CF_Reg_reg_12_ ( .D(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Out[12]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Reg[12]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_Q294_inst2_CF_Reg_reg_13_ ( .D(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Out[13]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Reg[13]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_Q294_inst2_CF_Reg_reg_14_ ( .D(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Out[14]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Reg[14]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_Q294_inst2_CF_Reg_reg_15_ ( .D(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Out[15]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Reg[15]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_Q294_inst2_CF_Reg_reg_16_ ( .D(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Out[16]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Reg[16]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_Q294_inst2_CF_Reg_reg_17_ ( .D(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Out[17]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Reg[17]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_Q294_inst2_dreg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_12_M2_out2_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_Q294_2_out1[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_Q294_inst2_dreg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_12_M2_out3_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_OutAff_out2[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_Q294_inst2_dreg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_12_M2_out1_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_OutAff_out3[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_Q294_inst2_creg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_12_M2_out2_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_Q294_2_out1[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_Q294_inst2_creg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_12_M2_out3_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_OutAff_out2[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_12_Q294_inst2_creg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_12_M2_out1_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_12_OutAff_out3[2]), .QN() );
  XNOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst2_Inst_0__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_12_Q294_inst2_Inst_0__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_12_M2_out2_reg[0]), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Out[0]) );
  NAND2_X1 Inst_SKINNY_Sbox_12_Q294_inst2_Inst_0__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_12_M2_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_12_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst2_Inst_0__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst2_Inst_1__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_12_Q294_inst2_Inst_1__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_12_Q294_inst2_Inst_1__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Out[1]) );
  NAND2_X1 Inst_SKINNY_Sbox_12_Q294_inst2_Inst_1__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_12_M2_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_12_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst2_Inst_1__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst2_Inst_1__CF_Inst_U1 ( .A(FRESH[12]), 
        .B(FRESH[13]), .Z(Inst_SKINNY_Sbox_12_Q294_inst2_Inst_1__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst2_Inst_2__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_12_Q294_inst2_Inst_2__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_12_Q294_inst2_Inst_2__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Out[2]) );
  NAND2_X1 Inst_SKINNY_Sbox_12_Q294_inst2_Inst_2__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_12_M2_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_12_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst2_Inst_2__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst2_Inst_2__CF_Inst_U1 ( .A(FRESH[13]), 
        .B(FRESH[14]), .Z(Inst_SKINNY_Sbox_12_Q294_inst2_Inst_2__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst2_Inst_3__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_12_Q294_inst2_Inst_3__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_12_M2_out3_reg[0]), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Out[3]) );
  NAND2_X1 Inst_SKINNY_Sbox_12_Q294_inst2_Inst_3__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_12_M2_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_12_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst2_Inst_3__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst2_Inst_4__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_12_Q294_inst2_Inst_4__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_12_Q294_inst2_Inst_4__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Out[4]) );
  NAND2_X1 Inst_SKINNY_Sbox_12_Q294_inst2_Inst_4__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_12_M2_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_12_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst2_Inst_4__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst2_Inst_4__CF_Inst_U1 ( .A(FRESH[14]), 
        .B(FRESH[15]), .Z(Inst_SKINNY_Sbox_12_Q294_inst2_Inst_4__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst2_Inst_5__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_12_Q294_inst2_Inst_5__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_12_Q294_inst2_Inst_5__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Out[5]) );
  NAND2_X1 Inst_SKINNY_Sbox_12_Q294_inst2_Inst_5__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_12_M2_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_12_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst2_Inst_5__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst2_Inst_5__CF_Inst_U1 ( .A(FRESH[15]), 
        .B(FRESH[16]), .Z(Inst_SKINNY_Sbox_12_Q294_inst2_Inst_5__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst2_Inst_6__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_12_Q294_inst2_Inst_6__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_12_M2_out1_reg[0]), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Out[6]) );
  NAND2_X1 Inst_SKINNY_Sbox_12_Q294_inst2_Inst_6__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_12_M2_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_12_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst2_Inst_6__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst2_Inst_7__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_12_Q294_inst2_Inst_7__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_12_Q294_inst2_Inst_7__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Out[7]) );
  NAND2_X1 Inst_SKINNY_Sbox_12_Q294_inst2_Inst_7__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_12_M2_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_12_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst2_Inst_7__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst2_Inst_7__CF_Inst_U1 ( .A(FRESH[16]), 
        .B(FRESH[17]), .Z(Inst_SKINNY_Sbox_12_Q294_inst2_Inst_7__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst2_Inst_8__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_12_Q294_inst2_Inst_8__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_12_Q294_inst2_Inst_8__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Out[8]) );
  NAND2_X1 Inst_SKINNY_Sbox_12_Q294_inst2_Inst_8__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_12_M2_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_12_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst2_Inst_8__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst2_Inst_8__CF_Inst_U1 ( .A(FRESH[17]), 
        .B(FRESH[12]), .Z(Inst_SKINNY_Sbox_12_Q294_inst2_Inst_8__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst2_Inst_9__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_12_Q294_inst2_Inst_9__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_12_M2_out2_reg[1]), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Out[9]) );
  NAND2_X1 Inst_SKINNY_Sbox_12_Q294_inst2_Inst_9__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_12_M2_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_12_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst2_Inst_9__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst2_Inst_10__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_12_Q294_inst2_Inst_10__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_12_Q294_inst2_Inst_10__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Out[10]) );
  NAND2_X1 Inst_SKINNY_Sbox_12_Q294_inst2_Inst_10__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_12_M2_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_12_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst2_Inst_10__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst2_Inst_10__CF_Inst_U1 ( .A(FRESH[18]), 
        .B(FRESH[19]), .Z(Inst_SKINNY_Sbox_12_Q294_inst2_Inst_10__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst2_Inst_11__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_12_Q294_inst2_Inst_11__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_12_Q294_inst2_Inst_11__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Out[11]) );
  NAND2_X1 Inst_SKINNY_Sbox_12_Q294_inst2_Inst_11__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_12_M2_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_12_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst2_Inst_11__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst2_Inst_11__CF_Inst_U1 ( .A(FRESH[19]), 
        .B(FRESH[20]), .Z(Inst_SKINNY_Sbox_12_Q294_inst2_Inst_11__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst2_Inst_12__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_12_Q294_inst2_Inst_12__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_12_M2_out3_reg[1]), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Out[12]) );
  NAND2_X1 Inst_SKINNY_Sbox_12_Q294_inst2_Inst_12__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_12_M2_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_12_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst2_Inst_12__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst2_Inst_13__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_12_Q294_inst2_Inst_13__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_12_Q294_inst2_Inst_13__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Out[13]) );
  NAND2_X1 Inst_SKINNY_Sbox_12_Q294_inst2_Inst_13__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_12_M2_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_12_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst2_Inst_13__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst2_Inst_13__CF_Inst_U1 ( .A(FRESH[20]), 
        .B(FRESH[21]), .Z(Inst_SKINNY_Sbox_12_Q294_inst2_Inst_13__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst2_Inst_14__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_12_Q294_inst2_Inst_14__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_12_Q294_inst2_Inst_14__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Out[14]) );
  NAND2_X1 Inst_SKINNY_Sbox_12_Q294_inst2_Inst_14__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_12_M2_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_12_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst2_Inst_14__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst2_Inst_14__CF_Inst_U1 ( .A(FRESH[21]), 
        .B(FRESH[22]), .Z(Inst_SKINNY_Sbox_12_Q294_inst2_Inst_14__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst2_Inst_15__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_12_Q294_inst2_Inst_15__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_12_M2_out1_reg[1]), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Out[15]) );
  NAND2_X1 Inst_SKINNY_Sbox_12_Q294_inst2_Inst_15__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_12_M2_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_12_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst2_Inst_15__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst2_Inst_16__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_12_Q294_inst2_Inst_16__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_12_Q294_inst2_Inst_16__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Out[16]) );
  NAND2_X1 Inst_SKINNY_Sbox_12_Q294_inst2_Inst_16__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_12_M2_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_12_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst2_Inst_16__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst2_Inst_16__CF_Inst_U1 ( .A(FRESH[22]), 
        .B(FRESH[23]), .Z(Inst_SKINNY_Sbox_12_Q294_inst2_Inst_16__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst2_Inst_17__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_12_Q294_inst2_Inst_17__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_12_Q294_inst2_Inst_17__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Out[17]) );
  NAND2_X1 Inst_SKINNY_Sbox_12_Q294_inst2_Inst_17__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_12_M2_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_12_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst2_Inst_17__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst2_Inst_17__CF_Inst_U1 ( .A(FRESH[23]), 
        .B(FRESH[18]), .Z(Inst_SKINNY_Sbox_12_Q294_inst2_Inst_17__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst2_InstXOR_0__Compression1_U2 ( .A(
        Inst_SKINNY_Sbox_12_Q294_inst2_InstXOR_0__Compression1_n3), .B(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Reg[2]), .ZN(
        Inst_SKINNY_Sbox_12_Q294_2_out1[0]) );
  XNOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst2_InstXOR_0__Compression1_U1 ( .A(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Reg[0]), .B(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Reg[1]), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst2_InstXOR_0__Compression1_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst2_InstXOR_0__Compression2_U2 ( .A(
        Inst_SKINNY_Sbox_12_Q294_inst2_InstXOR_0__Compression2_n3), .B(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Reg[5]), .ZN(
        Inst_SKINNY_Sbox_12_OutAff_out2[1]) );
  XNOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst2_InstXOR_0__Compression2_U1 ( .A(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Reg[3]), .B(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Reg[4]), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst2_InstXOR_0__Compression2_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst2_InstXOR_0__Compression3_U2 ( .A(
        Inst_SKINNY_Sbox_12_Q294_inst2_InstXOR_0__Compression3_n3), .B(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Reg[8]), .ZN(
        Inst_SKINNY_Sbox_12_OutAff_out3[1]) );
  XNOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst2_InstXOR_0__Compression3_U1 ( .A(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Reg[6]), .B(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Reg[7]), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst2_InstXOR_0__Compression3_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst2_InstXOR_1__Compression1_U2 ( .A(
        Inst_SKINNY_Sbox_12_Q294_inst2_InstXOR_1__Compression1_n3), .B(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Reg[11]), .ZN(
        Inst_SKINNY_Sbox_12_Q294_2_out1[1]) );
  XNOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst2_InstXOR_1__Compression1_U1 ( .A(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Reg[9]), .B(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Reg[10]), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst2_InstXOR_1__Compression1_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst2_InstXOR_1__Compression2_U2 ( .A(
        Inst_SKINNY_Sbox_12_Q294_inst2_InstXOR_1__Compression2_n3), .B(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Reg[14]), .ZN(
        Inst_SKINNY_Sbox_12_OutAff_out2[0]) );
  XNOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst2_InstXOR_1__Compression2_U1 ( .A(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Reg[12]), .B(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Reg[13]), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst2_InstXOR_1__Compression2_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst2_InstXOR_1__Compression3_U2 ( .A(
        Inst_SKINNY_Sbox_12_Q294_inst2_InstXOR_1__Compression3_n3), .B(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Reg[17]), .ZN(
        Inst_SKINNY_Sbox_12_OutAff_out3[0]) );
  XNOR2_X1 Inst_SKINNY_Sbox_12_Q294_inst2_InstXOR_1__Compression3_U1 ( .A(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Reg[15]), .B(
        Inst_SKINNY_Sbox_12_Q294_inst2_CF_Reg[16]), .ZN(
        Inst_SKINNY_Sbox_12_Q294_inst2_InstXOR_1__Compression3_n3) );
  INV_X1 Inst_SKINNY_Sbox_12_OutputAffine_U4 ( .A(
        Inst_SKINNY_Sbox_12_Q294_2_out1[3]), .ZN(
        Inst_SKINNY_Sbox_12_OutAff_out1[3]) );
  INV_X1 Inst_SKINNY_Sbox_12_OutputAffine_U3 ( .A(
        Inst_SKINNY_Sbox_12_Q294_2_out1[2]), .ZN(
        Inst_SKINNY_Sbox_12_OutAff_out1[2]) );
  INV_X1 Inst_SKINNY_Sbox_12_OutputAffine_U2 ( .A(
        Inst_SKINNY_Sbox_12_Q294_2_out1[1]), .ZN(
        Inst_SKINNY_Sbox_12_OutAff_out1[0]) );
  INV_X1 Inst_SKINNY_Sbox_12_OutputAffine_U1 ( .A(
        Inst_SKINNY_Sbox_12_Q294_2_out1[0]), .ZN(
        Inst_SKINNY_Sbox_12_OutAff_out1[1]) );
  XNOR2_X1 Inst_SKINNY_Sbox_13_U18 ( .A(Inst_SKINNY_Sbox_13_n12), .B(FRESH[39]), .ZN(SUB_OUT3[55]) );
  XNOR2_X1 Inst_SKINNY_Sbox_13_U17 ( .A(FRESH[35]), .B(
        Inst_SKINNY_Sbox_13_OutAff_out3[3]), .ZN(Inst_SKINNY_Sbox_13_n12) );
  XNOR2_X1 Inst_SKINNY_Sbox_13_U16 ( .A(Inst_SKINNY_Sbox_13_n11), .B(FRESH[38]), .ZN(SUB_OUT3[54]) );
  XNOR2_X1 Inst_SKINNY_Sbox_13_U15 ( .A(FRESH[34]), .B(
        Inst_SKINNY_Sbox_13_OutAff_out3[2]), .ZN(Inst_SKINNY_Sbox_13_n11) );
  XNOR2_X1 Inst_SKINNY_Sbox_13_U14 ( .A(Inst_SKINNY_Sbox_13_n10), .B(FRESH[37]), .ZN(SUB_OUT3[53]) );
  XNOR2_X1 Inst_SKINNY_Sbox_13_U13 ( .A(FRESH[33]), .B(
        Inst_SKINNY_Sbox_13_OutAff_out3[1]), .ZN(Inst_SKINNY_Sbox_13_n10) );
  XNOR2_X1 Inst_SKINNY_Sbox_13_U12 ( .A(Inst_SKINNY_Sbox_13_n9), .B(FRESH[36]), 
        .ZN(SUB_OUT3[52]) );
  XNOR2_X1 Inst_SKINNY_Sbox_13_U11 ( .A(FRESH[32]), .B(
        Inst_SKINNY_Sbox_13_OutAff_out3[0]), .ZN(Inst_SKINNY_Sbox_13_n9) );
  XOR2_X1 Inst_SKINNY_Sbox_13_U10 ( .A(FRESH[39]), .B(
        Inst_SKINNY_Sbox_13_OutAff_out2[3]), .Z(SUB_OUT2[55]) );
  XOR2_X1 Inst_SKINNY_Sbox_13_U9 ( .A(FRESH[38]), .B(
        Inst_SKINNY_Sbox_13_OutAff_out2[2]), .Z(SUB_OUT2[54]) );
  XOR2_X1 Inst_SKINNY_Sbox_13_U8 ( .A(FRESH[37]), .B(
        Inst_SKINNY_Sbox_13_OutAff_out2[1]), .Z(SUB_OUT2[53]) );
  XOR2_X1 Inst_SKINNY_Sbox_13_U7 ( .A(FRESH[36]), .B(
        Inst_SKINNY_Sbox_13_OutAff_out2[0]), .Z(SUB_OUT2[52]) );
  XOR2_X1 Inst_SKINNY_Sbox_13_U6 ( .A(FRESH[35]), .B(
        Inst_SKINNY_Sbox_13_OutAff_out1[3]), .Z(SUB_OUT1[55]) );
  XOR2_X1 Inst_SKINNY_Sbox_13_U5 ( .A(FRESH[34]), .B(
        Inst_SKINNY_Sbox_13_OutAff_out1[2]), .Z(SUB_OUT1[54]) );
  XOR2_X1 Inst_SKINNY_Sbox_13_U4 ( .A(FRESH[33]), .B(
        Inst_SKINNY_Sbox_13_OutAff_out1[1]), .Z(SUB_OUT1[53]) );
  XOR2_X1 Inst_SKINNY_Sbox_13_U3 ( .A(FRESH[32]), .B(
        Inst_SKINNY_Sbox_13_OutAff_out1[0]), .Z(SUB_OUT1[52]) );
  DFF_X1 Inst_SKINNY_Sbox_13_M2_out3_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_13_M2_out3[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_M2_out3_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_M2_out3_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_13_M2_out3[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_M2_out3_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_M2_out3_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_13_M2_out3[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_M2_out3_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_M2_out3_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_13_M2_out3[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_M2_out3_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_M2_out2_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_13_M2_out2[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_M2_out2_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_M2_out2_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_13_M2_out2[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_M2_out2_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_M2_out2_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_13_M2_out2[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_M2_out2_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_M2_out2_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_13_M2_out2[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_M2_out2_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_M2_out1_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_13_M2_out1[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_M2_out1_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_M2_out1_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_13_M2_out1[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_M2_out1_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_M2_out1_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_13_M2_out1[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_M2_out1_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_M2_out1_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_13_M2_out1[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_M2_out1_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_InAff_out3_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_13_InAff_out3[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_InAff_out3_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_InAff_out3_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_13_InAff_out3[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_InAff_out3_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_InAff_out3_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_13_InAff_out3[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_InAff_out3_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_InAff_out3_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_13_InAff_out3[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_InAff_out3_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_InAff_out2_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_13_InAff_out2[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_InAff_out2_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_InAff_out2_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_13_InAff_out2[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_InAff_out2_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_InAff_out2_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_13_InAff_out2[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_InAff_out2_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_InAff_out2_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_13_InAff_out2[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_InAff_out2_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_InAff_out1_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_13_InAff_out1[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_InAff_out1_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_InAff_out1_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_13_InAff_out1[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_InAff_out1_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_InAff_out1_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_13_InAff_out1[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_InAff_out1_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_InAff_out1_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_13_InAff_out1[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_InAff_out1_reg[3]), .QN() );
  INV_X1 Inst_SKINNY_Sbox_13_InputAffine_U4 ( .A(SUB_IN1[55]), .ZN(
        Inst_SKINNY_Sbox_13_InAff_out1[1]) );
  INV_X1 Inst_SKINNY_Sbox_13_InputAffine_U3 ( .A(SUB_IN1[54]), .ZN(
        Inst_SKINNY_Sbox_13_InAff_out1[3]) );
  INV_X1 Inst_SKINNY_Sbox_13_InputAffine_U2 ( .A(SUB_IN1[53]), .ZN(
        Inst_SKINNY_Sbox_13_InAff_out1[2]) );
  INV_X1 Inst_SKINNY_Sbox_13_InputAffine_U1 ( .A(SUB_IN1[52]), .ZN(
        Inst_SKINNY_Sbox_13_InAff_out1[0]) );
  DFF_X1 Inst_SKINNY_Sbox_13_Q294_inst1_CF_Reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Out[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_Q294_inst1_CF_Reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Out[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_Q294_inst1_CF_Reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Out[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_Q294_inst1_CF_Reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Out[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_Q294_inst1_CF_Reg_reg_4_ ( .D(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Out[4]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Reg[4]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_Q294_inst1_CF_Reg_reg_5_ ( .D(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Out[5]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Reg[5]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_Q294_inst1_CF_Reg_reg_6_ ( .D(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Out[6]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Reg[6]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_Q294_inst1_CF_Reg_reg_7_ ( .D(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Out[7]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Reg[7]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_Q294_inst1_CF_Reg_reg_8_ ( .D(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Out[8]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Reg[8]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_Q294_inst1_CF_Reg_reg_9_ ( .D(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Out[9]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Reg[9]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_Q294_inst1_CF_Reg_reg_10_ ( .D(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Out[10]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Reg[10]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_Q294_inst1_CF_Reg_reg_11_ ( .D(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Out[11]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Reg[11]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_Q294_inst1_CF_Reg_reg_12_ ( .D(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Out[12]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Reg[12]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_Q294_inst1_CF_Reg_reg_13_ ( .D(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Out[13]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Reg[13]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_Q294_inst1_CF_Reg_reg_14_ ( .D(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Out[14]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Reg[14]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_Q294_inst1_CF_Reg_reg_15_ ( .D(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Out[15]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Reg[15]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_Q294_inst1_CF_Reg_reg_16_ ( .D(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Out[16]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Reg[16]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_Q294_inst1_CF_Reg_reg_17_ ( .D(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Out[17]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Reg[17]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_Q294_inst1_dreg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_13_InAff_out2_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_M2_out1[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_Q294_inst1_dreg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_13_InAff_out3_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_M2_out2[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_Q294_inst1_dreg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_13_InAff_out1_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_M2_out3[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_Q294_inst1_creg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_13_InAff_out2_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_M2_out1[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_Q294_inst1_creg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_13_InAff_out3_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_M2_out2[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_Q294_inst1_creg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_13_InAff_out1_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_M2_out3[1]), .QN() );
  XNOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst1_Inst_0__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_13_Q294_inst1_Inst_0__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_13_InAff_out2_reg[0]), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Out[0]) );
  NAND2_X1 Inst_SKINNY_Sbox_13_Q294_inst1_Inst_0__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_13_InAff_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_13_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst1_Inst_0__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst1_Inst_1__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_13_Q294_inst1_Inst_1__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_13_Q294_inst1_Inst_1__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Out[1]) );
  NAND2_X1 Inst_SKINNY_Sbox_13_Q294_inst1_Inst_1__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_13_InAff_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_13_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst1_Inst_1__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst1_Inst_1__CF_Inst_U1 ( .A(FRESH[0]), 
        .B(FRESH[1]), .Z(Inst_SKINNY_Sbox_13_Q294_inst1_Inst_1__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst1_Inst_2__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_13_Q294_inst1_Inst_2__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_13_Q294_inst1_Inst_2__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Out[2]) );
  NAND2_X1 Inst_SKINNY_Sbox_13_Q294_inst1_Inst_2__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_13_InAff_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_13_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst1_Inst_2__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst1_Inst_2__CF_Inst_U1 ( .A(FRESH[1]), 
        .B(FRESH[2]), .Z(Inst_SKINNY_Sbox_13_Q294_inst1_Inst_2__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst1_Inst_3__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_13_Q294_inst1_Inst_3__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_13_InAff_out3_reg[0]), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Out[3]) );
  NAND2_X1 Inst_SKINNY_Sbox_13_Q294_inst1_Inst_3__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_13_InAff_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_13_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst1_Inst_3__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst1_Inst_4__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_13_Q294_inst1_Inst_4__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_13_Q294_inst1_Inst_4__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Out[4]) );
  NAND2_X1 Inst_SKINNY_Sbox_13_Q294_inst1_Inst_4__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_13_InAff_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_13_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst1_Inst_4__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst1_Inst_4__CF_Inst_U1 ( .A(FRESH[2]), 
        .B(FRESH[3]), .Z(Inst_SKINNY_Sbox_13_Q294_inst1_Inst_4__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst1_Inst_5__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_13_Q294_inst1_Inst_5__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_13_Q294_inst1_Inst_5__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Out[5]) );
  NAND2_X1 Inst_SKINNY_Sbox_13_Q294_inst1_Inst_5__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_13_InAff_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_13_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst1_Inst_5__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst1_Inst_5__CF_Inst_U1 ( .A(FRESH[3]), 
        .B(FRESH[4]), .Z(Inst_SKINNY_Sbox_13_Q294_inst1_Inst_5__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst1_Inst_6__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_13_Q294_inst1_Inst_6__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_13_InAff_out1_reg[0]), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Out[6]) );
  NAND2_X1 Inst_SKINNY_Sbox_13_Q294_inst1_Inst_6__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_13_InAff_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_13_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst1_Inst_6__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst1_Inst_7__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_13_Q294_inst1_Inst_7__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_13_Q294_inst1_Inst_7__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Out[7]) );
  NAND2_X1 Inst_SKINNY_Sbox_13_Q294_inst1_Inst_7__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_13_InAff_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_13_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst1_Inst_7__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst1_Inst_7__CF_Inst_U1 ( .A(FRESH[4]), 
        .B(FRESH[5]), .Z(Inst_SKINNY_Sbox_13_Q294_inst1_Inst_7__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst1_Inst_8__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_13_Q294_inst1_Inst_8__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_13_Q294_inst1_Inst_8__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Out[8]) );
  NAND2_X1 Inst_SKINNY_Sbox_13_Q294_inst1_Inst_8__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_13_InAff_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_13_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst1_Inst_8__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst1_Inst_8__CF_Inst_U1 ( .A(FRESH[5]), 
        .B(FRESH[0]), .Z(Inst_SKINNY_Sbox_13_Q294_inst1_Inst_8__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst1_Inst_9__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_13_Q294_inst1_Inst_9__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_13_InAff_out2_reg[1]), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Out[9]) );
  NAND2_X1 Inst_SKINNY_Sbox_13_Q294_inst1_Inst_9__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_13_InAff_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_13_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst1_Inst_9__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst1_Inst_10__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_13_Q294_inst1_Inst_10__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_13_Q294_inst1_Inst_10__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Out[10]) );
  NAND2_X1 Inst_SKINNY_Sbox_13_Q294_inst1_Inst_10__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_13_InAff_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_13_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst1_Inst_10__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst1_Inst_10__CF_Inst_U1 ( .A(FRESH[6]), 
        .B(FRESH[7]), .Z(Inst_SKINNY_Sbox_13_Q294_inst1_Inst_10__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst1_Inst_11__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_13_Q294_inst1_Inst_11__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_13_Q294_inst1_Inst_11__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Out[11]) );
  NAND2_X1 Inst_SKINNY_Sbox_13_Q294_inst1_Inst_11__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_13_InAff_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_13_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst1_Inst_11__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst1_Inst_11__CF_Inst_U1 ( .A(FRESH[7]), 
        .B(FRESH[8]), .Z(Inst_SKINNY_Sbox_13_Q294_inst1_Inst_11__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst1_Inst_12__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_13_Q294_inst1_Inst_12__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_13_InAff_out3_reg[1]), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Out[12]) );
  NAND2_X1 Inst_SKINNY_Sbox_13_Q294_inst1_Inst_12__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_13_InAff_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_13_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst1_Inst_12__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst1_Inst_13__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_13_Q294_inst1_Inst_13__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_13_Q294_inst1_Inst_13__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Out[13]) );
  NAND2_X1 Inst_SKINNY_Sbox_13_Q294_inst1_Inst_13__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_13_InAff_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_13_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst1_Inst_13__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst1_Inst_13__CF_Inst_U1 ( .A(FRESH[8]), 
        .B(FRESH[9]), .Z(Inst_SKINNY_Sbox_13_Q294_inst1_Inst_13__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst1_Inst_14__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_13_Q294_inst1_Inst_14__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_13_Q294_inst1_Inst_14__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Out[14]) );
  NAND2_X1 Inst_SKINNY_Sbox_13_Q294_inst1_Inst_14__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_13_InAff_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_13_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst1_Inst_14__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst1_Inst_14__CF_Inst_U1 ( .A(FRESH[9]), 
        .B(FRESH[10]), .Z(Inst_SKINNY_Sbox_13_Q294_inst1_Inst_14__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst1_Inst_15__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_13_Q294_inst1_Inst_15__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_13_InAff_out1_reg[1]), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Out[15]) );
  NAND2_X1 Inst_SKINNY_Sbox_13_Q294_inst1_Inst_15__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_13_InAff_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_13_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst1_Inst_15__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst1_Inst_16__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_13_Q294_inst1_Inst_16__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_13_Q294_inst1_Inst_16__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Out[16]) );
  NAND2_X1 Inst_SKINNY_Sbox_13_Q294_inst1_Inst_16__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_13_InAff_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_13_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst1_Inst_16__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst1_Inst_16__CF_Inst_U1 ( .A(FRESH[10]), 
        .B(FRESH[11]), .Z(Inst_SKINNY_Sbox_13_Q294_inst1_Inst_16__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst1_Inst_17__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_13_Q294_inst1_Inst_17__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_13_Q294_inst1_Inst_17__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Out[17]) );
  NAND2_X1 Inst_SKINNY_Sbox_13_Q294_inst1_Inst_17__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_13_InAff_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_13_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst1_Inst_17__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst1_Inst_17__CF_Inst_U1 ( .A(FRESH[11]), 
        .B(FRESH[6]), .Z(Inst_SKINNY_Sbox_13_Q294_inst1_Inst_17__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst1_InstXOR_0__Compression1_U2 ( .A(
        Inst_SKINNY_Sbox_13_Q294_inst1_InstXOR_0__Compression1_n3), .B(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Reg[2]), .ZN(
        Inst_SKINNY_Sbox_13_M2_out1[3]) );
  XNOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst1_InstXOR_0__Compression1_U1 ( .A(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Reg[0]), .B(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Reg[1]), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst1_InstXOR_0__Compression1_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst1_InstXOR_0__Compression2_U2 ( .A(
        Inst_SKINNY_Sbox_13_Q294_inst1_InstXOR_0__Compression2_n3), .B(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Reg[5]), .ZN(
        Inst_SKINNY_Sbox_13_M2_out2[3]) );
  XNOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst1_InstXOR_0__Compression2_U1 ( .A(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Reg[3]), .B(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Reg[4]), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst1_InstXOR_0__Compression2_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst1_InstXOR_0__Compression3_U2 ( .A(
        Inst_SKINNY_Sbox_13_Q294_inst1_InstXOR_0__Compression3_n3), .B(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Reg[8]), .ZN(
        Inst_SKINNY_Sbox_13_M2_out3[3]) );
  XNOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst1_InstXOR_0__Compression3_U1 ( .A(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Reg[6]), .B(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Reg[7]), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst1_InstXOR_0__Compression3_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst1_InstXOR_1__Compression1_U2 ( .A(
        Inst_SKINNY_Sbox_13_Q294_inst1_InstXOR_1__Compression1_n3), .B(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Reg[11]), .ZN(
        Inst_SKINNY_Sbox_13_M2_out1[2]) );
  XNOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst1_InstXOR_1__Compression1_U1 ( .A(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Reg[9]), .B(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Reg[10]), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst1_InstXOR_1__Compression1_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst1_InstXOR_1__Compression2_U2 ( .A(
        Inst_SKINNY_Sbox_13_Q294_inst1_InstXOR_1__Compression2_n3), .B(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Reg[14]), .ZN(
        Inst_SKINNY_Sbox_13_M2_out2[2]) );
  XNOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst1_InstXOR_1__Compression2_U1 ( .A(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Reg[12]), .B(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Reg[13]), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst1_InstXOR_1__Compression2_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst1_InstXOR_1__Compression3_U2 ( .A(
        Inst_SKINNY_Sbox_13_Q294_inst1_InstXOR_1__Compression3_n3), .B(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Reg[17]), .ZN(
        Inst_SKINNY_Sbox_13_M2_out3[2]) );
  XNOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst1_InstXOR_1__Compression3_U1 ( .A(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Reg[15]), .B(
        Inst_SKINNY_Sbox_13_Q294_inst1_CF_Reg[16]), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst1_InstXOR_1__Compression3_n3) );
  DFF_X1 Inst_SKINNY_Sbox_13_Q294_inst2_CF_Reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Out[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_Q294_inst2_CF_Reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Out[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_Q294_inst2_CF_Reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Out[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_Q294_inst2_CF_Reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Out[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_Q294_inst2_CF_Reg_reg_4_ ( .D(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Out[4]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Reg[4]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_Q294_inst2_CF_Reg_reg_5_ ( .D(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Out[5]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Reg[5]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_Q294_inst2_CF_Reg_reg_6_ ( .D(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Out[6]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Reg[6]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_Q294_inst2_CF_Reg_reg_7_ ( .D(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Out[7]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Reg[7]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_Q294_inst2_CF_Reg_reg_8_ ( .D(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Out[8]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Reg[8]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_Q294_inst2_CF_Reg_reg_9_ ( .D(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Out[9]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Reg[9]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_Q294_inst2_CF_Reg_reg_10_ ( .D(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Out[10]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Reg[10]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_Q294_inst2_CF_Reg_reg_11_ ( .D(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Out[11]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Reg[11]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_Q294_inst2_CF_Reg_reg_12_ ( .D(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Out[12]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Reg[12]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_Q294_inst2_CF_Reg_reg_13_ ( .D(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Out[13]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Reg[13]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_Q294_inst2_CF_Reg_reg_14_ ( .D(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Out[14]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Reg[14]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_Q294_inst2_CF_Reg_reg_15_ ( .D(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Out[15]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Reg[15]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_Q294_inst2_CF_Reg_reg_16_ ( .D(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Out[16]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Reg[16]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_Q294_inst2_CF_Reg_reg_17_ ( .D(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Out[17]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Reg[17]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_Q294_inst2_dreg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_13_M2_out2_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_Q294_2_out1[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_Q294_inst2_dreg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_13_M2_out3_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_OutAff_out2[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_Q294_inst2_dreg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_13_M2_out1_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_OutAff_out3[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_Q294_inst2_creg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_13_M2_out2_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_Q294_2_out1[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_Q294_inst2_creg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_13_M2_out3_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_OutAff_out2[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_13_Q294_inst2_creg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_13_M2_out1_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_13_OutAff_out3[2]), .QN() );
  XNOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst2_Inst_0__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_13_Q294_inst2_Inst_0__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_13_M2_out2_reg[0]), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Out[0]) );
  NAND2_X1 Inst_SKINNY_Sbox_13_Q294_inst2_Inst_0__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_13_M2_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_13_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst2_Inst_0__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst2_Inst_1__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_13_Q294_inst2_Inst_1__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_13_Q294_inst2_Inst_1__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Out[1]) );
  NAND2_X1 Inst_SKINNY_Sbox_13_Q294_inst2_Inst_1__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_13_M2_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_13_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst2_Inst_1__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst2_Inst_1__CF_Inst_U1 ( .A(FRESH[12]), 
        .B(FRESH[13]), .Z(Inst_SKINNY_Sbox_13_Q294_inst2_Inst_1__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst2_Inst_2__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_13_Q294_inst2_Inst_2__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_13_Q294_inst2_Inst_2__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Out[2]) );
  NAND2_X1 Inst_SKINNY_Sbox_13_Q294_inst2_Inst_2__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_13_M2_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_13_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst2_Inst_2__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst2_Inst_2__CF_Inst_U1 ( .A(FRESH[13]), 
        .B(FRESH[14]), .Z(Inst_SKINNY_Sbox_13_Q294_inst2_Inst_2__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst2_Inst_3__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_13_Q294_inst2_Inst_3__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_13_M2_out3_reg[0]), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Out[3]) );
  NAND2_X1 Inst_SKINNY_Sbox_13_Q294_inst2_Inst_3__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_13_M2_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_13_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst2_Inst_3__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst2_Inst_4__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_13_Q294_inst2_Inst_4__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_13_Q294_inst2_Inst_4__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Out[4]) );
  NAND2_X1 Inst_SKINNY_Sbox_13_Q294_inst2_Inst_4__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_13_M2_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_13_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst2_Inst_4__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst2_Inst_4__CF_Inst_U1 ( .A(FRESH[14]), 
        .B(FRESH[15]), .Z(Inst_SKINNY_Sbox_13_Q294_inst2_Inst_4__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst2_Inst_5__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_13_Q294_inst2_Inst_5__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_13_Q294_inst2_Inst_5__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Out[5]) );
  NAND2_X1 Inst_SKINNY_Sbox_13_Q294_inst2_Inst_5__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_13_M2_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_13_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst2_Inst_5__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst2_Inst_5__CF_Inst_U1 ( .A(FRESH[15]), 
        .B(FRESH[16]), .Z(Inst_SKINNY_Sbox_13_Q294_inst2_Inst_5__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst2_Inst_6__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_13_Q294_inst2_Inst_6__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_13_M2_out1_reg[0]), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Out[6]) );
  NAND2_X1 Inst_SKINNY_Sbox_13_Q294_inst2_Inst_6__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_13_M2_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_13_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst2_Inst_6__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst2_Inst_7__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_13_Q294_inst2_Inst_7__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_13_Q294_inst2_Inst_7__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Out[7]) );
  NAND2_X1 Inst_SKINNY_Sbox_13_Q294_inst2_Inst_7__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_13_M2_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_13_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst2_Inst_7__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst2_Inst_7__CF_Inst_U1 ( .A(FRESH[16]), 
        .B(FRESH[17]), .Z(Inst_SKINNY_Sbox_13_Q294_inst2_Inst_7__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst2_Inst_8__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_13_Q294_inst2_Inst_8__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_13_Q294_inst2_Inst_8__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Out[8]) );
  NAND2_X1 Inst_SKINNY_Sbox_13_Q294_inst2_Inst_8__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_13_M2_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_13_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst2_Inst_8__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst2_Inst_8__CF_Inst_U1 ( .A(FRESH[17]), 
        .B(FRESH[12]), .Z(Inst_SKINNY_Sbox_13_Q294_inst2_Inst_8__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst2_Inst_9__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_13_Q294_inst2_Inst_9__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_13_M2_out2_reg[1]), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Out[9]) );
  NAND2_X1 Inst_SKINNY_Sbox_13_Q294_inst2_Inst_9__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_13_M2_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_13_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst2_Inst_9__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst2_Inst_10__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_13_Q294_inst2_Inst_10__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_13_Q294_inst2_Inst_10__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Out[10]) );
  NAND2_X1 Inst_SKINNY_Sbox_13_Q294_inst2_Inst_10__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_13_M2_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_13_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst2_Inst_10__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst2_Inst_10__CF_Inst_U1 ( .A(FRESH[18]), 
        .B(FRESH[19]), .Z(Inst_SKINNY_Sbox_13_Q294_inst2_Inst_10__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst2_Inst_11__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_13_Q294_inst2_Inst_11__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_13_Q294_inst2_Inst_11__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Out[11]) );
  NAND2_X1 Inst_SKINNY_Sbox_13_Q294_inst2_Inst_11__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_13_M2_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_13_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst2_Inst_11__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst2_Inst_11__CF_Inst_U1 ( .A(FRESH[19]), 
        .B(FRESH[20]), .Z(Inst_SKINNY_Sbox_13_Q294_inst2_Inst_11__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst2_Inst_12__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_13_Q294_inst2_Inst_12__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_13_M2_out3_reg[1]), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Out[12]) );
  NAND2_X1 Inst_SKINNY_Sbox_13_Q294_inst2_Inst_12__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_13_M2_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_13_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst2_Inst_12__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst2_Inst_13__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_13_Q294_inst2_Inst_13__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_13_Q294_inst2_Inst_13__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Out[13]) );
  NAND2_X1 Inst_SKINNY_Sbox_13_Q294_inst2_Inst_13__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_13_M2_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_13_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst2_Inst_13__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst2_Inst_13__CF_Inst_U1 ( .A(FRESH[20]), 
        .B(FRESH[21]), .Z(Inst_SKINNY_Sbox_13_Q294_inst2_Inst_13__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst2_Inst_14__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_13_Q294_inst2_Inst_14__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_13_Q294_inst2_Inst_14__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Out[14]) );
  NAND2_X1 Inst_SKINNY_Sbox_13_Q294_inst2_Inst_14__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_13_M2_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_13_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst2_Inst_14__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst2_Inst_14__CF_Inst_U1 ( .A(FRESH[21]), 
        .B(FRESH[22]), .Z(Inst_SKINNY_Sbox_13_Q294_inst2_Inst_14__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst2_Inst_15__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_13_Q294_inst2_Inst_15__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_13_M2_out1_reg[1]), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Out[15]) );
  NAND2_X1 Inst_SKINNY_Sbox_13_Q294_inst2_Inst_15__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_13_M2_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_13_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst2_Inst_15__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst2_Inst_16__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_13_Q294_inst2_Inst_16__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_13_Q294_inst2_Inst_16__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Out[16]) );
  NAND2_X1 Inst_SKINNY_Sbox_13_Q294_inst2_Inst_16__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_13_M2_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_13_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst2_Inst_16__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst2_Inst_16__CF_Inst_U1 ( .A(FRESH[22]), 
        .B(FRESH[23]), .Z(Inst_SKINNY_Sbox_13_Q294_inst2_Inst_16__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst2_Inst_17__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_13_Q294_inst2_Inst_17__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_13_Q294_inst2_Inst_17__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Out[17]) );
  NAND2_X1 Inst_SKINNY_Sbox_13_Q294_inst2_Inst_17__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_13_M2_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_13_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst2_Inst_17__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst2_Inst_17__CF_Inst_U1 ( .A(FRESH[23]), 
        .B(FRESH[18]), .Z(Inst_SKINNY_Sbox_13_Q294_inst2_Inst_17__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst2_InstXOR_0__Compression1_U2 ( .A(
        Inst_SKINNY_Sbox_13_Q294_inst2_InstXOR_0__Compression1_n3), .B(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Reg[2]), .ZN(
        Inst_SKINNY_Sbox_13_Q294_2_out1[0]) );
  XNOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst2_InstXOR_0__Compression1_U1 ( .A(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Reg[0]), .B(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Reg[1]), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst2_InstXOR_0__Compression1_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst2_InstXOR_0__Compression2_U2 ( .A(
        Inst_SKINNY_Sbox_13_Q294_inst2_InstXOR_0__Compression2_n3), .B(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Reg[5]), .ZN(
        Inst_SKINNY_Sbox_13_OutAff_out2[1]) );
  XNOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst2_InstXOR_0__Compression2_U1 ( .A(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Reg[3]), .B(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Reg[4]), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst2_InstXOR_0__Compression2_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst2_InstXOR_0__Compression3_U2 ( .A(
        Inst_SKINNY_Sbox_13_Q294_inst2_InstXOR_0__Compression3_n3), .B(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Reg[8]), .ZN(
        Inst_SKINNY_Sbox_13_OutAff_out3[1]) );
  XNOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst2_InstXOR_0__Compression3_U1 ( .A(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Reg[6]), .B(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Reg[7]), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst2_InstXOR_0__Compression3_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst2_InstXOR_1__Compression1_U2 ( .A(
        Inst_SKINNY_Sbox_13_Q294_inst2_InstXOR_1__Compression1_n3), .B(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Reg[11]), .ZN(
        Inst_SKINNY_Sbox_13_Q294_2_out1[1]) );
  XNOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst2_InstXOR_1__Compression1_U1 ( .A(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Reg[9]), .B(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Reg[10]), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst2_InstXOR_1__Compression1_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst2_InstXOR_1__Compression2_U2 ( .A(
        Inst_SKINNY_Sbox_13_Q294_inst2_InstXOR_1__Compression2_n3), .B(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Reg[14]), .ZN(
        Inst_SKINNY_Sbox_13_OutAff_out2[0]) );
  XNOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst2_InstXOR_1__Compression2_U1 ( .A(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Reg[12]), .B(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Reg[13]), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst2_InstXOR_1__Compression2_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst2_InstXOR_1__Compression3_U2 ( .A(
        Inst_SKINNY_Sbox_13_Q294_inst2_InstXOR_1__Compression3_n3), .B(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Reg[17]), .ZN(
        Inst_SKINNY_Sbox_13_OutAff_out3[0]) );
  XNOR2_X1 Inst_SKINNY_Sbox_13_Q294_inst2_InstXOR_1__Compression3_U1 ( .A(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Reg[15]), .B(
        Inst_SKINNY_Sbox_13_Q294_inst2_CF_Reg[16]), .ZN(
        Inst_SKINNY_Sbox_13_Q294_inst2_InstXOR_1__Compression3_n3) );
  INV_X1 Inst_SKINNY_Sbox_13_OutputAffine_U4 ( .A(
        Inst_SKINNY_Sbox_13_Q294_2_out1[3]), .ZN(
        Inst_SKINNY_Sbox_13_OutAff_out1[3]) );
  INV_X1 Inst_SKINNY_Sbox_13_OutputAffine_U3 ( .A(
        Inst_SKINNY_Sbox_13_Q294_2_out1[2]), .ZN(
        Inst_SKINNY_Sbox_13_OutAff_out1[2]) );
  INV_X1 Inst_SKINNY_Sbox_13_OutputAffine_U2 ( .A(
        Inst_SKINNY_Sbox_13_Q294_2_out1[1]), .ZN(
        Inst_SKINNY_Sbox_13_OutAff_out1[0]) );
  INV_X1 Inst_SKINNY_Sbox_13_OutputAffine_U1 ( .A(
        Inst_SKINNY_Sbox_13_Q294_2_out1[0]), .ZN(
        Inst_SKINNY_Sbox_13_OutAff_out1[1]) );
  XNOR2_X1 Inst_SKINNY_Sbox_14_U18 ( .A(Inst_SKINNY_Sbox_14_n12), .B(FRESH[31]), .ZN(SUB_OUT3[59]) );
  XNOR2_X1 Inst_SKINNY_Sbox_14_U17 ( .A(FRESH[27]), .B(
        Inst_SKINNY_Sbox_14_OutAff_out3[3]), .ZN(Inst_SKINNY_Sbox_14_n12) );
  XNOR2_X1 Inst_SKINNY_Sbox_14_U16 ( .A(Inst_SKINNY_Sbox_14_n11), .B(FRESH[30]), .ZN(SUB_OUT3[58]) );
  XNOR2_X1 Inst_SKINNY_Sbox_14_U15 ( .A(FRESH[26]), .B(
        Inst_SKINNY_Sbox_14_OutAff_out3[2]), .ZN(Inst_SKINNY_Sbox_14_n11) );
  XNOR2_X1 Inst_SKINNY_Sbox_14_U14 ( .A(Inst_SKINNY_Sbox_14_n10), .B(FRESH[29]), .ZN(SUB_OUT3[57]) );
  XNOR2_X1 Inst_SKINNY_Sbox_14_U13 ( .A(FRESH[25]), .B(
        Inst_SKINNY_Sbox_14_OutAff_out3[1]), .ZN(Inst_SKINNY_Sbox_14_n10) );
  XNOR2_X1 Inst_SKINNY_Sbox_14_U12 ( .A(Inst_SKINNY_Sbox_14_n9), .B(FRESH[28]), 
        .ZN(SUB_OUT3[56]) );
  XNOR2_X1 Inst_SKINNY_Sbox_14_U11 ( .A(FRESH[24]), .B(
        Inst_SKINNY_Sbox_14_OutAff_out3[0]), .ZN(Inst_SKINNY_Sbox_14_n9) );
  XOR2_X1 Inst_SKINNY_Sbox_14_U10 ( .A(FRESH[31]), .B(
        Inst_SKINNY_Sbox_14_OutAff_out2[3]), .Z(SUB_OUT2[59]) );
  XOR2_X1 Inst_SKINNY_Sbox_14_U9 ( .A(FRESH[30]), .B(
        Inst_SKINNY_Sbox_14_OutAff_out2[2]), .Z(SUB_OUT2[58]) );
  XOR2_X1 Inst_SKINNY_Sbox_14_U8 ( .A(FRESH[29]), .B(
        Inst_SKINNY_Sbox_14_OutAff_out2[1]), .Z(SUB_OUT2[57]) );
  XOR2_X1 Inst_SKINNY_Sbox_14_U7 ( .A(FRESH[28]), .B(
        Inst_SKINNY_Sbox_14_OutAff_out2[0]), .Z(SUB_OUT2[56]) );
  XOR2_X1 Inst_SKINNY_Sbox_14_U6 ( .A(FRESH[27]), .B(
        Inst_SKINNY_Sbox_14_OutAff_out1[3]), .Z(SUB_OUT1[59]) );
  XOR2_X1 Inst_SKINNY_Sbox_14_U5 ( .A(FRESH[26]), .B(
        Inst_SKINNY_Sbox_14_OutAff_out1[2]), .Z(SUB_OUT1[58]) );
  XOR2_X1 Inst_SKINNY_Sbox_14_U4 ( .A(FRESH[25]), .B(
        Inst_SKINNY_Sbox_14_OutAff_out1[1]), .Z(SUB_OUT1[57]) );
  XOR2_X1 Inst_SKINNY_Sbox_14_U3 ( .A(FRESH[24]), .B(
        Inst_SKINNY_Sbox_14_OutAff_out1[0]), .Z(SUB_OUT1[56]) );
  DFF_X1 Inst_SKINNY_Sbox_14_M2_out3_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_14_M2_out3[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_M2_out3_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_M2_out3_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_14_M2_out3[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_M2_out3_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_M2_out3_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_14_M2_out3[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_M2_out3_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_M2_out3_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_14_M2_out3[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_M2_out3_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_M2_out2_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_14_M2_out2[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_M2_out2_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_M2_out2_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_14_M2_out2[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_M2_out2_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_M2_out2_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_14_M2_out2[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_M2_out2_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_M2_out2_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_14_M2_out2[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_M2_out2_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_M2_out1_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_14_M2_out1[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_M2_out1_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_M2_out1_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_14_M2_out1[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_M2_out1_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_M2_out1_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_14_M2_out1[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_M2_out1_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_M2_out1_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_14_M2_out1[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_M2_out1_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_InAff_out3_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_14_InAff_out3[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_InAff_out3_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_InAff_out3_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_14_InAff_out3[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_InAff_out3_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_InAff_out3_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_14_InAff_out3[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_InAff_out3_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_InAff_out3_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_14_InAff_out3[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_InAff_out3_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_InAff_out2_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_14_InAff_out2[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_InAff_out2_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_InAff_out2_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_14_InAff_out2[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_InAff_out2_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_InAff_out2_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_14_InAff_out2[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_InAff_out2_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_InAff_out2_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_14_InAff_out2[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_InAff_out2_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_InAff_out1_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_14_InAff_out1[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_InAff_out1_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_InAff_out1_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_14_InAff_out1[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_InAff_out1_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_InAff_out1_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_14_InAff_out1[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_InAff_out1_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_InAff_out1_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_14_InAff_out1[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_InAff_out1_reg[3]), .QN() );
  INV_X1 Inst_SKINNY_Sbox_14_InputAffine_U4 ( .A(SUB_IN1[59]), .ZN(
        Inst_SKINNY_Sbox_14_InAff_out1[1]) );
  INV_X1 Inst_SKINNY_Sbox_14_InputAffine_U3 ( .A(SUB_IN1[58]), .ZN(
        Inst_SKINNY_Sbox_14_InAff_out1[3]) );
  INV_X1 Inst_SKINNY_Sbox_14_InputAffine_U2 ( .A(SUB_IN1[57]), .ZN(
        Inst_SKINNY_Sbox_14_InAff_out1[2]) );
  INV_X1 Inst_SKINNY_Sbox_14_InputAffine_U1 ( .A(SUB_IN1[56]), .ZN(
        Inst_SKINNY_Sbox_14_InAff_out1[0]) );
  DFF_X1 Inst_SKINNY_Sbox_14_Q294_inst1_CF_Reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Out[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_Q294_inst1_CF_Reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Out[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_Q294_inst1_CF_Reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Out[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_Q294_inst1_CF_Reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Out[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_Q294_inst1_CF_Reg_reg_4_ ( .D(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Out[4]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Reg[4]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_Q294_inst1_CF_Reg_reg_5_ ( .D(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Out[5]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Reg[5]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_Q294_inst1_CF_Reg_reg_6_ ( .D(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Out[6]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Reg[6]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_Q294_inst1_CF_Reg_reg_7_ ( .D(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Out[7]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Reg[7]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_Q294_inst1_CF_Reg_reg_8_ ( .D(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Out[8]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Reg[8]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_Q294_inst1_CF_Reg_reg_9_ ( .D(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Out[9]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Reg[9]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_Q294_inst1_CF_Reg_reg_10_ ( .D(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Out[10]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Reg[10]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_Q294_inst1_CF_Reg_reg_11_ ( .D(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Out[11]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Reg[11]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_Q294_inst1_CF_Reg_reg_12_ ( .D(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Out[12]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Reg[12]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_Q294_inst1_CF_Reg_reg_13_ ( .D(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Out[13]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Reg[13]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_Q294_inst1_CF_Reg_reg_14_ ( .D(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Out[14]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Reg[14]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_Q294_inst1_CF_Reg_reg_15_ ( .D(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Out[15]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Reg[15]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_Q294_inst1_CF_Reg_reg_16_ ( .D(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Out[16]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Reg[16]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_Q294_inst1_CF_Reg_reg_17_ ( .D(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Out[17]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Reg[17]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_Q294_inst1_dreg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_14_InAff_out2_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_M2_out1[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_Q294_inst1_dreg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_14_InAff_out3_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_M2_out2[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_Q294_inst1_dreg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_14_InAff_out1_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_M2_out3[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_Q294_inst1_creg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_14_InAff_out2_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_M2_out1[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_Q294_inst1_creg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_14_InAff_out3_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_M2_out2[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_Q294_inst1_creg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_14_InAff_out1_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_M2_out3[1]), .QN() );
  XNOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst1_Inst_0__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_14_Q294_inst1_Inst_0__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_14_InAff_out2_reg[0]), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Out[0]) );
  NAND2_X1 Inst_SKINNY_Sbox_14_Q294_inst1_Inst_0__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_14_InAff_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_14_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst1_Inst_0__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst1_Inst_1__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_14_Q294_inst1_Inst_1__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_14_Q294_inst1_Inst_1__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Out[1]) );
  NAND2_X1 Inst_SKINNY_Sbox_14_Q294_inst1_Inst_1__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_14_InAff_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_14_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst1_Inst_1__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst1_Inst_1__CF_Inst_U1 ( .A(FRESH[0]), 
        .B(FRESH[1]), .Z(Inst_SKINNY_Sbox_14_Q294_inst1_Inst_1__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst1_Inst_2__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_14_Q294_inst1_Inst_2__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_14_Q294_inst1_Inst_2__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Out[2]) );
  NAND2_X1 Inst_SKINNY_Sbox_14_Q294_inst1_Inst_2__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_14_InAff_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_14_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst1_Inst_2__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst1_Inst_2__CF_Inst_U1 ( .A(FRESH[1]), 
        .B(FRESH[2]), .Z(Inst_SKINNY_Sbox_14_Q294_inst1_Inst_2__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst1_Inst_3__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_14_Q294_inst1_Inst_3__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_14_InAff_out3_reg[0]), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Out[3]) );
  NAND2_X1 Inst_SKINNY_Sbox_14_Q294_inst1_Inst_3__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_14_InAff_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_14_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst1_Inst_3__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst1_Inst_4__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_14_Q294_inst1_Inst_4__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_14_Q294_inst1_Inst_4__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Out[4]) );
  NAND2_X1 Inst_SKINNY_Sbox_14_Q294_inst1_Inst_4__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_14_InAff_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_14_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst1_Inst_4__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst1_Inst_4__CF_Inst_U1 ( .A(FRESH[2]), 
        .B(FRESH[3]), .Z(Inst_SKINNY_Sbox_14_Q294_inst1_Inst_4__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst1_Inst_5__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_14_Q294_inst1_Inst_5__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_14_Q294_inst1_Inst_5__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Out[5]) );
  NAND2_X1 Inst_SKINNY_Sbox_14_Q294_inst1_Inst_5__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_14_InAff_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_14_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst1_Inst_5__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst1_Inst_5__CF_Inst_U1 ( .A(FRESH[3]), 
        .B(FRESH[4]), .Z(Inst_SKINNY_Sbox_14_Q294_inst1_Inst_5__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst1_Inst_6__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_14_Q294_inst1_Inst_6__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_14_InAff_out1_reg[0]), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Out[6]) );
  NAND2_X1 Inst_SKINNY_Sbox_14_Q294_inst1_Inst_6__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_14_InAff_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_14_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst1_Inst_6__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst1_Inst_7__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_14_Q294_inst1_Inst_7__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_14_Q294_inst1_Inst_7__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Out[7]) );
  NAND2_X1 Inst_SKINNY_Sbox_14_Q294_inst1_Inst_7__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_14_InAff_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_14_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst1_Inst_7__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst1_Inst_7__CF_Inst_U1 ( .A(FRESH[4]), 
        .B(FRESH[5]), .Z(Inst_SKINNY_Sbox_14_Q294_inst1_Inst_7__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst1_Inst_8__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_14_Q294_inst1_Inst_8__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_14_Q294_inst1_Inst_8__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Out[8]) );
  NAND2_X1 Inst_SKINNY_Sbox_14_Q294_inst1_Inst_8__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_14_InAff_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_14_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst1_Inst_8__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst1_Inst_8__CF_Inst_U1 ( .A(FRESH[5]), 
        .B(FRESH[0]), .Z(Inst_SKINNY_Sbox_14_Q294_inst1_Inst_8__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst1_Inst_9__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_14_Q294_inst1_Inst_9__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_14_InAff_out2_reg[1]), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Out[9]) );
  NAND2_X1 Inst_SKINNY_Sbox_14_Q294_inst1_Inst_9__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_14_InAff_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_14_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst1_Inst_9__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst1_Inst_10__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_14_Q294_inst1_Inst_10__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_14_Q294_inst1_Inst_10__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Out[10]) );
  NAND2_X1 Inst_SKINNY_Sbox_14_Q294_inst1_Inst_10__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_14_InAff_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_14_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst1_Inst_10__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst1_Inst_10__CF_Inst_U1 ( .A(FRESH[6]), 
        .B(FRESH[7]), .Z(Inst_SKINNY_Sbox_14_Q294_inst1_Inst_10__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst1_Inst_11__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_14_Q294_inst1_Inst_11__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_14_Q294_inst1_Inst_11__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Out[11]) );
  NAND2_X1 Inst_SKINNY_Sbox_14_Q294_inst1_Inst_11__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_14_InAff_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_14_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst1_Inst_11__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst1_Inst_11__CF_Inst_U1 ( .A(FRESH[7]), 
        .B(FRESH[8]), .Z(Inst_SKINNY_Sbox_14_Q294_inst1_Inst_11__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst1_Inst_12__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_14_Q294_inst1_Inst_12__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_14_InAff_out3_reg[1]), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Out[12]) );
  NAND2_X1 Inst_SKINNY_Sbox_14_Q294_inst1_Inst_12__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_14_InAff_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_14_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst1_Inst_12__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst1_Inst_13__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_14_Q294_inst1_Inst_13__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_14_Q294_inst1_Inst_13__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Out[13]) );
  NAND2_X1 Inst_SKINNY_Sbox_14_Q294_inst1_Inst_13__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_14_InAff_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_14_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst1_Inst_13__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst1_Inst_13__CF_Inst_U1 ( .A(FRESH[8]), 
        .B(FRESH[9]), .Z(Inst_SKINNY_Sbox_14_Q294_inst1_Inst_13__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst1_Inst_14__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_14_Q294_inst1_Inst_14__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_14_Q294_inst1_Inst_14__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Out[14]) );
  NAND2_X1 Inst_SKINNY_Sbox_14_Q294_inst1_Inst_14__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_14_InAff_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_14_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst1_Inst_14__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst1_Inst_14__CF_Inst_U1 ( .A(FRESH[9]), 
        .B(FRESH[10]), .Z(Inst_SKINNY_Sbox_14_Q294_inst1_Inst_14__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst1_Inst_15__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_14_Q294_inst1_Inst_15__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_14_InAff_out1_reg[1]), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Out[15]) );
  NAND2_X1 Inst_SKINNY_Sbox_14_Q294_inst1_Inst_15__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_14_InAff_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_14_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst1_Inst_15__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst1_Inst_16__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_14_Q294_inst1_Inst_16__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_14_Q294_inst1_Inst_16__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Out[16]) );
  NAND2_X1 Inst_SKINNY_Sbox_14_Q294_inst1_Inst_16__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_14_InAff_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_14_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst1_Inst_16__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst1_Inst_16__CF_Inst_U1 ( .A(FRESH[10]), 
        .B(FRESH[11]), .Z(Inst_SKINNY_Sbox_14_Q294_inst1_Inst_16__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst1_Inst_17__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_14_Q294_inst1_Inst_17__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_14_Q294_inst1_Inst_17__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Out[17]) );
  NAND2_X1 Inst_SKINNY_Sbox_14_Q294_inst1_Inst_17__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_14_InAff_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_14_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst1_Inst_17__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst1_Inst_17__CF_Inst_U1 ( .A(FRESH[11]), 
        .B(FRESH[6]), .Z(Inst_SKINNY_Sbox_14_Q294_inst1_Inst_17__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst1_InstXOR_0__Compression1_U2 ( .A(
        Inst_SKINNY_Sbox_14_Q294_inst1_InstXOR_0__Compression1_n3), .B(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Reg[2]), .ZN(
        Inst_SKINNY_Sbox_14_M2_out1[3]) );
  XNOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst1_InstXOR_0__Compression1_U1 ( .A(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Reg[0]), .B(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Reg[1]), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst1_InstXOR_0__Compression1_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst1_InstXOR_0__Compression2_U2 ( .A(
        Inst_SKINNY_Sbox_14_Q294_inst1_InstXOR_0__Compression2_n3), .B(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Reg[5]), .ZN(
        Inst_SKINNY_Sbox_14_M2_out2[3]) );
  XNOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst1_InstXOR_0__Compression2_U1 ( .A(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Reg[3]), .B(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Reg[4]), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst1_InstXOR_0__Compression2_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst1_InstXOR_0__Compression3_U2 ( .A(
        Inst_SKINNY_Sbox_14_Q294_inst1_InstXOR_0__Compression3_n3), .B(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Reg[8]), .ZN(
        Inst_SKINNY_Sbox_14_M2_out3[3]) );
  XNOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst1_InstXOR_0__Compression3_U1 ( .A(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Reg[6]), .B(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Reg[7]), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst1_InstXOR_0__Compression3_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst1_InstXOR_1__Compression1_U2 ( .A(
        Inst_SKINNY_Sbox_14_Q294_inst1_InstXOR_1__Compression1_n3), .B(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Reg[11]), .ZN(
        Inst_SKINNY_Sbox_14_M2_out1[2]) );
  XNOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst1_InstXOR_1__Compression1_U1 ( .A(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Reg[9]), .B(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Reg[10]), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst1_InstXOR_1__Compression1_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst1_InstXOR_1__Compression2_U2 ( .A(
        Inst_SKINNY_Sbox_14_Q294_inst1_InstXOR_1__Compression2_n3), .B(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Reg[14]), .ZN(
        Inst_SKINNY_Sbox_14_M2_out2[2]) );
  XNOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst1_InstXOR_1__Compression2_U1 ( .A(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Reg[12]), .B(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Reg[13]), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst1_InstXOR_1__Compression2_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst1_InstXOR_1__Compression3_U2 ( .A(
        Inst_SKINNY_Sbox_14_Q294_inst1_InstXOR_1__Compression3_n3), .B(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Reg[17]), .ZN(
        Inst_SKINNY_Sbox_14_M2_out3[2]) );
  XNOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst1_InstXOR_1__Compression3_U1 ( .A(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Reg[15]), .B(
        Inst_SKINNY_Sbox_14_Q294_inst1_CF_Reg[16]), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst1_InstXOR_1__Compression3_n3) );
  DFF_X1 Inst_SKINNY_Sbox_14_Q294_inst2_CF_Reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Out[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_Q294_inst2_CF_Reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Out[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_Q294_inst2_CF_Reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Out[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_Q294_inst2_CF_Reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Out[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_Q294_inst2_CF_Reg_reg_4_ ( .D(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Out[4]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Reg[4]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_Q294_inst2_CF_Reg_reg_5_ ( .D(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Out[5]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Reg[5]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_Q294_inst2_CF_Reg_reg_6_ ( .D(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Out[6]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Reg[6]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_Q294_inst2_CF_Reg_reg_7_ ( .D(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Out[7]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Reg[7]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_Q294_inst2_CF_Reg_reg_8_ ( .D(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Out[8]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Reg[8]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_Q294_inst2_CF_Reg_reg_9_ ( .D(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Out[9]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Reg[9]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_Q294_inst2_CF_Reg_reg_10_ ( .D(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Out[10]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Reg[10]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_Q294_inst2_CF_Reg_reg_11_ ( .D(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Out[11]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Reg[11]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_Q294_inst2_CF_Reg_reg_12_ ( .D(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Out[12]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Reg[12]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_Q294_inst2_CF_Reg_reg_13_ ( .D(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Out[13]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Reg[13]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_Q294_inst2_CF_Reg_reg_14_ ( .D(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Out[14]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Reg[14]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_Q294_inst2_CF_Reg_reg_15_ ( .D(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Out[15]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Reg[15]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_Q294_inst2_CF_Reg_reg_16_ ( .D(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Out[16]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Reg[16]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_Q294_inst2_CF_Reg_reg_17_ ( .D(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Out[17]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Reg[17]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_Q294_inst2_dreg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_14_M2_out2_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_Q294_2_out1[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_Q294_inst2_dreg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_14_M2_out3_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_OutAff_out2[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_Q294_inst2_dreg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_14_M2_out1_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_OutAff_out3[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_Q294_inst2_creg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_14_M2_out2_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_Q294_2_out1[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_Q294_inst2_creg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_14_M2_out3_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_OutAff_out2[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_14_Q294_inst2_creg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_14_M2_out1_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_14_OutAff_out3[2]), .QN() );
  XNOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst2_Inst_0__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_14_Q294_inst2_Inst_0__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_14_M2_out2_reg[0]), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Out[0]) );
  NAND2_X1 Inst_SKINNY_Sbox_14_Q294_inst2_Inst_0__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_14_M2_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_14_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst2_Inst_0__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst2_Inst_1__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_14_Q294_inst2_Inst_1__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_14_Q294_inst2_Inst_1__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Out[1]) );
  NAND2_X1 Inst_SKINNY_Sbox_14_Q294_inst2_Inst_1__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_14_M2_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_14_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst2_Inst_1__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst2_Inst_1__CF_Inst_U1 ( .A(FRESH[12]), 
        .B(FRESH[13]), .Z(Inst_SKINNY_Sbox_14_Q294_inst2_Inst_1__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst2_Inst_2__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_14_Q294_inst2_Inst_2__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_14_Q294_inst2_Inst_2__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Out[2]) );
  NAND2_X1 Inst_SKINNY_Sbox_14_Q294_inst2_Inst_2__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_14_M2_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_14_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst2_Inst_2__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst2_Inst_2__CF_Inst_U1 ( .A(FRESH[13]), 
        .B(FRESH[14]), .Z(Inst_SKINNY_Sbox_14_Q294_inst2_Inst_2__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst2_Inst_3__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_14_Q294_inst2_Inst_3__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_14_M2_out3_reg[0]), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Out[3]) );
  NAND2_X1 Inst_SKINNY_Sbox_14_Q294_inst2_Inst_3__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_14_M2_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_14_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst2_Inst_3__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst2_Inst_4__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_14_Q294_inst2_Inst_4__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_14_Q294_inst2_Inst_4__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Out[4]) );
  NAND2_X1 Inst_SKINNY_Sbox_14_Q294_inst2_Inst_4__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_14_M2_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_14_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst2_Inst_4__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst2_Inst_4__CF_Inst_U1 ( .A(FRESH[14]), 
        .B(FRESH[15]), .Z(Inst_SKINNY_Sbox_14_Q294_inst2_Inst_4__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst2_Inst_5__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_14_Q294_inst2_Inst_5__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_14_Q294_inst2_Inst_5__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Out[5]) );
  NAND2_X1 Inst_SKINNY_Sbox_14_Q294_inst2_Inst_5__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_14_M2_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_14_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst2_Inst_5__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst2_Inst_5__CF_Inst_U1 ( .A(FRESH[15]), 
        .B(FRESH[16]), .Z(Inst_SKINNY_Sbox_14_Q294_inst2_Inst_5__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst2_Inst_6__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_14_Q294_inst2_Inst_6__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_14_M2_out1_reg[0]), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Out[6]) );
  NAND2_X1 Inst_SKINNY_Sbox_14_Q294_inst2_Inst_6__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_14_M2_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_14_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst2_Inst_6__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst2_Inst_7__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_14_Q294_inst2_Inst_7__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_14_Q294_inst2_Inst_7__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Out[7]) );
  NAND2_X1 Inst_SKINNY_Sbox_14_Q294_inst2_Inst_7__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_14_M2_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_14_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst2_Inst_7__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst2_Inst_7__CF_Inst_U1 ( .A(FRESH[16]), 
        .B(FRESH[17]), .Z(Inst_SKINNY_Sbox_14_Q294_inst2_Inst_7__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst2_Inst_8__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_14_Q294_inst2_Inst_8__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_14_Q294_inst2_Inst_8__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Out[8]) );
  NAND2_X1 Inst_SKINNY_Sbox_14_Q294_inst2_Inst_8__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_14_M2_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_14_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst2_Inst_8__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst2_Inst_8__CF_Inst_U1 ( .A(FRESH[17]), 
        .B(FRESH[12]), .Z(Inst_SKINNY_Sbox_14_Q294_inst2_Inst_8__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst2_Inst_9__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_14_Q294_inst2_Inst_9__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_14_M2_out2_reg[1]), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Out[9]) );
  NAND2_X1 Inst_SKINNY_Sbox_14_Q294_inst2_Inst_9__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_14_M2_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_14_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst2_Inst_9__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst2_Inst_10__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_14_Q294_inst2_Inst_10__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_14_Q294_inst2_Inst_10__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Out[10]) );
  NAND2_X1 Inst_SKINNY_Sbox_14_Q294_inst2_Inst_10__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_14_M2_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_14_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst2_Inst_10__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst2_Inst_10__CF_Inst_U1 ( .A(FRESH[18]), 
        .B(FRESH[19]), .Z(Inst_SKINNY_Sbox_14_Q294_inst2_Inst_10__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst2_Inst_11__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_14_Q294_inst2_Inst_11__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_14_Q294_inst2_Inst_11__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Out[11]) );
  NAND2_X1 Inst_SKINNY_Sbox_14_Q294_inst2_Inst_11__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_14_M2_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_14_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst2_Inst_11__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst2_Inst_11__CF_Inst_U1 ( .A(FRESH[19]), 
        .B(FRESH[20]), .Z(Inst_SKINNY_Sbox_14_Q294_inst2_Inst_11__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst2_Inst_12__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_14_Q294_inst2_Inst_12__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_14_M2_out3_reg[1]), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Out[12]) );
  NAND2_X1 Inst_SKINNY_Sbox_14_Q294_inst2_Inst_12__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_14_M2_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_14_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst2_Inst_12__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst2_Inst_13__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_14_Q294_inst2_Inst_13__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_14_Q294_inst2_Inst_13__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Out[13]) );
  NAND2_X1 Inst_SKINNY_Sbox_14_Q294_inst2_Inst_13__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_14_M2_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_14_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst2_Inst_13__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst2_Inst_13__CF_Inst_U1 ( .A(FRESH[20]), 
        .B(FRESH[21]), .Z(Inst_SKINNY_Sbox_14_Q294_inst2_Inst_13__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst2_Inst_14__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_14_Q294_inst2_Inst_14__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_14_Q294_inst2_Inst_14__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Out[14]) );
  NAND2_X1 Inst_SKINNY_Sbox_14_Q294_inst2_Inst_14__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_14_M2_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_14_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst2_Inst_14__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst2_Inst_14__CF_Inst_U1 ( .A(FRESH[21]), 
        .B(FRESH[22]), .Z(Inst_SKINNY_Sbox_14_Q294_inst2_Inst_14__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst2_Inst_15__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_14_Q294_inst2_Inst_15__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_14_M2_out1_reg[1]), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Out[15]) );
  NAND2_X1 Inst_SKINNY_Sbox_14_Q294_inst2_Inst_15__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_14_M2_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_14_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst2_Inst_15__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst2_Inst_16__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_14_Q294_inst2_Inst_16__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_14_Q294_inst2_Inst_16__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Out[16]) );
  NAND2_X1 Inst_SKINNY_Sbox_14_Q294_inst2_Inst_16__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_14_M2_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_14_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst2_Inst_16__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst2_Inst_16__CF_Inst_U1 ( .A(FRESH[22]), 
        .B(FRESH[23]), .Z(Inst_SKINNY_Sbox_14_Q294_inst2_Inst_16__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst2_Inst_17__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_14_Q294_inst2_Inst_17__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_14_Q294_inst2_Inst_17__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Out[17]) );
  NAND2_X1 Inst_SKINNY_Sbox_14_Q294_inst2_Inst_17__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_14_M2_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_14_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst2_Inst_17__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst2_Inst_17__CF_Inst_U1 ( .A(FRESH[23]), 
        .B(FRESH[18]), .Z(Inst_SKINNY_Sbox_14_Q294_inst2_Inst_17__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst2_InstXOR_0__Compression1_U2 ( .A(
        Inst_SKINNY_Sbox_14_Q294_inst2_InstXOR_0__Compression1_n3), .B(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Reg[2]), .ZN(
        Inst_SKINNY_Sbox_14_Q294_2_out1[0]) );
  XNOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst2_InstXOR_0__Compression1_U1 ( .A(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Reg[0]), .B(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Reg[1]), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst2_InstXOR_0__Compression1_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst2_InstXOR_0__Compression2_U2 ( .A(
        Inst_SKINNY_Sbox_14_Q294_inst2_InstXOR_0__Compression2_n3), .B(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Reg[5]), .ZN(
        Inst_SKINNY_Sbox_14_OutAff_out2[1]) );
  XNOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst2_InstXOR_0__Compression2_U1 ( .A(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Reg[3]), .B(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Reg[4]), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst2_InstXOR_0__Compression2_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst2_InstXOR_0__Compression3_U2 ( .A(
        Inst_SKINNY_Sbox_14_Q294_inst2_InstXOR_0__Compression3_n3), .B(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Reg[8]), .ZN(
        Inst_SKINNY_Sbox_14_OutAff_out3[1]) );
  XNOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst2_InstXOR_0__Compression3_U1 ( .A(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Reg[6]), .B(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Reg[7]), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst2_InstXOR_0__Compression3_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst2_InstXOR_1__Compression1_U2 ( .A(
        Inst_SKINNY_Sbox_14_Q294_inst2_InstXOR_1__Compression1_n3), .B(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Reg[11]), .ZN(
        Inst_SKINNY_Sbox_14_Q294_2_out1[1]) );
  XNOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst2_InstXOR_1__Compression1_U1 ( .A(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Reg[9]), .B(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Reg[10]), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst2_InstXOR_1__Compression1_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst2_InstXOR_1__Compression2_U2 ( .A(
        Inst_SKINNY_Sbox_14_Q294_inst2_InstXOR_1__Compression2_n3), .B(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Reg[14]), .ZN(
        Inst_SKINNY_Sbox_14_OutAff_out2[0]) );
  XNOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst2_InstXOR_1__Compression2_U1 ( .A(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Reg[12]), .B(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Reg[13]), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst2_InstXOR_1__Compression2_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst2_InstXOR_1__Compression3_U2 ( .A(
        Inst_SKINNY_Sbox_14_Q294_inst2_InstXOR_1__Compression3_n3), .B(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Reg[17]), .ZN(
        Inst_SKINNY_Sbox_14_OutAff_out3[0]) );
  XNOR2_X1 Inst_SKINNY_Sbox_14_Q294_inst2_InstXOR_1__Compression3_U1 ( .A(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Reg[15]), .B(
        Inst_SKINNY_Sbox_14_Q294_inst2_CF_Reg[16]), .ZN(
        Inst_SKINNY_Sbox_14_Q294_inst2_InstXOR_1__Compression3_n3) );
  INV_X1 Inst_SKINNY_Sbox_14_OutputAffine_U4 ( .A(
        Inst_SKINNY_Sbox_14_Q294_2_out1[3]), .ZN(
        Inst_SKINNY_Sbox_14_OutAff_out1[3]) );
  INV_X1 Inst_SKINNY_Sbox_14_OutputAffine_U3 ( .A(
        Inst_SKINNY_Sbox_14_Q294_2_out1[2]), .ZN(
        Inst_SKINNY_Sbox_14_OutAff_out1[2]) );
  INV_X1 Inst_SKINNY_Sbox_14_OutputAffine_U2 ( .A(
        Inst_SKINNY_Sbox_14_Q294_2_out1[1]), .ZN(
        Inst_SKINNY_Sbox_14_OutAff_out1[0]) );
  INV_X1 Inst_SKINNY_Sbox_14_OutputAffine_U1 ( .A(
        Inst_SKINNY_Sbox_14_Q294_2_out1[0]), .ZN(
        Inst_SKINNY_Sbox_14_OutAff_out1[1]) );
  XNOR2_X1 Inst_SKINNY_Sbox_15_U18 ( .A(Inst_SKINNY_Sbox_15_n12), .B(FRESH[39]), .ZN(SUB_OUT3[63]) );
  XNOR2_X1 Inst_SKINNY_Sbox_15_U17 ( .A(FRESH[35]), .B(
        Inst_SKINNY_Sbox_15_OutAff_out3[3]), .ZN(Inst_SKINNY_Sbox_15_n12) );
  XNOR2_X1 Inst_SKINNY_Sbox_15_U16 ( .A(Inst_SKINNY_Sbox_15_n11), .B(FRESH[38]), .ZN(SUB_OUT3[62]) );
  XNOR2_X1 Inst_SKINNY_Sbox_15_U15 ( .A(FRESH[34]), .B(
        Inst_SKINNY_Sbox_15_OutAff_out3[2]), .ZN(Inst_SKINNY_Sbox_15_n11) );
  XNOR2_X1 Inst_SKINNY_Sbox_15_U14 ( .A(Inst_SKINNY_Sbox_15_n10), .B(FRESH[37]), .ZN(SUB_OUT3[61]) );
  XNOR2_X1 Inst_SKINNY_Sbox_15_U13 ( .A(FRESH[33]), .B(
        Inst_SKINNY_Sbox_15_OutAff_out3[1]), .ZN(Inst_SKINNY_Sbox_15_n10) );
  XNOR2_X1 Inst_SKINNY_Sbox_15_U12 ( .A(Inst_SKINNY_Sbox_15_n9), .B(FRESH[36]), 
        .ZN(SUB_OUT3[60]) );
  XNOR2_X1 Inst_SKINNY_Sbox_15_U11 ( .A(FRESH[32]), .B(
        Inst_SKINNY_Sbox_15_OutAff_out3[0]), .ZN(Inst_SKINNY_Sbox_15_n9) );
  XOR2_X1 Inst_SKINNY_Sbox_15_U10 ( .A(FRESH[39]), .B(
        Inst_SKINNY_Sbox_15_OutAff_out2[3]), .Z(SUB_OUT2[63]) );
  XOR2_X1 Inst_SKINNY_Sbox_15_U9 ( .A(FRESH[38]), .B(
        Inst_SKINNY_Sbox_15_OutAff_out2[2]), .Z(SUB_OUT2[62]) );
  XOR2_X1 Inst_SKINNY_Sbox_15_U8 ( .A(FRESH[37]), .B(
        Inst_SKINNY_Sbox_15_OutAff_out2[1]), .Z(SUB_OUT2[61]) );
  XOR2_X1 Inst_SKINNY_Sbox_15_U7 ( .A(FRESH[36]), .B(
        Inst_SKINNY_Sbox_15_OutAff_out2[0]), .Z(SUB_OUT2[60]) );
  XOR2_X1 Inst_SKINNY_Sbox_15_U6 ( .A(FRESH[35]), .B(
        Inst_SKINNY_Sbox_15_OutAff_out1[3]), .Z(SUB_OUT1[63]) );
  XOR2_X1 Inst_SKINNY_Sbox_15_U5 ( .A(FRESH[34]), .B(
        Inst_SKINNY_Sbox_15_OutAff_out1[2]), .Z(SUB_OUT1[62]) );
  XOR2_X1 Inst_SKINNY_Sbox_15_U4 ( .A(FRESH[33]), .B(
        Inst_SKINNY_Sbox_15_OutAff_out1[1]), .Z(SUB_OUT1[61]) );
  XOR2_X1 Inst_SKINNY_Sbox_15_U3 ( .A(FRESH[32]), .B(
        Inst_SKINNY_Sbox_15_OutAff_out1[0]), .Z(SUB_OUT1[60]) );
  DFF_X1 Inst_SKINNY_Sbox_15_M2_out3_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_15_M2_out3[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_M2_out3_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_M2_out3_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_15_M2_out3[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_M2_out3_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_M2_out3_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_15_M2_out3[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_M2_out3_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_M2_out3_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_15_M2_out3[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_M2_out3_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_M2_out2_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_15_M2_out2[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_M2_out2_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_M2_out2_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_15_M2_out2[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_M2_out2_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_M2_out2_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_15_M2_out2[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_M2_out2_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_M2_out2_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_15_M2_out2[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_M2_out2_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_M2_out1_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_15_M2_out1[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_M2_out1_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_M2_out1_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_15_M2_out1[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_M2_out1_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_M2_out1_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_15_M2_out1[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_M2_out1_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_M2_out1_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_15_M2_out1[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_M2_out1_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_InAff_out3_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_15_InAff_out3[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_InAff_out3_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_InAff_out3_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_15_InAff_out3[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_InAff_out3_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_InAff_out3_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_15_InAff_out3[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_InAff_out3_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_InAff_out3_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_15_InAff_out3[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_InAff_out3_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_InAff_out2_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_15_InAff_out2[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_InAff_out2_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_InAff_out2_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_15_InAff_out2[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_InAff_out2_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_InAff_out2_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_15_InAff_out2[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_InAff_out2_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_InAff_out2_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_15_InAff_out2[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_InAff_out2_reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_InAff_out1_reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_15_InAff_out1[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_InAff_out1_reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_InAff_out1_reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_15_InAff_out1[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_InAff_out1_reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_InAff_out1_reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_15_InAff_out1[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_InAff_out1_reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_InAff_out1_reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_15_InAff_out1[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_InAff_out1_reg[3]), .QN() );
  INV_X1 Inst_SKINNY_Sbox_15_InputAffine_U4 ( .A(SUB_IN1[63]), .ZN(
        Inst_SKINNY_Sbox_15_InAff_out1[1]) );
  INV_X1 Inst_SKINNY_Sbox_15_InputAffine_U3 ( .A(SUB_IN1[62]), .ZN(
        Inst_SKINNY_Sbox_15_InAff_out1[3]) );
  INV_X1 Inst_SKINNY_Sbox_15_InputAffine_U2 ( .A(SUB_IN1[61]), .ZN(
        Inst_SKINNY_Sbox_15_InAff_out1[2]) );
  INV_X1 Inst_SKINNY_Sbox_15_InputAffine_U1 ( .A(SUB_IN1[60]), .ZN(
        Inst_SKINNY_Sbox_15_InAff_out1[0]) );
  DFF_X1 Inst_SKINNY_Sbox_15_Q294_inst1_CF_Reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Out[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_Q294_inst1_CF_Reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Out[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_Q294_inst1_CF_Reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Out[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_Q294_inst1_CF_Reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Out[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_Q294_inst1_CF_Reg_reg_4_ ( .D(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Out[4]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Reg[4]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_Q294_inst1_CF_Reg_reg_5_ ( .D(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Out[5]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Reg[5]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_Q294_inst1_CF_Reg_reg_6_ ( .D(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Out[6]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Reg[6]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_Q294_inst1_CF_Reg_reg_7_ ( .D(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Out[7]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Reg[7]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_Q294_inst1_CF_Reg_reg_8_ ( .D(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Out[8]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Reg[8]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_Q294_inst1_CF_Reg_reg_9_ ( .D(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Out[9]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Reg[9]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_Q294_inst1_CF_Reg_reg_10_ ( .D(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Out[10]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Reg[10]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_Q294_inst1_CF_Reg_reg_11_ ( .D(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Out[11]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Reg[11]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_Q294_inst1_CF_Reg_reg_12_ ( .D(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Out[12]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Reg[12]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_Q294_inst1_CF_Reg_reg_13_ ( .D(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Out[13]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Reg[13]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_Q294_inst1_CF_Reg_reg_14_ ( .D(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Out[14]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Reg[14]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_Q294_inst1_CF_Reg_reg_15_ ( .D(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Out[15]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Reg[15]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_Q294_inst1_CF_Reg_reg_16_ ( .D(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Out[16]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Reg[16]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_Q294_inst1_CF_Reg_reg_17_ ( .D(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Out[17]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Reg[17]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_Q294_inst1_dreg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_15_InAff_out2_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_M2_out1[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_Q294_inst1_dreg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_15_InAff_out3_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_M2_out2[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_Q294_inst1_dreg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_15_InAff_out1_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_M2_out3[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_Q294_inst1_creg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_15_InAff_out2_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_M2_out1[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_Q294_inst1_creg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_15_InAff_out3_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_M2_out2[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_Q294_inst1_creg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_15_InAff_out1_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_M2_out3[1]), .QN() );
  XNOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst1_Inst_0__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_15_Q294_inst1_Inst_0__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_15_InAff_out2_reg[0]), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Out[0]) );
  NAND2_X1 Inst_SKINNY_Sbox_15_Q294_inst1_Inst_0__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_15_InAff_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_15_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst1_Inst_0__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst1_Inst_1__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_15_Q294_inst1_Inst_1__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_15_Q294_inst1_Inst_1__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Out[1]) );
  NAND2_X1 Inst_SKINNY_Sbox_15_Q294_inst1_Inst_1__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_15_InAff_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_15_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst1_Inst_1__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst1_Inst_1__CF_Inst_U1 ( .A(FRESH[0]), 
        .B(FRESH[1]), .Z(Inst_SKINNY_Sbox_15_Q294_inst1_Inst_1__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst1_Inst_2__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_15_Q294_inst1_Inst_2__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_15_Q294_inst1_Inst_2__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Out[2]) );
  NAND2_X1 Inst_SKINNY_Sbox_15_Q294_inst1_Inst_2__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_15_InAff_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_15_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst1_Inst_2__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst1_Inst_2__CF_Inst_U1 ( .A(FRESH[1]), 
        .B(FRESH[2]), .Z(Inst_SKINNY_Sbox_15_Q294_inst1_Inst_2__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst1_Inst_3__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_15_Q294_inst1_Inst_3__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_15_InAff_out3_reg[0]), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Out[3]) );
  NAND2_X1 Inst_SKINNY_Sbox_15_Q294_inst1_Inst_3__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_15_InAff_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_15_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst1_Inst_3__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst1_Inst_4__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_15_Q294_inst1_Inst_4__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_15_Q294_inst1_Inst_4__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Out[4]) );
  NAND2_X1 Inst_SKINNY_Sbox_15_Q294_inst1_Inst_4__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_15_InAff_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_15_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst1_Inst_4__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst1_Inst_4__CF_Inst_U1 ( .A(FRESH[2]), 
        .B(FRESH[3]), .Z(Inst_SKINNY_Sbox_15_Q294_inst1_Inst_4__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst1_Inst_5__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_15_Q294_inst1_Inst_5__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_15_Q294_inst1_Inst_5__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Out[5]) );
  NAND2_X1 Inst_SKINNY_Sbox_15_Q294_inst1_Inst_5__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_15_InAff_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_15_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst1_Inst_5__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst1_Inst_5__CF_Inst_U1 ( .A(FRESH[3]), 
        .B(FRESH[4]), .Z(Inst_SKINNY_Sbox_15_Q294_inst1_Inst_5__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst1_Inst_6__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_15_Q294_inst1_Inst_6__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_15_InAff_out1_reg[0]), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Out[6]) );
  NAND2_X1 Inst_SKINNY_Sbox_15_Q294_inst1_Inst_6__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_15_InAff_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_15_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst1_Inst_6__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst1_Inst_7__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_15_Q294_inst1_Inst_7__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_15_Q294_inst1_Inst_7__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Out[7]) );
  NAND2_X1 Inst_SKINNY_Sbox_15_Q294_inst1_Inst_7__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_15_InAff_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_15_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst1_Inst_7__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst1_Inst_7__CF_Inst_U1 ( .A(FRESH[4]), 
        .B(FRESH[5]), .Z(Inst_SKINNY_Sbox_15_Q294_inst1_Inst_7__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst1_Inst_8__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_15_Q294_inst1_Inst_8__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_15_Q294_inst1_Inst_8__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Out[8]) );
  NAND2_X1 Inst_SKINNY_Sbox_15_Q294_inst1_Inst_8__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_15_InAff_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_15_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst1_Inst_8__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst1_Inst_8__CF_Inst_U1 ( .A(FRESH[5]), 
        .B(FRESH[0]), .Z(Inst_SKINNY_Sbox_15_Q294_inst1_Inst_8__CF_Inst_n6) );
  XNOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst1_Inst_9__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_15_Q294_inst1_Inst_9__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_15_InAff_out2_reg[1]), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Out[9]) );
  NAND2_X1 Inst_SKINNY_Sbox_15_Q294_inst1_Inst_9__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_15_InAff_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_15_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst1_Inst_9__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst1_Inst_10__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_15_Q294_inst1_Inst_10__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_15_Q294_inst1_Inst_10__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Out[10]) );
  NAND2_X1 Inst_SKINNY_Sbox_15_Q294_inst1_Inst_10__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_15_InAff_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_15_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst1_Inst_10__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst1_Inst_10__CF_Inst_U1 ( .A(FRESH[6]), 
        .B(FRESH[7]), .Z(Inst_SKINNY_Sbox_15_Q294_inst1_Inst_10__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst1_Inst_11__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_15_Q294_inst1_Inst_11__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_15_Q294_inst1_Inst_11__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Out[11]) );
  NAND2_X1 Inst_SKINNY_Sbox_15_Q294_inst1_Inst_11__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_15_InAff_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_15_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst1_Inst_11__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst1_Inst_11__CF_Inst_U1 ( .A(FRESH[7]), 
        .B(FRESH[8]), .Z(Inst_SKINNY_Sbox_15_Q294_inst1_Inst_11__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst1_Inst_12__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_15_Q294_inst1_Inst_12__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_15_InAff_out3_reg[1]), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Out[12]) );
  NAND2_X1 Inst_SKINNY_Sbox_15_Q294_inst1_Inst_12__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_15_InAff_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_15_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst1_Inst_12__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst1_Inst_13__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_15_Q294_inst1_Inst_13__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_15_Q294_inst1_Inst_13__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Out[13]) );
  NAND2_X1 Inst_SKINNY_Sbox_15_Q294_inst1_Inst_13__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_15_InAff_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_15_InAff_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst1_Inst_13__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst1_Inst_13__CF_Inst_U1 ( .A(FRESH[8]), 
        .B(FRESH[9]), .Z(Inst_SKINNY_Sbox_15_Q294_inst1_Inst_13__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst1_Inst_14__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_15_Q294_inst1_Inst_14__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_15_Q294_inst1_Inst_14__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Out[14]) );
  NAND2_X1 Inst_SKINNY_Sbox_15_Q294_inst1_Inst_14__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_15_InAff_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_15_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst1_Inst_14__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst1_Inst_14__CF_Inst_U1 ( .A(FRESH[9]), 
        .B(FRESH[10]), .Z(Inst_SKINNY_Sbox_15_Q294_inst1_Inst_14__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst1_Inst_15__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_15_Q294_inst1_Inst_15__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_15_InAff_out1_reg[1]), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Out[15]) );
  NAND2_X1 Inst_SKINNY_Sbox_15_Q294_inst1_Inst_15__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_15_InAff_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_15_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst1_Inst_15__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst1_Inst_16__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_15_Q294_inst1_Inst_16__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_15_Q294_inst1_Inst_16__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Out[16]) );
  NAND2_X1 Inst_SKINNY_Sbox_15_Q294_inst1_Inst_16__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_15_InAff_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_15_InAff_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst1_Inst_16__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst1_Inst_16__CF_Inst_U1 ( .A(FRESH[10]), 
        .B(FRESH[11]), .Z(Inst_SKINNY_Sbox_15_Q294_inst1_Inst_16__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst1_Inst_17__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_15_Q294_inst1_Inst_17__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_15_Q294_inst1_Inst_17__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Out[17]) );
  NAND2_X1 Inst_SKINNY_Sbox_15_Q294_inst1_Inst_17__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_15_InAff_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_15_InAff_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst1_Inst_17__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst1_Inst_17__CF_Inst_U1 ( .A(FRESH[11]), 
        .B(FRESH[6]), .Z(Inst_SKINNY_Sbox_15_Q294_inst1_Inst_17__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst1_InstXOR_0__Compression1_U2 ( .A(
        Inst_SKINNY_Sbox_15_Q294_inst1_InstXOR_0__Compression1_n3), .B(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Reg[2]), .ZN(
        Inst_SKINNY_Sbox_15_M2_out1[3]) );
  XNOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst1_InstXOR_0__Compression1_U1 ( .A(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Reg[0]), .B(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Reg[1]), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst1_InstXOR_0__Compression1_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst1_InstXOR_0__Compression2_U2 ( .A(
        Inst_SKINNY_Sbox_15_Q294_inst1_InstXOR_0__Compression2_n3), .B(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Reg[5]), .ZN(
        Inst_SKINNY_Sbox_15_M2_out2[3]) );
  XNOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst1_InstXOR_0__Compression2_U1 ( .A(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Reg[3]), .B(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Reg[4]), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst1_InstXOR_0__Compression2_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst1_InstXOR_0__Compression3_U2 ( .A(
        Inst_SKINNY_Sbox_15_Q294_inst1_InstXOR_0__Compression3_n3), .B(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Reg[8]), .ZN(
        Inst_SKINNY_Sbox_15_M2_out3[3]) );
  XNOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst1_InstXOR_0__Compression3_U1 ( .A(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Reg[6]), .B(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Reg[7]), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst1_InstXOR_0__Compression3_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst1_InstXOR_1__Compression1_U2 ( .A(
        Inst_SKINNY_Sbox_15_Q294_inst1_InstXOR_1__Compression1_n3), .B(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Reg[11]), .ZN(
        Inst_SKINNY_Sbox_15_M2_out1[2]) );
  XNOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst1_InstXOR_1__Compression1_U1 ( .A(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Reg[9]), .B(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Reg[10]), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst1_InstXOR_1__Compression1_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst1_InstXOR_1__Compression2_U2 ( .A(
        Inst_SKINNY_Sbox_15_Q294_inst1_InstXOR_1__Compression2_n3), .B(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Reg[14]), .ZN(
        Inst_SKINNY_Sbox_15_M2_out2[2]) );
  XNOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst1_InstXOR_1__Compression2_U1 ( .A(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Reg[12]), .B(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Reg[13]), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst1_InstXOR_1__Compression2_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst1_InstXOR_1__Compression3_U2 ( .A(
        Inst_SKINNY_Sbox_15_Q294_inst1_InstXOR_1__Compression3_n3), .B(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Reg[17]), .ZN(
        Inst_SKINNY_Sbox_15_M2_out3[2]) );
  XNOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst1_InstXOR_1__Compression3_U1 ( .A(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Reg[15]), .B(
        Inst_SKINNY_Sbox_15_Q294_inst1_CF_Reg[16]), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst1_InstXOR_1__Compression3_n3) );
  DFF_X1 Inst_SKINNY_Sbox_15_Q294_inst2_CF_Reg_reg_0_ ( .D(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Out[0]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Reg[0]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_Q294_inst2_CF_Reg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Out[1]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Reg[1]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_Q294_inst2_CF_Reg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Out[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Reg[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_Q294_inst2_CF_Reg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Out[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Reg[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_Q294_inst2_CF_Reg_reg_4_ ( .D(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Out[4]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Reg[4]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_Q294_inst2_CF_Reg_reg_5_ ( .D(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Out[5]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Reg[5]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_Q294_inst2_CF_Reg_reg_6_ ( .D(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Out[6]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Reg[6]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_Q294_inst2_CF_Reg_reg_7_ ( .D(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Out[7]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Reg[7]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_Q294_inst2_CF_Reg_reg_8_ ( .D(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Out[8]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Reg[8]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_Q294_inst2_CF_Reg_reg_9_ ( .D(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Out[9]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Reg[9]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_Q294_inst2_CF_Reg_reg_10_ ( .D(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Out[10]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Reg[10]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_Q294_inst2_CF_Reg_reg_11_ ( .D(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Out[11]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Reg[11]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_Q294_inst2_CF_Reg_reg_12_ ( .D(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Out[12]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Reg[12]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_Q294_inst2_CF_Reg_reg_13_ ( .D(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Out[13]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Reg[13]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_Q294_inst2_CF_Reg_reg_14_ ( .D(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Out[14]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Reg[14]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_Q294_inst2_CF_Reg_reg_15_ ( .D(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Out[15]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Reg[15]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_Q294_inst2_CF_Reg_reg_16_ ( .D(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Out[16]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Reg[16]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_Q294_inst2_CF_Reg_reg_17_ ( .D(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Out[17]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Reg[17]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_Q294_inst2_dreg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_15_M2_out2_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_Q294_2_out1[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_Q294_inst2_dreg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_15_M2_out3_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_OutAff_out2[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_Q294_inst2_dreg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_15_M2_out1_reg[3]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_OutAff_out3[3]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_Q294_inst2_creg_reg_1_ ( .D(
        Inst_SKINNY_Sbox_15_M2_out2_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_Q294_2_out1[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_Q294_inst2_creg_reg_2_ ( .D(
        Inst_SKINNY_Sbox_15_M2_out3_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_OutAff_out2[2]), .QN() );
  DFF_X1 Inst_SKINNY_Sbox_15_Q294_inst2_creg_reg_3_ ( .D(
        Inst_SKINNY_Sbox_15_M2_out1_reg[2]), .CK(CLK), .Q(
        Inst_SKINNY_Sbox_15_OutAff_out3[2]), .QN() );
  XNOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst2_Inst_0__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_15_Q294_inst2_Inst_0__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_15_M2_out2_reg[0]), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Out[0]) );
  NAND2_X1 Inst_SKINNY_Sbox_15_Q294_inst2_Inst_0__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_15_M2_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_15_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst2_Inst_0__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst2_Inst_1__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_15_Q294_inst2_Inst_1__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_15_Q294_inst2_Inst_1__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Out[1]) );
  NAND2_X1 Inst_SKINNY_Sbox_15_Q294_inst2_Inst_1__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_15_M2_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_15_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst2_Inst_1__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst2_Inst_1__CF_Inst_U1 ( .A(FRESH[12]), 
        .B(FRESH[13]), .Z(Inst_SKINNY_Sbox_15_Q294_inst2_Inst_1__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst2_Inst_2__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_15_Q294_inst2_Inst_2__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_15_Q294_inst2_Inst_2__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Out[2]) );
  NAND2_X1 Inst_SKINNY_Sbox_15_Q294_inst2_Inst_2__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_15_M2_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_15_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst2_Inst_2__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst2_Inst_2__CF_Inst_U1 ( .A(FRESH[13]), 
        .B(FRESH[14]), .Z(Inst_SKINNY_Sbox_15_Q294_inst2_Inst_2__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst2_Inst_3__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_15_Q294_inst2_Inst_3__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_15_M2_out3_reg[0]), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Out[3]) );
  NAND2_X1 Inst_SKINNY_Sbox_15_Q294_inst2_Inst_3__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_15_M2_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_15_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst2_Inst_3__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst2_Inst_4__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_15_Q294_inst2_Inst_4__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_15_Q294_inst2_Inst_4__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Out[4]) );
  NAND2_X1 Inst_SKINNY_Sbox_15_Q294_inst2_Inst_4__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_15_M2_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_15_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst2_Inst_4__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst2_Inst_4__CF_Inst_U1 ( .A(FRESH[14]), 
        .B(FRESH[15]), .Z(Inst_SKINNY_Sbox_15_Q294_inst2_Inst_4__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst2_Inst_5__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_15_Q294_inst2_Inst_5__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_15_Q294_inst2_Inst_5__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Out[5]) );
  NAND2_X1 Inst_SKINNY_Sbox_15_Q294_inst2_Inst_5__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_15_M2_out3_reg[1]), .A2(
        Inst_SKINNY_Sbox_15_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst2_Inst_5__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst2_Inst_5__CF_Inst_U1 ( .A(FRESH[15]), 
        .B(FRESH[16]), .Z(Inst_SKINNY_Sbox_15_Q294_inst2_Inst_5__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst2_Inst_6__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_15_Q294_inst2_Inst_6__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_15_M2_out1_reg[0]), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Out[6]) );
  NAND2_X1 Inst_SKINNY_Sbox_15_Q294_inst2_Inst_6__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_15_M2_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_15_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst2_Inst_6__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst2_Inst_7__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_15_Q294_inst2_Inst_7__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_15_Q294_inst2_Inst_7__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Out[7]) );
  NAND2_X1 Inst_SKINNY_Sbox_15_Q294_inst2_Inst_7__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_15_M2_out1_reg[1]), .A2(
        Inst_SKINNY_Sbox_15_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst2_Inst_7__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst2_Inst_7__CF_Inst_U1 ( .A(FRESH[16]), 
        .B(FRESH[17]), .Z(Inst_SKINNY_Sbox_15_Q294_inst2_Inst_7__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst2_Inst_8__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_15_Q294_inst2_Inst_8__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_15_Q294_inst2_Inst_8__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Out[8]) );
  NAND2_X1 Inst_SKINNY_Sbox_15_Q294_inst2_Inst_8__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_15_M2_out2_reg[1]), .A2(
        Inst_SKINNY_Sbox_15_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst2_Inst_8__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst2_Inst_8__CF_Inst_U1 ( .A(FRESH[17]), 
        .B(FRESH[12]), .Z(Inst_SKINNY_Sbox_15_Q294_inst2_Inst_8__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst2_Inst_9__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_15_Q294_inst2_Inst_9__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_15_M2_out2_reg[1]), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Out[9]) );
  NAND2_X1 Inst_SKINNY_Sbox_15_Q294_inst2_Inst_9__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_15_M2_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_15_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst2_Inst_9__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst2_Inst_10__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_15_Q294_inst2_Inst_10__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_15_Q294_inst2_Inst_10__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Out[10]) );
  NAND2_X1 Inst_SKINNY_Sbox_15_Q294_inst2_Inst_10__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_15_M2_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_15_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst2_Inst_10__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst2_Inst_10__CF_Inst_U1 ( .A(FRESH[18]), 
        .B(FRESH[19]), .Z(Inst_SKINNY_Sbox_15_Q294_inst2_Inst_10__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst2_Inst_11__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_15_Q294_inst2_Inst_11__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_15_Q294_inst2_Inst_11__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Out[11]) );
  NAND2_X1 Inst_SKINNY_Sbox_15_Q294_inst2_Inst_11__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_15_M2_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_15_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst2_Inst_11__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst2_Inst_11__CF_Inst_U1 ( .A(FRESH[19]), 
        .B(FRESH[20]), .Z(Inst_SKINNY_Sbox_15_Q294_inst2_Inst_11__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst2_Inst_12__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_15_Q294_inst2_Inst_12__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_15_M2_out3_reg[1]), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Out[12]) );
  NAND2_X1 Inst_SKINNY_Sbox_15_Q294_inst2_Inst_12__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_15_M2_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_15_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst2_Inst_12__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst2_Inst_13__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_15_Q294_inst2_Inst_13__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_15_Q294_inst2_Inst_13__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Out[13]) );
  NAND2_X1 Inst_SKINNY_Sbox_15_Q294_inst2_Inst_13__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_15_M2_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_15_M2_out3_reg[3]), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst2_Inst_13__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst2_Inst_13__CF_Inst_U1 ( .A(FRESH[20]), 
        .B(FRESH[21]), .Z(Inst_SKINNY_Sbox_15_Q294_inst2_Inst_13__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst2_Inst_14__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_15_Q294_inst2_Inst_14__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_15_Q294_inst2_Inst_14__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Out[14]) );
  NAND2_X1 Inst_SKINNY_Sbox_15_Q294_inst2_Inst_14__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_15_M2_out3_reg[2]), .A2(
        Inst_SKINNY_Sbox_15_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst2_Inst_14__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst2_Inst_14__CF_Inst_U1 ( .A(FRESH[21]), 
        .B(FRESH[22]), .Z(Inst_SKINNY_Sbox_15_Q294_inst2_Inst_14__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst2_Inst_15__CF_Inst_U2 ( .A(
        Inst_SKINNY_Sbox_15_Q294_inst2_Inst_15__CF_Inst_n3), .B(
        Inst_SKINNY_Sbox_15_M2_out1_reg[1]), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Out[15]) );
  NAND2_X1 Inst_SKINNY_Sbox_15_Q294_inst2_Inst_15__CF_Inst_U1 ( .A1(
        Inst_SKINNY_Sbox_15_M2_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_15_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst2_Inst_15__CF_Inst_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst2_Inst_16__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_15_Q294_inst2_Inst_16__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_15_Q294_inst2_Inst_16__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Out[16]) );
  NAND2_X1 Inst_SKINNY_Sbox_15_Q294_inst2_Inst_16__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_15_M2_out1_reg[2]), .A2(
        Inst_SKINNY_Sbox_15_M2_out2_reg[3]), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst2_Inst_16__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst2_Inst_16__CF_Inst_U1 ( .A(FRESH[22]), 
        .B(FRESH[23]), .Z(Inst_SKINNY_Sbox_15_Q294_inst2_Inst_16__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst2_Inst_17__CF_Inst_U3 ( .A(
        Inst_SKINNY_Sbox_15_Q294_inst2_Inst_17__CF_Inst_n6), .B(
        Inst_SKINNY_Sbox_15_Q294_inst2_Inst_17__CF_Inst_n5), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Out[17]) );
  NAND2_X1 Inst_SKINNY_Sbox_15_Q294_inst2_Inst_17__CF_Inst_U2 ( .A1(
        Inst_SKINNY_Sbox_15_M2_out2_reg[2]), .A2(
        Inst_SKINNY_Sbox_15_M2_out1_reg[3]), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst2_Inst_17__CF_Inst_n5) );
  XOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst2_Inst_17__CF_Inst_U1 ( .A(FRESH[23]), 
        .B(FRESH[18]), .Z(Inst_SKINNY_Sbox_15_Q294_inst2_Inst_17__CF_Inst_n6)
         );
  XNOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst2_InstXOR_0__Compression1_U2 ( .A(
        Inst_SKINNY_Sbox_15_Q294_inst2_InstXOR_0__Compression1_n3), .B(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Reg[2]), .ZN(
        Inst_SKINNY_Sbox_15_Q294_2_out1[0]) );
  XNOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst2_InstXOR_0__Compression1_U1 ( .A(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Reg[0]), .B(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Reg[1]), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst2_InstXOR_0__Compression1_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst2_InstXOR_0__Compression2_U2 ( .A(
        Inst_SKINNY_Sbox_15_Q294_inst2_InstXOR_0__Compression2_n3), .B(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Reg[5]), .ZN(
        Inst_SKINNY_Sbox_15_OutAff_out2[1]) );
  XNOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst2_InstXOR_0__Compression2_U1 ( .A(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Reg[3]), .B(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Reg[4]), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst2_InstXOR_0__Compression2_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst2_InstXOR_0__Compression3_U2 ( .A(
        Inst_SKINNY_Sbox_15_Q294_inst2_InstXOR_0__Compression3_n3), .B(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Reg[8]), .ZN(
        Inst_SKINNY_Sbox_15_OutAff_out3[1]) );
  XNOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst2_InstXOR_0__Compression3_U1 ( .A(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Reg[6]), .B(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Reg[7]), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst2_InstXOR_0__Compression3_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst2_InstXOR_1__Compression1_U2 ( .A(
        Inst_SKINNY_Sbox_15_Q294_inst2_InstXOR_1__Compression1_n3), .B(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Reg[11]), .ZN(
        Inst_SKINNY_Sbox_15_Q294_2_out1[1]) );
  XNOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst2_InstXOR_1__Compression1_U1 ( .A(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Reg[9]), .B(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Reg[10]), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst2_InstXOR_1__Compression1_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst2_InstXOR_1__Compression2_U2 ( .A(
        Inst_SKINNY_Sbox_15_Q294_inst2_InstXOR_1__Compression2_n3), .B(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Reg[14]), .ZN(
        Inst_SKINNY_Sbox_15_OutAff_out2[0]) );
  XNOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst2_InstXOR_1__Compression2_U1 ( .A(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Reg[12]), .B(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Reg[13]), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst2_InstXOR_1__Compression2_n3) );
  XNOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst2_InstXOR_1__Compression3_U2 ( .A(
        Inst_SKINNY_Sbox_15_Q294_inst2_InstXOR_1__Compression3_n3), .B(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Reg[17]), .ZN(
        Inst_SKINNY_Sbox_15_OutAff_out3[0]) );
  XNOR2_X1 Inst_SKINNY_Sbox_15_Q294_inst2_InstXOR_1__Compression3_U1 ( .A(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Reg[15]), .B(
        Inst_SKINNY_Sbox_15_Q294_inst2_CF_Reg[16]), .ZN(
        Inst_SKINNY_Sbox_15_Q294_inst2_InstXOR_1__Compression3_n3) );
  INV_X1 Inst_SKINNY_Sbox_15_OutputAffine_U4 ( .A(
        Inst_SKINNY_Sbox_15_Q294_2_out1[3]), .ZN(
        Inst_SKINNY_Sbox_15_OutAff_out1[3]) );
  INV_X1 Inst_SKINNY_Sbox_15_OutputAffine_U3 ( .A(
        Inst_SKINNY_Sbox_15_Q294_2_out1[2]), .ZN(
        Inst_SKINNY_Sbox_15_OutAff_out1[2]) );
  INV_X1 Inst_SKINNY_Sbox_15_OutputAffine_U2 ( .A(
        Inst_SKINNY_Sbox_15_Q294_2_out1[1]), .ZN(
        Inst_SKINNY_Sbox_15_OutAff_out1[0]) );
  INV_X1 Inst_SKINNY_Sbox_15_OutputAffine_U1 ( .A(
        Inst_SKINNY_Sbox_15_Q294_2_out1[0]), .ZN(
        Inst_SKINNY_Sbox_15_OutAff_out1[1]) );
  BUF_X1 KE1_RS_U6 ( .A(KEY_EN), .Z(KE1_RS_n10) );
  BUF_X1 KE1_RS_U5 ( .A(KEY_EN), .Z(KE1_RS_n9) );
  BUF_X1 KE1_RS_U4 ( .A(KEY_EN), .Z(KE1_RS_n8) );
  BUF_X1 KE1_RS_U3 ( .A(KEY_EN), .Z(KE1_RS_n7) );
  BUF_X1 KE1_RS_U2 ( .A(KEY_EN), .Z(KE1_RS_n11) );
  BUF_X1 KE1_RS_U1 ( .A(KEY_EN), .Z(KE1_RS_n12) );
  OAI21_X1 KE1_RS_SFF_0_U4 ( .B1(KE1_RS_n12), .B2(KE1_RS_SFF_0_n7), .A(
        KE1_RS_SFF_0_n10), .ZN(KE1_RS_SFF_0_n6) );
  OAI221_X1 KE1_RS_SFF_0_U3 ( .B1(RESET), .B2(KE1_KEY_PERM[0]), .C1(
        KE1_RS_SFF_0_n9), .C2(KEY1[0]), .A(KE1_RS_n12), .ZN(KE1_RS_SFF_0_n10)
         );
  INV_X1 KE1_RS_SFF_0_U2 ( .A(RESET), .ZN(KE1_RS_SFF_0_n9) );
  DFF_X1 KE1_RS_SFF_0_Q_reg ( .D(KE1_RS_SFF_0_n6), .CK(CLK), .Q(
        KE1_KEY_PERM[56]), .QN(KE1_RS_SFF_0_n7) );
  OAI21_X1 KE1_RS_SFF_1_U4 ( .B1(KE1_RS_n12), .B2(KE1_RS_SFF_1_n8), .A(
        KE1_RS_SFF_1_n11), .ZN(KE1_RS_SFF_1_n7) );
  OAI221_X1 KE1_RS_SFF_1_U3 ( .B1(RESET), .B2(KE1_KEY_PERM[1]), .C1(
        KE1_RS_SFF_1_n10), .C2(KEY1[1]), .A(KE1_RS_n12), .ZN(KE1_RS_SFF_1_n11)
         );
  INV_X1 KE1_RS_SFF_1_U2 ( .A(RESET), .ZN(KE1_RS_SFF_1_n10) );
  DFF_X1 KE1_RS_SFF_1_Q_reg ( .D(KE1_RS_SFF_1_n7), .CK(CLK), .Q(
        KE1_KEY_PERM[57]), .QN(KE1_RS_SFF_1_n8) );
  OAI21_X1 KE1_RS_SFF_2_U4 ( .B1(KE1_RS_n7), .B2(KE1_RS_SFF_2_n8), .A(
        KE1_RS_SFF_2_n11), .ZN(KE1_RS_SFF_2_n7) );
  OAI221_X1 KE1_RS_SFF_2_U3 ( .B1(RESET), .B2(KE1_KEY_PERM[2]), .C1(
        KE1_RS_SFF_2_n10), .C2(KEY1[2]), .A(KE1_RS_n7), .ZN(KE1_RS_SFF_2_n11)
         );
  INV_X1 KE1_RS_SFF_2_U2 ( .A(RESET), .ZN(KE1_RS_SFF_2_n10) );
  DFF_X1 KE1_RS_SFF_2_Q_reg ( .D(KE1_RS_SFF_2_n7), .CK(CLK), .Q(
        KE1_KEY_PERM[58]), .QN(KE1_RS_SFF_2_n8) );
  OAI21_X1 KE1_RS_SFF_3_U4 ( .B1(KE1_RS_n8), .B2(KE1_RS_SFF_3_n7), .A(
        KE1_RS_SFF_3_n10), .ZN(KE1_RS_SFF_3_n6) );
  OAI221_X1 KE1_RS_SFF_3_U3 ( .B1(RESET), .B2(KE1_KEY_PERM[3]), .C1(
        KE1_RS_SFF_3_n9), .C2(KEY1[3]), .A(KE1_RS_n8), .ZN(KE1_RS_SFF_3_n10)
         );
  INV_X1 KE1_RS_SFF_3_U2 ( .A(RESET), .ZN(KE1_RS_SFF_3_n9) );
  DFF_X1 KE1_RS_SFF_3_Q_reg ( .D(KE1_RS_SFF_3_n6), .CK(CLK), .Q(
        KE1_KEY_PERM[59]), .QN(KE1_RS_SFF_3_n7) );
  OAI21_X1 KE1_RS_SFF_4_U4 ( .B1(KE1_RS_n8), .B2(KE1_RS_SFF_4_n7), .A(
        KE1_RS_SFF_4_n10), .ZN(KE1_RS_SFF_4_n6) );
  OAI221_X1 KE1_RS_SFF_4_U3 ( .B1(RESET), .B2(KE1_KEY_PERM[4]), .C1(
        KE1_RS_SFF_4_n9), .C2(KEY1[4]), .A(KE1_RS_n8), .ZN(KE1_RS_SFF_4_n10)
         );
  INV_X1 KE1_RS_SFF_4_U2 ( .A(RESET), .ZN(KE1_RS_SFF_4_n9) );
  DFF_X1 KE1_RS_SFF_4_Q_reg ( .D(KE1_RS_SFF_4_n6), .CK(CLK), .Q(
        KE1_KEY_PERM[40]), .QN(KE1_RS_SFF_4_n7) );
  OAI21_X1 KE1_RS_SFF_5_U4 ( .B1(KE1_RS_n8), .B2(KE1_RS_SFF_5_n7), .A(
        KE1_RS_SFF_5_n10), .ZN(KE1_RS_SFF_5_n6) );
  OAI221_X1 KE1_RS_SFF_5_U3 ( .B1(RESET), .B2(KE1_KEY_PERM[5]), .C1(
        KE1_RS_SFF_5_n9), .C2(KEY1[5]), .A(KE1_RS_n8), .ZN(KE1_RS_SFF_5_n10)
         );
  INV_X1 KE1_RS_SFF_5_U2 ( .A(RESET), .ZN(KE1_RS_SFF_5_n9) );
  DFF_X1 KE1_RS_SFF_5_Q_reg ( .D(KE1_RS_SFF_5_n6), .CK(CLK), .Q(
        KE1_KEY_PERM[41]), .QN(KE1_RS_SFF_5_n7) );
  OAI21_X1 KE1_RS_SFF_6_U4 ( .B1(KE1_RS_n8), .B2(KE1_RS_SFF_6_n7), .A(
        KE1_RS_SFF_6_n10), .ZN(KE1_RS_SFF_6_n6) );
  OAI221_X1 KE1_RS_SFF_6_U3 ( .B1(RESET), .B2(KE1_KEY_PERM[6]), .C1(
        KE1_RS_SFF_6_n9), .C2(KEY1[6]), .A(KE1_RS_n8), .ZN(KE1_RS_SFF_6_n10)
         );
  INV_X1 KE1_RS_SFF_6_U2 ( .A(RESET), .ZN(KE1_RS_SFF_6_n9) );
  DFF_X1 KE1_RS_SFF_6_Q_reg ( .D(KE1_RS_SFF_6_n6), .CK(CLK), .Q(
        KE1_KEY_PERM[42]), .QN(KE1_RS_SFF_6_n7) );
  OAI21_X1 KE1_RS_SFF_7_U4 ( .B1(KE1_RS_n8), .B2(KE1_RS_SFF_7_n7), .A(
        KE1_RS_SFF_7_n10), .ZN(KE1_RS_SFF_7_n6) );
  OAI221_X1 KE1_RS_SFF_7_U3 ( .B1(RESET), .B2(KE1_KEY_PERM[7]), .C1(
        KE1_RS_SFF_7_n9), .C2(KEY1[7]), .A(KE1_RS_n8), .ZN(KE1_RS_SFF_7_n10)
         );
  INV_X1 KE1_RS_SFF_7_U2 ( .A(RESET), .ZN(KE1_RS_SFF_7_n9) );
  DFF_X1 KE1_RS_SFF_7_Q_reg ( .D(KE1_RS_SFF_7_n6), .CK(CLK), .Q(
        KE1_KEY_PERM[43]), .QN(KE1_RS_SFF_7_n7) );
  OAI21_X1 KE1_RS_SFF_8_U4 ( .B1(KE1_RS_n8), .B2(KE1_RS_SFF_8_n7), .A(
        KE1_RS_SFF_8_n10), .ZN(KE1_RS_SFF_8_n6) );
  OAI221_X1 KE1_RS_SFF_8_U3 ( .B1(RESET), .B2(KE1_KEY_PERM[8]), .C1(
        KE1_RS_SFF_8_n9), .C2(KEY1[8]), .A(KE1_RS_n8), .ZN(KE1_RS_SFF_8_n10)
         );
  INV_X1 KE1_RS_SFF_8_U2 ( .A(RESET), .ZN(KE1_RS_SFF_8_n9) );
  DFF_X1 KE1_RS_SFF_8_Q_reg ( .D(KE1_RS_SFF_8_n6), .CK(CLK), .Q(
        KE1_KEY_PERM[48]), .QN(KE1_RS_SFF_8_n7) );
  OAI21_X1 KE1_RS_SFF_9_U4 ( .B1(KE1_RS_n8), .B2(KE1_RS_SFF_9_n7), .A(
        KE1_RS_SFF_9_n10), .ZN(KE1_RS_SFF_9_n6) );
  OAI221_X1 KE1_RS_SFF_9_U3 ( .B1(RESET), .B2(KE1_KEY_PERM[9]), .C1(
        KE1_RS_SFF_9_n9), .C2(KEY1[9]), .A(KE1_RS_n8), .ZN(KE1_RS_SFF_9_n10)
         );
  INV_X1 KE1_RS_SFF_9_U2 ( .A(RESET), .ZN(KE1_RS_SFF_9_n9) );
  DFF_X1 KE1_RS_SFF_9_Q_reg ( .D(KE1_RS_SFF_9_n6), .CK(CLK), .Q(
        KE1_KEY_PERM[49]), .QN(KE1_RS_SFF_9_n7) );
  OAI21_X1 KE1_RS_SFF_10_U4 ( .B1(KE1_RS_n9), .B2(KE1_RS_SFF_10_n7), .A(
        KE1_RS_SFF_10_n10), .ZN(KE1_RS_SFF_10_n6) );
  OAI221_X1 KE1_RS_SFF_10_U3 ( .B1(RESET), .B2(KE1_KEY_PERM[10]), .C1(
        KE1_RS_SFF_10_n9), .C2(KEY1[10]), .A(KE1_RS_n9), .ZN(KE1_RS_SFF_10_n10) );
  INV_X1 KE1_RS_SFF_10_U2 ( .A(RESET), .ZN(KE1_RS_SFF_10_n9) );
  DFF_X1 KE1_RS_SFF_10_Q_reg ( .D(KE1_RS_SFF_10_n6), .CK(CLK), .Q(
        KE1_KEY_PERM[50]), .QN(KE1_RS_SFF_10_n7) );
  OAI21_X1 KE1_RS_SFF_11_U4 ( .B1(KE1_RS_n9), .B2(KE1_RS_SFF_11_n7), .A(
        KE1_RS_SFF_11_n10), .ZN(KE1_RS_SFF_11_n6) );
  OAI221_X1 KE1_RS_SFF_11_U3 ( .B1(RESET), .B2(KE1_KEY_PERM[11]), .C1(
        KE1_RS_SFF_11_n9), .C2(KEY1[11]), .A(KE1_RS_n9), .ZN(KE1_RS_SFF_11_n10) );
  INV_X1 KE1_RS_SFF_11_U2 ( .A(RESET), .ZN(KE1_RS_SFF_11_n9) );
  DFF_X1 KE1_RS_SFF_11_Q_reg ( .D(KE1_RS_SFF_11_n6), .CK(CLK), .Q(
        KE1_KEY_PERM[51]), .QN(KE1_RS_SFF_11_n7) );
  OAI21_X1 KE1_RS_SFF_12_U4 ( .B1(KE1_RS_n9), .B2(KE1_RS_SFF_12_n7), .A(
        KE1_RS_SFF_12_n10), .ZN(KE1_RS_SFF_12_n6) );
  OAI221_X1 KE1_RS_SFF_12_U3 ( .B1(RESET), .B2(KE1_KEY_PERM[12]), .C1(
        KE1_RS_SFF_12_n9), .C2(KEY1[12]), .A(KE1_RS_n9), .ZN(KE1_RS_SFF_12_n10) );
  INV_X1 KE1_RS_SFF_12_U2 ( .A(RESET), .ZN(KE1_RS_SFF_12_n9) );
  DFF_X1 KE1_RS_SFF_12_Q_reg ( .D(KE1_RS_SFF_12_n6), .CK(CLK), .Q(
        KE1_KEY_PERM[36]), .QN(KE1_RS_SFF_12_n7) );
  OAI21_X1 KE1_RS_SFF_13_U4 ( .B1(KE1_RS_n7), .B2(KE1_RS_SFF_13_n8), .A(
        KE1_RS_SFF_13_n11), .ZN(KE1_RS_SFF_13_n7) );
  OAI221_X1 KE1_RS_SFF_13_U3 ( .B1(RESET), .B2(KE1_KEY_PERM[13]), .C1(
        KE1_RS_SFF_13_n10), .C2(KEY1[13]), .A(KE1_RS_n7), .ZN(
        KE1_RS_SFF_13_n11) );
  INV_X1 KE1_RS_SFF_13_U2 ( .A(RESET), .ZN(KE1_RS_SFF_13_n10) );
  DFF_X1 KE1_RS_SFF_13_Q_reg ( .D(KE1_RS_SFF_13_n7), .CK(CLK), .Q(
        KE1_KEY_PERM[37]), .QN(KE1_RS_SFF_13_n8) );
  OAI21_X1 KE1_RS_SFF_14_U4 ( .B1(KE1_RS_n7), .B2(KE1_RS_SFF_14_n8), .A(
        KE1_RS_SFF_14_n11), .ZN(KE1_RS_SFF_14_n7) );
  OAI221_X1 KE1_RS_SFF_14_U3 ( .B1(RESET), .B2(KE1_KEY_PERM[14]), .C1(
        KE1_RS_SFF_14_n10), .C2(KEY1[14]), .A(KE1_RS_n7), .ZN(
        KE1_RS_SFF_14_n11) );
  INV_X1 KE1_RS_SFF_14_U2 ( .A(RESET), .ZN(KE1_RS_SFF_14_n10) );
  DFF_X1 KE1_RS_SFF_14_Q_reg ( .D(KE1_RS_SFF_14_n7), .CK(CLK), .Q(
        KE1_KEY_PERM[38]), .QN(KE1_RS_SFF_14_n8) );
  OAI21_X1 KE1_RS_SFF_15_U4 ( .B1(KE1_RS_n9), .B2(KE1_RS_SFF_15_n7), .A(
        KE1_RS_SFF_15_n10), .ZN(KE1_RS_SFF_15_n6) );
  OAI221_X1 KE1_RS_SFF_15_U3 ( .B1(RESET), .B2(KE1_KEY_PERM[15]), .C1(
        KE1_RS_SFF_15_n9), .C2(KEY1[15]), .A(KE1_RS_n9), .ZN(KE1_RS_SFF_15_n10) );
  INV_X1 KE1_RS_SFF_15_U2 ( .A(RESET), .ZN(KE1_RS_SFF_15_n9) );
  DFF_X1 KE1_RS_SFF_15_Q_reg ( .D(KE1_RS_SFF_15_n6), .CK(CLK), .Q(
        KE1_KEY_PERM[39]), .QN(KE1_RS_SFF_15_n7) );
  OAI21_X1 KE1_RS_SFF_16_U4 ( .B1(KE1_RS_n9), .B2(KE1_RS_SFF_16_n7), .A(
        KE1_RS_SFF_16_n10), .ZN(KE1_RS_SFF_16_n6) );
  OAI221_X1 KE1_RS_SFF_16_U3 ( .B1(RESET), .B2(KE1_KEY_PERM[16]), .C1(
        KE1_RS_SFF_16_n9), .C2(KEY1[16]), .A(KE1_RS_n9), .ZN(KE1_RS_SFF_16_n10) );
  INV_X1 KE1_RS_SFF_16_U2 ( .A(RESET), .ZN(KE1_RS_SFF_16_n9) );
  DFF_X1 KE1_RS_SFF_16_Q_reg ( .D(KE1_RS_SFF_16_n6), .CK(CLK), .Q(
        KE1_KEY_PERM[32]), .QN(KE1_RS_SFF_16_n7) );
  OAI21_X1 KE1_RS_SFF_17_U4 ( .B1(KE1_RS_n9), .B2(KE1_RS_SFF_17_n7), .A(
        KE1_RS_SFF_17_n10), .ZN(KE1_RS_SFF_17_n6) );
  OAI221_X1 KE1_RS_SFF_17_U3 ( .B1(RESET), .B2(KE1_KEY_PERM[17]), .C1(
        KE1_RS_SFF_17_n9), .C2(KEY1[17]), .A(KE1_RS_n9), .ZN(KE1_RS_SFF_17_n10) );
  INV_X1 KE1_RS_SFF_17_U2 ( .A(RESET), .ZN(KE1_RS_SFF_17_n9) );
  DFF_X1 KE1_RS_SFF_17_Q_reg ( .D(KE1_RS_SFF_17_n6), .CK(CLK), .Q(
        KE1_KEY_PERM[33]), .QN(KE1_RS_SFF_17_n7) );
  OAI21_X1 KE1_RS_SFF_18_U4 ( .B1(KE1_RS_n9), .B2(KE1_RS_SFF_18_n7), .A(
        KE1_RS_SFF_18_n10), .ZN(KE1_RS_SFF_18_n6) );
  OAI221_X1 KE1_RS_SFF_18_U3 ( .B1(RESET), .B2(KE1_KEY_PERM[18]), .C1(
        KE1_RS_SFF_18_n9), .C2(KEY1[18]), .A(KE1_RS_n9), .ZN(KE1_RS_SFF_18_n10) );
  INV_X1 KE1_RS_SFF_18_U2 ( .A(RESET), .ZN(KE1_RS_SFF_18_n9) );
  DFF_X1 KE1_RS_SFF_18_Q_reg ( .D(KE1_RS_SFF_18_n6), .CK(CLK), .Q(
        KE1_KEY_PERM[34]), .QN(KE1_RS_SFF_18_n7) );
  OAI21_X1 KE1_RS_SFF_19_U4 ( .B1(KE1_RS_n9), .B2(KE1_RS_SFF_19_n7), .A(
        KE1_RS_SFF_19_n10), .ZN(KE1_RS_SFF_19_n6) );
  OAI221_X1 KE1_RS_SFF_19_U3 ( .B1(RESET), .B2(KE1_KEY_PERM[19]), .C1(
        KE1_RS_SFF_19_n9), .C2(KEY1[19]), .A(KE1_RS_n9), .ZN(KE1_RS_SFF_19_n10) );
  INV_X1 KE1_RS_SFF_19_U2 ( .A(RESET), .ZN(KE1_RS_SFF_19_n9) );
  DFF_X1 KE1_RS_SFF_19_Q_reg ( .D(KE1_RS_SFF_19_n6), .CK(CLK), .Q(
        KE1_KEY_PERM[35]), .QN(KE1_RS_SFF_19_n7) );
  OAI21_X1 KE1_RS_SFF_20_U4 ( .B1(KE1_RS_n10), .B2(KE1_RS_SFF_20_n7), .A(
        KE1_RS_SFF_20_n10), .ZN(KE1_RS_SFF_20_n6) );
  OAI221_X1 KE1_RS_SFF_20_U3 ( .B1(RESET), .B2(KE1_KEY_PERM[20]), .C1(
        KE1_RS_SFF_20_n9), .C2(KEY1[20]), .A(KE1_RS_n10), .ZN(
        KE1_RS_SFF_20_n10) );
  INV_X1 KE1_RS_SFF_20_U2 ( .A(RESET), .ZN(KE1_RS_SFF_20_n9) );
  DFF_X1 KE1_RS_SFF_20_Q_reg ( .D(KE1_RS_SFF_20_n6), .CK(CLK), .Q(
        KE1_KEY_PERM[44]), .QN(KE1_RS_SFF_20_n7) );
  OAI21_X1 KE1_RS_SFF_21_U4 ( .B1(KE1_RS_n10), .B2(KE1_RS_SFF_21_n7), .A(
        KE1_RS_SFF_21_n10), .ZN(KE1_RS_SFF_21_n6) );
  OAI221_X1 KE1_RS_SFF_21_U3 ( .B1(RESET), .B2(KE1_KEY_PERM[21]), .C1(
        KE1_RS_SFF_21_n9), .C2(KEY1[21]), .A(KE1_RS_n10), .ZN(
        KE1_RS_SFF_21_n10) );
  INV_X1 KE1_RS_SFF_21_U2 ( .A(RESET), .ZN(KE1_RS_SFF_21_n9) );
  DFF_X1 KE1_RS_SFF_21_Q_reg ( .D(KE1_RS_SFF_21_n6), .CK(CLK), .Q(
        KE1_KEY_PERM[45]), .QN(KE1_RS_SFF_21_n7) );
  OAI21_X1 KE1_RS_SFF_22_U4 ( .B1(KE1_RS_n10), .B2(KE1_RS_SFF_22_n7), .A(
        KE1_RS_SFF_22_n10), .ZN(KE1_RS_SFF_22_n6) );
  OAI221_X1 KE1_RS_SFF_22_U3 ( .B1(RESET), .B2(KE1_KEY_PERM[22]), .C1(
        KE1_RS_SFF_22_n9), .C2(KEY1[22]), .A(KE1_RS_n10), .ZN(
        KE1_RS_SFF_22_n10) );
  INV_X1 KE1_RS_SFF_22_U2 ( .A(RESET), .ZN(KE1_RS_SFF_22_n9) );
  DFF_X1 KE1_RS_SFF_22_Q_reg ( .D(KE1_RS_SFF_22_n6), .CK(CLK), .Q(
        KE1_KEY_PERM[46]), .QN(KE1_RS_SFF_22_n7) );
  OAI21_X1 KE1_RS_SFF_23_U4 ( .B1(KE1_RS_n10), .B2(KE1_RS_SFF_23_n7), .A(
        KE1_RS_SFF_23_n10), .ZN(KE1_RS_SFF_23_n6) );
  OAI221_X1 KE1_RS_SFF_23_U3 ( .B1(RESET), .B2(KE1_KEY_PERM[23]), .C1(
        KE1_RS_SFF_23_n9), .C2(KEY1[23]), .A(KE1_RS_n10), .ZN(
        KE1_RS_SFF_23_n10) );
  INV_X1 KE1_RS_SFF_23_U2 ( .A(RESET), .ZN(KE1_RS_SFF_23_n9) );
  DFF_X1 KE1_RS_SFF_23_Q_reg ( .D(KE1_RS_SFF_23_n6), .CK(CLK), .Q(
        KE1_KEY_PERM[47]), .QN(KE1_RS_SFF_23_n7) );
  OAI21_X1 KE1_RS_SFF_24_U4 ( .B1(KE1_RS_n10), .B2(KE1_RS_SFF_24_n7), .A(
        KE1_RS_SFF_24_n10), .ZN(KE1_RS_SFF_24_n6) );
  OAI221_X1 KE1_RS_SFF_24_U3 ( .B1(RESET), .B2(KE1_KEY_PERM[24]), .C1(
        KE1_RS_SFF_24_n9), .C2(KEY1[24]), .A(KE1_RS_n10), .ZN(
        KE1_RS_SFF_24_n10) );
  INV_X1 KE1_RS_SFF_24_U2 ( .A(RESET), .ZN(KE1_RS_SFF_24_n9) );
  DFF_X1 KE1_RS_SFF_24_Q_reg ( .D(KE1_RS_SFF_24_n6), .CK(CLK), .Q(
        KE1_KEY_PERM[60]), .QN(KE1_RS_SFF_24_n7) );
  OAI21_X1 KE1_RS_SFF_25_U4 ( .B1(KE1_RS_n7), .B2(KE1_RS_SFF_25_n8), .A(
        KE1_RS_SFF_25_n11), .ZN(KE1_RS_SFF_25_n7) );
  OAI221_X1 KE1_RS_SFF_25_U3 ( .B1(RESET), .B2(KE1_KEY_PERM[25]), .C1(
        KE1_RS_SFF_25_n10), .C2(KEY1[25]), .A(KE1_RS_n7), .ZN(
        KE1_RS_SFF_25_n11) );
  INV_X1 KE1_RS_SFF_25_U2 ( .A(RESET), .ZN(KE1_RS_SFF_25_n10) );
  DFF_X1 KE1_RS_SFF_25_Q_reg ( .D(KE1_RS_SFF_25_n7), .CK(CLK), .Q(
        KE1_KEY_PERM[61]), .QN(KE1_RS_SFF_25_n8) );
  OAI21_X1 KE1_RS_SFF_26_U4 ( .B1(KE1_RS_n7), .B2(KE1_RS_SFF_26_n8), .A(
        KE1_RS_SFF_26_n11), .ZN(KE1_RS_SFF_26_n7) );
  OAI221_X1 KE1_RS_SFF_26_U3 ( .B1(RESET), .B2(KE1_KEY_PERM[26]), .C1(
        KE1_RS_SFF_26_n10), .C2(KEY1[26]), .A(KE1_RS_n7), .ZN(
        KE1_RS_SFF_26_n11) );
  INV_X1 KE1_RS_SFF_26_U2 ( .A(RESET), .ZN(KE1_RS_SFF_26_n10) );
  DFF_X1 KE1_RS_SFF_26_Q_reg ( .D(KE1_RS_SFF_26_n7), .CK(CLK), .Q(
        KE1_KEY_PERM[62]), .QN(KE1_RS_SFF_26_n8) );
  OAI21_X1 KE1_RS_SFF_27_U4 ( .B1(KE1_RS_n10), .B2(KE1_RS_SFF_27_n7), .A(
        KE1_RS_SFF_27_n10), .ZN(KE1_RS_SFF_27_n6) );
  OAI221_X1 KE1_RS_SFF_27_U3 ( .B1(RESET), .B2(KE1_KEY_PERM[27]), .C1(
        KE1_RS_SFF_27_n9), .C2(KEY1[27]), .A(KE1_RS_n10), .ZN(
        KE1_RS_SFF_27_n10) );
  INV_X1 KE1_RS_SFF_27_U2 ( .A(RESET), .ZN(KE1_RS_SFF_27_n9) );
  DFF_X1 KE1_RS_SFF_27_Q_reg ( .D(KE1_RS_SFF_27_n6), .CK(CLK), .Q(
        KE1_KEY_PERM[63]), .QN(KE1_RS_SFF_27_n7) );
  OAI21_X1 KE1_RS_SFF_28_U4 ( .B1(KE1_RS_n10), .B2(KE1_RS_SFF_28_n7), .A(
        KE1_RS_SFF_28_n10), .ZN(KE1_RS_SFF_28_n6) );
  OAI221_X1 KE1_RS_SFF_28_U3 ( .B1(RESET), .B2(KE1_KEY_PERM[28]), .C1(
        KE1_RS_SFF_28_n9), .C2(KEY1[28]), .A(KE1_RS_n10), .ZN(
        KE1_RS_SFF_28_n10) );
  INV_X1 KE1_RS_SFF_28_U2 ( .A(RESET), .ZN(KE1_RS_SFF_28_n9) );
  DFF_X1 KE1_RS_SFF_28_Q_reg ( .D(KE1_RS_SFF_28_n6), .CK(CLK), .Q(
        KE1_KEY_PERM[52]), .QN(KE1_RS_SFF_28_n7) );
  OAI21_X1 KE1_RS_SFF_29_U4 ( .B1(KE1_RS_n10), .B2(KE1_RS_SFF_29_n7), .A(
        KE1_RS_SFF_29_n10), .ZN(KE1_RS_SFF_29_n6) );
  OAI221_X1 KE1_RS_SFF_29_U3 ( .B1(RESET), .B2(KE1_KEY_PERM[29]), .C1(
        KE1_RS_SFF_29_n9), .C2(KEY1[29]), .A(KE1_RS_n10), .ZN(
        KE1_RS_SFF_29_n10) );
  INV_X1 KE1_RS_SFF_29_U2 ( .A(RESET), .ZN(KE1_RS_SFF_29_n9) );
  DFF_X1 KE1_RS_SFF_29_Q_reg ( .D(KE1_RS_SFF_29_n6), .CK(CLK), .Q(
        KE1_KEY_PERM[53]), .QN(KE1_RS_SFF_29_n7) );
  OAI21_X1 KE1_RS_SFF_30_U4 ( .B1(KE1_RS_n11), .B2(KE1_RS_SFF_30_n7), .A(
        KE1_RS_SFF_30_n10), .ZN(KE1_RS_SFF_30_n6) );
  OAI221_X1 KE1_RS_SFF_30_U3 ( .B1(RESET), .B2(KE1_KEY_PERM[30]), .C1(
        KE1_RS_SFF_30_n9), .C2(KEY1[30]), .A(KE1_RS_n11), .ZN(
        KE1_RS_SFF_30_n10) );
  INV_X1 KE1_RS_SFF_30_U2 ( .A(RESET), .ZN(KE1_RS_SFF_30_n9) );
  DFF_X1 KE1_RS_SFF_30_Q_reg ( .D(KE1_RS_SFF_30_n6), .CK(CLK), .Q(
        KE1_KEY_PERM[54]), .QN(KE1_RS_SFF_30_n7) );
  OAI21_X1 KE1_RS_SFF_31_U4 ( .B1(KE1_RS_n11), .B2(KE1_RS_SFF_31_n7), .A(
        KE1_RS_SFF_31_n10), .ZN(KE1_RS_SFF_31_n6) );
  OAI221_X1 KE1_RS_SFF_31_U3 ( .B1(RESET), .B2(KE1_KEY_PERM[31]), .C1(
        KE1_RS_SFF_31_n9), .C2(KEY1[31]), .A(KE1_RS_n11), .ZN(
        KE1_RS_SFF_31_n10) );
  INV_X1 KE1_RS_SFF_31_U2 ( .A(RESET), .ZN(KE1_RS_SFF_31_n9) );
  DFF_X1 KE1_RS_SFF_31_Q_reg ( .D(KE1_RS_SFF_31_n6), .CK(CLK), .Q(
        KE1_KEY_PERM[55]), .QN(KE1_RS_SFF_31_n7) );
  OAI21_X1 KE1_RS_SFF_32_U4 ( .B1(KE1_RS_n11), .B2(KE1_RS_SFF_32_n7), .A(
        KE1_RS_SFF_32_n10), .ZN(KE1_RS_SFF_32_n6) );
  OAI221_X1 KE1_RS_SFF_32_U3 ( .B1(RESET), .B2(KE1_KEY_PERM[32]), .C1(
        KE1_RS_SFF_32_n9), .C2(KEY1[32]), .A(KE1_RS_n11), .ZN(
        KE1_RS_SFF_32_n10) );
  INV_X1 KE1_RS_SFF_32_U2 ( .A(RESET), .ZN(KE1_RS_SFF_32_n9) );
  DFF_X1 KE1_RS_SFF_32_Q_reg ( .D(KE1_RS_SFF_32_n6), .CK(CLK), .Q(
        KE1_KEY_PERM[0]), .QN(KE1_RS_SFF_32_n7) );
  OAI21_X1 KE1_RS_SFF_33_U4 ( .B1(KE1_RS_n11), .B2(KE1_RS_SFF_33_n7), .A(
        KE1_RS_SFF_33_n10), .ZN(KE1_RS_SFF_33_n6) );
  OAI221_X1 KE1_RS_SFF_33_U3 ( .B1(RESET), .B2(KE1_KEY_PERM[33]), .C1(
        KE1_RS_SFF_33_n9), .C2(KEY1[33]), .A(KE1_RS_n11), .ZN(
        KE1_RS_SFF_33_n10) );
  INV_X1 KE1_RS_SFF_33_U2 ( .A(RESET), .ZN(KE1_RS_SFF_33_n9) );
  DFF_X1 KE1_RS_SFF_33_Q_reg ( .D(KE1_RS_SFF_33_n6), .CK(CLK), .Q(
        KE1_KEY_PERM[1]), .QN(KE1_RS_SFF_33_n7) );
  OAI21_X1 KE1_RS_SFF_34_U4 ( .B1(KE1_RS_n11), .B2(KE1_RS_SFF_34_n7), .A(
        KE1_RS_SFF_34_n10), .ZN(KE1_RS_SFF_34_n6) );
  OAI221_X1 KE1_RS_SFF_34_U3 ( .B1(RESET), .B2(KE1_KEY_PERM[34]), .C1(
        KE1_RS_SFF_34_n9), .C2(KEY1[34]), .A(KE1_RS_n11), .ZN(
        KE1_RS_SFF_34_n10) );
  INV_X1 KE1_RS_SFF_34_U2 ( .A(RESET), .ZN(KE1_RS_SFF_34_n9) );
  DFF_X1 KE1_RS_SFF_34_Q_reg ( .D(KE1_RS_SFF_34_n6), .CK(CLK), .Q(
        KE1_KEY_PERM[2]), .QN(KE1_RS_SFF_34_n7) );
  OAI21_X1 KE1_RS_SFF_35_U4 ( .B1(KE1_RS_n11), .B2(KE1_RS_SFF_35_n7), .A(
        KE1_RS_SFF_35_n10), .ZN(KE1_RS_SFF_35_n6) );
  OAI221_X1 KE1_RS_SFF_35_U3 ( .B1(RESET), .B2(KE1_KEY_PERM[35]), .C1(
        KE1_RS_SFF_35_n9), .C2(KEY1[35]), .A(KE1_RS_n11), .ZN(
        KE1_RS_SFF_35_n10) );
  INV_X1 KE1_RS_SFF_35_U2 ( .A(RESET), .ZN(KE1_RS_SFF_35_n9) );
  DFF_X1 KE1_RS_SFF_35_Q_reg ( .D(KE1_RS_SFF_35_n6), .CK(CLK), .Q(
        KE1_KEY_PERM[3]), .QN(KE1_RS_SFF_35_n7) );
  OAI21_X1 KE1_RS_SFF_36_U4 ( .B1(KE1_RS_n11), .B2(KE1_RS_SFF_36_n7), .A(
        KE1_RS_SFF_36_n10), .ZN(KE1_RS_SFF_36_n6) );
  OAI221_X1 KE1_RS_SFF_36_U3 ( .B1(RESET), .B2(KE1_KEY_PERM[36]), .C1(
        KE1_RS_SFF_36_n9), .C2(KEY1[36]), .A(KE1_RS_n11), .ZN(
        KE1_RS_SFF_36_n10) );
  INV_X1 KE1_RS_SFF_36_U2 ( .A(RESET), .ZN(KE1_RS_SFF_36_n9) );
  DFF_X1 KE1_RS_SFF_36_Q_reg ( .D(KE1_RS_SFF_36_n6), .CK(CLK), .Q(
        KE1_KEY_PERM[4]), .QN(KE1_RS_SFF_36_n7) );
  OAI21_X1 KE1_RS_SFF_37_U4 ( .B1(KE1_RS_n7), .B2(KE1_RS_SFF_37_n8), .A(
        KE1_RS_SFF_37_n11), .ZN(KE1_RS_SFF_37_n7) );
  OAI221_X1 KE1_RS_SFF_37_U3 ( .B1(RESET), .B2(KE1_KEY_PERM[37]), .C1(
        KE1_RS_SFF_37_n10), .C2(KEY1[37]), .A(KE1_RS_n7), .ZN(
        KE1_RS_SFF_37_n11) );
  INV_X1 KE1_RS_SFF_37_U2 ( .A(RESET), .ZN(KE1_RS_SFF_37_n10) );
  DFF_X1 KE1_RS_SFF_37_Q_reg ( .D(KE1_RS_SFF_37_n7), .CK(CLK), .Q(
        KE1_KEY_PERM[5]), .QN(KE1_RS_SFF_37_n8) );
  OAI21_X1 KE1_RS_SFF_38_U4 ( .B1(KE1_RS_n7), .B2(KE1_RS_SFF_38_n8), .A(
        KE1_RS_SFF_38_n11), .ZN(KE1_RS_SFF_38_n7) );
  OAI221_X1 KE1_RS_SFF_38_U3 ( .B1(RESET), .B2(KE1_KEY_PERM[38]), .C1(
        KE1_RS_SFF_38_n10), .C2(KEY1[38]), .A(KE1_RS_n7), .ZN(
        KE1_RS_SFF_38_n11) );
  INV_X1 KE1_RS_SFF_38_U2 ( .A(RESET), .ZN(KE1_RS_SFF_38_n10) );
  DFF_X1 KE1_RS_SFF_38_Q_reg ( .D(KE1_RS_SFF_38_n7), .CK(CLK), .Q(
        KE1_KEY_PERM[6]), .QN(KE1_RS_SFF_38_n8) );
  OAI21_X1 KE1_RS_SFF_39_U4 ( .B1(KE1_RS_n11), .B2(KE1_RS_SFF_39_n7), .A(
        KE1_RS_SFF_39_n10), .ZN(KE1_RS_SFF_39_n6) );
  OAI221_X1 KE1_RS_SFF_39_U3 ( .B1(RESET), .B2(KE1_KEY_PERM[39]), .C1(
        KE1_RS_SFF_39_n9), .C2(KEY1[39]), .A(KE1_RS_n11), .ZN(
        KE1_RS_SFF_39_n10) );
  INV_X1 KE1_RS_SFF_39_U2 ( .A(RESET), .ZN(KE1_RS_SFF_39_n9) );
  DFF_X1 KE1_RS_SFF_39_Q_reg ( .D(KE1_RS_SFF_39_n6), .CK(CLK), .Q(
        KE1_KEY_PERM[7]), .QN(KE1_RS_SFF_39_n7) );
  OAI21_X1 KE1_RS_SFF_40_U4 ( .B1(KE1_RS_n12), .B2(KE1_RS_SFF_40_n7), .A(
        KE1_RS_SFF_40_n10), .ZN(KE1_RS_SFF_40_n6) );
  OAI221_X1 KE1_RS_SFF_40_U3 ( .B1(RESET), .B2(KE1_KEY_PERM[40]), .C1(
        KE1_RS_SFF_40_n9), .C2(KEY1[40]), .A(KE1_RS_n12), .ZN(
        KE1_RS_SFF_40_n10) );
  INV_X1 KE1_RS_SFF_40_U2 ( .A(RESET), .ZN(KE1_RS_SFF_40_n9) );
  DFF_X1 KE1_RS_SFF_40_Q_reg ( .D(KE1_RS_SFF_40_n6), .CK(CLK), .Q(
        KE1_KEY_PERM[8]), .QN(KE1_RS_SFF_40_n7) );
  OAI21_X1 KE1_RS_SFF_41_U4 ( .B1(KE1_RS_n12), .B2(KE1_RS_SFF_41_n7), .A(
        KE1_RS_SFF_41_n10), .ZN(KE1_RS_SFF_41_n6) );
  OAI221_X1 KE1_RS_SFF_41_U3 ( .B1(RESET), .B2(KE1_KEY_PERM[41]), .C1(
        KE1_RS_SFF_41_n9), .C2(KEY1[41]), .A(KE1_RS_n12), .ZN(
        KE1_RS_SFF_41_n10) );
  INV_X1 KE1_RS_SFF_41_U2 ( .A(RESET), .ZN(KE1_RS_SFF_41_n9) );
  DFF_X1 KE1_RS_SFF_41_Q_reg ( .D(KE1_RS_SFF_41_n6), .CK(CLK), .Q(
        KE1_KEY_PERM[9]), .QN(KE1_RS_SFF_41_n7) );
  OAI21_X1 KE1_RS_SFF_42_U4 ( .B1(KE1_RS_n12), .B2(KE1_RS_SFF_42_n7), .A(
        KE1_RS_SFF_42_n10), .ZN(KE1_RS_SFF_42_n6) );
  OAI221_X1 KE1_RS_SFF_42_U3 ( .B1(RESET), .B2(KE1_KEY_PERM[42]), .C1(
        KE1_RS_SFF_42_n9), .C2(KEY1[42]), .A(KE1_RS_n12), .ZN(
        KE1_RS_SFF_42_n10) );
  INV_X1 KE1_RS_SFF_42_U2 ( .A(RESET), .ZN(KE1_RS_SFF_42_n9) );
  DFF_X1 KE1_RS_SFF_42_Q_reg ( .D(KE1_RS_SFF_42_n6), .CK(CLK), .Q(
        KE1_KEY_PERM[10]), .QN(KE1_RS_SFF_42_n7) );
  OAI21_X1 KE1_RS_SFF_43_U4 ( .B1(KE1_RS_n12), .B2(KE1_RS_SFF_43_n7), .A(
        KE1_RS_SFF_43_n10), .ZN(KE1_RS_SFF_43_n6) );
  OAI221_X1 KE1_RS_SFF_43_U3 ( .B1(RESET), .B2(KE1_KEY_PERM[43]), .C1(
        KE1_RS_SFF_43_n9), .C2(KEY1[43]), .A(KE1_RS_n12), .ZN(
        KE1_RS_SFF_43_n10) );
  INV_X1 KE1_RS_SFF_43_U2 ( .A(RESET), .ZN(KE1_RS_SFF_43_n9) );
  DFF_X1 KE1_RS_SFF_43_Q_reg ( .D(KE1_RS_SFF_43_n6), .CK(CLK), .Q(
        KE1_KEY_PERM[11]), .QN(KE1_RS_SFF_43_n7) );
  OAI21_X1 KE1_RS_SFF_44_U4 ( .B1(KE1_RS_n12), .B2(KE1_RS_SFF_44_n7), .A(
        KE1_RS_SFF_44_n10), .ZN(KE1_RS_SFF_44_n6) );
  OAI221_X1 KE1_RS_SFF_44_U3 ( .B1(RESET), .B2(KE1_KEY_PERM[44]), .C1(
        KE1_RS_SFF_44_n9), .C2(KEY1[44]), .A(KE1_RS_n12), .ZN(
        KE1_RS_SFF_44_n10) );
  INV_X1 KE1_RS_SFF_44_U2 ( .A(RESET), .ZN(KE1_RS_SFF_44_n9) );
  DFF_X1 KE1_RS_SFF_44_Q_reg ( .D(KE1_RS_SFF_44_n6), .CK(CLK), .Q(
        KE1_KEY_PERM[12]), .QN(KE1_RS_SFF_44_n7) );
  OAI21_X1 KE1_RS_SFF_45_U4 ( .B1(KE1_RS_n12), .B2(KE1_RS_SFF_45_n7), .A(
        KE1_RS_SFF_45_n10), .ZN(KE1_RS_SFF_45_n6) );
  OAI221_X1 KE1_RS_SFF_45_U3 ( .B1(RESET), .B2(KE1_KEY_PERM[45]), .C1(
        KE1_RS_SFF_45_n9), .C2(KEY1[45]), .A(KE1_RS_n12), .ZN(
        KE1_RS_SFF_45_n10) );
  INV_X1 KE1_RS_SFF_45_U2 ( .A(RESET), .ZN(KE1_RS_SFF_45_n9) );
  DFF_X1 KE1_RS_SFF_45_Q_reg ( .D(KE1_RS_SFF_45_n6), .CK(CLK), .Q(
        KE1_KEY_PERM[13]), .QN(KE1_RS_SFF_45_n7) );
  OAI21_X1 KE1_RS_SFF_46_U4 ( .B1(KE1_RS_n12), .B2(KE1_RS_SFF_46_n7), .A(
        KE1_RS_SFF_46_n10), .ZN(KE1_RS_SFF_46_n6) );
  OAI221_X1 KE1_RS_SFF_46_U3 ( .B1(RESET), .B2(KE1_KEY_PERM[46]), .C1(
        KE1_RS_SFF_46_n9), .C2(KEY1[46]), .A(KE1_RS_n12), .ZN(
        KE1_RS_SFF_46_n10) );
  INV_X1 KE1_RS_SFF_46_U2 ( .A(RESET), .ZN(KE1_RS_SFF_46_n9) );
  DFF_X1 KE1_RS_SFF_46_Q_reg ( .D(KE1_RS_SFF_46_n6), .CK(CLK), .Q(
        KE1_KEY_PERM[14]), .QN(KE1_RS_SFF_46_n7) );
  OAI21_X1 KE1_RS_SFF_47_U4 ( .B1(KE1_RS_n12), .B2(KE1_RS_SFF_47_n7), .A(
        KE1_RS_SFF_47_n10), .ZN(KE1_RS_SFF_47_n6) );
  OAI221_X1 KE1_RS_SFF_47_U3 ( .B1(RESET), .B2(KE1_KEY_PERM[47]), .C1(
        KE1_RS_SFF_47_n9), .C2(KEY1[47]), .A(KE1_RS_n12), .ZN(
        KE1_RS_SFF_47_n10) );
  INV_X1 KE1_RS_SFF_47_U2 ( .A(RESET), .ZN(KE1_RS_SFF_47_n9) );
  DFF_X1 KE1_RS_SFF_47_Q_reg ( .D(KE1_RS_SFF_47_n6), .CK(CLK), .Q(
        KE1_KEY_PERM[15]), .QN(KE1_RS_SFF_47_n7) );
  OAI21_X1 KE1_RS_SFF_48_U4 ( .B1(KE1_RS_n7), .B2(KE1_RS_SFF_48_n7), .A(
        KE1_RS_SFF_48_n10), .ZN(KE1_RS_SFF_48_n6) );
  OAI221_X1 KE1_RS_SFF_48_U3 ( .B1(RESET), .B2(KE1_KEY_PERM[48]), .C1(
        KE1_RS_SFF_48_n9), .C2(KEY1[48]), .A(KE1_RS_n7), .ZN(KE1_RS_SFF_48_n10) );
  INV_X1 KE1_RS_SFF_48_U2 ( .A(RESET), .ZN(KE1_RS_SFF_48_n9) );
  DFF_X1 KE1_RS_SFF_48_Q_reg ( .D(KE1_RS_SFF_48_n6), .CK(CLK), .Q(
        KE1_KEY_PERM[16]), .QN(KE1_RS_SFF_48_n7) );
  OAI21_X1 KE1_RS_SFF_49_U4 ( .B1(KE1_RS_n7), .B2(KE1_RS_SFF_49_n8), .A(
        KE1_RS_SFF_49_n11), .ZN(KE1_RS_SFF_49_n7) );
  OAI221_X1 KE1_RS_SFF_49_U3 ( .B1(RESET), .B2(KE1_KEY_PERM[49]), .C1(
        KE1_RS_SFF_49_n10), .C2(KEY1[49]), .A(KE1_RS_n7), .ZN(
        KE1_RS_SFF_49_n11) );
  INV_X1 KE1_RS_SFF_49_U2 ( .A(RESET), .ZN(KE1_RS_SFF_49_n10) );
  DFF_X1 KE1_RS_SFF_49_Q_reg ( .D(KE1_RS_SFF_49_n7), .CK(CLK), .Q(
        KE1_KEY_PERM[17]), .QN(KE1_RS_SFF_49_n8) );
  OAI21_X1 KE1_RS_SFF_50_U4 ( .B1(KE1_RS_n8), .B2(KE1_RS_SFF_50_n8), .A(
        KE1_RS_SFF_50_n11), .ZN(KE1_RS_SFF_50_n7) );
  OAI221_X1 KE1_RS_SFF_50_U3 ( .B1(RESET), .B2(KE1_KEY_PERM[50]), .C1(
        KE1_RS_SFF_50_n10), .C2(KEY1[50]), .A(KE1_RS_n8), .ZN(
        KE1_RS_SFF_50_n11) );
  INV_X1 KE1_RS_SFF_50_U2 ( .A(RESET), .ZN(KE1_RS_SFF_50_n10) );
  DFF_X1 KE1_RS_SFF_50_Q_reg ( .D(KE1_RS_SFF_50_n7), .CK(CLK), .Q(
        KE1_KEY_PERM[18]), .QN(KE1_RS_SFF_50_n8) );
  OAI21_X1 KE1_RS_SFF_51_U4 ( .B1(KE1_RS_n11), .B2(KE1_RS_SFF_51_n7), .A(
        KE1_RS_SFF_51_n10), .ZN(KE1_RS_SFF_51_n6) );
  OAI221_X1 KE1_RS_SFF_51_U3 ( .B1(RESET), .B2(KE1_KEY_PERM[51]), .C1(
        KE1_RS_SFF_51_n9), .C2(KEY1[51]), .A(KE1_RS_n11), .ZN(
        KE1_RS_SFF_51_n10) );
  INV_X1 KE1_RS_SFF_51_U2 ( .A(RESET), .ZN(KE1_RS_SFF_51_n9) );
  DFF_X1 KE1_RS_SFF_51_Q_reg ( .D(KE1_RS_SFF_51_n6), .CK(CLK), .Q(
        KE1_KEY_PERM[19]), .QN(KE1_RS_SFF_51_n7) );
  OAI21_X1 KE1_RS_SFF_52_U4 ( .B1(KE1_RS_n12), .B2(KE1_RS_SFF_52_n7), .A(
        KE1_RS_SFF_52_n10), .ZN(KE1_RS_SFF_52_n6) );
  OAI221_X1 KE1_RS_SFF_52_U3 ( .B1(RESET), .B2(KE1_KEY_PERM[52]), .C1(
        KE1_RS_SFF_52_n9), .C2(KEY1[52]), .A(KE1_RS_n12), .ZN(
        KE1_RS_SFF_52_n10) );
  INV_X1 KE1_RS_SFF_52_U2 ( .A(RESET), .ZN(KE1_RS_SFF_52_n9) );
  DFF_X1 KE1_RS_SFF_52_Q_reg ( .D(KE1_RS_SFF_52_n6), .CK(CLK), .Q(
        KE1_KEY_PERM[20]), .QN(KE1_RS_SFF_52_n7) );
  OAI21_X1 KE1_RS_SFF_53_U4 ( .B1(KE1_RS_n10), .B2(KE1_RS_SFF_53_n7), .A(
        KE1_RS_SFF_53_n10), .ZN(KE1_RS_SFF_53_n6) );
  OAI221_X1 KE1_RS_SFF_53_U3 ( .B1(RESET), .B2(KE1_KEY_PERM[53]), .C1(
        KE1_RS_SFF_53_n9), .C2(KEY1[53]), .A(KE1_RS_n10), .ZN(
        KE1_RS_SFF_53_n10) );
  INV_X1 KE1_RS_SFF_53_U2 ( .A(RESET), .ZN(KE1_RS_SFF_53_n9) );
  DFF_X1 KE1_RS_SFF_53_Q_reg ( .D(KE1_RS_SFF_53_n6), .CK(CLK), .Q(
        KE1_KEY_PERM[21]), .QN(KE1_RS_SFF_53_n7) );
  OAI21_X1 KE1_RS_SFF_54_U4 ( .B1(KE1_RS_n9), .B2(KE1_RS_SFF_54_n7), .A(
        KE1_RS_SFF_54_n10), .ZN(KE1_RS_SFF_54_n6) );
  OAI221_X1 KE1_RS_SFF_54_U3 ( .B1(RESET), .B2(KE1_KEY_PERM[54]), .C1(
        KE1_RS_SFF_54_n9), .C2(KEY1[54]), .A(KE1_RS_n9), .ZN(KE1_RS_SFF_54_n10) );
  INV_X1 KE1_RS_SFF_54_U2 ( .A(RESET), .ZN(KE1_RS_SFF_54_n9) );
  DFF_X1 KE1_RS_SFF_54_Q_reg ( .D(KE1_RS_SFF_54_n6), .CK(CLK), .Q(
        KE1_KEY_PERM[22]), .QN(KE1_RS_SFF_54_n7) );
  OAI21_X1 KE1_RS_SFF_55_U4 ( .B1(KE1_RS_n8), .B2(KE1_RS_SFF_55_n7), .A(
        KE1_RS_SFF_55_n10), .ZN(KE1_RS_SFF_55_n6) );
  OAI221_X1 KE1_RS_SFF_55_U3 ( .B1(RESET), .B2(KE1_KEY_PERM[55]), .C1(
        KE1_RS_SFF_55_n9), .C2(KEY1[55]), .A(KE1_RS_n8), .ZN(KE1_RS_SFF_55_n10) );
  INV_X1 KE1_RS_SFF_55_U2 ( .A(RESET), .ZN(KE1_RS_SFF_55_n9) );
  DFF_X1 KE1_RS_SFF_55_Q_reg ( .D(KE1_RS_SFF_55_n6), .CK(CLK), .Q(
        KE1_KEY_PERM[23]), .QN(KE1_RS_SFF_55_n7) );
  OAI21_X1 KE1_RS_SFF_56_U4 ( .B1(KE1_RS_n7), .B2(KE1_RS_SFF_56_n7), .A(
        KE1_RS_SFF_56_n10), .ZN(KE1_RS_SFF_56_n6) );
  OAI221_X1 KE1_RS_SFF_56_U3 ( .B1(RESET), .B2(KE1_KEY_PERM[56]), .C1(
        KE1_RS_SFF_56_n9), .C2(KEY1[56]), .A(KE1_RS_n7), .ZN(KE1_RS_SFF_56_n10) );
  INV_X1 KE1_RS_SFF_56_U2 ( .A(RESET), .ZN(KE1_RS_SFF_56_n9) );
  DFF_X1 KE1_RS_SFF_56_Q_reg ( .D(KE1_RS_SFF_56_n6), .CK(CLK), .Q(
        KE1_KEY_PERM[24]), .QN(KE1_RS_SFF_56_n7) );
  OAI21_X1 KE1_RS_SFF_57_U4 ( .B1(KE1_RS_n11), .B2(KE1_RS_SFF_57_n7), .A(
        KE1_RS_SFF_57_n10), .ZN(KE1_RS_SFF_57_n6) );
  OAI221_X1 KE1_RS_SFF_57_U3 ( .B1(RESET), .B2(KE1_KEY_PERM[57]), .C1(
        KE1_RS_SFF_57_n9), .C2(KEY1[57]), .A(KE1_RS_n11), .ZN(
        KE1_RS_SFF_57_n10) );
  INV_X1 KE1_RS_SFF_57_U2 ( .A(RESET), .ZN(KE1_RS_SFF_57_n9) );
  DFF_X1 KE1_RS_SFF_57_Q_reg ( .D(KE1_RS_SFF_57_n6), .CK(CLK), .Q(
        KE1_KEY_PERM[25]), .QN(KE1_RS_SFF_57_n7) );
  OAI21_X1 KE1_RS_SFF_58_U4 ( .B1(KEY_EN), .B2(KE1_RS_SFF_58_n7), .A(
        KE1_RS_SFF_58_n10), .ZN(KE1_RS_SFF_58_n6) );
  OAI221_X1 KE1_RS_SFF_58_U3 ( .B1(RESET), .B2(KE1_KEY_PERM[58]), .C1(
        KE1_RS_SFF_58_n9), .C2(KEY1[58]), .A(KEY_EN), .ZN(KE1_RS_SFF_58_n10)
         );
  INV_X1 KE1_RS_SFF_58_U2 ( .A(RESET), .ZN(KE1_RS_SFF_58_n9) );
  DFF_X1 KE1_RS_SFF_58_Q_reg ( .D(KE1_RS_SFF_58_n6), .CK(CLK), .Q(
        KE1_KEY_PERM[26]), .QN(KE1_RS_SFF_58_n7) );
  OAI21_X1 KE1_RS_SFF_59_U4 ( .B1(KE1_RS_n10), .B2(KE1_RS_SFF_59_n7), .A(
        KE1_RS_SFF_59_n10), .ZN(KE1_RS_SFF_59_n6) );
  OAI221_X1 KE1_RS_SFF_59_U3 ( .B1(RESET), .B2(KE1_KEY_PERM[59]), .C1(
        KE1_RS_SFF_59_n9), .C2(KEY1[59]), .A(KE1_RS_n10), .ZN(
        KE1_RS_SFF_59_n10) );
  INV_X1 KE1_RS_SFF_59_U2 ( .A(RESET), .ZN(KE1_RS_SFF_59_n9) );
  DFF_X1 KE1_RS_SFF_59_Q_reg ( .D(KE1_RS_SFF_59_n6), .CK(CLK), .Q(
        KE1_KEY_PERM[27]), .QN(KE1_RS_SFF_59_n7) );
  OAI21_X1 KE1_RS_SFF_60_U4 ( .B1(KE1_RS_n9), .B2(KE1_RS_SFF_60_n7), .A(
        KE1_RS_SFF_60_n10), .ZN(KE1_RS_SFF_60_n6) );
  OAI221_X1 KE1_RS_SFF_60_U3 ( .B1(RESET), .B2(KE1_KEY_PERM[60]), .C1(
        KE1_RS_SFF_60_n9), .C2(KEY1[60]), .A(KE1_RS_n9), .ZN(KE1_RS_SFF_60_n10) );
  INV_X1 KE1_RS_SFF_60_U2 ( .A(RESET), .ZN(KE1_RS_SFF_60_n9) );
  DFF_X1 KE1_RS_SFF_60_Q_reg ( .D(KE1_RS_SFF_60_n6), .CK(CLK), .Q(
        KE1_KEY_PERM[28]), .QN(KE1_RS_SFF_60_n7) );
  OAI21_X1 KE1_RS_SFF_61_U4 ( .B1(KE1_RS_n8), .B2(KE1_RS_SFF_61_n7), .A(
        KE1_RS_SFF_61_n10), .ZN(KE1_RS_SFF_61_n6) );
  OAI221_X1 KE1_RS_SFF_61_U3 ( .B1(RESET), .B2(KE1_KEY_PERM[61]), .C1(
        KE1_RS_SFF_61_n9), .C2(KEY1[61]), .A(KE1_RS_n8), .ZN(KE1_RS_SFF_61_n10) );
  INV_X1 KE1_RS_SFF_61_U2 ( .A(RESET), .ZN(KE1_RS_SFF_61_n9) );
  DFF_X1 KE1_RS_SFF_61_Q_reg ( .D(KE1_RS_SFF_61_n6), .CK(CLK), .Q(
        KE1_KEY_PERM[29]), .QN(KE1_RS_SFF_61_n7) );
  OAI21_X1 KE1_RS_SFF_62_U4 ( .B1(KE1_RS_n7), .B2(KE1_RS_SFF_62_n7), .A(
        KE1_RS_SFF_62_n10), .ZN(KE1_RS_SFF_62_n6) );
  OAI221_X1 KE1_RS_SFF_62_U3 ( .B1(RESET), .B2(KE1_KEY_PERM[62]), .C1(
        KE1_RS_SFF_62_n9), .C2(KEY1[62]), .A(KE1_RS_n7), .ZN(KE1_RS_SFF_62_n10) );
  INV_X1 KE1_RS_SFF_62_U2 ( .A(RESET), .ZN(KE1_RS_SFF_62_n9) );
  DFF_X1 KE1_RS_SFF_62_Q_reg ( .D(KE1_RS_SFF_62_n6), .CK(CLK), .Q(
        KE1_KEY_PERM[30]), .QN(KE1_RS_SFF_62_n7) );
  OAI21_X1 KE1_RS_SFF_63_U4 ( .B1(KE1_RS_n11), .B2(KE1_RS_SFF_63_n7), .A(
        KE1_RS_SFF_63_n10), .ZN(KE1_RS_SFF_63_n6) );
  OAI221_X1 KE1_RS_SFF_63_U3 ( .B1(RESET), .B2(KE1_KEY_PERM[63]), .C1(
        KE1_RS_SFF_63_n9), .C2(KEY1[63]), .A(KE1_RS_n11), .ZN(
        KE1_RS_SFF_63_n10) );
  INV_X1 KE1_RS_SFF_63_U2 ( .A(RESET), .ZN(KE1_RS_SFF_63_n9) );
  DFF_X1 KE1_RS_SFF_63_Q_reg ( .D(KE1_RS_SFF_63_n6), .CK(CLK), .Q(
        KE1_KEY_PERM[31]), .QN(KE1_RS_SFF_63_n7) );
  BUF_X1 KE2_RS_U6 ( .A(KEY_EN), .Z(KE2_RS_n6) );
  BUF_X1 KE2_RS_U5 ( .A(KEY_EN), .Z(KE2_RS_n7) );
  BUF_X1 KE2_RS_U4 ( .A(KEY_EN), .Z(KE2_RS_n8) );
  BUF_X1 KE2_RS_U3 ( .A(KEY_EN), .Z(KE2_RS_n9) );
  BUF_X1 KE2_RS_U2 ( .A(KEY_EN), .Z(KE2_RS_n10) );
  BUF_X1 KE2_RS_U1 ( .A(KEY_EN), .Z(KE2_RS_n11) );
  OAI21_X1 KE2_RS_SFF_0_U4 ( .B1(KE2_RS_n6), .B2(KE2_RS_SFF_0_n8), .A(
        KE2_RS_SFF_0_n11), .ZN(KE2_RS_SFF_0_n7) );
  OAI221_X1 KE2_RS_SFF_0_U3 ( .B1(RESET), .B2(KE2_KEY_PERM[0]), .C1(
        KE2_RS_SFF_0_n10), .C2(KEY2[0]), .A(KE2_RS_n6), .ZN(KE2_RS_SFF_0_n11)
         );
  INV_X1 KE2_RS_SFF_0_U2 ( .A(RESET), .ZN(KE2_RS_SFF_0_n10) );
  DFF_X1 KE2_RS_SFF_0_Q_reg ( .D(KE2_RS_SFF_0_n7), .CK(CLK), .Q(
        KE2_KEY_PERM[56]), .QN(KE2_RS_SFF_0_n8) );
  OAI21_X1 KE2_RS_SFF_1_U4 ( .B1(KE2_RS_n6), .B2(KE2_RS_SFF_1_n8), .A(
        KE2_RS_SFF_1_n11), .ZN(KE2_RS_SFF_1_n7) );
  OAI221_X1 KE2_RS_SFF_1_U3 ( .B1(RESET), .B2(KE2_KEY_PERM[1]), .C1(
        KE2_RS_SFF_1_n10), .C2(KEY2[1]), .A(KE2_RS_n6), .ZN(KE2_RS_SFF_1_n11)
         );
  INV_X1 KE2_RS_SFF_1_U2 ( .A(RESET), .ZN(KE2_RS_SFF_1_n10) );
  DFF_X1 KE2_RS_SFF_1_Q_reg ( .D(KE2_RS_SFF_1_n7), .CK(CLK), .Q(
        KE2_KEY_PERM[57]), .QN(KE2_RS_SFF_1_n8) );
  OAI21_X1 KE2_RS_SFF_2_U4 ( .B1(KE2_RS_n7), .B2(KE2_RS_SFF_2_n7), .A(
        KE2_RS_SFF_2_n10), .ZN(KE2_RS_SFF_2_n6) );
  OAI221_X1 KE2_RS_SFF_2_U3 ( .B1(RESET), .B2(KE2_KEY_PERM[2]), .C1(
        KE2_RS_SFF_2_n9), .C2(KEY2[2]), .A(KE2_RS_n7), .ZN(KE2_RS_SFF_2_n10)
         );
  INV_X1 KE2_RS_SFF_2_U2 ( .A(RESET), .ZN(KE2_RS_SFF_2_n9) );
  DFF_X1 KE2_RS_SFF_2_Q_reg ( .D(KE2_RS_SFF_2_n6), .CK(CLK), .Q(
        KE2_KEY_PERM[58]), .QN(KE2_RS_SFF_2_n7) );
  OAI21_X1 KE2_RS_SFF_3_U4 ( .B1(KE2_RS_n7), .B2(KE2_RS_SFF_3_n7), .A(
        KE2_RS_SFF_3_n10), .ZN(KE2_RS_SFF_3_n6) );
  OAI221_X1 KE2_RS_SFF_3_U3 ( .B1(RESET), .B2(KE2_KEY_PERM[3]), .C1(
        KE2_RS_SFF_3_n9), .C2(KEY2[3]), .A(KE2_RS_n7), .ZN(KE2_RS_SFF_3_n10)
         );
  INV_X1 KE2_RS_SFF_3_U2 ( .A(RESET), .ZN(KE2_RS_SFF_3_n9) );
  DFF_X1 KE2_RS_SFF_3_Q_reg ( .D(KE2_RS_SFF_3_n6), .CK(CLK), .Q(
        KE2_KEY_PERM[59]), .QN(KE2_RS_SFF_3_n7) );
  OAI21_X1 KE2_RS_SFF_4_U4 ( .B1(KE2_RS_n7), .B2(KE2_RS_SFF_4_n7), .A(
        KE2_RS_SFF_4_n10), .ZN(KE2_RS_SFF_4_n6) );
  OAI221_X1 KE2_RS_SFF_4_U3 ( .B1(RESET), .B2(KE2_KEY_PERM[4]), .C1(
        KE2_RS_SFF_4_n9), .C2(KEY2[4]), .A(KE2_RS_n7), .ZN(KE2_RS_SFF_4_n10)
         );
  INV_X1 KE2_RS_SFF_4_U2 ( .A(RESET), .ZN(KE2_RS_SFF_4_n9) );
  DFF_X1 KE2_RS_SFF_4_Q_reg ( .D(KE2_RS_SFF_4_n6), .CK(CLK), .Q(
        KE2_KEY_PERM[40]), .QN(KE2_RS_SFF_4_n7) );
  OAI21_X1 KE2_RS_SFF_5_U4 ( .B1(KE2_RS_n7), .B2(KE2_RS_SFF_5_n7), .A(
        KE2_RS_SFF_5_n10), .ZN(KE2_RS_SFF_5_n6) );
  OAI221_X1 KE2_RS_SFF_5_U3 ( .B1(RESET), .B2(KE2_KEY_PERM[5]), .C1(
        KE2_RS_SFF_5_n9), .C2(KEY2[5]), .A(KE2_RS_n7), .ZN(KE2_RS_SFF_5_n10)
         );
  INV_X1 KE2_RS_SFF_5_U2 ( .A(RESET), .ZN(KE2_RS_SFF_5_n9) );
  DFF_X1 KE2_RS_SFF_5_Q_reg ( .D(KE2_RS_SFF_5_n6), .CK(CLK), .Q(
        KE2_KEY_PERM[41]), .QN(KE2_RS_SFF_5_n7) );
  OAI21_X1 KE2_RS_SFF_6_U4 ( .B1(KE2_RS_n7), .B2(KE2_RS_SFF_6_n7), .A(
        KE2_RS_SFF_6_n10), .ZN(KE2_RS_SFF_6_n6) );
  OAI221_X1 KE2_RS_SFF_6_U3 ( .B1(RESET), .B2(KE2_KEY_PERM[6]), .C1(
        KE2_RS_SFF_6_n9), .C2(KEY2[6]), .A(KE2_RS_n7), .ZN(KE2_RS_SFF_6_n10)
         );
  INV_X1 KE2_RS_SFF_6_U2 ( .A(RESET), .ZN(KE2_RS_SFF_6_n9) );
  DFF_X1 KE2_RS_SFF_6_Q_reg ( .D(KE2_RS_SFF_6_n6), .CK(CLK), .Q(
        KE2_KEY_PERM[42]), .QN(KE2_RS_SFF_6_n7) );
  OAI21_X1 KE2_RS_SFF_7_U4 ( .B1(KE2_RS_n7), .B2(KE2_RS_SFF_7_n7), .A(
        KE2_RS_SFF_7_n10), .ZN(KE2_RS_SFF_7_n6) );
  OAI221_X1 KE2_RS_SFF_7_U3 ( .B1(RESET), .B2(KE2_KEY_PERM[7]), .C1(
        KE2_RS_SFF_7_n9), .C2(KEY2[7]), .A(KE2_RS_n7), .ZN(KE2_RS_SFF_7_n10)
         );
  INV_X1 KE2_RS_SFF_7_U2 ( .A(RESET), .ZN(KE2_RS_SFF_7_n9) );
  DFF_X1 KE2_RS_SFF_7_Q_reg ( .D(KE2_RS_SFF_7_n6), .CK(CLK), .Q(
        KE2_KEY_PERM[43]), .QN(KE2_RS_SFF_7_n7) );
  OAI21_X1 KE2_RS_SFF_8_U4 ( .B1(KE2_RS_n7), .B2(KE2_RS_SFF_8_n7), .A(
        KE2_RS_SFF_8_n10), .ZN(KE2_RS_SFF_8_n6) );
  OAI221_X1 KE2_RS_SFF_8_U3 ( .B1(RESET), .B2(KE2_KEY_PERM[8]), .C1(
        KE2_RS_SFF_8_n9), .C2(KEY2[8]), .A(KE2_RS_n7), .ZN(KE2_RS_SFF_8_n10)
         );
  INV_X1 KE2_RS_SFF_8_U2 ( .A(RESET), .ZN(KE2_RS_SFF_8_n9) );
  DFF_X1 KE2_RS_SFF_8_Q_reg ( .D(KE2_RS_SFF_8_n6), .CK(CLK), .Q(
        KE2_KEY_PERM[48]), .QN(KE2_RS_SFF_8_n7) );
  OAI21_X1 KE2_RS_SFF_9_U4 ( .B1(KE2_RS_n7), .B2(KE2_RS_SFF_9_n7), .A(
        KE2_RS_SFF_9_n10), .ZN(KE2_RS_SFF_9_n6) );
  OAI221_X1 KE2_RS_SFF_9_U3 ( .B1(RESET), .B2(KE2_KEY_PERM[9]), .C1(
        KE2_RS_SFF_9_n9), .C2(KEY2[9]), .A(KE2_RS_n7), .ZN(KE2_RS_SFF_9_n10)
         );
  INV_X1 KE2_RS_SFF_9_U2 ( .A(RESET), .ZN(KE2_RS_SFF_9_n9) );
  DFF_X1 KE2_RS_SFF_9_Q_reg ( .D(KE2_RS_SFF_9_n6), .CK(CLK), .Q(
        KE2_KEY_PERM[49]), .QN(KE2_RS_SFF_9_n7) );
  OAI21_X1 KE2_RS_SFF_10_U4 ( .B1(KE2_RS_n8), .B2(KE2_RS_SFF_10_n7), .A(
        KE2_RS_SFF_10_n10), .ZN(KE2_RS_SFF_10_n6) );
  OAI221_X1 KE2_RS_SFF_10_U3 ( .B1(RESET), .B2(KE2_KEY_PERM[10]), .C1(
        KE2_RS_SFF_10_n9), .C2(KEY2[10]), .A(KE2_RS_n8), .ZN(KE2_RS_SFF_10_n10) );
  INV_X1 KE2_RS_SFF_10_U2 ( .A(RESET), .ZN(KE2_RS_SFF_10_n9) );
  DFF_X1 KE2_RS_SFF_10_Q_reg ( .D(KE2_RS_SFF_10_n6), .CK(CLK), .Q(
        KE2_KEY_PERM[50]), .QN(KE2_RS_SFF_10_n7) );
  OAI21_X1 KE2_RS_SFF_11_U4 ( .B1(KE2_RS_n8), .B2(KE2_RS_SFF_11_n7), .A(
        KE2_RS_SFF_11_n10), .ZN(KE2_RS_SFF_11_n6) );
  OAI221_X1 KE2_RS_SFF_11_U3 ( .B1(RESET), .B2(KE2_KEY_PERM[11]), .C1(
        KE2_RS_SFF_11_n9), .C2(KEY2[11]), .A(KE2_RS_n8), .ZN(KE2_RS_SFF_11_n10) );
  INV_X1 KE2_RS_SFF_11_U2 ( .A(RESET), .ZN(KE2_RS_SFF_11_n9) );
  DFF_X1 KE2_RS_SFF_11_Q_reg ( .D(KE2_RS_SFF_11_n6), .CK(CLK), .Q(
        KE2_KEY_PERM[51]), .QN(KE2_RS_SFF_11_n7) );
  OAI21_X1 KE2_RS_SFF_12_U4 ( .B1(KE2_RS_n6), .B2(KE2_RS_SFF_12_n8), .A(
        KE2_RS_SFF_12_n11), .ZN(KE2_RS_SFF_12_n7) );
  OAI221_X1 KE2_RS_SFF_12_U3 ( .B1(RESET), .B2(KE2_KEY_PERM[12]), .C1(
        KE2_RS_SFF_12_n10), .C2(KEY2[12]), .A(KE2_RS_n6), .ZN(
        KE2_RS_SFF_12_n11) );
  INV_X1 KE2_RS_SFF_12_U2 ( .A(RESET), .ZN(KE2_RS_SFF_12_n10) );
  DFF_X1 KE2_RS_SFF_12_Q_reg ( .D(KE2_RS_SFF_12_n7), .CK(CLK), .Q(
        KE2_KEY_PERM[36]), .QN(KE2_RS_SFF_12_n8) );
  OAI21_X1 KE2_RS_SFF_13_U4 ( .B1(KE2_RS_n6), .B2(KE2_RS_SFF_13_n8), .A(
        KE2_RS_SFF_13_n11), .ZN(KE2_RS_SFF_13_n7) );
  OAI221_X1 KE2_RS_SFF_13_U3 ( .B1(RESET), .B2(KE2_KEY_PERM[13]), .C1(
        KE2_RS_SFF_13_n10), .C2(KEY2[13]), .A(KE2_RS_n6), .ZN(
        KE2_RS_SFF_13_n11) );
  INV_X1 KE2_RS_SFF_13_U2 ( .A(RESET), .ZN(KE2_RS_SFF_13_n10) );
  DFF_X1 KE2_RS_SFF_13_Q_reg ( .D(KE2_RS_SFF_13_n7), .CK(CLK), .Q(
        KE2_KEY_PERM[37]), .QN(KE2_RS_SFF_13_n8) );
  OAI21_X1 KE2_RS_SFF_14_U4 ( .B1(KE2_RS_n8), .B2(KE2_RS_SFF_14_n7), .A(
        KE2_RS_SFF_14_n10), .ZN(KE2_RS_SFF_14_n6) );
  OAI221_X1 KE2_RS_SFF_14_U3 ( .B1(RESET), .B2(KE2_KEY_PERM[14]), .C1(
        KE2_RS_SFF_14_n9), .C2(KEY2[14]), .A(KE2_RS_n8), .ZN(KE2_RS_SFF_14_n10) );
  INV_X1 KE2_RS_SFF_14_U2 ( .A(RESET), .ZN(KE2_RS_SFF_14_n9) );
  DFF_X1 KE2_RS_SFF_14_Q_reg ( .D(KE2_RS_SFF_14_n6), .CK(CLK), .Q(
        KE2_KEY_PERM[38]), .QN(KE2_RS_SFF_14_n7) );
  OAI21_X1 KE2_RS_SFF_15_U4 ( .B1(KE2_RS_n8), .B2(KE2_RS_SFF_15_n7), .A(
        KE2_RS_SFF_15_n10), .ZN(KE2_RS_SFF_15_n6) );
  OAI221_X1 KE2_RS_SFF_15_U3 ( .B1(RESET), .B2(KE2_KEY_PERM[15]), .C1(
        KE2_RS_SFF_15_n9), .C2(KEY2[15]), .A(KE2_RS_n8), .ZN(KE2_RS_SFF_15_n10) );
  INV_X1 KE2_RS_SFF_15_U2 ( .A(RESET), .ZN(KE2_RS_SFF_15_n9) );
  DFF_X1 KE2_RS_SFF_15_Q_reg ( .D(KE2_RS_SFF_15_n6), .CK(CLK), .Q(
        KE2_KEY_PERM[39]), .QN(KE2_RS_SFF_15_n7) );
  OAI21_X1 KE2_RS_SFF_16_U4 ( .B1(KE2_RS_n8), .B2(KE2_RS_SFF_16_n7), .A(
        KE2_RS_SFF_16_n10), .ZN(KE2_RS_SFF_16_n6) );
  OAI221_X1 KE2_RS_SFF_16_U3 ( .B1(RESET), .B2(KE2_KEY_PERM[16]), .C1(
        KE2_RS_SFF_16_n9), .C2(KEY2[16]), .A(KE2_RS_n8), .ZN(KE2_RS_SFF_16_n10) );
  INV_X1 KE2_RS_SFF_16_U2 ( .A(RESET), .ZN(KE2_RS_SFF_16_n9) );
  DFF_X1 KE2_RS_SFF_16_Q_reg ( .D(KE2_RS_SFF_16_n6), .CK(CLK), .Q(
        KE2_KEY_PERM[32]), .QN(KE2_RS_SFF_16_n7) );
  OAI21_X1 KE2_RS_SFF_17_U4 ( .B1(KE2_RS_n8), .B2(KE2_RS_SFF_17_n7), .A(
        KE2_RS_SFF_17_n10), .ZN(KE2_RS_SFF_17_n6) );
  OAI221_X1 KE2_RS_SFF_17_U3 ( .B1(RESET), .B2(KE2_KEY_PERM[17]), .C1(
        KE2_RS_SFF_17_n9), .C2(KEY2[17]), .A(KE2_RS_n8), .ZN(KE2_RS_SFF_17_n10) );
  INV_X1 KE2_RS_SFF_17_U2 ( .A(RESET), .ZN(KE2_RS_SFF_17_n9) );
  DFF_X1 KE2_RS_SFF_17_Q_reg ( .D(KE2_RS_SFF_17_n6), .CK(CLK), .Q(
        KE2_KEY_PERM[33]), .QN(KE2_RS_SFF_17_n7) );
  OAI21_X1 KE2_RS_SFF_18_U4 ( .B1(KE2_RS_n8), .B2(KE2_RS_SFF_18_n7), .A(
        KE2_RS_SFF_18_n10), .ZN(KE2_RS_SFF_18_n6) );
  OAI221_X1 KE2_RS_SFF_18_U3 ( .B1(RESET), .B2(KE2_KEY_PERM[18]), .C1(
        KE2_RS_SFF_18_n9), .C2(KEY2[18]), .A(KE2_RS_n8), .ZN(KE2_RS_SFF_18_n10) );
  INV_X1 KE2_RS_SFF_18_U2 ( .A(RESET), .ZN(KE2_RS_SFF_18_n9) );
  DFF_X1 KE2_RS_SFF_18_Q_reg ( .D(KE2_RS_SFF_18_n6), .CK(CLK), .Q(
        KE2_KEY_PERM[34]), .QN(KE2_RS_SFF_18_n7) );
  OAI21_X1 KE2_RS_SFF_19_U4 ( .B1(KE2_RS_n8), .B2(KE2_RS_SFF_19_n7), .A(
        KE2_RS_SFF_19_n10), .ZN(KE2_RS_SFF_19_n6) );
  OAI221_X1 KE2_RS_SFF_19_U3 ( .B1(RESET), .B2(KE2_KEY_PERM[19]), .C1(
        KE2_RS_SFF_19_n9), .C2(KEY2[19]), .A(KE2_RS_n8), .ZN(KE2_RS_SFF_19_n10) );
  INV_X1 KE2_RS_SFF_19_U2 ( .A(RESET), .ZN(KE2_RS_SFF_19_n9) );
  DFF_X1 KE2_RS_SFF_19_Q_reg ( .D(KE2_RS_SFF_19_n6), .CK(CLK), .Q(
        KE2_KEY_PERM[35]), .QN(KE2_RS_SFF_19_n7) );
  OAI21_X1 KE2_RS_SFF_20_U4 ( .B1(KE2_RS_n9), .B2(KE2_RS_SFF_20_n7), .A(
        KE2_RS_SFF_20_n10), .ZN(KE2_RS_SFF_20_n6) );
  OAI221_X1 KE2_RS_SFF_20_U3 ( .B1(RESET), .B2(KE2_KEY_PERM[20]), .C1(
        KE2_RS_SFF_20_n9), .C2(KEY2[20]), .A(KE2_RS_n9), .ZN(KE2_RS_SFF_20_n10) );
  INV_X1 KE2_RS_SFF_20_U2 ( .A(RESET), .ZN(KE2_RS_SFF_20_n9) );
  DFF_X1 KE2_RS_SFF_20_Q_reg ( .D(KE2_RS_SFF_20_n6), .CK(CLK), .Q(
        KE2_KEY_PERM[44]), .QN(KE2_RS_SFF_20_n7) );
  OAI21_X1 KE2_RS_SFF_21_U4 ( .B1(KE2_RS_n9), .B2(KE2_RS_SFF_21_n7), .A(
        KE2_RS_SFF_21_n10), .ZN(KE2_RS_SFF_21_n6) );
  OAI221_X1 KE2_RS_SFF_21_U3 ( .B1(RESET), .B2(KE2_KEY_PERM[21]), .C1(
        KE2_RS_SFF_21_n9), .C2(KEY2[21]), .A(KE2_RS_n9), .ZN(KE2_RS_SFF_21_n10) );
  INV_X1 KE2_RS_SFF_21_U2 ( .A(RESET), .ZN(KE2_RS_SFF_21_n9) );
  DFF_X1 KE2_RS_SFF_21_Q_reg ( .D(KE2_RS_SFF_21_n6), .CK(CLK), .Q(
        KE2_KEY_PERM[45]), .QN(KE2_RS_SFF_21_n7) );
  OAI21_X1 KE2_RS_SFF_22_U4 ( .B1(KE2_RS_n9), .B2(KE2_RS_SFF_22_n7), .A(
        KE2_RS_SFF_22_n10), .ZN(KE2_RS_SFF_22_n6) );
  OAI221_X1 KE2_RS_SFF_22_U3 ( .B1(RESET), .B2(KE2_KEY_PERM[22]), .C1(
        KE2_RS_SFF_22_n9), .C2(KEY2[22]), .A(KE2_RS_n9), .ZN(KE2_RS_SFF_22_n10) );
  INV_X1 KE2_RS_SFF_22_U2 ( .A(RESET), .ZN(KE2_RS_SFF_22_n9) );
  DFF_X1 KE2_RS_SFF_22_Q_reg ( .D(KE2_RS_SFF_22_n6), .CK(CLK), .Q(
        KE2_KEY_PERM[46]), .QN(KE2_RS_SFF_22_n7) );
  OAI21_X1 KE2_RS_SFF_23_U4 ( .B1(KE2_RS_n9), .B2(KE2_RS_SFF_23_n7), .A(
        KE2_RS_SFF_23_n10), .ZN(KE2_RS_SFF_23_n6) );
  OAI221_X1 KE2_RS_SFF_23_U3 ( .B1(RESET), .B2(KE2_KEY_PERM[23]), .C1(
        KE2_RS_SFF_23_n9), .C2(KEY2[23]), .A(KE2_RS_n9), .ZN(KE2_RS_SFF_23_n10) );
  INV_X1 KE2_RS_SFF_23_U2 ( .A(RESET), .ZN(KE2_RS_SFF_23_n9) );
  DFF_X1 KE2_RS_SFF_23_Q_reg ( .D(KE2_RS_SFF_23_n6), .CK(CLK), .Q(
        KE2_KEY_PERM[47]), .QN(KE2_RS_SFF_23_n7) );
  OAI21_X1 KE2_RS_SFF_24_U4 ( .B1(KE2_RS_n6), .B2(KE2_RS_SFF_24_n8), .A(
        KE2_RS_SFF_24_n11), .ZN(KE2_RS_SFF_24_n7) );
  OAI221_X1 KE2_RS_SFF_24_U3 ( .B1(RESET), .B2(KE2_KEY_PERM[24]), .C1(
        KE2_RS_SFF_24_n10), .C2(KEY2[24]), .A(KE2_RS_n6), .ZN(
        KE2_RS_SFF_24_n11) );
  INV_X1 KE2_RS_SFF_24_U2 ( .A(RESET), .ZN(KE2_RS_SFF_24_n10) );
  DFF_X1 KE2_RS_SFF_24_Q_reg ( .D(KE2_RS_SFF_24_n7), .CK(CLK), .Q(
        KE2_KEY_PERM[60]), .QN(KE2_RS_SFF_24_n8) );
  OAI21_X1 KE2_RS_SFF_25_U4 ( .B1(KE2_RS_n6), .B2(KE2_RS_SFF_25_n8), .A(
        KE2_RS_SFF_25_n11), .ZN(KE2_RS_SFF_25_n7) );
  OAI221_X1 KE2_RS_SFF_25_U3 ( .B1(RESET), .B2(KE2_KEY_PERM[25]), .C1(
        KE2_RS_SFF_25_n10), .C2(KEY2[25]), .A(KE2_RS_n6), .ZN(
        KE2_RS_SFF_25_n11) );
  INV_X1 KE2_RS_SFF_25_U2 ( .A(RESET), .ZN(KE2_RS_SFF_25_n10) );
  DFF_X1 KE2_RS_SFF_25_Q_reg ( .D(KE2_RS_SFF_25_n7), .CK(CLK), .Q(
        KE2_KEY_PERM[61]), .QN(KE2_RS_SFF_25_n8) );
  OAI21_X1 KE2_RS_SFF_26_U4 ( .B1(KE2_RS_n9), .B2(KE2_RS_SFF_26_n7), .A(
        KE2_RS_SFF_26_n10), .ZN(KE2_RS_SFF_26_n6) );
  OAI221_X1 KE2_RS_SFF_26_U3 ( .B1(RESET), .B2(KE2_KEY_PERM[26]), .C1(
        KE2_RS_SFF_26_n9), .C2(KEY2[26]), .A(KE2_RS_n9), .ZN(KE2_RS_SFF_26_n10) );
  INV_X1 KE2_RS_SFF_26_U2 ( .A(RESET), .ZN(KE2_RS_SFF_26_n9) );
  DFF_X1 KE2_RS_SFF_26_Q_reg ( .D(KE2_RS_SFF_26_n6), .CK(CLK), .Q(
        KE2_KEY_PERM[62]), .QN(KE2_RS_SFF_26_n7) );
  OAI21_X1 KE2_RS_SFF_27_U4 ( .B1(KE2_RS_n9), .B2(KE2_RS_SFF_27_n7), .A(
        KE2_RS_SFF_27_n10), .ZN(KE2_RS_SFF_27_n6) );
  OAI221_X1 KE2_RS_SFF_27_U3 ( .B1(RESET), .B2(KE2_KEY_PERM[27]), .C1(
        KE2_RS_SFF_27_n9), .C2(KEY2[27]), .A(KE2_RS_n9), .ZN(KE2_RS_SFF_27_n10) );
  INV_X1 KE2_RS_SFF_27_U2 ( .A(RESET), .ZN(KE2_RS_SFF_27_n9) );
  DFF_X1 KE2_RS_SFF_27_Q_reg ( .D(KE2_RS_SFF_27_n6), .CK(CLK), .Q(
        KE2_KEY_PERM[63]), .QN(KE2_RS_SFF_27_n7) );
  OAI21_X1 KE2_RS_SFF_28_U4 ( .B1(KE2_RS_n9), .B2(KE2_RS_SFF_28_n7), .A(
        KE2_RS_SFF_28_n10), .ZN(KE2_RS_SFF_28_n6) );
  OAI221_X1 KE2_RS_SFF_28_U3 ( .B1(RESET), .B2(KE2_KEY_PERM[28]), .C1(
        KE2_RS_SFF_28_n9), .C2(KEY2[28]), .A(KE2_RS_n9), .ZN(KE2_RS_SFF_28_n10) );
  INV_X1 KE2_RS_SFF_28_U2 ( .A(RESET), .ZN(KE2_RS_SFF_28_n9) );
  DFF_X1 KE2_RS_SFF_28_Q_reg ( .D(KE2_RS_SFF_28_n6), .CK(CLK), .Q(
        KE2_KEY_PERM[52]), .QN(KE2_RS_SFF_28_n7) );
  OAI21_X1 KE2_RS_SFF_29_U4 ( .B1(KE2_RS_n9), .B2(KE2_RS_SFF_29_n7), .A(
        KE2_RS_SFF_29_n10), .ZN(KE2_RS_SFF_29_n6) );
  OAI221_X1 KE2_RS_SFF_29_U3 ( .B1(RESET), .B2(KE2_KEY_PERM[29]), .C1(
        KE2_RS_SFF_29_n9), .C2(KEY2[29]), .A(KE2_RS_n9), .ZN(KE2_RS_SFF_29_n10) );
  INV_X1 KE2_RS_SFF_29_U2 ( .A(RESET), .ZN(KE2_RS_SFF_29_n9) );
  DFF_X1 KE2_RS_SFF_29_Q_reg ( .D(KE2_RS_SFF_29_n6), .CK(CLK), .Q(
        KE2_KEY_PERM[53]), .QN(KE2_RS_SFF_29_n7) );
  OAI21_X1 KE2_RS_SFF_30_U4 ( .B1(KE2_RS_n10), .B2(KE2_RS_SFF_30_n7), .A(
        KE2_RS_SFF_30_n10), .ZN(KE2_RS_SFF_30_n6) );
  OAI221_X1 KE2_RS_SFF_30_U3 ( .B1(RESET), .B2(KE2_KEY_PERM[30]), .C1(
        KE2_RS_SFF_30_n9), .C2(KEY2[30]), .A(KE2_RS_n10), .ZN(
        KE2_RS_SFF_30_n10) );
  INV_X1 KE2_RS_SFF_30_U2 ( .A(RESET), .ZN(KE2_RS_SFF_30_n9) );
  DFF_X1 KE2_RS_SFF_30_Q_reg ( .D(KE2_RS_SFF_30_n6), .CK(CLK), .Q(
        KE2_KEY_PERM[54]), .QN(KE2_RS_SFF_30_n7) );
  OAI21_X1 KE2_RS_SFF_31_U4 ( .B1(KE2_RS_n10), .B2(KE2_RS_SFF_31_n7), .A(
        KE2_RS_SFF_31_n10), .ZN(KE2_RS_SFF_31_n6) );
  OAI221_X1 KE2_RS_SFF_31_U3 ( .B1(RESET), .B2(KE2_KEY_PERM[31]), .C1(
        KE2_RS_SFF_31_n9), .C2(KEY2[31]), .A(KE2_RS_n10), .ZN(
        KE2_RS_SFF_31_n10) );
  INV_X1 KE2_RS_SFF_31_U2 ( .A(RESET), .ZN(KE2_RS_SFF_31_n9) );
  DFF_X1 KE2_RS_SFF_31_Q_reg ( .D(KE2_RS_SFF_31_n6), .CK(CLK), .Q(
        KE2_KEY_PERM[55]), .QN(KE2_RS_SFF_31_n7) );
  OAI21_X1 KE2_RS_SFF_32_U4 ( .B1(KE2_RS_n10), .B2(KE2_RS_SFF_32_n7), .A(
        KE2_RS_SFF_32_n10), .ZN(KE2_RS_SFF_32_n6) );
  OAI221_X1 KE2_RS_SFF_32_U3 ( .B1(RESET), .B2(KE2_KEY_PERM[32]), .C1(
        KE2_RS_SFF_32_n9), .C2(KEY2[32]), .A(KE2_RS_n10), .ZN(
        KE2_RS_SFF_32_n10) );
  INV_X1 KE2_RS_SFF_32_U2 ( .A(RESET), .ZN(KE2_RS_SFF_32_n9) );
  DFF_X1 KE2_RS_SFF_32_Q_reg ( .D(KE2_RS_SFF_32_n6), .CK(CLK), .Q(
        KE2_KEY_PERM[0]), .QN(KE2_RS_SFF_32_n7) );
  OAI21_X1 KE2_RS_SFF_33_U4 ( .B1(KE2_RS_n10), .B2(KE2_RS_SFF_33_n7), .A(
        KE2_RS_SFF_33_n10), .ZN(KE2_RS_SFF_33_n6) );
  OAI221_X1 KE2_RS_SFF_33_U3 ( .B1(RESET), .B2(KE2_KEY_PERM[33]), .C1(
        KE2_RS_SFF_33_n9), .C2(KEY2[33]), .A(KE2_RS_n10), .ZN(
        KE2_RS_SFF_33_n10) );
  INV_X1 KE2_RS_SFF_33_U2 ( .A(RESET), .ZN(KE2_RS_SFF_33_n9) );
  DFF_X1 KE2_RS_SFF_33_Q_reg ( .D(KE2_RS_SFF_33_n6), .CK(CLK), .Q(
        KE2_KEY_PERM[1]), .QN(KE2_RS_SFF_33_n7) );
  OAI21_X1 KE2_RS_SFF_34_U4 ( .B1(KE2_RS_n10), .B2(KE2_RS_SFF_34_n7), .A(
        KE2_RS_SFF_34_n10), .ZN(KE2_RS_SFF_34_n6) );
  OAI221_X1 KE2_RS_SFF_34_U3 ( .B1(RESET), .B2(KE2_KEY_PERM[34]), .C1(
        KE2_RS_SFF_34_n9), .C2(KEY2[34]), .A(KE2_RS_n10), .ZN(
        KE2_RS_SFF_34_n10) );
  INV_X1 KE2_RS_SFF_34_U2 ( .A(RESET), .ZN(KE2_RS_SFF_34_n9) );
  DFF_X1 KE2_RS_SFF_34_Q_reg ( .D(KE2_RS_SFF_34_n6), .CK(CLK), .Q(
        KE2_KEY_PERM[2]), .QN(KE2_RS_SFF_34_n7) );
  OAI21_X1 KE2_RS_SFF_35_U4 ( .B1(KE2_RS_n10), .B2(KE2_RS_SFF_35_n7), .A(
        KE2_RS_SFF_35_n10), .ZN(KE2_RS_SFF_35_n6) );
  OAI221_X1 KE2_RS_SFF_35_U3 ( .B1(RESET), .B2(KE2_KEY_PERM[35]), .C1(
        KE2_RS_SFF_35_n9), .C2(KEY2[35]), .A(KE2_RS_n10), .ZN(
        KE2_RS_SFF_35_n10) );
  INV_X1 KE2_RS_SFF_35_U2 ( .A(RESET), .ZN(KE2_RS_SFF_35_n9) );
  DFF_X1 KE2_RS_SFF_35_Q_reg ( .D(KE2_RS_SFF_35_n6), .CK(CLK), .Q(
        KE2_KEY_PERM[3]), .QN(KE2_RS_SFF_35_n7) );
  OAI21_X1 KE2_RS_SFF_36_U4 ( .B1(KE2_RS_n6), .B2(KE2_RS_SFF_36_n8), .A(
        KE2_RS_SFF_36_n11), .ZN(KE2_RS_SFF_36_n7) );
  OAI221_X1 KE2_RS_SFF_36_U3 ( .B1(RESET), .B2(KE2_KEY_PERM[36]), .C1(
        KE2_RS_SFF_36_n10), .C2(KEY2[36]), .A(KE2_RS_n6), .ZN(
        KE2_RS_SFF_36_n11) );
  INV_X1 KE2_RS_SFF_36_U2 ( .A(RESET), .ZN(KE2_RS_SFF_36_n10) );
  DFF_X1 KE2_RS_SFF_36_Q_reg ( .D(KE2_RS_SFF_36_n7), .CK(CLK), .Q(
        KE2_KEY_PERM[4]), .QN(KE2_RS_SFF_36_n8) );
  OAI21_X1 KE2_RS_SFF_37_U4 ( .B1(KE2_RS_n6), .B2(KE2_RS_SFF_37_n8), .A(
        KE2_RS_SFF_37_n11), .ZN(KE2_RS_SFF_37_n7) );
  OAI221_X1 KE2_RS_SFF_37_U3 ( .B1(RESET), .B2(KE2_KEY_PERM[37]), .C1(
        KE2_RS_SFF_37_n10), .C2(KEY2[37]), .A(KE2_RS_n6), .ZN(
        KE2_RS_SFF_37_n11) );
  INV_X1 KE2_RS_SFF_37_U2 ( .A(RESET), .ZN(KE2_RS_SFF_37_n10) );
  DFF_X1 KE2_RS_SFF_37_Q_reg ( .D(KE2_RS_SFF_37_n7), .CK(CLK), .Q(
        KE2_KEY_PERM[5]), .QN(KE2_RS_SFF_37_n8) );
  OAI21_X1 KE2_RS_SFF_38_U4 ( .B1(KE2_RS_n10), .B2(KE2_RS_SFF_38_n7), .A(
        KE2_RS_SFF_38_n10), .ZN(KE2_RS_SFF_38_n6) );
  OAI221_X1 KE2_RS_SFF_38_U3 ( .B1(RESET), .B2(KE2_KEY_PERM[38]), .C1(
        KE2_RS_SFF_38_n9), .C2(KEY2[38]), .A(KE2_RS_n10), .ZN(
        KE2_RS_SFF_38_n10) );
  INV_X1 KE2_RS_SFF_38_U2 ( .A(RESET), .ZN(KE2_RS_SFF_38_n9) );
  DFF_X1 KE2_RS_SFF_38_Q_reg ( .D(KE2_RS_SFF_38_n6), .CK(CLK), .Q(
        KE2_KEY_PERM[6]), .QN(KE2_RS_SFF_38_n7) );
  OAI21_X1 KE2_RS_SFF_39_U4 ( .B1(KE2_RS_n10), .B2(KE2_RS_SFF_39_n7), .A(
        KE2_RS_SFF_39_n10), .ZN(KE2_RS_SFF_39_n6) );
  OAI221_X1 KE2_RS_SFF_39_U3 ( .B1(RESET), .B2(KE2_KEY_PERM[39]), .C1(
        KE2_RS_SFF_39_n9), .C2(KEY2[39]), .A(KE2_RS_n10), .ZN(
        KE2_RS_SFF_39_n10) );
  INV_X1 KE2_RS_SFF_39_U2 ( .A(RESET), .ZN(KE2_RS_SFF_39_n9) );
  DFF_X1 KE2_RS_SFF_39_Q_reg ( .D(KE2_RS_SFF_39_n6), .CK(CLK), .Q(
        KE2_KEY_PERM[7]), .QN(KE2_RS_SFF_39_n7) );
  OAI21_X1 KE2_RS_SFF_40_U4 ( .B1(KE2_RS_n11), .B2(KE2_RS_SFF_40_n7), .A(
        KE2_RS_SFF_40_n10), .ZN(KE2_RS_SFF_40_n6) );
  OAI221_X1 KE2_RS_SFF_40_U3 ( .B1(RESET), .B2(KE2_KEY_PERM[40]), .C1(
        KE2_RS_SFF_40_n9), .C2(KEY2[40]), .A(KE2_RS_n11), .ZN(
        KE2_RS_SFF_40_n10) );
  INV_X1 KE2_RS_SFF_40_U2 ( .A(RESET), .ZN(KE2_RS_SFF_40_n9) );
  DFF_X1 KE2_RS_SFF_40_Q_reg ( .D(KE2_RS_SFF_40_n6), .CK(CLK), .Q(
        KE2_KEY_PERM[8]), .QN(KE2_RS_SFF_40_n7) );
  OAI21_X1 KE2_RS_SFF_41_U4 ( .B1(KE2_RS_n11), .B2(KE2_RS_SFF_41_n7), .A(
        KE2_RS_SFF_41_n10), .ZN(KE2_RS_SFF_41_n6) );
  OAI221_X1 KE2_RS_SFF_41_U3 ( .B1(RESET), .B2(KE2_KEY_PERM[41]), .C1(
        KE2_RS_SFF_41_n9), .C2(KEY2[41]), .A(KE2_RS_n11), .ZN(
        KE2_RS_SFF_41_n10) );
  INV_X1 KE2_RS_SFF_41_U2 ( .A(RESET), .ZN(KE2_RS_SFF_41_n9) );
  DFF_X1 KE2_RS_SFF_41_Q_reg ( .D(KE2_RS_SFF_41_n6), .CK(CLK), .Q(
        KE2_KEY_PERM[9]), .QN(KE2_RS_SFF_41_n7) );
  OAI21_X1 KE2_RS_SFF_42_U4 ( .B1(KE2_RS_n11), .B2(KE2_RS_SFF_42_n7), .A(
        KE2_RS_SFF_42_n10), .ZN(KE2_RS_SFF_42_n6) );
  OAI221_X1 KE2_RS_SFF_42_U3 ( .B1(RESET), .B2(KE2_KEY_PERM[42]), .C1(
        KE2_RS_SFF_42_n9), .C2(KEY2[42]), .A(KE2_RS_n11), .ZN(
        KE2_RS_SFF_42_n10) );
  INV_X1 KE2_RS_SFF_42_U2 ( .A(RESET), .ZN(KE2_RS_SFF_42_n9) );
  DFF_X1 KE2_RS_SFF_42_Q_reg ( .D(KE2_RS_SFF_42_n6), .CK(CLK), .Q(
        KE2_KEY_PERM[10]), .QN(KE2_RS_SFF_42_n7) );
  OAI21_X1 KE2_RS_SFF_43_U4 ( .B1(KE2_RS_n11), .B2(KE2_RS_SFF_43_n7), .A(
        KE2_RS_SFF_43_n10), .ZN(KE2_RS_SFF_43_n6) );
  OAI221_X1 KE2_RS_SFF_43_U3 ( .B1(RESET), .B2(KE2_KEY_PERM[43]), .C1(
        KE2_RS_SFF_43_n9), .C2(KEY2[43]), .A(KE2_RS_n11), .ZN(
        KE2_RS_SFF_43_n10) );
  INV_X1 KE2_RS_SFF_43_U2 ( .A(RESET), .ZN(KE2_RS_SFF_43_n9) );
  DFF_X1 KE2_RS_SFF_43_Q_reg ( .D(KE2_RS_SFF_43_n6), .CK(CLK), .Q(
        KE2_KEY_PERM[11]), .QN(KE2_RS_SFF_43_n7) );
  OAI21_X1 KE2_RS_SFF_44_U4 ( .B1(KE2_RS_n11), .B2(KE2_RS_SFF_44_n7), .A(
        KE2_RS_SFF_44_n10), .ZN(KE2_RS_SFF_44_n6) );
  OAI221_X1 KE2_RS_SFF_44_U3 ( .B1(RESET), .B2(KE2_KEY_PERM[44]), .C1(
        KE2_RS_SFF_44_n9), .C2(KEY2[44]), .A(KE2_RS_n11), .ZN(
        KE2_RS_SFF_44_n10) );
  INV_X1 KE2_RS_SFF_44_U2 ( .A(RESET), .ZN(KE2_RS_SFF_44_n9) );
  DFF_X1 KE2_RS_SFF_44_Q_reg ( .D(KE2_RS_SFF_44_n6), .CK(CLK), .Q(
        KE2_KEY_PERM[12]), .QN(KE2_RS_SFF_44_n7) );
  OAI21_X1 KE2_RS_SFF_45_U4 ( .B1(KE2_RS_n11), .B2(KE2_RS_SFF_45_n7), .A(
        KE2_RS_SFF_45_n10), .ZN(KE2_RS_SFF_45_n6) );
  OAI221_X1 KE2_RS_SFF_45_U3 ( .B1(RESET), .B2(KE2_KEY_PERM[45]), .C1(
        KE2_RS_SFF_45_n9), .C2(KEY2[45]), .A(KE2_RS_n11), .ZN(
        KE2_RS_SFF_45_n10) );
  INV_X1 KE2_RS_SFF_45_U2 ( .A(RESET), .ZN(KE2_RS_SFF_45_n9) );
  DFF_X1 KE2_RS_SFF_45_Q_reg ( .D(KE2_RS_SFF_45_n6), .CK(CLK), .Q(
        KE2_KEY_PERM[13]), .QN(KE2_RS_SFF_45_n7) );
  OAI21_X1 KE2_RS_SFF_46_U4 ( .B1(KE2_RS_n11), .B2(KE2_RS_SFF_46_n7), .A(
        KE2_RS_SFF_46_n10), .ZN(KE2_RS_SFF_46_n6) );
  OAI221_X1 KE2_RS_SFF_46_U3 ( .B1(RESET), .B2(KE2_KEY_PERM[46]), .C1(
        KE2_RS_SFF_46_n9), .C2(KEY2[46]), .A(KE2_RS_n11), .ZN(
        KE2_RS_SFF_46_n10) );
  INV_X1 KE2_RS_SFF_46_U2 ( .A(RESET), .ZN(KE2_RS_SFF_46_n9) );
  DFF_X1 KE2_RS_SFF_46_Q_reg ( .D(KE2_RS_SFF_46_n6), .CK(CLK), .Q(
        KE2_KEY_PERM[14]), .QN(KE2_RS_SFF_46_n7) );
  OAI21_X1 KE2_RS_SFF_47_U4 ( .B1(KE2_RS_n11), .B2(KE2_RS_SFF_47_n7), .A(
        KE2_RS_SFF_47_n10), .ZN(KE2_RS_SFF_47_n6) );
  OAI221_X1 KE2_RS_SFF_47_U3 ( .B1(RESET), .B2(KE2_KEY_PERM[47]), .C1(
        KE2_RS_SFF_47_n9), .C2(KEY2[47]), .A(KE2_RS_n11), .ZN(
        KE2_RS_SFF_47_n10) );
  INV_X1 KE2_RS_SFF_47_U2 ( .A(RESET), .ZN(KE2_RS_SFF_47_n9) );
  DFF_X1 KE2_RS_SFF_47_Q_reg ( .D(KE2_RS_SFF_47_n6), .CK(CLK), .Q(
        KE2_KEY_PERM[15]), .QN(KE2_RS_SFF_47_n7) );
  OAI21_X1 KE2_RS_SFF_48_U4 ( .B1(KE2_RS_n8), .B2(KE2_RS_SFF_48_n7), .A(
        KE2_RS_SFF_48_n10), .ZN(KE2_RS_SFF_48_n6) );
  OAI221_X1 KE2_RS_SFF_48_U3 ( .B1(RESET), .B2(KE2_KEY_PERM[48]), .C1(
        KE2_RS_SFF_48_n9), .C2(KEY2[48]), .A(KE2_RS_n8), .ZN(KE2_RS_SFF_48_n10) );
  INV_X1 KE2_RS_SFF_48_U2 ( .A(RESET), .ZN(KE2_RS_SFF_48_n9) );
  DFF_X1 KE2_RS_SFF_48_Q_reg ( .D(KE2_RS_SFF_48_n6), .CK(CLK), .Q(
        KE2_KEY_PERM[16]), .QN(KE2_RS_SFF_48_n7) );
  OAI21_X1 KE2_RS_SFF_49_U4 ( .B1(KE2_RS_n9), .B2(KE2_RS_SFF_49_n7), .A(
        KE2_RS_SFF_49_n10), .ZN(KE2_RS_SFF_49_n6) );
  OAI221_X1 KE2_RS_SFF_49_U3 ( .B1(RESET), .B2(KE2_KEY_PERM[49]), .C1(
        KE2_RS_SFF_49_n9), .C2(KEY2[49]), .A(KE2_RS_n9), .ZN(KE2_RS_SFF_49_n10) );
  INV_X1 KE2_RS_SFF_49_U2 ( .A(RESET), .ZN(KE2_RS_SFF_49_n9) );
  DFF_X1 KE2_RS_SFF_49_Q_reg ( .D(KE2_RS_SFF_49_n6), .CK(CLK), .Q(
        KE2_KEY_PERM[17]), .QN(KE2_RS_SFF_49_n7) );
  OAI21_X1 KE2_RS_SFF_50_U4 ( .B1(KE2_RS_n10), .B2(KE2_RS_SFF_50_n7), .A(
        KE2_RS_SFF_50_n10), .ZN(KE2_RS_SFF_50_n6) );
  OAI221_X1 KE2_RS_SFF_50_U3 ( .B1(RESET), .B2(KE2_KEY_PERM[50]), .C1(
        KE2_RS_SFF_50_n9), .C2(KEY2[50]), .A(KE2_RS_n10), .ZN(
        KE2_RS_SFF_50_n10) );
  INV_X1 KE2_RS_SFF_50_U2 ( .A(RESET), .ZN(KE2_RS_SFF_50_n9) );
  DFF_X1 KE2_RS_SFF_50_Q_reg ( .D(KE2_RS_SFF_50_n6), .CK(CLK), .Q(
        KE2_KEY_PERM[18]), .QN(KE2_RS_SFF_50_n7) );
  OAI21_X1 KE2_RS_SFF_51_U4 ( .B1(KEY_EN), .B2(KE2_RS_SFF_51_n7), .A(
        KE2_RS_SFF_51_n10), .ZN(KE2_RS_SFF_51_n6) );
  OAI221_X1 KE2_RS_SFF_51_U3 ( .B1(RESET), .B2(KE2_KEY_PERM[51]), .C1(
        KE2_RS_SFF_51_n9), .C2(KEY2[51]), .A(KEY_EN), .ZN(KE2_RS_SFF_51_n10)
         );
  INV_X1 KE2_RS_SFF_51_U2 ( .A(RESET), .ZN(KE2_RS_SFF_51_n9) );
  DFF_X1 KE2_RS_SFF_51_Q_reg ( .D(KE2_RS_SFF_51_n6), .CK(CLK), .Q(
        KE2_KEY_PERM[19]), .QN(KE2_RS_SFF_51_n7) );
  OAI21_X1 KE2_RS_SFF_52_U4 ( .B1(KE2_RS_n6), .B2(KE2_RS_SFF_52_n7), .A(
        KE2_RS_SFF_52_n10), .ZN(KE2_RS_SFF_52_n6) );
  OAI221_X1 KE2_RS_SFF_52_U3 ( .B1(RESET), .B2(KE2_KEY_PERM[52]), .C1(
        KE2_RS_SFF_52_n9), .C2(KEY2[52]), .A(KE2_RS_n6), .ZN(KE2_RS_SFF_52_n10) );
  INV_X1 KE2_RS_SFF_52_U2 ( .A(RESET), .ZN(KE2_RS_SFF_52_n9) );
  DFF_X1 KE2_RS_SFF_52_Q_reg ( .D(KE2_RS_SFF_52_n6), .CK(CLK), .Q(
        KE2_KEY_PERM[20]), .QN(KE2_RS_SFF_52_n7) );
  OAI21_X1 KE2_RS_SFF_53_U4 ( .B1(KE2_RS_n7), .B2(KE2_RS_SFF_53_n7), .A(
        KE2_RS_SFF_53_n10), .ZN(KE2_RS_SFF_53_n6) );
  OAI221_X1 KE2_RS_SFF_53_U3 ( .B1(RESET), .B2(KE2_KEY_PERM[53]), .C1(
        KE2_RS_SFF_53_n9), .C2(KEY2[53]), .A(KE2_RS_n7), .ZN(KE2_RS_SFF_53_n10) );
  INV_X1 KE2_RS_SFF_53_U2 ( .A(RESET), .ZN(KE2_RS_SFF_53_n9) );
  DFF_X1 KE2_RS_SFF_53_Q_reg ( .D(KE2_RS_SFF_53_n6), .CK(CLK), .Q(
        KE2_KEY_PERM[21]), .QN(KE2_RS_SFF_53_n7) );
  OAI21_X1 KE2_RS_SFF_54_U4 ( .B1(KE2_RS_n8), .B2(KE2_RS_SFF_54_n7), .A(
        KE2_RS_SFF_54_n10), .ZN(KE2_RS_SFF_54_n6) );
  OAI221_X1 KE2_RS_SFF_54_U3 ( .B1(RESET), .B2(KE2_KEY_PERM[54]), .C1(
        KE2_RS_SFF_54_n9), .C2(KEY2[54]), .A(KE2_RS_n8), .ZN(KE2_RS_SFF_54_n10) );
  INV_X1 KE2_RS_SFF_54_U2 ( .A(RESET), .ZN(KE2_RS_SFF_54_n9) );
  DFF_X1 KE2_RS_SFF_54_Q_reg ( .D(KE2_RS_SFF_54_n6), .CK(CLK), .Q(
        KE2_KEY_PERM[22]), .QN(KE2_RS_SFF_54_n7) );
  OAI21_X1 KE2_RS_SFF_55_U4 ( .B1(KE2_RS_n9), .B2(KE2_RS_SFF_55_n7), .A(
        KE2_RS_SFF_55_n10), .ZN(KE2_RS_SFF_55_n6) );
  OAI221_X1 KE2_RS_SFF_55_U3 ( .B1(RESET), .B2(KE2_KEY_PERM[55]), .C1(
        KE2_RS_SFF_55_n9), .C2(KEY2[55]), .A(KE2_RS_n9), .ZN(KE2_RS_SFF_55_n10) );
  INV_X1 KE2_RS_SFF_55_U2 ( .A(RESET), .ZN(KE2_RS_SFF_55_n9) );
  DFF_X1 KE2_RS_SFF_55_Q_reg ( .D(KE2_RS_SFF_55_n6), .CK(CLK), .Q(
        KE2_KEY_PERM[23]), .QN(KE2_RS_SFF_55_n7) );
  OAI21_X1 KE2_RS_SFF_56_U4 ( .B1(KE2_RS_n11), .B2(KE2_RS_SFF_56_n7), .A(
        KE2_RS_SFF_56_n10), .ZN(KE2_RS_SFF_56_n6) );
  OAI221_X1 KE2_RS_SFF_56_U3 ( .B1(RESET), .B2(KE2_KEY_PERM[56]), .C1(
        KE2_RS_SFF_56_n9), .C2(KEY2[56]), .A(KE2_RS_n11), .ZN(
        KE2_RS_SFF_56_n10) );
  INV_X1 KE2_RS_SFF_56_U2 ( .A(RESET), .ZN(KE2_RS_SFF_56_n9) );
  DFF_X1 KE2_RS_SFF_56_Q_reg ( .D(KE2_RS_SFF_56_n6), .CK(CLK), .Q(
        KE2_KEY_PERM[24]), .QN(KE2_RS_SFF_56_n7) );
  OAI21_X1 KE2_RS_SFF_57_U4 ( .B1(KE2_RS_n6), .B2(KE2_RS_SFF_57_n7), .A(
        KE2_RS_SFF_57_n10), .ZN(KE2_RS_SFF_57_n6) );
  OAI221_X1 KE2_RS_SFF_57_U3 ( .B1(RESET), .B2(KE2_KEY_PERM[57]), .C1(
        KE2_RS_SFF_57_n9), .C2(KEY2[57]), .A(KE2_RS_n6), .ZN(KE2_RS_SFF_57_n10) );
  INV_X1 KE2_RS_SFF_57_U2 ( .A(RESET), .ZN(KE2_RS_SFF_57_n9) );
  DFF_X1 KE2_RS_SFF_57_Q_reg ( .D(KE2_RS_SFF_57_n6), .CK(CLK), .Q(
        KE2_KEY_PERM[25]), .QN(KE2_RS_SFF_57_n7) );
  OAI21_X1 KE2_RS_SFF_58_U4 ( .B1(KE2_RS_n7), .B2(KE2_RS_SFF_58_n7), .A(
        KE2_RS_SFF_58_n10), .ZN(KE2_RS_SFF_58_n6) );
  OAI221_X1 KE2_RS_SFF_58_U3 ( .B1(RESET), .B2(KE2_KEY_PERM[58]), .C1(
        KE2_RS_SFF_58_n9), .C2(KEY2[58]), .A(KE2_RS_n7), .ZN(KE2_RS_SFF_58_n10) );
  INV_X1 KE2_RS_SFF_58_U2 ( .A(RESET), .ZN(KE2_RS_SFF_58_n9) );
  DFF_X1 KE2_RS_SFF_58_Q_reg ( .D(KE2_RS_SFF_58_n6), .CK(CLK), .Q(
        KE2_KEY_PERM[26]), .QN(KE2_RS_SFF_58_n7) );
  OAI21_X1 KE2_RS_SFF_59_U4 ( .B1(KE2_RS_n8), .B2(KE2_RS_SFF_59_n7), .A(
        KE2_RS_SFF_59_n10), .ZN(KE2_RS_SFF_59_n6) );
  OAI221_X1 KE2_RS_SFF_59_U3 ( .B1(RESET), .B2(KE2_KEY_PERM[59]), .C1(
        KE2_RS_SFF_59_n9), .C2(KEY2[59]), .A(KE2_RS_n8), .ZN(KE2_RS_SFF_59_n10) );
  INV_X1 KE2_RS_SFF_59_U2 ( .A(RESET), .ZN(KE2_RS_SFF_59_n9) );
  DFF_X1 KE2_RS_SFF_59_Q_reg ( .D(KE2_RS_SFF_59_n6), .CK(CLK), .Q(
        KE2_KEY_PERM[27]), .QN(KE2_RS_SFF_59_n7) );
  OAI21_X1 KE2_RS_SFF_60_U4 ( .B1(KE2_RS_n9), .B2(KE2_RS_SFF_60_n7), .A(
        KE2_RS_SFF_60_n10), .ZN(KE2_RS_SFF_60_n6) );
  OAI221_X1 KE2_RS_SFF_60_U3 ( .B1(RESET), .B2(KE2_KEY_PERM[60]), .C1(
        KE2_RS_SFF_60_n9), .C2(KEY2[60]), .A(KE2_RS_n9), .ZN(KE2_RS_SFF_60_n10) );
  INV_X1 KE2_RS_SFF_60_U2 ( .A(RESET), .ZN(KE2_RS_SFF_60_n9) );
  DFF_X1 KE2_RS_SFF_60_Q_reg ( .D(KE2_RS_SFF_60_n6), .CK(CLK), .Q(
        KE2_KEY_PERM[28]), .QN(KE2_RS_SFF_60_n7) );
  OAI21_X1 KE2_RS_SFF_61_U4 ( .B1(KE2_RS_n10), .B2(KE2_RS_SFF_61_n7), .A(
        KE2_RS_SFF_61_n10), .ZN(KE2_RS_SFF_61_n6) );
  OAI221_X1 KE2_RS_SFF_61_U3 ( .B1(RESET), .B2(KE2_KEY_PERM[61]), .C1(
        KE2_RS_SFF_61_n9), .C2(KEY2[61]), .A(KE2_RS_n10), .ZN(
        KE2_RS_SFF_61_n10) );
  INV_X1 KE2_RS_SFF_61_U2 ( .A(RESET), .ZN(KE2_RS_SFF_61_n9) );
  DFF_X1 KE2_RS_SFF_61_Q_reg ( .D(KE2_RS_SFF_61_n6), .CK(CLK), .Q(
        KE2_KEY_PERM[29]), .QN(KE2_RS_SFF_61_n7) );
  OAI21_X1 KE2_RS_SFF_62_U4 ( .B1(KE2_RS_n10), .B2(KE2_RS_SFF_62_n7), .A(
        KE2_RS_SFF_62_n10), .ZN(KE2_RS_SFF_62_n6) );
  OAI221_X1 KE2_RS_SFF_62_U3 ( .B1(RESET), .B2(KE2_KEY_PERM[62]), .C1(
        KE2_RS_SFF_62_n9), .C2(KEY2[62]), .A(KE2_RS_n10), .ZN(
        KE2_RS_SFF_62_n10) );
  INV_X1 KE2_RS_SFF_62_U2 ( .A(RESET), .ZN(KE2_RS_SFF_62_n9) );
  DFF_X1 KE2_RS_SFF_62_Q_reg ( .D(KE2_RS_SFF_62_n6), .CK(CLK), .Q(
        KE2_KEY_PERM[30]), .QN(KE2_RS_SFF_62_n7) );
  OAI21_X1 KE2_RS_SFF_63_U4 ( .B1(KE2_RS_n11), .B2(KE2_RS_SFF_63_n7), .A(
        KE2_RS_SFF_63_n10), .ZN(KE2_RS_SFF_63_n6) );
  OAI221_X1 KE2_RS_SFF_63_U3 ( .B1(RESET), .B2(KE2_KEY_PERM[63]), .C1(
        KE2_RS_SFF_63_n9), .C2(KEY2[63]), .A(KE2_RS_n11), .ZN(
        KE2_RS_SFF_63_n10) );
  INV_X1 KE2_RS_SFF_63_U2 ( .A(RESET), .ZN(KE2_RS_SFF_63_n9) );
  DFF_X1 KE2_RS_SFF_63_Q_reg ( .D(KE2_RS_SFF_63_n6), .CK(CLK), .Q(
        KE2_KEY_PERM[31]), .QN(KE2_RS_SFF_63_n7) );
  BUF_X1 KE3_RS_U6 ( .A(KEY_EN), .Z(KE3_RS_n9) );
  BUF_X1 KE3_RS_U5 ( .A(KEY_EN), .Z(KE3_RS_n10) );
  BUF_X1 KE3_RS_U4 ( .A(KEY_EN), .Z(KE3_RS_n11) );
  BUF_X1 KE3_RS_U3 ( .A(KEY_EN), .Z(KE3_RS_n12) );
  BUF_X1 KE3_RS_U2 ( .A(KEY_EN), .Z(KE3_RS_n8) );
  BUF_X1 KE3_RS_U1 ( .A(KEY_EN), .Z(KE3_RS_n7) );
  OAI21_X1 KE3_RS_SFF_0_U4 ( .B1(KE3_RS_n7), .B2(KE3_RS_SFF_0_n8), .A(
        KE3_RS_SFF_0_n11), .ZN(KE3_RS_SFF_0_n7) );
  OAI221_X1 KE3_RS_SFF_0_U3 ( .B1(RESET), .B2(KE3_KEY_PERM[0]), .C1(
        KE3_RS_SFF_0_n10), .C2(KEY3[0]), .A(KE3_RS_n7), .ZN(KE3_RS_SFF_0_n11)
         );
  INV_X1 KE3_RS_SFF_0_U2 ( .A(RESET), .ZN(KE3_RS_SFF_0_n10) );
  DFF_X1 KE3_RS_SFF_0_Q_reg ( .D(KE3_RS_SFF_0_n7), .CK(CLK), .Q(
        KE3_KEY_PERM[56]), .QN(KE3_RS_SFF_0_n8) );
  OAI21_X1 KE3_RS_SFF_1_U4 ( .B1(KE3_RS_n7), .B2(KE3_RS_SFF_1_n8), .A(
        KE3_RS_SFF_1_n11), .ZN(KE3_RS_SFF_1_n7) );
  OAI221_X1 KE3_RS_SFF_1_U3 ( .B1(RESET), .B2(KE3_KEY_PERM[1]), .C1(
        KE3_RS_SFF_1_n10), .C2(KEY3[1]), .A(KE3_RS_n7), .ZN(KE3_RS_SFF_1_n11)
         );
  INV_X1 KE3_RS_SFF_1_U2 ( .A(RESET), .ZN(KE3_RS_SFF_1_n10) );
  DFF_X1 KE3_RS_SFF_1_Q_reg ( .D(KE3_RS_SFF_1_n7), .CK(CLK), .Q(
        KE3_KEY_PERM[57]), .QN(KE3_RS_SFF_1_n8) );
  OAI21_X1 KE3_RS_SFF_2_U4 ( .B1(KE3_RS_n8), .B2(KE3_RS_SFF_2_n7), .A(
        KE3_RS_SFF_2_n10), .ZN(KE3_RS_SFF_2_n6) );
  OAI221_X1 KE3_RS_SFF_2_U3 ( .B1(RESET), .B2(KE3_KEY_PERM[2]), .C1(
        KE3_RS_SFF_2_n9), .C2(KEY3[2]), .A(KE3_RS_n8), .ZN(KE3_RS_SFF_2_n10)
         );
  INV_X1 KE3_RS_SFF_2_U2 ( .A(RESET), .ZN(KE3_RS_SFF_2_n9) );
  DFF_X1 KE3_RS_SFF_2_Q_reg ( .D(KE3_RS_SFF_2_n6), .CK(CLK), .Q(
        KE3_KEY_PERM[58]), .QN(KE3_RS_SFF_2_n7) );
  OAI21_X1 KE3_RS_SFF_3_U4 ( .B1(KE3_RS_n8), .B2(KE3_RS_SFF_3_n7), .A(
        KE3_RS_SFF_3_n10), .ZN(KE3_RS_SFF_3_n6) );
  OAI221_X1 KE3_RS_SFF_3_U3 ( .B1(RESET), .B2(KE3_KEY_PERM[3]), .C1(
        KE3_RS_SFF_3_n9), .C2(KEY3[3]), .A(KE3_RS_n8), .ZN(KE3_RS_SFF_3_n10)
         );
  INV_X1 KE3_RS_SFF_3_U2 ( .A(RESET), .ZN(KE3_RS_SFF_3_n9) );
  DFF_X1 KE3_RS_SFF_3_Q_reg ( .D(KE3_RS_SFF_3_n6), .CK(CLK), .Q(
        KE3_KEY_PERM[59]), .QN(KE3_RS_SFF_3_n7) );
  OAI21_X1 KE3_RS_SFF_4_U4 ( .B1(KE3_RS_n8), .B2(KE3_RS_SFF_4_n7), .A(
        KE3_RS_SFF_4_n10), .ZN(KE3_RS_SFF_4_n6) );
  OAI221_X1 KE3_RS_SFF_4_U3 ( .B1(RESET), .B2(KE3_KEY_PERM[4]), .C1(
        KE3_RS_SFF_4_n9), .C2(KEY3[4]), .A(KE3_RS_n8), .ZN(KE3_RS_SFF_4_n10)
         );
  INV_X1 KE3_RS_SFF_4_U2 ( .A(RESET), .ZN(KE3_RS_SFF_4_n9) );
  DFF_X1 KE3_RS_SFF_4_Q_reg ( .D(KE3_RS_SFF_4_n6), .CK(CLK), .Q(
        KE3_KEY_PERM[40]), .QN(KE3_RS_SFF_4_n7) );
  OAI21_X1 KE3_RS_SFF_5_U4 ( .B1(KE3_RS_n8), .B2(KE3_RS_SFF_5_n7), .A(
        KE3_RS_SFF_5_n10), .ZN(KE3_RS_SFF_5_n6) );
  OAI221_X1 KE3_RS_SFF_5_U3 ( .B1(RESET), .B2(KE3_KEY_PERM[5]), .C1(
        KE3_RS_SFF_5_n9), .C2(KEY3[5]), .A(KE3_RS_n8), .ZN(KE3_RS_SFF_5_n10)
         );
  INV_X1 KE3_RS_SFF_5_U2 ( .A(RESET), .ZN(KE3_RS_SFF_5_n9) );
  DFF_X1 KE3_RS_SFF_5_Q_reg ( .D(KE3_RS_SFF_5_n6), .CK(CLK), .Q(
        KE3_KEY_PERM[41]), .QN(KE3_RS_SFF_5_n7) );
  OAI21_X1 KE3_RS_SFF_6_U4 ( .B1(KE3_RS_n8), .B2(KE3_RS_SFF_6_n7), .A(
        KE3_RS_SFF_6_n10), .ZN(KE3_RS_SFF_6_n6) );
  OAI221_X1 KE3_RS_SFF_6_U3 ( .B1(RESET), .B2(KE3_KEY_PERM[6]), .C1(
        KE3_RS_SFF_6_n9), .C2(KEY3[6]), .A(KE3_RS_n8), .ZN(KE3_RS_SFF_6_n10)
         );
  INV_X1 KE3_RS_SFF_6_U2 ( .A(RESET), .ZN(KE3_RS_SFF_6_n9) );
  DFF_X1 KE3_RS_SFF_6_Q_reg ( .D(KE3_RS_SFF_6_n6), .CK(CLK), .Q(
        KE3_KEY_PERM[42]), .QN(KE3_RS_SFF_6_n7) );
  OAI21_X1 KE3_RS_SFF_7_U4 ( .B1(KE3_RS_n8), .B2(KE3_RS_SFF_7_n7), .A(
        KE3_RS_SFF_7_n10), .ZN(KE3_RS_SFF_7_n6) );
  OAI221_X1 KE3_RS_SFF_7_U3 ( .B1(RESET), .B2(KE3_KEY_PERM[7]), .C1(
        KE3_RS_SFF_7_n9), .C2(KEY3[7]), .A(KE3_RS_n8), .ZN(KE3_RS_SFF_7_n10)
         );
  INV_X1 KE3_RS_SFF_7_U2 ( .A(RESET), .ZN(KE3_RS_SFF_7_n9) );
  DFF_X1 KE3_RS_SFF_7_Q_reg ( .D(KE3_RS_SFF_7_n6), .CK(CLK), .Q(
        KE3_KEY_PERM[43]), .QN(KE3_RS_SFF_7_n7) );
  OAI21_X1 KE3_RS_SFF_8_U4 ( .B1(KE3_RS_n9), .B2(KE3_RS_SFF_8_n7), .A(
        KE3_RS_SFF_8_n10), .ZN(KE3_RS_SFF_8_n6) );
  OAI221_X1 KE3_RS_SFF_8_U3 ( .B1(RESET), .B2(KE3_KEY_PERM[8]), .C1(
        KE3_RS_SFF_8_n9), .C2(KEY3[8]), .A(KE3_RS_n9), .ZN(KE3_RS_SFF_8_n10)
         );
  INV_X1 KE3_RS_SFF_8_U2 ( .A(RESET), .ZN(KE3_RS_SFF_8_n9) );
  DFF_X1 KE3_RS_SFF_8_Q_reg ( .D(KE3_RS_SFF_8_n6), .CK(CLK), .Q(
        KE3_KEY_PERM[48]), .QN(KE3_RS_SFF_8_n7) );
  OAI21_X1 KE3_RS_SFF_9_U4 ( .B1(KE3_RS_n9), .B2(KE3_RS_SFF_9_n7), .A(
        KE3_RS_SFF_9_n10), .ZN(KE3_RS_SFF_9_n6) );
  OAI221_X1 KE3_RS_SFF_9_U3 ( .B1(RESET), .B2(KE3_KEY_PERM[9]), .C1(
        KE3_RS_SFF_9_n9), .C2(KEY3[9]), .A(KE3_RS_n9), .ZN(KE3_RS_SFF_9_n10)
         );
  INV_X1 KE3_RS_SFF_9_U2 ( .A(RESET), .ZN(KE3_RS_SFF_9_n9) );
  DFF_X1 KE3_RS_SFF_9_Q_reg ( .D(KE3_RS_SFF_9_n6), .CK(CLK), .Q(
        KE3_KEY_PERM[49]), .QN(KE3_RS_SFF_9_n7) );
  OAI21_X1 KE3_RS_SFF_10_U4 ( .B1(KE3_RS_n9), .B2(KE3_RS_SFF_10_n7), .A(
        KE3_RS_SFF_10_n10), .ZN(KE3_RS_SFF_10_n6) );
  OAI221_X1 KE3_RS_SFF_10_U3 ( .B1(RESET), .B2(KE3_KEY_PERM[10]), .C1(
        KE3_RS_SFF_10_n9), .C2(KEY3[10]), .A(KE3_RS_n9), .ZN(KE3_RS_SFF_10_n10) );
  INV_X1 KE3_RS_SFF_10_U2 ( .A(RESET), .ZN(KE3_RS_SFF_10_n9) );
  DFF_X1 KE3_RS_SFF_10_Q_reg ( .D(KE3_RS_SFF_10_n6), .CK(CLK), .Q(
        KE3_KEY_PERM[50]), .QN(KE3_RS_SFF_10_n7) );
  OAI21_X1 KE3_RS_SFF_11_U4 ( .B1(KE3_RS_n9), .B2(KE3_RS_SFF_11_n7), .A(
        KE3_RS_SFF_11_n10), .ZN(KE3_RS_SFF_11_n6) );
  OAI221_X1 KE3_RS_SFF_11_U3 ( .B1(RESET), .B2(KE3_KEY_PERM[11]), .C1(
        KE3_RS_SFF_11_n9), .C2(KEY3[11]), .A(KE3_RS_n9), .ZN(KE3_RS_SFF_11_n10) );
  INV_X1 KE3_RS_SFF_11_U2 ( .A(RESET), .ZN(KE3_RS_SFF_11_n9) );
  DFF_X1 KE3_RS_SFF_11_Q_reg ( .D(KE3_RS_SFF_11_n6), .CK(CLK), .Q(
        KE3_KEY_PERM[51]), .QN(KE3_RS_SFF_11_n7) );
  OAI21_X1 KE3_RS_SFF_12_U4 ( .B1(KE3_RS_n7), .B2(KE3_RS_SFF_12_n8), .A(
        KE3_RS_SFF_12_n11), .ZN(KE3_RS_SFF_12_n7) );
  OAI221_X1 KE3_RS_SFF_12_U3 ( .B1(RESET), .B2(KE3_KEY_PERM[12]), .C1(
        KE3_RS_SFF_12_n10), .C2(KEY3[12]), .A(KE3_RS_n7), .ZN(
        KE3_RS_SFF_12_n11) );
  INV_X1 KE3_RS_SFF_12_U2 ( .A(RESET), .ZN(KE3_RS_SFF_12_n10) );
  DFF_X1 KE3_RS_SFF_12_Q_reg ( .D(KE3_RS_SFF_12_n7), .CK(CLK), .Q(
        KE3_KEY_PERM[36]), .QN(KE3_RS_SFF_12_n8) );
  OAI21_X1 KE3_RS_SFF_13_U4 ( .B1(KE3_RS_n7), .B2(KE3_RS_SFF_13_n8), .A(
        KE3_RS_SFF_13_n11), .ZN(KE3_RS_SFF_13_n7) );
  OAI221_X1 KE3_RS_SFF_13_U3 ( .B1(RESET), .B2(KE3_KEY_PERM[13]), .C1(
        KE3_RS_SFF_13_n10), .C2(KEY3[13]), .A(KE3_RS_n7), .ZN(
        KE3_RS_SFF_13_n11) );
  INV_X1 KE3_RS_SFF_13_U2 ( .A(RESET), .ZN(KE3_RS_SFF_13_n10) );
  DFF_X1 KE3_RS_SFF_13_Q_reg ( .D(KE3_RS_SFF_13_n7), .CK(CLK), .Q(
        KE3_KEY_PERM[37]), .QN(KE3_RS_SFF_13_n8) );
  OAI21_X1 KE3_RS_SFF_14_U4 ( .B1(KE3_RS_n9), .B2(KE3_RS_SFF_14_n7), .A(
        KE3_RS_SFF_14_n10), .ZN(KE3_RS_SFF_14_n6) );
  OAI221_X1 KE3_RS_SFF_14_U3 ( .B1(RESET), .B2(KE3_KEY_PERM[14]), .C1(
        KE3_RS_SFF_14_n9), .C2(KEY3[14]), .A(KE3_RS_n9), .ZN(KE3_RS_SFF_14_n10) );
  INV_X1 KE3_RS_SFF_14_U2 ( .A(RESET), .ZN(KE3_RS_SFF_14_n9) );
  DFF_X1 KE3_RS_SFF_14_Q_reg ( .D(KE3_RS_SFF_14_n6), .CK(CLK), .Q(
        KE3_KEY_PERM[38]), .QN(KE3_RS_SFF_14_n7) );
  OAI21_X1 KE3_RS_SFF_15_U4 ( .B1(KE3_RS_n9), .B2(KE3_RS_SFF_15_n7), .A(
        KE3_RS_SFF_15_n10), .ZN(KE3_RS_SFF_15_n6) );
  OAI221_X1 KE3_RS_SFF_15_U3 ( .B1(RESET), .B2(KE3_KEY_PERM[15]), .C1(
        KE3_RS_SFF_15_n9), .C2(KEY3[15]), .A(KE3_RS_n9), .ZN(KE3_RS_SFF_15_n10) );
  INV_X1 KE3_RS_SFF_15_U2 ( .A(RESET), .ZN(KE3_RS_SFF_15_n9) );
  DFF_X1 KE3_RS_SFF_15_Q_reg ( .D(KE3_RS_SFF_15_n6), .CK(CLK), .Q(
        KE3_KEY_PERM[39]), .QN(KE3_RS_SFF_15_n7) );
  OAI21_X1 KE3_RS_SFF_16_U4 ( .B1(KE3_RS_n9), .B2(KE3_RS_SFF_16_n7), .A(
        KE3_RS_SFF_16_n10), .ZN(KE3_RS_SFF_16_n6) );
  OAI221_X1 KE3_RS_SFF_16_U3 ( .B1(RESET), .B2(KE3_KEY_PERM[16]), .C1(
        KE3_RS_SFF_16_n9), .C2(KEY3[16]), .A(KE3_RS_n9), .ZN(KE3_RS_SFF_16_n10) );
  INV_X1 KE3_RS_SFF_16_U2 ( .A(RESET), .ZN(KE3_RS_SFF_16_n9) );
  DFF_X1 KE3_RS_SFF_16_Q_reg ( .D(KE3_RS_SFF_16_n6), .CK(CLK), .Q(
        KE3_KEY_PERM[32]), .QN(KE3_RS_SFF_16_n7) );
  OAI21_X1 KE3_RS_SFF_17_U4 ( .B1(KE3_RS_n9), .B2(KE3_RS_SFF_17_n7), .A(
        KE3_RS_SFF_17_n10), .ZN(KE3_RS_SFF_17_n6) );
  OAI221_X1 KE3_RS_SFF_17_U3 ( .B1(RESET), .B2(KE3_KEY_PERM[17]), .C1(
        KE3_RS_SFF_17_n9), .C2(KEY3[17]), .A(KE3_RS_n9), .ZN(KE3_RS_SFF_17_n10) );
  INV_X1 KE3_RS_SFF_17_U2 ( .A(RESET), .ZN(KE3_RS_SFF_17_n9) );
  DFF_X1 KE3_RS_SFF_17_Q_reg ( .D(KE3_RS_SFF_17_n6), .CK(CLK), .Q(
        KE3_KEY_PERM[33]), .QN(KE3_RS_SFF_17_n7) );
  OAI21_X1 KE3_RS_SFF_18_U4 ( .B1(KE3_RS_n10), .B2(KE3_RS_SFF_18_n7), .A(
        KE3_RS_SFF_18_n10), .ZN(KE3_RS_SFF_18_n6) );
  OAI221_X1 KE3_RS_SFF_18_U3 ( .B1(RESET), .B2(KE3_KEY_PERM[18]), .C1(
        KE3_RS_SFF_18_n9), .C2(KEY3[18]), .A(KE3_RS_n10), .ZN(
        KE3_RS_SFF_18_n10) );
  INV_X1 KE3_RS_SFF_18_U2 ( .A(RESET), .ZN(KE3_RS_SFF_18_n9) );
  DFF_X1 KE3_RS_SFF_18_Q_reg ( .D(KE3_RS_SFF_18_n6), .CK(CLK), .Q(
        KE3_KEY_PERM[34]), .QN(KE3_RS_SFF_18_n7) );
  OAI21_X1 KE3_RS_SFF_19_U4 ( .B1(KE3_RS_n10), .B2(KE3_RS_SFF_19_n7), .A(
        KE3_RS_SFF_19_n10), .ZN(KE3_RS_SFF_19_n6) );
  OAI221_X1 KE3_RS_SFF_19_U3 ( .B1(RESET), .B2(KE3_KEY_PERM[19]), .C1(
        KE3_RS_SFF_19_n9), .C2(KEY3[19]), .A(KE3_RS_n10), .ZN(
        KE3_RS_SFF_19_n10) );
  INV_X1 KE3_RS_SFF_19_U2 ( .A(RESET), .ZN(KE3_RS_SFF_19_n9) );
  DFF_X1 KE3_RS_SFF_19_Q_reg ( .D(KE3_RS_SFF_19_n6), .CK(CLK), .Q(
        KE3_KEY_PERM[35]), .QN(KE3_RS_SFF_19_n7) );
  OAI21_X1 KE3_RS_SFF_20_U4 ( .B1(KE3_RS_n10), .B2(KE3_RS_SFF_20_n7), .A(
        KE3_RS_SFF_20_n10), .ZN(KE3_RS_SFF_20_n6) );
  OAI221_X1 KE3_RS_SFF_20_U3 ( .B1(RESET), .B2(KE3_KEY_PERM[20]), .C1(
        KE3_RS_SFF_20_n9), .C2(KEY3[20]), .A(KE3_RS_n10), .ZN(
        KE3_RS_SFF_20_n10) );
  INV_X1 KE3_RS_SFF_20_U2 ( .A(RESET), .ZN(KE3_RS_SFF_20_n9) );
  DFF_X1 KE3_RS_SFF_20_Q_reg ( .D(KE3_RS_SFF_20_n6), .CK(CLK), .Q(
        KE3_KEY_PERM[44]), .QN(KE3_RS_SFF_20_n7) );
  OAI21_X1 KE3_RS_SFF_21_U4 ( .B1(KE3_RS_n10), .B2(KE3_RS_SFF_21_n7), .A(
        KE3_RS_SFF_21_n10), .ZN(KE3_RS_SFF_21_n6) );
  OAI221_X1 KE3_RS_SFF_21_U3 ( .B1(RESET), .B2(KE3_KEY_PERM[21]), .C1(
        KE3_RS_SFF_21_n9), .C2(KEY3[21]), .A(KE3_RS_n10), .ZN(
        KE3_RS_SFF_21_n10) );
  INV_X1 KE3_RS_SFF_21_U2 ( .A(RESET), .ZN(KE3_RS_SFF_21_n9) );
  DFF_X1 KE3_RS_SFF_21_Q_reg ( .D(KE3_RS_SFF_21_n6), .CK(CLK), .Q(
        KE3_KEY_PERM[45]), .QN(KE3_RS_SFF_21_n7) );
  OAI21_X1 KE3_RS_SFF_22_U4 ( .B1(KE3_RS_n10), .B2(KE3_RS_SFF_22_n7), .A(
        KE3_RS_SFF_22_n10), .ZN(KE3_RS_SFF_22_n6) );
  OAI221_X1 KE3_RS_SFF_22_U3 ( .B1(RESET), .B2(KE3_KEY_PERM[22]), .C1(
        KE3_RS_SFF_22_n9), .C2(KEY3[22]), .A(KE3_RS_n10), .ZN(
        KE3_RS_SFF_22_n10) );
  INV_X1 KE3_RS_SFF_22_U2 ( .A(RESET), .ZN(KE3_RS_SFF_22_n9) );
  DFF_X1 KE3_RS_SFF_22_Q_reg ( .D(KE3_RS_SFF_22_n6), .CK(CLK), .Q(
        KE3_KEY_PERM[46]), .QN(KE3_RS_SFF_22_n7) );
  OAI21_X1 KE3_RS_SFF_23_U4 ( .B1(KE3_RS_n10), .B2(KE3_RS_SFF_23_n7), .A(
        KE3_RS_SFF_23_n10), .ZN(KE3_RS_SFF_23_n6) );
  OAI221_X1 KE3_RS_SFF_23_U3 ( .B1(RESET), .B2(KE3_KEY_PERM[23]), .C1(
        KE3_RS_SFF_23_n9), .C2(KEY3[23]), .A(KE3_RS_n10), .ZN(
        KE3_RS_SFF_23_n10) );
  INV_X1 KE3_RS_SFF_23_U2 ( .A(RESET), .ZN(KE3_RS_SFF_23_n9) );
  DFF_X1 KE3_RS_SFF_23_Q_reg ( .D(KE3_RS_SFF_23_n6), .CK(CLK), .Q(
        KE3_KEY_PERM[47]), .QN(KE3_RS_SFF_23_n7) );
  OAI21_X1 KE3_RS_SFF_24_U4 ( .B1(KE3_RS_n7), .B2(KE3_RS_SFF_24_n8), .A(
        KE3_RS_SFF_24_n11), .ZN(KE3_RS_SFF_24_n7) );
  OAI221_X1 KE3_RS_SFF_24_U3 ( .B1(RESET), .B2(KE3_KEY_PERM[24]), .C1(
        KE3_RS_SFF_24_n10), .C2(KEY3[24]), .A(KE3_RS_n7), .ZN(
        KE3_RS_SFF_24_n11) );
  INV_X1 KE3_RS_SFF_24_U2 ( .A(RESET), .ZN(KE3_RS_SFF_24_n10) );
  DFF_X1 KE3_RS_SFF_24_Q_reg ( .D(KE3_RS_SFF_24_n7), .CK(CLK), .Q(
        KE3_KEY_PERM[60]), .QN(KE3_RS_SFF_24_n8) );
  OAI21_X1 KE3_RS_SFF_25_U4 ( .B1(KE3_RS_n7), .B2(KE3_RS_SFF_25_n8), .A(
        KE3_RS_SFF_25_n11), .ZN(KE3_RS_SFF_25_n7) );
  OAI221_X1 KE3_RS_SFF_25_U3 ( .B1(RESET), .B2(KE3_KEY_PERM[25]), .C1(
        KE3_RS_SFF_25_n10), .C2(KEY3[25]), .A(KE3_RS_n7), .ZN(
        KE3_RS_SFF_25_n11) );
  INV_X1 KE3_RS_SFF_25_U2 ( .A(RESET), .ZN(KE3_RS_SFF_25_n10) );
  DFF_X1 KE3_RS_SFF_25_Q_reg ( .D(KE3_RS_SFF_25_n7), .CK(CLK), .Q(
        KE3_KEY_PERM[61]), .QN(KE3_RS_SFF_25_n8) );
  OAI21_X1 KE3_RS_SFF_26_U4 ( .B1(KE3_RS_n10), .B2(KE3_RS_SFF_26_n7), .A(
        KE3_RS_SFF_26_n10), .ZN(KE3_RS_SFF_26_n6) );
  OAI221_X1 KE3_RS_SFF_26_U3 ( .B1(RESET), .B2(KE3_KEY_PERM[26]), .C1(
        KE3_RS_SFF_26_n9), .C2(KEY3[26]), .A(KE3_RS_n10), .ZN(
        KE3_RS_SFF_26_n10) );
  INV_X1 KE3_RS_SFF_26_U2 ( .A(RESET), .ZN(KE3_RS_SFF_26_n9) );
  DFF_X1 KE3_RS_SFF_26_Q_reg ( .D(KE3_RS_SFF_26_n6), .CK(CLK), .Q(
        KE3_KEY_PERM[62]), .QN(KE3_RS_SFF_26_n7) );
  OAI21_X1 KE3_RS_SFF_27_U4 ( .B1(KE3_RS_n10), .B2(KE3_RS_SFF_27_n7), .A(
        KE3_RS_SFF_27_n10), .ZN(KE3_RS_SFF_27_n6) );
  OAI221_X1 KE3_RS_SFF_27_U3 ( .B1(RESET), .B2(KE3_KEY_PERM[27]), .C1(
        KE3_RS_SFF_27_n9), .C2(KEY3[27]), .A(KE3_RS_n10), .ZN(
        KE3_RS_SFF_27_n10) );
  INV_X1 KE3_RS_SFF_27_U2 ( .A(RESET), .ZN(KE3_RS_SFF_27_n9) );
  DFF_X1 KE3_RS_SFF_27_Q_reg ( .D(KE3_RS_SFF_27_n6), .CK(CLK), .Q(
        KE3_KEY_PERM[63]), .QN(KE3_RS_SFF_27_n7) );
  OAI21_X1 KE3_RS_SFF_28_U4 ( .B1(KE3_RS_n11), .B2(KE3_RS_SFF_28_n7), .A(
        KE3_RS_SFF_28_n10), .ZN(KE3_RS_SFF_28_n6) );
  OAI221_X1 KE3_RS_SFF_28_U3 ( .B1(RESET), .B2(KE3_KEY_PERM[28]), .C1(
        KE3_RS_SFF_28_n9), .C2(KEY3[28]), .A(KE3_RS_n11), .ZN(
        KE3_RS_SFF_28_n10) );
  INV_X1 KE3_RS_SFF_28_U2 ( .A(RESET), .ZN(KE3_RS_SFF_28_n9) );
  DFF_X1 KE3_RS_SFF_28_Q_reg ( .D(KE3_RS_SFF_28_n6), .CK(CLK), .Q(
        KE3_KEY_PERM[52]), .QN(KE3_RS_SFF_28_n7) );
  OAI21_X1 KE3_RS_SFF_29_U4 ( .B1(KE3_RS_n11), .B2(KE3_RS_SFF_29_n7), .A(
        KE3_RS_SFF_29_n10), .ZN(KE3_RS_SFF_29_n6) );
  OAI221_X1 KE3_RS_SFF_29_U3 ( .B1(RESET), .B2(KE3_KEY_PERM[29]), .C1(
        KE3_RS_SFF_29_n9), .C2(KEY3[29]), .A(KE3_RS_n11), .ZN(
        KE3_RS_SFF_29_n10) );
  INV_X1 KE3_RS_SFF_29_U2 ( .A(RESET), .ZN(KE3_RS_SFF_29_n9) );
  DFF_X1 KE3_RS_SFF_29_Q_reg ( .D(KE3_RS_SFF_29_n6), .CK(CLK), .Q(
        KE3_KEY_PERM[53]), .QN(KE3_RS_SFF_29_n7) );
  OAI21_X1 KE3_RS_SFF_30_U4 ( .B1(KE3_RS_n11), .B2(KE3_RS_SFF_30_n7), .A(
        KE3_RS_SFF_30_n10), .ZN(KE3_RS_SFF_30_n6) );
  OAI221_X1 KE3_RS_SFF_30_U3 ( .B1(RESET), .B2(KE3_KEY_PERM[30]), .C1(
        KE3_RS_SFF_30_n9), .C2(KEY3[30]), .A(KE3_RS_n11), .ZN(
        KE3_RS_SFF_30_n10) );
  INV_X1 KE3_RS_SFF_30_U2 ( .A(RESET), .ZN(KE3_RS_SFF_30_n9) );
  DFF_X1 KE3_RS_SFF_30_Q_reg ( .D(KE3_RS_SFF_30_n6), .CK(CLK), .Q(
        KE3_KEY_PERM[54]), .QN(KE3_RS_SFF_30_n7) );
  OAI21_X1 KE3_RS_SFF_31_U4 ( .B1(KE3_RS_n11), .B2(KE3_RS_SFF_31_n7), .A(
        KE3_RS_SFF_31_n10), .ZN(KE3_RS_SFF_31_n6) );
  OAI221_X1 KE3_RS_SFF_31_U3 ( .B1(RESET), .B2(KE3_KEY_PERM[31]), .C1(
        KE3_RS_SFF_31_n9), .C2(KEY3[31]), .A(KE3_RS_n11), .ZN(
        KE3_RS_SFF_31_n10) );
  INV_X1 KE3_RS_SFF_31_U2 ( .A(RESET), .ZN(KE3_RS_SFF_31_n9) );
  DFF_X1 KE3_RS_SFF_31_Q_reg ( .D(KE3_RS_SFF_31_n6), .CK(CLK), .Q(
        KE3_KEY_PERM[55]), .QN(KE3_RS_SFF_31_n7) );
  OAI21_X1 KE3_RS_SFF_32_U4 ( .B1(KE3_RS_n11), .B2(KE3_RS_SFF_32_n7), .A(
        KE3_RS_SFF_32_n10), .ZN(KE3_RS_SFF_32_n6) );
  OAI221_X1 KE3_RS_SFF_32_U3 ( .B1(RESET), .B2(KE3_KEY_PERM[32]), .C1(
        KE3_RS_SFF_32_n9), .C2(KEY3[32]), .A(KE3_RS_n11), .ZN(
        KE3_RS_SFF_32_n10) );
  INV_X1 KE3_RS_SFF_32_U2 ( .A(RESET), .ZN(KE3_RS_SFF_32_n9) );
  DFF_X1 KE3_RS_SFF_32_Q_reg ( .D(KE3_RS_SFF_32_n6), .CK(CLK), .Q(
        KE3_KEY_PERM[0]), .QN(KE3_RS_SFF_32_n7) );
  OAI21_X1 KE3_RS_SFF_33_U4 ( .B1(KE3_RS_n11), .B2(KE3_RS_SFF_33_n7), .A(
        KE3_RS_SFF_33_n10), .ZN(KE3_RS_SFF_33_n6) );
  OAI221_X1 KE3_RS_SFF_33_U3 ( .B1(RESET), .B2(KE3_KEY_PERM[33]), .C1(
        KE3_RS_SFF_33_n9), .C2(KEY3[33]), .A(KE3_RS_n11), .ZN(
        KE3_RS_SFF_33_n10) );
  INV_X1 KE3_RS_SFF_33_U2 ( .A(RESET), .ZN(KE3_RS_SFF_33_n9) );
  DFF_X1 KE3_RS_SFF_33_Q_reg ( .D(KE3_RS_SFF_33_n6), .CK(CLK), .Q(
        KE3_KEY_PERM[1]), .QN(KE3_RS_SFF_33_n7) );
  OAI21_X1 KE3_RS_SFF_34_U4 ( .B1(KE3_RS_n11), .B2(KE3_RS_SFF_34_n7), .A(
        KE3_RS_SFF_34_n10), .ZN(KE3_RS_SFF_34_n6) );
  OAI221_X1 KE3_RS_SFF_34_U3 ( .B1(RESET), .B2(KE3_KEY_PERM[34]), .C1(
        KE3_RS_SFF_34_n9), .C2(KEY3[34]), .A(KE3_RS_n11), .ZN(
        KE3_RS_SFF_34_n10) );
  INV_X1 KE3_RS_SFF_34_U2 ( .A(RESET), .ZN(KE3_RS_SFF_34_n9) );
  DFF_X1 KE3_RS_SFF_34_Q_reg ( .D(KE3_RS_SFF_34_n6), .CK(CLK), .Q(
        KE3_KEY_PERM[2]), .QN(KE3_RS_SFF_34_n7) );
  OAI21_X1 KE3_RS_SFF_35_U4 ( .B1(KE3_RS_n11), .B2(KE3_RS_SFF_35_n7), .A(
        KE3_RS_SFF_35_n10), .ZN(KE3_RS_SFF_35_n6) );
  OAI221_X1 KE3_RS_SFF_35_U3 ( .B1(RESET), .B2(KE3_KEY_PERM[35]), .C1(
        KE3_RS_SFF_35_n9), .C2(KEY3[35]), .A(KE3_RS_n11), .ZN(
        KE3_RS_SFF_35_n10) );
  INV_X1 KE3_RS_SFF_35_U2 ( .A(RESET), .ZN(KE3_RS_SFF_35_n9) );
  DFF_X1 KE3_RS_SFF_35_Q_reg ( .D(KE3_RS_SFF_35_n6), .CK(CLK), .Q(
        KE3_KEY_PERM[3]), .QN(KE3_RS_SFF_35_n7) );
  OAI21_X1 KE3_RS_SFF_36_U4 ( .B1(KE3_RS_n7), .B2(KE3_RS_SFF_36_n8), .A(
        KE3_RS_SFF_36_n11), .ZN(KE3_RS_SFF_36_n7) );
  OAI221_X1 KE3_RS_SFF_36_U3 ( .B1(RESET), .B2(KE3_KEY_PERM[36]), .C1(
        KE3_RS_SFF_36_n10), .C2(KEY3[36]), .A(KE3_RS_n7), .ZN(
        KE3_RS_SFF_36_n11) );
  INV_X1 KE3_RS_SFF_36_U2 ( .A(RESET), .ZN(KE3_RS_SFF_36_n10) );
  DFF_X1 KE3_RS_SFF_36_Q_reg ( .D(KE3_RS_SFF_36_n7), .CK(CLK), .Q(
        KE3_KEY_PERM[4]), .QN(KE3_RS_SFF_36_n8) );
  OAI21_X1 KE3_RS_SFF_37_U4 ( .B1(KE3_RS_n7), .B2(KE3_RS_SFF_37_n8), .A(
        KE3_RS_SFF_37_n11), .ZN(KE3_RS_SFF_37_n7) );
  OAI221_X1 KE3_RS_SFF_37_U3 ( .B1(RESET), .B2(KE3_KEY_PERM[37]), .C1(
        KE3_RS_SFF_37_n10), .C2(KEY3[37]), .A(KE3_RS_n7), .ZN(
        KE3_RS_SFF_37_n11) );
  INV_X1 KE3_RS_SFF_37_U2 ( .A(RESET), .ZN(KE3_RS_SFF_37_n10) );
  DFF_X1 KE3_RS_SFF_37_Q_reg ( .D(KE3_RS_SFF_37_n7), .CK(CLK), .Q(
        KE3_KEY_PERM[5]), .QN(KE3_RS_SFF_37_n8) );
  OAI21_X1 KE3_RS_SFF_38_U4 ( .B1(KE3_RS_n12), .B2(KE3_RS_SFF_38_n7), .A(
        KE3_RS_SFF_38_n10), .ZN(KE3_RS_SFF_38_n6) );
  OAI221_X1 KE3_RS_SFF_38_U3 ( .B1(RESET), .B2(KE3_KEY_PERM[38]), .C1(
        KE3_RS_SFF_38_n9), .C2(KEY3[38]), .A(KE3_RS_n12), .ZN(
        KE3_RS_SFF_38_n10) );
  INV_X1 KE3_RS_SFF_38_U2 ( .A(RESET), .ZN(KE3_RS_SFF_38_n9) );
  DFF_X1 KE3_RS_SFF_38_Q_reg ( .D(KE3_RS_SFF_38_n6), .CK(CLK), .Q(
        KE3_KEY_PERM[6]), .QN(KE3_RS_SFF_38_n7) );
  OAI21_X1 KE3_RS_SFF_39_U4 ( .B1(KE3_RS_n12), .B2(KE3_RS_SFF_39_n7), .A(
        KE3_RS_SFF_39_n10), .ZN(KE3_RS_SFF_39_n6) );
  OAI221_X1 KE3_RS_SFF_39_U3 ( .B1(RESET), .B2(KE3_KEY_PERM[39]), .C1(
        KE3_RS_SFF_39_n9), .C2(KEY3[39]), .A(KE3_RS_n12), .ZN(
        KE3_RS_SFF_39_n10) );
  INV_X1 KE3_RS_SFF_39_U2 ( .A(RESET), .ZN(KE3_RS_SFF_39_n9) );
  DFF_X1 KE3_RS_SFF_39_Q_reg ( .D(KE3_RS_SFF_39_n6), .CK(CLK), .Q(
        KE3_KEY_PERM[7]), .QN(KE3_RS_SFF_39_n7) );
  OAI21_X1 KE3_RS_SFF_40_U4 ( .B1(KE3_RS_n12), .B2(KE3_RS_SFF_40_n7), .A(
        KE3_RS_SFF_40_n10), .ZN(KE3_RS_SFF_40_n6) );
  OAI221_X1 KE3_RS_SFF_40_U3 ( .B1(RESET), .B2(KE3_KEY_PERM[40]), .C1(
        KE3_RS_SFF_40_n9), .C2(KEY3[40]), .A(KE3_RS_n12), .ZN(
        KE3_RS_SFF_40_n10) );
  INV_X1 KE3_RS_SFF_40_U2 ( .A(RESET), .ZN(KE3_RS_SFF_40_n9) );
  DFF_X1 KE3_RS_SFF_40_Q_reg ( .D(KE3_RS_SFF_40_n6), .CK(CLK), .Q(
        KE3_KEY_PERM[8]), .QN(KE3_RS_SFF_40_n7) );
  OAI21_X1 KE3_RS_SFF_41_U4 ( .B1(KE3_RS_n12), .B2(KE3_RS_SFF_41_n7), .A(
        KE3_RS_SFF_41_n10), .ZN(KE3_RS_SFF_41_n6) );
  OAI221_X1 KE3_RS_SFF_41_U3 ( .B1(RESET), .B2(KE3_KEY_PERM[41]), .C1(
        KE3_RS_SFF_41_n9), .C2(KEY3[41]), .A(KE3_RS_n12), .ZN(
        KE3_RS_SFF_41_n10) );
  INV_X1 KE3_RS_SFF_41_U2 ( .A(RESET), .ZN(KE3_RS_SFF_41_n9) );
  DFF_X1 KE3_RS_SFF_41_Q_reg ( .D(KE3_RS_SFF_41_n6), .CK(CLK), .Q(
        KE3_KEY_PERM[9]), .QN(KE3_RS_SFF_41_n7) );
  OAI21_X1 KE3_RS_SFF_42_U4 ( .B1(KE3_RS_n12), .B2(KE3_RS_SFF_42_n7), .A(
        KE3_RS_SFF_42_n10), .ZN(KE3_RS_SFF_42_n6) );
  OAI221_X1 KE3_RS_SFF_42_U3 ( .B1(RESET), .B2(KE3_KEY_PERM[42]), .C1(
        KE3_RS_SFF_42_n9), .C2(KEY3[42]), .A(KE3_RS_n12), .ZN(
        KE3_RS_SFF_42_n10) );
  INV_X1 KE3_RS_SFF_42_U2 ( .A(RESET), .ZN(KE3_RS_SFF_42_n9) );
  DFF_X1 KE3_RS_SFF_42_Q_reg ( .D(KE3_RS_SFF_42_n6), .CK(CLK), .Q(
        KE3_KEY_PERM[10]), .QN(KE3_RS_SFF_42_n7) );
  OAI21_X1 KE3_RS_SFF_43_U4 ( .B1(KE3_RS_n12), .B2(KE3_RS_SFF_43_n7), .A(
        KE3_RS_SFF_43_n10), .ZN(KE3_RS_SFF_43_n6) );
  OAI221_X1 KE3_RS_SFF_43_U3 ( .B1(RESET), .B2(KE3_KEY_PERM[43]), .C1(
        KE3_RS_SFF_43_n9), .C2(KEY3[43]), .A(KE3_RS_n12), .ZN(
        KE3_RS_SFF_43_n10) );
  INV_X1 KE3_RS_SFF_43_U2 ( .A(RESET), .ZN(KE3_RS_SFF_43_n9) );
  DFF_X1 KE3_RS_SFF_43_Q_reg ( .D(KE3_RS_SFF_43_n6), .CK(CLK), .Q(
        KE3_KEY_PERM[11]), .QN(KE3_RS_SFF_43_n7) );
  OAI21_X1 KE3_RS_SFF_44_U4 ( .B1(KE3_RS_n12), .B2(KE3_RS_SFF_44_n7), .A(
        KE3_RS_SFF_44_n10), .ZN(KE3_RS_SFF_44_n6) );
  OAI221_X1 KE3_RS_SFF_44_U3 ( .B1(RESET), .B2(KE3_KEY_PERM[44]), .C1(
        KE3_RS_SFF_44_n9), .C2(KEY3[44]), .A(KE3_RS_n12), .ZN(
        KE3_RS_SFF_44_n10) );
  INV_X1 KE3_RS_SFF_44_U2 ( .A(RESET), .ZN(KE3_RS_SFF_44_n9) );
  DFF_X1 KE3_RS_SFF_44_Q_reg ( .D(KE3_RS_SFF_44_n6), .CK(CLK), .Q(
        KE3_KEY_PERM[12]), .QN(KE3_RS_SFF_44_n7) );
  OAI21_X1 KE3_RS_SFF_45_U4 ( .B1(KE3_RS_n12), .B2(KE3_RS_SFF_45_n7), .A(
        KE3_RS_SFF_45_n10), .ZN(KE3_RS_SFF_45_n6) );
  OAI221_X1 KE3_RS_SFF_45_U3 ( .B1(RESET), .B2(KE3_KEY_PERM[45]), .C1(
        KE3_RS_SFF_45_n9), .C2(KEY3[45]), .A(KE3_RS_n12), .ZN(
        KE3_RS_SFF_45_n10) );
  INV_X1 KE3_RS_SFF_45_U2 ( .A(RESET), .ZN(KE3_RS_SFF_45_n9) );
  DFF_X1 KE3_RS_SFF_45_Q_reg ( .D(KE3_RS_SFF_45_n6), .CK(CLK), .Q(
        KE3_KEY_PERM[13]), .QN(KE3_RS_SFF_45_n7) );
  OAI21_X1 KE3_RS_SFF_46_U4 ( .B1(KE3_RS_n8), .B2(KE3_RS_SFF_46_n7), .A(
        KE3_RS_SFF_46_n10), .ZN(KE3_RS_SFF_46_n6) );
  OAI221_X1 KE3_RS_SFF_46_U3 ( .B1(RESET), .B2(KE3_KEY_PERM[46]), .C1(
        KE3_RS_SFF_46_n9), .C2(KEY3[46]), .A(KE3_RS_n8), .ZN(KE3_RS_SFF_46_n10) );
  INV_X1 KE3_RS_SFF_46_U2 ( .A(RESET), .ZN(KE3_RS_SFF_46_n9) );
  DFF_X1 KE3_RS_SFF_46_Q_reg ( .D(KE3_RS_SFF_46_n6), .CK(CLK), .Q(
        KE3_KEY_PERM[14]), .QN(KE3_RS_SFF_46_n7) );
  OAI21_X1 KE3_RS_SFF_47_U4 ( .B1(KE3_RS_n7), .B2(KE3_RS_SFF_47_n7), .A(
        KE3_RS_SFF_47_n10), .ZN(KE3_RS_SFF_47_n6) );
  OAI221_X1 KE3_RS_SFF_47_U3 ( .B1(RESET), .B2(KE3_KEY_PERM[47]), .C1(
        KE3_RS_SFF_47_n9), .C2(KEY3[47]), .A(KE3_RS_n7), .ZN(KE3_RS_SFF_47_n10) );
  INV_X1 KE3_RS_SFF_47_U2 ( .A(RESET), .ZN(KE3_RS_SFF_47_n9) );
  DFF_X1 KE3_RS_SFF_47_Q_reg ( .D(KE3_RS_SFF_47_n6), .CK(CLK), .Q(
        KE3_KEY_PERM[15]), .QN(KE3_RS_SFF_47_n7) );
  OAI21_X1 KE3_RS_SFF_48_U4 ( .B1(KE3_RS_n8), .B2(KE3_RS_SFF_48_n8), .A(
        KE3_RS_SFF_48_n11), .ZN(KE3_RS_SFF_48_n7) );
  OAI221_X1 KE3_RS_SFF_48_U3 ( .B1(RESET), .B2(KE3_KEY_PERM[48]), .C1(
        KE3_RS_SFF_48_n10), .C2(KEY3[48]), .A(KE3_RS_n8), .ZN(
        KE3_RS_SFF_48_n11) );
  INV_X1 KE3_RS_SFF_48_U2 ( .A(RESET), .ZN(KE3_RS_SFF_48_n10) );
  DFF_X1 KE3_RS_SFF_48_Q_reg ( .D(KE3_RS_SFF_48_n7), .CK(CLK), .Q(
        KE3_KEY_PERM[16]), .QN(KE3_RS_SFF_48_n8) );
  OAI21_X1 KE3_RS_SFF_49_U4 ( .B1(KE3_RS_n8), .B2(KE3_RS_SFF_49_n8), .A(
        KE3_RS_SFF_49_n11), .ZN(KE3_RS_SFF_49_n7) );
  OAI221_X1 KE3_RS_SFF_49_U3 ( .B1(RESET), .B2(KE3_KEY_PERM[49]), .C1(
        KE3_RS_SFF_49_n10), .C2(KEY3[49]), .A(KE3_RS_n8), .ZN(
        KE3_RS_SFF_49_n11) );
  INV_X1 KE3_RS_SFF_49_U2 ( .A(RESET), .ZN(KE3_RS_SFF_49_n10) );
  DFF_X1 KE3_RS_SFF_49_Q_reg ( .D(KE3_RS_SFF_49_n7), .CK(CLK), .Q(
        KE3_KEY_PERM[17]), .QN(KE3_RS_SFF_49_n8) );
  OAI21_X1 KE3_RS_SFF_50_U4 ( .B1(KEY_EN), .B2(KE3_RS_SFF_50_n7), .A(
        KE3_RS_SFF_50_n10), .ZN(KE3_RS_SFF_50_n6) );
  OAI221_X1 KE3_RS_SFF_50_U3 ( .B1(RESET), .B2(KE3_KEY_PERM[50]), .C1(
        KE3_RS_SFF_50_n9), .C2(KEY3[50]), .A(KEY_EN), .ZN(KE3_RS_SFF_50_n10)
         );
  INV_X1 KE3_RS_SFF_50_U2 ( .A(RESET), .ZN(KE3_RS_SFF_50_n9) );
  DFF_X1 KE3_RS_SFF_50_Q_reg ( .D(KE3_RS_SFF_50_n6), .CK(CLK), .Q(
        KE3_KEY_PERM[18]), .QN(KE3_RS_SFF_50_n7) );
  OAI21_X1 KE3_RS_SFF_51_U4 ( .B1(KE3_RS_n9), .B2(KE3_RS_SFF_51_n7), .A(
        KE3_RS_SFF_51_n10), .ZN(KE3_RS_SFF_51_n6) );
  OAI221_X1 KE3_RS_SFF_51_U3 ( .B1(RESET), .B2(KE3_KEY_PERM[51]), .C1(
        KE3_RS_SFF_51_n9), .C2(KEY3[51]), .A(KE3_RS_n9), .ZN(KE3_RS_SFF_51_n10) );
  INV_X1 KE3_RS_SFF_51_U2 ( .A(RESET), .ZN(KE3_RS_SFF_51_n9) );
  DFF_X1 KE3_RS_SFF_51_Q_reg ( .D(KE3_RS_SFF_51_n6), .CK(CLK), .Q(
        KE3_KEY_PERM[19]), .QN(KE3_RS_SFF_51_n7) );
  OAI21_X1 KE3_RS_SFF_52_U4 ( .B1(KE3_RS_n10), .B2(KE3_RS_SFF_52_n7), .A(
        KE3_RS_SFF_52_n10), .ZN(KE3_RS_SFF_52_n6) );
  OAI221_X1 KE3_RS_SFF_52_U3 ( .B1(RESET), .B2(KE3_KEY_PERM[52]), .C1(
        KE3_RS_SFF_52_n9), .C2(KEY3[52]), .A(KE3_RS_n10), .ZN(
        KE3_RS_SFF_52_n10) );
  INV_X1 KE3_RS_SFF_52_U2 ( .A(RESET), .ZN(KE3_RS_SFF_52_n9) );
  DFF_X1 KE3_RS_SFF_52_Q_reg ( .D(KE3_RS_SFF_52_n6), .CK(CLK), .Q(
        KE3_KEY_PERM[20]), .QN(KE3_RS_SFF_52_n7) );
  OAI21_X1 KE3_RS_SFF_53_U4 ( .B1(KE3_RS_n11), .B2(KE3_RS_SFF_53_n7), .A(
        KE3_RS_SFF_53_n10), .ZN(KE3_RS_SFF_53_n6) );
  OAI221_X1 KE3_RS_SFF_53_U3 ( .B1(RESET), .B2(KE3_KEY_PERM[53]), .C1(
        KE3_RS_SFF_53_n9), .C2(KEY3[53]), .A(KE3_RS_n11), .ZN(
        KE3_RS_SFF_53_n10) );
  INV_X1 KE3_RS_SFF_53_U2 ( .A(RESET), .ZN(KE3_RS_SFF_53_n9) );
  DFF_X1 KE3_RS_SFF_53_Q_reg ( .D(KE3_RS_SFF_53_n6), .CK(CLK), .Q(
        KE3_KEY_PERM[21]), .QN(KE3_RS_SFF_53_n7) );
  OAI21_X1 KE3_RS_SFF_54_U4 ( .B1(KE3_RS_n12), .B2(KE3_RS_SFF_54_n7), .A(
        KE3_RS_SFF_54_n10), .ZN(KE3_RS_SFF_54_n6) );
  OAI221_X1 KE3_RS_SFF_54_U3 ( .B1(RESET), .B2(KE3_KEY_PERM[54]), .C1(
        KE3_RS_SFF_54_n9), .C2(KEY3[54]), .A(KE3_RS_n12), .ZN(
        KE3_RS_SFF_54_n10) );
  INV_X1 KE3_RS_SFF_54_U2 ( .A(RESET), .ZN(KE3_RS_SFF_54_n9) );
  DFF_X1 KE3_RS_SFF_54_Q_reg ( .D(KE3_RS_SFF_54_n6), .CK(CLK), .Q(
        KE3_KEY_PERM[22]), .QN(KE3_RS_SFF_54_n7) );
  OAI21_X1 KE3_RS_SFF_55_U4 ( .B1(KE3_RS_n8), .B2(KE3_RS_SFF_55_n7), .A(
        KE3_RS_SFF_55_n10), .ZN(KE3_RS_SFF_55_n6) );
  OAI221_X1 KE3_RS_SFF_55_U3 ( .B1(RESET), .B2(KE3_KEY_PERM[55]), .C1(
        KE3_RS_SFF_55_n9), .C2(KEY3[55]), .A(KE3_RS_n8), .ZN(KE3_RS_SFF_55_n10) );
  INV_X1 KE3_RS_SFF_55_U2 ( .A(RESET), .ZN(KE3_RS_SFF_55_n9) );
  DFF_X1 KE3_RS_SFF_55_Q_reg ( .D(KE3_RS_SFF_55_n6), .CK(CLK), .Q(
        KE3_KEY_PERM[23]), .QN(KE3_RS_SFF_55_n7) );
  OAI21_X1 KE3_RS_SFF_56_U4 ( .B1(KEY_EN), .B2(KE3_RS_SFF_56_n7), .A(
        KE3_RS_SFF_56_n10), .ZN(KE3_RS_SFF_56_n6) );
  OAI221_X1 KE3_RS_SFF_56_U3 ( .B1(RESET), .B2(KE3_KEY_PERM[56]), .C1(
        KE3_RS_SFF_56_n9), .C2(KEY3[56]), .A(KEY_EN), .ZN(KE3_RS_SFF_56_n10)
         );
  INV_X1 KE3_RS_SFF_56_U2 ( .A(RESET), .ZN(KE3_RS_SFF_56_n9) );
  DFF_X1 KE3_RS_SFF_56_Q_reg ( .D(KE3_RS_SFF_56_n6), .CK(CLK), .Q(
        KE3_KEY_PERM[24]), .QN(KE3_RS_SFF_56_n7) );
  OAI21_X1 KE3_RS_SFF_57_U4 ( .B1(KE3_RS_n9), .B2(KE3_RS_SFF_57_n7), .A(
        KE3_RS_SFF_57_n10), .ZN(KE3_RS_SFF_57_n6) );
  OAI221_X1 KE3_RS_SFF_57_U3 ( .B1(RESET), .B2(KE3_KEY_PERM[57]), .C1(
        KE3_RS_SFF_57_n9), .C2(KEY3[57]), .A(KE3_RS_n9), .ZN(KE3_RS_SFF_57_n10) );
  INV_X1 KE3_RS_SFF_57_U2 ( .A(RESET), .ZN(KE3_RS_SFF_57_n9) );
  DFF_X1 KE3_RS_SFF_57_Q_reg ( .D(KE3_RS_SFF_57_n6), .CK(CLK), .Q(
        KE3_KEY_PERM[25]), .QN(KE3_RS_SFF_57_n7) );
  OAI21_X1 KE3_RS_SFF_58_U4 ( .B1(KE3_RS_n10), .B2(KE3_RS_SFF_58_n7), .A(
        KE3_RS_SFF_58_n10), .ZN(KE3_RS_SFF_58_n6) );
  OAI221_X1 KE3_RS_SFF_58_U3 ( .B1(RESET), .B2(KE3_KEY_PERM[58]), .C1(
        KE3_RS_SFF_58_n9), .C2(KEY3[58]), .A(KE3_RS_n10), .ZN(
        KE3_RS_SFF_58_n10) );
  INV_X1 KE3_RS_SFF_58_U2 ( .A(RESET), .ZN(KE3_RS_SFF_58_n9) );
  DFF_X1 KE3_RS_SFF_58_Q_reg ( .D(KE3_RS_SFF_58_n6), .CK(CLK), .Q(
        KE3_KEY_PERM[26]), .QN(KE3_RS_SFF_58_n7) );
  OAI21_X1 KE3_RS_SFF_59_U4 ( .B1(KE3_RS_n11), .B2(KE3_RS_SFF_59_n7), .A(
        KE3_RS_SFF_59_n10), .ZN(KE3_RS_SFF_59_n6) );
  OAI221_X1 KE3_RS_SFF_59_U3 ( .B1(RESET), .B2(KE3_KEY_PERM[59]), .C1(
        KE3_RS_SFF_59_n9), .C2(KEY3[59]), .A(KE3_RS_n11), .ZN(
        KE3_RS_SFF_59_n10) );
  INV_X1 KE3_RS_SFF_59_U2 ( .A(RESET), .ZN(KE3_RS_SFF_59_n9) );
  DFF_X1 KE3_RS_SFF_59_Q_reg ( .D(KE3_RS_SFF_59_n6), .CK(CLK), .Q(
        KE3_KEY_PERM[27]), .QN(KE3_RS_SFF_59_n7) );
  OAI21_X1 KE3_RS_SFF_60_U4 ( .B1(KE3_RS_n12), .B2(KE3_RS_SFF_60_n7), .A(
        KE3_RS_SFF_60_n10), .ZN(KE3_RS_SFF_60_n6) );
  OAI221_X1 KE3_RS_SFF_60_U3 ( .B1(RESET), .B2(KE3_KEY_PERM[60]), .C1(
        KE3_RS_SFF_60_n9), .C2(KEY3[60]), .A(KE3_RS_n12), .ZN(
        KE3_RS_SFF_60_n10) );
  INV_X1 KE3_RS_SFF_60_U2 ( .A(RESET), .ZN(KE3_RS_SFF_60_n9) );
  DFF_X1 KE3_RS_SFF_60_Q_reg ( .D(KE3_RS_SFF_60_n6), .CK(CLK), .Q(
        KE3_KEY_PERM[28]), .QN(KE3_RS_SFF_60_n7) );
  OAI21_X1 KE3_RS_SFF_61_U4 ( .B1(KE3_RS_n7), .B2(KE3_RS_SFF_61_n7), .A(
        KE3_RS_SFF_61_n10), .ZN(KE3_RS_SFF_61_n6) );
  OAI221_X1 KE3_RS_SFF_61_U3 ( .B1(RESET), .B2(KE3_KEY_PERM[61]), .C1(
        KE3_RS_SFF_61_n9), .C2(KEY3[61]), .A(KE3_RS_n7), .ZN(KE3_RS_SFF_61_n10) );
  INV_X1 KE3_RS_SFF_61_U2 ( .A(RESET), .ZN(KE3_RS_SFF_61_n9) );
  DFF_X1 KE3_RS_SFF_61_Q_reg ( .D(KE3_RS_SFF_61_n6), .CK(CLK), .Q(
        KE3_KEY_PERM[29]), .QN(KE3_RS_SFF_61_n7) );
  OAI21_X1 KE3_RS_SFF_62_U4 ( .B1(KE3_RS_n8), .B2(KE3_RS_SFF_62_n7), .A(
        KE3_RS_SFF_62_n10), .ZN(KE3_RS_SFF_62_n6) );
  OAI221_X1 KE3_RS_SFF_62_U3 ( .B1(RESET), .B2(KE3_KEY_PERM[62]), .C1(
        KE3_RS_SFF_62_n9), .C2(KEY3[62]), .A(KE3_RS_n8), .ZN(KE3_RS_SFF_62_n10) );
  INV_X1 KE3_RS_SFF_62_U2 ( .A(RESET), .ZN(KE3_RS_SFF_62_n9) );
  DFF_X1 KE3_RS_SFF_62_Q_reg ( .D(KE3_RS_SFF_62_n6), .CK(CLK), .Q(
        KE3_KEY_PERM[30]), .QN(KE3_RS_SFF_62_n7) );
  OAI21_X1 KE3_RS_SFF_63_U4 ( .B1(KE3_RS_n7), .B2(KE3_RS_SFF_63_n7), .A(
        KE3_RS_SFF_63_n10), .ZN(KE3_RS_SFF_63_n6) );
  OAI221_X1 KE3_RS_SFF_63_U3 ( .B1(RESET), .B2(KE3_KEY_PERM[63]), .C1(
        KE3_RS_SFF_63_n9), .C2(KEY3[63]), .A(KE3_RS_n7), .ZN(KE3_RS_SFF_63_n10) );
  INV_X1 KE3_RS_SFF_63_U2 ( .A(RESET), .ZN(KE3_RS_SFF_63_n9) );
  DFF_X1 KE3_RS_SFF_63_Q_reg ( .D(KE3_RS_SFF_63_n6), .CK(CLK), .Q(
        KE3_KEY_PERM[31]), .QN(KE3_RS_SFF_63_n7) );
  AOI221_X1 CL_U22 ( .B1(CL_n18), .B2(CL_n23), .C1(CL_n10), .C2(CL_n9), .A(
        RESET), .ZN(CL_n27) );
  AOI221_X1 CL_U21 ( .B1(CL_n18), .B2(CL_n25), .C1(CL_n10), .C2(CL_n23), .A(
        RESET), .ZN(CL_n28) );
  AOI221_X1 CL_U20 ( .B1(CL_n18), .B2(CL_n24), .C1(CL_n10), .C2(CL_n25), .A(
        RESET), .ZN(CL_n29) );
  AOI221_X1 CL_U19 ( .B1(CL_n18), .B2(CL_n19), .C1(CL_n10), .C2(CL_n24), .A(
        RESET), .ZN(CL_n30) );
  NOR2_X1 CL_U18 ( .A1(RESET), .A2(CL_n17), .ZN(CL_n3) );
  AOI221_X1 CL_U17 ( .B1(CL_n18), .B2(CL_n20), .C1(CL_n10), .C2(CL_n14), .A(
        RESET), .ZN(CL_n22) );
  AOI221_X1 CL_U16 ( .B1(CL_n18), .B2(CL_n9), .C1(CL_n10), .C2(CL_n20), .A(
        RESET), .ZN(CL_n21) );
  NOR2_X1 CL_U15 ( .A1(RESET), .A2(CL_n20), .ZN(ROUND_CST[1]) );
  NOR2_X1 CL_U14 ( .A1(RESET), .A2(CL_n16), .ZN(CL_n2) );
  NOR2_X1 CL_U13 ( .A1(RESET), .A2(CL_n15), .ZN(CL_n1) );
  NOR2_X1 CL_U12 ( .A1(RESET), .A2(CL_n24), .ZN(ROUND_CST[5]) );
  NOR2_X1 CL_U11 ( .A1(RESET), .A2(CL_n25), .ZN(ROUND_CST[4]) );
  NOR2_X1 CL_U10 ( .A1(RESET), .A2(CL_n23), .ZN(ROUND_CST[3]) );
  NOR2_X1 CL_U9 ( .A1(RESET), .A2(CL_n9), .ZN(ROUND_CST[2]) );
  NAND2_X1 CL_U8 ( .A1(CL_n14), .A2(CL_n12), .ZN(ROUND_CST[0]) );
  XOR2_X1 CL_U7 ( .A(CL_n24), .B(CL_n19), .Z(CL_n14) );
  NOR3_X1 CL_U6 ( .A1(CL_n24), .A2(CL_n25), .A3(CL_n13), .ZN(DONE) );
  NAND4_X1 CL_U5 ( .A1(CL_n20), .A2(CL_n19), .A3(CL_n9), .A4(CL_n11), .ZN(
        CL_n13) );
  INV_X1 CL_U4 ( .A(RESET), .ZN(CL_n12) );
  NAND2_X1 CL_U3 ( .A1(CL_n18), .A2(CL_n12), .ZN(KEY_EN) );
  DFF_X1 CL_SHIFT_reg_1_ ( .D(CL_n1), .CK(CLK), .Q(), .QN(CL_n16) );
  DFF_X1 CL_SHIFT_reg_2_ ( .D(CL_n2), .CK(CLK), .Q(), .QN(CL_n17) );
  DFF_X1 CL_SHIFT_reg_3_ ( .D(CL_n3), .CK(CLK), .Q(CL_n10), .QN(CL_n18) );
  DFF_X1 CL_STATE_reg_5_ ( .D(CL_n30), .CK(CLK), .Q(), .QN(CL_n19) );
  DFF_X1 CL_STATE_reg_4_ ( .D(CL_n29), .CK(CLK), .Q(), .QN(CL_n24) );
  DFF_X1 CL_STATE_reg_3_ ( .D(CL_n28), .CK(CLK), .Q(), .QN(CL_n25) );
  DFF_X1 CL_STATE_reg_2_ ( .D(CL_n27), .CK(CLK), .Q(CL_n11), .QN(CL_n23) );
  DFF_X1 CL_STATE_reg_1_ ( .D(CL_n21), .CK(CLK), .Q(), .QN(CL_n9) );
  DFF_X1 CL_STATE_reg_0_ ( .D(CL_n22), .CK(CLK), .Q(), .QN(CL_n20) );
  DFF_X1 CL_SHIFT_reg_0_ ( .D(KEY_EN), .CK(CLK), .Q(), .QN(CL_n15) );
endmodule

