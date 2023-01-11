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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity dataBody is
    Port ( clk 	: in  STD_LOGIC;
           selInit	: in  STD_LOGIC;
           en 	: in  STD_LOGIC;
           selP	: in  STD_LOGIC;
           inputA : in  STD_LOGIC_VECTOR (3 downto 0);
           inputB : in  STD_LOGIC_VECTOR (3 downto 0);
           TEST : out  STD_LOGIC_VECTOR (63 downto 0);
           output : out  STD_LOGIC_VECTOR (3 downto 0));
end dataBody;

architecture dfl of dataBody is


----------------------------------------------------------
-- component declaration
----------------------------------------------------------
component reg_en is
	generic (NBITS_D0: integer;
		 NBITS_D1: integer);
	port(
		clk	: in std_logic;
		en      : in std_logic;
		sel	: in std_logic;
		D0	: in std_logic_vector(NBITS_D0 - 1 downto 0);
		D1	: in std_logic_vector(NBITS_D1 - 1 downto 0);
		Q0	: out std_logic_vector(NBITS_D0 -1 downto 0);
		Q1	: out std_logic_vector(NBITS_D1 -1 downto 0)
		);
end component;

component pdata is
port(
	dataIn	: in std_logic_vector(63 downto 0);
	dataOut:	out std_logic_vector(63 downto 0)
	);
	
end component pdata;

----------------------------------------------------------
-- signal declaration
----------------------------------------------------------

signal inputSer, outputSer : STD_LOGIC_VECTOR(3 DOWNTO 0);
signal permIn : STD_LOGIC_VECTOR(63 DOWNTO 0);
signal inputPar, outputPar : STD_LOGIC_VECTOR(63 DOWNTO 0);

begin
----------------------------------------------------------
-- component instantiation
----------------------------------------------------------

state: reg_en
generic map(NBITS_D0=>4,
				NBITS_D1=>64)
	port map(
				clk => clk,
				en  => en,
				sel => selP,
				D0 => inputSer,
				D1 => inputPar,
				Q0 => outputSer,
				Q1 => outputPar
				);

--because of the piepline stage in S-box
permIn <= outputPar(59 downto 0)&inputSer;

permutation: pdata
	port map(
				dataIn => permIn,
				dataOut => inputPar
				);
----------------------------------------------------------
-- serial input Mux for initialization
----------------------------------------------------------
inputSer <= inputA when selInit = '1'
				else inputB;

output <= outputSer;

TEST <= outputPar;
end dfl;

