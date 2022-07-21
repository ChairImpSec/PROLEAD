library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity AddMask_1 is
generic (SHARES       : integer :=3; 
         NumberOfBits : integer :=2);
port(
	A       : in  std_logic_vector(NumberOfBits*SHARES-1 downto 0);
	NewMask : in  std_logic_vector(NumberOfBits*(SHARES-1)-1 downto 0);
	Q       : out std_logic_vector(NumberOfBits*SHARES-1 downto 0)
	);
end AddMask_1;

architecture DFL of AddMask_1 is 

	signal MaskXOR : std_logic_vector(NumberOfBits-1 downto 0);

	component XOR_n is
	generic (n : integer);
	port(
		A : in  std_logic_vector(n-1 downto 0);
		B : in  std_logic_vector(n-1 downto 0);
		Q : out std_logic_vector(n-1 downto 0));
	end component XOR_n;

begin

	MaskXORInst : XOR_n generic map(NumberOfBits)
	port map( NewMask(NumberOfBits*1-1 downto 0),
				 NewMask(NumberOfBits*2-1 downto NumberOfBits),
				 MaskXOR);

	XORInst1 : XOR_n generic map(NumberOfBits)
	port map( A(NumberOfBits*3-1 downto NumberOfBits*2),
				 MaskXOR,
				 Q(NumberOfBits*3-1 downto NumberOfBits*2));

	XORInst2 : XOR_n generic map(NumberOfBits*2)
	port map( A(NumberOfBits*2-1 downto 0),
				 NewMask,
				 Q(NumberOfBits*2-1 downto 0));

end;
