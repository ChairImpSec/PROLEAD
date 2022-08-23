#include "Hardware/Definitions.hpp"

Hardware::ProbePositionStruct::ProbePositionStruct(){}

Hardware::ProbePositionStruct::ProbePositionStruct(unsigned int p, unsigned int c){
    Probe = p;
	Cycle = c;
}

Hardware::TableEntryStruct::TableEntryStruct(unsigned int GroupSize){
	Count.resize(GroupSize, 0);
}

Hardware::TableEntryStruct::TableEntryStruct(Hardware::SimulationStruct& Simulation, std::vector<unsigned char>& NewKey, int GroupIndex1, unsigned int GroupIndex2){
	Key = NewKey;	
	Count.resize(Simulation.NumberOfGroups, 0);
	Count.at(GroupIndex1)++;
	Count.at(GroupIndex2)++;
}

Hardware::ProbingSetStruct::ProbingSetStruct(unsigned int p){
	Standard.push_back(p);
	Probability = 0.0;
}

Hardware::ProbingSetStruct::ProbingSetStruct(std::vector<unsigned int>& Probe){
	Standard = {Probe.begin(), Probe.end()};
	Probability = 0.0;
}

int Hardware::ProbingSetStruct::FindEntry(Hardware::TableEntryStruct& Entry, unsigned int IgnoredEntries){
    std::vector<Hardware::TableEntryStruct>::iterator it = std::lower_bound(ContingencyTable.begin(), ContingencyTable.end() - IgnoredEntries, Entry, [](const Hardware::TableEntryStruct& lhs, const Hardware::TableEntryStruct& rhs){return lhs.Key < rhs.Key;});
    std::iterator_traits<std::vector<Hardware::TableEntryStruct>::iterator>::difference_type Position = std::distance(ContingencyTable.begin(), it); 
    
    if ((it == ContingencyTable.end()) || (ContingencyTable.at(Position).Key != Entry.Key)){
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