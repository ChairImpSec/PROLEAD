#pragma once

#include <stdio.h>

#include <cinttypes>
#include <cstring>
#include <memory>
#include <string>
#include <vector>

#include "Hardware/Enabler.hpp"
#include "Hardware/FaultSet.hpp"
#include "Hardware/SharedData.hpp"
#include "Util/Sharing.hpp"
#include "boost/generator_iterator.hpp"
#include "boost/random.hpp"
#include "boost/log/trivial.hpp"

class Simulation {
 public:
  Simulation(CircuitStruct& circuit, Settings& settings);

  std::string topmodule_name_;
  std::string result_folder_name_;
  uint64_t clock_signal_index_;
  uint64_t number_of_clock_cycles_;
  uint64_t number_of_enablers_;
  uint64_t number_of_probe_extensions_;
  uint64_t number_of_processed_simulations;
  std::vector<std::vector<uint64_t>> always_random_inputs_rising_edge_indices_;
  std::vector<std::vector<uint64_t>> always_random_inputs_falling_edge_indices_;
  std::vector<uint64_t> selected_groups_;
  std::vector<std::pair<uint64_t, uint64_t>> end_condition_signals_;
  std::vector<std::pair<uint64_t, uint64_t>> fault_detection_flags_;
  std::vector<std::vector<std::vector<uint64_t>>> output_share_signal_indices_;
  std::vector<std::vector<std::vector<vlog_bit_t>>>
      expected_unshared_output_values_;
  std::unique_ptr<std::unique_ptr<uint64_t[]>[]> probe_values_;
  std::unique_ptr<std::unique_ptr<uint64_t[]>[]> propagation_values_;
  std::unique_ptr<std::unique_ptr<uint64_t[]>[]> glitch_values_;
  std::unique_ptr<std::unique_ptr<uint64_t[]>[]> constant_zero_;
  std::unique_ptr<uint64_t[]> is_simulation_faulty_;
  std::vector<uint64_t> considered_simulation_indices_;
  std::vector<FaultSet> fault_set_;
};

namespace Hardware {
namespace Simulate {
/**
 * @brief Performs the simulations.
 * @param Circuit The hardware circuit to analyze.
 * @param Settings The general settings.
 * @param SharedData The shared state of a simulation.
 * @param Simulation The simulation settings.
 * @param ThreadRng The rng assigned to a specific thread.
 * @author Amir Moradi
 */
void All(const CircuitStruct&, const Settings&, SharedData&,
         std::vector<const Probe*>&, std::vector<Enabler>&,
         Simulation&, int, boost::mt19937&);

		/**
		* @brief Performs the faulted and fault free (golden) simulations.
		* @param Library The cell library..
		* @param Circuit The hardware circuit to analyze.
		* @param Settings The general settings.
		* @param SharedData The shared state of a simulation.
		* @param Simulation The simulation settings.
		* @param ThreadRng The rng assigned to a specific thread.
		* @author Felix Uhle
		*/
      void SimulateFaultedAndFaultFree2(//const Library &library,
                                       const CircuitStruct &circuit,
                                       const Settings &settings,
                                       SharedData &shared_data,
                                       SharedData &shared_data_faulted,
                                       Simulation &simulation,
                                       uint64_t SimulationIndex,
                                       boost::mt19937 &ThreadRng,
                                       //const std::vector<FaultSet> &fault_sets,
                                       uint64_t thread_index,
                                       std::vector<std::vector<std::vector<FaultType>>> &fault_type
                                       );

/**
 * @brief Generate header for a .vcd file.
 * @param Circuit The hardware circuit to analyze.
 * @param Settings The general settings.
 * @param SimulationIndex The index of the simulation to store in the .vcd file.
 * @author Thanh Dat Nguyen
 */
void GenerateVCDfile(const CircuitStruct&, int, std::string,
                     std::string topmodule_name);

/**
 * @brief Writes the simulation to the .vcd file.
 * @param Circuit The hardware circuit to analyze.
 * @param Settings The general settings.
 * @param SharedData The shared state of a simulation.
 * @param SimulationIndex The index of the simulation to store in the .vcd file.
 * @param CycleIndex The index of the simulated clock cycle to store in the .vcd
 * file.
 * @author Thanh Dat Nguyen
 */
void WriteVCDfile(const CircuitStruct&, uint64_t, SharedData&, int, int,
                  std::string);

/**
 * @brief Finalizes the .vcd file.
 * @param SimulationIndex The index of the simulation to store in the .vcd file.
 * @param CycleIndex The index of the simulated clock cycle to store in the .vcd
 * file.
 * @author Thanh Dat Nguyen
 */
void FinalizeVCDfile(int, int, std::string);
}  // namespace Simulate
}  // namespace Hardware
