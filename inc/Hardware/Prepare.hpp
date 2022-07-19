#pragma once

#include <iostream>
#include <cstring>
#include <stdexcept>

#include "Hardware/Definitions.hpp"
#include "Hardware/Read.hpp"
#include "Util/CommandLineParameter.hpp"

namespace Hardware
{
    namespace Prepare
    {
        void MakeCircuitDepth(Hardware::LibraryStruct *, Hardware::CircuitStruct *);
        void ExtendProbe(LibraryStruct *, CircuitStruct *, SettingsStruct *, int, int, int *);
        void Probes(Hardware::LibraryStruct *, Hardware::CircuitStruct *, Hardware::SettingsStruct *, Hardware::ProbesStruct *);
        void Simulation(Hardware::CircuitStruct *, Hardware::SettingsStruct *, Hardware::ProbesStruct *, char *, Hardware::SimulationStruct *);
        void SharedData(Hardware::CircuitStruct *, Hardware::SettingsStruct *, Hardware::SharedDataStruct *);
        void All(CommandLineParameterStruct&, Hardware::CircuitStruct&, Hardware::LibraryStruct&, Hardware::SettingsStruct&, Hardware::ProbesStruct&, Hardware::SimulationStruct&, Hardware::SharedDataStruct*&);
    }
}