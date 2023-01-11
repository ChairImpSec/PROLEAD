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

--Template for clock gated state register with two inputs
--
--		D1
--		|
--	+---------------+
--  D0->|			|->Q0
--	+---------------+
--		|
--		Q1
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg is
	generic (NBITS_D0: integer;
		 NBITS_D1: integer);
	port(
		clk	: in std_logic;
		sel	: in std_logic;
		D0	: in std_logic_vector(NBITS_D0 - 1 downto 0);
		D1	: in std_logic_vector(NBITS_D1 - 1 downto 0);
		Q0	: out std_logic_vector(NBITS_D0 -1 downto 0);
		Q1	: out std_logic_vector(NBITS_D1 -1 downto 0)
		);

end entity reg;


architecture dfl of reg is

	signal intD0, intQ 	: std_logic_vector(NBITS_D1 - 1 downto 0);

begin

gen_ff:
FOR i in 1 to NBITS_D1/NBITS_D0 GENERATE
gff: entity work.ScanFF
	generic map(SIZE=>NBITS_D0)
	port map(
	CLK => clk,
	SE => sel,
	D  => intD0(NBITS_D0*i - 1 downto (i-1)*NBITS_D0),
      	DS => D1(NBITS_D0*i - 1 downto (i-1)*NBITS_D0),
      	Q => intQ(NBITS_D0*i - 1 downto (i-1)*NBITS_D0)
		);
		
		
END GENERATE gen_ff;

--regular case
intD0 <= intQ(NBITS_D1 - NBITS_D0 - 1 downto 0)&D0;

--special case for NBITS_D0 = NBITS_D1
--intD0 <= D0;

Q0 <= intQ(NBITS_D1 - 1 downto NBITS_D1 - NBITS_D0);
Q1 <= intQ;


end architecture;
