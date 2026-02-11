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

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


ENTITY matrixMultiplication IS
	PORT ( state : IN  STD_LOGIC_VECTOR (63 DOWNTO 0);
			 result : OUT  STD_LOGIC_VECTOR (63 DOWNTO 0));
END matrixMultiplication;

ARCHITECTURE behavioral OF matrixMultiplication IS	
	BEGIN

	MC1: entity work.MC
	PORT MAP ( state(63 downto 48),
				  result(63 downto 48));

	MC2: entity work.MC
	PORT MAP ( state(47 downto 32),
				  result(47 downto 32));

	MC3: entity work.MC
	PORT MAP ( state(31 downto 16),
				  result(31 downto 16));

	MC4: entity work.MC
	PORT MAP ( state(15 downto 0),
				  result(15 downto 0));


END behavioral;

