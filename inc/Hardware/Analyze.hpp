#pragma once

#include <iostream>
#include <cinttypes>
#include <cmath>
#include <omp.h>

#include "Hardware/Definitions.hpp"
#include "Hardware/Print.hpp"
#include "Hardware/Read.hpp"
#include "Hardware/Prepare.hpp"
#include "Hardware/GenerateProbingSets.hpp"
#include "Hardware/Simulate.hpp"
#include "Hardware/Test.hpp"
#include "Util/CommandLineParameter.hpp"
#include "Util/Util.hpp"

namespace Hardware
{
    namespace Analyze
    {
        void All(Hardware::LibraryStruct&, Hardware::CircuitStruct&, Hardware::SettingsStruct&, Hardware::SharedDataStruct*, Hardware::SimulationStruct&, Hardware::TestStruct&);
        void RobustProbingSecurity(Hardware::LibraryStruct&, Hardware::CircuitStruct&, Hardware::SettingsStruct&, Hardware::SharedDataStruct*, Hardware::SimulationStruct&, Hardware::TestStruct&);
        void UnivariateRobustProbingSecurity(Hardware::LibraryStruct&, Hardware::CircuitStruct&, Hardware::SettingsStruct&, Hardware::SharedDataStruct*, Hardware::SimulationStruct&, Hardware::TestStruct&, timespec&);
        void MultivariateRobustProbingSecurity(Hardware::LibraryStruct&, Hardware::CircuitStruct&, Hardware::SettingsStruct&, Hardware::SharedDataStruct*, Hardware::SimulationStruct&, Hardware::TestStruct&, timespec&);
        void RobustProbingSecurityForSomeProbingSets(Hardware::LibraryStruct&, Hardware::CircuitStruct&, Hardware::SettingsStruct&, Hardware::SharedDataStruct*, Hardware::SimulationStruct&, Hardware::TestStruct&, timespec&, unsigned int&);
    }
}