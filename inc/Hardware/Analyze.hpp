#pragma once

#include <iostream>
#include <cinttypes>
#include <cmath>
#include <omp.h>

#include "Hardware/Definitions.hpp"
#include "Hardware/Print.hpp"
#include "Hardware/Read.hpp"
#include "Hardware/Prepare.hpp"
#include "Hardware/GenerateProbingSets.hpp"
#include "Hardware/Simulate.hpp"
#include "Hardware/Test.hpp"
#include "Util/CommandLineParameter.hpp"
#include "Util/Util.hpp"

namespace Hardware
{
    namespace Analyze
    {
		/**
		* @brief Analyzes the probing security of a circuit under a certain model. 
		* @param Library The cell library..
		* @param Circuit The hardware circuit to analyze.
		* @param Settings The general settings.
		* @param SharedData The shared state of a simulation.
		* @param Simulation The simulation settings.
		* @param Test The test settings.
		* @author Nicolai Müller
		*/
        void All(Hardware::LibraryStruct&, Hardware::CircuitStruct&, Hardware::SettingsStruct&, Hardware::SharedDataStruct*, Hardware::SimulationStruct&, Hardware::TestStruct&);

		/**
		* @brief Analyzes the robust probing security of a circuit. 
		* @param Library The cell library..
		* @param Circuit The hardware circuit to analyze.
		* @param Settings The general settings.
		* @param SharedData The shared state of a simulation.
		* @param Simulation The simulation settings.
		* @param Test The test settings.
		* @author Nicolai Müller
		*/
        void RobustProbingSecurity(Hardware::LibraryStruct&, Hardware::CircuitStruct&, Hardware::SettingsStruct&, Hardware::SharedDataStruct*, Hardware::SimulationStruct&, Hardware::TestStruct&);
		
		/**
		* @brief Analyzes the robust probing security of a circuit with univariate adversaries. 
		* @param Library The cell library..
		* @param Circuit The hardware circuit to analyze.
		* @param Settings The general settings.
		* @param SharedData The shared state of a simulation.
		* @param Simulation The simulation settings.
		* @param Test The test settings.
		* @param StartTime The start time of the analysis.
		* @author Nicolai Müller
		*/		
        void UnivariateRobustProbingSecurity(Hardware::LibraryStruct&, Hardware::CircuitStruct&, Hardware::SettingsStruct&, Hardware::SharedDataStruct*, Hardware::SimulationStruct&, Hardware::TestStruct&, timespec&);
		
		/**
		* @brief Analyzes the robust probing security of a circuit with multivariate adversaries. 
		* @param Library The cell library..
		* @param Circuit The hardware circuit to analyze.
		* @param Settings The general settings.
		* @param SharedData The shared state of a simulation.
		* @param Simulation The simulation settings.
		* @param Test The test settings.
		* @param StartTime The start time of the analysis.
		* @author Nicolai Müller
		*/			
        void MultivariateRobustProbingSecurity(Hardware::LibraryStruct&, Hardware::CircuitStruct&, Hardware::SettingsStruct&, Hardware::SharedDataStruct*, Hardware::SimulationStruct&, Hardware::TestStruct&, timespec&);
		
		/**
		* @brief Analyzes the robust probing security of a circuit for a restricted set of adversaries. 
		* @param Library The cell library..
		* @param Circuit The hardware circuit to analyze.
		* @param Settings The general settings.
		* @param SharedData The shared state of a simulation.
		* @param Simulation The simulation settings.
		* @param Test The test settings.
		* @param StartTime The start time of the analysis.
		* @Param ProbeStepIndex The index of the restricted probing set.
		* @author Nicolai Müller
		*/			
        void RobustProbingSecurityForSomeProbingSets(Hardware::LibraryStruct&, Hardware::CircuitStruct&, Hardware::SettingsStruct&, Hardware::SharedDataStruct*, Hardware::SimulationStruct&, Hardware::TestStruct&, timespec&, unsigned int&);
    }
}