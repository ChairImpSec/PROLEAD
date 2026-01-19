--Template for FlipFlops
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ff_en is
	generic (NBITS: integer);
	port(
		clk		: in std_logic;
		en	: in std_logic;
		D	: in std_logic_vector(NBITS-1 downto 0);
		Q	: out std_logic_vector(NBITS-1 downto 0)
		);

end entity ff_en;

architecture dfl of ff_en is

	signal s_current_state, s_next_state	: std_logic_vector(NBITS-1 downto 0);
	
begin
s_next_state	<= D;
Q <= s_current_state;

FLIP_FLOP:	Process(clk, s_next_state, en)
	begin
		if en = '1' AND (clk'event AND clk = '1') then
			s_current_state <= s_next_state;
		end if;
end process;

end architecture dfl;
