library IEEE;
use IEEE.std_logic_1164.all;

entity f1BOOM is
	Port ( x : in  STD_LOGIC_VECTOR (7 downto 0);
	       y : out  STD_LOGIC_VECTOR (3 downto 0));
end entity f1BOOM;


architecture circ_arch of f1BOOM is
  	signal x2,y2,z2,w2  : std_logic;
  	signal x3,y3,z3,w3  : std_logic;

begin 
  
	x3 <= x(7);
	y3 <= x(6);
	z3 <= x(5);
	w3 <= x(4);

	x2 <= x(3);
	y2 <= x(2);
	z2 <= x(1);
	w2 <= x(0);


	y(0) <= z2  xor  (y2 and w2)  xor  (y2 and w3)  xor  (y3 and w2);
	y(1) <= y2  xor  z2  xor  (x2 and w2)  xor  (x2 and w3)  xor  (x3 and w2);
	y(2) <= x2  xor  (z2 and w2)  xor  (z2 and w3)  xor  (z3 and w2);
	y(3) <= y2  xor  z2  xor  w2  xor  (x2 and w2)  xor  (x2 and w3)  xor  (x3 and w2);
		
end circ_arch;
