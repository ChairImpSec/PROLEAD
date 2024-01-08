#define CATCH_CONFIG_ENABLE_BENCHMARKING
#include "Util/Util.hpp"

#include <catch2/catch.hpp>

TEST_CASE("Test the bucket constructor",
          "[TableBucket<TableBucketVector>::TableBucket(Key, size_t)]") {
  SECTION("Insert empty key and empty number of groups") {
    size_t number_of_groups = 0;
    hardware::stats::Key key = std::make_unique<unsigned char[]>(0);
    hardware::stats::TableBucket<hardware::stats::TableBucketVector>
        table_bucket(std::move(key), number_of_groups);
    REQUIRE(table_bucket.GetNumberOfEntries() == 1);
  }

  SECTION("Insert key and empty multiple groups") {
    size_t number_of_groups = 2;
    hardware::stats::Key key = std::make_unique<unsigned char[]>(2);
    hardware::stats::TableBucket<hardware::stats::TableBucketVector>
        table_bucket(std::move(key), number_of_groups);
    REQUIRE(table_bucket.GetNumberOfEntries() == 1);
    REQUIRE(table_bucket.GetCounters(0)[0] == 0);
    REQUIRE(table_bucket.GetCounters(0)[1] == 0);
  }
}

TEST_CASE("Test the incrementation of counter in a bucket",
          "[void TableBucket<TableBucketVector>::Increment(Key, size_t, "
          "size_t, size_t)]") {
  size_t byte_index, key_index;
  size_t number_of_groups = 2;
  size_t size_of_key_in_bytes = 1;
  size_t number_of_keys_to_test = 5;
  hardware::stats::Key key =
      std::make_unique<unsigned char[]>(size_of_key_in_bytes);

  for (byte_index = 0; byte_index < size_of_key_in_bytes; ++byte_index) {
    key[byte_index] = byte_index;
  }

  SECTION("Insert the same key multiple times for a fixed group") {
    hardware::stats::TableBucket<hardware::stats::TableBucketVector>
        table_bucket(std::move(key), number_of_groups);

    for (key_index = 0; key_index < number_of_keys_to_test; ++key_index) {
      key = std::make_unique<unsigned char[]>(size_of_key_in_bytes);

      for (byte_index = 0; byte_index < size_of_key_in_bytes; ++byte_index) {
        key[byte_index] = byte_index;
      }

      table_bucket.Increment(std::move(key), number_of_groups, 0,
                             size_of_key_in_bytes);
    }

    REQUIRE(table_bucket.GetNumberOfEntries() == 1);
    REQUIRE(table_bucket.GetCounters(0)[0] == number_of_keys_to_test);
    REQUIRE(table_bucket.GetCounters(0)[1] == 0);
  }

  SECTION("Insert the same key multiple times for 2 alternating groups") {
    hardware::stats::TableBucket<hardware::stats::TableBucketVector>
        table_bucket(std::move(key), number_of_groups);

    for (key_index = 0; key_index < number_of_keys_to_test; ++key_index) {
      key = std::make_unique<unsigned char[]>(size_of_key_in_bytes);

      for (byte_index = 0; byte_index < size_of_key_in_bytes; ++byte_index) {
        key[byte_index] = byte_index;
      }

      table_bucket.Increment(std::move(key), number_of_groups,
                             key_index % number_of_groups,
                             size_of_key_in_bytes);
    }

    REQUIRE(table_bucket.GetNumberOfEntries() == 1);
    REQUIRE(table_bucket.GetCounters(0)[0] == 3);
    REQUIRE(table_bucket.GetCounters(0)[1] == 2);
  }

  SECTION("Insert the same key multiple times for a fixed group") {
    hardware::stats::TableBucket<hardware::stats::TableBucketVector>
        table_bucket(std::move(key), number_of_groups);

    for (key_index = 0; key_index < number_of_keys_to_test; ++key_index) {
      key = std::make_unique<unsigned char[]>(size_of_key_in_bytes);

      for (byte_index = 0; byte_index < size_of_key_in_bytes; ++byte_index) {
        key[byte_index] = byte_index + key_index;
      }

      table_bucket.Increment(std::move(key), number_of_groups, 0,
                             size_of_key_in_bytes);
    }

    REQUIRE(table_bucket.GetNumberOfEntries() == number_of_keys_to_test);

    for (key_index = 0; key_index < number_of_keys_to_test; ++key_index) {
      REQUIRE(table_bucket.GetCounters(key_index)[0] == 1);
      REQUIRE(table_bucket.GetCounters(key_index)[1] == 0);
    }
  }
}