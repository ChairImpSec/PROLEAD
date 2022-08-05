
#include <iostream>
#include <vector>
#include <string>
#include <cinttypes>

#include "Util/pch.h"
#include "Util/CommandLineParameter.hpp"
#include "Hardware/Execute.hpp"

int main(int argc, char *argv[])
{
    std::vector<std::string> CommandLineArguments(argv, argv + argc);
    CommandLineParameterStruct CommandLineParameters;
    uint8_t i = 1, res = 0;
    bool Hardware = true;

    if (argc > 1){
 		if ((CommandLineArguments.at(1) ==  "-h") || (CommandLineArguments.at(1) == "-?") || (CommandLineArguments.at(1) == "/?") || (CommandLineArguments.at(1) == "-help")){
            Hardware::Print::Help(); 
            return 0;
        }
    }

    while (i < argc - 1)
    {
        if ((CommandLineArguments.at(i) == "-lf") || (CommandLineArguments.at(i) == "-libraryfile")){
            CommandLineParameters.LibraryFileName = CommandLineArguments.at(i + 1);
            i += 2;
        }
		else
        if ((CommandLineArguments.at(i) == "-ln") || (CommandLineArguments.at(i) == "-libraryname")){
            CommandLineParameters.LibraryName = CommandLineArguments.at(i + 1);
            i += 2;
        }  
        else
        if ((CommandLineArguments.at(i) == "-df") || (CommandLineArguments.at(i) == "-designfile")){
            CommandLineParameters.DesignFileName = CommandLineArguments.at(i + 1);
            i += 2;
        }
        else
        if ((CommandLineArguments.at(i) == "-mn") || (CommandLineArguments.at(i) == "-modulename")){
            CommandLineParameters.MainModuleName = CommandLineArguments.at(i + 1);
            i += 2;
        }     
		else
        if ((CommandLineArguments.at(i) == "-cf") || (CommandLineArguments.at(i) == "-configfile")){
            CommandLineParameters.SettingsFileName = CommandLineArguments.at(i + 1);
            i += 2;
        } 
		else
        if ((CommandLineArguments.at(i) == "-rf") || (CommandLineArguments.at(i) == "-resultfolder")){
            CommandLineParameters.EvaluationResultFolderName = CommandLineArguments.at(i + 1);
            i += 2;
        }
        else    
        if ((CommandLineArguments.at(i) == "-pf") || (CommandLineArguments.at(i) == "-platform")){
            CommandLineParameters.HardwareOrSoftwareCase = CommandLineArguments.at(i + 1);           
            i += 2;
        }  
        else    
        if ((CommandLineArguments.at(i) == "-ldf") || (CommandLineArguments.at(i) == "-linkerfile")){
            CommandLineParameters.LinkerFileName = CommandLineArguments.at(i + 1);            
            i += 2;
        }  
        else
        {
            Hardware::Print::Help(); 
            return 0;
        }
    }

    if ((CommandLineParameters.HardwareOrSoftwareCase == "hardware") || (CommandLineParameters.HardwareOrSoftwareCase == "Hardware") || (CommandLineParameters.HardwareOrSoftwareCase == "hw") || (CommandLineParameters.HardwareOrSoftwareCase == "Hw") || (CommandLineParameters.HardwareOrSoftwareCase == "HW")){
        Hardware = true;
    }else if((CommandLineParameters.HardwareOrSoftwareCase == "software") || (CommandLineParameters.HardwareOrSoftwareCase == "Software") || (CommandLineParameters.HardwareOrSoftwareCase == "sw") || (CommandLineParameters.HardwareOrSoftwareCase == "Sw") || (CommandLineParameters.HardwareOrSoftwareCase == "SW")){
        Hardware = false;
    }else{
        printf("Error: Platform is not specified correctly!");
        res = 1;
    }
    
    if (!res){
        if (Hardware){
            Hardware::Execute(CommandLineParameters);
        }else{
            throw std::logic_error("Software is not implemented yet!");
        }
    }
}
