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

entity Gf6_sq_scl_mul_Canright_N is
    Port ( a : in  STD_LOGIC_VECTOR (2 downto 1);
           b : in  STD_LOGIC_VECTOR (2 downto 1);
           c : in  STD_LOGIC_VECTOR (2 downto 1);
           d : in  STD_LOGIC_VECTOR (2 downto 1);
           e : in  STD_LOGIC_VECTOR (2 downto 1);
           f : in  STD_LOGIC_VECTOR (2 downto 1);
           g : in  STD_LOGIC_VECTOR (2 downto 1);
           h : in  STD_LOGIC_VECTOR (2 downto 1);
           xu : out  STD_LOGIC_VECTOR (4 downto 1);
           yu : out  STD_LOGIC_VECTOR (4 downto 1);
           zu : out  STD_LOGIC_VECTOR (4 downto 1);
           tu : out  STD_LOGIC_VECTOR (4 downto 1);
		   xd : out  STD_LOGIC_VECTOR (4 downto 1);
           yd : out  STD_LOGIC_VECTOR (4 downto 1);
           zd : out  STD_LOGIC_VECTOR (4 downto 1);
           td : out  STD_LOGIC_VECTOR (4 downto 1));
end Gf6_sq_scl_mul_Canright_N;

architecture Behavioral of Gf6_sq_scl_mul_Canright_N is

begin

	F1: ENTITY work.Gf6_sq_scl_mul_Canright_bit
	GENERIC Map (1)
	Port Map(a(1), b(1), c(1), d(1), e(1), f(1), g(1), h(1), xu(1), yu(1), zu(1), tu(1), xd(1), yd(1), zd(1), td(1));
	
	F2: ENTITY work.Gf6_sq_scl_mul_Canright_bit
	GENERIC Map (2)
	Port Map(a(1), b(1), c(1), d(1), e(2), f(2), g(2), h(2), xu(2), yu(2), zu(2), tu(2), xd(3), yd(3), zd(3), td(3));
	
	F3: ENTITY work.Gf6_sq_scl_mul_Canright_bit
	GENERIC Map (3)
	Port Map(a(2), b(2), c(2), d(2), e(1), f(1), g(1), h(1), xu(3), yu(3), zu(3), tu(3), xd(2), yd(2), zd(2), td(2));
	
	F4: ENTITY work.Gf6_sq_scl_mul_Canright_bit
	GENERIC Map (4)
	Port Map(a(2), b(2), c(2), d(2), e(2), f(2), g(2), h(2), xu(4), yu(4), zu(4), tu(4), xd(4), yd(4), zd(4), td(4));
	
	
end Behavioral;

