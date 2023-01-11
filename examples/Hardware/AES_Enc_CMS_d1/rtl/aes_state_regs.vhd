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
--       ### aes_state_regs.vhdl ###
--
-- Description:
-- State registers
--   
--
-- Initial Version: Date: 4. November 2015 by Hannes Gross IAIK
--
------------------------------------------------------------------------------
library ieee;  use ieee.std_logic_1164.all; 

entity aes_state_regs is
  port (
    ClkxCI        : in  std_logic;
    RstxBI        : in  std_logic;
    --- Inputs:
    StateInxDI    : in  std_logic_vector(7 downto 0);  -- Data input
    ShiftRowsxSI  : in  std_logic;                     -- do "ShiftRows" 
    MixColumnsxSI : in  std_logic;                     -- do "MixColumns"
    --- Output:
    StateOutxDO   : out std_logic_vector(7 downto 0);  -- Data output
    S01xDO        : out std_logic_vector(7 downto 0)   -- output register S01
    );
end aes_state_regs;

-------------------------------------------------------------------

architecture behavorial of aes_state_regs is
  -- State registers
  signal S00xDN, S00xDP : std_logic_vector(7 downto 0);
  signal S01xDN, S01xDP : std_logic_vector(7 downto 0);
  signal S02xDN, S02xDP : std_logic_vector(7 downto 0);
  signal S03xDN, S03xDP : std_logic_vector(7 downto 0);
  signal S10xDN, S10xDP : std_logic_vector(7 downto 0);
  signal S11xDN, S11xDP : std_logic_vector(7 downto 0);
  signal S12xDN, S12xDP : std_logic_vector(7 downto 0);
  signal S13xDN, S13xDP : std_logic_vector(7 downto 0);
  signal S20xDN, S20xDP : std_logic_vector(7 downto 0);
  signal S21xDN, S21xDP : std_logic_vector(7 downto 0);
  signal S22xDN, S22xDP : std_logic_vector(7 downto 0);
  signal S23xDN, S23xDP : std_logic_vector(7 downto 0);
  signal S30xDN, S30xDP : std_logic_vector(7 downto 0);
  signal S31xDN, S31xDP : std_logic_vector(7 downto 0);
  signal S32xDN, S32xDP : std_logic_vector(7 downto 0);
  signal S33xDN, S33xDP : std_logic_vector(7 downto 0);
  -- MixColumns signals
  signal MixColumnsS0xD : std_logic_vector(7 downto 0);
  signal MixColumnsS1xD : std_logic_vector(7 downto 0);
  signal MixColumnsS2xD : std_logic_vector(7 downto 0);
  signal MixColumnsS3xD : std_logic_vector(7 downto 0);
begin

  -- purpose: Register movement
  -- type   : combinational
  -- inputs : 
  -- outputs: 
state_movement_p: process (MixColumnsS0xD, MixColumnsS1xD, MixColumnsS2xD,
                           MixColumnsS3xD, MixColumnsxSI, S00xDP, S01xDP,
                           S02xDP, S03xDP, S10xDP, S11xDP, S12xDP, S13xDP,
                           S20xDP, S21xDP, S22xDP, S23xDP, S30xDP, S31xDP,
                           S32xDP, S33xDP, ShiftRowsxSI, StateInxDI) is
  begin  -- process state_movement_p
    StateOutxDO <= S00xDP; -- default output is first register (S00)
    S01xDO      <= S01xDP; -- register S01 for writing key back to K

    -- ShiftRows movement (one cycle before last byte is written)
    if (ShiftRowsxSI = '1') then
      S00xDN <= S10xDP;                 -- 1st row
      S01xDN <= S11xDP;
      S02xDN <= S12xDP;
      S03xDN <= S13xDP;
      S10xDN <= S21xDP;                 -- 2nd row
      S11xDN <= S22xDP;
      S12xDN <= S23xDP;
      S13xDN <= S20xDP;
      S20xDN <= S32xDP;                 -- 3rd row
      S21xDN <= S33xDP;
      S22xDN <= S30xDP;
      S23xDN <= S31xDP;
      S30xDN <= StateInxDI;             -- 4th row
      S31xDN <= S01xDP;
      S32xDN <= S02xDP;
      S33xDN <= S03xDP;
    -- MixColumns movement
    elsif (MixColumnsxSI = '1') then
      StateOutxDO <= MixColumnsS0xD;    -- output MUX

      S00xDN <= MixColumnsS1xD;         -- 1st row
      S01xDN <= S11xDP;
      S02xDN <= S12xDP;
      S03xDN <= S13xDP;
      S10xDN <= MixColumnsS2xD;         -- 2nd row
      S11xDN <= S21xDP;
      S12xDN <= S22xDP;
      S13xDN <= S23xDP;
      S20xDN <= MixColumnsS3xD;         -- 3rd row
      S21xDN <= S31xDP;
      S22xDN <= S32xDP;
      S23xDN <= S33xDP;
      S30xDN <= S01xDP;                 -- 4th row
      S31xDN <= S02xDP;
      S32xDN <= S03xDP;
      S33xDN <= StateInxDI;  
    else
      -- Normal register movement (meander)
      S00xDN <= S10xDP;                 -- 1st row
      S01xDN <= S11xDP;
      S02xDN <= S12xDP;
      S03xDN <= S13xDP;
      S10xDN <= S20xDP;                 -- 2nd row
      S11xDN <= S21xDP;
      S12xDN <= S22xDP;
      S13xDN <= S23xDP;
      S20xDN <= S30xDP;                 -- 3rd row
      S21xDN <= S31xDP;
      S22xDN <= S32xDP;
      S23xDN <= S33xDP;
      S30xDN <= S01xDP;                 -- 4th row
      S31xDN <= S02xDP;
      S32xDN <= S03xDP;
      S33xDN <= StateInxDI;
    end if;
  end process state_movement_p;

  -- MixColumns transformation
  mix_columns_1: entity work.mix_columns
    port map (
      A0xDI => S00xDP,
      A1xDI => S10xDP,
      A2xDI => S20xDP,
      A3xDI => S30xDP,
      B0xDO => MixColumnsS0xD,
      B1xDO => MixColumnsS1xD,
      B2xDO => MixColumnsS2xD,
      B3xDO => MixColumnsS3xD); 

  -- purpose: Register process
  -- type   : sequential
  -- inputs : ClkxCI, RstxBI
  -- outputs: 
  register_process_p: process (ClkxCI, RstxBI) is
  begin  -- process register_process_p
    if RstxBI = '0' then                -- asynchronous reset (active low)
      S00xDP <= (others => '0');
      S01xDP <= (others => '0');
      S02xDP <= (others => '0');
      S03xDP <= (others => '0');
      S10xDP <= (others => '0');
      S11xDP <= (others => '0');
      S12xDP <= (others => '0');
      S13xDP <= (others => '0');
      S20xDP <= (others => '0');
      S21xDP <= (others => '0');
      S22xDP <= (others => '0');
      S23xDP <= (others => '0');
      S30xDP <= (others => '0');
      S31xDP <= (others => '0');
      S32xDP <= (others => '0');
      S33xDP <= (others => '0');
    elsif ClkxCI'event and ClkxCI = '1' then  -- rising clock edge
      S00xDP <= S00xDN;
      S01xDP <= S01xDN;
      S02xDP <= S02xDN;
      S03xDP <= S03xDN;
      S10xDP <= S10xDN;
      S11xDP <= S11xDN;
      S12xDP <= S12xDN;
      S13xDP <= S13xDN;
      S20xDP <= S20xDN;
      S21xDP <= S21xDN;
      S22xDP <= S22xDN;
      S23xDP <= S23xDN;
      S30xDP <= S30xDN;
      S31xDP <= S31xDN;
      S32xDP <= S32xDN;
      S33xDP <= S33xDN;
    end if;
  end process register_process_p;
                   
end behavorial;
