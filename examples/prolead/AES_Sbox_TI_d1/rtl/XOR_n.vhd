library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity XOR_n is
generic (n : integer :=2);
port(
	A : in  std_logic_vector(n-1 downto 0);
	B : in  std_logic_vector(n-1 downto 0);
	Q : out std_logic_vector(n-1 downto 0));
end XOR_n;

architecture DFL of XOR_n is

begin

	Q	<= A XOR B;

end;
