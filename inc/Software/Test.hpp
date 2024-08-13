#pragma once
#include "Software/Definitions.hpp"
#include <cmath>
#include <numeric>
#include "Software/Operators.hpp"
#include "Software/Probing.hpp"
#include "Util/Util.hpp"

namespace Software
{
    namespace Test
    {
        void Test(Software::ThreadSimulationStruct&, Software::TestStruct&);
        void NormalTableUpdate(Software::ThreadSimulationStruct&, unsigned int , Software::ProbingSetStruct& , Software::ProbingSetStruct& , std::vector<std::vector<std::vector<uint8_t>>>& , Software::HelperStruct&);
        void FirstOrderTableUpdate(Software::ThreadSimulationStruct&, unsigned int , Software::ProbingSetStruct& , Software::ProbingSetStruct& , std::vector<std::vector<std::vector<uint8_t>>>& , Software::HelperStruct&);
        void CompactFirstOrderTableUpdate(Software::ThreadSimulationStruct&, unsigned int , Software::ProbingSetStruct& , Software::ProbingSetStruct& , std::vector<std::vector<std::vector<uint8_t>>>& , Software::HelperStruct&);
        void HigherOrderUnivariateTableUpdate(Software::ThreadSimulationStruct& , unsigned int , Software::ProbingSetStruct& , Software::ProbingSetStruct& , std::vector<std::vector<std::vector<uint8_t>>>& , Software::HelperStruct& , std::vector<std::vector<bool>>&, std::vector<std::vector<uint32_t>>&);
        void CompactHigherOrderUnivariateTableUpdate(Software::ThreadSimulationStruct& , unsigned int , Software::ProbingSetStruct& , Software::ProbingSetStruct& , std::vector<std::vector<std::vector<uint8_t>>>& , Software::HelperStruct& , std::vector<std::vector<bool>>&, std::vector<std::vector<uint32_t>>&);
        void HigherOrderMultivariateTableUpdate(Software::ThreadSimulationStruct& ThreadSimulation, uint32_t SimulationIndex, Software::ProbingSetStruct& GlobalSet, Software::ProbingSetStruct& ProbingSet, std::vector<std::vector<std::vector<uint8_t>>>& ProbeValues, Software::HelperStruct& Helper, std::vector<std::vector<uint32_t>>& ProbeInfoToStandardProbe);
        void CompactHigherOrderMultivariateTableUpdate(Software::ThreadSimulationStruct& ThreadSimulation, uint32_t SimulationIndex, Software::ProbingSetStruct& GlobalSet, Software::ProbingSetStruct& ProbingSet, std::vector<std::vector<std::vector<uint8_t>>>& ProbeValues, Software::HelperStruct& Helper, std::vector<std::vector<uint32_t>>& ProbeInfoToStandardProbe);
    }
}