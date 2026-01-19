library IEEE;
use IEEE.std_logic_1164.all;

entity f3BOOM is
	Port ( x : in  STD_LOGIC_VECTOR (7 downto 0);
	       y : out  STD_LOGIC_VECTOR (3 downto 0));
end entity f3BOOM;

architecture circ_arch of f3BOOM is
  	signal x1,y1,z1,w1  : std_logic;
  	signal x2,y2,z2,w2  : std_logic;

begin 
  
	x2 <= x(7);
	y2 <= x(6);
	z2 <= x(5);
	w2 <= x(4);

	x1 <= x(3);
	y1 <= x(2);
	z1 <= x(1);
	w1 <= x(0);

	y(0) <= 		z1  xor  (y1 and w1)  xor  (y1 and w2)  xor  (y2 and w1);
	y(1) <= y1  xor  z1  xor  (x1 and w1)  xor  (x1 and w2)  xor  (x2 and w1);
	y(2) <= x1  xor  (z1 and w1)  xor  (z1 and w2)  xor  (z2 and w1);
	y(3) <= y1  xor  z1  xor  w1  xor  (x1 and w1)  xor  (x1 and w2)  xor  (x2 and w1);
	
end circ_arch;

