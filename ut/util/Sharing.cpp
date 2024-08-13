#include "Util/Sharing.hpp"

#include <catch2/catch.hpp>

#include "Util/Util.hpp"
#include "boost/generator_iterator.hpp"
#include "boost/random.hpp"

TEST_CASE("Test the Boolean Secret Sharing", "[BooleanSecretSharing]") {
  boost::mt19937 rng;
  boost::uniform_int<uint64_t> dist(0, std::numeric_limits<uint64_t>::max());
  boost::variate_generator<boost::mt19937&, boost::uniform_int<uint64_t>> prng(
      rng, dist);
  std::vector<uint64_t> irreducible_polynomial = {1, 1};
  Sharing sharing(2, 1, irreducible_polynomial, rng);

  SECTION("Test sharing and resharing by addition in GF(2)") {
    std::vector<uint64_t> bitsliced_element(1);
    std::vector<std::vector<uint64_t>> bitsliced_shared_elements;
    uint64_t number_of_tests = 1000;
    uint64_t number_of_shares;

    for (uint64_t index = 0; index < number_of_tests; ++index) {
      bitsliced_element[0] = prng();
      number_of_shares = (prng() % 8) + 2;
      bitsliced_shared_elements =
          sharing.EncodeBitsliced(bitsliced_element, number_of_shares, true);
      REQUIRE(bitsliced_shared_elements.size() == number_of_shares);
      for (uint64_t i = 0; i < number_of_shares; ++i) {
        REQUIRE(bitsliced_shared_elements[i].size() == 1);
      }
      REQUIRE(bitsliced_element ==
              sharing.DecodeBitsliced(bitsliced_shared_elements, true));
      REQUIRE(bitsliced_element.size() == 1);
    }
  }

  SECTION("Test sharing and resharing by multiplication in GF(2)") {
    std::vector<uint64_t> bitsliced_element(1);
    std::vector<std::vector<uint64_t>> bitsliced_shared_elements;
    uint64_t number_of_tests = 1000;
    uint64_t number_of_shares;

    for (uint64_t index = 0; index < number_of_tests; ++index) {
      bitsliced_element[0] = prng();
      number_of_shares = (prng() % 8) + 2;
      bitsliced_shared_elements =
          sharing.EncodeBitsliced(bitsliced_element, number_of_shares, false);
      REQUIRE(bitsliced_shared_elements.size() == number_of_shares);
      for (uint64_t i = 0; i < number_of_shares; ++i) {
        REQUIRE(bitsliced_shared_elements[i].size() == 1);
      }
      REQUIRE(bitsliced_element ==
              sharing.DecodeBitsliced(bitsliced_shared_elements, false));
      REQUIRE(bitsliced_element.size() == 1);
    }
  }
}

TEST_CASE("Test the Rijndael Field Operations", "[RijndaelFieldSharing]") {
  boost::mt19937 rng;
  boost::uniform_int<uint64_t> dist(0, std::numeric_limits<uint64_t>::max());
  boost::variate_generator<boost::mt19937&, boost::uniform_int<uint64_t>> prng(
      rng, dist);
  Polynomial irreducible_polynomial = {1, 1, 0, 1, 1, 0, 0, 0, 1};
  Sharing sharing(2, 8, irreducible_polynomial, rng);

  SECTION("Test sharing and resharing by addition in GF(2^8)") {
    std::vector<uint64_t> bitsliced_element(8);
    std::vector<std::vector<uint64_t>> bitsliced_shared_elements;
    uint64_t number_of_tests = 1000;
    uint64_t number_of_shares;

    for (uint64_t index = 0; index < number_of_tests; ++index) {
      uint64_t value = prng() % 256;
      for (uint64_t i = 0; i < 8; ++i) {
        bitsliced_element[i] = (value >> i) & 1;
      }

      number_of_shares = (prng() % 8) + 2;

      bitsliced_shared_elements =
          sharing.EncodeBitsliced(bitsliced_element, number_of_shares, true);
      REQUIRE(bitsliced_shared_elements.size() == number_of_shares);
      for (uint64_t i = 0; i < number_of_shares; ++i) {
        REQUIRE(bitsliced_shared_elements[i].size() == 8);
      }
      REQUIRE(bitsliced_element ==
              sharing.DecodeBitsliced(bitsliced_shared_elements, true));
      REQUIRE(bitsliced_element.size() == 8);
    }
  }

  SECTION("Test sharing and resharing by multiplication in GF(2^8)") {
    std::vector<uint64_t> bitsliced_element(8);
    std::vector<std::vector<uint64_t>> bitsliced_shared_elements;
    uint64_t number_of_tests = 1000;
    uint64_t number_of_shares;

    for (uint64_t index = 0; index < number_of_tests; ++index) {
      uint64_t value = prng() % 256;
      for (uint64_t i = 0; i < 8; ++i) {
        bitsliced_element[i] = (value >> i) & 1;
      }

      number_of_shares = (prng() % 8) + 2;

      bitsliced_shared_elements =
          sharing.EncodeBitsliced(bitsliced_element, number_of_shares, false);
      REQUIRE(bitsliced_shared_elements.size() == number_of_shares);
      for (uint64_t i = 0; i < number_of_shares; ++i) {
        REQUIRE(bitsliced_shared_elements[i].size() == 8);
      }
      REQUIRE(bitsliced_element ==
              sharing.DecodeBitsliced(bitsliced_shared_elements, false));
      REQUIRE(bitsliced_element.size() == 8);
    }
  }
}

TEST_CASE(
    "Test the Rijndael Field Operations with different irreducible polynomial",
    "[AlternativRijndaelFieldSharing]") {
  boost::mt19937 rng;
  boost::uniform_int<uint64_t> dist(0, std::numeric_limits<uint64_t>::max());
  boost::variate_generator<boost::mt19937&, boost::uniform_int<uint64_t>> prng(
      rng, dist);
  std::vector<uint64_t> irreducible_polynomial = {1, 0, 1, 1, 1, 1, 0, 1, 1};
  Sharing sharing(2, 8, irreducible_polynomial, rng);

  SECTION(
      "Test sharing and resharing by addition in GF(2^8) with polynomial "
      "0x1bd") {
    std::vector<uint64_t> bitsliced_element(8);
    std::vector<std::vector<uint64_t>> bitsliced_shared_elements;
    uint64_t number_of_tests = 1000;
    uint64_t number_of_shares;

    for (uint64_t index = 0; index < number_of_tests; ++index) {
      uint64_t value = prng() % 256;
      for (uint64_t i = 0; i < 8; ++i) {
        bitsliced_element[i] = (value >> i) & 1;
      }

      number_of_shares = (prng() % 8) + 2;

      bitsliced_shared_elements =
          sharing.EncodeBitsliced(bitsliced_element, number_of_shares, true);
      REQUIRE(bitsliced_shared_elements.size() == number_of_shares);
      for (uint64_t i = 0; i < number_of_shares; ++i) {
        REQUIRE(bitsliced_shared_elements[i].size() == 8);
      }
      REQUIRE(bitsliced_element ==
              sharing.DecodeBitsliced(bitsliced_shared_elements, true));
      REQUIRE(bitsliced_element.size() == 8);
    }
  }

  SECTION(
      "Test sharing and resharing by multiplication in GF(2^8) with polynomial "
      "0x1bd") {
    std::vector<uint64_t> bitsliced_element(8);
    std::vector<std::vector<uint64_t>> bitsliced_shared_elements;
    uint64_t number_of_tests = 1000;
    uint64_t number_of_shares;

    for (uint64_t index = 0; index < number_of_tests; ++index) {
      uint64_t value = prng() % 256;
      for (uint64_t i = 0; i < 8; ++i) {
        bitsliced_element[i] = (value >> i) & 1;
      }

      number_of_shares = (prng() % 8) + 2;

      bitsliced_shared_elements =
          sharing.EncodeBitsliced(bitsliced_element, number_of_shares, false);
      REQUIRE(bitsliced_shared_elements.size() == number_of_shares);
      for (uint64_t i = 0; i < number_of_shares; ++i) {
        REQUIRE(bitsliced_shared_elements[i].size() == 8);
      }
      REQUIRE(bitsliced_element ==
              sharing.DecodeBitsliced(bitsliced_shared_elements, false));
      REQUIRE(bitsliced_element.size() == 8);
    }
  }
}