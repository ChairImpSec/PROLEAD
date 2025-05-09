#include <stdint.h>
#include <stdlib.h>
#include "gadgets.h"


/****************************************************************************************************
*       Declare here all your inputs for the emulator (need to be the same number and need to have  *
*       the same name as in config.set under no_of_initial_clock_cycles) (cf. example below)        *
*****************************************************************************************************/

uint8_t input_s1[128] __attribute__((section(".data")));



/****************************************************************************************************
*       Declares the internal randomness source of the emulator                                     *
*       (only if required, otherwise comment out)                                                   *
*       ! make sure that the linker file contains a .randomness section if you want to use it !     *
*****************************************************************************************************/



/****************************************************************************************************
*       DO NOT TOUCH (This function writes the inputs from the emulator to a reserved memory region)*
*****************************************************************************************************/

void __attribute__((noinline)) initialize_local(uint16_t local[32], uint8_t uart[128], uint8_t offset){
  if(!offset){
    for(int i = 0; i < 32; ++i){
        uint16_t tmp = (uart[i*2] << 8) | uart[i*2+1];
        local[i] = tmp;
    }
  }
  else{
      for(int i = 0; i < 32; ++i){
      uint16_t tmp = (uart[i*2 + 64] << 8) | uart[i*2+1 + 64];
      local[i] = tmp;
    }
  }

}

void __attribute__((noinline)) initialize_local_reverse(uint8_t uart[256], int16_t local[NSHARES * BSSIZE * 2]){
    for(int i = 0; i < 128; ++i){
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


uint32_t randomness __attribute__((section(".randomness")));

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

void secadd_modp(size_t nshares, size_t kbits, uint32_t q, uint32_t *out,
                 size_t out_msk_stride, size_t out_data_stride,
                 const uint32_t *in1, size_t in1_msk_stride,
                 size_t in1_data_stride, const uint32_t *in2,
                 size_t in2_msk_stride, size_t in2_data_stride) {

  uint32_t s[(kbits + 1) * nshares];
  uint32_t sp[(kbits + 1) * nshares];

  secadd(nshares, kbits, kbits + 1, s, 1, nshares, in1, in1_msk_stride,
         in1_data_stride, in2, in2_msk_stride, in2_data_stride);

  secadd_constant(nshares, kbits + 1, kbits + 1, sp, 1, nshares, s, 1, nshares,
                  (1 << (kbits + 1)) - q);

  secadd_constant_bmsk(nshares, kbits, kbits, out, out_msk_stride,
                       out_data_stride, sp, 1, nshares, q, &sp[kbits * nshares],
                       1);
}

void seca2b_modp(size_t nshares, size_t kbits, uint32_t p, uint32_t *in,
                 size_t in_msk_stride, size_t in_data_stride) {

  size_t i, d;

  if (nshares == 1) {
    return;
  }

  size_t nshares_low = nshares / 2;
  size_t nshares_high = nshares - nshares_low;

  seca2b_modp(nshares_low, kbits, p, in, in_msk_stride, in_data_stride);
  seca2b_modp(nshares_high, kbits, p, &in[nshares_low * in_msk_stride],
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
      r = get_random();
      x[i * x_msk_stride] ^= r;
      x[(i + d / 2) * x_msk_stride] ^= r;
    }
  }
}








/*******************************************************************************************************
*       Declare and define here your cipher                                                            *
********************************************************************************************************/

void cipher(size_t nshares,
                 //   size_t kbits, // MUST BE EQUAL TO COEF_NBITS
                 uint32_t p, uint32_t *in, size_t in_msk_stride,
                 size_t in_data_stride){


  /*
  *
  *secb2a_modp(nshares, p, in, in_msk_stride, in_data_stride);
  *
  */
  int16_t z_dense[2 * BSSIZE * nshares];
  int16_t zp_dense[2 * BSSIZE * nshares];
  uint32_t zp_str[2 * COEF_NBITS * nshares];
  uint32_t b_str[2 * COEF_NBITS * nshares];
  int16_t r[2];
  size_t d, i;

  // generate uniform sharing for z
  // zp = p - z;
  for (d = 0; d < nshares - 1; d++) {
    for (i = 0; i < BSSIZE; i += 2) {
      rand_q(r);
      z_dense[i * nshares + d] = r[0];
      zp_dense[i * nshares + d] = p - r[0];

      z_dense[(i + 1) * nshares + d] = r[1];
      zp_dense[(i + 1) * nshares + d] = p - r[1];

      rand_q(r);
      z_dense[i * nshares + d + (BSSIZE * nshares)] = r[0];
      zp_dense[i * nshares + d + (BSSIZE * nshares)] = p - r[0];

      z_dense[(i + 1) * nshares + d + (BSSIZE * nshares)] = r[1];
      zp_dense[(i + 1) * nshares + d + (BSSIZE * nshares)] = p - r[1];
    }
#if ((BSSIZE & 0x1) == 0x1)
    rand_q(r);
    z_dense[(BSSIZE - 1) * nshares + d] = r[0];
    zp_dense[(BSSIZE - 1) * nshares + d] = p - r[0];

    rand_q(r);
    z_dense[(BSSIZE - 1) * nshares + d + (BSSIZE * nshares)] = r[0];
    zp_dense[(BSSIZE - 1) * nshares + d + (BSSIZE * nshares)] = p - r[0];
#endif
  }

  // map zp to bitslice representation
  masked_dense2bitslice_opt(nshares - 1, COEF_NBITS, zp_str, 1, nshares,
                            zp_dense, 1, nshares);

  // last shares of zp set to zero
  for (i = 0; i < COEF_NBITS; i++) {
    zp_str[i * nshares + (nshares - 1)] = 0;
    zp_str[i * nshares + (nshares - 1) + COEF_NBITS * nshares] = 0;
  }

  // last shares of zp_str to zero
  seca2b_modp(nshares, COEF_NBITS, p, zp_str, 1, nshares);
  seca2b_modp(nshares, COEF_NBITS, p, &zp_str[COEF_NBITS * nshares], 1,
              nshares);

  secadd_modp(nshares, COEF_NBITS, p, b_str, 1, nshares, in, in_msk_stride,
              in_data_stride, zp_str, 1, nshares);
  secadd_modp(nshares, COEF_NBITS, p, &b_str[COEF_NBITS * nshares], 1, nshares,
              &in[COEF_NBITS * nshares], in_msk_stride, in_data_stride,
              &zp_str[COEF_NBITS * nshares], 1, nshares);

  // map z to bistlice in output buffer
  masked_dense2bitslice_opt(nshares - 1, COEF_NBITS, in, in_msk_stride,
                            in_data_stride, z_dense, 1, nshares);

  // unmask b_str and set to the last share of the output
  for (i = 0; i < COEF_NBITS; i++) {
    RefreshIOS_rec(nshares, nshares, &b_str[i * nshares], 1);
    RefreshIOS_rec(nshares, nshares, &b_str[i * nshares + COEF_NBITS * nshares],
                   1);

    in[i * in_data_stride + (nshares - 1) * in_msk_stride] = 0;
    in[i * in_data_stride + (nshares - 1) * in_msk_stride +
       COEF_NBITS * nshares] = 0;
    for (d = 0; d < nshares; d++) {
      in[i * in_data_stride + (nshares - 1) * in_msk_stride] ^=
          b_str[i * nshares + d];
      in[i * in_data_stride + (nshares - 1) * in_msk_stride +
         COEF_NBITS * nshares] ^= b_str[i * nshares + d + COEF_NBITS * nshares];
    }
  }

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
    uint16_t input1_local[32];
    uint16_t input2_local[32];


    /***************************************************************************************************************
    *       Call initialize_local as often as the number of inputs with correct variables (cf. example below)      *
    ****************************************************************************************************************/

    initialize_local(input1_local, input_s1, 0);
    initialize_local(input2_local, input_s1, 1);

    /***************************************************************************************************************
    *       Everything you do here (e.g. mask plaintext) before cipher-function starts will not be taken into      *
    *       account by PROLEAD                                                                                     *
    ****************************************************************************************************************/

    size_t kbits = COEF_NBITS;
    uint32_t q = KYBER_Q;
    uint32_t mask = ((1 << kbits) - 1);
    uint32_t in1[kbits * NSHARES * 2];

    int16_t coeffs_in1[NSHARES * BSSIZE * 2];
    int16_t coeffs_out[NSHARES * BSSIZE * 2];

    volatile int err;
    size_t i, j, d;

    for (j = 0; j < BSSIZE; j++) {
      coeffs_in1[j * NSHARES] = input1_local[j] % q;//rand32() % q;
      coeffs_in1[j * NSHARES + BSSIZE * NSHARES] = input2_local[j] % q;//rand32() % q;
      for (i = 1; i < NSHARES; i++) {
        int16_t r = rand32() & mask;
        coeffs_in1[j * NSHARES + i] = r;
        coeffs_in1[j * NSHARES] ^= r;

        r = rand32() & mask;
        coeffs_in1[j * NSHARES + i + BSSIZE * NSHARES] = r;
        coeffs_in1[j * NSHARES + BSSIZE * NSHARES] ^= r;
      }
    }
    masked_dense2bitslice_opt(NSHARES, kbits, in1, 1, NSHARES, coeffs_in1, 1,
                              NSHARES);






    cipher(NSHARES, q, in1, 1, NSHARES);
    



    // masked_bitslice2dense_opt(NSHARES, kbits, coeffs_out, 1, NSHARES, in1, 1,
    //                           NSHARES);

    

    // // check correctness
    // err = 0;
    // for (i = 0; i < 2 * BSSIZE; i++) {
    //   uint32_t uin1, uout;
    //   uin1 = 0;
    //   uout = 0;
    //   for (d = 0; d < NSHARES; d++) {
    //     uin1 ^= coeffs_in1[i * NSHARES + d];
    //     uout += coeffs_out[i * NSHARES + d];
    //   }
    //   uout = (uout) % q;
    //   uin1 = uin1 & ((1 << kbits) - 1);

    //   err += (uin1 != uout);
    // }
    
    // initialize_local_reverse(input_s1, coeffs_out);
    report_done();
    
}