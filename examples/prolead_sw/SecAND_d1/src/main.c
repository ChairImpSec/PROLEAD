#include <stdint.h>
#include <stdlib.h>
#include "gadgets.h"


/****************************************************************************************************
*       Declare here all your inputs for the emulator (need to be the same number and need to have  *
*       the same name as in config.set under no_of_initial_clock_cycles) (cf. example below)        *
*****************************************************************************************************/

uint8_t input_s1[192] __attribute__((section(".data")));
uint32_t randomness __attribute__((section(".randomness")));


/****************************************************************************************************
*       Declares the internal randomness source of the emulator                                     *
*       (only if required, otherwise comment out)                                                   *
*       ! make sure that the linker file contains a .randomness section if you want to use it !     *
*****************************************************************************************************/



/****************************************************************************************************
*       DO NOT TOUCH (This function writes the inputs from the emulator to a reserved memory region)*
*****************************************************************************************************/

void __attribute__((noinline)) initialize_local(uint32_t local[24], uint8_t uart[192], uint8_t offset){
  if(offset == 0){
    for(int i = 0; i < 24; ++i){
        uint32_t tmp = (uart[i*4] << 24) | (uart[i*4+1] << 16) | (uart[i*4+2] << 8) | (uart[i*4+3]);
        local[i] = tmp;
    }
  }
  else{
    for(int i = 0; i < 24; ++i){
        uint32_t tmp = (uart[i*4 + 96] << 24) | (uart[i*4+1 + 96] << 16) | (uart[i*4+2 + 96] << 8) | (uart[i*4+3 + 96]);
        local[i] = tmp;
    }
  }

}

void __attribute__((noinline)) initialize_local_reverse(uint8_t uart[192], int16_t local[COEF_NBITS * NSHARES]){
    for(int i = 0; i < 192; ++i){
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
typedef struct {
  int16_t coeffs[KYBER_N];
} poly;

typedef int16_t Coef;

typedef Coef StrAPoly[NSHARES][KYBER_N]; // strided
typedef Coef APoly[KYBER_N][NSHARES];    // dense

/*************************************************
 * Name:        StrAPoly2APoly
 *
 * Description: Maps strided polynomial into a dense representation
 *
 * Arguments:
 *           - APoly out : dense polynomial
 *           - StrAPoly in: strided polynomial
 * **************************************************/
void StrAPoly2APoly(APoly out, const StrAPoly in) {
  int i, d;
  for (i = 0; i < KYBER_N; i++) {
    for (d = 0; d < NSHARES; d++) {
      out[i][d] = in[d][i];
    }
  }
}

/*************************************************
 * Name:        poly_frombytes
 *
 * Description: De-serialization of a polynomial;
 *              inverse of poly_tobytes
 *
 * Arguments:   - poly *r:                pointer to output polynomial
 *              - const unsigned char *a: pointer to input byte array (of
 *KYBER_POLYBYTES bytes)
 **************************************************/
void poly_frombytes(poly *r, const unsigned char *a) {
  int i;

  for (i = 0; i < KYBER_N / 2; i++) {
    r->coeffs[2 * i] = a[3 * i] | ((uint16_t)a[3 * i + 1] & 0x0f) << 8;
    r->coeffs[2 * i + 1] = a[3 * i + 1] >> 4 | ((uint16_t)a[3 * i + 2] & 0xff)
                                                   << 4;
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

/*************************************************
 * Name:        masked_poly
 *
 * Description: masked a polynomial into a strided polynomial
 *
 * Arguments:   - uint16_t *p: pointer to in/output polynomial
 *              - StrAPoly mp: strided masked polynomial
 **************************************************/
void masked_poly(StrAPoly mp, const poly *p) {
  int16_t v[2];

  for (int i = 0; i < KYBER_N; i++) {
    mp[0][i] = p->coeffs[i];
  }

  for (int d = 1; d < NSHARES; d++) {
    for (int i = 0; i < KYBER_N; i += 2) {
      rand_q(v);
      mp[0][i] = (mp[0][i] + v[0]) % KYBER_Q;
      mp[0][i + 1] = (mp[0][i + 1] + v[1]) % KYBER_Q;

      mp[d][i] = (KYBER_Q - v[0]) % KYBER_Q;
      mp[d][i + 1] = (KYBER_Q - v[1]) % KYBER_Q;
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


void masked_dense2bitslice_opt(size_t nshares, size_t coeffs_size,
                               uint32_t *bitslice, size_t bitslice_msk_stride,
                               size_t bitslice_data_stride,
                               const int16_t *dense, size_t dense_msk_stride,
                               size_t dense_data_stride) {
  uint32_t a[32];
  for (size_t d = 0; d < nshares; d++) {
    for (size_t i = 0; i < 32; i++) {
      a[i] = (dense[i * dense_data_stride + d * dense_msk_stride] << 0) |
             (dense[(i + 32) * dense_data_stride + d * dense_msk_stride] << 16);
    }
    transpose32(a);
    for (size_t i = 0; i < coeffs_size; i++) {
      bitslice[d * bitslice_msk_stride + i * bitslice_data_stride] = a[i];
      bitslice[d * bitslice_msk_stride +
               (i + coeffs_size) * bitslice_data_stride] = a[i + 16];
    }
  }
}

void masked_bitslice2dense_opt(size_t nshares, size_t coeffs_size,
                               int16_t *dense, size_t dense_msk_stride,
                               size_t dense_data_stride,
                               const uint32_t *bitslice,
                               size_t bitslice_msk_stride,
                               size_t bitslice_data_stride) {

  uint32_t a[32];
  for (size_t d = 0; d < nshares; d++) {
    for (size_t i = 0; i < coeffs_size; i++) {
      a[i] = bitslice[d * bitslice_msk_stride + i * bitslice_data_stride];
      a[i + 16] = bitslice[d * bitslice_msk_stride +
                           (i + coeffs_size) * bitslice_data_stride];
    }
    // Avoid uninitialized vars -> UB :(
    for (size_t i = coeffs_size; i < 16; i++) {
      a[i] = 0;
      a[i + 16] = 0;
    }
    transpose32(a);
    for (size_t i = 0; i < 32; i++) {
      dense[d * dense_msk_stride + i * dense_data_stride] =
          (a[i] >> 0) & ((1 << 16) - 1);
      dense[d * dense_msk_stride + (i + 32) * dense_data_stride] = a[i] >> 16;
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



void RefreshIOS_rec(size_t nshares, size_t d, uint32_t *x,
                    size_t x_msk_stride) {
  uint32_t r;
  if (d == 1) {
  } else if (d == 2) {
    r = get_random();
    x[0 * x_msk_stride] ^= r;
    x[1 * x_msk_stride] ^= r;
  } else {
    RefreshIOS_rec(nshares, d / 2, x, x_msk_stride);
    RefreshIOS_rec(nshares, d - d / 2, &x[(d / 2) * x_msk_stride],
                   x_msk_stride);
    for (unsigned int i = 0; i < d / 2; i++) {
      r = rand32();
      x[i * x_msk_stride] ^= r;
      x[(i + d / 2) * x_msk_stride] ^= r;
    }
  }
}









/*******************************************************************************************************
*       Declare and define here your cipher                                                            *
********************************************************************************************************/

void __attribute__((noinline)) cipher(size_t nshares, size_t kbits, size_t kbits_out, uint32_t *out,
            size_t out_msk_stride, size_t out_data_stride, const uint32_t *in1,
            size_t in1_msk_stride, size_t in1_data_stride, const uint32_t *in2,
            size_t in2_msk_stride, size_t in2_data_stride){

  size_t i, d;
  uint32_t carry[nshares];
  // uint32_t xpy[nshares];
  // uint32_t xpc[nshares];

  masked_and(nshares, carry, 1, &in1[0 * in1_data_stride], in1_msk_stride,
             &in2[0 * in2_data_stride], in2_msk_stride);

  // masked_xor(nshares, &out[0 * out_data_stride], out_msk_stride,
  //            &in1[0 * in1_data_stride], in1_msk_stride,
  //            &in2[0 * in2_data_stride], in2_msk_stride);

  // for (i = 1; i < kbits; i++) {
  //   // xpy = in2 ^ in1
  //   // xpc = in1 ^ carry
  //   // out = xpy ^ carry

  //   masked_xor(nshares, xpy, 1, &in1[i * in1_data_stride], in1_msk_stride,
  //              &in2[i * in2_data_stride], in2_msk_stride);
  //   masked_xor(nshares, xpc, 1, &in1[i * in1_data_stride], in1_msk_stride,
  //              carry, 1);
  //   masked_xor(nshares, &out[i * out_data_stride], out_msk_stride, xpy, 1,
  //              carry, 1);

  //   if ((i == (kbits - 1)) && (i == (kbits_out - 1))) {
  //     break;
  //   } else if (i == (kbits - 1)) {
  //     masked_and(nshares, carry, 1, xpy, 1, xpc, 1);
  //     masked_xor(nshares, &out[(kbits)*out_data_stride], out_msk_stride, carry,
  //                1, &in1[i * in1_data_stride], in1_msk_stride);
  //     break;
  //   }

  //   masked_and(nshares, carry, 1, xpy, 1, xpc, 1);
  //   masked_xor(nshares, carry, 1, carry, 1, &in1[i * in1_data_stride],
  //              in1_msk_stride);
  // }

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
    uint32_t input_s1_local[24];
    uint32_t input_s2_local[24];


    /***************************************************************************************************************
    *       Call initialize_local as often as the number of inputs with correct variables (cf. example below)      *
    ****************************************************************************************************************/

    initialize_local(input_s1_local, input_s1, 0);
    initialize_local(input_s2_local, input_s1, 1);


    /***************************************************************************************************************
    *       Everything you do here (e.g. mask plaintext) before cipher-function starts will not be taken into      *
    *       account by PROLEAD                                                                                     *
    ****************************************************************************************************************/
  size_t kbits = COEF_NBITS;
  uint32_t in1[kbits * NSHARES];
  uint32_t in2[kbits * NSHARES];
  uint32_t out[kbits * NSHARES];

  int16_t coeffs_in1[NSHARES * BSSIZE];
  int16_t coeffs_in2[NSHARES * BSSIZE];
  int16_t coeffs_out[NSHARES * BSSIZE];

  volatile int err;
  size_t i, d;
  for (i = 0; i < kbits; i++) {
    uint32_t r = rand32();
    in1[i*2] = input_s1_local[i] ^ r;
    in1[i*2 + 1] = r;
    r = rand32();
    in1[i*2] = input_s1_local[i] ^ r;
    in1[i*2 + 2] = r;
    r = rand32();
    in1[i*2] = input_s1_local[i] ^ r;
    in1[i*2 + 3] = r;
    r = rand32();
    in1[i*2] = input_s1_local[i] ^ r;
    in1[i*2 + 4] = r;
    r = rand32();
    in2[i*2] = input_s2_local[i] ^ r;
    in2[i*2 + 1] = r;
    r = rand32();
    in2[i*2] = input_s2_local[i] ^ r;
    in2[i*2 + 2] = r;
    r = rand32();
    in2[i*2] = input_s2_local[i] ^ r;
    in2[i*2 + 3] = r;
    r = rand32();
    in2[i*2] = input_s2_local[i] ^ r;
    in2[i*2 + 4] = r;
  }
  
  
  cipher(NSHARES, kbits, kbits, out, 1, NSHARES, in1, 1, NSHARES, in2, 1,
         NSHARES);


  report_done();
  
}