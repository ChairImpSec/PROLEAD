library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library common;
use common.masked_aes_pkg.all;

entity stage2 is
    generic (
           order        : integer 
    );
    Port ( stage2In     : in t_shared_gf8(order downto 0);  -- 8, 16, 24, ... Bits
           random       : in randomStage2((order+1)*(order+1) -1 downto 0);                  -- 12 bits random per order
           clk          : in STD_LOGIC;
           stage2Out    : out gf12                          --  12, 32, 60, ... Bits
    );     
end stage2;

architecture Behavioral of stage2 is
    type dim2 is array(order downto 0) of t_shared_gf4(order downto 0);
    signal gf2_mul_out : dim2;
    signal sqsc_out : t_shared_gf4(order downto 0);
    signal sqsc_in : t_shared_gf4(order downto 0);
    
    signal refreshed : dim2;
    signal xorResult : dim2;
    type regOutDim1 is array(order+2 downto 0) of STD_LOGIC_VECTOR(3 downto 0);-- +2 to pass the two 4 bit inputs for each order
    type regOutType is array(order downto 0) of regOutDim1;  
    signal regOut : regOutType;
    signal compressed : t_shared_gf4(order downto 0);
    
    type chainTypeDim1 is array(order+2 downto 0) of STD_LOGIC_VECTOR(3 downto 0);
    type chainTypeDim2 is array(order downto 0) of chainTypeDim1;
    signal chain : chainTypeDim2;
    
    function indexCalc1 return integer is
      variable lastIndex1   : integer := -1;
    begin
        lastindex1 := lastindex1 + 1;
        return lastIndex1;
    end function;
    function indexCalc2 return integer is
      variable lastIndex2   : integer := (order+1)*(order+1);
    begin
        lastindex2 := lastindex2 - 1;
        return lastIndex2;
    end function;
    
    attribute keep_hierarchy : string;
    attribute keep_hierarchy of Behavioral : architecture is "yes";    
begin

    protected_variant : if order > -1 generate
        -- Nonlinear Layer    
        scalers: for i in order downto 0 generate
            sqsc_in(i) <= stage2In(i)(7 downto 4)  xor stage2In(i)(3 downto 0);
            sqsc: entity work.square_scaler port map (
                a   => sqsc_in(i),
                q   => sqsc_out(i)
            ); 
        end generate;
        
        mulsI: for i in order downto 0 generate
            mulJ: for j in order downto 0 generate
                mul1: entity work.mul_gf2 generic map (N => 4) port map (
                    a   => stage2In(i)(7 downto 4),
                    b => stage2In(j)(3 downto 0),
                    q   => gf2_mul_out(i)(j)
                );
            end generate;
        end generate;
        -- Linear Layer 
        xorsI: for i in order downto 0 generate
            xorsJ: for j in order downto 0 generate
                -- i and j equal -> create xor
                xors: if i = j generate
                    xorResult(i)(j) <=  gf2_mul_out(i)(i) xor sqsc_out(i);
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
                    regOut(i)(0) <= stage2In(i)(3 downto 0);
                    regOut(i)(order+2) <= stage2In(i)(7 downto 4);
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
          stage2Out(i) <= regOut(i)(order+2) & compressed(i) & regOut(i)(0);
       end generate;

       
    end generate;
end Behavioral;