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

signal NewMaskFull : std_logic_vector(NumberOfBits*SHARES-1 downto 0);

begin

NewMaskFull(NumberOfBits*(SHARES-1)-1 downto 0)                       <= NewMask;
NewMaskFull(NumberOfBits*SHARES-1     downto NumberOfBits*(SHARES-1)) <= NewMask(NumberOfBits*2-1 downto NumberOfBits) XOR NewMask(NumberOfBits-1 downto 0);

Q <= A XOR NewMaskFull;

end;
