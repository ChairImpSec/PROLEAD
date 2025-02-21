#pragma once

#include <bits/stdc++.h>

// #include <unordered_map>
// #include <cinttypes>
// #include <map>
#include <vector>
#include <memory>

#include "Hardware/FaultSet.hpp"
#include "Hardware/Circuit.hpp"
#include "Hardware/Library.hpp"
#include "Util/Settings.hpp"

// #include "Hardware/Library.hpp"
// #include "Util/Sharing.hpp"
// #include "Util/Util.hpp"

#define Max_Name_Length 10000

#define FullOne 0xffffffffffffffff
#define GroupInput 0x8000000000000000
#define RandomInput 0x4000000000000000
#define SameInput 0x2000000000000000
#define GroupInMask 0xf000000000000000

#define Task_find_module_type 0
#define Task_find_module_name 1
#define Task_find_open_bracket 2
#define Task_find_point 3
#define Task_find_IO_port 4
#define Task_find_signal_name 5
#define Task_find_close_bracket 6
#define Task_find_comma 7
#define Task_find_assign_signal_name1 8
#define Task_find_equal 9
#define Task_find_assign_signal_name2 10

namespace Hardware {
/**
 * @brief Defines a buffer to read design files.
 * @author Amir Moradi
 */
struct FileBufferStruct {
	char* Buffer;
	int   Size;
	int   Index;
};

}

class Simulation {
  public:
    Simulation(Hardware::CircuitStruct& circuit, Settings& settings);

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
    std::vector<std::vector<std::vector<vlog_bit_t>>> expected_unshared_output_values_;
    std::unique_ptr<std::unique_ptr<uint64_t[]>[]> probe_values_;
    std::unique_ptr<std::unique_ptr<uint64_t[]>[]> propagation_values_;
    std::unique_ptr<std::unique_ptr<uint64_t[]>[]> glitch_values_;
    std::unique_ptr<std::unique_ptr<uint64_t[]>[]> constant_zero_;
    std::unique_ptr<uint64_t[]> is_simulation_faulty_;
    std::vector<uint64_t> considered_simulation_indices_;
    std::vector<FaultSet> fault_set;
};
