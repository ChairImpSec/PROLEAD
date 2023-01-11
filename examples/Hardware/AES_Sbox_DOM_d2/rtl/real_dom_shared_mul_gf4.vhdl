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
--       ### real_dom_shared_mul_gf4.vhdl ###
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

entity real_dom_shared_mul_gf4 is
  generic (
    PIPELINED                : string  := "yes";
    FIRST_ORDER_OPTIMIZATION : string  := "yes";
    SHARES                   : integer := 2
    );
  port (
    -- Clock and reset
    ClkxCI : in  std_logic;
    RstxBI : in  std_logic;
    -- Shares of X and Y
    XxDI   : in  t_shared_gf4(SHARES-1 downto 0);
    YxDI   : in  t_shared_gf4(SHARES-1 downto 0);
    -- Fresh masks
    ZxDI   : in  t_shared_gf4((SHARES*(SHARES-1)/2)-1 downto 0);
    -- Blinding shares (SUM != 0)
    BxDI   : in  t_shared_gf4(SHARES-1 downto 0);
    -- Output Q = X*Y
    QxDO   : out t_shared_gf4(SHARES-1 downto 0)
    );
  constant NUM_MASKS : integer := SHARES*(SHARES-1)/2;
end real_dom_shared_mul_gf4;

-------------------------------------------------------------------
architecture behavorial of real_dom_shared_mul_gf4 is
  ---- Intermediates
  -- Blinded Y values
  signal BlindedYxDN         : t_shared_gf4(SHARES-1 downto 0);
  signal BlindedYxDP         : t_shared_gf4(SHARES-1 downto 0);
  -- Sum of blinded Y shares
  signal SumBlindedYxD       : std_logic_vector(3 downto 0);
  -- x *( sum(y+b) ) signal
  signal XtimesSumBlindedYxD : t_shared_gf4(SHARES-1 downto 0);
  -- x * b signal
  signal XtimesBxD           : t_shared_gf4(SHARES-1 downto 0);
  -- X pipelined
  signal XxDP                : t_shared_gf4(SHARES-1 downto 0);
  -- X input for GF mults => x * (y + z)
  signal XpipelinedOrNotxS   : t_shared_gf4(SHARES-1 downto 0);

  ---- For first-order optimization only:
  signal XtimesYxS             : t_shared_gf4(SHARES-1 downto 0);
  signal XtimesBlindedY        : t_shared_gf4(SHARES-1 downto 0);
  -- Y pipelined
  signal YxDP                  : t_shared_gf4(SHARES-1 downto 0);
  -- Xand Y multiplier inputs depending on pipelinign selection
  signal XxD, YxD              : t_shared_gf4(SHARES-1 downto 0);
  -- X times blinding value B 
  signal X_times_BxD           : t_shared_gf4(SHARES-1 downto 0);
  signal X_times_B_remaskedxDN : t_shared_gf4(SHARES-1 downto 0);
  signal X_times_B_remaskedxDP : t_shared_gf4(SHARES-1 downto 0);
begin

  -----------------------------------------------------------------------------
  -- First-order optimized variant
  first_order_optimized_variant_g: if (FIRST_ORDER_OPTIMIZATION = "yes") and (SHARES = 2)  generate
    -- Blinding of Y 
    blind_y_p: process (BxDI, X_times_BxD, XxDI, XxDP,
                        YxDI, YxDP, ZxDI, XtimesYxS, XtimesBlindedY,
                        X_times_B_remaskedxDP) is
    begin  -- process blind_y_p
      BlindedYxDN(1) <= YxDI(0) xor BxDI(0); -- use the same blinding share!
      BlindedYxDN(0) <= YxDI(1) xor BxDI(0); -- switch the shares here because
                                             -- each domain uses the other here

      -- Select inputs for multipliers depending if pipelining is used
      if(PIPELINED = "yes") then
        XxD <= XxDP;
        YxD <= YxDP;
      else
        XxD <= XxDI;
        YxD <= YxDI;
      end if;

      -- Remask X * B ... + Z
      X_times_B_remaskedxDN(0) <= X_times_BxD(0) xor ZxDI(0); -- use same mask
      X_times_B_remaskedxDN(1) <= X_times_BxD(1) xor ZxDI(0);

      -- Output
      QxDO(0) <= XtimesYxS(0) xor XtimesBlindedY(0) xor X_times_B_remaskedxDP(0);
      QxDO(1) <= XtimesYxS(1) xor XtimesBlindedY(1) xor X_times_B_remaskedxDP(1);
    end process blind_y_p;

    -- Remask multiplication results from different domains
    x_times_b_register_p: process (ClkxCI, RstxBI) is
    begin  -- process x_times_b_register_p
      if RstxBI = '0' then              -- asynchronous reset (active low)
        X_times_B_remaskedxDP(0) <= (others => '0');
        X_times_B_remaskedxDP(1) <= (others => '0');
      elsif ClkxCI'event and ClkxCI = '1' then  -- rising clock edge
        X_times_B_remaskedxDP(0) <= X_times_B_remaskedxDN(0);
        X_times_B_remaskedxDP(1) <= X_times_B_remaskedxDN(1);
      end if;
    end process x_times_b_register_p;

    -- Multipliers
    gen_multipliers_g : for i in SHARES-1 downto 0 generate
      x_times_y : entity work.gf2_mul
        generic map (
          N => 4)
        port map (
          AxDI => XxD(i), 
          BxDI => YxD(i),
          QxDO => XtimesYxS(i));

      x_times_blinded_y : entity work.gf2_mul
        generic map (
          N => 4)
        port map (
          AxDI => XxD(i),
          BxDI => BlindedYxDP(i),
          QxDO => XtimesBlindedY(i));

      x_times_b : entity work.gf2_mul
        generic map (
          N => 4)
        port map (
          AxDI => XxDI(i),
          BxDI => BxDI(0), -- only use one blinding input!
          QxDO => X_times_BxD(i));
    end generate gen_multipliers_g;

  end generate first_order_optimized_variant_g;
  
  -----------------------------------------------------------------------------
  -- NO First-order optimized variant
  donot_use_fo_optimization_g: if (FIRST_ORDER_OPTIMIZATION = "no") or (SHARES > 2) generate

    -- Blind input Y
    blind_y_p: process (BlindedYxDP, BxDI, XxDI, XxDP,
                        YxDI) is
      variable SumBlindedY : std_logic_vector(3 downto 0);
    begin  -- process blind_y_p
      BlindedYxDN <= BlindedYxDP;       -- default
      SumBlindedY := (others => '0');
      -- per share
      for i in SHARES-1 downto 0 loop
        BlindedYxDN(i) <= YxDI(i) xor BxDI(i);
        -- Sum of blinded Y
        SumBlindedY    := SumBlindedY xor BlindedYxDP(i);

        -- X input for GF mults => x * (y + z)
        if(PIPELINED = "yes") then
          XpipelinedOrNotxS(i) <= XxDP(i);
        else
          XpipelinedOrNotxS(i) <= XxDI(i);
        end if;
      end loop;  -- i
      -- Output sum of blinded Y shares
      SumBlindedYxD <= SumBlindedY;
    end process blind_y_p;

    -- Generate multipliers calculating x *( sum(y+b) )
    gen_multipliers_g : for i in SHARES-1 downto 0 generate
      gf4_mul : entity work.gf2_mul
        generic map (
          N => 4)
        port map (
          AxDI => XpipelinedOrNotxS(i),
          BxDI => SumBlindedYxD,
          QxDO => XtimesSumBlindedYxD(i));
    end generate gen_multipliers_g;

    -- Multiplier calculating x*b
    shared_mul_gf4_1: entity work.shared_mul_gf4
      generic map (
        PIPELINED => PIPELINED,
        SHARES    => SHARES)
      port map (
        ClkxCI => ClkxCI,
        RstxBI => RstxBI,
        XxDI   => XxDI,
        YxDI   => BxDI,
        ZxDI   => ZxDI,
        QxDO   => XtimesBxD);

    -- Output signal x*y = x*(y+b) + x*b
    output_signals_p: process (XtimesBxD, XtimesSumBlindedYxD) is
    begin  -- process output_signals_p
      for i in SHARES-1 downto 0 loop
        QxDO(i) <= XtimesSumBlindedYxD(i) xor XtimesBxD(i);
      end loop;  -- i
    end process output_signals_p;
  end generate donot_use_fo_optimization_g;

  ---- General stuff used for all variants:
  -- Use pipelining --> X needs to be registered
    pipeline_register_g: if PIPELINED = "yes" generate
      pipelining_regs_p : process (ClkxCI, RstxBI) is
      begin  -- process pipelining_regs_p
        if RstxBI = '0' then            -- asynchronous reset (active low)
          for i in SHARES-1 downto 0 loop
            XxDP(i) <= (others => '0');
            YxDP(i) <= (others => '0'); -- only for first-order optimization
          end loop;  -- i
        elsif ClkxCI'event and ClkxCI = '1' then  -- rising clock edge
          for i in SHARES-1 downto 0 loop
            XxDP(i) <= XxDI(i);
            YxDP(i) <= YxDI(i); -- only for first-order optimization
          end loop;  -- i
        end if;
      end process pipelining_regs_p;
    end generate pipeline_register_g;
  
  -- Blinding register process
  blinding_y_reg_p : process (ClkxCI, RstxBI) is
  begin  -- process blinding_y_reg_p
    if RstxBI = '0' then                -- asynchronous reset (active low)
      for i in SHARES-1 downto 0 loop
        BlindedYxDP(i) <= (others => '0');
      end loop;  -- i
    elsif ClkxCI'event and ClkxCI = '1' then  -- rising clock edge
      for i in SHARES-1 downto 0 loop
        BlindedYxDP(i) <= BlindedYxDN(i);
      end loop;  -- i 
    end if;
  end process blinding_y_reg_p;
end behavorial;
