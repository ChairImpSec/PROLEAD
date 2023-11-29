#pragma once

#include <iostream>
#include <numeric>  
#include <omp.h>

#include <boost/math/distributions/chi_squared.hpp>
#include <boost/math/distributions/inverse_chi_squared.hpp>
#include <boost/math/distributions/non_central_chi_squared.hpp>

#include "Hardware/Definitions.hpp"
#include "Util/Util.hpp"

namespace Hardware
{
    namespace Test
    {
		/**
		* Updates the contingency tables of all probing sets with the results of a single simulation.
		* Hence, one cell of each contingency table will be increased by one. 
		* In compact mode, all cells are assigned with zeros and the probed state is inserted based on its hamming weight.
		*
		* @brief Compact update of a single contingency table. 
		* @param Simulation The simulation settings, i.e. the simulated circuit states.
		* @param SimulationIndex The simulation number in the step.
		* @param Test The test settings, i.e. the unique probes and the contingency tables.
		* @param TempProbeValue A temporary storage for the probed states.
		* @author Amir Moradi
		*/
        void CompactTableUpdate(Hardware::SimulationStruct&, unsigned int, Hardware::TestStruct&, std::vector<int>&);
		
		/**
		* @brief Adds the new simulations to the contingency tables in compact mode and computes a new g-value for each table.
		* @param Simulation The simulation settings, i.e. the simulated circuit states.
		* @param Test The test settings, i.e. the unique probes and the contingency tables.
		* @author Nicolai Müller
		*/		
        void CompactTest(Hardware::SimulationStruct&, Hardware::TestStruct&);
		
		/**
		* Updates the contingency table of one probing set with the results of a simulation step.
		* In normal mode, a cell is assigned if a new probed state occurs and the probed state is stored directly.
		*
		* @brief Normal update of all contingency tables. 
		* @param Simulation The simulation settings, i.e. the simulated circuit states.
		* @param Test The test settings, i.e. the unique probes and the contingency tables.
		* @param ProbingSet The probing set to update.
		* @author Nicolai Müller
		*/		
        void NormalTableUpdate(Hardware::SimulationStruct&, Hardware::TestStruct&, Hardware::ProbingSetStruct&);
	
		/**
		* @brief Adds the new simulations to the contingency tables in normal mode, computes a new g-value for each table, and performs statistical power analysis.
		* @param Settings The general settings, i.e. parameters for statistical power analysis.
		* @param Simulation The simulation settings, i.e. the simulated circuit states.
		* @param Test The test settings, i.e. the unique probes and the contingency tables.
		* @author Nicolai Müller
		*/		
        void NormalTest(Hardware::SettingsStruct&, Hardware::SimulationStruct&, Hardware::TestStruct&);
		
		/**
		* @brief Performs the full test procedure.
		* @param Settings The general settings, i.e. parameters for statistical power analysis.
		* @param Simulation The simulation settings, i.e. the simulated circuit states.
		* @param Test The test settings, i.e. the unique probes and the contingency tables.
		* @param CompactDistributions Decides if the test procedure runs in normal of compact mode.
		* @author Nicolai Müller
		*/		
        void All(Hardware::SettingsStruct&, Hardware::SimulationStruct&, Hardware::TestStruct&, char);
    }
}