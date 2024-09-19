#define CATCH_CONFIG_ENABLE_BENCHMARKING
#include "Util/Sharing.hpp"

#include <catch2/catch.hpp>

TEST_CASE("Benchmark the Boolean secret sharing",
          "[Benchmark][BooleanSecretSharing]") {
  boost::mt19937 rng;
  boost::uniform_int<uint64_t> dist(0, std::numeric_limits<uint64_t>::max());
  boost::variate_generator<boost::mt19937&, boost::uniform_int<uint64_t>> prng(
      rng, dist);
  std::vector<uint64_t> irreducible_polynomial = {1, 1};
  Sharing sharing(2, 1, irreducible_polynomial, rng);

  SECTION("Encode") {
    std::vector<uint64_t> bitsliced_element(1);
    uint64_t number_of_shares = GENERATE(1, 2, 3, 4, 5, 6, 7, 8);
    bitsliced_element[0] = prng();

    BENCHMARK_ADVANCED("number of shares (encode) = " +
                       std::to_string(number_of_shares))
    (Catch::Benchmark::Chronometer meter) {
      meter.measure([&sharing, bitsliced_element, number_of_shares] {
        sharing.EncodeBitsliced(bitsliced_element, number_of_shares, false);
      });
    };
  }

  SECTION("Decode") {
    std::vector<uint64_t> bitsliced_element(1);
    std::vector<std::vector<uint64_t>> bitsliced_shared_elements;
    uint64_t number_of_shares = GENERATE(1, 2, 3, 4, 5, 6, 7, 8);
    bitsliced_element[0] = prng();
    bitsliced_shared_elements =
        sharing.EncodeBitsliced(bitsliced_element, number_of_shares, false);

    BENCHMARK_ADVANCED("number of shares (decode) = " +
                       std::to_string(number_of_shares))
    (Catch::Benchmark::Chronometer meter) {
      meter.measure([&sharing, bitsliced_shared_elements] {
        sharing.DecodeBitsliced(bitsliced_shared_elements, false);
      });
    };
  }
}

TEST_CASE("Benchmark the secret sharing in Rijndael field",
          "[Benchmark][RijndaelFieldSharing]") {
  boost::mt19937 rng;
  boost::uniform_int<uint64_t> dist(0, std::numeric_limits<uint64_t>::max());
  boost::variate_generator<boost::mt19937&, boost::uniform_int<uint64_t>> prng(
      rng, dist);
  Polynomial irreducible_polynomial = {1, 1, 0, 1, 1, 0, 0, 0, 1};
  Sharing sharing(2, 8, irreducible_polynomial, rng);

  SECTION("Encode") {
    std::vector<uint64_t> bitsliced_element(1);
    uint64_t number_of_shares = GENERATE(1, 2, 3, 4, 5, 6, 7, 8);
    bitsliced_element[0] = prng();

    BENCHMARK_ADVANCED("number of shares (encode) = " +
                       std::to_string(number_of_shares))
    (Catch::Benchmark::Chronometer meter) {
      meter.measure([&sharing, bitsliced_element, number_of_shares] {
        sharing.EncodeBitsliced(bitsliced_element, number_of_shares, false);
      });
    };
  }

  SECTION("Decode") {
    std::vector<uint64_t> bitsliced_element(1);
    std::vector<std::vector<uint64_t>> bitsliced_shared_elements;
    uint64_t number_of_shares = GENERATE(1, 2, 3, 4, 5, 6, 7, 8);
    bitsliced_element[0] = prng();
    bitsliced_shared_elements =
        sharing.EncodeBitsliced(bitsliced_element, number_of_shares, false);

    BENCHMARK_ADVANCED("number of shares (decode) = " +
                       std::to_string(number_of_shares))
    (Catch::Benchmark::Chronometer meter) {
      meter.measure([&sharing, bitsliced_shared_elements] {
        sharing.DecodeBitsliced(bitsliced_shared_elements, false);
      });
    };
  }
}