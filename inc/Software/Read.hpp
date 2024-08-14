#pragma once

#include "Software/Definitions.hpp"
#include "Util/Settings.hpp"

#include <cstring>
#include <Python.h>
#include <string>
#include <iostream>
#include <fstream>
#include <stdlib.h>
#include <sstream>
#include <filesystem>
#include <boost/algorithm/string/classification.hpp>
#include <boost/algorithm/string/split.hpp>
#include <boost/process.hpp>
#include <boost/program_options.hpp>

namespace po = boost::program_options;

namespace Software{
    namespace Read{
        void sort(char**, int);
        void SettingsFile(Software::SettingsStruct&, Settings&, Software::ConfigProbesStruct&, bool);
        void BinaryFile(const po::variables_map& vm, Software::SettingsStruct&);
        int ProbeCompare(const void* , const void* );
        std::vector<uint8_t> read_file(const std::string&);
        void StrReplaceChar(char *Str, char ch_source, char ch_destination);
        void ReadNonCommentFromFile(FILE *FileHeader, char *Str, const char *CommentSyntax);
    }
}