----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:21:07 05/22/2009 
-- Design Name: 
-- Module Name:    sharedSbox - dfl 
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

entity sharedSbox is
    Port ( clk : in  STD_LOGIC;
			  en  : in  STD_LOGIC;
           sboxIn1 : in  STD_LOGIC_VECTOR (3 downto 0);
           sboxIn2 : in  STD_LOGIC_VECTOR (3 downto 0);
           sboxIn3 : in  STD_LOGIC_VECTOR (3 downto 0);
           share1 : out  STD_LOGIC_VECTOR (3 downto 0);
           share2 : out  STD_LOGIC_VECTOR (3 downto 0);
           share3 : out  STD_LOGIC_VECTOR (3 downto 0));
end sharedSbox;

architecture dfl of sharedSbox is


----------------------------------------------------------
-- component declaration
----------------------------------------------------------

component dflipfloplw1in is
	generic (NBITS: integer);
	port(
		clk	: in std_logic;
		en	   : in std_logic;
		D	: in std_logic_vector(NBITS-1 downto 0);
		Q	: out std_logic_vector(NBITS-1 downto 0)
		);
end component dflipfloplw1in;

component f1BOOM is
	Port ( x : in  STD_LOGIC_VECTOR (7 downto 0);
			 y: out  STD_LOGIC_VECTOR (3 downto 0));
end component f1BOOM;

component f2BOOM is
	Port ( x : in  STD_LOGIC_VECTOR (7 downto 0);
			   y : out  STD_LOGIC_VECTOR (3 downto 0));
end component f2BOOM;

component f3BOOM is
	Port ( x : in  STD_LOGIC_VECTOR (7 downto 0);
			 y: out STD_LOGIC_VECTOR (3 downto 0));
end component f3BOOM;

component g1BOOM is
	Port ( x : in  STD_LOGIC_VECTOR (7 downto 0);
			 y: out  STD_LOGIC_VECTOR (3 downto 0));
end component g1BOOM;

component g2BOOM is
	Port ( x : in  STD_LOGIC_VECTOR (7 downto 0);
			 y: out  STD_LOGIC_VECTOR (3 downto 0));
end component g2BOOM;

component g3BOOM is
	Port ( x : in  STD_LOGIC_VECTOR (7 downto 0);
			 y: out  STD_LOGIC_VECTOR (3 downto 0));
end component g3BOOM;

----------------------------------------------------------
-- data signals
----------------------------------------------------------
signal f1In, f2In, f3In : STD_LOGIC_VECTOR (7 downto 0);
signal f1Out, f2Out, f3Out : STD_LOGIC_VECTOR (3 downto 0);
signal g1In, g2In, g3In : STD_LOGIC_VECTOR (7 downto 0);
signal g1Out, g2Out, g3Out : STD_LOGIC_VECTOR (3 downto 0);
signal g1Reg, g2Reg, g3Reg : STD_LOGIC_VECTOR (3 downto 0);


begin

----------------------------------------------------------
-- component instantiations
----------------------------------------------------------

f1: f1BOOM
	Port map (x => f1In,
				 y => f1Out);

f2: f2BOOM
	Port map (x => f2In,
				 y => f2Out);
				 
f3: f3BOOM
	Port map (x => f3In,
				 y => f3Out);

g1: g1BOOM
	Port map (x => g1In,
				 y => g1Out);
				 
g2: g2BOOM
	Port map (x => g2In,
				 y => g2Out);
				 
g3: g3BOOM
	Port map (x => g3In,
				 y => g3Out);
				 
				 
y3: dflipfloplw1in
	generic map(NBITS=>4)
	Port map(
		clk => clk,
		en  => en,
		D => g3Out,
		Q => g3Reg
		);


y2: dflipfloplw1in
	generic map(NBITS=>4)
	Port map(
		clk => clk,
		en  => en,
		D => g2Out,
		Q => g2Reg
		);


y1: dflipfloplw1in
	generic map(NBITS=>4)
	Port map(
		clk => clk,
		en  => en,
		D => g1Out,
		Q => g1Reg
		);

f1In <= g3Reg&g2Reg;
f2In <= g3Reg&g1Reg;
f3In <= g2Reg&g1Reg;
g1In <= sboxIn2&sboxIn3;
g2In <= sboxIn1&sboxIn3;
g3In <= sboxIn1&sboxIn2;

share1 <= f1Out;
share2 <= f2Out;
share3 <= f3Out;

end dfl;

