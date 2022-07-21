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
--       ### aes_key_regs.vhdl ###
--
-- Description:
-- Key registers
--   
--
-- Initial Version: Date: 4. November 2015 by Hannes Gross IAIK
--
------------------------------------------------------------------------------
library ieee;  use ieee.std_logic_1164.all; 

entity aes_key_regs is
  generic (
    PERFECTLY_INTERLEAVED : string  := "no"  -- yes -> faster, no -> smaller
    );
  port (
    ClkxCI            : in  std_logic;
    RstxBI            : in  std_logic;
    --- Inputs:
    KeyInxDI          : in  std_logic_vector(7 downto 0);  -- Key input
    KeyInterleavedxDI : in  std_logic_vector(7 downto 0);  -- alter. key input
    KeySchedulexSI    : in  std_logic;  -- do Sbox lookups                                              
    --- Outputs:
    KeyOutxDO         : out std_logic_vector(7 downto 0);  -- Data output
    KeyToSboxOutxDO   : out std_logic_vector(7 downto 0);  -- ... to Sbox
    K03xDO            : out std_logic_vector(7 downto 0)   -- for key schedule
    );
end aes_key_regs;

architecture behavorial of aes_key_regs is
  -- Key registers
  signal K00xDN, K00xDP : std_logic_vector(7 downto 0);
  signal K01xDN, K01xDP : std_logic_vector(7 downto 0);
  signal K02xDN, K02xDP : std_logic_vector(7 downto 0);
  signal K03xDN, K03xDP : std_logic_vector(7 downto 0);
  signal K10xDN, K10xDP : std_logic_vector(7 downto 0);
  signal K11xDN, K11xDP : std_logic_vector(7 downto 0);
  signal K12xDN, K12xDP : std_logic_vector(7 downto 0);
  signal K13xDN, K13xDP : std_logic_vector(7 downto 0);
  signal K20xDN, K20xDP : std_logic_vector(7 downto 0);
  signal K21xDN, K21xDP : std_logic_vector(7 downto 0);
  signal K22xDN, K22xDP : std_logic_vector(7 downto 0);
  signal K23xDN, K23xDP : std_logic_vector(7 downto 0);
  signal K30xDN, K30xDP : std_logic_vector(7 downto 0);
  signal K31xDN, K31xDP : std_logic_vector(7 downto 0);
  signal K32xDN, K32xDP : std_logic_vector(7 downto 0);
  signal K33xDN, K33xDP : std_logic_vector(7 downto 0);
begin

  -- Register movement for NOT perfectly interleaved variant
  not_perfectly_interleaved_var : if PERFECTLY_INTERLEAVED = "no" generate
    state_movement_p : process (K00xDP, K01xDP, K02xDP, K03xDP, K10xDP, K11xDP,
                               K12xDP, K13xDP, K20xDP, K21xDP, K22xDP, K23xDP,
                               K30xDP, K31xDP, K32xDP, K33xDP, KeyInterleavedxDI,
                               KeyInxDI, KeySchedulexSI) is
    begin  -- process state_movement_p
      KeyOutxDO       <= K00xDP;  -- default output is first register (K00)
      KeyToSboxOutxDO <= K13xDP;        -- to Sbox for key scheduling
      K03xDO          <= K03xDP;        -- output K03 for key schedule

      -- Key scheduling
      if (KeySchedulexSI = '1') then
        K00xDN <= K10xDP;               -- 1st row
        K01xDN <= K11xDP;
        K02xDN <= K12xDP;
        K03xDN <= K13xDP;
        K10xDN <= K20xDP;               -- 2nd row
        K11xDN <= K21xDP;
        K12xDN <= K22xDP;
        K13xDN <= K23xDP;
        K20xDN <= K30xDP;               -- 3rd row
        K21xDN <= K31xDP;
        K22xDN <= K32xDP;
        K23xDN <= K33xDP;
        K30xDN <= K00xDP;    -- 4th row
        K31xDN <= K01xDP;
        K32xDN <= K02xDP;
        K33xDN <= K03xDP;
      else
        -- Normal register movement (meander)
        K00xDN <= K10xDP;               -- 1st row
        K01xDN <= K11xDP;
        K02xDN <= K12xDP;
        K03xDN <= K13xDP;
        K10xDN <= K20xDP;               -- 2nd row
        K11xDN <= K21xDP;
        K12xDN <= K22xDP;
        K13xDN <= K23xDP;
        K20xDN <= K30xDP;               -- 3rd row
        K21xDN <= K31xDP;
        K22xDN <= K32xDP;
        K23xDN <= K33xDP;
        K30xDN <= K01xDP;               -- 4th row
        K31xDN <= K02xDP;
        K32xDN <= K03xDP;
        K33xDN <= KeyInxDI;
      end if;
    end process state_movement_p;
  end generate not_perfectly_interleaved_var;
  
-- Register movement for perfectly interleaved variant
  perfectly_interleaved_var : if PERFECTLY_INTERLEAVED = "yes" generate
    state_movement_p : process (K00xDP, K01xDP, K02xDP, K03xDP, K10xDP, K11xDP,
                               K12xDP, K13xDP, K20xDP, K21xDP, K22xDP, K23xDP,
                               K30xDP, K31xDP, K32xDP, K33xDP, KeyInterleavedxDI,
                               KeyInxDI, KeySchedulexSI) is
    begin  -- process state_movement_p
      KeyOutxDO       <= K00xDP;  -- default output is first register (K00)
      KeyToSboxOutxDO <= K13xDP;        -- to Sbox for key scheduling
      K03xDO          <= K03xDP;        -- output K03 for key schedule

      -- Key scheduling
      if (KeySchedulexSI = '1') then
        K00xDN <= K10xDP;               -- 1st row
        K01xDN <= K11xDP;
        K02xDN <= K12xDP;
        K03xDN <= K13xDP;
        K10xDN <= K20xDP;               -- 2nd row
        K11xDN <= K21xDP;
        K12xDN <= K22xDP;
        K13xDN <= K23xDP;
        K20xDN <= K30xDP;               -- 3rd row
        K21xDN <= K31xDP;
        K22xDN <= K32xDP;
        K23xDN <= K33xDP;
        K30xDN <= KeyInterleavedxDI;    -- 4th row
        K31xDN <= K01xDP;
        K32xDN <= K02xDP;
        K33xDN <= KeyInxDI;
      else
        -- Normal register movement (meander)
        K00xDN <= K10xDP;               -- 1st row
        K01xDN <= K11xDP;
        K02xDN <= K12xDP;
        K03xDN <= K13xDP;
        K10xDN <= K20xDP;               -- 2nd row
        K11xDN <= K21xDP;
        K12xDN <= K22xDP;
        K13xDN <= K23xDP;
        K20xDN <= K30xDP;               -- 3rd row
        K21xDN <= K31xDP;
        K22xDN <= K32xDP;
        K23xDN <= K33xDP;
        K30xDN <= K01xDP;               -- 4th row
        K31xDN <= K02xDP;
        K32xDN <= KeyInterleavedxDI;
        K33xDN <= KeyInxDI;
      end if;
    end process state_movement_p;
  end generate perfectly_interleaved_var;  

  -- purpose: Register process
  -- type   : sequential
  -- inputs : ClkxCI, RstxBI
  -- outputs: 
  register_process_p: process (ClkxCI, RstxBI) is
  begin  -- process register_process_p
    if RstxBI = '0' then                -- asynchronous reset (active low)
      K00xDP <= (others => '0');
      K01xDP <= (others => '0');
      K02xDP <= (others => '0');
      K03xDP <= (others => '0');
      K10xDP <= (others => '0');
      K11xDP <= (others => '0');
      K12xDP <= (others => '0');
      K13xDP <= (others => '0');
      K20xDP <= (others => '0');
      K21xDP <= (others => '0');
      K22xDP <= (others => '0');
      K23xDP <= (others => '0');
      K30xDP <= (others => '0');
      K31xDP <= (others => '0');
      K32xDP <= (others => '0');
      K33xDP <= (others => '0');
    elsif ClkxCI'event and ClkxCI = '1' then  -- rising clock edge
      K00xDP <= K00xDN;
      K01xDP <= K01xDN;
      K02xDP <= K02xDN;
      K03xDP <= K03xDN;
      K10xDP <= K10xDN;
      K11xDP <= K11xDN;
      K12xDP <= K12xDN;
      K13xDP <= K13xDN;
      K20xDP <= K20xDN;
      K21xDP <= K21xDN;
      K22xDP <= K22xDN;
      K23xDP <= K23xDN;
      K30xDP <= K30xDN;
      K31xDP <= K31xDN;
      K32xDP <= K32xDN;
      K33xDP <= K33xDN;
    end if;
  end process register_process_p;
                   
end behavorial;
