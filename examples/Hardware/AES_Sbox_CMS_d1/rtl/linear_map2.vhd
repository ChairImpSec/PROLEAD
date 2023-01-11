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
--       ### lin_map.vhdl ###
--
--
-- Description:
-- Input and output linear transformation of the AES S-Box 
--   
--
-- Initial Version: Date: 9. October 2015 by Hannes Gross IAIK
--
------------------------------------------------------------------------------
library ieee;  use ieee.std_logic_1164.all; 

entity linear_map2 is
  generic (
    MATRIX_SEL : string := "MX" -- X^-1... S-Box input, MX... S-Box output
    );
  port (  
    -- Inputs
    DataInxDI   : in std_logic_vector(7 downto 0);
    -- Outputs
    DataOutxDO  : out std_logic_vector(7 downto 0) 
  );
end linear_map2;

-------------------------------------------------------------------

architecture behavorial of linear_map2 is
  -- Matrix type definition
  type matrix is array (0 to 7, 0 to 7) of std_logic;
begin
  -----------------------------------------------------------------
  -- AES input transformation
  input_matrix: if MATRIX_SEL = "X^-1" generate    
    -- purpose: does the matrix multiplication
    -- type   : combinational
    -- inputs : 
    -- outputs: 
    mapping_p: process (DataInxDI) is
      variable Q : std_logic_vector(7 downto 0);
      variable INV_X : matrix;
    begin  -- process mapping_p
      INV_X :=(('1', '1', '1', '0', '0', '1', '1', '1'),
               ('0', '1', '1', '1', '0', '0', '0', '1'),
               ('0', '1', '1', '0', '0', '0', '1', '1'),
               ('1', '1', '1', '0', '0', '0', '0', '1'),
               ('1', '0', '0', '1', '1', '0', '1', '1'),
               ('0', '0', '0', '0', '0', '0', '0', '1'),
               ('0', '1', '1', '0', '0', '0', '0', '1'),
               ('0', '1', '0', '0', '1', '1', '1', '1'));
      
      -- Matrix multiplication
      Q := (others => '0');
      for y in 0 to 7 loop
              for x in 0 to 7 loop
                Q(7-y) := Q(7-y) xor (DataInxDI(7-x) and INV_X(y,x)); 
              end loop;  -- x
      end loop;  -- y
      
      DataOutxDO <= Q;
    end process mapping_p;   
  end generate input_matrix;
  
  -----------------------------------------------------------------
  -- AES output transformation
  output_matrix: if MATRIX_SEL = "MX" generate    
    -- purpose: does the matrix multiplication
    -- type   : combinational
    -- inputs : 
    -- outputs: 
    mapping_p: process (DataInxDI) is
      variable Q : std_logic_vector(7 downto 0);
      variable MX : matrix;
      
      variable b : std_logic_vector(7 downto 0);
    begin  -- process mapping_p
       MX :=(('0', '0', '1', '0', '1', '0', '0', '0'),
             ('1', '0', '0', '0', '1', '0', '0', '0'),
             ('0', '1', '0', '0', '0', '0', '0', '1'),
             ('1', '0', '1', '0', '1', '0', '0', '0'),
             ('1', '1', '1', '1', '1', '0', '0', '0'),
             ('0', '1', '1', '0', '1', '1', '0', '1'),
             ('0', '0', '1', '1', '0', '0', '1', '0'),
             ('0', '1', '0', '1', '0', '0', '1', '0'));
      
      -- Matrix multiplication
      Q := (others => '0');
      for y in 0 to 7 loop
              for x in 0 to 7 loop
                Q(7-y) := Q(7-y) xor (DataInxDI(7-x) and MX(y,x)); 
              end loop;  -- x
      end loop;  -- y
      DataOutxDO <= Q;
    end process mapping_p;   
  end generate output_matrix;

  

end behavorial;
