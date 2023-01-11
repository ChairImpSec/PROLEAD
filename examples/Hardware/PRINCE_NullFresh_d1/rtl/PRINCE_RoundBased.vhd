--
-----------------------------------------------------------------
-- COMPANY : Ruhr University Bochum
-- AUTHOR  : Amir Moradi (amir.moradi@rub.de) Aein Rezaei Shahmirzadi (aein.rezaeishahmirzadi@rub.de)
-- DOCUMENT: https://doi.org/10.46586/tches.v2021.i1.305-342
-- -----------------------------------------------------------------
--
-- Copyright (c) 2020, Amir Moradi, Aein Rezaei Shahmirzadi
--
-- All rights reserved.
--
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
-- ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
-- WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
-- DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTERS BE LIABLE FOR ANY
-- DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
-- (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
-- LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
-- ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
-- (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
-- SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
--
-- Please see LICENSE and README for license and further instructions.
--

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY PRINCE_RoundBased IS
	PORT ( input_s1: IN STD_LOGIC_VECTOR (63 DOWNTO 0);
			 input_s2: IN STD_LOGIC_VECTOR (63 DOWNTO 0);
			 k_0 : IN STD_LOGIC_VECTOR (63 DOWNTO 0);
			 k_0_p : IN STD_LOGIC_VECTOR (63 DOWNTO 0);
			 k_1 : IN STD_LOGIC_VECTOR (63 DOWNTO 0);
			 output_s1 : OUT STD_LOGIC_VECTOR (63 DOWNTO 0);
			 output_s2 : OUT STD_LOGIC_VECTOR (63 DOWNTO 0);
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
	
	SIGNAL add_Result_Start_s1, add_Result_Start_s2 : STD_LOGIC_VECTOR (63 DOWNTO 0);
	SIGNAL SR_Inv_Result_s1, SR_Inv_Result_s2			   : STD_LOGIC_VECTOR (63 DOWNTO 0);
	SIGNAL rounds_Output_s1, rounds_Output_s2          : STD_LOGIC_VECTOR (63 DOWNTO 0);
	
	SIGNAL selected_Key	: STD_LOGIC_VECTOR (63 DOWNTO 0);
	
BEGIN
	
	selected_Key 	     <= k_0 when (enc_dec xor reset) = '1' else k_0_p;

	add_Result_Start_s1 <= input_s1 XOR selected_Key;
	add_Result_Start_s2 <= input_s2;

	---------------------------------------------------------
	
	SR_Inv_s1: ShiftRows_Inverse
		Port MAP ( state => add_Result_Start_s1,
					  result => SR_Inv_Result_s1);

	SR_Inv_s2: ShiftRows_Inverse
		Port MAP ( state => add_Result_Start_s2,
					  result => SR_Inv_Result_s2);

	---------------------------------------------------------

	rounds : ENTITY work.PRINCE_Round
		PORT MAP ( input_s1 => SR_Inv_Result_s1,
					  input_s2 => SR_Inv_Result_s2,

					  k_1 => k_1,
					  result_s1 => rounds_Output_s1,
					  result_s2 => rounds_Output_s2,

					  
					  enc_dec => enc_dec,
					  clk => clk,
					  round_number => round,
					  roundStart_Select => roundStart_Select,
					  roundHalf_Select => roundHalf_Select,
					  roundEnd_Select => roundEnd_Select);
					  
	output_s1 <= rounds_Output_s1 XOR selected_Key;
	output_s2 <= rounds_Output_s2;

END behavioral;

