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
void Software::Read::SettingsFile(char* InputSettingsFileName, Software::SettingsStruct* Settings, Software::ConfigProbesStruct* Probes, bool ignoreMakefileConfig){
    char*     Str1 = (char *)malloc(Max_Name_Length * sizeof(char));
    char*     Str2 = (char *)malloc(Max_Name_Length * sizeof(char));
    char*     Str3 = (char *)malloc(Max_Name_Length * sizeof(char));
	char*	  Str4 = (char *)malloc(Max_Name_Length * sizeof(char));
    int       i, j;
    int       InputIndex;
    //int       SignalIndex;
    int       IndexH,  IndexL;
    int       IndexH2, IndexL2;
	int       ShareIndex;
    FILE*     SettingsFile;
    int       SettingsFileCheckList = 0;
    int       ClockCycle;
    int       InitialSim_NumberOfInputBlocks = 0;
    int*      Buffer_int;
    uint64_t* Buffer_U64;
	char** 	  Buffer_string;
    int       NumberOfBuffer_char;
    char*     str_ptr;
    int       v;
    int       NumberOfItems;
    int       NumberOfEntries;
    int       EntryIndex;
	int       GroupIndex;
	//char      OneFound;
	char*     tmptr;
	int64_t   templl;
	int		  templ;

    std::string ErrorMessage;

    SettingsFile = fopen(InputSettingsFileName, "rt");

    if (SettingsFile == NULL)
    {

        ErrorMessage = "config file " + std::string(InputSettingsFileName) + " not found";
        free(Str1);
        free(Str2);
        free(Str3);
		free(Str4);
        throw std::runtime_error(ErrorMessage);
    }

    do
    {
        Str1[0] = 0;
        ReadNonCommentFromFile(SettingsFile, Str1, "%");

		if (!strcmp(Str1, "max_no_of_threads"))
		{
			ReadNonCommentFromFile(SettingsFile, Str1, "%");
			templ = strtol(Str1, &tmptr, 10);
			if ((*tmptr) ||
			    (templ < 1))
			{

                ErrorMessage = "config file: given max_no_of_threads " + std::string(Str1) + " is not valid, should be larger than 0";
				fclose(SettingsFile);
				free(Str1);
				free(Str2);
				free(Str3);
				free(Str4);
				throw std::runtime_error(ErrorMessage);
			}

			Settings->Max_no_of_Threads = templ;
			SettingsFileCheckList |= (1 << 0);
		}
		else if (!strcmp(Str1, "no_of_groups"))
		{
			ReadNonCommentFromFile(SettingsFile, Str1, "%");
			templ = strtol(Str1, &tmptr, 10);
			if ((*tmptr) ||
			    (templ < 2))
			{
                ErrorMessage = "config file: given no_of_groups " +  std::string(Str1) + " is not valid, should be larger than 1";
				fclose(SettingsFile);
				free(Str1);
				free(Str2);
				free(Str3);
				free(Str4);
				throw std::runtime_error(ErrorMessage);
			}

			Settings->NumberOfGroups = templ;
			Settings->Group_Values = (int**)malloc(Settings->NumberOfGroups * sizeof(int*));
			Settings->NumberOfGroupValues = 0;

			for (GroupIndex = 0;GroupIndex < Settings->NumberOfGroups;GroupIndex++)
			{
				Settings->Group_Values[GroupIndex] = NULL;
				NumberOfBuffer_char = 0;
				ReadNonCommentFromFile(SettingsFile, Str1, "%");

				strncpy(Str2, Str1, Max_Name_Length);
				str_ptr = strchr(Str2, '\'');
				*str_ptr = 0;

				templ = strtol(Str2, &tmptr, 10);
				if ((*tmptr) ||
					(templ < 1))
				{
                    ErrorMessage = "config file: given length " + std::string(Str2) + " for" + std::string(Str1) + " is not valid, should be larger than 0";
					fclose(SettingsFile);
					free(Str1);
					free(Str2);
					free(Str3);
					free(Str4);
					throw std::runtime_error(ErrorMessage);
				}

				j = templ;
				if (!Settings->NumberOfGroupValues)
				{
					Settings->NumberOfGroupValues = j;
					Settings->MaxNumberOfSharesGroupValues = (int*)calloc(Settings->NumberOfGroupValues, sizeof(int));
				}
				else if (j != Settings->NumberOfGroupValues)
				{

                    ErrorMessage = "config file: length " + std::string(Str1) + " does not match to the other sizes";
					fclose(SettingsFile);
					free(Str1);
					free(Str2);
					free(Str3);
					free(Str4);
					throw std::runtime_error(ErrorMessage);
				}

				strncpy(Str3, str_ptr + 1, Max_Name_Length);
				strncpy(Str2, Str3, Max_Name_Length);
				strncpy(Str3, Str1, Max_Name_Length);
				strncpy(Str1, Str2 + 1, Max_Name_Length);

				if (Str2[0] == 'h')
				{
					for (j = 0; j < Settings->NumberOfGroupValues; j += 4)
					{
						if (!strlen(Str1))
						{

                            ErrorMessage = "config file: length " + std::string(Str3) + " does not match to the given size";
							fclose(SettingsFile);
							free(Str1);
							free(Str2);
							free(Str3);
							free(Str4);
							throw std::runtime_error(ErrorMessage);
						}
						Str2[0] = Str1[strlen(Str1) - 1];
						Str2[1] = 0;
						Str1[strlen(Str1) - 1] = 0;

						Buffer_int = (int*)malloc((NumberOfBuffer_char + 4) * sizeof(int));
						memcpy(Buffer_int, Settings->Group_Values[GroupIndex], NumberOfBuffer_char * sizeof(int));
						free(Settings->Group_Values[GroupIndex]);
						Settings->Group_Values[GroupIndex] = Buffer_int;

						v = strtol(Str2, NULL, 16);
						for (i = 0; i < 4; i++)
						{
							if (Str2[0] == '$')
								Settings->Group_Values[GroupIndex][NumberOfBuffer_char] = -1;
							else
								Settings->Group_Values[GroupIndex][NumberOfBuffer_char] = (v & (1 << i)) ? 1 : 0;
							NumberOfBuffer_char++;
						}
					}
				}
				else if (Str2[0] == 'b')
				{
					for (j = 0; j < Settings->NumberOfGroupValues; j += 1)
					{
						if (!strlen(Str1))
						{

                            ErrorMessage = "config file: length " + std::string(Str3) + " does not match to the given size";
							fclose(SettingsFile);
							free(Str1);
							free(Str2);
							free(Str3);
							free(Str4);
							throw std::runtime_error(ErrorMessage);
						}
						Str2[0] = Str1[strlen(Str1) - 1];
						Str2[1] = 0;
						Str1[strlen(Str1) - 1] = 0;

						Buffer_int = (int*)malloc((NumberOfBuffer_char + 1) * sizeof(int));
						memcpy(Buffer_int, Settings->Group_Values[GroupIndex], NumberOfBuffer_char * sizeof(int));
						free(Settings->Group_Values[GroupIndex]);
						Settings->Group_Values[GroupIndex] = Buffer_int;

						v = strtol(Str2, NULL, 2);
						if (Str2[0] == '$')
							Settings->Group_Values[GroupIndex][NumberOfBuffer_char] = -1;
						else
							Settings->Group_Values[GroupIndex][NumberOfBuffer_char] = v;
						NumberOfBuffer_char++;
					}
				}
				else
				{

                    ErrorMessage = "config file: base not known in " + std::string(Str3);
					fclose(SettingsFile);
					free(Str1);
					free(Str2);
					free(Str3);
					free(Str4);
					throw std::runtime_error(ErrorMessage);
				}

				if (strlen(Str1))
				{

                    ErrorMessage = "config file: length " + std::string(Str3) + " does not match to the given size";
					fclose(SettingsFile);
					free(Str1);
					free(Str2);
					free(Str3);
					free(Str4);
					throw std::runtime_error(ErrorMessage);
				}
			}

			SettingsFileCheckList |= (1 << 1);
		}
		else if (!strcmp(Str1, "order_of_test"))
		{
			ReadNonCommentFromFile(SettingsFile, Str1, "%");
			templ = strtol(Str1, &tmptr, 10);
			if ((*tmptr) ||
			    (templ < 1))
			{

                ErrorMessage = "config file: given value " +  std::string(Str1) + " for order_of_test is not valid, should be larger than 0";
				fclose(SettingsFile);
				free(Str1);
				free(Str2);
				free(Str3);
				free(Str4);
				throw std::runtime_error(ErrorMessage);
			}

			Settings->TestOrder = templ;
			SettingsFileCheckList |= (1 << 2);
		}

        else if (!strcmp(Str1, "max_clock_cycle"))								//in SW case: instruction granularity
        {
            ReadNonCommentFromFile(SettingsFile, Str1, "%");
			templ = strtol(Str1, &tmptr, 10);
			if ((*tmptr) ||
			    (templ < 1))
			{

                ErrorMessage = "config file: given Max_No_ClockCycles " + std::string(Str1) + " is not valid, should be larger than 0";
				fclose(SettingsFile);
				free(Str1);
				free(Str2);
				free(Str3);
				free(Str4);
				throw std::runtime_error(ErrorMessage);
			}

            Settings->Max_No_ClockCycles = templ;
            SettingsFileCheckList |= (1 << 3);
        }
		else if (!strcmp(Str1, "no_of_initial_inputs"))
		{
			ReadNonCommentFromFile(SettingsFile, Str1, "%");
			templ = strtol(Str1, &tmptr, 10);
			if ((*tmptr) ||
				(templ < 0))
			{

                ErrorMessage = "config file: given no_of_initial_inputs " +  std::string(Str1) + " is not valid, should be larger or equal 0";
				fclose(SettingsFile);
				free(Str1);
				free(Str2);
				free(Str3);
				free(Str4);
				throw std::runtime_error(ErrorMessage);
			}

			InitialSim_NumberOfInputBlocks = templ;

			if(!(Settings->Hardware)){


				Settings->InitialSim_InputsLength = (int*)malloc(InitialSim_NumberOfInputBlocks * sizeof(int));				//contains length (in bytes) of all inputs seperately
				Settings->InitialSim_IsInitialized = (uint8_t*)malloc(InitialSim_NumberOfInputBlocks * sizeof(uint8_t));	//flag if input in position i has a fixed or unkown value
				
				Settings->InitialSim_Values = (uint64_t**)malloc(InitialSim_NumberOfInputBlocks * sizeof(uint64_t*));
				
				Settings->InitialSim_NumberOfInputs = 0;
				Settings->InitialSim_Inputs = (int**)malloc(1 * sizeof(int*));		//contains X in paramX -> represents which input parameter this is
				Settings->InitialSim_Inputs[0] = (int*)malloc(InitialSim_NumberOfInputBlocks*sizeof(int));
				Settings->InitialSim_InputName = (char**)malloc(InitialSim_NumberOfInputBlocks * sizeof(char*));
				

				//go over all inputs
				for(InputIndex = 0; InputIndex < InitialSim_NumberOfInputBlocks; InputIndex++){
					NumberOfBuffer_char = 0;

					ReadNonCommentFromFile(SettingsFile, Str1, "%"); //will be [x:y] in bytes

					if ((Str1[0] == '[') && (Str1[strlen(Str1) - 1] == ']'))
					{
						strncpy(Str2, Str1 + 1, Max_Name_Length);
						Str2[strlen(Str2) - 1] = 0;
						str_ptr = strchr(Str2, ':');
						if (str_ptr != NULL)
						{
							*str_ptr = 0;
							IndexH = atoi(Str2);
							IndexL = atoi(str_ptr + 1);
						}
						else
						{
							IndexH = atoi(Str2);
							IndexL = IndexH;
						}


					}
					else
					{

                        ErrorMessage = "config file: In no_of_initial_clock_cycles: not the correct format for software case. Should start with [max_bit:min_bit]";
						fclose(SettingsFile);
						free(Str1);
						free(Str2);
						free(Str3);
						free(Str4);
						throw std::runtime_error(ErrorMessage);
					}

					/*
					*get input length [x:y] measured in bits -> x-y+1 bits required
					*/

					Settings->InitialSim_InputsLength[InputIndex] = ((IndexH - IndexL + 1) + 7)/8;

					//read if parameter will be array or variable
					ReadNonCommentFromFile(SettingsFile, Str1, "%");
					v = 0;
					while(Str1[v]){
						Str1[v] = toupper(Str1[v]);
						v++;
					}

					if(!(strcmp(Str1, "ARR"))){
						Settings->InitialSim_IsInitialized[InputIndex] = 0;
					}
					else if(!(strcmp(Str1, "VAR"))){
						Settings->InitialSim_IsInitialized[InputIndex] = 2;
					}
					else{
						ErrorMessage = "config file: In no_of_initial_clock_cycles: unkown second identfier if parameter is variable (var) or array (arr)";
                        fclose(SettingsFile);
						free(Str1);
						free(Str2);
						free(Str3);
						free(Str4);
						throw std::runtime_error(ErrorMessage);
					}


					ReadNonCommentFromFile(SettingsFile, Str1, "%");


					/*
					*	read name of input parameter
					*/
					Settings->InitialSim_InputName[InputIndex] = (char*)malloc((strlen(Str1)+1) * sizeof(char));
					memcpy(Settings->InitialSim_InputName[InputIndex], Str1, strlen(Str1)+1);

					//todo: probably unnecessary
					Settings->InitialSim_Inputs[0][InputIndex] = InputIndex;



					/*
					*look and decide if parsing group_inX or not
					*/
					ReadNonCommentFromFile(SettingsFile, Str1, "%");

					//no string group_in found -> fixed value
					if (strstr(Str1, "group_in") != Str1)
					{
						strncpy(Str2, Str1, Max_Name_Length);
						str_ptr = strchr(Str2, '\'');
						*str_ptr = 0;
						templ = strtol(Str2, &tmptr, 10);
						if ((*tmptr) ||
							(templ < 1))
						{

                            ErrorMessage = "config file: given length " + std::string(Str2) + " for" + std::string(Str1) + " is not valid, should be larger than 0";
							fclose(SettingsFile);
							free(Str1);
							free(Str2);
							free(Str3);
							free(Str4);
							throw std::runtime_error(ErrorMessage);
						}

						j = templ;
						if (j != (IndexH - IndexL + 1))
						{

                            ErrorMessage = "config file: length " +  std::string(Str1) + " does not match to the given size";
							fclose(SettingsFile);
							free(Str1);
							free(Str2);
							free(Str3);
							free(Str4);
							throw std::runtime_error(ErrorMessage);
						}

						strncpy(Str3, str_ptr + 1, Max_Name_Length);
						strncpy(Str2, Str3, Max_Name_Length);
						
						//make space for curent input, the amount of bytes used
						Settings->InitialSim_Values[InputIndex] = (uint64_t*)calloc(Settings->InitialSim_InputsLength[InputIndex],sizeof(uint64_t));
						

						if (Str2[0] == 'h')
						{
							if(templ % 4 != 0){
                                ErrorMessage = "config file: length for hex number should be multiple of four";
								fclose(SettingsFile);
								free(Str1);
								free(Str2);
								free(Str3);
								free(Str4);
								throw std::runtime_error(ErrorMessage);
							}
							int ByteFull = templ / 4;
							uint8_t tmp_val = 0;
							for(j = 0; j < ByteFull; ++j){
								Str2[0] = Str1[strlen(Str1) - 1];
								Str2[1] = 0;
								Str1[strlen(Str1) - 1] = 0;

								//todo: maybe the byte order here is wrong
								tmp_val |= (strtol(Str2, NULL, 16) << (4*(j%2)));

								if((j > 0) && (j % 2)){
									
									Settings->InitialSim_Values[InputIndex][NumberOfBuffer_char] = tmp_val;
									NumberOfBuffer_char++;
									tmp_val = 0;
								}
								
							}

						}
						else if (Str2[0] == 'b')
						{
							
							int ByteFull = templ / 8;
							int ByteRemain =  templ % 8;
							uint8_t tmp_val;


							for(int FullIdx = 0; FullIdx < ByteFull; ++FullIdx){
								tmp_val = 0;
								for(int BitIdx = 0; BitIdx < 8; ++BitIdx){
									Str2[0] = Str1[strlen(Str1) - 1];
									Str2[1] = 0;
									Str1[strlen(Str1) - 1] = 0;

									v = strtol(Str2, NULL, 2);
									tmp_val |= (v << BitIdx);
								}
								Settings->InitialSim_Values[InputIndex][NumberOfBuffer_char] = tmp_val;
								NumberOfBuffer_char++;
							}

							tmp_val = 0;

							if(ByteRemain){
								for(int RemainIdx = 0; RemainIdx < ByteRemain; ++RemainIdx){
									Str2[0] = Str1[strlen(Str1) - 1];
									Str2[1] = 0;
									Str1[strlen(Str1) - 1] = 0;

									v = strtol(Str2, NULL, 2);
									tmp_val |= (v << RemainIdx);
								}
								Settings->InitialSim_Values[InputIndex][NumberOfBuffer_char] = tmp_val;
								NumberOfBuffer_char++;
							}

						}
						else
						{

                            ErrorMessage = "config file: base not known in " + std::string(Str1);
							fclose(SettingsFile);
							free(Str1);
							free(Str2);
							free(Str3);
							free(Str4);
							throw std::runtime_error(ErrorMessage);
						}

						Settings->InitialSim_IsInitialized[InputIndex] |= 1;
					}					
					else{

						/*
						*	Read group_inX and split into group_in , X (ShareIndex)
						*/
						strncpy(Str2, &Str1[8], Max_Name_Length);
						str_ptr = strchr(Str2, '[');
						if (str_ptr == NULL)
						{

                            ErrorMessage = "config file: wrong given input in " + std::string(Str1);
							fclose(SettingsFile);
							free(Str1);
							free(Str2);
							free(Str3);
							free(Str4);
							throw std::runtime_error(ErrorMessage);
						}
						*str_ptr = 0;
						templ = strtol(Str2, &tmptr, 10);
						if ((*tmptr) ||
							(templ < 0))
						{

                            ErrorMessage = "config file: given share index " +  std::string(Str2) + " for" + std::string(Str1) + " is not valid, should be larger or equal 0";
							fclose(SettingsFile);
							free(Str1);
							free(Str2);
							free(Str3);
							free(Str4);
							throw std::runtime_error(ErrorMessage);
						}
						ShareIndex = templ;

						/*
						*	parse last [x:y]
						*/


						str_ptr = strchr(Str1, '[');
						strncpy(Str1, str_ptr, Max_Name_Length);
						if ((Str1[0] == '[') && (Str1[strlen(Str1) - 1] == ']'))
                		{
                    		strncpy(Str2, Str1 + 1, Max_Name_Length);
                    		Str2[strlen(Str2) - 1] = 0;
                    		str_ptr = strchr(Str2, ':');
							if (str_ptr != NULL)
							{
								*str_ptr = 0;
								IndexH2 = atoi(Str2);
								IndexL2 = atoi(str_ptr + 1);
							}
							else
							{
								IndexH2 = atoi(Str2);
								IndexL2 = IndexH2;
							}

							//check if number of bytes is equal
							if(((IndexH2 - IndexL2 + 1 + 7)/8) != Settings->InitialSim_InputsLength[InputIndex]){
								ErrorMessage = "config file: in no_of_initial_inputs: length of input and length of associated bits in group do not match";
								fclose(SettingsFile);
								free(Str1);
								free(Str2);
								free(Str3);
								free(Str4);
								throw std::runtime_error(ErrorMessage);
							}


							Settings->InitialSim_Values[InputIndex] = (uint64_t*)calloc(IndexH2 - IndexL2 + 1, sizeof(uint64_t));
							for(int BitIndex = IndexL2; BitIndex < IndexH2 + 1; ++BitIndex){ //which nibbles of the groups will be selected IndexH2 + 1 - IndexL2 
								Settings->InitialSim_Values[InputIndex][BitIndex - IndexL2] = ShareIndex;
								Settings->InitialSim_Values[InputIndex][BitIndex - IndexL2] <<= 32;
								Settings->InitialSim_Values[InputIndex][BitIndex - IndexL2] |= IndexL2 + (BitIndex - IndexL2); // = BitIndex
							}

							Settings->InitialSim_IsInitialized[InputIndex] |= 0;
						}
					}

					Settings->InitialSim_NumberOfInputs++;
				}

			}
			
            SettingsFileCheckList |= (1 << 4);
        }
        else if (!strcmp(Str1, "end_condition"))
        {
            ReadNonCommentFromFile(SettingsFile, Str1, "%");

            if (!strcmp(Str1, "ClockCycles"))					//clock cycle is end condition
            {
                ReadNonCommentFromFile(SettingsFile, Str1, "%");
				templ = strtol(Str1, &tmptr, 10);
				if ((*tmptr) ||
					(templ < 1))
				{

					ErrorMessage = "config file: given end_condition ClockCycles " + std::string(Str1) + " is not valid, should be larger than 0";
					fclose(SettingsFile);
					free(Str1);
					free(Str2);
					free(Str3);
					free(Str4);
					throw std::runtime_error(ErrorMessage);
				}

                Settings->EndSimCondition_ClockCycles = templ;
				Settings->EndSimCondition_NumberOfSignals = 0;
            }
            else												// certain signal/register is end condition
            {
				Settings->EndSimCondition_ClockCycles = 0;

                if ((Str1[0] == '[') && (Str1[strlen(Str1) - 1] == ']'))
                {
                    strncpy(Str2, Str1 + 1, Max_Name_Length);
                    Str2[strlen(Str2) - 1] = 0;
                    str_ptr = strchr(Str2, ':');

					if (str_ptr != NULL)
					{
						*str_ptr = 0;
						templ = strtol(Str2, &tmptr, 10);
						if ((*tmptr) ||
							(templ < 0))
						{

							ErrorMessage = "config file: given statement " + std::string(Str2) + " is not valid, should be larger or equal 0";
							fclose(SettingsFile);
							free(Str1);
							free(Str2);
							free(Str3);
							free(Str4);
							throw std::runtime_error(ErrorMessage);
						}

						IndexH = templ;

						templ = strtol(str_ptr + 1, &tmptr, 10);
						if ((*tmptr) ||
							(templ < 0))
						{

							ErrorMessage = "config file: given statement " + std::string(str_ptr + 1) + " is not valid, should be larger or equal 0";
							fclose(SettingsFile);
							free(Str1);
							free(Str2);
							free(Str3);
							free(Str4);
							throw std::runtime_error(ErrorMessage);
						}

						IndexL = templ;
					}
					else
					{
						templ = strtol(Str2, &tmptr, 10);
						if ((*tmptr) ||
							(templ < 0))
						{

							ErrorMessage = "config file: given statement " + std::string(Str2) + " is not valid, should be larger or equal 0";
							fclose(SettingsFile);
							free(Str1);
							free(Str2);
							free(Str3);
							free(Str4);
							throw std::runtime_error(ErrorMessage);
						}

						IndexH = templ;
						IndexL = IndexH;
					}

                    ReadNonCommentFromFile(SettingsFile, Str1, "%");
                }
                else
                {
                    IndexL = -1;
                    IndexH = -1;
                }

				Settings->EndSimCondition_NumberOfSignals = 0;
                NumberOfBuffer_char = 0;

				//software case
				if(!(Settings->Hardware)){
					int RegisterIndex;
					if(!strcmp(Str1, "R0") || !strcmp(Str1, "r0")){
						RegisterIndex = 0;
					}
					else if(!strcmp(Str1, "R1") || !strcmp(Str1, "r1")){
						RegisterIndex = 1;
					}
					else if(!strcmp(Str1, "R2") || !strcmp(Str1, "r2")){
						RegisterIndex = 2;
					}
					else if(!strcmp(Str1, "R3") || !strcmp(Str1, "r3")){
						RegisterIndex = 3;
					}
					else if(!strcmp(Str1, "R4") || !strcmp(Str1, "r4")){
						RegisterIndex = 4;
					}
					else if(!strcmp(Str1, "R5") || !strcmp(Str1, "r5")){
						RegisterIndex = 5;
					}
					else if(!strcmp(Str1, "R6") || !strcmp(Str1, "r6")){
						RegisterIndex = 6;
					}
					else if(!strcmp(Str1, "R7") || !strcmp(Str1, "r7")){
						RegisterIndex = 7;
					}
					else if(!strcmp(Str1, "R8") || !strcmp(Str1, "r8")){
						RegisterIndex = 8;
					}
					else if(!strcmp(Str1, "R9") || !strcmp(Str1, "r9") || !strcmp(Str1, "SB")){
						RegisterIndex = 9;
					}
					else if(!strcmp(Str1, "R10") || !strcmp(Str1, "r10") || !strcmp(Str1, "SL")){
						RegisterIndex = 10;
					}
					else if(!strcmp(Str1, "R11") || !strcmp(Str1, "r11") || !strcmp(Str1, "FP")){
						RegisterIndex = 11;
					}
					else if(!strcmp(Str1, "R12") || !strcmp(Str1, "r12") || !strcmp(Str1, "IP")){
						RegisterIndex = 12;
					}
					else if(!strcmp(Str1, "R13") || !strcmp(Str1, "r13") || !strcmp(Str1, "SP")){
						RegisterIndex = 13;
					}
					else if(!strcmp(Str1, "R14") || !strcmp(Str1, "r14") || !strcmp(Str1, "LR")){
						RegisterIndex = 14;
					}
					else if(!strcmp(Str1, "R15") || !strcmp(Str1, "r15") || !strcmp(Str1, "PC")){
						RegisterIndex = 15;
					}
					else if(!strcmp(Str1, "R16") || !strcmp(Str1, "r16") || !strcmp(Str1, "PSR")){
						RegisterIndex = 16;
					}
					else{

						ErrorMessage = "config file: register " + std::string(Str1) + " as register not found";
						throw std::runtime_error(ErrorMessage);
					}

					Buffer_int = (int*)malloc((Settings->EndSimCondition_NumberOfSignals + 1) * sizeof(int));
					memcpy(Buffer_int, Settings->EndSimCondition_Signals, Settings->EndSimCondition_NumberOfSignals * sizeof(int));
					free(Settings->EndSimCondition_Signals);
					Settings->EndSimCondition_Signals = Buffer_int;
					Settings->EndSimCondition_Signals[Settings->EndSimCondition_NumberOfSignals] = RegisterIndex;
					Settings->EndSimCondition_NumberOfSignals++;

					ReadNonCommentFromFile(SettingsFile, Str1, "%");

					strncpy(Str2, Str1, Max_Name_Length);
					str_ptr = strchr(Str2, '\'');
					*str_ptr = 0;
					j = atoi(Str2);
					if (j != (IndexH - IndexL + 1))
					{

						ErrorMessage = "config file: length " + std::string(Str1) + " does not match to the given size";
						fclose(SettingsFile);
						free(Str1);
						free(Str2);
						free(Str3);
						free(Str4);
						throw std::runtime_error(ErrorMessage);
					}

					strncpy(Str3, str_ptr + 1, Max_Name_Length);
					strncpy(Str2, Str3, Max_Name_Length);


					if (Str2[0] == 'h')
					{

						Buffer_U64 = (uint64_t*)malloc(sizeof(uint64_t));
						memcpy(Buffer_U64, Settings->EndSimCondition_Values, NumberOfBuffer_char * sizeof(uint64_t));
						free(Settings->EndSimCondition_Values);
						Settings->EndSimCondition_Values = Buffer_U64;
						Settings->EndSimCondition_Values[NumberOfBuffer_char] = strtol(Str2+1, NULL, 16);
						NumberOfBuffer_char++;


					}
					else if (Str2[0] == 'b')
					{
						Buffer_U64 = (uint64_t*)malloc(sizeof(uint64_t));
						memcpy(Buffer_U64, Settings->EndSimCondition_Values, NumberOfBuffer_char * sizeof(uint64_t));
						free(Settings->EndSimCondition_Values);
						Settings->EndSimCondition_Values = Buffer_U64;
						Settings->EndSimCondition_Values[NumberOfBuffer_char] = strtol(Str2+1, NULL, 2);
						NumberOfBuffer_char++;

					}
					else
					{

						ErrorMessage = "config file: base not known in " + std::string(Str1);
						fclose(SettingsFile);
						free(Str1);
						free(Str2);
						free(Str3);
						free(Str4);
						throw std::runtime_error(ErrorMessage);
					}

					//if (NumberOfBuffer_char != Settings->EndSimCondition_NumberOfSignals)
					if(NumberOfBuffer_char != Settings->EndSimCondition_NumberOfSignals)
					{
						ErrorMessage = "config file: something is wrong in given initial inputs";
						fclose(SettingsFile);
						free(Str1);
						free(Str2);
						free(Str3);
						free(Str4);
						throw std::runtime_error(ErrorMessage);
					}
				}
				
            }

            SettingsFileCheckList |= (1 << 5);
        }
        else if (!strcmp(Str1, "probes_include"))
        {
			
           	ReadNonCommentFromFile(SettingsFile, Str1, "%");
			
			//all registers probed
			if (!strcmp(Str1, "all"))
			{
				uint32_t NrOfNormalProbes = Max_Num_Register * 32;
				uint32_t NrOfMemoryProbes = 32;
				uint32_t NrOfMemShadowProbes = 32;
				uint32_t NrOfHorizontalProbes = 18;
				uint32_t NrOfVerticalProbes = 32;
				uint32_t NrOfFullHRProbes = 1;
				uint32_t NrOfFullVRProbes = 32;
				
				Probes->NumberOfProbes = NrOfNormalProbes + NrOfMemoryProbes + NrOfMemShadowProbes + NrOfHorizontalProbes + NrOfVerticalProbes + NrOfFullHRProbes + NrOfFullVRProbes;
				Probes->Probes = (int*)malloc(Probes->NumberOfProbes * sizeof(int));
				Probes->ProbeName = (char**)malloc(Probes->NumberOfProbes * sizeof(char*));

				uint32_t offset = 0;
				uint32_t reg_idx = 0;
				uint32_t bit_idx = 0;
				
				//generate normal probes
				for(reg_idx = 0; reg_idx < Max_Num_Register; ++reg_idx){
					for(bit_idx = 0; bit_idx < 32; ++bit_idx){
						Probes->Probes[32*reg_idx +  bit_idx] = 32*reg_idx + bit_idx;
						sprintf(Str3, "R%u[%u]",reg_idx,bit_idx);
						Probes->ProbeName[32*reg_idx+bit_idx] = (char*)malloc((strlen(Str3)+1)*sizeof(char));
						strcpy(Probes->ProbeName[32*reg_idx+bit_idx], Str3);
					}
				}

				offset += Max_Num_Register * 32;
				
				//generate memory probes
				for(bit_idx = 0; bit_idx < 32; ++bit_idx){
					Probes->Probes[offset + bit_idx] = offset + bit_idx;
					sprintf(Str3, "MEM[%u]",bit_idx);
					Probes->ProbeName[offset + bit_idx] = (char*)malloc((strlen(Str3)+1)*sizeof(char));
					strcpy(Probes->ProbeName[offset + bit_idx], Str3);
				}

				offset += 32;
				

				//generate memory shadow register probes
				for(bit_idx = 0; bit_idx < 32; ++bit_idx){
					Probes->Probes[offset + bit_idx] = offset + bit_idx;
					sprintf(Str3, "MEMSHADOW[%u]",bit_idx);
					Probes->ProbeName[offset + bit_idx] = (char*)malloc((strlen(Str3)+1)*sizeof(char));
					strcpy(Probes->ProbeName[offset + bit_idx], Str3);
				}

				offset += 32;
				
				
				// Generate horizontal probes
				for(reg_idx = 0; reg_idx < NrOfHorizontalProbes; ++reg_idx){
					Probes->Probes[offset + reg_idx] = offset + reg_idx;
					sprintf(Str3, "HR%u", reg_idx);
					Probes->ProbeName[offset + reg_idx] = (char*)malloc((strlen(Str3)+1)*sizeof(char));
					strcpy(Probes->ProbeName[offset + reg_idx], Str3);
				}

				offset += NrOfHorizontalProbes;
				
				// Generate vertical probes
				for(bit_idx = 0; bit_idx < 32;  ++bit_idx){
					Probes->Probes[offset + bit_idx] = offset + bit_idx;
					sprintf(Str3, "VR[%u]",bit_idx);
					Probes->ProbeName[offset + bit_idx] = (char*)malloc((strlen(Str3)+1)*sizeof(char));
					strcpy(Probes->ProbeName[offset + bit_idx], Str3);
				}

				offset += 32;
				
				
				// Generate full horizontal probe
				Probes->Probes[offset] = offset;
				sprintf(Str3, "FULLHR");
				Probes->ProbeName[offset] = (char*)malloc((strlen(Str3)+1)*sizeof(char));
				strcpy(Probes->ProbeName[offset], Str3);

				offset += 1;
				
				// Generate full vertical probe
				for(bit_idx = 0; bit_idx < 32;  ++bit_idx){
					Probes->Probes[offset + bit_idx] = offset + bit_idx;
					sprintf(Str3, "FULLVR[%u]",bit_idx);
					Probes->ProbeName[offset + bit_idx] = (char*)malloc((strlen(Str3)+1)*sizeof(char));
					strcpy(Probes->ProbeName[offset + bit_idx], Str3);
				}
									
			}
			//subset of registers probed
			else
			{
				NumberOfItems = atoi(Str1); //we have NumberOfItems Probes
				uint32_t offset = 0;
				Probes->NumberOfProbes = 0;
				uint32_t NrOfNormalProbes = 32;
				uint32_t NrOfMemoryProbes = 32;
				uint32_t NrOfMemShadowProbes = 32;
				uint32_t NrOfHorizontalProbes = 18;
				uint32_t NrOfVerticalProbes = 32;
				uint32_t NrOfFullHRProbes = 1;
				uint32_t NrOfFullVRProbes = 32;
				uint32_t reg_idx = 0;
				uint32_t bit_idx = 0;
				//add all probes to list
				for(i = 0; i < NumberOfItems; ++i){
					ReadNonCommentFromFile(SettingsFile, Str1, "%");

					//full register probed
					if(strchr(Str1, '[') == NULL){
						v = 0;
						while(Str1[v]){
							Str1[v] = toupper(Str1[v]);
							v++;
						}

						//horizontal probe
						if(!strncmp(Str1, "HR", 2)){
							Probes->NumberOfProbes += NrOfHorizontalProbes;

							Buffer_int = (int *)malloc((Probes->NumberOfProbes) * sizeof(int));
							memcpy(Buffer_int, Probes->Probes, (Probes->NumberOfProbes - NrOfHorizontalProbes) * sizeof(int));
							free(Probes->Probes);
							Probes->Probes = Buffer_int;

							Buffer_string = (char**)malloc((Probes->NumberOfProbes) * sizeof(char*));
							memcpy(Buffer_string, Probes->ProbeName, (Probes->NumberOfProbes - NrOfHorizontalProbes) * sizeof(char*));
							free(Probes->ProbeName);
							Probes->ProbeName = Buffer_string;

							for(reg_idx = 0; reg_idx < NrOfHorizontalProbes; ++reg_idx){
								Probes->Probes[Probes->NumberOfProbes - NrOfHorizontalProbes + reg_idx] = Probes->NumberOfProbes - NrOfHorizontalProbes + reg_idx;
								sprintf(Str3, "HR%u", reg_idx);
								Probes->ProbeName[Probes->NumberOfProbes - NrOfHorizontalProbes + reg_idx] = (char*)malloc((strlen(Str3)+1)*sizeof(char));
								strcpy(Probes->ProbeName[Probes->NumberOfProbes - NrOfHorizontalProbes + reg_idx], Str3);
							}
							offset += NrOfHorizontalProbes;
						}
						//vertical probe
						else if(!strncmp(Str1, "VR", 2)){
							Probes->NumberOfProbes += NrOfVerticalProbes;

							Buffer_int = (int *)malloc((Probes->NumberOfProbes) * sizeof(int));
							memcpy(Buffer_int, Probes->Probes, (Probes->NumberOfProbes - NrOfVerticalProbes) * sizeof(int));
							free(Probes->Probes);
							Probes->Probes = Buffer_int;

							Buffer_string = (char**)malloc((Probes->NumberOfProbes) * sizeof(char*));
							memcpy(Buffer_string, Probes->ProbeName, (Probes->NumberOfProbes - NrOfVerticalProbes) * sizeof(char*));
							free(Probes->ProbeName);
							Probes->ProbeName = Buffer_string;

							for(bit_idx = 0; bit_idx < 32;  ++bit_idx){
								Probes->Probes[Probes->NumberOfProbes - NrOfVerticalProbes + bit_idx] = Probes->NumberOfProbes - NrOfVerticalProbes + bit_idx;
								sprintf(Str3, "VR[%u]",bit_idx);
								Probes->ProbeName[Probes->NumberOfProbes - NrOfVerticalProbes + bit_idx] = (char*)malloc((strlen(Str3)+1)*sizeof(char));
								strcpy(Probes->ProbeName[Probes->NumberOfProbes - NrOfVerticalProbes + bit_idx], Str3);
							}

							offset += 32;
						}
						//memory probe
						else if(!strcmp(Str1, "MEM") && (strlen(Str1) < 4)){
							Probes->NumberOfProbes += NrOfMemoryProbes;
							Buffer_int = (int *)malloc((Probes->NumberOfProbes) * sizeof(int));
							memcpy(Buffer_int, Probes->Probes, (Probes->NumberOfProbes - NrOfMemoryProbes) * sizeof(int));
							free(Probes->Probes);
							Probes->Probes = Buffer_int;

							Buffer_string = (char**)malloc((Probes->NumberOfProbes) * sizeof(char*));
							memcpy(Buffer_string, Probes->ProbeName, (Probes->NumberOfProbes - NrOfMemoryProbes) * sizeof(char*));
							free(Probes->ProbeName);
							Probes->ProbeName = Buffer_string;

							for(bit_idx = 0; bit_idx < 32; ++bit_idx){
								Probes->Probes[Probes->NumberOfProbes - NrOfMemoryProbes + bit_idx] = Probes->NumberOfProbes - NrOfMemoryProbes + bit_idx;
								sprintf(Str3, "MEM[%u]",bit_idx);
								Probes->ProbeName[Probes->NumberOfProbes - NrOfMemoryProbes + bit_idx] = (char*)malloc((strlen(Str3)+1)*sizeof(char));
								strcpy(Probes->ProbeName[Probes->NumberOfProbes - NrOfMemoryProbes + bit_idx], Str3);
							}

							offset += 32;
						}
						//memory shadow register
						else if(!strcmp(Str1, "MEMSHADOW")){
							Probes->NumberOfProbes += NrOfMemShadowProbes;
							Buffer_int = (int *)malloc((Probes->NumberOfProbes) * sizeof(int));
							memcpy(Buffer_int, Probes->Probes, (Probes->NumberOfProbes - NrOfMemShadowProbes) * sizeof(int));
							free(Probes->Probes);
							Probes->Probes = Buffer_int;

							Buffer_string = (char**)malloc((Probes->NumberOfProbes) * sizeof(char*));
							memcpy(Buffer_string, Probes->ProbeName, (Probes->NumberOfProbes - NrOfMemShadowProbes) * sizeof(char*));
							free(Probes->ProbeName);
							Probes->ProbeName = Buffer_string;

							for(bit_idx = 0; bit_idx < 32; ++bit_idx){
								Probes->Probes[Probes->NumberOfProbes - NrOfMemShadowProbes + bit_idx] = Probes->NumberOfProbes - NrOfMemShadowProbes + bit_idx;
								sprintf(Str3, "MEMSHADOW[%u]",bit_idx);
								Probes->ProbeName[Probes->NumberOfProbes - NrOfMemShadowProbes + bit_idx] = (char*)malloc((strlen(Str3)+1)*sizeof(char));
								strcpy(Probes->ProbeName[Probes->NumberOfProbes - NrOfMemShadowProbes + bit_idx], Str3);
							}

							offset += 32;
						}
						//full horizontal
						else if(!strcmp(Str1, "FULLHR")){

							Probes->NumberOfProbes += NrOfFullHRProbes;
							Buffer_int = (int *)malloc((Probes->NumberOfProbes) * sizeof(int));
							memcpy(Buffer_int, Probes->Probes, (Probes->NumberOfProbes - NrOfFullHRProbes) * sizeof(int));
							free(Probes->Probes);
							Probes->Probes = Buffer_int;

							Buffer_string = (char**)malloc((Probes->NumberOfProbes) * sizeof(char*));
							memcpy(Buffer_string, Probes->ProbeName, (Probes->NumberOfProbes - NrOfFullHRProbes) * sizeof(char*));
							free(Probes->ProbeName);
							Probes->ProbeName = Buffer_string;

							Probes->Probes[Probes->NumberOfProbes - NrOfFullHRProbes] = Probes->NumberOfProbes - NrOfFullHRProbes;
							sprintf(Str3, "FULLHR");
							Probes->ProbeName[Probes->NumberOfProbes - NrOfFullHRProbes] = (char*)malloc((strlen(Str3)+1)*sizeof(char));
							strcpy(Probes->ProbeName[Probes->NumberOfProbes - NrOfFullHRProbes], Str3);

							offset += 1;
						}
						//full vertical
						else if(!strcmp(Str1, "FULLVR")){
							Probes->NumberOfProbes += NrOfFullVRProbes;
							Buffer_int = (int *)malloc((Probes->NumberOfProbes) * sizeof(int));
							memcpy(Buffer_int, Probes->Probes, (Probes->NumberOfProbes - NrOfFullVRProbes) * sizeof(int));
							free(Probes->Probes);
							Probes->Probes = Buffer_int;

							Buffer_string = (char**)malloc((Probes->NumberOfProbes) * sizeof(char*));
							memcpy(Buffer_string, Probes->ProbeName, (Probes->NumberOfProbes - NrOfFullVRProbes) * sizeof(char*));
							free(Probes->ProbeName);
							Probes->ProbeName = Buffer_string;

							for(bit_idx = 0; bit_idx < 32;  ++bit_idx){
								Probes->Probes[Probes->NumberOfProbes - NrOfFullVRProbes + bit_idx] = Probes->NumberOfProbes - NrOfFullVRProbes + bit_idx;
								sprintf(Str3, "FULLVR[%u]",bit_idx);
								Probes->ProbeName[Probes->NumberOfProbes - NrOfFullVRProbes + bit_idx] = (char*)malloc((strlen(Str3)+1)*sizeof(char));
								strcpy(Probes->ProbeName[Probes->NumberOfProbes - NrOfFullVRProbes + bit_idx], Str3);
							}

							offset += 32;
						}
						//standard probes
						else{
							Probes->NumberOfProbes += NrOfNormalProbes;
							Buffer_int = (int *)malloc((Probes->NumberOfProbes) * sizeof(int));
							memcpy(Buffer_int, Probes->Probes, (Probes->NumberOfProbes - NrOfNormalProbes) * sizeof(int));
							free(Probes->Probes);
							Probes->Probes = Buffer_int;

							Buffer_string = (char**)malloc((Probes->NumberOfProbes) * sizeof(char*));
							memcpy(Buffer_string, Probes->ProbeName, (Probes->NumberOfProbes - NrOfNormalProbes) * sizeof(char*));
							free(Probes->ProbeName);
							Probes->ProbeName = Buffer_string;

							if((Str1[0] == 'R')){
								for( bit_idx = 0; bit_idx < 32; ++bit_idx){
									sprintf(Str3, "%s[%u]",Str1,bit_idx);
									Probes->ProbeName[(Probes->NumberOfProbes-32)+bit_idx] = (char*)malloc((strlen(Str3)+1)*sizeof(char));
									strcpy(Probes->ProbeName[(Probes->NumberOfProbes-32)+bit_idx], Str3);
								}

							}
							else if(!strcmp(Str1,"SB")){
								for( bit_idx = 0; bit_idx < 32; ++bit_idx){
									sprintf(Str3, "R9[%u]",bit_idx);
									Probes->ProbeName[(Probes->NumberOfProbes-32)+bit_idx] = (char*)malloc((strlen(Str3)+1)*sizeof(char));
									strcpy(Probes->ProbeName[(Probes->NumberOfProbes-32)+bit_idx], Str3);
								}
							}
							else if(!strcmp(Str1,"SL")){
								for( bit_idx = 0; bit_idx < 32; ++bit_idx){
									sprintf(Str3, "R10[%u]",bit_idx);
									Probes->ProbeName[(Probes->NumberOfProbes-32)+bit_idx] = (char*)malloc((strlen(Str3)+1)*sizeof(char));
									strcpy(Probes->ProbeName[(Probes->NumberOfProbes-32)+bit_idx], Str3);
								}
							}
							else if(!strcmp(Str1,"FP")){
								for( bit_idx = 0; bit_idx < 32; ++bit_idx){
									sprintf(Str3, "R11[%u]",bit_idx);
									Probes->ProbeName[(Probes->NumberOfProbes-32)+bit_idx] = (char*)malloc((strlen(Str3)+1)*sizeof(char));
									strcpy(Probes->ProbeName[(Probes->NumberOfProbes-32)+bit_idx], Str3);
								}
							}
							else if(!strcmp(Str1,"IP")){
								for( bit_idx = 0; bit_idx < 32; ++bit_idx){
									sprintf(Str3, "R12[%u]",bit_idx);
									Probes->ProbeName[(Probes->NumberOfProbes-32)+bit_idx] = (char*)malloc((strlen(Str3)+1)*sizeof(char));
									strcpy(Probes->ProbeName[(Probes->NumberOfProbes-32)+bit_idx], Str3);
								}
							}
							else if(!strcmp(Str1,"SP")){
								for( bit_idx = 0; bit_idx < 32; ++bit_idx){
									sprintf(Str3, "R13[%u]",bit_idx);
									Probes->ProbeName[(Probes->NumberOfProbes-32)+bit_idx] = (char*)malloc((strlen(Str3)+1)*sizeof(char));
									strcpy(Probes->ProbeName[(Probes->NumberOfProbes-32)+bit_idx], Str3);
								}
							}
							else if(!strcmp(Str1, "LR")){
								for( bit_idx = 0; bit_idx < 32; ++bit_idx){
									sprintf(Str3, "R14[%u]",bit_idx);
									Probes->ProbeName[(Probes->NumberOfProbes-32)+bit_idx] = (char*)malloc((strlen(Str3)+1)*sizeof(char));
									strcpy(Probes->ProbeName[(Probes->NumberOfProbes-32)+bit_idx], Str3);
								}
							}
							else if(!strcmp(Str1, "PC")){
								for( bit_idx = 0; bit_idx < 32; ++bit_idx){
									sprintf(Str3, "R15[%u]",bit_idx);
									Probes->ProbeName[(Probes->NumberOfProbes-32)+bit_idx] = (char*)malloc((strlen(Str3)+1)*sizeof(char));
									strcpy(Probes->ProbeName[(Probes->NumberOfProbes-32)+bit_idx], Str3);
								}
							}
							else if(!strcmp(Str1, "PSR")){
								for( bit_idx = 0; bit_idx < 32; ++bit_idx){
									sprintf(Str3, "R16[%u]",bit_idx);
									Probes->ProbeName[(Probes->NumberOfProbes-32)+bit_idx] = (char*)malloc((strlen(Str3)+1)*sizeof(char));
									strcpy(Probes->ProbeName[(Probes->NumberOfProbes-32)+bit_idx], Str3);
								}
							}
							else{
								ErrorMessage = "Register " + std::string(Str1) + " unknown";
								throw std::runtime_error(ErrorMessage);
							}


						}
							
					}
					//only certain bits of register probed
					else{

						//want in str1; RX
						//want in str2 y from [y]
						str_ptr = strstr(Str1, "[");
						*str_ptr = 0;
						str_ptr += 1;
						str_ptr[strlen(str_ptr)-1] = 0;

						v = 0;
						while(Str1[v]){
							Str1[v] = toupper(Str1[v]);
							v++;
						}

						Probes->NumberOfProbes += 1;

						Buffer_int = (int *)malloc((Probes->NumberOfProbes) * sizeof(int));
						memcpy(Buffer_int, Probes->Probes, (Probes->NumberOfProbes - 1) * sizeof(int));
						free(Probes->Probes);
						Probes->Probes = Buffer_int;

						Buffer_string = (char**)malloc((Probes->NumberOfProbes) * sizeof(char*));
						memcpy(Buffer_string, Probes->ProbeName, (Probes->NumberOfProbes - 1) * sizeof(char*));
						free(Probes->ProbeName);
						Probes->ProbeName = Buffer_string;

						Probes->Probes[Probes->NumberOfProbes - 1] = Probes->NumberOfProbes - 1;

						
						if((Str1[0] == 'R')){
							sprintf(Str3, "%s[%s]",Str1,str_ptr);
							Probes->ProbeName[Probes->NumberOfProbes - 1] = (char*)malloc((strlen(Str3)+1)*sizeof(char));
							memcpy(Probes->ProbeName[Probes->NumberOfProbes - 1], Str3, strlen(Str3)+1);
						}
						else if(!strcmp(Str1,"SB")){
							sprintf(Str3, "R9[%s]",str_ptr);
							Probes->ProbeName[Probes->NumberOfProbes - 1] = (char*)malloc((strlen(Str3)+1)*sizeof(char));
							memcpy(Probes->ProbeName[Probes->NumberOfProbes - 1], Str3, strlen(Str3)+1);
						}
						else if(!strcmp(Str1,"SL")){
							sprintf(Str3, "R10[%s]",str_ptr);
							Probes->ProbeName[Probes->NumberOfProbes - 1] = (char*)malloc((strlen(Str3)+1)*sizeof(char));
							memcpy(Probes->ProbeName[Probes->NumberOfProbes - 1], Str3, strlen(Str3)+1);
						}
						else if(!strcmp(Str1,"FP")){
							sprintf(Str3, "R11[%s]",str_ptr);
							Probes->ProbeName[Probes->NumberOfProbes - 1] = (char*)malloc((strlen(Str3)+1)*sizeof(char));
							memcpy(Probes->ProbeName[Probes->NumberOfProbes - 1], Str3, strlen(Str3)+1);
						}
						else if(!strcmp(Str1,"IP")){
							sprintf(Str3, "R12[%s]",str_ptr);
							Probes->ProbeName[Probes->NumberOfProbes - 1] = (char*)malloc((strlen(Str3)+1)*sizeof(char));
							memcpy(Probes->ProbeName[Probes->NumberOfProbes - 1], Str3, strlen(Str3)+1);
						}
						else if(!strcmp(Str1,"SP")){
							sprintf(Str3, "R13[%s]",str_ptr);
							Probes->ProbeName[Probes->NumberOfProbes - 1] = (char*)malloc((strlen(Str3)+1)*sizeof(char));
							memcpy(Probes->ProbeName[Probes->NumberOfProbes - 1], Str3, strlen(Str3)+1);
						}
						else if(!strcmp(Str1, "LR")){
							sprintf(Str3, "R14[%s]",str_ptr);
							Probes->ProbeName[Probes->NumberOfProbes - 1] = (char*)malloc((strlen(Str3)+1)*sizeof(char));
							memcpy(Probes->ProbeName[Probes->NumberOfProbes - 1], Str3, strlen(Str3)+1);
						}
						else if(!strcmp(Str1, "PC")){
							
							sprintf(Str3, "R15[%s]",str_ptr);
							Probes->ProbeName[Probes->NumberOfProbes - 1] = (char*)malloc((strlen(Str3)+1)*sizeof(char));
							memcpy(Probes->ProbeName[Probes->NumberOfProbes - 1], Str3, strlen(Str3)+1);
						}
						else if(!strcmp(Str1, "PSR")){
							sprintf(Str3, "R16[%s]",str_ptr);
							Probes->ProbeName[Probes->NumberOfProbes - 1] = (char*)malloc((strlen(Str3)+1)*sizeof(char));
							memcpy(Probes->ProbeName[Probes->NumberOfProbes - 1], Str3, strlen(Str3)+1);
						}
						else if(!strcmp(Str1, "VR")){
							sprintf(Str3, "VR[%s]",str_ptr);
							Probes->ProbeName[Probes->NumberOfProbes - 1] = (char*)malloc((strlen(Str3)+1)*sizeof(char));
							memcpy(Probes->ProbeName[Probes->NumberOfProbes - 1], Str3, strlen(Str3)+1);	
						}
						else if((!strcmp(Str1, "MEM")) && (strlen(Str1) < 4)){
							sprintf(Str3, "MEM[%s]",str_ptr);
							Probes->ProbeName[Probes->NumberOfProbes - 1] = (char*)malloc((strlen(Str3)+1)*sizeof(char));
							memcpy(Probes->ProbeName[Probes->NumberOfProbes - 1], Str3, strlen(Str3)+1);
						}
						else if(!strcmp(Str1, "MEMSHADOW")){
							sprintf(Str3, "MEMSHADOW[%s]",str_ptr);
							Probes->ProbeName[Probes->NumberOfProbes - 1] = (char*)malloc((strlen(Str3)+1)*sizeof(char));
							memcpy(Probes->ProbeName[Probes->NumberOfProbes - 1], Str3, strlen(Str3)+1);	
						}
						else if(!strcmp(Str1, "FULLVR")){
							sprintf(Str3, "FULLVR[%s]",str_ptr);
							Probes->ProbeName[Probes->NumberOfProbes - 1] = (char*)malloc((strlen(Str3)+1)*sizeof(char));
							memcpy(Probes->ProbeName[Probes->NumberOfProbes - 1], Str3, strlen(Str3)+1);			
						}
						else{
							ErrorMessage = "Register " + std::string(Str1) + " unknown";
							throw std::runtime_error(ErrorMessage);
						}
					}
				}
			}
		


            SettingsFileCheckList |= (1 << 6);
        }
        else if (!strcmp(Str1, "probes_exclude"))
        {
			
			ReadNonCommentFromFile(SettingsFile, Str1, "%");
			NumberOfItems = atoi(Str1);

			//exclude all probes -> free memory and let all pointers point to nullptr
			if(!(strcmp(Str1, "all"))){
				for(i = 0; i < Probes->NumberOfProbes; ++i){
					free(Probes->ProbeName[i]);
				}
				free(Probes->Probes);
				free(Probes->ProbeName);
				Probes->Probes = nullptr;
				Probes->ProbeName = nullptr;
			}
			else if((strcmp(Str1, "0"))){ //delete at least one bit/register
				for(i = 0; i < NumberOfItems; ++i){ //mark to delete probes in ProbesStruct, set Probes->Probes to -1 and Probes->ProbeName to "#"
					
					ReadNonCommentFromFile(SettingsFile, Str1, "%"); //read probe to exclude
					//decide if whole register has to be removed or single bits
					if(strchr(Str1, '[') == NULL){	//remove whole register
						v = 0;
						while(Str1[v]){
							Str1[v] = toupper(Str1[v]);
							v++;
						}
						if((Str1[0] == 'R')){
							sprintf(Str4, "%s",Str1);
							sprintf(Str1, "%s", Str4);
						}
						else if(!strcmp(Str1,"SB")){
							sprintf(Str1, "R9");
						}
						else if(!strcmp(Str1,"SL")){
							sprintf(Str1, "R10");
						}
						else if(!strcmp(Str1,"FP")){
							sprintf(Str1, "R11");
						}
						else if(!strcmp(Str1,"IP")){
							sprintf(Str1, "R12");
						}
						else if(!strcmp(Str1,"SP")){
							sprintf(Str1, "R13");
						}
						else if(!strcmp(Str1, "LR")){
							sprintf(Str1, "R14");
						}
						else if(!strcmp(Str1, "PC")){
							sprintf(Str1, "R15");
						}
						else if(!strcmp(Str1, "PSR")){
							sprintf(Str1, "R16");
						}
						else if(!strcmp(Str1, "VR")){
							sprintf(Str1, "VR");
						}
						else if((!(strcmp(Str1, "MEM"))) && (strlen(Str1) < 4)){
							sprintf(Str1, "MEM");
						}
						else if(!strcmp(Str1, "MEMSHADOW")){
							sprintf(Str1, "MEMSHADOW");
						}
						else if((!strcmp(Str1, "FULLVR")) && (strlen(Str1) == 6)){
							sprintf(Str1, "FULLVR");
						}
						else if((!strcmp(Str1, "FULLHR")) && (strlen(Str1) == 6)){
							sprintf(Str1, "FULLHR");
						}
						else if(!strncmp(Str1, "HR", strlen("HR")) && (strlen(Str1) == 2)){ //all horizontal probes will be deleted
							sprintf(Str1, "HR");
						}
						else if(!strncmp(Str1, "HR", strlen("HR")) && (strlen(Str1) > 2)){ //only specific horizontal probe will be deleted
							sprintf(Str4, "%s", Str1);
							sprintf(Str1, "%s", Str4);
						}							
						else{
							ErrorMessage = "Register " + std::string(Str1) + " unknown";
							throw std::runtime_error(ErrorMessage);
						}
						sprintf(Str2, "%s", Str1);
						sprintf(Str4, "%s[", Str1);
						sprintf(Str1, "%s", Str4);
						for(j = 0; j < Probes->NumberOfProbes; ++j){
							if(!strncmp(Probes->ProbeName[j], Str1, strlen(Str1))){
								strncpy(Probes->ProbeName[j], "#", strlen(Probes->ProbeName[j]));
								Probes->Probes[j] = -1;
							}
							if(!strncmp(Str2, "HR", strlen("HR")) && (strlen(Str2) == 2)){
								if(!strncmp(Probes->ProbeName[j], Str2, strlen(Str2))){
									strncpy(Probes->ProbeName[j], "#", strlen(Probes->ProbeName[j]));
									Probes->Probes[j] = -1;
								}
							}
							if(!strncmp(Str2, "HR", strlen("HR")) && (strlen(Str2) > 2)){
								if(!strncmp(Probes->ProbeName[j], Str2, strlen(Str2))){
									strncpy(Probes->ProbeName[j], "#", strlen(Probes->ProbeName[j]));
									Probes->Probes[j] = -1;
								}
							}

							if((!strcmp(Str2, "FULLHR")) && (strlen(Str2) == 6)){
								if(!strncmp(Probes->ProbeName[j], Str2, strlen(Str2))){
									strncpy(Probes->ProbeName[j], "#", strlen(Probes->ProbeName[j]));
									Probes->Probes[j] = -1;
								}
							}

						}
					}
					else{ //remove specific bit in register

						str_ptr = strstr(Str1, "[");
						*str_ptr = 0;
						str_ptr += 1;
						str_ptr[strlen(str_ptr)-1] = 0;
						v = 0;
						while(Str1[v]){
							Str1[v] = toupper(Str1[v]);
							v++;
						}

						if((Str1[0] == 'R')){
							sprintf(Str3, "%s[%s]",Str1,str_ptr);
						}
						else if(!strcmp(Str1,"SB")){
							sprintf(Str3, "R9[%s]",str_ptr);
						}
						else if(!strcmp(Str1,"SL")){
							sprintf(Str3, "R10[%s]",str_ptr);
						}
						else if(!strcmp(Str1,"FP")){
							sprintf(Str3, "R11[%s]",str_ptr);
						}
						else if(!strcmp(Str1,"IP")){
							sprintf(Str3, "R12[%s]",str_ptr);
						}
						else if(!strcmp(Str1,"SP")){
							sprintf(Str3, "R13[%s]",str_ptr);
						}
						else if(!strcmp(Str1, "LR")){
							sprintf(Str3, "R14[%s]",str_ptr);
						}
						else if(!strcmp(Str1, "PC")){
							sprintf(Str3, "R15[%s]",str_ptr);
						}
						else if(!strcmp(Str1, "PSR")){
							sprintf(Str3, "R16[%s]",str_ptr);
						}
						else if(!strcmp(Str1, "VR")){
							sprintf(Str3, "VR[%s]", str_ptr);
						}
						else if((!strcmp(Str1, "MEM")) && (!strncmp(Str1, "MEM", strlen("MEM")))){
							sprintf(Str3, "MEM");
							sprintf(Str2, "MEM[%s]", str_ptr); 
						}
						else if(!strcmp(Str1, "MEMSHADOW")){
							sprintf(Str3, "MEMSHADOW[%s]", str_ptr);
						}
						else if(!strcmp(Str1, "FULLVR")){
							sprintf(Str3, "FULLVR[%s]", str_ptr);
						}
						else{
							ErrorMessage = "Register " + std::string(Str1) + " unknown";
							throw std::runtime_error(ErrorMessage);
						}
						for(j = 0; j < Probes->NumberOfProbes; ++j){
							if(!strncmp(Probes->ProbeName[j], Str3, strlen(Str3))){
								strncpy(Probes->ProbeName[j], "#", strlen(Probes->ProbeName[j]));
								Probes->Probes[j] = -1;
							}

						}
					}
				}
				uint32_t new_position = 0;

				//remove all to delete probes and resize ProbesStruct
				for(i = 0; i < Probes->NumberOfProbes; ++i){
					if((strcmp(Probes->ProbeName[i], "#") == 0)){
						continue;
					}
					if(new_position != static_cast<uint32_t>(i)){
						Probes->ProbeName[new_position] = Probes->ProbeName[i];
						Probes->Probes[new_position] = Probes->Probes[i];
					}
					new_position++;
				}
				//resize
				Probes->NumberOfProbes = new_position;
				Probes->ProbeName = (char**)realloc(Probes->ProbeName, new_position*sizeof(char*));
				for(i = 0; i < static_cast<int>(new_position); ++i){
					Probes->Probes[i] = i;
				}
			}
			
			sort(Probes->ProbeName, Probes->NumberOfProbes);


            SettingsFileCheckList |= (1 << 7);
        }
		else if (!strcmp(Str1, "multivariate_test"))
		{
			ReadNonCommentFromFile(SettingsFile, Str1, "%");
			if (!strcmp(Str1, "no"))
				Settings->TestMultivariate = 0;
			else if (!strcmp(Str1, "yes"))
				Settings->TestMultivariate = 1;
			else if (!strcmp(Str1, "exclusive"))
				Settings->TestMultivariate = 2;
			else
			{

				fclose(SettingsFile);
				free(Str1);
				free(Str2);
				free(Str3);
				free(Str4);
				ErrorMessage = "config file: given value for multivariate_test is not valid, can be only no, or, yes, exclusive";
				throw std::runtime_error(ErrorMessage);
			}

			SettingsFileCheckList |= (1 << 8);
		}
		else if (!strcmp(Str1, "transitional_leakage"))
		{
			ReadNonCommentFromFile(SettingsFile, Str1, "%");
			if (!strcmp(Str1, "no"))
				Settings->TestTransitional = 0;
			else if (!strcmp(Str1, "yes"))
				Settings->TestTransitional = 1;
			else
			{

				ErrorMessage = "config file: given value for transitional_leakage is not valid, can be only no or yes";
				fclose(SettingsFile);
				free(Str1);
				free(Str2);
				free(Str3);
				free(Str4);
				throw std::runtime_error(ErrorMessage);
			}

			SettingsFileCheckList |= (1 << 9);
		}
		else if (!strcmp(Str1, "no_of_test_clock_cycles"))
		{
			ReadNonCommentFromFile(SettingsFile, Str1, "%");
			templ = strtol(Str1, &tmptr, 10);
			if ((*tmptr) ||
				(templ < 1))
			{
				ErrorMessage = "config file: given value of no_of_test_clock_cycles " + std::string(Str1) + " is not valid, should be larger than 0";
				fclose(SettingsFile);
				free(Str1);
				free(Str2);
				free(Str3);
				free(Str4);
				throw std::runtime_error(ErrorMessage);
			}

			NumberOfEntries = templ;

			Settings->NumberOfTestClockCycles = 0;
			Settings->TestClockCycles = NULL;
			for (EntryIndex = 0;EntryIndex < NumberOfEntries;EntryIndex++)
			{
				ReadNonCommentFromFile(SettingsFile, Str1, "%");
				str_ptr = strchr(Str1, '-');
				if (str_ptr == NULL)
				{
					Buffer_int = (int*)malloc((Settings->NumberOfTestClockCycles + 1) * sizeof(int));
					memcpy(Buffer_int, Settings->TestClockCycles, Settings->NumberOfTestClockCycles * sizeof(int));
					free(Settings->TestClockCycles);
					Settings->TestClockCycles = Buffer_int;
					templ = strtol(Str1, &tmptr, 10);
					if ((*tmptr) ||
						(templ < 1))
					{

						ErrorMessage = "config file: given value " + std::string(Str1) + " for one of the test clock cycles is not valid, should be larger than 0";
						fclose(SettingsFile);
						free(Str1);
						free(Str2);
						free(Str3);
						free(Str4);
						throw std::runtime_error(ErrorMessage);
					}

					if(!(Settings->Hardware)){
						Settings->TestClockCycles[Settings->NumberOfTestClockCycles] = templ - 1;
					}
					else{
						Settings->TestClockCycles[Settings->NumberOfTestClockCycles] = templ;
					}
					

					if (Settings->TestClockCycles[Settings->NumberOfTestClockCycles] > Settings->Max_No_ClockCycles)
					{

						ErrorMessage = "config file: given value " + std::string(Str1) +  " for one of the test clock cycles is bigger than \"max_clock_cycle\"";
						fclose(SettingsFile);
						free(Str1);
						free(Str2);
						free(Str3);
						free(Str4);
						throw std::runtime_error(ErrorMessage);
					}

					Settings->NumberOfTestClockCycles++;
				}
				else
				{
					strncpy(Str3, Str1, Max_Name_Length);
					strncpy(Str2, str_ptr + 1, Max_Name_Length);
					*str_ptr = 0;

					templ = strtol(Str1, &tmptr, 10);
					if ((*tmptr) ||
						(templ < 1))
					{
						ErrorMessage = "config file: given value " + std::string(Str1) + " in " + std::string(Str3) + " for one of the test clock cycles is not valid, should be larger than 0";
						fclose(SettingsFile);
						free(Str1);
						free(Str2);
						free(Str3);
						free(Str4);
						throw std::runtime_error(ErrorMessage);
					}

					IndexL = templ;

					templ = strtol(Str2, &tmptr, 10);
					if ((*tmptr) ||
						(templ < 1))
					{

						ErrorMessage = "config file: given value " + std::string(Str2) + " in " + std::string(Str3) + " for one of the test clock cycles is not valid, should be larger than 0";
						fclose(SettingsFile);
						free(Str1);
						free(Str2);
						free(Str3);
						free(Str4);
						throw std::runtime_error(ErrorMessage);
					}

					IndexH = templ;

					if (IndexL > IndexH)
					{

						ErrorMessage = "config file: given value " + std::string(Str3) + " for one of the test clock cycles is not valid";
						fclose(SettingsFile);
						free(Str1);
						free(Str2);
						free(Str3);
						free(Str4);
						throw std::runtime_error(ErrorMessage);
					}

					for (ClockCycle = IndexL;ClockCycle <= IndexH;ClockCycle++)
					{
						if (ClockCycle > Settings->Max_No_ClockCycles)
						{

							ErrorMessage = "config file: given value " +  std::to_string(ClockCycle) + " for one of the test clock cycles is bigger than \"max_clock_cycle\"";
							fclose(SettingsFile);
							free(Str1);
							free(Str2);
							free(Str3);
							free(Str4);
							throw std::runtime_error(ErrorMessage);
						}

						Buffer_int = (int*)malloc((Settings->NumberOfTestClockCycles + 1) * sizeof(int));
						memcpy(Buffer_int, Settings->TestClockCycles, Settings->NumberOfTestClockCycles * sizeof(int));
						free(Settings->TestClockCycles);
						Settings->TestClockCycles = Buffer_int;
						if(!(Settings->Hardware)){
							Settings->TestClockCycles[Settings->NumberOfTestClockCycles] = ClockCycle - 1;
						}
						else{
							Settings->TestClockCycles[Settings->NumberOfTestClockCycles] = ClockCycle;
						}
						
						Settings->NumberOfTestClockCycles++;
						

					}
				}
			}

			SettingsFileCheckList |= (1 << 10);
		}
		else if (!strcmp(Str1, "no_of_simulations"))
		{
			ReadNonCommentFromFile(SettingsFile, Str1, "%");
			Settings->NumberOfSimulations = strtoll(Str1, &tmptr, 10);
			if ((*tmptr) ||
			    (Settings->NumberOfSimulations < 1) ||
				((Settings->NumberOfSimulations % 64) != 0))
			{
				ErrorMessage = "config file: given value for no_of_simulations is not valid, should be a factor of 64";
				fclose(SettingsFile);
				free(Str1);
				free(Str2);
				free(Str3);
				free(Str4);
				throw std::runtime_error(ErrorMessage);
			}

			SettingsFileCheckList |= (1 << 11);
		}
		else if (!strcmp(Str1, "no_of_step_simulations"))
		{
			ReadNonCommentFromFile(SettingsFile, Str1, "%");
			Settings->NumberOfStepSimulations = strtoll(Str1, &tmptr, 10);


			SettingsFileCheckList |= (1 << 12);

		}
		else if (!strcmp(Str1, "no_of_step_write_results"))
		{
			ReadNonCommentFromFile(SettingsFile, Str1, "%");
			Settings->NumberOfStepSimulationsToWrite = strtoll(Str1, &tmptr, 10);

			SettingsFileCheckList |= (1 << 13);

		}

		else if(!strcmp(Str1, "location_of_cipher")){
			if(!(Settings->Hardware)){
				ReadNonCommentFromFile(SettingsFile, Str1, "%");
				Settings->funcContainingCipher = std::string(Str1);
			}
			SettingsFileCheckList |= (1 << 14);
		}
		else if(!strcmp(Str1, "compiler_flags")){

			if(!Settings->Hardware){
				if(!ignoreMakefileConfig){
					std::ifstream file(InputSettingsFileName);
					std::string line;
					uint16_t readline_skip_count = 0;
					//read decision 1/0
					while(std::getline(file, line)){
						if(line.find("compiler_flags") != std::string::npos){
							std::getline(file,line);
							while(line.rfind("%",0) != std::string::npos){
								std::getline(file, line);
							}
							while((line.empty()) || (line.find_first_not_of(' ') == std::string::npos)){
								std::getline(file,line);
							}
							Settings->compilerFlags = line;
							std::istringstream ss(line);
							while(ss >> line){
								readline_skip_count++;
							}
							for(i = 0; i < readline_skip_count; ++i){
								ReadNonCommentFromFile(SettingsFile, Str1, "%");
							}
							break;
						}
					}
					Settings->externalMake = "0";
				}
				else{
					Settings->externalMake = "1";
				}
				SettingsFileCheckList |= (1 << 15);
			}
		}
		else if (!strcmp(Str1, "no_of_entries_in_report"))
		{
			ReadNonCommentFromFile(SettingsFile, Str1, "%");
			templl = strtoll(Str1, &tmptr, 10);
			if ((*tmptr) || (templl < 0))
			{
				ErrorMessage = "config file: given value for no_of_entries_in_report is not valid, should be greater or equal zero";
				fclose(SettingsFile);
				free(Str1);
				free(Str2);
				free(Str3);
				free(Str4);
				throw std::runtime_error(ErrorMessage);
			}

			Settings->Max_No_ReportEntries = templl;
			SettingsFileCheckList |= (1 << 16);
		}
		else if (!strcmp(Str1, "compact_distributions"))
		{
			ReadNonCommentFromFile(SettingsFile, Str1, "%");
			if (!strcmp(Str1, "no"))
				Settings->CompactDistributions = 0;
			else if (!strcmp(Str1, "yes"))
				Settings->CompactDistributions = 1;
			else
			{
				fclose(SettingsFile);
				free(Str1);
				free(Str2);
				free(Str3);
                throw std::runtime_error("Given value for \"compact_distributions\" is not valid, can be only no or yes!");
			}

			SettingsFileCheckList |= (1 << 17);
		}

		else if ((strlen(Str1) > 0) && (Str1[0] != '%'))
		{
			printf("given statement \"%s\" is not known\n", Str1);
			ErrorMessage = "given statement " + std::string(Str1) + " is not known";
				fclose(SettingsFile);
				free(Str1);
				free(Str2);
				free(Str3);
				free(Str4);
				throw std::runtime_error(ErrorMessage);
		}
    } while (!feof(SettingsFile));

    fclose(SettingsFile);
    free(Str1);
    free(Str2);
	free(Str3);
	free(Str4);

    if ((SettingsFileCheckList & ((1 << 18) - 1)) != ((1 << 18) - 1))
    {
        printf("config file: all required information are not given\n");

        if (!(SettingsFileCheckList & (1 << 0)))
        	throw std::runtime_error("\"max_no_of_threads\" is not given\n");

        if (!(SettingsFileCheckList & (1 << 1)))
        	throw std::runtime_error("\"no_of_groups\" is not given\n");

        if (!(SettingsFileCheckList & (1 << 2)))
        	throw std::runtime_error("\"order_of_test\" is not given\n");

        if (!(SettingsFileCheckList & (1 << 3)))
        	throw std::runtime_error("\"max_clock_cycle\" is not given\n");


        if (!(SettingsFileCheckList & (1 << 4)))
        	throw std::runtime_error("\"no_of_initial_inputs\" is not given\n");


        if (!(SettingsFileCheckList & (1 << 5)))
        	throw std::runtime_error("\"end_condition\" is not given\n");

        if (!(SettingsFileCheckList & (1 << 6)))
        	throw std::runtime_error("\"probes_include\" is not given\n");

        if (!(SettingsFileCheckList & (1 << 7)))
        	throw std::runtime_error("\"probes_exclude\" is not given\n");

        if (!(SettingsFileCheckList & (1 << 8)))
        	throw std::runtime_error("\"multivariate_test\" is not given\n");

        if (!(SettingsFileCheckList & (1 << 9)))
        	throw std::runtime_error("\"transitional_leakage\" is not given\n");

        if (!(SettingsFileCheckList & (1 << 10)))
        	throw std::runtime_error("\"no_of_test_clock_cycles\" is not given\n");

        if (!(SettingsFileCheckList & (1 << 11)))
        	throw std::runtime_error("\"no_of_simulations\" is not given\n");

        if (!(SettingsFileCheckList & (1 << 12)))
        	throw std::runtime_error("\"no_of_step_simulations\" is not given\n");

        if (!(SettingsFileCheckList & (1 << 13)))
        	throw std::runtime_error("\"no_of_step_write_results\" is not given\n");

        if (!(SettingsFileCheckList & (1 << 14)))
        	throw std::runtime_error("\"location_of_cipher\" is not given\n");

        if (!(SettingsFileCheckList & (1 << 15)))
			throw std::runtime_error("\"compiler_flags\" is not given\n");

		if (!(SettingsFileCheckList & (1 << 17)))
			throw std::runtime_error("\"compact_distribution\" is not given\n");

    }



	if (!(SettingsFileCheckList & (1 << 16)))
	{
		Settings->Max_No_ReportEntries = 10;
		printf("\ndefault \"no_of_entries_in_report\" = 10 is taken\n");
	}

}
void Software::Read::BinaryFile(char* ProgramFolderName, Software::SettingsStruct* Settings, char* Linkerfile){
    char pyscript_filename[] = "inc/Software/compile_sw.py"; 
    FILE *fp;
    
	std::string ErrorMessage;

    char** tmp_str = NULL;
    uint32_t str_ctr = 0;
    
    ProgramFolderName = strtok(ProgramFolderName, " ");
    while(ProgramFolderName){

        
        tmp_str = (char**)realloc(tmp_str, sizeof(char*) * (++str_ctr));
        if(tmp_str == NULL){
			ErrorMessage = "reading binary file: reallocation not possible";
			throw std::runtime_error(ErrorMessage);
        }
        tmp_str[str_ctr - 1] = strdup(ProgramFolderName);
        ProgramFolderName = strtok(NULL, " ");
        
    }


    /* create parameter array for compilation step*/
	uint8_t additonal_info_ctr = 0;
	if(Settings->externalMake == "0"){
		additonal_info_ctr = 4;
	}
	else if(Settings->externalMake == "1"){
		additonal_info_ctr = 7;
	}
    wchar_t** argv = new wchar_t*[additonal_info_ctr + str_ctr];
    argv[0] = new wchar_t[strlen(pyscript_filename)+1];
    argv[1] = new wchar_t[strlen(Linkerfile)+1];

    mbstowcs(argv[0], pyscript_filename, strlen(pyscript_filename) + 1);
    mbstowcs(argv[1], Linkerfile, strlen(Linkerfile) + 1);

    for(uint32_t i = 0; i < str_ctr; ++i){
        argv[i+2] = new wchar_t[strlen(tmp_str[i])+2];
        mbstowcs(argv[i+2], tmp_str[i], strlen(tmp_str[i]) + 2);
    }

	
	if(Settings->externalMake == "0"){
		argv[str_ctr + 2] = new wchar_t[strlen(Settings->compilerFlags.c_str())+1];
		mbstowcs(argv[str_ctr + 2], Settings->compilerFlags.c_str(), strlen(Settings->compilerFlags.c_str())+1);

		argv[str_ctr + 3] = new wchar_t[strlen(Settings->externalMake.c_str())+1];
		mbstowcs(argv[str_ctr + 3], Settings->externalMake.c_str(), strlen(Settings->externalMake.c_str())+1);
		additonal_info_ctr = 4;
	}
	else if(Settings->externalMake == "1"){
		argv[str_ctr + 2] = new wchar_t[strlen(Settings->compilerFlags.c_str())+1];
		mbstowcs(argv[str_ctr + 2], Settings->compilerFlags.c_str(), strlen(Settings->compilerFlags.c_str())+1);

		argv[str_ctr + 3] = new wchar_t[strlen(Settings->externalBinaryInformation.at(0).c_str())+1];
		mbstowcs(argv[str_ctr + 3], Settings->externalBinaryInformation.at(0).c_str(), strlen(Settings->externalBinaryInformation.at(0).c_str())+1);

		argv[str_ctr + 4] = new wchar_t[strlen(Settings->externalBinaryInformation.at(1).c_str())+1];
		mbstowcs(argv[str_ctr + 4], Settings->externalBinaryInformation.at(1).c_str(), strlen(Settings->externalBinaryInformation.at(1).c_str())+1);

		argv[str_ctr + 5] = new wchar_t[strlen(Settings->externalBinaryInformation.at(2).c_str())+1];
		mbstowcs(argv[str_ctr + 5], Settings->externalBinaryInformation.at(2).c_str(), strlen(Settings->externalBinaryInformation.at(2).c_str())+1);

		argv[str_ctr + 6] = new wchar_t[strlen(Settings->externalMake.c_str())+1];
		mbstowcs(argv[str_ctr + 6], Settings->externalMake.c_str(), strlen(Settings->externalMake.c_str())+1);
		additonal_info_ctr = 7;
	}


    // initiate c to python communication
    Py_SetProgramName(argv[0]);

    Py_Initialize();

    PySys_SetArgvEx(additonal_info_ctr + str_ctr, argv, 0);
    
    fp = _Py_fopen(pyscript_filename, "r");

    if(fp == NULL){
		ErrorMessage = "could not open python file!";
		throw std::runtime_error(ErrorMessage);
    }
    PyRun_SimpleFile(fp, pyscript_filename); //execute compile_sw.py
    fclose(fp);

    // delete dynamic arrays
    for(uint32_t i = 0; i < additonal_info_ctr + str_ctr; ++i){
        delete[] argv[i];
    }
    delete[] argv;

    for(uint32_t idx = 0; idx < str_ctr; ++idx){
        free(tmp_str[idx]);
    }
    free(tmp_str);

    /*
    *   second step: parse arguments
    */
   
    /* create parameter array for compilation step*/
    argv = new wchar_t*[Settings->InitialSim_NumberOfInputs+1]; //inputs and name of function containing cipher
    argv[0] = new wchar_t[strlen(Settings->funcContainingCipher.c_str())+1];
    mbstowcs(argv[0], Settings->funcContainingCipher.c_str(), strlen(Settings->funcContainingCipher.c_str()) + 1);
    
    for(int i = 0; i < Settings->InitialSim_NumberOfInputs; ++i){
        argv[i+1] = new wchar_t[strlen(Settings->InitialSim_InputName[i])+1];
        mbstowcs(argv[i+1], Settings->InitialSim_InputName[i], strlen(Settings->InitialSim_InputName[i]) + 1);
    }

    PySys_SetArgvEx(Settings->InitialSim_NumberOfInputs+1, argv, 0);
    
    //import python module for argument parsing
    PyObject* pName = PyUnicode_FromString("inc.Software.parse_args");
    PyObject* pModule = PyImport_Import(pName);
    PyObject* pDict = PyModule_GetDict(pModule);
    
    PyObject* pFunc = PyDict_GetItemString(pDict, "extract_args");
    PyObject* pArgs = PyTuple_New(1);
    PyObject* pValue = PyUnicode_FromString("./"); 

	PyTuple_SetItem(pArgs, 0, pValue);
    

    //run required function form module and return as PyObject*
    if(pModule){
        pValue = PyObject_CallObject(pFunc, pArgs); //
        if(pValue == NULL){
			throw std::runtime_error("ERROR: unable to execute python function to parse arguments!");
        }

    }
    else{
        throw std::runtime_error("ERROR: Python module not imported!");
    }
    
    //free allocated array
    for(int i = 0; i < Settings->InitialSim_NumberOfInputs; ++i){
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
    Settings->start_address    = -1;
    Settings->main_address     = -1;
    Settings->flash            = {0,0};
    Settings->ram              = {0,0};
    Settings->arch             = mulator::Architecture::ARMv7M;
    Settings->num_threads      = 0;

    for(uint32_t i = 0; i < n_spaces; ++i){
        if(!strcmp(args[i],"--start")){
            Settings->start_address = (uint32_t)strtol(args[++i], NULL, 16);
        }
        else if(!strcmp(args[i],"--main")){
            Settings->main_address = (uint32_t)strtol(args[++i], NULL, 16);
        }
        else if(!strcmp(args[i],"--symbol")){
            auto symbol = args[++i];
            auto addr = strtol(args[++i], NULL, 16);
            Settings->symbol_names[addr] = symbol;
            Settings->symbol_addresses.push_back(addr);
        }
        else if(!strcmp(args[i],"--halt")){
            auto symbol = args[++i];
            uint32_t addr = strtol(args[++i], NULL, 16);
            Settings->symbol_names[addr] = symbol;
            Settings->halt_addresses.push_back(addr);

        }
        else if(!strcmp(args[i], "--ignore")){
            ++i;
            ++i;
        }
        else if(!strcmp(args[i], "--edata_used_ram")){ 
            Settings->length_occupied_ram = (uint32_t)strtol(args[++i], NULL, 16);
        }
        else if(!strcmp(args[i], "--inputs")){ 
            for(int j = 0; j < Settings->InitialSim_NumberOfInputs; ++j){
                auto input_name = args[++i];
                auto input_address = (uint32_t)strtol(args[++i], NULL, 16);
                Settings->InitialSim_PositionInEmulatorRam[input_name] = input_address - (Settings->ram).offset;
            }
        }
        else if(!strcmp(args[i], "--randomness_section")){
            Settings->randomness_start_addr = (uint32_t)strtol(args[++i], NULL, 10);
            Settings->randomness_end_addr = (uint32_t)strtol(args[++i], NULL, 10);
            Settings->randomness_segment_length = Settings->randomness_end_addr - Settings->randomness_start_addr;

        }
        else if(!strcmp(args[i],"--section")){
            Settings->binary.push_back({args[++i], read_file(args[i]), (uint32_t)strtol(args[++i], NULL, 16)});
        }
        else if(!strcmp(args[i],"--flash")){
            Settings->flash.offset = (uint32_t)strtol(args[++i], NULL, 16);
            Settings->flash.size = (uint32_t)strtol(args[++i], NULL, 16);
        }
        else if(!strcmp(args[i],"--ram")){
            (Settings->ram).offset = (uint32_t)strtol(args[++i], NULL, 16);
            (Settings->ram).size = (uint32_t)strtol(args[++i], NULL, 16);
        }
        else if(!strcmp(args[i],"--armv7m")){
            Settings->arch = mulator::Architecture::ARMv7M;
        }
        else if(!strcmp(args[i],"--armv6m")){
            Settings->arch = mulator::Architecture::ARMv6M;
        }
        else if(!strcmp(args[i], "--armv7e-m")){
            Settings->arch = mulator::Architecture::ARMv7EM;
        }
        else{
            // printf("unkown option '%s'",args[i]);
			ErrorMessage = "unkown option " + std::string(args[i]);
			throw std::runtime_error(ErrorMessage);
        }
    }

    if(Settings->start_address == (uint32_t)-1){
        throw std::runtime_error("no entry point given");
    }
    if(Settings->main_address == (uint32_t)-1){
        throw std::runtime_error("no main function given");
    }
    if(Settings->ram.size == 0){
        throw std::runtime_error("no RAM given");
    }
    if(Settings->flash.size == 0){
		throw std::runtime_error("no FLASH given");
    }
    if(Settings->start_address == (uint32_t)-1){
        throw std::runtime_error("no entry point given");
    }

    //calculate actual offset
    Settings->length_occupied_ram -= Settings->ram.offset;

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