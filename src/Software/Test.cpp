#include "Software/Test.hpp"

//***************************************************************************************
void Software::Test::Test(Software::ThreadSimulationStruct& ThreadSimulation, Software::TestStruct& Test, char Compact){
    unsigned int  NumberOfProcessedSimulations, SetIndex;
    size_t i, j;

    for (SetIndex = 0; SetIndex < Test.GlobalProbingSets.size(); SetIndex++){
        std::vector<double> SumOverGroup(ThreadSimulation.NumberOfGroups, 0.0);

        for (i = 0; i < Test.GlobalProbingSets.at(SetIndex).ContingencyTable.Entries.size(); i++){
            for (j = 0; j < Test.GlobalProbingSets.at(SetIndex).ContingencyTable.Entries.at(i).Count.size(); j++){
                SumOverGroup.at(j) += Test.GlobalProbingSets.at(SetIndex).ContingencyTable.Entries.at(i).Count.at(j);
            }
        }

        NumberOfProcessedSimulations = std::accumulate(SumOverGroup.begin(), SumOverGroup.end(), 0);

        Util::GTest(ThreadSimulation.NumberOfGroups, NumberOfProcessedSimulations, Test.GlobalProbingSets.at(SetIndex).ContingencyTable, SumOverGroup);
    }

    if (!Compact){
        for (SetIndex = 0; SetIndex < Test.GlobalProbingSets.size(); SetIndex++){
            Test.GlobalProbingSets.at(SetIndex).ContingencyTable.CalculateTraces(ThreadSimulation.NumberOfGroups, ThreadSimulation.BetaThreshold, ThreadSimulation.EffectSize);
        }
    }
}

//***************************************************************************************
void Software::Test::FirstOrderTableUpdate(Software::ThreadSimulationStruct& ThreadSimulation, unsigned int SimulationIndex, Software::ProbingSetStruct& GlobalSet, Software::ProbingSetStruct& ProbingSet, std::vector<std::vector<std::vector<uint8_t>>>& ProbeValues, Software::HelperStruct& Helper, Util::TableEntryStruct& TableEntry){

    unsigned int StandardProbeIndex, KeyIndex;
    unsigned int KeySize = (ProbingSet.NumberOfProbesInSet >> 3) + 1;
    std::vector<Util::TableEntryStruct>::iterator it;
    std::iterator_traits<std::vector<Util::TableEntryStruct>::iterator>::difference_type Position;

    uint32_t ProbeClockCycle;
    uint8_t ProbeId, ProbeRegister, ProbePartnerRegister, ProbeBit, Dependency;
    uint16_t ExtensionSize;

    TableEntry.Key.resize(KeySize, 0);
    std::fill(TableEntry.Key.begin(), TableEntry.Key.end(), 0); 

    KeyIndex = 0;
    for (StandardProbeIndex = 0; StandardProbeIndex < ProbingSet.StandardProbe.size(); ++StandardProbeIndex){

        Software::Probing::ExtractAllProbeInfo(ProbeRegister, ProbeId, ProbePartnerRegister, ProbeClockCycle, ProbeBit, ExtensionSize, Dependency, ProbingSet.StandardProbe.at(StandardProbeIndex));

        switch(ProbeId){
            case(0): //memory probe
            {
                KeyIndex++; 
                TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                TableEntry.Key.at(KeyIndex >> 3) |= ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 1) & 1);

                if(ThreadSimulation.TestTransitional){
                    KeyIndex++; 
                    TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                    TableEntry.Key.at(KeyIndex >> 3) |= ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles) & 1);
                }

                break;
            }
            //memory probe shadow register
            case(1):
            {
                KeyIndex++;
                TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                TableEntry.Key.at(KeyIndex >> 3) |= (((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles ) >> ProbeBit) & 1);

                if(ThreadSimulation.TestTransitional){
                    KeyIndex++; 
                    TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                    TableEntry.Key.at(KeyIndex >> 3) |= ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> (32 + ProbeBit)) & 1);
                }
                break;

            }
            //memory probe shadow register horizontal
            case(2):{
                for(const auto& BitIdx: Helper.HorizontalBitsIncluded.at(17)){
                    KeyIndex++; 
                    TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                    TableEntry.Key.at(KeyIndex >> 3) |= ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> (BitIdx) ) & 1);

                    if(ThreadSimulation.TestTransitional){
                        KeyIndex++; 
                        TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                        TableEntry.Key.at(KeyIndex >> 3) |= ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> (32 + BitIdx)) & 1);
                    }
                }
                break;
            }

            case(3): //normal probe
            {

                KeyIndex++; 
                TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                TableEntry.Key.at(KeyIndex >> 3) |= ((ProbeValues.at(ProbeRegister).at(ProbeBit).at(ProbeClockCycle) >> (SimulationIndex & 0x7)) & 1);

                if(ThreadSimulation.TestTransitional){
                    KeyIndex++; 
                    TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                    TableEntry.Key.at(KeyIndex >> 3) |= ((ProbeValues.at(ProbeRegister).at(ProbeBit).at((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles & 0xffffffff)) >> (SimulationIndex & 0x7)) & 1);
                }                                                                    
                break;
            }


            case(4): //horizontal Probe
            {

                for(const auto& BitIdx: Helper.HorizontalBitsIncluded.at(ProbeRegister)){
                    KeyIndex++; 
                    TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                    TableEntry.Key.at(KeyIndex >> 3) |= ((ProbeValues.at(ProbeRegister).at(BitIdx).at(ProbeClockCycle) >> (SimulationIndex & 0x7) ) & 1);

                    if(ThreadSimulation.TestTransitional){
                        KeyIndex++; 
                        TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                        TableEntry.Key.at(KeyIndex >> 3) |= ((ProbeValues.at(ProbeRegister).at(BitIdx).at((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles & 0xffffffff)) >> (SimulationIndex & 0x7)) & 1);
                    }
                }
                break;
            }


            case(5): //small vertical Probe
                {
                    KeyIndex++; 
                    TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                    TableEntry.Key.at(KeyIndex >> 3) |= ((ProbeValues.at(ProbeRegister).at(ProbeBit).at(ProbeClockCycle) >> (SimulationIndex & 0x7)) & 1);

                    KeyIndex++; 
                    TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                    TableEntry.Key.at(KeyIndex >> 3) |= ((ProbeValues.at(ProbePartnerRegister).at(ProbeBit).at((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 32)) >> (SimulationIndex & 0x7)) & 1);

                    if(ThreadSimulation.TestTransitional){
                        KeyIndex++; 
                        TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                        TableEntry.Key.at(KeyIndex >> 3) |= ((ProbeValues.at(ProbeRegister).at(ProbeBit).at((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles & 0xffffffff)) >> (SimulationIndex & 0x7)) & 1);
                    }
                    break;
                }

            case(6): //large vertical probe
            {
                KeyIndex++; 
                TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                TableEntry.Key.at(KeyIndex >> 3) |= ((ProbeValues.at(ProbeRegister).at(ProbeBit).at(ProbeClockCycle) >> (SimulationIndex & 0x7)) & 1);

                KeyIndex++; 
                TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                TableEntry.Key.at(KeyIndex >> 3) |= ((ProbeValues.at(ProbePartnerRegister).at(ProbeBit).at(ProbeClockCycle) >> (SimulationIndex & 0x7)) & 1);

                if(ThreadSimulation.TestTransitional){
                    KeyIndex++; 
                    TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                    TableEntry.Key.at(KeyIndex >> 3) |= ((ProbeValues.at(ProbeRegister).at(ProbeBit).at((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles & 0xffffffff)) >> (SimulationIndex & 0x7)) & 1);

                    KeyIndex++; 
                    TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                    TableEntry.Key.at(KeyIndex >> 3) |= ((ProbeValues.at(ProbePartnerRegister).at(ProbeBit).at((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 32)) >> (SimulationIndex & 0x7)) & 1);
                }
                break;

            }
            
            case(7): //small full HR probe
            {
                for(const auto& BitIdx: Helper.NormalProbesIncluded.at(ProbeRegister)){
                    KeyIndex++;
                    TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                    TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbeValues.at(ProbeRegister).at(BitIdx).at(ProbeClockCycle) >> (SimulationIndex & 0x7)) & 1); //destination register of probe 

                    if(ThreadSimulation.TestTransitional){
                        KeyIndex++;
                        TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                        TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbeValues.at(ProbeRegister).at(BitIdx).at((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles & 0xffffffff)) >> (SimulationIndex & 0x7)) & 1); //transition of destination register of probe
                    }
                }

                for(const auto& BitIdx: Helper.NormalProbesIncluded.at(ProbePartnerRegister)){
                    KeyIndex++;
                    TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                    TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbeValues.at(ProbePartnerRegister).at(BitIdx).at((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 32)) >> (SimulationIndex & 0x7)) & 1); //transition of destination register of probe    
                }

                break;

            }
            case(8): //large full HR probe
            {
                for(const auto& BitIdx: Helper.NormalProbesIncluded.at(ProbeRegister)){
                    KeyIndex++;
                    TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                    TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbeValues.at(ProbeRegister).at(BitIdx).at(ProbeClockCycle) >> (SimulationIndex & 0x7)) & 1); //destination register of probe 

                    if(ThreadSimulation.TestTransitional){
                        KeyIndex++;
                        TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                        TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbeValues.at(ProbeRegister).at(BitIdx).at((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles & 0xffffffff)) >> (SimulationIndex & 0x7)) & 1); //transition of destination register of probe  
                    }
                }

                for(const auto& BitIdx: Helper.NormalProbesIncluded.at(ProbePartnerRegister)){
                    KeyIndex++;
                    TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                    TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbeValues.at(ProbePartnerRegister).at(BitIdx).at(ProbeClockCycle) >> (SimulationIndex & 0x7)) & 1); //transition of destination register of probe

                    if(ThreadSimulation.TestTransitional){
                        KeyIndex++;
                        TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                        TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbeValues.at(ProbePartnerRegister).at(BitIdx).at((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 32)) >> (SimulationIndex & 0x7)) & 1); //transition of destination register of probe     
                    }        
                }
                break;
            }
            case(9): // small full VR probe
            {
                for(const auto& RegIdx: Helper.FullVerticalProbesIncluded.at(ProbeBit)){
                    KeyIndex++;
                    TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                    TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> RegIdx) & 0x1); //transition of destination register of probe

                    if(ThreadSimulation.TestTransitional && (RegIdx == ProbeRegister)){
                        KeyIndex++;
                        TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                        TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 17) & 0x1);
                    }
                    else if(ThreadSimulation.TestTransitional && (RegIdx == ProbePartnerRegister)){
                        KeyIndex++;
                        TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                        TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 18) & 0x1);
                    }
                }
                break;
            }
            case(10): // large full VR probe
            {
                for(const auto& RegIdx: Helper.FullVerticalProbesIncluded.at(ProbeBit)){
                    KeyIndex++;
                    TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                    TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> RegIdx) & 0x1); //transition of destination register of probe

                    if(ThreadSimulation.TestTransitional && (RegIdx == ProbeRegister)){
                        KeyIndex++;
                        TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                        TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 17) & 0x1);
                    }
                    else if(ThreadSimulation.TestTransitional && (RegIdx == 15)){
                        KeyIndex++;
                        TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                        TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 18) & 0x1);
                    }
                    else if(ThreadSimulation.TestTransitional && (RegIdx == 16)){
                        KeyIndex++;
                        TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                        TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 19) & 0x1);
                    }
                }
                break;
            }
            case(11): // special full VR probe
            {
                for(const auto& RegIdx: Helper.FullVerticalProbesIncluded.at(ProbeBit)){
                    KeyIndex++;
                    TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                    TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> RegIdx) & 0x1); //transition of destination register of probe

                    if(ThreadSimulation.TestTransitional && (RegIdx == ProbeRegister)){
                        KeyIndex++;
                        TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                        TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 17) & 0x1);
                    }
                }
                break;
            }
            case(12):  //small DSP full VR probe
            {
                for(const auto& RegIdx: Helper.FullVerticalProbesIncluded.at(ProbeBit)){
                    KeyIndex++;
                    TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                    TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> RegIdx) & 0x1); //transition of destination register of probe

                    if(ThreadSimulation.TestTransitional && (RegIdx == ProbeRegister)){
                        KeyIndex++;
                        TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                        TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 17) & 0x1);
                    }
                    else if(ThreadSimulation.TestTransitional && (RegIdx == ProbePartnerRegister)){
                        KeyIndex++;
                        TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                        TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 18) & 0x1);
                    }
                    else if(ThreadSimulation.TestTransitional && (RegIdx == 16)){
                        KeyIndex++;
                        TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                        TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 19) & 0x1);
                    }
                }
                break;
            }
            case(13): //large DSP full VR probe
            {
                for(const auto& RegIdx: Helper.FullVerticalProbesIncluded.at(ProbeBit)){
                    KeyIndex++;
                    TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                    TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> RegIdx) & 0x1); //transition of destination register of probe

                    if(ThreadSimulation.TestTransitional && (RegIdx == ProbeRegister)){
                        KeyIndex++;
                        TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                        TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 17) & 0x1);
                    }
                    else if(ThreadSimulation.TestTransitional && (RegIdx == ProbePartnerRegister)){
                        KeyIndex++;
                        TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                        TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 18) & 0x1);
                    }
                    else if(ThreadSimulation.TestTransitional && (RegIdx == 15)){
                        KeyIndex++;
                        TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                        TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 19) & 0x1);
                    }
                    else if(ThreadSimulation.TestTransitional && (RegIdx == 16)){
                        KeyIndex++;
                        TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                        TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 20) & 0x1);
                    }
                }
                break;
            }
            default: std::runtime_error("In FirstOrderTableUpdate: unkown ID detected (neither normal, horizontal, vertical, memory, memoryshadow, fullhr or fullvr)"); break;
        }

    }  

    // Search if an entry exists
    it = std::lower_bound(GlobalSet.ContingencyTable.Entries.begin(), GlobalSet.ContingencyTable.Entries.end(), TableEntry, TableEntryCompare);
    Position = std::distance(GlobalSet.ContingencyTable.Entries.begin(), it);

    // Create a new bin for each group
    if ((it == GlobalSet.ContingencyTable.Entries.end()) || (GlobalSet.ContingencyTable.Entries.at(Position).Key != TableEntry.Key)){
        GlobalSet.ContingencyTable.Entries.insert(it, TableEntry);
    }

    // Increment the existing bin 
    GlobalSet.ContingencyTable.Entries.at(Position).Count[ThreadSimulation.SelectedGroups[SimulationIndex]]++; 
}


//***************************************************************************************
void Software::Test::CompactFirstOrderTableUpdate(Software::ThreadSimulationStruct& ThreadSimulation, unsigned int SimulationIndex, Software::ProbingSetStruct& GlobalSet, Software::ProbingSetStruct& ProbingSet, std::vector<std::vector<std::vector<uint8_t>>>& ProbeValues, Software::HelperStruct& Helper, Util::TableEntryStruct& TableEntry){

    unsigned int StandardProbeIndex;
    unsigned int KeySize = (ProbingSet.NumberOfProbesInSet >> 8) + 1;
    std::vector<Util::TableEntryStruct>::iterator it;
    std::iterator_traits<std::vector<Util::TableEntryStruct>::iterator>::difference_type Position;

    uint32_t ProbeClockCycle;
    uint8_t ProbeId, ProbeRegister, ProbePartnerRegister, ProbeBit, Dependency;
    uint16_t ExtensionSize;

    TableEntry.Key.resize(KeySize, 0);
    std::fill(TableEntry.Key.begin(), TableEntry.Key.end(), 0); 

    uint32_t heuristic = 0;

    for (StandardProbeIndex = 0; StandardProbeIndex < ProbingSet.StandardProbe.size(); ++StandardProbeIndex){

        Software::Probing::ExtractAllProbeInfo(ProbeRegister, ProbeId, ProbePartnerRegister, ProbeClockCycle, ProbeBit, ExtensionSize, Dependency, ProbingSet.StandardProbe.at(StandardProbeIndex));

        switch(ProbeId){
            case(0): //memory probe
            {
                heuristic += ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 1) & 1);

                if(ThreadSimulation.TestTransitional){
                    heuristic += ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles) & 1);

                }
                break;
            }
            //memory probe shadow register
            case(1):
            {
                heuristic += (((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles ) >> ProbeBit) & 1);

                if(ThreadSimulation.TestTransitional){
                    heuristic += ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> (32 + ProbeBit)) & 1);
                }
                break;

            }

            //memory probe shadow register horizontal
            case(2):{
                for(const auto& BitIdx: Helper.HorizontalBitsIncluded.at(17)){
                    heuristic += ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> (BitIdx) ) & 1);

                    if(ThreadSimulation.TestTransitional){
                        heuristic += ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> (32 + BitIdx)) & 1);

                    }
                }
                break;
            }

            case(3): //normal probe
            {

                heuristic += ((ProbeValues.at(ProbeRegister).at(ProbeBit).at(ProbeClockCycle) >> (SimulationIndex & 0x7)) & 1);

                if(ThreadSimulation.TestTransitional){
                    heuristic += ((ProbeValues.at(ProbeRegister).at(ProbeBit).at((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles & 0xffffffff)) >> (SimulationIndex & 0x7)) & 1);
                }

                break;
            }


            case(4): //horizontal Probe
            {

                for(const auto& BitIdx: Helper.HorizontalBitsIncluded.at(ProbeRegister)){
                    heuristic += ((ProbeValues.at(ProbeRegister).at(BitIdx).at(ProbeClockCycle) >> (SimulationIndex & 0x7) ) & 1);

                    if(ThreadSimulation.TestTransitional){
                        heuristic += ((ProbeValues.at(ProbeRegister).at(BitIdx).at((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles & 0xffffffff)) >> (SimulationIndex & 0x7)) & 1);

                    }
                }
                break;
            }

            case(5): //small vertical Probe
            {
                heuristic += ((ProbeValues.at(ProbeRegister).at(ProbeBit).at(ProbeClockCycle) >> (SimulationIndex & 0x7)) & 1);
                heuristic += ((ProbeValues.at(ProbePartnerRegister).at(ProbeBit).at((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 32)) >> (SimulationIndex & 0x7)) & 1);

                if(ThreadSimulation.TestTransitional){
                    heuristic += ((ProbeValues.at(ProbeRegister).at(ProbeBit).at((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles & 0xffffffff)) >> (SimulationIndex & 0x7)) & 1);
                }
                break;
            }
           
            case(6): //large vertical probe
            {

                heuristic += ((ProbeValues.at(ProbeRegister).at(ProbeBit).at(ProbeClockCycle) >> (SimulationIndex & 0x7)) & 1);

                heuristic += ((ProbeValues.at(ProbePartnerRegister).at(ProbeBit).at(ProbeClockCycle) >> (SimulationIndex & 0x7)) & 1);

                if(ThreadSimulation.TestTransitional){
                    heuristic += ((ProbeValues.at(ProbeRegister).at(ProbeBit).at((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles & 0xffffffff)) >> (SimulationIndex & 0x7)) & 1);

                    heuristic += ((ProbeValues.at(ProbePartnerRegister).at(ProbeBit).at((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 32)) >> (SimulationIndex & 0x7)) & 1);
                
                }
                break;

            }


            
            case(7): //small full HR probe
            {
                for(const auto& BitIdx: Helper.NormalProbesIncluded.at(ProbeRegister)){
         
                    heuristic +=  ((ProbeValues.at(ProbeRegister).at(BitIdx).at(ProbeClockCycle) >> (SimulationIndex & 0x7)) & 1); //destination register of probe 

                    if(ThreadSimulation.TestTransitional){
                    
                        heuristic +=  ((ProbeValues.at(ProbeRegister).at(BitIdx).at((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles & 0xffffffff)) >> (SimulationIndex & 0x7)) & 1); //transition of destination register of probe
                        
                    }
                }

                for(const auto& BitIdx: Helper.NormalProbesIncluded.at(ProbePartnerRegister)){

                    heuristic +=  ((ProbeValues.at(ProbePartnerRegister).at(BitIdx).at((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 32)) >> (SimulationIndex & 0x7)) & 1); //transition of destination register of probe
                        
                }

                break;

            }
            case(8): //large full HR probe
            {
                for(const auto& BitIdx: Helper.NormalProbesIncluded.at(ProbeRegister)){

                    heuristic +=  ((ProbeValues.at(ProbeRegister).at(BitIdx).at(ProbeClockCycle) >> (SimulationIndex & 0x7)) & 1); //destination register of probe 

                    if(ThreadSimulation.TestTransitional){

                        heuristic +=  ((ProbeValues.at(ProbeRegister).at(BitIdx).at((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles & 0xffffffff)) >> (SimulationIndex & 0x7)) & 1); //transition of destination register of probe
                        
                    }
                }

                for(const auto& BitIdx: Helper.NormalProbesIncluded.at(ProbePartnerRegister)){

                    heuristic +=  ((ProbeValues.at(ProbePartnerRegister).at(BitIdx).at(ProbeClockCycle) >> (SimulationIndex & 0x7)) & 1); //transition of destination register of probe

                    if(ThreadSimulation.TestTransitional){

                        heuristic +=  ((ProbeValues.at(ProbePartnerRegister).at(BitIdx).at((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 32)) >> (SimulationIndex & 0x7)) & 1); //transition of destination register of probe
                        
                    }        
                
                }
                break;
            }
            case(9): // small full VR probe
            {
                for(const auto& RegIdx: Helper.FullVerticalProbesIncluded.at(ProbeBit)){

                    heuristic +=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> RegIdx) & 0x1); //transition of destination register of probe

                    if(ThreadSimulation.TestTransitional && (RegIdx == ProbeRegister)){

                        heuristic +=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 17) & 0x1);
                    }
                    else if(ThreadSimulation.TestTransitional && (RegIdx == ProbePartnerRegister)){

                        heuristic +=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 18) & 0x1);
                    }
                }
                break;
            }
            case(10): // large full VR probe
            {
                for(const auto& RegIdx: Helper.FullVerticalProbesIncluded.at(ProbeBit)){

                    heuristic +=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> RegIdx) & 0x1); //transition of destination register of probe

                    if(ThreadSimulation.TestTransitional && (RegIdx == ProbeRegister)){

                        heuristic +=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 17) & 0x1);
                    }
                    else if(ThreadSimulation.TestTransitional && (RegIdx == 15)){

                        heuristic +=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 18) & 0x1);
                    }
                    else if(ThreadSimulation.TestTransitional && (RegIdx == 16)){

                        heuristic +=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 19) & 0x1);
                    }
                }
                break;
            }
            case(11): // special full VR probe
            {
                for(const auto& RegIdx: Helper.FullVerticalProbesIncluded.at(ProbeBit)){

                    heuristic +=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> RegIdx) & 0x1); //transition of destination register of probe

                    if(ThreadSimulation.TestTransitional && (RegIdx == ProbeRegister)){

                        heuristic +=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 17) & 0x1);
                    }
                }
                break;
            }
            case(12):  //small DSP full VR probe
            {
                for(const auto& RegIdx: Helper.FullVerticalProbesIncluded.at(ProbeBit)){

                    heuristic +=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> RegIdx) & 0x1); //transition of destination register of probe

                    if(ThreadSimulation.TestTransitional && (RegIdx == ProbeRegister)){

                        heuristic +=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 17) & 0x1);
                    }
                    else if(ThreadSimulation.TestTransitional && (RegIdx == ProbePartnerRegister)){

                        heuristic +=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 18) & 0x1);
                    }
                    else if(ThreadSimulation.TestTransitional && (RegIdx == 16)){

                        heuristic +=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 19) & 0x1);
                    }
                }
                break;
            }
            case(13): //large DSP full VR probe
            {
                for(const auto& RegIdx: Helper.FullVerticalProbesIncluded.at(ProbeBit)){

                    heuristic +=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> RegIdx) & 0x1); //transition of destination register of probe

                    if(ThreadSimulation.TestTransitional && (RegIdx == ProbeRegister)){

                        heuristic +=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 17) & 0x1);
                    }
                    else if(ThreadSimulation.TestTransitional && (RegIdx == ProbePartnerRegister)){

                        heuristic +=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 18) & 0x1);
                    }
                    else if(ThreadSimulation.TestTransitional && (RegIdx == 15)){

                        heuristic +=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 19) & 0x1);
                    }
                    else if(ThreadSimulation.TestTransitional && (RegIdx == 16)){

                        heuristic +=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 20) & 0x1);
                    }
                }
                break;
            }
            default: std::runtime_error("In NormalTableUpdate: unkown ID detected (neither normal, horizontal, vertical, memory, memoryshadow, fullhr or fullvr)"); break;
        }

    }  

    for(unsigned int i = 0; i < KeySize; ++i){
        TableEntry.Key.at(i) = (heuristic >> (i << 3)) & 0xff;
    }

    // Search if an entry exists
    it = std::lower_bound(GlobalSet.ContingencyTable.Entries.begin(), GlobalSet.ContingencyTable.Entries.end(), TableEntry, TableEntryCompare);
    Position = std::distance(GlobalSet.ContingencyTable.Entries.begin(), it);

    // Create a new bin for each group
    if ((it == GlobalSet.ContingencyTable.Entries.end()) || (GlobalSet.ContingencyTable.Entries.at(Position).Key != TableEntry.Key)){

        GlobalSet.ContingencyTable.Entries.insert(it, TableEntry);
    }
    // Increment the existing bin 
    GlobalSet.ContingencyTable.Entries.at(Position).Count[ThreadSimulation.SelectedGroups[SimulationIndex]]++; 
}

//***************************************************************************************
void Software::Test::CompactHigherOrderUnivariateTableUpdate(Software::ThreadSimulationStruct& ThreadSimulation, unsigned int SimulationIndex, Software::ProbingSetStruct& GlobalSet, Software::ProbingSetStruct& ProbingSet, std::vector<std::vector<std::vector<uint8_t>>>& ProbeValues, Software::HelperStruct& Helper, Util::TableEntryStruct& TableEntry, std::vector<std::vector<bool>>& HighOrderUnivariateRedundancy, std::vector<std::vector<uint32_t>>& ProbeInfoToStandardProbe){

    unsigned int StandardProbeIndex;
    unsigned int KeySize = (ProbingSet.NumberOfProbesInSet >> 3) + 1;
    std::vector<Util::TableEntryStruct>::iterator it;
    std::iterator_traits<std::vector<Util::TableEntryStruct>::iterator>::difference_type Position;

    uint32_t ProbeClockCycle;
    uint8_t ProbeId, ProbeRegister, ProbePartnerRegister, ProbeBit, Dependency;
    uint16_t ExtensionSize;

    TableEntry.Key.resize(KeySize, 0);
    std::fill(TableEntry.Key.begin(), TableEntry.Key.end(), 0); 

    uint32_t heuristic = 0;

    for (StandardProbeIndex = 0; StandardProbeIndex < ProbingSet.StandardProbe.size(); ++StandardProbeIndex){

        //resolve mapping from probes to standard probes
        std::vector<uint32_t> ResolvedProbes = ProbeInfoToStandardProbe.at((ProbingSet.StandardProbe.at(StandardProbeIndex).ProbeInfo >> 8) & 0x7ffff); //TODO: place ResolvedProbes into each case

        Software::Probing::ExtractAllProbeInfo(ProbeRegister, ProbeId, ProbePartnerRegister, ProbeClockCycle, ProbeBit, ExtensionSize, Dependency, ProbingSet.StandardProbe.at(StandardProbeIndex));

        switch(ProbeId){

            case(0): //memory probe
            {
                heuristic += ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 1) & 1);

                if(ThreadSimulation.TestTransitional){
                    heuristic += ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles) & 1);

                }
                break;
            }
            //memory probe shadow register
            case(1):
            {
                heuristic += (((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles ) >> ProbeBit) & 1);

                if(ThreadSimulation.TestTransitional){
                    heuristic += ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> (32 + ProbeBit)) & 1);
                }
                break;

            }

            //memory probe shadow register horizontal
            case(2):{
                for(const auto& BitIdx: Helper.HorizontalBitsIncluded.at(17)){
                    heuristic += ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> (BitIdx) ) & 1);

                    if(ThreadSimulation.TestTransitional){
                        heuristic += ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> (32 + BitIdx)) & 1);

                    }
                }
                break;
            }

            case(3): //normal probe
            {
                for(const auto& resolvedProbe: ResolvedProbes){
                    uint8_t resolvedProbeRegister = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolvedProbeBit = resolvedProbe & 0x1f;
                    uint8_t resolvedTransition = (resolvedProbe >> 19) & 0x1;
                    if(!HighOrderUnivariateRedundancy.at(resolvedProbeRegister << resolvedTransition).at(resolvedProbeBit)){ //not yet probed in ProbingSet -> add to table

                        HighOrderUnivariateRedundancy.at(resolvedProbeRegister << resolvedTransition).at(resolvedProbeBit) = true;

                        if(!resolvedTransition){
                            heuristic += ((ProbeValues.at(resolvedProbeRegister).at(resolvedProbeBit).at(ProbeClockCycle) >> (SimulationIndex & 0x7)) & 1);
                        }
                        else{
                            heuristic += ((ProbeValues.at(resolvedProbeRegister).at(resolvedProbeBit).at((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles & 0xffffffff)) >> (SimulationIndex & 0x7)) & 1);
                        }

                    } 
                }
                


                break;
            }


            case(4): //horizontal Probe
            {

                for(const auto& resolvedProbe: ResolvedProbes){
                    uint8_t resolvedProbeRegister = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolvedProbeBit = resolvedProbe & 0x1f;
                    uint8_t resolvedTransition = (resolvedProbe >> 19) & 0x1;
                    if(!HighOrderUnivariateRedundancy.at(resolvedProbeRegister << resolvedTransition).at(resolvedProbeBit)){ //not yet probed in ProbingSet -> add to table
                        HighOrderUnivariateRedundancy.at(resolvedProbeRegister << resolvedTransition).at(resolvedProbeBit) = true;

                        if(!resolvedTransition){
                            heuristic += ((ProbeValues.at(resolvedProbeRegister).at(resolvedProbeBit).at(ProbeClockCycle) >> (SimulationIndex & 0x7) ) & 1);
                        }
                        else{
                            heuristic += ((ProbeValues.at(resolvedProbeRegister).at(resolvedProbeBit).at((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles & 0xffffffff)) >> (SimulationIndex & 0x7)) & 1);

                        }

                    }

                }
                break;
            }


            case(5): //small vertical Probe
            {
                for(const auto& resolvedProbe: ResolvedProbes){
                    uint8_t resolvedProbeRegister = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolvedProbeBit = resolvedProbe & 0x1f;
                    uint8_t resolvedTransition = (resolvedProbe >> 19) & 0x1;
                    if(!HighOrderUnivariateRedundancy.at(resolvedProbeRegister << resolvedTransition).at(resolvedProbeBit)){
                        HighOrderUnivariateRedundancy.at(resolvedProbeRegister << resolvedTransition).at(resolvedProbeBit) = true;
                        if(!resolvedTransition){
                            if(resolvedProbeRegister != ProbePartnerRegister){
                                heuristic += ((ProbeValues.at(resolvedProbeRegister).at(resolvedProbeBit).at(ProbeClockCycle) >> (SimulationIndex & 0x7)) & 1);
                            }
                            else{
                                heuristic += ((ProbeValues.at(resolvedProbeRegister).at(resolvedProbeBit).at((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 32)) >> (SimulationIndex & 0x7)) & 1);
                            }
                        }
                        else{
                            heuristic += ((ProbeValues.at(ProbeRegister).at(ProbeBit).at((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles & 0xffffffff)) >> (SimulationIndex & 0x7)) & 1);
                        }
                    }
                }

                break;

            }


            case(6): //large vertical probe
            {
                for(const auto& resolvedProbe: ResolvedProbes){
                    uint8_t resolvedProbeRegister = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolvedProbeBit = resolvedProbe & 0x1f;
                    uint8_t resolvedTransition = (resolvedProbe >> 19) & 0x1;
                    if(!HighOrderUnivariateRedundancy.at(resolvedProbeRegister << resolvedTransition).at(resolvedProbeBit)){
                        HighOrderUnivariateRedundancy.at(resolvedProbeRegister << resolvedTransition).at(resolvedProbeBit) = true;
                        if(!resolvedTransition){
                            if(resolvedProbeRegister != ProbePartnerRegister){
                                heuristic += ((ProbeValues.at(resolvedProbeRegister).at(resolvedProbeBit).at(ProbeClockCycle) >> (SimulationIndex & 0x7)) & 1);
                            }
                            else{
                                heuristic += ((ProbeValues.at(resolvedProbeRegister).at(resolvedProbeBit).at(ProbeClockCycle) >> (SimulationIndex & 0x7)) & 1);
                            }
                        }
                        else{
                            if(resolvedProbeRegister != ProbePartnerRegister){
                                heuristic += ((ProbeValues.at(resolvedProbeRegister).at(resolvedProbeBit).at((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles & 0xffffffff)) >> (SimulationIndex & 0x7)) & 1);
                            }
                            else{
                                heuristic += ((ProbeValues.at(resolvedProbeRegister).at(resolvedProbeBit).at((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 32)) >> (SimulationIndex & 0x7)) & 1);
                            }

                        }
                    }
                }

                break;

            }

            case(7)://small full HR probe
            {
                for(const auto& resolvedProbe: ResolvedProbes){
                    uint8_t resolvedProbeRegister = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolvedProbeBit = resolvedProbe & 0x1f;
                    uint8_t resolvedTransition = (resolvedProbe >> 19) & 0x1;
                    if(!HighOrderUnivariateRedundancy.at(resolvedProbeRegister << resolvedTransition).at(resolvedProbeBit)){
                        HighOrderUnivariateRedundancy.at(resolvedProbeRegister << resolvedTransition).at(resolvedProbeBit) = true;
                        if(!resolvedTransition){
                            if(resolvedProbeRegister != ProbePartnerRegister){
                                heuristic +=  ((ProbeValues.at(resolvedProbeRegister).at(resolvedProbeBit).at(ProbeClockCycle) >> (SimulationIndex & 0x7)) & 1); //destination register of probe 
                            }
                            else{
                                heuristic +=  ((ProbeValues.at(resolvedProbeRegister).at(resolvedProbeBit).at((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 32)) >> (SimulationIndex & 0x7)) & 1); 
                            }
                        }
                        else{
                            heuristic +=  ((ProbeValues.at(resolvedProbeRegister).at(resolvedProbeBit).at((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles & 0xffffffff)) >> (SimulationIndex & 0x7)) & 1); //transition of destination register of probe
                            
                        }
                    }
                }

                break;

            }
            case(8):
            {
                for(const auto& resolvedProbe: ResolvedProbes){
                    uint8_t resolvedProbeRegister = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolvedProbeBit = resolvedProbe & 0x1f;
                    uint8_t resolvedTransition = (resolvedProbe >> 19) & 0x1;
                    if(!HighOrderUnivariateRedundancy.at(resolvedProbeRegister << resolvedTransition).at(resolvedProbeBit)){
                        HighOrderUnivariateRedundancy.at(resolvedProbeRegister << resolvedTransition).at(resolvedProbeBit) = true;
                        if(!resolvedTransition){
                            if(resolvedProbeRegister != ProbePartnerRegister){
                                heuristic +=  ((ProbeValues.at(resolvedProbeRegister).at(resolvedProbeBit).at(ProbeClockCycle) >> (SimulationIndex & 0x7)) & 1); //destination register of probe 
                            }
                            else{
                                heuristic +=  ((ProbeValues.at(resolvedProbeRegister).at(resolvedProbeBit).at(ProbeClockCycle) >> (SimulationIndex & 0x7)) & 1); //transition of destination register of probe
                            }
                        }
                        else{
                            if(resolvedProbeRegister != ProbePartnerRegister){
                                heuristic +=  ((ProbeValues.at(resolvedProbeRegister).at(resolvedProbeBit).at((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles & 0xffffffff)) >> (SimulationIndex & 0x7)) & 1); 
                            }
                            else{
                                heuristic +=  ((ProbeValues.at(resolvedProbeRegister).at(resolvedProbeBit).at((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 32)) >> (SimulationIndex & 0x7)) & 1);
                            }
                        }
                    }
                }

                break;
            }
            case(9): //small full VR probe
            {
                for(const auto& resolvedProbe: ResolvedProbes){
                    uint8_t resolvedProbeRegister = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolvedProbeBit = resolvedProbe & 0x1f;
                    uint8_t resolvedTransition = (resolvedProbe >> 19) & 0x1;
                    if(!HighOrderUnivariateRedundancy.at(resolvedProbeRegister << resolvedTransition).at(resolvedProbeBit)){
                        HighOrderUnivariateRedundancy.at(resolvedProbeRegister << resolvedTransition).at(resolvedProbeBit) = true;

                        if(!resolvedTransition){
                            heuristic +=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> resolvedProbeRegister) & 0x1);
                        }
                        else{
                            if(resolvedProbeRegister == ProbeRegister){
                                heuristic +=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 17) & 0x1);
                            }
                            else if(resolvedProbeRegister == ProbePartnerRegister){
                                heuristic +=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 18) & 0x1);
                            }

                        }

                    }
                }

                break;
            }
            case(10): // large full VR probe
            {
                for(const auto& resolvedProbe: ResolvedProbes){
                    uint8_t resolvedProbeRegister = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolvedProbeBit = resolvedProbe & 0x1f;
                    uint8_t resolvedTransition = (resolvedProbe >> 19) & 0x1;
                    if(!HighOrderUnivariateRedundancy.at(resolvedProbeRegister << resolvedTransition).at(resolvedProbeBit)){
                        HighOrderUnivariateRedundancy.at(resolvedProbeRegister << resolvedTransition).at(resolvedProbeBit) = true;
                        
                        if(!resolvedTransition){
                            heuristic +=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> resolvedProbeRegister) & 0x1);
                        }
                        else{
                            if(resolvedProbeRegister == ProbeRegister){
                                heuristic +=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 17) & 0x1);
                            }
                            else if(resolvedProbeRegister == 15){
                                heuristic +=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 18) & 0x1);
                            }
                            else if(resolvedProbeRegister == 16){
                                heuristic +=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 19) & 0x1);
                            }

                        }

                    }
                }

                break;
            }
            case(11): //special full VR probe
            {
                for(const auto& resolvedProbe: ResolvedProbes){
                    uint8_t resolvedProbeRegister = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolvedProbeBit = resolvedProbe & 0x1f;
                    uint8_t resolvedTransition = (resolvedProbe >> 19) & 0x1;
                    if(!HighOrderUnivariateRedundancy.at(resolvedProbeRegister << resolvedTransition).at(resolvedProbeBit)){
                        HighOrderUnivariateRedundancy.at(resolvedProbeRegister << resolvedTransition).at(resolvedProbeBit) = true;
                        
                        if(!resolvedTransition){
                            heuristic +=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> resolvedProbeRegister) & 0x1); 
                        }
                        else{
                            if(resolvedProbeRegister == ProbeRegister){
                                heuristic +=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 17) & 0x1);
                            }
                        }

                    }
                }

                break;                
            }
            case(12): //small DSP full VR probe
            {
                for(const auto& resolvedProbe: ResolvedProbes){
                    uint8_t resolvedProbeRegister = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolvedProbeBit = resolvedProbe & 0x1f;
                    uint8_t resolvedTransition = (resolvedProbe >> 19) & 0x1;
                    if(!HighOrderUnivariateRedundancy.at(resolvedProbeRegister << resolvedTransition).at(resolvedProbeBit)){
                        HighOrderUnivariateRedundancy.at(resolvedProbeRegister << resolvedTransition).at(resolvedProbeBit) = true;
                        
                        if(!resolvedTransition){
                            heuristic +=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> resolvedProbeRegister) & 0x1);
                        }
                        else{
                            if(resolvedProbeRegister == ProbeRegister){
                                heuristic +=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 17) & 0x1);
                            }
                            else if(resolvedProbeRegister == ProbePartnerRegister){
                                heuristic +=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 18) & 0x1);
                            }
                            else if(resolvedProbeRegister == 16){
                                heuristic +=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 19) & 0x1);
                            }

                        }

                    }
                }

                break;
            }
            case(13): //large DSP full VR probe
            {
                for(const auto& resolvedProbe: ResolvedProbes){
                    uint8_t resolvedProbeRegister = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolvedProbeBit = resolvedProbe & 0x1f;
                    uint8_t resolvedTransition = (resolvedProbe >> 19) & 0x1;
                    if(!HighOrderUnivariateRedundancy.at(resolvedProbeRegister << resolvedTransition).at(resolvedProbeBit)){
                        HighOrderUnivariateRedundancy.at(resolvedProbeRegister << resolvedTransition).at(resolvedProbeBit) = true;

                        if(!resolvedTransition){
                            heuristic +=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> resolvedProbeRegister) & 0x1);
                        }
                        else{
                            if(resolvedProbeRegister == ProbeRegister){
                                heuristic +=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 17) & 0x1);
                            }
                            else if(resolvedProbeRegister == ProbePartnerRegister){
                                heuristic +=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 18) & 0x1);
                            }
                            else if(resolvedProbeRegister == 15){
                                heuristic +=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 19) & 0x1);
                            }
                            else if(resolvedProbeRegister == 16){
                                heuristic +=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 20) & 0x1);
                            }

                        }                        

                    }
                }

                break;
            }
            case(0xf):
            {
                break;
            }
            default: std::runtime_error("In HigherOrderUnivariateTableUpdate: unkown ID detected (neither normal, horizontal, vertical, memory, memoryshadow, fullhr or fullvr)"); break;
        }

    }  

    for(unsigned int i = 0; i < KeySize; ++i){
        TableEntry.Key.at(i) = (heuristic >> (i*8)) & 0xff;
    }

    // Search if an entry exists
    it = std::lower_bound(GlobalSet.ContingencyTable.Entries.begin(), GlobalSet.ContingencyTable.Entries.end(), TableEntry, TableEntryCompare);
    Position = std::distance(GlobalSet.ContingencyTable.Entries.begin(), it);

    // Create a new bin for each group
    if ((it == GlobalSet.ContingencyTable.Entries.end()) || (GlobalSet.ContingencyTable.Entries.at(Position).Key != TableEntry.Key)){
        GlobalSet.ContingencyTable.Entries.insert(it, TableEntry);
    }
    
    // Increment the existing bin 
    GlobalSet.ContingencyTable.Entries.at(Position).Count[ThreadSimulation.SelectedGroups[SimulationIndex]]++; 

}

//***************************************************************************************
void Software::Test::HigherOrderUnivariateTableUpdate(Software::ThreadSimulationStruct& ThreadSimulation, unsigned int SimulationIndex, Software::ProbingSetStruct& GlobalSet, Software::ProbingSetStruct& ProbingSet, std::vector<std::vector<std::vector<uint8_t>>>& ProbeValues, Software::HelperStruct& Helper, Util::TableEntryStruct& TableEntry, std::vector<std::vector<bool>>& HighOrderUnivariateRedundancy, std::vector<std::vector<uint32_t>>& ProbeInfoToStandardProbe){

    unsigned int StandardProbeIndex, KeyIndex;
    unsigned int KeySize = (ProbingSet.NumberOfProbesInSet >> 3) + 1;
    std::vector<Util::TableEntryStruct>::iterator it;
    std::iterator_traits<std::vector<Util::TableEntryStruct>::iterator>::difference_type Position;

    uint32_t ProbeClockCycle;
    uint8_t ProbeId, ProbeRegister, ProbePartnerRegister, ProbeBit, Dependency;
    uint16_t ExtensionSize;

    TableEntry.Key.resize(KeySize, 0);
    std::fill(TableEntry.Key.begin(), TableEntry.Key.end(), 0); 

    KeyIndex = 0;

    for (StandardProbeIndex = 0; StandardProbeIndex < ProbingSet.StandardProbe.size(); ++StandardProbeIndex){

        //resolve mapping from probes to standard probes
        std::vector<uint32_t> ResolvedProbes = ProbeInfoToStandardProbe.at((ProbingSet.StandardProbe.at(StandardProbeIndex).ProbeInfo >> 8) & 0x7ffff);

        Software::Probing::ExtractAllProbeInfo(ProbeRegister, ProbeId, ProbePartnerRegister, ProbeClockCycle, ProbeBit, ExtensionSize, Dependency, ProbingSet.StandardProbe.at(StandardProbeIndex));

        switch(ProbeId){

            case(0): //memory probe
            {
                KeyIndex++; 
                TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                TableEntry.Key.at(KeyIndex >> 3) |= ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 1) & 1);


                if(ThreadSimulation.TestTransitional){
                    KeyIndex++; 
                    TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                    TableEntry.Key.at(KeyIndex >> 3) |= ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles) & 1);

                }
                break;
            }
            //memory probe shadow register
            case(1):
            {
                KeyIndex++;
                TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                TableEntry.Key.at(KeyIndex >> 3) |= (((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles ) >> ProbeBit) & 1);

                if(ThreadSimulation.TestTransitional){
                    KeyIndex++; 
                    TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                    TableEntry.Key.at(KeyIndex >> 3) |= ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> (32 + ProbeBit)) & 1);
                }
                break;

            }

            //memory probe shadow register horizontal
            case(2):{
                for(const auto& BitIdx: Helper.HorizontalBitsIncluded.at(17)){
                    KeyIndex++; 
                    TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                    TableEntry.Key.at(KeyIndex >> 3) |= ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> (BitIdx) ) & 1);

                    if(ThreadSimulation.TestTransitional){
                        KeyIndex++; 
                        TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                        TableEntry.Key.at(KeyIndex >> 3) |= ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> (32 + BitIdx)) & 1);

                    }
                }
                break;
            }

            case(3): //normal probe
            {
                for(const auto& resolvedProbe: ResolvedProbes){
                    uint8_t resolvedProbeRegister = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolvedProbeBit = resolvedProbe & 0x1f;
                    uint8_t resolvedTransition = (resolvedProbe >> 19) & 0x1;
                    if(!HighOrderUnivariateRedundancy.at(resolvedProbeRegister << resolvedTransition).at(resolvedProbeBit)){ //not yet probed in ProbingSet -> add to table

                        HighOrderUnivariateRedundancy.at(resolvedProbeRegister << resolvedTransition).at(resolvedProbeBit) = true;

                        if(!resolvedTransition){
                            KeyIndex++; 
                            TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                            TableEntry.Key.at(KeyIndex >> 3) |= ((ProbeValues.at(resolvedProbeRegister).at(resolvedProbeBit).at(ProbeClockCycle) >> (SimulationIndex & 0x7)) & 1);
                        }
                        else{
                            KeyIndex++; 
                            TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                            TableEntry.Key.at(KeyIndex >> 3) |= ((ProbeValues.at(resolvedProbeRegister).at(resolvedProbeBit).at((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles & 0xffffffff)) >> (SimulationIndex & 0x7)) & 1);
                        }

                    } 
                }
                


                break;
            }


            case(4): //horizontal Probe
            {

                for(const auto& resolvedProbe: ResolvedProbes){
                    uint8_t resolvedProbeRegister = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolvedProbeBit = resolvedProbe & 0x1f;
                    uint8_t resolvedTransition = (resolvedProbe >> 19) & 0x1;
                    if(!HighOrderUnivariateRedundancy.at(resolvedProbeRegister << resolvedTransition).at(resolvedProbeBit)){ //not yet probed in ProbingSet -> add to table
                        HighOrderUnivariateRedundancy.at(resolvedProbeRegister << resolvedTransition).at(resolvedProbeBit) = true;

                        if(!resolvedTransition){
                            KeyIndex++; 
                            TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                            TableEntry.Key.at(KeyIndex >> 3) |= ((ProbeValues.at(resolvedProbeRegister).at(resolvedProbeBit).at(ProbeClockCycle) >> (SimulationIndex & 0x7) ) & 1);
                        }
                        else{
                            KeyIndex++; 
                            TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                            TableEntry.Key.at(KeyIndex >> 3) |= ((ProbeValues.at(resolvedProbeRegister).at(resolvedProbeBit).at((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles & 0xffffffff)) >> (SimulationIndex & 0x7)) & 1);

                        }

                    }

                }
                break;
            }


            case(5): //small vertical Probe
            {
                for(const auto& resolvedProbe: ResolvedProbes){
                    uint8_t resolvedProbeRegister = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolvedProbeBit = resolvedProbe & 0x1f;
                    uint8_t resolvedTransition = (resolvedProbe >> 19) & 0x1;
                    if(!HighOrderUnivariateRedundancy.at(resolvedProbeRegister << resolvedTransition).at(resolvedProbeBit)){
                        HighOrderUnivariateRedundancy.at(resolvedProbeRegister << resolvedTransition).at(resolvedProbeBit) = true;
                        if(!resolvedTransition){
                            if(resolvedProbeRegister != ProbePartnerRegister){
                                KeyIndex++; 
                                TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                                TableEntry.Key.at(KeyIndex >> 3) |= ((ProbeValues.at(resolvedProbeRegister).at(resolvedProbeBit).at(ProbeClockCycle) >> (SimulationIndex & 0x7)) & 1);
                            }
                            else{
                                KeyIndex++; 
                                TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                                TableEntry.Key.at(KeyIndex >> 3) |= ((ProbeValues.at(resolvedProbeRegister).at(resolvedProbeBit).at((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 32)) >> (SimulationIndex & 0x7)) & 1);
                            }
                        }
                        else{
                            KeyIndex++; 
                            TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                            TableEntry.Key.at(KeyIndex >> 3) |= ((ProbeValues.at(ProbeRegister).at(ProbeBit).at((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles & 0xffffffff)) >> (SimulationIndex & 0x7)) & 1);
                        }
                    }
                }

                break;

            }


            case(6): //large vertical probe
            {
                for(const auto& resolvedProbe: ResolvedProbes){
                    uint8_t resolvedProbeRegister = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolvedProbeBit = resolvedProbe & 0x1f;
                    uint8_t resolvedTransition = (resolvedProbe >> 19) & 0x1;
                    if(!HighOrderUnivariateRedundancy.at(resolvedProbeRegister << resolvedTransition).at(resolvedProbeBit)){
                        HighOrderUnivariateRedundancy.at(resolvedProbeRegister << resolvedTransition).at(resolvedProbeBit) = true;
                        if(!resolvedTransition){
                            if(resolvedProbeRegister != ProbePartnerRegister){
                                KeyIndex++; 
                                TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                                TableEntry.Key.at(KeyIndex >> 3) |= ((ProbeValues.at(resolvedProbeRegister).at(resolvedProbeBit).at(ProbeClockCycle) >> (SimulationIndex & 0x7)) & 1);
                            }
                            else{
                                KeyIndex++; 
                                TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                                TableEntry.Key.at(KeyIndex >> 3) |= ((ProbeValues.at(resolvedProbeRegister).at(resolvedProbeBit).at(ProbeClockCycle) >> (SimulationIndex & 0x7)) & 1);
                            }
                        }
                        else{
                            if(resolvedProbeRegister != ProbePartnerRegister){
                                KeyIndex++; 
                                TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                                TableEntry.Key.at(KeyIndex >> 3) |= ((ProbeValues.at(resolvedProbeRegister).at(resolvedProbeBit).at((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles & 0xffffffff)) >> (SimulationIndex & 0x7)) & 1);
                            }
                            else{
                                KeyIndex++; 
                                TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                                TableEntry.Key.at(KeyIndex >> 3) |= ((ProbeValues.at(resolvedProbeRegister).at(resolvedProbeBit).at((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 32)) >> (SimulationIndex & 0x7)) & 1);
                            }

                        }
                    }
                }

                break;

            }

            case(7)://small full HR probe
            {
                for(const auto& resolvedProbe: ResolvedProbes){
                    uint8_t resolvedProbeRegister = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolvedProbeBit = resolvedProbe & 0x1f;
                    uint8_t resolvedTransition = (resolvedProbe >> 19) & 0x1;
                    if(!HighOrderUnivariateRedundancy.at(resolvedProbeRegister << resolvedTransition).at(resolvedProbeBit)){
                        HighOrderUnivariateRedundancy.at(resolvedProbeRegister << resolvedTransition).at(resolvedProbeBit) = true;
                        if(!resolvedTransition){
                            if(resolvedProbeRegister != ProbePartnerRegister){
                                KeyIndex++;
                                TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                                TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbeValues.at(resolvedProbeRegister).at(resolvedProbeBit).at(ProbeClockCycle) >> (SimulationIndex & 0x7)) & 1); //destination register of probe 
                            }
                            else{
                                KeyIndex++;
                                TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                                TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbeValues.at(resolvedProbeRegister).at(resolvedProbeBit).at((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 32)) >> (SimulationIndex & 0x7)) & 1); 
                            }
                        }
                        else{
                            KeyIndex++;
                            TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                            TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbeValues.at(resolvedProbeRegister).at(resolvedProbeBit).at((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles & 0xffffffff)) >> (SimulationIndex & 0x7)) & 1); //transition of destination register of probe
                            
                        }
                    }
                }

                break;

            }
            case(8):
            {
                for(const auto& resolvedProbe: ResolvedProbes){
                    uint8_t resolvedProbeRegister = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolvedProbeBit = resolvedProbe & 0x1f;
                    uint8_t resolvedTransition = (resolvedProbe >> 19) & 0x1;
                    if(!HighOrderUnivariateRedundancy.at(resolvedProbeRegister << resolvedTransition).at(resolvedProbeBit)){
                        HighOrderUnivariateRedundancy.at(resolvedProbeRegister << resolvedTransition).at(resolvedProbeBit) = true;
                        if(!resolvedTransition){
                            if(resolvedProbeRegister != ProbePartnerRegister){
                                KeyIndex++;
                                TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                                TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbeValues.at(resolvedProbeRegister).at(resolvedProbeBit).at(ProbeClockCycle) >> (SimulationIndex & 0x7)) & 1); //destination register of probe 
                            }
                            else{
                                KeyIndex++;
                                TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                                TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbeValues.at(resolvedProbeRegister).at(resolvedProbeBit).at(ProbeClockCycle) >> (SimulationIndex & 0x7)) & 1); //transition of destination register of probe
                            }
                        }
                        else{
                            if(resolvedProbeRegister != ProbePartnerRegister){
                                KeyIndex++;
                                TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                                TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbeValues.at(resolvedProbeRegister).at(resolvedProbeBit).at((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles & 0xffffffff)) >> (SimulationIndex & 0x7)) & 1); 
                            }
                            else{
                                KeyIndex++;
                                TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                                TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbeValues.at(resolvedProbeRegister).at(resolvedProbeBit).at((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 32)) >> (SimulationIndex & 0x7)) & 1);
                            }
                        }
                    }
                }

                break;
            }
            case(9): //small full VR probe
            {
                for(const auto& resolvedProbe: ResolvedProbes){
                    uint8_t resolvedProbeRegister = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolvedProbeBit = resolvedProbe & 0x1f;
                    uint8_t resolvedTransition = (resolvedProbe >> 19) & 0x1;
                    if(!HighOrderUnivariateRedundancy.at(resolvedProbeRegister << resolvedTransition).at(resolvedProbeBit)){
                        HighOrderUnivariateRedundancy.at(resolvedProbeRegister << resolvedTransition).at(resolvedProbeBit) = true;

                        if(!resolvedTransition){
                            KeyIndex++;
                            TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                            TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> resolvedProbeRegister) & 0x1);
                        }
                        else{
                            if(resolvedProbeRegister == ProbeRegister){
                                KeyIndex++;
                                TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                                TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 17) & 0x1);
                            }
                            else if(resolvedProbeRegister == ProbePartnerRegister){
                                KeyIndex++;
                                TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                                TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 18) & 0x1);
                            }

                        }

                    }
                }

                break;
            }
            case(10): // large full VR probe
            {
                for(const auto& resolvedProbe: ResolvedProbes){
                    uint8_t resolvedProbeRegister = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolvedProbeBit = resolvedProbe & 0x1f;
                    uint8_t resolvedTransition = (resolvedProbe >> 19) & 0x1;
                    if(!HighOrderUnivariateRedundancy.at(resolvedProbeRegister << resolvedTransition).at(resolvedProbeBit)){
                        HighOrderUnivariateRedundancy.at(resolvedProbeRegister << resolvedTransition).at(resolvedProbeBit) = true;
                        
                        if(!resolvedTransition){
                            KeyIndex++;
                            TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                            TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> resolvedProbeRegister) & 0x1);
                        }
                        else{
                            if(resolvedProbeRegister == ProbeRegister){
                                KeyIndex++;
                                TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                                TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 17) & 0x1);
                            }
                            else if(resolvedProbeRegister == 15){
                                KeyIndex++;
                                TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                                TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 18) & 0x1);
                            }
                            else if(resolvedProbeRegister == 16){
                                KeyIndex++;
                                TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                                TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 19) & 0x1);
                            }

                        }

                    }
                }

                break;
            }
            case(11): //special full VR probe
            {
                for(const auto& resolvedProbe: ResolvedProbes){
                    uint8_t resolvedProbeRegister = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolvedProbeBit = resolvedProbe & 0x1f;
                    uint8_t resolvedTransition = (resolvedProbe >> 19) & 0x1;
                    if(!HighOrderUnivariateRedundancy.at(resolvedProbeRegister << resolvedTransition).at(resolvedProbeBit)){
                        HighOrderUnivariateRedundancy.at(resolvedProbeRegister << resolvedTransition).at(resolvedProbeBit) = true;
                        
                        if(!resolvedTransition){
                            KeyIndex++;
                            TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                            TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> resolvedProbeRegister) & 0x1); 
                        }
                        else{
                            if(resolvedProbeRegister == ProbeRegister){
                                KeyIndex++;
                                TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                                TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 17) & 0x1);
                            }
                        }

                    }
                }

                break;                
            }
            case(12): //small DSP full VR probe
            {
                for(const auto& resolvedProbe: ResolvedProbes){
                    uint8_t resolvedProbeRegister = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolvedProbeBit = resolvedProbe & 0x1f;
                    uint8_t resolvedTransition = (resolvedProbe >> 19) & 0x1;
                    if(!HighOrderUnivariateRedundancy.at(resolvedProbeRegister << resolvedTransition).at(resolvedProbeBit)){
                        HighOrderUnivariateRedundancy.at(resolvedProbeRegister << resolvedTransition).at(resolvedProbeBit) = true;
                        
                        if(!resolvedTransition){
                            KeyIndex++;
                            TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                            TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> resolvedProbeRegister) & 0x1);
                        }
                        else{
                            if(resolvedProbeRegister == ProbeRegister){
                                KeyIndex++;
                                TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                                TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 17) & 0x1);
                            }
                            else if(resolvedProbeRegister == ProbePartnerRegister){
                                KeyIndex++;
                                TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                                TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 18) & 0x1);
                            }
                            else if(resolvedProbeRegister == 16){
                                KeyIndex++;
                                TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                                TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 19) & 0x1);
                            }

                        }

                    }
                }

                break;
            }
            case(13): //large DSP full VR probe
            {
                for(const auto& resolvedProbe: ResolvedProbes){
                    uint8_t resolvedProbeRegister = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolvedProbeBit = resolvedProbe & 0x1f;
                    uint8_t resolvedTransition = (resolvedProbe >> 19) & 0x1;
                    if(!HighOrderUnivariateRedundancy.at(resolvedProbeRegister << resolvedTransition).at(resolvedProbeBit)){
                        HighOrderUnivariateRedundancy.at(resolvedProbeRegister << resolvedTransition).at(resolvedProbeBit) = true;

                        if(!resolvedTransition){
                            KeyIndex++;
                            TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                            TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> resolvedProbeRegister) & 0x1);
                        }
                        else{
                            if(resolvedProbeRegister == ProbeRegister){
                                KeyIndex++;
                                TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                                TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 17) & 0x1);
                            }
                            else if(resolvedProbeRegister == ProbePartnerRegister){
                                KeyIndex++;
                                TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                                TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 18) & 0x1);
                            }
                            else if(resolvedProbeRegister == 15){
                                KeyIndex++;
                                TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                                TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 19) & 0x1);
                            }
                            else if(resolvedProbeRegister == 16){
                                KeyIndex++;
                                TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                                TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 20) & 0x1);
                            }

                        }                        

                    }
                }

                break;
            }
            case(0xf):
            {
                break;
            }
            default: std::runtime_error("In HigherOrderUnivariateTableUpdate: unkown ID detected (neither normal, horizontal, vertical, memory, memoryshadow, fullhr or fullvr)"); break;
        }

    }  

    // Search if an entry exists
    it = std::lower_bound(GlobalSet.ContingencyTable.Entries.begin(), GlobalSet.ContingencyTable.Entries.end(), TableEntry, TableEntryCompare);
    Position = std::distance(GlobalSet.ContingencyTable.Entries.begin(), it);

    // Create a new bin for each group
    if ((it == GlobalSet.ContingencyTable.Entries.end()) || (GlobalSet.ContingencyTable.Entries.at(Position).Key != TableEntry.Key)){
        GlobalSet.ContingencyTable.Entries.insert(it, TableEntry);
    }
    
    // Increment the existing bin 
    GlobalSet.ContingencyTable.Entries.at(Position).Count[ThreadSimulation.SelectedGroups[SimulationIndex]]++; 

}

//***************************************************************************************

void Software::Test::HigherOrderMultivariateTableUpdate(Software::ThreadSimulationStruct& ThreadSimulation, uint32_t SimulationIndex, Software::ProbingSetStruct& GlobalSet, Software::ProbingSetStruct& ProbingSet, std::vector<std::vector<std::vector<uint8_t>>>& ProbeValues, Software::HelperStruct& Helper, Util::TableEntryStruct& TableEntry, std::vector<std::vector<uint32_t>>& ProbeInfoToStandardProbe){
    unsigned int StandardProbeIndex, KeyIndex;
    unsigned int KeySize = (ProbingSet.NumberOfProbesInSet >> 3) + 1;
    std::vector<Util::TableEntryStruct>::iterator it;
    std::iterator_traits<std::vector<Util::TableEntryStruct>::iterator>::difference_type Position;

    uint32_t ProbeClockCycle;
    uint8_t ProbeId, ProbeRegister, ProbePartnerRegister, ProbeBit, Dependency;
    uint16_t ExtensionSize;

    TableEntry.Key.resize(KeySize, 0);
    std::fill(TableEntry.Key.begin(), TableEntry.Key.end(), 0); 

    KeyIndex = 0;

    for (StandardProbeIndex = 0; StandardProbeIndex < ProbingSet.StandardProbe.size(); ++StandardProbeIndex){

        //resolve mapping from probes to standard probes
        std::vector<uint32_t> ResolvedProbes = ProbeInfoToStandardProbe.at((ProbingSet.StandardProbe.at(StandardProbeIndex).ProbeInfo >> 8) & 0x7ffff); 

        Software::Probing::ExtractAllProbeInfo(ProbeRegister, ProbeId, ProbePartnerRegister, ProbeClockCycle, ProbeBit, ExtensionSize, Dependency, ProbingSet.StandardProbe.at(StandardProbeIndex));

        switch(ProbeId){

            case(0): //memory probe
            {
                KeyIndex++; 
                TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                TableEntry.Key.at(KeyIndex >> 3) |= ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 1) & 1);


                if(ThreadSimulation.TestTransitional){
                    KeyIndex++; 
                    TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                    TableEntry.Key.at(KeyIndex >> 3) |= ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles) & 1);

                }
                break;
            }
            //memory probe shadow register
            case(1):
            {
                KeyIndex++;
                TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                TableEntry.Key.at(KeyIndex >> 3) |= (((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles ) >> ProbeBit) & 1);

                if(ThreadSimulation.TestTransitional){
                    KeyIndex++; 
                    TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                    TableEntry.Key.at(KeyIndex >> 3) |= ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> (32 + ProbeBit)) & 1);
                }
                break;

            }

            //memory probe shadow register horizontal
            case(2):{
                for(const auto& BitIdx: Helper.HorizontalBitsIncluded.at(17)){
                    KeyIndex++; 
                    TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                    TableEntry.Key.at(KeyIndex >> 3) |= ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> (BitIdx) ) & 1);

                    if(ThreadSimulation.TestTransitional){
                        KeyIndex++; 
                        TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                        TableEntry.Key.at(KeyIndex >> 3) |= ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> (32 + BitIdx)) & 1);

                    }
                }
                break;
            }

            case(3): //normal probe
            {
                for(const auto& resolvedProbe: ResolvedProbes){
                    uint8_t resolvedProbeRegister = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolvedProbeBit = resolvedProbe & 0x1f;
                    uint8_t resolvedTransition = (resolvedProbe >> 19) & 0x1;

                    if(!resolvedTransition){
                        KeyIndex++; 
                        TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                        TableEntry.Key.at(KeyIndex >> 3) |= ((ProbeValues.at(resolvedProbeRegister).at(resolvedProbeBit).at(ProbeClockCycle) >> (SimulationIndex & 0x7)) & 1);
                    }
                    else{
                        KeyIndex++; 
                        TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                        TableEntry.Key.at(KeyIndex >> 3) |= ((ProbeValues.at(resolvedProbeRegister).at(resolvedProbeBit).at((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles & 0xffffffff)) >> (SimulationIndex & 0x7)) & 1);
                    }
                }
                
                break;
            }


            case(4): //horizontal Probe
            {

                for(const auto& resolvedProbe: ResolvedProbes){
                    uint8_t resolvedProbeRegister = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolvedProbeBit = resolvedProbe & 0x1f;
                    uint8_t resolvedTransition = (resolvedProbe >> 19) & 0x1;

                        if(!resolvedTransition){
                            KeyIndex++; 
                            TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                            TableEntry.Key.at(KeyIndex >> 3) |= ((ProbeValues.at(resolvedProbeRegister).at(resolvedProbeBit).at(ProbeClockCycle) >> (SimulationIndex & 0x7) ) & 1);
                        }
                        else{
                            KeyIndex++; 
                            TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                            TableEntry.Key.at(KeyIndex >> 3) |= ((ProbeValues.at(resolvedProbeRegister).at(resolvedProbeBit).at((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles & 0xffffffff)) >> (SimulationIndex & 0x7)) & 1);

                        }


                }
                break;
            }


            case(5): //small vertical Probe
            {
                for(const auto& resolvedProbe: ResolvedProbes){
                    uint8_t resolvedProbeRegister = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolvedProbeBit = resolvedProbe & 0x1f;
                    uint8_t resolvedTransition = (resolvedProbe >> 19) & 0x1;

                        if(!resolvedTransition){
                            if(resolvedProbeRegister != ProbePartnerRegister){
                                KeyIndex++; 
                                TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                                TableEntry.Key.at(KeyIndex >> 3) |= ((ProbeValues.at(resolvedProbeRegister).at(resolvedProbeBit).at(ProbeClockCycle) >> (SimulationIndex & 0x7)) & 1);
                            }
                            else{
                                KeyIndex++; 
                                TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                                TableEntry.Key.at(KeyIndex >> 3) |= ((ProbeValues.at(resolvedProbeRegister).at(resolvedProbeBit).at((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 32)) >> (SimulationIndex & 0x7)) & 1);
                            }
                        }
                        else{
                            KeyIndex++; 
                            TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                            TableEntry.Key.at(KeyIndex >> 3) |= ((ProbeValues.at(ProbeRegister).at(ProbeBit).at((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles & 0xffffffff)) >> (SimulationIndex & 0x7)) & 1);
                        }
                    
                }

                break;

            }

            case(6): //large vertical probe
            {
                for(const auto& resolvedProbe: ResolvedProbes){
                    uint8_t resolvedProbeRegister = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolvedProbeBit = resolvedProbe & 0x1f;
                    uint8_t resolvedTransition = (resolvedProbe >> 19) & 0x1;

                        if(!resolvedTransition){
                            if(resolvedProbeRegister != ProbePartnerRegister){
                                KeyIndex++; 
                                TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                                TableEntry.Key.at(KeyIndex >> 3) |= ((ProbeValues.at(resolvedProbeRegister).at(resolvedProbeBit).at(ProbeClockCycle) >> (SimulationIndex & 0x7)) & 1);
                            }
                            else{
                                KeyIndex++; 
                                TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                                TableEntry.Key.at(KeyIndex >> 3) |= ((ProbeValues.at(resolvedProbeRegister).at(resolvedProbeBit).at(ProbeClockCycle) >> (SimulationIndex & 0x7)) & 1);
                            }
                        }
                        else{
                            if(resolvedProbeRegister != ProbePartnerRegister){
                                KeyIndex++; 
                                TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                                TableEntry.Key.at(KeyIndex >> 3) |= ((ProbeValues.at(resolvedProbeRegister).at(resolvedProbeBit).at((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles & 0xffffffff)) >> (SimulationIndex & 0x7)) & 1);
                            }
                            else{
                                KeyIndex++; 
                                TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                                TableEntry.Key.at(KeyIndex >> 3) |= ((ProbeValues.at(resolvedProbeRegister).at(resolvedProbeBit).at((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 32)) >> (SimulationIndex & 0x7)) & 1);
                            }

                        }
        
                }

                break;


            }

            case(7)://small full HR probe
            {
                for(const auto& resolvedProbe: ResolvedProbes){
                    uint8_t resolvedProbeRegister = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolvedProbeBit = resolvedProbe & 0x1f;
                    uint8_t resolvedTransition = (resolvedProbe >> 19) & 0x1;

                        if(!resolvedTransition){
                            if(resolvedProbeRegister != ProbePartnerRegister){
                                KeyIndex++;
                                TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                                TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbeValues.at(resolvedProbeRegister).at(resolvedProbeBit).at(ProbeClockCycle) >> (SimulationIndex & 0x7)) & 1); //destination register of probe 
                            }
                            else{
                                KeyIndex++;
                                TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                                TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbeValues.at(resolvedProbeRegister).at(resolvedProbeBit).at((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 32)) >> (SimulationIndex & 0x7)) & 1); 
                            }
                        }
                        else{
                            KeyIndex++;
                            TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                            TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbeValues.at(resolvedProbeRegister).at(resolvedProbeBit).at((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles & 0xffffffff)) >> (SimulationIndex & 0x7)) & 1); //transition of destination register of probe
                            
                        }
                    
                }

                break;

            }
            case(8):
            {
                for(const auto& resolvedProbe: ResolvedProbes){
                    uint8_t resolvedProbeRegister = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolvedProbeBit = resolvedProbe & 0x1f;
                    uint8_t resolvedTransition = (resolvedProbe >> 19) & 0x1;

                        if(!resolvedTransition){
                            if(resolvedProbeRegister != ProbePartnerRegister){
                                KeyIndex++;
                                TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                                TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbeValues.at(resolvedProbeRegister).at(resolvedProbeBit).at(ProbeClockCycle) >> (SimulationIndex & 0x7)) & 1); //destination register of probe 
                            }
                            else{
                                KeyIndex++;
                                TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                                TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbeValues.at(resolvedProbeRegister).at(resolvedProbeBit).at(ProbeClockCycle) >> (SimulationIndex & 0x7)) & 1); //transition of destination register of probe
                            }
                        }
                        else{
                            if(resolvedProbeRegister != ProbePartnerRegister){
                                KeyIndex++;
                                TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                                TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbeValues.at(resolvedProbeRegister).at(resolvedProbeBit).at((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles & 0xffffffff)) >> (SimulationIndex & 0x7)) & 1); 
                            }
                            else{
                                KeyIndex++;
                                TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                                TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbeValues.at(resolvedProbeRegister).at(resolvedProbeBit).at((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 32)) >> (SimulationIndex & 0x7)) & 1);
                            }
                        }
                    
                }

                break;
            }
            case(9): //small full VR probe
            {
                for(const auto& resolvedProbe: ResolvedProbes){
                    uint8_t resolvedProbeRegister = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolvedTransition = (resolvedProbe >> 19) & 0x1;


                        if(!resolvedTransition){
                            KeyIndex++;
                            TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                            TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> resolvedProbeRegister) & 0x1);
                        }
                        else{
                            if(resolvedProbeRegister == ProbeRegister){
                                KeyIndex++;
                                TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                                TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 17) & 0x1);
                            }
                            else if(resolvedProbeRegister == ProbePartnerRegister){
                                KeyIndex++;
                                TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                                TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 18) & 0x1);
                            }

                        }

                    
                }

                break;
            }
            case(10): // large full VR probe
            {
                for(const auto& resolvedProbe: ResolvedProbes){
                    uint8_t resolvedProbeRegister = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolvedTransition = (resolvedProbe >> 19) & 0x1;

                        
                        if(!resolvedTransition){
                            KeyIndex++;
                            TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                            TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> resolvedProbeRegister) & 0x1);
                        }
                        else{
                            if(resolvedProbeRegister == ProbeRegister){
                                KeyIndex++;
                                TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                                TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 17) & 0x1);
                            }
                            else if(resolvedProbeRegister == 15){
                                KeyIndex++;
                                TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                                TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 18) & 0x1);
                            }
                            else if(resolvedProbeRegister == 16){
                                KeyIndex++;
                                TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                                TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 19) & 0x1);
                            }

                        }

                    
                }

                break;
            }
            case(11): //special full VR probe
            {
                for(const auto& resolvedProbe: ResolvedProbes){
                    uint8_t resolvedProbeRegister = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolvedTransition = (resolvedProbe >> 19) & 0x1;

                        
                        if(!resolvedTransition){
                            KeyIndex++;
                            TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                            TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> resolvedProbeRegister) & 0x1); 
                        }
                        else{
                            if(resolvedProbeRegister == ProbeRegister){
                                KeyIndex++;
                                TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                                TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 17) & 0x1);
                            }
                        }

                    
                }

                break;                
            }
            case(12): //small DSP full VR probe
            {
                for(const auto& resolvedProbe: ResolvedProbes){
                    uint8_t resolvedProbeRegister = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolvedTransition = (resolvedProbe >> 19) & 0x1;

                        
                        if(!resolvedTransition){
                            KeyIndex++;
                            TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                            TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> resolvedProbeRegister) & 0x1);
                        }
                        else{
                            if(resolvedProbeRegister == ProbeRegister){
                                KeyIndex++;
                                TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                                TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 17) & 0x1);
                            }
                            else if(resolvedProbeRegister == ProbePartnerRegister){
                                KeyIndex++;
                                TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                                TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 18) & 0x1);
                            }
                            else if(resolvedProbeRegister == 16){
                                KeyIndex++;
                                TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                                TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 19) & 0x1);
                            }

                        }

                    
                }

                break;
            }
            case(13): //large DSP full VR probe
            {
                for(const auto& resolvedProbe: ResolvedProbes){
                    uint8_t resolvedProbeRegister = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolvedTransition = (resolvedProbe >> 19) & 0x1;


                        if(!resolvedTransition){
                            KeyIndex++;
                            TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                            TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> resolvedProbeRegister) & 0x1);
                        }
                        else{
                            if(resolvedProbeRegister == ProbeRegister){
                                KeyIndex++;
                                TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                                TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 17) & 0x1);
                            }
                            else if(resolvedProbeRegister == ProbePartnerRegister){
                                KeyIndex++;
                                TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                                TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 18) & 0x1);
                            }
                            else if(resolvedProbeRegister == 15){
                                KeyIndex++;
                                TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                                TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 19) & 0x1);
                            }
                            else if(resolvedProbeRegister == 16){
                                KeyIndex++;
                                TableEntry.Key.at(KeyIndex >> 3) <<= 1;
                                TableEntry.Key.at(KeyIndex >> 3) |=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 20) & 0x1);
                            }

                        }                        

                    
                }

                break;
            }
            case(0xf):
            {

                break;
            }
            default: std::runtime_error("In HigherOrderMultivariateTableUpdate: unkown ID detected (neither normal, horizontal, vertical, memory, memoryshadow, fullhr or fullvr)"); break;
        }

    }  

    
    // Search if an entry exists
    it = std::lower_bound(GlobalSet.ContingencyTable.Entries.begin(), GlobalSet.ContingencyTable.Entries.end(), TableEntry, TableEntryCompare);
    Position = std::distance(GlobalSet.ContingencyTable.Entries.begin(), it);

    // Create a new bin for each group
    if ((it == GlobalSet.ContingencyTable.Entries.end()) || (GlobalSet.ContingencyTable.Entries.at(Position).Key != TableEntry.Key)){
        GlobalSet.ContingencyTable.Entries.insert(it, TableEntry);
    }
    
    // Increment the existing bin 
    GlobalSet.ContingencyTable.Entries.at(Position).Count[ThreadSimulation.SelectedGroups[SimulationIndex]]++; 
}

//***************************************************************************************

void Software::Test::CompactHigherOrderMultivariateTableUpdate(Software::ThreadSimulationStruct& ThreadSimulation, uint32_t SimulationIndex, Software::ProbingSetStruct& GlobalSet, Software::ProbingSetStruct& ProbingSet, std::vector<std::vector<std::vector<uint8_t>>>& ProbeValues, Software::HelperStruct& Helper, Util::TableEntryStruct& TableEntry, std::vector<std::vector<uint32_t>>& ProbeInfoToStandardProbe){
    unsigned int StandardProbeIndex;
    unsigned int KeySize = (ProbingSet.NumberOfProbesInSet >> 3) + 1;
    std::vector<Util::TableEntryStruct>::iterator it;
    std::iterator_traits<std::vector<Util::TableEntryStruct>::iterator>::difference_type Position;

    uint32_t ProbeClockCycle;
    uint8_t ProbeId, ProbeRegister, ProbePartnerRegister, ProbeBit, Dependency;
    uint16_t ExtensionSize;

    TableEntry.Key.resize(KeySize, 0);
    std::fill(TableEntry.Key.begin(), TableEntry.Key.end(), 0); 

    uint32_t heuristic = 0;

    for (StandardProbeIndex = 0; StandardProbeIndex < ProbingSet.StandardProbe.size(); ++StandardProbeIndex){

        //resolve mapping from probes to standard probes
        std::vector<uint32_t> ResolvedProbes = ProbeInfoToStandardProbe.at((ProbingSet.StandardProbe.at(StandardProbeIndex).ProbeInfo >> 8) & 0x7ffff); 

        Software::Probing::ExtractAllProbeInfo(ProbeRegister, ProbeId, ProbePartnerRegister, ProbeClockCycle, ProbeBit, ExtensionSize, Dependency, ProbingSet.StandardProbe.at(StandardProbeIndex));

        switch(ProbeId){

            case(0): //memory probe
            {
                heuristic += ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 1) & 1);


                if(ThreadSimulation.TestTransitional){
                    heuristic += ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles) & 1);

                }
                break;
            }
            //memory probe shadow register
            case(1):
            {
                heuristic += (((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles ) >> ProbeBit) & 1);

                if(ThreadSimulation.TestTransitional){
                    heuristic += ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> (32 + ProbeBit)) & 1);
                }
                break;

            }

            //memory probe shadow register horizontal
            case(2):{
                for(const auto& BitIdx: Helper.HorizontalBitsIncluded.at(17)){
                    heuristic += ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> (BitIdx) ) & 1);

                    if(ThreadSimulation.TestTransitional){
                        heuristic += ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> (32 + BitIdx)) & 1);

                    }
                }
                break;
            }

            case(3): //normal probe
            {
                for(const auto& resolvedProbe: ResolvedProbes){
                    uint8_t resolvedProbeRegister = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolvedProbeBit = resolvedProbe & 0x1f;
                    uint8_t resolvedTransition = (resolvedProbe >> 19) & 0x1;

                    if(!resolvedTransition){
                        heuristic += ((ProbeValues.at(resolvedProbeRegister).at(resolvedProbeBit).at(ProbeClockCycle) >> (SimulationIndex & 0x7)) & 1);
                    }
                    else{
                        heuristic += ((ProbeValues.at(resolvedProbeRegister).at(resolvedProbeBit).at((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles & 0xffffffff)) >> (SimulationIndex & 0x7)) & 1);
                    }
                }
                
                break;
            }

            case(4): //horizontal Probe
            {

                for(const auto& resolvedProbe: ResolvedProbes){
                    uint8_t resolvedProbeRegister = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolvedProbeBit = resolvedProbe & 0x1f;
                    uint8_t resolvedTransition = (resolvedProbe >> 19) & 0x1;

                        if(!resolvedTransition){
                            heuristic += ((ProbeValues.at(resolvedProbeRegister).at(resolvedProbeBit).at(ProbeClockCycle) >> (SimulationIndex & 0x7) ) & 1);
                        }
                        else{
                            heuristic += ((ProbeValues.at(resolvedProbeRegister).at(resolvedProbeBit).at((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles & 0xffffffff)) >> (SimulationIndex & 0x7)) & 1);

                        }


                }
                break;
            }


            case(5): //small vertical Probe
            {
                for(const auto& resolvedProbe: ResolvedProbes){
                    uint8_t resolvedProbeRegister = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolvedProbeBit = resolvedProbe & 0x1f;
                    uint8_t resolvedTransition = (resolvedProbe >> 19) & 0x1;

                        if(!resolvedTransition){
                            if(resolvedProbeRegister != ProbePartnerRegister){
                                heuristic += ((ProbeValues.at(resolvedProbeRegister).at(resolvedProbeBit).at(ProbeClockCycle) >> (SimulationIndex & 0x7)) & 1);
                            }
                            else{
                                heuristic += ((ProbeValues.at(resolvedProbeRegister).at(resolvedProbeBit).at((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 32)) >> (SimulationIndex & 0x7)) & 1);
                            }
                        }
                        else{
                            heuristic += ((ProbeValues.at(ProbeRegister).at(ProbeBit).at((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles & 0xffffffff)) >> (SimulationIndex & 0x7)) & 1);
                        }
                    
                }

                break;

            }

            case(6): //large vertical probe
            {
                for(const auto& resolvedProbe: ResolvedProbes){
                    uint8_t resolvedProbeRegister = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolvedProbeBit = resolvedProbe & 0x1f;
                    uint8_t resolvedTransition = (resolvedProbe >> 19) & 0x1;

                        if(!resolvedTransition){
                            if(resolvedProbeRegister != ProbePartnerRegister){
                                heuristic += ((ProbeValues.at(resolvedProbeRegister).at(resolvedProbeBit).at(ProbeClockCycle) >> (SimulationIndex & 0x7)) & 1);
                            }
                            else{
                                heuristic += ((ProbeValues.at(resolvedProbeRegister).at(resolvedProbeBit).at(ProbeClockCycle) >> (SimulationIndex & 0x7)) & 1);
                            }
                        }
                        else{
                            if(resolvedProbeRegister != ProbePartnerRegister){
                                heuristic += ((ProbeValues.at(resolvedProbeRegister).at(resolvedProbeBit).at((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles & 0xffffffff)) >> (SimulationIndex & 0x7)) & 1);
                            }
                            else{
                                heuristic += ((ProbeValues.at(resolvedProbeRegister).at(resolvedProbeBit).at((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 32)) >> (SimulationIndex & 0x7)) & 1);
                            }

                        }
        
                }

                break;


            }

            case(7)://small full HR probe
            {
                for(const auto& resolvedProbe: ResolvedProbes){
                    uint8_t resolvedProbeRegister = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolvedProbeBit = resolvedProbe & 0x1f;
                    uint8_t resolvedTransition = (resolvedProbe >> 19) & 0x1;

                        if(!resolvedTransition){
                            if(resolvedProbeRegister != ProbePartnerRegister){
                                heuristic +=  ((ProbeValues.at(resolvedProbeRegister).at(resolvedProbeBit).at(ProbeClockCycle) >> (SimulationIndex & 0x7)) & 1); //destination register of probe 
                            }
                            else{
                                heuristic +=  ((ProbeValues.at(resolvedProbeRegister).at(resolvedProbeBit).at((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 32)) >> (SimulationIndex & 0x7)) & 1); 
                            }
                        }
                        else{
                            heuristic +=  ((ProbeValues.at(resolvedProbeRegister).at(resolvedProbeBit).at((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles & 0xffffffff)) >> (SimulationIndex & 0x7)) & 1); //transition of destination register of probe
                            
                        }
                    
                }

                break;

            }
            case(8):
            {
                for(const auto& resolvedProbe: ResolvedProbes){
                    uint8_t resolvedProbeRegister = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolvedProbeBit = resolvedProbe & 0x1f;
                    uint8_t resolvedTransition = (resolvedProbe >> 19) & 0x1;

                        if(!resolvedTransition){
                            if(resolvedProbeRegister != ProbePartnerRegister){
                                heuristic +=  ((ProbeValues.at(resolvedProbeRegister).at(resolvedProbeBit).at(ProbeClockCycle) >> (SimulationIndex & 0x7)) & 1); //destination register of probe 
                            }
                            else{
                                heuristic +=  ((ProbeValues.at(resolvedProbeRegister).at(resolvedProbeBit).at(ProbeClockCycle) >> (SimulationIndex & 0x7)) & 1); //transition of destination register of probe
                            }
                        }
                        else{
                            if(resolvedProbeRegister != ProbePartnerRegister){
                                heuristic +=  ((ProbeValues.at(resolvedProbeRegister).at(resolvedProbeBit).at((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles & 0xffffffff)) >> (SimulationIndex & 0x7)) & 1); 
                            }
                            else{
                                heuristic +=  ((ProbeValues.at(resolvedProbeRegister).at(resolvedProbeBit).at((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 32)) >> (SimulationIndex & 0x7)) & 1);
                            }
                        }
                    
                }

                break;
            }
            case(9): //small full VR probe
            {
                for(const auto& resolvedProbe: ResolvedProbes){
                    uint8_t resolvedProbeRegister = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolvedTransition = (resolvedProbe >> 19) & 0x1;


                        if(!resolvedTransition){
                            heuristic +=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> resolvedProbeRegister) & 0x1);
                        }
                        else{
                            if(resolvedProbeRegister == ProbeRegister){
                                heuristic +=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 17) & 0x1);
                            }
                            else if(resolvedProbeRegister == ProbePartnerRegister){
                                heuristic +=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 18) & 0x1);
                            }

                        }

                    
                }

                break;
            }
            case(10): // large full VR probe
            {
                for(const auto& resolvedProbe: ResolvedProbes){
                    uint8_t resolvedProbeRegister = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolvedTransition = (resolvedProbe >> 19) & 0x1;

                        
                        if(!resolvedTransition){
                            heuristic +=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> resolvedProbeRegister) & 0x1);
                        }
                        else{
                            if(resolvedProbeRegister == ProbeRegister){
                                heuristic +=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 17) & 0x1);
                            }
                            else if(resolvedProbeRegister == 15){
                                heuristic +=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 18) & 0x1);
                            }
                            else if(resolvedProbeRegister == 16){
                                heuristic +=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 19) & 0x1);
                            }

                        }

                    
                }

                break;
            }
            case(11): //special full VR probe
            {
                for(const auto& resolvedProbe: ResolvedProbes){
                    uint8_t resolvedProbeRegister = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolvedTransition = (resolvedProbe >> 19) & 0x1;

                        
                        if(!resolvedTransition){
                            heuristic +=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> resolvedProbeRegister) & 0x1); 
                        }
                        else{
                            if(resolvedProbeRegister == ProbeRegister){
                                heuristic +=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 17) & 0x1);
                            }
                        }

                    
                }

                break;                
            }
            case(12): //small DSP full VR probe
            {
                for(const auto& resolvedProbe: ResolvedProbes){
                    uint8_t resolvedProbeRegister = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolvedTransition = (resolvedProbe >> 19) & 0x1;

                        
                        if(!resolvedTransition){
                            heuristic +=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> resolvedProbeRegister) & 0x1);
                        }
                        else{
                            if(resolvedProbeRegister == ProbeRegister){
                                heuristic +=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 17) & 0x1);
                            }
                            else if(resolvedProbeRegister == ProbePartnerRegister){
                                heuristic +=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 18) & 0x1);
                            }
                            else if(resolvedProbeRegister == 16){
                                heuristic +=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 19) & 0x1);
                            }

                        }

                    
                }

                break;
            }
            case(13): //large DSP full VR probe
            {
                for(const auto& resolvedProbe: ResolvedProbes){
                    uint8_t resolvedProbeRegister = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolvedTransition = (resolvedProbe >> 19) & 0x1;


                        if(!resolvedTransition){
                            heuristic +=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> resolvedProbeRegister) & 0x1);
                        }
                        else{
                            if(resolvedProbeRegister == ProbeRegister){
                                heuristic +=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 17) & 0x1);
                            }
                            else if(resolvedProbeRegister == ProbePartnerRegister){
                                heuristic +=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 18) & 0x1);
                            }
                            else if(resolvedProbeRegister == 15){
                                heuristic +=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 19) & 0x1);
                            }
                            else if(resolvedProbeRegister == 16){
                                heuristic +=  ((ProbingSet.StandardProbe.at(StandardProbeIndex).TransitionCycles >> 20) & 0x1);
                            }

                        }                        

                    
                }

                break;
            }
            case(0xf):
            {

                break;
            }
            default: std::runtime_error("In HigherOrderMultivariateTableUpdate: unkown ID detected (neither normal, horizontal, vertical, memory, memoryshadow, fullhr or fullvr)"); break;
        }

    }  

    for(unsigned int i = 0; i < KeySize; ++i){
        TableEntry.Key.at(i) = (heuristic >> (i*8)) & 0xff;
    }
    
    // Search if an entry exists
    it = std::lower_bound(GlobalSet.ContingencyTable.Entries.begin(), GlobalSet.ContingencyTable.Entries.end(), TableEntry, TableEntryCompare);
    Position = std::distance(GlobalSet.ContingencyTable.Entries.begin(), it);

    // Create a new bin for each group
    if ((it == GlobalSet.ContingencyTable.Entries.end()) || (GlobalSet.ContingencyTable.Entries.at(Position).Key != TableEntry.Key)){
        GlobalSet.ContingencyTable.Entries.insert(it, TableEntry);
    }
    
    // Increment the existing bin 
    GlobalSet.ContingencyTable.Entries.at(Position).Count[ThreadSimulation.SelectedGroups[SimulationIndex]]++; 
}