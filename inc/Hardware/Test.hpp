#pragma once

#include <iostream>
#include <numeric>  
#include <omp.h>

#include <boost/math/distributions/chi_squared.hpp>
#include <boost/math/distributions/inverse_chi_squared.hpp>
#include <boost/math/distributions/non_central_chi_squared.hpp>

#include "Hardware/Definitions.hpp"
#include "Util/Util.hpp"

namespace Hardware
{
    namespace Test
    {
        void CompactTableUpdate(Hardware::SimulationStruct&, unsigned int, Hardware::TestStruct&, std::vector<int>&);
        void CompactTest(Hardware::SimulationStruct&, Hardware::TestStruct&);
        void NormalTableUpdate(Hardware::SimulationStruct&, Hardware::TestStruct&, Hardware::ProbingSetStruct&, std::vector<Util::TableEntryStruct>&);
        void NormalTest(Hardware::SettingsStruct&, Hardware::SimulationStruct&, Hardware::TestStruct&);
        int SearchKey(std::vector<std::vector<unsigned char>>&, std::vector<unsigned char>&, unsigned int);
        void All(Hardware::SettingsStruct&, Hardware::SimulationStruct&, Hardware::TestStruct&, char);
    }
}