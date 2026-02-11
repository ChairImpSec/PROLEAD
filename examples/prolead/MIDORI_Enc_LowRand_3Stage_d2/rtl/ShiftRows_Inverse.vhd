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


ENTITY ShiftRows_Inverse IS
	PORT ( state : IN  STD_LOGIC_VECTOR (63 DOWNTO 0);
			 result : out  STD_LOGIC_VECTOR (63 downto 0));
END ShiftRows_Inverse;

ARCHITECTURE behavioral OF ShiftRows_Inverse IS
	BEGIN
		result <= state(63 downto 60) & state(35 downto 32) & state(7 downto  4) & state(27 downto 24) & state(43 downto 40) & state(55 downto 52) & state(19 downto 16) & state(15 downto 12) & state(3 downto  0) & state(31 downto 28) & state(59 downto 56) & state(39 downto 36) & state(23 downto 20) & state(11 downto  8) & state(47 downto 44) & state(51 downto 48);

END behavioral;

