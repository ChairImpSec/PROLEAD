#include <Software/Definitions.hpp>

Software::HelperStruct::HelperStruct(){
    // NormalProbesExcluded.resize(19);
    NormalProbesIncluded.resize(17);
	HorizontalBitsIncluded.resize(18);
	VerticalProbesIncluded.resize(17);
	FullVerticalProbesIncluded.resize(32);
	FullVerticalProbesSize = 0;
	PipelineForwardingProbesIncluded.resize(32);
	FULLHRProbesIncluded.resize(17);	
	HorizontalProbesExcluded.resize(18, true);

	ProbeMemory = false;
	ProbeMemoryShadowRegister = false;
	ProbeFullHorizontal = false;
	ProbeFullVertical = false;
	ProbePipelineForwarding = false;

	VerticalProbesSize.resize(17);
	FullHorizontalProbesSize.resize(17);
	for(uint8_t idx = 0; idx < 17; ++idx){
		VerticalProbesSize.at(idx).resize(18,0);
		FullHorizontalProbesSize.at(idx).resize(18,0);
	}
}
Software::ProbingSetStruct::ProbingSetStruct(std::vector<Software::ProbesStruct>& Probe){
	StandardProbe = {Probe.begin(), Probe.end()};
	ContingencyTable.Probability = 0.0;
    for(const auto& item: Probe){
        NumberOfProbesInSet += (item.ProbeInfo & 0xff);
    }
}

Software::ProbingSetStruct::ProbingSetStruct(Software::ProbesStruct& Probe){
	StandardProbe.push_back(Probe);
	ContingencyTable.Probability = 0.0;
    NumberOfProbesInSet += (Probe.ProbeInfo & 0x0ff);
}

Software::ProbingSetStruct::ProbingSetStruct(uint32_t TestOrder){
	StandardProbe.resize(TestOrder);
	ContingencyTable.Probability = 0.0;
    NumberOfProbesInSet = 0;
}

Software::ProbeTrackingStruct::ProbeTrackingStruct(){
    RegisterLatestValue.resize(17, 0);
	RegisterLatestClockCycle.resize(17, 0); 
    VerticalLatestClockCycle.resize(17, 0);
	MemoryLatestClockCycle = 0;
}