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
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity p2_controler is
port(
	clk	: in std_logic;
	nReset	: in std_logic;
	selInit	: out std_logic;
	selP	: out std_logic;
	selSbox	: out std_logic;
	enKey	: out std_logic;
	enData	: out std_logic;
	round : out std_logic_vector(4 downto 0);
  	done    : out std_logic
);
end entity p2_controler;

	
architecture fsm of p2_controler is

	component counter is
		generic(NBITS: integer);
		port(
			clk	: in std_logic;
			nReset	: in std_logic;
			en      : in std_logic;
			q	: out std_logic_vector(NBITS - 1 downto 0)
			);
	end component counter;

	type ps_states is (S_IDLE, S_SBOX, S_PLAYER_KeyI, S_FINISHED, S_DONE);
 
  	signal ps_state  		: ps_states;
  	signal next_state 		: ps_states;

	signal countRound  : std_logic_vector(4 downto 0);
	signal countSerial : std_logic_vector(4 downto 0);
	signal en_countRound : std_logic;
	signal rst_countRound : std_logic;
	signal en_countSerial, rst_countSerial : std_logic;

begin

	cnt_rnd: counter
	generic map(NBITS => 5)
	port map(
				clk => clk,
				nReset => rst_countRound,
				en => en_countRound,
				q => countRound
				);
              
	cnt_ser: counter
	generic map(NBITS => 5)
	port map(
				clk => clk,
				nReset => rst_countSerial,
				en => en_countSerial,
				q => countSerial
				);
  

	ps_state_change:	process(clk, nReset)
	begin
		if (nReset = '0') then
			ps_state <= S_IDLE;
		elsif(clk'event and clk = '1') then
			ps_state <= next_state;
		end if;
	end process;

	ps_state_compute:  process(clk, ps_state, countSerial, countRound)
	begin
		next_state <= ps_state;
		round <= countRound;
		rst_countRound <= '1';
		rst_countSerial <= '1';
		en_countRound <= '0';
		en_countSerial <= '0';
		selP <= '0';
		selInit <= '0';
		selSbox <= '1';
		enKey <= '0';
		enData <= '0';
		done <= '0';

		case ps_state is
			when S_IDLE =>
				rst_countRound <= '0';
				rst_countSerial <= '0';

				selInit <= '1';
				enData <= '1';
				enKey <= '1';
				next_state <= S_SBOX;
				
			when S_SBOX=>
				enData <= '1';
				en_countSerial <= '1';

				if (countSerial(4) = '0') then
					enKey <= '1';
				else
					selSbox <= '0';
				end if;

				if(countSerial="10011") then --SER_CLK
					en_countRound <= '1';
					next_state <= S_PLAYER_KeyI;
				end if;

			when S_PLAYER_KeyI=>
				enData <= '1';
				selP <= '1';
				enKey <= '1';
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
			
				if(countSerial="01111") then--SER_CLK
					next_state <= S_DONE;
				end if;
			 
			when S_DONE =>
				done <= '0';
			 
			when others =>
				next_state <= S_IDLE;
		end case;
	end process;
end;
