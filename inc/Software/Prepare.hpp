#pragma once

#include "Software/Definitions.hpp"
#include "Software/Read.hpp"
#include <cstring>
#include <iostream>
#include <algorithm>
#include <boost/program_options.hpp>

namespace po = boost::program_options;

namespace Software
{
    namespace Prepare
    {
        void SharedData(Software::SettingsStruct&, Software::SharedDataStruct&);
        void ThreadSimulation(Software::ThreadSimulationStruct& , Software::SettingsStruct& , const std::string&, uint32_t , uint32_t , std::vector<uint32_t>& );
        void Helper(Software::ConfigProbesStruct& , Software::HelperStruct& );
        void All(const po::variables_map&, Software::ConfigProbesStruct&, Software::SettingsStruct&, Settings&, std::vector<Software::SharedDataStruct>&, Software::HelperStruct&, std::vector<Software::ThreadSimulationStruct>& );
        bool IsEmptyOrBlank(const std::string &s);
    }
}