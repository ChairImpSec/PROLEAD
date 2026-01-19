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


entity Gf16_mul2_Canright is
    Port ( clk : in  STD_LOGIC;
			  dcba1 : in  STD_LOGIC_VECTOR (3 downto 0);
           dcba2 : in  STD_LOGIC_VECTOR (3 downto 0);
           hgfe1 : in  STD_LOGIC_VECTOR (3 downto 0);
           hgfe2 : in  STD_LOGIC_VECTOR (3 downto 0);
           tzyx1 : out  STD_LOGIC_VECTOR (3 downto 0);
           tzyx2 : out  STD_LOGIC_VECTOR (3 downto 0));
end Gf16_mul2_Canright;

architecture Behavioral of Gf16_mul2_Canright is

	signal a 								: STD_LOGIC_VECTOR (2 DOWNTO 1);
	signal b 								: STD_LOGIC_VECTOR (2 DOWNTO 1);
	signal c 								: STD_LOGIC_VECTOR (2 DOWNTO 1);
	signal d 								: STD_LOGIC_VECTOR (2 DOWNTO 1);
	signal e 								: STD_LOGIC_VECTOR (2 DOWNTO 1);
	signal f 								: STD_LOGIC_VECTOR (2 DOWNTO 1);
	signal g 								: STD_LOGIC_VECTOR (2 DOWNTO 1);
	signal h 								: STD_LOGIC_VECTOR (2 DOWNTO 1);
	
	signal x 								: STD_LOGIC_VECTOR (4 DOWNTO 1);
	signal y 								: STD_LOGIC_VECTOR (4 DOWNTO 1);
	signal z 								: STD_LOGIC_VECTOR (4 DOWNTO 1);
	signal t 								: STD_LOGIC_VECTOR (4 DOWNTO 1);
	
	signal x_reg 							: STD_LOGIC_VECTOR (4 DOWNTO 1);
	signal y_reg 							: STD_LOGIC_VECTOR (4 DOWNTO 1);
	signal z_reg 							: STD_LOGIC_VECTOR (4 DOWNTO 1);
	signal t_reg							: STD_LOGIC_VECTOR (4 DOWNTO 1);


begin

	a <= dcba2(0) & dcba1(0);
	b <= dcba2(1) & dcba1(1);
	c <= dcba2(2) & dcba1(2);
	d <= dcba2(3) & dcba1(3);
	e <= hgfe2(0) & hgfe1(0);
	f <= hgfe2(1) & hgfe1(1);
	g <= hgfe2(2) & hgfe1(2);
	h <= hgfe2(3) & hgfe1(3);
	
	
	Inst_Gf6_sq_scl_mul_Canright_N: Entity work.Gf16_mul2_Canright_N 
	PORT MAP(
		a => a,
		b => b,
		c => c,
		d => d,
		e => e,
		f => f,
		g => g,
		h => h,
		x => x,
		y => y,
		z => z,
		t => t );
		
	GEN_reg: ENTITY work.reg
	GENERIC map ( size => 16)
	Port Map (
		clk		=> clk,
		D(3  downto 0)			=> x,
		D(7 downto 4)			=> y,
		D(11 downto 8)			=> z,
		D(15 downto 12)		=> t,
		Q(3  downto 0)			=> x_reg,
		Q(7 downto 4)			=> y_reg,
		Q(11 downto 8)			=> z_reg,
		Q(15 downto 12)		=> t_reg );
		
	Inst_Gf6_sq_scl_mul_Canright_L: ENTITY work.Gf6_sq_scl_mul_Canright_L 
	PORT MAP(
		x => x_reg,
		y => y_reg,
		z => z_reg,
		t => t_reg,
		tzyx1 => tzyx1,
		tzyx2 => tzyx2 );
	
	

end Behavioral;

