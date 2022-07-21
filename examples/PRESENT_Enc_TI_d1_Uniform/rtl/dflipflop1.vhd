-- D-Flip-Flop lightweight 1 input
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dflipflop1 is
        port(
                clk     : in std_logic;
                D       : in std_logic;
                Q       : out std_logic
                );

end entity dflipflop1;

architecture dfl of dflipflop1 is

        signal s_current_state, s_next_state    : std_logic;

begin
s_next_state    <= D;
Q <= s_current_state;

FLIP_FLOP:      Process(clk, s_next_state)
        begin

                if (clk'event AND clk = '1') then
                        s_current_state <= s_next_state;
                end if;
        end process;

end architecture dfl;