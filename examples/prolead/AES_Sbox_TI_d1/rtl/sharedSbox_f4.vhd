----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity sharedSbox_f4 is
    generic(SHARES     : INTEGER :=3 );
    Port   ( Zhin       : in  std_logic_vector(4*SHARES-1 downto 0);
			    Zlin       : in  std_logic_vector(4*SHARES-1 downto 0);
				 muld       : in  std_logic_vector(4*SHARES-1 downto 0);
				 NewMask_H1 : in  std_logic_vector(2*(SHARES-1)-1 downto 0);
				 NewMask_H2 : in  std_logic_vector(2*(SHARES-1)-1 downto 0);
				 NewMask_H3 : in  std_logic_vector(2*(SHARES-1)-1 downto 0);
				 NewMask_L1 : in  std_logic_vector(2*(SHARES-1)-1 downto 0);
				 NewMask_L2 : in  std_logic_vector(2*(SHARES-1)-1 downto 0);
				 NewMask_L3 : in  std_logic_vector(2*(SHARES-1)-1 downto 0);
			    ph_H       : out std_logic_vector(2*SHARES-1 downto 0);
			    p_H        : out std_logic_vector(2*SHARES-1 downto 0);
			    pl_H       : out std_logic_vector(2*SHARES-1 downto 0);
			    ph_L       : out std_logic_vector(2*SHARES-1 downto 0);
			    p_L        : out std_logic_vector(2*SHARES-1 downto 0);
			    pl_L       : out std_logic_vector(2*SHARES-1 downto 0)
			  );
end sharedSbox_f4;

architecture Behavioral of sharedSbox_f4 is

component GF_MULS_4_NewMask_1 is
generic (SHARES : integer :=3);
port(
	A        : in  std_logic_vector(4*SHARES-1 downto 0);
	B        : in  std_logic_vector(4*SHARES-1 downto 0);
	NewMask1 : in  std_logic_vector(2*(SHARES-1)-1 downto 0);
	NewMask2 : in  std_logic_vector(2*(SHARES-1)-1 downto 0);
	NewMask3 : in  std_logic_vector(2*(SHARES-1)-1 downto 0);
	ph       : out std_logic_vector(2*SHARES-1 downto 0);
	p        : out std_logic_vector(2*SHARES-1 downto 0);
	pl       : out std_logic_vector(2*SHARES-1 downto 0)
	);
end component GF_MULS_4_NewMask_1;


signal final_d : std_logic_vector(4*SHARES-1 downto 0);

begin

	final_d	<= muld;

---------------------------------------------------------------------------
-- ph_L, p_L, pl_L =  first part of (Zhin * multd)
---------------------------------------------------------------------------
multd_L: GF_MULS_4_NewMask_1
generic map(SHARES => SHARES)
port map(
	A        => Zhin,
	B        => final_d,
	NewMask1 => NewMask_L1,
	NewMask2 => NewMask_L2,
	NewMask3 => NewMask_L3,
	ph       => ph_L,
	p        => p_L,
	pl       => pl_L
	);

---------------------------------------------------------------------------
-- ph_H, p_H, pl_H =  first part of (multd * Zlin)
---------------------------------------------------------------------------
multd_H: GF_MULS_4_NewMask_1
generic map(SHARES => SHARES)
port map(
	A        => final_d,
	B        => Zlin,
	NewMask1 => NewMask_H1,
	NewMask2 => NewMask_H2,
	NewMask3 => NewMask_H3,
	ph       => ph_H,
	p        => p_H,
	pl       => pl_H
	);

end Behavioral;

