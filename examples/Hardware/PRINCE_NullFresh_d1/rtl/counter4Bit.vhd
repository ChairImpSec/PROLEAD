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

ENTITY counter4Bit IS
	PORT ( clk     : IN  STD_LOGIC;
			 reset : IN  STD_LOGIC;
			 MoreControl : out std_logic;
			 roundEnd_Select : out std_logic;
			 q       : OUT STD_LOGIC_VECTOR (3 DOWNTO 0));
END counter4bit;

ARCHITECTURE behavioral OF counter4Bit IS

	signal feedback 						: std_logic_vector(3 downto 0);
	signal CountPlusOne 					: std_logic_vector(3 downto 0);
	signal mux_count_out 				: std_logic_vector(3 downto 0);
	signal sel_count     				: std_logic;
	signal sel_EachRoundCount			: std_logic;
	signal EQ7     						: std_logic;
	signal CO     						: std_logic;
	signal g     						: std_logic;
	signal tmp     						: std_logic;
	signal tmp_reg     						: std_logic;
	signal zero_or_PlusOne_count : std_logic_vector(3 downto 0);
	signal feedback1, zero_or_PlusOne, eachroundcounter, mux_eachroundcounter_out : std_logic_vector(1 downto 0);

begin

	
	roundEnd_Select <= feedback(3);

	EQ7 <= '1' when feedback = "0111" else '0';
	g   <= '1' when (eachroundcounter > "10") else '0';
	
	MoreControl <= (g) and EQ7;
	sel_count 				<= '1' when (eachroundcounter = "10" and feedback /= "0111") or (eachroundcounter = "11" and feedback = "0111") else '0';
	sel_EachRoundCount 	<= sel_count;

	counterMUX: ENTITY work.MUX
	GENERIC Map ( size => 4)
	PORT Map ( 
		sel	=> reset,
		D0   	=> feedback,
		D1 	=> "0010",
		Q 		=> mux_count_out);
		

	Adder_inst : ENTITY work.Adder
		PORT MAP ( A  		=> mux_count_out,
					  B  		=> "0001",
					  Cin 	=> '0',
					  S  		=> CountPlusOne,
					  cout  	=> open);
					  
	EachRoundMUX3: ENTITY work.MUX
	GENERIC Map ( size => 4)
	PORT Map ( 
		sel	=> sel_count,
		D1   	=> CountPlusOne,
		D0 	=> mux_count_out,
		Q 		=> zero_or_PlusOne_count);
					  
	Inst_Reg: ENTITY work.reg
	Generic MAP (size => 4)
	Port Map(
		clk				=> clk,
		D					=> zero_or_PlusOne_count,
		Q					=> feedback);

	q <= feedback;	
	
	
	EachRoundMUX: ENTITY work.MUX
	GENERIC Map ( size => 2)
	PORT Map ( 
		sel	=> reset,
		D0   	=> feedback1,
		D1 	=> "00",
		Q 		=> mux_eachroundcounter_out);
		
		
		FA1: ENTITY work.full_adder port map( mux_eachroundcounter_out(0), '1', '0', eachroundcounter(0), CO);
		FA2: ENTITY work.full_adder port map( mux_eachroundcounter_out(1), '0', CO, eachroundcounter(1), open);
					  
	
	EachRoundMUX2: ENTITY work.MUX
	GENERIC Map ( size => 2)
	PORT Map ( 
		sel	=> sel_EachRoundCount,
		D0   	=> eachroundcounter,
		D1 	=> "00",
		Q 		=> zero_or_PlusOne);
					  

	
	Inst_Reg1: ENTITY work.reg
	Generic MAP (size => 2)
	Port Map(
		clk				=> clk,
		D					=> zero_or_PlusOne,
		Q					=> feedback1);
		
	
	
END behavioral;

