#pragma once

#include <iostream>
#include <cstring>
#include <stdexcept>

#include "Hardware/Read.hpp"

namespace Hardware
{
    namespace Prepare
    {
        void MakeCircuitDepth(Library&, CircuitStruct *);
        void Simulation(CircuitStruct& circuit, Settings&, Simulation *);
    }
}
