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

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Midori64 is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           input1 : in  STD_LOGIC_VECTOR (63 DOWNTO 0);
			  input2 : in  STD_LOGIC_VECTOR (63 DOWNTO 0);
           output1 : OUT  STD_LOGIC_VECTOR (63 DOWNTO 0);
			  output2 : OUT  STD_LOGIC_VECTOR (63 DOWNTO 0);
			  key : in  STD_LOGIC_VECTOR (127 DOWNTO 0);
			  enc_dec : in  STD_LOGIC;
			  done : OUT STD_LOGIC);
end Midori64;

architecture Behavioral of Midori64 is
	COMPONENT key_Derivation IS
		PORT ( key : IN STD_LOGIC_VECTOR (127 DOWNTO 0);
				 wk, k_0, k_1: OUT STD_LOGIC_VECTOR (63 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT Midori64_Controller IS
		PORT ( clk : IN  STD_LOGIC;
				 reset : IN  STD_LOGIC;
				 round : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
				 roundStart_Select : OUT STD_LOGIC;
				 done : OUT STD_LOGIC);
	end COMPONENT;
	

	
	SIGNAL wk, k_0, k_1, 
	       output1_Midori64,
			 output2_Midori64 : STD_LOGIC_VECTOR (63 DOWNTO 0);
	SIGNAL round_Signal : STD_LOGIC_VECTOR (3 DOWNTO 0);
	SIGNAL roundStart_Select_Signal, done_Controller : STD_LOGIC;

begin
		-- PORT MAPPING
		keys: key_Derivation
			PORT MAP ( key => key,
						  wk  => wk,
						  k_0 => k_0,
						  k_1 => k_1);
						  
		controller: Midori64_Controller
		PORT MAP ( clk => clk,
				  reset => reset,
				  round => round_Signal,
				  roundStart_Select => roundStart_Select_Signal,
				  done => done_Controller);
						  
		Midori: Entity work.Midori64_RoundBased
			PORT MAP ( input1 => input1,
						  input2 => input2,

						  wk  => wk,
						  k_0 => k_0,
						  k_1 => k_1,
						  output1 => output1_Midori64,
						  output2 => output2_Midori64,

						  round => round_Signal,
						  enc_dec => enc_dec,
						  roundStart_Select => roundStart_Select_Signal,
						  clk => clk);
						  
	output1 <= output1_Midori64;
	output2 <= output2_Midori64;

	
	done   <= done_Controller;

end Behavioral;

