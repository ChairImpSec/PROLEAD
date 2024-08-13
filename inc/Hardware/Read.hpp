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

namespace Hardware
{
    namespace Read
    {
        void NonCommentFromFile(FILE*, char*, const char*);
        void fReadaWord(Hardware::FileBufferStruct*, char*, char*);
        int  MakeFormulaForCellInLibrary(Hardware::CellTypeStruct*);
        int  TrimSignalName(char*, int*);
        int  SearchSignalName(CircuitStruct*, char*, char, Settings&);
        void DesignFile_Find_IO_Port(char*, char, int, int, Hardware::Library&, Hardware::CircuitStruct*, int, char*, Hardware::CircuitStruct*, int*&, int&, int*&, int&);
        void DesignFile_Find_Signal_Name(char*, char, int, int, Settings&, Hardware::Library&, CircuitStruct*, int, int, int, char*, Hardware::CircuitStruct*, int*&, int&, int*&, int&, int&);
        void DesignFile(const std::string&, const std::string&, Settings&, Hardware::Library&, Hardware::CircuitStruct*, int, int, int, Hardware::FileBufferStruct*);
    }
}