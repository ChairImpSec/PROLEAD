#include "Software/Prepare.hpp"

void Software::Prepare::All(CommandLineParameterStruct& Parameter, Software::ConfigProbesStruct* Probes, Software::SettingsStruct* Settings, std::vector<Software::SharedDataStruct>& SharedInputData, Software::HelperStruct& GlobalHelper, std::vector<Software::ThreadSimulationStruct>& GlobalThreadSimulations){

    char* LinkerFileName			 =	(char*)malloc(sizeof(char) * (Parameter.LinkerFileName.length() + 1));
    char* DesignFileName			 =	(char*)malloc(sizeof(char) * (Parameter.DesignFileName.length() + 1));
    char* SettingsFileName			 =	(char*)malloc(sizeof(char) * (Parameter.SettingsFileName.length() + 1));
    char* EvaluationResultFolderName =	(char*)malloc(sizeof(char) * (Parameter.EvaluationResultFolderName.length() + 1));

	bool ignoreMakefileConfig = false;
	if(!Parameter.BinaryInformationNames.empty()){
		//split Binary parameter into location of .map file, location of disassembled.txt, location of binary.elf
		Settings->externalBinaryInformation.resize(3);
		std::vector<std::string> tmpBinaryName;
		std::istringstream iss(Parameter.BinaryInformationNames);
		std::string tmp;
		while(std::getline(iss, tmp, ' ' )){
			tmpBinaryName.push_back(tmp);
		}
		tmpBinaryName.erase(std::remove_if(tmpBinaryName.begin(), tmpBinaryName.end(), IsEmptyOrBlank), tmpBinaryName.end());
		if(tmpBinaryName.size() != 3){
			throw std::runtime_error("binary flag does not exactly contain three paths (required path to: .elf file, disassembled file, .map file)");
		}
		bool mapFound = false;
		bool disassembledFound = false;
		bool elfFound = false;
		for(const auto& path: tmpBinaryName){
			if(path.rfind(".map", path.length() - 4) != std::string::npos){
				Settings->externalBinaryInformation.at(1) = path;
				mapFound = true;
			}
			else if(path.rfind(".txt", path.length() -4) != std::string::npos){
				Settings->externalBinaryInformation.at(2) = path;
				disassembledFound = true;
			}
			else if(path.rfind(".elf", path.length() - 4) != std::string::npos){
				Settings->externalBinaryInformation.at(0) = path;
				elfFound = true;
			}
			else{
				throw std::runtime_error("in binary flag: detected path to unknown format");
			}
		}
		if(!mapFound){
			throw std::runtime_error("in binary flag: no path to .map found");
		}
		if(!disassembledFound){
			throw std::runtime_error("in binary flag: no path to disassembled.txt found");
		}
		if(!elfFound){
			throw std::runtime_error("in binary flag: no path to .elf found");
		}



		ignoreMakefileConfig = true;
	}


    strcpy(LinkerFileName, Parameter.LinkerFileName.c_str());
    strcpy(DesignFileName, Parameter.DesignFileName.c_str());
    strcpy(SettingsFileName, Parameter.SettingsFileName.c_str());
    strcpy(EvaluationResultFolderName, Parameter.EvaluationResultFolderName.c_str());

    Software::Read::SettingsFile(SettingsFileName, Settings, Probes, ignoreMakefileConfig);
    Software::Read::BinaryFile(DesignFileName , Settings, LinkerFileName);

	GlobalThreadSimulations.resize(Settings->Max_no_of_Threads);
    
    std::cout << "Prepare shared data for " << Settings->Max_no_of_Threads << " threads ..." << std::flush;
	SharedInputData.resize(Settings->NumberOfStepSimulations);
	
	uint32_t CycleCounter = 0;
	std::vector<uint32_t> number_of_cycles_per_thread(Settings->Max_no_of_Threads);
	for(uint32_t i = 0; i < (uint32_t)Settings->Max_no_of_Threads; ++i){
		number_of_cycles_per_thread.at(i) = (uint32_t)Settings->Max_No_ClockCycles/(uint32_t)Settings->Max_no_of_Threads;
	}
	for(uint32_t i = 0; i < (uint32_t)(Settings->Max_No_ClockCycles % Settings->Max_no_of_Threads); ++i){
		number_of_cycles_per_thread.at(i) += 1;
	}

    for (uint32_t ThreadIndex = 0; ThreadIndex < (uint32_t)Settings->Max_no_of_Threads; ThreadIndex++){
        // Software::Prepare::SharedData(Settings, SharedInputData.at(ThreadIndex));
        Software::Prepare::ThreadSimulation(GlobalThreadSimulations.at(ThreadIndex), Settings, EvaluationResultFolderName, ThreadIndex, CycleCounter, number_of_cycles_per_thread);
		CycleCounter += number_of_cycles_per_thread.at(ThreadIndex);
	}
	for(uint32_t SimulationIndex = 0; SimulationIndex < Settings->NumberOfStepSimulations; ++SimulationIndex){
		Software::Prepare::SharedData(Settings, SharedInputData.at(SimulationIndex));
	}
    Software::Prepare::Helper(Probes, GlobalHelper);
    std::cout << "done!" << std::endl << std::endl;
}

bool Software::Prepare::IsEmptyOrBlank(const std::string &s) {
    return s.find_first_not_of(" \t") == std::string::npos;
}


void Software::Prepare::SharedData(Software::SettingsStruct* Settings, Software::SharedDataStruct& SharedData){
	uint32_t i;
	
	/*
	*	SharedDataStruct for instantiating the emulator in multiple threads
	*/

	SharedData.BytelengthOfParams.resize(Settings->InitialSim_NumberOfInputs, 0);
	SharedData.VariableOrArrayParams.resize(Settings->InitialSim_NumberOfInputs, 0);
	SharedData.StartaddrInRAM.resize(Settings->InitialSim_NumberOfInputs, 0);

	SharedData.ByteValuesOfParams.resize(Settings->InitialSim_NumberOfInputs);

	for(i = 0; i < (uint32_t)Settings->InitialSim_NumberOfInputs; ++i){
		SharedData.ByteValuesOfParams[i].resize(Settings->InitialSim_InputsLength[i], 0);
	}
}

void Software::Prepare::ThreadSimulation(Software::ThreadSimulationStruct& GlobalThreadSimulation, Software::SettingsStruct* Settings, char* EvaluationResultFolderName, uint32_t ThreadIdx, uint32_t CycleCounter, std::vector<uint32_t>& number_of_cycles_per_thread){
	GlobalThreadSimulation.TestTransitional = Settings->TestTransitional;
	GlobalThreadSimulation.StandardProbesPerSimulation.resize(Settings->NumberOfStepSimulations);
	GlobalThreadSimulation.TestMultivariate = Settings->TestMultivariate;
	GlobalThreadSimulation.NumberOfTestClockCycles = Settings->NumberOfTestClockCycles;
	GlobalThreadSimulation.SelectedGroups.resize(Settings->NumberOfStepSimulations);
	GlobalThreadSimulation.NumberOfGroups = static_cast<uint32_t>(Settings->NumberOfGroups);
	GlobalThreadSimulation.TestOrder = Settings->TestOrder;
	GlobalThreadSimulation.EvaluationResultFolderName = EvaluationResultFolderName;
	GlobalThreadSimulation.NumberOfStepSimulations = static_cast<uint32_t>(Settings->NumberOfStepSimulations);
	GlobalThreadSimulation.StartRAM_EndRAM_EmulatorInputs.resize(GlobalThreadSimulation.StartRAM_EndRAM_EmulatorInputs.size() + Settings->InitialSim_PositionInEmulatorRam.size());
	
	for(uint32_t i = 0; i < (uint32_t)Settings->InitialSim_PositionInEmulatorRam.size(); ++i){
		GlobalThreadSimulation.StartRAM_EndRAM_EmulatorInputs.at(i).push_back(Settings->ram.offset + Settings->InitialSim_PositionInEmulatorRam[Settings->InitialSim_InputName[i]]);
		GlobalThreadSimulation.StartRAM_EndRAM_EmulatorInputs.at(i).push_back(Settings->ram.offset + Settings->InitialSim_PositionInEmulatorRam[Settings->InitialSim_InputName[i]] + Settings->InitialSim_InputsLength[i] - 1);
	}

	//calculate which thread executes which clock cycles
	GlobalThreadSimulation.GlobalCycleStart = CycleCounter;
	GlobalThreadSimulation.GlobalCycleEnd = CycleCounter + number_of_cycles_per_thread[ThreadIdx] - 1;
	GlobalThreadSimulation.NumberOfCycleSplits = ceil((GlobalThreadSimulation.GlobalCycleEnd - GlobalThreadSimulation.GlobalCycleStart + 1)/700.0f); //do at max 700 instructions per iteration


	for(uint32_t i = GlobalThreadSimulation.GlobalCycleStart; i <= GlobalThreadSimulation.GlobalCycleEnd; ++i){
		for(uint32_t j = 0; j < (uint32_t)Settings->NumberOfTestClockCycles; ++j){
			if((i) == (uint32_t)Settings->TestClockCycles[j]){
				GlobalThreadSimulation.TestClockCycles.push_back(i);
			}
			if((uint32_t)Settings->TestClockCycles[j] > GlobalThreadSimulation.GlobalCycleEnd){
				break;
			}
		}
	}


	uint32_t CycleSplitCounter = GlobalThreadSimulation.GlobalCycleStart;
	std::vector<uint32_t> number_of_cycles_per_cyclesplit(GlobalThreadSimulation.NumberOfCycleSplits);

	for(uint32_t i = 0; i < GlobalThreadSimulation.NumberOfCycleSplits; ++i){
		number_of_cycles_per_cyclesplit.at(i) = (GlobalThreadSimulation.GlobalCycleEnd - GlobalThreadSimulation.GlobalCycleStart + 1)/GlobalThreadSimulation.NumberOfCycleSplits;
	}

	for(uint32_t i = 0; i < ((GlobalThreadSimulation.GlobalCycleEnd - GlobalThreadSimulation.GlobalCycleStart + 1)%GlobalThreadSimulation.NumberOfCycleSplits); ++i){
		number_of_cycles_per_cyclesplit.at(i) += 1;
	}

	for(uint32_t i = 0; i < GlobalThreadSimulation.NumberOfCycleSplits; ++i){
		GlobalThreadSimulation.CycleStart.push_back(CycleSplitCounter);
		GlobalThreadSimulation.CycleEnd.push_back(CycleSplitCounter + number_of_cycles_per_cyclesplit.at(i) - 1);
		CycleSplitCounter += number_of_cycles_per_cyclesplit.at(i);
	}


}

void Software::Prepare::Helper(Software::ConfigProbesStruct* Probes, Software::HelperStruct& Helper){
	int ProbeIndex, RegisterIndex, BitIndex;
	std::string RegisterIndexAsString, BitIndexAsString;


	for(ProbeIndex = 0; ProbeIndex < Probes->NumberOfProbes; ++ProbeIndex){

		RegisterIndexAsString = Probes->ProbeName[ProbeIndex];
		BitIndexAsString = Probes->ProbeName[ProbeIndex];

		//Normal probes
		if (Probes->ProbeName[ProbeIndex][0] == 'R'){
			// Get the Number of the register -> RegisterIndex of R14[12] is 14
			RegisterIndexAsString = RegisterIndexAsString.substr(1, RegisterIndexAsString.find("[") - 1);
			RegisterIndex = std::stoi(RegisterIndexAsString);

			// Get bit index of the register -> BitIndex of R14[12] is 12
			BitIndexAsString = BitIndexAsString.substr(BitIndexAsString.find("[") + 1, BitIndexAsString.find("]") - BitIndexAsString.find("[") - 1);
			BitIndex = std::stoi(BitIndexAsString);

			// Include all probes that are not excluded
			Helper.NormalProbesIncluded.at(RegisterIndex).emplace_back(BitIndex);

		}
		//memory probes
		else if((strstr(Probes->ProbeName[ProbeIndex], "MEM") != NULL) && (strstr(Probes->ProbeName[ProbeIndex], "MEMSHADOW") == NULL)){ //if string contains mem but not memshadow
			Helper.ProbeMemory = true;

			BitIndexAsString = BitIndexAsString.substr(BitIndexAsString.find("[") + 1, BitIndexAsString.find("]") - BitIndexAsString.find("[") - 1);
			BitIndex = std::stoi(BitIndexAsString);

			Helper.MemoryProbesIncluded.emplace_back(BitIndex);
		}
		// memory shadow register probes
		else if((strstr(Probes->ProbeName[ProbeIndex], "MEMSHADOW") != NULL)){
			Helper.ProbeMemoryShadowRegister = true;

			BitIndexAsString = BitIndexAsString.substr(BitIndexAsString.find("[") + 1, BitIndexAsString.find("]") - BitIndexAsString.find("[") - 1);
			BitIndex = std::stoi(BitIndexAsString);
			Helper.MemoryShadowRegisterProbesIncluded.emplace_back(BitIndex);
		}
		//horizontal probes
		else if(Probes->ProbeName[ProbeIndex][0] == 'H'){
			// Get the Number of the register -> RegisterIndex of HR14 is 14
			RegisterIndexAsString = RegisterIndexAsString.substr(2, RegisterIndexAsString.find("[") - 2);
			RegisterIndex = std::stoi(RegisterIndexAsString);	

			if(RegisterIndex != 17){
				for(const auto& bit: Helper.NormalProbesIncluded.at(RegisterIndex)){
					Helper.HorizontalBitsIncluded.at(RegisterIndex).emplace_back(bit);
				}

				if(Helper.HorizontalBitsIncluded.at(RegisterIndex).size() <= 1){
					Helper.HorizontalBitsIncluded.at(RegisterIndex).clear();
					Helper.HorizontalProbesExcluded.at(RegisterIndex) = true;
				}
				else{
					Helper.HorizontalProbesExcluded.at(RegisterIndex) = false;
				}
			}
			else{ //shadow register horizontal probe
				Helper.HorizontalProbesExcluded.at(17) = false;
			}

		}
		//vertical probes
		else if(Probes->ProbeName[ProbeIndex][0] == 'V'){

			BitIndexAsString = BitIndexAsString.substr(BitIndexAsString.find("[") + 1, BitIndexAsString.find("]") - BitIndexAsString.find("[") - 1);
			BitIndex = std::stoi(BitIndexAsString);

			for(RegisterIndex = 0; RegisterIndex < 17; ++RegisterIndex){
				for(int CorrespondingRegisterIndex = 0; CorrespondingRegisterIndex < RegisterIndex; ++CorrespondingRegisterIndex){
					if((std::find(Helper.NormalProbesIncluded.at(RegisterIndex).begin(), Helper.NormalProbesIncluded.at(RegisterIndex).end() , BitIndex) != Helper.NormalProbesIncluded.at(RegisterIndex).end()) && (std::find(Helper.NormalProbesIncluded.at(CorrespondingRegisterIndex).begin(), Helper.NormalProbesIncluded.at(CorrespondingRegisterIndex).end() , BitIndex) != Helper.NormalProbesIncluded.at(CorrespondingRegisterIndex).end())){
						Helper.VerticalProbesIncluded.at(RegisterIndex).emplace_back(std::make_tuple(CorrespondingRegisterIndex, BitIndex));
						Helper.VerticalProbesSize.at(RegisterIndex).at(17)++;
						Helper.VerticalProbesSize.at(RegisterIndex).at(CorrespondingRegisterIndex)++;
					}
				}
				
				for(int CorrespondingRegisterIndex = RegisterIndex+1; CorrespondingRegisterIndex < 17; ++CorrespondingRegisterIndex){
					if((std::find(Helper.NormalProbesIncluded.at(RegisterIndex).begin(), Helper.NormalProbesIncluded.at(RegisterIndex).end() , BitIndex) != Helper.NormalProbesIncluded.at(RegisterIndex).end()) && (std::find(Helper.NormalProbesIncluded.at(CorrespondingRegisterIndex).begin(), Helper.NormalProbesIncluded.at(CorrespondingRegisterIndex).end() , BitIndex) != Helper.NormalProbesIncluded.at(CorrespondingRegisterIndex).end())){
						Helper.VerticalProbesIncluded.at(RegisterIndex).emplace_back(std::make_tuple(CorrespondingRegisterIndex, BitIndex));
						Helper.VerticalProbesSize.at(RegisterIndex).at(17)++;
						Helper.VerticalProbesSize.at(RegisterIndex).at(CorrespondingRegisterIndex)++;
					}
				}	
			}
		}
		//full horizontal probes
		else if((strstr(Probes->ProbeName[ProbeIndex], "FULLHR") != NULL)){
			Helper.ProbeFullHorizontal = true;

			for(uint8_t RegIdx = 0; RegIdx < 17; ++RegIdx){
				for(uint8_t PartnerRegIdx = 0; PartnerRegIdx < 17; ++PartnerRegIdx){
					if((RegIdx != PartnerRegIdx) && (!Helper.NormalProbesIncluded.at(PartnerRegIdx).empty()) && (!Helper.NormalProbesIncluded.at(RegIdx).empty())){
						Helper.FULLHRProbesIncluded.at(RegIdx).emplace_back(PartnerRegIdx);
						Helper.FullHorizontalProbesSize.at(RegIdx).at(17)++;
						Helper.FullHorizontalProbesSize.at(RegIdx).at(PartnerRegIdx)++;
					}
				}
			}
		}
		//full vertical probes
		else if((strstr(Probes->ProbeName[ProbeIndex], "FULLVR") != NULL)){
			Helper.ProbeFullVertical = true;

			BitIndexAsString = BitIndexAsString.substr(BitIndexAsString.find("[") + 1, BitIndexAsString.find("]") - BitIndexAsString.find("[") - 1);
			BitIndex = std::stoi(BitIndexAsString);

			for(RegisterIndex = 0; RegisterIndex < 17; ++ RegisterIndex){
				if(std::find(Helper.NormalProbesIncluded.at(RegisterIndex).begin(), Helper.NormalProbesIncluded.at(RegisterIndex).end() , BitIndex) != Helper.NormalProbesIncluded.at(RegisterIndex).end()){
					Helper.FullVerticalProbesIncluded.at(BitIndex).emplace_back(RegisterIndex);
				}
			}

			if(Helper.FullVerticalProbesIncluded.at(BitIndex).size() > 1){
				Helper.FullVerticalProbesSize++;
				Helper.FullVerticalRelevantBits.emplace_back(BitIndex);
			}

		}
		//pipeline forwarding probes
		else if((strstr(Probes->ProbeName[ProbeIndex], "PF") != NULL)){
			Helper.ProbePipelineForwarding = true;

			BitIndexAsString = BitIndexAsString.substr(BitIndexAsString.find("[") + 1, BitIndexAsString.find("]") - BitIndexAsString.find("[") - 1);
			BitIndex = std::stoi(BitIndexAsString);

			for(RegisterIndex = 0; RegisterIndex < 17; ++ RegisterIndex){
				if(std::find(Helper.NormalProbesIncluded.at(RegisterIndex).begin(), Helper.NormalProbesIncluded.at(RegisterIndex).end() , BitIndex) != Helper.NormalProbesIncluded.at(RegisterIndex).end()){
					Helper.PipelineForwardingProbesIncluded.at(BitIndex).emplace_back(RegisterIndex);
				}
			}

			if(Helper.PipelineForwardingProbesIncluded.at(BitIndex).size() > 1){
				Helper.PipelineForwardingProbesSize++;
				Helper.PipelineForwardingRelevantBits.emplace_back(BitIndex);
			}

		}
		else 
		{
			throw std::runtime_error("Critical error during the generation of inclusion/exclusion list");
		}

	}

	if(!(Helper.HorizontalProbesExcluded.at(17))){
		for(const auto& bit: Helper.MemoryShadowRegisterProbesIncluded){
			Helper.HorizontalBitsIncluded.at(17).emplace_back(bit);
		}
		if(Helper.HorizontalBitsIncluded.at(17).size() <= 1){
			Helper.HorizontalBitsIncluded.at(17).clear();
			Helper.HorizontalProbesExcluded.at(17) = true;
			std::cout << "remove horizontal memory" << std::endl;
		}
	}


	for(uint8_t RegIdx = 0; RegIdx < 17; ++RegIdx){
		std::sort(Helper.VerticalProbesIncluded.at(RegIdx).begin(), Helper.VerticalProbesIncluded.at(RegIdx).end());
	}
	
}
