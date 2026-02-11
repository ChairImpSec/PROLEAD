---------------------------------------------------------------------------
--
-- Copyright (C) 2016 Stiftung Secure Information and 
--                    Communication Technologies SIC and
--                    Graz University of Technology
-- Contact: http://opensource.iaik.tugraz.at
--
-- This file is part of AES DOM.
--
-- $BEGIN_LICENSE:DEFAULT$
-- Commercial License Usage
-- Licensees holding valid commercial licenses may use this file in
-- accordance with the commercial license agreement provided with the
-- Software or, alternatively, in accordance with the terms contained in
-- a written agreement between you and SIC. For further information
-- contact us at http://opensource.iaik.tugraz.at.
--
-- GNU General Public License Usage
-- Alternatively, this file may be used under the terms of the GNU
-- General Public License version 3.0 as published by the Free Software
-- Foundation and appearing in the file LICENSE.GPL included in the
-- packaging of this file.  Please review the following information to
-- ensure the GNU General Public License version 3.0 requirements will be
-- met: http://www.gnu.org/copyleft/gpl.html.
-- 
-- This software is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this software. If not, see http://www.gnu.org/licenses/.
--
-- $END_LICENSE:DEFAULT$
--
----------------------------------------------------------------------------
--       ### shared_mul.vhdl ###
--
--
-- Description:
-- Variants of masked\shared multipliers with varying number of shares
--   
--
-- Initial Version: Date: 27. October 2015 by Hannes Gross IAIK
--
------------------------------------------------------------------------------
library ieee;  use ieee.std_logic_1164.all;
               use work.masked_aes_pkg.all;

entity shared_mul_gf2 is
  generic (
    PIPELINED  : string  := "no";
    SHARES     : integer := 2
    );
  port (
    -- Clock and reset
    ClkxCI : in  std_logic;
    RstxBI : in  std_logic;
    -- Shares of X and Y
    XxDI   : in  t_shared_gf2(SHARES-1 downto 0);
    YxDI   : in  t_shared_gf2(SHARES-1 downto 0);
    -- Fresh masks
    ZxDI   : in  t_shared_gf2((SHARES*(SHARES-1)/2)-1 downto 0);
    -- Output Q = X*Y (+ Z)
    QxDO   : out t_shared_gf2(SHARES-1 downto 0)
    );
  constant NUM_MASKS : integer := SHARES*(SHARES-1)/2;
end shared_mul_gf2;

-------------------------------------------------------------------
architecture behavorial of shared_mul_gf2 is  
  -- Intermediates
  signal Xi_mul_Yj : t_shared_gf2(SHARES*SHARES-1 downto 0);
  
  -- Synchronization FF's
  signal FFxDN     : t_shared_gf2(SHARES*SHARES-1 downto 0);
  signal FFxDP     : t_shared_gf2(SHARES*SHARES-1 downto 0);
begin

  -------------------------------------------------------------------
  -- General stuff:
  -- Generate multipliers
  gen_inner_multipliers_g : for i in SHARES-1 downto 0 generate
    gen_outer_multipliers_g : for j in SHARES-1 downto 0 generate  
      gf2_mul : entity work.gf2_mul
        generic map (
          N => 2)
        port map (
          AxDI => XxDI(i),
          BxDI => YxDI(j),
          QxDO => Xi_mul_Yj(SHARES*i + j));
      end generate gen_outer_multipliers_g;
  end generate gen_inner_multipliers_g;

  -- purpose: Register process
  -- type   : sequential
  -- inputs : ClkxCI, RstxBI
  -- outputs: 
  register_proc_seq : process (ClkxCI, RstxBI) is
  begin  -- process register_proc_seq
    if RstxBI = '0' then                -- asynchronous reset (active low)
      for i in SHARES-1 downto 0 loop
        for j in SHARES-1 downto 0 loop
          FFxDP(SHARES*i + j) <= (others => '0');
        end loop; --j
      end loop; -- i
    elsif ClkxCI'event and ClkxCI = '1' then  -- rising clock edge
      for i in SHARES-1 downto 0 loop
        for j in SHARES-1 downto 0 loop
          FFxDP(SHARES*i + j) <= FFxDN(SHARES*i + j);
        end loop; --j
      end loop; -- i
    end if;
  end process register_proc_seq;

  ------------------------------------------------------------------
  -- Masked Multiplier Nth order secure for odd number of shares, pipelined
  odd_shares_pipelined : if ((SHARES mod 2) = 1) and (PIPELINED = "yes") generate
    -- purpose: implements the shared multiplication in a secure and generic way
    -- type   : combinational
    -- inputs : 
    -- outputs: 
    shared_mul_p : process (FFxDP, Xi_mul_Yj, ZxDI) is
      variable result : std_logic_vector(1 downto 0);
    begin  -- process odd_shared_mul_p
      -- iterate over shares
      for i in 0 to SHARES-1 loop
        result := (others => '0');
        for j in 0 to SHARES-1 loop
          -- Fi = Xi*Yi + SUM(...
          if (i = j) then
            FFxDN(SHARES*i + j) <= Xi_mul_Yj(SHARES*i + j);             -- domain term
          elsif (j > i) then
            FFxDN(SHARES*i + j) <= Xi_mul_Yj(SHARES*i + j) xor ZxDI(i + j*(j-1)/2);  -- regular term
          else
            FFxDN(SHARES*i + j) <= Xi_mul_Yj(SHARES*i + j) xor ZxDI(j + i*(i-1)/2);  -- transposed
          end if;
          -- Output
          result := result xor FFxDP(SHARES*i + j);
        end loop;  -- j     
        QxDO(i) <= result;
      end loop;  -- i
    end process shared_mul_p;
  end generate odd_shares_pipelined;

  -------------------------------------------------------------------
  -- Masked Multiplier Nth order secure for even number of shares, pipelined
  even_shares_pipelined : if ((SHARES mod 2) = 0) and (PIPELINED = "yes") generate
    -- purpose: implements the shared multiplication in a secure and generic way
    -- type   : combinational
    -- inputs : 
    -- outputs: 
    shared_mul_p : process (FFxDP, FFxDN, Xi_mul_Yj, ZxDI) is
      variable result : std_logic_vector(1 downto 0);
    begin  -- process odd_shared_mul_p
      -- iterate over shares
      for i in 0 to SHARES-1 loop
        result := (others => '0');
        for j in 0 to SHARES-1 loop
          -- Fi = Xi*Yi + SUM(...
          if (i = j) then
            FFxDN(SHARES*i + j) <= Xi_mul_Yj(SHARES*i + j);             -- domain term
          elsif (j > i) then
            FFxDN(SHARES*i + j) <= Xi_mul_Yj(SHARES*i + j) xor ZxDI(i + j*(j-1)/2);  -- regular term
          else
            FFxDN(SHARES*i + j) <= Xi_mul_Yj(SHARES*i + j) xor ZxDI(j + i*(i-1)/2);  -- transposed
          end if;
          -- Output
          result := result xor FFxDP(SHARES*i + j);
        end loop;  -- j
        QxDO(i) <= result;
      end loop;  -- i
    end process shared_mul_p;
  end generate even_shares_pipelined;

  -------------------------------------------------------------------
  -- Masked Multiplier Nth order secure for odd number of shares, pipelined
  odd_shares_not_pipelined : if ((SHARES mod 2) = 1) and (PIPELINED = "no") generate
    -- purpose: implements the shared multiplication in a secure and generic way
    -- type   : combinational
    -- inputs : 
    -- outputs: 
    shared_mul_p : process (FFxDN, FFxDP, Xi_mul_Yj, ZxDI) is
      variable result : std_logic_vector(1 downto 0);
    begin  -- process odd_shared_mul_p
      -- iterate over shares
      for i in 0 to SHARES-1 loop
        result := (others => '0');
        for j in 0 to SHARES-1 loop
          -- Fi = Xi*Yi + SUM(...
          if (i = j) then
            FFxDN(SHARES*i + j) <= Xi_mul_Yj(SHARES*i + j);             -- domain term
          elsif (j > i) then
            FFxDN(SHARES*i + j) <= Xi_mul_Yj(SHARES*i + j) xor ZxDI(i + j*(j-1)/2);  -- regular term
          else
            FFxDN(SHARES*i + j) <= Xi_mul_Yj(SHARES*i + j) xor ZxDI(j + i*(i-1)/2);  -- transposed
          end if;
          -- Output
          if (i = j) then
            result := result xor FFxDN(SHARES*i + j);
          else
            result := result xor FFxDP(SHARES*i + j);
          end if;
        end loop;  -- j
        QxDO(i) <= result;
      end loop;  -- i
    end process shared_mul_p;
  end generate odd_shares_not_pipelined;

  -------------------------------------------------------------------
  -- Masked Multiplier Nth order secure for even number of shares
  even_shares_not_pipelined : if ((SHARES mod 2) = 0) and (PIPELINED = "no") generate
    -- purpose: implements the shared multiplication in a secure and generic way
    -- type   : combinational
    -- inputs : 
    -- outputs: 
    shared_mul_p : process (FFxDN, FFxDP, Xi_mul_Yj, ZxDI)
      variable result : std_logic_vector(1 downto 0);
    begin  -- process odd_shared_mul_p
      -- iterate over shares
      for i in 0 to SHARES-1 loop
        result := (others => '0');
        for j in 0 to SHARES-1 loop
          -- Fi = Xi*Yi + SUM(...
          if (i = j) then
            FFxDN(SHARES*i + j) <= Xi_mul_Yj(SHARES*i + j);             -- domain term
          elsif (j > i) then
            FFxDN(SHARES*i + j) <= Xi_mul_Yj(SHARES*i + j) xor ZxDI(i + j*(j-1)/2);  -- regular term
          else
            FFxDN(SHARES*i + j) <= Xi_mul_Yj(SHARES*i + j) xor ZxDI(j + i*(i-1)/2);  -- transposed
          end if;
          -- Output
          if (i = j) then
            result := result xor FFxDN(SHARES*i + j);
          else
            result := result xor FFxDP(SHARES*i + j);
          end if;
        end loop;  -- j
        QxDO(i) <= result;
      end loop;  -- i
    end process shared_mul_p;
  end generate even_shares_not_pipelined;

end behavorial;
