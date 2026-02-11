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

ENTITY sBoxCombined IS
		PORT ( input0_s1  : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
				 input0_s2  : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
				 input0_s3  : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
				 
				 input1_s1  : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
				 input1_s2  : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
				 input1_s3  : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
				 r  : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
				 
				 sel			: IN STD_LOGIC;
				 clk			: IN STD_LOGIC;
				 
				 output0_s1 : OUT  STD_LOGIC_VECTOR (3 DOWNTO 0);
				 output0_s2 : OUT  STD_LOGIC_VECTOR (3 DOWNTO 0);
				 output0_s3 : OUT  STD_LOGIC_VECTOR (3 DOWNTO 0);
				 
				 output1_s1 : OUT  STD_LOGIC_VECTOR (3 DOWNTO 0);
				 output1_s2 : OUT  STD_LOGIC_VECTOR (3 DOWNTO 0);
				 output1_s3 : OUT  STD_LOGIC_VECTOR (3 DOWNTO 0));
END sBoxCombined;

ARCHITECTURE behavioral OF sBoxCombined IS
	COMPONENT PRINCESbox
	PORT(
		clk : IN std_logic;
		in1 : IN std_logic_vector(3 downto 0);
		in2 : IN std_logic_vector(3 downto 0);
		in3 : IN std_logic_vector(3 downto 0);
		r : IN std_logic_vector(15 downto 0);          
		out1 : OUT std_logic_vector(3 downto 0);
		out2 : OUT std_logic_vector(3 downto 0);
		out3 : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;
	
	signal InAffin_s1,
			 InAffin_s2,
			 InAffin_s3,
			 
			 Q2941in_s1,
			 Q2941in_s2,
			 Q2941in_s3,
			 
			 R1,
			 R2,
			 R3,
			 
			 Reg1in_s1,
			 Reg1in_s2,
			 Reg1in_s3,
			 
			 M1Affin_s1,
			 M1Affin_s2,
			 M1Affin_s3,
			 
			 Q2942in_s1,
			 Q2942in_s2,
			 Q2942in_s3,
			 
			 M2Affin_s1,
			 M2Affin_s2,
			 M2Affin_s3,
			 
			 Reg2in_s1,
			 Reg2in_s2,
			 Reg2in_s3,

			 Q2943in_s1,
			 Q2943in_s2,
			 Q2943in_s3,
			 
			 OutAffin_s1,
			 OutAffin_s2,
			 OutAffin_s3,
			 
			 SInvOut_s1,
			 SInvOut_s2,
			 SInvOut_s3 	: STD_LOGIC_VECTOR (3 DOWNTO 0);
	
BEGIN

	A_Pass_inst_s1: ENTITY work.A_Pass
	Port Map (
		input0	=> input0_s1,
		input1 	=> input1_s1,
		sel		=> sel,
		output	=> InAffin_s1);

	A_Pass_inst_s2: ENTITY work.A_PassC
	Port Map (
		input0	=> input0_s2,
		input1 	=> input1_s2,
		sel		=> sel,
		output	=> InAffin_s2);

	A_Pass_inst_s3: ENTITY work.A_Pass
	Port Map (
		input0	=> input0_s3,
		input1 	=> input1_s3,
		sel		=> sel,
		output	=> InAffin_s3);

	--------------------------------------------------
    Sub: PRINCESbox
	Port Map (
	    clk => clk,
		in1	=> InAffin_s1,
		in2	=> InAffin_s2,
		in3	=> InAffin_s3,
		r( 7 downto 0) => r,
		r(15 downto 8) => r,
		out1		=> SInvOut_s1,
		out2		=> SInvOut_s2,
		out3	=> SInvOut_s3);

	--------------------------------------------------

	A_inst_s1: ENTITY work.Affine
	Port Map (
		input		=> SInvOut_s1,
		output	=> output0_s1);

	A_inst_s2: ENTITY work.Affine
	Port Map (
		input		=> SInvOut_s2,
		output	=> output0_s2);

	A_inst_s3: ENTITY work.AffineC
	Port Map (
		input		=> SInvOut_s3,
		output	=> output0_s3);

	--------------------------------------------------
	
	output1_s1	<= SInvOut_s1;
	output1_s2	<= SInvOut_s2;
	output1_s3	<= SInvOut_s3;

END behavioral;

