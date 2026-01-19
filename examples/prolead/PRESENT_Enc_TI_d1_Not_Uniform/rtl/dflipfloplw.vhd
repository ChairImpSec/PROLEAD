-- D-Flip-Flop lightweight
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dflipfloplw is
	generic (NBITS: integer);
	port(
		clk	: in std_logic;
		en    : in std_logic;
		n_reset	: in std_logic;
		D	: in std_logic_vector(NBITS-1 downto 0);
		D_rst	: in std_logic_vector(NBITS-1 downto 0);
		Q	: out std_logic_vector(NBITS-1 downto 0)
		);

end entity dflipfloplw;

architecture dfl of dflipfloplw is

	signal s_current_state, s_next_state	: std_logic_vector(NBITS-1 downto 0);

begin
s_next_state	<= D;
Q <= s_current_state;

FLIP_FLOP:	Process(clk, en, n_reset, s_next_state)
	begin
		
		if (clk'event AND clk = '1') then
			if (en = '1') then
				if (n_reset = '0') then
					s_current_state <= D_rst;
				else
					s_current_state <= s_next_state;
				end if;
			end if;
		end if;
	end process;

end architecture dfl;
