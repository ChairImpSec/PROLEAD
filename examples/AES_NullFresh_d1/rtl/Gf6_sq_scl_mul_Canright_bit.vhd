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

library IEEE ;
use IEEE.STD_LOGIC_1164.ALL ;
use IEEE.NUMERIC_STD.ALL ;

entity Gf6_sq_scl_mul_Canright_bit is
	Generic (Num 		: integer) ;
		
    Port ( a 		: in  STD_LOGIC ;
           b 		: in  STD_LOGIC ;
           c 		: in  STD_LOGIC ;
           d 		: in  STD_LOGIC ;
			  e 		: in  STD_LOGIC ;
           f 		: in  STD_LOGIC ;
           g 		: in  STD_LOGIC ;
           h 		: in  STD_LOGIC ;
			  xu 		: out  STD_LOGIC ;
           yu 		: out  STD_LOGIC ;
           zu 		: out  STD_LOGIC ;
           tu 		: out  STD_LOGIC;
			  xd 		: out  STD_LOGIC ;
           yd 		: out  STD_LOGIC ;
           zd 		: out  STD_LOGIC ;
           td 		: out  STD_LOGIC);
end Gf6_sq_scl_mul_Canright_bit ;

architecture Behavioral of Gf6_sq_scl_mul_Canright_bit is
	signal x, y, z, t : STD_LOGIC;
begin

	GenNum1: IF Num = 1 GENERATE
			
		x <= (a and e ) xor ( b and e ) xor ( c and e ) xor ( a and f ) xor ( d and f ) xor ( a and g ) xor ( c and g ) xor ( b and h ) xor ( d and h);
		y <= ('1' ) xor ( a and e ) xor ( b and e ) xor ( d and e ) xor ( a and f ) xor ( c and f ) xor ( d and f ) xor ( b and g ) xor ( a and h ) xor ( b and h);
		z <= (a and e ) xor ( b and e ) xor ( c and e ) xor ( d and e ) xor ( a and f ) xor ( c and f ) xor ( a and g ) xor ( b and g ) xor ( d and g ) xor ( a and h ) xor ( c and h ) xor ( d and h );
		t <= (a and e ) xor ( c and e ) xor ( b and f ) xor ( d and f ) xor ( a and g ) xor ( c and g ) xor ( d and g ) xor ( b and h ) xor ( c and h);
			
		xu <= x;
		xd <= x;
		
		yu <= a xor g xor y;
		yd <= e xor c xor y;
		
		zu <= b xor d xor z;
		zd <= f xor h xor z;
		
		tu <= b xor e xor f xor t;
		td <= f xor a xor b xor t;
	END GENERATE ;
	
	GenNum2: IF Num = 2 GENERATE
			
		x <= ( a and e ) xor ( b and e ) xor ( c and e ) xor ( a and f ) xor ( d and f ) xor ( a and g ) xor ( c and g ) xor ( b and h ) xor ( d and h);
		y <= ( a and e ) xor ( b and e ) xor ( d and e ) xor ( a and f ) xor ( c and f ) xor ( d and f ) xor ( b and g ) xor ( a and h ) xor ( b and h);
		z <= (a and e ) xor ( b and e ) xor ( c and e ) xor ( d and e ) xor ( a and f ) xor ( c and f ) xor ( a and g ) xor ( b and g ) xor ( d and g ) xor ( a and h ) xor ( c and h ) xor ( d and h );
		t <= (a and e ) xor ( c and e ) xor ( b and f ) xor ( d and f ) xor ( a and g ) xor ( c and g ) xor ( d and g ) xor ( b and h ) xor ( c and h );
		
			
		xu <= a xor e xor x;
		xd <= h xor a xor x;
		
		yu <= a xor d xor y;
		yd <= c xor d xor y;
		
		zu <= a xor c xor h xor z;
		zd <= e xor g xor h xor a xor b xor c xor d xor z;
		
		tu <= d xor t;
		td <= a xor d xor t;
		
	END GENERATE ;

	GenNum3: IF Num = 3 GENERATE
		
		x <= (a and e ) xor ( b and e ) xor ( c and e ) xor ( a and f ) xor ( d and f ) xor ( a and g ) xor ( c and g ) xor ( b and h ) xor ( d and h );
		y <= (a and e ) xor ( b and e ) xor ( d and e ) xor ( a and f ) xor ( c and f ) xor ( d and f ) xor ( b and g ) xor ( a and h ) xor ( b and h );
		z <= (a and e ) xor ( b and e ) xor ( c and e ) xor ( d and e ) xor ( a and f ) xor ( c and f ) xor ( a and g ) xor ( b and g ) xor ( d and g ) xor ( a and h ) xor ( c and h ) xor ( d and h );
		t <= (a and e ) xor ( c and e ) xor ( b and f ) xor ( d and f ) xor ( a and g ) xor ( c and g ) xor ( d and g ) xor ( b and h ) xor ( c and h );
		
			
		xu <= d xor e xor x;
		xd <= e xor a xor x;
		
		yu <= g xor h xor y;
		yd <= e xor h xor y;
		
		zu <= a xor c xor d xor e xor f xor g xor h xor z;
		zd <= e xor g xor d xor z;
		
		tu <= e xor h xor t;
		td <= h xor t;
		
	END GENERATE ;
	
	GenNum4: IF Num = 4 GENERATE
			
		x <= ( a and e ) xor ( b and e ) xor ( c and e ) xor ( a and f ) xor ( d and f ) xor ( a and g ) xor ( c and g ) xor ( b and h ) xor ( d and h);
		y <= ( a and e ) xor ( b and e ) xor ( d and e ) xor ( a and f ) xor ( c and f ) xor ( d and f ) xor ( b and g ) xor ( a and h ) xor ( b and h);
		z <= (a and e ) xor ( b and e ) xor ( c and e ) xor ( d and e ) xor ( a and f ) xor ( c and f ) xor ( a and g ) xor ( b and g ) xor ( d and g ) xor ( a and h ) xor ( c and h ) xor ( d and h );
		t <= (a and e ) xor ( c and e ) xor ( b and f ) xor ( d and f ) xor ( a and g ) xor ( c and g ) xor ( d and g ) xor ( b and h ) xor ( c and h );
		
		xu <= a xor d xor x;
		xd <= e xor h xor x;
		
		yu <= d xor h xor y;
		yd <= h xor d xor y;
		
		zu <= b xor e xor f xor g xor z;
		zd <= f xor a xor b xor c xor z;
		
		tu <= b xor d xor f xor h xor t;
		td <= f xor h xor b xor d xor t;
	END GENERATE ;

	
end Behavioral ;

