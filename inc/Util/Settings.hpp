#pragma once

#include <boost/dynamic_bitset.hpp>
#include <boost/json.hpp>
#include <boost/log/trivial.hpp>
#include <fstream>
#include <regex>
#include <sstream>
#include <string>
#include <vector>

#include "Util/CpuCoreSelector.hpp"
#include "Util/FileParsing.hpp"
#include "Util/Sharing.hpp"
// #include "Hardware/Fault.hpp"
#include "Types.hpp"


struct IncludeSettings {
  bool first_include;
  std::regex included_elements;
  std::regex excluded_elements;
  std::regex included_paths;
  std::regex excluded_paths;
};

struct FiniteFieldSettings {
  uint64_t base;
  uint64_t exponent;
  bool is_additive;
  Polynomial irreducible_polynomial;
  std::vector<std::vector<TriStateBit>> excluded_elements;
};

struct PerformanceSettings {
  bool compact_distributions;
  bool remove_full_probing_sets;
  uint64_t number_of_threads;
  uint64_t number_of_entries_in_report;
  uint64_t number_of_probing_sets_per_step;
  Minimization minimize;
};

struct HardwareSettings {
  // TODO: init a member variable of Circuit class with that info or make citcuit aware of this.
  // This allwow to perform the check, IsFaultOnSignalAllowed without giveing clock_signal_name from
  // outside, which seems pointless to me.
  std::string clock_signal_name;
};

struct SoftwareSettings {
  uint64_t number_of_pipeline_stages;
  std::string compiler_flags;
  std::string location_of_cipher;
};

struct SimulationSettings {
  bool waveform_simulation;
  uint64_t number_of_clock_cycles;
  uint64_t number_of_wait_cycles;
  uint64_t number_of_simulations;
  uint64_t number_of_simulations_per_step;
  uint64_t number_of_simulations_per_write;
  uint64_t end_condition_clock_cycles;
  std::vector<std::vector<TriStateBit>> groups;
  std::vector<std::vector<std::string>> output_shares;
  std::vector<std::vector<TriStateBit>> expected_outputs;
  std::vector<std::pair<std::string, bool>> end_condition_signals;
  std::vector<std::pair<std::string, bool>> fault_detection_flags;
  std::vector<std::vector<std::string>> always_random_input_signals;
  std::vector<std::vector<InputAssignment>> input_sequence;
};

struct SideChannelAnalysisSettings {
  bool relaxed_model;
  bool transitional_leakage;
  uint64_t order;
  Analysis variate;
  uint64_t distance;
  double effect_size;
  double alpha_threshold;
  double beta_threshold;
  IncludeSettings locations;
  IncludeSettings extension;
  IncludeSettings analysis;
  std::vector<uint64_t> clock_cycles;
};

struct FaultProperties {
  IncludeSettings locations;
  FaultType fault_type;
  double probability;
  bool fault_logic_gates;
  bool fault_storage_gates;
};

struct FaultInjectionSettings {
  FaultType type; // TODO: remove? included in fault_properties
  std::vector<FaultProperties> fault_properties;
  FaultAnalysis analysis;
  uint64_t maximum_per_run;
  uint64_t minimum_per_run;
  uint64_t maximum_per_cycle;
  uint64_t minimum_per_cycle;
  IncludeSettings locations; // TODO: remove? included in fault_properties
  std::vector<uint64_t> clock_cycles;
};

class Settings {
 public:
  FiniteFieldSettings input_finite_field;
  FiniteFieldSettings output_finite_field;
  SideChannelAnalysisSettings side_channel_analysis;
  FaultInjectionSettings fault_injection;

  Settings(const std::string& config_file_path, bool is_hardware_target);


  /*
  * Performance settings getter and setter
  */
  bool IsCompactDistribution() const;
  void SetCompactDistribution(bool compact);
  bool IsRemoveFullProbingSets() const;
  uint64_t GetNumberOfThreads() const;
  uint64_t GetNumberOfEntriesInReport() const;
  uint64_t GetNumberOfProbingSetsPerStep() const;
  Minimization GetMinimization() const;
  void SetMinimization(const Minimization& minimization);

  /*
  * Hardware setting getter and setter
  */
  std::string GetClockSignalName() const;

  /*
  * Software setting getter and setter
  */
  uint64_t GetNumberOfPipelineStages() const;
  std::string GetCompilerFlags() const;
  std::string GetLocationOfCipher() const;

  /*
  * Simulation setting getter and setter
  */
  bool IsWaveformSimulation() const;
  uint64_t GetNumberOfClockCycles() const;
  uint64_t GetNumberOfWaitCycles() const;
  uint64_t GetNumberOfSimulations() const;
  uint64_t GetNumberOfSimulationsPerStep() const;
  uint64_t GetNumberOfSimulationsPerWrite() const;
  uint64_t GetEndConditionClockCycles() const;
  uint64_t GetNumberOfGroups() const;
  uint64_t GetNumberOfBitsPerGroup() const;
  TriStateBit GetGroupBit(uint64_t group_index, uint64_t bit_index) const;
  uint64_t GetNumberOfOutputShares() const;
  uint64_t GetNumberOfBitsPerOutputShare() const;
  std::string GetOutputShareName(uint64_t share_index, uint64_t bit_index) const;
  uint64_t GetNumberOfExpectedOutputs() const;
  TriStateBit GetExpectedOutputBit(uint64_t group_index, uint64_t bit_index) const;
  uint64_t GetNumberOfEndConditionSignalValuePairs() const;
  const std::vector<std::pair<std::string, bool>>& GetEndConditionSignalValuePairs() const;
  std::pair<std::string, bool> GetEndConditionSignalValuePair(uint64_t index) const;
  uint64_t GetNumberOfFaultDetectionSignalValuePairs() const;
  const std::vector<std::pair<std::string, bool>>& GetFaultDetectionSignalValuePairs() const;
  std::pair<std::string, bool> GetFaultDetectionSignalValuePair(uint64_t index) const;
  uint64_t GetNumberOfAlwaysRandomInputSignals() const;
  const std::vector<std::string>& GetAlwaysRandomInputElement(uint64_t index) const;
  uint64_t GetCyclesForInputSequence() const;
  const std::vector<InputAssignment>& GetInputSequenceOfOneCycle(uint64_t index) const;

  /*
  * Side-channel anaylsis setting getter and setter
  */
  bool IsRelaxedModel() const;
  void SetRelaxedModel(bool model);
  bool IsTransitionalLeakage() const;
  uint64_t GetTestOrder() const;
  void SetTestOrder(uint64_t order);
  Analysis GetVariate() const;
  uint64_t GetDistance() const;


  bool IsDistanceSmallEnough(uint64_t distance) const;
  bool IsMultivariateEvaluationRequired() const;
  bool IsLocation(const std::string& signal_name) const;

  uint64_t GetNumberOfTestClockCycles() const;
  uint64_t GetTestClockCycle(uint64_t index) const;


  uint64_t GetNumberOfSignalValuePairs(uint64_t index) const;
  uint64_t GetSignalLengthPerAssignment(uint64_t clock_index, uint64_t assignment_index) const;
  uint64_t GetGroupIndexOfAssignment(uint64_t clock_index, uint64_t assignment_index, uint64_t group_index) const;
  uint64_t GetShareIndexOfAssignment(uint64_t clock_index, uint64_t assignment_index) const;
  ValueType GetAssignmentType(uint64_t clock_index, uint64_t assignment_index) const;
  std::string GetSignalVectorName(uint64_t clock_index, uint64_t assignment_index) const;
  bool IsAssignedToConstant(uint64_t clock_index, uint64_t assignment_index) const;
  bool EndConditionIsBasedOnClockCycles() const;
  std::string GetEndConditionVectorName() const;


  TriStateBit GetAssignedConstantBit(uint64_t clock_index, uint64_t assignment_index, uint64_t bit_index) const;

 private:
  bool is_target_hardware_;
  PerformanceSettings performance;
  HardwareSettings hardware;
  SoftwareSettings software;
  SimulationSettings simulation;

  void ParseArrayOfTriStateBitVectors(const boost::json::object& json_object, const std::string& identifier, uint64_t number_of_values, bool required, bool check_number_of_values, std::vector<std::vector<TriStateBit>>& values);
  void ParseFiniteField(const boost::json::object& json_object, const std::string& identifier, FiniteFieldSettings& settings);
  void ParsePerformanceSettings(const boost::json::object& json_object, const std::string& identifier, PerformanceSettings& settings);
  void ParseHardwareSettings(const boost::json::object& json_object, const std::string& identifier, HardwareSettings& settings);
  void ParseSoftwareSettings(const boost::json::object& json_object, const std::string& identifier, SoftwareSettings& settings);
  void ParseGroups(const boost::json::object& json_object, std::vector<std::vector<TriStateBit>>& groups);
  void ParseAlwaysRandomInputs(const boost::json::object& json_object, std::vector<std::vector<std::string>>& always_random_input_signals);
  void ParseSignalNameValuePair(const boost::json::object& json_object, const std::string& identifier, std::vector<std::pair<std::string, bool>>& name_value_pairs);
  void ParseEndCondition(const boost::json::object& json_object, uint64_t& end_condition_clock_cycles, std::vector<std::pair<std::string, bool>>& end_condition_signals);
  void ParseOutputShares(const boost::json::object& json_object, std::vector<std::vector<std::string>>& output_shares);
  void ParseInputSequence(const boost::json::object& json_object, std::vector<std::vector<InputAssignment>>& input_sequence);
  void ParseSimulationSettings(const boost::json::object& json_object, const std::string& identifier, SimulationSettings& settings);
  void ParseClockCycles(const boost::json::object& json_object, const std::string& identifier, std::vector<uint64_t>& clock_cycles);
  void ParseIncludeSettings(const boost::json::object& json_object, const std::string& identifier, bool default_include, IncludeSettings& settings);
  void ParseSideChannelAnalysisSettings(const boost::json::object& json_object, const std::string& identifier, SideChannelAnalysisSettings& settings);
  void ParseFaultInjectionSettings(const boost::json::object& json_object, const std::string& identifier, FaultInjectionSettings& settings);
};

namespace SettingNames {

extern const std::string BASE;
extern const std::string EXPONENT;
extern const std::string IS_ADDITIVE;
extern const std::string EXCLUDED_ELEMENTS;
extern const std::string IRREDUCIBLE_POLYNOMIAL;
extern const std::string INPUT_FINITE_FIELD;
extern const std::string OUTPUT_FINITE_FIELD;

extern const std::string NUMBER_OF_THREADS;
extern const std::string COMPACT_DISTRIBUTIONS;
extern const std::string MINIMIZE_PROBING_SETS;
extern const std::string REMOVE_FULL_PROBING_SETS;
extern const std::string NUMBER_OF_ENTRIES_IN_REPORT;
extern const std::string NUMBER_OF_PROBING_SETS_PER_STEP;
extern const std::string PERFORMANCE;

extern const std::string CLOCK_SIGNAL_NAME;
extern const std::string HARDWARE;

extern const std::string COMPILER_FLAGS;
extern const std::string LOCATION_OF_CIPHER;
extern const std::string NUMBER_OF_PIPELINE_STAGES;
extern const std::string SOFTWARE;

extern const std::string WAVEFORM_SIMULATION;
extern const std::string NUMBER_OF_CLOCK_CYCLES;
extern const std::string END_WAIT_CYCLES;
extern const std::string END_CONDITION;
extern const std::string GROUPS;
extern const std::string ALWAYS_RANDOM_INPUTS;
extern const std::string OUTPUT_SHARES;
extern const std::string EXPECTED_OUTPUT;
extern const std::string INPUT_SEQUENCE;
extern const std::string FAULT_DETECTION_FLAGS;
extern const std::string NUMBER_OF_SIMULATIONS;
extern const std::string NUMBER_OF_SIMULATIONS_PER_STEP;
extern const std::string NUMBER_OF_SIMULATIONS_PER_WRITE;
extern const std::string SIMULATION;

extern const std::string ALPHA_THRESHOLD;
extern const std::string BETA_THRESHOLD;
extern const std::string EFFECT_SIZE;
extern const std::string ORDER_OF_TEST;
extern const std::string RELAXED_MODEL;
extern const std::string TRANSITIONAL_LEAKAGE;
extern const std::string VARIATE;
extern const std::string DISTANCE;
extern const std::string CLOCK_CYCLES;
extern const std::string PROBE_PLACEMENT;
extern const std::string EXTENSION_ROUTES;
extern const std::string OBSERVED_EXTENSIONS;
extern const std::string SIDE_CHANNEL_ANALYSIS;

extern const std::string MAXIMUM_NUMBER_OF_FAULTS_PER_RUN;
extern const std::string MINIMUM_NUMBER_OF_FAULTS_PER_RUN;
extern const std::string MAXIMUM_NUMBER_OF_FAULTS_PER_CYCLE;
extern const std::string MINIMUM_NUMBER_OF_FAULTS_PER_CYCLE;
extern const std::string FAULTED_CLOCK_CYCLES;
extern const std::string FAULT_TYPE;
extern const std::string FAULT_LOCATIONS;
extern const std::string FAULT_INJECTION;
extern const std::string FAULT_ANALYSIS;

}  // namespace SettingNames
