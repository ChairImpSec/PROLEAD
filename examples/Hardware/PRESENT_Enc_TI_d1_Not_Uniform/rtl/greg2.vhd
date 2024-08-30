--Template for clock gated state register with serial input and paralel output
--
--		
--		
--	     +---------------+
--  D ->|			      |
--	     +---------------+
--		         |
--		         Q
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity greg2 is
	generic (NBITS_D0: integer;
		      NBITS_D1: integer);
	port(
		clk  : in std_logic;
		en	  : in  std_logic;
		D	  : in  std_logic_vector(NBITS_D0 - 1 downto 0);
		Q	  : out std_logic_vector(NBITS_D1 - 1 downto 0));
end entity greg2;


architecture dfl of greg2 is

	signal inputSignal, int_Q 	: std_logic_vector(NBITS_D1 - 1 downto 0);

	component dflipfloplw1in is
		generic (NBITS: integer);
		port(
				 clk     : in std_logic;
				 en		: in std_logic;
				 D       : in std_logic_vector(NBITS-1 downto 0);
				 Q       : out std_logic_vector(NBITS-1 downto 0)
				 );
	end component dflipfloplw1in;		

begin

	gff: dflipfloplw1in
	generic map(NBITS=>NBITS_D1)
	port map(
		clk => clk,
		en	 => en,
  		D   => inputSignal,
      Q   => int_Q);
		
	
	inputSignal <= int_Q(NBITS_D1 - NBITS_D0 - 1 downto 0) & D;
	
	Q <= int_Q;

end architecture;
