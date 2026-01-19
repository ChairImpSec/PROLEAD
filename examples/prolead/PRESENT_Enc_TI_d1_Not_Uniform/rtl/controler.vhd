library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controler is
port(
	clk	: in std_logic;
	reset	: in std_logic;
	ctrlData: out std_logic_vector(2 downto 0);
	ctrlKey : out std_logic_vector(2 downto 0);
	round : out std_logic_vector(4 downto 0);
	enSboxReg : out std_logic;
  	done    : out std_logic;
	final   : out std_logic);
end entity controler;

	
architecture fsm of controler is

----------------------------------------------------------
-- component declaration
----------------------------------------------------------

component counter is
	generic(NBITS: integer);
	port(
		clk	: in std_logic;
		n_reset	: in std_logic;
		en      : in std_logic;
		q	: out std_logic_vector(NBITS - 1 downto 0)
		);
end component counter;

----------------------------------------------------------
-- finite state stuff
----------------------------------------------------------
	
	type ps_states is (S_IDLE, S_INIT_Data_Key, S_SBOX, S_PLAYER_KeyI, S_FINISHED, S_DONE);
 
  	signal ps_state  		: ps_states;
  	signal next_state 		: ps_states;

----------------------------------------------------------
-- signal declaration
----------------------------------------------------------

signal countRound  : std_logic_vector(4 downto 0);
signal countSerial : std_logic_vector(3 downto 0);
signal en_countRound : std_logic;
signal rst_countRound : std_logic;
signal selData, selDataIn: std_logic;
signal selKey, selKeyIn: std_logic;
signal enData, enKey: std_logic;
signal en_countSerial, rst_countSerial : std_logic;

begin

----------------------------------------------------------
-- component instantiation
----------------------------------------------------------

cnt_rnd: counter
  generic map(NBITS => 5)
  port map(
            clk => clk,
            n_reset => rst_countRound,
            en => en_countRound,
            q => countRound
            );
              
cnt_ser: counter
  generic map(NBITS => 4)
  port map(
            clk => clk,
            n_reset => rst_countSerial,
            en => en_countSerial,
            q => countSerial
            );
  

----------------------------------------------------------
-- finite state stuff
----------------------------------------------------------

ps_state_change:	process(clk, next_state, reset)
begin
	if(clk'event and clk = '1') then
		if (reset = '1') then
			ps_state <= S_IDLE;
		else
			ps_state <= next_state;
		end if;
	end if;
end process;


----------------------------------------------------------
-- FSM
----------------------------------------------------------

ps_state_compute:  process(clk, ps_state, countSerial, countRound)

begin

----------------------------------------------------------
-- finite state stuff
----------------------------------------------------------
next_state <= ps_state;
round <= countRound;
rst_countRound <= '1';
rst_countSerial <= '1';
en_countRound <= '0';
en_countSerial <= '0';

selData <= '0';
selKey <= '0';

selKeyIn <= '0';
selDataIn <= '0';

enKey <= '0';
enData <= '0';

enSboxReg <= '0';
done  <= '0';
final <= '0';

case ps_state is

        when S_IDLE =>
			rst_countRound <= '0';
			rst_countSerial <= '0';
			next_state <= S_INIT_Data_Key;
        
        when S_INIT_Data_Key =>
			selDataIn <= '1';
			selData   <= '1';
			enData    <= '1';

			selKeyIn  <= '1';
			enKey     <= '1';
			selKey    <= '1';
			next_state <= S_SBOX;
        
			when S_SBOX=>
				enData <= '1';
				enKey <= '1';
				enSboxReg <= '1';
				en_countSerial <= '1';
				if(countSerial="1111") then --SER_CLK
					en_countRound <= '1';
					next_state <= S_PLAYER_KeyI;
				end if;
	
			when S_PLAYER_KeyI=>
				--state registers in serial
				--key register in parallel mode for 1 clk cycle
				enData <= '1';
				selData <= '1';
				--key register takes Sbox output
				enKey <= '1';
				selKey <= '1';
--				enSboxReg <= '1';
				rst_countSerial <= '0';

				if(countRound="11111") then
				  next_state <= S_FINISHED;
				else
				  next_state <= S_SBOX;
				end if;
				  
			when S_FINISHED=>
				enData <= '1';
				enKey <= '1';
				en_countSerial <= '1';
				done <= '1';
				if(countSerial="1111") then--SER_CLK
					next_state <= S_DONE;
				end if;
          
        when S_DONE =>
			 final <= '1';
          
      
end case;
        
end process;


--ctrl = MUX&EN&SEL
ctrlData <= selDataIn&enData&selData;
ctrlKey <= selKeyIn&enKey&selKey;
end;
