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
ENTITY Permutation is
	PORT ( X : IN  STD_LOGIC_VECTOR ((64 - 1) DOWNTO 0);
          Y : OUT STD_LOGIC_VECTOR ((64 - 1) DOWNTO 0));
END Permutation;



-- ARCHITECTURE : PARALLEL
----------------------------------------------------------------------------------
ARCHITECTURE Parallel OF Permutation IS

	-- CONSTANTS ------------------------------------------------------------------
	CONSTANT W : INTEGER := 4;

BEGIN

	-- ROW 1 ----------------------------------------------------------------------
	Y((16 * W - 1) DOWNTO (15 * W)) <= X(( 7 * W - 1) DOWNTO ( 6 * W));
	Y((15 * W - 1) DOWNTO (14 * W)) <= X(( 1 * W - 1) DOWNTO ( 0 * W));
	Y((14 * W - 1) DOWNTO (13 * W)) <= X(( 8 * W - 1) DOWNTO ( 7 * W));
	Y((13 * W - 1) DOWNTO (12 * W)) <= X(( 3 * W - 1) DOWNTO ( 2 * W));

	-- ROW 2 ----------------------------------------------------------------------
	Y((12 * W - 1) DOWNTO (11 * W)) <= X(( 6 * W - 1) DOWNTO ( 5 * W));
	Y((11 * W - 1) DOWNTO (10 * W)) <= X(( 2 * W - 1) DOWNTO ( 1 * W));
	Y((10 * W - 1) DOWNTO ( 9 * W)) <= X(( 4 * W - 1) DOWNTO ( 3 * W));
	Y(( 9 * W - 1) DOWNTO ( 8 * W)) <= X(( 5 * W - 1) DOWNTO ( 4 * W));

	-- ROW 3 ----------------------------------------------------------------------
	Y(( 8 * W - 1) DOWNTO ( 7 * W)) <= X((16 * W - 1) DOWNTO (15 * W));
	Y(( 7 * W - 1) DOWNTO ( 6 * W)) <= X((15 * W - 1) DOWNTO (14 * W));
	Y(( 6 * W - 1) DOWNTO ( 5 * W)) <= X((14 * W - 1) DOWNTO (13 * W));
	Y(( 5 * W - 1) DOWNTO ( 4 * W)) <= X((13 * W - 1) DOWNTO (12 * W));

	-- ROW 4 ----------------------------------------------------------------------
	Y(( 4 * W - 1) DOWNTO ( 3 * W)) <= X((12 * W - 1) DOWNTO (11 * W));
	Y(( 3 * W - 1) DOWNTO ( 2 * W)) <= X((11 * W - 1) DOWNTO (10 * W));
	Y(( 2 * W - 1) DOWNTO ( 1 * W)) <= X((10 * W - 1) DOWNTO ( 9 * W));
	Y(( 1 * W - 1) DOWNTO ( 0 * W)) <= X(( 9 * W - 1) DOWNTO ( 8 * W));

END Parallel;
