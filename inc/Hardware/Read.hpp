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
        int MakeFormulaForCellInLibrary(Hardware::CellTypeStruct *);
        void LibraryFile(char *, char *, Hardware::LibraryStruct *);
        void DesignFile(char *, char *, Hardware::LibraryStruct *, Hardware::CircuitStruct *);
        void SettingsFile(char *, Hardware::CircuitStruct *, Hardware::SettingsStruct *);
    }
}