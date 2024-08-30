--Template for clock gated state register with two inputs
--
--		D1
--		|
--	+---------------+
--  D0->|			|->Q0
--	+---------------+
--		|
--		Q1
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity greg is
	generic (NBITS_D0: integer;
		 NBITS_D1: integer);
	port(
		clk	: in std_logic;
		sel	: in std_logic;
		en	: in std_logic;
		D0	: in std_logic_vector(NBITS_D0 - 1 downto 0);
		D1	: in std_logic_vector(NBITS_D1 - 1 downto 0);
		Q0	: out std_logic_vector(NBITS_D0 -1 downto 0);
		Q1	: out std_logic_vector(NBITS_D1 -1 downto 0)
		);

end entity greg;


architecture dfl of greg is

	signal int_D0, int_Q 	: std_logic_vector(NBITS_D1 - 1 downto 0);

component dflipfloplw is
	generic (NBITS: integer);
	port(
		clk	: in std_logic;
		en    : in std_logic;
		n_reset	: in std_logic;
		D	: in std_logic_vector(NBITS-1 downto 0);
		D_rst	: in std_logic_vector(NBITS-1 downto 0);
		Q	: out std_logic_vector(NBITS-1 downto 0)
		);

end component dflipfloplw;

begin

gen_ff:
FOR i in 1 to NBITS_D1/NBITS_D0 GENERATE
gff: dflipfloplw
	generic map(NBITS=>NBITS_D0)
	port map(
		clk => clk,
		en	 => en,
		n_reset => sel,
      		D => D1(NBITS_D0*i - 1 downto (i-1)*NBITS_D0),
		D_rst => int_D0(NBITS_D0*i - 1 downto (i-1)*NBITS_D0),
      Q => int_Q(NBITS_D0*i - 1 downto (i-1)*NBITS_D0)
		);
		
		
END GENERATE gen_ff;

--regular case
int_D0 <= int_Q(NBITS_D1 - NBITS_D0 - 1 downto 0)&D0;

--special case for NBITS_D0 = NBITS_D1
--int_D0 <= D0;

Q0 <= int_Q(NBITS_D1 - 1 downto NBITS_D1 - NBITS_D0);
Q1 <= int_Q;


end architecture;
