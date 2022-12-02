#pragma once

#include <iostream>
#include <climits>
#include <cstring>
#include <stdexcept>

#include "Hardware/Definitions.hpp"

namespace Hardware
{
    namespace Read
    {
        void NonCommentFromFile(FILE *, char *, const char *);
        void fReadaWord(FILE *, char *, char *);
        int  MakeFormulaForCellInLibrary(Hardware::CellTypeStruct *);
        void LibraryFile(char *, char *, Hardware::LibraryStruct *);
        int  TrimSignalName(char*, int*);
        void DesignFile_Find_IO_Port(char*, char, int, int, Hardware::LibraryStruct*, Hardware::CircuitStruct*, int, char*, Hardware::CircuitStruct*, int&, int&, int&, int&, int*&);
        void DesignFile_Find_Signal_Name(char*, char, int, Hardware::LibraryStruct*, CircuitStruct*, int, int, Hardware::CircuitStruct*, int, int, int, int, int*, int&);
        void DesignFile(char *, char *, Hardware::LibraryStruct *, Hardware::CircuitStruct *, int, int, int);
        void SettingsFile(char *, Hardware::CircuitStruct *, Hardware::SettingsStruct *);
    }
}