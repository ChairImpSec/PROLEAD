#include "Hardware/Prepare.hpp"

void Hardware::Prepare::MakeCircuitDepth(Hardware::LibraryStruct* Library, Hardware::CircuitStruct* Circuit)
{
    std::cout << "Make circuit depth..." << std::flush;
    int   i;
    int   OutputIndex;
    int   SignalIndex;
    int   GateIndex;
    int   RegIndex;
    int   CellIndex;
    short DepthIndex;
    char  all_have_depth;
    std::string ErrorMessage;

    for (DepthIndex = 1; DepthIndex <= Circuit->MaxDepth; DepthIndex++)
        free(Circuit->CellsInDepth[DepthIndex]);
    free(Circuit->CellsInDepth);
    free(Circuit->NumberOfCellsInDepth);

    for (GateIndex = 0; GateIndex < Circuit->NumberOfGates; GateIndex++)
    {
        CellIndex = Circuit->Gates[GateIndex];

        if (!Circuit->Cells[CellIndex]->Deleted)
            Circuit->Cells[CellIndex]->Depth = -1;
    }

    for (RegIndex = 0; RegIndex < Circuit->NumberOfRegs; RegIndex++)
    {
        CellIndex = Circuit->Regs[RegIndex];

        if (!Circuit->Cells[CellIndex]->Deleted)
            Circuit->Cells[CellIndex]->Depth = 0;
    }

    for (SignalIndex = 0; SignalIndex < Circuit->NumberOfSignals; SignalIndex++)
        if (!Circuit->Signals[SignalIndex]->Deleted)
        {
            if (Circuit->Signals[SignalIndex]->Output >= 0)
                Circuit->Signals[SignalIndex]->Depth = Circuit->Cells[Circuit->Signals[SignalIndex]->Output]->Depth;
            else
            {
                Circuit->Signals[SignalIndex]->Depth = 0;
            }
        }

    Circuit->MaxDepth = 0;

    do
    {
        all_have_depth = 1;

        for (CellIndex = 0; CellIndex < Circuit->NumberOfCells; CellIndex++)
            if (!Circuit->Cells[CellIndex]->Deleted)
                if (Library->CellTypes[Circuit->Cells[CellIndex]->Type]->GateOrReg == CellType_Gate)
                    if (Circuit->Cells[CellIndex]->Depth == -1)
                    {
                        all_have_depth = 0;
                        DepthIndex = 0;
                        for (i = 0; i < Circuit->Cells[CellIndex]->NumberOfInputs; i++)
                            if (Circuit->Signals[Circuit->Cells[CellIndex]->Inputs[i]]->Depth == -1)
                                break;
                            else if (DepthIndex < Circuit->Signals[Circuit->Cells[CellIndex]->Inputs[i]]->Depth)
                                DepthIndex = Circuit->Signals[Circuit->Cells[CellIndex]->Inputs[i]]->Depth;

                        if (i == Circuit->Cells[CellIndex]->NumberOfInputs) // all have depth
                        {
                            Circuit->Cells[CellIndex]->Depth = DepthIndex + 1;

                            for (OutputIndex = 0; OutputIndex < Circuit->Cells[CellIndex]->NumberOfOutputs; OutputIndex++)
                                if (Circuit->Cells[CellIndex]->Outputs[OutputIndex] != -1)
                                    Circuit->Signals[Circuit->Cells[CellIndex]->Outputs[OutputIndex]]->Depth = Circuit->Cells[CellIndex]->Depth;

                            if (Circuit->MaxDepth < Circuit->Cells[CellIndex]->Depth)
                                Circuit->MaxDepth = Circuit->Cells[CellIndex]->Depth;
                        }
                    }
    } while (!all_have_depth);

    Circuit->CellsInDepth = (int **)malloc((Circuit->MaxDepth + 1) * sizeof(int *));
    Circuit->NumberOfCellsInDepth = (int *)calloc(Circuit->MaxDepth + 1, sizeof(int));

    for (GateIndex = 0; GateIndex < Circuit->NumberOfGates; GateIndex++)
        if (!Circuit->Cells[Circuit->Gates[GateIndex]]->Deleted)
            Circuit->NumberOfCellsInDepth[Circuit->Cells[Circuit->Gates[GateIndex]]->Depth]++;

    for (DepthIndex = 0; DepthIndex <= Circuit->MaxDepth; DepthIndex++)
    {
        Circuit->CellsInDepth[DepthIndex] = (int *)malloc(Circuit->NumberOfCellsInDepth[DepthIndex] * sizeof(int));
        Circuit->NumberOfCellsInDepth[DepthIndex] = 0; // temporary to be used as index in the next loop
    }

    for (GateIndex = 0; GateIndex < Circuit->NumberOfGates; GateIndex++)
        if (!Circuit->Cells[Circuit->Gates[GateIndex]]->Deleted)
        {
            DepthIndex = Circuit->Cells[Circuit->Gates[GateIndex]]->Depth;
            Circuit->CellsInDepth[DepthIndex][Circuit->NumberOfCellsInDepth[DepthIndex]] = Circuit->Gates[GateIndex];
            Circuit->NumberOfCellsInDepth[DepthIndex]++;
        }

    for (SignalIndex = 0; SignalIndex < Circuit->NumberOfSignals; SignalIndex++)
        if (!Circuit->Signals[SignalIndex]->Deleted)
            if ((Circuit->Signals[SignalIndex]->Output != -1) && (Circuit->Signals[SignalIndex]->Depth == -1))
                break;

    if (SignalIndex < Circuit->NumberOfSignals)
    {
        printf("the depth of signal \"%s\" could not be identified\n", Circuit->Signals[SignalIndex]->Name);
        ErrorMessage = Circuit->Signals[SignalIndex]->Name;
        ErrorMessage = "The depth of signal \"" + ErrorMessage + "\" could not be identified!";
        throw std::runtime_error(ErrorMessage);
    }

    std::cout << "done!" << std::endl;
}

void Hardware::Prepare::ExtendProbe(LibraryStruct* Library, CircuitStruct* Circuit, SettingsStruct* Settings, int MainSignalIndex, int SignalIndex, int* Buffer_int, int* Check_int)
{
	int  InputIndex;

	if (SignalIndex >= 0)
		if ((!Circuit->Signals[SignalIndex]->Deleted) &&
			(SignalIndex != Settings->ClockSignal) &&
			(Check_int[SignalIndex] == 0))
		{
			Check_int[SignalIndex] = 1;

			if ((Circuit->Signals[SignalIndex]->Output == -1) ||
				(Library->CellTypes[Circuit->Cells[Circuit->Signals[SignalIndex]->Output]->Type]->GateOrReg == CellType_Reg))
			{
				if ((Circuit->Signals[SignalIndex]->ProbeAllowed) || (Circuit->Signals[MainSignalIndex]->ProbeAllowed == 2))
					Buffer_int[SignalIndex] = 1;
			}
			else
				if (!Circuit->Cells[Circuit->Signals[SignalIndex]->Output]->Deleted)
					for (InputIndex = 0;InputIndex < Circuit->Cells[Circuit->Signals[SignalIndex]->Output]->NumberOfInputs;InputIndex++)
						Hardware::Prepare::ExtendProbe(Library, Circuit, Settings, MainSignalIndex, Circuit->Cells[Circuit->Signals[SignalIndex]->Output]->Inputs[InputIndex], Buffer_int, Check_int);
		}
}

void Hardware::Prepare::Probes(Hardware::LibraryStruct* Library, Hardware::CircuitStruct* Circuit, Hardware::SettingsStruct* Settings, Hardware::ProbesStruct* Probes)
{
    std::cout << "Construct probes..." << std::flush;
	int     SignalIndex;
	int     InputIndex;
	int     ProbeIndex;
	int*    Buffer_int;
	int*    Check_int;
	int     NumberOfElements;
	int     i;

	free(Probes->Probes);
	Probes->Probes = NULL;
	Probes->NumberOfProbes = 0;

	// finding the probes at the input of registers or signals which are not connected to anywhere (but are primary output)
	for (SignalIndex = Circuit->NumberOfConstants;SignalIndex < Circuit->NumberOfSignals;SignalIndex++)
		if ((!Circuit->Signals[SignalIndex]->Deleted) && (Circuit->Signals[SignalIndex]->ProbeAllowed) && (SignalIndex != Settings->ClockSignal))
		{
			for (InputIndex = 0;InputIndex < Circuit->Signals[SignalIndex]->NumberOfInputs;InputIndex++)
				if (Library->CellTypes[Circuit->Cells[Circuit->Signals[SignalIndex]->Inputs[InputIndex]]->Type]->GateOrReg == CellType_Gate)
					break;

			if (InputIndex >= Circuit->Signals[SignalIndex]->NumberOfInputs)
			{
				Buffer_int = (int*)malloc((Probes->NumberOfProbes + 1) * sizeof(int));
				memcpy(Buffer_int, Probes->Probes, Probes->NumberOfProbes * sizeof(int));
				free(Probes->Probes);
				Probes->Probes = Buffer_int;
				Probes->Probes[Probes->NumberOfProbes] = SignalIndex;
				Probes->NumberOfProbes++;
			}
		}

	// extending the probes based on glitches
	free(Probes->GlitchExtendedProbes);
	Probes->GlitchExtendedProbes = (GlitchExtendedProbesStruct*)malloc(Probes->NumberOfProbes * sizeof(GlitchExtendedProbesStruct));

	Buffer_int = (int*)malloc(Circuit->NumberOfSignals * sizeof(int));
	Check_int = (int*)malloc(Circuit->NumberOfSignals * sizeof(int));

	for (ProbeIndex = 0;ProbeIndex < Probes->NumberOfProbes;ProbeIndex++)
	{
		memset(Buffer_int, 0, Circuit->NumberOfSignals * sizeof(int));
		memset(Check_int, 0, Circuit->NumberOfSignals * sizeof(int));
		Hardware::Prepare::ExtendProbe(Library, Circuit, Settings, Probes->Probes[ProbeIndex], Probes->Probes[ProbeIndex], Buffer_int, Check_int);

		NumberOfElements = 0;
		for (SignalIndex = 0;SignalIndex < Circuit->NumberOfSignals;SignalIndex++)
			if (Buffer_int[SignalIndex])
				NumberOfElements++;

		Probes->GlitchExtendedProbes[ProbeIndex].NumberOfProbes = NumberOfElements;
		Probes->GlitchExtendedProbes[ProbeIndex].Probes = (int*)malloc(NumberOfElements * sizeof(int));

		i = 0;
		for (SignalIndex = 0;SignalIndex < Circuit->NumberOfSignals;SignalIndex++)
			if (Buffer_int[SignalIndex])
			{
				Probes->GlitchExtendedProbes[ProbeIndex].Probes[i] = SignalIndex;
				i++;
			}
	}

	free(Buffer_int);

	// removing empty glitch-extended probes
	for (ProbeIndex = 0;ProbeIndex < Probes->NumberOfProbes;ProbeIndex++)
	{
		if (Probes->GlitchExtendedProbes[ProbeIndex].NumberOfProbes == 0)
		{
			memcpy(&Probes->Probes[ProbeIndex], &Probes->Probes[ProbeIndex + 1], (Probes->NumberOfProbes - ProbeIndex - 1) * sizeof(int));
			memcpy(&Probes->GlitchExtendedProbes[ProbeIndex], &Probes->GlitchExtendedProbes[ProbeIndex + 1], (Probes->NumberOfProbes - ProbeIndex - 1) * sizeof(GlitchExtendedProbesStruct));
			Probes->NumberOfProbes--;
			ProbeIndex--;
		}
	}

	std::cout << "done!" << std::endl;
}

void Hardware::Prepare::Simulation(CircuitStruct* Circuit, SettingsStruct* Settings, ProbesStruct* Probes, char* EvaluationResultFolderName, SimulationStruct* Simulation){
    std::cout << "Prepare simulation memory..." << std::flush;

	int      ProbeIndex;
	int      SignalIndex;
	int      ItemIndex;
	int      ClockCycle;
	uint64_t SimulationIndex;

	Simulation->EvaluationResultFolderName = (char*)malloc(Max_Name_Length);
	strncpy(Simulation->EvaluationResultFolderName, EvaluationResultFolderName, Max_Name_Length - 1);
	Simulation->EvaluationResultFolderName[Max_Name_Length - 1] = '\0';

	Simulation->NumberOfProbes = Probes->NumberOfProbes;
	Simulation->ProbeName = (char**)malloc(Probes->NumberOfProbes * sizeof(char*));

	Simulation->GlitchExtendedProbeIndex_of_Signal = (int*)malloc(Circuit->NumberOfSignals * sizeof(int));
	for (SignalIndex = 0;SignalIndex < Circuit->NumberOfSignals;SignalIndex++)
		Simulation->GlitchExtendedProbeIndex_of_Signal[SignalIndex] = -1;


	Simulation->NumberOfAllGlitchExtendedProbes = 0;
	for (ProbeIndex = 0;ProbeIndex < Probes->NumberOfProbes;ProbeIndex++)
	{
		Simulation->ProbeName[ProbeIndex] = (char*)malloc(Max_Name_Length);
		strncpy(Simulation->ProbeName[ProbeIndex], Circuit->Signals[Probes->Probes[ProbeIndex]]->Name, Max_Name_Length - 1);
		Simulation->ProbeName[ProbeIndex][Max_Name_Length - 1] = '\0';

		for (ItemIndex = 0;ItemIndex < Probes->GlitchExtendedProbes[ProbeIndex].NumberOfProbes;ItemIndex++)
			if (Simulation->GlitchExtendedProbeIndex_of_Signal[Probes->GlitchExtendedProbes[ProbeIndex].Probes[ItemIndex]] == -1)
			{
				Simulation->GlitchExtendedProbeIndex_of_Signal[Probes->GlitchExtendedProbes[ProbeIndex].Probes[ItemIndex]] = Simulation->NumberOfAllGlitchExtendedProbes;
				Simulation->NumberOfAllGlitchExtendedProbes++;
			}
	}

	Simulation->SignalIndex_of_GlitchExtendedProbe = (int*)malloc(Simulation->NumberOfAllGlitchExtendedProbes * sizeof(int));
	Simulation->GlitchExtendedProbeName = (char**)malloc(Simulation->NumberOfAllGlitchExtendedProbes * sizeof(char*));
	//ItemIndex = 0;
	for (SignalIndex = 0;SignalIndex < Circuit->NumberOfSignals;SignalIndex++)
		if (Simulation->GlitchExtendedProbeIndex_of_Signal[SignalIndex] != -1)
		{
			ItemIndex = Simulation->GlitchExtendedProbeIndex_of_Signal[SignalIndex];
			Simulation->SignalIndex_of_GlitchExtendedProbe[ItemIndex] = SignalIndex;
			Simulation->GlitchExtendedProbeName[ItemIndex] = (char*)malloc(Max_Name_Length);
			strncpy(Simulation->GlitchExtendedProbeName[ItemIndex], Circuit->Signals[SignalIndex]->Name, Max_Name_Length - 1);
			Simulation->GlitchExtendedProbeName[ItemIndex][Max_Name_Length - 1] = '\0';
			//ItemIndex++;
		}

	Simulation->GlitchExtendedProbes = (GlitchExtendedProbesStruct*)malloc(Probes->NumberOfProbes * sizeof(GlitchExtendedProbesStruct));
	for (ProbeIndex = 0;ProbeIndex < Probes->NumberOfProbes;ProbeIndex++)
	{
		Simulation->GlitchExtendedProbes[ProbeIndex].NumberOfProbes = Probes->GlitchExtendedProbes[ProbeIndex].NumberOfProbes;
		Simulation->GlitchExtendedProbes[ProbeIndex].Probes = (int*)malloc(Probes->GlitchExtendedProbes[ProbeIndex].NumberOfProbes * sizeof(int));
		for (ItemIndex = 0;ItemIndex < Probes->GlitchExtendedProbes[ProbeIndex].NumberOfProbes;ItemIndex++)
			Simulation->GlitchExtendedProbes[ProbeIndex].Probes[ItemIndex] = Simulation->GlitchExtendedProbeIndex_of_Signal[Probes->GlitchExtendedProbes[ProbeIndex].Probes[ItemIndex]];
	}

	//----------------------
	Simulation->NumberOfGroups = Settings->NumberOfGroups;
	Simulation->TestOrder = Settings->TestOrder;
	Simulation->TestMultivariate = Settings->TestMultivariate;
	Simulation->TestTransitional = Settings->TestTransitional;
	Simulation->NumberOfTestClockCycles = Settings->NumberOfTestClockCycles;
	Simulation->TestClockCycles = (int*)malloc(Settings->NumberOfTestClockCycles * sizeof(int));
	memcpy(Simulation->TestClockCycles, Settings->TestClockCycles, Settings->NumberOfTestClockCycles * sizeof(int));

	Simulation->NumberOfSimulations = Settings->NumberOfSimulations;
	Simulation->NumberOfStepSimulations = Settings->NumberOfStepSimulations;
	Simulation->NumberOfStepSimulationsToWrite = Settings->NumberOfStepSimulationsToWrite;

	Simulation->NumberOfClockCycles = Settings->Max_No_ClockCycles;
	if ((Settings->EndSimCondition_ClockCycles) &&
		((Settings->EndSimCondition_ClockCycles + 1 + Settings->EndSim_NumberOfWaitCycles) < Settings->Max_No_ClockCycles))
		Simulation->NumberOfClockCycles = Settings->EndSimCondition_ClockCycles + 1 + Settings->EndSim_NumberOfWaitCycles;

	Simulation->SelectedGroups = (int*)calloc(Simulation->NumberOfStepSimulations, sizeof(int));

	Simulation->ProbeValues = (char***)malloc(Simulation->NumberOfStepSimulations * sizeof(char**));
	for (SimulationIndex = 0;SimulationIndex < Simulation->NumberOfStepSimulations;SimulationIndex++)
	{
		Simulation->ProbeValues[SimulationIndex] = (char**)malloc(Simulation->NumberOfClockCycles * sizeof(char*));
		for (ClockCycle = 0;ClockCycle < Simulation->NumberOfClockCycles;ClockCycle++)
			Simulation->ProbeValues[SimulationIndex][ClockCycle] = (char*)calloc(Simulation->NumberOfAllGlitchExtendedProbes, sizeof(char));
	}

	std::cout << "done!" << std::endl;
}

//***************************************************************************************
void Hardware::Prepare::SharedData(CircuitStruct* Circuit, SettingsStruct* Settings, SharedDataStruct* SharedData)
{
	int i;

	SharedData->OneIn64  = (uint64_t*)malloc(64 * sizeof(uint64_t));
	SharedData->ZeroIn64 = (uint64_t*)malloc(64 * sizeof(uint64_t));

	SharedData->OneIn64[0] = 1;
	SharedData->ZeroIn64[0] = ~SharedData->OneIn64[0];
	for (i = 1; i < 64; i++)
	{
		SharedData->OneIn64[i] = SharedData->OneIn64[i - 1] << 1;
		SharedData->ZeroIn64[i] = ~SharedData->OneIn64[i];
	}

	//-----------------------

	SharedData->SignalValues = (uint64_t*)calloc(Circuit->NumberOfSignals, sizeof(uint64_t));
	SharedData->RegValues    = (uint64_t*)calloc(Circuit->NumberOfRegValues, sizeof(uint64_t));

	SharedData->SignalValues[1] = FullOne; // constant 1'b1
	SharedData->SignalValues[3] = FullOne; // constant 1'h1

	//-----------------------
	SharedData->GroupValues = (uint64_t**)malloc(Settings->NumberOfGroups * sizeof(uint64_t*));
	for (i = 0;i < Settings->NumberOfGroups;i++)
		SharedData->GroupValues[i] = (uint64_t*)calloc(Settings->NumberOfGroupValues, sizeof(uint64_t));

	SharedData->SelectedGroupValues = (uint64_t**)malloc(Settings->NumberOfGroupValues * sizeof(uint64_t*));
	for (i = 0;i < Settings->NumberOfGroupValues;i++)
		SharedData->SelectedGroupValues[i] = (uint64_t*)calloc(Settings->MaxNumberOfSharesGroupValues[i] + 1, sizeof(uint64_t));

	SharedData->LastInitialSimValues = (uint64_t*)calloc(Settings->InitialSim_NumberOfInputs, sizeof(uint64_t));
}

void Hardware::Prepare::All(const CommandLineParameterStruct& Parameter, Hardware::CircuitStruct& Circuit, Hardware::LibraryStruct& Library, Hardware::SettingsStruct& Settings, Hardware::ProbesStruct& Probes, Hardware::SimulationStruct& Simulation, Hardware::SharedDataStruct*& SharedData){
    // TODO: Replace c strings with std::string
    char LibraryFileName[Max_Name_Length];
    char LibraryName[Max_Name_Length];
    char DesignFileName[Max_Name_Length];
    char MainModuleName[Max_Name_Length];
    char SettingsFileName[Max_Name_Length];
    char EvaluationResultFolderName[Max_Name_Length];

    strcpy(LibraryFileName, Parameter.LibraryFileName.c_str());
    strcpy(LibraryName, Parameter.LibraryName.c_str());
    strcpy(DesignFileName, Parameter.DesignFileName.c_str());
    strcpy(MainModuleName, Parameter.MainModuleName.c_str());
    strcpy(SettingsFileName, Parameter.SettingsFileName.c_str());
    strcpy(EvaluationResultFolderName, Parameter.EvaluationResultFolderName.c_str());

	Hardware::Read::SettingsFile_BeforeDesign(SettingsFileName, &Settings);
    Hardware::Read::LibraryFile(LibraryFileName, LibraryName, &Library);
    std::cout << "Read design file..." << std::flush;
    Hardware::Read::DesignFile(DesignFileName, MainModuleName, &Settings, &Library, &Circuit, 0, 0, 0, NULL);
    std::cout << "done!" << std::endl;
    Hardware::Prepare::MakeCircuitDepth(&Library, &Circuit);
	Hardware::Read::SettingsFile(SettingsFileName, &Circuit, &Settings);
    Hardware::Prepare::Probes(&Library, &Circuit, &Settings, &Probes);
	Hardware::Prepare::Simulation(&Circuit, &Settings, &Probes, EvaluationResultFolderName, &Simulation);

    std::cout << "Prepare shared data for " << Settings.Max_no_of_Threads << " threads ..." << std::flush;
	SharedData = (SharedDataStruct*)malloc(Settings.Max_no_of_Threads * sizeof(SharedDataStruct));

    for (int ThreadIndex = 0; ThreadIndex < Settings.Max_no_of_Threads; ThreadIndex++){
        Hardware::Prepare::SharedData(&Circuit, &Settings, &SharedData[ThreadIndex]);
	}

    std::cout << "done!" << std::endl << std::endl;
}

