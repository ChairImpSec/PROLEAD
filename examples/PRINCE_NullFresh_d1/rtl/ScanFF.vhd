--
-----------------------------------------------------------------
-- COMPANY : Ruhr University Bochum
-- AUTHOR  : Amir Moradi (amir.moradi@rub.de) Aein Rezaei Shahmirzadi (aein.rezaeishahmirzadi@rub.de)
-- DOCUMENT: https://doi.org/10.46586/tches.v2021.i1.305-342
-- -----------------------------------------------------------------
--
-- Copyright (c) 2020, Amir Moradi, Aein Rezaei Shahmirzadi
--
-- All rights reserved.
--
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
-- ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
-- WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
-- DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTERS BE LIABLE FOR ANY
-- DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
-- (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
-- LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
-- ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
-- (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
-- SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
--
-- Please see LICENSE and README for license and further instructions.
--

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY ScanFF IS
	GENERIC (SIZE : integer);
	PORT ( CLK	: IN 	STD_LOGIC;
          SE 	: IN 	STD_LOGIC;
          D  	: IN 	STD_LOGIC_VECTOR((SIZE-1) DOWNTO 0);
          DS	: IN 	STD_LOGIC_VECTOR((SIZE-1) DOWNTO 0);
          Q 	: OUT STD_LOGIC_VECTOR((SIZE-1) DOWNTO 0));
END ScanFF;

ARCHITECTURE Behavioral of ScanFF is

component dflipfloplw is
	port(
                clk     : in  std_logic;
                sel	: in  std_logic;
                D0      : in  std_logic;
                D1    	: in  std_logic;
                Q       : out std_logic);
end component;

BEGIN
	
	GEN : FOR I IN 0 TO (SIZE-1) GENERATE	
		SFF : dflipfloplw
		PORT MAP (
			clk	=> CLK,
			sel	=> SE,
			D0	=> D(I),
			D1	=> DS(I),
			Q	=> Q(I));
	END GENERATE;
		
END Behavioral;


