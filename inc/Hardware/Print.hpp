#pragma once

#include <algorithm>
#include <array>
#include <climits>
#include <cstring>
#include <fstream> 
#include <iostream>
#include <string>

#include "Util/CommandLineParameter.hpp"
#include "Hardware/Definitions.hpp"

namespace Hardware
{
    namespace Print
    {
        void Help();
        unsigned int MemoryConsumption();
        void CommandLineSettings(CommandLineParameterStruct&);
        void ProbeGenerationSettings(Hardware::SettingsStruct&, Hardware::SimulationStruct&, Hardware::TestStruct&);
        unsigned int EvaluationSettings(Hardware::SimulationStruct&, Hardware::TestStruct&);
        void EvaluationResults(Hardware::SettingsStruct&, Hardware::SimulationStruct&, Hardware::TestStruct&, double&, std::string&, double, unsigned int);
        void Report(Hardware::SettingsStruct&, Hardware::SimulationStruct&, Hardware::TestStruct&, unsigned int, unsigned int);
    }
}