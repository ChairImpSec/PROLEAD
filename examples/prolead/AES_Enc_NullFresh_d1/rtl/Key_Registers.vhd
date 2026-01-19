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
use IEEE.NUMERIC_STD.ALL;


ENTITY Key_Registers is
    GENERIC ( ShareNumber                     : integer );
    PORT ( clk 		: in  STD_LOGIC;
				EN : in  STD_LOGIC;
           KeyIn 		: in  STD_LOGIC_VECTOR (7 downto 0);
           DoSbox 	: in  STD_LOGIC;
           JustFirstColShift 	: in  STD_LOGIC;
           KeyOut 	: out  STD_LOGIC_VECTOR (7 downto 0);
           KeyToSbox : out  STD_LOGIC_VECTOR (7 downto 0);
           KeyForSchedule : out  STD_LOGIC_VECTOR (7 downto 0));
END Key_Registers;

ARCHITECTURE Behavioral OF Key_Registers IS

	COMPONENT ScanFF_EN IS
		GENERIC (SIZE : integer);
		PORT ( CLK	: IN 	STD_LOGIC;
				 EN 	: IN 	STD_LOGIC;
				 SE 	: IN 	STD_LOGIC;
				 D  	: IN 	STD_LOGIC_VECTOR((SIZE-1) DOWNTO 0);
				 DS	: IN 	STD_LOGIC_VECTOR((SIZE-1) DOWNTO 0);
				 Q 	: OUT STD_LOGIC_VECTOR((SIZE-1) DOWNTO 0));
	END COMPONENT;
	
	

	SIGNAL S0, S1, S2, S3 									: STD_LOGIC_VECTOR (7 downto 0);
	SIGNAL S4, S5, S6, S7 									: STD_LOGIC_VECTOR (7 downto 0);
	SIGNAL S8, S9, S10, S11 								: STD_LOGIC_VECTOR (7 downto 0);
	SIGNAL S12, S13, S14, S15 								: STD_LOGIC_VECTOR (7 downto 0);
	
	SIGNAL S0_in, S1_in, S2_in, S3_in 					: STD_LOGIC_VECTOR (7 downto 0);
	SIGNAL S4_in, S5_in, S6_in, S7_in 					: STD_LOGIC_VECTOR (7 downto 0);
	SIGNAL S8_in, S9_in, S10_in, S11_in 				: STD_LOGIC_VECTOR (7 downto 0);
	SIGNAL S12_in, S13_in, S14_in, S15_in 				: STD_LOGIC_VECTOR (7 downto 0);
	
	SIGNAL Affined_inv_key					 				: STD_LOGIC_VECTOR (7 downto 0);
	SIGNAL Affined_key					 					: STD_LOGIC_VECTOR (7 downto 0);
	SIGNAL SelectedKey					 					: STD_LOGIC_VECTOR (7 downto 0);
	
	SIGNAL EN_first_column,
	       EN_other_column : STD_LOGIC;
	
BEGIN


	SelectedKey <=  KeyIn;
	KeyOut 				<= S0;
	KeyToSbox 			<= S13;
	KeyForSchedule 	<= S12;
	 
	 
	S0_in <= S1;   
	S1_in <= S2;                
	S2_in <= S3; 
	 
	S4_in <= S5;                
	S5_in <= S6;                
	S6_in <= S7; 
		
	S8_in <= S9;                
	S9_in <= S10;                
	S10_in <= S11;  
	
	S12_in <= S13;                
	S13_in <= S14;                
	S14_in <= S15; 

        EN_first_column <= EN;
	EN_other_column	<= EN and (not JustFirstColShift);

	--------------------------------------------- Scan FF --------------------------
	ScanFF_S3: ScanFF_EN 
	GENERIC MAP(SIZE => 8)	
	PORT MAP(
		EN  => EN_first_column,
		CLK => clk,
		SE => DoSbox,
		D => S4,
		DS => S0,
		Q => S3 );
	
	ScanFF_S7: ScanFF_EN
	GENERIC MAP(SIZE => 8)	
	PORT MAP(
		EN  => EN_other_column,
		CLK => clk,
		SE => DoSbox,
		D => S8,
		DS => S4,
		Q => S7 );
		
	ScanFF_S11: ScanFF_EN
	GENERIC MAP(SIZE => 8)	
	PORT MAP(
		EN  => EN_other_column,
		CLK => clk,
		SE => DoSbox,
		D => S12,
		DS => S8,
		Q => S11 );
		 
	ScanFF_S15: ScanFF_EN
	GENERIC MAP(SIZE => 8)	
	PORT MAP(
		EN  => EN_other_column,
		CLK => clk,
		SE => DoSbox,
		D => SelectedKey,
		DS => S12,
		Q => S15 );
	
	----------------------------------------Registers------------------------------
	reg_gen1: PROCESS(clk, EN_first_column, S0_in, S1_in, S2_in)
	BEGIN
		IF (RISING_EDGE(clk) and (EN_first_column = '1')) THEN
			S0 <= S0_in;
			S1 <= S1_in;
			S2 <= S2_in;
		END IF;
	END PROCESS;
	
	reg_gen2: PROCESS(clk, EN_other_column, S4_in, S5_in, S6_in, S8_in, S9_in, S10_in, S12_in, S13_in, S14_in)
	BEGIN
		IF (RISING_EDGE(clk) and (EN_other_column = '1')) THEN
			S4 <= S4_in;
			S5 <= S5_in;
			S6 <= S6_in;
			S8 <= S8_in;
			S9 <= S9_in;
			S10 <= S10_in;
			S12 <= S12_in;
			S13 <= S13_in;
			S14 <= S14_in;
		END IF;
	END PROCESS;
	
end Behavioral;

