#pragma once

#include "Software/Definitions.hpp"
#include <cstring>
#include <Python.h>
#include <string>
#include <iostream>
#include <fstream>
#include <stdlib.h>
#include <sstream>

namespace Software{
    namespace Read{
        void sort(char**, int);
        void SettingsFile(char* , Software::SettingsStruct*, Software::ConfigProbesStruct*, bool);
        void BinaryFile(char* , Software::SettingsStruct*, char*);
        int ProbeCompare(const void* , const void* );
        std::vector<uint8_t> read_file(const std::string&);
        void StrReplaceChar(char *Str, char ch_source, char ch_destination);
        void ReadNonCommentFromFile(FILE *FileHeader, char *Str, const char *CommentSyntax);
    }
}