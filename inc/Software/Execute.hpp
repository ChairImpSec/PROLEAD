#pragma once

#include <iostream>

#include "Util/CommandLineParameter.hpp"
#include "Software/Print.hpp"
#include "Software/Analyze.hpp"
#include "Software/Definitions.hpp"
#include "Software/Print.hpp"
#include "Software/Read.hpp"
#include "Software/Prepare.hpp"
#include "Util/CommandLineParameter.hpp"

namespace Software
{
    void Execute(CommandLineParameterStruct&);
}