#include "Hardware/Definitions.hpp"

Hardware::ProbePositionStruct::ProbePositionStruct(){}

Hardware::ProbePositionStruct::ProbePositionStruct(unsigned int p, unsigned int c){
    Probe = p;
	Cycle = c;
}

Hardware::ProbingSetStruct::ProbingSetStruct(unsigned int p){
	Standard.push_back(p);
}

Hardware::ProbingSetStruct::ProbingSetStruct(std::vector<unsigned int>& Probe){
	Standard = {Probe.begin(), Probe.end()};
}

bool Hardware::ProbingSetStruct::Covers(Hardware::ProbingSetStruct& ProbingSet){
	if (this->contingency_table.GetNumberOfRequiredTraces() || ProbingSet.contingency_table.GetNumberOfRequiredTraces()){
		return false;
	}else{
		if (this->Extension.size() <= ProbingSet.Extension.size()){
			return false;
		}else{
			if ((this->Extension.front() >= ProbingSet.Extension.front()) && (this->Extension.back() <= ProbingSet.Extension.back())){
				return true;
			}else{
				return false;
			}
		}
	}
}

Hardware::TestStruct::TestStruct(Hardware::SimulationStruct& Simulation){
	SumOverGroup.resize(Simulation.NumberOfGroups, 0.0);
}

int Hardware::TestStruct::GetNumberOfStandardProbes(unsigned int SetIndex){
	return ProbingSet.at(SetIndex).Standard.size();
}

Hardware::ProbePositionStruct Hardware::TestStruct::GetStandardProbe(unsigned int SetIndex, unsigned int ProbeIndex){
	return StandardProbes.at(ProbingSet.at(SetIndex).Standard.at(ProbeIndex));
}

Hardware::ProbePositionStruct Hardware::TestStruct::GetExtendedProbe(unsigned int SetIndex, unsigned int ProbeIndex){
	return ExtendedProbes.at(ProbingSet.at(SetIndex).Extension.at(ProbeIndex));
}

Hardware::ProbePositionStruct Hardware::TestStruct::GetStandardProbe(Hardware::ProbingSetStruct& Ps, unsigned int ProbeIndex){
	return StandardProbes.at(Ps.Standard.at(ProbeIndex));
}

Hardware::ProbePositionStruct Hardware::TestStruct::GetExtendedProbe(Hardware::ProbingSetStruct& Ps, unsigned int ProbeIndex){
	return ExtendedProbes.at(Ps.Extension.at(ProbeIndex));
}

void Hardware::TestStruct::GetExtendedProbes(Hardware::ProbingSetStruct& probing_set, std::vector<Hardware::ProbePositionStruct*>& extensions){
	for (size_t probe_index = 0; probe_index < probing_set.Extension.size(); ++probe_index){
		extensions[probe_index] = &ExtendedProbes[probing_set.Extension[probe_index]]; 
	}
}