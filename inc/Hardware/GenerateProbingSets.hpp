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
        void GenerateProbes(Hardware::SimulationStruct&, Hardware::TestStruct&);
        void InitializeMultivariateProbeCombinations(Hardware::SimulationStruct&, Hardware::TestStruct&, std::vector<unsigned int>&, std::vector<bool>&);
        void InitializeUnivariateProbeCombinations(Hardware::SimulationStruct&, std::vector<unsigned int>&, std::vector<bool>&);
        void Extend(Hardware::SimulationStruct&, Hardware::TestStruct&);
        void RemoveDuplicatedProbes(Hardware::TestStruct&);
        void CoverWithOneProbingSet(Hardware::TestStruct&, unsigned int, unsigned int, unsigned int);
        void RemoveCoveredProbingSets(Hardware::TestStruct&, unsigned int, unsigned int);
        void RemoveDuplicatedProbingSets(Hardware::SettingsStruct&, Hardware::SimulationStruct&, Hardware::TestStruct&);
        void RemoveDuplicatedProbingSetsBucket(Hardware::TestStruct&, unsigned int, unsigned int);
        void InitializeCompactDistributions(Hardware::SettingsStruct&, Hardware::SimulationStruct&, Hardware::TestStruct&);
        void All(Hardware::SettingsStruct&, Hardware::SimulationStruct&, Hardware::TestStruct&);
    }
}