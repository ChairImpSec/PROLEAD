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


entity Affine_outputC is
    Port ( C : in  STD_LOGIC_VECTOR (7 downto 0);
           Z : out  STD_LOGIC_VECTOR (7 downto 0));
end Affine_outputC;

architecture Behavioral of Affine_outputC is
	signal T1, T2, T3, T4, T5, T6, T7, T8, T9, T10 : STD_LOGIC;
	signal D : STD_LOGIC_VECTOR (7 downto 0);
begin

	T1 <= C(7) xor C(3);
	T2 <= C(6) xor C(4);
	T3 <= C(6) xor C(0);
	T4 <= C(5) xnor C(3) ; 
	T5 <= C(5) xnor T1 ; 
	T6 <= C(5) xnor C(1) ; 
	T7 <= C(4) xnor T6 ; 
	T8 <= C(2) xor T4 ; 
	T9 <= C(1) xor T2 ; 
--	T10 <= T3 xor T5 ; 
	D(7) <= T4 ;
	D(6) <= T1 ;
	D(5) <= T3 ;
	D(4) <= T5 ;
	D(3) <= T2 xor T5;
	D(2) <= T3 xor T8;
	D(1) <= T7 ;
	D(0) <= T9 ;
	
	Z(1 downto 0) <= D(1 downto 0);
	Z(4 downto 2) <= not D(4 downto 2);
	Z(6 downto 5) <= D(6 downto 5);
	Z(7) <= not D(7);
end Behavioral;

