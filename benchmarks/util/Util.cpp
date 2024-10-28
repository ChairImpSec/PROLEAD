#define CATCH_CONFIG_ENABLE_BENCHMARKING
#include "Util/Util.hpp"

#include <catch2/catch.hpp>

TEST_CASE("Benchmark sorting and merging of duplicates",
          "[Benchmark][SortAndMergeDuplicates]") {
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

  BENCHMARK_ADVANCED(
      "size of key (bytes) = " + std::to_string(size_of_key_in_bytes) + "\n" +
      "number of entries = " + std::to_string(number_of_entries))
  (Catch::Benchmark::Chronometer meter) {
    meter.measure([&observations, size_of_key_in_bytes, number_of_groups] {
      SortAndMergeDuplicates(observations, size_of_key_in_bytes,
                             number_of_groups);
    });
  };
}

TEST_CASE(
    "Benchmark the update of bucket entries with entries from another bucket",
    "[Benchmark][UpdateBucketWithBucket]") {
  uint64_t i, j;
  TableBucketVector bucket, observations;
  uint64_t number_of_groups, size_of_key_in_bytes, number_of_entries;
  std::random_device rd;
  std::mt19937 gen(rd());
  std::uniform_int_distribution<uint8_t> dis(0, 255);

  number_of_groups = GENERATE(2, 3);
  size_of_key_in_bytes = GENERATE(1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024);
  number_of_entries = GENERATE(1, 10, 100, 1000, 10000, 100000, 1000000);
  bucket.resize(number_of_entries);
  observations.resize(number_of_entries);

  for (i = 0; i < number_of_entries; ++i) {
    bucket[i].key_ = std::make_unique<uint8_t[]>(size_of_key_in_bytes);
    bucket[i].data_ = std::make_unique<uint32_t[]>(number_of_groups);
    observations[i].key_ = std::make_unique<uint8_t[]>(size_of_key_in_bytes);
    observations[i].data_ = std::make_unique<uint32_t[]>(number_of_groups);

    for (j = 0; j < size_of_key_in_bytes; ++j) {
      bucket[i].key_[j] = dis(gen);
      observations[i].key_[j] = dis(gen);
    }

    for (j = 0; j < number_of_groups; ++j) {
      bucket[i].data_[j] = dis(gen);
      observations[i].data_[j] = dis(gen);
    }
  }

  SortAndMergeDuplicates(bucket, size_of_key_in_bytes, number_of_groups);
  SortAndMergeDuplicates(observations, size_of_key_in_bytes, number_of_groups);

  BENCHMARK_ADVANCED(
      "number of groups = " + std::to_string(number_of_groups) + "\n" +
      "size of key (bytes) = " + std::to_string(size_of_key_in_bytes) + "\n" +
      "number of entries = " + std::to_string(number_of_entries))
  (Catch::Benchmark::Chronometer meter) {
    meter.measure(
        [&bucket, &observations, size_of_key_in_bytes, number_of_groups] {
          UpdateBucketWithBucket(bucket, observations, size_of_key_in_bytes,
                                 number_of_groups);
        });
  };
}

TEST_CASE("Benchmark computation of required sample size",
          "[Benchmark][ComputeRequiredSampleSize]") {
  uint64_t number_of_groups = GENERATE(2, 3);
  uint64_t number_of_entries =
      GENERATE(10, 100, 1000, 10000, 100000, 1000000, 10000000);
  double_t effect_size = GENERATE(0.1, 0.3, 0.5);
  double_t beta_threshold = GENERATE(0.00001, 0.0001, 0.001, 0.01, 0.1, 0.2);

  BENCHMARK_ADVANCED(
      "number of groups = " + std::to_string(number_of_groups) + "\n" +
      "number of entries = " + std::to_string(number_of_entries) + "\n" +
      "effect size = " + std::to_string(effect_size) + "\n" +
      "beta threshold = " + std::to_string(beta_threshold))
  (Catch::Benchmark::Chronometer meter) {
    meter.measure(
        [number_of_groups, number_of_entries, beta_threshold, effect_size] {
          ComputeRequiredSampleSize(number_of_groups, number_of_entries,
                                    beta_threshold, effect_size);
        });
  };
}

TEST_CASE("Benchmark the construction of simulated table entries",
          "[Benchmark][ConstructTableEntries]") {
  uint64_t number_of_groups = GENERATE(2, 3);
  uint64_t size_of_key_in_bytes = GENERATE(1, 64, 1024);
  uint64_t number_of_entries = GENERATE(64, 16384, 524288);
  TableBucketVector datasets;

  BENCHMARK_ADVANCED(
      "number of groups = " + std::to_string(number_of_groups) + "\n" +
      "number of entries = " + std::to_string(number_of_entries) + "\n" +
      "size of key (bytes) = " + std::to_string(size_of_key_in_bytes))
  (Catch::Benchmark::Chronometer meter) {
    meter.measure([&datasets, number_of_groups, number_of_entries,
                   size_of_key_in_bytes] {
      datasets.resize(number_of_entries);

      for (uint64_t i = 0; i < number_of_entries; ++i) {
        datasets[i].key_ = std::make_unique<uint8_t[]>(size_of_key_in_bytes);
        datasets[i].data_ = std::make_unique<uint32_t[]>(number_of_groups);
      }
    });
  };
}
