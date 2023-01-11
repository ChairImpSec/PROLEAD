--
-- -----------------------------------------------------------------
-- COMPANY : Ruhr University Bochum
-- AUTHOR  : Aein Rezaei Shahmirzadi (aein.rezaeishahmirzadi@rub.de)
-- DOCUMENT: "Cryptanalysis of Efficient Masked Ciphers: Applications to Low Latency" TCHES 2022, Issue 1
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



entity LED_RoundFunction is
    Port ( 	clk 			: in  STD_LOGIC; 
				rst 			: in  STD_LOGIC;
				EN 			: in  STD_LOGIC;
				AddKey		: in  STD_LOGIC;
				SelKey		: in  STD_LOGIC;
				FSM		 	: in  STD_LOGIC_VECTOR ( 5 downto 0);
				Plaintext 	: in  STD_LOGIC_VECTOR ( 63 downto 0);
				Key 			: in  STD_LOGIC_VECTOR (127 downto 0);
				SubCellOutput 	: in  STD_LOGIC_VECTOR ( 63 downto 0);
				SubCellInput 	: out  STD_LOGIC_VECTOR ( 63 downto 0);
				Ciphertext 	: out STD_LOGIC_VECTOR ( 63 downto 0)
				
	 
	 );
end LED_RoundFunction;

architecture Behavioral of LED_RoundFunction is
	signal StateRegInput 						: STD_LOGIC_VECTOR(63 downto 0);
	signal StateRegOutput						: STD_LOGIC_VECTOR(63 downto 0);
	signal AddRoundKeyOutput					: STD_LOGIC_VECTOR(63 downto 0);
	signal AddKeyMUXOutput						: STD_LOGIC_VECTOR(63 downto 0);
	signal AddConstInput							: STD_LOGIC_VECTOR(31 downto 0);
	signal AddConstTmp							: STD_LOGIC_VECTOR(31 downto 0);
	signal AddConstOutput						: STD_LOGIC_VECTOR(31 downto 0);
	signal ShiftRowsInput						: STD_LOGIC_VECTOR(63 downto 0);
	signal ShiftRowsOutput						: STD_LOGIC_VECTOR(63 downto 0);
	signal Feedback								: STD_LOGIC_VECTOR(63 downto 0);
	signal RoundKey								: STD_LOGIC_VECTOR(63 downto 0);
	signal CiphertextRegIn						: STD_LOGIC_VECTOR(63 downto 0);
	
	signal K0										: STD_LOGIC_VECTOR(63 downto 0);
	signal K1										: STD_LOGIC_VECTOR(63 downto 0);
	
	signal s0, s1, s2, s3     : STD_LOGIC_VECTOR (4-1 DOWNTO 0);
	signal s4, s5, s6, s7     : STD_LOGIC_VECTOR (4-1 DOWNTO 0);
	signal s8, s9, s10, s11   : STD_LOGIC_VECTOR (4-1 DOWNTO 0);
	signal s12, s13, s14, s15 : STD_LOGIC_VECTOR (4-1 DOWNTO 0);

begin

	StateRegOutput <= Feedback when rst = '0' else Plaintext;	
	
--	StateReg_gen: PROCESS(clk, StateRegInput)
--	BEGIN
--		IF RISING_EDGE(clk) THEN
--			IF (EN = '1') THEN
--			StateRegOutput <= StateRegInput;
--			END IF;
--		END IF;
--	END PROCESS;

	AddRoundKeyOutput <= StateRegOutput XOR RoundKey;

	AddKeyMUXOutput 	<= StateRegOutput when AddKey = '0' else AddRoundKeyOutput;	
	
	AddConstInput 		<= AddKeyMUXOutput(63 downto 56) & AddKeyMUXOutput(47 downto 40) & AddKeyMUXOutput(31 downto 24) & AddKeyMUXOutput(15 downto 8);

	AddConstTmp 		<= x"8" & ('0' & FSM(5 downto 3)) & x"9" & ('0' & FSM(2 downto 0)) & x"2" & ('0' & FSM(5 downto 3)) & x"3" & ('0' & FSM(2 downto 0));
	AddConstOutput 	<= AddConstInput XOR AddConstTmp;



	SubCellInput <= AddConstOutput(31 downto 24) & AddKeyMUXOutput(55 downto 48) &
	                AddConstOutput(23 downto 16) & AddKeyMUXOutput(39 downto 32) &
						 AddConstOutput(15 downto 8)  & AddKeyMUXOutput(23 downto 16) &
						 AddConstOutput(7  downto 0)  & AddKeyMUXOutput(7  downto 0);

	s0	 <= SubCellOutput(4*16-1  downto  4*15);
	s1	 <= SubCellOutput(4*15-1  downto  4*14);
	s2	 <= SubCellOutput(4*14-1  downto  4*13);
	s3	 <= SubCellOutput(4*13-1  downto  4*12);
	s4	 <= SubCellOutput(4*12-1  downto  4*11);
	s5	 <= SubCellOutput(4*11-1  downto  4*10);
	s6	 <= SubCellOutput(4*10-1  downto  4*9);
	s7	 <= SubCellOutput(4*9-1   downto  4*8);
	s8	 <= SubCellOutput(4*8-1   downto  4*7);
	s9	 <= SubCellOutput(4*7-1   downto  4*6);
	s10 <= SubCellOutput(4*6-1   downto  4*5);
	s11 <= SubCellOutput(4*5-1   downto  4*4);
	s12 <= SubCellOutput(4*4-1   downto  4*3);
	s13 <= SubCellOutput(4*3-1   downto  4*2);
	s14 <= SubCellOutput(4*2-1   downto  4*1);
	s15 <= SubCellOutput(4*1-1   downto  4*0);

	ShiftRowsOutput <= s0  & s1 & s2 & s3 & s5 & s6 & s7 & s4 & s10 & s11 & s8 & s9 & s15 & s12 & s13 & s14;
		
		
	MCInst1: ENTITY work.MC
	PORT Map (
		state		=> ShiftRowsOutput,
		result	=> Feedback);

	--===================================================
	
	K0		<= Key(127 downto 64);
	K1		<= Key( 63 downto  0);

	RoundKey <= K0 when rst = '0' else K1;	
		
	--===================================================	
	Ciphertext	<= AddRoundKeyOutput;
	
end Behavioral;

