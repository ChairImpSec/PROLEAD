#include "Software/Test.hpp"

//***************************************************************************************
void Software::Test::Test(Software::ThreadSimulationStruct& ThreadSimulation, Software::TestStruct& Test){
    uint64_t number_of_groups = ThreadSimulation.NumberOfGroups;
    uint64_t set_index;

    for ( set_index = 0; set_index < Test.GlobalProbingSets.size(); set_index++){
        Test.GlobalProbingSets[set_index].contingency_table_.SetLog10pValue(number_of_groups);
    }
}

//***************************************************************************************
void Software::Test::FirstOrderTableUpdate(Software::ThreadSimulationStruct& ThreadSimulation, unsigned int simulation_index, Software::ProbingSetStruct& GlobalSet, Software::ProbingSetStruct& ProbingSet, std::vector<std::vector<std::vector<uint8_t>>>& ProbeValues, Software::HelperStruct& Helper){
    uint64_t key_index = 0;
    uint64_t number_of_groups = ThreadSimulation.NumberOfGroups;
    uint64_t size_of_key_in_bytes = (ProbingSet.NumberOfProbesInSet >> 3) + 1;
    uint32_t clock_cycle;
    uint8_t id, register_index, partner_register_index, probed_bit, dependency;
    uint16_t extension_size;
    TableEntry dataset;

    dataset.key_ = std::make_unique<uint8_t[]>(size_of_key_in_bytes);
    dataset.data_ = std::make_unique<uint32_t[]>(number_of_groups);

    for (Software::ProbesStruct& probe : ProbingSet.StandardProbe){
        Software::Probing::ExtractAllProbeInfo(register_index, id, partner_register_index, clock_cycle, probed_bit, extension_size, dependency, probe);

        switch(id){
            case(0): //memory probe
            {
                key_index++; 
                dataset.key_[key_index >> 3] <<= 1;
                dataset.key_[key_index >> 3] |= ((probe.TransitionCycles >> 1) & 1);

                if(ThreadSimulation.TestTransitional){
                    key_index++; 
                    dataset.key_[key_index >> 3] <<= 1;
                    dataset.key_[key_index >> 3] |= ((probe.TransitionCycles) & 1);
                }

                break;
            }
            //memory probe shadow register
            case(1):
            {
                key_index++;
                dataset.key_[key_index >> 3] <<= 1;
                dataset.key_[key_index >> 3] |= (((probe.TransitionCycles ) >> probed_bit) & 1);

                if(ThreadSimulation.TestTransitional){
                    key_index++; 
                    dataset.key_[key_index >> 3] <<= 1;
                    dataset.key_[key_index >> 3] |= ((probe.TransitionCycles >> (32 + probed_bit)) & 1);
                }
                break;
            }
            //memory probe seperated load store shadow register
            case(2):
            {
                key_index++;
                dataset.key_[key_index >> 3] <<= 1;
                dataset.key_[key_index >> 3] |= (((probe.TransitionCycles ) >> probed_bit) & 1);

                if(ThreadSimulation.TestTransitional){
                    key_index++; 
                    dataset.key_[key_index >> 3] <<= 1;
                    dataset.key_[key_index >> 3] |= ((probe.TransitionCycles >> (32 + probed_bit)) & 1);
                }
                break;
            }
            //memory probe shadow register horizontal
            case(3):{
                for(const auto& BitIdx: Helper.HorizontalBitsIncluded.at(17)){
                    key_index++; 
                    dataset.key_[key_index >> 3] <<= 1;
                    dataset.key_[key_index >> 3] |= ((probe.TransitionCycles >> (BitIdx) ) & 1);

                    if(ThreadSimulation.TestTransitional){
                        key_index++; 
                        dataset.key_[key_index >> 3] <<= 1;
                        dataset.key_[key_index >> 3] |= ((probe.TransitionCycles >> (32 + BitIdx)) & 1);
                    }
                }
                break;
            }

            case(4): //normal probe
            {

                key_index++; 
                dataset.key_[key_index >> 3] <<= 1;
                dataset.key_[key_index >> 3] |= ((ProbeValues[register_index][probed_bit][clock_cycle] >> (simulation_index & 0x7)) & 1);

                if(ThreadSimulation.TestTransitional){
                    key_index++; 
                    dataset.key_[key_index >> 3] <<= 1;
                    dataset.key_[key_index >> 3] |= ((ProbeValues[register_index][probed_bit].at((probe.TransitionCycles & 0xffffffff)) >> (simulation_index & 0x7)) & 1);
                }                                                                    
                break;
            }


            case(5): //horizontal Probe
            {

                for(const auto& BitIdx: Helper.HorizontalBitsIncluded[register_index]){
                    key_index++; 
                    dataset.key_[key_index >> 3] <<= 1;
                    dataset.key_[key_index >> 3] |= ((ProbeValues[register_index].at(BitIdx)[clock_cycle] >> (simulation_index & 0x7) ) & 1);

                    if(ThreadSimulation.TestTransitional){
                        key_index++; 
                        dataset.key_[key_index >> 3] <<= 1;
                        dataset.key_[key_index >> 3] |= ((ProbeValues[register_index].at(BitIdx).at((probe.TransitionCycles & 0xffffffff)) >> (simulation_index & 0x7)) & 1);
                    }
                }
                break;
            }

            case(6): //small vertical Probe
                {
                    key_index++; 
                    dataset.key_[key_index >> 3] <<= 1;
                    dataset.key_[key_index >> 3] |= ((ProbeValues[register_index][probed_bit][clock_cycle] >> (simulation_index & 0x7)) & 1);

                    key_index++; 
                    dataset.key_[key_index >> 3] <<= 1;
                    dataset.key_[key_index >> 3] |= ((ProbeValues[partner_register_index][probed_bit].at((probe.TransitionCycles >> 32)) >> (simulation_index & 0x7)) & 1);

                    if(ThreadSimulation.TestTransitional){
                        key_index++; 
                        dataset.key_[key_index >> 3] <<= 1;
                        dataset.key_[key_index >> 3] |= ((ProbeValues[register_index][probed_bit].at((probe.TransitionCycles & 0xffffffff)) >> (simulation_index & 0x7)) & 1);
                    }
                    break;
                }

            case(7): //large vertical probe
            {
                key_index++; 
                dataset.key_[key_index >> 3] <<= 1;
                dataset.key_[key_index >> 3] |= ((ProbeValues[register_index][probed_bit][clock_cycle] >> (simulation_index & 0x7)) & 1);

                key_index++; 
                dataset.key_[key_index >> 3] <<= 1;
                dataset.key_[key_index >> 3] |= ((ProbeValues[partner_register_index][probed_bit][clock_cycle] >> (simulation_index & 0x7)) & 1);

                if(ThreadSimulation.TestTransitional){
                    key_index++; 
                    dataset.key_[key_index >> 3] <<= 1;
                    dataset.key_[key_index >> 3] |= ((ProbeValues[register_index][probed_bit].at((probe.TransitionCycles & 0xffffffff)) >> (simulation_index & 0x7)) & 1);

                    key_index++; 
                    dataset.key_[key_index >> 3] <<= 1;
                    dataset.key_[key_index >> 3] |= ((ProbeValues[partner_register_index][probed_bit].at((probe.TransitionCycles >> 32)) >> (simulation_index & 0x7)) & 1);
                }
                break;

            }
            
            case(8): //small full HR probe
            {
                for(const auto& BitIdx: Helper.NormalProbesIncluded[register_index]){
                    key_index++;
                    dataset.key_[key_index >> 3] <<= 1;
                    dataset.key_[key_index >> 3] |=  ((ProbeValues[register_index].at(BitIdx)[clock_cycle] >> (simulation_index & 0x7)) & 1); //destination register of probe 

                    if(ThreadSimulation.TestTransitional){
                        key_index++;
                        dataset.key_[key_index >> 3] <<= 1;
                        dataset.key_[key_index >> 3] |=  ((ProbeValues[register_index].at(BitIdx).at((probe.TransitionCycles & 0xffffffff)) >> (simulation_index & 0x7)) & 1); //transition of destination register of probe
                    }
                }

                for(const auto& BitIdx: Helper.NormalProbesIncluded[partner_register_index]){
                    key_index++;
                    dataset.key_[key_index >> 3] <<= 1;
                    dataset.key_[key_index >> 3] |=  ((ProbeValues[partner_register_index].at(BitIdx).at((probe.TransitionCycles >> 32)) >> (simulation_index & 0x7)) & 1); //transition of destination register of probe    
                }

                break;

            }
            case(9): //large full HR probe
            {
                for(const auto& BitIdx: Helper.NormalProbesIncluded[register_index]){
                    key_index++;
                    dataset.key_[key_index >> 3] <<= 1;
                    dataset.key_[key_index >> 3] |=  ((ProbeValues[register_index].at(BitIdx)[clock_cycle] >> (simulation_index & 0x7)) & 1); //destination register of probe 

                    if(ThreadSimulation.TestTransitional){
                        key_index++;
                        dataset.key_[key_index >> 3] <<= 1;
                        dataset.key_[key_index >> 3] |=  ((ProbeValues[register_index].at(BitIdx).at((probe.TransitionCycles & 0xffffffff)) >> (simulation_index & 0x7)) & 1); //transition of destination register of probe  
                    }
                }

                for(const auto& BitIdx: Helper.NormalProbesIncluded[partner_register_index]){
                    key_index++;
                    dataset.key_[key_index >> 3] <<= 1;
                    dataset.key_[key_index >> 3] |=  ((ProbeValues[partner_register_index].at(BitIdx)[clock_cycle] >> (simulation_index & 0x7)) & 1); //transition of destination register of probe

                    if(ThreadSimulation.TestTransitional){
                        key_index++;
                        dataset.key_[key_index >> 3] <<= 1;
                        dataset.key_[key_index >> 3] |=  ((ProbeValues[partner_register_index].at(BitIdx).at((probe.TransitionCycles >> 32)) >> (simulation_index & 0x7)) & 1); //transition of destination register of probe     
                    }        
                }
                break;
            }
            case(10): // small full VR probe
            {
                for(const auto& RegIdx: Helper.FullVerticalProbesIncluded[probed_bit]){
                    key_index++;
                    dataset.key_[key_index >> 3] <<= 1;
                    dataset.key_[key_index >> 3] |=  ((probe.TransitionCycles >> RegIdx) & 0x1); //transition of destination register of probe

                    if(ThreadSimulation.TestTransitional && (RegIdx == register_index)){
                        key_index++;
                        dataset.key_[key_index >> 3] <<= 1;
                        dataset.key_[key_index >> 3] |=  ((probe.TransitionCycles >> 17) & 0x1);
                    }
                    else if(ThreadSimulation.TestTransitional && (RegIdx == partner_register_index)){
                        key_index++;
                        dataset.key_[key_index >> 3] <<= 1;
                        dataset.key_[key_index >> 3] |=  ((probe.TransitionCycles >> 18) & 0x1);
                    }
                }
                break;
            }
            case(11): // large full VR probe
            {
                for(const auto& RegIdx: Helper.FullVerticalProbesIncluded[probed_bit]){
                    key_index++;
                    dataset.key_[key_index >> 3] <<= 1;
                    dataset.key_[key_index >> 3] |=  ((probe.TransitionCycles >> RegIdx) & 0x1); //transition of destination register of probe

                    if(ThreadSimulation.TestTransitional && (RegIdx == register_index)){
                        key_index++;
                        dataset.key_[key_index >> 3] <<= 1;
                        dataset.key_[key_index >> 3] |=  ((probe.TransitionCycles >> 17) & 0x1);
                    }
                    else if(ThreadSimulation.TestTransitional && (RegIdx == 15)){
                        key_index++;
                        dataset.key_[key_index >> 3] <<= 1;
                        dataset.key_[key_index >> 3] |=  ((probe.TransitionCycles >> 18) & 0x1);
                    }
                    else if(ThreadSimulation.TestTransitional && (RegIdx == 16)){
                        key_index++;
                        dataset.key_[key_index >> 3] <<= 1;
                        dataset.key_[key_index >> 3] |=  ((probe.TransitionCycles >> 19) & 0x1);
                    }
                }
                break;
            }
            case(12): // special full VR probe
            {
                for(const auto& RegIdx: Helper.FullVerticalProbesIncluded[probed_bit]){
                    key_index++;
                    dataset.key_[key_index >> 3] <<= 1;
                    dataset.key_[key_index >> 3] |=  ((probe.TransitionCycles >> RegIdx) & 0x1); //transition of destination register of probe

                    if(ThreadSimulation.TestTransitional && (RegIdx == register_index)){
                        key_index++;
                        dataset.key_[key_index >> 3] <<= 1;
                        dataset.key_[key_index >> 3] |=  ((probe.TransitionCycles >> 17) & 0x1);
                    }
                }
                break;
            }
            case(13):  //small DSP full VR probe
            {
                for(const auto& RegIdx: Helper.FullVerticalProbesIncluded[probed_bit]){
                    key_index++;
                    dataset.key_[key_index >> 3] <<= 1;
                    dataset.key_[key_index >> 3] |=  ((probe.TransitionCycles >> RegIdx) & 0x1); //transition of destination register of probe

                    if(ThreadSimulation.TestTransitional && (RegIdx == register_index)){
                        key_index++;
                        dataset.key_[key_index >> 3] <<= 1;
                        dataset.key_[key_index >> 3] |=  ((probe.TransitionCycles >> 17) & 0x1);
                    }
                    else if(ThreadSimulation.TestTransitional && (RegIdx == partner_register_index)){
                        key_index++;
                        dataset.key_[key_index >> 3] <<= 1;
                        dataset.key_[key_index >> 3] |=  ((probe.TransitionCycles >> 18) & 0x1);
                    }
                    else if(ThreadSimulation.TestTransitional && (RegIdx == 16)){
                        key_index++;
                        dataset.key_[key_index >> 3] <<= 1;
                        dataset.key_[key_index >> 3] |=  ((probe.TransitionCycles >> 19) & 0x1);
                    }
                }
                break;
            }
            case(14): //large DSP full VR probe
            {
                for(const auto& RegIdx: Helper.FullVerticalProbesIncluded[probed_bit]){
                    key_index++;
                    dataset.key_[key_index >> 3] <<= 1;
                    dataset.key_[key_index >> 3] |=  ((probe.TransitionCycles >> RegIdx) & 0x1); //transition of destination register of probe

                    if(ThreadSimulation.TestTransitional && (RegIdx == register_index)){
                        key_index++;
                        dataset.key_[key_index >> 3] <<= 1;
                        dataset.key_[key_index >> 3] |=  ((probe.TransitionCycles >> 17) & 0x1);
                    }
                    else if(ThreadSimulation.TestTransitional && (RegIdx == partner_register_index)){
                        key_index++;
                        dataset.key_[key_index >> 3] <<= 1;
                        dataset.key_[key_index >> 3] |=  ((probe.TransitionCycles >> 18) & 0x1);
                    }
                    else if(ThreadSimulation.TestTransitional && (RegIdx == 15)){
                        key_index++;
                        dataset.key_[key_index >> 3] <<= 1;
                        dataset.key_[key_index >> 3] |=  ((probe.TransitionCycles >> 19) & 0x1);
                    }
                    else if(ThreadSimulation.TestTransitional && (RegIdx == 16)){
                        key_index++;
                        dataset.key_[key_index >> 3] <<= 1;
                        dataset.key_[key_index >> 3] |=  ((probe.TransitionCycles >> 20) & 0x1);
                    }
                }
                break;
            }
            case(15): //pipeline forwarding probe
            {
                for(uint32_t bit_idx = 0; bit_idx < extension_size; ++bit_idx){
                    key_index++;
                    dataset.key_[key_index >> 3] <<= 1;

                    if(bit_idx >= 64){
                        dataset.key_[key_index >> 3] |= ((probe.SpecialInfo >> (bit_idx - 64)) & 0x1);
                    }
                    else{
                        dataset.key_[key_index >> 3] |= ((probe.TransitionCycles >> (bit_idx)) & 0x1);
                    }
                    
                }
                break;
            }
            default: std::runtime_error("Error while performing a first-order table update: Unknown ID detected!"); break;
        }
    }

    ++dataset.data_[ThreadSimulation.SelectedGroups[simulation_index]];
    GlobalSet.contingency_table_.UpdateBucket(dataset, number_of_groups);
}

//***************************************************************************************
void Software::Test::CompactFirstOrderTableUpdate(Software::ThreadSimulationStruct& ThreadSimulation, unsigned int simulation_index, Software::ProbingSetStruct& GlobalSet, Software::ProbingSetStruct& ProbingSet, std::vector<std::vector<std::vector<uint8_t>>>& ProbeValues, Software::HelperStruct& Helper){
    uint64_t heuristic = 0;
    uint64_t number_of_groups = ThreadSimulation.NumberOfGroups;
    uint64_t size_of_key_in_bytes = (ProbingSet.NumberOfProbesInSet >> 8) + 1;
    uint32_t clock_cycle;
    uint8_t id, register_index, partner_register_index, probed_bit, dependency;
    uint16_t extension_size;
    TableEntry dataset;

    dataset.key_ = std::make_unique<uint8_t[]>(size_of_key_in_bytes);
    dataset.data_ = std::make_unique<uint32_t[]>(number_of_groups);

    for (Software::ProbesStruct& probe : ProbingSet.StandardProbe){
        Software::Probing::ExtractAllProbeInfo(register_index, id, partner_register_index, clock_cycle, probed_bit, extension_size, dependency, probe);

        switch(id){
            case(0): //memory probe
            {
                heuristic += ((probe.TransitionCycles >> 1) & 1);

                if(ThreadSimulation.TestTransitional){
                    heuristic += ((probe.TransitionCycles) & 1);
                }
                break;
            }
            //memory probe shadow register
            case(1):
            {
                heuristic += (((probe.TransitionCycles ) >> probed_bit) & 1);

                if(ThreadSimulation.TestTransitional){
                    heuristic += ((probe.TransitionCycles >> (32 + probed_bit)) & 1);
                }
                break;

            }
            //memory probe seperated load store shadow register
            case(2):
            {
                heuristic += (((probe.TransitionCycles) >> probed_bit) & 1);
                if(ThreadSimulation.TestTransitional){
                    heuristic += ((probe.TransitionCycles >> (32 + probed_bit)) & 1);
                }
                break;
            }
            //memory probe shadow register horizontal
            case(3):{
                for(const auto& BitIdx: Helper.HorizontalBitsIncluded.at(17)){
                    heuristic += ((probe.TransitionCycles >> (BitIdx) ) & 1);

                    if(ThreadSimulation.TestTransitional){
                        heuristic += ((probe.TransitionCycles >> (32 + BitIdx)) & 1);

                    }
                }
                break;
            }

            case(4): //normal probe
            {

                heuristic += ((ProbeValues[register_index][probed_bit][clock_cycle] >> (simulation_index & 0x7)) & 1);

                if(ThreadSimulation.TestTransitional){
                    heuristic += ((ProbeValues[register_index][probed_bit].at((probe.TransitionCycles & 0xffffffff)) >> (simulation_index & 0x7)) & 1);
                }

                break;
            }


            case(5): //horizontal Probe
            {

                for(const auto& BitIdx: Helper.HorizontalBitsIncluded[register_index]){
                    heuristic += ((ProbeValues[register_index].at(BitIdx)[clock_cycle] >> (simulation_index & 0x7) ) & 1);

                    if(ThreadSimulation.TestTransitional){
                        heuristic += ((ProbeValues[register_index].at(BitIdx).at((probe.TransitionCycles & 0xffffffff)) >> (simulation_index & 0x7)) & 1);

                    }
                }
                break;
            }

            case(6): //small vertical Probe
            {
                heuristic += ((ProbeValues[register_index][probed_bit][clock_cycle] >> (simulation_index & 0x7)) & 1);
                heuristic += ((ProbeValues[partner_register_index][probed_bit].at((probe.TransitionCycles >> 32)) >> (simulation_index & 0x7)) & 1);

                if(ThreadSimulation.TestTransitional){
                    heuristic += ((ProbeValues[register_index][probed_bit].at((probe.TransitionCycles & 0xffffffff)) >> (simulation_index & 0x7)) & 1);
                }
                break;
            }
           
            case(7): //large vertical probe
            {

                heuristic += ((ProbeValues[register_index][probed_bit][clock_cycle] >> (simulation_index & 0x7)) & 1);

                heuristic += ((ProbeValues[partner_register_index][probed_bit][clock_cycle] >> (simulation_index & 0x7)) & 1);

                if(ThreadSimulation.TestTransitional){
                    heuristic += ((ProbeValues[register_index][probed_bit].at((probe.TransitionCycles & 0xffffffff)) >> (simulation_index & 0x7)) & 1);

                    heuristic += ((ProbeValues[partner_register_index][probed_bit].at((probe.TransitionCycles >> 32)) >> (simulation_index & 0x7)) & 1);
                
                }
                break;

            }


            
            case(8): //small full HR probe
            {
                for(const auto& BitIdx: Helper.NormalProbesIncluded[register_index]){
         
                    heuristic +=  ((ProbeValues[register_index].at(BitIdx)[clock_cycle] >> (simulation_index & 0x7)) & 1); //destination register of probe 

                    if(ThreadSimulation.TestTransitional){
                    
                        heuristic +=  ((ProbeValues[register_index].at(BitIdx).at((probe.TransitionCycles & 0xffffffff)) >> (simulation_index & 0x7)) & 1); //transition of destination register of probe
                        
                    }
                }

                for(const auto& BitIdx: Helper.NormalProbesIncluded[partner_register_index]){

                    heuristic +=  ((ProbeValues[partner_register_index].at(BitIdx).at((probe.TransitionCycles >> 32)) >> (simulation_index & 0x7)) & 1); //transition of destination register of probe
                        
                }

                break;

            }
            case(9): //large full HR probe
            {
                for(const auto& BitIdx: Helper.NormalProbesIncluded[register_index]){

                    heuristic +=  ((ProbeValues[register_index].at(BitIdx)[clock_cycle] >> (simulation_index & 0x7)) & 1); //destination register of probe 

                    if(ThreadSimulation.TestTransitional){

                        heuristic +=  ((ProbeValues[register_index].at(BitIdx).at((probe.TransitionCycles & 0xffffffff)) >> (simulation_index & 0x7)) & 1); //transition of destination register of probe
                        
                    }
                }

                for(const auto& BitIdx: Helper.NormalProbesIncluded[partner_register_index]){

                    heuristic +=  ((ProbeValues[partner_register_index].at(BitIdx)[clock_cycle] >> (simulation_index & 0x7)) & 1); //transition of destination register of probe

                    if(ThreadSimulation.TestTransitional){

                        heuristic +=  ((ProbeValues[partner_register_index].at(BitIdx).at((probe.TransitionCycles >> 32)) >> (simulation_index & 0x7)) & 1); //transition of destination register of probe
                        
                    }        
                
                }
                break;
            }
            case(10): // small full VR probe
            {
                for(const auto& RegIdx: Helper.FullVerticalProbesIncluded[probed_bit]){

                    heuristic +=  ((probe.TransitionCycles >> RegIdx) & 0x1); //transition of destination register of probe

                    if(ThreadSimulation.TestTransitional && (RegIdx == register_index)){

                        heuristic +=  ((probe.TransitionCycles >> 17) & 0x1);
                    }
                    else if(ThreadSimulation.TestTransitional && (RegIdx == partner_register_index)){

                        heuristic +=  ((probe.TransitionCycles >> 18) & 0x1);
                    }
                }
                break;
            }
            case(11): // large full VR probe
            {
                for(const auto& RegIdx: Helper.FullVerticalProbesIncluded[probed_bit]){

                    heuristic +=  ((probe.TransitionCycles >> RegIdx) & 0x1); //transition of destination register of probe

                    if(ThreadSimulation.TestTransitional && (RegIdx == register_index)){

                        heuristic +=  ((probe.TransitionCycles >> 17) & 0x1);
                    }
                    else if(ThreadSimulation.TestTransitional && (RegIdx == 15)){

                        heuristic +=  ((probe.TransitionCycles >> 18) & 0x1);
                    }
                    else if(ThreadSimulation.TestTransitional && (RegIdx == 16)){

                        heuristic +=  ((probe.TransitionCycles >> 19) & 0x1);
                    }
                }
                break;
            }
            case(12): // special full VR probe
            {
                for(const auto& RegIdx: Helper.FullVerticalProbesIncluded[probed_bit]){

                    heuristic +=  ((probe.TransitionCycles >> RegIdx) & 0x1); //transition of destination register of probe

                    if(ThreadSimulation.TestTransitional && (RegIdx == register_index)){

                        heuristic +=  ((probe.TransitionCycles >> 17) & 0x1);
                    }
                }
                break;
            }
            case(13):  //small DSP full VR probe
            {
                for(const auto& RegIdx: Helper.FullVerticalProbesIncluded[probed_bit]){

                    heuristic +=  ((probe.TransitionCycles >> RegIdx) & 0x1); //transition of destination register of probe

                    if(ThreadSimulation.TestTransitional && (RegIdx == register_index)){

                        heuristic +=  ((probe.TransitionCycles >> 17) & 0x1);
                    }
                    else if(ThreadSimulation.TestTransitional && (RegIdx == partner_register_index)){

                        heuristic +=  ((probe.TransitionCycles >> 18) & 0x1);
                    }
                    else if(ThreadSimulation.TestTransitional && (RegIdx == 16)){

                        heuristic +=  ((probe.TransitionCycles >> 19) & 0x1);
                    }
                }
                break;
            }
            case(14): //large DSP full VR probe
            {
                for(const auto& RegIdx: Helper.FullVerticalProbesIncluded[probed_bit]){

                    heuristic +=  ((probe.TransitionCycles >> RegIdx) & 0x1); //transition of destination register of probe

                    if(ThreadSimulation.TestTransitional && (RegIdx == register_index)){

                        heuristic +=  ((probe.TransitionCycles >> 17) & 0x1);
                    }
                    else if(ThreadSimulation.TestTransitional && (RegIdx == partner_register_index)){

                        heuristic +=  ((probe.TransitionCycles >> 18) & 0x1);
                    }
                    else if(ThreadSimulation.TestTransitional && (RegIdx == 15)){

                        heuristic +=  ((probe.TransitionCycles >> 19) & 0x1);
                    }
                    else if(ThreadSimulation.TestTransitional && (RegIdx == 16)){

                        heuristic +=  ((probe.TransitionCycles >> 20) & 0x1);
                    }
                }
                break;
            }
            case(15): //pipeline forwarding probe
            {
                for(uint32_t bit_idx = 0; bit_idx < extension_size; ++bit_idx){
                    if(bit_idx >= 64){
                        heuristic += ((probe.SpecialInfo >> (bit_idx - 64)) & 0x1);
                    }
                    else{
                        heuristic += ((probe.TransitionCycles >> (bit_idx)) & 0x1);
                    }
                    
                }
                break;
            }
            default: std::runtime_error("Error while performing a first-order compact table update: Unknown ID detected!"); break;
        }

    }  

    for(uint64_t i = 0; i < size_of_key_in_bytes; ++i){
        dataset.key_[i] = (heuristic >> (i << 3)) & 0xff;
    }

    ++dataset.data_[ThreadSimulation.SelectedGroups[simulation_index]];
    GlobalSet.contingency_table_.UpdateBucket(dataset, number_of_groups);
}

//***************************************************************************************
void Software::Test::CompactHigherOrderUnivariateTableUpdate(Software::ThreadSimulationStruct& ThreadSimulation, unsigned int simulation_index, Software::ProbingSetStruct& GlobalSet, Software::ProbingSetStruct& ProbingSet, std::vector<std::vector<std::vector<uint8_t>>>& ProbeValues, Software::HelperStruct& Helper, std::vector<std::vector<bool>>& HighOrderUnivariateRedundancy, std::vector<std::vector<uint32_t>>& ProbeInfoToStandardProbe){
    uint64_t heuristic = 0;
    uint64_t number_of_groups = ThreadSimulation.NumberOfGroups;
    uint64_t size_of_key_in_bytes = (ProbingSet.NumberOfProbesInSet >> 8) + 1;
    uint32_t clock_cycle;
    uint8_t id, register_index, partner_register_index, probed_bit, dependency;
    uint16_t extension_size;
    TableEntry dataset;

    dataset.key_ = std::make_unique<uint8_t[]>(size_of_key_in_bytes);
    dataset.data_ = std::make_unique<uint32_t[]>(number_of_groups);

    for (Software::ProbesStruct& probe : ProbingSet.StandardProbe){
        Software::Probing::ExtractAllProbeInfo(register_index, id, partner_register_index, clock_cycle, probed_bit, extension_size, dependency, probe);
        std::vector<uint32_t> resolved_probes = ProbeInfoToStandardProbe[(probe.ProbeInfo >> 8) & 0x7ffff]; //TODO: place resolved_probes into each case

        switch(id){
            case(0): //memory probe
            {
                heuristic += (probe.TransitionCycles >> 1) & 1;

                if(ThreadSimulation.TestTransitional){
                    heuristic += (probe.TransitionCycles) & 1;
                }
                break;
            }
            //memory probe shadow register
            case(1):
            {
                heuristic += (((probe.TransitionCycles ) >> probed_bit) & 1);

                if(ThreadSimulation.TestTransitional){
                    heuristic += (probe.TransitionCycles >> (32 + probed_bit)) & 1;
                }
                break;

            }
            //memory probe seperated load store shadow register
            case(2):
            {
                heuristic += (((probe.TransitionCycles) >> probed_bit) & 1);
                if(ThreadSimulation.TestTransitional){
                    heuristic += (probe.TransitionCycles >> (32 + probed_bit)) & 1;
                }
                break;
            }
            //memory probe shadow register horizontal
            case(3):{
                for(const auto& BitIdx: Helper.HorizontalBitsIncluded.at(17)){
                    heuristic += (probe.TransitionCycles >> (BitIdx) ) & 1;

                    if(ThreadSimulation.TestTransitional){
                        heuristic += (probe.TransitionCycles >> (32 + BitIdx)) & 1;

                    }
                }
                break;
            }

            case(4): //normal probe
            {
                for(const auto& resolvedProbe: resolved_probes){
                    uint8_t resolved_probed_register = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolved_probed_bit = resolvedProbe & 0x1f;
                    uint8_t resolved_transition = (resolvedProbe >> 19) & 0x1;
                    if(!HighOrderUnivariateRedundancy[resolved_probed_register << resolved_transition][resolved_probed_bit]){ //not yet probed in ProbingSet -> add to table

                        HighOrderUnivariateRedundancy[resolved_probed_register << resolved_transition][resolved_probed_bit] = true;

                        if(!resolved_transition){
                            heuristic += (ProbeValues[resolved_probed_register][resolved_probed_bit][clock_cycle] >> (simulation_index & 0x7)) & 1;
                        }
                        else{
                            heuristic += (ProbeValues[resolved_probed_register][resolved_probed_bit][probe.TransitionCycles & 0xffffffff] >> (simulation_index & 0x7)) & 1;
                        }

                    } 
                }
                


                break;
            }


            case(5): //horizontal Probe
            {

                for(const auto& resolvedProbe: resolved_probes){
                    uint8_t resolved_probed_register = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolved_probed_bit = resolvedProbe & 0x1f;
                    uint8_t resolved_transition = (resolvedProbe >> 19) & 0x1;
                    if(!HighOrderUnivariateRedundancy[resolved_probed_register << resolved_transition][resolved_probed_bit]){ //not yet probed in ProbingSet -> add to table
                        HighOrderUnivariateRedundancy[resolved_probed_register << resolved_transition][resolved_probed_bit] = true;

                        if(!resolved_transition){
                            heuristic += (ProbeValues[resolved_probed_register][resolved_probed_bit][clock_cycle] >> (simulation_index & 0x7) ) & 1;
                        }else{
                            heuristic += (ProbeValues[resolved_probed_register][resolved_probed_bit][probe.TransitionCycles & 0xffffffff] >> (simulation_index & 0x7)) & 1;
                        }
                    }
                }
                break;
            }


            case(6): //small vertical Probe
            {
                for(const auto& resolvedProbe: resolved_probes){
                    uint8_t resolved_probed_register = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolved_probed_bit = resolvedProbe & 0x1f;
                    uint8_t resolved_transition = (resolvedProbe >> 19) & 0x1;
                    if(!HighOrderUnivariateRedundancy[resolved_probed_register << resolved_transition][resolved_probed_bit]){
                        HighOrderUnivariateRedundancy[resolved_probed_register << resolved_transition][resolved_probed_bit] = true;
                        if(!resolved_transition){
                            if(resolved_probed_register != partner_register_index){
                                heuristic += (ProbeValues[resolved_probed_register][resolved_probed_bit][clock_cycle] >> (simulation_index & 0x7)) & 1;
                            }
                            else{
                                heuristic += (ProbeValues[resolved_probed_register][resolved_probed_bit][probe.TransitionCycles >> 32] >> (simulation_index & 0x7)) & 1;
                            }
                        }
                        else{
                            heuristic += (ProbeValues[register_index][probed_bit][probe.TransitionCycles & 0xffffffff] >> (simulation_index & 0x7)) & 1;
                        }
                    }
                }

                break;

            }


            case(7): //large vertical probe
            {
                for(const auto& resolvedProbe: resolved_probes){
                    uint8_t resolved_probed_register = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolved_probed_bit = resolvedProbe & 0x1f;
                    uint8_t resolved_transition = (resolvedProbe >> 19) & 0x1;
                    if(!HighOrderUnivariateRedundancy[resolved_probed_register << resolved_transition][resolved_probed_bit]){
                        HighOrderUnivariateRedundancy[resolved_probed_register << resolved_transition][resolved_probed_bit] = true;
                        if(!resolved_transition){
                            if(resolved_probed_register != partner_register_index){
                                heuristic += (ProbeValues[resolved_probed_register][resolved_probed_bit][clock_cycle] >> (simulation_index & 0x7)) & 1;
                            }
                            else{
                                heuristic += (ProbeValues[resolved_probed_register][resolved_probed_bit][clock_cycle] >> (simulation_index & 0x7)) & 1;
                            }
                        }
                        else{
                            if(resolved_probed_register != partner_register_index){
                                heuristic += (ProbeValues[resolved_probed_register][resolved_probed_bit][probe.TransitionCycles & 0xffffffff] >> (simulation_index & 0x7)) & 1;
                            }
                            else{
                                heuristic += (ProbeValues[resolved_probed_register][resolved_probed_bit][probe.TransitionCycles >> 32] >> (simulation_index & 0x7)) & 1;
                            }

                        }
                    }
                }

                break;

            }

            case(8)://small full HR probe
            {
                for(const auto& resolvedProbe: resolved_probes){
                    uint8_t resolved_probed_register = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolved_probed_bit = resolvedProbe & 0x1f;
                    uint8_t resolved_transition = (resolvedProbe >> 19) & 0x1;
                    if(!HighOrderUnivariateRedundancy[resolved_probed_register << resolved_transition][resolved_probed_bit]){
                        HighOrderUnivariateRedundancy[resolved_probed_register << resolved_transition][resolved_probed_bit] = true;
                        if(!resolved_transition){
                            if(resolved_probed_register != partner_register_index){
                                heuristic +=  (ProbeValues[resolved_probed_register][resolved_probed_bit][clock_cycle] >> (simulation_index & 0x7)) & 1; //destination register of probe 
                            }
                            else{
                                heuristic +=  (ProbeValues[resolved_probed_register][resolved_probed_bit][probe.TransitionCycles >> 32] >> (simulation_index & 0x7)) & 1; 
                            }
                        }
                        else{
                            heuristic +=  (ProbeValues[resolved_probed_register][resolved_probed_bit][probe.TransitionCycles & 0xffffffff] >> (simulation_index & 0x7)) & 1; //transition of destination register of probe
                            
                        }
                    }
                }

                break;

            }
            case(9):
            {
                for(const auto& resolvedProbe: resolved_probes){
                    uint8_t resolved_probed_register = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolved_probed_bit = resolvedProbe & 0x1f;
                    uint8_t resolved_transition = (resolvedProbe >> 19) & 0x1;
                    if(!HighOrderUnivariateRedundancy[resolved_probed_register << resolved_transition][resolved_probed_bit]){
                        HighOrderUnivariateRedundancy[resolved_probed_register << resolved_transition][resolved_probed_bit] = true;
                        if(!resolved_transition){
                            if(resolved_probed_register != partner_register_index){
                                heuristic +=  (ProbeValues[resolved_probed_register][resolved_probed_bit][clock_cycle] >> (simulation_index & 0x7)) & 1; //destination register of probe 
                            }
                            else{
                                heuristic +=  (ProbeValues[resolved_probed_register][resolved_probed_bit][clock_cycle] >> (simulation_index & 0x7)) & 1; //transition of destination register of probe
                            }
                        }
                        else{
                            if(resolved_probed_register != partner_register_index){
                                heuristic +=  (ProbeValues[resolved_probed_register][resolved_probed_bit][probe.TransitionCycles & 0xffffffff] >> (simulation_index & 0x7)) & 1; 
                            }
                            else{
                                heuristic +=  (ProbeValues[resolved_probed_register][resolved_probed_bit][probe.TransitionCycles >> 32] >> (simulation_index & 0x7)) & 1;
                            }
                        }
                    }
                }

                break;
            }
            case(10): //small full VR probe
            {
                for(const auto& resolvedProbe: resolved_probes){
                    uint8_t resolved_probed_register = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolved_probed_bit = resolvedProbe & 0x1f;
                    uint8_t resolved_transition = (resolvedProbe >> 19) & 0x1;
                    if(!HighOrderUnivariateRedundancy[resolved_probed_register << resolved_transition][resolved_probed_bit]){
                        HighOrderUnivariateRedundancy[resolved_probed_register << resolved_transition][resolved_probed_bit] = true;

                        if(!resolved_transition){
                            heuristic +=  (probe.TransitionCycles >> resolved_probed_register) & 0x1;
                        }
                        else{
                            if(resolved_probed_register == register_index){
                                heuristic +=  (probe.TransitionCycles >> 17) & 0x1;
                            }
                            else if(resolved_probed_register == partner_register_index){
                                heuristic +=  (probe.TransitionCycles >> 18) & 0x1;
                            }

                        }

                    }
                }

                break;
            }
            case(11): // large full VR probe
            {
                for(const auto& resolvedProbe: resolved_probes){
                    uint8_t resolved_probed_register = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolved_probed_bit = resolvedProbe & 0x1f;
                    uint8_t resolved_transition = (resolvedProbe >> 19) & 0x1;
                    if(!HighOrderUnivariateRedundancy[resolved_probed_register << resolved_transition][resolved_probed_bit]){
                        HighOrderUnivariateRedundancy[resolved_probed_register << resolved_transition][resolved_probed_bit] = true;
                        
                        if(!resolved_transition){
                            heuristic +=  (probe.TransitionCycles >> resolved_probed_register) & 0x1;
                        }
                        else{
                            if(resolved_probed_register == register_index){
                                heuristic +=  (probe.TransitionCycles >> 17) & 0x1;
                            }
                            else if(resolved_probed_register == 15){
                                heuristic +=  (probe.TransitionCycles >> 18) & 0x1;
                            }
                            else if(resolved_probed_register == 16){
                                heuristic +=  (probe.TransitionCycles >> 19) & 0x1;
                            }

                        }

                    }
                }

                break;
            }
            case(12): //special full VR probe
            {
                for(const auto& resolvedProbe: resolved_probes){
                    uint8_t resolved_probed_register = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolved_probed_bit = resolvedProbe & 0x1f;
                    uint8_t resolved_transition = (resolvedProbe >> 19) & 0x1;
                    if(!HighOrderUnivariateRedundancy[resolved_probed_register << resolved_transition][resolved_probed_bit]){
                        HighOrderUnivariateRedundancy[resolved_probed_register << resolved_transition][resolved_probed_bit] = true;
                        
                        if(!resolved_transition){
                            heuristic +=  (probe.TransitionCycles >> resolved_probed_register) & 0x1; 
                        }
                        else{
                            if(resolved_probed_register == register_index){
                                heuristic +=  (probe.TransitionCycles >> 17) & 0x1;
                            }
                        }

                    }
                }

                break;                
            }
            case(13): //small DSP full VR probe
            {
                for(const auto& resolvedProbe: resolved_probes){
                    uint8_t resolved_probed_register = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolved_probed_bit = resolvedProbe & 0x1f;
                    uint8_t resolved_transition = (resolvedProbe >> 19) & 0x1;
                    if(!HighOrderUnivariateRedundancy[resolved_probed_register << resolved_transition][resolved_probed_bit]){
                        HighOrderUnivariateRedundancy[resolved_probed_register << resolved_transition][resolved_probed_bit] = true;
                        
                        if(!resolved_transition){
                            heuristic +=  ((probe.TransitionCycles >> resolved_probed_register) & 0x1);
                        }
                        else{
                            if(resolved_probed_register == register_index){
                                heuristic +=  ((probe.TransitionCycles >> 17) & 0x1);
                            }
                            else if(resolved_probed_register == partner_register_index){
                                heuristic +=  ((probe.TransitionCycles >> 18) & 0x1);
                            }
                            else if(resolved_probed_register == 16){
                                heuristic +=  ((probe.TransitionCycles >> 19) & 0x1);
                            }

                        }

                    }
                }

                break;
            }
            case(14): //large DSP full VR probe
            {
                for(const auto& resolvedProbe: resolved_probes){
                    uint8_t resolved_probed_register = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolved_probed_bit = resolvedProbe & 0x1f;
                    uint8_t resolved_transition = (resolvedProbe >> 19) & 0x1;
                    if(!HighOrderUnivariateRedundancy[resolved_probed_register << resolved_transition][resolved_probed_bit]){
                        HighOrderUnivariateRedundancy[resolved_probed_register << resolved_transition][resolved_probed_bit] = true;

                        if(!resolved_transition){
                            heuristic +=  (probe.TransitionCycles >> resolved_probed_register) & 0x1;
                        }
                        else{
                            if(resolved_probed_register == register_index){
                                heuristic +=  (probe.TransitionCycles >> 17) & 0x1;
                            }
                            else if(resolved_probed_register == partner_register_index){
                                heuristic +=  (probe.TransitionCycles >> 18) & 0x1;
                            }
                            else if(resolved_probed_register == 15){
                                heuristic +=  (probe.TransitionCycles >> 19) & 0x1;
                            }
                            else if(resolved_probed_register == 16){
                                heuristic +=  (probe.TransitionCycles >> 20) & 0x1;
                            }

                        }                        

                    }
                }

                break;
            }
            case(15):
            {
                for(uint32_t bit_idx = 0; bit_idx < extension_size; ++bit_idx){
                    if(bit_idx >= 64){
                        heuristic += (probe.SpecialInfo >> (bit_idx - 64)) & 0x1;
                    }
                    else{
                        heuristic += (probe.TransitionCycles >> (bit_idx)) & 0x1;
                    }
                    
                }
                break;
            }
            default: std::runtime_error("Error while performing a higher-order univariate table update: Unknown ID detected!"); break;
        }

    }  

    for(uint64_t i = 0; i < size_of_key_in_bytes; ++i){
        dataset.key_[i] = (heuristic >> (i << 3)) & 0xff;
    }

    ++dataset.data_[ThreadSimulation.SelectedGroups[simulation_index]];
    GlobalSet.contingency_table_.UpdateBucket(dataset, number_of_groups);
}

//***************************************************************************************
void Software::Test::HigherOrderUnivariateTableUpdate(Software::ThreadSimulationStruct& ThreadSimulation, unsigned int simulation_index, Software::ProbingSetStruct& GlobalSet, Software::ProbingSetStruct& ProbingSet, std::vector<std::vector<std::vector<uint8_t>>>& ProbeValues, Software::HelperStruct& Helper, std::vector<std::vector<bool>>& HighOrderUnivariateRedundancy, std::vector<std::vector<uint32_t>>& ProbeInfoToStandardProbe){
    uint64_t key_index = 0;
    uint64_t number_of_groups = ThreadSimulation.NumberOfGroups;
    uint64_t size_of_key_in_bytes = (ProbingSet.NumberOfProbesInSet >> 3) + 1;
    uint32_t clock_cycle;
    uint8_t id, register_index, partner_register_index, probed_bit, dependency;
    uint16_t extension_size;
    TableEntry dataset;

    dataset.key_ = std::make_unique<uint8_t[]>(size_of_key_in_bytes);
    dataset.data_ = std::make_unique<uint32_t[]>(number_of_groups);

    for (Software::ProbesStruct& probe : ProbingSet.StandardProbe){
        Software::Probing::ExtractAllProbeInfo(register_index, id, partner_register_index, clock_cycle, probed_bit, extension_size, dependency, probe);
        std::vector<uint32_t> resolved_probes = ProbeInfoToStandardProbe[(probe.ProbeInfo >> 8) & 0x7ffff];

        switch(id){
            case(0): //memory probe
            {
                key_index++; 
                dataset.key_[key_index >> 3] <<= 1;
                dataset.key_[key_index >> 3] |= (probe.TransitionCycles >> 1) & 1;


                if(ThreadSimulation.TestTransitional){
                    key_index++; 
                    dataset.key_[key_index >> 3] <<= 1;
                    dataset.key_[key_index >> 3] |= (probe.TransitionCycles) & 1;

                }
                break;
            }
            //memory probe shadow register
            case(1):
            {
                key_index++;
                dataset.key_[key_index >> 3] <<= 1;
                dataset.key_[key_index >> 3] |= ((probe.TransitionCycles ) >> probed_bit) & 1;

                if(ThreadSimulation.TestTransitional){
                    key_index++; 
                    dataset.key_[key_index >> 3] <<= 1;
                    dataset.key_[key_index >> 3] |= (probe.TransitionCycles >> (32 + probed_bit)) & 1;
                }
                break;

            }
            //memory probe seperated load store shadow register
            case(2):
            {
                key_index++;
                dataset.key_[key_index >> 3] <<= 1;
                dataset.key_[key_index >> 3] |= ((probe.TransitionCycles ) >> probed_bit) & 1;

                if(ThreadSimulation.TestTransitional){
                    key_index++; 
                    dataset.key_[key_index >> 3] <<= 1;
                    dataset.key_[key_index >> 3] |= (probe.TransitionCycles >> (32 + probed_bit)) & 1;
                }
                break;
            }
            //memory probe shadow register horizontal
            case(3):{
                for(const auto& BitIdx: Helper.HorizontalBitsIncluded.at(17)){
                    key_index++; 
                    dataset.key_[key_index >> 3] <<= 1;
                    dataset.key_[key_index >> 3] |= (probe.TransitionCycles >> (BitIdx) ) & 1;

                    if(ThreadSimulation.TestTransitional){
                        key_index++; 
                        dataset.key_[key_index >> 3] <<= 1;
                        dataset.key_[key_index >> 3] |= (probe.TransitionCycles >> (32 + BitIdx)) & 1;

                    }
                }
                break;
            }

            case(4): //normal probe
            {
                for(const auto& resolvedProbe: resolved_probes){
                    uint8_t resolved_probed_register = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolved_probed_bit = resolvedProbe & 0x1f;
                    uint8_t resolved_transition = (resolvedProbe >> 19) & 0x1;
                    if(!HighOrderUnivariateRedundancy[resolved_probed_register << resolved_transition][resolved_probed_bit]){ //not yet probed in ProbingSet -> add to table

                        HighOrderUnivariateRedundancy[resolved_probed_register << resolved_transition][resolved_probed_bit] = true;

                        if(!resolved_transition){
                            key_index++; 
                            dataset.key_[key_index >> 3] <<= 1;
                            dataset.key_[key_index >> 3] |= (ProbeValues[resolved_probed_register][resolved_probed_bit][clock_cycle] >> (simulation_index & 0x7)) & 1;
                        }
                        else{
                            key_index++; 
                            dataset.key_[key_index >> 3] <<= 1;
                            dataset.key_[key_index >> 3] |= (ProbeValues[resolved_probed_register][resolved_probed_bit][probe.TransitionCycles & 0xffffffff] >> (simulation_index & 0x7)) & 1;
                        }

                    } 
                }
                


                break;
            }


            case(5): //horizontal Probe
            {

                for(const auto& resolvedProbe: resolved_probes){
                    uint8_t resolved_probed_register = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolved_probed_bit = resolvedProbe & 0x1f;
                    uint8_t resolved_transition = (resolvedProbe >> 19) & 0x1;
                    if(!HighOrderUnivariateRedundancy[resolved_probed_register << resolved_transition][resolved_probed_bit]){ //not yet probed in ProbingSet -> add to table
                        HighOrderUnivariateRedundancy[resolved_probed_register << resolved_transition][resolved_probed_bit] = true;

                        if(!resolved_transition){
                            key_index++; 
                            dataset.key_[key_index >> 3] <<= 1;
                            dataset.key_[key_index >> 3] |= (ProbeValues[resolved_probed_register][resolved_probed_bit][clock_cycle] >> (simulation_index & 0x7) ) & 1;
                        }
                        else{
                            key_index++; 
                            dataset.key_[key_index >> 3] <<= 1;
                            dataset.key_[key_index >> 3] |= (ProbeValues[resolved_probed_register][resolved_probed_bit][probe.TransitionCycles & 0xffffffff] >> (simulation_index & 0x7)) & 1;

                        }

                    }

                }
                break;
            }


            case(6): //small vertical Probe
            {
                for(const auto& resolvedProbe: resolved_probes){
                    uint8_t resolved_probed_register = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolved_probed_bit = resolvedProbe & 0x1f;
                    uint8_t resolved_transition = (resolvedProbe >> 19) & 0x1;
                    if(!HighOrderUnivariateRedundancy[resolved_probed_register << resolved_transition][resolved_probed_bit]){
                        HighOrderUnivariateRedundancy[resolved_probed_register << resolved_transition][resolved_probed_bit] = true;
                        if(!resolved_transition){
                            if(resolved_probed_register != partner_register_index){
                                key_index++; 
                                dataset.key_[key_index >> 3] <<= 1;
                                dataset.key_[key_index >> 3] |= (ProbeValues[resolved_probed_register][resolved_probed_bit][clock_cycle] >> (simulation_index & 0x7)) & 1;
                            }
                            else{
                                key_index++; 
                                dataset.key_[key_index >> 3] <<= 1;
                                dataset.key_[key_index >> 3] |= (ProbeValues[resolved_probed_register][resolved_probed_bit][probe.TransitionCycles >> 32] >> (simulation_index & 0x7)) & 1;
                            }
                        }
                        else{
                            key_index++; 
                            dataset.key_[key_index >> 3] <<= 1;
                            dataset.key_[key_index >> 3] |= (ProbeValues[register_index][probed_bit][probe.TransitionCycles & 0xffffffff] >> (simulation_index & 0x7)) & 1;
                        }
                    }
                }

                break;

            }


            case(7): //large vertical probe
            {
                for(const auto& resolvedProbe: resolved_probes){
                    uint8_t resolved_probed_register = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolved_probed_bit = resolvedProbe & 0x1f;
                    uint8_t resolved_transition = (resolvedProbe >> 19) & 0x1;
                    if(!HighOrderUnivariateRedundancy[resolved_probed_register << resolved_transition][resolved_probed_bit]){
                        HighOrderUnivariateRedundancy[resolved_probed_register << resolved_transition][resolved_probed_bit] = true;
                        if(!resolved_transition){
                            if(resolved_probed_register != partner_register_index){
                                key_index++; 
                                dataset.key_[key_index >> 3] <<= 1;
                                dataset.key_[key_index >> 3] |= (ProbeValues[resolved_probed_register][resolved_probed_bit][clock_cycle] >> (simulation_index & 0x7)) & 1;
                            }
                            else{
                                key_index++; 
                                dataset.key_[key_index >> 3] <<= 1;
                                dataset.key_[key_index >> 3] |= (ProbeValues[resolved_probed_register][resolved_probed_bit][clock_cycle] >> (simulation_index & 0x7)) & 1;
                            }
                        }
                        else{
                            if(resolved_probed_register != partner_register_index){
                                key_index++; 
                                dataset.key_[key_index >> 3] <<= 1;
                                dataset.key_[key_index >> 3] |= (ProbeValues[resolved_probed_register][resolved_probed_bit][probe.TransitionCycles & 0xffffffff] >> (simulation_index & 0x7)) & 1;
                            }
                            else{
                                key_index++; 
                                dataset.key_[key_index >> 3] <<= 1;
                                dataset.key_[key_index >> 3] |= (ProbeValues[resolved_probed_register][resolved_probed_bit][probe.TransitionCycles >> 32] >> (simulation_index & 0x7)) & 1;
                            }

                        }
                    }
                }

                break;

            }

            case(8)://small full HR probe
            {
                for(const auto& resolvedProbe: resolved_probes){
                    uint8_t resolved_probed_register = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolved_probed_bit = resolvedProbe & 0x1f;
                    uint8_t resolved_transition = (resolvedProbe >> 19) & 0x1;
                    if(!HighOrderUnivariateRedundancy[resolved_probed_register << resolved_transition][resolved_probed_bit]){
                        HighOrderUnivariateRedundancy[resolved_probed_register << resolved_transition][resolved_probed_bit] = true;
                        if(!resolved_transition){
                            if(resolved_probed_register != partner_register_index){
                                key_index++;
                                dataset.key_[key_index >> 3] <<= 1;
                                dataset.key_[key_index >> 3] |=  (ProbeValues[resolved_probed_register][resolved_probed_bit][clock_cycle] >> (simulation_index & 0x7)) & 1; //destination register of probe 
                            }
                            else{
                                key_index++;
                                dataset.key_[key_index >> 3] <<= 1;
                                dataset.key_[key_index >> 3] |=  (ProbeValues[resolved_probed_register][resolved_probed_bit][probe.TransitionCycles >> 32] >> (simulation_index & 0x7)) & 1; 
                            }
                        }
                        else{
                            key_index++;
                            dataset.key_[key_index >> 3] <<= 1;
                            dataset.key_[key_index >> 3] |=  (ProbeValues[resolved_probed_register][resolved_probed_bit][probe.TransitionCycles & 0xffffffff] >> (simulation_index & 0x7)) & 1; //transition of destination register of probe
                            
                        }
                    }
                }

                break;

            }
            case(9):
            {
                for(const auto& resolvedProbe: resolved_probes){
                    uint8_t resolved_probed_register = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolved_probed_bit = resolvedProbe & 0x1f;
                    uint8_t resolved_transition = (resolvedProbe >> 19) & 0x1;
                    if(!HighOrderUnivariateRedundancy[resolved_probed_register << resolved_transition][resolved_probed_bit]){
                        HighOrderUnivariateRedundancy[resolved_probed_register << resolved_transition][resolved_probed_bit] = true;
                        if(!resolved_transition){
                            if(resolved_probed_register != partner_register_index){
                                key_index++;
                                dataset.key_[key_index >> 3] <<= 1;
                                dataset.key_[key_index >> 3] |=  (ProbeValues[resolved_probed_register][resolved_probed_bit][clock_cycle] >> (simulation_index & 0x7)) & 1; //destination register of probe 
                            }
                            else{
                                key_index++;
                                dataset.key_[key_index >> 3] <<= 1;
                                dataset.key_[key_index >> 3] |=  (ProbeValues[resolved_probed_register][resolved_probed_bit][clock_cycle] >> (simulation_index & 0x7)) & 1; //transition of destination register of probe
                            }
                        }
                        else{
                            if(resolved_probed_register != partner_register_index){
                                key_index++;
                                dataset.key_[key_index >> 3] <<= 1;
                                dataset.key_[key_index >> 3] |=  (ProbeValues[resolved_probed_register][resolved_probed_bit][probe.TransitionCycles & 0xffffffff] >> (simulation_index & 0x7)) & 1; 
                            }
                            else{
                                key_index++;
                                dataset.key_[key_index >> 3] <<= 1;
                                dataset.key_[key_index >> 3] |=  (ProbeValues[resolved_probed_register][resolved_probed_bit][probe.TransitionCycles >> 32] >> (simulation_index & 0x7)) & 1;
                            }
                        }
                    }
                }

                break;
            }
            case(10): //small full VR probe
            {
                for(const auto& resolvedProbe: resolved_probes){
                    uint8_t resolved_probed_register = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolved_probed_bit = resolvedProbe & 0x1f;
                    uint8_t resolved_transition = (resolvedProbe >> 19) & 0x1;
                    if(!HighOrderUnivariateRedundancy[resolved_probed_register << resolved_transition][resolved_probed_bit]){
                        HighOrderUnivariateRedundancy[resolved_probed_register << resolved_transition][resolved_probed_bit] = true;

                        if(!resolved_transition){
                            key_index++;
                            dataset.key_[key_index >> 3] <<= 1;
                            dataset.key_[key_index >> 3] |=  (probe.TransitionCycles >> resolved_probed_register) & 0x1;
                        }
                        else{
                            if(resolved_probed_register == register_index){
                                key_index++;
                                dataset.key_[key_index >> 3] <<= 1;
                                dataset.key_[key_index >> 3] |=  (probe.TransitionCycles >> 17) & 0x1;
                            }
                            else if(resolved_probed_register == partner_register_index){
                                key_index++;
                                dataset.key_[key_index >> 3] <<= 1;
                                dataset.key_[key_index >> 3] |=  (probe.TransitionCycles >> 18) & 0x1;
                            }

                        }

                    }
                }

                break;
            }
            case(11): // large full VR probe
            {
                for(const auto& resolvedProbe: resolved_probes){
                    uint8_t resolved_probed_register = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolved_probed_bit = resolvedProbe & 0x1f;
                    uint8_t resolved_transition = (resolvedProbe >> 19) & 0x1;
                    if(!HighOrderUnivariateRedundancy[resolved_probed_register << resolved_transition][resolved_probed_bit]){
                        HighOrderUnivariateRedundancy[resolved_probed_register << resolved_transition][resolved_probed_bit] = true;
                        
                        if(!resolved_transition){
                            key_index++;
                            dataset.key_[key_index >> 3] <<= 1;
                            dataset.key_[key_index >> 3] |=  (probe.TransitionCycles >> resolved_probed_register) & 0x1;
                        }
                        else{
                            if(resolved_probed_register == register_index){
                                key_index++;
                                dataset.key_[key_index >> 3] <<= 1;
                                dataset.key_[key_index >> 3] |=  (probe.TransitionCycles >> 17) & 0x1;
                            }
                            else if(resolved_probed_register == 15){
                                key_index++;
                                dataset.key_[key_index >> 3] <<= 1;
                                dataset.key_[key_index >> 3] |=  (probe.TransitionCycles >> 18) & 0x1;
                            }
                            else if(resolved_probed_register == 16){
                                key_index++;
                                dataset.key_[key_index >> 3] <<= 1;
                                dataset.key_[key_index >> 3] |=  (probe.TransitionCycles >> 19) & 0x1;
                            }

                        }

                    }
                }

                break;
            }
            case(12): //special full VR probe
            {
                for(const auto& resolvedProbe: resolved_probes){
                    uint8_t resolved_probed_register = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolved_probed_bit = resolvedProbe & 0x1f;
                    uint8_t resolved_transition = (resolvedProbe >> 19) & 0x1;
                    if(!HighOrderUnivariateRedundancy[resolved_probed_register << resolved_transition][resolved_probed_bit]){
                        HighOrderUnivariateRedundancy[resolved_probed_register << resolved_transition][resolved_probed_bit] = true;
                        
                        if(!resolved_transition){
                            key_index++;
                            dataset.key_[key_index >> 3] <<= 1;
                            dataset.key_[key_index >> 3] |=  (probe.TransitionCycles >> resolved_probed_register) & 0x1; 
                        }
                        else{
                            if(resolved_probed_register == register_index){
                                key_index++;
                                dataset.key_[key_index >> 3] <<= 1;
                                dataset.key_[key_index >> 3] |=  (probe.TransitionCycles >> 17) & 0x1;
                            }
                        }

                    }
                }

                break;                
            }
            case(13): //small DSP full VR probe
            {
                for(const auto& resolvedProbe: resolved_probes){
                    uint8_t resolved_probed_register = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolved_probed_bit = resolvedProbe & 0x1f;
                    uint8_t resolved_transition = (resolvedProbe >> 19) & 0x1;
                    if(!HighOrderUnivariateRedundancy[resolved_probed_register << resolved_transition][resolved_probed_bit]){
                        HighOrderUnivariateRedundancy[resolved_probed_register << resolved_transition][resolved_probed_bit] = true;
                        
                        if(!resolved_transition){
                            key_index++;
                            dataset.key_[key_index >> 3] <<= 1;
                            dataset.key_[key_index >> 3] |=  (probe.TransitionCycles >> resolved_probed_register) & 0x1;
                        }
                        else{
                            if(resolved_probed_register == register_index){
                                key_index++;
                                dataset.key_[key_index >> 3] <<= 1;
                                dataset.key_[key_index >> 3] |=  (probe.TransitionCycles >> 17) & 0x1;
                            }
                            else if(resolved_probed_register == partner_register_index){
                                key_index++;
                                dataset.key_[key_index >> 3] <<= 1;
                                dataset.key_[key_index >> 3] |=  (probe.TransitionCycles >> 18) & 0x1;
                            }
                            else if(resolved_probed_register == 16){
                                key_index++;
                                dataset.key_[key_index >> 3] <<= 1;
                                dataset.key_[key_index >> 3] |=  (probe.TransitionCycles >> 19) & 0x1;
                            }

                        }

                    }
                }

                break;
            }
            case(14): //large DSP full VR probe
            {
                for(const auto& resolvedProbe: resolved_probes){
                    uint8_t resolved_probed_register = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolved_probed_bit = resolvedProbe & 0x1f;
                    uint8_t resolved_transition = (resolvedProbe >> 19) & 0x1;
                    if(!HighOrderUnivariateRedundancy[resolved_probed_register << resolved_transition][resolved_probed_bit]){
                        HighOrderUnivariateRedundancy[resolved_probed_register << resolved_transition][resolved_probed_bit] = true;

                        if(!resolved_transition){
                            key_index++;
                            dataset.key_[key_index >> 3] <<= 1;
                            dataset.key_[key_index >> 3] |=  (probe.TransitionCycles >> resolved_probed_register) & 0x1;
                        }
                        else{
                            if(resolved_probed_register == register_index){
                                key_index++;
                                dataset.key_[key_index >> 3] <<= 1;
                                dataset.key_[key_index >> 3] |=  (probe.TransitionCycles >> 17) & 0x1;
                            }
                            else if(resolved_probed_register == partner_register_index){
                                key_index++;
                                dataset.key_[key_index >> 3] <<= 1;
                                dataset.key_[key_index >> 3] |=  (probe.TransitionCycles >> 18) & 0x1;
                            }
                            else if(resolved_probed_register == 15){
                                key_index++;
                                dataset.key_[key_index >> 3] <<= 1;
                                dataset.key_[key_index >> 3] |=  (probe.TransitionCycles >> 19) & 0x1;
                            }
                            else if(resolved_probed_register == 16){
                                key_index++;
                                dataset.key_[key_index >> 3] <<= 1;
                                dataset.key_[key_index >> 3] |=  (probe.TransitionCycles >> 20) & 0x1;
                            }

                        }                        

                    }
                }

                break;
            }
            case(15):
            {
                for(uint32_t bit_idx = 0; bit_idx < extension_size; ++bit_idx){
                    key_index++;
                    dataset.key_[key_index >> 3] <<= 1;

                    if(bit_idx >= 64){
                        dataset.key_[key_index >> 3] |=  (probe.SpecialInfo >> (bit_idx - 64)) & 0x1;
                    }
                    else{
                        dataset.key_[key_index >> 3] |=  (probe.TransitionCycles >> (bit_idx)) & 0x1;
                    }
                    
                }
                break;
            }
            default: std::runtime_error("Error while performing a higher-order univariate table update: Unknown ID detected!"); break;
        }
    }

    ++dataset.data_[ThreadSimulation.SelectedGroups[simulation_index]];
    GlobalSet.contingency_table_.UpdateBucket(dataset, number_of_groups);
}

//***************************************************************************************

void Software::Test::HigherOrderMultivariateTableUpdate(Software::ThreadSimulationStruct& ThreadSimulation, uint32_t simulation_index, Software::ProbingSetStruct& GlobalSet, Software::ProbingSetStruct& ProbingSet, std::vector<std::vector<std::vector<uint8_t>>>& ProbeValues, Software::HelperStruct& Helper, std::vector<std::vector<uint32_t>>& ProbeInfoToStandardProbe){
    uint64_t key_index = 0;
    uint64_t number_of_groups = ThreadSimulation.NumberOfGroups;
    uint64_t size_of_key_in_bytes = (ProbingSet.NumberOfProbesInSet >> 3) + 1;
    uint32_t clock_cycle;
    uint8_t id, register_index, partner_register_index, probed_bit, dependency;
    uint16_t extension_size;
    TableEntry dataset;

    dataset.key_ = std::make_unique<uint8_t[]>(size_of_key_in_bytes);
    dataset.data_ = std::make_unique<uint32_t[]>(number_of_groups);

    for (Software::ProbesStruct& probe : ProbingSet.StandardProbe){
        Software::Probing::ExtractAllProbeInfo(register_index, id, partner_register_index, clock_cycle, probed_bit, extension_size, dependency, probe);
        std::vector<uint32_t> resolved_probes = ProbeInfoToStandardProbe[(probe.ProbeInfo >> 8) & 0x7ffff];

        switch(id){
            case(0): //memory probe
            {
                key_index++; 
                dataset.key_[key_index >> 3] <<= 1;
                dataset.key_[key_index >> 3] |= (probe.TransitionCycles >> 1) & 1;


                if(ThreadSimulation.TestTransitional){
                    key_index++; 
                    dataset.key_[key_index >> 3] <<= 1;
                    dataset.key_[key_index >> 3] |= (probe.TransitionCycles) & 1;

                }
                break;
            }
            //memory probe shadow register
            case(1):
            {
                key_index++;
                dataset.key_[key_index >> 3] <<= 1;
                dataset.key_[key_index >> 3] |= ((probe.TransitionCycles ) >> probed_bit) & 1;

                if(ThreadSimulation.TestTransitional){
                    key_index++; 
                    dataset.key_[key_index >> 3] <<= 1;
                    dataset.key_[key_index >> 3] |= (probe.TransitionCycles >> (32 + probed_bit)) & 1;
                }
                break;

            }
            //memory probe seperated load store shadow register
            case(2):
            {
                key_index++;
                dataset.key_[key_index >> 3] <<= 1;
                dataset.key_[key_index >> 3] |= ((probe.TransitionCycles ) >> probed_bit) & 1;

                if(ThreadSimulation.TestTransitional){
                    key_index++; 
                    dataset.key_[key_index >> 3] <<= 1;
                    dataset.key_[key_index >> 3] |= (probe.TransitionCycles >> (32 + probed_bit)) & 1;
                }
                break;
            }
            //memory probe shadow register horizontal
            case(3):{
                for(const auto& BitIdx: Helper.HorizontalBitsIncluded.at(17)){
                    key_index++; 
                    dataset.key_[key_index >> 3] <<= 1;
                    dataset.key_[key_index >> 3] |= (probe.TransitionCycles >> (BitIdx) ) & 1;

                    if(ThreadSimulation.TestTransitional){
                        key_index++; 
                        dataset.key_[key_index >> 3] <<= 1;
                        dataset.key_[key_index >> 3] |= (probe.TransitionCycles >> (32 + BitIdx)) & 1;

                    }
                }
                break;
            }

            case(4): //normal probe
            {
                for(const auto& resolvedProbe: resolved_probes){
                    uint8_t resolved_probed_register = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolved_probed_bit = resolvedProbe & 0x1f;
                    uint8_t resolved_transition = (resolvedProbe >> 19) & 0x1;

                    if(!resolved_transition){
                        key_index++; 
                        dataset.key_[key_index >> 3] <<= 1;
                        dataset.key_[key_index >> 3] |= (ProbeValues[resolved_probed_register][resolved_probed_bit][clock_cycle] >> (simulation_index & 0x7)) & 1;
                    }
                    else{
                        key_index++; 
                        dataset.key_[key_index >> 3] <<= 1;
                        dataset.key_[key_index >> 3] |= (ProbeValues[resolved_probed_register][resolved_probed_bit][probe.TransitionCycles & 0xffffffff] >> (simulation_index & 0x7)) & 1;
                    }
                }
                
                break;
            }


            case(5): //horizontal Probe
            {

                for(const auto& resolvedProbe: resolved_probes){
                    uint8_t resolved_probed_register = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolved_probed_bit = resolvedProbe & 0x1f;
                    uint8_t resolved_transition = (resolvedProbe >> 19) & 0x1;

                        if(!resolved_transition){
                            key_index++; 
                            dataset.key_[key_index >> 3] <<= 1;
                            dataset.key_[key_index >> 3] |= (ProbeValues[resolved_probed_register][resolved_probed_bit][clock_cycle] >> (simulation_index & 0x7) ) & 1;
                        }
                        else{
                            key_index++; 
                            dataset.key_[key_index >> 3] <<= 1;
                            dataset.key_[key_index >> 3] |= (ProbeValues[resolved_probed_register][resolved_probed_bit][probe.TransitionCycles & 0xffffffff] >> (simulation_index & 0x7)) & 1;
                        }


                }
                break;
            }


            case(6): //small vertical Probe
            {
                for(const auto& resolvedProbe: resolved_probes){
                    uint8_t resolved_probed_register = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolved_probed_bit = resolvedProbe & 0x1f;
                    uint8_t resolved_transition = (resolvedProbe >> 19) & 0x1;

                        if(!resolved_transition){
                            if(resolved_probed_register != partner_register_index){
                                key_index++; 
                                dataset.key_[key_index >> 3] <<= 1;
                                dataset.key_[key_index >> 3] |= (ProbeValues[resolved_probed_register][resolved_probed_bit][clock_cycle] >> (simulation_index & 0x7)) & 1;
                            }
                            else{
                                key_index++; 
                                dataset.key_[key_index >> 3] <<= 1;
                                dataset.key_[key_index >> 3] |= (ProbeValues[resolved_probed_register][resolved_probed_bit][probe.TransitionCycles >> 32] >> (simulation_index & 0x7)) & 1;
                            }
                        }
                        else{
                            key_index++; 
                            dataset.key_[key_index >> 3] <<= 1;
                            dataset.key_[key_index >> 3] |= (ProbeValues[register_index][probed_bit][probe.TransitionCycles & 0xffffffff] >> (simulation_index & 0x7)) & 1;
                        }
                    
                }

                break;

            }

            case(7): //large vertical probe
            {
                for(const auto& resolvedProbe: resolved_probes){
                    uint8_t resolved_probed_register = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolved_probed_bit = resolvedProbe & 0x1f;
                    uint8_t resolved_transition = (resolvedProbe >> 19) & 0x1;

                        if(!resolved_transition){
                            if(resolved_probed_register != partner_register_index){
                                key_index++; 
                                dataset.key_[key_index >> 3] <<= 1;
                                dataset.key_[key_index >> 3] |= (ProbeValues[resolved_probed_register][resolved_probed_bit][clock_cycle] >> (simulation_index & 0x7)) & 1;
                            }
                            else{
                                key_index++; 
                                dataset.key_[key_index >> 3] <<= 1;
                                dataset.key_[key_index >> 3] |= (ProbeValues[resolved_probed_register][resolved_probed_bit][clock_cycle] >> (simulation_index & 0x7)) & 1;
                            }
                        }
                        else{
                            if(resolved_probed_register != partner_register_index){
                                key_index++; 
                                dataset.key_[key_index >> 3] <<= 1;
                                dataset.key_[key_index >> 3] |= (ProbeValues[resolved_probed_register][resolved_probed_bit][probe.TransitionCycles & 0xffffffff] >> (simulation_index & 0x7)) & 1;
                            }
                            else{
                                key_index++; 
                                dataset.key_[key_index >> 3] <<= 1;
                                dataset.key_[key_index >> 3] |= (ProbeValues[resolved_probed_register][resolved_probed_bit][probe.TransitionCycles >> 32] >> (simulation_index & 0x7)) & 1;
                            }

                        }
        
                }

                break;


            }

            case(8)://small full HR probe
            {
                for(const auto& resolvedProbe: resolved_probes){
                    uint8_t resolved_probed_register = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolved_probed_bit = resolvedProbe & 0x1f;
                    uint8_t resolved_transition = (resolvedProbe >> 19) & 0x1;

                        if(!resolved_transition){
                            if(resolved_probed_register != partner_register_index){
                                key_index++;
                                dataset.key_[key_index >> 3] <<= 1;
                                dataset.key_[key_index >> 3] |=  (ProbeValues[resolved_probed_register][resolved_probed_bit][clock_cycle] >> (simulation_index & 0x7)) & 1; //destination register of probe 
                            }
                            else{
                                key_index++;
                                dataset.key_[key_index >> 3] <<= 1;
                                dataset.key_[key_index >> 3] |=  (ProbeValues[resolved_probed_register][resolved_probed_bit][probe.TransitionCycles >> 32] >> (simulation_index & 0x7)) & 1; 
                            }
                        }
                        else{
                            key_index++;
                            dataset.key_[key_index >> 3] <<= 1;
                            dataset.key_[key_index >> 3] |=  (ProbeValues[resolved_probed_register][resolved_probed_bit][probe.TransitionCycles & 0xffffffff] >> (simulation_index & 0x7)) & 1; //transition of destination register of probe
                            
                        }
                    
                }

                break;

            }
            case(9):
            {
                for(const auto& resolvedProbe: resolved_probes){
                    uint8_t resolved_probed_register = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolved_probed_bit = resolvedProbe & 0x1f;
                    uint8_t resolved_transition = (resolvedProbe >> 19) & 0x1;

                        if(!resolved_transition){
                            if(resolved_probed_register != partner_register_index){
                                key_index++;
                                dataset.key_[key_index >> 3] <<= 1;
                                dataset.key_[key_index >> 3] |=  (ProbeValues[resolved_probed_register][resolved_probed_bit][clock_cycle] >> (simulation_index & 0x7)) & 1; //destination register of probe 
                            }
                            else{
                                key_index++;
                                dataset.key_[key_index >> 3] <<= 1;
                                dataset.key_[key_index >> 3] |=  (ProbeValues[resolved_probed_register][resolved_probed_bit][clock_cycle] >> (simulation_index & 0x7)) & 1; //transition of destination register of probe
                            }
                        }
                        else{
                            if(resolved_probed_register != partner_register_index){
                                key_index++;
                                dataset.key_[key_index >> 3] <<= 1;
                                dataset.key_[key_index >> 3] |=  (ProbeValues[resolved_probed_register][resolved_probed_bit][probe.TransitionCycles & 0xffffffff] >> (simulation_index & 0x7)) & 1; 
                            }
                            else{
                                key_index++;
                                dataset.key_[key_index >> 3] <<= 1;
                                dataset.key_[key_index >> 3] |=  (ProbeValues[resolved_probed_register][resolved_probed_bit][probe.TransitionCycles >> 32] >> (simulation_index & 0x7)) & 1;
                            }
                        }
                    
                }

                break;
            }
            case(10): //small full VR probe
            {
                for(const auto& resolvedProbe: resolved_probes){
                    uint8_t resolved_probed_register = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolved_transition = (resolvedProbe >> 19) & 0x1;


                        if(!resolved_transition){
                            key_index++;
                            dataset.key_[key_index >> 3] <<= 1;
                            dataset.key_[key_index >> 3] |=  (probe.TransitionCycles >> resolved_probed_register) & 0x1;
                        }
                        else{
                            if(resolved_probed_register == register_index){
                                key_index++;
                                dataset.key_[key_index >> 3] <<= 1;
                                dataset.key_[key_index >> 3] |=  (probe.TransitionCycles >> 17) & 0x1;
                            }
                            else if(resolved_probed_register == partner_register_index){
                                key_index++;
                                dataset.key_[key_index >> 3] <<= 1;
                                dataset.key_[key_index >> 3] |=  (probe.TransitionCycles >> 18) & 0x1;
                            }

                        }

                    
                }

                break;
            }
            case(11): // large full VR probe
            {
                for(const auto& resolvedProbe: resolved_probes){
                    uint8_t resolved_probed_register = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolved_transition = (resolvedProbe >> 19) & 0x1;

                        
                        if(!resolved_transition){
                            key_index++;
                            dataset.key_[key_index >> 3] <<= 1;
                            dataset.key_[key_index >> 3] |=  (probe.TransitionCycles >> resolved_probed_register) & 0x1;
                        }
                        else{
                            if(resolved_probed_register == register_index){
                                key_index++;
                                dataset.key_[key_index >> 3] <<= 1;
                                dataset.key_[key_index >> 3] |=  (probe.TransitionCycles >> 17) & 0x1;
                            }
                            else if(resolved_probed_register == 15){
                                key_index++;
                                dataset.key_[key_index >> 3] <<= 1;
                                dataset.key_[key_index >> 3] |=  (probe.TransitionCycles >> 18) & 0x1;
                            }
                            else if(resolved_probed_register == 16){
                                key_index++;
                                dataset.key_[key_index >> 3] <<= 1;
                                dataset.key_[key_index >> 3] |=  (probe.TransitionCycles >> 19) & 0x1;
                            }

                        }

                    
                }

                break;
            }
            case(12): //special full VR probe
            {
                for(const auto& resolvedProbe: resolved_probes){
                    uint8_t resolved_probed_register = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolved_transition = (resolvedProbe >> 19) & 0x1;

                        
                        if(!resolved_transition){
                            key_index++;
                            dataset.key_[key_index >> 3] <<= 1;
                            dataset.key_[key_index >> 3] |=  (probe.TransitionCycles >> resolved_probed_register) & 0x1; 
                        }
                        else{
                            if(resolved_probed_register == register_index){
                                key_index++;
                                dataset.key_[key_index >> 3] <<= 1;
                                dataset.key_[key_index >> 3] |=  (probe.TransitionCycles >> 17) & 0x1;
                            }
                        }

                    
                }

                break;                
            }
            case(13): //small DSP full VR probe
            {
                for(const auto& resolvedProbe: resolved_probes){
                    uint8_t resolved_probed_register = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolved_transition = (resolvedProbe >> 19) & 0x1;

                        
                        if(!resolved_transition){
                            key_index++;
                            dataset.key_[key_index >> 3] <<= 1;
                            dataset.key_[key_index >> 3] |=  (probe.TransitionCycles >> resolved_probed_register) & 0x1;
                        }
                        else{
                            if(resolved_probed_register == register_index){
                                key_index++;
                                dataset.key_[key_index >> 3] <<= 1;
                                dataset.key_[key_index >> 3] |=  (probe.TransitionCycles >> 17) & 0x1;
                            }
                            else if(resolved_probed_register == partner_register_index){
                                key_index++;
                                dataset.key_[key_index >> 3] <<= 1;
                                dataset.key_[key_index >> 3] |=  (probe.TransitionCycles >> 18) & 0x1;
                            }
                            else if(resolved_probed_register == 16){
                                key_index++;
                                dataset.key_[key_index >> 3] <<= 1;
                                dataset.key_[key_index >> 3] |=  (probe.TransitionCycles >> 19) & 0x1;
                            }

                        }

                    
                }

                break;
            }
            case(14): //large DSP full VR probe
            {
                for(const auto& resolvedProbe: resolved_probes){
                    uint8_t resolved_probed_register = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolved_transition = (resolvedProbe >> 19) & 0x1;


                        if(!resolved_transition){
                            key_index++;
                            dataset.key_[key_index >> 3] <<= 1;
                            dataset.key_[key_index >> 3] |=  (probe.TransitionCycles >> resolved_probed_register) & 0x1;
                        }
                        else{
                            if(resolved_probed_register == register_index){
                                key_index++;
                                dataset.key_[key_index >> 3] <<= 1;
                                dataset.key_[key_index >> 3] |=  (probe.TransitionCycles >> 17) & 0x1;
                            }
                            else if(resolved_probed_register == partner_register_index){
                                key_index++;
                                dataset.key_[key_index >> 3] <<= 1;
                                dataset.key_[key_index >> 3] |=  (probe.TransitionCycles >> 18) & 0x1;
                            }
                            else if(resolved_probed_register == 15){
                                key_index++;
                                dataset.key_[key_index >> 3] <<= 1;
                                dataset.key_[key_index >> 3] |=  (probe.TransitionCycles >> 19) & 0x1;
                            }
                            else if(resolved_probed_register == 16){
                                key_index++;
                                dataset.key_[key_index >> 3] <<= 1;
                                dataset.key_[key_index >> 3] |=  (probe.TransitionCycles >> 20) & 0x1;
                            }

                        }                        

                    
                }

                break;
            }
            case(15): //pipeline forwarding probe
            {
                for(uint32_t bit_idx = 0; bit_idx < extension_size; ++bit_idx){
                    key_index++;
                    dataset.key_[key_index >> 3] <<= 1;

                    if(bit_idx >= 64){
                        dataset.key_[key_index >> 3] |=  (probe.SpecialInfo >> (bit_idx - 64)) & 0x1;
                    }
                    else{
                        dataset.key_[key_index >> 3] |=  (probe.TransitionCycles >> (bit_idx)) & 0x1;
                    }
                    
                }
                break;
            }
            default: std::runtime_error("Error while performing a higher-order multivariate table update: Unknown ID detected!"); break;
        }

    }  

    ++dataset.data_[ThreadSimulation.SelectedGroups[simulation_index]];
    GlobalSet.contingency_table_.UpdateBucket(dataset, number_of_groups);
}

//***************************************************************************************

void Software::Test::CompactHigherOrderMultivariateTableUpdate(Software::ThreadSimulationStruct& ThreadSimulation, uint32_t simulation_index, Software::ProbingSetStruct& GlobalSet, Software::ProbingSetStruct& ProbingSet, std::vector<std::vector<std::vector<uint8_t>>>& ProbeValues, Software::HelperStruct& Helper, std::vector<std::vector<uint32_t>>& ProbeInfoToStandardProbe){
    uint64_t heuristic = 0;
    uint64_t number_of_groups = ThreadSimulation.NumberOfGroups;
    uint64_t size_of_key_in_bytes = (ProbingSet.NumberOfProbesInSet >> 8) + 1;
    uint32_t clock_cycle;
    uint8_t id, register_index, partner_register_index, probed_bit, dependency;
    uint16_t extension_size;
    TableEntry dataset;

    dataset.key_ = std::make_unique<uint8_t[]>(size_of_key_in_bytes);
    dataset.data_ = std::make_unique<uint32_t[]>(number_of_groups);

    for (Software::ProbesStruct& probe : ProbingSet.StandardProbe){
        Software::Probing::ExtractAllProbeInfo(register_index, id, partner_register_index, clock_cycle, probed_bit, extension_size, dependency, probe);
        std::vector<uint32_t> resolved_probes = ProbeInfoToStandardProbe[(probe.ProbeInfo >> 8) & 0x7ffff]; //TODO: place resolved_probes into each case

        switch(id){
            case(0): //memory probe
            {
                heuristic += (probe.TransitionCycles >> 1) & 1;

                if(ThreadSimulation.TestTransitional){
                    heuristic += (probe.TransitionCycles) & 1;

                }
                break;
            }
            //memory probe shadow register
            case(1):
            {
                heuristic += ((probe.TransitionCycles ) >> probed_bit) & 1;

                if(ThreadSimulation.TestTransitional){
                    heuristic += (probe.TransitionCycles >> (32 + probed_bit)) & 1;
                }
                break;

            }
            //memory probe seperated load store shadow register
            case(2):
            {
                heuristic += ((probe.TransitionCycles) >> probed_bit) & 1;
                if(ThreadSimulation.TestTransitional){
                    heuristic += (probe.TransitionCycles >> (32 + probed_bit)) & 1;
                }
                break;
            }
            //memory probe shadow register horizontal
            case(3):{
                for(const auto& BitIdx: Helper.HorizontalBitsIncluded.at(17)){
                    heuristic += (probe.TransitionCycles >> (BitIdx) ) & 1;

                    if(ThreadSimulation.TestTransitional){
                        heuristic += (probe.TransitionCycles >> (32 + BitIdx)) & 1;
                    }
                }
                break;
            }

            case(4): //normal probe
            {
                for(const auto& resolvedProbe: resolved_probes){
                    uint8_t resolved_probed_register = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolved_probed_bit = resolvedProbe & 0x1f;
                    uint8_t resolved_transition = (resolvedProbe >> 19) & 0x1;

                    if(!resolved_transition){
                        heuristic += (ProbeValues[resolved_probed_register][resolved_probed_bit][clock_cycle] >> (simulation_index & 0x7)) & 1;
                    }
                    else{
                        heuristic += (ProbeValues[resolved_probed_register][resolved_probed_bit][probe.TransitionCycles & 0xffffffff] >> (simulation_index & 0x7)) & 1;
                    }
                }
                
                break;
            }

            case(5): //horizontal Probe
            {

                for(const auto& resolvedProbe: resolved_probes){
                    uint8_t resolved_probed_register = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolved_probed_bit = resolvedProbe & 0x1f;
                    uint8_t resolved_transition = (resolvedProbe >> 19) & 0x1;

                        if(!resolved_transition){
                            heuristic += (ProbeValues[resolved_probed_register][resolved_probed_bit][clock_cycle] >> (simulation_index & 0x7) ) & 1;
                        }
                        else{
                            heuristic += (ProbeValues[resolved_probed_register][resolved_probed_bit][probe.TransitionCycles & 0xffffffff] >> (simulation_index & 0x7)) & 1;
                        }
                }
                break;
            }


            case(6): //small vertical Probe
            {
                for(const auto& resolvedProbe: resolved_probes){
                    uint8_t resolved_probed_register = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolved_probed_bit = resolvedProbe & 0x1f;
                    uint8_t resolved_transition = (resolvedProbe >> 19) & 0x1;

                        if(!resolved_transition){
                            if(resolved_probed_register != partner_register_index){
                                heuristic += (ProbeValues[resolved_probed_register][resolved_probed_bit][clock_cycle] >> (simulation_index & 0x7)) & 1;
                            }
                            else{
                                heuristic += (ProbeValues[resolved_probed_register][resolved_probed_bit].at((probe.TransitionCycles >> 32)) >> (simulation_index & 0x7)) & 1;
                            }
                        }
                        else{
                            heuristic += (ProbeValues[register_index][probed_bit][probe.TransitionCycles & 0xffffffff] >> (simulation_index & 0x7)) & 1;
                        }
                    
                }

                break;

            }

            case(7): //large vertical probe
            {
                for(const auto& resolvedProbe: resolved_probes){
                    uint8_t resolved_probed_register = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolved_probed_bit = resolvedProbe & 0x1f;
                    uint8_t resolved_transition = (resolvedProbe >> 19) & 0x1;

                        if(!resolved_transition){
                            if(resolved_probed_register != partner_register_index){
                                heuristic += (ProbeValues[resolved_probed_register][resolved_probed_bit][clock_cycle] >> (simulation_index & 0x7)) & 1;
                            }
                            else{
                                heuristic += (ProbeValues[resolved_probed_register][resolved_probed_bit][clock_cycle] >> (simulation_index & 0x7)) & 1;
                            }
                        }
                        else{
                            if(resolved_probed_register != partner_register_index){
                                heuristic += (ProbeValues[resolved_probed_register][resolved_probed_bit][probe.TransitionCycles & 0xffffffff] >> (simulation_index & 0x7)) & 1;
                            }
                            else{
                                heuristic += (ProbeValues[resolved_probed_register][resolved_probed_bit][probe.TransitionCycles >> 32] >> (simulation_index & 0x7)) & 1;
                            }

                        }
        
                }

                break;


            }

            case(8)://small full HR probe
            {
                for(const auto& resolvedProbe: resolved_probes){
                    uint8_t resolved_probed_register = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolved_probed_bit = resolvedProbe & 0x1f;
                    uint8_t resolved_transition = (resolvedProbe >> 19) & 0x1;

                        if(!resolved_transition){
                            if(resolved_probed_register != partner_register_index){
                                heuristic +=  (ProbeValues[resolved_probed_register][resolved_probed_bit][clock_cycle] >> (simulation_index & 0x7)) & 1; //destination register of probe 
                            }
                            else{
                                heuristic +=  (ProbeValues[resolved_probed_register][resolved_probed_bit][probe.TransitionCycles >> 32] >> (simulation_index & 0x7)) & 1; 
                            }
                        }
                        else{
                            heuristic +=  (ProbeValues[resolved_probed_register][resolved_probed_bit][probe.TransitionCycles & 0xffffffff] >> (simulation_index & 0x7)) & 1; //transition of destination register of probe
                            
                        }
                    
                }

                break;

            }
            case(9):
            {
                for(const auto& resolvedProbe: resolved_probes){
                    uint8_t resolved_probed_register = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolved_probed_bit = resolvedProbe & 0x1f;
                    uint8_t resolved_transition = (resolvedProbe >> 19) & 0x1;

                        if(!resolved_transition){
                            if(resolved_probed_register != partner_register_index){
                                heuristic +=  (ProbeValues[resolved_probed_register][resolved_probed_bit][clock_cycle] >> (simulation_index & 0x7)) & 1; //destination register of probe 
                            }
                            else{
                                heuristic +=  (ProbeValues[resolved_probed_register][resolved_probed_bit][clock_cycle] >> (simulation_index & 0x7)) & 1; //transition of destination register of probe
                            }
                        }
                        else{
                            if(resolved_probed_register != partner_register_index){
                                heuristic +=  (ProbeValues[resolved_probed_register][resolved_probed_bit][probe.TransitionCycles & 0xffffffff] >> (simulation_index & 0x7)) & 1; 
                            }
                            else{
                                heuristic +=  (ProbeValues[resolved_probed_register][resolved_probed_bit][probe.TransitionCycles >> 32] >> (simulation_index & 0x7)) & 1;
                            }
                        }
                    
                }

                break;
            }
            case(10): //small full VR probe
            {
                for(const auto& resolvedProbe: resolved_probes){
                    uint8_t resolved_probed_register = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolved_transition = (resolvedProbe >> 19) & 0x1;


                        if(!resolved_transition){
                            heuristic +=  (probe.TransitionCycles >> resolved_probed_register) & 0x1;
                        }
                        else{
                            if(resolved_probed_register == register_index){
                                heuristic +=  (probe.TransitionCycles >> 17) & 0x1;
                            }
                            else if(resolved_probed_register == partner_register_index){
                                heuristic +=  (probe.TransitionCycles >> 18) & 0x1;
                            }

                        }

                    
                }

                break;
            }
            case(11): // large full VR probe
            {
                for(const auto& resolvedProbe: resolved_probes){
                    uint8_t resolved_probed_register = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolved_transition = (resolvedProbe >> 19) & 0x1;

                        
                        if(!resolved_transition){
                            heuristic +=  (probe.TransitionCycles >> resolved_probed_register) & 0x1;
                        }
                        else{
                            if(resolved_probed_register == register_index){
                                heuristic +=  (probe.TransitionCycles >> 17) & 0x1;
                            }
                            else if(resolved_probed_register == 15){
                                heuristic +=  (probe.TransitionCycles >> 18) & 0x1;
                            }
                            else if(resolved_probed_register == 16){
                                heuristic +=  (probe.TransitionCycles >> 19) & 0x1;
                            }

                        }

                    
                }

                break;
            }
            case(12): //special full VR probe
            {
                for(const auto& resolvedProbe: resolved_probes){
                    uint8_t resolved_probed_register = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolved_transition = (resolvedProbe >> 19) & 0x1;

                        
                        if(!resolved_transition){
                            heuristic +=  (probe.TransitionCycles >> resolved_probed_register) & 0x1; 
                        }
                        else{
                            if(resolved_probed_register == register_index){
                                heuristic +=  (probe.TransitionCycles >> 17) & 0x1;
                            }
                        }

                    
                }

                break;                
            }
            case(13): //small DSP full VR probe
            {
                for(const auto& resolvedProbe: resolved_probes){
                    uint8_t resolved_probed_register = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolved_transition = (resolvedProbe >> 19) & 0x1;

                        
                        if(!resolved_transition){
                            heuristic +=  (probe.TransitionCycles >> resolved_probed_register) & 0x1;
                        }
                        else{
                            if(resolved_probed_register == register_index){
                                heuristic +=  (probe.TransitionCycles >> 17) & 0x1;
                            }
                            else if(resolved_probed_register == partner_register_index){
                                heuristic +=  (probe.TransitionCycles >> 18) & 0x1;
                            }
                            else if(resolved_probed_register == 16){
                                heuristic +=  (probe.TransitionCycles >> 19) & 0x1;
                            }

                        }

                    
                }

                break;
            }
            case(14): //large DSP full VR probe
            {
                for(const auto& resolvedProbe: resolved_probes){
                    uint8_t resolved_probed_register = (resolvedProbe >> 10) & 0x1f;
                    uint8_t resolved_transition = (resolvedProbe >> 19) & 0x1;


                        if(!resolved_transition){
                            heuristic +=  (probe.TransitionCycles >> resolved_probed_register) & 0x1;
                        }
                        else{
                            if(resolved_probed_register == register_index){
                                heuristic +=  (probe.TransitionCycles >> 17) & 0x1;
                            }
                            else if(resolved_probed_register == partner_register_index){
                                heuristic +=  (probe.TransitionCycles >> 18) & 0x1;
                            }
                            else if(resolved_probed_register == 15){
                                heuristic +=  (probe.TransitionCycles >> 19) & 0x1;
                            }
                            else if(resolved_probed_register == 16){
                                heuristic +=  (probe.TransitionCycles >> 20) & 0x1;
                            }

                        }                        
                }

                break;
            }
            case(15): //pipeline forwarding probe
            {
                for(uint32_t bit_idx = 0; bit_idx < extension_size; ++bit_idx){
                    if(bit_idx >= 64){
                        heuristic += ((probe.SpecialInfo >> (bit_idx - 64)) & 0x1);
                    }
                    else{
                        heuristic += ((probe.TransitionCycles >> (bit_idx)) & 0x1);
                    }
                    
                }
                break;
            }

            default: std::runtime_error("Error while performing a higher-order multivariate compact table update: Unknown ID detected!"); break;
        }

    }  

    for(uint64_t i = 0; i < size_of_key_in_bytes; ++i){
        dataset.key_[i] = (heuristic >> (i << 3)) & 0xff;
    }

    ++dataset.data_[ThreadSimulation.SelectedGroups[simulation_index]];
    GlobalSet.contingency_table_.UpdateBucket(dataset, number_of_groups);
}