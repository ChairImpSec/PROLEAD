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

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Reg_2 is
	GENERIC ( size: POSITIVE);
	Port (  clk		:  IN  STD_LOGIC;
			  D1 : in  STD_LOGIC_VECTOR (size-1 downto 0);
           D2 : in  STD_LOGIC_VECTOR (size-1 downto 0);
           Q1 : out  STD_LOGIC_VECTOR (size-1 downto 0);
           Q2 : out  STD_LOGIC_VECTOR (size-1 downto 0));
end Reg_2;

architecture Behavioral of Reg_2 is

begin

	
	Reg1: ENTITY work.reg
	GENERIC map ( size => size)
	PORT map ( 
		clk 	=> clk,
		D 		=> D1,
		Q 		=> Q1);
		
	Reg2: ENTITY work.reg
	GENERIC map ( size => size)
	PORT map ( 
		clk 	=> clk,
		D 		=> D2,
		Q 		=> Q2);
		
		
end Behavioral;

