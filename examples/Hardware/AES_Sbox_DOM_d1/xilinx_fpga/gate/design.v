// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2024.1 (win64) Build 5076996 Wed May 22 18:37:14 MDT 2024
// Command     : write_verilog design.v
// Design      : circuit
// Purpose     : This is a Verilog netlist of the current design or from a specific cell of the design. The output is an
//               IEEE 1364-2001 compliant Verilog HDL file that contains netlist information obtained from the input
//               design files.
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* EIGHT_STAGED = "yes" *) (* PIPELINED = "yes" *) (* SHARES = "2" *) 
(* STRUCTURAL_NETLIST = "yes" *)
module circuit
   (ClkxCI,
    \XxDI[1] ,
    \XxDI[0] ,
    \Zmul1xDI[0] ,
    \Zmul2xDI[0] ,
    \Zmul3xDI[0] ,
    \Zinv1xDI[0] ,
    \Zinv2xDI[0] ,
    \Zinv3xDI[0] ,
    \Bmul1xDI[1] ,
    \Bmul1xDI[0] ,
    \Binv1xDI[1] ,
    \Binv1xDI[0] ,
    \Binv2xDI[1] ,
    \Binv2xDI[0] ,
    \Binv3xDI[1] ,
    \Binv3xDI[0] ,
    \QxDO[1] ,
    \QxDO[0] );
  input ClkxCI;
  input [7:0]\XxDI[1] ;
  input [7:0]\XxDI[0] ;
  input [3:0]\Zmul1xDI[0] ;
  input [3:0]\Zmul2xDI[0] ;
  input [3:0]\Zmul3xDI[0] ;
  input [1:0]\Zinv1xDI[0] ;
  input [1:0]\Zinv2xDI[0] ;
  input [1:0]\Zinv3xDI[0] ;
  input [3:0]\Bmul1xDI[1] ;
  input [3:0]\Bmul1xDI[0] ;
  input [1:0]\Binv1xDI[1] ;
  input [1:0]\Binv1xDI[0] ;
  input [1:0]\Binv2xDI[1] ;
  input [1:0]\Binv2xDI[0] ;
  input [1:0]\Binv3xDI[1] ;
  input [1:0]\Binv3xDI[0] ;
  output [7:0]\QxDO[1] ;
  output [7:0]\QxDO[0] ;

  wire \<const0> ;
  wire \<const1> ;
  wire ClkxCI;
  wire ClkxCI_IBUF;
  wire ClkxCI_IBUF_BUFG;
  wire [3:0]\FFxDN[1]_0 ;
  wire [3:0]\FFxDN[1]_2 ;
  wire [3:0]\FFxDN[2]_3 ;
  wire [3:0]\FFxDN[2]_6 ;
  wire [2:1]\FFxDP_reg[0]_14 ;
  wire [3:1]\FFxDP_reg[0]_8 ;
  wire [2:1]\FFxDP_reg[1]_15 ;
  wire [3:1]\FFxDP_reg[1]_9 ;
  wire \FFxDP_reg[2][0]_i_2__0_n_0 ;
  wire \FFxDP_reg[2][0]_i_2__1_n_0 ;
  wire \FFxDP_reg[2][0]_i_2__2_n_0 ;
  wire \FFxDP_reg[2][0]_i_2__3_n_0 ;
  wire \FFxDP_reg[2][0]_i_2__4_n_0 ;
  wire \FFxDP_reg[2][0]_i_2_n_0 ;
  wire \FFxDP_reg[2][1]_i_2__0_n_0 ;
  wire \FFxDP_reg[2][1]_i_2__1_n_0 ;
  wire \FFxDP_reg[2][1]_i_2__2_n_0 ;
  wire \FFxDP_reg[2][1]_i_2__3_n_0 ;
  wire \FFxDP_reg[2][1]_i_2__4_n_0 ;
  wire \FFxDP_reg[2][1]_i_2_n_0 ;
  wire \FFxDP_reg[2][2]_i_2__0_n_0 ;
  wire \FFxDP_reg[2][2]_i_2__1_n_0 ;
  wire \FFxDP_reg[2][2]_i_2_n_0 ;
  wire \FFxDP_reg[2][3]_i_2__0_n_0 ;
  wire \FFxDP_reg[2][3]_i_2__1_n_0 ;
  wire \FFxDP_reg[2][3]_i_2_n_0 ;
  wire [3:1]\FFxDP_reg[2]_10 ;
  wire [2:1]\FFxDP_reg[2]_16 ;
  wire [3:1]\FFxDP_reg[3]_11 ;
  wire [2:1]\FFxDP_reg[3]_17 ;
  wire [3:0]\InverterInxD[0] ;
  wire [3:0]\InverterInxD[1] ;
  wire [7:0]\QxDO[0] ;
  wire [7:0]\QxDO[0]_OBUF ;
  wire [7:0]\QxDO[1] ;
  wire [7:0]\QxDO[1]_OBUF ;
  wire [3:0]\Xi_mul_Yj[0]_1 ;
  wire [3:0]\Xi_mul_Yj[0]_7 ;
  wire [3:0]\Xi_mul_Yj[3]_4 ;
  wire [3:0]\Xi_mul_Yj[3]_5 ;
  wire [7:0]\XxDI[0] ;
  wire [7:0]\XxDI[1] ;
  wire [3:1]\Y0xorY12xD[0] ;
  wire [3:1]\Y0xorY12xD[1] ;
  wire [0:0]\Y0xorY1xD[0] ;
  wire [0:0]\Y0xorY1xD[1] ;
  wire [3:0]\Y1xD[0] ;
  wire [3:0]\Y1xD[1] ;
  wire [1:0]\Zinv1xDI[0] ;
  wire [1:0]\Zinv2xDI[0] ;
  wire [1:0]\Zinv3xDI[0] ;
  wire [3:0]\Zmul1xDI[0] ;
  wire [3:0]\Zmul2xDI[0] ;
  wire [3:0]\Zmul3xDI[0] ;
  wire \gen_inner_multipliers_g[1].gen_outer_multipliers_g[0].gf4_mul/p_0_in2_in ;
  wire \gen_inner_multipliers_g[1].gen_outer_multipliers_g[0].gf4_mul/p_0_in2_in_13 ;
  wire \gen_inner_multipliers_g[1].gen_outer_multipliers_g[1].gf4_mul/p_0_in2_in ;
  wire \gen_inner_multipliers_g[1].gen_outer_multipliers_g[1].gf4_mul/p_0_in2_in_12 ;
  wire i__i_1__0_n_0;
  wire i__i_1__1_n_0;
  wire i__i_1__2_n_0;
  wire i__i_1_n_0;
  wire i__i_2__0_n_0;
  wire i__i_2__1_n_0;
  wire i__i_2__2_n_0;
  wire i__i_2_n_0;
  wire i__i_3__0_n_0;
  wire i__i_3_n_0;
  wire i__i_4__0_n_0;
  wire i__i_4_n_0;
  wire i__i_5__0_n_0;
  wire i__i_5_n_0;
  wire [0:0]\mappedxD[0] ;
  wire [0:0]\mappedxD[1] ;
  wire \masked_variant_pipelined_8_staged.InverterInxDP_reg_n_0_[0][0] ;
  wire \masked_variant_pipelined_8_staged.InverterInxDP_reg_n_0_[0][1] ;
  wire \masked_variant_pipelined_8_staged.InverterInxDP_reg_n_0_[0][2] ;
  wire \masked_variant_pipelined_8_staged.InverterInxDP_reg_n_0_[0][3] ;
  wire \masked_variant_pipelined_8_staged.InverterInxDP_reg_n_0_[1][0] ;
  wire \masked_variant_pipelined_8_staged.InverterInxDP_reg_n_0_[1][1] ;
  wire \masked_variant_pipelined_8_staged.InverterInxDP_reg_n_0_[1][2] ;
  wire \masked_variant_pipelined_8_staged.InverterInxDP_reg_n_0_[1][3] ;
  wire [3:0]\masked_variant_pipelined_8_staged.Y0_0xDP_reg[0] ;
  wire [3:0]\masked_variant_pipelined_8_staged.Y0_0xDP_reg[1] ;
  wire [3:0]\masked_variant_pipelined_8_staged.Y0_1xDP_reg[0] ;
  wire [3:0]\masked_variant_pipelined_8_staged.Y0_1xDP_reg[1] ;
  wire [3:0]\masked_variant_pipelined_8_staged.Y0_2xDP_reg[0] ;
  wire [3:0]\masked_variant_pipelined_8_staged.Y0_2xDP_reg[1] ;
  wire [3:0]\masked_variant_pipelined_8_staged.Y0_3xDP_reg[0] ;
  wire [3:0]\masked_variant_pipelined_8_staged.Y0_3xDP_reg[1] ;
  wire \masked_variant_pipelined_8_staged.Y0_4xDP_reg_n_0_[0][0] ;
  wire \masked_variant_pipelined_8_staged.Y0_4xDP_reg_n_0_[0][1] ;
  wire \masked_variant_pipelined_8_staged.Y0_4xDP_reg_n_0_[0][2] ;
  wire \masked_variant_pipelined_8_staged.Y0_4xDP_reg_n_0_[0][3] ;
  wire \masked_variant_pipelined_8_staged.Y0_4xDP_reg_n_0_[1][0] ;
  wire \masked_variant_pipelined_8_staged.Y0_4xDP_reg_n_0_[1][1] ;
  wire \masked_variant_pipelined_8_staged.Y0_4xDP_reg_n_0_[1][2] ;
  wire \masked_variant_pipelined_8_staged.Y0_4xDP_reg_n_0_[1][3] ;
  wire [3:0]\masked_variant_pipelined_8_staged.Y0xorY12xDP_reg[0] ;
  wire [3:0]\masked_variant_pipelined_8_staged.Y0xorY12xDP_reg[1] ;
  wire [3:0]\masked_variant_pipelined_8_staged.Y1_0xDP_reg[0] ;
  wire [3:0]\masked_variant_pipelined_8_staged.Y1_0xDP_reg[1] ;
  wire [3:0]\masked_variant_pipelined_8_staged.Y1_1xDP_reg[0] ;
  wire [3:0]\masked_variant_pipelined_8_staged.Y1_1xDP_reg[1] ;
  wire [3:0]\masked_variant_pipelined_8_staged.Y1_2xDP_reg[0] ;
  wire [3:0]\masked_variant_pipelined_8_staged.Y1_2xDP_reg[1] ;
  wire [3:0]\masked_variant_pipelined_8_staged.Y1_3xDP_reg[0] ;
  wire [3:0]\masked_variant_pipelined_8_staged.Y1_3xDP_reg[1] ;
  wire \masked_variant_pipelined_8_staged.Y1_4xDP_reg_n_0_[0][0] ;
  wire \masked_variant_pipelined_8_staged.Y1_4xDP_reg_n_0_[0][1] ;
  wire \masked_variant_pipelined_8_staged.Y1_4xDP_reg_n_0_[0][2] ;
  wire \masked_variant_pipelined_8_staged.Y1_4xDP_reg_n_0_[0][3] ;
  wire \masked_variant_pipelined_8_staged.Y1_4xDP_reg_n_0_[1][0] ;
  wire \masked_variant_pipelined_8_staged.Y1_4xDP_reg_n_0_[1][1] ;
  wire \masked_variant_pipelined_8_staged.Y1_4xDP_reg_n_0_[1][2] ;
  wire \masked_variant_pipelined_8_staged.Y1_4xDP_reg_n_0_[1][3] ;
  wire \masked_variant_pipelined_8_staged.generate_instances_g[0].input_mapping_n_0 ;
  wire \masked_variant_pipelined_8_staged.generate_instances_g[0].input_mapping_n_1 ;
  wire \masked_variant_pipelined_8_staged.generate_instances_g[0].input_mapping_n_2 ;
  wire \masked_variant_pipelined_8_staged.generate_instances_g[1].input_mapping_n_0 ;
  wire \masked_variant_pipelined_8_staged.generate_instances_g[1].input_mapping_n_1 ;
  wire \masked_variant_pipelined_8_staged.generate_instances_g[1].input_mapping_n_2 ;
  wire \masked_variant_pipelined_8_staged.mappedxDP[0][1]_i_1_n_0 ;
  wire \masked_variant_pipelined_8_staged.mappedxDP[0][4]_i_1_n_0 ;
  wire \masked_variant_pipelined_8_staged.mappedxDP[0][6]_i_1_n_0 ;
  wire \masked_variant_pipelined_8_staged.mappedxDP[1][1]_i_1_n_0 ;
  wire \masked_variant_pipelined_8_staged.mappedxDP[1][4]_i_1_n_0 ;
  wire \masked_variant_pipelined_8_staged.mappedxDP[1][6]_i_1_n_0 ;
  wire \masked_variant_pipelined_8_staged.mappedxDP_reg[0][2]_i_1_n_0 ;
  wire \masked_variant_pipelined_8_staged.mappedxDP_reg[1][2]_i_1_n_0 ;
  wire \masked_variant_pipelined_8_staged.mappedxDP_reg_n_0_[0][0] ;
  wire \masked_variant_pipelined_8_staged.mappedxDP_reg_n_0_[0][1] ;
  wire \masked_variant_pipelined_8_staged.mappedxDP_reg_n_0_[0][2] ;
  wire \masked_variant_pipelined_8_staged.mappedxDP_reg_n_0_[0][3] ;
  wire \masked_variant_pipelined_8_staged.mappedxDP_reg_n_0_[1][0] ;
  wire \masked_variant_pipelined_8_staged.mappedxDP_reg_n_0_[1][1] ;
  wire \masked_variant_pipelined_8_staged.mappedxDP_reg_n_0_[1][2] ;
  wire \masked_variant_pipelined_8_staged.mappedxDP_reg_n_0_[1][3] ;
  wire \masked_variant_pipelined_8_staged.mult_lsb_n_15 ;
  wire \masked_variant_pipelined_8_staged.mult_lsb_n_17 ;
  wire \masked_variant_pipelined_8_staged.mult_msb_n_19 ;
  wire \masked_variant_pipelined_8_staged.mult_msb_n_21 ;
  wire \masked_variant_pipelined_8_staged.mult_msb_n_23 ;
  wire \masked_variant_pipelined_8_staged.mult_msb_n_9 ;

  BUFG ClkxCI_IBUF_BUFG_inst
       (.I(ClkxCI_IBUF),
        .O(ClkxCI_IBUF_BUFG));
  IBUF ClkxCI_IBUF_inst
       (.I(ClkxCI),
        .O(ClkxCI_IBUF));
  IBUF \FFxDP_reg[2][0]_i_2 
       (.I(\Zmul1xDI[0] [0]),
        .O(\FFxDP_reg[2][0]_i_2_n_0 ));
  IBUF \FFxDP_reg[2][0]_i_2__0 
       (.I(\Zmul2xDI[0] [0]),
        .O(\FFxDP_reg[2][0]_i_2__0_n_0 ));
  IBUF \FFxDP_reg[2][0]_i_2__1 
       (.I(\Zmul3xDI[0] [0]),
        .O(\FFxDP_reg[2][0]_i_2__1_n_0 ));
  IBUF \FFxDP_reg[2][0]_i_2__2 
       (.I(\Zinv1xDI[0] [0]),
        .O(\FFxDP_reg[2][0]_i_2__2_n_0 ));
  IBUF \FFxDP_reg[2][0]_i_2__3 
       (.I(\Zinv2xDI[0] [0]),
        .O(\FFxDP_reg[2][0]_i_2__3_n_0 ));
  IBUF \FFxDP_reg[2][0]_i_2__4 
       (.I(\Zinv3xDI[0] [0]),
        .O(\FFxDP_reg[2][0]_i_2__4_n_0 ));
  IBUF \FFxDP_reg[2][1]_i_2 
       (.I(\Zmul1xDI[0] [1]),
        .O(\FFxDP_reg[2][1]_i_2_n_0 ));
  IBUF \FFxDP_reg[2][1]_i_2__0 
       (.I(\Zmul2xDI[0] [1]),
        .O(\FFxDP_reg[2][1]_i_2__0_n_0 ));
  IBUF \FFxDP_reg[2][1]_i_2__1 
       (.I(\Zmul3xDI[0] [1]),
        .O(\FFxDP_reg[2][1]_i_2__1_n_0 ));
  IBUF \FFxDP_reg[2][1]_i_2__2 
       (.I(\Zinv1xDI[0] [1]),
        .O(\FFxDP_reg[2][1]_i_2__2_n_0 ));
  IBUF \FFxDP_reg[2][1]_i_2__3 
       (.I(\Zinv2xDI[0] [1]),
        .O(\FFxDP_reg[2][1]_i_2__3_n_0 ));
  IBUF \FFxDP_reg[2][1]_i_2__4 
       (.I(\Zinv3xDI[0] [1]),
        .O(\FFxDP_reg[2][1]_i_2__4_n_0 ));
  IBUF \FFxDP_reg[2][2]_i_2 
       (.I(\Zmul1xDI[0] [2]),
        .O(\FFxDP_reg[2][2]_i_2_n_0 ));
  IBUF \FFxDP_reg[2][2]_i_2__0 
       (.I(\Zmul2xDI[0] [2]),
        .O(\FFxDP_reg[2][2]_i_2__0_n_0 ));
  IBUF \FFxDP_reg[2][2]_i_2__1 
       (.I(\Zmul3xDI[0] [2]),
        .O(\FFxDP_reg[2][2]_i_2__1_n_0 ));
  IBUF \FFxDP_reg[2][3]_i_2 
       (.I(\Zmul1xDI[0] [3]),
        .O(\FFxDP_reg[2][3]_i_2_n_0 ));
  IBUF \FFxDP_reg[2][3]_i_2__0 
       (.I(\Zmul2xDI[0] [3]),
        .O(\FFxDP_reg[2][3]_i_2__0_n_0 ));
  IBUF \FFxDP_reg[2][3]_i_2__1 
       (.I(\Zmul3xDI[0] [3]),
        .O(\FFxDP_reg[2][3]_i_2__1_n_0 ));
  GND GND
       (.G(\<const0> ));
  OBUF \QxDO[0][0]_INST_0 
       (.I(\QxDO[0]_OBUF [0]),
        .O(\QxDO[0] [0]));
  OBUF \QxDO[0][1]_INST_0 
       (.I(\QxDO[0]_OBUF [1]),
        .O(\QxDO[0] [1]));
  OBUF \QxDO[0][2]_INST_0 
       (.I(\QxDO[0]_OBUF [2]),
        .O(\QxDO[0] [2]));
  OBUF \QxDO[0][3]_INST_0 
       (.I(\QxDO[0]_OBUF [3]),
        .O(\QxDO[0] [3]));
  OBUF \QxDO[0][4]_INST_0 
       (.I(\QxDO[0]_OBUF [4]),
        .O(\QxDO[0] [4]));
  OBUF \QxDO[0][5]_INST_0 
       (.I(\QxDO[0]_OBUF [5]),
        .O(\QxDO[0] [5]));
  OBUF \QxDO[0][6]_INST_0 
       (.I(\QxDO[0]_OBUF [6]),
        .O(\QxDO[0] [6]));
  OBUF \QxDO[0][7]_INST_0 
       (.I(\QxDO[0]_OBUF [7]),
        .O(\QxDO[0] [7]));
  OBUF \QxDO[1][0]_INST_0 
       (.I(\QxDO[1]_OBUF [0]),
        .O(\QxDO[1] [0]));
  OBUF \QxDO[1][1]_INST_0 
       (.I(\QxDO[1]_OBUF [1]),
        .O(\QxDO[1] [1]));
  OBUF \QxDO[1][2]_INST_0 
       (.I(\QxDO[1]_OBUF [2]),
        .O(\QxDO[1] [2]));
  OBUF \QxDO[1][3]_INST_0 
       (.I(\QxDO[1]_OBUF [3]),
        .O(\QxDO[1] [3]));
  OBUF \QxDO[1][4]_INST_0 
       (.I(\QxDO[1]_OBUF [4]),
        .O(\QxDO[1] [4]));
  OBUF \QxDO[1][5]_INST_0 
       (.I(\QxDO[1]_OBUF [5]),
        .O(\QxDO[1] [5]));
  OBUF \QxDO[1][6]_INST_0 
       (.I(\QxDO[1]_OBUF [6]),
        .O(\QxDO[1] [6]));
  OBUF \QxDO[1][7]_INST_0 
       (.I(\QxDO[1]_OBUF [7]),
        .O(\QxDO[1] [7]));
  VCC VCC
       (.P(\<const1> ));
  IBUF i__i_1
       (.I(\XxDI[1] [6]),
        .O(i__i_1_n_0));
  IBUF i__i_1__0
       (.I(\XxDI[1] [4]),
        .O(i__i_1__0_n_0));
  IBUF i__i_1__1
       (.I(\XxDI[0] [6]),
        .O(i__i_1__1_n_0));
  IBUF i__i_1__2
       (.I(\XxDI[0] [4]),
        .O(i__i_1__2_n_0));
  IBUF i__i_2
       (.I(\XxDI[1] [3]),
        .O(i__i_2_n_0));
  IBUF i__i_2__0
       (.I(\XxDI[1] [1]),
        .O(i__i_2__0_n_0));
  IBUF i__i_2__1
       (.I(\XxDI[0] [3]),
        .O(i__i_2__1_n_0));
  IBUF i__i_2__2
       (.I(\XxDI[0] [1]),
        .O(i__i_2__2_n_0));
  IBUF i__i_3
       (.I(\XxDI[1] [2]),
        .O(i__i_3_n_0));
  IBUF i__i_3__0
       (.I(\XxDI[0] [2]),
        .O(i__i_3__0_n_0));
  IBUF i__i_4
       (.I(\XxDI[1] [5]),
        .O(i__i_4_n_0));
  IBUF i__i_4__0
       (.I(\XxDI[0] [5]),
        .O(i__i_4__0_n_0));
  IBUF i__i_5
       (.I(\XxDI[1] [7]),
        .O(i__i_5_n_0));
  IBUF i__i_5__0
       (.I(\XxDI[0] [7]),
        .O(i__i_5__0_n_0));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.InverterInxDP_reg[0][0] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\InverterInxD[0] [0]),
        .Q(\masked_variant_pipelined_8_staged.InverterInxDP_reg_n_0_[0][0] ),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.InverterInxDP_reg[0][1] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\InverterInxD[0] [1]),
        .Q(\masked_variant_pipelined_8_staged.InverterInxDP_reg_n_0_[0][1] ),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.InverterInxDP_reg[0][2] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\InverterInxD[0] [2]),
        .Q(\masked_variant_pipelined_8_staged.InverterInxDP_reg_n_0_[0][2] ),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.InverterInxDP_reg[0][3] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\InverterInxD[0] [3]),
        .Q(\masked_variant_pipelined_8_staged.InverterInxDP_reg_n_0_[0][3] ),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.InverterInxDP_reg[1][0] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\InverterInxD[1] [0]),
        .Q(\masked_variant_pipelined_8_staged.InverterInxDP_reg_n_0_[1][0] ),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.InverterInxDP_reg[1][1] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\InverterInxD[1] [1]),
        .Q(\masked_variant_pipelined_8_staged.InverterInxDP_reg_n_0_[1][1] ),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.InverterInxDP_reg[1][2] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\InverterInxD[1] [2]),
        .Q(\masked_variant_pipelined_8_staged.InverterInxDP_reg_n_0_[1][2] ),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.InverterInxDP_reg[1][3] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\InverterInxD[1] [3]),
        .Q(\masked_variant_pipelined_8_staged.InverterInxDP_reg_n_0_[1][3] ),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y0_0xDP_reg[0][0] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.mappedxDP_reg_n_0_[0][0] ),
        .Q(\masked_variant_pipelined_8_staged.Y0_0xDP_reg[0] [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y0_0xDP_reg[0][1] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.mappedxDP_reg_n_0_[0][1] ),
        .Q(\masked_variant_pipelined_8_staged.Y0_0xDP_reg[0] [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y0_0xDP_reg[0][2] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.mappedxDP_reg_n_0_[0][2] ),
        .Q(\masked_variant_pipelined_8_staged.Y0_0xDP_reg[0] [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y0_0xDP_reg[0][3] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.mappedxDP_reg_n_0_[0][3] ),
        .Q(\masked_variant_pipelined_8_staged.Y0_0xDP_reg[0] [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y0_0xDP_reg[1][0] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.mappedxDP_reg_n_0_[1][0] ),
        .Q(\masked_variant_pipelined_8_staged.Y0_0xDP_reg[1] [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y0_0xDP_reg[1][1] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.mappedxDP_reg_n_0_[1][1] ),
        .Q(\masked_variant_pipelined_8_staged.Y0_0xDP_reg[1] [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y0_0xDP_reg[1][2] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.mappedxDP_reg_n_0_[1][2] ),
        .Q(\masked_variant_pipelined_8_staged.Y0_0xDP_reg[1] [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y0_0xDP_reg[1][3] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.mappedxDP_reg_n_0_[1][3] ),
        .Q(\masked_variant_pipelined_8_staged.Y0_0xDP_reg[1] [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y0_1xDP_reg[0][0] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.Y0_0xDP_reg[0] [0]),
        .Q(\masked_variant_pipelined_8_staged.Y0_1xDP_reg[0] [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y0_1xDP_reg[0][1] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.Y0_0xDP_reg[0] [1]),
        .Q(\masked_variant_pipelined_8_staged.Y0_1xDP_reg[0] [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y0_1xDP_reg[0][2] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.Y0_0xDP_reg[0] [2]),
        .Q(\masked_variant_pipelined_8_staged.Y0_1xDP_reg[0] [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y0_1xDP_reg[0][3] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.Y0_0xDP_reg[0] [3]),
        .Q(\masked_variant_pipelined_8_staged.Y0_1xDP_reg[0] [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y0_1xDP_reg[1][0] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.Y0_0xDP_reg[1] [0]),
        .Q(\masked_variant_pipelined_8_staged.Y0_1xDP_reg[1] [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y0_1xDP_reg[1][1] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.Y0_0xDP_reg[1] [1]),
        .Q(\masked_variant_pipelined_8_staged.Y0_1xDP_reg[1] [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y0_1xDP_reg[1][2] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.Y0_0xDP_reg[1] [2]),
        .Q(\masked_variant_pipelined_8_staged.Y0_1xDP_reg[1] [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y0_1xDP_reg[1][3] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.Y0_0xDP_reg[1] [3]),
        .Q(\masked_variant_pipelined_8_staged.Y0_1xDP_reg[1] [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y0_2xDP_reg[0][0] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.Y0_1xDP_reg[0] [0]),
        .Q(\masked_variant_pipelined_8_staged.Y0_2xDP_reg[0] [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y0_2xDP_reg[0][1] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.Y0_1xDP_reg[0] [1]),
        .Q(\masked_variant_pipelined_8_staged.Y0_2xDP_reg[0] [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y0_2xDP_reg[0][2] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.Y0_1xDP_reg[0] [2]),
        .Q(\masked_variant_pipelined_8_staged.Y0_2xDP_reg[0] [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y0_2xDP_reg[0][3] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.Y0_1xDP_reg[0] [3]),
        .Q(\masked_variant_pipelined_8_staged.Y0_2xDP_reg[0] [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y0_2xDP_reg[1][0] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.Y0_1xDP_reg[1] [0]),
        .Q(\masked_variant_pipelined_8_staged.Y0_2xDP_reg[1] [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y0_2xDP_reg[1][1] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.Y0_1xDP_reg[1] [1]),
        .Q(\masked_variant_pipelined_8_staged.Y0_2xDP_reg[1] [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y0_2xDP_reg[1][2] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.Y0_1xDP_reg[1] [2]),
        .Q(\masked_variant_pipelined_8_staged.Y0_2xDP_reg[1] [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y0_2xDP_reg[1][3] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.Y0_1xDP_reg[1] [3]),
        .Q(\masked_variant_pipelined_8_staged.Y0_2xDP_reg[1] [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y0_3xDP_reg[0][0] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.Y0_2xDP_reg[0] [0]),
        .Q(\masked_variant_pipelined_8_staged.Y0_3xDP_reg[0] [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y0_3xDP_reg[0][1] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.Y0_2xDP_reg[0] [1]),
        .Q(\masked_variant_pipelined_8_staged.Y0_3xDP_reg[0] [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y0_3xDP_reg[0][2] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.Y0_2xDP_reg[0] [2]),
        .Q(\masked_variant_pipelined_8_staged.Y0_3xDP_reg[0] [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y0_3xDP_reg[0][3] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.Y0_2xDP_reg[0] [3]),
        .Q(\masked_variant_pipelined_8_staged.Y0_3xDP_reg[0] [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y0_3xDP_reg[1][0] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.Y0_2xDP_reg[1] [0]),
        .Q(\masked_variant_pipelined_8_staged.Y0_3xDP_reg[1] [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y0_3xDP_reg[1][1] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.Y0_2xDP_reg[1] [1]),
        .Q(\masked_variant_pipelined_8_staged.Y0_3xDP_reg[1] [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y0_3xDP_reg[1][2] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.Y0_2xDP_reg[1] [2]),
        .Q(\masked_variant_pipelined_8_staged.Y0_3xDP_reg[1] [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y0_3xDP_reg[1][3] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.Y0_2xDP_reg[1] [3]),
        .Q(\masked_variant_pipelined_8_staged.Y0_3xDP_reg[1] [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y0_4xDP_reg[0][0] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.Y0_3xDP_reg[0] [0]),
        .Q(\masked_variant_pipelined_8_staged.Y0_4xDP_reg_n_0_[0][0] ),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y0_4xDP_reg[0][1] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.Y0_3xDP_reg[0] [1]),
        .Q(\masked_variant_pipelined_8_staged.Y0_4xDP_reg_n_0_[0][1] ),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y0_4xDP_reg[0][2] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.Y0_3xDP_reg[0] [2]),
        .Q(\masked_variant_pipelined_8_staged.Y0_4xDP_reg_n_0_[0][2] ),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y0_4xDP_reg[0][3] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.Y0_3xDP_reg[0] [3]),
        .Q(\masked_variant_pipelined_8_staged.Y0_4xDP_reg_n_0_[0][3] ),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y0_4xDP_reg[1][0] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.Y0_3xDP_reg[1] [0]),
        .Q(\masked_variant_pipelined_8_staged.Y0_4xDP_reg_n_0_[1][0] ),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y0_4xDP_reg[1][1] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.Y0_3xDP_reg[1] [1]),
        .Q(\masked_variant_pipelined_8_staged.Y0_4xDP_reg_n_0_[1][1] ),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y0_4xDP_reg[1][2] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.Y0_3xDP_reg[1] [2]),
        .Q(\masked_variant_pipelined_8_staged.Y0_4xDP_reg_n_0_[1][2] ),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y0_4xDP_reg[1][3] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.Y0_3xDP_reg[1] [3]),
        .Q(\masked_variant_pipelined_8_staged.Y0_4xDP_reg_n_0_[1][3] ),
        .R(\<const0> ));
  (* SOFT_HLUTNM = "soft_lutpair18" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \masked_variant_pipelined_8_staged.Y0xorY12xDP[0][0]_i_1 
       (.I0(\masked_variant_pipelined_8_staged.mappedxDP_reg_n_0_[0][0] ),
        .I1(\Y1xD[0] [0]),
        .O(\Y0xorY1xD[0] ));
  (* SOFT_HLUTNM = "soft_lutpair18" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    \masked_variant_pipelined_8_staged.Y0xorY12xDP[0][1]_i_1 
       (.I0(\Y1xD[0] [0]),
        .I1(\masked_variant_pipelined_8_staged.mappedxDP_reg_n_0_[0][0] ),
        .I2(\Y1xD[0] [1]),
        .I3(\masked_variant_pipelined_8_staged.mappedxDP_reg_n_0_[0][1] ),
        .O(\Y0xorY12xD[0] [1]));
  LUT4 #(
    .INIT(16'h6996)) 
    \masked_variant_pipelined_8_staged.Y0xorY12xDP[0][2]_i_1 
       (.I0(\Y1xD[0] [3]),
        .I1(\masked_variant_pipelined_8_staged.mappedxDP_reg_n_0_[0][3] ),
        .I2(\Y1xD[0] [1]),
        .I3(\masked_variant_pipelined_8_staged.mappedxDP_reg_n_0_[0][1] ),
        .O(\Y0xorY12xD[0] [2]));
  LUT4 #(
    .INIT(16'h6996)) 
    \masked_variant_pipelined_8_staged.Y0xorY12xDP[0][3]_i_1 
       (.I0(\Y1xD[0] [2]),
        .I1(\masked_variant_pipelined_8_staged.mappedxDP_reg_n_0_[0][2] ),
        .I2(\Y1xD[0] [0]),
        .I3(\masked_variant_pipelined_8_staged.mappedxDP_reg_n_0_[0][0] ),
        .O(\Y0xorY12xD[0] [3]));
  (* SOFT_HLUTNM = "soft_lutpair17" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \masked_variant_pipelined_8_staged.Y0xorY12xDP[1][0]_i_1 
       (.I0(\masked_variant_pipelined_8_staged.mappedxDP_reg_n_0_[1][0] ),
        .I1(\Y1xD[1] [0]),
        .O(\Y0xorY1xD[1] ));
  (* SOFT_HLUTNM = "soft_lutpair17" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    \masked_variant_pipelined_8_staged.Y0xorY12xDP[1][1]_i_1 
       (.I0(\Y1xD[1] [0]),
        .I1(\masked_variant_pipelined_8_staged.mappedxDP_reg_n_0_[1][0] ),
        .I2(\Y1xD[1] [1]),
        .I3(\masked_variant_pipelined_8_staged.mappedxDP_reg_n_0_[1][1] ),
        .O(\Y0xorY12xD[1] [1]));
  LUT4 #(
    .INIT(16'h6996)) 
    \masked_variant_pipelined_8_staged.Y0xorY12xDP[1][2]_i_1 
       (.I0(\Y1xD[1] [3]),
        .I1(\masked_variant_pipelined_8_staged.mappedxDP_reg_n_0_[1][3] ),
        .I2(\Y1xD[1] [1]),
        .I3(\masked_variant_pipelined_8_staged.mappedxDP_reg_n_0_[1][1] ),
        .O(\Y0xorY12xD[1] [2]));
  LUT4 #(
    .INIT(16'h6996)) 
    \masked_variant_pipelined_8_staged.Y0xorY12xDP[1][3]_i_1 
       (.I0(\Y1xD[1] [2]),
        .I1(\masked_variant_pipelined_8_staged.mappedxDP_reg_n_0_[1][2] ),
        .I2(\Y1xD[1] [0]),
        .I3(\masked_variant_pipelined_8_staged.mappedxDP_reg_n_0_[1][0] ),
        .O(\Y0xorY12xD[1] [3]));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y0xorY12xDP_reg[0][0] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\Y0xorY1xD[0] ),
        .Q(\masked_variant_pipelined_8_staged.Y0xorY12xDP_reg[0] [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y0xorY12xDP_reg[0][1] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\Y0xorY12xD[0] [1]),
        .Q(\masked_variant_pipelined_8_staged.Y0xorY12xDP_reg[0] [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y0xorY12xDP_reg[0][2] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\Y0xorY12xD[0] [2]),
        .Q(\masked_variant_pipelined_8_staged.Y0xorY12xDP_reg[0] [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y0xorY12xDP_reg[0][3] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\Y0xorY12xD[0] [3]),
        .Q(\masked_variant_pipelined_8_staged.Y0xorY12xDP_reg[0] [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y0xorY12xDP_reg[1][0] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\Y0xorY1xD[1] ),
        .Q(\masked_variant_pipelined_8_staged.Y0xorY12xDP_reg[1] [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y0xorY12xDP_reg[1][1] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\Y0xorY12xD[1] [1]),
        .Q(\masked_variant_pipelined_8_staged.Y0xorY12xDP_reg[1] [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y0xorY12xDP_reg[1][2] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\Y0xorY12xD[1] [2]),
        .Q(\masked_variant_pipelined_8_staged.Y0xorY12xDP_reg[1] [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y0xorY12xDP_reg[1][3] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\Y0xorY12xD[1] [3]),
        .Q(\masked_variant_pipelined_8_staged.Y0xorY12xDP_reg[1] [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y1_0xDP_reg[0][0] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\Y1xD[0] [0]),
        .Q(\masked_variant_pipelined_8_staged.Y1_0xDP_reg[0] [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y1_0xDP_reg[0][1] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\Y1xD[0] [1]),
        .Q(\masked_variant_pipelined_8_staged.Y1_0xDP_reg[0] [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y1_0xDP_reg[0][2] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\Y1xD[0] [2]),
        .Q(\masked_variant_pipelined_8_staged.Y1_0xDP_reg[0] [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y1_0xDP_reg[0][3] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\Y1xD[0] [3]),
        .Q(\masked_variant_pipelined_8_staged.Y1_0xDP_reg[0] [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y1_0xDP_reg[1][0] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\Y1xD[1] [0]),
        .Q(\masked_variant_pipelined_8_staged.Y1_0xDP_reg[1] [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y1_0xDP_reg[1][1] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\Y1xD[1] [1]),
        .Q(\masked_variant_pipelined_8_staged.Y1_0xDP_reg[1] [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y1_0xDP_reg[1][2] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\Y1xD[1] [2]),
        .Q(\masked_variant_pipelined_8_staged.Y1_0xDP_reg[1] [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y1_0xDP_reg[1][3] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\Y1xD[1] [3]),
        .Q(\masked_variant_pipelined_8_staged.Y1_0xDP_reg[1] [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y1_1xDP_reg[0][0] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.Y1_0xDP_reg[0] [0]),
        .Q(\masked_variant_pipelined_8_staged.Y1_1xDP_reg[0] [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y1_1xDP_reg[0][1] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.Y1_0xDP_reg[0] [1]),
        .Q(\masked_variant_pipelined_8_staged.Y1_1xDP_reg[0] [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y1_1xDP_reg[0][2] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.Y1_0xDP_reg[0] [2]),
        .Q(\masked_variant_pipelined_8_staged.Y1_1xDP_reg[0] [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y1_1xDP_reg[0][3] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.Y1_0xDP_reg[0] [3]),
        .Q(\masked_variant_pipelined_8_staged.Y1_1xDP_reg[0] [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y1_1xDP_reg[1][0] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.Y1_0xDP_reg[1] [0]),
        .Q(\masked_variant_pipelined_8_staged.Y1_1xDP_reg[1] [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y1_1xDP_reg[1][1] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.Y1_0xDP_reg[1] [1]),
        .Q(\masked_variant_pipelined_8_staged.Y1_1xDP_reg[1] [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y1_1xDP_reg[1][2] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.Y1_0xDP_reg[1] [2]),
        .Q(\masked_variant_pipelined_8_staged.Y1_1xDP_reg[1] [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y1_1xDP_reg[1][3] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.Y1_0xDP_reg[1] [3]),
        .Q(\masked_variant_pipelined_8_staged.Y1_1xDP_reg[1] [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y1_2xDP_reg[0][0] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.Y1_1xDP_reg[0] [0]),
        .Q(\masked_variant_pipelined_8_staged.Y1_2xDP_reg[0] [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y1_2xDP_reg[0][1] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.Y1_1xDP_reg[0] [1]),
        .Q(\masked_variant_pipelined_8_staged.Y1_2xDP_reg[0] [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y1_2xDP_reg[0][2] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.Y1_1xDP_reg[0] [2]),
        .Q(\masked_variant_pipelined_8_staged.Y1_2xDP_reg[0] [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y1_2xDP_reg[0][3] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.Y1_1xDP_reg[0] [3]),
        .Q(\masked_variant_pipelined_8_staged.Y1_2xDP_reg[0] [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y1_2xDP_reg[1][0] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.Y1_1xDP_reg[1] [0]),
        .Q(\masked_variant_pipelined_8_staged.Y1_2xDP_reg[1] [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y1_2xDP_reg[1][1] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.Y1_1xDP_reg[1] [1]),
        .Q(\masked_variant_pipelined_8_staged.Y1_2xDP_reg[1] [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y1_2xDP_reg[1][2] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.Y1_1xDP_reg[1] [2]),
        .Q(\masked_variant_pipelined_8_staged.Y1_2xDP_reg[1] [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y1_2xDP_reg[1][3] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.Y1_1xDP_reg[1] [3]),
        .Q(\masked_variant_pipelined_8_staged.Y1_2xDP_reg[1] [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y1_3xDP_reg[0][0] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.Y1_2xDP_reg[0] [0]),
        .Q(\masked_variant_pipelined_8_staged.Y1_3xDP_reg[0] [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y1_3xDP_reg[0][1] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.Y1_2xDP_reg[0] [1]),
        .Q(\masked_variant_pipelined_8_staged.Y1_3xDP_reg[0] [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y1_3xDP_reg[0][2] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.Y1_2xDP_reg[0] [2]),
        .Q(\masked_variant_pipelined_8_staged.Y1_3xDP_reg[0] [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y1_3xDP_reg[0][3] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.Y1_2xDP_reg[0] [3]),
        .Q(\masked_variant_pipelined_8_staged.Y1_3xDP_reg[0] [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y1_3xDP_reg[1][0] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.Y1_2xDP_reg[1] [0]),
        .Q(\masked_variant_pipelined_8_staged.Y1_3xDP_reg[1] [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y1_3xDP_reg[1][1] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.Y1_2xDP_reg[1] [1]),
        .Q(\masked_variant_pipelined_8_staged.Y1_3xDP_reg[1] [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y1_3xDP_reg[1][2] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.Y1_2xDP_reg[1] [2]),
        .Q(\masked_variant_pipelined_8_staged.Y1_3xDP_reg[1] [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y1_3xDP_reg[1][3] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.Y1_2xDP_reg[1] [3]),
        .Q(\masked_variant_pipelined_8_staged.Y1_3xDP_reg[1] [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y1_4xDP_reg[0][0] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.Y1_3xDP_reg[0] [0]),
        .Q(\masked_variant_pipelined_8_staged.Y1_4xDP_reg_n_0_[0][0] ),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y1_4xDP_reg[0][1] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.Y1_3xDP_reg[0] [1]),
        .Q(\masked_variant_pipelined_8_staged.Y1_4xDP_reg_n_0_[0][1] ),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y1_4xDP_reg[0][2] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.Y1_3xDP_reg[0] [2]),
        .Q(\masked_variant_pipelined_8_staged.Y1_4xDP_reg_n_0_[0][2] ),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y1_4xDP_reg[0][3] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.Y1_3xDP_reg[0] [3]),
        .Q(\masked_variant_pipelined_8_staged.Y1_4xDP_reg_n_0_[0][3] ),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y1_4xDP_reg[1][0] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.Y1_3xDP_reg[1] [0]),
        .Q(\masked_variant_pipelined_8_staged.Y1_4xDP_reg_n_0_[1][0] ),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y1_4xDP_reg[1][1] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.Y1_3xDP_reg[1] [1]),
        .Q(\masked_variant_pipelined_8_staged.Y1_4xDP_reg_n_0_[1][1] ),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y1_4xDP_reg[1][2] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.Y1_3xDP_reg[1] [2]),
        .Q(\masked_variant_pipelined_8_staged.Y1_4xDP_reg_n_0_[1][2] ),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.Y1_4xDP_reg[1][3] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.Y1_3xDP_reg[1] [3]),
        .Q(\masked_variant_pipelined_8_staged.Y1_4xDP_reg_n_0_[1][3] ),
        .R(\<const0> ));
  lin_map \masked_variant_pipelined_8_staged.generate_instances_g[0].input_mapping 
       (.D({\masked_variant_pipelined_8_staged.generate_instances_g[0].input_mapping_n_0 ,\masked_variant_pipelined_8_staged.generate_instances_g[0].input_mapping_n_1 ,\masked_variant_pipelined_8_staged.generate_instances_g[0].input_mapping_n_2 ,\mappedxD[0] }),
        .\masked_variant_pipelined_8_staged.mappedxDP_reg[0][0] (i__i_2__1_n_0),
        .\masked_variant_pipelined_8_staged.mappedxDP_reg[0][3] (i__i_1__2_n_0),
        .\masked_variant_pipelined_8_staged.mappedxDP_reg[0][7] (i__i_1__1_n_0),
        .\masked_variant_pipelined_8_staged.mappedxDP_reg[0][7]_0 (\masked_variant_pipelined_8_staged.mappedxDP_reg[0][2]_i_1_n_0 ),
        .\masked_variant_pipelined_8_staged.mappedxDP_reg[0][7]_1 (i__i_2__2_n_0),
        .\masked_variant_pipelined_8_staged.mappedxDP_reg[0][7]_2 (i__i_3__0_n_0),
        .\masked_variant_pipelined_8_staged.mappedxDP_reg[0][7]_3 (i__i_4__0_n_0),
        .\masked_variant_pipelined_8_staged.mappedxDP_reg[0][7]_4 (i__i_5__0_n_0));
  lin_map_0 \masked_variant_pipelined_8_staged.generate_instances_g[1].input_mapping 
       (.D({\masked_variant_pipelined_8_staged.generate_instances_g[1].input_mapping_n_0 ,\masked_variant_pipelined_8_staged.generate_instances_g[1].input_mapping_n_1 ,\masked_variant_pipelined_8_staged.generate_instances_g[1].input_mapping_n_2 ,\mappedxD[1] }),
        .\masked_variant_pipelined_8_staged.mappedxDP_reg[1][0] (i__i_2_n_0),
        .\masked_variant_pipelined_8_staged.mappedxDP_reg[1][3] (i__i_1__0_n_0),
        .\masked_variant_pipelined_8_staged.mappedxDP_reg[1][7] (i__i_1_n_0),
        .\masked_variant_pipelined_8_staged.mappedxDP_reg[1][7]_0 (\masked_variant_pipelined_8_staged.mappedxDP_reg[1][2]_i_1_n_0 ),
        .\masked_variant_pipelined_8_staged.mappedxDP_reg[1][7]_1 (i__i_2__0_n_0),
        .\masked_variant_pipelined_8_staged.mappedxDP_reg[1][7]_2 (i__i_3_n_0),
        .\masked_variant_pipelined_8_staged.mappedxDP_reg[1][7]_3 (i__i_4_n_0),
        .\masked_variant_pipelined_8_staged.mappedxDP_reg[1][7]_4 (i__i_5_n_0));
  inverter \masked_variant_pipelined_8_staged.inverter_gf24 
       (.CLK(ClkxCI_IBUF_BUFG),
        .D(\Xi_mul_Yj[0]_7 ),
        .\FFxDP_reg[0][1] (\masked_variant_pipelined_8_staged.mult_lsb_n_15 ),
        .\FFxDP_reg[0][1]_0 ({\masked_variant_pipelined_8_staged.Y1_4xDP_reg_n_0_[0][3] ,\masked_variant_pipelined_8_staged.Y1_4xDP_reg_n_0_[0][2] ,\masked_variant_pipelined_8_staged.Y1_4xDP_reg_n_0_[0][1] ,\masked_variant_pipelined_8_staged.Y1_4xDP_reg_n_0_[0][0] }),
        .\FFxDP_reg[1][0] (\FFxDP_reg[2][0]_i_2__0_n_0 ),
        .\FFxDP_reg[1][0]_0 (\FFxDP_reg[2][0]_i_2__1_n_0 ),
        .\FFxDP_reg[1][0]_1 (\FFxDP_reg[2][0]_i_2__2_n_0 ),
        .\FFxDP_reg[1][0]_2 (\FFxDP_reg[2][0]_i_2__3_n_0 ),
        .\FFxDP_reg[1][0]_3 (\FFxDP_reg[2][0]_i_2__4_n_0 ),
        .\FFxDP_reg[1][1] (\FFxDP_reg[2][1]_i_2__0_n_0 ),
        .\FFxDP_reg[1][1]_0 (\masked_variant_pipelined_8_staged.mult_lsb_n_17 ),
        .\FFxDP_reg[1][1]_1 (\FFxDP_reg[2][1]_i_2__1_n_0 ),
        .\FFxDP_reg[1][1]_2 (\FFxDP_reg[2][1]_i_2__2_n_0 ),
        .\FFxDP_reg[1][1]_3 (\FFxDP_reg[2][1]_i_2__3_n_0 ),
        .\FFxDP_reg[1][1]_4 (\FFxDP_reg[2][1]_i_2__4_n_0 ),
        .\FFxDP_reg[1][2] (\FFxDP_reg[2][2]_i_2__0_n_0 ),
        .\FFxDP_reg[1][2]_0 (\FFxDP_reg[2][2]_i_2__1_n_0 ),
        .\FFxDP_reg[1][3] (\masked_variant_pipelined_8_staged.mult_msb_n_23 ),
        .\FFxDP_reg[1][3]_0 (\FFxDP_reg[2][3]_i_2__0_n_0 ),
        .\FFxDP_reg[1][3]_1 (\FFxDP_reg[2][3]_i_2__1_n_0 ),
        .\FFxDP_reg[2][3] (\masked_variant_pipelined_8_staged.mult_msb_n_21 ),
        .\FFxDP_reg[3][3] ({\masked_variant_pipelined_8_staged.Y0_4xDP_reg_n_0_[1][3] ,\masked_variant_pipelined_8_staged.Y0_4xDP_reg_n_0_[1][2] ,\masked_variant_pipelined_8_staged.Y0_4xDP_reg_n_0_[1][1] ,\masked_variant_pipelined_8_staged.Y0_4xDP_reg_n_0_[1][0] }),
        .\FFxDP_reg[3][3]_0 ({\masked_variant_pipelined_8_staged.Y1_4xDP_reg_n_0_[1][3] ,\masked_variant_pipelined_8_staged.Y1_4xDP_reg_n_0_[1][2] ,\masked_variant_pipelined_8_staged.Y1_4xDP_reg_n_0_[1][1] ,\masked_variant_pipelined_8_staged.Y1_4xDP_reg_n_0_[1][0] }),
        .Q({\masked_variant_pipelined_8_staged.Y0_4xDP_reg_n_0_[0][3] ,\masked_variant_pipelined_8_staged.Y0_4xDP_reg_n_0_[0][2] ,\masked_variant_pipelined_8_staged.Y0_4xDP_reg_n_0_[0][1] ,\masked_variant_pipelined_8_staged.Y0_4xDP_reg_n_0_[0][0] }),
        .\Zmul2xDI[0][3] (\FFxDN[2]_6 ),
        .\Zmul2xDI[0][3]_0 (\FFxDN[1]_2 ),
        .\Zmul3xDI[0][3] (\FFxDN[2]_3 ),
        .\Zmul3xDI[0][3]_0 (\FFxDN[1]_0 ),
        .\masked_variant_pipelined_8_staged.Y0_4xDP_reg[1][1] (\Xi_mul_Yj[3]_5 ),
        .\masked_variant_pipelined_8_staged.Y1_4xDP_reg[0][1] (\Xi_mul_Yj[0]_1 ),
        .\masked_variant_pipelined_8_staged.Y1_4xDP_reg[1][1] (\Xi_mul_Yj[3]_4 ),
        .p_0_in2_in(\gen_inner_multipliers_g[1].gen_outer_multipliers_g[0].gf4_mul/p_0_in2_in_13 ),
        .p_0_in2_in_0(\gen_inner_multipliers_g[1].gen_outer_multipliers_g[1].gf4_mul/p_0_in2_in_12 ),
        .p_0_in2_in_1(\gen_inner_multipliers_g[1].gen_outer_multipliers_g[1].gf4_mul/p_0_in2_in ),
        .p_0_in2_in_2(\gen_inner_multipliers_g[1].gen_outer_multipliers_g[0].gf4_mul/p_0_in2_in ),
        .\shared_sel_pipelined_4staged.AxDP_reg[0][1]_0 ({\masked_variant_pipelined_8_staged.InverterInxDP_reg_n_0_[0][3] ,\masked_variant_pipelined_8_staged.InverterInxDP_reg_n_0_[0][2] ,\masked_variant_pipelined_8_staged.InverterInxDP_reg_n_0_[0][1] ,\masked_variant_pipelined_8_staged.InverterInxDP_reg_n_0_[0][0] }),
        .\shared_sel_pipelined_4staged.AxDP_reg[1][1]_0 ({\masked_variant_pipelined_8_staged.InverterInxDP_reg_n_0_[1][3] ,\masked_variant_pipelined_8_staged.InverterInxDP_reg_n_0_[1][2] ,\masked_variant_pipelined_8_staged.InverterInxDP_reg_n_0_[1][1] ,\masked_variant_pipelined_8_staged.InverterInxDP_reg_n_0_[1][0] }));
  (* SOFT_HLUTNM = "soft_lutpair19" *) 
  LUT3 #(
    .INIT(8'h96)) 
    \masked_variant_pipelined_8_staged.mappedxDP[0][1]_i_1 
       (.I0(i__i_4__0_n_0),
        .I1(i__i_1__1_n_0),
        .I2(\masked_variant_pipelined_8_staged.mappedxDP_reg[0][2]_i_1_n_0 ),
        .O(\masked_variant_pipelined_8_staged.mappedxDP[0][1]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h6996)) 
    \masked_variant_pipelined_8_staged.mappedxDP[0][4]_i_1 
       (.I0(i__i_1__1_n_0),
        .I1(\masked_variant_pipelined_8_staged.mappedxDP_reg[0][2]_i_1_n_0 ),
        .I2(i__i_5__0_n_0),
        .I3(i__i_4__0_n_0),
        .O(\masked_variant_pipelined_8_staged.mappedxDP[0][4]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair19" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    \masked_variant_pipelined_8_staged.mappedxDP[0][6]_i_1 
       (.I0(i__i_1__2_n_0),
        .I1(\masked_variant_pipelined_8_staged.mappedxDP_reg[0][2]_i_1_n_0 ),
        .I2(i__i_1__1_n_0),
        .I3(i__i_4__0_n_0),
        .O(\masked_variant_pipelined_8_staged.mappedxDP[0][6]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT3 #(
    .INIT(8'h96)) 
    \masked_variant_pipelined_8_staged.mappedxDP[1][1]_i_1 
       (.I0(i__i_4_n_0),
        .I1(i__i_1_n_0),
        .I2(\masked_variant_pipelined_8_staged.mappedxDP_reg[1][2]_i_1_n_0 ),
        .O(\masked_variant_pipelined_8_staged.mappedxDP[1][1]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h6996)) 
    \masked_variant_pipelined_8_staged.mappedxDP[1][4]_i_1 
       (.I0(i__i_1_n_0),
        .I1(\masked_variant_pipelined_8_staged.mappedxDP_reg[1][2]_i_1_n_0 ),
        .I2(i__i_5_n_0),
        .I3(i__i_4_n_0),
        .O(\masked_variant_pipelined_8_staged.mappedxDP[1][4]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    \masked_variant_pipelined_8_staged.mappedxDP[1][6]_i_1 
       (.I0(i__i_1__0_n_0),
        .I1(\masked_variant_pipelined_8_staged.mappedxDP_reg[1][2]_i_1_n_0 ),
        .I2(i__i_1_n_0),
        .I3(i__i_4_n_0),
        .O(\masked_variant_pipelined_8_staged.mappedxDP[1][6]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.mappedxDP_reg[0][0] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\mappedxD[0] ),
        .Q(\masked_variant_pipelined_8_staged.mappedxDP_reg_n_0_[0][0] ),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.mappedxDP_reg[0][1] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.mappedxDP[0][1]_i_1_n_0 ),
        .Q(\masked_variant_pipelined_8_staged.mappedxDP_reg_n_0_[0][1] ),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.mappedxDP_reg[0][2] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.mappedxDP_reg[0][2]_i_1_n_0 ),
        .Q(\masked_variant_pipelined_8_staged.mappedxDP_reg_n_0_[0][2] ),
        .R(\<const0> ));
  IBUF \masked_variant_pipelined_8_staged.mappedxDP_reg[0][2]_i_1 
       (.I(\XxDI[0] [0]),
        .O(\masked_variant_pipelined_8_staged.mappedxDP_reg[0][2]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.mappedxDP_reg[0][3] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.generate_instances_g[0].input_mapping_n_2 ),
        .Q(\masked_variant_pipelined_8_staged.mappedxDP_reg_n_0_[0][3] ),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.mappedxDP_reg[0][4] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.mappedxDP[0][4]_i_1_n_0 ),
        .Q(\Y1xD[0] [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.mappedxDP_reg[0][5] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.generate_instances_g[0].input_mapping_n_1 ),
        .Q(\Y1xD[0] [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.mappedxDP_reg[0][6] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.mappedxDP[0][6]_i_1_n_0 ),
        .Q(\Y1xD[0] [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.mappedxDP_reg[0][7] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.generate_instances_g[0].input_mapping_n_0 ),
        .Q(\Y1xD[0] [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.mappedxDP_reg[1][0] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\mappedxD[1] ),
        .Q(\masked_variant_pipelined_8_staged.mappedxDP_reg_n_0_[1][0] ),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.mappedxDP_reg[1][1] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.mappedxDP[1][1]_i_1_n_0 ),
        .Q(\masked_variant_pipelined_8_staged.mappedxDP_reg_n_0_[1][1] ),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.mappedxDP_reg[1][2] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.mappedxDP_reg[1][2]_i_1_n_0 ),
        .Q(\masked_variant_pipelined_8_staged.mappedxDP_reg_n_0_[1][2] ),
        .R(\<const0> ));
  IBUF \masked_variant_pipelined_8_staged.mappedxDP_reg[1][2]_i_1 
       (.I(\XxDI[1] [0]),
        .O(\masked_variant_pipelined_8_staged.mappedxDP_reg[1][2]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.mappedxDP_reg[1][3] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.generate_instances_g[1].input_mapping_n_2 ),
        .Q(\masked_variant_pipelined_8_staged.mappedxDP_reg_n_0_[1][3] ),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.mappedxDP_reg[1][4] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.mappedxDP[1][4]_i_1_n_0 ),
        .Q(\Y1xD[1] [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.mappedxDP_reg[1][5] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.generate_instances_g[1].input_mapping_n_1 ),
        .Q(\Y1xD[1] [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.mappedxDP_reg[1][6] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.mappedxDP[1][6]_i_1_n_0 ),
        .Q(\Y1xD[1] [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \masked_variant_pipelined_8_staged.mappedxDP_reg[1][7] 
       (.C(ClkxCI_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\masked_variant_pipelined_8_staged.generate_instances_g[1].input_mapping_n_0 ),
        .Q(\Y1xD[1] [3]),
        .R(\<const0> ));
  shared_mul_gf4 \masked_variant_pipelined_8_staged.mul_y0y1 
       (.CLK(ClkxCI_IBUF_BUFG),
        .D(\InverterInxD[1] ),
        .\FFxDP_reg[2][0]_0 (\FFxDP_reg[2][0]_i_2_n_0 ),
        .\FFxDP_reg[2][1]_0 (\FFxDP_reg[2][1]_i_2_n_0 ),
        .\FFxDP_reg[2][2]_0 (\FFxDP_reg[2][2]_i_2_n_0 ),
        .\FFxDP_reg[2][3]_0 (\FFxDP_reg[2][3]_i_2_n_0 ),
        .\FFxDP_reg[3][3]_0 ({\Y1xD[1] ,\masked_variant_pipelined_8_staged.mappedxDP_reg_n_0_[1][3] ,\masked_variant_pipelined_8_staged.mappedxDP_reg_n_0_[1][2] ,\masked_variant_pipelined_8_staged.mappedxDP_reg_n_0_[1][1] ,\masked_variant_pipelined_8_staged.mappedxDP_reg_n_0_[1][0] }),
        .Q({\Y1xD[0] ,\masked_variant_pipelined_8_staged.mappedxDP_reg_n_0_[0][3] ,\masked_variant_pipelined_8_staged.mappedxDP_reg_n_0_[0][2] ,\masked_variant_pipelined_8_staged.mappedxDP_reg_n_0_[0][1] ,\masked_variant_pipelined_8_staged.mappedxDP_reg_n_0_[0][0] }),
        .\masked_variant_pipelined_8_staged.InverterInxDP_reg[0][3] (\masked_variant_pipelined_8_staged.Y0xorY12xDP_reg[0] ),
        .\masked_variant_pipelined_8_staged.InverterInxDP_reg[1][3] (\masked_variant_pipelined_8_staged.Y0xorY12xDP_reg[1] ),
        .\masked_variant_pipelined_8_staged.Y0xorY12xDP_reg[0][3] (\InverterInxD[0] ));
  shared_mul_gf4_1 \masked_variant_pipelined_8_staged.mult_lsb 
       (.CLK(ClkxCI_IBUF_BUFG),
        .D(\Xi_mul_Yj[3]_4 ),
        .\FFxDP_reg[0][0]_0 ({\masked_variant_pipelined_8_staged.Y1_4xDP_reg_n_0_[0][3] ,\masked_variant_pipelined_8_staged.Y1_4xDP_reg_n_0_[0][2] ,\masked_variant_pipelined_8_staged.Y1_4xDP_reg_n_0_[0][1] ,\masked_variant_pipelined_8_staged.Y1_4xDP_reg_n_0_[0][0] }),
        .\FFxDP_reg[0][3]_0 ({\FFxDP_reg[0]_8 [3],\FFxDP_reg[0]_8 [1]}),
        .\FFxDP_reg[0][3]_1 (\Xi_mul_Yj[0]_1 ),
        .\FFxDP_reg[1][1]_0 ({\masked_variant_pipelined_8_staged.Y1_4xDP_reg_n_0_[1][3] ,\masked_variant_pipelined_8_staged.Y1_4xDP_reg_n_0_[1][2] ,\masked_variant_pipelined_8_staged.Y1_4xDP_reg_n_0_[1][1] ,\masked_variant_pipelined_8_staged.Y1_4xDP_reg_n_0_[1][0] }),
        .\FFxDP_reg[1][3]_0 ({\FFxDP_reg[1]_9 [3],\FFxDP_reg[1]_9 [1]}),
        .\FFxDP_reg[1][3]_1 (\FFxDN[1]_0 ),
        .\FFxDP_reg[2][3]_0 ({\FFxDP_reg[2]_10 [3],\FFxDP_reg[2]_10 [1]}),
        .\FFxDP_reg[2][3]_1 (\FFxDN[2]_3 ),
        .Q({\FFxDP_reg[3]_11 [3],\FFxDP_reg[3]_11 [1]}),
        .\QxDO[0][2] (\masked_variant_pipelined_8_staged.mult_msb_n_19 ),
        .\QxDO[0][5] (\FFxDP_reg[0]_14 ),
        .\QxDO[0][5]_0 (\FFxDP_reg[1]_15 ),
        .\QxDO[0]_OBUF ({\QxDO[0]_OBUF [7],\QxDO[0]_OBUF [5],\QxDO[0]_OBUF [2]}),
        .\QxDO[1][2] (\masked_variant_pipelined_8_staged.mult_msb_n_9 ),
        .\QxDO[1][5] (\FFxDP_reg[2]_16 ),
        .\QxDO[1][5]_0 (\FFxDP_reg[3]_17 ),
        .\QxDO[1]_OBUF ({\QxDO[1]_OBUF [7],\QxDO[1]_OBUF [5],\QxDO[1]_OBUF [2]}),
        .\masked_variant_pipelined_8_staged.Y1_4xDP_reg[0][0] (\masked_variant_pipelined_8_staged.mult_lsb_n_15 ),
        .\masked_variant_pipelined_8_staged.Y1_4xDP_reg[1][0] (\masked_variant_pipelined_8_staged.mult_lsb_n_17 ),
        .p_0_in2_in(\gen_inner_multipliers_g[1].gen_outer_multipliers_g[0].gf4_mul/p_0_in2_in ),
        .p_0_in2_in_0(\gen_inner_multipliers_g[1].gen_outer_multipliers_g[1].gf4_mul/p_0_in2_in ));
  shared_mul_gf4_2 \masked_variant_pipelined_8_staged.mult_msb 
       (.CLK(ClkxCI_IBUF_BUFG),
        .D(\Xi_mul_Yj[3]_5 ),
        .\FFxDP_reg[0][2]_0 (\FFxDP_reg[0]_14 ),
        .\FFxDP_reg[0][3]_0 (\Xi_mul_Yj[0]_7 ),
        .\FFxDP_reg[1][1]_0 (\masked_variant_pipelined_8_staged.mult_msb_n_19 ),
        .\FFxDP_reg[1][2]_0 (\FFxDP_reg[1]_15 ),
        .\FFxDP_reg[1][3]_0 ({\masked_variant_pipelined_8_staged.Y0_4xDP_reg_n_0_[1][3] ,\masked_variant_pipelined_8_staged.Y0_4xDP_reg_n_0_[1][2] ,\masked_variant_pipelined_8_staged.Y0_4xDP_reg_n_0_[1][1] ,\masked_variant_pipelined_8_staged.Y0_4xDP_reg_n_0_[1][0] }),
        .\FFxDP_reg[1][3]_1 (\FFxDN[1]_2 ),
        .\FFxDP_reg[2][2]_0 (\FFxDP_reg[2]_16 ),
        .\FFxDP_reg[2][3]_0 ({\masked_variant_pipelined_8_staged.Y0_4xDP_reg_n_0_[0][3] ,\masked_variant_pipelined_8_staged.Y0_4xDP_reg_n_0_[0][2] ,\masked_variant_pipelined_8_staged.Y0_4xDP_reg_n_0_[0][1] ,\masked_variant_pipelined_8_staged.Y0_4xDP_reg_n_0_[0][0] }),
        .\FFxDP_reg[2][3]_1 (\FFxDN[2]_6 ),
        .\FFxDP_reg[3][1]_0 (\masked_variant_pipelined_8_staged.mult_msb_n_9 ),
        .Q(\FFxDP_reg[3]_17 ),
        .\QxDO[0][4] ({\FFxDP_reg[1]_9 [3],\FFxDP_reg[1]_9 [1]}),
        .\QxDO[0][4]_0 ({\FFxDP_reg[0]_8 [3],\FFxDP_reg[0]_8 [1]}),
        .\QxDO[0]_OBUF ({\QxDO[0]_OBUF [6],\QxDO[0]_OBUF [4:3],\QxDO[0]_OBUF [1:0]}),
        .\QxDO[1][4] ({\FFxDP_reg[3]_11 [3],\FFxDP_reg[3]_11 [1]}),
        .\QxDO[1][4]_0 ({\FFxDP_reg[2]_10 [3],\FFxDP_reg[2]_10 [1]}),
        .\QxDO[1]_OBUF ({\QxDO[1]_OBUF [6],\QxDO[1]_OBUF [4:3],\QxDO[1]_OBUF [1:0]}),
        .\masked_variant_pipelined_8_staged.Y0_4xDP_reg[0][0] (\masked_variant_pipelined_8_staged.mult_msb_n_21 ),
        .\masked_variant_pipelined_8_staged.Y0_4xDP_reg[1][0] (\masked_variant_pipelined_8_staged.mult_msb_n_23 ),
        .p_0_in2_in(\gen_inner_multipliers_g[1].gen_outer_multipliers_g[0].gf4_mul/p_0_in2_in_13 ),
        .p_0_in2_in_0(\gen_inner_multipliers_g[1].gen_outer_multipliers_g[1].gf4_mul/p_0_in2_in_12 ));
endmodule

(* ORIG_REF_NAME = "gf2_mul" *) 
module gf2_mul__parameterized0
   (D,
    \FFxDP_reg[0][0] ,
    \FFxDP_reg[0][0]_0 );
  output [1:0]D;
  input [1:0]\FFxDP_reg[0][0] ;
  input [1:0]\FFxDP_reg[0][0]_0 ;

  wire [1:0]D;
  wire [1:0]\FFxDP_reg[0][0] ;
  wire [1:0]\FFxDP_reg[0][0]_0 ;

  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT4 #(
    .INIT(16'hA6C0)) 
    \FFxDP[0][0]_i_1 
       (.I0(\FFxDP_reg[0][0] [0]),
        .I1(\FFxDP_reg[0][0] [1]),
        .I2(\FFxDP_reg[0][0]_0 [0]),
        .I3(\FFxDP_reg[0][0]_0 [1]),
        .O(D[0]));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT4 #(
    .INIT(16'hCA60)) 
    \FFxDP[0][1]_i_1 
       (.I0(\FFxDP_reg[0][0] [0]),
        .I1(\FFxDP_reg[0][0] [1]),
        .I2(\FFxDP_reg[0][0]_0 [0]),
        .I3(\FFxDP_reg[0][0]_0 [1]),
        .O(D[1]));
endmodule

(* ORIG_REF_NAME = "gf2_mul" *) 
module gf2_mul__parameterized0_5
   (D,
    \FFxDP_reg[3][0] ,
    \FFxDP_reg[3][0]_0 );
  output [1:0]D;
  input [1:0]\FFxDP_reg[3][0] ;
  input [1:0]\FFxDP_reg[3][0]_0 ;

  wire [1:0]D;
  wire [1:0]\FFxDP_reg[3][0] ;
  wire [1:0]\FFxDP_reg[3][0]_0 ;

  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT4 #(
    .INIT(16'hA6C0)) 
    \FFxDP[3][0]_i_1 
       (.I0(\FFxDP_reg[3][0] [0]),
        .I1(\FFxDP_reg[3][0] [1]),
        .I2(\FFxDP_reg[3][0]_0 [0]),
        .I3(\FFxDP_reg[3][0]_0 [1]),
        .O(D[0]));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT4 #(
    .INIT(16'hCA60)) 
    \FFxDP[3][1]_i_1 
       (.I0(\FFxDP_reg[3][0] [0]),
        .I1(\FFxDP_reg[3][0] [1]),
        .I2(\FFxDP_reg[3][0]_0 [0]),
        .I3(\FFxDP_reg[3][0]_0 [1]),
        .O(D[1]));
endmodule

(* ORIG_REF_NAME = "gf2_mul" *) 
module gf2_mul__parameterized0_6
   (D,
    \FFxDP_reg[0][0] ,
    \FFxDP_reg[0][0]_0 );
  output [1:0]D;
  input [1:0]\FFxDP_reg[0][0] ;
  input [1:0]\FFxDP_reg[0][0]_0 ;

  wire [1:0]D;
  wire [1:0]\FFxDP_reg[0][0] ;
  wire [1:0]\FFxDP_reg[0][0]_0 ;

  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT4 #(
    .INIT(16'hA6C0)) 
    \FFxDP[0][0]_i_1 
       (.I0(\FFxDP_reg[0][0] [0]),
        .I1(\FFxDP_reg[0][0] [1]),
        .I2(\FFxDP_reg[0][0]_0 [0]),
        .I3(\FFxDP_reg[0][0]_0 [1]),
        .O(D[0]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT4 #(
    .INIT(16'hCA60)) 
    \FFxDP[0][1]_i_1 
       (.I0(\FFxDP_reg[0][0] [0]),
        .I1(\FFxDP_reg[0][0] [1]),
        .I2(\FFxDP_reg[0][0]_0 [0]),
        .I3(\FFxDP_reg[0][0]_0 [1]),
        .O(D[1]));
endmodule

(* ORIG_REF_NAME = "gf2_mul" *) 
module gf2_mul__parameterized0_7
   (D,
    \FFxDP_reg[3][0] ,
    \FFxDP_reg[3][0]_0 );
  output [1:0]D;
  input [1:0]\FFxDP_reg[3][0] ;
  input [1:0]\FFxDP_reg[3][0]_0 ;

  wire [1:0]D;
  wire [1:0]\FFxDP_reg[3][0] ;
  wire [1:0]\FFxDP_reg[3][0]_0 ;

  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT4 #(
    .INIT(16'hA6C0)) 
    \FFxDP[3][0]_i_1 
       (.I0(\FFxDP_reg[3][0] [0]),
        .I1(\FFxDP_reg[3][0] [1]),
        .I2(\FFxDP_reg[3][0]_0 [0]),
        .I3(\FFxDP_reg[3][0]_0 [1]),
        .O(D[0]));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT4 #(
    .INIT(16'hCA60)) 
    \FFxDP[3][1]_i_1 
       (.I0(\FFxDP_reg[3][0] [0]),
        .I1(\FFxDP_reg[3][0] [1]),
        .I2(\FFxDP_reg[3][0]_0 [0]),
        .I3(\FFxDP_reg[3][0]_0 [1]),
        .O(D[1]));
endmodule

(* ORIG_REF_NAME = "gf2_mul" *) 
module gf2_mul__parameterized0_8
   (D,
    \FFxDP_reg[0][1] );
  output [1:0]D;
  input [3:0]\FFxDP_reg[0][1] ;

  wire [1:0]D;
  wire [3:0]\FFxDP_reg[0][1] ;

  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'hA6C0)) 
    \FFxDP[0][0]_i_1 
       (.I0(\FFxDP_reg[0][1] [0]),
        .I1(\FFxDP_reg[0][1] [1]),
        .I2(\FFxDP_reg[0][1] [2]),
        .I3(\FFxDP_reg[0][1] [3]),
        .O(D[0]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'hCA60)) 
    \FFxDP[0][1]_i_1 
       (.I0(\FFxDP_reg[0][1] [0]),
        .I1(\FFxDP_reg[0][1] [1]),
        .I2(\FFxDP_reg[0][1] [2]),
        .I3(\FFxDP_reg[0][1] [3]),
        .O(D[1]));
endmodule

(* ORIG_REF_NAME = "gf2_mul" *) 
module gf2_mul__parameterized0_9
   (D,
    \FFxDP_reg[3][1] );
  output [1:0]D;
  input [3:0]\FFxDP_reg[3][1] ;

  wire [1:0]D;
  wire [3:0]\FFxDP_reg[3][1] ;

  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT4 #(
    .INIT(16'hA6C0)) 
    \FFxDP[3][0]_i_1 
       (.I0(\FFxDP_reg[3][1] [0]),
        .I1(\FFxDP_reg[3][1] [1]),
        .I2(\FFxDP_reg[3][1] [2]),
        .I3(\FFxDP_reg[3][1] [3]),
        .O(D[0]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT4 #(
    .INIT(16'hCA60)) 
    \FFxDP[3][1]_i_1 
       (.I0(\FFxDP_reg[3][1] [0]),
        .I1(\FFxDP_reg[3][1] [1]),
        .I2(\FFxDP_reg[3][1] [2]),
        .I3(\FFxDP_reg[3][1] [3]),
        .O(D[1]));
endmodule

module inverter
   (D,
    \Zmul2xDI[0][3] ,
    \masked_variant_pipelined_8_staged.Y0_4xDP_reg[1][1] ,
    \masked_variant_pipelined_8_staged.Y1_4xDP_reg[1][1] ,
    \Zmul3xDI[0][3] ,
    \Zmul2xDI[0][3]_0 ,
    \masked_variant_pipelined_8_staged.Y1_4xDP_reg[0][1] ,
    \Zmul3xDI[0][3]_0 ,
    Q,
    \FFxDP_reg[2][3] ,
    p_0_in2_in,
    \FFxDP_reg[1][1] ,
    \FFxDP_reg[1][0] ,
    \FFxDP_reg[3][3] ,
    \FFxDP_reg[1][3] ,
    p_0_in2_in_0,
    \FFxDP_reg[3][3]_0 ,
    \FFxDP_reg[1][1]_0 ,
    p_0_in2_in_1,
    \FFxDP_reg[1][1]_1 ,
    \FFxDP_reg[0][1] ,
    p_0_in2_in_2,
    \FFxDP_reg[0][1]_0 ,
    \FFxDP_reg[1][0]_0 ,
    \FFxDP_reg[1][2] ,
    \FFxDP_reg[1][3]_0 ,
    \FFxDP_reg[1][2]_0 ,
    \FFxDP_reg[1][3]_1 ,
    CLK,
    \shared_sel_pipelined_4staged.AxDP_reg[1][1]_0 ,
    \shared_sel_pipelined_4staged.AxDP_reg[0][1]_0 ,
    \FFxDP_reg[1][1]_2 ,
    \FFxDP_reg[1][0]_1 ,
    \FFxDP_reg[1][1]_3 ,
    \FFxDP_reg[1][0]_2 ,
    \FFxDP_reg[1][1]_4 ,
    \FFxDP_reg[1][0]_3 );
  output [3:0]D;
  output [3:0]\Zmul2xDI[0][3] ;
  output [3:0]\masked_variant_pipelined_8_staged.Y0_4xDP_reg[1][1] ;
  output [3:0]\masked_variant_pipelined_8_staged.Y1_4xDP_reg[1][1] ;
  output [3:0]\Zmul3xDI[0][3] ;
  output [3:0]\Zmul2xDI[0][3]_0 ;
  output [3:0]\masked_variant_pipelined_8_staged.Y1_4xDP_reg[0][1] ;
  output [3:0]\Zmul3xDI[0][3]_0 ;
  input [3:0]Q;
  input \FFxDP_reg[2][3] ;
  input p_0_in2_in;
  input \FFxDP_reg[1][1] ;
  input \FFxDP_reg[1][0] ;
  input [3:0]\FFxDP_reg[3][3] ;
  input \FFxDP_reg[1][3] ;
  input p_0_in2_in_0;
  input [3:0]\FFxDP_reg[3][3]_0 ;
  input \FFxDP_reg[1][1]_0 ;
  input p_0_in2_in_1;
  input \FFxDP_reg[1][1]_1 ;
  input \FFxDP_reg[0][1] ;
  input p_0_in2_in_2;
  input [3:0]\FFxDP_reg[0][1]_0 ;
  input \FFxDP_reg[1][0]_0 ;
  input \FFxDP_reg[1][2] ;
  input \FFxDP_reg[1][3]_0 ;
  input \FFxDP_reg[1][2]_0 ;
  input \FFxDP_reg[1][3]_1 ;
  input CLK;
  input [3:0]\shared_sel_pipelined_4staged.AxDP_reg[1][1]_0 ;
  input [3:0]\shared_sel_pipelined_4staged.AxDP_reg[0][1]_0 ;
  input \FFxDP_reg[1][1]_2 ;
  input \FFxDP_reg[1][0]_1 ;
  input \FFxDP_reg[1][1]_3 ;
  input \FFxDP_reg[1][0]_2 ;
  input \FFxDP_reg[1][1]_4 ;
  input \FFxDP_reg[1][0]_3 ;

  wire \<const0> ;
  wire \<const1> ;
  wire CLK;
  wire [0:0]\CxD[0] ;
  wire [0:0]\CxD[1] ;
  wire [3:0]D;
  wire [1:0]\ExD[0]_13 ;
  wire [1:0]\ExD[1]_12 ;
  wire \FFxDP_reg[0][1] ;
  wire [3:0]\FFxDP_reg[0][1]_0 ;
  wire [1:0]\FFxDP_reg[0]_11 ;
  wire [1:0]\FFxDP_reg[0]_3 ;
  wire \FFxDP_reg[1][0] ;
  wire \FFxDP_reg[1][0]_0 ;
  wire \FFxDP_reg[1][0]_1 ;
  wire \FFxDP_reg[1][0]_2 ;
  wire \FFxDP_reg[1][0]_3 ;
  wire \FFxDP_reg[1][1] ;
  wire \FFxDP_reg[1][1]_0 ;
  wire \FFxDP_reg[1][1]_1 ;
  wire \FFxDP_reg[1][1]_2 ;
  wire \FFxDP_reg[1][1]_3 ;
  wire \FFxDP_reg[1][1]_4 ;
  wire \FFxDP_reg[1][2] ;
  wire \FFxDP_reg[1][2]_0 ;
  wire \FFxDP_reg[1][3] ;
  wire \FFxDP_reg[1][3]_0 ;
  wire \FFxDP_reg[1][3]_1 ;
  wire [1:0]\FFxDP_reg[1]_10 ;
  wire [1:0]\FFxDP_reg[1]_2 ;
  wire \FFxDP_reg[2][3] ;
  wire [1:0]\FFxDP_reg[2]_1 ;
  wire [1:0]\FFxDP_reg[2]_9 ;
  wire [3:0]\FFxDP_reg[3][3] ;
  wire [3:0]\FFxDP_reg[3][3]_0 ;
  wire [1:0]\FFxDP_reg[3]_0 ;
  wire [1:0]\FFxDP_reg[3]_8 ;
  wire [3:0]Q;
  wire QxDO122_out__0__0;
  wire QxDO122_out__1__0;
  wire QxDO122_out__2__0;
  wire QxDO122_out__3;
  wire QxDO122_out__3__0;
  wire QxDO122_out__4;
  wire QxDO122_out__5;
  wire QxDO122_out__6;
  wire QxDO124_out__0__0;
  wire QxDO124_out__1__0;
  wire QxDO124_out__2__0;
  wire QxDO124_out__3;
  wire QxDO124_out__3__0;
  wire QxDO124_out__4;
  wire QxDO124_out__5;
  wire QxDO124_out__6;
  wire [3:0]\Zmul2xDI[0][3] ;
  wire [3:0]\Zmul2xDI[0][3]_0 ;
  wire [3:0]\Zmul3xDI[0][3] ;
  wire [3:0]\Zmul3xDI[0][3]_0 ;
  wire [3:0]\masked_variant_pipelined_8_staged.Y0_4xDP_reg[1][1] ;
  wire [3:0]\masked_variant_pipelined_8_staged.Y1_4xDP_reg[0][1] ;
  wire [3:0]\masked_variant_pipelined_8_staged.Y1_4xDP_reg[1][1] ;
  wire p_0_in2_in;
  wire p_0_in2_in_0;
  wire p_0_in2_in_1;
  wire p_0_in2_in_2;
  wire [1:0]\shared_sel_pipelined_4staged.AxDP_reg[0] ;
  wire [3:0]\shared_sel_pipelined_4staged.AxDP_reg[0][1]_0 ;
  wire [1:0]\shared_sel_pipelined_4staged.AxDP_reg[1] ;
  wire [3:0]\shared_sel_pipelined_4staged.AxDP_reg[1][1]_0 ;
  wire [1:0]\shared_sel_pipelined_4staged.BxDP_reg[0] ;
  wire [1:0]\shared_sel_pipelined_4staged.BxDP_reg[1] ;
  wire \shared_sel_pipelined_4staged.CxDP_reg[0]0 ;
  wire \shared_sel_pipelined_4staged.CxDP_reg[1]0 ;
  wire \shared_sel_pipelined_4staged.CxDP_reg_n_0_[0][0] ;
  wire \shared_sel_pipelined_4staged.CxDP_reg_n_0_[0][1] ;
  wire \shared_sel_pipelined_4staged.CxDP_reg_n_0_[1][0] ;
  wire \shared_sel_pipelined_4staged.CxDP_reg_n_0_[1][1] ;
  wire \shared_sel_pipelined_4staged.ExDP_reg_n_0_[0][0] ;
  wire \shared_sel_pipelined_4staged.ExDP_reg_n_0_[0][1] ;
  wire \shared_sel_pipelined_4staged.ExDP_reg_n_0_[1][0] ;
  wire \shared_sel_pipelined_4staged.ExDP_reg_n_0_[1][1] ;
  wire \shared_sel_pipelined_4staged.pipelinedAxDP_reg_n_0_[0][0] ;
  wire \shared_sel_pipelined_4staged.pipelinedAxDP_reg_n_0_[0][1] ;
  wire \shared_sel_pipelined_4staged.pipelinedAxDP_reg_n_0_[1][0] ;
  wire \shared_sel_pipelined_4staged.pipelinedAxDP_reg_n_0_[1][1] ;
  wire \shared_sel_pipelined_4staged.pipelinedBxDP_reg_n_0_[0][0] ;
  wire \shared_sel_pipelined_4staged.pipelinedBxDP_reg_n_0_[0][1] ;
  wire \shared_sel_pipelined_4staged.pipelinedBxDP_reg_n_0_[1][0] ;
  wire \shared_sel_pipelined_4staged.pipelinedBxDP_reg_n_0_[1][1] ;

  GND GND
       (.G(\<const0> ));
  VCC VCC
       (.P(\<const1> ));
  FDRE #(
    .INIT(1'b0)) 
    \shared_sel_pipelined_4staged.AxDP_reg[0][0] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\shared_sel_pipelined_4staged.AxDP_reg[0][1]_0 [2]),
        .Q(\shared_sel_pipelined_4staged.AxDP_reg[0] [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \shared_sel_pipelined_4staged.AxDP_reg[0][1] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\shared_sel_pipelined_4staged.AxDP_reg[0][1]_0 [3]),
        .Q(\shared_sel_pipelined_4staged.AxDP_reg[0] [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \shared_sel_pipelined_4staged.AxDP_reg[1][0] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\shared_sel_pipelined_4staged.AxDP_reg[1][1]_0 [2]),
        .Q(\shared_sel_pipelined_4staged.AxDP_reg[1] [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \shared_sel_pipelined_4staged.AxDP_reg[1][1] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\shared_sel_pipelined_4staged.AxDP_reg[1][1]_0 [3]),
        .Q(\shared_sel_pipelined_4staged.AxDP_reg[1] [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \shared_sel_pipelined_4staged.BxDP_reg[0][0] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\shared_sel_pipelined_4staged.AxDP_reg[0][1]_0 [0]),
        .Q(\shared_sel_pipelined_4staged.BxDP_reg[0] [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \shared_sel_pipelined_4staged.BxDP_reg[0][1] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\shared_sel_pipelined_4staged.AxDP_reg[0][1]_0 [1]),
        .Q(\shared_sel_pipelined_4staged.BxDP_reg[0] [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \shared_sel_pipelined_4staged.BxDP_reg[1][0] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\shared_sel_pipelined_4staged.AxDP_reg[1][1]_0 [0]),
        .Q(\shared_sel_pipelined_4staged.BxDP_reg[1] [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \shared_sel_pipelined_4staged.BxDP_reg[1][1] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\shared_sel_pipelined_4staged.AxDP_reg[1][1]_0 [1]),
        .Q(\shared_sel_pipelined_4staged.BxDP_reg[1] [1]),
        .R(\<const0> ));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    \shared_sel_pipelined_4staged.CxDP[0][0]_i_1 
       (.I0(\shared_sel_pipelined_4staged.AxDP_reg[0][1]_0 [3]),
        .I1(\shared_sel_pipelined_4staged.AxDP_reg[0][1]_0 [1]),
        .I2(\shared_sel_pipelined_4staged.AxDP_reg[0][1]_0 [2]),
        .I3(\shared_sel_pipelined_4staged.AxDP_reg[0][1]_0 [0]),
        .O(\CxD[0] ));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \shared_sel_pipelined_4staged.CxDP[0][1]_i_1 
       (.I0(\shared_sel_pipelined_4staged.AxDP_reg[0][1]_0 [1]),
        .I1(\shared_sel_pipelined_4staged.AxDP_reg[0][1]_0 [3]),
        .O(\shared_sel_pipelined_4staged.CxDP_reg[0]0 ));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    \shared_sel_pipelined_4staged.CxDP[1][0]_i_1 
       (.I0(\shared_sel_pipelined_4staged.AxDP_reg[1][1]_0 [3]),
        .I1(\shared_sel_pipelined_4staged.AxDP_reg[1][1]_0 [1]),
        .I2(\shared_sel_pipelined_4staged.AxDP_reg[1][1]_0 [2]),
        .I3(\shared_sel_pipelined_4staged.AxDP_reg[1][1]_0 [0]),
        .O(\CxD[1] ));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \shared_sel_pipelined_4staged.CxDP[1][1]_i_1 
       (.I0(\shared_sel_pipelined_4staged.AxDP_reg[1][1]_0 [1]),
        .I1(\shared_sel_pipelined_4staged.AxDP_reg[1][1]_0 [3]),
        .O(\shared_sel_pipelined_4staged.CxDP_reg[1]0 ));
  FDRE #(
    .INIT(1'b0)) 
    \shared_sel_pipelined_4staged.CxDP_reg[0][0] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\CxD[0] ),
        .Q(\shared_sel_pipelined_4staged.CxDP_reg_n_0_[0][0] ),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \shared_sel_pipelined_4staged.CxDP_reg[0][1] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\shared_sel_pipelined_4staged.CxDP_reg[0]0 ),
        .Q(\shared_sel_pipelined_4staged.CxDP_reg_n_0_[0][1] ),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \shared_sel_pipelined_4staged.CxDP_reg[1][0] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\CxD[1] ),
        .Q(\shared_sel_pipelined_4staged.CxDP_reg_n_0_[1][0] ),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \shared_sel_pipelined_4staged.CxDP_reg[1][1] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\shared_sel_pipelined_4staged.CxDP_reg[1]0 ),
        .Q(\shared_sel_pipelined_4staged.CxDP_reg_n_0_[1][1] ),
        .R(\<const0> ));
  LUT3 #(
    .INIT(8'h96)) 
    \shared_sel_pipelined_4staged.ExDP[0][0]_i_1 
       (.I0(\FFxDP_reg[0]_3 [1]),
        .I1(\FFxDP_reg[1]_2 [1]),
        .I2(\shared_sel_pipelined_4staged.CxDP_reg_n_0_[0][1] ),
        .O(\ExD[0]_13 [0]));
  LUT3 #(
    .INIT(8'h96)) 
    \shared_sel_pipelined_4staged.ExDP[0][1]_i_1 
       (.I0(\FFxDP_reg[0]_3 [0]),
        .I1(\FFxDP_reg[1]_2 [0]),
        .I2(\shared_sel_pipelined_4staged.CxDP_reg_n_0_[0][0] ),
        .O(\ExD[0]_13 [1]));
  LUT3 #(
    .INIT(8'h96)) 
    \shared_sel_pipelined_4staged.ExDP[1][0]_i_1 
       (.I0(\FFxDP_reg[2]_1 [1]),
        .I1(\FFxDP_reg[3]_0 [1]),
        .I2(\shared_sel_pipelined_4staged.CxDP_reg_n_0_[1][1] ),
        .O(\ExD[1]_12 [0]));
  LUT3 #(
    .INIT(8'h96)) 
    \shared_sel_pipelined_4staged.ExDP[1][1]_i_1 
       (.I0(\FFxDP_reg[2]_1 [0]),
        .I1(\FFxDP_reg[3]_0 [0]),
        .I2(\shared_sel_pipelined_4staged.CxDP_reg_n_0_[1][0] ),
        .O(\ExD[1]_12 [1]));
  FDRE #(
    .INIT(1'b0)) 
    \shared_sel_pipelined_4staged.ExDP_reg[0][0] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\ExD[0]_13 [0]),
        .Q(\shared_sel_pipelined_4staged.ExDP_reg_n_0_[0][0] ),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \shared_sel_pipelined_4staged.ExDP_reg[0][1] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\ExD[0]_13 [1]),
        .Q(\shared_sel_pipelined_4staged.ExDP_reg_n_0_[0][1] ),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \shared_sel_pipelined_4staged.ExDP_reg[1][0] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\ExD[1]_12 [0]),
        .Q(\shared_sel_pipelined_4staged.ExDP_reg_n_0_[1][0] ),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \shared_sel_pipelined_4staged.ExDP_reg[1][1] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\ExD[1]_12 [1]),
        .Q(\shared_sel_pipelined_4staged.ExDP_reg_n_0_[1][1] ),
        .R(\<const0> ));
  shared_mul_gf2 \shared_sel_pipelined_4staged.a_mul_b 
       (.CLK(CLK),
        .\FFxDP_reg[0][1]_0 (\FFxDP_reg[0]_3 ),
        .\FFxDP_reg[0][1]_1 (\shared_sel_pipelined_4staged.AxDP_reg[0][1]_0 ),
        .\FFxDP_reg[1][0]_0 (\FFxDP_reg[1][0]_1 ),
        .\FFxDP_reg[1][1]_0 (\FFxDP_reg[1]_2 ),
        .\FFxDP_reg[1][1]_1 (\FFxDP_reg[1][1]_2 ),
        .\FFxDP_reg[2][1]_0 (\FFxDP_reg[2]_1 ),
        .\FFxDP_reg[3][1]_0 (\shared_sel_pipelined_4staged.AxDP_reg[1][1]_0 ),
        .Q(\FFxDP_reg[3]_0 ));
  shared_mul_gf2_3 \shared_sel_pipelined_4staged.a_mul_e 
       (.CLK(CLK),
        .D(D),
        .\FFxDP_reg[0][0]_0 ({\shared_sel_pipelined_4staged.ExDP_reg_n_0_[0][1] ,\shared_sel_pipelined_4staged.ExDP_reg_n_0_[0][0] }),
        .\FFxDP_reg[0][0]_1 ({\shared_sel_pipelined_4staged.pipelinedAxDP_reg_n_0_[0][1] ,\shared_sel_pipelined_4staged.pipelinedAxDP_reg_n_0_[0][0] }),
        .\FFxDP_reg[0][1]_0 (\FFxDP_reg[0][1] ),
        .\FFxDP_reg[0][1]_1 (\FFxDP_reg[0][1]_0 ),
        .\FFxDP_reg[1][0]_0 (\FFxDP_reg[1][0] ),
        .\FFxDP_reg[1][0]_1 (\FFxDP_reg[1][0]_0 ),
        .\FFxDP_reg[1][0]_2 (\FFxDP_reg[1][0]_2 ),
        .\FFxDP_reg[1][1]_0 (\FFxDP_reg[1][1] ),
        .\FFxDP_reg[1][1]_1 (\FFxDP_reg[1][1]_0 ),
        .\FFxDP_reg[1][1]_2 (\FFxDP_reg[1][1]_1 ),
        .\FFxDP_reg[1][1]_3 (\FFxDP_reg[0]_11 ),
        .\FFxDP_reg[1][1]_4 (\FFxDP_reg[1]_10 ),
        .\FFxDP_reg[1][1]_5 (\FFxDP_reg[1][1]_3 ),
        .\FFxDP_reg[1][2] (\FFxDP_reg[1][2] ),
        .\FFxDP_reg[1][2]_0 (\FFxDP_reg[1][2]_0 ),
        .\FFxDP_reg[1][3] (\FFxDP_reg[1][3] ),
        .\FFxDP_reg[1][3]_0 (\FFxDP_reg[1][3]_0 ),
        .\FFxDP_reg[1][3]_1 (\FFxDP_reg[1][3]_1 ),
        .\FFxDP_reg[2][3] (\FFxDP_reg[2][3] ),
        .\FFxDP_reg[3][0]_0 ({\shared_sel_pipelined_4staged.pipelinedAxDP_reg_n_0_[1][1] ,\shared_sel_pipelined_4staged.pipelinedAxDP_reg_n_0_[1][0] }),
        .\FFxDP_reg[3][0]_1 ({\shared_sel_pipelined_4staged.ExDP_reg_n_0_[1][1] ,\shared_sel_pipelined_4staged.ExDP_reg_n_0_[1][0] }),
        .\FFxDP_reg[3][3] (\FFxDP_reg[3][3] ),
        .\FFxDP_reg[3][3]_0 (\FFxDP_reg[3][3]_0 ),
        .\FFxDP_reg[3][3]_1 (\FFxDP_reg[2]_9 ),
        .\FFxDP_reg[3][3]_2 (\FFxDP_reg[3]_8 ),
        .Q(Q),
        .QxDO122_out__0__0(QxDO122_out__0__0),
        .QxDO122_out__1__0(QxDO122_out__1__0),
        .QxDO122_out__2__0(QxDO122_out__2__0),
        .QxDO122_out__3(QxDO122_out__3),
        .QxDO122_out__3__0(QxDO122_out__3__0),
        .QxDO122_out__4(QxDO122_out__4),
        .QxDO122_out__5(QxDO122_out__5),
        .QxDO122_out__6(QxDO122_out__6),
        .QxDO124_out__0__0(QxDO124_out__0__0),
        .QxDO124_out__1__0(QxDO124_out__1__0),
        .QxDO124_out__2__0(QxDO124_out__2__0),
        .QxDO124_out__3(QxDO124_out__3),
        .QxDO124_out__3__0(QxDO124_out__3__0),
        .QxDO124_out__4(QxDO124_out__4),
        .QxDO124_out__5(QxDO124_out__5),
        .QxDO124_out__6(QxDO124_out__6),
        .\Zmul2xDI[0][3] (\Zmul2xDI[0][3] ),
        .\Zmul2xDI[0][3]_0 (\Zmul2xDI[0][3]_0 ),
        .\Zmul3xDI[0][3] (\Zmul3xDI[0][3] ),
        .\Zmul3xDI[0][3]_0 (\Zmul3xDI[0][3]_0 ),
        .\masked_variant_pipelined_8_staged.Y0_4xDP_reg[1][1] (\masked_variant_pipelined_8_staged.Y0_4xDP_reg[1][1] ),
        .\masked_variant_pipelined_8_staged.Y1_4xDP_reg[0][1] (\masked_variant_pipelined_8_staged.Y1_4xDP_reg[0][1] ),
        .\masked_variant_pipelined_8_staged.Y1_4xDP_reg[1][1] (\masked_variant_pipelined_8_staged.Y1_4xDP_reg[1][1] ),
        .p_0_in2_in(p_0_in2_in),
        .p_0_in2_in_0(p_0_in2_in_0),
        .p_0_in2_in_1(p_0_in2_in_1),
        .p_0_in2_in_2(p_0_in2_in_2));
  shared_mul_gf2_4 \shared_sel_pipelined_4staged.b_mul_e 
       (.CLK(CLK),
        .\FFxDP_reg[0][0]_0 ({\shared_sel_pipelined_4staged.ExDP_reg_n_0_[0][1] ,\shared_sel_pipelined_4staged.ExDP_reg_n_0_[0][0] }),
        .\FFxDP_reg[0][0]_1 ({\shared_sel_pipelined_4staged.pipelinedBxDP_reg_n_0_[0][1] ,\shared_sel_pipelined_4staged.pipelinedBxDP_reg_n_0_[0][0] }),
        .\FFxDP_reg[0][2] (Q[3:2]),
        .\FFxDP_reg[1][0]_0 (\FFxDP_reg[1][0]_3 ),
        .\FFxDP_reg[1][1]_0 (\FFxDP_reg[1]_10 ),
        .\FFxDP_reg[1][1]_1 (\FFxDP_reg[1][1]_4 ),
        .\FFxDP_reg[1][2] (\FFxDP_reg[3][3] [3:2]),
        .\FFxDP_reg[1][2]_0 (\FFxDP_reg[3][3]_0 [3:2]),
        .\FFxDP_reg[2][1]_0 (\FFxDP_reg[2]_9 ),
        .\FFxDP_reg[2][2] (\FFxDP_reg[0][1]_0 [3:2]),
        .\FFxDP_reg[3][0]_0 ({\shared_sel_pipelined_4staged.pipelinedBxDP_reg_n_0_[1][1] ,\shared_sel_pipelined_4staged.pipelinedBxDP_reg_n_0_[1][0] }),
        .\FFxDP_reg[3][0]_1 ({\shared_sel_pipelined_4staged.ExDP_reg_n_0_[1][1] ,\shared_sel_pipelined_4staged.ExDP_reg_n_0_[1][0] }),
        .\FFxDP_reg[3][1]_0 (\FFxDP_reg[3]_8 ),
        .Q(\FFxDP_reg[0]_11 ),
        .QxDO122_out__0__0(QxDO122_out__0__0),
        .QxDO122_out__1__0(QxDO122_out__1__0),
        .QxDO122_out__2__0(QxDO122_out__2__0),
        .QxDO122_out__3(QxDO122_out__3),
        .QxDO122_out__3__0(QxDO122_out__3__0),
        .QxDO122_out__4(QxDO122_out__4),
        .QxDO122_out__5(QxDO122_out__5),
        .QxDO122_out__6(QxDO122_out__6),
        .QxDO124_out__0__0(QxDO124_out__0__0),
        .QxDO124_out__1__0(QxDO124_out__1__0),
        .QxDO124_out__2__0(QxDO124_out__2__0),
        .QxDO124_out__3(QxDO124_out__3),
        .QxDO124_out__3__0(QxDO124_out__3__0),
        .QxDO124_out__4(QxDO124_out__4),
        .QxDO124_out__5(QxDO124_out__5),
        .QxDO124_out__6(QxDO124_out__6));
  FDRE #(
    .INIT(1'b0)) 
    \shared_sel_pipelined_4staged.pipelinedAxDP_reg[0][0] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\shared_sel_pipelined_4staged.AxDP_reg[0] [0]),
        .Q(\shared_sel_pipelined_4staged.pipelinedAxDP_reg_n_0_[0][0] ),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \shared_sel_pipelined_4staged.pipelinedAxDP_reg[0][1] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\shared_sel_pipelined_4staged.AxDP_reg[0] [1]),
        .Q(\shared_sel_pipelined_4staged.pipelinedAxDP_reg_n_0_[0][1] ),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \shared_sel_pipelined_4staged.pipelinedAxDP_reg[1][0] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\shared_sel_pipelined_4staged.AxDP_reg[1] [0]),
        .Q(\shared_sel_pipelined_4staged.pipelinedAxDP_reg_n_0_[1][0] ),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \shared_sel_pipelined_4staged.pipelinedAxDP_reg[1][1] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\shared_sel_pipelined_4staged.AxDP_reg[1] [1]),
        .Q(\shared_sel_pipelined_4staged.pipelinedAxDP_reg_n_0_[1][1] ),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \shared_sel_pipelined_4staged.pipelinedBxDP_reg[0][0] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\shared_sel_pipelined_4staged.BxDP_reg[0] [0]),
        .Q(\shared_sel_pipelined_4staged.pipelinedBxDP_reg_n_0_[0][0] ),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \shared_sel_pipelined_4staged.pipelinedBxDP_reg[0][1] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\shared_sel_pipelined_4staged.BxDP_reg[0] [1]),
        .Q(\shared_sel_pipelined_4staged.pipelinedBxDP_reg_n_0_[0][1] ),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \shared_sel_pipelined_4staged.pipelinedBxDP_reg[1][0] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\shared_sel_pipelined_4staged.BxDP_reg[1] [0]),
        .Q(\shared_sel_pipelined_4staged.pipelinedBxDP_reg_n_0_[1][0] ),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \shared_sel_pipelined_4staged.pipelinedBxDP_reg[1][1] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\shared_sel_pipelined_4staged.BxDP_reg[1] [1]),
        .Q(\shared_sel_pipelined_4staged.pipelinedBxDP_reg_n_0_[1][1] ),
        .R(\<const0> ));
endmodule

module lin_map
   (D,
    \masked_variant_pipelined_8_staged.mappedxDP_reg[0][7] ,
    \masked_variant_pipelined_8_staged.mappedxDP_reg[0][7]_0 ,
    \masked_variant_pipelined_8_staged.mappedxDP_reg[0][7]_1 ,
    \masked_variant_pipelined_8_staged.mappedxDP_reg[0][7]_2 ,
    \masked_variant_pipelined_8_staged.mappedxDP_reg[0][7]_3 ,
    \masked_variant_pipelined_8_staged.mappedxDP_reg[0][7]_4 ,
    \masked_variant_pipelined_8_staged.mappedxDP_reg[0][3] ,
    \masked_variant_pipelined_8_staged.mappedxDP_reg[0][0] );
  output [3:0]D;
  input \masked_variant_pipelined_8_staged.mappedxDP_reg[0][7] ;
  input \masked_variant_pipelined_8_staged.mappedxDP_reg[0][7]_0 ;
  input \masked_variant_pipelined_8_staged.mappedxDP_reg[0][7]_1 ;
  input \masked_variant_pipelined_8_staged.mappedxDP_reg[0][7]_2 ;
  input \masked_variant_pipelined_8_staged.mappedxDP_reg[0][7]_3 ;
  input \masked_variant_pipelined_8_staged.mappedxDP_reg[0][7]_4 ;
  input \masked_variant_pipelined_8_staged.mappedxDP_reg[0][3] ;
  input \masked_variant_pipelined_8_staged.mappedxDP_reg[0][0] ;

  wire [3:0]D;
  wire \masked_variant_pipelined_8_staged.mappedxDP_reg[0][0] ;
  wire \masked_variant_pipelined_8_staged.mappedxDP_reg[0][3] ;
  wire \masked_variant_pipelined_8_staged.mappedxDP_reg[0][7] ;
  wire \masked_variant_pipelined_8_staged.mappedxDP_reg[0][7]_0 ;
  wire \masked_variant_pipelined_8_staged.mappedxDP_reg[0][7]_1 ;
  wire \masked_variant_pipelined_8_staged.mappedxDP_reg[0][7]_2 ;
  wire \masked_variant_pipelined_8_staged.mappedxDP_reg[0][7]_3 ;
  wire \masked_variant_pipelined_8_staged.mappedxDP_reg[0][7]_4 ;

  LUT6 #(
    .INIT(64'h6996966996696996)) 
    \__2/i_ 
       (.I0(\masked_variant_pipelined_8_staged.mappedxDP_reg[0][7] ),
        .I1(\masked_variant_pipelined_8_staged.mappedxDP_reg[0][7]_0 ),
        .I2(\masked_variant_pipelined_8_staged.mappedxDP_reg[0][7]_1 ),
        .I3(\masked_variant_pipelined_8_staged.mappedxDP_reg[0][7]_2 ),
        .I4(\masked_variant_pipelined_8_staged.mappedxDP_reg[0][7]_3 ),
        .I5(\masked_variant_pipelined_8_staged.mappedxDP_reg[0][7]_4 ),
        .O(D[3]));
  LUT4 #(
    .INIT(16'h6996)) 
    \__5/i_ 
       (.I0(\masked_variant_pipelined_8_staged.mappedxDP_reg[0][7]_3 ),
        .I1(\masked_variant_pipelined_8_staged.mappedxDP_reg[0][7] ),
        .I2(\masked_variant_pipelined_8_staged.mappedxDP_reg[0][7]_0 ),
        .I3(\masked_variant_pipelined_8_staged.mappedxDP_reg[0][7]_1 ),
        .O(D[2]));
  LUT5 #(
    .INIT(32'h96696996)) 
    \__7/i_ 
       (.I0(\masked_variant_pipelined_8_staged.mappedxDP_reg[0][3] ),
        .I1(\masked_variant_pipelined_8_staged.mappedxDP_reg[0][7]_1 ),
        .I2(\masked_variant_pipelined_8_staged.mappedxDP_reg[0][7]_0 ),
        .I3(\masked_variant_pipelined_8_staged.mappedxDP_reg[0][7]_4 ),
        .I4(\masked_variant_pipelined_8_staged.mappedxDP_reg[0][0] ),
        .O(D[1]));
  LUT5 #(
    .INIT(32'h96696996)) 
    \__9/i_ 
       (.I0(\masked_variant_pipelined_8_staged.mappedxDP_reg[0][0] ),
        .I1(\masked_variant_pipelined_8_staged.mappedxDP_reg[0][7]_1 ),
        .I2(\masked_variant_pipelined_8_staged.mappedxDP_reg[0][7]_2 ),
        .I3(\masked_variant_pipelined_8_staged.mappedxDP_reg[0][7]_0 ),
        .I4(\masked_variant_pipelined_8_staged.mappedxDP_reg[0][7] ),
        .O(D[0]));
endmodule

(* ORIG_REF_NAME = "lin_map" *) 
module lin_map_0
   (D,
    \masked_variant_pipelined_8_staged.mappedxDP_reg[1][7] ,
    \masked_variant_pipelined_8_staged.mappedxDP_reg[1][7]_0 ,
    \masked_variant_pipelined_8_staged.mappedxDP_reg[1][7]_1 ,
    \masked_variant_pipelined_8_staged.mappedxDP_reg[1][7]_2 ,
    \masked_variant_pipelined_8_staged.mappedxDP_reg[1][7]_3 ,
    \masked_variant_pipelined_8_staged.mappedxDP_reg[1][7]_4 ,
    \masked_variant_pipelined_8_staged.mappedxDP_reg[1][3] ,
    \masked_variant_pipelined_8_staged.mappedxDP_reg[1][0] );
  output [3:0]D;
  input \masked_variant_pipelined_8_staged.mappedxDP_reg[1][7] ;
  input \masked_variant_pipelined_8_staged.mappedxDP_reg[1][7]_0 ;
  input \masked_variant_pipelined_8_staged.mappedxDP_reg[1][7]_1 ;
  input \masked_variant_pipelined_8_staged.mappedxDP_reg[1][7]_2 ;
  input \masked_variant_pipelined_8_staged.mappedxDP_reg[1][7]_3 ;
  input \masked_variant_pipelined_8_staged.mappedxDP_reg[1][7]_4 ;
  input \masked_variant_pipelined_8_staged.mappedxDP_reg[1][3] ;
  input \masked_variant_pipelined_8_staged.mappedxDP_reg[1][0] ;

  wire [3:0]D;
  wire \masked_variant_pipelined_8_staged.mappedxDP_reg[1][0] ;
  wire \masked_variant_pipelined_8_staged.mappedxDP_reg[1][3] ;
  wire \masked_variant_pipelined_8_staged.mappedxDP_reg[1][7] ;
  wire \masked_variant_pipelined_8_staged.mappedxDP_reg[1][7]_0 ;
  wire \masked_variant_pipelined_8_staged.mappedxDP_reg[1][7]_1 ;
  wire \masked_variant_pipelined_8_staged.mappedxDP_reg[1][7]_2 ;
  wire \masked_variant_pipelined_8_staged.mappedxDP_reg[1][7]_3 ;
  wire \masked_variant_pipelined_8_staged.mappedxDP_reg[1][7]_4 ;

  LUT6 #(
    .INIT(64'h6996966996696996)) 
    \__2/i_ 
       (.I0(\masked_variant_pipelined_8_staged.mappedxDP_reg[1][7] ),
        .I1(\masked_variant_pipelined_8_staged.mappedxDP_reg[1][7]_0 ),
        .I2(\masked_variant_pipelined_8_staged.mappedxDP_reg[1][7]_1 ),
        .I3(\masked_variant_pipelined_8_staged.mappedxDP_reg[1][7]_2 ),
        .I4(\masked_variant_pipelined_8_staged.mappedxDP_reg[1][7]_3 ),
        .I5(\masked_variant_pipelined_8_staged.mappedxDP_reg[1][7]_4 ),
        .O(D[3]));
  LUT4 #(
    .INIT(16'h6996)) 
    \__5/i_ 
       (.I0(\masked_variant_pipelined_8_staged.mappedxDP_reg[1][7]_3 ),
        .I1(\masked_variant_pipelined_8_staged.mappedxDP_reg[1][7] ),
        .I2(\masked_variant_pipelined_8_staged.mappedxDP_reg[1][7]_0 ),
        .I3(\masked_variant_pipelined_8_staged.mappedxDP_reg[1][7]_1 ),
        .O(D[2]));
  LUT5 #(
    .INIT(32'h96696996)) 
    \__7/i_ 
       (.I0(\masked_variant_pipelined_8_staged.mappedxDP_reg[1][3] ),
        .I1(\masked_variant_pipelined_8_staged.mappedxDP_reg[1][7]_1 ),
        .I2(\masked_variant_pipelined_8_staged.mappedxDP_reg[1][7]_0 ),
        .I3(\masked_variant_pipelined_8_staged.mappedxDP_reg[1][7]_4 ),
        .I4(\masked_variant_pipelined_8_staged.mappedxDP_reg[1][0] ),
        .O(D[1]));
  LUT5 #(
    .INIT(32'h96696996)) 
    \__9/i_ 
       (.I0(\masked_variant_pipelined_8_staged.mappedxDP_reg[1][0] ),
        .I1(\masked_variant_pipelined_8_staged.mappedxDP_reg[1][7]_1 ),
        .I2(\masked_variant_pipelined_8_staged.mappedxDP_reg[1][7]_2 ),
        .I3(\masked_variant_pipelined_8_staged.mappedxDP_reg[1][7]_0 ),
        .I4(\masked_variant_pipelined_8_staged.mappedxDP_reg[1][7] ),
        .O(D[0]));
endmodule

module shared_mul_gf2
   (Q,
    \FFxDP_reg[2][1]_0 ,
    \FFxDP_reg[1][1]_0 ,
    \FFxDP_reg[0][1]_0 ,
    CLK,
    \FFxDP_reg[1][1]_1 ,
    \FFxDP_reg[3][1]_0 ,
    \FFxDP_reg[0][1]_1 ,
    \FFxDP_reg[1][0]_0 );
  output [1:0]Q;
  output [1:0]\FFxDP_reg[2][1]_0 ;
  output [1:0]\FFxDP_reg[1][1]_0 ;
  output [1:0]\FFxDP_reg[0][1]_0 ;
  input CLK;
  input \FFxDP_reg[1][1]_1 ;
  input [3:0]\FFxDP_reg[3][1]_0 ;
  input [3:0]\FFxDP_reg[0][1]_1 ;
  input \FFxDP_reg[1][0]_0 ;

  wire \<const0> ;
  wire \<const1> ;
  wire CLK;
  wire [1:0]\FFxDN[1]_15 ;
  wire [1:0]\FFxDN[2]_14 ;
  wire [1:0]\FFxDP_reg[0][1]_0 ;
  wire [3:0]\FFxDP_reg[0][1]_1 ;
  wire \FFxDP_reg[1][0]_0 ;
  wire [1:0]\FFxDP_reg[1][1]_0 ;
  wire \FFxDP_reg[1][1]_1 ;
  wire [1:0]\FFxDP_reg[2][1]_0 ;
  wire [3:0]\FFxDP_reg[3][1]_0 ;
  wire [1:0]Q;
  wire [1:0]\Xi_mul_Yj[0]_17 ;
  wire [1:0]\Xi_mul_Yj[3]_16 ;

  LUT5 #(
    .INIT(32'h5A6696AA)) 
    \FFxDP[1][0]_i_1 
       (.I0(\FFxDP_reg[1][0]_0 ),
        .I1(\FFxDP_reg[0][1]_1 [3]),
        .I2(\FFxDP_reg[0][1]_1 [2]),
        .I3(\FFxDP_reg[3][1]_0 [1]),
        .I4(\FFxDP_reg[3][1]_0 [0]),
        .O(\FFxDN[1]_15 [0]));
  LUT5 #(
    .INIT(32'h66965AAA)) 
    \FFxDP[1][1]_i_1 
       (.I0(\FFxDP_reg[1][1]_1 ),
        .I1(\FFxDP_reg[0][1]_1 [3]),
        .I2(\FFxDP_reg[0][1]_1 [2]),
        .I3(\FFxDP_reg[3][1]_0 [1]),
        .I4(\FFxDP_reg[3][1]_0 [0]),
        .O(\FFxDN[1]_15 [1]));
  LUT5 #(
    .INIT(32'h5A6696AA)) 
    \FFxDP[2][0]_i_1 
       (.I0(\FFxDP_reg[1][0]_0 ),
        .I1(\FFxDP_reg[3][1]_0 [3]),
        .I2(\FFxDP_reg[3][1]_0 [2]),
        .I3(\FFxDP_reg[0][1]_1 [1]),
        .I4(\FFxDP_reg[0][1]_1 [0]),
        .O(\FFxDN[2]_14 [0]));
  LUT5 #(
    .INIT(32'h66965AAA)) 
    \FFxDP[2][1]_i_1 
       (.I0(\FFxDP_reg[1][1]_1 ),
        .I1(\FFxDP_reg[3][1]_0 [3]),
        .I2(\FFxDP_reg[3][1]_0 [2]),
        .I3(\FFxDP_reg[0][1]_1 [1]),
        .I4(\FFxDP_reg[0][1]_1 [0]),
        .O(\FFxDN[2]_14 [1]));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[0][0] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\Xi_mul_Yj[0]_17 [0]),
        .Q(\FFxDP_reg[0][1]_0 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[0][1] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\Xi_mul_Yj[0]_17 [1]),
        .Q(\FFxDP_reg[0][1]_0 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[1][0] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\FFxDN[1]_15 [0]),
        .Q(\FFxDP_reg[1][1]_0 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[1][1] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\FFxDN[1]_15 [1]),
        .Q(\FFxDP_reg[1][1]_0 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[2][0] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\FFxDN[2]_14 [0]),
        .Q(\FFxDP_reg[2][1]_0 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[2][1] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\FFxDN[2]_14 [1]),
        .Q(\FFxDP_reg[2][1]_0 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[3][0] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\Xi_mul_Yj[3]_16 [0]),
        .Q(Q[0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[3][1] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\Xi_mul_Yj[3]_16 [1]),
        .Q(Q[1]),
        .R(\<const0> ));
  GND GND
       (.G(\<const0> ));
  VCC VCC
       (.P(\<const1> ));
  gf2_mul__parameterized0_8 \gen_inner_multipliers_g[0].gen_outer_multipliers_g[0].gf2_mul 
       (.D(\Xi_mul_Yj[0]_17 ),
        .\FFxDP_reg[0][1] (\FFxDP_reg[0][1]_1 ));
  gf2_mul__parameterized0_9 \gen_inner_multipliers_g[1].gen_outer_multipliers_g[1].gf2_mul 
       (.D(\Xi_mul_Yj[3]_16 ),
        .\FFxDP_reg[3][1] (\FFxDP_reg[3][1]_0 ));
endmodule

(* ORIG_REF_NAME = "shared_mul_gf2" *) 
module shared_mul_gf2_3
   (D,
    \Zmul2xDI[0][3] ,
    \masked_variant_pipelined_8_staged.Y0_4xDP_reg[1][1] ,
    \masked_variant_pipelined_8_staged.Y1_4xDP_reg[1][1] ,
    \Zmul3xDI[0][3] ,
    \Zmul2xDI[0][3]_0 ,
    \masked_variant_pipelined_8_staged.Y1_4xDP_reg[0][1] ,
    \Zmul3xDI[0][3]_0 ,
    Q,
    \FFxDP_reg[2][3] ,
    p_0_in2_in,
    \FFxDP_reg[1][1]_0 ,
    \FFxDP_reg[1][0]_0 ,
    \FFxDP_reg[3][3] ,
    \FFxDP_reg[1][3] ,
    p_0_in2_in_0,
    \FFxDP_reg[3][3]_0 ,
    \FFxDP_reg[1][1]_1 ,
    p_0_in2_in_1,
    \FFxDP_reg[1][1]_2 ,
    \FFxDP_reg[0][1]_0 ,
    p_0_in2_in_2,
    \FFxDP_reg[0][1]_1 ,
    \FFxDP_reg[1][0]_1 ,
    QxDO122_out__2__0,
    QxDO124_out__2__0,
    \FFxDP_reg[1][2] ,
    QxDO122_out__0__0,
    \FFxDP_reg[1][3]_0 ,
    QxDO124_out__0__0,
    QxDO122_out__3,
    QxDO122_out__3__0,
    \FFxDP_reg[1][2]_0 ,
    QxDO122_out__4,
    \FFxDP_reg[1][3]_1 ,
    QxDO124_out__4,
    QxDO124_out__3__0,
    QxDO124_out__3,
    \FFxDP_reg[3][3]_1 ,
    \FFxDP_reg[3][3]_2 ,
    QxDO122_out__1__0,
    QxDO124_out__1__0,
    QxDO124_out__6,
    QxDO122_out__6,
    QxDO124_out__5,
    QxDO122_out__5,
    \FFxDP_reg[1][1]_3 ,
    \FFxDP_reg[1][1]_4 ,
    CLK,
    \FFxDP_reg[1][1]_5 ,
    \FFxDP_reg[3][0]_0 ,
    \FFxDP_reg[0][0]_0 ,
    \FFxDP_reg[1][0]_2 ,
    \FFxDP_reg[0][0]_1 ,
    \FFxDP_reg[3][0]_1 );
  output [3:0]D;
  output [3:0]\Zmul2xDI[0][3] ;
  output [3:0]\masked_variant_pipelined_8_staged.Y0_4xDP_reg[1][1] ;
  output [3:0]\masked_variant_pipelined_8_staged.Y1_4xDP_reg[1][1] ;
  output [3:0]\Zmul3xDI[0][3] ;
  output [3:0]\Zmul2xDI[0][3]_0 ;
  output [3:0]\masked_variant_pipelined_8_staged.Y1_4xDP_reg[0][1] ;
  output [3:0]\Zmul3xDI[0][3]_0 ;
  input [3:0]Q;
  input \FFxDP_reg[2][3] ;
  input p_0_in2_in;
  input \FFxDP_reg[1][1]_0 ;
  input \FFxDP_reg[1][0]_0 ;
  input [3:0]\FFxDP_reg[3][3] ;
  input \FFxDP_reg[1][3] ;
  input p_0_in2_in_0;
  input [3:0]\FFxDP_reg[3][3]_0 ;
  input \FFxDP_reg[1][1]_1 ;
  input p_0_in2_in_1;
  input \FFxDP_reg[1][1]_2 ;
  input \FFxDP_reg[0][1]_0 ;
  input p_0_in2_in_2;
  input [3:0]\FFxDP_reg[0][1]_1 ;
  input \FFxDP_reg[1][0]_1 ;
  input QxDO122_out__2__0;
  input QxDO124_out__2__0;
  input \FFxDP_reg[1][2] ;
  input QxDO122_out__0__0;
  input \FFxDP_reg[1][3]_0 ;
  input QxDO124_out__0__0;
  input QxDO122_out__3;
  input QxDO122_out__3__0;
  input \FFxDP_reg[1][2]_0 ;
  input QxDO122_out__4;
  input \FFxDP_reg[1][3]_1 ;
  input QxDO124_out__4;
  input QxDO124_out__3__0;
  input QxDO124_out__3;
  input [1:0]\FFxDP_reg[3][3]_1 ;
  input [1:0]\FFxDP_reg[3][3]_2 ;
  input QxDO122_out__1__0;
  input QxDO124_out__1__0;
  input QxDO124_out__6;
  input QxDO122_out__6;
  input QxDO124_out__5;
  input QxDO122_out__5;
  input [1:0]\FFxDP_reg[1][1]_3 ;
  input [1:0]\FFxDP_reg[1][1]_4 ;
  input CLK;
  input \FFxDP_reg[1][1]_5 ;
  input [1:0]\FFxDP_reg[3][0]_0 ;
  input [1:0]\FFxDP_reg[0][0]_0 ;
  input \FFxDP_reg[1][0]_2 ;
  input [1:0]\FFxDP_reg[0][0]_1 ;
  input [1:0]\FFxDP_reg[3][0]_1 ;

  wire \<const0> ;
  wire \<const1> ;
  wire CLK;
  wire [3:0]D;
  wire [1:0]\FFxDN[1]_19 ;
  wire [1:0]\FFxDN[2]_18 ;
  wire \FFxDP[1][3]_i_3__0_n_0 ;
  wire \FFxDP[3][3]_i_3__0_n_0 ;
  wire [1:0]\FFxDP_reg[0][0]_0 ;
  wire [1:0]\FFxDP_reg[0][0]_1 ;
  wire \FFxDP_reg[0][1]_0 ;
  wire [3:0]\FFxDP_reg[0][1]_1 ;
  wire [1:0]\FFxDP_reg[0]_7 ;
  wire \FFxDP_reg[1][0]_0 ;
  wire \FFxDP_reg[1][0]_1 ;
  wire \FFxDP_reg[1][0]_2 ;
  wire \FFxDP_reg[1][1]_0 ;
  wire \FFxDP_reg[1][1]_1 ;
  wire \FFxDP_reg[1][1]_2 ;
  wire [1:0]\FFxDP_reg[1][1]_3 ;
  wire [1:0]\FFxDP_reg[1][1]_4 ;
  wire \FFxDP_reg[1][1]_5 ;
  wire \FFxDP_reg[1][2] ;
  wire \FFxDP_reg[1][2]_0 ;
  wire \FFxDP_reg[1][3] ;
  wire \FFxDP_reg[1][3]_0 ;
  wire \FFxDP_reg[1][3]_1 ;
  wire [1:0]\FFxDP_reg[1]_6 ;
  wire \FFxDP_reg[2][3] ;
  wire [1:0]\FFxDP_reg[2]_5 ;
  wire [1:0]\FFxDP_reg[3][0]_0 ;
  wire [1:0]\FFxDP_reg[3][0]_1 ;
  wire [3:0]\FFxDP_reg[3][3] ;
  wire [3:0]\FFxDP_reg[3][3]_0 ;
  wire [1:0]\FFxDP_reg[3][3]_1 ;
  wire [1:0]\FFxDP_reg[3][3]_2 ;
  wire [1:0]\FFxDP_reg[3]_4 ;
  wire [3:0]Q;
  wire QxDO122_out__0__0;
  wire QxDO122_out__1__0;
  wire QxDO122_out__2__0;
  wire QxDO122_out__3;
  wire QxDO122_out__3__0;
  wire QxDO122_out__4;
  wire QxDO122_out__5;
  wire QxDO122_out__6;
  wire QxDO124_out__0__0;
  wire QxDO124_out__1__0;
  wire QxDO124_out__2__0;
  wire QxDO124_out__3;
  wire QxDO124_out__3__0;
  wire QxDO124_out__4;
  wire QxDO124_out__5;
  wire QxDO124_out__6;
  wire QxDO13_out__0__0;
  wire QxDO13_out__1__0;
  wire QxDO13_out__2__0;
  wire QxDO13_out__3;
  wire QxDO13_out__3__0;
  wire QxDO13_out__4;
  wire QxDO13_out__5;
  wire QxDO13_out__6;
  wire QxDO1__0__0;
  wire QxDO1__1__0;
  wire QxDO1__2__0;
  wire QxDO1__3;
  wire QxDO1__3__0;
  wire QxDO1__4;
  wire QxDO1__5;
  wire QxDO1__6;
  wire [1:0]\Xi_mul_Yj[0]_23 ;
  wire [1:0]\Xi_mul_Yj[3]_22 ;
  wire [3:0]\Zmul2xDI[0][3] ;
  wire [3:0]\Zmul2xDI[0][3]_0 ;
  wire [3:0]\Zmul3xDI[0][3] ;
  wire [3:0]\Zmul3xDI[0][3]_0 ;
  wire [3:0]\masked_variant_pipelined_8_staged.Y0_4xDP_reg[1][1] ;
  wire [3:0]\masked_variant_pipelined_8_staged.Y1_4xDP_reg[0][1] ;
  wire [3:0]\masked_variant_pipelined_8_staged.Y1_4xDP_reg[1][1] ;
  wire \masked_variant_pipelined_8_staged.mult_msb/gen_inner_multipliers_g[0].gen_outer_multipliers_g[0].gf4_mul/p_1_in3_in ;
  wire \masked_variant_pipelined_8_staged.mult_msb/gen_inner_multipliers_g[1].gen_outer_multipliers_g[0].gf4_mul/p_1_in3_in ;
  wire p_0_in2_in;
  wire p_0_in2_in_0;
  wire p_0_in2_in_1;
  wire p_0_in2_in_2;

  LUT6 #(
    .INIT(64'h690F99FF96F06600)) 
    \FFxDP[0][0]_i_1__0 
       (.I0(Q[2]),
        .I1(Q[0]),
        .I2(p_0_in2_in),
        .I3(\FFxDP[1][3]_i_3__0_n_0 ),
        .I4(\masked_variant_pipelined_8_staged.mult_msb/gen_inner_multipliers_g[0].gen_outer_multipliers_g[0].gf4_mul/p_1_in3_in ),
        .I5(QxDO1__2__0),
        .O(D[0]));
  LUT6 #(
    .INIT(64'h690F99FF96F06600)) 
    \FFxDP[0][0]_i_1__1 
       (.I0(\FFxDP_reg[0][1]_1 [2]),
        .I1(\FFxDP_reg[0][1]_1 [0]),
        .I2(p_0_in2_in_2),
        .I3(\FFxDP[1][3]_i_3__0_n_0 ),
        .I4(\masked_variant_pipelined_8_staged.mult_msb/gen_inner_multipliers_g[0].gen_outer_multipliers_g[0].gf4_mul/p_1_in3_in ),
        .I5(QxDO1__6),
        .O(\masked_variant_pipelined_8_staged.Y1_4xDP_reg[0][1] [0]));
  LUT6 #(
    .INIT(64'h0CC06AA66AA60CC0)) 
    \FFxDP[0][0]_i_2__0 
       (.I0(Q[0]),
        .I1(Q[1]),
        .I2(\FFxDP_reg[0]_7 [0]),
        .I3(\FFxDP_reg[1]_6 [0]),
        .I4(\FFxDP_reg[0]_7 [1]),
        .I5(\FFxDP_reg[1]_6 [1]),
        .O(QxDO1__2__0));
  LUT6 #(
    .INIT(64'h0CC06AA66AA60CC0)) 
    \FFxDP[0][0]_i_2__1 
       (.I0(\FFxDP_reg[0][1]_1 [0]),
        .I1(\FFxDP_reg[0][1]_1 [1]),
        .I2(\FFxDP_reg[0]_7 [0]),
        .I3(\FFxDP_reg[1]_6 [0]),
        .I4(\FFxDP_reg[0]_7 [1]),
        .I5(\FFxDP_reg[1]_6 [1]),
        .O(QxDO1__6));
  LUT6 #(
    .INIT(64'h5335F99FACCA0660)) 
    \FFxDP[0][1]_i_1__0 
       (.I0(\masked_variant_pipelined_8_staged.mult_msb/gen_inner_multipliers_g[0].gen_outer_multipliers_g[0].gf4_mul/p_1_in3_in ),
        .I1(\FFxDP[1][3]_i_3__0_n_0 ),
        .I2(Q[1]),
        .I3(Q[3]),
        .I4(\FFxDP_reg[2][3] ),
        .I5(QxDO13_out__2__0),
        .O(D[1]));
  LUT6 #(
    .INIT(64'h5335F99FACCA0660)) 
    \FFxDP[0][1]_i_1__1 
       (.I0(\masked_variant_pipelined_8_staged.mult_msb/gen_inner_multipliers_g[0].gen_outer_multipliers_g[0].gf4_mul/p_1_in3_in ),
        .I1(\FFxDP[1][3]_i_3__0_n_0 ),
        .I2(\FFxDP_reg[0][1]_1 [1]),
        .I3(\FFxDP_reg[0][1]_1 [3]),
        .I4(\FFxDP_reg[0][1]_0 ),
        .I5(QxDO13_out__6),
        .O(\masked_variant_pipelined_8_staged.Y1_4xDP_reg[0][1] [1]));
  LUT6 #(
    .INIT(64'h0660ACCAACCA0660)) 
    \FFxDP[0][1]_i_2__0 
       (.I0(Q[0]),
        .I1(Q[1]),
        .I2(\FFxDP_reg[0]_7 [0]),
        .I3(\FFxDP_reg[1]_6 [0]),
        .I4(\FFxDP_reg[0]_7 [1]),
        .I5(\FFxDP_reg[1]_6 [1]),
        .O(QxDO13_out__2__0));
  LUT6 #(
    .INIT(64'h0660ACCAACCA0660)) 
    \FFxDP[0][1]_i_2__1 
       (.I0(\FFxDP_reg[0][1]_1 [0]),
        .I1(\FFxDP_reg[0][1]_1 [1]),
        .I2(\FFxDP_reg[0]_7 [0]),
        .I3(\FFxDP_reg[1]_6 [0]),
        .I4(\FFxDP_reg[0]_7 [1]),
        .I5(\FFxDP_reg[1]_6 [1]),
        .O(QxDO13_out__6));
  LUT6 #(
    .INIT(64'h690F99FF96F06600)) 
    \FFxDP[0][2]_i_1__0 
       (.I0(Q[2]),
        .I1(Q[0]),
        .I2(p_0_in2_in),
        .I3(\FFxDP[1][3]_i_3__0_n_0 ),
        .I4(\masked_variant_pipelined_8_staged.mult_msb/gen_inner_multipliers_g[0].gen_outer_multipliers_g[0].gf4_mul/p_1_in3_in ),
        .I5(QxDO122_out__2__0),
        .O(D[2]));
  LUT6 #(
    .INIT(64'h690F99FF96F06600)) 
    \FFxDP[0][2]_i_1__1 
       (.I0(\FFxDP_reg[0][1]_1 [2]),
        .I1(\FFxDP_reg[0][1]_1 [0]),
        .I2(p_0_in2_in_2),
        .I3(\FFxDP[1][3]_i_3__0_n_0 ),
        .I4(\masked_variant_pipelined_8_staged.mult_msb/gen_inner_multipliers_g[0].gen_outer_multipliers_g[0].gf4_mul/p_1_in3_in ),
        .I5(QxDO122_out__6),
        .O(\masked_variant_pipelined_8_staged.Y1_4xDP_reg[0][1] [2]));
  LUT6 #(
    .INIT(64'h5335F99FACCA0660)) 
    \FFxDP[0][3]_i_1__0 
       (.I0(\masked_variant_pipelined_8_staged.mult_msb/gen_inner_multipliers_g[0].gen_outer_multipliers_g[0].gf4_mul/p_1_in3_in ),
        .I1(\FFxDP[1][3]_i_3__0_n_0 ),
        .I2(Q[1]),
        .I3(Q[3]),
        .I4(\FFxDP_reg[2][3] ),
        .I5(QxDO124_out__2__0),
        .O(D[3]));
  LUT6 #(
    .INIT(64'h5335F99FACCA0660)) 
    \FFxDP[0][3]_i_1__1 
       (.I0(\masked_variant_pipelined_8_staged.mult_msb/gen_inner_multipliers_g[0].gen_outer_multipliers_g[0].gf4_mul/p_1_in3_in ),
        .I1(\FFxDP[1][3]_i_3__0_n_0 ),
        .I2(\FFxDP_reg[0][1]_1 [1]),
        .I3(\FFxDP_reg[0][1]_1 [3]),
        .I4(\FFxDP_reg[0][1]_0 ),
        .I5(QxDO124_out__6),
        .O(\masked_variant_pipelined_8_staged.Y1_4xDP_reg[0][1] [3]));
  LUT5 #(
    .INIT(32'h5A6696AA)) 
    \FFxDP[1][0]_i_1 
       (.I0(\FFxDP_reg[1][0]_2 ),
        .I1(\FFxDP_reg[0][0]_1 [1]),
        .I2(\FFxDP_reg[0][0]_1 [0]),
        .I3(\FFxDP_reg[3][0]_1 [1]),
        .I4(\FFxDP_reg[3][0]_1 [0]),
        .O(\FFxDN[1]_19 [0]));
  LUT6 #(
    .INIT(64'h6996996696966666)) 
    \FFxDP[1][0]_i_1__0 
       (.I0(\FFxDP_reg[1][0]_0 ),
        .I1(QxDO1__1__0),
        .I2(\masked_variant_pipelined_8_staged.mult_msb/gen_inner_multipliers_g[0].gen_outer_multipliers_g[0].gf4_mul/p_1_in3_in ),
        .I3(\FFxDP[1][3]_i_3__0_n_0 ),
        .I4(p_0_in2_in_0),
        .I5(\FFxDP_reg[1][3] ),
        .O(\Zmul2xDI[0][3]_0 [0]));
  LUT6 #(
    .INIT(64'h6996996696966666)) 
    \FFxDP[1][0]_i_1__1 
       (.I0(\FFxDP_reg[1][0]_1 ),
        .I1(QxDO1__5),
        .I2(\masked_variant_pipelined_8_staged.mult_msb/gen_inner_multipliers_g[0].gen_outer_multipliers_g[0].gf4_mul/p_1_in3_in ),
        .I3(\FFxDP[1][3]_i_3__0_n_0 ),
        .I4(p_0_in2_in_1),
        .I5(\FFxDP_reg[1][1]_1 ),
        .O(\Zmul3xDI[0][3]_0 [0]));
  LUT6 #(
    .INIT(64'h0CC06AA66AA60CC0)) 
    \FFxDP[1][0]_i_2__0 
       (.I0(\FFxDP_reg[3][3] [0]),
        .I1(\FFxDP_reg[3][3] [1]),
        .I2(\FFxDP_reg[0]_7 [0]),
        .I3(\FFxDP_reg[1]_6 [0]),
        .I4(\FFxDP_reg[0]_7 [1]),
        .I5(\FFxDP_reg[1]_6 [1]),
        .O(QxDO1__1__0));
  LUT6 #(
    .INIT(64'h0CC06AA66AA60CC0)) 
    \FFxDP[1][0]_i_2__1 
       (.I0(\FFxDP_reg[3][3]_0 [0]),
        .I1(\FFxDP_reg[3][3]_0 [1]),
        .I2(\FFxDP_reg[0]_7 [0]),
        .I3(\FFxDP_reg[1]_6 [0]),
        .I4(\FFxDP_reg[0]_7 [1]),
        .I5(\FFxDP_reg[1]_6 [1]),
        .O(QxDO1__5));
  LUT5 #(
    .INIT(32'h66965AAA)) 
    \FFxDP[1][1]_i_1 
       (.I0(\FFxDP_reg[1][1]_5 ),
        .I1(\FFxDP_reg[0][0]_1 [1]),
        .I2(\FFxDP_reg[0][0]_1 [0]),
        .I3(\FFxDP_reg[3][0]_1 [1]),
        .I4(\FFxDP_reg[3][0]_1 [0]),
        .O(\FFxDN[1]_19 [1]));
  LUT6 #(
    .INIT(64'h9696699699666666)) 
    \FFxDP[1][1]_i_1__0 
       (.I0(\FFxDP_reg[1][1]_0 ),
        .I1(QxDO13_out__1__0),
        .I2(\FFxDP_reg[1][3] ),
        .I3(p_0_in2_in_0),
        .I4(\FFxDP[1][3]_i_3__0_n_0 ),
        .I5(\masked_variant_pipelined_8_staged.mult_msb/gen_inner_multipliers_g[0].gen_outer_multipliers_g[0].gf4_mul/p_1_in3_in ),
        .O(\Zmul2xDI[0][3]_0 [1]));
  LUT6 #(
    .INIT(64'h9696699699666666)) 
    \FFxDP[1][1]_i_1__1 
       (.I0(\FFxDP_reg[1][1]_2 ),
        .I1(QxDO13_out__5),
        .I2(\FFxDP_reg[1][1]_1 ),
        .I3(p_0_in2_in_1),
        .I4(\FFxDP[1][3]_i_3__0_n_0 ),
        .I5(\masked_variant_pipelined_8_staged.mult_msb/gen_inner_multipliers_g[0].gen_outer_multipliers_g[0].gf4_mul/p_1_in3_in ),
        .O(\Zmul3xDI[0][3]_0 [1]));
  LUT6 #(
    .INIT(64'h0660ACCAACCA0660)) 
    \FFxDP[1][1]_i_2__0 
       (.I0(\FFxDP_reg[3][3] [0]),
        .I1(\FFxDP_reg[3][3] [1]),
        .I2(\FFxDP_reg[0]_7 [0]),
        .I3(\FFxDP_reg[1]_6 [0]),
        .I4(\FFxDP_reg[0]_7 [1]),
        .I5(\FFxDP_reg[1]_6 [1]),
        .O(QxDO13_out__1__0));
  LUT6 #(
    .INIT(64'h0660ACCAACCA0660)) 
    \FFxDP[1][1]_i_2__1 
       (.I0(\FFxDP_reg[3][3]_0 [0]),
        .I1(\FFxDP_reg[3][3]_0 [1]),
        .I2(\FFxDP_reg[0]_7 [0]),
        .I3(\FFxDP_reg[1]_6 [0]),
        .I4(\FFxDP_reg[0]_7 [1]),
        .I5(\FFxDP_reg[1]_6 [1]),
        .O(QxDO13_out__5));
  LUT6 #(
    .INIT(64'h6996996696966666)) 
    \FFxDP[1][2]_i_1__0 
       (.I0(\FFxDP_reg[1][2] ),
        .I1(QxDO122_out__1__0),
        .I2(\masked_variant_pipelined_8_staged.mult_msb/gen_inner_multipliers_g[0].gen_outer_multipliers_g[0].gf4_mul/p_1_in3_in ),
        .I3(\FFxDP[1][3]_i_3__0_n_0 ),
        .I4(p_0_in2_in_0),
        .I5(\FFxDP_reg[1][3] ),
        .O(\Zmul2xDI[0][3]_0 [2]));
  LUT6 #(
    .INIT(64'h6996996696966666)) 
    \FFxDP[1][2]_i_1__1 
       (.I0(\FFxDP_reg[1][2]_0 ),
        .I1(QxDO122_out__5),
        .I2(\masked_variant_pipelined_8_staged.mult_msb/gen_inner_multipliers_g[0].gen_outer_multipliers_g[0].gf4_mul/p_1_in3_in ),
        .I3(\FFxDP[1][3]_i_3__0_n_0 ),
        .I4(p_0_in2_in_1),
        .I5(\FFxDP_reg[1][1]_1 ),
        .O(\Zmul3xDI[0][3]_0 [2]));
  LUT6 #(
    .INIT(64'h9696699699666666)) 
    \FFxDP[1][3]_i_1__0 
       (.I0(\FFxDP_reg[1][3]_0 ),
        .I1(QxDO124_out__1__0),
        .I2(\FFxDP_reg[1][3] ),
        .I3(p_0_in2_in_0),
        .I4(\FFxDP[1][3]_i_3__0_n_0 ),
        .I5(\masked_variant_pipelined_8_staged.mult_msb/gen_inner_multipliers_g[0].gen_outer_multipliers_g[0].gf4_mul/p_1_in3_in ),
        .O(\Zmul2xDI[0][3]_0 [3]));
  LUT6 #(
    .INIT(64'h9696699699666666)) 
    \FFxDP[1][3]_i_1__1 
       (.I0(\FFxDP_reg[1][3]_1 ),
        .I1(QxDO124_out__5),
        .I2(\FFxDP_reg[1][1]_1 ),
        .I3(p_0_in2_in_1),
        .I4(\FFxDP[1][3]_i_3__0_n_0 ),
        .I5(\masked_variant_pipelined_8_staged.mult_msb/gen_inner_multipliers_g[0].gen_outer_multipliers_g[0].gf4_mul/p_1_in3_in ),
        .O(\Zmul3xDI[0][3]_0 [3]));
  LUT4 #(
    .INIT(16'h6996)) 
    \FFxDP[1][3]_i_3__0 
       (.I0(\FFxDP_reg[0]_7 [0]),
        .I1(\FFxDP_reg[1]_6 [0]),
        .I2(\FFxDP_reg[1][1]_3 [0]),
        .I3(\FFxDP_reg[1][1]_4 [0]),
        .O(\FFxDP[1][3]_i_3__0_n_0 ));
  LUT4 #(
    .INIT(16'h6996)) 
    \FFxDP[1][3]_i_4__0 
       (.I0(\FFxDP_reg[0]_7 [1]),
        .I1(\FFxDP_reg[1]_6 [1]),
        .I2(\FFxDP_reg[1][1]_3 [1]),
        .I3(\FFxDP_reg[1][1]_4 [1]),
        .O(\masked_variant_pipelined_8_staged.mult_msb/gen_inner_multipliers_g[0].gen_outer_multipliers_g[0].gf4_mul/p_1_in3_in ));
  LUT5 #(
    .INIT(32'h5A6696AA)) 
    \FFxDP[2][0]_i_1 
       (.I0(\FFxDP_reg[1][0]_2 ),
        .I1(\FFxDP_reg[3][0]_0 [1]),
        .I2(\FFxDP_reg[3][0]_0 [0]),
        .I3(\FFxDP_reg[0][0]_0 [1]),
        .I4(\FFxDP_reg[0][0]_0 [0]),
        .O(\FFxDN[2]_18 [0]));
  LUT6 #(
    .INIT(64'h6996996696966666)) 
    \FFxDP[2][0]_i_1__0 
       (.I0(\FFxDP_reg[1][0]_0 ),
        .I1(QxDO1__0__0),
        .I2(\masked_variant_pipelined_8_staged.mult_msb/gen_inner_multipliers_g[1].gen_outer_multipliers_g[0].gf4_mul/p_1_in3_in ),
        .I3(\FFxDP[3][3]_i_3__0_n_0 ),
        .I4(p_0_in2_in),
        .I5(\FFxDP_reg[2][3] ),
        .O(\Zmul2xDI[0][3] [0]));
  LUT6 #(
    .INIT(64'h6996996696966666)) 
    \FFxDP[2][0]_i_1__1 
       (.I0(\FFxDP_reg[1][0]_1 ),
        .I1(QxDO1__4),
        .I2(\masked_variant_pipelined_8_staged.mult_msb/gen_inner_multipliers_g[1].gen_outer_multipliers_g[0].gf4_mul/p_1_in3_in ),
        .I3(\FFxDP[3][3]_i_3__0_n_0 ),
        .I4(p_0_in2_in_2),
        .I5(\FFxDP_reg[0][1]_0 ),
        .O(\Zmul3xDI[0][3] [0]));
  LUT6 #(
    .INIT(64'h0CC06AA66AA60CC0)) 
    \FFxDP[2][0]_i_3__0 
       (.I0(Q[0]),
        .I1(Q[1]),
        .I2(\FFxDP_reg[2]_5 [0]),
        .I3(\FFxDP_reg[3]_4 [0]),
        .I4(\FFxDP_reg[2]_5 [1]),
        .I5(\FFxDP_reg[3]_4 [1]),
        .O(QxDO1__0__0));
  LUT6 #(
    .INIT(64'h0CC06AA66AA60CC0)) 
    \FFxDP[2][0]_i_3__1 
       (.I0(\FFxDP_reg[0][1]_1 [0]),
        .I1(\FFxDP_reg[0][1]_1 [1]),
        .I2(\FFxDP_reg[2]_5 [0]),
        .I3(\FFxDP_reg[3]_4 [0]),
        .I4(\FFxDP_reg[2]_5 [1]),
        .I5(\FFxDP_reg[3]_4 [1]),
        .O(QxDO1__4));
  LUT5 #(
    .INIT(32'h66965AAA)) 
    \FFxDP[2][1]_i_1 
       (.I0(\FFxDP_reg[1][1]_5 ),
        .I1(\FFxDP_reg[3][0]_0 [1]),
        .I2(\FFxDP_reg[3][0]_0 [0]),
        .I3(\FFxDP_reg[0][0]_0 [1]),
        .I4(\FFxDP_reg[0][0]_0 [0]),
        .O(\FFxDN[2]_18 [1]));
  LUT6 #(
    .INIT(64'h9696699699666666)) 
    \FFxDP[2][1]_i_1__0 
       (.I0(\FFxDP_reg[1][1]_0 ),
        .I1(QxDO13_out__0__0),
        .I2(\FFxDP_reg[2][3] ),
        .I3(p_0_in2_in),
        .I4(\FFxDP[3][3]_i_3__0_n_0 ),
        .I5(\masked_variant_pipelined_8_staged.mult_msb/gen_inner_multipliers_g[1].gen_outer_multipliers_g[0].gf4_mul/p_1_in3_in ),
        .O(\Zmul2xDI[0][3] [1]));
  LUT6 #(
    .INIT(64'h9696699699666666)) 
    \FFxDP[2][1]_i_1__1 
       (.I0(\FFxDP_reg[1][1]_2 ),
        .I1(QxDO13_out__4),
        .I2(\FFxDP_reg[0][1]_0 ),
        .I3(p_0_in2_in_2),
        .I4(\FFxDP[3][3]_i_3__0_n_0 ),
        .I5(\masked_variant_pipelined_8_staged.mult_msb/gen_inner_multipliers_g[1].gen_outer_multipliers_g[0].gf4_mul/p_1_in3_in ),
        .O(\Zmul3xDI[0][3] [1]));
  LUT6 #(
    .INIT(64'h0660ACCAACCA0660)) 
    \FFxDP[2][1]_i_3__0 
       (.I0(Q[0]),
        .I1(Q[1]),
        .I2(\FFxDP_reg[2]_5 [0]),
        .I3(\FFxDP_reg[3]_4 [0]),
        .I4(\FFxDP_reg[2]_5 [1]),
        .I5(\FFxDP_reg[3]_4 [1]),
        .O(QxDO13_out__0__0));
  LUT6 #(
    .INIT(64'h0660ACCAACCA0660)) 
    \FFxDP[2][1]_i_3__1 
       (.I0(\FFxDP_reg[0][1]_1 [0]),
        .I1(\FFxDP_reg[0][1]_1 [1]),
        .I2(\FFxDP_reg[2]_5 [0]),
        .I3(\FFxDP_reg[3]_4 [0]),
        .I4(\FFxDP_reg[2]_5 [1]),
        .I5(\FFxDP_reg[3]_4 [1]),
        .O(QxDO13_out__4));
  LUT6 #(
    .INIT(64'h6996996696966666)) 
    \FFxDP[2][2]_i_1__0 
       (.I0(\FFxDP_reg[1][2] ),
        .I1(QxDO122_out__0__0),
        .I2(\masked_variant_pipelined_8_staged.mult_msb/gen_inner_multipliers_g[1].gen_outer_multipliers_g[0].gf4_mul/p_1_in3_in ),
        .I3(\FFxDP[3][3]_i_3__0_n_0 ),
        .I4(p_0_in2_in),
        .I5(\FFxDP_reg[2][3] ),
        .O(\Zmul2xDI[0][3] [2]));
  LUT6 #(
    .INIT(64'h6996996696966666)) 
    \FFxDP[2][2]_i_1__1 
       (.I0(\FFxDP_reg[1][2]_0 ),
        .I1(QxDO122_out__4),
        .I2(\masked_variant_pipelined_8_staged.mult_msb/gen_inner_multipliers_g[1].gen_outer_multipliers_g[0].gf4_mul/p_1_in3_in ),
        .I3(\FFxDP[3][3]_i_3__0_n_0 ),
        .I4(p_0_in2_in_2),
        .I5(\FFxDP_reg[0][1]_0 ),
        .O(\Zmul3xDI[0][3] [2]));
  LUT6 #(
    .INIT(64'h9696699699666666)) 
    \FFxDP[2][3]_i_1__0 
       (.I0(\FFxDP_reg[1][3]_0 ),
        .I1(QxDO124_out__0__0),
        .I2(\FFxDP_reg[2][3] ),
        .I3(p_0_in2_in),
        .I4(\FFxDP[3][3]_i_3__0_n_0 ),
        .I5(\masked_variant_pipelined_8_staged.mult_msb/gen_inner_multipliers_g[1].gen_outer_multipliers_g[0].gf4_mul/p_1_in3_in ),
        .O(\Zmul2xDI[0][3] [3]));
  LUT6 #(
    .INIT(64'h9696699699666666)) 
    \FFxDP[2][3]_i_1__1 
       (.I0(\FFxDP_reg[1][3]_1 ),
        .I1(QxDO124_out__4),
        .I2(\FFxDP_reg[0][1]_0 ),
        .I3(p_0_in2_in_2),
        .I4(\FFxDP[3][3]_i_3__0_n_0 ),
        .I5(\masked_variant_pipelined_8_staged.mult_msb/gen_inner_multipliers_g[1].gen_outer_multipliers_g[0].gf4_mul/p_1_in3_in ),
        .O(\Zmul3xDI[0][3] [3]));
  LUT6 #(
    .INIT(64'h690F99FF96F06600)) 
    \FFxDP[3][0]_i_1__0 
       (.I0(\FFxDP_reg[3][3] [2]),
        .I1(\FFxDP_reg[3][3] [0]),
        .I2(p_0_in2_in_0),
        .I3(\FFxDP[3][3]_i_3__0_n_0 ),
        .I4(\masked_variant_pipelined_8_staged.mult_msb/gen_inner_multipliers_g[1].gen_outer_multipliers_g[0].gf4_mul/p_1_in3_in ),
        .I5(QxDO1__3),
        .O(\masked_variant_pipelined_8_staged.Y0_4xDP_reg[1][1] [0]));
  LUT6 #(
    .INIT(64'h690F99FF96F06600)) 
    \FFxDP[3][0]_i_1__1 
       (.I0(\FFxDP_reg[3][3]_0 [2]),
        .I1(\FFxDP_reg[3][3]_0 [0]),
        .I2(p_0_in2_in_1),
        .I3(\FFxDP[3][3]_i_3__0_n_0 ),
        .I4(\masked_variant_pipelined_8_staged.mult_msb/gen_inner_multipliers_g[1].gen_outer_multipliers_g[0].gf4_mul/p_1_in3_in ),
        .I5(QxDO1__3__0),
        .O(\masked_variant_pipelined_8_staged.Y1_4xDP_reg[1][1] [0]));
  LUT6 #(
    .INIT(64'h0CC06AA66AA60CC0)) 
    \FFxDP[3][0]_i_2__0 
       (.I0(\FFxDP_reg[3][3] [0]),
        .I1(\FFxDP_reg[3][3] [1]),
        .I2(\FFxDP_reg[2]_5 [0]),
        .I3(\FFxDP_reg[3]_4 [0]),
        .I4(\FFxDP_reg[2]_5 [1]),
        .I5(\FFxDP_reg[3]_4 [1]),
        .O(QxDO1__3));
  LUT6 #(
    .INIT(64'h0CC06AA66AA60CC0)) 
    \FFxDP[3][0]_i_2__1 
       (.I0(\FFxDP_reg[3][3]_0 [0]),
        .I1(\FFxDP_reg[3][3]_0 [1]),
        .I2(\FFxDP_reg[2]_5 [0]),
        .I3(\FFxDP_reg[3]_4 [0]),
        .I4(\FFxDP_reg[2]_5 [1]),
        .I5(\FFxDP_reg[3]_4 [1]),
        .O(QxDO1__3__0));
  LUT6 #(
    .INIT(64'h5335F99FACCA0660)) 
    \FFxDP[3][1]_i_1__0 
       (.I0(\masked_variant_pipelined_8_staged.mult_msb/gen_inner_multipliers_g[1].gen_outer_multipliers_g[0].gf4_mul/p_1_in3_in ),
        .I1(\FFxDP[3][3]_i_3__0_n_0 ),
        .I2(\FFxDP_reg[3][3] [1]),
        .I3(\FFxDP_reg[3][3] [3]),
        .I4(\FFxDP_reg[1][3] ),
        .I5(QxDO13_out__3),
        .O(\masked_variant_pipelined_8_staged.Y0_4xDP_reg[1][1] [1]));
  LUT6 #(
    .INIT(64'h5335F99FACCA0660)) 
    \FFxDP[3][1]_i_1__1 
       (.I0(\masked_variant_pipelined_8_staged.mult_msb/gen_inner_multipliers_g[1].gen_outer_multipliers_g[0].gf4_mul/p_1_in3_in ),
        .I1(\FFxDP[3][3]_i_3__0_n_0 ),
        .I2(\FFxDP_reg[3][3]_0 [1]),
        .I3(\FFxDP_reg[3][3]_0 [3]),
        .I4(\FFxDP_reg[1][1]_1 ),
        .I5(QxDO13_out__3__0),
        .O(\masked_variant_pipelined_8_staged.Y1_4xDP_reg[1][1] [1]));
  LUT6 #(
    .INIT(64'h0660ACCAACCA0660)) 
    \FFxDP[3][1]_i_2__0 
       (.I0(\FFxDP_reg[3][3] [0]),
        .I1(\FFxDP_reg[3][3] [1]),
        .I2(\FFxDP_reg[2]_5 [0]),
        .I3(\FFxDP_reg[3]_4 [0]),
        .I4(\FFxDP_reg[2]_5 [1]),
        .I5(\FFxDP_reg[3]_4 [1]),
        .O(QxDO13_out__3));
  LUT6 #(
    .INIT(64'h0660ACCAACCA0660)) 
    \FFxDP[3][1]_i_2__1 
       (.I0(\FFxDP_reg[3][3]_0 [0]),
        .I1(\FFxDP_reg[3][3]_0 [1]),
        .I2(\FFxDP_reg[2]_5 [0]),
        .I3(\FFxDP_reg[3]_4 [0]),
        .I4(\FFxDP_reg[2]_5 [1]),
        .I5(\FFxDP_reg[3]_4 [1]),
        .O(QxDO13_out__3__0));
  LUT6 #(
    .INIT(64'h690F99FF96F06600)) 
    \FFxDP[3][2]_i_1__0 
       (.I0(\FFxDP_reg[3][3] [2]),
        .I1(\FFxDP_reg[3][3] [0]),
        .I2(p_0_in2_in_0),
        .I3(\FFxDP[3][3]_i_3__0_n_0 ),
        .I4(\masked_variant_pipelined_8_staged.mult_msb/gen_inner_multipliers_g[1].gen_outer_multipliers_g[0].gf4_mul/p_1_in3_in ),
        .I5(QxDO122_out__3),
        .O(\masked_variant_pipelined_8_staged.Y0_4xDP_reg[1][1] [2]));
  LUT6 #(
    .INIT(64'h690F99FF96F06600)) 
    \FFxDP[3][2]_i_1__1 
       (.I0(\FFxDP_reg[3][3]_0 [2]),
        .I1(\FFxDP_reg[3][3]_0 [0]),
        .I2(p_0_in2_in_1),
        .I3(\FFxDP[3][3]_i_3__0_n_0 ),
        .I4(\masked_variant_pipelined_8_staged.mult_msb/gen_inner_multipliers_g[1].gen_outer_multipliers_g[0].gf4_mul/p_1_in3_in ),
        .I5(QxDO122_out__3__0),
        .O(\masked_variant_pipelined_8_staged.Y1_4xDP_reg[1][1] [2]));
  LUT6 #(
    .INIT(64'h5335F99FACCA0660)) 
    \FFxDP[3][3]_i_1__0 
       (.I0(\masked_variant_pipelined_8_staged.mult_msb/gen_inner_multipliers_g[1].gen_outer_multipliers_g[0].gf4_mul/p_1_in3_in ),
        .I1(\FFxDP[3][3]_i_3__0_n_0 ),
        .I2(\FFxDP_reg[3][3]_0 [1]),
        .I3(\FFxDP_reg[3][3]_0 [3]),
        .I4(\FFxDP_reg[1][1]_1 ),
        .I5(QxDO124_out__3__0),
        .O(\masked_variant_pipelined_8_staged.Y1_4xDP_reg[1][1] [3]));
  LUT6 #(
    .INIT(64'h5335F99FACCA0660)) 
    \FFxDP[3][3]_i_1__1 
       (.I0(\masked_variant_pipelined_8_staged.mult_msb/gen_inner_multipliers_g[1].gen_outer_multipliers_g[0].gf4_mul/p_1_in3_in ),
        .I1(\FFxDP[3][3]_i_3__0_n_0 ),
        .I2(\FFxDP_reg[3][3] [1]),
        .I3(\FFxDP_reg[3][3] [3]),
        .I4(\FFxDP_reg[1][3] ),
        .I5(QxDO124_out__3),
        .O(\masked_variant_pipelined_8_staged.Y0_4xDP_reg[1][1] [3]));
  LUT4 #(
    .INIT(16'h6996)) 
    \FFxDP[3][3]_i_2__0 
       (.I0(\FFxDP_reg[2]_5 [1]),
        .I1(\FFxDP_reg[3]_4 [1]),
        .I2(\FFxDP_reg[3][3]_1 [1]),
        .I3(\FFxDP_reg[3][3]_2 [1]),
        .O(\masked_variant_pipelined_8_staged.mult_msb/gen_inner_multipliers_g[1].gen_outer_multipliers_g[0].gf4_mul/p_1_in3_in ));
  LUT4 #(
    .INIT(16'h6996)) 
    \FFxDP[3][3]_i_3__0 
       (.I0(\FFxDP_reg[2]_5 [0]),
        .I1(\FFxDP_reg[3]_4 [0]),
        .I2(\FFxDP_reg[3][3]_1 [0]),
        .I3(\FFxDP_reg[3][3]_2 [0]),
        .O(\FFxDP[3][3]_i_3__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[0][0] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\Xi_mul_Yj[0]_23 [0]),
        .Q(\FFxDP_reg[0]_7 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[0][1] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\Xi_mul_Yj[0]_23 [1]),
        .Q(\FFxDP_reg[0]_7 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[1][0] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\FFxDN[1]_19 [0]),
        .Q(\FFxDP_reg[1]_6 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[1][1] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\FFxDN[1]_19 [1]),
        .Q(\FFxDP_reg[1]_6 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[2][0] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\FFxDN[2]_18 [0]),
        .Q(\FFxDP_reg[2]_5 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[2][1] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\FFxDN[2]_18 [1]),
        .Q(\FFxDP_reg[2]_5 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[3][0] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\Xi_mul_Yj[3]_22 [0]),
        .Q(\FFxDP_reg[3]_4 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[3][1] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\Xi_mul_Yj[3]_22 [1]),
        .Q(\FFxDP_reg[3]_4 [1]),
        .R(\<const0> ));
  GND GND
       (.G(\<const0> ));
  VCC VCC
       (.P(\<const1> ));
  gf2_mul__parameterized0_6 \gen_inner_multipliers_g[0].gen_outer_multipliers_g[0].gf2_mul 
       (.D(\Xi_mul_Yj[0]_23 ),
        .\FFxDP_reg[0][0] (\FFxDP_reg[0][0]_0 ),
        .\FFxDP_reg[0][0]_0 (\FFxDP_reg[0][0]_1 ));
  gf2_mul__parameterized0_7 \gen_inner_multipliers_g[1].gen_outer_multipliers_g[1].gf2_mul 
       (.D(\Xi_mul_Yj[3]_22 ),
        .\FFxDP_reg[3][0] (\FFxDP_reg[3][0]_1 ),
        .\FFxDP_reg[3][0]_0 (\FFxDP_reg[3][0]_0 ));
endmodule

(* ORIG_REF_NAME = "shared_mul_gf2" *) 
module shared_mul_gf2_4
   (QxDO124_out__6,
    Q,
    \FFxDP_reg[1][1]_0 ,
    QxDO122_out__6,
    QxDO124_out__4,
    \FFxDP_reg[2][1]_0 ,
    \FFxDP_reg[3][1]_0 ,
    QxDO122_out__4,
    QxDO124_out__3,
    QxDO122_out__3,
    QxDO124_out__0__0,
    QxDO122_out__0__0,
    QxDO124_out__3__0,
    QxDO122_out__3__0,
    QxDO124_out__5,
    QxDO122_out__5,
    QxDO124_out__2__0,
    QxDO122_out__2__0,
    QxDO124_out__1__0,
    QxDO122_out__1__0,
    \FFxDP_reg[2][2] ,
    \FFxDP_reg[1][2] ,
    \FFxDP_reg[0][2] ,
    \FFxDP_reg[1][2]_0 ,
    CLK,
    \FFxDP_reg[1][1]_1 ,
    \FFxDP_reg[3][0]_0 ,
    \FFxDP_reg[0][0]_0 ,
    \FFxDP_reg[1][0]_0 ,
    \FFxDP_reg[0][0]_1 ,
    \FFxDP_reg[3][0]_1 );
  output QxDO124_out__6;
  output [1:0]Q;
  output [1:0]\FFxDP_reg[1][1]_0 ;
  output QxDO122_out__6;
  output QxDO124_out__4;
  output [1:0]\FFxDP_reg[2][1]_0 ;
  output [1:0]\FFxDP_reg[3][1]_0 ;
  output QxDO122_out__4;
  output QxDO124_out__3;
  output QxDO122_out__3;
  output QxDO124_out__0__0;
  output QxDO122_out__0__0;
  output QxDO124_out__3__0;
  output QxDO122_out__3__0;
  output QxDO124_out__5;
  output QxDO122_out__5;
  output QxDO124_out__2__0;
  output QxDO122_out__2__0;
  output QxDO124_out__1__0;
  output QxDO122_out__1__0;
  input [1:0]\FFxDP_reg[2][2] ;
  input [1:0]\FFxDP_reg[1][2] ;
  input [1:0]\FFxDP_reg[0][2] ;
  input [1:0]\FFxDP_reg[1][2]_0 ;
  input CLK;
  input \FFxDP_reg[1][1]_1 ;
  input [1:0]\FFxDP_reg[3][0]_0 ;
  input [1:0]\FFxDP_reg[0][0]_0 ;
  input \FFxDP_reg[1][0]_0 ;
  input [1:0]\FFxDP_reg[0][0]_1 ;
  input [1:0]\FFxDP_reg[3][0]_1 ;

  wire \<const0> ;
  wire \<const1> ;
  wire CLK;
  wire [1:0]\FFxDN[1]_21 ;
  wire [1:0]\FFxDN[2]_20 ;
  wire [1:0]\FFxDP_reg[0][0]_0 ;
  wire [1:0]\FFxDP_reg[0][0]_1 ;
  wire [1:0]\FFxDP_reg[0][2] ;
  wire \FFxDP_reg[1][0]_0 ;
  wire [1:0]\FFxDP_reg[1][1]_0 ;
  wire \FFxDP_reg[1][1]_1 ;
  wire [1:0]\FFxDP_reg[1][2] ;
  wire [1:0]\FFxDP_reg[1][2]_0 ;
  wire [1:0]\FFxDP_reg[2][1]_0 ;
  wire [1:0]\FFxDP_reg[2][2] ;
  wire [1:0]\FFxDP_reg[3][0]_0 ;
  wire [1:0]\FFxDP_reg[3][0]_1 ;
  wire [1:0]\FFxDP_reg[3][1]_0 ;
  wire [1:0]Q;
  wire QxDO122_out__0__0;
  wire QxDO122_out__1__0;
  wire QxDO122_out__2__0;
  wire QxDO122_out__3;
  wire QxDO122_out__3__0;
  wire QxDO122_out__4;
  wire QxDO122_out__5;
  wire QxDO122_out__6;
  wire QxDO124_out__0__0;
  wire QxDO124_out__1__0;
  wire QxDO124_out__2__0;
  wire QxDO124_out__3;
  wire QxDO124_out__3__0;
  wire QxDO124_out__4;
  wire QxDO124_out__5;
  wire QxDO124_out__6;
  wire [1:0]\Xi_mul_Yj[0]_25 ;
  wire [1:0]\Xi_mul_Yj[3]_24 ;

  LUT6 #(
    .INIT(64'h0CC06AA66AA60CC0)) 
    \FFxDP[0][2]_i_2__0 
       (.I0(\FFxDP_reg[2][2] [0]),
        .I1(\FFxDP_reg[2][2] [1]),
        .I2(Q[0]),
        .I3(\FFxDP_reg[1][1]_0 [0]),
        .I4(Q[1]),
        .I5(\FFxDP_reg[1][1]_0 [1]),
        .O(QxDO122_out__6));
  LUT6 #(
    .INIT(64'h0CC06AA66AA60CC0)) 
    \FFxDP[0][2]_i_2__1 
       (.I0(\FFxDP_reg[0][2] [0]),
        .I1(\FFxDP_reg[0][2] [1]),
        .I2(Q[0]),
        .I3(\FFxDP_reg[1][1]_0 [0]),
        .I4(Q[1]),
        .I5(\FFxDP_reg[1][1]_0 [1]),
        .O(QxDO122_out__2__0));
  LUT6 #(
    .INIT(64'h0660ACCAACCA0660)) 
    \FFxDP[0][3]_i_2__0 
       (.I0(\FFxDP_reg[2][2] [0]),
        .I1(\FFxDP_reg[2][2] [1]),
        .I2(Q[0]),
        .I3(\FFxDP_reg[1][1]_0 [0]),
        .I4(Q[1]),
        .I5(\FFxDP_reg[1][1]_0 [1]),
        .O(QxDO124_out__6));
  LUT6 #(
    .INIT(64'h0660ACCAACCA0660)) 
    \FFxDP[0][3]_i_2__1 
       (.I0(\FFxDP_reg[0][2] [0]),
        .I1(\FFxDP_reg[0][2] [1]),
        .I2(Q[0]),
        .I3(\FFxDP_reg[1][1]_0 [0]),
        .I4(Q[1]),
        .I5(\FFxDP_reg[1][1]_0 [1]),
        .O(QxDO124_out__2__0));
  LUT5 #(
    .INIT(32'h5A6696AA)) 
    \FFxDP[1][0]_i_1 
       (.I0(\FFxDP_reg[1][0]_0 ),
        .I1(\FFxDP_reg[0][0]_1 [1]),
        .I2(\FFxDP_reg[0][0]_1 [0]),
        .I3(\FFxDP_reg[3][0]_1 [1]),
        .I4(\FFxDP_reg[3][0]_1 [0]),
        .O(\FFxDN[1]_21 [0]));
  LUT5 #(
    .INIT(32'h66965AAA)) 
    \FFxDP[1][1]_i_1 
       (.I0(\FFxDP_reg[1][1]_1 ),
        .I1(\FFxDP_reg[0][0]_1 [1]),
        .I2(\FFxDP_reg[0][0]_1 [0]),
        .I3(\FFxDP_reg[3][0]_1 [1]),
        .I4(\FFxDP_reg[3][0]_1 [0]),
        .O(\FFxDN[1]_21 [1]));
  LUT6 #(
    .INIT(64'h0CC06AA66AA60CC0)) 
    \FFxDP[1][2]_i_2__0 
       (.I0(\FFxDP_reg[1][2]_0 [0]),
        .I1(\FFxDP_reg[1][2]_0 [1]),
        .I2(Q[0]),
        .I3(\FFxDP_reg[1][1]_0 [0]),
        .I4(Q[1]),
        .I5(\FFxDP_reg[1][1]_0 [1]),
        .O(QxDO122_out__5));
  LUT6 #(
    .INIT(64'h0CC06AA66AA60CC0)) 
    \FFxDP[1][2]_i_2__1 
       (.I0(\FFxDP_reg[1][2] [0]),
        .I1(\FFxDP_reg[1][2] [1]),
        .I2(Q[0]),
        .I3(\FFxDP_reg[1][1]_0 [0]),
        .I4(Q[1]),
        .I5(\FFxDP_reg[1][1]_0 [1]),
        .O(QxDO122_out__1__0));
  LUT6 #(
    .INIT(64'h0660ACCAACCA0660)) 
    \FFxDP[1][3]_i_2__0 
       (.I0(\FFxDP_reg[1][2]_0 [0]),
        .I1(\FFxDP_reg[1][2]_0 [1]),
        .I2(Q[0]),
        .I3(\FFxDP_reg[1][1]_0 [0]),
        .I4(Q[1]),
        .I5(\FFxDP_reg[1][1]_0 [1]),
        .O(QxDO124_out__5));
  LUT6 #(
    .INIT(64'h0660ACCAACCA0660)) 
    \FFxDP[1][3]_i_2__1 
       (.I0(\FFxDP_reg[1][2] [0]),
        .I1(\FFxDP_reg[1][2] [1]),
        .I2(Q[0]),
        .I3(\FFxDP_reg[1][1]_0 [0]),
        .I4(Q[1]),
        .I5(\FFxDP_reg[1][1]_0 [1]),
        .O(QxDO124_out__1__0));
  LUT5 #(
    .INIT(32'h5A6696AA)) 
    \FFxDP[2][0]_i_1 
       (.I0(\FFxDP_reg[1][0]_0 ),
        .I1(\FFxDP_reg[3][0]_0 [1]),
        .I2(\FFxDP_reg[3][0]_0 [0]),
        .I3(\FFxDP_reg[0][0]_0 [1]),
        .I4(\FFxDP_reg[0][0]_0 [0]),
        .O(\FFxDN[2]_20 [0]));
  LUT5 #(
    .INIT(32'h66965AAA)) 
    \FFxDP[2][1]_i_1 
       (.I0(\FFxDP_reg[1][1]_1 ),
        .I1(\FFxDP_reg[3][0]_0 [1]),
        .I2(\FFxDP_reg[3][0]_0 [0]),
        .I3(\FFxDP_reg[0][0]_0 [1]),
        .I4(\FFxDP_reg[0][0]_0 [0]),
        .O(\FFxDN[2]_20 [1]));
  LUT6 #(
    .INIT(64'h0CC06AA66AA60CC0)) 
    \FFxDP[2][2]_i_3__0 
       (.I0(\FFxDP_reg[2][2] [0]),
        .I1(\FFxDP_reg[2][2] [1]),
        .I2(\FFxDP_reg[2][1]_0 [0]),
        .I3(\FFxDP_reg[3][1]_0 [0]),
        .I4(\FFxDP_reg[2][1]_0 [1]),
        .I5(\FFxDP_reg[3][1]_0 [1]),
        .O(QxDO122_out__4));
  LUT6 #(
    .INIT(64'h0CC06AA66AA60CC0)) 
    \FFxDP[2][2]_i_3__1 
       (.I0(\FFxDP_reg[0][2] [0]),
        .I1(\FFxDP_reg[0][2] [1]),
        .I2(\FFxDP_reg[2][1]_0 [0]),
        .I3(\FFxDP_reg[3][1]_0 [0]),
        .I4(\FFxDP_reg[2][1]_0 [1]),
        .I5(\FFxDP_reg[3][1]_0 [1]),
        .O(QxDO122_out__0__0));
  LUT6 #(
    .INIT(64'h0660ACCAACCA0660)) 
    \FFxDP[2][3]_i_3__0 
       (.I0(\FFxDP_reg[2][2] [0]),
        .I1(\FFxDP_reg[2][2] [1]),
        .I2(\FFxDP_reg[2][1]_0 [0]),
        .I3(\FFxDP_reg[3][1]_0 [0]),
        .I4(\FFxDP_reg[2][1]_0 [1]),
        .I5(\FFxDP_reg[3][1]_0 [1]),
        .O(QxDO124_out__4));
  LUT6 #(
    .INIT(64'h0660ACCAACCA0660)) 
    \FFxDP[2][3]_i_3__1 
       (.I0(\FFxDP_reg[0][2] [0]),
        .I1(\FFxDP_reg[0][2] [1]),
        .I2(\FFxDP_reg[2][1]_0 [0]),
        .I3(\FFxDP_reg[3][1]_0 [0]),
        .I4(\FFxDP_reg[2][1]_0 [1]),
        .I5(\FFxDP_reg[3][1]_0 [1]),
        .O(QxDO124_out__0__0));
  LUT6 #(
    .INIT(64'h0CC06AA66AA60CC0)) 
    \FFxDP[3][2]_i_3__0 
       (.I0(\FFxDP_reg[1][2] [0]),
        .I1(\FFxDP_reg[1][2] [1]),
        .I2(\FFxDP_reg[2][1]_0 [0]),
        .I3(\FFxDP_reg[3][1]_0 [0]),
        .I4(\FFxDP_reg[2][1]_0 [1]),
        .I5(\FFxDP_reg[3][1]_0 [1]),
        .O(QxDO122_out__3));
  LUT6 #(
    .INIT(64'h0CC06AA66AA60CC0)) 
    \FFxDP[3][2]_i_3__1 
       (.I0(\FFxDP_reg[1][2]_0 [0]),
        .I1(\FFxDP_reg[1][2]_0 [1]),
        .I2(\FFxDP_reg[2][1]_0 [0]),
        .I3(\FFxDP_reg[3][1]_0 [0]),
        .I4(\FFxDP_reg[2][1]_0 [1]),
        .I5(\FFxDP_reg[3][1]_0 [1]),
        .O(QxDO122_out__3__0));
  LUT6 #(
    .INIT(64'h0660ACCAACCA0660)) 
    \FFxDP[3][3]_i_3__1 
       (.I0(\FFxDP_reg[1][2]_0 [0]),
        .I1(\FFxDP_reg[1][2]_0 [1]),
        .I2(\FFxDP_reg[2][1]_0 [0]),
        .I3(\FFxDP_reg[3][1]_0 [0]),
        .I4(\FFxDP_reg[2][1]_0 [1]),
        .I5(\FFxDP_reg[3][1]_0 [1]),
        .O(QxDO124_out__3__0));
  LUT6 #(
    .INIT(64'h0660ACCAACCA0660)) 
    \FFxDP[3][3]_i_5__0 
       (.I0(\FFxDP_reg[1][2] [0]),
        .I1(\FFxDP_reg[1][2] [1]),
        .I2(\FFxDP_reg[2][1]_0 [0]),
        .I3(\FFxDP_reg[3][1]_0 [0]),
        .I4(\FFxDP_reg[2][1]_0 [1]),
        .I5(\FFxDP_reg[3][1]_0 [1]),
        .O(QxDO124_out__3));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[0][0] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\Xi_mul_Yj[0]_25 [0]),
        .Q(Q[0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[0][1] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\Xi_mul_Yj[0]_25 [1]),
        .Q(Q[1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[1][0] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\FFxDN[1]_21 [0]),
        .Q(\FFxDP_reg[1][1]_0 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[1][1] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\FFxDN[1]_21 [1]),
        .Q(\FFxDP_reg[1][1]_0 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[2][0] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\FFxDN[2]_20 [0]),
        .Q(\FFxDP_reg[2][1]_0 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[2][1] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\FFxDN[2]_20 [1]),
        .Q(\FFxDP_reg[2][1]_0 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[3][0] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\Xi_mul_Yj[3]_24 [0]),
        .Q(\FFxDP_reg[3][1]_0 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[3][1] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\Xi_mul_Yj[3]_24 [1]),
        .Q(\FFxDP_reg[3][1]_0 [1]),
        .R(\<const0> ));
  GND GND
       (.G(\<const0> ));
  VCC VCC
       (.P(\<const1> ));
  gf2_mul__parameterized0 \gen_inner_multipliers_g[0].gen_outer_multipliers_g[0].gf2_mul 
       (.D(\Xi_mul_Yj[0]_25 ),
        .\FFxDP_reg[0][0] (\FFxDP_reg[0][0]_0 ),
        .\FFxDP_reg[0][0]_0 (\FFxDP_reg[0][0]_1 ));
  gf2_mul__parameterized0_5 \gen_inner_multipliers_g[1].gen_outer_multipliers_g[1].gf2_mul 
       (.D(\Xi_mul_Yj[3]_24 ),
        .\FFxDP_reg[3][0] (\FFxDP_reg[3][0]_1 ),
        .\FFxDP_reg[3][0]_0 (\FFxDP_reg[3][0]_0 ));
endmodule

module shared_mul_gf4
   (D,
    \masked_variant_pipelined_8_staged.Y0xorY12xDP_reg[0][3] ,
    \FFxDP_reg[2][3]_0 ,
    Q,
    \FFxDP_reg[3][3]_0 ,
    \FFxDP_reg[2][2]_0 ,
    \FFxDP_reg[2][0]_0 ,
    \FFxDP_reg[2][1]_0 ,
    CLK,
    \masked_variant_pipelined_8_staged.InverterInxDP_reg[1][3] ,
    \masked_variant_pipelined_8_staged.InverterInxDP_reg[0][3] );
  output [3:0]D;
  output [3:0]\masked_variant_pipelined_8_staged.Y0xorY12xDP_reg[0][3] ;
  input \FFxDP_reg[2][3]_0 ;
  input [7:0]Q;
  input [7:0]\FFxDP_reg[3][3]_0 ;
  input \FFxDP_reg[2][2]_0 ;
  input \FFxDP_reg[2][0]_0 ;
  input \FFxDP_reg[2][1]_0 ;
  input CLK;
  input [3:0]\masked_variant_pipelined_8_staged.InverterInxDP_reg[1][3] ;
  input [3:0]\masked_variant_pipelined_8_staged.InverterInxDP_reg[0][3] ;

  wire \<const0> ;
  wire \<const1> ;
  wire CLK;
  wire [3:0]D;
  wire [3:0]\FFxDN[1]_2 ;
  wire [3:0]\FFxDN[2]_0 ;
  wire \FFxDP[1][3]_i_3_n_0 ;
  wire \FFxDP[2][3]_i_4_n_0 ;
  wire \FFxDP[3][3]_i_2_n_0 ;
  wire \FFxDP[3][3]_i_4_n_0 ;
  wire [3:0]\FFxDP_reg[0]_7 ;
  wire [3:0]\FFxDP_reg[1]_6 ;
  wire \FFxDP_reg[2][0]_0 ;
  wire \FFxDP_reg[2][1]_0 ;
  wire \FFxDP_reg[2][2]_0 ;
  wire \FFxDP_reg[2][3]_0 ;
  wire [3:0]\FFxDP_reg[2]_5 ;
  wire [7:0]\FFxDP_reg[3][3]_0 ;
  wire [3:0]\FFxDP_reg[3]_4 ;
  wire [7:0]Q;
  wire QxDO1;
  wire QxDO122_out;
  wire QxDO122_out__0;
  wire QxDO122_out__1;
  wire QxDO122_out__2;
  wire QxDO124_out;
  wire QxDO124_out__0;
  wire QxDO124_out__1;
  wire QxDO124_out__2;
  wire QxDO13_out;
  wire QxDO13_out__0;
  wire QxDO13_out__1;
  wire QxDO13_out__2;
  wire QxDO1__0;
  wire QxDO1__1;
  wire QxDO1__2;
  wire [3:0]\Xi_mul_Yj[0]_1 ;
  wire [3:0]\Xi_mul_Yj[3]_3 ;
  wire \gen_inner_multipliers_g[0].gen_outer_multipliers_g[0].gf4_mul/p_0_in2_in ;
  wire \gen_inner_multipliers_g[0].gen_outer_multipliers_g[0].gf4_mul/p_1_in3_in ;
  wire \gen_inner_multipliers_g[0].gen_outer_multipliers_g[1].gf4_mul/p_0_in2_in ;
  wire \gen_inner_multipliers_g[1].gen_outer_multipliers_g[0].gf4_mul/p_1_in3_in ;
  wire [3:0]\masked_variant_pipelined_8_staged.InverterInxDP_reg[0][3] ;
  wire [3:0]\masked_variant_pipelined_8_staged.InverterInxDP_reg[1][3] ;
  wire [3:0]\masked_variant_pipelined_8_staged.Y0xorY12xDP_reg[0][3] ;

  LUT6 #(
    .INIT(64'h3993F55FC66C0AA0)) 
    \FFxDP[0][0]_i_1 
       (.I0(\FFxDP[2][3]_i_4_n_0 ),
        .I1(\gen_inner_multipliers_g[0].gen_outer_multipliers_g[0].gf4_mul/p_0_in2_in ),
        .I2(Q[6]),
        .I3(Q[4]),
        .I4(\gen_inner_multipliers_g[0].gen_outer_multipliers_g[0].gf4_mul/p_1_in3_in ),
        .I5(QxDO1__2),
        .O(\Xi_mul_Yj[0]_1 [0]));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT4 #(
    .INIT(16'hA6C0)) 
    \FFxDP[0][0]_i_2 
       (.I0(Q[0]),
        .I1(Q[1]),
        .I2(Q[4]),
        .I3(Q[5]),
        .O(QxDO1__2));
  LUT6 #(
    .INIT(64'h0F9969FFF0669600)) 
    \FFxDP[0][1]_i_1 
       (.I0(Q[5]),
        .I1(Q[7]),
        .I2(\FFxDP[1][3]_i_3_n_0 ),
        .I3(\gen_inner_multipliers_g[0].gen_outer_multipliers_g[0].gf4_mul/p_0_in2_in ),
        .I4(\FFxDP[2][3]_i_4_n_0 ),
        .I5(QxDO13_out__2),
        .O(\Xi_mul_Yj[0]_1 [1]));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT4 #(
    .INIT(16'hCA60)) 
    \FFxDP[0][1]_i_2 
       (.I0(Q[0]),
        .I1(Q[1]),
        .I2(Q[4]),
        .I3(Q[5]),
        .O(QxDO13_out__2));
  LUT6 #(
    .INIT(64'h3993F55FC66C0AA0)) 
    \FFxDP[0][2]_i_1 
       (.I0(\FFxDP[2][3]_i_4_n_0 ),
        .I1(\gen_inner_multipliers_g[0].gen_outer_multipliers_g[0].gf4_mul/p_0_in2_in ),
        .I2(Q[6]),
        .I3(Q[4]),
        .I4(\gen_inner_multipliers_g[0].gen_outer_multipliers_g[0].gf4_mul/p_1_in3_in ),
        .I5(QxDO122_out__2),
        .O(\Xi_mul_Yj[0]_1 [2]));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT4 #(
    .INIT(16'hA6C0)) 
    \FFxDP[0][2]_i_2 
       (.I0(Q[2]),
        .I1(Q[3]),
        .I2(Q[6]),
        .I3(Q[7]),
        .O(QxDO122_out__2));
  LUT6 #(
    .INIT(64'h0F9969FFF0669600)) 
    \FFxDP[0][3]_i_1 
       (.I0(Q[5]),
        .I1(Q[7]),
        .I2(\FFxDP[1][3]_i_3_n_0 ),
        .I3(\gen_inner_multipliers_g[0].gen_outer_multipliers_g[0].gf4_mul/p_0_in2_in ),
        .I4(\FFxDP[2][3]_i_4_n_0 ),
        .I5(QxDO124_out__2),
        .O(\Xi_mul_Yj[0]_1 [3]));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT4 #(
    .INIT(16'hCA60)) 
    \FFxDP[0][3]_i_2 
       (.I0(Q[2]),
        .I1(Q[3]),
        .I2(Q[6]),
        .I3(Q[7]),
        .O(QxDO124_out__2));
  LUT6 #(
    .INIT(64'h6996996696966666)) 
    \FFxDP[1][0]_i_1 
       (.I0(\FFxDP_reg[2][0]_0 ),
        .I1(QxDO1__1),
        .I2(\gen_inner_multipliers_g[0].gen_outer_multipliers_g[0].gf4_mul/p_1_in3_in ),
        .I3(\FFxDP[1][3]_i_3_n_0 ),
        .I4(\gen_inner_multipliers_g[0].gen_outer_multipliers_g[1].gf4_mul/p_0_in2_in ),
        .I5(\FFxDP[3][3]_i_4_n_0 ),
        .O(\FFxDN[1]_2 [0]));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT4 #(
    .INIT(16'hA6C0)) 
    \FFxDP[1][0]_i_2 
       (.I0(\FFxDP_reg[3][3]_0 [0]),
        .I1(\FFxDP_reg[3][3]_0 [1]),
        .I2(Q[4]),
        .I3(Q[5]),
        .O(QxDO1__1));
  LUT6 #(
    .INIT(64'h9696699699666666)) 
    \FFxDP[1][1]_i_1 
       (.I0(\FFxDP_reg[2][1]_0 ),
        .I1(QxDO13_out__1),
        .I2(\FFxDP[3][3]_i_4_n_0 ),
        .I3(\gen_inner_multipliers_g[0].gen_outer_multipliers_g[1].gf4_mul/p_0_in2_in ),
        .I4(\FFxDP[1][3]_i_3_n_0 ),
        .I5(\gen_inner_multipliers_g[0].gen_outer_multipliers_g[0].gf4_mul/p_1_in3_in ),
        .O(\FFxDN[1]_2 [1]));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT4 #(
    .INIT(16'hCA60)) 
    \FFxDP[1][1]_i_2 
       (.I0(\FFxDP_reg[3][3]_0 [0]),
        .I1(\FFxDP_reg[3][3]_0 [1]),
        .I2(Q[4]),
        .I3(Q[5]),
        .O(QxDO13_out__1));
  LUT6 #(
    .INIT(64'h6996996696966666)) 
    \FFxDP[1][2]_i_1 
       (.I0(\FFxDP_reg[2][2]_0 ),
        .I1(QxDO122_out__1),
        .I2(\gen_inner_multipliers_g[0].gen_outer_multipliers_g[0].gf4_mul/p_1_in3_in ),
        .I3(\FFxDP[1][3]_i_3_n_0 ),
        .I4(\gen_inner_multipliers_g[0].gen_outer_multipliers_g[1].gf4_mul/p_0_in2_in ),
        .I5(\FFxDP[3][3]_i_4_n_0 ),
        .O(\FFxDN[1]_2 [2]));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT4 #(
    .INIT(16'hA6C0)) 
    \FFxDP[1][2]_i_2 
       (.I0(\FFxDP_reg[3][3]_0 [2]),
        .I1(\FFxDP_reg[3][3]_0 [3]),
        .I2(Q[6]),
        .I3(Q[7]),
        .O(QxDO122_out__1));
  LUT6 #(
    .INIT(64'h9696699699666666)) 
    \FFxDP[1][3]_i_1 
       (.I0(\FFxDP_reg[2][3]_0 ),
        .I1(QxDO124_out__1),
        .I2(\FFxDP[3][3]_i_4_n_0 ),
        .I3(\gen_inner_multipliers_g[0].gen_outer_multipliers_g[1].gf4_mul/p_0_in2_in ),
        .I4(\FFxDP[1][3]_i_3_n_0 ),
        .I5(\gen_inner_multipliers_g[0].gen_outer_multipliers_g[0].gf4_mul/p_1_in3_in ),
        .O(\FFxDN[1]_2 [3]));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT4 #(
    .INIT(16'hCA60)) 
    \FFxDP[1][3]_i_2 
       (.I0(\FFxDP_reg[3][3]_0 [2]),
        .I1(\FFxDP_reg[3][3]_0 [3]),
        .I2(Q[6]),
        .I3(Q[7]),
        .O(QxDO124_out__1));
  LUT2 #(
    .INIT(4'h6)) 
    \FFxDP[1][3]_i_3 
       (.I0(Q[4]),
        .I1(Q[6]),
        .O(\FFxDP[1][3]_i_3_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \FFxDP[1][3]_i_4 
       (.I0(Q[5]),
        .I1(Q[7]),
        .O(\gen_inner_multipliers_g[0].gen_outer_multipliers_g[0].gf4_mul/p_1_in3_in ));
  LUT6 #(
    .INIT(64'h6996996696966666)) 
    \FFxDP[2][0]_i_1 
       (.I0(\FFxDP_reg[2][0]_0 ),
        .I1(QxDO1__0),
        .I2(\gen_inner_multipliers_g[1].gen_outer_multipliers_g[0].gf4_mul/p_1_in3_in ),
        .I3(\FFxDP[3][3]_i_2_n_0 ),
        .I4(\gen_inner_multipliers_g[0].gen_outer_multipliers_g[0].gf4_mul/p_0_in2_in ),
        .I5(\FFxDP[2][3]_i_4_n_0 ),
        .O(\FFxDN[2]_0 [0]));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT4 #(
    .INIT(16'hA6C0)) 
    \FFxDP[2][0]_i_3 
       (.I0(Q[0]),
        .I1(Q[1]),
        .I2(\FFxDP_reg[3][3]_0 [4]),
        .I3(\FFxDP_reg[3][3]_0 [5]),
        .O(QxDO1__0));
  LUT6 #(
    .INIT(64'h9696699699666666)) 
    \FFxDP[2][1]_i_1 
       (.I0(\FFxDP_reg[2][1]_0 ),
        .I1(QxDO13_out__0),
        .I2(\FFxDP[2][3]_i_4_n_0 ),
        .I3(\gen_inner_multipliers_g[0].gen_outer_multipliers_g[0].gf4_mul/p_0_in2_in ),
        .I4(\FFxDP[3][3]_i_2_n_0 ),
        .I5(\gen_inner_multipliers_g[1].gen_outer_multipliers_g[0].gf4_mul/p_1_in3_in ),
        .O(\FFxDN[2]_0 [1]));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT4 #(
    .INIT(16'hCA60)) 
    \FFxDP[2][1]_i_3 
       (.I0(Q[0]),
        .I1(Q[1]),
        .I2(\FFxDP_reg[3][3]_0 [4]),
        .I3(\FFxDP_reg[3][3]_0 [5]),
        .O(QxDO13_out__0));
  LUT6 #(
    .INIT(64'h6996996696966666)) 
    \FFxDP[2][2]_i_1 
       (.I0(\FFxDP_reg[2][2]_0 ),
        .I1(QxDO122_out__0),
        .I2(\gen_inner_multipliers_g[1].gen_outer_multipliers_g[0].gf4_mul/p_1_in3_in ),
        .I3(\FFxDP[3][3]_i_2_n_0 ),
        .I4(\gen_inner_multipliers_g[0].gen_outer_multipliers_g[0].gf4_mul/p_0_in2_in ),
        .I5(\FFxDP[2][3]_i_4_n_0 ),
        .O(\FFxDN[2]_0 [2]));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT4 #(
    .INIT(16'hA6C0)) 
    \FFxDP[2][2]_i_3 
       (.I0(Q[2]),
        .I1(Q[3]),
        .I2(\FFxDP_reg[3][3]_0 [6]),
        .I3(\FFxDP_reg[3][3]_0 [7]),
        .O(QxDO122_out__0));
  LUT6 #(
    .INIT(64'h9696699699666666)) 
    \FFxDP[2][3]_i_1 
       (.I0(\FFxDP_reg[2][3]_0 ),
        .I1(QxDO124_out__0),
        .I2(\FFxDP[2][3]_i_4_n_0 ),
        .I3(\gen_inner_multipliers_g[0].gen_outer_multipliers_g[0].gf4_mul/p_0_in2_in ),
        .I4(\FFxDP[3][3]_i_2_n_0 ),
        .I5(\gen_inner_multipliers_g[1].gen_outer_multipliers_g[0].gf4_mul/p_1_in3_in ),
        .O(\FFxDN[2]_0 [3]));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT4 #(
    .INIT(16'hCA60)) 
    \FFxDP[2][3]_i_3 
       (.I0(Q[2]),
        .I1(Q[3]),
        .I2(\FFxDP_reg[3][3]_0 [6]),
        .I3(\FFxDP_reg[3][3]_0 [7]),
        .O(QxDO124_out__0));
  LUT2 #(
    .INIT(4'h6)) 
    \FFxDP[2][3]_i_4 
       (.I0(Q[0]),
        .I1(Q[2]),
        .O(\FFxDP[2][3]_i_4_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \FFxDP[2][3]_i_5 
       (.I0(Q[1]),
        .I1(Q[3]),
        .O(\gen_inner_multipliers_g[0].gen_outer_multipliers_g[0].gf4_mul/p_0_in2_in ));
  LUT6 #(
    .INIT(64'h3993F55FC66C0AA0)) 
    \FFxDP[3][0]_i_1 
       (.I0(\FFxDP[3][3]_i_4_n_0 ),
        .I1(\gen_inner_multipliers_g[0].gen_outer_multipliers_g[1].gf4_mul/p_0_in2_in ),
        .I2(\FFxDP_reg[3][3]_0 [6]),
        .I3(\FFxDP_reg[3][3]_0 [4]),
        .I4(\gen_inner_multipliers_g[1].gen_outer_multipliers_g[0].gf4_mul/p_1_in3_in ),
        .I5(QxDO1),
        .O(\Xi_mul_Yj[3]_3 [0]));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT4 #(
    .INIT(16'hA6C0)) 
    \FFxDP[3][0]_i_2 
       (.I0(\FFxDP_reg[3][3]_0 [0]),
        .I1(\FFxDP_reg[3][3]_0 [1]),
        .I2(\FFxDP_reg[3][3]_0 [4]),
        .I3(\FFxDP_reg[3][3]_0 [5]),
        .O(QxDO1));
  LUT6 #(
    .INIT(64'h0F9969FFF0669600)) 
    \FFxDP[3][1]_i_1 
       (.I0(\FFxDP_reg[3][3]_0 [5]),
        .I1(\FFxDP_reg[3][3]_0 [7]),
        .I2(\FFxDP[3][3]_i_2_n_0 ),
        .I3(\gen_inner_multipliers_g[0].gen_outer_multipliers_g[1].gf4_mul/p_0_in2_in ),
        .I4(\FFxDP[3][3]_i_4_n_0 ),
        .I5(QxDO13_out),
        .O(\Xi_mul_Yj[3]_3 [1]));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT4 #(
    .INIT(16'hCA60)) 
    \FFxDP[3][1]_i_2 
       (.I0(\FFxDP_reg[3][3]_0 [0]),
        .I1(\FFxDP_reg[3][3]_0 [1]),
        .I2(\FFxDP_reg[3][3]_0 [4]),
        .I3(\FFxDP_reg[3][3]_0 [5]),
        .O(QxDO13_out));
  LUT6 #(
    .INIT(64'h3993F55FC66C0AA0)) 
    \FFxDP[3][2]_i_1 
       (.I0(\FFxDP[3][3]_i_4_n_0 ),
        .I1(\gen_inner_multipliers_g[0].gen_outer_multipliers_g[1].gf4_mul/p_0_in2_in ),
        .I2(\FFxDP_reg[3][3]_0 [6]),
        .I3(\FFxDP_reg[3][3]_0 [4]),
        .I4(\gen_inner_multipliers_g[1].gen_outer_multipliers_g[0].gf4_mul/p_1_in3_in ),
        .I5(QxDO122_out),
        .O(\Xi_mul_Yj[3]_3 [2]));
  LUT2 #(
    .INIT(4'h6)) 
    \FFxDP[3][2]_i_2 
       (.I0(\FFxDP_reg[3][3]_0 [5]),
        .I1(\FFxDP_reg[3][3]_0 [7]),
        .O(\gen_inner_multipliers_g[1].gen_outer_multipliers_g[0].gf4_mul/p_1_in3_in ));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT4 #(
    .INIT(16'hA6C0)) 
    \FFxDP[3][2]_i_3 
       (.I0(\FFxDP_reg[3][3]_0 [2]),
        .I1(\FFxDP_reg[3][3]_0 [3]),
        .I2(\FFxDP_reg[3][3]_0 [6]),
        .I3(\FFxDP_reg[3][3]_0 [7]),
        .O(QxDO122_out));
  LUT6 #(
    .INIT(64'h0F9969FFF0669600)) 
    \FFxDP[3][3]_i_1 
       (.I0(\FFxDP_reg[3][3]_0 [5]),
        .I1(\FFxDP_reg[3][3]_0 [7]),
        .I2(\FFxDP[3][3]_i_2_n_0 ),
        .I3(\gen_inner_multipliers_g[0].gen_outer_multipliers_g[1].gf4_mul/p_0_in2_in ),
        .I4(\FFxDP[3][3]_i_4_n_0 ),
        .I5(QxDO124_out),
        .O(\Xi_mul_Yj[3]_3 [3]));
  LUT2 #(
    .INIT(4'h6)) 
    \FFxDP[3][3]_i_2 
       (.I0(\FFxDP_reg[3][3]_0 [4]),
        .I1(\FFxDP_reg[3][3]_0 [6]),
        .O(\FFxDP[3][3]_i_2_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \FFxDP[3][3]_i_3 
       (.I0(\FFxDP_reg[3][3]_0 [1]),
        .I1(\FFxDP_reg[3][3]_0 [3]),
        .O(\gen_inner_multipliers_g[0].gen_outer_multipliers_g[1].gf4_mul/p_0_in2_in ));
  LUT2 #(
    .INIT(4'h6)) 
    \FFxDP[3][3]_i_4 
       (.I0(\FFxDP_reg[3][3]_0 [0]),
        .I1(\FFxDP_reg[3][3]_0 [2]),
        .O(\FFxDP[3][3]_i_4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT4 #(
    .INIT(16'hCA60)) 
    \FFxDP[3][3]_i_5 
       (.I0(\FFxDP_reg[3][3]_0 [2]),
        .I1(\FFxDP_reg[3][3]_0 [3]),
        .I2(\FFxDP_reg[3][3]_0 [6]),
        .I3(\FFxDP_reg[3][3]_0 [7]),
        .O(QxDO124_out));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[0][0] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\Xi_mul_Yj[0]_1 [0]),
        .Q(\FFxDP_reg[0]_7 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[0][1] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\Xi_mul_Yj[0]_1 [1]),
        .Q(\FFxDP_reg[0]_7 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[0][2] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\Xi_mul_Yj[0]_1 [2]),
        .Q(\FFxDP_reg[0]_7 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[0][3] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\Xi_mul_Yj[0]_1 [3]),
        .Q(\FFxDP_reg[0]_7 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[1][0] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\FFxDN[1]_2 [0]),
        .Q(\FFxDP_reg[1]_6 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[1][1] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\FFxDN[1]_2 [1]),
        .Q(\FFxDP_reg[1]_6 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[1][2] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\FFxDN[1]_2 [2]),
        .Q(\FFxDP_reg[1]_6 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[1][3] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\FFxDN[1]_2 [3]),
        .Q(\FFxDP_reg[1]_6 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[2][0] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\FFxDN[2]_0 [0]),
        .Q(\FFxDP_reg[2]_5 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[2][1] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\FFxDN[2]_0 [1]),
        .Q(\FFxDP_reg[2]_5 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[2][2] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\FFxDN[2]_0 [2]),
        .Q(\FFxDP_reg[2]_5 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[2][3] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\FFxDN[2]_0 [3]),
        .Q(\FFxDP_reg[2]_5 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[3][0] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\Xi_mul_Yj[3]_3 [0]),
        .Q(\FFxDP_reg[3]_4 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[3][1] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\Xi_mul_Yj[3]_3 [1]),
        .Q(\FFxDP_reg[3]_4 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[3][2] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\Xi_mul_Yj[3]_3 [2]),
        .Q(\FFxDP_reg[3]_4 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[3][3] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\Xi_mul_Yj[3]_3 [3]),
        .Q(\FFxDP_reg[3]_4 [3]),
        .R(\<const0> ));
  GND GND
       (.G(\<const0> ));
  VCC VCC
       (.P(\<const1> ));
  LUT3 #(
    .INIT(8'h96)) 
    \masked_variant_pipelined_8_staged.InverterInxDP[0][0]_i_1 
       (.I0(\masked_variant_pipelined_8_staged.InverterInxDP_reg[0][3] [0]),
        .I1(\FFxDP_reg[0]_7 [0]),
        .I2(\FFxDP_reg[1]_6 [0]),
        .O(\masked_variant_pipelined_8_staged.Y0xorY12xDP_reg[0][3] [0]));
  LUT3 #(
    .INIT(8'h96)) 
    \masked_variant_pipelined_8_staged.InverterInxDP[0][1]_i_1 
       (.I0(\masked_variant_pipelined_8_staged.InverterInxDP_reg[0][3] [1]),
        .I1(\FFxDP_reg[0]_7 [1]),
        .I2(\FFxDP_reg[1]_6 [1]),
        .O(\masked_variant_pipelined_8_staged.Y0xorY12xDP_reg[0][3] [1]));
  LUT3 #(
    .INIT(8'h96)) 
    \masked_variant_pipelined_8_staged.InverterInxDP[0][2]_i_1 
       (.I0(\masked_variant_pipelined_8_staged.InverterInxDP_reg[0][3] [2]),
        .I1(\FFxDP_reg[0]_7 [2]),
        .I2(\FFxDP_reg[1]_6 [2]),
        .O(\masked_variant_pipelined_8_staged.Y0xorY12xDP_reg[0][3] [2]));
  LUT3 #(
    .INIT(8'h96)) 
    \masked_variant_pipelined_8_staged.InverterInxDP[0][3]_i_1 
       (.I0(\masked_variant_pipelined_8_staged.InverterInxDP_reg[0][3] [3]),
        .I1(\FFxDP_reg[0]_7 [3]),
        .I2(\FFxDP_reg[1]_6 [3]),
        .O(\masked_variant_pipelined_8_staged.Y0xorY12xDP_reg[0][3] [3]));
  LUT3 #(
    .INIT(8'h96)) 
    \masked_variant_pipelined_8_staged.InverterInxDP[1][0]_i_1 
       (.I0(\masked_variant_pipelined_8_staged.InverterInxDP_reg[1][3] [0]),
        .I1(\FFxDP_reg[2]_5 [0]),
        .I2(\FFxDP_reg[3]_4 [0]),
        .O(D[0]));
  LUT3 #(
    .INIT(8'h96)) 
    \masked_variant_pipelined_8_staged.InverterInxDP[1][1]_i_1 
       (.I0(\masked_variant_pipelined_8_staged.InverterInxDP_reg[1][3] [1]),
        .I1(\FFxDP_reg[2]_5 [1]),
        .I2(\FFxDP_reg[3]_4 [1]),
        .O(D[1]));
  LUT3 #(
    .INIT(8'h96)) 
    \masked_variant_pipelined_8_staged.InverterInxDP[1][2]_i_1 
       (.I0(\masked_variant_pipelined_8_staged.InverterInxDP_reg[1][3] [2]),
        .I1(\FFxDP_reg[2]_5 [2]),
        .I2(\FFxDP_reg[3]_4 [2]),
        .O(D[2]));
  LUT3 #(
    .INIT(8'h96)) 
    \masked_variant_pipelined_8_staged.InverterInxDP[1][3]_i_1 
       (.I0(\masked_variant_pipelined_8_staged.InverterInxDP_reg[1][3] [3]),
        .I1(\FFxDP_reg[2]_5 [3]),
        .I2(\FFxDP_reg[3]_4 [3]),
        .O(D[3]));
endmodule

(* ORIG_REF_NAME = "shared_mul_gf4" *) 
module shared_mul_gf4_1
   (\QxDO[1]_OBUF ,
    Q,
    \FFxDP_reg[2][3]_0 ,
    \QxDO[0]_OBUF ,
    \FFxDP_reg[1][3]_0 ,
    \FFxDP_reg[0][3]_0 ,
    p_0_in2_in,
    \masked_variant_pipelined_8_staged.Y1_4xDP_reg[0][0] ,
    p_0_in2_in_0,
    \masked_variant_pipelined_8_staged.Y1_4xDP_reg[1][0] ,
    \QxDO[1][2] ,
    \QxDO[1][5] ,
    \QxDO[1][5]_0 ,
    \QxDO[0][2] ,
    \QxDO[0][5] ,
    \QxDO[0][5]_0 ,
    \FFxDP_reg[0][0]_0 ,
    \FFxDP_reg[1][1]_0 ,
    D,
    CLK,
    \FFxDP_reg[2][3]_1 ,
    \FFxDP_reg[1][3]_1 ,
    \FFxDP_reg[0][3]_1 );
  output [2:0]\QxDO[1]_OBUF ;
  output [1:0]Q;
  output [1:0]\FFxDP_reg[2][3]_0 ;
  output [2:0]\QxDO[0]_OBUF ;
  output [1:0]\FFxDP_reg[1][3]_0 ;
  output [1:0]\FFxDP_reg[0][3]_0 ;
  output p_0_in2_in;
  output \masked_variant_pipelined_8_staged.Y1_4xDP_reg[0][0] ;
  output p_0_in2_in_0;
  output \masked_variant_pipelined_8_staged.Y1_4xDP_reg[1][0] ;
  input \QxDO[1][2] ;
  input [1:0]\QxDO[1][5] ;
  input [1:0]\QxDO[1][5]_0 ;
  input \QxDO[0][2] ;
  input [1:0]\QxDO[0][5] ;
  input [1:0]\QxDO[0][5]_0 ;
  input [3:0]\FFxDP_reg[0][0]_0 ;
  input [3:0]\FFxDP_reg[1][1]_0 ;
  input [3:0]D;
  input CLK;
  input [3:0]\FFxDP_reg[2][3]_1 ;
  input [3:0]\FFxDP_reg[1][3]_1 ;
  input [3:0]\FFxDP_reg[0][3]_1 ;

  wire \<const0> ;
  wire \<const1> ;
  wire CLK;
  wire [3:0]D;
  wire [3:0]\FFxDP_reg[0][0]_0 ;
  wire [1:0]\FFxDP_reg[0][3]_0 ;
  wire [3:0]\FFxDP_reg[0][3]_1 ;
  wire [2:0]\FFxDP_reg[0]_3 ;
  wire [3:0]\FFxDP_reg[1][1]_0 ;
  wire [1:0]\FFxDP_reg[1][3]_0 ;
  wire [3:0]\FFxDP_reg[1][3]_1 ;
  wire [2:0]\FFxDP_reg[1]_2 ;
  wire [1:0]\FFxDP_reg[2][3]_0 ;
  wire [3:0]\FFxDP_reg[2][3]_1 ;
  wire [2:0]\FFxDP_reg[2]_1 ;
  wire [2:0]\FFxDP_reg[3]_0 ;
  wire [1:0]Q;
  wire \QxDO[0][2] ;
  wire [1:0]\QxDO[0][5] ;
  wire [1:0]\QxDO[0][5]_0 ;
  wire [2:0]\QxDO[0]_OBUF ;
  wire \QxDO[1][2] ;
  wire [1:0]\QxDO[1][5] ;
  wire [1:0]\QxDO[1][5]_0 ;
  wire [2:0]\QxDO[1]_OBUF ;
  wire \masked_variant_pipelined_8_staged.Y1_4xDP_reg[0][0] ;
  wire \masked_variant_pipelined_8_staged.Y1_4xDP_reg[1][0] ;
  wire p_0_in2_in;
  wire p_0_in2_in_0;

  LUT2 #(
    .INIT(4'h6)) 
    \FFxDP[2][3]_i_4__1 
       (.I0(\FFxDP_reg[0][0]_0 [0]),
        .I1(\FFxDP_reg[0][0]_0 [2]),
        .O(\masked_variant_pipelined_8_staged.Y1_4xDP_reg[0][0] ));
  LUT2 #(
    .INIT(4'h6)) 
    \FFxDP[2][3]_i_5__1 
       (.I0(\FFxDP_reg[0][0]_0 [1]),
        .I1(\FFxDP_reg[0][0]_0 [3]),
        .O(p_0_in2_in));
  LUT2 #(
    .INIT(4'h6)) 
    \FFxDP[3][2]_i_2__1 
       (.I0(\FFxDP_reg[1][1]_0 [1]),
        .I1(\FFxDP_reg[1][1]_0 [3]),
        .O(p_0_in2_in_0));
  LUT2 #(
    .INIT(4'h6)) 
    \FFxDP[3][3]_i_2__1 
       (.I0(\FFxDP_reg[1][1]_0 [0]),
        .I1(\FFxDP_reg[1][1]_0 [2]),
        .O(\masked_variant_pipelined_8_staged.Y1_4xDP_reg[1][0] ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[0][0] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\FFxDP_reg[0][3]_1 [0]),
        .Q(\FFxDP_reg[0]_3 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[0][1] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\FFxDP_reg[0][3]_1 [1]),
        .Q(\FFxDP_reg[0][3]_0 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[0][2] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\FFxDP_reg[0][3]_1 [2]),
        .Q(\FFxDP_reg[0]_3 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[0][3] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\FFxDP_reg[0][3]_1 [3]),
        .Q(\FFxDP_reg[0][3]_0 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[1][0] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\FFxDP_reg[1][3]_1 [0]),
        .Q(\FFxDP_reg[1]_2 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[1][1] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\FFxDP_reg[1][3]_1 [1]),
        .Q(\FFxDP_reg[1][3]_0 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[1][2] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\FFxDP_reg[1][3]_1 [2]),
        .Q(\FFxDP_reg[1]_2 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[1][3] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\FFxDP_reg[1][3]_1 [3]),
        .Q(\FFxDP_reg[1][3]_0 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[2][0] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\FFxDP_reg[2][3]_1 [0]),
        .Q(\FFxDP_reg[2]_1 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[2][1] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\FFxDP_reg[2][3]_1 [1]),
        .Q(\FFxDP_reg[2][3]_0 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[2][2] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\FFxDP_reg[2][3]_1 [2]),
        .Q(\FFxDP_reg[2]_1 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[2][3] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\FFxDP_reg[2][3]_1 [3]),
        .Q(\FFxDP_reg[2][3]_0 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[3][0] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(D[0]),
        .Q(\FFxDP_reg[3]_0 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[3][1] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(D[1]),
        .Q(Q[0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[3][2] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(D[2]),
        .Q(\FFxDP_reg[3]_0 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[3][3] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(D[3]),
        .Q(Q[1]),
        .R(\<const0> ));
  GND GND
       (.G(\<const0> ));
  LUT5 #(
    .INIT(32'h96696996)) 
    \QxDO[0][2]_INST_0_i_1 
       (.I0(\FFxDP_reg[1]_2 [0]),
        .I1(\FFxDP_reg[0]_3 [0]),
        .I2(\FFxDP_reg[1]_2 [2]),
        .I3(\FFxDP_reg[0]_3 [2]),
        .I4(\QxDO[0][2] ),
        .O(\QxDO[0]_OBUF [0]));
  LUT4 #(
    .INIT(16'h9669)) 
    \QxDO[0][5]_INST_0_i_1 
       (.I0(\FFxDP_reg[0]_3 [0]),
        .I1(\FFxDP_reg[1]_2 [0]),
        .I2(\QxDO[0][5] [1]),
        .I3(\QxDO[0][5]_0 [1]),
        .O(\QxDO[0]_OBUF [1]));
  LUT4 #(
    .INIT(16'h6996)) 
    \QxDO[0][7]_INST_0_i_1 
       (.I0(\FFxDP_reg[0][3]_0 [1]),
        .I1(\FFxDP_reg[1][3]_0 [1]),
        .I2(\QxDO[0][5] [0]),
        .I3(\QxDO[0][5]_0 [0]),
        .O(\QxDO[0]_OBUF [2]));
  LUT5 #(
    .INIT(32'h96696996)) 
    \QxDO[1][2]_INST_0_i_1 
       (.I0(\FFxDP_reg[3]_0 [0]),
        .I1(\FFxDP_reg[2]_1 [0]),
        .I2(\FFxDP_reg[3]_0 [2]),
        .I3(\FFxDP_reg[2]_1 [2]),
        .I4(\QxDO[1][2] ),
        .O(\QxDO[1]_OBUF [0]));
  LUT4 #(
    .INIT(16'h6996)) 
    \QxDO[1][5]_INST_0_i_1 
       (.I0(\FFxDP_reg[2]_1 [0]),
        .I1(\FFxDP_reg[3]_0 [0]),
        .I2(\QxDO[1][5] [1]),
        .I3(\QxDO[1][5]_0 [1]),
        .O(\QxDO[1]_OBUF [1]));
  LUT4 #(
    .INIT(16'h6996)) 
    \QxDO[1][7]_INST_0_i_1 
       (.I0(\FFxDP_reg[2][3]_0 [1]),
        .I1(Q[1]),
        .I2(\QxDO[1][5] [0]),
        .I3(\QxDO[1][5]_0 [0]),
        .O(\QxDO[1]_OBUF [2]));
  VCC VCC
       (.P(\<const1> ));
endmodule

(* ORIG_REF_NAME = "shared_mul_gf4" *) 
module shared_mul_gf4_2
   (\QxDO[1]_OBUF ,
    Q,
    \FFxDP_reg[2][2]_0 ,
    \FFxDP_reg[3][1]_0 ,
    \QxDO[0]_OBUF ,
    \FFxDP_reg[1][2]_0 ,
    \FFxDP_reg[0][2]_0 ,
    \FFxDP_reg[1][1]_0 ,
    p_0_in2_in,
    \masked_variant_pipelined_8_staged.Y0_4xDP_reg[0][0] ,
    p_0_in2_in_0,
    \masked_variant_pipelined_8_staged.Y0_4xDP_reg[1][0] ,
    \QxDO[1][4] ,
    \QxDO[1][4]_0 ,
    \QxDO[0][4] ,
    \QxDO[0][4]_0 ,
    \FFxDP_reg[2][3]_0 ,
    \FFxDP_reg[1][3]_0 ,
    D,
    CLK,
    \FFxDP_reg[2][3]_1 ,
    \FFxDP_reg[1][3]_1 ,
    \FFxDP_reg[0][3]_0 );
  output [4:0]\QxDO[1]_OBUF ;
  output [1:0]Q;
  output [1:0]\FFxDP_reg[2][2]_0 ;
  output \FFxDP_reg[3][1]_0 ;
  output [4:0]\QxDO[0]_OBUF ;
  output [1:0]\FFxDP_reg[1][2]_0 ;
  output [1:0]\FFxDP_reg[0][2]_0 ;
  output \FFxDP_reg[1][1]_0 ;
  output p_0_in2_in;
  output \masked_variant_pipelined_8_staged.Y0_4xDP_reg[0][0] ;
  output p_0_in2_in_0;
  output \masked_variant_pipelined_8_staged.Y0_4xDP_reg[1][0] ;
  input [1:0]\QxDO[1][4] ;
  input [1:0]\QxDO[1][4]_0 ;
  input [1:0]\QxDO[0][4] ;
  input [1:0]\QxDO[0][4]_0 ;
  input [3:0]\FFxDP_reg[2][3]_0 ;
  input [3:0]\FFxDP_reg[1][3]_0 ;
  input [3:0]D;
  input CLK;
  input [3:0]\FFxDP_reg[2][3]_1 ;
  input [3:0]\FFxDP_reg[1][3]_1 ;
  input [3:0]\FFxDP_reg[0][3]_0 ;

  wire \<const0> ;
  wire \<const1> ;
  wire CLK;
  wire [3:0]D;
  wire [1:0]\FFxDP_reg[0][2]_0 ;
  wire [3:0]\FFxDP_reg[0][3]_0 ;
  wire [3:0]\FFxDP_reg[0]_3 ;
  wire \FFxDP_reg[1][1]_0 ;
  wire [1:0]\FFxDP_reg[1][2]_0 ;
  wire [3:0]\FFxDP_reg[1][3]_0 ;
  wire [3:0]\FFxDP_reg[1][3]_1 ;
  wire [3:0]\FFxDP_reg[1]_2 ;
  wire [1:0]\FFxDP_reg[2][2]_0 ;
  wire [3:0]\FFxDP_reg[2][3]_0 ;
  wire [3:0]\FFxDP_reg[2][3]_1 ;
  wire [3:0]\FFxDP_reg[2]_1 ;
  wire \FFxDP_reg[3][1]_0 ;
  wire [3:0]\FFxDP_reg[3]_0 ;
  wire [1:0]Q;
  wire [1:0]\QxDO[0][4] ;
  wire [1:0]\QxDO[0][4]_0 ;
  wire [4:0]\QxDO[0]_OBUF ;
  wire [1:0]\QxDO[1][4] ;
  wire [1:0]\QxDO[1][4]_0 ;
  wire [4:0]\QxDO[1]_OBUF ;
  wire \masked_variant_pipelined_8_staged.Y0_4xDP_reg[0][0] ;
  wire \masked_variant_pipelined_8_staged.Y0_4xDP_reg[1][0] ;
  wire p_0_in2_in;
  wire p_0_in2_in_0;

  LUT2 #(
    .INIT(4'h6)) 
    \FFxDP[2][3]_i_4__0 
       (.I0(\FFxDP_reg[2][3]_0 [0]),
        .I1(\FFxDP_reg[2][3]_0 [2]),
        .O(\masked_variant_pipelined_8_staged.Y0_4xDP_reg[0][0] ));
  LUT2 #(
    .INIT(4'h6)) 
    \FFxDP[2][3]_i_5__0 
       (.I0(\FFxDP_reg[2][3]_0 [1]),
        .I1(\FFxDP_reg[2][3]_0 [3]),
        .O(p_0_in2_in));
  LUT2 #(
    .INIT(4'h6)) 
    \FFxDP[3][2]_i_2__0 
       (.I0(\FFxDP_reg[1][3]_0 [1]),
        .I1(\FFxDP_reg[1][3]_0 [3]),
        .O(p_0_in2_in_0));
  LUT2 #(
    .INIT(4'h6)) 
    \FFxDP[3][3]_i_4__0 
       (.I0(\FFxDP_reg[1][3]_0 [0]),
        .I1(\FFxDP_reg[1][3]_0 [2]),
        .O(\masked_variant_pipelined_8_staged.Y0_4xDP_reg[1][0] ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[0][0] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\FFxDP_reg[0][3]_0 [0]),
        .Q(\FFxDP_reg[0]_3 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[0][1] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\FFxDP_reg[0][3]_0 [1]),
        .Q(\FFxDP_reg[0][2]_0 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[0][2] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\FFxDP_reg[0][3]_0 [2]),
        .Q(\FFxDP_reg[0][2]_0 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[0][3] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\FFxDP_reg[0][3]_0 [3]),
        .Q(\FFxDP_reg[0]_3 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[1][0] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\FFxDP_reg[1][3]_1 [0]),
        .Q(\FFxDP_reg[1]_2 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[1][1] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\FFxDP_reg[1][3]_1 [1]),
        .Q(\FFxDP_reg[1][2]_0 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[1][2] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\FFxDP_reg[1][3]_1 [2]),
        .Q(\FFxDP_reg[1][2]_0 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[1][3] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\FFxDP_reg[1][3]_1 [3]),
        .Q(\FFxDP_reg[1]_2 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[2][0] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\FFxDP_reg[2][3]_1 [0]),
        .Q(\FFxDP_reg[2]_1 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[2][1] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\FFxDP_reg[2][3]_1 [1]),
        .Q(\FFxDP_reg[2][2]_0 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[2][2] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\FFxDP_reg[2][3]_1 [2]),
        .Q(\FFxDP_reg[2][2]_0 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[2][3] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(\FFxDP_reg[2][3]_1 [3]),
        .Q(\FFxDP_reg[2]_1 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[3][0] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(D[0]),
        .Q(\FFxDP_reg[3]_0 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[3][1] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(D[1]),
        .Q(Q[0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[3][2] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(D[2]),
        .Q(Q[1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \FFxDP_reg[3][3] 
       (.C(CLK),
        .CE(\<const1> ),
        .D(D[3]),
        .Q(\FFxDP_reg[3]_0 [3]),
        .R(\<const0> ));
  GND GND
       (.G(\<const0> ));
  LUT6 #(
    .INIT(64'h9669699669969669)) 
    \QxDO[0][0]_INST_0_i_1 
       (.I0(\FFxDP_reg[1]_2 [0]),
        .I1(\FFxDP_reg[0]_3 [0]),
        .I2(\QxDO[0][4] [0]),
        .I3(\QxDO[0][4]_0 [0]),
        .I4(\FFxDP_reg[0][2]_0 [1]),
        .I5(\FFxDP_reg[1][2]_0 [1]),
        .O(\QxDO[0]_OBUF [0]));
  LUT6 #(
    .INIT(64'h9669699669969669)) 
    \QxDO[0][1]_INST_0_i_1 
       (.I0(\FFxDP_reg[1]_2 [0]),
        .I1(\FFxDP_reg[0]_3 [0]),
        .I2(\QxDO[0][4] [0]),
        .I3(\QxDO[0][4]_0 [0]),
        .I4(\FFxDP_reg[0][2]_0 [0]),
        .I5(\FFxDP_reg[1][2]_0 [0]),
        .O(\QxDO[0]_OBUF [1]));
  LUT5 #(
    .INIT(32'h96696996)) 
    \QxDO[0][3]_INST_0_i_1 
       (.I0(\FFxDP_reg[1]_2 [0]),
        .I1(\FFxDP_reg[0]_3 [0]),
        .I2(\FFxDP_reg[1]_2 [3]),
        .I3(\FFxDP_reg[0]_3 [3]),
        .I4(\FFxDP_reg[1][1]_0 ),
        .O(\QxDO[0]_OBUF [2]));
  LUT6 #(
    .INIT(64'h6996966996696996)) 
    \QxDO[0][3]_INST_0_i_2 
       (.I0(\FFxDP_reg[1][2]_0 [0]),
        .I1(\FFxDP_reg[0][2]_0 [0]),
        .I2(\QxDO[0][4] [1]),
        .I3(\QxDO[0][4]_0 [1]),
        .I4(\FFxDP_reg[0][2]_0 [1]),
        .I5(\FFxDP_reg[1][2]_0 [1]),
        .O(\FFxDP_reg[1][1]_0 ));
  LUT6 #(
    .INIT(64'h6996966996696996)) 
    \QxDO[0][4]_INST_0_i_1 
       (.I0(\FFxDP_reg[0]_3 [3]),
        .I1(\FFxDP_reg[1]_2 [3]),
        .I2(\FFxDP_reg[1][2]_0 [0]),
        .I3(\FFxDP_reg[0][2]_0 [0]),
        .I4(\QxDO[0][4] [1]),
        .I5(\QxDO[0][4]_0 [1]),
        .O(\QxDO[0]_OBUF [3]));
  LUT4 #(
    .INIT(16'h9669)) 
    \QxDO[0][6]_INST_0_i_1 
       (.I0(\FFxDP_reg[0]_3 [3]),
        .I1(\FFxDP_reg[1]_2 [3]),
        .I2(\QxDO[0][4]_0 [1]),
        .I3(\QxDO[0][4] [1]),
        .O(\QxDO[0]_OBUF [4]));
  LUT6 #(
    .INIT(64'h6996966996696996)) 
    \QxDO[1][0]_INST_0_i_1 
       (.I0(\FFxDP_reg[3]_0 [0]),
        .I1(\FFxDP_reg[2]_1 [0]),
        .I2(\QxDO[1][4] [0]),
        .I3(\QxDO[1][4]_0 [0]),
        .I4(\FFxDP_reg[2][2]_0 [1]),
        .I5(Q[1]),
        .O(\QxDO[1]_OBUF [0]));
  LUT6 #(
    .INIT(64'h6996966996696996)) 
    \QxDO[1][1]_INST_0_i_1 
       (.I0(\FFxDP_reg[3]_0 [0]),
        .I1(\FFxDP_reg[2]_1 [0]),
        .I2(\QxDO[1][4] [0]),
        .I3(\QxDO[1][4]_0 [0]),
        .I4(\FFxDP_reg[2][2]_0 [0]),
        .I5(Q[0]),
        .O(\QxDO[1]_OBUF [1]));
  LUT5 #(
    .INIT(32'h96696996)) 
    \QxDO[1][3]_INST_0_i_1 
       (.I0(\FFxDP_reg[3]_0 [0]),
        .I1(\FFxDP_reg[2]_1 [0]),
        .I2(\FFxDP_reg[3]_0 [3]),
        .I3(\FFxDP_reg[2]_1 [3]),
        .I4(\FFxDP_reg[3][1]_0 ),
        .O(\QxDO[1]_OBUF [2]));
  LUT6 #(
    .INIT(64'h6996966996696996)) 
    \QxDO[1][3]_INST_0_i_2 
       (.I0(Q[0]),
        .I1(\FFxDP_reg[2][2]_0 [0]),
        .I2(\QxDO[1][4] [1]),
        .I3(\QxDO[1][4]_0 [1]),
        .I4(\FFxDP_reg[2][2]_0 [1]),
        .I5(Q[1]),
        .O(\FFxDP_reg[3][1]_0 ));
  LUT6 #(
    .INIT(64'h6996966996696996)) 
    \QxDO[1][4]_INST_0_i_1 
       (.I0(\FFxDP_reg[2]_1 [3]),
        .I1(\FFxDP_reg[3]_0 [3]),
        .I2(Q[0]),
        .I3(\FFxDP_reg[2][2]_0 [0]),
        .I4(\QxDO[1][4] [1]),
        .I5(\QxDO[1][4]_0 [1]),
        .O(\QxDO[1]_OBUF [3]));
  LUT4 #(
    .INIT(16'h6996)) 
    \QxDO[1][6]_INST_0_i_1 
       (.I0(\FFxDP_reg[2]_1 [3]),
        .I1(\FFxDP_reg[3]_0 [3]),
        .I2(\QxDO[1][4]_0 [1]),
        .I3(\QxDO[1][4] [1]),
        .O(\QxDO[1]_OBUF [4]));
  VCC VCC
       (.P(\<const1> ));
endmodule
