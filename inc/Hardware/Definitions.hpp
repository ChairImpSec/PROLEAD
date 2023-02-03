#pragma once

#include <cinttypes>
#include <vector>
#include <bits/stdc++.h>
#include "Util/Util.hpp"

#define Max_Name_Length 10000

#define FullOne     0xffffffffffffffff
#define GroupInput  0x8000000000000000
#define RandomInput 0x4000000000000000
#define SameInput   0x2000000000000000
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
        unsigned int ProbeStepSize;
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
        uint64_t*   LastInitialSimValues = NULL;
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

	/**
	* @brief Defines a single probe.
	* @author Nicolai Müller
	*/
    struct ProbePositionStruct
    {
        unsigned int Probe; ///< The position of a probe, i.e. the probed signal, given by the index of the signal.
        unsigned int Cycle; ///< The clock cycle in which the signal driven by a wire is recorded.

		/**
		* The default constructor of a single probe.
		*
		* @brief Initializes a new probe. 
		* @author Nicolai Müller
		*/
        ProbePositionStruct();
		
		/**
		* @brief Initializes a single probe with a specific position and clock cycle.
		* @param p The probed wire index.
		* @param c The clock cycle to probe.
		* @author Nicolai Müller
		*/
        ProbePositionStruct(unsigned int, unsigned int);
    };

	/**
	* Stores all information belonging to a probing set, i.e. the indices of all involved probes and the contingency table.
	*
	* @brief Defines a probing set.
	* @author Nicolai Müller
	*/
    struct ProbingSetStruct
    {
        std::vector<unsigned int> Standard; ///< The standard probes placed by an adversary.
        std::vector<unsigned int> Extension; ///< The extensions of the standard probes, i.e. glitch- and transition-extended probes.
        Util::ContingencyTableStruct ContingencyTable; ///< The contingency table storing the occurences of values probed by the extended probes.

		/**
		* @brief Initializes a probing set with a single standard probe.
		* @param p The standard probe index.
		* @author Nicolai Müller
		*/
        ProbingSetStruct(unsigned int);
		
		/**
		* @brief Initializes a probing set with a list of standard probes.
		* @param Probe The list of standard probe indices.
		* @author Nicolai Müller
		*/		
        ProbingSetStruct(std::vector<unsigned int>&);
		
		/**
		* Checks if the probing set can theoretically contain all extended probes of a given probing set.
		* This leads to a higher efficiency as we can reject probing sets before comparing all extended probes.
		* This pre-checking step proves if all extended probes of the robing set to cover are in the range of the covering probing set.
		*
		* @brief Checks if the probing set covers another probing set.
		* @param ProbingSet The probing set that should be covered.
		* @author Nicolai Müller
		*/	
        bool Covers(Hardware::ProbingSetStruct&);
		
		/**
		* @brief Checks if the contingency table contains a particular entry.
		* @param Entry The contingency table entry to search.
		* @param IgnoredEntries Number of entries at the end of the contingency table to ignore during search.
		* @return The position of the entry in the table or -1 if the entry was not found.
		* @author Nicolai Müller
		*/			
        int FindEntry(Util::TableEntryStruct&, unsigned int);
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
        std::vector<std::vector<Util::TableEntryStruct>> TableEntries; // [NumberOfThreads][NumberOfStepSimulations]
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