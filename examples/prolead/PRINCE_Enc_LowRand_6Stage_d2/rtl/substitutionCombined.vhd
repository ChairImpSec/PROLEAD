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

ENTITY substitutionCombined IS
		PORT ( state0_s1  : IN  STD_LOGIC_VECTOR (63 DOWNTO 0);
				 state0_s2  : IN  STD_LOGIC_VECTOR (63 DOWNTO 0);
				 state0_s3  : IN  STD_LOGIC_VECTOR (63 DOWNTO 0);
				 
				 state1_s1  : IN  STD_LOGIC_VECTOR (63 DOWNTO 0);
				 state1_s2  : IN  STD_LOGIC_VECTOR (63 DOWNTO 0);
				 state1_s3  : IN  STD_LOGIC_VECTOR (63 DOWNTO 0);
				 r          : IN  STD_LOGIC_VECTOR (37 DOWNTO 0);
				 
				 sel			: IN STD_LOGIC;
				 clk			: IN STD_LOGIC;
				 
				 result0_s1 : OUT  STD_LOGIC_VECTOR (63 DOWNTO 0);
				 result0_s2 : OUT  STD_LOGIC_VECTOR (63 DOWNTO 0);
				 result0_s3 : OUT  STD_LOGIC_VECTOR (63 DOWNTO 0);
				 
				 result1_s1 : OUT  STD_LOGIC_VECTOR (63 DOWNTO 0);
				 result1_s2 : OUT  STD_LOGIC_VECTOR (63 DOWNTO 0);
				 result1_s3 : OUT  STD_LOGIC_VECTOR (63 DOWNTO 0));
END substitutionCombined;

ARCHITECTURE behavioral OF substitutionCombined IS
	

	
BEGIN

	substition_PRINCE:
		FOR i IN 0 TO 15 GENERATE
			sBoxCombined_PRINCE: Entity work.sBoxCombined
				PORT MAP ( input0_s1  => state0_s1(((i+1) * 4 - 1) DOWNTO i*4),
							  input0_s2  => state0_s2(((i+1) * 4 - 1) DOWNTO i*4),
							  input0_s3  => state0_s3(((i+1) * 4 - 1) DOWNTO i*4),
							  
							  input1_s1  => state1_s1(((i+1) * 4 - 1) DOWNTO i*4),
							  input1_s2  => state1_s2(((i+1) * 4 - 1) DOWNTO i*4),
							  input1_s3  => state1_s3(((i+1) * 4 - 1) DOWNTO i*4),
							  r  => r,
							  
							  sel		 	 => sel,
							  clk		 	 => clk,
							  
							  output0_s1 => result0_s1(((i+1) * 4 - 1) DOWNTO i*4),
							  output0_s2 => result0_s2(((i+1) * 4 - 1) DOWNTO i*4),
							  output0_s3 => result0_s3(((i+1) * 4 - 1) DOWNTO i*4),
							  
							  output1_s1 => result1_s1(((i+1) * 4 - 1) DOWNTO i*4),
							  output1_s2 => result1_s2(((i+1) * 4 - 1) DOWNTO i*4),
							  output1_s3 => result1_s3(((i+1) * 4 - 1) DOWNTO i*4));
		END GENERATE;
		
END behavioral;

