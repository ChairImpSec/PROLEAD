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

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY XOR_2n IS
	GENERIC ( size  : POSITIVE;
				 count : POSITIVE);
	PORT ( in0 	 : IN  STD_LOGIC_VECTOR ((size*count-1) DOWNTO 0);
			 in1 	 : IN  STD_LOGIC_VECTOR ((size*count-1) DOWNTO 0);
			 q 	 : OUT STD_LOGIC_VECTOR ((size*count-1) DOWNTO 0);
		    const : IN  STD_LOGIC_VECTOR ((size-1)       DOWNTO 0) := (others => '0'));			 
END XOR_2n;

ARCHITECTURE behavioral OF XOR_2n IS
BEGIN

	GEN1:
	FOR j IN 0 TO count-1 GENERATE
		GEN2:
		FOR i IN 0 TO size-1 GENERATE
			XORInst: ENTITY work.XOR_2
			Port Map (
				in0	=> in0(j*size+i),
				in1	=> in1(j*size+i),
				q		=> q(j*size+i),
				const => const(i));
		END GENERATE;
	END GENERATE;
	
END;

