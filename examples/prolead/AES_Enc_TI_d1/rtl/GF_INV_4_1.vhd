library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity GF_INV_4_1 is
generic (SHARES : integer :=3);
port(
	   A        : in  std_logic_vector(4*SHARES-1 downto 0);
	   NewMask1 : in  std_logic_vector(2*(SHARES-1)-1 downto 0);
 	   NewMask2 : in  std_logic_vector(2*(SHARES-1)-1 downto 0);
	   gamma1   : out std_logic_vector(2*SHARES-1 downto 0);
	   sA2N     : out std_logic_vector(2*SHARES-1 downto 0);
		ab       : out std_logic_vector(2*SHARES-1 downto 0);
	   gamma0   : out std_logic_vector(2*SHARES-1 downto 0)
	);
end GF_INV_4_1;

architecture DFL of GF_INV_4_1 is

component s_GF_MULS_2 is
generic (SHARES : integer :=3);
port(
	A : in  std_logic_vector(2*SHARES-1 downto 0);
	B : in  std_logic_vector(2*SHARES-1 downto 0);
	Q : out std_logic_vector(2*SHARES-1 downto 0)
	);
end component s_GF_MULS_2;

component GF_SCLW2_2 is
generic (SHARES : integer :=3);
port(
	A : in  std_logic_vector(2*SHARES-1 downto 0);
	Q : out std_logic_vector(2*SHARES-1 downto 0)
	);
end component GF_SCLW2_2;

component GF_SQ_2 is
generic (SHARES : integer :=3);
port(
	A : in  std_logic_vector(2*SHARES-1 downto 0);
	Q : out std_logic_vector(2*SHARES-1 downto 0)
	);
end component GF_SQ_2;


component AddMask_1 is
generic (SHARES       : integer :=3; 
         NumberOfBits : integer :=2);
port(
	A       : in  std_logic_vector(NumberOfBits*SHARES-1 downto 0);
	NewMask : in  std_logic_vector(NumberOfBits*(SHARES-1)-1 downto 0);
	Q       : out std_logic_vector(NumberOfBits*SHARES-1 downto 0)
	);
end component AddMask_1;


signal Al, Ah, Orig_ab, sA, sA2, Orig_sA2N : std_logic_vector(2*SHARES-1 downto 0);

begin

gen_sig:
For i in 0 to SHARES-1 generate
Ah(2*i+1 downto 2*i) <= A(4*i+3 downto 4*i+2);
Al(2*i+1 downto 2*i) <= A(4*i+1 downto 4*i);
end generate gen_sig;

mul: s_GF_MULS_2
generic map(SHARES => SHARES)
port map(
	A => Ah,
	B => Al,
	Q => Orig_ab
	);

AddNewMaskab: AddMask_1
generic map(SHARES => SHARES,
				NumberOfBits => 2)
port map(
	A       => Orig_ab,
	NewMask => NewMask1,
	Q       => ab
	);

---------------------------------------------------------------------------
-- XOR sum of once buffered MSB and LSB
---------------------------------------------------------------------------
sA <= Ah XOR Al;


SQ : GF_SQ_2
generic map(SHARES => SHARES)
port map(
	A => sA,
	Q => sA2
	);

NxGAMMA : GF_SCLW2_2
generic map(SHARES => SHARES)
port map(
	A => sA2,
	Q => Orig_sA2N
	);


AddNewMasksA2N: AddMask_1
generic map(SHARES => SHARES,
				NumberOfBits => 2)
port map(
	A       => Orig_sA2N,
	NewMask => NewMask2,
	Q       => sA2N
	);


gamma1 <= Ah;
gamma0 <= Al;

end;
