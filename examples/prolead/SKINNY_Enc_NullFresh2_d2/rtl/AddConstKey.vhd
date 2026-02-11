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
ENTITY AddConstKey IS
	PORT ( -- CONST PORT -----------------------------------
			 CONST			: IN	STD_LOGIC_VECTOR(5 DOWNTO 0);
			 -- KEY PORT -------------------------------------
			 ROUND_KEY		: IN	STD_LOGIC_VECTOR((64 	- 1) DOWNTO 0);
			 -- DATA PORTS -----------------------------------
			 DATA_IN			: IN	STD_LOGIC_VECTOR((64 	- 1) DOWNTO 0);
			 DATA_OUT		: OUT STD_LOGIC_VECTOR((64	- 1) DOWNTO 0));
END AddConstKey;



-- ARCHITECTURE : MIXED
----------------------------------------------------------------------------------
ARCHITECTURE Parallel OF AddConstKey IS

	-- CONSTANTS ------------------------------------------------------------------
	CONSTANT N : INTEGER := 64;
	CONSTANT T : INTEGER := 64;
	CONSTANT W : INTEGER := 4;

	-- SIGNALS --------------------------------------------------------------------
	SIGNAL CONST_ADDITION	: STD_LOGIC_VECTOR((N - 1) DOWNTO 0);

BEGIN

	-- CONSTANT ADDITION ----------------------------------------------------------
	CONST_ADDITION(63 DOWNTO 60) <= DATA_IN(63 DOWNTO 60) XOR CONST(3 DOWNTO 0);
	CONST_ADDITION(59 DOWNTO 46) <= DATA_IN(59 DOWNTO 46);
	CONST_ADDITION(45 DOWNTO 44) <= DATA_IN(45 DOWNTO 44) XOR CONST(5 DOWNTO 4);
	CONST_ADDITION(43 DOWNTO 30) <= DATA_IN(43 DOWNTO 30);
	CONST_ADDITION(29) 	     	  <= NOT(DATA_IN(29));
	CONST_ADDITION(28 DOWNTO  0) <= DATA_IN(28 DOWNTO  0);

	-------------------------------------------------------------------------------

	-- ROUNDKEY ADDITION ----------------------------------------------------------
	DATA_OUT((16 * W - 1) DOWNTO (12 * W)) <= CONST_ADDITION((16 * W - 1) DOWNTO (12 * W)) XOR ROUND_KEY((16 * W - 1) DOWNTO (12 * W));
	DATA_OUT((12 * W - 1) DOWNTO ( 8 * W)) <= CONST_ADDITION((12 * W - 1) DOWNTO ( 8 * W)) XOR ROUND_KEY((12 * W - 1) DOWNTO ( 8 * W));

	DATA_OUT(( 8 * W - 1) DOWNTO ( 4 * W)) <= CONST_ADDITION(( 8 * W - 1) DOWNTO ( 4 * W));
	DATA_OUT(( 4 * W - 1) DOWNTO ( 0 * W)) <= CONST_ADDITION(( 4 * W - 1) DOWNTO ( 0 * W));
	-------------------------------------------------------------------------------

END Parallel;
