#pragma once

#include <string>

struct CommandLineParameterStruct
{
	std::string LibraryFileName = "library.lib";
    std::string LibraryName = "NANG45";
    std::string DesignFileName = "design.v";
    std::string SettingsFileName = "config.set";
    std::string MainModuleName = "circuit";
    std::string EvaluationResultFolderName = ".";
    std::string HardwareOrSoftwareCase = "hardware";
    std::string LinkerFileName = "linker.ld";
};