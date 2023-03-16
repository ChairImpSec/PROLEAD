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
        char*      ModuleName;

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

        bool WaveformSimulation = false;
    };

	/**
	* @brief Defines an already extended probe, i.e. a set of glitch extended probes.
	* @author Amir Moradi
	*/
    struct GlitchExtendedProbesStruct
    {
        int        NumberOfProbes = 0; ///< The number of glitch-extended probes.
        int*       Probes = NULL; ///< A list of glitch-extended probes.
    };

	/**
	* @brief Defines a probing set, i.e. a set of standard probes with their corresponding glitch extensions.
	* @author Amir Moradi
	*/
    struct ProbesStruct
    {
        int        NumberOfProbes = 0; ///< The number of standard probes.
        int*       Probes = NULL; ///< A list of the standard probe indices.
        char**     ProbeName = NULL; ///< A list of the standard probe names.

        Hardware::GlitchExtendedProbesStruct* GlitchExtendedProbes = NULL; ///< A list of glitch-extensions per standard probe.
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

	/**
	* @brief Defines all settings regarding simulations.
	* @author Amir Moradi
	*/
    struct SimulationStruct
    {
        int        NumberOfGroups; ///< The number of user-defined groups.
        char*      EvaluationResultFolderName = NULL; ///< Name and path of the generated reports.

        int        NumberOfProbes = 0; ///< The total number of standard probes. 
        char**     ProbeName = NULL; ///< The names of the standard probes, i.e. the name of the probed wire.
        Hardware::GlitchExtendedProbesStruct* GlitchExtendedProbes; ///< The glitch-extended probes belonging to the standard probes.

        int        NumberOfAllGlitchExtendedProbes = 0; ///< The total number of glitch-extended probes.
        int*       SignalIndex_of_GlitchExtendedProbe = NULL;
        int*       GlitchExtendedProbeIndex_of_Signal = NULL;
        char**     GlitchExtendedProbeName = NULL; ///< The names of the glitch-extended probes, i.e. the name of the probed wire.

        int        TestOrder = 0; ///< The security order to test.
        int        TestMultivariate = 0; ///< Decision regarding univariate and multivariate attackers.
        int        TestTransitional = 0; ///< Decision regarding transitional leakage.
        int        NumberOfTestClockCycles = 0; ///< Number of clock cycles in which standard probes can record
        int*       TestClockCycles = NULL; ///< The list of clock cycles to test.

        int        NumberOfClockCycles = 0; ///< Number of clock cycles to simulate, i.e. the duration of one simulation.
        uint64_t   NumberOfSimulations = 0; ///< The total number of simulations.
        uint64_t   NumberOfStepSimulations = 0; ///< The number of simulations per step. After each step the contingency tables are updated.
        uint64_t   NumberOfStepSimulationsToWrite = 0; ///< The number of simulations after which reports are written.
        uint64_t   NumberOfProcessedSimulations = 0; ///< The number of currently processed simulations.

        int*       SelectedGroups = NULL; ///< The chosen group for each simulation.
        char***    ProbeValues; ///< The simulated states of all wires during different simulations and clock cycles.
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
		
    /** 
	* @brief Defines a unique probe for the compact mode.
	* @author Amir Moradi
	*/	
    struct UniqueProbeStruct
    {
        unsigned int  Probe = 0; ///< The position of a probe, i.e. the probed signal, given by the index of the signal.
        unsigned int  Cycle = 0; ///< The clock cycle in which the signal driven by a wire is recorded.
        unsigned int  NumberOfProbeSets = 0; ///< The number of probing sets in which this standard probe occurs.
        unsigned int* ProbeSetIndexes = NULL; ///< The indices of all probing sets in which this standard probe occurs.
    };

	/**
	* @brief Defines all settings belonging to the test prodecure.
	* @author Nicolai Müller
	*/
    struct TestStruct
    {
        std::vector<double>           SumOverGroup; ///< Stores the number of simulations per group.
        std::vector<Hardware::ProbingSetStruct> ProbingSet; ///< A list of all probing sets to evaluate.
        std::vector<std::vector<int>> TempProbeValue; ///< A list of table entries which will be added to the contingency tables in compact mode.
        std::vector<std::vector<Util::TableEntryStruct>> TableEntries; ///< A list of table entries which will be added to the contingency tables in normal mode.
        int				              NumberOfUniqueProbes = 0;
        Hardware::UniqueProbeStruct** UniqueProbe = NULL;

        std::vector<Hardware::ProbePositionStruct> StandardProbes; ///< A list of all standard probes. 
        std::vector<Hardware::ProbePositionStruct> ExtendedProbes; ///< A list of all glitch-extended probes.

		/**
		* @brief Initializes the test settings.
		* @param Simulation The simulation settings.
		* @author Nicolai Müller
		*/	
        TestStruct(Hardware::SimulationStruct&);

		/**
		* @brief Computes the number of standard probes in a probing set.
		* @param SetIndex The index of the probing set in the list.
        * @return The number of standard probes.
		* @author Nicolai Müller
		*/	
        int GetNumberOfStandardProbes(unsigned int);

		/**
		* @brief Gives a particular standard probe inside a probing set.
		* @param SetIndex The index of the probing set in the list.
		* @param ProbeIndex The index of the standard probe in the probing set.
        * @return The standard probe.
		* @author Nicolai Müller
		*/	
        Hardware::ProbePositionStruct GetStandardProbe(unsigned int, unsigned int);

		/**
		* @brief Gives a particular (glitch or transition)-extended probe inside a probing set.
		* @param SetIndex The index of the probing set in the list.
		* @param ProbeIndex The index of the (glitch or transition)-extended probe in the probing set.
        * @return The (glitch or transition)-extended probe.
		* @author Nicolai Müller
		*/	
        Hardware::ProbePositionStruct GetExtendedProbe(unsigned int, unsigned int);

		/**
		* @brief Gives a particular standard probe inside a probing set.
		* @param Ps The considered probing set.
		* @param ProbeIndex The index of the standard probe in the probing set.
        * @return The standard probe.
		* @author Nicolai Müller
		*/	
        Hardware::ProbePositionStruct GetStandardProbe(Hardware::ProbingSetStruct&, unsigned int);

		/**
		* @brief Gives a particular (glitch or transition)-extended probe inside a probing set.
		* @param Ps The considered probing set.
		* @param ProbeIndex The index of the (glitch or transition)-extended probe in the probing set.
        * @return The (glitch or transition)-extended probe.
		* @author Nicolai Müller
		*/
        Hardware::ProbePositionStruct GetExtendedProbe(Hardware::ProbingSetStruct&, unsigned int);
    };
}