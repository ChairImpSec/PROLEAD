
#pragma once

#include <omp.h>
#include <sys/stat.h>

#include <cstdint>
#include <vector>

#include "Hardware/Expression.hpp"
#include "Hardware/Library.hpp"
#include "Hardware/TruthTable.hpp"
#include "Util/Grammars/VlogConstGrammar.hpp"
#include "Util/Settings.hpp"
#include <boost/log/trivial.hpp>

#define Max_Name_Len 1000000

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

enum class signal_t { input, output, wire };

/**
 * @brief Defines a buffer to read design files.
 * @author Amir Moradi
 */
struct FileBufferStruct {
  char* Buffer;
  int Size;
  int Index;
};

std::string parseNextWord(std::string::iterator& it,
                          const std::string::iterator& end);
void NonCommentFromFile(FILE* FileHeader, char* Str, const char* CommentSyntax);
void fReadaWord(FileBufferStruct* FileBuffer, char* Buffer, char* Attribute);
int TrimSignalName(char* SignalName, int* k = nullptr);

struct CellStruct {
  const Cell* type;
  char* Name;
  int Hierarchy;
  short Depth;
  int* Inputs;
  int* Outputs;
  int* RegValueIndexes;
  char Deleted;
  char Flag;

  std::vector<std::pair<std::string, uint64_t>> params_;
  std::vector<Expression> expr_;
  std::vector<Expression> expr_mids_;
  std::vector<Expression> expr_glitch_ext_;
  std::vector<Expression> expr_probe_prop_;

  uint64_t GetNumberOfProbeExtensions() const;
  void Precomp(std::vector<uint64_t>& vals) const;
  uint64_t Eval(uint64_t idx, const std::vector<uint64_t>& vals) const;
  uint64_t EvalGlitch(uint64_t idx, const std::vector<uint64_t>& vals) const;
  uint64_t EvalProp(uint64_t idx, const std::vector<uint64_t>& vals) const;
  TruthTable GenerateSmallEnablers(const std::vector<Expression>& expr_mids,
                                   const Expression& expr);
  void LookupGlitchesSmallTable(TruthTable& table, TruthTable& small_table,
                                IterateEnablers& it);
  bool DetectGlitches(const std::vector<Expression>& expr_mids,
                      const Expression& expr,
                      std::vector<uint64_t> const& norm_input,
                      std::vector<uint64_t> const& mod_input,
                      bool transition_allowed);
  void GenerateRelaxedFunctions(const std::vector<Expression>& expr_mids,
                                const Expression& expr);
  void SetExpressions(bool relaxed);
};

struct SignalStruct {
  char* Name;
  signal_t Type;
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
  CircuitStruct(const std::string& design_file_name,
                const std::string& topmodule_name, const Settings& settings,
                const Library& library);

  std::vector<SignalStruct> signals_;

  int NumberOfSignals = 0;  ///< The total number of signals in the circuit.
  int* Inputs = NULL;       ///< The indices of all primary input signals.
  int* Outputs = NULL;      ///< The indices of all primary output signals.
  int NumberOfInputs = 0;   ///< Number of primary inputs.
  int NumberOfOutputs = 0;  ///< Number of primary outputs.
  int NumberOfConstants = 0;

  std::vector<CellStruct> cells_;
  std::vector<uint64_t> gates_;
  std::vector<uint64_t> regs_;

  int NumberOfRegValues = 0;

  short MaxDepth = 0;         ///< The maximum circuit depth.
  int** CellsInDepth = NULL;  ///< The indices of cells with a specific depth.
  int* NumberOfCellsInDepth =
      NULL;  ///< The number of cells with a specific depth.

  int** ClockCellsInDepth =
      NULL;  ///< The indices of cells with a specific depth.
  int* NumberOfClockCellsInDepth =
      NULL;  ///< The number of cells with a specific depth.

  void MakeCircuitDepth(bool relaxed);
  void SetCellFlag(int SignalIndex);
  int SearchSignalName(char* SignalName, char Trim, const Settings& settings);
  void DesignFile_Find_IO_Port(int NumberOfCells, char* Str1,
                               char SubCircuitRead, const Cell* CellTypeIndex,
                               int CaseIndex, int NumberOfSignalsOffset,
                               char* SubCircuitInstanceName,
                               CircuitStruct* SubCircuit, int*& InputPorts,
                               int& NumberOfInputPorts, int*& OutputPorts,
                               int& NumberOfOutputPorts);
  void DesignFile_Find_Signal_Name(
      int* NumberOfCells, char* Str1, char SubCircuitRead,
      const Cell* CellTypeIndex, int CaseIndex, const Settings& settings,
      const Library& library, int Task, int NumberOfSignalsOffset,
      int NumberOfCellsOffset, char* SubCircuitInstanceName,
      CircuitStruct* SubCircuit, int*& InputPorts, int& NumberOfInputPorts,
      int*& OutputPorts, int& NumberOfOutputPorts, int& CurrentIO);
  int ReadDesignFile(const std::string& design_file_name,
                     const std::string& top_module_name,
                     const Settings& settings, const Library& library,
                     int NumberOfSignalsOffset, int NumberOfCellsOffset,
                     int NumberOfRegValuesOffset, FileBufferStruct* FB);
  CircuitStruct() = default;

  bool IsGateThatOutputsSignalDeleted(int signal_index);
  uint64_t GetNumberOfInputsForSignalsComputingCell(
      uint64_t signal_index) const;
  std::vector<uint64_t> GetSignals() const;
  uint64_t GetSignalIndexByName(const std::string& signal_name);
  void PropagateProbe(uint64_t signal_index, const bool allowed);
  void PropagateExtension(uint64_t signal_index, const bool allowed);
  void SetIsProbeAllowed(const Settings& settings);
  void SetIsExtensionAllowed(const Settings& settings);
  void SetIsAnalysisAllowed(const Settings& settings);
  void SetIsFaultAllowed(const Settings& settings);
  bool IsFaultOnSignalAllowed(uint64_t signal_index,
                              uint64_t clock_signal_index) const;
};
