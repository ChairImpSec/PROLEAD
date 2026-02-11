#pragma once

#include "Hardware/Enabler.hpp"

class Target {
  public: 
    Target(const std::vector<const SignalStruct*>& signals, uint64_t cycle);

    const std::vector<const SignalStruct*>& GetSignals() const;
    uint64_t GetCycle() const;

    bool operator<(const Target& other) const;
    bool operator==(const Target& other) const;
    bool operator!=(const Target& other) const;
    std::string Print(clk_edge_t edge, bool with_cycle) const;  

  private:
    std::vector<const SignalStruct*> signals_; 
    uint64_t cycle_;
};

class Probe : public Target {
  public:
    Probe(const std::vector<const SignalStruct*>& signals, uint64_t cycle);
    
    bool IsPlaced(const CircuitStruct& circuit) const;
    bool IsInternal() const;
    bool DoesExtend(const CircuitStruct& circuit) const;
    const std::vector<const Probe*>& GetGlitchExtensions() const;
    const std::vector<const Probe*>& GetTransitionExtensions() const;
    const std::vector<const Probe*>& GetCouplingExtensions() const;

    void Extend(const CircuitStruct& circuit, const std::map<Probe, const Probe*>& probe_map, const Settings& settings);
    const Enabler* GetEnabler() const;
    void SetEnabler(const Enabler& enabler);
    uint64_t GetBitslicedValue(uint64_t signal_idx, uint64_t step_idx) const;
    void SetBitslicedValues(const std::vector<std::unique_ptr<uint64_t[]>*>& values);
    uint64_t GetBitslicedPropValue(uint64_t step_idx) const;

  private:
    std::vector<std::unique_ptr<uint64_t[]>*> values_;
    std::vector<const Probe*> glitch_extensions_;
    std::vector<const Probe*> transition_extensions_;
    std::vector<const Probe*> coupling_extensions_;
    Enabler const* enabler_ = nullptr;
};

class UniqueProbe : public Target {
 public:
  UniqueProbe(const std::vector<const SignalStruct*>& signals, uint64_t cycle,
              const std::vector<uint64_t>& probing_set_indices);

  const std::vector<uint64_t>& GetProbingSetIndices() const;

 private:
  std::vector<uint64_t> probing_set_indices_;
};

class Fault : public Target {
  public:
    Fault(const std::vector<const SignalStruct*>& signals, uint64_t cycle, double pr, FaultType type);
    double GetProbability() const;
    FaultType GetType() const;
    bool IsFaulty(const std::vector<const SignalStruct*>& signals, uint64_t cycle) const;
    virtual uint64_t Eval([[maybe_unused]] uint64_t value) const = 0;
    
  private:
    double probability_;
    FaultType type_;
};

class StuckAtZeroFault : public Fault {
public:
  StuckAtZeroFault(const std::vector<const SignalStruct*>& signals, uint64_t cycle, double pr);
  virtual uint64_t Eval([[maybe_unused]] uint64_t value) const override;
};

class StuckAtOneFault : public Fault {
public:
  StuckAtOneFault(const std::vector<const SignalStruct*>& signals, uint64_t cycle, double pr);
  virtual uint64_t Eval([[maybe_unused]] uint64_t value) const override;
};

class ToggleFault : public Fault {
public:
  ToggleFault(const std::vector<const SignalStruct*>& signals, uint64_t cycle, double pr);
  virtual uint64_t Eval([[maybe_unused]] uint64_t value) const override;
};