--
-- -----------------------------------------------------------------
-- COMPANY : Ruhr University Bochum
-- AUTHOR  : Aein Rezaei Shahmirzadi (aein.rezaeishahmirzadi@rub.de)
-- DOCUMENT: "Low-Latency and Low-Randomness Second-Order Masked Cubic Functions", TCHES 2023, Issue 1.
-- -----------------------------------------------------------------
--
-- Copyright c 2021, Aein Rezaei Shahmirzadi
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

ENTITY roundConstant_MUX IS
	PORT ( round : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
			 enc_dec: IN STD_LOGIC;
			 roundConstant : OUT  STD_LOGIC_VECTOR (63 DOWNTO 0));
END roundConstant_MUX;

ARCHITECTURE behavioral OF roundConstant_MUX IS

	signal roundXORenc : std_logic_vector(3 downto 0);

BEGIN

	roundXORenc <= round XOR (enc_dec & enc_dec & enc_dec & enc_dec);

	WITH roundXORenc SELECT
		roundConstant <= x"0000000000000000" WHEN "0010",
							  x"13198a2e03707344" WHEN "0011",
							  x"a4093822299f31d0" WHEN "0100",
							  x"082efa98ec4e6c89" WHEN "0101",
							  x"452821e638d01377" WHEN "0110",
							  x"be5466cf34e90c6c" WHEN "0111",
							  x"7ef84f78fd955cb1" WHEN "1000",
							  x"85840851f1ac43aa" WHEN "1001",
							  x"c882d32f25323c54" WHEN "1010",
							  x"64a51195e0e3610d" WHEN "1011",
							  x"d3b5a399ca0c2399" WHEN "1100",
							  x"c0ac29b7c97c50dd" WHEN "1101",
							  (OTHERS => 'X')     WHEN OTHERS;
		
END behavioral;

