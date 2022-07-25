-------------------------------------------------------------------
-- COMPANY : Ruhr University Bochum
-- AUTHOR  : Amir Moradi (amir.moradi@rub.de) & David Knichel (david.knichel@rub.de)
-- DOCUMENT: https:--eprint.iacr.org/2021/569/
-- -----------------------------------------------------------------
--
--
-- Copyright (c) 2021, David Knichel, Amir Moradi, Nicolai Müller, Pascal Sasdrich
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
use IEEE.NUMERIC_STD.ALL;

library work;
use work.GHPC_pkg.all;

entity and_GHPC is
   Generic (
      low_latency   : integer := 0;   -- 0 / 1
      pipeline      : integer := 1);  -- 0 / 1
   Port(
	a   : in  std_logic_vector(1 downto 0);
	b   : in  std_logic_vector(1 downto 0);
	r   : in  std_logic_vector((1+low_latency*3)-1 downto 0);
	clk : in  std_logic;
	c   : out std_logic_vector(1 downto 0));
end and_GHPC;

architecture Behavioral of and_GHPC is 

	constant in_size  : integer := 2;
	constant out_size : integer := 1; 

        signal in0 : std_logic_vector(in_size-1    downto 0);
        signal in1 : std_logic_vector(in_size-1    downto 0);
	signal out0: std_logic_vector(out_size-1   downto 0);
	signal out1: std_logic_vector(out_size-1   downto 0);

	signal in1_reg	 : std_logic_vector(in_size-1  downto 0);

	--===============================================================
	
	signal Step1_reg : bus_array(0 to out_size-1, 2**in_size-1 downto 0);

	--===============================================================

	signal out0_mid  : std_logic_vector(out_size-1 downto 0);

begin

	in0 <= b(0) & a(0);
	in1 <= b(1) & a(1);
	
	c   <= out1(0) & out0(0);

	--===============================

	GEN_in: for I in 0 to in_size-1 generate
           GEN_pp: if (pipeline /= 0) generate
		reg_ins1: entity work.reg
		Port map(
			clk	=> clk,
			D	=> in1(I),
			Q	=> in1_reg(I));
           end generate;

           GEN_npp: if (pipeline = 0) generate
		in1_reg(I) <= in1(I);
           end generate;
	end generate;	

	--===============================

	Step1_ins: entity work.and_GHPC_Step1
	Generic map (in_size, out_size, out_size*(1+low_latency*(2**in_size-1)), low_latency, pipeline)
	Port map (in0, r, clk, Step1_reg);

	---------------------------------

	Step2_inst: entity work.GHPC_Step2
	Generic map (in_size, out_size, low_latency, pipeline)
	Port map (Step1_reg, in1_reg, clk, out1);
	
	--===============================

	GEN_out: for X in 0 to out_size-1 generate
           GEN_normal: if (low_latency = 0) generate
              GEN_pp: if (pipeline /= 0) generate
	         reg_out0_ins1: entity work.reg
		   Port map(
		      clk => clk,
		      D	  => r(X),
 		      Q	  => out0_mid(X));

                reg_out0_ins2: entity work.reg
                  Port map(
	             clk => clk,
	             D	 => out0_mid(X),
	             Q	 => out0(X));
              end generate;

              GEN_npp: if (pipeline = 0) generate
	  	out0(X) <= r(X);
              end generate;
           end generate;

   	   GEN_LL: if (low_latency /= 0) generate
	      tp: Process (in1, r)
	      begin
	         out0_mid(X) <= r(X*(2**in_size) + to_integer(unsigned(in1)));
 	      end process;

              reg_out0_ins2: entity work.reg
              Port map(
                 clk => clk,
	         D   => out0_mid(X),
	         Q   => out0(X));
           end generate;
	end generate;		
	
end Behavioral;
