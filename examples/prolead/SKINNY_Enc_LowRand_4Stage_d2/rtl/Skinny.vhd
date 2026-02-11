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


-- IMPORTS
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

-- ENTITY
----------------------------------------------------------------------------------
ENTITY Skinny IS
   PORT ( CLK        : IN  STD_LOGIC;
   		 -- CONTROL PORTS --------------------------------
          RESET      : IN  STD_LOGIC;
			 Static_r 		: IN  STD_LOGIC_VECTOR (143 DOWNTO 0);
			 Dynamic_r 		: IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
          DONE       : OUT STD_LOGIC;
   	    -- KEY PORT -------------------------------------
          KEY1       : IN  STD_LOGIC_VECTOR ((64 - 1) DOWNTO 0);
          KEY2       : IN  STD_LOGIC_VECTOR ((64 - 1) DOWNTO 0);
          KEY3       : IN  STD_LOGIC_VECTOR ((64 - 1) DOWNTO 0);
   	    -- DATA PORTS -----------------------------------
          PLAINTEXT1 : IN  STD_LOGIC_VECTOR ((64 - 1) DOWNTO 0);
          PLAINTEXT2 : IN  STD_LOGIC_VECTOR ((64 - 1) DOWNTO 0);
          PLAINTEXT3 : IN  STD_LOGIC_VECTOR ((64 - 1) DOWNTO 0);
          CIPHERTEXT1: OUT STD_LOGIC_VECTOR ((64 - 1) DOWNTO 0);
          CIPHERTEXT2: OUT STD_LOGIC_VECTOR ((64 - 1) DOWNTO 0);
          CIPHERTEXT3: OUT STD_LOGIC_VECTOR ((64 - 1) DOWNTO 0));
END Skinny;


-- ARCHITECTURE : ROUND
----------------------------------------------------------------------------------
ARCHITECTURE Structural OF Skinny IS

		COMPONENT Sbox_State
	PORT(
		clk : IN std_logic;
		r : IN std_logic_vector(143 downto 0);
		state1 : IN std_logic_vector(63 downto 0);
		state2 : IN std_logic_vector(63 downto 0);
		state3 : IN std_logic_vector(63 downto 0);          
		result1 : OUT std_logic_vector(63 downto 0);
		result2 : OUT std_logic_vector(63 downto 0);
		result3 : OUT std_logic_vector(63 downto 0)
		);
	END COMPONENT;
	
	CONSTANT W : INTEGER := 4;

	-- SIGNALS --------------------------------------------------------------------
	SIGNAL SUB_IN1 : STD_LOGIC_VECTOR((64 - 1) DOWNTO 0);
	SIGNAL SUB_IN2 : STD_LOGIC_VECTOR((64 - 1) DOWNTO 0);
	SIGNAL SUB_IN3 : STD_LOGIC_VECTOR((64 - 1) DOWNTO 0);
	SIGNAL SUB_OUT1: STD_LOGIC_VECTOR((64 - 1) DOWNTO 0);
	SIGNAL SUB_OUT2: STD_LOGIC_VECTOR((64 - 1) DOWNTO 0);
	SIGNAL SUB_OUT3: STD_LOGIC_VECTOR((64 - 1) DOWNTO 0);

	SIGNAL ROUND_KEY1: STD_LOGIC_VECTOR((64 - 1) DOWNTO 0);
	SIGNAL ROUND_KEY2: STD_LOGIC_VECTOR((64 - 1) DOWNTO 0);
	SIGNAL ROUND_KEY3: STD_LOGIC_VECTOR((64 - 1) DOWNTO 0);
	SIGNAL Dynamic_r_XOR: STD_LOGIC_VECTOR(15 DOWNTO 0);

	SIGNAL ROUND_CST : STD_LOGIC_VECTOR(      5  DOWNTO 0);
	SIGNAL KEY_EN    : STD_LOGIC;
	
	SIGNAL r0_64, r1_64, r2_64	 	: STD_LOGIC_VECTOR (63 DOWNTO 0);
	SIGNAL r0, r1, r2, r3, r4, r5, r6 ,r7		: STD_LOGIC_VECTOR (3 DOWNTO 0);
	SIGNAL r01, r23, r45, r024, r135, r012345		: STD_LOGIC_VECTOR (3 DOWNTO 0);
	SIGNAL r6_4, r7_4     		: STD_LOGIC_VECTOR (15 DOWNTO 0);
	SIGNAL c1_fresh1, c1_fresh2, c1_fresh3     		: STD_LOGIC_VECTOR (15 DOWNTO 0);
	SIGNAL c2_fresh1, c2_fresh2, c2_fresh3     		: STD_LOGIC_VECTOR (15 DOWNTO 0);

BEGIN

	-- ROUND FUNCTION -------------------------------------------------------------
	Dynamic_r_XOR <= Dynamic_r(15 downto 0) xor Dynamic_r(31 downto 16);
	RF1 : ENTITY work.RoundFunction PORT MAP (CLK, RESET, ROUND_CST,       ROUND_KEY1, r0_64	, PLAINTEXT1, SUB_IN1, SUB_OUT1, CIPHERTEXT1);
	RF2 : ENTITY work.RoundFunction PORT MAP (CLK, RESET, (others => '0'), ROUND_KEY2, r1_64	, PLAINTEXT2, SUB_IN2, SUB_OUT2, CIPHERTEXT2);
	RF3 : ENTITY work.RoundFunction PORT MAP (CLK, RESET, (others => '0'), ROUND_KEY3, r2_64	, PLAINTEXT3, SUB_IN3, SUB_OUT3, CIPHERTEXT3);
	-------------------------------------------------------------------------------
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
		
		
		r0_64 <= c1_fresh1(3 downto 0) 	& c2_fresh1(3 downto 0) 	& c1_fresh1(3 downto 0) 	& c2_fresh1(3 downto 0)
				&c1_fresh1(7 downto 4) 	& c2_fresh1(7 downto 4) 	& c1_fresh1(7 downto 4) 	& c2_fresh1(7 downto 4)
				&c1_fresh1(11 downto 8) & c2_fresh1(11 downto 8) 	& c1_fresh1(11 downto 8) 	& c2_fresh1(11 downto 8)	
				&c1_fresh1(15 downto 12)& c2_fresh1(15 downto 12) 	& c1_fresh1(15 downto 12) 	& c2_fresh1(15 downto 12);
		
		r1_64 <= c1_fresh2(3 downto 0) 	& c2_fresh2(3 downto 0) 	& c1_fresh2(3 downto 0) 	& c2_fresh2(3 downto 0)
				&c1_fresh2(7 downto 4) 	& c2_fresh2(7 downto 4) 	& c1_fresh2(7 downto 4) 	& c2_fresh2(7 downto 4)
				&c1_fresh2(11 downto 8) & c2_fresh2(11 downto 8) 	& c1_fresh2(11 downto 8) 	& c2_fresh2(11 downto 8)	
				&c1_fresh2(15 downto 12)& c2_fresh2(15 downto 12) 	& c1_fresh2(15 downto 12) 	& c2_fresh2(15 downto 12);
		
		r2_64 <= c1_fresh3(3 downto 0) 	& c2_fresh3(3 downto 0) 	& c1_fresh3(3 downto 0) 	& c2_fresh3(3 downto 0)
				&c1_fresh3(7 downto 4) 	& c2_fresh3(7 downto 4) 	& c1_fresh3(7 downto 4) 	& c2_fresh3(7 downto 4)
				&c1_fresh3(11 downto 8) & c2_fresh3(11 downto 8) 	& c1_fresh3(11 downto 8) 	& c2_fresh3(11 downto 8)	
				&c1_fresh3(15 downto 12)& c2_fresh3(15 downto 12) 	& c1_fresh3(15 downto 12) 	& c2_fresh3(15 downto 12);
		
	-- SUBSTITUTION ---------------------------------------------------------------
	Inst_Sbox_State: Sbox_State PORT MAP(
		clk 	=> CLK,
		r		=> Static_r,
		state1 => SUB_IN1,
		state2 => SUB_IN2,
		state3 => SUB_IN3,
		result1 => SUB_OUT1,
		result2 => SUB_OUT2,
		result3 => SUB_OUT3
	);

   -- KEY EXPANSION --------------------------------------------------------------
   KE1 : ENTITY work.KeyExpansion PORT MAP (CLK, RESET, KEY_EN, KEY1, ROUND_KEY1);
   KE2 : ENTITY work.KeyExpansion PORT MAP (CLK, RESET, KEY_EN, KEY2, ROUND_KEY2);
   KE3 : ENTITY work.KeyExpansion PORT MAP (CLK, RESET, KEY_EN, KEY3, ROUND_KEY3);
	-------------------------------------------------------------------------------

   -- CONTROL LOGIC --------------------------------------------------------------
   CL : ENTITY work.ControlLogic PORT MAP (CLK, RESET, KEY_EN, DONE, ROUND_CST);
	-------------------------------------------------------------------------------

END Structural;
