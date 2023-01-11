library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library common;
use common.masked_aes_pkg.all;

entity stage4 is
    generic (
       order    : integer 
    );
    Port ( stage4In : in stage3OutType;
           random : in randomStage4((order+1)*(order+1) -1 downto 0);
           clk : in STD_LOGIC;
           stage4out : out stage4OutType);
end stage4;

architecture Behavioral of stage4 is
    type dim2 is array(order downto 0) of t_shared_gf2(order downto 0);
    signal gf2_mul_out1 : dim2;
    signal gf2_mul_out2 : dim2;
    signal scale_in : t_shared_gf2(order downto 0);
    signal scale_out : t_shared_gf2(order downto 0);
    signal inv_out : t_shared_gf2(order downto 0);
    
    type concatType is array(order downto 0) of t_shared_gf4(order downto 0);
    signal concat : concatType;
    signal refreshed : concatType;
    type regOutDim1 is array(order+2 downto 0) of STD_LOGIC_VECTOR(3 downto 0);-- +2 to pass the two 4 bit inputs for each order
    type regOutType is array(order downto 0) of regOutDim1;  
    signal regOut : regOutType;
    signal compressed : t_shared_gf4(order downto 0);
    
    type chainTypeDim1 is array(order+2 downto 0) of STD_LOGIC_VECTOR(3 downto 0);
    type chainTypeDim2 is array(order downto 0) of chainTypeDim1;
    signal chain : chainTypeDim2;

    attribute keep_hierarchy : string;
    attribute keep_hierarchy of Behavioral : architecture is "yes";    
begin

 protected_variant : if order > -1 generate
        -- Nonlinear Layer    
        -- inverter GF(2^2) (swaps the bits)
       inverters: for i in order downto 0 generate
            inverter: entity work.inverter port map (
                a   => stage4In(i)(7 downto 6),
                q   => inv_out(i)
            );
        end generate;
        
        -- GF(2^2) Mult 1   
        mulsI1: for i in order downto 0 generate
            mulJ1: for j in order downto 0 generate
                mul1: entity work.mul_gf2 generic map (N => 2) port map (
                    a   => stage4In(i)(9 downto 8),
                    b => inv_out(j),
                    q   => gf2_mul_out1(i)(j)
                );
            end generate;
        end generate;
        
        -- GF(2^2) Mult 2   
        mulsI2: for i in order downto 0 generate
            mulJ2: for j in order downto 0 generate
                mul2: entity work.mul_gf2 generic map (N => 2) port map (
                    a   => stage4In(i)(5 downto 4),
                    b => inv_out(j),
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
                    regOut(i)(0) <= stage4In(i)(3 downto 0);
                    regOut(i)(order+2) <= stage4In(i)(13 downto 10);
                    for j in order+1 downto 1 loop
                        regOut(i)(j) <= refreshed(i)(j-1); 
                    end loop;
                end loop;
            end if;
         end process stage2Proc;
         
        -- Compression
        compressionI: for i in 0 to order generate
            chain(i)(0) <= regOut(i)(1);
            compressed(i) <= chain(i)(order);
            compressionJ: for j in 0 to order-1 generate
                compr: entity work.xorBlock generic map ( N => 4) 
                port map (
                    a   => chain(i)(j),
                    b   => regOut(i)(j+2),
                    q   => chain(i)(j+1)
                ); 
            end generate;
        end generate;
        
       outputs: for i in order downto 0 generate
          stage4Out(i) <= regOut(i)(order+2) & compressed(i) & regOut(i)(0);
       end generate;  
    end generate;
end Behavioral;
