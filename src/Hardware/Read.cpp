#include "Hardware/Read.hpp"

void Hardware::Read::NonCommentFromFile(FILE *FileHeader, char *Str, const char *CommentSyntax)
{
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

void Hardware::Read::fReadaWord(Hardware::FileBufferStruct* FileBuffer, char *Buffer, char *Attribute)
{
    //reset Buffer
	memset(Buffer, 0, 10); //Max_Name_Length

    static char Lastch = 0;
    char        ch = 0;
    int         i = 0;
    int         j = 0;
    char        BracketOpened = 0;

    if (Attribute)
        Attribute[0] = 0;

    while ((FileBuffer->Index <= FileBuffer->Size) || Lastch)
    {
        if (Lastch)
            ch = Lastch;
        else
            ch = FileBuffer->Buffer[FileBuffer->Index++];

        if ((FileBuffer->Index <= FileBuffer->Size) || Lastch)
        {
            Lastch = 0;

            if ((ch == 32) || (ch == 13) || (ch == 10) || (ch == 9))
            {
				if (i && (!BracketOpened))
					break;
			}
            else if ((ch == '(') || (ch == ')'))
            {
                if (i)
                {
                    Lastch = ch;
                    break;
                }
                else
                {
                    Buffer[i++] = ch;

                    if (ch == '(')
                    {
                        ch = FileBuffer->Buffer[FileBuffer->Index++];
                        if (ch == '*')
                        {
                            while (FileBuffer->Index <= FileBuffer->Size)
                            {
                                ch = FileBuffer->Buffer[FileBuffer->Index++];
                                if ((Buffer[i] == '*') && (ch == ')'))
                                    break;
                                else
                                {
                                    Buffer[i] = ch;
                                    if (Attribute)
                                        Attribute[j++] = ch;
                                }
                            }

                            if (FileBuffer->Index <= FileBuffer->Size)
                            {
                                i--;
                                j--;
                            }
                        }
                        else
                        {
                            Lastch = ch;
                            break;
                        }
                    }
                    else
                        break;
                }
            }
            else if ((ch == '/') && i)
            {
                if (Buffer[i - 1] == '/') // start of the comment "//"
                {
                    i--;

                    while (FileBuffer->Index <= FileBuffer->Size)
                    {
                        ch = FileBuffer->Buffer[FileBuffer->Index++];
                        if ((ch == '\n') || (ch == '\r'))
                            break;
                    }
                }
                else
                	Buffer[i++] = ch;
            }
            else if ((ch == '*') && i)
            {
                if (Buffer[i - 1] == '/') // start of the comment "/*"
                {
                    i--;

                    while (FileBuffer->Index <= FileBuffer->Size)
                    {
                        ch = FileBuffer->Buffer[FileBuffer->Index++];
                        if ((Buffer[i] == '*') && (ch == '/'))
                            break;
                        else
                            Buffer[i] = ch;
                    }
                }
                else if (Buffer[i - 1] == '(') // start of the attribute "(*"
                {
                    i--;

                    while (FileBuffer->Index <= FileBuffer->Size)
                    {
                        ch = FileBuffer->Buffer[FileBuffer->Index++];
                        if ((Buffer[i] == '*') && (ch == ')'))
                            break;
                        else
                        {
                            Buffer[i] = ch;
                            if (Attribute)
                                Attribute[j++] = ch;
                        }
                    }

                    if (FileBuffer->Index <= FileBuffer->Size)
                        j--;
                }
            }
            else
            {
                Buffer[i++] = ch;

           		if (ch == '{')
	            	BracketOpened = 1;

	            if (ch == '}')
	            	BracketOpened = 0;
			}
        }
    }

    Buffer[i] = 0;
    if (Attribute)
        Attribute[j] = 0;
}

int Hardware::Read::TrimSignalName(char* SignalName, int* k = NULL)
{
	int   i, j, l;
	char* Str = (char *)malloc(Max_Name_Length * sizeof(char));
	char* ptr;

	j = -1;
	l = strlen(SignalName);

	if (SignalName[l - 1] == ']')
	{
		for (i = l - 2;i >= 0;i--)
			if (SignalName[i] == '[')
				break;

		if (i >= 0)
		{
			SignalName[i] = 0;
			strncpy(Str, &SignalName[i + 1], Max_Name_Length - 1);
			Str[strlen(Str) - 1] = 0;
			ptr = strchr(Str, ':');
			if (ptr == NULL)
			{
				j = atoi(Str);
				if (k != NULL)
					*k = -1;
			}
			else
			{
				*ptr = 0;
				j = atoi(Str);
				if (k != NULL)
					*k = atoi(ptr + 1);
			}
		}
	}

	free(Str);
	return(j);
}

int Hardware::Read::SearchSignalName(CircuitStruct* Circuit, char* SignalName, char Trim, Settings& settings)
{
	int    SignalIndex = -1;
	int    Index;
	int    size;
	char   flag = 0;
	uint64_t    no_of_Threads = 0;

	if (Trim)
		size = strlen(SignalName);
	else
		size = Max_Name_Length;

	no_of_Threads = ceil(Circuit->NumberOfSignals / 10000);
	if (no_of_Threads > settings.GetNumberOfThreads())
		no_of_Threads = settings.GetNumberOfThreads();

	omp_set_num_threads(no_of_Threads);

	#pragma omp parallel for shared(flag, SignalIndex)
	for (Index = 0; Index < Circuit->NumberOfSignals; Index++)
	{
		if(flag) continue;

		if (!strncmp(SignalName, Circuit->Signals[Index]->Name, size))
		{
			if (Trim)
			{
				if ((Circuit->Signals[Index]->Name[size] == 0) || (Circuit->Signals[Index]->Name[size] == '['))
				{
					SignalIndex = Index;
					flag = 1;
				}
			}
			else
			{
				SignalIndex = Index;
				flag = 1;
			}
		}
	}

	return(SignalIndex);
}

void Hardware::Read::DesignFile_Find_IO_Port(char* Str1, char SubCircuitRead, int CellTypeIndex, int CaseIndex,
                                             Library& library, CircuitStruct* Circuit, int NumberOfSignalsOffset,
                                             char* SubCircuitInstanceName, CircuitStruct* SubCircuit,
                                             int* &InputPorts, int &NumberOfInputPorts, int* &OutputPorts, int &NumberOfOutputPorts)
{
	int          SignalIndex;
	int 		 InputIndex;
	int 		 OutputIndex;
	int          TempIndex;
	int          i;
    char*        Str2 = (char*)malloc(Max_Name_Length * sizeof(char));
    int*         Buffer_int;
    std::string  ErrorMessage;

	NumberOfInputPorts = 0;
	NumberOfOutputPorts = 0;
	free(InputPorts);
	free(OutputPorts);
	InputPorts = NULL;
	OutputPorts = NULL;

	if (!SubCircuitRead)
	{
		if (strlen(Str1))
		{
			for (InputIndex = 0; InputIndex < (int)library.GetNumberOfInputs(CellTypeIndex); InputIndex++)
			{
				strncpy(Str2, library.GetInput(CellTypeIndex, InputIndex).c_str(), Max_Name_Length - 1);
				i = TrimSignalName(Str2);

				if ((!strcmp(Str1 + 1, library.GetInput(CellTypeIndex, InputIndex).c_str())) ||
					(!strcmp(Str1 + 1, Str2)))
				{
					Buffer_int = (int *)malloc((NumberOfInputPorts + 1) * sizeof(int));
					memcpy(Buffer_int, InputPorts, NumberOfInputPorts * sizeof(int));
					free(InputPorts);
					InputPorts = Buffer_int;

					InputPorts[NumberOfInputPorts] = InputIndex;
					NumberOfInputPorts++;

					if (i < 0) // means the signal name was found not its trimmed
						break;
				}
			}

			if (!NumberOfInputPorts) // the IO port NOT found in the Circuit->Inputs
			{
				for (OutputIndex = 0; OutputIndex < (int)library.GetNumberOfOutputs(CellTypeIndex); OutputIndex++)
				{
					strncpy(Str2, library.GetOutput(CellTypeIndex, OutputIndex).c_str(), Max_Name_Length - 1);
					i = TrimSignalName(Str2);

					if ((!strcmp(Str1 + 1, library.GetOutput(CellTypeIndex, OutputIndex).c_str())) ||
						(!strcmp(Str1 + 1, Str2)))
					{
						Buffer_int = (int *)malloc((NumberOfOutputPorts + 1) * sizeof(int));
						memcpy(Buffer_int, OutputPorts, NumberOfOutputPorts * sizeof(int));
						free(OutputPorts);
						OutputPorts = Buffer_int;

						OutputPorts[NumberOfOutputPorts] = OutputIndex;
						NumberOfOutputPorts++;

						if (i < 0) // means the signal name was found not its trimmed
							break;
					}
				}

				if (!NumberOfOutputPorts) // the IO port NOT found in the Circuit->Outputs
				{
					ErrorMessage = Str1 + 1;
					ErrorMessage = "IO port " + ErrorMessage + " not found in cell type \"" + library.GetIdentifier(CellTypeIndex, CaseIndex) + "\"!";
					throw std::runtime_error(ErrorMessage);
				}
			}
		}
		else
		{
			for (InputIndex = 0; InputIndex < Circuit->Cells[Circuit->NumberOfCells]->NumberOfInputs; InputIndex++)
				if (Circuit->Cells[Circuit->NumberOfCells]->Inputs[InputIndex] == -1)
				{
					ErrorMessage = "Input port \"" + library.GetInput(CellTypeIndex, InputIndex) + "\" of cell \"" + (std::string)Circuit->Cells[Circuit->NumberOfCells]->Name + "\" cannot be left unconnected!";
					throw std::runtime_error(ErrorMessage);
				}

			for (OutputIndex = 0; OutputIndex < Circuit->Cells[Circuit->NumberOfCells]->NumberOfOutputs; OutputIndex++)
				if (Circuit->Cells[Circuit->NumberOfCells]->Outputs[OutputIndex] == -1)
				{
					Buffer_int = (int *)malloc((NumberOfOutputPorts + 1) * sizeof(int));
					memcpy(Buffer_int, OutputPorts, NumberOfOutputPorts * sizeof(int));
					free(OutputPorts);
					OutputPorts = Buffer_int;

					OutputPorts[NumberOfOutputPorts] = OutputIndex;
					NumberOfOutputPorts++;
				}
		}
	}
	else
	{
		if (strlen(Str1))
		{
			TempIndex = strlen(SubCircuitInstanceName);
			strncat(SubCircuitInstanceName, ".", Max_Name_Length - 1);
			if (Str1[1] == '\\')
				strncat(SubCircuitInstanceName, Str1 + 2, Max_Name_Length - 1);
			else
				strncat(SubCircuitInstanceName, Str1 + 1, Max_Name_Length - 1);

			strncpy(Str1, "\\", Max_Name_Length - 1);
			strncat(Str1, SubCircuitInstanceName, Max_Name_Length - 1);
			SubCircuitInstanceName[TempIndex] = '\0';

			for (InputIndex = 0; InputIndex < SubCircuit->NumberOfInputs; InputIndex++)
			{
				SignalIndex = SubCircuit->Inputs[InputIndex];
				if (SignalIndex > Circuit->NumberOfConstants)
					SignalIndex -= NumberOfSignalsOffset;

				strncpy(Str2, Circuit->Signals[SignalIndex]->Name, Max_Name_Length - 1);
				i = TrimSignalName(Str2);

				if ((!strcmp(Str1, Circuit->Signals[SignalIndex]->Name)) ||
					(!strcmp(Str1, Str2)))
				{
					Buffer_int = (int *)malloc((NumberOfInputPorts + 1) * sizeof(int));
					memcpy(Buffer_int, InputPorts, NumberOfInputPorts * sizeof(int));
					free(InputPorts);
					InputPorts = Buffer_int;

					InputPorts[NumberOfInputPorts] = InputIndex;
					NumberOfInputPorts++;

					if (i < 0) // means the signal name was found not its trimmed
						break;
				}
			}

			if (!NumberOfInputPorts) // the IO port NOT found in the SubCircuit.Inputs
			{
				for (OutputIndex = 0; OutputIndex < SubCircuit->NumberOfOutputs; OutputIndex++)
				{
					SignalIndex = SubCircuit->Outputs[OutputIndex];
					if (SignalIndex > Circuit->NumberOfConstants)
						SignalIndex -= NumberOfSignalsOffset;

					strncpy(Str2, Circuit->Signals[SignalIndex]->Name, Max_Name_Length - 1);
					i = TrimSignalName(Str2);

					if ((!strcmp(Str1, Circuit->Signals[SignalIndex]->Name)) ||
						(!strcmp(Str1, Str2)))
					{
						Buffer_int = (int *)malloc((NumberOfOutputPorts + 1) * sizeof(int));
						memcpy(Buffer_int, OutputPorts, NumberOfOutputPorts * sizeof(int));
						free(OutputPorts);
						OutputPorts = Buffer_int;

						OutputPorts[NumberOfOutputPorts] = OutputIndex;
						NumberOfOutputPorts++;

						if (i < 0) // means the signal name was found not its trimmed
							break;
					}
				}

				if (!NumberOfOutputPorts) // the IO port NOT found in the subCircuit.Outputs
				{
					ErrorMessage = Str1;
					ErrorMessage = "IO port " + ErrorMessage + " not found in module \"" + (std::string)SubCircuitInstanceName + "\"!";
					throw std::runtime_error(ErrorMessage);
				}
			}
		}
		else
		{
			for (InputIndex = 0; InputIndex < SubCircuit->NumberOfInputs; InputIndex++)
			{
				SignalIndex = SubCircuit->Inputs[InputIndex];
				if (SignalIndex > Circuit->NumberOfConstants)
					SignalIndex -= NumberOfSignalsOffset;

				if (!Circuit->Signals[SignalIndex]->Deleted)
				{
					ErrorMessage = "Input port \"" + (std::string)Circuit->Signals[SignalIndex]->Name + "\" of module \"" + (std::string)SubCircuitInstanceName + "\" cannot be left unconnected!";
					throw std::runtime_error(ErrorMessage);
				}
			}

			for (OutputIndex = 0; OutputIndex < SubCircuit->NumberOfOutputs; OutputIndex++)
			{
				SignalIndex = SubCircuit->Outputs[OutputIndex];
				if (SignalIndex > Circuit->NumberOfConstants)
					SignalIndex -= NumberOfSignalsOffset;

				if (!Circuit->Signals[SignalIndex]->Deleted)
				{
					Buffer_int = (int *)malloc((NumberOfOutputPorts + 1) * sizeof(int));
					memcpy(Buffer_int, OutputPorts, NumberOfOutputPorts * sizeof(int));
					free(OutputPorts);
					OutputPorts = Buffer_int;

					OutputPorts[NumberOfOutputPorts] = OutputIndex;
					NumberOfOutputPorts++;
				}
			}
		}
	}

	free(Str2);
}

void Hardware::Read::DesignFile_Find_Signal_Name(char* Str1, char SubCircuitRead, int CellTypeIndex, int CaseIndex,
                                                 Settings& settings, Library& library, CircuitStruct* Circuit, int Task,
                                                 int NumberOfSignalsOffset, int NumberOfCellsOffset,
                                                 char* SubCircuitInstanceName, CircuitStruct* SubCircuit,
                                                 int* &InputPorts, int &NumberOfInputPorts, int* &OutputPorts, int &NumberOfOutputPorts, int &CurrentIO)
{
	int          SignalIndex;
	int          SignalIndexWithOffset;
	int          SignalIndex2;
	int          SignalIndex2WithOffset;
	int 		 InputIndex;
	int 		 OutputIndex;
	int          CellIndex;
	int          InputIndex2;
	int          OutputIndex2;
	int          TempIndex;
    int*         Buffer_int;
    char*        Str2 = (char*)malloc(Max_Name_Length * sizeof(char));
    char*        Str3 = (char*)malloc(Max_Name_Length * sizeof(char));
    int          Index1, Index2, IndexUpwards;
    int          j;
    CellStruct** TempCells;
    int*         TempGates;
    int*         IOSignals = NULL;
    int          NumberOfIOSignals = 0;
    char*        strptr;
    char*        strptr2;
    char         doneone;
    std::string  ErrorMessage;

	if (strlen(Str1))
	{
		strptr = Str1;
		if (strptr[0] == '{')
			strptr++;

		if (strptr[strlen(strptr) - 1] == '}')
			strptr[strlen(strptr) - 1]  = 0;

		strptr[strlen(strptr) + 1] = 0;

		while (strlen(strptr))
		{
			strptr2 = strchr(strptr, ',');
			if (strptr2)
				*strptr2 = 0;

			strncpy(Str2, strptr, Max_Name_Length - 1);
			Index1 = TrimSignalName(Str2, &Index2);
			doneone = 0;

			if (Index1 < 0) // the given signal name does not have any index (without [])
			{
				SignalIndex = Hardware::Read::SearchSignalName(Circuit, strptr, 1, settings);

				if (SignalIndex != -1)
				{
					for (SignalIndex2 = SignalIndex - 1; SignalIndex2 >= 0; SignalIndex2--)
					{
						strncpy(Str2, Circuit->Signals[SignalIndex2]->Name, Max_Name_Length - 1);
						TrimSignalName(Str2);

						if (strcmp(strptr, Str2))
							break;
					}

					for (SignalIndex = SignalIndex2 + 1; SignalIndex < Circuit->NumberOfSignals; SignalIndex++)
					{
						strncpy(Str2, Circuit->Signals[SignalIndex]->Name, Max_Name_Length - 1);
						TrimSignalName(Str2);

						if (!strcmp(strptr, Str2))
						{
							Buffer_int = (int *)malloc((NumberOfIOSignals + 1) * sizeof(int));
							memcpy(Buffer_int, IOSignals, NumberOfIOSignals * sizeof(int));
							free(IOSignals);
							IOSignals = Buffer_int;

							IOSignals[NumberOfIOSignals] = SignalIndex;
							NumberOfIOSignals++;
							doneone = 1;
						}
						else
							break;
					}
				}
			}
			else if ((Index1 >= 0) && (Index2 < 0)) // the given signal name has one index (with [ ])
			{
				SignalIndex = Hardware::Read::SearchSignalName(Circuit, strptr, 0, settings);

				if (SignalIndex != -1)
				{
					Buffer_int = (int *)malloc((NumberOfIOSignals + 1) * sizeof(int));
					memcpy(Buffer_int, IOSignals, NumberOfIOSignals * sizeof(int));
					free(IOSignals);
					IOSignals = Buffer_int;

					IOSignals[NumberOfIOSignals] = SignalIndex;
					NumberOfIOSignals++;
					doneone = 1;
				}
			}
			else if ((Index1 >= 0) && (Index2 >= 0)) // the given signal name has two indices (with [ : ])
			{
				IndexUpwards = (Index1 < Index2) ? 1 : -1;

				for (j = Index1; ((IndexUpwards == 1) && (j <= Index2)) || ((IndexUpwards == -1) && (j >= Index2)); j += IndexUpwards)
				{
					sprintf(Str3, "%s[%d]", Str2, j);

					SignalIndex = Hardware::Read::SearchSignalName(Circuit, Str3, 0, settings);

					if (SignalIndex != -1)
					{
						Buffer_int = (int *)malloc((NumberOfIOSignals + 1) * sizeof(int));
						memcpy(Buffer_int, IOSignals, NumberOfIOSignals * sizeof(int));
						free(IOSignals);
						IOSignals = Buffer_int;

						IOSignals[NumberOfIOSignals] = SignalIndex;
						NumberOfIOSignals++;
						doneone = 1;
					}
					else
					{
						ErrorMessage = Str3;
						ErrorMessage = "Signal \"" + ErrorMessage + "\" not found!";
						throw std::runtime_error(ErrorMessage);
					}
				}
			}

			if (!doneone)
			{
				ErrorMessage = "Signal \"" + (std::string)strptr + "\" not found!";
				throw std::runtime_error(ErrorMessage);
			}

			strptr += strlen(strptr) + 1;
		}
	}
	else
	{
		if (NumberOfInputPorts > 0)
		{
			if (!SubCircuitRead)
			{
				ErrorMessage = "Input port \"" + library.GetInput(CellTypeIndex, InputPorts[0]) + "\" of cell type \"" + library.GetIdentifier(CellTypeIndex, CaseIndex) + "\" cannot be left unconnected!";
				throw std::runtime_error(ErrorMessage);
			}
			else
			{
				SignalIndex = SubCircuit->Inputs[InputPorts[0]];
				if (SignalIndex >= Circuit->NumberOfConstants)
					SignalIndex -= NumberOfSignalsOffset;

				ErrorMessage = "Input port \"" + (std::string)Circuit->Signals[SignalIndex]->Name + "\" of module \"" + (std::string)SubCircuitInstanceName + "\" cannot be left unconnected!";
				throw std::runtime_error(ErrorMessage);
			}
		}

		for (TempIndex = 0; TempIndex < NumberOfOutputPorts; TempIndex++)
		{
			Buffer_int = (int *)malloc((NumberOfIOSignals + 1) * sizeof(int));
			memcpy(Buffer_int, IOSignals, NumberOfIOSignals * sizeof(int));
			free(IOSignals);
			IOSignals = Buffer_int;

			IOSignals[NumberOfIOSignals] = -1;
			NumberOfIOSignals++;
		}
	}

	//**********************************************//

	if (Task == Task_find_assign_signal_name1)
	{
		free(InputPorts);
		NumberOfInputPorts = NumberOfIOSignals;
		InputPorts = (int *)malloc(NumberOfInputPorts * sizeof(int));

		for (TempIndex = 0; TempIndex < NumberOfIOSignals; TempIndex++)
		{
			CellTypeIndex = library.GetBufferIndex(); // not necessary

			TempCells = (CellStruct **)malloc((Circuit->NumberOfCells + 1) * sizeof(CellStruct *));
			memcpy(TempCells, Circuit->Cells, Circuit->NumberOfCells * sizeof(CellStruct *));
			free(Circuit->Cells);
			Circuit->Cells = TempCells;

			Circuit->Cells[Circuit->NumberOfCells] = (CellStruct *)malloc(sizeof(CellStruct));
			Circuit->Cells[Circuit->NumberOfCells]->Type = CellTypeIndex;
			Circuit->Cells[Circuit->NumberOfCells]->NumberOfInputs = library.GetNumberOfInputs(CellTypeIndex);
			Circuit->Cells[Circuit->NumberOfCells]->Inputs = (int *)malloc(library.GetNumberOfInputs(CellTypeIndex) * sizeof(int));
			Circuit->Cells[Circuit->NumberOfCells]->NumberOfOutputs = library.GetNumberOfOutputs(CellTypeIndex);
			Circuit->Cells[Circuit->NumberOfCells]->Outputs = (int *)malloc(library.GetNumberOfOutputs(CellTypeIndex) * sizeof(int));
			Circuit->Cells[Circuit->NumberOfCells]->Deleted = 0;

			for (InputIndex = 0;InputIndex < Circuit->Cells[Circuit->NumberOfCells]->NumberOfInputs; InputIndex++)
				Circuit->Cells[Circuit->NumberOfCells]->Inputs[InputIndex] = -1;

			for (OutputIndex = 0;OutputIndex < Circuit->Cells[Circuit->NumberOfCells]->NumberOfOutputs; OutputIndex++)
				Circuit->Cells[Circuit->NumberOfCells]->Outputs[OutputIndex] = -1;

			//if (Library->CellTypes[CellTypeIndex]->GateOrReg == CellType_Gate)
			Circuit->Cells[Circuit->NumberOfCells]->Depth = -1;

			TempGates = (int *)malloc((Circuit->NumberOfGates + 1) * sizeof(int));
			memcpy(TempGates, Circuit->Gates, Circuit->NumberOfGates * sizeof(int));
			free(Circuit->Gates);
			Circuit->Gates = TempGates;

			Circuit->Gates[Circuit->NumberOfGates] = Circuit->NumberOfCells + NumberOfCellsOffset;
			Circuit->NumberOfGates++;

			//if (!strcmp(Str1, "assign"))
			sprintf(Str2, "assign_%d", Circuit->NumberOfCells);
			Circuit->Cells[Circuit->NumberOfCells]->Name = (char *)malloc(Max_Name_Length);
			strncpy(Circuit->Cells[Circuit->NumberOfCells]->Name, Str2, Max_Name_Length - 1); // Str2 = "assign_%d"
			Circuit->Cells[Circuit->NumberOfCells]->Name[Max_Name_Length - 1] = '\0';

			SignalIndex = IOSignals[TempIndex];
			OutputIndex = 0;
			Circuit->Cells[Circuit->NumberOfCells]->Outputs[OutputIndex] = SignalIndex;
			if (SignalIndex >= Circuit->NumberOfConstants)
				Circuit->Cells[Circuit->NumberOfCells]->Outputs[OutputIndex] += NumberOfSignalsOffset;

			if (Circuit->Signals[SignalIndex]->Output != -1)
			{
				ErrorMessage = Circuit->Signals[SignalIndex]->Name;
				ErrorMessage = "signal \"" + ErrorMessage + "\" cannot be the output of more than one cell!";
				throw std::runtime_error(ErrorMessage);
			}

			Circuit->Signals[SignalIndex]->Output = Circuit->NumberOfCells + NumberOfCellsOffset;

			InputPorts[TempIndex] = Circuit->NumberOfCells;
			Circuit->NumberOfCells++;
		}
	}
	else if (Task == Task_find_assign_signal_name2)
	{
		if (NumberOfIOSignals != NumberOfInputPorts)
		{
			ErrorMessage = Str1;
			ErrorMessage = "The size of the signal \"" + ErrorMessage + "\" does not match to the connected signal!";
			throw std::runtime_error(ErrorMessage);
		}

		for (TempIndex = 0; TempIndex < NumberOfIOSignals; TempIndex++)
		{
			SignalIndex = IOSignals[TempIndex];
			CellIndex = InputPorts[TempIndex];
			InputIndex = 0;
			Circuit->Cells[CellIndex]->Inputs[InputIndex] = SignalIndex;
			if (SignalIndex >= Circuit->NumberOfConstants)
				Circuit->Cells[CellIndex]->Inputs[InputIndex] += NumberOfSignalsOffset;

			Buffer_int = (int *)malloc((Circuit->Signals[SignalIndex]->NumberOfInputs + 1) * sizeof(int));
			memcpy(Buffer_int, Circuit->Signals[SignalIndex]->Inputs, Circuit->Signals[SignalIndex]->NumberOfInputs * sizeof(int));
			free(Circuit->Signals[SignalIndex]->Inputs);
			Circuit->Signals[SignalIndex]->Inputs = Buffer_int;

			Circuit->Signals[SignalIndex]->Inputs[Circuit->Signals[SignalIndex]->NumberOfInputs] = CellIndex + NumberOfCellsOffset;
			Circuit->Signals[SignalIndex]->NumberOfInputs++;
		}
	}
	else
	{
		if (NumberOfIOSignals != (NumberOfInputPorts + NumberOfOutputPorts))
		{
			ErrorMessage = Str1;
			ErrorMessage = "The size of the signal \"" + ErrorMessage + "\" does not match to the connected port!";
			throw std::runtime_error(ErrorMessage);
		}

		if (!SubCircuitRead)
		{
			for (TempIndex = 0; TempIndex < (NumberOfInputPorts + NumberOfOutputPorts); TempIndex++)
			{
				SignalIndex = IOSignals[TempIndex];
				if (TempIndex < NumberOfInputPorts)
				{
					InputIndex = InputPorts[TempIndex];
					Circuit->Cells[Circuit->NumberOfCells]->Inputs[InputIndex] = SignalIndex;
					if (SignalIndex >= Circuit->NumberOfConstants)
						Circuit->Cells[Circuit->NumberOfCells]->Inputs[InputIndex] += NumberOfSignalsOffset;

					Buffer_int = (int *)malloc((Circuit->Signals[SignalIndex]->NumberOfInputs + 1) * sizeof(int));
					memcpy(Buffer_int, Circuit->Signals[SignalIndex]->Inputs, Circuit->Signals[SignalIndex]->NumberOfInputs * sizeof(int));
					free(Circuit->Signals[SignalIndex]->Inputs);
					Circuit->Signals[SignalIndex]->Inputs = Buffer_int;

					Circuit->Signals[SignalIndex]->Inputs[Circuit->Signals[SignalIndex]->NumberOfInputs] = Circuit->NumberOfCells + NumberOfCellsOffset;
					Circuit->Signals[SignalIndex]->NumberOfInputs++;
				}
				else
				{
					OutputIndex = OutputPorts[TempIndex - NumberOfInputPorts];
					Circuit->Cells[Circuit->NumberOfCells]->Outputs[OutputIndex] = SignalIndex;
					if (SignalIndex >= Circuit->NumberOfConstants)
						Circuit->Cells[Circuit->NumberOfCells]->Outputs[OutputIndex] += NumberOfSignalsOffset;

					if (SignalIndex != -1)
					{
						if (Circuit->Signals[SignalIndex]->Output != -1)
						{
							ErrorMessage = Circuit->Signals[SignalIndex]->Name;
							ErrorMessage = "signal \"" + ErrorMessage + "\" cannot be the output of more than one cell!";
							throw std::runtime_error(ErrorMessage);
						}

						Circuit->Signals[SignalIndex]->Output = Circuit->NumberOfCells + NumberOfCellsOffset;
						if (library.IsCellRegister(CellTypeIndex))
							Circuit->Signals[SignalIndex]->Depth = 0;
					}
				}

				CurrentIO++;
			}
		}
		else
		{
			for (TempIndex = 0; TempIndex < (NumberOfInputPorts + NumberOfOutputPorts); TempIndex++)
			{
				SignalIndex = IOSignals[TempIndex];
				SignalIndexWithOffset = SignalIndex;
				if (SignalIndexWithOffset >= Circuit->NumberOfConstants)
					SignalIndexWithOffset += NumberOfSignalsOffset;

				if (TempIndex < NumberOfInputPorts)
					SignalIndex2WithOffset = SubCircuit->Inputs[InputPorts[TempIndex]];
				else
					SignalIndex2WithOffset = SubCircuit->Outputs[OutputPorts[TempIndex - NumberOfInputPorts]];

				SignalIndex2 = SignalIndex2WithOffset;
				if (SignalIndex2 >= Circuit->NumberOfConstants)
					SignalIndex2 -= NumberOfSignalsOffset;

				Circuit->Signals[SignalIndex2]->Type = SignalType_wire;

				if (SignalIndex != -1)
				{
					Buffer_int = (int *)malloc((Circuit->Signals[SignalIndex]->NumberOfInputs + Circuit->Signals[SignalIndex2]->NumberOfInputs) * sizeof(int));
					memcpy(Buffer_int, Circuit->Signals[SignalIndex]->Inputs, Circuit->Signals[SignalIndex]->NumberOfInputs * sizeof(int));
					free(Circuit->Signals[SignalIndex]->Inputs);
					Circuit->Signals[SignalIndex]->Inputs = Buffer_int;

					for (InputIndex = 0; InputIndex < Circuit->Signals[SignalIndex2]->NumberOfInputs; InputIndex++)
					{
						CellIndex = Circuit->Signals[SignalIndex2]->Inputs[InputIndex];
						Circuit->Signals[SignalIndex]->Inputs[Circuit->Signals[SignalIndex]->NumberOfInputs] = CellIndex;
						Circuit->Signals[SignalIndex]->NumberOfInputs++;

						CellIndex -= NumberOfCellsOffset;
						for (InputIndex2 = 0; InputIndex2 < Circuit->Cells[CellIndex]->NumberOfInputs; InputIndex2++)
							if (Circuit->Cells[CellIndex]->Inputs[InputIndex2] == SignalIndex2WithOffset)
								Circuit->Cells[CellIndex]->Inputs[InputIndex2] = SignalIndexWithOffset;
					}

					if (TempIndex >= NumberOfInputPorts)
					{
						if (Circuit->Signals[SignalIndex]->Output != -1)
						{
							ErrorMessage = Circuit->Signals[SignalIndex]->Name;
							ErrorMessage = "signal \"" + ErrorMessage + "\" cannot be the output of more than one cell!";
							throw std::runtime_error(ErrorMessage);
						}

						CellIndex = Circuit->Signals[SignalIndex2]->Output;
						Circuit->Signals[SignalIndex]->Output = CellIndex;
						if (CellIndex != -1)
						{
							CellIndex -= NumberOfCellsOffset;

							for (OutputIndex2 = 0; OutputIndex2 < Circuit->Cells[CellIndex]->NumberOfOutputs; OutputIndex2++)
								if (Circuit->Cells[CellIndex]->Outputs[OutputIndex2] == SignalIndex2WithOffset)
									Circuit->Cells[CellIndex]->Outputs[OutputIndex2] = SignalIndexWithOffset;
						}
					}

					free(Circuit->Signals[SignalIndex2]->Inputs);
					Circuit->Signals[SignalIndex2]->Inputs = NULL;
					Circuit->Signals[SignalIndex2]->NumberOfInputs = 0;
					Circuit->Signals[SignalIndex2]->Deleted = 1;
				}

				CurrentIO++;
			}
		}
	}

	free(IOSignals);
	free(Str2);
	free(Str3);
}

void Hardware::Read::DesignFile(const std::string& design_file_name, const std::string& top_module_name,
                                Settings& settings, Hardware::Library& library, Hardware::CircuitStruct* Circuit,
                                int NumberOfSignalsOffset, int NumberOfCellsOffset, int NumberOfRegValuesOffset, Hardware::FileBufferStruct* FB)
{
    FILE*          DesignFile;
    char           finished;
    char           ReadSignalsFinished;
    int            CellTypeIndex = 0;
    int            CaseIndex = 0;
    char*          Str1 = (char*)malloc(Max_Name_Length * sizeof(char));
    char*          Str2 = (char*)malloc(Max_Name_Length * sizeof(char));
    char           ch;
    int            i, j;
    int            MyNumberofIO = 0;
    int            CurrentIO = 0;
    int            InputIndex = 0;
    int            OutputIndex = 0;
    int            SignalIndex;
    int            CellIndex;
    int            Index1, Index2, IndexUpwards;
    SignalStruct** TempSignals;
    int*           TempInputs;
    int*           TempOutputs;
    CellStruct**   TempCells;
    int*           TempGates;
    int*           TempRegs;
    std::string    ErrorMessage;
	CircuitStruct  SubCircuit;
	char           SubCircuitRead = 0;
    char*          SubCircuitInstanceName = (char*)malloc(Max_Name_Length * sizeof(char));
    int*           InputPorts = NULL;
    int            NumberOfInputPorts = 0;
    int*           OutputPorts = NULL;
    int            NumberOfOutputPorts = 0;
	FileBufferStruct FileBuffer;
	struct stat      file_status;

    std::cout << "\"" << top_module_name << "\"..." << std::flush;

    Circuit->NumberOfSignals = 0;
    Circuit->NumberOfOutputs = 0;
    Circuit->NumberOfInputs = 0;

    char *Phrase = (char *)malloc(Max_Name_Length * sizeof(char));
    char Task;
    char IO_port_found = 0;

    Circuit->NumberOfCells = 0;
    Circuit->NumberOfGates = 0;
    Circuit->NumberOfRegs = 0;
    Circuit->NumberOfRegValues = 0;

    // --------- adding 0 and 1 Circuit->Signals --------------

    Circuit->NumberOfSignals = 6;
	Circuit->NumberOfConstants = 6;
    Circuit->Signals = (SignalStruct **)malloc(Circuit->NumberOfSignals * sizeof(SignalStruct *));

    Circuit->Signals[0] = (SignalStruct *)malloc(sizeof(SignalStruct));
    Circuit->Signals[0]->Name = (char *)malloc(Max_Name_Length);
    strncpy(Circuit->Signals[0]->Name, "1'b0", Max_Name_Length - 1);
    Circuit->Signals[0]->Name[Max_Name_Length - 1] = '\0';
    Circuit->Signals[0]->Type = SignalType_wire;
    Circuit->Signals[0]->NumberOfInputs = 0;
    Circuit->Signals[0]->Inputs = NULL;
    Circuit->Signals[0]->Output = -1;
    Circuit->Signals[0]->Depth = 0;
	Circuit->Signals[0]->is_probe_allowed = false;
	Circuit->Signals[0]->is_extension_allowed = false;
	Circuit->Signals[0]->is_analysis_allowed = false;
    Circuit->Signals[0]->Deleted = 0;

    Circuit->Signals[1] = (SignalStruct *)malloc(sizeof(SignalStruct));
    Circuit->Signals[1]->Name = (char *)malloc(Max_Name_Length);
    strncpy(Circuit->Signals[1]->Name, "1'b1", Max_Name_Length - 1);
    Circuit->Signals[1]->Name[Max_Name_Length - 1] = '\0';
    Circuit->Signals[1]->Type = SignalType_wire;
    Circuit->Signals[1]->NumberOfInputs = 0;
    Circuit->Signals[1]->Inputs = NULL;
    Circuit->Signals[1]->Output = -1;
    Circuit->Signals[1]->Depth = 0;
	Circuit->Signals[1]->is_probe_allowed = false;
	Circuit->Signals[1]->is_extension_allowed = false;
	Circuit->Signals[1]->is_analysis_allowed = false;
	Circuit->Signals[1]->Deleted = 0;

    Circuit->Signals[2] = (SignalStruct *)malloc(sizeof(SignalStruct));
    Circuit->Signals[2]->Name = (char *)malloc(Max_Name_Length);
    strncpy(Circuit->Signals[2]->Name, "1'h0", Max_Name_Length - 1);
    Circuit->Signals[2]->Name[Max_Name_Length - 1] = '\0';
    Circuit->Signals[2]->Type = SignalType_wire;
    Circuit->Signals[2]->NumberOfInputs = 0;
    Circuit->Signals[2]->Inputs = NULL;
    Circuit->Signals[2]->Output = -1;
    Circuit->Signals[2]->Depth = 0;
	Circuit->Signals[2]->is_probe_allowed = false;
	Circuit->Signals[2]->is_extension_allowed = false;
	Circuit->Signals[2]->is_analysis_allowed = false;
	Circuit->Signals[2]->Deleted = 0;

    Circuit->Signals[3] = (SignalStruct *)malloc(sizeof(SignalStruct));
    Circuit->Signals[3]->Name = (char *)malloc(Max_Name_Length);
    strncpy(Circuit->Signals[3]->Name, "1'h1", Max_Name_Length - 1);
    Circuit->Signals[3]->Name[Max_Name_Length - 1] = '\0';
    Circuit->Signals[3]->Type = SignalType_wire;
    Circuit->Signals[3]->NumberOfInputs = 0;
    Circuit->Signals[3]->Inputs = NULL;
    Circuit->Signals[3]->Output = -1;
    Circuit->Signals[3]->Depth = 0;
	Circuit->Signals[3]->is_probe_allowed = false;
	Circuit->Signals[3]->is_extension_allowed = false;
	Circuit->Signals[3]->is_analysis_allowed = false;
	Circuit->Signals[3]->Deleted = 0;

    Circuit->Signals[4] = (SignalStruct *)malloc(sizeof(SignalStruct));
    Circuit->Signals[4]->Name = (char *)malloc(Max_Name_Length);
    strncpy(Circuit->Signals[4]->Name, "1'bx", Max_Name_Length - 1);
    Circuit->Signals[4]->Name[Max_Name_Length - 1] = '\0';
    Circuit->Signals[4]->Type = SignalType_wire;
    Circuit->Signals[4]->NumberOfInputs = 0;
    Circuit->Signals[4]->Inputs = NULL;
    Circuit->Signals[4]->Output = -1;
    Circuit->Signals[4]->Depth = 0;
	Circuit->Signals[4]->is_probe_allowed = false;
	Circuit->Signals[4]->is_extension_allowed = false;
	Circuit->Signals[4]->is_analysis_allowed = false;
	Circuit->Signals[4]->Deleted = 0;

    Circuit->Signals[5] = (SignalStruct *)malloc(sizeof(SignalStruct));
    Circuit->Signals[5]->Name = (char *)malloc(Max_Name_Length);
    strncpy(Circuit->Signals[5]->Name, "1'hx", Max_Name_Length - 1);
    Circuit->Signals[5]->Name[Max_Name_Length - 1] = '\0';
    Circuit->Signals[5]->Type = SignalType_wire;
    Circuit->Signals[5]->NumberOfInputs = 0;
    Circuit->Signals[5]->Inputs = NULL;
    Circuit->Signals[5]->Output = -1;
    Circuit->Signals[5]->Depth = 0;
	Circuit->Signals[5]->is_probe_allowed = false;
	Circuit->Signals[5]->is_extension_allowed = false;
	Circuit->Signals[5]->is_analysis_allowed = false;
	Circuit->Signals[5]->Deleted = 0;

    //---------------------------------------------------------------------------------------------//
    //------------------- reading the Circuit->Signals from the design file --------------------------------//

	if (FB == NULL)
	{
		DesignFile = fopen(design_file_name.c_str(), "rt");

		if (DesignFile == NULL)
		{
        	ErrorMessage = "Design file " + design_file_name + " not found!";
			free(Str1);
			free(Str2);
			free(Phrase);
			free(SubCircuitInstanceName);
			throw std::runtime_error(ErrorMessage);
		}

		if (stat(design_file_name.c_str(), &file_status))
		{
			ErrorMessage = "\ncannot find the size of design file " + design_file_name;
			free(Str1);
			free(Str2);
			free(Phrase);
			free(SubCircuitInstanceName);
			throw std::runtime_error(ErrorMessage);
		}

		FileBuffer.Buffer = (char*)malloc((file_status.st_size + 10) * sizeof(char));
		FileBuffer.Size = fread(FileBuffer.Buffer, sizeof(char), file_status.st_size, DesignFile);
		fclose(DesignFile);
	}
	else
	{
		FileBuffer.Size = FB->Size;
		FileBuffer.Buffer = FB->Buffer;
	}

	FileBuffer.Index = 0;
    finished = 0;
    ReadSignalsFinished = 0;

    do
    {
        do
        {
            fReadaWord(&FileBuffer, Str1, NULL);
        } while ((FileBuffer.Index <= FileBuffer.Size) && strcmp(Str1, "module"));

        if (FileBuffer.Index <= FileBuffer.Size)
        {
            fReadaWord(&FileBuffer, Str1, NULL);
            if (strcmp(Str1, top_module_name.c_str()))
            {
                do
                {
                    fReadaWord(&FileBuffer, Str1, NULL);
                } while ((FileBuffer.Index <= FileBuffer.Size) && strcmp(Str1, "endmodule"));
            }
            else
            {
                do
                {
                    fReadaWord(&FileBuffer, Str1, NULL);
                    ch = Str1[strlen(Str1) - 1];
                } while ((ch != ';') && (FileBuffer.Index <= FileBuffer.Size)); // ignoring the entire list of input/output ports

                while ((!ReadSignalsFinished) && (FileBuffer.Index <= FileBuffer.Size))
                {
                    fReadaWord(&FileBuffer, Str1, NULL);

                    if ((!strcmp(Str1, "input")) || (!strcmp(Str1, "output")) || (!strcmp(Str1, "wire")))
                    {
                        strncpy(Phrase, Str1, Max_Name_Length - 1);
                        Phrase[Max_Name_Length - 1] = '\0';
                        i = 0;
                        Index1 = -1;
                        Index2 = -1;

                        do
                        {
							//std::cout << "signal: " << FileBuffer.Index << " " << FileBuffer.Size << std::endl;
                            ch = FileBuffer.Buffer[FileBuffer.Index++];

                            if ((ch == '[') && (!i))
                            {
                                // do nothing
                            }
                            else if ((ch == ':') && (Str1[0] != '\\'))
                            {
                                Index1 = atoi(Str1);
                                i = 0;
                            }
                            else if ((ch == ']') && (Str1[0] != '\\'))
                            {
                                Index2 = atoi(Str1);
                                i = 0;
                            }
                            else if ((ch == ',') || (ch == ';'))
                            {
                                IndexUpwards = (Index1 < Index2) ? 1 : -1;

                                for (j = Index1; ((IndexUpwards == 1) && (j <= Index2)) || ((IndexUpwards == -1) && (j >= Index2)); j += IndexUpwards)
                                {
                                    if (Index1 != -1)
                                        sprintf(Str2, "%s[%d]", Str1, j);
                                    else
                                        sprintf(Str2, "%s", Str1);

									SignalIndex = Hardware::Read::SearchSignalName(Circuit, Str2, 0, settings);

									if (SignalIndex != -1)
									{
										if (!strcmp(Phrase, "input"))
										{
											if (Circuit->Signals[SignalIndex]->Type != SignalType_wire)
											{
												ErrorMessage = "Signal \"" + (std::string)Str2 + "\" is defined multiple times!";
												throw std::runtime_error(ErrorMessage);
											}
										}
										else if (!strcmp(Phrase, "output"))
										{
											if (Circuit->Signals[SignalIndex]->Type != SignalType_wire)
											{
												ErrorMessage = "Signal \"" + (std::string)Str2 + "\" is defined multiple times!";
												throw std::runtime_error(ErrorMessage);
											}
										}
										else // if (!strcmp(Phrase, "wire"))
										{
											if (Circuit->Signals[SignalIndex]->Type == SignalType_wire)
											{
												ErrorMessage = "Signal \"" + (std::string)Str2 + "\" is defined multiple times!";
												throw std::runtime_error(ErrorMessage);
											}
										}
									}
									else
									{
										TempSignals = (SignalStruct **)malloc((Circuit->NumberOfSignals + 1) * sizeof(SignalStruct *));
										memcpy(TempSignals, Circuit->Signals, Circuit->NumberOfSignals * sizeof(SignalStruct *));
										free(Circuit->Signals);
										Circuit->Signals = TempSignals;

										Circuit->Signals[Circuit->NumberOfSignals] = (SignalStruct *)malloc(sizeof(SignalStruct));
										Circuit->Signals[Circuit->NumberOfSignals]->Name = (char *)malloc(Max_Name_Length);
										strncpy(Circuit->Signals[Circuit->NumberOfSignals]->Name, Str2, Max_Name_Length - 1);
										Circuit->Signals[Circuit->NumberOfSignals]->Name[Max_Name_Length - 1] = '\0';
										Circuit->Signals[Circuit->NumberOfSignals]->NumberOfInputs = 0;
										Circuit->Signals[Circuit->NumberOfSignals]->Inputs = NULL;
										Circuit->Signals[Circuit->NumberOfSignals]->Output = -1;
										Circuit->Signals[Circuit->NumberOfSignals]->is_probe_allowed = false;
										Circuit->Signals[Circuit->NumberOfSignals]->is_extension_allowed = false;
										Circuit->Signals[Circuit->NumberOfSignals]->is_analysis_allowed = false;										
										Circuit->Signals[Circuit->NumberOfSignals]->Deleted = 0;

										SignalIndex = Circuit->NumberOfSignals;
										Circuit->NumberOfSignals++;
									}

									if (!strcmp(Phrase, "input"))
									{
										Circuit->Signals[SignalIndex]->Type = SignalType_input;
										Circuit->Signals[SignalIndex]->Depth = 0;

										TempInputs = (int *)malloc((Circuit->NumberOfInputs + 1) * sizeof(int));
										memcpy(TempInputs, Circuit->Inputs, Circuit->NumberOfInputs * sizeof(int));
										free(Circuit->Inputs);
										Circuit->Inputs = TempInputs;

										Circuit->Inputs[Circuit->NumberOfInputs] = SignalIndex + NumberOfSignalsOffset;
										Circuit->NumberOfInputs++;
									}
									else if (!strcmp(Phrase, "output"))
									{
										Circuit->Signals[SignalIndex]->Type = SignalType_output;
										Circuit->Signals[SignalIndex]->Depth = -1;

										TempOutputs = (int *)malloc((Circuit->NumberOfOutputs + 1) * sizeof(int));
										memcpy(TempOutputs, Circuit->Outputs, Circuit->NumberOfOutputs * sizeof(int));
										free(Circuit->Outputs);
										Circuit->Outputs = TempOutputs;

										Circuit->Outputs[Circuit->NumberOfOutputs] = SignalIndex + NumberOfSignalsOffset;
										Circuit->NumberOfOutputs++;
									}
									else if ((!strcmp(Phrase, "wire")) && (SignalIndex == Circuit->NumberOfSignals -1))
									{
										Circuit->Signals[SignalIndex]->Type = SignalType_wire;
										Circuit->Signals[SignalIndex]->Depth = -1;
									}
                                }

                                i = 0;
                            }
                            else if ((ch != ' ') && (ch != '\n') && (ch != '\t') && (ch != '\r'))
                            {
                                Str1[i++] = ch;
                                Str1[i] = 0;
                            }
                        } while ((ch != ';') && (FileBuffer.Index <= FileBuffer.Size));
                    }
                    else
                        ReadSignalsFinished = 1;
                }

                //---------------------------------------------------------------------------------------------//
                //------------------- reading the Circuit->Cells from the design file ----------------------------------//

                if (FileBuffer.Index <= FileBuffer.Size)
                {
                    strncpy(Str2, Str1, Max_Name_Length - 1);
                    Str2[Max_Name_Length - 1] = '\0';

                    do
                    {
                        fReadaWord(&FileBuffer, Str1, NULL);
                        if (Str1[0] != '[')
                            strcat(Str2, " ");
                        strcat(Str2, Str1);

                        if (Str1[strlen(Str1) - 1] == ';')
                        {
                            i = 0;
                            j = 0;
                            Str1[0] = 0;
                            Task = Task_find_module_type;

                            do
                            {
                                ch = Str2[i++];

                                if ((ch == ' ') || (ch == ';') || (ch == '='))
                                {
                                    if (j)
                                    {
                                        if (Task == Task_find_module_type)
                                        {
                                            if (!strcmp(Str1, "assign"))
                                                if (library.GetBufferIndex() > -1)
                                                {
                                                	CellTypeIndex = library.GetBufferIndex();

                                                	SubCircuitRead = 0;
													NumberOfInputPorts = 0;
													free(InputPorts);
													InputPorts = NULL;
													NumberOfOutputPorts = 0;
													free(OutputPorts);
													OutputPorts = NULL;

                                                	Task = Task_find_assign_signal_name1;
												}
                                                else
                                                {
                                                    free(Str1);
                                                    free(Str2);
                                                    free(Phrase);
                                                    free(SubCircuitInstanceName);
                                                    throw std::runtime_error("Buffer cell is not defined in the library for \"assign\" statements!");
                                                }
                                            else
                                            {											
                                                for (CellTypeIndex = 0; CellTypeIndex < (int)library.GetNumberOfCells(); CellTypeIndex++)
                                                {
                                                    for (CaseIndex = 0; CaseIndex < (int)library.GetNumberOfIdentifiers(CellTypeIndex); CaseIndex++)
                                                        if (!strcmp(Str1, library.GetIdentifier(CellTypeIndex, CaseIndex).c_str()))
                                                            break;

                                                    if (CaseIndex < (int)library.GetNumberOfIdentifiers(CellTypeIndex))
                                                        break;
                                                }

												if (CellTypeIndex < (int)library.GetNumberOfCells())
												{
													TempCells = (CellStruct **)malloc((Circuit->NumberOfCells + 1) * sizeof(CellStruct *));
													memcpy(TempCells, Circuit->Cells, Circuit->NumberOfCells * sizeof(CellStruct *));
													free(Circuit->Cells);
													Circuit->Cells = TempCells;

													Circuit->Cells[Circuit->NumberOfCells] = (CellStruct *)malloc(sizeof(CellStruct));
													Circuit->Cells[Circuit->NumberOfCells]->Type = CellTypeIndex;
													Circuit->Cells[Circuit->NumberOfCells]->NumberOfInputs = library.GetNumberOfInputs(CellTypeIndex);
													Circuit->Cells[Circuit->NumberOfCells]->Inputs = (int *)malloc(library.GetNumberOfInputs(CellTypeIndex) * sizeof(int));
													Circuit->Cells[Circuit->NumberOfCells]->NumberOfOutputs = library.GetNumberOfOutputs(CellTypeIndex);
													Circuit->Cells[Circuit->NumberOfCells]->Outputs = (int *)malloc(library.GetNumberOfOutputs(CellTypeIndex) * sizeof(int));
													Circuit->Cells[Circuit->NumberOfCells]->Deleted = 0;

													for (InputIndex = 0;InputIndex < Circuit->Cells[Circuit->NumberOfCells]->NumberOfInputs; InputIndex++)
														Circuit->Cells[Circuit->NumberOfCells]->Inputs[InputIndex] = -1;

													for (OutputIndex = 0;OutputIndex < Circuit->Cells[Circuit->NumberOfCells]->NumberOfOutputs; OutputIndex++)
														Circuit->Cells[Circuit->NumberOfCells]->Outputs[OutputIndex] = -1;

													if (library.IsCellRegister(CellTypeIndex))
													{
														Circuit->Cells[Circuit->NumberOfCells]->Depth = 0;
														Circuit->Cells[Circuit->NumberOfCells]->RegValueIndexes = (int *)malloc(library.GetNumberOfOutputs(CellTypeIndex) * sizeof(int));
														for (OutputIndex = 0; OutputIndex < (int)library.GetNumberOfOutputs(CellTypeIndex); OutputIndex++)
															Circuit->Cells[Circuit->NumberOfCells]->RegValueIndexes[OutputIndex] = NumberOfRegValuesOffset + Circuit->NumberOfRegValues++;

														TempRegs = (int *)malloc((Circuit->NumberOfRegs + 1) * sizeof(int));
														memcpy(TempRegs, Circuit->Regs, Circuit->NumberOfRegs * sizeof(int));
														free(Circuit->Regs);
														Circuit->Regs = TempRegs;

														Circuit->Regs[Circuit->NumberOfRegs] = Circuit->NumberOfCells + NumberOfCellsOffset;
														Circuit->NumberOfRegs++;
													}
													else // is a gate or a latch
													{
														Circuit->Cells[Circuit->NumberOfCells]->Depth = -1;

														TempGates = (int *)malloc((Circuit->NumberOfGates + 1) * sizeof(int));
														memcpy(TempGates, Circuit->Gates, Circuit->NumberOfGates * sizeof(int));
														free(Circuit->Gates);
														Circuit->Gates = TempGates;

														Circuit->Gates[Circuit->NumberOfGates] = Circuit->NumberOfCells + NumberOfCellsOffset;
														Circuit->NumberOfGates++;
													}

													Task = Task_find_module_name;
													MyNumberofIO = library.GetNumberOfInputs(CellTypeIndex) + library.GetNumberOfOutputs(CellTypeIndex);
													CurrentIO = 0;
													SubCircuitRead = 0;
												}
												else
												{
													SubCircuit.Signals = NULL;
													SubCircuit.NumberOfSignals = 0;
													SubCircuit.Inputs = NULL;
													SubCircuit.Outputs = NULL;
													SubCircuit.NumberOfInputs = 0;
													SubCircuit.NumberOfOutputs = 0;
													SubCircuit.NumberOfConstants = 0;
													SubCircuit.Cells = NULL;
													SubCircuit.NumberOfCells = 0;
													SubCircuit.Gates = NULL;
													SubCircuit.Regs = NULL;
													SubCircuit.NumberOfGates = 0;
													SubCircuit.NumberOfRegs = 0;
													SubCircuit.NumberOfRegValues = 0;
													SubCircuit.MaxDepth = 0;
													SubCircuit.CellsInDepth = NULL;
													SubCircuit.NumberOfCellsInDepth = NULL;

													Hardware::Read::DesignFile(design_file_name, Str1, settings, library, &SubCircuit,
																			   NumberOfSignalsOffset + Circuit->NumberOfSignals - Circuit->NumberOfConstants,
																			   NumberOfCellsOffset + Circuit->NumberOfCells,
																			   NumberOfRegValuesOffset + Circuit->NumberOfRegValues, 
														                       &FileBuffer);

													TempSignals = (SignalStruct **)malloc((Circuit->NumberOfSignals + SubCircuit.NumberOfSignals - SubCircuit.NumberOfConstants) * sizeof(SignalStruct *));
													memcpy(TempSignals, Circuit->Signals, Circuit->NumberOfSignals * sizeof(SignalStruct *));
													free(Circuit->Signals);
													Circuit->Signals = TempSignals;
													memcpy(&Circuit->Signals[Circuit->NumberOfSignals], &SubCircuit.Signals[SubCircuit.NumberOfConstants], (SubCircuit.NumberOfSignals - SubCircuit.NumberOfConstants) * sizeof(SignalStruct *));
													Circuit->NumberOfSignals += SubCircuit.NumberOfSignals - SubCircuit.NumberOfConstants;

													TempCells = (CellStruct **)malloc((Circuit->NumberOfCells + SubCircuit.NumberOfCells) * sizeof(CellStruct *));
													memcpy(TempCells, Circuit->Cells, Circuit->NumberOfCells * sizeof(CellStruct *));
													free(Circuit->Cells);
													Circuit->Cells = TempCells;
													memcpy(&Circuit->Cells[Circuit->NumberOfCells], SubCircuit.Cells, SubCircuit.NumberOfCells * sizeof(CellStruct *));
													Circuit->NumberOfCells += SubCircuit.NumberOfCells;

													TempGates = (int *)malloc((Circuit->NumberOfGates + SubCircuit.NumberOfGates) * sizeof(int));
													memcpy(TempGates, Circuit->Gates, Circuit->NumberOfGates * sizeof(int));
													free(Circuit->Gates);
													Circuit->Gates = TempGates;
													memcpy(&Circuit->Gates[Circuit->NumberOfGates], SubCircuit.Gates, SubCircuit.NumberOfGates * sizeof(int));
													Circuit->NumberOfGates += SubCircuit.NumberOfGates;

													TempRegs = (int *)malloc((Circuit->NumberOfRegs + SubCircuit.NumberOfRegs) * sizeof(int));
													memcpy(TempRegs, Circuit->Regs, Circuit->NumberOfRegs * sizeof(int));
													free(Circuit->Regs);
													Circuit->Regs = TempRegs;
													memcpy(&Circuit->Regs[Circuit->NumberOfRegs], SubCircuit.Regs, SubCircuit.NumberOfRegs * sizeof(int));
													Circuit->NumberOfRegs += SubCircuit.NumberOfRegs;

													Circuit->NumberOfRegValues += SubCircuit.NumberOfRegValues;

													MyNumberofIO = SubCircuit.NumberOfInputs + SubCircuit.NumberOfOutputs;
													CurrentIO = 0;
													SubCircuitRead = 1;
													Task = Task_find_module_name;
												}
											}
                                        }
                                        else if (Task == Task_find_module_name)
                                        {
                                            if (!SubCircuitRead)
											{
	                                            Circuit->Cells[Circuit->NumberOfCells]->Name = (char *)malloc(Max_Name_Length);
	                                            strncpy(Circuit->Cells[Circuit->NumberOfCells]->Name, Str1, Max_Name_Length - 1);
	                                            Circuit->Cells[Circuit->NumberOfCells]->Name[Max_Name_Length - 1] = '\0';
											}
                                            else
                                            {
												strncpy(SubCircuitInstanceName, Str1, Max_Name_Length - 1);

												for (SignalIndex = SubCircuit.NumberOfConstants; SignalIndex < SubCircuit.NumberOfSignals; SignalIndex++)
												{
													strncpy(Str1, "\\", Max_Name_Length - 1);
													strncat(Str1, SubCircuitInstanceName, Max_Name_Length - 1);
													strncat(Str1, ".", Max_Name_Length - 1);
													if (SubCircuit.Signals[SignalIndex]->Name[0] == '\\')
														strncat(Str1, SubCircuit.Signals[SignalIndex]->Name + 1, Max_Name_Length - 1);
													else
														strncat(Str1, SubCircuit.Signals[SignalIndex]->Name, Max_Name_Length - 1);

													strncpy(SubCircuit.Signals[SignalIndex]->Name, Str1, Max_Name_Length - 1);
												}

												for (CellIndex = 0; CellIndex < SubCircuit.NumberOfCells; CellIndex++)
												{
													strncpy(Str1, "\\", Max_Name_Length - 1);
													strncat(Str1, SubCircuitInstanceName, Max_Name_Length - 1);
													strncat(Str1, ".", Max_Name_Length - 1);
													if (SubCircuit.Cells[CellIndex]->Name[0] == '\\')
														strncat(Str1, SubCircuit.Cells[CellIndex]->Name + 1, Max_Name_Length - 1);
													else
														strncat(Str1, SubCircuit.Cells[CellIndex]->Name, Max_Name_Length - 1);

													strncpy(SubCircuit.Cells[CellIndex]->Name, Str1, Max_Name_Length - 1);
												}
											}

                                            Task = Task_find_open_bracket;
                                            IO_port_found = 0;
                                        }
                                        else if (Task == Task_find_IO_port)
                                        {
                                            if (Str1[0] == '.')
                                            {
												DesignFile_Find_IO_Port(Str1, SubCircuitRead, CellTypeIndex, CaseIndex, library, Circuit, NumberOfSignalsOffset,
                                                                        SubCircuitInstanceName, &SubCircuit,
                                                                        InputPorts, NumberOfInputPorts, OutputPorts, NumberOfOutputPorts);

                                                IO_port_found = 1;
                                                Task = Task_find_open_bracket;
                                            }
                                            else
                                            {
                                                ErrorMessage = Str1;
                                                ErrorMessage = "Error in reading the netlist, '.' is expected in " + ErrorMessage + "!";
                                                free(Str1);
                                                free(Str2);
                                                free(Phrase);
                                                free(SubCircuitInstanceName);
                                                throw std::runtime_error(ErrorMessage);
                                            }
                                        }
                                        else if ((Task == Task_find_signal_name) ||
                                                 (Task == Task_find_assign_signal_name1) ||
                                                 (Task == Task_find_assign_signal_name2))
                                        {
											DesignFile_Find_Signal_Name(Str1, SubCircuitRead, CellTypeIndex, CaseIndex, settings, library, Circuit, Task,
																		NumberOfSignalsOffset, NumberOfCellsOffset, SubCircuitInstanceName, &SubCircuit,
																		InputPorts, NumberOfInputPorts, OutputPorts, NumberOfOutputPorts, CurrentIO);

                                            if (Task == Task_find_assign_signal_name1)
                                                if (ch == '=')
                                                    Task = Task_find_assign_signal_name2;
                                                else
                                                    Task = Task_find_equal;
                                            else if (Task == Task_find_assign_signal_name2)
                                                Task = -1; // to avoid incrementing NumberOfCells
                                            else
                                                Task = Task_find_close_bracket;
                                        }

                                        j = 0;
                                        Str1[0] = 0;
                                    }
                                    else if (ch == '=')
                                    {
                                        if (Task == Task_find_equal)
                                            Task = Task_find_assign_signal_name2;
                                        else
                                        {
                                            free(Str1);
                                            free(Str2);
                                            free(Phrase);
                                            free(SubCircuitInstanceName);
	                                        ErrorMessage = "Error in reading the netlist, Taskid: " + std::to_string(Task) + "!\n\"=\" is placed in a wrong position.";
	                                        throw std::runtime_error(ErrorMessage);
                                        }
                                    }
                                }
                                else if (ch == '(')
                                {
                                    if (Task == Task_find_open_bracket)
                                    {
                                        if (IO_port_found)
                                            Task = Task_find_signal_name;
                                        else
                                            Task = Task_find_IO_port;
                                    }
                                    else if (Task == Task_find_IO_port)
                                    {
                                        if (Str1[0] == '.')
                                        {
											DesignFile_Find_IO_Port(Str1, SubCircuitRead, CellTypeIndex, CaseIndex, library, Circuit, NumberOfSignalsOffset,
                                                                    SubCircuitInstanceName, &SubCircuit,
                                                                    InputPorts, NumberOfInputPorts, OutputPorts, NumberOfOutputPorts);

                                            Task = Task_find_signal_name;
                                        }
                                        else
                                        {
                                            ErrorMessage = Str1;
                                            ErrorMessage = "Error in reading the netlist, '.' is expected in " + ErrorMessage + "!";
                                            free(Str1);
                                            free(Str2);
                                            free(Phrase);
                                            free(SubCircuitInstanceName);
                                            throw std::runtime_error(ErrorMessage);
                                        }
                                    }
                                    else
                                    {
                                        ErrorMessage = "Error in reading the netlist, Taskid: " + std::to_string(Task) + "!\n\"(\" is placed in a wrong position.";
                                        free(Str1);
                                        free(Str2);
                                        free(Phrase);
                                        free(SubCircuitInstanceName);
                                        throw std::runtime_error(ErrorMessage);
                                    }

                                    j = 0;
                                    Str1[0] = 0;
                                }
                                else if (ch == ')')
                                {
                                    if (Task == Task_find_close_bracket)
                                    {
                                        if (CurrentIO < MyNumberofIO)
                                            Task = Task_find_comma;
                                    }
                                    else if (Task == Task_find_signal_name)
                                    {
										DesignFile_Find_Signal_Name(Str1, SubCircuitRead, CellTypeIndex, CaseIndex, settings, library, Circuit, Task,
																	NumberOfSignalsOffset, NumberOfCellsOffset, SubCircuitInstanceName, &SubCircuit,
																	InputPorts, NumberOfInputPorts, OutputPorts, NumberOfOutputPorts, CurrentIO);

                                        if (CurrentIO < MyNumberofIO)
                                            Task = Task_find_comma;
                                        else
                                            Task = Task_find_close_bracket;
                                    }
                                    else if (Task == Task_find_comma)
                                    {
										Str1[0] = 0;
										DesignFile_Find_IO_Port(Str1, SubCircuitRead, CellTypeIndex, CaseIndex, library, Circuit, NumberOfSignalsOffset,
																SubCircuitInstanceName, &SubCircuit,
																InputPorts, NumberOfInputPorts, OutputPorts, NumberOfOutputPorts);

										Str1[0] = 0;
										DesignFile_Find_Signal_Name(Str1, SubCircuitRead, CellTypeIndex, CaseIndex, settings, library, Circuit, Task,
																	NumberOfSignalsOffset, NumberOfCellsOffset, SubCircuitInstanceName, &SubCircuit,
																	InputPorts, NumberOfInputPorts, OutputPorts, NumberOfOutputPorts, CurrentIO);

										Task = Task_find_close_bracket;
									}
                                    else
                                    {
                                        ErrorMessage = "Error in reading the netlist, Taskid: " + std::to_string(Task) + "!\n\")\" is placed in a wrong position.";
                                        free(Str1);
                                        free(Str2);
                                        free(Phrase);
                                        free(SubCircuitInstanceName);
                                        throw std::runtime_error(ErrorMessage);
                                    }

                                    j = 0;
                                    Str1[0] = 0;
                                }
                                else if ((ch == ',') && (Str1[0] != '{'))
                                {
                                    if (Task == Task_find_comma)
                                    {
										IO_port_found = 0;
										Task = Task_find_IO_port;

										j = 0;
										Str1[0] = 0;
									}
									else
									{
                                        ErrorMessage = "Error in reading the netlist, Taskid: " + std::to_string(Task) + "!\n\".\" is placed in a wrong position.";
                                        free(Str1);
                                        free(Str2);
                                        free(Phrase);
                                        free(SubCircuitInstanceName);
                                        throw std::runtime_error(ErrorMessage);
									}
                                }
                                else
                                {
                                    Str1[j++] = ch;
                                    Str1[j] = 0;
                                }

                            } while (ch != ';');

                            if ((!SubCircuitRead) && (Task >= 0))
	                            Circuit->NumberOfCells++;

                            Str1[0] = 0;
                            Str2[0] = 0;
                        }

                    } while (strcmp(Str1, "endmodule") && (FileBuffer.Index <= FileBuffer.Size));

                    finished = 1;
                }
            }
        }
    } while ((FileBuffer.Index <= FileBuffer.Size) && (!finished));

    free(Str1);
    free(Str2);
    free(Phrase);
    free(SubCircuitInstanceName);
	if (FB == NULL)
		free(FileBuffer.Buffer);

    if (!finished)
    {
		ErrorMessage = "Target module " + top_module_name + " not found!";
        throw std::runtime_error(ErrorMessage);
    }

    // turn '1bx' and '1hx' to constant 0
    strncpy(Circuit->Signals[4]->Name, "1'b0", Max_Name_Length - 1);
    Circuit->Signals[4]->Name[Max_Name_Length - 1] = '\0';
    strncpy(Circuit->Signals[5]->Name, "1'h0", Max_Name_Length - 1);
    Circuit->Signals[5]->Name[Max_Name_Length - 1] = '\0';
}
