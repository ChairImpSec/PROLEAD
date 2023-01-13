#pragma once

#include <time.h>
#include <vector>
#include <cmath>
#include <numeric>

#include <boost/math/distributions/chi_squared.hpp>
#include <boost/math/distributions/inverse_chi_squared.hpp>
#include <boost/math/distributions/non_central_chi_squared.hpp>

namespace Util{
    struct TableEntryStruct{
        std::vector<unsigned char> Key;
        std::vector<unsigned int> Count;
        TableEntryStruct(unsigned int);
        TableEntryStruct(unsigned int, std::vector<unsigned char>&, unsigned int, unsigned int);
    };

    struct ContingencyTableStruct{
        std::vector<TableEntryStruct> Entries;
        std::vector<std::vector<std::vector<std::vector<unsigned char>>>> OnlyOneEntry; // [GroupIndex][ByteIndex][KeyIndex][KeyByteIndex]
        double Probability;
        unsigned int Traces;

        void CalculateTraces(int, double, double);
    };
    
    double GetGValue(unsigned int, unsigned int, ContingencyTableStruct&, std::vector<double>, unsigned int, unsigned int&);
    void GTest(unsigned int, unsigned int, ContingencyTableStruct&, std::vector<double>);

    void StartClock(timespec&);
    double EndClock(timespec&);
}
