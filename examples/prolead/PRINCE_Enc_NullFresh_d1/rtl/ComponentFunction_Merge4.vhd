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
use work.functions.all;

entity ComponentFunction_Merge4 is
	Generic ( 
		Number1 		: integer;
		Number2 		: integer;
		Number3   	: integer;
		Number4 		: integer);
		
    Port ( Q_Sbox_N1 	: out  STD_LOGIC;
			  Q_Sbox_N2 	: out  STD_LOGIC;
			  Q_Sbox_N3 	: out  STD_LOGIC;
			  Q_Sbox_N4 	: out  STD_LOGIC;
			  Q_SboxInverse_N1 	: out  STD_LOGIC;
			  Q_SboxInverse_N2 	: out  STD_LOGIC;
			  Q_SboxInverse_N3 	: out  STD_LOGIC;
			  Q_SboxInverse_N4 	: out  STD_LOGIC;
           a 		: in  STD_LOGIC;
           b 		: in  STD_LOGIC;
           c 		: in  STD_LOGIC;
           d 		: in  STD_LOGIC);
end ComponentFunction_Merge4;

architecture Behavioral of ComponentFunction_Merge4 is

	constant SboxTable_N1    					: STD_LOGIC_VECTOR (15 DOWNTO 0) := LookUp_Gen(Number1);
	constant SboxTable_N2    					: STD_LOGIC_VECTOR (15 DOWNTO 0) := LookUp_Gen(Number2);
	constant SboxTable_N3    					: STD_LOGIC_VECTOR (15 DOWNTO 0) := LookUp_Gen(Number3);
	constant SboxTable_N4    					: STD_LOGIC_VECTOR (15 DOWNTO 0) := LookUp_Gen(Number4);
	
	constant SboxTableInv_N1    				: STD_LOGIC_VECTOR (15 DOWNTO 0) := LookUp_Inv_Gen(Number1);
	constant SboxTableInv_N2    				: STD_LOGIC_VECTOR (15 DOWNTO 0) := LookUp_Inv_Gen(Number2);
	constant SboxTableInv_N3    				: STD_LOGIC_VECTOR (15 DOWNTO 0) := LookUp_Inv_Gen(Number3);
	constant SboxTableInv_N4    				: STD_LOGIC_VECTOR (15 DOWNTO 0) := LookUp_Inv_Gen(Number4);

	signal input									: STD_LOGIC_VECTOR(3 downto 0);
begin

	input <= d & c & b & a;

	tableprocess: Process (input)
	begin
		Q_Sbox_N1  			<= SboxTable_N1(to_integer(unsigned(input)));
		Q_Sbox_N2  			<= SboxTable_N2(to_integer(unsigned(input)));
		Q_Sbox_N3 			<= SboxTable_N3(to_integer(unsigned(input)));
		Q_Sbox_N4 			<= SboxTable_N4(to_integer(unsigned(input)));

		Q_SboxInverse_N1  <= SboxTableInv_N1(to_integer(unsigned(input)));
		Q_SboxInverse_N2  <= SboxTableInv_N2(to_integer(unsigned(input)));
		Q_SboxInverse_N3 <= SboxTableInv_N3(to_integer(unsigned(input)));
		Q_SboxInverse_N4 <= SboxTableInv_N4(to_integer(unsigned(input)));
	end process;


end Behavioral;

