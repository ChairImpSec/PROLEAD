library IEEE;
use IEEE.std_logic_1164.all;
Library UNISIM;
use UNISIM.vcomponents.all;

entity g2BOOM is
	Port ( x : in  STD_LOGIC_VECTOR (7 downto 0);
	       y : out  STD_LOGIC_VECTOR (3 downto 0));
end entity g2BOOM;

architecture circ_arch of g2BOOM is
  		
  	signal temp         : std_logic;
	signal x1,y1,z1,w1  : std_logic;
  	signal x3,y3,z3,w3  : std_logic;
	
begin 
    
 	x1 <= x(7);
	y1 <= x(6);
	z1 <= x(5);
	w1 <= x(4);

	x3 <= x(3);
	y3 <= x(2);
	z3 <= x(1);
	w3 <= x(0);

	y(0) <= w3  xor  (x3 and y3)  xor  (x1 and y3)  xor  (x3 and y1)  xor  (x3 and z3)  xor  (x1 and z3)  xor  (x3 and z1)  xor  (y3 and z3)  xor  (y1 and z3)  xor  (y3 and z1);

	temp <= (y1 and w3)  xor  (y3 and w1)  xor  (z1 and w3)  xor  (z3 and w1)  xor  x1  xor  z3  xor  (y3 and w3)  xor  (z3 and w3) xor (y3 and z3);

	y(2) <= (y3  xor  z3);
	y(3) <= (y3  xor  z3  xor  w3); 
    
	---------------------- 
  
 	y(1) <= temp;
	
end circ_arch;