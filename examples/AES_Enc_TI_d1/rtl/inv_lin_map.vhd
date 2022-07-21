library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity inv_lin_map is
generic(SHARES : INTEGER :=3 );
port (
	C : in std_logic_vector(8*SHARES-1 downto 0); 
	Q : out std_logic_vector(8*SHARES-1 downto 0)
	);
end inv_lin_map;

architecture dfl of inv_lin_map is

signal D: std_logic_Vector(8*SHARES-1 downto 0);
signal T1, T2, T3, T4, T5, T6, T7, T8, T9 : std_logic_vector(SHARES -1 downto 0); 

begin

gen_sig:
For i in 0 to SHARES-1 generate

T1(i) <= C(7+8*i) XOR C(3+8*i) ; 
 T2(i) <= C(6+8*i) XOR C(4+8*i) ; 
 T3(i) <= C(6+8*i) XOR C(0+8*i) ; 
 T4(i) <= C(5+8*i) XNOR C(3+8*i) ; 
 T5(i) <= C(5+8*i) XNOR T1(i) ; 
 T6(i) <= C(5+8*i) XNOR C(1+8*i) ; 
 T7(i) <= C(4+8*i) XNOR T6(i) ; 
 T8(i) <= C(2+8*i) XOR T4(i) ; 
 T9(i) <= C(1+8*i) XOR T2(i) ; 
 D(7+8*i) <= T4(i) ; 
 D(6+8*i) <= T1(i) ; 
 D(5+8*i) <= T3(i) ; 
 D(4+8*i) <= T5(i) ; 
 D(3+8*i) <= T2(i) XOR T5(i) ; 
 D(2+8*i) <= T3(i) XOR T8(i) ; 
 D(1+8*i) <= T7(i) ; 
 D(0+8*i) <= T9(i) ; 
 --X(7) <= C(4) XNOR C(1) ; 
 --X(6) <= C(1) XOR T10 ; 
 --X(5) <= C(2) XOR T10 ; 
 --X(4) <= C(6) XNOR C(1) ; 
 --X(3) <= T8 XOR T9 ; 
 --X(2) <= C(7) XNOR T7 ; 
 --X(1) <= T6 ; 
 --X(0) <= NOT C(2) ; 
-- SELECT_NOT_8 sel_out( D, X, encrypt, Q );

end generate gen_sig;

Q <= not D;
 
end;