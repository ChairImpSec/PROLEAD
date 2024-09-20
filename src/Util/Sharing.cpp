#include "Util/Sharing.hpp"

Sharing::Sharing(uint64_t prime_base, uint64_t extension_degree,
                 const Polynomial& irreducible_polynomial, boost::mt19937& rng)
    : prime_base_(prime_base),
      extension_degree_(extension_degree),
      size_coefficients_bits_(std::ceil(std::log2l(prime_base))),
      length_of_elements_in_bits_(size_coefficients_bits_ * extension_degree) {
  fmpz_init(prime_fmpz_);
  fmpz_set_ui(prime_fmpz_, prime_base_);
  flint_randinit(random_state_);

  boost::uniform_int<uint64_t> dist_(0, std::numeric_limits<uint64_t>::max());
  boost::variate_generator<boost::mt19937&, boost::uniform_int<uint64_t>> gen_(
      rng, dist_);

  mp_limb_t seed1 = gen_();
  mp_limb_t seed2 = gen_();
  flint_randseed(random_state_, seed1, seed2);

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
  flint_randclear(random_state_);
  fmpz_mod_poly_clear(fmpz_poly_, ctx_fmpz_mod_);
  fmpz_mod_ctx_clear(ctx_fmpz_mod_);
}

std::vector<std::vector<uint64_t>> Sharing::EncodeBitsliced(
    const std::vector<uint64_t>& bitsliced_polynomial,
    uint64_t number_of_shares, bool is_additive_masking) {
  std::string error_context = "Error while encoding a bitsliced polynomial.";
  std::vector<std::vector<uint64_t>> bitsliced_shared_polynomial(
      number_of_shares, std::vector<uint64_t>(length_of_elements_in_bits_, 0));
  uint64_t coefficient_index, bit_index, share_index, simulation_index, index;
  std::vector<Polynomial> shared_polynomial;

  uint64_t coefficient;
  fmpz_t coefficient_fmpz;
  fmpz_init(coefficient_fmpz);

  fq_t polynomial_fq;
  fq_init(polynomial_fq, ctx_fq_);

  for (simulation_index = 0; simulation_index < 64; ++simulation_index) {
    fmpz_mod_poly_zero(fmpz_poly_, ctx_fmpz_mod_);

    for (coefficient_index = 0; coefficient_index < extension_degree_;
         ++coefficient_index) {
      coefficient = 0;
      index = (coefficient_index + 1) * size_coefficients_bits_ - 1;

      for (bit_index = 0; bit_index < size_coefficients_bits_; ++bit_index) {
        coefficient <<= 1;
        coefficient |=
            (bitsliced_polynomial[index] >> (63 - simulation_index)) & 1;
        --index;
      }

      if (coefficient >= prime_base_) {
        throw std::invalid_argument(
            error_context +
            " The unshared input polynomial is not in the field!");
      }

      fmpz_set_ui(coefficient_fmpz, coefficient);
      fmpz_mod_poly_set_coeff_fmpz(fmpz_poly_, coefficient_index,
                                   coefficient_fmpz, ctx_fmpz_mod_);
    }

    fq_set_fmpz_mod_poly(polynomial_fq, fmpz_poly_, ctx_fq_);

    shared_polynomial =
        Encode(polynomial_fq, number_of_shares, is_additive_masking);

    for (share_index = 0; share_index < number_of_shares; ++share_index) {
      if (IsInField(shared_polynomial[share_index])) {
        index = 0;
        for (coefficient_index = 0; coefficient_index < extension_degree_;
             ++coefficient_index) {
          for (bit_index = 0; bit_index < size_coefficients_bits_;
               ++bit_index) {
            bitsliced_shared_polynomial[share_index][index] <<= 1;
            bitsliced_shared_polynomial[share_index][index] |=
                shared_polynomial[share_index][coefficient_index] & 1;
            shared_polynomial[share_index][coefficient_index] >>= 1;
            ++index;
          }
        }
      } else {
        throw std::invalid_argument(
            error_context +
            " One of the shared output polynomials is not in the field!");
      }
    }
  }

  fq_clear(polynomial_fq, ctx_fq_);
  fmpz_clear(coefficient_fmpz);
  return bitsliced_shared_polynomial;
}

std::vector<uint64_t> Sharing::DecodeBitsliced(
    const std::vector<std::vector<uint64_t>>& bitsliced_shared_polynomial,
    bool is_additive_masking) {
  uint64_t number_of_shares = bitsliced_shared_polynomial.size();
  std::vector<uint64_t> bitsliced_polynomial(length_of_elements_in_bits_, 0);
  std::vector<fq_t> shared_polynomial_fq(number_of_shares);
  uint64_t bit_index, coefficient_index, share_index, simulation_index, index;
  Polynomial polynomial;

  uint64_t coefficient;
  fmpz_t coefficient_fmpz;
  fmpz_init(coefficient_fmpz);

  for (fq_t& polynomial_fq : shared_polynomial_fq) {
    fq_init(polynomial_fq, ctx_fq_);
  }

  for (simulation_index = 0; simulation_index < 64; ++simulation_index) {
    for (share_index = 0; share_index < number_of_shares; ++share_index) {
      fmpz_mod_poly_zero(fmpz_poly_, ctx_fmpz_mod_);

      for (coefficient_index = 0; coefficient_index < extension_degree_;
           ++coefficient_index) {
        coefficient = 0;
        index = (coefficient_index + 1) * size_coefficients_bits_ - 1;

        for (bit_index = 0; bit_index < size_coefficients_bits_; ++bit_index) {
          coefficient <<= 1;
          coefficient |= (bitsliced_shared_polynomial[share_index][index] >>
                          (63 - simulation_index)) &
                         1;
          --index;
        }

        fmpz_set_ui(coefficient_fmpz, coefficient);
        fmpz_mod_poly_set_coeff_fmpz(fmpz_poly_, coefficient_index,
                                     coefficient_fmpz, ctx_fmpz_mod_);
      }

      fq_set_fmpz_mod_poly(shared_polynomial_fq[share_index], fmpz_poly_,
                           ctx_fq_);
    }

    polynomial = Decode(shared_polynomial_fq, is_additive_masking);
    index = 0;
    for (coefficient_index = 0; coefficient_index < extension_degree_;
         ++coefficient_index) {
      for (bit_index = 0; bit_index < size_coefficients_bits_; ++bit_index) {
        bitsliced_polynomial[index] <<= 1;
        bitsliced_polynomial[index] |= polynomial[coefficient_index] & 1;
        polynomial[coefficient_index] >>= 1;
        ++index;
      }
    }
  }

  for (fq_t& polynomial_fq : shared_polynomial_fq) {
    fq_clear(polynomial_fq, ctx_fq_);
  }

  fmpz_clear(coefficient_fmpz);
  return bitsliced_polynomial;
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

void Sharing::SampleRandomPolynomial(fq_t& random_polynomial_fq) {
  fmpz_mod_poly_randtest(fmpz_poly_, random_state_, extension_degree_,
                         ctx_fmpz_mod_);
  fq_set_fmpz_mod_poly(random_polynomial_fq, fmpz_poly_, ctx_fq_);
}

std::vector<uint64_t> Sharing::SampleRandomBitslicedPolynomial() {
  uint64_t bit_index, coefficient_index, simulation_index, index;
  std::vector<uint64_t> bitsliced_polynomial(length_of_elements_in_bits_, 0);

  uint64_t coefficient;
  fmpz_t fmpz_coef;
  fmpz_init(fmpz_coef);

  for (simulation_index = 0; simulation_index < 64; ++simulation_index) {
    index = 0;
    fmpz_mod_poly_randtest(fmpz_poly_, random_state_, extension_degree_, ctx_fmpz_mod_);
    for (coefficient_index = 0; coefficient_index < extension_degree_;
         ++coefficient_index) {
      fmpz_mod_poly_get_coeff_fmpz(fmpz_coef, fmpz_poly_, index, ctx_fmpz_mod_);
      coefficient = fmpz_get_ui(fmpz_coef);
      for (bit_index = 0; bit_index < size_coefficients_bits_; ++bit_index) {
        bitsliced_polynomial[index] <<= 1;
        bitsliced_polynomial[index] |= coefficient & 1;
        coefficient >>= 1;
        ++index;
      }
    }
  }

  fmpz_clear(fmpz_coef);
  return bitsliced_polynomial;
}

std::vector<Polynomial> Sharing::Encode(fq_t& polynomial_fq,
                                        uint64_t number_of_shares,
                                        bool is_additive_masking) {
  std::vector<Polynomial> shared_polynomial(number_of_shares,
                                            Polynomial(extension_degree_));
  std::vector<fq_t> shared_polynomial_fq(number_of_shares);

  for (fq_t& share_fq : shared_polynomial_fq) {
    fq_init(share_fq, ctx_fq_);
  }

  if (is_additive_masking) {
    fq_add(shared_polynomial_fq[0], shared_polynomial_fq[0], polynomial_fq,
           ctx_fq_);

    for (uint64_t index = 1; index < number_of_shares; ++index) {
      SampleRandomPolynomial(shared_polynomial_fq[index]);
      fq_sub(shared_polynomial_fq[0], shared_polynomial_fq[0],
             shared_polynomial_fq[index], ctx_fq_);
    }
  } else {
    fq_one(shared_polynomial_fq[0], ctx_fq_);
    fq_mul(shared_polynomial_fq[0], shared_polynomial_fq[0], polynomial_fq,
           ctx_fq_);

    for (uint64_t index = 1; index < number_of_shares; ++index) {
      do {
        SampleRandomPolynomial(shared_polynomial_fq[index]);
      } while (fq_is_zero(shared_polynomial_fq[index], ctx_fq_));

      fq_t inverse_fq;
      fq_init(inverse_fq, ctx_fq_);
      fq_inv(inverse_fq, shared_polynomial_fq[index], ctx_fq_);
      fq_mul(shared_polynomial_fq[0], shared_polynomial_fq[0], inverse_fq,
             ctx_fq_);
      fq_clear(inverse_fq, ctx_fq_);
    }
  }

  for (uint64_t index = 0; index < number_of_shares; ++index) {
    ConvertFqToPolynomial(shared_polynomial_fq[index],
                          shared_polynomial[index]);
  }

  for (fq_t& share_fq : shared_polynomial_fq) {
    fq_clear(share_fq, ctx_fq_);
  }

  return shared_polynomial;
}

Polynomial Sharing::Decode(std::vector<fq_t>& shared_polynomial_fq,
                           bool is_additive_masking) {
  Polynomial polynomial(extension_degree_);
  fq_t polynomial_fq;
  fq_init(polynomial_fq, ctx_fq_);

  if (is_additive_masking) {
    for (fq_t& operand_fq : shared_polynomial_fq) {
      fq_add(polynomial_fq, polynomial_fq, operand_fq, ctx_fq_);
    }
  } else {
    fq_one(polynomial_fq, ctx_fq_);
    for (fq_t& operand_fq : shared_polynomial_fq) {
      fq_mul(polynomial_fq, polynomial_fq, operand_fq, ctx_fq_);
    }
  }

  ConvertFqToPolynomial(polynomial_fq, polynomial);
  fq_clear(polynomial_fq, ctx_fq_);
  return polynomial;
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
