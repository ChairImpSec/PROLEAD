----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity sharedSbox_f5 is
    generic(SHARES     : INTEGER :=3 );
    Port   ( ph_H       : in  std_logic_vector(2*SHARES-1 downto 0);
			    p_H        : in  std_logic_vector(2*SHARES-1 downto 0);
			    pl_H       : in  std_logic_vector(2*SHARES-1 downto 0);
			    ph_L       : in  std_logic_vector(2*SHARES-1 downto 0);
			    p_L        : in  std_logic_vector(2*SHARES-1 downto 0);
			    pl_L       : in  std_logic_vector(2*SHARES-1 downto 0);
         	 Q          : out std_logic_vector(8*SHARES-1 downto 0)
			  );
end sharedSbox_f5;

architecture Behavioral of sharedSbox_f5 is


component GF_MULS_4_NewMask_2 is
generic (SHARES : integer :=3);
port(	ph       : in std_logic_vector(2*SHARES-1 downto 0);
	   p        : in std_logic_vector(2*SHARES-1 downto 0);
   	pl       : in std_logic_vector(2*SHARES-1 downto 0);
	   Q        : out std_logic_vector(4*SHARES-1 downto 0)	
  	 ); 
end component GF_MULS_4_NewMask_2;


component inv_lin_map is
generic(SHARES : INTEGER :=3 );
port (
	C : in std_logic_vector(8*SHARES-1 downto 0); 
	Q : out std_logic_vector(8*SHARES-1 downto 0));
end component inv_lin_map;

signal pl, ph : std_logic_vector(4*SHARES-1 downto 0);
signal P		  : std_logic_vector(8*SHARES-1 downto 0);


begin


phwillwin: GF_MULS_4_NewMask_2
generic map(SHARES => SHARES)
port map(
	ph       => ph_H,
	p        => p_H,
	pl       => pl_H,
	Q        => ph
	);


plwillwin: GF_MULS_4_NewMask_2
generic map(SHARES => SHARES)
port map(
	ph       => ph_L,
	p        => p_L,
	pl       => pl_L,
	Q        => pl
	);


---------------------------------------------------------------------------
--/* change basis back from GF(2XOR8)/GF(2XOR4)/GF(2XOR2) to GF(2XOR8) */ 
---------------------------------------------------------------------------
gen_p:
For i in 0 to SHARES-1 generate
--p <= ph&pl;
p(8*i+7 downto 8*i) <= ph(4*i+3 downto 4*i)&pl(4*i+3 downto 4*i);
end generate gen_p;


invlinearMapping: inv_lin_map
generic map(SHARES => SHARES)
port map(
	C => p, 
	Q => Q
	);


end Behavioral;

