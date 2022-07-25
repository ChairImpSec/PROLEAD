
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.GHPC_pkg.all;

entity main is
   Generic (
      low_latency   : integer := 0;   -- 0 / 1
      pipeline      : integer := 1);  -- 0 / 1
   Port(
	a   : in  std_logic_vector(1 downto 0);
	b   : in  std_logic_vector(1 downto 0);
	c   : in  std_logic_vector(1 downto 0);
	r   : in  std_logic_vector((2*(1+low_latency*3))-1 downto 0);
	clk : in  std_logic;
	d   : out std_logic_vector(1 downto 0));
end main;

architecture Behavioral of main is 

	constant in_size  : integer := 2;
	constant out_size : integer := 1; 

	signal t  : std_logic_vector(1 downto 0);

begin

	inst1: entity work.and_GHPC
	Generic map (
           low_latency   => low_latency,
           pipeline      => pipeline)
        Port map (
   	   a   => a,
           b   => b,
           r   => r((1+low_latency*3)-1 downto 0),
  	   clk => clk,
	   c   => t);

	inst2: entity work.and_GHPC
	Generic map (
           low_latency   => low_latency,
           pipeline      => pipeline)
        Port map (
   	   a   => t,
           b   => c,
           r   => r(2*(1+low_latency*3)-1 downto (1+low_latency*3)),
  	   clk => clk,
	   c   => d);
	
end Behavioral;
