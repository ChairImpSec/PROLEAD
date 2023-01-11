--
-- -----------------------------------------------------------------
-- COMPANY : Ruhr University Bochum
-- AUTHOR  : Aein Rezaei Shahmirzadi (aein.rezaeishahmirzadi@rub.de)
-- DOCUMENT: "Cryptanalysis of Efficient Masked Ciphers: Applications to Low Latency" TCHES 2022, Issue 1
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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.functions.all;

ENTITY MixOneColumn IS
	PORT ( s0  : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
			 s1  : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
			 s2  : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
			 s3  : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
			 r0  : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
			 r1  : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
			 r2  : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
			 r3  : OUT STD_LOGIC_VECTOR (3 DOWNTO 0));
END MixOneColumn;

ARCHITECTURE behavioral OF MixOneColumn IS	
	signal v0_0, v0_1, v0_2, v0_3 : STD_LOGIC_VECTOR (3 DOWNTO 0);
	signal v1_0, v1_1, v1_2, v1_3 : STD_LOGIC_VECTOR (3 DOWNTO 0);
	signal v2_0, v2_1, v2_2, v2_3 : STD_LOGIC_VECTOR (3 DOWNTO 0);
	signal v3_0, v3_1, v3_2, v3_3 : STD_LOGIC_VECTOR (3 DOWNTO 0);
	
	constant C_2 : STD_LOGIC_VECTOR (3 DOWNTO 0) := x"2";
	constant C_4 : STD_LOGIC_VECTOR (3 DOWNTO 0) := x"4";
	constant C_5 : STD_LOGIC_VECTOR (3 DOWNTO 0) := x"5";
	constant C_6 : STD_LOGIC_VECTOR (3 DOWNTO 0) := x"6";
	constant C_8 : STD_LOGIC_VECTOR (3 DOWNTO 0) := x"8";
	constant C_9 : STD_LOGIC_VECTOR (3 DOWNTO 0) := x"9";
	constant C_A : STD_LOGIC_VECTOR (3 DOWNTO 0) := x"A";
	constant C_B : STD_LOGIC_VECTOR (3 DOWNTO 0) := x"B";
	constant C_E : STD_LOGIC_VECTOR (3 DOWNTO 0) := x"E";
	constant C_F : STD_LOGIC_VECTOR (3 DOWNTO 0) := x"F";

BEGIN

	v0_0(0) <= (C_4(0) AND s0(0)) XOR (C_4(1) AND s0(3)) XOR (C_4(2) AND s0(2)) XOR (C_4(3) AND s0(1));
	v0_0(1) <= (C_4(0) AND s0(1)) XOR (C_4(1) AND s0(0)) XOR (C_4(2) AND s0(3)) XOR (C_4(3) AND s0(2)) XOR (C_4(1) AND s0(3)) XOR (C_4(2) AND s0(2)) XOR (C_4(3) AND s0(1));
	v0_0(2) <= (C_4(0) AND s0(2)) XOR (C_4(1) AND s0(1)) XOR (C_4(2) AND s0(0)) XOR (C_4(3) AND s0(3)) XOR (C_4(2) AND s0(3)) XOR (C_4(3) AND s0(2));
	v0_0(3) <= (C_4(0) AND s0(3)) XOR (C_4(1) AND s0(2)) XOR (C_4(2) AND s0(1)) XOR (C_4(3) AND s0(0)) XOR (C_4(3) AND s0(3));
		
	v0_1(0) <= (C_8(0) AND s0(0)) XOR (C_8(1) AND s0(3)) XOR (C_8(2) AND s0(2)) XOR (C_8(3) AND s0(1));
	v0_1(1) <= (C_8(0) AND s0(1)) XOR (C_8(1) AND s0(0)) XOR (C_8(2) AND s0(3)) XOR (C_8(3) AND s0(2)) XOR (C_8(1) AND s0(3)) XOR (C_8(2) AND s0(2)) XOR (C_8(3) AND s0(1));
	v0_1(2) <= (C_8(0) AND s0(2)) XOR (C_8(1) AND s0(1)) XOR (C_8(2) AND s0(0)) XOR (C_8(3) AND s0(3)) XOR (C_8(2) AND s0(3)) XOR (C_8(3) AND s0(2));
	v0_1(3) <= (C_8(0) AND s0(3)) XOR (C_8(1) AND s0(2)) XOR (C_8(2) AND s0(1)) XOR (C_8(3) AND s0(0)) XOR (C_8(3) AND s0(3));
		
	v0_2(0) <= (C_B(0) AND s0(0)) XOR (C_B(1) AND s0(3)) XOR (C_B(2) AND s0(2)) XOR (C_B(3) AND s0(1));
	v0_2(1) <= (C_B(0) AND s0(1)) XOR (C_B(1) AND s0(0)) XOR (C_B(2) AND s0(3)) XOR (C_B(3) AND s0(2)) XOR (C_B(1) AND s0(3)) XOR (C_B(2) AND s0(2)) XOR (C_B(3) AND s0(1));
	v0_2(2) <= (C_B(0) AND s0(2)) XOR (C_B(1) AND s0(1)) XOR (C_B(2) AND s0(0)) XOR (C_B(3) AND s0(3)) XOR (C_B(2) AND s0(3)) XOR (C_B(3) AND s0(2));
	v0_2(3) <= (C_B(0) AND s0(3)) XOR (C_B(1) AND s0(2)) XOR (C_B(2) AND s0(1)) XOR (C_B(3) AND s0(0)) XOR (C_B(3) AND s0(3));
		
	v0_3(0) <= (C_2(0) AND s0(0)) XOR (C_2(1) AND s0(3)) XOR (C_2(2) AND s0(2)) XOR (C_2(3) AND s0(1));
	v0_3(1) <= (C_2(0) AND s0(1)) XOR (C_2(1) AND s0(0)) XOR (C_2(2) AND s0(3)) XOR (C_2(3) AND s0(2)) XOR (C_2(1) AND s0(3)) XOR (C_2(2) AND s0(2)) XOR (C_2(3) AND s0(1));
	v0_3(2) <= (C_2(0) AND s0(2)) XOR (C_2(1) AND s0(1)) XOR (C_2(2) AND s0(0)) XOR (C_2(3) AND s0(3)) XOR (C_2(2) AND s0(3)) XOR (C_2(3) AND s0(2));
	v0_3(3) <= (C_2(0) AND s0(3)) XOR (C_2(1) AND s0(2)) XOR (C_2(2) AND s0(1)) XOR (C_2(3) AND s0(0)) XOR (C_2(3) AND s0(3));
		
	------
	
	v1_0 <= s1; -- MUL by 1
	
	v1_1(0) <= (C_6(0) AND s1(0)) XOR (C_6(1) AND s1(3)) XOR (C_6(2) AND s1(2)) XOR (C_6(3) AND s1(1));
	v1_1(1) <= (C_6(0) AND s1(1)) XOR (C_6(1) AND s1(0)) XOR (C_6(2) AND s1(3)) XOR (C_6(3) AND s1(2)) XOR (C_6(1) AND s1(3)) XOR (C_6(2) AND s1(2)) XOR (C_6(3) AND s1(1));
	v1_1(2) <= (C_6(0) AND s1(2)) XOR (C_6(1) AND s1(1)) XOR (C_6(2) AND s1(0)) XOR (C_6(3) AND s1(3)) XOR (C_6(2) AND s1(3)) XOR (C_6(3) AND s1(2));
	v1_1(3) <= (C_6(0) AND s1(3)) XOR (C_6(1) AND s1(2)) XOR (C_6(2) AND s1(1)) XOR (C_6(3) AND s1(0)) XOR (C_6(3) AND s1(3));
		
		
	v1_2(0) <= (C_E(0) AND s1(0)) XOR (C_E(1) AND s1(3)) XOR (C_E(2) AND s1(2)) XOR (C_E(3) AND s1(1));
	v1_2(1) <= (C_E(0) AND s1(1)) XOR (C_E(1) AND s1(0)) XOR (C_E(2) AND s1(3)) XOR (C_E(3) AND s1(2)) XOR (C_E(1) AND s1(3)) XOR (C_E(2) AND s1(2)) XOR (C_E(3) AND s1(1));
	v1_2(2) <= (C_E(0) AND s1(2)) XOR (C_E(1) AND s1(1)) XOR (C_E(2) AND s1(0)) XOR (C_E(3) AND s1(3)) XOR (C_E(2) AND s1(3)) XOR (C_E(3) AND s1(2));
	v1_2(3) <= (C_E(0) AND s1(3)) XOR (C_E(1) AND s1(2)) XOR (C_E(2) AND s1(1)) XOR (C_E(3) AND s1(0)) XOR (C_E(3) AND s1(3));
		
	v1_3(0) <= (C_2(0) AND s1(0)) XOR (C_2(1) AND s1(3)) XOR (C_2(2) AND s1(2)) XOR (C_2(3) AND s1(1));
	v1_3(1) <= (C_2(0) AND s1(1)) XOR (C_2(1) AND s1(0)) XOR (C_2(2) AND s1(3)) XOR (C_2(3) AND s1(2)) XOR (C_2(1) AND s1(3)) XOR (C_2(2) AND s1(2)) XOR (C_2(3) AND s1(1));
	v1_3(2) <= (C_2(0) AND s1(2)) XOR (C_2(1) AND s1(1)) XOR (C_2(2) AND s1(0)) XOR (C_2(3) AND s1(3)) XOR (C_2(2) AND s1(3)) XOR (C_2(3) AND s1(2));
	v1_3(3) <= (C_2(0) AND s1(3)) XOR (C_2(1) AND s1(2)) XOR (C_2(2) AND s1(1)) XOR (C_2(3) AND s1(0)) XOR (C_2(3) AND s1(3));
		
	-------
	
	v2_0(0) <= (C_2(0) AND s2(0)) XOR (C_2(1) AND s2(3)) XOR (C_2(2) AND s2(2)) XOR (C_2(3) AND s2(1));
	v2_0(1) <= (C_2(0) AND s2(1)) XOR (C_2(1) AND s2(0)) XOR (C_2(2) AND s2(3)) XOR (C_2(3) AND s2(2)) XOR (C_2(1) AND s2(3)) XOR (C_2(2) AND s2(2)) XOR (C_2(3) AND s2(1));
	v2_0(2) <= (C_2(0) AND s2(2)) XOR (C_2(1) AND s2(1)) XOR (C_2(2) AND s2(0)) XOR (C_2(3) AND s2(3)) XOR (C_2(2) AND s2(3)) XOR (C_2(3) AND s2(2));
	v2_0(3) <= (C_2(0) AND s2(3)) XOR (C_2(1) AND s2(2)) XOR (C_2(2) AND s2(1)) XOR (C_2(3) AND s2(0)) XOR (C_2(3) AND s2(3));
		
	v2_1(0) <= (C_5(0) AND s2(0)) XOR (C_5(1) AND s2(3)) XOR (C_5(2) AND s2(2)) XOR (C_5(3) AND s2(1));
	v2_1(1) <= (C_5(0) AND s2(1)) XOR (C_5(1) AND s2(0)) XOR (C_5(2) AND s2(3)) XOR (C_5(3) AND s2(2)) XOR (C_5(1) AND s2(3)) XOR (C_5(2) AND s2(2)) XOR (C_5(3) AND s2(1));
	v2_1(2) <= (C_5(0) AND s2(2)) XOR (C_5(1) AND s2(1)) XOR (C_5(2) AND s2(0)) XOR (C_5(3) AND s2(3)) XOR (C_5(2) AND s2(3)) XOR (C_5(3) AND s2(2));
	v2_1(3) <= (C_5(0) AND s2(3)) XOR (C_5(1) AND s2(2)) XOR (C_5(2) AND s2(1)) XOR (C_5(3) AND s2(0)) XOR (C_5(3) AND s2(3));
				
	v2_2(0) <= (C_A(0) AND s2(0)) XOR (C_A(1) AND s2(3)) XOR (C_A(2) AND s2(2)) XOR (C_A(3) AND s2(1));
	v2_2(1) <= (C_A(0) AND s2(1)) XOR (C_A(1) AND s2(0)) XOR (C_A(2) AND s2(3)) XOR (C_A(3) AND s2(2)) XOR (C_A(1) AND s2(3)) XOR (C_A(2) AND s2(2)) XOR (C_A(3) AND s2(1));
	v2_2(2) <= (C_A(0) AND s2(2)) XOR (C_A(1) AND s2(1)) XOR (C_A(2) AND s2(0)) XOR (C_A(3) AND s2(3)) XOR (C_A(2) AND s2(3)) XOR (C_A(3) AND s2(2));
	v2_2(3) <= (C_A(0) AND s2(3)) XOR (C_A(1) AND s2(2)) XOR (C_A(2) AND s2(1)) XOR (C_A(3) AND s2(0)) XOR (C_A(3) AND s2(3));
		
	v2_3(0) <= (C_F(0) AND s2(0)) XOR (C_F(1) AND s2(3)) XOR (C_F(2) AND s2(2)) XOR (C_F(3) AND s2(1));
	v2_3(1) <= (C_F(0) AND s2(1)) XOR (C_F(1) AND s2(0)) XOR (C_F(2) AND s2(3)) XOR (C_F(3) AND s2(2)) XOR (C_F(1) AND s2(3)) XOR (C_F(2) AND s2(2)) XOR (C_F(3) AND s2(1));
	v2_3(2) <= (C_F(0) AND s2(2)) XOR (C_F(1) AND s2(1)) XOR (C_F(2) AND s2(0)) XOR (C_F(3) AND s2(3)) XOR (C_F(2) AND s2(3)) XOR (C_F(3) AND s2(2));
	v2_3(3) <= (C_F(0) AND s2(3)) XOR (C_F(1) AND s2(2)) XOR (C_F(2) AND s2(1)) XOR (C_F(3) AND s2(0)) XOR (C_F(3) AND s2(3));
		
	-------
	
	v3_0(0) <= (C_2(0) AND s3(0)) XOR (C_2(1) AND s3(3)) XOR (C_2(2) AND s3(2)) XOR (C_2(3) AND s3(1));
	v3_0(1) <= (C_2(0) AND s3(1)) XOR (C_2(1) AND s3(0)) XOR (C_2(2) AND s3(3)) XOR (C_2(3) AND s3(2)) XOR (C_2(1) AND s3(3)) XOR (C_2(2) AND s3(2)) XOR (C_2(3) AND s3(1));
	v3_0(2) <= (C_2(0) AND s3(2)) XOR (C_2(1) AND s3(1)) XOR (C_2(2) AND s3(0)) XOR (C_2(3) AND s3(3)) XOR (C_2(2) AND s3(3)) XOR (C_2(3) AND s3(2));
	v3_0(3) <= (C_2(0) AND s3(3)) XOR (C_2(1) AND s3(2)) XOR (C_2(2) AND s3(1)) XOR (C_2(3) AND s3(0)) XOR (C_2(3) AND s3(3));
		
	v3_1(0) <= (C_6(0) AND s3(0)) XOR (C_6(1) AND s3(3)) XOR (C_6(2) AND s3(2)) XOR (C_6(3) AND s3(1));
	v3_1(1) <= (C_6(0) AND s3(1)) XOR (C_6(1) AND s3(0)) XOR (C_6(2) AND s3(3)) XOR (C_6(3) AND s3(2)) XOR (C_6(1) AND s3(3)) XOR (C_6(2) AND s3(2)) XOR (C_6(3) AND s3(1));
	v3_1(2) <= (C_6(0) AND s3(2)) XOR (C_6(1) AND s3(1)) XOR (C_6(2) AND s3(0)) XOR (C_6(3) AND s3(3)) XOR (C_6(2) AND s3(3)) XOR (C_6(3) AND s3(2));
	v3_1(3) <= (C_6(0) AND s3(3)) XOR (C_6(1) AND s3(2)) XOR (C_6(2) AND s3(1)) XOR (C_6(3) AND s3(0)) XOR (C_6(3) AND s3(3));

	v3_2(0) <= (C_9(0) AND s3(0)) XOR (C_9(1) AND s3(3)) XOR (C_9(2) AND s3(2)) XOR (C_9(3) AND s3(1));
	v3_2(1) <= (C_9(0) AND s3(1)) XOR (C_9(1) AND s3(0)) XOR (C_9(2) AND s3(3)) XOR (C_9(3) AND s3(2)) XOR (C_9(1) AND s3(3)) XOR (C_9(2) AND s3(2)) XOR (C_9(3) AND s3(1));
	v3_2(2) <= (C_9(0) AND s3(2)) XOR (C_9(1) AND s3(1)) XOR (C_9(2) AND s3(0)) XOR (C_9(3) AND s3(3)) XOR (C_9(2) AND s3(3)) XOR (C_9(3) AND s3(2));
	v3_2(3) <= (C_9(0) AND s3(3)) XOR (C_9(1) AND s3(2)) XOR (C_9(2) AND s3(1)) XOR (C_9(3) AND s3(0)) XOR (C_9(3) AND s3(3));

	v3_3(0) <= (C_B(0) AND s3(0)) XOR (C_B(1) AND s3(3)) XOR (C_B(2) AND s3(2)) XOR (C_B(3) AND s3(1));
	v3_3(1) <= (C_B(0) AND s3(1)) XOR (C_B(1) AND s3(0)) XOR (C_B(2) AND s3(3)) XOR (C_B(3) AND s3(2)) XOR (C_B(1) AND s3(3)) XOR (C_B(2) AND s3(2)) XOR (C_B(3) AND s3(1));
	v3_3(2) <= (C_B(0) AND s3(2)) XOR (C_B(1) AND s3(1)) XOR (C_B(2) AND s3(0)) XOR (C_B(3) AND s3(3)) XOR (C_B(2) AND s3(3)) XOR (C_B(3) AND s3(2));
	v3_3(3) <= (C_B(0) AND s3(3)) XOR (C_B(1) AND s3(2)) XOR (C_B(2) AND s3(1)) XOR (C_B(3) AND s3(0)) XOR (C_B(3) AND s3(3));

	
	------------------------------------------
	
	r0 <= v3_0 XOR v2_0 XOR v1_0 XOR v0_0;
	r1 <= v3_1 XOR v2_1 XOR v1_1 XOR v0_1;
	r2 <= v3_2 XOR v2_2 XOR v1_2 XOR v0_2;
	r3 <= v3_3 XOR v2_3 XOR v1_3 XOR v0_3;
	
	
END behavioral;

