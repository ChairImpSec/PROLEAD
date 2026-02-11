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

ENTITY PRINCE_RoundBased IS
	PORT ( input_s1: IN STD_LOGIC_VECTOR (63 DOWNTO 0);
			 input_s2: IN STD_LOGIC_VECTOR (63 DOWNTO 0);
			 input_s3: IN STD_LOGIC_VECTOR (63 DOWNTO 0);
			 Static_r  : in  STD_LOGIC_VECTOR (215 DOWNTO 0);
          Dynamic_r  : in  STD_LOGIC_VECTOR (31 DOWNTO 0);
			 Key1 : IN STD_LOGIC_VECTOR (127 DOWNTO 0);
			 Key2 : IN STD_LOGIC_VECTOR (127 DOWNTO 0);
			 Key3 : IN STD_LOGIC_VECTOR (127 DOWNTO 0);
			 output_s1 : OUT STD_LOGIC_VECTOR (63 DOWNTO 0);
			 output_s2 : OUT STD_LOGIC_VECTOR (63 DOWNTO 0);
			 output_s3 : OUT STD_LOGIC_VECTOR (63 DOWNTO 0);
			 round : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
			 reset   : IN STD_LOGIC;
			 enc_dec : IN STD_LOGIC;
			 roundStart_Select : IN STD_LOGIC;
			 roundHalf_Select : IN STD_LOGIC;
			 roundEnd_Select : IN STD_LOGIC;
			 clk : IN STD_LOGIC);
END PRINCE_RoundBased;

ARCHITECTURE behavioral OF PRINCE_RoundBased IS
												  
	COMPONENT ShiftRows_Inverse is
		PORT ( state : in  STD_LOGIC_VECTOR (63 downto 0);
				  result : out  STD_LOGIC_VECTOR (63 downto 0));
	END COMPONENT;
	
	SIGNAL add_Result_Start_s1, add_Result_Start_s2, add_Result_Start_s3 : STD_LOGIC_VECTOR (63 DOWNTO 0);
	SIGNAL SR_Inv_Result_s1, SR_Inv_Result_s2, SR_Inv_Result_s3			   : STD_LOGIC_VECTOR (63 DOWNTO 0);
	SIGNAL rounds_Output_s1, rounds_Output_s2, rounds_Output_s3          : STD_LOGIC_VECTOR (63 DOWNTO 0);
	
	SIGNAL k_0_share1, k_0_p_share1, k_1_share1 : STD_LOGIC_VECTOR (63 DOWNTO 0);
	SIGNAL k_0_share2, k_0_p_share2, k_1_share2 : STD_LOGIC_VECTOR (63 DOWNTO 0);
	SIGNAL k_0_share3, k_0_p_share3, k_1_share3 : STD_LOGIC_VECTOR (63 DOWNTO 0);
	SIGNAL selected_Key1,selected_Key2,selected_Key3	: STD_LOGIC_VECTOR (63 DOWNTO 0);
	SIGNAL enc_dec_xor_reset	: STD_LOGIC;
	
BEGIN

	KeyDriv1: entity work.key_Derivation
		PORT MAP ( key 	=> Key1,
					  k_0 	=> k_0_share1,
					  k_0_p 	=> k_0_p_share1,
					  k_1 	=> k_1_share1);
					  
	KeyDriv2: entity work.key_Derivation
		PORT MAP ( key 	=> Key2,
					  k_0 	=> k_0_share2,
					  k_0_p 	=> k_0_p_share2,
					  k_1 	=> k_1_share2);
	
	KeyDriv3: entity work.key_Derivation
		PORT MAP ( key 	=> Key3,
					  k_0 	=> k_0_share3,
					  k_0_p 	=> k_0_p_share3,
					  k_1 	=> k_1_share3);
	
	enc_dec_xor_reset <= enc_dec xor reset;
	
	KeyMUX1: ENTITY work.MUX
	GENERIC Map ( size => 64)
	PORT Map ( 
		sel	      => enc_dec_xor_reset,
		D0        	=> k_0_p_share1,
		D1 	      => k_0_share1,
      Q         	=> selected_Key1);
		
	KeyMUX2: ENTITY work.MUX
	GENERIC Map ( size => 64)
	PORT Map ( 
		sel	      => enc_dec_xor_reset,
		D0        	=> k_0_p_share2,
		D1 	      => k_0_share2,
      Q         	=> selected_Key2);
		
	KeyMUX3: ENTITY work.MUX
	GENERIC Map ( size => 64)
	PORT Map ( 
		sel	      => enc_dec_xor_reset,
		D0        	=> k_0_p_share3,
		D1 	      => k_0_share3,
      Q         	=> selected_Key3);
		 
	---------------------------------------------------------
		 
   AddKey1: ENTITY work.XOR_2n
	GENERIC Map ( size => 4, count => 16)
	PORT Map ( input_s1, selected_Key1, add_Result_Start_s1);
	
	AddKey2: ENTITY work.XOR_2n
	GENERIC Map ( size => 4, count => 16)
	PORT Map ( input_s2, selected_Key2, add_Result_Start_s2);
	
	AddKey3: ENTITY work.XOR_2n
	GENERIC Map ( size => 4, count => 16)
	PORT Map ( input_s3, selected_Key3, add_Result_Start_s3);

	---------------------------------------------------------
	
	SR_Inv_s1: ShiftRows_Inverse
		Port MAP ( state => add_Result_Start_s1,
					  result => SR_Inv_Result_s1);

	SR_Inv_s2: ShiftRows_Inverse
		Port MAP ( state => add_Result_Start_s2,
					  result => SR_Inv_Result_s2);

	SR_Inv_s3: ShiftRows_Inverse
		Port MAP ( state => add_Result_Start_s3,
					  result => SR_Inv_Result_s3);

	---------------------------------------------------------

	rounds : Entity work.PRINCE_Round
		PORT MAP ( input_s1 => SR_Inv_Result_s1,
					  input_s2 => SR_Inv_Result_s2,
					  input_s3 => SR_Inv_Result_s3,
					  Static_r 	=> Static_r,
					  Dynamic_r 	=> Dynamic_r,
					  k_1_share1 => k_1_share1,
					  k_1_share2 => k_1_share2,
					  k_1_share3 => k_1_share3,
					  result_s1 => rounds_Output_s1,
					  result_s2 => rounds_Output_s2,
					  result_s3 => rounds_Output_s3,
					  
					  enc_dec => enc_dec,
					  clk => clk,
					  round_number => round,
					  roundStart_Select => roundStart_Select,
					  roundHalf_Select => roundHalf_Select,
					  roundEnd_Select => roundEnd_Select);
					  
	AddKeyOut1: ENTITY work.XOR_2n
	GENERIC Map ( size => 4, count => 16)
	PORT Map (rounds_Output_s1, selected_Key1, output_s1);
	
	AddKeyOut2: ENTITY work.XOR_2n
	GENERIC Map ( size => 4, count => 16)
	PORT Map (rounds_Output_s2, selected_Key2, output_s2);
	
	AddKeyOut3: ENTITY work.XOR_2n
	GENERIC Map ( size => 4, count => 16)
	PORT Map (rounds_Output_s3, selected_Key3, output_s3);

END behavioral;

