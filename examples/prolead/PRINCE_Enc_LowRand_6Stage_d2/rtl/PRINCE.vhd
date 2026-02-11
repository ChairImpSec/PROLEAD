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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Cipher is
    Port ( clk       : in  STD_LOGIC;
           reset     : in  STD_LOGIC;
           input_s1  : in  STD_LOGIC_VECTOR (63 DOWNTO 0);
			  input_s2  : in  STD_LOGIC_VECTOR (63 DOWNTO 0);
			  input_s3  : in  STD_LOGIC_VECTOR (63 DOWNTO 0);
			  Static_r  : in  STD_LOGIC_VECTOR (215 DOWNTO 0);
          Dynamic_r  : in  STD_LOGIC_VECTOR (31 DOWNTO 0);
           output_s1 : OUT STD_LOGIC_VECTOR (63 DOWNTO 0);
           output_s2 : OUT STD_LOGIC_VECTOR (63 DOWNTO 0);
           output_s3 : OUT STD_LOGIC_VECTOR (63 DOWNTO 0);
			  Key1       : in  STD_LOGIC_VECTOR (127 DOWNTO 0);
			  Key2       : in  STD_LOGIC_VECTOR (127 DOWNTO 0);
			  Key3       : in  STD_LOGIC_VECTOR (127 DOWNTO 0);
			  enc_dec   : in  STD_LOGIC;
			  done      : OUT STD_LOGIC);
end Cipher;

architecture Behavioral of Cipher is

		COMPONENT Controller
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;          
		round : OUT std_logic_vector(3 downto 0);
		roundStart_Select : OUT std_logic;
		roundHalf_Select : OUT std_logic;
		roundEnd_Select : OUT std_logic;
		done : OUT std_logic
		);
	END COMPONENT;
	
	signal output_PRINCE_s1 : STD_LOGIC_VECTOR (63 DOWNTO 0);
	signal output_PRINCE_s2 : STD_LOGIC_VECTOR (63 DOWNTO 0);
	signal output_PRINCE_s3 : STD_LOGIC_VECTOR (63 DOWNTO 0);
	SIGNAL round_Signal : STD_LOGIC_VECTOR (3 DOWNTO 0);
	SIGNAL roundStart_Select_Signal, roundHalf_Select_Signal, roundEnd_Select_Signal, done_Controller : STD_LOGIC;
	
	SIGNAL round_Signal1 : STD_LOGIC_VECTOR (3 DOWNTO 0);
	SIGNAL roundStart_Select_Signal1, roundHalf_Select_Signal1, roundEnd_Select_Signal1, done_Controller1 : STD_LOGIC;

begin


						  
				  
		MyController: Controller
		PORT MAP ( clk => clk,
				  reset => reset,
				  round => round_Signal,
				  roundStart_Select => roundStart_Select_Signal,
				  roundHalf_Select => roundHalf_Select_Signal,
				  roundEnd_Select => roundEnd_Select_Signal,
				  done => done_Controller);
						  
		prince: entity work.PRINCE_RoundBased
			PORT MAP ( input_s1 => input_s1,
						  input_s2 => input_s2,
						  input_s3 => input_s3,
						  Static_r 	=> Static_r,
							Dynamic_r 	=> Dynamic_r,
						  Key1 => Key1,
						  Key2 => Key2,
						  Key3 => Key3,
						  output_s1 => output_PRINCE_s1,
						  output_s2 => output_PRINCE_s2,
						  output_s3 => output_PRINCE_s3,
						  round => round_Signal,
						  reset	 => reset,
						  enc_dec => enc_dec,
						  roundStart_Select => roundStart_Select_Signal,
						  roundHalf_Select => roundHalf_Select_Signal,
						  roundEnd_Select => roundEnd_Select_Signal,
						  clk => clk);
						  
	output_s1 <= output_PRINCE_s1;
	output_s2 <= output_PRINCE_s2;
	output_s3 <= output_PRINCE_s3;
	
	done   <= done_Controller;

end Behavioral;

