library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity s_GF_MULS_2 is
generic (SHARES : integer :=3);
port(
	A : in  std_logic_vector(2*SHARES-1 downto 0);
	B : in  std_logic_vector(2*SHARES-1 downto 0);
	Q : out std_logic_vector(2*SHARES-1 downto 0)
	);
end s_GF_MULS_2;

architecture DFL of s_GF_MULS_2 is

signal a1,a2,a3,b1,b2,b3 : std_logic; --input A
signal c1,c2,c3,d1,d2,d3 : std_logic; --input B

signal e1,e2,e3,f1,f2,f3 : std_logic;
signal ce1,ce2,ce3,cf1,cf2,cf3 : std_logic;
signal e1ce1,e2ce2,e3ce3,f1cf1,f2cf2,f3cf3 : std_logic;

--signal sumce, sumcf : std_logic;

--signal d : std_logic_vector(2*SHARES-1 downto 0);

begin

---------------------------------------------------------------------------
-- input mapping
-- (A(5 dwonto 0),B(5 downto 0) = (d3,c3,d2,c2,d1,c1,b3,a3,b2,a2,b1,a1)
---------------------------------------------------------------------------

--Input A
--share 1
d3 <= A(5); 
c3 <= A(4);
--share 2
d2 <= A(3);
c2 <= A(2); 
--share 3
d1 <= A(1);
c1 <= A(0);

--Inbut B
--share 1
b3 <= B(5); 
a3 <= B(4);
--share 2
b2 <= B(3);
a2 <= B(2); 
--share 3
b1 <= B(1);
a1 <= B(0);

---------------------------------------------------------------------------
-- taken from Nikova et al ICISC08
-- fixed Terms 
---------------------------------------------------------------------------
e1 <= (a2 AND d2) XOR (a2 AND d3) XOR (a3 AND d2) XOR (b2 AND c2) XOR (b2 AND c3) XOR (b3 AND c2) XOR (b2 AND d2) XOR (b2 AND d3) XOR (b3 AND d2);
f1 <= (a2 AND c2) XOR (a2 AND c3) XOR (a3 AND c2) XOR (a2 AND d2) XOR (a2 AND d3) XOR (a3 AND d2) XOR (b2 AND c2) XOR (b2 AND c3) XOR (b3 AND c2);
e2 <= (a1 AND d3) XOR (a3 AND d1) XOR (a3 AND d3) XOR (b1 AND c3) XOR (b3 AND c1) XOR (b3 AND c3) XOR (b1 AND d3) XOR (b3 AND d1) XOR (b3 AND d3);
f2 <= (a1 AND c3) XOR (a3 AND c1) XOR (a3 AND c3) XOR (a1 AND d3) XOR (a3 AND d1) XOR (a3 AND d3) XOR (b1 AND c3) XOR (b3 AND c1) XOR (b3 AND c3);
e3 <= (a1 AND d1) XOR (a1 AND d2) XOR (a2 AND d1) XOR (b1 AND c1) XOR (b1 AND c2) XOR (b2 AND c1) XOR (b1 AND d1) XOR (b1 AND d2) XOR (b2 AND d1);
f3 <= (a1 AND c1) XOR (a1 AND c2) XOR (a2 AND c1) XOR (a1 AND d1) XOR (a1 AND d2) XOR (a2 AND d1) XOR (b1 AND c1) XOR (b1 AND c2) XOR (b2 AND c1);

---------------------------------------------------------------------------
-- Correction Terms
---------------------------------------------------------------------------
ce1 <= a3 XOR (b2 AND c2) XOR (b3 AND c3) XOR (a2 AND c2);
ce2 <= a1 XOR (a3) XOR (d1) XOR (b1 AND c1) XOR (b3 AND c3) XOR (a1 AND d1);
ce3 <= a1 XOR (d1) XOR (b1 AND c1) XOR (b2 AND c2) XOR (a2 AND c2) XOR (a1 AND d1);
cf1 <= c3 XOR (d3) XOR (a2 AND c2) XOR (a3 AND c3) XOR (b2 AND d2) XOR (b3 AND d3);
cf2 <= c3 XOR (d1) XOR (d3) XOR (a3 AND c3) XOR (b1 AND d1) XOR (b3 AND d3);
cf3 <= d1 XOR (a2 AND c2) XOR (b1 AND d1) XOR (b2 AND d2);

--sumce <= ce1 XOR ce2 XOR ce3;
--sumcf <= cf1 XOR cf2 XOR cf3;

---------------------------------------------------------------------------
-- output mapping
-- x(0 to 3) = (A,B) = (a,b,c,d)
-- x(0 to 11) = (B(0 to 5),A(0 to 5) = (a1,a2,a3,b1,b2,b3,c1,c2,c3,d1,d2,d3)
-- (A(5 dwonto 0),B(5 downto 0) = (d3,c3,d2,c2,d1,c1,b3,a3,b2,a2,b1,a1)
-- Q(0 to 1) = (e,f)
-- Q(0 to 5) = (e1,e2,e3,f1,f2,f3)
-- Q(5 downto 0) = (f3,e3,f2,e2,f1,e1)
---------------------------------------------------------------------------
f3cf3 <= f3 XOR cf3;
e3ce3 <= e3 XOR ce3;
f2cf2 <= f2 XOR cf2;
e2ce2 <= e2 XOR ce2;
f1cf1 <= f1 XOR cf1;
e1ce1 <= e1 XOR ce1;

Q <= f3cf3&e3ce3&f2cf2&e2ce2&f1cf1&e1ce1;
--Q <= (f3 XOR cf3)&(e3 XOR ce3)&(f2 XOR cf2)&(e2 XOR ce2)&(f1 XOR cf1)&(e1 XOR ce1);

end;
