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

entity aes_ctrl_lsfr is
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
    doMixColumnsxS        : out std_logic   -- perform MixColumns
    );

  -- States
  constant STATE_0  : std_logic_vector(4 downto 0) := "00000";
  constant STATE_1  : std_logic_vector(4 downto 0) := "00011";
  constant STATE_2  : std_logic_vector(4 downto 0) := "00111";
  constant STATE_3  : std_logic_vector(4 downto 0) := "01111";
  constant STATE_4  : std_logic_vector(4 downto 0) := "11111";
  constant STATE_5  : std_logic_vector(4 downto 0) := "11110";
  constant STATE_6  : std_logic_vector(4 downto 0) := "11101";
  constant STATE_7  : std_logic_vector(4 downto 0) := "11010";
  constant STATE_8  : std_logic_vector(4 downto 0) := "10101";
  constant STATE_9  : std_logic_vector(4 downto 0) := "01010";
  constant STATE_10 : std_logic_vector(4 downto 0) := "10100";
  constant STATE_11 : std_logic_vector(4 downto 0) := "01001";
  constant STATE_12 : std_logic_vector(4 downto 0) := "10011";
  constant STATE_13 : std_logic_vector(4 downto 0) := "00110";
  constant STATE_14 : std_logic_vector(4 downto 0) := "01100";
  constant STATE_15 : std_logic_vector(4 downto 0) := "11000";
  constant STATE_16 : std_logic_vector(4 downto 0) := "10001";
  constant STATE_17 : std_logic_vector(4 downto 0) := "00010";
  constant STATE_18 : std_logic_vector(4 downto 0) := "00100";
  constant STATE_19 : std_logic_vector(4 downto 0) := "01000";
  constant STATE_20 : std_logic_vector(4 downto 0) := "10000";
end aes_ctrl_lsfr;

-------------------------------------------------------------------

architecture behavorial of aes_ctrl_lsfr is
  -- LSFR regs
  signal LSFRxDN, LSFRxDP : std_logic_vector (4 downto 0);
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

   -- in cycle 1
   if(LSFRxDP = STATE_1) then
     State1xS <= '1';
   end if;

   -- MixColumns every 4th cycle exept for the last round
   if(LastRoundxSI = '0' and (LSFRxDP = STATE_1 or LSFRxDP = STATE_5 or LSFRxDP = STATE_9 or LSFRxDP = STATE_13) ) then
     doMixColumnsxS <= '1';
   end if;
   
   -- State specific signals
   case LSFRxDP is
     -- IDLE
     when STATE_0 =>
       StateIDLExS              <= '1';
     -- KeyAddition Part 1 Cycle 1 - 4
     when STATE_1 | STATE_2 | STATE_3 | STATE_4 =>
       StateKEYADDITION1o3xS    <= '1';
     -- KeyAddition Part 2 Cycle 5 - 12
     when STATE_5 | STATE_6 | STATE_7 | STATE_8 | STATE_9 | STATE_10 | STATE_11 | STATE_12 =>
       StateKEYADDITION2o3xS    <= '1';
     -- KeyAddition Part 3 Cycle 13 - 16
     when STATE_13 | STATE_14 | STATE_15 | STATE_16 =>
       StateKEYADDITION3o3xS    <= '1';
     -- Key schedule Cycle 17 - 20
     when STATE_17 | STATE_18 | STATE_19 =>
       StateKEYSCHEDULExS <= '1';
     when STATE_20 =>
       StateSHIFTROWSxS <= '1';
     when others =>
   end case;
 end process create_control_signals_p;

  feedback_p: process (LSFRxDP, StartxSI) is
    variable fb0 : std_logic;
    variable fb1 : std_logic;
    variable cmp : std_logic;
  begin  -- process feedback_p
    
    -- Check for this state in order to know when to continue from start
    if (LSFRxDP = "10000") then
      cmp := '1';
    else
      cmp := '0';
    end if;

    -- Bit 0 of LSFR
    fb0 := (LSFRxDP(0) xor LSFRxDP(4)) or StartxSI;
    -- Bit 1 of LSFR
    fb1 := (LSFRxDP(0) or StartxSI) or cmp;

    -- Shift with feedback
    LSFRxDN <= LSFRxDP(3 downto 1) & fb1 & fb0; 
  end process feedback_p;

  -- purpose: Register process
  -- type   : sequential
  -- inputs : ClkxCI, RstxBI
  -- outputs: 
  register_process_p: process (ClkxCI, RstxBI) is
  begin  -- process register_process_p
    if RstxBI = '0' then                -- asynchronous reset (active low)
      LSFRxDP <= STATE_0;
    elsif ClkxCI'event and ClkxCI = '1' then  -- rising clock edge
      LSFRxDP <= LSFRxDN;
    end if;
  end process register_process_p;
                   
end behavorial;
