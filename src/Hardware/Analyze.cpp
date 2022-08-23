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
    uint64_t StepSimultaionIndex = 0, SimulationIndex = 0;
    int ThreadIndex = 0, ProbeIndex, ProbeStepIndex;
    size_t SetIndex;
    double Alpha = 0.0;
    std::string Probe, Cycle, ProbingSet = "";
    std::vector<boost::mt19937> ThreadRng(Settings.Max_no_of_Threads);

    struct timespec StartTime;
    Util::StartClock(StartTime);

    Hardware::GenerateProbingSets::All(Settings, Simulation, Test);
    Hardware::Print::ProbeGenerationSettings(Settings, Simulation, Test);

    std::cout << "Evaluate security under the robust probing model!" << std::endl;
    omp_set_num_threads(Settings.Max_no_of_Threads);
    Hardware::Operators::GenerateThreadRng(ThreadRng, Settings.Max_no_of_Threads);

    // TODO: Support multiple probe steps in compact mode
    if (Settings.CompactDistributions){
        Settings.NumberOfProbeSteps = 1;
    }

    unsigned int RemainingProbingSets, TotalNumberOfProbingSets = Test.ProbingSet.size();
    unsigned int ReducedProbeStepSize, ProbeStepSize = std::ceil((double)TotalNumberOfProbingSets / Settings.NumberOfProbeSteps);
    unsigned int Space = Hardware::Print::EvaluationSettings(Simulation, Test);

    for (ProbeStepIndex = 0; ProbeStepIndex < Settings.NumberOfProbeSteps; ProbeStepIndex++){
        Alpha = 0.0;
        RemainingProbingSets = Test.ProbingSet.size();

        if (ProbeStepSize > RemainingProbingSets){
            ProbeStepSize = RemainingProbingSets;
        }

        ReducedProbeStepSize = ProbeStepSize;

        if (Settings.NumberOfProbeSteps > 1 && !Settings.CompactDistributions){
            Hardware::GenerateProbingSets::Extend(Simulation, Test, 0, ReducedProbeStepSize);
            Hardware::GenerateProbingSets::RemoveDuplicatedProbes(Test, 0, ReducedProbeStepSize);
        }

        if (!Settings.CompactDistributions){
            for (SetIndex = 0; SetIndex < ReducedProbeStepSize; SetIndex++){
                Test.ProbingSet.at(SetIndex).OnlyOneEntry.resize(Simulation.NumberOfGroups, std::vector<std::vector<std::vector<unsigned char>>>(256));
            }
        }

        std::fill(Test.SumOverGroup.begin(), Test.SumOverGroup.end(), 0.0);

        // Simulate the traces and evaluate distributions
        for (StepSimultaionIndex = 0; StepSimultaionIndex < (Settings.NumberOfSimulations / Settings.NumberOfStepSimulations); StepSimultaionIndex++){

            #pragma omp parallel for schedule(guided) private(ThreadIndex)        
            for (SimulationIndex = 0; SimulationIndex < (Settings.NumberOfStepSimulations / 64); SimulationIndex++){
                ThreadIndex = omp_get_thread_num();
                Hardware::Simulate::All(Library, Circuit, Settings, &SharedData[ThreadIndex], Simulation, SimulationIndex, ThreadRng[ThreadIndex]);
            }

            Simulation.NumberOfProcessedSimulations = (StepSimultaionIndex + 1) * Settings.NumberOfStepSimulations;
            Hardware::Test::All(Settings, Simulation, Test, Settings.CompactDistributions, ReducedProbeStepSize);

            double ElapsedTimePeriod = Util::EndClock(StartTime);
            Hardware::Print::EvaluationResults(Settings, Simulation, Test, Alpha, ProbingSet, ElapsedTimePeriod, ReducedProbeStepSize, Space);

            if ((Simulation.NumberOfProcessedSimulations % Settings.NumberOfStepSimulationsToWrite) == 0){
                Hardware::Print::Report(Settings, Simulation, Test, ProbeStepIndex, ReducedProbeStepSize, Space);
            }

            if(Settings.RemoveProbingSets && !Settings.CompactDistributions){ // Remove probing set if enough traces are processed
                for (SetIndex = 0; SetIndex < ReducedProbeStepSize; SetIndex++){
                    if (Simulation.NumberOfProcessedSimulations > Test.ProbingSet.at(SetIndex).Traces){
                        if (Test.ProbingSet.at(SetIndex).Probability > Alpha){
                            Alpha = Test.ProbingSet.at(SetIndex).Probability;
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

                Test.ProbingSet.erase(std::remove_if(Test.ProbingSet.begin(), Test.ProbingSet.begin() + ReducedProbeStepSize, [&Simulation](const ProbingSetStruct& Ps){return (Simulation.NumberOfProcessedSimulations > Ps.Traces);}), Test.ProbingSet.begin() + ReducedProbeStepSize);
                ReducedProbeStepSize = ProbeStepSize - (RemainingProbingSets - Test.ProbingSet.size());

                if (ReducedProbeStepSize == 0){
                    if ((Simulation.NumberOfProcessedSimulations % Settings.NumberOfStepSimulationsToWrite) != 0){
                        Hardware::Print::Report(Settings, Simulation, Test, ProbeStepIndex, ReducedProbeStepSize, Space);
                    }
                    break;
                }
            }
        }

        if (!Settings.RemoveProbingSets && !Settings.CompactDistributions){ // If probing sets are not automatically removed
            Test.ProbingSet.erase(Test.ProbingSet.begin(), Test.ProbingSet.begin() + ReducedProbeStepSize);
        }
    }
}