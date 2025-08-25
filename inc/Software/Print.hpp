#pragma once

#include <iostream>
#include "Software/Definitions.hpp"
#include "Software/Probing.hpp"
#include <array>

namespace Software
{
    namespace Print
    {
        void SoftwareMaximumProbingSet(uint32_t , Software::TestStruct& , int& , std::string& );
        void EvaluationTableLine(std::array<std::string, 6>& );
        void ProbeReport(std::vector<Software::ThreadSimulationStruct>& GlobalThreadSimulations, Software::SettingsStruct& Setting, std::vector<Software::TestStruct>& GlobalTests,  int StepSimulationIndex, unsigned int NumberOfProbesToPrint, std::vector<std::tuple<uint32_t, uint32_t, double>>& ProbingSetsWithHighestProbabilities, Software::HelperStruct& GlobalHelper, uint32_t NumberOfProcessedSimulations);
        void ProbingSet(Software::SettingsStruct& Setting, Software::ProbingSetStruct& ProbingSet, double Probability, FILE* fp, Software::HelperStruct& GlobalHelper);
    }
}