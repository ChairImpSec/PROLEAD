/**
 * @file ProgramOptions.hpp
 * @author Nicolai Müller
 */
#pragma once
#define BOOST_BIND_GLOBAL_PLACEHOLDERS
#include <boost/filesystem.hpp>
#include <boost/json.hpp>
#include <boost/program_options.hpp>
#include <iostream>
#include <fstream>
#include <regex>
#include <string>

/**
 * @brief This class takes care of the command line options.
 */
class ProgramOptions {
 public:
  /**
   * @brief Constructs the ProgramOptions object and initializes the
   * command-line options.
   *
   * @details This constructor sets up the available command-line options for
   * the program using the Boost.Program_options library. It specifies default
   * values, descriptions, and validation functions for each option. Each option
   * can be provided via the command line, and the validation functions ensure
   * that the provided paths and formats are correct.
   */
  ProgramOptions();

  /**
   * @brief Parses command-line arguments and stores the values in a
   * variables_map.
   *
   * This function processes the command-line arguments using the
   * Boost.Program_options library. It parses the arguments, stores them in a
   * variables_map, and handles the "help" option by printing the help message
   * and exiting the program.
   *
   * @param argc The number of command-line arguments.
   * @param argv The array of command-line arguments.
   * @return A po::variables_map containing the parsed command-line options and
   * their values.
   *
   * @details This function performs the following steps:
   * - Parses the command-line arguments using `parse_command_line`.
   * - Stores the parsed arguments in the variables_map `vm`.
   * - Checks if the "help" option is present:
   *   - If "help" is present, it calls `PrintHelp()` to display the help
   * message and exits the program.
   *   - Otherwise, it calls `po::notify(vm)` to validate and apply the options.
   */
  boost::program_options::variables_map Parse(int argc, char* argv[]);

  void PrintHelp();

 private:
  constexpr static auto help_option_name = "help,h";
  constexpr static auto help_option_info = "prints the command list";
  constexpr static auto libraryfile_option_name = "libraryfile,l";
  constexpr static auto libraryfile_option_info =
      "specifies the path to the standard-cell library file (.json file)";
  constexpr static auto libraryfile_option_default = "library.json";
  constexpr static auto libraryname_option_name = "libraryname,n";
  constexpr static auto libraryname_option_info =
      "specifies the the standard-cell library name";
  constexpr static auto libraryname_option_default = "NANG45";
  constexpr static auto designfile_option_name = "designfile,d";
  constexpr static auto designfile_option_info =
      "specifies the path to the implementation file (either .v or .c file)";
  constexpr static auto designfile_option_default = "design.v";
  constexpr static auto modulename_option_name = "modulename,m";
  constexpr static auto modulename_option_info =
      "specifies the name of the top module";
  constexpr static auto modulename_option_default = "circuit";
  constexpr static auto configfile_option_name = "configfile,c";
  constexpr static auto configfile_option_info =
      "specifies the path to the configuration file (.json file)";
  constexpr static auto configfile_option_default = "config.json";
  constexpr static auto resultfolder_option_name = "resultfolder,r";
  constexpr static auto resultfolder_option_info =
      "specifies the path to the directory with results";
  constexpr static auto resultfolder_option_default = ".";
  constexpr static auto linkerfile_option_name = "linkerfile,k";
  constexpr static auto linkerfile_option_info =
      "specifies the path to the linker file (.ld file)";
  constexpr static auto linkerfile_option_default = "linker.ld";
  constexpr static auto platform_option_name = "platform,p";
  constexpr static auto platform_option_info =
      "switches between the hardware and software version of PROLEAD";
  constexpr static auto platform_option_default = "hardware";
  constexpr static auto binary_option_name = "binary,b";
  constexpr static auto binary_option_info =
      "specifies the path to the ARM binary (.elf file)";
  constexpr static auto binary_option_default = "binary.elf";
  constexpr static auto mapfile_option_name = "mapfile,f";
  constexpr static auto mapfile_option_info =
      "specifies the path to the map file (.map file)";
  constexpr static auto mapfile_option_default = "binary.map";
  constexpr static auto asmfile_option_name = "asmfile,a";
  constexpr static auto asmfile_option_info =
      "specifies the path to the disassembled file (.txt file)";
  constexpr static auto asmfile_option_default = "disassembled.txt";
  boost::program_options::options_description description;
};

/**
 * @brief Validates the content of a JSON file at the specified path.
 *
 * This function reads and parses the JSON file located at `path_to_json_file`
 * using the Boost.PropertyTree library. If the file cannot be parsed due to
 * a JSON parsing error, a po::validation_error is thrown with details of the
 * error.
 *
 * @param path_to_json_file The path to the JSON file to be validated.
 *
 * @throws po::validation_error if the JSON file cannot be parsed correctly,
 *         providing details of the error encountered during parsing.
 *
 * @details The function works as follows:
 * - Attempts to read and parse the JSON file into a Boost.PropertyTree ptree
 * object.
 * - If parsing fails due to a pt::json_parser_error, converts the error into
 *   a po::validation_error and throws it.
 */
boost::json::object ValidateJson(const std::string& path_to_json_file);

/**
 * @brief Validates that a file at the specified path has the expected file
 * ending.
 *
 * This function checks whether the file at `path_to_file` exists and is a
 * regular file. It then verifies if the file's extension matches the specified
 * `file_ending`. If any validation check fails, a po::validation_error is
 * thrown with details of the error.
 *
 * @param path_to_file The path to the file to be validated.
 * @param file_ending The expected file ending (including the dot), e.g., ".v"
 * for Verilog files.
 *
 * @throws po::validation_error if the file does not exist, is not a regular
 * file, or its extension does not match the expected `file_ending`.
 *
 * @details The function performs the following checks:
 * - Verifies the existence and regular file status of the file at
 * `path_to_file`.
 * - Checks if the file's extension matches `file_ending`.
 * - Throws a po::validation_error with appropriate messages if any validation
 * fails.
 */
void ValidateFileEnding(const std::string& path_to_file,
                        std::string file_ending);

/**
 * @brief Validates the existence of a directory at the specified path.
 *        If it does not exist, attempts to create the directory.
 *
 * This function checks whether the directory at `path_to_dir` exists.
 * If it exists but is not a directory, a po::validation_error is thrown
 * indicating that the path points to a regular file. If the directory
 * does not exist, it attempts to create it using
 * std::filesystem::create_directories.
 *
 * @param path_to_dir The path to the directory to be validated or created.
 *
 * @throws po::validation_error if the path points to a regular file or if
 *         there is an error during directory creation.
 *
 * @details The function operates as follows:
 * - Checks if the directory exists using std::filesystem::exists.
 * - If the path exists but is not a directory, throws a po::validation_error.
 * - If the directory does not exist, attempts to create it using
 *   std::filesystem::create_directories.
 * - Catches any std::filesystem::filesystem_error during directory creation
 *   and throws a po::validation_error with an appropriate error message.
 */
void ValidateDirectory(const std::string& path_to_dir);

/**
 * @brief Validates the platform specifier string.
 *
 * This function checks if the provided platform specifier `platform` matches
 * one of the valid options: "hardware", "hw", "software", or "sw"
 * (case-insensitive). If `platform` does not match any of these valid options,
 * a po::validation_error is thrown indicating that the platform specifier is
 * invalid.
 *
 * @param platform The platform specifier string to be validated.
 *
 * @throws po::validation_error if the platform specifier is not one of the
 * valid options: "hardware", "hw", "software", or "sw".
 *
 * @details The function performs the following checks:
 * - Compares the `platform` string against a set of valid options in a
 * case-insensitive manner.
 * - Throws a po::validation_error with an appropriate error message if
 * `platform` is not valid.
 */
void ValidatePlatform(const std::string& platform);
