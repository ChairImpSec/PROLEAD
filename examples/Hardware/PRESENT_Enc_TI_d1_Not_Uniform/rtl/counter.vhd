----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:13:25 10/26/2012 
-- Design Name: 
-- Module Name:    counter - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity counter is
	generic ( NBITS : INTEGER := 4);
    Port ( clk : in  STD_LOGIC;
           en : in  STD_LOGIC;
           n_reset : in  STD_LOGIC;
           q : out  STD_LOGIC_VECTOR (NBITS-1 downto 0));
end counter;

architecture Behavioral of counter is

signal count : unsigned (NBITS-1 downto 0);

begin

process (clk, n_reset, en) 
begin
   if rising_edge(clk) then
      if n_reset='0' then 
         count <= (others => '0');
      elsif en='1' then
         count <= count + 1;
      end if;
   end if;
end process; 

	q <= std_logic_vector(count);

end Behavioral;

