#pragma once

#include "Hardware/Definitions.hpp"
#include "Hardware/Prepare.hpp"
#include "Hardware/Probing.hpp"
#include "Hardware/Read.hpp"
#include "Util/CommandLineParameter.hpp"

namespace Hardware {
/**
 * @brief Executes PROLEAD.
 * @param parameter The given command line parameters.
 * @author Nicolai Müller
 */
void Execute(const CommandLineParameterStruct& parameter);
}  // namespace Hardware