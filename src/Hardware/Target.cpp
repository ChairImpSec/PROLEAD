#include "Hardware/Target.hpp"

Target::Target(const std::vector<const SignalStruct*>& signals, uint64_t cycle)
  : signals_(signals), cycle_(cycle) {}

uint64_t Target::GetCycle() const { return cycle_; }

const std::vector<const SignalStruct*>& Target::GetSignals() const {
  assert(std::is_sorted(signals_.begin(), signals_.end()) &&
    "Error in Target::GetSignalIndices(): Signals not sorted!");
  return signals_;
}

bool Target::operator<(const Target& other) const {
  if (cycle_ == other.cycle_) {
    if (signals_[0]->Depth == other.signals_[0]->Depth) {
      assert(std::is_sorted(signals_.begin(), signals_.end()) &&
            "Error in Target::operator<(): First operand not sorted!");
      assert(std::is_sorted(other.signals_.begin(), other.signals_.end()) &&
            "Error in Target::operator<(): Second operand not sorted!");
      return signals_[0]->id < other.signals_[0]->id;
    } else {
      return signals_[0]->Depth < other.signals_[0]->Depth;
    }
  } else {
    return cycle_ < other.cycle_;
  }
}

bool Target::operator==(const Target& other) const {
  assert(std::is_sorted(signals_.begin(), signals_.end()) &&
         "Error in Target::operator==(): First operand not sorted!");
  assert(std::is_sorted(other.signals_.begin(), other.signals_.end()) &&
         "Error in Target::operator==(): Second operand not sorted!");
  return (signals_[0]->id == other.signals_[0]->id) && (cycle_ == other.cycle_);
}

bool Target::operator!=(const Target& other) const {
  assert(std::is_sorted(signals_.begin(), signals_.end()) &&
         "Error in Target::operator!=(): First operand not sorted!");
  assert(std::is_sorted(other.signals_.begin(), other.signals_.end()) &&
         "Error in Target::operator!=(): Second operand not sorted!");
  return (signals_[0]->id != other.signals_[0]->id) || (cycle_ != other.cycle_);
}

std::string Target::Print(clk_edge_t edge, bool with_cycle) const {
  std::string name, cycle, result;

  for (const SignalStruct* signal : signals_) {
    assert(signal->Name != NULL && "Error in Target::Print(): Signal name is NULL!");
    name = signal->Name;

    if (with_cycle) {
      if (edge == clk_edge_t::both) {
        cycle = std::to_string((cycle_ + 1) / 2);
        if (cycle_ % 2) {
          return name + "(" + cycle + ".0)";
        } else {
          return name + "(" + cycle + ".5)";
        }
      } else {
        cycle = std::to_string(cycle_ + 1);
      }

      result += ", " + name + "(" + cycle + ")";
    } else {
      result += ", " + name;
    }
  }

  /* Removes the initial comma*/
  result.erase(0, 2);
  return result;
}

Probe::Probe(const std::vector<const SignalStruct*>& signals, uint64_t cycle) : Target(signals, cycle) {}

bool Probe::DoesExtend(const CircuitStruct& circuit) const {
  const std::vector<const SignalStruct*>& signals = this->GetSignals();
  assert(!signals.empty() && "Error in Probe::DoesExtend(): No signals in probe!");
  for (const SignalStruct* signal : signals) {
    const CellStruct& cell = circuit.cells_[signal->Output];
    if (!signal->is_extension_allowed || (signal->Output == -1) || (cell.type->GetType() == cell_t::sequential)) {
      return false;
    }
  }

  return true;
}

const std::vector<const Probe*>& Probe::GetGlitchExtensions() const {
  assert(std::is_sorted(glitch_extensions_.begin(), glitch_extensions_.end()) &&
         "Error in Probe::GetGlitchExtensions(): Extensions not sorted!");
  return glitch_extensions_;
}

const std::vector<const Probe*>& Probe::GetTransitionExtensions() const {
  assert(std::is_sorted(glitch_extensions_.begin(), glitch_extensions_.end()) &&
         "Error in Probe::GetTransitionExtensions(): Extensions not sorted!");
  return transition_extensions_;
}

const std::vector<const Probe*>& Probe::GetCouplingExtensions() const {
  assert(std::is_sorted(coupling_extensions_.begin(), coupling_extensions_.end()) &&
         "Error in Probe::GetCouplingExtensions(): Extensions not sorted!");
  return coupling_extensions_;
}

void Probe::Extend(const CircuitStruct& circuit, const std::vector<Probe>& probes, const Settings& settings) {
  const std::vector<const SignalStruct*>& signals = GetSignals();
  assert(!signals.empty() && "Error in Probe::Extend(): No probes!");
  assert(std::is_sorted(probes.begin(), probes.end()) && "Error in Probe::Extend(): Probes not sorted!");

  for (const SignalStruct* signal : signals) {
    const CellStruct& cell = circuit.cells_[signal->Output];
    if (signal->is_extension_allowed && (signal->Output != -1) && (cell.type->GetType() != cell_t::sequential)) {
      for (uint64_t in_idx : cell.GetInputs()) {
        const SignalStruct& input = circuit.signals_[in_idx];
        Probe probe({&input}, GetCycle());
        auto it = std::find(probes.begin(), probes.end(), probe);
        if (it != probes.end()) {
          glitch_extensions_.push_back(&(*it));
        }  
      }
    }
    
    transition_extensions_.push_back(this);

    if ((settings.IsRelaxedModel() || settings.IsTransitionalLeakage()) && GetCycle()) {
      Probe probe(GetSignals(), GetCycle() - 1);
      auto it = std::find(probes.begin(), probes.end(), probe);
      if (it == probes.end()) {
        throw std::out_of_range("Error in Probe::Extend(): Probe \"" + 
          probe.Print(settings.GetClkEdge(), true)  + "\" not found!");
      } else {
        transition_extensions_.push_back(&(*it));
      }
    }
  }

  std::sort(glitch_extensions_.begin(), glitch_extensions_.end(),
    [](const Probe* lhs, const Probe* rhs) { return *lhs < *rhs; });
  glitch_extensions_.erase(std::unique(glitch_extensions_.begin(), glitch_extensions_.end(), 
    [](const Probe* lhs, const Probe* rhs) { return *lhs == *rhs; }), glitch_extensions_.end());
  std::sort(transition_extensions_.begin(), transition_extensions_.end(),
    [](const Probe* lhs, const Probe* rhs) { return *lhs < *rhs; });
  transition_extensions_.erase(std::unique(transition_extensions_.begin(), transition_extensions_.end(), 
    [](const Probe* lhs, const Probe* rhs) { return *lhs == *rhs; }), transition_extensions_.end());
}

bool Probe::IsPlaced(const CircuitStruct& circuit) const {
  for (const SignalStruct* signal : this->GetSignals()) {
    if (!signal->is_probe_allowed) {
      return false;
    }
  }

  for (const SignalStruct* signal : this->GetSignals()) {
    if (signal->Output == -1) {
      return true;
    } else {
      const CellStruct& cell = circuit.cells_[signal->Output];
      if (cell.type->GetType() != cell_t::buffer) {
        return true;
      }
    }
  }

  return false;
}

bool Probe::IsInternal() const {
  for (const SignalStruct* signal : this->GetSignals()) {
    if (signal->NumberOfInputs) {
      return true;
    }
  }
  return false;
}

void Probe::SetEnabler(const Enabler& enabler) { 
  enabler_ = &enabler; 
}

const Enabler* Probe::GetEnabler() const {
  return enabler_;
}

uint64_t Probe::GetBitslicedValue(uint64_t signal_idx, uint64_t step_idx) const {
  return (*values_[signal_idx])[step_idx];
}

uint64_t Probe::GetBitslicedPropValue(uint64_t step_idx) const { 
  return enabler_->GetPropagationValue(step_idx); 
}

void Probe::SetBitslicedValues(const std::vector<std::unique_ptr<uint64_t[]>*>& values) {
  values_= values;
}

UniqueProbe::UniqueProbe(const std::vector<const SignalStruct*>& signals,
  uint64_t cycle, const std::vector<uint64_t>& probing_set_indices)
    : Target(signals, cycle), probing_set_indices_(probing_set_indices) {}

const std::vector<uint64_t>& UniqueProbe::GetProbingSetIndices() const {
  assert(std::is_sorted(probing_set_indices_.begin(), probing_set_indices_.end()) &&
    "Error in Probe::GetProbingSetIndices(): Probing set indices not sorted!");
  return probing_set_indices_;
}

Fault::Fault(const std::vector<const SignalStruct*>& signals, uint64_t cycle, double pr, FaultType type)
    : Target(signals, cycle), probability_(pr), type_(type) {}

double Fault::GetProbability() const { 
	return this->probability_; 
}

FaultType Fault::GetType() const { 
	return this->type_; 
}

bool Fault::IsFaulty(const std::vector<const SignalStruct*>& signals, uint64_t cycle) const {
  return (signals == this->GetSignals()) && (cycle == this->GetCycle());
}

StuckAtZeroFault::StuckAtZeroFault(const std::vector<const SignalStruct*>& signals, uint64_t cycle, double pr)
  : Fault(signals, cycle, pr, FaultType::stuck_at_0) {}

uint64_t StuckAtZeroFault::Eval([[maybe_unused]] uint64_t value) const {
  return 0;
}

StuckAtOneFault::StuckAtOneFault(const std::vector<const SignalStruct*>& signals, uint64_t cycle, double pr)
  : Fault(signals, cycle, pr, FaultType::stuck_at_1) {}

uint64_t StuckAtOneFault::Eval([[maybe_unused]] uint64_t value) const {
  return 0xfffffffffffffffful;
}

ToggleFault::ToggleFault(const std::vector<const SignalStruct*>& signals, uint64_t cycle, double pr)
  : Fault(signals, cycle, pr, FaultType::toggle) {}

uint64_t ToggleFault::Eval([[maybe_unused]] uint64_t value) const {
  return ~value;
}