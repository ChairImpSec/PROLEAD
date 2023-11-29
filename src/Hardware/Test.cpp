#include "Hardware/Test.hpp"

void Hardware::Test::All(Hardware::SettingsStruct& Settings, Hardware::SimulationStruct& Simulation, Hardware::TestStruct& Test, char CompactDistributions){
    uint64_t     StepSimulationIndex = 0;

    for (StepSimulationIndex = 0; StepSimulationIndex < Simulation.NumberOfStepSimulations; StepSimulationIndex++){
        Test.SumOverGroup.at(Simulation.SelectedGroups[StepSimulationIndex]) += 1.0;
    }

	if (CompactDistributions){
        Hardware::Test::CompactTest(Simulation, Test);
	}else{
        Hardware::Test::NormalTest(Settings, Simulation, Test);
	}
}

void Hardware::Test::CompactTest(Hardware::SimulationStruct& simulation, Hardware::TestStruct& test){
    uint64_t     StepSimulationIndex = 0;
    int		     ThreadIndex = 0;
    size_t       set_index = 0;

    #pragma omp parallel for schedule(guided) private(ThreadIndex)
    for (StepSimulationIndex = 0; StepSimulationIndex < simulation.NumberOfStepSimulations; StepSimulationIndex++){
        ThreadIndex = omp_get_thread_num();
        Hardware::Test::CompactTableUpdate(simulation, StepSimulationIndex, test, test.TempProbeValue.at(ThreadIndex));
    }

    #pragma omp parallel for schedule(guided)
    for (set_index = 0; set_index < test.ProbingSet.size(); set_index++){
        test.ProbingSet[set_index].contingency_table.ComputeGTest(simulation.NumberOfGroups, simulation.NumberOfProcessedSimulations, test.SumOverGroup);
    }
}

void Hardware::Test::CompactTableUpdate(Hardware::SimulationStruct& Simulation, unsigned int SimulationIndex, Hardware::TestStruct& Test, std::vector<int>& TempProbeValue)
{
	unsigned int ProbeSetIndex = 0;
	int          ProbeIndex = 0;

    std::fill(TempProbeValue.begin(), TempProbeValue.end(), 0);

	for (ProbeIndex = 0; ProbeIndex < Test.NumberOfUniqueProbes; ProbeIndex++){
		if (Simulation.ProbeValues[SimulationIndex][Test.UniqueProbe[ProbeIndex]->Cycle][Test.UniqueProbe[ProbeIndex]->Probe]){
			for (ProbeSetIndex = 0; ProbeSetIndex < Test.UniqueProbe[ProbeIndex]->NumberOfProbeSets; ProbeSetIndex++){
				TempProbeValue.at(Test.UniqueProbe[ProbeIndex]->ProbeSetIndexes[ProbeSetIndex])++;
            }
        }
	}

	for (ProbeSetIndex = 0; ProbeSetIndex < (unsigned int)Test.ProbingSet.size(); ProbeSetIndex++){
		#pragma omp atomic
        ++Test.ProbingSet.at(ProbeSetIndex).contingency_table.GetCounters(TempProbeValue[ProbeSetIndex])[Simulation.SelectedGroups[SimulationIndex]];
	}
}

void Hardware::Test::NormalTest(Hardware::SettingsStruct& settings, Hardware::SimulationStruct& simulation, Hardware::TestStruct& test){
    #pragma omp parallel for schedule(guided)
	for (size_t set_index = 0; set_index < test.ProbingSet.size(); ++set_index){
		Hardware::Test::NormalTableUpdate(simulation, test, test.ProbingSet.at(set_index));
        test.ProbingSet[set_index].contingency_table.ComputeGTest(simulation.NumberOfGroups, simulation.NumberOfProcessedSimulations, test.SumOverGroup);
        test.ProbingSet[set_index].contingency_table.ComputeNumberOfRequiredTraces(settings.NumberOfGroups, settings.BetaThreshold, settings.EffectSize);
    } 
}

void Hardware::Test::NormalTableUpdate(Hardware::SimulationStruct& simulation, Hardware::TestStruct& test, Hardware::ProbingSetStruct& probing_set){
    hardware::stats::Key key;
    unsigned int group_index;
    size_t bit_index, key_index, tmp_index;
    unsigned char hash_value0, hash_value1;
    std::vector<Hardware::ProbePositionStruct*> extensions(probing_set.Extension.size());

    test.GetExtendedProbes(probing_set, extensions);

    for (uint64_t sim_index = 0; sim_index < simulation.NumberOfStepSimulations; ++sim_index){
        hash_value0 = 0;
        hash_value1 = 0;
        key = std::make_unique<unsigned char[]>(probing_set.contingency_table.GetKeySizeExcludingHashValues()); 

        // Set first hash value
        for (bit_index = 0; (bit_index < 8) && (bit_index < probing_set.Extension.size()); ++bit_index){
            hash_value0 <<= 1;
            hash_value0 |= simulation.ProbeValues[sim_index][extensions[bit_index]->Cycle][extensions[bit_index]->Probe];
        }

        // Set second hash value
        for (bit_index = 8; (bit_index < 16) && (bit_index < probing_set.Extension.size()); ++bit_index){
            hash_value1 <<= 1;
            hash_value1 |= simulation.ProbeValues[sim_index][extensions[bit_index]->Cycle][extensions[bit_index]->Probe];
        }
    
        // Get regular key
        for (key_index = 0; key_index < probing_set.contingency_table.GetKeySizeExcludingHashValues(); ++key_index){
            tmp_index = probing_set.contingency_table.GetKeySizeExcludingHashValues() - key_index - 1;
            for (bit_index = (key_index + probing_set.contingency_table.GetNumberOfLayers()) << 3; bit_index < ((key_index + probing_set.contingency_table.GetNumberOfLayers() + 1) << 3) && (bit_index < probing_set.Extension.size()); ++bit_index){
                key[tmp_index] <<= 1;
                key[tmp_index] |= simulation.ProbeValues[sim_index][extensions[bit_index]->Cycle][extensions[bit_index]->Probe];
            }
        }

        group_index = simulation.SelectedGroups[sim_index];
        probing_set.contingency_table.UpdateTable(std::move(key), hash_value0, hash_value1, simulation.NumberOfGroups, group_index);
    }
}