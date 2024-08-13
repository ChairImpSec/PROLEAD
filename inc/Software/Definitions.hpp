#pragma once
#include <stdint.h>
#include <vector>
#include <unordered_map>

#include "Software/mulator/types.h"
#include "Software/mulator/architectures.h"
#include "Util/Util.hpp"

#define Max_Num_Register 17
#define Max_Name_Length 10000

namespace Software{

	/**
	 * @brief Defines a probe that will be used in the preparation step
	 * 
	 */
	struct ConfigProbesStruct
	{
		int        NumberOfProbes = 0; ///< The number of probes.
		int*       Probes = NULL;	///< A list of probe indices.
		char**     ProbeName = NULL; ///< A list of probe names.
	};

	/**
	 * @brief Defines all settings regarding software simulations.
	 * 
	 */
    struct SettingsStruct
    {
        int        Max_no_of_Threads; ///< The maximum number of threads PROLEAD can use for parallelism.
        int        NumberOfGroups; ///< The number of user-defined groups
        int        NumberOfGroupValues; ///< The size of the group values, i.e. their bit length.
        char       CompactDistributions; ///< Decision whether the evaluation should be performed in compact or normal mode.
        int**      Group_Values = NULL; ///< The values assigned to the user-defined groups
        int*       MaxNumberOfSharesGroupValues; ///< The number of shares per input bit.

        int 	   Hardware = 0; ///< Decistion whether PROLEAD will be used for software or hardware

        int        ClockSignal = 0; ///< The index of the clock signal.
        int        Max_No_ClockCycles = 0; ///< The maximum number of clock cycles to simulate.
        int        Max_No_ReportEntries; ///< The maximum number of entries in the report.

        int        InitialSim_NumberOfInputs; ///< The number of inputs which are assigned to initialize the simulation. Bsp 2
        int**      InitialSim_Inputs = NULL; ///< The indices of the initialization signals. 
        char**	   InitialSim_InputName = NULL; ///< A list of input names to create a link for the emulator.
        std::unordered_map<std::string, uint32_t> InitialSim_PositionInEmulatorRam; ///< 
        int* 	   InitialSim_InputsLength = NULL; // A list that contains the length of each input
        uint64_t** InitialSim_Values = NULL; ///< The signal values during the initialization cycles.
        uint8_t*   InitialSim_IsInitialized = NULL; //< List of identifiers if input is array or variable and if the input has a fixed value or not.

        int        EndSimCondition_ClockCycles; ///< The number of clock cycles after which the simulation terminates.
        int        EndSimCondition_NumberOfSignals; ///< The bit width of the signal which terminates the simulation.
        int*       EndSimCondition_Signals = NULL; ///< The indices of the single-bit signals terminating the simulation.
        uint64_t*  EndSimCondition_Values = NULL; ///< The values the signals have to reach to terminate the simulation.
        int        EndSim_NumberOfWaitCycles = 0; ///< Number of cycles to wait after each simulation.

        int        TestOrder = 0; ///< The security order to test.
        int        TestMultivariate = 0; ///< Decision whether univariate or multivariate adversaries should be considered.
        int        MaxDistanceMultivariet = 0; ///< The maximum distance in time, i.e. clock cycles, for multivariate adversaries.
        int        TestTransitional = 0; ///< Decision whether transitional leakage is included.
        int        NumberOfTestClockCycles = 0; ///< The number of clock cycles in which the adversary can place probes.
        int*       TestClockCycles = NULL; ///< The particular clock cycles the adversary can target.
        uint64_t   NumberOfSimulations = 0; ///< The total number of simulations.
        uint64_t   NumberOfStepSimulations = 0; ///< The number of simulations before the simulations are evaluated.
        uint64_t   NumberOfStepSimulationsToWrite = 0; ///< The number of simulations before a report is written.


		/**
		 * @brief Defines how the Emulator models the memory
		 * 
		 */
        struct MemoryRange
        {
            mulator::u32 offset;
            mulator::u32 size;
        };

		/**
		 * @brief Defines how the Emulator models the code section
		 * 
		 */
        struct CodeSection
        {
            std::string name; ///< each section consists of a corresponding name
            std::vector<mulator::u8> bytes; ///< each section contains 
            mulator::u32 offset;
        };


        mulator::Architecture arch; ///< ISA version of the binary
        MemoryRange flash;	///< Flash memory region for emulator
        MemoryRange ram; ///< RAM memory region for emulator
        mulator::u32 start_address; ///< address of cipher where PROLEAD starts to evaluate
        mulator::u32 main_address; ///< start address of main function
        std::vector<CodeSection> binary; //< A list that contains all information of the binary
        std::vector<mulator::u32> halt_addresses;
        std::vector<mulator::u32> symbol_addresses;
        std::unordered_map<mulator::u32, std::string> symbol_names;
        mulator::u32 length_occupied_ram;
        mulator::u32 randomness_start_addr; ///< start address of emulator internal randomness section
        mulator::u32 randomness_end_addr; ///< end address of emulator internal randomness section
        mulator::u32 randomness_segment_length; ///<length  of emulator internal randomness section
        mulator::u32 num_threads;

		uint32_t NumberOfPipelineStages; ///< number of pipeline stages provided by the user
		std::string funcContainingCipher; ///< name of function containing cipher to search in disassembled file
		std::string compilerFlags; ///< compiler flags that will be parsed to tell the compiler how to compile
		std::vector<std::string> externalBinaryInformation; ///< contains path to binary, disassembled file and .map file in case of directly provided binary
		std::string externalMake; //< Decision if the binary is directly provided or needs to be generated by PROLEAD

		// By default, we set the allowed false-negative probability to 10^-5
		// If necessary, please change the false-negative probability here.
		double BetaThreshold = 0.00001;

		// In statistics an effect size of 0.1 is denoted as a "small effect size"
		double EffectSize = 0.1;

    };

    struct ExtendedProbesStruct
    {
        uint8_t RegisterNumber;
        uint8_t RegisterBit;
        uint32_t ClockCycle;
        uint8_t ProbeValue;
        ExtendedProbesStruct(uint8_t RegNr, uint8_t RegBit, uint32_t Clk, uint8_t Val);
    };

	/**
	 * @brief Defines how every probe during simulation looks like
	 * 
	 */
	struct ProbesStruct
	{

		uint64_t 							TransitionCycles; ///< Contains previous cycle where probed register was used last
		uint64_t							ProbeInfo;		 ///< Uniquly identifies a probe, (Cycle | Dependency | ID | RegNr1 | RegNr2 | Bit | ExtensionSize)			
		uint64_t							SpecialInfo;	///< Contains information that might change depending on type of probe
	};

	/**
	 * @brief Defines a struct that tracks metadata during the simulation
	 * 
	 */
	struct ProbeTrackingStruct{
		std::vector<uint32_t> RegisterLatestValue;	///< List of previous values for each register 
		std::vector<uint32_t> RegisterLatestClockCycle; ///< List of cycles where each register was used last
		uint32_t MemoryLatestClockCycle = 0; ///< Cycle that last used a memory instruction
		uint32_t LoadMemoryLatestClockCycle = 0; ///< Cycle that last used a load memory instruction
		uint32_t StoreMemoryLatestClockCycle = 0; ///< Cycle that last used a store memory instruction
		std::vector<uint32_t> VerticalLatestClockCycle;
		ProbeTrackingStruct();
	};


	/**
	 * @brief Defines a struct that tracks necessary information for simulation
	 * 
	 */
	struct SimulationStruct
	{
		int        NumberOfGroups; ///< The number of user-defined groups.
		char*      EvaluationResultFolderName = NULL;   ///< Name and path of the generated reports.

		int        NumberOfProbes = 0; ///< The total number of standard probes. 
		int        TestOrder = 0; ///< The security order to test.
		int        TestMultivariate = 0; ///< Decision regarding univariate and multivariate attackers.
		int        TestTransitional = 0; ///< Decision regarding transitional leakage.
		int        NumberOfTestClockCycles = 0; ///< Number of clock cycles in which standard probes can record
		std::vector<int> TestClockCycles; ///< List that contains the index of every clock cycle that should be tested

		uint64_t   NumberOfProcessedSimulations = 0;  ///< The number of currently processed simulations.
		int        StepSimulationIndex = 0;

	};


	/**
	 * @brief Defines a struct that tracks necessary information for thread simulation
	 * 
	 */
	struct ThreadSimulationStruct{
		uint32_t NumberOfGroups; ///< The number of user-defined groups.
		uint32_t GlobalCycleStart = 0; ///<
		uint32_t GlobalCycleEnd = 0; ///< 
		std::vector<uint32_t> CycleStart; ///<
		std::vector<uint32_t> CycleEnd; ///<
		uint32_t NumberOfStepSimulations; ///< The number of simulations before the simulations are evaluated.
		uint32_t NumberOfCycleSplits = 0; ///<
		std::vector<int> SelectedGroups;  ///< // [0...NumberOfStepSimulations-1]
		std::vector<std::vector<::Software::ProbesStruct>> StandardProbesPerSimulation; //[simulation], [number of probes]
		std::vector<int> TestClockCycles; ///< //assign only needed TestClockCycles for specific thread to vector
		int TestTransitional = 0; ///< Decision regarding transitional leakage.
		int TestMultivariate = 0; ///< Decision regarding univariate and multivariate attackers.
		int TestOrder = 0; ///< The security order to test.
		uint32_t NumberOfTestClockCycles = 0; ///< Number of clock cycles in which standard probes can record
		std::string EvaluationResultFolderName; ///< Name and path of the generated reports.
		std::vector<std::vector<uint32_t>> StartRAM_EndRAM_EmulatorInputs; //[#inputs][start addr in ram, end addr in ram]

        // By default, we set the allowed false-positive probability to 10^-5
        // If necessary, please change the false-positive probability here.
        // Important: Give probability as negative logarithmic value
        double AlphaThreshold = 5.0;

        // By default, we set the allowed false-negative probability to 10^-5
        // If necessary, please change the false-negative probability here.
        double BetaThreshold = 0.00001;
        double EffectSize = 0.1;
	};

	/**
	 * @brief Defines a struct that track meta information for probes
	 * 
	 */
	struct HelperStruct
	{
		std::vector<std::vector<uint8_t>> 						NormalProbesIncluded; ///< stores bit position of every register that will be probed
		std::vector<std::vector<uint8_t>> 						HorizontalBitsIncluded; ///< Store the probes which are not excluded in a horizontal probe
		std::vector<std::vector<std::tuple<uint8_t, uint8_t>>> 	VerticalProbesIncluded; ///< Store the probes which are not excluded in a vertical probe
		std::vector<std::vector<uint8_t>>					 	FullVerticalProbesIncluded; ///< [32][] one vertical probe contains included register of i-th bit
		std::vector<uint8_t>									MemoryProbesIncluded; ///< stores bit position of a memory word that will be probed
		std::vector<uint8_t>									MemoryShadowRegisterProbesIncluded; ///< stores bit position of the shadow memory register that will be probed
		std::vector<std::vector<uint8_t>>						PipelineForwardingProbesIncluded; ///< [32][] one pipeline probe contains included register of i-th bit with a depth of #PipelineSize
		std::vector<std::vector<uint8_t>>						FULLHRProbesIncluded; ///< Store the probes which are not excluded in a horizontal probe

		bool 													ProbeMemory; ///< Decision if memory should be probed
		bool 													ProbeMemoryShadowRegister; ///< Decision if memory shadow register should be probed
		bool													ProbeFullHorizontal; ///< Decision if full horizontal should be probed
		bool													ProbeFullVertical; ///< Decision if full vertical should be probed
		bool													ProbePipelineForwarding; ///< Decision if pipeline forwarding should be probed


		std::vector<bool> 										HorizontalProbesExcluded; ///< Decision which bits should be probed in a horizontal probe

		std::vector<std::vector<uint32_t>>						VerticalProbesSize; ///< Contains probe size of each register for vertical probe
		std::vector<std::vector<uint32_t>>						FullHorizontalProbesSize; ///< Contains probe size of each register for full horizontal probe
		uint32_t												FullVerticalProbesSize;	///< Contains probe size of full vertical probe
		uint32_t												PipelineForwardingProbesSize; 	///< Contains probe size of pipeline forwarding probe	


		std::vector<uint8_t>									FullVerticalRelevantBits;
		std::vector<uint8_t>									PipelineForwardingRelevantBits;

		HelperStruct();
	};

	/**
	* @brief Defines the shared state of a simulation.
	* 
	*/
	struct SharedDataStruct
	{
		std::vector<uint32_t> 	BytelengthOfParams; ///< length of shared data in bytes
		std::vector<std::vector<uint8_t>> 	ByteValuesOfParams; ///< values of shared data in byte size
		std::vector<uint8_t>	VariableOrArrayParams; //if variable -> input written into register, else written into memory with register containing memory address
		std::vector<uint32_t> 	StartaddrInRAM; ///< address of shared data in RAM
	};

	/**
	* Stores all information belonging to a probing set, i.e. the indices of all involved probes and the contingency table.
	*
	* @brief Defines a probing set.
	* 
	*/
	struct ProbingSetStruct
	{
		int 										NumberOfProbesInSet = 0;
		std::vector<::Software::ProbesStruct> 		StandardProbe;  ///< The standard probes placed by an adversary.
        ContingencyTable<TableBucketVector>			contingency_table_; ///< The contingency table storing the occurences of values probed by the extended probes.
		
		ProbingSetStruct(std::vector<::Software::ProbesStruct>& Probe);
		ProbingSetStruct(::Software::ProbesStruct& Probe);
		ProbingSetStruct(uint32_t TestOrder);
	};

	/**
	* @brief Defines all settings belonging to the test prodecure.
	* 
	*/
	struct TestStruct
	{
		std::vector<::Software::ProbesStruct> 					Combination;
		std::vector<bool>										CombinationBitmask;
		std::vector<::Software::ProbingSetStruct> 				GlobalProbingSets;
		std::vector<uint32_t> 	  								NumberOfSets; //[NumberOfStepSimulation]
		std::vector<std::vector<::Software::ProbingSetStruct>>	ProbingSet; //[NumberOfStepSimulation][]

		void Reset();
	};

}
//***************************************************************************************

void FreeAllocatedMemory(Software::SharedDataStruct* SharedData, Software::SettingsStruct* Settings, ::Software::SimulationStruct* Simulation, Software::ProbesStruct* Probes);
