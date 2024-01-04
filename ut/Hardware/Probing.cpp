#define CATCH_CONFIG_ENABLE_BENCHMARKING
#include "Hardware/Probing.hpp"

#include <catch2/catch.hpp>

TEST_CASE("Test the removing of duplicates from a vector",
          "[void RemoveDuplicates(std::vector<ExtensionContainer>&)]") {
  SECTION("Empty vector") {
    std::vector<unsigned int> test_vector = {};
    std::vector<unsigned int> expected_result = {};
    Hardware::probing::RemoveDuplicates(test_vector);
    REQUIRE(test_vector == expected_result);
  }

  SECTION("Vector with no duplicates") {
    std::vector<unsigned int> test_vector = {1, 2, 3, 4, 5};
    std::vector<unsigned int> expected_result = {5, 4, 3, 2, 1};
    Hardware::probing::RemoveDuplicates(test_vector);
    REQUIRE(test_vector == expected_result);
  }

  SECTION("Vector with all duplicates") {
    std::vector<unsigned int> test_vector = {2, 2, 2, 2, 2};
    std::vector<unsigned int> expected_result = {2};
    Hardware::probing::RemoveDuplicates(test_vector);
    REQUIRE(test_vector == expected_result);
  }

  SECTION("Vector with some duplicates") {
    std::vector<unsigned int> test_vector = {4, 2, 8, 4, 6, 2, 1};
    std::vector<unsigned int> expected_result = {8, 6, 4, 2, 1};
    Hardware::probing::RemoveDuplicates(test_vector);
    REQUIRE(test_vector == expected_result);
  }

  SECTION("Vector with duplicates at the beginning or end") {
    std::vector<unsigned int> test_vector = {2, 2, 3, 4, 5, 5};
    std::vector<unsigned int> expected_result = {5, 4, 3, 2};
    Hardware::probing::RemoveDuplicates(test_vector);
    REQUIRE(test_vector == expected_result);
  }
}

TEST_CASE(
    "Test the returning of the number of probe extensions in a probing set",
    "[size_t ProbingSet<ExtensionContainer>::GetNumberOfProbeExtensions() "
    "const]") {
  SECTION("Empty probing set") {
    std::vector<unsigned int> test_vector = {};
    Hardware::probing::ProbingSet<unsigned int> probing_set(test_vector,
                                                            test_vector);
    REQUIRE(probing_set.GetNumberOfProbeExtensions() == 0);
  }

  SECTION("Probing set with one probe extension") {
    std::vector<unsigned int> test_vector = {5};
    Hardware::probing::ProbingSet<unsigned int> probing_set(test_vector,
                                                            test_vector);
    REQUIRE(probing_set.GetNumberOfProbeExtensions() == 1);
  }

  SECTION("Probing set with multiple extensions") {
    std::vector<unsigned int> test_vector = {5, 6, 7};
    Hardware::probing::ProbingSet<unsigned int> probing_set(test_vector,
                                                            test_vector);
    REQUIRE(probing_set.GetNumberOfProbeExtensions() == 3);
  }
}

TEST_CASE(
    "Test the returning of particular standard probe indices",
    "[size_t ProbingSet<ExtensionContainer>::GetStandardProbeIndex(size_t)]") {
  SECTION("Empty probing set") {
    std::vector<unsigned int> test_vector = {};
    Hardware::probing::ProbingSet<unsigned int> probing_set(test_vector,
                                                            test_vector);
    REQUIRE_THROWS_WITH(
        probing_set.GetStandardProbeIndex(0),
        "Tried to access a standard probe index from an empty vector!");
  }

  SECTION("Probing set with one probe extension and index in range") {
    std::vector<unsigned int> test_vector = {5};
    Hardware::probing::ProbingSet<unsigned int> probing_set(test_vector,
                                                            test_vector);
    REQUIRE(probing_set.GetStandardProbeIndex(0) == 5);
  }

  SECTION("Probing set with one probe extension and index out of range") {
    std::vector<unsigned int> test_vector = {5};
    Hardware::probing::ProbingSet<unsigned int> probing_set(test_vector,
                                                            test_vector);
    REQUIRE_THROWS_WITH(probing_set.GetStandardProbeIndex(1),
                        "Tried to access an invalid standard probe index!");
  }

  SECTION("Probing set with multiple extensions and indices in range") {
    std::vector<unsigned int> test_vector = {5, 6, 7};
    Hardware::probing::ProbingSet<unsigned int> probing_set(test_vector,
                                                            test_vector);
    REQUIRE(probing_set.GetExtendedProbeIndex(0) == 5);
    REQUIRE(probing_set.GetExtendedProbeIndex(1) == 6);
    REQUIRE(probing_set.GetExtendedProbeIndex(2) == 7);
  }

  SECTION("Probing set with multiple extensions and index out of range") {
    std::vector<unsigned int> test_vector = {5, 6, 7};
    Hardware::probing::ProbingSet<unsigned int> probing_set(test_vector,
                                                            test_vector);
    REQUIRE_THROWS_WITH(probing_set.GetStandardProbeIndex(3),
                        "Tried to access an invalid standard probe index!");
  }
}

TEST_CASE(
    "Test the returning of particular probe-extension indices",
    "[size_t ProbingSet<ExtensionContainer>::GetExtendedProbeIndex(size_t)]") {
  SECTION("Empty probing set") {
    std::vector<unsigned int> test_vector = {};
    Hardware::probing::ProbingSet<unsigned int> probing_set(test_vector,
                                                            test_vector);
    REQUIRE_THROWS_WITH(
        probing_set.GetExtendedProbeIndex(0),
        "Tried to access a probe-extension index from an empty vector!");
  }

  SECTION("Probing set with one probe extension and index in range") {
    std::vector<unsigned int> test_vector = {5};
    Hardware::probing::ProbingSet<unsigned int> probing_set(test_vector,
                                                            test_vector);
    REQUIRE(probing_set.GetExtendedProbeIndex(0) == 5);
  }

  SECTION("Probing set with one probe extension and index out of range") {
    std::vector<unsigned int> test_vector = {5};
    Hardware::probing::ProbingSet<unsigned int> probing_set(test_vector,
                                                            test_vector);
    REQUIRE_THROWS_WITH(probing_set.GetExtendedProbeIndex(1),
                        "Tried to access an invalid probe-extension index!");
  }

  SECTION("Probing set with multiple extensions and indices in range") {
    std::vector<unsigned int> test_vector = {5, 6, 7};
    Hardware::probing::ProbingSet<unsigned int> probing_set(test_vector,
                                                            test_vector);
    REQUIRE(probing_set.GetExtendedProbeIndex(0) == 5);
    REQUIRE(probing_set.GetExtendedProbeIndex(1) == 6);
    REQUIRE(probing_set.GetExtendedProbeIndex(2) == 7);
  }

  SECTION("Probing set with multiple extensions and index out of range") {
    std::vector<unsigned int> test_vector = {5, 6, 7};
    Hardware::probing::ProbingSet<unsigned int> probing_set(test_vector,
                                                            test_vector);
    REQUIRE_THROWS_WITH(probing_set.GetExtendedProbeIndex(3),
                        "Tried to access an invalid probe-extension index!");
  }
}

TEST_CASE("Test the returning of the first probe extension from a probing set",
          "[ExtensionContainer "
          "ProbingSet<ExtensionContainer>::GetFirstProbeExtension() const]") {
  SECTION("Empty probing set") {
    std::vector<unsigned int> test_vector = {};
    Hardware::probing::ProbingSet<unsigned int> probing_set(test_vector,
                                                            test_vector);
    REQUIRE_THROWS_WITH(
        probing_set.GetFirstProbeExtension(),
        "Tried to return the first element of an empty vector!");
  }

  SECTION("Probing set with one probe extension") {
    std::vector<unsigned int> test_vector = {5};
    unsigned int expected_result = 5;
    Hardware::probing::ProbingSet<unsigned int> probing_set(test_vector,
                                                            test_vector);
    REQUIRE(probing_set.GetFirstProbeExtension() == expected_result);
  }

  SECTION("Probing set with multiple extensions") {
    std::vector<unsigned int> test_vector = {5, 6, 7};
    unsigned int expected_result = 5;
    Hardware::probing::ProbingSet<unsigned int> probing_set(test_vector,
                                                            test_vector);
    REQUIRE(probing_set.GetFirstProbeExtension() == expected_result);
  }
}

TEST_CASE("Test the returning of the last probe extension from a probing set",
          "[ExtensionContainer "
          "ProbingSet<ExtensionContainer>::GetLastProbeExtension() const]") {
  SECTION("Empty probing set") {
    std::vector<unsigned int> test_vector = {};
    Hardware::probing::ProbingSet<unsigned int> probing_set(test_vector,
                                                            test_vector);
    REQUIRE_THROWS_WITH(probing_set.GetLastProbeExtension(),
                        "Tried to return the last element of an empty vector!");
  }

  SECTION("Probing set with one probe extension") {
    std::vector<unsigned int> test_vector = {5};
    unsigned int expected_result = 5;
    Hardware::probing::ProbingSet<unsigned int> probing_set(test_vector,
                                                            test_vector);
    REQUIRE(probing_set.GetLastProbeExtension() == expected_result);
  }

  SECTION("Probing set with multiple extensions") {
    std::vector<unsigned int> test_vector = {5, 6, 7};
    unsigned int expected_result = 7;
    Hardware::probing::ProbingSet<unsigned int> probing_set(test_vector,
                                                            test_vector);
    REQUIRE(probing_set.GetLastProbeExtension() == expected_result);
  }
}

TEST_CASE(
    "Test the returning of all probe extension indices from a probing set",
    "[std::vector<ExtensionContainer> "
    "ProbingSet<ExtensionContainer>::GetAllProbeExtensions() const]") {
  SECTION("Empty probing set") {
    std::vector<unsigned int> test_vector = {};
    Hardware::probing::ProbingSet<unsigned int> probing_set(test_vector,
                                                            test_vector);
    REQUIRE(probing_set.GetAllProbeExtensions() == test_vector);
  }

  SECTION("Probing set with multiple extensions") {
    std::vector<unsigned int> test_vector = {5, 6, 7};
    Hardware::probing::ProbingSet<unsigned int> probing_set(test_vector,
                                                            test_vector);
    REQUIRE(probing_set.GetAllProbeExtensions() == test_vector);
  }
}

TEST_CASE("Test the greater operator for probing sets",
          "bool ProbingSet<ExtensionContainer>::operator<(const "
          "ProbingSet<ExtensionContainer>&) const") {
  SECTION("Two empty probing sets") {
    std::vector<unsigned int> test_vector = {};
    Hardware::probing::ProbingSet<unsigned int> probing_set1(test_vector,
                                                             test_vector);
    Hardware::probing::ProbingSet<unsigned int> probing_set2(test_vector,
                                                             test_vector);
    REQUIRE_FALSE(probing_set1 < probing_set1);
    REQUIRE_FALSE(probing_set2 < probing_set2);
    REQUIRE_FALSE(probing_set1 < probing_set2);
    REQUIRE_FALSE(probing_set2 < probing_set1);
  }

  SECTION("Two equal probing sets") {
    std::vector<unsigned int> test_vector = {5, 6, 7};
    Hardware::probing::ProbingSet<unsigned int> probing_set1(test_vector,
                                                             test_vector);
    Hardware::probing::ProbingSet<unsigned int> probing_set2(test_vector,
                                                             test_vector);
    REQUIRE_FALSE(probing_set1 < probing_set1);
    REQUIRE_FALSE(probing_set2 < probing_set2);
    REQUIRE_FALSE(probing_set1 < probing_set2);
    REQUIRE_FALSE(probing_set2 < probing_set1);
  }

  SECTION("Two probing sets with one different probe-extension index") {
    std::vector<unsigned int> test_vector1 = {5};
    std::vector<unsigned int> test_vector2 = {6};
    Hardware::probing::ProbingSet<unsigned int> probing_set1(test_vector1,
                                                             test_vector1);
    Hardware::probing::ProbingSet<unsigned int> probing_set2(test_vector2,
                                                             test_vector2);
    REQUIRE(probing_set1 < probing_set2);
    REQUIRE_FALSE(probing_set2 < probing_set1);
  }

  SECTION("Two probing sets with different probe-extension indices") {
    std::vector<unsigned int> test_vector1 = {5, 6, 7};
    std::vector<unsigned int> test_vector2 = {5, 6, 8};
    Hardware::probing::ProbingSet<unsigned int> probing_set1(test_vector1,
                                                             test_vector1);
    Hardware::probing::ProbingSet<unsigned int> probing_set2(test_vector2,
                                                             test_vector2);
    REQUIRE(probing_set1 < probing_set2);
    REQUIRE_FALSE(probing_set2 < probing_set1);
  }
}

TEST_CASE("Test the equal operator for probing sets",
          "bool ProbingSet<ExtensionContainer>::operator==(const "
          "ProbingSet<ExtensionContainer>&) const") {
  SECTION("Two empty probing sets") {
    std::vector<unsigned int> test_vector = {};
    Hardware::probing::ProbingSet<unsigned int> probing_set1(test_vector,
                                                             test_vector);
    Hardware::probing::ProbingSet<unsigned int> probing_set2(test_vector,
                                                             test_vector);
    REQUIRE(probing_set1 == probing_set1);
    REQUIRE(probing_set2 == probing_set2);
    REQUIRE(probing_set1 == probing_set2);
    REQUIRE(probing_set2 == probing_set1);
  }

  SECTION("Two equal probing sets") {
    std::vector<unsigned int> test_vector = {5, 6, 7};
    Hardware::probing::ProbingSet<unsigned int> probing_set1(test_vector,
                                                             test_vector);
    Hardware::probing::ProbingSet<unsigned int> probing_set2(test_vector,
                                                             test_vector);
    REQUIRE(probing_set1 == probing_set1);
    REQUIRE(probing_set2 == probing_set2);
    REQUIRE(probing_set1 == probing_set2);
    REQUIRE(probing_set2 == probing_set1);
  }

  SECTION("Two probing sets with one different probe-extension index") {
    std::vector<unsigned int> test_vector1 = {5};
    std::vector<unsigned int> test_vector2 = {6};
    Hardware::probing::ProbingSet<unsigned int> probing_set1(test_vector1,
                                                             test_vector1);
    Hardware::probing::ProbingSet<unsigned int> probing_set2(test_vector2,
                                                             test_vector2);
    REQUIRE(probing_set1 == probing_set1);
    REQUIRE(probing_set2 == probing_set2);
    REQUIRE_FALSE(probing_set1 == probing_set2);
    REQUIRE_FALSE(probing_set2 == probing_set1);
  }

  SECTION("Two probing sets with different probe-extension indices") {
    std::vector<unsigned int> test_vector1 = {5, 6, 7};
    std::vector<unsigned int> test_vector2 = {5, 6, 8};
    Hardware::probing::ProbingSet<unsigned int> probing_set1(test_vector1,
                                                             test_vector1);
    Hardware::probing::ProbingSet<unsigned int> probing_set2(test_vector2,
                                                             test_vector2);
    REQUIRE(probing_set1 == probing_set1);
    REQUIRE(probing_set2 == probing_set2);
    REQUIRE_FALSE(probing_set1 == probing_set2);
    REQUIRE_FALSE(probing_set2 == probing_set1);
  }
}

TEST_CASE("Test the not-equal operator for probing sets",
          "bool ProbingSet<ExtensionContainer>::operator!=(const "
          "ProbingSet<ExtensionContainer>&) const") {
  SECTION("Two empty probing sets") {
    std::vector<unsigned int> test_vector = {};
    Hardware::probing::ProbingSet<unsigned int> probing_set1(test_vector,
                                                             test_vector);
    Hardware::probing::ProbingSet<unsigned int> probing_set2(test_vector,
                                                             test_vector);
    REQUIRE_FALSE(probing_set1 != probing_set1);
    REQUIRE_FALSE(probing_set2 != probing_set2);
    REQUIRE_FALSE(probing_set1 != probing_set2);
    REQUIRE_FALSE(probing_set2 != probing_set1);
  }

  SECTION("Two equal probing sets") {
    std::vector<unsigned int> test_vector = {5, 6, 7};
    Hardware::probing::ProbingSet<unsigned int> probing_set1(test_vector,
                                                             test_vector);
    Hardware::probing::ProbingSet<unsigned int> probing_set2(test_vector,
                                                             test_vector);
    REQUIRE_FALSE(probing_set1 != probing_set1);
    REQUIRE_FALSE(probing_set2 != probing_set2);
    REQUIRE_FALSE(probing_set1 != probing_set2);
    REQUIRE_FALSE(probing_set2 != probing_set1);
  }

  SECTION("Two probing sets with one different probe-extension index") {
    std::vector<unsigned int> test_vector1 = {5};
    std::vector<unsigned int> test_vector2 = {6};
    Hardware::probing::ProbingSet<unsigned int> probing_set1(test_vector1,
                                                             test_vector1);
    Hardware::probing::ProbingSet<unsigned int> probing_set2(test_vector2,
                                                             test_vector2);
    REQUIRE_FALSE(probing_set1 != probing_set1);
    REQUIRE_FALSE(probing_set2 != probing_set2);
    REQUIRE(probing_set1 != probing_set2);
    REQUIRE(probing_set2 != probing_set1);
  }

  SECTION("Two probing sets with different probe-extension indices") {
    std::vector<unsigned int> test_vector1 = {5, 6, 7};
    std::vector<unsigned int> test_vector2 = {5, 6, 8};
    Hardware::probing::ProbingSet<unsigned int> probing_set1(test_vector1,
                                                             test_vector1);
    Hardware::probing::ProbingSet<unsigned int> probing_set2(test_vector2,
                                                             test_vector2);
    REQUIRE_FALSE(probing_set1 != probing_set1);
    REQUIRE_FALSE(probing_set2 != probing_set2);
    REQUIRE(probing_set1 != probing_set2);
    REQUIRE(probing_set2 != probing_set1);
  }
}

TEST_CASE("Test if a probing set fully includes another probing set",
          "bool ProbingSet<ExtensionContainer>::Includes(const "
          "ProbingSet<ExtensionContainer>&) const") {
  SECTION("One probing set includes another probing set at the end") {
    std::vector<unsigned int> empty_vector = {};
    std::vector<unsigned int> test_vector1 = {7,6,5};
    std::vector<unsigned int> test_vector2 = {9,8,7,6,5};
    Hardware::probing::ProbingSet<unsigned int> probing_set1(empty_vector,
                                                             test_vector1);
    Hardware::probing::ProbingSet<unsigned int> probing_set2(empty_vector,
                                                             test_vector2);
    REQUIRE(probing_set2.Includes(probing_set1));
    REQUIRE_FALSE(probing_set1.Includes(probing_set2));
  }

  SECTION("One probing set includes another probing set in the middle") {
    std::vector<unsigned int> empty_vector = {};
    std::vector<unsigned int> test_vector1 = {8,7,6};
    std::vector<unsigned int> test_vector2 = {9,8,7,6,5};
    Hardware::probing::ProbingSet<unsigned int> probing_set1(empty_vector,
                                                             test_vector1);
    Hardware::probing::ProbingSet<unsigned int> probing_set2(empty_vector,
                                                             test_vector2);
    REQUIRE(probing_set2.Includes(probing_set1));
    REQUIRE_FALSE(probing_set1.Includes(probing_set2));
  }

  SECTION("One probing set includes another probing set at the end") {
    std::vector<unsigned int> empty_vector = {};
    std::vector<unsigned int> test_vector1 = {9,8,7};
    std::vector<unsigned int> test_vector2 = {9,8,7,6,5};
    Hardware::probing::ProbingSet<unsigned int> probing_set1(empty_vector,
                                                             test_vector1);
    Hardware::probing::ProbingSet<unsigned int> probing_set2(empty_vector,
                                                             test_vector2);
    REQUIRE(probing_set2.Includes(probing_set1));
    REQUIRE_FALSE(probing_set1.Includes(probing_set2));
  }

  SECTION("One probing set includes another probing set but not continuously") {
    std::vector<unsigned int> empty_vector = {};
    std::vector<unsigned int> test_vector1 = {9,7,5};
    std::vector<unsigned int> test_vector2 = {9,8,7,6,5};
    Hardware::probing::ProbingSet<unsigned int> probing_set1(empty_vector,
                                                             test_vector1);
    Hardware::probing::ProbingSet<unsigned int> probing_set2(empty_vector,
                                                             test_vector2);
    REQUIRE(probing_set2.Includes(probing_set1));
    REQUIRE_FALSE(probing_set1.Includes(probing_set2));
  }

  SECTION("Non-including probing sets with a single element") {
    std::vector<unsigned int> empty_vector = {};
    std::vector<unsigned int> test_vector1 = {5};
    std::vector<unsigned int> test_vector2 = {6};
    Hardware::probing::ProbingSet<unsigned int> probing_set1(empty_vector,
                                                             test_vector1);
    Hardware::probing::ProbingSet<unsigned int> probing_set2(empty_vector,
                                                             test_vector2);
    REQUIRE_FALSE(probing_set1.Includes(probing_set2));
    REQUIRE_FALSE(probing_set2.Includes(probing_set1));
  }

  SECTION("Non-including probing sets with a multiple elements") {
    std::vector<unsigned int> empty_vector = {};
    std::vector<unsigned int> test_vector1 = {7,6,5,3};
    std::vector<unsigned int> test_vector2 = {7,6,4,3};
    Hardware::probing::ProbingSet<unsigned int> probing_set1(empty_vector,
                                                             test_vector1);
    Hardware::probing::ProbingSet<unsigned int> probing_set2(empty_vector,
                                                             test_vector2);
    REQUIRE_FALSE(probing_set1.Includes(probing_set2));
    REQUIRE_FALSE(probing_set2.Includes(probing_set1));
  }
}