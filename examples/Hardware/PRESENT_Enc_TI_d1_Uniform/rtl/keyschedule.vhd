----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:38:43 05/25/2009 
-- Design Name: 
-- Module Name:    keyschedule - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity keyschedule is
		Port ( clk : in  STD_LOGIC;
           ctrl : in  STD_LOGIC_VECTOR (2 downto 0);
			  counter : in STD_LOGIC_VECTOR(4 downto 0);
           inputA : in  STD_LOGIC_VECTOR (79 downto 0);
           inputB : in  STD_LOGIC_VECTOR (3 downto 0);
           outputA : out  STD_LOGIC_VECTOR (3 downto 0);
           outputB : out  STD_LOGIC_VECTOR (3 downto 0));
end keyschedule;

architecture dfl of keyschedule is

----------------------------------------------------------
-- component declaration
----------------------------------------------------------
component greg is
	generic (NBITS_D0: integer;
		 NBITS_D1: integer);
	port(
		clk	: in std_logic;
		sel	: in std_logic;
		en	: in std_logic;
		D0	: in std_logic_vector(NBITS_D0 - 1 downto 0);
		D1	: in std_logic_vector(NBITS_D1 - 1 downto 0);
		Q0	: out std_logic_vector(NBITS_D0 -1 downto 0);
		Q1	: out std_logic_vector(NBITS_D1 -1 downto 0)
		);

end component greg;

----------------------------------------------------------
-- signal declaration
----------------------------------------------------------

signal inputSer, outputSer : STD_LOGIC_VECTOR(3 DOWNTO 0);
signal inputPar, outputPar : STD_LOGIC_VECTOR(79 DOWNTO 0);
signal permOut: STD_LOGIC_VECTOR(79 DOWNTO 0);
signal counterAdd: STD_LOGIC_VECTOR(4 DOWNTO 0);


begin
----------------------------------------------------------
-- component instantiation
----------------------------------------------------------

keystate: greg
generic map(NBITS_D0=>4,
				NBITS_D1=>80)
	port map(
				clk => clk,
				sel => ctrl(0),
				en => ctrl(1),
				D0 => inputSer,
				D1 => inputPar,
				Q0 => outputSer,
				Q1 => outputPar
				);

----------------------------------------------------------
-- serial input Mux
----------------------------------------------------------
inputSer <= outputSer;

----------------------------------------------------------
-- key schedule permutation <<61
--  |79 78 ...  1  0|
--  16 clock cycles later
--  |15 14 ... 17 16|
-- after Permutation it should be
--  |18 17 ... 20 19|
-- -> rotate 3 position to the right
----------------------------------------------------------

permOut <= outputPar(2 downto 0)&outputPar(79 downto 3);

counterAdd <= permOut(19 downto 15) XOR counter;

inputPar <= inputA when ctrl(2) = '1'
				else inputB&permOut(75 downto 20)&counterAdd&permOut(14 downto 0);

outputA <= outputSer;

outputB <= permOut(79 downto 76);

end dfl;

