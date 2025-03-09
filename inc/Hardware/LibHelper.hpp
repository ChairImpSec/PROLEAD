#pragma once

#include <functional>
#include <iostream>
#include <memory>
#include <vector>

void BitVectorFromNumber(std::vector<uint64_t>& result, uint64_t number);
void BoolVectorFromNumber(std::vector<bool>& result, uint64_t number);
std::vector<bool> ConcatBoolVectors2(std::vector<bool> first,
                                     std::vector<bool>& second);
std::vector<bool> ConcatBoolVectors3(std::vector<bool> first,
                                     std::vector<bool>& second,
                                     std::vector<bool>& third);
