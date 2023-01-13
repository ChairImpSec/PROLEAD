#pragma once
#include "boost/random/mersenne_twister.hpp"
#include "Software/Definitions.hpp"
#include "Util/Util.hpp"
#include <array>
#include <algorithm>

bool operator==(const std::vector<Software::ProbesStruct>& firstOperand, const std::vector<Software::ProbesStruct>& secondOperand);
bool operator<(const std::vector<Software::ProbesStruct>& firstOperand, const std::vector<Software::ProbesStruct>& secondOperand);

bool operator==(const std::vector<Software::ProbingSetStruct>& firstOperand, const std::vector<Software::ProbingSetStruct>& secondOperand);
bool operator<(const std::vector<Software::ProbingSetStruct>& firstOperand, const std::vector<Software::ProbingSetStruct>& secondOperand);
bool TableEntryCompare(const Util::TableEntryStruct& firstOperand, const Util::TableEntryStruct& secondOperand);

bool operator==(const Software::ProbesStruct& firstOperand, const Software::ProbesStruct& secondOperand);
bool operator<(const Software::ProbesStruct& firstOperand, const Software::ProbesStruct& secondOperand);
bool operator>(const Software::ProbesStruct& firstOperand, const Software::ProbesStruct& secondOperand);
bool operator==(const Software::ProbingSetStruct& firstOperand, const Software::ProbingSetStruct& secondOperand);
bool operator<(const Software::ProbingSetStruct& firstOperand, const Software::ProbingSetStruct& secondOperand);

bool ProbingSetCompare(const Software::ProbingSetStruct& firstOperand, const Software::ProbingSetStruct& secondOperand);
bool ProbeInfoEquality(const ::Software::ProbingSetStruct& firstOperand, const ::Software::ProbingSetStruct& secondOperand);
bool ProbabilityCompare(const Software::ProbingSetStruct& firstOperand, const Software::ProbingSetStruct& secondOperand);
bool SoftwareProbabilityCompare(const Software::ProbingSetStruct& firstOperand, const Software::ProbingSetStruct& secondOperand);

void SwapEndian(uint32_t &val);


namespace Software{
    namespace Operators{
        void GenerateThreadRng(std::vector<boost::mt19937>&, unsigned int);
        unsigned int BinomialCoefficient(int n, int k);
        void ComputeBinomCoeffOrderOverTwo(std::vector<std::tuple<uint32_t, uint32_t>>& , uint32_t);
    }
}