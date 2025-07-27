#include "Util/Sharing.hpp"

#include <boost/math/distributions/chi_squared.hpp>
#include <boost/test/unit_test.hpp>

#include "boost/generator_iterator.hpp"
#include "boost/random.hpp"

namespace utf = boost::unit_test;

BOOST_AUTO_TEST_SUITE(test_sharing)

double GTestGoodnessOfFit(const std::vector<uint64_t>& dist) {
  uint64_t degrees_of_freedom;
  double g_test_statistic = 0.0;
  double expectation = 0.0;
  double portion, sum = 0.0;

  for (uint64_t idx = 0; idx < dist.size(); ++idx) {
    if (dist[idx] > 0) {
      expectation += 1.0;
      sum += dist[idx];
    }
  }

  degrees_of_freedom = dist.size() - 1;
  expectation = sum / expectation;
  for (uint64_t idx = 0; idx < dist.size(); ++idx) {
    if (dist[idx] > 0) {
      portion = static_cast<double>(dist[idx]) / expectation;
      g_test_statistic += dist[idx] * std::log(portion);
    }
  }
  g_test_statistic *= 2.0;

  boost::math::chi_squared_distribution<> distribution(degrees_of_freedom);
  double_t p_value =
      boost::math::cdf(boost::math::complement(distribution, g_test_statistic));
  return -std::log10(p_value);
}

void CheckCoefficients(const std::vector<uint64_t>& bs_poly,
                       uint64_t finite_field_base,
                       uint64_t finite_field_exponent) {
  uint64_t coeff = 0;
  uint64_t number_of_coeff_bits = std::ceil(std::log2l(finite_field_base));
  uint64_t number_of_bits = number_of_coeff_bits * finite_field_exponent;

  BOOST_CHECK_MESSAGE(bs_poly.size() == number_of_bits,
                      "Sampled bitsliced polynomial size mismatch! Expected: "
                          << number_of_bits << ", Got: " << bs_poly.size());

  for (uint64_t sim_idx = 0; sim_idx < 64; ++sim_idx) {
    for (uint64_t bit_idx = 0; bit_idx < bs_poly.size(); ++bit_idx) {
      if (bit_idx % number_of_coeff_bits == 0 && bit_idx > 0) {
        BOOST_CHECK_MESSAGE(
            coeff < finite_field_base,
            "Coefficient: " << coeff << " is not in the field!");
        coeff = 0;
      }

      coeff |= ((bs_poly[bit_idx] >> sim_idx) & 1)
               << (bit_idx % number_of_coeff_bits);
    }
  }
}

void UpdateDistributions(std::vector<uint64_t>& bs_poly,
                         std::vector<uint64_t>& dist) {
  uint64_t coeff = 0;
  for (uint64_t sim_idx = 0; sim_idx < 64; ++sim_idx) {
    for (uint64_t bit_idx = 0; bit_idx < bs_poly.size(); ++bit_idx) {
      coeff |= ((bs_poly[bit_idx] >> sim_idx) & 1) << bit_idx;
    }

    dist[coeff]++;
    coeff = 0;
  }
}

void CheckCorrectness(uint64_t number_of_tests, uint64_t finite_field_base,
                      uint64_t finite_field_exponent,
                      const Polynomial& irreducible_polynomial,
                      bool is_additive_masking) {
  Polynomial bs_poly;
  std::vector<Polynomial> bs_sh_poly;
  uint64_t number_of_shares;

  boost::mt19937 rng;
  boost::uniform_int<uint64_t> dist(0, std::numeric_limits<uint64_t>::max());
  boost::variate_generator<boost::mt19937&, boost::uniform_int<uint64_t>> prng(
      rng, dist);

  Sharing sharing(finite_field_base, finite_field_exponent,
                  irreducible_polynomial, rng);

  for (uint64_t idx = 0; idx < number_of_tests; ++idx) {
    bs_poly = sharing.SampleRandomBitslicedPolynomial();
    CheckCoefficients(bs_poly, finite_field_base, finite_field_exponent);
    number_of_shares = (prng() % 8) + 2;
    bs_sh_poly =
        sharing.EncodeBitsliced(bs_poly, number_of_shares, is_additive_masking);
    BOOST_CHECK_MESSAGE(bs_sh_poly.size() == number_of_shares,
                        "Encoded bitsliced polynomial size mismatch! Expected: "
                            << number_of_shares
                            << ", Got: " << bs_sh_poly.size());

    for (const Polynomial& bs_poly_share : bs_sh_poly) {
      CheckCoefficients(bs_poly_share, finite_field_base,
                        finite_field_exponent);
    }

    BOOST_CHECK_MESSAGE(
        bs_poly == sharing.DecodeBitsliced(bs_sh_poly, is_additive_masking),
        "Decoded bitsliced polynomial does not match original!");
  }
}

void CheckUniformity(uint64_t number_of_tests, uint64_t finite_field_base,
                     uint64_t finite_field_exponent,
                     const Polynomial& irreducible_polynomial) {
  Polynomial bs_poly;
  std::vector<Polynomial> bs_sh_poly;

  boost::mt19937 rng;
  boost::uniform_int<uint64_t> dist(0, std::numeric_limits<uint64_t>::max());
  boost::variate_generator<boost::mt19937&, boost::uniform_int<uint64_t>> prng(
      rng, dist);

  Sharing sharing(finite_field_base, finite_field_exponent,
                  irreducible_polynomial, rng);

  std::vector<uint64_t> hist(
      static_cast<uint64_t>(std::pow(finite_field_base, finite_field_exponent)),
      0);
  for (uint64_t idx = 0; idx < number_of_tests; ++idx) {
    bs_poly = sharing.SampleRandomBitslicedPolynomial();
    UpdateDistributions(bs_poly, hist);
  }

  BOOST_CHECK_MESSAGE(
      GTestGoodnessOfFit(hist) <= 5.0,
      "Distribution of unshared coefficients is not uniform! G-test statistic: "
          << GTestGoodnessOfFit(hist));
}

BOOST_AUTO_TEST_CASE(test_gf2, *utf::label("sharing") * utf::label("gf2")) {
  uint64_t number_of_tests = 1000;
  uint64_t finite_field_base = 2;
  uint64_t finite_field_exponent = 1;
  Polynomial irreducible_polynomial;
  CheckCorrectness(number_of_tests, finite_field_base, finite_field_exponent,
                   irreducible_polynomial, true);
  CheckCorrectness(number_of_tests, finite_field_base, finite_field_exponent,
                   irreducible_polynomial, false);
  CheckUniformity(number_of_tests, finite_field_base, finite_field_exponent,
                  irreducible_polynomial);
}

BOOST_AUTO_TEST_CASE(test_gf3, *utf::label("sharing") * utf::label("gf3")) {
  uint64_t number_of_tests = 1000;
  uint64_t finite_field_base = 3;
  uint64_t finite_field_exponent = 1;
  Polynomial irreducible_polynomial;
  CheckCorrectness(number_of_tests, finite_field_base, finite_field_exponent,
                   irreducible_polynomial, true);
  CheckCorrectness(number_of_tests, finite_field_base, finite_field_exponent,
                   irreducible_polynomial, false);
  CheckUniformity(number_of_tests, finite_field_base, finite_field_exponent,
                  irreducible_polynomial);
}

BOOST_AUTO_TEST_CASE(test_gf7, *utf::label("sharing") * utf::label("gf7")) {
  uint64_t number_of_tests = 1000;
  uint64_t finite_field_base = 7;
  uint64_t finite_field_exponent = 1;
  Polynomial irreducible_polynomial;
  CheckCorrectness(number_of_tests, finite_field_base, finite_field_exponent,
                   irreducible_polynomial, true);
  CheckCorrectness(number_of_tests, finite_field_base, finite_field_exponent,
                   irreducible_polynomial, false);
  CheckUniformity(number_of_tests, finite_field_base, finite_field_exponent,
                  irreducible_polynomial);
}

BOOST_AUTO_TEST_CASE(test_gf31, *utf::label("sharing") * utf::label("gf31")) {
  uint64_t number_of_tests = 1000;
  uint64_t finite_field_base = 31;
  uint64_t finite_field_exponent = 1;
  Polynomial irreducible_polynomial;
  CheckCorrectness(number_of_tests, finite_field_base, finite_field_exponent,
                   irreducible_polynomial, true);
  CheckCorrectness(number_of_tests, finite_field_base, finite_field_exponent,
                   irreducible_polynomial, false);
  CheckUniformity(number_of_tests, finite_field_base, finite_field_exponent,
                  irreducible_polynomial);
}

BOOST_AUTO_TEST_CASE(test_gf127, *utf::label("sharing") * utf::label("gf127")) {
  uint64_t number_of_tests = 1000;
  uint64_t finite_field_base = 127;
  uint64_t finite_field_exponent = 1;
  Polynomial irreducible_polynomial;
  CheckCorrectness(number_of_tests, finite_field_base, finite_field_exponent,
                   irreducible_polynomial, true);
  CheckCorrectness(number_of_tests, finite_field_base, finite_field_exponent,
                   irreducible_polynomial, false);
  CheckUniformity(number_of_tests, finite_field_base, finite_field_exponent,
                  irreducible_polynomial);
}

BOOST_AUTO_TEST_CASE(test_rijndael,
                     *utf::label("sharing") * utf::label("rijndael")) {
  uint64_t number_of_tests = 1000;
  uint64_t finite_field_base = 2;
  uint64_t finite_field_exponent = 8;
  Polynomial irreducible_polynomial = {1, 1, 0, 1, 1, 0, 0, 0, 1};
  CheckCorrectness(number_of_tests, finite_field_base, finite_field_exponent,
                   irreducible_polynomial, true);
  CheckCorrectness(number_of_tests, finite_field_base, finite_field_exponent,
                   irreducible_polynomial, false);
  CheckUniformity(number_of_tests, finite_field_base, finite_field_exponent,
                  irreducible_polynomial);
}

BOOST_AUTO_TEST_CASE(test_alternativ_rijndael,
                     *utf::label("sharing") *
                         utf::label("alternativ_rijndael")) {
  uint64_t number_of_tests = 1000;
  uint64_t finite_field_base = 2;
  uint64_t finite_field_exponent = 8;
  Polynomial irreducible_polynomial = {1, 0, 1, 1, 1, 1, 0, 1, 1};
  CheckCorrectness(number_of_tests, finite_field_base, finite_field_exponent,
                   irreducible_polynomial, true);
  CheckCorrectness(number_of_tests, finite_field_base, finite_field_exponent,
                   irreducible_polynomial, false);
  CheckUniformity(number_of_tests, finite_field_base, finite_field_exponent,
                  irreducible_polynomial);
}

BOOST_AUTO_TEST_SUITE_END()
