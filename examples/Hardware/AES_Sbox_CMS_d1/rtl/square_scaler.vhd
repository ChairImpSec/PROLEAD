library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity square_scaler is
    Port ( a : in STD_LOGIC_VECTOR (3 downto 0);
           q : out STD_LOGIC_VECTOR (3 downto 0));
end square_scaler;

architecture Behavioral of square_scaler is
signal square_in1 : STD_LOGIC_VECTOR(1 downto 0);
signal square_out1 : STD_LOGIC_VECTOR(1 downto 0);
signal square_out2 : STD_LOGIC_VECTOR(1 downto 0);

signal scale_out : STD_LOGIC_VECTOR(1 downto 0);
begin
-- square & scale by nu in GF(2^4)/GF(2^2), normal basis (alpha^8,alpha^2) 
-- nu = beta^8 = N^2*alpha^2, N = w^2 

--    -- square1 (GF2 squaring is the same as inverting)
--    square_in1 <= a(3 downto 2) xor a(1 downto 0);
--    square1: entity work.inverter port map (
--        a => square_in1,
--        q => square_out1
--    );
    
--    -- square2 (GF2 squaring is the same as inverting)
--    square2: entity work.inverter port map (
--        a => a(1 downto 0),
--        q => square_out2
--    );
    
--    -- scale by w^2 = Omega^2 in GF(2^2), using normal basis [Omega^2,Omega]  
--    square_scale_gf2: entity work.square_scaler_gf2 port map (
--        a => square_out2,
--        q => scale_out
--    );    
--    q   <=  square_out1 & scale_out;
    
    -- todo: is this the same, but better?
    q(3) <= a(0) xor a(2);
    q(2) <= a(1) xor a(3);    
    q(1) <= a(1) xor a(0);
    q(0) <= a(0);

end Behavioral;
