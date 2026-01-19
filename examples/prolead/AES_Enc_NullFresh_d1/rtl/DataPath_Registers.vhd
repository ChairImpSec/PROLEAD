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


ENTITY DataPath_Registers is
	 generic ( ShareNumber                     : integer );
    PORT ( clk : in  STD_LOGIC;
			  EN : in  STD_LOGIC;
			  StateIn : in  STD_LOGIC_VECTOR (7 downto 0);
           DoMC : in  STD_LOGIC;
           DoSR : in  STD_LOGIC;
           StateOut : out  STD_LOGIC_VECTOR (7 downto 0));
end DataPath_Registers;

architecture Behavioral of DataPath_Registers is
	
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
	
	SIGNAL in1, in2, in3, in4 								: STD_LOGIC_VECTOR (7 downto 0);
	SIGNAL MC0, MC1, MC2, MC3 								: STD_LOGIC_VECTOR (7 downto 0);
	SIGNAL out1, out2, out3, out4 						: STD_LOGIC_VECTOR (7 downto 0);
	SIGNAL S0_xor_S1, S2_xor_S3 	 						: STD_LOGIC_VECTOR (7 downto 0);
	
	SIGNAL conditionalXOR1, conditionalXOR2, 
			 conditionalXOR3, conditionalXOR4 			: STD_LOGIC_VECTOR (7 downto 0);
	SIGNAL ShiftedData1, ShiftedData2,
			 ShiftedData3, ShiftedData4 					: STD_LOGIC_VECTOR (7 downto 0);
	SIGNAL mult2_in1, mult2_in2,
			 mult2_in3, mult2_in4 							: STD_LOGIC_VECTOR (7 downto 0);
	SIGNAL mult3_in1, mult3_in2,
			 mult3_in3, mult3_in4 							: STD_LOGIC_VECTOR (7 downto 0);
	
	signal reg_A_output1_1									: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal reg_A_output2_1									: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal reg_A_output3_1									: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal reg_A_output4_1									: STD_LOGIC_VECTOR (7 DOWNTO 0);

	
	signal Affine_out1_1										: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal Affine_out2_1										: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal Affine_out3_1										: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal Affine_out4_1										: STD_LOGIC_VECTOR (7 DOWNTO 0);
	
	
begin




	StateOut <= MC0 when (DoMC = '1') else S0;


	state_movement: process (StateIn, S1, S2, S3, S4, S5, S6,
                           S9, S11, S13, DoSR, 
									DoMC, MC1, MC2, MC3
									) is
   begin 
  
		S0_in <= S1;
		S1_in <= S2;                
		S2_in <= S3; 
		S3_in <= S4;
				
		S4_in <= S5;                
		S8_in <= S9;                
		S12_in <= S13;                

		if (DoSR = '1') then
					
			S1_in <= S6;                
			S2_in <= S11;                
			S3_in <= StateIn;             

		 -- MixColumns movement
		 elsif (DoMC = '1') then

			S0_in <= MC1;                
			S1_in <= MC2;                
			S2_in <= MC3;                
				
		end if;
  end process state_movement;
  
	--------------------------------------------- Scan FF --------------------------
	ScanFF_S5: ScanFF_EN 
	GENERIC MAP(SIZE => 8)	
	PORT MAP(
		EN  => EN,
		CLK => clk,
		SE => DoSR,
		D => S6,
		DS => S10,
		Q => S5 );
		
	ScanFF_S6: ScanFF_EN 
	GENERIC MAP(SIZE => 8)	
	PORT MAP(
		EN  => EN,
		CLK => clk,
		SE => DoSR,
		D => S7,
		DS => S15,
		Q => S6 );
		
	ScanFF_S7: ScanFF_EN 
	GENERIC MAP(SIZE => 8)	
	PORT MAP(
		EN  => EN,
		CLK => clk,
		SE => DoSR,
		D => S8,
		DS => S4,
		Q => S7 );
		
	ScanFF_S9: ScanFF_EN 
	GENERIC MAP(SIZE => 8)	
	PORT MAP(
		EN  => EN,
		CLK => clk,
		SE => DoSR,
		D => S10,
		DS => S14,
		Q => S9 );
		
	ScanFF_S10: ScanFF_EN 
	GENERIC MAP(SIZE => 8)	
	PORT MAP(
		EN  => EN,
		CLK => clk,
		SE => DoSR,
		D => S11,
		DS => S3,
		Q => S10 );
		
	ScanFF_S11: ScanFF_EN 
	GENERIC MAP(SIZE => 8)	
	PORT MAP(
		EN  => EN,
		CLK => clk,
		SE => DoSR,
		D => S12,
		DS => S8,
		Q => S11 );
		
	ScanFF_S13: ScanFF_EN 
	GENERIC MAP(SIZE => 8)	
	PORT MAP(
		EN  => EN,
		CLK => clk,
		SE => DoSR,
		D => S14,
		DS => S2,
		Q => S13 );
		
	ScanFF_S14: ScanFF_EN 
	GENERIC MAP(SIZE => 8)	
	PORT MAP(
		EN  => EN,
		CLK => clk,
		SE => DoSR,
		D => S15,
		DS => S7,
		Q => S14 );
		
	ScanFF_S15: ScanFF_EN 
	GENERIC MAP(SIZE => 8)	
	PORT MAP(
		EN  => EN,
		CLK => clk,
		SE => DoSR,
		D => StateIn,
		DS => S12,
		Q => S15 );
		
	--------------------------------------------- Regular FF --------------------------
	reg_gen: PROCESS(clk, EN, S0_in, S1_in, S2_in, S3_in, S4_in, S8_in, S12_in)
	BEGIN
		IF (RISING_EDGE(clk) and (EN = '1')) THEN
			S0 <= S0_in;
			S1 <= S1_in;
			S2 <= S2_in;
			S3 <= S3_in;
			S4 <= S4_in;
			S8 <= S8_in;
			S12 <= S12_in;
		END IF;
	END PROCESS;	
	
	
	------------------------------------- Mix Column -------------------------
	
	
	--- Beta
	S0_xor_S1 <= S0_in xor S1_in;
	S2_xor_S3 <= S2_in xor S3_in;
	
	out1 <= S0_in xor S2_xor_S3;
	out2 <= S0_xor_S1 xor S3_in;
	out3 <= S0_xor_S1 xor S2_in;
	out4 <= S1_in xor S2_xor_S3;
	
	
	GEN_reg1: ENTITY work.regE
	GENERIC map ( size => 32)
	Port Map (
		EN  => EN,
		clk						=> clk,
		D(7 downto 0)			=> out1,
		D(15 downto 8)			=> out2,
		D(23 downto 16)		=> out3,
		D(31 downto 24)		=> out4,
		Q(7 downto 0)			=> reg_A_output1_1,
		Q(15 downto 8)			=> reg_A_output2_1,
		Q(23 downto 16)		=> reg_A_output3_1,
		Q(31 downto 24)		=> reg_A_output4_1	);
		
	
	GenShareNumber0: IF ShareNumber = 0 GENERATE
		A1: ENTITY work.Affine_output
		Port Map(reg_A_output1_1, Affine_out1_1);
		
		A2: ENTITY work.Affine_output
		Port Map(reg_A_output2_1, Affine_out2_1);
		
		A3: ENTITY work.Affine_output
		Port Map(reg_A_output3_1, Affine_out3_1);
		
		A4: ENTITY work.Affine_output
		Port Map(reg_A_output4_1, Affine_out4_1);
	END GENERATE;
	
	GenShareNumber1: IF ShareNumber /= 0 GENERATE
		A1: ENTITY work.Affine_outputC
		Port Map(reg_A_output1_1, Affine_out1_1);
		
		A2: ENTITY work.Affine_outputC
		Port Map(reg_A_output2_1, Affine_out2_1);
		
		A3: ENTITY work.Affine_outputC
		Port Map(reg_A_output3_1, Affine_out3_1);
		
		A4: ENTITY work.Affine_outputC
		Port Map(reg_A_output4_1, Affine_out4_1);
	END GENERATE;
	
	
	in1 <= Affine_out1_1;
	in2 <= Affine_out2_1;
	in3 <= Affine_out3_1;
	in4 <= Affine_out4_1;
	
	conditionalXOR1 <= "000" & in1(7) & in1(7) & "0" & in1(7) & in1(7);
	ShiftedData1 	<= in1(6 downto 0) & "0";
	mult2_in1 <= ShiftedData1 xor conditionalXOR1;
	
	conditionalXOR2 <= "000" & in2(7) & in2(7) & "0" & in2(7) & in2(7);
	ShiftedData2 	<= in2(6 downto 0) & "0";
	mult2_in2 <= ShiftedData2 xor conditionalXOR2;
	
	conditionalXOR3 <= "000" & in3(7) & in3(7) & "0" & in3(7) & in3(7);
	ShiftedData3 	<= in3(6 downto 0) & "0";
	mult2_in3 <= ShiftedData3 xor conditionalXOR3;
	
	conditionalXOR4 <= "000" & in4(7) & in4(7) & "0" & in4(7) & in4(7);
	ShiftedData4 	<= in4(6 downto 0) & "0";
	mult2_in4 <= ShiftedData4 xor conditionalXOR4;

	mult3_in1 <= mult2_in1 xor in1;
	mult3_in2 <= mult2_in2 xor in2;
	mult3_in3 <= mult2_in3 xor in3;
	mult3_in4 <= mult2_in4 xor in4;
	
	MC0 <= mult2_in1 xor mult3_in4;
	MC1 <= mult2_in2 xor mult3_in1;
	MC2 <= mult2_in3 xor mult3_in2;
	MC3 <= mult2_in4 xor mult3_in3;
	
end Behavioral;

