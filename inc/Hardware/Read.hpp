#pragma once

#include <iostream>
#include <climits>
#include <cstring>
#include <stdexcept>
#include <sys/stat.h>
#include <omp.h>

#include "Hardware/Definitions.hpp"
#include "Util/CpuCoreSelector.hpp"
#include "Util/Settings.hpp"
#include "Hardware/Circuit.hpp"

namespace Hardware
{
    namespace Read
    {
        void NonCommentFromFile(FILE*, char*, const char*);
        void fReadaWord(FileBufferStruct*, char*, char*);
        int  TrimSignalName(char*, int*);
        int  SearchSignalName(CircuitStruct*, char*, char, Settings&);
        void DesignFile_Find_IO_Port(char*, char, const Cell*, int, CircuitStruct*, int, char*, CircuitStruct*, int*&, int&, int*&, int&);
        void DesignFile_Find_Signal_Name(char*, char, const Cell*, int, Settings&, Library&, CircuitStruct*, int, int, int, char*, CircuitStruct*, int*&, int&, int*&, int&, int&);
        void DesignFile(const std::string&, const std::string&, Settings&, Library&, CircuitStruct*, int, int, int, FileBufferStruct*);
    }
}
