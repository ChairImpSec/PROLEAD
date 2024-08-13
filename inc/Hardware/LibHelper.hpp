#pragma once

#include <vector>
#include <memory>
#include <functional>
#include <iostream>


namespace Hardware {
  void BitVectorFromNumber(std::vector<uint64_t>& result, size_t number);
  void BoolVectorFromNumber(std::vector<bool>& result, size_t number);
  std::vector<bool> ConcatBoolVectors2(std::vector<bool> first, std::vector<bool>& second);
  std::vector<bool> ConcatBoolVectors3(std::vector<bool> first, std::vector<bool>& second, std::vector<bool>& third);
}
