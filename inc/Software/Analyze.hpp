#pragma once

#include <cinttypes>
#include <time.h>
#include <omp.h>
#include <iostream>
#include "Software/Definitions.hpp"
#include "Software/Operators.hpp"
#include "Software/Print.hpp"
#include "boost/random/variate_generator.hpp"
#include "boost/random/mersenne_twister.hpp"
#include "boost/random/uniform_int.hpp"
#include "boost/generator_iterator.hpp"
#include "mulator/emulator.h"
#include "Software/Simulate.hpp"
#include "Software/Test.hpp"
#include <iterator>
#include "Software/Probing.hpp"
#include "Util/Util.hpp"


namespace Software
{
    namespace Analyze
    {
        double All(Software::SettingsStruct&,  std::vector<Software::SharedDataStruct>&, Software::HelperStruct&, std::vector<Software::ThreadSimulationStruct>&);
        double ProbingSecurity(Software::SettingsStruct&,  std::vector<Software::SharedDataStruct>&, Software::HelperStruct&, std::vector<Software::ThreadSimulationStruct>&);
    }
}