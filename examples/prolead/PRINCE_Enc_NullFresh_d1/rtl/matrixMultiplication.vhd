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

ENTITY matrixMultiplication IS
	PORT ( state : IN  STD_LOGIC_VECTOR (63 DOWNTO 0);
			 result : OUT  STD_LOGIC_VECTOR (63 DOWNTO 0));
END matrixMultiplication;

ARCHITECTURE behavioral OF matrixMultiplication IS	
	BEGIN
		result(63) <= state(59) XOR state(55) XOR state(51);
		result(62) <= state(62) XOR state(54) XOR state(50);
		result(61) <= state(61) XOR state(57) XOR state(49);
		result(60) <= state(60) XOR state(56) XOR state(52);
		result(59) <= state(63) XOR state(59) XOR state(55);
		result(58) <= state(58) XOR state(54) XOR state(50);
		result(57) <= state(61) XOR state(53) XOR state(49);
		result(56) <= state(60) XOR state(56) XOR state(48);
		result(55) <= state(63) XOR state(59) XOR state(51);
		result(54) <= state(62) XOR state(58) XOR state(54);
		result(53) <= state(57) XOR state(53) XOR state(49);
		result(52) <= state(60) XOR state(52) XOR state(48);
		result(51) <= state(63) XOR state(55) XOR state(51);
		result(50) <= state(62) XOR state(58) XOR state(50);
		result(49) <= state(61) XOR state(57) XOR state(53);
		result(48) <= state(56) XOR state(52) XOR state(48);
		
		result(47) <= state(47) XOR state(43) XOR state(39);
		result(46) <= state(42) XOR state(38) XOR state(34);
		result(45) <= state(45) XOR state(37) XOR state(33);
		result(44) <= state(44) XOR state(40) XOR state(32);
		result(43) <= state(47) XOR state(43) XOR state(35);
		result(42) <= state(46) XOR state(42) XOR state(38);
		result(41) <= state(41) XOR state(37) XOR state(33);
		result(40) <= state(44) XOR state(36) XOR state(32);
		result(39) <= state(47) XOR state(39) XOR state(35);
		result(38) <= state(46) XOR state(42) XOR state(34);
		result(37) <= state(45) XOR state(41) XOR state(37);
		result(36) <= state(40) XOR state(36) XOR state(32);
		result(35) <= state(43) XOR state(39) XOR state(35);
		result(34) <= state(46) XOR state(38) XOR state(34);
		result(33) <= state(45) XOR state(41) XOR state(33);
		result(32) <= state(44) XOR state(40) XOR state(36);
		
		result(31) <= state(31) XOR state(27) XOR state(23);
		result(30) <= state(26) XOR state(22) XOR state(18);
		result(29) <= state(29) XOR state(21) XOR state(17);
		result(28) <= state(28) XOR state(24) XOR state(16);
		result(27) <= state(31) XOR state(27) XOR state(19);
		result(26) <= state(30) XOR state(26) XOR state(22);
		result(25) <= state(25) XOR state(21) XOR state(17);
		result(24) <= state(28) XOR state(20) XOR state(16);
		result(23) <= state(31) XOR state(23) XOR state(19);
		result(22) <= state(30) XOR state(26) XOR state(18);
		result(21) <= state(29) XOR state(25) XOR state(21);
		result(20) <= state(24) XOR state(20) XOR state(16);
		result(19) <= state(27) XOR state(23) XOR state(19);
		result(18) <= state(30) XOR state(22) XOR state(18);
		result(17) <= state(29) XOR state(25) XOR state(17);
		result(16) <= state(28) XOR state(24) XOR state(20);
		
		result(15) <= state(11) XOR state(7) XOR state(3);
		result(14) <= state(14) XOR state(6) XOR state(2);
		result(13) <= state(13) XOR state(9) XOR state(1);
		result(12) <= state(12) XOR state(8) XOR state(4);
		result(11) <= state(15) XOR state(11) XOR state(7);
		result(10) <= state(10) XOR state(6) XOR state(2);
		result(9) <= state(13) XOR state(5) XOR state(1);
		result(8) <= state(12) XOR state(8) XOR state(0);
		result(7) <= state(15) XOR state(11) XOR state(3);
		result(6) <= state(14) XOR state(10) XOR state(6);
		result(5) <= state(9) XOR state(5) XOR state(1);
		result(4) <= state(12) XOR state(4) XOR state(0);
		result(3) <= state(15) XOR state(7) XOR state(3);
		result(2) <= state(14) XOR state(10) XOR state(2);
		result(1) <= state(13) XOR state(9) XOR state(5);
		result(0) <= state(8) XOR state(4) XOR state(0);
END behavioral;

