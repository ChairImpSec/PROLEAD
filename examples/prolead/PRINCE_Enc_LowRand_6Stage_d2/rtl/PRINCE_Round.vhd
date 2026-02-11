--
-- -----------------------------------------------------------------
-- COMPANY : Ruhr University Bochum
-- AUTHOR  : Aein Rezaei Shahmirzadi (aein.rezaeishahmirzadi@rub.de)
-- DOCUMENT: "Low-Latency and Low-Randomness Second-Order Masked Cubic Functions", TCHES 2023, Issue 1.
-- -----------------------------------------------------------------
--
-- Copyright c 2021, Aein Rezaei Shahmirzadi
--
-- All rights reserved.
--
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
-- ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
-- WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
-- DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTERS BE LIABLE FOR ANY
-- DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
-- INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
-- LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION HOWEVER CAUSED AND
-- ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
-- INCLUDING NEGLIGENCE OR OTHERWISE ARISING IN ANY WAY OUT OF THE USE OF THIS
-- SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
--
-- Please see LICENSE and README for license and further instructions.
--
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY PRINCE_Round IS
	PORT ( input_s1          : IN  STD_LOGIC_VECTOR (63 DOWNTO 0);
			 input_s2          : IN  STD_LOGIC_VECTOR (63 DOWNTO 0);
			 input_s3          : IN  STD_LOGIC_VECTOR (63 DOWNTO 0);
			 k_1_share1        : IN  STD_LOGIC_VECTOR (63 downto 0);
			 k_1_share2        : IN  STD_LOGIC_VECTOR (63 downto 0);
			 k_1_share3        : IN  STD_LOGIC_VECTOR (63 downto 0);
			 result_s1         : OUT  STD_LOGIC_VECTOR (63 downto 0);
			 result_s2         : OUT  STD_LOGIC_VECTOR (63 downto 0);
			 result_s3         : OUT  STD_LOGIC_VECTOR (63 downto 0);
			 Static_r  : in  STD_LOGIC_VECTOR (215 DOWNTO 0);
          Dynamic_r  : in  STD_LOGIC_VECTOR (31 DOWNTO 0);

			 enc_dec           : IN STD_LOGIC;
			 clk               : IN STD_LOGIC;
			 round_number      : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
			 roundStart_Select : IN STD_LOGIC;
			 roundHalf_Select  : IN STD_LOGIC;
			 roundEnd_Select   : IN STD_LOGIC);
END PRINCE_Round;

ARCHITECTURE behavioral OF PRINCE_Round IS
		COMPONENT Sbox_State
	PORT(
		clk : IN std_logic;
		r : IN std_logic_vector(215 downto 0);
		sel : IN std_logic;
		In_state1 : IN std_logic_vector(63 downto 0);
		In_state2 : IN std_logic_vector(63 downto 0);
		In_state3 : IN std_logic_vector(63 downto 0);          
		result1 : OUT std_logic_vector(63 downto 0);
		result2 : OUT std_logic_vector(63 downto 0);
		result3 : OUT std_logic_vector(63 downto 0)
		);
	END COMPONENT;
	COMPONENT ScanFF IS
		GENERIC (SIZE : integer);
		PORT ( CLK	: IN 	STD_LOGIC;
				 SE 	: IN 	STD_LOGIC;
				 D  	: IN 	STD_LOGIC_VECTOR((SIZE-1) DOWNTO 0);
				 DS	: IN 	STD_LOGIC_VECTOR((SIZE-1) DOWNTO 0);
				 Q 	: OUT STD_LOGIC_VECTOR((SIZE-1) DOWNTO 0));
	END COMPONENT;
	
	COMPONENT roundConstant_MUX IS
		PORT ( round : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
				 enc_dec: IN STD_LOGIC;
				 roundConstant : OUT  STD_LOGIC_VECTOR (63 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT ShiftRows_Inverse is
		PORT ( state : in  STD_LOGIC_VECTOR (63 downto 0);
				  result : out  STD_LOGIC_VECTOR (63 downto 0));
	END COMPONENT;
	
	COMPONENT matrixMultiplication IS
		PORT ( state : IN  STD_LOGIC_VECTOR (63 DOWNTO 0);
				 result : OUT  STD_LOGIC_VECTOR (63 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT ShiftRows is
		PORT ( state : IN  STD_LOGIC_VECTOR (63 DOWNTO 0);
				 result : OUT  STD_LOGIC_VECTOR (63 DOWNTO 0));
	END COMPONENT;
		
	SIGNAL round_Constant     : STD_LOGIC_VECTOR (63 DOWNTO 0);
	SIGNAL k1_XOR_round_Constant, 
			 roundReg_out_s1,
			 roundReg_out_s2,
			 roundReg_out_s3,
			 SR_Result_s1,
			 SR_Result_s2,
			 SR_Result_s3,
			 sub_Inv_Result_s1,
			 sub_Inv_Result_s2,
			 sub_Inv_Result_s3,
			 mul_input_s1,
			 mul_input_s2,
			 mul_input_s3,
			 mul_result_s1,
			 mul_result_s2,
			 mul_result_s3,
			 SR_Inv_Result_s1,
			 SR_Inv_Result_s2,
			 SR_Inv_Result_s3,
			 sub_Result_s1,
			 sub_Result_s2,
			 sub_Result_s3,
			 sub_Inv_Result_XOR_keyRCON_s1,
			 sub_Inv_Result_XOR_keyRCON_s2,
			 sub_Inv_Result_XOR_keyRCON_s3,
			 Sbox_Input_s3,
			 Sbox_Input_s2,
			 Sbox_Input_s1,
			 round_inputXORkeyRCON_s1,
			 round_inputXORkeyRCON_s2,
			 round_inputXORkeyRCON_s3: STD_LOGIC_VECTOR (63 DOWNTO 0);
			 
			 	SIGNAL r0_64, r1_64, r2_64	 	: STD_LOGIC_VECTOR (63 DOWNTO 0);
	SIGNAL r0, r1, r2, r3, r4, r5, r6 ,r7		: STD_LOGIC_VECTOR (3 DOWNTO 0);
	SIGNAL r01, r23, r45, r024, r135, r012345		: STD_LOGIC_VECTOR (3 DOWNTO 0);
	SIGNAL r6_4, r7_4     		: STD_LOGIC_VECTOR (15 DOWNTO 0);
	SIGNAL c1_fresh1, c1_fresh2, c1_fresh3     		: STD_LOGIC_VECTOR (15 DOWNTO 0);
	SIGNAL c2_fresh1, c2_fresh2, c2_fresh3     		: STD_LOGIC_VECTOR (15 DOWNTO 0);
	SIGNAL Refreshed_mul_Result1, Refreshed_mul_Result2, Refreshed_mul_Result3     		: STD_LOGIC_VECTOR (63 DOWNTO 0);
	
BEGIN

	constant_MUX : roundConstant_MUX
		PORT MAP ( round => round_number,
					  enc_dec => enc_dec,
					  roundConstant => round_Constant);

    k1_XOR_round_Constant_module: ENTITY work.XOR_2n
	GENERIC Map ( size => 4, count => 16)
	PORT Map ( k_1_share1, round_Constant, k1_XOR_round_Constant);

	-------------------------------------------------------
	InputMUX1: ENTITY work.MUX
	GENERIC Map ( size => 64)
	PORT Map ( 
		sel	      => roundStart_Select,
		D0        => Refreshed_mul_Result1,
		D1 	      => input_s1,
        Q         => roundReg_out_s1);
        
    InputMUX2: ENTITY work.MUX
	GENERIC Map ( size => 64)
	PORT Map ( 
		sel	      => roundStart_Select,
		D0        => Refreshed_mul_Result2,
		D1 	      => input_s2,
        Q         => roundReg_out_s2);
        
    InputMUX3: ENTITY work.MUX
	GENERIC Map ( size => 64)
	PORT Map ( 
		sel	      => roundStart_Select,
		D0        => Refreshed_mul_Result3,
		D1 	      => input_s3,
        Q         => roundReg_out_s3);

	-------------------------------------------------------

	SR_s1: ShiftRows
		PORT MAP ( state => roundReg_out_s1,
					  result => SR_Result_s1);

	SR_s2: ShiftRows
		PORT MAP ( state => roundReg_out_s2,
					  result => SR_Result_s2);

	SR_s3: ShiftRows
		PORT MAP ( state => roundReg_out_s3,
					  result => SR_Result_s3);

	-------------------------------------------------------
	round_inputXORkeyRCON_s1 <= SR_Result_s1 XOR k1_XOR_round_Constant;
	round_inputXORkeyRCON_s2 <= SR_Result_s2 XOR k_1_share2;
	round_inputXORkeyRCON_s3 <= SR_Result_s3 XOR k_1_share3;
	
	-------------------------------------------------------
	
MUX_inst0: ENTITY work.MUX
	GENERIC Map ( size => 64)
	PORT Map ( 
		sel	=> roundHalf_Select,
		D0   	=> round_inputXORkeyRCON_s1,
		D1 	=> roundReg_out_s1,
		Q 		=> Sbox_Input_s1);
		
	MUX_inst1: ENTITY work.MUX
	GENERIC Map ( size => 64)
	PORT Map ( 
		sel	=> roundHalf_Select,
		D0   	=> round_inputXORkeyRCON_s2,
		D1 	=> roundReg_out_s2,
		Q 		=> Sbox_Input_s2);
		
	MUX_inst2: ENTITY work.MUX
	GENERIC Map ( size => 64)
	PORT Map ( 
		sel	=> roundHalf_Select,
		D0   	=> round_inputXORkeyRCON_s3,
		D1 	=> roundReg_out_s3,
		Q 		=> Sbox_Input_s3);
		
		
	Inst_Sbox_State: Sbox_State PORT MAP(
		clk => clk,
		r => Static_r,
		sel => roundHalf_Select,
		In_state1 => Sbox_Input_s1,
		In_state2 => Sbox_Input_s2,
		In_state3 => Sbox_Input_s3,
		result1 => sub_Inv_Result_s1,
		result2 => sub_Inv_Result_s2,
		result3 => sub_Inv_Result_s3
	);
					  
	  sub_Result_s1 <= sub_Inv_Result_s1;
	  sub_Result_s2 <= sub_Inv_Result_s2;
	  sub_Result_s3 <= sub_Inv_Result_s3;
					  
	-------------------------------------------------------
	sub_Inv_Result_XOR_keyRCON_s1	<= sub_Inv_Result_s1 XOR k1_XOR_round_Constant;
	sub_Inv_Result_XOR_keyRCON_s2	<= sub_Inv_Result_s2 XOR k_1_share2;
	sub_Inv_Result_XOR_keyRCON_s3	<= sub_Inv_Result_s3 XOR k_1_share3;
	-------------------------------------------------------

	SR_Inv_s1: ShiftRows_Inverse
		Port MAP ( state => sub_Inv_Result_XOR_keyRCON_s1,
					  result => SR_Inv_Result_s1);

	SR_Inv_s2: ShiftRows_Inverse
		Port MAP ( state => sub_Inv_Result_XOR_keyRCON_s2,
					  result => SR_Inv_Result_s2);

	SR_Inv_s3: ShiftRows_Inverse
		Port MAP ( state => sub_Inv_Result_XOR_keyRCON_s3,
					  result => SR_Inv_Result_s3);
	
	-------------------------------------------------------
	mul_input_s1 <= sub_Result_s1 when roundEnd_Select = '0' else SR_Inv_Result_s1;
	mul_input_s2 <= sub_Result_s2 when roundEnd_Select = '0' else SR_Inv_Result_s2;
	mul_input_s3 <= sub_Result_s3 when roundEnd_Select = '0' else SR_Inv_Result_s3;

	
	-------------------------------------------------------

	mul_s1: matrixMultiplication
		PORT MAP ( state => mul_input_s1,
					  result => mul_Result_s1);
					  
	mul_s2: matrixMultiplication
		PORT MAP ( state => mul_input_s2,
					  result => mul_Result_s2);

	mul_s3: matrixMultiplication
		PORT MAP ( state => mul_input_s3,
					  result => mul_Result_s3);
					  
	r0 <= Dynamic_r(3 downto 0);
	r1 <= Dynamic_r(7 downto 4);
	r2 <= Dynamic_r(11 downto 8);
	r3 <= Dynamic_r(15 downto 12);
	r4 <= Dynamic_r(19 downto 16);
	r5 <= Dynamic_r(23 downto 20);
	r6 <= Dynamic_r(27 downto 24);
	r7 <= Dynamic_r(31 downto 28);
	
	
	
	r6_4 <= r6 & r6 & r6 & r6;
	r7_4 <= r7 & r7 & r7 & r7;
	
	r01 <= r0 xor r1;
	r23 <= r2 xor r3;
	r45 <= r4 xor r5;

	r024 <= r0 xor r2 xor r4;
	r135 <= r1 xor r3 xor r5;
	r012345 <= r024 xor r135;
	
	c1_fresh1 <= r0 & r2 & r4 & r024;
	c1_fresh2 <= r1 & r3 & r5 & r135;
	c1_fresh3 <= r01 & r23 & r45 & r012345;
	
	c2_fresh1 <= c1_fresh1 xor r6_4;
	c2_fresh2 <= c1_fresh2 xor r7_4;
	c2_fresh3 <= c1_fresh3 xor r6_4 xor r7_4;
	
	
	r0_64 <= c1_fresh1 & c2_fresh1 & c1_fresh1 & c2_fresh1  ;
	r1_64 <= c1_fresh2 & c2_fresh2 & c1_fresh2 & c2_fresh2  ;
	r2_64 <= c1_fresh3 & c2_fresh3 & c1_fresh3 & c2_fresh3  ;
	
	
	Refreshed_mul_Result1 <= mul_Result_s1 xor r0_64;
	Refreshed_mul_Result2 <= mul_Result_s2 xor r1_64;
	Refreshed_mul_Result3 <= mul_Result_s3 xor r2_64;

	-------------------------------------------------------

	result_s1 <= sub_Inv_Result_XOR_keyRCON_s1;
	result_s2 <= sub_Inv_Result_XOR_keyRCON_s2;
	result_s3 <= sub_Inv_Result_XOR_keyRCON_s3;

END behavioral;

