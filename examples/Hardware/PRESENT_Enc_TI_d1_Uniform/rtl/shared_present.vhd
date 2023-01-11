----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:08:35 05/22/2009 
-- Design Name: 
-- Module Name:    shared_present - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity shared_present is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  data_in1 : in  STD_LOGIC_VECTOR (63 downto 0);
			  data_in2 : in  STD_LOGIC_VECTOR (63 downto 0);
			  data_in3 : in  STD_LOGIC_VECTOR (63 downto 0);
           key  : in  STD_LOGIC_VECTOR (79 downto 0);
           data_out1 : out  STD_LOGIC_VECTOR (63 downto 0);
           data_out2 : out  STD_LOGIC_VECTOR (63 downto 0);
           data_out3 : out  STD_LOGIC_VECTOR (63 downto 0);
           done : out  STD_LOGIC);
end shared_present;

architecture dfl of shared_present is

----------------------------------------------------------
-- component declaration
----------------------------------------------------------
component controler is
port(
	clk	: in std_logic;
	reset	: in std_logic;
	ctrlData: out std_logic_vector(2 downto 0);
	ctrlKey : out std_logic_vector(2 downto 0);
	round : out std_logic_vector(4 downto 0);
	enSboxReg : out std_logic;
  	done    : out std_logic;
	final   : out std_logic
);
end component controler;


component dataBody is
    Port ( clk : in  STD_LOGIC;
           ctrl : in  STD_LOGIC_VECTOR (2 downto 0);
           inputA : in  STD_LOGIC_VECTOR (63 downto 0);
           inputB : in  STD_LOGIC_VECTOR (3 downto 0);
           output : out  STD_LOGIC_VECTOR (3 downto 0));
end component dataBody;

component keyschedule is
		Port ( clk : in  STD_LOGIC;
           ctrl : in  STD_LOGIC_VECTOR (2 downto 0);
			  counter : in STD_LOGIC_VECTOR(4 downto 0);
           inputA : in  STD_LOGIC_VECTOR (79 downto 0);
           inputB : in  STD_LOGIC_VECTOR (3 downto 0);
           outputA : out  STD_LOGIC_VECTOR (3 downto 0);
           outputB : out  STD_LOGIC_VECTOR (3 downto 0));
end component keyschedule;

component sharedSbox is
    Port ( sboxIn1 : in  STD_LOGIC_VECTOR (3 downto 0);
           sboxIn2 : in  STD_LOGIC_VECTOR (3 downto 0);
           sboxIn3 : in  STD_LOGIC_VECTOR (3 downto 0);
           clk : in  STD_LOGIC;
			  en  : in  STD_LOGIC;
           share1 : out  STD_LOGIC_VECTOR (3 downto 0);
           share2 : out  STD_LOGIC_VECTOR (3 downto 0);
           share3 : out  STD_LOGIC_VECTOR (3 downto 0));
end component sharedSbox;

component dflipfloplw1in is
	generic (NBITS: integer);
	port(
			 clk     : in std_logic;
			 en		: in std_logic;
			 D       : in std_logic_vector(NBITS-1 downto 0);
			 Q       : out std_logic_vector(NBITS-1 downto 0)
			 );
end component dflipfloplw1in;

component Sbox is
    Port ( sboxIn  : in  STD_LOGIC_VECTOR (3 downto 0);
           sboxOut : out  STD_LOGIC_VECTOR (3 downto 0));
end component;

component greg2 is
	generic (NBITS_D0: integer;
		      NBITS_D1: integer);
	port(
		clk  : in std_logic;
		en	  : in  std_logic;
		D	  : in  std_logic_vector(NBITS_D0 - 1 downto 0);
		Q	  : out std_logic_vector(NBITS_D1 - 1 downto 0));
end component greg2;

component dflipflop1 is
	port(
			 clk     : in std_logic;
			 D       : in std_logic;
			 Q       : out std_logic
			 );
end component dflipflop1;

----------------------------------------------------------
-- data signals
----------------------------------------------------------
signal share1, share2, share3 : STD_LOGIC_VECTOR (3 downto 0);
signal sboxIn1, sboxIn2, sboxIn3 : STD_LOGIC_VECTOR (3 downto 0);
signal roundkey, keyRegKS: STD_LOGIC_VECTOR (3 downto 0);
signal md1Reg, md2Reg: STD_LOGIC_VECTOR (3 downto 0);
signal state, sboxOut : STD_LOGIC_VECTOR (3 downto 0);
signal enSboxReg : STD_LOGIC;
signal intDone : STD_LOGIC;
signal final   : STD_LOGIC;
----------------------------------------------------------
-- control signals
----------------------------------------------------------
signal counter : STD_LOGIC_VECTOR (4 downto 0);
signal ctrlData: STD_LOGIC_VECTOR (2 downto 0);
signal ctrlKey: STD_LOGIC_VECTOR (2 downto 0);


begin
----------------------------------------------------------
-- component instantiation
----------------------------------------------------------
----------------------------------------------------------
-- FSM
----------------------------------------------------------
fsm: controler
		port map(
			clk => clk,
			reset => reset,
			ctrlData => ctrlData,
			ctrlKey => ctrlKey,
			round => counter,
			enSboxReg => enSboxReg,
			done => intDone,
			final => final
		);

----------------------------------------------------------
-- STATE register
----------------------------------------------------------
stateFF: dataBody
    Port map ( clk => clk,
           ctrl => ctrlData,
           inputA => data_in1,
           inputB => share1,
           output => state
			  );

----------------------------------------------------------
-- Data mask md1
----------------------------------------------------------
md1FF: dataBody
    Port map ( clk => clk,
           ctrl => ctrlData,
           inputA => data_in2,
           inputB => share2,
           output => md1Reg
			  );

----------------------------------------------------------
-- Data mask md2
----------------------------------------------------------
md2FF: dataBody
    Port map ( clk => clk,
           ctrl => ctrlData,
           inputA => data_in3,
           inputB => share3,
           output => md2reg
			  );

----------------------------------------------------------
-- Key register
----------------------------------------------------------
keyFF: keyschedule
    Port map ( clk => clk,
           ctrl => ctrlKey,
			  counter => counter,
           inputA => key,
           inputB => sboxOut,
           outputA => roundkey,
           outputB => keyRegKS
			  );

----------------------------------------------------------
-- S-box component
----------------------------------------------------------
sboxInst: Sbox
    Port map ( 
           sboxIn  => keyRegKS,
           sboxOut => sboxOut );

----------------------------------------------------------
-- shared S-box component
----------------------------------------------------------
sboxTI: sharedSbox
    Port map ( 
			  clk => clk,
			  en  => enSboxReg,
           sboxIn1 => sboxIn1,
           sboxIn2 => sboxIn2,
           sboxIn3 => sboxIn3,
           share1 => share1,
           share2 => share2,
           share3 => share3
			  );

----------------------------------------------------------
-- Sbox input MUXes
----------------------------------------------------------
sboxIn1 <= state XOR roundkey;
sboxIn2 <= md1Reg;
sboxIn3 <= md2Reg;
----------------------------------------------------------
-- making of the output
----------------------------------------------------------

DoneReg: dflipflop1
	Port map(
		clk   => clk,
		D     => final,
		Q     => done);

DataOutReg1: greg2 
	generic map(NBITS_D0 => 4, NBITS_D1 => 64)
	port map(
		clk   => clk,
		en		=> intDone,
		D     => sboxIn1,
		Q     => data_out1);

DataOutReg2: greg2 
	generic map(NBITS_D0 => 4, NBITS_D1 => 64)
	Port map(
		clk   => clk,
		en		=> intDone,
		D     => sboxIn2,
		Q     => data_out2);

DataOutReg3: greg2 
	generic map(NBITS_D0 => 4, NBITS_D1 => 64)
	Port map(
		clk   => clk,
		en		=> intDone,
		D     => sboxIn3,
		Q     => data_out3);

end dfl;

