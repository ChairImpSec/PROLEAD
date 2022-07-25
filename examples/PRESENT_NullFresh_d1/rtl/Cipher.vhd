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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Cipher is
    Port ( clk      : in  STD_LOGIC;
           nReset   : in  STD_LOGIC;
		     dataIn1  : in  STD_LOGIC_VECTOR (3 downto 0);
           dataIn2  : in  STD_LOGIC_VECTOR (3 downto 0);
			  key      : in  STD_LOGIC_VECTOR (3 downto 0);
           dataOut1 : out STD_LOGIC_VECTOR (3 downto 0);
           dataOut2 : out STD_LOGIC_VECTOR (3 downto 0);
           done     : out STD_LOGIC);
end Cipher;

architecture Behavioral of Cipher is

----------------------------------------------------------
-- component declaration
----------------------------------------------------------
component p2_controler is
port(
	clk	: in std_logic;
	nReset	: in std_logic;
	selInit	: out std_logic;
	selP	: out std_logic;
	enKey	: out std_logic;
	enData	: out std_logic;
	round : out std_logic_vector(4 downto 0);
  	done    : out std_logic
);
end component p2_controler;

component dataBody is
    Port ( clk : in  STD_LOGIC;
           selInit	: in  STD_LOGIC;
           en 	: in  STD_LOGIC;
           selP	: in  STD_LOGIC;
           inputA : in  STD_LOGIC_VECTOR (3 downto 0);
           inputB : in  STD_LOGIC_VECTOR (3 downto 0);
           output : out  STD_LOGIC_VECTOR (3 downto 0));
end component dataBody;

component p2_keyschedule is
		Port ( clk : in  STD_LOGIC;
           selInit	: in  STD_LOGIC;
           en 	: in  STD_LOGIC;
           selP	: in  STD_LOGIC;
           counter : in STD_LOGIC_VECTOR(4 downto 0);
           inputA : in  STD_LOGIC_VECTOR (3 downto 0);
           inputB : in  STD_LOGIC_VECTOR (3 downto 0);
           outputA : out  STD_LOGIC_VECTOR (3 downto 0);
           outputB : out  STD_LOGIC_VECTOR (3 downto 0));
end component p2_keyschedule;

component sboxDAO is
 	port(
		sboxIn	: in std_logic_vector(3 downto 0);
		sboxOut: out std_logic_vector(3 downto 0)
		);

end component sboxDAO;

----------------------------------------------------------
-- data signals
----------------------------------------------------------
signal share1, share2 : STD_LOGIC_VECTOR (3 downto 0);
signal sboxIn1, sboxIn2 : STD_LOGIC_VECTOR (3 downto 0);
signal roundkey, keyRegKS: STD_LOGIC_VECTOR (3 downto 0);
signal md1Reg, md2Reg: STD_LOGIC_VECTOR (3 downto 0);
signal sboxKS: STD_LOGIC_VECTOR (3 downto 0);
signal stateRegInit, state, stateXORroundkey: STD_LOGIC_VECTOR (3 downto 0);
signal md1RegInit, md2RegInit: STD_LOGIC_VECTOR (3 downto 0);
signal done4, ANDstateXORroundkey, ANDmd1Reg, ANDmd2Reg : STD_LOGIC_VECTOR (3 downto 0);
signal intDone : STD_LOGIC;

----------------------------------------------------------
-- control signals
----------------------------------------------------------
signal rst_sbox : std_logic;
signal counter : STD_LOGIC_VECTOR (4 downto 0);

signal enData, enKey, selP, selInit : std_logic;


begin
----------------------------------------------------------
-- component instantiation
----------------------------------------------------------
----------------------------------------------------------
-- FSM
----------------------------------------------------------
fsm: p2_controler
		port map(
			clk => clk,
			nReset => nReset,
			selInit => selInit,
			selP => selP,
			enData => enData,
			enKey => enKey,
			round => counter,
			done => intDone
		);

----------------------------------------------------------
-- STATE register
----------------------------------------------------------
stateFF: dataBody
    Port map ( clk => clk,
           selInit => selInit,
           en => enData,
           selP => selP,
           inputA => stateRegInit,
           inputB => share1,
           output => state
			  );

----------------------------------------------------------
-- Data mask md1
----------------------------------------------------------
md1FF: dataBody
    Port map ( clk => clk,
           selInit => selInit,
           en => enData,
           selP => selP,
           inputA => md1RegInit,
           inputB => share2,
           output => md1Reg
			  );

----------------------------------------------------------
-- Key register
----------------------------------------------------------
keyFF: p2_keyschedule
    Port map ( clk => clk,
           selInit => selInit,
           en => enKey,
           selP => selP,
           counter => counter,
           inputA => key,
           inputB => sboxKS,
           outputA => roundkey,
           outputB => keyRegKS
			  );


----------------------------------------------------------
-- shared S-box component
----------------------------------------------------------
	sbox: ENTITY work.MaskedSbox
    Port map ( 
			  clk => clk,
			  input1 => sboxIn1,
			  input2 => sboxIn2,
			  output1 => share1,
			  output2 => share2
			  );

----------------------------------------------------------
-- shared S-box component
----------------------------------------------------------
sbox_KS: sboxDAO
    Port map ( 
           sboxIn => keyRegKS,
           sboxOut => sboxKS
			  );
			  

----------------------------------------------------------
-- masking of the input
----------------------------------------------------------

--DATA
stateRegInit <= dataIn1;
md1RegInit <=   dataIn2;

----------------------------------------------------------
-- XOR sums for the S-Box input
----------------------------------------------------------
stateXORroundkey <= state XOR roundkey;

----------------------------------------------------------
-- Sbox input MUXes
----------------------------------------------------------
sboxIn1 <= stateXORroundkey;
sboxIn2 <= md1Reg;
----------------------------------------------------------
-- unmasking of the output
----------------------------------------------------------
done <= intDone;

dataOut1 <= stateXORroundkey;
dataOut2 <= md1Reg;

end Behavioral;

