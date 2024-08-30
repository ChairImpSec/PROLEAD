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
--       ### inverter.vhdl ###
--
--
-- Description:
-- 
--   
--
-- Initial Version: Date: 9. October 2015 by Hannes Gross IAIK
--
------------------------------------------------------------------------------
library ieee;  use ieee.std_logic_1164.all;
               use work.masked_aes_pkg.all;
                   
entity inverter is
  generic (
    VARIANT           : string  := "Masked";
    PIPELINED         : string  := "yes";
    --- Only for pipelined variant
    EIGHT_STAGED_SBOX : string  := "yes";
    SHARES            : integer := 2
    );
  port (
    ClkxCI   : in  std_logic;
    RstxBI   : in  std_logic;
    -- Masked input
    XxDI     : in  t_shared_gf4(SHARES-1 downto 0);
    -- Fresh masks
    Zmul1xDI : in  t_shared_gf2((SHARES*(SHARES-1)/2)-1 downto 0);
    Zmul2xDI : in  t_shared_gf2((SHARES*(SHARES-1)/2)-1 downto 0);
    Zmul3xDI : in  t_shared_gf2((SHARES*(SHARES-1)/2)-1 downto 0);
    Bmul1xDI : in  t_shared_gf2(SHARES-1 downto 0);
    Bmul2xDI : in  t_shared_gf2(SHARES-1 downto 0);
    Bmul3xDI : in  t_shared_gf2(SHARES-1 downto 0);
    -- Outputs
    QxDO     : out t_shared_gf4(SHARES-1 downto 0)
  );
end inverter;

-------------------------------------------------------------------

architecture behavorial of inverter is
  -- Shares
  signal A             : t_shared_gf2(SHARES-1 downto 0);  -- MSBits of input
  signal B             : t_shared_gf2(SHARES-1 downto 0);  -- LSBits of input
  -- Intermediates
  signal AmulBxD       : t_shared_gf2(SHARES-1 downto 0);  -- A x B
  signal AmulExD       : t_shared_gf2(SHARES-1 downto 0);  -- A x E
  signal BmulExD       : t_shared_gf2(SHARES-1 downto 0);  -- B x E
  signal ExD           : t_shared_gf2(SHARES-1 downto 0);  -- E
  signal CxD           : t_shared_gf2(SHARES-1 downto 0);  -- C
  -- Pipelining
  signal AxDP          : t_shared_gf2(SHARES-1 downto 0);  -- MSBits
  signal BxDP          : t_shared_gf2(SHARES-1 downto 0);  -- LSBits
  signal CxDP          : t_shared_gf2(SHARES-1 downto 0);  -- C

  -- For 8 staged Sbox only
  signal pipelinedAxDP : t_shared_gf2(SHARES-1 downto 0);  -- MSBits
  signal pipelinedBxDP : t_shared_gf2(SHARES-1 downto 0);  -- LSBits
  signal ExDP          : t_shared_gf2(SHARES-1 downto 0);  -- E pipl.                                           
  begin
    ---------------------------------------------------------------
    -- General
    define_a_and_b_aliases_p: process (XxDI) is
    begin  -- process define_a_and_b_aliases_p
      -- iterate over shares
      for i in 0 to SHARES-1 loop
        A(i) <=  XxDI(i)(3 downto 2); --split GF2^4 element in two GF2^2
        B(i) <=  XxDI(i)(1 downto 0);
      end loop;  -- i
    end process define_a_and_b_aliases_p;
    ---------------------------------------------------------------
    -- Masked Inverter for 8 staged Sbox
    shared_sel_pipelined_4staged: if VARIANT = "Masked" and PIPELINED = "yes" and EIGHT_STAGED_SBOX = "yes" generate

      pipeline_p: process (ClkxCI, RstxBI) is
      begin  -- process pipeline_p
        if RstxBI = '0' then            -- asynchronous reset (active low)  
          -- iterate over shares
          for i in 0 to SHARES-1 loop
            AxDP(i)          <= (others => '0');
            BxDP(i)          <= (others => '0');
            CxDP(i)          <= (others => '0');
            ExDP(i)          <= (others => '0');
            pipelinedAxDP(i) <= (others => '0');
            pipelinedBxDP(i) <= (others => '0');
          end loop;  --i
        elsif ClkxCI'event and ClkxCI = '1' then  -- rising clock edge
          -- iterate over shares
          for i in 0 to SHARES-1 loop
            AxDP(i)          <= A(i);
            BxDP(i)          <= B(i);
            CxDP(i)          <= CxD(i);
            ExDP(i)          <= ExD(i);
            pipelinedAxDP(i) <= AxDP(i);
            pipelinedBxDP(i) <= BxDP(i);
          end loop;  --i
        end if;
      end process pipeline_p;
      
      invert_p: process (XxDI, A, B, AmulBxD, AmulExD, BmulExD, ExD, CxDP) is
        variable d, dm : t_shared_gf2(SHARES-1 downto 0); -- temp     
      begin  -- process invert_p
        -- iterate over shares
        for i in 0 to SHARES-1 loop
          -- xor and ^2  
          d(i)    := (A(i)(0) xor B(i)(0)) & (A(i)(1) xor B(i)(1));
          -- scale
          CxD(i)  <= d(i)(0) & (d(i)(1) xor d(i)(0));
          --(c + d)^2
          ExD(i)  <= (CxDP(i)(0) xor AmulBxD(i)(0)) & (CxDP(i)(1) xor AmulBxD(i)(1));
          -- Output  
          QxDO(i) <= BmulExD(i) & AmulExD(i);
        end loop;  -- i
      end process invert_p;             
      
      -- Multipliers
      a_mul_b : entity work.shared_mul_gf2
        generic map (
          PIPELINED                => PIPELINED,
          SHARES                   => SHARES)
        port map (
          ClkxCI => ClkxCI,
          RstxBI => RstxBI,
          XxDI   => A,
          YxDI   => B,
          ZxDI   => Zmul1xDI,
          QxDO   => AmulBxD);

      a_mul_e : entity work.shared_mul_gf2
        generic map (
          PIPELINED                => PIPELINED,
          SHARES                   => SHARES)
        port map (
          ClkxCI => ClkxCI,
          RstxBI => RstxBI,
          XxDI   => pipelinedAxDP,
          YxDI   => ExDP,
          ZxDI   => Zmul2xDI,
          QxDO   => AmulExD);

      b_mul_e : entity work.shared_mul_gf2
        generic map (
          PIPELINED                => PIPELINED,
          SHARES                   => SHARES)
        port map (
          ClkxCI => ClkxCI,
          RstxBI => RstxBI,
          XxDI   => pipelinedBxDP,
          YxDI   => ExDP,
          ZxDI   => Zmul3xDI,
          QxDO   => BmulExD);

    end generate shared_sel_pipelined_4staged;
    
    ---------------------------------------------------------------
    -- Masked Inverter for 5 staged Sbox
    shared_sel_pipelined: if VARIANT = "Masked" and PIPELINED = "yes" and EIGHT_STAGED_SBOX = "no" generate

      pipeline_p: process (ClkxCI, RstxBI) is
      begin  -- process pipeline_p
        if RstxBI = '0' then            -- asynchronous reset (active low)  
          -- iterate over shares
          for i in 0 to SHARES-1 loop
            AxDP(i) <= (others => '0');
            BxDP(i) <= (others => '0');
            CxDP(i) <= (others => '0');
          end loop;  --i
        elsif ClkxCI'event and ClkxCI = '1' then  -- rising clock edge
          -- iterate over shares
          for i in 0 to SHARES-1 loop
            AxDP(i) <= A(i);
            BxDP(i) <= B(i);
            CxDP(i) <= CxD(i);
          end loop;  --i
        end if;
      end process pipeline_p;
      
      invert_p: process (XxDI, A, B, AmulBxD, AmulExD, BmulExD, ExD, CxDP) is
        variable d, dm : t_shared_gf2(SHARES-1 downto 0); -- temp     
      begin  -- process invert_p
        -- iterate over shares
        for i in 0 to SHARES-1 loop
          -- xor and ^2  
          d(i)    := (A(i)(0) xor B(i)(0)) & (A(i)(1) xor B(i)(1));
          -- scale
          CxD(i)  <= d(i)(0) & (d(i)(1) xor d(i)(0));
          --(c + d)^2
          ExD(i)  <= (CxDP(i)(0) xor AmulBxD(i)(0)) & (CxDP(i)(1) xor AmulBxD(i)(1));
          -- Output  
          QxDO(i) <= BmulExD(i) & AmulExD(i);
        end loop;  -- i
      end process invert_p;             
      
      -- Multipliers
      a_mul_b : entity work.real_dom_shared_mul_gf2
        generic map (
          PIPELINED                => PIPELINED,
          FIRST_ORDER_OPTIMIZATION => "yes",
          SHARES                   => SHARES)
        port map (
          ClkxCI => ClkxCI,
          RstxBI => RstxBI,
          XxDI   => A,
          YxDI   => B,
          ZxDI   => Zmul1xDI,
          BxDI   => Bmul1xDI,
          QxDO   => AmulBxD);

      a_mul_e : entity work.real_dom_shared_mul_gf2
        generic map (
          PIPELINED                => PIPELINED,
          FIRST_ORDER_OPTIMIZATION => "yes",
          SHARES                   => SHARES)
        port map (
          ClkxCI => ClkxCI,
          RstxBI => RstxBI,
          XxDI   => AxDP,
          YxDI   => ExD,
          ZxDI   => Zmul2xDI,
          BxDI   => Bmul2xDI,
          QxDO   => AmulExD);

      b_mul_e : entity work.real_dom_shared_mul_gf2
        generic map (
          PIPELINED                => PIPELINED,
          FIRST_ORDER_OPTIMIZATION => "yes",
          SHARES                   => SHARES)
        port map (
          ClkxCI => ClkxCI,
          RstxBI => RstxBI,
          XxDI   => BxDP,
          YxDI   => ExD,
          ZxDI   => Zmul3xDI,
          BxDI   => Bmul3xDI,
          QxDO   => BmulExD);

    end generate shared_sel_pipelined;
    
    ---------------------------------------------------------------
    -- Masked Inverter
    shared_sel: if VARIANT = "Masked" and PIPELINED = "no" generate
      invert_p: process (XxDI, A, B, AmulBxD, AmulExD, BmulExD, ExD) is
        variable c, d : t_shared_gf2(SHARES-1 downto 0); -- temp   
      begin  -- process invert_p
        -- iterate over shares
        for i in 0 to SHARES-1 loop
          -- xor and ^2  
          d(i)    := (A(i)(0) xor B(i)(0)) & (A(i)(1) xor B(i)(1));
          -- scale
          c(i)    := d(i)(0) & (d(i)(1) xor d(i)(0));
          --(c + d)^2
          ExD(i)  <= (c(i)(0) xor AmulBxD(i)(0)) & (c(i)(1) xor AmulBxD(i)(1));
          -- Output  
          QxDO(i) <= BmulExD(i) & AmulExD(i);
        end loop;  -- i
      end process invert_p;
      
      -- Multipliers
      a_mul_b : entity work.real_dom_shared_mul_gf2
        generic map (
          PIPELINED                => PIPELINED,
          FIRST_ORDER_OPTIMIZATION => "yes",
          SHARES                   => SHARES)
        port map (
          ClkxCI => ClkxCI,
          RstxBI => RstxBI,
          XxDI   => A,
          YxDI   => B,
          ZxDI   => Zmul1xDI,
          BxDI   => Bmul1xDI,
          QxDO   => AmulBxD);

      a_mul_e : entity work.real_dom_shared_mul_gf2
        generic map (
          PIPELINED                => PIPELINED,
          FIRST_ORDER_OPTIMIZATION => "yes",
          SHARES                   => SHARES)
        port map (
          ClkxCI => ClkxCI,
          RstxBI => RstxBI,
          XxDI   => A,
          YxDI   => ExD,
          ZxDI   => Zmul2xDI,
          BxDI   => Bmul2xDI,
          QxDO   => AmulExD);

      b_mul_e : entity work.real_dom_shared_mul_gf2
        generic map (
          PIPELINED                => PIPELINED,
          FIRST_ORDER_OPTIMIZATION => "yes",
          SHARES                   => SHARES)
        port map (
          ClkxCI => ClkxCI,
          RstxBI => RstxBI,
          XxDI   => B,
          YxDI   => ExD,
          ZxDI   => Zmul3xDI,
          BxDI   => Bmul3xDI,
          QxDO   => BmulExD);
    end generate shared_sel;
    
    -----------------------------------------------------------------
    ---- Unshared Inverter
    unshared_sel: if VARIANT = "Unshared" generate
      invert_p: process (XxDI, A, B) is
        variable c, d, amuld, bmuld : std_logic_vector(1 downto 0); -- temp
        variable sa, sb,sd : std_logic;
      begin  -- process invert_p
        -- Canright variant 
        sa := A(0)(1) xor A(0)(0);
        sb := B(0)(1) xor B(0)(0);
        c := ((A(0)(1) nor B(0)(1)) xor (sa nand sb)) & ((sa nor sb) xor (A(0)(0) nand B(0)(0)));
        d := c(0) & c(1); -- c squared
        sd := d(1) xor d(0);

        -- A mul E
        amuld(0) := ((sa) and (sd)) xor (A(0)(0) and d(0));
        amuld(1) := ((sa) and (sd)) xor (A(0)(1) and d(1));

        -- A mul E
        bmuld(0) := ((sb) and (sd)) xor (B(0)(0) and d(0));
        bmuld(1) := ((sb) and (sd)) xor (B(0)(1) and d(1));

        QxDO(0) <= bmuld & amuld;
      end process invert_p;
    end generate unshared_sel;

end behavorial;
