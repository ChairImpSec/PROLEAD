#include "Hardware/Definitions.hpp"

bool Hardware::CircuitStruct::IsProbeOnSignalAllowed(int base_signal_index,
                                                     int current_signal_index,
                                                     int clock_signal_index) {
  return !Signals[current_signal_index]->Deleted &&
         (current_signal_index != clock_signal_index) &&
         ((Signals[current_signal_index]->ProbeAllowed) ||
          (Signals[base_signal_index]->ProbeAllowed == 2));
}

bool Hardware::CircuitStruct::IsFaultOnSignalAllowed(int signal_index,
                                                     int clock_signal_index) {
  return !Signals[signal_index]->Deleted &&
         (signal_index != clock_signal_index) &&
         ((Signals[signal_index]->FaultAllowed) ||
          (Signals[signal_index]->FaultAllowed == 2));
}

bool Hardware::CircuitStruct::CanProbeOnSignalBePropagated(
    int signal_index, const LibraryStruct& library) {
  return (Signals[signal_index]->Output != -1) &&
         (library.CellTypes[Cells[Signals[signal_index]->Output]->Type]
              ->GateOrReg != CellType_Reg);
}

bool Hardware::CircuitStruct::IsGateThatOutputsSignalDeleted(int signal_index) {
  return Cells[Signals[signal_index]->Output]->Deleted == 1;
}

int Hardware::CircuitStruct::GetNumberOfInputsForSignalsComputingCell(
    int signal_index) {
  return Cells[Signals[signal_index]->Output]->NumberOfInputs;
}
