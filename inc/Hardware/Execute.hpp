#pragma once

#include "Hardware/Adversaries.hpp"
#include <boost/program_options.hpp>

namespace po = boost::program_options;

namespace Hardware {
/**
 * @brief Executes PROLEAD.
 * @param parameter The given command line parameters.
 */
void Execute(const po::variables_map& vm);
}  // namespace Hardware