#include "Software/Simulate.hpp"

void  Software::Simulate::GenerateInputs(std::vector<Software::SharedDataStruct>& SharedInputData, std::vector<Software::ThreadSimulationStruct>& ThreadSimulation, Software::SettingsStruct& Settings, boost::variate_generator<boost::mt19937&, boost::uniform_int<uint64_t>>& InputPrng){

	for(uint32_t simulation_idx = 0; simulation_idx < Settings.NumberOfStepSimulations; ++simulation_idx){
		//first select if fixed or random plaintext, then write inputs to memory
		uint32_t tmp_SelectedGroups = ((uint32_t)InputPrng()) % Settings.NumberOfGroups;
		#ifdef DEBUG
		std::cout << "simulation " << simulation_idx << " group: " << tmp_SelectedGroups << std::endl;
		#endif 
		

		uint8_t shared_param_found = 0;
		uint8_t initial_share_position = 0;
		uint8_t parameter_is_initialized = 0;

		for(int InputSimulationIndex = 0; InputSimulationIndex < Settings.InitialSim_NumberOfInputs; ++InputSimulationIndex){

			//split InitialSim_inputValues in shareIndex and position in group values
			parameter_is_initialized = Settings.InitialSim_IsInitialized[InputSimulationIndex] & 0x1;


			if((!shared_param_found) && (!parameter_is_initialized)){
				initial_share_position = InputSimulationIndex;
				shared_param_found = 1;
			}

			int ValueFull = Settings.InitialSim_InputsLength[InputSimulationIndex];
			std::fill(std::begin(SharedInputData.at(simulation_idx).ByteValuesOfParams[InputSimulationIndex]), std::end(SharedInputData.at(simulation_idx).ByteValuesOfParams[InputSimulationIndex]), 0);
			SharedInputData.at(simulation_idx).BytelengthOfParams[InputSimulationIndex] = ValueFull;
			SharedInputData.at(simulation_idx).StartaddrInRAM[InputSimulationIndex] = Settings.InitialSim_PositionInEmulatorRam[Settings.InitialSim_InputName[InputSimulationIndex]];
			SharedInputData.at(simulation_idx).VariableOrArrayParams[Settings.InitialSim_Inputs[0][InputSimulationIndex]] = Settings.InitialSim_IsInitialized[InputSimulationIndex] & 0x2;

			switch(parameter_is_initialized){ //check if input is pre-defined by user or not
				case(0): {//not predefined -> fill with values from randomly selected group
					for(int ValueIndex = 0; ValueIndex < ValueFull; ++ValueIndex){

						if(initial_share_position == InputSimulationIndex){
							for(int BitIndex = 0; BitIndex < 8; ++BitIndex){
								switch(Settings.Group_Values[tmp_SelectedGroups][(uint32_t)(Settings.InitialSim_Values[InputSimulationIndex][ValueIndex*8 + BitIndex])]){
									//write in corresponding parameter position (e.g. with 3 input parameters 0, 1 or 2) (first dimension) to byte position (depending on length of parameter)
									case(-1): SharedInputData.at(simulation_idx).ByteValuesOfParams[InputSimulationIndex][ValueIndex] |= ((InputPrng() % 2) << BitIndex); break;
									case(0):  break;
									case(1):  SharedInputData.at(simulation_idx).ByteValuesOfParams[InputSimulationIndex][ValueIndex] |= (1 << BitIndex);  break;
									default: std::cout << "In function InstantiateEmulator: unexpected value when writing memory!" << std::endl; exit(-1);
								}
							}

						}
						else{
							//generate random shares and mask initial input
							SharedInputData.at(simulation_idx).ByteValuesOfParams[InputSimulationIndex][ValueIndex] = InputPrng() % 256;
							SharedInputData.at(simulation_idx).ByteValuesOfParams[initial_share_position][ValueIndex] ^= SharedInputData.at(simulation_idx).ByteValuesOfParams[InputSimulationIndex][ValueIndex];
						}
					}

					break;
					

				}
				case(1): {//predefined . fill memory with user defined input
					for(int ValueIndex = 0; ValueIndex < ValueFull; ++ValueIndex){
						SharedInputData.at(simulation_idx).ByteValuesOfParams[Settings.InitialSim_Inputs[0][InputSimulationIndex]][ValueIndex] = (uint8_t)Settings.InitialSim_Values[InputSimulationIndex][ValueIndex];
					}
					break;
					
				}
				default: std::cout << "In function Instantiate_Emulator: unkown initialization state when writing memory" << std::endl; exit(-1);
			}

		}

		for(uint32_t thread_idx = 0; thread_idx < (uint32_t)Settings.Max_no_of_Threads; ++thread_idx){
			ThreadSimulation.at(thread_idx).SelectedGroups.at(simulation_idx) = tmp_SelectedGroups;//tmp % Settings.NumberOfGroups;
		}

	}

}


void Software::Simulate::Instantiate_Emulator(mulator::Emulator& emu, ::Software::ThreadSimulationStruct& ThreadSimulation, int simulation_idx, SettingsStruct& Settings, ::Software::SharedDataStruct& SharedData, uint32_t CycleStart, ::Software::ProbeTrackingStruct& ProbeTracker, ::Software::HelperStruct& Helper, std::vector<std::vector<std::vector<uint8_t>>>& ProbeValues){
    emu.set_flash_region(Settings.flash.offset, Settings.flash.size);
    emu.set_ram_region(Settings.ram.offset, Settings.ram.size);
    for(const auto& s: Settings.binary){
        emu.write_memory(s.offset, s.bytes.data(), s.bytes.size());
    }
    emu.write_register(mulator::Register::SP, Settings.ram.offset + Settings.ram.size);

	emu.write_register(mulator::Register::PC, Settings.main_address);
    emu.write_register(mulator::Register::LR, 0xFFFFFFFF);
	
	//write initial randomness to memory
	for(uint32_t i = 0; i < Settings.randomness_segment_length; ++i){
		uint8_t prng_out = emu.get_PRNG_randomness() & 0xff;
		emu.write_memory(Settings.randomness_start_addr + i, (uint8_t*)&prng_out, 1);
	}
	
	for(int InputSimulationIndex = 0; InputSimulationIndex < Settings.InitialSim_NumberOfInputs; ++InputSimulationIndex){
		for(uint32_t ByteIndex = 0; ByteIndex < SharedData.BytelengthOfParams[InputSimulationIndex]; ++ByteIndex){
			emu.write_memory(Settings.ram.offset + SharedData.StartaddrInRAM[InputSimulationIndex] + ByteIndex, &SharedData.ByteValuesOfParams[InputSimulationIndex][ByteIndex], 1);
		}

	}





	//simulate from main function until we reached function to analyze
	while(emu.emulate(Settings.start_address, 1,  Settings.randomness_start_addr, Settings.randomness_end_addr) != mulator::ReturnCode::END_ADDRESS_REACHED){

	}

	emu.emulateInstantiation(CycleStart, ThreadSimulation, ProbeTracker, Helper, ProbeValues, Settings.randomness_start_addr, Settings.randomness_end_addr, simulation_idx);



	/*
			DEBUG
	*/
	#ifdef DEBUG
	emu.emulate(2750, Settings.randomness_start_addr, Settings.randomness_end_addr);
	exit(-1);
	#endif

}

void Software::Simulate::Run(mulator::Emulator& Emu, ::Software::ThreadSimulationStruct& ThreadSimulation, SettingsStruct& Settings, ::Software::ProbeTrackingStruct& ProbeTracker, ::Software::HelperStruct& Helper, std::vector<std::vector<std::vector<uint8_t>>>& ProbeValues,  uint64_t SimulationIdx, uint32_t CycleSplit){

    for(uint32_t InstructionNr = ThreadSimulation.CycleStart.at(CycleSplit); InstructionNr <= ThreadSimulation.CycleEnd.at(CycleSplit); ++InstructionNr){
        Emu.emulate_PROLEAD(ThreadSimulation, ProbeTracker, Helper, ProbeValues, InstructionNr, SimulationIdx, Settings.randomness_start_addr, Settings.randomness_end_addr);
        
		//when instructionNr greater than biggest TestClockCycle in ThreadSimulation then break
		if((ThreadSimulation.TestClockCycles.empty()) || (InstructionNr > (uint32_t)ThreadSimulation.TestClockCycles.back())){
			break;
		}

    }

}