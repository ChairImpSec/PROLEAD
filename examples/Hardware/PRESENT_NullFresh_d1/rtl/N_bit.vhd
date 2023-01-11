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

entity N_bit is
	Generic (Num 		: integer) ;
		
    Port ( a 		: in  STD_LOGIC ;
           b 		: in  STD_LOGIC ;
           c 		: in  STD_LOGIC ;
           d 		: in  STD_LOGIC ;
		     x 		: out  STD_LOGIC ;
           y 		: out  STD_LOGIC ;
           z 		: out  STD_LOGIC ;
           t 		: out  STD_LOGIC);
end N_bit ;

architecture Behavioral of N_bit is

begin

	GenNum1: IF Num = 1 GENERATE
			
		x <= ( c ) xor ( d ) xor ( a  ) xor ( b and c );
		y <= ( b and a  ) xor ( b and c and a  ) xor ( b and d and a  ) xor ( c and d and a  );
		z <= ( '1' ) xor ( b and a  ) xor ( c and a  ) xor ( b and d and a  ) xor ( c and d and a  );
		t <= ( '1' ) xor ( b and a  ) xor ( b and c and a  ) xor ( b and d and a  ) xor ( c and d and a  );
			
	END GENERATE ;
	
	GenNum2: IF Num = 2 GENERATE

		y <= ( d and a  ) xor ( b and c and a ) xor ( b and d and a  ) xor ( c and d and a  );
		z <= ( a  ) xor ( b and a  ) xor ( c and a  ) xor ( d and a  ) xor ( b and d and a  ) xor ( c and d and a  );
		t <= ( d ) xor ( b and c ) xor ( b and d ) xor ( c and d ) xor ( d and a  ) xor ( b and c and a  ) xor ( b and d and a  ) xor ( c and d and a  );	
		
	END GENERATE ;

	GenNum3: IF Num = 3 GENERATE
			
		y <= ( c ) xor ( b and c ) xor ( b and d ) xor ( c and d ) xor ( c and a  ) xor ( b and c and a  ) xor ( b and d and a  ) xor ( c and d and a  );
		z <= ( b and d ) xor ( c and d ) xor ( b and d and a  ) xor ( c and d and a  );
		t <= ( c and a  ) xor ( b and c and a  ) xor ( b and d and a  ) xor ( c and d and a  );
		
	END GENERATE ;
	
	GenNum4: IF Num = 4 GENERATE
			
		x <= ( c ) xor ( a  ) xor ( b and c );
		y <= ( b ) xor ( c ) xor ( b and c ) xor ( b and d ) xor ( c and d ) xor ( b and a  ) xor ( c and a  ) xor ( d and a  ) xor ( b and c and a  ) xor ( b and d and a  ) xor ( c and d and a  );
		z <= ( c ) xor ( a  ) xor ( b and d ) xor ( c and d ) xor ( d and a  ) xor ( b and d and a  ) xor ( c and d and a  );
		t <= ( b ) xor ( c ) xor ( a  ) xor ( b and c ) xor ( b and d ) xor ( c and d ) xor ( b and a  ) xor ( c and a  ) xor ( d and a  ) xor ( b and c and a  ) xor ( b and d and a  ) xor ( c and d and a  );
		
	END GENERATE ;
	
	GenNum5: IF Num = 5 GENERATE
			
		y <= ( b ) xor ( d ) xor ( a  ) xor ( b and c ) xor ( b and d ) xor ( c and d ) xor ( b and a  ) xor ( b and c and a  ) xor ( b and d and a  ) xor ( c and d and a  );
		z <= ( a  ) xor ( b and a  ) xor ( c and a  ) xor ( d and a  ) xor ( b and d and a  ) xor ( c and d and a  );
		t <= ( d ) xor ( b and a  ) xor ( b and c and a  ) xor ( b and d and a  ) xor ( c and d and a  );	
		
	END GENERATE ;

	GenNum6: IF Num = 6 GENERATE
			
		x <= ( a  ) xor ( b and c );
		y <= ( d ) xor ( b and c ) xor ( b and d ) xor ( c and d ) xor ( d and a  ) xor ( b and c and a  ) xor ( b and d and a  ) xor ( c and d and a  );
		z <= ( c ) xor ( d ) xor ( a  ) xor ( b and a  ) xor ( c and a  ) xor ( b and d and a  ) xor ( c and d and a  );
		t <= ( d ) xor ( b and c ) xor ( b and d ) xor ( c and d ) xor ( d and a  ) xor ( b and c and a  ) xor ( b and d and a  ) xor ( c and d and a  );
		
	END GENERATE ;
	
	GenNum7: IF Num = 7 GENERATE
			
		y <= ( c and a  ) xor ( b and c and a  ) xor ( b and d and a  ) xor ( c and d and a  );
		z <= ( d ) xor ( b and d ) xor ( c and d ) xor ( d and a  ) xor ( b and d and a  ) xor ( c and d and a  );
		t <= ( c and a  ) xor ( b and c and a  ) xor ( b and d and a  ) xor ( c and d and a  );
		
	END GENERATE ;
	
	GenNum8: IF Num = 8 GENERATE
			
		x <= ( d ) xor ( a  ) xor ( b and c );
		y <= ( a  ) xor ( b and a  ) xor ( c and a  ) xor ( d and a  ) xor ( b and c and a  ) xor ( b and d and a  ) xor ( c and d and a  );
		z <= ( b and d ) xor ( c and d ) xor ( b and d and a  ) xor ( c and d and a  );
		t <= ( b ) xor ( c ) xor ( d ) xor ( a  ) xor ( b and c ) xor ( b and d ) xor ( c and d ) xor ( b and a  ) xor ( c and a  ) xor ( d and a  ) xor ( b and c and a  ) xor ( b and d and a  ) xor ( c and d and a  );
		
	END GENERATE ;
	
	
end Behavioral ;

