#include "Hardware/Analyze.hpp"

void Hardware::Analyze::All(Hardware::LibraryStruct& Library, Hardware::CircuitStruct& Circuit, Hardware::SettingsStruct& Settings, Hardware::SharedDataStruct* SharedData, Hardware::SimulationStruct& Simulation, Hardware::TestStruct& Test){
    struct timespec StartTime;
    Util::StartClock(StartTime);

    if (true){
        Hardware::Analyze::RobustProbingSecurity(Library, Circuit, Settings, SharedData, Simulation, Test);
    }else{
        throw std::runtime_error("More models are currently not supported!");
    }

    std::cout << "Evaluation done in " << Util::EndClock(StartTime) << " seconds!" << std::endl;
}

void Hardware::Analyze::RobustProbingSecurity(Hardware::LibraryStruct& Library, Hardware::CircuitStruct& Circuit, Hardware::SettingsStruct& Settings, Hardware::SharedDataStruct* SharedData, Hardware::SimulationStruct& Simulation, Hardware::TestStruct& Test){
    struct timespec StartTime;
    Util::StartClock(StartTime);

    // We generate a global list of all standard and extended probes.
    // Afterwards, we can store the probe index in the probing sets.
    // This procedure is more memory efficient than storing the full probe in the probing set.
    Hardware::GenerateProbingSets::GenerateProbes(Simulation, Test);

    if ((Simulation.TestMultivariate != 0) && (Simulation.NumberOfTestClockCycles > 1) && (Simulation.TestOrder != 1)){
        Hardware::Analyze::MultivariateRobustProbingSecurity(Library, Circuit, Settings, SharedData, Simulation, Test, StartTime);
    }else{
        Hardware::Analyze::UnivariateRobustProbingSecurity(Library, Circuit, Settings, SharedData, Simulation, Test, StartTime);
    }
}

void Hardware::Analyze::MultivariateRobustProbingSecurity(Hardware::LibraryStruct& Library, Hardware::CircuitStruct& Circuit, Hardware::SettingsStruct& Settings, Hardware::SharedDataStruct* SharedData, Hardware::SimulationStruct& Simulation, Hardware::TestStruct& Test, timespec& StartTime){
    int CombinationIndex = 0;
    size_t ProbeIndex = 0;
    unsigned int ProbeStepIndex = 0;
    std::vector<unsigned int> Combination;
    std::vector<bool> CombinationBitmask(Test.StandardProbes.size(), false);
    Hardware::TestStruct EmptyTest(Simulation);// = Test;

    EmptyTest.ExtendedProbes = Test.ExtendedProbes;
    EmptyTest.NumberOfUniqueProbes = Test.NumberOfUniqueProbes;
    EmptyTest.StandardProbes = Test.StandardProbes;
    EmptyTest.SumOverGroup = Test.SumOverGroup;
    EmptyTest.TempProbeValue = Test.TempProbeValue;
    EmptyTest.UniqueProbe = Test.UniqueProbe;

    std::cout << "Generate multivariate probing sets..." << std::flush;
    Hardware::GenerateProbingSets::InitializeMultivariateProbeCombinations(Simulation, Test, Combination, CombinationBitmask);

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

            if (Test.ProbingSet.size() == (size_t)Settings.ProbeStepSize){
                std::cout << "done! " << Test.ProbingSet.size() << " probing sets generated!" << std::endl;
                Hardware::Analyze::RobustProbingSecurityForSomeProbingSets(Library, Circuit, Settings, SharedData, Simulation, Test, StartTime, ProbeStepIndex);
                //Test = EmptyTest;

                Test.ProbingSet.clear();
                Test.ExtendedProbes = EmptyTest.ExtendedProbes;
                Test.NumberOfUniqueProbes = EmptyTest.NumberOfUniqueProbes;
                Test.StandardProbes = EmptyTest.StandardProbes;
                Test.SumOverGroup = EmptyTest.SumOverGroup;
                Test.TempProbeValue = EmptyTest.TempProbeValue;
                Test.UniqueProbe = EmptyTest.UniqueProbe;
            }
        }
    } while (std::prev_permutation(CombinationBitmask.begin(), CombinationBitmask.end()));   

    if (Test.ProbingSet.size()){
        std::cout << "done (last step)! " << Test.ProbingSet.size() << " probing sets generated!" << std::endl;
        Hardware::Analyze::RobustProbingSecurityForSomeProbingSets(Library, Circuit, Settings, SharedData, Simulation, Test, StartTime, ProbeStepIndex);
        //Test = EmptyTest;

        Test.ProbingSet.clear();
        Test.ExtendedProbes = EmptyTest.ExtendedProbes;
        Test.NumberOfUniqueProbes = EmptyTest.NumberOfUniqueProbes;
        Test.StandardProbes = EmptyTest.StandardProbes;
        Test.SumOverGroup = EmptyTest.SumOverGroup;
        Test.TempProbeValue = EmptyTest.TempProbeValue;
        Test.UniqueProbe = EmptyTest.UniqueProbe;
    }
}

void Hardware::Analyze::UnivariateRobustProbingSecurity(Hardware::LibraryStruct& Library, Hardware::CircuitStruct& Circuit, Hardware::SettingsStruct& Settings, Hardware::SharedDataStruct* SharedData, Hardware::SimulationStruct& Simulation, Hardware::TestStruct& Test, timespec& StartTime){
	int CycleIndex = 0;
    size_t CombinationIndex = 0, ProbeIndex = 0;
    unsigned int ProbeStepIndex = 0;
    std::vector<unsigned int> Combination;
    std::vector<bool> CombinationBitmask(Simulation.NumberOfProbes, false);
    Hardware::TestStruct EmptyTest(Simulation);// = Test;

    EmptyTest.ExtendedProbes = Test.ExtendedProbes;
    EmptyTest.NumberOfUniqueProbes = Test.NumberOfUniqueProbes;
    EmptyTest.StandardProbes = Test.StandardProbes;
    EmptyTest.SumOverGroup = Test.SumOverGroup;
    EmptyTest.TempProbeValue = Test.TempProbeValue;
    EmptyTest.UniqueProbe = Test.UniqueProbe;

    std::cout << "Generate univariate probing sets..." << std::flush;
    for (CycleIndex = 0; CycleIndex < Simulation.NumberOfTestClockCycles; CycleIndex++){
        Hardware::GenerateProbingSets::InitializeUnivariateProbeCombinations(Simulation, Combination, CombinationBitmask);

        do{
            CombinationIndex = 0;
                    
            for (ProbeIndex = 0; ProbeIndex < (size_t)Simulation.NumberOfProbes; ProbeIndex++){
                if (CombinationBitmask.at(ProbeIndex)){
                    Combination.at(CombinationIndex) = CycleIndex * Simulation.NumberOfProbes + ProbeIndex;
                    CombinationIndex++;
                }

                if (CombinationIndex == Combination.size()){
                    break;
                }
            }

            Test.ProbingSet.emplace_back(Combination);

            if (Test.ProbingSet.size() == (size_t)Settings.ProbeStepSize){
                std::cout << "done! " << Test.ProbingSet.size() << " probing sets generated!" << std::endl;
                Hardware::Analyze::RobustProbingSecurityForSomeProbingSets(Library, Circuit, Settings, SharedData, Simulation, Test, StartTime, ProbeStepIndex);
                //Test = EmptyTest;

                Test.ProbingSet.clear();
                Test.ExtendedProbes = EmptyTest.ExtendedProbes;
                Test.NumberOfUniqueProbes = EmptyTest.NumberOfUniqueProbes;
                Test.StandardProbes = EmptyTest.StandardProbes;
                Test.SumOverGroup = EmptyTest.SumOverGroup;
                Test.TempProbeValue = EmptyTest.TempProbeValue;
                Test.UniqueProbe = EmptyTest.UniqueProbe;                
            }

        } while (std::prev_permutation(CombinationBitmask.begin(), CombinationBitmask.end())); 
    }

    if (Test.ProbingSet.size()){
        std::cout << "done (last step)! " << Test.ProbingSet.size() << " probing sets generated!" << std::endl;
        Hardware::Analyze::RobustProbingSecurityForSomeProbingSets(Library, Circuit, Settings, SharedData, Simulation, Test, StartTime, ProbeStepIndex);
        //Test = EmptyTest;

        Test.ProbingSet.clear();
        Test.ExtendedProbes = EmptyTest.ExtendedProbes;
        Test.NumberOfUniqueProbes = EmptyTest.NumberOfUniqueProbes;
        Test.StandardProbes = EmptyTest.StandardProbes;
        Test.SumOverGroup = EmptyTest.SumOverGroup;
        Test.TempProbeValue = EmptyTest.TempProbeValue;
        Test.UniqueProbe = EmptyTest.UniqueProbe;        
    }
}

void Hardware::Analyze::RobustProbingSecurityForSomeProbingSets(Hardware::LibraryStruct& Library, Hardware::CircuitStruct& Circuit, Hardware::SettingsStruct& Settings, Hardware::SharedDataStruct* SharedData, Hardware::SimulationStruct& Simulation, Hardware::TestStruct& Test, timespec& StartTime, unsigned int& ProbeStepIndex){
    uint64_t StepSimultaionIndex, SimulationIndex;
    size_t SetIndex;
    int ProbeIndex, ThreadIndex;
    unsigned int Space;
    double Alpha = 0.0;
    std::string Probe, Cycle, ProbingSet = "";
    std::vector<boost::mt19937> ThreadRng(Settings.Max_no_of_Threads);

    Hardware::GenerateProbingSets::All(Settings, Simulation, Test);
    Hardware::Print::ProbeGenerationSettings(Settings, Simulation, Test);

    std::cout << "Evaluate security under the robust probing model!" << std::endl;
    omp_set_num_threads(Settings.Max_no_of_Threads);

    // We use a PRNG that is thread safe
    Hardware::Operators::GenerateThreadRng(ThreadRng, Settings.Max_no_of_Threads);    

    Space = Hardware::Print::EvaluationSettings(Simulation, Test);
    std::fill(Test.SumOverGroup.begin(), Test.SumOverGroup.end(), 0.0);

    // Simulate the traces and evaluate distributions
    for (StepSimultaionIndex = 0; StepSimultaionIndex < (Settings.NumberOfSimulations / Settings.NumberOfStepSimulations); StepSimultaionIndex++){

        #pragma omp parallel for schedule(guided) private(ThreadIndex)        
        for (SimulationIndex = 0; SimulationIndex < (Settings.NumberOfStepSimulations / 64); SimulationIndex++){
            ThreadIndex = omp_get_thread_num();
            Hardware::Simulate::All(Library, Circuit, Settings, &SharedData[ThreadIndex], Simulation, SimulationIndex, ThreadRng[ThreadIndex]);
        }

        Simulation.NumberOfProcessedSimulations = (StepSimultaionIndex + 1) * Settings.NumberOfStepSimulations;
        Hardware::Test::All(Settings, Simulation, Test, Settings.CompactDistributions);

        double ElapsedTimePeriod = Util::EndClock(StartTime);
        Hardware::Print::EvaluationResults(Settings, Simulation, Test, Alpha, ProbingSet, ElapsedTimePeriod, Space);

        if ((Simulation.NumberOfProcessedSimulations % Settings.NumberOfStepSimulationsToWrite) == 0){
            Hardware::Print::Report(Settings, Simulation, Test, ProbeStepIndex, Space);
        }

        if(Settings.RemoveProbingSets && !Settings.CompactDistributions){ // Remove probing set if enough traces are processed
            for (SetIndex = 0; SetIndex < Test.ProbingSet.size(); SetIndex++){
                if (Simulation.NumberOfProcessedSimulations > Test.ProbingSet.at(SetIndex).contingency_table.GetNumberOfRequiredTraces()){
                    if (Test.ProbingSet.at(SetIndex).contingency_table.GetGValue() > Alpha){
                        Alpha = Test.ProbingSet.at(SetIndex).contingency_table.GetGValue();
                        ProbingSet = "";

                        for (ProbeIndex = 0; ProbeIndex < Test.GetNumberOfStandardProbes(SetIndex); ProbeIndex++){
                            Probe = Simulation.ProbeName[Test.GetStandardProbe(SetIndex, ProbeIndex).Probe];
                            Cycle = std::to_string(Test.GetStandardProbe(SetIndex, ProbeIndex).Cycle + 1);

                            if (ProbeIndex == (Test.GetNumberOfStandardProbes(SetIndex) - 1)){
                                ProbingSet += Probe + " (" + Cycle + ")";
                            }else{
                                ProbingSet += Probe + " (" + Cycle + "), ";
                            }
                        }
                    }
                }
            }

            Test.ProbingSet.erase(std::remove_if(Test.ProbingSet.begin(), Test.ProbingSet.end(), [&Simulation](const ProbingSetStruct& Ps){return (Simulation.NumberOfProcessedSimulations > Ps.contingency_table.GetNumberOfRequiredTraces());}), Test.ProbingSet.end());

            if (Test.ProbingSet.size() == 0){
                if ((Simulation.NumberOfProcessedSimulations % Settings.NumberOfStepSimulationsToWrite) != 0){
                    Hardware::Print::Report(Settings, Simulation, Test, ProbeStepIndex, Space);
                }
                break;
            }
        }
    }

    Test.ProbingSet.clear();
    Test.ProbingSet.shrink_to_fit();
    ProbeStepIndex++;
}