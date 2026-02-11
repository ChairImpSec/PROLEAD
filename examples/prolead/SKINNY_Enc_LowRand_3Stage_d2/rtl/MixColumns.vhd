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
ENTITY MixColumns is
	PORT ( X : IN	STD_LOGIC_VECTOR ((64 - 1) DOWNTO 0);
          Y : OUT	STD_LOGIC_VECTOR ((64 - 1) DOWNTO 0));
END MixColumns;



-- ARCHITECTURE : DATAFLOW
----------------------------------------------------------------------------------
ARCHITECTURE Parallel of MixColumns is

	-- CONSTANT -------------------------------------------------------------------
	CONSTANT W : INTEGER := 4;

	-- SIGNALS --------------------------------------------------------------------
	SIGNAL C1_X2X0, C2_X2X0, C3_X2X0, C4_X2X0	: STD_LOGIC_VECTOR((W - 1) DOWNTO 0);
	SIGNAL C1_X2X1, C2_X2X1, C3_X2X1, C4_X2X1	: STD_LOGIC_VECTOR((W - 1) DOWNTO 0);

BEGIN

	-- X2 XOR X1 ------------------------------------------------------------------
	C1_X2X1 <= X((12 * W - 1) DOWNTO (11 * W)) XOR X(( 8 * W - 1) DOWNTO ( 7 * W));
	C2_X2X1 <= X((11 * W - 1) DOWNTO (10 * W)) XOR X(( 7 * W - 1) DOWNTO ( 6 * W));
	C3_X2X1 <= X((10 * W - 1) DOWNTO ( 9 * W)) XOR X(( 6 * W - 1) DOWNTO ( 5 * W));
	C4_X2X1 <= X(( 9 * W - 1) DOWNTO ( 8 * W)) XOR X(( 5 * W - 1) DOWNTO ( 4 * W));
	-------------------------------------------------------------------------------

	-- X2 XOR X0 ------------------------------------------------------------------
	C1_X2X0 <= X((16 * W - 1) DOWNTO (15 * W)) XOR X(( 8 * W - 1) DOWNTO ( 7 * W));
	C2_X2X0 <= X((15 * W - 1) DOWNTO (14 * W)) XOR X(( 7 * W - 1) DOWNTO ( 6 * W));
	C3_X2X0 <= X((14 * W - 1) DOWNTO (13 * W)) XOR X(( 6 * W - 1) DOWNTO ( 5 * W));
	C4_X2X0 <= X((13 * W - 1) DOWNTO (12 * W)) XOR X(( 5 * W - 1) DOWNTO ( 4 * W));
	-------------------------------------------------------------------------------

	-- COLUMN 1 -------------------------------------------------------------------
	Y((16 * W - 1) DOWNTO (15 * W)) <= C1_X2X0 XOR X(( 4 * W - 1) DOWNTO ( 3 * W));
	Y((12 * W - 1) DOWNTO (11 * W)) <= X((16 * W - 1) DOWNTO (15 * W));
	Y(( 8 * W - 1) DOWNTO ( 7 * W)) <= C1_X2X1;
	Y(( 4 * W - 1) DOWNTO ( 3 * W)) <= C1_X2X0;
	-------------------------------------------------------------------------------

	-- COLUMN 2 -------------------------------------------------------------------
	Y((15 * W - 1) DOWNTO (14 * W)) <= C2_X2X0 XOR X(( 3 * W - 1) DOWNTO ( 2 * W));
	Y((11 * W - 1) DOWNTO (10 * W)) <= X((15 * W - 1) DOWNTO (14 * W));
	Y(( 7 * W - 1) DOWNTO ( 6 * W)) <= C2_X2X1;
	Y(( 3 * W - 1) DOWNTO ( 2 * W)) <= C2_X2X0;
	-------------------------------------------------------------------------------

	-- COLUMN 3 -------------------------------------------------------------------
	Y((14 * W - 1) DOWNTO (13 * W)) <= C3_X2X0 XOR X(( 2 * W - 1) DOWNTO ( 1 * W));
	Y((10 * W - 1) DOWNTO ( 9 * W)) <= X((14 * W - 1) DOWNTO (13 * W));
	Y(( 6 * W - 1) DOWNTO ( 5 * W)) <= C3_X2X1;
	Y(( 2 * W - 1) DOWNTO ( 1 * W)) <= C3_X2X0;
	-------------------------------------------------------------------------------

	-- COLUMN 4 -------------------------------------------------------------------
	Y((13 * W - 1) DOWNTO (12 * W)) <= C4_X2X0 XOR X(( 1 * W - 1) DOWNTO ( 0 * W));
	Y(( 9 * W - 1) DOWNTO ( 8 * W)) <= X((13 * W - 1) DOWNTO (12 * W));
	Y(( 5 * W - 1) DOWNTO ( 4 * W)) <= C4_X2X1;
	Y(( 1 * W - 1) DOWNTO ( 0 * W)) <= C4_X2X0;
	-------------------------------------------------------------------------------

END Parallel;
