#pragma once

#include <cinttypes>
#include <memory>
#include <vector>
#include <stdio.h>
#include <string>
#include <cstring>

#include "boost/random.hpp"
#include "boost/generator_iterator.hpp"
#include "Hardware/Definitions.hpp"
#include "Hardware/Enabler.hpp"
#include "Hardware/Library.hpp"
#include "Hardware/Probes.hpp"
#include "Hardware/SharedData.hpp"
#include "Util/Sharing.hpp"
#include "Hardware/Circuit.hpp"

namespace Hardware{
    namespace Simulate{
		/**
		* @brief Performs the simulations.
		* @param Circuit The hardware circuit to analyze.
		* @param Settings The general settings.
		* @param SharedData The shared state of a simulation.
		* @param Simulation The simulation settings.
		* @param ThreadRng The rng assigned to a specific thread.
		* @author Amir Moradi
		*/
        void All(const CircuitStruct&, const Settings&, SharedData&, std::vector<Probe>&, std::vector<Enabler<CustomOperation>>&, std::vector<size_t>&, Simulation&, int, boost::mt19937&);

		/**
		* @brief Generate header for a .vcd file.
		* @param Circuit The hardware circuit to analyze.
		* @param Settings The general settings.
		* @param SimulationIndex The index of the simulation to store in the .vcd file.
		* @author Thanh Dat Nguyen
		*/
        void GenerateVCDfile(const CircuitStruct&, int, std::string, std::string topmodule_name);

		/**
		* @brief Writes the simulation to the .vcd file.
		* @param Circuit The hardware circuit to analyze.
		* @param Settings The general settings.
		* @param SharedData The shared state of a simulation.
		* @param SimulationIndex The index of the simulation to store in the .vcd file.
		* @param CycleIndex The index of the simulated clock cycle to store in the .vcd file.
		* @author Thanh Dat Nguyen
		*/
        void WriteVCDfile(const CircuitStruct&, uint64_t, SharedData&, int, int, std::string);

		/**
		* @brief Finalizes the .vcd file.
		* @param SimulationIndex The index of the simulation to store in the .vcd file.
		* @param CycleIndex The index of the simulated clock cycle to store in the .vcd file.
		* @author Thanh Dat Nguyen
		*/
        void FinalizeVCDfile(int, int, std::string);
    }
}

