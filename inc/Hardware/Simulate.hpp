#pragma once

#include <cinttypes>

#include "boost/random.hpp"
#include "boost/generator_iterator.hpp"
#include "Hardware/Definitions.hpp"

namespace Hardware
{
    namespace Simulate
    {
        uint64_t EvaluateOperation(Hardware::OperationStruct, uint64_t *, char);
        void All(Hardware::LibraryStruct&, Hardware::CircuitStruct&, Hardware::SettingsStruct&, Hardware::SharedDataStruct*, Hardware::SimulationStruct&, int, boost::mt19937&);
    }
}

