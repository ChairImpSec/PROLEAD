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

package functions is

function LookUp_Gen	(Number	 : NATURAL; const : STD_LOGIC := '0')
		return STD_LOGIC_VECTOR;
		
function LookUp_Inv_Gen	(Number	 : NATURAL; const : STD_LOGIC := '0')
		return STD_LOGIC_VECTOR;

		
end Functions;

package body Functions is	

	function LookUp_Gen	(Number	 : NATURAL;
								 const : STD_LOGIC := '0')
		return STD_LOGIC_VECTOR is
		variable ResTable	: STD_LOGIC_VECTOR (15 DOWNTO 0);
		variable Input		: STD_LOGIC_VECTOR(3 downto 0);
		variable a	: STD_LOGIC;
		variable b	: STD_LOGIC;
		variable c	: STD_LOGIC;
		variable d	: STD_LOGIC;
		variable Index   : NATURAL;
	begin
		
		
		for i in 0 to 15 loop
			input := std_logic_vector(to_unsigned(i,4));
			a := Input(0);
			b := Input(1);
			c := Input(2);
			d := Input(3);
			if (Number = 1) then
					ResTable(i) := ('1' ) xor ( b ) xor ( d ) xor ( a and b ) xor ( b and c ) xor ( a and d) xor ( a and b and c);
			end if;
			if (Number = 9) then
					ResTable(i) := ('1' ) xor ( b and c ) xor ( a and b and c ) xor ( b and c and d);
			end if;
			if (Number = 17) then
					ResTable(i) := (a and d ) xor ( c and d ) xor ( a and b and d ) xor ( b and c and d);
			end if;
			if (Number = 25) then
					ResTable(i) := ('1' ) xor ( a and b ) xor ( a and d ) xor ( a and b and c ) xor ( a and b and d ) xor ( a and c and d);
			end if;
			
			if (Number = 2) then
					ResTable(i) := (a and c ) xor ( a and b and c);
			end if;
			if (Number = 3) then
					ResTable(i) := (d ) xor ( b and c ) xor ( a and d ) xor ( a and b and c);
			end if;
			if (Number = 4) then
					ResTable(i) := (c ) xor ( a and b ) xor ( a and c ) xor ( a and b and c);
			end if;
			if (Number = 5) then
					ResTable(i) := (c ) xor ( c and d ) xor ( a and b and c);
			end if;
			if (Number = 6) then
					ResTable(i) := (b ) xor ( d ) xor ( a and b ) xor ( b and c ) xor ( a and d ) xor ( c and d ) xor ( a and b and c);
			end if;
			if (Number = 7) then
					ResTable(i) := (d ) xor ( a and b ) xor ( c and d ) xor ( a and b and c);
			end if;
			if (Number = 8) then
					ResTable(i) := (b and c ) xor ( a and d ) xor ( c and d ) xor ( a and b and c);
			end if;
			if (Number = 10) then
					ResTable(i) := (c ) xor ( a and c ) xor ( b and c ) xor ( c and d ) xor ( a and b and c ) xor ( b and c and d);
			end if;
			
			if (Number = 11) then
					ResTable(i) := (d ) xor ( a and b ) xor ( a and c ) xor ( b and d ) xor ( c and d ) xor ( a and b and c ) xor ( b and c and d);
			end if;
			if (Number = 12) then
					ResTable(i) :=  (a and b ) xor ( b and d ) xor ( a and b and c ) xor ( b and c and d);
			end if;
			if (Number = 13) then
					ResTable(i) := (d ) xor ( a and b ) xor ( a and c ) xor ( b and d ) xor ( c and d ) xor ( a and b and c ) xor ( b and c and d);
			end if;
			if (Number = 14) then
					ResTable(i) := (a and b ) xor ( b and d ) xor ( a and b and c ) xor ( b and c and d);
			end if;
			if (Number = 15) then
					ResTable(i) := (b and c ) xor ( a and b and c ) xor ( b and c and d);
			end if;
			if (Number = 16) then
					ResTable(i) := (c ) xor ( a and c ) xor ( b and c ) xor ( c and d ) xor ( a and b and c ) xor ( b and c and d);
			end if;
			if (Number = 18) then
					ResTable(i) := (a ) xor ( a and b ) xor ( b and c ) xor ( b and d ) xor ( a and b and d ) xor ( b and c and d);
			end if;
			if (Number = 19) then
					ResTable(i) := (d ) xor ( a and d ) xor ( b and d ) xor ( c and d ) xor ( a and b and d ) xor ( b and c and d);
			end if;
			
			if (Number = 20) then
					ResTable(i) := (a and b ) xor ( b and c ) xor ( a and b and d ) xor ( b and c and d);
			end if;
			if (Number = 21) then
					ResTable(i) := (a and d ) xor ( c and d ) xor ( a and b and d ) xor ( b and c and d);
			end if;
			if (Number = 22) then
					ResTable(i) := (a ) xor ( a and b ) xor ( b and c ) xor ( b and d ) xor ( a and b and d ) xor ( b and c and d);
			end if;
			if (Number = 23) then
					ResTable(i) := (d ) xor ( a and d ) xor ( b and d ) xor ( c and d ) xor ( a and b and d ) xor ( b and c and d);
			end if;
			if (Number = 24) then
					ResTable(i) := (a and b ) xor ( b and c ) xor ( a and b and d ) xor ( b and c and d);
			end if;
			if (Number = 26) then
					ResTable(i) := (b ) xor ( d ) xor ( a and b ) xor ( b and c ) xor ( a and d ) xor ( b and d ) xor ( c and d ) xor ( a and b and c ) xor ( a and b and d ) xor ( a and c and d);
			end if;
			if (Number = 27) then
					ResTable(i) := (a and d ) xor ( a and b and c ) xor ( a and b and d ) xor ( a and c and d);
			end if;
			if (Number = 28) then
					ResTable(i) := ( d ) xor ( b and c ) xor ( a and d ) xor ( b and d ) xor ( c and d ) xor ( a and b and c ) xor ( a and b and d ) xor ( a and c and d);
			end if;
			if (Number = 29) then
					ResTable(i) := (b and c ) xor ( b and d ) xor ( c and d ) xor ( a and b and c ) xor ( a and b and d ) xor ( a and c and d);
			end if;
			if (Number = 30) then
					ResTable(i) := (a ) xor ( a and b and c ) xor ( a and b and d ) xor ( a and c and d);
			end if;
			if (Number = 31) then
					ResTable(i) := (b ) xor ( a and b ) xor ( b and c ) xor ( b and d ) xor ( c and d ) xor ( a and b and c ) xor ( a and b and d ) xor ( a and c and d);
			end if;
			if (Number = 32) then
					ResTable(i) := (a ) xor ( a and b ) xor ( a and b and c ) xor ( a and b and d ) xor ( a and c and d);
			end if;
			
		end loop;
	  return ResTable;
	end LookUp_Gen;
	
	
	-------------------------------
	function LookUp_Inv_Gen	(Number	 : NATURAL;
								 const : STD_LOGIC := '0')
		return STD_LOGIC_VECTOR is
		variable ResTable	: STD_LOGIC_VECTOR (15 DOWNTO 0);
		variable Input		: STD_LOGIC_VECTOR(3 downto 0);
		variable a	: STD_LOGIC;
		variable b	: STD_LOGIC;
		variable c	: STD_LOGIC;
		variable d	: STD_LOGIC;
		variable Index   : NATURAL;
	begin
		
		
		for i in 0 to 15 loop
			input := std_logic_vector(to_unsigned(i,4));
			a := Input(0);
			b := Input(1);
			c := Input(2);
			d := Input(3);
			if (Number = 1) then
					ResTable(i) := ('1' ) xor ( d ) xor ( a and c ) xor ( b and d ) xor ( a and b and d ) xor ( a and c and d);
			end if;
			if (Number = 9) then
					ResTable(i) := ('1' ) xor ( a ) xor ( c ) xor ( b and c ) xor ( a and d ) xor ( c and d ) xor ( a and b and c);
			end if;
			if (Number = 17) then
					ResTable(i) := (a ) xor ( c ) xor ( a and b ) xor ( a and d ) xor ( a and b and c ) xor ( a and b and d);
			end if;
			if (Number = 25) then
					ResTable(i) := ( '1' ) xor ( b ) xor ( a and b ) xor ( b and c ) xor ( a and d ) xor ( b and d ) xor ( a and b and c ) xor ( a and c and d ) xor ( b and c and d);
			end if;
			
			if (Number = 2) then
					ResTable(i) := (a ) xor ( d ) xor ( a and b ) xor ( c and d ) xor ( a and b and d ) xor ( a and c and d);
			end if;
			if (Number = 3) then
					ResTable(i) := (c ) xor ( a and c ) xor ( c and d ) xor ( a and b and d ) xor ( a and c and d);
			end if;
			if (Number = 4) then
					ResTable(i) := (a ) xor ( b ) xor ( a and b ) xor ( b and d ) xor ( a and b and d ) xor ( a and c and d);
			end if;
			if (Number = 5) then
					ResTable(i) := (b ) xor ( c ) xor ( a and c ) xor ( b and c ) xor ( a and d ) xor ( a and b and d ) xor ( a and c and d);
			end if;
			if (Number = 6) then
					ResTable(i) := (b ) xor ( c ) xor ( a and b ) xor ( a and c ) xor ( b and c ) xor ( b and d ) xor ( c and d ) xor ( a and b and d ) xor ( a and c and d);
			end if;
			if (Number = 7) then
					ResTable(i) := (a ) xor ( a and b ) xor ( a and c ) xor ( b and c ) xor ( b and d ) xor ( c and d ) xor ( a and b and d ) xor ( a and c and d);
			end if;
			if (Number = 8) then
					ResTable(i) := (a ) xor ( b ) xor ( c ) xor ( a and c ) xor ( b and c ) xor ( a and d ) xor ( a and b and d ) xor ( a and c and d);
			end if;
			if (Number = 10) then
					ResTable(i) := (a ) xor ( b and c ) xor ( a and d ) xor ( c and d ) xor ( a and b and c);
			end if;
			
			if (Number = 11) then
					ResTable(i) := (d ) xor ( a and c ) xor ( a and d ) xor ( c and d ) xor ( a and b and c);
			end if;
			if (Number = 12) then
					ResTable(i) := (b ) xor ( a and c ) xor ( b and c ) xor ( a and d ) xor ( c and d ) xor ( a and b and c);
			end if;
			if (Number = 13) then
					ResTable(i) := (c ) xor ( a and b ) xor ( a and c ) xor ( a and d ) xor ( b and d ) xor ( a and b and c);
			end if;
			if (Number = 14) then
					ResTable(i) := (a and b ) xor ( a and c ) xor ( a and d ) xor ( b and d ) xor ( a and b and c);
			end if;
			if (Number = 15) then
					ResTable(i) := (b ) xor ( a and b ) xor ( b and c ) xor ( a and d ) xor ( b and d ) xor ( a and b and c);
			end if;
			if (Number = 16) then
					ResTable(i) := (d ) xor ( a and b ) xor ( a and d ) xor ( b and d ) xor ( a and b and c);
			end if;
			if (Number = 18) then
					ResTable(i) := (a and b and c ) xor ( a and b and d);
			end if;
			if (Number = 19) then
					ResTable(i) := (a and b ) xor ( a and c ) xor ( b and c ) xor ( b and d ) xor ( a and b and c ) xor ( a and b and d);
			end if;
			
			if (Number = 20) then
					ResTable(i) := (c ) xor ( d ) xor ( a and c ) xor ( b and c ) xor ( a and d ) xor ( b and d ) xor ( a and b and c ) xor ( a and b and d);
			end if;
			if (Number = 21) then
					ResTable(i) := (b and c ) xor ( b and d ) xor ( a and b and c ) xor ( a and b and d);
			end if;
			if (Number = 22) then
					ResTable(i) := (d ) xor ( a and b ) xor ( a and c ) xor ( b and c ) xor ( a and d ) xor ( b and d ) xor ( a and b and c ) xor ( a and b and d);
			end if;
			if (Number = 23) then
					ResTable(i) := (a and b ) xor ( a and c ) xor ( a and d ) xor ( a and b and c ) xor ( a and b and d);
			end if;
			if (Number = 24) then
					ResTable(i) := (a ) xor ( a and b and c ) xor ( a and b and d);
			end if;
			if (Number = 26) then
					ResTable(i) := (c and d ) xor ( a and b and c ) xor ( a and c and d ) xor ( b and c and d);
			end if;
			if (Number = 27) then
					ResTable(i) := (b ) xor ( a and c ) xor ( b and c ) xor ( c and d ) xor ( a and b and c ) xor ( a and c and d ) xor ( b and c and d);
			end if;
			if (Number = 28) then
					ResTable(i) := (a ) xor ( a and b ) xor ( a and c ) xor ( a and d ) xor ( b and d ) xor ( a and b and c ) xor ( a and c and d ) xor ( b and c and d);
			end if;
			if (Number = 29) then
					ResTable(i) := (a and c ) xor ( a and b and c ) xor ( a and c and d ) xor ( b and c and d);
			end if;
			if (Number = 30) then
					ResTable(i) := (a ) xor ( d ) xor ( a and b ) xor ( a and c ) xor ( b and c ) xor ( a and d ) xor ( b and d ) xor ( c and d ) xor ( a and b and c ) xor ( a and c and d ) xor ( b and c and d);
			end if;
			if (Number = 31) then
					ResTable(i) := (d ) xor ( a and b ) xor ( a and d ) xor ( b and d ) xor ( c and d ) xor ( a and b and c ) xor ( a and c and d ) xor ( b and c and d);
			end if;
			if (Number = 32) then
					ResTable(i) := (b and c ) xor ( a and b and c ) xor ( a and c and d ) xor ( b and c and d);
			end if;
			
		end loop;
	  return ResTable;
	end LookUp_Inv_Gen;
	
end functions;

