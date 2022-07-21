-- D-Flip-Flop lightweight 1 input
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dflipfloplw1in is
        generic (NBITS: integer);
        port(
                clk     : in std_logic;
                en		: in std_logic;
                D       : in std_logic_vector(NBITS-1 downto 0);
                Q       : out std_logic_vector(NBITS-1 downto 0)
                );

end entity dflipfloplw1in;

architecture dfl of dflipfloplw1in is

        signal s_current_state, s_next_state    : std_logic_vector(NBITS-1 downto 0);

begin
s_next_state    <= D;
Q <= s_current_state;

FLIP_FLOP:      Process(clk, en , s_next_state)
        begin

                if (clk'event AND clk = '1') then
                      if (en = '1') then
                                s_current_state <= s_next_state;
                        end if;
                end if;
        end process;

end architecture dfl;