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


ENTITY Midori64_RoundBased IS
	PORT ( input1: IN STD_LOGIC_VECTOR (63 DOWNTO 0);
			 input2: IN STD_LOGIC_VECTOR (63 DOWNTO 0);
			 input3: IN STD_LOGIC_VECTOR (63 DOWNTO 0);
			 Static_r		 : IN STD_LOGIC_VECTOR (191 DOWNTO 0);
			 Dynamic_r		 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			 wk_share1  : IN STD_LOGIC_VECTOR (63 DOWNTO 0);
			 k_0_share1 : IN STD_LOGIC_VECTOR (63 DOWNTO 0);
			 k_1_share1 : IN STD_LOGIC_VECTOR (63 DOWNTO 0);
			 wk_share2  : IN STD_LOGIC_VECTOR (63 DOWNTO 0);
			 k_0_share2 : IN STD_LOGIC_VECTOR (63 DOWNTO 0);
			 k_1_share2 : IN STD_LOGIC_VECTOR (63 DOWNTO 0);
			 wk_share3  : IN STD_LOGIC_VECTOR (63 DOWNTO 0);
			 k_0_share3 : IN STD_LOGIC_VECTOR (63 DOWNTO 0);
			 k_1_share3 : IN STD_LOGIC_VECTOR (63 DOWNTO 0);
			 output1 : OUT STD_LOGIC_VECTOR (63 DOWNTO 0);
			 output2 : OUT STD_LOGIC_VECTOR (63 DOWNTO 0);
			 output3 : OUT STD_LOGIC_VECTOR (63 DOWNTO 0);
			 round : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
			 enc_dec : IN STD_LOGIC;
			 EN : IN STD_LOGIC;
			 roundStart_Select : IN STD_LOGIC;
			 clk : IN STD_LOGIC);
END Midori64_RoundBased;

ARCHITECTURE behavioral OF Midori64_RoundBased IS
	

												  
	
	SIGNAL add_Result_Start1,
			 add_Result_Start2,
			 add_Result_Start3 : STD_LOGIC_VECTOR (63 DOWNTO 0);

	SIGNAL rounds_Output1,
			 rounds_Output2,
			 rounds_Output3 : STD_LOGIC_VECTOR (63 DOWNTO 0);
	
	BEGIN
		-- PORT MAPPING						  
		
		add_Result_Start1 <= input1 XOR wk_share1;
		add_Result_Start2 <= input2 XOR wk_share2;
		add_Result_Start3	<= input3 XOR wk_share3;

		rounds : Entity work.Midori64_Round
			PORT MAP ( input1 => add_Result_Start1,
						  input2 => add_Result_Start2,
						  input3 => add_Result_Start3,						  
						  Static_r => Static_r,
						  Dynamic_r => Dynamic_r,						  
						  k_0_share1 => k_0_share1,
						  k_1_share1 => k_1_share1,
						  k_0_share2 => k_0_share2,
						  k_1_share2 => k_1_share2,
						  k_0_share3 => k_0_share3,
						  k_1_share3 => k_1_share3,
						  result1 => rounds_Output1,
						  result2 => rounds_Output2,
						  result3 => rounds_Output3,
						  
						  -- CONTROLLER SIGNALS
						  EN => EN,
						  enc_dec => enc_dec,
						  clk => clk,
						  round_number => round,
						  roundStart_Select => roundStart_Select);
						  
		output1 <= rounds_Output1 XOR wk_share1;
		output2 <= rounds_Output2 XOR wk_share2;
		output3 <= rounds_Output3 XOR wk_share3;
		
END behavioral;

