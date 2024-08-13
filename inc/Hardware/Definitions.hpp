#pragma once

#include <bits/stdc++.h>

#include <unordered_map>
#include <cinttypes>
#include <vector>
#include <memory>
#include <map>

#include "Hardware/FaultSet.hpp"
#include "Hardware/Library.hpp"
#include "Util/Settings.hpp"
#include "Util/Sharing.hpp"
#include "Util/Util.hpp"

#define Max_Name_Length 10000

#define FullOne 0xffffffffffffffff
#define GroupInput 0x8000000000000000
#define RandomInput 0x4000000000000000
#define SameInput 0x2000000000000000
#define GroupInMask 0xf000000000000000

#define CellType_Gate 0
#define CellType_Reg 1

#define Operation_AND 0
#define Operation_OR 1
#define Operation_XOR 2
#define Operation_NOT 3

#define SignalType_input 0
#define SignalType_output 1
#define SignalType_wire 2

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

struct OperationStruct {
  unsigned char NumberOfClauses;
  char* OperationOfClause;
  unsigned char* NumberOfOperandsInClause;
  unsigned char** OperandsInClause;
};

struct CellTypeStruct {
  char GateOrReg;
  unsigned char NumberOfCases;
  char** Cases;
  char NumberOfInputs;
  char** Inputs;
  char NumberOfOutputs;
  char** Outputs;
  char** Expresions;
  Hardware::OperationStruct* Operations;
  char Intermediate;
};

struct CellStruct {
  int Type;
  char* Name;
  int Hierarchy;
  short Depth;
  char NumberOfInputs;
  int* Inputs;
  char NumberOfOutputs;
  int* Outputs;
  int* RegValueIndexes;
  char Deleted;

    // Destructor
  /*  ~CellStruct() {
        if (Name != NULL) {
            free(Name);  // Free the dynamically allocated name
        }
        if (NumberOfInputs) {
            free(Inputs);  // Free the dynamically allocated inputs array
        }
        if (NumberOfOutputs) {
            free(Outputs);  // Free the dynamically allocated outputs array
        }
        if (RegValueIndexes != NULL) {
            free(RegValueIndexes);  // Free the dynamically allocated reg value indexes array
        }
    }*/

};

struct SignalStruct {
  char* Name;
  char Type;
  short Depth;
  int Output;
  int NumberOfInputs;
  int* Inputs;
  bool is_probe_allowed;
  bool is_extension_allowed;
  bool is_analysis_allowed;
  bool is_fault_allowed;
  char Deleted;

    // Destructor
 /*   ~SignalStruct() {
        if (Name != NULL) {
            free(Name);    // Free the dynamically allocated name
        }
        if (NumberOfInputs) {
            free(Inputs);  // Free the dynamically allocated inputs array
        }
    }*/
};

/**
 * @brief Defines a hardware circuit.
 * @author Amir Moradi
 */
struct CircuitStruct {
  Hardware::SignalStruct** Signals = NULL;  ///< The circuit signals.
  int NumberOfSignals = 0;  ///< The total number of signals in the circuit.
  int* Inputs = NULL;       ///< The indices of all primary input signals.
  int* Outputs = NULL;      ///< The indices of all primary output signals.
  int NumberOfInputs = 0;   ///< Number of primary inputs.
  int NumberOfOutputs = 0;  ///< Number of primary outputs.
  int NumberOfConstants = 0;

  Hardware::CellStruct** Cells = NULL;  ///< The circuit cells.
  int NumberOfCells = 0;                ///< The number of cells in the circuit.
  int* Gates = NULL;                    ///< The indices of all gates.
  int* Regs = NULL;                     /// The indices of all regs.
  int NumberOfGates = 0;                ///< The number of gates in the circuit.
  int NumberOfRegs = 0;  ///< The number of registers in the circuit.
  int NumberOfRegValues = 0;

  short MaxDepth = 0;         ///< The maximum circuit depth.
  int** CellsInDepth = NULL;  ///< The indices of cells with a specific depth.
  int* NumberOfCellsInDepth =
      NULL;  ///< The number of cells with a specific depth.

  bool IsGateThatOutputsSignalDeleted(int signal_index);
  uint64_t GetNumberOfInputsForSignalsComputingCell(uint64_t signal_index) const;
  std::vector<uint64_t> GetSignals() const;
  uint64_t GetSignalIndexByName(const std::string& signal_name);
  void PropagateProbe(Library& library, uint64_t signal_index, const bool allowed);
  void PropagateExtension(Library& library, uint64_t signal_index, const bool allowed);
  void SetIsProbeAllowed(Library& library, const Settings& settings);
  void SetIsExtensionAllowed(Library& library, const Settings& settings);
  void SetIsAnalysisAllowed(const Settings& settings);
  void SetIsFaultAllowed(const Settings& settings);

  // Destructor
 /*  ~CircuitStruct() {
    // Free Signals
    if (NumberOfSignals) {
      for (int i = 0; i < NumberOfSignals; ++i) {
        if (Signals[i] != NULL) {
          free(Signals[i]);
        }
      }
      if (Signals != NULL) {
        free(Signals);
      }
    }

    // Free Inputs and Outputs
    if (NumberOfInputs)
      free(Inputs);
    
    if (NumberOfOutputs)
      free(Outputs);

    // Free Cells
    if (Cells != NULL) {
        for (int i = 0; i < NumberOfCells; ++i) {
            if (Cells[i] != NULL) {
                free(Cells[i]); // Free each individual CellStruct object
            }
        }
        free(Cells); // Free the array of CellStruct pointers
    }

    // Free Gates and Regs
    if (NumberOfGates)
      free(Gates);

    if (NumberOfRegs)  
      free(Regs);

    // Free CellsInDepth and NumberOfCellsInDepth
    if (CellsInDepth) {
      for (int i = 0; i <= MaxDepth; ++i) {
        if (NumberOfCellsInDepth[i])
          free(CellsInDepth[i]);
      }
      free(CellsInDepth);
    }
    free(NumberOfCellsInDepth);
  }*/
};

}  // namespace Hardware

class Simulation {
  public: 
    Simulation(Hardware::CircuitStruct& circuit, Settings& settings);

    std::string topmodule_name_; 
    std::string result_folder_name_;
    uint64_t clock_signal_index_;
    uint64_t number_of_clock_cycles_;
    uint64_t number_of_processed_simulations;
    std::vector<std::vector<uint64_t>> always_random_inputs_indices_;
    std::vector<uint64_t> selected_groups_;
    std::vector<std::pair<uint64_t, uint64_t>> end_condition_signals_; 
    std::vector<std::pair<uint64_t, uint64_t>> fault_detection_flags_; 
    std::vector<std::vector<std::vector<uint64_t>>> output_share_signal_indices_; 
    std::vector<std::vector<std::vector<TriStateBit>>> expected_unshared_output_values_;
    std::unique_ptr<std::unique_ptr<uint64_t[]>[]> probe_values_;
    std::unique_ptr<std::unique_ptr<uint64_t[]>[]> propagation_values_;
    std::unique_ptr<std::unique_ptr<uint64_t[]>[]> glitch_values_;
    std::unique_ptr<std::unique_ptr<uint64_t[]>[]> constant_zero_;
    std::unique_ptr<uint64_t[]> is_simulation_faulty_;
    std::vector<uint64_t> considered_simulation_indices_;
    std::vector<FaultSet> fault_set;
};