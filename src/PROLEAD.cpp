#include "Hardware/Execute.hpp"
#include "Software/Execute.hpp"
#include "Util/ProgramOptions.hpp"
#include "Util/Logger.hpp"

namespace po = boost::program_options;


int main(int argc, char* argv[]) {
  ProgramOptions program_options;
  po::variables_map vm = program_options.Parse(argc, argv);
  Logger::InitLogging();

  /**
   * @brief The platform notifier already guarantees that the platform argument
   * is valid. Hence, we don't need to check for invalid arguments here.
   * @see Util::ValidatePlatform()
   */
  std::string platform_option = vm["platform"].as<std::string>();
  if (platform_option == "hardware" || platform_option == "Hardware" ||
      platform_option == "hw" || platform_option == "Hw") {
    Hardware::Execute(vm);
  } else {
    Software::Execute(vm);
  }
}
