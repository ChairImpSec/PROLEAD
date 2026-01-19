#include "main.h"

/****************************************************************************************************
*       Declare here all your inputs for the emulator (need to be the same number and need to have  *
*       the same name as in config.set under no_of_initial_clock_cycles) (cf. example below)        *
*****************************************************************************************************/

unsigned char input_s1[8] __attribute__((section(".data")));
unsigned char input_s2[8] __attribute__((section(".data")));


/****************************************************************************************************
*       Declares the internal randomness source of the emulator                                     *
*       (only if required, otherwise comment out)                                                   *
*       ! make sure that the linker file contains a .randomness section if you want to use it !     *
*****************************************************************************************************/

uint32_t randomness __attribute__((section(".randomness")));

/****************************************************************************************************
*       DO NOT TOUCH (This function writes the inputs from the emulator to a reserved memory region)*
*****************************************************************************************************/

void __attribute__((noinline)) initialize_local(unsigned char local[8], unsigned char uart[8]){
    for(int i = 0; i < 8; ++i){
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


	uint32_t roundkeys_high_s0[32] = {
			0x112233,
			0x21132002,
			0x9599c422,
			0xb9a232b3,
			0xb1123734,
			0x1321622,
			0xc99c4026,
			0x2a233933,
			0xa1236544,
			0xe3217424,
			0xc9c41c64,
			0xc2339938,
			0xf2365846,
			0x22175e46,
			0x9c41c442,
			0x43399388,
			0x73658867,
			0x6175ee6c,
			0x741c6c2e,
			0x53990e83,
			0xc658aa73,
			0x75ed8cb,
			0x51c6e0eb,
			0x990ca38,
			0x558a8132,
			0x25edaab1,
			0x3c6e24bd,
			0xb90c878d,
			0x18a83721,
			0xeeda8315,
			0x56e27ddb,
			0xd0c84adc
	};
	uint32_t roundkeys_low_s0[32] = {
			0x44556677,
			0x2446688a,
			0x64004489,
			0x38844c81,
			0x46566712,
			0x46e688c8,
			0x42c448df,
			0x8804c85b,
			0x67267104,
			0x6ca88ce0,
			0x2e848d90,
			0x838c85d5,
			0x73271077,
			0xcb08ce62,
			0xebc8d966,
			0x38885d7e,
			0x32710719,
			0xb10ce646,
			0xbdcd9628,
			0x8d85d7b0,
			0x21d071ba,
			0x154e6430,
			0xdb1962a2,
			0xdc1d7b68,
			0x19471b8f,
			0x50264324,
			0xb5562a09,
			0xc497b6a7,
			0x90f1b89c,
			0x6e43210,
			0x5062a0d3,
			0x4fbb6a03
	};
	uint32_t roundkeys_high_s1[32] = {
			0x5d7e90ae,
			0x42105cec,
			0xa4a854df,
			0x2158eeec,
			0xf9a34fd,
			0x6aaafaa3,
			0xa226138a,
			0xad7109c9,
			0xded989b6,
			0x65d4117e,
			0xc1772f8c,
			0x11ad3871,
			0x67c9b691,
			0x8f18ddbe,
			0x106b212e,
			0xe44a34d0,
			0xea901c43,
			0x210ae67e,
			0xdbffac48,
			0x6da9b929,
			0x6745bc8,
			0x89c40b8d,
			0xfdd3b987,
			0xab4a91ec,
			0xdd27749,
			0x6f1534da,
			0xb452c456,
			0x457b9e12,
			0x156262f5,
			0x518d4c62,
			0xc5967d8d,
			0x67e18987
	};


	uint32_t roundkeys_low_s1[32] = {
			0x385585c5,
			0x11fbdc7f,
			0xe43234b0,
			0x4866f10,
			0x2ced8cbb,
			0xcce70d0,
			0x66d9333f,
			0x7aa234c5,
			0x8dacb235,
			0xeb683c0a,
			0x95c3668b,
			0x7f7e0ce2,
			0xd8ca6369,
			0xfb99d930,
			0xf0e94e5e,
			0xb5d3f267,
			0xe6539e8b,
			0xb8a7acb3,
			0x5817689,
			0xd29d2d25,
			0x8ba5c40b,
			0x73929afa,
			0xdb6ff2c5,
			0xc9ca81cc,
			0xbfa160d0,
			0x736d2474,
			0x6da783db,
			0xfd51dc1,
			0x7374038f,
			0x80fef69f,
			0x975262cb,
			0x39c7f71e
	};


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

__attribute__((noinline)) void cipher(unsigned char s0[8], unsigned char s1[8], uint32_t roundkeys_high_s0[32], uint32_t roundkeys_high_s1[32], uint32_t roundkeys_low_s0[32], uint32_t roundkeys_low_s1[32]){

  masked_present(s0, s1, roundkeys_high_s0, roundkeys_high_s1, roundkeys_low_s0, roundkeys_low_s1); 

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
    unsigned char input_s0_local[8];
    unsigned char input_s1_local[8];



    /***************************************************************************************************************
    *       Everything you do here (e.g. mask plaintext) before cipher-function starts will not be taken into      *
    *       account by PROLEAD                                                                                     *
    ****************************************************************************************************************/






    /***************************************************************************************************************
    *       Call initialize_local as often as the number of inputs with correct variables (cf. example below)      *
    ****************************************************************************************************************/
    initialize_local(input_s0_local, input_s1);
    initialize_local(input_s1_local, input_s2);




    uint32_t* tmp;

    tmp = &input_s1_local[0];
    *tmp = rightRotate32(*tmp,1);
    tmp = &input_s1_local[4];
    *tmp = rightRotate32(*tmp,1);
    //tmp = 0;
    
    for(int i = 0; i < 32; ++i){
      roundkeys_high_s0[i] = roundkeys_high_s0[i] ^ roundkeys_high_s1[i];
      roundkeys_high_s1[i] = rightRotate32(roundkeys_high_s1[i],1);

      roundkeys_low_s0[i] = roundkeys_low_s0[i] ^ roundkeys_low_s1[i];
      roundkeys_low_s1[i] = rightRotate32(roundkeys_low_s1[i],1);
    }

    /***************************************************************************************************************
    *       Call initialize_local as often as the number of inputs with correct variables (cf. example below)      *
    ****************************************************************************************************************/
    cipher(input_s0_local, input_s1_local, roundkeys_high_s0, roundkeys_high_s1, roundkeys_low_s0, roundkeys_low_s1);


    /***************************************************************************************************************
    *       Call initialize_local as often as the number of inputs with correct variables to write the values      *
    *       stored inside local variables back to emulator variables (cf. example below)                           *
    ****************************************************************************************************************/

	volatile unsigned char res[8];
	tmp = &input_s1_local[0];
	*tmp = leftRotate32(*tmp,1);
	tmp = &input_s1_local[4];
	*tmp = leftRotate32(*tmp,1);
	//tmp = 0;
	for(int i = 0; i < 8; ++i){
		res[i] = input_s0_local[i] ^ input_s1_local[i];
	}
    
    report_done();
    
}