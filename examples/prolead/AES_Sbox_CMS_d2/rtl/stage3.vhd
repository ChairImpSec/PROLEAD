library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library common;
use common.masked_aes_pkg.all;

entity stage3 is
    generic (
       order    : integer 
    );
    Port ( stage3In : in gf12;
           random : in randomStage3((order+1)*(order+1) -1 downto 0);
           clk : in STD_LOGIC;
           stage3Out : out stage3OutType
    );
end stage3;

architecture Behavioral of stage3 is    
    type dim2 is array(order downto 0) of t_shared_gf2(order downto 0);
    signal gf2_mul_out : dim2;
    signal scale_out : t_shared_gf2(order downto 0);
    signal scale_in : t_shared_gf2(order downto 0);
    
    signal refreshed : dim2;
    signal xorResult : dim2;
    type regOutDim1 is array(order+6 downto 0) of STD_LOGIC_VECTOR(1 downto 0);-- +6 to pass the 2x4 bit and 2x2 inputs for each order
    type regOutType is array(order downto 0) of regOutDim1;  
    signal regOut : regOutType;
    signal compressed : t_shared_gf2(order downto 0);
    
    type chainTypeDim1 is array(order+6 downto 0) of STD_LOGIC_VECTOR(1 downto 0);
    type chainTypeDim2 is array(order downto 0) of chainTypeDim1;
    signal chain : chainTypeDim2;
      
    attribute keep_hierarchy : string;
    attribute keep_hierarchy of Behavioral : architecture is "yes";    
begin
 protected_variant : if order > -1 generate
        -- Nonlinear Layer    
        scalers: for i in order downto 0 generate
            scale_in(i) <= stage3In(i)(7 downto 6)  xor stage3In(i)(5 downto 4);
            sqsc: entity work.scale port map (
                a   => scale_in(i),
                q   => scale_out(i)
            ); 
        end generate;
        
        mulsI: for i in order downto 0 generate
            mulJ: for j in order downto 0 generate
                mul1: entity work.mul_gf2 generic map (N => 2) port map (
                    a   => stage3In(i)(7 downto 6),
                    b => stage3In(j)(5 downto 4),
                    q   => gf2_mul_out(i)(j)
                );
            end generate;
        end generate;
        -- Linear Layer 
        xorsI: for i in order downto 0 generate
            xorsJ: for j in order downto 0 generate
                -- i and j equal -> create xor
                xors: if i = j generate
                    xorResult(i)(j) <=  gf2_mul_out(i)(i) xor scale_out(i);
                end generate;
                -- i and j unequal -> wire
                noXors1: if i /= j generate
                    xorResult(i)(j) <=  gf2_mul_out(i)(j);
                end generate;
            end generate;
        end generate;       
                            
       -- Refreshing
        -- ring refreshing for order != 1
        ringRefresh: if order > 1 generate                            
             refreshingI: for i in order downto 0 generate
                 refreshingJ: for j in order downto 0 generate
                     -- for 2nd order -> first index: 0,8,7,6,5,4,3,2,1 second index: 8,7,6,5,4,3,2,1,0
                     a: if i=0 and j = 0 generate
                         refreshed(i)(j) <=  xorResult(i)(j) xor random(0) xor random((order+1)*(order+1)-1);
                     end generate;
                     b: if i /= 0 or j /= 0 generate
                         refreshed(i)(j) <=  xorResult(i)(j) xor random((order+1)*(order+1)-1-i*(order+1)-j+1) xor random((order+1)*(order+1)-1-i*(order+1)-j);
                     end generate;                       
                 end generate;            
             end generate;
         end generate;
         -- 1st order optimization additive refreshing
         additiveRefresh: if order = 1 generate                    
             refreshed(0)(0) <=  xorResult(0)(0) xor random(0);
             refreshed(0)(1) <=  xorResult(0)(1) xor random(1);
             refreshed(1)(0) <=  xorResult(1)(0) xor random(2);
             refreshed(1)(1) <=  xorResult(1)(1) xor random(0) xor random (1) xor random(2);  -- (cf. Paper, Fig. 4), random(3) is not used
          end generate;
          noRefresh: if order = 0 generate                    
              refreshed(0)(0) <=  xorResult(0)(0);
          end generate;

         -- Register
         stage2Proc : process(clk) is begin
            if (rising_edge(clk)) then 
                for i in order downto 0 loop
                    --stage3Out <= stage3In(11 downto 8) & stage3In(7 downto 6) & xorResult & stage3In(5 downto 4) & stage3In(3 downto 0);
                    regOut(i)(0) <= stage3In(i)(1 downto 0);
                    regOut(i)(1) <= stage3In(i)(3 downto 2);
                    regOut(i)(2) <= stage3In(i)(5 downto 4);
                    regOut(i)(order+6) <= stage3In(i)(11 downto 10);
                    regOut(i)(order+5) <= stage3In(i)(9 downto 8);
                    regOut(i)(order+4) <= stage3In(i)(7 downto 6);
                    for j in order+3 downto 3 loop
                        regOut(i)(j) <= refreshed(i)(j-3); 
                    end loop;
                end loop;
            end if;
         end process stage2Proc;
        -- Compression     
        compressionI: for i in 0 to order generate
            chain(i)(0) <= regOut(i)(3);
            compressed(i) <= chain(i)(order);
            compressionJ: for j in 0 to order-1 generate
                compr: entity work.xorBlock generic map ( N => 2) 
                port map (
                    a   => chain(i)(j),
                    b   => regOut(i)(j+4),
                    q   => chain(i)(j+1)
                ); 
            end generate;
        end generate;
        
       outputs: for i in order downto 0 generate
          stage3Out(i) <= regOut(i)(order+6) & regOut(i)(order+5) & regOut(i)(order+4) & compressed(i) & regOut(i)(2) & regOut(i)(1) & regOut(i)(0);
       end generate;

       
    end generate;

end Behavioral;
