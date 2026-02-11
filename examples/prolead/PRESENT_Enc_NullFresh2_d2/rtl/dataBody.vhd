--
-- -----------------------------------------------------------------
-- COMPANY : Ruhr University Bochum
-- AUTHOR  : Amir Moradi amir.moradi@rub.de Aein Rezaei Shahmirzadi aein.rezaeishahmirzadi@rub.de
-- DOCUMENT: "Second-Order SCA Security with almost no Fresh Randomness" TCHES 2021, Issue 3
-- -----------------------------------------------------------------
--
-- Copyright c 2021, Amir Moradi, Aein Rezaei Shahmirzadi
--
-- All rights reserved.
--
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
-- ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
-- WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
-- DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTERS BE LIABLE FOR ANY
-- DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
-- INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
-- LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION HOWEVER CAUSED AND
-- ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
-- INCLUDING NEGLIGENCE OR OTHERWISE ARISING IN ANY WAY OUT OF THE USE OF THIS
-- SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
--
-- Please see LICENSE and README for license and further instructions.
--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity dataBody is
    Port ( clk 	: in  STD_LOGIC;
           selInit	: in  STD_LOGIC;
           en 	: in  STD_LOGIC;
           selP	: in  STD_LOGIC;
           inputA : in  STD_LOGIC_VECTOR (3 downto 0);
           inputB : in  STD_LOGIC_VECTOR (3 downto 0);
           output : out  STD_LOGIC_VECTOR (3 downto 0));
end dataBody;

architecture dfl of dataBody is

	component reg is
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
	end component reg;

	component pdata is
	port(
		dataIn	: in std_logic_vector(63 downto 0);
		dataOut:	out std_logic_vector(63 downto 0)
		);
	end component pdata;

	signal inputSer, outputSer : STD_LOGIC_VECTOR(3 DOWNTO 0);
	signal permIn : STD_LOGIC_VECTOR(63 DOWNTO 0);
	signal inputPar, outputPar : STD_LOGIC_VECTOR(63 DOWNTO 0);

	signal ENlatch : STD_LOGIC;
	signal clkEN   : STD_LOGIC;

begin

	latch: Process(clk, EN)
   begin
		if (clk = '0') then
			ENlatch <= EN;
		end if;
	end process;

	clkEN <= clk AND ENlatch;

	state: reg
	generic map(NBITS_D0=>4,
					NBITS_D1=>64)
	port map(
				clk => clkEN,
				sel => selP,
				D0 => inputSer,
				D1 => inputPar,
				Q0 => outputSer,
				Q1 => outputPar
				);

	permIn <= outputPar(63 downto 0);

	permutation: pdata
	port map(
				dataIn => permIn,
				dataOut => inputPar
				);

	inputSer <= inputA when selInit = '1'	else inputB;

	output <= outputSer;
	
end dfl;

