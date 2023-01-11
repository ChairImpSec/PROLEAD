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
use IEEE.NUMERIC_STD.ALL;

entity Gf16_mul2_Canright_bit is
Generic (Num 		: integer) ;
    Port ( a 		: in  STD_LOGIC ;
           b 		: in  STD_LOGIC ;
           c 		: in  STD_LOGIC ;
           d 		: in  STD_LOGIC ;
			  e 		: in  STD_LOGIC ;
           f 		: in  STD_LOGIC ;
           g 		: in  STD_LOGIC ;
           h 		: in  STD_LOGIC ;
			  x 		: out  STD_LOGIC ;
           y 		: out  STD_LOGIC ;
           z 		: out  STD_LOGIC ;
           t 		: out  STD_LOGIC);
end Gf16_mul2_Canright_bit;

architecture Behavioral of Gf16_mul2_Canright_bit is

begin


	GenNum1: IF Num = 1 GENERATE
			
		x <= (d ) xor ( a and e ) xor ( c and e ) xor ( a and f ) xor ( b and f ) xor ( c and f ) xor ( d and f ) xor ( c and g ) xor ( a and h ) xor ( b and h);
		y <= (a ) xor ( b ) xor ( b and e ) xor ( d and e ) xor ( a and f ) xor ( c and f ) xor ( d and g ) xor ( a and h);
		z <= (b ) xor ( a and e ) xor ( c and e ) xor ( d and e ) xor ( a and f ) xor ( b and f ) xor ( d and f ) xor ( a and g ) xor ( d and g ) xor ( c and h ) xor ( d and h);
		t <= (a ) xor ( b and e ) xor ( c and e ) xor ( a and f ) xor ( c and f ) xor ( d and f ) xor ( b and g ) xor ( c and g ) xor ( d and g ) xor ( c and h);
			
	END GENERATE ;
	
	GenNum2: IF Num = 2 GENERATE
			
		x <= (b ) xor ( e ) xor ( a and e ) xor ( c and e ) xor ( a and f ) xor ( b and f ) xor ( c and f ) xor ( d and f ) xor ( c and g ) xor ( a and h ) xor ( b and h);
		y <= (c ) xor ( d ) xor ( f ) xor ( b and e ) xor ( d and e ) xor ( a and f ) xor ( c and f ) xor ( d and g ) xor ( a and h);
		z <= (c ) xor ( g ) xor ( a and e ) xor ( c and e ) xor ( d and e ) xor ( a and f ) xor ( b and f ) xor ( d and f ) xor ( a and g ) xor ( d and g ) xor ( c and h ) xor ( d and h);
		t <= (b ) xor ( d ) xor ( h ) xor ( b and e ) xor ( c and e ) xor ( a and f ) xor ( c and f ) xor ( d and f ) xor ( b and g ) xor ( c and g ) xor ( d and g ) xor ( c and h);
			
	END GENERATE ;
	
	GenNum3: IF Num = 3 GENERATE
			
		x <= (d ) xor ( a and e ) xor ( c and e ) xor ( a and f ) xor ( b and f ) xor ( c and f ) xor ( d and f ) xor ( c and g ) xor ( a and h ) xor ( b and h);
		y <= (b ) xor ( c ) xor ( d ) xor ( b and e ) xor ( d and e ) xor ( a and f ) xor ( c and f ) xor ( d and g ) xor ( a and h);
		z <= (b ) xor ( a and e ) xor ( c and e ) xor ( d and e ) xor ( a and f ) xor ( b and f ) xor ( d and f ) xor ( a and g ) xor ( d and g ) xor ( c and h ) xor ( d and h);
		t <= (a ) xor ( c ) xor ( d ) xor ( b and e ) xor ( c and e ) xor ( a and f ) xor ( c and f ) xor ( d and f ) xor ( b and g ) xor ( c and g ) xor ( d and g ) xor ( c and h);
			
	END GENERATE ;
	
	GenNum4: IF Num = 4 GENERATE
			
		x <= (b ) xor ( e ) xor ( a and e ) xor ( c and e ) xor ( a and f ) xor ( b and f ) xor ( c and f ) xor ( d and f ) xor ( c and g ) xor ( a and h ) xor ( b and h);
		y <= (a ) xor ( f ) xor ( b and e ) xor ( d and e ) xor ( a and f ) xor ( c and f ) xor ( d and g ) xor ( a and h);
		z <= (c ) xor ( g ) xor ( a and e ) xor ( c and e ) xor ( d and e ) xor ( a and f ) xor ( b and f ) xor ( d and f ) xor ( a and g ) xor ( d and g ) xor ( c and h ) xor ( d and h);
		t <= (b ) xor ( c ) xor ( h ) xor ( b and e ) xor ( c and e ) xor ( a and f ) xor ( c and f ) xor ( d and f ) xor ( b and g ) xor ( c and g ) xor ( d and g ) xor ( c and h);
			
	END GENERATE ;

end Behavioral;