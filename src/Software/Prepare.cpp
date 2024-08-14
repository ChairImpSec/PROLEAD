#include "Software/Prepare.hpp"

void Software::Prepare::All(const po::variables_map& vm, Software::ConfigProbesStruct& probes, Software::SettingsStruct& settings, Settings& settings2, std::vector<Software::SharedDataStruct>& SharedInputData, Software::HelperStruct& GlobalHelper, std::vector<Software::ThreadSimulationStruct>& GlobalThreadSimulations){
  std::string result_folder_name = vm["resultfolder"].as<std::string>();
  std::string linker_file_name = vm["linkerfile"].as<std::string>();
  std::string design_file_name = vm["designfile"].as<std::string>();

	bool ignore_makefile_config = false;

	if(design_file_name == "design.v"){
		settings.externalBinaryInformation.resize(3);
		settings.externalBinaryInformation.at(0) = vm["binary"].as<std::string>();
		settings.externalBinaryInformation.at(1) = vm["mapfile"].as<std::string>();
		settings.externalBinaryInformation.at(2) = vm["asmfile"].as<std::string>();
		ignore_makefile_config = true;
	}

    Software::Read::SettingsFile(settings, settings2, probes, ignore_makefile_config);
    Software::Read::BinaryFile(vm, settings);

	GlobalThreadSimulations.resize(settings.Max_no_of_Threads);
    
    std::cout << "Prepare shared data for " << settings.Max_no_of_Threads << " threads ..." << std::flush;
	SharedInputData.resize(settings.NumberOfStepSimulations);
	
	uint32_t CycleCounter = 0;
	std::vector<uint32_t> number_of_cycles_per_thread(settings.Max_no_of_Threads);
	for(uint32_t i = 0; i < (uint32_t)settings.Max_no_of_Threads; ++i){
		number_of_cycles_per_thread[i] = (uint32_t)settings.Max_No_ClockCycles/(uint32_t)settings.Max_no_of_Threads;
	}
	for(uint32_t i = 0; i < (uint32_t)(settings.Max_No_ClockCycles % settings.Max_no_of_Threads); ++i){
		number_of_cycles_per_thread[i] += 1;
	}

    for (uint32_t ThreadIndex = 0; ThreadIndex < (uint32_t)settings.Max_no_of_Threads; ThreadIndex++){
        // Software::Prepare::SharedData(Settings, SharedInputData.at(ThreadIndex));
        Software::Prepare::ThreadSimulation(GlobalThreadSimulations[ThreadIndex], settings, result_folder_name, ThreadIndex, CycleCounter, number_of_cycles_per_thread);
		CycleCounter += number_of_cycles_per_thread[ThreadIndex];
	}
	for(uint32_t SimulationIndex = 0; SimulationIndex < settings.NumberOfStepSimulations; ++SimulationIndex){
		Software::Prepare::SharedData(settings, SharedInputData.at(SimulationIndex));
	}
    Software::Prepare::Helper(probes, GlobalHelper);
    std::cout << "done!" << std::endl << std::endl;
}

bool Software::Prepare::IsEmptyOrBlank(const std::string &s) {
    return s.find_first_not_of(" \t") == std::string::npos;
}


void Software::Prepare::SharedData(Software::SettingsStruct& settings, Software::SharedDataStruct& SharedData){
	uint32_t i;
	
	/*
	*	SharedDataStruct for instantiating the emulator in multiple threads
	*/

	SharedData.BytelengthOfParams.resize(settings.InitialSim_NumberOfInputs, 0);
	SharedData.VariableOrArrayParams.resize(settings.InitialSim_NumberOfInputs, 0);
	SharedData.StartaddrInRAM.resize(settings.InitialSim_NumberOfInputs, 0);

	SharedData.ByteValuesOfParams.resize(settings.InitialSim_NumberOfInputs);

	for(i = 0; i < (uint32_t)settings.InitialSim_NumberOfInputs; ++i){
		SharedData.ByteValuesOfParams[i].resize(settings.InitialSim_InputsLength[i], 0);
	}
}

void Software::Prepare::ThreadSimulation(Software::ThreadSimulationStruct& GlobalThreadSimulation, Software::SettingsStruct& settings, const std::string& result_folder_name, uint32_t ThreadIdx, uint32_t CycleCounter, std::vector<uint32_t>& number_of_cycles_per_thread){
	GlobalThreadSimulation.TestTransitional = settings.TestTransitional;
	GlobalThreadSimulation.StandardProbesPerSimulation.resize(settings.NumberOfStepSimulations);
	GlobalThreadSimulation.TestMultivariate = settings.TestMultivariate;
	GlobalThreadSimulation.NumberOfTestClockCycles = settings.NumberOfTestClockCycles;
	GlobalThreadSimulation.SelectedGroups.resize(settings.NumberOfStepSimulations);
	GlobalThreadSimulation.NumberOfGroups = static_cast<uint32_t>(settings.NumberOfGroups);
	GlobalThreadSimulation.TestOrder = settings.TestOrder;
	GlobalThreadSimulation.EvaluationResultFolderName = result_folder_name;
	GlobalThreadSimulation.NumberOfStepSimulations = static_cast<uint32_t>(settings.NumberOfStepSimulations);
	GlobalThreadSimulation.StartRAM_EndRAM_EmulatorInputs.resize(GlobalThreadSimulation.StartRAM_EndRAM_EmulatorInputs.size() + settings.InitialSim_PositionInEmulatorRam.size());
	
	for(uint32_t i = 0; i < (uint32_t)settings.InitialSim_PositionInEmulatorRam.size(); ++i){
		GlobalThreadSimulation.StartRAM_EndRAM_EmulatorInputs.at(i).push_back(settings.ram.offset + settings.InitialSim_PositionInEmulatorRam[settings.InitialSim_InputName[i]]);
		GlobalThreadSimulation.StartRAM_EndRAM_EmulatorInputs.at(i).push_back(settings.ram.offset + settings.InitialSim_PositionInEmulatorRam[settings.InitialSim_InputName[i]] + settings.InitialSim_InputsLength[i] - 1);
	}

	//calculate which thread executes which clock cycles
	GlobalThreadSimulation.GlobalCycleStart = CycleCounter;
	GlobalThreadSimulation.GlobalCycleEnd = CycleCounter + number_of_cycles_per_thread[ThreadIdx] - 1;
	GlobalThreadSimulation.NumberOfCycleSplits = ceil((GlobalThreadSimulation.GlobalCycleEnd - GlobalThreadSimulation.GlobalCycleStart + 1)/700.0f); //do at max 700 instructions per iteration


	for(uint32_t i = GlobalThreadSimulation.GlobalCycleStart; i <= GlobalThreadSimulation.GlobalCycleEnd; ++i){
		for(uint32_t j = 0; j < (uint32_t)settings.NumberOfTestClockCycles; ++j){
			if((i) == (uint32_t)settings.TestClockCycles[j]){
				GlobalThreadSimulation.TestClockCycles.push_back(i);
			}
			if((uint32_t)settings.TestClockCycles[j] > GlobalThreadSimulation.GlobalCycleEnd){
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

void Software::Prepare::Helper(Software::ConfigProbesStruct& probes, Software::HelperStruct& Helper){
	int ProbeIndex, RegisterIndex, BitIndex;
	std::string RegisterIndexAsString, BitIndexAsString;


	for(ProbeIndex = 0; ProbeIndex < probes.NumberOfProbes; ++ProbeIndex){

		RegisterIndexAsString = probes.ProbeName[ProbeIndex];
		BitIndexAsString = probes.ProbeName[ProbeIndex];

		//Normal probes
		if (probes.ProbeName[ProbeIndex][0] == 'R'){
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
		else if((strstr(probes.ProbeName[ProbeIndex], "MEM") != NULL) && (strstr(probes.ProbeName[ProbeIndex], "MEMSHADOW") == NULL)){ //if string contains mem but not memshadow
			Helper.ProbeMemory = true;

			BitIndexAsString = BitIndexAsString.substr(BitIndexAsString.find("[") + 1, BitIndexAsString.find("]") - BitIndexAsString.find("[") - 1);
			BitIndex = std::stoi(BitIndexAsString);

			Helper.MemoryProbesIncluded.emplace_back(BitIndex);
		}
		// memory shadow register probes
		else if((strstr(probes.ProbeName[ProbeIndex], "MEMSHADOW") != NULL)){
			Helper.ProbeMemoryShadowRegister = true;

			BitIndexAsString = BitIndexAsString.substr(BitIndexAsString.find("[") + 1, BitIndexAsString.find("]") - BitIndexAsString.find("[") - 1);
			BitIndex = std::stoi(BitIndexAsString);
			Helper.MemoryShadowRegisterProbesIncluded.emplace_back(BitIndex);
		}
		//horizontal probes
		else if(probes.ProbeName[ProbeIndex][0] == 'H'){
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
		else if(probes.ProbeName[ProbeIndex][0] == 'V'){

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
		else if((strstr(probes.ProbeName[ProbeIndex], "FULLHR") != NULL)){
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
		else if((strstr(probes.ProbeName[ProbeIndex], "FULLVR") != NULL)){
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
		else if((strstr(probes.ProbeName[ProbeIndex], "PF") != NULL)){
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
