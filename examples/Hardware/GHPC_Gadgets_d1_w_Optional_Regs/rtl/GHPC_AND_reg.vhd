-------------------------------------------------------------------
-- COMPANY : Ruhr University Bochum
-- AUTHOR  : Amir Moradi (amir.moradi@rub.de) & David Knichel (david.knichel@rub.de)
-- DOCUMENT: https:--eprint.iacr.org/2021/569/
-- -----------------------------------------------------------------
--
--
-- Copyright (c) 2021, David Knichel, Amir Moradi, Nicolai Müller, Pascal Sasdrich
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

library work;

entity GHPC_AND_reg is
	Port(
		input1	: in  std_logic;
		input2	: in  std_logic;
		clk 	: in  std_logic;
		output	: out std_logic);
end GHPC_AND_reg;

architecture Behavioral of GHPC_AND_reg is 

	signal value		: std_logic;

begin
	
	value <= input1 AND input2;
        
        reg_gen: PROCESS(clk, value)
	BEGIN
	    IF RISING_EDGE(clk) THEN
	        output <= value;
	    END IF;
   	END PROCESS;

end Behavioral;
