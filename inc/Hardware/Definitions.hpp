#pragma once

#include <cinttypes>
#include <vector>
#include <bits/stdc++.h>

#define Max_Name_Length 10000

#define FullOne     0xffffffffffffffff
#define GroupInput  0x8000000000000000
#define GroupInMask 0xf000000000000000

#define CellType_Gate 0
#define CellType_Reg 1

#define Operation_AND 0
#define Operation_OR 1
#define Operation_XOR 2
#define Operation_NOT 3

#define SignalType_input 0
#define SignalType_output 1
#define SignalType_wire 2

#define Task_find_module_type 0
#define Task_find_module_name 1
#define Task_find_open_bracket 2
#define Task_find_point 3
#define Task_find_IO_port 4
#define Task_find_signal_name 5
#define Task_find_close_bracket 6
#define Task_find_comma 7
#define Task_find_assign_signal_name1 8
#define Task_find_equal 9
#define Task_find_assign_signal_name2 10

namespace Hardware
{
    struct OperationStruct
    {
        unsigned char NumberOfClauses;
        char *OperationOfClause;
        unsigned char *NumberOfOperandsInClause;
        unsigned char **OperandsInClause;
    };

    struct CellTypeStruct
    {
        char GateOrReg;
        unsigned char NumberOfCases;
        char **Cases;
        char NumberOfInputs;
        char **Inputs;
        char NumberOfOutputs;
        char **Outputs;
        char **Expresions;
        Hardware::OperationStruct *Operations;
        char Intermediate;
    };

    struct LibraryStruct
    {
        int              NumberOfCellTypes = 0;
        Hardware::CellTypeStruct** CellTypes = NULL;
        int              BufferCellType = -1;
    };

    struct CellStruct
    {
        int Type;
        char *Name;
        int Hierarchy;
        short Depth;
        char NumberOfInputs;
        int *Inputs;
        char NumberOfOutputs;
        int *Outputs;
        int *RegValueIndexes;
        char Deleted;
    };

    struct SignalStruct
    {
        char* Name;
        char  Type;
        short Depth;
        int   Output;
        int   NumberOfInputs;
        int*  Inputs;
        char  ProbeAllowed;
        char  Deleted;
    };

    struct CircuitStruct
    {
        Hardware::SignalStruct** Signals = NULL;
        int            NumberOfSignals = 0;
        int*           Inputs = NULL;
        int*           Outputs = NULL;
        int            NumberOfInputs = 0;
        int            NumberOfOutputs = 0;
        int            NumberOfConstants = 0;

        Hardware::CellStruct**   Cells = NULL;
        int            NumberOfCells = 0;
        int*           Gates = NULL;
        int*           Regs = NULL;
        int            NumberOfGates = 0;
        int            NumberOfRegs = 0;
        int            NumberOfRegValues = 0;

        short          MaxDepth = 0;
        int**          CellsInDepth = NULL;
        int*           NumberOfCellsInDepth = NULL;
    };

    struct SettingsStruct
    {
        int        Max_no_of_Threads;

        int        NumberOfGroups;
        int        NumberOfGroupValues;
        char       CompactDistributions;
        char       MinimizeProbeSets;
        char       RemoveProbingSets;
        int        NumberOfProbeSteps;
        int**      Group_Values = NULL;
        int*       MaxNumberOfSharesGroupValues;

        int        ClockSignal;
        int        Max_No_ClockCycles = 0;
        int        Max_No_ReportEntries;

        int        NumberOfAlwaysRandomInputs;
        int*       AlwaysRandomInputs = NULL;

        int        InitialSim_NumberOfInputs;
        int        InitialSim_NumberOfClockCycles;
        int**      InitialSim_Inputs = NULL;
        uint64_t** InitialSim_Values = NULL;

        int        EndSimCondition_ClockCycles;
        int        EndSimCondition_NumberOfSignals;
        int*       EndSimCondition_Signals = NULL;
        uint64_t*  EndSimCondition_Values = NULL;
        int        EndSim_NumberOfWaitCycles = 0;

		int        NumberOfOutputShares = 0;
		int        NumberOfOutputSignals = 0;
		int**      OutputSignals = NULL;
		int**      ExpectedOutputValues = NULL;

        int        TestOrder = 0;
        int        TestMultivariate = 0;
        int        MaxDistanceMultivariet = 0;
        int        TestTransitional = 0;
        int        NumberOfTestClockCycles = 0;
        int*       TestClockCycles = NULL;
        uint64_t   NumberOfSimulations = 0;
        uint64_t   NumberOfStepSimulations = 0;
        uint64_t   NumberOfStepSimulationsToWrite = 0;

        // By default, we set the allowed false-positive probability to 10^-5
        // If necessary, please change the false-positive probability here.
        // Important: Give probability as negative logarithmic value 
        double AlphaThreshold = 5.0;

        // By default, we set the allowed false-negative probability to 10^-5
        // If necessary, please change the false-negative probability here.
        double BetaThreshold = 0.00001;

        // In statistics an effect size of 0.1 is denoted as a "small effect size"
        double EffectSize;
    };

    struct GlitchExtendedProbesStruct
    {
        int        NumberOfProbes = 0;
        int*       Probes = NULL;
    };

    struct ProbesStruct
    {
        int        NumberOfProbes = 0;
        int*       Probes = NULL;
        char**     ProbeName = NULL;

        Hardware::GlitchExtendedProbesStruct* GlitchExtendedProbes = NULL;
    };  

    struct SharedDataStruct
    {
        uint64_t*   OneIn64 = NULL;
        uint64_t*   ZeroIn64 = NULL;
        uint64_t*   SignalValues = NULL;
        uint64_t*   RegValues = NULL;
        uint64_t**  GroupValues = NULL;
        uint64_t**  SelectedGroupValues = NULL;
    };  

    struct SimulationStruct
    {
        int        NumberOfGroups;
        char*      EvaluationResultFolderName = NULL;   // result_1000000.txt, result_2000000.txt, ...

        int        NumberOfProbes = 0; // 13
        char**     ProbeName = NULL;   //  Probe[0], Probe[1], ...
        Hardware::GlitchExtendedProbesStruct* GlitchExtendedProbes; // 13 times

        int        NumberOfAllGlitchExtendedProbes = 0;
        int*       SignalIndex_of_GlitchExtendedProbe = NULL;
        int*       GlitchExtendedProbeIndex_of_Signal = NULL;
        char**     GlitchExtendedProbeName = NULL;

        int        TestOrder = 0;
        int        TestMultivariate = 0;
        int        TestTransitional = 0;
        int        NumberOfTestClockCycles = 0;
        int*       TestClockCycles = NULL;

        int        NumberOfClockCycles = 0;
        uint64_t   NumberOfSimulations = 0;            // 100000000
        uint64_t   NumberOfStepSimulations = 0;        // 1000000
        uint64_t   NumberOfStepSimulationsToWrite = 0; // 5000000
        uint64_t   NumberOfProcessedSimulations = 0;
        int        StepSimulationIndex = 0;

        int*       SelectedGroups = NULL;   // NumberOfStepSimulations
        char***    ProbeValues;             // [0...NumberOfStepSimulations-1][0...NumberOfClockCycles-1][0...NumberOfAllGlitchExtendedProbes-1]
    };    

    struct TableEntryStruct
    {
        std::vector<unsigned char> Key;
	    std::vector<unsigned int> Count;
        TableEntryStruct(unsigned int);
        TableEntryStruct(Hardware::SimulationStruct&, std::vector<unsigned char>&, int, unsigned int);
    };

    struct ProbePositionStruct
    {
        unsigned int Probe;
        unsigned int Cycle;

        ProbePositionStruct();
        ProbePositionStruct(unsigned int, unsigned int);
    };

    struct ProbingSetStruct
    {
        std::vector<unsigned int> Standard;
        std::vector<unsigned int> Extension;
        std::vector<Hardware::TableEntryStruct> ContingencyTable;
        std::vector<std::vector<std::vector<std::vector<unsigned char>>>> OnlyOneEntry; // [GroupIndex][ByteIndex][KeyIndex][KeyByteIndex]
        double                           Probability;
        unsigned int                     Traces;

        ProbingSetStruct(unsigned int);
        ProbingSetStruct(std::vector<unsigned int>&);

        int FindEntry(Hardware::TableEntryStruct&, unsigned int);
    };

    struct UniqueProbeStruct
    {
        unsigned int  Probe = 0;
        unsigned int  Cycle = 0;
        unsigned int  NumberOfProbeSets = 0;
        unsigned int* ProbeSetIndexes = NULL;
    };

    struct TestStruct
    {
        std::vector<double>           SumOverGroup;
        std::vector<Hardware::ProbingSetStruct> ProbingSet;
        std::vector<std::vector<int>> TempProbeValue; // [NumberOfThreads][NumberOfSets]
        std::vector<std::vector<Hardware::TableEntryStruct>> TableEntries; // [NumberOfThreads][NumberOfStepSimulations]
        int				              NumberOfUniqueProbes = 0;
        Hardware::UniqueProbeStruct** UniqueProbe = NULL;

        std::vector<Hardware::ProbePositionStruct> StandardProbes;
        std::vector<Hardware::ProbePositionStruct> ExtendedProbes;

        TestStruct(Hardware::SimulationStruct&);
        int GetNumberOfStandardProbes(unsigned int);
        Hardware::ProbePositionStruct GetStandardProbe(unsigned int, unsigned int);
        Hardware::ProbePositionStruct GetExtendedProbe(unsigned int, unsigned int);
        Hardware::ProbePositionStruct GetStandardProbe(Hardware::ProbingSetStruct&, unsigned int);
        Hardware::ProbePositionStruct GetExtendedProbe(Hardware::ProbingSetStruct&, unsigned int);
    };
}