#include "main.h"

/****************************************************************************************************
*       Declare here all your inputs for the emulator (need to be the same number and need to have  *
*       the same name as in config.set under no_of_initial_clock_cycles) (cf. example below)        *
*****************************************************************************************************/

unsigned char input_s1[100] __attribute__((section(".data")));
unsigned char input_s2[100] __attribute__((section(".data")));


/****************************************************************************************************
*       Declares the internal randomness source of the emulator                                     *
*       (only if required, otherwise comment out)                                                   *
*       ! make sure that the linker file contains a .randomness section if you want to use it !     *
*****************************************************************************************************/

uint32_t randomness __attribute__((section(".randomness")));

/****************************************************************************************************
*       DO NOT TOUCH (This function writes the inputs from the emulator to a reserved memory region)*
*****************************************************************************************************/

void __attribute__((noinline)) initialize_local(uint32_t local[5][5], unsigned char uart[100]){

	for(int i = 0; i < 25; ++i){
		local[i/5][i%5] = (((uint32_t)uart[i*4 + 0]) << 24) | (((uint32_t)uart[i*4 + 1]) << 16) | (((uint32_t)uart[i*4 + 2]) << 8) | (((uint32_t)uart[i*4 + 3]) << 0);
	}
}


/****************************************************************************************************
*       If you want to use dynamic memory allocation comment in the next code                       *
*       ! make sure that the flag -nostdlib in compile_sw.py is NOT used !                          *
*****************************************************************************************************/

/*extern int _end;

void *_sbrk(int incr) {
  static unsigned char *heap = NULL;
  unsigned char *prev_heap;

  if (heap == NULL) {
    heap = (unsigned char *)&_end;
  }
  prev_heap = heap;

  heap += incr;

  return prev_heap;
}*/

/*******************************************************************************************************
*       Declare and define here your functions used for the cipher (e.g add_roundkey, mix_columns, ...)*
********************************************************************************************************/
#pragma GCC push_options
#pragma GCC optimize ("O0")
void get_external_randomness(uint32_t rand_s0[5][5]){
	for(int i = 0; i < 5; ++i){
		for(int j = 0; j < 5; ++j){
			rand_s0[i][j] = randomness;
		}
	}
}

#pragma GCC pop_options

uint32_t leftRotate32(uint32_t n, unsigned int d)
{

	return (n << d)|(n >> (32 - d));
}

/*Function to right rotate n by d bits*/
uint32_t rightRotate32(uint32_t n, unsigned int d)
{

	return (n >> d)|(n << (32 - d));
}


/*******************************************************************************************************
*       Declare and define here your cipher                                                            *
********************************************************************************************************/

__attribute__((noinline)) void cipher(uint32_t state_s0[5][5], uint32_t state_s1[5][5], uint32_t rand_s0[5][5], uint32_t rand_s1[5][5]){

  KeccakF800_StatePermute(state_s0, state_s1, rand_s0, rand_s1);

}




/****************************************************************************************************
*                                           DO NOT TOUCH                                            *
*****************************************************************************************************/
__attribute__((noreturn, noinline)) void report_done()
{
    report_done();
}

int main(){

    /***************************************************************************************************************
    *       Declare here the local variables where the input of the emulator will be written to (cf. example below)*
    ****************************************************************************************************************/




    /***************************************************************************************************************
    *       Everything you do here (e.g. mask plaintext) before cipher-function starts will not be taken into      *
    *       account by PROLEAD                                                                                     *
    ****************************************************************************************************************/
	uint32_t state_s0_local[5][5] = {
			{0x0,0x0,0x0,0x0,0x0},
			{0x0,0x0,0x0,0x0,0x0},
			{0x0,0x0,0x0,0x0,0x0},
			{0x0,0x0,0x0,0x0,0x0},
			{0x0,0x0,0x0,0x0,0x0}
	};


	uint32_t state_s1_local[5][5] = {
			{0x0,0x0,0x0,0x0,0x0},
			{0x0,0x0,0x0,0x0,0x0},
			{0x0,0x0,0x0,0x0,0x0},
			{0x0,0x0,0x0,0x0,0x0},
			{0x0,0x0,0x0,0x0,0x0}
	};

	uint32_t rand_s0[5][5] = {
			{0x0,0x0,0x0,0x0,0x0},
			{0x0,0x0,0x0,0x0,0x0},
			{0x0,0x0,0x0,0x0,0x0},
			{0x0,0x0,0x0,0x0,0x0},
			{0x0,0x0,0x0,0x0,0x0}
	};


	uint32_t rand_s1[5][5] = {
			{0x0,0x0,0x0,0x0,0x0},
			{0x0,0x0,0x0,0x0,0x0},
			{0x0,0x0,0x0,0x0,0x0},
			{0x0,0x0,0x0,0x0,0x0},
			{0x0,0x0,0x0,0x0,0x0}
	};




    /***************************************************************************************************************
    *       Call initialize_local as often as the number of inputs with correct variables (cf. example below)      *
    ****************************************************************************************************************/
    initialize_local(state_s0_local, input_s1);
    initialize_local(state_s1_local, input_s2);

	//rotation of share
	for(int i = 0; i < 5; ++i){
		for(int j = 0; j < 5; ++j){
			state_s1_local[i][j] = rightRotate32(state_s1_local[i][j], 1);
		}
	}

	get_external_randomness(rand_s0);

	//construct zero sharing
	for(int i = 0; i < 5; ++i){
		for(int j = 0; j < 5; ++j){
			rand_s1[i][j] = rand_s0[i][j];
			rand_s1[i][j] = rightRotate32(rand_s1[i][j], 1);
		}
	}


    /***************************************************************************************************************
    *       Call initialize_local as often as the number of inputs with correct variables (cf. example below)      *
    ****************************************************************************************************************/
    cipher(state_s0_local, state_s1_local, rand_s0, rand_s1);


    /***************************************************************************************************************
    *       Call initialize_local as often as the number of inputs with correct variables to write the values      *
    *       stored inside local variables back to emulator variables (cf. example below)                           *
    ****************************************************************************************************************/

	// volatile uint32_t res[5][5];
	// for(int i = 0; i < 5; ++i){
	// 	for(int j = 0; j < 5; ++j){
	// 		state_s1_local[i][j] = leftRotate32(state_s1_local[i][j], 1);
	// 		res[i][j] = state_s0_local[i][j] ^ state_s1_local[i][j];
	// 	}
	// }
    
    report_done();
    
}