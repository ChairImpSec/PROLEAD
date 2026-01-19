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


ENTITY Midori64_RoundBased IS
	PORT ( input1: IN STD_LOGIC_VECTOR (63 DOWNTO 0);
			 input2: IN STD_LOGIC_VECTOR (63 DOWNTO 0);
			 wk  : IN STD_LOGIC_VECTOR (63 DOWNTO 0);
			 k_0 : IN STD_LOGIC_VECTOR (63 DOWNTO 0);
			 k_1 : IN STD_LOGIC_VECTOR (63 DOWNTO 0);
			 output1 : OUT STD_LOGIC_VECTOR (63 DOWNTO 0);
			 output2 : OUT STD_LOGIC_VECTOR (63 DOWNTO 0);
			 round : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
			 enc_dec : IN STD_LOGIC;
			 roundStart_Select : IN STD_LOGIC;
			 clk : IN STD_LOGIC);
END Midori64_RoundBased;

ARCHITECTURE behavioral OF Midori64_RoundBased IS
	
												  
	
	SIGNAL add_Result_Start1,
			 add_Result_Start2: STD_LOGIC_VECTOR (63 DOWNTO 0);

	SIGNAL rounds_Output1,
			 rounds_Output2 : STD_LOGIC_VECTOR (63 DOWNTO 0);
	
	BEGIN
		-- PORT MAPPING						  
		
		add_Result_Start1 <= input1 XOR wk;
		add_Result_Start2 <= input2;


		rounds : Entity work.Midori64_Round
			PORT MAP ( input1 => add_Result_Start1,
						  input2 => add_Result_Start2,
					  
						  k_0 => k_0,
						  k_1 => k_1,
						  result1 => rounds_Output1,
						  result2 => rounds_Output2,

						  
						  -- CONTROLLER SIGNALS
						  enc_dec => enc_dec,
						  clk => clk,
						  round_number => round,
						  roundStart_Select => roundStart_Select);
						  
		output1 <= rounds_Output1;
		output2 <= rounds_Output2 XOR wk;
		
END behavioral;

