#pragma once
#include "Software/Definitions.hpp"
#include "Software/mulator/emulator.h"
#include "Software/Operators.hpp"
#include <algorithm>
#include <cmath>
#include <numeric>

#define ID_OFFSET 23
#define ID_MASK 0x7800000
#define REG1_OFFSET 18
#define REG1_MASK 0x7c0000
#define REG2_OFFSET 13
#define REG2_MASK 0x3e000
#define BIT_OFFSET 8
#define BIT_MASK 0x1f00
#define CYCLE_OFFSET 32
#define EXTENSION_MASK 0xff
#define DEPENDENCY_OFFSET 27
#define DEPENDENCY_MASK 0x78000000

namespace Software
{
    namespace Probing
    {
        void GetProbingSets(Software::ThreadSimulationStruct& , Software::SettingsStruct& , Software::TestStruct&, std::vector<std::tuple<uint32_t, uint32_t>>&, std::vector<std::vector<uint32_t>>&, uint64_t );
        void GetMultivariateProbingSets(std::vector<std::vector<Software::ProbesStruct>>& OneSimulationStandardProbes, SettingsStruct& Settings, Software::TestStruct& Test, std::vector<std::tuple<uint32_t, uint32_t>>& OrderOverTwoCombination, std::vector<std::vector<uint32_t>>& ProbeInfoToStandardProbe, uint32_t ThreadIndex, uint32_t SimulationIndex);
        bool InDistance(Software::SettingsStruct& , std::vector<Software::ProbesStruct>& );
        uint32_t MemoryConsumption();

        void CreateNormalProbe(std::vector<uint8_t>& , std::vector<Software::ProbesStruct>& , std::vector<std::vector<uint8_t>>& , uint32_t& , uint64_t& , uint32_t , uint32_t , uint64_t , uint32_t, uint8_t);
        
        void CreateHorizontalProbe(std::vector<Software::ProbesStruct>& , uint32_t , uint8_t , uint32_t& , uint32_t , uint8_t );

        void CreateLargeVerticalProbe(std::vector<Software::ProbesStruct>& , uint64_t&  , uint32_t& , uint32_t , uint32_t );
        void CreateSmallVerticalProbe(std::vector<Software::ProbesStruct>& , uint64_t&  , uint32_t& , uint32_t,  uint32_t );
        
        void CreateLargeFullHorizontalProbe(std::vector<Software::ProbesStruct>& , uint64_t&  , uint32_t& , uint32_t , uint32_t);
        void CreateSmallFullHorizontalProbe(std::vector<Software::ProbesStruct>& , uint64_t&  , uint32_t& , uint32_t,  uint32_t);
        
        void CreateLargeFullVerticalProbe(std::vector<Software::ProbesStruct>& StandardProbes, std::vector<uint8_t>& FullVerticalProbes, uint8_t BitIdx, uint8_t RegNr, uint32_t& ProbeIndex, uint64_t ProbeInfo, std::vector<uint32_t>& RegisterValues, uint32_t TransValueRegNr, uint32_t TransValuePC, uint32_t TransValuePSR);
        void CreateSmallFullVerticalProbe(std::vector<Software::ProbesStruct>& StandardProbes, std::vector<uint8_t>& FullVerticalProbes, uint8_t BitIdx, uint8_t RegNr1, uint8_t RegNr2, uint32_t& ProbeIndex, uint64_t ProbeInfo, std::vector<uint32_t>& RegisterValues, uint32_t TransValueReg1, uint32_t TransValueReg2);
        void CreateOneRegisterOnlyFullVerticalProbe(std::vector<Software::ProbesStruct>& StandardProbes, std::vector<uint8_t>& FullVerticalProbes, uint8_t BitIdx, uint8_t RegNr1, uint32_t& ProbeIndex, uint64_t ProbeInfo, std::vector<uint32_t>& RegisterValues, uint32_t TransValueRegNr);

        void CreateDSPLargeFullVerticalProbe(std::vector<Software::ProbesStruct>& StandardProbes, std::vector<uint8_t>& FullVerticalProbes, uint8_t BitIdx, uint8_t low_RegNr, uint8_t high_RegNr, uint32_t& ProbeIndex, uint64_t ProbeInfo, std::vector<uint32_t>& RegisterValues, uint32_t TransValueLowRegNr, uint32_t TransValueHighRegNr, uint32_t TransValuePC, uint32_t TransValuePSR);
        void CreateDSPSmallFullVerticalProbe(std::vector<Software::ProbesStruct>& StandardProbes, std::vector<uint8_t>& FullVerticalProbes, uint8_t BitIdx, uint8_t low_RegNr, uint8_t high_RegNr, uint32_t& ProbeIndex, uint64_t ProbeInfo, std::vector<uint32_t>& RegisterValues, uint32_t TransValueLowRegNr, uint32_t TransValueHighRegNr, uint32_t TransValuePC);
        
        void CreateMemoryProbe();
        void CreateMemShadowProbe(std::vector<Software::ProbesStruct>& , std::vector<uint8_t>& ,  uint64_t , uint32_t& , uint32_t , uint32_t , uint32_t );
        void CreateHorizontalMemShadowProbe(std::vector<Software::ProbesStruct>& StandardProbes, uint32_t InstrNr, uint32_t& ProbeIndex, uint8_t RegNr, uint32_t memory_shadow_register, uint32_t next_shadow_register_value, uint32_t TransitionCycle, uint32_t ExtensionSize);

        void ExtractAllProbeInfo(uint8_t& , uint8_t&, uint8_t& , uint32_t& , uint8_t& , uint16_t& , uint8_t& , Software::ProbesStruct& );
        void ExtractBitProbeInfo(uint8_t& , Software::ProbesStruct&);
        void ExtractCycleProbeInfo(uint32_t& , Software::ProbesStruct& );
        void ExtractIdProbeInfo(uint8_t& , Software::ProbesStruct& );
        void ExtractRegisterProbeInfo(uint8_t&, Software::ProbesStruct&);
        void ExtractDependencyProbeInfo(uint8_t& , Software::ProbesStruct& );
        void ExtractExtensionSizeProbeInfo(uint16_t& , Software::ProbesStruct& );

        void FillHigherOrderRedundantCases(std::vector<std::vector<uint32_t>>&);
        void RedundancyNormalProbe(std::vector<std::vector<uint32_t>>&);
        void RedundancyHorizontalProbe(std::vector<std::vector<uint32_t>>&);
        void RedundancyVerticalProbe(std::vector<std::vector<uint32_t>>&);
        void RedundancyFullHorizontalProbe(std::vector<std::vector<uint32_t>>&);
        void RedundancyFullVerticalProbe(std::vector<std::vector<uint32_t>>&);
        
        void ProbeInfoToStandardProbeMapping(std::vector<std::vector<uint32_t>>& , Software::HelperStruct&, Software::SettingsStruct&);
        void Univariate_AddCombinationToProbingSet(Software::ProbingSetStruct& , std::vector<Software::ProbesStruct>& , std::vector<std::tuple<uint32_t, uint32_t>>& , std::vector<std::vector<uint32_t>>&, std::vector<std::vector<uint32_t>>& , uint32_t );
        void Multivariate_AddCombinationToProbingSet(Software::ProbingSetStruct& , std::vector<Software::ProbesStruct>& , std::vector<std::tuple<uint32_t, uint32_t>>& , std::vector<std::vector<uint32_t>>&, std::vector<std::vector<uint32_t>>& , uint32_t );
    } // namespace Probing
    
    
} // namespace Software

