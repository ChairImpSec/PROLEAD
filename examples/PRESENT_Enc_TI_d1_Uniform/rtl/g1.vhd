library IEEE;
use IEEE.std_logic_1164.all;

entity g1BOOM is
	Port ( x : in  STD_LOGIC_VECTOR (7 downto 0);
	       y : out  STD_LOGIC_VECTOR (3 downto 0));
end entity g1BOOM;

architecture circ_arch of g1BOOM is
  	signal temp         : std_logic;
  	signal x2,y2,z2,w2  : std_logic;
  	signal x3,y3,z3,w3  : std_logic;

begin 
  
	x2 <= x(7);
	y2 <= x(6);
	z2 <= x(5);
	w2 <= x(4);

	x3 <= x(3);
	y3 <= x(2);
	z3 <= x(1);
	w3 <= x(0);


	y(0) <= ((x2 and y3) xnor (x3 and y2))	xor (x2 and z3) xor (x3 and z2) xor (y2 and z3) xor (y3 and z2) xor w2 xor (x2 and y2) xor (x2 and z2) xor (y2 and z2);
	
	temp <= ((y2 and w3) xnor (y3 and w2)) xor (z2 and w3) xor (z3 and w2) xor x3 xor z2 xor (y2 and w2) xor (z2 and w2);
	y(1) <= temp xor (y2 and z2) xor (y3 and z3);
	
	y(2) <= (y2 xnor z2);
	y(3) <= (y2 xor z2 xor w2);

end circ_arch;
