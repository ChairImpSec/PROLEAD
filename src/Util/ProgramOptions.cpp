#include "Util/ProgramOptions.hpp"

ProgramOptions::ProgramOptions() {
  description.add_options()(help_option_name, help_option_info)(
      libraryfile_option_name,
      boost::program_options::value<std::string>()
          ->default_value(libraryfile_option_default)
          ->notifier([](const std::string& path_to_file) {
            ValidateFileEnding(path_to_file, ".json");
          }),
      libraryfile_option_info)(
      libraryname_option_name,
      boost::program_options::value<std::string>()->default_value(
          libraryname_option_default),
      libraryname_option_info)(
      designfile_option_name,
      boost::program_options::value<std::vector<std::string>>()
          ->multitoken()
          ->default_value(std::vector<std::string>{designfile_option_default},
                          "")
          ->notifier([](const std::vector<std::string>& paths_to_files) {
            for (const auto& path_to_file : paths_to_files) {
              boost::filesystem::path file_path(path_to_file);
              if (file_path.extension() == ".c") {
                ValidateFileEnding(path_to_file, ".c");
              } else if (file_path.extension() == ".s") {
                ValidateFileEnding(path_to_file, ".s");
              } else if (file_path.extension() == ".S") {
                ValidateFileEnding(path_to_file, ".S");
              } else {
                ValidateFileEnding(path_to_file, ".v");
              }
            }
          }),
      designfile_option_info)(
      modulename_option_name,
      boost::program_options::value<std::string>()->default_value(
          modulename_option_default),
      modulename_option_info)(
      layoutfile_option_name,
      boost::program_options::value<std::string>()->notifier(
          [](const std::string& path_to_file) {
            ValidateFileEnding(path_to_file, ".gds");
          }),
      layoutfile_option_info)(
      configfile_option_name,
      boost::program_options::value<std::string>()
          ->default_value(configfile_option_default)
          ->notifier([](const std::string& path_to_file) {
            ValidateFileEnding(path_to_file, ".json");
          }),
      configfile_option_info)(
      resultfolder_option_name,
      boost::program_options::value<std::string>()
          ->default_value(resultfolder_option_default)
          ->notifier([](const std::string& path_to_file) {
            ValidateDirectory(path_to_file);
          }),
      resultfolder_option_info)(
      linkerfile_option_name,
      boost::program_options::value<std::string>()
          ->default_value(linkerfile_option_default)
          ->notifier([](const std::string& path_to_file) {
            ValidateFileEnding(path_to_file, ".ld");
          }),
      linkerfile_option_info)(
      binary_option_name,
      boost::program_options::value<std::string>()
          ->default_value(binary_option_default)
          ->notifier([](const std::string& path_to_file) {
            ValidateFileEnding(path_to_file, ".elf");
          }),
      binary_option_info)(mapfile_option_name,
                          boost::program_options::value<std::string>()
                              ->default_value(mapfile_option_default)
                              ->notifier([](const std::string& path_to_file) {
                                ValidateFileEnding(path_to_file, ".map");
                              }),
                          mapfile_option_info)(
      asmfile_option_name,
      boost::program_options::value<std::string>()
          ->default_value(asmfile_option_default)
          ->notifier([](const std::string& path_to_file) {
            ValidateFileEnding(path_to_file, ".txt");
          }),
      asmfile_option_info)(platform_option_name,
                           boost::program_options::value<std::string>()
                               ->default_value(platform_option_default)
                               ->notifier([](const std::string& platform) {
                                 ValidatePlatform(platform);
                               }),
                           platform_option_info);
}

boost::program_options::variables_map ProgramOptions::Parse(int argc,
                                                            char* argv[]) {
  boost::program_options::variables_map vm;
  boost::program_options::store(parse_command_line(argc, argv, description),
                                vm);

  if (vm.count("help")) {
    PrintHelp();
    exit(0);
  } else {
    boost::program_options::notify(vm);
  }

  return vm;
}

void ProgramOptions::PrintHelp() { std::cout << description << std::endl; }

boost::json::object ValidateJson(const std::string& path_to_json_file) {
  try {
    std::ifstream stream(path_to_json_file);
    if (!stream.is_open()) {
      throw std::runtime_error(
          "Error while opening the file located at path \"" +
          path_to_json_file + "\": File not found!");
    }

    std::string data{std::istreambuf_iterator<char>(stream),
                     std::istreambuf_iterator<char>()};
    std::string data_without_comments = std::regex_replace(
        data, std::regex(R"(//.*?$)", std::regex::multiline), "");
    data_without_comments = std::regex_replace(
        data_without_comments, std::regex(R"(/\*[\s\S]*?\*/)"), "");
    boost::json::value json_data = boost::json::parse(
        data_without_comments,
        boost::json::make_shared_resource<boost::json::monotonic_resource>());
    return json_data.as_object();
  } catch (const boost::system::system_error& e) {
    std::string error_message =
        "Error while parsing the JSON file located at path \"" +
        path_to_json_file + "\": ";
    throw std::runtime_error(error_message + e.what());
  }
}

void ValidateFileEnding(const std::string& path_to_file,
                        std::string file_ending) {
  boost::filesystem::path file_path(path_to_file);

  try {
    boost::filesystem::exists(file_path);
    boost::filesystem::is_regular_file(file_path);
  } catch (const boost::filesystem::filesystem_error& e) {
    throw boost::program_options::validation_error(
        boost::program_options::validation_error::invalid_option_value,
        e.what());
  }

  if (file_path.extension() != file_ending) {
    throw boost::program_options::validation_error(
        boost::program_options::validation_error::invalid_option_value,
        "Invalid file ending.");
  }
}

void ValidateDirectory(const std::string& path_to_dir) {
  boost::filesystem::path dir_path(path_to_dir);

  if (boost::filesystem::exists(dir_path)) {
    if (boost::filesystem::is_regular_file(dir_path)) {
      throw boost::program_options::validation_error(
          boost::program_options::validation_error::invalid_option_value,
          "Result folder path points to a file.");
    }
  } else {
    try {
      boost::filesystem::create_directories(dir_path);
    } catch (const boost::filesystem::filesystem_error& e) {
      throw boost::program_options::validation_error(
          boost::program_options::validation_error::invalid_option_value,
          "Error while creating the result folder: " + std::string(e.what()));
    }
  }
}

void ValidatePlatform(const std::string& platform) {
  if (platform != "hardware" && platform != "Hardware" && platform != "hw" &&
      platform != "Hw" && platform != "software" && platform != "Software" &&
      platform != "sw" && platform != "Sw") {
    throw boost::program_options::validation_error(
        boost::program_options::validation_error::invalid_option_value,
        "Platform specifier is invalid.");
  }
}
