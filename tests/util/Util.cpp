#include "Util/Util.hpp"

#include <catch2/catch.hpp>

TEST_CASE("Test sorting and merging of duplicates",
          "[SortAndMergeDuplicates]") {
  uint64_t i, j;
  uint64_t number_of_groups = 2;
  uint64_t size_of_key_in_bytes =
      GENERATE(1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024);
  uint64_t number_of_entries = GENERATE(64, 1024, 2048, 4096, 8192, 16384,
                                        32768, 65536, 131072, 262144, 524288);
  std::random_device rd;
  std::mt19937 gen(rd());
  std::uniform_int_distribution<uint8_t> dis(0, 255);
  TableBucketVector observations(number_of_entries);

  for (i = 0; i < number_of_entries; ++i) {
    observations[i].key_ = std::make_unique<uint8_t[]>(size_of_key_in_bytes);
    observations[i].data_ = std::make_unique<uint32_t[]>(number_of_groups);

    for (j = 0; j < size_of_key_in_bytes; ++j) {
      observations[i].key_[j] = dis(gen);
    }

    ++observations[i].data_[dis(gen) % number_of_groups];
  }

  SortAndMergeDuplicates(observations, size_of_key_in_bytes, number_of_groups);
  for (i = 1; i < observations.size(); ++i) {
    REQUIRE(std::memcmp(observations[i - 1].key_.get(),
                        observations[i].key_.get(), size_of_key_in_bytes) < 0);
  }
}

TEST_CASE("Test the update of bucket entries with entries from another bucket",
          "[UpdateBucketWithBucket]") {
  TableBucketVector bucket, observations;
  uint64_t number_of_groups, size_of_key_in_bytes, number_of_entries;
  std::random_device rd;
  std::mt19937 gen(rd());
  std::uniform_int_distribution<uint8_t> dis(0, 255);

  number_of_groups = 2;
  size_of_key_in_bytes = 1;
  number_of_entries = 2;

  bucket.resize(number_of_entries);
  observations.resize(number_of_entries);

  for (uint64_t index = 0; index < number_of_entries; ++index) {
    bucket[index].key_ = std::make_unique<uint8_t[]>(size_of_key_in_bytes);
    bucket[index].data_ = std::make_unique<uint32_t[]>(number_of_groups);
    observations[index].key_ =
        std::make_unique<uint8_t[]>(size_of_key_in_bytes);
    observations[index].data_ = std::make_unique<uint32_t[]>(number_of_groups);
  }

  bucket[0].key_[0] = 0;
  bucket[0].data_[0] = 1;
  bucket[0].data_[1] = 2;

  bucket[1].key_[0] = 1;
  bucket[1].data_[0] = 3;
  bucket[1].data_[1] = 4;

  observations[0].key_[0] = 1;
  observations[0].data_[0] = 5;
  observations[0].data_[1] = 6;

  observations[1].key_[0] = 2;
  observations[1].data_[0] = 7;
  observations[1].data_[1] = 8;

  UpdateBucketWithBucket(bucket, observations, size_of_key_in_bytes,
                         number_of_groups);

  REQUIRE(bucket.size() == 2);
  REQUIRE(bucket[0].key_[0] == 0);
  REQUIRE(bucket[0].data_[0] == 1);
  REQUIRE(bucket[0].data_[1] == 2);
  REQUIRE(bucket[1].key_[0] == 1);
  REQUIRE(bucket[1].data_[0] == 8);
  REQUIRE(bucket[1].data_[1] == 10);
  REQUIRE(observations.size() == 1);
  REQUIRE(observations[0].key_[0] == 2);
  REQUIRE(observations[0].data_[0] == 7);
  REQUIRE(observations[0].data_[1] == 8);
}

TEST_CASE(
    "Test if the number of samples is high enough to achieve a desired "
    "confidence",
    "[IsSampleSizeSufficient]") {
  uint64_t number_of_groups = 2;
  std::pair<uint64_t, uint64_t> test_vectors =
      GENERATE(std::make_pair(10, 10072), std::make_pair(100, 18701),
               std::make_pair(1000, 45110), std::make_pair(10000, 127784),
               std::make_pair(100000, 388698), std::make_pair(1000000, 1213556),
               std::make_pair(10000000, 3821906));

  double_t effect_size = 0.1;
  double_t beta_threshold = 0.00001;
  uint64_t lower_sample_size = test_vectors.second - 1;
  uint64_t higher_sample_size = test_vectors.second + 1;

  SECTION("Test for number_of_entries = " +
          std::to_string(test_vectors.first)) {
    REQUIRE_FALSE(IsSampleSizeSufficient(lower_sample_size, number_of_groups,
                                         test_vectors.first, beta_threshold,
                                         effect_size));
    REQUIRE(IsSampleSizeSufficient(higher_sample_size, number_of_groups,
                                   test_vectors.first, beta_threshold,
                                   effect_size));
  }
}

TEST_CASE("Test computation of required sample size",
          "[ComputeRequiredSampleSize]") {
  uint64_t number_of_groups = 2;
  std::pair<uint64_t, uint64_t> test_vectors =
      GENERATE(std::make_pair(10, 10072), std::make_pair(100, 18701),
               std::make_pair(1000, 45110), std::make_pair(10000, 127784),
               std::make_pair(100000, 388698), std::make_pair(1000000, 1213556),
               std::make_pair(10000000, 3821906));

  double_t effect_size = 0.1;
  double_t beta_threshold = 0.00001;
  uint64_t number_of_samples = ComputeRequiredSampleSize(
      number_of_groups, test_vectors.first, beta_threshold, effect_size);
  REQUIRE(number_of_samples == test_vectors.second);
}

TEST_CASE("Test the construction of simulated table entries",
          "[ConstructTableEntries]") {
  uint64_t number_of_groups = GENERATE(2, 3);
  uint64_t size_of_key_in_bytes = GENERATE(1, 64, 1024);
  uint64_t number_of_entries = GENERATE(64, 16384, 524288);
  uint64_t index, byte_index;
  TableBucketVector datasets;

  datasets.resize(number_of_entries);

  for (index = 0; index < number_of_entries; ++index) {
    datasets[index].key_ = std::make_unique<uint8_t[]>(size_of_key_in_bytes);
    datasets[index].data_ = std::make_unique<uint32_t[]>(number_of_groups);
  }

  for (index = 0; index < number_of_entries; ++index) {
    for (byte_index = 0; byte_index < size_of_key_in_bytes; ++byte_index) {
      REQUIRE(datasets[index].key_[byte_index] == 0);
    }

    for (byte_index = 0; byte_index < number_of_groups; ++byte_index) {
      REQUIRE(datasets[index].data_[byte_index] == 0);
    }
  }
}
