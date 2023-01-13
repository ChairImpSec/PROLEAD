#pragma once

#include "Software/Definitions.hpp"
#include "Software/Read.hpp"
#include "Util/CommandLineParameter.hpp"
#include <cstring>
#include <iostream>
#include <algorithm>

namespace Software
{
    namespace Prepare
    {
        void Simulation(Software::SettingsStruct*, Software::ConfigProbesStruct*, char* , Software::SimulationStruct*);
        void SharedData(Software::SettingsStruct*, Software::SharedDataStruct&);
        void ThreadSimulation(Software::ThreadSimulationStruct& , Software::SettingsStruct* , char*, uint32_t , uint32_t , std::vector<uint32_t>& );
        void Helper(Software::ConfigProbesStruct* , Software::HelperStruct& );
        void All(CommandLineParameterStruct&, Software::ConfigProbesStruct*, Software::SettingsStruct*, std::vector<Software::SharedDataStruct>&, Software::HelperStruct&, std::vector<Software::ThreadSimulationStruct>& );
        bool IsEmptyOrBlank(const std::string &s);
    }
}