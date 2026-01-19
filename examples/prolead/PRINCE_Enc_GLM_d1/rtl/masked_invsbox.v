module masked_invsbox(
    input clk,
    input rst,
    input en,
    input [3:0] x,
    input [3:0] y,
    input [35:0] r,
    output [3:0] z_x,
    output [3:0] z_y
    );
    
    wire x01, x02, x12, x13, x23, x012, x013, x023, x123, s012, s0123_0, s0123_1;
    
    wire x01_xx, x01_xy, x01_yx, x01_yy;
    wire x02_xx, x02_xy, x02_yx, x02_yy;
    wire x12_xx, x12_xy, x12_yx, x12_yy;
    wire x13_xx, x13_xy, x13_yx, x13_yy;
    wire x23_xx, x23_xy, x23_yx, x23_yy;
    wire x012_xxx, x012_xxy, x012_xyx, x012_xyy, x012_yxx, x012_yxy, x012_yyx, x012_yyy;
    wire x013_xxx, x013_xxy, x013_xyx, x013_xyy, x013_yxx, x013_yxy, x013_yyx, x013_yyy;
    wire x023_xxx, x023_xxy, x023_xyx, x023_xyy, x023_yxx, x023_yxy, x023_yyx, x023_yyy;
    wire x123_xxx, x123_xxy, x123_xyx, x123_xyy, x123_yxx, x123_yxy, x123_yyx, x123_yyy;
    wire s012_xxx, s012_xxy, s012_xyx, s012_xyy, s012_yxx, s012_yxy, s012_yyx, s012_yyy;
    wire s0123_0_xxx, s0123_0_xxy, s0123_0_xyx, s0123_0_xyy, s0123_0_yxx, s0123_0_yxy, s0123_0_yyx, s0123_0_yyy;
    wire s0123_1_xxx, s0123_1_xxy, s0123_1_xyx, s0123_1_xyy, s0123_1_yxx, s0123_1_yxy, s0123_1_yyx, s0123_1_yyy;
    wire [15:0] s3_sh, s3_sh_out, s2_sh, s2_sh_out;
    wire [7:0] s1_sh, s1_sh_out;
    wire [11:0] s0_sh, s0_sh_out;
    wire [3:0] s1_sum, s2_tmp, s3_tmp;
    wire [5:0] s0_sum;
    wire [7:0] s2_sum, s3_sum;
    wire [1:0] s0_tmp;
    
    assign x01_xx = x[0] & x[1];
    assign x01_xy = x[0] & y[1];
    assign x01_yx = y[0] & x[1];
    assign x01_yy = y[0] & y[1];
    
    assign x02_xx = x[0] & x[2];
    assign x02_xy = x[0] & y[2];
    assign x02_yx = y[0] & x[2];
    assign x02_yy = y[0] & y[2];
    
    assign x12_xx = x[1] & x[2];
    assign x12_xy = x[1] & y[2];
    assign x12_yx = y[1] & x[2];
    assign x12_yy = y[1] & y[2];
    
    assign x13_xx = x[1] & x[3];
    assign x13_xy = x[1] & y[3];
    assign x13_yx = y[1] & x[3];
    assign x13_yy = y[1] & y[3];
    
    assign x23_xx = x[2] & x[3];
    assign x23_xy = x[2] & y[3];
    assign x23_yx = y[2] & x[3];
    assign x23_yy = y[2] & y[3];
    
    assign x012_xxx = x01_xx & x[2];
    assign x012_xxy = x01_xx & y[2];
    assign x012_xyx = x01_xy & x[2];
    assign x012_xyy = x01_xy & y[2];
    assign x012_yxx = x01_yx & x[2];
    assign x012_yxy = x01_yx & y[2];
    assign x012_yyx = x01_yy & x[2];
    assign x012_yyy = x01_yy & y[2];
    
    assign x013_xxx = x01_xx & x[3];
    assign x013_xxy = x01_xx & y[3];
    assign x013_xyx = x01_xy & x[3];
    assign x013_xyy = x01_xy & y[3];
    assign x013_yxx = x01_yx & x[3];
    assign x013_yxy = x01_yx & y[3];
    assign x013_yyx = x01_yy & x[3];
    assign x013_yyy = x01_yy & y[3];
    
    assign x023_xxx = x02_xx & x[3];
    assign x023_xxy = x02_xx & y[3];
    assign x023_xyx = x02_xy & x[3];
    assign x023_xyy = x02_xy & y[3];
    assign x023_yxx = x02_yx & x[3];
    assign x023_yxy = x02_yx & y[3];
    assign x023_yyx = x02_yy & x[3];
    assign x023_yyy = x02_yy & y[3];
    
    assign x123_xxx = x12_xx & x[3];
    assign x123_xxy = x12_xx & y[3];
    assign x123_xyx = x12_xy & x[3];
    assign x123_xyy = x12_xy & y[3];
    assign x123_yxx = x12_yx & x[3];
    assign x123_yxy = x12_yx & y[3];
    assign x123_yyx = x12_yy & x[3];
    assign x123_yyy = x12_yy & y[3];
    
    assign s012_xxx = x012_xxx ^ x12_xx;
    assign s012_xxy = x012_xxy ^ x02_xy;
    assign s012_xyx = x012_xyx ^ x02_xx;
    assign s012_xyy = x012_xyy ^ x12_yy;
    assign s012_yxx = x012_yxx ^ x02_yx;
    assign s012_yxy = x012_yxy ^ x12_xy;
    assign s012_yyx = x012_yyx ^ x12_yx;
    assign s012_yyy = x012_yyy ^ x02_yy;
    
    assign s0123_0_xxx = s012_xxx ^ x13_xx;
    assign s0123_0_xxy = s012_xxy;
    assign s0123_0_xyx = s012_xyx ^ x13_yx;
    assign s0123_0_xyy = s012_xyy;
    assign s0123_0_yxx = s012_yxx ^ x13_xy;
    assign s0123_0_yxy = s012_yxy;
    assign s0123_0_yyx = s012_yyx ^ x13_yy;
    assign s0123_0_yyy = s012_yyy;
    
    assign s0123_1_xxx = x023_xxx ^ x23_xx;
    assign s0123_1_xxy = x023_xxy ^ x01_xx;
    assign s0123_1_xyx = x023_xyx ^ x01_xy;
    assign s0123_1_xyy = x023_xyy ^ x23_yy;
    assign s0123_1_yxx = x023_yxx ^ x01_yx;
    assign s0123_1_yxy = x023_yxy ^ x23_xy;
    assign s0123_1_yyx = x023_yyx ^ x23_yx;
    assign s0123_1_yyy = x023_yyy ^ x01_yy;
    
    assign s0_sh[0] = s0123_1_xxx ^ x[3] ^ x013_xxx ^ r[0] ^ r[2];
    assign s0_sh[1] = s0123_1_xxy ^ x013_xxy ^ ~x12_xx ^ r[5];
    assign s0_sh[2] = s0123_1_xyx ^ x013_xyx ^ r[0] ^ r[1] ^ r[3];
    assign s0_sh[3] = s0123_1_xyy ^ x013_xyy ^ x12_yy;
    
    assign s0_sh[4] = s0123_1_yxx ^ x013_yxx ^ r[2] ^ r[6];
    assign s0_sh[5] = s0123_1_yxy ^ x013_yxy ^ r[0] ^ r[4];
    assign s0_sh[6] = s0123_1_yyx ^ x013_yyx ^ r[0] ^ r[1];
    assign s0_sh[7] = s0123_1_yyy ^ y[3] ^ x013_yyy ^ r[3] ^ r[4];
    
    assign s0_sh[8] = x12_xy ^ r[5];
    assign s0_sh[9] = x12_yx ^ r[6];
    
    assign s1_sh[0] = s0123_0_xxx ^ ~x23_xx;
    assign s1_sh[1] = s0123_0_xxy ^ x23_yx ^ r[0];
    assign s1_sh[2] = s0123_0_xyx ^ r[0] ^ r[1];
    assign s1_sh[3] = s0123_0_xyy ^ r[1] ^ r[2];
    
    assign s1_sh[4] = s0123_0_yxx ^ r[0] ^ r[1];
    assign s1_sh[5] = s0123_0_yxy ^ r[1] ^ r[2];
    assign s1_sh[6] = s0123_0_yyx ^ x23_xy ^ r[0];
    assign s1_sh[7] = s0123_0_yyy ^ x23_yy;
    
    assign s2_sh[0] = s0123_0_xxx ^ x013_xxx ^ x[0];
    assign s2_sh[1] = s0123_0_xxy ^ x01_xx ^ r[0] ^ r[6];
    assign s2_sh[2] = x013_xxy ^ r[0] ^ r[1] ^ r[4];
    assign s2_sh[3] = s0123_0_xyx ^ x013_xyx ^ r[3];
    
    assign s2_sh[4] = s0123_0_xyy ^ x01_xy ^ r[4];
    assign s2_sh[5] = x013_xyy ^ r[0] ^ r[5];
    assign s2_sh[6] = s0123_0_yxx ^ x013_yxy ^ x[2] ^ r[2];
    assign s2_sh[7] = x013_yxx ^ r[0] ^ r[3];

    assign s2_sh[8] = s0123_0_yxy ^ x01_yx ^ y[2] ^ r[5]; 
    assign s2_sh[9] = s0123_0_yyx ^ x01_yy ^ r[0] ^ r[1];
    assign s2_sh[10] = x013_yyx ^ r[0] ^ r[2];
    assign s2_sh[11] = s0123_0_yyy ^ x013_yyy ^ y[0] ^ r[6];
    
    assign s3_sh[0] = s0123_1_xxx ^ ~x[0] ^ s012_xxx ^ x123_xxx;
    assign s3_sh[1] = s012_xxy ^ x123_xyx ^ r[0] ^ r[6];
    assign s3_sh[2] = s0123_1_xxy ^ x[1] ^ r[0] ^ r[1] ^ r[4];
    assign s3_sh[3] = s012_xyx ^ x123_yxx ^ r[3];
    
    assign s3_sh[4] = s0123_1_xyx ^ y[1] ^ s012_xyy ^ x123_yyx ^ r[4];
    assign s3_sh[5] = s0123_1_xyy ^ r[0] ^ r[5];
    assign s3_sh[6] = s0123_1_yxy ^ s012_yxx ^ x123_xxy ^ r[2];
    assign s3_sh[7] = s0123_1_yxx ^ y[0] ^ r[0] ^ r[3];

    assign s3_sh[8] = s012_yxy ^ x123_xyy ^ r[5];
    assign s3_sh[9] = s012_yyx ^ x123_yxy ^ r[0] ^ r[1];
    assign s3_sh[10] = s0123_1_yyx ^ r[0] ^ r[2];
    assign s3_sh[11] = s0123_1_yyy ^ s012_yyy ^ x123_yyy ^ r[6];
    
    // register stage
    register_stage reg_0(.clk(clk), .rst(rst), .en(en), .D(s0_sh[0]), .Q(s0_sh_out[0]));
    register_stage reg_1(.clk(clk), .rst(rst), .en(en), .D(s0_sh[1]), .Q(s0_sh_out[1]));
    register_stage reg_2(.clk(clk), .rst(rst), .en(en), .D(s0_sh[2]), .Q(s0_sh_out[2]));
    register_stage reg_3(.clk(clk), .rst(rst), .en(en), .D(s0_sh[3]), .Q(s0_sh_out[3]));
    register_stage reg_4(.clk(clk), .rst(rst), .en(en), .D(s0_sh[4]), .Q(s0_sh_out[4]));
    register_stage reg_5(.clk(clk), .rst(rst), .en(en), .D(s0_sh[5]), .Q(s0_sh_out[5]));
    register_stage reg_6(.clk(clk), .rst(rst), .en(en), .D(s0_sh[6]), .Q(s0_sh_out[6]));
    register_stage reg_7(.clk(clk), .rst(rst), .en(en), .D(s0_sh[7]), .Q(s0_sh_out[7]));
    register_stage reg_8(.clk(clk), .rst(rst), .en(en), .D(s0_sh[8]), .Q(s0_sh_out[8]));
    register_stage reg_9(.clk(clk), .rst(rst), .en(en), .D(s0_sh[9]), .Q(s0_sh_out[9]));

    register_stage reg_10(.clk(clk), .rst(rst), .en(en), .D(s1_sh[0]), .Q(s1_sh_out[0]));
    register_stage reg_11(.clk(clk), .rst(rst), .en(en), .D(s1_sh[1]), .Q(s1_sh_out[1]));
    register_stage reg_12(.clk(clk), .rst(rst), .en(en), .D(s1_sh[2]), .Q(s1_sh_out[2]));
    register_stage reg_13(.clk(clk), .rst(rst), .en(en), .D(s1_sh[3]), .Q(s1_sh_out[3]));
    register_stage reg_14(.clk(clk), .rst(rst), .en(en), .D(s1_sh[4]), .Q(s1_sh_out[4]));
    register_stage reg_15(.clk(clk), .rst(rst), .en(en), .D(s1_sh[5]), .Q(s1_sh_out[5]));
    register_stage reg_16(.clk(clk), .rst(rst), .en(en), .D(s1_sh[6]), .Q(s1_sh_out[6]));
    register_stage reg_17(.clk(clk), .rst(rst), .en(en), .D(s1_sh[7]), .Q(s1_sh_out[7]));
    
    register_stage reg_18(.clk(clk), .rst(rst), .en(en), .D(s2_sh[0]), .Q(s2_sh_out[0]));
    register_stage reg_19(.clk(clk), .rst(rst), .en(en), .D(s2_sh[1]), .Q(s2_sh_out[1]));
    register_stage reg_20(.clk(clk), .rst(rst), .en(en), .D(s2_sh[2]), .Q(s2_sh_out[2]));
    register_stage reg_21(.clk(clk), .rst(rst), .en(en), .D(s2_sh[3]), .Q(s2_sh_out[3]));
    register_stage reg_22(.clk(clk), .rst(rst), .en(en), .D(s2_sh[4]), .Q(s2_sh_out[4]));
    register_stage reg_23(.clk(clk), .rst(rst), .en(en), .D(s2_sh[5]), .Q(s2_sh_out[5]));
    register_stage reg_24(.clk(clk), .rst(rst), .en(en), .D(s2_sh[6]), .Q(s2_sh_out[6]));
    register_stage reg_25(.clk(clk), .rst(rst), .en(en), .D(s2_sh[7]), .Q(s2_sh_out[7]));
    register_stage reg_26(.clk(clk), .rst(rst), .en(en), .D(s2_sh[8]), .Q(s2_sh_out[8]));
    register_stage reg_27(.clk(clk), .rst(rst), .en(en), .D(s2_sh[9]), .Q(s2_sh_out[9]));
    register_stage reg_28(.clk(clk), .rst(rst), .en(en), .D(s2_sh[10]), .Q(s2_sh_out[10]));
    register_stage reg_29(.clk(clk), .rst(rst), .en(en), .D(s2_sh[11]), .Q(s2_sh_out[11]));
    
    register_stage reg_30(.clk(clk), .rst(rst), .en(en), .D(s3_sh[0]), .Q(s3_sh_out[0]));
    register_stage reg_31(.clk(clk), .rst(rst), .en(en), .D(s3_sh[1]), .Q(s3_sh_out[1]));
    register_stage reg_32(.clk(clk), .rst(rst), .en(en), .D(s3_sh[2]), .Q(s3_sh_out[2]));
    register_stage reg_33(.clk(clk), .rst(rst), .en(en), .D(s3_sh[3]), .Q(s3_sh_out[3]));
    register_stage reg_34(.clk(clk), .rst(rst), .en(en), .D(s3_sh[4]), .Q(s3_sh_out[4]));
    register_stage reg_35(.clk(clk), .rst(rst), .en(en), .D(s3_sh[5]), .Q(s3_sh_out[5]));
    register_stage reg_36(.clk(clk), .rst(rst), .en(en), .D(s3_sh[6]), .Q(s3_sh_out[6]));
    register_stage reg_37(.clk(clk), .rst(rst), .en(en), .D(s3_sh[7]), .Q(s3_sh_out[7]));   
    register_stage reg_38(.clk(clk), .rst(rst), .en(en), .D(s3_sh[8]), .Q(s3_sh_out[8]));
    register_stage reg_39(.clk(clk), .rst(rst), .en(en), .D(s3_sh[9]), .Q(s3_sh_out[9]));
    register_stage reg_40(.clk(clk), .rst(rst), .en(en), .D(s3_sh[10]), .Q(s3_sh_out[10]));
    register_stage reg_41(.clk(clk), .rst(rst), .en(en), .D(s3_sh[11]), .Q(s3_sh_out[11]));
    
    assign s0_sum[0] = s0_sh_out[0] ^ s0_sh_out[1]; 
    assign s0_sum[1] = s0_sh_out[2] ^ s0_sh_out[3];
    assign s0_sum[2] = s0_sh_out[4] ^ s0_sh_out[5];
    assign s0_sum[3] = s0_sh_out[6] ^ s0_sh_out[7];
    assign s0_sum[4] = s0_sh_out[8] ^ s0_sh_out[9];
    
    assign s1_sum[0] = s1_sh_out[0] ^ s1_sh_out[1]; 
    assign s1_sum[1] = s1_sh_out[2] ^ s1_sh_out[3];
    assign s1_sum[2] = s1_sh_out[4] ^ s1_sh_out[5];
    assign s1_sum[3] = s1_sh_out[6] ^ s1_sh_out[7];
    
    assign s2_sum[0] = s2_sh_out[0] ^ s2_sh_out[1]; 
    assign s2_sum[1] = s2_sh_out[2] ^ s2_sh_out[3];
    assign s2_sum[2] = s2_sh_out[4] ^ s2_sh_out[5];
    assign s2_sum[3] = s2_sh_out[6] ^ s2_sh_out[7];
    assign s2_sum[4] = s2_sh_out[8] ^ s2_sh_out[9]; 
    assign s2_sum[5] = s2_sh_out[10] ^ s2_sh_out[11];
    
    assign s3_sum[0] = s3_sh_out[0] ^ s3_sh_out[1]; 
    assign s3_sum[1] = s3_sh_out[2] ^ s3_sh_out[3];
    assign s3_sum[2] = s3_sh_out[4] ^ s3_sh_out[5];
    assign s3_sum[3] = s3_sh_out[6] ^ s3_sh_out[7];
    assign s3_sum[4] = s3_sh_out[8] ^ s3_sh_out[9]; 
    assign s3_sum[5] = s3_sh_out[10] ^ s3_sh_out[11];
    
    assign s0_tmp[0] = s0_sum[0] ^ s0_sum[1];
    assign s0_tmp[1] = s0_sum[2] ^ s0_sum[3];
    
    assign s2_tmp[0] = s2_sum[0] ^ s2_sum[1];
    assign s2_tmp[1] = s2_sum[2] ^ s2_sum[3];
    
    assign s3_tmp[0] = s3_sum[0] ^ s3_sum[1];
    assign s3_tmp[1] = s3_sum[2] ^ s3_sum[3];
    
    assign z_x[0] = s0_tmp[0] ^ s0_tmp[1];
    assign z_x[1] = s1_sum[0] ^ s1_sum[1];
    assign z_x[2] = s2_tmp[0] ^ s2_tmp[1];
    assign z_x[3] = s3_tmp[0] ^ s3_tmp[1];
    
    assign z_y[0] = s0_sum[4];
    assign z_y[1] = s1_sum[2] ^ s1_sum[3];
    assign z_y[2] = s2_sum[4] ^ s2_sum[5];
    assign z_y[3] = s3_sum[4] ^ s3_sum[5];
endmodule