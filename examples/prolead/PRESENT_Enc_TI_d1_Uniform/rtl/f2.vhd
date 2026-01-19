library IEEE;
use IEEE.std_logic_1164.all;

entity f2BOOM is
	Port ( x : in  STD_LOGIC_VECTOR (7 downto 0);
	       y : out  STD_LOGIC_VECTOR (3 downto 0));
end entity f2BOOM;

architecture circ_arch of f2BOOM is
  	signal x1,y1,z1,w1  : std_logic;
  	signal x3,y3,z3,w3  : std_logic;

begin 
  
	x3 <= x(7);
	y3 <= x(6);
	z3 <= x(5);
	w3 <= x(4);

	x1 <= x(3);
	y1 <= x(2);
	z1 <= x(1);
	w1 <= x(0);

	y(0) <= z3  xor  (y3 and w3)  xor  (y1 and w3)  xor  (y3 and w1);
	y(1) <= y3  xor  z3  xor  (x3 and w3)  xor  (x1 and w3)  xor  (x3 and w1);
	y(2) <= x3  xor  (z3 and w3)  xor  (z1 and w3)  xor  (z3 and w1);
	y(3) <= y3  xor  z3  xor  w3  xor  (x3 and w3)  xor  (x1 and w3)  xor  (x3 and w1);
	
end circ_arch;