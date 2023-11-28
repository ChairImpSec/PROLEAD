#pragma once

#include <algorithm>
#include <array>
#include <climits>
#include <cstring>
#include <fstream> 
#include <iostream>
#include <string>

#include "Util/CommandLineParameter.hpp"
#include "Hardware/Definitions.hpp"

namespace Hardware
{
    namespace Print
    {
		/**
		* @brief Prints the manual. 
		* @author Nicolai Müller
		*/
        void Help();
		
		/**
		* @brief Prints the current memory consumption. 
		* @author Nicolai Müller
		*/		
        uint64_t MemoryConsumption();
		
		/**
		* @brief Prints the command line parameters. 
		* @param CommandLineParameters The command line parameters.
		* @author Nicolai Müller
		*/	
        void CommandLineSettings(CommandLineParameterStruct&);
		
		/**
		* @brief Prints the probe generation settings. 
		* @param Settings The general settings.
		* @param Simulation The simulation settings.
		* @param Test The test settings.
		* @author Nicolai Müller
		*/			
        void ProbeGenerationSettings(Hardware::SettingsStruct&, Hardware::SimulationStruct&, Hardware::TestStruct&);
		
		/**
		* @brief Prints the evaluation settings. 
		* @param Simulation The simulation settings.
		* @param Test The test settings.
		* @author Nicolai Müller
		*/		
        unsigned int EvaluationSettings(Hardware::SimulationStruct&, Hardware::TestStruct&);
		
		/**
		* @brief Prints the evaluation results. 
		* @param Settings The general settings.
		* @param Simulation The simulation settings.
		* @param Test The test settings.
		* @param DeletedAlpha The maximum p-value of a deleted probing set.
		* @param DeletedProbingSet The deleted probing set.
		* @param ElapsedTimePeriod The runtime of PROLEAD.
		* @param Space The space to print one line of evaluation results.
		* @author Nicolai Müller
		*/			
        void EvaluationResults(Hardware::SettingsStruct&, Hardware::SimulationStruct&, Hardware::TestStruct&, double&, std::string&, double, unsigned int);
		
		/**
		* @brief Writes a report file. 
		* @param Settings The general settings.
		* @param Simulation The simulation settings.
		* @param Test The test settings.
		* @param ProbeStepIndex The index of the current step.
		* @param TableWidth The width of the printed table.
		* @author Nicolai Müller
		*/			
        void Report(Hardware::SettingsStruct&, Hardware::SimulationStruct&, Hardware::TestStruct&, unsigned int, unsigned int);
    }
}