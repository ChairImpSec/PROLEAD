-------------------------------------------------------------------
-- COMPANY : Ruhr University Bochum
-- AUTHOR  : Amir Moradi (amir.moradi@rub.de)
-- DOCUMENT: https:--eprint.iacr.org/2021/569/
-- -----------------------------------------------------------------
--
--
-- Copyright (c) 2021, David Knichel, Amir Moradi, Nicolai Müller, Pascal Sasdrich
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

package GHPC_pkg is

	-- Functions

	function xor_all (
		input 	: std_logic_vector)
		return std_logic;
		
	function GetBit (
		input 	: integer;
		size     : integer;
		myBit    : integer)
		return std_logic;
	
	-- Types	

	type bus_array is array(natural range <>, natural range <>) of std_logic;

end GHPC_pkg;

package body GHPC_pkg is
  
	function xor_all (
		input 	: std_logic_vector)
		return std_logic is
		variable res : std_logic := '0';
	begin
		for i in input'range loop
			res := res xor input(i);
		end loop;
		return res;
	end xor_all;

	--------------------------------------------------------

	function GetBit (
		input 	: integer;
		size     : integer;
		myBit    : integer)
		return std_logic is
		variable temp: std_logic_vector(size-1 downto 0);
		variable res : std_logic := '0';
	begin
		temp := std_logic_vector(to_unsigned(input, size));
		res := temp(myBit);
		return res;
	end GetBit;
  
end GHPC_pkg;
