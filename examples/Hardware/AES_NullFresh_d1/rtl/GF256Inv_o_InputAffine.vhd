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

entity GF256Inv_o_InputAffine is
    Port ( clk : in  STD_LOGIC;
           input1 : in  STD_LOGIC_VECTOR (7 downto 0);
           input2 : in  STD_LOGIC_VECTOR (7 downto 0);
           output1 : out  STD_LOGIC_VECTOR (7 downto 0);
           output2 : out  STD_LOGIC_VECTOR (7 downto 0));
end GF256Inv_o_InputAffine;

architecture Behavioral of GF256Inv_o_InputAffine is

	signal inv_input1							: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal inv_input2							: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal inv_input1_reg					: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal inv_input2_reg					: STD_LOGIC_VECTOR (7 DOWNTO 0);
	
	signal inv_output1						: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal inv_output2						: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal inv_output1_reg					: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal inv_output2_reg					: STD_LOGIC_VECTOR (7 DOWNTO 0);

begin


	A1: ENTITY work.Affine_input
	Port Map(input1, inv_input1);
	
	A2: ENTITY work.Affine_input
	Port Map(input2, inv_input2);
  
   GEN_reg1: ENTITY work.reg
	GENERIC map ( size => 16)
	Port Map (
		clk						=> clk,
		D(7 downto 0)			=> inv_input1,
		D(15 downto 8)			=> inv_input2,
		Q(7 downto 0)			=> inv_input1_reg,
		Q(15 downto 8)			=> inv_input2_reg );
		
	Inst_GF256_INV: ENTITY work.GF256_INV 
	PORT MAP(
		clk => clk,
		dcba1 => inv_input1_reg(3 downto 0),
		dcba2 => inv_input2_reg(3 downto 0),
		hgfe1 => inv_input1_reg(7 downto 4),
		hgfe2 => inv_input2_reg(7 downto 4),
		dcba1_out => inv_output1(3 downto 0),
		dcba2_out => inv_output2(3 downto 0),
		hgfe1_out => inv_output1(7 downto 4),
		hgfe2_out => inv_output2(7 downto 4) );


	output1 <= inv_output1;
	output2 <= inv_output2;

end Behavioral;

