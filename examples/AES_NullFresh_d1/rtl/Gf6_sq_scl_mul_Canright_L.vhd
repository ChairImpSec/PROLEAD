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

entity Gf6_sq_scl_mul_Canright_L is
    Port ( x : in  STD_LOGIC_VECTOR (4 downto 1);
           y : in  STD_LOGIC_VECTOR (4 downto 1);
           z : in  STD_LOGIC_VECTOR (4 downto 1);
           t : in  STD_LOGIC_VECTOR (4 downto 1);
           tzyx1 : out  STD_LOGIC_VECTOR (3 downto 0);
           tzyx2 : out  STD_LOGIC_VECTOR (3 downto 0));
end Gf6_sq_scl_mul_Canright_L;

architecture Behavioral of Gf6_sq_scl_mul_Canright_L is

begin

	XORInst0: ENTITY work.XOR_2
	Port Map (
		in0	=> x(1),
		in1	=> x(2),
		q		=> tzyx1(0) );
		
	XORInst1: ENTITY work.XOR_2
	Port Map (
		in0	=> x(3),
		in1	=> x(4),
		q		=> tzyx2(0) );
		
	XORInst2: ENTITY work.XOR_2
	Port Map (
		in0	=> y(1),
		in1	=> y(2),
		q		=> tzyx1(1) );
		
	XORInst3: ENTITY work.XOR_2
	Port Map (
		in0	=> y(3),
		in1	=> y(4),
		q		=> tzyx2(1) );
	
	XORInst4: ENTITY work.XOR_2
	Port Map (
		in0	=> z(1),
		in1	=> z(2),
		q		=> tzyx1(2) );
		
	XORInst5: ENTITY work.XOR_2
	Port Map (
		in0	=> z(3),
		in1	=> z(4),
		q		=> tzyx2(2) );
		
	XORInst6: ENTITY work.XOR_2
	Port Map (
		in0	=> t(1),
		in1	=> t(2),
		q		=> tzyx1(3) );
		
	XORInst7: ENTITY work.XOR_2
	Port Map (
		in0	=> t(3),
		in1	=> t(4),
		q		=> tzyx2(3) );
	
end Behavioral;

