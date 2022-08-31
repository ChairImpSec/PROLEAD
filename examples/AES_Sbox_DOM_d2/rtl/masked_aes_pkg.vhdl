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
--       ### aes_top.vhdl ###
--
-- Description:
-- Types required for parameterized implementation
--
--
-- Initial Version: Date: 23. November 2015 by Hannes Gross IAIK
--
------------------------------------------------------------------------------
library ieee;  use ieee.std_logic_1164.all; 
               
package masked_aes_pkg is
  -- Subtypes

  -- Types
  type t_shared_gf2   is array(natural range <>) of std_logic_vector(1 downto 0);
  type t_shared_gf4   is array(natural range <>) of std_logic_vector(3 downto 0);
  type t_shared_gf8   is array(natural range <>) of std_logic_vector(7 downto 0);
  type t_shared_gf128 is array(natural range <>) of std_logic_vector(127 downto 0);
  type t_shared_gf18  is array(natural range <>) of std_logic_vector(17 downto 0);

  -- Functions
  
end masked_aes_pkg;


package body masked_aes_pkg is
  
end masked_aes_pkg;
