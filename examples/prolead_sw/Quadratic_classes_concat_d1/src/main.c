#include "main.h"

/****************************************************************************************************
*       Declare here all your inputs for the emulator (need to be the same number and need to have  *
*       the same name as in config.set under no_of_initial_clock_cycles) (cf. example below)        *
*****************************************************************************************************/

unsigned char input_s1[16] __attribute__((section(".data")));
unsigned char input_s2[16] __attribute__((section(".data")));


/****************************************************************************************************
*       Declares the internal randomness source of the emulator                                     *
*       (only if required, otherwise comment out)                                                   *
*       ! make sure that the linker file contains a .randomness section if you want to use it !     *
*****************************************************************************************************/

uint32_t randomness __attribute__((section(".randomness")));

/****************************************************************************************************
*       DO NOT TOUCH (This function writes the inputs from the emulator to a reserved memory region)*
*****************************************************************************************************/

void __attribute__((noinline)) initialize_local(unsigned char local[16], unsigned char uart[16]){
    for(int i = 0; i < 16; ++i){
        local[i] = uart[i];
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

__attribute__((noinline)) void cipher(uint32_t s0[4], uint32_t s1[4], uint32_t o0[4], uint32_t o1[4]){

  test_Sboxes(s0, s1, o0, o1); 

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
    unsigned char input_s0_local[16];
    unsigned char input_s1_local[16];



    /***************************************************************************************************************
    *       Everything you do here (e.g. mask plaintext) before cipher-function starts will not be taken into      *
    *       account by PROLEAD                                                                                     *
    ****************************************************************************************************************/






    /***************************************************************************************************************
    *       Call initialize_local as often as the number of inputs with correct variables (cf. example below)      *
    ****************************************************************************************************************/
    initialize_local(input_s0_local, input_s1);
    initialize_local(input_s1_local, input_s2);


	uint32_t s0[4] = {0x0, 0x0, 0x0, 0x0};
	uint32_t s1[4] = {0x0, 0x0, 0x0, 0x0};
	uint32_t o0[4] = {0x0};
	uint32_t o1[4] = {0x0};

    for(int i = 0; i < 16; ++i){
        s0[0] |= (((input_s0_local[i] >> 3) & 0x1) << (2*i));
        s0[1] |= (((input_s0_local[i] >> 2) & 0x1) << (2*i));
        s0[2] |= (((input_s0_local[i] >> 1) & 0x1) << (2*i));
        s0[3] |= (((input_s0_local[i] >> 0) & 0x1) << (2*i));

        s0[0] |= (((input_s0_local[i] >> 7) & 0x1) << (2*i+1));
        s0[1] |= (((input_s0_local[i] >> 6) & 0x1) << (2*i+1));
        s0[2] |= (((input_s0_local[i] >> 5) & 0x1) << (2*i+1));
        s0[3] |= (((input_s0_local[i] >> 4) & 0x1) << (2*i+1));

        s1[0] |= (((input_s1_local[i] >> 3) & 0x1) << (2*i));
        s1[1] |= (((input_s1_local[i] >> 2) & 0x1) << (2*i));
        s1[2] |= (((input_s1_local[i] >> 1) & 0x1) << (2*i));
        s1[3] |= (((input_s1_local[i] >> 0) & 0x1) << (2*i));

        s1[0] |= (((input_s1_local[i] >> 7) & 0x1) << (2*i+1));
        s1[1] |= (((input_s1_local[i] >> 6) & 0x1) << (2*i+1));
        s1[2] |= (((input_s1_local[i] >> 5) & 0x1) << (2*i+1));
        s1[3] |= (((input_s1_local[i] >> 4) & 0x1) << (2*i+1));
    }

    for(int i = 0; i < 4; ++i){
    	s1[i] = rightRotate32(s1[i], 1);
    }

    /***************************************************************************************************************
    *       Call initialize_local as often as the number of inputs with correct variables (cf. example below)      *
    ****************************************************************************************************************/
    cipher(s0, s1, o0, o1);


    /***************************************************************************************************************
    *       Call initialize_local as often as the number of inputs with correct variables to write the values      *
    *       stored inside local variables back to emulator variables (cf. example below)                           *
    ****************************************************************************************************************/

	// volatile unsigned char res_0[16] = {0x0};
	// volatile unsigned char res_1[16] = {0x0};

    // for(int i = 0; i < 4; ++i){
    // 	o1[i] = leftRotate32(o1[i], 1);
    // 	o0[i] ^= o1[i];
    // }

    // for(int i = 0; i < 16; ++i){
    // 	res_0[i] |= (((o0[3] >> (2*i)) & 0x1) << 0);
    // 	res_0[i] |= (((o0[3] >> (2*i+1)) & 0x1) << 4);

    // 	res_0[i] |= (((o0[2] >> (2*i)) & 0x1) << 1);
    // 	res_0[i] |= (((o0[2] >> (2*i+1)) & 0x1) << 5);

    // 	res_0[i] |= (((o0[1] >> (2*i)) & 0x1) << 2);
    // 	res_0[i] |= (((o0[1] >> (2*i+1)) & 0x1) << 6);

    // 	res_0[i] |= (((o0[0] >> (2*i)) & 0x1) << 3);
    // 	res_0[i] |= (((o0[0] >> (2*i+1)) & 0x1) << 7);

    	//---------------------------------------------

    	//res_1[i] |= (((o1[3] >> (2*i)) & 0x1) << 0);
    	//res_1[i] |= (((o1[3] >> (2*i+1)) & 0x1) << 4);

    	//res_1[i] |= (((o1[2] >> (2*i)) & 0x1) << 1);
    	//res_1[i] |= (((o1[2] >> (2*i+1)) & 0x1) << 5);

    	//res_1[i] |= (((o1[1] >> (2*i)) & 0x1) << 2);
    	//res_1[i] |= (((o1[1] >> (2*i+1)) & 0x1) << 6);

    	//res_1[i] |= (((o1[0] >> (2*i)) & 0x1) << 3);
    	//res_1[i] |= (((o1[0] >> (2*i+1)) & 0x1) << 7);

    // }
    
    // for(int i = 0; i < 16; ++i){
    //     res_1[i] ^= res_0[i];
    // }
    report_done();
    
}