library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity GF_INV_4_2 is
generic (SHARES : integer :=3);
port(
	   gamma1   : in  std_logic_vector(2*SHARES-1 downto 0);
	   sA2N     : in  std_logic_vector(2*SHARES-1 downto 0);
	   ab       : in  std_logic_vector(2*SHARES-1 downto 0);
	   gamma0   : in  std_logic_vector(2*SHARES-1 downto 0);
		NewMaskQ : in  std_logic_vector(4*(SHARES-1)-1 downto 0);
		Q        : out std_logic_vector(4*SHARES-1 downto 0)
	);
end GF_INV_4_2;

architecture DFL of GF_INV_4_2 is

component GF_SQ_2 is
generic (SHARES : integer :=3);
port(
	A : in  std_logic_vector(2*SHARES-1 downto 0);
	Q : out std_logic_vector(2*SHARES-1 downto 0)
	);
end component GF_SQ_2;

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

signal final_sA2N, final_ab  : std_logic_vector(2*SHARES-1 downto 0);
signal absA2N,d              : std_logic_vector(2*SHARES-1 downto 0);
signal pl, ph 					  : std_logic_vector(2*SHARES-1 downto 0);
signal pre_Q  					  : std_logic_vector(4*SHARES-1 downto 0);

begin

final_sA2N <= sA2N;
final_ab   <= ab;	

absA2N <= final_ab XOR final_sA2N;

sASQ : GF_SQ_2
generic map(SHARES => SHARES)
port map(
	A => absA2N,
	Q => d
	);
	
himul: s_GF_MULS_2
generic map(SHARES => SHARES)
port map(
	A => gamma1,
	B => d,
	Q => pl
	);

lowmul: s_GF_MULS_2
generic map(SHARES => SHARES)
port map(
	A => d,
	B => gamma0,
	Q => ph
	);

gen_sig:
For i in 0 to SHARES-1 generate
pre_Q(4*i+3 downto 4*i) <= ph(2*i+1 downto 2*i)&pl(2*i+1 downto 2*i);
end generate gen_sig;

AddNewMaskQ: AddMask_1
generic map(SHARES => SHARES,
				NumberOfBits => 4)
port map(
	A       => pre_Q,
	NewMask => NewMaskQ,
	Q       => Q
	);

end;
