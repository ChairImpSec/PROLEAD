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

entity Gf6_sq_scl_mul_Canright is
    Port ( clk : in  STD_LOGIC;
			  dcba1 : in  STD_LOGIC_VECTOR (3 downto 0);
           dcba2 : in  STD_LOGIC_VECTOR (3 downto 0);
           hgfe1 : in  STD_LOGIC_VECTOR (3 downto 0);
           hgfe2 : in  STD_LOGIC_VECTOR (3 downto 0);
           tzyx1u : out  STD_LOGIC_VECTOR (3 downto 0);
           tzyx2u : out  STD_LOGIC_VECTOR (3 downto 0);
		     tzyx1d : out  STD_LOGIC_VECTOR (3 downto 0);
           tzyx2d : out  STD_LOGIC_VECTOR (3 downto 0));
end Gf6_sq_scl_mul_Canright;

architecture Behavioral of Gf6_sq_scl_mul_Canright is

	signal a 								: STD_LOGIC_VECTOR (2 DOWNTO 1);
	signal b 								: STD_LOGIC_VECTOR (2 DOWNTO 1);
	signal c 								: STD_LOGIC_VECTOR (2 DOWNTO 1);
	signal d 								: STD_LOGIC_VECTOR (2 DOWNTO 1);
	signal e 								: STD_LOGIC_VECTOR (2 DOWNTO 1);
	signal f 								: STD_LOGIC_VECTOR (2 DOWNTO 1);
	signal g 								: STD_LOGIC_VECTOR (2 DOWNTO 1);
	signal h 								: STD_LOGIC_VECTOR (2 DOWNTO 1);
	
	signal xu 								: STD_LOGIC_VECTOR (4 DOWNTO 1);
	signal yu 								: STD_LOGIC_VECTOR (4 DOWNTO 1);
	signal zu 								: STD_LOGIC_VECTOR (4 DOWNTO 1);
	signal tu 								: STD_LOGIC_VECTOR (4 DOWNTO 1);
	
	signal xd 								: STD_LOGIC_VECTOR (4 DOWNTO 1);
	signal yd 								: STD_LOGIC_VECTOR (4 DOWNTO 1);
	signal zd 								: STD_LOGIC_VECTOR (4 DOWNTO 1);
	signal td								: STD_LOGIC_VECTOR (4 DOWNTO 1);
	
	signal xu_reg 							: STD_LOGIC_VECTOR (4 DOWNTO 1);
	signal yu_reg 							: STD_LOGIC_VECTOR (4 DOWNTO 1);
	signal zu_reg 							: STD_LOGIC_VECTOR (4 DOWNTO 1);
	signal tu_reg							: STD_LOGIC_VECTOR (4 DOWNTO 1);
	
	signal xd_reg 							: STD_LOGIC_VECTOR (4 DOWNTO 1);
	signal yd_reg 							: STD_LOGIC_VECTOR (4 DOWNTO 1);
	signal zd_reg 							: STD_LOGIC_VECTOR (4 DOWNTO 1);
	signal td_reg							: STD_LOGIC_VECTOR (4 DOWNTO 1);
	
begin

	a <= dcba2(0) & dcba1(0);
	b <= dcba2(1) & dcba1(1);
	c <= dcba2(2) & dcba1(2);
	d <= dcba2(3) & dcba1(3);
	e <= hgfe2(0) & hgfe1(0);
	f <= hgfe2(1) & hgfe1(1);
	g <= hgfe2(2) & hgfe1(2);
	h <= hgfe2(3) & hgfe1(3);
	
	Inst_Gf6_sq_scl_mul_Canright_N: Entity work.Gf6_sq_scl_mul_Canright_N 
	PORT MAP(
		a => a,
		b => b,
		c => c,
		d => d,
		e => e,
		f => f,
		g => g,
		h => h,
		xu => xu,
		yu => yu,
		zu => zu,
		tu => tu,
		xd => xd,
		yd => yd,
		zd => zd,
		td => td		);
		
	GEN_reg: ENTITY work.reg
	GENERIC map ( size => 16)
	Port Map (
		clk		=> clk,
		D(3  downto 0)			=> xu,
		D(7 downto 4)			=> yu,
		D(11 downto 8)			=> zu,
		D(15 downto 12)		=> tu,
		Q(3  downto 0)			=> xu_reg,
		Q(7 downto 4)			=> yu_reg,
		Q(11 downto 8)			=> zu_reg,
		Q(15 downto 12)		=> tu_reg );
		
	GEN_reg01: ENTITY work.reg
	GENERIC map ( size => 16)
	Port Map (
		clk		=> clk,
		D(3  downto 0)			=> xd,
		D(7 downto 4)			=> yd,
		D(11 downto 8)			=> zd,
		D(15 downto 12)		=> td,
		Q(3  downto 0)			=> xd_reg,
		Q(7 downto 4)			=> yd_reg,
		Q(11 downto 8)			=> zd_reg,
		Q(15 downto 12)		=> td_reg );
		
		
	Inst_Gf6_sq_scl_mul_Canright_L1: ENTITY work.Gf6_sq_scl_mul_Canright_L 
	PORT MAP(
		x => xu_reg,
		y => yu_reg,
		z => zu_reg,
		t => tu_reg,
		tzyx1 => tzyx1u,
		tzyx2 => tzyx2u );
		
	Inst_Gf6_sq_scl_mul_Canright_L2: ENTITY work.Gf6_sq_scl_mul_Canright_L 
	PORT MAP(
		x => xd_reg,
		y => yd_reg,
		z => zd_reg,
		t => td_reg,
		tzyx1 => tzyx1d,
		tzyx2 => tzyx2d );

end Behavioral;

