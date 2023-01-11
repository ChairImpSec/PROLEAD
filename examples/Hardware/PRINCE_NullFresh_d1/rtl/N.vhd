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
			 e_s : OUT STD_LOGIC_VECTOR (8 DOWNTO 1);
			 f_s : OUT STD_LOGIC_VECTOR (8 DOWNTO 1);
			 g_s : OUT STD_LOGIC_VECTOR (8 DOWNTO 1);
			 h_s : OUT STD_LOGIC_VECTOR (8 DOWNTO 1);
			 e_SI : OUT STD_LOGIC_VECTOR (8 DOWNTO 1);
			 f_SI : OUT STD_LOGIC_VECTOR (8 DOWNTO 1);
			 g_SI : OUT STD_LOGIC_VECTOR (8 DOWNTO 1);
			 h_SI : OUT STD_LOGIC_VECTOR (8 DOWNTO 1));
end N;

--- a and e are LSB
architecture Behavioral of N is
begin

	F1: ENTITY work.ComponentFunction_Merge4
	GENERIC Map (1, 9, 17, 25)
	Port Map(e_s(1), f_s(1), g_s(1), h_s(1), e_SI(1), f_SI(1), g_SI(1), h_SI(1), a(1), b(1), c(1), d(2));
	
	F2: ENTITY work.ComponentFunction_Merge4
	GENERIC Map (2, 10, 18, 26)
	Port Map(e_s(2), f_s(2), g_s(2), h_s(2), e_si(2), f_si(2), g_si(2), h_si(2), a(1), b(1), c(2), d(1));
	
	F3: ENTITY work.ComponentFunction_Merge4
	GENERIC Map (3, 11, 19, 27)
	Port Map(e_s(3), f_s(3), g_s(3), h_s(3), e_si(3), f_si(3), g_si(3), h_si(3), a(1), b(2), c(1), d(1));

	F4: ENTITY work.ComponentFunction_Merge4
	GENERIC Map (4, 12, 20, 28)
	Port Map(e_s(4), f_s(4), g_s(4), h_s(4), e_si(4), f_si(4), g_si(4), h_si(4), a(1), b(2), c(2), d(2));

	F5: ENTITY work.ComponentFunction_Merge4
	GENERIC Map (5, 13, 21, 29)
	Port Map(e_s(5), f_s(5), g_s(5), h_s(5), e_si(5), f_si(5), g_si(5), h_si(5), a(2), b(1), c(1), d(1));

	F6: ENTITY work.ComponentFunction_Merge4
	GENERIC Map (6, 14, 22, 30)
	Port Map(e_s(6), f_s(6), g_s(6), h_s(6), e_si(6), f_si(6), g_si(6), h_si(6), a(2), b(1), c(2), d(2));
	
	F7: ENTITY work.ComponentFunction_Merge4
	GENERIC Map (7, 15, 23, 31)
	Port Map(e_s(7), f_s(7), g_s(7), h_s(7), e_si(7), f_si(7), g_si(7), h_si(7), a(2), b(2), c(1), d(2));

	F8: ENTITY work.ComponentFunction_Merge4
	GENERIC Map (8, 16, 24, 32)
	Port Map(e_s(8), f_s(8), g_s(8), h_s(8), e_si(8), f_si(8), g_si(8), h_si(8), a(2), b(2), c(2), d(1));
	
	
	
	
end Behavioral;

