#include "Util/SettingsSchema.hpp"
const std::string SettingNames::ANALYSIS_STRATEGY = "analysis_strategy";

const std::string SettingNames::FAULT_INJECTION = "fault_injection";
const std::string SettingNames::FAULTED_CLOCK_CYCLES = "clock_cycles";
const std::string SettingNames::FAULT_LOCATIONS = "fault_locations";
const std::string SettingNames::FAULT_TYPE = "type";
const std::string SettingNames::MAXIMUM_NUMBER_OF_FAULTS_PER_CYCLE =
    "maximum_number_of_faults_per_cycle";
const std::string SettingNames::MAXIMUM_NUMBER_OF_FAULTS_PER_RUN =
    "maximum_number_of_faults_per_run";
const std::string SettingNames::MINIMUM_NUMBER_OF_FAULTS_PER_CYCLE =
    "minimum_number_of_faults_per_cycle";
const std::string SettingNames::MINIMUM_NUMBER_OF_FAULTS_PER_RUN =
    "minimum_number_of_faults_per_run";
const std::string SettingNames::FAULT_ANALYSIS = "simulations_to_analyze";

const std::string SettingNames::INPUT_FINITE_FIELD = "input_finite_field";
const std::string SettingNames::OUTPUT_FINITE_FIELD = "output_finite_field";
const std::string SettingNames::BASE = "base";
const std::string SettingNames::EXCLUDED_ELEMENTS = "excluded_elements";
const std::string SettingNames::EXPONENT = "exponent";
const std::string SettingNames::IRREDUCIBLE_POLYNOMIAL =
    "irreducible_polynomial";
const std::string SettingNames::IS_ADDITIVE = "is_additive";

const std::string SettingNames::PERFORMANCE = "performance";
const std::string SettingNames::COMPACT_DISTRIBUTIONS = "compact_distributions";
const std::string SettingNames::MINIMIZE_PROBING_SETS = "minimize_probing_sets";
const std::string SettingNames::NUMBER_OF_ENTRIES_IN_REPORT =
    "number_of_entries_in_report";
const std::string SettingNames::NUMBER_OF_PROBING_SETS_PER_STEP =
    "number_of_probing_sets_per_step";
const std::string SettingNames::NUMBER_OF_THREADS = "max_number_of_threads";
const std::string SettingNames::REMOVE_FULL_PROBING_SETS =
    "remove_full_probing_sets";

const std::string SettingNames::HARDWARE = "hardware";
const std::string SettingNames::CLOCK_SIGNAL_NAME = "clock_signal_name";
const std::string SettingNames::CLOCK_EDGE_TYPE = "timing";

const std::string SettingNames::SIDE_CHANNEL_ANALYSIS = "side_channel_analysis";
const std::string SettingNames::ALPHA_THRESHOLD = "alpha_threshold";
const std::string SettingNames::BETA_THRESHOLD = "beta_threshold";
const std::string SettingNames::CLOCK_CYCLES = "clock_cycles";
const std::string SettingNames::DISTANCE = "distance";
const std::string SettingNames::NOTION = "notion";
const std::string SettingNames::EFFECT_SIZE = "effect_size";
const std::string SettingNames::EXTENSION_ROUTES = "extension_routes";
const std::string SettingNames::OBSERVED_EXTENSIONS = "observed_extensions";
const std::string SettingNames::ORDER_OF_TEST = "order";
const std::string SettingNames::PROBE_PLACEMENT = "probe_placement";
const std::string SettingNames::RELAXED_MODEL = "relaxed_model";
const std::string SettingNames::TRANSITIONAL_LEAKAGE = "transitional_leakage";
const std::string SettingNames::VARIATE = "variate";

const std::string SettingNames::SOFTWARE = "software";
const std::string SettingNames::COMPILER_FLAGS = "compiler_flags";
const std::string SettingNames::LOCATION_OF_CIPHER = "location_of_cipher";
const std::string SettingNames::PIPELINE_STAGES = "pipeline_stages";

const std::string SettingNames::SIMULATION = "simulation";
const std::string SettingNames::ALWAYS_RANDOM_INPUTS = "always_random_inputs";
const std::string SettingNames::ALWAYS_RANDOM_INPUTS_RISING_EDGE =
    "always_random_inputs_rising_edge";
const std::string SettingNames::ALWAYS_RANDOM_INPUTS_FALLING_EDGE =
    "always_random_inputs_falling_edge";
const std::string SettingNames::ALWAYS_RANDOM_INPUTS_BOTH_EDGES =
    "always_random_inputs_both_edges";
const std::string SettingNames::END_CONDITION = "end_condition";
const std::string SettingNames::END_WAIT_CYCLES = "end_wait_cycles";
const std::string SettingNames::EXPECTED_OUTPUT = "expected_output";
const std::string SettingNames::FAULT_DETECTION_FLAGS = "fault_detection_flags";
const std::string SettingNames::GROUPS = "groups";
const std::string SettingNames::INPUT_SEQUENCE = "input_sequence";
const std::string SettingNames::NUMBER_OF_CLOCK_CYCLES =
    "number_of_clock_cycles";
const std::string SettingNames::NUMBER_OF_SIMULATIONS = "number_of_simulations";
const std::string SettingNames::NUMBER_OF_SIMULATIONS_PER_STEP =
    "number_of_simulations_per_step";
const std::string SettingNames::NUMBER_OF_SIMULATIONS_PER_WRITE =
    "number_of_simulations_per_write";
const std::string SettingNames::OUTPUT_SHARES = "output_shares";
const std::string SettingNames::WAVEFORM_SIMULATION = "waveform_simulation";

const std::string SettingNames::FIESTA_ADVERSARIES = "adversaries";
const std::string SettingNames::FIESTA_CONFIDENCE_LEVEL = "confidence_level";
const std::string SettingNames::FIESTA_FAULT_PROBABILITY = "probability";
const std::string SettingNames::FIESTA_PROPERTIES = "properties";
const std::string SettingNames::FIESTA_TARGET_LOGIC_GATES =
    "target_logic_gates";
const std::string SettingNames::FIESTA_TARGET_STORAGE_GATES =
    "target_storage_gates";

JsonSchema fault_injection_schema(
    SettingNames::FAULT_INJECTION, "object",
    {JsonSchema(
         SettingNames::FIESTA_ADVERSARIES, "array",
         {JsonSchema(
             "", "object",
             {JsonSchema(
                 SettingNames::FIESTA_PROPERTIES, "array",
                 {JsonSchema(
                     "", "object",
                     {JsonSchema(SettingNames::FAULT_LOCATIONS, "object",
                                 {JsonSchema("exclude", "object",
                                             {JsonSchema("signals", "string")}),
                                  JsonSchema("include", "object",
                                             {JsonSchema("signals",
                                                         "string")})}),
                      JsonSchema(SettingNames::FIESTA_FAULT_PROBABILITY,
                                 "double"),
                      JsonSchema(SettingNames::FIESTA_TARGET_LOGIC_GATES,
                                 "bool"),
                      JsonSchema(SettingNames::FIESTA_TARGET_STORAGE_GATES,
                                 "bool"),
                      JsonSchema(SettingNames::FAULT_TYPE, "string")
          })})})}),
     JsonSchema(SettingNames::FAULTED_CLOCK_CYCLES, "array"),
     JsonSchema(SettingNames::FIESTA_CONFIDENCE_LEVEL, "double"),
     JsonSchema(
         SettingNames::FAULT_LOCATIONS, "object",
         {JsonSchema("exclude", "object", {JsonSchema("signals", "string")}),
          JsonSchema("include", "object", {JsonSchema("signals", "string")})}),
     JsonSchema(SettingNames::MAXIMUM_NUMBER_OF_FAULTS_PER_CYCLE, "int"),
     JsonSchema(SettingNames::MAXIMUM_NUMBER_OF_FAULTS_PER_RUN, "int"),
     JsonSchema(SettingNames::MINIMUM_NUMBER_OF_FAULTS_PER_CYCLE, "int"),
     JsonSchema(SettingNames::MINIMUM_NUMBER_OF_FAULTS_PER_RUN, "int"),
     JsonSchema(SettingNames::FAULT_ANALYSIS, "string"),
     JsonSchema(SettingNames::FAULT_TYPE, "string")});

JsonSchema hardware_schema(
    SettingNames::HARDWARE, "object",
    {JsonSchema(SettingNames::CLOCK_SIGNAL_NAME, "string"),
     JsonSchema(SettingNames::CLOCK_EDGE_TYPE, "string")});

JsonSchema input_finite_field_schema(
    SettingNames::INPUT_FINITE_FIELD, "object",
    {JsonSchema(SettingNames::BASE, "int"),
     JsonSchema(SettingNames::EXCLUDED_ELEMENTS, "array"),
     JsonSchema(SettingNames::EXPONENT, "int"),
     JsonSchema(SettingNames::IRREDUCIBLE_POLYNOMIAL, "string"),
     JsonSchema(SettingNames::IS_ADDITIVE, "bool")});

JsonSchema output_finite_field_schema(
    SettingNames::OUTPUT_FINITE_FIELD, "object",
    {JsonSchema(SettingNames::BASE, "int"),
     JsonSchema(SettingNames::EXCLUDED_ELEMENTS, "array"),
     JsonSchema(SettingNames::EXPONENT, "int"),
     JsonSchema(SettingNames::IRREDUCIBLE_POLYNOMIAL, "string"),
     JsonSchema(SettingNames::IS_ADDITIVE, "bool")});

JsonSchema performance_schema(
    SettingNames::PERFORMANCE, "object",
    {
        JsonSchema(SettingNames::COMPACT_DISTRIBUTIONS, "bool"),
        JsonSchema(SettingNames::NUMBER_OF_THREADS, "string"),
        JsonSchema(SettingNames::MINIMIZE_PROBING_SETS, "string"),
        JsonSchema(SettingNames::NUMBER_OF_ENTRIES_IN_REPORT, "int"),
        JsonSchema(SettingNames::NUMBER_OF_PROBING_SETS_PER_STEP, "int"),
        JsonSchema(SettingNames::REMOVE_FULL_PROBING_SETS, "bool"),
    });

JsonSchema side_channel_analysis_schema(
    SettingNames::SIDE_CHANNEL_ANALYSIS, "object",
    {JsonSchema(SettingNames::ALPHA_THRESHOLD, "double"),
     JsonSchema(SettingNames::BETA_THRESHOLD, "double"),
     JsonSchema(SettingNames::CLOCK_CYCLES, "array"),
     JsonSchema(SettingNames::DISTANCE, "int"),
     JsonSchema(SettingNames::EFFECT_SIZE, "double"),
     JsonSchema(SettingNames::EXTENSION_ROUTES, "object",
                {JsonSchema("exclude", "object",
                            {JsonSchema("paths", "string"),
                             JsonSchema("signals", "string")}),
                 JsonSchema("include", "object",
                            {JsonSchema("paths", "string"),
                             JsonSchema("signals", "string")})}),
     JsonSchema(SettingNames::NOTION, "string"),
     JsonSchema(SettingNames::OBSERVED_EXTENSIONS, "object",
                {JsonSchema("exclude", "object",
                            {JsonSchema("paths", "string"),
                             JsonSchema("signals", "string")}),
                 JsonSchema("include", "object",
                            {JsonSchema("paths", "string"),
                             JsonSchema("signals", "string")})}),
     JsonSchema(SettingNames::ORDER_OF_TEST, "int"),
     JsonSchema(SettingNames::PROBE_PLACEMENT, "object",
                {JsonSchema("exclude", "object",
                            {JsonSchema("paths", "string"),
                             JsonSchema("signals", "string")}),
                 JsonSchema("include", "object",
                            {JsonSchema("paths", "string"),
                             JsonSchema("signals", "string")})}),
     JsonSchema(SettingNames::RELAXED_MODEL, "bool"),
     JsonSchema(SettingNames::TRANSITIONAL_LEAKAGE, "bool"),
     JsonSchema(SettingNames::VARIATE, "string")});

JsonSchema simulation_schema(
    SettingNames::SIMULATION, "object",
    {JsonSchema(SettingNames::ALWAYS_RANDOM_INPUTS, "array"),
     JsonSchema(SettingNames::ALWAYS_RANDOM_INPUTS_BOTH_EDGES, "array"),
     JsonSchema(SettingNames::ALWAYS_RANDOM_INPUTS_FALLING_EDGE, "array"),
     JsonSchema(SettingNames::ALWAYS_RANDOM_INPUTS_RISING_EDGE, "array"),
     JsonSchema(SettingNames::END_CONDITION, "array",
                {JsonSchema("", "object",
                            {JsonSchema("name", "string"),
                             JsonSchema("value", "string")})}),
     JsonSchema(SettingNames::END_WAIT_CYCLES, "int"),
     JsonSchema(SettingNames::EXPECTED_OUTPUT, "array"),
     JsonSchema(SettingNames::FAULT_DETECTION_FLAGS, "array",
                {JsonSchema("", "object",
                            {JsonSchema("name", "string"),
                             JsonSchema("value", "string")})}),
     JsonSchema(SettingNames::GROUPS, "array"),
     JsonSchema(
         SettingNames::INPUT_SEQUENCE, "array",
         {JsonSchema(
             "", "object",
             {JsonSchema("hold_for_cycles", "int"),
              JsonSchema("signals", "array",
                         {JsonSchema("", "object",
                                     {JsonSchema("name", "string"),
                                      JsonSchema("type", "string"),
                                      JsonSchema("value", "string")})})})}),
     JsonSchema(SettingNames::NUMBER_OF_CLOCK_CYCLES, "int"),
     JsonSchema(SettingNames::NUMBER_OF_SIMULATIONS, "int"),
     JsonSchema(SettingNames::NUMBER_OF_SIMULATIONS_PER_STEP, "int"),
     JsonSchema(SettingNames::NUMBER_OF_SIMULATIONS_PER_WRITE, "int"),
     JsonSchema(SettingNames::OUTPUT_SHARES, "array"),
     JsonSchema(SettingNames::WAVEFORM_SIMULATION, "bool")});

JsonSchema software_schema(SettingNames::SOFTWARE, "object",
                           {JsonSchema(SettingNames::COMPILER_FLAGS, "string"),
                            JsonSchema(SettingNames::LOCATION_OF_CIPHER,
                                       "string"),
                            JsonSchema(SettingNames::PIPELINE_STAGES, "int")});

JsonSchema settings_schema(
    "", "object",
    {JsonSchema(SettingNames::ANALYSIS_STRATEGY, "string"),
     fault_injection_schema, hardware_schema, input_finite_field_schema,
     output_finite_field_schema, performance_schema,
     side_channel_analysis_schema, simulation_schema, software_schema});