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


ENTITY Midori64_Round IS
	PORT ( input1            : IN  STD_LOGIC_VECTOR (63 DOWNTO 0);
			 input2            : IN  STD_LOGIC_VECTOR (63 DOWNTO 0);
			 k_0               : IN  STD_LOGIC_VECTOR (63 downto 0);
			 k_1               : IN  STD_LOGIC_VECTOR (63 downto 0);
			 result1           : OUT  STD_LOGIC_VECTOR (63 downto 0);
			 result2           : OUT  STD_LOGIC_VECTOR (63 downto 0);

			 -- CONTROLLER PORTS
			 enc_dec           : IN STD_LOGIC;
			 clk               : IN STD_LOGIC;
			 round_number      : IN STD_LOGIC_VECTOR (3 DOWNTO 0); -- besser in round ändern
			 roundStart_Select : IN STD_LOGIC);
END Midori64_Round;

ARCHITECTURE behavioral OF Midori64_Round IS
	
	COMPONENT ScanFF IS
		GENERIC (SIZE : integer);
		PORT ( CLK	: IN 	STD_LOGIC;
				 SE 	: IN 	STD_LOGIC;
				 D  	: IN 	STD_LOGIC_VECTOR((SIZE-1) DOWNTO 0);
				 DS	: IN 	STD_LOGIC_VECTOR((SIZE-1) DOWNTO 0);
				 Q 	: OUT STD_LOGIC_VECTOR((SIZE-1) DOWNTO 0));
	END COMPONENT;
	
	COMPONENT roundConstant_MUX IS
		PORT ( round : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
				 enc_dec: IN STD_LOGIC;
				 roundConstant : OUT  STD_LOGIC_VECTOR (15 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT ShiftRows_Inverse is
		PORT ( state : in  STD_LOGIC_VECTOR (63 downto 0);
				  result : out  STD_LOGIC_VECTOR (63 downto 0));
	END COMPONENT;
	
	COMPONENT matrixMultiplication IS
		PORT ( state : IN  STD_LOGIC_VECTOR (63 DOWNTO 0);
				 result : OUT  STD_LOGIC_VECTOR (63 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT ShiftRows is
		PORT ( state : IN  STD_LOGIC_VECTOR (63 DOWNTO 0);
				 result : OUT  STD_LOGIC_VECTOR (63 DOWNTO 0));
	END COMPONENT;
	
	SIGNAL round_Constant     : STD_LOGIC_VECTOR (15 DOWNTO 0);

	SIGNAL SelectedKey,
			 ProcessedKey,
			 roundReg_out1,
			 roundReg_out2,

			 sub_Result1,
			 sub_Result2,

			 SR_Result1,
			 SR_Result2,

			 sub_ResultXORkey1,
			 sub_ResultXORkey2,

			 mul_input1,
			 mul_input2,

			 mul_Result1,
			 mul_Result2,

			 SR_Inv_Result1,
			 SR_Inv_Result2,

			 mul_ResultXORkey1,
			 mul_ResultXORkey2,

			 round_Result1,
			 round_Result2 : STD_LOGIC_VECTOR (63 DOWNTO 0);
	
	BEGIN 
						  
		constant_MUX : roundConstant_MUX
			PORT MAP ( round => round_number,
						  enc_dec => enc_dec,
						  roundConstant => round_Constant);

		SelectedKey	<= k_0 when round_number(0) = '0' else k_1;

		ProcessedKey(63 downto 61) <= SelectedKey(63 downto 61);
		ProcessedKey(59 downto 57) <= SelectedKey(59 downto 57);
		ProcessedKey(55 downto 53) <= SelectedKey(55 downto 53);
		ProcessedKey(51 downto 49) <= SelectedKey(51 downto 49);
		ProcessedKey(47 downto 45) <= SelectedKey(47 downto 45);
		ProcessedKey(43 downto 41) <= SelectedKey(43 downto 41);
		ProcessedKey(39 downto 37) <= SelectedKey(39 downto 37);
		ProcessedKey(35 downto 33) <= SelectedKey(35 downto 33);
		ProcessedKey(31 downto 29) <= SelectedKey(31 downto 29);
		ProcessedKey(27 downto 25) <= SelectedKey(27 downto 25);
		ProcessedKey(23 downto 21) <= SelectedKey(23 downto 21);
		ProcessedKey(19 downto 17) <= SelectedKey(19 downto 17);
		ProcessedKey(15 downto 13) <= SelectedKey(15 downto 13);
		ProcessedKey(11 downto  9) <= SelectedKey(11 downto  9);
		ProcessedKey( 7 downto  5) <= SelectedKey( 7 downto  5);
		ProcessedKey( 3 downto  1) <= SelectedKey( 3 downto  1);

		ProcessedKey(60)	<= SelectedKey(60) XOR round_Constant(15);
		ProcessedKey(56)	<= SelectedKey(56) XOR round_Constant(14);
		ProcessedKey(52)	<= SelectedKey(52) XOR round_Constant(13);
		ProcessedKey(48)	<= SelectedKey(48) XOR round_Constant(12);
		ProcessedKey(44)	<= SelectedKey(44) XOR round_Constant(11);
		ProcessedKey(40)	<= SelectedKey(40) XOR round_Constant(10);
		ProcessedKey(36)	<= SelectedKey(36) XOR round_Constant( 9);
		ProcessedKey(32)	<= SelectedKey(32) XOR round_Constant( 8);
		ProcessedKey(28)	<= SelectedKey(28) XOR round_Constant( 7);
		ProcessedKey(24)	<= SelectedKey(24) XOR round_Constant( 6);
		ProcessedKey(20)	<= SelectedKey(20) XOR round_Constant( 5);
		ProcessedKey(16)	<= SelectedKey(16) XOR round_Constant( 4);
		ProcessedKey(12)	<= SelectedKey(12) XOR round_Constant( 3);
		ProcessedKey( 8)	<= SelectedKey( 8) XOR round_Constant( 2);
		ProcessedKey( 4)	<= SelectedKey( 4) XOR round_Constant( 1);
		ProcessedKey( 0)	<= SelectedKey( 0) XOR round_Constant( 0);
		
		-----------------------------------------

		roundResult_Reg1: ScanFF
			GENERIC MAP ( SIZE => 64)
			PORT MAP (
				CLK	=> clk,
				SE		=> roundStart_Select,
				D		=> round_Result1,
				DS		=> input1,
				Q		=> roundReg_out1);

		roundResult_Reg2: ScanFF
			GENERIC MAP ( SIZE => 64)
			PORT MAP (
				CLK	=> clk,
				SE		=> roundStart_Select,
				D		=> round_Result2,
				DS		=> input2,
				Q		=> roundReg_out2);

		-----------------------------------------
		
		sub : ENTITY work.substitution
			PORT MAP ( state1 => roundReg_out1,
						  state2 => roundReg_out2,
						  clk		=> clk,
						  result1 => sub_Result1,
						  result2 => sub_Result2);
		
		-----------------------------------------
				
		SR1: ShiftRows
			PORT MAP ( state => sub_Result1,
						  result => SR_Result1);
		
		SR2: ShiftRows
			PORT MAP ( state => sub_Result2,
						  result => SR_Result2);
	
		
		-----------------------------------------

		sub_ResultXORkey1 <= sub_Result1;
		sub_ResultXORkey2 <= sub_Result2 xor ProcessedKey;
		
		-----------------------------------------

		mul_input1	<= SR_Result1 when enc_dec = '0' else sub_ResultXORkey1;
		mul_input2	<= SR_Result2 when enc_dec = '0' else sub_ResultXORkey2;

		-----------------------------------------

		mul1: matrixMultiplication
			PORT MAP ( state => mul_input1,
						  result => mul_Result1);
		
		mul2: matrixMultiplication
			PORT MAP ( state => mul_input2,
						  result => mul_Result2);

		
		-----------------------------------------

		SR_Inv1: ShiftRows_Inverse
			Port MAP ( state => mul_Result1,
						  result => SR_Inv_Result1);
						  
		SR_Inv2: ShiftRows_Inverse
			Port MAP ( state => mul_Result2,
						  result => SR_Inv_Result2);
						  

						  
		-----------------------------------------

		mul_ResultXORkey1	<= mul_Result1;
		mul_ResultXORkey2	<= mul_Result2 xor ProcessedKey;

		-----------------------------------------

		round_Result1	<= SR_Inv_Result1 when enc_dec = '1' else mul_ResultXORkey1;
		round_Result2	<= SR_Inv_Result2 when enc_dec = '1' else mul_ResultXORkey2;

		--------------------------------------------
					  
		result1 <= sub_Result1;
		result2 <= sub_Result2;

END behavioral;

