library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mul_gf2 is
    generic (
        N    : integer := 1
    );
    Port ( a : in STD_LOGIC_VECTOR (N-1 downto 0);
           b : in STD_LOGIC_VECTOR (N-1  downto 0);
           q : out STD_LOGIC_VECTOR (N-1 downto 0));
end mul_gf2;

architecture Behavioral of mul_gf2 is

begin
    -- 1 Bit
    gf2_1: if N = 1 generate
        q(0) <= a(0) and b(0);
    end generate gf2_1;

    -- 2 Bit
    gf2_2: if N = 2 generate
        q(0) <= ((a(1) xor a(0)) and (b(1) xor b(0))) xor (a(0) and b(0));
        q(1) <= ((a(1) xor a(0)) and (b(1) xor b(0))) xor (a(1) and b(1));
    end generate gf2_2;
    
    -- 4 Bit
  gf2_3: if N = 4 generate
      gf2_3_mul: process (a, b) is
        variable PH     : std_logic_vector(1 downto 0); --  PH
        variable PL     : std_logic_vector(1 downto 0); --  PL
        variable P      : std_logic_vector(1 downto 0); --  P
        variable AA     : std_logic_vector(1 downto 0); --  AA
        variable BB     : std_logic_vector(1 downto 0); --  BB
      begin  -- process gf2_1_mul
        -- Canright:
        -- HI MUL GF2^4 multiplier
        PH(0) := ((A(3) xor A(2)) and (B(3) xor B(2))) xor (A(2) and B(2));
        PH(1) := ((A(3) xor A(2)) and (B(3) xor B(2))) xor (A(3) and B(3));
        
        -- LO MUL GF2^4 multiplier
        PL(0) := ((A(1) xor A(0)) and (B(1) xor B(0))) xor (A(0) and B(0));
        PL(1) := ((A(1) xor A(0)) and (B(1) xor B(0))) xor (A(1) and B(1));
  
        -- MUL and SQUARE SCALE
        AA := (A(3) & A(2)) xor (A(1) & A(0));
        BB := (B(3) & B(2)) xor (B(1) & B(0));
        
        P(1) := ((AA(1) xor AA(0)) and (BB(1) xor BB(0))) xor (AA(0) and BB(0));
        P(0) := ((AA(1) xor AA(0)) and (BB(1) xor BB(0))) xor (AA(1) and BB(1)) xor P(1);
  
       -- Output assignment
        q <= (PH xor P) & (PL xor P);
                
      end process gf2_3_mul;
    end generate gf2_3;


end Behavioral;
