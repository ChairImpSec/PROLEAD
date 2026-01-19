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
--       ### mix_columns.vhdl ###
--
-- Description:
-- MixColumns transformation
--   
--
-- Initial Version: Date: 4. November 2015 by Hannes Gross IAIK
--
------------------------------------------------------------------------------
library ieee;  use ieee.std_logic_1164.all; 

entity mix_columns is
  port (
    --- Inputs:
    A0xDI     : in std_logic_vector(7 downto 0);
    A1xDI     : in std_logic_vector(7 downto 0);
    A2xDI     : in std_logic_vector(7 downto 0);
    A3xDI     : in std_logic_vector(7 downto 0);
    --- Output:
    B0xDO     : out std_logic_vector(7 downto 0);
    B1xDO     : out std_logic_vector(7 downto 0);
    B2xDO     : out std_logic_vector(7 downto 0);
    B3xDO     : out std_logic_vector(7 downto 0)
    );
end mix_columns;

-------------------------------------------------------------------

architecture behavorial of mix_columns is

begin
  -- Calculate all bytes at once
  mix_columns_p : process (A0xDI, A1xDI, A2xDI, A3xDI) is
    variable a0_mul_2 : std_logic_vector(7 downto 0);
    variable a1_mul_2 : std_logic_vector(7 downto 0);
    variable a2_mul_2 : std_logic_vector(7 downto 0);
    variable a3_mul_2 : std_logic_vector(7 downto 0);
    variable a0_mul_3 : std_logic_vector(7 downto 0);
    variable a1_mul_3 : std_logic_vector(7 downto 0);
    variable a2_mul_3 : std_logic_vector(7 downto 0);
    variable a3_mul_3 : std_logic_vector(7 downto 0);
  begin  -- process mix_columns_p
    -- 2*a0
    a0_mul_2(0) := A0xDI(7);
    a0_mul_2(1) := A0xDI(0) xor A0xDI(7);
    a0_mul_2(2) := A0xDI(1);
    a0_mul_2(3) := A0xDI(2) xor A0xDI(7);
    a0_mul_2(4) := A0xDI(3) xor A0xDI(7);
    a0_mul_2(5) := A0xDI(4);
    a0_mul_2(6) := A0xDI(5);
    a0_mul_2(7) := A0xDI(6);

    -- 2*a1
    a1_mul_2(0) := A1xDI(7);
    a1_mul_2(1) := A1xDI(0) xor A1xDI(7);
    a1_mul_2(2) := A1xDI(1);
    a1_mul_2(3) := A1xDI(2) xor A1xDI(7);
    a1_mul_2(4) := A1xDI(3) xor A1xDI(7);
    a1_mul_2(5) := A1xDI(4);
    a1_mul_2(6) := A1xDI(5);
    a1_mul_2(7) := A1xDI(6);

    -- 2*a2
    a2_mul_2(0) := A2xDI(7);
    a2_mul_2(1) := A2xDI(0) xor A2xDI(7);
    a2_mul_2(2) := A2xDI(1);
    a2_mul_2(3) := A2xDI(2) xor A2xDI(7);
    a2_mul_2(4) := A2xDI(3) xor A2xDI(7);
    a2_mul_2(5) := A2xDI(4);
    a2_mul_2(6) := A2xDI(5);
    a2_mul_2(7) := A2xDI(6);

    -- 2*a3
    a3_mul_2(0) := A3xDI(7);
    a3_mul_2(1) := A3xDI(0) xor A3xDI(7);
    a3_mul_2(2) := A3xDI(1);
    a3_mul_2(3) := A3xDI(2) xor A3xDI(7);
    a3_mul_2(4) := A3xDI(3) xor A3xDI(7);
    a3_mul_2(5) := A3xDI(4);
    a3_mul_2(6) := A3xDI(5);
    a3_mul_2(7) := A3xDI(6);

    -- 3*a0 = 2 * a0 + a0
    a0_mul_3 := a0_mul_2 xor A0xDI;

    -- 3*a1 = 2 * a1 + a1
    a1_mul_3 := a1_mul_2 xor A1xDI;

    -- 3*a2 = 2 * a2 + a2
    a2_mul_3 := a2_mul_2 xor A2xDI;

    -- 3*a3 = 2 * a3 + a3
    a3_mul_3 := a3_mul_2 xor A3xDI;
    
    -- b0 = 2*a0 + 3*a1 + 1*a2 + 1*a3
    B0xDO <= a0_mul_2 xor a1_mul_3 xor A2xDI    xor A3xDI;

    -- b1 = 1*a0 + 2*a1 + 3*a2 + 1*a3
    B1xDO <= A0xDI    xor a1_mul_2 xor a2_mul_3 xor A3xDI;

    -- b2 = 1*a0 + 1*a1 + 2*a2 + 3*a3
    B2xDO <= A0xDI    xor A1xDI    xor a2_mul_2 xor a3_mul_3;

    -- b3 = 3*a0 + 1*a1 + 1*a2 + 2*a3
    B3xDO <= a0_mul_3 xor A1xDI    xor A2xDI    xor a3_mul_2;
    
  end process mix_columns_p;
  
                   
end behavorial;
