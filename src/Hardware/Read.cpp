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

int Hardware::Read::MakeFormulaForCellInLibrary(CellTypeStruct *CellType)
{
    char *MyStr = (char *)malloc(Max_Name_Length * sizeof(char));
    char *Str2 = (char *)malloc(Max_Name_Length * sizeof(char));
    char *Str3 = (char *)malloc(Max_Name_Length * sizeof(char));
	char *TempStr = (char *)malloc(Max_Name_Length * sizeof(char));
	char *pos;
    char *Start = NULL;
    char *End = NULL;
    char OperationIndex;
    char *TempChar;
    unsigned char *UTempChar;
    // char **TempCharChar;
    unsigned char **UTempCharChar;
    char Intermediate;
    int i, l;

    Intermediate = CellType->NumberOfInputs + CellType->NumberOfOutputs;
    CellType->Intermediate = Intermediate;
    CellType->Operations = (OperationStruct *)malloc(CellType->NumberOfOutputs * sizeof(OperationStruct));

    for (i = 0; i < CellType->NumberOfOutputs; i++)
    {
        CellType->Operations[i].NumberOfClauses = 0;
        CellType->Operations[i].OperationOfClause = NULL;
        CellType->Operations[i].NumberOfOperandsInClause = NULL;
        CellType->Operations[i].OperandsInClause = NULL;

        strncpy(MyStr, CellType->Expresions[i], Max_Name_Length - 1);
        MyStr[Max_Name_Length - 1] = '\0';

        do
        {
            TempChar = (char *)malloc((CellType->Operations[i].NumberOfClauses + 1) * sizeof(char));
            memcpy(TempChar, CellType->Operations[i].OperationOfClause, CellType->Operations[i].NumberOfClauses * sizeof(char));
            free(CellType->Operations[i].OperationOfClause);
            CellType->Operations[i].OperationOfClause = TempChar;

            UTempChar = (unsigned char *)calloc(CellType->Operations[i].NumberOfClauses + 1, sizeof(unsigned char));
            memcpy(UTempChar, CellType->Operations[i].NumberOfOperandsInClause, CellType->Operations[i].NumberOfClauses * sizeof(unsigned char));
            free(CellType->Operations[i].NumberOfOperandsInClause);
            CellType->Operations[i].NumberOfOperandsInClause = UTempChar;

            UTempCharChar = (unsigned char **)malloc((CellType->Operations[i].NumberOfClauses + 1) * sizeof(unsigned char *));
            memcpy(UTempCharChar, CellType->Operations[i].OperandsInClause, CellType->Operations[i].NumberOfClauses * sizeof(unsigned char *));
            free(CellType->Operations[i].OperandsInClause);
            CellType->Operations[i].OperandsInClause = UTempCharChar;
            CellType->Operations[i].OperandsInClause[CellType->Operations[i].NumberOfClauses] = NULL;

            pos = MyStr;
            while ((*pos != ')') && (*pos != 0))
            {
                if (*pos == '(')
                    Start = pos;
                pos++;
            }
            End = pos;

            if (*pos != 0)
            {
                memcpy(Str2, Start + 1, End - Start - 1);
                Str2[End - Start - 1] = 0;
            }
            else
            {
                strncpy(Str2, MyStr, Max_Name_Length - 1);
                Str2[Max_Name_Length - 1] = '\0';
	    }

            if (strstr(Str2, " and "))
                OperationIndex = Operation_AND;
            else if (strstr(Str2, " or "))
                OperationIndex = Operation_OR;
            else if (strstr(Str2, " xor "))
                OperationIndex = Operation_XOR;
            else if (strstr(Str2, "not "))
                OperationIndex = Operation_NOT;
            else
            {
                std::cout << "Error in Library file " << MyStr << std::endl;
                free(MyStr);
                free(Str2);
                free(Str3);
				free(TempStr);
                return 1;
            }

            CellType->Operations[i].OperationOfClause[CellType->Operations[i].NumberOfClauses] = OperationIndex;

            for (l = 0; l < CellType->NumberOfInputs; l++)
                if (strstr(Str2, CellType->Inputs[l]))
                {
                    UTempChar = (unsigned char *)malloc((CellType->Operations[i].NumberOfOperandsInClause[CellType->Operations[i].NumberOfClauses] + 1) * sizeof(unsigned char));
                    memcpy(UTempChar, CellType->Operations[i].OperandsInClause[CellType->Operations[i].NumberOfClauses], CellType->Operations[i].NumberOfOperandsInClause[CellType->Operations[i].NumberOfClauses] * sizeof(unsigned char));
                    free(CellType->Operations[i].OperandsInClause[CellType->Operations[i].NumberOfClauses]);
                    CellType->Operations[i].OperandsInClause[CellType->Operations[i].NumberOfClauses] = UTempChar;

                    CellType->Operations[i].OperandsInClause[CellType->Operations[i].NumberOfClauses][CellType->Operations[i].NumberOfOperandsInClause[CellType->Operations[i].NumberOfClauses]] = l;
                    CellType->Operations[i].NumberOfOperandsInClause[CellType->Operations[i].NumberOfClauses]++;
                }

            for (l = 0; l < CellType->NumberOfOutputs; l++)
                if (strstr(Str2, CellType->Outputs[l]))
                {
                    UTempChar = (unsigned char *)malloc((CellType->Operations[i].NumberOfOperandsInClause[CellType->Operations[i].NumberOfClauses] + 1) * sizeof(char));
                    memcpy(UTempChar, CellType->Operations[i].OperandsInClause[CellType->Operations[i].NumberOfClauses], CellType->Operations[i].NumberOfOperandsInClause[CellType->Operations[i].NumberOfClauses] * sizeof(unsigned char));
                    free(CellType->Operations[i].OperandsInClause[CellType->Operations[i].NumberOfClauses]);
                    CellType->Operations[i].OperandsInClause[CellType->Operations[i].NumberOfClauses] = UTempChar;

                    CellType->Operations[i].OperandsInClause[CellType->Operations[i].NumberOfClauses][CellType->Operations[i].NumberOfOperandsInClause[CellType->Operations[i].NumberOfClauses]] = CellType->NumberOfInputs + l;
                    CellType->Operations[i].NumberOfOperandsInClause[CellType->Operations[i].NumberOfClauses]++;
                }

            for (l = 0; l < CellType->Operations[i].NumberOfClauses; l++)
            {
                sprintf(Str3, "I%d", Intermediate + l + 1);
                if (strstr(Str2, Str3))
                {
                    UTempChar = (unsigned char *)malloc((CellType->Operations[i].NumberOfOperandsInClause[CellType->Operations[i].NumberOfClauses] + 1) * sizeof(unsigned char));
                    memcpy(UTempChar, CellType->Operations[i].OperandsInClause[CellType->Operations[i].NumberOfClauses], CellType->Operations[i].NumberOfOperandsInClause[CellType->Operations[i].NumberOfClauses] * sizeof(unsigned char));
                    free(CellType->Operations[i].OperandsInClause[CellType->Operations[i].NumberOfClauses]);
                    CellType->Operations[i].OperandsInClause[CellType->Operations[i].NumberOfClauses] = UTempChar;

                    CellType->Operations[i].OperandsInClause[CellType->Operations[i].NumberOfClauses][CellType->Operations[i].NumberOfOperandsInClause[CellType->Operations[i].NumberOfClauses]] = Intermediate + l;
                    CellType->Operations[i].NumberOfOperandsInClause[CellType->Operations[i].NumberOfClauses]++;
                }
            }

			if (*pos != 0){
				sprintf(Start, "I%d", Intermediate + CellType->Operations[i].NumberOfClauses + 1);
				strncpy(TempStr, End + 1, Max_Name_Length - 1);
				TempStr[Max_Name_Length - 1] = '\0';
				strcat(MyStr, TempStr);
				CellType->Operations[i].NumberOfClauses++;
			}else{
				CellType->Operations[i].NumberOfClauses++;
				break;
			}

			pos=MyStr;
        } while (*pos != 0);
    }

    free(MyStr);
    free(Str2);
    free(Str3);
	free(TempStr);
    return 0;
}

void Hardware::Read::LibraryFile(char *LibraryFileName, char *LibraryName, Hardware::LibraryStruct* Library){
    std::cout << "Read library file..." << std::flush;
    FILE*            LibraryFile;
    char*            Str1 = (char*)malloc(Max_Name_Length * sizeof(char));
    char             ch;
    int              i, j;
    char             LibraryRead = 0;
    CellTypeStruct** TempCellTypes;
    std::string ErrorMessage;

    Library->NumberOfCellTypes = 0;
    LibraryFile = fopen(LibraryFileName, "rt");

    if (LibraryFile == NULL)
    {
        free(Str1);
        ErrorMessage = LibraryFileName;
        ErrorMessage = "Library file " + ErrorMessage + " not found!";
        throw std::runtime_error(ErrorMessage);
    }

    while ((!LibraryRead) && (!feof(LibraryFile)))
    {
        Str1[0] = 0;
        while (strcmp(Str1, "Library") && (!feof(LibraryFile)))
            Hardware::Read::NonCommentFromFile(LibraryFile, Str1, "%");

        if (!feof(LibraryFile))
        {
            Hardware::Read::NonCommentFromFile(LibraryFile, Str1, "%");
            if (!strcmp(Str1, LibraryName))
            {
                Hardware::Read::NonCommentFromFile(LibraryFile, Str1, "%");

                while (strcmp(Str1, "Library") && (!feof(LibraryFile)))
                {
                    TempCellTypes = (CellTypeStruct**)malloc((Library->NumberOfCellTypes + 1) * sizeof(CellTypeStruct*));
                    memcpy(TempCellTypes, Library->CellTypes, Library->NumberOfCellTypes * sizeof(CellTypeStruct*));
                    free(Library->CellTypes);
					Library->CellTypes = TempCellTypes;

					Library->CellTypes[Library->NumberOfCellTypes] = (CellTypeStruct*)malloc(sizeof(CellTypeStruct));
                    if (!strcmp(Str1, "Gate"))
						Library->CellTypes[Library->NumberOfCellTypes]->GateOrReg = CellType_Gate;
                    else if (!strcmp(Str1, "Reg"))
						Library->CellTypes[Library->NumberOfCellTypes]->GateOrReg = CellType_Reg;
                    else if (!strcmp(Str1, "Buffer"))
                    {
						Library->CellTypes[Library->NumberOfCellTypes]->GateOrReg = CellType_Gate;
						Library->BufferCellType = Library->NumberOfCellTypes;
                    }
                    else
                    {
                        ErrorMessage = Str1;
                        ErrorMessage = "Cell type " + ErrorMessage + " in library is not known!";
                        fclose(LibraryFile);
                        free(Str1);
                        throw std::runtime_error(ErrorMessage);
                    }

                    Hardware::Read::NonCommentFromFile(LibraryFile, Str1, "%");
					Library->CellTypes[Library->NumberOfCellTypes]->NumberOfCases = atoi(Str1);
					Library->CellTypes[Library->NumberOfCellTypes]->Cases = (char**)malloc(Library->CellTypes[Library->NumberOfCellTypes]->NumberOfCases * sizeof(char*));

                    for (i = 0; i < Library->CellTypes[Library->NumberOfCellTypes]->NumberOfCases; i++)
                    {
                        Hardware::Read::NonCommentFromFile(LibraryFile, Str1, "%");
						Library->CellTypes[Library->NumberOfCellTypes]->Cases[i] = (char*)malloc(Max_Name_Length);
                        strncpy(Library->CellTypes[Library->NumberOfCellTypes]->Cases[i], Str1, Max_Name_Length - 1);
                        Library->CellTypes[Library->NumberOfCellTypes]->Cases[i][Max_Name_Length - 1] = '\0';

                    }

                    Hardware::Read::NonCommentFromFile(LibraryFile, Str1, "%");
					Library->CellTypes[Library->NumberOfCellTypes]->NumberOfInputs = atoi(Str1);
					Library->CellTypes[Library->NumberOfCellTypes]->Inputs = (char**)malloc(Library->CellTypes[Library->NumberOfCellTypes]->NumberOfInputs * sizeof(char*));

                    for (i = 0; i < Library->CellTypes[Library->NumberOfCellTypes]->NumberOfInputs; i++)
                    {
                        Hardware::Read::NonCommentFromFile(LibraryFile, Str1, "%");
						Library->CellTypes[Library->NumberOfCellTypes]->Inputs[i] = (char*)malloc(Max_Name_Length);
                        strncpy(Library->CellTypes[Library->NumberOfCellTypes]->Inputs[i], Str1, Max_Name_Length - 1);
                        Library->CellTypes[Library->NumberOfCellTypes]->Inputs[i][Max_Name_Length - 1] = '\0';
                    }

                    Hardware::Read::NonCommentFromFile(LibraryFile, Str1, "%");
					Library->CellTypes[Library->NumberOfCellTypes]->NumberOfOutputs = atoi(Str1);
					Library->CellTypes[Library->NumberOfCellTypes]->Outputs = (char**)malloc(Library->CellTypes[Library->NumberOfCellTypes]->NumberOfOutputs * sizeof(char*));

                    for (i = 0; i < Library->CellTypes[Library->NumberOfCellTypes]->NumberOfOutputs; i++)
                    {
                        Hardware::Read::NonCommentFromFile(LibraryFile, Str1, "%");
						Library->CellTypes[Library->NumberOfCellTypes]->Outputs[i] = (char*)malloc(Max_Name_Length);
                        strncpy(Library->CellTypes[Library->NumberOfCellTypes]->Outputs[i], Str1, Max_Name_Length - 1);
                        Library->CellTypes[Library->NumberOfCellTypes]->Outputs[i][Max_Name_Length - 1] = '\0';
                    }

					Library->CellTypes[Library->NumberOfCellTypes]->Expresions = (char**)malloc(Library->CellTypes[Library->NumberOfCellTypes]->NumberOfOutputs * sizeof(char*));

                    for (i = 0; i < Library->CellTypes[Library->NumberOfCellTypes]->NumberOfOutputs; i++)
                    {
                        Str1[0] = 0;
                        j = 0;
                        do
                        {
                            ch = fgetc(LibraryFile);
                            if ((ch != '\n') && (ch != '\r'))
                                Str1[j++] = ch;
                        } while ((((ch != '\n') && (ch != '\r'))) || (!j));

                        Str1[j] = 0;
						Library->CellTypes[Library->NumberOfCellTypes]->Expresions[i] = (char *)malloc(Max_Name_Length);
                        strncpy(Library->CellTypes[Library->NumberOfCellTypes]->Expresions[i], Str1, Max_Name_Length - 1);
                        Library->CellTypes[Library->NumberOfCellTypes]->Expresions[i][Max_Name_Length - 1] = '\0';
                    }

                    if (Hardware::Read::MakeFormulaForCellInLibrary(Library->CellTypes[Library->NumberOfCellTypes]))
                        throw std::runtime_error("Formula error!");

					Library->NumberOfCellTypes++;
                    Hardware::Read::NonCommentFromFile(LibraryFile, Str1, "%");
                }

                LibraryRead = 1;
            }
        }
    }

    fclose(LibraryFile);
    free(Str1);

    if (!LibraryRead)
    {
        throw std::runtime_error("Library could not be found");
    }

    std::cout << "done!" << std::endl;
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

int Hardware::Read::SearchSignalName(CircuitStruct* Circuit, char* SignalName, char Trim, SettingsStruct* Settings)
{
	int    SignalIndex = -1;
	int    Index;
	int    size;
	char   flag = 0;
	int    no_of_Threads = 0;

	if (Trim)
		size = strlen(SignalName);
	else
		size = Max_Name_Length;

	no_of_Threads = ceil(Circuit->NumberOfSignals / 10000);
	if (no_of_Threads > Settings->Max_no_of_Threads)
		no_of_Threads = Settings->Max_no_of_Threads;

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
                                             LibraryStruct* Library, CircuitStruct* Circuit, int NumberOfSignalsOffset,
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
			for (InputIndex = 0; InputIndex < Library->CellTypes[CellTypeIndex]->NumberOfInputs; InputIndex++)
			{
				strncpy(Str2, Library->CellTypes[CellTypeIndex]->Inputs[InputIndex], Max_Name_Length - 1);
				i = TrimSignalName(Str2);

				if ((!strcmp(Str1 + 1, Library->CellTypes[CellTypeIndex]->Inputs[InputIndex])) ||
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
				for (OutputIndex = 0; OutputIndex < Library->CellTypes[CellTypeIndex]->NumberOfOutputs; OutputIndex++)
				{
					strncpy(Str2, Library->CellTypes[CellTypeIndex]->Outputs[OutputIndex], Max_Name_Length - 1);
					i = TrimSignalName(Str2);

					if ((!strcmp(Str1 + 1, Library->CellTypes[CellTypeIndex]->Outputs[OutputIndex])) ||
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
					ErrorMessage = "IO port " + ErrorMessage + " not found in cell type \"" + Library->CellTypes[CellTypeIndex]->Cases[CaseIndex] + "\"!";
					throw std::runtime_error(ErrorMessage);
				}
			}
		}
		else
		{
			for (InputIndex = 0; InputIndex < Circuit->Cells[Circuit->NumberOfCells]->NumberOfInputs; InputIndex++)
				if (Circuit->Cells[Circuit->NumberOfCells]->Inputs[InputIndex] == -1)
				{
					ErrorMessage = "Input port \"" + (std::string)Library->CellTypes[CellTypeIndex]->Inputs[InputIndex] + "\" of cell \"" + (std::string)Circuit->Cells[Circuit->NumberOfCells]->Name + "\" cannot be left unconnected!";
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
                                                 SettingsStruct* Settings, LibraryStruct* Library, CircuitStruct* Circuit, int Task,
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
				SignalIndex = Hardware::Read::SearchSignalName(Circuit, strptr, 1, Settings);

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
				SignalIndex = Hardware::Read::SearchSignalName(Circuit, strptr, 0, Settings);

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

					SignalIndex = Hardware::Read::SearchSignalName(Circuit, Str3, 0, Settings);

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
				ErrorMessage = "Input port \"" + (std::string)Library->CellTypes[CellTypeIndex]->Inputs[InputPorts[0]] + "\" of cell type \"" + Library->CellTypes[CellTypeIndex]->Cases[CaseIndex] + "\" cannot be left unconnected!";
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
			CellTypeIndex = Library->BufferCellType; // not necessary

			TempCells = (CellStruct **)malloc((Circuit->NumberOfCells + 1) * sizeof(CellStruct *));
			memcpy(TempCells, Circuit->Cells, Circuit->NumberOfCells * sizeof(CellStruct *));
			free(Circuit->Cells);
			Circuit->Cells = TempCells;

			Circuit->Cells[Circuit->NumberOfCells] = (CellStruct *)malloc(sizeof(CellStruct));
			Circuit->Cells[Circuit->NumberOfCells]->Type = CellTypeIndex;
			Circuit->Cells[Circuit->NumberOfCells]->NumberOfInputs = Library->CellTypes[CellTypeIndex]->NumberOfInputs;
			Circuit->Cells[Circuit->NumberOfCells]->Inputs = (int *)malloc(Library->CellTypes[CellTypeIndex]->NumberOfInputs * sizeof(int));
			Circuit->Cells[Circuit->NumberOfCells]->NumberOfOutputs = Library->CellTypes[CellTypeIndex]->NumberOfOutputs;
			Circuit->Cells[Circuit->NumberOfCells]->Outputs = (int *)malloc(Library->CellTypes[CellTypeIndex]->NumberOfOutputs * sizeof(int));
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
						if (Library->CellTypes[CellTypeIndex]->GateOrReg == CellType_Reg)
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
}

void Hardware::Read::DesignFile(char *InputVerilogFileName, char *MainModuleName,
                                Hardware::SettingsStruct* Settings, Hardware::LibraryStruct* Library, Hardware::CircuitStruct* Circuit,
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

    std::cout << "\"" << MainModuleName << "\"..." << std::flush;

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
	Circuit->Signals[0]->ProbeAllowed = 0;
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
	Circuit->Signals[1]->ProbeAllowed = 0;
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
	Circuit->Signals[2]->ProbeAllowed = 0;
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
	Circuit->Signals[3]->ProbeAllowed = 0;
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
	Circuit->Signals[4]->ProbeAllowed = 0;
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
	Circuit->Signals[5]->ProbeAllowed = 0;
	Circuit->Signals[5]->Deleted = 0;

    //---------------------------------------------------------------------------------------------//
    //------------------- reading the Circuit->Signals from the design file --------------------------------//

	if (FB == NULL)
	{
		DesignFile = fopen(InputVerilogFileName, "rt");

		if (DesignFile == NULL)
		{
			ErrorMessage = InputVerilogFileName;
			ErrorMessage = "Design file " + ErrorMessage + " not found!";
			free(Str1);
			free(Str2);
			free(Phrase);
			free(SubCircuitInstanceName);
			throw std::runtime_error(ErrorMessage);
		}

		if (stat(InputVerilogFileName, &file_status))
		{
			ErrorMessage = InputVerilogFileName;
			ErrorMessage = "\ncannot find the size of design file " + ErrorMessage;
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
            if (strcmp(Str1, MainModuleName))
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

									SignalIndex = Hardware::Read::SearchSignalName(Circuit, Str2, 0, Settings);

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
										Circuit->Signals[Circuit->NumberOfSignals]->ProbeAllowed = 1;
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
                                                if (Library->BufferCellType > -1)
                                                {
                                                	CellTypeIndex = Library->BufferCellType;

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
                                                for (CellTypeIndex = 0; CellTypeIndex < Library->NumberOfCellTypes; CellTypeIndex++)
                                                {
                                                    for (CaseIndex = 0; CaseIndex < Library->CellTypes[CellTypeIndex]->NumberOfCases; CaseIndex++)
                                                        if (!strcmp(Str1, Library->CellTypes[CellTypeIndex]->Cases[CaseIndex]))
                                                            break;

                                                    if (CaseIndex < Library->CellTypes[CellTypeIndex]->NumberOfCases)
                                                        break;
                                                }

												if (CellTypeIndex < Library->NumberOfCellTypes)
												{
													TempCells = (CellStruct **)malloc((Circuit->NumberOfCells + 1) * sizeof(CellStruct *));
													memcpy(TempCells, Circuit->Cells, Circuit->NumberOfCells * sizeof(CellStruct *));
													free(Circuit->Cells);
													Circuit->Cells = TempCells;

													Circuit->Cells[Circuit->NumberOfCells] = (CellStruct *)malloc(sizeof(CellStruct));
													Circuit->Cells[Circuit->NumberOfCells]->Type = CellTypeIndex;
													Circuit->Cells[Circuit->NumberOfCells]->NumberOfInputs = Library->CellTypes[CellTypeIndex]->NumberOfInputs;
													Circuit->Cells[Circuit->NumberOfCells]->Inputs = (int *)malloc(Library->CellTypes[CellTypeIndex]->NumberOfInputs * sizeof(int));
													Circuit->Cells[Circuit->NumberOfCells]->NumberOfOutputs = Library->CellTypes[CellTypeIndex]->NumberOfOutputs;
													Circuit->Cells[Circuit->NumberOfCells]->Outputs = (int *)malloc(Library->CellTypes[CellTypeIndex]->NumberOfOutputs * sizeof(int));
													Circuit->Cells[Circuit->NumberOfCells]->Deleted = 0;

													for (InputIndex = 0;InputIndex < Circuit->Cells[Circuit->NumberOfCells]->NumberOfInputs; InputIndex++)
														Circuit->Cells[Circuit->NumberOfCells]->Inputs[InputIndex] = -1;

													for (OutputIndex = 0;OutputIndex < Circuit->Cells[Circuit->NumberOfCells]->NumberOfOutputs; OutputIndex++)
														Circuit->Cells[Circuit->NumberOfCells]->Outputs[OutputIndex] = -1;

													if (Library->CellTypes[CellTypeIndex]->GateOrReg == CellType_Gate)
													{
														Circuit->Cells[Circuit->NumberOfCells]->Depth = -1;

														TempGates = (int *)malloc((Circuit->NumberOfGates + 1) * sizeof(int));
														memcpy(TempGates, Circuit->Gates, Circuit->NumberOfGates * sizeof(int));
														free(Circuit->Gates);
														Circuit->Gates = TempGates;

														Circuit->Gates[Circuit->NumberOfGates] = Circuit->NumberOfCells + NumberOfCellsOffset;
														Circuit->NumberOfGates++;
													}
													else // CellType_Reg
													{
														Circuit->Cells[Circuit->NumberOfCells]->Depth = 0;
														Circuit->Cells[Circuit->NumberOfCells]->RegValueIndexes = (int *)malloc(Library->CellTypes[CellTypeIndex]->NumberOfOutputs * sizeof(int));
														for (OutputIndex = 0; OutputIndex < Library->CellTypes[CellTypeIndex]->NumberOfOutputs; OutputIndex++)
															Circuit->Cells[Circuit->NumberOfCells]->RegValueIndexes[OutputIndex] = NumberOfRegValuesOffset + Circuit->NumberOfRegValues++;

														TempRegs = (int *)malloc((Circuit->NumberOfRegs + 1) * sizeof(int));
														memcpy(TempRegs, Circuit->Regs, Circuit->NumberOfRegs * sizeof(int));
														free(Circuit->Regs);
														Circuit->Regs = TempRegs;

														Circuit->Regs[Circuit->NumberOfRegs] = Circuit->NumberOfCells + NumberOfCellsOffset;
														Circuit->NumberOfRegs++;
													}

													Task = Task_find_module_name;
													MyNumberofIO = Library->CellTypes[CellTypeIndex]->NumberOfInputs + Library->CellTypes[CellTypeIndex]->NumberOfOutputs;
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

													Hardware::Read::DesignFile(InputVerilogFileName, Str1, Settings, Library, &SubCircuit,
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
												DesignFile_Find_IO_Port(Str1, SubCircuitRead, CellTypeIndex, CaseIndex, Library, Circuit, NumberOfSignalsOffset,
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
											DesignFile_Find_Signal_Name(Str1, SubCircuitRead, CellTypeIndex, CaseIndex, Settings, Library, Circuit, Task,
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
											DesignFile_Find_IO_Port(Str1, SubCircuitRead, CellTypeIndex, CaseIndex, Library, Circuit, NumberOfSignalsOffset,
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
										DesignFile_Find_Signal_Name(Str1, SubCircuitRead, CellTypeIndex, CaseIndex, Settings, Library, Circuit, Task,
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
										DesignFile_Find_IO_Port(Str1, SubCircuitRead, CellTypeIndex, CaseIndex, Library, Circuit, NumberOfSignalsOffset,
																SubCircuitInstanceName, &SubCircuit,
																InputPorts, NumberOfInputPorts, OutputPorts, NumberOfOutputPorts);

										Str1[0] = 0;
										DesignFile_Find_Signal_Name(Str1, SubCircuitRead, CellTypeIndex, CaseIndex, Settings, Library, Circuit, Task,
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
        ErrorMessage = MainModuleName;
        ErrorMessage = "Target module " + ErrorMessage + " not found!";
        throw std::runtime_error(ErrorMessage);
    }

    // turn '1bx' and '1hx' to constant 0
    strncpy(Circuit->Signals[4]->Name, "1'b0", Max_Name_Length - 1);
    Circuit->Signals[4]->Name[Max_Name_Length - 1] = '\0';
    strncpy(Circuit->Signals[5]->Name, "1'h0", Max_Name_Length - 1);
    Circuit->Signals[5]->Name[Max_Name_Length - 1] = '\0';
}

void Hardware::Read::SettingsFile_BeforeDesign(char *InputSettingsFileName, Hardware::SettingsStruct* Settings)
{
    std::cout << "Read settings file before design file..." << std::flush;
    char*     Str1 = (char *)malloc(Max_Name_Length * sizeof(char));
    FILE*     SettingsFile;
    uint64_t  SettingsFileCheckList = 0;
	char*     tmptr;
	int		  templ;
    std::string ErrorMessage;
    std::vector<std::string> Warnings;

    SettingsFile = fopen(InputSettingsFileName, "rt");

    if (SettingsFile == NULL)
    {
        ErrorMessage = "Settings file " + (std::string)InputSettingsFileName + " not found!";
        free(Str1);
        throw std::runtime_error(ErrorMessage);
    }

    do
    {
        Str1[0] = 0;
        Hardware::Read::NonCommentFromFile(SettingsFile, Str1, "%");

		if (!strcmp(Str1, "max_no_of_threads"))
		{
			CpuCoreSelector cpu_core_selector;
			Hardware::Read::NonCommentFromFile(SettingsFile, Str1, "%");

            if (!strcmp(Str1, "all")){
				Settings->Max_no_of_Threads = cpu_core_selector.getOptimalCount(CpuSelectionOption::all);
            }else if (!strcmp(Str1, "half")){
				Settings->Max_no_of_Threads = cpu_core_selector.getOptimalCount(CpuSelectionOption::half);
			}else if (!strcmp(Str1, "third")){
				Settings->Max_no_of_Threads = cpu_core_selector.getOptimalCount(CpuSelectionOption::third);
			}else if (!strcmp(Str1, "quarter")){
				Settings->Max_no_of_Threads = cpu_core_selector.getOptimalCount(CpuSelectionOption::quarter);
			}else{
				templ = strtol(Str1, &tmptr, 10);
				if ((*tmptr) ||
					(templ < 1))
				{
					ErrorMessage = "Given \"max_no_of_threads\" (" + (std::string)Str1 + " > 0) in settings file is not valid!";
					fclose(SettingsFile);
					free(Str1);
					throw std::runtime_error(ErrorMessage);
				}

				Settings->Max_no_of_Threads = cpu_core_selector.getOptimalCount(CpuSelectionOption::specific, templ);
			}

			SettingsFileCheckList |= (1 << 0);
		}
    } while (!feof(SettingsFile));

    fclose(SettingsFile);
    free(Str1);

	//---------------------------------------------------------------------
	// check optional inputs

	if (!(SettingsFileCheckList & (1 << 0))){
        Settings->Max_no_of_Threads = 1;
        Warnings.push_back("Warning \"max_no_of_threads\" is not specified. Default \"max_no_of_threads\" = 1 is taken!");
    }

	if (Settings->Max_no_of_Threads > omp_get_num_procs()){
		Settings->Max_no_of_Threads = omp_get_num_procs();
		ErrorMessage = "Warning \"max_no_of_threads\" is larger than available cores, reduced to " + std::to_string(omp_get_num_procs()) + "!";
        Warnings.push_back(ErrorMessage);
	}

	std::cout << "done with " << Warnings.size() << " warnings!" << std::endl;

    for (size_t WarningIndex = 0; WarningIndex < Warnings.size(); WarningIndex++){
        std::cout << "    " << Warnings.at(WarningIndex) << std::endl;
    }
}

void Hardware::Read::SettingsFile(char *InputSettingsFileName, Hardware::CircuitStruct* Circuit, Hardware::SettingsStruct* Settings)
{
    std::cout << "Read settings file..." << std::flush;
    char*     Str1 = (char *)malloc(Max_Name_Length * sizeof(char));
    char*     Str2 = (char *)malloc(Max_Name_Length * sizeof(char));
    char*     Str3 = (char *)malloc(Max_Name_Length * sizeof(char));
    int       i, j;
    int       InputIndex;
    int       SignalIndex;
    int       IndexH,  IndexL;
    int       IndexH2, IndexL2;
	int       ShareIndex;
    FILE*     SettingsFile;
    uint64_t  SettingsFileCheckList = 0;
    int       ClockCycle;
    int       InitialSim_NumberOfInputBlocksGeneral = -1;
    int       InitialSim_NumberOfInputBlocksLocal = -1;
    int       InitialSim_NumberOfInputBlocks = -1;
    int       TempIndex;
    int*      InitialInputList = NULL;
    int       LocalCounter = 0;
    int       Repeat = 0;
    int       Repeated = 0;
    int*      Buffer_int;
    uint64_t* Buffer_U64;
    int       NumberOfBuffer_char;
    char*     str_ptr;
    int       v;
    int       NumberOfItems;
    int       NumberOfEntries;
    int       EntryIndex;
	int       GroupIndex;
	char      OneFound;
	char*     tmptr;
	int64_t   templl;
	int		  templ;
    std::string ErrorMessage;
    std::vector<std::string> Warnings;

    SettingsFile = fopen(InputSettingsFileName, "rt");

    if (SettingsFile == NULL)
    {
        ErrorMessage = "Settings file " + (std::string)InputSettingsFileName + " not found!";
        free(Str1);
        free(Str2);
        free(Str3);
        throw std::runtime_error(ErrorMessage);
    }

    do
    {
        Str1[0] = 0;
        Hardware::Read::NonCommentFromFile(SettingsFile, Str1, "%");

		if (!strcmp(Str1, "max_no_of_threads"))
		{
			Hardware::Read::NonCommentFromFile(SettingsFile, Str1, "%");

			// is already processed in Hardware::Read::SettingsFile_BeforeDesign

		}
		else if (!strcmp(Str1, "no_of_groups"))
		{
			Hardware::Read::NonCommentFromFile(SettingsFile, Str1, "%");
			templ = strtol(Str1, &tmptr, 10);
			if ((*tmptr) ||
			    (templ < 2))
			{
                ErrorMessage = "Given \"no_of_groups\" (" + (std::string)Str1 + " > 1) in settings file is not valid!";
				fclose(SettingsFile);
				free(Str1);
				free(Str2);
				free(Str3);
                throw std::runtime_error(ErrorMessage);
			}

			Settings->NumberOfGroups = templ;
			Settings->Group_Values = (int**)malloc(Settings->NumberOfGroups * sizeof(int*));
			Settings->NumberOfGroupValues = 0;

			for (GroupIndex = 0;GroupIndex < Settings->NumberOfGroups;GroupIndex++)
			{
				Settings->Group_Values[GroupIndex] = NULL;
				NumberOfBuffer_char = 0;
				Hardware::Read::NonCommentFromFile(SettingsFile, Str1, "%");

				strncpy(Str2, Str1, Max_Name_Length - 1);
				Str2[Max_Name_Length - 1] = '\0';
				str_ptr = strchr(Str2, '\'');
				*str_ptr = 0;

				templ = strtol(Str2, &tmptr, 10);
				if ((*tmptr) ||
					(templ < 1))
				{
                    ErrorMessage = "Given length (" + (std::string)Str2 + " > 0) for " + (std::string)Str1 + " in settings file is not valid!";
                    fclose(SettingsFile);
                    free(Str1);
                    free(Str2);
                    free(Str3);
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
                    ErrorMessage = "Length " + (std::string)Str1 + " in settings file does not match to the other sizes!";
                    fclose(SettingsFile);
                    free(Str1);
                    free(Str2);
                    free(Str3);
                    throw std::runtime_error(ErrorMessage);
				}

				strncpy(Str3, str_ptr + 1, Max_Name_Length - 1);
				Str3[Max_Name_Length - 1] = '\0';
				strncpy(Str2, Str3, Max_Name_Length - 1);
				Str2[Max_Name_Length - 1] = '\0';
				strncpy(Str3, Str1, Max_Name_Length - 1);
				Str3[Max_Name_Length - 1] = '\0';
				strncpy(Str1, Str2 + 1, Max_Name_Length - 1);
				Str1[Max_Name_Length - 1] = '\0';

				if (Str2[0] == 'h')
				{
					for (j = 0; j < Settings->NumberOfGroupValues; j += 4)
					{
						if (!strlen(Str1))
						{
                            ErrorMessage = "Length " + (std::string)Str3 + " in settings file does not match to the given size!";
                            fclose(SettingsFile);
                            free(Str1);
                            free(Str2);
                            free(Str3);
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
                            ErrorMessage = "Length " + (std::string)Str3 + " in settings file does not match to the given size!";
                            fclose(SettingsFile);
                            free(Str1);
                            free(Str2);
                            free(Str3);
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
                    ErrorMessage = "Base in settings file not known in " + (std::string)Str3 + "!";
                    fclose(SettingsFile);
                    free(Str1);
                    free(Str2);
                    free(Str3);
                    throw std::runtime_error(ErrorMessage);
				}

				if (strlen(Str1))
				{
                    ErrorMessage = "Length " + (std::string)Str3 + " in settings file does not match to the given size!";
                    fclose(SettingsFile);
                    free(Str1);
                    free(Str2);
                    free(Str3);
                    throw std::runtime_error(ErrorMessage);
				}
			}

			SettingsFileCheckList |= (1 << 1);
		}
		else if (!strcmp(Str1, "order_of_test"))
		{
			Hardware::Read::NonCommentFromFile(SettingsFile, Str1, "%");
			templ = strtol(Str1, &tmptr, 10);
			if ((*tmptr) || (templ < 1))
			{
                ErrorMessage = "Given \"order_of_test\" (" + (std::string)Str1 + " > 0) in settings file is not valid!";
				fclose(SettingsFile);
				free(Str1);
				free(Str2);
				free(Str3);
                throw std::runtime_error(ErrorMessage);
			}

			Settings->TestOrder = templ;
			SettingsFileCheckList |= (1 << 2);
		}
		else if (!strcmp(Str1, "clock_signal_name"))
        {
            Hardware::Read::NonCommentFromFile(SettingsFile, Str1, "%");

            for (SignalIndex = 0; SignalIndex < Circuit->NumberOfSignals; SignalIndex++)
                if (!strcmp(Circuit->Signals[SignalIndex]->Name, Str1))
                    break;

            if (SignalIndex >= Circuit->NumberOfSignals)
            {
                ErrorMessage = "Signal " + (std::string)Str1 + " as clock signal in settings file not found!";
				fclose(SettingsFile);
				free(Str1);
				free(Str2);
				free(Str3);
                throw std::runtime_error(ErrorMessage);
            }

			Settings->ClockSignal = SignalIndex;
            SettingsFileCheckList |= (1 << 3);
        }
        else if (!strcmp(Str1, "max_clock_cycle"))
        {
            Hardware::Read::NonCommentFromFile(SettingsFile, Str1, "%");
			templ = strtol(Str1, &tmptr, 10);
			if ((*tmptr) || (templ < 1))
			{
                ErrorMessage = "Given \"Max_No_ClockCycles\" (" + (std::string)Str1 + " > 0) in settings file is not valid!";
				fclose(SettingsFile);
				free(Str1);
				free(Str2);
				free(Str3);
                throw std::runtime_error(ErrorMessage);
			}

            Settings->Max_No_ClockCycles = templ;
            SettingsFileCheckList |= (1 << 4);
        }
		else if (!strcmp(Str1, "no_of_always_random_inputs"))
		{
			Hardware::Read::NonCommentFromFile(SettingsFile, Str1, "%");
			templ = strtol(Str1, &tmptr, 10);
			if ((*tmptr) ||
			    (templ < 0))
			{
                ErrorMessage = "Given \"no_of_always_random_inputs\" (" + (std::string)Str1 + " >= 0) in settings file is not valid!";
				fclose(SettingsFile);
				free(Str1);
				free(Str2);
				free(Str3);
                throw std::runtime_error(ErrorMessage);
			}

			NumberOfEntries = templ;
			Settings->AlwaysRandomInputs = NULL;
			Settings->NumberOfAlwaysRandomInputs = 0;

			for (EntryIndex = 0; EntryIndex < NumberOfEntries; EntryIndex++)
			{
				Hardware::Read::NonCommentFromFile(SettingsFile, Str1, "%");

				if ((Str1[0] == '[') && (Str1[strlen(Str1) - 1] == ']'))
				{
					strncpy(Str2, Str1 + 1, Max_Name_Length - 1);
					Str2[Max_Name_Length - 1] = '\0';
					Str2[strlen(Str2) - 1] = 0;
					str_ptr = strchr(Str2, ':');
					if (str_ptr != NULL)
					{
						*str_ptr = 0;
						templ = strtol(Str2, &tmptr, 10);
						if ((*tmptr) || (templ < 0))
						{
                            ErrorMessage = "Given statement (" + (std::string)Str2 + " >= 0) in settings file is not valid!";
                            fclose(SettingsFile);
                            free(Str1);
                            free(Str2);
                            free(Str3);
                            throw std::runtime_error(ErrorMessage);
						}

						IndexH = templ;

						templ = strtol(str_ptr + 1, &tmptr, 10);
						if ((*tmptr) || (templ < 0))
						{
                            ErrorMessage = "Given statement (" + (std::string)str_ptr + " >= 0) in settings file is not valid!";
                            fclose(SettingsFile);
                            free(Str1);
                            free(Str2);
                            free(Str3);
                            throw std::runtime_error(ErrorMessage);
						}

						IndexL = templ;
					}
					else
					{
						templ = strtol(Str2, &tmptr, 10);
						if ((*tmptr) || (templ < 0))
						{
                            ErrorMessage = "Given statement (" + (std::string)Str2 + " >= 0) in settings file is not valid!";
                            fclose(SettingsFile);
                            free(Str1);
                            free(Str2);
                            free(Str3);
                            throw std::runtime_error(ErrorMessage);
						}

						IndexH = templ;
						IndexL = IndexH;
					}

					Hardware::Read::NonCommentFromFile(SettingsFile, Str1, "%");
				}
				else
				{
					IndexL = -1;
					IndexH = -1;
				}

				for (j = IndexL; j <= IndexH; j++)
				{
					if (IndexL != -1)
						sprintf(Str2, "%s[%d]", Str1, j);
					else
						sprintf(Str2, "%s", Str1);

					for (SignalIndex = 0; SignalIndex < Circuit->NumberOfSignals; SignalIndex++)
						if (!strcmp(Circuit->Signals[SignalIndex]->Name, Str2))
							break;

					if (SignalIndex >= Circuit->NumberOfSignals)
					{
                        ErrorMessage = "Signal " + (std::string)Str2 + " in settings file as always random input signal not found!";
                        fclose(SettingsFile);
                        free(Str1);
                        free(Str2);
                        free(Str3);
                        throw std::runtime_error(ErrorMessage);
					}

					Buffer_int = (int*)malloc((Settings->NumberOfAlwaysRandomInputs + 1) * sizeof(int));
					memcpy(Buffer_int, Settings->AlwaysRandomInputs, Settings->NumberOfAlwaysRandomInputs * sizeof(int));
					free(Settings->AlwaysRandomInputs);
					Settings->AlwaysRandomInputs = Buffer_int;

					Settings->AlwaysRandomInputs[Settings->NumberOfAlwaysRandomInputs] = SignalIndex;
					Settings->NumberOfAlwaysRandomInputs++;
				}
			}

			SettingsFileCheckList |= (1 << 5);
		}
		else if (!strcmp(Str1, "no_of_initial_inputs"))
		{
			Hardware::Read::NonCommentFromFile(SettingsFile, Str1, "%");
			templ = strtol(Str1, &tmptr, 10);
			if ((*tmptr) || (templ < 0))
			{
                ErrorMessage = "Given \"no_of_initial_inputs\" (" + (std::string)Str1 + " >= 0) in settings file is not valid!";
                fclose(SettingsFile);
                free(Str1);
                free(Str2);
                free(Str3);
                throw std::runtime_error(ErrorMessage);
			}

			InitialSim_NumberOfInputBlocks = templ;
			InitialSim_NumberOfInputBlocksGeneral = InitialSim_NumberOfInputBlocks;
			SettingsFileCheckList |= (1 << 6);
		}
		else if (!strcmp(Str1, "no_of_initial_clock_cycles"))
        {
            Hardware::Read::NonCommentFromFile(SettingsFile, Str1, "%");
			templ = strtol(Str1, &tmptr, 10);
			if ((*tmptr) ||
				(templ < 0))
			{
                ErrorMessage = "Given \"no_of_initial_clock_cycles\" (" + (std::string)Str1 + " >= 0) in settings file is not valid!";
                fclose(SettingsFile);
                free(Str1);
                free(Str2);
                free(Str3);
                throw std::runtime_error(ErrorMessage);
			}

            Settings->InitialSim_NumberOfClockCycles = templ;
			Settings->InitialSim_Inputs = (int**)malloc(Settings->InitialSim_NumberOfClockCycles * sizeof(int*));
			Settings->InitialSim_Values = (uint64_t**)malloc(Settings->InitialSim_NumberOfClockCycles * sizeof(uint64_t*));

            Repeat = 0;
            Repeated = 0;

            for (ClockCycle = 0; ClockCycle < Settings->InitialSim_NumberOfClockCycles; ClockCycle++)
            {
				if (Repeated >= Repeat)
				{
					if (InitialSim_NumberOfInputBlocksGeneral == -1)
					{
						Hardware::Read::NonCommentFromFile(SettingsFile, Str1, "%");
						str_ptr = strchr(Str1, '*');
						if (str_ptr == NULL)
						{
							templ = strtol(Str1, &tmptr, 10);
							if ((*tmptr) || (templ < 0))
							{
								ErrorMessage = "Given \"no_of_initial_inputs\" (" + (std::string)Str1 + " >= 0) after \"no_of_initial_clock_cycles\" in settings file is not valid!";
								fclose(SettingsFile);
								free(Str1);
								free(Str2);
								free(Str3);
								throw std::runtime_error(ErrorMessage);
							}
							Repeat = 1;
							Repeated = 0;
						}
						else
						{
							strncpy(Str2, str_ptr + 1, Max_Name_Length - 1);
							Str2[Max_Name_Length - 1] = '\0';
							*str_ptr = 0;

							templ = strtol(Str1, &tmptr, 10);
							if ((*tmptr) || (templ <= 0))
							{
								ErrorMessage = "Given \"no_of_initial_inputs\" (" + (std::string)Str1 + "*" + (std::string)Str2 + ") after \"no_of_initial_clock_cycles\" in settings file is not valid!";
								fclose(SettingsFile);
								free(Str1);
								free(Str2);
								free(Str3);
								throw std::runtime_error(ErrorMessage);
							}
							Repeat = templ;
							Repeated = 0;

							templ = strtol(Str2, &tmptr, 10);
							if ((*tmptr) || (templ < 0))
							{
								ErrorMessage = "Given \"no_of_initial_inputs\" (" + (std::string)Str1 + "*" + (std::string)Str2 + ") after \"no_of_initial_clock_cycles\" in settings file is not valid!";
								fclose(SettingsFile);
								free(Str1);
								free(Str2);
								free(Str3);
								throw std::runtime_error(ErrorMessage);
							}
						}

						InitialSim_NumberOfInputBlocksLocal = templ;
						if (InitialSim_NumberOfInputBlocks < 0)
						{
							InitialSim_NumberOfInputBlocks = InitialSim_NumberOfInputBlocksLocal;
							SettingsFileCheckList |= (1 << 6);
						}

						if (InitialSim_NumberOfInputBlocksLocal > InitialSim_NumberOfInputBlocks)
						{
							ErrorMessage = "Given \"no_of_initial_inputs\" (" + (std::string)Str1 + ") after \"no_of_initial_clock_cycles\" in settings file cannot be larger than (" + std::to_string(InitialSim_NumberOfInputBlocks) + ")!";
							fclose(SettingsFile);
							free(Str1);
							free(Str2);
							free(Str3);
							throw std::runtime_error(ErrorMessage);
						}
					}
					else
					{
						InitialSim_NumberOfInputBlocksLocal = InitialSim_NumberOfInputBlocks;
						Repeat = 1;
						Repeated = 0;
					}
				}

				if (!ClockCycle)
				{
					Settings->InitialSim_Inputs[ClockCycle] = NULL;
					Settings->InitialSim_NumberOfInputs = 0;
					Settings->InitialSim_Values[ClockCycle] = NULL;
				}
				else
				{
					Settings->InitialSim_Inputs[ClockCycle] = (int*)malloc(Settings->InitialSim_NumberOfInputs * sizeof(int));
					Settings->InitialSim_Values[ClockCycle] = (uint64_t*)malloc(Settings->InitialSim_NumberOfInputs * sizeof(uint64_t));

					memcpy(Settings->InitialSim_Inputs[ClockCycle], Settings->InitialSim_Inputs[ClockCycle - 1], Settings->InitialSim_NumberOfInputs * sizeof(int));
					if (Repeated)
						memcpy(Settings->InitialSim_Values[ClockCycle], Settings->InitialSim_Values[ClockCycle - 1], Settings->InitialSim_NumberOfInputs * sizeof(uint64_t));
					else
						for (LocalCounter = 0; LocalCounter < Settings->InitialSim_NumberOfInputs; LocalCounter++)
							Settings->InitialSim_Values[ClockCycle][LocalCounter] = SameInput;

					if (InitialInputList == NULL)
						InitialInputList = (int*)malloc(Settings->InitialSim_NumberOfInputs * sizeof(int));

					LocalCounter = 0;
				}

                NumberOfBuffer_char = 0;

                for (InputIndex = 0; (InputIndex < InitialSim_NumberOfInputBlocksLocal) && (!Repeated); InputIndex++)
                {
                    Hardware::Read::NonCommentFromFile(SettingsFile, Str1, "%");

                    if ((Str1[0] == '[') && (Str1[strlen(Str1) - 1] == ']'))
                    {
                        strncpy(Str2, Str1 + 1, Max_Name_Length - 1);
                        Str2[Max_Name_Length - 1] = '\0';
                        Str2[strlen(Str2) - 1] = 0;
                        str_ptr = strchr(Str2, ':');
						if (str_ptr != NULL)
						{
							*str_ptr = 0;
							templ = strtol(Str2, &tmptr, 10);
							if ((*tmptr) ||
								(templ < 0))
							{
                                ErrorMessage = "Given statement (" + (std::string)Str2 + " >= 0) in settings file is not valid!";
                                fclose(SettingsFile);
                                free(Str1);
                                free(Str2);
                                free(Str3);
                                throw std::runtime_error(ErrorMessage);
							}

							IndexH = templ;

							templ = strtol(str_ptr + 1, &tmptr, 10);
							if ((*tmptr) ||
								(templ < 0))
							{
                                ErrorMessage = "Given statement (" + (std::string)(str_ptr + 1) + " >= 0) in settings file is not valid!";
                                fclose(SettingsFile);
                                free(Str1);
                                free(Str2);
                                free(Str3);
                                throw std::runtime_error(ErrorMessage);
							}

							IndexL = templ;
						}
						else
						{
							templ = strtol(Str2, &tmptr, 10);
							if ((*tmptr) || (templ < 0))
							{
                                ErrorMessage = "Given statement (" + (std::string)Str2 + " >= 0) in settings file is not valid!";
                                fclose(SettingsFile);
                                free(Str1);
                                free(Str2);
                                free(Str3);
                                throw std::runtime_error(ErrorMessage);
							}

							IndexH = templ;
							IndexL = IndexH;
						}

                        Hardware::Read::NonCommentFromFile(SettingsFile, Str1, "%");
                    }
                    else
                    {
                        IndexL = -1;
                        IndexH = -1;
                    }

                    for (j = IndexL; j <= IndexH; j++)
                    {
                        if (IndexL != -1)
                            sprintf(Str2, "%s[%d]", Str1, j);
                        else
                            sprintf(Str2, "%s", Str1);

                        for (SignalIndex = 0; SignalIndex < Circuit->NumberOfSignals; SignalIndex++)
                        {
                            if (!strcmp(Circuit->Signals[SignalIndex]->Name, Str2))
                                break;
                        }

                        if (SignalIndex >= Circuit->NumberOfSignals)
                        {
                            ErrorMessage = "Signal " + (std::string)Str2 + " in settings file as input signal not found!";
                            fclose(SettingsFile);
                            free(Str1);
                            free(Str2);
                            free(Str3);
                            throw std::runtime_error(ErrorMessage);
                        }

                        if (!ClockCycle)
						{
							Buffer_int = (int*)malloc((Settings->InitialSim_NumberOfInputs + 1) * sizeof(int));
							memcpy(Buffer_int, Settings->InitialSim_Inputs[ClockCycle], Settings->InitialSim_NumberOfInputs * sizeof(int));
							free(Settings->InitialSim_Inputs[ClockCycle]);
							Settings->InitialSim_Inputs[ClockCycle] = Buffer_int;

							Settings->InitialSim_Inputs[ClockCycle][Settings->InitialSim_NumberOfInputs] = SignalIndex;
							Settings->InitialSim_NumberOfInputs++;
						}
						else
						{
							for (TempIndex = 0; TempIndex < Settings->InitialSim_NumberOfInputs; TempIndex++)
								if (Settings->InitialSim_Inputs[0][TempIndex] == SignalIndex)
									break;

							if (TempIndex >= Settings->InitialSim_NumberOfInputs)
							{
								ErrorMessage = "Signal " + (std::string)Str2 + " in settings file as initial input signal not found in the main initial input list!";
								fclose(SettingsFile);
								free(Str1);
								free(Str2);
								free(Str3);
								throw std::runtime_error(ErrorMessage);
							}

							InitialInputList[LocalCounter] = TempIndex;
							LocalCounter++;
						}
                    }

                    Hardware::Read::NonCommentFromFile(SettingsFile, Str1, "%");

					int InvertedInput = 0;
					if (Str1[0] == '~')
					{
						strncpy(Str2, &Str1[1], Max_Name_Length - 2);
						Str2[Max_Name_Length - 1] = '\0';
						strncpy(Str1, Str2, Max_Name_Length - 1);
						Str1[Max_Name_Length - 1] = '\0';
						InvertedInput = 1;
					}

					if (strstr(Str1, "group_in") != Str1)
					{
						strncpy(Str2, Str1, Max_Name_Length - 1);
						Str2[Max_Name_Length - 1] = '\0';
						if (!strcmp(Str2, "$"))
						{
							for (j = IndexL; j <= IndexH; j += 1)
							{
								if (!ClockCycle)
								{
									Buffer_U64 = (uint64_t*)malloc((NumberOfBuffer_char + 1) * sizeof(uint64_t));
									memcpy(Buffer_U64, Settings->InitialSim_Values[ClockCycle], NumberOfBuffer_char * sizeof(uint64_t));
									free(Settings->InitialSim_Values[ClockCycle]);
									Settings->InitialSim_Values[ClockCycle] = Buffer_U64;
									TempIndex = NumberOfBuffer_char;
								}
								else
									TempIndex = InitialInputList[NumberOfBuffer_char];

								Settings->InitialSim_Values[ClockCycle][TempIndex] = RandomInput;
								NumberOfBuffer_char++;
							}
						}
						else
						{
							str_ptr = strchr(Str2, '\'');
							if (str_ptr == NULL)
							{
								ErrorMessage = "Given statement " + (std::string)Str1 + " in settings file is not valid!";
								fclose(SettingsFile);
								free(Str1);
								free(Str2);
								free(Str3);
								throw std::runtime_error(ErrorMessage);
							}

							*str_ptr = 0;
							templ = strtol(Str2, &tmptr, 10);
							if ((*tmptr) || (templ < 1))
							{
								ErrorMessage = "Given length (" + (std::string)Str2 + " > 0) for " +  (std::string)Str1 + " in settings file is not valid!";
								fclose(SettingsFile);
								free(Str1);
								free(Str2);
								free(Str3);
								throw std::runtime_error(ErrorMessage);
							}

							j = templ;
							if (j != (IndexH - IndexL + 1))
							{
								ErrorMessage = "Given length " + (std::string)Str1 + " in settings file does not match to the given size!";
								fclose(SettingsFile);
								free(Str1);
								free(Str2);
								free(Str3);
								throw std::runtime_error(ErrorMessage);
							}

							strncpy(Str3, str_ptr + 1, Max_Name_Length - 1);
							Str3[Max_Name_Length - 1] = '\0';
							strncpy(Str2, Str3, Max_Name_Length - 1);
							Str2[Max_Name_Length - 1] = '\0';

							if (Str2[0] == 'h')
							{
								if ((strlen(&Str2[1]) * 4) != (unsigned int) (1+ IndexH - IndexL))
								{
									ErrorMessage = "Given string for " +  (std::string)Str1 + " in settings file is not valid!";
									fclose(SettingsFile);
									free(Str1);
									free(Str2);
									free(Str3);
									throw std::runtime_error(ErrorMessage);
								}

								for (j = IndexL; j <= IndexH; j += 4)
								{
									Str2[0] = Str1[strlen(Str1) - 1];
									Str2[1] = 0;

									if (!(((Str2[0] >= '0') && (Str2[0] <= '9')) ||
										  ((Str2[0] >= 'a') && (Str2[0] <= 'f')) ||
										  ((Str2[0] >= 'A') && (Str2[0] <= 'F')) ||
										   (Str2[0] == '$')))
									{
										ErrorMessage = "Given string for " +  (std::string)Str1 + " in settings file is not valid!";
										fclose(SettingsFile);
										free(Str1);
										free(Str2);
										free(Str3);
										throw std::runtime_error(ErrorMessage);
									}

									Str1[strlen(Str1) - 1] = 0;

									if (!ClockCycle)
									{
										Buffer_U64 = (uint64_t*)malloc((NumberOfBuffer_char + 4) * sizeof(uint64_t));
										memcpy(Buffer_U64, Settings->InitialSim_Values[ClockCycle], NumberOfBuffer_char * sizeof(uint64_t));
										free(Settings->InitialSim_Values[ClockCycle]);
										Settings->InitialSim_Values[ClockCycle] = Buffer_U64;
									}

									v = strtol(Str2, NULL, 16);
									for (i = 0; i < 4; i++)
									{
										if (!ClockCycle)
											TempIndex = NumberOfBuffer_char;
										else
											TempIndex = InitialInputList[NumberOfBuffer_char];

										if (Str2[0] != '$')
											Settings->InitialSim_Values[ClockCycle][TempIndex] = (v & (1 << i)) ? FullOne : 0;
										else
											Settings->InitialSim_Values[ClockCycle][TempIndex] = RandomInput;

										NumberOfBuffer_char++;
									}
								}
							}
							else if (Str2[0] == 'b')
							{
								if (strlen(&Str2[1]) != (unsigned int)(1 + IndexH - IndexL))
								{
									ErrorMessage = "Given string for " +  (std::string)Str1 + " in settings file is not valid!";
									fclose(SettingsFile);
									free(Str1);
									free(Str2);
									free(Str3);
									throw std::runtime_error(ErrorMessage);
								}

								for (j = IndexL; j <= IndexH; j += 1)
								{
									Str2[0] = Str1[strlen(Str1) - 1];
									Str2[1] = 0;

									if ((Str2[0] != '0') && (Str2[0] != '1') && (Str2[0] != '$'))
									{
										ErrorMessage = "Given string for " +  (std::string)Str1 + " in settings file is not valid!";
										fclose(SettingsFile);
										free(Str1);
										free(Str2);
										free(Str3);
										throw std::runtime_error(ErrorMessage);
									}

									Str1[strlen(Str1) - 1] = 0;

									if (!ClockCycle)
									{
										Buffer_U64 = (uint64_t*)malloc((NumberOfBuffer_char + 1) * sizeof(uint64_t));
										memcpy(Buffer_U64, Settings->InitialSim_Values[ClockCycle], NumberOfBuffer_char * sizeof(uint64_t));
										free(Settings->InitialSim_Values[ClockCycle]);
										Settings->InitialSim_Values[ClockCycle] = Buffer_U64;
										TempIndex = NumberOfBuffer_char;
									}
									else
										TempIndex = InitialInputList[NumberOfBuffer_char];

									v = strtol(Str2, NULL, 2);
									if (Str2[0] != '$')
										Settings->InitialSim_Values[ClockCycle][TempIndex] = v ? FullOne : 0;
									else
										Settings->InitialSim_Values[ClockCycle][TempIndex] = RandomInput;

									NumberOfBuffer_char++;
								}
							}
							else
							{
								ErrorMessage = "Base in settings file not known in " + (std::string)Str1 + "!";
								fclose(SettingsFile);
								free(Str1);
								free(Str2);
								free(Str3);
								throw std::runtime_error(ErrorMessage);
							}
						}
					}
					else
					{
						strncpy(Str2, &Str1[8], Max_Name_Length - 1);
						Str2[Max_Name_Length - 1] = '\0';
						str_ptr = strchr(Str2, '[');
						if (str_ptr == NULL)
						{
                            ErrorMessage = "Wrong given input in settings file in " + (std::string)Str1 + "!";
                            fclose(SettingsFile);
                            free(Str1);
                            free(Str2);
                            free(Str3);
                            throw std::runtime_error(ErrorMessage);
						}

						*str_ptr = 0;
						templ = strtol(Str2, &tmptr, 10);
						if ((*tmptr) ||
							(templ < 0))
						{
                            ErrorMessage = "Given share index (" + (std::string)Str2 + " > 0) for " + (std::string)Str1 + " in settings file is not valid!";
                            fclose(SettingsFile);
                            free(Str1);
                            free(Str2);
                            free(Str3);
                            throw std::runtime_error(ErrorMessage);
						}

						ShareIndex = templ;

						str_ptr = strchr(Str1, '[');
						strncpy(Str2, str_ptr, Max_Name_Length - 1);
						Str2[Max_Name_Length - 1] = '\0';

						if ((Str2[0] == '[') && (Str2[strlen(Str2) - 1] == ']'))
						{
							Str2[strlen(Str2) - 1] = 0;
							str_ptr = strchr(Str2, ':');

							if (str_ptr != NULL)
							{
								*str_ptr = 0;
								templ = strtol(Str2 + 1, &tmptr, 10);
								if ((*tmptr) || (templ < 0))
								{
                                    ErrorMessage = "Given statement (" + (std::string)(Str2 + 1) + " >= 0) in settings file is not valid!";
                                    fclose(SettingsFile);
                                    free(Str1);
                                    free(Str2);
                                    free(Str3);
                                    throw std::runtime_error(ErrorMessage);
								}

								IndexH2 = templ;

								templ = strtol(str_ptr + 1, &tmptr, 10);
								if ((*tmptr) || (templ < 0))
								{
                                    ErrorMessage = "Given statement (" + (std::string)(str_ptr + 1) + " >= 0) in settings file is not valid!";
                                    fclose(SettingsFile);
                                    free(Str1);
                                    free(Str2);
                                    free(Str3);
                                    throw std::runtime_error(ErrorMessage);
								}

								IndexL2 = templ;
							}
							else
							{
								templ = strtol(Str2 + 1, &tmptr, 10);
								if ((*tmptr) || (templ < 0))
								{
                                    ErrorMessage = "Given statement (" + (std::string)(Str2 + 1) + " >= 0) in settings file is not valid!";
                                    fclose(SettingsFile);
                                    free(Str1);
                                    free(Str2);
                                    free(Str3);
                                    throw std::runtime_error(ErrorMessage);
								}

								IndexH2 = templ;
								IndexL2 = IndexH2;
							}
						}
						else
						{
                            ErrorMessage = "Wrong given input in settings file in " + (std::string)Str1 + "!";
                            fclose(SettingsFile);
                            free(Str1);
                            free(Str2);
                            free(Str3);
                            throw std::runtime_error(ErrorMessage);
						}

						if ((IndexH2 - IndexL2) != (IndexH - IndexL))
						{
                            ErrorMessage = "Given length " + (std::string)Str1 + " in settings file does not match to the given size!";
                            fclose(SettingsFile);
                            free(Str1);
                            free(Str2);
                            free(Str3);
                            throw std::runtime_error(ErrorMessage);
						}

						for (j = IndexL; j <= IndexH; j += 1)
						{
							if ((IndexL2 + (j - IndexL)) >= Settings->NumberOfGroupValues)
							{
								ErrorMessage = "Wrong given input in settings file in " + (std::string)Str1 + "!";
								fclose(SettingsFile);
								free(Str1);
								free(Str2);
								free(Str3);
								throw std::runtime_error(ErrorMessage);
							}

							if (!ClockCycle)
							{
								Buffer_U64 = (uint64_t*)malloc((NumberOfBuffer_char + 1) * sizeof(uint64_t));
								memcpy(Buffer_U64, Settings->InitialSim_Values[ClockCycle], NumberOfBuffer_char * sizeof(uint64_t));
								free(Settings->InitialSim_Values[ClockCycle]);
								Settings->InitialSim_Values[ClockCycle] = Buffer_U64;
								TempIndex = NumberOfBuffer_char;
							}
							else
								TempIndex = InitialInputList[NumberOfBuffer_char];

							Settings->InitialSim_Values[ClockCycle][TempIndex]   = (ShareIndex << 1) | InvertedInput;
							Settings->InitialSim_Values[ClockCycle][TempIndex] <<= 32;
							Settings->InitialSim_Values[ClockCycle][TempIndex]  |= IndexL2 + (j - IndexL);
							Settings->InitialSim_Values[ClockCycle][TempIndex]  |= GroupInput;
							NumberOfBuffer_char++;

							if (ShareIndex > Settings->MaxNumberOfSharesGroupValues[IndexL2 + (j - IndexL)])
								Settings->MaxNumberOfSharesGroupValues[IndexL2 + (j - IndexL)] = ShareIndex;
						}
					}
                }

                if (!Repeated)
				{
					if (!ClockCycle)
						TempIndex = Settings->InitialSim_NumberOfInputs;
					else
						TempIndex = LocalCounter;

					if (NumberOfBuffer_char != TempIndex)
					{
						fclose(SettingsFile);
						free(Str1);
						free(Str2);
						free(Str3);
						throw std::runtime_error("Something is wrong in given initial inputs in settings file!");
					}
				}

               	Repeated++;
            }

            if (Repeated < Repeat)
			{
				fclose(SettingsFile);
				free(Str1);
				free(Str2);
				free(Str3);
				throw std::runtime_error("The given cycles for the initial inputs is more than \"no_of_initial_clock_cycles\" in settings file!");
			}

            SettingsFileCheckList |= (1 << 7);
        }
        else if (!strcmp(Str1, "end_condition"))
        {
            Hardware::Read::NonCommentFromFile(SettingsFile, Str1, "%");

            if (!strcmp(Str1, "ClockCycles"))
            {
                Hardware::Read::NonCommentFromFile(SettingsFile, Str1, "%");
				templ = strtol(Str1, &tmptr, 10);
				if ((*tmptr) || (templ < 1))
				{
                    ErrorMessage = "Given \"end_condition\" ClockCycles (" + (std::string)Str1 + " > 0) in settings file is not valid!";
                    fclose(SettingsFile);
                    free(Str1);
                    free(Str2);
                    free(Str3);
                    throw std::runtime_error(ErrorMessage);
				}

                Settings->EndSimCondition_ClockCycles = templ;
				Settings->EndSimCondition_NumberOfSignals = 0;
            }
            else
            {
				Settings->EndSimCondition_ClockCycles = 0;

                if ((Str1[0] == '[') && (Str1[strlen(Str1) - 1] == ']'))
                {
                    strncpy(Str2, Str1 + 1, Max_Name_Length - 1);
                    Str2[Max_Name_Length - 1] = '\0';
                    Str2[strlen(Str2) - 1] = 0;
                    str_ptr = strchr(Str2, ':');

					if (str_ptr != NULL)
					{
						*str_ptr = 0;
						templ = strtol(Str2, &tmptr, 10);
						if ((*tmptr) || (templ < 0))
						{
                            ErrorMessage = "Given statement (" + (std::string)Str2 + " >= 0) in settings file is not valid!";
                            fclose(SettingsFile);
                            free(Str1);
                            free(Str2);
                            free(Str3);
                            throw std::runtime_error(ErrorMessage);
						}

						IndexH = templ;

						templ = strtol(str_ptr + 1, &tmptr, 10);
						if ((*tmptr) || (templ < 0))
						{
                            ErrorMessage = "Given statement (" + (std::string)(str_ptr + 1) + " >= 0) in settings file is not valid!";
                            fclose(SettingsFile);
                            free(Str1);
                            free(Str2);
                            free(Str3);
                            throw std::runtime_error(ErrorMessage);
						}

						IndexL = templ;
					}
					else
					{
						templ = strtol(Str2, &tmptr, 10);
						if ((*tmptr) || (templ < 0))
						{
                            ErrorMessage = "Given statement (" + (std::string)Str2 + " >= 0) in settings file is not valid!";
                            fclose(SettingsFile);
                            free(Str1);
                            free(Str2);
                            free(Str3);
                            throw std::runtime_error(ErrorMessage);
						}

						IndexH = templ;
						IndexL = IndexH;
					}

                    Hardware::Read::NonCommentFromFile(SettingsFile, Str1, "%");
                }
                else
                {
                    IndexL = -1;
                    IndexH = -1;
                }

				Settings->EndSimCondition_NumberOfSignals = 0;
                NumberOfBuffer_char = 0;

                for (j = IndexL; j <= IndexH; j++)
                {
                    if (IndexL != -1)
                        sprintf(Str2, "%s[%d]", Str1, j);
                    else
                        sprintf(Str2, "%s", Str1);

                    for (SignalIndex = 0; SignalIndex < Circuit->NumberOfSignals; SignalIndex++)
                    {
                        if (!strcmp(Circuit->Signals[SignalIndex]->Name, Str2))
                            break;
                    }

                    if (SignalIndex >= Circuit->NumberOfSignals)
                    {
                        ErrorMessage = "Signal " + (std::string)Str2 + " in settings file as input signal not found!";
                        fclose(SettingsFile);
                        free(Str1);
                        free(Str2);
                        free(Str3);
                        throw std::runtime_error(ErrorMessage);
                    }

                    Buffer_int = (int*)malloc((Settings->EndSimCondition_NumberOfSignals + 1) * sizeof(int));
                    memcpy(Buffer_int, Settings->EndSimCondition_Signals, Settings->EndSimCondition_NumberOfSignals * sizeof(int));
                    free(Settings->EndSimCondition_Signals);
					Settings->EndSimCondition_Signals = Buffer_int;

					Settings->EndSimCondition_Signals[Settings->EndSimCondition_NumberOfSignals] = SignalIndex;
					Settings->EndSimCondition_NumberOfSignals++;
                }

                Hardware::Read::NonCommentFromFile(SettingsFile, Str1, "%");

                strncpy(Str2, Str1, Max_Name_Length - 1);
                Str2[Max_Name_Length - 1] = '\0';
                str_ptr = strchr(Str2, '\'');
                *str_ptr = 0;

				templ = strtol(Str2, &tmptr, 10);
				if ((*tmptr) || (templ < 1))
				{
                    ErrorMessage = "Given length (" + (std::string)Str2 + " > 0) for " +  (std::string)Str1 + " in settings file is not valid!";
                    fclose(SettingsFile);
                    free(Str1);
                    free(Str2);
                    free(Str3);
                    throw std::runtime_error(ErrorMessage);
				}

                j = templ;
                if (j != (IndexH - IndexL + 1))
                {
                    ErrorMessage = "Given length " + (std::string)Str1 + " in settings file does not match to the given size!";
                    fclose(SettingsFile);
                    free(Str1);
                    free(Str2);
                    free(Str3);
                    throw std::runtime_error(ErrorMessage);
                }

                strncpy(Str3, str_ptr + 1, Max_Name_Length - 1);
                Str3[Max_Name_Length - 1] = '\0';
		strncpy(Str2, Str3, Max_Name_Length - 1);
		Str2[Max_Name_Length - 1] = '\0';

                if (Str2[0] == 'h')
                {
                    for (j = IndexL; j <= IndexH; j += 4)
                    {
                        Str2[0] = Str1[strlen(Str1) - 1];
                        Str2[1] = 0;
                        Str1[strlen(Str1) - 1] = 0;

                        Buffer_U64 = (uint64_t*)malloc((NumberOfBuffer_char + 4) * sizeof(uint64_t));
                        memcpy(Buffer_U64, Settings->EndSimCondition_Values, NumberOfBuffer_char * sizeof(uint64_t));
                        free(Settings->EndSimCondition_Values);
						Settings->EndSimCondition_Values = Buffer_U64;

                        v = strtol(Str2, NULL, 16);
                        for (i = 0; i < 4; i++)
                        {
							Settings->EndSimCondition_Values[NumberOfBuffer_char] = (v & (1 << i)) ? FullOne : 0;
                            NumberOfBuffer_char++;
                        }
                    }
                }
                else if (Str2[0] == 'b')
                {
                    for (j = IndexL; j <= IndexH; j += 1)
                    {
                        Str2[0] = Str1[strlen(Str1) - 1];
                        Str2[1] = 0;
                        Str1[strlen(Str1) - 1] = 0;

                        Buffer_U64 = (uint64_t *)malloc((NumberOfBuffer_char + 1) * sizeof(uint64_t));
                        memcpy(Buffer_U64, Settings->EndSimCondition_Values, NumberOfBuffer_char * sizeof(uint64_t));
                        free(Settings->EndSimCondition_Values);
						Settings->EndSimCondition_Values = Buffer_U64;

                        v = strtol(Str2, NULL, 2);
						Settings->EndSimCondition_Values[NumberOfBuffer_char] = v ? FullOne : 0;
                        NumberOfBuffer_char++;
                    }
                }
                else
                {
                    ErrorMessage = "Base in settings file not known in " + (std::string)Str1 + "!";
                    fclose(SettingsFile);
                    free(Str1);
                    free(Str2);
                    free(Str3);
                    throw std::runtime_error(ErrorMessage);
                }

                if (NumberOfBuffer_char != Settings->EndSimCondition_NumberOfSignals)
                {
                    fclose(SettingsFile);
                    free(Str1);
                    free(Str2);
					free(Str3);
                    throw std::runtime_error("Something is wrong in given initial inputs in settings file!");
                }
            }

            SettingsFileCheckList |= (1 << 8);
        }
        else if (!strcmp(Str1, "end_wait_cycles"))
        {
            Hardware::Read::NonCommentFromFile(SettingsFile, Str1, "%");
			templ = strtol(Str1, &tmptr, 10);
			if ((*tmptr) || (templ < 0))
			{
                ErrorMessage = "Given \"end_wait_cycles\" length (" + (std::string)Str1 + " >= 0) in settings file is not valid!";
                fclose(SettingsFile);
                free(Str1);
                free(Str2);
                free(Str3);
                throw std::runtime_error(ErrorMessage);
			}

			Settings->EndSim_NumberOfWaitCycles = templ;
            SettingsFileCheckList |= (1 << 9);
        }
        else if (!strcmp(Str1, "probes_include"))
        {
            Hardware::Read::NonCommentFromFile(SettingsFile, Str1, "%");

            if (!strcmp(Str1, "all"))
            {
                for (SignalIndex = 0; SignalIndex < Circuit->NumberOfSignals; SignalIndex++)
					Circuit->Signals[SignalIndex]->ProbeAllowed = 1;
            }
            else
            {
	            if (!strcmp(Str1, "none"))
	            	NumberOfItems = 0;
	            else
	            {
					templ = strtol(Str1, &tmptr, 10);
					if ((*tmptr) || (templ < 0))
					{
                        ErrorMessage = "Given number of \"probes_include\" (" + (std::string)Str1 + " >= 0) in settings file is not valid!";
                        fclose(SettingsFile);
                        free(Str1);
                        free(Str2);
                        free(Str3);
                        throw std::runtime_error(ErrorMessage);
					}

					NumberOfItems = templ;
				}

                for (i = 0; i < NumberOfItems; i++)
                {
                    Hardware::Read::NonCommentFromFile(SettingsFile, Str1, "%");

                    if ((Str1[0] == '{') && (Str1[strlen(Str1)-1] == '}'))
                    {
						Str1[strlen(Str1)-1] = 0;
						strncpy(Str2, &Str1[1], Max_Name_Length - 1);
						Str2[Max_Name_Length - 1] = '\0';
						strncpy(Str1, Str2, Max_Name_Length - 1);
						Str1[Max_Name_Length - 1] = '\0';
						Str2[0] = 2;
					}
					else
						Str2[0] = 1;

					if (Str1[strlen(Str1)-1] == '*')
					{
						Str1[strlen(Str1)-1] = 0;
						OneFound = 0;

						for (SignalIndex = 0; SignalIndex < Circuit->NumberOfSignals; SignalIndex++)
							if (strstr(Circuit->Signals[SignalIndex]->Name, Str1) == Circuit->Signals[SignalIndex]->Name)
							{
								Circuit->Signals[SignalIndex]->ProbeAllowed = Str2[0];
								OneFound = 1;
							}

						if (!OneFound)
						{
                            ErrorMessage = "Given signal name " + (std::string)Str1 + " for \"probes_include\" in settings file does not match to any signal!";
                            fclose(SettingsFile);
                            free(Str1);
                            free(Str2);
                            free(Str3);
                            throw std::runtime_error(ErrorMessage);
						}
					}
					else
					{
						for (SignalIndex = 0; SignalIndex < Circuit->NumberOfSignals; SignalIndex++)
							if (!strcmp(Circuit->Signals[SignalIndex]->Name, Str1))
							{
								Circuit->Signals[SignalIndex]->ProbeAllowed = Str2[0];
								break;
							}

						if (SignalIndex >= Circuit->NumberOfSignals)
						{
                            ErrorMessage = "Given signal name " + (std::string)Str1 + " for \"probes_include\" in settings file not found!";
                            fclose(SettingsFile);
                            free(Str1);
                            free(Str2);
                            free(Str3);
                            throw std::runtime_error(ErrorMessage);
						}
					}
                }
            }

            SettingsFileCheckList |= (1 << 10);
        }
        else if (!strcmp(Str1, "probes_exclude"))
        {
            Hardware::Read::NonCommentFromFile(SettingsFile, Str1, "%");

            if (!strcmp(Str1, "all"))
            {
				for (SignalIndex = 0; SignalIndex < Circuit->NumberOfSignals; SignalIndex++)
					Circuit->Signals[SignalIndex]->ProbeAllowed = 0;
            }
            else
            {
	            if (!strcmp(Str1, "none"))
	            	NumberOfItems = 0;
	            else
	            {
					templ = strtol(Str1, &tmptr, 10);
					if ((*tmptr) || (templ < 0))
					{
                        ErrorMessage = "Given number of \"probes_exclude\" (" + (std::string)Str1 + " >= 0) in settings file is not valid!";
                        fclose(SettingsFile);
                        free(Str1);
                        free(Str2);
                        free(Str3);
                        throw std::runtime_error(ErrorMessage);
					}

					NumberOfItems = templ;
				}

                for (i = 0; i < NumberOfItems; i++)
                {
                    Hardware::Read::NonCommentFromFile(SettingsFile, Str1, "%");

					if (Str1[strlen(Str1)-1] == '*')
					{
						Str1[strlen(Str1)-1] = 0;
						OneFound = 0;

						for (SignalIndex = 0; SignalIndex < Circuit->NumberOfSignals; SignalIndex++)
							if (strstr(Circuit->Signals[SignalIndex]->Name, Str1) == Circuit->Signals[SignalIndex]->Name)
							{
								Circuit->Signals[SignalIndex]->ProbeAllowed = 0;
								OneFound = 1;
							}

						if (!OneFound)
						{
                            ErrorMessage = "Given signal name " + (std::string)Str1 + " for probes_exclude in settings file does not match to any signal!";
                            fclose(SettingsFile);
                            free(Str1);
                            free(Str2);
                            free(Str3);
                            throw std::runtime_error(ErrorMessage);
						}
					}
					else
					{
						for (SignalIndex = 0; SignalIndex < Circuit->NumberOfSignals; SignalIndex++)
							if (!strcmp(Circuit->Signals[SignalIndex]->Name, Str1))
							{
								Circuit->Signals[SignalIndex]->ProbeAllowed = 0;
								break;
							}

						if (SignalIndex >= Circuit->NumberOfSignals)
						{
                            ErrorMessage = "Given signal name " + (std::string)Str1 + " for probes_exclude in settings file not found!";
                            fclose(SettingsFile);
                            free(Str1);
                            free(Str2);
                            free(Str3);
                            throw std::runtime_error(ErrorMessage);
						}
					}
                }
            }

            SettingsFileCheckList |= (1 << 11);
        }else if (!strcmp(Str1, "multivariate_test"))
		{
			Hardware::Read::NonCommentFromFile(SettingsFile, Str1, "%");
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
				throw std::runtime_error("Given value for \"multivariate_test\" is not valid, can be only no or yes or exclusive!");
			}

			SettingsFileCheckList |= (1 << 12);
		}
		else if (!strcmp(Str1, "transitional_leakage"))
		{
			Hardware::Read::NonCommentFromFile(SettingsFile, Str1, "%");
			if (!strcmp(Str1, "no"))
				Settings->TestTransitional = 0;
			else if (!strcmp(Str1, "yes"))
				Settings->TestTransitional = 1;
			else
			{
				fclose(SettingsFile);
				free(Str1);
				free(Str2);
				free(Str3);
				throw std::runtime_error("Given value for \"transitional_leakage\" is not valid, can be only no or yes!");
			}

			SettingsFileCheckList |= (1 << 13);
		}
		else if (!strcmp(Str1, "no_of_test_clock_cycles"))
		{
			Hardware::Read::NonCommentFromFile(SettingsFile, Str1, "%");
			templ = strtol(Str1, &tmptr, 10);
			if ((*tmptr) || (templ < 1))
			{
                ErrorMessage = "Given no_of_test_clock_cycles (" + (std::string)Str1 + " > 0) in settings file is not valid!";
                fclose(SettingsFile);
                free(Str1);
                free(Str2);
                free(Str3);
                throw std::runtime_error(ErrorMessage);
			}

			NumberOfEntries = templ;

			Settings->NumberOfTestClockCycles = 0;
			Settings->TestClockCycles = NULL;
			for (EntryIndex = 0;EntryIndex < NumberOfEntries;EntryIndex++)
			{
				Hardware::Read::NonCommentFromFile(SettingsFile, Str1, "%");
				str_ptr = strchr(Str1, '-');
				if (str_ptr == NULL)
				{
					Buffer_int = (int*)malloc((Settings->NumberOfTestClockCycles + 1) * sizeof(int));
					memcpy(Buffer_int, Settings->TestClockCycles, Settings->NumberOfTestClockCycles * sizeof(int));
					free(Settings->TestClockCycles);
					Settings->TestClockCycles = Buffer_int;
					templ = strtol(Str1, &tmptr, 10);
					if ((*tmptr) || (templ < 1))
					{
                        ErrorMessage = "Given value for one of the test clock cycles (" + (std::string)Str1 + " > 0) in settings file is not valid!";
                        fclose(SettingsFile);
                        free(Str1);
                        free(Str2);
                        free(Str3);
                        throw std::runtime_error(ErrorMessage);
					}

					Settings->TestClockCycles[Settings->NumberOfTestClockCycles] = templ;

					if (Settings->TestClockCycles[Settings->NumberOfTestClockCycles] > Settings->Max_No_ClockCycles)
					{
                        ErrorMessage = "Given value for one of the test clock cycles " + (std::string)Str1 + " in settings file is bigger than \"max_clock_cycle\"!";
                        fclose(SettingsFile);
                        free(Str1);
                        free(Str2);
                        free(Str3);
                        throw std::runtime_error(ErrorMessage);
					}

					Settings->NumberOfTestClockCycles++;
				}
				else
				{
					strncpy(Str3, Str1, Max_Name_Length - 1);
					Str3[Max_Name_Length - 1] = '\0';
					strncpy(Str2, str_ptr + 1, Max_Name_Length - 1);
					Str2[Max_Name_Length - 1] = '\0';
					*str_ptr = 0;

					templ = strtol(Str1, &tmptr, 10);
					if ((*tmptr) || (templ < 1))
					{
                        ErrorMessage = "Given value (" + (std::string)Str1 + " > 0) in " +  (std::string)Str3 + " for one of the test clock cycles in settings file is not valid!";
                        fclose(SettingsFile);
                        free(Str1);
                        free(Str2);
                        free(Str3);
                        throw std::runtime_error(ErrorMessage);
					}

					IndexL = templ;

					templ = strtol(Str2, &tmptr, 10);
					if ((*tmptr) ||
						(templ < 1))
					{
                        ErrorMessage = "Given value (" + (std::string)Str2 + " > 0) in " +  (std::string)Str3 + " for one of the test clock cycles in settings file is not valid!";
                        fclose(SettingsFile);
                        free(Str1);
                        free(Str2);
                        free(Str3);
                        throw std::runtime_error(ErrorMessage);
					}

					IndexH = templ;

					if (IndexL > IndexH)
					{
                        ErrorMessage = "Given value " + (std::string)Str3 + " for one of the test clock cycles in settings file is not valid!";
                        fclose(SettingsFile);
                        free(Str1);
                        free(Str2);
                        free(Str3);
                        throw std::runtime_error(ErrorMessage);
					}

					for (ClockCycle = IndexL;ClockCycle <= IndexH;ClockCycle++)
					{
						if (ClockCycle > Settings->Max_No_ClockCycles)
						{
                            ErrorMessage = "Given value " + std::to_string(ClockCycle) + " for one of the test clock cycles in settings file is bigger than \"max_clock_cycle\"!";
                            fclose(SettingsFile);
                            free(Str1);
                            free(Str2);
                            free(Str3);
                            throw std::runtime_error(ErrorMessage);
						}

						Buffer_int = (int*)malloc((Settings->NumberOfTestClockCycles + 1) * sizeof(int));
						memcpy(Buffer_int, Settings->TestClockCycles, Settings->NumberOfTestClockCycles * sizeof(int));
						free(Settings->TestClockCycles);
						Settings->TestClockCycles = Buffer_int;
						Settings->TestClockCycles[Settings->NumberOfTestClockCycles] = ClockCycle;
						Settings->NumberOfTestClockCycles++;
					}
				}
			}

			SettingsFileCheckList |= (1 << 14);
		}
		else if (!strcmp(Str1, "no_of_simulations"))
		{
			Hardware::Read::NonCommentFromFile(SettingsFile, Str1, "%");
			Settings->NumberOfSimulations = strtoll(Str1, &tmptr, 10);
			if ((*tmptr) ||
			    (Settings->NumberOfSimulations < 1) ||
				((Settings->NumberOfSimulations % 64) != 0))
			{
				fclose(SettingsFile);
				free(Str1);
				free(Str2);
				free(Str3);
                throw std::runtime_error("Given value for \"no_of_simulations\" is not valid, should be a factor of 64!");
			}

			SettingsFileCheckList |= (1 << 15);
		}
		else if (!strcmp(Str1, "no_of_step_simulations"))
		{
			Hardware::Read::NonCommentFromFile(SettingsFile, Str1, "%");
			Settings->NumberOfStepSimulations = strtoll(Str1, &tmptr, 10);
			if ((*tmptr) ||
			    (Settings->NumberOfStepSimulations < 1) ||
				((Settings->NumberOfStepSimulations % 64) != 0) ||
				((Settings->NumberOfSimulations % Settings->NumberOfStepSimulations) != 0))
			{
				fclose(SettingsFile);
				free(Str1);
				free(Str2);
				free(Str3);
                throw std::runtime_error("Given value for \"no_of_step_simulations\" is not valid, should be a factor of 64 and a divisor of \"no_of_simulations\"!");
			}

			SettingsFileCheckList |= (1 << 16);
		}
		else if (!strcmp(Str1, "no_of_step_write_results"))
		{
			Hardware::Read::NonCommentFromFile(SettingsFile, Str1, "%");
			Settings->NumberOfStepSimulationsToWrite = strtoll(Str1, &tmptr, 10);
			if ((*tmptr) ||
			    (Settings->NumberOfStepSimulationsToWrite < 1) ||
				((Settings->NumberOfStepSimulationsToWrite % 64) != 0) ||
				((Settings->NumberOfSimulations % Settings->NumberOfStepSimulationsToWrite) != 0) ||
				((Settings->NumberOfStepSimulationsToWrite % Settings->NumberOfStepSimulations) != 0))
			{
				fclose(SettingsFile);
				free(Str1);
				free(Str2);
				free(Str3);
                throw std::runtime_error("Given value for \"no_of_step_write_results\" is not valid, should be a factor of 64, a divisor of \"no_of_simulations\", and a factor of \"no_of_step_simulations\"!");
			}

			SettingsFileCheckList |= (1 << 17);
		}
		else if (!strcmp(Str1, "compact_distributions"))
		{
			Hardware::Read::NonCommentFromFile(SettingsFile, Str1, "%");
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

		SettingsFileCheckList |= (1 << 18);
		}
		else if (!strcmp(Str1, "minimize_probe_sets"))
		{
			Hardware::Read::NonCommentFromFile(SettingsFile, Str1, "%");
			if (!strcmp(Str1, "no"))
				Settings->MinimizeProbeSets = 0;
			else if (!strcmp(Str1, "yes"))
				Settings->MinimizeProbeSets = 1;
			else
			{
				fclose(SettingsFile);
				free(Str1);
				free(Str2);
				free(Str3);
                throw std::runtime_error("Given value for \"minimize_probe_sets\" is not valid, can be only no or yes!");
			}

			SettingsFileCheckList |= (1 << 19);
		}
		else if (!strcmp(Str1, "remove_full_probing_sets"))
		{
			Hardware::Read::NonCommentFromFile(SettingsFile, Str1, "%");
			if (!strcmp(Str1, "no"))
                Settings->RemoveProbingSets = 0;
			else if (!strcmp(Str1, "yes"))
                Settings->RemoveProbingSets = 1;
			else
			{
				fclose(SettingsFile);
				free(Str1);
				free(Str2);
				free(Str3);
				throw std::runtime_error("Given value for \"remove_full_probing_sets\" is not valid, can be only no or yes!");
			}

			SettingsFileCheckList |= (1 << 20);
		}
		else if (!strcmp(Str1, "waveform_simulation"))
		{
			Hardware::Read::NonCommentFromFile(SettingsFile, Str1, "%");
			if (!strcmp(Str1, "no"))
                Settings->WaveformSimulation = false;
			else if (!strcmp(Str1, "yes"))
                Settings->WaveformSimulation = true;
			else
			{
				fclose(SettingsFile);
				free(Str1);
				free(Str2);
				free(Str3);
				throw std::runtime_error("Given value for \"waveform_simulation\" is not valid, can be only no or yes!");
			}

			SettingsFileCheckList |= (1 << 21);
		}

		else if (!strcmp(Str1, "no_of_entries_in_report"))
		{
			Hardware::Read::NonCommentFromFile(SettingsFile, Str1, "%");
			templl = strtoll(Str1, &tmptr, 10);
			if ((*tmptr) || (templl < 0))
			{
				fclose(SettingsFile);
				free(Str1);
				free(Str2);
				free(Str3);
                throw std::runtime_error("Given value for \"no_of_entries_in_report\" is not valid, should be greater or equal zero!");
			}

			Settings->Max_No_ReportEntries = templl;
			SettingsFileCheckList |= (1 << 22);
		}
		else if (!strcmp(Str1, "max_distance_multivariate"))
		{
			Hardware::Read::NonCommentFromFile(SettingsFile, Str1, "%");
			Settings->MaxDistanceMultivariet = strtoll(Str1, &tmptr, 10);
			if ((*tmptr) || (Settings->MaxDistanceMultivariet < 0))
			{
				fclose(SettingsFile);
				free(Str1);
				free(Str2);
				free(Str3);
                throw std::runtime_error("Given value for \"max_distance_multivariate\" is not valid, should be greater or equal zero!");
			}

			SettingsFileCheckList |= (1 << 23);
		}
		else if (!strcmp(Str1, "no_of_probing_sets_per_step"))
		{
			Hardware::Read::NonCommentFromFile(SettingsFile, Str1, "%");
			templl = strtoll(Str1, &tmptr, 10);
			if ((*tmptr) || (templl <= 0))
			{
				fclose(SettingsFile);
				free(Str1);
				free(Str2);
				free(Str3);
                throw std::runtime_error("Given value for \"no_of_probing_sets_per_step\" is not valid, should be greater than zero!");
			}

            Settings->ProbeStepSize = templl;
			SettingsFileCheckList |= (1 << 24);
		}
		else if (!strcmp(Str1, "effect_size"))
		{
			Hardware::Read::NonCommentFromFile(SettingsFile, Str1, "%");
            double Effect = std::stod((std::string)Str1);

			if (Effect < 0.0)
			{
                ErrorMessage = "Given \"effect_size\" (" + (std::string)Str1 + " > 0) in settings file is not valid!";
				fclose(SettingsFile);
				free(Str1);
				free(Str2);
				free(Str3);
                throw std::runtime_error(ErrorMessage);
			}

            Settings->EffectSize = Effect;
			SettingsFileCheckList |= (1 << 25);
		}
		else if (!strcmp(Str1, "no_of_outputs"))
		{
			Hardware::Read::NonCommentFromFile(SettingsFile, Str1, "%");
			templl = strtoll(Str1, &tmptr, 10);
			if ((*tmptr) || (templl < 0))
			{
				ErrorMessage = "Given \"no_of_outputs\" (" + (std::string)Str1 + " >= 0) in settings file is not valid!";
				fclose(SettingsFile);
				free(Str1);
				free(Str2);
				free(Str3);
				throw std::runtime_error(ErrorMessage);
			}

			Settings->NumberOfOutputShares = templl;
			Settings->OutputSignals = (int**)malloc(Settings->NumberOfOutputShares * sizeof(int*));

			for (ShareIndex = 0; ShareIndex < Settings->NumberOfOutputShares; ShareIndex++)
			{
				Hardware::Read::NonCommentFromFile(SettingsFile, Str1, "%");

				if ((Str1[0] == '[') && (Str1[strlen(Str1) - 1] == ']'))
				{
					strncpy(Str2, Str1 + 1, Max_Name_Length - 1);
					Str2[Max_Name_Length - 1] = '\0';
					Str2[strlen(Str2) - 1] = 0;
					str_ptr = strchr(Str2, ':');
					if (str_ptr != NULL)
					{
						*str_ptr = 0;
						templ = strtol(Str2, &tmptr, 10);
						if ((*tmptr) || (templ < 0))
						{
							ErrorMessage = "Given statement (" + (std::string)Str2 + " >= 0) in settings file is not valid!";
							fclose(SettingsFile);
							free(Str1);
							free(Str2);
							free(Str3);
							throw std::runtime_error(ErrorMessage);
						}

						IndexH = templ;

						templ = strtol(str_ptr + 1, &tmptr, 10);
						if ((*tmptr) || (templ < 0))
						{
							ErrorMessage = "Given statement (" + (std::string)str_ptr + " >= 0) in settings file is not valid!";
							fclose(SettingsFile);
							free(Str1);
							free(Str2);
							free(Str3);
							throw std::runtime_error(ErrorMessage);
						}

						IndexL = templ;
					}
					else
					{
						templ = strtol(Str2, &tmptr, 10);
						if ((*tmptr) || (templ < 0))
						{
							ErrorMessage = "Given statement (" + (std::string)Str2 + " >= 0) in settings file is not valid!";
							fclose(SettingsFile);
							free(Str1);
							free(Str2);
							free(Str3);
							throw std::runtime_error(ErrorMessage);
						}

						IndexH = templ;
						IndexL = IndexH;
					}

					Hardware::Read::NonCommentFromFile(SettingsFile, Str1, "%");
				}
				else
				{
					IndexL = -1;
					IndexH = -1;
				}

				if (!ShareIndex)
					Settings->NumberOfOutputSignals = IndexH - IndexL + 1;
				else
					if (Settings->NumberOfOutputSignals != IndexH - IndexL + 1)	{
						ErrorMessage = "Number of output signals given in line no. " + std::to_string(ShareIndex + 1) + " of \"no_of_outputs\" in settings file does not match with other given output signals!";
						fclose(SettingsFile);
						free(Str1);
						free(Str2);
						free(Str3);
						throw std::runtime_error(ErrorMessage);
					}

				Settings->OutputSignals[ShareIndex] = (int*)malloc(Settings->NumberOfOutputSignals * sizeof(int));

				for (j = IndexL; j <= IndexH; j++)
				{
					if (IndexL != -1)
						sprintf(Str2, "%s[%d]", Str1, j);
					else
						sprintf(Str2, "%s", Str1);

					for (SignalIndex = 0; SignalIndex < Circuit->NumberOfSignals; SignalIndex++)
						if (!strcmp(Circuit->Signals[SignalIndex]->Name, Str2))
							break;

					if (SignalIndex >= Circuit->NumberOfSignals)
					{
						ErrorMessage = "Signal " + (std::string)Str2 + " in settings file as output signal not found!";
						fclose(SettingsFile);
						free(Str1);
						free(Str2);
						free(Str3);
						throw std::runtime_error(ErrorMessage);
					}

					Settings->OutputSignals[ShareIndex][j - IndexL] = SignalIndex;
				}
			}

			SettingsFileCheckList |= (1 << 26);
		}
		else if (!strcmp(Str1, "expected_output"))
		{
			if (!(SettingsFileCheckList & (1 << 26)))
			{
				ErrorMessage = "\"no_of_outputs\" should be defined before \"expected_output\" in settings file!";
				fclose(SettingsFile);
				free(Str1);
				free(Str2);
				free(Str3);
				throw std::runtime_error(ErrorMessage);
			}

			if (Settings->NumberOfOutputShares == 0)
			{
				ErrorMessage = "To define \"expected_output\", \"no_of_outputs\" should be > 0 in settings file!";
				fclose(SettingsFile);
				free(Str1);
				free(Str2);
				free(Str3);
				throw std::runtime_error(ErrorMessage);
			}

			Settings->ExpectedOutputValues = (int**)malloc(Settings->NumberOfGroups * sizeof(int*));

			for (GroupIndex = 0; GroupIndex < Settings->NumberOfGroups; GroupIndex++)
			{
				NumberOfBuffer_char = 0;
				Hardware::Read::NonCommentFromFile(SettingsFile, Str1, "%");

				strncpy(Str2, Str1, Max_Name_Length - 1);
				Str2[Max_Name_Length - 1] = '\0';
				str_ptr = strchr(Str2, '\'');
				*str_ptr = 0;

				templ = strtol(Str2, &tmptr, 10);
				if ((*tmptr) ||
					(templ < 1))
				{
					ErrorMessage = "Given length (" + (std::string)Str2 + " > 0) for " + (std::string)Str1 + " in settings file is not valid!";
					fclose(SettingsFile);
					free(Str1);
					free(Str2);
					free(Str3);
					throw std::runtime_error(ErrorMessage);
				}

				j = templ;
				if (j != Settings->NumberOfOutputSignals)
				{
					ErrorMessage = "Length " + (std::string)Str1 + " in settings file does not match to the size of given output signals!";
					fclose(SettingsFile);
					free(Str1);
					free(Str2);
					free(Str3);
					throw std::runtime_error(ErrorMessage);
				}

				Settings->ExpectedOutputValues[GroupIndex] = (int*)malloc(Settings->NumberOfOutputSignals * sizeof(int));

				strncpy(Str3, str_ptr + 1, Max_Name_Length - 1);
				Str3[Max_Name_Length - 1] = '\0';
				strncpy(Str2, Str3, Max_Name_Length - 1);
				Str2[Max_Name_Length - 1] = '\0';
				strncpy(Str3, Str1, Max_Name_Length - 1);
				Str3[Max_Name_Length - 1] = '\0';
				strncpy(Str1, Str2 + 1, Max_Name_Length - 1);
				Str1[Max_Name_Length - 1] = '\0';

				if (Str2[0] == 'h')
				{
					for (j = 0; j < Settings->NumberOfOutputSignals; j += 4)
					{
						if (!strlen(Str1))
						{
							ErrorMessage = "Length " + (std::string)Str3 + " in settings file does not match to the given size!";
							fclose(SettingsFile);
							free(Str1);
							free(Str2);
							free(Str3);
							throw std::runtime_error(ErrorMessage);
						}
						Str2[0] = Str1[strlen(Str1) - 1];
						Str2[1] = 0;
						Str1[strlen(Str1) - 1] = 0;

						v = strtol(Str2, NULL, 16);
						for (i = 0; i < 4; i++)
						{
							if (Str2[0] == '$')
								Settings->ExpectedOutputValues[GroupIndex][NumberOfBuffer_char] = -1;
							else
								Settings->ExpectedOutputValues[GroupIndex][NumberOfBuffer_char] = (v & (1 << i)) ? 1 : 0;
							NumberOfBuffer_char++;
						}
					}
				}
				else if (Str2[0] == 'b')
				{
					for (j = 0; j < Settings->NumberOfOutputSignals; j += 1)
					{
						if (!strlen(Str1))
						{
							ErrorMessage = "Length " + (std::string)Str3 + " in settings file does not match to the given size!";
							fclose(SettingsFile);
							free(Str1);
							free(Str2);
							free(Str3);
							throw std::runtime_error(ErrorMessage);
						}
						Str2[0] = Str1[strlen(Str1) - 1];
						Str2[1] = 0;
						Str1[strlen(Str1) - 1] = 0;

						v = strtol(Str2, NULL, 2);
						if (Str2[0] == '$')
							Settings->ExpectedOutputValues[GroupIndex][NumberOfBuffer_char] = -1;
						else
							Settings->ExpectedOutputValues[GroupIndex][NumberOfBuffer_char] = v;
						NumberOfBuffer_char++;
					}
				}
				else
				{
					ErrorMessage = "Base in settings file not known in " + (std::string)Str3 + "!";
					fclose(SettingsFile);
					free(Str1);
					free(Str2);
					free(Str3);
					throw std::runtime_error(ErrorMessage);
				}

				if (strlen(Str1))
				{
					ErrorMessage = "Length " + (std::string)Str3 + " in settings file does not match to the given size!";
					fclose(SettingsFile);
					free(Str1);
					free(Str2);
					free(Str3);
					throw std::runtime_error(ErrorMessage);
				}
			}

			SettingsFileCheckList |= (1 << 27);
		}
        else if (!strcmp(Str1, "fault_injection_include"))
        {
            Hardware::Read::NonCommentFromFile(SettingsFile, Str1, "%");

            if (!strcmp(Str1, "all"))
            {
                for (SignalIndex = 0; SignalIndex < Circuit->NumberOfSignals; SignalIndex++)
					Circuit->Signals[SignalIndex]->FaultAllowed = 1;
            }
            else
            {
	            if (!strcmp(Str1, "none"))
	            	NumberOfItems = 0;
	            else
	            {
					templ = strtol(Str1, &tmptr, 10);
					if ((*tmptr) || (templ < 0))
					{
                        ErrorMessage = "Given number of \"fault_injection_include\" (" + (std::string)Str1 + " >= 0) in settings file is not valid!";
                        fclose(SettingsFile);
                        free(Str1);
                        free(Str2);
                        free(Str3);
                        throw std::runtime_error(ErrorMessage);
					}

					NumberOfItems = templ;
				}

                for (i = 0; i < NumberOfItems; i++)
                {
                    Hardware::Read::NonCommentFromFile(SettingsFile, Str1, "%");
					Str2[0] = 1;

					if (Str1[strlen(Str1)-1] == '*')
					{
						Str1[strlen(Str1)-1] = 0;
						OneFound = 0;

						for (SignalIndex = 0; SignalIndex < Circuit->NumberOfSignals; SignalIndex++)
							if (strstr(Circuit->Signals[SignalIndex]->Name, Str1) == Circuit->Signals[SignalIndex]->Name)
							{
								Circuit->Signals[SignalIndex]->FaultAllowed = Str2[0];
								OneFound = 1;
							}

						if (!OneFound)
						{
                            ErrorMessage = "Given signal name " + (std::string)Str1 + " for \"fault_injection_include\" in settings file does not match to any signal!";
                            fclose(SettingsFile);
                            free(Str1);
                            free(Str2);
                            free(Str3);
                            throw std::runtime_error(ErrorMessage);
						}
					}
					else
					{
						for (SignalIndex = 0; SignalIndex < Circuit->NumberOfSignals; SignalIndex++)
							if (!strcmp(Circuit->Signals[SignalIndex]->Name, Str1))
							{
								Circuit->Signals[SignalIndex]->FaultAllowed = Str2[0];
								break;
							}

						if (SignalIndex >= Circuit->NumberOfSignals)
						{
                            ErrorMessage = "Given signal name " + (std::string)Str1 + " for \"fault_injection_include\" in settings file not found!";
                            fclose(SettingsFile);
                            free(Str1);
                            free(Str2);
                            free(Str3);
                            throw std::runtime_error(ErrorMessage);
						}
					}
                }
            }

            SettingsFileCheckList |= (1 << 28);
        }
        else if (!strcmp(Str1, "fault_injection_exclude"))
        {
            Hardware::Read::NonCommentFromFile(SettingsFile, Str1, "%");

            if (!strcmp(Str1, "all"))
            {
				for (SignalIndex = 0; SignalIndex < Circuit->NumberOfSignals; SignalIndex++)
					Circuit->Signals[SignalIndex]->FaultAllowed = 0;
            }
            else
            {
	            if (!strcmp(Str1, "none"))
	            	NumberOfItems = 0;
	            else
	            {
					templ = strtol(Str1, &tmptr, 10);
					if ((*tmptr) || (templ < 0))
					{
                        ErrorMessage = "Given number of \"fault_injection_exclude\" (" + (std::string)Str1 + " >= 0) in settings file is not valid!";
                        fclose(SettingsFile);
                        free(Str1);
                        free(Str2);
                        free(Str3);
                        throw std::runtime_error(ErrorMessage);
					}

					NumberOfItems = templ;
				}

                for (i = 0; i < NumberOfItems; i++)
                {
                    Hardware::Read::NonCommentFromFile(SettingsFile, Str1, "%");

					if (Str1[strlen(Str1)-1] == '*')
					{
						Str1[strlen(Str1)-1] = 0;
						OneFound = 0;

						for (SignalIndex = 0; SignalIndex < Circuit->NumberOfSignals; SignalIndex++)
							if (strstr(Circuit->Signals[SignalIndex]->Name, Str1) == Circuit->Signals[SignalIndex]->Name)
							{
								Circuit->Signals[SignalIndex]->FaultAllowed = 0;
								OneFound = 1;
							}

						if (!OneFound)
						{
                            ErrorMessage = "Given signal name " + (std::string)Str1 + " for fault_injection_exclude in settings file does not match to any signal!";
                            fclose(SettingsFile);
                            free(Str1);
                            free(Str2);
                            free(Str3);
                            throw std::runtime_error(ErrorMessage);
						}
					}
					else
					{
						for (SignalIndex = 0; SignalIndex < Circuit->NumberOfSignals; SignalIndex++)
							if (!strcmp(Circuit->Signals[SignalIndex]->Name, Str1))
							{
								Circuit->Signals[SignalIndex]->FaultAllowed = 0;
								break;
							}

						if (SignalIndex >= Circuit->NumberOfSignals)
						{
                            ErrorMessage = "Given signal name " + (std::string)Str1 + " for fault_injection_exclude in settings file not found!";
                            fclose(SettingsFile);
                            free(Str1);
                            free(Str2);
                            free(Str3);
                            throw std::runtime_error(ErrorMessage);
						}
					}
                }
            }

            SettingsFileCheckList |= (1 << 29);
		}
		else if (!strcmp(Str1, "number_of_faults"))
		{
			Hardware::Read::NonCommentFromFile(SettingsFile, Str1, "%");
			templ = strtol(Str1, &tmptr, 10);
			if ((*tmptr) || (templ < 1))
			{
                ErrorMessage = "Given \"number_of_faults\" (" + (std::string)Str1 + " > 0) in settings file is not valid!";
				fclose(SettingsFile);
				free(Str1);
				free(Str2);
				free(Str3);
                throw std::runtime_error(ErrorMessage);
			}
			Settings->number_of_faults = templ;
			SettingsFileCheckList |= (1 << 30);
		}
		else if (!strcmp(Str1, "number_of_faulted_clock_cycles"))
		{
			Hardware::Read::NonCommentFromFile(SettingsFile, Str1, "%");
			templ = strtol(Str1, &tmptr, 10);
			if ((*tmptr) || (templ < 1))
			{
                ErrorMessage = "Given number_of_faulted_clock_cycles (" + (std::string)Str1 + " > 0) in settings file is not valid!";
                fclose(SettingsFile);
                free(Str1);
                free(Str2);
                free(Str3);
                throw std::runtime_error(ErrorMessage);
			}

			NumberOfEntries = templ;

			Settings->number_of_faulted_clock_cycles = 0;
			Settings->faulted_clock_cycles = NULL;
			for (EntryIndex = 0;EntryIndex < NumberOfEntries;EntryIndex++)
			{
				Hardware::Read::NonCommentFromFile(SettingsFile, Str1, "%");
				str_ptr = strchr(Str1, '-');
				if (str_ptr == NULL)
				{
					Buffer_int = (int*)malloc((Settings->number_of_faulted_clock_cycles + 1) * sizeof(int));
					memcpy(Buffer_int, Settings->faulted_clock_cycles, Settings->number_of_faulted_clock_cycles * sizeof(int));
					free(Settings->faulted_clock_cycles);
					Settings->faulted_clock_cycles = Buffer_int;
					templ = strtol(Str1, &tmptr, 10);
					if ((*tmptr) || (templ < 1))
					{
                        ErrorMessage = "Given value for one of the faulted clock cycles (" + (std::string)Str1 + " > 0) in settings file is not valid!";
                        fclose(SettingsFile);
                        free(Str1);
                        free(Str2);
                        free(Str3);
                        throw std::runtime_error(ErrorMessage);
					}

					Settings->faulted_clock_cycles[Settings->number_of_faulted_clock_cycles] = templ;

					if (Settings->faulted_clock_cycles[Settings->number_of_faulted_clock_cycles] > Settings->Max_No_ClockCycles)
					{
                        ErrorMessage = "Given value for one of the faulted clock cycles " + (std::string)Str1 + " in settings file is bigger than \"max_clock_cycle\"!";
                        fclose(SettingsFile);
                        free(Str1);
                        free(Str2);
                        free(Str3);
                        throw std::runtime_error(ErrorMessage);
					}

					Settings->number_of_faulted_clock_cycles++;
				}
				else
				{
					strncpy(Str3, Str1, Max_Name_Length - 1);
					Str3[Max_Name_Length - 1] = '\0';
					strncpy(Str2, str_ptr + 1, Max_Name_Length - 1);
					Str2[Max_Name_Length - 1] = '\0';
					*str_ptr = 0;

					templ = strtol(Str1, &tmptr, 10);
					if ((*tmptr) || (templ < 1))
					{
                        ErrorMessage = "Given value (" + (std::string)Str1 + " > 0) in " +  (std::string)Str3 + " for one of the faulted clock cycles in settings file is not valid!";
                        fclose(SettingsFile);
                        free(Str1);
                        free(Str2);
                        free(Str3);
                        throw std::runtime_error(ErrorMessage);
					}

					IndexL = templ;

					templ = strtol(Str2, &tmptr, 10);
					if ((*tmptr) ||
						(templ < 1))
					{
                        ErrorMessage = "Given value (" + (std::string)Str2 + " > 0) in " +  (std::string)Str3 + " for one of the test clock cycles in settings file is not valid!";
                        fclose(SettingsFile);
                        free(Str1);
                        free(Str2);
                        free(Str3);
                        throw std::runtime_error(ErrorMessage);
					}

					IndexH = templ;

					if (IndexL > IndexH)
					{
                        ErrorMessage = "Given value " + (std::string)Str3 + " for one of the test clock cycles in settings file is not valid!";
                        fclose(SettingsFile);
                        free(Str1);
                        free(Str2);
                        free(Str3);
                        throw std::runtime_error(ErrorMessage);
					}

					for (ClockCycle = IndexL;ClockCycle <= IndexH;ClockCycle++)
					{
						if (ClockCycle > Settings->Max_No_ClockCycles)
						{
                            ErrorMessage = "Given value " + std::to_string(ClockCycle) + " for one of the test clock cycles in settings file is bigger than \"max_clock_cycle\"!";
                            fclose(SettingsFile);
                            free(Str1);
                            free(Str2);
                            free(Str3);
                            throw std::runtime_error(ErrorMessage);
						}

						Buffer_int = (int*)malloc((Settings->number_of_faulted_clock_cycles + 1) * sizeof(int));
						memcpy(Buffer_int, Settings->faulted_clock_cycles, Settings->number_of_faulted_clock_cycles * sizeof(int));
						free(Settings->faulted_clock_cycles);
						Settings->faulted_clock_cycles = Buffer_int;
						Settings->faulted_clock_cycles[Settings->number_of_faulted_clock_cycles] = ClockCycle;
						Settings->number_of_faulted_clock_cycles++;
					}
				}
			}

			SettingsFileCheckList |= (1 << 31);
		}


		else if (!strcmp(Str1, "fault_injection_type"))
		{
			Hardware::Read::NonCommentFromFile(SettingsFile, Str1, "%");

			if (!strcmp(Str1, "stuck_at_0")){
               for (SignalIndex = 0; SignalIndex < Circuit->NumberOfSignals; SignalIndex++){
					Circuit->Signals[SignalIndex]->fault_type = Hardware::faulting::FaultType::StuckAt0;
			   }
			}else if (!strcmp(Str1, "stuck_at_1"))
               for (SignalIndex = 0; SignalIndex < Circuit->NumberOfSignals; SignalIndex++){
					Circuit->Signals[SignalIndex]->fault_type = Hardware::faulting::FaultType::StuckAt1;
			   }
			else if (!strcmp(Str1, "toggle"))
               for (SignalIndex = 0; SignalIndex < Circuit->NumberOfSignals; SignalIndex++){
					Circuit->Signals[SignalIndex]->fault_type = Hardware::faulting::FaultType::Toggle;
			   }
			else
			{
				fclose(SettingsFile);
				free(Str1);
				free(Str2);
			    throw std::runtime_error("Unknown fault injection type!");
			}

			SettingsFileCheckList |= ((uint64_t)1 << 32);
		}
		else if ((strlen(Str1) > 0) && (Str1[0] != '%'))
		{
            ErrorMessage = "Given statement \"" + (std::string)Str1 + "\" in settings file is not known!";
			fclose(SettingsFile);
			free(Str1);
			free(Str2);
			free(Str3);
            throw std::runtime_error(ErrorMessage);
		}
    } while (!feof(SettingsFile));

    fclose(SettingsFile);
    free(Str1);
    free(Str2);
	free(Str3);

	//---------------------------------------------------------------------
	// check optional inputs

	if (!(SettingsFileCheckList & (1 << 2))) {
		Settings->TestOrder = 1;
		Warnings.push_back("Warning \"order_of_test\" is not specified. Default \"order_of_test\" = 1 is taken!");
	}

	if (!(SettingsFileCheckList & (1 << 5))) {
		Settings->AlwaysRandomInputs = NULL;
		Settings->NumberOfAlwaysRandomInputs = 0;
		Warnings.push_back("Warning \"no_of_always_random_inputs\" is not specified. Default \"no_of_always_random_inputs\" = 0 is taken!");
	}

	if (!(SettingsFileCheckList & (1 << 8))) {
		Settings->EndSimCondition_ClockCycles = Settings->Max_No_ClockCycles;
		Settings->EndSimCondition_NumberOfSignals = 0;
		ErrorMessage = "Warning  \"end_condition\" is not specified. Default \"end_condition\" = ClockCycles " + std::to_string(Settings->Max_No_ClockCycles) + " is taken!";
		Warnings.push_back(ErrorMessage);
	}

	if (!(SettingsFileCheckList & (1 << 9))) {
		Settings->EndSim_NumberOfWaitCycles = 0;
		Warnings.push_back("Warning \"end_wait_cycles\" is not specified. Default \"end_wait_cycles\" = 0 is taken!");
	}

	if (!(SettingsFileCheckList & (1 << 10))) {
        for (SignalIndex = 0; SignalIndex < Circuit->NumberOfSignals; SignalIndex++)
			Circuit->Signals[SignalIndex]->ProbeAllowed = 1;

		Warnings.push_back("Warning \"probes_include\" is not specified. Default \"probes_include\" = all is taken!");
	}

	if (!(SettingsFileCheckList & (1 << 11))) {
		Warnings.push_back("Warning \"probes_exclude\" is not specified. Default \"probes_exclude\" = none is taken!");
	}

 	if (!(SettingsFileCheckList & (1 << 12))){
        Settings->TestMultivariate = 0;
        Warnings.push_back("Warning \"multivariate_test\" is not specified. Default \"multivariate_test\" = no is taken!");
	}

 	if (!(SettingsFileCheckList & (1 << 13))){
        Settings->TestTransitional = 0;
        Warnings.push_back("Warning \"transitional_leakage\" is not specified. Default \"transitional_leakage\" = no is taken!");
	}


	if (!(SettingsFileCheckList & (1 << 14))) {
		Settings->NumberOfTestClockCycles = Settings->Max_No_ClockCycles;
		Settings->TestClockCycles = (int*)malloc(Settings->NumberOfTestClockCycles * sizeof(int));

		for(ClockCycle = 0; ClockCycle < Settings->NumberOfTestClockCycles; ClockCycle++)
			Settings->TestClockCycles[ClockCycle] = ClockCycle + 1;

		ErrorMessage = "Warning \"no_of_test_clock_cycles\" is not specified. Default \"no_of_test_clock_cycles\" = 1-" + std::to_string(Settings->NumberOfTestClockCycles) + " is taken!";
        Warnings.push_back(ErrorMessage);
	}

	if (!(SettingsFileCheckList & (1 << 15))) {
		Settings->NumberOfSimulations = 100000000;
		Warnings.push_back("Warning \"no_of_simulations\" is not specified. Default \"no_of_simulations\" = 100000000 is taken!");
	}

	if (!(SettingsFileCheckList & (1 << 16))) {
		Settings->NumberOfStepSimulations = 1000000;
		Warnings.push_back("Warning \"no_of_step_simulations\" is not specified. Default \"no_of_step_simulations\" = 1000000 is taken!");
	}

	if (!(SettingsFileCheckList & (1 << 17))) {
		Settings->NumberOfStepSimulationsToWrite = 1000000;
		Warnings.push_back("Warning \"no_of_step_write_results\" is not specified. Default \"no_of_step_write_results\" = 1000000 is taken!");
	}

	if (!(SettingsFileCheckList & (1 << 18))){
		Settings->CompactDistributions = 0;
        Warnings.push_back("Warning \"compact_distributions\" is not specified. Default \"compact_distributions\" = no is taken!");
	}

	if (!(SettingsFileCheckList & (1 << 19))){
		Settings->MinimizeProbeSets = 0;
        Warnings.push_back("Warning \"minimize_probe_sets\" is not specified. Default \"minimize_probe_sets\" = no is taken!");
    }

	if (!(SettingsFileCheckList & (1 << 20))){
        Settings->RemoveProbingSets = 0;
        Warnings.push_back("Warning \"remove_full_probing_sets\" is not specified. Default \"remove_full_probing_sets\" = no is taken!");
	}

	if (!(SettingsFileCheckList & (1 << 21))) {
		Settings->WaveformSimulation = false;
		Warnings.push_back("Warning \"waveform_simulation\" is not specified. Default \"waveform_simulation\" = false is taken!");
	}

	if (!(SettingsFileCheckList & (1 << 22))){
		Settings->Max_No_ReportEntries = 10;
        Warnings.push_back("Warning \"no_of_entries_in_report\" is not specified. Default \"no_of_entries_in_report\" = 10 is taken!");
	}

	if (!(SettingsFileCheckList & (1 << 23))){
		Settings->MaxDistanceMultivariet = 10;
        Warnings.push_back("Warning \"max_distance_multivariate\" is not specified. Default \"max_distance_multivariate\" = 10 is taken!");
	}

    if (!(SettingsFileCheckList & (1 << 24))){
        Settings->ProbeStepSize = UINT_MAX;
        Warnings.push_back("Warning \"no_of_probing_sets_per_step\" is not specified. Default \"no_of_probing_sets_per_step\" = all is taken!");
    }

	if (!(SettingsFileCheckList & (1 << 25))) {
		Settings->EffectSize = 0.1;
		Warnings.push_back("Warning \"effect_size\" is not specified. Default \"effect_size\" = 0.1 is taken!");
	}

	if (!(SettingsFileCheckList & (1 << 26))) {
		Settings->NumberOfOutputShares = 0;
		Settings->NumberOfOutputSignals = 0;
		Warnings.push_back("Warning \"no_of_outputs\" is not specified. Default \"no_of_outputs\" = 0 is taken!");
	}

	//---------------------------------------------------------------------
	// check the essential inputs

	if (!(SettingsFileCheckList & (1 << 1))) {
		throw std::runtime_error("\"no_of_groups\" is not given!");
	}

	if (!(SettingsFileCheckList & (1 << 3))) {
		throw std::runtime_error("\"clock_signal_name\" is not given!");
	}

	if (!(SettingsFileCheckList & (1 << 4))) {
		throw std::runtime_error("\"max_clock_cycle\" is not given!");
	}

	if (!(SettingsFileCheckList & (1 << 6))) {
		throw std::runtime_error("\"no_of_initial_inputs\" is not given!");
	}

	if (!(SettingsFileCheckList & (1 << 7))) {
		throw std::runtime_error("\"no_of_initial_clock_cycles\" is not given!");
	}

	if ((!(SettingsFileCheckList & (1 << 10)) && (SettingsFileCheckList & (1 << 11)))) {
		throw std::runtime_error("\"probes_include\" is not given while \"probes_exclude\" is given!");
	}

	if (((SettingsFileCheckList & (1 << 10)) && !(SettingsFileCheckList & (1 << 11)))) {
		throw std::runtime_error("\"probes_exclude\" is not given while \"probes_include\" is given!");
	}

	if ((!(SettingsFileCheckList & (1 << 15)) || !(SettingsFileCheckList & (1 << 16)) || !(SettingsFileCheckList & (1 << 17))) && !(!(SettingsFileCheckList & (1 << 15)) && !(SettingsFileCheckList & (1 << 16)) && !(SettingsFileCheckList & (1 << 17)))) {
		throw std::runtime_error("Incomplete set of {\"no_of_simulations\", \"no_of_step_simulations\", \"no_of_step_write_results\"} is given!");
	}

	if ((SettingsFileCheckList & (1 << 26)) && (!(SettingsFileCheckList & (1 << 27))) && (Settings->NumberOfOutputShares > 0)) {
		throw std::runtime_error("\"expected_output\" is not given!");
	}

	if ((Settings->NumberOfAlwaysRandomInputs + Settings->InitialSim_NumberOfInputs + 1) != Circuit->NumberOfInputs) {
		throw std::runtime_error("Number of always random inputs + initial sim number of inputs in settings file does not match with the circuit's number of inputs!");
	}

	std::cout << "done with " << Warnings.size() << " warnings!" << std::endl;

    for (size_t WarningIndex = 0; WarningIndex < Warnings.size(); WarningIndex++){
        std::cout << "    " << Warnings.at(WarningIndex) << std::endl;
    }
}
