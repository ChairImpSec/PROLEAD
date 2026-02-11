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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Cipher is
    Port ( clk      : in  STD_LOGIC;
           nReset   : in  STD_LOGIC;
			  r		  : in  STD_LOGIC_VECTOR (7 downto 0);
		     dataIn1  : in  STD_LOGIC_VECTOR (3 downto 0);
           dataIn2  : in  STD_LOGIC_VECTOR (3 downto 0);
           dataIn3  : in  STD_LOGIC_VECTOR (3 downto 0);
			  key1     : in  STD_LOGIC_VECTOR (3 downto 0);
			  key2     : in  STD_LOGIC_VECTOR (3 downto 0);
			  key3     : in  STD_LOGIC_VECTOR (3 downto 0);
           dataOut1 : out STD_LOGIC_VECTOR (3 downto 0);
           dataOut2 : out STD_LOGIC_VECTOR (3 downto 0);
           dataOut3 : out STD_LOGIC_VECTOR (3 downto 0);
           done     : out STD_LOGIC);
end Cipher;

architecture Behavioral of Cipher is
	COMPONENT PRESENTSbox
	PORT(
		clk : IN std_logic;
		in1 : IN std_logic_vector(3 downto 0);
		in2 : IN std_logic_vector(3 downto 0);
		in3 : IN std_logic_vector(3 downto 0);
		r : IN std_logic_vector(7 downto 0);          
		out1 : OUT std_logic_vector(3 downto 0);
		out2 : OUT std_logic_vector(3 downto 0);
		out3 : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;
	
	component p2_controler is
	port(
		clk	: in std_logic;
		nReset	: in std_logic;
		selInit	: out std_logic;
		selP	: out std_logic;
		selSbox	: out std_logic;
		enKey	: out std_logic;
		enData	: out std_logic;
		round : out std_logic_vector(4 downto 0);
		done    : out std_logic);
	end component p2_controler;

	component dataBody is
   Port ( 
		clk : in  STD_LOGIC;
		selInit	: in  STD_LOGIC;
		en 	: in  STD_LOGIC;
		selP	: in  STD_LOGIC;
		inputA : in  STD_LOGIC_VECTOR (3 downto 0);
		inputB : in  STD_LOGIC_VECTOR (3 downto 0);
		output : out  STD_LOGIC_VECTOR (3 downto 0));
	end component dataBody;

	component p2_keyschedule is
	Port ( 
		clk : in  STD_LOGIC;
		selInit	: in  STD_LOGIC;
		en 	: in  STD_LOGIC;
		selP	: in  STD_LOGIC;
		counter : in STD_LOGIC_VECTOR(4 downto 0);
		inputA : in  STD_LOGIC_VECTOR (3 downto 0);
		inputB : in  STD_LOGIC_VECTOR (3 downto 0);
		outputA : out  STD_LOGIC_VECTOR (3 downto 0);
		outputB : out  STD_LOGIC_VECTOR (3 downto 0));
	end component p2_keyschedule;
	
	---------------------------------------------------------
	signal share1, share2, share3             : STD_LOGIC_VECTOR (3 downto 0);
	signal AddKeyOut1, AddKeyOut2, AddKeyOut3 : STD_LOGIC_VECTOR (3 downto 0);
	signal sboxIn1,  sboxIn2,  sboxIn3        : STD_LOGIC_VECTOR (3 downto 0);
	signal sboxOut1, sboxOut2, sboxOut3       : STD_LOGIC_VECTOR (3 downto 0);
	signal roundkey1, roundkey2, roundkey3    : STD_LOGIC_VECTOR (3 downto 0);
	signal keyRegKS1, keyRegKS2, keyRegKS3    : STD_LOGIC_VECTOR (3 downto 0);
	signal md1Reg, md2Reg, md3Reg             : STD_LOGIC_VECTOR (3 downto 0);
	signal ANDmd1Reg, ANDmd2Reg, ANDmd3Reg    : STD_LOGIC_VECTOR (3 downto 0);
	signal intDone 								   : STD_LOGIC;

	signal counter 	 							   : STD_LOGIC_VECTOR (4 downto 0);
	signal enData, enKey                      : std_logic;
	signal selP, selInit, selSbox             : std_logic;

begin
	
	fsm: p2_controler
		port map(
			clk => clk,
			nReset => nReset,
			selInit => selInit,
			selP => selP,
			selSbox => selSbox,
			enData => enData,
			enKey => enKey,
			round => counter,
			done => intDone
		);

	----------------------------------------------------------
	state1FF: dataBody
    Port map ( clk => clk,
           selInit => selInit,
           en => enData,
           selP => selP,
           inputA => dataIn1,
           inputB => sboxOut1,
           output => md1Reg
			  );

	state2FF: dataBody
    Port map ( clk => clk,
           selInit => selInit,
           en => enData,
           selP => selP,
           inputA => dataIn2,
           inputB => sboxOut2,
           output => md2Reg
			  );

	state3FF: dataBody
    Port map ( clk => clk,
           selInit => selInit,
           en => enData,
           selP => selP,
           inputA => dataIn3,
           inputB => sboxOut3,
           output => md3Reg
			  );
	
	----------------------------------------------------------			  
	key1FF: p2_keyschedule
    Port map ( clk => clk,
           selInit => selInit,
           en => enKey,
           selP => selP,
           counter => counter,
           inputA => key1,
           inputB => sboxOut1,
           outputA => roundkey1,
           outputB => keyRegKS1
			  );

	key2FF: p2_keyschedule
    Port map ( clk => clk,
           selInit => selInit,
           en => enKey,
           selP => selP,
           counter => (others => '0'),
           inputA => key2,
           inputB => sboxOut2,
           outputA => roundkey2,
           outputB => keyRegKS2
			  );

	key3FF: p2_keyschedule
    Port map ( clk => clk,
           selInit => selInit,
           en => enKey,
           selP => selP,
           counter => (others => '0'),
           inputA => key3,
           inputB => sboxOut3,
           outputA => roundkey3,
           outputB => keyRegKS3
			  );

	----------------------------------------------------------
	AddKeyOut1 <= md1Reg XOR roundkey1;
	AddKeyOut2 <= md2Reg XOR roundkey2;
	AddKeyOut3 <= md3Reg XOR roundkey3;

	----------------------------------------------------------

	mux1: entity work.MUX
	 Generic Map (size => 4)
	 Port Map (
			  sel => selSbox,
			  D1	=> AddKeyOut1,
			  D0  => keyRegKS1,
			  Q	=> sboxIn1);

	mux2: entity work.MUX
	 Generic Map (size => 4)
	 Port Map (
			  sel => selSbox,
			  D1	=> AddKeyOut2,
			  D0  => keyRegKS2,
			  Q	=> sboxIn2);

	mux3: entity work.MUX
	 Generic Map (size => 4)
	 Port Map (
			  sel => selSbox,
			  D1	=> AddKeyOut3,
			  D0  => keyRegKS3,
			  Q	=> sboxIn3);

	----------------------------------------------------------
	sbox: PRESENTSbox
    Port map ( 
			  clk => clk,
			  in1 => sboxIn1,
			  in2 => sboxIn2,
			  in3 => sboxIn3,
			  r	 => r,
			  out1 => sboxOut1,
			  out2 => sboxOut2,
			  out3 => sboxOut3
			  );

	----------------------------------------------------------
	dataOut1 <= sboxIn1;
	dataOut2 <= sboxIn2;
	dataOut3 <= sboxIn3;

	----------------------------------------------------------
	done <= intDone;

end Behavioral;

