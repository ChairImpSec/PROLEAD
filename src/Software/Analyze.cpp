#include "Software/Analyze.hpp"

double Software::Analyze::All(Software::SettingsStruct& Settings, std::vector<Software::SharedDataStruct>& SharedInputData,  Software::HelperStruct& Helper, std::vector<Software::ThreadSimulationStruct>& GlobalThreadSimulations){
    struct timespec begin, end;
    clock_gettime(CLOCK_REALTIME, &begin);

    double maximum_leakage = 0.0;

    if (true){
        maximum_leakage = Software::Analyze::ProbingSecurity(Settings, SharedInputData, Helper, GlobalThreadSimulations);
    }else{
        throw std::runtime_error("More models are currently not supported!");
    }

	// Stop timing of one evaluation step
	clock_gettime(CLOCK_REALTIME, &end);
    long timeInSeconds = end.tv_sec - begin.tv_sec;
    long timeInNanoseconds = end.tv_nsec - begin.tv_nsec;
    double elapsedTimePeriod = timeInSeconds + timeInNanoseconds*1e-9;
    std::cout << "Evaluation done in " << elapsedTimePeriod << " seconds!" << std::endl;
    return maximum_leakage;
}

//***************************************************************************************
double Software::Analyze::ProbingSecurity(Software::SettingsStruct& Settings,  std::vector<Software::SharedDataStruct>& SharedInputData, Software::HelperStruct& GlobalHelper, std::vector<Software::ThreadSimulationStruct>& GlobalThreadSimulations){
    double maximum_leakage = 0.0;
    uint64_t StepSimulationIndex = 0;
    uint32_t NumberOfProcessedSimulations = 0;
    struct timespec begin, end;
    std::tuple<int, int, uint32_t> LargestContingencyTableProbingSet = std::make_tuple(0,0,0); //(thread, probing set, contingency table size)
    std::tuple<int, int> MaximumProbingSet;
    std::tuple<int, int> MinimumProbingSet;
    std::vector<ProbingSetStruct>::iterator MaximumIterator;
    std::vector<boost::mt19937> ThreadRng(Settings.Max_no_of_Threads + 1);
    std::vector<::Software::TestStruct> GlobalTests(Settings.Max_no_of_Threads);    
    std::vector<std::vector<uint32_t>> ProbeInfoToStandardProbe;
    Software::Probing::ProbeInfoToStandardProbeMapping(ProbeInfoToStandardProbe, GlobalHelper, Settings);
    std::array<std::string, 6> TableRow;
    std::vector<std::tuple<uint32_t, uint32_t>> OrderOverTwoCombination;
    if(Settings.TestOrder > 1){
        Software::Operators::ComputeBinomCoeffOrderOverTwo(OrderOverTwoCombination, Settings.TestOrder);
    }
    	
    for(auto& Test: GlobalTests){
        Test.NumberOfSets.resize(Settings.NumberOfStepSimulations, 0);
        Test.ProbingSet.resize(Settings.NumberOfStepSimulations);
        Test.Combination.resize(Settings.TestOrder);
    }

    clock_gettime(CLOCK_REALTIME, &begin);

    std::cout << "Start software evaluation..." << std::endl;

    omp_set_num_threads(Settings.Max_no_of_Threads);

    Operators::GenerateThreadRng(ThreadRng, Settings.Max_no_of_Threads + 1);
    
    //generate PRNG for input generation
    boost::uniform_int<uint64_t> InputDist(0, std::numeric_limits<uint64_t>::max());
    boost::variate_generator<boost::mt19937&, boost::uniform_int<uint64_t>> InputPrng(ThreadRng.back(), InputDist);

    Software::Print::EvaluationTableHeader();

    for(StepSimulationIndex = 0; StepSimulationIndex < (Settings.NumberOfSimulations / Settings.NumberOfStepSimulations); ++StepSimulationIndex){
        //initialize inputs for i-th simulation
        Software::Simulate::GenerateInputs(SharedInputData, GlobalThreadSimulations, Settings, InputPrng);
        
        std::vector<std::tuple<uint32_t, uint32_t, double>> ProbingSetsWithHighestProbabilities; //<thread, position, probability>
        uint32_t IndexOfSmallestProbability = 0;
        
        for(uint32_t i = 0; i < (uint32_t)Settings.Max_No_ReportEntries; ++i){
            ProbingSetsWithHighestProbabilities.push_back(std::make_tuple(0,0,0.0));
        }

        std::vector<std::vector<std::vector<std::vector<uint8_t>>>> FullStepSimulationProbeValues; //required for multivariate case; contains all probed values of all #numberstepsimulations
        std::vector<std::vector<std::vector<Software::ProbesStruct>>> FullStepSimulationStandardProbes(Settings.NumberOfStepSimulations, std::vector<std::vector<Software::ProbesStruct>>(Settings.Max_no_of_Threads)); //required for multivariate case; contains all standard proes of all #numberofstepsimulations

        #pragma omp parallel for schedule(auto)
        for(uint32_t thread = 0; thread < (uint32_t)Settings.Max_no_of_Threads; ++thread){
            uint32_t Position;
            uint32_t ThreadIndex = omp_get_thread_num();
	  
            /**
             * @brief local thread instances
             * 
             */

            boost::uniform_int<uint64_t> LocalThreadDist(0, std::numeric_limits<uint64_t>::max());
            boost::variate_generator<boost::mt19937&, boost::uniform_int<uint64_t>> ThreadPrng(ThreadRng.at(ThreadIndex), LocalThreadDist);

            std::vector<mulator::Emulator> EmulatorsPerThread;
            std::vector<::Software::ProbeTrackingStruct> ProbeTracker(Settings.NumberOfStepSimulations);
            std::vector<std::vector<bool>> HighOrderUnivariateRedundancy(34, std::vector<bool>(32, false)); //17 register each 32 bit, consider transitions -> 34 registers

            std::vector<std::vector<std::vector<std::vector<uint8_t>>>> ProbeValues; //[simulation][registernumber][registerbit][clockcycle]
            ProbeValues.resize(static_cast<uint64_t>(std::ceil(Settings.NumberOfStepSimulations/8.0f)), std::vector<std::vector<std::vector<uint8_t>>>(17,std::vector<std::vector<uint8_t>>(32,std::vector<uint8_t>(GlobalThreadSimulations.at(ThreadIndex).CycleEnd.back() + 1, 0))));
            
            for(uint32_t CycleSplit = 0; CycleSplit < GlobalThreadSimulations.at(ThreadIndex).NumberOfCycleSplits; ++CycleSplit){
                for(uint32_t SimulationIndex = 0; SimulationIndex < Settings.NumberOfStepSimulations; ++SimulationIndex){
                    if(CycleSplit ==  0){
                        mulator::Emulator Emulator(Settings.arch, ThreadPrng, Settings.NumberOfPipelineStages);
                        Software::Simulate::Instantiate_Emulator(Emulator, GlobalThreadSimulations.at(ThreadIndex), SimulationIndex, Settings, SharedInputData[SimulationIndex], GlobalThreadSimulations.at(ThreadIndex).CycleStart.at(CycleSplit), ProbeTracker.at(SimulationIndex), GlobalHelper, ProbeValues.at(SimulationIndex >> 3));

                        Software::Simulate::Run(Emulator, GlobalThreadSimulations.at(ThreadIndex), Settings, ProbeTracker.at(SimulationIndex), GlobalHelper, ProbeValues.at(SimulationIndex >> 3), SimulationIndex, CycleSplit);
                        EmulatorsPerThread.emplace_back(Emulator);
                    }
                    else{
                        Software::Simulate::Run(EmulatorsPerThread.at(SimulationIndex), GlobalThreadSimulations.at(ThreadIndex), Settings, ProbeTracker.at(SimulationIndex), GlobalHelper, ProbeValues.at(SimulationIndex >> 3), SimulationIndex, CycleSplit);
                    }

                    if(!Settings.TestMultivariate){
                        Software::Probing::GetProbingSets(GlobalThreadSimulations.at(ThreadIndex), Settings, GlobalTests.at(ThreadIndex), OrderOverTwoCombination, ProbeInfoToStandardProbe, SimulationIndex);
                    }
                }
								
                if(!Settings.TestMultivariate){
                    //go over every StepSimulation
                    for (uint32_t SimulationIndex = 0; SimulationIndex < Settings.NumberOfStepSimulations; SimulationIndex++)
                    {
                        unsigned int GlobalProbingSetIndex = 0;

                            //go over ervery ProbingSet of the current Simulation
                        for (uint32_t ProbingSetIndex = 0; ProbingSetIndex < GlobalTests.at(ThreadIndex).NumberOfSets.at(SimulationIndex); ProbingSetIndex++)
                        {
                            //check if we already have a probing set that is exactly the one we currently look at and get position
                            auto it = std::lower_bound(GlobalTests.at(ThreadIndex).GlobalProbingSets.begin() + GlobalProbingSetIndex, GlobalTests.at(ThreadIndex).GlobalProbingSets.end(), GlobalTests.at(ThreadIndex).ProbingSet.at(SimulationIndex).at(ProbingSetIndex), ProbingSetCompare);
                            Position = std::distance(GlobalTests.at(ThreadIndex).GlobalProbingSets.begin(), it);

                            //if its not in GlobalProbingSets yet -> insert it, otherwise update the corresponding table entry
                            if ((it == GlobalTests.at(ThreadIndex).GlobalProbingSets.end()) || !(GlobalTests.at(ThreadIndex).GlobalProbingSets.at(Position) == GlobalTests.at(ThreadIndex).ProbingSet.at(SimulationIndex).at(ProbingSetIndex))){
                                it = GlobalTests.at(ThreadIndex).GlobalProbingSets.insert(it, std::move(GlobalTests.at(ThreadIndex).ProbingSet.at(SimulationIndex).at(ProbingSetIndex)));
                            }

                            Position = std::distance(GlobalTests.at(ThreadIndex).GlobalProbingSets.begin(), it);

                            GlobalProbingSetIndex = Position;
                            if(Settings.TestOrder == 1){
                                
                                if(Settings.CompactDistributions){
                                    Software::Test::CompactFirstOrderTableUpdate(GlobalThreadSimulations.at(ThreadIndex), SimulationIndex, GlobalTests.at(ThreadIndex).GlobalProbingSets.at(Position), GlobalTests.at(ThreadIndex).ProbingSet.at(SimulationIndex).at(ProbingSetIndex), ProbeValues.at(SimulationIndex >> 3), GlobalHelper);
                                }else{
                                    Software::Test::FirstOrderTableUpdate(GlobalThreadSimulations.at(ThreadIndex), SimulationIndex, GlobalTests.at(ThreadIndex).GlobalProbingSets.at(Position), GlobalTests.at(ThreadIndex).ProbingSet.at(SimulationIndex).at(ProbingSetIndex), ProbeValues.at(SimulationIndex >> 3), GlobalHelper);
                                }

                            }
                            else if((Settings.TestOrder > 1) && (!Settings.TestMultivariate)) //higher order univariate case
                            {
                                if(Settings.CompactDistributions){
                                    Software::Test::CompactHigherOrderUnivariateTableUpdate(GlobalThreadSimulations.at(ThreadIndex), SimulationIndex, GlobalTests.at(ThreadIndex).GlobalProbingSets.at(Position), GlobalTests.at(ThreadIndex).ProbingSet.at(SimulationIndex).at(ProbingSetIndex), ProbeValues.at(SimulationIndex >> 3), GlobalHelper, HighOrderUnivariateRedundancy, ProbeInfoToStandardProbe);
                                }
                                else{
                                    Software::Test::HigherOrderUnivariateTableUpdate(GlobalThreadSimulations.at(ThreadIndex), SimulationIndex, GlobalTests.at(ThreadIndex).GlobalProbingSets.at(Position), GlobalTests.at(ThreadIndex).ProbingSet.at(SimulationIndex).at(ProbingSetIndex), ProbeValues.at(SimulationIndex >> 3), GlobalHelper, HighOrderUnivariateRedundancy, ProbeInfoToStandardProbe);
                                }
                                for(auto &row: HighOrderUnivariateRedundancy){
                                    std::fill(row.begin(), row.end(), false);
                                }
                            } 
                        }
                    }
                    Software::Test::Test(GlobalThreadSimulations.at(ThreadIndex), GlobalTests.at(ThreadIndex));
                }

                
                for(uint32_t SimulationIndex = 0; SimulationIndex < Settings.NumberOfStepSimulations; ++SimulationIndex){

                    std::vector<Software::ProbingSetStruct>().swap(GlobalTests.at(ThreadIndex).ProbingSet.at(SimulationIndex));
                    GlobalTests.at(ThreadIndex).CombinationBitmask.clear();
                    std::fill(GlobalTests.at(ThreadIndex).NumberOfSets.begin(), GlobalTests.at(ThreadIndex).NumberOfSets.end(), 0);



                    // in multivariate case store standardprobes outside threads to build probingsets
                    if(Settings.TestMultivariate){
                        FullStepSimulationStandardProbes.at(SimulationIndex).at(ThreadIndex).insert(FullStepSimulationStandardProbes.at(SimulationIndex).at(ThreadIndex).end(), GlobalThreadSimulations.at(ThreadIndex).StandardProbesPerSimulation.at(SimulationIndex).begin(), GlobalThreadSimulations.at(ThreadIndex).StandardProbesPerSimulation.at(SimulationIndex).end()) ;
                    }
                    std::vector<Software::ProbesStruct>().swap(GlobalThreadSimulations.at(ThreadIndex).StandardProbesPerSimulation.at(SimulationIndex));
                }

            }
            
            //thread which covers last clock cycles contains all probed values -> copy this vector
            if(Settings.TestMultivariate && (ThreadIndex == (uint32_t)(Settings.Max_no_of_Threads - 1))){
                FullStepSimulationProbeValues = ProbeValues;
            }

        } //end of threads, implicit barrier of synchronization

        // cover multivariate cases
        if(Settings.TestMultivariate){
            #pragma omp parallel for schedule(auto)
            for(uint32_t thread = 0; thread < (uint32_t)Settings.Max_no_of_Threads; ++thread){
                uint32_t Position;
                uint32_t ThreadIndex = omp_get_thread_num();
                for(uint32_t SimulationIndex = 0; SimulationIndex < Settings.NumberOfStepSimulations; ++SimulationIndex){
                    //build probing sets
                    Software::Probing::GetMultivariateProbingSets(FullStepSimulationStandardProbes.at(SimulationIndex), Settings, GlobalTests.at(ThreadIndex), OrderOverTwoCombination, ProbeInfoToStandardProbe, ThreadIndex, SimulationIndex);
                }
    
                for(uint32_t SimulationIndex = 0; SimulationIndex < Settings.NumberOfStepSimulations; ++SimulationIndex){
                    unsigned int GlobalProbingSetIndex = 0;

                        // go over ervery ProbingSet of the current Simulation
                    for (uint32_t ProbingSetIndex = 0; ProbingSetIndex < GlobalTests.at(ThreadIndex).NumberOfSets.at(SimulationIndex); ProbingSetIndex++)
                    {
                        // check if we already have a probing set that is exactly the one we currently look at and get position
                        auto it = std::lower_bound(GlobalTests.at(ThreadIndex).GlobalProbingSets.begin() + GlobalProbingSetIndex, GlobalTests.at(ThreadIndex).GlobalProbingSets.end(), GlobalTests.at(ThreadIndex).ProbingSet.at(SimulationIndex).at(ProbingSetIndex), ProbingSetCompare);
                        Position = std::distance(GlobalTests.at(ThreadIndex).GlobalProbingSets.begin(), it);

                        // if its not in GlobalProbingSets yet -> insert it, otherwise update the corresponding table entry
                        if ((it == GlobalTests.at(ThreadIndex).GlobalProbingSets.end()) || !(GlobalTests.at(ThreadIndex).GlobalProbingSets.at(Position) == GlobalTests.at(ThreadIndex).ProbingSet.at(SimulationIndex).at(ProbingSetIndex))){
                            it = GlobalTests.at(ThreadIndex).GlobalProbingSets.insert(it, std::move(GlobalTests.at(ThreadIndex).ProbingSet.at(SimulationIndex).at(ProbingSetIndex)));
                        }

                        Position = std::distance(GlobalTests.at(ThreadIndex).GlobalProbingSets.begin(), it);

                        GlobalProbingSetIndex = Position;
                        if(Settings.CompactDistributions){
                            Software::Test::CompactHigherOrderMultivariateTableUpdate(GlobalThreadSimulations.at(ThreadIndex), SimulationIndex, GlobalTests.at(ThreadIndex).GlobalProbingSets.at(Position), GlobalTests.at(ThreadIndex).ProbingSet.at(SimulationIndex).at(ProbingSetIndex), FullStepSimulationProbeValues.at(SimulationIndex >> 3), GlobalHelper, ProbeInfoToStandardProbe);

                        }
                        else{
                            Software::Test::HigherOrderMultivariateTableUpdate(GlobalThreadSimulations.at(ThreadIndex), SimulationIndex, GlobalTests.at(ThreadIndex).GlobalProbingSets.at(Position), GlobalTests.at(ThreadIndex).ProbingSet.at(SimulationIndex).at(ProbingSetIndex), FullStepSimulationProbeValues.at(SimulationIndex >> 3), GlobalHelper, ProbeInfoToStandardProbe);
                        }
                    }
                }
                Software::Test::Test(GlobalThreadSimulations.at(ThreadIndex), GlobalTests.at(ThreadIndex));
            }
        }
  
        NumberOfProcessedSimulations = (StepSimulationIndex + 1) * Settings.NumberOfStepSimulations;

        //for printing: get probing set with maximum probability + list of #NumberOfProbesToPrint highest probabilities
        uint32_t GlobalProbingSetSize = 0;

        for(uint32_t thread = 0; thread < (uint32_t)Settings.Max_no_of_Threads; ++thread){
            GlobalProbingSetSize += GlobalTests.at(thread).GlobalProbingSets.size();
            for (uint64_t i = 0; i < GlobalTests.at(thread).GlobalProbingSets.size(); ++i)
            {
                if(GlobalTests.at(thread).GlobalProbingSets.at(i).contingency_table_.GetNumberOfEntries() > std::get<2>(LargestContingencyTableProbingSet)){
                    std::get<0>(LargestContingencyTableProbingSet) = thread;
                    std::get<1>(LargestContingencyTableProbingSet) = i;
                    std::get<2>(LargestContingencyTableProbingSet) = GlobalTests.at(thread).GlobalProbingSets.at(i).contingency_table_.GetNumberOfEntries();
                }
                
                // found probability which is higher than lowest probability in vector -> replace and set index to new position
                if(GlobalTests.at(thread).GlobalProbingSets.at(i).contingency_table_.GetLog10pValue() > std::get<2>(ProbingSetsWithHighestProbabilities.at(IndexOfSmallestProbability))){
                    ProbingSetsWithHighestProbabilities.at(IndexOfSmallestProbability) = std::make_tuple(thread, i,GlobalTests.at(thread).GlobalProbingSets.at(i).contingency_table_.GetLog10pValue() );

                    auto it = std::min_element(ProbingSetsWithHighestProbabilities.begin(), ProbingSetsWithHighestProbabilities.end(), [](const auto& a, const auto& b){return std::get<2>(a) < std::get<2>(b);});
                    IndexOfSmallestProbability = std::distance(ProbingSetsWithHighestProbabilities.begin(), it);
                }
            }
        }

        std::sort(ProbingSetsWithHighestProbabilities.begin(), ProbingSetsWithHighestProbabilities.end(), [](const auto& a, const auto& b){return std::get<2>(a) < std::get<2>(b);});
        std::get<0>(MinimumProbingSet) = std::get<0>(ProbingSetsWithHighestProbabilities.at(0));
        std::get<1>(MinimumProbingSet) = std::get<1>(ProbingSetsWithHighestProbabilities.at(0));

        TableRow[1] = std::to_string(Software::Probing::MemoryConsumption() / 1e6) + "GB";
        TableRow[2] = std::to_string(GlobalProbingSetSize);

        if(GlobalTests.at(std::get<0>(MinimumProbingSet)).GlobalProbingSets.empty()){ //handle cases where threads do not contain any probingsets
            //search for first GlobalTests which contains probing sets
            uint32_t i;
            uint32_t n = 0;
            for(i = 0; i < (uint32_t)Settings.Max_no_of_Threads; ++i){
                if(!GlobalTests.at(i).GlobalProbingSets.empty()){
                    n = i;
                    break;
                }
            }

            for(uint32_t j = 0; j < (uint32_t)Settings.Max_No_ReportEntries; ++j){
                if(GlobalTests.at(std::get<0>(ProbingSetsWithHighestProbabilities.at(j))).GlobalProbingSets.empty()){
                    std::get<0>(ProbingSetsWithHighestProbabilities.at(j)) = n;
                }
                
            }
        }

        std::get<0>(MaximumProbingSet) = std::get<0>(ProbingSetsWithHighestProbabilities.back());
        std::get<1>(MaximumProbingSet) = std::get<1>(ProbingSetsWithHighestProbabilities.back());

        Software::Print::SoftwareMaximumProbingSet(Settings.TestOrder, GlobalTests.at(std::get<0>(MaximumProbingSet)), std::get<1>(MaximumProbingSet), TableRow[4]);
        TableRow[5] = std::to_string(GlobalTests.at(std::get<0>(MaximumProbingSet)).GlobalProbingSets.at(std::get<1>(MaximumProbingSet)).contingency_table_.GetLog10pValue());

        if (Settings.CompactDistributions){
		    TableRow[3] = std::to_string(NumberOfProcessedSimulations);
        }else{
			TableRow[3] = std::to_string(NumberOfProcessedSimulations) + " / " + std::to_string(ComputeRequiredSampleSize(Settings.NumberOfGroups, GlobalTests.at(std::get<0>(LargestContingencyTableProbingSet)).GlobalProbingSets.at(std::get<1>(LargestContingencyTableProbingSet)).contingency_table_.GetNumberOfEntries(), Settings.BetaThreshold, Settings.EffectSize));
			}

		// Stop timing of one evaluation step
		clock_gettime(CLOCK_REALTIME, &end);
    	long timeInSeconds = end.tv_sec - begin.tv_sec;
    	long timeInNanoseconds = end.tv_nsec - begin.tv_nsec;
    	double elapsedTimePeriod = timeInSeconds + timeInNanoseconds*1e-9;
        
        // // Print results in table line
		TableRow[0] = std::to_string(elapsedTimePeriod);
        Software::Print::EvaluationTableLine(TableRow);
        
        //Print reports
        if (Settings.NumberOfStepSimulationsToWrite) {
            if ((NumberOfProcessedSimulations % Settings.NumberOfStepSimulationsToWrite) == 0){
                Software::Print::ProbeReport(GlobalThreadSimulations, Settings, GlobalTests, (NumberOfProcessedSimulations / Settings.NumberOfStepSimulationsToWrite) - 1, Settings.Max_No_ReportEntries, ProbingSetsWithHighestProbabilities, GlobalHelper, NumberOfProcessedSimulations);
            }
        }
    }

    maximum_leakage = GlobalTests.at(std::get<0>(MaximumProbingSet)).GlobalProbingSets.at(std::get<1>(MaximumProbingSet)).contingency_table_.GetLog10pValue();
    std::cout.width(96);
    std::cout.fill('-');
    std::cout << '-' << std::endl;
    std::cout.fill(' ');
    std::cout << std::endl;
    return maximum_leakage;
}
