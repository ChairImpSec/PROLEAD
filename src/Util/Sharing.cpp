#include "Util/Sharing.hpp"

Sharing::Sharing(uint64_t prime_base, uint64_t extension_degree,
                 const Polynomial& irreducible_polynomial, boost::mt19937& rng)
    : prime_base_(prime_base),
      extension_degree_(extension_degree),
      size_coefficients_bits_(std::ceil(std::log2l(prime_base))),
      dist_(0, std::numeric_limits<uint64_t>::max()),
      gen_(rng, dist_) {
  fmpz_init(prime_fmpz_);
  fmpz_set_ui(prime_fmpz_, prime_base_);

  if (!irreducible_polynomial.empty()) {
    fmpz_mod_ctx_init(ctx_fmpz_mod_, prime_fmpz_);
    fmpz_mod_poly_t modulus_poly;
    fmpz_mod_poly_init(modulus_poly, ctx_fmpz_mod_);

    for (uint64_t index = 0; index < irreducible_polynomial.size(); ++index) {
      fmpz_t coeff_fmpz;
      fmpz_init_set_ui(coeff_fmpz, irreducible_polynomial[index]);
      fmpz_mod_poly_set_coeff_fmpz(modulus_poly, index, coeff_fmpz,
                                   ctx_fmpz_mod_);
      fmpz_clear(coeff_fmpz);
    }

    fq_ctx_init_modulus(ctx_fq_, modulus_poly, ctx_fmpz_mod_, "x");
    fmpz_mod_poly_clear(modulus_poly, ctx_fmpz_mod_);
    fmpz_clear(prime_fmpz_);
  } else {
    fq_ctx_init(ctx_fq_, prime_fmpz_, extension_degree_, "x");
    fmpz_mod_ctx_init(ctx_fmpz_mod_, prime_fmpz_);
  }
}

Sharing::~Sharing() {
  fmpz_clear(prime_fmpz_);
  fq_ctx_clear(ctx_fq_);
  fmpz_mod_ctx_clear(ctx_fmpz_mod_);
}

std::vector<std::vector<uint64_t>> Sharing::EncodeBitsliced(
    const std::vector<uint64_t>& bitsliced_polynomial,
    uint64_t number_of_shares, bool is_additive_masking) {
  std::string error_context = "Error while encoding a bitsliced polynomial.";
  std::vector<std::vector<uint64_t>> bitsliced_shared_polynomial(
      number_of_shares, std::vector<uint64_t>(GetLengthOfElementsInBits(), 0));
  boost::dynamic_bitset<> bitset(GetLengthOfElementsInBits());
  uint64_t bit_index, share_index, simulation_index;
  std::vector<Polynomial> shared_polynomial;
  Polynomial polynomial;

  for (simulation_index = 0; simulation_index < 64; ++simulation_index) {
    for (bit_index = 0; bit_index < GetLengthOfElementsInBits(); ++bit_index) {
      bitset[bit_index] =
          (bitsliced_polynomial[bit_index] >> (63 - simulation_index)) & 1;
    }

    polynomial = ConvertBitsetToPolynomial(bitset);

    if (IsInField(polynomial)) {
      shared_polynomial =
          Encode(polynomial, number_of_shares, is_additive_masking);

      for (share_index = 0; share_index < number_of_shares; ++share_index) {
        if (IsInField(shared_polynomial[share_index])) {
          bitset = ConvertPolynomialToBitset(shared_polynomial[share_index]);

          for (bit_index = 0; bit_index < GetLengthOfElementsInBits();
               ++bit_index) {
            bitsliced_shared_polynomial[share_index][bit_index] <<= 1;
            bitsliced_shared_polynomial[share_index][bit_index] |=
                bitset[bit_index];
          }
        } else {
          throw std::invalid_argument(
              error_context +
              " One of the shared output polynomials is not in the field!");
        }
      }

    } else {
      throw std::invalid_argument(
          error_context +
          " The unshared input polynomial is not in the field!");
    }
  }

  return bitsliced_shared_polynomial;
}

std::vector<uint64_t> Sharing::DecodeBitsliced(
    const std::vector<std::vector<uint64_t>>& bitsliced_shared_polynomial,
    bool is_additive_masking) {
  std::vector<uint64_t> bitsliced_polynomial(GetLengthOfElementsInBits(), 0);
  boost::dynamic_bitset<> bitset(GetLengthOfElementsInBits());
  std::vector<Polynomial> shared_polynomial(bitsliced_shared_polynomial.size());
  uint64_t bit_index, share_index, simulation_index;
  Polynomial polynomial;

  for (simulation_index = 0; simulation_index < 64; ++simulation_index) {
    for (share_index = 0; share_index < bitsliced_shared_polynomial.size();
         ++share_index) {
      for (bit_index = 0; bit_index < GetLengthOfElementsInBits();
           ++bit_index) {
        bitset[bit_index] =
            (bitsliced_shared_polynomial[share_index][bit_index] >>
             (63 - simulation_index)) &
            1;
      }

      shared_polynomial[share_index] = ConvertBitsetToPolynomial(bitset);

      /*if (!IsInField(shared_polynomial[share_index])) {
        throw std::invalid_argument(
            "Error while decoding a bitsliced shared polynomial. The "
            "polynomial is not in the field!");
      }*/
    }

    polynomial = Decode(shared_polynomial, is_additive_masking);
    bitset = ConvertPolynomialToBitset(polynomial);

    for (bit_index = 0; bit_index < GetLengthOfElementsInBits(); ++bit_index) {
      bitsliced_polynomial[bit_index] <<= 1;
      bitsliced_polynomial[bit_index] |= bitset[bit_index];
    }
  }

  return bitsliced_polynomial;
}

uint64_t Sharing::GetLengthOfElementsInBits() const {
  return size_coefficients_bits_ * extension_degree_;
}

void Sharing::ConvertPolynomialToFq(Polynomial& polynomial,
                                    fq_t& polynomial_fq) const {
  fmpz_t coefficient_fmpz;
  fmpz_init(coefficient_fmpz);
  fmpz_mod_poly_t polynomial_fmpz;
  fmpz_mod_poly_init(polynomial_fmpz, ctx_fmpz_mod_);

  for (uint64_t index = 0; index < polynomial.size(); ++index) {
    fmpz_set_ui(coefficient_fmpz, polynomial[index]);
    fmpz_mod_poly_set_coeff_fmpz(polynomial_fmpz, index, coefficient_fmpz,
                                 ctx_fmpz_mod_);
  }

  fq_set_fmpz_mod_poly(polynomial_fq, polynomial_fmpz, ctx_fq_);
  fmpz_mod_poly_clear(polynomial_fmpz, ctx_fmpz_mod_);
  fmpz_clear(coefficient_fmpz);
}

void Sharing::ConvertFqToPolynomial(fq_t& polynomial_fq,
                                    Polynomial& polynomial) const {
  fmpz_t coefficient_fmpz;
  fmpz_init(coefficient_fmpz);
  fmpz_mod_poly_t polynomial_fmpz;
  fmpz_mod_poly_init(polynomial_fmpz, ctx_fmpz_mod_);
  fq_get_fmpz_mod_poly(polynomial_fmpz, polynomial_fq, ctx_fq_);

  for (uint64_t index = 0; index < (uint64_t)fq_ctx_degree(ctx_fq_); ++index) {
    fmpz_mod_poly_get_coeff_fmpz(coefficient_fmpz, polynomial_fmpz, index,
                                 ctx_fmpz_mod_);
    polynomial.push_back(fmpz_get_ui(coefficient_fmpz));
  }

  fmpz_mod_poly_clear(polynomial_fmpz, ctx_fmpz_mod_);
  fmpz_clear(coefficient_fmpz);
}

void Sharing::SampleRandomPolynomial(fq_t& random_polynomial_fq) {
  fmpz_mod_poly_t random_fmpz;
  fmpz_mod_poly_init(random_fmpz, ctx_fmpz_mod_);

  fmpz_t coefficient;
  fmpz_init(coefficient);

  for (uint64_t index = 0; index < extension_degree_; ++index) {
    fmpz_set_ui(coefficient, gen_());
    fmpz_mod_poly_set_coeff_fmpz(random_fmpz, index, coefficient,
                                 ctx_fmpz_mod_);
  }

  fq_set_fmpz_mod_poly(random_polynomial_fq, random_fmpz, ctx_fq_);
  fmpz_mod_poly_clear(random_fmpz, ctx_fmpz_mod_);
  fmpz_clear(coefficient);
}

std::vector<uint64_t> Sharing::SampleRandomBitslicedPolynomial() {
  uint64_t index, bit_index, bit_width = GetLengthOfElementsInBits();
  std::vector<uint64_t> bitsliced_polynomial(bit_width);
  boost::dynamic_bitset<> bitset;

  for (index = 0; index < 64; ++index) {
    fq_t polynomial_fq;
    Polynomial polynomial;
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

std::vector<Polynomial> Sharing::Encode(Polynomial& polynomial,
                                        uint64_t number_of_shares,
                                        bool is_additive_masking) {
  fq_t polynomial_fq;
  fq_init(polynomial_fq, ctx_fq_);
  ConvertPolynomialToFq(polynomial, polynomial_fq);
  std::vector<Polynomial> shared_polynomial(number_of_shares);
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

  fq_clear(polynomial_fq, ctx_fq_);
  return shared_polynomial;
}

Polynomial Sharing::Decode(std::vector<Polynomial> shared_polynomial,
                           bool is_additive_masking) const {
  Polynomial polynomial;
  fq_t polynomial_fq, operand_fq;
  fq_init(polynomial_fq, ctx_fq_);
  fq_init(operand_fq, ctx_fq_);

  if (is_additive_masking) {
    for (auto& share : shared_polynomial) {
      ConvertPolynomialToFq(share, operand_fq);
      fq_add(polynomial_fq, polynomial_fq, operand_fq, ctx_fq_);
    }
  } else {
    fq_one(polynomial_fq, ctx_fq_);
    for (auto& share : shared_polynomial) {
      ConvertPolynomialToFq(share, operand_fq);
      fq_mul(polynomial_fq, polynomial_fq, operand_fq, ctx_fq_);
    }
  }

  ConvertFqToPolynomial(polynomial_fq, polynomial);
  fq_clear(polynomial_fq, ctx_fq_);
  fq_clear(operand_fq, ctx_fq_);
  return polynomial;
}

Polynomial Sharing::ConvertBitsetToPolynomial(
    const boost::dynamic_bitset<>& bitset) const {
  uint64_t number_of_coefficients = bitset.size() / size_coefficients_bits_;
  uint64_t mask = (1 << size_coefficients_bits_) - 1;
  uint64_t bitset_as_integer = bitset.to_ulong();
  Polynomial polynomial(number_of_coefficients, 0);

  if (bitset.size() == GetLengthOfElementsInBits()) {
    for (uint64_t& coefficient : polynomial) {
      coefficient = bitset_as_integer & mask;
      bitset_as_integer >>= size_coefficients_bits_;
    }
  } else {
    throw std::invalid_argument(
        "Error while converting a bitset to a coefficient vector. The bitset "
        "size is not a multiple of the coefficient size!");
  }

  return polynomial;
}

boost::dynamic_bitset<> Sharing::ConvertPolynomialToBitset(
    const Polynomial& polynomial) const {
  uint64_t number_of_bits = GetLengthOfElementsInBits();
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
