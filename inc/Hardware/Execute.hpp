#pragma once

#include <iostream>
#include <cinttypes>

#include "Hardware/Analyze.hpp"
#include "Hardware/Definitions.hpp"
#include "Hardware/Print.hpp"
#include "Hardware/Read.hpp"
#include "Hardware/Prepare.hpp"
#include "Util/CommandLineParameter.hpp"

namespace Hardware
{
	/**
	* @brief Executes PROLEAD. 
	* @param CommandLineParameters The given command line parameters.
	* @author Nicolai Müller
	*/
    void Execute(CommandLineParameterStruct&);
}