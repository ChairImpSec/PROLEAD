--
-- -----------------------------------------------------------------
-- COMPANY : Ruhr University Bochum
-- AUTHOR  : Aein Rezaei Shahmirzadi (aein.rezaeishahmirzadi@rub.de)
-- DOCUMENT: "Cryptanalysis of Efficient Masked Ciphers: Applications to Low Latency" TCHES 2022, Issue 1
-- -----------------------------------------------------------------
--
-- Copyright c 2021, Aein Rezaei Shahmirzadi
--
-- All rights reserved.
--
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
-- ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
-- WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
-- DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTERS BE LIABLE FOR ANY
-- DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
-- INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
-- LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION HOWEVER CAUSED AND
-- ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
-- INCLUDING NEGLIGENCE OR OTHERWISE ARISING IN ANY WAY OUT OF THE USE OF THIS
-- SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
--
-- Please see LICENSE and README for license and further instructions.
--



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package functions is

	function MakeStateUpdateTable ( BitNumber : NATURAL)
		return STD_LOGIC_VECTOR;

	function MakeGF16_MulTable ( 
		c 			 : STD_LOGIC_VECTOR (3 DOWNTO 0);
		BitNumber : NATURAL)
		return STD_LOGIC_VECTOR;

	function MakeSignalAddKeyTable
		return STD_LOGIC_VECTOR ;
		
	function MakeSignalSelKeyTable
		return STD_LOGIC_VECTOR ;

	function MakeSignaldoneTable
		return STD_LOGIC_VECTOR ;

end functions;

package body functions is	

	function MakeStateUpdate (
		FSM  	  	  : STD_LOGIC_VECTOR (5 DOWNTO 0))
		return STD_LOGIC_VECTOR is
		variable FSMUpdate : STD_LOGIC_VECTOR (5 DOWNTO 0);
		variable en    : STD_LOGIC;
	begin
		if (FSM = "010011") then
			FSMUpdate(0) := FSM(0);
			FSMUpdate(1) := FSM(1);
			FSMUpdate(2) := FSM(2);
			FSMUpdate(3) := FSM(3);
			FSMUpdate(4) := FSM(4);
			FSMUpdate(5) := FSM(5);	  
		else
			FSMUpdate(0) := FSM(4) XNOR FSM(5);
			FSMUpdate(1) := FSM(0);
			FSMUpdate(2) := FSM(1);
			FSMUpdate(3) := FSM(2);
			FSMUpdate(4) := FSM(3);
			FSMUpdate(5) := FSM(4);	  
		end if;
		
		return FSMUpdate;
	end MakeStateUpdate;	
	
	-----

	function MakeStateUpdateTable ( BitNumber : NATURAL)
		return STD_LOGIC_VECTOR is
		variable FSMUpdateTable : STD_LOGIC_VECTOR (63 DOWNTO 0);
		variable FSMUpdate      : STD_LOGIC_VECTOR (5  DOWNTO 0);
		variable i   : NATURAL;
	begin
		for i in 0 to 63 loop
			FSMUpdate := MakeStateUpdate(std_logic_vector(to_unsigned(i,6)));
			FSMUpdateTable(63-i) := FSMUpdate(BitNumber);
		end loop;
	  return FSMUpdateTable;
	end MakeStateUpdateTable;	

	-------------------------------
	
	function GF16_Mul (
		x  	  	  : STD_LOGIC_VECTOR (3 DOWNTO 0);
		c          : STD_LOGIC_VECTOR (3 DOWNTO 0))
		return STD_LOGIC_VECTOR is
		variable y : STD_LOGIC_VECTOR (3 DOWNTO 0);
	begin
		
		y(0) := (c(0) AND x(0)) XOR (c(1) AND x(3)) XOR (c(2) AND x(2)) XOR (c(3) AND x(1));
		y(1) := (c(0) AND x(1)) XOR (c(1) AND x(0)) XOR (c(2) AND x(3)) XOR (c(3) AND x(2)) XOR (c(1) AND x(3)) XOR (c(2) AND x(2)) XOR (c(3) AND x(1));
		y(2) := (c(0) AND x(2)) XOR (c(1) AND x(1)) XOR (c(2) AND x(0)) XOR (c(3) AND x(3)) XOR (c(2) AND x(3)) XOR (c(3) AND x(2));
		y(3) := (c(0) AND x(3)) XOR (c(1) AND x(2)) XOR (c(2) AND x(1)) XOR (c(3) AND x(0)) XOR (c(3) AND x(3));
		
		return y;
	end GF16_Mul;		

	-----
	
	function MakeGF16_MulTable ( 
		c         : STD_LOGIC_VECTOR (3 DOWNTO 0);
		BitNumber : NATURAL)
		return STD_LOGIC_VECTOR is
		variable GF16_MulTable  : STD_LOGIC_VECTOR (15 DOWNTO 0);
		variable y              : STD_LOGIC_VECTOR (3  DOWNTO 0);
		variable i   : NATURAL;
	begin
		for i in 0 to 15 loop
			y := GF16_Mul(std_logic_vector(to_unsigned(i,4)), c);
			GF16_MulTable(15-i) := y(BitNumber);
		end loop;
	  return GF16_MulTable;
	end MakeGF16_MulTable;	

	-------------------------------

	function MakeSignalAddKey (
		FSM  	  	  : STD_LOGIC_VECTOR (5 DOWNTO 0))
		return STD_LOGIC is
		variable AddKey : STD_LOGIC;
	begin
		IF ((FSM = "000001") OR (FSM = "011111") OR (FSM = "110111") OR 
		    (FSM = "111001") OR (FSM = "011101") OR (FSM = "010110") OR 
			 (FSM = "100001") OR (FSM = "010111") OR (FSM = "110001") OR
			 (FSM = "011011") OR (FSM = "110100") OR (FSM = "001000")) THEN
			AddKey := '1';
		ELSE
			AddKey := '0';
		END IF;
		return AddKey;
	end MakeSignalAddKey;	
	
	-----

	function MakeSignaldone (
		FSM  	  	  : STD_LOGIC_VECTOR (5 DOWNTO 0))
		return STD_LOGIC is
		variable done : STD_LOGIC;
	begin
		IF (FSM = "001001") THEN
			done := '1';
		ELSE 
			done := '0';
		END IF;	
		return done;
	end MakeSignaldone;	
	
	-----
	
	function MakeSignalSelKey (
		FSM  	  	  : STD_LOGIC_VECTOR (5 DOWNTO 0))
		return STD_LOGIC is
		variable SelKey : STD_LOGIC;
	begin
		IF ((FSM = "000001") OR (FSM = "110111") OR (FSM = "011101") OR
			 (FSM = "100001") OR (FSM = "110001") OR (FSM = "110100")) THEN
			SelKey := '0';
		ELSE
			SelKey := '1';
		END IF;
		return SelKey;
	end MakeSignalSelKey;		

	----------------
	
	function MakeSignalAddKeyTable
		return STD_LOGIC_VECTOR is
		variable AddKeyTable : STD_LOGIC_VECTOR (63 DOWNTO 0);
		variable i   : NATURAL;
	begin
		for i in 0 to 63 loop
			AddKeyTable(63-i) := MakeSignalAddKey(std_logic_vector(to_unsigned(i,6)));
		end loop;
	  return AddKeyTable;
	end MakeSignalAddKeyTable;	
	
	------
	
	function MakeSignaldoneTable
		return STD_LOGIC_VECTOR is
		variable doneTable : STD_LOGIC_VECTOR (63 DOWNTO 0);
		variable i   : NATURAL;
	begin
		for i in 0 to 63 loop
			doneTable(63-i) := MakeSignaldone(std_logic_vector(to_unsigned(i,6)));
		end loop;
	  return doneTable;
	end MakeSignaldoneTable;	

	------
	
	function MakeSignalSelKeyTable
		return STD_LOGIC_VECTOR is
		variable SelKeyTable : STD_LOGIC_VECTOR (63 DOWNTO 0);
		variable i   : NATURAL;
	begin
		for i in 0 to 63 loop
			SelKeyTable(63-i) := MakeSignalSelKey(std_logic_vector(to_unsigned(i,6)));
		end loop;
	  return SelKeyTable;
	end MakeSignalSelKeyTable;	
	
end functions;

