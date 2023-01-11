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

ENTITY L IS
	PORT ( 
			 e : IN STD_LOGIC_VECTOR (8 DOWNTO 1);
			 f : IN STD_LOGIC_VECTOR (4 DOWNTO 1);
			 g : IN STD_LOGIC_VECTOR (8 DOWNTO 1);
			 h : IN STD_LOGIC_VECTOR (8 DOWNTO 1);
			 a : OUT STD_LOGIC_VECTOR (2 DOWNTO 1);
			 b : OUT STD_LOGIC_VECTOR (2 DOWNTO 1);
			 c : OUT STD_LOGIC_VECTOR (2 DOWNTO 1);
			 d : OUT STD_LOGIC_VECTOR (2 DOWNTO 1));
END L;

architecture Behavioral of L is

begin

 
	XORInst1: ENTITY work.XOR_4
	Port Map (
		in0	=> e(1),
		in1	=> e(2),
		in2	=> e(3),
		in3	=> e(4),
		q		=> a(1) );
		
	XORInst2: ENTITY work.XOR_4
	Port Map (
		in0	=> e(5),
		in1	=> e(6),
		in2	=> e(7),
		in3	=> e(8),
		q		=> a(2) );
		
	--------------------------------------------
	
	XORInst3: ENTITY work.XOR_2
	Port Map (
		in0	=> f(1),
		in1	=> f(2),
		q		=> b(1) );
		
	XORInst4: ENTITY work.XOR_2
	Port Map (
		in0	=> f(3),
		in1	=> f(4),
		q		=> b(2) );
		
	--------------------------------------------
	
	XORInst5: ENTITY work.XOR_4
	Port Map (
		in0	=> g(1),
		in1	=> g(2),
		in2	=> g(3),
		in3	=> g(4),
		q		=> c(1) );
		
	XORInst6: ENTITY work.XOR_4
	Port Map (
		in0	=> g(5),
		in1	=> g(6),
		in2	=> g(7),
		in3	=> g(8),
		q		=> c(2) );
		
	--------------------------------------------
	
	XORInst7: ENTITY work.XOR_4
	Port Map (
		in0	=> h(1),
		in1	=> h(2),
		in2	=> h(3),
		in3	=> h(4),
		q		=> d(1) );
		
	XORInst8: ENTITY work.XOR_4
	Port Map (
		in0	=> h(5),
		in1	=> h(6),
		in2	=> h(7),
		in3	=> h(8),
		q		=> d(2) );
	
end Behavioral;

