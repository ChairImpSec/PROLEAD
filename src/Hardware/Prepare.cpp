#include "Hardware/Prepare.hpp"

void Hardware::Prepare::MakeCircuitDepth(Library& library, Hardware::CircuitStruct* Circuit)
{
    int   i;
    int   OutputIndex;
    int   SignalIndex;
    int   GateIndex;
    int   RegIndex;
    int   CellIndex;
    short DepthIndex;
    char  all_have_depth;
    std::string ErrorMessage;
    int PortIndex;

    for (DepthIndex = 1; DepthIndex <= Circuit->MaxDepth; DepthIndex++)
        free(Circuit->CellsInDepth[DepthIndex]);
    free(Circuit->CellsInDepth);
    free(Circuit->NumberOfCellsInDepth);

    for (GateIndex = 0; GateIndex < Circuit->NumberOfGates; GateIndex++)
    {
        CellIndex = Circuit->Gates[GateIndex];

        if (!Circuit->Cells[CellIndex]->Deleted)
            Circuit->Cells[CellIndex]->Depth = -1;
    }

    for (RegIndex = 0; RegIndex < Circuit->NumberOfRegs; RegIndex++)
    {
        CellIndex = Circuit->Regs[RegIndex];

        if (!Circuit->Cells[CellIndex]->Deleted)
            Circuit->Cells[CellIndex]->Depth = 0;
    }

    for (SignalIndex = 0; SignalIndex < Circuit->NumberOfSignals; SignalIndex++)
        if (!Circuit->Signals[SignalIndex]->Deleted)
        {
            if (Circuit->Signals[SignalIndex]->Output >= 0)
                Circuit->Signals[SignalIndex]->Depth = Circuit->Cells[Circuit->Signals[SignalIndex]->Output]->Depth;
            else
            {
                Circuit->Signals[SignalIndex]->Depth = 0;
            }
        }

    Circuit->MaxDepth = 0;

    do
    {
        all_have_depth = 1;

        for (CellIndex = 0; CellIndex < Circuit->NumberOfCells; CellIndex++)
            if (!Circuit->Cells[CellIndex]->Deleted)
                if (!Circuit->Cells[CellIndex]->type->IsRegister())
                    if (Circuit->Cells[CellIndex]->Depth == -1)
                    {
                        all_have_depth = 0;
                        DepthIndex = 0;
                        for (i = 0; i < (int)Circuit->Cells[CellIndex]->type->GetNumberOfInputs(); i++)
                            if (Circuit->Signals[Circuit->Cells[CellIndex]->Inputs[i]]->Depth == -1)
                                break;
                            else if (DepthIndex < Circuit->Signals[Circuit->Cells[CellIndex]->Inputs[i]]->Depth)
                                DepthIndex = Circuit->Signals[Circuit->Cells[CellIndex]->Inputs[i]]->Depth;

                        if (i == (int)Circuit->Cells[CellIndex]->type->GetNumberOfInputs()) // all have depth
                        {
                            Circuit->Cells[CellIndex]->Depth = DepthIndex + 1;

                            for (OutputIndex = 0; OutputIndex < (int)Circuit->Cells[CellIndex]->type->GetNumberOfOutputs(); OutputIndex++)
                                if (Circuit->Cells[CellIndex]->Outputs[OutputIndex] != -1)
                                    Circuit->Signals[Circuit->Cells[CellIndex]->Outputs[OutputIndex]]->Depth = Circuit->Cells[CellIndex]->Depth;

                            if (Circuit->MaxDepth < Circuit->Cells[CellIndex]->Depth)
                                Circuit->MaxDepth = Circuit->Cells[CellIndex]->Depth;
                        }
                    }
    } while (!all_have_depth);

    Circuit->CellsInDepth = (int **)malloc((Circuit->MaxDepth + 1) * sizeof(int *));
    Circuit->NumberOfCellsInDepth = (int *)calloc(Circuit->MaxDepth + 1, sizeof(int));

    for (GateIndex = 0; GateIndex < Circuit->NumberOfGates; GateIndex++)
        if (!Circuit->Cells[Circuit->Gates[GateIndex]]->Deleted)
            Circuit->NumberOfCellsInDepth[Circuit->Cells[Circuit->Gates[GateIndex]]->Depth]++;

    for (DepthIndex = 0; DepthIndex <= Circuit->MaxDepth; DepthIndex++)
    {
        Circuit->CellsInDepth[DepthIndex] = (int *)malloc(Circuit->NumberOfCellsInDepth[DepthIndex] * sizeof(int));
        Circuit->NumberOfCellsInDepth[DepthIndex] = 0; // temporary to be used as index in the next loop
    }

    for (GateIndex = 0; GateIndex < Circuit->NumberOfGates; GateIndex++)
        if (!Circuit->Cells[Circuit->Gates[GateIndex]]->Deleted)
        {
            DepthIndex = Circuit->Cells[Circuit->Gates[GateIndex]]->Depth;
            Circuit->CellsInDepth[DepthIndex][Circuit->NumberOfCellsInDepth[DepthIndex]] = Circuit->Gates[GateIndex];
            Circuit->NumberOfCellsInDepth[DepthIndex]++;
        }

    for (SignalIndex = 0; SignalIndex < Circuit->NumberOfSignals; SignalIndex++)
        if (!Circuit->Signals[SignalIndex]->Deleted)
            if ((Circuit->Signals[SignalIndex]->Output != -1) && (Circuit->Signals[SignalIndex]->Depth == -1))
                break;

    if (SignalIndex < Circuit->NumberOfSignals)
    {
        printf("the depth of signal \"%s\" could not be identified\n", Circuit->Signals[SignalIndex]->Name);
        ErrorMessage = Circuit->Signals[SignalIndex]->Name;
        ErrorMessage = "The depth of signal \"" + ErrorMessage + "\" could not be identified!";
        throw std::runtime_error(ErrorMessage);
    }

    //-----------

    for (CellIndex = 0; CellIndex < Circuit->NumberOfCells; CellIndex++)
        Circuit->Cells[CellIndex]->Flag = 0;

    for (RegIndex = 0; RegIndex < Circuit->NumberOfRegs; RegIndex++)
    {
        CellIndex = Circuit->Regs[RegIndex];

        if (!Circuit->Cells[CellIndex]->Deleted)
        {
			PortIndex = Circuit->Cells[CellIndex]->type->GetClock();
			if (PortIndex != -1)
			{
				SignalIndex = Circuit->Cells[CellIndex]->Inputs[PortIndex];
				SetCellFlag(library, Circuit, SignalIndex);
			}
		}
    }

    Circuit->ClockCellsInDepth = (int**)malloc((Circuit->MaxDepth + 1) * sizeof(int*));
    Circuit->NumberOfClockCellsInDepth = (int*)calloc(Circuit->MaxDepth + 1, sizeof(int));

	for (DepthIndex = 1; DepthIndex <= Circuit->MaxDepth; DepthIndex++)
	{
        Circuit->ClockCellsInDepth[DepthIndex] = (int*)malloc(Circuit->NumberOfCellsInDepth[DepthIndex] * sizeof(int));
        Circuit->NumberOfClockCellsInDepth[DepthIndex] = 0;

		for (i = 0; i < Circuit->NumberOfCellsInDepth[DepthIndex]; i++)
		{
			CellIndex = Circuit->CellsInDepth[DepthIndex][i];
			if (Circuit->Cells[CellIndex]->Flag)
			{
				Circuit->ClockCellsInDepth[DepthIndex][Circuit->NumberOfClockCellsInDepth[DepthIndex]] = CellIndex;
				Circuit->NumberOfClockCellsInDepth[DepthIndex]++;
			}
		}
	}

}

void Hardware::Prepare::SetCellFlag(Library& library, Hardware::CircuitStruct* Circuit, int SignalIndex)
{
    int   CellIndex;
    int   InputIndex;

    if (SignalIndex != -1)
    {
		CellIndex = Circuit->Signals[SignalIndex]->Output;
		if (CellIndex != -1)
		{
			if ((!Circuit->Cells[CellIndex]->Deleted) &&
			    (!Circuit->Cells[CellIndex]->type->IsRegister()) &&
			    (!Circuit->Cells[CellIndex]->Flag))
			{
				Circuit->Cells[CellIndex]->Flag = 1;

				for (InputIndex = 0; InputIndex < (int)Circuit->Cells[CellIndex]->type->GetNumberOfInputs(); InputIndex++)
				{
					SignalIndex = Circuit->Cells[CellIndex]->Inputs[InputIndex];
					SetCellFlag(library, Circuit, SignalIndex);
				}
			}
		}
	}
}


