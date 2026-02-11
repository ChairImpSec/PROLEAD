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
ENTITY ShiftRows IS
	PORT ( X : IN	STD_LOGIC_VECTOR ((64 - 1) DOWNTO 0);
          Y : OUT	STD_LOGIC_VECTOR ((64 - 1) DOWNTO 0));
END ShiftRows;



-- ARCHITECTURE : PARALLEL
----------------------------------------------------------------------------------
ARCHITECTURE Parallel OF ShiftRows IS

	-- CONSTANT -------------------------------------------------------------------
	CONSTANT W : INTEGER := 4;

BEGIN

	-- ROW 1 ----------------------------------------------------------------------
	Y((16 * W - 1) DOWNTO (12 * W)) <= X((16 * W - 1) DOWNTO (12 * W));

	-- ROW 2 ----------------------------------------------------------------------
	Y((12 * W - 1) DOWNTO ( 8 * W)) <= X(( 9 * W - 1) DOWNTO ( 8 * W)) & X((12 * W - 1) DOWNTO ( 9 * W));

	-- ROW 3 ----------------------------------------------------------------------
	Y(( 8 * W - 1) DOWNTO ( 4 * W)) <= X(( 6 * W - 1) DOWNTO ( 4 * W)) & X(( 8 * W - 1) DOWNTO ( 6 * W));

	-- ROW 4 ----------------------------------------------------------------------
	Y(( 4 * W - 1) DOWNTO ( 0 * W)) <= X(( 3 * W - 1) DOWNTO ( 0 * W)) & X(( 4 * W - 1) DOWNTO ( 3 * W));

END Parallel;
