----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:40:36 05/25/2009 
-- Design Name: 
-- Module Name:    dataBody - Behavioral 
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

entity dataBody is
    Port ( clk : in  STD_LOGIC;
           ctrl : in  STD_LOGIC_VECTOR (2 downto 0);
           inputA : in  STD_LOGIC_VECTOR (63 downto 0);
           inputB : in  STD_LOGIC_VECTOR (3 downto 0);
           output : out  STD_LOGIC_VECTOR (3 downto 0));
end dataBody;

--ctrl = MUX&EN&SEL

architecture dfl of dataBody is


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

component pdata is
port(
	data_in	: in std_logic_vector(63 downto 0);
	data_out:	out std_logic_vector(63 downto 0)
	);
	
end component pdata;

----------------------------------------------------------
-- signal declaration
----------------------------------------------------------

signal inputSer, outputSer : STD_LOGIC_VECTOR(3 DOWNTO 0);
signal permIn, permOut : STD_LOGIC_VECTOR(63 DOWNTO 0);
signal inputPar, outputPar : STD_LOGIC_VECTOR(63 DOWNTO 0);


begin
----------------------------------------------------------
-- component instantiation
----------------------------------------------------------

state: greg
generic map(NBITS_D0=>4,
				NBITS_D1=>64)
	port map(
				clk => clk,
				sel => ctrl(0),
				en => ctrl(1),
				D0 => inputSer,
				D1 => inputPar,
				Q0 => outputSer,
				Q1 => outputPar
				);

--because of the piepline stage in S-box
permIn <= outputPar(59 downto 0)&inputSer;

permutation: pdata
	port map(
				data_in => permIn,
				data_out => permOut
				);
				
inputPar <= inputA when ctrl(2) = '1'
				else permOut;				
								
----------------------------------------------------------
-- serial input Mux
----------------------------------------------------------
inputSer <= inputB;

output <= outputSer;
	
end dfl;

