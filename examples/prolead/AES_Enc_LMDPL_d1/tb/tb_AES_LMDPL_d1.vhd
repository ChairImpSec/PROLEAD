
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;
 
ENTITY tb_AES_LMDPL_d1 IS
END tb_AES_LMDPL_d1;
 
ARCHITECTURE behavior OF tb_AES_LMDPL_d1 IS 
 
    COMPONENT AES
    PORT(
         plaintext_s0 : IN  std_logic_vector(127 downto 0);
         key_s0 : IN  std_logic_vector(127 downto 0);
         clk : IN  std_logic;
         reset : IN  std_logic;
         plaintext_s1 : IN  std_logic_vector(127 downto 0);
         key_s1 : IN  std_logic_vector(127 downto 0);
         ciphertext_s0 : OUT  std_logic_vector(127 downto 0);
			seed			  : in  STD_LOGIC_VECTOR (159 downto 0);
         done : OUT  std_logic;
         ciphertext_s1 : OUT  std_logic_vector(127 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal plaintext_s0 : std_logic_vector(127 downto 0) := (others => '0');
   signal key_s0 : std_logic_vector(127 downto 0) := (others => '0');
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal plaintext_s1 : std_logic_vector(127 downto 0) := (others => '0');
   signal key_s1 : std_logic_vector(127 downto 0) := (others => '0');

 	--Outputs
   signal ciphertext_s0 : std_logic_vector(127 downto 0);
   signal done : std_logic;
   signal ciphertext_s1 : std_logic_vector(127 downto 0);

   signal plaintext  : std_logic_vector(127 downto 0) := (others => '0');
   signal key        : std_logic_vector(127 downto 0) := (others => '0');
   signal ciphertext : std_logic_vector(127 downto 0) := (others => '0');

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
   signal seed     		: std_logic_vector(159 downto 0);

   signal Mask_P : std_logic_vector(127 downto 0) := x"e70087a49685eaec4b26c2ee951d7bda";
   signal Mask_K : std_logic_vector(127 downto 0) := x"c869116bcc45d12ebc444d66cc08c3f8";


BEGIN
  
 	plaintext_s0 <= plaintext XOR Mask_P;
	plaintext_s1 <= Mask_P;
	
	key_s0 <= key XOR Mask_K;
	key_s1 <= Mask_K;

   ciphertext <= ciphertext_s0 XOR ciphertext_s1;
 
	-- Instantiate the Unit Under Test (UUT)
   uut: AES 
	PORT MAP (
          plaintext_s0 => plaintext_s0,
          key_s0 => key_s0,
          clk => clk,
          reset => reset,
          seed => seed,
          plaintext_s1 => plaintext_s1,
          key_s1 => key_s1,
          ciphertext_s0 => ciphertext_s0,
          done => done,
          ciphertext_s1 => ciphertext_s1
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 
 
   -- Stimulus process
   stim_proc: process
   begin		

		reset			<= '1';
		plaintext 	<= x"328831E0435A3137F6309807A88DA234";
		key 			<= x"2B28AB097EAEF7CF15D2154F16A6883C";
		seed			<= x"56876296fa5141fdb81b64f5fea0e5bb60f3ea5c";
      
		wait for clk_period;

		reset			<= '0';

		wait for clk_period;

		wait until rising_edge(clk) and (done = '1'); 
				
		if (ciphertext = x"3902DC1925DC116A8409850B1DFB9732") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
		end if;	


		wait until falling_edge(clk); 

		reset			<= '1';
		plaintext 	<= (others => '0');
		key 			<= (others => '0');
		seed			<= x"012560127501275027501764512765276235700f";
      
		wait for clk_period;

		reset			<= '0';

		wait for clk_period;

		wait until rising_edge(clk) and (done = '1'); 
				
		if (ciphertext = x"66ef88cae98a4c344b2cfa2bd43b592e") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
		end if;	
		
      wait;
   end process;

END;
