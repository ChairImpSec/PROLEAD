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


ENTITY KeySchedule is
    GENERIC ( ShareNumber                     : integer );
    PORT ( clk : in  STD_LOGIC;
			  ShowRcon : in  STD_LOGIC;
			  KeyScheduleRegisterEN : in  STD_LOGIC;
           Rcon : in  STD_LOGIC_VECTOR (7 downto 0);
           S_key1 : in  STD_LOGIC_VECTOR (7 downto 0);
           S_key2 : in  STD_LOGIC_VECTOR (7 downto 0);
           K0 : in  STD_LOGIC_VECTOR (7 downto 0);
			  Key_forCipherText : out  STD_LOGIC_VECTOR (7 downto 0);
           Key_out : out  STD_LOGIC_VECTOR (7 downto 0));
END KeySchedule;

architecture Behavioral of KeySchedule is
	SIGNAL Affined_Inv_K0					 	: STD_LOGIC_VECTOR (7 downto 0);
	SIGNAL Reg_in					 				: STD_LOGIC_VECTOR (7 downto 0);
	SIGNAL Reg_out					 				: STD_LOGIC_VECTOR (7 downto 0);
	SIGNAL Key_out_tmp					 		: STD_LOGIC_VECTOR (7 downto 0);
	SIGNAL S_key2_reg					 			: STD_LOGIC_VECTOR (7 downto 0);
	SIGNAL Sbox_outputs_xor					 	: STD_LOGIC_VECTOR (7 downto 0);
begin


	
	Affine_OutInv1: ENTITY work.Affine_output_inv
	Generic Map (Const => '0')
	Port Map (
		I	=> K0,
		O	=> Affined_Inv_K0 );
			
	A1: ENTITY work.Affine_output
	Port Map(Sbox_outputs_xor, Key_out_tmp);
	
	Sbox_outputs_xor  <= Reg_out xor S_key2_reg;
	Key_out 				<= Key_out_tmp xor Rcon;
	Reg_in 				<= S_key1 xor Affined_Inv_K0;

	
	GEN_reg: ENTITY work.regE
	GENERIC map ( size => 8)
	Port Map (
		EN  => KeyScheduleRegisterEN,
		clk		=> clk,
		D			=> Reg_in,
		Q			=> Reg_out );
		
	GEN_reg2: ENTITY work.regE
	GENERIC map ( size => 8)
	Port Map (
		EN  => KeyScheduleRegisterEN,
		clk		=> clk,
		D			=> S_key2,
		Q			=> S_key2_reg );
		
		Key_forCipherText <= Sbox_outputs_xor;
end Behavioral;

