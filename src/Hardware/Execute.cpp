#include "Hardware/Execute.hpp"

void Hardware::Execute(CommandLineParameterStruct& Parameter){
	Hardware::CircuitStruct Circuit;
    Hardware::LibraryStruct Library;
	Hardware::SettingsStruct Settings;
    Hardware::ProbesStruct Probes;
	Hardware::SimulationStruct Simulation;
	Hardware::SharedDataStruct* SharedData = NULL;

    std::cout << "Start Hardware Leakage Evaluation" << std::endl << std::endl;
    Hardware::Print::CommandLineSettings(Parameter);
    Hardware::Prepare::All(Parameter, Circuit, Library, Settings, Probes, Simulation, SharedData);
    Hardware::TestStruct Test(Simulation);
    Hardware::Analyze::All(Library, Circuit, Settings, SharedData, Simulation, Test);
    std::cout << "done!" << std::endl;
}
