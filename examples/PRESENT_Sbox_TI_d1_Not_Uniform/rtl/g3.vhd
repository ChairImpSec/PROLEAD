library IEEE;
use IEEE.std_logic_1164.all;

entity g3BOOM is
	Port ( x : in  STD_LOGIC_VECTOR (7 downto 0);
	       y : out  STD_LOGIC_VECTOR (3 downto 0));
end entity g3BOOM;

architecture circ_arch of g3BOOM is

  	signal temp         : std_logic;
	signal x1,y1,z1,w1  : std_logic;
  	signal x2,y2,z2,w2  : std_logic;

begin 
  
	x1 <= x(7);
	y1 <= x(6);
	z1 <= x(5);
	w1 <= x(4);

	x2 <= x(3);
	y2 <= x(2);
	z2 <= x(1);
	w2 <= x(0);

	y(0) <= w1  xor  (x1 and y1)  xor  (x1 and y2)  xor  (x2 and y1)  xor  (x1 and z1)  xor  (x1 and z2)  xor  (x2 and z1)  xor  (y1 and z1)  xor  (y1 and z2)  xor  (y2 and z1);
	
	temp <= (y1 and w2)  xor  (y2 and w1)  xor  (z1 and w2)  xor  (z2 and w1)  xor  x2  xor  z1  xor  (y1 and w1)  xor  (z1 and w1) xor (y2 and z2);
	
	y(2) <= (y1  xor  z1);
	y(3) <= (y1  xor  z1  xor  w1);

	---------------------- 
      
 	y(1) <= temp;
	
end circ_arch;

