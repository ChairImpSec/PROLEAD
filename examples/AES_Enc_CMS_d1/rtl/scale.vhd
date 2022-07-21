library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity scale is
    Port ( a : in STD_LOGIC_VECTOR (1 downto 0);
           q : out STD_LOGIC_VECTOR (1 downto 0));
end scale;

architecture Behavioral of scale is

begin

    -- see canright, scale by w = Omega in GF(2^2), using normal basis [Omega^2,Omega]
    q(1) <= a(1);
    q(0) <= a(1) xor a(0);

end Behavioral;
