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



entity GF16_inv_282 is
    Port ( clk : in  STD_LOGIC;
			  dcba1 : in  STD_LOGIC_VECTOR (3 downto 0);
           dcba2 : in  STD_LOGIC_VECTOR (3 downto 0);
           tzyx1 : out  STD_LOGIC_VECTOR (3 downto 0);
           tzyx2 : out  STD_LOGIC_VECTOR (3 downto 0));
end GF16_inv_282;

architecture Behavioral of GF16_inv_282 is

	signal a 								: STD_LOGIC_VECTOR (2 DOWNTO 1);
	signal b 								: STD_LOGIC_VECTOR (2 DOWNTO 1);
	signal c 								: STD_LOGIC_VECTOR (2 DOWNTO 1);
	signal d 								: STD_LOGIC_VECTOR (2 DOWNTO 1);
	
	signal x 								: STD_LOGIC_VECTOR (8 DOWNTO 1);
	signal y 								: STD_LOGIC_VECTOR (8 DOWNTO 1);
	signal z 								: STD_LOGIC_VECTOR (8 DOWNTO 1);
	signal t 								: STD_LOGIC_VECTOR (8 DOWNTO 1);
	
	signal x_reg 							: STD_LOGIC_VECTOR (8 DOWNTO 1);
	signal y_reg 							: STD_LOGIC_VECTOR (8 DOWNTO 1);
	signal z_reg 							: STD_LOGIC_VECTOR (8 DOWNTO 1);
	signal t_reg							: STD_LOGIC_VECTOR (8 DOWNTO 1);

begin

	a <= dcba2(0) & dcba1(0);
	b <= dcba2(1) & dcba1(1);
	c <= dcba2(2) & dcba1(2);
	d <= dcba2(3) & dcba1(3);
	

	
	Inst_Gf6_sq_scl_mul_Canright_N: Entity work.GF16_inv_282_N 
	PORT MAP(
		a => a,
		b => b,
		c => c,
		d => d,
		x => x,
		y => y,
		z => z,
		t => t );
		
	GEN_reg: ENTITY work.reg
	GENERIC map ( size => 32)
	Port Map (
		clk		=> clk,
		D(7  downto 0)			=> x,
		D(15 downto 8)			=> y,
		D(23 downto 16)		=> z,
		D(31 downto 24)		=> t,
		Q(7  downto 0)			=> x_reg,
		Q(15 downto 8)			=> y_reg,
		Q(23 downto 16)		=> z_reg,
		Q(31 downto 24)		=> t_reg );
		
	Inst_Gf6_sq_scl_mul_Canright_L: ENTITY work.GF16_inv_282_L 
	PORT MAP(
		x => x_reg,
		y => y_reg,
		z => z_reg,
		t => t_reg,
		tzyx1 => tzyx1,
		tzyx2 => tzyx2 );

end Behavioral;

