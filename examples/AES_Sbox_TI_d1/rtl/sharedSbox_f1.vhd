----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity sharedSbox_f1 is
    generic(SHARES   : INTEGER :=3 );
    Port   ( A        : in  std_logic_vector(8*SHARES-1 downto 0); 
	          NewMask1 : in  std_logic_vector(2*(SHARES-1)-1 downto 0);
	          NewMask2 : in  std_logic_vector(2*(SHARES-1)-1 downto 0);
	          NewMask3 : in  std_logic_vector(2*(SHARES-1)-1 downto 0);
			    Zh       : out std_logic_vector(4*SHARES-1 downto 0);
			    Zl       : out std_logic_vector(4*SHARES-1 downto 0);
			    ab2      : out std_logic_vector(4*SHARES-1 downto 0);
			    ph       : out std_logic_vector(2*SHARES-1 downto 0);
			    p        : out std_logic_vector(2*SHARES-1 downto 0);
			    pl       : out std_logic_vector(2*SHARES-1 downto 0)
			  );
end sharedSbox_f1;

architecture Behavioral of sharedSbox_f1 is

component lin_map is
generic(SHARES : INTEGER :=3 );
port (
	A : in std_logic_vector(8*SHARES-1 downto 0); 
	Z : out std_logic_vector(8*SHARES-1 downto 0)
	);
end component lin_map;


component GF_SQ_SCL_4 is
generic (SHARES : integer :=3);
port(
	A : in  std_logic_vector(4*SHARES-1 downto 0);
	Q : out std_logic_vector(4*SHARES-1 downto 0)
	);
end component GF_SQ_SCL_4;


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


signal Z               :std_logic_vector(8*SHARES-1 downto 0); 
signal Zh_t, Zl_t, sZ :std_logic_vector(4*SHARES-1 downto 0); 

begin

---------------------------------------------------------------------------
--/* change basis from GF(2XOR8) to GF(2XOR8)/GF(2XOR4)/GF(2XOR2) */ 
--/* combine with bit inverse matrix multiply of Sbox */ 
---------------------------------------------------------------------------
linearMapping: lin_map
generic map(SHARES => SHARES)
port map(
	A => A, 
	Z => Z
	);

---------------------------------------------------------------------------
-- make Zh and Zl from Z
---------------------------------------------------------------------------
gen_Zh_Zl:
For i in 0 to SHARES-1 generate
-- MSB vs LSB
Zh_t(4*i+3 downto 4*i) <= Z(8*i+7 downto 8*i+4);
Zl_t(4*i+3 downto 4*i) <= Z(8*i+3 downto 8*i);
end generate gen_Zh_Zl;


---------------------------------------------------------------------------
-- ab2 = (Zh XOR Zl)^2 x Nu
---------------------------------------------------------------------------

gen_sZ:
For i in 0 to SHARES-1 generate
-- XOR
sZ(4*i+3 downto 4*i) <= Zh_t(4*i+3 downto 4*i) XOR Zl_t(4*i+3 downto 4*i);
end generate gen_sZ;

abSQ: GF_SQ_SCL_4
generic map(SHARES => SHARES)
port map(
	A => sZ,
	Q => ab2
	);


---------------------------------------------------------------------------
-- ph, p, pl =  first part of (Zh * Zl)
---------------------------------------------------------------------------
phpplmul: GF_MULS_4_NewMask_1
generic map(SHARES => SHARES)
port map(
	A        => Zh_t,
	B        => Zl_t,
	NewMask1 => NewMask1,
	NewMask2 => NewMask2,
	NewMask3 => NewMask3,
	ph       => ph,
	p        => p,
	pl       => pl
	);

Zh <= Zh_t;
Zl <= Zl_t;

end Behavioral;

