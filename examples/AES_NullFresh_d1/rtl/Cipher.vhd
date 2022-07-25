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

entity Cipher is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           input1 : in  STD_LOGIC_VECTOR (7 downto 0);
           input2 : in  STD_LOGIC_VECTOR (7 downto 0);
           key : in  STD_LOGIC_VECTOR (7 downto 0);
           output1 : out  STD_LOGIC_VECTOR (7 downto 0);
           output2 : out  STD_LOGIC_VECTOR (7 downto 0);
           Done : out  STD_LOGIC);
end Cipher;

architecture Behavioral of Cipher is
	COMPONENT Controller
	PORT(
		clk : IN std_logic;
		rst : IN std_logic;          
		ShowRcon : OUT std_logic;          
		KeyScheduleRegisterEN : OUT std_logic;
		DoSR : OUT std_logic;
		DoMC : OUT std_logic;
		state_reg_hold : OUT std_logic;
		key_reg_hold : OUT std_logic;
		DoKeySbox : OUT std_logic;
		JustFirstColShift : OUT std_logic;
		Done : OUT std_logic;
		CorrectCiphertext : OUT std_logic;
		output_sel : OUT std_logic;
		KeyIn_sel : OUT std_logic_vector(1 downto 0);
		SboxIn_sel : OUT std_logic_vector(1 downto 0);
		Rcon : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;
	
	signal State_xor_KeyScheduleWithoutAffine1							: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal State_xor_KeyScheduleWithoutAffine2							: STD_LOGIC_VECTOR (7 DOWNTO 0);
	
	signal Corr_63								: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal output1_A								: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal State_xor_AffinedKey1				: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal State_xor_AffinedKey2				: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal Affined_Inv_K0_xor_K12_1			: STD_LOGIC_VECTOR (7 DOWNTO 0);

	signal K_ciphertext1							: STD_LOGIC_VECTOR (7 DOWNTO 0);

	signal OutputReg_in1							: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal OutputReg_in2							: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal OutputReg1								: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal OutputReg2								: STD_LOGIC_VECTOR (7 DOWNTO 0);
	
	signal InputXorKey1							: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal InputXorKey2							: STD_LOGIC_VECTOR (7 DOWNTO 0);

	signal SboxIn1									: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal SboxIn2									: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal SboxOut1								: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal SboxOut2								: STD_LOGIC_VECTOR (7 DOWNTO 0);
	
	signal KeyIn1									: STD_LOGIC_VECTOR (7 DOWNTO 0);
	
	signal KeyOut1									: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal KeyToSbox1								: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal KeyForSchedule1						: STD_LOGIC_VECTOR (7 DOWNTO 0);
	
	signal KeySchedule_out1						: STD_LOGIC_VECTOR (7 DOWNTO 0);
	
	signal S0_output1								: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal S0_output2								: STD_LOGIC_VECTOR (7 DOWNTO 0);
	
	signal K0_xor_K12_1							: STD_LOGIC_VECTOR (7 DOWNTO 0);

	
	signal MCout_xor_SKey_1						: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal MCout_xor_SKey_2						: STD_LOGIC_VECTOR (7 DOWNTO 0);
	
	signal MCout_xor_K0_xor_K12_1				: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal MCout_xor_K0_xor_K12_2				: STD_LOGIC_VECTOR (7 DOWNTO 0);
	
	signal StateIn1								: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal StateIn2								: STD_LOGIC_VECTOR (7 DOWNTO 0);
	
	signal KeyScheduleRegisterEN				: STD_LOGIC;
	signal DoSR										: STD_LOGIC;
	signal DoMC										: STD_LOGIC;
	signal state_reg_hold						: STD_LOGIC;
	signal key_reg_hold							: STD_LOGIC;
	signal DoKeySbox								: STD_LOGIC;
	signal JustFirstColShift					: STD_LOGIC;
	signal CorrectCiphertext					: STD_LOGIC;
	signal Output_Sel								: STD_LOGIC;
	signal done_internal							: STD_LOGIC;
	signal KeyIn_sel								: STD_LOGIC_VECTOR (1 DOWNTO 0);
	signal SboxIn_sel								: STD_LOGIC_VECTOR (1 DOWNTO 0);
	signal Rcon_internal							: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal Rcon_1 									: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal Rcon_2				 					: STD_LOGIC_VECTOR (7 DOWNTO 0);
	-----
	signal ShowRcon								: STD_LOGIC;
	
begin
	
	InputXorKey1 	<= input1 xor key;
	InputXorKey2 	<= input2;
	
	K0_xor_K12_1 <= KeyOut1 xor KeyForSchedule1;
--	K0_xor_K12_2 <= KeyOut2 xor KeyForSchedule2;
	
	MCout_xor_SKey_1 <= S0_output1 xor KeySchedule_out1;
	MCout_xor_SKey_2 <= S0_output2;
	
	MCout_xor_K0_xor_K12_1 <= S0_output1 xor K0_xor_K12_1;
	MCout_xor_K0_xor_K12_2 <= S0_output2;
	
	State_xor_KeyScheduleWithoutAffine1 <= K_ciphertext1 xor S0_output1;
	State_xor_KeyScheduleWithoutAffine2 <= S0_output2;
	
	Affine_OutInv1: ENTITY work.Affine_output_inv
	Generic Map (Const => '1')
	Port Map (
		I	=> K0_xor_K12_1,
		O	=> Affined_Inv_K0_xor_K12_1 );


	State_xor_AffinedKey1 <= Affined_Inv_K0_xor_K12_1 xor S0_output1;
	State_xor_AffinedKey2 <= S0_output2;
	
	OutputReg_in1 <= State_xor_KeyScheduleWithoutAffine1 when (Output_Sel = '0') else State_xor_AffinedKey1;
	OutputReg_in2 <= State_xor_KeyScheduleWithoutAffine2 when (Output_Sel = '0') else State_xor_AffinedKey2;
	
	OutputReg: ENTITY work.regER 
	GENERIC Map ( size => 16)
	PORT Map ( 
		clk	=> clk,
		rst	=> rst,
		EN		=> done_internal,
		D(7 downto 0) 		=> OutputReg_in1,
		D(15 downto 8) 	=> OutputReg_in2,
		Q(7 downto 0)		=> OutputReg1,
		Q(15 downto 8)		=> OutputReg2);
		
	
	Corr_63 <= "00" & CorrectCiphertext & CorrectCiphertext & "0" & CorrectCiphertext & CorrectCiphertext & "0";
	output1 <= output1_A xor Corr_63;
	
	Affine_output_Inst: ENTITY work.Affine_outputC
		Port Map(OutputReg1, output1_A);
	Affine_outputC_Inst: ENTITY work.Affine_outputC
		Port Map(OutputReg2, output2);
	------------------------------- Rcon Condition -------------------------------
	
	Rcon_1 <= Rcon_internal  when (ShowRcon = '1') else x"00";
	Rcon_2 <= "00000000";
	------------------------------- State input Condition -------------------------------

	StateIn1 <= SboxOut1;
	StateIn2 <= SboxOut2;

	------------------------------- Sbox input Condition -------------------------------

	SboxInput_process: process (InputXorKey1, InputXorKey2, KeyToSbox1, MCout_xor_SKey_1,
										 MCout_xor_SKey_2, MCout_xor_K0_xor_K12_1, MCout_xor_K0_xor_K12_2, SboxIn_sel) is
	begin 

	if (SboxIn_sel = "00") then

		SboxIn1 <= InputXorKey1;
		SboxIn2 <= InputXorKey2;

	elsif (SboxIn_sel = "01") then

		SboxIn1 <= KeyToSbox1;
		SboxIn2 <= SboxIn_sel(1) & SboxIn_sel(1) & SboxIn_sel(1) & SboxIn_sel(1) & SboxIn_sel(1) & SboxIn_sel(1) & SboxIn_sel(1) & SboxIn_sel(1);

	elsif (SboxIn_sel = "10") then

		SboxIn1 <= MCout_xor_SKey_1;
		SboxIn2 <= MCout_xor_SKey_2;

	else

		SboxIn1 <= MCout_xor_K0_xor_K12_1;
		SboxIn2 <= MCout_xor_K0_xor_K12_2;

	end if;
	end process SboxInput_process;
	
	
	------------------------------- Key input Condition -------------------------------
	KeyInput_process: process (KeyIn_sel, key, KeySchedule_out1, K0_xor_K12_1  ) is
	begin 

	if (KeyIn_sel = "00") then

		KeyIn1 <= key;
			
	elsif (KeyIn_sel = "01") then
		
		KeyIn1 <= KeySchedule_out1;
	
	else --if (KeyIn_sel = "10") then
		
		KeyIn1 <= K0_xor_K12_1;

	end if;
	end process KeyInput_process;

	------------------------------- Key Schedule -------------------------------
	KeySchedule_Inst1: ENTITY work.KeySchedule 
	GENERIC MAP(1)
	PORT MAP(
		clk 		=> clk,
		KeyScheduleRegisterEN => KeyScheduleRegisterEN,
		ShowRcon => ShowRcon,
		Rcon 		=> Rcon_1,
		S_key1 	=> SboxOut1,
		S_key2 	=> SboxOut2,
		K0 		=> KeyOut1,
		Key_forCipherText => K_ciphertext1,
		Key_out 	=> KeySchedule_out1 );
	
	
	------------------------------- State Regs -------------------------------
	DataPath_Registers_Inst1: ENTITY work.DataPath_Registers 
	GENERIC MAP(0)
	PORT MAP(
		clk => clk,
		EN => state_reg_hold,
		StateIn => StateIn1,
		DoMC => DoMC,
		DoSR => DoSR,
		StateOut => S0_output1 );
		
	DataPath_Registers_Inst2: ENTITY work.DataPath_Registers 
	GENERIC MAP(1)
	PORT MAP(
		clk => clk,
		EN => state_reg_hold,
		StateIn => StateIn2,
		DoMC => DoMC,
		DoSR => DoSR,
		StateOut => S0_output2 );
		
	------------------------------- Key Regs -------------------------------		
	Key_Registers_INST1: ENTITY work.Key_Registers
	GENERIC MAP(1)	
	PORT MAP(
		clk 				=> clk,
		EN 				=> key_reg_hold,
		KeyIn 			=> KeyIn1,
		DoSbox 			=> DoKeySbox,
		JustFirstColShift => JustFirstColShift,
		KeyOut 			=> KeyOut1,
		KeyToSbox 		=> KeyToSbox1,
		KeyForSchedule => KeyForSchedule1 );

	------------------------------- Sbox -------------------------------
	GF256Inv_o_InputAffine_Inst1: Entity work.GF256Inv_o_InputAffine 
	PORT MAP(
		clk 			=> clk,
		input1 		=> SboxIn1,
		input2 		=> SboxIn2,
		output1 		=> SboxOut1,
		output2 		=> SboxOut2 );
		
		
	------------------------------- Controller -------------------------------
	Inst_Controller: Controller PORT MAP(
		clk => clk,
		rst => rst,
		KeyScheduleRegisterEN => KeyScheduleRegisterEN,
		ShowRcon => ShowRcon,
		DoSR => DoSR,
		DoMC => DoMC,
		state_reg_hold => state_reg_hold,
		key_reg_hold => key_reg_hold,
		DoKeySbox => DoKeySbox,
		JustFirstColShift => JustFirstColShift,
		Done => done_internal,
		CorrectCiphertext => CorrectCiphertext,
		output_sel => Output_Sel,
		KeyIn_sel => KeyIn_sel,
		SboxIn_sel => SboxIn_sel,
		Rcon => Rcon_internal
	);
		
	done_reg_gen: PROCESS(clk, done_internal)
	BEGIN
		IF RISING_EDGE(clk) THEN
			Done <= done_internal;
		END IF;
	END PROCESS;
		
end Behavioral;

