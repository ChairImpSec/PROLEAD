library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity GF_SQ_SCL_4 is
generic (SHARES : integer :=3);
port(
	A : in  std_logic_vector(4*SHARES-1 downto 0);
	Q : out std_logic_vector(4*SHARES-1 downto 0)
	);
end GF_SQ_SCL_4;

architecture DFL of GF_SQ_SCL_4 is

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


signal al, sA, sA2, aw, aw2 : std_logic_vector(2*SHARES-1 downto 0);

begin



gen_sig:
For i in 0 to SHARES-1 generate
-- XOR
sA(2*i+1) <= A(4*i+3) XOR A(4*i+1);
sA(2*i) <= A(4*i+2) XOR A(4*i);

-- A(1:0)
al(2*i+1) <= A(4*i+1);
al(2*i) <= A(4*i);

--Q <= sA2&aw2;
Q(4*i+3 downto 4*i) <= sA2(2*i+1 downto 2*i)&aw2(2*i+1 downto 2*i);

end generate gen_sig;


sAsq: GF_SQ_2
generic map(SHARES => SHARES)
port map(
	A => sA,
	Q => sA2
	);
	
	NxGamma : GF_SCLW2_2
generic map(SHARES => SHARES)
port map(
	A => al,
	Q => aw
	);

awsq: GF_SQ_2
generic map(SHARES => SHARES)
port map(
	A => aw,
	Q => aw2
	);

end;
--/* square AND scale by nu in GF(2XOR4)/GF(2XOR2), normal basis (alphaXOR8, alphaXOR2) */ 
--/* nu <= betaXOR8 <= NXOR2*alphaXOR2, N <= wXOR2 */ 
-- entity GF_SQ_SCL_4 ( A, Q ); 
-- input (3:0) A; 
-- output (3:0) Q; 
-- signal (1:0) a, b, ab2, b2, b2N2; 
--  a <= A(3:2); 
--  b <= A(1:0); 
-- GF_SQ_2 absq(a XOR b,ab2); 
-- GF_SQ_2 bsq(b,b2); 
-- GF_SCLW_2 bmulN2(b2,b2N2); 
--  Q <= { ab2, b2N2 }; 
-- endmodule 
