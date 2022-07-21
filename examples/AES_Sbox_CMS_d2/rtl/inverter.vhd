library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity inverter is
    Port ( a :  in  STD_LOGIC_VECTOR (1 downto 0);
           q :  out STD_LOGIC_VECTOR (1 downto 0));
end inverter;

architecture Behavioral of inverter is

begin
    -- inverter GF(2^2) (inverting is the same as squaring)
    q(0) <= a(1);
    q(1) <= a(0);
end Behavioral;
