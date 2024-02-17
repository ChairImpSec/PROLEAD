#pragma once

#include <bits/stdc++.h>

#include <cinttypes>
#include <vector>

#include "Hardware/Faulting.hpp"
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

/**
 * @brief Defines a cell library.
 * @author Amir Moradi
 */
struct LibraryStruct {
  int NumberOfCellTypes =
      0;  ///< The number of different cell types in the library.
  Hardware::CellTypeStruct** CellTypes =
      NULL;  ///< The different cell types in the library.
  int BufferCellType = -1;
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
};

struct SignalStruct {
  char* Name;
  char Type;
  short Depth;
  int Output;
  int NumberOfInputs;
  int* Inputs;
  char ProbeAllowed;
  char FaultAllowed;
  Hardware::faulting::FaultType fault_type;
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
  bool IsProbeOnSignalAllowed(int base_signal_index, int current_signal_index,
                              int clock_signal_index);

  bool IsFaultOnSignalAllowed(int signal_index, int clock_signal_index);

  bool CanProbeOnSignalBePropagated(int signal_index,
                                    const LibraryStruct& library);
  bool IsGateThatOutputsSignalDeleted(int signal_index);
  int GetNumberOfInputsForSignalsComputingCell(int signal_index);
};

/**
 * @brief Defines the settings of the evaluation procedure.
 * @author Amir Moradi
 */
struct SettingsStruct {
  int Max_no_of_Threads;  ///< The maximum number of threads PROLEAD can use for
                          ///< parallelism.
  char* ModuleName;       ///< The name of the top module.

  int NumberOfGroups;         ///< The number of user-defined groups
  int NumberOfGroupValues;    ///< The size of the group values, i.e. their bit
                              ///< length.
  char CompactDistributions;  ///< Decision whether the evaluation should be
                              ///< performed in compact or normal mode.
  char MinimizeProbeSets;     ///< Decision whether the number of probing sets
                              ///< should be minimized before the evaluation.
  char RemoveProbingSets;     ///< Decision whether probing sets achieving a
                           ///< sufficient confidence level should be removed.
  unsigned int ProbeStepSize;  ///< The number of probing sets to evaluate per
                               ///< execution step.
  int** Group_Values =
      NULL;  ///< The values assigned to the user-defined groups
  int* MaxNumberOfSharesGroupValues;  ///< The number of shares per input bit.

  int ClockSignal;  ///< The index of the clock signal.
  int Max_No_ClockCycles =
      0;  ///< The maximum number of clock cycles to simulate.
  int Max_No_ReportEntries;  ///< The maximum number of entries in the report.

  int NumberOfAlwaysRandomInputs;  ///< Number of fresh random inputs.
  int* AlwaysRandomInputs =
      NULL;  ///< Indices of the fresh random input signals.

  int InitialSim_NumberOfInputs;  ///< The number of inputs which are assigned
                                  ///< to initialize the simulation.
  int InitialSim_NumberOfClockCycles;  ///< The number of clock cycles to
                                       ///< initialize the simulation.
  int** InitialSim_Inputs =
      NULL;  ///< The indices of the initialization signals.
  uint64_t** InitialSim_Values =
      NULL;  ///< The signal values during the initialization cycles.

  int EndSimCondition_ClockCycles;  ///< The number of clock cycles after which
                                    ///< the simulation terminates.
  int EndSimCondition_NumberOfSignals;  ///< The bit width of the signal which
                                        ///< terminates the simulation.
  int* EndSimCondition_Signals = NULL;  ///< The indices of the single-bit
                                        ///< signals terminating the simulation.
  uint64_t* EndSimCondition_Values =
      NULL;  ///< The values the signals have to reach to terminate the
             ///< simulation.
  int EndSim_NumberOfWaitCycles =
      0;  ///< Number of cycles to wait after each simulation.

  int NumberOfOutputShares = 0;   ///< The number of output shares.
  int NumberOfOutputSignals = 0;  ///< The bit width of the shared output.
  int** OutputSignals = NULL;     ///< The simulated output signals (unshared).
  int** ExpectedOutputValues =
      NULL;  ///< The expected unshared output given by the user.

  int TestOrder = 0;  ///< The security order to test.
  int TestMultivariate = 0;  ///< Decision whether univariate or multivariate
                             ///< adversaries should be considered.
  int MaxDistanceMultivariet = 0;  ///< The maximum distance in time, i.e. clock
                                   ///< cycles, for multivariate adversaries.
  int TestTransitional =
      0;  ///< Decision whether transitional leakage is included.
  int NumberOfTestClockCycles = 0;  ///< The number of clock cycles in which the
                                    ///< adversary can place probes.
  int* TestClockCycles =
      NULL;  ///< The particular clock cycles the adversary can target.
  uint64_t NumberOfSimulations = 0;  ///< The total number of simulations.
  uint64_t NumberOfStepSimulations =
      0;  ///< The number of simulations before the simulations are evaluated.
  uint64_t NumberOfStepSimulationsToWrite =
      0;  ///< The number of simulations before a report is written.

  // By default, we set the allowed false-positive probability to 10^-5
  // If necessary, please change the false-positive probability here.
  // Important: Give probability as negative logarithmic value
  double AlphaThreshold = 5.0;

  // By default, we set the allowed false-negative probability to 10^-5
  // If necessary, please change the false-negative probability here.
  double BetaThreshold = 0.00001;

  // In statistics an effect size of 0.1 is denoted as a "small effect size"
  double EffectSize;

  bool WaveformSimulation = false;

  unsigned int number_of_faults = 0;

  unsigned int number_of_faulted_clock_cycles = 0;

  int* faulted_clock_cycles = NULL;

  bool IsInMultivariateSetting() const {
    return (TestMultivariate != 0) && (NumberOfTestClockCycles > 1) &&
           (TestOrder != 1);
  }
};

/**
 * @brief Defines an already extended probe, i.e. a set of glitch extended
 * probes.
 * @author Amir Moradi
 */
struct GlitchExtendedProbesStruct {
  int NumberOfProbes = 0;  ///< The number of glitch-extended probes.
  int* Probes = NULL;      ///< A list of glitch-extended probes.
};

/**
 * @brief Defines a probing set, i.e. a set of standard probes with their
 * corresponding glitch extensions.
 * @author Amir Moradi
 */
struct ProbesStruct {
  int NumberOfProbes = 0;   ///< The number of standard probes.
  int* Probes = NULL;       ///< A list of the standard probe indices.
  char** ProbeName = NULL;  ///< A list of the standard probe names.

  Hardware::GlitchExtendedProbesStruct* GlitchExtendedProbes =
      NULL;  ///< A list of glitch-extensions per standard probe.
};

/**
 * @brief Defines the shared state of a simulation.
 * @author Amir Moradi
 */
struct SharedDataStruct {
  uint64_t* OneIn64 = NULL;
  uint64_t* ZeroIn64 = NULL;
  uint64_t* SignalValues = NULL;
  uint64_t* RegValues = NULL;
  uint64_t** GroupValues = NULL;
  uint64_t** SelectedGroupValues = NULL;
  uint64_t* LastInitialSimValues = NULL;
};

/**
 * @brief Defines a buffer to read design files.
 * @author Amir Moradi
 */
struct FileBufferStruct {
	char* Buffer;
	int   Size;
	int   Index;
};

/**
 * @brief Defines all settings regarding simulations.
 * @author Amir Moradi
 */
struct SimulationStruct {
  int NumberOfGroups;  ///< The number of user-defined groups.
  char* EvaluationResultFolderName =
      NULL;  ///< Name and path of the generated reports.

  int NumberOfProbes = 0;   ///< The total number of standard probes.
  char** ProbeName = NULL;  ///< The names of the standard probes, i.e. the name
                            ///< of the probed wire.
  Hardware::GlitchExtendedProbesStruct*
      GlitchExtendedProbes;  ///< The glitch-extended probes belonging to the
                             ///< standard probes.

  int NumberOfAllGlitchExtendedProbes =
      0;  ///< The total number of glitch-extended probes.
  int* SignalIndex_of_GlitchExtendedProbe = NULL;
  int* GlitchExtendedProbeIndex_of_Signal = NULL;
  char** GlitchExtendedProbeName =
      NULL;  ///< The names of the glitch-extended probes, i.e. the name of the
             ///< probed wire.

  int TestOrder = 0;  ///< The security order to test.
  int TestMultivariate =
      0;  ///< Decision regarding univariate and multivariate attackers.
  int TestTransitional = 0;  ///< Decision regarding transitional leakage.
  int NumberOfTestClockCycles =
      0;  ///< Number of clock cycles in which standard probes can record
  int* TestClockCycles = NULL;  ///< The list of clock cycles to test.

  int NumberOfClockCycles = 0;  ///< Number of clock cycles to simulate, i.e.
                                ///< the duration of one simulation.
  uint64_t NumberOfSimulations = 0;  ///< The total number of simulations.
  uint64_t NumberOfStepSimulations =
      0;  ///< The number of simulations per step. After each step the
          ///< contingency tables are updated.
  uint64_t NumberOfStepSimulationsToWrite =
      0;  ///< The number of simulations after which reports are written.
  uint64_t NumberOfProcessedSimulations =
      0;  ///< The number of currently processed simulations.

  int* SelectedGroups = NULL;  ///< The chosen group for each simulation.
  char*** ProbeValues;  ///< The simulated states of all wires during different
                        ///< simulations and clock cycles.
  Hardware::faulting::FaultSet fault_set;
};
}  // namespace Hardware