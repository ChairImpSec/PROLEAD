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



LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;


ENTITY Midori64_Round IS


	PORT ( input1            : IN  STD_LOGIC_VECTOR (63 DOWNTO 0);
			 input2            : IN  STD_LOGIC_VECTOR (63 DOWNTO 0);
			 input3            : IN  STD_LOGIC_VECTOR (63 DOWNTO 0);
			 Static_r          : IN  STD_LOGIC_VECTOR (191 DOWNTO 0);
			 Dynamic_r         : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			 k_0_share1        : IN  STD_LOGIC_VECTOR (63 downto 0);
			 k_1_share1        : IN  STD_LOGIC_VECTOR (63 downto 0);
			 k_0_share2        : IN  STD_LOGIC_VECTOR (63 downto 0);
			 k_1_share2        : IN  STD_LOGIC_VECTOR (63 downto 0);
			 k_0_share3        : IN  STD_LOGIC_VECTOR (63 downto 0);
			 k_1_share3        : IN  STD_LOGIC_VECTOR (63 downto 0);
			 result1           : OUT  STD_LOGIC_VECTOR (63 downto 0);
			 result2           : OUT  STD_LOGIC_VECTOR (63 downto 0);
			 result3           : OUT  STD_LOGIC_VECTOR (63 downto 0);

			 -- CONTROLLER PORTS
			 EN	             : IN STD_LOGIC;
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
				 EN 	: IN 	STD_LOGIC;
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
	
	COMPONENT Sbox_State
	PORT(
		clk : IN std_logic;
		r : IN std_logic_vector(191 downto 0);
		state1 : IN std_logic_vector(63 downto 0);
		state2 : IN std_logic_vector(63 downto 0);
		state3 : IN std_logic_vector(63 downto 0);          
		result1 : OUT std_logic_vector(63 downto 0);
		result2 : OUT std_logic_vector(63 downto 0);
		result3 : OUT std_logic_vector(63 downto 0)
		);
	END COMPONENT;
	
	
	SIGNAL round_Constant     		: STD_LOGIC_VECTOR (15 DOWNTO 0);
	SIGNAL r0_64, r1_64, r2_64	 	: STD_LOGIC_VECTOR (63 DOWNTO 0);
	SIGNAL r0, r1, r2, r3, r4, r5, r6 ,r7		: STD_LOGIC_VECTOR (3 DOWNTO 0);
	SIGNAL r01, r23, r45, r024, r135, r012345		: STD_LOGIC_VECTOR (3 DOWNTO 0);
	SIGNAL r6_4, r7_4     		: STD_LOGIC_VECTOR (15 DOWNTO 0);
	SIGNAL c1_fresh1, c1_fresh2, c1_fresh3     		: STD_LOGIC_VECTOR (15 DOWNTO 0);
	SIGNAL c2_fresh1, c2_fresh2, c2_fresh3     		: STD_LOGIC_VECTOR (15 DOWNTO 0);

	SIGNAL SelectedKey1,
			SelectedKey2,
			SelectedKey3,
			 ProcessedKey1,
			 roundReg_out1,
			 roundReg_out2,
			 roundReg_out3,
			 sub_Result1,
			 sub_Result2,
			 sub_Result3,
			 SR_Result1,
			 SR_Result2,
			 SR_Result3,
			 sub_ResultXORkey1,
			 sub_ResultXORkey2,
			 sub_ResultXORkey3,
			 mul_input1,
			 mul_input2,
			 mul_input3,
			 mul_Result1,
			 mul_Result2,
			 mul_Result3,
			 SR_Inv_Result1,
			 SR_Inv_Result2,
			 SR_Inv_Result3,
			 mul_ResultXORkey1,
			 mul_ResultXORkey2,
			 mul_ResultXORkey3,
			 Refreshed_mul_Result1,
			 Refreshed_mul_Result2,
			 Refreshed_mul_Result3,
			 round_Result1,
			 round_Result2,
			 round_Result3 : STD_LOGIC_VECTOR (63 DOWNTO 0);
	
	BEGIN 
						  
		constant_MUX : roundConstant_MUX
			PORT MAP ( round => round_number,
						  enc_dec => enc_dec,
						  roundConstant => round_Constant);

		SelectedKey1	<= k_0_share1 when round_number(0) = '0' else k_1_share1;
		SelectedKey2	<= k_0_share2 when round_number(0) = '0' else k_1_share2;
		SelectedKey3	<= k_0_share3 when round_number(0) = '0' else k_1_share3;

		ProcessedKey1(63 downto 61) <= SelectedKey1(63 downto 61);
		ProcessedKey1(59 downto 57) <= SelectedKey1(59 downto 57);
		ProcessedKey1(55 downto 53) <= SelectedKey1(55 downto 53);
		ProcessedKey1(51 downto 49) <= SelectedKey1(51 downto 49);
		ProcessedKey1(47 downto 45) <= SelectedKey1(47 downto 45);
		ProcessedKey1(43 downto 41) <= SelectedKey1(43 downto 41);
		ProcessedKey1(39 downto 37) <= SelectedKey1(39 downto 37);
		ProcessedKey1(35 downto 33) <= SelectedKey1(35 downto 33);
		ProcessedKey1(31 downto 29) <= SelectedKey1(31 downto 29);
		ProcessedKey1(27 downto 25) <= SelectedKey1(27 downto 25);
		ProcessedKey1(23 downto 21) <= SelectedKey1(23 downto 21);
		ProcessedKey1(19 downto 17) <= SelectedKey1(19 downto 17);
		ProcessedKey1(15 downto 13) <= SelectedKey1(15 downto 13);
		ProcessedKey1(11 downto  9) <= SelectedKey1(11 downto  9);
		ProcessedKey1( 7 downto  5) <= SelectedKey1( 7 downto  5);
		ProcessedKey1( 3 downto  1) <= SelectedKey1( 3 downto  1);

		ProcessedKey1(60)	<= SelectedKey1(60) XOR round_Constant(15);
		ProcessedKey1(56)	<= SelectedKey1(56) XOR round_Constant(14);
		ProcessedKey1(52)	<= SelectedKey1(52) XOR round_Constant(13);
		ProcessedKey1(48)	<= SelectedKey1(48) XOR round_Constant(12);
		ProcessedKey1(44)	<= SelectedKey1(44) XOR round_Constant(11);
		ProcessedKey1(40)	<= SelectedKey1(40) XOR round_Constant(10);
		ProcessedKey1(36)	<= SelectedKey1(36) XOR round_Constant( 9);
		ProcessedKey1(32)	<= SelectedKey1(32) XOR round_Constant( 8);
		ProcessedKey1(28)	<= SelectedKey1(28) XOR round_Constant( 7);
		ProcessedKey1(24)	<= SelectedKey1(24) XOR round_Constant( 6);
		ProcessedKey1(20)	<= SelectedKey1(20) XOR round_Constant( 5);
		ProcessedKey1(16)	<= SelectedKey1(16) XOR round_Constant( 4);
		ProcessedKey1(12)	<= SelectedKey1(12) XOR round_Constant( 3);
		ProcessedKey1( 8)	<= SelectedKey1( 8) XOR round_Constant( 2);
		ProcessedKey1( 4)	<= SelectedKey1( 4) XOR round_Constant( 1);
		ProcessedKey1( 0)	<= SelectedKey1( 0) XOR round_Constant( 0);
		
		-----------------------------------------
		roundReg_out1	<= input1 when roundStart_Select = '1' else round_Result1;
		roundReg_out2	<= input2 when roundStart_Select = '1' else round_Result2;
		roundReg_out3	<= input3 when roundStart_Select = '1' else round_Result3;

		-----------------------------------------
		
		Inst_Sbox_State: Sbox_State PORT MAP(
			clk => clk,
			r => Static_r,
			state1 => roundReg_out1,
			state2 => roundReg_out2,
			state3 => roundReg_out3,
			result1 => sub_Result1,
			result2 => sub_Result2,
			result3 => sub_Result3
		);
	
		
		-----------------------------------------
				
		SR1: ShiftRows
			PORT MAP ( state => sub_Result1,
						  result => SR_Result1);
		
		SR2: ShiftRows
			PORT MAP ( state => sub_Result2,
						  result => SR_Result2);
		
		SR3: ShiftRows
			PORT MAP ( state => sub_Result3,
						  result => SR_Result3);
		
		-----------------------------------------

		sub_ResultXORkey1 <= sub_Result1 xor ProcessedKey1;
		sub_ResultXORkey2 <= sub_Result2 xor SelectedKey2;
		sub_ResultXORkey3 <= sub_Result3 xor SelectedKey3;
		
		-----------------------------------------

		mul_input1	<= SR_Result1 when enc_dec = '0' else sub_ResultXORkey1;
		mul_input2	<= SR_Result2 when enc_dec = '0' else sub_ResultXORkey2;
		mul_input3	<= SR_Result3 when enc_dec = '0' else sub_ResultXORkey3;

		-----------------------------------------

		mul1: matrixMultiplication
			PORT MAP ( state => mul_input1,
						  result => mul_Result1);
		
		mul2: matrixMultiplication
			PORT MAP ( state => mul_input2,
						  result => mul_Result2);
		
		mul3: matrixMultiplication
			PORT MAP ( state => mul_input3,
						  result => mul_Result3);
		
		-----------------------------------------
		--- Refreshing

		
		r0 <= Dynamic_r(3 downto 0);
		r1 <= Dynamic_r(7 downto 4);
		r2 <= Dynamic_r(11 downto 8);
		r3 <= Dynamic_r(15 downto 12);
		r4 <= Dynamic_r(19 downto 16);
		r5 <= Dynamic_r(23 downto 20);
		r6 <= Dynamic_r(27 downto 24);
		r7 <= Dynamic_r(31 downto 28);
		
		
		
		r6_4 <= r6 & r6 & r6 & r6;
		r7_4 <= r7 & r7 & r7 & r7;
		
		r01 <= r0 xor r1;
		r23 <= r2 xor r3;
		r45 <= r4 xor r5;

		r024 <= r0 xor r2 xor r4;
		r135 <= r1 xor r3 xor r5;
		r012345 <= r024 xor r135;
		
		c1_fresh1 <= r0 & r2 & r4 & r024;
		c1_fresh2 <= r1 & r3 & r5 & r135;
		c1_fresh3 <= r01 & r23 & r45 & r012345;
		
		c2_fresh1 <= c1_fresh1 xor r6_4;
		c2_fresh2 <= c1_fresh2 xor r7_4;
		c2_fresh3 <= c1_fresh3 xor r6_4 xor r7_4;
		
		
		r0_64 <= c1_fresh1 & c2_fresh1 & c1_fresh1 & c2_fresh1  ;
		r1_64 <= c1_fresh2 & c2_fresh2 & c1_fresh2 & c2_fresh2  ;
		r2_64 <= c1_fresh3 & c2_fresh3 & c1_fresh3 & c2_fresh3  ;
		
		
		Refreshed_mul_Result1 <= mul_Result1 xor r0_64;
		Refreshed_mul_Result2 <= mul_Result2 xor r1_64;
		Refreshed_mul_Result3 <= mul_Result3 xor r2_64;
	
	-----------------------------------------
	
	

		SR_Inv1: ShiftRows_Inverse
			Port MAP ( state => Refreshed_mul_Result1,
						  result => SR_Inv_Result1);
						  
		SR_Inv2: ShiftRows_Inverse
			Port MAP ( state => Refreshed_mul_Result2,
						  result => SR_Inv_Result2);
						  
		SR_Inv3: ShiftRows_Inverse
			Port MAP ( state => Refreshed_mul_Result3,
						  result => SR_Inv_Result3);
						  
		-----------------------------------------

		mul_ResultXORkey1	<= mul_Result1 xor ProcessedKey1;
		mul_ResultXORkey2	<= mul_Result2 xor SelectedKey2;
		mul_ResultXORkey3	<= mul_Result3 xor SelectedKey3;

		-----------------------------------------

		round_Result1	<= SR_Inv_Result1 when enc_dec = '1' else mul_ResultXORkey1;
		round_Result2	<= SR_Inv_Result2 when enc_dec = '1' else mul_ResultXORkey2;
		round_Result3	<= SR_Inv_Result3 when enc_dec = '1' else mul_ResultXORkey3;

		--------------------------------------------
					  
		result1 <= sub_Result1;
		result2 <= sub_Result2;
		result3 <= sub_Result3;

END behavioral;

