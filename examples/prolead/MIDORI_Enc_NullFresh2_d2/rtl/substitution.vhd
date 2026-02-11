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


ENTITY substitution IS
		PORT ( state1  : IN  STD_LOGIC_VECTOR (63 DOWNTO 0);
				 state2  : IN  STD_LOGIC_VECTOR (63 DOWNTO 0);
				 state3  : IN  STD_LOGIC_VECTOR (63 DOWNTO 0);
				 r  : IN  STD_LOGIC_VECTOR (127 DOWNTO 0);
				 clk		: IN  STD_LOGIC;
				 result1 : OUT  STD_LOGIC_VECTOR (63 DOWNTO 0);
				 result2 : OUT  STD_LOGIC_VECTOR (63 DOWNTO 0);
				 result3 : OUT  STD_LOGIC_VECTOR (63 DOWNTO 0));
END substitution;

ARCHITECTURE behavioral OF substitution IS

		COMPONENT MidoriSbox
	PORT(
		clk : IN std_logic;
		in1 : IN std_logic_vector(3 downto 0);
		in2 : IN std_logic_vector(3 downto 0);
		in3 : IN std_logic_vector(3 downto 0);
		r : IN std_logic_vector(7 downto 0);          
		out1 : OUT std_logic_vector(3 downto 0);
		out2 : OUT std_logic_vector(3 downto 0);
		out3 : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;
	
	BEGIN
		substition_Midori:
			FOR i IN 0 TO 15 GENERATE
			
				Sub: MidoriSbox 
				PORT MAP(
					clk => clk,
					in1 => state1(((i+1) * 4 - 1) DOWNTO i*4),
					in2 => state2(((i+1) * 4 - 1) DOWNTO i*4),
					in3 => state3(((i+1) * 4 - 1) DOWNTO i*4),
					r 	 => r(((i+1) * 8 - 1) DOWNTO i*8),
					out1 => result1(((i+1) * 4 - 1) DOWNTO i*4),
					out2 => result2(((i+1) * 4 - 1) DOWNTO i*4),
					out3 => result3(((i+1) * 4 - 1) DOWNTO i*4));
	
			END GENERATE;
END behavioral;

