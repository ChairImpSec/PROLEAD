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


entity GF16_inv_282_N is
    Port ( a : in  STD_LOGIC_VECTOR (2 downto 1);
           b : in  STD_LOGIC_VECTOR (2 downto 1);
           c : in  STD_LOGIC_VECTOR (2 downto 1);
           d : in  STD_LOGIC_VECTOR (2 downto 1);
			  x : out  STD_LOGIC_VECTOR (8 downto 1);
           y : out  STD_LOGIC_VECTOR (8 downto 1);
           z : out  STD_LOGIC_VECTOR (8 downto 1);
           t : out  STD_LOGIC_VECTOR (8 downto 1));
end GF16_inv_282_N;

architecture Behavioral of GF16_inv_282_N is

begin

	F1: ENTITY work.GF16_inv_282_bit
	GENERIC Map (1)
	Port Map(a(1), b(1), c(1), d(1), x(1), open, open, open);
	
	F2: ENTITY work.GF16_inv_282_bit
	GENERIC Map (2)
	Port Map(a(2), b(1), c(1), d(2), x(2), open, open, open);
	
	F3: ENTITY work.GF16_inv_282_bit
	GENERIC Map (3)
	Port Map(a(1), b(1), c(2), d(1), x(3), y(3), z(3), t(3));
	
	F4: ENTITY work.GF16_inv_282_bit
	GENERIC Map (4)
	Port Map(a(2), b(1), c(2), d(2), x(4), y(4), z(4), t(4));
	
	F5: ENTITY work.GF16_inv_282_bit
	GENERIC Map (5)
	Port Map(a(2), b(2), c(1), d(1), x(5), open, open, open);
	
	F6: ENTITY work.GF16_inv_282_bit
	GENERIC Map (6)
	Port Map(a(1), b(2), c(1), d(1), x(6), y(5), z(5), t(5));
	
	F7: ENTITY work.GF16_inv_282_bit
	GENERIC Map (7)
	Port Map(a(2), b(2), c(2), d(1), x(7), y(7), z(7), t(7));
	
	F8: ENTITY work.GF16_inv_282_bit
	GENERIC Map (8)
	Port Map(a(1), b(2), c(2), d(2), x(8), y(8), z(8), t(8));

	F9: ENTITY work.GF16_inv_282_bit
	GENERIC Map (9)
	Port Map(a(2), b(1), c(1), d(1), open, y(1), z(1), t(1));
	
	F10: ENTITY work.GF16_inv_282_bit
	GENERIC Map (10)
	Port Map(a(1), b(1), c(1), d(2), open, y(2), z(2), t(2));
	
	F11: ENTITY work.GF16_inv_282_bit
	GENERIC Map (11)
	Port Map(a(2), b(2), c(1), d(2), open, y(6), z(6), t(6));
	
end Behavioral;

