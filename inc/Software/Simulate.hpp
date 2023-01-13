#pragma once
#include "mulator/emulator.h"
#include <iostream>

namespace Software
{
    namespace Simulate
    {
        void Instantiate_Emulator(mulator::Emulator& , ::Software::ThreadSimulationStruct& , int , SettingsStruct& , ::Software::SharedDataStruct& , uint32_t , ::Software::ProbeTrackingStruct& , ::Software::HelperStruct& , std::vector<std::vector<std::vector<uint8_t>>>&);
        void Run(mulator::Emulator& , ::Software::ThreadSimulationStruct& , SettingsStruct& , ::Software::ProbeTrackingStruct& , ::Software::HelperStruct& , std::vector<std::vector<std::vector<uint8_t>>>& ,  uint64_t , uint32_t);
        void GenerateInputs(std::vector<Software::SharedDataStruct>& SharedInputData, std::vector<Software::ThreadSimulationStruct>& ThreadSimulation, Software::SettingsStruct& Settings, boost::variate_generator<boost::mt19937&, boost::uniform_int<uint64_t>>& InputPrng);
    } // namespace Simulate
    
    
} // namespace Software

