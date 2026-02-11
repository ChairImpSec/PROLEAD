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
ENTITY KeyExpansion IS
	PORT ( CLK			: IN  STD_LOGIC;
			 -- CONTROL PORTS --------------------------------
          RESET		: IN  STD_LOGIC;
			 ENABLE     : IN  STD_LOGIC;
		    -- KEY PORT -------------------------------------
			 KEY			: IN  STD_LOGIC_VECTOR ((64 - 1) DOWNTO 0);
			 ROUND_KEY	: OUT STD_LOGIC_VECTOR ((64 - 1) DOWNTO 0));
END KeyExpansion;



-- ARCHITECTURE : ROUND
----------------------------------------------------------------------------------
ARCHITECTURE Round OF KeyExpansion IS

	-- CONSTANTS ------------------------------------------------------------------
	CONSTANT W : INTEGER := 4;
	CONSTANT N : INTEGER := 64;
	CONSTANT T : INTEGER := 64;

	-- SIGNALS --------------------------------------------------------------------
	SIGNAL KEY_STATE, KEY_NEXT, KEY_PERM	: STD_LOGIC_VECTOR((T - 1) DOWNTO 0);

BEGIN

	-- REGISTER STAGE -------------------------------------------------------------
	RS : ENTITY work.ScanFF_en GENERIC MAP (SIZE => T) PORT MAP (CLK, RESET, ENABLE, KEY_NEXT, KEY, KEY_STATE);

	-- TWEAKEY ARRAY PERMUTATIONS : TK1 -------------------------------------------
	-- PERMUTATION -------------------------------------------------------------
	P1 : ENTITY work.Permutation  PORT MAP (KEY_STATE ((T - 0 * N - 1) DOWNTO (T - 1 * N)), KEY_PERM((T - 0 * N - 1) DOWNTO (T - 1 * N)));

	-- NO LFSR -----------------------------------------------------------------
	KEY_NEXT((T - 0 * N - 1) DOWNTO (T - 1 * N)) <= KEY_PERM((T - 0 * N - 1) DOWNTO (T - 1 * N));

	-- KEY OUTPUT -----------------------------------------------------------------
	ROUND_KEY <= KEY_STATE;

END Round;
