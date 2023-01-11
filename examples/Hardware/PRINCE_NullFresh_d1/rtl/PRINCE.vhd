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

entity Cipher is
    Port ( clk       : in  STD_LOGIC;
           rst		     : in  STD_LOGIC;
           input_s1  : in  STD_LOGIC_VECTOR (63 DOWNTO 0);
			  input_s2  : in  STD_LOGIC_VECTOR (63 DOWNTO 0);
           output_s1 : OUT STD_LOGIC_VECTOR (63 DOWNTO 0);
           output_s2 : OUT STD_LOGIC_VECTOR (63 DOWNTO 0);
			  Key       : in  STD_LOGIC_VECTOR (127 DOWNTO 0);
			  enc_dec   : in  STD_LOGIC;
			  done      : OUT STD_LOGIC);
end Cipher;

architecture Behavioral of Cipher is
	COMPONENT key_Derivation IS
		PORT ( key : IN STD_LOGIC_VECTOR (127 DOWNTO 0);
				 k_0, k_0_p, k_1: OUT STD_LOGIC_VECTOR (63 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT PRINCE_Controller IS
		PORT ( clk : IN  STD_LOGIC;
				 reset : IN  STD_LOGIC;
				 round : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
				 roundStart_Select : OUT STD_LOGIC;
				 roundHalf_Select : OUT STD_LOGIC;
				 roundEnd_Select : OUT STD_LOGIC;
				 done : OUT STD_LOGIC);
	end COMPONENT;
	
	COMPONENT PRINCE_RoundBased IS
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
	END COMPONENT;
	
	SIGNAL k_0, k_0_p, k_1 : STD_LOGIC_VECTOR (63 DOWNTO 0);
	signal output_PRINCE_s1 : STD_LOGIC_VECTOR (63 DOWNTO 0);
	signal output_PRINCE_s2 : STD_LOGIC_VECTOR (63 DOWNTO 0);
	SIGNAL round_Signal : STD_LOGIC_VECTOR (3 DOWNTO 0);
	SIGNAL roundStart_Select_Signal, roundHalf_Select_Signal, roundEnd_Select_Signal, done_Controller, reset : STD_LOGIC;

begin

		reset <= rst;
		-- PORT MAPPING
		keys: key_Derivation
			PORT MAP ( key => key,
						  k_0 => k_0,
						  k_0_p => k_0_p,
						  k_1 => k_1);
						  
		controller: PRINCE_Controller
		PORT MAP ( clk => clk,
				  reset => reset,
				  round => round_Signal,
				  roundStart_Select => roundStart_Select_Signal,
				  roundHalf_Select => roundHalf_Select_Signal,
				  roundEnd_Select => roundEnd_Select_Signal,
				  done => done_Controller);
						  
		prince: PRINCE_RoundBased
			PORT MAP ( input_s1 => input_s1,
						  input_s2 => input_s2,
						  k_0 => k_0,
						  k_0_p => k_0_p,
						  k_1 => k_1,
						  output_s1 => output_PRINCE_s1,
						  output_s2 => output_PRINCE_s2,
						  round => round_Signal,
						  reset	 => reset,
						  enc_dec => enc_dec,
						  roundStart_Select => roundStart_Select_Signal,
						  roundHalf_Select => roundHalf_Select_Signal,
						  roundEnd_Select => roundEnd_Select_Signal,
						  clk => clk);
						  
	output_s1 <= output_PRINCE_s1;
	output_s2 <= output_PRINCE_s2;
	
	done   <= done_Controller;

end Behavioral;

