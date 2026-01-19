library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity AES is
    Port ( 
	   plaintext_s0  : in  STD_LOGIC_VECTOR (127 downto 0);
	   plaintext_s1  : in  STD_LOGIC_VECTOR (127 downto 0);           
	   key_s0        : in  STD_LOGIC_VECTOR (127 downto 0);
	   key_s1        : in  STD_LOGIC_VECTOR (127 downto 0);
		seed			  : in  STD_LOGIC_VECTOR (159 downto 0);
      reset         : in  STD_LOGIC;
      clk           : in  STD_LOGIC;
      ciphertext_s0 : out STD_LOGIC_VECTOR (127 downto 0);
      ciphertext_s1 : out STD_LOGIC_VECTOR (127 downto 0);
      done          : out STD_LOGIC);
end AES;

architecture Behavioral of AES is

component AES_LMDPL_Pipeline_d1 is
	Port(
		plaintext_s0  : in  STD_LOGIC_VECTOR (127 downto 0);
	   plaintext_s1  : in  STD_LOGIC_VECTOR (127 downto 0);           
	   key_s0        : in  STD_LOGIC_VECTOR (127 downto 0);
	   key_s1        : in  STD_LOGIC_VECTOR (127 downto 0);
		Fresh			  : in  STD_LOGIC_VECTOR (33  downto 0);
      start         : in  STD_LOGIC;
      Po_rst        : in  STD_LOGIC;
      clk           : in  STD_LOGIC;
      ciphertext_s0 : out STD_LOGIC_VECTOR (127 downto 0);
      ciphertext_s1 : out STD_LOGIC_VECTOR (127 downto 0);
      done          : out STD_LOGIC;
		LMDPL_pre1	  : out STD_LOGIC;
		LMDPL_pre2	  : out STD_LOGIC;
		GlobalEn      : in  STD_LOGIC);
end component;

component Trivium is
    Generic (output_bits : INTEGER := 64);
    Port (  clk : in STD_LOGIC;
            en  : in STD_LOGIC;
            rst : in STD_LOGIC;
            key : in STD_LOGIC_VECTOR(79 downto 0);
            iv : in STD_LOGIC_VECTOR(79 downto 0);
            stream_out : out STD_LOGIC_VECTOR(output_bits-1 downto 0));
end component;
	
	signal LMDPL_pre1	  : STD_LOGIC;
	signal LMDPL_pre2	  : STD_LOGIC;

	signal GlobalEn : std_logic;
	
	signal Po_rst  : std_logic;
	signal start   : std_logic;
	signal done2   : std_logic;
	signal done_in : std_logic;

	signal   counter_rst  : unsigned (2 downto 0);
	signal   counter_done : unsigned (2 downto 0);
	signal   Fresh        : STD_LOGIC_VECTOR (33 downto 0);

begin

   main_process: process(clk, reset, done2, counter_rst, counter_done)
   begin
		if (rising_edge(clk)) then
			if (reset = '1') then
				counter_rst  <= (others => '0');
				counter_done <= (others => '0');
			else
				if (to_integer(counter_rst) <= 1) then
					counter_rst <= counter_rst + 1;
				end if;
				
				if (to_integer(counter_done) < 1) then
					if ((done2 = '1') or (counter_done > 0)) then
						counter_done <= counter_done + 1;
					end if;
				end if;
			end if;	
		end if;
   end process;	
	
	Po_rst  <= reset;
	start   <= '1' when (to_integer(counter_rst) <= 1) else '0';
	
	done_in <= '1' when (to_integer(counter_done) >= 1) else '0';
	done    <= done_in;

	GlobalEn <= reset or (not done_in);

	prng: Trivium
	Generic map (output_bits => 34)
   Port map(  
		clk 			=> clk,
		en				=> LMDPL_pre1,
		rst 			=> reset,
      key 			=> seed( 79 downto  0),
		iv 			=> seed(159 downto 80),
		stream_out 	=> Fresh);
	
	top: AES_LMDPL_Pipeline_d1 
	Port map(
		plaintext_s0  => plaintext_s0,
	   plaintext_s1  => plaintext_s1,      
	   key_s0        => key_s0,
	   key_s1        => key_s1,
		Fresh			  => Fresh,
      start         => start,
      Po_rst        => Po_rst,
      clk           => clk,
      ciphertext_s0 => ciphertext_s0,
      ciphertext_s1 => ciphertext_s1,
      done          => done2,
		LMDPL_pre1    => LMDPL_pre1,
		LMDPL_pre2    => LMDPL_pre2,
		GlobalEn		  => GlobalEn);

end Behavioral;
