/**
 * @file Sharing.hpp
 * @author Simon Osterheider
 */
#pragma once

#include <flint/fmpz.h>
#include <flint/fmpz_mod.h>
#include <flint/fmpz_mod_poly.h>
#include <flint/fq.h>

#include <boost/dynamic_bitset.hpp>
#include <boost/random.hpp>
#include <cstdint>
#include <iostream>
#include <random>
#include <vector>

/**
 * @brief We represent elements in GF(n^k) (polynomials) as a vector of
 * coefficients.
 *
 * In this representation, each integer in the vector corresponds to a
 * coefficient of the polynomial. Polynomial[0] represents the coefficient of
 * the polynomial's constant term (degree 0), Polynomial[1] represents the
 * coefficient of the x term (degree 1), and so on. For example, the vector
 * {1,0,1,1} in GF(2^4) represents the polynomial x^3 + x^2 + 1.
 */
using Polynomial = std::vector<uint64_t>;

class Sharing {
 public:
  /**
   * @brief Constructs a Sharing object with the given parameters, initializing
   * finite field contexts.
   *
   * This constructor initializes the Sharing object using the provided prime
   * base and extension degree. It can also use an optional irreducible
   * polynomial for finite field operations. The constructor sets up the random
   * number generator and initializes the necessary FLINT contexts for finite
   * field operations.
   *
   * @param prime_base The prime base used for finite field operations.
   * @param extension_degree The degree of the field extension.
   * @param rng The random number generator.
   * @param irreducible_polynomial The coefficients of the irreducible
   * polynomial used for finite field operations. If an empty polynomial is
   * provided, a default polynomial, chosen by FLINT will be used.
   */
  Sharing(uint64_t prime_base, uint64_t extension_degree,
          const Polynomial& irreducible_polynomial, boost::mt19937& rng);

  ~Sharing();

  /**
   * @brief Encodes a bitsliced polynomial into multiple shares.
   *
   * This function encodes a bitsliced polynomial into a specified number of
   * shares, each represented as a vector of bitsliced coefficient bits.
   *
   * @param bitsliced_polynomial The bitsliced polynomial to encode.
   * @param number_of_shares The number of shares to generate from the
   * polynomial.
   * @param is_additive_masking Flag indicating whether to apply additive
   * masking during encoding.
   * @return A vector of vectors representing the bitsliced shared polynomial
   * across multiple shares.
   *
   * @throws std::invalid_argument if the bitsliced polynomial is not valid
   * within the defined finite field.
   *
   * @details
   * - The function iterates through each bit position of the bitsliced
   * polynomial (up to 64 bits).
   * - It converts the bits at each position into a polynomial form and verifies
   * its validity within the field.
   * - If the polynomial is valid, it encodes it into multiple shares using the
   * chosen encoding scheme.
   * - Each share is further split into bits and stored in the
   * bitsliced_shared_polynomial structure.
   * - If the polynomial is not valid (i.e., not in the field), an exception is
   * thrown to indicate an error.
   */
  std::vector<std::vector<uint64_t>> EncodeBitsliced(
      const std::vector<uint64_t>& bitsliced_polynomial,
      uint64_t number_of_shares, bool is_additive_masking);

  /**
   * @brief Decodes a bitsliced shared polynomial.
   *
   * This function takes a bitsliced representation of shared polynomials and
   * decodes them into their original polynomial form.
   *
   * @param bitsliced_shared_polynomial A 2D vector where each inner vector
   * represents a share of the bitsliced polynomial. The outer vector represents
   * the different shares.
   * @param is_additive_masking A boolean flag indicating whether additive
   * masking is used.
   * @return A vector of 64-bit integers representing the decoded bitsliced
   * polynomial.
   *
   * @throws std::invalid_argument if any of the polynomials are not valid
   * elements of the field.
   *
   * The decoding process involves:
   * - Iterating through all 64 possible bit positions (simulation_index).
   * - For each bit position, extracting the relevant bit from each share and
   *   storing it in a dynamic bitset.
   * - Converting the bitset into a polynomial and checking if it is a valid
   *   element of the finite field.
   * - Decoding the shared polynomial into its original form.
   * - Reconstructing the bitsliced polynomial from the decoded polynomials.
   */
  std::vector<uint64_t> DecodeBitsliced(
      const std::vector<std::vector<uint64_t>>& bitsliced_shared_polynomial,
      bool is_additive_masking);

  /**
   * @brief Samples a random bitsliced polynomial.
   *
   * This function generates a bitsliced polynomial representation by sampling
   * random polynomials and converting them into a bitsliced representation.
   *
   * @return A std::vector<uint64_t> containing the bitsliced polynomial. Each
   *         element in the vector represents a slice of the polynomial.
   */
  std::vector<uint64_t> SampleRandomBitslicedPolynomial();

  /**
   * @brief Samples a random bitsliced polynomialfor Boolean masking.
   *
   * As SampleRandomBitslicedPolynomial is slow, we provide a faster version
   * only for Boolean masking.
   *
   * @return A std::vector<uint64_t> containing the bitsliced polynomial. Each
   *         element in the vector represents a slice of the polynomial.
   */
  std::vector<uint64_t> SampleBooleanRandomBitslicedPolynomial();

 private:
  /**
   * @brief Converts an fq_t polynomial to a polynomial represented as
   * coefficient vector.
   * @param polynomial_fq The polynomial represented as an fq_t.
   * @param polynomial_fq The converted polynomial stored as coefficient vector.
   */
  void ConvertFqToPolynomial(fq_t& polynomial_fq, Polynomial& polynomial);

  boost::dynamic_bitset<> ConvertPolynomialToBitset(
      const Polynomial& polynomial) const;

  void SampleRandomPolynomial(fq_t& random_polynomial_fq);

  /**
   * @brief Checks if a given polynomial is within the specified finite field.
   *
   * This function verifies whether the polynomial satisfies the criteria to be
   * considered an element of a finite field defined by the extension degree and
   * a prime base.
   *
   * @param polynomial The polynomial to be checked.
   * @return true if the polynomial is in the field defined by extension_degree_
   * and prime_base_, false otherwise.
   *
   * @details
   * - The function first checks if the size of the polynomial matches the
   * extension degree of the field.
   * - Then, it ensures that each coefficient of the polynomial is less than the
   * prime base of the field.
   * - If either condition fails, the function returns false, indicating that
   * the polynomial is not in the field.
   * - Otherwise, it returns true, confirming that the polynomial is a valid
   * element of the field.
   */
  bool IsInField(const Polynomial& polynomial) const;

  /**
   * @brief Encodes an unshared polynomial X into its shared representation
   * Sh(X).
   *
   * The probabilistic algorithm generates a shared representation Sh(X) = {X0,
   * X1, ..., Xd-1} from the unshared polynomial X, where X0 = X o X1 o ... o
   * Xd-1. Each Xi (i = 1 to d-1) is randomly sampled and X0 is computed such
   * that it satisfies the additive sharing property. Further, 'o' denotes the
   * operation under the finite field.
   *
   * @param polynomial_fq The unshared polynomial to be encoded.
   * @param number_of_shares The number of shares to generate, denoted as d.
   * @param is_additive_masking A boolean indicating the operation used:
   *        - true: The operation is additive, so '+' is used.
   *        - false: The operation is multiplicative, so '*' is used under the
   * finite field.
   * * @return A vector of d polynomials representing the shared
   * representation Sh(X).
   */
  std::vector<Polynomial> Encode(fq_t& polynomial_fq, uint64_t number_of_shares,
                                 bool is_additive_masking);

  /**
   * @brief Decodes a shared representation Sh(X) into its unshared polynomial
   * X.
   *
   * The deterministic algorithm comutes the unshared polynomial as X = X0 o
   * ,..., o Xd-1 based on Sh(X).
   *
   * @param shared_polynomial A vector of d polynomials representing the shared
   * representation Sh(X).
   * @param is_additive_masking A boolean indicating the operation used:
   *        - true: The operation is additive, so '+' is used.
   *        - false: The operation is multiplicative, so '*' is used under the
   * finite field.
   * @return The decoded (unshared) polynomial.
   */
  Polynomial Decode(std::vector<fq_t>& shared_polynomial_fq,
                    bool is_additive_masking);

  uint64_t prime_base_;
  uint64_t extension_degree_;
  uint64_t size_coefficients_bits_;
  uint64_t length_of_elements_in_bits_;

  fmpz_t prime_fmpz_;
  fq_ctx_t ctx_fq_;
  fmpz_mod_poly_t fmpz_poly_;
  fmpz_mod_ctx_t ctx_fmpz_mod_;
  boost::uniform_int<uint64_t> dist_;
  boost::variate_generator<boost::mt19937&, boost::uniform_int<uint64_t>> gen_;
};