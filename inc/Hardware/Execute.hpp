#pragma once

#include "Util/ProgramOptions.hpp"
#include "Hardware/Adversaries.hpp"
#include "Hardware/SampledRFAdversary.hpp"
#include "Hardware/gds/GDSScanner.hpp"

namespace po = boost::program_options;

namespace Hardware {
/**
 * @brief Executes PROLEAD.
 * @param parameter The given command line parameters.
 */
void Execute(const po::variables_map& vm);
}  // namespace Hardware
