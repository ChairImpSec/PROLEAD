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
--       ### gf2_mul.vhdl ###
--
--
-- Description:
-- Generic variant of GF(2^n----IAIK----IAIK----IAIK----IAIK----IAIK----IAIK----IAIK----IAIK----IAIK----
--
--                   VHDL model of masked multiplier, (c) IAIK
--                       !!! CONFIDENTIAL !!!
--
--                      !!! DO NOT MODIFY !!!
----------------------------------------------------------------------------
--       ### masked_mul.vhdl ###
--
--
-- Description:
-- Different variants of masked multipliers 
--   
--
-- Initial Version: Date: 22. September 2015 by Hannes Gross IAIK
--
------------------------------------------------------------------------------
library ieee;  use ieee.std_logic_1164.all; 

entity gf2_mul is
  generic ( 
    N     : integer       := 1 -- GF(2^n) multiplier
  );
  port (  
    AxDI  : in std_logic_vector(N-1 downto 0); --  A
    BxDI  : in std_logic_vector(N-1 downto 0); --  B
    -- Outputs
    QxDO  : out std_logic_vector(N-1 downto 0)  --  Q
  );
end gf2_mul;

-------------------------------------------------------------------

architecture behavorial of gf2_mul is 
  signal Q : std_logic_vector(N-1 downto 0); --  Q

begin

  -- GF(2^N) multiplier
  classic_mul_variant1: if N = 1 generate
    -- purpose: GF(2) multiplier
    -- type   : combinational
    -- inputs : 
    -- outputs: 
    gf2_1_mul: process (AxDI, BxDI) is
    begin  -- process gf2_1_mul
      Q <= AxDI and BxDI;
    end process gf2_1_mul;
  end generate classic_mul_variant1;

   classic_mul_variant2: if N = 2 generate
    -- purpose: GF(2) multiplier
    -- type   : combinational
    -- inputs : 
    -- outputs: 
    gf2_1_mul: process (AxDI, BxDI) is
        variable A      : std_logic_vector(N-1 downto 0); --  A
        variable B      : std_logic_vector(N-1 downto 0); --  B
        variable Q_norm : std_logic_vector(N-1 downto 0); --  B
        variable AandB  : std_logic;
    begin  -- process gf2_1_mul
      -- see https://online.tugraz.at/tug_online/voe_main2.getvolltext?pCurrPk=50621
      -- formula 10
      -- Linear mapping a*x + b |--> (a + b)*v + b*(x+1)
      A(0) := AxDI(0);
      A(1) := AxDI(1);-- xor  AxDI(0);
      B(0) := BxDI(0);
      B(1) := BxDI(1);-- xor  BxDI(0);
 
      Q_norm(0) := ((A(1) xor A(0)) and (B(1) xor B(0))) xor (A(0) and B(0));
      Q_norm(1) := ((A(1) xor A(0)) and (B(1) xor B(0))) xor (A(1) and B(1));

      -- Linear mapping from standard basis to normal basis
      Q(0) <= Q_norm(0);
      Q(1) <= Q_norm(1);-- xor Q_norm(0);
    end process gf2_1_mul;
  end generate classic_mul_variant2;
  
  classic_mul_variant4: if N = 4 generate
    -- purpose: GF(2) multiplier
    -- type   : combinational
    -- inputs : 
    -- outputs: 
    gf2_1_mul: process (AxDI, BxDI) is
      variable A      : std_logic_vector(3 downto 0); --  A
      variable B      : std_logic_vector(3 downto 0); --  B
      variable Q_norm : std_logic_vector(3 downto 0); --  Q
      variable PH     : std_logic_vector(1 downto 0); --  PH
      variable PL     : std_logic_vector(1 downto 0); --  PL
      variable P      : std_logic_vector(1 downto 0); --  P
      variable AA     : std_logic_vector(1 downto 0); --  AA
      variable BB     : std_logic_vector(1 downto 0); --  BB
    begin  -- process gf2_1_mul
      -- Linear mapping:
      A(3) := AxDI(3);--AxDI(0);
      A(2) := AxDI(2);--AxDI(3)xor AxDI(0);
      A(1) := AxDI(1);--AxDI(2);
      A(0) := AxDI(0);--AxDI(1);

      B(3) := BxDI(3);--BxDI(0);
      B(2) := BxDI(2);--BxDI(3)xor BxDI(0);
      B(1) := BxDI(1);--BxDI(2);
      B(0) := BxDI(0);--BxDI(1);

       -- Canright:
      -- HI MUL GF2^4 multiplier
      PH(0) := ((A(3) xor A(2)) and (B(3) xor B(2))) xor (A(2) and B(2));
      PH(1) := ((A(3) xor A(2)) and (B(3) xor B(2))) xor (A(3) and B(3));
      
      -- LO MUL GF2^4 multiplier
      PL(0) := ((A(1) xor A(0)) and (B(1) xor B(0))) xor (A(0) and B(0));
      PL(1) := ((A(1) xor A(0)) and (B(1) xor B(0))) xor (A(1) and B(1));

      -- MUL and SQUARE SCALE
      AA := (A(3) & A(2)) xor (A(1) & A(0));
      BB := (B(3) & B(2)) xor (B(1) & B(0));
      
      P(1) := ((AA(1) xor AA(0)) and (BB(1) xor BB(0))) xor (AA(0) and BB(0));
      P(0) := ((AA(1) xor AA(0)) and (BB(1) xor BB(0))) xor (AA(1) and BB(1)) xor P(1);

     -- Output assignment
      Q_norm := (PH xor P) & (PL xor P);
      
      -- Bilgin:
      --Q_norm(3) := (A(3) and B(3) ) xor ( A(1) and B(3) ) xor ( A(0) and B(3) ) xor ( A(2) and B(2) ) xor ( A(1) and B(2)) xor (A(3) and B(1) ) xor ( A(2) and B(1) ) xor ( A(1) and B(1) ) xor ( A(0) and B(1) ) xor ( A(3) and B(0)) xor (A(1) and B(0) );
      --Q_norm(2) := (A(2) and B(3) ) xor ( A(1) and B(3) ) xor ( A(3) and B(2) ) xor ( A(2) and B(2) ) xor ( A(0) and B(2)) xor (A(3) and B(1) ) xor ( A(1) and B(1) ) xor ( A(2) and B(0) ) xor ( A(0) and B(0) );
      --Q_norm(1) := (A(3) and B(3) ) xor ( A(2) and B(3) ) xor ( A(1) and B(3) ) xor ( A(0) and B(3) ) xor ( A(3) and B(2)) xor (A(1) and B(2) ) xor ( A(3) and B(1) ) xor ( A(2) and B(1) ) xor ( A(1) and B(1) ) xor ( A(3) and B(0)) xor (A(0) and B(0) );
      --Q_norm(0) := (A(3) and B(3) ) xor ( A(1) and B(3) ) xor ( A(2) and B(2) ) xor ( A(0) and B(2) ) xor ( A(3) and B(1)) xor (A(0) and B(1) ) xor ( A(2) and B(0) ) xor ( A(1) and B(0) ) xor ( A(0) and B(0) );

      -- Linear mapping:
      Q(3) <= Q_norm(3);
      Q(2) <= Q_norm(2);
      Q(1) <= Q_norm(1);
      Q(0) <= Q_norm(0);
      
    end process gf2_1_mul;
  end generate classic_mul_variant4;


  -- Output
  QxDO <= Q;
end behavorial;
