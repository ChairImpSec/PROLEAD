library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity GF_MULS_4_NewMask_1 is
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
end GF_MULS_4_NewMask_1;

architecture DFL of GF_MULS_4_NewMask_1 is

component s_GF_MULS_2 is
generic (SHARES : integer :=3);
port(
	A : in  std_logic_vector(2*SHARES-1 downto 0);
	B : in  std_logic_vector(2*SHARES-1 downto 0);
	Q : out std_logic_vector(2*SHARES-1 downto 0)
	);
end component s_GF_MULS_2;

component AddMask_1 is
generic (SHARES       : integer :=3; 
         NumberOfBits : integer :=2);
port(
	A       : in  std_logic_vector(NumberOfBits*SHARES-1 downto 0);
	NewMask : in  std_logic_vector(NumberOfBits*(SHARES-1)-1 downto 0);
	Q       : out std_logic_vector(NumberOfBits*SHARES-1 downto 0)
	);
end component AddMask_1;

signal Ah, Al, Bh, Bl, sA, sB   : std_logic_vector(2*SHARES-1 downto 0);
signal Orig_p, Orig_ph, Orig_pl : std_logic_vector(2*SHARES-1 downto 0);

begin

gen_sig:
For i in 0 to SHARES-1 generate
Ah(2*i+1 downto 2*i) <= A(4*i+3 downto 4*i+2);
Al(2*i+1 downto 2*i) <= A(4*i+1 downto 4*i);

Bh(2*i+1 downto 2*i) <= B(4*i+3 downto 4*i+2);
Bl(2*i+1 downto 2*i) <= B(4*i+1 downto 4*i);
end generate gen_sig;

sA <= Ah XOR Al;
sB <= Bh XOR Bl;

himul: s_GF_MULS_2
generic map(SHARES => SHARES)
port map(
	A => Ah,
	B => Bh,
	Q => Orig_ph
	);

AddNewMaskph: AddMask_1
generic map(SHARES => SHARES,
				NumberOfBits => 2)
port map(
	A       => Orig_ph,
	NewMask => NewMask1,
	Q       => ph
	);


summul: s_GF_MULS_2
generic map(SHARES => SHARES)
port map(
	A => sA,
	B => sB,
	Q => Orig_p
	);

AddNewMaskp: AddMask_1
generic map(SHARES => SHARES,
				NumberOfBits => 2)
port map(
	A       => Orig_p,
	NewMask => NewMask2,
	Q       => p
	);

lowmul: s_GF_MULS_2
generic map(SHARES => SHARES)
port map(
	A => Al,
	B => Bl,
	Q => Orig_pl
	);

AddNewMaskpl: AddMask_1
generic map(SHARES => SHARES,
				NumberOfBits => 2)
port map(
	A       => Orig_pl,
	NewMask => NewMask3,
	Q       => pl
	);

end;
