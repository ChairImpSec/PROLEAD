--Template for FlipFlops
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity flipflop_en is
	generic (NBITS: integer);
	port(
		clk		: in std_logic;
		sel	: in std_logic;
		en	: in std_logic;
		D0	: in std_logic_vector(NBITS-1 downto 0);
		D1	: in std_logic_vector(NBITS-1 downto 0);
		Q	: out std_logic_vector(NBITS-1 downto 0)
		);

end entity flipflop_en;

architecture dfl of flipflop_en is

	signal d, s_current_state, s_next_state	: std_logic_vector(NBITS-1 downto 0);
	
begin
s_next_state	<= d;
q <= s_current_state;

FLIP_FLOP:	Process(clk, s_next_state, en, s_current_state)
	begin
	   if rising_edge(clk) then
            if en = '1' then
			     s_current_state <= s_next_state;
			else
			     s_current_state <= s_current_state;
			end if;
	   end if;
end process;

d <= D0 when sel = '0'
		else D1;
end architecture dfl;
