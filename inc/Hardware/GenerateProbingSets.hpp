#pragma once

#include <iostream>
#include <cinttypes>
#include <vector>
#include <omp.h>

#include "Hardware/Operators.hpp"

namespace Hardware
{
    namespace GenerateProbingSets
    {
        bool Remove(Hardware::ProbingSetStruct&);
        bool InDistance(Hardware::SettingsStruct&, Hardware::TestStruct&, std::vector<unsigned int>&);
        void Multivariate(Hardware::SettingsStruct&, Hardware::SimulationStruct&, Hardware::TestStruct&);
        void Univariate(Hardware::SimulationStruct&, Hardware::TestStruct&);
        void GenerateProbes(Hardware::SimulationStruct&, Hardware::TestStruct&);
        void Extend(Hardware::SimulationStruct&, Hardware::TestStruct&, unsigned int, unsigned int);
        void RemoveDuplicatedProbes(Hardware::TestStruct&, unsigned int, unsigned int);
        void RemoveDuplicatedProbingSets(Hardware::SettingsStruct&, Hardware::SimulationStruct&, Hardware::TestStruct&, unsigned int, unsigned int);
        void InitializeCompactDistributions(Hardware::SettingsStruct&, Hardware::SimulationStruct&, Hardware::TestStruct&);
        void All(Hardware::SettingsStruct&, Hardware::SimulationStruct&, Hardware::TestStruct&);
    }
}