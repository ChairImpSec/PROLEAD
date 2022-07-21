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
--       ### square_scaler.vhdl ###
--
--
-- Description:
-- Square sacler in GF(2^4) respectively GF(2) over normal basis 
--   
--
-- Initial Version: Date: 9. October 2015 by Hannes Gross IAIK
--
------------------------------------------------------------------------------
library ieee;  use ieee.std_logic_1164.all; 

entity square_scaler is
  port (  
    -- Inputs
    DataInxDI   : in std_logic_vector(3 downto 0);
    -- Outputs
    DataOutxDO  : out std_logic_vector(3 downto 0) 
  );
end square_scaler;

-------------------------------------------------------------------

architecture behavorial of square_scaler is

begin
  -----------------------------------------------------------------
  -- purpose: Performs purely linear square scaling
  -- type   : combinational
  -- inputs : 
  -- outputs: 
  sqr_scl_p: process (DataInxDI) is
  begin  -- process sqr_scl_p
    -- Output
    DataOutxDO(3) <= DataInxDI(0) xor DataInxDI(2);
    DataOutxDO(2) <= DataInxDI(1) xor DataInxDI(3);    
    DataOutxDO(1) <= DataInxDI(1) xor DataInxDI(0);
    DataOutxDO(0) <= DataInxDI(0);
  end process sqr_scl_p;
  

end behavorial;
