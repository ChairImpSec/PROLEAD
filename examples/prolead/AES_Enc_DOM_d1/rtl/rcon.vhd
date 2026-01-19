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
--       ### rcon.vhdl ###
--
-- Description:
-- Round constant calculation RCON
--   
--
-- Initial Version: Date: 4. November 2015 by Hannes Gross IAIK
--
------------------------------------------------------------------------------
library ieee;  use ieee.std_logic_1164.all; 

entity rcon is
  generic (
    PERFECTLY_INTERLEAVED : string := "no"  -- yes -> faster, no -> smaller
    );
  port (
    ClkxCI       : in  std_logic;
    RstxBI       : in  std_logic;
    --- Inputs:
    NextxSI      : in  std_logic;           -- calculate next round constant
    ActivexSI    : in  std_logic;           -- show RCON at output
    --- Output:
    LastRoundxSO : out std_logic;           -- Round 10 started
    FinishedxSO  : out std_logic;           -- Done with round 10
    RCONxDO      : out std_logic_vector (7 downto 0)
    );
end rcon;

-------------------------------------------------------------------

architecture behavorial of rcon is
  -- RCON regs
  signal RCONxDN, RCONxDP : std_logic_vector (7 downto 0); 
begin


  -----------------------------------------------------------------
  -- Perfectly interleaving variant
  perfectly_interleaving : if PERFECTLY_INTERLEAVED = "yes" generate
    -- Perform RCON calculations
    rcon_calc_p : process (ActivexSI, NextxSI, RCONxDP) is
      variable is_zero : std_logic;
    begin  -- process rcon_calc_p
      RCONxDN <= RCONxDP;               -- default

      -- RCON calculation
      if(NextxSI = '1') then
        if((RCONxDP(5) and RCONxDP(2)) = '1') then
          RCONxDN <= "00000001";
        else
          RCONxDN(0) <= RCONxDP(7);
          RCONxDN(1) <= RCONxDP(0) xor RCONxDP(7);
          RCONxDN(2) <= RCONxDP(1);
          RCONxDN(3) <= RCONxDP(2) xor RCONxDP(7);
          RCONxDN(4) <= RCONxDP(3) xor RCONxDP(7);
          RCONxDN(5) <= RCONxDP(4);
          RCONxDN(6) <= RCONxDP(5);
          RCONxDN(7) <= RCONxDP(6);
        end if;
      end if;

      -- Output MUX
      if(ActivexSI = '1') then
        RCONxDO <= RCONxDP;
      else
        RCONxDO <= "00000000";
      end if;

      -- Last round?
      LastRoundxSO <= RCONxDP(5) and RCONxDP(2);
    end process rcon_calc_p;

    -- purpose: Register process
    -- type   : sequential
    -- inputs : ClkxCI, RstxBI
    -- outputs: 
    register_process_p : process (ClkxCI, RstxBI) is
    begin  -- process register_process_p
      if RstxBI = '0' then              -- asynchronous reset (active low)
        RCONxDP <= "00110110";
      elsif ClkxCI'event and ClkxCI = '1' then  -- rising clock edge
        RCONxDP <= RCONxDN;
      end if;
    end process register_process_p;
  end generate perfectly_interleaving;

  -----------------------------------------------------------------
  -- Not Perfectly interleaving variant
  not_perfectly_interleaving : if PERFECTLY_INTERLEAVED = "no" generate
    -- Perform RCON calculations
    rcon_calc_p : process (ActivexSI, NextxSI, RCONxDP) is
      variable is_zero : std_logic;
    begin  -- process rcon_calc_p
      RCONxDN <= RCONxDP;               -- default

      -- RCON calculation
      if(NextxSI = '1') then
        if((RCONxDP(6) and RCONxDP(3)) = '1') then
          RCONxDN <= "00000001";
        else
          RCONxDN(0) <= RCONxDP(7);
          RCONxDN(1) <= RCONxDP(0) xor RCONxDP(7);
          RCONxDN(2) <= RCONxDP(1);
          RCONxDN(3) <= RCONxDP(2) xor RCONxDP(7);
          RCONxDN(4) <= RCONxDP(3) xor RCONxDP(7);
          RCONxDN(5) <= RCONxDP(4);
          RCONxDN(6) <= RCONxDP(5);
          RCONxDN(7) <= RCONxDP(6);
        end if;
      end if;

      -- Output MUX
      if(ActivexSI = '1') then
        RCONxDO <= RCONxDP;
      else
        RCONxDO <= "00000000";
      end if;

      -- Last round?
      LastRoundxSO <= RCONxDP(5) and RCONxDP(2);

      -- Finished?
      FinishedxSO  <= RCONxDP(6) and RCONxDP(3);
    end process rcon_calc_p;

    -- purpose: Register process
    -- type   : sequential
    -- inputs : ClkxCI, RstxBI
    -- outputs: 
    register_process_p : process (ClkxCI, RstxBI) is
    begin  -- process register_process_p
      if RstxBI = '0' then              -- asynchronous reset (active low)
        RCONxDP <= "01101100";
      elsif ClkxCI'event and ClkxCI = '1' then  -- rising clock edge
        RCONxDP <= RCONxDN;
      end if;
    end process register_process_p;
  end generate not_perfectly_interleaving;

                   
end behavorial;
