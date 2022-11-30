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
use IEEE.NUMERIC_STD.ALL;


entity LED128Enc is
    Port ( clk 			: in  STD_LOGIC;
           rst 			: in  STD_LOGIC;
           Plaintext0 	: in  STD_LOGIC_VECTOR ( 63 downto 0);
           Plaintext1 	: in  STD_LOGIC_VECTOR ( 63 downto 0);
           Plaintext2 	: in  STD_LOGIC_VECTOR ( 63 downto 0);
           Key0 			: in  STD_LOGIC_VECTOR (127 downto 0);
           Key1 			: in  STD_LOGIC_VECTOR (127 downto 0);
           Key2 			: in  STD_LOGIC_VECTOR (127 downto 0);
           r	 			: in  STD_LOGIC_VECTOR (71 downto 0);
           Ciphertext0 	: out STD_LOGIC_VECTOR ( 63 downto 0);
           Ciphertext1 	: out STD_LOGIC_VECTOR ( 63 downto 0);
           Ciphertext2 	: out STD_LOGIC_VECTOR ( 63 downto 0);
           done 			: out STD_LOGIC);
end LED128Enc;

architecture Behavioral of LED128Enc is

	COMPONENT LED128_Controller
	PORT(
		rst : IN std_logic;
		clk : IN std_logic;          
		AddKey : OUT std_logic;
		SelKey : OUT std_logic;
		RoundFunctionEN : OUT std_logic;
		done : OUT std_logic;
		FSM : OUT std_logic_vector(5 downto 0)
		);
	END COMPONENT;
	
	
	
	constant SboxTable : STD_LOGIC_VECTOR (63 DOWNTO 0) := x"C56B90AD3EF84712";

	-------------------------------

	signal StateRegInput 						: STD_LOGIC_VECTOR(63 downto 0);
	signal StateRegOutput						: STD_LOGIC_VECTOR(63 downto 0);
	signal AddRoundKeyOutput					: STD_LOGIC_VECTOR(63 downto 0);
	signal AddKeyMUXOutput						: STD_LOGIC_VECTOR(63 downto 0);
	signal AddConstInput							: STD_LOGIC_VECTOR(31 downto 0);
	signal AddConstOutput						: STD_LOGIC_VECTOR(31 downto 0);
	signal SubCellInput							: STD_LOGIC_VECTOR(63 downto 0);
	signal tmp										: STD_LOGIC_VECTOR(63 downto 0);
	signal SubCellOutput							: STD_LOGIC_VECTOR(63 downto 0);
	signal ShiftRowsInput						: STD_LOGIC_VECTOR(63 downto 0);
	signal ShiftRowsOutput						: STD_LOGIC_VECTOR(63 downto 0);
	signal Feedback								: STD_LOGIC_VECTOR(63 downto 0);
	signal RoundKey								: STD_LOGIC_VECTOR(63 downto 0);
	signal CiphertextRegIn						: STD_LOGIC_VECTOR(63 downto 0);
	
	signal K0										: STD_LOGIC_VECTOR(63 downto 0);
	signal K1										: STD_LOGIC_VECTOR(63 downto 0);
	
	signal FSM										: STD_LOGIC_VECTOR(5            downto 0);
	signal FSMUpdate								: STD_LOGIC_VECTOR(5            downto 0);
	signal FSMSelected							: STD_LOGIC_VECTOR(5            downto 0);
	signal AddKey									: STD_LOGIC;
	signal SelKey									: STD_LOGIC;
	signal done_internal							: STD_LOGIC;
	signal RoundFunctionEN						: STD_LOGIC;
	
	signal SubCellInput0							: STD_LOGIC_VECTOR(63 downto 0);
	signal SubCellOutput0						: STD_LOGIC_VECTOR(63 downto 0);
	signal SubCellInput1							: STD_LOGIC_VECTOR(63 downto 0);
	signal SubCellOutput1						: STD_LOGIC_VECTOR(63 downto 0);
	signal SubCellInput2							: STD_LOGIC_VECTOR(63 downto 0);
	signal SubCellOutput2						: STD_LOGIC_VECTOR(63 downto 0);

begin

	LED_RoundFunction0: ENTITY work.LED_RoundFunction 
	PORT MAP(
		clk => clk,
		rst => rst,
		EN => RoundFunctionEN,
		AddKey => AddKey,
		SelKey => SelKey,
		FSM => FSM,
		Plaintext => Plaintext0,
		Key => Key0,
		SubCellOutput => SubCellOutput0,
		SubCellInput => SubCellInput0,
		Ciphertext => Ciphertext0
	);
	
	LED_RoundFunction1: ENTITY work.LED_RoundFunction 
	PORT MAP(
		clk => clk,
		rst => rst,
		EN => RoundFunctionEN,
		AddKey => AddKey,
		SelKey => SelKey,
		FSM => (others => '0'),
		Plaintext => Plaintext1,
		Key => Key1,
		SubCellOutput => SubCellOutput1,
		SubCellInput => SubCellInput1,
		Ciphertext => Ciphertext1 );
	
	LED_RoundFunction2: ENTITY work.LED_RoundFunction 
	PORT MAP(
		clk => clk,
		rst => rst,
		EN => RoundFunctionEN,
		AddKey => AddKey,
		SelKey => SelKey,
		FSM => (others => '0'),
		Plaintext => Plaintext2,
		Key => Key2,
		SubCellOutput => SubCellOutput2,
		SubCellInput => SubCellInput2,
		Ciphertext => Ciphertext2 );
		
	
	Inst_SubCell_Multi: entity WORK.SubCell_Multi 
	GENERIC Map ( count => 16)
	PORT MAP(
		clk => clk,
		in0 => SubCellInput0,
		in1 => SubCellInput1,
		in2 => SubCellInput2,
		r => r,
		EN => RoundFunctionEN,
		out0 => SubCellOutput0,
		out1 => SubCellOutput1,
		out2 => SubCellOutput2
	);
	
	-------------------------------------
	LED128_Controller_Inst: LED128_Controller PORT MAP(
		rst => rst,
		clk => clk,
		AddKey => AddKey,
		SelKey => SelKey,
		RoundFunctionEN => RoundFunctionEN,
		done => done_internal,
		FSM => FSM );

	----------------
	done			<= done_internal;	

end Behavioral;

