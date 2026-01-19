library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library common;
use common.masked_aes_pkg.all;

entity stage5 is
    generic (
       order    : integer
    );
    Port ( stage5In : in stage4OutType;
           random : in randomStage5((order+1)*(order+1) -1 downto 0);
           clk : in STD_LOGIC;
           stage5Out : out stage5OutType 
    );
end stage5;

architecture Behavioral of stage5 is
 
    type dim2 is array(order downto 0) of t_shared_gf4(order downto 0);
    signal gf2_mul_out1 : dim2;
    signal gf2_mul_out2 : dim2;
    
    type concatType is array(order downto 0) of t_shared_gf8(order downto 0);
    signal concat : concatType;
    signal refreshed : concatType; 
    signal regOut : concatType;
    signal compressed : t_shared_gf8(order downto 0);
    
    type chainTypeDim1 is array(order+2 downto 0) of STD_LOGIC_VECTOR(7 downto 0);
    type chainTypeDim2 is array(order downto 0) of chainTypeDim1;
    signal chain : chainTypeDim2;
    
    attribute keep_hierarchy : string;
    attribute keep_hierarchy of Behavioral : architecture is "yes";    
begin
 protected_variant : if order > -1 generate
        -- Nonlinear Layer           
        -- GF(2^2) Mult 1   
        mulsI1: for i in order downto 0 generate
            mulJ1: for j in order downto 0 generate
                mul1: entity work.mul_gf2 generic map (N => 4) port map (
                    a   => stage5In(i)(11 downto 8),
                    b   => stage5In(j)(7 downto 4),
                    q   => gf2_mul_out1(i)(j)
                );
            end generate;
        end generate;
        
        -- GF(2^2) Mult 2   
        mulsI2: for i in order downto 0 generate
            mulJ2: for j in order downto 0 generate
                mul2: entity work.mul_gf2 generic map (N => 4) port map (
                    a   => stage5In(i)(7 downto 4),
                    b => stage5In(j)(3 downto 0),
                    q   => gf2_mul_out2(i)(j)
                );
            end generate;
        end generate;
       
        -- Linear Layer 
        --concatenation
        concatI: for i in order downto 0 generate
            concatJ: for j in order downto 0 generate
                concat(i)(j)    <=  gf2_mul_out2(i)(j) & gf2_mul_out1(i)(j);
            end generate;
        end generate;                          
        
        -- Refreshing
        -- ring refreshing for order != 1
        ringRefresh: if order > 1 generate                            
            refreshingI: for i in order downto 0 generate
              refreshingJ: for j in order downto 0 generate
                  -- for 2nd order -> first index: 0,8,7,6,5,4,3,2,1 second index: 8,7,6,5,4,3,2,1,0
                  a: if i=0 and j = 0 generate
                      refreshed(i)(j) <=  concat(i)(j) xor random(0) xor random((order+1)*(order+1)-1);
                  end generate;
                  b: if i /= 0 or j /= 0 generate
                      refreshed(i)(j) <=  concat(i)(j) xor random((order+1)*(order+1)-1-i*(order+1)-j+1) xor random((order+1)*(order+1)-1-i*(order+1)-j);
                  end generate;                       
              end generate;            
            end generate;
        end generate;
        -- 1st order optimization additive refreshing
        additiveRefresh: if order = 1 generate                    
            refreshed(0)(0) <=  concat(0)(0) xor random(0);
            refreshed(0)(1) <=  concat(0)(1) xor random(1);
            refreshed(1)(0) <=  concat(1)(0) xor random(2);
            refreshed(1)(1) <=  concat(1)(1) xor random(0) xor random (1) xor random(2);  -- (cf. Paper, Fig. 4), random(3) is not used
         end generate;
         noRefresh: if order = 0 generate                    
             refreshed(0)(0) <=  concat(0)(0);
         end generate;
       
         -- Register
         stage2Proc : process(clk) is begin
            if (rising_edge(clk)) then 
                for i in order downto 0 loop
                    for j in order downto 0 loop
                        regOut(i)(j) <= refreshed(i)(j); 
                    end loop;
                end loop;
            end if;
         end process stage2Proc;
         
        -- Compression
        compressionI: for i in 0 to order generate
            chain(i)(0) <= regOut(i)(0);
            compressed(i) <= chain(i)(order);
            compressionJ: for j in 0 to order-1 generate
                compr: entity work.xorBlock generic map ( N => 8) 
                port map (
                    a   => chain(i)(j),
                    b   => regOut(i)(j+1),
                    q   => chain(i)(j+1)
                ); 
            end generate;
        end generate;
        
       outputs: for i in order downto 0 generate
          stage5Out(i) <= compressed(i);
       end generate;

       
    end generate;


end Behavioral;
