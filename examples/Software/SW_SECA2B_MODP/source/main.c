#include <stdint.h>
#include <stdlib.h>
#include "gadgets.h"


/****************************************************************************************************
*       Declare here all your inputs for the emulator (need to be the same number and need to have  *
*       the same name as in config.set under no_of_initial_clock_cycles) (cf. example below)        *
*****************************************************************************************************/

uint8_t input_s1[64] __attribute__((section(".data")));
uint32_t randomness __attribute__((section(".randomness")));


/****************************************************************************************************
*       Declares the internal randomness source of the emulator                                     *
*       (only if required, otherwise comment out)                                                   *
*       ! make sure that the linker file contains a .randomness section if you want to use it !     *
*****************************************************************************************************/



/****************************************************************************************************
*       DO NOT TOUCH (This function writes the inputs from the emulator to a reserved memory region)*
*****************************************************************************************************/

void __attribute__((noinline)) initialize_local(uint16_t local[32], uint8_t uart[64]){
    for(int i = 0; i < 32; ++i){
        uint16_t tmp = (uart[i*2] << 8) | (uart[i*2+1]);
        local[i] = tmp;
    }
}

void __attribute__((noinline)) initialize_local_reverse(uint8_t uart[96], int16_t local[COEF_NBITS * NSHARES]){
    for(int i = 0; i < 96; ++i){
        uart[i*2] = (local[i] >> 8) & 0xff;
        uart[i*2 + 1] = (local[i]) & 0xff;

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
 uint32_t get_random(){
  return randomness;
}
#pragma GCC pop_options

#pragma GCC push_options
#pragma GCC optimize ("O0")
 uint32_t rand32() { return get_random(); }
#pragma GCC pop_options

#pragma GCC push_options
#pragma GCC optimize ("O0")
 void rand_q(int16_t v[2]) {
  uint32_t r;
  do {
    r = rand32();
  } while (r > (387U * KYBER_Q * KYBER_Q));
  r = r % (KYBER_Q * KYBER_Q);
  v[0] = r % (KYBER_Q);
  v[1] = r / KYBER_Q;
}
#pragma GCC pop_options

void transpose32(uint32_t a[32]) {
  int j, k;
  uint32_t m, t;
  m = 0x0000FFFF;
  for (j = 16; j != 0; j = j >> 1, m = m ^ (m << j)) {
    for (k = 0; k < 32; k = (k + j + 1) & ~j) {
      t = (a[k + j] ^ (a[k] >> j)) & m;
      a[k + j] = a[k + j] ^ t;
      a[k] = a[k] ^ (t << j);
    }
  }
}


void masked_dense2bitslice(size_t nshares, size_t n_coeffs, size_t coeffs_size,
                           uint32_t *bitslice, size_t bitslice_msk_stride,
                           size_t bitslice_data_stride, const int16_t *dense,
                           size_t dense_msk_stride, size_t dense_data_stride) {

  size_t d, c, b;
  for (b = 0; b < coeffs_size; b++) {
    for (d = 0; d < nshares; d++) {
      bitslice[b * bitslice_data_stride + d * bitslice_msk_stride] = 0;
    }
  }

  if ((n_coeffs & 0x3) == 0) {
    for (d = 0; d < nshares; d++) {
      for (c = 0; c < n_coeffs; c += 4) {
        int16_t xd0 = dense[c * dense_data_stride + d * dense_msk_stride];
        int16_t xd1 = dense[(c + 1) * dense_data_stride + d * dense_msk_stride];
        int16_t xd2 = dense[(c + 2) * dense_data_stride + d * dense_msk_stride];
        int16_t xd3 = dense[(c + 3) * dense_data_stride + d * dense_msk_stride];

        for (b = 0; b < coeffs_size; b++) {

          bitslice[b * bitslice_data_stride + d * bitslice_msk_stride] |=
              (xd0 & 0x1) << (c + 0);
          bitslice[b * bitslice_data_stride + d * bitslice_msk_stride] |=
              (xd1 & 0x1) << (c + 1);
          bitslice[b * bitslice_data_stride + d * bitslice_msk_stride] |=
              (xd2 & 0x1) << (c + 2);
          bitslice[b * bitslice_data_stride + d * bitslice_msk_stride] |=
              (xd3 & 0x1) << (c + 3);
          xd0 = xd0 >> 1;
          xd1 = xd1 >> 1;
          xd2 = xd2 >> 1;
          xd3 = xd3 >> 1;
        }
      }
    }

  } else {
    for (d = 0; d < nshares; d++) {
      for (c = 0; c < n_coeffs; c++) {
        int16_t xd = dense[c * dense_data_stride + d * dense_msk_stride];
        for (b = 0; b < coeffs_size; b++) {
          bitslice[b * bitslice_data_stride + d * bitslice_msk_stride] |=
              (xd & 0x1) << c;
          xd = xd >> 1;
        }
      }
    }
  }
}


void masked_bitslice2dense(size_t nshares, size_t n_coeffs, size_t coeffs_size,
                           int16_t *dense, size_t dense_msk_stride,
                           size_t dense_data_stride, const uint32_t *bitslice,
                           size_t bitslice_msk_stride,
                           size_t bitslice_data_stride) {

  size_t d, c, b;
  for (c = 0; c < n_coeffs; c += 2) {
    for (d = 0; d < nshares; d++) {
      int16_t xd0 = 0;
      int16_t xd1 = 0;
      for (b = 0; b < coeffs_size; b++) {
        uint32_t y =
            bitslice[b * bitslice_data_stride + d * bitslice_msk_stride];
        xd0 |= ((y >> c) & 0x1) << b;
        xd1 |= ((y >> (c + 1)) & 0x1) << b;
      }
      dense[c * dense_data_stride + d * dense_msk_stride] = xd0;
      dense[(c + 1) * dense_data_stride + d * dense_msk_stride] = xd1;
    }
  }

}

void secadd_constant_bmsk(size_t nshares, size_t kbits, size_t kbits_out,
                          uint32_t *out, size_t out_msk_stride,
                          size_t out_data_stride, const uint32_t *in1,
                          size_t in1_msk_stride, size_t in1_data_stride,
                          uint32_t constant, const uint32_t *bmsk,
                          size_t bmsk_msk_stride) {
  size_t i, d;
  uint32_t carry[nshares];
  uint32_t xpy[nshares];
  uint32_t xpc[nshares];

  if (constant & 0x1) {
    masked_and(nshares, carry, 1, &in1[0 * in1_data_stride], in1_msk_stride,
               bmsk, bmsk_msk_stride);
    masked_xor(nshares, &out[0 * out_data_stride], out_msk_stride,
               &in1[0 * in1_data_stride], in1_msk_stride, bmsk,
               bmsk_msk_stride);
  } else {
    for (d = 0; d < nshares; d++) {
      carry[d] = 0;
    }
    copy_sharing(nshares, out, out_msk_stride, in1, in1_msk_stride);
  }
  for (i = 1; i < kbits; i++) {
    // xpy = in2 ^ in1
    // xpc = in1 ^ carry
    // out = xpy ^ carry
    if ((constant >> i) & 0x1) {
      masked_xor(nshares, xpy, 1, &in1[i * in1_data_stride], in1_msk_stride,
                 bmsk, bmsk_msk_stride);
      masked_xor(nshares, xpc, 1, &in1[i * in1_data_stride], in1_msk_stride,
                 carry, 1);
      masked_xor(nshares, &out[i * out_data_stride], out_msk_stride, xpy, 1,
                 carry, 1);

      if ((i == (kbits - 1)) && (i == (kbits_out - 1))) {
        return;
      } else if (i == (kbits - 1)) {
        masked_and(nshares, carry, 1, xpy, 1, xpc, 1);
        masked_xor(nshares, &out[(kbits)*out_data_stride], out_msk_stride,
                   carry, 1, &in1[i * in1_data_stride], in1_msk_stride);
        return;
      }

      masked_and(nshares, carry, 1, xpy, 1, xpc, 1);
      masked_xor(nshares, carry, 1, carry, 1, &in1[i * in1_data_stride],
                 in1_msk_stride);
    } else {
      // compute the carry
      masked_xor(nshares, &out[i * out_data_stride], out_msk_stride, carry, 1,
                 &in1[i * in1_data_stride], 1);

      if ((i == (kbits - 1)) && (i == (kbits_out - 1))) {
        return;
      } else if (i == (kbits - 1)) {
        masked_and(nshares, &out[(kbits)*out_data_stride], out_msk_stride,
                   carry, 1, &in1[i * in1_data_stride], in1_msk_stride);
        return;
      }
      masked_and(nshares, carry, 1, carry, 1, &in1[i * in1_data_stride],
                 in1_msk_stride);
    }
  }
}

void secadd_constant(size_t nshares, size_t kbits, size_t kbits_out,
                     uint32_t *out, size_t out_msk_stride,
                     size_t out_data_stride, const uint32_t *in1,
                     size_t in1_msk_stride, size_t in1_data_stride,
                     uint32_t constant) {

  size_t i, d;
  uint32_t carry[nshares];
  uint32_t xpy[nshares];
  uint32_t xpc[nshares];

  if (constant & 0x1) {
    for (d = 0; d < nshares; d++) {
      carry[d] = in1[d * in1_msk_stride];
    }
    copy_sharing(nshares, out, out_msk_stride, in1, in1_msk_stride);
    out[0] ^= 0xFFFFFFFF;
  } else {
    for (d = 0; d < nshares; d++) {
      carry[d] = 0;
    }
    copy_sharing(nshares, out, out_msk_stride, in1, in1_msk_stride);
  }

  for (i = 1; i < kbits; i++) {
    if ((constant >> i) & 0x1) {
      copy_sharing(nshares, xpy, 1, &in1[i * in1_data_stride], in1_msk_stride);
      masked_xor(nshares, xpc, 1, &in1[i * in1_data_stride], in1_msk_stride,
                 carry, 1);
      masked_xor(nshares, &out[i * out_data_stride], out_msk_stride, xpy, 1,
                 carry, 1);

      xpy[0] ^= 0xFFFFFFFF;
      out[i * out_data_stride] ^= 0xFFFFFFFF;

      if ((i == (kbits - 1)) && (i == (kbits_out - 1))) {
        return;
      } else if (i == (kbits - 1)) {
        masked_and(nshares, carry, 1, xpy, 1, xpc, 1);
        masked_xor(nshares, &out[(kbits)*out_data_stride], out_msk_stride,
                   carry, 1, &in1[i * in1_data_stride], in1_msk_stride);

        // add the kbits_out of the constant
        out[(kbits)*out_data_stride] ^=
            0xFFFFFFFF * ((constant >> kbits) & 0x1);

        return;
      }

      masked_and(nshares, carry, 1, xpy, 1, xpc, 1);
      masked_xor(nshares, carry, 1, carry, 1, &in1[i * in1_data_stride],
                 in1_msk_stride);
    } else {
      // compute the carry
      masked_xor(nshares, &out[i * out_data_stride], out_msk_stride, carry, 1,
                 &in1[i * in1_data_stride], 1);

      if ((i == (kbits - 1)) && (i == (kbits_out - 1))) {
        return;
      } else if (i == (kbits - 1)) {
        masked_and(nshares, &out[(kbits)*out_data_stride], out_msk_stride,
                   carry, 1, &in1[i * in1_data_stride], in1_msk_stride);

        // add the kbits_out of the constant
        out[(kbits)*out_data_stride] ^=
            0xFFFFFFFF * ((constant >> kbits) & 0x1);
        return;
      }
      masked_and(nshares, carry, 1, carry, 1, &in1[i * in1_data_stride],
                 in1_msk_stride);
    }
  }
}




void secadd(size_t nshares, size_t kbits, size_t kbits_out, uint32_t *out,
            size_t out_msk_stride, size_t out_data_stride, const uint32_t *in1,
            size_t in1_msk_stride, size_t in1_data_stride, const uint32_t *in2,
            size_t in2_msk_stride, size_t in2_data_stride) {


  size_t i, d;
  uint32_t carry[nshares];
  uint32_t xpy[nshares];
  uint32_t xpc[nshares];

  masked_and(nshares, carry, 1, &in1[0 * in1_data_stride], in1_msk_stride,
             &in2[0 * in2_data_stride], in2_msk_stride);

  masked_xor(nshares, &out[0 * out_data_stride], out_msk_stride,
             &in1[0 * in1_data_stride], in1_msk_stride,
             &in2[0 * in2_data_stride], in2_msk_stride);

  for (i = 1; i < kbits; i++) {
    // xpy = in2 ^ in1
    // xpc = in1 ^ carry
    // out = xpy ^ carry

    masked_xor(nshares, xpy, 1, &in1[i * in1_data_stride], in1_msk_stride,
               &in2[i * in2_data_stride], in2_msk_stride);
    masked_xor(nshares, xpc, 1, &in1[i * in1_data_stride], in1_msk_stride,
               carry, 1);
    masked_xor(nshares, &out[i * out_data_stride], out_msk_stride, xpy, 1,
               carry, 1);

    if ((i == (kbits - 1)) && (i == (kbits_out - 1))) {
      break;
    } else if (i == (kbits - 1)) {
      masked_and(nshares, carry, 1, xpy, 1, xpc, 1);
      masked_xor(nshares, &out[(kbits)*out_data_stride], out_msk_stride, carry,
                 1, &in1[i * in1_data_stride], in1_msk_stride);
      break;
    }

    masked_and(nshares, carry, 1, xpy, 1, xpc, 1);
    masked_xor(nshares, carry, 1, carry, 1, &in1[i * in1_data_stride],
               in1_msk_stride);
  }

}




/*******************************************************************************************************
*       Declare and define here your cipher                                                            *
********************************************************************************************************/

void cipher(size_t nshares, size_t kbits, uint32_t p, uint32_t *in, size_t in_msk_stride, size_t in_data_stride){


  /*
  *
  *seca2b(NSHARES, kbits, in1, 1, NSHARES);
  *
  */
  size_t i, d;

  if (nshares == 1) {
    return;
  }

  size_t nshares_low = nshares / 2;
  size_t nshares_high = nshares - nshares_low;

  cipher(nshares_low, kbits, p, in, in_msk_stride, in_data_stride);
  cipher(nshares_high, kbits, p, &in[nshares_low * in_msk_stride],
              in_msk_stride, in_data_stride);

  uint32_t expanded_low[(kbits + 1) * nshares];
  uint32_t expanded_high[(kbits + 1) * nshares];
  uint32_t u[(kbits + 1) * nshares];

  secadd_constant(nshares_low, kbits, kbits + 1, expanded_low, 1, nshares, in,
                  in_msk_stride, in_data_stride, (1 << (kbits + 1)) - p);

  for (i = 0; i < (kbits + 1); i++) {
    if (i < kbits) {
      copy_sharing(nshares_high, &expanded_high[i * nshares + nshares_low], 1,
                   &in[i * in_data_stride + nshares_low * in_msk_stride],
                   in_msk_stride);
    }
    for (d = 0; d < nshares_low; d++) {
      // has already been written by secadd_constant_bmsk
      // expanded_low[i*nshares + d] = in[i*in_data_stride + d*in_msk_stride];
      expanded_high[i * nshares + d] = 0;
    }
    for (d = nshares_low; d < nshares; d++) {
      // kbits + 1 within in is unset
      if (i >= kbits) {
        expanded_high[i * nshares + d] = 0;
      }
      expanded_low[i * nshares + d] = 0;
    }
  }

  secadd(nshares, kbits + 1, kbits + 1, u, 1, nshares, expanded_high, 1,
         nshares, expanded_low, 1, nshares);

  secadd_constant_bmsk(nshares, kbits, kbits, in, in_msk_stride, in_data_stride,
                       u, 1, nshares, p, &u[kbits * nshares], 1);


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
    uint16_t input_local[32];


    /***************************************************************************************************************
    *       Call initialize_local as often as the number of inputs with correct variables (cf. example below)      *
    ****************************************************************************************************************/

    initialize_local(input_local, input_s1);

    /***************************************************************************************************************
    *       Everything you do here (e.g. mask plaintext) before cipher-function starts will not be taken into      *
    *       account by PROLEAD                                                                                     *
    ****************************************************************************************************************/

  size_t kbits = COEF_NBITS;
  uint32_t q = KYBER_Q;
  uint32_t in1[kbits * NSHARES];

  int16_t coeffs_in1[NSHARES * BSSIZE];
  int16_t coeffs_out[NSHARES * BSSIZE];

  volatile int err;
  size_t i, j, d;

  for (j = 0; j < BSSIZE; j++) {
    coeffs_in1[j * NSHARES] = input_local[j] % q;
    for (i = 1; i < NSHARES; i++) {
      int16_t r = rand32() % q;
      coeffs_in1[j * NSHARES + i] = (r) % q;
      coeffs_in1[j * NSHARES] = (coeffs_in1[j * NSHARES] + q - r) % q;
    }
  }

  masked_dense2bitslice(NSHARES, BSSIZE, kbits, in1, 1, NSHARES, coeffs_in1, 1,
                        NSHARES);

  cipher(NSHARES, kbits, KYBER_Q, in1, 1, NSHARES);

  // masked_bitslice2dense(NSHARES, BSSIZE, kbits, coeffs_out, 1, NSHARES, in1, 1,
  //                       NSHARES);

  // // check correctness
  // err = 0;
  // for (i = 0; i < BSSIZE; i++) {
  //   uint32_t uin1, uout;
  //   uin1 = 0;
  //   uout = 0;
  //   for (d = 0; d < NSHARES; d++) {
  //     uin1 += coeffs_in1[i * NSHARES + d];
  //     uout ^= coeffs_out[i * NSHARES + d];
  //   }
  //   uin1 = (uin1) % q;
  //   uout = uout & ((1 << kbits) - 1);

  //   err += (uin1 != uout);
  // }

  report_done();
  
}