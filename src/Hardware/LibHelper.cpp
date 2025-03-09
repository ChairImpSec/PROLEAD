#include "Hardware/LibHelper.hpp"

void BitVectorFromNumber(std::vector<uint64_t>& result, uint64_t number) {
  for (uint64_t i = 0; i < result.size(); ++i) {
      result.at(i) = (number & (1 << i)) != 0;
  }
}

void BoolVectorFromNumber(std::vector<bool>& result, uint64_t number) {
  for (uint64_t i = 0; i < result.size(); ++i) {
      result.at(i) = (number & (1 << i)) != 0;
  }
}

std::vector<bool> ConcatBoolVectors2(std::vector<bool> first, std::vector<bool>& second) {
  for (bool bit : second) {
    first.push_back(bit);
  }
  return first;
}

std::vector<bool> ConcatBoolVectors3(std::vector<bool> first, std::vector<bool>& second, std::vector<bool>& third) {
  for (bool bit : second) {
    first.push_back(bit);
  }
  for (bool bit : third) {
    first.push_back(bit);
  }
  return first;
}
