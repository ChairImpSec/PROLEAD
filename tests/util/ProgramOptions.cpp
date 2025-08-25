#include "Util/ProgramOptions.hpp"

#include <boost/test/unit_test.hpp>

namespace utf = boost::unit_test;

BOOST_AUTO_TEST_SUITE(test_program_options)

BOOST_AUTO_TEST_CASE(test_no_options, *utf::label("program_options")) {
  ProgramOptions program_options;
  const char* argv[] = {"call"};
  int argc = sizeof(argv) / sizeof(argv[0]);

  boost::program_options::variables_map vm =
      program_options.Parse(argc, const_cast<char**>(argv));

  BOOST_CHECK(vm.count("help") == 0);
  BOOST_CHECK(vm["libraryfile"].as<std::string>() == "libs/nang45.json");
  BOOST_CHECK(vm["libraryname"].as<std::string>() == "nang45");
  BOOST_CHECK(vm["designfile"].as<std::vector<std::string>>() ==
              std::vector<std::string>{"design.v"});
  BOOST_CHECK(vm["modulename"].as<std::string>() == "circuit");
  BOOST_CHECK(vm["configfile"].as<std::string>() == "config.json");
  BOOST_CHECK(vm["resultfolder"].as<std::string>() == ".");
  BOOST_CHECK(vm["linkerfile"].as<std::string>() == "linker.ld");
  BOOST_CHECK(vm["binary"].as<std::string>() == "binary.elf");
  BOOST_CHECK(vm["mapfile"].as<std::string>() == "binary.map");
  BOOST_CHECK(vm["asmfile"].as<std::string>() == "disassembled.txt");
  BOOST_CHECK(vm["platform"].as<std::string>() == "hardware");
}

BOOST_AUTO_TEST_CASE(test_full_identifiers, *utf::label("program_options")) {
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

  BOOST_CHECK(vm.count("help") == 0);
  BOOST_CHECK(vm["libraryfile"].as<std::string>() == "library.json");
  BOOST_CHECK(vm["libraryname"].as<std::string>() == "custom_libraryname");
  BOOST_CHECK((vm["designfile"].as<std::vector<std::string>>() ==
               std::vector<std::string>{"custom_designfile1.v",
                                        "custom_designfile2.v"}));
  BOOST_CHECK(vm["modulename"].as<std::string>() == "custom_modulename");
  BOOST_CHECK(vm["configfile"].as<std::string>() == "config.json");
  BOOST_CHECK(vm["resultfolder"].as<std::string>() == "../util");
  BOOST_CHECK(vm["linkerfile"].as<std::string>() == "custom_linkerfile.ld");
  BOOST_CHECK(vm["binary"].as<std::string>() == "custom_binary.elf");
  BOOST_CHECK(vm["mapfile"].as<std::string>() == "custom_mapfile.map");
  BOOST_CHECK(vm["asmfile"].as<std::string>() == "custom_asmfile.txt");
  BOOST_CHECK(vm["platform"].as<std::string>() == "software");
}

BOOST_AUTO_TEST_CASE(test_abbreviations, *utf::label("program_options")) {
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

  BOOST_CHECK(vm.count("help") == 0);
  BOOST_CHECK(vm["libraryfile"].as<std::string>() == "library.json");
  BOOST_CHECK(vm["libraryname"].as<std::string>() == "custom_libraryname");
  BOOST_CHECK(vm["designfile"].as<std::vector<std::string>>() ==
              std::vector<std::string>{"custom_designfile.v"});
  BOOST_CHECK(vm["modulename"].as<std::string>() == "custom_modulename");
  BOOST_CHECK(vm["configfile"].as<std::string>() == "config.json");
  BOOST_CHECK(vm["resultfolder"].as<std::string>() == "../util");
  BOOST_CHECK(vm["linkerfile"].as<std::string>() == "custom_linkerfile.ld");
  BOOST_CHECK(vm["binary"].as<std::string>() == "custom_binary.elf");
  BOOST_CHECK(vm["mapfile"].as<std::string>() == "custom_mapfile.map");
  BOOST_CHECK(vm["asmfile"].as<std::string>() == "custom_asmfile.txt");
  BOOST_CHECK(vm["platform"].as<std::string>() == "software");
}

BOOST_AUTO_TEST_CASE(test_unknown_option, *utf::label("program_options")) {
  ProgramOptions program_options;
  const char* argv[] = {"call", "--unknown_option", "unknown_argument"};
  int argc = sizeof(argv) / sizeof(argv[0]);
  BOOST_CHECK_THROW(program_options.Parse(argc, const_cast<char**>(argv)),
                    boost::program_options::unknown_option);
}

BOOST_AUTO_TEST_CASE(test_duplicated_option, *utf::label("program_options")) {
  ProgramOptions program_options;
  const char* argv[] = {"call", "-designfile", "design.v", "-designfile",
                        "design.v"};
  int argc = sizeof(argv) / sizeof(argv[0]);
  BOOST_CHECK_THROW(program_options.Parse(argc, const_cast<char**>(argv)),
                    boost::program_options::error);
}

BOOST_AUTO_TEST_CASE(test_invalid_platform, *utf::label("program_options")) {
  ProgramOptions program_options;
  const char* argv[] = {"call", "--platform", "invalid_platform"};
  int argc = sizeof(argv) / sizeof(argv[0]);
  BOOST_CHECK_THROW(program_options.Parse(argc, const_cast<char**>(argv)),
                    boost::program_options::validation_error);
}

BOOST_AUTO_TEST_SUITE_END()
