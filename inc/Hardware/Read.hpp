#pragma once

#include <iostream>
#include <climits>
#include <cstring>
#include <stdexcept>
#include <sys/stat.h>
#include <omp.h>

#include "Hardware/Definitions.hpp"
#include "Util/CpuCoreSelector.hpp"

namespace Hardware
{
    namespace Read
    {
        void NonCommentFromFile(FILE*, char*, const char*);
        void fReadaWord(Hardware::FileBufferStruct*, char*, char*);
        int  MakeFormulaForCellInLibrary(Hardware::CellTypeStruct*);
        void LibraryFile(char*, char*, Hardware::LibraryStruct*);
        int  TrimSignalName(char*, int*);
        int  SearchSignalName(CircuitStruct*, char*, char, Hardware::SettingsStruct*);
        void DesignFile_Find_IO_Port(char*, char, int, int, Hardware::LibraryStruct*, Hardware::CircuitStruct*, int, char*, Hardware::CircuitStruct*, int*&, int&, int*&, int&);
        void DesignFile_Find_Signal_Name(char*, char, int, int, Hardware::SettingsStruct*, Hardware::LibraryStruct*, CircuitStruct*, int, int, int, char*, Hardware::CircuitStruct*, int*&, int&, int*&, int&, int&);
        void DesignFile(char*, char*, Hardware::SettingsStruct*, Hardware::LibraryStruct*, Hardware::CircuitStruct*, int, int, int, Hardware::FileBufferStruct*);
        void SettingsFile_BeforeDesign(char*, Hardware::SettingsStruct*);
        void SettingsFile(char*, Hardware::CircuitStruct*, Hardware::SettingsStruct*);
    }
}