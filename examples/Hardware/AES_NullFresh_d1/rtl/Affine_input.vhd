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


entity Affine_input is
    Port ( A : in  STD_LOGIC_VECTOR (7 downto 0);
           Z : out  STD_LOGIC_VECTOR (7 downto 0));
end Affine_input;

architecture Behavioral of Affine_input is

	signal R1, R2, R3, R4, R5, R6, R7, R8, R9 : STD_LOGIC;
	signal B : STD_LOGIC_VECTOR (7 downto 0);

begin

   R1 <= A(7) xor A(5) ;
   R2 <= A(7) xnor A(4) ;
   R3 <= A(6) xor A(0) ;
   R4 <= A(5) xnor R3 ;
   R5 <= A(4) xor R4 ;
   R6 <= A(3) xor A(0) ;
   R7 <= A(2) xor R1 ;
   R8 <= A(1) xor R3 ;
   R9 <= A(3) xor R8 ;
	
	
   B(7) <= R7 xnor R8 ;
   B(6) <= R5 ;
   B(5) <= A(1) xor R4 ;
   B(4) <= R1 xnor R3 ;
   B(3) <= A(1)xor R2 xor R6 ;
   B(2) <= not A(0) ;
   B(1) <= R4 ;
   B(0) <= A(2) xnor R9 ;
	
	Z <= not B;
	
end Behavioral;

