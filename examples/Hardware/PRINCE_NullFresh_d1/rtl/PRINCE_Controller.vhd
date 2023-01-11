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
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY PRINCE_Controller IS
    PORT ( clk : IN  STD_LOGIC;
			  reset : IN  STD_LOGIC;
			  round : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
			  roundStart_Select : OUT STD_LOGIC;
			  roundHalf_Select : OUT STD_LOGIC;
			  roundEnd_Select : OUT STD_LOGIC;
			  done : OUT STD_LOGIC);
end PRINCE_Controller;

ARCHITECTURE behavioral OF PRINCE_Controller IS	

	COMPONENT counter4Bit IS
		PORT ( clk     : IN STD_LOGIC;
				 reset   : IN STD_LOGIC;
				 MoreControl : out std_logic;
				 roundEnd_Select : out std_logic;
				 q       : OUT STD_LOGIC_VECTOR (3 DOWNTO 0));
	END COMPONENT;
	
	SIGNAL counter_round : STD_LOGIC_VECTOR (3 DOWNTO 0);
	SIGNAL MoreControl 	: STD_LOGIC;
	
BEGIN

	roundCounter: counter4Bit
		PORT MAP ( clk     => clk,
					  reset 	 => reset,
					  MoreControl => MoreControl,
					  roundEnd_Select => roundEnd_Select,
					  q       => counter_round);
					  
	round <= counter_round;
	
	roundStart_Select <= reset;
	
	roundHalf_Select  <= counter_round(3) or MoreControl;
	

	done              <= '1' WHEN counter_round = "1101" else '0';

END behavioral;

