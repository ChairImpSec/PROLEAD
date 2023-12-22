#define CATCH_CONFIG_ENABLE_BENCHMARKING
#include <catch2/catch.hpp>
#include "Hardware/Probing.hpp"

TEST_CASE("Test the removing of duplicates from a vector", "[void RemoveDuplicates(std::vector<ExtensionContainer>& extensions)]"){
    SECTION("Empty vector"){
        std::vector<unsigned int> test_vector = {};
        std::vector<unsigned int> expected_result = {};
        Hardware::probing::RemoveDuplicates(test_vector);
        REQUIRE(test_vector == expected_result);
    }

    SECTION("Vector with no duplicates"){
        std::vector<unsigned int> test_vector = {1, 2, 3, 4, 5};
        std::vector<unsigned int> expected_result = {5, 4, 3, 2, 1};
        Hardware::probing::RemoveDuplicates(test_vector);
        REQUIRE(test_vector == expected_result);
    }

    SECTION("Vector with all duplicates"){
        std::vector<unsigned int> test_vector = {2, 2, 2, 2, 2};
        std::vector<unsigned int> expected_result = {2};
        Hardware::probing::RemoveDuplicates(test_vector);
        REQUIRE(test_vector == expected_result);
    }

    SECTION("Vector with some duplicates"){
        std::vector<unsigned int> test_vector = {4, 2, 8, 4, 6, 2, 1};
        std::vector<unsigned int> expected_result = {8, 6, 4, 2, 1};
        Hardware::probing::RemoveDuplicates(test_vector);
        REQUIRE(test_vector == expected_result);
    }

    SECTION("Vector with duplicates at the beginning or end"){
        std::vector<unsigned int> test_vector = {2, 2, 3, 4, 5, 5};
        std::vector<unsigned int> expected_result = {5, 4, 3, 2};
        Hardware::probing::RemoveDuplicates(test_vector);
        REQUIRE(test_vector == expected_result);
    }
}