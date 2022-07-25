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

-- This is the P-layer of PRESENT
-- created with tools/permutation.c
--63 62 ... 1 0
--  | |
--  \ /
--63 47 ...16 0
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pdata is
port(
	dataIn	: in std_logic_vector(63 downto 0);
	dataOut:	out std_logic_vector(63 downto 0)
	);
	
end entity pdata;

architecture dfl of pdata is

begin

dataOut <=dataIn(63)&dataIn(59)&dataIn(55)&dataIn(51)&dataIn(47)&dataIn(43)&dataIn(39)&dataIn(35)&dataIn(31)&dataIn(27)&dataIn(23)&dataIn(19)&dataIn(15)&dataIn(11)&dataIn(7)&dataIn(3)&dataIn(62)&dataIn(58)&dataIn(54)&dataIn(50)&dataIn(46)&dataIn(42)&dataIn(38)&dataIn(34)&dataIn(30)&dataIn(26)&dataIn(22)&dataIn(18)&dataIn(14)&dataIn(10)&dataIn(6)&dataIn(2)&dataIn(61)&dataIn(57)&dataIn(53)&dataIn(49)&dataIn(45)&dataIn(41)&dataIn(37)&dataIn(33)&dataIn(29)&dataIn(25)&dataIn(21)&dataIn(17)&dataIn(13)&dataIn(9)&dataIn(5)&dataIn(1)&dataIn(60)&dataIn(56)&dataIn(52)&dataIn(48)&dataIn(44)&dataIn(40)&dataIn(36)&dataIn(32)&dataIn(28)&dataIn(24)&dataIn(20)&dataIn(16)&dataIn(12)&dataIn(8)&dataIn(4)&dataIn(0);


end architecture dfl;
