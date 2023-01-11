library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity lin_map is
generic(SHARES : INTEGER :=3 );
port (
	A : in std_logic_vector(8*SHARES-1 downto 0); 
	Z : out std_logic_vector(8*SHARES-1 downto 0)
	);
end lin_map;

architecture dfl of lin_map is

signal A1,A2,A3,B1,B2,B3: std_logic_Vector(7 downto 0);
signal R11, R21, R31, R41, R51, R61, R71, R81, R91 :std_logic; 
signal R12, R22, R32, R42, R52, R62, R72, R82, R92 :std_logic; 
signal R13, R23, R33, R43, R53, R63, R73, R83, R93 :std_logic; 

begin

--gen_sig:
--For i in 0 to SHARES-1 generate

-- R1(i) <= A(7+8*i) XOR A(5+8*i) ; 
-- R2(i) <= A(7+8*i) XNOR A(4+8*i) ; 
-- R3(i) <= A(6+8*i) XOR A(0+8*i) ; 
-- R4(i) <= A(5+8*i) XNOR R3(i) ; 
-- R5(i) <= A(4+8*i) XOR R4(i) ; 
-- R6(i) <= A(3+8*i) XOR A(0+8*i) ; 
-- R7(i) <= A(2+8*i) XOR R1(i) ; 
-- R8(i) <= A(1+8*i) XOR R3(i) ; 
-- R9(i) <= A(3+8*i) XOR R8(i) ; 
 
-- B(7+8*i) <= R7(i) XNOR R8(i) ; 
-- B(6+8*i) <= R5(i) ; 
-- B(5+8*i) <= A(1+8*i) XOR R4(i) ; 
-- B(4+8*i) <= R1(i) XNOR R3(i) ; 
-- B(3+8*i) <= A(1) XOR R2(i) XOR R6(i) ; 
-- B(2+8*i) <= NOT A(0+8*i) ; 
-- B(1+8*i) <= R4(i) ; 
-- B(0+8*i) <= A(2+8*i) XNOR R9(i) ; 

 --Y(7) <= R2 ; 
-- Y(6) <= A(4) XOR R8 ; 
-- Y(5) <= A(6) XOR A(4) ; 
-- Y(4) <= R9 ; 
-- Y(3) <= A(6) XNOR R2 ; 
-- Y(2) <= R7 ; 
-- Y(1) <= A(4) XOR R6 ; 
-- Y(0) <= A(1) XOR R5 ; 
-- SELECT_NOT_8 sel_in( B, Y, encrypt, Z ); 
--end generate gen_sig;

A1 <= A(23 downto 16);
A2 <= A(15 downto 8);
A3 <= A(7 downto 0);

 R11 <= A1(7) XOR A1(5) ; 
 R21 <= A1(7) XNOR A1(4) ; 
 R31 <= A1(6) XOR A1(0) ; 
 R41 <= A1(5) XNOR R31 ; 
 R51 <= A1(4) XOR R41 ; 
 R61 <= A1(3) XOR A1(0) ; 
 R71 <= A1(2) XOR R11 ; 
 R81 <= A1(1) XOR R31 ; 
 R91 <= A1(3) XOR R81 ; 
 
 B1(7) <= R71 XNOR R81 ; 
 B1(6) <= R51 ; 
 B1(5) <= A1(1) XOR R41 ; 
 B1(4) <= R11 XNOR R31 ; 
 B1(3) <= A1(1) XOR R21 XOR R61 ; 
 B1(2) <= NOT A1(0) ; 
 B1(1) <= R41 ; 
 B1(0) <= A1(2) XNOR R91 ; 

 R12 <= A2(7) XOR A2(5) ; 
 R22 <= A2(7) XNOR A2(4) ; 
 R32 <= A2(6) XOR A2(0) ; 
 R42 <= A2(5) XNOR R32 ; 
 R52 <= A2(4) XOR R42 ; 
 R62 <= A2(3) XOR A2(0) ; 
 R72 <= A2(2) XOR R12 ; 
 R82 <= A2(1) XOR R32 ; 
 R92 <= A2(3) XOR R82 ; 
 
 B2(7) <= R72 XNOR R82 ; 
 B2(6) <= R52 ; 
 B2(5) <= A2(1) XOR R42 ; 
 B2(4) <= R12 XNOR R32 ; 
 B2(3) <= A2(1) XOR R22 XOR R62 ; 
 B2(2) <= NOT A2(0) ; 
 B2(1) <= R42 ; 
 B2(0) <= A2(2) XNOR R92 ; 


 R13 <= A3(7) XOR A3(5) ; 
 R23 <= A3(7) XNOR A3(4) ; 
 R33 <= A3(6) XOR A3(0) ; 
 R43 <= A3(5) XNOR R33 ; 
 R53 <= A3(4) XOR R43 ; 
 R63 <= A3(3) XOR A3(0) ; 
 R73 <= A3(2) XOR R13 ; 
 R83 <= A3(1) XOR R33 ; 
 R93 <= A3(3) XOR R83 ; 
 
 B3(7) <= R73 XNOR R83 ; 
 B3(6) <= R53 ; 
 B3(5) <= A3(1) XOR R43 ; 
 B3(4) <= R13 XNOR R33 ; 
 B3(3) <= A3(1) XOR R23 XOR R63 ; 
 B3(2) <= NOT A3(0) ; 
 B3(1) <= R43 ; 
 B3(0) <= A3(2) XNOR R93 ; 

Z <= not (B1&B2&B3);

end;