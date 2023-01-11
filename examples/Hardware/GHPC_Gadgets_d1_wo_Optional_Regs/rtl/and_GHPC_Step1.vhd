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

entity and_GHPC_Step1 is
   Generic (
      in_size	    : integer;
      out_size	    : integer; 
      fresh_size    : integer;
      low_latency   : integer;
      pipeline      : integer);
   Port(
	in0 		: in  std_logic_vector(in_size-1    downto 0);
	r   		: in  std_logic_vector(fresh_size-1 downto 0);
	clk 		: in  std_logic;
	Step1_reg	: out bus_array(0 to out_size-1, 2**in_size-1 downto 0));
end and_GHPC_Step1;

architecture Behavioral of and_GHPC_Step1 is 

	type in_array  is array(natural range <>) of std_logic_vector(in_size-1  downto 0);
	type out_array is array(natural range <>) of std_logic_vector(out_size-1 downto 0);

	signal in0_comb		: in_array(0 to 2**in_size-1);
	signal FuncOut 		: out_array(0 to 2**in_size-1);
	signal Step1		: bus_array(0 to   out_size-1, 2**in_size-1 downto 0);

begin

	GEN_in0_comb: for I in 0 to 2**in_size-1 generate
		GEN_in0_bit: for J in 0 to in_size-1 generate
			in0_comb(I)(j) <= in0(J) when GetBit(I,in_size,J) = '0' else (not in0(J));
		end generate;
		
	        FuncOut(I)(0) <= in0_comb(I)(0) AND in0_comb(I)(1); -- output: FuncOut(I)
                                                                    -- input:  in0_comb(I)
	end generate;

	---------------------------------

	GEN_out: for X in 0 to out_size-1 generate
		GEN_Step1_1: for I in 0 to 2**in_size-1 generate
		   GEN_normal: if (low_latency = 0) generate
                      Step1(X, I) <= r(X) xor FuncOut(I)(X);
                   end generate;

		   GEN_LL: if (low_latency /= 0) generate
                      Step1(X, I) <= r(I+X*(2**in_size)) xor FuncOut(I)(X);
                   end generate;
			
 		   reg_ins: entity work.reg
		   Port map(
		     clk	=> clk,
		     D		=> Step1(X, I),
		     Q		=> Step1_reg(X, I));
		end generate;	
	end generate;	
	
end Behavioral;
