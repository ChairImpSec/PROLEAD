library IEEE;
use IEEE.std_logic_1164.all;

entity Cterm is
	Port ( x : in  STD_LOGIC_VECTOR (7 downto 0);
	       y : out  STD_LOGIC);
end entity Cterm;

architecture circ_arch of Cterm is
  		
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

	---------------------- 
    
 	y <= y1 and z1;
	 
end circ_arch;