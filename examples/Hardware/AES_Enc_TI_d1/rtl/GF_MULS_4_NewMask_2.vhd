library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity GF_MULS_4_NewMask_2 is
generic (SHARES : integer :=3);
port(
	ph       : in std_logic_vector(2*SHARES-1 downto 0);
	p        : in std_logic_vector(2*SHARES-1 downto 0);
	pl       : in std_logic_vector(2*SHARES-1 downto 0);
	Q        : out std_logic_vector(4*SHARES-1 downto 0)	
	);
end GF_MULS_4_NewMask_2;

architecture DFL of GF_MULS_4_NewMask_2 is

component GF_SCLW2_2 is
generic (SHARES : integer :=3);
port(
	A : in  std_logic_vector(2*SHARES-1 downto 0);
	Q : out std_logic_vector(2*SHARES-1 downto 0)
	);
end component GF_SCLW2_2;

signal pw2, phpw2, plpw2           : std_logic_vector(2*SHARES-1 downto 0);
signal final_ph, final_p, final_pl : std_logic_vector(2*SHARES-1 downto 0);

begin

final_ph <= ph;	
final_p  <= p;
final_pl <= pl;

NxGAMMA : GF_SCLW2_2
generic map(SHARES => SHARES)
port map(
	A => final_p,
	Q => pw2
	);

phpw2 <= final_ph XOR pw2;
plpw2 <= final_pl XOR pw2;

gen_sig:
For i in 0 to SHARES-1 generate

Q(4*i+3 downto 4*i) <= phpw2(2*i+1 downto 2*i)&plpw2(2*i+1 downto 2*i);

end generate gen_sig;

end;
