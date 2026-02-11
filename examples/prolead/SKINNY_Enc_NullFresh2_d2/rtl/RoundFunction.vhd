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

-- IMPORTS
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;


-- ENTITY
----------------------------------------------------------------------------------
ENTITY RoundFunction IS
   PORT ( CLK        : IN  STD_LOGIC;
   		 -- CONTROL PORTS --------------------------------
          RESET      : IN  STD_LOGIC;
   	    -- CONSTANT PORT --------------------------------
          ROUND_CST  : IN  STD_LOGIC_VECTOR (5 DOWNTO 0);
   	    -- KEY PORT -------------------------------------
          ROUND_KEY  : IN  STD_LOGIC_VECTOR ((64 - 1) DOWNTO 0);
   	    -- DATA PORTS -----------------------------------
          ROUND_IN   : IN  STD_LOGIC_VECTOR ((64 - 1) DOWNTO 0);
			 SUB_IN		: OUT STD_LOGIC_VECTOR ((64 - 1) DOWNTO 0);
			 SUB_OUT		: IN  STD_LOGIC_VECTOR ((64 - 1) DOWNTO 0);
          ROUND_OUT  : OUT STD_LOGIC_VECTOR ((64 - 1) DOWNTO 0));
END RoundFunction;



-- ARCHITECTURE : ROUND
----------------------------------------------------------------------------------
ARCHITECTURE Round OF RoundFunction IS

	-- CONSTANTS ------------------------------------------------------------------
	CONSTANT W : INTEGER := 4;
	CONSTANT N : INTEGER := 64;
	CONSTANT T : INTEGER := 64;

	-- SIGNALS --------------------------------------------------------------------
	SIGNAL STATE, STATE_NEXT, SUBSTITUTE, ADDITION, SHIFTROWS	: STD_LOGIC_VECTOR((N - 1) DOWNTO 0);

BEGIN

	-- REGISTER STAGE -------------------------------------------------------------
	RS : ENTITY work.ScanFF GENERIC MAP (SIZE => N) PORT MAP (CLK, RESET, STATE_NEXT, ROUND_IN, STATE);

	-- SUBSTITUTION ---------------------------------------------------------------
	SUB_IN 		<= STATE;
	SUBSTITUTE	<= SUB_OUT;

	-- CONSTANT AND KEY ADDITION --------------------------------------------------
	KA : ENTITY work.AddConstKey PORT MAP (ROUND_CST, ROUND_KEY, SUBSTITUTE, ADDITION);

	-- SHIFT ROWS -----------------------------------------------------------------
	SR : ENTITY work.ShiftRows PORT MAP (ADDITION, SHIFTROWS);

	-- MIX COLUMNS ----------------------------------------------------------------
	MC : ENTITY work.MixColumns PORT MAP (SHIFTROWS, STATE_NEXT);

	-- ROUND OUTPUT ---------------------------------------------------------------
	ROUND_OUT <= STATE_NEXT;

END Round;
