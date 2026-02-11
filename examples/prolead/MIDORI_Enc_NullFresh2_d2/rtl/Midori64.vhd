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

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Midori64 is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           r 	: in  STD_LOGIC_VECTOR (127 DOWNTO 0);
           input1 : in  STD_LOGIC_VECTOR (63 DOWNTO 0);
			  input2 : in  STD_LOGIC_VECTOR (63 DOWNTO 0);
			  input3 : in  STD_LOGIC_VECTOR (63 DOWNTO 0);
           output1 : OUT  STD_LOGIC_VECTOR (63 DOWNTO 0);
			  output2 : OUT  STD_LOGIC_VECTOR (63 DOWNTO 0);
			  output3 : OUT  STD_LOGIC_VECTOR (63 DOWNTO 0);
			  Key1 : in  STD_LOGIC_VECTOR (127 DOWNTO 0);
			  Key2 : in  STD_LOGIC_VECTOR (127 DOWNTO 0);
			  Key3 : in  STD_LOGIC_VECTOR (127 DOWNTO 0);
			  enc_dec : in  STD_LOGIC;
			  done : OUT STD_LOGIC);
end Midori64;

architecture Behavioral of Midori64 is
	COMPONENT key_Derivation IS
		PORT ( key : IN STD_LOGIC_VECTOR (127 DOWNTO 0);
				 wk, k_0, k_1: OUT STD_LOGIC_VECTOR (63 DOWNTO 0));
	END COMPONENT;
	
	SIGNAL wk, k_0, k_1, 
	       output1_Midori64,
			 output2_Midori64,
			 output3_Midori64 : STD_LOGIC_VECTOR (63 DOWNTO 0);
	SIGNAL round_Signal : STD_LOGIC_VECTOR (3 DOWNTO 0);
	SIGNAL roundStart_Select_Signal, done_Controller : STD_LOGIC;
	SIGNAL EN : STD_LOGIC;
	
	SIGNAL wk_share1, k_0_share1, k_1_share1 : STD_LOGIC_VECTOR (63 DOWNTO 0);
	SIGNAL wk_share2, k_0_share2, k_1_share2 : STD_LOGIC_VECTOR (63 DOWNTO 0);
	SIGNAL wk_share3, k_0_share3, k_1_share3 : STD_LOGIC_VECTOR (63 DOWNTO 0);


begin

		KeySchadule1: key_Derivation
		PORT MAP ( key => Key1,
					  wk  => wk_share1,
					  k_0 => k_0_share1,
					  k_1 => k_1_share1);
						  
		KeySchadule2: key_Derivation
		PORT MAP ( key => Key2,
					  wk  => wk_share2,
					  k_0 => k_0_share2,
					  k_1 => k_1_share2);
					  
		KeySchadule3: key_Derivation
		PORT MAP ( key => Key3,
					  wk  => wk_share3,
					  k_0 => k_0_share3,
					  k_1 => k_1_share3);

						  
		controller: ENTITY work.Midori64_Controller
		PORT MAP ( clk => clk,
				  reset => reset,
				  round => round_Signal,
				  roundStart_Select => roundStart_Select_Signal,
				  EN => EN,
				  done => done_Controller);
						  
		Midori: Entity work.Midori64_RoundBased
			PORT MAP ( input1 => input1,
						  input2 => input2,
						  input3 => input3,
						  r => r,
						  wk_share1  => wk_share1,
						  k_0_share1 => k_0_share1,
						  k_1_share1 => k_1_share1,
						  wk_share2  => wk_share2,
						  k_0_share2 => k_0_share2,
						  k_1_share2 => k_1_share2,
						  wk_share3  => wk_share3,
						  k_0_share3 => k_0_share3,
						  k_1_share3 => k_1_share3,
						  output1 => output1_Midori64,
						  output2 => output2_Midori64,
						  output3 => output3_Midori64,
						  round => round_Signal,
						  enc_dec => enc_dec,
						  EN => EN,
						  roundStart_Select => roundStart_Select_Signal,
						  clk => clk);
						  
	output1 <= output1_Midori64;
	output2 <= output2_Midori64;
	output3 <= output3_Midori64;
	
	done   <= done_Controller;

end Behavioral;

