#pragma once

#include "Util/FileParsing.hpp"

namespace SettingNames {
  extern const std::string ANALYSIS_STRATEGY;

  extern const std::string FAULT_INJECTION;
  extern const std::string FAULTED_CLOCK_CYCLES;
  extern const std::string FAULT_LOCATIONS;
  extern const std::string FAULT_TYPE;
  extern const std::string MAXIMUM_NUMBER_OF_FAULTS_PER_CYCLE;
  extern const std::string MAXIMUM_NUMBER_OF_FAULTS_PER_RUN;
  extern const std::string MINIMUM_NUMBER_OF_FAULTS_PER_CYCLE;
  extern const std::string MINIMUM_NUMBER_OF_FAULTS_PER_RUN;
  extern const std::string FAULT_ANALYSIS;

  extern const std::string INPUT_FINITE_FIELD;
  extern const std::string OUTPUT_FINITE_FIELD;
  extern const std::string BASE;
  extern const std::string EXCLUDED_ELEMENTS;
  extern const std::string EXPONENT;
  extern const std::string IRREDUCIBLE_POLYNOMIAL;
  extern const std::string IS_ADDITIVE;

  extern const std::string PERFORMANCE;
  extern const std::string COMPACT_DISTRIBUTIONS;
  extern const std::string MINIMIZE_PROBING_SETS;
  extern const std::string NUMBER_OF_ENTRIES_IN_REPORT;
  extern const std::string NUMBER_OF_PROBING_SETS_PER_STEP;
  extern const std::string NUMBER_OF_THREADS;
  extern const std::string REMOVE_FULL_PROBING_SETS;

  extern const std::string HARDWARE;
  extern const std::string CLOCK_SIGNAL_NAME;
  extern const std::string CLOCK_EDGE_TYPE;

  extern const std::string SIDE_CHANNEL_ANALYSIS;
  extern const std::string ALPHA_THRESHOLD;
  extern const std::string BETA_THRESHOLD;
  extern const std::string CLOCK_CYCLES;
  extern const std::string DISTANCE;
  extern const std::string EFFECT_SIZE;
  extern const std::string EXTENSION_ROUTES;
  extern const std::string OBSERVED_EXTENSIONS;
  extern const std::string ORDER_OF_TEST;
  extern const std::string PROBE_PLACEMENT;
  extern const std::string RELAXED_MODEL;
  extern const std::string TRANSITIONAL_LEAKAGE;
  extern const std::string VARIATE;

  extern const std::string SOFTWARE;
  extern const std::string COMPILER_FLAGS;
  extern const std::string LOCATION_OF_CIPHER;
  extern const std::string PIPELINE_STAGES;

  extern const std::string SIMULATION;
  extern const std::string ALWAYS_RANDOM_INPUTS;
  extern const std::string ALWAYS_RANDOM_INPUTS_RISING_EDGE;
  extern const std::string ALWAYS_RANDOM_INPUTS_FALLING_EDGE;
  extern const std::string ALWAYS_RANDOM_INPUTS_BOTH_EDGES;
  extern const std::string END_CONDITION;
  extern const std::string END_WAIT_CYCLES;
  extern const std::string EXPECTED_OUTPUT;
  extern const std::string FAULT_DETECTION_FLAGS;
  extern const std::string GROUPS;
  extern const std::string INPUT_SEQUENCE;
  extern const std::string NUMBER_OF_CLOCK_CYCLES;  
  extern const std::string NUMBER_OF_SIMULATIONS;
  extern const std::string NUMBER_OF_SIMULATIONS_PER_STEP;
  extern const std::string NUMBER_OF_SIMULATIONS_PER_WRITE;
  extern const std::string OUTPUT_SHARES;
  extern const std::string WAVEFORM_SIMULATION;

  extern const std::string FIESTA_ADVERSARIES;
  extern const std::string FIESTA_CONFIDENCE_LEVEL;
  extern const std::string FIESTA_FAULT_PROBABILITY;
  extern const std::string FIESTA_PROPERTIES;
  extern const std::string FIESTA_TARGET_LOGIC_GATES;
  extern const std::string FIESTA_TARGET_STORAGE_GATES;

}  // namespace SettingNames

extern JsonSchema fault_injection_schema;
extern JsonSchema hardware_schema;
extern JsonSchema input_finite_field_schema;
extern JsonSchema output_finite_field_schema;
extern JsonSchema performance_schema;
extern JsonSchema side_channel_analysis_schema;
extern JsonSchema simulation_schema;
extern JsonSchema settings_schema;