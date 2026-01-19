library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity GF_SCLW2_2 is
generic (SHARES : integer :=3);
port(
	A : in  std_logic_vector(2*SHARES-1 downto 0);
	Q : out std_logic_vector(2*SHARES-1 downto 0)
	);
end GF_SCLW2_2;

architecture DFL of GF_SCLW2_2 is

begin

--gen_sig:
--For i in 0 to SHARES-1 generate

--Q(2*i+1) <= A(2*i);
--Q(2*i) <= A(2*i) XOR A(2*i+1);
--end generate gen_sig;

Q <= A(4)&(A(4) XOR A(5))&A(2)&(A(2) XOR A(3))&A(0)&(A(0) XOR A(1));

end;
--/* scale by w^2 <= OmegaXOR2 in GF(2XOR2), using normal basis (OmegaXOR2,Omega) */ 
-- module GF_SCLW2_2 ( A, Q ); 
-- input (1:0) A; 
-- output (1:0) Q; 
--  Q <= { A(0), (A(1) XOR A(0)) }; 
-- endmodule 
