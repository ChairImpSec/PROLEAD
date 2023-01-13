#include "Hardware/Definitions.hpp"

Hardware::ProbePositionStruct::ProbePositionStruct(){}

Hardware::ProbePositionStruct::ProbePositionStruct(unsigned int p, unsigned int c){
    Probe = p;
	Cycle = c;
}

Hardware::ProbingSetStruct::ProbingSetStruct(unsigned int p){
	Standard.push_back(p);
	ContingencyTable.Probability = 0.0;
	ContingencyTable.Traces = 0;
}

Hardware::ProbingSetStruct::ProbingSetStruct(std::vector<unsigned int>& Probe){
	Standard = {Probe.begin(), Probe.end()};
	ContingencyTable.Probability = 0.0;
	ContingencyTable.Traces = 0;
}

bool Hardware::ProbingSetStruct::Covers(Hardware::ProbingSetStruct& ProbingSet){
	if (this->ContingencyTable.Traces || ProbingSet.ContingencyTable.Traces){
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

int Hardware::ProbingSetStruct::FindEntry(Util::TableEntryStruct& Entry, unsigned int IgnoredEntries){
    std::vector<Util::TableEntryStruct>::iterator it = std::lower_bound(ContingencyTable.Entries.begin(), ContingencyTable.Entries.end() - IgnoredEntries, Entry, [](const Util::TableEntryStruct& lhs, const Util::TableEntryStruct& rhs){return lhs.Key < rhs.Key;});
    std::iterator_traits<std::vector<Util::TableEntryStruct>::iterator>::difference_type Position = std::distance(ContingencyTable.Entries.begin(), it); 
    
    if ((it == ContingencyTable.Entries.end()) || (ContingencyTable.Entries.at(Position).Key != Entry.Key)){
        return -1;
    }else{
        return (int)Position;
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