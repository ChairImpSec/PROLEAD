#include "Software/Probing.hpp"
#include <fstream>
#include <iostream>


void Software::Probing::CreateNormalProbe(std::vector<uint8_t>& NormalProbesRegister, std::vector<Software::ProbesStruct>& StandardProbes, std::vector<std::vector<uint8_t>>& ProbeValueRegister, uint32_t& ProbeIndex, uint64_t& ProbeInfo, uint32_t RegisterTransitionCycle, uint32_t InstrNr, uint64_t SimulationIdx, uint32_t DestinationRegisterValue, uint8_t RegNr){
    for(const auto& BitIdx: NormalProbesRegister){
        StandardProbes.at(ProbeIndex).ProbeInfo = (ProbeInfo | (RegNr << REG1_OFFSET) | (BitIdx << BIT_OFFSET));
        StandardProbes.at(ProbeIndex).TransitionCycles = RegisterTransitionCycle;
        ProbeValueRegister.at(BitIdx).at(InstrNr) |= (((DestinationRegisterValue >> BitIdx) & 1) << (SimulationIdx & 0x7));
        ProbeIndex++;
    }
}

void Software::Probing::CreateHorizontalProbe(std::vector<Software::ProbesStruct>& StandardProbes, uint32_t RegisterTransitionCycle, uint8_t ExtensionSize, uint32_t& ProbeIndex, uint32_t InstrNr, uint8_t RegisterNumber){
    uint64_t ProbeInfo = (static_cast<uint64_t>(InstrNr) << CYCLE_OFFSET) | (5 << ID_OFFSET)  | (RegisterNumber << REG1_OFFSET) | ExtensionSize;
    StandardProbes.at(ProbeIndex).ProbeInfo = (ProbeInfo);
    StandardProbes.at(ProbeIndex).TransitionCycles = RegisterTransitionCycle;

    ProbeIndex++;

}

void Software::Probing::CreateLargeVerticalProbe(std::vector<Software::ProbesStruct>& StandardProbes, uint64_t& ProbeInfo , uint32_t& ProbeIndex, uint32_t TransCycleRegNr, uint32_t TransCyclePartnerRegNr){

    StandardProbes.at(ProbeIndex).ProbeInfo = ProbeInfo;
    StandardProbes.at(ProbeIndex).TransitionCycles = TransCycleRegNr | (static_cast<uint64_t>(TransCyclePartnerRegNr) << 32);

    ProbeIndex++;

}

void Software::Probing::CreateSmallVerticalProbe(std::vector<Software::ProbesStruct>& StandardProbes, uint64_t& ProbeInfo , uint32_t& ProbeIndex, uint32_t TransCycleRegNr, uint32_t CyclePartnerRegNr){

    StandardProbes.at(ProbeIndex).ProbeInfo = ProbeInfo;
    StandardProbes.at(ProbeIndex).TransitionCycles = TransCycleRegNr | (static_cast<uint64_t>(CyclePartnerRegNr) << 32);

    ProbeIndex++;
}

void Software::Probing::CreateLargeFullHorizontalProbe(std::vector<Software::ProbesStruct>& StandardProbes, uint64_t& ProbeInfo , uint32_t& ProbeIndex, uint32_t TransCycleRegNr, uint32_t TransCyclePartnerRegNr){

    StandardProbes.at(ProbeIndex).ProbeInfo = ProbeInfo;
    StandardProbes.at(ProbeIndex).TransitionCycles = TransCycleRegNr | (static_cast<uint64_t>(TransCyclePartnerRegNr) << 32); //cycles of current values in ProbeTracker.RegisterLatestClockCycle, transitions in ProbeTracker.VerticalLatestClockCycle

    ProbeIndex++;

}

void Software::Probing::CreateSmallFullHorizontalProbe(std::vector<Software::ProbesStruct>& StandardProbes, uint64_t& ProbeInfo , uint32_t& ProbeIndex, uint32_t TransCycleRegNr, uint32_t CyclePartnerRegNr){
    StandardProbes.at(ProbeIndex).ProbeInfo = ProbeInfo;
    StandardProbes.at(ProbeIndex).TransitionCycles = TransCycleRegNr | (static_cast<uint64_t>(CyclePartnerRegNr) << 32);

    ProbeIndex++;

}


void Software::Probing::CreateLargeFullVerticalProbe(std::vector<Software::ProbesStruct>& StandardProbes, std::vector<uint8_t>& FullVerticalProbes, uint8_t BitIdx, uint8_t RegNr, uint32_t& ProbeIndex, uint64_t ProbeInfo, std::vector<uint32_t>& RegisterValues, uint32_t TransValueRegNr, uint32_t TransValuePC, uint32_t TransValuePSR){
	uint32_t probedValues = 0;
	for(const auto& RegisterIndex: FullVerticalProbes){
		probedValues |= ((RegisterValues[RegisterIndex] >> BitIdx) & 0x1) << RegisterIndex;
	}

	//add transition probes
	probedValues |= ((TransValueRegNr >> BitIdx) & 0x1)	 << 17;
	probedValues |= ((TransValuePC >> BitIdx) & 0x1)	 << 18;
	probedValues |= ((TransValuePSR >> BitIdx) & 0x1)	 << 19;

	uint8_t ExtensionSize = FullVerticalProbes.size() + (uint8_t)std::binary_search(FullVerticalProbes.begin(), FullVerticalProbes.end(), RegNr) + (uint8_t)std::binary_search(FullVerticalProbes.begin(), FullVerticalProbes.end(), 15) + (uint8_t)std::binary_search(FullVerticalProbes.begin(), FullVerticalProbes.end(), 16);
	StandardProbes.at(ProbeIndex).ProbeInfo = ProbeInfo  | (BitIdx << BIT_OFFSET) | (ExtensionSize);
	StandardProbes.at(ProbeIndex).TransitionCycles = probedValues;
	ProbeIndex++;
}

void Software::Probing::CreateSmallFullVerticalProbe(std::vector<Software::ProbesStruct>& StandardProbes, std::vector<uint8_t>& FullVerticalProbes, uint8_t BitIdx, uint8_t RegNr1, uint8_t RegNr2, uint32_t& ProbeIndex, uint64_t ProbeInfo, std::vector<uint32_t>& RegisterValues, uint32_t TransValueReg1, uint32_t TransValueReg2){

	uint32_t probedValues = 0;
	for(const auto& RegisterIndex: FullVerticalProbes){
		probedValues |= ((RegisterValues[RegisterIndex] >> BitIdx) & 0x1) << RegisterIndex;
	}

	//add transition probes
	probedValues |= ((TransValueReg1 >> BitIdx) & 0x1)	 << 17;
	probedValues |= ((TransValueReg2 >> BitIdx) & 0x1)	 << 18;

	uint8_t ExtensionSize = FullVerticalProbes.size() + (uint8_t)std::binary_search(FullVerticalProbes.begin(), FullVerticalProbes.end(), RegNr1) + (uint8_t)std::binary_search(FullVerticalProbes.begin(), FullVerticalProbes.end(), RegNr2);
	StandardProbes.at(ProbeIndex).ProbeInfo = ProbeInfo | (BitIdx << BIT_OFFSET) | (ExtensionSize);
	StandardProbes.at(ProbeIndex).TransitionCycles = probedValues;
	ProbeIndex++;

}

void Software::Probing::CreateOneRegisterOnlyFullVerticalProbe(std::vector<Software::ProbesStruct>& StandardProbes, std::vector<uint8_t>& FullVerticalProbes, uint8_t BitIdx, uint8_t RegNr1, uint32_t& ProbeIndex, uint64_t ProbeInfo, std::vector<uint32_t>& RegisterValues, uint32_t TransValueRegNr){
	uint32_t probedValues = 0;
	for(const auto& RegisterIndex: FullVerticalProbes){
		probedValues |= ((RegisterValues[RegisterIndex] >> BitIdx) & 0x1) << RegisterIndex;
	}

	//add transition probes
	probedValues |= ((TransValueRegNr >> BitIdx) & 0x1)	 << 17;

	uint8_t ExtensionSize = FullVerticalProbes.size() + (uint8_t)std::binary_search(FullVerticalProbes.begin(), FullVerticalProbes.end(), RegNr1);
	StandardProbes.at(ProbeIndex).ProbeInfo = ProbeInfo  | (BitIdx << BIT_OFFSET) | (ExtensionSize);
	StandardProbes.at(ProbeIndex).TransitionCycles = probedValues;
	ProbeIndex++;

}

void Software::Probing::CreateDSPLargeFullVerticalProbe(std::vector<Software::ProbesStruct>& StandardProbes, std::vector<uint8_t>& FullVerticalProbes, uint8_t BitIdx, uint8_t low_RegNr, uint8_t high_RegNr, uint32_t& ProbeIndex, uint64_t ProbeInfo, std::vector<uint32_t>& RegisterValues, uint32_t TransValueLowRegNr, uint32_t TransValueHighRegNr, uint32_t TransValuePC, uint32_t TransValuePSR){
	uint32_t probedValues = 0;
	for(const auto& RegisterIndex: FullVerticalProbes){
		probedValues |= ((RegisterValues[RegisterIndex] >> BitIdx) & 0x1) << RegisterIndex;
	}

	//add transition probes
	probedValues |= ((TransValueLowRegNr >> BitIdx) & 0x1)	 << 17;
	probedValues |= ((TransValueHighRegNr >> BitIdx) & 0x1)	 << 18;
	probedValues |= ((TransValuePC >> BitIdx) & 0x1)	 << 19;
	probedValues |= ((TransValuePSR >> BitIdx) & 0x1)	 << 20;

	uint8_t ExtensionSize = FullVerticalProbes.size() + (uint8_t)std::binary_search(FullVerticalProbes.begin(), FullVerticalProbes.end(), low_RegNr) + (uint8_t)std::binary_search(FullVerticalProbes.begin(), FullVerticalProbes.end(), high_RegNr) + (uint8_t)std::binary_search(FullVerticalProbes.begin(), FullVerticalProbes.end(), 15) + (uint8_t)std::binary_search(FullVerticalProbes.begin(), FullVerticalProbes.end(), 16);
	StandardProbes.at(ProbeIndex).ProbeInfo = ProbeInfo  | (BitIdx << BIT_OFFSET) | (ExtensionSize);
	StandardProbes.at(ProbeIndex).TransitionCycles = probedValues;
	ProbeIndex++;
}

void Software::Probing::CreateDSPSmallFullVerticalProbe(std::vector<Software::ProbesStruct>& StandardProbes, std::vector<uint8_t>& FullVerticalProbes, uint8_t BitIdx, uint8_t low_RegNr, uint8_t high_RegNr, uint32_t& ProbeIndex, uint64_t ProbeInfo, std::vector<uint32_t>& RegisterValues, uint32_t TransValueLowRegNr, uint32_t TransValueHighRegNr, uint32_t TransValuePC){
	uint32_t probedValues = 0;
	for(const auto& RegisterIndex: FullVerticalProbes){
		probedValues |= ((RegisterValues[RegisterIndex] >> BitIdx) & 0x1) << RegisterIndex;
	}

	//add transition probes
	probedValues |= ((TransValueLowRegNr >> BitIdx) & 0x1)	 << 17;
	probedValues |= ((TransValueHighRegNr >> BitIdx) & 0x1)	 << 18;
	probedValues |= ((TransValuePC >> BitIdx) & 0x1)	 << 19;

	uint8_t ExtensionSize = FullVerticalProbes.size() + (uint8_t)std::binary_search(FullVerticalProbes.begin(), FullVerticalProbes.end(), low_RegNr) + (uint8_t)std::binary_search(FullVerticalProbes.begin(), FullVerticalProbes.end(), high_RegNr) + (uint8_t)std::binary_search(FullVerticalProbes.begin(), FullVerticalProbes.end(), 15);
	StandardProbes.at(ProbeIndex).ProbeInfo = ProbeInfo  | (BitIdx << BIT_OFFSET) | (ExtensionSize);
	StandardProbes.at(ProbeIndex).TransitionCycles = probedValues;
	ProbeIndex++;
}

void Software::Probing::CreateMemShadowProbe(std::vector<Software::ProbesStruct>& StandardProbes, std::vector<uint8_t>& MemoryShadowRegisterProbesIncluded,  uint64_t ProbeInfo, uint32_t& ProbeIndex, uint32_t memory_shadow_register, uint32_t next_shadow_register_value, uint32_t TransitionCycle){

    for(auto& BitIdx: MemoryShadowRegisterProbesIncluded){
        StandardProbes.at(ProbeIndex).ProbeInfo = (ProbeInfo | (BitIdx << BIT_OFFSET));
        StandardProbes.at(ProbeIndex).TransitionCycles = ((static_cast<uint64_t>(memory_shadow_register) << 32) | (next_shadow_register_value));
        StandardProbes.at(ProbeIndex).SpecialInfo = TransitionCycle;//ProbeTracker.MemoryLatestClockCycle;
        ProbeIndex++;
    }

}


void Software::Probing::CreateSeperateLoadStoreMemShadowProbe(std::vector<Software::ProbesStruct>& StandardProbes, std::vector<uint8_t>& MemoryShadowRegisterProbesIncluded, uint32_t RegNr,  uint32_t InstrNr, uint32_t& ProbeIndex, uint32_t load_store_memory_shadow_register, uint32_t next_load_store_shadow_register_value, uint32_t TransitionCycle, uint32_t ExtensionSize, uint32_t LoadStoreFlag){

	//LoadStoreFlag == 1 -> Load
	//LoadStoreFlag == 0 -> Store
	uint64_t ProbeInfo = (static_cast<uint64_t>(InstrNr) << 32) | (2 << ID_OFFSET) | (LoadStoreFlag << REG1_OFFSET) | (RegNr << REG2_OFFSET) | (ExtensionSize);
    
	for(auto& BitIdx: MemoryShadowRegisterProbesIncluded){
        StandardProbes.at(ProbeIndex).ProbeInfo = (ProbeInfo | (BitIdx << BIT_OFFSET));
        StandardProbes.at(ProbeIndex).TransitionCycles = ((static_cast<uint64_t>(load_store_memory_shadow_register) << 32) | (next_load_store_shadow_register_value));
        StandardProbes.at(ProbeIndex).SpecialInfo = TransitionCycle;
        ProbeIndex++;
    }

}

void Software::Probing::CreateHorizontalMemShadowProbe(std::vector<Software::ProbesStruct>& StandardProbes, uint32_t InstrNr, uint32_t& ProbeIndex, uint8_t RegNr, uint32_t memory_shadow_register, uint32_t next_shadow_register_value, uint32_t TransitionCycle, uint32_t ExtensionSize){
    uint64_t ProbeInfo = (static_cast<uint64_t>(InstrNr) << CYCLE_OFFSET) | (3 << ID_OFFSET) | (RegNr << REG1_OFFSET) | ExtensionSize;
    StandardProbes.at(ProbeIndex).ProbeInfo = (ProbeInfo);
    StandardProbes.at(ProbeIndex).TransitionCycles =  ((static_cast<uint64_t>(memory_shadow_register) << 32) | (next_shadow_register_value));
	StandardProbes.at(ProbeIndex).SpecialInfo = TransitionCycle;
	ProbeIndex++;
}

void Software::Probing::CreatePipelineForwardingProbe(std::vector<Software::ProbesStruct>& StandardProbes, std::vector<uint8_t>& PipelineForwardingProbes, uint8_t BitIdx, uint32_t& ProbeIndex, uint64_t ProbeInfo, uint32_t NrOfPipelineStages, std::vector<::mulator::CPU_State>& pipeline_cpu_states){

	
	uint32_t bit_pos_ctr = 0;

	//use TransitionCycles and SpecialInfo to store the probe values. both together have space for 128 bits. We can have at max. a 6 stage pipeline. If all 17 registers (r0-r16) are probed in 6 stages we get: 17*6 = 102
    uint64_t tmp_TransitionCycles =  0;
	uint64_t tmp_SpecialInfo = 0;

	for(uint32_t pipeline_idx = 0; pipeline_idx < NrOfPipelineStages; ++pipeline_idx){ //go over every pipeline stage
		if(pipeline_cpu_states.at(pipeline_idx).containing_valid_pipeline_values){ //only add values if registers are valid
			for(const auto& RegIdx : PipelineForwardingProbes){
				if(bit_pos_ctr >= 64){
					tmp_SpecialInfo |= (static_cast<uint64_t>((((pipeline_cpu_states.at(pipeline_idx).registers[RegIdx] >> BitIdx) & 0x1)) << (bit_pos_ctr - 64)));
				}
				else{
					tmp_TransitionCycles |= (static_cast<uint64_t>((((pipeline_cpu_states.at(pipeline_idx).registers[RegIdx] >> BitIdx) & 0x1)) << (bit_pos_ctr)));
				}
				bit_pos_ctr++;
			}
		}
	}

	StandardProbes.at(ProbeIndex).TransitionCycles = tmp_TransitionCycles;
	StandardProbes.at(ProbeIndex).SpecialInfo = tmp_SpecialInfo;


	StandardProbes.at(ProbeIndex).ProbeInfo = (ProbeInfo | (BitIdx << BIT_OFFSET) | (bit_pos_ctr));
	ProbeIndex++;
}

void Software::Probing::ExtractAllProbeInfo(uint8_t& Register, uint8_t& Id, uint8_t& PartnerRegister, uint32_t& Cycle, uint8_t& Bit, uint16_t& ExtensionSize, uint8_t& Dependency, Software::ProbesStruct& ProbeFromProbingSet){

    Register = (ProbeFromProbingSet.ProbeInfo & REG1_MASK) >> REG1_OFFSET;
    Id = (ProbeFromProbingSet.ProbeInfo & ID_MASK) >> ID_OFFSET;
    PartnerRegister = (ProbeFromProbingSet.ProbeInfo & REG2_MASK) >> REG2_OFFSET;
    Cycle = ProbeFromProbingSet.ProbeInfo >> CYCLE_OFFSET;
    Bit = (ProbeFromProbingSet.ProbeInfo & BIT_MASK) >> BIT_OFFSET;
    ExtensionSize = (ProbeFromProbingSet.ProbeInfo & EXTENSION_MASK);
    Dependency = (ProbeFromProbingSet.ProbeInfo >> DEPENDENCY_OFFSET) & DEPENDENCY_MASK;

}

void Software::Probing::ExtractRegisterProbeInfo(uint8_t& Register, Software::ProbesStruct& ProbeFromProbingSet){
	Register = (ProbeFromProbingSet.ProbeInfo & REG1_MASK) >> REG1_OFFSET;
}

void Software::Probing::ExtractBitProbeInfo(uint8_t& Bit, Software::ProbesStruct& ProbeFromProbingSet){
	Bit = (ProbeFromProbingSet.ProbeInfo & BIT_MASK) >> BIT_OFFSET;
}

void Software::Probing::ExtractCycleProbeInfo(uint32_t& Cycle, Software::ProbesStruct& ProbeFromProbingSet){
	Cycle = ProbeFromProbingSet.ProbeInfo >> CYCLE_OFFSET;
}

void Software::Probing::ExtractIdProbeInfo(uint8_t& Id, Software::ProbesStruct& ProbeFromProbingSet){
	Id = (ProbeFromProbingSet.ProbeInfo & ID_MASK) >> ID_OFFSET;
}

void Software::Probing::ExtractDependencyProbeInfo(uint8_t& Dependency, Software::ProbesStruct& ProbeFromProbingSet){
	Dependency = (ProbeFromProbingSet.ProbeInfo >> DEPENDENCY_OFFSET) & DEPENDENCY_MASK;
}

void Software::Probing::ExtractExtensionSizeProbeInfo(uint16_t& ExtensionSize, Software::ProbesStruct& ProbeFromProbingSet){
	ExtensionSize = (ProbeFromProbingSet.ProbeInfo & EXTENSION_MASK);
}


void Software::Probing::ProbeInfoToStandardProbeMapping(std::vector<std::vector<uint32_t>>& ProbeMapping, Software::HelperStruct& Helper, Software::SettingsStruct& Setting){

	uint8_t IdOffset = 15;
	uint8_t RegNrOffset = 10;
	uint8_t TransitionOffset = 19;
	uint8_t BitOffset = 0;
	uint8_t PartnerRegOffset = 5;

	ProbeMapping.resize((uint32_t)pow(2,20));

	//resolve memory probes
	for(uint8_t RegNr = 0; RegNr <= 15; ++RegNr){
		for(const auto& BitIdx: Helper.MemoryProbesIncluded){
			uint32_t ProbeInfo = (0 << IdOffset) | (RegNr << RegNrOffset) | (BitIdx << BitOffset);
			uint32_t Probe = (18 << RegNrOffset) | (BitIdx << BitOffset);
			ProbeMapping.at(ProbeInfo).emplace_back(Probe);
			if(Setting.TestTransitional){
				Probe |= (1 << TransitionOffset);
				ProbeMapping.at(ProbeInfo).emplace_back(Probe);
			}
			std::sort(ProbeMapping.at(ProbeInfo).begin(), ProbeMapping.at(ProbeInfo).end());
		}
	}

	//resolve Shadow Register probes
	for(uint8_t RegNr = 0; RegNr <= 15; ++RegNr){
		for(const auto& BitIdx: Helper.MemoryShadowRegisterProbesIncluded){
			uint32_t ProbeInfo = (1 << IdOffset) | (RegNr << RegNrOffset) | (BitIdx << BitOffset);
			uint32_t Probe = (RegNr << RegNrOffset) | (BitIdx << BitOffset);
			ProbeMapping.at(ProbeInfo).emplace_back(Probe);
			if(Setting.TestTransitional){
				Probe |= (1 << TransitionOffset);
				ProbeMapping.at(ProbeInfo).emplace_back(Probe);
			}
			std::sort(ProbeMapping.at(ProbeInfo).begin(), ProbeMapping.at(ProbeInfo).end());
		}
	}

	//resolve Store Shadow Register probes
	for(uint8_t RegNr = 0; RegNr <= 15; ++RegNr){
		for(const auto& BitIdx: Helper.MemoryShadowRegisterProbesIncluded){
			uint32_t ProbeInfo = (2 << IdOffset) | (0 << RegNrOffset) | (BitIdx << BitOffset) | (RegNr << PartnerRegOffset);			
			uint32_t Probe = (RegNr << RegNrOffset) | (BitIdx << BitOffset);
			ProbeMapping.at(ProbeInfo).emplace_back(Probe);
			if(Setting.TestTransitional){
				Probe |= (1 << TransitionOffset);
				ProbeMapping.at(ProbeInfo).emplace_back(Probe);
			}
			std::sort(ProbeMapping.at(ProbeInfo).begin(), ProbeMapping.at(ProbeInfo).end());
		}
	}

	//resolve Load Shadow Register probes
	for(uint8_t RegNr = 0; RegNr <= 15; ++RegNr){
		for(const auto& BitIdx: Helper.MemoryShadowRegisterProbesIncluded){
			uint32_t ProbeInfo = (2 << IdOffset) | (1 << RegNrOffset) | (BitIdx << BitOffset) | (RegNr << PartnerRegOffset);
			uint32_t Probe = (RegNr << RegNrOffset) | (BitIdx << BitOffset);
			ProbeMapping.at(ProbeInfo).emplace_back(Probe);
			if(Setting.TestTransitional){
				Probe |= (1 << TransitionOffset);
				ProbeMapping.at(ProbeInfo).emplace_back(Probe);
			}
			std::sort(ProbeMapping.at(ProbeInfo).begin(), ProbeMapping.at(ProbeInfo).end());
		}
	}

	//resolve Horizontal Shadow Register probes
	for(uint8_t RegNr = 0; RegNr <= 15; ++RegNr){
		uint32_t ProbeInfo = (3 << IdOffset) | (RegNr << RegNrOffset);
		for(const auto& BitIdx: Helper.HorizontalBitsIncluded.at(17)){
			uint32_t Probe = (RegNr << RegNrOffset) | (BitIdx << BitOffset);
			ProbeMapping.at(ProbeInfo).emplace_back(Probe);
			if(Setting.TestTransitional){
				Probe |= (1 << TransitionOffset);
				ProbeMapping.at(ProbeInfo).emplace_back(Probe);
			}
			std::sort(ProbeMapping.at(ProbeInfo).begin(), ProbeMapping.at(ProbeInfo).end());
		}
	}
	

	//resolve Normal probes
	for(uint8_t RegNr = 0; RegNr < 17; ++RegNr){
		for(uint8_t BitIdx = 0; BitIdx < 32; ++BitIdx){
			uint32_t ProbeInfo = (4 << IdOffset) | (RegNr << RegNrOffset) | (BitIdx << BitOffset);
			uint32_t Probe = (RegNr << RegNrOffset) | (BitIdx << BitOffset);
			ProbeMapping.at(ProbeInfo).emplace_back(Probe);
			if(Setting.TestTransitional){
				Probe |= (1 << TransitionOffset);
				ProbeMapping.at(ProbeInfo).emplace_back(Probe);
			}
			std::sort(ProbeMapping.at(ProbeInfo).begin(), ProbeMapping.at(ProbeInfo).end());
		}
	}

	//resolve Horizontal probes
	for(uint8_t RegNr = 0; RegNr < 17; ++RegNr){
		uint32_t ProbeInfo = (5 << IdOffset) | (RegNr << RegNrOffset);
		for(const auto& BitIdx: Helper.HorizontalBitsIncluded.at(RegNr)){
			uint32_t Probe = (RegNr << RegNrOffset) | (BitIdx << BitOffset);
			ProbeMapping.at(ProbeInfo).emplace_back(Probe);
			if(Setting.TestTransitional){
				Probe |= (1 << TransitionOffset);
				ProbeMapping.at(ProbeInfo).emplace_back(Probe);
			}
			std::sort(ProbeMapping.at(ProbeInfo).begin(), ProbeMapping.at(ProbeInfo).end());
		}
	}


	//resolve small vertical probes
	for(uint8_t RegNr = 0; RegNr < 17; ++RegNr){
		for(uint8_t PartnerRegNr = 0; PartnerRegNr < 17; ++PartnerRegNr){
			if(PartnerRegNr != RegNr){
				for(uint8_t BitIdx = 0; BitIdx < 32; ++BitIdx){
					uint32_t ProbeInfo = (6 << IdOffset) | (RegNr << RegNrOffset) | (PartnerRegNr << PartnerRegOffset) | (BitIdx << BitOffset);
					uint32_t Probe = (RegNr << RegNrOffset) | (BitIdx << BitOffset);
					ProbeMapping.at(ProbeInfo).emplace_back(Probe);
					if(Setting.TestTransitional){
						Probe |= (1 << TransitionOffset);
						ProbeMapping.at(ProbeInfo).emplace_back(Probe);
					}
					Probe = (PartnerRegNr << RegNrOffset) | (BitIdx << BitOffset);
					ProbeMapping.at(ProbeInfo).emplace_back(Probe);

					std::sort(ProbeMapping.at(ProbeInfo).begin(), ProbeMapping.at(ProbeInfo).end());
				}
			}
		}
	}

	//resolve large vertical probes
	for(uint8_t RegNr = 0; RegNr < 17; ++RegNr){
		for(uint8_t PartnerRegNr = 0; PartnerRegNr < 17; ++PartnerRegNr){
			if(PartnerRegNr != RegNr){
				for(uint8_t BitIdx = 0; BitIdx < 32; ++BitIdx){
					uint32_t ProbeInfo = (7 << IdOffset) | (RegNr << RegNrOffset) | (PartnerRegNr << PartnerRegOffset) | (BitIdx << BitOffset);
					uint32_t Probe = (RegNr << RegNrOffset) | (BitIdx << BitOffset);
					ProbeMapping.at(ProbeInfo).emplace_back(Probe);
					if(Setting.TestTransitional){
						Probe |= (1 << TransitionOffset);
						ProbeMapping.at(ProbeInfo).emplace_back(Probe);
					}
					Probe = (PartnerRegNr << RegNrOffset) | (BitIdx << BitOffset);
					ProbeMapping.at(ProbeInfo).emplace_back(Probe);
					if(Setting.TestTransitional){
						Probe |= (1 << TransitionOffset);
						ProbeMapping.at(ProbeInfo).emplace_back(Probe);
					}
					std::sort(ProbeMapping.at(ProbeInfo).begin(), ProbeMapping.at(ProbeInfo).end());
				}
			}
		}
	}


	//resolve small Full Horizontal probes
	for(uint8_t RegNr = 0; RegNr < 17; ++RegNr){
		for(uint8_t PartnerRegNr = 0; PartnerRegNr < 17; ++PartnerRegNr){
			if(PartnerRegNr != RegNr){
				uint32_t ProbeInfo = (8 << IdOffset) | (RegNr << RegNrOffset) | (PartnerRegNr << PartnerRegOffset);
				for(const auto& BitIdx: Helper.NormalProbesIncluded.at(RegNr)){
					uint32_t Probe = (RegNr << RegNrOffset) | (BitIdx);
					ProbeMapping.at(ProbeInfo).emplace_back(Probe);
					if(Setting.TestTransitional){
						Probe |= (1 << TransitionOffset);
						ProbeMapping.at(ProbeInfo).emplace_back(Probe);
					}
				}
				for(const auto& BitIdx: Helper.NormalProbesIncluded.at(PartnerRegNr)){
					uint32_t Probe = (PartnerRegNr << RegNrOffset) | (BitIdx);
					ProbeMapping.at(ProbeInfo).emplace_back(Probe);
				}
				std::sort(ProbeMapping.at(ProbeInfo).begin(), ProbeMapping.at(ProbeInfo).end());
			}
		}
	}

	//resolve large Full Horizontal probes
	for(uint8_t RegNr = 0; RegNr < 17; ++RegNr){
		for(uint8_t PartnerRegNr = 0; PartnerRegNr < 17; ++PartnerRegNr){
			if(PartnerRegNr != RegNr){
				uint32_t ProbeInfo = (9 << IdOffset) | (RegNr << RegNrOffset) | (PartnerRegNr << PartnerRegOffset);
				for(const auto& BitIdx: Helper.NormalProbesIncluded.at(RegNr)){
					uint32_t Probe = (RegNr << RegNrOffset) | (BitIdx);
					ProbeMapping.at(ProbeInfo).emplace_back(Probe);
					if(Setting.TestTransitional){
						Probe |= (1 << TransitionOffset);
						ProbeMapping.at(ProbeInfo).emplace_back(Probe);
					}
				}
				for(const auto& BitIdx: Helper.NormalProbesIncluded.at(PartnerRegNr)){
					uint32_t Probe = (PartnerRegNr << RegNrOffset) | (BitIdx);
					ProbeMapping.at(ProbeInfo).emplace_back(Probe);
					if(Setting.TestTransitional){
						Probe |= (1 << TransitionOffset);
						ProbeMapping.at(ProbeInfo).emplace_back(Probe);
					}
				}
				std::sort(ProbeMapping.at(ProbeInfo).begin(), ProbeMapping.at(ProbeInfo).end());
			}
		}
	}

	//resolve special case Full Vertical probes
	for(uint8_t RegNr = 0; RegNr < 17; ++RegNr){
		for(uint8_t BitIdx = 0; BitIdx < 32; ++BitIdx){
			uint32_t ProbeInfo = (12 << IdOffset) | (RegNr << RegNrOffset) | (BitIdx << BitOffset);
			for(const auto& RegIdx: Helper.FullVerticalProbesIncluded.at(BitIdx)){
				uint32_t Probe = (RegIdx << RegNrOffset) | (BitIdx);
				ProbeMapping.at(ProbeInfo).emplace_back(Probe);
				if(Setting.TestTransitional && (RegIdx == RegNr)){
					Probe |= (1 << TransitionOffset);
					ProbeMapping.at(ProbeInfo).emplace_back(Probe);
				}
			}
			std::sort(ProbeMapping.at(ProbeInfo).begin(), ProbeMapping.at(ProbeInfo).end());
		}
	}

	//resolve small Full Vertical probes
	for(uint8_t RegNr = 0; RegNr < 17; ++RegNr){
		for(uint8_t PartnerRegNr = 0; PartnerRegNr < 17; ++PartnerRegNr){
			for(uint8_t BitIdx = 0; BitIdx < 32; ++BitIdx){
				if((RegNr != PartnerRegNr)){
					uint32_t ProbeInfo = (10 << IdOffset) | (RegNr << RegNrOffset) | (PartnerRegNr << PartnerRegOffset) | (BitIdx << BitOffset);
					for(const auto& RegIdx: Helper.FullVerticalProbesIncluded.at(BitIdx)){
						uint32_t Probe = (RegIdx << RegNrOffset) | (BitIdx);
						ProbeMapping.at(ProbeInfo).emplace_back(Probe);
						if(Setting.TestTransitional && ((RegIdx == RegNr) || (RegIdx == PartnerRegNr))){
							Probe |= (1 << TransitionOffset);
							ProbeMapping.at(ProbeInfo).emplace_back(Probe);
						}
					}
					std::sort(ProbeMapping.at(ProbeInfo).begin(), ProbeMapping.at(ProbeInfo).end());
				}
			}
		}
	}

	//resolve large Full Vertical probes
	for(uint8_t RegNr = 0; RegNr < 17; ++RegNr){
		for(uint8_t BitIdx = 0; BitIdx < 32; ++BitIdx){
			uint32_t ProbeInfo = (11 << IdOffset) | (RegNr << RegNrOffset) | (BitIdx << BitOffset);
			for(const auto& RegIdx: Helper.FullVerticalProbesIncluded.at(BitIdx)){
				uint32_t Probe = (RegIdx << RegNrOffset) | (BitIdx);
				ProbeMapping.at(ProbeInfo).emplace_back(Probe);
				if(Setting.TestTransitional && ((RegIdx == RegNr) || (RegIdx == 15) || (RegIdx == 16))){
					Probe |= (1 << TransitionOffset);
					ProbeMapping.at(ProbeInfo).emplace_back(Probe);
				}
			}
			std::sort(ProbeMapping.at(ProbeInfo).begin(), ProbeMapping.at(ProbeInfo).end());
		}
	}


	//resolve small DSP Full Vertical probes, RdHi + RdLo + PC transition
	for(uint8_t RegNr = 0; RegNr < 17; ++RegNr){
		for(uint8_t PartnerRegNr = 0; PartnerRegNr < 17; ++PartnerRegNr){
			if(RegNr != PartnerRegNr){
				for(uint8_t BitIdx = 0; BitIdx < 32; ++BitIdx){
					uint32_t ProbeInfo = (13 << IdOffset) | (RegNr << RegNrOffset) | (PartnerRegNr << PartnerRegOffset) | (BitIdx << BitOffset);
					for(const auto& ProbeRegNr: Helper.FullVerticalProbesIncluded.at(BitIdx << BitOffset)){
						uint32_t Probe = (ProbeRegNr << 11) | (BitIdx);
						ProbeMapping.at(ProbeInfo).emplace_back(Probe);
						if(Setting.TestTransitional){
							if(ProbeRegNr == RegNr){
								Probe |= (1 << TransitionOffset);
								ProbeMapping.at(ProbeInfo).emplace_back(Probe);
							}
							if(ProbeRegNr == PartnerRegNr){
								Probe |= (1 << TransitionOffset);
								ProbeMapping.at(ProbeInfo).emplace_back(Probe);
							}
							if(ProbeRegNr == 15){
								Probe |= (1 << TransitionOffset);
								ProbeMapping.at(ProbeInfo).emplace_back(Probe);
							}
						}
					}
					std::sort(ProbeMapping.at(ProbeInfo).begin(), ProbeMapping.at(ProbeInfo).end());
				}
			}
		}
	}

	//resolve large DSP Full Vertical probes, RdHi + RdLo + PC + PSR transition
	for(uint8_t RegNr = 0; RegNr < 17; ++RegNr){
		for(uint8_t PartnerRegNr = 0; PartnerRegNr < 17; ++PartnerRegNr){
			if(RegNr != PartnerRegNr){
				for(uint8_t BitIdx = 0; BitIdx < 32; ++BitIdx){
					uint32_t ProbeInfo = (14 << IdOffset) | (RegNr << RegNrOffset) | (PartnerRegNr << PartnerRegOffset) | (BitIdx << BitOffset);
					for(const auto& ProbeRegNr: Helper.FullVerticalProbesIncluded.at(BitIdx << BitOffset)){
						uint32_t Probe = (ProbeRegNr << 11) | (BitIdx);
						ProbeMapping.at(ProbeInfo).emplace_back(Probe);
						if(Setting.TestTransitional){
							if(ProbeRegNr == RegNr){
								Probe |= (1 << TransitionOffset);
								ProbeMapping.at(ProbeInfo).emplace_back(Probe);
							}
							if(ProbeRegNr == PartnerRegNr){
								Probe |= (1 << TransitionOffset);
								ProbeMapping.at(ProbeInfo).emplace_back(Probe);
							}
							if(ProbeRegNr == 15){
								Probe |= (1 << TransitionOffset);
								ProbeMapping.at(ProbeInfo).emplace_back(Probe);
							}
							if(ProbeRegNr == 16){
								Probe |= (1 << TransitionOffset);
								ProbeMapping.at(ProbeInfo).emplace_back(Probe);
							}
						}
					}
					std::sort(ProbeMapping.at(ProbeInfo).begin(), ProbeMapping.at(ProbeInfo).end());
				}
			}
		}
	}

	//resolve pipeline forwarding probes
	for(uint8_t BitIdx = 0; BitIdx < 32; ++BitIdx){
		uint32_t ProbeInfo = (15 << IdOffset) | (BitIdx << BitOffset);
		for(uint32_t pipeline_idx = 0; pipeline_idx < Setting.NumberOfPipelineStages; ++pipeline_idx){
			for(const auto& RegIdx: Helper.PipelineForwardingProbesIncluded.at(BitIdx)){
				uint32_t Probe = (RegIdx << RegNrOffset) | (BitIdx);
				ProbeMapping.at(ProbeInfo).emplace_back(Probe);
			}
		}
		std::sort(ProbeMapping.at(ProbeInfo).begin(), ProbeMapping.at(ProbeInfo).end());
	}

}

// **************************************************************************************************************************

void Software::Probing::Univariate_AddCombinationToProbingSet(Software::ProbingSetStruct& ProbingSet, std::vector<Software::ProbesStruct>& Combination, std::vector<std::tuple<uint32_t, uint32_t>>& OrderOverTwoCombination, std::vector<std::vector<uint32_t>>& ProbeMapping, std::vector<std::vector<uint32_t>>& ResolvedProbes, uint32_t TestOrder){
	//resolve probes with mapping

	std::vector<uint8_t> IndexOfCombinations(TestOrder);
	std::iota(std::begin(IndexOfCombinations), std::end(IndexOfCombinations), 0);

	for(uint32_t idx = 0; idx < TestOrder; ++idx){

		ResolvedProbes.at(idx) = ProbeMapping.at((Combination.at(idx).ProbeInfo >> 8) & 0x7ffff);

		if(ProbeMapping.at((Combination.at(idx).ProbeInfo >> 8) & 0x7ffff).empty()){
			throw std::runtime_error("in univariate AddCombinationToProbingSet: empty mapping from ProbeInfo to resolved standard probes");
		}
		
	}
        

	//sort resolved probes by size
	std::sort(IndexOfCombinations.begin(), IndexOfCombinations.end(), [&ResolvedProbes](const uint8_t& a, const uint8_t& b){return ResolvedProbes.at(a).size() > ResolvedProbes.at(b).size();});
	std::sort(ResolvedProbes.begin(), ResolvedProbes.end(), [](const std::vector<uint32_t> & a, const std::vector<uint32_t> & b){ return a.size() > b.size(); });
	
	uint32_t low_idx, high_idx;
	//go over all (TestOrder over 2) pairs
	for(auto const& tup: OrderOverTwoCombination){
		std::tie(low_idx, high_idx) = tup;
		//check if one probe is fully redundant of other probe
		if(std::includes(ResolvedProbes.at(low_idx).begin(), ResolvedProbes.at(low_idx).end(), ResolvedProbes.at(high_idx).begin(), ResolvedProbes.at(high_idx).end())){
			//set redundant probe to dummy value
			Combination.at(IndexOfCombinations.at(high_idx)).ProbeInfo = 0xffffff00; //set Extension size to zero
			Combination.at(IndexOfCombinations.at(high_idx)).SpecialInfo = 0; 
			Combination.at(IndexOfCombinations.at(high_idx)).TransitionCycles = 0; 
			
		}
	}

	std::sort(Combination.begin(), Combination.end(), [](const Software::ProbesStruct& a, const Software::ProbesStruct& b){ return a.ProbeInfo < b.ProbeInfo; });
	
	for(uint32_t idx = 0; idx < TestOrder; ++idx){
		ProbingSet.NumberOfProbesInSet += (Combination.at(idx).ProbeInfo & EXTENSION_MASK);
		ProbingSet.StandardProbe.at(idx) = Combination.at(idx);
	}
}

// **************************************************************************************************************************

void Software::Probing::Multivariate_AddCombinationToProbingSet(Software::ProbingSetStruct& ProbingSet, std::vector<Software::ProbesStruct>& Combination, std::vector<std::tuple<uint32_t, uint32_t>>& OrderOverTwoCombination, std::vector<std::vector<uint32_t>>& ProbeMapping, std::vector<std::vector<uint32_t>>& ResolvedProbes, uint32_t TestOrder){
	//resolve probes with mapping
	
	std::vector<uint8_t> IndexOfCombinations(TestOrder);
	std::iota(std::begin(IndexOfCombinations), std::end(IndexOfCombinations), 0);

	for(uint32_t idx = 0; idx < TestOrder; ++idx){
		
		ResolvedProbes.at(idx) = ProbeMapping.at((Combination.at(idx).ProbeInfo >> 8) & 0x7ffff);
		if(ProbeMapping.at((Combination.at(idx).ProbeInfo >> 8) & 0x7ffff).empty()){
			throw std::runtime_error("in multivariate AddCombinationToProbingSet: empty mapping from ProbeInfo to resolved standard probes");
		}
		
	}
        

	//sort resolved probes by size
	std::sort(IndexOfCombinations.begin(), IndexOfCombinations.end(), [&ResolvedProbes](const uint8_t& a, const uint8_t& b){return ResolvedProbes.at(a).size() > ResolvedProbes.at(b).size();});
	std::sort(ResolvedProbes.begin(), ResolvedProbes.end(), [](const std::vector<uint32_t> & a, const std::vector<uint32_t> & b){ return a.size() > b.size(); });
	
	uint32_t low_idx, high_idx;
	//go over all (TestOrder over 2) pairs
	for(auto const& tup: OrderOverTwoCombination){
		std::tie(low_idx, high_idx) = tup;
		//check if one probe is fully redundant of other probe
		if(std::includes(ResolvedProbes.at(low_idx).begin(), ResolvedProbes.at(low_idx).end(), ResolvedProbes.at(high_idx).begin(), ResolvedProbes.at(high_idx).end()) && ((Combination.at(IndexOfCombinations.at(high_idx)).ProbeInfo >> 32) == (Combination.at(IndexOfCombinations.at(low_idx)).ProbeInfo >> 32))){
			//set redundant probe to dummy value
			Combination.at(IndexOfCombinations.at(high_idx)).ProbeInfo = 0xffffff00; //set Extension size to zero
			Combination.at(IndexOfCombinations.at(high_idx)).SpecialInfo = 0; 
			Combination.at(IndexOfCombinations.at(high_idx)).TransitionCycles = 0;
		}
	}

	std::sort(Combination.begin(), Combination.end(), [](const Software::ProbesStruct& a, const Software::ProbesStruct& b){ return a.ProbeInfo < b.ProbeInfo; });
	
	for(uint32_t idx = 0; idx < TestOrder; ++idx){
		ProbingSet.NumberOfProbesInSet += (Combination.at(idx).ProbeInfo & EXTENSION_MASK);
		ProbingSet.StandardProbe.at(idx) = Combination.at(idx);
	}
}

// **************************************************************************************************************************

void Software::Probing::GetProbingSets(Software::ThreadSimulationStruct& ThreadSimulation, SettingsStruct& Settings, Software::TestStruct& Test, std::vector<std::tuple<uint32_t, uint32_t>>& OrderOverTwoCombination, std::vector<std::vector<uint32_t>>& ProbeInfoToStandardProbe, uint64_t SimulationIndex){
	size_t SetIndex = 0;
	uint32_t StandardProbeIndex = 0;
	int ProbeIndex = 0, CycleIndex = 0;
	uint32_t NumberOfStandardProbes = ThreadSimulation.StandardProbesPerSimulation.at(SimulationIndex).size();

	if ((Settings.TestMultivariate != 0) && (Settings.NumberOfTestClockCycles > 1) && (Settings.TestOrder != 1)){
		// Multivariate setting
		//Test.ProbingSet.at(SimulationIndex).resize(Software::Operators::BinomialCoefficient(NumberOfStandardProbes,Settings.TestOrder));
		// Set the bitmask to the first possible probe combination
		std::vector<bool>().swap(Test.CombinationBitmask);
		Test.CombinationBitmask.resize(NumberOfStandardProbes, false);
		std::fill(Test.CombinationBitmask.begin(), Test.CombinationBitmask.begin() + Settings.TestOrder, true);

		// Iterate through all possible probe combinations
		do{
			// Convert bitmask to probing set
			ProbeIndex = 0;

			for (StandardProbeIndex = 0; StandardProbeIndex < NumberOfStandardProbes; StandardProbeIndex++){
				if (Test.CombinationBitmask.at(StandardProbeIndex)){
					Test.Combination.at(ProbeIndex) = ThreadSimulation.StandardProbesPerSimulation.at(SimulationIndex).at(StandardProbeIndex);
					ProbeIndex++;
				}
				if((ProbeIndex >= Settings.TestOrder)){
					break;
				}
			}
			Test.ProbingSet.at(SimulationIndex).emplace_back(Test.Combination);
			Test.ProbingSet.at(SimulationIndex).back().contingency_table_.Initialize(Test.ProbingSet.at(SimulationIndex).back().NumberOfProbesInSet, Settings.CompactDistributions == 1 );


		} while (std::prev_permutation(Test.CombinationBitmask.begin(), Test.CombinationBitmask.end()));
	}else{
		// Univariate setting
		// Store standard probes for each clock cycle separately 
		CycleIndex = 0;
		
		//as StandardProbesPerSimulation has ascending ClockCycle -> if we found a ClockCycle that is greater we know all following Probes are also in later ClockCycle
		if(Settings.TestOrder == 1){

			//Test.ProbingSet.at(SimulationIndex).resize(NumberOfStandardProbes, (uint32_t)Settings.TestOrder);
			for(SetIndex = 0; SetIndex < NumberOfStandardProbes; ++SetIndex){
				Test.ProbingSet[SimulationIndex].emplace_back(Settings.TestOrder);
				Test.ProbingSet[SimulationIndex].back().NumberOfProbesInSet = (ThreadSimulation.StandardProbesPerSimulation.at(SimulationIndex).at(SetIndex).ProbeInfo & EXTENSION_MASK);// << ThreadSimulation.TestTransitional;
				Test.ProbingSet[SimulationIndex].back().StandardProbe.at(0) = ThreadSimulation.StandardProbesPerSimulation.at(SimulationIndex).at(SetIndex);
				Test.ProbingSet[SimulationIndex].back().contingency_table_.Initialize(Test.ProbingSet[SimulationIndex][SetIndex].NumberOfProbesInSet, Settings.CompactDistributions == 1);
			}
			
			if(NumberOfStandardProbes == 0){
				Test.ProbingSet[SimulationIndex].clear();
			}
		}else{
			std::vector<std::vector<uint32_t>> ResolvedProbes(Settings.TestOrder);
			uint64_t ProbingSetIndex = 0;
			uint32_t NumberOfStandardProbesPerCycle;

			for (StandardProbeIndex = 1; StandardProbeIndex < NumberOfStandardProbes; StandardProbeIndex++){
				if (((ThreadSimulation.StandardProbesPerSimulation.at(SimulationIndex).at(CycleIndex).ProbeInfo >> 32) < (ThreadSimulation.StandardProbesPerSimulation.at(SimulationIndex).at(StandardProbeIndex).ProbeInfo >> 32)) || (StandardProbeIndex == (NumberOfStandardProbes - 1))){				
					NumberOfStandardProbesPerCycle = StandardProbeIndex - CycleIndex;
					//make space for new pairs
					//Test.ProbingSet.at(SimulationIndex).resize(Test.ProbingSet.at(SimulationIndex).size() + Software::Operators::BinomialCoefficient(NumberOfStandardProbesPerCycle,Settings.TestOrder), (uint32_t)Settings.TestOrder);

					// Set the bitmask to the first possible probe combination
					std::vector<bool>().swap(Test.CombinationBitmask); //clear bitmask
					Test.CombinationBitmask.resize(NumberOfStandardProbesPerCycle, false);
					
					std::fill(Test.CombinationBitmask.begin(), Test.CombinationBitmask.begin() + Settings.TestOrder, true);

					do{
						// Convert bitmask to probing set
						ProbeIndex = 0;
												
						for (SetIndex = 0; SetIndex < NumberOfStandardProbesPerCycle; SetIndex++){
							if (Test.CombinationBitmask.at(SetIndex)){ 				
								Test.Combination.at(ProbeIndex) = ThreadSimulation.StandardProbesPerSimulation.at(SimulationIndex).at(SetIndex + CycleIndex);
								ProbeIndex++;
							}
							if((ProbeIndex >= Settings.TestOrder)){
								break;
							}
						}
					
						Test.ProbingSet.at(SimulationIndex).emplace_back(Settings.TestOrder);
						Software::Probing::Univariate_AddCombinationToProbingSet(Test.ProbingSet.at(SimulationIndex).back(), Test.Combination, OrderOverTwoCombination, ProbeInfoToStandardProbe, ResolvedProbes, Settings.TestOrder);
						Test.ProbingSet.at(SimulationIndex).back().contingency_table_.Initialize(Test.ProbingSet.at(SimulationIndex).back().NumberOfProbesInSet, Settings.CompactDistributions == 1 );

						ProbingSetIndex++;
					
					} while (std::prev_permutation(Test.CombinationBitmask.begin(), Test.CombinationBitmask.end()));

					CycleIndex = StandardProbeIndex;
				}
			}

			//remove complete redundant ProbingSets
			//sort and unique
			std::sort(Test.ProbingSet.at(SimulationIndex).begin(), Test.ProbingSet.at(SimulationIndex).end(), ProbingSetCompare);
			Test.ProbingSet.at(SimulationIndex).erase(std::unique(Test.ProbingSet.at(SimulationIndex).begin(), Test.ProbingSet.at(SimulationIndex).end(), ProbeInfoEquality), Test.ProbingSet.at(SimulationIndex).end());

		}
	}

	Test.NumberOfSets.at(SimulationIndex) = Test.ProbingSet.at(SimulationIndex).size();	
}


// **************************************************************************************************************************


void Software::Probing::GetMultivariateProbingSets(std::vector<std::vector<Software::ProbesStruct>>& OneSimulationStandardProbes, SettingsStruct& Settings, Software::TestStruct& Test, std::vector<std::tuple<uint32_t, uint32_t>>& OrderOverTwoCombination, std::vector<std::vector<uint32_t>>& ProbeInfoToStandardProbe, uint32_t ThreadIndex, uint32_t SimulationIndex){
	//merge thread standardprobes together
	std::vector<Software::ProbesStruct> MergedStandardProbes;
	for(const auto& threadStandardProbes: OneSimulationStandardProbes){
		MergedStandardProbes.insert(MergedStandardProbes.end(), threadStandardProbes.begin(), threadStandardProbes.end());
	}

	uint32_t NumberOfStandardProbes = 0;
	uint32_t SetIndex;
	
	uint32_t ProbingSetIndex = 0;
	uint32_t ProbeThreshold = 0;

	for(uint32_t idx = 0; idx <= ThreadIndex; ++idx){
		NumberOfStandardProbes += OneSimulationStandardProbes.at(idx).size();
	}
	ProbeThreshold = NumberOfStandardProbes - OneSimulationStandardProbes.at(ThreadIndex).size();

	// Set the bitmask to the first possible probe combination
	std::vector<bool>().swap(Test.CombinationBitmask); //clear bitmask
	Test.CombinationBitmask.resize(NumberOfStandardProbes, false);

	std::fill(Test.CombinationBitmask.begin(), Test.CombinationBitmask.begin() + Settings.TestOrder, true);

	//Test.ProbingSet.at(SimulationIndex).resize(Software::Operators::BinomialCoefficient(NumberOfStandardProbes,Settings.TestOrder), (uint32_t)Settings.TestOrder);
	std::vector<std::vector<uint32_t>> ResolvedProbes(Settings.TestOrder);
	std::vector<uint32_t> IndexOfProbes(Settings.TestOrder,0);
	// Iterate through all possible probe combinations
	do{
		uint32_t index = 0;
		uint32_t ProbeIndex = 0;
		for (SetIndex = 0; SetIndex < NumberOfStandardProbes; SetIndex++){
			if (Test.CombinationBitmask.at(SetIndex)){ 				
				Test.Combination.at(ProbeIndex) = MergedStandardProbes.at(SetIndex);
				
				ProbeIndex++;
				IndexOfProbes.at(index) = SetIndex;
				index++;
			}
			if((ProbeIndex >= (uint32_t)Settings.TestOrder)){
				break;
			}
		}

		//add probing set only if at least one probe is new
		if(IndexOfProbes.back() > ProbeThreshold){
			Test.ProbingSet.at(SimulationIndex).emplace_back(Settings.TestOrder);
			Software::Probing::Multivariate_AddCombinationToProbingSet(Test.ProbingSet.at(SimulationIndex).back(), Test.Combination, OrderOverTwoCombination, ProbeInfoToStandardProbe, ResolvedProbes, Settings.TestOrder);
			Test.ProbingSet.at(SimulationIndex).back().contingency_table_.Initialize(Test.ProbingSet.at(SimulationIndex).back().NumberOfProbesInSet, Settings.CompactDistributions == 1 );

			ProbingSetIndex++;
		}

	} while (std::prev_permutation(Test.CombinationBitmask.begin(), Test.CombinationBitmask.end()));
	

	//remove complete redundant ProbingSets
	//sort and unique
	std::sort(Test.ProbingSet.at(SimulationIndex).begin(), Test.ProbingSet.at(SimulationIndex).end(), ProbingSetCompare);
	Test.ProbingSet.at(SimulationIndex).erase(std::unique(Test.ProbingSet.at(SimulationIndex).begin(), Test.ProbingSet.at(SimulationIndex).end(), ProbeInfoEquality), Test.ProbingSet.at(SimulationIndex).end());

	Test.NumberOfSets.at(SimulationIndex) = Test.ProbingSet.at(SimulationIndex).size();	
}

// **************************************************************************************************************************

bool Software::Probing::InDistance(Software::SettingsStruct& Settings, std::vector<Software::ProbesStruct>& ProbingSet){
    size_t ProbeIndex = 0;
	int Distance = 0;

	std::vector<unsigned int> Cycles(ProbingSet.size());

    for (ProbeIndex = 0; ProbeIndex < ProbingSet.size(); ProbeIndex++){
		Cycles.at(ProbeIndex) = ProbingSet.at(ProbeIndex).ProbeInfo >> 32;
	}

	std::sort(Cycles.begin(), Cycles.end());
	Distance = Cycles.back() - Cycles.front();

	if (Distance > Settings.MaxDistanceMultivariet){
		return 0;
	} else if ((Settings.TestMultivariate == 2) && Distance == 0){
		return 0;
	} else {
		return 1;
	}
}

// **************************************************************************************************************************

uint32_t Software::Probing::MemoryConsumption(){
    std::ifstream Status("/proc/self/status");
    std::string Line, Number;
    uint32_t ram = 0;

    if (Status.is_open()){
        while (getline(Status,Line)){
            if (Line.find("VmSize") != std::string::npos){
                Number = Line.substr(7, Line.length());
                ram = std::stol(Number.substr(0, Number.length() - 2));
                break;
            }
        }
        Status.close();
    }else{
        throw std::logic_error("Status file not found!");
    }

    return ram;
}