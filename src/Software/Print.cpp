#include "Software/Print.hpp"

void Software::Print::CommandLineSettings(CommandLineParameterStruct& CommandLineParameters){
    std::cout << "Source file(s): " << CommandLineParameters.DesignFileName             << std::endl;
    std::cout << "Linker file:    " << CommandLineParameters.LinkerFileName             << std::endl;
    std::cout << "Settings file:  " << CommandLineParameters.SettingsFileName           << std::endl;
    std::cout << "Result folder:  " << CommandLineParameters.EvaluationResultFolderName << std::endl;
	if(!CommandLineParameters.BinaryInformationNames.empty()){
		std::cout << "Binary information path:  " << CommandLineParameters.BinaryInformationNames << std::endl;
	}
}
//***************************************************************************************
void Software::Print::EvaluationTableHeader(){

    int TableWidth = 83 + 11 + 47;

    std::cout.width(TableWidth);
    std::cout.fill('-');
    std::cout << '-' << std::endl;
    std::cout.fill(' ');

	std::cout.setf(std::ios::right, std::ios::adjustfield);

	std::array<std::string, 6> Headers{{ "Elapsed Time", "Memory Consumption", "#Sets", "Simulations", "Probing Set with highest Information Leakage", "-log10(p)"}};
	auto const &[Time, MemoryConsumption, Probes, Simulations, ProbingSet, Probability] = Headers;

	std::cout << '|';
    std::cout.width(20);
    std::cout << (Time + " |");
	std::cout.width(25);
	std::cout << (MemoryConsumption + " |");
    std::cout.width(15);
	std::cout << (Probes + " |");
    std::cout.width(20);
    std::cout << (Simulations + " |");
    std::cout.width(47);
    std::cout << (ProbingSet + " |");
    std::cout.width(13);
    std::cout << (Probability + " |");
    std::cout << std::endl;

    std::cout.width(TableWidth);
    std::cout.fill('-');
    std::cout << '-' << std::endl;
    std::cout.fill(' ');
}

//***************************************************************************************
void Software::Print::SoftwareMaximumProbingSet(uint32_t TestOrder, ::Software::TestStruct& Test, int& MaximumProbingSet, std::string& ProbingSet)
{
	uint8_t Id, RegisterNumber, Bit;
	uint32_t Cycle;

	ProbingSet = " ";
	for(uint32_t probeIndex = 0; probeIndex < TestOrder; ++probeIndex){
		Software::Probing::ExtractIdProbeInfo(Id, Test.GlobalProbingSets.at(MaximumProbingSet).StandardProbe.at(probeIndex));
		Software::Probing::ExtractCycleProbeInfo(Cycle, Test.GlobalProbingSets.at(MaximumProbingSet).StandardProbe.at(probeIndex));
		Software::Probing::ExtractBitProbeInfo(Bit, Test.GlobalProbingSets.at(MaximumProbingSet).StandardProbe.at(probeIndex));
		Software::Probing::ExtractRegisterProbeInfo(RegisterNumber, Test.GlobalProbingSets.at(MaximumProbingSet).StandardProbe.at(probeIndex));

		switch(Id){
			case 0: ProbingSet += "MEM[" + std::to_string(Bit) + "](" + std::to_string(Cycle + 1) + ")"; break;
			case 1: ProbingSet += "MEMSHADOW[" + std::to_string(Bit) + "](" + std::to_string(Cycle + 1) + ")"; break;
			case 2: ProbingSet += "HR_MEMSHADOW(" + std::to_string(Cycle + 1) +  ")"; break;
			case 3: ProbingSet += "R" + std::to_string(RegisterNumber) + "[" + std::to_string(Bit) + "](" + std::to_string(Cycle + 1) + ")"; break;
			case 4: ProbingSet += "HR" + std::to_string(RegisterNumber) + "(" + std::to_string(Cycle + 1) + ")";break;
			case 5:
			case 6: ProbingSet += "VR[" + std::to_string(Bit) + "](" + std::to_string(Cycle + 1) + ")"; break;
			case 7:
			case 8: ProbingSet += "FULLHR(" + std::to_string(Cycle + 1) + ")"; break;
			case 9:
			case 10:
			case 11:
			case 12:
			case 13: ProbingSet += "FULLVR[" + std::to_string(Bit) + "](" + std::to_string(Cycle + 1) + ")"; break;
			case 0xf:  ProbingSet += "_"; break;
			default: ProbingSet += "???";
		}


		if(probeIndex != (TestOrder - 1)){
			ProbingSet += ", ";
		}
	}

}

//***************************************************************************************
void Software::Print::EvaluationTableLine(std::array<std::string, 6>& TableRow){
	auto const &[Time, MemoryConsumption, Probes, Simulations, ProbingSet, Probability] = TableRow;
 
	std::cout << '|';
    std::cout.width(20);
    std::cout << (Time + "s |");
	std::cout.width(25);
	std::cout << (MemoryConsumption + " |");
    std::cout.width(15);
	std::cout << (Probes + " |");
    std::cout.width(20);
	std::cout << (Simulations + " |");
    std::cout.width(47);
    std::cout << (ProbingSet + " |");
    std::cout.width(13);
    std::cout << (Probability + " |");

    std::cout << std::endl;
}

//***************************************************************************************
void Software::Print::ProbeReport(std::vector<::Software::ThreadSimulationStruct>& GlobalThreadSimulations, ::Software::SettingsStruct& Setting, std::vector<::Software::TestStruct>& GlobalTests,  int StepSimulationIndex, unsigned int NumberOfProbesToPrint, std::vector<std::tuple<uint32_t, uint32_t, double>>& ProbingSetsWithHighestProbabilities, ::Software::HelperStruct& GlobalHelper, uint32_t NumberOfProcessedSimulations){
	char*        filename;
	FILE*        fp;
	unsigned int counter = 0;
	std::tuple<int, int> MaximumPosition;
	std::vector<::Software::ProbingSetStruct>::iterator maximum;

	if (NumberOfProbesToPrint)
	{
		filename = (char*)malloc(Max_Name_Length);
		sprintf(filename, "%s/report.dat", GlobalThreadSimulations.at(0).EvaluationResultFolderName.c_str());

		if (!StepSimulationIndex)
			fp = fopen(filename, "wt");
		else
			fp = fopen(filename, "at");

		fprintf(fp, "========== State after %" PRIu64 " simulations ==========\n", (uint64_t)NumberOfProcessedSimulations);


		counter = 0;
		while((counter < NumberOfProbesToPrint)){
			Software::Print::ProbingSet(Setting, GlobalTests.at(std::get<0>(ProbingSetsWithHighestProbabilities.at(counter))).GlobalProbingSets.at(std::get<1>(ProbingSetsWithHighestProbabilities.at(counter))), std::get<2>(ProbingSetsWithHighestProbabilities.at(counter)), fp, GlobalHelper);
			counter++;
		}


		fprintf(fp, "\n");
		fclose(fp);
		free(filename);
	}
}


//***************************************************************************************
void Software::Print::ProbingSet(::Software::SettingsStruct& Setting, ::Software::ProbingSetStruct& ProbingSet, double Probability, FILE* fp, ::Software::HelperStruct& GlobalHelper){
	unsigned int ProbeIndex = 0;
	fprintf(fp, "@[");

	uint8_t Id, Bit, RegisterNumber, PartnerRegisterNumber, Dependency;
	uint32_t Cycle;//, TransitionCycle;
	uint16_t ExtensionSize;

    for(ProbeIndex = 0; ProbeIndex < ProbingSet.StandardProbe.size(); ++ProbeIndex){
        
		Software::Probing::ExtractAllProbeInfo(RegisterNumber, Id, PartnerRegisterNumber, Cycle, Bit, ExtensionSize, Dependency, ProbingSet.StandardProbe.at(ProbeIndex));

		switch(Id){
			case 0:{
				fprintf(fp, "MEM[%u](%u)", Bit, static_cast<uint32_t>(Cycle + 1));
				fprintf(fp, " ==> [");
				fprintf(fp, "MEM[%u](%u)", Bit, static_cast<uint32_t>(Cycle + 1));
				fprintf(fp, "]");
				break;
			}
			case 1:{
				fprintf(fp, "MEMSHADOW[%u](%u)", Bit, static_cast<uint32_t>(Cycle + 1));
				fprintf(fp, " ==> [MEMSHADOW[%u](%u)", Bit, static_cast<uint32_t>(Cycle + 1));
				if(Setting.TestTransitional){
					fprintf(fp, ", MEMSHADOW[%u][%u]]", Bit, static_cast<uint32_t>(ProbingSet.StandardProbe.at(ProbeIndex).TransitionCycles & 0xffffffff) + 1);
				}
				break;
			}
			case 2:{
				fprintf(fp, "HR_MEMSHADOW(%u)", static_cast<uint32_t>(Cycle+1));
				fprintf(fp, " ==> [");
				for(const auto& BitIdx: GlobalHelper.HorizontalBitsIncluded.at(17)){
					fprintf(fp, "MEMSHADOW[%u](%u), ", BitIdx, static_cast<uint32_t>(Cycle) + 1);
					if(Setting.TestTransitional){
						fprintf(fp, "MEMSHADOW[%u](%u), ", BitIdx, static_cast<uint32_t>(ProbingSet.StandardProbe.at(ProbeIndex).SpecialInfo & 0xffffffff) + 1);
					}
				}
				fprintf(fp, "]");
				break;
			}
			case 3:{
				fprintf(fp, "R%u[%u](%u)]", (static_cast<uint32_t>(RegisterNumber)), Bit, Cycle + 1);
				fprintf(fp, " ==> [");

				fprintf(fp, "R%u[%u](%u)",  (static_cast<uint32_t>(RegisterNumber)), static_cast<uint32_t>(Bit), static_cast<uint32_t>(Cycle) + 1);
				if(Setting.TestTransitional){
					 fprintf(fp, ", R%u[%u](%u)",  (static_cast<uint32_t>(RegisterNumber)), static_cast<uint32_t>(Bit), static_cast<uint32_t>(ProbingSet.StandardProbe.at(ProbeIndex).TransitionCycles & 0xffffffff) + 1);
				}
				fprintf(fp, "]");
				break;
			}
			case 4:{
				fprintf(fp, "HR%u(%u)", (static_cast<uint32_t>(RegisterNumber)), static_cast<uint32_t>(Cycle) + 1);
				fprintf(fp, " ==> [");

				for(const auto& BitIdx: GlobalHelper.HorizontalBitsIncluded.at(RegisterNumber)){
					fprintf(fp, "R%u[%u](%u), ", (static_cast<uint32_t>(RegisterNumber)), BitIdx, static_cast<uint32_t>(Cycle) + 1);
					if(Setting.TestTransitional){
						fprintf(fp, "R%u[%u](%u), ", (static_cast<uint32_t>(RegisterNumber)), BitIdx, static_cast<uint32_t>(ProbingSet.StandardProbe.at(ProbeIndex).TransitionCycles & 0xffffffff) + 1);
					}
				}
				fprintf(fp, "]");
				break;
			}
			case 5:{ //small vertical probe
				fprintf(fp, "VR[%u](%u)]", static_cast<uint32_t>(Bit), static_cast<uint32_t>(Cycle) + 1);
				fprintf(fp, " ==> [");

				fprintf(fp, "R%u[%u](%u), ", (static_cast<uint32_t>(RegisterNumber)), static_cast<uint32_t>(Bit), static_cast<uint32_t>(Cycle) + 1);
				if(Setting.TestTransitional){
					fprintf(fp, "R%u[%u](%u), ", (static_cast<uint32_t>(RegisterNumber)), static_cast<uint32_t>(Bit), static_cast<uint32_t>(ProbingSet.StandardProbe.at(ProbeIndex).TransitionCycles & 0xffffffff) + 1);
				}
				fprintf(fp, "R%u[%u](%u)", (static_cast<uint32_t>(PartnerRegisterNumber)), static_cast<uint32_t>(Bit), static_cast<uint32_t>(ProbingSet.StandardProbe.at(ProbeIndex).TransitionCycles >> 32) + 1);

				fprintf(fp, "]");
				break;
			}
			case 6:{ //large vertical probe
				fprintf(fp, "VR[%u](%u)]", static_cast<uint32_t>(Bit), static_cast<uint32_t>(Cycle) + 1);
				fprintf(fp, " ==> [");

				fprintf(fp, "R%u[%u](%u), ", (static_cast<uint32_t>(RegisterNumber)), static_cast<uint32_t>(Bit), static_cast<uint32_t>(Cycle) + 1);
				if(Setting.TestTransitional){
					fprintf(fp, "R%u[%u](%u), ", (static_cast<uint32_t>(RegisterNumber)), static_cast<uint32_t>(Bit), static_cast<uint32_t>(ProbingSet.StandardProbe.at(ProbeIndex).TransitionCycles & 0xffffffff) + 1);
				}
				fprintf(fp, "R%u[%u](%u)", (static_cast<uint32_t>(PartnerRegisterNumber)), static_cast<uint32_t>(Bit), static_cast<uint32_t>(Cycle) + 1);
				if(Setting.TestTransitional){
					fprintf(fp, "R%u[%u](%u), ", (static_cast<uint32_t>(PartnerRegisterNumber)), static_cast<uint32_t>(Bit), static_cast<uint32_t>(ProbingSet.StandardProbe.at(ProbeIndex).TransitionCycles >> 32) + 1);
				}
				fprintf(fp, "]");
				break;
			}
			case 7:{ //small full HR
				uint32_t CycleRegNr2 = static_cast<uint32_t>((ProbingSet.StandardProbe.at(ProbeIndex).TransitionCycles >> 32) + 1);
				uint32_t TransCycleRegNr1 = static_cast<uint32_t>((ProbingSet.StandardProbe.at(ProbeIndex).TransitionCycles & 0xffffffff) + 1);
				fprintf(fp, "FULLHR:R%u(%u) - R%u(%u)",RegisterNumber, Cycle+1, PartnerRegisterNumber, CycleRegNr2);
				fprintf(fp, " ==> [");
				for(const auto& idx: GlobalHelper.NormalProbesIncluded.at(RegisterNumber)){
					fprintf(fp, "R%u[%u](%u)", RegisterNumber, idx, Cycle+1);
					if(Setting.TestTransitional){
						fprintf(fp, ", R%u[%u](%u)", RegisterNumber, idx, TransCycleRegNr1);
					}
					fprintf(fp, ", ");
				}
				for(const auto& idx: GlobalHelper.NormalProbesIncluded.at(PartnerRegisterNumber)){
					fprintf(fp, "R%u[%u](%u)", PartnerRegisterNumber, idx, CycleRegNr2);
					fprintf(fp, ", ");
				}

				fprintf(fp, "]");
				break;
			}
			case 8:{ //large full HR probe
				uint32_t TransCycleRegNr1 = static_cast<uint32_t>((ProbingSet.StandardProbe.at(ProbeIndex).TransitionCycles & 0xffffffff) + 1);
				uint32_t TransCycleRegNr2 = static_cast<uint32_t>((ProbingSet.StandardProbe.at(ProbeIndex).TransitionCycles >> 32) + 1);
				fprintf(fp, "FULLHR:R%u(%u) - R%u(%u)",RegisterNumber, Cycle+1, PartnerRegisterNumber, Cycle+1);
				fprintf(fp, " ==> [");
				for(const auto& idx: GlobalHelper.NormalProbesIncluded.at(RegisterNumber)){
					fprintf(fp, "R%u[%u](%u)", RegisterNumber, idx, Cycle+1);
					if(Setting.TestTransitional){
						fprintf(fp, ", R%u[%u](%u)", RegisterNumber, idx, TransCycleRegNr1);
					}
					fprintf(fp, ", ");
				}
				for(const auto& idx: GlobalHelper.NormalProbesIncluded.at(PartnerRegisterNumber)){
					fprintf(fp, "R%u[%u](%u)", PartnerRegisterNumber, idx, Cycle+1);
					if(Setting.TestTransitional){
						fprintf(fp, ", R%u[%u](%u)", RegisterNumber, idx, TransCycleRegNr2);
					}
					fprintf(fp, ", ");
				}
				fprintf(fp, "]");
				break;
			}
			case 9:{ //small full VR probe
				fprintf(fp, "FULLVR[%u](%u)",Bit, Cycle+1);
				fprintf(fp, " ==> [");
				for(const auto& idx: GlobalHelper.FullVerticalProbesIncluded.at(Bit)){
					fprintf(fp, "R%u[%u]", idx, Bit);
					fprintf(fp, ", ");
					if(((idx == RegisterNumber) || (idx == PartnerRegisterNumber)) && Setting.TestTransitional){
						fprintf(fp, "R%u[%u]", idx, Bit);
						fprintf(fp, ", ");
					}
				}
				fprintf(fp, "]");
				break;
			}
			case 10:{ //large full VR probe
				fprintf(fp, "FULLVR[%u](%u)",Bit, Cycle+1);
				fprintf(fp, " ==> [");
				for(const auto& idx: GlobalHelper.FullVerticalProbesIncluded.at(Bit)){
					fprintf(fp, "R%u[%u]", idx, Bit);
					fprintf(fp, ", ");
					if(((idx == RegisterNumber) || (idx == 15) || (idx == 16)) && Setting.TestTransitional){
						fprintf(fp, "R%u[%u]", idx, Bit);
						fprintf(fp, ", ");
					}
				}
				fprintf(fp, "]");
				break;
			}
			case 11:{ // special full VR probe
				fprintf(fp, "FULLVR[%u](%u)",Bit, Cycle+1);
				fprintf(fp, " ==> [");
				for(const auto& idx: GlobalHelper.FullVerticalProbesIncluded.at(Bit)){
					fprintf(fp, "R%u[%u]", idx, Bit);
					fprintf(fp, ", ");
					if(((idx == RegisterNumber)) && Setting.TestTransitional){
						fprintf(fp, "R%u[%u]", idx, Bit);
						fprintf(fp, ", ");
					}
				}
				fprintf(fp, "]");
				break;
			}
			case 12:{ //small DSP full VR probe
				fprintf(fp, "FULLVR[%u](%u)",Bit, Cycle+1);
				fprintf(fp, " ==> [");
				for(const auto& idx: GlobalHelper.FullVerticalProbesIncluded.at(Bit)){
					fprintf(fp, "R%u[%u]", idx, Bit);
					fprintf(fp, ", ");
					if(((idx == RegisterNumber) || (idx == PartnerRegisterNumber) || (idx == 16)) && Setting.TestTransitional){
						fprintf(fp, "R%u[%u]", idx, Bit);
						fprintf(fp, ", ");
					}
				}
				fprintf(fp, "]");
				break;
			}
			case 13:{ //large DSP full VR probe
				fprintf(fp, "FULLVR[%u](%u)",Bit, Cycle+1);
				fprintf(fp, " ==> [");
				for(const auto& idx: GlobalHelper.FullVerticalProbesIncluded.at(Bit)){
					fprintf(fp, "R%u[%u]", idx, Bit);
					fprintf(fp, ", ");
					if(((idx == RegisterNumber) || (idx == PartnerRegisterNumber) || (idx == 15) || (idx == 16)) && Setting.TestTransitional){
						fprintf(fp, "R%u[%u]", idx, Bit);
						fprintf(fp, ", ");
					}
				}
				fprintf(fp, "]");
				break;
			}
			case 0xf:{
				break;
			}
			default: {
				std::cout << "Error in printing Probing Sets to file" << std::endl;
			    exit(-1);
			}             
		}
		
    }

	fprintf(fp, " -log10(p) = %f", Probability);
    if(Probability > 5.0){fprintf(fp, " --> LEAKAGE\n");}else{fprintf(fp, " --> OKAY\n");}
}