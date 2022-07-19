#pragma once

#include <algorithm>

#include "boost/random.hpp"
#include "boost/generator_iterator.hpp"

#include "Hardware/Definitions.hpp"

bool operator==(const Hardware::ProbePositionStruct&, const Hardware::ProbePositionStruct&);
bool operator!=(const Hardware::ProbePositionStruct&, const Hardware::ProbePositionStruct&);
bool operator<(const Hardware::ProbePositionStruct&, const Hardware::ProbePositionStruct&);
bool operator<=(const Hardware::ProbePositionStruct&, const Hardware::ProbePositionStruct&);
bool operator>(const Hardware::ProbePositionStruct&, const Hardware::ProbePositionStruct&);
bool operator>=(const Hardware::ProbePositionStruct&, const Hardware::ProbePositionStruct&);
bool operator==(const std::vector<Hardware::ProbePositionStruct>&, const std::vector<Hardware::ProbePositionStruct>&);
bool operator!=(const std::vector<Hardware::ProbePositionStruct>&, const std::vector<Hardware::ProbePositionStruct>&);
bool operator<(const std::vector<Hardware::ProbePositionStruct>&, const std::vector<Hardware::ProbePositionStruct>&);
bool operator<=(const std::vector<Hardware::ProbePositionStruct>&, const std::vector<Hardware::ProbePositionStruct>&);
bool operator>(const std::vector<Hardware::ProbePositionStruct>&, const std::vector<Hardware::ProbePositionStruct>&);
bool operator>=(const std::vector<Hardware::ProbePositionStruct>&, const std::vector<Hardware::ProbePositionStruct>&);
bool operator==(const Hardware::ProbingSetStruct&, const Hardware::ProbingSetStruct&);
bool operator!=(const Hardware::ProbingSetStruct&, const Hardware::ProbingSetStruct&);
bool operator<(const Hardware::ProbingSetStruct&, const Hardware::ProbingSetStruct&);
bool operator<=(const Hardware::ProbingSetStruct&, const Hardware::ProbingSetStruct&);
bool operator>(const Hardware::ProbingSetStruct&, const Hardware::ProbingSetStruct&);
bool operator>=(const Hardware::ProbingSetStruct&, const Hardware::ProbingSetStruct&);

namespace Hardware
{
    namespace Operators
    {
        void GenerateThreadRng(std::vector<boost::mt19937>&, unsigned int);
    }
}