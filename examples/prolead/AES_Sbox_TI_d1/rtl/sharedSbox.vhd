----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity sharedSbox is
port (
	clk          : in std_logic;
	PRNGQ        : std_logic_vector(51 downto 0);
	A            : in  std_logic_vector(23 downto 0); 
	Q            : out std_logic_vector(23 downto 0)
	);
end sharedSbox;

architecture Behavioral of sharedSbox is

---------------------------------------------------------------------------
-- Component declaration
---------------------------------------------------------------------------

constant SHARES : INTEGER := 3;


component sharedSbox_f1 is
    generic(SHARES   : INTEGER :=3 );
    Port   ( A        : in  std_logic_vector(8*SHARES-1 downto 0); 
	          NewMask1 : in  std_logic_vector(2*(SHARES-1)-1 downto 0);
	          NewMask2 : in  std_logic_vector(2*(SHARES-1)-1 downto 0);
	          NewMask3 : in  std_logic_vector(2*(SHARES-1)-1 downto 0);
			    Zh       : out std_logic_vector(4*SHARES-1 downto 0);
			    Zl       : out std_logic_vector(4*SHARES-1 downto 0);
			    ab2      : out std_logic_vector(4*SHARES-1 downto 0);
			    ph       : out std_logic_vector(2*SHARES-1 downto 0);
			    p        : out std_logic_vector(2*SHARES-1 downto 0);
			    pl       : out std_logic_vector(2*SHARES-1 downto 0)
			  );
end component sharedSbox_f1;


component sharedSbox_f2 is
    generic(SHARES   : INTEGER :=3 );
    Port   ( Zhin        : in  std_logic_vector(4*SHARES-1 downto 0);
			    Zlin        : in  std_logic_vector(4*SHARES-1 downto 0);
				 ab2         : in  std_logic_vector(4*SHARES-1 downto 0);
			    ph          : in  std_logic_vector(2*SHARES-1 downto 0);
			    p           : in  std_logic_vector(2*SHARES-1 downto 0);
			    pl          : in  std_logic_vector(2*SHARES-1 downto 0);
	          NewMasksA2N : in  std_logic_vector(2*(SHARES-1)-1 downto 0);
	          NewMaskab   : in  std_logic_vector(2*(SHARES-1)-1 downto 0);
			    Zhout       : out std_logic_vector(4*SHARES-1 downto 0);
			    Zlout       : out std_logic_vector(4*SHARES-1 downto 0);
			    gamma1      : out std_logic_vector(2*SHARES-1 downto 0);
			    sA2N        : out std_logic_vector(2*SHARES-1 downto 0);
			    ab          : out std_logic_vector(2*SHARES-1 downto 0);
			    gamma0      : out std_logic_vector(2*SHARES-1 downto 0)				 
			  );
end component sharedSbox_f2;


component sharedSbox_f3 is
    generic(SHARES   : INTEGER :=3 );
    Port   ( Zhin     : in  std_logic_vector(4*SHARES-1 downto 0);
			    Zlin     : in  std_logic_vector(4*SHARES-1 downto 0);
			    gamma1   : in  std_logic_vector(2*SHARES-1 downto 0);
				 sA2N     : in  std_logic_vector(2*SHARES-1 downto 0);
				 ab       : in  std_logic_vector(2*SHARES-1 downto 0);
			    gamma0   : in  std_logic_vector(2*SHARES-1 downto 0);			 
				 NewMaskQ : in  std_logic_vector(4*(SHARES-1)-1 downto 0);
			    Zhout    : out std_logic_vector(4*SHARES-1 downto 0);
			    Zlout    : out std_logic_vector(4*SHARES-1 downto 0);
				 muld     : out std_logic_vector(4*SHARES-1 downto 0)
			  );
end component sharedSbox_f3;


component sharedSbox_f4 is
    generic(SHARES     : INTEGER :=3 );
    Port   ( Zhin       : in  std_logic_vector(4*SHARES-1 downto 0);
			    Zlin       : in  std_logic_vector(4*SHARES-1 downto 0);
				 muld       : in  std_logic_vector(4*SHARES-1 downto 0);
				 NewMask_H1 : in  std_logic_vector(2*(SHARES-1)-1 downto 0);
				 NewMask_H2 : in  std_logic_vector(2*(SHARES-1)-1 downto 0);
				 NewMask_H3 : in  std_logic_vector(2*(SHARES-1)-1 downto 0);
				 NewMask_L1 : in  std_logic_vector(2*(SHARES-1)-1 downto 0);
				 NewMask_L2 : in  std_logic_vector(2*(SHARES-1)-1 downto 0);
				 NewMask_L3 : in  std_logic_vector(2*(SHARES-1)-1 downto 0);
			    ph_H       : out std_logic_vector(2*SHARES-1 downto 0);
			    p_H        : out std_logic_vector(2*SHARES-1 downto 0);
			    pl_H       : out std_logic_vector(2*SHARES-1 downto 0);
			    ph_L       : out std_logic_vector(2*SHARES-1 downto 0);
			    p_L        : out std_logic_vector(2*SHARES-1 downto 0);
			    pl_L       : out std_logic_vector(2*SHARES-1 downto 0)
			  );
end component sharedSbox_f4;


component sharedSbox_f5 is
    generic(SHARES     : INTEGER :=3 );
    Port   ( ph_H       : in  std_logic_vector(2*SHARES-1 downto 0);
			    p_H        : in  std_logic_vector(2*SHARES-1 downto 0);
			    pl_H       : in  std_logic_vector(2*SHARES-1 downto 0);
			    ph_L       : in  std_logic_vector(2*SHARES-1 downto 0);
			    p_L        : in  std_logic_vector(2*SHARES-1 downto 0);
			    pl_L       : in  std_logic_vector(2*SHARES-1 downto 0);
         	 Q          : out std_logic_vector(8*SHARES-1 downto 0)
			  );
end component sharedSbox_f5;

component ff is
	generic (NBITS : integer);
	port(
		clk		: in std_logic;
		D	: in std_logic_vector(NBITS-1 downto 0);
		Q	: out std_logic_vector(NBITS-1 downto 0)
		);
end component ff;


---------------------------------------------------------------------------
-- Signal declaration
---------------------------------------------------------------------------

signal NewMask_f1_1				: std_logic_vector(2*(SHARES-1)-1 downto 0);
signal NewMask_f1_2				: std_logic_vector(2*(SHARES-1)-1 downto 0);
signal NewMask_f1_3				: std_logic_vector(2*(SHARES-1)-1 downto 0);

signal NewMask_f2_1				: std_logic_vector(2*(SHARES-1)-1 downto 0);
signal NewMask_f2_2				: std_logic_vector(2*(SHARES-1)-1 downto 0);

signal NewMask_f3			  	   : std_logic_vector(4*(SHARES-1)-1 downto 0);

signal NewMask_H_f4_1			: std_logic_vector(2*(SHARES-1)-1 downto 0);
signal NewMask_H_f4_2			: std_logic_vector(2*(SHARES-1)-1 downto 0);
signal NewMask_H_f4_3			: std_logic_vector(2*(SHARES-1)-1 downto 0);

signal NewMask_L_f4_1			: std_logic_vector(2*(SHARES-1)-1 downto 0);
signal NewMask_L_f4_2			: std_logic_vector(2*(SHARES-1)-1 downto 0);
signal NewMask_L_f4_3			: std_logic_vector(2*(SHARES-1)-1 downto 0);

signal Zh_f1, Zl_f1       				: std_logic_vector(4*SHARES-1 downto 0);
signal ab2               				: std_logic_vector(4*SHARES-1 downto 0);
signal ph, p, pl           			: std_logic_vector(2*SHARES-1 downto 0);

signal FF1_in                       : std_logic_vector(18*SHARES-1 downto 0);
signal FF1_out                      : std_logic_vector(18*SHARES-1 downto 0);

signal Zh_f1_saved, Zl_f1_saved     : std_logic_vector(4*SHARES-1 downto 0);
signal ab2_saved               		: std_logic_vector(4*SHARES-1 downto 0);
signal ph_saved, p_saved, pl_saved  : std_logic_vector(2*SHARES-1 downto 0);

signal Zh_f2, Zl_f2        			: std_logic_vector(4*SHARES-1 downto 0);
signal gamma1, sA2N, ab, gamma0  	: std_logic_vector(2*SHARES-1 downto 0);

signal FF2_in                       : std_logic_vector(16*SHARES-1 downto 0);
signal FF2_out                      : std_logic_vector(16*SHARES-1 downto 0);

signal Zh_f2_saved, Zl_f2_saved     : std_logic_vector(4*SHARES-1 downto 0);
signal gamma1_saved, sA2N_saved     : std_logic_vector(2*SHARES-1 downto 0);
signal ab_saved, gamma0_saved       : std_logic_vector(2*SHARES-1 downto 0);

signal Zh_f3, Zl_f3  			      : std_logic_vector(4*SHARES-1 downto 0);
signal muld  			   				: std_logic_vector(4*SHARES-1 downto 0);

signal FF3_in                       : std_logic_vector(12*SHARES-1 downto 0);
signal FF3_out                      : std_logic_vector(12*SHARES-1 downto 0);

signal Zh_f3_saved, Zl_f3_saved     : std_logic_vector(4*SHARES-1 downto 0);
signal muld_saved  			   		: std_logic_vector(4*SHARES-1 downto 0);

signal ph_H, p_H, pl_H  				: std_logic_vector(2*SHARES-1 downto 0);
signal ph_L, p_L, pl_L 					: std_logic_vector(2*SHARES-1 downto 0);

signal FF4_in                       : std_logic_vector(12*SHARES-1 downto 0);
signal FF4_out                      : std_logic_vector(12*SHARES-1 downto 0);

signal ph_H_saved, p_H_saved, pl_H_saved : std_logic_vector(2*SHARES-1 downto 0);
signal ph_L_saved, p_L_saved, pl_L_saved : std_logic_vector(2*SHARES-1 downto 0);

begin

---------------------------------------------------------------------------
-- generate the masks

NewMask_f1_1 <= PRNGQ(3 downto 0);
NewMask_f1_2 <= PRNGQ(7 downto 4);
NewMask_f1_3 <= PRNGQ(11 downto 8);

NewMask_f2_1 <= PRNGQ(15 downto 12);
NewMask_f2_2 <= PRNGQ(19 downto 16);

NewMask_f3(1 downto 0) <= PRNGQ(21 downto 20);
NewMask_f3(3 downto 2) <= PRNGQ(25 downto 24);
NewMask_f3(5 downto 4) <= PRNGQ(23 downto 22);
NewMask_f3(7 downto 6) <= PRNGQ(27 downto 26);

NewMask_H_f4_1 <= PRNGQ(31 downto 28);
NewMask_H_f4_2 <= PRNGQ(35 downto 32);
NewMask_H_f4_3 <= PRNGQ(39 downto 36);

NewMask_L_f4_1 <= PRNGQ(43 downto 40);
NewMask_L_f4_2 <= PRNGQ(47 downto 44);
NewMask_L_f4_3 <= PRNGQ(51 downto 48);

---------------------------------------------------------------------------
-- first stage

Inst_f1: sharedSbox_f1
generic map(SHARES => SHARES)
port map(
			 A        => A,
	       NewMask1 => NewMask_f1_1,
	       NewMask2 => NewMask_f1_2,
	       NewMask3 => NewMask_f1_3,
			 Zh       => Zh_f1,
			 Zl       => Zl_f1,
			 ab2      => ab2,
			 ph       => ph,
			 p        => p,
			 pl      => pl
		  );
		  
-- first saving

FF1_in <= Zh_f1 & Zl_f1 & ab2 & ph & p & pl;

PL_1: ff
generic map(NBITS=>18*SHARES)
port map(
		clk	=> clk,
		D	=> FF1_in,
		Q	=> FF1_out
		);

Zh_f1_saved <= FF1_out(18*SHARES-1 downto 14*SHARES);
Zl_f1_saved <= FF1_out(14*SHARES-1 downto 10*SHARES);
ab2_saved   <= FF1_out(10*SHARES-1 downto 6*SHARES);
ph_saved    <= FF1_out(6*SHARES-1  downto 4*SHARES);
p_saved     <= FF1_out(4*SHARES-1  downto 2*SHARES);
pl_saved    <= FF1_out(2*SHARES-1  downto 0);

---------------------------------------------------------------------------
-- second stage

Inst_f2: sharedSbox_f2
generic map(SHARES => SHARES)
port map(
			 Zhin        => Zh_f1_saved,
			 Zlin        => Zl_f1_saved,
			 ab2         => ab2_saved,
			 ph          => ph_saved,
			 p           => p_saved,
			 pl          => pl_saved,
			 NewMasksA2N => NewMask_f2_1,
			 NewMaskab   => NewMask_f2_2,
		    Zhout       => Zh_f2,
		    Zlout       => Zl_f2,
		    gamma1      => gamma1,
		    sA2N        => sA2N,
			 ab          => ab,
		    gamma0      => gamma0
		  );
 
-- second saving

FF2_in <= Zh_f2 & Zl_f2 & gamma1 & sA2N & ab & gamma0;

PL_2: ff
generic map(NBITS=>16*SHARES)
port map(
		clk	=> clk,
		D	=> FF2_in,
		Q	=> FF2_out
		);

Zh_f2_saved  <= FF2_out(16*SHARES-1 downto 12*SHARES);
Zl_f2_saved  <= FF2_out(12*SHARES-1 downto 8*SHARES);
gamma1_saved <= FF2_out(8*SHARES-1  downto 6*SHARES);
sA2N_saved   <= FF2_out(6*SHARES-1  downto 4*SHARES);
ab_saved     <= FF2_out(4*SHARES-1  downto 2*SHARES);
gamma0_saved <= FF2_out(2*SHARES-1  downto 0);
 
---------------------------------------------------------------------------
-- third stage
 
Inst_f3: sharedSbox_f3
generic map(SHARES => SHARES)
port map(
		    Zhin     => Zh_f2_saved,
		    Zlin     => Zl_f2_saved,
		    gamma1   => gamma1_saved,
		    sA2N     => sA2N_saved,
		    ab       => ab_saved,
		    gamma0   => gamma0_saved,
			 NewMaskQ => NewMask_f3,
		    Zhout    => Zh_f3,
		    Zlout    => Zl_f3,
		    muld     => muld
		  );
 
-- third saving

FF3_in <= Zh_f3 & Zl_f3 & muld;

PL_3: ff
generic map(NBITS=>12*SHARES)
port map(
		clk	=> clk,
		D	=> FF3_in,
		Q	=> FF3_out
		);

Zh_f3_saved  <= FF3_out(12*SHARES-1 downto 8*SHARES);
Zl_f3_saved  <= FF3_out(8*SHARES-1  downto 4*SHARES);
muld_saved   <= FF3_out(4*SHARES-1  downto 0);

---------------------------------------------------------------------------
-- fourth stage
 
Inst_f4: sharedSbox_f4
generic map(SHARES => SHARES)
port map( Zhin       => Zh_f3_saved,
		    Zlin       => Zl_f3_saved,
		    muld       => muld_saved,
			 NewMask_H1 => NewMask_H_f4_1,
			 NewMask_H2 => NewMask_H_f4_2,
			 NewMask_H3 => NewMask_H_f4_3,
			 NewMask_L1 => NewMask_L_f4_1,
			 NewMask_L2 => NewMask_L_f4_2,
			 NewMask_L3 => NewMask_L_f4_3,
		    ph_H       => ph_H,
		    p_H        => p_H,
		    pl_H       => pl_H,
		    ph_L       => ph_L,
		    p_L        => p_L,
		    pl_L       => pl_L
		  );
 
-- fourth saving

FF4_in <= ph_H & p_H & pl_H & ph_L & p_L & pl_L;

PL_4: ff
generic map(NBITS=>12*SHARES)
port map(
		clk	=> clk,
		D	=> FF4_in,
		Q	=> FF4_out
		);

ph_H_saved <= FF4_out(12*SHARES-1 downto 10*SHARES);
p_H_saved  <= FF4_out(10*SHARES-1 downto 8*SHARES);
pl_H_saved <= FF4_out(8*SHARES-1  downto 6*SHARES);

ph_L_saved <= FF4_out(6*SHARES-1 downto 4*SHARES);
p_L_saved  <= FF4_out(4*SHARES-1 downto 2*SHARES);
pl_L_saved <= FF4_out(2*SHARES-1 downto 0);

---------------------------------------------------------------------------
-- fifth stage

Inst_f5: sharedSbox_f5
generic map(SHARES => SHARES)
port map( ph_H       => ph_H_saved,
		    p_H        => p_H_saved,
		    pl_H       => pl_H_saved,
		    ph_L       => ph_L_saved,
		    p_L        => p_L_saved,
		    pl_L       => pl_L_saved,
			 Q          => Q
		  );
 
end Behavioral;
