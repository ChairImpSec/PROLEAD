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
                if (!library.IsCellRegister(Circuit->Cells[CellIndex]->Type))
                    if (Circuit->Cells[CellIndex]->Depth == -1)
                    {
                        all_have_depth = 0;
                        DepthIndex = 0;
                        for (i = 0; i < Circuit->Cells[CellIndex]->NumberOfInputs; i++)
                            if (Circuit->Signals[Circuit->Cells[CellIndex]->Inputs[i]]->Depth == -1)
                                break;
                            else if (DepthIndex < Circuit->Signals[Circuit->Cells[CellIndex]->Inputs[i]]->Depth)
                                DepthIndex = Circuit->Signals[Circuit->Cells[CellIndex]->Inputs[i]]->Depth;

                        if (i == Circuit->Cells[CellIndex]->NumberOfInputs) // all have depth
                        {
                            Circuit->Cells[CellIndex]->Depth = DepthIndex + 1;

                            for (OutputIndex = 0; OutputIndex < Circuit->Cells[CellIndex]->NumberOfOutputs; OutputIndex++)
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
}


