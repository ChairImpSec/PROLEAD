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

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity N is
    Port (
			 a : IN STD_LOGIC_VECTOR (2 DOWNTO 1);
			 b : IN STD_LOGIC_VECTOR (2 DOWNTO 1);
			 c : IN STD_LOGIC_VECTOR (2 DOWNTO 1);
			 d : IN STD_LOGIC_VECTOR (2 DOWNTO 1);
			 e : OUT STD_LOGIC_VECTOR (8 DOWNTO 1);
			 f : OUT STD_LOGIC_VECTOR (4 DOWNTO 1);
			 g : OUT STD_LOGIC_VECTOR (8 DOWNTO 1);
			 h : OUT STD_LOGIC_VECTOR (8 DOWNTO 1));
end N;

--- a and e are LSB
architecture Behavioral of N is
begin

	F1: ENTITY work.ComponentFunction_Merge4
	GENERIC Map (1, 13, 13, 21)
	Port Map(e(1), open, g(1), h(1) , a(1), b(1), c(2), d(1));
	
	F2: ENTITY work.ComponentFunction_Merge4
	GENERIC Map (2, 9, 14, 22)
	Port Map(e(2), f(1), g(2), h(2) , a(1), b(2), c(1), d(1));
	
	F3: ENTITY work.ComponentFunction_Merge4
	GENERIC Map (3, 15, 15, 23)
	Port Map(e(3), open, g(3), h(3) , a(2), b(1), c(1), d(1));

	F4: ENTITY work.ComponentFunction_Merge4
	GENERIC Map (4, 10, 16, 24)
	Port Map(e(4), f(2), g(4), h(4) , a(2), b(2), c(2), d(1));

	F5: ENTITY work.ComponentFunction_Merge4
	GENERIC Map (5, 17, 17, 25)
	Port Map(e(5), open, g(5), h(5) , a(1), b(1), c(1), d(2));

	F6: ENTITY work.ComponentFunction_Merge4
	GENERIC Map (6, 11, 18, 26)
	Port Map(e(6), f(3), g(6), h(6) , a(1), b(2), c(2), d(2));
	
	F7: ENTITY work.ComponentFunction_Merge4
	GENERIC Map (7, 19, 19, 27)
	Port Map(e(7), open, g(7), h(7) , a(2), b(1), c(2), d(2));

	F8: ENTITY work.ComponentFunction_Merge4
	GENERIC Map (8, 12, 20, 28)
	Port Map(e(8), f(4), g(8), h(8) , a(2), b(2), c(1), d(2));
	
	
	
	
end Behavioral;

