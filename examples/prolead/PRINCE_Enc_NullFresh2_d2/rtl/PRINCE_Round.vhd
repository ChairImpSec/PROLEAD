--
-- -----------------------------------------------------------------
-- COMPANY : Ruhr University Bochum
-- AUTHOR  : Amir Moradi amir.moradi@rub.de Aein Rezaei Shahmirzadi aein.rezaeishahmirzadi@rub.de
-- DOCUMENT: "Second-Order SCA Security with almost no Fresh Randomness" TCHES 2021, Issue 3
-- -----------------------------------------------------------------
--
-- Copyright c 2021, Amir Moradi, Aein Rezaei Shahmirzadi
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
			 r         : IN  STD_LOGIC_VECTOR (127 downto 0);

			 enc_dec           : IN STD_LOGIC;
			 clk               : IN STD_LOGIC;
			 round_number      : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
			 roundStart_Select : IN STD_LOGIC;
			 roundHalf_Select  : IN STD_LOGIC;
			 roundEnd_Select   : IN STD_LOGIC);
END PRINCE_Round;

ARCHITECTURE behavioral OF PRINCE_Round IS
	
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
			 round_inputXORkeyRCON_s1,
			 round_inputXORkeyRCON_s2,
			 round_inputXORkeyRCON_s3: STD_LOGIC_VECTOR (63 DOWNTO 0);
	
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
		D0        => mul_Result_s1,
		D1 	      => input_s1,
        Q         => roundReg_out_s1);
        
    InputMUX2: ENTITY work.MUX
	GENERIC Map ( size => 64)
	PORT Map ( 
		sel	      => roundStart_Select,
		D0        => mul_Result_s2,
		D1 	      => input_s2,
        Q         => roundReg_out_s2);
        
    InputMUX3: ENTITY work.MUX
	GENERIC Map ( size => 64)
	PORT Map ( 
		sel	      => roundStart_Select,
		D0        => mul_Result_s3,
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
	AddKey1: ENTITY work.XOR_2n
	GENERIC Map ( size => 4, count => 16)
	PORT Map ( SR_Result_s1, k1_XOR_round_Constant, round_inputXORkeyRCON_s1);
	
	AddKey2: ENTITY work.XOR_2n
	GENERIC Map ( size => 4, count => 16)
	PORT Map ( SR_Result_s2, k_1_share2, round_inputXORkeyRCON_s2);
	
	AddKey3: ENTITY work.XOR_2n
	GENERIC Map ( size => 4, count => 16)
	PORT Map ( SR_Result_s3, k_1_share3, round_inputXORkeyRCON_s3);
	
	-------------------------------------------------------
	
	sub : Entity work.substitutionCombined
		PORT MAP ( state0_s1  => round_inputXORkeyRCON_s1,
					  state0_s2  => round_inputXORkeyRCON_s2,
					  state0_s3  => round_inputXORkeyRCON_s3,
					  
					  state1_s1  => roundReg_out_s1,
					  state1_s2  => roundReg_out_s2,
					  state1_s3  => roundReg_out_s3,
					  r  => r,
					  
					  sel		 	 => roundHalf_Select,
					  clk			 => clk,
					  
					  result0_s1 => sub_Result_s1,
					  result0_s2 => sub_Result_s2,
					  result0_s3 => sub_Result_s3,
					  
					  result1_s1 => sub_Inv_Result_s1,
					  result1_s2 => sub_Inv_Result_s2,
					  result1_s3 => sub_Inv_Result_s3);
					  
	-------------------------------------------------------
	AddKey1_forInv: ENTITY work.XOR_2n
	GENERIC Map ( size => 4, count => 16)
	PORT Map ( sub_Inv_Result_s1, k1_XOR_round_Constant, sub_Inv_Result_XOR_keyRCON_s1);
	
	AddKey2_forInv: ENTITY work.XOR_2n
	GENERIC Map ( size => 4, count => 16)
	PORT Map ( sub_Inv_Result_s2, k_1_share2, sub_Inv_Result_XOR_keyRCON_s2);
	
	AddKey3_forInv: ENTITY work.XOR_2n
	GENERIC Map ( size => 4, count => 16)
	PORT Map ( sub_Inv_Result_s3, k_1_share3, sub_Inv_Result_XOR_keyRCON_s3);
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
	S_Sinv_mul1: ENTITY work.MUX
	GENERIC Map ( size => 64)
	PORT Map ( 
		sel	      => roundEnd_Select,
		D0        => sub_Result_s1,
		D1 	      => SR_Inv_Result_s1,
        Q         => mul_input_s1);
        
    S_Sinv_mul2: ENTITY work.MUX
	GENERIC Map ( size => 64)
	PORT Map ( 
		sel	      => roundEnd_Select,
		D0        => sub_Result_s2,
		D1 	      => SR_Inv_Result_s2,
        Q         => mul_input_s2);
        
    S_Sinv_mul3: ENTITY work.MUX
	GENERIC Map ( size => 64)
	PORT Map ( 
		sel	      => roundEnd_Select,
		D0        => sub_Result_s3,
		D1 	      => SR_Inv_Result_s3,
        Q         => mul_input_s3);

	
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

	-------------------------------------------------------

	result_s1 <= sub_Inv_Result_XOR_keyRCON_s1;
	result_s2 <= sub_Inv_Result_XOR_keyRCON_s2;
	result_s3 <= sub_Inv_Result_XOR_keyRCON_s3;

END behavioral;

