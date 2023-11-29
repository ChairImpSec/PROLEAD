#include "Hardware/GenerateProbingSets.hpp"

void Hardware::GenerateProbingSets::All(Hardware::SettingsStruct& Settings, Hardware::SimulationStruct& Simulation, Hardware::TestStruct& Test){
    Hardware::GenerateProbingSets::Extend(Simulation, Test);

    // If the same probe occurs multiple times in one probing set, we remove it.
    // This leads to smaller contingency tables.
    Hardware::GenerateProbingSets::RemoveDuplicatedProbes(Test);

    // Moreover, we remove probing sets which are fully convered by another probing set.
    Hardware::GenerateProbingSets::RemoveDuplicatedProbingSets(Settings, Simulation, Test);

    bool is_in_compact_mode = Settings.CompactDistributions == 1;

    if (is_in_compact_mode){
        // We assume, that the contingency tables in compact mode encompass a small number of entries
        // Therefore, we pre-allocate memory for all entries of the table. This leads to a faster evaluation. 
        Hardware::GenerateProbingSets::InitializeCompactDistributions(Settings, Simulation, Test);
    }/*
        //Test.TableEntries.resize(Settings.Max_no_of_Threads, std::vector<Util::TableEntryStruct>(Simulation.NumberOfStepSimulations, Util::TableEntryStruct(1)));
        
        for (size_t SetIndex = 0; SetIndex < Test.ProbingSet.size(); SetIndex++){
            Test.ProbingSet.at(SetIndex).ContingencyTable.OnlyOneEntry.resize(Simulation.NumberOfGroups, std::vector<std::vector<std::vector<unsigned char>>>(256));
        }
    }*/

    for (size_t set_index = 0; set_index < Test.ProbingSet.size(); ++set_index){
        Test.ProbingSet[set_index].contingency_table.Initialize(Settings.NumberOfGroups, Test.ProbingSet[set_index].Extension.size(), is_in_compact_mode);
    }
}

void Hardware::GenerateProbingSets::GenerateProbes(Hardware::SimulationStruct& Simulation, Hardware::TestStruct& Test){
    int CycleIndex = 0, GlitchIndex = 0, ProbeIndex = 0;

    std::cout << "Generate list of standard probes from " << Simulation.NumberOfProbes << " standard probe locations..." << std::flush;
    for (CycleIndex = 0; CycleIndex < Simulation.NumberOfTestClockCycles; CycleIndex++){ 
        for (ProbeIndex = 0; ProbeIndex < Simulation.NumberOfProbes; ProbeIndex++){
            Test.StandardProbes.emplace_back(ProbeIndex, Simulation.TestClockCycles[CycleIndex] - 1);
        }
    }
    std::cout << Test.StandardProbes.size() << " standard probes found...done!" << std::endl;

    std::cout << "Generate list of extended probes from " << Simulation.NumberOfAllGlitchExtendedProbes << " extended probe locations..." << std::flush;
    for (CycleIndex = 0; CycleIndex < Simulation.NumberOfTestClockCycles; CycleIndex++){ 
        for (ProbeIndex = 0; ProbeIndex < Simulation.NumberOfProbes; ProbeIndex++){
            for (GlitchIndex = 0; GlitchIndex < Simulation.GlitchExtendedProbes[ProbeIndex].NumberOfProbes; GlitchIndex++){
                // Add glitch-extended probes
                Test.ExtendedProbes.emplace_back(Simulation.GlitchExtendedProbes[ProbeIndex].Probes[GlitchIndex], Simulation.TestClockCycles[CycleIndex] - 1);

                if (Simulation.TestTransitional && ((Simulation.TestClockCycles[CycleIndex] - 1) != 0)){
                    // Add transition-extended probes
                    Test.ExtendedProbes.emplace_back(Simulation.GlitchExtendedProbes[ProbeIndex].Probes[GlitchIndex], Simulation.TestClockCycles[CycleIndex] - 2);
                }
            }  
        }
    }
    std::cout << Test.ExtendedProbes.size() << " extended probes found...done!" << std::endl;
}

void Hardware::GenerateProbingSets::InitializeMultivariateProbeCombinations(Hardware::SimulationStruct& Simulation, Hardware::TestStruct& Test, std::vector<unsigned int>& Combination, std::vector<bool>& CombinationBitmask){
    // Cover the case that the order is higher than the number of standard probes
    // In this case, only one probing set including all standard probes is generated
    if (Simulation.TestOrder > (int)Test.StandardProbes.size()){
        Combination.resize(Test.StandardProbes.size());
        std::fill(CombinationBitmask.begin(), CombinationBitmask.end(), true);   
    }else{
        Combination.resize(Simulation.TestOrder);
        std::fill(CombinationBitmask.begin(), CombinationBitmask.begin() + Simulation.TestOrder, true);    
    }
}

void Hardware::GenerateProbingSets::InitializeUnivariateProbeCombinations(Hardware::SimulationStruct& Simulation, std::vector<unsigned int>& Combination, std::vector<bool>& CombinationBitmask){
    // Cover the case that the order is higher than the number of different probe positions
    // In this case, multiple probing set with probes on all positions are generated
    if (Simulation.TestOrder > Simulation.NumberOfProbes){
        Combination.resize(Simulation.NumberOfProbes);
        std::fill(CombinationBitmask.begin(), CombinationBitmask.end(), true);
    }else{
        Combination.resize(Simulation.TestOrder);
        std::fill(CombinationBitmask.begin(), CombinationBitmask.begin() + Simulation.TestOrder, true);
    }
}

bool Hardware::GenerateProbingSets::InDistance(Hardware::SettingsStruct& Settings, Hardware::TestStruct& Test, std::vector<unsigned int>& ProbingSet){
    size_t ProbeIndex = 0;
	int Distance = 0;

	std::vector<unsigned int> Cycles(ProbingSet.size());

    for (ProbeIndex = 0; ProbeIndex < ProbingSet.size(); ProbeIndex++){
		Cycles.at(ProbeIndex) = Test.StandardProbes.at(ProbingSet.at(ProbeIndex)).Cycle;
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

void Hardware::GenerateProbingSets::Extend(Hardware::SimulationStruct& Simulation, Hardware::TestStruct& Test){
    int GlitchIndex = 0, ProbeIndex = 0;
    size_t SetIndex = 0;

    ProbePositionStruct ExtendedProbe;
    std::vector<ProbePositionStruct>::iterator it;
    std::iterator_traits<std::vector<ProbePositionStruct>::iterator>::difference_type Index; 
    std::string ErrorMessage;

    std::cout << "Extend all probing sets..." << std::flush;

    // Sort in a way that the smallest element has the smallest index
    std::sort(Test.ExtendedProbes.begin(), Test.ExtendedProbes.end(), [](Hardware::ProbePositionStruct& lhs, Hardware::ProbePositionStruct& rhs){return lhs < rhs;});
    Test.ExtendedProbes.erase(std::unique(Test.ExtendedProbes.begin(), Test.ExtendedProbes.end(), [](Hardware::ProbePositionStruct& lhs, Hardware::ProbePositionStruct& rhs){return lhs == rhs;}), Test.ExtendedProbes.end());

    // Extend all standard probes of a probing set
    for (SetIndex = 0; SetIndex < Test.ProbingSet.size(); SetIndex++){
        for (ProbeIndex = 0; ProbeIndex < Test.GetNumberOfStandardProbes(SetIndex); ProbeIndex++){
            for (GlitchIndex = 0; GlitchIndex < Simulation.GlitchExtendedProbes[Test.GetStandardProbe(SetIndex, ProbeIndex).Probe].NumberOfProbes; GlitchIndex++){
                ExtendedProbe.Probe = Simulation.GlitchExtendedProbes[Test.GetStandardProbe(SetIndex, ProbeIndex).Probe].Probes[GlitchIndex];
                ExtendedProbe.Cycle = Test.GetStandardProbe(SetIndex, ProbeIndex).Cycle;

                // Check if the glitch-extended probe is in the list of extended probes
                it = std::lower_bound(Test.ExtendedProbes.begin(), Test.ExtendedProbes.end(), ExtendedProbe, [](const Hardware::ProbePositionStruct& lhs, const Hardware::ProbePositionStruct& rhs){return lhs < rhs;});
                Index = std::distance(Test.ExtendedProbes.begin(), it);

                if ((it == Test.ExtendedProbes.end()) || (Test.ExtendedProbes.at(Index) != ExtendedProbe)){
                    ErrorMessage = "The glitch-extended probe p" + std::to_string(ExtendedProbe.Probe) + "(" + std::to_string(ExtendedProbe.Cycle) + ") is not known as a probe extension!";
                    throw std::runtime_error(ErrorMessage);
                }else{
                    Test.ProbingSet.at(SetIndex).Extension.push_back(Index);
                }

                if (Simulation.TestTransitional && (ExtendedProbe.Cycle != 0)){
                    // Check if the transition-extended probe is in the list of extended probes
                    ExtendedProbe.Cycle--;

                    it = std::lower_bound(Test.ExtendedProbes.begin(), Test.ExtendedProbes.end(), ExtendedProbe, [](const Hardware::ProbePositionStruct& lhs, const Hardware::ProbePositionStruct& rhs){return lhs < rhs;});
                    Index = std::distance(Test.ExtendedProbes.begin(), it);

                    if ((it == Test.ExtendedProbes.end()) || (Test.ExtendedProbes.at(Index) != ExtendedProbe)){
                        ErrorMessage = "The transition-extended probe p" + std::to_string(ExtendedProbe.Probe) + "(" + std::to_string(ExtendedProbe.Cycle) + ") is not known as a probe extension!";
                        throw std::runtime_error(ErrorMessage);
                    }else{
                        Test.ProbingSet.at(SetIndex).Extension.push_back(Index);
                    }
                }
            }
        }     
    }

    std::cout << "done!" << std::endl;
}

void Hardware::GenerateProbingSets::RemoveDuplicatedProbes(Hardware::TestStruct& Test){
    std::cout << "Remove duplicated probes in the sets..." << std::flush;   

    for (size_t SetIndex = 0; SetIndex < Test.ProbingSet.size(); SetIndex++){
        std::sort(Test.ProbingSet.at(SetIndex).Extension.begin(), Test.ProbingSet.at(SetIndex).Extension.end(), std::greater<unsigned int>());
        Test.ProbingSet.at(SetIndex).Extension.erase(std::unique(Test.ProbingSet.at(SetIndex).Extension.begin(), Test.ProbingSet.at(SetIndex).Extension.end()), Test.ProbingSet.at(SetIndex).Extension.end());
    } 

    std::cout << "done!" << std::endl;
}

void Hardware::GenerateProbingSets::CoverWithOneProbingSet(Hardware::TestStruct& Test, unsigned int SetIndex, unsigned int Start, unsigned int End){
    // Iterate through all probing set that should be covered by another probing set
    for (unsigned int Index = Start; Index < End; Index++){
        if ((SetIndex != Index) && Test.ProbingSet.at(SetIndex).Covers(Test.ProbingSet.at(Index))){
            if (std::includes(Test.ProbingSet.at(SetIndex).Extension.begin(), Test.ProbingSet.at(SetIndex).Extension.end(), Test.ProbingSet.at(Index).Extension.begin(), Test.ProbingSet.at(Index).Extension.end(), std::greater<unsigned int>())){
                // Traces equals one means that the probing set should be removed
                Test.ProbingSet.at(Index).contingency_table.MarkAsRemovable();
            }
        }
    }    
}

void Hardware::GenerateProbingSets::RemoveCoveredProbingSets(Hardware::TestStruct& Test, unsigned int Start, unsigned int End){    
    // Iterate through all probing set that should cover another probing set
    for (unsigned int Index = Start; Index < End; Index++){
        Hardware::GenerateProbingSets::CoverWithOneProbingSet(Test, Index, Start, End);
    }    
}

void Hardware::GenerateProbingSets::RemoveDuplicatedProbingSets(Hardware::SettingsStruct& Settings, Hardware::SimulationStruct& Simulation, Hardware::TestStruct& Test){
    std::cout << "Remove duplicated probing sets..." << std::flush;
    size_t Index = 0;
    
    // Remove all probing sets that occur twice
    std::sort(Test.ProbingSet.begin(), Test.ProbingSet.end(), [](Hardware::ProbingSetStruct& lhs, Hardware::ProbingSetStruct& rhs){return lhs < rhs;});
    Test.ProbingSet.erase(std::unique(Test.ProbingSet.begin(), Test.ProbingSet.end(), [](Hardware::ProbingSetStruct& lhs, Hardware::ProbingSetStruct& rhs){return lhs == rhs;}), Test.ProbingSet.end());
    std::cout << "done! " << Test.ProbingSet.size() << " probing sets remain!" << std::endl;

    // Remove all probing sets that are completely covered by another probing set
    if (Settings.MinimizeProbeSets){
        std::cout << "Remove subsets of probing sets..." << std::flush;

        if ((Simulation.TestMultivariate != 0) && (Simulation.NumberOfTestClockCycles > 1) && (Simulation.TestOrder != 1)){
            std::cout << "Setting multivariate case..." << std::flush;
            Hardware::GenerateProbingSets::RemoveCoveredProbingSets(Test, 0, Test.ProbingSet.size()); 
        }else{
            std::cout << "Setting univariate case..." << std::flush;
            if (Simulation.NumberOfTestClockCycles != 1){
                std::vector<unsigned int> StartIndices(1,0), EndIndices;

                for (Index = 1; Index < Test.ProbingSet.size(); Index++){
                    if (Test.ExtendedProbes.at(Test.ProbingSet.at(Index - 1).Extension.back()).Cycle != Test.ExtendedProbes.at(Test.ProbingSet.at(Index).Extension.back()).Cycle){                        
                        StartIndices.push_back(Index);
                        EndIndices.push_back(Index);
                    }
                }
                EndIndices.push_back(Test.ProbingSet.size());

                // Each set of probing sets with the same clock cycle can be minimized in parallel
                // As they are independend, the runtime is decreased
                #pragma omp parallel for schedule(guided)
                for (Index = 0; Index < StartIndices.size(); Index++){
                    Hardware::GenerateProbingSets::RemoveCoveredProbingSets(Test, StartIndices.at(Index), EndIndices.at(Index));
                }
            }else{
                if (Test.ProbingSet.size() > 1){
                    Hardware::GenerateProbingSets::RemoveCoveredProbingSets(Test, 0, Test.ProbingSet.size()); 
                }
            }
        }
        
        Test.ProbingSet.erase(std::remove_if(Test.ProbingSet.begin(), Test.ProbingSet.end(), Hardware::GenerateProbingSets::Remove), Test.ProbingSet.end());
        std::cout << "done! " << Test.ProbingSet.size() << " probing sets remain!" << std::endl;    
    }
}

bool Hardware::GenerateProbingSets::Remove(ProbingSetStruct& ProbingSet){
    return ProbingSet.contingency_table.IsRemovable();
}

void Hardware::GenerateProbingSets::InitializeCompactDistributions(Hardware::SettingsStruct& Settings, Hardware::SimulationStruct& Simulation, Hardware::TestStruct& Test){
    Util::TableEntryStruct emptyTableEntry(Simulation.NumberOfGroups);
    unsigned int          setIndex = 0, ProbeIndex = 0;
	int                   TempIndex = 0, ClockCycle;
	int**                 TempClockProbeTable = NULL;

    /*for (setIndex = 0; setIndex < Test.ProbingSet.size(); setIndex++){
        for (ProbeIndex = 0; ProbeIndex <= Test.ProbingSet.at(setIndex).Extension.size(); ProbeIndex++){
			Test.ProbingSet.at(setIndex).ContingencyTable.Entries.push_back(emptyTableEntry);
		}
	}*/

    Test.TempProbeValue.resize(Settings.Max_no_of_Threads, std::vector<int>(Test.ProbingSet.size(), 0));

	TempClockProbeTable = (int**)malloc(Simulation.NumberOfClockCycles * sizeof(int*));
	for (ClockCycle = 0;ClockCycle < Simulation.NumberOfClockCycles; ClockCycle++)
	{
		TempClockProbeTable[ClockCycle] = (int*)calloc(Simulation.NumberOfAllGlitchExtendedProbes, sizeof(int));
		for (TempIndex = 0; TempIndex < Simulation.NumberOfAllGlitchExtendedProbes; TempIndex++)
		{
			TempClockProbeTable[ClockCycle][TempIndex] = -1;
		}
	}

	Test.NumberOfUniqueProbes = 0;

	for (setIndex = 0; setIndex < Test.ProbingSet.size(); setIndex++)
		for (ProbeIndex = 0; ProbeIndex < Test.ProbingSet[setIndex].Extension.size(); ProbeIndex++)
		{
			TempIndex = TempClockProbeTable[Test.ExtendedProbes.at(Test.ProbingSet[setIndex].Extension[ProbeIndex]).Cycle][Test.ExtendedProbes.at(Test.ProbingSet[setIndex].Extension[ProbeIndex]).Probe];
			if (TempIndex < 0)
			{
				TempClockProbeTable[Test.ExtendedProbes.at(Test.ProbingSet[setIndex].Extension[ProbeIndex]).Cycle][Test.ExtendedProbes.at(Test.ProbingSet[setIndex].Extension[ProbeIndex]).Probe] = Test.NumberOfUniqueProbes;
				Test.NumberOfUniqueProbes++;
			}
		}

	Test.UniqueProbe = (UniqueProbeStruct**)malloc(Test.NumberOfUniqueProbes * sizeof(UniqueProbeStruct*));
	for (TempIndex = 0; TempIndex < Test.NumberOfUniqueProbes; TempIndex++)
	{
		Test.UniqueProbe[TempIndex] = (UniqueProbeStruct*)malloc(sizeof(UniqueProbeStruct));
		Test.UniqueProbe[TempIndex]->NumberOfProbeSets = 0;
	}

	for (setIndex = 0; setIndex < Test.ProbingSet.size(); setIndex++)
	{
		for (ProbeIndex = 0; ProbeIndex < Test.ProbingSet[setIndex].Extension.size(); ProbeIndex++)
		{
			TempIndex = TempClockProbeTable[Test.ExtendedProbes.at(Test.ProbingSet[setIndex].Extension[ProbeIndex]).Cycle][Test.ExtendedProbes.at(Test.ProbingSet[setIndex].Extension[ProbeIndex]).Probe];
			Test.UniqueProbe[TempIndex]->Cycle = Test.ExtendedProbes.at(Test.ProbingSet[setIndex].Extension[ProbeIndex]).Cycle;
			Test.UniqueProbe[TempIndex]->Probe = Test.ExtendedProbes.at(Test.ProbingSet[setIndex].Extension[ProbeIndex]).Probe;
			Test.UniqueProbe[TempIndex]->NumberOfProbeSets++;
		}
	}

	for (TempIndex = 0; TempIndex < Test.NumberOfUniqueProbes; TempIndex++)
	{
		Test.UniqueProbe[TempIndex]->ProbeSetIndexes = (unsigned int*)malloc(Test.UniqueProbe[TempIndex]->NumberOfProbeSets * sizeof(unsigned int));
		Test.UniqueProbe[TempIndex]->NumberOfProbeSets = 0; // to be used as a counter in the next part
	}

	for (setIndex = 0; setIndex < Test.ProbingSet.size(); setIndex++)
	{
		for (ProbeIndex = 0; ProbeIndex < Test.ProbingSet[setIndex].Extension.size(); ProbeIndex++)
		{
			TempIndex = TempClockProbeTable[Test.ExtendedProbes.at(Test.ProbingSet[setIndex].Extension[ProbeIndex]).Cycle][Test.ExtendedProbes.at(Test.ProbingSet[setIndex].Extension[ProbeIndex]).Probe];
			Test.UniqueProbe[TempIndex]->ProbeSetIndexes[Test.UniqueProbe[TempIndex]->NumberOfProbeSets] = setIndex;
			Test.UniqueProbe[TempIndex]->NumberOfProbeSets++;
		}
	}

	for (ClockCycle = 0;ClockCycle < Simulation.NumberOfClockCycles;ClockCycle++)
	{
		free(TempClockProbeTable[ClockCycle]);
	}

	free(TempClockProbeTable);
}