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
--       ### aes_ctrl_lsfr.vhdl ###
--
-- Description:
-- LSFR that generates the state transitions
--   
--
-- Initial Version: Date: 4. November 2015 by Hannes Gross IAIK
--
------------------------------------------------------------------------------
library ieee;  use ieee.std_logic_1164.all; 

entity aes_ctrl_lsfr_23_cycles is
  port (
    ClkxCI                : in  std_logic;
    RstxBI                : in  std_logic;
    --- Inputs:
    StartxSI              : in  std_logic;  -- Start running
    LastRoundxSI          : in  std_logic;  -- Back to idle
    -- State outputs
    StateIDLExS           : out std_logic;  -- IDLE State
    State1xS              : out std_logic;  -- State 1 is active
    -- Phases
    StateKEYADDITION1o3xS : out std_logic;  -- 1/3 of KeyAddition
    StateKEYADDITION2o3xS : out std_logic;  -- 2/3 of KeyAddition
    StateKEYADDITION3o3xS : out std_logic;  -- 3/3 of KeyAddition
    StateKEYSCHEDULExS    : out std_logic;  -- Key schedule state
    StateSHIFTROWSxS      : out std_logic;  -- ShiftRows + K in Sbox
    -- Other control signals
    disableKeyRegsxS      : out std_logic;  -- Clockgate K regs
    doMixColumnsxS        : out std_logic   -- perform MixColumns
    );

end aes_ctrl_lsfr_23_cycles;

-------------------------------------------------------------------

architecture behavorial of aes_ctrl_lsfr_23_cycles is
  -- LSFR regs
  type state_t is (S0,S1,S2,S3,S4,S5,S6,S7,S8,S9,S10,S11,S12,S13,S14,S15,S16,S17,S18,S19,S20,S21,S22,S23);
  signal LSFRxDN, LSFRxDP : state_t;
  
begin

 create_control_signals_p: process (LSFRxDP, LastRoundxSI) is
 begin  -- process create_control_signals_p
   
   -- Default assignments
   StateIDLExS           <= '0';  
   State1xS              <= '0';
   StateKEYADDITION1o3xS <= '0';
   StateKEYADDITION2o3xS <= '0';
   StateKEYADDITION3o3xS <= '0';
   StateKEYSCHEDULExS    <= '0';
   StateSHIFTROWSxS      <= '0';
   doMixColumnsxS        <= '0';
   disableKeyRegsxS      <= '0';

   -- in cycle 1
   if(LSFRxDP = S1) then
     State1xS <= '1';
   end if;

   -- MixColumns every 4th cycle except for the last round
   if(LastRoundxSI = '0' and (LSFRxDP = S1 or LSFRxDP = S5 or LSFRxDP = S9 or LSFRxDP = S13) ) then
     doMixColumnsxS <= '1';
   end if;
   
   -- State specific signals
   case LSFRxDP is
     -- IDLE
     when S0 =>
       StateIDLExS              <= '1';
     -- KeyAddition Part 1 Cycle 1 - 4
     when S1 | S2 | S3 | S4 =>
       StateKEYADDITION1o3xS    <= '1';
     -- KeyAddition Part 2 Cycle 5 - 12
     when S5 | S6 | S7 | S8 | S9 | S10 | S11 | S12 =>
       StateKEYADDITION2o3xS    <= '1';
     -- KeyAddition Part 3 Cycle 13 - 16
     when S13 | S14 | S15 | S16 =>
       StateKEYADDITION3o3xS    <= '1';
     -- Key schedule Cycle 17 - 20
     when S17 | S18 | S19 =>
       StateKEYSCHEDULExS <= '1';
     when S20 =>
       StateKEYSCHEDULExS <= '1';
       disableKeyRegsxS <= '1';
     -- Dummy cycles
     when S21 | S22 =>
       disableKeyRegsxS <= '1';
     when S23 =>
       disableKeyRegsxS <= '1';
       StateSHIFTROWSxS <= '1';
     when others =>
   end case;
 end process create_control_signals_p;

  feedback_p: process (LSFRxDP, LastRoundxSI, StartxSI) is
  begin  -- process feedback_p
    LSFRxDN <= LSFRxDP; -- default;
    
    case LSFRxDP is
      -- IDLE
      when S0 =>
        -- Wait for start signal
        if(StartxSI = '1') then
          LSFRxDN <= S1;
        end if;
      when S1 => LSFRxDN <= S2;
      when S2 => LSFRxDN <= S3;
      when S3 => LSFRxDN <= S4;
      when S4 => LSFRxDN <= S5;
      when S5 => LSFRxDN <= S6;
      when S6 => LSFRxDN <= S7;
      when S7 => LSFRxDN <= S8;
      when S8 => LSFRxDN <= S9;
      when S9 => LSFRxDN <= S10;
      when S10 => LSFRxDN <= S11;
      when S11 => LSFRxDN <= S12;
      when S12 => LSFRxDN <= S13;
      when S13 => LSFRxDN <= S14;
      when S14 => LSFRxDN <= S15;
      when S15 => LSFRxDN <= S16;
      when S16 => LSFRxDN <= S17;
      when S17 => LSFRxDN <= S18;
      when S18 => LSFRxDN <= S19;
      when S19 => LSFRxDN <= S20;
      when S20 => LSFRxDN <= S21;
      when S21 => LSFRxDN <= S22;
      when S22 => LSFRxDN <= S23;
      when S23 => LSFRxDN <= S1;
      when others =>
    end case;
  end process feedback_p;

  -- purpose: Register process
  -- type   : sequential
  -- inputs : ClkxCI, RstxBI
  -- outputs: 
  register_process_p: process (ClkxCI, RstxBI) is
  begin  -- process register_process_p
    if RstxBI = '0' then                -- asynchronous reset (active low)
      LSFRxDP <= S0;
    elsif ClkxCI'event and ClkxCI = '1' then  -- rising clock edge
      LSFRxDP <= LSFRxDN;
    end if;
  end process register_process_p;
                   
end behavorial;
