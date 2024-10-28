#pragma once

#include <iostream>

#include "Software/Print.hpp"
#include "Software/Analyze.hpp"
#include "Software/Definitions.hpp"
#include "Software/Print.hpp"
#include "Software/Read.hpp"
#include "Software/Prepare.hpp"
#include <boost/program_options.hpp>

namespace po = boost::program_options;

namespace Software
{
  void Execute(const po::variables_map& vm);
}
