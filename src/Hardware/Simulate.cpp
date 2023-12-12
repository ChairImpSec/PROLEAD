#include "Hardware/Simulate.hpp"
#include <stdio.h>
#include <string>
#include <cstring>

uint64_t Hardware::Simulate::EvaluateOperation(Hardware::OperationStruct Operation, uint64_t *Values, char Intermediate)
{
	uint64_t Res = 0;
	int i, j;

	for (i = 0; i < Operation.NumberOfClauses; i++)
	{
		Res = Values[Operation.OperandsInClause[i][0]];

		if (Operation.OperationOfClause[i] == Operation_AND)
			for (j = 1; j < Operation.NumberOfOperandsInClause[i]; j++)
				Res &= Values[Operation.OperandsInClause[i][j]];
		else if (Operation.OperationOfClause[i] == Operation_OR)
			for (j = 1; j < Operation.NumberOfOperandsInClause[i]; j++)
				Res |= Values[Operation.OperandsInClause[i][j]];
		else if (Operation.OperationOfClause[i] == Operation_XOR)
			for (j = 1; j < Operation.NumberOfOperandsInClause[i]; j++)
				Res ^= Values[Operation.OperandsInClause[i][j]];
		else
			Res = ~Res;

		Values[Intermediate + i] = Res;
	}

	return Res;
}

void Hardware::Simulate::All(Hardware::LibraryStruct &Library, Hardware::CircuitStruct &Circuit, Hardware::SettingsStruct &Settings, Hardware::SharedDataStruct *SharedData, Hardware::SimulationStruct &Simulation, int SimulationIndex, boost::mt19937 &ThreadRng)
{
	int i;
	int InputIndex;
	int OutputIndex;
	int SignalIndex;
	int RegIndex;
	int DepthIndex;
	int CellIndex;
	int ClockCycle;
	uint64_t Value;
	uint64_t Mask;
	uint64_t ExpectedValue;
	int NumberOfWaitedClockCycles;
	uint64_t InputVector[100];
	uint64_t Active;
	int BitIndex;
	// int       ClockCyclesTook;
	int GroupIndex;
	int ValueIndex;
	int ShareIndex;
	uint64_t InvertedInput;
	uint64_t Select[100];
	int ProbeIndex;
	std::string ErrorMessage;

	// assigning inputs (fixed/random/etc)
	boost::uniform_int<uint64_t> ThreadDist(0, std::numeric_limits<uint64_t>::max());
	boost::variate_generator<boost::mt19937 &, boost::uniform_int<uint64_t>> ThreadPrng(ThreadRng, ThreadDist);

	for (GroupIndex = 0; GroupIndex < Settings.NumberOfGroups; GroupIndex++)
	{
		for (ValueIndex = 0; ValueIndex < Settings.NumberOfGroupValues; ValueIndex++)
		{
			if (Settings.Group_Values[GroupIndex][ValueIndex] < 0)
			{
				SharedData->GroupValues[GroupIndex][ValueIndex] = ThreadPrng();
			}
			else
			{
				SharedData->GroupValues[GroupIndex][ValueIndex] = Settings.Group_Values[GroupIndex][ValueIndex] ? FullOne : 0;
			}
		}

		Select[GroupIndex] = 0;
	}

	for (BitIndex = 0; BitIndex < 64; BitIndex++)
	{
		Simulation.SelectedGroups[SimulationIndex * 64 + BitIndex] = ThreadPrng() % Settings.NumberOfGroups;
		Select[Simulation.SelectedGroups[SimulationIndex * 64 + BitIndex]] |= SharedData->OneIn64[BitIndex];
	}

	for (ValueIndex = 0; ValueIndex < Settings.NumberOfGroupValues; ValueIndex++)
	{
		SharedData->SelectedGroupValues[ValueIndex][0] = 0;

		for (GroupIndex = 0; GroupIndex < Settings.NumberOfGroups; GroupIndex++)
			SharedData->SelectedGroupValues[ValueIndex][0] |= SharedData->GroupValues[GroupIndex][ValueIndex] & Select[GroupIndex];

		// sharing selected inputs
		for (ShareIndex = 0; ShareIndex < Settings.MaxNumberOfSharesGroupValues[ValueIndex]; ShareIndex++)
		{
			SharedData->SelectedGroupValues[ValueIndex][ShareIndex + 1] = ThreadPrng();
			SharedData->SelectedGroupValues[ValueIndex][0] ^= SharedData->SelectedGroupValues[ValueIndex][ShareIndex + 1];
		}
	}

	NumberOfWaitedClockCycles = -1;

	if (Settings.WaveformSimulation){
		Hardware::Simulate::GenerateVCDfile(Circuit, Settings, SimulationIndex + Simulation.NumberOfProcessedSimulations / 64);
	}

	for (ClockCycle = 0; ClockCycle < Settings.Max_No_ClockCycles; ClockCycle++)
	{
		SharedData->SignalValues[Settings.ClockSignal] = FullOne;

		// ----------- evaluate the registers

		for (RegIndex = 0; RegIndex < Circuit.NumberOfRegs; RegIndex++)
		{
			for (InputIndex = 0; InputIndex < Circuit.Cells[Circuit.Regs[RegIndex]]->NumberOfInputs; InputIndex++)
				InputVector[InputIndex] = SharedData->SignalValues[Circuit.Cells[Circuit.Regs[RegIndex]]->Inputs[InputIndex]];

			for (OutputIndex = 0; OutputIndex < Circuit.Cells[Circuit.Regs[RegIndex]]->NumberOfOutputs; OutputIndex++)
				InputVector[Circuit.Cells[Circuit.Regs[RegIndex]]->NumberOfInputs + OutputIndex] = SharedData->RegValues[Circuit.Cells[Circuit.Regs[RegIndex]]->RegValueIndexes[OutputIndex]];

			for (OutputIndex = 0; OutputIndex < Circuit.Cells[Circuit.Regs[RegIndex]]->NumberOfOutputs; OutputIndex++)
			{
				Value = Hardware::Simulate::EvaluateOperation(Library.CellTypes[Circuit.Cells[Circuit.Regs[RegIndex]]->Type]->Operations[OutputIndex], InputVector,
															  Library.CellTypes[Circuit.Cells[Circuit.Regs[RegIndex]]->Type]->Intermediate);

				if (ClockCycle == 0)
					SharedData->RegValues[Circuit.Cells[Circuit.Regs[RegIndex]]->RegValueIndexes[OutputIndex]] = 0;
				else
					SharedData->RegValues[Circuit.Cells[Circuit.Regs[RegIndex]]->RegValueIndexes[OutputIndex]] = Value;
			}
		}

		// ----------- applying always random inputs

		for (InputIndex = 0; InputIndex < Settings.NumberOfAlwaysRandomInputs; InputIndex++)
			SharedData->SignalValues[Settings.AlwaysRandomInputs[InputIndex]] = ThreadPrng();

		// ----------- applying the initial inputs

		if (ClockCycle < Settings.InitialSim_NumberOfClockCycles)
		{
			for (InputIndex = 0; InputIndex < Settings.InitialSim_NumberOfInputs; InputIndex++)
			{
				if ((Settings.InitialSim_Values[ClockCycle][InputIndex] & GroupInMask) == GroupInput)
				{
					ValueIndex = Settings.InitialSim_Values[ClockCycle][InputIndex] & 0xffffffff;
					InvertedInput = (Settings.InitialSim_Values[ClockCycle][InputIndex] >> 32) & 1;
					ShareIndex = (Settings.InitialSim_Values[ClockCycle][InputIndex] >> 33) & 0xff;

					if (InvertedInput){
						InvertedInput = FullOne;
					}

					SharedData->SignalValues[Settings.InitialSim_Inputs[ClockCycle][InputIndex]] = InvertedInput ^ SharedData->SelectedGroupValues[ValueIndex][ShareIndex];
				}
				else if ((Settings.InitialSim_Values[ClockCycle][InputIndex] & GroupInMask) == SameInput)
					SharedData->SignalValues[Settings.InitialSim_Inputs[ClockCycle][InputIndex]] = SharedData->LastInitialSimValues[InputIndex];
				else if ((Settings.InitialSim_Values[ClockCycle][InputIndex] & GroupInMask) == RandomInput)
					SharedData->SignalValues[Settings.InitialSim_Inputs[ClockCycle][InputIndex]] = ThreadPrng();
				else
					SharedData->SignalValues[Settings.InitialSim_Inputs[ClockCycle][InputIndex]] = Settings.InitialSim_Values[ClockCycle][InputIndex];

				SharedData->LastInitialSimValues[InputIndex] = SharedData->SignalValues[Settings.InitialSim_Inputs[ClockCycle][InputIndex]];
			}
		}

		// ----------- applying the register outputs to the output signals

		for (RegIndex = 0; RegIndex < Circuit.NumberOfRegs; RegIndex++)
		{
			for (OutputIndex = 0; OutputIndex < Circuit.Cells[Circuit.Regs[RegIndex]]->NumberOfOutputs; OutputIndex++)
				if (Circuit.Cells[Circuit.Regs[RegIndex]]->Outputs[OutputIndex] != -1)
					SharedData->SignalValues[Circuit.Cells[Circuit.Regs[RegIndex]]->Outputs[OutputIndex]] = SharedData->RegValues[Circuit.Cells[Circuit.Regs[RegIndex]]->RegValueIndexes[OutputIndex]];
		}

		// ----------- storing the probe values in simualtion memory

		for (ProbeIndex = 0; ProbeIndex < Simulation.NumberOfAllGlitchExtendedProbes; ProbeIndex++)
			for (BitIndex = 0; BitIndex < 64; BitIndex++)
				Simulation.ProbeValues[SimulationIndex * 64 + BitIndex][ClockCycle][ProbeIndex] =
					(SharedData->SignalValues[Simulation.SignalIndex_of_GlitchExtendedProbe[ProbeIndex]] & SharedData->OneIn64[BitIndex]) ? 1 : 0;

		// ----------- evaluate the circuits :D

		for (DepthIndex = 1; DepthIndex <= Circuit.MaxDepth; DepthIndex++)
		{
			for (i = 0; i < Circuit.NumberOfCellsInDepth[DepthIndex]; i++)
			{
				CellIndex = Circuit.CellsInDepth[DepthIndex][i];

				for (InputIndex = 0; InputIndex < Circuit.Cells[CellIndex]->NumberOfInputs; InputIndex++)
					InputVector[InputIndex] = SharedData->SignalValues[Circuit.Cells[CellIndex]->Inputs[InputIndex]];

				for (OutputIndex = 0; OutputIndex < Circuit.Cells[CellIndex]->NumberOfOutputs; OutputIndex++)
					if (Circuit.Cells[CellIndex]->Outputs[OutputIndex] != -1)
					{
						Value = Hardware::Simulate::EvaluateOperation(Library.CellTypes[Circuit.Cells[CellIndex]->Type]->Operations[OutputIndex], InputVector,
																	  Library.CellTypes[Circuit.Cells[CellIndex]->Type]->Intermediate);
						SharedData->SignalValues[Circuit.Cells[CellIndex]->Outputs[OutputIndex]] = Value;
					}
			}
		}

		SharedData->SignalValues[Settings.ClockSignal] = 0;

		// re-evaluate (we don't need it in this design since it works only at possitive edge of the clock and does not have a latch
		//
		//
		//

		// ----------- check the conditions to terminate the simulation

		if (ClockCycle > Settings.InitialSim_NumberOfClockCycles)
		{
			Active = 0;
			if (Settings.EndSimCondition_ClockCycles)
				Active = (ClockCycle >= Settings.EndSimCondition_ClockCycles) ? 0 : FullOne;
			else
				for (SignalIndex = 0; SignalIndex < Settings.EndSimCondition_NumberOfSignals; SignalIndex++)
					Active |= SharedData->SignalValues[Settings.EndSimCondition_Signals[SignalIndex]] ^ Settings.EndSimCondition_Values[SignalIndex];

			if (Active == 0)
			{
				if (NumberOfWaitedClockCycles == -1)
					NumberOfWaitedClockCycles = 0;
				else
					NumberOfWaitedClockCycles++;
			}

			if (NumberOfWaitedClockCycles == Settings.EndSim_NumberOfWaitCycles)
			{
				// ClockCyclesTook = ClockCycle;
				break;
			}
			else if ((ClockCycle == (Settings.Max_No_ClockCycles - 1)) && (NumberOfWaitedClockCycles < Settings.EndSim_NumberOfWaitCycles))
			{
				// ClockCyclesTook = ClockCycle + 1;
				break;
			}
		}

		// Here, we store the result during one clock cycle in a vcd file
		if (Settings.WaveformSimulation){
			Hardware::Simulate::WriteVCDfile(Circuit, Settings, SharedData, SimulationIndex + Simulation.NumberOfProcessedSimulations / 64, ClockCycle);
		}
	}

	if (Settings.WaveformSimulation){
		Hardware::Simulate::FinalizeVCDfile(ClockCycle, SimulationIndex + Simulation.NumberOfProcessedSimulations / 64);
	}

	for (SignalIndex = 0; SignalIndex < Settings.NumberOfOutputSignals; SignalIndex++)
	{
		Value = 0;
		for (ShareIndex = 0; ShareIndex < Settings.NumberOfOutputShares; ShareIndex++)
			Value ^= SharedData->SignalValues[Settings.OutputSignals[ShareIndex][SignalIndex]];

		Mask = 0;
		ExpectedValue = 0;
		for (GroupIndex = 0; GroupIndex < Settings.NumberOfGroups; GroupIndex++)
		{
			if (Settings.ExpectedOutputValues[GroupIndex][SignalIndex] >= 0)
			{
				Mask |= Select[GroupIndex];
				if (Settings.ExpectedOutputValues[GroupIndex][SignalIndex] == 1)
					ExpectedValue |= Select[GroupIndex];
			}
		}

		if ((Value & Mask) != ExpectedValue)
		{
			ErrorMessage = "Error in simulation. Value of signal(s)\n";
			for (ShareIndex = 0; ShareIndex < Settings.NumberOfOutputShares; ShareIndex++)
				ErrorMessage += "  \"" + (std::string)Circuit.Signals[Settings.OutputSignals[ShareIndex][SignalIndex]]->Name + "\"\n";

			ErrorMessage += "do not match to the expected output!";

#pragma omp critical
			throw std::runtime_error(ErrorMessage);
		}
	}
}

void Hardware::Simulate::GenerateVCDfile(Hardware::CircuitStruct &Circuit, Hardware::SettingsStruct &Settings, int SimulationIndex)
{
	std::string SignalName;
	unsigned int BitIndex;

	for (BitIndex = 0; BitIndex < 64; BitIndex++){
		std::ofstream VCDFile("Simulation_" + std::to_string(SimulationIndex * 64 + BitIndex) + ".vcd");
		VCDFile << "$version \n PROLEAD \n$end \n$timescale \n 1ps \n$end" << std::endl;
		VCDFile << "$scope module " << Settings.ModuleName << " $end\n" << std::endl;
		
		for (int SignalIndex = 0; SignalIndex < Circuit.NumberOfSignals; ++SignalIndex){
			SignalName = Circuit.Signals[SignalIndex]->Name;
			if (SignalName != "1'b0" && SignalName != "1'b1" && SignalName != "1'h0" && SignalName != "1'h1"){
				VCDFile << "$var wire 1 " << SignalName << " " << SignalName << " $end" << std::endl;
			}
		}

		VCDFile << "$upscope $end" << std::endl;
		VCDFile << "$enddefinitions $end" << std::endl;
		VCDFile.close();
	}
}

void Hardware::Simulate::WriteVCDfile(Hardware::CircuitStruct &Circuit, Hardware::SettingsStruct &Settings, Hardware::SharedDataStruct *SharedData, int SimulationIndex, int CycleIndex)
{
	int SignalIndex;
	unsigned int BitIndex;
	std::string SignalName;

	for (BitIndex = 0; BitIndex < 64; BitIndex++){
		std::ofstream VCDFile;
		VCDFile.open("Simulation_" + std::to_string(SimulationIndex * 64 + BitIndex) + ".vcd", std::ios_base::app);	
		VCDFile << "#" << (2 * CycleIndex) * 1000 << std::endl;

		for (SignalIndex = 0; SignalIndex < Circuit.NumberOfSignals; SignalIndex++){
			SignalName = Circuit.Signals[SignalIndex]->Name;
		
			if (SignalName != "1'b0" && SignalName != "1'b1" && SignalName != "1'h0" && SignalName != "1'h1"){
				if (SignalIndex == Settings.ClockSignal){
					VCDFile << "1" << SignalName << std::endl;
				}else{
					bool BitAtIndex = (SharedData->SignalValues[SignalIndex] >> BitIndex) & 0x1;
					VCDFile << BitAtIndex << SignalName << std::endl;
				}
			}
		}

		VCDFile << "#" << (2 * CycleIndex + 1) * 1000 << std::endl;
		VCDFile << "0" << Circuit.Signals[Settings.ClockSignal]->Name << std::endl;
		VCDFile.close();
	}
}

void Hardware::Simulate::FinalizeVCDfile(int CycleIndex, int SimulationIndex)
{
	for (unsigned int BitIndex = 0; BitIndex < 64; BitIndex++){
		std::ofstream VCDFile;
		VCDFile.open("Simulation_" + std::to_string(SimulationIndex * 64 + BitIndex) + ".vcd", std::ios_base::app);	
		VCDFile << "#" << (2 * CycleIndex) * 1000 << std::endl;
		VCDFile.close();
	}
}
