#include "Util/ProgramOptions.hpp"

#include <catch2/catch.hpp>

TEST_CASE("Test ProgramOptions Parse function", "[ProgramOptions]") {
  SECTION("No command line options given.") {
    ProgramOptions program_options;
    const char* argv[] = {"call"};
    int argc = sizeof(argv) / sizeof(argv[0]);

    boost::program_options::variables_map vm =
        program_options.Parse(argc, const_cast<char**>(argv));

    REQUIRE_FALSE(vm.count("help"));
    REQUIRE(vm["libraryfile"].as<std::string>() == "library.json");
    REQUIRE(vm["libraryname"].as<std::string>() == "NANG45");
    REQUIRE(vm["designfile"].as<std::vector<std::string>>() ==
            std::vector<std::string>{"design.v"});
    REQUIRE(vm["modulename"].as<std::string>() == "circuit");
    REQUIRE(vm["configfile"].as<std::string>() == "config.json");
    REQUIRE(vm["resultfolder"].as<std::string>() == ".");
    REQUIRE(vm["linkerfile"].as<std::string>() == "linker.ld");
    REQUIRE(vm["binary"].as<std::string>() == "binary.elf");
    REQUIRE(vm["mapfile"].as<std::string>() == "binary.map");
    REQUIRE(vm["asmfile"].as<std::string>() == "disassembled.txt");
    REQUIRE(vm["platform"].as<std::string>() == "hardware");
  }

  SECTION("Custom command line options given by full option identifiers.") {
    ProgramOptions program_options;
    const char* argv[] = {"call",
                          "--libraryfile",
                          "library.json",
                          "--libraryname",
                          "custom_libraryname",
                          "--designfile",
                          "custom_designfile1.v",
                          "custom_designfile2.v",
                          "--modulename",
                          "custom_modulename",
                          "--configfile",
                          "config.json",
                          "--resultfolder",
                          "../util",
                          "--linkerfile",
                          "custom_linkerfile.ld",
                          "--binary",
                          "custom_binary.elf",
                          "--mapfile",
                          "custom_mapfile.map",
                          "--asmfile",
                          "custom_asmfile.txt",
                          "--platform",
                          "software"};
    int argc = sizeof(argv) / sizeof(argv[0]);

    boost::program_options::variables_map vm =
        program_options.Parse(argc, const_cast<char**>(argv));

    REQUIRE_FALSE(vm.count("help"));
    REQUIRE(vm["libraryfile"].as<std::string>() == "library.json");
    REQUIRE(vm["libraryname"].as<std::string>() == "custom_libraryname");
    REQUIRE(vm["designfile"].as<std::vector<std::string>>() ==
            std::vector<std::string>{"custom_designfile1.v",
                                     "custom_designfile2.v"});
    REQUIRE(vm["modulename"].as<std::string>() == "custom_modulename");
    REQUIRE(vm["configfile"].as<std::string>() == "config.json");
    REQUIRE(vm["resultfolder"].as<std::string>() == "../util");
    REQUIRE(vm["linkerfile"].as<std::string>() == "custom_linkerfile.ld");
    REQUIRE(vm["binary"].as<std::string>() == "custom_binary.elf");
    REQUIRE(vm["mapfile"].as<std::string>() == "custom_mapfile.map");
    REQUIRE(vm["asmfile"].as<std::string>() == "custom_asmfile.txt");
    REQUIRE(vm["platform"].as<std::string>() == "software");
  }

  SECTION("Custom command line options given by abbreviations.") {
    ProgramOptions program_options;
    const char* argv[] = {"call",
                          "-l",
                          "library.json",
                          "-n",
                          "custom_libraryname",
                          "-d",
                          "custom_designfile.v",
                          "-m",
                          "custom_modulename",
                          "-c",
                          "config.json",
                          "-r",
                          "../util",
                          "-k",
                          "custom_linkerfile.ld",
                          "-b",
                          "custom_binary.elf",
                          "-f",
                          "custom_mapfile.map",
                          "-a",
                          "custom_asmfile.txt",
                          "-p",
                          "software"};
    int argc = sizeof(argv) / sizeof(argv[0]);

    boost::program_options::variables_map vm =
        program_options.Parse(argc, const_cast<char**>(argv));

    REQUIRE_FALSE(vm.count("help"));
    REQUIRE(vm["libraryfile"].as<std::string>() == "library.json");
    REQUIRE(vm["libraryname"].as<std::string>() == "custom_libraryname");
    REQUIRE(vm["designfile"].as<std::vector<std::string>>() ==
            std::vector<std::string>{"custom_designfile.v"});
    REQUIRE(vm["modulename"].as<std::string>() == "custom_modulename");
    REQUIRE(vm["configfile"].as<std::string>() == "config.json");
    REQUIRE(vm["resultfolder"].as<std::string>() == "../util");
    REQUIRE(vm["linkerfile"].as<std::string>() == "custom_linkerfile.ld");
    REQUIRE(vm["binary"].as<std::string>() == "custom_binary.elf");
    REQUIRE(vm["mapfile"].as<std::string>() == "custom_mapfile.map");
    REQUIRE(vm["asmfile"].as<std::string>() == "custom_asmfile.txt");
    REQUIRE(vm["platform"].as<std::string>() == "software");
  }

  SECTION("Unknown option") {
    ProgramOptions program_options;
    const char* argv[] = {"call", "--unknown_option", "unknown_argument"};
    int argc = sizeof(argv) / sizeof(argv[0]);
    REQUIRE_THROWS_AS(program_options.Parse(argc, const_cast<char**>(argv)),
                      boost::program_options::unknown_option);
  }

  SECTION("Duplicated option") {
    ProgramOptions program_options;
    const char* argv[] = {"call", "-designfile", "design.v", "-designfile",
                          "design.v"};
    int argc = sizeof(argv) / sizeof(argv[0]);
    REQUIRE_THROWS_AS(program_options.Parse(argc, const_cast<char**>(argv)),
                      boost::program_options::error);
  }

  SECTION("Invalid platform option") {
    ProgramOptions program_options;
    const char* argv[] = {"call", "--platform", "invalid_platform"};
    int argc = sizeof(argv) / sizeof(argv[0]);
    REQUIRE_THROWS_AS(program_options.Parse(argc, const_cast<char**>(argv)),
                      boost::program_options::validation_error);
  }
}
