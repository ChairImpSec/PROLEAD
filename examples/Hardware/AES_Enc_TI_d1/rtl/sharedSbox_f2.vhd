----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity sharedSbox_f2 is
    generic(SHARES   : INTEGER :=3 );
    Port   ( Zhin        : in  std_logic_vector(4*SHARES-1 downto 0);
			    Zlin        : in  std_logic_vector(4*SHARES-1 downto 0);
				 ab2         : in  std_logic_vector(4*SHARES-1 downto 0);
			    ph          : in  std_logic_vector(2*SHARES-1 downto 0);
			    p           : in  std_logic_vector(2*SHARES-1 downto 0);
			    pl          : in  std_logic_vector(2*SHARES-1 downto 0);
	          NewMasksA2N : in  std_logic_vector(2*(SHARES-1)-1 downto 0);
	          NewMaskab   : in  std_logic_vector(2*(SHARES-1)-1 downto 0);
			    Zhout       : out std_logic_vector(4*SHARES-1 downto 0);
			    Zlout       : out std_logic_vector(4*SHARES-1 downto 0);
			    gamma1      : out std_logic_vector(2*SHARES-1 downto 0);
			    sA2N        : out std_logic_vector(2*SHARES-1 downto 0);
			    ab          : out std_logic_vector(2*SHARES-1 downto 0);
			    gamma0      : out std_logic_vector(2*SHARES-1 downto 0)				 
			  );
end sharedSbox_f2;

architecture Behavioral of sharedSbox_f2 is

component GF_MULS_4_NewMask_2 is
generic (SHARES : integer :=3);
port(	ph       : in std_logic_vector(2*SHARES-1 downto 0);
	   p        : in std_logic_vector(2*SHARES-1 downto 0);
   	pl       : in std_logic_vector(2*SHARES-1 downto 0);
	   Q        : out std_logic_vector(4*SHARES-1 downto 0)	
  	 );
end component GF_MULS_4_NewMask_2;


component GF_INV_4_1 is
generic (SHARES : integer :=3);
port(	A        : in  std_logic_vector(4*SHARES-1 downto 0);
	   NewMask1 : in  std_logic_vector(2*(SHARES-1)-1 downto 0);
 	   NewMask2 : in  std_logic_vector(2*(SHARES-1)-1 downto 0);
	   gamma1   : out std_logic_vector(2*SHARES-1 downto 0);
	   sA2N     : out std_logic_vector(2*SHARES-1 downto 0);
		ab       : out std_logic_vector(2*SHARES-1 downto 0);
	   gamma0   : out std_logic_vector(2*SHARES-1 downto 0)
  	 );
end component GF_INV_4_1;


signal abin, ab2abin  :std_logic_vector(4*SHARES-1 downto 0); 

begin

---------------------------------------------------------------------------
-- ab =  second part of (Zh * Zl) using ph, p, pl 
---------------------------------------------------------------------------
abmul: GF_MULS_4_NewMask_2
generic map(SHARES => SHARES)
port map(
	ph       => ph,
	p        => p,
	pl       => pl,
	Q        => abin
	);

---------------------------------------------------------------------------
-- ab2ab = (ab XOR ab2)
---------------------------------------------------------------------------
gen_ab2ab:
For i in 0 to SHARES-1 generate
ab2abin(4*i+3 downto 4*i) <= abin(4*i+3 downto 4*i) XOR ab2(4*i+3 downto 4*i);
end generate gen_ab2ab;


dinv_1: GF_INV_4_1
generic map(SHARES => SHARES)
port map(
  A        => ab2abin,
  NewMask1 => NewMasksA2N,
  NewMask2 => NewMaskab,
  gamma1   => gamma1,
  sA2N     => sA2N,
  ab       => ab,
  gamma0   => gamma0
	);

Zhout <= Zhin;
Zlout <= Zlin;

end Behavioral;

