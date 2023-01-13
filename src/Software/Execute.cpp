#include "Software/Execute.hpp"

void Software::Execute(CommandLineParameterStruct& CommandLineParameters){

    Software::ConfigProbesStruct Probes;
    Software::SettingsStruct Settings;
    Software::HelperStruct GlobalHelper;
    std::vector<Software::SharedDataStruct> SharedData;
    std::vector<Software::ThreadSimulationStruct> GlobalThreadSimulations;

    std::cout << "Start Software Leakage Evaluation" << std::endl << std::endl;
    Software::Print::CommandLineSettings(CommandLineParameters);
    Software::Prepare::All(CommandLineParameters, &Probes, &Settings, SharedData, GlobalHelper, GlobalThreadSimulations);
    Software::Analyze::All(Settings, SharedData, GlobalHelper, GlobalThreadSimulations);
    std::cout << "done!" << std::endl;
}
