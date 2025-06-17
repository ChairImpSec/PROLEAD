#include "Util/Sharing.hpp"

Sharing::Sharing(uint64_t prime_base, uint64_t extension_degree,
                 const Polynomial& irreducible_polynomial, boost::mt19937& rng)
    : prime_base_(prime_base),
      extension_degree_(extension_degree),
      size_coefficients_bits_(std::ceil(std::log2l(prime_base))),
      length_of_elements_in_bits_(size_coefficients_bits_ * extension_degree),
      sampling_bound_(UINT64_MAX - (UINT64_MAX % prime_base_)),
      dist_(0, std::numeric_limits<uint64_t>::max()),
      gen_(rng, dist_) {
  fmpz_init(prime_fmpz_);
  fmpz_set_ui(prime_fmpz_, prime_base_);

  if (!irreducible_polynomial.empty()) {
    fmpz_mod_ctx_init(ctx_fmpz_mod_, prime_fmpz_);
    fmpz_mod_poly_init(fmpz_poly_, ctx_fmpz_mod_);

    for (uint64_t index = 0; index < irreducible_polynomial.size(); ++index) {
      fmpz_t coeff_fmpz;
      fmpz_init_set_ui(coeff_fmpz, irreducible_polynomial[index]);
      fmpz_mod_poly_set_coeff_fmpz(fmpz_poly_, index, coeff_fmpz,
                                   ctx_fmpz_mod_);
      fmpz_clear(coeff_fmpz);
    }

    fq_ctx_init_modulus(ctx_fq_, fmpz_poly_, ctx_fmpz_mod_, "x");
    fmpz_clear(prime_fmpz_);
  } else {
    fq_ctx_init(ctx_fq_, prime_fmpz_, extension_degree_, "x");
    fmpz_mod_ctx_init(ctx_fmpz_mod_, prime_fmpz_);
    fmpz_mod_poly_init(fmpz_poly_, ctx_fmpz_mod_);
  }
}

Sharing::~Sharing() {
  fmpz_clear(prime_fmpz_);
  fq_ctx_clear(ctx_fq_);
  fmpz_mod_poly_clear(fmpz_poly_, ctx_fmpz_mod_);
  fmpz_mod_ctx_clear(ctx_fmpz_mod_);
}

std::vector<std::vector<uint64_t>> Sharing::EncodeBooleanBitsliced(
    const std::vector<uint64_t>& bitsliced_poly, uint64_t number_of_shares) {
  std::vector<std::vector<uint64_t>> bitsliced_shared_poly(
      number_of_shares, std::vector<uint64_t>(length_of_elements_in_bits_, 0));
  std::vector<Polynomial> shared_poly(number_of_shares,
                                      Polynomial(extension_degree_));

  bitsliced_shared_poly[0][0] = bitsliced_poly[0];
  for (uint64_t share_idx = 1; share_idx < number_of_shares; ++share_idx) {
    bitsliced_shared_poly[share_idx][0] = gen_();
    bitsliced_shared_poly[0][0] ^= bitsliced_shared_poly[share_idx][0];
  }

  return bitsliced_shared_poly;
}

std::vector<std::vector<uint64_t>> Sharing::EncodeBitsliced(
    const std::vector<uint64_t>& bitsliced_poly, uint64_t number_of_shares,
    bool is_additive_masking) {
  if (prime_base_ == 2 && extension_degree_ == 1 && is_additive_masking) {
    return EncodeBooleanBitsliced(bitsliced_poly, number_of_shares);
  }

  std::vector<std::vector<uint64_t>> bitsliced_shared_poly(
      number_of_shares, std::vector<uint64_t>(length_of_elements_in_bits_, 0));
  std::vector<Polynomial> shared_poly(number_of_shares,
                                      Polynomial(extension_degree_));
  uint64_t idx, coeff;
  
  fq_t poly_fq;
  fq_init2(poly_fq, ctx_fq_);

  for (uint64_t sim_idx = 0; sim_idx < 64; ++sim_idx) {
    fmpz_mod_poly_zero(fmpz_poly_, ctx_fmpz_mod_);

    for (uint64_t coeff_idx = 0; coeff_idx < extension_degree_; ++coeff_idx) {
      coeff = 0;
      idx = (coeff_idx + 1) * size_coefficients_bits_ - 1;

      for (uint64_t bit_idx = 0; bit_idx < size_coefficients_bits_; ++bit_idx) {
        coeff <<= 1;
        coeff |= (bitsliced_poly[idx] >> (63 - sim_idx)) & 1;
        --idx;
      }

      assert(coeff < prime_base_ &&
             "Error while encoding a bitsliced polynomial. The unshared input "
             "polynomial is not in the field!");
      fmpz_mod_poly_set_coeff_ui(fmpz_poly_, coeff_idx, coeff, ctx_fmpz_mod_);
    }

    std::vector<fq_t> shared_poly_fq(number_of_shares);
    for (fq_t& share_fq : shared_poly_fq) {
      fq_init(share_fq, ctx_fq_);
    }

    fq_set_fmpz_mod_poly(shared_poly_fq[0], fmpz_poly_, ctx_fq_);

    if (is_additive_masking) {
      for (uint64_t share_idx = 1; share_idx < number_of_shares; ++share_idx) {
        SampleRandomPolynomial(shared_poly_fq[share_idx]);
        fq_sub(shared_poly_fq[0], shared_poly_fq[0], shared_poly_fq[share_idx],
               ctx_fq_);
      }
    } else {
      for (uint64_t share_idx = 1; share_idx < number_of_shares; ++share_idx) {
        do {
          SampleRandomPolynomial(shared_poly_fq[share_idx]);
        } while (fq_is_zero(shared_poly_fq[share_idx], ctx_fq_));

        fq_inv(poly_fq, shared_poly_fq[share_idx], ctx_fq_);
        fq_mul(shared_poly_fq[0], shared_poly_fq[0], poly_fq, ctx_fq_);
      }
    }

    for (uint64_t share_idx = 0; share_idx < number_of_shares; ++share_idx) {
      ConvertFqToPolynomial(shared_poly_fq[share_idx], shared_poly[share_idx]);
    }

    for (fq_t& share_fq : shared_poly_fq) {
      fq_clear(share_fq, ctx_fq_);
    }

    for (uint64_t share_idx = 0; share_idx < number_of_shares; ++share_idx) {
      assert(IsInField(shared_poly[share_idx]) &&
             "Error while encoding a bitsliced polynomial. One of the shared "
             "output polynomials is not in the field!");
      idx = 0;

      for (uint64_t coeff_idx = 0; coeff_idx < extension_degree_; ++coeff_idx) {
        for (uint64_t bit_idx = 0; bit_idx < size_coefficients_bits_;
             ++bit_idx) {
          bitsliced_shared_poly[share_idx][idx] <<= 1;
          bitsliced_shared_poly[share_idx][idx] |=
              shared_poly[share_idx][coeff_idx] & 1;
          shared_poly[share_idx][coeff_idx] >>= 1;
          ++idx;
        }
      }
    }
  }

  fq_clear(poly_fq, ctx_fq_);
  return bitsliced_shared_poly;
}

std::vector<uint64_t> Sharing::DecodeBooleanBitsliced(
    const std::vector<std::vector<uint64_t>>& bitsliced_shared_poly) {
  uint64_t number_of_shares = bitsliced_shared_poly.size();
  std::vector<uint64_t> bitsliced_poly(length_of_elements_in_bits_, 0);

  for (uint64_t share_idx = 0; share_idx < number_of_shares; ++share_idx) {
    bitsliced_poly[0] ^= bitsliced_shared_poly[share_idx][0];
  }

  return bitsliced_poly;
}

std::vector<uint64_t> Sharing::DecodeBitsliced(
    const std::vector<std::vector<uint64_t>>& bitsliced_shared_poly,
    bool is_additive_masking) {
  if (prime_base_ == 2 && extension_degree_ == 1 && is_additive_masking) {
    return DecodeBooleanBitsliced(bitsliced_shared_poly);
  }

  uint64_t idx, number_of_shares = bitsliced_shared_poly.size();
  std::vector<uint64_t> bitsliced_poly(length_of_elements_in_bits_, 0);
  std::vector<fq_t> shared_poly_fq(number_of_shares);
  Polynomial result(extension_degree_);
  fq_t polynomial_fq, result_fq;
  uint64_t coeff;

  fq_init2(result_fq, ctx_fq_);
  fq_init2(polynomial_fq, ctx_fq_);

  for (fq_t& poly_fq : shared_poly_fq) {
    fq_init2(poly_fq, ctx_fq_);
  }

  for (uint64_t sim_idx = 0; sim_idx < 64; ++sim_idx) {
    for (uint64_t share_idx = 0; share_idx < number_of_shares; ++share_idx) {
      fmpz_mod_poly_zero(fmpz_poly_, ctx_fmpz_mod_);

      for (uint64_t coeff_idx = 0; coeff_idx < extension_degree_; ++coeff_idx) {
        coeff = 0;
        idx = (coeff_idx + 1) * size_coefficients_bits_ - 1;

        for (uint64_t bit_idx = 0; bit_idx < size_coefficients_bits_;
             ++bit_idx) {
          coeff <<= 1;
          coeff |=
              (bitsliced_shared_poly[share_idx][idx] >> (63 - sim_idx)) & 1;
          --idx;
        }

        fmpz_mod_poly_set_coeff_ui(fmpz_poly_, coeff_idx, coeff, ctx_fmpz_mod_);
      }

      fq_set_fmpz_mod_poly(shared_poly_fq[share_idx], fmpz_poly_, ctx_fq_);
    }

    if (is_additive_masking) {
      fq_zero(result_fq, ctx_fq_);
      for (fq_t& operand_fq : shared_poly_fq) {
        fq_add(polynomial_fq, result_fq, operand_fq, ctx_fq_);
        fq_swap(polynomial_fq, result_fq, ctx_fq_);
      }
    } else {
      fq_one(result_fq, ctx_fq_);
      for (fq_t& operand_fq : shared_poly_fq) {
        fq_mul(polynomial_fq, result_fq, operand_fq, ctx_fq_);
        fq_swap(polynomial_fq, result_fq, ctx_fq_);
      }
    }

    ConvertFqToPolynomial(result_fq, result);

    idx = 0;
    for (uint64_t coeff_idx = 0; coeff_idx < extension_degree_; ++coeff_idx) {
      for (uint64_t bit_idx = 0; bit_idx < size_coefficients_bits_; ++bit_idx) {
        bitsliced_poly[idx] <<= 1;
        bitsliced_poly[idx] |= result[coeff_idx] & 1;
        result[coeff_idx] >>= 1;
        ++idx;
      }
    }
  }

  fq_clear(polynomial_fq, ctx_fq_);
  fq_clear(result_fq, ctx_fq_);

  for (fq_t& poly_fq : shared_poly_fq) {
    fq_clear(poly_fq, ctx_fq_);
  }

  return bitsliced_poly;
}

void Sharing::ConvertFqToPolynomial(fq_t& polynomial_fq,
                                    Polynomial& polynomial) {
  fmpz_t fmpz_coef;
  fmpz_init(fmpz_coef);
  fmpz_mod_poly_zero(fmpz_poly_, ctx_fmpz_mod_);
  fq_get_fmpz_mod_poly(fmpz_poly_, polynomial_fq, ctx_fq_);

  for (uint64_t index = 0; index < extension_degree_; ++index) {
    fmpz_mod_poly_get_coeff_fmpz(fmpz_coef, fmpz_poly_, index, ctx_fmpz_mod_);
    polynomial[index] = fmpz_get_ui(fmpz_coef);
  }

  fmpz_clear(fmpz_coef);
}

boost::dynamic_bitset<> Sharing::ConvertPolynomialToBitset(
    const Polynomial& polynomial) const {
  uint64_t number_of_bits = length_of_elements_in_bits_;
  uint64_t bit_index, coefficient_index;
  boost::dynamic_bitset<> bitset(number_of_bits);

  for (coefficient_index = 0; coefficient_index < polynomial.size();
       ++coefficient_index) {
    for (bit_index = 0; bit_index < size_coefficients_bits_; ++bit_index) {
      bitset[coefficient_index * size_coefficients_bits_ + bit_index] =
          (polynomial[coefficient_index] >> bit_index) & 1;
    }
  }

  return bitset;
}

void Sharing::SampleRandomPolynomial(fq_t& random_polynomial_fq) {
  fmpz_mod_poly_t rand_fmpz;
  fmpz_mod_poly_init2(rand_fmpz, extension_degree_, ctx_fmpz_mod_);
  uint64_t coeff;

  for (uint64_t idx = 0; idx < extension_degree_; ++idx) {
    do {
      coeff = gen_();
    } while (coeff >= sampling_bound_);

    coeff %= prime_base_;
    fmpz_mod_poly_set_coeff_ui(rand_fmpz, idx, coeff, ctx_fmpz_mod_);
  }

  _fmpz_mod_poly_set_length(rand_fmpz, extension_degree_);
  fq_set_fmpz_mod_poly(random_polynomial_fq, rand_fmpz, ctx_fq_);
  fmpz_mod_poly_clear(rand_fmpz, ctx_fmpz_mod_);
}

std::vector<uint64_t> Sharing::SampleRandomBitslicedPolynomial() {
  uint64_t index, bit_index, bit_width = length_of_elements_in_bits_;
  std::vector<uint64_t> bitsliced_polynomial(bit_width);
  boost::dynamic_bitset<> bitset;
  Polynomial polynomial(extension_degree_);

  for (index = 0; index < 64; ++index) {
    fq_t polynomial_fq;
    fq_init(polynomial_fq, ctx_fq_);
    SampleRandomPolynomial(polynomial_fq);
    ConvertFqToPolynomial(polynomial_fq, polynomial);
    bitset = ConvertPolynomialToBitset(polynomial);

    for (bit_index = 0; bit_index < bit_width; ++bit_index) {
      bitsliced_polynomial[bit_index] <<= 1;
      bitsliced_polynomial[bit_index] |= bitset[bit_index];
    }

    fq_clear(polynomial_fq, ctx_fq_);
  }

  return bitsliced_polynomial;
}

std::vector<uint64_t> Sharing::SampleBooleanRandomBitslicedPolynomial() {
  std::vector<uint64_t> bitsliced_polynomial(length_of_elements_in_bits_,
                                             gen_());
  return bitsliced_polynomial;
}

bool Sharing::IsInField(const Polynomial& polynomial) const {
  if (polynomial.size() != extension_degree_) {
    return false;
  }

  for (uint64_t coefficient : polynomial) {
    if (coefficient >= prime_base_) {
      return false;
    }
  }

  return true;
}
