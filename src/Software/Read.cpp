#include "Software/Read.hpp"

//***************************************************************************************

// Defining comparator function as per the requirement
int Software::Read::ProbeCompare(const void* a, const void* b)
{
 
    if((char)(*(const char**)a)[0] == 'R' && (char)(*(const char**)b)[0] == 'H'){
        return false;
    }
    else if((char)(*(const char**)a)[0] == 'R' && (char)(*(const char**)b)[0] == 'V'){
        return false;
    }
	else if((char)(*(const char**)a)[0] == 'R' && (char)(*(const char**)b)[0] == 'F'){
		return false;
	}
	else if((char)(*(const char**)a)[0] == 'R' && (char)(*(const char**)b)[0] == 'M'){
		return false;
	}
	else if((char)(*(const char**)a)[0] == 'R' && (static_cast<std::string>(*(const char**)b).rfind("PF", 0) == 0)){
		return false;
	}
    else if((char)(*(const char**)a)[0] == 'V' && (char)(*(const char**)b)[0] == 'R'){
        return true;
    }
    else if((char)(*(const char**)a)[0] == 'V' && (char)(*(const char**)b)[0] == 'F'){
        return false;
    }
    else if((char)(*(const char**)a)[0] == 'V' && (char)(*(const char**)b)[0] == 'H'){
        return true;
    }
    else if((char)(*(const char**)a)[0] == 'V' && (char)(*(const char**)b)[0] == 'M'){
        return false;
    }
	else if((char)(*(const char**)a)[0] == 'V' && (static_cast<std::string>(*(const char**)b).rfind("PF", 0) == 0)){
		return false;
	}
    else if((char)(*(const char**)a)[0] == 'H' && (char)(*(const char**)b)[0] == 'V'){
        return false;
    }
    else if((char)(*(const char**)a)[0] == 'H' && (char)(*(const char**)b)[0] == 'R'){
        return true;
    }
    else if((char)(*(const char**)a)[0] == 'H' && (char)(*(const char**)b)[0] == 'F'){
        return false;
    }
	else if((char)(*(const char**)a)[0] == 'H' && (char)(*(const char**)b)[0] == 'H'){
		char* tmp_a = ((char*)a + 2);
		char* tmp_b = ((char*)b + 2);
		return atoi(tmp_a) < atoi(tmp_b);
	}
    else if((char)(*(const char**)a)[0] == 'H' && (char)(*(const char**)b)[0] == 'M'){
        return false;
    }
	else if((char)(*(const char**)a)[0] == 'M' && (static_cast<std::string>(*(const char**)b).rfind("PF", 0) == 0)){
		return false;
	}
    else if((char)(*(const char**)a)[0] == 'M' && (char)(*(const char**)b)[0] == 'R'){
        return true;
    }
    else if((char)(*(const char**)a)[0] == 'M' && (char)(*(const char**)b)[0] == 'H'){
        return true;
    }
    else if((char)(*(const char**)a)[0] == 'M' && (char)(*(const char**)b)[0] == 'R'){
        return true;
    }
    else if((char)(*(const char**)a)[0] == 'M' && (char)(*(const char**)b)[0] == 'F'){
        return false;
    }
    else if((char)(*(const char**)a)[0] == 'M' && (char)(*(const char**)b)[0] == 'V'){
        return true;
    }
    else if(((char)(*(const char**)a)[0] == 'M') && ((char)(*(const char**)b)[0] == 'M')){
		if((strstr(*(const char**)a, "MEMSHADOW") == NULL) && (strstr(*(const char**)b, "MEMSHADOW") != NULL)){
			return true;
		}
		else {
			return false;
		}
    }
    else if((char)(*(const char**)a)[0] == 'F' && (char)(*(const char**)b)[0] == 'R'){
        return true;
    }
    else if((char)(*(const char**)a)[0] == 'F' && (char)(*(const char**)b)[0] == 'H'){
        return true;
    }
    else if((char)(*(const char**)a)[0] == 'F' && (char)(*(const char**)b)[0] == 'V'){
        return true;
    }
    else if((char)(*(const char**)a)[0] == 'F' && (char)(*(const char**)b)[0] == 'M'){
        return true;
    }
	else if((char)(*(const char**)a)[0] == 'F' && (char)(*(const char**)b)[0] == 'F'){
		if((strstr(*(const char**)a, "FULLVR") == NULL) && (strstr(*(const char**)b, "FULLVR") != NULL)){
			return true;
		}
		else {
			return false;
		}
	}
	else if((char)(*(const char**)a)[0] == 'F' && (static_cast<std::string>(*(const char**)b).rfind("PF", 0) == 0)){
		return false;
	}
    else if((static_cast<std::string>(*(const char**)a).rfind("PF", 0) == 0) && (char)(*(const char**)b)[0] == 'R'){
        return true;
    }
    else if((static_cast<std::string>(*(const char**)a).rfind("PF", 0) == 0) && (char)(*(const char**)b)[0] == 'H'){
        return true;
    }
    else if((static_cast<std::string>(*(const char**)a).rfind("PF", 0) == 0) && (char)(*(const char**)b)[0] == 'V'){
        return true;
    }
    else if((static_cast<std::string>(*(const char**)a).rfind("PF", 0) == 0) && (char)(*(const char**)b)[0] == 'F'){
        return true;
    }
    else if((static_cast<std::string>(*(const char**)a).rfind("PF", 0) == 0) && (char)(*(const char**)b)[0] == 'M'){
        return true;
    }

    else{ //both strings are normal registers
        char* tmp_b = (char*)malloc((strlen(*(char**)b)+1) *sizeof(char));
        char* tmp_a = (char*)malloc((strlen(*(char**)a)+1) *sizeof(char)); 
        

        char* bit_number_b;
        char* bit_number_a;
        
        memcpy(tmp_b, *(char**)b, strlen(*(char**)b)+1);
        memcpy(tmp_a, *(char**)a, strlen(*(char**)a)+1);
        
        tmp_b[strlen(*(char**)b)] = '\0';
        tmp_a[strlen(*(char**)a)] = '\0';
        
        //get register number and bit number
        char* register_number_b = strtok(tmp_b, "[");
        register_number_b += 1;
        bit_number_b = strtok(NULL, "]");
        
        char* register_number_a = strtok(tmp_a, "[");
        register_number_a += 1;
        bit_number_a = strtok(NULL, "]");
        
        
        if(strtol(register_number_a, NULL, 10) < strtol(register_number_b, NULL, 10)){

			free(tmp_b);
			free(tmp_a);
            return false;
        }
        else if(strtol(register_number_a, NULL, 10) > strtol(register_number_b, NULL, 10)){

			free(tmp_b);
			free(tmp_a);
            return true;
        }
        else{ //register number is equal -> check bit number
            if(strtol(bit_number_a, NULL, 10) < strtol(bit_number_b, NULL, 10)){

				free(tmp_b);
				free(tmp_a);
                return false;
            }

			free(tmp_b);
			free(tmp_a);
            return true;
        }
    }
}

//***************************************************************************************
// Function to sort the array
void Software::Read::sort(char* arr[], int n)
{
    // calling qsort function to sort the array
    // with the help of Comparator
    qsort(arr, n, sizeof(const char*), ProbeCompare);
}
//***************************************************************************************
std::vector<uint8_t> Software::Read::read_file(const std::string& path){
    std::ifstream ifs(path, std::ios::binary | std::ios::ate);
    std::ifstream::pos_type pos = ifs.tellg();
    std::vector<uint8_t> result(pos);
    ifs.seekg(0, std::ios::beg);
    ifs.read((char*)(&result[0]),pos);
    return result;
}

//***************************************************************************************
void Software::Read::SettingsFile(Software::SettingsStruct& settings, Settings& settings2, Software::ConfigProbesStruct& probes, bool ignoreMakefileConfig){
	settings.Max_no_of_Threads = settings2.GetNumberOfThreads();
	settings.NumberOfGroups = settings2.GetNumberOfGroups();
	settings.Group_Values = (int**)malloc(settings.NumberOfGroups * sizeof(int*));
	settings.NumberOfGroupValues = settings2.GetNumberOfBitsPerGroup();

	for (int group_index = 0; group_index < settings.NumberOfGroups; group_index++) {
		settings.Group_Values[group_index] = (int*)malloc((settings.NumberOfGroupValues) * sizeof(int));
		for (int j = 0; j < settings.NumberOfGroupValues; ++j) {
			if (settings2.GetGroupBit(group_index, j) == vlog_bit_t::zero) {
				settings.Group_Values[group_index][j] = 0;
			} else if (settings2.GetGroupBit(group_index, j) == vlog_bit_t::one) {
				settings.Group_Values[group_index][j] = 1;
			} else {
				settings.Group_Values[group_index][j] = -1;
			}
		}
	}

	settings.Max_No_ClockCycles = settings2.GetNumberOfClockCycles();
	settings.NumberOfTestClockCycles = settings2.GetNumberOfTestClockCycles();
	settings.TestClockCycles = (int*)malloc(settings.NumberOfTestClockCycles * sizeof(int));
	for (int j = 0; j < settings.NumberOfTestClockCycles; ++j) {
		settings.TestClockCycles[j] = settings2.GetTestClockCycle(j);
	}

	uint64_t number_of_signal_value_pairs = settings2.GetNumberOfSignalValuePairs(0);
	settings.TestOrder = settings2.GetTestOrder();
	settings.InitialSim_InputsLength = (int*)malloc(number_of_signal_value_pairs * sizeof(int));
	settings.InitialSim_IsInitialized = (uint8_t*)malloc(number_of_signal_value_pairs * sizeof(uint8_t));
	settings.InitialSim_Values = (uint64_t**)malloc(number_of_signal_value_pairs * sizeof(uint64_t*));
	settings.InitialSim_NumberOfInputs = 0;
	settings.InitialSim_Inputs = (int**)malloc(1 * sizeof(int*));
	settings.InitialSim_Inputs[0] = (int*)malloc(number_of_signal_value_pairs * sizeof(int));
	settings.InitialSim_InputName = (char**)malloc(number_of_signal_value_pairs * sizeof(char*));

	for(uint64_t index = 0; index < number_of_signal_value_pairs; ++index) {
		settings.InitialSim_InputsLength[index] = std::ceil(settings2.GetSignalLengthPerAssignment(0, index) / 8.0);

		if (settings2.GetAssignmentType(0, index) == ValueType::arary) {
			settings.InitialSim_IsInitialized[index] = 0;
		} else {
			settings.InitialSim_IsInitialized[index] = 2;
		}

		settings.InitialSim_InputName[index] = new char[strlen(settings2.GetSignalVectorName(0, index).c_str()) + 1];
		strcpy(settings.InitialSim_InputName[index], settings2.GetSignalVectorName(0, index).c_str());
		settings.InitialSim_Inputs[0][index] = index;

		settings.InitialSim_Values[index] = (uint64_t*)calloc(settings.InitialSim_InputsLength[index], sizeof(uint64_t));

		if (settings2.IsAssignedToConstant(0, index)){
			settings.InitialSim_Values[index] = (uint64_t*)calloc(settings.InitialSim_InputsLength[index], sizeof(uint64_t));

			for (int j = 0; j < settings.InitialSim_InputsLength[index]; ++j) {
				settings.InitialSim_Values[index][j] = 0;
			}

			for (uint64_t bit_index = 0; bit_index < settings2.GetSignalLengthPerAssignment(0, index); ++bit_index) {
				if (settings2.GetAssignedConstantBit(0, index, bit_index) == vlog_bit_t::one) {
					settings.InitialSim_Values[index][bit_index >> 3] |= (1 << (bit_index % 8));
				} else if (settings2.GetAssignedConstantBit(0, index, bit_index) == vlog_bit_t::zero) {
					settings.InitialSim_Values[index][bit_index >> 3] &= ~(1 << (bit_index % 8));
				} else {
					throw std::invalid_argument("Error: Signal value pair is not assigned to constant value");
				}
			}
			settings.InitialSim_IsInitialized[index] |= 1;
		} else{
			settings.InitialSim_Values[index] = (uint64_t*)calloc(settings2.GetSignalLengthPerAssignment(0, index), sizeof(uint64_t));
			for (uint64_t bit_index = 0; bit_index < settings2.GetSignalLengthPerAssignment(0, index); ++bit_index) {
				settings.InitialSim_Values[index][bit_index] = settings2.GetShareIndexOfAssignment(0, index);
				settings.InitialSim_Values[index][bit_index] <<= 32;
				settings.InitialSim_Values[index][bit_index] |= settings2.GetGroupIndexOfAssignment(0, index, bit_index); 
			}
		}

		settings.InitialSim_NumberOfInputs++;
	}

	if (settings2.GetEndConditionSignalValuePairs().empty()) {
		settings.EndSimCondition_ClockCycles = 0;
		settings.EndSimCondition_NumberOfSignals = 0;
	} else {
		settings.EndSimCondition_ClockCycles = 0;
		settings.EndSimCondition_NumberOfSignals = 1;
		std::string signal_name = settings2.GetEndConditionVectorName();
		bool is_set = false;

		for (uint64_t index = 0; index < 17; ++index) {
			if ((signal_name == ("R" + std::to_string(index))) || (signal_name == ("r" + std::to_string(index)))) {
				settings.EndSimCondition_Signals = (int*)malloc(sizeof(int));
				settings.EndSimCondition_Signals[0] = index;
				settings.EndSimCondition_Values = (uint64_t*)malloc(sizeof(uint64_t));
				settings.EndSimCondition_Values[0] = 0;

				for (uint64_t bit_index = 0; bit_index < settings2.GetNumberOfEndConditionSignalValuePairs(); ++bit_index) {
					if (settings2.GetEndConditionSignalValuePair(bit_index).second){
						settings.EndSimCondition_Values[0] |= (1 << bit_index);
					}
				}
				is_set = true;
				break;
			}
		}

		if (!is_set) {
			if (signal_name == "SB") {
				settings.EndSimCondition_Signals = (int*)malloc(sizeof(int));
				settings.EndSimCondition_Signals[0] = 9;
				settings.EndSimCondition_Values = (uint64_t*)malloc(sizeof(uint64_t));
				settings.EndSimCondition_Values[0] = 0;

				for (uint64_t bit_index = 0; bit_index < settings2.GetNumberOfEndConditionSignalValuePairs(); ++bit_index) {
					if (settings2.GetEndConditionSignalValuePair(bit_index).second){
						settings.EndSimCondition_Values[0] |= (1 << bit_index);
					}
				}
				is_set = true;
			} else if (signal_name == "SL") {
				settings.EndSimCondition_Signals = (int*)malloc(sizeof(int));
				settings.EndSimCondition_Signals[0] = 10;
				settings.EndSimCondition_Values = (uint64_t*)malloc(sizeof(uint64_t));
				settings.EndSimCondition_Values[0] = 0;

				for (uint64_t bit_index = 0; bit_index < settings2.GetNumberOfEndConditionSignalValuePairs(); ++bit_index) {
					if (settings2.GetEndConditionSignalValuePair(bit_index).second){
						settings.EndSimCondition_Values[0] |= (1 << bit_index);
					}
				}
				is_set = true;
			} else if (signal_name == "FP") {
				settings.EndSimCondition_Signals = (int*)malloc(sizeof(int));
				settings.EndSimCondition_Signals[0] = 11;
				settings.EndSimCondition_Values = (uint64_t*)malloc(sizeof(uint64_t));
				settings.EndSimCondition_Values[0] = 0;

				for (uint64_t bit_index = 0; bit_index < settings2.GetNumberOfEndConditionSignalValuePairs(); ++bit_index) {
					if (settings2.GetEndConditionSignalValuePair(bit_index).second){
						settings.EndSimCondition_Values[0] |= (1 << bit_index);
					}
				}
				is_set = true;
			} else if (signal_name == "IP") {
				settings.EndSimCondition_Signals = (int*)malloc(sizeof(int));
				settings.EndSimCondition_Signals[0] = 12;
				settings.EndSimCondition_Values = (uint64_t*)malloc(sizeof(uint64_t));
				settings.EndSimCondition_Values[0] = 0;

				for (uint64_t bit_index = 0; bit_index < settings2.GetNumberOfEndConditionSignalValuePairs(); ++bit_index) {
					if (settings2.GetEndConditionSignalValuePair(bit_index).second){
						settings.EndSimCondition_Values[0] |= (1 << bit_index);
					}
				}
				is_set = true;
			} else if (signal_name == "SP") {
				settings.EndSimCondition_Signals = (int*)malloc(sizeof(int));
				settings.EndSimCondition_Signals[0] = 13;
				settings.EndSimCondition_Values = (uint64_t*)malloc(sizeof(uint64_t));
				settings.EndSimCondition_Values[0] = 0;

				for (uint64_t bit_index = 0; bit_index < settings2.GetNumberOfEndConditionSignalValuePairs(); ++bit_index) {
					if (settings2.GetEndConditionSignalValuePair(bit_index).second){
						settings.EndSimCondition_Values[0] |= (1 << bit_index);
					}
				}
				is_set = true;
			} else if (signal_name == "LR") {
				settings.EndSimCondition_Signals = (int*)malloc(sizeof(int));
				settings.EndSimCondition_Signals[0] = 14;
				settings.EndSimCondition_Values = (uint64_t*)malloc(sizeof(uint64_t));
				settings.EndSimCondition_Values[0] = 0;

				for (uint64_t bit_index = 0; bit_index < settings2.GetNumberOfEndConditionSignalValuePairs(); ++bit_index) {
					if (settings2.GetEndConditionSignalValuePair(bit_index).second){
						settings.EndSimCondition_Values[0] |= (1 << bit_index);
					}
				}
				is_set = true;
			} else if (signal_name == "PC") {
				settings.EndSimCondition_Signals = (int*)malloc(sizeof(int));
				settings.EndSimCondition_Signals[0] = 15;
				settings.EndSimCondition_Values = (uint64_t*)malloc(sizeof(uint64_t));
				settings.EndSimCondition_Values[0] = 0;

				for (uint64_t bit_index = 0; bit_index < settings2.GetNumberOfEndConditionSignalValuePairs(); ++bit_index) {
					if (settings2.GetEndConditionSignalValuePair(bit_index).second){
						settings.EndSimCondition_Values[0] |= (1 << bit_index);
					}
				}
				is_set = true;
			} else if (signal_name == "PSR") {
				settings.EndSimCondition_Signals = (int*)malloc(sizeof(int));
				settings.EndSimCondition_Signals[0] = 16;
				settings.EndSimCondition_Values = (uint64_t*)malloc(sizeof(uint64_t));
				settings.EndSimCondition_Values[0] = 0;

				for (uint64_t bit_index = 0; bit_index < settings2.GetNumberOfEndConditionSignalValuePairs(); ++bit_index) {
					if (settings2.GetEndConditionSignalValuePair(bit_index).second){
						settings.EndSimCondition_Values[0] |= (1 << bit_index);
					}
				}
				is_set = true;
			}
		}

		if (!is_set){
			throw std::invalid_argument("Error: Signal value pair is not assigned to constant value");
		}			
	}

	settings.NumberOfPipelineStages = settings2.GetNumberOfPipelineStages();

	uint64_t number_of_horizontal_probes = 18;

	std::vector<std::string> probe_names_to_check;
	std::vector<std::string> included_probe_names;
	std::vector<uint64_t> included_probe_indices;
	probes.NumberOfProbes = 0;

	for (uint64_t index = 0; index < Max_Num_Register; ++index) {
		for (uint64_t bit_index = 0; bit_index < 32; ++bit_index) {
			probe_names_to_check.push_back("R" + std::to_string(index) + "[" + std::to_string(bit_index) + "]");
		}
	}

	for (uint64_t index = 0; index < 32; ++index) {
		probe_names_to_check.push_back("MEM[" + std::to_string(index) + "]");
	}

	for (uint64_t index = 0; index < 32; ++index) {
		probe_names_to_check.push_back("MEMSHADOW[" + std::to_string(index) + "]");
	} 

	for (uint64_t index = 0; index < number_of_horizontal_probes; ++index) {
		probe_names_to_check.push_back("HR" +  std::to_string(index));
	} 

	for (uint64_t index = 0; index < 32; ++index) {
		probe_names_to_check.push_back("VR[" + std::to_string(index) + "]");
	} 

	probe_names_to_check.push_back("FULLHR");

	for (uint64_t index = 0; index < 32; ++index) {
		probe_names_to_check.push_back("FULLVR[" + std::to_string(index) + "]");
	} 

	for (uint64_t index = 0; index < 32; ++index) {
		probe_names_to_check.push_back("PF[" + std::to_string(index) + "]");
	} 

	bool included = false;
	for (uint64_t index = 0; index < probe_names_to_check.size(); ++index) {  
		if (settings2.side_channel_analysis.locations.first_include){
			included = false;

			if (std::regex_match(probe_names_to_check[index], settings2.side_channel_analysis.locations.included_elements)) {
				included = true;
			}

			if (std::regex_match(probe_names_to_check[index], settings2.side_channel_analysis.locations.excluded_elements)) {
        		included = false;
      		}
		} else {
			included = true;

			if (std::regex_match(probe_names_to_check[index], settings2.side_channel_analysis.locations.excluded_elements)) {
				included = false;
			}

			if (std::regex_match(probe_names_to_check[index], settings2.side_channel_analysis.locations.included_elements)) {
        		included = true;
      		}
		}

		if (included) {
			included_probe_names.push_back(probe_names_to_check[index]);
			included_probe_indices.push_back(index);
			++probes.NumberOfProbes;
		}
	}

	probes.Probes = (int*)malloc(probes.NumberOfProbes * sizeof(int));
	probes.ProbeName = (char**)malloc(probes.NumberOfProbes * sizeof(char*));

	for (uint64_t index = 0; index < included_probe_names.size(); ++index) {  
		probes.Probes[index] = included_probe_indices[index];
		probes.ProbeName[index] = new char[strlen(included_probe_names[index].c_str()) + 1];
		strcpy(probes.ProbeName[index], included_probe_names[index].c_str());
	}
	
	settings.TestTransitional = settings2.IsTransitionalLeakage();
	settings.NumberOfSimulations = settings2.GetNumberOfSimulations();
	settings.NumberOfStepSimulations = settings2.GetNumberOfSimulationsPerStep();
	settings.NumberOfStepSimulationsToWrite = settings2.GetNumberOfSimulationsPerWrite();

	if (settings2.GetVariate() == Analysis::univariate) {
		settings.TestMultivariate = 0;
	} else if (settings2.GetVariate() == Analysis::multivariate) {
		settings.TestMultivariate = 1;
	} else {
		settings.TestMultivariate = 2;
	}

	settings.funcContainingCipher = settings2.GetLocationOfCipher();
	
	if (settings2.GetNumberOfEntriesInReport()) {
		settings.Max_No_ReportEntries = settings2.GetNumberOfEntriesInReport();
	} else{
		settings.Max_No_ReportEntries = 10;
	}
	
	settings.CompactDistributions = settings2.IsCompactDistribution();

	if (ignoreMakefileConfig) {
		settings.externalMake = "1";
	} else {
		settings.externalMake = "0";
		settings.compilerFlags = settings2.GetCompilerFlags();
	}
}

void Software::Read::BinaryFile(const po::variables_map& vm, Software::SettingsStruct& settings){
	if(settings.externalMake == "0") {
    	const std::string build_arm_binary = "arm-none-eabi-gcc " + settings.compilerFlags + " -Wl,-T" + vm["linkerfile"].as<std::string>() +
                          " -Wl,-Map," + vm["mapfile"].as<std::string>() + " -o " + vm["binary"].as<std::string>() + " " + vm["designfile"].as<std::string>();

		boost::process::system(build_arm_binary);
	}

	const std::string create_asm = "arm-none-eabi-objdump " + vm["binary"].as<std::string>() + " -d"; 
	boost::process::system(create_asm, boost::process::std_out > vm["asmfile"].as<std::string>());

	wchar_t** argv;
	std::string ErrorMessage;




    /*
    *   second step: parse arguments
    */
	Py_Initialize();
  	/* This is to add the path in the code */
	PyObject *os_module = PyImport_ImportModule("os");
	if (os_module == NULL) { //error handling
        PyErr_Print();
		throw std::runtime_error("in read binaryfile: os module error");
	}
	PyObject* cwd = PyObject_CallMethod(os_module, "getcwd", NULL);
	if (cwd == NULL) { //error handling
        PyErr_Print();
		throw std::runtime_error("in read binaryfile: getcwd error");
	}

	PyObject* result = PyUnicode_AsEncodedString(cwd, "utf-8", "~E~");
	const char *bytes = PyBytes_AS_STRING(result);
	std::string path_of_example(bytes);
	std::string path_of_directory = path_of_example.substr(0, path_of_example.rfind("prolead") + strlen("prolead"));

	PyObject *sys_path = PySys_GetObject("path");
	PyList_Append(sys_path, PyUnicode_FromString(path_of_directory.c_str()));
	
    /* create parameter array for compilation step*/
    argv = new wchar_t*[settings.InitialSim_NumberOfInputs+4]; //inputs and name of function containing cipher
    argv[0] = new wchar_t[strlen(settings.funcContainingCipher.c_str())+1];
    mbstowcs(argv[0], settings.funcContainingCipher.c_str(), strlen(settings.funcContainingCipher.c_str()) + 1);
    argv[1] = new wchar_t[strlen(vm["binary"].as<std::string>().c_str())+1];
    mbstowcs(argv[1], vm["binary"].as<std::string>().c_str(), strlen(vm["binary"].as<std::string>().c_str()) + 1);
    argv[2] = new wchar_t[strlen(vm["mapfile"].as<std::string>().c_str())+1];
    mbstowcs(argv[2], vm["mapfile"].as<std::string>().c_str(), strlen(vm["mapfile"].as<std::string>().c_str()) + 1);
    argv[3] = new wchar_t[strlen(vm["asmfile"].as<std::string>().c_str())+1];
    mbstowcs(argv[3], vm["asmfile"].as<std::string>().c_str(), strlen(vm["asmfile"].as<std::string>().c_str()) + 1);
    argv[4] = new wchar_t[strlen(vm["resultfolder"].as<std::string>().c_str())+1];
    mbstowcs(argv[4], vm["resultfolder"].as<std::string>().c_str(), strlen(vm["resultfolder"].as<std::string>().c_str()) + 1);

    for(int i = 0; i < settings.InitialSim_NumberOfInputs; ++i){
        argv[i+5] = new wchar_t[strlen(settings.InitialSim_InputName[i])+1];
        mbstowcs(argv[i+5], settings.InitialSim_InputName[i], strlen(settings.InitialSim_InputName[i]) + 1);
    }
    PySys_SetArgv(settings.InitialSim_NumberOfInputs+5, argv);
	PyObject* pName = NULL;
	PyObject* pModule = NULL;
	PyObject* pDict = NULL;
	PyObject* pFunc  = NULL;
	PyObject* pArgs  = NULL;
	PyObject* pValue = NULL;
    //import python module for argument parsing
    if((pName = PyUnicode_FromString("inc.Software.parse_args"))){
		if((pModule = PyImport_Import(pName))){
			if((pDict = PyModule_GetDict(pModule))){
				pFunc = PyDict_GetItemString(pDict, "extract_args");
				pArgs = PyTuple_New(1);
				pValue = PyUnicode_FromString(path_of_example.c_str()); 
			}
			else{
                PyErr_Print();
				throw std::runtime_error("in read binaryfile: PyModule_GetDict error");
			}
		}
		else{
            PyErr_Print();
			throw std::runtime_error("in read binaryfile: PyImport_Import error");
		}

	}
	else{
        PyErr_Print();
		throw std::runtime_error("in read binaryfile: PyUnicode_FromString error");
	}

	PyTuple_SetItem(pArgs, 0, pValue);

    //run required function form module and return as PyObject*
    if(pModule){
        pValue = PyObject_CallObject(pFunc, pArgs); //
        if(pValue == NULL){
            PyErr_Print();
			throw std::runtime_error("ERROR: unable to execute python function to parse arguments!");
        }

    }
    else{
        PyErr_Print();
        throw std::runtime_error("ERROR: Python module not imported!");
    }

    //free allocated array
    for(int i = 0; i < settings.InitialSim_NumberOfInputs; ++i){
        delete[] argv[i];
    }
    delete[] argv;

    //generate from PyObject* arguments for c struct

    //convert as const char*
    PyObject* obj_representation = PyObject_Repr(pValue);
    const char* py_string = PyUnicode_AsUTF8(obj_representation);


    //convert as char*
    char* arg_string = strdup(py_string);
    char* arg = strtok(arg_string+1, " ");

    char** args = NULL;
    uint32_t n_spaces = 0;

    //convert string into array of strings
    while(arg){
        args = (char**)realloc(args, sizeof(char*) * (++n_spaces));
        if(args == NULL){
			ErrorMessage = "reading binary file: reallocation not possible";
			throw std::runtime_error(ErrorMessage);
        }
        
        args[n_spaces-1] = strdup(arg);
        arg = strtok(NULL, " ");
    }
    free(arg_string);

    //get rid of last apostrophe
    args[n_spaces-1][strlen(args[n_spaces-1])-1] = '\0';
    
    //initialise Settings values
    settings.start_address    = -1;
    settings.main_address     = -1;
    settings.flash            = {0,0};
    settings.ram              = {0,0};
    settings.arch             = mulator::Architecture::ARMv7M;
    settings.num_threads      = 0;
	
    for(uint32_t i = 0; i < n_spaces; ++i){
        if(!strcmp(args[i],"--start")){
            settings.start_address = (uint32_t)strtol(args[++i], NULL, 16);
        }
        else if(!strcmp(args[i],"--main")){
            settings.main_address = (uint32_t)strtol(args[++i], NULL, 16);
        }
        else if(!strcmp(args[i],"--symbol")){
            auto symbol = args[++i];
            auto addr = strtol(args[++i], NULL, 16);
            settings.symbol_names[addr] = symbol;
            settings.symbol_addresses.push_back(addr);
        }
        else if(!strcmp(args[i],"--halt")){
            auto symbol = args[++i];
            uint32_t addr = strtol(args[++i], NULL, 16);
            settings.symbol_names[addr] = symbol;
            settings.halt_addresses.push_back(addr);

        }
        else if(!strcmp(args[i], "--ignore")){
            ++i;
            ++i;
        }
        else if(!strcmp(args[i], "--edata_used_ram")){ 
            settings.length_occupied_ram = (uint32_t)strtol(args[++i], NULL, 16);
        }
        else if(!strcmp(args[i], "--inputs")){ 
            for(int j = 0; j < settings.InitialSim_NumberOfInputs; ++j){
                auto input_name = args[++i];
                auto input_address = (uint32_t)strtol(args[++i], NULL, 16);
                settings.InitialSim_PositionInEmulatorRam[input_name] = input_address - (settings.ram).offset;
            }
        }
        else if(!strcmp(args[i], "--randomness_section")){
            settings.randomness_start_addr = (uint32_t)strtol(args[++i], NULL, 10);
            settings.randomness_end_addr = (uint32_t)strtol(args[++i], NULL, 10);
            settings.randomness_segment_length = settings.randomness_end_addr - settings.randomness_start_addr;

        }
        else if(!strcmp(args[i],"--section")){
            settings.binary.push_back({args[++i], read_file(args[i]), (uint32_t)strtol(args[++i], NULL, 16)});
        }
        else if(!strcmp(args[i],"--flash")){
            settings.flash.offset = (uint32_t)strtol(args[++i], NULL, 16);
            settings.flash.size = (uint32_t)strtol(args[++i], NULL, 16);
        }
        else if(!strcmp(args[i],"--ram")){
            (settings.ram).offset = (uint32_t)strtol(args[++i], NULL, 16);
            (settings.ram).size = (uint32_t)strtol(args[++i], NULL, 16);
        }
        else if(!strcmp(args[i],"--armv7m")){
            settings.arch = mulator::Architecture::ARMv7M;
        }
        else if(!strcmp(args[i],"--armv6m")){
            settings.arch = mulator::Architecture::ARMv6M;
        }
        else if(!strcmp(args[i], "--armv7e-m")){
            settings.arch = mulator::Architecture::ARMv7EM;
        }
        else{
            // printf("unkown option '%s'",args[i]);
			ErrorMessage = "unkown option " + std::string(args[i]);
			throw std::runtime_error(ErrorMessage);
        }
    }

    if(settings.start_address == (uint32_t)-1){
        throw std::runtime_error("no entry point given");
    }
    if(settings.main_address == (uint32_t)-1){
        throw std::runtime_error("no main function given");
    }
    if(settings.ram.size == 0){
        throw std::runtime_error("no RAM given");
    }
    if(settings.flash.size == 0){
		throw std::runtime_error("no FLASH given");
    }
    if(settings.start_address == (uint32_t)-1){
        throw std::runtime_error("no entry point given");
    }

    //calculate actual offset
    settings.length_occupied_ram -= settings.ram.offset;

    //free reallocated memory
    for(uint32_t idx = 0; idx < n_spaces; ++idx){
        free(args[idx]);
    }
    free(args);

    Py_Finalize();
}

void Software::Read::StrReplaceChar(char *Str, char ch_source, char ch_destination){
    unsigned int i;

    for (i = 0; i < strlen(Str); i++)
    {
        if (Str[i] == ch_source)
            Str[i] = ch_destination;
    }
}
void Software::Read::ReadNonCommentFromFile(FILE *FileHeader, char *Str, const char *CommentSyntax){
    int l;
    char ch;

	Str[0] = 0;

    l = (int)strlen(CommentSyntax);
    do
    {
        if (fscanf(FileHeader, "%s", Str))
        {
			if (!memcmp(CommentSyntax, Str, l))
			{
				do
					ch = fgetc(FileHeader);
				while ((ch != '\n') && (ch != '\r') && (!feof(FileHeader)));
			}
		}
    } while ((!memcmp(CommentSyntax, Str, l)) && (!feof(FileHeader)));
}
