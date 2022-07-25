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

ENTITY MaskedSbox IS
	PORT (input1	:  IN  STD_LOGIC_VECTOR (4-1 DOWNTO 0);
			input2	:  IN  STD_LOGIC_VECTOR (4-1 DOWNTO 0);
			sel		:  IN  STD_LOGIC;
			clk		:  IN  STD_LOGIC;
			output1	: OUT STD_LOGIC_VECTOR (4-1 DOWNTO 0);
			output2	: OUT STD_LOGIC_VECTOR (4-1 DOWNTO 0));
END MaskedSbox;

ARCHITECTURE behavioral OF MaskedSbox IS

	
	signal a_in 							: STD_LOGIC_VECTOR (2 DOWNTO 1);
	signal b_in 							: STD_LOGIC_VECTOR (2 DOWNTO 1);
	signal c_in 							: STD_LOGIC_VECTOR (2 DOWNTO 1);
	signal d_in 							: STD_LOGIC_VECTOR (2 DOWNTO 1);
	
	signal e_s 								: STD_LOGIC_VECTOR (8 DOWNTO 1);
	signal f_s 								: STD_LOGIC_VECTOR (8 DOWNTO 1);
	signal g_s 								: STD_LOGIC_VECTOR (8 DOWNTO 1);
	signal h_s 								: STD_LOGIC_VECTOR (8 DOWNTO 1);
	
	signal e_si								: STD_LOGIC_VECTOR (8 DOWNTO 1);
	signal f_si								: STD_LOGIC_VECTOR (8 DOWNTO 1);
	signal g_si								: STD_LOGIC_VECTOR (8 DOWNTO 1);
	signal h_si								: STD_LOGIC_VECTOR (8 DOWNTO 1);
	
	signal e_reg 							: STD_LOGIC_VECTOR (8 DOWNTO 1);
	signal f_reg 							: STD_LOGIC_VECTOR (8 DOWNTO 1);
	signal g_reg 							: STD_LOGIC_VECTOR (8 DOWNTO 1);
	signal h_reg 							: STD_LOGIC_VECTOR (8 DOWNTO 1);
	
	signal a_out 							: STD_LOGIC_VECTOR (2 DOWNTO 1);
	signal b_out 							: STD_LOGIC_VECTOR (2 DOWNTO 1);
	signal c_out 							: STD_LOGIC_VECTOR (2 DOWNTO 1);
	signal d_out 							: STD_LOGIC_VECTOR (2 DOWNTO 1);
	
BEGIN

	a_in <= input2(0) & input1(0);
	b_in <= input2(1) & input1(1);
	c_in <= input2(2) & input1(2);
	d_in <= input2(3) & input1(3);
	
	--------------------------------------------------
	
	Inst_N: ENTITY work.N 
	PORT MAP(
		a 	=> a_in,
		b 	=> b_in,
		c 	=> c_in,
		d 	=> d_in,
		e_s	=> e_s,
		f_s	=> f_s,
		g_s	=> g_s,
		h_s	=> h_s,
		e_si	=> e_si,
		f_si	=> f_si,
		g_si	=> g_si,
		h_si	=> h_si	);
		
	--------------------------------------------------
	
	
	ScanFF_GEN: ENTITY work.ScanFF
	GENERIC MAP ( SIZE => 32)
	PORT MAP (
		CLK	=> clk,
		SE		=> sel,
		D(7  downto 0)			=> e_s,
		D(15 downto 8)			=> f_s,
		D(23 downto 16)		=> g_s,
		D(31 downto 24)		=> h_s,
		DS(7  downto 0)		=> e_si,
		DS(15 downto 8)		=> f_si,
		DS(23 downto 16)		=> g_si,
		DS(31 downto 24)		=> h_si,
		Q(7  downto 0)			=> e_reg,
		Q(15 downto 8)			=> f_reg,
		Q(23 downto 16)		=> g_reg,
		Q(31 downto 24)		=> h_reg);
			
			
--	reg_GEN: ENTITY work.reg
--	GENERIC map ( size => 32)
--	Port Map (
--		clk		=> clk,
--		D(7  downto 0)			=> e,
--		D(15 downto 8)			=> f,
--		D(23 downto 16)		=> g,
--		D(31 downto 24)		=> h,
--		Q(7  downto 0)			=> e_reg,
--		Q(15 downto 8)			=> f_reg,
--		Q(23 downto 16)		=> g_reg,
--		Q(31 downto 24)		=> h_reg );
		
	--------------------------------------------------
	
	Inst_L: ENTITY work.L
	PORT MAP(
		e	=> e_reg,
		f	=> f_reg,
		g	=> g_reg,
		h	=> h_reg,
		a 	=> a_out,
		b 	=> b_out,
		c 	=> c_out,
		d 	=> d_out );
		
	--------------------------------------------------
	
	output1 <= d_out(1) & c_out(1) & b_out(1) & a_out(1);
	output2 <= d_out(2) & c_out(2) & b_out(2) & a_out(2);
	
END behavioral;

