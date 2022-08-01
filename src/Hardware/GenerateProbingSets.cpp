#include "Hardware/GenerateProbingSets.hpp"

void Hardware::GenerateProbingSets::All(Hardware::SettingsStruct& Settings, Hardware::SimulationStruct& Simulation, Hardware::TestStruct& Test){
	// Generate all possible probing sets
    std::cout << "Generate all possible probing sets for order " << Simulation.TestOrder << "..." << std::endl;
    Hardware::GenerateProbingSets::GenerateProbes(Simulation, Test);

    if ((Simulation.TestMultivariate != 0) && (Simulation.NumberOfTestClockCycles > 1) && (Simulation.TestOrder != 1)){
        Hardware::GenerateProbingSets::Multivariate(Settings, Simulation, Test);
    }else{
        Hardware::GenerateProbingSets::Univariate(Simulation, Test);
    }

    std::cout << "done! " << Test.ProbingSet.size() << " probing sets generated!" << std::endl;

    if (Settings.NumberOfProbeSteps == 1 || Settings.MinimizeProbeSets || Settings.CompactDistributions){
        std::cout << "Extend all probing sets..." << std::flush;
        Hardware::GenerateProbingSets::Extend(Simulation, Test, 0, Test.ProbingSet.size());
        std::cout << "done!" << std::endl;
        
        std::cout << "Remove duplicated probes in the sets..." << std::flush;
        Hardware::GenerateProbingSets::RemoveDuplicatedProbes(Test, 0, Test.ProbingSet.size());
        std::cout << "done!" << std::endl;

        Hardware::GenerateProbingSets::RemoveDuplicatedProbingSets(Settings, Simulation, Test, 0, Test.ProbingSet.size());

        if (Settings.NumberOfProbeSteps > 1 && Settings.MinimizeProbeSets && !Settings.CompactDistributions){
            for (size_t SetIndex = 0; SetIndex < Test.ProbingSet.size(); SetIndex++){
                Test.ProbingSet.at(SetIndex).Extension.clear();
            }
        }
    }

    if (Settings.CompactDistributions){
        Hardware::GenerateProbingSets::InitializeCompactDistributions(Settings, Simulation, Test);
    }else{
        Test.TableEntries.resize(Settings.Max_no_of_Threads, std::vector<Hardware::TableEntryStruct>(Simulation.NumberOfStepSimulations, TableEntryStruct(1)));
    }
}

void Hardware::GenerateProbingSets::GenerateProbes(Hardware::SimulationStruct& Simulation, Hardware::TestStruct& Test){
    int CycleIndex = 0, GlitchIndex = 0, ProbeIndex = 0;

    std::cout << "Generate list of standard probes..." << std::flush;
    for (CycleIndex = 0; CycleIndex < Simulation.NumberOfTestClockCycles; CycleIndex++){ 
        for (ProbeIndex = 0; ProbeIndex < Simulation.NumberOfProbes; ProbeIndex++){
            Test.StandardProbes.emplace_back(ProbeIndex, Simulation.TestClockCycles[CycleIndex] - 1);
        }
    }
    std::cout << "done!" << std::endl;

    std::cout << "Generate list of extended probes..." << std::flush;
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
    std::cout << "done!" << std::endl;
}

void Hardware::GenerateProbingSets::Multivariate(Hardware::SettingsStruct& Settings, Hardware::SimulationStruct& Simulation, Hardware::TestStruct& Test){
    std::cout << "Generate multivariate probing sets..." << std::flush;
    int CombinationIndex = 0;
    size_t ProbeIndex = 0;

	// Set the bitmask to the first possible probe combination
    std::vector<unsigned int> Combination(Simulation.TestOrder);
	std::vector<bool> CombinationBitmask(Test.StandardProbes.size(), false);
	std::fill(CombinationBitmask.begin(), CombinationBitmask.begin() + Simulation.TestOrder, true);    

    do{
        CombinationIndex = 0;

        for (ProbeIndex = 0; ProbeIndex < Test.StandardProbes.size(); ProbeIndex++){
            if (CombinationBitmask.at(ProbeIndex)){
                Combination.at(CombinationIndex) = ProbeIndex;
                CombinationIndex++;
            }

            if (CombinationIndex == Simulation.TestOrder){
                break;
            }
        }

        // Check if the maximum distance over time is in the allowed range
        if (Hardware::GenerateProbingSets::InDistance(Settings, Test, Combination)){
            Test.ProbingSet.emplace_back(Combination);
        }
    } while (std::prev_permutation(CombinationBitmask.begin(), CombinationBitmask.end()));   

    std::cout << "done!" << std::endl;  
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

void Hardware::GenerateProbingSets::Univariate(Hardware::SimulationStruct& Simulation, Hardware::TestStruct& Test){
    std::cout << "Generate univariate probing sets..." << std::flush;
	int CycleIndex = 0, CombinationIndex = 0;
    size_t ProbeIndex = 0;

    // Fast variant for first order
    if (Simulation.TestOrder == 1){
        std::cout << "Setting first-order variant..." <<std::flush;
        for (ProbeIndex = 0; ProbeIndex < Test.StandardProbes.size(); ProbeIndex++){
            Test.ProbingSet.emplace_back(ProbeIndex);    
        }

    // Slower variant for higher orders    
    }else{
        std::cout << "Setting higher-order variant..." <<std::flush;

        // Set the bitmask to the first possible probe combination
        std::vector<unsigned int> Combination(Simulation.TestOrder);

        for (CycleIndex = 0; CycleIndex < Simulation.NumberOfTestClockCycles; CycleIndex++){
            std::vector<bool> CombinationBitmask(Simulation.NumberOfProbes, false);
	        std::fill(CombinationBitmask.begin(), CombinationBitmask.begin() + Simulation.TestOrder, true);

            do{
                CombinationIndex = 0;

                for (ProbeIndex = 0; ProbeIndex < (size_t)Simulation.NumberOfProbes; ProbeIndex++){
                    if (CombinationBitmask.at(ProbeIndex)){
                        Combination.at(CombinationIndex) = CycleIndex * Simulation.NumberOfProbes + ProbeIndex;
                        CombinationIndex++;
                    }

                    if (CombinationIndex == Simulation.TestOrder){
                        break;
                    }
                }

                Test.ProbingSet.emplace_back(Combination);
            } while (std::prev_permutation(CombinationBitmask.begin(), CombinationBitmask.end())); 
        }
    }

    std::cout << "done!" << std::endl;
}

void Hardware::GenerateProbingSets::Extend(Hardware::SimulationStruct& Simulation, Hardware::TestStruct& Test, unsigned int Start, unsigned int End){
    int GlitchIndex = 0, ProbeIndex = 0;
    size_t SetIndex = 0;

    ProbePositionStruct ExtendedProbe;
    std::vector<ProbePositionStruct>::iterator it;
    std::iterator_traits<std::vector<ProbePositionStruct>::iterator>::difference_type Index; 
    std::string ErrorMessage;

    // Sort in a way that the smallest element has the smallest index
    std::sort(Test.ExtendedProbes.begin(), Test.ExtendedProbes.end(), [](Hardware::ProbePositionStruct& lhs, Hardware::ProbePositionStruct& rhs){return lhs < rhs;});
    Test.ExtendedProbes.erase(std::unique(Test.ExtendedProbes.begin(), Test.ExtendedProbes.end(), [](Hardware::ProbePositionStruct& lhs, Hardware::ProbePositionStruct& rhs){return lhs == rhs;}), Test.ExtendedProbes.end());

    // Extend all standard probes of a probing set
    for (SetIndex = Start; SetIndex < End; SetIndex++){
        for (ProbeIndex = 0; ProbeIndex < Simulation.TestOrder; ProbeIndex++){
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
}

void Hardware::GenerateProbingSets::RemoveDuplicatedProbes(Hardware::TestStruct& Test, unsigned int Start, unsigned int End){
    unsigned int SetIndex = 0;

    // Remove all probes that occur twice
    for (SetIndex = Start; SetIndex < End; SetIndex++){
        // Sort in a way that the smallest probe index gets the smallest index in the probing set
        std::sort(Test.ProbingSet.at(SetIndex).Extension.begin(), Test.ProbingSet.at(SetIndex).Extension.end(), std::greater<unsigned int>());
        Test.ProbingSet.at(SetIndex).Extension.erase(std::unique(Test.ProbingSet.at(SetIndex).Extension.begin(), Test.ProbingSet.at(SetIndex).Extension.end()), Test.ProbingSet.at(SetIndex).Extension.end());
    }    
}

void Hardware::GenerateProbingSets::RemoveDuplicatedProbingSets(Hardware::SettingsStruct& Settings, Hardware::SimulationStruct& Simulation, Hardware::TestStruct& Test, unsigned int Start, unsigned int End){
    std::cout << "Remove duplicated probing sets..." << std::flush;
    size_t LargerIndex = 0, SmallerIndex = 0;
    
    std::sort(Test.ProbingSet.begin() + Start, Test.ProbingSet.begin() + End, [](Hardware::ProbingSetStruct& lhs, Hardware::ProbingSetStruct& rhs){return lhs > rhs;});
    
    // Remove all probing sets that occur twice
    Test.ProbingSet.erase(std::unique(Test.ProbingSet.begin() + Start, Test.ProbingSet.begin() + End, [](Hardware::ProbingSetStruct& lhs, Hardware::ProbingSetStruct& rhs){return lhs == rhs;}), Test.ProbingSet.begin() + End);
    std::cout << "done! " << Test.ProbingSet.size() << " probing sets remain!" << std::endl;

    // Remove all probing sets that are completely covered by another probing set
    if (Settings.MinimizeProbeSets){
        std::cout << "Remove subsets of probing sets..." << std::flush;

        if ((Simulation.TestMultivariate != 0) && (Simulation.NumberOfTestClockCycles > 1) && (Simulation.TestOrder != 1)){
            for (LargerIndex = Start; LargerIndex < Test.ProbingSet.size(); LargerIndex++){
                if (!Test.ProbingSet.at(LargerIndex).Traces){      
                    for (SmallerIndex = LargerIndex + 1; SmallerIndex < Test.ProbingSet.size(); SmallerIndex++){
                        if ((!Test.ProbingSet.at(SmallerIndex).Traces) && (Test.ProbingSet.at(LargerIndex).Extension.size() > Test.ProbingSet.at(SmallerIndex).Extension.size()) && (Test.ProbingSet.at(LargerIndex).Extension.back() <= Test.ProbingSet.at(SmallerIndex).Extension.back())){
                            if (std::includes(Test.ProbingSet.at(LargerIndex).Extension.begin(), Test.ProbingSet.at(LargerIndex).Extension.end(), Test.ProbingSet.at(SmallerIndex).Extension.begin(), Test.ProbingSet.at(SmallerIndex).Extension.end(), std::greater<unsigned int>())){
                                Test.ProbingSet.at(SmallerIndex).Traces |= 1;
                            }
                        }
                    } 
                }
            }   
        }else{
            // In the univariate case we only compare probing sets with the same clock cycle
            size_t Index = 0;

            if (Simulation.NumberOfTestClockCycles != 1){
                std::vector<unsigned int> StartIndices(1,0), EndIndices;

                for (LargerIndex = Start + 1; LargerIndex < Test.ProbingSet.size(); LargerIndex++){
                    if (Test.ExtendedProbes.at(Test.ProbingSet.at(LargerIndex - 1).Extension.back()).Cycle != Test.ExtendedProbes.at(Test.ProbingSet.at(LargerIndex).Extension.back()).Cycle){
                        StartIndices.push_back(LargerIndex);
                        EndIndices.push_back(LargerIndex);
                    }
                }
                EndIndices.push_back(Test.ProbingSet.size());

                #pragma omp parallel for schedule(guided)
                for (Index = 0; Index < StartIndices.size(); Index++){
                    for (LargerIndex = StartIndices.at(Index); LargerIndex < EndIndices.at(Index); LargerIndex++){
                        if (!Test.ProbingSet.at(LargerIndex).Traces){ 
                            for (SmallerIndex = LargerIndex + 1; SmallerIndex < EndIndices.at(Index); SmallerIndex++){
                                if ((Test.ProbingSet.at(LargerIndex).Extension.size() > Test.ProbingSet.at(SmallerIndex).Extension.size()) && (Test.ProbingSet.at(LargerIndex).Extension.back() <= Test.ProbingSet.at(SmallerIndex).Extension.back()) && (!Test.ProbingSet.at(SmallerIndex).Traces)){
                                    if (std::includes(Test.ProbingSet.at(LargerIndex).Extension.begin(), Test.ProbingSet.at(LargerIndex).Extension.end(), Test.ProbingSet.at(SmallerIndex).Extension.begin(), Test.ProbingSet.at(SmallerIndex).Extension.end(), std::greater<unsigned int>())){
                                        Test.ProbingSet.at(SmallerIndex).Traces |= 1;
                                    }
                                }
                            }
                        }
                    }
                }
            }else{
                std::vector<std::vector<unsigned int>> ThreadList(Settings.Max_no_of_Threads, std::vector<unsigned int>(Test.ProbingSet.size(),0));
                int ThreadIndex;

                #pragma omp parallel for schedule(guided) private(ThreadIndex)
                for (LargerIndex = 0; LargerIndex < Test.ProbingSet.size(); LargerIndex++){
                    ThreadIndex = omp_get_thread_num();

                    if (!ThreadList.at(ThreadIndex).at(LargerIndex)){ 
                        for (SmallerIndex = LargerIndex + 1; SmallerIndex < Test.ProbingSet.size(); SmallerIndex++){
                            if ((Test.ProbingSet.at(LargerIndex).Extension.size() > Test.ProbingSet.at(SmallerIndex).Extension.size()) && (Test.ProbingSet.at(LargerIndex).Extension.back() <= Test.ProbingSet.at(SmallerIndex).Extension.back()) && (!ThreadList.at(ThreadIndex).at(SmallerIndex))){
                                if (std::includes(Test.ProbingSet.at(LargerIndex).Extension.begin(), Test.ProbingSet.at(LargerIndex).Extension.end(), Test.ProbingSet.at(SmallerIndex).Extension.begin(), Test.ProbingSet.at(SmallerIndex).Extension.end(), std::greater<unsigned int>())){
                                    ThreadList.at(ThreadIndex).at(SmallerIndex) |= 1;
                                }
                            }
                        }
                    }
                }

                for (LargerIndex = 0; LargerIndex < (size_t)Settings.Max_no_of_Threads; LargerIndex++){
                    for (SmallerIndex = 0; SmallerIndex < Test.ProbingSet.size(); SmallerIndex++){
                        if (ThreadList.at(LargerIndex).at(SmallerIndex)){
                            Test.ProbingSet.at(SmallerIndex).Traces |= 1;
                        }
                    }
                }
            }
        }
        
        Test.ProbingSet.erase(std::remove_if(Test.ProbingSet.begin(), Test.ProbingSet.end(), Hardware::GenerateProbingSets::Remove), Test.ProbingSet.end());
        std::cout << "done! " << Test.ProbingSet.size() << " probing sets remain!" << std::endl;    
    }
}

bool Hardware::GenerateProbingSets::Remove(ProbingSetStruct& ProbingSet){
    return ProbingSet.Traces == 1;
}

void Hardware::GenerateProbingSets::InitializeCompactDistributions(Hardware::SettingsStruct& Settings, Hardware::SimulationStruct& Simulation, Hardware::TestStruct& Test){
    Hardware::TableEntryStruct emptyTableEntry(Simulation.NumberOfGroups);
    unsigned int          setIndex = 0, ProbeIndex = 0;
	int                   TempIndex = 0, ClockCycle;
	int**                 TempClockProbeTable = NULL;

    for (setIndex = 0; setIndex < Test.ProbingSet.size(); setIndex++){
        for (ProbeIndex = 0; ProbeIndex <= Test.ProbingSet.at(setIndex).Extension.size(); ProbeIndex++){
			Test.ProbingSet.at(setIndex).ContingencyTable.push_back(emptyTableEntry);
		}
	}

	//----------------------
    Test.TempProbeValue.resize(Settings.Max_no_of_Threads, std::vector<int>(Test.ProbingSet.size(), 0));

	//-------------------
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