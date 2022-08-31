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

void Hardware::Test::CompactTest(Hardware::SimulationStruct& Simulation, Hardware::TestStruct& Test){
    uint64_t     StepSimulationIndex = 0;
    int		     ThreadIndex = 0;
    size_t       SetIndex = 0;

    #pragma omp parallel for schedule(guided) private(ThreadIndex)
    for (StepSimulationIndex = 0; StepSimulationIndex < Simulation.NumberOfStepSimulations; StepSimulationIndex++){
        ThreadIndex = omp_get_thread_num();
        Hardware::Test::CompactTableUpdate(Simulation, StepSimulationIndex, Test, Test.TempProbeValue.at(ThreadIndex));
    }

    #pragma omp parallel for schedule(guided)
    for (SetIndex = 0; SetIndex < Test.ProbingSet.size(); SetIndex++){
        Hardware::Test::GTest(Simulation, Test.ProbingSet.at(SetIndex), Test.SumOverGroup);
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
        Test.ProbingSet.at(ProbeSetIndex).ContingencyTable.at(TempProbeValue.at(ProbeSetIndex)).Count.at(Simulation.SelectedGroups[SimulationIndex])++;
	}
}

void Hardware::Test::NormalTest(Hardware::SettingsStruct& Settings, Hardware::SimulationStruct& Simulation, Hardware::TestStruct& Test){
	size_t SetIndex = 0;
    int ThreadIndex;

    #pragma omp parallel for schedule(guided) private(ThreadIndex)
	for (SetIndex = 0; SetIndex < Test.ProbingSet.size(); SetIndex++){
        ThreadIndex = omp_get_thread_num();
		Hardware::Test::NormalTableUpdate(Simulation, Test, Test.ProbingSet.at(SetIndex), Test.TableEntries.at(ThreadIndex));
        Hardware::Test::GTest(Simulation, Test.ProbingSet.at(SetIndex), Test.SumOverGroup);
        Hardware::Test::Traces(Settings, Simulation, Test.ProbingSet.at(SetIndex));
    } 
}

void Hardware::Test::NormalTableUpdate(Hardware::SimulationStruct& Simulation, Hardware::TestStruct& Test, Hardware::ProbingSetStruct& ProbingSet, std::vector<Hardware::TableEntryStruct>& TableEntries){
    uint64_t SimulationIndex = 0;
    int KeySizeFull = ProbingSet.Extension.size() >> 3;
    int KeySize = KeySizeFull + 1;
    int KeyRemainder = ProbingSet.Extension.size() & 0b111;
    int BitIndex = 0, GroupIndex = 0, EntryIndex = 0, KeyIndex = 0, TempIndex = 0;
    unsigned int NewTableElements = 0;
    std::vector<std::vector<unsigned int>> NewGroupElements(Simulation.NumberOfGroups, std::vector<unsigned int>(256, 0));
    std::vector<std::vector<std::vector<int>>> RemovedElementIndices(Simulation.NumberOfGroups, std::vector<std::vector<int>>(256));
    std::vector<unsigned char> Subkey;

    for (SimulationIndex = 0; SimulationIndex < Simulation.NumberOfStepSimulations; SimulationIndex++){
	    TableEntries.at(SimulationIndex).Key.resize(KeySize, 0);
        std::fill(TableEntries.at(SimulationIndex).Key.begin(), TableEntries.at(SimulationIndex).Key.end(), 0);

        for (KeyIndex = 0; KeyIndex < KeySizeFull; KeyIndex++){
            TempIndex = KeySizeFull - KeyIndex;
            for (BitIndex = KeyIndex << 3; BitIndex < (KeyIndex + 1) << 3; BitIndex++){
                TableEntries.at(SimulationIndex).Key.at(TempIndex) <<= 1;
                TableEntries.at(SimulationIndex).Key.at(TempIndex) |= Simulation.ProbeValues[SimulationIndex][Test.GetExtendedProbe(ProbingSet, BitIndex).Cycle][Test.GetExtendedProbe(ProbingSet, BitIndex).Probe];
            }
        }

        for (BitIndex = KeySizeFull << 3; BitIndex < (KeySizeFull << 3) + KeyRemainder; BitIndex++){
            TableEntries.at(SimulationIndex).Key.at(0) <<= 1;
            TableEntries.at(SimulationIndex).Key.at(0) |= Simulation.ProbeValues[SimulationIndex][Test.GetExtendedProbe(ProbingSet, BitIndex).Cycle][Test.GetExtendedProbe(ProbingSet, BitIndex).Probe];
        }

        TableEntries.at(SimulationIndex).Count.at(0) = Simulation.SelectedGroups[SimulationIndex]; 
    }

    std::sort(TableEntries.begin(), TableEntries.end(), [](const Hardware::TableEntryStruct& lhs, const Hardware::TableEntryStruct& rhs){return lhs.Key < rhs.Key;});

    // Search if an entry exists in the list of entries that occur multiple times
    EntryIndex = ProbingSet.FindEntry(TableEntries.at(0), 0);
    
    if (EntryIndex == -1){
        // If the entry did not already occur multiple times, we check if entry occured at least once
        if (KeySize > 1){
            Subkey = {TableEntries.at(0).Key.begin(), TableEntries.at(0).Key.end() - 1};

            for (GroupIndex = 0; GroupIndex < Simulation.NumberOfGroups; GroupIndex++){
                KeyIndex = Hardware::Test::SearchKey(ProbingSet.OnlyOneEntry.at(GroupIndex).at(TableEntries.at(0).Key.back()), Subkey, 0);

                if (KeyIndex != -1){
                    // If the entry already occured once, we add it to the table and remove the other entry
                    ProbingSet.ContingencyTable.emplace_back(Simulation, TableEntries.at(0).Key, GroupIndex, TableEntries.at(0).Count.at(0));
                    NewTableElements++;
                    RemovedElementIndices.at(GroupIndex).at(TableEntries.at(0).Key.back()).push_back(KeyIndex);  
                    break;
                }
            }

            if (GroupIndex == Simulation.NumberOfGroups){
                // If the entry occurs for the first time, create a new entry
                ProbingSet.OnlyOneEntry.at(TableEntries.at(0).Count.at(0)).at(TableEntries.at(0).Key.back()).push_back(Subkey);
                NewGroupElements.at(TableEntries.at(0).Count.at(0)).at(TableEntries.at(0).Key.back())++;
            }

        }else{
            for (GroupIndex = 0; GroupIndex < Simulation.NumberOfGroups; GroupIndex++){
                if (ProbingSet.OnlyOneEntry.at(GroupIndex).at(TableEntries.at(0).Key.back()).size()){
                    // If the entry already occured once, we add it to the table and remove the other entry
                    ProbingSet.ContingencyTable.emplace_back(Simulation, TableEntries.at(0).Key, GroupIndex, TableEntries.at(0).Count.at(0));
                    NewTableElements++;
                    RemovedElementIndices.at(GroupIndex).at(TableEntries.at(0).Key.back()).push_back(0);  
                    break;
                }
            }

            if (GroupIndex == Simulation.NumberOfGroups){
                // If the entry occurs for the first time, create a new entry
                ProbingSet.OnlyOneEntry.at(TableEntries.at(0).Count.at(0)).at(TableEntries.at(0).Key.back()).push_back(TableEntries.at(0).Key);
                NewGroupElements.at(TableEntries.at(0).Count.at(0)).at(TableEntries.at(0).Key.back())++;
            }
        }
    }else{
        // If the entry already occured multiple times, we just increment the existing bin
        ProbingSet.ContingencyTable.at(EntryIndex).Count.at(TableEntries.at(0).Count.at(0))++; 
    }

    for (SimulationIndex = 1; SimulationIndex < Simulation.NumberOfStepSimulations; SimulationIndex++){ 
        Subkey = {TableEntries.at(SimulationIndex).Key.begin(), TableEntries.at(SimulationIndex).Key.end() - 1};

        if (ProbingSet.ContingencyTable.size() && TableEntries.at(SimulationIndex).Key == ProbingSet.ContingencyTable.back().Key){
            // Increment the existing entry
            ProbingSet.ContingencyTable.back().Count.at(TableEntries.at(SimulationIndex).Count.at(0))++;  
        }else{
            for (GroupIndex = 0; GroupIndex < Simulation.NumberOfGroups; GroupIndex++){
                if (ProbingSet.OnlyOneEntry.at(GroupIndex).at(TableEntries.at(SimulationIndex).Key.back()).size() && Subkey == ProbingSet.OnlyOneEntry.at(GroupIndex).at(TableEntries.at(SimulationIndex).Key.back()).back()){
                    // Add the entry to the table and clear the entry in the group table
                    ProbingSet.ContingencyTable.emplace_back(Simulation, TableEntries.at(SimulationIndex).Key, GroupIndex, TableEntries.at(SimulationIndex).Count.at(0));
                    NewTableElements++;
                    RemovedElementIndices.at(GroupIndex).at(TableEntries.at(SimulationIndex).Key.back()).push_back(ProbingSet.OnlyOneEntry.at(GroupIndex).at(TableEntries.at(SimulationIndex).Key.back()).size() - 1);  
                    break;
                }
            }

            if (GroupIndex == Simulation.NumberOfGroups){
                // Search if an entry exists in the list of entries that occur multiple times
                EntryIndex = ProbingSet.FindEntry(TableEntries.at(SimulationIndex), NewTableElements);
                
                if (EntryIndex == -1){
                    if (KeySize > 1){
                        // If the entry did not already occur multiple times, we check if entry occured at least once
                        for (GroupIndex = 0; GroupIndex < Simulation.NumberOfGroups; GroupIndex++){
                            KeyIndex = Hardware::Test::SearchKey(ProbingSet.OnlyOneEntry.at(GroupIndex).at(TableEntries.at(SimulationIndex).Key.back()), Subkey, NewGroupElements.at(GroupIndex).at(TableEntries.at(SimulationIndex).Key.back()));

                            if (KeyIndex != -1){
                                // If the entry already occured once, we add it to the table and remove the other entry
                                ProbingSet.ContingencyTable.emplace_back(Simulation, TableEntries.at(SimulationIndex).Key, GroupIndex, TableEntries.at(SimulationIndex).Count.at(0));                    
                                NewTableElements++;
                                RemovedElementIndices.at(GroupIndex).at(TableEntries.at(SimulationIndex).Key.back()).push_back(KeyIndex);     
                                break;
                            }                    
                        }    

                        if (GroupIndex == Simulation.NumberOfGroups){
                            // If the entry occurs for the first time, create a new entry
                            ProbingSet.OnlyOneEntry.at(TableEntries.at(SimulationIndex).Count.at(0)).at(TableEntries.at(SimulationIndex).Key.back()).push_back(Subkey);
                            NewGroupElements.at(TableEntries.at(SimulationIndex).Count.at(0)).at(TableEntries.at(SimulationIndex).Key.back())++;
                        } 
                    }else{
                        // If the entry did not already occur multiple times, we check if entry occured at least once
                        for (GroupIndex = 0; GroupIndex < Simulation.NumberOfGroups; GroupIndex++){
                            if (ProbingSet.OnlyOneEntry.at(GroupIndex).at(TableEntries.at(SimulationIndex).Key.back()).size()){
                                // If the entry already occured once, we add it to the table and remove the other entry
                                ProbingSet.ContingencyTable.emplace_back(Simulation, TableEntries.at(SimulationIndex).Key, GroupIndex, TableEntries.at(SimulationIndex).Count.at(0));
                                NewTableElements++;
                                RemovedElementIndices.at(GroupIndex).at(TableEntries.at(SimulationIndex).Key.back()).push_back(0);     
                                break;
                            }                    
                        }    

                        if (GroupIndex == Simulation.NumberOfGroups){
                            // If the entry occurs for the first time, create a new entry
                            ProbingSet.OnlyOneEntry.at(TableEntries.at(SimulationIndex).Count.at(0)).at(TableEntries.at(SimulationIndex).Key.back()).push_back(TableEntries.at(SimulationIndex).Key);
                            NewGroupElements.at(TableEntries.at(SimulationIndex).Count.at(0)).at(TableEntries.at(SimulationIndex).Key.back())++;
                        }                         
                    }      
                }else{
                    // If the entry already occured multiple times, we just increment the existing bin
                    ProbingSet.ContingencyTable.at(EntryIndex).Count.at(TableEntries.at(SimulationIndex).Count.at(0))++; 
                }
            }  
        }
    }

    for (GroupIndex = 0; GroupIndex < Simulation.NumberOfGroups; GroupIndex++){
        for (BitIndex = 0; BitIndex < 256; BitIndex++){
            for (EntryIndex = 0; EntryIndex < (int)RemovedElementIndices.at(GroupIndex).at(BitIndex).size(); EntryIndex++){
                ProbingSet.OnlyOneEntry.at(GroupIndex).at(BitIndex).at(RemovedElementIndices.at(GroupIndex).at(BitIndex).at(EntryIndex)).clear();
            }
        
            std::sort(ProbingSet.OnlyOneEntry.at(GroupIndex).at(BitIndex).begin(), ProbingSet.OnlyOneEntry.at(GroupIndex).at(BitIndex).end(), [](const std::vector<unsigned char>& lhs, const std::vector<unsigned char>& rhs){return lhs < rhs;});
            ProbingSet.OnlyOneEntry.at(GroupIndex).at(BitIndex).erase(std::remove_if(ProbingSet.OnlyOneEntry.at(GroupIndex).at(BitIndex).begin(), ProbingSet.OnlyOneEntry.at(GroupIndex).at(BitIndex).end(), [](const std::vector<unsigned char>& x){return (x.size() == 0);}), ProbingSet.OnlyOneEntry.at(GroupIndex).at(BitIndex).end());
        }
    }

    std::sort(ProbingSet.ContingencyTable.begin(), ProbingSet.ContingencyTable.end(), [](const Hardware::TableEntryStruct& lhs, const Hardware::TableEntryStruct& rhs){return lhs.Key < rhs.Key;});
}

int Hardware::Test::SearchKey(std::vector<std::vector<unsigned char>>& Table, std::vector<unsigned char>& Entry, unsigned int IgnoredEntries){ 
    std::vector<std::vector<unsigned char>>::iterator it = std::lower_bound(Table.begin(), Table.end() - IgnoredEntries, Entry, [](const std::vector<unsigned char>& lhs, const std::vector<unsigned char>& rhs){return lhs < rhs;});
    std::iterator_traits<std::vector<std::vector<unsigned char>>::iterator>::difference_type Position = std::distance(Table.begin(), it); 
    
    if ((it == Table.end()) || (Table.at(Position) != Entry)){
        return -1;
    }else{
        return (int)Position;
    }
}

void Hardware::Test::GTest(Hardware::SimulationStruct& Simulation, Hardware::ProbingSetStruct& ProbingSet, std::vector<double> Frequency){
    size_t GroupIndex = 0;
    unsigned int Df = 0; 
    unsigned int TableSize = ProbingSet.ContingencyTable.size();

    for (GroupIndex = 0; GroupIndex < ProbingSet.OnlyOneEntry.size(); GroupIndex++){
        TableSize += ProbingSet.OnlyOneEntry.at(GroupIndex).size();
    }

    if (Simulation.NumberOfGroups != 1 && TableSize != 1){
        double gValue = Hardware::Test::GetGValue(Simulation, ProbingSet, Frequency, TableSize, Df);

        if (Df){
            boost::math::chi_squared_distribution<> Distribution(Df);
            ProbingSet.Probability = (-1.0) * log2(boost::math::cdf(boost::math::complement(Distribution, gValue))) / log2(10.0);
        }else{
            ProbingSet.Probability = 0.0;
        }
    }else{
        ProbingSet.Probability = 0.0;
    }
}

double Hardware::Test::GetGValue(Hardware::SimulationStruct& Simulation, Hardware::ProbingSetStruct& ProbingSet, std::vector<double> Frequency, unsigned int TableSize, unsigned int& Df){
    unsigned int SumOverBin = 0, BinIndex = 0, BitIndex = 0, SanitisedTableSize = 0;
    int          GroupIndex = 0, GroupIndex2 = 0;
    double       gValue = 0.0, portion = 0.0, product = 0.0;
    std::vector<double> ExpectedFrequency(Simulation.NumberOfGroups, 0.0);
    std::vector<unsigned int> PooledCount(Simulation.NumberOfGroups, 0);
    bool Valid = true;
    Df = 0;

    double PoolingFactor = (double)Simulation.NumberOfProcessedSimulations / TableSize;

    std::transform(Frequency.begin(), Frequency.end(), Frequency.begin(), [Simulation](double x){return x / Simulation.NumberOfProcessedSimulations;});

    for (BinIndex = 0; BinIndex < ProbingSet.ContingencyTable.size(); BinIndex++){
        SumOverBin = std::accumulate(ProbingSet.ContingencyTable.at(BinIndex).Count.begin(), ProbingSet.ContingencyTable.at(BinIndex).Count.end(), 0);

        Valid = true;
        for (GroupIndex = 0; GroupIndex < Simulation.NumberOfGroups; GroupIndex++){
            ExpectedFrequency.at(GroupIndex) = Frequency.at(GroupIndex) * SumOverBin;

            if ((ExpectedFrequency.at(GroupIndex) < 5.0) || ((ExpectedFrequency.at(GroupIndex) < 5.0 * PoolingFactor) && ExpectedFrequency.at(GroupIndex) < 20.0)){
                Valid = false;
            }
        }

        if (Valid){
            for (GroupIndex = 0; GroupIndex < Simulation.NumberOfGroups; GroupIndex++){
                if (ProbingSet.ContingencyTable.at(BinIndex).Count.at(GroupIndex)){
                    portion = ProbingSet.ContingencyTable.at(BinIndex).Count.at(GroupIndex) / ExpectedFrequency.at(GroupIndex);
                    product = ProbingSet.ContingencyTable.at(BinIndex).Count.at(GroupIndex) * std::log(portion);
                    gValue += product;
                }          
            }

            SanitisedTableSize++;
        }else{
            for (GroupIndex = 0; GroupIndex < Simulation.NumberOfGroups; GroupIndex++){
                PooledCount.at(GroupIndex) += ProbingSet.ContingencyTable.at(BinIndex).Count.at(GroupIndex); 
            }
        }
    }

    for (GroupIndex = 0; GroupIndex < (int)ProbingSet.OnlyOneEntry.size(); GroupIndex++){
        for (BitIndex = 0; BitIndex < 256; BitIndex++){
            for (BinIndex = 0; BinIndex < ProbingSet.OnlyOneEntry.at(GroupIndex).at(BitIndex).size(); BinIndex++){
                SumOverBin = 1;

                Valid = true;
                for (GroupIndex2 = 0; GroupIndex2 < Simulation.NumberOfGroups; GroupIndex2++){
                    ExpectedFrequency.at(GroupIndex2) = Frequency.at(GroupIndex2) * SumOverBin;

                    if ((ExpectedFrequency.at(GroupIndex2) < 5.0) || ((ExpectedFrequency.at(GroupIndex2) < 5.0 * PoolingFactor) && ExpectedFrequency.at(GroupIndex2) < 20.0)){
                        Valid = false;
                    }
                }

                if (Valid){
                    for (GroupIndex2 = 0; GroupIndex2 < Simulation.NumberOfGroups; GroupIndex2++){
                        portion = 1.0 / ExpectedFrequency.at(GroupIndex);
                        product = std::log(portion);
                        gValue += product;        
                    }

                    SanitisedTableSize++;
                }else{
                    PooledCount.at(GroupIndex) += 1; 
                }
            }
        }
    }

    SumOverBin = std::accumulate(PooledCount.begin(), PooledCount.end(), 0);

    if (SumOverBin){
        for (GroupIndex = 0; GroupIndex < Simulation.NumberOfGroups; GroupIndex++){
            ExpectedFrequency.at(GroupIndex) = Frequency.at(GroupIndex) * SumOverBin;

            if (PooledCount.at(GroupIndex)){
                portion = PooledCount.at(GroupIndex) / ExpectedFrequency.at(GroupIndex);
                product = PooledCount.at(GroupIndex) * std::log(portion);
                gValue += product;
            }  
        }    

        SanitisedTableSize++;
    }

    gValue *= 2;
    Df = (Simulation.NumberOfGroups - 1) * (SanitisedTableSize - 1);

    if (gValue < 0.0){
        gValue = 0.0;
    }    

    return gValue;
}

void Hardware::Test::Traces(Hardware::SettingsStruct& Settings, Hardware::SimulationStruct& Simulation, Hardware::ProbingSetStruct& ProbingSet){
    bool TooSmall = true;
    int GroupIndex, BitIndex;
    unsigned int Factor = 1;
    unsigned int TableSize = ProbingSet.ContingencyTable.size();
    double NoncentralityParameter, Beta;

    ProbingSet.Traces = 1;

    for (GroupIndex = 0; GroupIndex < Simulation.NumberOfGroups; GroupIndex++){
        for (BitIndex = 0; BitIndex < 256; BitIndex++){
            TableSize += ProbingSet.OnlyOneEntry.at(GroupIndex).at(BitIndex).size();
        }
    }

    if (TableSize > 1){
        // Compute degree of freedom
        unsigned int Df = (Simulation.NumberOfGroups - 1) * (TableSize - 1); 

        // Compute critical g value
        boost::math::chi_squared_distribution<> Distribution1(Df);
        double CriticalValue = boost::math::quantile(boost::math::complement(Distribution1, Settings.BetaThreshold));

        while (true){
            // Get non-centrality parameter
            NoncentralityParameter = Settings.EffectSize * Settings.EffectSize * ProbingSet.Traces;

            // Get type II error rate
            boost::math::non_central_chi_squared_distribution<> Distribution2(Df, NoncentralityParameter);
            Beta = boost::math::cdf(Distribution2, CriticalValue);

            if (Beta > Settings.BetaThreshold){
                if (TooSmall){
                    ProbingSet.Traces += Factor;
                    Factor <<= 1;
                }else{
                    if (Factor == 1){
                        break;
                    }else{
                        TooSmall = true;
                        Factor = 1;
                        ProbingSet.Traces += Factor;
                    }
                }
            }else{
                if (!TooSmall){
                    ProbingSet.Traces -= Factor;
                    Factor <<= 1;
                }else{
                    if (Factor == 1){
                        break;
                    }else{
                        TooSmall = false;
                        Factor = 1;
                        ProbingSet.Traces -= Factor;
                    }
                }
            }
        }
    }
}