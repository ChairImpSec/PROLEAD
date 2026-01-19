#include "main.h"

/****************************************************************************************************
*       Declare here all your inputs for the emulator (need to be the same number and need to have  *
*       the same name as in config.set under no_of_initial_clock_cycles) (cf. example below)        *
*****************************************************************************************************/

unsigned char input_s1[200] __attribute__((section(".data")));
unsigned char input_s2[200] __attribute__((section(".data")));


/****************************************************************************************************
*       Declares the internal randomness source of the emulator                                     *
*       (only if required, otherwise comment out)                                                   *
*       ! make sure that the linker file contains a .randomness section if you want to use it !     *
*****************************************************************************************************/

uint32_t randomness __attribute__((section(".randomness")));

/****************************************************************************************************
*       DO NOT TOUCH (This function writes the inputs from the emulator to a reserved memory region)*
*****************************************************************************************************/

void __attribute__((noinline)) initialize_local(uint64_t local[5][5], unsigned char uart[200]){
	for(int i = 0; i < 25; ++i){
		local[i/5][i%5] = (((uint64_t)uart[i*8 + 0]) << 56) | (((uint64_t)uart[i*8 + 1]) << 48) | (((uint64_t)uart[i*8 + 2]) << 40) | (((uint64_t)uart[i*8 + 3]) << 32) | (((uint64_t)uart[i*8 + 4]) << 24) | (((uint64_t)uart[i*8 + 5]) << 16) | (((uint64_t)uart[i*8 + 6]) << 8) | (((uint64_t)uart[i*8 + 7]) << 0);

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
uint32_t get_external_randomness(){
	return randomness;
}

#pragma GCC pop_options

uint64_t leftRotate64(uint64_t n, unsigned int d)
{

	return (n << d)|(n >> (64 - d));
}

/*Function to right rotate n by d bits*/
uint64_t rightRotate64(uint64_t n, unsigned int d)
{

	return (n >> d)|(n << (64 - d));
}

void split_odd_even(uint64_t* in){
    uint64_t tmp = 0;
    for(int i = 0; i < 32; ++i){
        tmp |= ((*in >> (2*i)) & 0x1) << i;
    }
    for(int i = 0; i < 32; ++i){
        tmp |= ((*in >> (2*i+1)) & 0x1) << (i+32);
    }
    *in = tmp;
}

void merge_odd_even(uint64_t* in){
    uint64_t tmp = 0;
    for(int i = 0; i < 32; ++i){
        tmp |= ((*in >> (i)) & 0x1) << (2*i);
    }
    for(int i = 0; i < 32; ++i){
        tmp |= ((*in >> (i+32)) & 0x1) << (2*i+1);
    }
    *in = tmp;
}


/*******************************************************************************************************
*       Declare and define here your cipher                                                            *
********************************************************************************************************/

void __attribute__((noinline)) cipher(uint64_t s0[5][5], uint64_t s1[5][5], uint64_t r0[5][5], uint64_t r1[5][5]){

  KeccakF1600_StatePermute_TI(s0, s1, r0, r1);

}




/****************************************************************************************************
*                                           DO NOT TOUCH                                            *
*****************************************************************************************************/
void __attribute__((noreturn, noinline)) report_done()
{
    report_done();
}

int main(){

    /***************************************************************************************************************
    *       Declare here the local variables where the input of the emulator will be written to (cf. example below)*
    ****************************************************************************************************************/
	uint64_t state_s0_local[5][5] = {
			{0x0,0x0,0x0,0x0,0x0},
			{0x0,0x0,0x0,0x0,0x0},
			{0x0,0x0,0x0,0x0,0x0},
			{0x0,0x0,0x0,0x0,0x0},
			{0x0,0x0,0x0,0x0,0x0}
	};

	uint64_t state_s1_local[5][5] = {
			{0x0,0x0,0x0,0x0,0x0},
			{0x0,0x0,0x0,0x0,0x0},
			{0x0,0x0,0x0,0x0,0x0},
			{0x0,0x0,0x0,0x0,0x0},
			{0x0,0x0,0x0,0x0,0x0}
	};

	uint64_t rand_s0[5][5] = {
			{0x0,0x0,0x0,0x0,0x0},
			{0x0,0x0,0x0,0x0,0x0},
			{0x0,0x0,0x0,0x0,0x0},
			{0x0,0x0,0x0,0x0,0x0},
			{0x0,0x0,0x0,0x0,0x0}
	};


	uint64_t rand_s1[5][5] = {
			{0x0,0x0,0x0,0x0,0x0},
			{0x0,0x0,0x0,0x0,0x0},
			{0x0,0x0,0x0,0x0,0x0},
			{0x0,0x0,0x0,0x0,0x0},
			{0x0,0x0,0x0,0x0,0x0}
	};


    /***************************************************************************************************************
    *       Everything you do here (e.g. mask plaintext) before cipher-function starts will not be taken into      *
    *       account by PROLEAD                                                                                     *
    ****************************************************************************************************************/






    /***************************************************************************************************************
    *       Call initialize_local as often as the number of inputs with correct variables (cf. example below)      *
    ****************************************************************************************************************/
    initialize_local(state_s0_local, input_s1);
    initialize_local(state_s1_local, input_s2);

	//sharing of secret
	for(int i = 0; i < 5; ++i){
		for(int j = 0; j < 5; ++j){
			state_s1_local[i][j] = rightRotate64(state_s1_local[i][j], 2);
		}
	}


	for(int i = 0; i < 5; ++i){
		for(int j = 0; j < 5; ++j){
			rand_s0[i][j] = ((((uint64_t)get_external_randomness()) << 32) | get_external_randomness()) & 0xffffffffffffffff ;
			rand_s1[i][j] = rand_s0[i][j];
			rand_s1[i][j] = rightRotate64(rand_s1[i][j], 2);
		}
	}

	for(int i = 0; i < 5; ++i){
		for(int j = 0; j < 5; ++j){
			split_odd_even(&state_s0_local[i][j]);
			split_odd_even(&rand_s0[i][j]);
			//
			split_odd_even(&state_s1_local[i][j]);
			split_odd_even(&rand_s1[i][j]);
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
	// for(int i = 0; i < 5; ++i){
	// 	for(int j = 0; j < 5; ++j){
	// 		merge_odd_even(&state_s0_local[i][j]);
	// 		//
	// 		merge_odd_even(&state_s1_local[i][j]);
	// 	}
	// }
	// volatile uint64_t res[5][5];
	// for(int i = 0; i < 5; ++i){
	// 	for(int j = 0; j < 5; ++j){
	// 		state_s1_local[i][j] = leftRotate64(state_s1_local[i][j], 2);
	// 		res[i][j] = state_s0_local[i][j] ^ state_s1_local[i][j];
	// 	}
	// }
    

    report_done();
    
}