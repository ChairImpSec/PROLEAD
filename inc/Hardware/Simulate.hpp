#pragma once

#include <cinttypes>

#include "boost/random.hpp"
#include "boost/generator_iterator.hpp"
#include "Hardware/Definitions.hpp"

namespace Hardware{
    namespace Simulate{
	
		/**
		* @brief Evaluates a specific operation. 
		* @param Operation The operation to evaluate.
		* @param Values The inputs of the operation
		* @param Intermediate The index of an intermediate.
		* @author Amir Moradi
		*/
        uint64_t EvaluateOperation(Hardware::OperationStruct, uint64_t *, char);
		
		/**
		* @brief Performs the simulations. 
		* @param Library The cell library..
		* @param Circuit The hardware circuit to analyze.
		* @param Settings The general settings.
		* @param SharedData The shared state of a simulation.
		* @param Simulation The simulation settings.
		* @param ThreadRng The rng assigned to a specific thread.
		* @author Amir Moradi
		*/		
        void All(Hardware::LibraryStruct&, Hardware::CircuitStruct&, Hardware::SettingsStruct&, Hardware::SharedDataStruct*, Hardware::SimulationStruct&, int, boost::mt19937&);

		/**
		* @brief Generate header for a .vcd file. 
		* @param Circuit The hardware circuit to analyze.
		* @param Settings The general settings.
		* @param SimulationIndex The index of the simulation to store in the .vcd file.
		* @author Thanh Dat Nguyen
		*/
        void GenerateVCDfile(Hardware::CircuitStruct&, Hardware::SettingsStruct&, int);
		
		/**
		* @brief Writes the simulation to the .vcd file. 
		* @param Circuit The hardware circuit to analyze.
		* @param Settings The general settings.
		* @param SharedData The shared state of a simulation.
		* @param SimulationIndex The index of the simulation to store in the .vcd file.
		* @param CycleIndex The index of the simulated clock cycle to store in the .vcd file.
		* @author Thanh Dat Nguyen
		*/		
        void WriteVCDfile(Hardware::CircuitStruct&, Hardware::SettingsStruct&, Hardware::SharedDataStruct*, int, int);

		/**
		* @brief Finalizes the .vcd file. 
		* @param SimulationIndex The index of the simulation to store in the .vcd file.
		* @param CycleIndex The index of the simulated clock cycle to store in the .vcd file.
		* @author Thanh Dat Nguyen
		*/	
        void FinalizeVCDfile(int, int);
    }
}

