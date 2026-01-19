library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity xorBlock is
    generic (   N : integer := 4 );
    Port ( a : in   STD_LOGIC_VECTOR (N-1 downto 0);
           b : in   STD_LOGIC_VECTOR (N-1 downto 0);
           q : out  STD_LOGIC_VECTOR (N-1 downto 0));
end xorBlock;

architecture Behavioral of xorBlock is

begin

    q   <= a xor b;

end Behavioral;
