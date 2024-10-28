
#pragma once

#include "Hardware/Library.hpp"
#include "Util/Settings.hpp"
#include <cstdint>
#include <vector>

#define CellType_Gate 0
#define CellType_Reg 1

#define SignalType_input 0
#define SignalType_output 1
#define SignalType_wire 2

namespace Hardware {

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
  bool IsFaultOnSignalAllowed(size_t signal_index, size_t clock_signal_index) const;
};

}  // namespace Hardware
