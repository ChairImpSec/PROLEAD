library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library common;
use common.masked_aes_pkg.all;

entity stage1 is
    generic (
       order    : integer
    );
    Port ( stage1In : in t_shared_gf8(order downto 0);
           clk : in STD_LOGIC;
           stage1Out : out t_shared_gf8(order downto 0)
    );
end stage1;

architecture Behavioral of stage1 is
    signal linMapOut : t_shared_gf8(order downto 0);
    
    attribute keep_hierarchy : string;
    attribute keep_hierarchy of Behavioral : architecture is "yes";    
begin

    unprotected_variant : if order = 0 generate
        -- Linear mapping at input from DOM source code
        input_mapping : entity work.linear_map2
        generic map (
            MATRIX_SEL => "X^-1")
        port map (
            DataInxDI  => stage1In(0),
            DataOutxDO => linMapOut(0)
        );
          
    --       -- Linear mapping at input from paper
    --       input_mapping : entity work.linear_map
    --         port map (
    --           a  => stage1In,
    --           q  => linMapOut
    --       );
    
        stage1Proc : process(clk) is begin
            if (rising_edge(clk)) then
                stage1Out <= linMapOut;
            end if;
        end process stage1Proc;
        
    end generate;
    
    protected_variant : if order > 0 generate
         generate_instances_g: for i in order downto 0 generate
            -- Linear mapping at input from DOM source code
            input_mapping : entity work.linear_map2
            generic map (
                MATRIX_SEL => "X^-1")
            port map (
                DataInxDI  => stage1In(i),
                DataOutxDO => linMapOut(i)
            );
            
            stage1Proc : process(clk) is begin
                if (rising_edge(clk)) then
                    stage1Out(i) <= linMapOut(i);
                end if;
            end process stage1Proc;       
         end generate;     
    end generate;

end Behavioral;
