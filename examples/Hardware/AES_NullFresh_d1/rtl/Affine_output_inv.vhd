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


entity Affine_output_inv is
	 Generic (Const : STD_LOGIC);
    Port ( I : in  STD_LOGIC_VECTOR (7 downto 0);
           O : out  STD_LOGIC_VECTOR (7 downto 0));
end Affine_output_inv;

architecture Behavioral of Affine_output_inv is
	signal a,b,c,d,e,f,g,h : STD_LOGIC;
begin

	a <= I(0);
	b <= I(1);
	c <= I(2);
	d <= I(3);
	e <= I(4);
	f <= I(5);
	g <= I(6);
	h <= I(7);

	O(0) <= a XOR b XOR e XOR f XOR g;
	O(1) <= a XOR d XOR e XOR Const;
	O(2) <= c XOR f XOR h XOR Const;
	O(3) <= e XOR g XOR h XOR Const;
	O(4) <= a XOR b XOR d XOR g XOR Const;
	O(5) <= e XOR g XOR Const;
	O(6) <= a XOR b XOR e XOR g XOR Const;
	O(7) <= e XOR h;

end Behavioral;

