#include "Software/Execute.hpp"

void Software::Execute(const po::variables_map& vm){

    Software::ConfigProbesStruct probes;
    Software::SettingsStruct settings;
    Software::HelperStruct GlobalHelper;
    std::vector<Software::SharedDataStruct> SharedData;
    std::vector<Software::ThreadSimulationStruct> GlobalThreadSimulations;

    boost::json::object config_file = vm["configfile"].as<boost::json::object>();
    Settings settings2(config_file, false);

    std::cout << "Start Software Leakage Evaluation" << std::endl << std::endl;
    Software::Prepare::All(vm, probes, settings, settings2, SharedData, GlobalHelper, GlobalThreadSimulations);
    Software::Analyze::All(settings, SharedData, GlobalHelper, GlobalThreadSimulations);
    std::cout << "done!" << std::endl;
}
