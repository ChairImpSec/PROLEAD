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
        Util::GTest(Simulation.NumberOfGroups, Simulation.NumberOfProcessedSimulations, Test.ProbingSet.at(SetIndex).ContingencyTable, Test.SumOverGroup);
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
        Test.ProbingSet.at(ProbeSetIndex).ContingencyTable.Entries.at(TempProbeValue.at(ProbeSetIndex)).Count.at(Simulation.SelectedGroups[SimulationIndex])++;
	}
}

void Hardware::Test::NormalTest(Hardware::SettingsStruct& Settings, Hardware::SimulationStruct& Simulation, Hardware::TestStruct& Test){
	size_t SetIndex = 0;
    int ThreadIndex;

    #pragma omp parallel for schedule(guided) private(ThreadIndex)
	for (SetIndex = 0; SetIndex < Test.ProbingSet.size(); SetIndex++){
        ThreadIndex = omp_get_thread_num();
		Hardware::Test::NormalTableUpdate(Simulation, Test, Test.ProbingSet.at(SetIndex), Test.TableEntries.at(ThreadIndex));
        Util::GTest(Simulation.NumberOfGroups, Simulation.NumberOfProcessedSimulations, Test.ProbingSet.at(SetIndex).ContingencyTable, Test.SumOverGroup);
        Test.ProbingSet.at(SetIndex).ContingencyTable.CalculateTraces(Settings.NumberOfGroups, Settings.BetaThreshold, Settings.EffectSize);
    } 
}

void Hardware::Test::NormalTableUpdate(Hardware::SimulationStruct& Simulation, Hardware::TestStruct& Test, Hardware::ProbingSetStruct& ProbingSet, std::vector<Util::TableEntryStruct>& TableEntries){
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

    std::sort(TableEntries.begin(), TableEntries.end(), [](const Util::TableEntryStruct& lhs, const Util::TableEntryStruct& rhs){return lhs.Key < rhs.Key;});

    // Search if an entry exists in the list of entries that occur multiple times
    EntryIndex = ProbingSet.FindEntry(TableEntries.at(0), 0);
    
    if (EntryIndex == -1){
        // If the entry did not already occur multiple times, we check if entry occured at least once
        if (KeySize > 1){
            Subkey = {TableEntries.at(0).Key.begin(), TableEntries.at(0).Key.end() - 1};

            for (GroupIndex = 0; GroupIndex < Simulation.NumberOfGroups; GroupIndex++){
                KeyIndex = Hardware::Test::SearchKey(ProbingSet.ContingencyTable.OnlyOneEntry.at(GroupIndex).at(TableEntries.at(0).Key.back()), Subkey, 0);

                if (KeyIndex != -1){
                    // If the entry already occured once, we add it to the table and remove the other entry
                    ProbingSet.ContingencyTable.Entries.emplace_back(Simulation.NumberOfGroups, TableEntries.at(0).Key, GroupIndex, TableEntries.at(0).Count.at(0));
                    NewTableElements++;
                    RemovedElementIndices.at(GroupIndex).at(TableEntries.at(0).Key.back()).push_back(KeyIndex);  
                    break;
                }
            }

            if (GroupIndex == Simulation.NumberOfGroups){
                // If the entry occurs for the first time, create a new entry
                ProbingSet.ContingencyTable.OnlyOneEntry.at(TableEntries.at(0).Count.at(0)).at(TableEntries.at(0).Key.back()).push_back(Subkey);
                NewGroupElements.at(TableEntries.at(0).Count.at(0)).at(TableEntries.at(0).Key.back())++;
            }

        }else{
            for (GroupIndex = 0; GroupIndex < Simulation.NumberOfGroups; GroupIndex++){
                if (ProbingSet.ContingencyTable.OnlyOneEntry.at(GroupIndex).at(TableEntries.at(0).Key.back()).size()){
                    // If the entry already occured once, we add it to the table and remove the other entry
                    ProbingSet.ContingencyTable.Entries.emplace_back(Simulation.NumberOfGroups, TableEntries.at(0).Key, GroupIndex, TableEntries.at(0).Count.at(0));
                    NewTableElements++;
                    RemovedElementIndices.at(GroupIndex).at(TableEntries.at(0).Key.back()).push_back(0);  
                    break;
                }
            }

            if (GroupIndex == Simulation.NumberOfGroups){
                // If the entry occurs for the first time, create a new entry
                ProbingSet.ContingencyTable.OnlyOneEntry.at(TableEntries.at(0).Count.at(0)).at(TableEntries.at(0).Key.back()).push_back(TableEntries.at(0).Key);
                NewGroupElements.at(TableEntries.at(0).Count.at(0)).at(TableEntries.at(0).Key.back())++;
            }
        }
    }else{
        // If the entry already occured multiple times, we just increment the existing bin
        ProbingSet.ContingencyTable.Entries.at(EntryIndex).Count.at(TableEntries.at(0).Count.at(0))++; 
    }

    for (SimulationIndex = 1; SimulationIndex < Simulation.NumberOfStepSimulations; SimulationIndex++){ 
        Subkey = {TableEntries.at(SimulationIndex).Key.begin(), TableEntries.at(SimulationIndex).Key.end() - 1};

        if (ProbingSet.ContingencyTable.Entries.size() && TableEntries.at(SimulationIndex).Key == ProbingSet.ContingencyTable.Entries.back().Key){
            // Increment the existing entry
            ProbingSet.ContingencyTable.Entries.back().Count.at(TableEntries.at(SimulationIndex).Count.at(0))++;  
        }else{
            for (GroupIndex = 0; GroupIndex < Simulation.NumberOfGroups; GroupIndex++){
                if (ProbingSet.ContingencyTable.OnlyOneEntry.at(GroupIndex).at(TableEntries.at(SimulationIndex).Key.back()).size() && Subkey == ProbingSet.ContingencyTable.OnlyOneEntry.at(GroupIndex).at(TableEntries.at(SimulationIndex).Key.back()).back()){
                    // Add the entry to the table and clear the entry in the group table
                    ProbingSet.ContingencyTable.Entries.emplace_back(Simulation.NumberOfGroups, TableEntries.at(SimulationIndex).Key, GroupIndex, TableEntries.at(SimulationIndex).Count.at(0));
                    NewTableElements++;
                    RemovedElementIndices.at(GroupIndex).at(TableEntries.at(SimulationIndex).Key.back()).push_back(ProbingSet.ContingencyTable.OnlyOneEntry.at(GroupIndex).at(TableEntries.at(SimulationIndex).Key.back()).size() - 1);  
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
                            KeyIndex = Hardware::Test::SearchKey(ProbingSet.ContingencyTable.OnlyOneEntry.at(GroupIndex).at(TableEntries.at(SimulationIndex).Key.back()), Subkey, NewGroupElements.at(GroupIndex).at(TableEntries.at(SimulationIndex).Key.back()));

                            if (KeyIndex != -1){
                                // If the entry already occured once, we add it to the table and remove the other entry
                                ProbingSet.ContingencyTable.Entries.emplace_back(Simulation.NumberOfGroups, TableEntries.at(SimulationIndex).Key, GroupIndex, TableEntries.at(SimulationIndex).Count.at(0));                    
                                NewTableElements++;
                                RemovedElementIndices.at(GroupIndex).at(TableEntries.at(SimulationIndex).Key.back()).push_back(KeyIndex);     
                                break;
                            }                    
                        }    

                        if (GroupIndex == Simulation.NumberOfGroups){
                            // If the entry occurs for the first time, create a new entry
                            ProbingSet.ContingencyTable.OnlyOneEntry.at(TableEntries.at(SimulationIndex).Count.at(0)).at(TableEntries.at(SimulationIndex).Key.back()).push_back(Subkey);
                            NewGroupElements.at(TableEntries.at(SimulationIndex).Count.at(0)).at(TableEntries.at(SimulationIndex).Key.back())++;
                        } 
                    }else{
                        // If the entry did not already occur multiple times, we check if entry occured at least once
                        for (GroupIndex = 0; GroupIndex < Simulation.NumberOfGroups; GroupIndex++){
                            if (ProbingSet.ContingencyTable.OnlyOneEntry.at(GroupIndex).at(TableEntries.at(SimulationIndex).Key.back()).size()){
                                // If the entry already occured once, we add it to the table and remove the other entry
                                ProbingSet.ContingencyTable.Entries.emplace_back(Simulation.NumberOfGroups, TableEntries.at(SimulationIndex).Key, GroupIndex, TableEntries.at(SimulationIndex).Count.at(0));
                                NewTableElements++;
                                RemovedElementIndices.at(GroupIndex).at(TableEntries.at(SimulationIndex).Key.back()).push_back(0);     
                                break;
                            }                    
                        }    

                        if (GroupIndex == Simulation.NumberOfGroups){
                            // If the entry occurs for the first time, create a new entry
                            ProbingSet.ContingencyTable.OnlyOneEntry.at(TableEntries.at(SimulationIndex).Count.at(0)).at(TableEntries.at(SimulationIndex).Key.back()).push_back(TableEntries.at(SimulationIndex).Key);
                            NewGroupElements.at(TableEntries.at(SimulationIndex).Count.at(0)).at(TableEntries.at(SimulationIndex).Key.back())++;
                        }                         
                    }      
                }else{
                    // If the entry already occured multiple times, we just increment the existing bin
                    ProbingSet.ContingencyTable.Entries.at(EntryIndex).Count.at(TableEntries.at(SimulationIndex).Count.at(0))++; 
                }
            }  
        }
    }

    for (GroupIndex = 0; GroupIndex < Simulation.NumberOfGroups; GroupIndex++){
        for (BitIndex = 0; BitIndex < 256; BitIndex++){
            for (EntryIndex = 0; EntryIndex < (int)RemovedElementIndices.at(GroupIndex).at(BitIndex).size(); EntryIndex++){
                ProbingSet.ContingencyTable.OnlyOneEntry.at(GroupIndex).at(BitIndex).at(RemovedElementIndices.at(GroupIndex).at(BitIndex).at(EntryIndex)).clear();
            }
        
            std::sort(ProbingSet.ContingencyTable.OnlyOneEntry.at(GroupIndex).at(BitIndex).begin(), ProbingSet.ContingencyTable.OnlyOneEntry.at(GroupIndex).at(BitIndex).end(), [](const std::vector<unsigned char>& lhs, const std::vector<unsigned char>& rhs){return lhs < rhs;});
            ProbingSet.ContingencyTable.OnlyOneEntry.at(GroupIndex).at(BitIndex).erase(std::remove_if(ProbingSet.ContingencyTable.OnlyOneEntry.at(GroupIndex).at(BitIndex).begin(), ProbingSet.ContingencyTable.OnlyOneEntry.at(GroupIndex).at(BitIndex).end(), [](const std::vector<unsigned char>& x){return (x.size() == 0);}), ProbingSet.ContingencyTable.OnlyOneEntry.at(GroupIndex).at(BitIndex).end());
        }
    }

    std::sort(ProbingSet.ContingencyTable.Entries.begin(), ProbingSet.ContingencyTable.Entries.end(), [](const Util::TableEntryStruct& lhs, const Util::TableEntryStruct& rhs){return lhs.Key < rhs.Key;});
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