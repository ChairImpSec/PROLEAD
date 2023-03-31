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

	struct ConfigProbesStruct
	{
		int        NumberOfProbes = 0;
		int*       Probes = NULL;
		char**     ProbeName = NULL;
	};

    struct SettingsStruct
    {
        int        Max_no_of_Threads;
        int        NumberOfGroups;
        int        NumberOfGroupValues;
        char       CompactDistributions;
        char       MinimizeProbeSets;
        int**      Group_Values = NULL;
        int*       MaxNumberOfSharesGroupValues;

        int 	   Hardware = 0;

        int        ClockSignal = 0;
        int        Max_No_ClockCycles = 0;
        int        Max_No_ReportEntries;

        int        NumberOfAlwaysRandomInputs;
        int*       AlwaysRandomInputs = NULL;

        int        InitialSim_NumberOfInputs;
        int        InitialSim_NumberOfClockCycles;
        int**      InitialSim_Inputs = NULL;
        char**	   InitialSim_InputName = NULL;
        std::unordered_map<std::string, uint32_t> InitialSim_PositionInEmulatorRam;
        int* 	   InitialSim_InputsLength = NULL;
        uint64_t** InitialSim_Values = NULL;
        uint8_t*   InitialSim_IsInitialized = NULL;

        int        EndSimCondition_ClockCycles;
        int        EndSimCondition_NumberOfSignals;
        int*       EndSimCondition_Signals = NULL;
        uint64_t*  EndSimCondition_Values = NULL;
        int        EndSim_NumberOfWaitCycles = 0;

        int        TestOrder = 0;
        int        TestMultivariate = 0;
        int        MaxDistanceMultivariet = 0;
        int        TestTransitional = 0;
        int        NumberOfTestClockCycles = 0;
        int*       TestClockCycles = NULL;
        uint64_t   NumberOfSimulations = 0;
        uint64_t   NumberOfStepSimulations = 0;
        uint64_t   NumberOfStepSimulationsToWrite = 0;


        struct MemoryRange
        {
            mulator::u32 offset;
            mulator::u32 size;
        };

        struct CodeSection
        {
            std::string name;
            std::vector<mulator::u8> bytes;
            mulator::u32 offset;
        };


        mulator::Architecture arch;
        MemoryRange flash;
        MemoryRange ram;
        mulator::u32 start_address;
        mulator::u32 main_address;
        std::vector<CodeSection> binary;
        std::vector<mulator::u32> halt_addresses;
        std::vector<mulator::u32> symbol_addresses;
        std::unordered_map<mulator::u32, std::string> symbol_names;
        mulator::u32 length_occupied_ram;
        mulator::u32 randomness_start_addr;
        mulator::u32 randomness_end_addr;
        mulator::u32 randomness_segment_length;
        mulator::u32 num_threads;

		uint32_t NumberOfPipelineStages;
		std::string funcContainingCipher; //name of function containing cipher to search in disassembled file
		std::string compilerFlags;
		std::vector<std::string> externalBinaryInformation;
		std::string externalMake;
    };

    struct ExtendedProbesStruct
    {
        uint8_t RegisterNumber;
        uint8_t RegisterBit;
        uint32_t ClockCycle;
        uint8_t ProbeValue;
        ExtendedProbesStruct(uint8_t RegNr, uint8_t RegBit, uint32_t Clk, uint8_t Val);
    };

	struct ProbesStruct
	{

		uint64_t 							TransitionCycles; 			//(OriginalRegister|PartnerRegister)
		uint64_t							ProbeInfo;					//(Cycle|Reg1|Id|Reg2)
		uint64_t							SpecialInfo;
	};

	struct ProbeTrackingStruct{
		std::vector<uint32_t> RegisterLatestValue;
		std::vector<uint32_t> RegisterLatestClockCycle; 
		uint32_t MemoryLatestClockCycle = 0;
		std::vector<uint32_t> VerticalLatestClockCycle;
		ProbeTrackingStruct();
	};


	struct SimulationStruct
	{
		int        NumberOfGroups;
		char*      EvaluationResultFolderName = NULL;   

		int        NumberOfProbes = 0; // 
		int        TestOrder = 0;
		int        TestMultivariate = 0;
		int        TestTransitional = 0;
		int        NumberOfTestClockCycles = 0;
		std::vector<int> TestClockCycles;

		uint64_t   NumberOfProcessedSimulations = 0;
		int        StepSimulationIndex = 0;

	};

	struct ThreadSimulationStruct{
		uint32_t NumberOfGroups;
		uint32_t GlobalCycleStart = 0;
		uint32_t GlobalCycleEnd = 0;
		std::vector<uint32_t> CycleStart;
		std::vector<uint32_t> CycleEnd;
		uint32_t NumberOfStepSimulations;
		uint32_t NumberOfCycleSplits = 0;
		std::vector<int> SelectedGroups;   // [0...NumberOfStepSimulations-1]
		std::vector<std::vector<::Software::ProbesStruct>> StandardProbesPerSimulation; //[simulation], [number of probes]
		std::vector<int> TestClockCycles; //assign only needed TestClockCycles for specific thread to vector
		int TestTransitional = 0;
		int TestMultivariate = 0;
		int TestOrder = 0;
		uint32_t NumberOfTestClockCycles = 0; 
		std::string EvaluationResultFolderName;
		std::vector<std::vector<uint32_t>> StartRAM_EndRAM_EmulatorInputs; //[#inputs][start addr in ram, end addr in ram]
        double AlphaThreshold = 5.0;
        double BetaThreshold = 0.00001;
        double EffectSize = 0.1;
	};

	struct HelperStruct
	{
		std::vector<std::vector<uint8_t>> 						NormalProbesIncluded; //[#NumberOfRegisters][#NumberOfBits; stores bit position of every register that was not excluded
		std::vector<std::vector<uint8_t>> 						HorizontalBitsIncluded; // Store the probes which are not excluded in a horizontal probe
		std::vector<std::vector<std::tuple<uint8_t, uint8_t>>> 	VerticalProbesIncluded;
		std::vector<std::vector<uint8_t>>					 	FullVerticalProbesIncluded; //[32][] one vertical probe contains included register of i-th bit
		std::vector<uint8_t>									MemoryProbesIncluded;
		std::vector<uint8_t>									MemoryShadowRegisterProbesIncluded;
		std::vector<std::vector<uint8_t>>						PipelineForwardingProbesIncluded; //[32][] one vertical probe contains included register of i-th bit
		std::vector<std::vector<uint8_t>>						FULLHRProbesIncluded;	

		bool 													ProbeMemory;
		bool 													ProbeMemoryShadowRegister;
		bool													ProbeFullHorizontal;
		bool													ProbeFullVertical;
		bool													ProbePipelineForwarding;


		std::vector<bool> 										HorizontalProbesExcluded; // [0, ..., NumberOfRegisters]

		std::vector<std::vector<uint32_t>>						VerticalProbesSize;
		std::vector<std::vector<uint32_t>>						FullHorizontalProbesSize;
		uint32_t												FullVerticalProbesSize;		
		uint32_t												PipelineForwardingProbesSize;		


		std::vector<uint8_t>									FullVerticalRelevantBits;
		std::vector<uint8_t>									PipelineForwardingRelevantBits;

		HelperStruct();
	};

	struct SharedDataStruct
	{
		std::vector<uint32_t> 	BytelengthOfParams;
		std::vector<std::vector<uint8_t>> 	ByteValuesOfParams;
		std::vector<uint8_t>	VariableOrArrayParams; //if variable -> input written into register, else written into memory with register containing memory address
		std::vector<uint32_t> 	StartaddrInRAM;
	};

	struct ProbingSetStruct
	{
		int 										NumberOfProbesInSet = 0; // weg
		std::vector<::Software::ProbesStruct> 		StandardProbe; // Evtl mit index statt der ganzen struct
        Util::ContingencyTableStruct ContingencyTable;
		
		ProbingSetStruct(std::vector<::Software::ProbesStruct>& Probe);
		ProbingSetStruct(::Software::ProbesStruct& Probe);
		ProbingSetStruct(uint32_t TestOrder);
	};

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
