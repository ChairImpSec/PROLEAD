----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity sharedSbox_f3 is
    generic(SHARES   : INTEGER :=3 );
    Port   ( Zhin     : in  std_logic_vector(4*SHARES-1 downto 0);
			    Zlin     : in  std_logic_vector(4*SHARES-1 downto 0);
			    gamma1   : in  std_logic_vector(2*SHARES-1 downto 0);
				 sA2N     : in  std_logic_vector(2*SHARES-1 downto 0);
				 ab       : in  std_logic_vector(2*SHARES-1 downto 0);
			    gamma0   : in  std_logic_vector(2*SHARES-1 downto 0);			 
				 NewMaskQ : in  std_logic_vector(4*(SHARES-1)-1 downto 0);
			    Zhout    : out std_logic_vector(4*SHARES-1 downto 0);
			    Zlout    : out std_logic_vector(4*SHARES-1 downto 0);
				 muld     : out std_logic_vector(4*SHARES-1 downto 0)
			  );
end sharedSbox_f3;

architecture Behavioral of sharedSbox_f3 is

component GF_INV_4_2 is
generic (SHARES : integer :=3);
port(	gamma1   : in  std_logic_vector(2*SHARES-1 downto 0);
	   sA2N     : in  std_logic_vector(2*SHARES-1 downto 0);
	   ab       : in  std_logic_vector(2*SHARES-1 downto 0);
	   gamma0   : in  std_logic_vector(2*SHARES-1 downto 0);
		NewMaskQ : in  std_logic_vector(4*(SHARES-1)-1 downto 0);
		Q        : out std_logic_vector(4*SHARES-1 downto 0)
  	 );
end component GF_INV_4_2;

begin

dinv_2: GF_INV_4_2
generic map(SHARES => SHARES)
port map(
  gamma1   => gamma1,
  sA2N     => sA2N,
  ab       => ab,
  gamma0   => gamma0,
  NewMaskQ => NewMaskQ,
  Q        => muld
	);

Zhout <= Zhin;
Zlout <= Zlin;

end Behavioral;

