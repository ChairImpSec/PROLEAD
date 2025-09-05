/**
 * @file ProbingSets.hpp
 * @brief Declaration of the ProbingSet class.
 *
 * @version 0.0.3
 * @date 2025-08-08
 *
 * @author Nicolai Müller
 */
#pragma once

#include <algorithm>
#include <execution>
#include <memory>
#include <queue>
#include <unordered_set>

#include "Hardware/Simulate.hpp"
#include "Util/Settings.hpp"
#include "Util/Util.hpp"

namespace Hardware {
class ProbingSet {
 public:
  ContingencyTable<TableBucketVector> contingency_table_;

  ProbingSet(const CircuitStruct& circuit, const Settings& settings, const std::vector<const Probe*>& probes);

  bool operator<(const ProbingSet& other) const;
  bool operator==(const ProbingSet& other) const;
  bool operator!=(const ProbingSet& other) const;

  const std::vector<const Probe*>& GetProbes() const;
  uint64_t GetSizeOfKeyInBits() const;

  const Probe* GetFirstExtension() const;
  const Probe* GetLastExtension() const;
  const Probe* GetExtension(uint64_t idx) const;
  const std::vector<const Probe*>& GetExtensions() const;
  uint64_t GetNumberOfExtensions() const;

  void MarkAsRemovable();
  bool IsRemovable() const;
  bool Includes(const ProbingSet& other) const;

  void Initialize(bool is_in_compact_mode, uint64_t number_of_groups);

  double GetGValue() const;
  void ComputeGTest(uint64_t number_of_groups, uint64_t number_of_simulations,
                    std::vector<double>& group_simulation_ratio);


  uint64_t GetNumberOfEntries() const;

  void CompactRelaxedTableUpdate(const Settings& settings, const Simulation& simulation);
  void NormalRobustTableUpdate(const Settings& settings, const Simulation& simulation);
  void NormalRelaxedTableUpdate(const Settings& settings, const Simulation& simulation);
  void NormalRobustTableUpdateWithAllSimulations(const Settings& settings, const Simulation& simulation);


  std::string PrintProbes(const Settings& settings) const;

  void DeconstructTable();
  void Deconstruct();

  uint64_t GetHighestClockCycle() const;
  uint64_t GetSizeOfKeyInBytes();
  void IncrementSpecificCounter(uint64_t key_index, uint64_t group_index);

  bool IsSampleSizeSufficient(uint64_t number_of_samples, const Settings& settings) const;

  private:
    uint64_t number_of_enablers_;
    uint64_t number_of_extensions_; 
    std::vector<const Probe*> probes_;
    std::vector<const Probe*> extensions_;
    std::vector<Simulator> simulators_;

    void Extend(const CircuitStruct& circuit);
    void SetSimulators(const Settings& settings);

    bool should_be_removed_;
};

}  // namespace Hardware
